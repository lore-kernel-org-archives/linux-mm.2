Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3590CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 22:59:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CBA86B0088; Tue, 23 Jun 2026 18:59:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47CBB6B008A; Tue, 23 Jun 2026 18:59:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3935D6B008C; Tue, 23 Jun 2026 18:59:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 159106B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:59:47 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 712E08BBCD
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:59:46 +0000 (UTC)
X-FDA: 84912696372.08.C84C249
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id A1D0318000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 22:59:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BszsdU7/";
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782255584;
	b=sPhlhWebhLo9RT5krSdgwunhdbj/e2CbRmOEwjSfgQ7r9Dv+XLp5LrQ1gCGvpMVcPVzXPK
	5HKvmMXpwPxyCqZ59Hq4LMaisZlJUSvw5p3+sh0r8w74K3S33JNlYoWtDNSVt3WxQ5zXQN
	iBiJETx2bHlfKaYIfqQQTHUhiZJSqeQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782255584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7IXcfq3gM4m+s/VkQ06cWcybglp/CfQS9+usXoqPFzM=;
	b=osJ0Xw21jx0WIIOucPAo4dL+Ju277uZQWHrBlHFNPm43PEptemK2GKl42BTKXJzGB1cAHR
	tvWYbUPDFXwz/ZM5D/djO77DQB28RHyZZjsl6YxBzbbKeUNYApOYOgoCi81YA1k/t3DyfX
	A+W1omhrmCGRNUcsciRxg7MYb1hqxoc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="BszsdU7/";
	spf=pass (imf24.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0CFED60008;
	Tue, 23 Jun 2026 22:59:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA5F31F000E9;
	Tue, 23 Jun 2026 22:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782255583;
	bh=7IXcfq3gM4m+s/VkQ06cWcybglp/CfQS9+usXoqPFzM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=BszsdU7/nCzdDTP9g2kxjx9nm3+NNarhyLL9fRajMPKyjKUbSOlowhxnVQou+MHbh
	 YbgTJ0s3XBg7iuAxb2nncvJFHl8joZBpHXP/vfDXFs6532tOAnmtNjpIVrB1VtqkLl
	 OrIcv41NBxofcc0T5EB5ofnBkBQwLoAGhDqkPHZnFMUCRXjIWl4ewwGu+5YIkx3JAr
	 8Y3MzlbYxn/+5rD6ylYVpmOx3jMiuAkJdVRiMSf4wu7dslfZqXr7X7mHdpNdSk6aLW
	 b5qm6SlnVWnVExVjqL51ivPhrif1IrOxC2daCqB51rUB9TDpvZn2yZzrmZ4bSfG+D6
	 2/OgwfftsAwpA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 56A9A393101D;
	Tue, 23 Jun 2026 22:59:34 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260623085840.0819c7694831ca2055e6a733@linux-foundation.org>
References: <20260623085840.0819c7694831ca2055e6a733@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260623085840.0819c7694831ca2055e6a733@linux-foundation.org>
X-PR-Tracked-Remote: https://lore.kernel.org/ahRU4OQiGMaLf2Y-@sirena.org.uk Thanks.
X-PR-Tracked-Commit-Id: 13a1e1a618858407fa12c391f664ea750651f6b2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a1a8bab74176eed204a3139ab7ad840caa3d73b8
Message-Id: <178225557296.2458641.3513051191848090904.pr-tracker-bot@kernel.org>
Date: Tue, 23 Jun 2026 22:59:32 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: medtt3mpcc3mt4h7hk9mp9os7dy8qw6r
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A1D0318000C
X-HE-Tag: 1782255584-358675
X-HE-Meta: U2FsdGVkX1/aAhys4EuNKPalFxUmceQO6QsWSYl8IDqvVjhyOoPAJiob1iOBP7rVtDkLEdKW3yXtdF8Ezgb7HI1m2ZgGPSnCzAmuN+KuYzYjXQWz9eqOAZ99Na/G0TIaN2MBSjEAJdVhZFW0NBwINHgNhb1AyI0r4A5jYEJORjzJUxSmQIvoDi9syCcg/CTIOmHHTrRcxJ9f3ghqkdi21Og69HUUvooVLHQiS2hVksDSBJZyxEBVxuifGPdcBFks/LwalaRoDAWkqRB7WoJClXHFOb67sKf0LzLgcGUp2w0HclvlhUQjCMYjYRHCYKftnQzbZTPrUPOIQaeztjksJZPSXhipZ/1ILs3T8Wg2xPDIoZU6VZeIZXuhWT9NI1/ahQJ6we05iKc+MRx4DFZyi8+sl55MGvOplBxGYYguyOjFIMDNDE5nbkHr0ECs5pFRHPHLatoXoMBmUFsUIibhcfVU1LQra6WFAXzAt8JRb+9z2QWZe6WfNVUOTYHIHr6kB4cX0LIYwAUCR8h/FP2PJNbN5TeM8HGymNKJ6Ma/KoGyuuLVZ1v13yuErPYWdjGpfZ3pJbsSPd2VEzYd5nf5d3l66MZdGYAfkRP5Nq6ZI2m5FG9RJRSmKhMdwgF5quSxmVEGb7TYyENZYPGwVrqBhiV1gkDREeogx6P+OqeNoVyePOB+DR2tOCl/vqMRQwry9UJKLxVgSzmr/raOGeKzJvyVLSd7VEAR+s4gVtPnMVpRxp30Efl0l0UhiY5dJxCvyE4U48ZX30bToZ1bmh0Gk/33/pL5ZwdlvsGxEGbk4VW588rNl8YC7zycTARzoQzkIoUw27Odaf30FH7B2oEUTgNHstnzT5edKSQk+G2glYuPhZH4wQ2NoH1Jo5bMN0rlq9gV96PoUvj7547/kx8aVl67KqpyvoBf5hQc/3S05glFctMFdq8KDL6ap7yxLcqgI8yXiru1ij9MycB8x/C
 87qaLxGY
 +IKxEJ0Y6twiUlRfe7zDKJD0bTQef3MCyJmF1PhrEHdHs1nC0v6iQyFQvtUdXjenQYdIaoLt8vbpTMGdNIfe0zEXiTuKyHlNrmSafdj8vxSPS0a7SIKvrnvTgsb6zu0NQHoM/Dl65yZkHgsfJZABsjkMgz+HORxSOpTFpVV41Y0mSDkHVgsPTKJQdB3AeCebXRUX3UnBvH2kBwqDS7oySKDw3lZX6L6YBMqAPOujBuIlrvPSbn5yMV1xuimjf9xv64kMWFAzigRsSb63CLxx7ndvNZrNES4qhbibV3NG5AXYnZcz8LWiq60Xejp0/geBuc+z0ZwjEY9G23LrdFGKouTdjGZp1zoLT3GRe3aVYG/sb+FDvetOd3WlimQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 23 Jun 2026 08:58:40 -0700:

> https://lore.kernel.org/ahRU4OQiGMaLf2Y-@sirena.org.uk Thanks.

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a1a8bab74176eed204a3139ab7ad840caa3d73b8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

