Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97BECCCD184
	for <linux-mm@archiver.kernel.org>; Sat, 11 Oct 2025 18:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0E2A8E000A; Sat, 11 Oct 2025 14:38:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBF438E0002; Sat, 11 Oct 2025 14:38:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAF818E000A; Sat, 11 Oct 2025 14:38:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2E8C8E0002
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 14:38:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5BEB2140714
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:38:05 +0000 (UTC)
X-FDA: 83986692930.03.E885DA4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6E316100006
	for <linux-mm@kvack.org>; Sat, 11 Oct 2025 18:38:03 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHkqSFvs;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760207883;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=mxXinw3NcLSewP77YI5Ch7mCV3rQCdC/qg6nJ/5wvkU=;
	b=FMvUNplmpVkqB1ENgyair6NIkQbNRe+P2WJjOHbp09yqv1/aQmss1OWD4F5sIzBj+OM3pf
	yRII1zqU49gvA85hWOE0JtO916irj++IiC2LxJPszAHBqZIIfiawcietWsAjAh0u+q3ryK
	/8zrkTsbGfCFm/Eyv1dWFLegZGUNbI4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHkqSFvs;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760207883; a=rsa-sha256;
	cv=none;
	b=jHF0eqzLHo6uqvGKrXYNPud3TY0RdETr7WRT6YCIK4re3DEo7QLIu+YrKm3b5uQK8Kzf7X
	rACnYigWE687/c+nKrtWtWosfw+3tcOSJUey1aNPWKx7/SkyY+sOkSq8WNs+7G/oxfrVaM
	5oP0jT/J9ikI/gpGtywXhWGSqwZ1H9A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AB96436AF;
	Sat, 11 Oct 2025 18:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA74DC4CEF4;
	Sat, 11 Oct 2025 18:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760207881;
	bh=+4I6/7gKW49KdhJ+r5k2IKqth6kx2WhiqWw0C5OIRM4=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=fHkqSFvsp6R/eFe3n/3aGYcqhzP8pn3NyoPej8FXvcqfrTG8+e9cdEyyzgL21R6PG
	 dLhWsg2W1lOXSaaO28PWR5xS4Pw987x3qS5juHWhVTwfNTmZoPHjWXrGdvR30YVEDr
	 oSpdurw9ZS5Xp9fHRDfwxg/I2NHgMAjGD//EhIvdWJG3Igs0+7lezqs/I/AIu4sdQ3
	 F2IPKLDgrfk8ekvpEH+6DgC7g6WDzjVLG01ZL8mfp30tv/24YSZTbIHqZYIOwVeqYl
	 PPyWbNjK9C0W7NXfNkceTNxlTHIM+q76yLYYiJdZzvMJUcVjoWLtA29tugHBhQADt1
	 2vprsZEjtt6Iw==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id EB2493809A18;
	Sat, 11 Oct 2025 18:37:49 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.18-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
References: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251010150323.2d73ad0f6fa1c49fbb7d9870@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-10-15-00
X-PR-Tracked-Commit-Id: f52ce0ea90c83a28904c7cc203a70e6434adfecb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 971370a88c3b1be1144c11468b4c84e3ed17af6d
Message-Id: <176020786851.1422231.15209279275130489404.pr-tracker-bot@kernel.org>
Date: Sat, 11 Oct 2025 18:37:48 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: w9ttobrrguq8x88himnbguztepox1p1z
X-Rspamd-Queue-Id: 6E316100006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760207883-989714
X-HE-Meta: U2FsdGVkX18pLk/TKzd49UAhQBPxw0gtKhffNRN2EPBJrLWiwS+E+a97l+nrj8+LVqc9CnhRppkq0QG640faYGes6WFONfcvyXkk3q6/J3E9iSFsuUuI74W9IWPhg97O9nvxoVWyzpOIGTJaHDXxT6GL3bx8VDXEMj8NLLJkWd9mtLW4+l1k+Bw4aqyT2SCmcNTJEt0ZL5LkxkgVI+8LlGo/1gxQuizeszpjo4IVgfwUdqIx6t49xYdk25aXoiagMVxCm9hxoKvsItR8Hn76ifKx52dnoNplwS8H8V3VrafVz+KZyurCXSpB8kEvy7bYPJd+w2r2yHGiKoSJXmnzP3YZf3Pca4kGokWiz5obzlKA5zrHnzYey/Mm/ezWbTJK4Olued3MUIReepfQRqv7Ju/M+IJLSoytxf/1I3cAx6DHv1GJYUt7OZ4VWT0Z9CxPCej48cTeQ5+qk7+eOH5t5UbAM0NIKPcldEvBGBvILyPemvRXnWZso57LUlt3of+7NDQAaU85Ax8O7eDpfjkmNnmzxYNwludQc2aZUu7E/xxHsgZcDmHlGCzcup+5cZJE9ZJnWK++oU/4fpv5q9SIm0VcWzqf7AW0upNXOT37j2QRoOnaEPshSV/YZwYQNS3aOaLXUnoXiXgXuOMrm4PLmUqZkZuLo8+EI2bDSrnjYAwYJK0BFOUT2q4hu9FpIY81oicg4Ehdcj8X2M8h23nYIOoNO3Mkr3fidzGeGh8BgjtK+ysXMb95CVWpj1nlWJPMd/c3w5b5p0TA9LGrbPOW12WNa+9FbkQ9f9ovoginyWTkKGjKjmwK31MlCumlilJQs+Hi1fYePfWoTjf/G70lVUXZ+NKqphh9Kt9umL9a3X/hqHWXCLgRdgmDFgqTE2OXv0zEpvMwiTwhGVJ+m3qscKR+Flz9j22x2VNNwyWEh3jR8rOXZKarJ6qzNBpZtgKaCYPzurxNr/wUNaB2VjU
 grO7H1OC
 wYeEHQzsEwFnG6Co18vygb5rfzhJxfvjMnLDcRHdMJ1PrreI74nLyaC1yIq31IWGH2rmDYbmyY54LWnQUk2aAi5K7jMd11oa67K+6LfxlJrkcyXlnERw2JQ1UCDFv+SfM1La6N88FGYUudKRfQlnXa9Rm3IT2FhZwLv6PKDamdSYTphhxSLw1uwmlAmeEVVLp+vU+/K75ibBe4uZB/TdI/hYf5xxUAbYLfea0FJL2QPBQ1NkjOKp5wB1f+R7ecJwH7t7+qxu4a+sh8FWhvry66kPmsOvEBAUxdeNtL0ZRzbOp8VrgikWvtLlqatrCw+MiSkvxFxVMh3ejQPGrvGjJxUhP/VhFQiz0icjEmZZ8tqkKb5PzRFVfK1NlrGzZFOr0AYA6eB/Xzyn2z10=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 10 Oct 2025 15:03:23 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-10-10-15-00

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/971370a88c3b1be1144c11468b4c84e3ed17af6d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

