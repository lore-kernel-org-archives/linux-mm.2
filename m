Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B264CA5FAE
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 275296B0088; Tue, 29 Sep 2026 09:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DD96B008A; Tue, 29 Sep 2026 09:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B026B008C; Tue, 29 Sep 2026 09:58:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E47C56B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:58:32 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7DD711204D3
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:58:32 +0000 (UTC)
X-FDA: 85266954864.30.1351635
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id ADA774000C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:58:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SgRYrjZT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790690310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=OtECl8+vYMPnXskEA5uxBLNSGll9C58y1Bq34FNO+eg=;
	b=VzjhHTCisu/BO/NB+HhezW+QdUEqRhfCsRCpitl+8HXIR0v3B3TAyoAQoFgEtmmTGT1Zrf
	ZGHzFvKJfcy+C040NT7OBzZDs0PGwwyjOD8I0Hcg5NUGK3+eQ6EPxIaLsRhnGMaAjUsFD9
	ytFhmGlzCqjQGHvDHObRBQhu+E6dPP8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SgRYrjZT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790690310;
	b=qlYknQq8VV5JLiZKz1A+LEaRwGpJGI/+yuzKTRMNjxG7T8cxJq1E0VUu9kubY0NP+0O065
	t2DeyCtNDsYtDw2RjK9IZ8fygaznM9eCGf6iajuSRCe/HU1sDRMvdWis5TbJ5KzGeQfp6F
	uxP1DNbK/aSL/nnKTyCgPR07G+qRW14=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D923041AE9;
	Tue, 29 Sep 2026 13:58:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD3061F000FF;
	Tue, 29 Sep 2026 13:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790690309;
	bh=OtECl8+vYMPnXskEA5uxBLNSGll9C58y1Bq34FNO+eg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=SgRYrjZTvIw0+xwOcjvzqiB9d9fnVU2yeS703kX9dpf1qk3Ss0h9Fmj3K0+JEKFvv
	 sTPm8tV6joZij1oeq62s0zs8iVK701ZJJZAkFZ/aIBM9s3UtaPbfrGwHkK6/eMpJVO
	 1k9CZhwbre3jDVa/S26Dtbq7vcy9JXen4kF2u6y6QdmINPgMWTTxNaqUDhznMMnzcD
	 PMjbZ+Soxz4Z2wbVgjyqOLfEgnSheS6Yg43GdRDuMbuhRDY9EIJSlCbkSOT1Wkfawj
	 Ox2FH+VkdxCXS2ZuQCoIS4hMafq4pL4p1OOH/jt9oITWPMNfW5H9KmCfR7gSDwJC/Z
	 t6FQXGqHi6bow==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B47383926663;
	Tue, 29 Sep 2026 13:58:29 +0000 (UTC)
Subject: Re: [GIT PULL] MM hotfixes for 7.3-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
References: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260928200625.8d739583d545932f905e36b7@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-27-19-12
X-PR-Tracked-Commit-Id: 976d5e0ddac885b0219252f004f6c561c344df9d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6f8319e3e9a44dd537d17f41565a8453c560a581
Message-Id: <179069030829.508778.12503709141210678561.pr-tracker-bot@kernel.org>
Date: Tue, 29 Sep 2026 13:58:28 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: 35na59hrss5jmtcxinamf6jszkqgaya1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ADA774000C
X-HE-Tag: 1790690310-686548
X-HE-Meta: U2FsdGVkX1/3GFkMnKw6GNcCoawJ0ee9xuOtoRtTYmeVl2KB8nmlG26IXk1+MST9EeMK3GR3FTWTCnmkhD8QPklr6qEhf1Uty19EbyyiOjfQoVlB55lEcQmgJ+REZC8qcWXRjGRXgaJMtbUaFt9ZWchWBC/jSfFa8ZG0fzhKMV86A/m861nMOiOHwgKqP88O8JmehQgU/MrGbYgoPB2S8IN3VY/Hs2j8Fy/qE2nzNlyAYB14KaMPUrs24CJ3p7vVoFPL9v2UyOfLViRNSLy2858ou/uKs+n4EDr/EpoyJgm8LQSYOveJoFCTSOWNhvU7w8HqpRr7ObjUQwp30+hBcoNUWf9c8DPxTgOXzx7o07bik4ZQcx+RhGbOLKTUfDDeoXxjn7N2XnH0mlUpCTVTA5XShdpAKxU0xf6738thB6QOg8lb1kHKTUfnOfp/+9mVMaVCvHWjmYXYI+mvMBpbnUoSHXhJcyYYvWg7uis8GJ4/KjtUuBvqTTZKS0X6XlW+adltYV6W5hAtLHvk5zhjSpR4gbBjiHGx0hbA7zKpzBQsuqI/JBuNnv1USimOZdyPUQMt76oCmFvLgbmpGV9Huvk1hED5dHKPp5iCvViIKkmeH6RL3uUF4lK3of6z1c/FJmptX0Q4KPc5xje2823iJp4hK9MjOa5H3e5vMR/JLHPIUBP4sgycSVrP0+M0Tmbq/ADg/3cnhWOEWbODIoU/AxYiaYOWsp3FpCWwPLcbj+FjpI+9e7ikif/fWk8nZvHFVXNxy2EDS/CdaDKKHEv6vEjqn224Ff0bf4P8X5JW7xgAtIQbhR6H2cGSGBtES1SVWUeqs6LmisfgsTpLf9rotc3WHEUylzzNPjPgby0jWgftYp5YURQyS4cmyIOcuW1QlbfSWO9/fIDjj0wrr9/KIm6KQ5fStRs9Jr6befAC1Twdgb1ou0zPD9drFv94OYDkLMxTXoc6VWMhrz9agc9
 P6Gio48j
 XQLFIFeukXkd+c38aezFM/UNkXFxra3xVI5nSR4bbXFDeJFgvE0jtrS8amiOHyuS0a5MBtMeJZC2buu20YRI+6W8jQfqyWlhLkvZD8G/QXdxBp65es+VvuZupQ24UptLyCShZpsHZTiV5loYmea/ax9roiJE2UuwXJAFp9LI63M/nYioKGFU0UT2Yilbj0m/qa+RSc7TogvbO/2moSR3OKYQ7gH8CYdgzAHNjymS04Yv0FWP/9vE/y2iyuLXVvQrLdFnR14UFw4zeBLnN5kM/iKBqFZ2zCMOlswqAIkYwZ3k6Rn74EohHeiyvJB82uzfysArd3E0b4iu+L3H5x98i2Xhcz+8DTHbKSi9JrqfRl0sPcBqxJ1dmM4ZrHthCH792aXp3QNfYt3O+8fjA8hBEvEbQ5d5B9tk+UMLcN9JoQ4fkKOxUw81gtex1nQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 28 Sep 2026 20:06:25 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-09-27-19-12

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6f8319e3e9a44dd537d17f41565a8453c560a581

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

