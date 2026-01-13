Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BF859D0C852
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 11:12:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CC2A6B008A; Tue, 13 Jan 2026 06:12:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2AA786B008C; Tue, 13 Jan 2026 06:12:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183676B0092; Tue, 13 Jan 2026 06:12:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 038A36B008A
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 06:12:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AB6401402A0
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:12:36 +0000 (UTC)
X-FDA: 84326677512.01.01DFFC7
Received: from mail-ej1-f65.google.com (mail-ej1-f65.google.com [209.85.218.65])
	by imf03.hostedemail.com (Postfix) with ESMTP id A954B2000B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:12:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=quHdzbjC;
	spf=pass (imf03.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.218.65 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768302754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rO+by4VRpGoh+64Jlp60LzKBsLBfLOxrwjzwp2adwPk=;
	b=jM4QSfuGMWN7Trk7R+MqMERRBaVsQEuFEFYhSTBavEJf3ccjuZk/+kn2aF9aFxJ23IDcu/
	xDAKTa/wOBA1f4eyh0x9qSsl3YD4XU4ZrkmT+WdGd7/1E7LyZNPkNOovkA64dyb+8DWKKz
	UZSmWZmm0cSv82snahaE3/nKIL9P7Ak=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=quHdzbjC;
	spf=pass (imf03.hostedemail.com: domain of dan.carpenter@linaro.org designates 209.85.218.65 as permitted sender) smtp.mailfrom=dan.carpenter@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768302754; a=rsa-sha256;
	cv=none;
	b=DI7YjWCzzDewhV/r5S5iUuWYmbaLl8r5wUuCC4BDJxgxEyQvm6lXmeuH/heBoKCYaos9oc
	1y3a5fUocLABcSwn9EiIhqmi4ADIsaVGw/hr04UfWnzvX4V1uAVpvoTmBe3m24moWGluSr
	oI/IiYxUBwqj1H+e9aGxAtyb2JUF22g=
Received: by mail-ej1-f65.google.com with SMTP id a640c23a62f3a-b872cf905d3so266775466b.2
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 03:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768302753; x=1768907553; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rO+by4VRpGoh+64Jlp60LzKBsLBfLOxrwjzwp2adwPk=;
        b=quHdzbjC7/29fBZpPPoELlN9ofz4nhceUoSdT30HHd+zY98Wgcco4wKwJ+kf9MK83y
         lntfHK37Hmygz8Q9sJFG5fapMfDihTvO2v0q0H304QSpqvQbKHwtn8xrbH25QdNVvPku
         5DWaBsnM7UDzW+AZz3OV3PoELKv8fSD/w8B0X2tV+rs0rOiD9fr31FZwyX6zdRj1TzHj
         ckvgKvPp+ngQAlXZTxWihd14dozcxzhNtJGT/1j9aAdnLphFwcydQW2Xp8vvOk+vbZfa
         k9oqogf1FIauIxzqYD0WIvBKi2CM1H7EzYiLF2BBGHzlryirCroImN6hYOncRb2xP6pi
         Mgew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768302753; x=1768907553;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rO+by4VRpGoh+64Jlp60LzKBsLBfLOxrwjzwp2adwPk=;
        b=jNjkeK88HuDgB8ImTPDCeHhRbRRue+9w4nZ/F2fbZuUsOKV3LCUBhCET+6Tfy5LZrZ
         GCkLWV45ucD7lUoQ5OzaVfIGrvLSK5ucxhP3R994IxIxVPNKZ3tOWXNMp/uxfKQlJMrI
         srMhJjoLWgyTX+Yi04NJbCAk4+/V2crvje5ZAzD8myPTisEno4W3GzrSq+59ABB/x9jL
         2RMyb8p7RdL2PH46qQi54uXlt/NIXR+YYY0BgM7sjllScIxB4jGVmift6chzBsEWDCTV
         BHCMaA9pLWk+u8SnBS9TB5depCYobE/0knhbgGJL4Nsmc/ZtDSD4oQ74vuPOr4FKjQw2
         JzZA==
X-Forwarded-Encrypted: i=1; AJvYcCW84/DpYQB/VYj8RBp5Tplz8OXtZi4dMV8NGPq/qOZ6Ws8SRPxOVivCuSnJ8VvKMMmPUfOoGyFU1A==@kvack.org
X-Gm-Message-State: AOJu0YxFv4g1q5+2aJLTt9O9zupoXbg0npjBvV4j1Q4p5A1bZdoKNseF
	uAqvydFarsxZMFhZXJtzcYR7ARTZR04qu5vsNuOVJjo3kPjIHI6m2tGfppliGW4IV+I=
X-Gm-Gg: AY/fxX6ESQ34/+VCjHS/59lBRvKbE3DZSo2K/u3MazFzx6WD9dMqmLV/ln6hWj8VyZA
	kGh5Yi3nH2ERDZKIU7q2vkm+LIhSRtJ7T9BXmIWe342wHYM4mw2DEO9fdBLgqVw28BN3t7HZc+I
	Z4GE8paUGBvO6QFZ26Oi9wnjmkD+AEV8ZhGuzsXvRvr1d/29sYpAZxD7fl5Sy6Rd8+WALMHTzyo
	yjwmc5Ax5ycTot8hjkJqmejicqsB5y81+fxj9O8D1/pxD2dhJ4k/bVj/dD9z9Nneog7oSxtaYGl
	A89L7MJdnmG/4CXqCEC7T8vCZp2waIZeS7qbghzrQ6XUm5lUr8HrhIRtebN8sN9ug8mR99AFjub
	LzyokXl4rfu1DBb42IFY/9jwjn8TaMet4Ii/URY873lMMI2UF3mOuVDIWOGKL8BW1a/FsxX9rVA
	eo4Px7sSOT/rpC/7DP
X-Google-Smtp-Source: AGHT+IHheoYbuw2wt4/wnA0dnnGI4fo1ixTrXZWv/VYNJFuJtdOOVWhH3xr0vBxqdOpKsEyM3E+uIg==
X-Received: by 2002:a17:906:fe05:b0:b75:7b39:847a with SMTP id a640c23a62f3a-b8445216dccmr2146865366b.60.1768302752980;
        Tue, 13 Jan 2026 03:12:32 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a5180bdsm2131322766b.57.2026.01.13.03.12.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Jan 2026 03:12:32 -0800 (PST)
Date: Tue, 13 Jan 2026 14:12:28 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Roman Gushchin <roman.gushchin@linux.dev>
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>,
	Dev Jain <dev.jain@arm.com>, Jan Kara <jack@suse.cz>
Subject: mm/filemap.c:3307 do_sync_mmap_readahead() warn: assigning (-12) to
 unsigned variable 'ra->order'
Message-ID: <202601131311.g3lyUAks-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: q6uo15oj6b5b85dkmuub8fott7zt8qbu
X-Rspam-User: 
X-Rspamd-Queue-Id: A954B2000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768302754-353857
X-HE-Meta: U2FsdGVkX1+3ppom4aWr0L8smCwaz9WIek/g+Yu1eY+3AJ7c91ZtBiUq5f2estxZKRIBplfiXX8DB58wByfLe44XhaxCO5NI3rFbxVzUNZdUB/ULD2PFca+ViaA3f+1APcBy8S6zALgfnOdPKvc6Lak/MOBkHIRxhMBihay6BGdIq7lf+06mHPS/DLSLKlSwugQ7H2JPlsLoVB4fC2G7yejkMgNR/OID0MZ2Wvy01m9vnt96oIiycUBlLGOUwgggo6t5565tiiUyURFhgkdqx7r2bMUCGoctm9KPBTVDScxJLFmD9ctX2+MGEYRrpxL+/ThvbV+386Wi8h1R3mmwr5vFSVUYAqKx5a+XainF2ArMvMt0fDa6SECKVGZY8wjmy6Cl3/WvqOWtoEiJoJ6dB25pj+zozISRbKQkXrjTAV4XzJ7ktkr1se3c5tqPHSiM5Q7DvBKt7Y2Cf1vODlmIa1DI+cD9oPOeRJe+5IymPd742rTaPw+UYFeyqEDjnrnkYKkvQ+zvuibzQ3q5p2QdVNe+yeGCJ8sqF15JlZ44F9OTj6EJgBOrli70KnsJfiDV8UBowfsNX17Itrwu8F2LIC9DfBo8OBMw9U6EQXkOte5AmTFZI1xmrJmSlnGAQxw1xh2G0K8Nm2yTC0zuCrQQE1d5E4pMoS5cHA+EfYhMXOztvAqgay5qLtQBk+b73xSYFf89ptDIyvSBsM0xZaxd2Yb24pnLRbe5VNgqzxmhusAm2kz4e7bATU0yH59D7j96SDCzbTC9uerOzTuEUuxawKNej4HYWTH7DtBYc4WaufmnBHNtlWOmtn3gq73h/U42Vwo4Fi7wVxsW8571tbSeLYi52A297p1USCK/gEl+GkxhSf5p3XXvX4XeVsaHvpxMXApyPQL+P89osd8w/JQ4Q8lHW9I6mmuh92VYArHmTJnYPR+BTmGA1d4tMEz/TFvwDt7jtFs6v71sw68u47F
 8moebYr/
 lJMGAOcZt4az7guw2rM/nUqVpWt6JDvaIMOjfx2Drj1xTFatEWCDTALDwM3j9J4udYIvjxeGBPdQgcFDrGn9cBY0jrukoFCNX57OVS0DA9ExrshbC5MZMXxPQ56bDEGNu2H1zpZriisYehAbyRyn5d3YqBESIL0yizoOtuT3w7Q4GG6wXkJhwVP0ngylPvUKNZJG3rRGV4tj3p/Sz8Tfx+oIWKyo5yjz2DdSS5oxxVH7dlLIV1IXeWuR6/xVoEZgbLBxMiB6ReutmNTKMHmcBGl3XT78P4kuNbWmPujbN1lg9NIIB9kjnrlWhAfhrpKovN7orCLI6mIk67i35f6mVR+yJ+5+Z0EUsdmVV8CI5tujKXOFujTHVhbCw1PQKAFSoCqUDbdQnGOra/s4d23NvzeKhIRH6U2ysoun7ZuLdE4rwQEpw9nqMW4RnvpiBuLrzmKaCu7Dw1Q3XErbIHKt7evWIn4kanRMqH8O84WNWI9vYaRG8/nQv7Rxm7j2QbG0LTJv4SSnP52nC25jcetLhtTLj7o9AEy71rXrXe7VgI+NbOnuPhOhVE2slkogECnUR3mAWdV9BPlz9I+6kMgosuHc0V5pbVWd164ZQ25gL7ofkAXAf+NyD4fur5rCDNha3rAwg
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
head:   b71e635feefc852405b14620a7fc58c4c80c0f73
commit: 9f1edf1aedac1b287355f63f768ba4275de72dca mm: readahead: make thp readahead conditional to mmap_miss logic
config: x86_64-randconfig-161-20260113 (https://download.01.org/0day-ci/archive/20260113/202601131311.g3lyUAks-lkp@intel.com/config)
compiler: clang version 20.1.8 (https://github.com/llvm/llvm-project 87f0227cb60147a26a1eeb4fb06e3b505e9c7261)
smatch version: v0.5.0-8985-g2614ff1a

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202601131311.g3lyUAks-lkp@intel.com/

smatch warnings:
mm/filemap.c:3307 do_sync_mmap_readahead() warn: assigning (-12) to unsigned variable 'ra->order'

vim +3307 mm/filemap.c

6b4c9f4469819a0 Josef Bacik             2019-03-13  3248  static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3249  {
2a1180f1bd389e9 Josef Bacik             2019-03-13  3250  	struct file *file = vmf->vma->vm_file;
2a1180f1bd389e9 Josef Bacik             2019-03-13  3251  	struct file_ra_state *ra = &file->f_ra;
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3252  	struct address_space *mapping = file->f_mapping;
fcd9ae4f7f3b5fb Matthew Wilcox (Oracle  2021-04-07  3253) 	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
6b4c9f4469819a0 Josef Bacik             2019-03-13  3254  	struct file *fpin = NULL;
bfbe71109fa40e8 Lorenzo Stoakes         2025-06-18  3255  	vm_flags_t vm_flags = vmf->vma->vm_flags;
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3256  	bool force_thp_readahead = false;
f5e8b140cd1324c Ryan Roberts            2025-06-09  3257  	unsigned short mmap_miss;
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3258  
4687fdbb805a92c Matthew Wilcox (Oracle  2021-07-24  3259) 	/* Use the readahead code, even if readahead is disabled */
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3260  	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3261  	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3262  		force_thp_readahead = true;
4687fdbb805a92c Matthew Wilcox (Oracle  2021-07-24  3263) 
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3264  	if (!force_thp_readahead) {
38b0ece6d76374b Ryan Roberts            2025-06-09  3265  		/*
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3266  		 * If we don't want any read-ahead, don't bother.
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3267  		 * VM_EXEC case below is already intended for random access.
38b0ece6d76374b Ryan Roberts            2025-06-09  3268  		 */
38b0ece6d76374b Ryan Roberts            2025-06-09  3269  		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
6b4c9f4469819a0 Josef Bacik             2019-03-13  3270  			return fpin;
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3271  
275b12bf5486f6f Wu Fengguang            2011-05-24  3272  		if (!ra->ra_pages)
6b4c9f4469819a0 Josef Bacik             2019-03-13  3273  			return fpin;
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3274  
dcfa24ba68991ab Matthew Wilcox (Oracle  2022-05-25  3275) 		if (vm_flags & VM_SEQ_READ) {
6b4c9f4469819a0 Josef Bacik             2019-03-13  3276  			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
fcd9ae4f7f3b5fb Matthew Wilcox (Oracle  2021-04-07  3277) 			page_cache_sync_ra(&ractl, ra->ra_pages);
6b4c9f4469819a0 Josef Bacik             2019-03-13  3278  			return fpin;
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3279  		}
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3280  	}
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3281  
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3282  	if (!(vm_flags & VM_SEQ_READ)) {
207d04baa3591a3 Andi Kleen              2011-05-24  3283  		/* Avoid banging the cache line if not needed */
e630bfac79456d3 Kirill A. Shutemov      2020-08-14  3284  		mmap_miss = READ_ONCE(ra->mmap_miss);
e630bfac79456d3 Kirill A. Shutemov      2020-08-14  3285  		if (mmap_miss < MMAP_LOTSAMISS * 10)
e630bfac79456d3 Kirill A. Shutemov      2020-08-14  3286  			WRITE_ONCE(ra->mmap_miss, ++mmap_miss);
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3287  
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3288  		/*
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3289  		 * Do we miss much more than hit in this file? If so,
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3290  		 * stop bothering with read-ahead. It will only hurt.
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3291  		 */
e630bfac79456d3 Kirill A. Shutemov      2020-08-14  3292  		if (mmap_miss > MMAP_LOTSAMISS)
6b4c9f4469819a0 Josef Bacik             2019-03-13  3293  			return fpin;
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3294  	}
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3295  
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3296  	if (force_thp_readahead) {
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3297  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3298  		ractl._index &= ~((unsigned long)HPAGE_PMD_NR - 1);
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3299  		ra->size = HPAGE_PMD_NR;
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3300  		/*
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3301  		 * Fetch two PMD folios, so we get the chance to actually
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3302  		 * readahead, unless we've been told not to.
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3303  		 */
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3304  		if (!(vm_flags & VM_RAND_READ))
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3305  			ra->size *= 2;
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3306  		ra->async_size = HPAGE_PMD_NR;
9f1edf1aedac1b2 Roman Gushchin          2025-10-06 @3307  		ra->order = HPAGE_PMD_ORDER;

HPAGE_PMD_SHIFT is zero in this config?
ra->order is a u16.

9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3308  		page_cache_ra_order(&ractl, ra);
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3309  		return fpin;
9f1edf1aedac1b2 Roman Gushchin          2025-10-06  3310  	}
ef00e08e26dd5d8 Linus Torvalds          2009-06-16  3311  
38b0ece6d76374b Ryan Roberts            2025-06-09  3312  	if (vm_flags & VM_EXEC) {
38b0ece6d76374b Ryan Roberts            2025-06-09  3313  		/*
38b0ece6d76374b Ryan Roberts            2025-06-09  3314  		 * Allow arch to request a preferred minimum folio order for
38b0ece6d76374b Ryan Roberts            2025-06-09  3315  		 * executable memory. This can often be beneficial to

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki


