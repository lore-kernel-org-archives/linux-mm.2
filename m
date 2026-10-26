Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C65AB606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 03:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iud6+Tsz
Received: by kanga.kvack.org (Postfix)
	id 8398B6B05B1; Sun, 25 Oct 2026 23:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811DA6B05B2; Sun, 25 Oct 2026 23:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 728786B05B3; Sun, 25 Oct 2026 23:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 531C76B05B1
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 23:46:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C90A140636
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:46:25 +0000 (UTC)
X-FDA: 85363389930.08.25FFD04
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0458F40007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 03:46:23 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iud6+Tsz;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792986384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=SsagISxi0qI49SXgbaqHMJnTeQEJUrT8R+ZKkwxfnp0=;
	b=PJMZ/YxOPLM/rtcsmV7nXvATETBac9/YLXjf3qZp2KLneRyPMZTNBdWfQjJ6/A/wAckxXU
	b/hfAEz538YiNkqYCapZE4LD/3GwAd9vAM2Zvyjy0CG7VBWst/ObVrAVhpb0rhSJvk4iOe
	PKZFkdjc5whEcwhz6lZ85+1l1LMhONo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iud6+Tsz;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792986384;
	b=XZAvJmVC3V68SZbFjlrRjLSG8qC53fSL090GFmjvpiTX8f8JPQaqfqLxJGMIXP/5dkLNUX
	qGyVp574VjAXzbj5aoJ4roj+YB4ayZW4kU3H8nsAyQTUIcOpEDHJCPTU+O2Qn7fFe0yS55
	UIDLsbcnxFA6HUgbEVPCwTepaeen3NE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9878360120;
	Mon, 26 Oct 2026 03:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E1551F01825;
	Mon, 26 Oct 2026 03:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792986383;
	bh=SsagISxi0qI49SXgbaqHMJnTeQEJUrT8R+ZKkwxfnp0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=iud6+TszJtUxwQspZzhQJExY2oUs0SRKiAVJRuYeyMY888SK4n1J/cPhayyEBa49Z
	 GzGvBSTRFNulBVdbYyW7iqx8xD3/CKxIollZV2+drt2bI0jJZon1z2RwNfE4vLfn5F
	 ruGwELzQTvN6dtpXXuDHIobBILCWZZBP9p81GptuiJtyLZKNWc9PLvj5Kk6LqKiA0v
	 MBZm+CtpiVK9102vqVPyc0Aslg6kzisyiKr13+QVNCB3FuopZOi95G3C3El+qD/++b
	 sdk7OwJ7f10ylC9KapC810uIq3HwTdv2vcsrC2Y9U8SjTb0xRwadD4p/lAo294umHC
	 bEpC0mYkM8YYA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 447C939EA761;
	Mon, 26 Oct 2026 03:46:23 +0000 (UTC)
Subject: Re: [GIT PULL] liveupdate: updates for 7.4-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261024112228.3384682-1-rppt@kernel.org>
References: <20261024112228.3384682-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <kexec.lists.infradead.org>
X-PR-Tracked-Message-Id: <20261024112228.3384682-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git liveupdate-v7.4-rc1
X-PR-Tracked-Commit-Id: 9a6a70aefe77f6fb9ff2b3037dcf87f6dff65c8c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 126ad898a6e97fcb4c3fbe6d979829f72b8c348c
Message-Id: <179298638199.2442679.15503618075883442316.pr-tracker-bot@kernel.org>
Date: Mon, 26 Oct 2026 03:46:21 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0458F40007
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Stat-Signature: y4wz3gmmsb8jrpfwoo9p3a64479nqr7o
X-HE-Tag: 1792986383-779681
X-HE-Meta: U2FsdGVkX1/MTHuJD3x0nfOFrGrBrZguA4axN9pM504klfujr6VB5mXmCWz7PnrhsT38giGT0e10e66DBcspAnLs7khyg3pvJZfeiWGHKxXPFbRYnEGf59nAXJUPxoXpNQ/pWnn2yEqq/yShRx/KVDyHqqbGB9uubCTfAkfR9zXb/6b0NkVOLd5MDSESnUlV59uDRp4OP1yxEWcPHctCqDIAaD4jUHX1IChs0TDn9BYfp+RjGkvQlDQ36PzdSVjbTINUqa+R3RAWhrCZsodKRAROHTvjW2rDwalC4KTqC/MM60Y1Tu2RXNyI6IEB2innvwZm1hN0nupavIUZthd/SF00++zK8z3RGv6XMWFqXHcNxuZW/YDjaSGUIpaWE+EnZIi2uMmozReJjpUv8cCmketjEOLr4SAlVY1yX78+A2SwAj6OGM7Y2CeSQqz8Z/LzcvrDOtclVHbzkcA9Si1EScCvsQ2r5ds3c51D8zBlHo3uZsbRRQyLQg1nxxmXB/OQvnljRF7/JDc4YeSZB1C+uxBPtrgx9Vs8xuWn7CbLpW+q1gYgIFHp10juhHELcPp7bdsPoDy5bS51Vdjx64hAyeJwxZ2DbC2ZJIxLPI7jPR02FjmAiunvdyax8OmthOlIKt9TYGgvNO3xIsxLHD9ysFDaCPHJtUeoF5cA0GekXZKaJw3vKne2tPhahCDZusvlamKpovxnfdwZC859bCY32K4vugGj9MZS9UxurBidkfMEII4YP7/vM9I6Xu9jaxeY715dJ4gBUX0Lu3lCv69E4xJguF8Jyk2yB+ZX51+GE40WmaNe+ncd3yu3fwVLr94QzVjd98QPNtcgdXBeCpyGz2Vc2W5t3bB1uzlqLZW0KLWnbAqeCVxkQnBXx6XILeovmYjhKf9LpT5uw/KOGhIfgltkRG6nJPi2ib3D+4QdaOAMKXARC0keJrwYnbZHH2QdW9izdTYBwFcRtNZi8N2
 gfLqtuA+
 3o6nTpXinDtG5eOJtUHzsfsC2z5q25on8ABLgLUO5EoOr0wsTs9DLR3fc4azHgq1uh2XUtjLEQHHbGq9AN0KoouDsumRh8ILjHtscwvgIe2fftnC7F/y8/KIu2TvLSyETJGNy1wdRNYvDQltaT9vK0/dwh5LX/30dN0qpYz63nZ4uNCpFvCllENVZ3hWy8+2rP4oWjUWQ8NqIJJYWd6LK5PGSqG9L6JW9pJwQjiUZpPlHaS4N6lPEWmXn7bltf1ktzaNFDbKexRPumDj6f+ZZ8+e6OYyfOM3y4kE1qG8dmO0u9PxYskf3Qxej1vogekh4kZkRt6OpbpSOgMoW7NEN5m/GostzYaHejmLcm92fnYuh1m4hYdDrabIzc6Uv48DPWwP9Bag+aQLpY888AUBy/HjVj3htnQjF8Id0iZ+vZRj5ssLmKEFy0BzwLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Sat, 24 Oct 2026 14:22:27 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git liveupdate-v7.4-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/126ad898a6e97fcb4c3fbe6d979829f72b8c348c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

