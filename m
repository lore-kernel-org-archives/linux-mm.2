Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3A5EE9A04A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 03:55:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0A966B0088; Tue, 17 Feb 2026 22:55:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB7306B0089; Tue, 17 Feb 2026 22:55:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB63E6B008A; Tue, 17 Feb 2026 22:55:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 918B16B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:55:51 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 380FA1C3E4
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:55:51 +0000 (UTC)
X-FDA: 84456213702.17.BD39FA6
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 56361A0008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:55:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdhnnJb7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771386949; a=rsa-sha256;
	cv=none;
	b=lDLXx6vu7e5utPH89Et/ngkkJOqfPJ18Atuajlis/LBZEhn5K0jC3ZGLjY6s9LdLnZ8VJ2
	+3/OGBvjFgIUJIul5PzewUHm2Lp518XScVcrYU0qmtONun7W8utGcRbwIokTi5gxN8ISAu
	vaVquzLMMY2xElsvucIBzdY66C4KS5E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hdhnnJb7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771386949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4YO+h8rtqMr+abHp/0+y5ZSj0pAfx1sg/45nPs4WA4=;
	b=Hl1i2ch90380YXcac6Ke+ISap6nf0Zi6jfcwWKoOxDl/UvppYqovjPtapVVpnAYDuJz/Rx
	T89vv9NelcwTbBXKq2fbcbS4vXO8KgLLFuvfI3krV5NoMgaDmECncazilXTDR1SIBAF96j
	BjQRW/NytYv45Kb/b1D1laQglmsqeLw=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8230c33f477so2330804b3a.2
        for <linux-mm@kvack.org>; Tue, 17 Feb 2026 19:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771386948; x=1771991748; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N4YO+h8rtqMr+abHp/0+y5ZSj0pAfx1sg/45nPs4WA4=;
        b=hdhnnJb7e+3dFzr/kNpx/SyX7WVIa6KtTSoyeYQ1JSu9IgoSq/EVGLt3yzAU9ywJCI
         1JmEq+VkW2PmDt+bjkkaUi1yG12UvcCm1bs/09B8vfsBcsItH8i4zZ8RzYU6pYwUu3P0
         XBSltBoNLspRCnNVio2XwaU4ElSP8bokDxA9RbvaOYPf+aD5X9L4EeKGyTVG5uBfGMkT
         +5QjfwaJhGaeEvRU0srd+Uu19Woo3DElLe3jgrJlUr1huC6JZjNfPxvKirnGbDv9FZFt
         wIW4wTOXcr00+kzJoG4ZvT+IW0bwpRLw8ma1cGLjxZvj4ZAinxDbb8ZSBBzlXSyzjIQ0
         6JTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771386948; x=1771991748;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N4YO+h8rtqMr+abHp/0+y5ZSj0pAfx1sg/45nPs4WA4=;
        b=Z7qYw1oBsmnrXRKdahI9SJjaYMaZcn7tQrXBh2PFLBxFm4gxQ5UniApH5uI93EqwGb
         cRSiUbGceYSEuNaXcZZJCG/SGBH0uFiDjZYgbBapMHURXBJ1RoBJtRTmvQRBNZRVuUYI
         6pEsZwdPy+CR6SfE9vk/lJvvv0byvL/HdBsOK1kqBAyKG9RSchPWeyHxq3L0QGabNgtT
         1Ji7rva/3qGR4Y0dJQCtmEADPR8upnooY0mjhdFL27JzmHSbv1zShoY7ayhIPop2vafE
         5lJ+rLKe0Oghs+J2FtuhgAAFDIrvrlhgHXzgPEN+lq0PumjxF3VRc3JTF2xYe9vfxilg
         iiLA==
X-Forwarded-Encrypted: i=1; AJvYcCWCYS/BIUu9zpdRK/27vwzHkYSbt0i7KAa1c8aOSZnKLqYOcL8Slld6vn3ANWBi3WV7s9zzUOvXMw==@kvack.org
X-Gm-Message-State: AOJu0YxcwN2kDlS9tBBD4Rz+ccLl/7ZDZCrVhc3FROE1zkRvb3gb/5ha
	AD5Da/HEHzymIAE5DqGUiuxuDP3qKNqvWJDWFncNz4yUbdhO5AY81YGp
