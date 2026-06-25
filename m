Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63B0CCDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 01:47:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4553C6B0095; Wed, 24 Jun 2026 21:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C346B0096; Wed, 24 Jun 2026 21:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31AE56B0098; Wed, 24 Jun 2026 21:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 080B56B0095
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 21:47:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7ADFF4054B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:47:28 +0000 (UTC)
X-FDA: 84916747776.26.ADFF56D
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf02.hostedemail.com (Postfix) with ESMTP id CF58A8000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 01:47:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMw2Cr55;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782352046;
	b=VkU03HwUV7Ughf7nf6XP797cC2qB21plAwy+BAdEbyUQ2aySW9t+fVk3sr+xebYb/esTwU
	Goj8AzpIfX7mTQ56qYaSi1sTgVRF4e04WARfUXWNqDpNO9CVqG64cjl2q/LU36go7nOn1V
	O1SdnUFOw3G2Ez4zXiO/zDexOZhUOGw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782352046;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lqPDLB1YoDx0Y1fsr1fIGOh3XfpoSAyKKLhHHE2uK4g=;
	b=ekua4paN0bPZtb5CRcoQhO5eVnLVfneh/jUqHA/1pw66PUNnc4FdvSzd0nyM2bLQA29jG2
	CW2pKubN3SfgnowvyFwFc6nUxQFt3J27E0bXrb+SzyCDds/NfEj/1MrdeKN/68D5RDTDbb
	Ci0nVzC3wMU87OhuOqd9dZvQB99/cQs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMw2Cr55;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782352045;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lqPDLB1YoDx0Y1fsr1fIGOh3XfpoSAyKKLhHHE2uK4g=;
	b=iMw2Cr55VC6ytMBY4Y3rPARgmBWgvBGrBxcTe7KYt9y/IA3JIlyh9GbjLIrqGHVJT4/eqr
	ziiNcOExSag80d6IHrs615JfpgQMgJWJvme7r//7tSXjbGZyeLRnc/7SdeJUOJx9zEnHST
	WP9pI3cs8gD6qzTruSesWmik/P1jJRg=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] mm/page_owner: use memcg_data snapshot instead of PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Date: Thu, 25 Jun 2026 09:47:05 +0800
Message-ID: <20260625014708.87386-3-ye.liu@linux.dev>
In-Reply-To: <20260625014708.87386-1-ye.liu@linux.dev>
References: <20260625014708.87386-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: an3of4ypf9hh6tm47fqu4nqjimabiq4z
X-Rspamd-Queue-Id: CF58A8000B
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782352046-276390
X-HE-Meta: U2FsdGVkX19qas4Jozf/Ce3yt+EU7zQBkuXMUNah0AwpNg5ZpQlC1btHuXOzD7MG3R6sgdHCafvFFRGhtAubnvDrAXFdanyu+Wsd2wZB5ecbhvhVcDALmDXlyfHqeAtfngtVntz/294JEBEQmua5a8ANz0iVcvd49hPMQneFB65VGTc6UbW8LHiYpZQAUciVSdLqM3oJ3clkAT7JmMzpRnZZd6PKyg2jQxe/6fZ1NYwcKy/IXQIj2QlAWyiYCwStYb6jZFRoSLLegOdLR932zRyydLEIQZy+jLhX6EwfK6Kh0cck7YTqWM/qnlbaU3r+wnTKVgJQA9i+qc4ANQqC6saCfUnVAmJuuv7cYDgX3yD9IJDikCWt6MLVIKHKLksvPNd8tEe3q10PgJ3X97gO/PIawakrA4m9W0YiE/LwBjnS/LMA3J/6N5LCuj6v9gCssWs/J96yKH2t8Z+MrR0ghTvRBGhyMlC6IAeVpICeKdPvbzCpmn5ouadc1k8+LdZOzb4xCPOZJaf1r1cUtt3v1lbSaHi++aEaJauBntPTXVF/4p9NYNfi56oKfPxIsW9Cnl1jrxEyc/FwChVlPGq2GmeAbdbDScZbJL/a74CowqAmMCHpZBwEY+a+piYCmjA3s8u/nDw3JFLjFIScALLkxjJMrYlQVg5A/pgSgn9BpRcJDnrI6rWgIZ/YZM9T4FhqhMFTdE9wg7yhqp2NNf82bvx/Lm+ZO+Za8n/VvEvSwcciXPPz/TI/WoadcsusdGpCCj4rsESvW9r7OjuDNbmtei5vxB7Yv5CBaWhUkCnIh/mZN8Fp0/tLUF9R/v0asUhPu6gNINgzZEp+7XGI+IdCEMrvc3ZO/JkUA1eru5dny/B20Aaic2af9RcRmyre/XjHDfQMymFQkJywmTbBh9db358StnYKOBwDvllqHKFvmgnPluVYmebhhEtj3dQY+8/01o2VJuX7oEPOpqC6HE7
 sTbBb5F5
 XbE0LN0pJidx/Xw9bPAtysvrtbH5ySWizkBMWf+ssTN8fT0oQeCmhfNkxXtuXa+iXMXfX9s8Lg8rTX5QpN8hwoBG64XIIMdOwNd3Cd+BD9KMoiUXStGBbzFZem3JwayBYn68YIdV2eaKK3JKP6igwZdmDpoYgQwxRISPTudLCauA16banEbimCy1TWLJCQJV6dLLLTdQexwT+/0ukPvjSOspQcdaihGIBVHEPYOAFeynuuq003fsZYaFdUrf+98/6cQcM21TowNxCBc+i44xuLETlxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

print_page_owner_memcg() takes a snapshot of page->memcg_data via
READ_ONCE at the top of the function and guards against tail pages
and NULL memcg_data.  However, at the end it calls PageMemcgKmem(page)
which internally calls folio_memcg_kmem() — and that function re-reads
folio->memcg_data and page->compound_head locklessly, wrapping both
in VM_BUG_ON assertions:

    VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
    VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);

If the page is concurrently freed and reallocated as a THP tail page
or a slab page between the initial guards and this final call, the
VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
causing a kernel panic.

Fix by reusing the memcg_data snapshot already taken at function entry
instead of calling PageMemcgKmem(), which is semantically equivalent:
PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM.
This avoids both the TOCTOU window and the assertions entirely.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
---
 mm/page_owner.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 5c403bce35ce..b3252ebc0307 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -568,7 +568,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 	cgroup_name(memcg->css.cgroup, name, sizeof(name));
 	ret += scnprintf(kbuf + ret, count - ret,
 			"Charged %sto %smemcg %s\n",
-			PageMemcgKmem(page) ? "(via objcg) " : "",
+			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
 			online ? "" : "offline ",
 			name);
 out_unlock:
-- 
2.43.0


