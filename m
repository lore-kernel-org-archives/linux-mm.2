Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 805E4CEB2E4
	for <linux-mm@archiver.kernel.org>; Sat, 15 Nov 2025 16:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E429F8E0009; Sat, 15 Nov 2025 11:56:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF29F8E0005; Sat, 15 Nov 2025 11:56:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBA3B8E0009; Sat, 15 Nov 2025 11:56:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B3B5F8E0005
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 11:56:49 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2228D12EDC2
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 16:56:49 +0000 (UTC)
X-FDA: 84113445738.10.BA2D36E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 89B97120004
	for <linux-mm@kvack.org>; Sat, 15 Nov 2025 16:56:47 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0fBrSOT;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763225807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iw3vI9BSb/qr+hkziL0vT/cLUCBcRsq6vY5Xd0Wk3Og=;
	b=79xujvWQNRvOFd5icpE/LmMVJQYJZsj67jBGFsqA4XlBqIcwRNwENgJRx2qnGDtti9KGOt
	gWS47RmaZElgDB6IwL4bjSLMtgDmaJEWT6FAJbKmpa0C+bhHucCZFRrXBx8e115qfvYGKk
	r8HI3DNQ8yPrc4gHf/Sxp7mYtgFJrA0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=H0fBrSOT;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763225807; a=rsa-sha256;
	cv=none;
	b=mIzC/FgK+X+XU/0untBVBVBI9uKiInQLQZTt/OXUD8V46gxiFaPLdu/fEdgWwqtJkOBO1+
	jxfxF2stDDr8bTDh0Avnbt+l5LetGO+livra3ZtXKezPYITRiFE0DD39qyAwYpVEG7kKGO
	8t9Vmg81QfPlo26zXcj91qQbP+e8d4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD36660008;
	Sat, 15 Nov 2025 16:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96E7C4CEF5;
	Sat, 15 Nov 2025 16:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763225806;
	bh=/gOkGsj7raAQD06iajDMIoQCwWI8rwh1FUuNxXNRiDc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H0fBrSOTYwuz2F3C7hEG+BNNJ4ANuNHg5MF4ShyVzawn6gUZ2cv+mqh67Kmp4OfqC
	 bEMV1qF0avBOwaTJWdmPQ63m4NnPD+GQABzOF8GZN4GfZ9Wx7LVgNlWwvn6vSiXYf4
	 9ZuWxsvvwd3y5ICUVwyIWwNLpf5XzFSqOMy1ihbWGKajOU8O1GhBlMMaUx4UI/7m1Z
	 xGk/emq5jpa8fmE9d9mZHp5OzgnkVE5MyKqkNwl3Uh+IU73uI0AIEzNlyyrEeAM0cn
	 Lc+9MePZszKDSsvlerpFA4E1e4fYpvJnJpoKif0m8edPq6ei27KhYck9PkDzgvzXeY
	 S2faeXhLNG90w==
From: SeongJae Park <sj@kernel.org>
To: YoungJun Park <youngjun.park@lge.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com
Subject: Re: [RFC] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
Date: Sat, 15 Nov 2025 08:56:35 -0800
Message-ID: <20251115165637.82966-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <aRhLmEKixuKGCUJX@yjaykim-PowerEdge-T330>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 89B97120004
X-Stat-Signature: h9g8p6hpze8xnjjihohykfs65aqxgdwh
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763225807-298654
X-HE-Meta: U2FsdGVkX19c6wFMJUc2ZQrkB8UPjFBRRITK36i3D9CN/F1N9zQ0AIc/1q6IzBZm1N10AzMGtUNXqeYhM3GV0DNZYDds8sUkD2o14nhYpl8g7hnnmiijFiDtqjFa2iaeri+aEyAvwggDbiggwnEYWhk+gjt6tfAm/oEpXFbAx8AY5fIURJ+JwX1knKLXpSLGjvgGDHEY09D4JRKNeSV5l5AN8NH59RjC5NpU6tABSTDcm1IFjA5ddYeTHSAk67nPaHnLVCl/dsUQ3WGXkEkwTuxMoi0xqopCFbeHTHCJ36QBrYk/+7lz/7ydfdW2MHLiWiOoqB4HgvQ45eB9odIIVFao6ktjduiL/LyMP8ECGtIMFoMIpHaAXG+ZcetKZqgNPDyZ3K9CGbQ8uiwOwnrqNFNJnnqRTJYdKhxyMDhQ3KC9CC/sYKM4JlbpAt2KihaU5wT4day/cEmW+VPWtLrVhCMtlR9AjDWbzX6nqQ7zMdyckPcyGnIax1e2zpXaQtBqqTFlZMmgSgBNbtP+ehaaBlbq/UZoNO0N/lLbodJO5lnUYonmzoaviTUvzI9tfBtoNx/ztYHrHZvMiZpMkfcCCExcyj+pvVMAdSna4621gVGhMLO0N+whADrp+ROENoxdTt+72dsMYLa/17PeV34NHJgB2f2e6yWbaQTfr2QxlGdgjT1DqW6jU9LiB2S2GuiHiBt/k/gmvu79syl26dlbt2mWy6t+lWLNtdDnnrX4XjhJxcBjGB+yse/TdN7UE8JOqErgNEMIwOFlyiNgKnwwNyoL9MTDUMJjbm4pYdauAyGqJaIaSPRRT+8CQTT9uCXVlf/oU2hUFWwBpf4351tDMkFdxXe1unE15QG+NGECSJqSziFySZos4pO+yMInCbnc/6+EGbJeq4RhIY05uujBkXMsxwy2p8VZuRDmqSjkZiEsC/dYy9eBuoYx18Ct+aN0MGW7Uw8OCH0d6NhggxI
 jNciJooj
 CGDN/h3ON0vDqhmi667A+gfLcz3dqFreqW9aWOZ9RyJno5NQmPDcO6ZRyATX+Ce1E+sQPAI+HF5r2dkNxinOvD6ngqkWQzHcINwz2qIqfLNRaAr3jPBNadZlEo+L1jjeEeqZp8N9wW5VLe/FZelEeE+k7q9CJwnwv6Lyn5pgPBaoJh//iCjeLAMZCCxRCxbxCS3SPxEaFbKWLOKEAIh1wrDdDxrzX1S1BGbVKFTga7KOHt3cJqgIMtOJQr36tYTNW4K4WFSGykXTxCekAsPntFCy1HshDtgxl68mDSKUafueVp6KXJJYgMGlpy8tRiDHNzrlJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 15 Nov 2025 18:44:56 +0900 YoungJun Park <youngjun.park@lge.com> wrote:

