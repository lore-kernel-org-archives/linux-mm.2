Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B17DE66886
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 02:42:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA926B0088; Fri, 19 Dec 2025 21:42:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7930F6B0089; Fri, 19 Dec 2025 21:42:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 695316B008A; Fri, 19 Dec 2025 21:42:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1816B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 21:42:10 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EC2481403F2
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:42:09 +0000 (UTC)
X-FDA: 84238299978.22.E86076E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 585252000B
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 02:42:08 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAVdGaiY;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766198528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=brQggMSUyAjDugJQGfNkWweGj6t3ESK+xyAgWkJcu2Y=;
	b=FNIn8isMnzEIoaNEkawPi8aUTXhmA00eTD3XgUfe3ys8oht3Nf8NYaax0ljWTUL2HE/TyP
	JgBZ/Lwv5Qi3YU/naca5LKvh80TjwlJTkUUtBxcxGQHXCXm/bmWm5ERjM3zX6MriasP1NF
	2DVump4a4l7AM1j7sS0O9WGoYFliEUg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sAVdGaiY;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766198528; a=rsa-sha256;
	cv=none;
	b=H88fwnqQafQxWrjduFQNW+gv4UOSesbQWlEiavEjGaj4RdDDSJemBXi2MMX3yysZuiKa9q
	xB89H1qaDLhWLu+K9YpcB8v5jlWtyceNzjSdR+H9Ej0j61kq+j6y3E6G6sFV+6/CO86RwR
	MDNIpEI47nqSlJMplTQkCL4g7FAD1yw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E3694433F;
	Sat, 20 Dec 2025 02:42:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08355C4CEF1;
	Sat, 20 Dec 2025 02:42:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766198527;
	bh=mndMqX0S/14QL0u5YDFIVifJ026qwf4PHYrKtqB/M+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sAVdGaiYIqmFPMb237e+e2rLHhbk6C1T5tXs8tS0am3d4NjFmk0P8DtOT0G0S0KRY
	 EYkC1Ccnl9LvqnT+geDFMUbhN+aRUFQGqMOzYqRkTYRUUaB4gI5xH1EKhAgAHdVNlS
	 uIIR55jIq5OBdHuGHZsuxo+cgAvA5lXRI4wOVktQO0qf8TaroYo+hJnn54KXsqtKUt
	 sS89hDW6xOf5pUvUg79dFM+vQtsUN+AF3H7cs2GQUykNVvDIsPJDwwgK1B4zH+uFSY
	 q3dJ6G9C/Y36sNbVIdtq5kE5oU85vlZJXFUNPAJkSEAsghLTZrTzoK9mhuVcvRvPX4
	 yMI4yJFye4rIw==
