Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D6BDCF3966
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 17:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8040C6B008A; Wed, 19 Nov 2025 12:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DC136B00DB; Wed, 19 Nov 2025 12:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 719696B00DC; Wed, 19 Nov 2025 12:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 635B16B008A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 12:20:11 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88BABC0579
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:20:08 +0000 (UTC)
X-FDA: 84128019696.14.0FCE84B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id A13CF4001B
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 17:20:06 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4ln6eb8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763572806; a=rsa-sha256;
	cv=none;
	b=GjG0JPLkVXQ9YCIJoXe/WyzDXs+/yC1Xc1dGAwkYxvIHvi7wl89v+pqO+O3YEMIJe65yZj
	fIoJftYsaHhd/CMd2wiN/YlJtTE6LMJSBkaYTvrBGdwPGjCVkoSCnq0Ca0yGIXtjVBtCq8
	j/HgGrcSqaFrE0d/nFbIRZ4DvSF06e0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=g4ln6eb8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763572806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=j0YrCDAtKA2xQw0lDAjRI5tHvJWpfMR/sVqMNMXIbHM=;
	b=C/+MchHzSr5wdDw1YQ31cniAQIPB5G9ZQk0rBnziSvp7jmBwNen8aGcov4CUIcW01YnA8T
	Gmxg4DLt4w4KP8RfiMtorihKSTiabQFEACRCBLCWD05ZlSZssD1JKiI+XtFvq3gJfFmh4N
	wqXpgEuQzJHCogMe5zuLW5xX6XJNBuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C874960171;
	Wed, 19 Nov 2025 17:20:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74313C4CEF5;
	Wed, 19 Nov 2025 17:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763572805;
	bh=pWWEs4qJQNrpo7YvIBTYzqinP2ounh9QoHC0gVtEh9Q=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=g4ln6eb8kLq+X65Z989NqgBo2OJB7uUlLjMm1C9sYl08z1f/fU7q7DymIS3KHCnik
	 fzkWrXjn+qYpIMdw4zmI2UKW3//xj1t2XnB1+HUKyvYSGkFqmQb+IwTrbHVTxiC4aW
	 NOlFBnt52hEVVQ3o7s9iw53Wis1JEfiQAiUHr5fmZaCW6AEMnJoxHrpLctPFYqLEKj
	 lAiCynVJuTezYKasCsL/sldJ3PaKkZJHP9jqK5aimGmtXSDm5DIVIvrIPDAtkW6jOj
	 KngLhDOj9szXv7/QRXyU/CfgknnQnWEnxSuAmwZh3pDwOKML9byj5h6EWONFcR2i4g
	 mBOl1u9M5V23w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 711C0380A944;
	Wed, 19 Nov 2025 17:19:32 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: fix memblock_estimated_nr_free_pages() for
 soft-reserved memory
From: pr-tracker-bot@kernel.org
In-Reply-To: <aR1s8Y4wP1E6-dRR@kernel.org>
References: <aR1s8Y4wP1E6-dRR@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <aR1s8Y4wP1E6-dRR@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock fixes-2025-11-19
X-PR-Tracked-Commit-Id: c42af83c59b65d01c0f7a074e450bbbb43b22f0d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 2df79e4d729cc67395db2fd6965148fea0851898
Message-Id: <176357277094.888478.3778456531491359165.pr-tracker-bot@kernel.org>
Date: Wed, 19 Nov 2025 17:19:30 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Akinobu Mita <akinobu.mita@gmail.com>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A13CF4001B
X-Stat-Signature: bqo8ja3gneqoj3u4bidnpgi45oskm696
X-HE-Tag: 1763572806-225006
X-HE-Meta: U2FsdGVkX18vxaYjhv/gJoY4nT2YbzquNoD6bB8zI9QQAv58WciMWqjVwt5JR0mwAYprij1k7UCcrHQ8xaoWhzHnOhHIyIYtSay8B1hONhdCxewGzktcqeVPkBfsnhJIgiWB92kdbaaJSLZzW3EH/ZwEpvUr9yVNLplFAI5tcvkjWBO4Y9Ji7KIVMKXWfTqNQoX5/u1KihEWs3IQLNsWlwVV+vaHXZgDwvzrjYcoWuPshe3aM2HXwKzAB/RYa6Gw2okWjeb9uGlPsgj3FaHFsjbnUCu3qd539K64bo86M1hT8IlxC0zeCaXNfu6Qkx3YGhlw6YtHwFasf98NHZrqlZkviOKMB8lufU4alCyW8HxbAE0PQdwnKr99WCB3/ZzcoqeRwWIkIRdTfbo3JXocoim0PbHbR6ai5MNgUYUOYeuCUmOq/V4irgjVcQQfWKV15oWTDJbayJRTOjOjDSAR8XqjEnlzX7GCkdZ8nCbkhKPHkxDsGWp3sloVFqlwa7z1nN15wvZnAVPw98RlpMFkVrUoFdsdMzplrOwSeVLzQzgg0jBlrsMfoi/n4thDrN77kXr8/ioZN2FzIfLJMfQnACf9TOCILU7/P+9IydpXDr180W+n6q18E8sCcFXLLZLtkUEsejS78Nim4un6oVS02rYgLtsyG90RqH/tgFVbsZvmWD6yt2uwjBGE8JdYGaqFIP5AgZM59BiksK4EBYvjeaR1C9swwbggtnvOVB2WYhio/HldcH2clPBxz1k2ZcuLV8gMUCKdu8Em1AKxgu0CqmEejkC00Ud29peg3m5h/nqV/bF6rY8yjGEEgzeGYznNSKF2ne5bKV7ZNXVRw0/2oKrrLM/nrGFdm7oZ/rUpYvm0QVrGS4P7rPJyRqIS0570Q75qnnx+TL1vZ+8Yb0OgFanObzwKqBc2ZsmnM89A3X7mxXhmNx1xx7dgNZauRrm9l1m2jiHofrAUh7Bctw0
 Kt3hhiJ6
 jchXajbIwk6t/L/m9wX/E/b9ay5ZX7WV8smBtPX7qwFyDDXTE+hHvPrz0mYEe9tmYi6rKDYYm8K9SL+gmH56PEE20fKDei4Cg2PnsovEG4x0rBrYnOSDhhdf59exyH9IjfxN77tfwT24h+qB6yAMmlL/fZHRAlcxgbfIr4ZbHygTiCvw/EiZpzo8zr2I+O7YohCTnQAB05fWfokDNXLwgDL+x3YT74T+ANrKQP8cyAziFafGC1IzJnFQBHYV8iTktl8HKnZ36ZDEBZcPk+c/D+or+u2Q+wzXtqJlufkbN6AxSO8GEWfdwpDRB9b2qgn/NTAipABuUZCtBcRH0BkCCgKrVr9J+UXNt92eR/1MaEBcEjabGO4b32Jvlm7X31WREj/bSNI7C22ZoQTg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 19 Nov 2025 09:08:33 +0200:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock fixes-2025-11-19

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/2df79e4d729cc67395db2fd6965148fea0851898

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

