Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EAA1D5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:30:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4F3C6B0089; Tue, 16 Dec 2025 01:30:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D28E46B008A; Tue, 16 Dec 2025 01:30:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50266B008C; Tue, 16 Dec 2025 01:30:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B05646B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:30:33 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 487D78ABEB
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:30:33 +0000 (UTC)
X-FDA: 84224360346.21.471711D
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5276980011
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:30:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mXGzP5jW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765866631; a=rsa-sha256;
	cv=none;
	b=EZPHArmZnScgmUyYVMBdT8C2wXpBbMDmSHPgF1fv2GjGr/GXhXJQY2W159bSAT6kpqx5de
	nnHMHdVno2R3s+bILDdzgJmttMIy/ya63cHCMvFbj9D7bS9zpvDeqzDqqSTRGCDa9oiz/L
	rFf68AvsAQnIK3ESy/xP400Vcp8jPp0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mXGzP5jW;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765866631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6hz9jdXtFMh2qAHrt6NkjlTikBzsrAftSe+xfn1Yjs=;
	b=TtE7faYuEIMXXuKLj0Sze6rB4Fcscq97MA5/5EMNb9SeO6w4cUchxKDpISHCtgjID7Tg0a
	geQ/A0lhutEc2V4kCZQDozeeeMxIt0HMNuG+dBJhEq1/lI2obMWUxajW/kmbWT1Q9tDQVE
	PSnaVGlgOC03fotSl8cyCj0Km0wKKIQ=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a07fac8aa1so31119725ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 22:30:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765866630; x=1766471430; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6hz9jdXtFMh2qAHrt6NkjlTikBzsrAftSe+xfn1Yjs=;
        b=mXGzP5jWX11oO4zJaTkGlvH5nxAt6aEAvcLH1+Z/NI6xsBECiev23SjJ5ZvdDbeXW6
         fcO7LIyRhBjFhRXuLw33sViqd2ZYZcyYOh76ldo0/7FYY4qaJoIrRKqyeJo3+/atlZbT
         Ef/6GpG64SAyhyVa+hCXLWOWqUxIeqV/yrAl+PNpcg/nsQNeNxyTWiMn3pHlGpdVxhYM
         DS0FYqnT5++NRbjxu7quxVcmQxFMnbvyeJT+wqh+9Zz7vL1IqTd0Nt1HPzLivIUv9icL
         2Zp1tYRn4325esbBhw0hc8ozzkjyNSC7JSDxX5GW63rNomPZS+hxRhTvEpz23qWtvPU4
         cgPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765866630; x=1766471430;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y6hz9jdXtFMh2qAHrt6NkjlTikBzsrAftSe+xfn1Yjs=;
        b=qNM9nxO9Ep93C164z/Gg7pgLO6oVJ3oc8Hzdsj6FXHpyzb0vLFaLo1vt2Vt35+mCPP
         71iviFF25g0o+/F6kEhPerklQEIA/YrXHIzdre/aaOUx3poqceunHqqiQUueOA14LJHe
         Y71TOrsQuwKHAwHUkdHdLuf57szJNX0Rv6BbO7ZvtsaQQflU/zyrw6WrtAHAw+a1S4/0
         pmtshuAKBX0jTmkezJlGZI/ZkWBWavpwgyMZgQzlRV/OIr104jPJI0MsTANDY1alo4KF
         riJzFKxkQWy2qIDs3T3P1ODMUzjmFdt5tefkdtCXSBtGA15hvCxpX9TbOeYdYrg33mGx
         6XwA==
X-Forwarded-Encrypted: i=1; AJvYcCXER9sNPh0xvwQZ2hptvQR7S8nCVJOB091iM6ibr0sCjckOEuQwisuLnwsrkEtxSJlOJCYMIScFJA==@kvack.org
X-Gm-Message-State: AOJu0Yylz7zjQYpzi6rw1iup1L4Pc2p7smBUEmVajMKHAXcin1ShdN/a
	byLlgoIFrBTrdSpuhZn9PgZujM5MjP1geJEQ6KSZvOHD8JP8B9hdu95+iTc2rdpB
