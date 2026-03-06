Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0BD6FCC05A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 18:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3685B6B0096; Fri,  6 Mar 2026 13:38:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 312376B0099; Fri,  6 Mar 2026 13:38:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 214B76B009B; Fri,  6 Mar 2026 13:38:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5836B0096
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 13:38:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C823A1C95D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:38:05 +0000 (UTC)
X-FDA: 84516497730.18.73E64EF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 20EB540008
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 18:38:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3qAZGJl;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772822284;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=PEwYaGT7xG4tJOwU//WWVVB7YRRgc2eZlLIqK4yf5yw=;
	b=Qnt6RRcnr2e8rvuTfNKTBkX9HwVdeIL3HuAyICYGCNWSL0U7C29e8EFamEpvf4RtpHzwQU
	fG3jXcnwFP4al2OucioBa931JrbQv18T/N6hgqH4JRQ0OQQD3oiyKZGLeTdc4Ec0kJTU8p
	jFa308u2i4MzQ5isOm9jvmGGuJTfcTU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772822284; a=rsa-sha256;
	cv=none;
	b=OHIMFXV06ZAnnhx1MjYST6LsPEtxBgszF7H6FnHnNKTHqUzyOHK7oqWK9mDzmymp1wCUDR
	S8mRjyS84u8uMQBu80kuInhqeVfaR49SzAKPsvw3uUDkoD7MXx00Qiw1GKa3zA7fzA16Mp
	aILNTxVLU5wWcKH5jPImUdkpeilaI0E=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=U3qAZGJl;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8661560018;
	Fri,  6 Mar 2026 18:38:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34EB8C4CEF7;
	Fri,  6 Mar 2026 18:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772822283;
	bh=RCtRnJ9Mf4+vaJ1DdaOWKCOk3Lwe6gkVAmGvVe3J2dY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=U3qAZGJldTAtTrzuHxeJ6knqpFDmyKPrNU8tWBQynf+mpDGbSZAl2GaQDZkj/JONm
	 lfR74NDf1s8RwvL/eOaURQwP2KfCA/2joa9j8h7eEX1jKUPFaH8a1DXkPrJgIobfYi
	 YTLy7gz5ixmoHtcATYnbRsk0oNFufZiSRN2tEFhm8ijEDrltesdyURZ6fJ9/ZFYkbR
	 P92ss1OV/TSG7XH2dqrhTOj+5yyqNaFKJnRJ7az4ltyD8vo/msKS6CPQMJekzgTjMC
	 FItnr1WsydhUUaMvG6WjW8unNrxdcctEmG5GJJ89Jbtg06EIFVTBdLFpWYTaQPCOzp
	 DArNvxuKPEu7g==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id BA1263808200;
	Fri,  6 Mar 2026 18:38:03 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 7.0-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <086138f7-052e-402d-ab36-b40ca4428662@kernel.org>
References: <086138f7-052e-402d-ab36-b40ca4428662@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <086138f7-052e-402d-ab36-b40ca4428662@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc2
X-PR-Tracked-Commit-Id: 6432f15c818cb30eec7c4ca378ecdebd9796f741
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9a881ea3da166b05ec0eb66df22a7228b90aa66c
Message-Id: <177282228227.7628.4557674103225371572.pr-tracker-bot@kernel.org>
Date: Fri, 06 Mar 2026 18:38:02 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 20EB540008
X-Stat-Signature: hhk3sqirndj93redatf6uj1c3xkizcte
X-Rspam-User: 
X-HE-Tag: 1772822283-503039
X-HE-Meta: U2FsdGVkX1/tnHZAlTRxG87yeApvFS8aN9CL2bAPUCrnimmmr7evqB8IptNQ3H6QuC/PwIMinCl0GI1YWuaqG8a9UMU40E527ahh1bUsd7bBjfwzTyg9RMRQtIpBcXUDHLD3YfYBzxCt09a6grwdGHZqOvCHE6uAFdx8Edq0MYoDYp3RUpkBezR0Xsq9XR7LBan8HV0mYSOlA1cyvPeMPzcdoZIhcBQx/c5fzczRG18BTsUbOFM66AzgXiPCTCfwZGOdjLRW+uZUKpW1VhwVpiFYc4NmCBjDsh0IId7U2bxNtJ+JerkM56RsKA9flt+wUJrzsnV+bgIGvNCcfOodTy3oHsP2ck1rgs9ZHSUy6pm5egrtNJQ9iZ04P1cTQPSgM2Ek1As9Gtdg2q43eSGTrV72amDS6Pe5z7mUpaZLLI2VrPZ1Uuaa1M3OiGUDb+NeTc8YFXFRtSEY3vH/ODJ7fNSQlZKCUAJgIy/I1yU9nR8yjs5BOBIZJ+/TFm38PbsLmsJPiWzagn45XWJq8rpu97+x06DgIkUPqjz/8BmjeNYPN22mDAToPt8vUuEqI9PRO3ukn0XdcgkTKmeE3/NxiZU1IWigrITnzmd/4om51yDAMjW2ug/faUXijgwQ3GGUG8sxTvKJpiZd07i6Ac2UWt/xZk43Oe116kGvJuEqQ/x3u5jVV/6gkoYJPxTVTz+qyfe5Y5qC7h0E/RdPoV5ORRjmCJ5UsnRsYx8uKT8WkvAxAKsYtfakFDy3t0sgTN+DFsUjYLBANfvSXCQ4A9ACQuZZuEpL8ki9TPlarJTyjOSJCwuWCFEs6zZN0mRObHc/sQeLqzX5GxlrsdduJTbqLKoafzfuyArYpfLeAuDPBpMGuyeTa3PgcTtVKeXzqADg8zR8/hmYGhHX70GQLB4ibbTxj9mnJf4l7k+f0JDfFrWP2Et2YADaoDisYNn5LJiEbtOmVfLsMmCSOtc2bLN
 ujg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 6 Mar 2026 12:36:23 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9a881ea3da166b05ec0eb66df22a7228b90aa66c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

