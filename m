Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 652B2C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:09:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611556B0088; Thu, 27 Aug 2026 13:09:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E82F6B0095; Thu, 27 Aug 2026 13:09:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529116B0096; Thu, 27 Aug 2026 13:09:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 305D26B0088
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:09:21 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B7D67120148
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:09:20 +0000 (UTC)
X-FDA: 85147685280.04.2CBBDD7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id DE7DF40011
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:09:18 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlqsaUiu;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787850558;
	b=J+NL8Qsr+b7aroF1bzsU1ISj96664IHijKFjs6BWEdZIAGtT5GfpFhxAk8Wqv3KrRdJRBl
	HPeaxOiD/wbnpqPqlIweJB7Sb6HtNN6me0RpsrYbQtS4RZ6Wqbn7k8wNWcrwut/dPT7/EE
	lkRiJzYbJ46V4IpPrFw4uoJPqtPZ+l8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IlqsaUiu;
	spf=pass (imf17.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787850558;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=2+TtOTWAn9+K8+57S9u3rhptl8PsUZnys96Z6mm5eEk=;
	b=8f42oJZChS+BSdmgakhYEugCcllPZs9QmlPG4yOTfVC5N+l9ENrXu8KK6nbq/aYSCpfTIS
	07rJIV+2oJYqdjKx59VsUdW/wYznLJCmTjof027FVwdRQXe/zRPotBxw0FUhVzuav2axbM
	qGKo+HD1NV4kvbHthFNYCwxquJYVQuE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 606EE601F6;
	Thu, 27 Aug 2026 17:09:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1689D1F000E9;
	Thu, 27 Aug 2026 17:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787850558;
	bh=2+TtOTWAn9+K8+57S9u3rhptl8PsUZnys96Z6mm5eEk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=IlqsaUiubPVhLE71yfQCZwtFSXNDceRztFia7OehE3IagvK7OxB6h7BkRC0tOA5Ti
	 LfqnUwyepxWQBy/uIYgOigX7i/ZBYBTXxW9dVqbyYE//UIV/WGvoevPVY6mvIGot59
	 qMwt4OPBLZ/C13fxbOtsqXJ9eT3DbdtwHjN6hSY4lSixfX8G3lPOb91rf0YsTT6B7R
	 UoxVDmb0eda/oqu+3ivLBLmjN/SykmoocsTO5CejYYlwsJqrosNcp4W0tYbwlvIt/W
	 etld41JqN87WlrW/hWoMSNqyDNhLbGtY6V3hrFTrSXvsXunycy/fPkit1Mw67r1gBr
	 du+FGoVRqOrTA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D0C203809A89;
	Thu, 27 Aug 2026 17:08:24 +0000 (UTC)
Subject: Re: [GIT PULL] additional MM updates for 7.3-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org>
References: <20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20260826152330.9cdd482b43726942d6c149cb@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-08-26-15-22
X-PR-Tracked-Commit-Id: 0685630fdccb62dcb0e3f44525a40578da5f6dc8
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 18fbf5151d2c0bfe433c7428eef03cabf5fdb2fa
Message-Id: <178785050350.1753754.11441521265176590388.pr-tracker-bot@kernel.org>
Date: Thu, 27 Aug 2026 17:08:23 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DE7DF40011
X-Stat-Signature: 4ox5jqp877wihcb78arkomxkwkrwbdqp
X-HE-Tag: 1787850558-324245
X-HE-Meta: U2FsdGVkX1+aBgVRJhW3VbMJuRgsX1ULwkmmZTFudsPFBNyq3+qm2P/YEvNLQqUeFc7Gt4Fkt2t9h7uk5ymr6fNAtdvvujW/jQpfWE7Z9Qi14b1YZm3MUV6Wsmr5rJywuo4N6phIIWHUUthMLcH72BV0ccSRJ5csDRTBg3GFsKxrjLSkwrLIK2+et7+HftGWZR/OO1Y2nFvOV/HpW2ommZbNMQz3Hy8uerVvbq7cexChTiPIDCbq/tWHbIt8sV2QAmaR4TkgwousHlNF9j39/VETq0SQFMABMyCtrRjmiKi1cEE4EiCLV5Qqq+pxF3gtkKJ/zbXMBCxrALI94OgyE+1NN+gXOUoBV0IzvHCp1aG2Ya40MN7DYlcOTWtwNZVniyUD5vbRIwAg6s0ys7FMPk7aCXHaZZiLyxAzXtt4Z0erthCwAygHIs1VaotofjmAJsOitjBd51sM8GgFZyZ7Wvuo7JCo+Kp1lIhbnjq6RaoOaY7e4/yOcG6dfcWYBVqF0L2PqOFa6kO4Kqw7oiXFmo4orCOI6/0mPd3m2ElCOxwCM7HvWjjqNmG5mbx3PZxRKJ8Z5J3HykZ15tSinVXZP7Hldt7EJD4+a0OyGzs3Lt57ijTxF3Z+u6BOESg7lsBxU6SBZDiYcE2wGKudxp7hUc7FwPC4auMBT5/o9Qna25YTSFmONX3L94Coznoj2F4WqUSjUGF/JgoOKFqXNrPHHGg7psV7fK6ADQ/iV6CiffQSzM5e4S3gu2s7smZnbIwo2EZIFc4qzuBg2grQXWmj6BnYj26MVzu4CPhxXJc3UPNlxrSz1VQzyc6NXHKU8aNpZ8eMgHS0dVj8Zc+Yf738TBLym2eCoAz9NgcZzC8OKhKzY91Xvlgs1BxeorLUk5qKecXWbuEn+3o7tn6Z+MFzit71gyp9m8BLmu0Jk0MNcfUqLa8YdQlNwTZ2mLR/LAzAgX/fi0o2XvcktktIONT
 I6LFnkFQ
 ghTnRSEonxKCA8Laqnl/cbXzj0Gz1OzrvvDZhhXSeJ3fpFVF1DatXjiIUJx8Xn6lDTwGnNwGdesQDHFwFX1cBWW/OfNSs6gxgoQ/YOXJCbaxsTKyS1fqiJv4/R/epfQ6MIU04RKvNVXJlK7rwtZYUiiAvjOuJwIloE3m6IbyAuhkLryMCAS0m//BL43545IUn1VrYwye4LWCprNiw/bt47l6tDzfUKox7ZP3SGsE0F0i4a5yuaE4tHfBqwQtxLoAI5/ANXEJkDddXRKiotnwmIlMs667bM1U1GBZLqAmkuz9PJF+4eCXQ8aiUMgfS5lsOtv+Byz6KIEA66weL03MOiuLYgraTXDD22N8qNVfQp7159DOnkdI14Uatc8hNEkEQT+OdgtkQMLiaYA3nXgl18SM5JHYm2jDfH860z8aZlribprSZgkLR2v3nBg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 26 Aug 2026 15:23:30 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-stable-2026-08-26-15-22

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/18fbf5151d2c0bfe433c7428eef03cabf5fdb2fa

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

