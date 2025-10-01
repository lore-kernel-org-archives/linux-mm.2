Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1A39CAC5BB
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:30:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3B388E0006; Wed,  1 Oct 2025 10:30:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D13408E0002; Wed,  1 Oct 2025 10:30:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4FCA8E0006; Wed,  1 Oct 2025 10:30:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B65868E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:30:16 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4276611B1E5
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:30:16 +0000 (UTC)
X-FDA: 83949780432.24.3BFE3C2
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 8C04E1A0004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:30:14 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JJYIo9Mj;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759329014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=kZ6hUjEVtgffLoT6sHpXj4auc03i3/X6N3IwwJFumjg=;
	b=eKzppeKe8GihHm+KPjcFnCcAF8ywhD77bkeLbpD4GFFJ+a+ALalWNoCkzQowuKT4AZoxFt
	7HaLF28hfQnVN3JpEpwQ6VNsUc82r1UdA+OL+XVeCsUe6hYtoLXI37nI6/NooItHHHhsI9
	Tlcq1jjHdR/KpcMeUDw6Ivr2Kn8qSeg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=JJYIo9Mj;
	spf=pass (imf19.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759329014; a=rsa-sha256;
	cv=none;
	b=ZOjDWRKvGGHKSfiUzCVg8q9Gj+DZ72mr7CbgbqxVVgOttejdFU4+NsSxTKaju1EnN0+y2D
	Qp3K19kKLXaXvqsnh4zHuml8gW8KEgZlvc81yVin8emGiq7YdhwwWS/mrPwKS60uSOhHEI
	vxqbQa0V2xw42z6FIC/QOUO+EovkjHw=
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-b3727611c1bso1378708266b.1
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 07:30:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759329013; x=1759933813; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kZ6hUjEVtgffLoT6sHpXj4auc03i3/X6N3IwwJFumjg=;
        b=JJYIo9MjH0F0lnormqNVRDJoaQYsAQRJaRa3473EeoB1iWqNeALR+xu6+xJ4ttzmFr
         HAtp3eflINtBV4VqqehYaCkYgejfyExroFqGJGAQN+NDm1ZCo3DgU6bE7P7lw8epMzeA
         tTgBeWXKMmQVolRGBeDHnZrDvpG8YVO+Q21rdOr5Db1ZCo9qowNOoiyGQ4yLgWc4yu9J
         FSx/8zUnJr9tipcLhkuHJx1xQNhveGITs8I6RKuGv3odJbNyNu9yj9Eip1SAPhDPDDLn
         1DGIvSQRZtslpQvigwIh3HD+/Fh/vjcVCAUsbiTPBzf5thklYqKkkp/JtB60T3V1nHRm
         V39w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759329013; x=1759933813;
        h=message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kZ6hUjEVtgffLoT6sHpXj4auc03i3/X6N3IwwJFumjg=;
        b=FvRLzK0VmICeMnphG8MxP2C1BLItV4M0gO553f0SWhk+qS6VUiPeLXxRvYszSkxVLH
         h1GV8wvGbQBNXz6N+jWxyDM1+gDLV/T/kIVioxuRQNMfSw02o8MKdAaBfdVPyTHceWle
         HsTUbRQgzQS1tXJbfqxdsYT/7k+5F1cDlaHY7JuFOsL0g1sunxd1t/QKmHdvYGkBIg2U
         0brK4Tsf7IC3Ja7i+/XNgdlMtId4ig9HUOc781hGieB/LBlUg3ILjJlzShaT/HC9245f
         aUPMqD42gC9RZ7UYvyRsa82oWyezGuHc0QKX169Z0Yp0aZQakd77VEtZdjC8T/sGRV46
         YboQ==
X-Gm-Message-State: AOJu0Yzjz91FskK0XAN2GQWZdZXEZI1kyacG6M+J39c1FNyyuuHWGXcO
	DLj3J8k1VTwFbcrmYrNm02fPYxXHcS3CxhQoP0vURX5HMdD4T7/jLQAW
X-Gm-Gg: ASbGncsXblGhLOjRYkK3M9bzgvYz4Sf7/vi+U9u+8immh/V41J8F9tqqyRXCr7/DoN1
	ynzTUOKo/nL0/mULyPjKe2niw0mqKAx7OxXZcfTzRJEw9AGe6TZ+KDSmmvFBZFWn0L8TxKVYvkn
	tajUEoBD3tPyBQxEZVZMZOzqEnQFtD/QGqzkSq25NgITcbMKvJ6xQvgXqmPahWE8kNWDJkHgeEt
	lLUEHLwMt1/kmnhfxBCCQ+bva+ohrfmpHBu4+WLQJl2gMUK5gXwgRsIkn+atpMwtrhgw5Bf3DUZ
	OfNmwpXRWA6fffUR/QmJEFco7YwEnL7ajr6Tno6ybVrh+hcExzkApE8ixtdGMKHKcHOItcuZppx
	6XDfTxYuZWLH5VmDbjRvcSRK25lIxjSQQkOi0Wo6am7tOT1oQpA==
X-Google-Smtp-Source: AGHT+IHT0EhfF+z5rcV66BG57UWP0Tiz5LYSgQFY3drz9SAWhvBzqURHegC0i09wHhxbDxTptnH63g==
X-Received: by 2002:a17:907:1c95:b0:b3c:31c2:b57d with SMTP id a640c23a62f3a-b46e99531a7mr471790166b.55.1759329012729;
        Wed, 01 Oct 2025 07:30:12 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b3f3b7eb5ffsm630757166b.90.2025.10.01.07.30.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 01 Oct 2025 07:30:12 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [PATCH] mm/huge_memory: add pmd folio to ds_queue in do_huge_zero_wp_pmd()
Date: Wed,  1 Oct 2025 14:28:23 +0000
Message-Id: <20251001142823.4050-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Queue-Id: 8C04E1A0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 5wsmqggm4go9fauxstxnyxyb35j5oatc
X-HE-Tag: 1759329014-285710
X-HE-Meta: U2FsdGVkX183mL92NCM4APFHh3lIVI+y0hr7VA+WsBGCh85Ak911mBhvl+1/ChDeP7SX68ityGSJMGcYM/sIH3oxbd6aKI73RdNpgH9j+/9AP1bNXuqUA6maWxl5aNRjHNwBgYPCfpaBMZKpD7Y9mrQadlmYzdVCF7bbYTgaavFZU+8/XFzrE9GMKQvuxGolse3feu9iiyV2+kOQVj9hj1y8aXrlRiEbslkFfp3XWx/0aTO3XCGv+oDuVppv0BJEAqb29eJwFUH9QEzMPMP3NHS2kYuBZoST8TBVQOTq90dHRHWoXQW71y3eaEMpEYBcxsdB6HWgvUIhDl8ZdO1NHk4f5bxUlyBJowMs6JKzjzt+yEn2vZxkLkvnU7lEYRjr6YkG0Wn8qu6cz6ugb+6Ck+4SpI7Pq1Qz8IUA4fYkxaaSUdSErejhGVAtTL51WOWvvOdvIEDpCwRC2kD9WsXhwkt8hzrt6yELThTL4o3OSfHAcThojXmCVWR9dasATP3TSQxx3qhj+n0ntqMm4op6IADWaecK4tcoSfc2zDEntNCGnvV01PFin6OlF3gY2nBK2fOFDosLI2TaQtEK+brgzbUQcfIQYRfcyo9um6IuH+uA1Ob49QKy56OZZ1NE0adxg164NS9eAosuGixlrbfjlskkrU3aLH/VH2hsbMgv8BksfwYe4lczLcIO7l0RBGLTmfsgx5jQRQF7/LYDkbfp1jYPQ+y6RL/xDbuBXk7zTF2b/oX1sbSZunvVRQ8r5JhNPjujs0iZK84+H7iWUrqCmPo+McfZ7Mp1h0mccL0IFf+eW8YZOvhI4eSt1WzvuSZyhe/u3dl7duTgBournhI+7mT9rIhmZUvRBIGrGEQ1D58JZNxgHeTxU64IFBZBYmOeFPIZxfvUrurUYq3bIth2cmYbE1K9jPGyxY1Nr6+Z568Xs1VBcHt6UGvLtvi5Qh3Igo5cF/YalimUipcNVgA
 0d6f63Je
 XQs8uec6uDqys1GeLCQ6PQj0tAueHu9hX28GYLzKWQy4QoP647W2i4XkpiRjdZ7a5s92kN0+qHUQUKSkpQqfgYQQ9yZsWTw3M0geMB/s5U0loHUWljhzc+wRY9MaeEpT1Ee5XZ3YVQCsvraM3iWV/xe361sHs6EpMjzWFhdBztBjGCYY2J95hhOau7xcknM159jEiLyDq7Tni3V9KVwMF6P6lvk6sAZ0EFKyYEkXRqpPgHjUYCL4Myf/jZbr8yhezkwEobIgtGwtmLRR5QHeB18TPyQMCYz5HpbH67Lud52NjOk7EB0xAIZKzD44zLwEcmd7yhebMgh4NSF1GfBgaaTJbcoAxqgx3ayZLdP6m2P+wAbJb6ksaxFovJC65m3GW1d+u2AZQX73LkATa22Gpo+Vg8db9lt453X+FTT80/0vemmF/yqjeyQZRBMfJ2VH11ktPgHv4FZ5hht8FgEtWtJXMQbpSdK2D5xPW16MESlEOHGsnJfHrjPgpdyLLxpTDQaZQG2iUNhW347HByfoT2FSegNzZz47Z7Pn2lJyS247fiHA6+ke2LNzId44nwXx73c5s+Cd6qHD2879n1gddwkUmzEGNL/YJaUiyANy0oE9S0IuFQ6i7nztV+jOVY4CMpdFhyRxt+OoEZinxCRTku7/xsA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We add pmd folio into ds_queue on the first page fault in
__do_huge_pmd_anonymous_page(), so that we can split it in case of
memory pressure. This should be the same for a pmd folio during wp
page fault.

Add it as expected.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Dev Jain <dev.jain@arm.com>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1b81680b4225..963cba933cb6 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1878,6 +1878,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
 		goto release;
 	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
 	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
+	deferred_split_folio(folio, false);
 	goto unlock;
 release:
 	folio_put(folio);
-- 
2.34.1


