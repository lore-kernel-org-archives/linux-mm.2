Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F86D606A32D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 18:35:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J0Wksski
Received: by kanga.kvack.org (Postfix)
	id 604A16B05B1; Sun, 15 Nov 2026 13:35:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B4FE6B05B2; Sun, 15 Nov 2026 13:35:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CBA96B05B3; Sun, 15 Nov 2026 13:35:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25D156B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:35:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A8B26A07D2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:35:43 +0000 (UTC)
X-FDA: 85438206966.09.64A7670
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id DA8B280002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 18:35:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0Wksski;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794767742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=aXEWzZe6OnLHlf8VjTALCLu1A7VUqMKhDTtQNvf/NyI=;
	b=z4e2mJcXZDvP/RD0F5S2hjI6fjursxp4qQsVVPUOHCRd6Nb+mEY+dBnT9VNhww1rGz3aWB
	C644gwR1kiLnkODzBvVANzRdfv+jpyf82WBIxuFCu6j+1rSqvtt2wTSkyGoiZU94aEfzMW
	xbZC9G3uu627MO+sDJA11RYOnN1QMx0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794767742;
	b=BgfPdf5VYFHBWONF2MiYqbar/1cC/Sl+otPH1Bq3Rkz67oLQNu11qpFjwp9JrxQsz9JzSy
	L+3AuXcDeaSkZTkHuWiuwMNVSrHkUldDLoIgNdjJjr1Dgb4sLLYw4PymFiyfMA9Rk/c0l5
	gWdWc5K4GZB1amuUJUqN4ZsUg63In+4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0Wksski;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5087560DB0;
	Sun, 15 Nov 2026 18:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0747D1F000C4;
	Sun, 15 Nov 2026 18:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794767741;
	bh=aXEWzZe6OnLHlf8VjTALCLu1A7VUqMKhDTtQNvf/NyI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=J0WksskipE3SIqYo2ZaZlSFptKQyfDLSaxMBWtQB2BDDpOwM3QS/f8sYTSmqxOSJx
	 55JO2lKP8Aqkbvwc1IHYuUc2iY7iXYD5KfYzLG0VeFXFulMsWIYQSJpsw9pvNqy5zl
	 Dxb+hPQh6yYdsVDAoX/KNma1YM/UMauGLBFhQg8mqSRleWBB4h2QcJY4PdiHwTzKzA
	 z5C3aZJKk7CBZkhDwKWqL0DmGFZJYqXzma1zmsrsU21nYAG5ItIto/kVK644f50nqh
	 njVzCjlunow76K8ZBW9e+kywlpbf+6qvzNnLmCoxevG/yl3GfRkt3Xc0JAk09m4HEB
	 snco3NI2X3lSw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F16F1380822F;
	Sun, 15 Nov 2026 18:35:40 +0000 (UTC)
Subject: Re: [GIT PULL] kexec: MAINTAINERS update
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261115050200.1847508-1-rppt@kernel.org>
References: <20261115050200.1847508-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261115050200.1847508-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/kexec-fixes-2026-11-15
X-PR-Tracked-Commit-Id: ab75132e99eb0b7dcd3a1882e35519f8229a669e
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bfac855a820c3a32219779e4fb44804e8f81977d
Message-Id: <179476773966.2691368.5009607276514482536.pr-tracker-bot@kernel.org>
Date: Sun, 15 Nov 2026 18:35:39 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Stat-Signature: dfesryh5qbj3wozccxh7bibfx3jmz6ww
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DA8B280002
X-HE-Tag: 1794767741-243124
X-HE-Meta: U2FsdGVkX192h0L/SpwZo0lhR/ZjxAzEUZ5kE/Rgde0wxyz68dA+Xot4Q35K6ashgfEB52Or31qyn+hxXKi9UD5V5c0iy1clBJakEd33VWnCmkdbiI0lvPJGs7UJzW+KIENcQYNKIvuRPcQL6a6ULkUGFKlmO649wr7XxF2FYaYK9Q1WDPQaJlSyT2aT1aYeF/0QycnQy/7PP1mdRfCQOGfo1qWDcAP0T7/dyULfzpWQg+nw4PZfH14VZ5U7Rs5Mg1z6GolfObvCZgFCa7fE8UB9SGufLvz+Y49dFAJ2a7aM+VVdtnEu8J1iywYwq95lOs3aO71Dc8wlxX2vCnjkuagl+4iROaRD36Bg4ao0bL/uO/velZ0xlXVbBY5asiNSPYpZLrzrYCBKnxSU7NtmsnLuGwwofPyoJgPAiylTO2Z9TBvkjZcCKJQxnky1KU/dajp4yYk8g6kJKPruRW1+SSJ4wX5jkL9Bdtb5jd26d2F+9H2B+a1SRSdXTZiodna7QqdVIL1n44NlYbsiLqFHeR/gC2mysGMBhmJSl4oWYAGXB4isXwC299Pg+BGQWcYXsRqEORhGwFUtm/ggVcsvfBplH0jOhUQutf+1TajJvMhuk7Wm1Ov/q7fIOp0R9jw0vgtgq+hq3KtUSZAdR86M3YwBzaFwT1gmoIcPvqofJbgO6zEtq6FZdlhG/otL7jbB9+O7cSAMN0PDaB3b1wcmmXdoBeDxsuao+TXYgDo0O0ZP5iUk54ojN9EvN/etB8qVFA5vWmpaw2shprxEFf4Kp+wbc0mz1qmeV8qt+uek8c9y/IfgskrFQGxBsB9Sa/rUi4+wLdQ3khNhpibrQxJpCgFqkY1q01of7bxWyHjGqPZam0Nm1WtTe7gQ2jhJMETaQPsuaG4ZzWVFJDs3ci6dknrA1bCBO46MN9Pyr/q/3Y7sRqqGH4B5RIxfbQ9264Bsk9HorKORsp0Y6VtoOqW
 mObO2f+S
 exB2UGg+uNgRWx2Ps+EZdmJ86WKZKq3oMsd+1dTCB068RdctWtGP6OFYABCQn1Ej+WB5tQGxSCnGwIU4ZiO6bgtxfcxppFLsikM+EwJhfCOWvAoFbFvTLtoIMB13uw0l+ShYqkyTxzb0Vo7DtNtsPnBNlddrYGsb684N7jEIA/EljSZTeCoHHEaJ3ACr8TmcC/lNcMfnzy0Rb6CMVxoSAZaRS0TdzDhBzkaydNhXKrbkJtwoc/rpGe65g/naQjjzitTqpAEWyvL4D8rFG3u8SYGBb7PDcBpHXTS48FaS/Jv73aPo8/xRDPyVLGEGAgYKi52bdF6aCIRAVda7fEez1aQiJ72Rpspj/sMzSsszb/kXWmXUWQn5EM59MI1H6o9pYNBGYtk2oOeB3UgPt/r/sAn/0Paj6NlDtDlON8wTg5dYwtWPSD47VKC5WQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Sun, 15 Nov 2026 07:01:59 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/kexec-fixes-2026-11-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bfac855a820c3a32219779e4fb44804e8f81977d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

