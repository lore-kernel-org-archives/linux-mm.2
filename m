Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75C18C5DF81
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 16:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31C256B0095; Sun, 23 Aug 2026 12:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CCE16B009B; Sun, 23 Aug 2026 12:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E3376B009D; Sun, 23 Aug 2026 12:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F288B6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:31:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7CE93A32A9
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:31:01 +0000 (UTC)
X-FDA: 85133073522.11.5DF89B3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id B20D640004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:30:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Whfp9XBU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787502659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=zSckTnyIbH/NA5CO67d6i3mvcZ8WMAnIAcorZ5eX4AM=;
	b=IzJ7a8hVqY7ZaSI7rxabmd4k/5ssUub2i/8/ywE2Dq3llhf4RC4RyaRlgmIvxzKSHmQp+W
	BkvQmDcNQlZ+YHf9ir2US/oPUOd6IkxwydbXVTd+uDzBkRXPwtlZfhBgfxGkjVARt2Hs+o
	gO5UgJv16nFHURTlAr6obJjFhIXx0vg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Whfp9XBU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787502659;
	b=pqQv8/CYz3Jph9hpDctpoMZzf+5t0P68wAfYz0rxQXzpwUumcI4yGyV5cnjC2fUCSDYEZw
	gesvaMn5AMjREgnyEFVZOw5ffzweGNgvwkKMSQ/fSoL7R1VpEDfLgYw7zA70p9njm99zj0
	8G7lbltUYX2BK0BIxxqTFrKy+jCSILk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EE2C960055;
	Sun, 23 Aug 2026 16:30:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BC5D1F0156C;
	Sun, 23 Aug 2026 16:30:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787502658;
	bh=zSckTnyIbH/NA5CO67d6i3mvcZ8WMAnIAcorZ5eX4AM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=Whfp9XBUNTPzRmBYYYOkoBvC/oOhfgY0shRcyKHO27qTXsv0ZsB/y30MRfq70NqkO
	 uLnZQJzpret3nO1H46hNxRXOeEKe91bkghBrdbACti26mncfrT1fnWp+8+7q0DCmVa
	 uLzNbk03bjOy4xNhrlt/P5HLwbHQClCFdeuqVGOc9J/b8ZV+4s2WMJwIrcmTRWligA
	 URC24N14WBiKJUhvIPGDZjRCKqGGX8vdmnoghAUuTAzZRCCgvDJALP7hFNkW3aY11F
	 qErGYxZfYryEbyV582yCYsXIcFpTqO1gHykZGpAdPMVIB2NMl5Dru2w+vXz896hNV3
	 4PuITQONggajQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 199DD380AA77;
	Sun, 23 Aug 2026 16:30:08 +0000 (UTC)
Subject: Re: [GIT PULL] Non-MM updates for 7.3.rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260822170728.415abdaf6589f2849d6de871@linux-foundation.org>
References: <20260822170728.415abdaf6589f2849d6de871@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260822170728.415abdaf6589f2849d6de871@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-08-22-16-57
X-PR-Tracked-Commit-Id: eef628bce8e18ce1eb8531c396bf55e36f86c62c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e5f92606156a6a823992294d214c285b49cd72e9
Message-Id: <178750260687.2078512.3571703151903804032.pr-tracker-bot@kernel.org>
Date: Sun, 23 Aug 2026 16:30:06 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Rspam-User: 
X-Stat-Signature: o5ni5bypaasjwscks5ycea18ctds5ezx
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B20D640004
X-HE-Tag: 1787502659-746916
X-HE-Meta: U2FsdGVkX18TgY0qCG0OERgaSrODKxRy2wiADWafH5vqgMYT/RQHgtkiJDjNVlj31aMaGpHxmPIvYTfeT7EMgO9krnnLE9Mv/C+USItAkNJ+6pnHTrgqtNIzNRrweq/NV+mwSijGu/PhnG9hK05p6xpXwepQj/Q4Hb/uZwdoHgagWPBYSy0C5BLv6OW32RH1Hy/aCcFbiDSqrkpt5g/e07Skzp0+ZOFDIEdg0uCEfOaPE0zWfuwtavJnbSXT5EqBdVBiJRG1WL65TEy4+62w6XgwA3aqYO9VqGfVYbkPeQEDsO6GgwuuaD7qOQLlaGDPUKQyr+D8EVZBHuGBMrisipD+M+e5aG0mLsUYuCtiLPD8QMj0TClUP2hy9KfJpUDCnDDZg1OqZu0NFkpdbfLK7byWuHyjEIjImY5kwrFB1lbaFMyZ3gcouzQBsGWLCTgsXICAqEWzkQvvp5P5Ni1bSpQ+HsH3vN+ESRyXB+fjcGgktMn5erp/rVaPRh/iI4BJRD8jMaf+wG5M+07fMpxkvzks3fypvfSSECJADYHHS7BZX1Xe6QoJWpuXgh44ZvHoKBD/rrkAjFtbUC89dg9Qa81LKO/zL9dBxkgDarCJYB/FOgvWXkGFKCdX9hY3aUKiUgu53phGk3ZbT6w5fioamlP2qko3wfN52WpO7T2WpihJASl2UJbINmR5hMTGFFskUqH3LtAozSJbVsDXRynCpWD4TN3CjhgB7JbMmLhaGnVgRMidLtH23Ufw1G4Qqn2UCPOJ8ovFqARQbWdrLpQx8FDkA/OGippC8fgUIjS8VWqvPcI4qS4Qq1EBVZOBAqYuwvrIOABlCbMnToYEvk88qBYX3Xd8uuZhraeoJCzdrXYhY3Hpv13cZcCWv+43ZyfGZ1VNc1CK6QrOGA3OVjMBdpxcg2VvFZ9laWQczTUtI2Yt8+pUVyoSJWjUrt89fd/PEPV2Pk7Wu9CXKhp0E3B
 ATqV3kSI
 q0bnJcQA9Lk/sMdtQvDgiiP9MwvlB6L3raciYTV9vhvmhls+Dwm7y69+NYOSDnXKiJXmqHUPfVk44lR/DfyT60GD3isWIlpnJa0+hOWmG3Y9GQb+37pJncrp0SLkK70sfGRCQA5YoR2QzzxbnGDROT1loNs3Fszv9+JvOV7duzVUM7n+igOscYZoJgiluTXOuWYWvF6fm8wbemzY0qbqV+3pHt0ju06gilrml7Xaeo4YUZ3eZ46U6sWDgJxJp/G/yGEQN3C1xHjGukd06nRXZo23noXOtwAgHhXXrR5ANnQIQh/eFVy4xaELm3ppxi6Vzcg82avySbnZ43a2U80NRkLCoIV0VEnGEdvgBhVS0hNHFJqzI5J5LwBvlXgS9dLAktPEnDvae62EgPi8wlTxepNUoVst/M7J4nrJbh1GBkyUQ1y7duPob9oMm+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 22 Aug 2026 17:07:28 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2026-08-22-16-57

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e5f92606156a6a823992294d214c285b49cd72e9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