X-Gm-Gg: AZuq6aJtTU5EdX904XdRdJa3dcL0gXk78cwNYzgC3iiw0SQoNyOF09k4eSGR+Anmeis
	jbOLWkg+6pWdBILBG26IRoYj6V4gF5EzC/iaklCG0UjWWOYeL6tq6zXRf9FwfnK6LXI1PmBlT1y
	e0evI7mlV3A426l6PFj8vwi3/EGccpWk+eyT0wayGtVZfEX4weIbO+5+liTX5kWimKqo56PAHYl
	PJ1X+AVsmRxx8vLyL5ZfGzCW5gpNIfGMI6GAGviKcnNJid9zmFzoJ79oCyrUrpvxMdd25myHD5v
	dTIIIKY7YMhtOB2N3m1NRxHR43fF3mRxzWtTViE7v67LphsLzFUgXgGfo4y1sL5+jXcyjyx/qbo
	aZ7uHQ9lGtVTKguCfnxkQbAPdsnzJo3c1aUFU2+n6j19uXCJWqMIzrMh8wol0B0yvt/pI03zApt
	m160hX+4EFs2/n9KsT0taaggKzuiLx9/Vrn0uB
X-Received: by 2002:a05:6a21:115:b0:393:2434:683a with SMTP id adf61e73a8af0-394fc3218b3mr557987637.67.1771386948029;
        Tue, 17 Feb 2026 19:55:48 -0800 (PST)
Received: from localhost.localdomain ([114.231.118.96])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c6e531e6dccsm10739572a12.19.2026.02.17.19.55.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 19:55:47 -0800 (PST)
Date: Wed, 18 Feb 2026 11:55:39 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org, david@kernel.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH mm-new v7 2/5] mm: khugepaged: refine scan progress number
Message-ID: <4qdu7owpmxfh3ugsue775fxarw5g2gcggbxdf5psj75nnu7z2u@cv2uu2yocaxq>
References: <20260207081613.588598-1-vernon2gm@gmail.com>
 <20260207081613.588598-3-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260207081613.588598-3-vernon2gm@gmail.com>
X-Stat-Signature: tikjj84fbkyfudihb6u53rzeyxe4jfr4
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 56361A0008
X-HE-Tag: 1771386949-304694
X-HE-Meta: U2FsdGVkX1+dElzzLnEAk2Ju+PUGvBt8YU+RvxigJH/7hzuE0XNbsL+8Dxrg0vuPZ+SRGt03LgzcdKDx9nwdLWZx+ZZZzE0q7r98Zdn19gse1i/J16uIwmtAlEeVj6akI7cox6eEWWL0Hs2RDXr+BPcFit/7flIVi7UjRWuHnrri0kIhejssxFedLUr1fw0zkqyUGdbPtj16Cy69XUQx69nQDIVnQGHSYmngvNvIRk3TVDa2p50cwidmY7+MNIG/oc2nXGn//UfJmC/N6O/RXUU5zhFtnCxl82DzFuqpisaL0Tax/wMPe3DmvkpDbyAjttR0Hfba6V9dTPQ3y6dyA2ZysB78HGPq7RRahAhk/6qA2LWjjQZRx0n4bkMsWGGXQg00pxxYu5ql6hrS0WtNX9YOTH++QGQDteDdc/GaiD+gvbdvJYMJtsZI2+B9ubEyovx6pHIfi/qUgCourvb1D3dJWiEJz+QFHJ2WuQ4pb1WF4iACaZM6U+tfzjEssbXl82eUlPGVI0KZAlUA1Eibrvautsb0VLs6zMbCZoLUr3e54CW2idVVnQnlhyf75BUwngiT/9uvm2zm3bBqOP8iVGg6ifMZHs10reYW+2U1J5m4OoqhkL35DOPGLDNchjhgggRo2apCxAsiWrfbMnVwpRrLrT3/2jgDzEmLbb5GjZ6PcX6+pKEJajm2EOSrv6uqoBXgPumAnoe3A7odvyxRbavin/QyTmFcHMhPoqQLWuoEP+MhHIx4VpBUohAl1j8auZqPcfW5zMkr5AhtMgsth5xtDLDJgm1TmwPiWjn6gDGyTyAqSrjXKq3VrNKuCxGALoSv23ZIere/JMIBt/vqXlx2QrZ82tkmdoIielnhAc9aPr0KAheoUmsNDTdjitX2X/ZMlto/AmOXlf/EN00VjlLm9JiNfoistxnPLNN94x/Kh/ohQ5o2c8nNUFgFfD/ZrJfoDduJzC6APr7c3sa
 Btu0+BGP
 NcZWnP5BSSbLBmn54DS9PPxWq75zKbpYCg1vupzK0NY6gUDTtmVaPIeN6dZS9SlLzOYo3rwsInN5r4eygBBkkAZZ+QRZCVHr1XWEhIJIu0s/4UZlt5AuCpG18ZGe5uSymzhjf/TxTS869fqhhXewmDVyLhGGEAQlzYsSWI7/FNJp7C6FJHNEuNvIhBg67P4L93QaQwqibmWeXeAlJJxiaboSc6gH/ibKrwUz9WXWv+szIPffZEWlOGTFw02Wgx/55jomHG31pQDg7jibnU+yMVcMmXzwe/jL7qiwUmuRrhcqgfMxmZhgWdemdcGUb2uuzqka0YM08ZmijpxvEQm1R45+jwT8u6JUZzlfV20a1jis+OhAoasIo9RENJZ4SUKRmyWseEKXx5yyvNKamEbPhSd5OUhO4RC3+B7Gw5+gv2kdjzS/N+6/8swRaHwwujOm3WNEju+DT7EqhSJkilpY93C4YPm25KKE7OqO7c2VEJk49faVgmOCdzpaD2AKGxYgqfjnPYCsCf2NJyxCUht4+FLfsvIC1hmnVyRkXuMmRl3eVqXc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Feb 07, 2026 at 04:16:10PM +0800, Vernon Yang wrote:
