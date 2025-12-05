Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CB2BD374A6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 22:18:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9019D6B00AE; Fri,  5 Dec 2025 17:18:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88ABD6B00AF; Fri,  5 Dec 2025 17:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1076B00B0; Fri,  5 Dec 2025 17:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 63D956B00AE
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:18:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1538F13A956
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:18:03 +0000 (UTC)
X-FDA: 84186831246.20.4DA3674
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4D65A100002
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 22:18:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KKJDUWnk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764973081; a=rsa-sha256;
	cv=none;
	b=kVXQs9HdNR7GqugnTPp4ezERZFXFRD+ctNvyrAnfR0nfO/bdSJTs9vNgqwj17O0ACvJY6d
	w1jsLTaDTbBpv9Wq5a91yhmgjkHPQR0PljwedOsL7HpUnZJoY7orkdOOt1Jj+1ivdYJKSI
	ERoWiQdS3Fsir9xfaAumojE0/9+ZE94=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KKJDUWnk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764973081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=y63iH8xnsQAn2oq+5mTjKA6/yOTK/UkE0L1kwNDwmAo=;
	b=309R/wjQ41fR4qZ3F/oA3EozQXypwY8Wdbx6MY/iwcnlzGsF7YFfYjF+hvcAXZWruGjJT8
	5dF1TTZaYruH/UbBD95aJtRn3c6mOqXbvI4cM2hBv2V2sgjiJnlxqNPFTfHGTqTg5/U+H0
	G4Fh5UzeyUjcDmDrb5v8G9sOY/9nY6U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A406760010;
	Fri,  5 Dec 2025 22:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E0EC4CEF1;
	Fri,  5 Dec 2025 22:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764973080;
	bh=vZT1N7OzINfGzWrHt/AkN/V/E9PnnBAgULLc6tYB1to=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=KKJDUWnkV+0BrAmG8iaVkXv27AugTFYBBr6nztV+v34qGDUKW6jEF597sRBLAlOJ7
	 PjeO/UeJqAgshM9WebG0HlpNtBBaZY2QPE+qUhLhxJeVpMvMdY2azGnwYtOAWIDUZV
	 okp5Roy72KnzP3QPqaL7ul/DhrXaCMOPYNcoiMbXoYQlbdKu/Q5xP88WDAbbbl+ulJ
	 ZEISnSfQe5iQzewdGiQS+/5I4l9noyecrGSky0+/ViO7S5COrwtvmm2dWoZhflCSHb
	 AiD1RrUnHFCFTLV2j4nvGT5aLUlbkxj2e0q0E21TilXA1rauBvHs30DnZc/0NHT4Ht
	 sEedszSmQEa1Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id F2D0D3AAA0D7;
	Fri,  5 Dec 2025 22:14:58 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
References: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251203212918.82f1c9d3947940aeae263878@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-03-21-26
X-PR-Tracked-Commit-Id: faf3c923523e5c8fc3baaa413d62e913774ae52f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7203ca412fc8e8a0588e9adc0f777d3163f8dff3
Message-Id: <176497289744.1839199.7735679084188935975.pr-tracker-bot@kernel.org>
Date: Fri, 05 Dec 2025 22:14:57 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Queue-Id: 4D65A100002
X-Rspamd-Server: rspam10
X-Stat-Signature: umntubiugfrzzf74khit71dx45fwhcuo
X-HE-Tag: 1764973081-114130
X-HE-Meta: U2FsdGVkX1+sM4XfRk2oQUDt0/tdEHrEXmx2NeRCIoMV3QFWH555kFJQl9IfGlg/VbUa708aIGRTHWfFiKqtEDw9kRM1msOhhSRSoUhnfkYQxHTRII3eIJ2zl3I2unwDIHvJfku2E5J6cwQxUn1ngx5y2hf9iJMbGwqpKfPqSTYrxHcWLhk1oo2rzpWcDQ4eQqXTPGZ2zlnj4yRg93/y/3mZyU12cp4+5VyNnN9jBeas0wd1rbnucpmJY/j/eMOHO59+dJWkbZkLhkMZTKBbrLW777orE6Tcdin2iV8Ig8EMXwLeNVlJnq+p7WHKUAL9CTh3w8MwOhW5DkAmMOrflH4c2CyDQ5G+6+VdVcAB4iz2XdSc53i0zdUKieLMnO6vlSOSG0HODXfyGGGbbMzMHHNpgPbTKcj+NCwIcDDjdqBRzTSSvvVE5H6X/4bRQSicTAs0CrLu+1qzWwiJLT319X/e03VaJKsapZS8h/PCEWjYme7KyJD5RuxzHG0TVP/qjsVotk3bTzx3rARMqSUPJEQt63Mxsx9i4ZjLDGKXeQjX/U7kwyKg3HpXMKXQCN4eOh16cyX+RQcsjpl4KXKq2nNEtZPwEVe8i3IlL1hqyTYRytuYtb5PUrvIQ5PGYQwbBA4O3Lk3cy8PUxMVUz48nIyrgRAhzmleauXIZvv7NVLpMNJuACdFbtE3/dxEBt9KavfxU19ju1fnoGXAHrcFMMO/9YT/w6g3bEOHbqNhufOZEEXyCNGUMb2raI59cbj+dXNS5vynv8OyG49PpEXee7nQv8Phj/cEOD5Mu8l2Sn85s/zQgGxZW+9mB6rjaS7FhmWOVHBt9yN1jKDSbTuk3fMWmfyhRFgi9EYeowIPNOXHAprpAIoQFFCR1p0TWoIQnw+auC3UioVXTnIWwlKYtRGGBIM50QrHav/BBkuOAoJ0OIG6wOToa03mnHOJQYcvy8mW3fgvLOKBCYKVa9U
 AhebvHp7
 SS4uLx3YLTkgZXHHm4CTYz35s54Ilh61kJ+8XirNqQ17Mm+bsPuHIrXFRW+rFF3EeQlBtCg16JhYvoPYFzkq9vt0KRrI2+tQPW2xCU4RIPAAisn5BgxoimiKOThgITx9sPlOuGvmiT3SVZNICPM0xsDyF21u6FkR4xcQYFMrVvClQJ41zzNudevDIfjd0Zvl6P0QERQO1jpj7X2+ZFG1fmqaXLQe48T3cP3ufyv2bhiHbWr7TqgBnBl6AMi24DFDRYxtM0cNUSnkyqYY7Ca3oy72xBL0tDHoekKLEOHqgXz36xoGgQ24wZpsiyeNLL7w2K5sQwM7IF9Hy8vqJBK2sEyrGU8NuPhKhA+vCYVnItUWS9j1ICbus0Ae+7jiKBbVyH49iJXblruZVr4o=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 3 Dec 2025 21:29:18 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-12-03-21-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7203ca412fc8e8a0588e9adc0f777d3163f8dff3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

