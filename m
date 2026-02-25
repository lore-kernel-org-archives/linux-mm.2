Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6630BFD3764
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:25:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D1E16B0005; Wed, 25 Feb 2026 09:25:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 855796B0088; Wed, 25 Feb 2026 09:25:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 736C06B0089; Wed, 25 Feb 2026 09:25:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E6566B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:25:51 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D612113B401
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:25:50 +0000 (UTC)
X-FDA: 84483202860.16.191C029
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0BFA3160007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:25:48 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K0zY4OFK;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772029549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NwUCMoDfXb+FfVahgVkaRmwo6NUaajkhBRxUYgla81A=;
	b=u6dqw2aJ6brflDW385L8d83nPos2Y/K147WZlBEiPuoorpoyGn/vPwx/viqPqrV5wwlYsb
	vUASs8EtZHx2t9miB66djOMR8XILMVBVzrrwu3J2fQMHvtV80Yf+S0KTXdEk8+FjInntdq
	yy1bF62caqpqbouUz+1inTDeGWivqIU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K0zY4OFK;
	spf=pass (imf08.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772029549; a=rsa-sha256;
	cv=none;
	b=E8HG9qxIdLJ4dyNxcOykHTq0oLArAKHOeQSxMxA1hve/EczdQHqMZqrhZBYoFRZlbMKQjw
	M0p3rPHwZXiR0RsxG+ahns0ZnNQRaA8hhKsbj1lOJwd/S3iKlf4h0VCErvLa3Q6WMB2qKJ
	U5tNxtDOw3vU/OQqzSXo5mbD/DMM33k=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2a7d98c1879so43622585ad.3
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 06:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772029548; x=1772634348; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NwUCMoDfXb+FfVahgVkaRmwo6NUaajkhBRxUYgla81A=;
        b=K0zY4OFKRP70cmzUh+4XKCP4N8vjO3OHYCSQ5oZlc7S9ASlkNzCe+sUee9RLIcmcPj
         wr9eBT4GaVKlNgOzB6D/ge2Off0FN77WpVuuiGwtIo9BtZiN+CO6cHbKc1sZCVKi/X4S
         3vwOYRsKRqcweCwaT4fAzvPCDShdJQMzVoDFjp+kRHvWRnNlMVXnaKU/nLWzI/80c5YD
         KoxFITImfRzzjXRBNsOGEZuloq+VUGq8WEGcjS8M3qhOEVnHW+kdt26nfXBMlkbEZvW7
         McuYvMhT2WOU4N9hklz2JGWYtpOPEuxowTNJZnGrRflDiCS4/QpLSIt9ABrKUKi8Xbg8
         OW3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772029548; x=1772634348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NwUCMoDfXb+FfVahgVkaRmwo6NUaajkhBRxUYgla81A=;
        b=X7zIZLbH6+81h2fiUNgnb1wjNty7zKocLU4zt/rmv5oKakIIILMDvkHthdLRgmOljJ
         26vg8aLHpRdq3j+6Y8+kSiwxCKIYGHdgO3IhSn5eLimW1sNeJO5qAHPXbCr8FHCFQq1t
         vMI4W/davs5KStfJyns7b3O5hH3cEDBkWkJQFeFEfIB/xsfej3GZG4Ygd8N+GIIuBYBX
         2UTnaeIgh+6a9oWUg1q2gXGeERH09lTcK6LK3g6cg8H7ZYjkFW0weIS86Pb5rHfwvsLP
         XF+KOIiJOGxei6FKvyNr57VtAj+fgK8zSt0y+Y4+P95pB4J9QfhV+0WlmOtzM/EAtOll
         n0Lg==
X-Forwarded-Encrypted: i=1; AJvYcCUPMivHDvlEWqGjnvk0KOXV+WhrIvsCqYmwq6LqgMqXD2flE+CwXEoQAG9O4AYZtEtaYxK6a56uXQ==@kvack.org
X-Gm-Message-State: AOJu0YyI7/numWh2+kSmTnoMyuTxOSCiZl6wXFkSyy5xGZd4Ipl8aXjV
	ooXXqQkoGsJ4XfBkvSi5Vy+i4tdP5VzrHsIgJR9QfMb+5OwqopoB+Lvy
X-Gm-Gg: ATEYQzxzASfuCGet8BYBmQXpE7AiIRXtY5xKfDn3fnQ4VwhgsIs1Hv1DhWiXF59ziP5
	XukkOl3ErW9XKEvn3H6OgxQjgJwq1pV9nhl81VPuluGoIVm8NK9BDqBgTKP4CMZ0SEjnpcQJ/4Z
	L8u7XafQ4sI0EMxy2zSiFKbhcDRL2wQDFa4Fm6TPjvBuHg64MLmH4KRGbRIIdAv7S9+EEN/JpRt
	/62KNO5+I5M2ty9hNos9ttO1uCquk29fH9SI/P2CiEbHySLPrOZ9TjdpOF9bvdo9SmzscTqMqgI
	/4aYuiCIryi3cEbzpL+Vdpmf8hziZQyCDVG27npiUTZVW8sJHkQQnBzHgjuLcqvz8TmI3kdu2j3
	LGTxpAIY9sGMdzfoLL87Bw47ebsjzB/AYFlSsjqzUuIGPelQg4ecgkDKIWx/K8kLETGWqvK8TWR
	rXY4fj7/MTzOfUVWuFG7NryvDJJcI2Oghg
X-Received: by 2002:a17:903:2c08:b0:2a0:b467:a7cf with SMTP id d9443c01a7336-2ad742b9cc1mr141048865ad.0.1772029547553;
        Wed, 25 Feb 2026 06:25:47 -0800 (PST)
Received: from localhost.localdomain ([49.79.21.101])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ad74f637easm136460575ad.37.2026.02.25.06.25.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 06:25:46 -0800 (PST)
Date: Wed, 25 Feb 2026 22:25:39 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: Wei Yang <richard.weiyang@gmail.com>, david@kernel.org
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v8 2/4] mm: khugepaged: refine scan progress number
Message-ID: <zo2o25tesjzdvxdbjo6rc7crqmf76z5zwlykrnvhydaowgngya@hv3vgfa7zcgi>
References: <20260221093918.1456187-1-vernon2gm@gmail.com>
 <20260221093918.1456187-3-vernon2gm@gmail.com>
 <20260224035247.r6mxsfcpiev4wnce@master>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260224035247.r6mxsfcpiev4wnce@master>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BFA3160007
