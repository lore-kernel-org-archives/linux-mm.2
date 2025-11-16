Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8041CEBF61
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 21:57:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99E938E0003; Sun, 16 Nov 2025 16:57:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976188E0002; Sun, 16 Nov 2025 16:57:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3008E0003; Sun, 16 Nov 2025 16:57:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 748788E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 16:57:02 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D9EC21609CC
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 21:57:01 +0000 (UTC)
X-FDA: 84117831042.05.7F5029E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id F02BEA0006
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 21:56:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imgMWj9j;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763330220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7DMuKxlUdMUlJYydxnybLCw7JLSX7a5aCTmZrxWwxS0=;
	b=L15tXY4LtdCi8vWMFMW3glJwERfjKr8TnlJ+n8fuS2m1PQtmiL8cEsoMeaif0Xi03oHhSH
	uk2V4kRYw6n+dCtzUZ36KcmACKb5ATEmK9QyMJrw8R7yWOnA60Ix6MKVYJCdL7S/2Zam/L
	gle4DT55uuoFYaI3cWRQNqndyMl4J/0=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=imgMWj9j;
	spf=pass (imf25.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763330220; a=rsa-sha256;
	cv=none;
	b=qWiFU5534oIagwfQ+KeGHmvURdqXHXnTyCYMfotNNZzeF1TbyN1KWEv7lQmfCXPV6fpwae
	UHNhN/MF9qfmoaAiPxm6i3VsCmNLMqsEPGrS3batowDFk2MgImCVSUZEBpMIH27dagMNmj
	WCDgjvc2lI0QuSrnWBTkLVmagTQyYh8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBF2C43F1E;
	Sun, 16 Nov 2025 21:56:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB99C113D0;
	Sun, 16 Nov 2025 21:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763330218;
	bh=PDkkOpiMJjesVYweoYCtun20J+ToVKvJguekRA83Gvs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=imgMWj9jXwpT2fJ0dQygRWxglESWZLeezswF+2hohCPEoLXLakrM5eQEfsvDp0RZ4
	 ldBdLjFULi0ioNeePqjj3t5reie4soJ3QC83WOYZXJM10EG7wq5iW2m5Nh0k3TxnDk
	 UtMtkLxPt3PEscez1MqPBwQXpCbtwxSjmKXZ3uuSPS0Q11atglqqq3r3gWwivjpGwg
	 7zXE5SLCLOrQAYXYYV+niHaYLDoj5SmHtK9oNEb/ZkNBN1vnUe0YZ36K04pWPCGxXh
	 94Z7N+P8lqDNcvxNSw1uDysrcClEYRPK0qxoIgl2ccmTuxNSOuSxbaGj+7AWHh9wdw
	 ffeH97zWYNrRA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 340523A78B25;
	Sun, 16 Nov 2025 21:56:27 +0000 (UTC)
Subject: Re: [GIT PULL] more hotfixes for 6.18-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
References: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251116104314.af398baa1fafa06daee19ce3@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-16-10-40
X-PR-Tracked-Commit-Id: 1c2a936edd71e133f2806e68324ec81a4eb07588
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ba45f15049b4442c932ca2499aec739bb6bdbcf
Message-Id: <176333018574.2325379.9692418358427217808.pr-tracker-bot@kernel.org>
Date: Sun, 16 Nov 2025 21:56:25 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F02BEA0006
X-Stat-Signature: h7djnfgtcwoug49ko9z5o757t971poes
X-Rspam-User: 
X-HE-Tag: 1763330219-252367
X-HE-Meta: U2FsdGVkX19nzmulK/rWu0S/Me6VqS3SCQKU1XzDGSPrG2LMY4y0XfcXbx93bEEFMhH4mqNtSMG00DQ5Xk7F4gmNivD6Fs/tSM6MyWWWGUTVcWkG6CRg9A0IdWUZHOO0NpcQ+eyqlfoe7fE6MIKL4SAjFODAGDWKodZEI16c6KqJI8i1DLH7FzJBG6HjSlnkmb1nbEfq2zQ9Dl7NvDQJ20CRcN+2GvbEp7f0wf63dwEH9STz4qY9l27LgXavc8p7XmNUgD4lytojqZN9N7ew4tbwlOQvQzx7RBRqQm8FhBH3uNbPEuZFa09fNqR1X8eCE/Pbu7SypEs/v65HBx9T1btCOOhaLSd5mu2igLNPo62oMcDoEnVyoJJs50dg6U6xHALpeyaZFyQ6LC3k849XKtS5z7TXM4LFV1dCGJxTi/eQuUDItIRVcPbfJ0on2mp1CBz39E4F3pEEkQo7NI3T/ufLz/CmOcVElxBAxnZCYnH09TWEtmwIEH85fukbbd+xfsyAacA8qyjSf5pUntMdvENlGKp/f0NEs+v3Dm91YJmBjT+cK0TEV+86Nfi+nYi2L5Dp+fL8YkaIB75IVw6PUs07l/SNU5cdojFGeGm9N2lmWNUGQkVWZazBaUYpSHbwWMZfA1s5CYjqbuEc/DT92p0wEXzR7OiXgjal17CC2U68U9h6WSqYA7uzU02imePqufATxc1jt7zft5QK4TRAo6OWBLmzxKIGSFDPeBZt0380HqISn+sIfzfI3yvKU2tZjy6ksruAGe9lsYvTD73td9CRXysPmJhR9ltZyTeAdPvzDPkGV1Vln/wKmI2788woIGV9fyz/UrZmnchqImipXkrvDE3X9ov2MLFzLOMBEiE6RvKQ5xCveaRoJ52LQMxw1/AFHwhvJ6sBC+xw7fak9hrJIsMIVlfmRbCV2XiyOP+a4U8oISpkid9US6W/gcosDiSZi+cbX59NX87WHym
 6QI9ivak
 UzoPdYCDQjrFOmVYSNzgZ2L4F7bXeMMh39bfQSLb7qQd/ZE/sVaOiw37eqLzHQcdbvi8zE5W5qNlFLmoG64apFhkuwqeuecXH8uyW58ojwNWSMWpfWzQLA4cV83QRu7p5xUhXtlI3pbUpOVNPUj9MJB90DwIsfL6EiHTHCKopmV4O4J3Qw/stZ4rU5b04QQG2NrA+U8AZCw0d3egXTJq/S8PQRmjKfO+ysKoXPVI0cEnaejNgqHoywLlSzy+jYLjcpXIylT8aU9vv0JaOkC8hCBQymQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sun, 16 Nov 2025 10:43:14 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-11-16-10-40

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ba45f15049b4442c932ca2499aec739bb6bdbcf

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

