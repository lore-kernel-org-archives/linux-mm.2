Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80460C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 02:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C3716B009D; Mon,  6 Jul 2026 22:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2740B6B009E; Mon,  6 Jul 2026 22:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13E866B009F; Mon,  6 Jul 2026 22:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D62376B009D
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 22:09:33 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DDBC1202AC
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:09:33 +0000 (UTC)
X-FDA: 84960349026.08.B3D3C60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 61AD31C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 02:09:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSuHS01Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783390171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ZSeRuFsGx/Wn1nKCRTuLj+Pzgee6JkOaa4XLCrxaHQc=;
	b=VBPPMavLTAnBhXhSxvwiO4HViRZtLDjkWMvj+GzUhU+npQj4XWdLyu4KSyZOhMtx3p2hz2
	uM9q3frA9U/TAYYx4IvAVy7ksiHqok1H3BgSNi5zK4FXc0WC9cVa6o1pQpw4J157uFhCTC
	2BX0BMmNUmtaxLecxeTlhEh4D3JpQ0E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSuHS01Q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783390171;
	b=c/sweRWlufU/RUm3hvh601Fmx3288t6VGRtLlVVbqN1PbzIpfKcgm08L0qyEG9I52+G9es
	Fjq0rFFfVc3hz7x3v/S6XYAmNh5kgXcJNu4MFK98DhO3/y/bB+op79hKyav1kwKOLl4tzG
	YDXBjQr8XD7lmxGsT/jaf9SSF940Yts=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 486F441664;
	Tue,  7 Jul 2026 02:09:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF401F000E9;
	Tue,  7 Jul 2026 02:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783390170;
	bh=ZSeRuFsGx/Wn1nKCRTuLj+Pzgee6JkOaa4XLCrxaHQc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=cSuHS01QpzWP2DO0NjfSNBZpzkXmJQAoAjI+G0frblXW3RoF5R7l+vozVnsElzpr5
	 rywewl6ccSjZpq8rtkb708xuPdiOm6xlMenR3vJ3Y8TGhTw2PGfwAtIWeE9lmIDZ34
	 81q6pNNn0iS/HEkuJ+fmSF7vn56sfIwXx2+Zig270LqK1aWG5ZW6MH7xOChujpjbjO
	 SOjHd1IMVLTga0TAaYwY6mDLvH9nl4Kz3k4gmXHtVOKpo20JlMieAID6DLI5aA8t0f
	 HFt5xrsLMmIW0kW7k75Qmn922wl1XoxDU1RmhhkpsqkfRK//YsTwy8kZB0UdkHPLCH
	 Z7mG9PHYvhZQw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93C9C3925F7B;
	Tue,  7 Jul 2026 02:09:11 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.2-rc3
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
References: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260706175120.2411eb28603d28ac0424a573@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-06-17-49
X-PR-Tracked-Commit-Id: 039892c35f9d8f5ea00d7c2ed1c25224f28b11d7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
Message-Id: <178339015024.1289809.10295323944110315873.pr-tracker-bot@kernel.org>
Date: Tue, 07 Jul 2026 02:09:10 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Queue-Id: 61AD31C0004
X-Stat-Signature: ioz5q1dcr9qpf1id6tmxorqmnywqanuw
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783390171-700465
X-HE-Meta: U2FsdGVkX19jh6h7/Iy3Z6X+70qfaSvKdvCAgKrOKQpRT7TEiJN1dYewQPbB1sbeqTdiPJBkgOT5FkM9E/DYpZCF5znf4JOIfZUTna+8FLzH3of9iMs2XmE+eOdHHnBJPiX6zIvS28uuy53bdyHcycxfbhxkQy0gE6/KrR7Y4v++tu84zI4IQwa6qHyhEf1svgK8dtBXohHsKZo3LvXfNDlsyWZ8ATBNO3iviPq1SRISBcPWaR2SZkpsAmNqgbbIlOilY5VTczJrBViNFY/zMuHuA50uWNGUkq7Jeqckil0m5TWCE6hSwatAATANzKuXJHU4my3BU3sPSRi7YLXzYqgeNWc0c1y2xchzxK81PkEB4bjLgdhxfra8hVDR3tm2EUI0cdg92RV/U4x8aohj6Dgcc6mw11q3CnjA4uQsFhDzr/ez5su3HLEmmcBqr7CrM7uDI/ahACLNWEHNSU4CdoXnUYm5+qHS/IE2iml1D7+UVF1XFChikpSMLGxEechYZa39q6zM/eVKN7fhjd3Lct5A8VigU09yrNn6tUssUvYUXo8Y+w5v0IpYF8UfEF2Rk6hQ0s9ot2tVuDKvfQu+zWM0Zmff5xXBfHa/pZwI0ovqshVfr9OP1Zhkc84L+umgZqQlgXLSgzojBSdsB3Jl6mGMXiAUS2EeHp5PGvi2mJ9A1UfVRI3ahmmZVrLEESpOop15lncTj+Q5ysLghZRG9mTYLI/ClX2NDizGFX7m6iczBb8yo3VB8oTNTUcI9cJtxnKuwyNBT2R/3UrXTCxiOHJ/0O/QdqC2+WbQifyWAczCnbErKZluJ8cq4+xyYyOZRuTzoSrvW3Zs3pDZ6tBsM3VdHfcrbemCPz8Kt7e7h82h9MyjlSrEGBrxtKt2XwwFKSSxk3KSBIuLE55BHoDJg4iyMmnULQsD6F7eisF7O711M3x2pHBx4IRbiEbw9kUi4HQVmaP5oTQka0T9wzL
 Qvo82AWI
 NYAxXIdnWu1NpMeCWriEUTWEPbqw8HfmCS1TS02tpk7z7NR+jM4J2sFwGxs8kFWhN+KHgR/4dEpfoXFYw2SuifyZHGUEgycLPaZF+5xsEOmYOkA6r1l6G91j6xxn9gkpKFEtax7nYcenJ9EuGGDKJpx9s64Q0G1lHhiSxXOGhQiWFSx/+RStR5THHk2U8h+DPZ1n+3NL6Cqlcj7V3+dxnCKw1KO57renOStxGHVkXYzALHgz2yB0+z6E21JNhsobTluksSbcxc1KFHu9ZdJDQBaPZ4ByRGRQDw+erJLwE2e6e3CAKgh75UFStSEH9qGTvytYwvadDo9DH1WEVWKdx6F0lmpeV35Ts2UcovcMEC8lwKJ6EsSorKqXj1zKBgjEImnlCTvC6s1dD516a9q7FbokzZExFnMRCFUzJmgfQjnT6SmRCr8Yu3RxG/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 6 Jul 2026 17:51:20 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-07-06-17-49

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

