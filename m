Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F66CA5FF6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 11:09:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0744F6B017E; Mon, 19 Jan 2026 06:09:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03EA16B0180; Mon, 19 Jan 2026 06:09:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E804C6B0181; Mon, 19 Jan 2026 06:09:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D74926B017E
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 06:09:23 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 79A8B13B991
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:09:23 +0000 (UTC)
X-FDA: 84348442206.11.3D0F379
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA4DA40004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 11:09:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T2p0ReId;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768820961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XJQeLzTpNy5GGcT0XVduDPzok5+RfZO+3TzBrGpm2yY=;
	b=AJHQJLTwmUGNpxFjTcnhC6BeZ2gVx84afad+wIYYcD43sxk5nSm4UxcwwJZQsmzUYcE4gj
	WCO5mDvLYRlnZEICVdy6CssUUTjBqitlNLy8jzipmFtQzADX/cniSnFiSyVD7ghwqQsZ5Z
	EbDj7j26hoOdGRB21and5a0tfxW5FiM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=T2p0ReId;
	spf=pass (imf17.hostedemail.com: domain of brauner@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=brauner@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768820961; a=rsa-sha256;
	cv=none;
	b=3buWHoZaNVHA4VnzOpfGC5/Vve08HaM7cZ8VAGA9/xUDMlIlkIXkEiK7ZyY0K9l5AiWkFq
	JP3Vy4orKW7qQ+Ymc4SplvGLBbXEfWLk1TJ+MuYAedASqqlLiXkZS1FAGXI/pvUKKDptgC
	xQ/LASQO2tijSbcQIsNGSIw/L6UnOoY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1543F6014F;
	Mon, 19 Jan 2026 11:09:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CD56C116C6;
	Mon, 19 Jan 2026 11:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768820960;
	bh=GmLMDLqG/ZC6pHQoQ4uFJi6AJiGopiYZNwHKuIrSntM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T2p0ReId1lbEsFY2DvU/gRohnt8QhyaJ72wS+PSJfzZMB5VFH0JTxi5XcP9d1ZNYc
	 Ef3Hb9Otl0xKCVY08zNMLDo+3zFnK77RWzjFFuV1TNoBKNNEZS5KxfBdB6Ee6pU8JN
	 JdZgD7rQqnLFzoDn0ydqYxhbTyZHAZCcK0OuxR4aS6kif7Vhbz3zFrlDtgzRmSqtsj
	 pph+k+TCZvbzCH5d2hsTB77/MYcGQatq2iq3KS/75MsiG3Wv+0wNTlEelXdElQ03zN
	 dTCxJPEswb1NeCX/DaRnUmCBQKCmKL78bqPFUJCV1t9D8lHc/2+TPw4JH6gtIN/0Ii
	 YD/GqbaYBY9vw==
From: Christian Brauner <brauner@kernel.org>
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org,
	oleg@redhat.com
Subject: Re: [PATCH v3 0/2] further damage-control lack of clone scalability
Date: Mon, 19 Jan 2026 12:09:10 +0100
Message-ID: <20260119-wohlmeinend-hebamme-1a9c418f3e8d@brauner>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251206131955.780557-1-mjguzik@gmail.com>
References: <20251206131955.780557-1-mjguzik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Developer-Signature: v=1; a=openpgp-sha256; l=1350; i=brauner@kernel.org; h=from:subject:message-id; bh=GmLMDLqG/ZC6pHQoQ4uFJi6AJiGopiYZNwHKuIrSntM=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWTmCdw2ddu3JWS9yJYXNyd8DJOaG65et0d6+qu+PyaiW 19KPuDU7ihlYRDjYpAVU2RxaDcJl1vOU7HZKFMDZg4rE8gQBi5OAZjI9QRGhr8ykWfrvq1XvPrO auf2E8tjHE5POmvONOVJIW/1hv63b60ZGX4J3Jmz/1vIjAf6u95qda98FrV7/je9A0eEFrTNCW+ r3coDAA==
X-Developer-Key: i=brauner@kernel.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: sm6fyyu1jwdxxqbwsibkwinjoa17aft1
X-Rspamd-Queue-Id: AA4DA40004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768820961-384255
X-HE-Meta: U2FsdGVkX1/9y+8JlOFEWNa2I8mhlcRD642dX2JH9flcSs/hhedcg8x9bGTEvlXCCioLJ3kkQW336+MnHKAeGZ/WyJK+le56XD/7Dstexaf1nJvXZhVJOSCOEHo1ZDjtblmMxWsA6uo75LoVhZ1sz0yuAPyiRA89XHhUBB3CEyi9Tm6gNPhiV+6XoOUW6rdm5xDOc97SsF5CVMLDE6iODr7pExMIlOyO+9WBed0ZC5zaiq54td3DLJ/a9x2WkdwaJezTLmOtXuKVJjBV9fNC5FcTNL18+sRnpaV9w5qxzURJdqPO6VEHFmoOLSvpW2XKjVBEFZqG6xEludxsg4AEWnxO8+v481VEP5e74F7digpU9agNoyUMpBttDAATmXCyKobbK25hl8mDH0PPhIRJq3ypW0XFCcg6tHWKQbA90JL5Ig2jj6HMRWXey8VRlADVKDT9UFVTkJtFyIEfRVR1A1xVzZfvs5jsFET7ZS60G7tKMFd0BdFY7isAL/n/gUVhjfJk9EQNiJPjtOjogkIrmUFf2Y8z/eXrD75D4qLAI+f+mBy5TanZEWzXEeIKmWs+Ll1E3fspNS4To9iZ25WtCh9lnATFDqJeKRVYgnn7do1uKzjyBmYfLIY2tLOMdRYf+cYLrApy7Hix1qyDCV3yE3P1jROweS4y/EhWmuk9rlJcpIbWQH2K5HBIZKdvP/fPbp6wiYvOIVBCgULTXMQKb/Bt7x62oneiupuleVwh5crokY1WT05RoZ2nU5cw1YCBtTciw6zdDPBeFCw4tRsjZmTJ0G+D4AuEJrzKTv5gAHY+6XmaFS7V3yE7E0tE131Zw7fuIWrH7MqlwXxCCmeaNcL85b+SGpgIMnC3F0S6zSzkpWQtp1rAsf6pHVOttVfqsjV/DNmq3ZfWPGIYI5dRwRPOrGd7rQVJMev6eMgkRFMAMuhWc1LHntuPcfkSdQH9DpxsD72Tf+Ifcpkp4VZ
 dJxN1hn9
 wpNis8dYX3/pZKDZZZV+COe89jWk9byMaqnb8lmglIPfkV09dBl+ag7CFeHmP3ls8pg5pPdrMwAWZo/bKqdSE0CA44prJTJwDn9iwAsyrk0rxyV/8SpbOzvg7kMNZc9cZ+Lvq40C4QQW29M9Ci4yPBDZJwZNb6aX+hB3QhylCSNqkKFeptkfoeX3qQyejlb6bzk+mLrU0kBYft/RAB/9O80d5fVHrUsHNlKV+wN5xFH41bIdUQvTohz+Qc39FXLQ7Zeq/f1hgCnlw6zvk11tDngGWJAYMMeL2w4uj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 06 Dec 2025 14:19:53 +0100, Mateusz Guzik wrote:
> When spawning and killing threads in separate processes in parallel the
> primary bottleneck on the stock kernel is pidmap_lock, largely because
> of a back-to-back acquire in the common case.
> 
> Benchmark code at the end.
> 
> With this patchset alloc_pid() only takes the lock once and consequently
> alleviates the problem. While scalability improves, the lock remains the
> primary bottleneck by a large margin.
> 
> [...]

Applied to the kernel-7.0.misc branch of the vfs/vfs.git tree.
Patches in the kernel-7.0.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: kernel-7.0.misc

[1/2] ns: pad refcount
      https://git.kernel.org/vfs/vfs/c/0832219c84f2
[2/2] pid: only take pidmap_lock once on alloc
      https://git.kernel.org/vfs/vfs/c/fb374f0d6fc6

