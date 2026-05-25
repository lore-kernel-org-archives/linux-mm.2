Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F99CD5BAB
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 02:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A354E6B0092; Sun, 24 May 2026 22:03:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0CCB6B0095; Sun, 24 May 2026 22:03:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 923196B0096; Sun, 24 May 2026 22:03:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EED36B0092
	for <linux-mm@kvack.org>; Sun, 24 May 2026 22:03:20 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 14865140DB8
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:03:20 +0000 (UTC)
X-FDA: 84804294960.30.8BEB878
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf30.hostedemail.com (Postfix) with ESMTP id 2FCFE80005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 02:03:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="baShfB/l";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779674598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a1dR+qUQ11esis+j6Iq3N8urMnTyCI4LYg4f+Ph15u8=;
	b=jV0nav/fwNJj7ER1EcuDv0XXb0mJ6FDfX1tlXOJfHucQ6f1Ita79gVnmMlGj+LyzIMXWTZ
	lTuE9jI2vuxvUotRVbBZaXwjXrB4jYxYEyKmUc+XucgG4uxtYk45sz6ufJAweW/m+DJoLF
	wIJRv6ASV0Bczt6psIZ4euSYGDyVi1s=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="baShfB/l";
	spf=pass (imf30.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.175 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779674598; a=rsa-sha256;
	cv=none;
	b=rj5L5jyp1OImgyXCud3T6YRXQHX/ivqsV9nirxBEfPezsDCV9ZLb1PuZQ0U3H9lXyIycxr
	GRxK67Ex3mpndYB8pB8UImUtDZiidjhfzXC6x0VI5GBxNa9K0cPcsOMSmSUvKyQhxjEZiI
	gPry+Ulp8aad1w2brV+P3t8UwvMdmlI=
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-90caad2e944so943833785a.2
        for <linux-mm@kvack.org>; Sun, 24 May 2026 19:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1779674597; x=1780279397; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=a1dR+qUQ11esis+j6Iq3N8urMnTyCI4LYg4f+Ph15u8=;
        b=baShfB/lUH0QUkg7S6gd2upx7zt/xoTRtzE/mmR/1P2HExnGE0rDv1RoBA5s4rVBQ1
         tgI3//nPmN7rKz/fy58V5T5loMyzZMGEGKVGoGpYRYS5sDvPCJDaQf/ZdeSfp9cHg+VL
         tC0h17bpU8J/VGU8wYKJ2P7JwGNWXt2V8/f9XjHA9ZVF+svfOHJVHh0W3zXCDF1C5Fop
         MW7T3795+HMElhBYrGtcIq9ebrN5dBlxov/j2jhEVyUE2iGb0uA/6qP8P9mNbdPy7pOB
         YfiyiIykWUcZlW7goHbmePk1OHf+smhQKtAJXHlPSRNSng1d9CXJA668Cvb+2ukdI39a
         Fp3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779674597; x=1780279397;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a1dR+qUQ11esis+j6Iq3N8urMnTyCI4LYg4f+Ph15u8=;
        b=m+WDDc4yAM6STjIT0mIK3rOvGnQ9nXQcOL88+OKDZqsBcm/2g0RTeoyiqUhxi1/4DH
         EnbyxCFYd4SHMvrj694x0+nKRoTuNV5/qv9+aCoiHebhYoSd3hAwO4+Ydpky4q1Gacba
         Cb9s4PFEFWMDoyVQ8il+nBx5vzwfhzwWX86gXKWb06VJbLHbK05ZXNjv10BcZvirniI0
         Bj6O2FEJU4gFaTbxxXpdatBZluw4+MJkSqxIPpDUvPqNgKoVYppgw+fsTA6zxjv199uf
         jlbLDukX+vLdQEDW66iwF/E9bg2pVXLeTICB8g2ziN4m/rvGdNquU+DgzESnaQ6fc4h2
         peTg==
X-Forwarded-Encrypted: i=1; AFNElJ+0wqWuB/Y+V1j9NALAcdL/DEwZOU/kDZ5R73aXrUysx+jBbDzg9kD62TmLILVgWk5pACRxd4gU4w==@kvack.org
X-Gm-Message-State: AOJu0YzeH/8uWj5MQbw5bvcybd40OgJcQdlEZC70hid8G5RMG9N2Ev05
	qO761b1sYM6m16D5qHBYrvk+7tYeSMLroKQN+WxkcnEak7SfKBLZ39iyKsmbiAub2T5mrZs8gGO
	JzqD7
X-Gm-Gg: Acq92OH13TfaIpOcjt7WChlVrSDhDVEAKuI9BvuECs/NE4nG4ljQ7Z+G+PF4X1Z3WBR
	FLBgNvLjnIBg94UyGxfXqUPhfpTAS6lCpD7ZndY2KqMksgaqJflFmXawUNjcKY6cn1JhxjNtfVn
	vRdjOfYBnD3SklZeY4B6SkeA/HYs+iYmo6k68ZqU96spwKwqzRwgFC/XMyVAmfKiC4j3nPqyNn8
	Q5hrVluADdHBd0N619yETLWiffQS89L59hxjNX1LxJWtEIENwLCn7cFB6K/H1mdOiwjsjWdmPSq
	w02s7yDaB0FJrvp7+iHjyCowrYET8RhGqAwRMd2WoqO+lcyfrR/KdQ6hUL+3I8DwS1Y0XpEySQo
	iNLUO+A1U9Uy4cFTu7qlQ0F8PNvYIK3LnyU8VNjVmLkPc2dfoH2zyhXhzRB8Jl945AJz4HcAY1a
	8V03GZR8LAkLA5a/m4NJX41Whv6zNq+35lrL6ImW/4IBtPE28XK6bxzecSjGkRoUfkL+N9ZE0tx
	z929m3yCePp
X-Received: by 2002:a05:620a:372a:b0:914:c100:6a0f with SMTP id af79cd13be357-914c10072a4mr1391916385a.23.1779674597141;
        Sun, 24 May 2026 19:03:17 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-100-36-248-188.washdc.fios.verizon.net. [100.36.248.188])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-914bb8c8034sm892777285a.7.2026.05.24.19.03.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2026 19:03:16 -0700 (PDT)
