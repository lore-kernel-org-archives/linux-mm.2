Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2C40CD98ED
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 08:18:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2CEA6B0005; Wed, 17 Jun 2026 04:18:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDEE46B0088; Wed, 17 Jun 2026 04:18:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ACCD86B008A; Wed, 17 Jun 2026 04:18:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 718C46B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 04:18:23 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4B34A0364
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:18:22 +0000 (UTC)
X-FDA: 84888702444.16.3FB83FA
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id C9D6AC0003
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:18:20 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ntD40d2V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781684300;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YhalDeiPKafuB6dh85e27yohyG4zdlphxrEzu0htw90=;
	b=Xn/erSzRCoNdbwLmf7iO4q4P2236UfExqXmZ/7E5ZOVYVrxCEFpq+FwjaVN450RewdNDNP
	J7gQBLBtOjIX31KAQ9I5EF79qH5D89NdRpV/GsfFb7nkRjjpzGVpkSzUBjo5CO8cC1079+
	p/uLrbIPcX6CKHSmJUrwEowHf5JyLQM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ntD40d2V;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781684300;
	b=FqpjKE/93GnFRANcb3ecHoYCstgUrlbvH9HWmrWDV4JFzPmSrsWTaFl9Mny2Hqz8+0oCMn
	mQOY+hOjFvTKqs6/HTKoGWRTSQ82dA9xzU8K2pRfMijUSZAmQgdSCFLo8AJgqj8CB+JEkP
	NOHSOvD9oZ+5NVilWn2Fva5PTyqqr0w=
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-bec49f7e35eso720623766b.2
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 01:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781684299; x=1782289099; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YhalDeiPKafuB6dh85e27yohyG4zdlphxrEzu0htw90=;
        b=ntD40d2V/s8IIwzBGDtQICuAHfJAe0LOx9CjsJ6EQHI+mxhd8TW2bXHXsWQsNfg3JP
         k/gn0/O/FrjFs50YLIexhrNzLdh0eIX5bkpifq9JbfdM4Fkbtq8Byu7M9kf/rWv9uxmD
         7fW9kiycW0VkY6UsKW1/2qRsaCn6h0r4Fdq0drLd92IcE3WpPf+a2uR6Z534ZfJyekUQ
         qW79OPC6sXu2Tu8Pdx4YgtG3Gx4EUaCqQEApqqIwGEIqioXuNJqKZQ3clEaeNLapiHvi
         DuBu/GPrquh6dMkeL2RTugRPvLBBTOtT0L/ULTGgAqql1bm+CqQoJ+sh5qI2NxoKH6mx
         SrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781684299; x=1782289099;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YhalDeiPKafuB6dh85e27yohyG4zdlphxrEzu0htw90=;
        b=Zj2XqONeSx2EF+qBoQXNHdrDddLBrVJVOMU0m0iEWI8KyIfkZZh9ThRDJFfCauzfl4
         IXyHQwVqbIS3PqVV9Kw7mzHWfYjeM7THJ9tXcXXYeCIZptDrz2+eTP4iXdFegtZEGqDP
         1+L15mTkd91ZasUs58LUnhn2hfCLaSTD5iO7WAm7PMaG6Ugjs2pFu232w5qnxJpo1xzg
         aWc46nT7Lw9ufQIR/hvHW8rv9A1NBI3fyCX7C+vaKlPD5RYudOcW4Zmn+PZIRHNhVU9k
         giskL2SjEWbZNsfY17SLVBR8Lej2xpPLMDTFp51ySXoMYHaoVBDt7F5mWdjcK9ZbgCIt
         8+dg==
X-Forwarded-Encrypted: i=1; AFNElJ+BhtUM9TizX/+q6h63TLFKbalFFpfSNp9aUvJqs6OaIWJjWz5ASsFSjvOheZgV41sPVagMKRQFZg==@kvack.org
X-Gm-Message-State: AOJu0YyrEdrg0xC4BAHbNclZQr6Kmbp56B1yq35hbjLwIx/3SSBjmn2m
	5NV1JWfGR5ELxOkseGj+yZeyRG+Uf4wfNJJ533UfQaXGTCUILVOOIcbG
