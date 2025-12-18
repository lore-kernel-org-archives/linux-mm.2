Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E439D68BD1
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 03:27:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D5BC6B008A; Wed, 17 Dec 2025 22:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 083A26B008C; Wed, 17 Dec 2025 22:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC7576B0092; Wed, 17 Dec 2025 22:27:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA8E06B008A
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 22:27:34 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6F763140C95
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:27:34 +0000 (UTC)
X-FDA: 84231156828.08.ADABC48
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7FB874000A
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:27:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G7/r4n2H";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766028452; a=rsa-sha256;
	cv=none;
	b=eE/Tp3bIzNZsarrE+Oz1DvJuo2MNK9A4vZAxRUxG3mlMStIAdihOLvXY/rc2QFyTJMmYov
	Wvb+ER9WFQB05kiQeywDByqBshnF0/Q0kK+g753uv8/WpXO7Bg3YE8f+es/3sxneATLVZb
	PoL38PualnQ+NdDZRUP4JFjIyNEwbd0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G7/r4n2H";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766028452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gOEfCXNMsaQVfUksR2XTNPPPQDSaWx7Reat1wB8Dq08=;
	b=uaPhgjiigGoL6gb4F1zoKhgrjPYX3UdtT8lrIs2JdvLG6WYRG2YLx/mYHHjtfHu25CIbtU
	dDlFJ7KA4CLWJ+3eKUb0Igry0gNgGo4KcOm5BdAm7eaPUJAfPQm/yT24oOsn6J7Po5ubu9
	5c2yFnVxAITG2vzO8pEaC9/9pqoesMs=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0d52768ccso2403785ad.1
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 19:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766028451; x=1766633251; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gOEfCXNMsaQVfUksR2XTNPPPQDSaWx7Reat1wB8Dq08=;
        b=G7/r4n2HtzffndzQ70xzKv6AxoVvbWF/CJO+7OX/w51NdiikurBTZgUYofb8xOCj7r
         6UgrB43SJB9ElxEVhOE0B+m/XvlXPUkOl/if33RsLga8YSxRop9Cqab1CgWajOf+FBnD
         dO4wfnAW4lBufw+Bv+QaY6JzBdwi6RF8tMu+KEp/smVnrKYY7gdlM2Nt1Vsf4SiNkJ2Z
         hB+yW+vtJwo3fm5lMOScCT4cXPxTerboMmGb+a/QeLfyER+HboXUkeJBaqNaW464n6AJ
         Sord+DmFuD9tZH9MhDm/utzj+o0kBmf0FAMY0PPyOWtmalfxQ4WH/GCqS2IvkXnFdy+3
         8SAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766028451; x=1766633251;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gOEfCXNMsaQVfUksR2XTNPPPQDSaWx7Reat1wB8Dq08=;
        b=wknYnEo32psWGJlI9E5sPCX/1Q0DbQlCIfTKs7hkwdw9Vi3krfi6SAUxGPdlOtIcrj
         7OqAxe49kub4zAILwOQ3cX1+l3/rmBuZ5IIDOmQjTxTYOjyv1YH2Lw+sKgyy+9UJo69o
         A+6hMfiFCb53PfqvVn/wg0yCyYogl20e0f05E77PjZqvgXFlQiNp2ANBR0ZWlKgK4HNz
         NBCR+AJkjQRUErB5fceWkRZ+BFb7bP45H81PXXET+q7YgBFk0aDQ9/lfYrkcCIeWzZzE
         cGATJWEjBOXPTnFxNkCCPOL44Xo0M5TK9IdylLzLrMZbQEf9iYq9Cvq7Gu4UmmQiRhcM
         pATQ==
X-Forwarded-Encrypted: i=1; AJvYcCWsE/CJ8yoYZ+LSXOMoHBZiDd9awSWFgzamwRUD5nFdkb3IOAh+HDbe2trEgQu3WfkQtuPjn6tmZg==@kvack.org
X-Gm-Message-State: AOJu0YwDYdI5Vr+pG332xvAy6OOwbG+KPH/3JQtvqPgUEH9FaKZ0Lh+2
	xdZSdY4TkYkX4NKxajNyRsFCJT13w4+Kywfs0srVLqIJLu2ICT5EGN6S
