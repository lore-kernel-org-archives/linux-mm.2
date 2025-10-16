Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DF57CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 17:42:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CF0B8E0005; Thu, 16 Oct 2025 13:42:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37F668E0002; Thu, 16 Oct 2025 13:42:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26E9B8E0005; Thu, 16 Oct 2025 13:42:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 134F98E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:42:11 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3F951DFF68
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:42:10 +0000 (UTC)
X-FDA: 84004696020.19.AEAFF22
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf19.hostedemail.com (Postfix) with ESMTP id DF7F01A0019
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 17:42:08 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OVPZPAmL;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760636529;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g2Q7pcup/Lsb81kvRC7mU77d52O8r0BSQzF+Rjf52UY=;
	b=LzUeT0FBl5zs+kf0GxBO4QDCyM2fFX93ilRMqR+WCi44g+wQCBk64UVHJyPYZvAbFTJH4X
	cUJhZo0hn/UMIqYVK3caxagm23lHRmJRG5M0/AmUEWjejUjmq02j7KLTxCYG+1Z2Mb8yKt
	rr3MECk7JMiy3nOYpz50yeOIgWw3fNc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OVPZPAmL;
	spf=pass (imf19.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760636529; a=rsa-sha256;
	cv=none;
	b=FNPHqZDVWxW7TRMyWrEyWcJkP8/QHP2tVrVYUFNYqopbhRtt2x7VvjNeiu7pETZIdpfpoi
	QUPrajETlmJH/1lpwobijvNgmjnLtm4xHGzNxP9kDchpaHk9Um35uFLxmXEIR4C/2CFy6o
	iN8j/2tBbVKOuOLgUfsBrQP0kDftIg0=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-3ecdf2b1751so571517f8f.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 10:42:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760636527; x=1761241327; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=g2Q7pcup/Lsb81kvRC7mU77d52O8r0BSQzF+Rjf52UY=;
        b=OVPZPAmLbFnqWXjksJqdIaW8XrUvhbP0czMqG03c1yusWm995Jl52VywGhLSf/anDF
         MOekkihQ5rp1+oScZS/8J9jQhbvcyW5/HLKpd22ietVn5DDRx8KseWLm+yqFG7trUmv7
         dXhBOl0IrSjOLn7UwupP7ZoC1Yii3roSozDhd3+w5CdOJMsPLgT0tHcDe5YB61UWq8T+
         xKb8Titg7Kl4JlwH7m1MV6UTIIFiKetuZ9MJbwDSnZwEQqM78nxNKCTY+8TeHL1A74Ih
         t8MLj+feaIkkFd+oujdmz4CbI/R4noJa/jg3X2kFxPKDw27/JZk/tU6Zz8nsIWGHfbE+
         jbhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760636527; x=1761241327;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g2Q7pcup/Lsb81kvRC7mU77d52O8r0BSQzF+Rjf52UY=;
        b=bbJf1Os7XFOpHAig0XHmOWARsGETRjjI5fQoWB8hT+U8Jhf72g3prpmKk5R0kYOZGt
         0u5VJRu/eDRSkUpiu/qqc0VWhqCo5Q+UgTMPwUZDF8utLdOyw6ZitW9q2jyymFPFPEep
         vP5PuG9tBRugIz0sz5xjZElwyn6fkJWkGJS0WSBpdm/CciwBbINykqpaVNbvDcyD1g3e
         XDFIi8uxrYokT7795suA1b5KndCtlJvAMT39eTRYu9sAb1pfEuaVx+VHK1z5iIkuVInU
         W3Tr0xJfpTV6jJ8kkp5GidmL1J6jMTpgLXYwTii9JAfX3uHi2MbV1qnnuVqQ4xHqyEia
         x2nA==
X-Forwarded-Encrypted: i=1; AJvYcCVvNgyCfBIo5V3D3CYFh00JkI3PVJfNZe8FJVs4Jrde+EqpZ2dPFJSkl2F2QkSrMBcKq1AnDDSBSQ==@kvack.org
X-Gm-Message-State: AOJu0Yy99qHbHKsJnfGX6RP9eMlmA6GfYow5jk/qrNH2e0wCmEqWLStZ
	AygOixywi0oulIwTYoh+w6mJ2HlIyCN8uCGGdZhTETG1RP/KMAovv+gz
X-Gm-Gg: ASbGnctgyI3MpOw+wZACV77GnAzrG4usDCIKq2Jekl5+1i5b5ZbvoYTAe20GimScdsB
	ncR1qKdkuMvDK4CD6Cv82hRq06cUEyJA3S4hsrkQHc6abCkrgJ8OsJl0HWfxxDp794U16EDtUM5
	l7r2nfCZX/XvTngBJ5rLt56QJQXHNy+k+OK4OSO81TImkwy9XPqjTErGWIdK98Ztid85RjNQeE4
	1QeRrpN6Sqig1BZHXdHrjdATlG46K4zb8bcCTdxNbG7Q/KBMz/AwgJV0tovpHbWNj8Fqvj6lpHh
	DoO5c4Z4NZuc8fVz7Af4s7bToAE6eand080hwW/Y0QqeIl5H/29ZyWAq8TIkFzmnaiE24iFu/lS
	7lu+PeEq1PXjN08JifV4Jo4YFRrE9RrAfNkh+S2b5WAYA2yRmAS+EZgRWq0TN1Em/0qx0+k3QVQ
	Qe8wziFQ==
X-Google-Smtp-Source: AGHT+IFMjQaDJpjCZS2noIhc81rQXZOk7Twbvcm9hhW+VNbrmylgy3Qpo3DO9zp4G74w1uQ0e6XBiQ==
X-Received: by 2002:a05:6000:400a:b0:425:8133:ec6c with SMTP id ffacd0b85a97d-42704d1460fmr594857f8f.9.1760636527217;
        Thu, 16 Oct 2025 10:42:07 -0700 (PDT)
Received: from fedora ([31.94.20.195])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427013f9b58sm4284463f8f.51.2025.10.16.10.42.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 10:42:06 -0700 (PDT)
Date: Thu, 16 Oct 2025 10:42:04 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPEubI4kWvzSC5RN@fedora>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO8behuGn5jVo28K@casper.infradead.org>
 <aO9pUS3zLHsap81f@fedora>
 <aPEZdHJlNOofy5tm@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPEZdHJlNOofy5tm@milan>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DF7F01A0019
X-Stat-Signature: aoegk9ijjq7x5hkmyobdb9iiugiakorj
X-Rspam-User: 
X-HE-Tag: 1760636528-718854
X-HE-Meta: U2FsdGVkX1/SxmoumPF12velDMnVUfs6wmfsEQjjRly4fhjfpRsBVsXF2PNpHrc6zkzFH0ESSFo+LHWRm25fK9giun9bBUZOQ1D5tpM2BV6l3RnEZJbDCqwhhEz72nxA/tFxc3Ftr5RTjQzBnKJP9Sa0vU0e+RIWmXKG/dofK4kn3Nn2ezGCbyhsg8WCAFhxZEhLU0NWYmBVCWw9oJqEqDJZT5lOnp69ZQFMucliJxGp+hpLn80ut7wR0WayET1sZARDyxlBl1M7EC9gYQRE12quiz0zQ2cv1FOyalW+QGI7TwYvWV6Ssna3fUWh2kU1X42Z+pkV12TeBK2uknPRP/RyHgwYJCTz5lIiEWVWHpuZC2jNjmecD+xUUouU4hOfswngEI4adVNh4lI0qC+VnmAqLOOf4MuyFvrmdvNGjoejJk+ayjSEpd9Q2oyFdr6mbiaiIny+ULhfXvT/rcJtmwpGqDwxiv2+37goM1hzibyjsQTK4hzZWUhlmBIU2MpeCaf1aZKmNmr2+VvyuMr6tsaM11rlQUkYFpum4lU1gUNTOlQCbqrTqsKAHmousGGutlCIWnVeY41jwVk0t/5ExPix7zMh6n7pEZVqm07ZRgatgtAyVStuoY9mnC6KpO75q5yGRldMkeuyXqRXODmlwMvLnOV6HhhWxon+h0sbj04lsDEm7Ppu3XaBC5el9JevLijEp2OzrCqfKy59EsAbrWmTCxncGVEbIhYQjYRYAHKPxjDAz9g2AjcS9Q7i6k4n1MkHo7lup7ULY7RcX5vwyx3DMpvz8Do2fgBecrJATdx7QO355KTJ3sXm4EDS+mwPsVQ78paylCRtCW4bPoE/Iu0ekqN8lqj+7veHKYig2WxIFl/f/o5TemRPUpaP8KzjiGQKjAzqbyOf6c2TYL8byZLvGgHmogonEPUQktfXJ+Ld1zVPh/VBEgVf9gDjwYQPUaNMm7aLitP+busMNm3
 AUg1RFIs
 J5rUuAPa98qV9Kn5VdI5NDNJ13axcT9jFrHfkDowT72U2xGo48l26iSObLrJ+nlzrWrezmD3dzXNuDv7qNeUwQVTbcy9XU+W/cQR6g7eHbgx4PGXTCEmU7CcyBax8G5dPXj+eb1+5C/HzpwaPnPLZHinqCKjenoTHG9x1ixZ6QkkVhDtiJ3OK3wajYIyn8VrYuRQEYBsMCIQPnFE3W7yYfHBoxEWKjznyYq1MbJgYHiy0zNpGe9Aa8eAWS1H+NRREM9DfsQyuEAJcZiXbqoelCWRVSy3cQmn9byQM5ZQHyMwks7gF6nRb3Zhp4LAU+lpjNoBQUyA/5nRCPzIGHqJF8inombMnnsjtu104v4JM6oH7blCCQxfDxmCB6iYLNxhl3oLxRRmlN8OJ3P5W4PMTxjOpUyi8Q+nnUrgpgyxm8kSuVB6SN3f0ZkQzaRJVsD+qcK/z2xF/BgYgf9JIe9p9jUeXFg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 06:12:36PM +0200, Uladzislau Rezki wrote:
> On Wed, Oct 15, 2025 at 02:28:49AM -0700, Vishal Moola (Oracle) wrote:
> > On Wed, Oct 15, 2025 at 04:56:42AM +0100, Matthew Wilcox wrote:
> > > On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> > > > Running 1000 iterations of allocations on a small 4GB system finds:
> > > > 
> > > > 1000 2mb allocations:
> > > > 	[Baseline]			[This patch]
> > > > 	real    46.310s			real    34.380s
> > > > 	user    0.001s			user    0.008s
> > > > 	sys     46.058s			sys     34.152s
> > > > 
> > > > 10000 200kb allocations:
> > > > 	[Baseline]			[This patch]
> > > > 	real    56.104s			real    43.946s
> > > > 	user    0.001s			user    0.003s
> > > > 	sys     55.375s			sys     43.259s
> > > > 
> > > > 10000 20kb allocations:
> > > > 	[Baseline]			[This patch]
> > > > 	real    0m8.438s		real    0m9.160s
> > > > 	user    0m0.001s		user    0m0.002s
> > > > 	sys     0m7.936s		sys     0m8.671s
> > > 
> > > I'd be more confident in the 20kB numbers if you'd done 10x more
> > > iterations.
> > 
> > I actually ran my a number of times to mitigate the effects of possibly
> > too small sample sizes, so I do have that number for you too:
> > 
> > [Baseline]			[This patch]
> > real    1m28.119s		real    1m32.630s
> > user    0m0.012s		user    0m0.011s
> > sys     1m23.270s		sys     1m28.529s
> > 
> I have just had a look at performance figures of this patch. The test
> case is 16K allocation by one single thread, 1 000 000 loops, 10 run:
> 
> sudo ./test_vmalloc.sh run_test_mask=1 nr_threads=1 nr_pages=4

The reason I didn't use this test module is the same concern Matthew
brought up earlier about testing the PCP list rather than buddy
allocator. The test module allocates, then frees over and over again,
making it incredibly prone to reuse the pages over and over again.

> BOX: AMD Milan, 256 CPUs, 512GB of memory
> 
> # default 16K alloc
> [   15.823704] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955334 usec
> [   17.751685] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1158739 usec
> [   19.443759] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1016522 usec
> [   21.035701] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 911381 usec
> [   22.727688] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 987286 usec
> [   24.199694] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955112 usec
> [   25.755675] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 926393 usec
> [   27.355670] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 937875 usec
> [   28.979671] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1006985 usec
> [   30.531674] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 941088 usec
> 
> # the patch 16K alloc
> [   44.343380] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2296849 usec
> [   47.171290] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2014678 usec
> [   50.007258] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2094184 usec
> [   52.651141] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1953046 usec
> [   55.455089] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2209423 usec
> [   57.943153] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1941747 usec
> [   60.799043] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2038504 usec
> [   63.299007] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1788588 usec
> [   65.843011] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2137055 usec
> [   68.647031] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2193022 usec
> 
> 2X slower.
> 
> perf-cycles, same test but on 64 CPUs:
> 
> +   97.02%     0.13%  [test_vmalloc]    [k] fix_size_alloc_test
> -   82.11%    82.10%  [kernel]          [k] native_queued_spin_lock_slowpath
>      26.19% ret_from_fork_asm
>         ret_from_fork
>       - kthread
>          - 25.96% test_func
>             - fix_size_alloc_test
>                - 23.49% __vmalloc_node_noprof
>                   - __vmalloc_node_range_noprof
>                      - 54.70% alloc_pages_noprof
>                           alloc_pages_mpol
>                           __alloc_frozen_pages_noprof
>                           get_page_from_freelist
>                           __rmqueue_pcplist
>                      - 5.58% __get_vm_area_node
>                           alloc_vmap_area
>                - 20.54% vfree.part.0
>                   - 20.43% __free_frozen_pages
>                        free_frozen_page_commit
>                        free_pcppages_bulk
>                        _raw_spin_lock_irqsave
>                        native_queued_spin_lock_slowpath
>          - 0.77% worker_thread
>             - process_one_work
>                - 0.76% vmstat_update
>                     refresh_cpu_vm_stats
>                     decay_pcp_high
>                     free_pcppages_bulk
>                     _raw_spin_lock_irqsave
>                     native_queued_spin_lock_slowpath
> +   76.57%     0.16%  [kernel]          [k] _raw_spin_lock_irqsave
> +   71.62%     0.00%  [kernel]          [k] __vmalloc_node_noprof
> +   71.61%     0.58%  [kernel]          [k] __vmalloc_node_range_noprof
> +   62.35%     0.06%  [kernel]          [k] alloc_pages_mpol
> +   62.27%     0.17%  [kernel]          [k] __alloc_frozen_pages_noprof
> +   62.20%     0.02%  [kernel]          [k] alloc_pages_noprof
> +   62.10%     0.05%  [kernel]          [k] get_page_from_freelist
> +   55.63%     0.19%  [kernel]          [k] __rmqueue_pcplist
> +   32.11%     0.00%  [kernel]          [k] ret_from_fork_asm
> +   32.11%     0.00%  [kernel]          [k] ret_from_fork
> +   32.11%     0.00%  [kernel]          [k] kthread
> 
> I would say the bottle-neck is a page-allocator. It seems high-order
> allocations are not good for it.
> 
> --
> Uladzislau Rezki

