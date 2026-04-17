Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2368BF8E4B4
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 07:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0666A6B00A2; Fri, 17 Apr 2026 03:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D006B00A3; Fri, 17 Apr 2026 03:11:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94FB6B00A4; Fri, 17 Apr 2026 03:11:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D52A26B00A2
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 03:11:26 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 892181A0B94
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:11:26 +0000 (UTC)
X-FDA: 84667176972.20.D0655FD
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9CA8680012
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 07:11:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XOC9dWb4;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776409884; a=rsa-sha256;
	cv=none;
	b=5wm/okhUGJOm+LYl8k42dWdUM0vZopsj/SkLQonP36ym/pkenpE+J8ZO5zZ6lSliyzUEZJ
	FNXYLZoA2J9kt2KQV/IL3Rh8gpw+Enm25ox34aQq1RBpxGn8GlZIUtgaKLKjaz3n3r76v5
	04vange4D2JwjgkT1Js8wexqA1bgyHE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=XOC9dWb4;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776409884;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7gA/l5GHxYLyTbDgZvMzjj19RXSMRwmPtxVoiFdDZg=;
	b=wj0K7rjN5bL8BVXHe3CvdoniCgTlY51+h9dItxrh/w9yInirc2dCdSsuNVFTqRBzKBv6vL
	auxc8OHKR2DguOqlrv2rxnD0Vm+MH6QHJCRPAcH9pSj5RCFNgkraPvUsTwPtLLqwz7osyM
	TPhxFHi4ay3x1/QC5fiGnv1VEXK9YTM=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43d7645adbdso186192f8f.1
        for <linux-mm@kvack.org>; Fri, 17 Apr 2026 00:11:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1776409883; x=1777014683; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=k7gA/l5GHxYLyTbDgZvMzjj19RXSMRwmPtxVoiFdDZg=;
        b=XOC9dWb4vBWjcSSHZsRvEK/XjvX/VaMC3rtAR58+1hkDik+l108dGxjVrCHxF8bHmo
         kLbJSPtdeZVmHl22ooVepXJ8ACE0LJabWLCJSfamhRoWFjhzMFn7cmD6R2Ry6wJC/Ufr
         +OybWo0SxF694ptIdpzFwg5Yr8RYOrUA6NWvZPzKgJsSSr3+LYF6KIhW57OT46QL7Img
         Dqb+ro5g8+nOiERo3f4cKK7u6aDPiPDJNu5hqIXTqpHkO3uUrHgnaKZa7F/x3FDqvNNP
         yKXi1KWoLSb1ZQ3XTCB34uzsf9KiEnsMdJYRktpe3/TMsXaUdJ6siUKvsstkiWIl9C0m
         91cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776409883; x=1777014683;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k7gA/l5GHxYLyTbDgZvMzjj19RXSMRwmPtxVoiFdDZg=;
        b=WOw35BVGPoalOPbd8QJ5QB8X3jWZxTp7KAIHNsKj5EKGIWnZWdoemK1OBz2aBrgO7t
         p/st/a9JwdfKJ2ybybTGkd51OgZW5R57XOZZSwVnPeTcdWcMXN/uJIlxSrBW8L73iyZ5
         vc/7R7Om28VGQgPm9cB2gmU4Fm+AkhaXLt0TNq+23Wx/CcMukaAu7tz6vf69algnYc4b
         Z0DqvfUG8vHlZ3PsqQd8sqyZlHJ1zrL6xS/vGwG2jbJ0hBw/HB3R0o/r8tGgM78OvS/a
         +mDzGOE7e19X78h02Rs1CPELwKkPqBwWvAVFBR32YPlGvPS6boR9JumxS5Vvlz0r43WW
         p4ug==
