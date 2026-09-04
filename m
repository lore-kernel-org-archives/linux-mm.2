Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93150C79F80
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 05:51:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA496B0088; Fri,  4 Sep 2026 01:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AB4A6B008A; Fri,  4 Sep 2026 01:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C39B6B008C; Fri,  4 Sep 2026 01:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0EFC06B0088
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 01:51:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C0844073A
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:51:07 +0000 (UTC)
X-FDA: 85175006574.07.17F4F92
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9FDB5100004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 05:51:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/P4mY69";
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788501065;
	b=SiEj3PXSoxRdQASfjKsKcJ3AcrfZZRx01at4pT1a25etl+17m5aFvLoMJJ/afI0Es7w8Lf
	WIjao0mGOv9dQ+k6DN3ZlzIgnKKTjb/iYij6YZ3FDSQjtRvH2f4DktXTtMIBBH65dA8UaV
	P1dILpR7Cq6ZTr4BMXWVQhgJWByeeAo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788501065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Ni9g+VS/7DxBWoYVJAkvr5meS+eqSiNuXWyCSs4HoDs=;
	b=t15lCqX1wZl11LzpNB4cZtGqbhIkfLe/OeIA37PVzbR0J2pMZkcmgqK1c3pXMkeoC094SV
	z8KxrXGjxWMthsj2VF6gFsjHuX9cCSnfTwJ+9NMzzPZ6KwQcagWToNuwHksqceVviQmSnh
	TP0sX11lNRj+5Wmu6iTSwoRI6jdiF+w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/P4mY69";
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E0EB760A6B;
	Fri,  4 Sep 2026 05:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96DE21F00A3E;
	Fri,  4 Sep 2026 05:51:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788501064;
	bh=Ni9g+VS/7DxBWoYVJAkvr5meS+eqSiNuXWyCSs4HoDs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=T/P4mY69d7b6hQUixCeJyZXv8seyN033qYzYvIKbUX4p7R2OQs6PETh74s8XbDiOR
	 WXFCA2bp94DUcqS3gkjsXCDpRdaRKuHgcqRBz05VnT4pfdGK7mWRbX6PWPrFLQ0eGH
	 OjsjwSkyuUzpjnmYexFZnGtX1auzkKwEqgTPwmbh97BrMHPx77Mm0ALjtvEP3lBM3U
	 o12szbDxevz7rUSkWUNTddxY9hg2RivnO0EHgD2kr23YXIyMf8ag9EYnnLuQ+0O8ox
	 KjGEaCFwNlpYNoMEL14ERHkSAL/f41M/yF8RM3RT0DqS0YwLpmj+PPQ1etj5YCHec7
	 NavJf9LyYQlEQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C3238119E5;
	Fri,  4 Sep 2026 05:50:06 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.3-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
References: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260903174847.a7f81bd5400d48cc8d0feaf9@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-03-17-45
X-PR-Tracked-Commit-Id: 97d34aa65c29cca85e3e9050f4c936389b38a054
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bc35965f6940a9bf834d54187b6088b8eb09206d
Message-Id: <178850100549.4186254.2817444267395046439.pr-tracker-bot@kernel.org>
Date: Fri, 04 Sep 2026 05:50:05 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 9FDB5100004
X-Stat-Signature: 15ztprba4g4fb7bppsn3qiy836y789yu
X-HE-Tag: 1788501065-150307
X-HE-Meta: U2FsdGVkX1/VMeoDYZaoT39i9qDAJt2slbHo3u6sXxLRaaSzEwqM9KEzIr6rQ2w3xUEWsA6HbLrlYEuARzfEFGc+yToqk1yIxG9X50LTf4Nvawo3Tufylnq7f1MoLZrkL7UteJoyQ0T5Sm9cSLdIYeMj688JkO4SF0HY2m8pl1W2T6lmLro6xTIvP1qVeYOoFAmgTfo2m88I//1fWKkYAoLGXXcpwyyo80gEpTCli6zXXMH1G/af9rnabvqfuIXkBXjDkiAykMoRj4oXMpQoFZGDNYS5PBs6+YvN6JTG1urcJR552b0jYJ+t983j6x+UGG8CH2agI2U5niHXvwA52gRtrlZ0YLb7FJcfHFZwgxWIDBhoOwCdrV/BYWJ16GkhJh75yjEYEAyQ+V4BHf8dM6/DdzBf0g4OZQ5RRaHuQkfhhJL3OrsVdaXdVpz15pqO7xlDpd27iQYmaZD/+VtQB2e/YKl+Hc2stWhxic9h1CyZ18yppG2mq9GCSSrSE0RFszCvR1EIOcb+lDl/qBpQis7gPBMHkHJ9BmOLV0ILzYHmrQIJwOPFFXY01xeA6K0gD2O5o2Z9cSwlzQsYj+cF+LnHewP/DmBYR2Z7B+wfPnhdkAZMj82tKtMqRRXBbYCEyKkG/MVVl66JVgcm07+07xDU6kQEWj86vDeq9mgs7ltvmw6M1Scxg+n6irXntYp/DXzzCGr/qZwf+PDu5DGnHrGHWgwLGxVq6FQ9GFv3bPCNRkD0cz1o6Of1ZmFwe+3vZVDh9Tka2A5iW+4V1T2FiWtA6JG3SB/Q0pHhBL7PBBayRhUuWKQEMgI8XsA2FuFbHcErAIvHtU2/LBzrlh+iegDB0zxl008zzy/wuK+e1BE3MrpJPePgqvDeGfW/UmPiwegUN327Ltrv3RaCJG/+4a647Vfm0GIU2k9vRodH99R1C+hzvmlrK5qsaoAqCzz8R78PiB+5wuLH1o8LIeu
 yH/P+Pec
 bb6QPkxD8PJ8HdBch2sjykEDXX95eLyWI3IQOLGTWqc6AWqQgSIxZbdRfLD9IJn0tnWqEJqRCskEH5AH4/sjV0ZtZeLJ+OpboT8Z8HokhOv+ygQipuzHAdpZw2A+mcOBC1RzIUuX+1roLlyZPJ15+bMda1zh3k0UrxKvsG2iRZbe4d/QcpKj66BR9saYtcIQMwmMgfvHRU334eympsm4I3poJ1ENRXpH/TQ32uCR1OWxta1KudGL0ATIzLusBkZEEZ+aOpgeHOSU+AQprIwQbmciQ97Kc0rYykrVokYkffFfTu/rQiWIPn3JLExOY501vftHw9kWVEj49stzWYEFcttKOKWUW8AF3ljmfZS/YmeoPCqUBgg7OCaFtF578blV59n574cbFeFYQ3rD2Z1qp3ptJGgD37q9w8O0hWFrZdQpWq/3+OoqqBVcVrQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 3 Sep 2026 17:48:47 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-03-17-45

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bc35965f6940a9bf834d54187b6088b8eb09206d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

