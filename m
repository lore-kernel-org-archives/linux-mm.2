Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96214CD98E1
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 02:32:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 517B26B00AC; Tue, 16 Jun 2026 22:32:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A1A16B00AD; Tue, 16 Jun 2026 22:32:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 368C56B00AE; Tue, 16 Jun 2026 22:32:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0686C6B00AC
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 22:32:30 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55855A025A
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:32:30 +0000 (UTC)
X-FDA: 84887830860.14.7E418E0
Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	by imf29.hostedemail.com (Postfix) with ESMTP id 02F5B120002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 02:32:27 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EOPnEcRo;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781663548;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KWSwI0JSp8IpusvL17b7isqNuxgesNcqyUkzefJ+C/g=;
	b=8YvhslRGBFB6a9bOIahFH/QHKAeLdO7FOltsZYhC115I3o8R3vNdhZv5Xzk3VlRc1nLQBd
	6JaP40kxdxV052OV7RKLyVSH7tQ253xl1X8gNsVsoJAlK23VXu32bltD2B7YQVYChGpOZ9
	jAzRARA3GtAoaD36q/VUNXcq4TQ0AU0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=EOPnEcRo;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.171 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781663548;
	b=4E/xjuWgS0vJ3v7B/f3OhQ/K9a4TBFYnvteYgjUC4AAJ7WA9Dec61P+9z+6GufFkq2c5xc
	TIDOgyQCQ7uP2AS4W+d/ZoinTx6MMANNVwTuKg874cv9+G+0MEnlfRml1GvMpLP0EPJKzR
	0fnu3iGGyqAmrkzR5KFS1irNu9ZlSEs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781663545;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KWSwI0JSp8IpusvL17b7isqNuxgesNcqyUkzefJ+C/g=;
	b=EOPnEcRoyEvrckUiMuG+/W56AB0fjfv6Ssjj7zOAWHhVtqtmbkqSe23THUbNf4yk623rCB
	KKdaBgxBn6yPULoRDg3R5eb4fJrpdPUYPyraPTes0TevoJqpC4OX2BKnX0fcH8iJrheN1q
	4tQ8m/GCPRbWd9hOjxwAnPooOewsAx0=
From: Lance Yang <lance.yang@linux.dev>
To: richard.weiyang@gmail.com
Cc: lance.yang@linux.dev,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	riel@surriel.com,
	liam@infradead.org,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	balbirs@nvidia.com,
	ziy@nvidia.com,
	sj@kernel.org,
	linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check before return device-private pmd
Date: Wed, 17 Jun 2026 10:32:11 +0800
Message-Id: <20260617023211.80409-1-lance.yang@linux.dev>
In-Reply-To: <20260616235022.iesy2jeb2p7zof2l@master>
References: <20260616235022.iesy2jeb2p7zof2l@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 02F5B120002
X-Stat-Signature: i85sqhzw3d8dqbz54auek5b6pmcc6mnp
X-Rspam-User: 
X-HE-Tag: 1781663547-420047
X-HE-Meta: U2FsdGVkX1+Pobgc0TivFW2AXINe+NsiRHo9Jf5zl1CtRS/HYTSsKWujr4tO+xIr6DRX67D+FmwLkZZ0lRq0e/cVdzI+eu8FbMZiE8LWmVRigmnjuEMrI+tNGJb/AcfY7+HuDJa8trBFUBvkFTdgRKqUDwxkWtYImJWDwrz7N5JVTDR36Ar2IyNcNtNbzEjpZuHfBlKqGftmiAWjjqtSYy1iBRsnUj80UCHWro3oGp4D6lt6s8EQxwiM0VQigX7YiWo4hntjJcG0x8JL32JPCzubXDmLXbAkQO/efb4LOxuBmN2VcmIDjUgQvIjtc5KFMxFkvVko0ZFq/gZPOYeWAoJWbcbA7F4AUoOY9hkDM5YWYUnyWThdoB0XeHzZouPiuHeXMjW3p3pfc1HZdlnV5NSrWt7Q6cmFErIT+XNObHABrvNTwz8TeIZiYEYmhCvwBLT6bsgeAyEG3TltGHyG0Fmf4un87S+GbsMK2DxWZKvhUk95SO2aAuvAfKq1wkmbYHeBe04SMj3Enszs/luHWhrH4xZIoY6P8ts7zfQWkgFL80QR5/u9Sw4b8HHlJgvshl1y7xx/+4bFRdum6WQ4oD4V98CoOKn/vqhazBWgQarZp7y2/9S5UcNNW6wLHYc3KQhK25VQdARh9I9UMke954T9iqEiVu/5+tVW6inTW4yiLqwRLAoSRZNw7xHQJgwrqURgIQQHjpv8SS3+RQ2HJo4QYF/FldicQbD3a/b0M0ieq+lpfJQOEzifqhAUC92WQR+1jEgm3xR1fcFa+pn1FyjvExVm1Qebe7tA0sLe9VVjfbLkSn6yWzohTaFzeWtPRs8Wtdl+jP9xsisRea/ZkcW8RqXiZ5dpdV09yfGAu1bh0nDChyBCDWtNUL5SEYV3BIhHMZ/elZV84JFO+rcFigaahu4/8MvNIC0dXp7ozH+V9KwJ99ddjH2PawxjCSTAmQm2itwJCsOFdPCOaIG
 sQ32hmEH
 7AQhnbKN6zY+yxeuaFQWxTJG7tzy7UZzo32HEbT0RgyawyJ93N5q5dpxseoRUXao5GllImt8y3N/znh0Q7oNszZ78ijASEa+tiwH0GMP8+JLZoyO7c+8X6uPzoLyhPPc22M3noW1ovjr/nsZ+ztSOlNV5WYIDOHXtL9k6N15qDr4WQSwIkADfk4U/tFTDbBcBqeLTZElGKlOJRyndCMfcz3486ZgjLI2K7NcazW6aR+Pj/BV58aSmA8HTDow6shrdyDdngBInK52lIXCwNRRVu556J3ZmZxsZc/A5Sg5dVHIJlHpCB2ln9QU5SsmnBd7zFc7BIq7Qs2Zd6RI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 16, 2026 at 11:50:22PM +0000, Wei Yang wrote:
