Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62A6F606A32E
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 18:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Ua++PlLt
Received: by kanga.kvack.org (Postfix)
	id 8C3836B05B2; Sun, 15 Nov 2026 13:35:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84D406B05B3; Sun, 15 Nov 2026 13:35:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 762F06B05B4; Sun, 15 Nov 2026 13:35:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 57E836B05B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:35:46 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3B3B12045F
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:35:45 +0000 (UTC)
X-FDA: 85438207050.25.A19593D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id F362640004
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:35:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ua++PlLt;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794767744;
	b=SEISymS9o2gX9VdwUFnRkaOM6dIAW8KNSBgWP0dkmQqzHNarR9pjLJsdMvT5pXM+nOG6RK
	Htv+oocyF3c7Ms0dZ3VGGShwNnVPX2RVrwl05XwAFScAeFbdH+mAG7nU5P507EYtlWg4Br
	3z5OG06VG9c4Uu5FXEJfEAS09cDKoZc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ua++PlLt;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794767744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=BQvSITIRJIq/LrCuYDWL3zvl98iDwr6EHjhrxtx22pw=;
	b=epieNz2I5VdYhJJeYRJuokDdQe6P8tbsVwsZWhsDyX38EUwrJD8Ij2TzcBubpbCuaAvdAZ
	t+8aYMBrLiQTvN7BPRfjgFvPiSbCmWw01o3W9kFGk/vXBPb6dlNsxkY6OG4m1ipi8Q2t5i
	Ks6C8WAKNt11HYRRBDLzLhj8R3RbOgc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EE5060DB0;
	Sun, 15 Nov 2026 18:35:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 452A71F000C4;
	Sun, 15 Nov 2026 18:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794767743;
	bh=BQvSITIRJIq/LrCuYDWL3zvl98iDwr6EHjhrxtx22pw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Ua++PlLtLWLZp1cN9wx76saG2RJjl0oPwiOJJj65PqGTgHhAYxz1lfxb4fLbzCxwC
	 ZNk6HTvSU60a8fxZp/F/4BxgrNhNiLCT9HUpVGQXL98h/g86twvKIE/t8z4823WWwE
	 M5y5cJg7cZngWUUunoolUKaatPUBelwpRgOdgKfucyR6s58DnFkZgxYYOw5xWwd+sX
	 VWlvcYigvzcPS6jI9re1Ar1xtDV/jq/qk8y/VIBtI76jSYiwd+4dej6h17e9VvA/5t
	 CazCqm0UD9/+zFBsZ2H1MCn2G7n7w3pIITYfkGdsy7Tda8e4x/K5Xntipbz7a2Fc8a
	 Gsg2F0NPK+ruA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3A225380822F;
	Sun, 15 Nov 2026 18:35:43 +0000 (UTC)
Subject: Re: [GIT PULL] liveupdate: fixes for 7.4-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261115050300.1847760-1-rppt@kernel.org>
References: <20261115050300.1847760-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261115050300.1847760-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/fixes-2026-11-15
X-PR-Tracked-Commit-Id: 58c5852ca96c58cdfdb9646870b217fc54d06a97
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 04da1a14b9eae1dbc2ccc007b54f46771f9cb529
Message-Id: <179476774173.2691368.12556780418749677537.pr-tracker-bot@kernel.org>
Date: Sun, 15 Nov 2026 18:35:41 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Stat-Signature: 8c5rhhjzwdouu64yrowwewca6aexat8g
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F362640004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794767743-226236
X-HE-Meta: U2FsdGVkX19v9OgpumNB7njxDbRLvBjeGPBK2bIYqsQ2rstZEFS7TOtv6d43QmJXjO+6vVDKbOUgxLRgZvOgTW35aixGFn5AJdVucJOGHLzszfuSYorTFydmPAWyxzVl2jQo7dkEXoZjw3wZ2THy8fls+HrCQlJCRgUsEjzTyqDyu+GcQL2GIHDuPVa9ATasp00OZiueX86q41but2L+YSsy66NgixfyegjIcvw3zBcqeZhxN9N5uxpQC698CBQ8Be7Uf8z/tuT4X6LLlYry2XWPj5OWlIvJ/iyalDfpn97oxr8ypnWm6UhgfnsIeLUCB62NOmyhigHUr0P/P/gbmvM3aoXrMxZ4mMuR8gRzJ+1ddHSMPg5XlDXFHeSphwwMcnCPO1m6xc/2X62MRgZy9QYlFZItvPkzqPbsFT4xPataryXqsC6IeU6HDNIQa/J0QD+D+IfOqioZH3SAxk2GTWwub3ISd/CWSpNQEr/MpUo4JT4GSFI1YUdj/v2rY/Kfm7BrvoptWhujPe6f7Jv/61fUd2/f9PcsFIX0Rrmffub4uAfCnX2tqmEybR6LEFeGhzYF8DZ/RkysfKENPOA5D94tOdjDeL+7gcqSWAss64//m0k5ICN3TUTbzHrmEo9EAw3wlWZdBqC54aA/fOkCl7hPDVsTQc3pq1F292HMXxjk39bpLF4OmDp8YMgqAQMklded/VRpeLz1MGDU5gnG15uc7bWeXCk4A5Q+mx33s/ZyQydmSFyfHF0B591ikPJgCMpJod52ETxkhwqbeNHMREzPo4xaTmDqHx9iau8ddQZnrRirtKiB3iPXKp+xGYkQlSI8XV3o3D/EWIjNkP2zSN3JEYXB4ciSMZlQ6YmeKuqs915zw5zbBxvV0k4TMWhUG9GdqJHbQOUMsyWtnMCexyaN7bEkRtvd3ez1JWJfpq5Nkwmp/R0tz64tn1frjXsCpl8hvI9icGQVb/jh56m
 z3hwRCha
 s4VrxsUvEMZadN0rZU7VxoU2Mx2C679xA495UclQjGIbyoV/CHUyJmZmnRA356fEEHFbBma355S47au//xPxCLpw3I4iftN/pziEhpFUo/XDFDn1kSrWOSAFBNNlXUA4X1sC6pZvIu/vHpRhnuvg21lZTuXkpA2ljfsVQS5LaXkmXZZuueagtHE3c30sVE+BOKJ92W3cZkyn8IBl6MyCEqGnIFh3ZFYwyFN7ASLuncUl7St8Fl+HlyjgJ85IuZR4lIROparrDpv2HL4VIqRta1eCb/dMZSpObYM2buY7w41ZkdLZ6X9F8vZQFKiNBogg4qjJikeekTfMvv1/6lJi/c1maof4GdY0ATO3XHyDpMEZjU+Jr7WhDt/MEUt7Ep3CkoFXaYzO7COsGUgwiHfZe8WJ9kzdeKN0WIqeGWAx9h2D8HzmhEkqJJw+3kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Sun, 15 Nov 2026 07:02:58 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/fixes-2026-11-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/04da1a14b9eae1dbc2ccc007b54f46771f9cb529

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