X-Stat-Signature: 5zoi9ppawdmb5ta5tyukawju88kasqhz
X-Rspam-User: 
X-HE-Tag: 1772029548-649936
X-HE-Meta: U2FsdGVkX1/1LdcLqU1K1n4HM4CEcQx8oF3VNRjeuTKZ9DTc7dPd1ppppMgQvnufSBh9xxfRNLT/0Vv4TravEhBxr9GOr4PtSxISUn6ftszUcs5TZEgpY8Ol0fw/p8tTXgUw/nSZHGcX9bXlq1EFwuINnK5WgrDok8zx9Er7QCpwe76X28rlQmLYLbAI04juPt4X2GZbTFJJ/E+Qa3FiFr1ZTbMT8+C7iQ+9DGWJ9Gbe8mce5qFv0EP6++JSbFG65Zyfyg+QlpRLsxi7JYjapzstFqL+9VtkdvFzRuPJjFge/5vUOcyvQ9O1S6lVpo251THtDwutEdPhdcyV9Dhnr1Z4GkRG69X29Kj+acUTxfLMSi4yhC8iD2sd0ZanLznA8H8N0OITSj5kteFv6U70Om4KonTwUhuBGtA+4kO2HqIckEc72+j9B3se2aR3SxsUSrNxayiNS6Xjo7yeIsmqGSJfnm6DpWDLbs9QEjhUbjgfaZ2zxB1/uyBhW8u/W6YffLhrdEb0sKFo91dFzmsb1cl3SLAUrIAEnEIJYBjgn8Ssoy96C0PQVdVDoI2EmdhVkQGzkYZ902cQHRewKRgQ7YM+pWRljrdhDq1C9VXnCivhPUqWG3JLiurW7uobnS1F+7DtTszU06wwYSNKHrXG2koSJ0AO6pvAtOPZeY6H2JqJrHs6XvDeVqQN93ATliETkNCEM62J4UplAfYJWDxjKeYq39htmE2Qny3wiIsvng0qAII6Xv+FQvNfHUEWDFGdK0YbQyWmPJ5h83b5+jLq84h+mmJN81KhAs6H1iu7G+Okj98J3mDoLjq5xFNaash3bIeg++/TGiRqOOT53Twzxxdo5Gz3Ba3Ekxu1QFUa/RNtLTtiCJv5FRvTRRjxassDBPcHqIcPniktwknvrsCE+2tKhzAmHnTJd/l0IEemH1LXwa4Tx//9sUkwqHtG1T5B63HEjSSi+szGnyWO8rp
 hF0a952z
 xk60uSr6zV7YB5scszDvrOz0fCwgxXMs6JaSaWD1GAflYCMMSrafY40jkHikmMmxacFl2sn54bq8vyTNpTEZYg7bcanxx+hC0PvbGsG0YudVR/JWDHLrHqJuvn9CnRpljlcVMjbImQQY+lTUJ85kkrxuUvSLw6keYR4q3i80bjG0MmIKmCEgpmR9UIlax31ZjgEwvj6+wkiYn6dkgFGBstn2ZfwTgscLdpe7MjxaThAlXCoT2SuGDYLGdMloksiwnanFvjEpoGUzIHR7u09x8yLHVaOB3SnX4dKUuJKBd2OdX8ZaXXdWKxQx1SBGFsTI1osL1swACqQoGimWB5ut1O0GtSlAvSyO+ocaui6K/JAgWnpeoTT2zNJIXmjCDwKUw8oVCdv99AXQsQqQ+ETlbt6MwUgLRNZVXi0/ED7vgLhRJLsrKGd7xdaSUA8czFih6nyr2whISOqq8nBfo8LTUtb5+yeqrrKDZG6eqGoi44cxn1PLmnhtZnMX07I5kocpSkpfascn3GHyGGb+aMMbbzLnSHrgm4MLixeY0lBqrKLt3ykSHQuhOd1yuB9Q647AKsxzY8ZtKZiQMPp4hmfpn8seGmwAYgAw9bLMv6NsqU8sB6j42MMRiB1hIMlQU1mYa3+ypBqppkj3fIFlX0kteIQLN0Or6pIY+HCJI6B2bBNzKF9s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 24, 2026 at 03:52:47AM +0000, Wei Yang wrote:
