Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B092CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 16:12:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83BF8E0020; Thu, 16 Oct 2025 12:12:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D34288E0002; Thu, 16 Oct 2025 12:12:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C71A18E0020; Thu, 16 Oct 2025 12:12:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B70EC8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:12:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A5E31A03A2
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:12:44 +0000 (UTC)
X-FDA: 84004470648.27.EC857C6
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id E1E991C0014
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:12:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhUDgmqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760631162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQ8TgGiMRhix2au9XQ+hoMB2htnBV/w4RzgVlEvya/w=;
	b=4+fzu72aDIh2G3yaP2CGolp7ZlbU+CaQhuBaaLG3+U+l0+jJdXQOIXUIY7G4FJwRzan1ol
	8O8I3yJxVaMEuOtGln7vfCdZAE0T2ecQNEGDeTq9HjS2eEdnyzbCY4+wt2iR0M5IdLOMRy
	hqqvmqzFfp7oC9zTkenShEFZuE9r3j4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PhUDgmqB;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760631162; a=rsa-sha256;
	cv=none;
	b=dcVUPP40rEnFISLoFs/pM5zzSt4AXC8c3EzSHTWmYNdVx8eIqt/NKCl3DTHwT5BA9SFZ+E
	mzftiZOmMmoWWSh9GEa4ffQ5SZJuZ9g2e9ypIYXD8MoC2ZMIZvkQ3c8F8pp3DJm2wJpqG1
	b1aHVmsrOXXVOBiVw67jL+Wf2DvU/N0=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-363cb0cd8a1so10896681fa.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:12:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760631160; x=1761235960; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=BQ8TgGiMRhix2au9XQ+hoMB2htnBV/w4RzgVlEvya/w=;
        b=PhUDgmqBWZ35R0hLxK+wWhGQh/lowxSVYTmrEu2s7StltIEqwjLg8PrH/kKVUAeMUj
         emShqslpvQJlhQSYU+grLp00YHcguOGRwK8F8bBFhVzJIiIfK0HXbihvLnUQnGRuPPLo
         LKUf5X6nEJLdD3NP4I4soqfhagx3cmiUAZxJWZQeIU7ls4B7g0DVlswGevwBPPU6pG6R
         Pv9s6CoQXrlECAyOsocsjaocRkpSGZEq2Bae56iZv1ADSUvP/KmBHl1DE19e7h22qAWz
         2C+aOqwd2kd04VEzNOTPkbdsMy93n60BHC3si9+35OhaWCizctrhB5ldRvDc35LQrHZa
         4cfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760631160; x=1761235960;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BQ8TgGiMRhix2au9XQ+hoMB2htnBV/w4RzgVlEvya/w=;
        b=AuKq2uKB5uhiDbZTb8C8aZ17ewOTXv+QPm/glWpPImNs0gFzSra0HjkA+bMgRyLmSc
         HBspkRUndGAOr1YojA2SR1DerhIpJm4IpBue+CJJ7D7VGU2BRfPHmcpqzQCWI43HwlRu
         6OsBcROFiB3dutsWKfXgEX9QvEjDhu7nt6Wil36VsNaHKbgrPjfpwGRgxWmXfIQ+McZW
         mii2BpDUaonWiwaB7NIPPpPZ4GQ25zj3ZSC4WxGTqhVuIxAPCKREKg3lDN7iQr6tWdmU
         Hx+tiECBbXUKR6xJK6MdeChajtk11yndLaRoByX3R8+XIFZPYUHGJCeZf/IJcMIywsOP
         /bYg==
X-Forwarded-Encrypted: i=1; AJvYcCWEhh+y9uRiXj0lPfNWl3n5Gztl14tg6ivKgODZ5ozPwmjESZeBlkkuhjuWSOr1i9oA7/nz7yc+Bw==@kvack.org
X-Gm-Message-State: AOJu0YzHiZ/36hMefTHdyss70BSdH8cBoEhDtFkvK/UmXIvcQULhynKY
	KhBWoVPMWsjU9faHqnFKTv14jqFs6scyB+QGLIjWdkp6e4utIWzsYrhG
X-Gm-Gg: ASbGnctAehupmOWmUV0DxG6PsWVRrR1ITbrDA2kWXThqN9D+tGXNCbaEQOg12+Opyu3
	MgfSTlC7VhoYiM/2jeIi94TYM64OzDkDYx6yeuFAXTLXi49Ok2CaSaVQVbznI92R63kTqfmMPE/
	3yKzIjpgvHDFMYswjcI+SABDoVNBzyo1YBkl+OWuPKDqEBV6nbaViJa8csDCjL87Jd3rNsodTiS
	vvUaNSbcSrU7ic/aBHiUoLR2MW797fttUxXDZy0Oy1mnzm/BEofREqF1iqN3lJWzgXFB8PtmYmb
	jPPI7M6jfkEEhOMgSB+rgjEXZo/QHwB95w1arIXbX2sKkwrw/JDY7ZdwL6pSv6YUhQGMxtGAUfh
	8Ex9aUNY7P5Cp9Hv+kN6gXrpOfqGZh8DJytHitO4qQ9k=
X-Google-Smtp-Source: AGHT+IEwND9M7VO7/WvljXI2LkdyYkBWXrMc78AOnO5Yy2f188cHytXGCJUcSMPofMbbHxEIERaiHQ==
X-Received: by 2002:a2e:9a14:0:b0:372:8d1d:6952 with SMTP id 38308e7fff4ca-37797986b26mr2895401fa.41.1760631158889;
        Thu, 16 Oct 2025 09:12:38 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3762ea14d1esm55681011fa.31.2025.10.16.09.12.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 09:12:38 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Thu, 16 Oct 2025 18:12:36 +0200
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPEZdHJlNOofy5tm@milan>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO8behuGn5jVo28K@casper.infradead.org>
 <aO9pUS3zLHsap81f@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO9pUS3zLHsap81f@fedora>
X-Rspam-User: 
X-Rspamd-Queue-Id: E1E991C0014
X-Rspamd-Server: rspam03
X-Stat-Signature: aft4yc8gw75ofqtjbk4kbebidc9md18k
X-HE-Tag: 1760631161-27923
X-HE-Meta: U2FsdGVkX18oY+k20FdFQWOFzfFj+oq9r4AekUVcNZt0tzz0b3MXH3sEogXZSiEFJW3nhjrZzi4i+r6pBXXKvL00ABCXSbgXhNHxSYHBG9d5CHcG/hLvUe4omDaFDa/5BHuVlJ6pkfvzp4IwsM+KchpRJAms769OHqKwfA2Ta96H+2PpxY3R69BbJsRmgaunxrX5j3CD3Gbak5Kq/VFfQN/TySlKcFab5Oc5uaMLW1tpEVnmDP7vO0s1m1bgz08auX0pLlZYGOA/EjpwSDzhbonpRewpcTK6hvFNHLuiPFLMEbxpObKbIwHage9qybSt9GpNKTS150pWMdO7c0aoTn5yOGNrN6KxeG1389Ua5ZDTow5oZQW2YOWNAkWhu5oNBGn77raIJhRhvnjqZ9ZcXftbFbCn/j9pOqPik/q+2vTa3Mctv9XCIu10VnI8KxDw4gu7w8oP80o/tCKBYuKQZ4DCPc3db6C3K+HAB/4tcqWZ/gTj2mmCL5aff6V90tk9LTJYsV98K0bLFZ1J8EuFM+UOuBh6JklvAOPjf3NYSkBX+XYlOOljIrCh2QC5AYYlnnVeZ7mbc6SV5cOe0AWJ3UqkB+/Gy9100ckj0A/tcYEDNhx1BBVUScdlPo18K5X7VvX3S9QhuNpZvHjXWZ2jkNTiMQ2zbSFKaWf06wGmWhioIgtBRJNxLbUklJuUb95DQVODMmWWl2HxUmsvIkJU+ePvwO99ECCTPfjveZwuGbJcP1/jCrI18TrhBLHq/1hETN9DiR6fvGtFmBvgvOEiCUzbpOraifJQgIzbhKND4uoNRls5QVeUYR2nrFiqQB8CDXwLeFDvNlVVvaWEyJG7Om7IBpuWfxmQP2NiWYMjrQRztt7/eswHSZXGEG72JENhgVd0OYUyFlvmZxIlioMvxaki5KVnKUFfNh1xVvRQASV5rG/72PV8CysdqEfJgdtDu0rDPV+i+YbODcGe09U
 JKrlkCLL
 1rRNTPA7WCZvO41TIWyeuWBiArmLa3FLgaSP8mizidnl/LBZ5Un4kIlZE5XW1G8wJn65L8o2WC9zDduuXqWyCSveIu33f5+K4QNiPZZivHJU86/1CAATrdFD9kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 02:28:49AM -0700, Vishal Moola (Oracle) wrote:
> On Wed, Oct 15, 2025 at 04:56:42AM +0100, Matthew Wilcox wrote:
> > On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> > > Running 1000 iterations of allocations on a small 4GB system finds:
> > > 
> > > 1000 2mb allocations:
> > > 	[Baseline]			[This patch]
> > > 	real    46.310s			real    34.380s
> > > 	user    0.001s			user    0.008s
> > > 	sys     46.058s			sys     34.152s
> > > 
> > > 10000 200kb allocations:
> > > 	[Baseline]			[This patch]
> > > 	real    56.104s			real    43.946s
> > > 	user    0.001s			user    0.003s
> > > 	sys     55.375s			sys     43.259s
> > > 
> > > 10000 20kb allocations:
> > > 	[Baseline]			[This patch]
> > > 	real    0m8.438s		real    0m9.160s
> > > 	user    0m0.001s		user    0m0.002s
> > > 	sys     0m7.936s		sys     0m8.671s
> > 
> > I'd be more confident in the 20kB numbers if you'd done 10x more
> > iterations.
> 
> I actually ran my a number of times to mitigate the effects of possibly
> too small sample sizes, so I do have that number for you too:
> 
> [Baseline]			[This patch]
> real    1m28.119s		real    1m32.630s
> user    0m0.012s		user    0m0.011s
> sys     1m23.270s		sys     1m28.529s
> 
I have just had a look at performance figures of this patch. The test
case is 16K allocation by one single thread, 1 000 000 loops, 10 run:

sudo ./test_vmalloc.sh run_test_mask=1 nr_threads=1 nr_pages=4

BOX: AMD Milan, 256 CPUs, 512GB of memory

# default 16K alloc
[   15.823704] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955334 usec
[   17.751685] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1158739 usec
[   19.443759] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1016522 usec
[   21.035701] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 911381 usec
[   22.727688] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 987286 usec
[   24.199694] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955112 usec
[   25.755675] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 926393 usec
[   27.355670] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 937875 usec
[   28.979671] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1006985 usec
[   30.531674] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 941088 usec

# the patch 16K alloc
[   44.343380] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2296849 usec
[   47.171290] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2014678 usec
[   50.007258] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2094184 usec
[   52.651141] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1953046 usec
[   55.455089] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2209423 usec
[   57.943153] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1941747 usec
[   60.799043] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2038504 usec
[   63.299007] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1788588 usec
[   65.843011] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2137055 usec
[   68.647031] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2193022 usec

2X slower.

perf-cycles, same test but on 64 CPUs:

+   97.02%     0.13%  [test_vmalloc]    [k] fix_size_alloc_test
-   82.11%    82.10%  [kernel]          [k] native_queued_spin_lock_slowpath
     26.19% ret_from_fork_asm
        ret_from_fork
      - kthread
         - 25.96% test_func
            - fix_size_alloc_test
               - 23.49% __vmalloc_node_noprof
                  - __vmalloc_node_range_noprof
                     - 54.70% alloc_pages_noprof
                          alloc_pages_mpol
                          __alloc_frozen_pages_noprof
                          get_page_from_freelist
                          __rmqueue_pcplist
                     - 5.58% __get_vm_area_node
                          alloc_vmap_area
               - 20.54% vfree.part.0
                  - 20.43% __free_frozen_pages
                       free_frozen_page_commit
                       free_pcppages_bulk
                       _raw_spin_lock_irqsave
                       native_queued_spin_lock_slowpath
         - 0.77% worker_thread
            - process_one_work
               - 0.76% vmstat_update
                    refresh_cpu_vm_stats
                    decay_pcp_high
                    free_pcppages_bulk
                    _raw_spin_lock_irqsave
                    native_queued_spin_lock_slowpath
+   76.57%     0.16%  [kernel]          [k] _raw_spin_lock_irqsave
+   71.62%     0.00%  [kernel]          [k] __vmalloc_node_noprof
+   71.61%     0.58%  [kernel]          [k] __vmalloc_node_range_noprof
+   62.35%     0.06%  [kernel]          [k] alloc_pages_mpol
+   62.27%     0.17%  [kernel]          [k] __alloc_frozen_pages_noprof
+   62.20%     0.02%  [kernel]          [k] alloc_pages_noprof
+   62.10%     0.05%  [kernel]          [k] get_page_from_freelist
+   55.63%     0.19%  [kernel]          [k] __rmqueue_pcplist
+   32.11%     0.00%  [kernel]          [k] ret_from_fork_asm
+   32.11%     0.00%  [kernel]          [k] ret_from_fork
+   32.11%     0.00%  [kernel]          [k] kthread

I would say the bottle-neck is a page-allocator. It seems high-order
allocations are not good for it.

--
Uladzislau Rezki

