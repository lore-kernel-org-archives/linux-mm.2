Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2337D10F3DC8
	for <linux-mm@archiver.kernel.org>; Sat, 28 Mar 2026 02:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B35D6B0099; Fri, 27 Mar 2026 22:30:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88AB06B009B; Fri, 27 Mar 2026 22:30:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7B76B009D; Fri, 27 Mar 2026 22:30:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 68D066B0099
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 22:30:25 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1663DE1D02
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:30:25 +0000 (UTC)
X-FDA: 84593892810.26.6253CCD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 6D723C0003
	for <linux-mm@kvack.org>; Sat, 28 Mar 2026 02:30:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=di8marH8;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774665023; a=rsa-sha256;
	cv=none;
	b=opJJn6ILZBPPEPBvuFj8L35lF7w5OmVa9L1mWhWCF9hhZSr5ySRPPqXpLampzQYPwlFLQW
	SvRbhP2tTmttBUbPRVA65HuXtLM0CGFGUW5YtGSYM5fSxaMJkl15H7AYva3G+ydbacgPL7
	ivc086RdLpCOHh6uOBO3ws3Mcq6++0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774665023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoYwlKx46TsaP/gujwSOltovcgzZkQ/np1EimtzLsfo=;
	b=1peRYl+GBjDM4yvMYeIfgBgZets5Dya5ttk+030JUPGDARqOh3ObeajN63GI6plbxdWyy/
	VkcIjs5tfxrYhXahKWgMdgv12cgfghLmeYaqCJozGFP7mZYs9j+ZjJRrkQM1kAKhaKfauB
	EAiRxoQTj14jetandKBFjxdz1o8eASk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=di8marH8;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DED38600AE;
	Sat, 28 Mar 2026 02:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 766D8C19423;
	Sat, 28 Mar 2026 02:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774665022;
	bh=LxFmMpfJcOxqkaYRp86376K9yg/HLYeOtxNghx/brdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=di8marH8r/JOmw/1cHmnyV1x1x3milaQg7+Hp73F+lCh7c24s5QgzJYd1sweKw4D7
	 IYX0eHDeVIzE4/1I9QhOsgifEzaqXeR82mWrrcoblYCOiSJ6Ycakdd3ywKWkyFVMm+
	 xb0mMZ/HcI2haDXc1ZDixf1zXjuw2IVc8FC1XfT1eg9qhtMU20OV2dvN1W8ysvZWEl
	 QBwPm6VmPbLrclwlQBzWsDxLKDCfV2qwV1ipUO7nhWHpXrVJHgIjFtux2hFc8z/oo4
	 GdmP6IYkvlm6Ihh1xyd/LQgpVaDUA7w/mdEt3tEIt18rGYuduGv8jTMi/ruajNT8I1
	 m0Kl1/vtLhWjg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: "# 6 . 19 . x" <stable@vger.kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH 2/2] mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp
Date: Fri, 27 Mar 2026 19:30:20 -0700
Message-ID: <20260328023020.8525-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260328005412.7606-3-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6D723C0003
X-Stat-Signature: pzmbxzmoeuhgkft9eg4r7bzpy8uepddt
X-HE-Tag: 1774665023-879424
X-HE-Meta: U2FsdGVkX19sTY09JKa6PCmKNfKRkVrjtudonnXrGwjyQfo5YI0+r+x2YrbbdZx0jpp0n5LbbZvPdwbS+daLDTRcFGYj28L91j/t8nmpAP1mXBDdAqb4AG8rt1CyCkQ28y1y4F9O+NOzNZa2Bil1QacnMwjgszfeVSU+DojBb+tTq1o8dy84+B5ng9tMvd3449Wb2gqCOObRfDJAC40mCIUWuCDEW+d/AQC8Lmu66BAenvAOqWP0ozSEeDuSTQaWHCvmVg44uvDpYDmtGjOyGtTGHhhVbkqtxKypYQlvs7zuQGQndELkw0qP3p0F0m6SFhpSXohdoLWWYli8qOZqImGdaZ89SAmZFDX/7Ai8jliIlphSWOev3I7MZtzDbYMasmVmOtJwKOVLiC4MmVcENX2CRSd+mOImqnXvh763AC/hSOsb5zjM3DG/GNq9RsOe1HTwisj0hX6QZmLV8ei089KWhkx0jN49uk3Lz/bcwnA9J7R8MHFUKLW0j8s2Zu93Doe68uhne1RDBxkkBRsfAmB2hLbuoz5won6RhzJ1TAROfj8/3IJIq5dtzYne0tGYIEsz9X7Q4eEv6rePUHj4jAob+j6yKdb9zJgACxH/f+49jxHCR3QUfju818Za7Qi/cSYvFPOr2hyjEb7BwmFlgT36mE5zOFjVM4+cDD6XUhszY/mRIXHyKuEZhq2K9ojs0PS1YSpqEHUHEWXPlfNfsUqd7rDcw/AdtnHQkt4uF16n7z9YFzqSSaZqAM6xzQ/o38i9EPKA8vN1/znS7w52ULsX/jh/4JLUbXajI0atpkti9fttdz/ujWUsZEFBqYqwRXmi5l0wd+1NI3OseOWk9xKDk3KeEV/5vV3LoaJqenD89PDGZuhT45rLF4GzhTjrgoct7iJYtrbgeVyM7/SvBe+lz1LdSTPcVrvLj0EcsSdGXLBiGlU4J4oxWulgMH+/NdbO6GdN9PZ5+XfVgoE
 nLEXXBaG
 oVDFGwedeAh9lolO795LpyPMio4/cK9ztyUg6n38koEH9f0yP94JXkVOqiYiBvDl8Y+aHfBN5FcyaOcur56csD/dn++UeXXDNGaQ5m386h8rTCBAT54LWRWdDrQ+Z0P45TR1orrUde/wsiyMwR4Pgs0Q9uciGzKZRR5cmkwHjiUv1v3hbhwBtb8XDesfEbGteD9hg16mz2meiMyVNtfC7n+5skZZunoDjGMiVNY7Ufb/R0gJXkEAiZvHv24/4vE0pUB0rBWlKblPGe4f+SYqmANZTb0gtNxXQLd6FxSO40fqsmQNjMuMGD54QcOrA0LjhmDXBrxriP6BjM13jqshs70qxk0d/47E76V6r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Forwarding Sashiko review for doing discussions via mails.

# review url: https://sashiko.dev/#/patchset/20260328005412.7606-3-sj@kernel.org
# start of sashiko.dev inline review
commit d10719045bbbd92307cf40ef0886ce0e81cb9caa
Author: SeongJae Park <sj@kernel.org>

mm/damon/core: validate damos_quota_goal->nid for node_memcg_{used,free}_bp

This commit adds validation for the damos_quota_goal->nid when calculating
node memory cgroup usage ratios. If an invalid node ID is provided, it
returns 0% for used memory and 100% for free memory to prevent out-of-bounds
memory access during NODE_DATA() lookups.

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -2273,6 +2273,13 @@ static unsigned long damos_get_node_memcg_used_bp(
>  	unsigned long used_pages, numerator;
>  	struct sysinfo i;
>  
> +	if (invalid_mem_node(goal->nid)) {
> +		if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
> +			return 0;
> +		else	/* DAMOS_QUOTA_NODE_MEM_FREE_BP */

This isn't a bug, but there is a typo in the comment here. It says
DAMOS_QUOTA_NODE_MEM_FREE_BP instead of DAMOS_QUOTA_NODE_MEMCG_FREE_BP.

> +			return 10000;
> +	}
> +

[ ... ]

>  	si_meminfo_node(&i, goal->nid);
>  	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
>  		numerator = used_pages;
>  	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
>  		numerator = i.totalram - used_pages;
>  	return mult_frac(numerator, 10000, i.totalram);
>  }

Does this code safely handle nodes with zero managed pages?

While the new invalid_mem_node() check ensures the node has N_MEMORY set, a
node could still have zero managed pages if all its memory is reserved, or
if a concurrent hot-remove event drops the pages to zero just before
si_meminfo_node() runs. If i.totalram evaluates to 0, mult_frac() will
cause a divide-by-zero kernel panic.

Can this calculation also silently overflow on 32-bit architectures?

Both used_pages and i.totalram are unsigned long. Since numerator <=
i.totalram, mult_frac() bypasses the initial integer division and computes
numerator * 10000 directly. If the memory cgroup uses more than ~1.7GB
(about 429,496 4KB pages), numerator * 10000 will exceed the maximum
32-bit unsigned long value, resulting in an incorrect ratio.


# end of sashiko.dev inline review
# review url: https://sashiko.dev/#/patchset/20260328005412.7606-3-sj@kernel.org
#
# hkml [1] generated a draft of this mail.  It can be regenerated
# using below command:
#
#     hkml patch sashiko_dev --for_forwarding \
#             20260328005412.7606-3-sj@kernel.org
#
# [1] https://github.com/sjp38/hackermail

Sent using hkml (https://github.com/sjp38/hackermail)

