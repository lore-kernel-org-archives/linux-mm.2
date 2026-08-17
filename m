Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99B6BC5DF74
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 22:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FD706B03DF; Mon, 17 Aug 2026 18:08:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 486E96B0132; Mon, 17 Aug 2026 18:08:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34F2B6B0870; Mon, 17 Aug 2026 18:08:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A3A9A6B0132
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 18:08:22 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 37EBA807D6
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:22 +0000 (UTC)
X-FDA: 85112150844.18.C7FDBB6
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6A2ECA0006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 22:08:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JnwcrFtC;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787004500;
	b=JOQ6ioNNF7zID02gyFZK0DXu2G0FvozfmS6mhzLs4u2o2InG3qYgDVQEfsYCmnoXjr7vNd
	fFBxVxAQYYwAumOSk/H99ZXbDVA6yrf8/3ci5Os5JwVmEYquuha92Vj7+yhXrh+tUtaZdK
	2uAfTdXej48bfjRHi1BIX+Zk9WGIsUc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=JnwcrFtC;
	spf=pass (imf25.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787004500;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYwESWun0fa6liMiTXLOYEKQD6iVsL/nuJsHb68bQDQ=;
	b=3CdwzIMAl5o8D1X0uuB+TbTz5ZF6OnELs7Ym9AO645RC8XJbB4m6fGovLJsJ0M1qNizlaS
	qVzzR+1ATMt2rwp4N8D/El71bIRBhLUqM7UQ6Bv9m2Xdw98uMbw7qRKQ6OfdExjG1yInWg
	Q6HlFood/b8Lx22DLW2Pv4febQrotQg=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e512a9a6bso181063585a.2
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 15:08:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1787004499; x=1787609299; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PYwESWun0fa6liMiTXLOYEKQD6iVsL/nuJsHb68bQDQ=;
        b=JnwcrFtCwZ2EhofzH1krjMDeWEAhU/Jb4C/Q+e5SdsugC/kte3zTjQiLaxPn2XW2vz
         HWgCZphk69+nd62qNiaR+ir/xVpnTz3n3WRJOH6f2cFqI/HfGQDt8R0mN8Au32ebHDfb
         E9/CyrE11ihsKWslhG7y3YLjCYSXIYtulhRiZsVwiARsAU3I0vZRyLL4wzg0wakjSFd9
         beodmZH7HEvR7PZl+aYxe3gyCYZTx7t6LD/7ZjRaiiHVW1a8TbtKWU9H+oEPdruNM71Z
         wz8DJLnUh83fIXwf8KZnKd16qYrzp9/n2a6koM2s0L/dW1m18tYfEZDy+0Oec7R5xJeV
         p97A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787004499; x=1787609299;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PYwESWun0fa6liMiTXLOYEKQD6iVsL/nuJsHb68bQDQ=;
        b=tAK7qQHloFsPWE80MIbVtwmht6htdNhIyXtdX7YsPGSddhHj+bn3ZFTtvzNp0c3iXm
         lps0yaBVFHfhfnILEmNWJ6GT1pQWTWIU9HqpFOqhFLlcKc7Bp8Zj3xw+IfCGj6TcVaxS
         vovbsk4lpNfBYZmpS0NE00Ol+HLh28Xd1Jt/hpY02ndE6H60f6gZlVjdtr8y3lsIBRYP
         Ig7tftZm8NX49vDHHBj8kB3PktgkMsfJaJ1+6tuy/5za3smyg5j3WnGQslF0mI2z4/c7
         sYaVZr0C3vxeWMygNjkPlneeZsdAKgxnYSRDPvpj45D1M34f79K4b1K+eAJXiLZaNVBI
         A/pQ==
X-Gm-Message-State: AOJu0YwzIS8d0ERHAgi9lXfkf/y14ExzK6SNHV53yXGdGIbPlN1hqiFk
	wz/h9UNZxlIgBU2Zx5Li6fUSaWlnnGxZSQTAgZwZEG6blq9YJPhH8HdrcLHAJROx3Z3VE+dbOPF
	s4Sp3Qjc=
X-Gm-Gg: AR+sD13jZHjVrO65+uTnahgeaFFi+vxDo/n4mJ9pwQp1EDnLl5rnYMBSDguQQNHbyTM
	icDQ/n6r7cPa/p3lmqds9pk97iiq29awqf5Vg5nfCofEu9GBeGLArDwhJbaFRiCch2EUjOjviwq
	AxnUjYMVV4gSmnQtkzmU908sIqVfGiA/KW2LGAZySRi/c60ohKfxEWJZ4A05QV3Lk4uXI5qrDNt
	cw242kBz6uXpjfUbphv5ul5sHLcyKDTA24hxF0D9W13peecptju9mhx1GRC4Er7sJvlYnQ3V6YT
	H7LHF9zyQy68wY5jPbhPwMM2DSRdjyP5dW4D6iGbyBn5XtTOGIDgQYXmHdmpGtlCkFzP9aNvXsj
	Tv1kLMgxp6UnLKEK9jFp0Y7Y/1Cbe2T5UlcMlHhRtLVsKrxPMNHWaJzU8zJav0WIhWpRDlCLdaJ
	Lw382hzUltHXtIeYwKV9P6Vi180dNgMaXmIt6fH2Fhtb2v2IagDhrZ5UzEDitaLiCudjamKOB3o
	PzfqhZsrz0wXeqEl9e1HKztFdHix4hU1PzpV6W5ceWitEbwkdpz2/uBT6rM
X-Received: by 2002:a05:620a:4387:b0:92e:bc28:5479 with SMTP id af79cd13be357-93704b1ac3fmr488870385a.2.1787004499566;
        Mon, 17 Aug 2026 15:08:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033ce78csm147108885a.31.2026.08.17.15.08.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 15:08:19 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	jannh@google.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	stable@vger.kernel.org
Subject: [PATCH v2 2/3] mm/madvise: skip zone device folios in cold/pageout PMD range
Date: Mon, 17 Aug 2026 18:08:09 -0400
Message-ID: <20260817220810.1175596-3-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817220810.1175596-1-gourry@gourry.net>
References: <20260817220810.1175596-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6A2ECA0006
X-Stat-Signature: j9bgu8n4osauzdbfagi8jj5fq1stbw87
X-HE-Tag: 1787004500-480298
X-HE-Meta: U2FsdGVkX1/e3lIV9H7+HmXwVFVxDZCfE3UfTNV47DowaARc3C2dErhSichmO8AQiPeeJNH3e0JjDKMvuullJ0BMOBw5ee12hFtNYfjMuAm7aNm/gnWjEi36r1GwNODNGFzksYh/giAi3swmMtnyvaWs8+VGanlagNOz5oj6h6OO7EWO3l1sS/conEKOAUoex4Bzi6xsnYBV76cAG9UcmYgRUp9DAGi/Caq/O7dSSvHgsxB3red2ijUVYGcCqTJC1x/fQjsPEEYXs70IyIk9POtADP0z1F5wciqR2AKzwoWpczitj+VaL1xwPbhAVLS0yz1JhIJsKGzaTKQhACVCPGeptldGXY1NKWn9Qe+SmSn0UBgEDHCKNmMUzBl+g0HlxjU6RlBd7d20VrTs9x+UYY6hXHCGFVfbzdZEJFwBo/PsLFOa7juNBw78n4HzusAoQJaC/DkcEQn7iLxlsE5N+U0aiHEbvdXmEP+7FRNezL/hm8wXzv4vp56ZSHyVs8Jcp0Z4bpYI/p4vsX+2Zt7rvM0ryfzvKjqX5zuQkscDkP6el739959xS6tPPuBxklp+c6fNnEv3F0y6k0yMN+69VsWp8vxkB6q8Zm+GNwjd11OLf8ZnsTlFxQroibIb28aCJx55WpD64j1FqgiFYuQ39/HGWNBSQPTUuXOIxXsrm0Tcc6M+qQNAWzc7RmlFe1tWxXDTmbp2Pdh7/u70u/xa4VHnltUEjSpXBY+BY0eEWUE6H5ER0GBYVRz/JvpbsvcYHNJtpQpv+aNJB3x2XfwAUTcdtOTRnGSUjOxysmERBaNLVuh7rIvtFuzt0Qjwa8kmG5icPRMpbAHOBiWv1Ke2pF5U835esLq16NmrVK9zs8N4+yzs1ihQLeGQ9A5mOq4bSyUam2B7cyOdF8D55hhsajhrTEwVhqbWF1BBKiOt1xvkyLkbT/V4QSXuHJOS/z1ogcZ3VAho2iQaMx9N9KC
 5odbKsaQ
 dpLqS7cvV9Ntrkrn2fljj0sI7LZV5W2zZTQ0yjoEN+/zEmvUGOoA6nP04pzY3aqYQwiTZb2MhMgdZVQzQxiDTX/SrXhMXPOSiahyWv3AQ+p2HnLTTQD2UltfjHEAsuvZ+vcjhPEamIpScQx89y30qyAUf8fVixh5gbkbOESpUdZSZmYFRq0TUMOrv7F/72JOj9OsZekaRD5802CdxTuBlhswHYolBXCYlX581eOgfHklXRQsDnJqUd9EarhMF9lS9k6B+0rSRq4ZimQmhfAj4VBkBwyBuOCdU0Y8fZqJS6LVBtS1ctytBiXl0WESmKaWZyaWIc6A1ySkkBXhqY1kvkCorsameBFkWEXtppQ9LbxtD/YCXbfRwNUpiG6n6aG+Y3T7IzUEikg2jr5I4ToTR8RSv8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

madvise_cold_or_pageout_pte_range() resolves the folio backing a PMD
via pmd_folio() and ages or reclaims it without checking for zone
device memory.

The surrounding guards do not cover every zone device case:

  - can_madv_lru_vma() excludes VM_PFNMAP and VM_HUGETLB VMAs
    (so device DAX is filtered)

  - !pmd_present() branch above rejects device-private and
    migration entries, which are non-present.

  - A present zone device PMD - e.g. a device-coherent THP - is
    not filtered by any of these, nor by pmd_folio() (unlike
    vm_normal_page_pmd(), it performs no special/pfnmap check),
    and would be aged or paged out here.

Skip ZONE_DEVICE folios explicitly during MADV_COLD/PAGEOUT.

Fixes: a30b48bf1b24 ("mm/migrate_device: implement THP migration of zone device pages")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/madvise.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/madvise.c b/mm/madvise.c
index c179938097bf0..2151bb9468594 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -396,6 +396,9 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 
 		folio = pmd_folio(orig_pmd);
 
+		if (folio_is_zone_device(folio))
+			goto huge_unlock;
+
 		/* Do not interfere with other mappings of this folio */
 		if (folio_maybe_mapped_shared(folio))
 			goto huge_unlock;
-- 
2.53.0-Meta