X-Forwarded-Encrypted: i=1; AFNElJ/H8gndbPDengUpYu3P7AC5tCc1WxjEVgQscJDEZsBF/Lf7jt7Gk86K+CxJz7CcXgKxpCdWjA2kIw==@kvack.org
X-Gm-Message-State: AOJu0YziQd6YRK4NaG2DMU61tbx/tid/LWx+5QceWXnulhKGAhzUIg+V
	Df6HPPc3e/zHSsA6rpYgpldcamstki0z4L7itEnd6keZF6VTqssi3N7lz7hVwDuAAIc=
X-Gm-Gg: AeBDiesdr4+RS5GCb4WUm3vCAsEwXqiOKi7riP5ikOlehVZmhIl1LCN7HMUAgBIFoaj
	yCwuYzP7Cr4WzAEUICNdfchMRfNgmIbrlaFHaclWeCw5Hz+uKNVVL1C0ALaI6XEPmq0cFe18dBm
	l7GlAs0ATfRChN1kThbOxPIBF4GtO1RJCIU8l8RPDguag1lY1wd5lx2LKiVtXevc0zqQT6TcsY6
	AP2wJS4gwsbiWpYqoOu7nIUcR0/BbikEt0r+WLUyiJOTG0QbqyV5mjBUIGvi5LUEpo9C4MQRhyB
	hWIeDcva+1Jr/bie351e2peFV2zpUwtSuv7ElM2ghNiUmUIO1qOEOEdkZCi9ed9HWUerJ+zAWp2
	HGoOZ4+3qvTRqh4sA1v+buUNenuIBDwpyM7NJUVGsFKgZzXApsmaoJ8AmbklQtH/oD0ZXHpfav1
	BzV9lyUR1ImVfONtsbQY2icqOOCfTOjwWuBHYYjjPH7hGXeBjSAvj2cgBuEw==
X-Received: by 2002:a05:6000:184b:b0:43d:70de:1c71 with SMTP id ffacd0b85a97d-43fe3db2e7bmr2143672f8f.11.1776409882963;
        Fri, 17 Apr 2026 00:11:22 -0700 (PDT)
Received: from localhost (109-81-20-115.rct.o2.cz. [109.81.20.115])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43fe4e3a166sm2354840f8f.19.2026.04.17.00.11.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Apr 2026 00:11:22 -0700 (PDT)
Date: Fri, 17 Apr 2026 09:11:21 +0200
From: Michal Hocko <mhocko@suse.com>
To: Minchan Kim <minchan@kernel.org>
Cc: akpm@linux-foundation.org, david@kernel.org, brauner@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, surenb@google.com,
	timmurray@google.com
Subject: Re: [RFC 0/3]  mm: process_mrelease: expedited reclaim and auto-kill
 support
Message-ID: <aeHdGf7XDjvOES1V@tiehlicka>
References: <20260413223948.556351-1-minchan@kernel.org>
 <ad3ldU4DZxga_J2L@tiehlicka>
 <ad6c0DN7AGoOQ_Iq@google.com>
 <ad9AXVYxWCkHmh6J@tiehlicka>
 <aeAeqoJ_acUAza8D@google.com>
 <aeCHvYOKP1exBBns@tiehlicka>
 <aeHRLv834FCAQlQ8@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeHRLv834FCAQlQ8@google.com>
