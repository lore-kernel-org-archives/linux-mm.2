Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA07FCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 04:30:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539148E0007; Tue,  9 Sep 2025 00:30:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9E86B0011; Tue,  9 Sep 2025 00:30:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 426AE8E0007; Tue,  9 Sep 2025 00:30:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB286B0008
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 00:30:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E364F583A2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:30:14 +0000 (UTC)
X-FDA: 83868434748.16.8EE2B10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4023B40002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 04:30:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncqk3Z4A;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757392213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2Ux8ek3ct63Y8ZcqYbhJbHNfCiCv8CvaOJ7cl+B3AUg=;
	b=CPmboqPceBsK4ptMc9kaCvycNdjUHgEkPV758SaDV/mYOkz6TJKba4V5VJrBMuwrHjGtyu
	/IO8ZI9e4eWKeyLAjEw4MisIIQZhJBSOxs8l4Rr/grOfjtkkkjXGl4PpAQtwClhZwL0YTD
	WE8ggCsUj0s8kdHoY5RoTW1kOClYw7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757392213; a=rsa-sha256;
	cv=none;
	b=BxDuS8qoo1HPxfEFZdgMCJAzimy1sfhQIuWBgIXZ1X/7X18UuLnSJ5wtmBIglf/1ZsqmCJ
	IS1OabGJM2mFOjyOFACNMv40o5hvxvXUr7aF3Lrk+LrTNsWTl7YUPctYtuK1UXGqec0Guo
	fk/ggV3YcftFoyQr/uSGEGlic0CQaY0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ncqk3Z4A;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3360240478;
	Tue,  9 Sep 2025 04:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1C88C4CEF4;
	Tue,  9 Sep 2025 04:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757392212;
	bh=XaDrtfjywtQdCC1M0mnTwMYse4SqpKCgiK0eeh290h8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ncqk3Z4AmlmqjSVH+RnWKfjmcxOmt0Il6EeReuZ2UkrQhoNG95On7Le+Rvyp7HqyU
	 nnPcmGgsRpnP/b/eej6hbxJ0dq7f0CVBWAgdX+fPc88fYU1MvcIVU84kjLyvYld84I
	 FZSk1hn4OiSX+gk4AwzjgpMyugqhyTcWEW5wy5uGY08iYZ9xLFNxsX3VgO0qaxGXWX
	 wMk354AtbW8VjkYR7Zgy2Xw3r2GuYOysRAFs9TXUxLHZtRMye1/QssczFR7YiRD+/A
	 1hoNBcDWHQTiwzJ+SY9BjtpuhXKago+0rV8pjqjMfY4OcgaEyRUgsDesiegTWLBmAZ
	 XRVkozjIbD21g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"# 6 . 17-rc1" <stable@vger.kernel.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 0/3] samples/damon: fix boot time enable handling fixup merge mistakes