>On Tue, Jun 16, 2026 at 08:30:01PM +0800, Lance Yang wrote:
>>
>>On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>>[...]
>>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>index 2ccbabfb2cc1..21635fab209c 100644
>>>--- a/mm/page_vma_mapped.c
>>>+++ b/mm/page_vma_mapped.c
>>>@@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>> 		 */
>>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>>> 
>>>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>-			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>-			pmde = *pvmw->pmd;
>>>-			if (!pmd_present(pmde)) {
>>>-				softleaf_t entry;
>>>-
>>>-				if (!thp_migration_supported() ||
>>>-				    !(pvmw->flags & PVMW_MIGRATION))
>>>-					return not_found(pvmw);
>>>-				entry = softleaf_from_pmd(pmde);
>>>-
>>>-				if (!softleaf_is_migration(entry) ||
>>>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>-					return not_found(pvmw);
>>>-				return true;
>>>-			}
>>>-			if (likely(pmd_trans_huge(pmde))) {
>>>-				if (pvmw->flags & PVMW_MIGRATION)
>>>-					return not_found(pvmw);
>>>-				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>-					return not_found(pvmw);
>>>-				return true;
>>>-			}
>>>-			/* THP pmd was split under us: handle on pte level */
>>>-			spin_unlock(pvmw->ptl);
>>>-			pvmw->ptl = NULL;
>>>-		} else if (!pmd_present(pmde)) {
>>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>>-
>>>-			if (softleaf_is_device_private(entry)) {
>>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>-				return true;
>>>-			}
>>>+		if (pmd_present(pmde)) {
>>>+			if (!pmd_leaf(pmde))
>>>+				goto pte_table;
>>>+			if (pvmw->flags & PVMW_MIGRATION)
>>>+				return not_found(pvmw);
>>>+			if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>+				return not_found(pvmw);
>>>+		} else if (pmd_is_migration_entry(pmde)) {
>>>+			softleaf_t entry = softleaf_from_pmd(pmde);
>>>+
>>>+			if (!(pvmw->flags & PVMW_MIGRATION))
>>>+				return not_found(pvmw);
>>
>>Looked at history a bit, and I wonder if this changed something old
>>here ...
>>
>>Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
>>migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
>>including not_found() cases. So lockless PMD read was just a filter ...
>>
>>With this fix, true case gets final pmd_same() check, but this
>>not_found() case happens before taking PTL.
>>
>>So a !PVMW_MIGRATION walker could race with someone, e.g.
>>remove_migration_pmd(): we make the not_found() decision from old PMD
>>value that still says "migration", while real *pvmw->pmd may already be
>>present again. We return without ever taking PTL :)
>>
>
>Hi, Lance
>
>Thanks for take a look.
>
>I am trying to understand the scenario you mentioned. Let's say A migrate a
>pmd and B want to unmap the pmd.
>
>            A                                        B
>
>  try to migrate a pmd
>  pmd is set to migration entry
>                                           unmap the pmd ...
>  managed to finish migration
>                                           ...still see migration entry,
>                                           so skipped and unmap fail
>
>Would this be a timing case? Even B grab the PTL, it still could see migration
>entry if B visit pmd before A finish migration.
>
>Maybe I miss something, look forward your insight.

Right, seeing migration entry while migration is still ongoing is fine.

What I meant was this ordering:

  CPU 0: pmde = pmdp_get_lockless(...); /* migration */
  CPU 1: remove_migration_pmd() restores PMD to present
  CPU 0: returns not_found() from old pmde, without ever taking PTL and
         rechecking *pvmw->pmd

So issue is not seeing migration entry itself, but making final
not_found() decision from stale lockless PMD value ...

Before this patch, PMD migration case took PTL before making that
decision ...

>>Not sure about practical fallout, but should these PMD-level not_found()
>>cases also take PTL and restart if PMD changed?
>>
>
>-- 
>Wei Yang
>Help you, Help me
>

