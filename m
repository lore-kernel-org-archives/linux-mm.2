Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB7A1E7FDD3
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 20:48:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DA306B0005; Mon,  2 Feb 2026 15:48:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1880F6B0088; Mon,  2 Feb 2026 15:48:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0940B6B0089; Mon,  2 Feb 2026 15:48:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E94A76B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 15:48:02 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7778957426
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:48:02 +0000 (UTC)
X-FDA: 84400703604.02.BE50C9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id A90441C0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 20:48:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sie31vNs;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770065280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=NKcggRejeW0rq8EeDgXa/5w1xW3qRzMeZprnYunh+I8=;
	b=7T1+8PnJD04U9RIvYkGMcKeZ2UZ73SltlLMwKffnTiroWedwPTPqFR3jpCwSJGFpAAOPw8
	BtKjIvIREyyEwt5n3mOcMnicm2CpmPU+1g5I32nj8ilLHL6mokhAT0L9FBBYJjJCdKG9AU
	JDxPmgND7d8n4fHr0cEwGhFX6caXzMw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Sie31vNs;
	spf=pass (imf18.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770065280; a=rsa-sha256;
	cv=none;
	b=UwDSHvSiCGeqBYEBX9VT208RFpDLfFOYxHM85EM/o8+7BofmMYqILE0Jlif3wrf7ske2XE
	Z6QFz4ghwgI294splOzzY0JRNuw/pjw0n/Y9i2fjm24RmJ2HQqvlEGPSijB1PPXuHWjG8T
	dZKxNk+vzE1YOaNsh5AOOe3C5NKb6L0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 90984600AA;
	Mon,  2 Feb 2026 20:47:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D36C116C6;
	Mon,  2 Feb 2026 20:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770065279;
	bh=LiK/bkOXAJsd6g5x9DXzkN5eQPipgwgbVBb2oEEJpHs=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=Sie31vNstj2Cu4CjhJMwTFLNYd87lPTGcX0eQtrV4/aaLJVZhq4t6mbUpvmLK7+y1
	 usQuV7QvFSty9PXa29mTbEP1BHb0gWnzBxSxeJGTQ2BxI2Ygp7Dypjo3jdrCLd6CpN
	 +kHAroSgil8p9WRhfpCV9kl5OJ+jZdsqZKbxohEMSjXR2bZI0yKvBTizhNth29zy+L
	 zJmr9KeTp2sc0bPgzjhYj6MIM+FBQ78KT7T8F03Vwkuyr4ePOGOpXOR9eiMad7Qmyy
	 KTiLjGhwZ/NgYe/85Kuv95JAtB8WDzMwTyw9xHOJAHpCgjYjMBrrHwbfoPiV+n73pD
	 v68A3kbs+G8zg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 542B13808200;
	Mon,  2 Feb 2026 20:47:57 +0000 (UTC)
Subject: Re: [GIT PULL] lsm/lsm-pr-20260202
From: pr-tracker-bot@kernel.org
In-Reply-To: <1840fe300392f962e0bd444941c24969@paul-moore.com>
References: <1840fe300392f962e0bd444941c24969@paul-moore.com>
X-PR-Tracked-List-Id: <linux-security-module.vger.kernel.org>
X-PR-Tracked-Message-Id: <1840fe300392f962e0bd444941c24969@paul-moore.com>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git tags/lsm-pr-20260202
X-PR-Tracked-Commit-Id: bdde21d3e77da55121885fd2ef42bc6a15ac2f0c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: dee65f79364c18033cabdf0728c7e7025405cf40
Message-Id: <177006527594.1185825.11940018596223733420.pr-tracker-bot@kernel.org>
Date: Mon, 02 Feb 2026 20:47:55 +0000
To: Paul Moore <paul@paul-moore.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: A90441C0005
X-Stat-Signature: 54dcpystjuibxo3kqp8ezyxg1y7czmaw
X-Rspam-User: 
X-HE-Tag: 1770065280-381540
X-HE-Meta: U2FsdGVkX1+eFswaOVooKVyD7829WLE7LWKtJcKS3We0mCot9o0IhO4CuTrb6OHRHlsJLIxfOtin3YNNH2rsRW1BTaiEpsCV01SdF5Ea5VCgdPfS1WH4lTfpPEX7YNmT1FKhSfuCHmijJeS/wydh54HngrKDNBpUYrD4NEtNVf5GKok9u3SGPx2Oc3A8T4T1hlDoOVgRapj1BIU5eGZJ88RQPaINfHhcId0iWWLgVOtOvrxz8doHcmPYYn+o0M4CdSo9LHJeIT41WZZ/gsI73MJ4bVcSGmZpLZQSmnOjglIkiHeZemnTWGNve0TbeReDpxAw/UMcEvbYkV1iBjEsDDqtHsj3hoWAWHHJ68A4n3Io4stguGoqsAgILGhJll62S/jmcG9jaMgYPKqpYSpGmxVBpATKMelE3rOKPjhJB75l7+y3AZwRcoDRNWosBPwx/X2HnD/rFoDWMO3BVV/SstgiaD5mRAeb7hbYCRUX9AtaQvqgjzOW4ObhSBJWlZlgSy2hhzKTh5uQhNr4pBQKj50QC5GxAqUW6qjpxV4EfBD50z0ZDMbBADABOVpuyLo0gUpXi6oGhJFJBUhMp5r2Go6dipl4kSiCE1k6JW9QeZuF26MXc6XlKstNFByIzt0Jc53FkWjhK7IZzlM+JuSgvCw7I20noU7sk31VSqNJ4lAdur/jAiVFZwFHNUvU8GOE372EUSmqtHCdi8jvVOvj/Ihd4S+GbG5KdmLt7f4AONEcsCT2/0LckXIGX7yz93QWI+LhvkT76fGUqF9pNDt5IVIvDmq3nPlFPrB+GziiOlGHYB7QNPa9KMS731S7Zaghv6FsZ3PPXNz/yWbnyHqOLKOb+xMV7fkk1XtqRCNW+5MSkW5Acr2kGQLSL4JW4jIpe3W4YRNAd2fP61aCJUzisXnzXhmNW0FGt3rbJe2sky/Fr9ExwiEx1IU4hjhDGtDFj2/+oW1HIyPQx9sOt3p
 HrMe9+NU
 OxV1KhbqDHJQZQLScqcGbUNzaDjY8oCERCB6acs4+GSos4+GcHKHBJL63b5PzsKzzFkXPwm8D6vHgQdivNGdjgg/d77qk4A7cTYwpA4uweKyfbza0N7GcPrZ+19j1+KR/0GsY3jhAEcm/MPMeMo4J6QA7FwYDALyOJJ8ETz1jxNIK2JZLlq+JGDHWLuhIApConhz3ype8hDs67TA1jLGFaBHyX+dqDZz0IBVJimH7s1keoa8h5UF5TzPr+VdLHIh4RDLdmefH6boz5Wb9pJUeNW9X8k4AFTHWyApDyT6wrsXUBwpNQJWfQSM0vKiNELQffTzXQ21pimPSIjiSW5mYdxnQywxRvcjpgKt1I0zTISAkur+iBZ/cukrudmwpNZUoEHAnZfH/D83kwGw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Mon, 02 Feb 2026 12:37:02 -0500:

> https://git.kernel.org/pub/scm/linux/kernel/git/pcmoore/lsm.git tags/lsm-pr-20260202

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/dee65f79364c18033cabdf0728c7e7025405cf40

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

