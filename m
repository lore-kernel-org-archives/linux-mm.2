Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39F9FF44871
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 14:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D5586B0088; Fri, 10 Apr 2026 10:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985816B008A; Fri, 10 Apr 2026 10:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2236B0092; Fri, 10 Apr 2026 10:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A49F6B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:05:42 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2AB8140593
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:05:39 +0000 (UTC)
X-FDA: 84642819198.04.45AC922
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 895B540006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 14:05:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMnTBLr2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775829937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2Yc2ufrFbVmz+XNd4LpUhe5AZVmPZIwqnXGOTUi5JI=;
	b=0s5yx9vjk63BSB54crrx73Id9PBQQUg7IF31taaTUWKujRQX34CLftO5XxfSLWO1A8JqrE
	Fl/cVrXNBcsDIyXtXyBABLGZc15JfHCOZ48fZ287GuTtK8gzWTkNWOCnoEKYl5cYN8aXj2
	7L3INhLiDedTOIgqwEa41dm4EJZArow=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775829937; a=rsa-sha256;
	cv=none;
	b=cCnnzj18mG8vSOJ1WYCmT/wdn5HNVorfUcwFxt/rnSBgxjacaUjh//vDNY33u8sXm2qnFL
	yrWYWcKxymkqo4BlruqOrFQ4cyS/MaQZS91CreZ06iJoP8hxY6ejvRlFhXg2Qm+eFMxVk9
	RBrPlHN35X1bRCi2BIEMuxXQeKC7+vs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=EMnTBLr2;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F12B408E3;
	Fri, 10 Apr 2026 14:05:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1750EC19421;
	Fri, 10 Apr 2026 14:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775829936;
	bh=vU7YhsU6mPtOO9+7OdOGJ86dQ128aE6IKS2KzhCvWA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EMnTBLr23e9TcOIjzibJX2yAThFvTjWcHruR2vn40XZzn/dQb7PmEq9jB+CyajGDR
	 y62IuCLcV+k03xjqiIeBPQRf2NuX75zuJEgT7RXcQJ7u4lpgQGPLlQwjOVCgV14FCk
	 HEiQiBslMzj5/zJYWNwa/EfO7/FvQjgCzqu8KnO4gT9BD8vzzHJgn2a8b5IH9MWTkB
	 cgHGBOjdXOtCdQl3XQjcD0FGMgNTgY81u9xT2L+ohESdvPLA9lwpB0+1T9gu8kX0aP
	 JKwRlYahD5H11hGUSiTMJyPzVXSfe500z9NEYUQRdhy5FUI80yQO6csTnLW2LwZayS
	 1mVjtY0VP74BQ==