X-Gm-Gg: AY/fxX4AJW4SLuVlGWEE2JDLDNG6bAudQ1SzSws1Nd3X2DMAuHx5n6Tza0ujAME+0fF
	yLrpC6sY374gdRttDqH/VE+REh4vT02e5/F32X3KkwRfh2GUidQccFYz84dOsY9vcSDz2RSQfIm
	qrVuFBd5xF9kTG7SAoTuUqTOva1fhS3RFA+42MY8FnJw/fma2ZKrpczqjbG4m7rhgmMS/Ni+sQG
	W3tG3ut3P1WN89yZ3ZzYEYu0LlZUATmc0B+0tkc/z1/LGHxjkOhAbXgPak6zQ6WFd5kEcXGs4Yw
	ZNLXsI1RsoXaNrv9+Xht84OAhW9fENxZcT0OuPALKgDv7w7YmLkdsAeOOag3Vwoco5HZ3S99uPJ
	IZddwnD/f0irN9/x3QCzKoJ6zSvjDtCGqJYOL31CZoyuymN6HStqlr3Ww4KPBfg7hiiWU9vFA7F
	aJqXltFywqNCFxQ/LlGHQFC7tk
X-Google-Smtp-Source: AGHT+IHCR3V2ZOSf2DNAdaUCPEn//pj3RQnEaYRTkC8QLxf8DSb6AkGhriuFHV0quXV9SpHCqqv2aA==
X-Received: by 2002:a17:903:2bcc:b0:295:8a2a:9595 with SMTP id d9443c01a7336-29f241512c1mr211687515ad.39.1766028451230;
        Wed, 17 Dec 2025 19:27:31 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d193cf98sm7880175ad.94.2025.12.17.19.27.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 19:27:30 -0800 (PST)
Date: Thu, 18 Dec 2025 11:27:24 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <77paexkefc7qkfjgv6reuf7jxlysgkinuswsck5tthqkpcjkpr@aelvplwvafnt>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <20251217033155.yhjerlthr36utnbr@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217033155.yhjerlthr36utnbr@master>
X-Rspamd-Queue-Id: 7FB874000A
X-Stat-Signature: e116jb9pditsasoky3sbkb1gcs4hznkh
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766028452-328039
X-HE-Meta: U2FsdGVkX19/xm1+qPbp5A19gEBHknmW3vFvMuus/H4Q8jzddecuMe75TDbYSkz71gc024wx71SzV95anWmPOZefzYpvmNoyLmGliwwsLhHqeRvIQmNd5AoAu8R9pnAX+bLn3n1lmutmikCC1aUXooT9vfUZK3Ban2ue9ZLXTxU65kubobfHSZX2IgpP01OHs70z8MCop7aD9MQy0OK0Tt5VSr3bHCeEzlS6MwY5kqKyK47EElgnLfbVS/5a2gtE+nLyxQlNHsLsASaQPcizrq64twehUshheJhDoN+JFLZ0yeWsnmGdccF+Ewo+11tm6IeRno83uEb0b/WetaAwn8KmPFybG9h60j+M4xRUT8VObJnvuQkdFMjotp8Ou4W4JEOF4yAhQ/zOw+BYuvL32oSLS2BKOSg+oRnVdmmuPEnd1eYoo5dzH8AgB/vMDlO7AputMPjp+5luutpBvQCh31r89idi9fmB6C4cJuTgk+Kyw7Kecb2QSZ0QN+CkcKhxvg8G2vyKdCzxKnHPr0kE6ZhM8yPhe4rHi2ghdF862/7HuL5fs4janMSDeOA198CJzdQetsSdGXkSeFEXHHDUvoHn0+GZHn1c2GZjok8xrtWdG+tkVbR45UdpPvlknGBG8VdSLvK+fRr6GnG87e/FH6kzGFmGYsWK45INZogp77UsTnS6a2sgC2fzQ8o14aRd4FBdRL3ZbNGCu/TJdxhIgJMTWAkWRxQganAUmpEmcPLFfUduegLVSOUZjCSjWFiuCP9foC3o2k5/ANoqO6Tapozys7TKqv6e1tYwYOcATEANAyR5ce6QMxJxAAjW3ktHcHSw1RgVKJ1cxNsZlhPxwPMYAuSZFKPN8vSIxsEmPVazM3YbzfQcjMeHJbiwi5PjX7AA1mavWwPOwhhc1zGqbvUBMgNwdxwmkK9tp//egoje6wNMt0oVEfrPC1jKxUdkveusvvrLPKRe5zkeTF0
 3k5z2xn6
 ihwiXWE3szu1v62siNa11v0MSnewQEeTGydA0PKLEphPot6LQjNiqScFcaz9UV4OrKoEooeQR3MygaI4NdLgqbrhhO7v7injRzSNgGfO7VCyXbDv6EWFjRFksS/8BMYGQUr/8R2LH4wdyGFXfxMYTaJaOxFZxTKvNb1yRaS0/yJyb/fV5xy6hdZHxrfp9WtexeqXvPk6gXRLF57RDks8XM/Nx3MsiW+oeWRXGwTOFuqHce3fhh9zSN3vZ06C/mU3VL8kFO42er/dTWh5hIl9s3iXtofYGoVFBsy7lat+IlzJ39H/li24b3yMXqv5Kmv/ClwGCOrJ26Lp5CDGHKuvlavmsxbUgGEQ20GMe5WlI4VgLLfnVtWir5XzaccxejDoVm5zRMHkjJKjQ90V5EQZoUig3Nb/9fdflLKgR/H77nNcwTEj6dj0FWCIGdlS7sezWib6Ks2ik7SMtPlRe2YjvIZHjyTiaS9wxX/Sp237zWd+zAtvHTQXlx+IKmxGynLYEDfaVMznBZciySWZOBFEj1sU+50zMVveeJ2B46yk4d1RpfKEIEWANBUlM5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 03:31:55AM +0000, Wei Yang wrote:
> On Mon, Dec 15, 2025 at 05:04:17PM +0800, Vernon Yang wrote:
> >The following data is traced by bpftrace on a desktop system. After
> >the system has been left idle for 10 minutes upon booting, a lot of
> >SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> >khugepaged.
> >
> >@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> >@scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> >@scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> >total progress size: 701 MB
> >Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> >
> >The khugepaged_scan list save all task that support collapse into hugepage,
> >as long as the take is not destroyed, khugepaged will not remove it from
> >the khugepaged_scan list. This exist a phenomenon where task has already
> >collapsed all memory regions into hugepage, but khugepaged continues to
> >scan it, which wastes CPU time and invalid, and due to
> >khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> >scanning a large number of invalid task, so scanning really valid task
> >is later.
> >
> >After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> >SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> >list. If the page fault or MADV_HUGEPAGE again, it is added back to
> >khugepaged.
>
> Two thing s come up my mind:
>
>   * what happens if we split the huge page under memory pressure?

static unsigned int shrink_folio_list(struct list_head *folio_list,
		struct pglist_data *pgdat, struct scan_control *sc,
		struct reclaim_stat *stat, bool ignore_references,
		struct mem_cgroup *memcg)
{
	...

	folio = lru_to_folio(folio_list);

	...

	references = folio_check_references(folio, sc);
	switch (references) {
	case FOLIOREF_ACTIVATE:
		goto activate_locked;
	case FOLIOREF_KEEP:
		stat->nr_ref_keep += nr_pages;
		goto keep_locked;
	case FOLIOREF_RECLAIM:
	case FOLIOREF_RECLAIM_CLEAN:
		; /* try to reclaim the folio below */
	}

	...

	split_folio_to_list(folio, folio_list);
}

During memory reclaim above, only inactive folios are split. This also
implies that the folio is cold, meaning it hasn't been used recently, so
we do not expect to put the mm back onto the khugepaged scan list to
continue scan/collapse. khugeapged needs to scan hot folios as much as
possible priorityly and collapse hot folios to avoid wasting CPU.

>   * would this interfere with mTHP collapse?

It has no impact on mTHP collapse, only when all memory is either
SCAN_PMD_MAPPED or SCAN_PMD_NONE, the mm will be removed automatically.
other cases will not be removed.

Let me know if I missed something please, thanks!

