Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4138CCD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 18:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C1366B0005; Fri,  1 May 2026 14:43:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6723E6B008A; Fri,  1 May 2026 14:43:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 587F66B008C; Fri,  1 May 2026 14:43:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2C36B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 14:43:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E9C9EA01EF
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:43:32 +0000 (UTC)
X-FDA: 84719724264.29.6850BF1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id EFFA61C000B
	for <linux-mm@kvack.org>; Fri,  1 May 2026 18:43:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OwJP4jJ6;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777661011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=c4AJHoxo6J7vjcP24oOHW2GcO+fqqrTVZUQDb3KaA9U=;
	b=XEhDxOTLMKiKaipfbCJcV61mn28gT7KYWD/29d55CeuwDczFq/nhBqSnUt/UOk52FRBIfJ
	mqT2s3W1/SkY8pW5G89eeuMIfMe+o+eb54/EjyBfvAflZytHYL+S58/4ThOHpjm4Y0kjXN
	QLhp31ET0TyHe46SjAl0Em9IU5SZAaM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777661011; a=rsa-sha256;
	cv=none;
	b=EpidXT/fInflVMy+Tipcxszi/23TefbrKtlBt+x/e+qi0zqEqqQyKR1O5N163E4M76nae2
	1fjZG467bDS/EcvjOiYMRJdlCqiEp4uJJcFyPOtdw4tadOtFpbVPZwf1rJ/Pocg3bHo3JA
	vqhpP2fzXH0qHJkT/LOkXYE6UkRxTyk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OwJP4jJ6;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E1DF343FED;
	Fri,  1 May 2026 18:43:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4696C2BCB4;
	Fri,  1 May 2026 18:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777661009;
	bh=94Oin6CedKLtGQvhO6opbhFX+jLJB3nE7cq5zlxD8N8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=OwJP4jJ6BhBFpMZkXjDDuxXjlbIqLNCJORM+17jjpEJ+xU2uB9JY+8BpF5I9Ep97Q
	 mn3bnlu5Oehjg+OesPv4BCjOEkq7W1ZP245kTNR428EqDQDhdhOfziMiLtNdU9KJsx
	 51mtgMyMX/0S1B1FS4XlfQdJbLSx05VduGjhsqUB9OXbwnnfil3+jWZK+bQL2xrUaM
	 kerscP0g02MvmGqIV+QN/BsHnY5Ofx7M4Jo/qMJQIz5G+4Qw9IdPellSK9vs2pCm+v
	 6xcNza8fYTYW6VlkDfPIr+CxSAeUNNRQSO+a166wWtX7YWftAZ7ZwihOOx8K8nRCLC
	 V+z73P1hjBzlg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 6168A380CEE6;
	Fri,  1 May 2026 18:42:44 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.1-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
References: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260430154158.4739147fd0129804c9e6766a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-30-15-39
X-PR-Tracked-Commit-Id: 99ebc509eef52675ae5bae86aa2a53e15594e4a3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2b4d0215bec0f09bfb872e9a8aa1e1943a42d5e7
Message-Id: <177766096316.3581397.1600456892750829896.pr-tracker-bot@kernel.org>
Date: Fri, 01 May 2026 18:42:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EFFA61C000B
X-Stat-Signature: p4ig678mkjybtqruyymetdcs8medsnqd
X-Rspam-User: 
X-HE-Tag: 1777661010-193685
X-HE-Meta: U2FsdGVkX18pRJfzHYUIM3y7GC7/iBN40pzUwawVqecHr+oVAo26e53ZNrNRz7/dW3gC7XnJxfA1LpLdMDKm2OfYPlEhYIKVWwk6P9eEs0wAgC+lK5dyrFrGGbNM2+bxC0M9+MXHh/igcpwTxQVmudD77l/vf8Y/T1LKwTrcrbwsZZWfl743rEgD95c65JgPldsQfV0TFYntj//XWSPvDLVD2oVrkyTLCVbsuH8JDv4nCSPtBOU0uKybQ0M+j/4LiM1tri9qSwbzK7j7a+mPQHxg69F9jzCYLkjPPRzTKhC/gxWgwhqR6sMaN742L7AMbxZpAPivrJMZ3GBHGrkd1AUwMfrLudKNI6NGdnCD6qyWWbGxpSi+/MQ131MHDnfgdhgJAK25bQ5BDBTv8BPoKyOnvCsEvupL1q/r6E6sToFuQ+E5QPEL1OxoTX5asIKAOYhbIbNc1mWuQXwfqvx2RrVQQs4VYHUf3kTdhwEqxjgwPDQMX7wUepsihY5CEqmMTY8YJSEFA9spBWQYnGgve/7za+6i4d03+j18Vw9V3WariPIjdTjVoY+uBaMDhaXCR0wErDvJy9EjT9tK6XRwScXmIFV5TBiJXNjnWc7y1iF1WHydo/1i4NWfKVW7E+AbuMPm/L9dEplP7XBF8D/2FTuULyAHSA0Tfx0ZRInxe7XzRpgtuclunJ8PxdziqKJIJO5xw3IETvDMPv20s/odvu1GUDvWASeNkGga90voiHQoFs/SsSgiGtp7SbjhQBcTX8EVXX4hv6DPmyFmx2xDQRT9gnxQpAEisl7Zcod4eDB5R/E2iD79NrDD3SOlVSHI1VlZ+Ny2xgObB/kNeGVqq8dhggDK9XMBW4u5+43zswY/I1Dn/GuPSlTR7DnzJb4wf7UmLOsC9EMj7Xq9kCiTooN6cQIt9GRrHO6YFo7V575MMCa3K1k4BXXgzSD4TOjF40Q7AkDVlO4lj/7UheI
 0vjhP0o4
 cCBGvtqHi/PNiVXScEjAU66hB7jyzE1dyZoOrnjxwO7mVm1W2RujxuIxFwDJ1taYu6F7h0V3ESIyR0eHXaM5zh/Uvml8lKvandH9BVS31iP2YXfzJAKpewwJe5+ZvsYw1B+Cm1P8jmFSnVkcXG69o0gjlpcrH4ype5hZ+v2SNwpjfdGey9EqWp/sVsYOazKt3MWdW0fIdZLLL7CvpuB8ChaWs7hmKXICixn9SAH2hsygAyee201LPOKiABDfNri3o9kLcUfrED/22kkvijJZF+lCsAR507D3dNzRbrn1gH3N6vDFp2DCfpMRbQnyHtaJg0acvqtbQ47l7iu1U3klZhwdA/ovu26bVGfOPWX1mYFA2pJWDt/LIGf2fVLcnGm/ZUKgA394DZG442l8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 30 Apr 2026 15:41:58 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-04-30-15-39

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2b4d0215bec0f09bfb872e9a8aa1e1943a42d5e7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

