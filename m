Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 268F8CD98EE
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1266B0088; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E87356B0092; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29BD6B0096; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A18626B0088
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:27:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 340821C4353
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:47 +0000 (UTC)
X-FDA: 84888726174.09.C041243
Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	by imf14.hostedemail.com (Postfix) with ESMTP id 81C06100002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:44 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=afN7qhkU;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781684865;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+SOpAvEzrdC8piDmDvhlvjnol3WJEjZsC7+vuJpgc1k=;
	b=bBhVS29DFALHDhJfOGyhRASHYu0KQaW/o/n9wETZQJeibp/S3wknWSO0a7OIt7ezdqEi9O
	fX8kFaBatplsef7jRULa8pvGrhDqtejO/IKbUrqCBt2oe6i/2dNJbZIgFrCKnmhfwchHNQ
	RgQcE2HFxUP3/6NhcjhrkEL3ZQmraNo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=afN7qhkU;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.225 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781684865;
	b=y0xJ+LssVp8rEXvWUwbUk9OLi02TFAeckmTFduBrLe2T6H3bzUwa3AXA1aNKllElxhkfE+
	9iXO6bnJbpQu6a3SMxGbyppywL3W3R2cGfGQYxK7EcgQ1+TnuyrXPcuo0RwU07GWsmu9zj
	UCMz3s5EglJpxzQv1VfXE9fZA4Il3dk=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=+SOpAvEzrdC8piDmDvhlvjnol3WJEjZsC7+vuJpgc1k=;
	b=afN7qhkUEfcECRpY1JyKQppjKZXJDDUuocPPkd6kbAtDrxmp6HrSNDsIciACRfTddfqDihEg5
	lxubOJlLCuMwSb+4s+0ATEfTcApm/8nZ7Na51f/ZZhH1YJd8SSQSKNVVPFzrPIvGZD4oBznUZJY
	zPnbpywr7uXPY/dVpLC2Gao=
Received: from mail.maildlp.com (unknown [172.19.163.214])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4ggGxD1Rrcz1K96G;
	Wed, 17 Jun 2026 16:19:44 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 682F640561;
	Wed, 17 Jun 2026 16:27:41 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 17 Jun 2026 16:27:40 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, "Liam R.
 Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Vlastimil
 Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 3/4] mm: mlock: use walk_page_range_vma() in mlock_vma_pages_range()
Date: Wed, 17 Jun 2026 16:26:21 +0800
Message-ID: <20260617082622.3397584-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
References: <20260617082622.3397584-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 81C06100002
X-Stat-Signature: 69c1migs6xfenmjsspucu3k4gtbe485e
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781684864-857699
X-HE-Meta: U2FsdGVkX1/peqd7xM2GErFRMJzqS9YbWTPc0ztsQUlpdlTuSpSBjokrJDAxuYMGbKlGkSdTN37Ya+qUEoBGuD44uz0gGjRuXx2jhf+ao0kLjK6dBGb+oAO1IBDSNTHFliJM9pbMMrWO0/aE/9ceG3LbeVs6IWfO6oPPSSQ/I53bpto5tI/236vv7goA0T73ej4kcB9bz8vg+9aA0g30Qa1DSJUl4um3fOWXDfCUwTR9YwkLKV9El63O26LRmAcMolCRksbpfCVKtXNzvN/POx+ylGLJnnWjuo2GZxjnUDUovfdh+094Evh0lvAkCW4dhxScym8q/PovV9SjSSSJYDxdVk6Xl+SBDAYVFX/OJHOG3W7bWBII7RAZ9VKNxEqbUu/avKM2/EZzUB0SCAkf6NVwAaQTKve0mzxoG/OQVUfsXxYVxg/LPKIE3uxI9lNcCikXm9UUZCM/H4+G6/Oc54wfAYFBHNNsCRc0Bbhhl2xY4zaUnHqNExhxv8hfApDpB7SkSRE8iQNttBHWBToEP9Wo8EsCpey8zhdEtmh39v/pe2O41UrkZvdC1XEui8o6RJne+a3y5XfqoFm7UJIMnn3zIKcd10jEM14KOOEq7g5o1/Ty15wc5TPNSMVinEAeCRZxL4RQtUa2yGyC0R/gyaK78Fo51gTZ+c67zNTRzObn9Im4nP04xKS5pCqne4jzIqywba+22nsI/yRycUR4pHr5R7iml1h7tBTHKlV8riNh/Kw3kSBQyqRdMIaqXXOWPMuXDHHmLoO6AdLcNfDY0ZPEp0sGk6ox0nSb6/XpGbXIG7lhgX2Y1iNQlQv2HgXDh/iqyifEzSGJSX5MZTVuRMEtTf89DO3kHHUzo4tLUa/2tgcAvT0ENkiRNupApT1by41xbtswErM3CS5ZdMIlq1KYUEgwuQU5ZIyOKvtG7vwcrFdZyx8Wc5qzTmc/CjayH4WBR7rXAQvVUySsJzr
 0+rw/N8M
 NaOHHnhckFqJPSuFn5XwxG1il3mcyJa3jD9V9Fir+4eyeWcF6J/jL+ZVXrNXzzv+94XpSBgPgSj9+a5iR3zkbaMsc1bteVv6KukVjRfRX8LPYD17j4orFUDAgb62Fcv340APhuA5xkeWWbe9pmRJz+qd0zUB2jriqyOBOCLdvqnrh4330QLrU0/NEIeacFNP5hihj8B8liNlPrDIUOr4FhnhRSdaZaJg/og/Fg5p/PCg+48iXyrbQ2wut6WiTNZV+dwbSALEDCQD19WKDsTA6ljQSG4DM4oiyugHVV2WQ1cERsoWDXJmKA9AYU3aaszAQKjgO6dBU2M+wUrkPHXtVmrveiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The mlock_vma_pages_range() uses walk_page_range() to walk the
page table. Fortunately, the caller always passes start/end that
falls within a single VMA, apply_vma_lock_flags() iterates per-VMA,
and apply_mlockall_flags() passes the whole VMA.

Since there is no .test_walk in mlock_walk_ops and VM_PFNMAP has
been filtered by vma_supports_mlock(), it's safely replace
walk_page_range() with walk_page_range_vma() to eliminates an
unnecessary find_vma() lookup.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/mlock.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mlock.c b/mm/mlock.c
index 8c227fefa2df..97e49038d8d3 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -446,7 +446,7 @@ static void mlock_vma_pages_range(struct vm_area_struct *vma,
 	vma_flags_reset_once(vma, new_vma_flags);
 
 	lru_add_drain();
-	walk_page_range(vma->vm_mm, start, end, &mlock_walk_ops, NULL);
+	walk_page_range_vma(vma, start, end, &mlock_walk_ops, NULL);
 	lru_add_drain();
 
 	if (vma_flags_test(new_vma_flags, VMA_IO_BIT)) {
-- 
2.27.0


