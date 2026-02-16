Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD941E8383F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 22:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2F126B0088; Mon, 16 Feb 2026 17:11:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5AC6B0089; Mon, 16 Feb 2026 17:11:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1C96B008A; Mon, 16 Feb 2026 17:11:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 86F2D6B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 17:11:52 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B33C160F94
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 22:11:52 +0000 (UTC)
X-FDA: 84451718064.03.1F66AB3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 358C81A000B
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 22:11:50 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ucL+QnU1;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771279910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=NhfMTT6urSi9y+oASW/6cejYKdfMWynqnMeQK5L0ypQ=;
	b=hxNhePGTuW6bV/Vuton6rQFfjETx56gn6FZI0LcQt+Na9ka8aPKAgB5gF4Q7WCcBkq5LSS
	NbMK08+cTWSkpJSyc6bdKskhRvnHTzmPvavw/wqZIoH+6P+VwUjlhKCFLwSLHiQWB0XRxL
	noh/vIek0TRM0FvBfpkPy6slQVWYg08=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ucL+QnU1;
	spf=pass (imf19.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771279910; a=rsa-sha256;
	cv=none;
	b=jReinRYWlBKloR9lce9hdiDpuONa07ad6QHyp1Iuan1aEKEQjrteaarCGlFGIisPR96prX
	hNJ+mbYj0btZgZRklLVtQ/6Fq1QZ99h1sEXE0cJlqSTzALRM5ZluSrPOoAMIfdIdAYxrwp
	6o+bm3XPvhuG8zkXz3nZIJCW+kKqHuk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 57545433FC;
	Mon, 16 Feb 2026 22:11:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 333CDC116C6;
	Mon, 16 Feb 2026 22:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771279909;
	bh=moRbK7mvwDcdCdgDvltmXgWx/TskxYfVlXPDnMYUvoo=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=ucL+QnU1zvFUYgZrm4acuw8cjm/1E1DV1veOl8O66I2fiofPQ9g2eSddLW0ZyWzvT
	 hLs/p+anlZDHVVBCuQX7aCm8vNLbzLXScX/RtFPRx6kxI0/I97zHidKAQAMwV86Pd1
	 WSmGd2aTkbXGLkax7Rch8bozvykctoCLZsx1TpE+PzzDpYb5rw36IomvhWv1t0DOtV
	 oq/5jxCwuFKXTzMKvWNYT+/IeTFdLfN1PlL2b6Rt9aVT/3ER3Ab/LUmA4sI0z046cx
	 QS9hpFXlDlgR8+IJbNAJkpVnKaCIE/2GtZnLtWuR1Yb0MJdFpJw7D5Yu+7qLyFm4SZ
	 JV6QLvyT/b3aA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B6E6B39308C1;
	Mon, 16 Feb 2026 22:11:42 +0000 (UTC)
Subject: Re: [GIT PULL] slab updates for 7.0 part 2
From: pr-tracker-bot@kernel.org
In-Reply-To: <0c8f9910-1b4f-4a8c-846e-397f328662ae@suse.cz>
References: <0c8f9910-1b4f-4a8c-846e-397f328662ae@suse.cz>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <0c8f9910-1b4f-4a8c-846e-397f328662ae@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-part2
X-PR-Tracked-Commit-Id: 27125df9a5d3b4cfd03bce3a8ec405a368cc9aae
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9702969978695d9a699a1f34771580cdbb153b33
Message-Id: <177127990139.4020762.10413226405389539228.pr-tracker-bot@kernel.org>
Date: Mon, 16 Feb 2026 22:11:41 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>
X-Rspam-User: 
X-Rspamd-Queue-Id: 358C81A000B
X-Rspamd-Server: rspam07
X-Stat-Signature: 4q8xpkajj664crfy8fg57eykn7q7af56
X-HE-Tag: 1771279910-190831
X-HE-Meta: U2FsdGVkX1/UkFm9VgdCD2w0hS6U2OdMBtdzmTf+SBgWaJq8OfUFrKcau7kbG8p9eO52Ao4p6wBtJH25sSEZ5iien33LhZAMUmWdKpVAU8ns0kXcvayB5rSiXGw1pFdSeOIiHlx2OEW5Z8NDV6SiEw7mMa9FFMieywNbpx83CfBgy4Bmxm12x+MzuftdZmBKBnlrUJF1Y54tSEndejv4r2UEm7dJ68WmSTI4taC60ClQb/abNZNJr4UX7CV9KNGYMSPg6QXH3/ooVdVt4x9sm5nB75bG3LiH12/34a8/QbHIj3J4yPt6MVRC8unNNUXKIswhs2ht3OrLR73mOz+VyFuLToVv+W3AZEcYsHnSKYFKI4v00QQCJK1KSiUb2hFCbBrvHei2e2bZvMA4tuMqLXcrnrVUt/YdvkHmxyTJNQGnuFFq6jlLN+o4MBdATY/88tvd1EdTdgiFrbLxbEy24eMbWB46et+PhWLL3pXa8ubYoN0OBJHuewO1z3fflHq2Svc3iQTXshghjPOiBKPFiFAgb6RUec5fNd+TRFfaQGGwNRd+UDu9BCj4cyYpxnGlcBqrjFcAJXLQz4v54msWozGJI4cLgcKG+yJ7CA2ABYK0ckof41n45yxtr7kqrmErjklwBI3oBV+4i/UuWmkJgH87wfqN65hbvYO7V8HyDWb03GWLt+KfyeFNbunkVWjRr9WOUk67hyQDDWZgMJYz0N9ftOckCEDK/18lJ3fey8UP0XUqCbxM2mhauBoOOzNyPCbNI+kuAw3Q/fIkr/MHuMCgEMY5TsRtLl9t09CtVTNxoiDxNIOSILRuL82vvrCDGXvQQzzbJQAD2pbSjGjnH+pfRFe93NxaxaDF7BaDIeGEjQa1jRfWj7C2JoGBJYUiC35uwCOSfekfjPS/QjY1l3qn9/VhvjXiO9KIIwbkO9fuMA+snvMcWyd7vMQCSaRHMX8z/9uiwJiN8PoaLMH
 BOyRHkOK
 tSz3PGdez9woXd6a+ircEujnOsOakRa5dtK7kRjhRZFNCQ1D+fOvWG+9OdT7oGl5j9TKp7flcp35w+xJHUh4p9Mq6do2M5+Lc34ySQfG1V6lXe/tvfQvjX4jJL777OZgRen8g0Z7V2tB8g/PE3cIe47SpyunmXoHDHXknhY7clGJ/wB3h1hClbEu/rQGdkOI/bJBNtz5RJkL1KJbSTapOnn+xNKH0FWu1QoGP+Sh9h+lAc/NhK4bR++TJz86aQEQcFwojG/xkprfWR3EZLSOnbowg0/kk6C2Fu7E928RtjE46mv1d2xrJdrHumQilOzLZcW7g/JYyq8V6ghgNEyprConS4wuQnh+Xiuav9p85CWDr8DZhxNPCng76fDyMfwW4DFEHj5N98sxDRgTDS2r+fe4BedjhJI18w/iuSftTwKFae6miLLxR7RcMEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 16 Feb 2026 17:50:51 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-part2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9702969978695d9a699a1f34771580cdbb153b33

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

