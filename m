Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BFDB3FD4F31
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 19:48:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 025BB6B0088; Tue, 10 Mar 2026 15:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7D66B0089; Tue, 10 Mar 2026 15:48:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE6CD6B008A; Tue, 10 Mar 2026 15:48:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE4D26B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:48:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 517F21398B3
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:48:03 +0000 (UTC)
X-FDA: 84531189246.05.84A5986
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9814F40007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 19:48:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQIKf2zO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773172081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sDyNoQ3Umt4VC41nVkZFBBjnPbJ5RSyXwJTMYWBLsw0=;
	b=oDrfY0uxl3bJxfkDSBPKEgGPAIt2yjEZNcrTM1iVI/Y/UblkbChG+ykPjbawmWIe82E9/M
	6hidlNA7Yd4XOWIWJzxjs3d12PizKkM8GGthj0Auq/lVeRx3mb3BJ8EGbjBH+08pdjys6+
	iyiuzV70+wS17kJsHr2OuSSKFwz76vs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pQIKf2zO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773172081; a=rsa-sha256;
	cv=none;
	b=hsK15BZW2WREYfwxnPmJuc3vXnEO1nNAsHs1ye3fzGXWQT0Mg/8tV4WbtytX24+nSg13Ku
	8pu5a4pb/KpoeOgpgjbmXi4agH3tnHO9428f4ksDtnnQHOBkS6xu2gpDpETvsxQDM5UNw2
	3y0yXMgCQK5TAA8P3AFHjf6NA4u+yu4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 686FC43401;
	Tue, 10 Mar 2026 19:48:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216FCC19423;
	Tue, 10 Mar 2026 19:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773172080;
	bh=6T6jaUZt2ffF7BsGgmsx15Xkc6EQsgSDxh0SiVnLI4U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pQIKf2zO+VQwtji2K+41IbalY0n57Ers3wp0AU86A+g3QoHyrNMQyrnucruLgj/IO
	 oXW0ytWiIDHxkMctz9TsogDqYivDm8dDt7ZTvmLRj4IZ/ajVB3ahHlIRHBTcI9jN7c
	 uJ+RP3xVlfXB1l3EEQq/2SX89dOe+G4+ocZHByrGaSkp3L2Wd3nyuTKIn8CDWHSVlD
	 fpuXQwjD/IlUDwBBuJA27VEON3ACdhjkM9ojRdE99Lm2bFYcYoyjcPeUbn2W2gXT3O
	 M6VPkGlXgod9v1uabYJjXm+JOrVsEg2qpm7Fjfy0d5VjtHjOdasfBazJmEWJXpivii
	 Rixwf4N1h/+Sg==
Date: Tue, 10 Mar 2026 09:47:59 -1000
From: Tejun Heo <tj@kernel.org>
To: Ben Greear <greearb@candelatech.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Miriam Rachel <miriam.rachel.korenblit@intel.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: 6.18.13 iwlwifi deadlock allocating cma while work-item is
 active.
Message-ID: <abB1b098e83bLT5v@slm.duckdns.org>
References: <35779061f94c2a55bb58dcd619ae91c618509cf4.camel@sipsolutions.net>
 <aadKDCKGHk1Ua-7_@slm.duckdns.org>
 <3303d57a4ea6776dbc66ca72441023f76e6f1234.camel@sipsolutions.net>
 <35a7ebcf-862f-0b3a-a245-c32196a58692@candelatech.com>
 <aadYoaA_JYduCx_S@slm.duckdns.org>
 <de003dc3-3e37-f238-4250-2df16eeb77d6@candelatech.com>
 <68c1ca1381d1871fff72b211890a64eb@kernel.org>
 <bba74cab-7305-a052-7e1c-7a7736ba4531@candelatech.com>
 <5b9b93df8774810a43fceb359906604b@kernel.org>
 <729164a1-9dd4-c9a4-f092-d93d775257e0@candelatech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <729164a1-9dd4-c9a4-f092-d93d775257e0@candelatech.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9814F40007
X-Stat-Signature: 7qmsfwzgbdbkt9ou6boumtwtd4x6q9hm
X-Rspam-User: 
X-HE-Tag: 1773172081-667764
X-HE-Meta: U2FsdGVkX19UjECTKcFyeVNa+lIIVQGO3kOSrbp40PkNc53D7ksS9bywNXWDsfjuPFtHh+EXOnzjPMKOaYKsVkM3QDIQHTBSh7rN3IcZmvukgRajA3ZI7EY6eugg8ekcJ4brkFbMEvIM4zd429wHwBohCE8+BvXM/zWwe9UBtJRiGlr5ewNgBrBPlmBaDx9pkTpQTXWotVz4tuNFVPI1GDs1OAtYM1A55GkZcmuK1H0B5yFhIPpeYNF+8k6RMQ4zfXpG9plvrev77UTMXBajgaOOy5xBIdKpe1ofqWQ0GnQIZ5TWxwOadn0qCNAF+lW4FCnzrGO9ykTopOShEvXt8B7dBfL++gCjkGS4sn0/QTpCf8eiMjH/Bu9gfpSM3SHJZEFwSOsgEje3DQKnhRYhp7j49tjHg1m/C1biaHCJ3yXP/+9Xu/LmV1kha/00z/5P4xO1SKHAFPcHVgX96klYh9ftoLHqltNQvwksxPQN5V3dIJeBRbdnmJpw8177vVawJOt5wyIg8uReRSNntAQnAf5gguTXrJs0uIL3MHNVouMA05Zlf5IhvjP4Tlw6YfhMRXaEHYSvwcP3UQqWWxWUhXugUQEQscpMbYVm8HYqqWz28XkEHWOheZOyNrDkld7mjfYy4hwAnogLrMwnfkFcMBvzKcz4DFQwynJI23y0IG3gC4J9ulxtwkEGQFTLQwx1PnIOowMs9oW65KLh6cEakzutgpvcysxMqtZg/Lf5dZ8icMOcwCjFqjRaEuGVoGBbgX/1/AQeETROkuvTzvTZLyH01E04N9WUa0udLeFU1qCIJpcte6tTZzDBn9ITl2lhOt82nwP03q043A3+TEptApJtfNLgji1CceIzwXIJGtxz5RkNCXA/1JdPRHYVv6cALsmcavtbpdZtAWmrLbsKmJq1Zr/USR51i5r5x/MMG6YgsDtQmI13nag7StoNgMpjcuxKQl7sXApVJj0w0Ed
 yjIbc1ea
 7i8AtyHMbcHrKq7YPyHLBONB789UeOwV3cG3tD1KAHIVSaDAf8KvlXeff3B5oLhLtqh9W7oUVje+g2xQdWK6wm5YW+YeTtBXOtw1rdJNU62bQiytEEGpnho7iXSFJas4oWbXY5cv2gDg4l5VCFiRvw/q38sr9ijIuPMFoeqP37vOt2ohUb86V4VErz1RWF8F1j8kMkjEKFD6WRCQBm6GwSEDCXg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

On Tue, Mar 10, 2026 at 12:18:49PM -0700, Ben Greear wrote:
...
> But could this work-item (re)initialization also explain work-queue system going
> weird?  Just using kthreads, which 'fixes' the problem for me,
> really shouldn't make a difference to the code below, so probably
> it is not related?

Oh, re-initing can deifnitely corrupt things. Workqueue shares work list
across all work items sharing the pool, so the blast radius can be bigger.
ie. It'd be *possible* for kthread_worker to get lucky.

Thanks.

-- 
tejun

