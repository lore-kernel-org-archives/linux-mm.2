Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B736D2ECF9
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 06:30:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489ED6B036A; Tue, 20 Jan 2026 01:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40DCE6B036C; Tue, 20 Jan 2026 01:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319FA6B036D; Tue, 20 Jan 2026 01:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15E8C6B036A
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 01:30:03 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9DFFD58D9F
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:30:02 +0000 (UTC)
X-FDA: 84351367044.14.961796A
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf23.hostedemail.com (Postfix) with ESMTP id 92079140007
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 06:30:00 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=L7X9TmN1;
	spf=pass (imf23.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768890600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:dkim-signature;
	bh=AEWbkgnTvkqzPgeo47yZYvD2LbBZqNGtjtOFOPaqgWg=;
	b=UiLSzjb5mKRim8y9kZlJAfkhmqFvAgQ0or6zZpB6A9iKHN2MALTl2OOqfJYAl+PsACAkaY
	8Hola62wB45rh9xqCDTL52Z/rXT8WCbHfSqgs9C2FgrWLh839/vJj1/hXA2yEsgVL3biR8
	IcYzqLpONfsZB+o8jR9hxDPnna9q1yg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=L7X9TmN1;
	spf=pass (imf23.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.41 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768890600; a=rsa-sha256;
	cv=none;
	b=70izxFItIb66C7hJrL5ipNXAW71GtB5TkSnfUpYn/ND501oIwYmkPbPgNKTicC4uHjoaea
	3U81Lx8jQzIXNPhW6sqP1EszoxSoDiTRDpfBQenvhNyhsHADuOXwP9ZteX4pYZe8lMvf2z
	hgk21PHny72ts9OTko2lRPkW+UrRptQ=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-47ee301a06aso46284605e9.0
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 22:30:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768890599; x=1769495399; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AEWbkgnTvkqzPgeo47yZYvD2LbBZqNGtjtOFOPaqgWg=;
        b=L7X9TmN1khCZ+0lG8TG8QRdRJv2tbuV/tH4AGjSEu2m58y4rht7dG5anEoVeTLfOvY
         wWYp2SySxVyS900Yj6aPw3irg2W5CQ0rJaZ6mqgluPeo7lu5Gam5Rto9gq+PtvNU4Dfy
         8HoSLG/C8zqishpM5OuL+yZmKyS+YL1DRJer3pyLABf+QROq+R9avnYMMMaFU+DN3JlO
         oTZ6AUHL5wDXzheXflrpzMksGlkbQr85hGs/k7dWJ52GKY/Ajtafn9nOdf8BlCbCJsaL
         D2luek7RzQlg7X2EU+R8r7hkIIKbjWEI3OBdFJxzd4yUeau4HSqyAz3haEW0I6hvLqwg
         7AMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768890599; x=1769495399;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AEWbkgnTvkqzPgeo47yZYvD2LbBZqNGtjtOFOPaqgWg=;
        b=UcLbp3GS53wIchRt5Xci3echCwZHf8zNFFrtUmpCHUzvPpvVPsjOGOUUQuY7Rj9s1j
         nuZJkLXIdql+opevSksfH8od7UVcOfmir3vqgCctNVaipoykYRYCLw2ZgC67KEgJ2dB+
         DJZioVRwgZ8wduJCALsevon4NaxLJ+YzODifvIIEPgDQxM8ybjib7RB9I6hK25LcvpWn
         m4EotAKez7zR0gY9F7Va8xlqoa52E6F3rOilyi35Rs20hYMPYjeJZpZqaTd7aED2lK6o
         YVMEjRC1Pm/6GnwMTO44O+020FP1iBqNtc3P2beV9cGim8lLE2Y2yK+eymIKUyjJ57Aa
         TwTg==
X-Forwarded-Encrypted: i=1; AJvYcCVRm4gCQxn43Dyxh2sTkqKm5hdo5hByWpIkyFx3iGt7qVb6JnRj3jcaluufseV0Ap157zmjEKmyhg==@kvack.org
X-Gm-Message-State: AOJu0YxI++PURBNP/CXIp12G9TctkOJneUh5vRtW9/K/BLfSgvg6YFCU
	olnOPbELA1HH0PPN616oGKtLuxrODtOoez/O6fxH1O7Qi9uVLF22BJ61XnKR37f72Ow=
X-Gm-Gg: AY/fxX6scOLptQRMBqOlUjqpNCbb9g60M/mdFfahwyO3rjqJpZL5i5eKACULqjabXQU
	UWTs0gwASFUlCBENkmUeHICY+GOMMKx/nN/oMuulV9RmtaZjasY2G/nCuPoLqIoy75XXhvephuJ
	N2uaTXl6HNdxIV34IkaT2jdGDxlUE097cz7nWkfQgi3VC2/MS54Xb8t7QtEmHKFXj29y/OEgzD5
	/ayxnvunz5ZmaUBUSSrPiBARYqElYyQvxFeRjx7KKIAZQ2gP6hx6+LzMejWCadBejB7m9BarEvc
	oUlJ6wksGdGbRQycKqDxbOlNrALfO7srOxChsef8hqM1PxV9A9k0ng2iQBNaszRzUwYEZn/ybf2
	gg1+7OZ7m6M3yXeDOVIMtn+vnufzfEzgiIT0R4iIjsuj9EQPMx0f/1cxuzlplTecMJcwzFO/cng
	U7FTRpNnFiRgyWXHeq
X-Received: by 2002:a05:600c:870e:b0:47d:264e:b35a with SMTP id 5b1f17b1804b1-4801eabf1eamr154903985e9.13.1768890598747;
        Mon, 19 Jan 2026 22:29:58 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e879537sm231880515e9.5.2026.01.19.22.29.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jan 2026 22:29:58 -0800 (PST)
Date: Tue, 20 Jan 2026 09:29:55 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, mpenttil@redhat.com, linux-mm@kvack.org
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Mika =?iso-8859-1?Q?Penttil=E4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>
Subject: Re: [PATCH v2 1/3] mm: unified hmm fault and migrate device pagewalk
 paths
Message-ID: <202601200251.uRdWeQPq-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260119112502.645059-2-mpenttil@redhat.com>
X-Rspamd-Queue-Id: 92079140007
X-Stat-Signature: ko3z6n7oz839tqd5dnk3r63ub6ww4jpn
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768890600-10429
X-HE-Meta: U2FsdGVkX18OnAEawJ6triEehXx+xGv3jJyXODp7tXko2kNjtKkt+sCclGcpSGVMModFBYiK8W4bmss6pOMyAlmAXNvXBr/D/brULwqNbcE8xlS6uiVQuAu+ChUqHSywtNHgsDMsBVwwFq82XGrkChxTxyOYgd4A9MWtXhF3q7zx8xZJv8LJPBn8RRbsy0GeuA0kM5fBqRvvao+S7LNE1xefWZk6I303zId5TMNhxeeCrY9JHbviz9IrlVL6wJh56b5cY6ER8xYjdEtuTpi78J/BxNO0e1sHgADYtdaMT2Yk1R3m0NRYns2E94DOd2KfKiS3dOLTv4Gmj8ryLgClSybaH/l6rpXxGshASWUsqKUn5WgFqZw5h6quvFmdZSDun+0CRftROBNegOQWQ2LBCnb4ScKpDy2YVvxrSVaMOmR3MaHdkw+j3YHsihKDp51sMObT71/Rap2cE8N47TeQC8pFe3MgKD9AA3M2KGfI0dmpSUIMPH6zVDYXRbJQ8QJOkLE2/AR8TRWhdApdpvlnctY3sgI/js8aB1CT203qktjU1+0bmM2DNu3jrvgIGc9XaZHOsUnZ6gG3VghOjwfgVEMzKHRROcab4SuvF6tDBF0AG4foMdqsJwPhLLsost5ZWNxoeLXSWmlWBvIZ7xGg5XEUGi2ilUr3Ca6cd6D+z+lYqz0yDjXd2phluBds9Mxg5caADXI5HnqpcsAgOiThL9R6U87VHYrDJWx3en8i2cJkjnrPnBSKrCVwEw9vGgeuVsf/cCa0Wo4bE7G/8/ospGwLTB+BVmfMnujvgjiQ4eTUe7X3+Q/lgqC2My1MADqYCXw+xdK6QG6ilhZlJv6Dazh9+3li8eE9Ik7yibP2T/O5q8AX0TluCwcKeisKFdrqvvQ1Bhs0Ak4lm2snFemofLgb6rDdRLF/c6E+zZwMYslGyO/XkfrijHu508SfwbiQDIXh6o+l9PdfRVecRNQ
 7Rh8MFZt
 yhyAsDkPorPRLyUK8uWxDrWPS7EWYT0+iaOGNW5xK0LWouewG+ohvyQY9FS9CWKPvbLvK62CzkNmsCuigzFYBuUgolNIMDUdAwen5OWBeBZmWfZiUc2J5HtPBi8suFogDhNUnaFXQceR0ZRjVEWyEWbiSXc39UFuNGDs8ntWpnYkbCcPOCYic9DyHOxIKQCvuDR+RY6UT8fdCPme3FnIRd7YpC4SjUQjw0ug4M4+YcVdrtXngzXWNRqWQhet/RxqJ/ul0CzNIAG8+MirlXJnHv2yvXkxzauU96yU4OW8+Yini0Z18OtsxmKK4+jwynR03TWoApwRmSrpBm1nZZDth9gHEH02Lj8u/bUm4zsB9dOUwefEqimUxiv6WmkzjuyxE6cDMv6inOyBlCur4a9jBJMrU5zg6KV6Bf7UZnmESWMWQIuAebiQ/uCRFs7wdlG4zUmiGkryfgCHd+3VBqdXBumGAeASLT+P81lftw2K9vdn4DsoQoOqt+JFoCXwjIQjyM9p8vUXUSH49j4Dvc7Op13LbqAomgGQ8j47GiGnYnVaoFa+6gJAvBwMvq0lKHH2ETjMnplYGpmP3vXjVtKG1Xn6kIA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

kernel test robot noticed the following build warnings:

url:    https://github.com/intel-lab-lkp/linux/commits/mpenttil-redhat-com/mm-unified-hmm-fault-and-migrate-device-pagewalk-paths/20260119-193100
base:   24d479d26b25bce5faea3ddd9fa8f3a6c3129ea7
patch link:    https://lore.kernel.org/r/20260119112502.645059-2-mpenttil%40redhat.com
patch subject: [PATCH v2 1/3] mm: unified hmm fault and migrate device pagewalk paths
config: sparc-randconfig-r071-20260119 (https://download.01.org/0day-ci/archive/20260120/202601200251.uRdWeQPq-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 15.2.0
smatch version: v0.5.0-8985-g2614ff1a

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202601200251.uRdWeQPq-lkp@intel.com/

smatch warnings:
mm/hmm.c:960 hmm_vma_walk_pmd() warn: missing error code? 'r'
mm/hmm.c:1310 hmm_range_fault() error: we previously assumed 'range->notifier' could be null (see line 1296)

vim +/r +960 mm/hmm.c

53f5c3f489ecdd Jérôme Glisse   2018-04-10   926  static int hmm_vma_walk_pmd(pmd_t *pmdp,
53f5c3f489ecdd Jérôme Glisse   2018-04-10   927  			    unsigned long start,
53f5c3f489ecdd Jérôme Glisse   2018-04-10   928  			    unsigned long end,
53f5c3f489ecdd Jérôme Glisse   2018-04-10   929  			    struct mm_walk *walk)
53f5c3f489ecdd Jérôme Glisse   2018-04-10   930  {
53f5c3f489ecdd Jérôme Glisse   2018-04-10   931  	struct hmm_vma_walk *hmm_vma_walk = walk->private;
53f5c3f489ecdd Jérôme Glisse   2018-04-10   932  	struct hmm_range *range = hmm_vma_walk->range;
2733ea144dcce7 Jason Gunthorpe 2020-05-01   933  	unsigned long *hmm_pfns =
2733ea144dcce7 Jason Gunthorpe 2020-05-01   934  		&range->hmm_pfns[(start - range->start) >> PAGE_SHIFT];
2288a9a68175ce Jason Gunthorpe 2020-03-05   935  	unsigned long npages = (end - start) >> PAGE_SHIFT;
adc5de78797562 Mika Penttilä   2026-01-19   936  	struct mm_struct *mm = walk->vma->vm_mm;
2288a9a68175ce Jason Gunthorpe 2020-03-05   937  	unsigned long addr = start;
adc5de78797562 Mika Penttilä   2026-01-19   938  	enum migrate_vma_info minfo;
adc5de78797562 Mika Penttilä   2026-01-19   939  	unsigned long i;
adc5de78797562 Mika Penttilä   2026-01-19   940  	spinlock_t *ptl;
53f5c3f489ecdd Jérôme Glisse   2018-04-10   941  	pte_t *ptep;
d08faca018c461 Jérôme Glisse   2018-10-30   942  	pmd_t pmd;
adc5de78797562 Mika Penttilä   2026-01-19   943  	int r;
adc5de78797562 Mika Penttilä   2026-01-19   944  
adc5de78797562 Mika Penttilä   2026-01-19   945  	minfo = hmm_select_migrate(range);
53f5c3f489ecdd Jérôme Glisse   2018-04-10   946  
53f5c3f489ecdd Jérôme Glisse   2018-04-10   947  again:
adc5de78797562 Mika Penttilä   2026-01-19   948  	hmm_vma_walk->locked = false;
adc5de78797562 Mika Penttilä   2026-01-19   949  	hmm_vma_walk->pmdlocked = false;
26e1a0c3277d7f Hugh Dickins    2023-06-08   950  	pmd = pmdp_get_lockless(pmdp);
adc5de78797562 Mika Penttilä   2026-01-19   951  	if (pmd_none(pmd)) {
adc5de78797562 Mika Penttilä   2026-01-19   952  		r = hmm_vma_walk_hole(start, end, -1, walk);
adc5de78797562 Mika Penttilä   2026-01-19   953  		if (r || !minfo)
adc5de78797562 Mika Penttilä   2026-01-19   954  			return r;

if minfo is NULL do we return success?

adc5de78797562 Mika Penttilä   2026-01-19   955  
adc5de78797562 Mika Penttilä   2026-01-19   956  		ptl = pmd_lock(walk->mm, pmdp);
adc5de78797562 Mika Penttilä   2026-01-19   957  		if (pmd_none(*pmdp)) {
adc5de78797562 Mika Penttilä   2026-01-19   958  			// hmm_vma_walk_hole() filled migration needs
adc5de78797562 Mika Penttilä   2026-01-19   959  			spin_unlock(ptl);
adc5de78797562 Mika Penttilä   2026-01-19  @960  			return r;

And here?

adc5de78797562 Mika Penttilä   2026-01-19   961  		}
adc5de78797562 Mika Penttilä   2026-01-19   962  		spin_unlock(ptl);
adc5de78797562 Mika Penttilä   2026-01-19   963  	}
53f5c3f489ecdd Jérôme Glisse   2018-04-10   964  
0ac881efe16468 Lorenzo Stoakes 2025-11-10   965  	if (thp_migration_supported() && pmd_is_migration_entry(pmd)) {
adc5de78797562 Mika Penttilä   2026-01-19   966  		if (!minfo) {
2733ea144dcce7 Jason Gunthorpe 2020-05-01   967  			if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0)) {
d08faca018c461 Jérôme Glisse   2018-10-30   968  				hmm_vma_walk->last = addr;
d2e8d551165ccb Ralph Campbell  2019-07-25   969  				pmd_migration_entry_wait(walk->mm, pmdp);
73231612dc7c90 Jérôme Glisse   2019-05-13   970  				return -EBUSY;
d08faca018c461 Jérôme Glisse   2018-10-30   971  			}
2288a9a68175ce Jason Gunthorpe 2020-03-05   972  		}
adc5de78797562 Mika Penttilä   2026-01-19   973  		for (i = 0; addr < end; addr += PAGE_SIZE, i++)
adc5de78797562 Mika Penttilä   2026-01-19   974  			hmm_pfns[i] &= HMM_PFN_INOUT_FLAGS;
2288a9a68175ce Jason Gunthorpe 2020-03-05   975  
adc5de78797562 Mika Penttilä   2026-01-19   976  		return 0;
adc5de78797562 Mika Penttilä   2026-01-19   977  	}
adc5de78797562 Mika Penttilä   2026-01-19   978  
adc5de78797562 Mika Penttilä   2026-01-19   979  	if (minfo) {
adc5de78797562 Mika Penttilä   2026-01-19   980  		hmm_vma_walk->ptl = pmd_lock(mm, pmdp);
adc5de78797562 Mika Penttilä   2026-01-19   981  		hmm_vma_walk->pmdlocked = true;
adc5de78797562 Mika Penttilä   2026-01-19   982  		pmd = pmdp_get(pmdp);
adc5de78797562 Mika Penttilä   2026-01-19   983  	} else
adc5de78797562 Mika Penttilä   2026-01-19   984  		pmd = pmdp_get_lockless(pmdp);
adc5de78797562 Mika Penttilä   2026-01-19   985  
adc5de78797562 Mika Penttilä   2026-01-19   986  	if (pmd_trans_huge(pmd) || !pmd_present(pmd)) {
adc5de78797562 Mika Penttilä   2026-01-19   987  
adc5de78797562 Mika Penttilä   2026-01-19   988  		if (!pmd_present(pmd)) {
adc5de78797562 Mika Penttilä   2026-01-19   989  			r = hmm_vma_handle_absent_pmd(walk, start, end, hmm_pfns,
10b9feee2d0dc8 Francois Dugast 2025-09-08   990  						      pmd);
adc5de78797562 Mika Penttilä   2026-01-19   991  			if (r || !minfo)
adc5de78797562 Mika Penttilä   2026-01-19   992  				return r;

Same

adc5de78797562 Mika Penttilä   2026-01-19   993  		} else {
d08faca018c461 Jérôme Glisse   2018-10-30   994  
53f5c3f489ecdd Jérôme Glisse   2018-04-10   995  			/*
adc5de78797562 Mika Penttilä   2026-01-19   996  			 * No need to take pmd_lock here if not migrating,
adc5de78797562 Mika Penttilä   2026-01-19   997  			 * even if some other thread is splitting the huge
adc5de78797562 Mika Penttilä   2026-01-19   998  			 * pmd we will get that event through mmu_notifier callback.
53f5c3f489ecdd Jérôme Glisse   2018-04-10   999  			 *
d2e8d551165ccb Ralph Campbell  2019-07-25  1000  			 * So just read pmd value and check again it's a transparent
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1001  			 * huge or device mapping one and compute corresponding pfn
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1002  			 * values.
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1003  			 */
adc5de78797562 Mika Penttilä   2026-01-19  1004  
adc5de78797562 Mika Penttilä   2026-01-19  1005  			if (!pmd_trans_huge(pmd)) {
adc5de78797562 Mika Penttilä   2026-01-19  1006  				// must be lockless
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1007  				goto again;
adc5de78797562 Mika Penttilä   2026-01-19  1008  			}
adc5de78797562 Mika Penttilä   2026-01-19  1009  
adc5de78797562 Mika Penttilä   2026-01-19  1010  			r = hmm_vma_handle_pmd(walk, addr, end, hmm_pfns, pmd);
adc5de78797562 Mika Penttilä   2026-01-19  1011  
adc5de78797562 Mika Penttilä   2026-01-19  1012  			if (r || !minfo)
adc5de78797562 Mika Penttilä   2026-01-19  1013  				return r;

Same?

adc5de78797562 Mika Penttilä   2026-01-19  1014  		}
adc5de78797562 Mika Penttilä   2026-01-19  1015  
adc5de78797562 Mika Penttilä   2026-01-19  1016  		r = hmm_vma_handle_migrate_prepare_pmd(walk, pmdp, start, end, hmm_pfns);
adc5de78797562 Mika Penttilä   2026-01-19  1017  
adc5de78797562 Mika Penttilä   2026-01-19  1018  		if (hmm_vma_walk->pmdlocked) {
adc5de78797562 Mika Penttilä   2026-01-19  1019  			spin_unlock(hmm_vma_walk->ptl);
adc5de78797562 Mika Penttilä   2026-01-19  1020  			hmm_vma_walk->pmdlocked = false;
adc5de78797562 Mika Penttilä   2026-01-19  1021  		}
adc5de78797562 Mika Penttilä   2026-01-19  1022  
adc5de78797562 Mika Penttilä   2026-01-19  1023  		if (r == -ENOENT) {
adc5de78797562 Mika Penttilä   2026-01-19  1024  			r = hmm_vma_walk_split(pmdp, addr, walk);
adc5de78797562 Mika Penttilä   2026-01-19  1025  			if (r) {
adc5de78797562 Mika Penttilä   2026-01-19  1026  				/* Split not successful, skip */
adc5de78797562 Mika Penttilä   2026-01-19  1027  				return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
adc5de78797562 Mika Penttilä   2026-01-19  1028  			}
adc5de78797562 Mika Penttilä   2026-01-19  1029  
adc5de78797562 Mika Penttilä   2026-01-19  1030  			/* Split successful or "again", reloop */
adc5de78797562 Mika Penttilä   2026-01-19  1031  			hmm_vma_walk->last = addr;
adc5de78797562 Mika Penttilä   2026-01-19  1032  			return -EBUSY;
adc5de78797562 Mika Penttilä   2026-01-19  1033  		}
adc5de78797562 Mika Penttilä   2026-01-19  1034  
adc5de78797562 Mika Penttilä   2026-01-19  1035  		return r;
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1036  
adc5de78797562 Mika Penttilä   2026-01-19  1037  	}
adc5de78797562 Mika Penttilä   2026-01-19  1038  
adc5de78797562 Mika Penttilä   2026-01-19  1039  	if (hmm_vma_walk->pmdlocked) {
adc5de78797562 Mika Penttilä   2026-01-19  1040  		spin_unlock(hmm_vma_walk->ptl);
adc5de78797562 Mika Penttilä   2026-01-19  1041  		hmm_vma_walk->pmdlocked = false;
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1042  	}
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1043  
d08faca018c461 Jérôme Glisse   2018-10-30  1044  	/*
d2e8d551165ccb Ralph Campbell  2019-07-25  1045  	 * We have handled all the valid cases above ie either none, migration,
d08faca018c461 Jérôme Glisse   2018-10-30  1046  	 * huge or transparent huge. At this point either it is a valid pmd
d08faca018c461 Jérôme Glisse   2018-10-30  1047  	 * entry pointing to pte directory or it is a bad pmd that will not
d08faca018c461 Jérôme Glisse   2018-10-30  1048  	 * recover.
d08faca018c461 Jérôme Glisse   2018-10-30  1049  	 */
2288a9a68175ce Jason Gunthorpe 2020-03-05  1050  	if (pmd_bad(pmd)) {
2733ea144dcce7 Jason Gunthorpe 2020-05-01  1051  		if (hmm_range_need_fault(hmm_vma_walk, hmm_pfns, npages, 0))
2288a9a68175ce Jason Gunthorpe 2020-03-05  1052  			return -EFAULT;
adc5de78797562 Mika Penttilä   2026-01-19  1053  		return hmm_pfns_fill(start, end, hmm_vma_walk, HMM_PFN_ERROR);
2288a9a68175ce Jason Gunthorpe 2020-03-05  1054  	}
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1055  
adc5de78797562 Mika Penttilä   2026-01-19  1056  	if (minfo) {
adc5de78797562 Mika Penttilä   2026-01-19  1057  		ptep = pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
adc5de78797562 Mika Penttilä   2026-01-19  1058  		if (ptep)
adc5de78797562 Mika Penttilä   2026-01-19  1059  			hmm_vma_walk->locked = true;
adc5de78797562 Mika Penttilä   2026-01-19  1060  	} else
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1061  		ptep = pte_offset_map(pmdp, addr);
6ec1905f6ec7f9 Hugh Dickins    2023-06-08  1062  	if (!ptep)
6ec1905f6ec7f9 Hugh Dickins    2023-06-08  1063  		goto again;
adc5de78797562 Mika Penttilä   2026-01-19  1064  
2733ea144dcce7 Jason Gunthorpe 2020-05-01  1065  	for (; addr < end; addr += PAGE_SIZE, ptep++, hmm_pfns++) {
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1066  
2733ea144dcce7 Jason Gunthorpe 2020-05-01  1067  		r = hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1068  		if (r) {
dfdc22078f3f06 Jason Gunthorpe 2020-02-28  1069  			/* hmm_vma_handle_pte() did pte_unmap() */
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1070  			return r;
53f5c3f489ecdd Jérôme Glisse   2018-04-10  1071  		}
adc5de78797562 Mika Penttilä   2026-01-19  1072  
adc5de78797562 Mika Penttilä   2026-01-19  1073  		r = hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns);
adc5de78797562 Mika Penttilä   2026-01-19  1074  		if (r == -EAGAIN) {
adc5de78797562 Mika Penttilä   2026-01-19  1075  			goto again;
adc5de78797562 Mika Penttilä   2026-01-19  1076  		}
adc5de78797562 Mika Penttilä   2026-01-19  1077  		if (r) {
adc5de78797562 Mika Penttilä   2026-01-19  1078  			hmm_pfns_fill(addr, end, hmm_vma_walk, HMM_PFN_ERROR);
adc5de78797562 Mika Penttilä   2026-01-19  1079  			break;
da4c3c735ea4dc Jérôme Glisse   2017-09-08  1080  		}
adc5de78797562 Mika Penttilä   2026-01-19  1081  	}
adc5de78797562 Mika Penttilä   2026-01-19  1082  
adc5de78797562 Mika Penttilä   2026-01-19  1083  	if (hmm_vma_walk->locked)
adc5de78797562 Mika Penttilä   2026-01-19  1084  		pte_unmap_unlock(ptep - 1, hmm_vma_walk->ptl);
adc5de78797562 Mika Penttilä   2026-01-19  1085  	else
da4c3c735ea4dc Jérôme Glisse   2017-09-08  1086  		pte_unmap(ptep - 1);
adc5de78797562 Mika Penttilä   2026-01-19  1087  
da4c3c735ea4dc Jérôme Glisse   2017-09-08  1088  	return 0;
da4c3c735ea4dc Jérôme Glisse   2017-09-08  1089  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


