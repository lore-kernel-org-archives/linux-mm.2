Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9273606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 23:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nFlEGBr3
Received: by kanga.kvack.org (Postfix)
	id BCFD96B0B31; Wed, 25 Nov 2026 18:31:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA7186B0B33; Wed, 25 Nov 2026 18:31:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABDC96B0B34; Wed, 25 Nov 2026 18:31:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85A6E6B0B31
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 18:31:16 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 326721C4538
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:31:15 +0000 (UTC)
X-FDA: 85475239710.25.2F68820
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 5D34A1C0016
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 23:31:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFlEGBr3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795649473;
	b=gZ1v5D/Pf6rPACnM24AuE8QfAbSZSeotyr3EJ1gtlBvI2DgliHuquYfxIE287OmhrI709z
	dxODuNbebRj6ukJNNCLxkzOuaJ39L2jdTuvK1ZPYwgHPEp5j7ExJwwBSsKoVcuXAnESwNr
	HcebZvfjN9MELFxnKaSGAxp8UJWGvfE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795649473;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=IaQ8G7FsZ0ue/JnonyL9MzaOsIPjfxBpTMXEtTIO4eM=;
	b=pITkIWU0qZt0zBs+hxYUCd9tlY2X4fph5FViSB7LeMXTBrEsEK7tV3Jo5L6z1eSjelp8I1
	u3qS8n5bESOv5e+hBcOutQm8JPv8tXY6NM6SyWmlVD+LKey3Z2na/vSFyamqpHjqvAanjb
	lpqGbJGTUHoC2jvXA+9aeXMuuAYNnKg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nFlEGBr3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D90B26350C;
	Wed, 25 Nov 2026 23:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896A61F000CF;
	Wed, 25 Nov 2026 23:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795649472;
	bh=IaQ8G7FsZ0ue/JnonyL9MzaOsIPjfxBpTMXEtTIO4eM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=nFlEGBr3DuFs0gttzSMUwUrwo0VdEDEAH4Lwp/lblcB1ELqPskzCFSaoBcKHQ+VhY
	 tVQbDZ/RREyJenVJAGV+IYXDJDYdMKTG2H2BKsRnQdUpc53CcHB1OhI5ubpm5GTMW9
	 GQURxM2/UEE2s9xTTpA4WLK9bZ0N+B7ML19O3uymOO8yHsvpLWTsY+Mmq+ob8+qjzY
	 qgrNsTrsF18Gb6m1hZKAADv2x3Fx2I6mhLNdTj0vPt2ScL84DJlE4ZxEGSKGYbiK4I
	 p7Mx+Heq8KdTclXd63wjHXQEemH3O921guuo9QCGHzyzjkXsAe6hMke1q4kR8J5KzY
	 GarDrwnscPXKg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7772C3809A29;
	Wed, 25 Nov 2026 23:31:12 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.4-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
