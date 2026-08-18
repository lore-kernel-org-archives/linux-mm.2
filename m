Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78141C5DF81
	for <linux-mm@archiver.kernel.org>; Tue, 18 Aug 2026 19:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87C8E6B018F; Tue, 18 Aug 2026 15:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8534E6B0190; Tue, 18 Aug 2026 15:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7694A6B0191; Tue, 18 Aug 2026 15:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56FF16B018F
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 15:15:34 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D937180207
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:15:33 +0000 (UTC)
X-FDA: 85115344146.05.F9022E8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id D699720002
	for <linux-mm@kvack.org>; Tue, 18 Aug 2026 19:15:31 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFdNSuQ6;
	spf=pass (imf03.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787080531;
	b=0xoQoMkbWidVA7ToY1uR6DQiFISwckPEQiy14zCv07x3gSNKoUGFUF1rwObT5DUrCbCdn2
	T6CP2zOl5lUF/6/MA2ZMzqv8t5/fcCXk5WAOrme/Jpvb2dbufA/DL8j1wuDKHk6kCtq2fZ
	eZWsQPNWxKXZmqleOdZkiK/i8DuK3nQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AFdNSuQ6;
	spf=pass (imf03.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787080531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=EpQerXQbZSe4Wq320Dj3fwwzYb5xQfeYWcQSYz6oPP0=;
	b=BKRyxxO+Z1YXsNiYYcNTpBS/fww5HekUsMUmI8ZfPONAYjgK/ECyaNpudKLlJEFBixcnz0
	2uB9k3NeAygcronJaJwJ9atueXnNnSe77pQctvTTsw0Y+pKrO/1WwRPHkGdOXy5uo0L6vs
	YAhBzzsj1jk6ZcQm633QEeSO67l6WYU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 36B35409BC;
	Tue, 18 Aug 2026 19:15:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189E81F0155E;
	Tue, 18 Aug 2026 19:15:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787080531;
	bh=EpQerXQbZSe4Wq320Dj3fwwzYb5xQfeYWcQSYz6oPP0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=AFdNSuQ6MPh39uTxiQkLnhUYzLFuGnHOaIFQ1aII4OoYMyPzmyw0ynmPCBGR9oR9A
	 c0yLs3lN1LOM8DSAcgUBb6+XSM9b5NIju/ZgNylyph0obJqrq+AXB+mvPtd9kO2I5T
	 nUQyHADKPTtftpfLCbrRib0jRoqoyvrpeSYExibo0Q4Md07AkHYE7ZS+3Jt/GQtBjl
	 D6UU+MhbxNliua4+/lebnmTirGUlWfr8TfH26ymoQlHoifJVf9CzBnBQKojoV7d38F
	 s8WHrqknJ3HgClf7WCct5WXG6nvmMfrnq3YlCuR/fHrHqxd7EkKwGNZovKx2KySH9Q
	 g2wWy0Rqw+qJQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0A103927051;
	Tue, 18 Aug 2026 19:14:43 +0000 (UTC)
Subject: Re: [GIT PULL] liveupdate: updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260813110815.2482807-1-rppt@kernel.org>
References: <20260813110815.2482807-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260813110815.2482807-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-v7.3-rc1
X-PR-Tracked-Commit-Id: bcf2a0b55e322a663c9602c9e773770b87d3e629
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7b24dd46a70e94d8db83b50a04d46690fac216d0
Message-Id: <178708048250.2235733.8997074466118245465.pr-tracker-bot@kernel.org>
Date: Tue, 18 Aug 2026 19:14:42 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Alexander Graf <graf@amazon.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D699720002
X-Stat-Signature: ecpbeeqctwoksqtty3mt48f7shh9iwim
X-HE-Tag: 1787080531-210712
X-HE-Meta: U2FsdGVkX19tvluN82kokxpLfrBQhiv5wZsVd/9JF6A5CUBUXBqibAXmgrjhr+S2rjFvoGHIWiSXVY5/FZhGUIf/7WZlqtwG/i6gVhZv9H9p8CygTCzg2mFpA5wz9sm89nWWat1fh2jcOATEIFySLdUXu/RlQhWWdfjDeU+ViByUxOzrWSTdWZJKdAAN7oIq/ZglPb4uCtqB4jPVwEYnSyUOW/cFGmBtcwe2NOGxywZCYOEVQwOlhTLMRrKzbXUC4UUvOUxNGCV25Ll42eNdU3mHRIoSK1PirwZXsM0DhZZTigYBTRKErnPh5ARdITVLJ1pnf6fhzivG9Y0M7KwSN6i7PUpNDeTVYHwTglvg+1lDfJ6W8mRBdaAPZi6IMBJd+v4acw1L+zB31ExG53XXbk2lbPAJhu2LhbVIQ+WnJogjfxGntwFt6APwMCIAp/DySh8BRLe1yf7vwEnh0gPn559EnwCSpjo4/gjqKiE+o3BgDNxuCB8m9LVSb5ITXzZVoBCL+ZqaUfhnSDQxHxcaANi/mWcIBkTXq6/rFc127eCFluI8vOPJ2VnovkWSmyF19nj2N5Mnc9B+Kf561nIhp8sBuJL+PH335ypKMBshwD67i78uibC+hH72M9B19tZLniWQIYAaRP8/QIN61p+moHE5Ki0FlyT2RhmqJu0+yf59QO5Kl9GYNCr/Pf6IW3s7S+cr9HHOPUsd4eMycOP1v1ktf/uPM/sw851imKP7xwk1IM4kUd003Ad5Pri961lZ/NguG/pawgVq5P3MS4ghejjBW+h87Mzv0KduC2k/eu3i5WdzC0h5e70IwTVut78VEYAqYFPqQZWkZlujUej+75CHXDZXDznoo96d6F/2ShWEUBs0UUOn1WdR+DiOurdFciC1EBA2Ze/VPe+TcMFYOAtJngxnZFUy3uH2LX/cDktwsLwO5cjFgtXhmUpS6hfNq6x8l9KiB5CHPJ1jI22
 oP4OllQR
 uk7nn2YUlJU6ANoQLMKOUXN5G07LvJJ6taxKvR9Po0sbhc0tJUwgMn7MTSeKD7QzwCV561JBJkjHR+w/vBj/Bn6xdu3drqYQXVBiw4dfiUT05VFk/OOfbdx28Zg6HvL2SrgViDmf0AYk1YWDbBtWV1wWPTsspA/n8XNWxmfy5WtpU3Y3YqI2PkpABNRZKaSTfXljyp3oZa3KJ2fshGMzSg0MuqosGFy11LI7ZPhWGYQUjfVKED9lxwvcgIQuAq+0FQGJuB1Baq6cLljE/idNTd67XY3m5bjeXFpX6hFBobFJ+WFXOwieiErcYNPgr+WEmgXVsq9Y1qUQ7nt18/7BjjHZ+W1aOjOhK+kkcH+4VPW19/9bEMwOJmCCZ0ZxwrQwewydWyMOOlgd0slcK0eQzy4LgRTYyxoNWfRhceOtm8HJGkmjkIy+XGk5RvQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 13 Aug 2026 14:07:58 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-v7.3-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7b24dd46a70e94d8db83b50a04d46690fac216d0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

