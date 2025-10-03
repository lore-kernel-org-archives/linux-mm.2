Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB842CCA472
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 02:18:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 234CF8E0005; Thu,  2 Oct 2025 22:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20CEF8E0001; Thu,  2 Oct 2025 22:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05EF08E0005; Thu,  2 Oct 2025 22:18:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E65628E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:18:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9EE2C5A52C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:26 +0000 (UTC)
X-FDA: 83955193812.13.385BAF9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BA041C0007
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:18:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YOetLl5f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759457904; a=rsa-sha256;
	cv=none;
	b=1+D/4vj/f6jGJH+m7+6xEBmelJXSqBxPrbrWJ6btt2AieNxzCrB8vfVxV112H4hpNz5EYM
	YeI4P1AH9DH7Rt/kkPqR0r/Nc4DnKC0Y7UHHWQr3vtb/aOy4VC8T2nPx0zTD+/PnvAeev4
	oUfjEW783esJgD6gKS/URdBi1IKDw8g=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YOetLl5f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759457904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=kNyG1IA7KJucCDtwUmFnK2uaxlYXdDmqbGCjxcz43Tk=;
	b=6R6nzDdfRnZS8d3f+SxgDBkUSPnj4yQlf4Cw3cYNIXJEWOcQD4hpPuDwTXa0NdZre/nnh0
	FL4dFM8ioUx6DlJN7TeAj2UTyIN6cVfLtxfvZO+zrei5rrsXO2hrojM5GEJz/QbDijgm3Y
	BCDPIl67V1CSoZm2TxgHozqBB6wq3q0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5E155451D0;
	Fri,  3 Oct 2025 02:18:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4E4C4CEF5;
	Fri,  3 Oct 2025 02:18:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759457903;
	bh=Dc9/hZWk9fHRv7vY+ojxRQScjdcyQGHx3TOlkrD6eLc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=YOetLl5fKaj7OEU72LUSqOE6CRDtzwNw0H4yD6enkY8XcmXZ2PT9W/5nDF4T1tqx2
	 uLYL6L4T9gFgNZDOQpA0XFmMuqfku2qeU5qXpQHxcsU03jncwiJCmWAnt1SIaKjyAJ
	 JVkJZj+lZztFYx6Oxbk2ij9zdxKBKKdedW1xtWOco5b4HnyfjNf/8Tai7pf6/y4kLa
	 HWcSyU7zOYZnvFnbCvubyqaIVIYiDD8JR26XZNGesTLM5WMwB+D77Su08CKVVD4Qly
	 8YuiSSfrTS46OW0aH7xzT1hRUW5hT37F0guzWHRon+LE+tV4TcwyR/OyNuwWrEy6Dh
	 85PwkR4xHgYtQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3401139D0C1A;
	Fri,  3 Oct 2025 02:18:16 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251002153627.8890d5019e8e25a9df283e99@linux-foundation.org>
References: <20251002153627.8890d5019e8e25a9df283e99@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20251002153627.8890d5019e8e25a9df283e99@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-02-15-29
X-PR-Tracked-Commit-Id: 9f1c14c1de1bdde395f6cc893efa4f80a2ae3b2b
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: e406d57be7bd2a4e73ea512c1ae36a40a44e499e
Message-Id: <175945789476.3590395.14349776223212846303.pr-tracker-bot@kernel.org>
Date: Fri, 03 Oct 2025 02:18:14 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BA041C0007
X-Stat-Signature: oih9xeqn3gquk3duwrdzyeuyuiie4wxn
X-Rspam-User: 
X-HE-Tag: 1759457904-760580
X-HE-Meta: U2FsdGVkX1/+QL6+4RHFL8dwGE9nIEnD9n1rYjWaf383qK/At4w99kkajXk8BIRhuenzeH7uf1nX8g+unC7A5FrCz5CbgeO4kldZisCXPBDDruXXK/GOLC6yR0TiE0mI+Rd9KILKGAS5SUoV5WukVoNC//KJxh8s01k/qTc6p5rtY5VmD227t9LA80Eji6chS2DNVCydOYQn3uVZpWi5LskXTDIyCTqfVcQXpKybHO4NwLU11AR5MFAsjjDI355jvQCJiyOk3qs21YFGmEg47pyKbUJT82IWr/+fz/uPCr8mHzcfNf2lC+uyiyhk2Em9DOaXDXh9ZiGvk/2DTIT2Ucl552zIVW8BZH2lP3Blaqomd4hXLlJ8Zjpxv6Zf2TZIu94duUBLuE65GYwav/KuSvzg/HhjpZb8n1u9pPp9y8AlOOGyGmZv23YyMWx7YHcM7F8iAFnzID+IYvWSor3cKq2jP1NsyF4A+0NoJRC+XSQFqwd50pEB0Ilgs+6yCF4S/E0lnt1kg7Gycz41dPLU+DdagunKEYYTFvFMBYJFerRXTEDdYVE9gAAYAkDqSsxRScq7BCHy+IE239JX59shJtW0DGP/kEiQaMynJ7r8btW1cRWA2ilXf80lL62+qjCKJ78nrjqIUb6gtHIETsBQ9RgGuw8ywMDMKbZm0BDPthMwQqRA/E4SS2jxwbPlkK+GshLpIF8QJ27Hk9eRnpfN9quw+Y/zTw8AqYe8ULsv5jXQoV/H+3ncumuKhmfD7ceW0gyrc+udg6L8olBT4AqdcoiXPqv+1/IbhI3t5PaX7I9CePJoEb72+AYSP5hI2hupOpjGulk3TkCj7ty0aBJ9HWonndZWygJKs9W37/MmEZivYP0u0WVN7RwH5kCF+L+eZUzoe9wBvwoaUVJnYmMMK35XfV1TW4IbRT/E9M0j5QMMqm/uyVLUYqRsgm8pFdICUG4ocQSAw3kjYnsKrYu
 j3i72M7w
 CssF/DhlHOFR4/duOdfVqC3DbwsPZlYf0B9l6clorosKQZjvLV/DFhpGIlF3gSURom4ez7c0XdPC8486V1EZwbaYJpO98A+0tJCRyBjWfhQVT8Ha/EiKTGUKtQzPG/2ZsdJjn1ffDBDfqdu1LYqL9/gSSFw1fMVoiIdMp4mAwkMssjsdz6xKcvD11NAN7EnaJrnit3L9w1PZuAmA0edeHm3hrEufceVjCihWRmNgjeo/Y8qur2MmZL/kDDAno/jVkfh5aHSk+yFU9/8x89BchKIrX39SxvZ/fmgmXwDunJClmfgWLOiXRLldrCW8+m7ezlaSzY4KcFuxA7n95ohlF3MKZVWaqFZ/+GZB6WkhJ4yg99yZqsgU1wc17bOpMyjN6KHO42YdxNVvEuVE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 2 Oct 2025 15:36:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-10-02-15-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/e406d57be7bd2a4e73ea512c1ae36a40a44e499e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

