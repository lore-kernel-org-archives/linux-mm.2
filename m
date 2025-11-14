Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C08ECE8D4A
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B86988E0006; Fri, 14 Nov 2025 10:48:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36EC8E0002; Fri, 14 Nov 2025 10:48:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4C988E0006; Fri, 14 Nov 2025 10:48:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 905848E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:48:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4705058E52
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:48:10 +0000 (UTC)
X-FDA: 84109643940.30.F20A0BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7F659160008
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:48:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxcWREvS;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6k+74ZGA0Vdj/ArmDb05rG1QCFGTYyDawtYFIZo2k7c=;
	b=uOynY0+/Qlcj622sDYvbqouQJ7CC5IE0FuDwTc7R56lwf6xZXm0tpgh5b5G105+Zr0FMLq
	xuJuR0AEmgmaqwfDznqtN6jRUXuyxjRbnpVXplaYfFvBe1Rfll3CFqrN7ev278EGUCqJKV
	bpJ0UJLaQtVAriVQ9EuWZE29R/k7gpM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VxcWREvS;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135288; a=rsa-sha256;
	cv=none;
	b=m+dMWcVcjKwhHq/RVyJvc8Al1Cgunso1lGn5F9nstOIrr2dZfCIWB758hQBArgEGHkY60X
	TEdW4Ah7nYhy0nuCJBDRnfYVytBatAR9HtI0OEBMdKQp64IGwL6bTA8vgV2Opr104/tEzd
	PywXNCZ7CAj5xdnkul9xax4cjWrlM8M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5D30E409D2;
	Fri, 14 Nov 2025 15:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F007C4CEF1;
	Fri, 14 Nov 2025 15:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763135287;
	bh=vfbrct6bJzrCc+Mkh/vkmrp/+VzAY67l9cyJGnmW9xQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VxcWREvSw7ifZWkM1yvTpCn19i/Y5OvbOMdF5dRd1xm4xWjctyA0qlMhfljwgDa0D
	 sGBwq6mnnONS1MdJN/12wMATKfVe26UcSEz9MZ15Kek3n4N9ckGuJtzRiXxnJQJ1iv
	 tIUATjxQP7CcPG5kHwSWbTrZYGzX/PiuULTrcOZhn1N09OUYY9K0fPz+IN8cOkeJfE
	 mPZxAQVgSNF3kjFKiQ7BsiEXnWIWfMcJKUukhFgfJpP26TngN5wa4xyGFwGDwSQqtp
	 YyerKFmxatyqlPXRB71bEldfydWnM05KF3SO8cgbZExX1Stn7bJAsMooKGTtGc6LHu
	 q2uuxNMhk7S2w==
From: SeongJae Park <sj@kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>
Subject: Re: [PATCH] mm/cma: Remove CONFIG_CMA_SYSFS option
Date: Fri, 14 Nov 2025 07:47:57 -0800
Message-ID: <20251114154759.76541-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251114094814.3b2efb09@endymion>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7F659160008
X-Stat-Signature: 4u5jc8tstwaa9thgqf1xegmk5jedum97
X-Rspam-User: 
X-HE-Tag: 1763135288-760796
X-HE-Meta: U2FsdGVkX18GIUUcV6FNUPU3asYa1xbqRufYfBiMA1+AKamXzCSQYp/mjzUbvCBor7eKtlKFQJsYD7oxNKa+OVtgXxvmCDUXh7wNfBtbEUCVXf1QfqGHLnsGDWUpELxltoRTiYAa0mdtLr3PbnHI5WrALXa2FZsrOpHkpe/M4CGvn9lWYmOJVgLagRTqGWACDxO0auLnunTal12ZBbwrxz4fDaBRYhgkIfQ6sVb18HuN2u00GWUY30D8YFEye/4sBUvqnKSv0dzp+mRwIGD5m/E9/cE/tczM906lBJQaktUoc6llldrr7uAGY0ThYXNDzoOo7kDT7zMM+bd+Xvy63T4/jR1pKHKgP31O2ySZQf7gRSF4SssWn3u1Bk+Ik1TmPdxyzhcCMjngzpLTnsquPfaQJFVZV62mV3w/INOrLGqx9e1g7AcdUhtYzzcUZCU5/gsDLbaPd1io/IWbZPZ33aLmgBAXOei+aiy8gRslRjRun+NGmtUn8UxC6oHzmqMgIsRDSEoPUi0BpyYZb1vC74FwhQ0IADfcRDfPcMKwLVe/+gJzQOyG+NJRZmMSho5P8CUh7htYgPd2wJzLPjofSLql+o7WBUdRyhZnGqucWFzrUNooahS0kLNiJJZWrXLjdba0zzONRd2da8/ln9+xc89tyKwcyDjtsVS+BUvWI/Ad+0prCyG+w/qaOkaL7EeMH9pH6xzOjUSuYN//n4Dy8bjhi4ihxmuHgJlk0ZqPM/H2f1KwFQ7h7seOX56TySc5qKKLSZrRDw3QsU1YbB1MDsVnxgjIX9xGN+H7TwSEte2w7BuSP7eiEelVfJEZSAarUzGAzaMau7tXta8YjbowYaVctPPLMO8UPRCV9LweFag1cQkSix3/cbrDcPAwT6J64uL472GdKhU3B9wxiuzSskzYjdlMtAMuEKoG7MQY9nD89OzSnHjhxUTA5WzdqyMpTDJ6I8+DsuSQEVLGSZ9
 9r5+YZ8Z
 WpzPqQu8VBH8W0RF6G6F0JBN2f+Urmpie39z1FaANTxMAD2x10V5ZQYI7IdvE7J2t0Hxc0IycrN86SceZiCB9AykDCVGbR/r6RsIC3oEIPN3i+jUHdaJQC8iaMiaYVt42DOmIAkfzSC2iAl3CVBxAAvxk5r5kuiKb0Da3ahQ2+JErHqjfNI84jewUlCr9EkPatdgs5VWW0227sN8JoT5ILTi5X2L5hUNkBkTMKK7W7AWT0vadl2FCZKL23VcrU10oiCp52oy7OkuDfhunZPcjO8LB/Vd9kKmsXrTAPKg8XTrZ5DOrkn6PaoMCdRGMcxwxFUBdFoSrrQiiT+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 09:48:14 +0100 Jean Delvare <jdelvare@suse.de> wrote:

