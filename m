Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D98606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fnE9PzFv
Received: by kanga.kvack.org (Postfix)
	id 9AD6F6B05B0; Thu,  5 Nov 2026 16:37:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936376B05B1; Thu,  5 Nov 2026 16:37:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84C436B05B2; Thu,  5 Nov 2026 16:37:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6856B05B0
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:37:38 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAFB2120BC8
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:37:37 +0000 (UTC)
X-FDA: 85402377354.28.D246506
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id DF6B72000C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:37:35 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnE9PzFv;
	spf=pass (imf31.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914656;
	b=uSfk4FuAcB6HUgF3iHD9vwbjHQnXudLzmgoLFbJyZs4DoiTe5yogMc87QW515MDHvDEv0B
	Uvp5KDSfo8PhPCTzDE0K4C+EI6R3jUF0dLiesiDuFDQLnVL7/mn2ARNduhxnqqShddvWzF
	rza1b5e47iHs+fIA0v0ZdK8yr8VOBg0=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fnE9PzFv;
	spf=pass (imf31.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=WTXHhh5pRi82QXsGsIZV+AuAH7A6K1EJ0oWTh4/aW+U=;
	b=5g6L+RB5/cWmm+CMy8EbYwUSlYZRvi5JwTFB8Ii8VKYab6y+VMK9vcoDuv29wUHS1yKTlP
	yS64vuAgXkG0XalK6VSOP8GKKtOI5yOBSIxDwPvFZCXNsCMJfmhgasPS65KVvn1YR2Wnwi
	/mgTk6BVhVpz/wS24anHyD7CT23js5I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7158B601BF;
	Thu,  5 Nov 2026 21:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AEF01F008A1;
	Thu,  5 Nov 2026 21:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914655;
	bh=WTXHhh5pRi82QXsGsIZV+AuAH7A6K1EJ0oWTh4/aW+U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=fnE9PzFvKPEqVaT6U0gwy5UbhH+YB3BFZ3YDcM3KD1A/YXemCHodsIsjW6OnR4fZV
	 uSFROpUduvxagL1qMhv0EiuLGxwir2SefVD/maMJd/uuBPuuqbhCd5wR/OmfT4O43W
	 wv8KOWaQOtUCholVL5lsQqP6QwNwYcfmiPoTX0r+SKGj/IYhLRzPgrC4T/nHlhccdN
	 Ih1OTvy4C1p9CI4qBiwAnDZgKgt+O8ygVkfzdViBbs0asgF0d5hWCupdFt5paGADEx
	 V9T4Oze+82m8QKtByuaMyBtVNqxU1VrHj4GGzqr6OnSG40sApZAHDFrdpxLASqHmnh
	 g3yqpZ5aO/ZIA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 211E1391B19C;
	Thu,  5 Nov 2026 21:37:35 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
References: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20261104201408.90579e9988fe725faf3ad859@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-04-20-02
X-PR-Tracked-Commit-Id: 19eab4cf787c917bfb7615460933e4ae894af65b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: afd661f6a26438c407bd9928ea16e80c14b121d9
Message-Id: <179391465378.190890.6119698743174134267.pr-tracker-bot@kernel.org>
Date: Thu, 05 Nov 2026 21:37:33 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org, David Hildenbrand <david@kernel.org>
X-Stat-Signature: k19kqqo5r1qdumhc94pe4posdasmw167
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DF6B72000C
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793914655-240818
X-HE-Meta: U2FsdGVkX1+rjtTdEwy/PkrCnQhfqt6ed9zly8b7hKNayxf/wYgO2j26vKXETI1dorwM8uYChgcVLo/lSsSGHQEbwbNTPRrTDYnt3c4dRk25iTUgte+CTqo0udYEcSvWdNNYUYpmhCG/5YNzDYhpDuHSh9k1f6vAWuEBiO83sd2vEeI3VZahtR/SMG4ezGnD3P5ca1aore2XI7nVI3yMJ9V7j6bW5N5ISeAqepfAE3AgONeCn6ImUkF6Z0HAMWP2sZKpW8HNe0dXvLWsNUmP+ds0QwnLIlGQ4STyZCnwX8mJW7e6w5s/EshTbaI4VK5dXhYl9sE6ZDEIrsZ66khiL+8FouQlVkfnQLdUCOW/REU04hD419cEsjrvy2c0p6WyHZ563P2qRXa3+Xj4JYWJwzPmsXbV3B+gNG9J/Cn1duPHSb0pKONZJpC8dSuz9msQkrW8CU1yFTPotjV8aAXh6t2vfx8G0eOa/iyt0Sz5QeJetHsWpPKgnCZMT37heAyuhw/QnrQXGBN/C4NVO/hNIyZ4nkex7Keo9UYfFXoZbVS8ZqNJvhU2+/8GIL/rmxUXroPq0F90v/H8LYHQ2jKYssmqfT6r7vyjTnSjvwL3ezaJ9GKFf0kGFT+mnlFA2rvkJM0Pqyxai5WQrVCxtnzZfksRy5F+Tw+QzooSpMaZJy435+DWnMkyJC6E+OiePF6juALljWQ2Xb0gICxr78uU5MeLZGH4UZn9/l5WrUY0SQr0II/dgSMH9P4iENsombtmH3PEUswY2Ofj0QjHEVFu2rIsjZ8puts4xxEvu/5lqn9zJ6YnN4Q3f8vjCrcahG5hZqCi2jQhZCSuzPKDK3kZf0LCvt3kPaED5myyEsQ4sWPibdubU+jMORBzmFtbGtNLdeEaeL5CjlzYk7isAltsvrkYZpjcwIqiX08thskoH3xly0J4pUQrck+Tsx9Iv0UPq4RbzvJaYCUdJqFkugv
 ddJ2SKvz
 fsrryfawEib7QQMlWdYu7xSEEp/MAoMGLoc9o921WG63DkFMQbmxKC/xNSMTSrTKwo2Y02NhSv5wup7OPM2kS/5LA7pWlKDkCKsmKbQKl6mjpxrFQTR0kC9bj1+ZdGy2NIp08fcT83f8rgKLb7r1xt7m/L6VRWBApADWc9T3IQaHDGXNxSSoe/gMFccU1wstsrWCOc+6TNWm4OEsZpmGS6u4Fd1PDTj0QeHAamtsZuowzccZrp2lfCXfLlV8PWJv2EyBYbKJ9GiZ37CKm06NLw4N4Mjgq5vk/7H2KCpdY4yCrb6ou7JUajpMnwfSHaKQuugHO1OahOQIkvzVHa47+AFY8Ljy4I1/1N1xqN39tMGrpsXMdg0Yw2D6zrHs7UgHXQ3mYq7fCUoTA6tvEYWfkt6Uvv0juhVpXcpPONPFz90ozvoO8yfxhOffFIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Wed, 4 Nov 2026 20:14:08 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-11-04-20-02

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/afd661f6a26438c407bd9928ea16e80c14b121d9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

