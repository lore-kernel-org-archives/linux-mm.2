Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B4CED6554F
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 11:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EB96B0005; Wed, 17 Dec 2025 06:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC406B0089; Wed, 17 Dec 2025 06:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FB256B008A; Wed, 17 Dec 2025 06:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 59AA96B0005
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 06:53:12 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA1658B84B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:53:11 +0000 (UTC)
X-FDA: 84228802182.15.A14FB1D
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD81140011
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 11:53:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dVyILFBr;
	spf=pass (imf11.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765972389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oliDIUiEaAM81fXPI/jGxdfC+4cPbCHWAn9+NEqY32c=;
	b=04vJYYXFvBnuqj9UdgRW/1sfAPh1gn7LjfowgdyJa+upHmjtRN4jKEC+MVwurX/vFLCmYE
	PHuwUZPP2YXR5aZfz1AQtEaCD0pCm9X7N4fwDh1wkrJAMnZIzRYHjAp3+inYCjToo6icof
	4uIrWf6l83qKQahqzZSoqGgP88sA1pY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765972389; a=rsa-sha256;
	cv=none;
	b=J/bUb1DLMaouvuEgtCg++Np32sCiO3hsOU7uSE8HRiYPyPYHO7oqPgRAfce7iiFMUY65E3
	++I5ws9ym0j1syFTYBp69PMX9leB+7+SOtnesgYwVct+lzveOOiLisIG9qrVqwQDF7IsXQ
	7zLhMR5SkTMFsVvOcEyQz6+IMYsi5ws=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=dVyILFBr;
	spf=pass (imf11.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.51 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-b79d6a70fc8so997902166b.0
        for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:53:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765972388; x=1766577188; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oliDIUiEaAM81fXPI/jGxdfC+4cPbCHWAn9+NEqY32c=;
        b=dVyILFBrD/fk76Tx5OSstTLR+S7NyLbTVkbliXYiHE1fI1e/3acSvppBaUEieHqiVq
         FJgSv/S6XA8vBvQTDZOwsB3iPNzsBlyeigBVF15wGG92Mp/W2uO/zZdKmPhZnN+MEIla
         DvAzSZ4V86vLY5vvHg+NXPTf+ulurbrdcD2vSy7MnlcTAw6exuOHTSJImgUZIvoGaS8a
         beXc5I3mMI33znQKoMehgIaJMQtnm6uugt3V636lgTe8Lf4VoKnjpYRKmPh5dpYBcbgl
         iqOSL4ScKE7QWz0sgF3DMe5bU9mydrRPGdwO22QYgo3t9sHaF3D16UaolA/ggOXFNqpO
         +F2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765972388; x=1766577188;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oliDIUiEaAM81fXPI/jGxdfC+4cPbCHWAn9+NEqY32c=;
        b=S85WhDM4yQ+r+d3kYDbzsxSdq8AQz07CGvuMNU9GVtDR8zTG6n6LKLkXYpEIu4zQ0E
         3xuMJ6ETLXdVgyLNXYk0JfLJhoYoe7+9/+aQ+1EzmMHzTf/6/dcWoMmHaO1j4HHa8F+q
         98XlZN7r7tiwGQN8ETzl+4JJgfljmEi+uQFQzqkfZjA35aI+roQljliVxFq13nljAKDO
         K4ss0P/y+W83V9zmqj1Vk2jcLYxjHi16AvqnmpBnZNfb5TI+lHSnWxVWowE5H4qIBNh0
         v82pRhTmFohmePPlO7/Tmc+lW7mBR4hLQZVz8TctHMHMPfUpz7cmHAzbHtiZhJ+xfW3M
         bROw==
X-Forwarded-Encrypted: i=1; AJvYcCU4WMMsemO/wLTdnaP9yXxdMGuomLqRrjJWzPpq1N2y+vYcgDOPjeFhZEwjKtXRi+INmvvAmHszfg==@kvack.org
X-Gm-Message-State: AOJu0YzU5/vfC88WQm0efqEbM42LT3ZMSGjEW6hAmW3TackSnN9iohHH
	WFqhdpomegyUlTgi2hK5c2zp1hHii5zYODTm4EWeuhlCuTczoZ0TCv8y
X-Gm-Gg: AY/fxX40gY4WDEHcRKLfRllu2LM0Sxl6AjLwAnyAMV/Zu5VoKzVlC8uDIP5lQp0Xpki
	pcYdqBYPv4iZ8NIiXn0nFUTj7EddcZQ9293IOEn6yaWgweAxPMUoJe5eEE0U+xloru7PG16QfD3
	+JPtnhCLRfIBKSFJi8CFJcZoIPATXvxCbMKb/rlMUtdRO70htHLl/8FZBM8WSg0g+euOVksOCo9
	eWUr9/chG+x8UQlL4/nPQm+jIxz4J3TPaSfR/lDZ274L33xxzeDktNfL7dUpdyP5ija8hxLvjQ6
	WIiX/VvqqAYswUxjav1rfoUzeLERPSModJjf/xHUrzZaz1mpHTG/++7erp1gRhU6vKSlveh35zB
	tVRQ9ellcnpPkzV02y84RtUpIioNaF1VIPHWA9NXzHdprp9/kwO1M0LS8vb1JTXgh5PSh04j0+s
	9urGsYkCwB15CYA9KlNTrH/BZfl9ccw+6Ccrec5b67onNT9CzHZGLZzdgEzH9Zl0DPSxECwg==
X-Google-Smtp-Source: AGHT+IHRKWPWVx0T5T2V5i4he1Sc1dU48282q7ThJX1s1zq7LXBYN6/i0oWEP8PfTNAxBdnlUdN2/w==
X-Received: by 2002:a17:907:6e9f:b0:b73:79e9:7d3b with SMTP id a640c23a62f3a-b7d236637d3mr1852932266b.25.1765972387802;
        Wed, 17 Dec 2025 03:53:07 -0800 (PST)
Received: from f (cst-prg-23-145.cust.vodafone.cz. [46.135.23.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7ff7e5e79esm429244666b.46.2025.12.17.03.53.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 03:53:07 -0800 (PST)
Date: Wed, 17 Dec 2025 12:52:55 +0100
From: Mateusz Guzik <mjguzik@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Oliver Sang <oliver.sang@intel.com>, oe-lkp@lists.linux.dev, 
	lkp@intel.com, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Baoquan He <bhe@redhat.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org
Subject: Re: [linus:master] [mm/vmalloc]  9c47753167:
 stress-ng.bigheap.realloc_calls_per_sec 21.3% regression
Message-ID: <e4b6sjeh22uqhxhxudsbanlnyo2potwowuy7mkrp6tvxnftjn4@mcjyes2s3eu6>
References: <202512121138.986f6a6b-lkp@intel.com>
 <aT_8woTbtklin3Bh@milan>
 <aUI/MZ8sGDt8toOC@xsang-OptiPlex-9020>
 <aUKONAP3CZn1kZw6@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aUKONAP3CZn1kZw6@milan>
X-Stat-Signature: ew4dhnrezhskd4gtoapjpaib4r8wggt7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AD81140011
X-Rspam-User: 
X-HE-Tag: 1765972389-399820
X-HE-Meta: U2FsdGVkX1+xTLnfDYJ9g+mhMHSevJUSRMfli5BEs125PcwHRBXfp/SmK6bAE8k4WrvLGmjTiAFJK75J/PWEMqXOftWIA8B5yok0eZpTxNr/GxHjEw/fvpKPjiUqSUkTFF8ps1e9hRJN6lTndHxmOl7cqxG8K6yYBB3BlLnk7bwsnxzuRBy0DWz5ATz1nvbXBhP4gTDGOnuYcC0ahSMdJAGnoyPlrhkL5SIyiPl3t06qX05pnRFV/e9pbQZA8wCbCyLsvT4sulP2pRNnORz//rYkMrBvQQV6MoGxyApnnOZgSvJ/5gxKMjjBx6ySWKhQoP+XVk1YfrT6DFHDCe2pamKKjAfmRtumIzJmxoInqR5Z4HlcZcy+Te9KeyfIhFdIQfVfOJ+HRM9KHGWUnPrab/CL9nHi/MEN8+3j6aXMdhMtbu7wN0UOUQqnP9eXS2B3JfNMotysEGJ055imyXJRBb1XHJleNvkrCAIhDSBZWzJaTC2jtSrCCwl49SRX2i3rzicmVIk8nnSaHNStVQB5qkQ9Kf16nROPKSaCIdW11/lNS/fUQxZeNY3GZQqQri4id/5MZuDJXeVBnj1auF1wEOavTledvKqe8AI24vgV45x9Dq7UQz9uANVgY6U3am5gOgVfu581R51qLfYFsja0UmXbLafe3JoWtJZvSJF8dkSRbPyUY6MI+GuzwRq67EoHd6ENqVJHjwcOLuA3CFGkgv5IfsR4TUPgSwh2xDGSsxfV26TBl3AZU7zR0wD+NiyGXXixPXwtJ5agrtkbg6abtel9ErVDFpvqVyqTCTU7crMFlGUeBqrZDkF8q9lJkwfq9k7JoTAgz1s2OFHI3Qw/PuNBEk5L5Wj0JZ9YMOJGle6qykdlxfXNuDpQcp7uPnuUL1D7Ub9nArEbEO96pt57COSzTuKFeP8qSTMfJNTPWNvjzRWKH7vvjuOLfxOgu3/+HN8TSpVh0xxfkbmudJD
 9Yz7FzlG
 xR991qxvfvhklxO1iYWSVTxfGNvlzjO2XYs05mJ59MMZY2dkbz73uUCfIBOiBF3AyqgDE6eDZ8kDogyjxfD64g3WYqCabYWls5wCU+CY5yPueENU+2QujTB3k4MXh8AwvzHpA/zGwMbfN5MoY2l2NvoX05KTWIMwRPA5eu8/4DRv0hl7YBigSwWR63YUJd1gPhDiyc8VYCXc8vrbzbbB7sC7q/fEkxsz13Jjnwy4APH1GUK/yFhZFua8V/CUpN2iWYStDkIduGd4g7veGcGL3OsF52KHqA8qJgDlTkfpLI6OOxCxz6HEHGPtxFQzRRMgfNvE3AuSybVhbd8xuhiKfdTk4kwMy+x/MiXqLZwbfSejbj435dNOCYp6B+PNeKyUgwKiPmkivQQTAQjlNO/mExMvZZZiSPp768e2Sm7+78yjgvXs4GaJNsNLFtx7lh0SRa3IZFvuZ3vNBA2a9EPrAJYsSxHMkreSU6KDnQxohkQqr9wOQHwfZCXw21kb0AP/fkeobi8xDIIfYtW5pcqeLsSvlSc5yOELYywwdI9KkJBQR6Xvg+wl7VBm4T7tk4MKeWzu3yRd4fU3J7hze/NZitYWV0xAtq8ZK1rRryZYfHo1Z+z6aDH5Xyav61bctBJ5LuhXp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 12:04:20PM +0100, Uladzislau Rezki wrote:
> Hello, Oliver.
> 
> > > > 
> > > > Hello,
> > > > 
> > > > kernel test robot noticed a 21.3% regression of stress-ng.bigheap.realloc_calls_per_sec on:
> > > > 
> > > > 
> > > > commit: 9c47753167a6a585d0305663c6912f042e131c2d ("mm/vmalloc: defer freeing partly initialized vm_struct")
> > > > https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git master
> > > > 
> > > > [still regression on linus/master      c9b47175e9131118e6f221cc8fb81397d62e7c91]
> > > > [still regression on linux-next/master 008d3547aae5bc86fac3eda317489169c3fda112]
> > > > 
> > > > testcase: stress-ng
> > > > config: x86_64-rhel-9.4
> > > > compiler: gcc-14
> > > > test machine: 256 threads 2 sockets Intel(R) Xeon(R) 6767P  CPU @ 2.4GHz (Granite Rapids) with 256G memory
> > > > parameters:
> > > > 
> > > > 	nr_threads: 100%
> > > > 	testtime: 60s
> > > > 	test: bigheap
> > > > 	cpufreq_governor: performance
> > > > 
> > > > 
> > > > 
> > > > If you fix the issue in a separate patch/commit (i.e. not just a new version of
> > > > the same patch/commit), kindly add following tags
> > > > | Reported-by: kernel test robot <oliver.sang@intel.com>
> > > > | Closes: https://lore.kernel.org/oe-lkp/202512121138.986f6a6b-lkp@intel.com
> > > > 
> > > > 
> > 
> > [...]
> > 
> > > > 
> > > Could you please test below patch and confirm if it solves regression:
> > 
> > we directly apply the patch upon 9c47753167, so our test branch looks like below
> > 
> > * f7991e8a0136cb <---- below patch from you
> > * 9c47753167a6a5 mm/vmalloc: defer freeing partly initialized vm_struct
> > * 86e968d8ca6dc8 mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
> > 
> > but found it has little performance impacts
> > 
> > =========================================================================================
> > compiler/cpufreq_governor/kconfig/nr_threads/rootfs/tbox_group/test/testcase/testtime:
> >   gcc-14/performance/x86_64-rhel-9.4/100%/debian-13-x86_64-20250902.cgz/lkp-gnr-2sp3/bigheap/stress-ng/60s
> > 
> > 86e968d8ca6dc823 9c47753167a6a585d0305663c69 f7991e8a0136cb0fdf35f11e28a
> > ---------------- --------------------------- ---------------------------
> >          %stddev     %change         %stddev     %change         %stddev
> >              \          |                \          |                \
> >   48320196           -10.9%   43072080           -10.8%   43116499        stress-ng.bigheap.ops
> >     785159            -9.8%     708390            -9.7%     708644        stress-ng.bigheap.ops_per_sec
> >     879805           -21.3%     692805           -20.7%     697312        stress-ng.bigheap.realloc_calls_per_sec
> > 
> Thank you for testing. I had same expectations. No difference.
> Honestly i can not figure out how: 
> 
> * 9c47753167a6a5 mm/vmalloc: defer freeing partly initialized vm_struct
> * 86e968d8ca6dc8 mm/vmalloc: support non-blocking GFP flags in alloc_vmap_area()
> 
> can effect performance. I am not doing anything related to performance.
> I would like to ask you if you could test one more thing. I see that
> 
> [still regression on linus/master      c9b47175e9131118e6f221cc8fb81397d62e7c91]
> 
> contains also below patch:
> 
> <snip>
> commit a0615780439938e8e61343f1f92a4c54a71dc6a5
>     mm/vmalloc: request large order pages from buddy allocator
> <snip>
> 
> where we try to use larger order for vmalloc. Could you please revert
> it and rerun same tests?
> 

This being stress-ng it is not doing what you think it is doing.

Profile shows increased contention on swapinfo spinlock:

        %stddev     %change         %stddev
             \          |                \
     40.08 ±  2%      +9.8       49.92 ±  2%  perf-profile.calltrace.cycles-pp.native_queued_spin_lock_slowpath._raw_spin_lock.si_swapinfo.do_sysinfo.__do_sys_sysinfo

The spinlock and the data it operates on are not annotated.

The commit deferring freeing adds 2 global vars which most likely
shifted things around to add cacheline bouncing.

That's a 3rd case in last few weeks that I know of.

I asked gcc people to do osmething about it, so far no takers:  https://gcc.gnu.org/pipermail/gcc/2024-October/245004.html

