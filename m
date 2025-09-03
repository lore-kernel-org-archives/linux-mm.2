Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC57CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 10:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7565D8E000A; Wed,  3 Sep 2025 06:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706DD8E0001; Wed,  3 Sep 2025 06:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5828E000A; Wed,  3 Sep 2025 06:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 495198E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 06:24:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EEA5C1A05C6
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:24:26 +0000 (UTC)
X-FDA: 83847554532.13.1A38A26
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf27.hostedemail.com (Postfix) with ESMTP id 0ECB140009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 10:24:24 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L5mop/IM";
	spf=pass (imf27.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756895065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iq+2oZ/KcgO95X7z7Iwm4V3d8FmvBHKC4zBSx2fR9sg=;
	b=4JVWe1R6BHXXL8TZ5FnxObTWUb+Rnn0Hj5O9++7aNlgokZkVHaeuScjR7jL6XW3dsAsqCc
	DZWhPl2tqTCqqJ/+txDaryVmIfF5j7VYWOgwzLldWD9ysyVxAjwWX4FPlRUNZ/721MxYEW
	NyiTP1EVYQlSKe+b1jaD92lh4zejj5o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L5mop/IM";
	spf=pass (imf27.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756895065; a=rsa-sha256;
	cv=none;
	b=lI4xZD/CrzT12/6x/F34U4FsXc9RitumkbaOy86Z1tGy5y46x6P8Ne3ZTE272eztcRYltk
	FvJ9h5ENBnpKjjefmdYdIIg1CqaDJ1pM7IREkCuQU1BjyPoEVx2NjCYgMahyRcTgPTD2uc
	7zxzWzQGgrhs1hv64p+/punaTfVEh0w=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-45cb6180b60so2444325e9.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 03:24:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756895063; x=1757499863; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iq+2oZ/KcgO95X7z7Iwm4V3d8FmvBHKC4zBSx2fR9sg=;
        b=L5mop/IMTegxU4c6gjA9dKT43T3h2UbeYImY/uyl5JKHXLiVpvJc2XaJoaVNPfa0Gw
         VA4TUrRJF5t0Slh7EcEUhYxRfJ9iv9ZhJtNFIC3xwu+L4pyGyn96fOCGjTGNyZi3hLIZ
         H6k0yNDw+XDLlHsrO0MaMorGymP6hjw7ioNnFlT6BH53yz0CZQueW2jGdkribwmGw+fq
         7hcWLySeG2YWjyy9Ma/KY4EQlBZ/Lx4+X10hotrDyPK68kWaF7xQeQw8aoH59ukoYZB+
         kdMbnOHdPgEcGZmzoLIhFoSlF5X6YVcHwbr+91J5hlLHzXEShDzjz8ItBmVYTvVmIXYX
         CbfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756895063; x=1757499863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iq+2oZ/KcgO95X7z7Iwm4V3d8FmvBHKC4zBSx2fR9sg=;
        b=r3MrGK44kFzzWFs1pVPbxGFpQRVBKFdfCQ//yNXfH0MAZgEyfLjKDu+glSsDpIWDlD
         q45FNcD7jg7BssqC9hZh/N04w6PqWS9lASoO37P3wOpskQQtw+mGHT0wgt9CwusZHWvG
         BVX0f+8K9I+kG+djV4C5o8Uw3XOjV1VNPXb1Ukp9Xw4ZnBjlGfu3TE31M87BR6BdakRD
         oQ588Tr/Ye3tLbW4WsfyWgCAz6VjX2THMKbDAugofaQz07hxF5yxG0BCA0lm21L1qhBA
         F5GC/7a1jwIWgdODGOmMdNyxWrRGPaRbAIcvInofYs4wmWFWDXtmJSejS84M1F5EVRqu
         R1YQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcYQispfZ/YbV1SfMxQqif9N11LquTOlSevd1k8RoCa02YxkSdmXeveR+hv/lbY5B+YqG6CCov7w==@kvack.org
X-Gm-Message-State: AOJu0YyhDHGmd1NNuQPg/55r+XW4+lXGZ/5PY6TIiAkD9/Z+KJyo7qs/
	EsOH2Jb8Huh0329KJdfutqT64dyUN0c6K/F0/xrOfaZiCTgDUT9SJyTX
X-Gm-Gg: ASbGncsuVUerMjgqtgKDe1YCUXe42L1egzq9inZAce0H3J9a6h/CATFaL7n0fXRevkf
	CZt0TTxqRbjTiOLiIMa6614GJ+Eclhg7dc0+5NoBvR1Zeqr4U3VPqTlaVENq9emYkRaz1E3b25y
	E+rm+RmL8u6HwnK6rmASlNjY68oB6J+il1K8FU6r36+/dJkRRIgFBXziBXBnwnlE6/7PncMIKb5
	+i6ijeMd8Q554mHnDmBV2iofLQtr16wsbOUPD5SrHAyx0bXISq/VjbIiLrBtdNadr67H1ae4Ktv
	Nbf9E3UyW+JLYVLvqnf/cgySia3YzPGX8nVdbsqCsOmtNYEJdYbRUsov0CHG86xRiTRKs19+aF0
	rKLhihd56J69Aad89XOMnAuozWkkNUOoiiai2qa07sn0qiSpTLw==
X-Google-Smtp-Source: AGHT+IHjlg0yHyZ7YsY89pq9m16v4pKhC6s3zw1wicDWknab221B4wj1sid8VcPOZQd1k2UL+vWaMw==
X-Received: by 2002:a05:600c:c8a:b0:45b:9afe:ad48 with SMTP id 5b1f17b1804b1-45b9afeaeefmr51851595e9.16.1756895063039;
        Wed, 03 Sep 2025 03:24:23 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:52::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34494776sm22895356f8f.61.2025.09.03.03.24.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Sep 2025 03:24:22 -0700 (PDT)
Date: Wed, 3 Sep 2025 03:24:20 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: kernel test robot <lkp@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Usama Arif <usamaarif642@gmail.com>, oe-kbuild-all@lists.linux.dev,
	Linux Memory Management List <linux-mm@kvack.org>,
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <aLgXVIxyFpvZ9PU7@devbig569.cln6.facebook.com>
References: <1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason@gmail.com>
 <202509031744.HcibSETe-lkp@intel.com>
 <c41c82f0-e5c3-4c2e-b711-3ddf8fcb0135@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c41c82f0-e5c3-4c2e-b711-3ddf8fcb0135@suse.cz>
X-Stat-Signature: bssb7csmhwpwakdnbmd4seaca4nhbbgz
X-Rspam-User: 
X-Rspamd-Queue-Id: 0ECB140009
X-Rspamd-Server: rspam01
X-HE-Tag: 1756895064-474054
X-HE-Meta: U2FsdGVkX19vNUhWSJssZR2aQP90iVEf4suuA9SkwNKByrOue4fYCaQjpHeaDiEu8B4yDavwT6RwStzuS+dGimWapHwhUJ+0Ne7RlfJVj03hyZ7IEixG5GMpzey/IE3tJlEJtPVPr00xuFBrjBSMjezxQ5g9OLcWmKcOxh8LR3oiy7stdYvr2YNqpAuA8DbJHldZVD18nM0qbm4OWEbj8TGDdNIs81SLZIgpnYtbESNSt62B9IDdtMRgz3mquWa3xPo0+9EgTqOBIZ/UIoWIq7wySsx0hQKWjNDvdhFowwB3kBfsA9+Q/ILdYmTsaYp6Jw1DXrMfoX5cHkjrH2U6ElGAHwI/GU4+n0Alb9HXBv5X149+WqujSTwJj7Ne0KA+tqlPzKsSrrovhYprh03VP9chbyIVF3TZlywlIjtRqI8o3UY7qs6tJuW1NnRYf8/taCrvrTpCR/SEUXxiJiiV72rIEgxm0LitB0yr3MboFXNT4O3oyoCxk0W0ia3YSewv+xzGjVuYa9V/JLhiMmCRiC4aR1FKrels/LVlHmOhFTOBfUftMwN3Aw6Bqwv5gvkniBX1uTxeELKmAnj9KpK/5E3FzwDLtDkbUTaZ67ojAv9tPdEGF5EOF1ZnXNV1WI5GwZQKtYHg7HJ64OIrMmrsQg3tx3MSjL8OoFkDAEiSVDB8jmt2Qtk8ZLyWoUODUxNWXsY8l1l4c4bnfejzzGnk+BTMwmR4qJIStycUuiHwCFHk3KOzQ0XUhl9WnaEtQhnUIM1iDzNPLyoG+W0ZUIktUD9Tq0X469Qs9eJbwmgqWTQ11qUxTA0kNrcr7ikwWyySGFRZOyR32ewT9Vm0zZqURNIgc0mb+Uxv0qo/155W5Un9/XiLtrZ8VoUukHe7/auOM5pPaL49Z14KMcyF43MKL1OANibO9PF1q6Z8uA7Wmxf4SoPK04xMvnVxWvxnsFy3RxQ1U6jIosJ3S07al1U
 mwrz+G5X
 ZHZp4zFcxFHTOZ926TaLuegTivFV6e62l9C+3uLHI+oZ4TgkF5zFio6Zm5wGsDlHSk6aHiyydB0koz09RAmoiZYl1mIcL7SE3t0e/T/L8e8QtpmB7MopUL1QZcZgUAPeHqdgkH10QyWRHsodJt7UCCsdXhFclCHrsRTnQ0l4bnuRPJgaJ9/UkWJt8BGG/vq+JGwkJ5c1H3A3BFVYxNAOYsY3olVMZGkHtBSGoCagNh+TtOIIGDJIo3nFCVWe9N78duUvLYczo/csi0gurL8qUv/cQGJ0+kAsPkKtQpO9PJLe2f2yctXJ6Z2suIONcGMuRIX0/MS4OLKwupZZzOq5UbWsbKyc4XCcWs3BY8Y2cSVV2/my63yGKlhC/12HrwcbLwbqtMrY84bV8HlSCLkTB7xz6rJY4K4g3GTp5P7B3fTOzr7m8TcEAumXBESS9irJq3XeGQ+CzDgejuRiMviOVcA7JmpGICpzfzAo513Va4bNaN6WixvcFlDsFJBS1HTm9LrrweWgxZUtFQiCFqRBA1AWxXoxX4D65KB9HRV0g5XpZPIpCG8v9XIlnn3Gbvm2kUGA3jVqDqvxN1eBibxchwmPhbR07/HBvXZin0IZFVAaIUYnmiDTBO6lFW1g4rxyu0mpC1RWc1XOhtexXopxXFC9D3RDb8d6+yAICKvJrsOOsduecOesVBEVHArZJWhrh28aECwLe84z6LDY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 12:16:45PM +0200, Vlastimil Babka wrote:
> On 9/3/25 11:47, kernel test robot wrote:
> > Hi Yueyang,
> > 
> > kernel test robot noticed the following build warnings:
> > 
> > [auto build test WARNING on akpm-mm/mm-everything]
> > 
> > url:    https://github.com/intel-lab-lkp/linux/commits/Yueyang-Pan/mm-show_mem-Dump-the-status-of-the-mem-alloc-profiling-before-printing/20250903-000616
> > base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
> > patch link:    https://lore.kernel.org/r/1491df0ac12a7626b7c9b00e26a6e10adb8c9045.1756827906.git.pyyjason%40gmail.com
> > patch subject: [PATCH v2 2/2] mm/show_mem: Add trylock while printing alloc info
> > config: i386-buildonly-randconfig-001-20250903 (https://download.01.org/0day-ci/archive/20250903/202509031744.HcibSETe-lkp@intel.com/config)
> > compiler: gcc-13 (Debian 13.3.0-16) 13.3.0
> > reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20250903/202509031744.HcibSETe-lkp@intel.com/reproduce)
> > 
> > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > the same patch/commit), kindly add following tags
> > | Reported-by: kernel test robot <lkp@intel.com>
> > | Closes: https://lore.kernel.org/oe-kbuild-all/202509031744.HcibSETe-lkp@intel.com/
> > 
> > All warnings (new ones prefixed by >>):
> > 
> >    In file included from mm/show_mem.c:18:
> >    mm/show_mem.c: In function 'show_free_areas':
> >    mm/show_mem.c:336:49: error: 'NR_ZSPAGES' undeclared (first use in this function); did you mean 'NR_STATS'?
> >      336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
> >          |                                                 ^~~~~~~~~~
> 
> This is from a different patch and being fixed. Interesting that lkp will
> report additional warnings even in presence of prior errors.

Thanks. Understood.

> 
> >    mm/internal.h:560:16: note: in definition of macro 'K'
> >      560 | #define K(x) ((x) << (PAGE_SHIFT-10))
> >          |                ^
> >    include/linux/printk.h:512:26: note: in expansion of macro 'printk_index_wrap'
> >      512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
> >          |                          ^~~~~~~~~~~~~~~~~
> >    mm/show_mem.c:298:17: note: in expansion of macro 'printk'
> >      298 |                 printk(KERN_CONT
> >          |                 ^~~~~~
> >    mm/show_mem.c:336:49: note: each undeclared identifier is reported only once for each function it appears in
> >      336 |                         K(zone_page_state(zone, NR_ZSPAGES)),
> >          |                                                 ^~~~~~~~~~
> >    mm/internal.h:560:16: note: in definition of macro 'K'
> >      560 | #define K(x) ((x) << (PAGE_SHIFT-10))
> >          |                ^
> >    include/linux/printk.h:512:26: note: in expansion of macro 'printk_index_wrap'
> >      512 | #define printk(fmt, ...) printk_index_wrap(_printk, fmt, ##__VA_ARGS__)
> >          |                          ^~~~~~~~~~~~~~~~~
> >    mm/show_mem.c:298:17: note: in expansion of macro 'printk'
> >      298 |                 printk(KERN_CONT
> >          |                 ^~~~~~
> >    In file included from include/linux/spinlock.h:89,
> >                     from include/linux/wait.h:9,
> >                     from include/linux/wait_bit.h:8,
> >                     from include/linux/fs.h:7,
> >                     from include/linux/highmem.h:5,
> >                     from include/linux/bvec.h:10,
> >                     from include/linux/blk_types.h:10,
> >                     from include/linux/blkdev.h:9,
> >                     from mm/show_mem.c:8:
> >    mm/show_mem.c: In function '__show_mem':
> >>> mm/show_mem.c:399:32: warning: unused variable 'mem_alloc_profiling_spinlock' [-Wunused-variable]
> >      399 |         static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
> 
> This is the warning
> 
> I think you can simply move the definition to the existing #ifdef
> CONFIG_MEM_ALLOC_PROFILING block above the spin_trylock(). The kernel now
> uses a new enough C standard to allow this and not only at the beginning of
> a cuntion. While not encouraged to do that in general, this seems to be a
> valid use case.
> 

Let me quickly fix both and push v3

> 
> >          |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >    include/linux/spinlock_types.h:43:44: note: in definition of macro 'DEFINE_SPINLOCK'
> >       43 | #define DEFINE_SPINLOCK(x)      spinlock_t x = __SPIN_LOCK_UNLOCKED(x)
> >          |                                            ^
> > 
> > 
> > vim +/mem_alloc_profiling_spinlock +399 mm/show_mem.c
> > 
> >    396	
> >    397	void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
> >    398	{
> >  > 399		static DEFINE_SPINLOCK(mem_alloc_profiling_spinlock);
> > 
> 