> Hi Seong Jae,
> 
> On Thu, 13 Nov 2025 17:09:27 -0800, SeongJae Park wrote:
> > On Thu, 13 Nov 2025 14:56:36 +0100 Jean Delvare <jdelvare@suse.de> wrote:
> > 
> > > The sysfs interface to CMA has a marginal runtime cost and a small
> > > footprint, there's no reason not to include it in all kernels where
> > > the dependencies are satisfied.  
> > 
> > Overall change looks good to me.  I have a question below, though.
> > 
> > > 
> > > Signed-off-by: Jean Delvare <jdelvare@suse.de>
> > > ---
> > > As discussed with David:
> > >   https://lkml.org/lkml/2025/8/6/371
> > > 
> > >  arch/loongarch/configs/loongson3_defconfig |    1 -
> > >  arch/s390/configs/debug_defconfig          |    1 -
> > >  arch/s390/configs/defconfig                |    1 -
> > >  mm/Kconfig                                 |    7 -------
> > >  mm/Makefile                                |    4 +++-
> > >  mm/cma.h                                   |    4 ++--
> > >  6 files changed, 5 insertions(+), 13 deletions(-)
> > > 
> > > --- linux-6.17.orig/arch/loongarch/configs/loongson3_defconfig
> > > +++ linux-6.17/arch/loongarch/configs/loongson3_defconfig  
> > [...]
> > > --- linux-6.17.orig/mm/cma.h
> > > +++ linux-6.17/mm/cma.h
> > > @@ -49,7 +49,7 @@ struct cma {
> > >  	char name[CMA_MAX_NAME];
> > >  	int nranges;
> > >  	struct cma_memrange ranges[CMA_MAX_RANGES];
> > > -#ifdef CONFIG_CMA_SYSFS
> > > +#ifdef CONFIG_SYSFS
> > >  	/* the number of CMA page successful allocations */
> > >  	atomic64_t nr_pages_succeeded;
> > >  	/* the number of CMA page allocation failures */
> > > @@ -80,7 +80,7 @@ static inline unsigned long cma_bitmap_m
> > >  	return cmr->count >> cma->order_per_bit;
> > >  }
> > >  
> > > -#ifdef CONFIG_CMA_SYSFS
> > > +#ifdef CONFIG_SYSFS
> > >  void cma_sysfs_account_success_pages(struct cma *cma, unsigned long nr_pages);
> > >  void cma_sysfs_account_fail_pages(struct cma *cma, unsigned long nr_pages);
> > >  void cma_sysfs_account_release_pages(struct cma *cma, unsigned long nr_pages);  
> > 
> > Why don't you check CONFIG_CMA together?  I think that makes the change more
> > complete and safe.
> > 
> > I found there is no file that can be compiled without CONFIG_CMA but still
> > including this header file, so I expect no real issue for now, though.
> 
> This would actually make no difference. This header file is internal
> and not expected to be included by any file besides that CMA core
> itself, so it is assumed that CONFIG_CMA=y whenever this header file
> is used. If not, then things would break already, even without my
> proposed changes (due to cma_areas and cma_area_count being declared
> but never defined).

Makes sense.

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

