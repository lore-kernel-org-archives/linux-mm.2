Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28647CCD195
	for <linux-mm@archiver.kernel.org>; Sat, 18 Oct 2025 17:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E58A8E0005; Sat, 18 Oct 2025 13:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BD5B8E0002; Sat, 18 Oct 2025 13:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D3098E0005; Sat, 18 Oct 2025 13:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4A6118E0002
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 13:27:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFD651602A1
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:27:21 +0000 (UTC)
X-FDA: 84011916282.02.13E6BDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5B7E6120005
	for <linux-mm@kvack.org>; Sat, 18 Oct 2025 17:27:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fEhlJ9b/";
	spf=pass (imf29.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760808440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=HT8VMvGx65FVUedY6PmToesbhsbEECSQN3kI6u1Oo9s=;
	b=JCoMomfCk8pSfPIiWC28BxhMmzcog4H4p86u4x2+fD/7Bd0N/TQcjqdXHGJXzoiCK8y9YF
	db4Tu5zidDPtP8y8Uk5g4XfZdyK1Kzf7pu882OzNazZlGs0qe7CpoId5a+C5xZB+tLbflE
	kZF4sfbf8Xi9Lgm4YtjLY0lL41Nrhkw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="fEhlJ9b/";
	spf=pass (imf29.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760808440; a=rsa-sha256;
	cv=none;
	b=a2znRTTqx0RVYzbncy5GC3UYaRCnCBlIFW2imzCjb1BnBz+HYioXQqk9APQMOMWbBFFKhw
	SNpOBoW2rH+fUR68t4ImCry5IapyYP3yUzIN1FkNURRQ6bWs+KX/cJutofuynxBtQdbr3G
	gZ6FBMKWFJwRLZtQo3u6rBvK+P7jeQw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A8A4961159;
	Sat, 18 Oct 2025 17:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 566B4C4CEF8;
	Sat, 18 Oct 2025 17:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760808439;
	bh=QmGTKM+RnLzBjvWS1gV5DAi0YFvYn3gGyGoJRYQfhR0=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fEhlJ9b/l8YmQsIkKzTKwFeAj0QJiCvwYNo5+b9ByJBD6zboqUfXDh3NX72nUZ75u
	 c5IQ+JPU11I5sUg10q7kXWmEQph+idqR6sWZo2LX25sZjMvbHq6TfG8sATh9UEur0R
	 CllMK9iS1Bmgqu351rmkUuPVIVNF1CWWX0Q2c3h4Jh+nme81SkUGWrNFAxoDaq/tRw
	 iQGtoLDmKBeTr1cP7+sk9vhDpjfP8P15RYX1hLwzsmAxc8SoLf9H/UhQIPa+EV9OI+
	 k+S9PmapntNEqbCISCbCjw9RFEW/Stl2Vnj1jag6CGv0UXDMWRJIpgMmU4vzfol9Tu
	 zdhTZ5OkSyQNQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF0039EFBB7;
	Sat, 18 Oct 2025 17:27:03 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 6.18-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <a22d61d0-9291-455e-8aa1-c19a4574d772@suse.cz>
References: <a22d61d0-9291-455e-8aa1-c19a4574d772@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <a22d61d0-9291-455e-8aa1-c19a4574d772@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc2
X-PR-Tracked-Commit-Id: 86f54f9b6c17d6567c69e3a6fed52fdf5d7dbe93
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 959f018f97e63fc188c6a7519baa6dc2d1248828
Message-Id: <176080842226.3050468.9795521680348275739.pr-tracker-bot@kernel.org>
Date: Sat, 18 Oct 2025 17:27:02 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5B7E6120005
X-Stat-Signature: 88k8kom34arhmza7kbgrsfyyp91fdfe5
X-Rspam-User: 
X-HE-Tag: 1760808440-61285
X-HE-Meta: U2FsdGVkX18WL4i0oo5x9lWQ+s9s5SkWu2c9YfJurqLkA1Hal/7t/dIoXrCA3xCVh+wEEMX7lmfHYxLInhBDZze4LVc4y+u2Y/VA9hY1HiBzo6i3y/5KokM4SLHFaA46onv4t2RpZYPYasCN4GcJQvy0LL1YiIxcQuku8PdCSCMfn673DJ+Y2C9ae3MtGUv6fKCPcZtIDWndemniyK+QkMLzuYLbKnUPfL18pEq7gHWatlNsoOMlsVjLEpANcr+7+BWoPgJNUganPR4mBuqfJG67JAoLMVcL8bA41fd1wd9rHwHngKvMdPom6asTKJDkGgXTgeoTosc6w1a/I6ORxwQ449xZfiBLxlICpqO+Ml0pvtj8RXJ1uYRm3DoVsmsfb7TloBeCgHT90MOn90MQ+jHPnl8Eo8vUtA3TBcwgF4JUyBtujqOPAWHVPWT5az0xTWRRaNFPH7kBEF8mSz/QgC+tEZF3K06f8RvKTSSd/rAKE799vxtgsn90CbOgivQfJxnoOU6lFFVZbPLEuqEobzRde33fSoMmp7we3K+7sGdiP6p4SjSl1m3bq0S4f8ZEbJAxljr9+3RPcu2KtP/bQVnK4eMzopDByxhpO+x+kw1Guk5Z6MzuH6he/3tPH9U/N6/noijLuWlgtF1voM+GA0j/2oqOLoB5XBdPQNFiOsUsJF5JwBPvQtgLX2paaeaEYR6w1X83kHC0rZFLGtcKUiZC3EnqtxMlmPPRrHub403Dwigchg987UESAs6XLp9Zilfh8jk35rEqAIOcNuF1+W9Pwwx7uCTEpDa6oRHxES9o1BfXZ0FhNy4f2pNPXnV+2/73bPmSeULr53wjf+pjU0BEq02t1wT5fD6yCqALOpv32hfeEmjxozBwqC2VGlUbY96spsuOZDgBfQzf+hdW6gYsBhWYENn71HlNp/+/44MnB4RQa8ekbeIr8cJt6d1VHZUTa6bDIrnLRUYBuDO
 vkKVzxzQ
 2/X8VskKDBhtRE1NtuKU7Xy9+HklHJe6YUV6Hz4ww4FIyHkx4EAMuTXrvmY+VKzDHUAiuwU8IDIC+YqlA/2RCDrFz65cVTqbtEBz1teLUO7fQDx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 17 Oct 2025 10:49:47 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.18-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/959f018f97e63fc188c6a7519baa6dc2d1248828

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