From: SeongJae Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 0/2] mm/damon: validate min_region_size to be power of 2
Date: Fri, 10 Apr 2026 07:05:28 -0700
Message-ID: <20260410140529.82414-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260410044259.95877-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 895B540006
X-Stat-Signature: pky3gmugpqmcq7dmfaer4o3rhk8xgxgy
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775829937-345391
X-HE-Meta: U2FsdGVkX1+glz3d5RdIUUWfwJAKP1I23dtRzFB6/1qKLFBXKuJd2j3ypLLOfnHNaf2dSR+ncTzHUlAfaHsQ1GYsZxqbFfhVwdvvqrQwDUd3T22ich48XARFVr9Skn2iUQ5KR/7d3KdW5NvyceDwf8aBIkKs0oqWHK+zQVpqPO57oFShvGKCrZFa1S+SqjEWsWoTCxPmEz8/HvpngCH+5Z06BwuGHv5Vbhi8knU6KdeV/5NhYVJzxKyfnKmFGIcVDLxwA4CfzDOCTgqoPBIIc/I67mcCgCNrEQ34pbUv1HCP4u0vVntkeZLaCMiPLUkqc+b7JS4StPscy8TEHq0AZJKOxCGW1yiO2rGAK9gbU/rE64LtgedLHw4scwYjoOpEd2NmyUPDFvenLynJWuMK+GLIwF5FPdejCCcccWPipcyP2BsQVbpcB2kdcvKLrG0R/AcMO7LZSnslkitSW1XBZ8g61mqj412jXFB6xwbfFfYLTbYqA5BKS+zjaPAYPAZi9QoYoy3b66lj+kuwg4E1uD6S2cPODzPmpaoFFDUZjA3SAX7PAAuxUkdFxyodKG19gd6L/w+X8LPxbWAzUahV1AXj7aDS1R0Eq+PqCCYQew5DMa2ReCtV68FszfkXyHYO2L0JDu8hZQpOG60cVYbopMaaHZ//OV1zDugLdUXJK/JljE7eZlW/JIV6MuA/yYkXK9tyGt5lQ8qPzGkC37xD4zvLOjA4TNdF0Bibym2/YD1isQci6sP3G3ilONjRJ5xUvzBwzB/bhBYLDrTQ12cgZipOgm0hDsdADAUdgRnwQEqvfzjbxoGK1IX/jvsvW+RKYrIIeR49M2XIvegU/R39MUAs7fI/wvZLE/iYKSsdI6flvmwnTLPrn/A8Vd01xRVwqRxqM65/NWuyzA6VHYvahodEhrOQ2+QdMcomws4oain3iASVS/8M31JVJNQl1zGNOHQdLVtgO4IoMEHowbb
 X3F1Vm2K
 vcl4P+4Z+A0F8WApZQtVQdeOSqJVjEz8Q9rzCp+73+7oupvRAF49k0huHo7B223kf6LTXRPYl0ajp32jZRIApBXvZtXRs95HsrjH8J1+puKPqLiIN/h9tNsjTvl6kqhcul6aDqCFIjRtviUpgFOWidFn0b76sgtJjQ5RJ9b7iw7x8ezk53nLiRI7010jLTY3fyO5RqB7yWUbN0RnLp8o8Q8j7XWV0/ljkInvjhz+RFrVAh0iiLjEigQOhXKxOvRsarG58ce034mHnPjR7PxKV4Dz12osQhs7R+hO4zoK04u1/mRg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Apr 2026 12:42:57 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> Problem
> =======
> When a user sets an invalid 'addr_unit' (e.g., 3) via
> DAMON_LRU_SORT/DAMON_RECLAIM, 'min_region_sz' becomes a non-power-of-2
> value. This value eventually reaches damon_commit_ctx(), which does:
> 
>     dst->maybe_corrupted = true;
>     if (!is_power_of_2(src->min_region_sz))
>         return -EINVAL;
> 
> Although -EINVAL is returned, 'maybe_corrupted' is already set. The
> running kdamond observers this flag and terminates unexpectedly.
> 
> "Unexpected termination" here means the kdamond exits without any user
> request (e.g., not by writing 'N' to 'enabled').
> 
> User Impact
> ===========
> Once kdamond terminates this way, it cannot be restarted via sysfs
> because:
> 
> 1. DAMON_LRU_SORT/DAMON_RECLAIM is built into the kernel, so it cannot
>    be unloaded and reloaded at runtime.
> 2. Writing 'N' to 'enabled' fails because kdamond no longer exists;
>    Writing 'Y' does nothing, as 'enabled' is already Y.
> 
> Solution
> ========
> Add an early validation in damon_lru_sort_apply_parameters()
> /damon_reclaim_apply_parameters() to check 'min_region_sz' before any
> state change occurs. If it is non-power-of-2, return -EINVAL immediately,
> preventing 'maybe_corrupted' from being set.
> 
> Patch 1 fixes the issue for DAMON_LRU_SORT.
> Patch 2 fixes the issue for DAMON_RECLAIM.
> 
> Changes from v3
> (https://lore.kernel.org/20260403052837.58063-1-aethernet65535@gmail.com)
> - Improve commit message: clarify "unexpected termination".
> - Add detailed User Impact with reason why kdamond cannot be restarted.

Thank you for making the change.  Looks good to me.  I gave my 'Reviewed-by:'
for the two patches as replies.

Andrew, this series is for hotfixes that deserve Cc-ing stable@.  Could you
please pick this up into mm.git?  I don't think these are super-urgent and I
have some capacities to manage this myself, though.  So if you prefer to, I can
stash this in my tree for now and repost after next rc1.


Thanks,
SJ

[...]

