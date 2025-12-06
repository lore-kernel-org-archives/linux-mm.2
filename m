Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3915DD3B7D5
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 23:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518D06B0005; Sat,  6 Dec 2025 18:36:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C9CB6B0006; Sat,  6 Dec 2025 18:36:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DF866B0008; Sat,  6 Dec 2025 18:36:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C15F6B0005
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 18:36:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AA8585A0BA
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:36:47 +0000 (UTC)
X-FDA: 84190658454.02.529269D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id BA71D40006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 23:36:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k2klsx0L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765064205; a=rsa-sha256;
	cv=none;
	b=bN6vHmo1DT1zNc6mIHAhVFSAlT+4tzEa9uD8eQeGQAekmJlwz9Iu7+VCtg1CTIWeWMItAW
	/C1ovcDh/B7AFr8VjAIHLdgVnKvHcsQ4AyfdQ+2dOhmaOyOP8RS9xOPf8byF1kddfXzABn
	Xj/IVmuDWZdyTTojCUaFqNLsETCMZak=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k2klsx0L;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765064205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=DRwcwif5ArI2j1mRP3kfUrtfzF126MdXDppYhTAz4Mg=;
	b=0JMz5fP4Mt+Vc5hLclMeVF6kcMKcDPK2ph0H0sEcuxPfTLnspbB7tOk8QP0yyKUaN3Bra9
	aHMyhDF1ZV+JLJVm6wfifHZuFjZmqcaoonBZF+m2cas/ufe//ewJpCEQnHF9MxE3GT+wO8
	tpY8uR5jwFH9Jv9LU3QGyrrwZLoCiFk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D231B43798;
	Sat,  6 Dec 2025 23:36:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF859C4CEF5;
	Sat,  6 Dec 2025 23:36:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765064204;
	bh=Xy490bYBXRCIaVdEKOF3H87YYhykbLI6BBVU7qxvw8w=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=k2klsx0Lyr/CRmhIoWDzB2CeQa9otxOJLF+ctidxe21AX9WupLN8nJTraZqfi0zUG
	 ryGJgwbCq82cy6kTDHgdMkYETXqEB45kX+tenLEoP9nJ/vi0dMwhP+PxzCUZ6VrSyO
	 9yVg2D8gwV67GQpV4Q6nyu3akzef6QnUt/MqTS+sa1HWiN2WoxUbI8aKgcuJG2YczR
	 lRsK1chsLJy7qlrELB4lMfVzqUrfPUFuQe9PsKnFQ+x+QdxNvUr6VVPNyMHNFOy55r
	 kBnwR+JuwGYJqdAlHF5j+9YirP/D4pdjJiR5/62ydvQMH4w6SHECW272pXqdAqwDji
	 iIu4E77DmQcFg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id B59B63808200;
	Sat,  6 Dec 2025 23:33:42 +0000 (UTC)
Subject: Re: [GIT PULL] non-MM updates for 6.19-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
References: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20251206111533.f1b18ce84d0854b5f6d86a8f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-06-11-14
X-PR-Tracked-Commit-Id: aa514a297a0c175239f24a2e582ebd37f0727494
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 509d3f45847627f4c5cdce004c3ec79262b5239c
Message-Id: <176506402140.2232960.14577174906108791705.pr-tracker-bot@kernel.org>
Date: Sat, 06 Dec 2025 23:33:41 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linuxfoundation.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mm-commits@vger.kernel.org, Pasha Tatashin <pasha.tatashin@soleen.com>
X-Rspamd-Queue-Id: BA71D40006
X-Stat-Signature: hsw339brzck9r4amno9zdk1h737rofkk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1765064205-120938
X-HE-Meta: U2FsdGVkX18TKozq8JajYcEB4CbZ+sdTAtlMN9ZN9qxLmKabZPoz4jQ+Z1w3nWamJ+Agjt55YCcev/bzctey9c85h+ZvWYF5jjfRrIUYc9s6h9+jk9G16f9h6NVtHSKHSxdNyl6WYynpLAU6nKO2zHOMt6/SGkpS/aDs3jyZN3p1h6GtrtztqHeQxVkriJW3xU49pbCKTon4t2+iODPlFernbXe6uTJ/Ij2QoNA8BFr0/OwLSro123IAxFs/OW7p9bi2jMitLau1Ttg5aOPZ3Txul5mt67v/u3NjNoOcnrPwz10MfBk0krczOCAhorrFEZ4vuEP0BsbG4LKrVV8IlTPCA4hoBusybmkLY9RBBwOZcudXJr70W37+NNjwBi/qYid05S7XBleUYu0TmvehSLqCO1ksRWEZ4odpfNypENdLzWWlI/klDlBHuECTbWyj2wuW9naeKF98FrXqwXlyttRyzevv0GTNmQ3qdKROZDjtl+y7Paoy4rCVBiJV/qP5FwSDufRaoWaWp4cMZfW0X9eNkSMTCZ4r7VhSSR/S/aZmW7zIZfpvN75gnSqhYQr5BFaQoLQfyUI5NHArG5W7y/kK9v3OSNFtSFPzi11ubdouHhHo3E3ajan4efHFyFZmVgC2l7pRV267Af4wWON2dgjps1dHXJ0JmxgZP0G8oI+HCRexdMS70iOFl0NMhQar+Q7EHSxyPJaUlS0wIEdkgZbhPeWCnmZF3q7OWmoJma0B5rgTAb8+hdD1iYNrHhdeqi5vw9/FdnC9syuNLsgMC16zZqZqoq+Ch6lp0HcumV1KItyrU2nSWk7Bw0Zir5PvaEXwEzx8k1y8BQEThveZ0si8w9i7tFDw7O1xe61h1+8VwXbdzo9gAGew6f/33CASbrMpYOfsU08I6cF/YEg8DDDK0WeKWcya54n3XK94jdHP9sgBMhCPgfEDMUcTqk42BOZwxJnZ6GeCoFc5+cP
 nP+rF+U5
 DryO+tcAtHwTHaoa+dYGQUMp0bCEtAxl9efsyx9WZaT+CsxIyULD4kmlLnAioNB01oJ8s8zzgHhRHD0bxstInCbiKFjzMD7vv/6S2/ppDXmXhANuuBKzR1HVUAIGZ2d7I+/06cl8QWUJlNrl8qEazFUw9xzabkRxei5ATI6RG/wfKavp5rQfBBYcBwyeTukArYNjcrpXSog1oKS/zVkVg3TfatorUo+0456EedPMUviIGAvXcHbXD7m84Qs478Zi10mAWbZa9wykPMJDVS5B1vB81KQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Sat, 6 Dec 2025 11:15:33 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-nonmm-stable-2025-12-06-11-14

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/509d3f45847627f4c5cdce004c3ec79262b5239c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

