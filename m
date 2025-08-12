Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00938CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 13:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97B3C8E0142; Tue, 12 Aug 2025 09:47:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 952888E00E5; Tue, 12 Aug 2025 09:47:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869338E0142; Tue, 12 Aug 2025 09:47:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 70DAE8E00E5
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 09:47:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 21E8758780
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:47:10 +0000 (UTC)
X-FDA: 83768231820.20.5B168CB
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf25.hostedemail.com (Postfix) with ESMTP id AE4E9A0008
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 13:47:07 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YeSnrp59;
	spf=pass (imf25.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755006428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D8WoxjvDBkfx4Zq67j4dS/oZqS1XLjrG4y/OFkK7qEk=;
	b=s9qTnfENaUSFT+lIxn24AopU/GPpaO1WLiQvqONQDuPvTrT/T/clssin+Y7siH/r+4RZdi
	oQlK+lBc3Kc3moSpNxP5+f1LSwG3hEQ3QD6MlwXWL+YMWp+g5M0CrPFnoeHK1E+X+6Dlqg
	Ksyn+YzFk2bV+atagHop5y1tw+OAMd4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YeSnrp59;
	spf=pass (imf25.hostedemail.com: domain of linyongting@bytedance.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=linyongting@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755006428; a=rsa-sha256;
	cv=none;
	b=gjT/EQ4BVL2q3ZoPrVB7eZsuwpudULL/pZ3PBB38NRpfM6Qn66D7wYCKXn6wudRa/A1Kjr
	94dTbZljNyKbsZ+r92T7qlrUUCulFaNbwtobB0Fbwmmkc+GLKcnPEPcmgNpCYmEOCYgjTv
	/37Ku/MDiRKYrjDWzF0SG4T/dch2dNA=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2400f746440so45410835ad.2
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 06:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1755006426; x=1755611226; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D8WoxjvDBkfx4Zq67j4dS/oZqS1XLjrG4y/OFkK7qEk=;
        b=YeSnrp599Dt75VtoX8eGOSi8jrWKuheVysLZAbJ80H1B4he1elm97WUQ3FuyT42/He
         JaNdmJMZqsniHGVaA/ajwnr7PtJ4QjN9I3hN2979l4I9htPIaIX+8xR2bR//aDL7PPrJ
         A034ySsWU0X4xpqTydPH/TaxktTAQvx1NZF9hxgWxlqiS25klcWiZpMZhHyncecGFmdn
         JHs77ihj89tibYxPkrrvQie88I2i+oxy9CS8qS47OVJqgbMwgwD4xIA7moswl6tRHw2o
         gyRXVyjvcVcr2FcKtFw9q33NSifzbRH3k3ggR+Bw1esg62+M+Y+vWs9qIZalX9GQ0ktZ
         0fyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755006426; x=1755611226;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D8WoxjvDBkfx4Zq67j4dS/oZqS1XLjrG4y/OFkK7qEk=;
        b=jW8Q7jsG/A2F/pZvoj0WSSJNoJzcE2LDsu9O8Eo57FH9AbLeVMkqYjaws0jCnEl6F2
         KnoGkj3W2sYS525sddosxKvdCJP/6xBeNBmnySjPfijm9Una2xssDJCYggsrmSdvzoBa
         ySitLcY1ye+kdZw9up4la1TCRnwldS3wFg80aEBNh8L5C/JpRLmyXedORrbmx1HOG8uM
         4tLfEvSSILuqFxV5LQPDndzSN85dQz/k/S5o+Ajq3NdMnz1yIAi0zyThoScAEXDQEGKu
         CM28U1b+0KRhldE4UwzN2OkoybSyJgBhHnUdGvU4oba4ldCO/jGZtrfUynf9FDhN93P8
         4xxw==
X-Forwarded-Encrypted: i=1; AJvYcCU9rdAjOUbn89dX39sGruukPOw75fM1QBXQZ/8v3X5jTEnLT0uVejkPxSXP2NFvvBEdRm9XxgaXiA==@kvack.org
X-Gm-Message-State: AOJu0YxlH0yyxZRvAbXC6MfOESOBMZhA/zwfYfNjWSWJovLD2Wcv+EJa
	oiJjbKbXmPTrBgt2TU8eGbqTioRRYaYfhk6WK/7psw2A7F2ecV2Fu0T38U6aEDBSMt8=
X-Gm-Gg: ASbGnctUQuef3bWLcIA/jcUF7rDms8iEsa2ASoHOIF6me4rvH57ltT/ou4zwjn8OB6w
	3awvsr3LKV8RtDc3iwDZQMB86wvdDaKPf8+49lUwaigWn2XRTpOxHO8rlRh+DHE7duHdHevDbfv
	4sNuHHaByG+WZM9wqnlYBCbzTCaw1dQMO0C4pynFhC3hlsbiAwSkQUGseJsB6p8U69A48vYXFEP
	6YQ29CHh2b1M9Kqi6FLnLaoTc181+THzmaAgop9QG33SJWC13SFfmzrbCDSYf3Gc5CdUHX752jB
	HtVwG6hJ6zvetyAfSdQohWkdW5MHm0dGIK4BtVj78vqiIUMauAhbs40zpAkkQhTXeNT4PDQnLCq
	oURCYSMHkZZ0Q7YfNELcPxsQh5E4/XJdXFcclVBigyu9Svjo2Zao=
X-Google-Smtp-Source: AGHT+IHA60tP4SeRa6XXCks2V9uQ+cQDXkYaDUBAx/8PtuesE53gCrJ6FR505cnAE/3WujtaqV6XRQ==
X-Received: by 2002:a17:902:ccc2:b0:240:99d8:84 with SMTP id d9443c01a7336-242fc38ac30mr53371355ad.52.1755006426232;
        Tue, 12 Aug 2025 06:47:06 -0700 (PDT)
Received: from H3DJ4YJ04F.bytedance.net ([2001:c10:ff04:0:1000:0:1:d])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b42890523basm12948595a12.45.2025.08.12.06.46.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 12 Aug 2025 06:47:05 -0700 (PDT)
From: Yongting Lin <linyongting@bytedance.com>
To: anthony.yznaga@oracle.com
Cc: akpm@linux-foundation.org,
	andreyknvl@gmail.com,
	arnd@arndb.de,
	brauner@kernel.org,
	catalin.marinas@arm.com,
	dave.hansen@intel.com,
	david@redhat.com,
	ebiederm@xmission.com,
	khalid@kernel.org,
	linux-arch@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	luto@kernel.org,
	markhemm@googlemail.com,
	maz@kernel.org,
	mhiramat@kernel.org,
	neilb@suse.de,
	pcc@google.com,
	rostedt@goodmis.org,
	vasily.averin@linux.dev,
	viro@zeniv.linux.org.uk,
	willy@infradead.org,
	xhao@linux.alibaba.com
Subject: Re: [PATCH v2 13/20] x86/mm: enable page table sharing
Date: Tue, 12 Aug 2025 21:46:55 +0800
Message-Id: <20250812134655.68614-1-linyongting@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20250404021902.48863-14-anthony.yznaga@oracle.com>
References: <20250404021902.48863-14-anthony.yznaga@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AE4E9A0008
X-Rspam-User: 
X-Stat-Signature: kxdbpscuf11u6bpz4o5rr175wdcjwcph
X-Rspamd-Server: rspam09
X-HE-Tag: 1755006427-510647
X-HE-Meta: U2FsdGVkX18gP24ueChtPrQ2ozyAeFgoxcZ2Tm4C8kuaY9YjOfeI4Y7qMMrAyxNqcGqa8jZraKEfo5NldaEeerXZdmje5Hgz1sVVxnAD/HInTpwbgyahicp3FeWXOp/tjgalHn8BYy64sqitFfbVWgjH/C+TZNHk20VeNnHy7WrgM8zMmKun+kpqFNUy1uhl9hSS/A9fH3bP0znxXhOoP1UIGPpFWIsrBKRz+b6wtDog1fyJxUsl/3SrOTTIuYvO7+pPleoFfJF3eVOlKRIgKGLpIu+aUilXCFrUmVFSjSTU6XgzFF2O7j7h02GEoCqMdeGXz8Csp/74xpRaCgqRyxIRtGroQGEJ5ABbwkFOb2QfDpZlyN+sE6bDa4Fkzl1nsnY017SmtmhrybWtWY6F7f/EpkrXIWWYLVEILHWv8MuGQHu03XwP9lJDgtNKMFds1KlmRdTy+pmIcN2eGjLtDbuoE2EAkmtYYOUgnSAvSVLG/am0u8InYfeLTxMXuOKWg3Fg2sim7bFdb+ynydmWaBxGWqovpHVrqYMG669WGv0B8LusHTr18VzDE/BVW8v7w1nmATOJx/7yu4Oj8O3/qrqDgB1sxPM9odPmRzOTE1QyvtAzFSXUQeuIbQa5tTGV/Y8IGnC+YZQIKwaLyBtPc5MuccTNr5X59wGXtbtg5hzAbpZIlf8Sf/Nj8aa/TLC0ldgGx2abMf3uRWJRVVhKsbB0JW//Fli6iP5f3Muulmx+NDAIrxKSFJbUR/O0m8xnLfy2JDdsp2aKxkE/bDm+u+59aCFhSIxaYcgdtn8ne2TsGNP6m9UIuU3MU6qDAyewZs3Sli0akyRg2EwojlhgalCsF2BQXYWsHULZttQLyUHQBVYWbQ/YSe+HO82VhZKEbRTZp71GeKLBnVZ1/GBVOxfMH34NRbKDLNiw3LGRsVtl6fePLIQQnOVlsMQBNox66WlSgz0TCck0qinI8X2
 9sMdMRSL
 dH3JuZEtCF1J1F38tLQw9eFOtsMZ4cBxGaaUz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 4/4/25 10:18 AM, Anthony Yznaga wrote:
> Enable x86 support for handling page faults in an mshare region by
> redirecting page faults to operate on the mshare mm_struct and vmas
> contained in it.
> Some permissions checks are done using vma flags in architecture-specfic
> fault handling code so the actual vma needed to complete the handling
> is acquired before calling handle_mm_fault(). Because of this an
> ARCH_SUPPORTS_MSHARE config option is added.
>
> Signed-off-by: Anthony Yznaga <anthony.yznaga@oracle.com>
> ---
>  arch/Kconfig        |  3 +++
>  arch/x86/Kconfig    |  1 +
>  arch/x86/mm/fault.c | 37 ++++++++++++++++++++++++++++++++++++-
>  mm/Kconfig          |  2 +-
>  4 files changed, 41 insertions(+), 2 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 9f6eb09ef12d..2e000fefe9b3 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -1652,6 +1652,9 @@ config HAVE_ARCH_PFN_VALID
>  config ARCH_SUPPORTS_DEBUG_PAGEALLOC
>  	bool
>  
> +config ARCH_SUPPORTS_MSHARE
> +	bool
> +
>  config ARCH_SUPPORTS_PAGE_TABLE_CHECK
>  	bool
>  
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 1502fd0c3c06..1f1779decb44 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -125,6 +125,7 @@ config X86
>  	select ARCH_SUPPORTS_ACPI
>  	select ARCH_SUPPORTS_ATOMIC_RMW
>  	select ARCH_SUPPORTS_DEBUG_PAGEALLOC
> +	select ARCH_SUPPORTS_MSHARE		if X86_64
>  	select ARCH_SUPPORTS_PAGE_TABLE_CHECK	if X86_64
>  	select ARCH_SUPPORTS_NUMA_BALANCING	if X86_64
>  	select ARCH_SUPPORTS_KMAP_LOCAL_FORCE_MAP	if NR_CPUS <= 4096
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 296d294142c8..49659d2f9316 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -1216,6 +1216,8 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	struct mm_struct *mm;
>  	vm_fault_t fault;
>  	unsigned int flags = FAULT_FLAG_DEFAULT;
> +	bool is_shared_vma;
> +	unsigned long addr;
>  
>  	tsk = current;
>  	mm = tsk->mm;
> @@ -1329,6 +1331,12 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	if (!vma)
>  		goto lock_mmap;
>  
> +	/* mshare does not support per-VMA locks yet */
> +	if (vma_is_mshare(vma)) {
> +		vma_end_read(vma);
> +		goto lock_mmap;
> +	}
> +
>  	if (unlikely(access_error(error_code, vma))) {
>  		bad_area_access_error(regs, error_code, address, NULL, vma);
>  		count_vm_vma_lock_event(VMA_LOCK_SUCCESS);
> @@ -1357,17 +1365,38 @@ void do_user_addr_fault(struct pt_regs *regs,
>  lock_mmap:
>  
>  retry:
> +	addr = address;
> +	is_shared_vma = false;
>  	vma = lock_mm_and_find_vma(mm, address, regs);
>  	if (unlikely(!vma)) {
>  		bad_area_nosemaphore(regs, error_code, address);
>  		return;
>  	}
>  
> +	if (unlikely(vma_is_mshare(vma))) {
> +		fault = find_shared_vma(&vma, &addr);
> +
> +		if (fault) {
> +			mmap_read_unlock(mm);
> +			goto done;
> +		}
> +
> +		if (!vma) {
> +			mmap_read_unlock(mm);
> +			bad_area_nosemaphore(regs, error_code, address);
> +			return;
> +		}
> +
> +		is_shared_vma = true;
> +	}
> +
>  	/*
>  	 * Ok, we have a good vm_area for this memory access, so
>  	 * we can handle it..
>  	 */
>  	if (unlikely(access_error(error_code, vma))) {
> +		if (unlikely(is_shared_vma))
> +			mmap_read_unlock(vma->vm_mm);
>  		bad_area_access_error(regs, error_code, address, mm, vma);
>  		return;
>  	}
> @@ -1385,7 +1414,11 @@ void do_user_addr_fault(struct pt_regs *regs,
>  	 * userland). The return to userland is identified whenever
>  	 * FAULT_FLAG_USER|FAULT_FLAG_KILLABLE are both set in flags.
>  	 */
> -	fault = handle_mm_fault(vma, address, flags, regs);
> +	fault = handle_mm_fault(vma, addr, flags, regs);
> +
> +	if (unlikely(is_shared_vma) && ((fault & VM_FAULT_COMPLETED) ||
> +	    (fault & VM_FAULT_RETRY) || fault_signal_pending(fault, regs)))
> +		mmap_read_unlock(mm);

I was backporting these patches of mshare to 5.15 kernel and trying to do some
basic tests. Then found a potential issue.

Reaching here means find_shared_vma function has been executed successfully 
and host_mm->mmap_lock has got locked.

When returned fault variable has VM_FAULT_COMPLETED or VM_FAULT_RETRY flags,
or fault_signal_pending(fault, regs) takes true, there is not chance to release
locks of both mm and host_mm(i.e. vma->vm_mm) in the following Snippet of Code.

As a result, needs to release vma->vm_mm.mmap_lock as well.

So it is supposed to be like below:

-	fault = handle_mm_fault(vma, address, flags, regs);
+	fault = handle_mm_fault(vma, addr, flags, regs);
+
+	if (unlikely(is_shared_vma) && ((fault & VM_FAULT_COMPLETED) ||
+	    (fault & VM_FAULT_RETRY) || fault_signal_pending(fault, regs))) {
+		mmap_read_unlock(vma->vm_mm);
+		mmap_read_unlock(mm);
+	}

>  
>  	if (fault_signal_pending(fault, regs)) {
>  		/*
> @@ -1413,6 +1446,8 @@ void do_user_addr_fault(struct pt_regs *regs,
>  		goto retry;
>  	}
>  
> +	if (unlikely(is_shared_vma))
> +		mmap_read_unlock(vma->vm_mm);
>  	mmap_read_unlock(mm);
>  done:
>  	if (likely(!(fault & VM_FAULT_ERROR)))
> diff --git a/mm/Kconfig b/mm/Kconfig
> index e6c90db83d01..8a5a159457f2 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -1344,7 +1344,7 @@ config PT_RECLAIM
>  
>  config MSHARE
>  	bool "Mshare"
> -	depends on MMU
> +	depends on MMU && ARCH_SUPPORTS_MSHARE
>  	help
>  	  Enable msharefs: A ram-based filesystem that allows multiple
>  	  processes to share page table entries for shared pages. A file

Yongting Lin.

