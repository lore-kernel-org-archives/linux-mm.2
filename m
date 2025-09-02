Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4EFBCA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 20:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1738E000C; Tue,  2 Sep 2025 16:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12B6C8E0001; Tue,  2 Sep 2025 16:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 019A18E000C; Tue,  2 Sep 2025 16:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DED138E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 16:42:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9B65AB904E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:42:41 +0000 (UTC)
X-FDA: 83845483722.10.CF4E853
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 057D3A000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 20:42:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p29jjoBA;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756845760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=3J13W0+++PmFhUmM2bCNAWMxvrYYD5cPtk8en/ovnvA=;
	b=GjVerSIwnxrSYYtwEW7nn7ztwg0+Dbx1ovf0ZUQQ8Ha6m2pM4dueeOpMEoQq2tQ4yLZrmR
	KLHTUcPIu5u2JstRL7K9CSuujEucBKL3soIn6O2DUGqOFTIpeYcAMZr2maxfori/A2LEs3
	2kp+3XaIcgQQXaNMjB+nEk6o8mPKwN4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p29jjoBA;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756845760; a=rsa-sha256;
	cv=none;
	b=q9T1alJoR99LEailk8CNPaondiMVxVO0ZbiQ4acCkVnYX2mgiBe9OWrBJoVu32044zi6et
	sDY3a0TvaLbqm3xMt4vdLXD5tXSVXJj5HmDvN8RihQMe+W5SwNQ5EXo+8SVkCItULV8HLc
	FzmzaBkdZOB8mepqbE2ebaDlERuBznc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20EFE600AA;
	Tue,  2 Sep 2025 20:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC493C4CEED;
	Tue,  2 Sep 2025 20:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756845758;
	bh=EY3Ros8ui1AxqpqZefjCgk4LjTsOIk6qAWtxKeex6fU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=p29jjoBAJe6T0O7UThks1cmcjI8SwiFvWaxZKkHmZDYW+zegGZ+hP7E1ddt6qE5Mf
	 cTWXmxdr2FFrkYBwpp0gY0ofH3mAgU6Awrm56ogJI/LhYXeFNSwdUg5H22EFX0UcLV
	 XpkohuD27GjAgrQLodQ+hyo6F+1x8RZ0HqAhPzmyYUe1UuV/bBs6i+gDr8nscdXlSn
	 9otq/HIICPl47kenbfXhrMXtj1n/aYYoUDeag+sTGpfSFjtI3Y3oTdd2wJ1Exyb776
	 7LgKNtE7pKL105d+816ek+fl35NjgiCLIufI5Zo65vE7/S59HUgTGZAjAtqnxf+BB5
	 ZoooU9lR3s5pQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 7146E383BF64;
	Tue,  2 Sep 2025 20:42:45 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250901172234.3a74524a97b595a5a81d1697@linux-foundation.org>
References: <20250901172234.3a74524a97b595a5a81d1697@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250901172234.3a74524a97b595a5a81d1697@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-01-17-20
X-PR-Tracked-Commit-Id: c873ccbb2f8db46ad9b4a989ea924b6d8f19abf1
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8026aed072e1221f0a61e5acc48c64546341bd4d
Message-Id: <175684576405.430647.5772922228170674151.pr-tracker-bot@kernel.org>
Date: Tue, 02 Sep 2025 20:42:44 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 057D3A000E
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: aju1db737zdq5aets3uzcqnish8pb1gn
X-HE-Tag: 1756845759-575530
X-HE-Meta: U2FsdGVkX1/gf99GFWzvLMbkt0w+5ubRg6s+KNVZcS1oDLTFWVj1dnDqL7GpqJIwnqOLPvb25RF3Xv63QfSHWB4WXxiCArRJAkIjD+kcOy9JWJ103c0HiG4QLD7lt2Kjd9PfrvQB/9d4Ai5JYtJO9CJ00AJaG4+QskFbKhE3ciV0tSOk6TiYzCvQIvSz8Fqwd4NLhjVDEHCUNJtdol5wrfIs1qWvwKe/3RmgZj6EsmjzuLcEPBMX/Z8sZIhjHX/K8O6599+NU+x+gPh3Io4FFGoLeLYreQTmAnLPvlWcfWmy2OkncA4ULqeY3A+HNd7/ufvjoB/f+bBhK7vqo5T2j7HTTIPPeWxSf/Ha1dQ8awIXCtznvO8dyLw6PVAm3DTtP7+iBh80BcQ8kdUWJRoAbnMMkj5QAFqSdpmx7hAkQbWZe4VwzMARHjLfePES+GagnV3H4dG5/ZMkMrkWd3OjWGEf3G6nDRqpaSpzk6DCtRNcamwxan3HpkcqYMW0Za4jC75ZA1rq6wx1Dc1dzUHBS+WrxwcApPH2h0vfu5irgMK8gohFLSvbSeS33BGGtlHstJu3UiEUxwgiHNPakA6+DiwW5R6fRr8G4Xj4lxe6U4yxwQWo4CUrfJolZCukT7rTUwCdsPg8ULxDrrNECp1IjNfPuGAd1hS1CwsL65cbhAezd2FxZFAWa4Q2Wtt9emW1nT0d9BevVpSLkA1HaiOU+30wr/QkKklMvgZXHgyiH9G0quVzDdLhrfd+GdAJvUNvVJBkZPuLwdZBBaaKrvyfVpQqBmRawxFCsu50gcAzTSsTkX3oa0F5Z6ysywAsq/oU8ZeoZpSHF4cBaFvj2OXW8jIXY54LoXLGsn8ER4JQChUdVQ2yKgwZWsncsqnMooiLr0wFkb3OjmFA355PGJJ0tUXJXpyU7DjWfQP70wtwQwPxvwW9KC4IoYwkSqEJ7Dd3ab4bonm0GE5gzb/yXwL
 BJs+5Rph
 rit04qwag5IoyOPQ+lpDnS+/Pme6aIE/I7WqNl2ijZT47uix0JiKg1oQYYlNzpXNZkDdD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 1 Sep 2025 17:22:34 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-01-17-20

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8026aed072e1221f0a61e5acc48c64546341bd4d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