Date: Sun, 24 May 2026 22:03:13 -0400
From: Gregory Price <gourry@gourry.net>
To: Arun George/Arun George <arun.george@samsung.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev, kernel-team@meta.com,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	dave@stgolabs.net, dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	osalvador@suse.de, ziy@nvidia.com, matthew.brost@intel.com,
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
	ying.huang@linux.alibaba.com, apopple@nvidia.com,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	yury.norov@gmail.com, linux@rasmusvillemoes.dk, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, tj@kernel.org, hannes@cmpxchg.org,
	mkoutny@suse.com, jackmanb@google.com, sj@kernel.org,
	baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com,
	gost.dev@samsung.com, arungeorge05@gmail.com, cpgs@samsung.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ahOt4Zw66ukww2On@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <CGME20260427123800epcas5p1e1a2fed257091b31e2e6c3a7d1b0c2b0@epcas5p1.samsung.com>
 <1983025922.01777297382206.JavaMail.epsvc@epcpadp2new>
 <ae_i9IlIndumJWN3@gourry-fedora-PF4VCD3F>
 <1891546521.01777455002601.JavaMail.epsvc@epcpadp1new>
 <afIKxG5mJZE6QgpR@gourry-fedora-PF4VCD3F>
 <1891546521.01777901881625.JavaMail.epsvc@epcpadp2new>
 <afmgJcFUjQLYxkb5@gourry-fedora-PF4VCD3F>
 <1891546521.01779449881859.JavaMail.epsvc@epcpadp2new>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1891546521.01779449881859.JavaMail.epsvc@epcpadp2new>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2FCFE80005
