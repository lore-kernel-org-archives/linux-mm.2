Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A86D73EAA
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 00:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41A216B0005; Thu, 29 Jan 2026 19:29:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C7B26B0088; Thu, 29 Jan 2026 19:29:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D3E86B0089; Thu, 29 Jan 2026 19:29:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1AD7C6B0005
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 19:29:02 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C87BF58BFA
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:29:01 +0000 (UTC)
X-FDA: 84386745282.16.D4C4B7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EB962100007
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 00:28:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pt6yp52i;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769732940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=kJsXd0K4ahVBvz1t8K/MAsRSvAj2U/6x3aiZDu6Yxx8=;
	b=eOOKT8WrentHW7zr58ib24u8Uw2JNFlQymZYDW6Bt/OZVjseX8UtvQjWAb68M5q3Rrv9YM
	ihR5uw9lCyZv8xlvZXdvyl6JmHpcoE9VbAk1QAPagZqnAOFC6tvLgW0fwOgwceBJD/ilzg
	JVceIOS7FJADC0D32Ql/nHDTxCcCuns=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pt6yp52i;
	spf=pass (imf05.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769732940; a=rsa-sha256;
	cv=none;
	b=tulau0Z1e2My8OdO0d7Tc03NQiBdc28vdWWS7WRKarllmHtoD5tGxgPL91PPy4OxZvvnJR
	D2Z2LUQz5Bmg5lhKvor3trVqS8/73OAXcPHstLe6JINiZJaVVVxoHj387EEwxft2aCH/+u
	128XaIwNenrCd+rH58EmMFTT32aOi9s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A300240547;
	Fri, 30 Jan 2026 00:28:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88F64C2BC86;
	Fri, 30 Jan 2026 00:28:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769732938;
	bh=//CDFm1J+twEzc2SPj9olOmFK7Gf+t8RPHxm3wf49W8=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=pt6yp52iqEXdyfmBgXaMrJyt2LwyGKEsP2eWcCdeaWb8/4QTNFDbkTEVOSQoV+W15
	 HcY1Yz+2YmIHV8FLUg/DQF5dHsbBrY9YyH+9o47sauY+iZVqp7bXUS9a25oByj0Kh6
	 09ucj7bsHchXy9rhOBodCjZIN/z3ZHzyZ/chcUABXyRr4ulbdeTRMlM4BdjH7kzOxX
	 IAXe8Xcd0L8JAMASSXflDYXSzIRIBBdO+JbqXIcmLh3ncOG4Zt/1e3n9+QBYZZ7Rz4
	 scEuKaoP+perBtsgNGcDawNvfHstyI8elLefuocYP13EjYCjrgBBJKxJJKUBsA6EnX
	 oAn4Wau0NkxrQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 8BC43380CEDD;
	Fri, 30 Jan 2026 00:28:52 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260129094513.621310717801e65dce692162@linux-foundation.org>
References: <20260129094513.621310717801e65dce692162@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260129094513.621310717801e65dce692162@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-29-09-41
X-PR-Tracked-Commit-Id: bd58782995a2e6a07fd07255f3cc319f40b131c9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bcb6058a4b4596f12065276faeb9363dc4887ea9
Message-Id: <176973293118.3113374.1837769402149740462.pr-tracker-bot@kernel.org>
Date: Fri, 30 Jan 2026 00:28:51 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, mm-commits@vger.kernel.org
X-Rspamd-Server: rspam11
X-Stat-Signature: 5k1pkubgenwocppdxitht87ookg16h1k
X-Rspam-User: 
X-Rspamd-Queue-Id: EB962100007
X-HE-Tag: 1769732939-251963
X-HE-Meta: U2FsdGVkX1+ulBO/j2fWWQhmhWjruRxuH/jiHUgNwKxMf4EP/+Cb7YUhlnB5NMcs5F1j/r30PlH5ZxgfRYDd/DmUJmSkONqTQU2y5bwLe2TLKK0a5icWngcYNXnTkH3rhXLG5qrL0h1HXFSxyXrtxf1jltHXBUyhlp/GbyJOVFQ8nGJUpy6olH2VY8KFDp4MjaXSSMCBFM24PXABh7jfGk2Nl51CJLQLj7t2o+Nb9RyjicedmtCfue/kT/77mABVeWHdq8Sjlg1o7GMNsBoKjXCyonVvREjkKrMQAfcLFCOH/vks37MwpSfwF47xl6PaUZV7ex1cWI+qZ6ZrtGTSZB2oQ4x8AcmTKGUXSnBS0J5xNC7xNJEj4E1pH5Du24N85+ohlxzmgQEFQ1icbnrDBGwC6sDI26KmNsmqFsUXRaiJf2H9p13WhX0ZR7H7ZvP9EeAvWu2Emc/3XRV5Hq0y5N3k4Cp2hrY6SHSeZbOILsR5HfVQmkMzIxKqRDj6GzpsAcPvL1UcKH+rMFtQiDtWvXIwPm0cOe+cOVzxO6ru76THbuB49mv/O867T5v3WJmE+rf6vDW+y0PKqzGsLJf88cPzG5pdwn8mi1xWL449KJ/vEtvK0LBuZ0vq6GN4cJOHEg9FAPl49RVtmCFOdk8Zb5t62EFvVaPR7JG0l6Vn/ACBURcwSOLWXSCh2AS3bELcQLeI1pMoerjVqxAPREgg561xSEvhBUsacxuGjLAzckKWkUrAZFBjtQPcgBxrEC9r1KulvUrsgLlkLWL5l3MQ8L4PeFpC9Wd5ds2aT8A1VEfRTRsSoS6QIoPSusp+JCfkuPr58UIwhnnwWOkYwnnfFZsVxcT9inPTlG2QAeNr6bqCCWjzcbIjAXGwHQXlibwREKnsRBPFq7UPNMGxEKXfm6RZQEf566bScFs+lG+63AoVxvRHY/J6ZFAMLcnt0mYHOuIbfBvxbWqrYpiuyEH
 fjKF16F1
 AKkMDDj8Qv1l9kKQggmzz7tFOcaxxCNqE7SFpLv5w1Htt4i5ml0B8weNSCG9MHXLPrwMVAgSPCsUjTbfh9ExiU9WSczetrqPA5FiwN/sr6lIC+B+CJ9+TMh90Kzup4FzMVs8PO51lrau8ua+9ZE3XivN9HZPN3uEftK5TOxmk1VzbEbLYmYC+UVY+3aDdRHDu8kib5Kx0ALm8Ub2OLNZAGgzZXANs5RDO1BEvbP5APADS+8qRbl0bIAVgnhQ9W+cSFj+5tC8BPCa+BEZSz/2WYVaE7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Thu, 29 Jan 2026 09:45:13 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-01-29-09-41

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bcb6058a4b4596f12065276faeb9363dc4887ea9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