Date: Mon,  8 Sep 2025 21:30:08 -0700
Message-Id: <20250909043008.8651-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250908211845.bfc7299d783c361b10ae810b@linux-foundation.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4023B40002
X-Stat-Signature: us9umgso7fuynj177b59m4xhfzf3uko6
X-Rspam-User: 
X-HE-Tag: 1757392213-336716
X-HE-Meta: U2FsdGVkX18dv2TKwO4vDH6mUwMBIMJOS2zIo6ukHvSexe5ic+xCtUYL60KD/djep7Jg3Llew0+9zgtoUm8UA+Khyq3KbDV4Z0a7CB1Skuqg+hwD6Zyj3d0z03PWzpdS1Xqn8gzLLurq9blzFInkhI6vuGHLtYfZjipKXLtmzm3J9ee9pdRJbh6mlVI4RCtnolGHODOuO2cZl9c68FUa00wkfNHSHC0Bmt/1GjJRvEpOv0gighzTuOfpiufq+0PYLNPjTxOgxaqUk3p3ZHzlqouXlJjaMsrBtYaYNl3iTgMbLeqi82FpzuDMyhTEk36LM1XvnFAgsb07l74sCin6poVEm6gKw5E7/dETFZqCz8CMg9nr9fJftQ6tQKtW5X3eDK0uNwKeskzU+kIAdTvgXvP3L5ZbzXP4ey0Vx5M0IdsYGTlV8nMMl91FtBzPT4chfLAOG6V38fibRhsOCqCTDBcQbiB/KvVLqZXKhN5b+XYzCHTWrwRbspGzQTT51weAkhkxS7S1ZOGwLZvN0ZkNKTtDrWMAM8hv3MbhfsPKOPCxYUB6RqdBp7xT05PSNtqUgQFS7FEIlQQ75V9dXa45lRcig6uMrPBKFY8rDwaRm5TqA5nnDECnrpfT9BsfyN+9neql14ObB2EmuzeiSSUdVe3k4jxK1cIPU9ldSxQwxIfSI8oUATWbm4FfRLO1kbnCm1aCtz16K/bO3D0ZV0exzXUJ5kyQKPmQov6ots+uG7fGcBdb8mNeYqRWYJccX8hckcdNv+VIPUv229nOraRw7TdcZSS402Eo0ijJPGqypjGME2yCOXLASEzXrvIkJxFXnadem//cTaaCnle04OPobe+NmZztRTRXeXbGgaLh0PB3Rz92REONUy0EOX3RrXzFFSROf6CTX4r7Ckx96Xvdbh83aKI70+FePpCzSrqvSh6wKSfEpBHFYaNp7NG0J7jzcbbjXBScP8pOloHffIX
 A/MsYcO3
 7xJQd/Go/1IClb1h2MdUQJTC9TmV+ktdEa2umMz3uy0eLEIhXwvxhVSRvHWK/TF2JxtOw1Qs+dn7tuMXC+lrvNNu/PgBVKxtw+pIGVZJ0CZ0lwDhWumasNOTYgFQzndjmdkItPEGOPGZTr509C6jQwf1hggw8GfNXJ8ad1OYjs0dSVH1sJdDDuqm3vXE3atUmLaYvrRC6e9r/11+iNy6NJIc74Z1gSV2a9ZEvyMP80RU8M12rS5M/Dyuox2cKWCmqvb56GGESU8wm5tOLyy81DEJuTfRRa7H5jyKB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 8 Sep 2025 21:18:45 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> On Mon,  8 Sep 2025 20:51:41 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > > > Note that the broken commits are merged into 6.17-rc1, but also
> > > > backported to relevant stable kernels.  So this series also need to be
> > > > merged into the stable kernels.  Hence Cc-ing stable@.
> > > 
> > > That's unfortunate, but the about doesn't actually tell us what this
> > > series does.  
> > 
> > Good point.  The issue is that the sample modules can crash if those are
> > enabled at boot time before DAMON is initialized, via kernel command line.
> > 
> > Would you prefer me sending another version of this patch series with an
> > elaborated cover letter?
> 
> Please just send out the appropriate words and I'll paste it in.

Thank you for the guidance, Andrew.  How about below?

"""
First three patches of the patch series "mm/damon: fix misc bugs in DAMON
modules" [1] was trying to fix boot time DAMON sample modules enabling issues.
The issues are the modules can crash if those are enabled before DAMON is
enabled, like using boot time parameter options. The three patches were fixing
the issues by avoiding starting DAMON before the module initialization phase.

However, probably by a mistake during a merge, only half of the change is
merged, and the part for avoiding the starting of DAMON before the module
initialized is missed.  So the problem is not solved and thus the modules can
still crash if enabled before DAMON is initialized.  Fix those by applying the
unmerged parts again.

Note that the broken commits are merged into 6.17-rc1, but also backported to
relevant stable kernels.  So this series also needs to be merged into the
stable kernels.  Hence Cc-ing stable@.
"""


Thanks,
SJ