X-Rspam-User: 
X-Stat-Signature: tabhu1wxag1hgtmhgcszqkbirn6co6en
X-HE-Tag: 1779674598-685485
X-HE-Meta: U2FsdGVkX1/1I9++hCL5q04+oxxUejfsnf9xEh+6XEwn7pINkvgIDEzWZGFxZwCpj3fsJUWmmhqUD/A1yS8znJs5+Ww4ENa+3RiqEiv5G0hXH0XyVa087R+bs/WmDBa7RwWQ4D5ZrjDG0Q6pxLikfZP/Rii3duiF61moO4CU8kHhwNVVw7IgspDGEB2c2LxqA6mfhBp7QCj4NZHGUjwVGiQfEw5w909pBdH4BTP0/xUnYn4A3GIE+KxxkzSbcHSLwiEWBRqrkHaBTB545afTceZXith26GUkTARUnjnypRU39GZHSdWA6fquUblSG7ObIk2uBhjSmy2hZB5YMNo6UyusRb5KniPt1zswFa/6qka5PgCEg5LAcqDH5usFde6n+Y2NFHyKt+KrdfCsAEOyzj/gTs7YJPzrADIFtECJQz5834yyox6mNLQsBu7ghGLukzJKjLzWmucVJJUh2NPWYCdDiqlbDGfNZk1ht5cuMN74X8ep5gwn77mbwTVKcQlNfyYOd2JY4kzxtVc3BsXSdSioAJjTAFzGZ0SYjRQuRlGFmL7ALnrvcoihSHEyt/Za5N02voXcJPIFzYdFn/I2ps4ZibC2BWdjY0QCrp60Hj0ky/br0ZT5cMN/bIJYe8UN1pE1ufxunYYwGJDR82KTc0CmUPwWgc7vvKsb3icGcT2fICjR8y5VBF8CKObOzU/FqohOGD7LOYhe1tyWO3EJBdgD2s29AP3PPo2qUWxzUANy3MtzH3keYUdI/tAHMe3V7IqLSt7F82dmBg/+HqMJismZ0dR+gaBQnkGNsKqYQvwJHIrcpimyESkFy0GKy/7IQFTSZBUyxFCBBsLPdbQNKZ2Pc8L0L9tEZDP80AsMLM8BOLnw//fqnoMgJoXqMbxhGs2H58OG8/ThofEY/m4klsTdJhwc32h+TEctHtM8o/4rmpbuLaJwtRbrrsKAXb1WLKbaV1rBhWL6h7tZ8sK
 YPdlXN2I
 IAzMeEUxNQYm/A3r7vxEi/HDZRXXsZ715HhctDDhnZU//iBjUG2VkoXfR927L6cwFBiirKJiF+yKsUy59LQsqgD93fEnK9lQYDtcQ26T1y8SmTOQbbkqoyrSZTh6ZO3iRPnIRGG5eDz8u7RWGzkGIWTu+KgFDd8AsbP4NEE+tGkt4TmHtsMy4HK6T3Y98s7ru0vkScrwlkmwXb3DAt4+8vTnoVJAgpTFZnD7wHxZQBkFDTf2udeqs2R9RBwusdMF+GyTeCKaJ9wcPB9qGTN4ZI0kIwjqPaAIomS3hZ/3Ybytk1D+eEdLoG4+K7m/XmqYEsezUWm0HfFM6lphEf4dhxZnlGcohhdg9ugOmjJ0pvj9yNCf3CihkYBapPyeu/ggHwpqP7ohSSQ4hQzHOAyH0Akh7a4sRmPlAk9atSeRjOw/LI0gAxjw/N0i9/MQSaZkAnVdAzv9079YQXNxjnzUNm3rFBffci4UMA6kfJdWAakTrB84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, May 22, 2026 at 02:10:34PM +0530, Arun George/Arun George wrote:
