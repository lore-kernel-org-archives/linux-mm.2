Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 949B7CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 18:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B22528E0008; Mon, 20 Oct 2025 14:23:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1A78E0002; Mon, 20 Oct 2025 14:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C1508E0008; Mon, 20 Oct 2025 14:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 88D928E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:23:36 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 405361A0283
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:23:36 +0000 (UTC)
X-FDA: 84019315632.27.09A6AFE
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf02.hostedemail.com (Postfix) with ESMTP id 263CD80007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 18:23:33 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L4gEq2u/";
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760984614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XM3lb+nkcJ7701WZ1nCVSRPcoybWb6DxOoNrWe3kEL8=;
	b=qFJZgEYp0yEIoYQhcH9kzCbPnDeQsvxi4RAEwXYQtBUZt4ufJRMgUgh0h5ieAU8LNEEugD
	8wquv129TTsw9WmZ74SxNkdZb2jqlxPgCiNdxRczKnI67nPV/UD467weHPSYtjQ/QtyOVE
	d7D3TtThzjyEx5RrJ1j5sEFmc7sJOes=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L4gEq2u/";
	spf=pass (imf02.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760984614; a=rsa-sha256;
	cv=none;
	b=Xho0N9TuhNUIpe4qoEXD6WZxexPz/WUkdMr2SOjQVHRuNcGL/p5lkDA91ybPcuwGNh5NHK
	79kre20g0ppCU4+pb7RmGm1WkC+Pslguc6SXMc0znCm4bUhsXN1IOt61sBqG0vqixMh99Y
	x4bCiRV3rGkefbUoZm8nI8BN8x/uuIs=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-471b80b994bso27353625e9.3
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760984612; x=1761589412; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=XM3lb+nkcJ7701WZ1nCVSRPcoybWb6DxOoNrWe3kEL8=;
        b=L4gEq2u/q1KUBVg6X6iSVaw0+N+zbRnQ1ARvuJSL+9GB5owsTHBfqmvHT4cMZ9wWx8
         QcWjIx1Z/D42pDALzYI8ftNX767XJ9jl4B0SDVH+LLUNe+r8h/eCu/E1ypxJsZu4haAg
         YDmIygq0Im8BMId1Xpu2y7eN868GV3/5xVluCgF4mQ+FlYorfa/ksrAz3EHOkMXh3L2U
         mGHYqtk3yDOIIALrZD2O6P+2zLZEYFohiX9hrdKbs+hj0J2yDM/YggdFqBU374lxjjup
         4g0R7R+NduSsoPQcmniLzibvrRVKB6bb/xAetV3OZhMGVwhljXUqnS1HTqQKhaCzkyif
         jxEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760984612; x=1761589412;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XM3lb+nkcJ7701WZ1nCVSRPcoybWb6DxOoNrWe3kEL8=;
        b=W8ZcechSdsNuKpL2MRUJrhrHTzwB+jqKH+LXRK993rM4R+ZZsjMcBGhMeu7wnndtJz
         YBTuiU5B8FrxVgcrO+IbT5m5J+iT6FWMtYJ7y/KLv9KNSvrIcsX/AcyHu7yey8wJBXek
         cCDCU+elu7LUhCAyc7Ks1HZL+9LIaSyo95IDo7lEoNzjFq86gi8yRnA9OH+miwr/aGOU
         +G0OBS4iX4QPYrcIX0OOfeZFqG3tVMiuEhyfgRbF2Iy/j1hw6/t4GiIE/rCCjeF2AFhP
         +M97mW3YuhDisccLDrWV10Gn7ZpyFxPlaZlEF14iEbTWp/YPvGUJQ+ogY1uzj76qcMVd
         NIrQ==
X-Forwarded-Encrypted: i=1; AJvYcCXU04G91G+RTvj09jKnT8dGz68d9oBHLxP2oFMQ2barop6hwEkqOP2KC2U4pOLBEyrEsK1doap0FA==@kvack.org
X-Gm-Message-State: AOJu0Yyj4lXQBL76weRUCqqSJ+K89wCnhteG6K1jD1aNhvgbiexZmque
	/ygxkDgZGf3u7xvEXN540axFrjRCOv++Gzefwe1oICBZGfzDFXpKQLBw
X-Gm-Gg: ASbGncuWl8RRM+oQw12qu5jFk4q/x7yQ8QZvoOz8jyWxJLhU2O9d/GBWCPC6Wc9ehCp
	E32iax3MeJs439rmO91Qax/Tbt8TE7p70K56WLi9hsfDtMKGEqgsfCvnXxJ/71bljGDhb4j5/R7
	qVJFGBGsKd7IWCOyRZ0rAFzTJH4fVq/cAYaxM84ctZE+JOcbQ6l4qHRy/TDwGmb1PSaZckqmbuq
	eLJ8UZRgQjUbrpXZAlAA5/HIt/2zl4rec19DnbcNM8pthm1wchCdBkWM5NEiE3YNLDNxWprTuNL
	cIip1qh6Dhi/25849eS6QDNxL53MhAB18n6gNLZCssFXPjFDGKH7f5KJWxWHg16q2rd/zf9tISZ
	O3MRgbbF6rlVRcV3hdxnYA0nH5ucsPNObKmIjYzJbVdVAzCjYW3TAQ3wzgfdbTg9KDULJPgKx
X-Google-Smtp-Source: AGHT+IGHUYoXmddIw92+qME6tnuYAuOMrQdL8QRukN+6lCRGWfNdPq95JXiT0QQ5qbS6qIZ64FWm1g==
X-Received: by 2002:a05:600c:4ec9:b0:46e:2562:e7b8 with SMTP id 5b1f17b1804b1-471179123admr101994905e9.21.1760984612069;
        Mon, 20 Oct 2025 11:23:32 -0700 (PDT)
Received: from fedora ([31.205.15.105])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00b9853sm16487755f8f.33.2025.10.20.11.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 11:23:31 -0700 (PDT)
Date: Mon, 20 Oct 2025 11:23:29 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPZ-IbX7K8f4Jngp@fedora>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO8behuGn5jVo28K@casper.infradead.org>
 <aO9pUS3zLHsap81f@fedora>
 <aPEZdHJlNOofy5tm@milan>
 <aPEubI4kWvzSC5RN@fedora>
 <aPFBY_OtG0YTAaHv@fedora>
 <aPJrmdeQY1QvbVdc@milan>
 <aPJ6lLf24TfW_1n7@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPJ6lLf24TfW_1n7@milan>
X-Stat-Signature: t1um3d4mdtdcj4rb9bhmddtrj81xozez
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 263CD80007
X-HE-Tag: 1760984613-890095
X-HE-Meta: U2FsdGVkX1/RdJVYqFV0RxmeYnlFwtv0UeMnr7i9IOG366wsekdgt+BAxPean+EzxzbKPWgVtFj5kse4EcDeWBZZli1fVnd8QRJ5TOaN2RP3PA3gAnlFs/flNVFElh6RK0SRe0aCcQ4+u/X5bqscGtwpvttH5LOa2MgP4dcs5EZTfmhSUtFLIYiVwNKfX3PeWwIJvj2e7atXo7svRoFdVkKmJVz9fHD8A+bPiQZGXq4rpDieiltzhxurzUSeLGYpmRLDuR3tl8/8+40oRQSPDzPs/7UA/Lyhmtl+zFWL7cvyMAy5MurYL4tfKHnvTje+qOMLONJkGA786B8xLKNiwFVQ6fnTIZ8l+WZSVK6xgbLOLFov14E5665UXImHe/AjyZfezfKx6TANxyVW60Dps/3x/dKjuEjgrQu+Z143TPwpz+f35x2I/rWdJ36OC4Mgnx4VWFLXfaBIXpBLnYKHTAuYKXumq6IZWlo8/GsjBtdFC//Dr+Rd4s0fIeB70HGYm2MQl1fVzxIuGpRlGcyKliF7fojITdFF5W4soE+il2Nj32TQ52BjvRNuLM8mjMYacTKh2gDUmf4/4sOlwSBUvmMHJj2IrFu6TRDU2o0CDjrn5mGRTTY5tzbA/F+OZ2Wc6gAiOGzk7XyB9j16Prfkn4CgwPjS1ToibbwEbt+Sa7Q8BmPWhLVxdIw8GVTXMwMKEKbSm/gmS4AtIX1cX1DyT+J4VfVAivguMehHTQY5qb4bFHomRSt+aoMpozi0uG8ch1cDeLXOZyUJOtcSujT4hrunw7evGDAqxpCmq4740K6zqf5QC7ESfoXtGEDYxlj5XkdbdYVlTd4cEhfX5EpCkJIUuwWM3mDdm+bCM0P+9MSTUZGyk3oUhz2+uFsq6YIyxRIug6BRDzl0OJRs5MITwwLx8N3BHuAgpw+K7+9/yhrCbGhB0ktsgR6yFtqyyPPWhre2WrLcpdVF2R3AwNa
 HjsljTuF
 7++q6vzIoF4LTV/0ehd8tdpSNDhIwDcMrNZ6afoIooKr2EfMIFava9Mwurj7V7v9DV4c0To/RYkCJa0tSmC0YVFy/8ZUgLmc3Md18sYgKlLQanEddNOFgWvHIJohQDx1k/Mpv/QU2kTXgY+XAebLI6LyZgiolPxWWrvgksCbqYcprjS0fTxLBLlXF6HgSsilhfyUK/TPJPGXVZWGXn4+rP0mh6emhq/fFcPbnxTZyUKu7Jz/TNRsllFVfVWc6xnFmPp5ULROyeTByayh6pdOuQ4n3OoGQCjPDSIqUwqBTS+2KpQUa+E9cncSaLHfJr2RORn7tCTgEeJEPC5WCHsub7XZ6OJQtaEIVdNDMawYvRsULER//ehqHRAT2guUOpA7uIL8lnEevIjKcTproaBxsS1cdwuJ5KSiHctUkWVfm+gRlBOzjrwzWX4JKDDi4Soj+XOeLhfeampwytRloM1cAJO5NoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 17, 2025 at 07:19:16PM +0200, Uladzislau Rezki wrote:
> On Fri, Oct 17, 2025 at 06:15:21PM +0200, Uladzislau Rezki wrote:
> > On Thu, Oct 16, 2025 at 12:02:59PM -0700, Vishal Moola (Oracle) wrote:
> > > On Thu, Oct 16, 2025 at 10:42:04AM -0700, Vishal Moola (Oracle) wrote:
> > > > On Thu, Oct 16, 2025 at 06:12:36PM +0200, Uladzislau Rezki wrote:
> > > > > On Wed, Oct 15, 2025 at 02:28:49AM -0700, Vishal Moola (Oracle) wrote:
> > > > > > On Wed, Oct 15, 2025 at 04:56:42AM +0100, Matthew Wilcox wrote:
> > > > > > > On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> > > > > > > > Running 1000 iterations of allocations on a small 4GB system finds:
> > > > > > > > 
> > > > > > > > 1000 2mb allocations:
> > > > > > > > 	[Baseline]			[This patch]
> > > > > > > > 	real    46.310s			real    34.380s
> > > > > > > > 	user    0.001s			user    0.008s
> > > > > > > > 	sys     46.058s			sys     34.152s
> > > > > > > > 
> > > > > > > > 10000 200kb allocations:
> > > > > > > > 	[Baseline]			[This patch]
> > > > > > > > 	real    56.104s			real    43.946s
> > > > > > > > 	user    0.001s			user    0.003s
> > > > > > > > 	sys     55.375s			sys     43.259s
> > > > > > > > 
> > > > > > > > 10000 20kb allocations:
> > > > > > > > 	[Baseline]			[This patch]
> > > > > > > > 	real    0m8.438s		real    0m9.160s
> > > > > > > > 	user    0m0.001s		user    0m0.002s
> > > > > > > > 	sys     0m7.936s		sys     0m8.671s
> > > > > > > 
> > > > > > > I'd be more confident in the 20kB numbers if you'd done 10x more
> > > > > > > iterations.
> > > > > > 
> > > > > > I actually ran my a number of times to mitigate the effects of possibly
> > > > > > too small sample sizes, so I do have that number for you too:
> > > > > > 
> > > > > > [Baseline]			[This patch]
> > > > > > real    1m28.119s		real    1m32.630s
> > > > > > user    0m0.012s		user    0m0.011s
> > > > > > sys     1m23.270s		sys     1m28.529s
> > > > > > 
> > > > > I have just had a look at performance figures of this patch. The test
> > > > > case is 16K allocation by one single thread, 1 000 000 loops, 10 run:
> > > > > 
> > > > > sudo ./test_vmalloc.sh run_test_mask=1 nr_threads=1 nr_pages=4
> > > > 
> > > > The reason I didn't use this test module is the same concern Matthew
> > > > brought up earlier about testing the PCP list rather than buddy
> > > > allocator. The test module allocates, then frees over and over again,
> > > > making it incredibly prone to reuse the pages over and over again.
> > > > 
> > > > > BOX: AMD Milan, 256 CPUs, 512GB of memory
> > > > > 
> > > > > # default 16K alloc
> > > > > [   15.823704] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955334 usec
> > > > > [   17.751685] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1158739 usec
> > > > > [   19.443759] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1016522 usec
> > > > > [   21.035701] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 911381 usec
> > > > > [   22.727688] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 987286 usec
> > > > > [   24.199694] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955112 usec
> > > > > [   25.755675] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 926393 usec
> > > > > [   27.355670] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 937875 usec
> > > > > [   28.979671] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1006985 usec
> > > > > [   30.531674] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 941088 usec
> > > > > 
> > > > > # the patch 16K alloc
> > > > > [   44.343380] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2296849 usec
> > > > > [   47.171290] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2014678 usec
> > > > > [   50.007258] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2094184 usec
> > > > > [   52.651141] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1953046 usec
> > > > > [   55.455089] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2209423 usec
> > > > > [   57.943153] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1941747 usec
> > > > > [   60.799043] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2038504 usec
> > > > > [   63.299007] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1788588 usec
> > > > > [   65.843011] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2137055 usec
> > > > > [   68.647031] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2193022 usec
> > > > > 
> > > > > 2X slower.
> > > > > 
> > > > > perf-cycles, same test but on 64 CPUs:
> > > > > 
> > > > > +   97.02%     0.13%  [test_vmalloc]    [k] fix_size_alloc_test
> > > > > -   82.11%    82.10%  [kernel]          [k] native_queued_spin_lock_slowpath
> > > > >      26.19% ret_from_fork_asm
> > > > >         ret_from_fork
> > > > >       - kthread
> > > > >          - 25.96% test_func
> > > > >             - fix_size_alloc_test
> > > > >                - 23.49% __vmalloc_node_noprof
> > > > >                   - __vmalloc_node_range_noprof
> > > > >                      - 54.70% alloc_pages_noprof
> > > > >                           alloc_pages_mpol
> > > > >                           __alloc_frozen_pages_noprof
> > > > >                           get_page_from_freelist
> > > > >                           __rmqueue_pcplist
> > > > >                      - 5.58% __get_vm_area_node
> > > > >                           alloc_vmap_area
> > > > >                - 20.54% vfree.part.0
> > > > >                   - 20.43% __free_frozen_pages
> > > > >                        free_frozen_page_commit
> > > > >                        free_pcppages_bulk
> > > > >                        _raw_spin_lock_irqsave
> > > > >                        native_queued_spin_lock_slowpath
> > > > >          - 0.77% worker_thread
> > > > >             - process_one_work
> > > > >                - 0.76% vmstat_update
> > > > >                     refresh_cpu_vm_stats
> > > > >                     decay_pcp_high
> > > > >                     free_pcppages_bulk
> > > > >                     _raw_spin_lock_irqsave
> > > > >                     native_queued_spin_lock_slowpath
> > > > > +   76.57%     0.16%  [kernel]          [k] _raw_spin_lock_irqsave
> > > > > +   71.62%     0.00%  [kernel]          [k] __vmalloc_node_noprof
> > > > > +   71.61%     0.58%  [kernel]          [k] __vmalloc_node_range_noprof
> > > > > +   62.35%     0.06%  [kernel]          [k] alloc_pages_mpol
> > > > > +   62.27%     0.17%  [kernel]          [k] __alloc_frozen_pages_noprof
> > > > > +   62.20%     0.02%  [kernel]          [k] alloc_pages_noprof
> > > > > +   62.10%     0.05%  [kernel]          [k] get_page_from_freelist
> > > > > +   55.63%     0.19%  [kernel]          [k] __rmqueue_pcplist
> > > > > +   32.11%     0.00%  [kernel]          [k] ret_from_fork_asm
> > > > > +   32.11%     0.00%  [kernel]          [k] ret_from_fork
> > > > > +   32.11%     0.00%  [kernel]          [k] kthread
> > > > > 
> > > > > I would say the bottle-neck is a page-allocator. It seems high-order
> > > > > allocations are not good for it.
> > > 
> > > Ah also just took a closer look at this. I realize that you also did 16k
> > > allocations (which is at most order-2), so it may not be a good
> > > representation of high-order allocations either.
> > > 
> > I agree. But then we should not optimize "small" orders and focus on
> > highest ones. Because of double degrade. I assume stress-ng fork test
> > would alos notice this.
> > 
> > > Plus that falls into the regression range I found that I detailed in
> > > response to Matthew elsewhere (I've copy pasted it here for reference)
> > > 
> > >   I ended up finding that allocating sizes <=20k had noticeable
> > >   regressions, while [20k, 90k] was approximately the same, and >= 90k had
> > >   improvements (getting more and more noticeable as size grows in
> > >   magnitude).
> > > 
> > Yes, i did 2-order allocations 
> > 
> > # default
> > +   35.87%     4.24%  [kernel]            [k] alloc_pages_bulk_noprof
> > +   31.94%     0.88%  [kernel]            [k] vfree.part.0
> > -   27.38%    27.36%  [kernel]            [k] clear_page_rep
> >      27.36% ret_from_fork_asm
> >         ret_from_fork
> >         kthread
> >         test_func
> >         fix_size_alloc_test
> >         __vmalloc_node_noprof
> >         __vmalloc_node_range_noprof
> >         alloc_pages_bulk_noprof
> >         clear_page_rep
> > 
> > # patch
> > +   53.32%     1.12%  [kernel]        [k] get_page_from_freelist
> > +   49.41%     0.71%  [kernel]        [k] prep_new_page
> > -   48.70%    48.64%  [kernel]        [k] clear_page_rep
> >      48.64% ret_from_fork_asm
> >         ret_from_fork
> >         kthread
> >         test_func
> >         fix_size_alloc_test
> >         __vmalloc_node_noprof
> >         __vmalloc_node_range_noprof
> >         alloc_pages_noprof
> >         alloc_pages_mpol
> >         __alloc_frozen_pages_noprof
> >         get_page_from_freelist
> >         prep_new_page
> >         clear_page_rep
> > 
> > i noticed it is because of clear_page_rep() which with patch consumes
> > double in cycles. 
> > 
> > Both versions should mostly go over pcp-cache, as far as i remember
> > order-2 is allowed to be cached.
> > 
> > I wounder why the patch gives x2 of cycles to clear_page_rep()...
> > 
> And here we go with some results "without" pcp exxecise:
> 
> static int fix_size_alloc_test(void)
> {
> 	void **ptr;
> 	int i;
> 
> 	if (set_cpus_allowed_ptr(current, cpumask_of(1)) < 0)
> 		pr_err("Failed to set affinity to %d CPU\n", 1);
> 
> 	ptr = vmalloc(sizeof(void *) * test_loop_count);
> 	if (!ptr)
> 		return -1;
> 
> 	for (i = 0; i < test_loop_count; i++)
> 		ptr[i] = vmalloc((nr_pages > 0 ? nr_pages:1) * PAGE_SIZE);
> 
> 	for (i = 0; i < test_loop_count; i++) {
> 		if (ptr[i])
> 			vfree(ptr[i]);
> 	}
> 
> 	return 0;
> }
> 
> time sudo ./test_vmalloc.sh run_test_mask=1 nr_threads=1 nr_pages=nr-pages-in-order
> 
> # default order-1
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1423862 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1453518 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1451734 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1455142 usec
> 
> # patch order-1
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1431082 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1454855 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1476372 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1433379 usec
> 
> # default order-2
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2198130 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2208504 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2219533 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2214151 usec
> 
> # patch order-2
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2110344 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2044186 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2083308 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2073572 usec
> 
> # default order-3
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3718592 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740495 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3737213 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3740765 usec
> 
> # patch order-3
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3350391 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3374568 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3286374 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 3261335 usec
> 
> # default order-6(64 pages)
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 23847773 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 24015706 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 24226268 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 24078102 usec
> 
> # patch order-6
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 20128225 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 19968964 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 20067469 usec
> Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 19928870 usec
> 
> Now i see that results align with my initial thoughts when i first time
> saw your patch.
 
Its reassuring that your test results show similar performance even at
the order-1 and order-2 cases. This was what I was expecting as well.

I'm assuming this happened because you tested exactly aligned PAGE_SIZE
allocations (whereas somehow I hadn't thought to do that).

> The question which is not clear for me still, why pcp case is doing better
> even for cached orders.
>
> Do you have any thoughts?

I'm not sure either. I'm not familiar with the optimization differences
between the standard and bulk allocators :(

When looking at the code, it appears that although the pcp lists can cache
up to PAGE_ALLOC_COSTLY_ORDER (3), the bulk allocator doesn't have support
for anything outside of order-0. And whenever order-0 pages are
available, the bulk allocator appears incredibly efficient at grabbing
them.