X-Gm-Gg: AY/fxX6nH0VqRAC3yDQWILodK8kM+Sg+RID6BWCInPcl7ryleDe+bDw1PpXvVjwlASq
	I1CthaF5fwN31axDgh46hmBBZ1ccQjtEFI1ONSyU0xgeXpLOc2yPmrHC322qmVk9r3+ffJxQ82/
	RcjOnH6Hux9aJ6xL5xDT1D/yAmhrtR7wbOZIwjZEAa2g4HEVDgfmMAV7mp5lRPfIcJ0b2NUWVDk
	A24zFrXnpr6DcbRFgRu3eeb1QpvZW5kVSzdiEpRFscikP4sT1NhdT52UO2iSDvz1Ke97Y+Ljrpn
	+6xydFbaRXrnKp/XTdHC+j+oBevaIGNSQF7FXMa2Hu1AYD5VZhSoBqz2egrZnS2jZfNTtMvmoX8
	pwCCe8GrV+9xKkMnRKXPk4wnySGnDJfCIOxFKmPmO7EzNb0RxbhGNSjMFiahC7ybBrdPlfTJJUa
	N4ClJYnNaBb+zk1TLVtDASOFTB
X-Google-Smtp-Source: AGHT+IEolo+n77ASckTX3/EY5JIe/RABcbNjmNYeXvNzTrdbM79wggS/bRbZ+AJ+1vYZfzhSRF9log==
X-Received: by 2002:a17:903:f90:b0:295:b46f:a6c2 with SMTP id d9443c01a7336-29f23c7ba77mr135454575ad.37.1765866629767;
        Mon, 15 Dec 2025 22:30:29 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9d38b98sm154247525ad.34.2025.12.15.22.30.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 22:30:29 -0800 (PST)
Date: Tue, 16 Dec 2025 14:30:20 +0800
From: Vernon Yang <vernon2gm@gmail.com>
To: kernel test robot <lkp@intel.com>
Cc: akpm@linux-foundation.org, david@kernel.org, 
	lorenzo.stoakes@oracle.com, llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev, 
	ziy@nvidia.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
Message-ID: <x2675vjrcxax375coeazrvfegtxasr74saf44mrb4npf5cgdr2@cg7gajuen7ni>
References: <20251215090419.174418-3-yanglincheng@kylinos.cn>
 <202512160533.KuHwyJTP-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202512160533.KuHwyJTP-lkp@intel.com>
