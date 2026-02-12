Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EBDAEEA84F
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 21:00:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1AAE6B0088; Thu, 12 Feb 2026 16:00:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8096B0089; Thu, 12 Feb 2026 16:00:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA9C96B008A; Thu, 12 Feb 2026 16:00:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB1996B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:00:23 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60CEDB7EEC
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:00:23 +0000 (UTC)
X-FDA: 84437022726.17.559641B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 630A5180015
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:00:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tYzn7vSU;
	spf=pass (imf06.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770930021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=IdTFGHreoZv8b0CTvuLSWBMzUwbWv/z9i50T+a2VSZw=;
	b=b1dbc/F9cXsOrrTS6eBBACbv+U7AKBUCJ+jOZjgP5wvK9Nss9uYBa/B3ApRsMZdefDH1CJ
	ALn4fhIpDyKmMftPUckA9na33eEwzt5oFH+umgw0PPpqYyQQS6dER0FZj53nLLXuo/Cgo0
	pS0LhK49Bbgo98zOvLVy+zw3rA/6bXo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tYzn7vSU;
	spf=pass (imf06.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770930021; a=rsa-sha256;
	cv=none;
	b=i4cGmaC18WikoeO44Tr7UfmjVLXuM88u8LPBg7yyjGeoR0dNIpNXtRTdztW4b+MF5qCStv
	T10/fILaKLYfmynR9oZG/vzzD1AgHS5FVR8QGJxK/EXWCoRiSMIyuwaTJMRLqo95TBMS71
	j8uxjbp0jqDh5WdtMM0bgnWTTjaVv70=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43E5A43BA6;
	Thu, 12 Feb 2026 21:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23581C19424;
	Thu, 12 Feb 2026 21:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770930020;
	bh=DGZLLIs2weEORyQ83w6L0bf66JmLwadJuIns9tYBheA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=tYzn7vSUMw2+xoccUN9IKE952g+0X+p7atAMYuTYzvn1pZ/b72qzC7t/Yc/qJlXA5
	 DQgGMDweD/0yKXZMPoSfd5kCgoS6JhMksQrowyH6lNdi73jjO/F0tmLbPd/pBP9547
	 fGCxyPWu0ldZHtIRJ2rgXrYk1plcErur5WsEHPtnef8zP5WDq/nkPIKe8DqP8IqtlQ
	 11kfcejQFN6YH2XHlx91KaIME+xJlJD8VLlmNW66COTgg0/7fn9QBKbv0l2xnAKGrw
	 ZqwiuHiFTDvL4zbTPoeFC/QHDq2O6vEUSZ29aKtF0qabSY+0BpGfmyfEm9bBhgViil
	 aLnR0sEb0ec7w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id A0A6E3800347;
	Thu, 12 Feb 2026 21:00:15 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
References: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260211192351.6684a77b8c70cc032a3e7a27@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-11-19-22
X-PR-Tracked-Commit-Id: fb4ddf2085115ed28dedc427d9491707b476bbfe
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4cff5c05e076d2ee4e34122aa956b84a2eaac587
Message-Id: <177093001447.1706748.1376321274128551760.pr-tracker-bot@kernel.org>
Date: Thu, 12 Feb 2026 21:00:14 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 630A5180015
X-Stat-Signature: 551598nkpgmcda8u18y4ssfr4wxypej6
X-Rspam-User: 
X-HE-Tag: 1770930021-383032
X-HE-Meta: U2FsdGVkX18/0OQVrdbtVRT0zWSMrNY1npiPa0eHgQhsmUSfHzzKTq3JDShSzJyI8w1/NPHlL7H0tYCrIx5fGd/kQ8vAKiVPYJzYJMzHDnUGdfmdLJz5LzqH3g9q/HZ0A4Gs/NCNuLKL65FehjAs+76DCNQK1Xs+7yuFZrtD/NhLhcH6necyFOe0D2mdHDo5su1a3b+ijRODjZm5qGAqxpJ1gIOH/TVqhJG+BAclJ0+5olox7d0ObgOpWqJg/LcjqnqSXelfppeYucqtfiBjATo73YdzBTBuEfKt9wAShP/q8VUuEYjwQWa36XrfBuNd39sv67v6flK8BSIC95lCygDrP8JOm+j3IZcq0IBxZ2va0ilk0kuu4C+L04zgtEzVGDt31StWm+8Gt8UkoGbVlVA+z5+0M33wev2w4ymso8HY8S3Mp8SrDVfe3eAChq+CaE/eRJAVRObPTiCN9RUexI3WkNj1z03loNl7Uw9HzXyDu8rBxUo/TbqMD+2SHYiGrFXT9wj05mSL1RQn0TtxIImxrVbdHHJsBvNgntnJqc0riIEG/zDB9sMoq02Cgfmm5fcTO/BcCFcbtjD1jZO+ZaP5H2j9/DgJWhdnk14niP/7lU9k/iVVUQU40V07ttbpAgpxf6xW6rnNX3jaQ7Hx66dWwGmSfmmawyWKkSfHH2IRpS0aA5RUqEOwVD4qW9pq/9cEEMBPz1oKbvF8qknqlI8BFxKd947iBqRiORidq0MYqhEyqz7V8kGQaac8HabcQF+WEWzlFePAkBAUEzp4QnNgY8EEb6MG1bngeeu5fPRGWJP3BACKyY/i1uVLVPZT97ulxtyhqeKOqmf+hhe6y+ltOla0yRYKmee5ehhys274tbmFx7jqGuzmJqWmhEHMD0GQLQXYAYF7nnmFs+TfkoAjFFb8SENtloCQVysclKuVR2YXWSiYVyn7AypXtbVJSa+aU1rMxppNLRCkFj8
 vD3W5/Dy
 ZDFnwY8y2rUYF/bgBnKlCHsh/hz9rsjHOq2qwltGLY+s6ENUSe4DOIxmhU98fiVtyUXBMrzSyYh9dKzpb0kFE8gEvx9AqUZGQz3hiXdy6fOi4DJXCyyYGU4MucFRwtGAHiJyH9M883uSRvgB1R9QtWsV+K6UR7PqCdC0RZBq9uVphGhWeyOjkJxqNrdXsVXBx+XrWb8z1cBAjTJJ+PYkEFvlk+H2ufF3RUhEcocS3igNGZZrLtwBveFM/SqXW5JwXQOqSnHoFOTJjCCCkqsIfwPREmDSKLop/BSNLni/FZceOeUm03witM/GXNmVHqhINl5IVXp69oL0tpnmUqfgBmvRBXkCkxaNwASYY9wG3nI9rq6jV41bnhAEoSZYI6bmw6LtKR4PqdsUSk6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 11 Feb 2026 19:23:51 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-02-11-19-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4cff5c05e076d2ee4e34122aa956b84a2eaac587

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