> From: Vernon Yang <yanglincheng@kylinos.cn>
>
> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> even if only scanning a single PTE/PMD entry.
>
> - When only scanning a sigle PTE entry, let me provide a detailed
>   example:
>
> static int hpage_collapse_scan_pmd()
> {
> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> 	     _pte++, addr += PAGE_SIZE) {
> 		pte_t pteval = ptep_get(_pte);
> 		...
> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
> 			result = SCAN_PTE_UFFD_WP;
> 			goto out_unmap;
> 		}
> 	}
> }
>
> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> directly. In practice, only one PTE is scanned before termination.
> Here, "progress += 1" reflects the actual number of PTEs scanned, but
> previously "progress += HPAGE_PMD_NR" always.
>
> - When the memory has been collapsed to PMD, let me provide a detailed
>   example:
>
> The following data is traced by bpftrace on a desktop system. After
> the system has been left idle for 10 minutes upon booting, a lot of
> SCAN_PMD_MAPPED or SCAN_NO_PTE_TABLE are observed during a full scan
> by khugepaged.
>
> From trace_mm_khugepaged_scan_pmd and trace_mm_khugepaged_scan_file, the
> following statuses were observed, with frequency mentioned next to them:
>
> SCAN_SUCCEED          : 1
> SCAN_EXCEED_SHARED_PTE: 2
> SCAN_PMD_MAPPED       : 142
> SCAN_NO_PTE_TABLE     : 178
> total progress size   : 674 MB
> Total time            : 419 seconds, include khugepaged_scan_sleep_millisecs
>
> The khugepaged_scan list save all task that support collapse into hugepage,
> as long as the task is not destroyed, khugepaged will not remove it from
> the khugepaged_scan list. This exist a phenomenon where task has already
> collapsed all memory regions into hugepage, but khugepaged continues to
> scan it, which wastes CPU time and invalid, and due to
> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> scanning a large number of invalid task, so scanning really valid task
> is later.
>
> After applying this patch, when the memory is either SCAN_PMD_MAPPED or
> SCAN_NO_PTE_TABLE, just skip it, as follow:
>
> SCAN_EXCEED_SHARED_PTE: 2
> SCAN_PMD_MAPPED       : 147
> SCAN_NO_PTE_TABLE     : 173
> total progress size   : 45 MB
> Total time            : 20 seconds
>
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>  mm/khugepaged.c | 38 ++++++++++++++++++++++++++++----------
>  1 file changed, 28 insertions(+), 10 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4049234e1c8b..8b68ae3bc2c5 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -68,7 +68,10 @@ enum scan_result {
>  static struct task_struct *khugepaged_thread __read_mostly;
>  static DEFINE_MUTEX(khugepaged_mutex);
>
> -/* default scan 8*HPAGE_PMD_NR ptes (or vmas) every 10 second */
> +/*
> + * default scan 8*HPAGE_PMD_NR ptes, pmd_mapped, no_pte_table or vmas
> + * every 10 second.
> + */
>  static unsigned int khugepaged_pages_to_scan __read_mostly;
>  static unsigned int khugepaged_pages_collapsed;
>  static unsigned int khugepaged_full_scans;
> @@ -1240,7 +1243,8 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>  }
>
>  static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
> -		struct vm_area_struct *vma, unsigned long start_addr, bool *mmap_locked,
> +		struct vm_area_struct *vma, unsigned long start_addr,
> +		bool *mmap_locked, unsigned int *cur_progress,
>  		struct collapse_control *cc)
>  {
>  	pmd_t *pmd;
> @@ -1256,19 +1260,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>
>  	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> -	if (result != SCAN_SUCCEED)
> +	if (result != SCAN_SUCCEED) {
> +		if (cur_progress)
> +			*cur_progress = 1;
>  		goto out;
> +	}
>
>  	memset(cc->node_load, 0, sizeof(cc->node_load));
>  	nodes_clear(cc->alloc_nmask);
>  	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>  	if (!pte) {
> +		if (cur_progress)
> +			*cur_progress = 1;
>  		result = SCAN_NO_PTE_TABLE;
>  		goto out;
>  	}
>
>  	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, addr += PAGE_SIZE) {
> +		if (cur_progress)
> +			*cur_progress += 1;
> +
>  		pte_t pteval = ptep_get(_pte);
>  		if (pte_none_or_zero(pteval)) {
>  			++none_or_zero;
> @@ -2288,8 +2300,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>  	return result;
>  }
>
> -static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
> -		struct file *file, pgoff_t start, struct collapse_control *cc)
> +static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
> +		unsigned long addr, struct file *file, pgoff_t start,
> +		unsigned int *cur_progress, struct collapse_control *cc)
>  {
>  	struct folio *folio = NULL;
>  	struct address_space *mapping = file->f_mapping;
> @@ -2378,6 +2391,8 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>  			cond_resched_rcu();
>  		}
>  	}
> +	if (cur_progress)
> +		*cur_progress = HPAGE_PMD_NR;

