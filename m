Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95218D68BD1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:48:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D705B6B0088; Wed, 17 Dec 2025 22:48:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E596B0089; Wed, 17 Dec 2025 22:48:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFFBD6B008A; Wed, 17 Dec 2025 22:48:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ADEDD6B0088
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:48:06 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57EA21A0CB1
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:48:06 +0000 (UTC)
X-FDA: 84231208572.27.114C7A1
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5808BC0004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:48:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZtElJH1b;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766029684;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eu5mTsUDsFsEXyRU5WNzyJUBw6y+ieYrC2Vms+G/4F4=;
	b=65DZGDJ9qB/cTD6rhC4BNRSZVuEgZubo+ATsq3PHHZ2mW6xcnsglrs2ErXFNiJX/RR9Soe
	JPoZ+pZCurhBXtIsLpMZnMdISdec21oe7iOFHMluGMmt5GfZpe991+xIaztxkwbQmqVf2R
	AVO4P8XHofnm6GNzGo5wKfNlCh0a10k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZtElJH1b;
	spf=pass (imf22.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.44 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766029684; a=rsa-sha256;
	cv=none;
	b=1NFWn2JQn/rljEwmpTSqLiWJCw5Q9fBhxpAcvqIH05HsGNWbz+RqNLcYBK9KpQDKSRgNHx
	bM86U8INerX8xP2DUFTtBm+wb6nCHrjKRdyhU2hln2FYGmoF/UKKRh6wyD2HCNhZBm3naO
	8Yv9zlzppzo3meVH0trEpjeyoAnF7X8=
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b7636c96b9aso23601666b.2
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:48:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766029683; x=1766634483; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Eu5mTsUDsFsEXyRU5WNzyJUBw6y+ieYrC2Vms+G/4F4=;
        b=ZtElJH1bZ0iOZCVax08dzHNT2+Qnrzn1knJtFEsD6e3xlmzrDcOViCsHm5S78qJcPJ
         tk/P6NSbVCUBML3dGjxjSoII9ZRlAtZbkqTPm+NtkcpuAx32N98YPu0n1d9vgXqc/kyh
         7vDlnSYz14IVkVzlD7UNo67Br6Wa0in93XyokHkT6IOiEM/h8Wps150PyoxR97zVEyxO
         7POCBHpSpVGF9LwIa4t2mJ85bk/vcM/ZNdFeLOoPb6PkMYV6Hi951Z56Ps48c2mDQ9LX
         Ec9Wk6Q5FMIHOYYbPfP4x2Lzmpa1nx5SCDIHraZOrvtiWykNowWyBnTOvLYEOLSLPGX0
         eQhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766029683; x=1766634483;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eu5mTsUDsFsEXyRU5WNzyJUBw6y+ieYrC2Vms+G/4F4=;
        b=Ywlu118k9lhB/EXCPIKEpIAJDWVvxzDzhKI86u2mcGdLRCwWwqoX75+JZUplVLHq+Y
         8728lwCXQQsMQkyAhrBxmj3ewg77FHpgHDA7rlKJ9JCYRpx0j9slKLMEOSL07DM9pfhY
         o4dDFVYs75hxj3fJSe33FZ8fKSRp/qIficnbyZOpkD5t6QSzqWCaU5mLAHPyEPP458vL
         9s/AymWX1K7TlpMfzSvweohmAClpQaURfeAmpQSsifZLC+9PYFCSnC/HjRC/dhJxNmsl
         0OE7rGwcfs2C5Ub/7K518ubk45gsrNpKhwv5/RbVV8XLVrnGJ7MEWI4Dea3G/w8UlsC2
         kUkg==
X-Forwarded-Encrypted: i=1; AJvYcCWyzW0aVapjqLyzf0/qvpYZNY9yVMj5+tglKHkOzQwKKjW5nNS6dW2AambaozzXNNjjiXWwHNWrBg==@kvack.org
X-Gm-Message-State: AOJu0YwUn6x32+IBu8gkydyZE0sZp8wkdTK8L3e1BrEnAgBuSOg9ve+D
	3pa45BUlsedaKFlwOilgiYUzQ5MCxZf7oOFytuDsSuYvrDNwHPPR2myG
X-Gm-Gg: AY/fxX4mFANTWOZlkudWJWCr+tfr0zlG9rJldxYvY4WgUVWkEmciTsgtG8Tw/Ohlxy+
	Hh+dIFoisp19IlmblscSxV6FQXmcDKvAYSkWynipH7eCNdeoRG6ADENzAy9nAqguCBYZ+OPqamn
	4kkGGzcOmrQL3gR/64IpbU1x7WfqMbnJGSvMgSET1KvKdEkbf3z9y+3e0JZk4E2altTmCTNLiRP
	HdRZAtz7ZRDbg5h/exRU12bfBnsGWrmiASJaCISaQyMqzJj5sFako+3d9tXDqgqjn4rmoQQR/m2
	HHfb0B8cfCINjT+P5jiXVOloaS1ZFqTZXP3c0ij4dCKMH3oEvpti4bw+urpMGYm5hMzqPNwwEvO
	1Y+o2ncKHUCuW1lsVobkhP+5/jan74aCBrOu51H12NOutBNB5qwhx6DXmr12wZYZtUvaNpgsoQu
	aWiVARXDRIuQ==
X-Google-Smtp-Source: AGHT+IEhb85OnxJHtdaCsIJfZYaNPQatlWVX6Voa/vRm28GJA+za37nS/qdtvmhAhmBAGS8ibfry0A==
X-Received: by 2002:a17:907:94c3:b0:b7c:e320:5228 with SMTP id a640c23a62f3a-b7d2362659fmr2044581666b.22.1766029682574;
        Wed, 17 Dec 2025 19:48:02 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b8022f95331sm104950666b.6.2025.12.17.19.48.01
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 17 Dec 2025 19:48:02 -0800 (PST)
Date: Thu, 18 Dec 2025 03:48:01 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
	david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <20251218034801.jyuu437dbtvcnpzw@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <20251217033155.yhjerlthr36utnbr@master>
 <77paexkefc7qkfjgv6reuf7jxlysgkinuswsck5tthqkpcjkpr@aelvplwvafnt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <77paexkefc7qkfjgv6reuf7jxlysgkinuswsck5tthqkpcjkpr@aelvplwvafnt>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5808BC0004
X-Stat-Signature: hpfc7doubbdt1yr6xi63wd1z7fmy9bw1
X-Rspam-User: 
X-HE-Tag: 1766029684-932275
X-HE-Meta: U2FsdGVkX1/07SlR7Z2M5PO1L4KVolnpcv9nZBvmO+70qnXx+q/nmcIx/YAHz1C9F+tMJv1nWyW2wdXkMBNJ7sAmlNTQWHn8KljyiVVQ05yGt7MjD/OB7JJS9td0VztIQ/pP4zQEZ+ENdf+7bgnjV+BoKVb8xuDapbik5kmeobLOKsmTlKgkpkHGzvUAaiFR8/K7XAINrIQW/0MTFckbD58Kt9SUbFBIgfB86yWAOdifmm92XrJ8TJY79GmDkQ8U9HXqB97iJSaRdA2LH1laGZ0Fmg8xIyvVpPsJ9rPiwuCLXXtcKgrknxjp/UTmBmTMmk2v5f1n7cyRyF99MuQdjorVQBn/zQtqIdmk+F0NjsNMqOyDJohfkhk36T3XBQ0H7KMmp/MJTZ3Mro2npu2rgT/g8Ml/4Z43LnEIfLJ/7GEIYFI9Xjwt+T3pMOdTIw92vH6DwVf/nt3/+HboFLvD6FxNdYwKltBLUBcM18aL/wIAtGeus2Lo5b5/h1LMhmv93vvJrzYmtCOy33d4uboPqaBpPYDju3H739goAi4VScOcVeLWkLf+PWhVt0W2cVe5MEiyGeg71SPpCJi3AypXp5SzIqoToa1+T/1zidH2isNlR4PrtJanIogWcDmWROVssfz53N6ENWip/y7UqRiOhr7riKKCgw9OlVYVSsnpaNI8/lgmvExTMpiHek8i86yVGtu1RIA6mO8eX62D7LNEY79wMHt3dwMo8p74UuWy1T7wARxsRTgaxND/5KC1CJ/LEWG6bbd5YKAEqpqC2qv6HX31LSpBUiE87l4H0hV7jhbg2W2aqAmNncVcvR7CXERNhe0mqfU1h8q6BFUB0H2U8XkaIHO7hrbp+lfdhTx0EkUluIZJdATz0FgFr37/5uT2WL9ZZWwy1FtHfwW2zHFkE2x08zhhnEN3lTlFWQSAy58v/SygIOzhEfjDdnnyxFCBE4jscvked1Rcy3molf9
 fhziP5vD
 xoiDfB0iqcOu9V804REBNyfd5zk0uNy6Ea0wEpBWL2vG//Mj4dDZXoGF+kL/gzceEiEvQOAV3d/3DfTAfEtFYI0Zb5DWeOfvXtPYW9WIN/UNOVws6KS3P71sIZCZXHGqP4+aG6OIRa6+h2iQkcmYpAmMvYD/c+YpN4eMZsmEZdCaJPZpxjl9I2hVi22VicmMAUJVDznHQzm3foIFOysoAr/YRak6wbjxouF74RcSa14T/JzkHgdJG2eBZjvWnPhmd238Fc9YCQ30b+9NrNekifBPm9Pc32fYKUeh6MB7blV8P3dVmBL/wB5NQ9W6+F4FTlacLrUatFy2MsxjgdnzPn8R1ROaVFcDQUfHVi/Ogwn1LutWc3T61P9F5jdGf+c3D3wA4+xRd28CJp6rd6W/7VeUdChM8gaiHWkscNDn9brjr2jD26Bxf8vbM+zyPbs3psEzN4o7VNLITK+Qo3lZnud+pIe6c5B7BgVMCT9yFXJW9wfwKyeyRjwT0EUQA4jxVWFP5stKkRd4oA3ZtB4c4ry53OM2hUgbwFTyw8JANbEwrc8rP78POw/4cgOMSOIkpiPRP8A9RbZCSY17Pjgtnei/cBr8i9GDn7SHN4RkLPDk8H6ERfL+q6KTWuv3ixE/IGuFHRZlYkFbVgmmhpVNPyVQZikOK4gHU2Zwp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Dec 18, 2025 at 11:27:24AM +0800, Vernon Yang wrote:
>On Wed, Dec 17, 2025 at 03:31:55AM +0000, Wei Yang wrote:
>> On Mon, Dec 15, 2025 at 05:04:17PM +0800, Vernon Yang wrote:
>> >The following data is traced by bpftrace on a desktop system. After
>> >the system has been left idle for 10 minutes upon booting, a lot of
>> >SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
>> >khugepaged.
>> >
>> >@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
>> >@scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
>> >@scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
>> >total progress size: 701 MB
>> >Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
>> >
>> >The khugepaged_scan list save all task that support collapse into hugepage,
>> >as long as the take is not destroyed, khugepaged will not remove it from
>> >the khugepaged_scan list. This exist a phenomenon where task has already
>> >collapsed all memory regions into hugepage, but khugepaged continues to
>> >scan it, which wastes CPU time and invalid, and due to
>> >khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
>> >scanning a large number of invalid task, so scanning really valid task
>> >is later.
>> >
>> >After applying this patch, when all memory is either SCAN_PMD_MAPPED or
>> >SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
>> >list. If the page fault or MADV_HUGEPAGE again, it is added back to
>> >khugepaged.
>>
>> Two thing s come up my mind:
>>
>>   * what happens if we split the huge page under memory pressure?
>
>static unsigned int shrink_folio_list(struct list_head *folio_list,
>		struct pglist_data *pgdat, struct scan_control *sc,
>		struct reclaim_stat *stat, bool ignore_references,
>		struct mem_cgroup *memcg)
>{
>	...
>
>	folio = lru_to_folio(folio_list);
>
>	...
>
>	references = folio_check_references(folio, sc);
>	switch (references) {
>	case FOLIOREF_ACTIVATE:
>		goto activate_locked;
>	case FOLIOREF_KEEP:
>		stat->nr_ref_keep += nr_pages;
>		goto keep_locked;
>	case FOLIOREF_RECLAIM:
>	case FOLIOREF_RECLAIM_CLEAN:
>		; /* try to reclaim the folio below */
>	}
>
>	...
>
>	split_folio_to_list(folio, folio_list);
>}
>
>During memory reclaim above, only inactive folios are split. This also
>implies that the folio is cold, meaning it hasn't been used recently, so
>we do not expect to put the mm back onto the khugepaged scan list to
>continue scan/collapse. khugeapged needs to scan hot folios as much as
>possible priorityly and collapse hot folios to avoid wasting CPU.
>

So we will never pout this process back onto the scan list, right?

>>   * would this interfere with mTHP collapse?
>
>It has no impact on mTHP collapse, only when all memory is either
>SCAN_PMD_MAPPED or SCAN_PMD_NONE, the mm will be removed automatically.
>other cases will not be removed.
>
>Let me know if I missed something please, thanks!
>
>>
>> >
>> >Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
>> >---
>> > mm/khugepaged.c | 35 +++++++++++++++++++++++++----------
>> > 1 file changed, 25 insertions(+), 10 deletions(-)
>> >
>> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> >index 0598a19a98cc..1ec1af5be3c8 100644
>> >--- a/mm/khugepaged.c
>> >+++ b/mm/khugepaged.c
>> >@@ -115,6 +115,7 @@ struct khugepaged_scan {
>> > 	struct list_head mm_head;
>> > 	struct mm_slot *mm_slot;
>> > 	unsigned long address;
>> >+	bool maybe_collapse;
>> > };
>> >
>> > static struct khugepaged_scan khugepaged_scan = {
>> >@@ -1420,22 +1421,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>> > 	return result;
>> > }
>> >
>> >-static void collect_mm_slot(struct mm_slot *slot)
>> >+static void collect_mm_slot(struct mm_slot *slot, bool maybe_collapse)
>> > {
>> > 	struct mm_struct *mm = slot->mm;
>> >
>> > 	lockdep_assert_held(&khugepaged_mm_lock);
>> >
>> >-	if (hpage_collapse_test_exit(mm)) {
>> >+	if (hpage_collapse_test_exit(mm) || !maybe_collapse) {
>> > 		/* free mm_slot */
>> > 		hash_del(&slot->hash);
>> > 		list_del(&slot->mm_node);
>> >
>> >-		/*
>> >-		 * Not strictly needed because the mm exited already.
>> >-		 *
>> >-		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>> >-		 */
>> >+		if (!maybe_collapse)
>> >+			mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>> >
>> > 		/* khugepaged_mm_lock actually not necessary for the below */
>> > 		mm_slot_free(mm_slot_cache, slot);
>> >@@ -2397,6 +2395,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> > 				     struct mm_slot, mm_node);
>> > 		khugepaged_scan.address = 0;
>> > 		khugepaged_scan.mm_slot = slot;
>> >+		khugepaged_scan.maybe_collapse = false;
>> > 	}
>> > 	spin_unlock(&khugepaged_mm_lock);
>> >
>> >@@ -2470,8 +2469,18 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> > 					khugepaged_scan.address, &mmap_locked, cc);
>> > 			}
>> >
>> >-			if (*result == SCAN_SUCCEED)
>> >+			switch (*result) {
>> >+			case SCAN_PMD_NULL:
>> >+			case SCAN_PMD_NONE:
>> >+			case SCAN_PMD_MAPPED:
>> >+			case SCAN_PTE_MAPPED_HUGEPAGE:
>> >+				break;
>> >+			case SCAN_SUCCEED:
>> > 				++khugepaged_pages_collapsed;
>> >+				fallthrough;
>>
>> If collapse successfully, we don't need to set maybe_collapse to true?
>
>Above "fallthrough" explicitly tells the compiler that when the collapse is
>successful, run below "khugepaged_scan.maybe_collapse = true" :)
>

