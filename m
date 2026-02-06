Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CC5EE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:10:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 546106B0088; Fri,  6 Feb 2026 18:10:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F4346B0089; Fri,  6 Feb 2026 18:10:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44B676B0092; Fri,  6 Feb 2026 18:10:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 37DAB6B0088
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:10:00 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA0B2B84D0
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:09:59 +0000 (UTC)
X-FDA: 84415576518.20.DCBAE14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 230F5180009
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:09:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRfdhljK;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770419398;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=R7PSIj1um49B2rZPEPWzXpIsmmnu8lgm9Xiu2RRyqq4=;
	b=eTR7bv6rByE9g8eKZ9btXSAeVqALpSl9+5PJbKl7ZDys6BJ+GVxPxwERj5Sf+q9HH5jcUN
	bAuzcy5DTb+1GvoIwa1h0CyI+f6Fs78xyv7lfYLrO17jGCl/l/sr6qok9hfGXeawwvoiyg
	dnhjlaVJR2OKSc6BmwtPJUsQg1DohwU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WRfdhljK;
	spf=pass (imf16.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770419398; a=rsa-sha256;
	cv=none;
	b=5ZwNlCyIclrpILdOncG2PXIPWCuYtMbxKO2ewCxR4LvmMP4sEwpaXDbY7Ne+aI9avvGzkg
	Sx3RIBZ4VL/PNwyTVRoxWaGEvp+y64PxplTYIIG1ziFWaePz90R+N78+OGTI+9nihJpwZ/
	kPKONurnqwMTQROySmdNkmI5Q91hP6I=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CAFEE408F6;
	Fri,  6 Feb 2026 23:09:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88F5C116C6;
	Fri,  6 Feb 2026 23:09:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770419396;
	bh=JCLA96J6mzpfoWLV1MrmcZoPb5/P8YN14N+axSjroRg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=WRfdhljKPpCHQto6BHAf2FZB7fyaBPESBXuAyRJldYsKApq2lUudppXjrMXIg974i
	 asdFmsLEUu8SCln50jYpxYMrqgdilUl9C2TPrx2RGXgY+DF/BUWEsbmeo2gjGy7WKD
	 CwEGbDgCU9mKFEzdyMsdmIocKZWCdjdcDfd7CzeIHC1mWe3xLsu7R5E3DEkLZzVbWO
	 aqP75ed0Qpwnczl7yCExCOpghBaNQuCtw+PrkUDunkwThg2lv6qXEGs/gKySD3w2TK
	 7Ws2im9l9ue4yX38BjZCDkO+Dqxo6DNxu9BkSp00XOGPYsUp3J4U6eE1ENSudsXG6Q
	 t0pA4EgPrlLKA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 0B3F53809A17;
	Fri,  6 Feb 2026 23:09:55 +0000 (UTC)
Subject: Re: [GIT PULL] slab fix for 6.19-rc8
From: pr-tracker-bot@kernel.org
In-Reply-To: <c5f2a4f2-8156-4c4a-9f28-0fe129893e2a@suse.cz>
References: <c5f2a4f2-8156-4c4a-9f28-0fe129893e2a@suse.cz>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <c5f2a4f2-8156-4c4a-9f28-0fe129893e2a@suse.cz>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc8-fix
X-PR-Tracked-Commit-Id: e6c53ead2d8fa73206e0a63e9cd9aea6bc929837
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5ca98c22b5c4507fad4513a504d7c5ec46cd0386
Message-Id: <177041939361.1109628.15892298095020403352.pr-tracker-bot@kernel.org>
Date: Fri, 06 Feb 2026 23:09:53 +0000
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 230F5180009
X-Stat-Signature: dosf3iqym7tywmf7qcgx7eiihk3z7smg
X-Rspam-User: 
X-HE-Tag: 1770419397-299383
X-HE-Meta: U2FsdGVkX19UDfSzi7RQA2njGNMjWE5Tihzf+ocDo7kN4XM7UigHOc4++lCJe0XRdTs2QDg/7R6jVdQYR+YWRYLRUUUbrYOWB7djVEZbRAbCj1UQPRAja7rOg0vi4bODt4ox0EjqAjp1YTI6d5mn6DFG+UNTSTZkHYtNFCD8dPdMwP883uc7XSu6Ix0l/1rDE4QJo3cjEc8fvMErkt/TfWMNXwCQjnkey0DXWOoXBFTBzjfZyOqagTl1b3kAVF2fsVf7Epm8Y5xJAL/+lvlxMZUpJZrjBIE+9qPq61OWdHcPF3W3NCK17PceiEIvSVAMaIVjrMcV1+HWBlnWxIwubGP49fl7d/qmo8Iiyzrc1ABxwCcyX2OObsE76qg4aFFePCUEbHJf3vVUcqxftjsezzDDevUgxnrQrAzwHWl7pBW5vpOLDhheGIAOm8OuX7EcFhDOogza4Zw9LY1bTVDOiCqOaGtTzynGFTEfvBeQ37F/M9tyrKvcEpLFT6CLrtU/9Gli1ZwlwqkXNXRA0U9GIJtz4pfDy194MIQQRFEk4nZwB6r6kr8Hr6jwvrzKETvX2NwX/ibZOOW696UzLhZgeg/YRW893T/AUCWGAqI1aYriAC7c5agFT4gAFEbUuDD0XNeyuEbmXYFY4nTxRvXcqJBYAFQJFqnlAqyAtlqSPZfL3XF7lSX7DkQ2PXusb+SEWAp7U+l8jegQCkp4l4e7C8YW+wQX720OXF6FrGnsRV2NBzNCfYh+lVeuQM8bAiqKOh4a18DCvXhYX6I7n4u5M4V4bdKSw2E+w3qC9pldNEa8ZOJpNTfb4azZIStSExJez+tW4eGrcKiOKmVIO+FW/NasmhKGodw0NE/4+8r5xQv1LUYoVVG6CM3Sd0CeLIFawbbsu3UWOL6zFraweQnmMm7jSmBbcFUDQhotMB1UiWgghvSZAOZQ0mNhZCvr38TFg3wtLvWNxxZ+mAyO33X
 ALykgGhj
 TUc3xiBAxtS/TcMbAYJ75BQNo/HXEcagbGJ4JtVQ/vM8zkSsnTmbFARCgYUMjtBvmMNSPnXBFOGXLME7ufzp3LdyONOnCgEpHy8MI1ZgpHKOM9cN0WClTVg1hbhkUCT4yNiJEvdi9z44n1yrSVqfuu55+7/Cyv3SeqQ0xoPi/T/3lR+i4RPQE5jlAJj6WFNCzgA2YyoFS3TJ0AVTObtxgKXtM/b782gbNB72RhzUQIkR8792xIhPbq81qjThukS+OHJJV9VV46E9Uj0xukEJSrhdPgaOQEpnGYlIbtSRCJc6ii3CQYuBieyhZRCkiJDNDAELYrJjkHin4TuDonufAqaKToMQbwidr0O26DY9L4znMLn74sKSsUXTcKWThgXa69IJR/v53SEGp/dbHxvgONi81oWv3vIzS9veA1s5hbYkPy3XCebI5SuHvtQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 6 Feb 2026 09:59:01 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-6.19-rc8-fix

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5ca98c22b5c4507fad4513a504d7c5ec46cd0386

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

