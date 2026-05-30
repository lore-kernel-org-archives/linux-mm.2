Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC311CD5BD0
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 22:43:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 228C96B00C7; Sat, 30 May 2026 18:43:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 200D06B00C8; Sat, 30 May 2026 18:43:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13DAB6B00C9; Sat, 30 May 2026 18:43:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0684D6B00C7
	for <linux-mm@kvack.org>; Sat, 30 May 2026 18:43:45 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9B5FF8D90A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:43:44 +0000 (UTC)
X-FDA: 84825564768.20.D39C1C7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7A5E180005
	for <linux-mm@kvack.org>; Sat, 30 May 2026 22:43:42 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EA9b/79V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780181022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=fEA+Q1No3hdnuU0k4mLoh7smyxcJtjxVNRQcVo9O6zY=;
	b=E7zon7/G9ocm4AaTGQB8wtDc0cQgS86PoxAAZEba2IQoBx+zIHd2eCvQaRVqFAyT4Anj0y
	m0UOKekkECLugQaIMZ7ooasoR/X+QrMp69zjK/EXpdQqCRoRjC0MtBlwlbcd7VJIMTAITw
	RQHGC16UaB0nfBRTYaA8PEkE8NoXus4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="EA9b/79V";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780181022; a=rsa-sha256;
	cv=none;
	b=tXmrI8icP2LB5y6XF/JDyyFTjCxDx4MXJXWzFpZ1kUCgbfuRzLQwNOyYm+apyHE/c0sNca
	qWQFWm/VcnSp7dB5LRXryiLX/QlSR+kFUE4QolVE78nBzVsQdxlwG6m/JaYr4dOwhvBcoI
	1PxB82SYkyKev8SIi/I114mNEiehfVQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C0410406AC;
	Sat, 30 May 2026 22:43:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CB01F00893;
	Sat, 30 May 2026 22:43:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780181021;
	bh=fEA+Q1No3hdnuU0k4mLoh7smyxcJtjxVNRQcVo9O6zY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=EA9b/79VbdML1zbqGIXHErINBIVmdG7nDiS0l1HCQZ6Lub++GSBwd8KPuT3OjrMcs
	 N7cD/DrhOEk93PNpMnnT697vuzh/7fMpqPV0wd0McYOPB8Zqu8tRu9GizVdi37zsSH
	 wKbIZ+zFzEllAJIoORV9sCeQs5o/shkjhD2jVLUpmKVcRQYRidE3oKbGKN2tRdtCae
	 Tp+LcG79WBvHYB69MbK/KO4i1D4Pb+H1CTihpV4jXJVfSF9C7ne9qTQzjPrMjq7bmS
	 ZjWT60FzeEkKc9DE0egXyL/5D9er/eoAs0NCeRdlgwTqe4SCGRDf8Yo5XLLNvEtbNB
	 5Ii4shX+KpVOQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 19D5939302C0;
	Sat, 30 May 2026 22:43:46 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: fix regression from memblock_free_late() refactoring
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260530164044.1428118-1-rppt@kernel.org>
References: <20260530164044.1428118-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260530164044.1428118-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git tags/fixes-2026-05-30
X-PR-Tracked-Commit-Id: 7c2eee9c136734825ff524dd8b2146438a4f8250
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a29c0b0cafc78a45f44ac4a98efee0c11dd7996d
Message-Id: <178018102468.2731103.2487606304363243299.pr-tracker-bot@kernel.org>
Date: Sat, 30 May 2026 22:43:44 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Breno Leitao <leitao@debian.org>, Waiman Long <longman@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Stat-Signature: 769iqwoq8qudmeepzaidofa5g3wezjpf
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C7A5E180005
X-Rspam-User: 
X-HE-Tag: 1780181022-664750
X-HE-Meta: U2FsdGVkX18mwgI2rVxD0ZOea5gocufWL77oi1um4Ssi0gRZqN7i+aRTIsXVUuy8nZ0qpojcbNyl5Lc/72xhrmb3h6A2S29BPlozQuWxiFODcSULv9A7iCLaJbLD5Y7aO4DrlIwBFoFhTl7Cg74ofpiMbhTGJSoXPcRqEHNrW0DhE0nuUFLaiQNxoWBnrMh8yprNPnppe5F8Obl744M0HNxgEAHuyt1S++pLqGbEmScAvGgZ6J2XKzmsKaFbuQDhKBTER+JicpAKbFIRUsAjc4elcS3NDLEFqUd2jCA8qH0BdCiUwVMWmr11FRNX7HLBlNPPbjxbOcdFJPY1rpyTFf2Ebk7FQWwBEj5x0tez7XgBHU9xWBUOpkq6cXnovvXMUO0rnh7w2owEelqDT5zU8C85xllXte2ZyrWrVFKV74+zlIXpnf6jT9HyrFy0UMfyjRkvHFylNtrLBegCHm7kkajkwrbqQdntfho1iBy35+YQyL/UrYGX8V08ucrqR3tgAmBaXJBWf5AzGQIM0jZuLUDEmMTDMX21vZ93/BCP71FtHsZN1c8R89KUsyDMpGVZ/6YvwgckhmzYfRklEXEOLtb9vHgW9A2QEx9HDVtOVxKX4mPhZdB8GY/YWJe7/N5IezI2fcxJS4S2kPNu7oB3WjDX6eLRmUZnLXzbwgJ9Vo8SeRu99zqNXtS6sCAy68xh54mJZ71AfdwBCkziNHua4vb6q7P/9rwIhiYt5hejlVrz9tlNPPzeDTzr2rcvR1eJKTSZ1tO/zDif9hEjJT9Q6ZCeJlFzybPWr8EKdGhm1RGySHmD4OMkCGuw7rHTZmQaFSqQh5zxZvcFyymg+Vozou3v4Lfv63oDEeMWbAAc1p3JyA+lpvi7s4W99fJsos0r2o/Y/VhkTmXiMTScJVRdjXgv42IX+4piDwjczvus2vZN5CTFHzuRlsO9ohmvhuyn7w3mgI0utoh9zd1zxIx
 CZeqKPXB
 j78089b8g+vF6WF412BTj8KkRzEwm4Q1FamY3nFDzUfZLf8b5A4wAS9me2WhP0cI3JandRQprY1Gb1IbOZEAzd335hDnQdLcU46KR0YbXpskUQwiYqhjjNpx9+9oMlsPYDLNRkxUNbjbbgc7luF0BkMlO2FZCrPxn0HFy01alKp1vuzieJz56aBCOr1vgshsmGIVi2ro1ShwdCahy3cq2B0+M38jQEsXerV3E1udpevdaQzkWGR29set8taTRJSbb1jXIcRtT5M2br2l7F8cd1wgRSfKleE08G3pyLEeIsIitH9ZbKCDIdvaB/0wse49295TIoFdZaUc2Q0YZYcS55K2ZM0RcKfwjrayb7nPq2KJwayvMwhWNCSo/4KKIsooD2AXIfiVKfeJzVOx5BXFItVHHWT/KDtWBL61+qhEqm4HRTiyEXWjWqa0WHeI2xtLAt1N9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 30 May 2026 19:40:43 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git tags/fixes-2026-05-30

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a29c0b0cafc78a45f44ac4a98efee0c11dd7996d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