References: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261124224409.56e65d8ff1f72a1d485450ad@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-24-22-39
X-PR-Tracked-Commit-Id: 448293c44d86abaff45d6f6919e6056ad97eaa31
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: b312ada03437d5874a8dbac6b4a1d479c2af3da9
Message-Id: <179564947119.1391833.9076043211055122022.pr-tracker-bot@kernel.org>
Date: Wed, 25 Nov 2026 23:31:11 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
X-Rspamd-Queue-Id: 5D34A1C0016
X-Stat-Signature: e935c5arqanfhd8imzzsej1hgkhbipwk
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-HE-Tag: 1795649473-624329
X-HE-Meta: U2FsdGVkX19ep2ubnnLdhwzO/jLwYa5YI6w++qiYGUA7aMIyMVJD4jD1A2e6YbLHDZC47PITpm3RM7B3/VVHM6Z8K7kyImlywOO0gJ2/76qaN91w2OOt9pdQznoOUD3nUqn3DgW6F3Cn16zd/zequ4jcrMSP7eIFCSYHjjLeP2QpONVNYVkcNZ2El8VJ7Wsjvcs0Axi8lzu7jEyoCYjDtqH+++c4Kip0nZloHcXFO3GL+Wn/tJ+9yoaUPGJS0MhO6gu3czZMdjvz4IEW4luRjNx4AJchKbkpl1tGBYsKzTF2BcLq9PZm6Fp1U3FKV7209+vGGv+pb1AR6jv5bR0To+7J+pIV7g2uewyIQFMYsY4JeI+nYhDrG5WFy30agJJMQl9EHvuXEUuqZOnfK3BE9Hu71euSCe4sfzEgTjLJYg4CXIgRQ/Yho4r77YrdAEdhyZhiGbxTNEQJ8kuleGjnnwy02mXuAYAWpB+TF1Xi0cYdrQBZeIGUUUcDVEi8ULO/uHmc2KUBWAuoum90Ecfdfa3ZfWbtN8MJT+0g5dosEK/odwKQIc0kNoEnLAdBervNQ9qG2f62ILtI9QmMuHJdHPFv/rg9QG4Fqy+URGEEsOeVgP6ZalRTHC48rFUjPqWu+nK0OAyI++BCP9mJoB3urIkrBLmJikX4Zf1uVm/7WgCSuJwfgd+3urhy/WqYeArg1Z/Xcvx7MDplwL9FtPbNJP8eFPaEt5mFX6hh4gQezQ0DEQm6VLcVJkk8Y0STy0102GyON6+rjtGJL6emCE43uQ9d3n2L+hcON34Lfq0oPMS8mAwjYCYp6I0oklQtbgeqjcr4stvwAQJ0THiDUrv0mWcIJZcqHI1RCM6dkj6qhxOfoAgs2h7BxXEKqyg4JWFD3k2OnEtE69ElxXe+I2M39PYgLH2hygRcWy6YwTRyUhrKs8XFCZRpPcBzkpl1E+/O+FTDfymgt2lJWcpA0Xp
 u4bVwiyl
 vb0A7+ml0NR/2YEkQS5xPpAw650g/f8kBxywHemZS4+v3AaLtkXWnNtYY3D2WIaPuG4U/EqCqKINnuDLiJWqxylPxInnBCiRGRK+wxZu1x63tgLUIEvt6XR96+UL5dSlV9ab1tLVEpz5b3Ilu8ViqtPGt9vqG+TeqjphFHMfcmFQIhKmAgtuwl9kQLnvFgYy5D+3lD6uCO1yTYCAultRuOEwzZmFD5R47jyv5ZlYGOIGIhMAQhdThVb2ALPAFuqstIPcQyJVMw3FJz8gXMu3ytgWKX6wuklA+X+Gdo4wLlvvK9Tg58yt+F0H4YVz+ptXNdnRe8du2xZrT27IisBeoaHF48tKlRK390/QWqMdsrskkWHRH/7muKdKVtVygV/SIf0AUS7wHP98OyXhg6tzESf2EyLYT7TLIFJbbJHKUNZwAjFg+w3K3dCK4L5owtjlvAkdx2RTPcWMayKKLT/el6/HphS+iv2LKa5sTogdmi4hsIb6Xmv25OtHUBSn4mRuZ0V4H1demHJabf9LcYyE4SHVHX2ftMSfGw0QSELRddzDlNYdFc+oBbokHyAPYuFRPf/d3bVoihgcb0jnssNsDYBmzxh36+P7w+4jWnxC+qh0tHlJHVsDmI6XuEUAIboaP/MzQ+QyAwJBBudrvT7n+uoihwCheah/+ob6vEQewki179SE/Ekx44kDOleozt+yXEDk56kmmBpqjcrE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Tue, 24 Nov 2026 22:44:09 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-24-22-39

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/b312ada03437d5874a8dbac6b4a1d479c2af3da9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