Got it, thanks.

>> >+			default:
>> >+				khugepaged_scan.maybe_collapse = true;
>> >+			}
>> >
>> > 			/* move to next address */
>> > 			khugepaged_scan.address += HPAGE_PMD_SIZE;
>> >@@ -2500,6 +2509,11 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> > 	 * if we scanned all vmas of this mm.
>> > 	 */
>> > 	if (hpage_collapse_test_exit(mm) || !vma) {
>> >+		bool maybe_collapse = khugepaged_scan.maybe_collapse;
>> >+
>> >+		if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
>> >+			maybe_collapse = true;
>> >+
>> > 		/*
>> > 		 * Make sure that if mm_users is reaching zero while
>> > 		 * khugepaged runs here, khugepaged_exit will find
>> >@@ -2508,12 +2522,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>> > 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
>> > 			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
>> > 			khugepaged_scan.address = 0;
>> >+			khugepaged_scan.maybe_collapse = false;
>> > 		} else {
>> > 			khugepaged_scan.mm_slot = NULL;
>> > 			khugepaged_full_scans++;
>> > 		}
>> >
>> >-		collect_mm_slot(slot);
>> >+		collect_mm_slot(slot, maybe_collapse);
>> > 	}
>> >
>> > 	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
>> >@@ -2616,7 +2631,7 @@ static int khugepaged(void *none)
>> > 	slot = khugepaged_scan.mm_slot;
>> > 	khugepaged_scan.mm_slot = NULL;
>> > 	if (slot)
>> >-		collect_mm_slot(slot);
>> >+		collect_mm_slot(slot, true);
>> > 	spin_unlock(&khugepaged_mm_lock);
>> > 	return 0;
>> > }
>> >--
>> >2.51.0
>> >
>>
>> --
>> Wei Yang
>> Help you, Help me
>
>--
>Thanks,
>Vernon

-- 
Wei Yang
Help you, Help me