> On Fri, Nov 14, 2025 at 05:22:45PM -0800, SeongJae Park wrote:
> > On Sun,  9 Nov 2025 21:49:44 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> > 
> > > Hi all,
> > > 
> > > In constrained environments, there is a need to improve workload
> > > performance by controlling swap device usage on a per-process or
> > > per-cgroup basis. For example, one might want to direct critical
> > > processes to faster swap devices (like SSDs) while relegating
> > > less critical ones to slower devices (like HDDs or Network Swap).
> > > 
> > > Initial approach was to introduce a per-cgroup swap priority
> > > mechanism [1]. However, through review and discussion, several
> > > drawbacks were identified:
> > > 
> > > a. There is a lack of concrete use cases for assigning a fine-grained,
> > >    unique swap priority to each cgroup. 
> > > b. The implementation complexity was high relative to the desired
> > >    level of control.
> > > c. Differing swap priorities between cgroups could lead to LRU
> > >    inversion problems.
> > > 
> > > To address these concerns, I propose the "swap tiers" concept, 
> > > originally suggested by Chris Li [2] and further developed through 
> > > collaborative discussions. I would like to thank Chris Li and 
> > > He Baoquan for their invaluable contributions in refining this 
> > > approach, and Kairui Song, Nhat Pham, and Michal KoutnÃ½ for their 
> > > insightful reviews of earlier RFC versions.
> > 
> > I think the tiers concept is a nice abstraction.  I'm also interested in how
> > the in-kernel control mechanism will deal with tiers management, which is not
> > always simple.  I'll try to take a time to read this series thoroughly.  Thank
> > you for sharing this nice work!
> 
> Hi SeongJae,
> 
> Thank you for your feedback and interest in the swap tiers concept
> I appreciate your willingness to review this series.
> 
> Regarding your question about simpler approaches using memory.reclaim,
> MADV_PAGEOUT, or DAMOS_PAGEOUT with swap device specification - I've
> looked into this perspective after reading your comments. This approach
> would indeed be one way to enable per-process swap device selection
> from a broader standpoint.
> 
> > Nevertheless, I'm curious if there is simpler and more flexible ways to achieve
> > the goal (control of swap device to use).  For example, extending existing
> > proactive pageout features, such as memory.reclaim, MADV_PAGEOUT or
> > DAMOS_PAGEOUT, to let users specify the swap device to use.  Doing such
> > extension for MADV_PAGEOUT may be challenging, but it might be doable for
> > memory.reclaim and DAMOS_PAGEOUT.  Have you considered this kind of options?
> 
> Regarding your question about simpler approaches using memory.reclaim,
> MADV_PAGEOUT, or DAMOS_PAGEOUT with swap device specification - I've
> looked into this perspective after reading your comments. This approach
> would indeed be one way to enable per-process swap device selection
> from a broader standpoint.
> 
> However, for our use case, per-process granularity feels too fine-grained,
> which is why we've been focusing more on the cgroup-based approach.

Thank you for kindly sharing your opinion.  That all makes sense.  Nonetheless,
I think the limitation is only for MADV_PAGEOUT.

MADV_PAGEOUT would indeed have a limitation at applying it on cgroup level.  In
case of memory.reclaim and DAMOS_PAGEOUT, however, I think it can work in
cgroup level, since memory.reclaim exists per cgroup, and DAMOS_PAGEOUT has
knobs for cgroup level controls, including cgroup based DAMOS filters and
per-node per-cgroup memory usage based DAMOS quota goal.  Also, if needed for
swap tiers, extending DAMOS seems doable, to my perspective.

> 
> That said, if we were to aggressively consider the per-process approach
> as well in the future, I'm thinking about how we might integrate it with
> the tier concept(not just indivisual swap device). During discussions with Chris Li, we also talked about
> potentially tying this to per-VMA control (see the discussion at
> https://lore.kernel.org/linux-mm/CACePvbW_Q6O2ppMG35gwj7OHCdbjja3qUCF1T7GFsm9VDr2e_g@mail.gmail.com/).
> This concept could go beyond just selection at the cgroup layer.

Sounds interesting.  I once thought extending DAMOS for vma level control
(e.g., asking some DAMOS actions to target only vmas of specific names) could
be useful, in the past.  I have no real plan to do that at the moment due to
the absence of expected usage.  But if that could be used for swap tiers, I
would be happy to help.


Thanks,
SJ

[...]