>
> >
> >Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >---
> > mm/khugepaged.c | 35 +++++++++++++++++++++++++----------
> > 1 file changed, 25 insertions(+), 10 deletions(-)
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index 0598a19a98cc..1ec1af5be3c8 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
> >@@ -115,6 +115,7 @@ struct khugepaged_scan {
> > 	struct list_head mm_head;
> > 	struct mm_slot *mm_slot;
> > 	unsigned long address;
> >+	bool maybe_collapse;
> > };
> >
> > static struct khugepaged_scan khugepaged_scan = {
> >@@ -1420,22 +1421,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
> > 	return result;
> > }
> >
> >-static void collect_mm_slot(struct mm_slot *slot)
> >+static void collect_mm_slot(struct mm_slot *slot, bool maybe_collapse)
> > {
> > 	struct mm_struct *mm = slot->mm;
> >
> > 	lockdep_assert_held(&khugepaged_mm_lock);
> >
> >-	if (hpage_collapse_test_exit(mm)) {
> >+	if (hpage_collapse_test_exit(mm) || !maybe_collapse) {
> > 		/* free mm_slot */
> > 		hash_del(&slot->hash);
> > 		list_del(&slot->mm_node);
> >
> >-		/*
> >-		 * Not strictly needed because the mm exited already.
> >-		 *
> >-		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> >-		 */
> >+		if (!maybe_collapse)
> >+			mm_flags_clear(MMF_VM_HUGEPAGE, mm);
> >
> > 		/* khugepaged_mm_lock actually not necessary for the below */
> > 		mm_slot_free(mm_slot_cache, slot);
> >@@ -2397,6 +2395,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> > 				     struct mm_slot, mm_node);
> > 		khugepaged_scan.address = 0;
> > 		khugepaged_scan.mm_slot = slot;
> >+		khugepaged_scan.maybe_collapse = false;
> > 	}
> > 	spin_unlock(&khugepaged_mm_lock);
> >
> >@@ -2470,8 +2469,18 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> > 					khugepaged_scan.address, &mmap_locked, cc);
> > 			}
> >
> >-			if (*result == SCAN_SUCCEED)
> >+			switch (*result) {
> >+			case SCAN_PMD_NULL:
> >+			case SCAN_PMD_NONE:
> >+			case SCAN_PMD_MAPPED:
> >+			case SCAN_PTE_MAPPED_HUGEPAGE:
> >+				break;
> >+			case SCAN_SUCCEED:
> > 				++khugepaged_pages_collapsed;
> >+				fallthrough;
>
> If collapse successfully, we don't need to set maybe_collapse to true?

Above "fallthrough" explicitly tells the compiler that when the collapse is
successful, run below "khugepaged_scan.maybe_collapse = true" :)

> >+			default:
> >+				khugepaged_scan.maybe_collapse = true;
> >+			}
> >
> > 			/* move to next address */
> > 			khugepaged_scan.address += HPAGE_PMD_SIZE;
> >@@ -2500,6 +2509,11 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> > 	 * if we scanned all vmas of this mm.
> > 	 */
> > 	if (hpage_collapse_test_exit(mm) || !vma) {
> >+		bool maybe_collapse = khugepaged_scan.maybe_collapse;
> >+
> >+		if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
> >+			maybe_collapse = true;
> >+
> > 		/*
> > 		 * Make sure that if mm_users is reaching zero while
> > 		 * khugepaged runs here, khugepaged_exit will find
> >@@ -2508,12 +2522,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
> > 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
> > 			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
> > 			khugepaged_scan.address = 0;
> >+			khugepaged_scan.maybe_collapse = false;
> > 		} else {
> > 			khugepaged_scan.mm_slot = NULL;
> > 			khugepaged_full_scans++;
> > 		}
> >
> >-		collect_mm_slot(slot);
> >+		collect_mm_slot(slot, maybe_collapse);
> > 	}
> >
> > 	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
> >@@ -2616,7 +2631,7 @@ static int khugepaged(void *none)
> > 	slot = khugepaged_scan.mm_slot;
> > 	khugepaged_scan.mm_slot = NULL;
> > 	if (slot)
> >-		collect_mm_slot(slot);
> >+		collect_mm_slot(slot, true);
> > 	spin_unlock(&khugepaged_mm_lock);
> > 	return 0;
> > }
> >--
> >2.51.0
> >
>
> --
> Wei Yang
> Help you, Help me

--
Thanks,
Vernon

