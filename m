Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73755CD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 18:14:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CC516B0088; Fri, 19 Jun 2026 14:14:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37D4E6B008A; Fri, 19 Jun 2026 14:14:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 294E26B008C; Fri, 19 Jun 2026 14:14:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04CAE6B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:14:28 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 74C148F2C4
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:14:28 +0000 (UTC)
X-FDA: 84897462216.14.91F015D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9E9EF10000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:14:26 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFG0dXDa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781892866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=oqyIcGARJODplCSo9Kl2yV2cMuHVctJWhciqisobXCk=;
	b=ZR3oNXKq226BjewVDFXBcx6xoHiCEFqqdiI2AQyZng1ynTcFVd/tQWmcrRVvQuqzQph1HH
	Sbvhl1yN5E/xhFtH2pX6ZBZE91RZWPla6qnvVZrMfNm1SPub3GUgTRygSsb7uT1DymhZHt
	GTAvyeO3GFqnF4iyOEo5LAAI4sVl82U=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFG0dXDa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781892866;
	b=ylLRqe2EgIqIOkOp/fzyDu2KHE1YtWqSPBS4vaoHE/vOhNuIJmKtgrpM4slmypEMllXYNw
	53ji1tX8VR2sNrJlBfRe/ae+VNmy5L2tUuligtEyakZ4fpjaGfzSwzfQ0uJuwroLfO1pvf
	3am2S+doEEoWuuDcCsH8cNR39bJHHv0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 02452601E1;
	Fri, 19 Jun 2026 18:14:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABD821F000E9;
	Fri, 19 Jun 2026 18:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781892865;
	bh=oqyIcGARJODplCSo9Kl2yV2cMuHVctJWhciqisobXCk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=QFG0dXDaaCxAZho2nbLoKbK3x5feeZuPKuTvYK7kAB3KsHAG+7mrNcVBfjgKXPox4
	 8UVAO5UnmnvI9XjiQbcgRRKZRX6quE6gKO/OkOJFbJYXDg3aSzw8RbSQbFAZRmDSfo
	 17suW1Gs5N1/j7qDBftvabYtKlr8tQ57OB+MvTh05OjxMOmvH1UQH21vdsjIqYfnQt
	 WeJrZdwqbS0OAAfYwPJI8oqqMIQPXhNtMdfdtROlFOzJuJjk2E3ty62HkcjwEqyqL1
	 g8BDakRtSy4a1U6IQuDKC27VhVbwGBC48Jg9zAypvim2MBGxM1OMz1ykcdAxWmNjCZ
	 9XEMod4t3RyXA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0BD53AAA0F2;
	Fri, 19 Jun 2026 18:14:19 +0000 (UTC)
Subject: Re: [GIT PULL] MM updates for 7.2-rc1 (v2)
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260618093027.803700be945480575260b0f3@linux-foundation.org>
References: <20260618093027.803700be945480575260b0f3@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260618093027.803700be945480575260b0f3@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-18-09-26
X-PR-Tracked-Commit-Id: e3d8707358ea76b78bdec9928937bb9a797f2c8f
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: a552c81ff4a16738ca5a44a177d552eb38d552ce
Message-Id: <178189285848.4018353.4379775953714652811.pr-tracker-bot@kernel.org>
Date: Fri, 19 Jun 2026 18:14:18 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E9EF10000C
X-Stat-Signature: sax99jzrfnia7cktfpp8n7waygq497qr
X-Rspam-User: 
X-HE-Tag: 1781892866-735387
X-HE-Meta: U2FsdGVkX18CrawDkWGbIlCygvz38OKUls10gnZy+lBDAYV3W40nmOA7iKrhPCR1ped+tKfErfDOINupiukmljYi3ImkQoD5y77k4UezqTWzd5o6PdVq/HAua0EF7jkbiJEPWiG9aUFVOf8YuED2OXDHYRAWCrf3Epj2ENgi+ffEXaEjWt5dskqpLBR1sNpUAWJFnJripjQZ/AcoG6jYqm/IIUyb4iC3XNsHYkYcYKmGvgCFb7SEN6GVq6MGY8tCuRJUoOhfvJ9zpu3u6sGz5NjhUR36aICg/ZkyXlGgYvZ5dR0dU6hfpOjrHX810tKhjBmELDneRwnCh+DrEinBrabABK9UWn+7ij+guLqUKKFMcuuNNn75LnbWaVgs1+rE5zqtEWWnhzdKPtuyOlkyjtAGUKVAPJ3iOYkVrGrAmt3VtD/6GUUzei3Mad9yVf+vmsNo/BKPiyLt61fZcdZ7BeQuhR8l9zqPYImF6zwULX0dJp2EXTInwHFZgH/iDd4fIV6qkDwyTGOZU1AsyKJuozoRyE+mkB3dVCGXjJVQN/sdstnQCUKDVqZ24/7rcrEDDARpIgFMtvQNAiVcNobRlU5RC8nGaGZS9ffzf7IxZ8BT94yh2Df0fDy4AbfEhk5qEeGZT0yPXZ+LrKX1VpMZ+paYEPoroacK7uZVyEBnGtF5irdwxWw5wqcqm7mFYp9ZJYfTgcptDOzGjaq9IohiO2+qHrKjJaLO40MPaE7I7caw7HCcwr06002RqTUqjkBCvYFlUJ3JWVDBJnqtVAd+SHeuPTdbTIckJG7scEZBH2xlbW5bs6XmzG0t2xFZJ9AVAOQXdm5wcCmC9gaqQYX3MQj0UMM5EpICb6bwNryLBagXn2/Q48NDPB1wxfgMr1w1tnCG/HxNmpTFqXtPFkqITzad9m7oMBIaS/WremkfYndl16BA0vWLgJjlMnEVc15y2gSkUoVTylW4zpX5hOo
 81ZrJI9P
 F6l5i0FxPuvpvrAqgYt26o28Jwuid43xhzgrxCnTUqZK9lko7jQ8mmKavx3KBQ4XtFrHcz5iywpkDS0zlSUKLpDg+m4F2nZluWar4kJH8DbXd+lGrMUX7ZQPMSNrkHzv8RmGsO+dH4NH4i5cTR3RDcxGWVcS8mU0Hzs8ASPczj8rszZsIBpTE85Y2E69O7P200oCtCkFHEEvRWyRhn+gIm7CH+Mweyw8rFX0N0/+VB2zWLbrfzhFj92/gK8hNrKSO7NPu5zM6wTXHkK08D/5cqi3P/CzEF4ZORH89GUeoSOMo0FKop2l+T+Htx5AmAUVtfcxNGg56rUnY1j/2ABQCicCM86m7CBvfb8PE026yENniPDe4MsL4Ucnm77+cUHalTvnLH0skhwJ9FyrfWR61unGcQfHquOo9qnd7RPWGEIfs6afhZjah0tHNvg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 18 Jun 2026 09:30:27 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-06-18-09-26

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/a552c81ff4a16738ca5a44a177d552eb38d552ce

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

