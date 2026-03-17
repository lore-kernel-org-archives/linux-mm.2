Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30133FF6E7F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 20:57:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55DD76B0088; Tue, 17 Mar 2026 16:57:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F226B008A; Tue, 17 Mar 2026 16:57:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 424E56B008C; Tue, 17 Mar 2026 16:57:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 310AF6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:57:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D1A151A0330
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:57:35 +0000 (UTC)
X-FDA: 84556766070.22.BA462F6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0963940005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 20:57:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKtLr3D9;
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773781054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=FiD8HzUdwMo8afOfF+yvt8L5cP7ixPnKsNWdU6pAE4Y=;
	b=DM7wJYo3hty+cqt6guk85O3jQFk9Fq2hnmb5ZeyOo3/sA2Gu+LRctAvLLVL+inWqo98O1j
	reqLhYq62DFniCxeL7pik8/24/WKecuOOkH/FSnt+ZNbjQyvtN8F1Las2Z2++fIl7WN2s2
	kvmx5FnXrqXmADbMmaouIP3Fi2p2A2g=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JKtLr3D9;
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773781054; a=rsa-sha256;
	cv=none;
	b=y6Mu2gJ75hhv44COg4aYRTmmAY3nz8vZckFxHo66EoJQVD014riLTN+ZG8bWJCx9r12f8R
	j0eIwVbWKvv5XHz2OhQuIDVQiPinmz72jFG55iRaQAlRY81ZqHMdnMFLYWtNleE8bhxX5Q
	ujMyucZ9LTWUMYZiBTxhyw+AKl36l5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7064960133;
	Tue, 17 Mar 2026 20:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215CAC2BC9E;
	Tue, 17 Mar 2026 20:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773781053;
	bh=guTzA1+naN3igCbO31ky7A4heGg5JVZ1ELhJHmusAks=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=JKtLr3D9wSXIBFWmpNMUlliH+9JqogwmxNQtP2sPI/ePqhIzbgTTVxEBnVwfjaJT5
	 e/fo1FYmH0+DN9lXTOIGTDxcNdTm6POBP8yzeCBmtjcF53wi8ZLI5ylxft120t4f9P
	 nndk4RipFCrZB3QFeukWsC6GPhWNJCitDzoosU9IgKLJVBj85F+ng6h8z5tr9fHZYP
	 dlKcv+2qRc2VaIo+tKF43WeHLWtRDINOw3vE8787IuaI6FuRowgqdn3SKjv7BMSeDo
	 pMSGmV1+anPcdqLO+8Rtja7J/cvOdIrnHNPAeJ5GamaY5WCAy+rkX64MImBMqtJhfd
	 T8t9ni8qpfphg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7D0B83808200;
	Tue, 17 Mar 2026 20:57:26 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
References: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260316121727.54468f0e01ca280c17f2b735@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-16-12-15
X-PR-Tracked-Commit-Id: 182b9b3d8d1d36500f58e4f3dc82b144d6487bdf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8a91ebb337fa68e01339a8c1c411a38d66eac80e
Message-Id: <177378104513.6471.18366680837313261729.pr-tracker-bot@kernel.org>
Date: Tue, 17 Mar 2026 20:57:25 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 0963940005
X-Rspamd-Server: rspam07
X-Stat-Signature: ddyycu7rgo61z4s9ecuit1me4phzopsq
X-Rspam-User: 
X-HE-Tag: 1773781053-259254
X-HE-Meta: U2FsdGVkX189z+WGxAfRhTDycwJCYDYM7g1V/lPb4DLkp27qHGhaAAJd2B1Q9r/jCpVoUjWBNifCAnhqU0T3z6rVDY90Abpc+rNxfpaH2Cbae6lFrapJOf0RYdxg6PVFgKNRnoKNhl+KUaGm7G2SOtM6Yjq7ny5hkx91MHZa5T9mhGi4St/F9gFHIhs1+/IQYWOBReDZDLTOv/fBHmJiufvn+Ij7JVfU94dssVKR74gLhhakRrz/J81GwidX9ffDOjFgg5UamRei6FWK0v8x/awip9g2UZPgJhYjBV2EO/NOWq31zeXAacjBrYL5SdZTPKRIhq4wvNQmqIb0NY8xPyFYXKTwy/fuuCr1e4sjk3NiW1OdYXoXpIzRP8AYCW0XtVoLx/IL29hXiQbD2pPmEc8xbqyz2H614SXi4Yh2haGA+1mw//Bx/wI4c3jAL1qfirVVATPCoYbUMAbZstma47J/9KNIxw70ZKB97Prrx2rwdDmVUvKcjnK52EtpkQCCUi3jaF6nB3bfdxXiIv6oyNfcj1RZKFYr3R64f0Rlv4d8wemujRV0/a6H+0xhVSCpywkeuKRJw/bfbATMzcYbB9NYUe8nKsRzNBhRVtvBrswMkkN7olPuenaKc0HpwzAeV+Xnded7v+pEdzHXtZUUmHu8WvvbNETyrfRJyRCQ2WPvGBTOGctRudo6khZnb/vdGmfVlz8sx1+gZwNsHUV3NL13g3Q1AQuvGrSC7Hehz5P/uAFzKU7eD03kgcRSs2QIEJqw1EJPHjoCU09aKwaANI8zZflIAlD+iJJNNWFlwt7F9mHAfHVmWQncTzikDj63Eq2L2bZwKyAkAy17zK5DC3UHbzDh1VN6WwNIC4M3tCHQ0rDbOIKfscsLLmR4RQOncK+GtCTrL/Z+cny2UauySd8TGGYxaCGmG75APHD4eVWU8Y/bNElirmIFH4ZxXp/hHsKjp9oasJabJMLw7TC
 rokygVbX
 kWKq2q6y+6y9dW+C2wLjT2ulU8FDG6jago9fsXu6O9ZlOPT6G23B8ufmgPHF5YuNVlPJbpORaCpAKdlKCZXxSa7Qh1/cKXxAlV+IRSoYhpMKn6P1eGE2vpa1RXLxNSYx3AhCEmB6KxR01xCBj8RoTPrzqnZfDeE0if9In+i2ROkdWTPy4NNTGQ2VJU1C65nyqtSvoEiskc/fxlcOi5wUjGzwizLQUf6U0gUfdAwBvhISfy8HIGw44il8L20AO9vzSovoGn3w8aIl/9UxF402pDhdXA1cWByACT9BIdDxKRL6PcL/B0DDzoP9Abq6uZ97ZdCcNi8S1rskoK4Uaw7wqszsr0fsVX8XQHBSQ4gDuCvfWwiiOIuSc0wVzcKrKNOvmzTn0clp4AMI4jBU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 16 Mar 2026 12:17:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-03-16-12-15

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8a91ebb337fa68e01339a8c1c411a38d66eac80e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