X-Rspamd-Server: rspam10
X-Stat-Signature: rtrednnduqc5j6yeeut3ph8hsnm91rxz
X-Rspam-User: 
X-Rspamd-Queue-Id: 9CA8680012
X-HE-Tag: 1776409884-349002
X-HE-Meta: U2FsdGVkX18WviyBHsgMG6TR/qhNH3FN9iUmWUawvprZo9bTHKZ1YnGaQ+ax8Dxa9NU4ruiGHedRgJIGq8IlIfnS3ul5UqCp5n/yVZmW4OaYKqQAY45IyXiKoaP6t7IniwkSDozz1y3IPdy3Z4s5GOHVH/W7WK2oGYxWd0pFJ6pzwiOHqvUXlPmjs3msSjd37vMAMd3KEYB2wHb3C9kY71cbZuXsTQgUmc0/FNHXbt2nHoyktHU3ADWXyYnI8Yop6LzwfjbqNShrGo5AzFFTMdByJihdZNiFQwqrQKxjDl+XhZXMx0bhb3t+uiy3D9iYPdqlbBkaRAX7cOYhcte7ksoGg4rIBByNhQrGkWDwLghTosUs4D11sEUQSg5nJL1grpMInBQmkgwzEbGxwYZnqNrAfP4bvcKb69m74ksnX1A+/9TdtEFNdlLUgaRwQmc5lVySu7YFNLG5JC7jWd1S3DJRqDaV8BSut+o2DDEvk3ahQuOLIalDLrD7Wmom4ochEer9Q/VApVRRiu+m8YjYB4wM7XG0uw+0hp4C1/H+gxCDbASI9hOOMkpPwtfS82a41ZEVsclXcm9nAOKA0EzKgFX0xTTyJEBDkqmJSDiI397LdA3yCoZ/IGiYphkWtmbaEX93RKjEYyFsndzUD708AMgq3ZF1zlsgurv1eYgfvdjOEdohjeE2iH44SFUMmsKDv4cvaZ3qa8+fSQa/YPL7wspxwl5CoyFMOE5RLwiTVwA03m9Yr8SgGL11lofm8CNfwzzttk3b4Rjm/PEVTpMGX4xXave9zgkE+ESGHcvE3evAuwZ4LSZjZqZLZ/9bVOeR5e8i1wjlve4pHcbhx8upYeEftPBOYy/O2DeE5hkiRXxb28ABQt9fd/Vs9LheP9GRiCiMoE3LiZOoPDSIko03UeYjEmKLxu2SGwnLER+zHpS8wkQg9WrvcdQDvNK1Bf7Xh1FHkEC02ZdM1R4ryT6
 SN/t2JuJ
 iLrEcgB+ZRG84oTdK6FiFjvZGlwW1My5jx90qn9QvEyrMmR/iM5/Y3/YCU8TYayDTmR6bxIv9svlKgBTG7shTc1XkM729s8QTKv2CS1FqHd7tZ2MDOjXY6vyhtNnJ2fo2BQdflOxT2NatmqDe7FCzI7ts8yGzi2o3AgZxBLXpo5wLaQC2Vk63yp8UuZT2C+uq2T6X6JCuugMf8BsBn5xFOTh6RlhkcN6GeD3NwQP5ptc/V2n2p4amCFN/Lsqifu9CsIJoHI+u10C5USv0OHxgi+gJhBSIkSmRyk9qyQYxcO6DokACt/rONYy32WyleXX3PmOt7Mr4uykK4PmTVfb04HtMwwkSaCJADJoexBqkfY7kdiVmShiPi1qrou1ecKlHZEBzyArJbKp5W0NiVfDxMcu44A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu 16-04-26 23:20:30, Minchan Kim wrote:
> On Thu, Apr 16, 2026 at 08:54:53AM +0200, Michal Hocko wrote:
> > On Wed 15-04-26 16:26:34, Minchan Kim wrote:
> > > On Wed, Apr 15, 2026 at 09:38:05AM +0200, Michal Hocko wrote:
> > > > On Tue 14-04-26 13:00:16, Minchan Kim wrote:
> > > > > On Tue, Apr 14, 2026 at 08:57:57AM +0200, Michal Hocko wrote:
> > > > > > On Mon 13-04-26 15:39:45, Minchan Kim wrote:
> > > > > > > This patch series introduces optimizations to expedite memory reclamation
> > > > > > > in process_mrelease() and provides a secure, race-free "auto-kill"
> > > > > > > mechanism for efficient container shutdown and OOM handling.
> > > > > > > 
> > > > > > > Currently, process_mrelease() unmaps pages but leaves clean file folios
> > > > > > > on the LRU list, relying on standard memory reclaim to eventually free
> > > > > > > them. Furthermore, requiring userspace to send a SIGKILL prior to
> > > > > > > invoking process_mrelease() introduces scheduling race conditions where
> > > > > > > the victim task may enter the exit path prematurely, bypassing expedited
> > > > > > > reclamation hooks.
> > > > > > > 
> > > > > > > This series addresses these limitations in three logical steps.
> > > > > > > 
> > > > > > > Patch #1: mm: process_mrelease: expedite clean file folio reclaim via mmu_gather
> > > > > > > Integrates clean file folio eviction directly into the low-level TLB
> > > > > > > batching (mmu_gather) infrastructure. Symmetrically truncates clean file
> > > > > > > folios alongside anonymous pages during the unmap loop.
> > > > > > 
> > > > > > Why do we need to care about clean page cache? Is this a form of
> > > > > > drop_caches?
> > > > > 
> > > > > The goal is to ensure the memory is actually freed by the time
> > > > > process_mrelease returns. Currently, process_mrelease unmaps pages, but
> > > > > page caches remain on the LRU, leaving them to be reclaimed later
> > > > > by kswapd or direct reclaim.
> > > > 
> > > > Correct. This was the initial design decision because there is not much
> > > > you can assume about page cache pages which are very often shared. Even
> > > > if they are not mapped by all users.
> > > 
> > > Fair point. However, that's the trade-off:
> > > 
> > > Leaving unmapped caches to be reclaimed asynchronously keeps system memory
> > > pressure high for too long. In Android, this delay forces the LMKD to
> > > unnecessarily kill additional innocent background apps before the memory
> > > from the original victim is recovered.
> > 
> > OK, this is really not clear to me. How come you end up triggering LMKD
> > (or any OOM handling) when there is a considerable amount of clean page
> > cache?
> 
> It's not simple to explain all the heuristics, but basically, LMKD is triggered
> by PSI pressure (usually contributed by kswapd rather than other components
> like refault, kcompactd, or workingset operations).
> 
> It then checks the current free memory against system watermarks. Depending
> on the free memory size, file cache, and free swap, it decides to start
> killing background apps.
> 
> In other words, LMKD acts as a "userspace kswapd" to assist kernel kswapd's
> reclamation speed. It is smarter than kswapd because it has high-level knowledge
> of which processes are okay to be killed rather than forcing slow, unnecessary
> paing out.
> 
> Whenever LMKD is running, kswapd is usually running alongside it. You might
> wonder why LMKD kills background apps even when there are plenty of clean file
> pages. That's because the system cannot predict current memory allocation rates.
> If the allocation is bursty, kswapd can never catch up with the allocation speed.
> This forces the foreground apps into direct reclaim, resulting in visible
> UI jank. Android prioritizes UI smoothness and chooses to kill background apps.
>
> Furthermore, when LMKD kills a background app, it expects immediate memory relief.
> If the clean file pages of the killed process are left on the LRU to be reclaimed
> asynchronously later, the system's memory pressure (PSI) remains high.
> This forces LMKD to unnecessarily kill *additional* background apps before
> the memory from the first victim is fully recovered.
> 
> Again, this is why I want process_mrelease expedite clean file reclamation
> synchronously.

How much of a clean page cache do you usually drop this way?
 
[...]
> > I suspect you are missing my point. I am arguing that those special
> > hacks in the address space release path shouldn't be process_mrelease
> 
> I am a bit confused now. Do you mean you want to apply these expedited
> reclamation optimizations to ALL dying processes in the common exit path,
> rather than making them specific to process_mrelease?

Yes. All which make sense, really. I am still not convinced about the
clean page cache because that just seems like a hack to workaround wrong
userspace oom heuristics.
-- 
Michal Hocko
SUSE Labs

