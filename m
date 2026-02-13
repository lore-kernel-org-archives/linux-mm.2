Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08D6FEF99D3
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 20:18:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B22B6B0005; Fri, 13 Feb 2026 15:18:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255C16B0088; Fri, 13 Feb 2026 15:18:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16B776B008A; Fri, 13 Feb 2026 15:18:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 04A4D6B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:18:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 83EF7140650
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 20:18:09 +0000 (UTC)
X-FDA: 84440545098.16.0DDFA65
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9709840016
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 20:18:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s00Uy19n;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771013887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=t4lr13SWVUmJntNWgeecv6SQklZnEIFrGA+t6jkxNn8=;
	b=TE9GObtfOiAr4ShmdDXksIX0ygYYR/I2ezGJHjHxNSm8IVmxXrV4U/GZMnO412Rakw0TJM
	h69YEgkFZzpGy6DkGZOujJFYsgLeKrCJkafiYnCBHDk8ZU71v/8OIEoX4eYzlwxx3XD8NB
	q7DgKRnojcvhHGQMDLkIqTvKEFWsdtg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s00Uy19n;
	spf=pass (imf04.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771013887; a=rsa-sha256;
	cv=none;
	b=Lcms+qr4n+lSvg0P2GE6NiJwbuJ3NMwt+aZcFyIMQZfzO4ND0VLvcxbO3KTMiVmhFvLwhL
	vYAD+NvTnn9LqpISi8r7AwPdWRCryqZhl9upNrhHCsc+Sri5I7gOnH2IyildvS7UEUsH+u
	ArFJph525ftVogt2u6tFTgJ0hOHV494=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 660364456D;
	Fri, 13 Feb 2026 20:18:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44DB6C116C6;
	Fri, 13 Feb 2026 20:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771013886;
	bh=4GCjESj7JoK5fBFoy3ylJnUVgB7t3oqyOrWWSK4SDwc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=s00Uy19nbU6KE4eIoJ+ZDKH9jzOQoKWQM2XB5Y+ogVytTDpB7ueJ1P5tF7z1Fck92
	 49bThbDRK2HUIr2kkvNPCLSToKou0j+W59iGdKyHwfYnpDGgUSjxNDc413wZ2Ttie7
	 A4qVWNBXnj473LtkZLANDo+YKp7y7r9M6TUx/tukr9hxdL/sfIAEiVHFdjX8MIip0x
	 XWUohxjjFcnX8bgAaV2lwGE3cXHMImMF4oITjRNe8dfKyWLVF+kbmjgxmK6VjrlvEW
	 xJYG3cV2MSI0XAr+ACSl0m9c5R0KyMMP3HUdbCOnEBr9H8f2cWaMjHInDZxHKUbdvJ
	 UOwQmdCpjMeJg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 481A83811A44;
	Fri, 13 Feb 2026 20:18:01 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 7.0-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
References: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260213071717.77ff0bf809865bfb7901453a@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-13-07-14
X-PR-Tracked-Commit-Id: 61dc9f776705d6db6847c101b98fa4f0e9eb6fa3
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 44331bd6a6107a33f8082521b227ffa4ec063a40
Message-Id: <177101387975.2542361.12777525486322994831.pr-tracker-bot@kernel.org>
Date: Fri, 13 Feb 2026 20:17:59 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org
X-Rspamd-Server: rspam12
X-Stat-Signature: fbxxhj6uf3b4sp3cmorsmfk7u8gtgwyg
X-Rspamd-Queue-Id: 9709840016
X-Rspam-User: 
X-HE-Tag: 1771013887-538756
X-HE-Meta: U2FsdGVkX18NP8+6qgAz/HKXBUoXyz2dArmZDXaTq93PUsjlV4ONy5c9gPELsIyYAbmA1MmiEXL93krTrdtQnYWq7YzwB9I12gBWK+c0vYqfnNz6PP0VqBBLRR48r//RZoFT1i8CdMZE5DyOoQvShoNhwzxXIWr9y4lTOFg6056H6d3C6JAkdKT7Nckn56QbUBDIo4/3ZoGxTqPKB/TZt6IEDr0TKMrfFuVeBl5jUyC5KqwC/RQYNkKW84umwkhDe60j0pXY+/KMRszOMyGQBKN8IYfuCYOz/TNnFgRLsiG5W6aaC28Y1GIkDrfEoVnSSAnulkuvyjCEdfBsKXIaCpUtVEdlzmy/qmmfnrK5hXyvlOSS9BFbFxX+hWwFGRUHa7nfTO7JjNNHapWL2OCTSBGiDn8m7q5UyCAEDuI7ywQHpTZq8nUW+VPisNwAt1qI5f9upDRTuYp+481zmiOtWFGBdzAdVIvYuJE3bJR4sgCXds6evJ7in7WMpOzaPXju+zH/3c7oWBny4V1C4yUTOyz18hc80aUjXoCd8qq7hX2in+egASkDGSVPB2Yp89MxyZ/VRHdEMJeHNqPXdnUnb+PJQ3bHCcDcrxE/cv7NDIy7o6MEgzzO3Ba+csNaZSPTeqOEyADYD87GcvAjCdMr7p85tRGjhZewpPDXS78W/YiVHAtsWtcp0j6K2bG+sXSlfvWXoKKBxqc5l8ALbosc0d11GvNBP+49VdJa8cqgWk3C2OUKizlKSuvJPQxQ+g6uN8fYgPAXUEeEccwIiw7nWJehemG204t5rK+aTnEUCZCDwNCkCY1DNrd/CyXOgJwY8u+iTravuJVMG/+efFVxwsvvLQrk3t9qMLl/21lnxNOJVLwZyjXx1ePHbvlKKj8q0zdD6QRt7m6FP6lVX5nz+cmEGs3+pWdnTpgklLMJWBjj4HQnSS2U0vb47sFtP4U/qrDPVQHm9+R4r1EZYEy
 EHiJjhuN
 7OgdfczfNjZKAfR3Bjmsa7EsMx0l4b3cn/xtGFtnTxjMFunaUgYgpdHNFQ40Dek2qWT5VM5yUVs4o366muOvqhiEExm6RfIi5AcZQIBymuxDJo92pucWlh8EfGgAqfvB2hhb9ZDtgxrsEWTnsTaI5Mie6ouaRhad5XaN3w5ighYA0J4dZUFvgyOVEL6zNjPXpMEippMS9cesgLZ4ZG6MywNbuQWWHn6lVmfYZBSKpo8Wq+fGEhPZ5VJBMP3rJoyI2GRenLeVvvhOm5f5+CVjsYBzqlKQvLgSr5FC5e1yWWo9cgtPEHDqa0+Ubvr6xgyO5qDFDCJ0tLDr7kDKl1xOFlDt59fbuR++DSBhtRbwCe3CvUcEB+0i/bICponiYFedyEzDyrug3QTcmP24=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 13 Feb 2026 07:17:17 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2026-02-13-07-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/44331bd6a6107a33f8082521b227ffa4ec063a40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

