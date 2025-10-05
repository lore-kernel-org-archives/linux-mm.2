Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F1A7CAC5B8
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 19:45:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 015DC8E0005; Sun,  5 Oct 2025 15:45:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1D18E0002; Sun,  5 Oct 2025 15:45:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DD0A18E0005; Sun,  5 Oct 2025 15:45:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C91628E0002
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 15:45:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5F655B94FB
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 19:45:32 +0000 (UTC)
X-FDA: 83965090104.15.447E4C5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 918601C0004
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 19:45:30 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zy7Df1Ex;
	spf=pass (imf20.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759693530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Rd26sB32tRYpAQnB3KqWiTVsmXfqNMeP/1e5YA/0Q/8=;
	b=tpow7D8Hcd/mH96LidbJQ37IV5AHqeQuym2k9oIWpRKQ42/VLlr/8kRgqYEIWPiCOBoUW9
	z0K2eZ9KT3dEK7YKNOfv8mqW7TbAgDcDqDIAGlNMHorRJeLmM0lx4FftPPwLBoyERrFkKs
	b/0uKH1s7VEIWa1bBjKX2plMw9njqog=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Zy7Df1Ex;
	spf=pass (imf20.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759693530; a=rsa-sha256;
	cv=none;
	b=w+eh8St6tcFbtLr447SVmEA2OwreSpscWzjAbDBCeLylLDat+ugU4nrDCzdioW3ralnjVz
	C92q5gBweM66F+kkV5kQXfPvsHugnd+SKaK9B66N0tEw/TkeU/9KJzXJ3Itr/hbar/XIAL
	lzO+KMUmaJVIUNMrZZT/LdiIHtSD2pQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 97D6060300;
	Sun,  5 Oct 2025 19:45:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 439E4C4CEF4;
	Sun,  5 Oct 2025 19:45:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759693529;
	bh=XcUhwtF7uuagHrGC9EKXXgcoMysaKraEZFP2wxRcrOM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Zy7Df1Ex4hfhtHIPCZpyCQnScZcEHsWCYcPmPzbnrzvaAvKfTQUU0hwAGh9Sg/7ji
	 /9C168K23Xjc4QDuzie5AnwHrSEOU4IBHZZXUMFD3wv+nhczr9UijjNNTrojbzdaDj
	 rsgtUaMOo6yIP5GjbQteYF7k+LcwCzgNhq++LZDT9sJ3kUF59gta6ilRPQV6aZicuk
	 FI7qp0UsN44jJlySo03rIdT+JbJwmwZSYuuFvIxCkXCv/6l17INvV3TDBbLIn3ZXMV
	 PYJNWtLxm5gG2/IL5bh674VD6hKLAyNFKv17ImL1qc6XzbExi9f6K6Ltk1J4Efh+sF
	 BEmVdaH2nSDwQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADE4A39D0C1A;
	Sun,  5 Oct 2025 19:45:20 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
References: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251005111538.3996dae46662e46054d46528@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-03-16-49
X-PR-Tracked-Commit-Id: c14bdcc9f274620492aba7d920cc2641440cf1ba
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7a405dbb0f036f8d1713ab9e7df0cd3137987b07
Message-Id: <175969351912.726026.1611185390690071734.pr-tracker-bot@kernel.org>
Date: Sun, 05 Oct 2025 19:45:19 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 918601C0004
X-Rspamd-Server: rspam05
X-Stat-Signature: 3z71j4e1nowo9q1jb568frxskoc1qmju
X-Rspam-User: 
X-HE-Tag: 1759693530-900487
X-HE-Meta: U2FsdGVkX18Wb7gabmXRbrTM4St/w2tb3HktqxL3orWxGQldtE1UO9hnnMAd3GMnXLKjtQ6DH0nX9OaEN5TsjaL7Jwq/vCigChPNooaRSAjZZZIhy6prMcQXoZw4SoI6+Hg0tqdKwynxGqJ55HJRyZBkY9CjOdfO5fs0ngfKz64krQqUaZiaEqbO2tWBxnH2vzQGjX4Zce56A+bjIdmDGtNRz6U6R6x6IVhnsYHjB/Ozqk/TYbDJ77RS59EstKrIQXboZK+gUKb2Rjy+qf0IZ9tCCTs7dwPWaDsFiPPiftrz4C+nw8mp9cd7VT39YJMohGs8kc58uLm3vancwy5SpcK7L8dfPzLYsEQbMm5B2FqxD2WVJs7YBlgDyhP9DKoikDNZF/nZb/vvRaeGyeBEvHSmBmI3x0oEK2VQwQiw0VwBIAJxkP3MCpCZ104R5GuqpDZMGqa6TAobY43x68ajrSmc/xfjz19N8+zH+KE3J6HE8kIuVKez+h8XIvkRCl3FYMPdaADMBBfPj+ueuu6OxMQx8yNt9XXXe1nOIEyPvOsIFkEQLzoziOWx9WzFvrR9Pnwap8PzZFp7UG7ZrS4iEpfYtw7wVKVRgUUVrhsKELfsRy5SUSeHbvEzDyuC0LDR/+K+qRjrNUmNVa3ztZ0NEYH5iJYadQ0n0Oeqe+hafL0TeQVJstPZygEz0bYOjqzLv811Hv8/YbyFsjJLY5Hli64Q0IPiHe2wwDImDlRFJaVB9L3HL6g5gCVXNG3laPEPHYBw96YUn4iEopSpcLVdNEJQKCjPgSysX9ShwqOgkAZX3nr+hkp5KzhWLvQFp7Mtk7Xm8Yduk4D0g/luEOJIXbp19ltWhFmWURy7PZU/1m0UplOiMHorhHXt/YUtW5vJtsbohzg2nkjmhLjOAs+JIpMC5+ItB9yie3XjfyT7Jzth1T72pbPstHJF/sQo66Fk3WSbg+oMOz0EImX4fwa
 Nw0E6Iqr
 Hj5H4ENdQ/binsQadWeP8H3WjZDrrtTJB8jV5MJ5dHgJD2F5L9dEJqqYQVLBl3T4bte0F8dOdv7v8o8xAuPDLU4epiGEkKMPPClH1leQx2PcQbqQQkK9MDfDHYEQCSLqXOYy2MsFNvsJKH50pHJUcY6LKMNQEHMMVKdceO/QIF+p+3qJ9x0zc127820LyJtMkR1TAI3jk7u+rEvrIjfqXjGvHSRvlamjMMmgpHTKhY0M9KWT18HBt1uTTXtmAcwmsgYfRpz0RjVGv1ZDZxfJStjTFBA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 5 Oct 2025 11:15:38 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2025-10-03-16-49

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7a405dbb0f036f8d1713ab9e7df0cd3137987b07

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

