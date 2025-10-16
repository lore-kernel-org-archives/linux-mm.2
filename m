Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53406CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:03:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 634A78E0011; Thu, 16 Oct 2025 15:03:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60CA48E0002; Thu, 16 Oct 2025 15:03:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521BA8E0011; Thu, 16 Oct 2025 15:03:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3FFC78E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:03:11 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BB88C03FA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:03:11 +0000 (UTC)
X-FDA: 84004900182.05.C742FE1
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 08203A0005
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:03:08 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HKn7JGqI;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760641389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bElOFzybJYApx11r2UithqZnt7BeVh4JMgw683hHLlM=;
	b=CPQvNnT4lWYBqI5Gh0XXV9dhQQIFX1fAy7PcBm2G9R7GTjlFDatKKLc8NRv3iexvNiIW/f
	gqBO1+/rv10MXRSsVgR5dhFIq65DeYYe5dgs07hPO0fVs2C7pfB6CvNpHV/L9qavPSUgN6
	bWWO98lv97ahAFqPYMuAS0mFII12H0E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760641389; a=rsa-sha256;
	cv=none;
	b=6kBiCvJAnhXh9VFZtopvEimnOnwAjXji9wXNcgHxvfPS/ST79pHOhCkV20f0UhT+8iaodY
	U7HzhU8mxgJYrYr9fEaWcFsSqUVA9VyxXmR/roLMj3KBeRxo7VyR/VqHISz6fi4YvmxmiB
	PY4SEdY1LSPrshEUbMNAcGYQU7dnkrI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HKn7JGqI;
	spf=pass (imf25.hostedemail.com: domain of vishal.moola@gmail.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=vishal.moola@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47112edf9f7so5971535e9.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760641387; x=1761246187; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bElOFzybJYApx11r2UithqZnt7BeVh4JMgw683hHLlM=;
        b=HKn7JGqIYGjSDI6xfZ5nVXI7LKvJHg6H9yyAmGHRkE2Dr06mQEdaYsrtlEBH+LyLaW
         TI7GsdIZmLAw6uqiYzbyUtWB180Qm2D232iiYogC1ZXXvSE1/DEaxn3y23ckdFBeS5e/
         QDyn8SybUDD4VNK/gzA35INTc2ijezzDCePZWL2lEGZKnBUGWqm/8eSMImUk9+bPQ4HH
         PErKz1dCU1wysrS6sg8W/QfEwlJCFUvrBobjM24V8silrz63YfgfFEl3LUkAK/6V0zBX
         hzk9rmIL1LJO5rSUeeAk+bGVy0Yu4vdGaJOlwTIuV68jzklRQOh1d2AW3gR9YgHJKsCx
         5WmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760641387; x=1761246187;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bElOFzybJYApx11r2UithqZnt7BeVh4JMgw683hHLlM=;
        b=iQiIxZhra0h1y1eeD59PzsUevxVdq1CwseThtteMD2BFyF52kFXgKoD3qzVKO7OAxY
         chUIPakSaBn+WY9ATm4wv0BGK3nhKoQZ35h7ciGt96y+WVmlSngKaUawvtjbdJ8lSRmQ
         evigcnciSJmpFjutP4MI/zxxD66YzC6nEV804ar14K8uy6L+JyhcW14kZIuQVNDsaSah
         7yGLD/+dJ4CuvTWtj9oAoJiuBE5deWuaHXEV/Q7CG32pd6REC5zYE8heSepn2yc7bjES
         TGE63A9/cpvZOE0jBvFNzAHrB4heP5JcYBKB1UHqdqkvfSyWA2FO7pabqOlTK/Bbsbgs
         Le8w==
X-Forwarded-Encrypted: i=1; AJvYcCXQG5bADmnqHKlZkmrm745qtIfV9yvefH1vtxAxK+feSYyT00KcFNpn2kExarPs7zRFJ9ZG2EA7fg==@kvack.org
X-Gm-Message-State: AOJu0YxSbOm1q3GjT5IAbTyWY8QnSBr8ZZR+a2E6VILR9VoGV574Dgl7
	9XgoXrnevoluND/q/c2M2N3jYeSbUHJhatwY9zNsK22chqalPwSOuIpl
X-Gm-Gg: ASbGncvSS6/gApdFSBjxkwSWU6ra6vrRskaMt3LZH6QHRZnm7hJQycPS2PeWwbWM6ER
	DyPdfDIaQsPvRcXHVgbl11x+GUgcNzvMjuPN/Q7Jwc/3oKwe5mDTklSIxZTM/+/O1LFXLHLGcvz
	UBr5GpHAqerJCEed4F1DDEm+51VfsmpxuGvxG5x1lqUDuQ1W+DR+3h89TpZpQIrxeBQLDND5E4x
	WqyKHeafeJlQlvP+Fd2dJEmwgdsf9WjOAzLWmXhO7WIy2PJ+Yx/8zob+VgVPDvqk5A48zf1wotK
	8mjLRXGMBKPVxGRtK4gUR1W/TPhTuP5pLzSaCX0PndMsP3dv1vIhK12zKti9eN3MiL1pCI5pULa
	1deaAyRnqTZoLx/eYwHRmdHPqjkJB/9Uat7oodOhAlmlbbRvR+zDfbtSbOOjhjAEdgY35wY3KIp
	H/hRBZPSNKrqyt7ZGm
X-Google-Smtp-Source: AGHT+IHpqR+b9nmFiD5VjfH6g0TM8Sg/3RCXImNqlBAhdaTBB5kxjSgRISQMrKRjkf7dkKnh9/bQZA==
X-Received: by 2002:a05:600c:3553:b0:46e:1cc6:25f7 with SMTP id 5b1f17b1804b1-4711789daf3mr7304675e9.9.1760641387210;
        Thu, 16 Oct 2025 12:03:07 -0700 (PDT)
Received: from fedora ([31.94.20.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711435b06fsm52679605e9.0.2025.10.16.12.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Oct 2025 12:03:06 -0700 (PDT)
Date: Thu, 16 Oct 2025 12:02:59 -0700
From: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPFBY_OtG0YTAaHv@fedora>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO8behuGn5jVo28K@casper.infradead.org>
 <aO9pUS3zLHsap81f@fedora>
 <aPEZdHJlNOofy5tm@milan>
 <aPEubI4kWvzSC5RN@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aPEubI4kWvzSC5RN@fedora>
X-Rspamd-Server: rspam05
X-Stat-Signature: sqyuoh7xpm4b4s7f31tx5z4fnr6q3gpt
X-Rspam-User: 
X-Rspamd-Queue-Id: 08203A0005
X-HE-Tag: 1760641388-375572
X-HE-Meta: U2FsdGVkX19glFtuXJf5z/n4/CJlU/vLDbybfAiQN/NxbSyQj//A63/DPBrvTXI7Vt4c+sDZyM2yi3fw/+gBhLbqUASYwagAtpaoUJURGxcmzeSfxEPnVs0EQfsLI5JX8zTgjOGmF4o5+1YM0s1+Ss5DL7siBGvLLzYBPpVY4IFCh34ERZmWI/tAr0XGwFoDVWMhVhNzlZRXsM5T31j8agKlQLY0T3snCgSAhi+wnt2KmNhgUwKE+1MvYPqgKESsfKsvhfGKyhEm9CQnYcs52McShgzyu2CapIRGp/B6L0r/otbZ0HZn4JEx2XJM2iTxWRyYi7nUb1weZezt2JRtCYN6sYlOsoqEdb4/aPO+eNA+fvaeuKzMBppBNpiOcTCIMR0ETm8+bE7twi681Dx51qkpyINphd4WuEbc0hn08mLUWrLHZEZ0d+vpQCDXcWe3NblOnTOL9ybt6mLkSR3o+0CH+KSDqOparW/3rB3QDYAgHYdN2NnNWSx6jEasa/VfJnK3iojo11hLCHBWiB4DpcvMVMta33srOmu3y/m00WkaqoqADAp7F0xAfQM6XV57HqlCdqphRyh5kK05q+1v+7ghLYP4DXGrzk1IAHasdzXHN1y7WJ9xsze5/bBfxIV9zdhv8HRM+heSKFpHcd5Yd+TGNoYhbruZtKuMLgIEsIbN2Ii6GcfpbyX5qD5r5LsyDfR3YkbJ/Mxv3qt26mq6LjvhyoHi2dbzuzVukehUuf4LZ595Kd4bqd2mP6VOynbVi1pmZQW+tFSPVO7ZCFyUDOKz8Gi6AEg2/fliOUcynDcxybLD6MK6js61bw3cgVV7umacUyX+04GTBJDLcpaR8WA1NJCEAruyLEouuxz3/3ZFEgVevWIqfvOniq+NJ6jobyYaiCOYuUnuLx6GeXjYbHQnO+8WaHHT3EIUJbEp4OcotxMYMfHuan+9FHoGVPbI/P9FrB0hhaF81bI626v
 XiFFWI0d
 PoLm7f3QRSg0TOD0ZQYwMUn5HULOzpkWK7b3+QRuPOcmi5b0C8EDUZW9v2Zku0ouK1b5q5Yb7KanWcZWv3WoR+ixOOfclJVK50QNYmXKmlC+gLOx9F6Cp8soRb0lm3+k0Va+LeJLKQuSdP0JLuwLIueUgRRkvu+5VRZAb8ZKLxStHZ3UfhlXjTxM39bQ75diPT7eSnGEskvis1bbwaFTUMjcwwKm7eV45SD3YnRdEJFUBBSP0NeuQswpKbm5J1jm0it5vi/siaBHDbS6stDhlKHu8UI6HzTQBtMxNeLFYSNBQPDGvWMGBRnfCyTfUz+JlND5B8USp346qNY9NnIpWLZEHT5/xRIxpZ9S0j5qlhaG5Awr8faFAVBX7kKk2KjdjT71Hv0fCZmsLtCSXT4RCV03Zo1hqdUM9jx8Pq8XyXlTsPwvi2Y9VYruA6mqCQsGA9J9Tlkr+hgm2THwMdD31MnRpCw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 16, 2025 at 10:42:04AM -0700, Vishal Moola (Oracle) wrote:
> On Thu, Oct 16, 2025 at 06:12:36PM +0200, Uladzislau Rezki wrote:
> > On Wed, Oct 15, 2025 at 02:28:49AM -0700, Vishal Moola (Oracle) wrote:
> > > On Wed, Oct 15, 2025 at 04:56:42AM +0100, Matthew Wilcox wrote:
> > > > On Tue, Oct 14, 2025 at 11:27:54AM -0700, Vishal Moola (Oracle) wrote:
> > > > > Running 1000 iterations of allocations on a small 4GB system finds:
> > > > > 
> > > > > 1000 2mb allocations:
> > > > > 	[Baseline]			[This patch]
> > > > > 	real    46.310s			real    34.380s
> > > > > 	user    0.001s			user    0.008s
> > > > > 	sys     46.058s			sys     34.152s
> > > > > 
> > > > > 10000 200kb allocations:
> > > > > 	[Baseline]			[This patch]
> > > > > 	real    56.104s			real    43.946s
> > > > > 	user    0.001s			user    0.003s
> > > > > 	sys     55.375s			sys     43.259s
> > > > > 
> > > > > 10000 20kb allocations:
> > > > > 	[Baseline]			[This patch]
> > > > > 	real    0m8.438s		real    0m9.160s
> > > > > 	user    0m0.001s		user    0m0.002s
> > > > > 	sys     0m7.936s		sys     0m8.671s
> > > > 
> > > > I'd be more confident in the 20kB numbers if you'd done 10x more
> > > > iterations.
> > > 
> > > I actually ran my a number of times to mitigate the effects of possibly
> > > too small sample sizes, so I do have that number for you too:
> > > 
> > > [Baseline]			[This patch]
> > > real    1m28.119s		real    1m32.630s
> > > user    0m0.012s		user    0m0.011s
> > > sys     1m23.270s		sys     1m28.529s
> > > 
> > I have just had a look at performance figures of this patch. The test
> > case is 16K allocation by one single thread, 1 000 000 loops, 10 run:
> > 
> > sudo ./test_vmalloc.sh run_test_mask=1 nr_threads=1 nr_pages=4
> 
> The reason I didn't use this test module is the same concern Matthew
> brought up earlier about testing the PCP list rather than buddy
> allocator. The test module allocates, then frees over and over again,
> making it incredibly prone to reuse the pages over and over again.
> 
> > BOX: AMD Milan, 256 CPUs, 512GB of memory
> > 
> > # default 16K alloc
> > [   15.823704] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955334 usec
> > [   17.751685] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1158739 usec
> > [   19.443759] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1016522 usec
> > [   21.035701] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 911381 usec
> > [   22.727688] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 987286 usec
> > [   24.199694] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 955112 usec
> > [   25.755675] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 926393 usec
> > [   27.355670] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 937875 usec
> > [   28.979671] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1006985 usec
> > [   30.531674] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 941088 usec
> > 
> > # the patch 16K alloc
> > [   44.343380] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2296849 usec
> > [   47.171290] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2014678 usec
> > [   50.007258] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2094184 usec
> > [   52.651141] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1953046 usec
> > [   55.455089] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2209423 usec
> > [   57.943153] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1941747 usec
> > [   60.799043] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2038504 usec
> > [   63.299007] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 1788588 usec
> > [   65.843011] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2137055 usec
> > [   68.647031] Summary: fix_size_alloc_test passed: 1 failed: 0 xfailed: 0 repeat: 1 loops: 1000000 avg: 2193022 usec
> > 
> > 2X slower.
> > 
> > perf-cycles, same test but on 64 CPUs:
> > 
> > +   97.02%     0.13%  [test_vmalloc]    [k] fix_size_alloc_test
> > -   82.11%    82.10%  [kernel]          [k] native_queued_spin_lock_slowpath
> >      26.19% ret_from_fork_asm
> >         ret_from_fork
> >       - kthread
> >          - 25.96% test_func
> >             - fix_size_alloc_test
> >                - 23.49% __vmalloc_node_noprof
> >                   - __vmalloc_node_range_noprof
> >                      - 54.70% alloc_pages_noprof
> >                           alloc_pages_mpol
> >                           __alloc_frozen_pages_noprof
> >                           get_page_from_freelist
> >                           __rmqueue_pcplist
> >                      - 5.58% __get_vm_area_node
> >                           alloc_vmap_area
> >                - 20.54% vfree.part.0
> >                   - 20.43% __free_frozen_pages
> >                        free_frozen_page_commit
> >                        free_pcppages_bulk
> >                        _raw_spin_lock_irqsave
> >                        native_queued_spin_lock_slowpath
> >          - 0.77% worker_thread
> >             - process_one_work
> >                - 0.76% vmstat_update
> >                     refresh_cpu_vm_stats
> >                     decay_pcp_high
> >                     free_pcppages_bulk
> >                     _raw_spin_lock_irqsave
> >                     native_queued_spin_lock_slowpath
> > +   76.57%     0.16%  [kernel]          [k] _raw_spin_lock_irqsave
> > +   71.62%     0.00%  [kernel]          [k] __vmalloc_node_noprof
> > +   71.61%     0.58%  [kernel]          [k] __vmalloc_node_range_noprof
> > +   62.35%     0.06%  [kernel]          [k] alloc_pages_mpol
> > +   62.27%     0.17%  [kernel]          [k] __alloc_frozen_pages_noprof
> > +   62.20%     0.02%  [kernel]          [k] alloc_pages_noprof
> > +   62.10%     0.05%  [kernel]          [k] get_page_from_freelist
> > +   55.63%     0.19%  [kernel]          [k] __rmqueue_pcplist
> > +   32.11%     0.00%  [kernel]          [k] ret_from_fork_asm
> > +   32.11%     0.00%  [kernel]          [k] ret_from_fork
> > +   32.11%     0.00%  [kernel]          [k] kthread
> > 
> > I would say the bottle-neck is a page-allocator. It seems high-order
> > allocations are not good for it.

Ah also just took a closer look at this. I realize that you also did 16k
allocations (which is at most order-2), so it may not be a good
representation of high-order allocations either.

Plus that falls into the regression range I found that I detailed in
response to Matthew elsewhere (I've copy pasted it here for reference)

  I ended up finding that allocating sizes <=20k had noticeable
  regressions, while [20k, 90k] was approximately the same, and >= 90k had
  improvements (getting more and more noticeable as size grows in
  magnitude).

> > --
> > Uladzislau Rezki

