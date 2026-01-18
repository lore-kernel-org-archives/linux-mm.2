Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0462FD4A5F4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Jan 2026 12:05:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DC36B0005; Sun, 18 Jan 2026 07:05:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CC456B0089; Sun, 18 Jan 2026 07:05:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE2A76B008A; Sun, 18 Jan 2026 07:05:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DCD956B0005
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 07:05:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8282AD1F60
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:05:00 +0000 (UTC)
X-FDA: 84344953560.10.9B1CB18
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf03.hostedemail.com (Postfix) with ESMTP id CC6872000E
	for <linux-mm@kvack.org>; Sun, 18 Jan 2026 12:04:58 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dwSnzy60;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf03.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768737899; a=rsa-sha256;
	cv=none;
	b=KfTqy0VMF5WR0ZKMAyzcQfafrhLuV3XGfTLvxZLr0aLBdGN6CIVEPBupe51C26w4+cJIFz
	1+G3NOJoHSklimyLqcTxh2L67zBm7/ur8UHuNSI3Q/hqq1+B4rmA2l2xM9VeM4UwY1niC6
	iYvuNre9xaZRCLwJ4tc5vgtl5Zr7EEo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=dwSnzy60;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf03.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.43 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768737899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oF5W5aUZl0P1F8rfmU73l0YSa0P2lxA+7bTTG4Xe1sw=;
	b=1xhKAPDZSkRbD1MEYP9aveRLXg6VpJ5X3Nfk/pe2Cf62XrhWPJGxeMEEXiScF+BdBTRR4P
	7CiF1+2Q1MPRgJObUBc6ups0f1MNhoiFtgzpMfzfoFSUpN+xnPmIk2wgyjL9Sn2uhCxPQm
	oAwIcp0jOftY4afHbgaMBiLmuScE4YQ=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47ee937ecf2so24429275e9.0
        for <linux-mm@kvack.org>; Sun, 18 Jan 2026 04:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768737897; x=1769342697; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oF5W5aUZl0P1F8rfmU73l0YSa0P2lxA+7bTTG4Xe1sw=;
        b=dwSnzy60PgshjOZDFTxoMaiDPu/G9aK4zPvjG78kza0CNLF3NMWgv25tNuUt728Ayn
         00bcwsz1NR7kMbo6AKPg3jxeqSFSmuSly5MJqKvC8d45Fq0UKnska1k904hCvj8EBNpC
         qJIYBut2bHuOHFYmN1GKODj/j8Dy26IZqAZXFrepicaljbGHvQIgXdCKKNTNSU7nxViW
         5egVDtOpgcWpJQnGkMzmUpbxWBIxGrKY/FvXcixQnROCt1AjkthoStlayHTv8y3TZ2BN
         /uoiym+X/3/t3gvVBvFZLd+aCDxg8/6YMRzxRmGsC5OJBd06a7iBhq/60XgXsFEA+HLK
         U7PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768737897; x=1769342697;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oF5W5aUZl0P1F8rfmU73l0YSa0P2lxA+7bTTG4Xe1sw=;
        b=D6vJcx8CPfP/lN28Ex86OkENMuU89QyTKm0jqcLNVzp6zd5JlBoB76pDL2g77KPrxm
         0v4o79DCWk8Wsf8Cj7qJhWijGeshXw24UeIoi0hTQNWv29h0mL0j+pCPt9EzJhQqmadV
         uBiOVQ6lR/06oPg6LoL7unaxLcsbrfjImihvJ0Uae2/ijaT2dFvWtsKEyi5vKJs6NuJr
         wC13SATNh5SQSsdPSroPwRDKMoPdU8Pam7c0yy/RMKE3n3QvPp9cTvcSCADTAWWlVQ3w
         448v8KtfjbiiHSaabqYvVPoFyoQkP4xLmTDqsAfGqwGgSt5t/ovTJMOQiMflN7z41yzQ
         5aCw==
