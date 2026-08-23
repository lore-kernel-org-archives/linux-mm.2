Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6BC7C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 16:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 258B26B009B; Sun, 23 Aug 2026 12:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 230C76B009D; Sun, 23 Aug 2026 12:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F8E16B009F; Sun, 23 Aug 2026 12:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E04906B009B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 12:31:03 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5FC51120328
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:31:03 +0000 (UTC)
X-FDA: 85133073606.29.96AB96C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8C99BC000C
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 16:31:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRAAjVlE;
	spf=pass (imf28.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787502661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=QsDNIrgg21IWpYyBuhXQ4f5JQxGbAnh20UiPJbJBuDY=;
	b=tHESnEqJb3l1yGTcMQ4PddZlStI3nlBqn3odDKU8h0klAO6M2vmS6xtxZv7x3tImBMBHjQ
	fICrFYkk2bYwL2QyJIdri0y1VK//vrUQ7SLG9h9RLYwEtFoJNaxsQCUrDTmaOHgWZz6Su0
	wMuFdmSQpkAexHL3Ag8uReDIkT2iLkE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787502661;
	b=u0TIm+AxiVvMvFMJiyMG7V63u+4z3LpQeZZt2NiWxkhYkX1F5JwWqhhjPNQJ1OpRHmBsGM
	RY5hDWKxbT7snjmX4v5WR/i4RhIKCTypStJ1IcCHq21WlfcBXOEXUrKDazl0HVo6k8+0iE
	k728tyiqIAqdACjmkjY0NVM2baCQhYE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRAAjVlE;
	spf=pass (imf28.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8B8C040196;
	Sun, 23 Aug 2026 16:31:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6718B1F01564;
	Sun, 23 Aug 2026 16:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787502660;
	bh=QsDNIrgg21IWpYyBuhXQ4f5JQxGbAnh20UiPJbJBuDY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=SRAAjVlEN20R3dSf6E/eCUZXkegG51hHZaAIDYRP+kHVVQeoqCcQHCS1ZXDbPpyPZ
	 30HAdphU0Is0lnMIc8gU6EaJD2dpcf9vhYUt8omKgSCWXj6cknV+ddERVghXDey014
	 SlBCGC+/BEtDSmLFr/Py9jQnsCvQm7IqSUeon4L5Vt2hg67FIImehuyA2PlVS/aKUJ
	 MUnwW4T00IsNhUJr57UpyhZVXlkWJTSJSPcTaMfSKWNnwEPYCXRwUv+dgJqz/OhIry
	 j0c3Lflh2bV1JryZyE59eKR9juJjzsKsCj45XB6kji/p+eqwrNDVFNrbn3Clrl8Gex
	 L0T/2y/ZjFduA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D156D380AA78;
	Sun, 23 Aug 2026 16:30:09 +0000 (UTC)
Subject: Re: [GIT PULL] liveupdate: updates for 7.3-rc1, part 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260823133634.3570153-1-rppt@kernel.org>
References: <20260823133634.3570153-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260823133634.3570153-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-v7.3-rc1-20260823
X-PR-Tracked-Commit-Id: bc0f793c5c41601b273a2ca64c768adca1d447f5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 91959a31a3990073b55b506af044eda09c359fb4
Message-Id: <178750260860.2078512.2539370660916433944.pr-tracker-bot@kernel.org>
Date: Sun, 23 Aug 2026 16:30:08 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Alexander Graf <graf@amazon.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Stat-Signature: qdu7ma1tpjkbgio3sd4kbr5m9hi5x7iu
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8C99BC000C
X-HE-Tag: 1787502661-348079
X-HE-Meta: U2FsdGVkX18Il3n+5nM4W07qIM/X1A6rPSIHlRwHnwnxIeRaQdIXP2CiXR7sYZwcXexpmsNk6J6R5DiA0TeQ6NElcegGWAeys/Bf6G4eAUa7BONqoYYJvOQFAIpTbKcjVCnN/6yqeqdPcMHyVswZ/zD4ZvDHR6gwXU6u+jnAEWrzwlzKhaay4gjQseDt7lm63ACwDlkU8YlrBHWrpprKZrw8hvmzSA0z44qIhG9Cu5J2YeeNUNmupRCHu+X4DUpvJwLaNwAO9ZGvWjbw/bBYq5ZEojl+TuBH70DiwT5hZdjdMHFZchfmtm4nerToVvJvcEwgpEn+noValkKGyhBHKgIJYASp96xGJaVXvjBTyVYLKEsu0XmnX6arcDbhrsPJ5kvd8qbsttpHrEi581adqAeK/h+fnJxLJYZhMsiyUK3X9Z1cSYLr4kUYgj9inv+Bn4NAHfjCIl7XO026XkpzAhWmfBXgXqw5bqtjVpPIciQm20t1ySCxpATMow3Mh4Ybuksnn347XzEPZ9n3gH5Ea7o2d2DKuk9GlfnsH030WIgwjQBZC6EvNUWoi43pZ7LsMrWoZ4J4e2v7eX/sMWiqOgnoVFo4vKVdxYljjHdyWZ9BLTBnpYW7R2Sv59ufca/GPpt2aOVdN2KtK91R42Q58G4UVjDY/tRIHCSn24n3zpR0mjTQ59k3sPBNlIBvhmo4CoAlMVixiN1dh3NU+Xeat5OeVTmSSplzic1tNqzLf5LhJpKZe94S0N9LsUXN7kVsOZX/+FuNwkfII203TboimG0Gl2+TpHdNGSpe7TihXNWgVnnqF0ysTOvdBnkzwboa8rCkMSBMvt4skd34Uov+wI8KDjSTrR5qja35YXzpRzYN17NBTIvUbWbP9A8B9bkL9iwDw4QEZ1WmTYwFkk82T+smqNcnOdHvkUu+YXVvqN0FWVpRXiAgg39LESsrvlWWmnT28ZvMXxDTdmAoTgE
 vdmI/6KW
 SqM+uYULWA+wm+V7O993kDL7zIJB3b1TxsBPs6shI7jEB2lZDrKWaD1i5G2oDj0DjrQ5Mm/V34hi505vGYpzhDIWT+Y/1Fme2uugyQ4Ur2qpzPA4C3I4lK6Ru4rzqth5ZWHvZCP1GtFjx1pZfU4p0nuOSfjbyLMxKO1vufLsnO8d3FS+ENWC4AQHcStF+gdIhOAvGq0RmFsrxJ+EQEyo2NtwG4KFKq0Eiey8rQNoB0X7muUwstmhC9eRjsk/IT/11hfYT6kJdZYBtXakbFS8BnuwJvM3H8lLLJFBxIIQXLLjDBGvickvjPH/2MMNKFO8T8uil
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 23 Aug 2026 16:36:32 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git tags/liveupdate-v7.3-rc1-20260823

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/91959a31a3990073b55b506af044eda09c359fb4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