Hi David,

When using Fedora Server, I found a lot of SCAN_PTE_MAPPED_HUGEPAGE.

The following data is traced by bpftrace[1] on Fedora Server. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PTE_MAPPED_HUGEPAGE are observed during a full scan by khugepaged,
as shown below:

SCAN_SUCCEED            : 1
SCAN_PMD_MAPPED         : 22
SCAN_EXCEED_NONE_PTE    : 67
SCAN_PTE_MAPPED_HUGEPAGE: 919

I simply handled SCAN_PTE_MAPPED_HUGEPAGE by "cur_progress" equal to 1,
as follows:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 437783cf2873..7f301bebfb11 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2405,8 +2405,12 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
 		}
 	}
 	rcu_read_unlock();
-	if (cur_progress)
-		*cur_progress = HPAGE_PMD_NR;
+	if (cur_progress) {
+		if (result == SCAN_PTE_MAPPED_HUGEPAGE)
+			*cur_progress = 1;
+		else
+			*cur_progress = HPAGE_PMD_NR;
+	}

The below is some performance test results.
kernbench results (testing on x86_64 machine):

                     baseline w/o patches   test w/ patches
Amean     user-32    18633.85 (   0.00%)    18346.30 *   1.54%*
Amean     syst-32     1138.82 (   0.00%)     1109.68 *   2.56%*
Amean     elsp-32      669.60 (   0.00%)      659.79 *   1.47%*
BAmean-95 user-32    18631.33 (   0.00%)    18340.10 (   1.56%)
BAmean-95 syst-32     1138.36 (   0.00%)     1108.05 (   2.66%)
BAmean-95 elsp-32      669.55 (   0.00%)      659.61 (   1.48%)
BAmean-99 user-32    18631.33 (   0.00%)    18340.10 (   1.56%)
BAmean-99 syst-32     1138.36 (   0.00%)     1108.05 (   2.66%)
BAmean-99 elsp-32      669.55 (   0.00%)      659.61 (   1.48%)

Kernbench performance improved by 2.56%, so we truly need to address
this issue. I will fix it in the next version.

If I missed something, please let me know, Thanks!

[1] https://github.com/vernon2gh/app_and_module/blob/main/khugepaged/khugepaged_mm.bt

--
Cheers,
Vernon

