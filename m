Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A6DECAC597
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 05:00:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FE9028002C; Thu, 18 Sep 2025 01:00:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AF528E0093; Thu, 18 Sep 2025 01:00:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D6928002C; Thu, 18 Sep 2025 01:00:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 775EB8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 01:00:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0F99613B9E9
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:00:10 +0000 (UTC)
X-FDA: 83901169380.29.5ED4A06
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1CB374000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 05:00:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=igbs4A95;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758171608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=6Ec04g/Ig/m7kgTcJ3xaihW5GkT64Qi9+IEBSQ3VVew=;
	b=wRDB4Vi0kAalRd5cOQEt5Pv9n5i4eL0cBMSGAB+jw/JwScbUg06tAlsgdQFfn8YaGSxM1K
	vfDHAI5/qXaUiKyj6qvrq7lidITU9+gTbgQyW+EWFPRSF6FpeT7jmdGBrS8zhsi9L6+PiS
	ZkL2seRlEku9md2sa6niBvhk8fmuQos=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=igbs4A95;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758171608; a=rsa-sha256;
	cv=none;
	b=DeTN3jaTSISqnsW1G6PG+i3L4kucMmlEHc9/BhnD3MSz9kcRvqmkeamp1JW1Yn8O2VPZUl
	ecehXt+uMu/cVJRdhNNrOvCTID3+SEpdG8S56feJNFF3aDb3Y3kbjXCmkDgW4ucMpf5D/a
	xLJeFBsrjLkx6F6oeF5IOCbPgQ6aj1g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B9C4A43D30;
	Thu, 18 Sep 2025 05:00:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8E2C4CEE7;
	Thu, 18 Sep 2025 05:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758171606;
	bh=Pwe38i2essNnYnJ3UQqLil3L0njh2nUJNrRrwwF8g0Y=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=igbs4A95i0SZAd2ZiO6v7aDzwzLJEuv4U5QGReD9svMMlfahs0WqpgCiuc+6mbZhc
	 SThjrocxu5ORjR4k9wouv04DYLhyMhmQEpoKXDM76+dNVxlb1ZUVuKk7ere+lQ1r0e
	 hIkKRYPIT6rjc/Tk3ky6+Lpl1XN92vkNv98cPqE0eRMnTnvnlA9A6UOjuiApKjnTAj
	 4hFWAbj72PVv73A7MEH5e96AjenbsNx7PilrIp9kMa/aHmCmSUlcMa2o0e/MU5skzn
	 spZ7RPpgTDAKRHgabAOYcMzTSCV/zfLB7T8ge2FIu6fagbaEd62CYqcNnrCRCAa8Bf
	 DIfmsorlQFpLg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 3533139D0C3D;
	Thu, 18 Sep 2025 05:00:08 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc7
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
References: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250917211310.da8771af4cb50be2e657fe6a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-17-21-10
X-PR-Tracked-Commit-Id: ce4be9e4307c5a60701ff6e0cafa74caffdc54ce
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b789f2b7602a818e7c7488c74414fae21392b63
Message-Id: <175817160718.2263649.1243233939386153850.pr-tracker-bot@kernel.org>
Date: Thu, 18 Sep 2025 05:00:07 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Rspamd-Queue-Id: 1CB374000C
X-Stat-Signature: yn34epqscdk1igxt1g9dg6fy1np8aj74
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758171607-77560
X-HE-Meta: U2FsdGVkX1+94nH7dHVyRnwAzPEi86KV2xSCU2TuISejueDPnpabikmUdE0sGUIAskJ0uQqMqOqTif7BCcQn2UooPsGsqohh+gF+4rX2e8tnaKFRhPlOb3K2fayUbx7+lFoZomR5BeS4uS3dqXovcXCY4w/mmYmQFgYtOQDogkEfV37ZPV9YCUe3e4TaIOc1cslsVBvku+HGFQqquRyMd/HfuYwtNJTUQLQIpy2SnVMiPJl5TYaepSdjajdd7l2eaLBmQXDjlISb0KSDz5tF1x7acT+aUBdMpRV3HKPAaxLj+B3J3hxseZUmRZobQxe915ci4Yd8xHMpRWn6WZTt/BbuU6ATlbiZ6T5Xo10qGXUv0NwVg40njDybYTH9jfwEHEUlEt5ywquJW7TSoDBfYVmPgKp0WcQPx/CXkKb4SJxKqSJnIFRYr8sZcxCwwPbY3mPZd5+BxJDDzo8x+7BSk4zEj6CI9tx8mTRT1mjsFbM7phZuXtje498HN79nVJCqsTti0Zq4O8yYdg+yx4DjCjH5H6k7Fva4Svcs5SHqOvu9eJY7K883duaKZFOECGyy4qiqRdSwQep/W/YBJJIwDr10qm8YZToQjZOawmFtQZfiWHj2EzyWCZbPyL8OigYFw2OdTbmCtmnI1Erbn66amD7SPhKh25BtAQZW8pNQPuEqJQls3o3w0CmqHcdjhzSyB8YzbThLpKd4dJE8vSMcJjEbIiE/dMZIn03nNG2EwUIoxqm4DRLe/qKclgZDNtA0nSItgeVes6XNVeOENhvHp7HEUGmif9/5fTKEkaBC0+GZAsis66xDQCUZxQT5a5R+1BH+d7e2ik7cXyMhu8qWggfWhvrAdc7kmhdj5sj/J9hjhhFxHiOWoaXM/RRQ+Jw4XHZsOkJRblTBXYHnqsODolwy1BWrMqIuuciP0QpC0L0Si2Iex6WrZl0NKqV8CKtYIV4vkpWpDEHiFgpLt8o
 tkWOIpwU
 OiItFCiv3IeGwauqh/9346UrIRla7GZ7x0FDqCzorkSprjGQ9UdBsW5yt9gJ3K3iQagXDRpLeerzoicIf3Xsul44nPfNMyvAb+5FX479AYijQbDZPBJxiNmAbNbtSBfBrjtjdgekBa2XGa9qz9lUp7BSXN5DvNhyoxNKXFe7On6KmuF0LOHld1cT8EpCg7szDPztOBB9v8zCojetYyOCeJ/5UfAF+3FJVWHEwyLKfXAfruHjhR+/pBfGwFqJ0cTcAx6rd5/R/IKEbDzGqBM1QzNTrxA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 17 Sep 2025 21:13:10 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-17-21-10

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b789f2b7602a818e7c7488c74414fae21392b63

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