> Thanks.
> 
> On 05-05-2026 01:15 pm, Gregory Price wrote:
> > In the scenario i'm talking about, a "write budget" is defined as a
> > number of pages that are allows to be mapped writable in the page
> > tables at any given time.
> > Agree. I was also in the same context.
> 
> I am trying to bring the device perspective here, and would like to 
> discuss a few corner cases and possible solutions.
> 
> As I see, solving the compressed memory problem statement has these 
> aspects mainly:
> 
> 1) Allocation control: private/managed memory concept.
> 2) Write control: write-protected PTEs, write-controlled use cases like 
> ZSWAP
> 3) Proactive reclaims: optional methods to ease back-pressure using 
> memory shrinkers, ballooning, kswapd, promotion etc. These methods will 
> be triggered based on notifications/interrupts from the device.
> 
> May be they are not enough to cover some corner cases for cram!
> 
>   I believe that this thin-provisioned memory infra is susceptible to 

I'm not understanding the "thin provisioned" terminology you're using
here.  Can you help define what you mean by thin-provision in this case?

> 'writes-above-media-capacity corner cases' (because of not handling 
> device back-pressure notifications in time) whichever methods we use in 
> the kernel. Even if we use write-controlled methods like ZSWAP and 
> pro-active reclaims, there could be corner cases where the communication 
> with the device could be broken and the write path is not aware of it 
> immediately. Note that OCP spec [1] says the device should mark the 
> memory location as 'poisoned' in 'over-capacity' writes.
> 

The intent is to use the low-watermark to prevent new allocations from
occurring, and the write-controls prevent writing to the device without
interposition.

With a sufficient watermark such that the interrupt is delivered within
some number of microseconds, that should be perfectly fine to prevent
poison from ever occurring at all.

Since poison is only delivered *on read*, the system can go a long,
long time before poison is discovered. From the end-user perspective,
this poison is basically unacceptable.

So either we can prevent poison from always occurring, or the hardware
is not viable to support in a scaled production.  

If you think a sufficiently conservative watermark + write-protection is
insufficient to defend against poison, then please let me know why.

> So I have the following proposals / options for this scenario.
> 
>     Option 1: Poisoned data management - This is about accepting that 
> poisoning of memory locations can happen in much more regular frequency 
> here than regular memories and we need to figure out potential recovery 
> mechanisms in host (not recovery of data; but recovery from the poison 
> situation). But I guess folks will not be okay with it in general, and I 
> am not aware of any workloads where data poisoning is tolerated (may be 
> caching workloads?).
> 

Given option 1, I would never put such a device into my production
environment.  The only reasonable action for handling poison is killing
the software, as the data is functionally corrupted.

>     Option 2 (preferred): Device assisted write budgeting - This is 
> about a device aware / assisted mechanism for the write-controlled 
> use-cases (Ex: ZSWAP) to know the 'safe number of  writes' that can be 
> performed to the device (Or allows to be mapped writable in the page 
> tables). This could be like a 'token bucket' algorithm, where the device 
> provides a 'budget / set of tokens' to the host. And it need to be 
> replenished periodically in the device communication code path; and if 
> the host does not find the token, writes cannot go ahead.
> 

When I say budgeting, I mean literally a budget of writable pages,
entirely controlled by software (mm/cram.c or zswap.c or whatever).

This has nothing to do with device operation / throttling / bandwidth
budgets etc.  It is simply a proposal of an optimization that allows the
user to say:  X out of Y possible pages may be mapped writable.

I don't think this would be part of an initial MVP for a compressed ram
service (regardless of it's cram.c or zswap.c)

> In short, the communication with the device has to be maintained to make 
> pages mapped writable. For MVP, this could be a simple constraint of 
> checking actual device capacity periodically to replenish write-budget 
> for CRAM. For other users of private nodes (GPU memory?), this 
> constraint may not be needed at all.
> 
> We are planning to send an RFC code which will fit into your CRAM infra 
> to discuss this poison management approach further.
> 

I'll try to get a new version out this or next week, apologies for the
lag on this series, I've had a number of disruptions and major movements
on the patch set since I last updated it in February.

~Gregory

