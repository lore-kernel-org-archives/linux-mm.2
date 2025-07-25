Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99434C87FCC
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 02:49:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 202A06B0089; Thu, 24 Jul 2025 22:49:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B39C6B008A; Thu, 24 Jul 2025 22:49:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C9EE6B008C; Thu, 24 Jul 2025 22:49:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EEA8A6B0089
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 22:49:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49D51B9A3F
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:49:52 +0000 (UTC)
X-FDA: 83701257024.15.BD0BF40
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf09.hostedemail.com (Postfix) with ESMTP id 72EC6140007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 02:49:50 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="olzSoiu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753411790; a=rsa-sha256;
	cv=none;
	b=fbLA7LOo4Zi7guTf6hdLiZD/lWKQQtfsflKGia8ytzifbQ1H4ddCbN97XFLTi8oYDa/3Yz
	VK3YtJh4cl9GQowVTT7zj1KAF9WKsXC7N/HMYcTBajuABqXtDvNa86zommu7/hOEsFe94x
	eyQB5tkm5/hWI87IS1nQ4SjdZGAkFC8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="olzSoiu/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753411790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=GtDM0BqjnbZ+gI3uheyzp4B091BhdpKCFxD9k36NAC4=;
	b=Emizyx8Env8I4AfxPWa0YyOpc1+zVsF/3BjSn/SmAxWSjuhFkjsp/mfIPTpfR3ywzyzQfM
	GWzbQNxyztL3DN53ah7+qrmMW3tfdtJCCY3+NIJ0+nhWbfBT3Bik65yfHi4i4vwq8fBoBX
	DlvFSNvpbafjOvCfAtTll5My2Sxy+gM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id CA83AA52B3D;
	Fri, 25 Jul 2025 02:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7963EC4CEED;
	Fri, 25 Jul 2025 02:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753411789;
	bh=qUCSrAgl+i6cCOtcKNxDQMp0yHB2JDvPJZobt3f40XA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=olzSoiu/cgwUrcS6qR4oFnQAaMPu1oi7AKpl9XFOquxrYPnxzSVDJCZnUcijUc4hu
	 TPStRmwMT6QHqI7zXjIH1vsPuIL9NtF9F5HaKW6chvU1SGezRisUyYPrSH0kMu6ztP
	 5Dj2bhtXaLV0Z0f6MmKcQbFw6hDQ9dKir72n6caMjAPfjf7dMqLc/NaJsSOz+Dfjgd
	 6B70B7j9WwL8INmN5gv0yXwOrBwVkxxuN3ptHf54m/FJSyBUSFGuMt3yq8fw1TrPme
	 cZMZCscGUbFhD44uiiXSJhz1fkp7hzAjr5OQG/sPZma701XOG49p7FZYTf3WHPsgxj
	 DRf4PrRIzqFZA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3907C383BF4E;
	Fri, 25 Jul 2025 02:50:08 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.16
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
References: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250724180503.a8a80b0b0c904c1c7f967448@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-24-18-03
X-PR-Tracked-Commit-Id: 0dec7201788b9152f06321d0dab46eed93834cda
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2942242dde896ea8544f321617c86f941899c544
Message-Id: <175341180659.2616960.3118846587587977860.pr-tracker-bot@kernel.org>
Date: Fri, 25 Jul 2025 02:50:06 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 72EC6140007
X-Stat-Signature: cp5amyq14moi9dcjgt1w3s5g7fmf3zow
X-Rspam-User: 
X-HE-Tag: 1753411790-370840
X-HE-Meta: U2FsdGVkX1/OmpDYikC3L01qzkqkOYgyD7hshh3dUsqoYMvCZ5Gmz9ipBPk9qhI0qmmzJb7/t6xYWldbUc6ew5GZ5mdkPrdzxTirgvAaxSE3eymEc6TpEDMsyIzBcZzBXIy77M3mq8d8h1SwtvyeyCd3rz74PjJCo/oE4DZTYxITeo7fWM/7POo3aehiiaH7gQk1RFpnIzMBTfcZuq2PwArdox5E7+8lnUXoTaNGPmqLyQvYzuZAjag8Q0/rBrrgcur0pp1lqRHs3TEIcrXgILARzZwV4XhdhqSN2ve0qrDFUDBWVy2hvFpgCxTbG1Rg6AyrcecgHZTbshIkZRtZKL1LlKx/RYBZedE4MeFuwhuynOE21TrFRxblWQVO1a8CnnVVAwUHfgBwyr8GXYhY0YqskjCU8OsYtWbmruEaZumOmbxxzx3040rCnRgWsQafgp/JmYCf3g9TAcXjqbTajv/uHM9qzgFMv9ZODUbu/Qh0lStIywaN/8ThTGya0Y9hTcmhk809RFwTF2yy0CyIfBFSFavUIE4x0hUWUsruEJmU+gTlOj20zoCkri8MvpLKwV/L4W6IeK/FbDB1Co7tDcBMeKMM8hufAbmHB9n0KUUpHKoVMVhtToJtzfspnZ4OnzPQUfLtqiK/BZmh6nY1aVng7pV+gs88LhPXsuCvwGaX4Q4x7fRHdwuAIbCZ+YaFoFxZXdhu/owc7trXFS0sOYV7mO7FXx7XqjwGTX7cVu5EaD4apemq27pbzhlAv/W9RtdLyMjIEhclqcmGAiie8Yc2gjMFqJG1tLq8eNi7fDv05vDB5pQWunil5XSaVkP8fm2PAwjb+J6IKXgGY0/u/AHjUm1SZIM3OlEYQOQHta3W2CQEJYtWga7OT7L5pvvgM0j2G01n9ObOiZlz+/HmbdjlVeHQQN5Su3RhE0Ww2WAUEQULmsFzIPAzBTN6ktyhcqOYME11rT6gdJ+smty
 P2YkrUrS
 dj3wPQgd56cowrHOnc0oR75rjcwHIvNSxqfnwTDSF9sNrYOi5qOXfEWZ6uJjGb0TwJmPuES6iyaKLTTWtWH9h8g53r+lkfJIUwUpsJpm3CuZmCGbjMsUGPP1UdMr7x40owmPf2P3/J3QinQIxsVZj20Llka59udcCIOGZiuv/x8EREDe5erT4vkBh/PJfmB/bgHhADAsstSCbAirjN1m/+BebwDsdSWXtT3DWCC4gpG7kZZ6uhNWgdwfb10Rye596wTb95nSb8hoGDfX6YX/kiwRbZVC2G0FfOzwEIwi9N8RzlfJO+Fv7OcmekoT+hgGANcUozsY4Grq1sWmSv0oisLQs/gpt4d+0MOXz8p4mSvioKtB+/UpsDwAXJiAZ4DcfMmz/Uzz7gBwK9FM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 24 Jul 2025 18:05:03 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-07-24-18-03

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2942242dde896ea8544f321617c86f941899c544

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