X-Forwarded-Encrypted: i=1; AJvYcCUQpZHRLkBONoFUdL4WxBTx78I1/uPPx/OGzkcFg5gCsQrFCf4QKjXlC+/uTL+kMZN5vi86PZD/Ag==@kvack.org
X-Gm-Message-State: AOJu0YzabUmvWonN0i3lLNqhkm74imaRRBTPQObljN3wxBDDbaSuWKIb
	IXzYBw4CIAwtKjqdYfBlh644fZcdCp+Lfjh9FHrje+uFRuluVRQGg91eb2RcjxeyJG4=
X-Gm-Gg: AY/fxX4RPVr0qwbWjaICMfcHXXfr9Re19zWzzzuW+z+b36qex6fip7vb8Lp+txLxLVi
	1C9977dOdSNNfIEyXOmEHDI90cbQdilEl2ciCvVz33r6fCJnfglc//wpX46Xk2asyIW/ZtanAs7
	LMqF9ZuInpzGX17ugl+2Qr3ZqFdsU9hnlr/NhsMFGwC3USQXsKjjHKvJTbnEGLg0pwMRId7zCMF
	+2mBaVn26xjR9vsIWEYZHtR5oJfQ2ZKVOOUGWUk1cvZAOLDpUWb4ajCoGNY+RSb29D3U7GC4Xqc
	iXQDZ3Rkn8TMCexvZPWcajnXbgOukd9UdYBW/v36VEWFFWRDfo5xRVSkmf3faXD76DK0JiwzrX2
	crApJCIuSdTur34CGYFvNspnmh2YunMyrYoRPBA8fdh1IxOcbhktMg+FwKrEVeje96r7eEAPbbF
	Y7T2gk3uEYPhbvDdLk
X-Received: by 2002:a05:600c:8184:b0:475:d9de:952e with SMTP id 5b1f17b1804b1-4801e530d08mr96596425e9.1.1768737897204;
        Sun, 18 Jan 2026 04:04:57 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47f428acae8sm194366875e9.4.2026.01.18.04.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 04:04:56 -0800 (PST)
Date: Sun, 18 Jan 2026 15:04:53 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Alistair Popple <apopple@nvidia.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	=?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn@rivosinc.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: lib/test_hmm.c:932 dmirror_migrate_to_system() error: uninitialized
 symbol 'ret'.