> On Sat, Feb 21, 2026 at 05:39:16PM +0800, Vernon Yang wrote:
> >From: Vernon Yang <yanglincheng@kylinos.cn>
> >
> >Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> >even if only scanning a single PTE/PMD entry.
> >
> >- When only scanning a sigle PTE entry, let me provide a detailed
> >  example:
> >
> >static int hpage_collapse_scan_pmd()
> >{
> >	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> >	     _pte++, addr += PAGE_SIZE) {
> >		pte_t pteval = ptep_get(_pte);
> >		...
> >		if (pte_uffd_wp(pteval)) { <-- first scan hit
> >			result = SCAN_PTE_UFFD_WP;
> >			goto out_unmap;
> >		}
> >	}
> >}
> >
> >During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> >directly. In practice, only one PTE is scanned before termination.
> >Here, "progress += 1" reflects the actual number of PTEs scanned, but
> >previously "progress += HPAGE_PMD_NR" always.
> >
> >- When the memory has been collapsed to PMD, let me provide a detailed
> >  example:
> >
> >The following data is traced by bpftrace on a desktop system. After
> >the system has been left idle for 10 minutes upon booting, a lot of
> >SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> >by khugepaged.
> >
> >>From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
> >following statuses were observed, with frequency mentioned next to them:
> >
> >SCAN_SUCCEED          : 1
> >SCAN_EXCEED_SHARED_PTE: 2
> >SCAN_PMD_MAPPED       : 142
> >SCAN_NO_PTE_TABLE     : 178
> >total progress size   : 674 MB
> >Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs
> >
> >The khugepaged_scan list save all task that support collapse into hugepage,
> >as long as the task is not destroyed, khugepaged will not remove it from
> >the khugepaged_scan list. This exist a phenomenon where task has already
> >collapsed all memory regions into hugepage, but khugepaged continues to
> >scan it, which wastes CPU time and invalid, and due to
> >khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> >scanning a large number of invalid task, so scanning really valid task
> >is later.
> >
> >After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> >SCAN_NO_PTE_TABLE, just skip it, as follow:
> >
> >SCAN_EXCEED_SHARED_PTE: 2
> >SCAN_PMD_MAPPED       : 147
> >SCAN_NO_PTE_TABLE     : 173
> >total progress size   : 45 MB
> >Total time            : 20 seconds
> >
> >SCAN_PTE_MAPPED_HUGEPAGE is the same, for detailed data, refer to
> >https://lore.kernel.org/linux-mm/4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq
> >
> >Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> >Reviewed-by: Dev Jain <dev.jain@arm.com>
> >---
> > mm/khugepaged.c | 42 ++++++++++++++++++++++++++++++++----------
> > 1 file changed, 32 insertions(+), 10 deletions(-)
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index e2f6b68a0011..61e25cf5424b 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
> >@@ -68,7 +68,10 @@ enum scan_result {
> > static struct task_struct *khugepaged_thread __read_mostly;
> > static DEFINE_MUTEX(khugepaged_mutex);
> >
> >-/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> >+/*
> >+ * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> >+ * every 10 second.
> >+ */
> > static unsigned int khugepaged_pages_to_scan __read_mostly;
> > static unsigned int khugepaged_pages_collapsed;
> > static unsigned int khugepaged_full_scans;
> >@@ -1231,7 +1234,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
> > }
> >
> > static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> >-		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> >+		struct vm_area_struct *vma, unsigned long start_addr,
> >+		bool *mmap_locked, unsigned int *cur_progress,
> > 		struct collapse_control *cc)
> > {
> > 	pmd_t *pmd;
> >@@ -1247,19 +1251,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> > 	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
> >
> > 	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> >-	if (result != SCAN_SUCCEED)
> >+	if (result != SCAN_SUCCEED) {
> >+		if (cur_progress)
> >+			*cur_progress = 1;
> > 		goto out;
> >+	}
>
> How about put cur_progress in struct collapse_control?
>
> Then we don't need to check cur_progress every time before modification.

Thank you for suggestion.

Placing it inside "struct collapse_control" makes the overall code
simpler, there also coincidentally has a 4-bytes hole, as shown below:

struct collapse_control {
        bool                       is_khugepaged;        /*     0     1 */

        /* XXX 3 bytes hole, try to pack */

        u32                        node_load[64];        /*     4   256 */

        /* XXX 4 bytes hole, try to pack */

        /* --- cacheline 4 boundary (256 bytes) was 8 bytes ago --- */
        nodemask_t                 alloc_nmask;          /*   264     8 */

        /* size: 272, cachelines: 5, members: 3 */
        /* sum members: 265, holes: 2, sum holes: 7 */
        /* last cacheline: 16 bytes */
};

But regardless of khugepaged or madvise(MADV_COLLAPSE), "cur_progress"
will be counted, while madvise(MADV_COLLAPSE) actually does not need to
be counted.

David, do we want to place "cur_progress" inside the "struct collapse_control"?
If Yes, it would be better to rename "cur_progress" to "pmd_progress",
as show below:

struct collapse_control {
        bool is_khugepaged;

        /* Num pages scanned per node */
        u32 node_load[MAX_NUMNODES];

        /*
         * Num pages scanned per pmd, include ptes,
         * pte_mapped_hugepage, pmd_mapped or no_pte_table.
         */
        unsigned int pmd_progress;

        /* nodemask for allocation fallback */
        nodemask_t alloc_nmask;
};

--
Cheers,
Vernon

