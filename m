Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 666C8E9D828
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 23:06:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD8B16B0088; Sun,  5 Apr 2026 19:06:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89F06B0089; Sun,  5 Apr 2026 19:06:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F676B008A; Sun,  5 Apr 2026 19:06:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 981FA6B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 19:06:13 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 425371B6AFA
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 23:06:13 +0000 (UTC)
X-FDA: 84626037426.03.E08E058
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 99C7C100002
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 23:06:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=URmIvhmr;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=URmIvhmr;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775430371; a=rsa-sha256;
	cv=none;
	b=f4N3eOiMTLmdHM0CRS06t/LwGW4JnWae9o7njLU+6fUL9oytk3QAB/cMmwOAEGcocGvVZ8
	BcktE1Ynd2Wv0EgWMkotupYP5U+ciropIh2VAuBBD3yNQ3UTVetvSnd8bn3sfGFbM7MZdL
	fS59LOXrCMoTJOgy8gIrZo4o8kFfykM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775430371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L/2zD7w+Lpl+V/M49I6KSIsTJoy8VbK3b15DgoUgogI=;
	b=fEZO+6w/ExWVTn+6g72pPScDSewiI1G+IiilBpUohwNQgzNHD13jeOiKmlDMWKrkqt/50K
	oiFmRDWippToNMDlqDevyLmvAzR8FkXT1UiO8SSsY/OiWQ4TYZzz59REFJinCJm+06ZWUi
	apcq59nySNBHsIhtDNuOpBdl/xRvBmc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8904F4077E;
	Sun,  5 Apr 2026 23:06:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41287C116C6;
	Sun,  5 Apr 2026 23:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775430370;
	bh=pP6Lsj6XqQDkF7uu3oeV1rYB/xOwRq5U4UDN4zrHvtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URmIvhmrOUP/ERm1/oiysBSdneWuMSjg4ZZWcidG+FATwxXRAl3hP+aNiUKkFhaRD
	 RciBUIYsdyoWuXw8tUXQ8NwdE+B2U27El6OU9rTl7wuOxYVOW7/PPJ1KumY0OC4Mlw
	 JQd8eRgv4FIi2aM4dFhCiqWapwvvo3KRy0ytOCdEx0PtlbhPQ1AhVAWczlbYZMEaiE
	 oCSH0DQ8WO8jWCnfHFzXJPqphIknoiFlwaAnjQmUN4JOR6W2xqTCGRvTCZ2+utlF6y
	 OuxgzzKkKAx8c6iOpW5xhUCSY5VlJvNgT3I/7ps37WoAmeCXlmlpkaqfulEqVz2JSO
	 FMaYYpFjZ3CFg==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v5 01/10] mm/damon/core: introduce damon_ctx->paused
Date: Sun,  5 Apr 2026 16:06:01 -0700
Message-ID: <20260405230602.118036-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260402011043.67218-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99C7C100002
X-Stat-Signature: m1umnke51fpcc1qf9bbf466sp5j5tkwo
X-Rspam-User: 
X-HE-Tag: 1775430371-71982
X-HE-Meta: U2FsdGVkX18JiHBqKUvprlOCEygl31DTAPxTcyuzqB2ia/rm+VOAjaPsBG8fm/IDyB1ijx7hYJz3ed/kUrYme5SF/+O5yoT5/vqRCrsyO2tXpdGt+B12rwhQNJoN0N18teC/HsVPXxZ6WCZscN2aW547vnA7GGH35QthOHQC4kOEoZO5i2uJNSNmmBdyZeJZgST1gfCWRFa+njbTzh7uzaVE76vSw/pIvcjSue31S6S9ecoXFcwQnhO+B0rNfKcTWt0YSfPbz8YDsW4VpQJA4Dro9FYX1MeVymJ9y34m7AS6/kntSf90yDJXsvQOsREOrqyfBTX+30AqxB/SRx4xIvcVzIzzJx/pUSH9ERLwaJ5VQmKsDTHMpjYGmC1PDPP3FuIfGSWB7EEX3SfwWNe48PqtH6zfDufE+sAFO4uxNtoV1XHW+83gC5m/7foyu5YTKHdRIN9haoKMa3NWQNy0bCrjVkIZARgpoPOvV2q67HEu4N6H64csPV0T+R/o9loHFz9lay+Cu/59bXhCmHwaTVWcvBziqVlKO5ET+X2sSUUUPOnm35Vl/U0JOGEWffkPE/1hAZmi+gqOqvMA7joiWN7GN/gdAYbw1Ctypni4C+CWfXk4QwmARTddJq+FpwgpzMEAdbGxEKUdTK0RZG8pBHFrbNC1SWURNsxYs96i0Nl4fRZTu47IxrRH4C8+7RZZEZ5UTlSw5WPGZ1T5rCfT9sA8W22cvEPI93y7o+VVPpTjR0ZGIMdBExk35m7MEH9N44vNVs5X3OiwxKbE+2SjKMkJ7nxiWm77wL3ABM56JB83w4gdy6cIBAYHdbxAx4st+fUywmQ8I4aYiMULSp5120JmTpI82G9MbAOP0xXX3FlRbm7RgFEtU2+4mVRyzQKUJPK9xUPUFHZ6Rcvx7sh5YJWEslI+rA3GeWtSuxFV5LesfrQqPkE5GTxqZT8yKbxTYr+/Oqu7g68JZ7o/OPH
 Ehp6Vbfp
 XYtGhxpuZIGU0gsOujvWibjc4FJfe8Dq5igJdeGsuuwcijQ69MhuEoj0iZF2/SdfvPtWLydl1duuNAK4k8Ts6JWngxpQG1T8ZVVhV+wh1Robx73meT6WPdxfRXuHeVwHAtgZbg8Gh2RSuoIPzTJgEHkqeNcjbVl2gDZxnhbSluqxMstmfd6SZ0qsV2cYEojIFszf+TQ/Z+bn0F0NBpps+df3aEOL4Qe/1laBmvkorNhSYDOomOb46T5T+da7ybBdvk5oH7pwa7rswtOmxwxRMsllDqw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  1 Apr 2026 18:10:42 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Mon, 23 Mar 2026 21:07:21 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Mon, 23 Mar 2026 18:28:00 -0700 SeongJae Park <sj@kernel.org> wrote:
> > 
> > > Forwarding Sashiko review for doing discussions via mails.
> [...]
> > > Additionally, when the context is paused, kdamond_fn remains in this sleep
> > > loop and skips calling damos_adjust_quota(), which means quota->charged_from
> > > is frozen.
> > > 
> > > If the pause lasts for more than LONG_MAX jiffies (e.g., about 24.8 days on
> > > a 32-bit system with HZ=1000), will system jiffies wrap past the half-range
> > > limit of the unsigned long type relative to the frozen timestamp?
> > > 
> > > If this wraparound occurs, time_after_eq(jiffies, quota->charged_from +
> > > interval) would evaluate to false when unpaused. Would this cause the quota
> > > window to not reset for another 24.8 days, accumulating charged_sz and
> > > blocking the scheme from being applied?
> > 
> > That's a wild corner case, but I agree it is better to avoid the problematic
> > case.  I'm still thinking about the good way for that.  Anyway, I will address
> > this in the next spin.
> 
> The root cause of the issue was introduced before this patch, so I fixed it
> with another hotfix [1].  So next spin of this patch will have no change.

FWIW, I'm planning to post the next version of this series only after rebasing
to the latest mm-new, after the all MM pull requests for next -rc1 are merged.

> 
> [1] https://lore.kernel.org/20260329152306.45796-1-sj@kernel.org


Thanks,
SJ

[...]

