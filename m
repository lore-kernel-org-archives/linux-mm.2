Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69F68C44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 20:07:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAA1C6B008C; Mon, 20 Jul 2026 16:07:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0C516B009D; Mon, 20 Jul 2026 16:07:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFB406B00A2; Mon, 20 Jul 2026 16:07:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9F37B6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:07:48 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1E37EA088E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:07:48 +0000 (UTC)
X-FDA: 85010240616.16.2C0AD3F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 497E2180005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:07:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYUrosTh;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784578066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=FSDZOKDITuvHVEfYM0znzNCRh/yzDimb8GlW407ykSE=;
	b=iskPdfYHg2DiNhu/XdQoqZ9NnOgxrNtP8GsDD5JBe7+cJpx1F9yYZh5bMnNNtsGNUqGxKd
	lWjUCE+HbCPoq72tQx2b2C5m4Xp8NeTYlkK/a7KNmPj/HzlqkquPeMl4pA1eXV6Oit9PeX
	08LedMjoy8vdIRh9YL2zxEHLx9ulG20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784578066;
	b=v0tHTbbq5vryESnynKCJkJvS8Qm/4KkIV9oYh/7xoXB2Qnnet8TiV93c0KpwKe3CaMU5Oy
	5b+Gjeod+/xRuepqxUZmqOYLyTMHL9sk4/sc7Nfzo9crONcYyTS38aoxi9tH0xF8SeL1b0
	N/UG5TgoZSS0G8al2qt7Uapy6UQS/aQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LYUrosTh;
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 121214178E;
	Mon, 20 Jul 2026 20:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA3A91F00A3A;
	Mon, 20 Jul 2026 20:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784578065;
	bh=FSDZOKDITuvHVEfYM0znzNCRh/yzDimb8GlW407ykSE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=LYUrosThPhvAlQWDHttVXf0ZgyjsQkE7NRNfHf0Fkty4T+rdxi1R4C1LvgIQvmTNb
	 mXtTCAsB9w6KNNZ9rS1q2cCm3+9zxE2wd6zc9mJxsL/jCnMMlR89uBeWNpZbck6wW7
	 mSHegldDqFxF6qbO9VQpOfo7RMTeHiHBHyNlLw3Hpr5B0Ac2Jd1e0xtsSsK1lUw1Gt
	 jOPMuOKhWq7oMrKKZOzz3tRxWoBBHZYS24mvBOijfnsGV1pj2NDmhA2DTfu1npd5BF
	 k0HA1vF8THJlFTrMifi4QCGvr2xg7F+SY+6t+eaklWlkiiRap3tW7Fhz6FFLBuqoDo
	 jwP6DwyZBo1yQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56BAE39244CA;
	Mon, 20 Jul 2026 20:07:16 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
References: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260720113947.6b43f86cede7f20c4126650b@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-20-11-37
X-PR-Tracked-Commit-Id: e57d6e9e20b551e4910d7a6331a81775c3ad6693
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b95f03f04d475aa6719d15a636ddf32222d55657
Message-Id: <178457803502.4145645.13085712170717969937.pr-tracker-bot@kernel.org>
Date: Mon, 20 Jul 2026 20:07:15 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: t4mhpehrbpp6xbff9adc1j9p3yj9p58z
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 497E2180005
X-HE-Tag: 1784578066-495527
X-HE-Meta: U2FsdGVkX19W0czFCBMxQJNUfvaF24YsLMvcinicaadCWX5jSUv3sGaT0tvugI6/C3OSR3QVrEeFigFnrX5wbdmha6bp2MKwBGYPV3XuESIebl/K3sPXivcIsnQ6eKZTX6rV7pLkWvUp6tftzZRV9bbUifnzBBXWwhHrQdxT9fdtyCigFxBU+L7kW1UNujnde1S5iQ8w59Cmlvi0JBO37hZMkO3EWnECJslb3CmaEE0XtkBfcUGC2UDLSfLXHy6zVgY45kkj5RlSPGJTHQ9Wu6GQ0G5/cCDn6a2tE0Eq9OdrKJ3ZHrTK5ohfhOmSb/Ms7rZkE/SopeK7uVVOim2GbZCSxB99oKOz3R8CujWvLI70CsA47dPLvBF7g16gjoJ1TJ6EyOYV7ybT2mEVQ/TnyetDs3GPz8NfjpEiSmtt0XBeHZVHWnX/yy+Za0BVW0lPYQ0E7r/upB/rWJSekFnQowUR30uMYrEpyKPX05XydJyn1O6zIhe959rNm7QkXncm7hi40zCorHf4U7xxCIo+t83rWA3ZBvmV0ZG26T8AB6fqsa7mQpZAb7Zbk/sDCtmBxea0jdc/epxaBR/OUS5z0BtcrYlwXi/SuSzHb4/u8QjvbWNT3YQA0ozda+3N5Cbbc2Vp1Zo0cDGolWcx1VjwlMcZslwamhOKxttWl72oyLsyIZetFTaCteQK9PzwcbXUeLVLFJBPXBAk99+HOruhPq/DCTNCBrVFQLXN/9ziBXnSnv4Y+YGO/NEN2AUu0qKskw2TaBDcCD6Fbw5KKPl2WawRzxU5mLDZAjSaphSMUYbrXT7EIxsPobpp9u0TryXmOVT0ncEpN8/eAJZmTKgHSX18C/LJLNYoiUxole50HEPlZSf+e0gvz1132b9zcrcUiZGinXEev+koNbNoEg+ntZZbpn9220ZMCgKMbxeGFeZ2TpmBl1ta8rqjeugaBYWorMc5nBK9vcBaEXAXpJN
 3qZk2BR4
 5QIHy18Dgc1Fe/wMCwCZZFq7/8xN4BylC3sDrv8BGjYJv07tvtvf7aC+6ebnh0zxLuFEHsOc8re1+HTpl6YmBRPZbWLtOi+Icz9eu3nxPPYVV73IpdPunSZut36Xnpq5MQoGAcu2uvNtwU6jHZUtIRPc9YGY/+BDFJ4iBrv1F26bMcCjHLw+yu9vn8fjH4JMjNJdUwWL0sv8+l367AOeXU5tbBJ4hvtCniI/6uxJmTB5JrbRKkqFn0Z2ldsXxteaLVZdAyfEYx/ft+ugHQQe0OT2qpcgDGLZOFhdd95BdGxULhcsE9AiWA/INQG1Tg2evYRPU+cS6Ky7qu+FTOAXb4WaREo8MVUvNEX8QiWz4W60Co/urtpPNHxEog+txvjbK0TAwwWwJXhQ1P4RjAJCeHRF0IftmTUFbFMeb6YW3iJ6RHnmO7/MZsVLjBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 20 Jul 2026 11:39:47 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-20-11-37

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b95f03f04d475aa6719d15a636ddf32222d55657

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

