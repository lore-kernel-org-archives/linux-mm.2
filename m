Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D076CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77E778E0005; Tue, 14 Oct 2025 04:28:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 755CF8E00CC; Tue, 14 Oct 2025 04:28:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66EC88E0005; Tue, 14 Oct 2025 04:28:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4D4D58E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:28:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1A82BB28B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:28:13 +0000 (UTC)
X-FDA: 83996042466.18.9A4AE5D
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2928C4000F
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:28:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wDPCyv0X;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760430492;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ZMmcKKtzsAFzuEGIDGC8F2Daew0h91iJpeeav+ugrHo=;
	b=wafozpsP2SmYOf1VdCjIJqVbvAptTxeaWioGdRVm66Q8Xo+CDtobhXixrC8H0Gx/mlWtTX
	B6STUeEo4ToVsi1H9vp5zkgXATjn55djY/w+oBjzZOEFIH7LUURyMvMRbGqXSdtuzAIOGZ
	N2vizEni1pJbqEBHjPvLsiK0jlBfJq4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=wDPCyv0X;
	spf=pass (imf27.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.128.52 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760430492; a=rsa-sha256;
	cv=none;
	b=MbObKTDp4Du/dSqm4PVCfnDpDbiL6qM+VcI5BGcH2tmu+cm6YROvqo4dYIRlm87ddmOfKm
	Yl6AyV8M7WJtecmD4PhEmYzJA79xCcr8z2ssFQdKn1pFp5sH3w3j+MPEuLqBXiylRe+69L
	1xP7I4MxKFtDNgkxGb762eQdVJEBROk=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-46e384dfde0so51840805e9.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 01:28:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760430490; x=1761035290; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZMmcKKtzsAFzuEGIDGC8F2Daew0h91iJpeeav+ugrHo=;
        b=wDPCyv0XSyTm1eQxJiZ+7gS5Z29/U2ThMnI1SybxREF2BXtk1Z+D2s8xlpe6fBTleE
         7hJU8H+GfBC7i14xuu0H1QMGGM2f8gXXvtyarAB7NqMAX/N/qyqvMdyfPPzsSw+7iby7
         v0Fxl7InWwg0Ww9t9w7UCXwMR3AkAqrNhTGFclDfVPhBXTWFeeHFBLup4AzREvS7j12M
         fmf6xoPT6/lGAPVKg86KNiwp6emGoauGQRgqEiV4n9jQF+EuLfDx4o2OBwdz8ZF6igme
         ENZ2jf2Z+AGfuMka+4i6SRGhPnHLBtL+DorVrJEsmmOW0AThUok5OTY8dBWQI1dWqCki
         8x5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760430490; x=1761035290;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZMmcKKtzsAFzuEGIDGC8F2Daew0h91iJpeeav+ugrHo=;
        b=eVuknHVeaXVcNnjMqmYTmEmlptGZR6dUthHanQbGz5POvjjLbfvT6mCOgmjxbrnmd2
         gkflH2IcYOL4kKAj/4mr1i/YcbZtKRPwgZuZiYOaUGJ2e2oIXPWAvCFhoAJQgfEiRtKZ
         iA7jSCRxkO9kaKv6nhDH36ouPG7VUy60w5LxTSG8kPUyhGN7WJ319fVSyJhoSGZWt5xX
         UeZZ2gahgj4T/Oa3H+lC6uEB2vwfQUrM+3xviwTK9VGGpyZxgjdZXu/wuunjDp7q/VCb
         yTgUBqXsuqDa04wgXGeoFMqdyCPOcx2X7h0KLE9QAMkXD3zagQs/XxM2O4jP+phBdSVD
         8xcg==
X-Forwarded-Encrypted: i=1; AJvYcCWCVyWzgKEZYQHoD16jq3bLUu/bAUJT38UJX84bmg+JJm2xSwVzbquCKeqdfN4CowLxG2koXymQJQ==@kvack.org
X-Gm-Message-State: AOJu0YwQErn60hmxd7AoN0Nbmn1vaKpgtsYw5AThFov8Ipa2JR4/+nmH
	dorkHQ5F+D9LwRTxRW0DQYzT3QC7i6hVsss/UYvdyL5yKuHDmMVtJ4gFR5Hgxbmal6k=
X-Gm-Gg: ASbGncuWWPrgk1eOhtFeRNf10AnospdS0NXEQAMRGT7V6UwdiYs8o+hyxcMdeP9vhlB
	PZ04QychfgjYu0yic/AUPHzjX8T0LibnKK2sJLYN5ayI9pRoD357EAECFXIsnmQQ3ch5zziQqy5
	ywsQ9MiSPZwYpVd1uoXzlEzMtw5xy6E2mlwwmk2zcq/Wfw7IeB5b68XEz26yqPGQqBCaC/+jZpl
	roA1eXfZ8KKAvnC5345nWB5fHrcmsGcyTgQG33f0+xLEllY2owZy4okwK4stpLadwRyXhKxPF8n
	fNPCUrKs7E3RMXbLVvYCRyATOt3i6wlJyWafBuxFEax8gcz0BD0Tr+gMpLby17+ajH6tZcHwDpB
	4/jY2bFeVgvOeQQoF6BkYeaiVNyNpm3KcH3E9QPCZkEUsLFR87oo=
X-Google-Smtp-Source: AGHT+IHg93aeG/+rqWGvVOf5SViU9wzXfImlvuVSqw4Zl6WnSo614BhemIrHZLx8kViaZ8pW3TgLTg==
X-Received: by 2002:a05:600c:19d0:b0:46e:761b:e7ff with SMTP id 5b1f17b1804b1-46fa9b06c8cmr173278365e9.28.1760430490392;
        Tue, 14 Oct 2025 01:28:10 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-46fb489ad27sm227170535e9.15.2025.10.14.01.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Oct 2025 01:28:09 -0700 (PDT)
Date: Tue, 14 Oct 2025 11:28:06 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Yadong Qi <yadong.qi@linux.alibaba.com>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Huang Ying <ying.huang@linux.alibaba.com>
Subject: [akpm-mm:mm-new 114/114] mm/vmalloc.c:191 vmap_pmd_range() error:
 uninitialized symbol 'err'.
Message-ID: <202510110050.VG9YKMRK-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Queue-Id: 2928C4000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: hs7wbzjx9gczew5dour85dcahbapjg33
X-HE-Tag: 1760430491-359298
X-HE-Meta: U2FsdGVkX19ayLA2KHgovTihT+rLEZk3Z+OGweDwig7YtoyGk78MIJrOJBc2vg9jjIVaRXkfV2nV5tKvXj8yhc7KugrYL34EutLDSaVD5hE24ID1+s8IgemlkXJ7FRFjVbXDcSfInBBWj5F1PkkCwXmCWwXz/KiohZcBk2J/zkHxeh6Q0u1asedZ8nJoQb6UJx+7v8duzodHYp3NwjbX3wSJalPZfG1qNMFAmy1+04tjpEWO1n7FQmLYZEgf8KZkSzBkHZLUCIEZ+2RSQkAtqgpDAj7NWjMjBs0TnPr6C5c02LKSs9pArIxgy5SLesXl/rhJFkfFOa/lKJIUJxMgSa1D1Je1srUb2kQDxBv5UQ/lHfeuzC9/GG+j0nSOKAXW4pe4FzzEJ9J1aVM/wco7fD3unBVj87SuvdpzBCZNVkRGIhEnr9/XCpW5RelabRsQa+MlWySxKpLgA51MyqnIzvn8w1+oCebnkwn5N54vVAAeieSd35E2HezjbqrQs72/O4l/xwwrZAuuYUYMjM7R4drVsaCb73NyrlXki2q6NH3/pGlJRHeNd/6UdlsknvpW561rXQyFz25oWLv6dOptaDX5cZJZG+Bi3+f08TC/DLay2gASjKZuwkhbNGTxgvH8CF1VC3t+NJFcYz1Z9aWu/WEjfHYUnPuQuonpJ/10NhBYpAr+9qE0d7ZZwEjyw9CG4DjpvTYwvGkfg/GI7kKJlPRqJdPQRTwn6G2RonkXi4DNKMw2rBosa3HRblIl8vN6xYlxvcqxVmoUSbRORfuNiTfDazbA0tTnbw589NlgaoaOeS+I/5zaAjFdnhNKSV0NDI5BAj8lG9oJ4JaYGdZKz0wYJhxTGMShGiDMFmjKNUyx1yfZreiMR9NPPWUG6TdqZEveY3MkzGhIOqgCN6mEDLNa5adpod5Q/bmVD62N5NxjuJTqMTH/e/sVu1jQ6kxSjR9VD/NUIRSKj1qjkz2
 2UkupvjS
 ynxi/k8Nv5zd660XPS/3FwQ4KeLvVHz8mSyR5BLLqYmLzZoszCklpklwcHz1OY67yvvzvR6/zngyDb+q8VHVEuiq+weBW9fZrYsZK/8zaIjQgmWSvPEqjhB8zR0GtdAbj0nWvJVQr5zetH8PrA2E3+HqBOx4+B0ibi9vH+mvSDei/Bw8K4rEk94zWqORDDuT/RIAXWbta4ug4XD1cIXpITc5Q6DvEWxED03avNCg9R+kaatPmPoOetKMMXr0IcOSYt5tKInsm1n3qEwVm031BrZWIPGeXzBd95qa75F/qBw6l7DD6kKQYH+128KHHMpuYemChSaZBgg4E6U6YdIoyS+UVOiusRdQ9c+pDgMEK9Mhu71FUobgdD++u2OOk1rgryaMnciIAL1/ZuTFvpdSd/F+qlPimqllQt5Rrfe8vvWHZS3SJFx487bZvFR3xbh1B0pBasmoiVRVHkfKK01+mjfxjLzEhaLHytqLTwyVHYQQ5+/NY5TOWEOf3ds1eShIYxpHQHJlAFgN07a/Lg901rgfoOMnuxwFBQMta
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
head:   dbf0247637dd0601a462793035bdd0b416b30e36
commit: dbf0247637dd0601a462793035bdd0b416b30e36 [114/114] mm: vmalloc: WARN_ON if mapping size is not PAGE_SIZE aligned
config: sparc-randconfig-r071-20251010 (https://download.01.org/0day-ci/archive/20251011/202510110050.VG9YKMRK-lkp@intel.com/config)
compiler: sparc-linux-gcc (GCC) 8.5.0

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202510110050.VG9YKMRK-lkp@intel.com/

smatch warnings:
mm/vmalloc.c:191 vmap_pmd_range() error: uninitialized symbol 'err'.
mm/vmalloc.c:243 vmap_pud_range() error: uninitialized symbol 'err'.
mm/vmalloc.c:295 vmap_p4d_range() error: uninitialized symbol 'err'.

vim +/err +191 mm/vmalloc.c

5e9e3d777b99aa Nicholas Piggin 2021-04-29  167  static int vmap_pmd_range(pud_t *pud, unsigned long addr, unsigned long end,
5e9e3d777b99aa Nicholas Piggin 2021-04-29  168  			phys_addr_t phys_addr, pgprot_t prot,
5e9e3d777b99aa Nicholas Piggin 2021-04-29  169  			unsigned int max_page_shift, pgtbl_mod_mask *mask)
5e9e3d777b99aa Nicholas Piggin 2021-04-29  170  {
5e9e3d777b99aa Nicholas Piggin 2021-04-29  171  	pmd_t *pmd;
5e9e3d777b99aa Nicholas Piggin 2021-04-29  172  	unsigned long next;
dbf0247637dd06 Yadong Qi       2025-10-10  173  	int err;
5e9e3d777b99aa Nicholas Piggin 2021-04-29  174  
5e9e3d777b99aa Nicholas Piggin 2021-04-29  175  	pmd = pmd_alloc_track(&init_mm, pud, addr, mask);
5e9e3d777b99aa Nicholas Piggin 2021-04-29  176  	if (!pmd)
5e9e3d777b99aa Nicholas Piggin 2021-04-29  177  		return -ENOMEM;
5e9e3d777b99aa Nicholas Piggin 2021-04-29  178  	do {
5e9e3d777b99aa Nicholas Piggin 2021-04-29  179  		next = pmd_addr_end(addr, end);
5e9e3d777b99aa Nicholas Piggin 2021-04-29  180  
5e9e3d777b99aa Nicholas Piggin 2021-04-29  181  		if (vmap_try_huge_pmd(pmd, addr, next, phys_addr, prot,
5e9e3d777b99aa Nicholas Piggin 2021-04-29  182  					max_page_shift)) {
5e9e3d777b99aa Nicholas Piggin 2021-04-29  183  			*mask |= PGTBL_PMD_MODIFIED;
5e9e3d777b99aa Nicholas Piggin 2021-04-29  184  			continue;

Is it possible to hit the continue on every iteration through the loop?

5e9e3d777b99aa Nicholas Piggin 2021-04-29  185  		}
5e9e3d777b99aa Nicholas Piggin 2021-04-29  186  
dbf0247637dd06 Yadong Qi       2025-10-10  187  		err = vmap_pte_range(pmd, addr, next, phys_addr, prot, max_page_shift, mask);
dbf0247637dd06 Yadong Qi       2025-10-10  188  		if (err)
dbf0247637dd06 Yadong Qi       2025-10-10  189  			break;

I always feel like these are better as a "return ret;" anyway.  Then it's
just one line to read instead of needing to "break; ... return err;".
Twice as fast to read one line vs two lines.

5e9e3d777b99aa Nicholas Piggin 2021-04-29  190  	} while (pmd++, phys_addr += (next - addr), addr = next, addr != end);
dbf0247637dd06 Yadong Qi       2025-10-10 @191  	return err;
5e9e3d777b99aa Nicholas Piggin 2021-04-29  192  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


