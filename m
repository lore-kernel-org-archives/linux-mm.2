Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9C618C5DF81
	for <linux-mm@archiver.kernel.org>; Wed, 19 Aug 2026 16:17:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A253D6B0092; Wed, 19 Aug 2026 12:17:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A73D6B0093; Wed, 19 Aug 2026 12:17:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86EE76B0095; Wed, 19 Aug 2026 12:17:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 62AFB6B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 12:17:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5CBE0A04B2
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:17:43 +0000 (UTC)
X-FDA: 85118524806.18.72D531F
Received: from mta1.migadu.com (out-43.mta1.migadu.com [95.215.58.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id 59925140009
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 16:17:39 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1I4H6MB;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787156261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gi4iP7Iv1yV/DE8hMwNOB2hZZ11Jlz+zR+Kzxv9/1k=;
	b=PJotjfH2Xu2etKZ7+SUvg8LKQab18Z0eN9XBkd0MH6WK89ZsjcKM4xWoHkR+F6259PfMbd
	mPsv3JY/S6b77LuDY9i/VzqYv15uaU+4ut9gzVmZiv34Gf1TsyhSKwPhTO0KIttrackALT
	K+jcQJG1XSnwsmuM94Vvad9CCJdL020=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I1I4H6MB;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.43 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787156261;
	b=fiqB+mZXIkfVhC+Uek6jASoHAgdEXCtisT1t69tXRKs34plE9XbrCdhTjakibLRQAlf6Wl
	48uO30uXfiyIehb/TOIKYud2WA/kOhkGRIsC+YTyP6zdnkECuR8lN1WFIYu4dQWFMVjgZ8
	y5bkpiFXkadJxd/vHVmn7pThv8H0RBE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=H6/QcdUixULjBgiKCgDUKmcum30yTmAeKK5QKuZnZjk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787156257; v=1; x=1787761057;
 b=I1I4H6MBoI0g8XkFslMDaKEaar9a/p3/A5H5wxyIOHqXwe103FiAXA9IamAvHwQIkvBDPgIc
 zdR3UQvtnG63/r/dsyWiKlMSiY3BugxVpQRKdrIHTPuUJFy5rEXLXE6P8NiF8/EA+3x5A5uDWz+
 rjtlavwV/QwCVbzbLn8wYCAQ=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 9b2cb0d49dfecef4;
	Wed, 19 Aug 2026 16:17:37 +0000
X-Mizu-Trace-ID: 9b2cb0d49dfecef4
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: kas@kernel.org
Cc: usama.arif@linux.dev,
	hughd@google.com,
	akpm@linux-foundation.org,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	dev.jain@arm.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	ziy@nvidia.com,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com,
	stable@vger.kernel.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH] mm/huge_memory: transfer the pmd dirty bit to the folio on zap
Date: Thu, 20 Aug 2026 00:17:28 +0800
Message-Id: <20260819161728.70270-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <aoWw_iKEDLjKL2jr@thinkstation>
References: <aoWw_iKEDLjKL2jr@thinkstation>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59925140009
X-Stat-Signature: uhayjn3cexzm5ou386d8tjab1zqtb18q
X-Rspam-User: 
X-HE-Tag: 1787156259-631655
X-HE-Meta: U2FsdGVkX1+CE7SXC+9mImuyTx3zj/vnIBuAJjnbfVxpwmTIv3/UgZvW+cUmLciOCRTuqds2waBLTACT1pokXGW/HjQDvlqIxYqQ3JDJl8XulFF2X0WgrAhmLkereOEqZuWTz1En/tNdiTIQgBgvexjZKN9szQKbgJH+hjg+YRswhf6/s3gerbo8ONp6zlm7+P+/GJrfzqLuptHH8gglsXg2V4eYxW6CvqxV5+UUinCgyXMyR3S9w/yp8cvGG/JFn/ZvqPMtagiCauujp2/tvo0tn3J38RAPGbabbaoxbT88eoseewQ9UCNfwdEPxdC98dtXeesUseB5Nxmq6XloSioZXVdKR5QyLT3pHJLuctQo4zWhdviYRVKR/IiS5zZnpcMG9uBy4OnBJg3dGNGhKWnUj39tp+gsrgjqkbbxU/UtogGisYN27LsoRYvLqn7Xy4J8JhGZZpb1PtPw44VHvzHFV1TSHf/L6epsHR76lV3xJsB6LAOGEVkSSTWVMFq/MA41DdkIvn+M1qH0dKT4n1QFxmTIdHvB24KY0mN1OTtton+9XdgbJQ1N/uEHLfURmjsykZmXrk/LkcZgZmszLDc+BC/AWnyZKoQUKdPGG8NnfMdvhNsXSmWgCcf3cO2L4BZQRfV430kAJQworF/ERidm6Aq0YhraJuDM/+1VMq1nKi3atUpUCGV+Qnk24Fg17oSlQZu2k293Ox/I3NaESjyxoOE7OJLxN6oemAq0JZYN6BjgTrLeXFGdmVoOZCg0XacO2SkoX23YPTTledsOjQxVoypKAJegP3Rh2DKAs1k2HmHax0VeiXNJTCHkaW5lmpdUNZir2k6jsxiPwlChzohd7yegG2BO+TutGZQoz4S8AyPRX0uiUJyJcU7S6B6RiDtO9lGE1byYGSh814RtTsarcCdQcga90CSW30iYP2EOsVDvESIfIWgnQTnvYs/g7pbh8iYKmDc0Wxe4NlJ
 t1FUfoWk
 RAP8D5eEGZ56bkzf+SbHoePwFCvM/eykOIbpeeOz9xssmJdm5DI/fAPKYKKtqwnE0Arz3uMWq/twqragkYb76riFEHdZRk5L9UVG0AtrMux9D79aauXMau+5xeGLppRCPQP+IWKwdS7gJVq4zM9Ft9KZ2BvnZiUQq/pY0c1QV42Phlqhx+3nXs8BfWNrJ4B5u5L+sMfJ0xfx91LTeamei0/3lWoQX8H2/8Ni23uUc45+oY9zi5tT5jvhOkjEBiEVYywML4Tqm2ZWhWzpa7BsNAqupC16crPXQZgcXkRdFwC1WElAzL5aVjMKuuSSZZwnhQkMITtvisdn9kCs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Wed, Aug 19, 2026 at 03:31:40PM +0100, Kiryl Shutsemau wrote:
>On Wed, Aug 19, 2026 at 03:12:22AM -0700, Usama Arif wrote:
[...]
>> ---
>>  mm/huge_memory.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index ced400f72d43a..afbb5974bd225 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -2449,6 +2449,8 @@ static void zap_huge_pmd_folio(struct mm_struct *mm, struct vm_area_struct *vma,
>>  		add_mm_counter(mm, mm_counter_file(folio),
>>  			       -HPAGE_PMD_NR);
>>  
>> +		if (is_present && pmd_dirty(pmdval))
>> +			folio_mark_dirty(folio);
>
>Unrelated to your patch, but noticed while looking at it: we drop the rmap
>here under the pmd lock, while the TLB flush is deferred to
>tlb_finish_mmu(). The pte path handles this with
>tlb_delay_rmap()/force_flush (5df397dec7c4), but there's no pmd equivalent:
>tlb_flush_rmap_batch() only knows folio_remove_rmap_ptes(), and
>zap_huge_pmd() uses tlb_remove_page_size(), which takes no delay_rmap.

Well spotted!

>Doesn't matter for shmem, but xfs & friends do get PMD-order folios, and

Right. pageout() cannot pass its refcount check while PMD mapping still
holds an extra folio ref, and mmu_gather drops that ref only after TLB
flush.

>do_set_pmd() makes the pmd dirty+writable once page_mkwrite() has run. So
>folio_mkclean() can clean the folio while another CPU still stores through a
>stale TLB entry -- silently lost write, no PG_dirty left behind.

Yep. Writeback can run folio_mkclean() while that ref is still held,
though, and with rmap already gone it misses the PMD ...

>I think we need to fix this too.

+1

>Wanna give it a try?

zap_huge_pmd() only handles one PMD under PTL anyway ... how about just
flushing before folio_remove_rmap_pmd()?

---8<---
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index afbb5974bd22..6fb34924ef66 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2531,6 +2531,14 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
+	/*
+	 * folio_mkclean() relies on the rmap to find writable mappings.
+	 * Flush stale TLB entries before removing it below.
+	 */
+	if (folio && is_present && !folio_test_anon(folio) &&
+	    pmd_dirty(orig_pmd))
+		tlb_flush_mmu_tlbonly(tlb);
+
 	if (folio)
 		zap_huge_pmd_folio(mm, vma, orig_pmd, folio, is_present);
 	if (has_deposit)
---

Cheers, Lance

>
>>  		if (is_present && pmd_young(pmdval) &&
>>  		    likely(vma_has_recency(vma)))
>>  			folio_mark_accessed(folio);
>> -- 
>> 2.53.0-Meta
>> 
>
>-- 
>  Kiryl Shutsemau / Kirill A. Shutemov
>