Message-ID: <202601152125.McLpiKxS-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Stat-Signature: ihty6aza5wucztbo6uw1mi6wb1ik1ooq
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CC6872000E
X-HE-Tag: 1768737898-291045
X-HE-Meta: U2FsdGVkX1/SQw9C8APwffLDstP5HjJvtZp4eo4XwnMhhY/vOyM/T0Cww6YKDGUcSTN2TmKZBxsvI8sO5JXYCuClz9KG8ESAJ1aD0Zvg7AxgG4jQiV7x2j3A23ptR9NhF0nGbo/FoEE7/jqdtD/rBVdFLX8HBmXwe/0kT5HCphZmJgn5ZVj66Aeg6QgNNinaVx0QPfTNYqBUagjY2tyi01xEVPQ07OSDAOlo6GQ4V/l2gG5tDZI2fCpKbm8OCMA42sM65CNRToRyjiTDLpBORz3qrIH4GzW4CG0LMKrk82BpDc4N2k5yRiS7mCssLtalBoDjiJz2y/iOYxQhUsQRuUnUexrdC4jec7Fx+S66kW+XLHNlemuoqUw0pthJ2ywA2m3d6RyE7XzVIL+jgHcmx0lDJE9055Uj4HPb+N2j6pNYCIXqLce0V8PpFeF7PpfJpthr++0ztr8STTfx+Q+itr+GsLe7MUxtzKHbUgj0SMEd6Natihka5oE51qCMs1kiYV3f7D3ro43oqSbQh1GzrNB1CSFrbtPQAspNfEZeN7oJQTSWpId3MTGdv2mfN8mVifpBCvvHyHfP/pYyBXnexbSIfpMNvbeCvH6oVzYN2D2/dT/e4mxgnb3QmE0OsVsSILU3vqojAPtHS+px8tpU8PECVulJHQRdEE33/mSTlTvHcmxxmRmn2wb8FNYgIqXH+M3e1Mb61YCohWQi/X49nGmsJyWBj70K6b7Vc6D1OmAUcZUzOnv2juLnEvkTzkBQkH7GRxysbjA1o3KiBhp3uGc2Ly/7dbSgedKpb/N/HOjPHU3zcJ42vqTaGOMf8U7Z5gZgZ9YyVeIJFDKNedapOh3u7bcaZnY+9uSc4CQJe3/YJG9DlWn1UmWbtuASS6DRVgrVreQKNV8imyGvqfuIZOrjPnE6Y7+afpoKSwxz2obd/KfFTAG5IfboRykpJ4ryzDO5djXHrY7UrlTrNTr
 JZeBG9It
 E8ArgHlhN5JTpUEDWvoLGGSLykmh21dsuxj1B7/JduY0V5omRWUIyeCWj/nm5qofqllihl9T1Xs1f5bxL1MEIdSpugHScPIVTp5/W
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   944aacb68baf7624ab8d277d0ebf07f025ca137c
commit: d438d273417055241ebaaf1ba3be23459fc27cba mm: remove devmap related functions and page table bits
config: s390-randconfig-r071-20260115 (https://download.01.org/0day-ci/archive/20260115/202601152125.McLpiKxS-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
smatch version: v0.5.0-8985-g2614ff1a

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202601152125.McLpiKxS-lkp@intel.com/

smatch warnings:
lib/test_hmm.c:932 dmirror_migrate_to_system() error: uninitialized symbol 'ret'.

vim +/ret +932 lib/test_hmm.c

4c2e0f764eb4444 Alex Sierra     2022-07-15  875  static int dmirror_migrate_to_system(struct dmirror *dmirror,
4c2e0f764eb4444 Alex Sierra     2022-07-15  876  				     struct hmm_dmirror_cmd *cmd)
4c2e0f764eb4444 Alex Sierra     2022-07-15  877  {
4c2e0f764eb4444 Alex Sierra     2022-07-15  878  	unsigned long start, end, addr;
4c2e0f764eb4444 Alex Sierra     2022-07-15  879  	unsigned long size = cmd->npages << PAGE_SHIFT;
4c2e0f764eb4444 Alex Sierra     2022-07-15  880  	struct mm_struct *mm = dmirror->notifier.mm;
4c2e0f764eb4444 Alex Sierra     2022-07-15  881  	struct vm_area_struct *vma;
6046a3bed1c2b02 Arnd Bergmann   2025-06-10  882  	unsigned long src_pfns[32] = { 0 };
6046a3bed1c2b02 Arnd Bergmann   2025-06-10  883  	unsigned long dst_pfns[32] = { 0 };
16ce101db85db69 Alistair Popple 2022-09-28  884  	struct migrate_vma args = { 0 };
4c2e0f764eb4444 Alex Sierra     2022-07-15  885  	unsigned long next;
4c2e0f764eb4444 Alex Sierra     2022-07-15  886  	int ret;
4c2e0f764eb4444 Alex Sierra     2022-07-15  887  
4c2e0f764eb4444 Alex Sierra     2022-07-15  888  	start = cmd->addr;
4c2e0f764eb4444 Alex Sierra     2022-07-15  889  	end = start + size;
4c2e0f764eb4444 Alex Sierra     2022-07-15  890  	if (end < start)

If end == start then ret is uninitialized.

4c2e0f764eb4444 Alex Sierra     2022-07-15  891  		return -EINVAL;
4c2e0f764eb4444 Alex Sierra     2022-07-15  892  
4c2e0f764eb4444 Alex Sierra     2022-07-15  893  	/* Since the mm is for the mirrored process, get a reference first. */
4c2e0f764eb4444 Alex Sierra     2022-07-15  894  	if (!mmget_not_zero(mm))
4c2e0f764eb4444 Alex Sierra     2022-07-15  895  		return -EINVAL;
4c2e0f764eb4444 Alex Sierra     2022-07-15  896  
4c2e0f764eb4444 Alex Sierra     2022-07-15  897  	cmd->cpages = 0;
4c2e0f764eb4444 Alex Sierra     2022-07-15  898  	mmap_read_lock(mm);
4c2e0f764eb4444 Alex Sierra     2022-07-15  899  	for (addr = start; addr < end; addr = next) {
4c2e0f764eb4444 Alex Sierra     2022-07-15  900  		vma = vma_lookup(mm, addr);
4c2e0f764eb4444 Alex Sierra     2022-07-15  901  		if (!vma || !(vma->vm_flags & VM_READ)) {
4c2e0f764eb4444 Alex Sierra     2022-07-15  902  			ret = -EINVAL;
4c2e0f764eb4444 Alex Sierra     2022-07-15  903  			goto out;
4c2e0f764eb4444 Alex Sierra     2022-07-15  904  		}
4c2e0f764eb4444 Alex Sierra     2022-07-15  905  		next = min(end, addr + (ARRAY_SIZE(src_pfns) << PAGE_SHIFT));
4c2e0f764eb4444 Alex Sierra     2022-07-15  906  		if (next > vma->vm_end)
4c2e0f764eb4444 Alex Sierra     2022-07-15  907  			next = vma->vm_end;
4c2e0f764eb4444 Alex Sierra     2022-07-15  908  
4c2e0f764eb4444 Alex Sierra     2022-07-15  909  		args.vma = vma;
4c2e0f764eb4444 Alex Sierra     2022-07-15  910  		args.src = src_pfns;
4c2e0f764eb4444 Alex Sierra     2022-07-15  911  		args.dst = dst_pfns;
4c2e0f764eb4444 Alex Sierra     2022-07-15  912  		args.start = addr;
4c2e0f764eb4444 Alex Sierra     2022-07-15  913  		args.end = next;
4c2e0f764eb4444 Alex Sierra     2022-07-15  914  		args.pgmap_owner = dmirror->mdevice;
4c2e0f764eb4444 Alex Sierra     2022-07-15  915  		args.flags = dmirror_select_device(dmirror);
4c2e0f764eb4444 Alex Sierra     2022-07-15  916  
4c2e0f764eb4444 Alex Sierra     2022-07-15  917  		ret = migrate_vma_setup(&args);
4c2e0f764eb4444 Alex Sierra     2022-07-15  918  		if (ret)
4c2e0f764eb4444 Alex Sierra     2022-07-15  919  			goto out;
4c2e0f764eb4444 Alex Sierra     2022-07-15  920  
4c2e0f764eb4444 Alex Sierra     2022-07-15  921  		pr_debug("Migrating from device mem to sys mem\n");
4c2e0f764eb4444 Alex Sierra     2022-07-15  922  		dmirror_devmem_fault_alloc_and_copy(&args, dmirror);
4c2e0f764eb4444 Alex Sierra     2022-07-15  923  
4c2e0f764eb4444 Alex Sierra     2022-07-15  924  		migrate_vma_pages(&args);
4c2e0f764eb4444 Alex Sierra     2022-07-15  925  		cmd->cpages += dmirror_successful_migrated_pages(&args);
4c2e0f764eb4444 Alex Sierra     2022-07-15  926  		migrate_vma_finalize(&args);
4c2e0f764eb4444 Alex Sierra     2022-07-15  927  	}
4c2e0f764eb4444 Alex Sierra     2022-07-15  928  out:
4c2e0f764eb4444 Alex Sierra     2022-07-15  929  	mmap_read_unlock(mm);
4c2e0f764eb4444 Alex Sierra     2022-07-15  930  	mmput(mm);
4c2e0f764eb4444 Alex Sierra     2022-07-15  931  
4c2e0f764eb4444 Alex Sierra     2022-07-15 @932  	return ret;
4c2e0f764eb4444 Alex Sierra     2022-07-15  933  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