X-Gm-Gg: Acq92OGJ3RL0zv7XPM4dwUO3tbKgBRpldTlPEZNpva0DwiS9sYk2n1DMc47la3+28cF
	KGBFhvykUgBqQYwq/APc5F3bsJJICws0K6xvYqUm5UrVLxdqLBtcgNVNyxWH281ATHfcczOkJc8
	bYGzjiwu1mJkDK1lgIvOU9Wvfc/WcpQPpivtrU5yXpCdLnXM5DvdWAryiLMGoa2O2xW8d00g8VJ
	pUToBYaNOr8zHkPtCVeu7Joc1Ccqm8MQZq6aqnh8nUjwYmYkWXsOJgTK7D0PITu4L0j/wjymnMH
	zP+KYZgmwCDW9NJYq4vBL3u6KB4Ft0bV7YHiB5RYoSYZoyJhXvr9XtO0nRGCZdBFV+dS+acGrwM
	zNrV6N+PLSy8J1a8+QnmrtxUS5l5Z5BThnyL2shyyO+uyNexzWG3JED28euWsd8AAA/VIOR1Cx2
	3VIx3Pew26T/w=
X-Received: by 2002:a17:907:9805:b0:bfe:ed06:5a16 with SMTP id a640c23a62f3a-c05a7bb59c7mr155753266b.52.1781684296405;
        Wed, 17 Jun 2026 01:18:16 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c063f9b2470sm33268266b.62.2026.06.17.01.18.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Jun 2026 01:18:15 -0700 (PDT)
Date: Wed, 17 Jun 2026 08:18:15 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: richard.weiyang@gmail.com, akpm@linux-foundation.org, david@kernel.org,
	ljs@kernel.org, riel@surriel.com, liam@infradead.org,
	vbabka@kernel.org, harry@kernel.org, jannh@google.com,
	balbirs@nvidia.com, ziy@nvidia.com, sj@kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com,
	stable@vger.kernel.org
Subject: Re: [Patch v2] mm/page_vma_mapped: revalidate and do proper check
 before return device-private pmd
Message-ID: <20260617081815.kq6g3rjtomudxca5@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260616235022.iesy2jeb2p7zof2l@master>
 <20260617023211.80409-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260617023211.80409-1-lance.yang@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C9D6AC0003
X-Stat-Signature: ro89yaacyygax6ijxfdcug1npeyhgfm9
X-HE-Tag: 1781684300-870374
X-HE-Meta: U2FsdGVkX1/iPWzcbQsfXgbJMIsRsbFvuFLJ7OJ5H9agBnNyEBjxcJg8kVLPp3eNxHUhmJDiTtD4LmGdm4tfUpuhdaN+vO517jvmwT79EyF/AjaOZK3KYtVSnrxrK0PjENUgB9ODwoQv7pasfc/rR9+NY6XWXCQGpXkxY1jB/9JwwtHprT9+4PywtXJRWCdglIwXGlrji5LIWY1aC8Plcu9myu6B8t5PoOSRDpnGsDQEkxip884JPPvypk9Q7jWXPnpPXjQjhTGWj3CrtKkI7Duq9hmfT1fQOr3ZMC2noussfLp2kg87OY3jgenSpV3BHdxWxCImpkQYix7hHxitJOJ/QBowFvHetWJJTCvLz/PKYnxvUTGVwERKHzZXJ7/OxUzTH5aSZ4kTtZ3XXj3aI9zoYEPANZUP+g1klubtcpEUEWDXGti3dhtzpK07IUqwqlaSvlQ79r+4i7i1zdFWmoLgJNNwsmLT0jfKReih3ariyqAvc/p4kMCcAFpy37ujf+RPAY1ZM7vjW9lA4A41gGHaEVEGBwF8CfX0Z6KagZe3q2kwd5YF/3rix7fkUlZOfORu/vobfOnZmH4LcvgtRRWkWYwIsHnBTRSNR9+STRNPkUwBMthg0o66zODtr4DfyUQdXVCz30Ms2TjR8DH4V2vLqG6mw7go4CDpCO86qYLyUfhsW2CN2sdU+CIzVERcX30+AZSqdBshy0RS1goXIUqX+w3XRsuL8KFUgRvXVTbGbqDRbdJpctytnKa8IWcJQS17J3NYt9NAsR8NBgzBdOsDQxyClLgTEGjAVKEV91ONfBMfZmYGSpgpTITDQawbHGdrmK3/5WQ4wzn5UEP+Z8oIRYkOLHelTaG/0PXBH3C05Miu1Z649hO7NGMZJBaWG3k6YqbLUoTJIIWg9P6/RnqkMUdXAhWzFHegT7Vmf4R5oifhsgofcdqF+O4+wbgSU56QEmDPUq6NmcCtm+p
 C5YlopH0
 +CCH3wSy4zdCweC9nCzXYvZ0xV/W/oEMKx/DucjjZBVdRnkWhy4N7tFH9EoWpw2X+aJr9m+d1RB+t2pQvRHWVI0Tlh/0Snk/owGX7ASzHVkA7xF3GgAvLuvmUm8d1iYzUf1q5Rj5TqFM6f3x/pFN+VCpVABDQVcIjvA6hw1UCgKMJZt+nJlQsLOKcwN30FotIIw5JhpMApfDbMjZhLHJZJB0dpmQgvQr9KzSAoKEglHYY0hY3Pa4vx8DyuBVIlyqX6unslSgr7LhThAUe+2VlCjqzvTVSH5wJtxVwqZtu+Rxw680sHTnMAYPxzawHqeOi4vSpEy2qPHH+p9KTA8bByJmw6kvhnQGs9xgrZSMeJWrnampDz3TRLj7fi2P5nsZX0dY4tmH4RQDUPSYGutA7grQ6Qwsumd1IiMC/bWsvfjNQGcGh8WosYjiMkqhGLGvrmLHNGiNhNmd5Yn21ov1kERX/Wi/suId69RJs9mbjz8+s4XL9TS3OqjcqekpOad91NkE8+ltkViF0ht7Q3qs5YtkAxy0Z+WGIJXOjxWFrd/Otm89M4YEHNYKYrX47SXZXM1HSSAozSWTFnd73caxoyHHEyFqJHRVa4s6nTOX06HT2dVGkM4Qqc+jK+dSAjTxXnZUO8nrN5aYHDQ39GUhNHVdzy8NV7JUGIQ3cTOy5MG30HzdP2LzrDKZpQsstsAJocDg1rJ4U2eXrndEY8cT+q3ACa7EkvaZNT8Z2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 10:32:11AM +0800, Lance Yang wrote:
>
>On Tue, Jun 16, 2026 at 11:50:22PM +0000, Wei Yang wrote:
>>On Tue, Jun 16, 2026 at 08:30:01PM +0800, Lance Yang wrote:
>>>
>>>On Tue, Jun 16, 2026 at 06:34:36AM +0000, Wei Yang wrote:
>>>[...]
>>>>diff --git a/mm/page_vma_mapped.c b/mm/page_vma_mapped.c
>>>>index 2ccbabfb2cc1..21635fab209c 100644
>>>>--- a/mm/page_vma_mapped.c
>>>>+++ b/mm/page_vma_mapped.c
>>>>@@ -243,40 +243,28 @@ bool page_vma_mapped_walk(struct page_vma_mapped_walk *pvmw)
>>>> 		 */
>>>> 		pmde = pmdp_get_lockless(pvmw->pmd);
>>>> 
>>>>-		if (pmd_trans_huge(pmde) || pmd_is_migration_entry(pmde)) {
>>>>-			pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>-			pmde = *pvmw->pmd;
>>>>-			if (!pmd_present(pmde)) {
>>>>-				softleaf_t entry;
>>>>-
>>>>-				if (!thp_migration_supported() ||
>>>>-				    !(pvmw->flags & PVMW_MIGRATION))
>>>>-					return not_found(pvmw);
>>>>-				entry = softleaf_from_pmd(pmde);
>>>>-
>>>>-				if (!softleaf_is_migration(entry) ||
>>>>-				    !check_pmd(softleaf_to_pfn(entry), pvmw))
>>>>-					return not_found(pvmw);
>>>>-				return true;
>>>>-			}
>>>>-			if (likely(pmd_trans_huge(pmde))) {
>>>>-				if (pvmw->flags & PVMW_MIGRATION)
>>>>-					return not_found(pvmw);
>>>>-				if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>-					return not_found(pvmw);
>>>>-				return true;
>>>>-			}
>>>>-			/* THP pmd was split under us: handle on pte level */
>>>>-			spin_unlock(pvmw->ptl);
>>>>-			pvmw->ptl = NULL;
>>>>-		} else if (!pmd_present(pmde)) {
>>>>-			const softleaf_t entry = softleaf_from_pmd(pmde);
>>>>-
>>>>-			if (softleaf_is_device_private(entry)) {
>>>>-				pvmw->ptl = pmd_lock(mm, pvmw->pmd);
>>>>-				return true;
>>>>-			}
>>>>+		if (pmd_present(pmde)) {
>>>>+			if (!pmd_leaf(pmde))
>>>>+				goto pte_table;
>>>>+			if (pvmw->flags & PVMW_MIGRATION)
>>>>+				return not_found(pvmw);
>>>>+			if (!check_pmd(pmd_pfn(pmde), pvmw))
>>>>+				return not_found(pvmw);
>>>>+		} else if (pmd_is_migration_entry(pmde)) {
>>>>+			softleaf_t entry = softleaf_from_pmd(pmde);
>>>>+
>>>>+			if (!(pvmw->flags & PVMW_MIGRATION))
>>>>+				return not_found(pvmw);
>>>
>>>Looked at history a bit, and I wonder if this changed something old
>>>here ...
>>>
>>>Since 616b8371539a ("mm: thp: enable thp migration in generic path"), PMD
>>>migration handling took PTL before doing PVMW_MIGRATION/PFN checks,
>>>including not_found() cases. So lockless PMD read was just a filter ...
>>>
>>>With this fix, true case gets final pmd_same() check, but this
>>>not_found() case happens before taking PTL.
>>>
>>>So a !PVMW_MIGRATION walker could race with someone, e.g.
>>>remove_migration_pmd(): we make the not_found() decision from old PMD
>>>value that still says "migration", while real *pvmw->pmd may already be
>>>present again. We return without ever taking PTL :)
>>>
>>
>>Hi, Lance
>>
>>Thanks for take a look.
>>
>>I am trying to understand the scenario you mentioned. Let's say A migrate a
>>pmd and B want to unmap the pmd.
>>
>>            A                                        B
>>
>>  try to migrate a pmd
>>  pmd is set to migration entry
>>                                           unmap the pmd ...
>>  managed to finish migration
>>                                           ...still see migration entry,
>>                                           so skipped and unmap fail
>>
>>Would this be a timing case? Even B grab the PTL, it still could see migration
>>entry if B visit pmd before A finish migration.
>>
>>Maybe I miss something, look forward your insight.
>
>Right, seeing migration entry while migration is still ongoing is fine.
>
>What I meant was this ordering:
>
>  CPU 0: pmde = pmdp_get_lockless(...); /* migration */
>  CPU 1: remove_migration_pmd() restores PMD to present
>  CPU 0: returns not_found() from old pmde, without ever taking PTL and
>         rechecking *pvmw->pmd
>
>So issue is not seeing migration entry itself, but making final
>not_found() decision from stale lockless PMD value ...
>
>Before this patch, PMD migration case took PTL before making that
>decision ...
>

Yes, this patch changes the decision making condition for pmd entry. Thanks
for pointing out.

Hmm... I took another look into current pte handling and find for pte entry,
we did two phase check:

  * map_pte() without ptl
  * check_pte() with ptl

While check_pte() do extra pfn range check, map_pte() doesn't.

This means for pte entry, we may face the same situation as you describe: 
make the decision before grab PTL. Till now, it looks reasonable.

But one thing jumped at me, PVMW_SYNC. When this flag is specified, all check
is done under PTL. But now for pmd entry, we don't have a chance to do so.

And as the comment says in try_to_migrate_one()

	/*
	 * When racing against e.g. zap_pte_range() on another cpu,
	 * in between its ptep_get_and_clear_full() and folio_remove_rmap_*(),
	 * try_to_migrate() may return before folio_mapped() has become false,
	 * if page table locking is skipped: use TTU_SYNC to wait for that.
	 */

I tracked down to commit a98a2f0c8ce1 ('mm/rmap: split migration into its own
function'), but not getting more detail on reasoning. Not fully understand it
yet, but it seems there is some race between migration and unmap which is
protected by PTL?

Will look into this to get more detail.

>>>Not sure about practical fallout, but should these PMD-level not_found()
>>>cases also take PTL and restart if PMD changed?
>>>
>>
>>-- 
>>Wei Yang
>>Help you, Help me
>>

-- 
Wei Yang
Help you, Help me