From: SeongJae Park <sj@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Palmer <daniel@0x0f.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2] mm/page_alloc: Report 1 as zone_batchsize for !CONFIG_MMU
Date: Fri, 19 Dec 2025 18:41:58 -0800
Message-ID: <20251220024158.43433-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083200.2435789-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: kqd8rgey6eb3brnnsosyj6fw54xbh9u4
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 585252000B
X-HE-Tag: 1766198528-227219
X-HE-Meta: U2FsdGVkX1/NqnD30507dVRz7QuSwg9Q/ayE2UdkJJfZHQrdN/hLZXMQD9qIr5qt1BL3wOWQUCv8HqR9tbv7yWNfKGlttCME0tv0oJ0Q2c/Tae3Ogb1rG62NMwaahJdicUwvOeyStO/MBspCLUAYcdCi9aj0Uruu1gQkuCSdLSPZU46jNdC42wKug8iZ5xz6t/NATOWJvLvxc+0P+YA6Pk+srYgynr4uhFiUuzMOGAr0ccaMqTZW63XWjOjQeZR6gyV62sWazOZ3QlwyHqpTLcY1/kk1WZeMZ/507zsKedAl4SVDKRQ4fsTY+la+mNPw2+4IanKzOflmq6JJrN5bBkCLm+t6WoF7ePf6I+FvFU2+Qp6e6YecXm1mscdbZ9YsJLCu4rH11USKngGolnrU/+oIFN4Mt+d3KsWnyS8WWUERGN1WPSsuuOSSiUZMeEa+BVSkzLSI8Cr4jOm00zbchnz8rYwAZJ5bMwTEGgRnYe0Rgjn3OBzDr4BTkgUFvzu+oWhfq584ezv180XkpDhinDd3a4Sa+XyaNM7iRodShoXXMqzZUKu5/RhZZWTzjD/38qLZn6KHTzpfliIrYvFvbGnBrm9rJyQ3I58OeOrn63ij5sKSFXsjA9Cx9V3UHiaFuLyzt4+Sa85vyyEvIAphlCxEJDdEE/QhJjKEHT1Imp5bObfbm0SoOXPSn5WRb/4WIs8t6KLZww/S32lszXW6dUFJdg7Gkv1L8qWARX5u8khfuNbjaIrQ+7vjhJXit9MO94FEoh6gexHZLa4SkTbW9GE4ntDymmFW36fPjuwyI5LL5F0AIA+o6QiMY7W7IrNqKpHlKwaNlszmtyuWtbRz1/dZdp3VXwSs2QqL1MTwXhWJ/7vtvDGoFDRctLKprWCvuJTs71mne3NFBvXMTi98CbulhAUkCnfsW2RAM9hJ0RZtrU0ohTCZI0y5dHPQqnrXmJLknWKx3Q4rvLOTggX
 FsIEMQgq
 Oca9bQ7bcJYsFQazmhcn7HkmV+z8j3oC8ZD8+JK0RrbyAzWe387LcokTldl1ZCaQM/+6qSaWPZxoOHMnqHkpKyDcYMe3SdS0ZuUasvV0v1313tDGHEgbWtshMAcj7yCZJsnWBpJU+QU3cN8PUCzHk0tYcTww3mrzX4FRtja8E8GaPzsu6TluwHTOaJ2j6u5JPLyc5taUXBwmjoy+VPrL6vP81O4GpESbnWp0czWdmWx9kTVBwjZHo+l+zw4LLF8Zxiq6P+wZ1aJBAtb8NSO4NnDghDDcmgO2f0hAaf7pXGNfwhFaZHSQen16/vygylNITr9HUhCaO1q8hEdxT1i2CNFiym0m++Cc8fRhjwSnnC5p+o9jPCjrx53yN16uwuTY0TGRQAX+Tyop6HtL2X/og0bV3ngBOX1j01hI5UBlvSdwJ0g6lQ9cIfaCOKKAiZr7Mx2iSUuB+FY0drFhYziTqglrUwBZUnsBx7Yi/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Dec 2025 00:31:59 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> Commit 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> moved the error handling (0-handling) of zone_batchsize from its
> callers to inside the function. However, the commit left out the error
> handling for the NOMMU case, leading to deadlocks on NOMMU systems.
> 
> For NOMMU systems, return 1 instead of 0 for zone_batchsize, which restores
> the previous deadlock-free behavior.
> 
> There is no functional difference expected with this patch before commit
> 2783088ef24e, other than the pr_debug in zone_pcp_init now printing out
> 1 instead of 0 for zones in NOMMU systems. Not only is this a pr_debug,
> the difference is purely semantic anyways.
> 
> Fixes: 2783088ef24e ("mm/page_alloc: prevent reporting pcp->batch = 0")
> Reported-by: Daniel Palmer <daniel@thingy.jp>
> Closes: https://lore.kernel.org/linux-mm/CAFr9PX=_HaM3_xPtTiBn5Gw5-0xcRpawpJ02NStfdr0khF2k7g@mail.gmail.com/
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Closes: https://lore.kernel.org/all/42143500-c380-41fe-815c-696c17241506@roeck-us.net/
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