X-Rspamd-Queue-Id: 5276980011
X-Rspamd-Server: rspam03
X-Stat-Signature: 9jqijysr3cz1rafu3dhp8m3fxx8opsy8
X-Rspam-User: 
X-HE-Tag: 1765866631-67642
X-HE-Meta: U2FsdGVkX1+UTYzwTosqBDuQq2KDcjvHWgk16wxe3yn8kc6nkhSZgB8nL5ImoOCiJpe1NyE7CdXm18W48TNRfi6mmjhUoKgNdXtgzgp6LjZVxNXKx9jcZIZcbTz9ctC7wlSSP1HBLLEieWvZSow8OwSasUdZ8wK/1NH9zYYqot9X2GroZ5Eai19JAy0zyz6lvOzmI8kPlpdGpovOu4XDfoL8xbYXq63Pnb9TPbuhOTqZfWQ5v0jUkGzstp8ZsweZIMX25WXDd2lbv7TpX3lHQhui6m7aQAu3k+1jVDK6PMeZhMUrnVVagUq9oEB78BUUzi9znyApeZwXaORhUTvYClHSloLgveyL+x+V4/n/SfwnvDSO1Ey+qJ3LIBgWHIHOsAzzUF3NnPuFsAlWl2QOl1VxGif/zeQFkdrrjmkZZY+fEZeW3p3Hdk1fjbwbysJ2R6KNXYK430zVtuNAB91J1obiBSKpMGNVcrsj1jcfTA0HnVFp8O0RDfn5clk3yywTSSZl+OUZ9kOu4a/vIyo97UB+R9WWXEnf2FyM5jJTrDaLH61CosUqGLT6Xll7kXe464/uGtNK651SSsRkmY3Wjya3Gyblk28HkpU9cuJOlOzR0/Bk97X8+88Rs/0eM16H1u59rVgj+pgbCuKbx5cPMUKZhuS/EcSfTSN//27f0nis5jhMbQ4C259+CH7WEuH/CbwvIHUwtPP6oIS/MbZ9+aFcwsByFryQJsKtPgg39GyTywyCdL2YaSNIlnt2ztL3QKwRMFkfdxEwwV3HXK9uCmVF7rIyrDlCOJzOd7+PXMfCAgEU1dk7Ys7+mAYtBVAZn2255vQRE6PiS4DU1dP2habzhyKe61cvpj7r6xGqtPfoOcJQsJ6eYo++acx46PhwOunN1Ejtq/g7DguTKqnVxvJIsSAI/dKmAOpc3V6KoQWmmCJ/TVAidIOzaie16eKGMMqrCWkt3wtuWrDFxFr
 nOn0f/Tc
 VcTm+Mu0cDYMRdkSpyO52YMt4N/gsbMnDOhidfplRUamHCg9H80JWvfmWBcPCrszEU9d7tIKPjdWbne5d/JUUg9xBBWHD9JZNOeL6JsGXvuNBMIAJnPKPMlDIPBhPPaDaHOoUNyfjlBGwdMfaSdCHRixHL4bMqYV97SlFKoGqn0e3E+vVL8uQ1ktWciR5JpvzBedIo+1tlSHBhcjalsCW87ScMkqJ5tETtsTfjBCvjl8lnZ7u+Ln9AxGECsU5T+8HcX8uWpk4TUKw4mxfeHt9+eBHBAAcKDRnVrKnOmMnOoU1kvrzZNgjlwepXNT10XO/RZqVmTWgAEn7vhxEDLwu4iX3mcgCoYoihx4olzBQzSYlN6hFtGNbmkfKmzEBLDe2x8RW5z0fbNc2Yn/Df9xUYV7LqS4ck1pJdU0MGKJprpPakYriczRI/4WY50Z8biUtmDJKHZ+H/765SoV93aqeU0hzNn1izSETNxSwyhlL0MB4G9ZgQzDMaUf/8W/9UieWYL+h6JltkPaLvnzaQn+n4Icd7AuMFBmPeC+c8Eh7Kw/ifBuCF/VS2oUWfEufLaBBo0AF5XQbmrgILNA1b5CYqL5R6ltpEAxVavRd4DKMwtJUFfvmcgxsXhGBcY5I4vYMHATA/UnjOQWZJ4s8duVm1GM3+YcwdNO37BYs
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 05:45:31AM +0800, kernel test robot wrote:
> Hi Vernon,
>
> kernel test robot noticed the following build errors:
>
> [auto build test ERROR on akpm-mm/mm-everything]
> [also build test ERROR on linus/master v6.19-rc1 next-20251215]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Vernon-Yang/mm-khugepaged-add-trace_mm_khugepaged_scan-event/20251215-171046
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> patch link:    https://lore.kernel.org/r/20251215090419.174418-3-yanglincheng%40kylinos.cn
> patch subject: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been collapsed
> config: x86_64-kexec (https://download.01.org/0day-ci/archive/20251216/202512160533.KuHwyJTP-lkp@intel.com/config)
> compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20251216/202512160533.KuHwyJTP-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202512160533.KuHwyJTP-lkp@intel.com/
>
> All errors (new ones prefixed by >>):
>
> >> mm/khugepaged.c:2490:9: error: use of undeclared identifier 'SCAN_PMD_NULL'; did you mean 'SCAN_VMA_NULL'?
>     2490 |                         case SCAN_PMD_NULL:
>          |                              ^~~~~~~~~~~~~
>          |                              SCAN_VMA_NULL
>    mm/khugepaged.c:50:2: note: 'SCAN_VMA_NULL' declared here
>       50 |         SCAN_VMA_NULL,
>          |         ^
> >> mm/khugepaged.c:2491:9: error: use of undeclared identifier 'SCAN_PMD_NONE'
>     2491 |                         case SCAN_PMD_NONE:
>          |                              ^
>    2 errors generated.

This series is based on Linux v6.18, due to the v6.19-rc1 add "mm/khugepaged:
unify SCAN_PMD_NONE and SCAN_PMD_NULL into SCAN_NO_PTE_TABLE"[1], trigger this
build errors. I'll fix it in the next version, Thanks!

[1] https://lkml.kernel.org/r/20251114030028.7035-4-richard.weiyang@gmail.com

>
> vim +2490 mm/khugepaged.c
>
>   2392
>   2393	static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   2394						    struct collapse_control *cc)
>   2395		__releases(&khugepaged_mm_lock)
>   2396		__acquires(&khugepaged_mm_lock)
>   2397	{
>   2398		struct vma_iterator vmi;
>   2399		struct mm_slot *slot;
>   2400		struct mm_struct *mm;
>   2401		struct vm_area_struct *vma;
>   2402		int progress = 0;
>   2403
>   2404		VM_BUG_ON(!pages);
>   2405		lockdep_assert_held(&khugepaged_mm_lock);
>   2406		*result = SCAN_FAIL;
>   2407
>   2408		if (khugepaged_scan.mm_slot) {
>   2409			slot = khugepaged_scan.mm_slot;
>   2410		} else {
>   2411			slot = list_first_entry(&khugepaged_scan.mm_head,
>   2412					     struct mm_slot, mm_node);
>   2413			khugepaged_scan.address = 0;
>   2414			khugepaged_scan.mm_slot = slot;
>   2415			khugepaged_scan.maybe_collapse = false;
>   2416		}
>   2417		spin_unlock(&khugepaged_mm_lock);
>   2418
>   2419		mm = slot->mm;
>   2420		/*
>   2421		 * Don't wait for semaphore (to avoid long wait times).  Just move to
>   2422		 * the next mm on the list.
>   2423		 */
>   2424		vma = NULL;
>   2425		if (unlikely(!mmap_read_trylock(mm)))
>   2426			goto breakouterloop_mmap_lock;
>   2427
>   2428		progress++;
>   2429		if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>   2430			goto breakouterloop;
>   2431
>   2432		vma_iter_init(&vmi, mm, khugepaged_scan.address);
>   2433		for_each_vma(vmi, vma) {
>   2434			unsigned long hstart, hend;
>   2435
>   2436			cond_resched();
>   2437			if (unlikely(hpage_collapse_test_exit_or_disable(mm))) {
>   2438				progress++;
>   2439				break;
>   2440			}
>   2441			if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
>   2442	skip:
>   2443				progress++;
>   2444				continue;
>   2445			}
>   2446			hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>   2447			hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
>   2448			if (khugepaged_scan.address > hend)
>   2449				goto skip;
>   2450			if (khugepaged_scan.address < hstart)
>   2451				khugepaged_scan.address = hstart;
>   2452			VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
>   2453
>   2454			while (khugepaged_scan.address < hend) {
>   2455				bool mmap_locked = true;
>   2456
>   2457				cond_resched();
>   2458				if (unlikely(hpage_collapse_test_exit_or_disable(mm)))
>   2459					goto breakouterloop;
>   2460
>   2461				VM_BUG_ON(khugepaged_scan.address < hstart ||
>   2462					  khugepaged_scan.address + HPAGE_PMD_SIZE >
>   2463					  hend);
>   2464				if (!vma_is_anonymous(vma)) {
>   2465					struct file *file = get_file(vma->vm_file);
>   2466					pgoff_t pgoff = linear_page_index(vma,
>   2467							khugepaged_scan.address);
>   2468
>   2469					mmap_read_unlock(mm);
>   2470					mmap_locked = false;
>   2471					*result = hpage_collapse_scan_file(mm,
>   2472						khugepaged_scan.address, file, pgoff, cc);
>   2473					fput(file);
>   2474					if (*result == SCAN_PTE_MAPPED_HUGEPAGE) {
>   2475						mmap_read_lock(mm);
>   2476						if (hpage_collapse_test_exit_or_disable(mm))
>   2477							goto breakouterloop;
>   2478						*result = collapse_pte_mapped_thp(mm,
>   2479							khugepaged_scan.address, false);
>   2480						if (*result == SCAN_PMD_MAPPED)
>   2481							*result = SCAN_SUCCEED;
>   2482						mmap_read_unlock(mm);
>   2483					}
>   2484				} else {
>   2485					*result = hpage_collapse_scan_pmd(mm, vma,
>   2486						khugepaged_scan.address, &mmap_locked, cc);
>   2487				}
>   2488
>   2489				switch (*result) {
> > 2490				case SCAN_PMD_NULL:
> > 2491				case SCAN_PMD_NONE:
>   2492				case SCAN_PMD_MAPPED:
>   2493				case SCAN_PTE_MAPPED_HUGEPAGE:
>   2494					break;
>   2495				case SCAN_SUCCEED:
>   2496					++khugepaged_pages_collapsed;
>   2497					fallthrough;
>   2498				default:
>   2499					khugepaged_scan.maybe_collapse = true;
>   2500				}
>   2501
>   2502				/* move to next address */
>   2503				khugepaged_scan.address += HPAGE_PMD_SIZE;
>   2504				progress += HPAGE_PMD_NR;
>   2505				if (!mmap_locked)
>   2506					/*
>   2507					 * We released mmap_lock so break loop.  Note
>   2508					 * that we drop mmap_lock before all hugepage
>   2509					 * allocations, so if allocation fails, we are
>   2510					 * guaranteed to break here and report the
>   2511					 * correct result back to caller.
>   2512					 */
>   2513					goto breakouterloop_mmap_lock;
>   2514				if (progress >= pages)
>   2515					goto breakouterloop;
>   2516			}
>   2517		}
>   2518	breakouterloop:
>   2519		mmap_read_unlock(mm); /* exit_mmap will destroy ptes after this */
>   2520	breakouterloop_mmap_lock:
>   2521
>   2522		spin_lock(&khugepaged_mm_lock);
>   2523		VM_BUG_ON(khugepaged_scan.mm_slot != slot);
>   2524		/*
>   2525		 * Release the current mm_slot if this mm is about to die, or
>   2526		 * if we scanned all vmas of this mm.
>   2527		 */
>   2528		if (hpage_collapse_test_exit(mm) || !vma) {
>   2529			bool maybe_collapse = khugepaged_scan.maybe_collapse;
>   2530
>   2531			if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
>   2532				maybe_collapse = true;
>   2533
>   2534			/*
>   2535			 * Make sure that if mm_users is reaching zero while
>   2536			 * khugepaged runs here, khugepaged_exit will find
>   2537			 * mm_slot not pointing to the exiting mm.
>   2538			 */
>   2539			if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
>   2540				khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
>   2541				khugepaged_scan.address = 0;
>   2542				khugepaged_scan.maybe_collapse = false;
>   2543			} else {
>   2544				khugepaged_scan.mm_slot = NULL;
>   2545				khugepaged_full_scans++;
>   2546			}
>   2547
>   2548			collect_mm_slot(slot, maybe_collapse);
>   2549		}
>   2550
>   2551		trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
>   2552
>   2553		return progress;
>   2554	}
>   2555
>
> --
> 0-DAY CI Kernel Test Service
> https://github.com/intel/lkp-tests/wiki

--
Thanks,
Vernon

