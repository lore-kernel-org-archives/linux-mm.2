Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CA7DC88E6F
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 18:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9856B0092; Mon, 14 Sep 2026 14:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997766B0093; Mon, 14 Sep 2026 14:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CD106B0095; Mon, 14 Sep 2026 14:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 73C616B0092
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:08:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EF91D16020B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:08:32 +0000 (UTC)
X-FDA: 85213152864.03.AB825DA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 2EF221C0010
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 18:08:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xakp5jX7;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789409311;
	b=YsBLdj0lQLm7rmuzHeeUgBeSeUzgXcU1WWXbHlvt2iG2RyIVoZFXIondGCF+D2HifIUDWe
	9z2Fg0WM/GhhHcBLPFwrbUmDqZgudQ3TP9ZHmC1d7Kb16rzLiCzD6Fh/fNbZXtV+9zKzTO
	8PY/fFDtkbBBVGa5qUvKniEzoOO7UnU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Xakp5jX7;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789409311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=5daMscwDaX2JwFil5lTXQITuvGSdrd4toNTeASvATRQ=;
	b=JEWpyy6osRXqMu2P76zuZa0wcxFmIxbj6M7mciv4DltUrqXHgP2Pifj6NyZHfIDYdsnr7F
	+dI/ZWMz4jVhOFbGyxDL0JCw3jMItaeTD1KgEgewxBJcrKaNBDniyQqo4ndWu6v7ZQlOC3
	3HgqPuCX6mgUCUD+9uT6MABVgKWHGV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C65D56022A;
	Mon, 14 Sep 2026 18:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FA761F00898;
	Mon, 14 Sep 2026 18:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789409309;
	bh=5daMscwDaX2JwFil5lTXQITuvGSdrd4toNTeASvATRQ=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Xakp5jX7jwvusY84gD63JmsDjXhhUehahgSy3T+yLAarj7F1FTY1QGD+zf1aLGP2z
	 gBBmG2fDX2fChAynKn6/vXj8tjqluX+nHVamvQUCDMGcXHus2qBDGlErHvpNpSE6Pc
	 hs59QlvuzqEgmJnfdqE9Xwltnjz9Lqw5oTEoOpLRlBLZlerRfhbRE42zen6vjKD+mG
	 HG5ED0/4Xm4w1hItcbxOD7EkDR0kqO+xB0tpBou7UO+ccqFfX5fxhOXxgbVOJqkJXV
	 qnXyvpR3+Hi9FoFwLJZwAAQBBmobLKBRyIGN6wcW9Ot9gl6YucJJ2CzVxKOdqll8LQ
	 gudQDaE1dvSaQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A613924FD1;
	Mon, 14 Sep 2026 18:07:25 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: fix for regions display in debugfs and MAINTAINERS update
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260914051534.4085114-1-rppt@kernel.org>
References: <20260914051534.4085114-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260914051534.4085114-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock tags/fixes-2026-09-14
X-PR-Tracked-Commit-Id: 6e33dc90df108c76899dc544a42d17adcba61668
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: ebb58ec7f8539450804741d974acbb985da0f071
Message-Id: <178940924446.1155813.14492190716772354611.pr-tracker-bot@kernel.org>
Date: Mon, 14 Sep 2026 18:07:24 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2EF221C0010
X-Stat-Signature: 7zew7yy7t1htdb53tpsho1mw5hni8g57
X-HE-Tag: 1789409311-603220
X-HE-Meta: U2FsdGVkX1+NgzPQmhP51Rg+HwbRZlIUiORxXiQBAyhGf9dttAr1bfO+3bfJh3M7Q8tbpQY8Kg5Qi/LAE3Dle4OEp/LuTe2Zd0KS9w8SqHWpxESnUZX2l3gLTK0v0yzP1ezUWly0JFU+2Gov/A2OYreyI0tOAKSGoWGuWqw/P3q7ZtSlZmnRffBYj7WCtonZgyKbB+5Nyy/pLl4m3Ls3BrRIy6bBCaVW8csWYvDziKLRSR/6q0sgG5nN+gnkFl/MQtsiqDrtWb/FYxz3MVQJHXYhdSpstZtHt6R5bdn2IcRtbvd9QkEKIFYghDGOYib9mjEZRiK/FfqS7jvlYfNykaP02A6wL41u0t5TnHr8t5dHYG/iBtaT8f8Nxb19NeaQpsb2mrql6mg1SGsRzQ7pbsMOMBD14QNLBWHZY8DTU6Dr0t7kgPUN2EcznGSnavpyrLu3izPJEThjPQLPgIdeHXBJpuIEnyzbxgicyiIyJzNgDnk+X+Bv4ins9Wq4xCSzALEKhsCRJwgsAoHO1BRaLe0VzUCG8r628+0AkRQgxbS8v+NU9W9js5eVxELrWYyII/1cuSEuW9geOMOX3H2EG2F1B7ToR7nTGn9OO+h0ivHsRZuKKc0YPbF2GS2BTwbVusYRwm/mLVyHGwr4f3hx+JCvjzAnE2UgzbQhxe1dofE5gf/jj+qVJLJ5YZ5qSdl0OOEmnRFi1fDBdcYTWp1ioDNDLX15Uy7lyR8HCPEVEdzLwMz/nR7GOQ0N//9kAFbUxDKHxMKnf7uklmfGvpNENfk6pxzMVj3NUiurOpqCglk4cZ7w0zYgLZ9veAMCesfztlP8aEFWiuJN512plid66Dow/L51ZtMd32D4FQwIpeBLNUHJn/jK5bqPbCV6E6FO33GCdh+jCktigRXvGxhLsaQN2iUqzVSbu6+NWytZxqjxvfyKlBYqYCzHvogqftKwfsM5h0aUagNx0dnWsPo
 Ig/NPcAW
 jGHWzIr8ZEe9/8Co+H3hj30BRNFOxed4DtcUH4PDo7g5DnTXmNbA29zhLVmhe8i0x5m1tyKyqdwTjpJWe2hSDw2VLgb5IJXAfSmF3Z74P2xCuWLEzFQr53MsBJyjvqSL6tCncpTZ6bFCfBk0mGDpIhbEZCr7f8h6A36RiQ4tLgNBfwjW1IdNKW+Wn4kPVuYEMydZdM/4AdwXW/faaov/QhI8RWgj/iNeiNxOS1h4KYrF3VfYvTqNlfXkvkG3yQiYRoTVnzuew5hbdb4ajEqianURZ53LeZ2qFdgNs26hN6f6b//8vFasiDcfRSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 14 Sep 2026 08:15:32 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/mm/memblock tags/fixes-2026-09-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/ebb58ec7f8539450804741d974acbb985da0f071

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

