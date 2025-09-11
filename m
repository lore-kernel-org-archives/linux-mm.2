Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5255CCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 14:59:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3E7294000A; Thu, 11 Sep 2025 10:59:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE4B940007; Thu, 11 Sep 2025 10:59:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2BBA94000A; Thu, 11 Sep 2025 10:59:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 91ECE940007
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 10:59:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2D1681604CE
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:59:44 +0000 (UTC)
X-FDA: 83877278688.19.8A8B4D9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3173B2000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:59:41 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AERr1Yeu;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757602782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CSCzR11sCKlKm9rd6/Rsr6OmrZt4XG/qx7gM5bANgHg=;
	b=PWU+a+J3uxWZ3J4d/OzYg4GABU81R1EYxTBAam8QxuTNMdc0VLznUA6L8AiLhwijVlLhrl
	MgdYecflDFGOV7wTZ+5S+Pf0iKFhvwSpl+/mkGugEv/AcRlZ88M34Y8b2W9SmVlx97tYkc
	q3h7yR5nqJtmB/ZeXjBWdAuDRknpsG4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757602782; a=rsa-sha256;
	cv=none;
	b=ZXZvAi6qyx7GixuBVit+5I740kUkDa9AqRavuaYS6+thP6m0vNyxaAResU7NgCPR1+kUtD
	4nt5COgUXEKegKSmX0H65TrafyFNxbzvs91P764Eu9kf+q6/JwNYsiY5Jve4i+oWeSZZap
	Vo8nxqKdtDUeQGoDwJjZQZlTyP/HsTQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AERr1Yeu;
	spf=pass (imf13.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA6AC44FA5;
	Thu, 11 Sep 2025 14:59:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE1B0C4CEF0;
	Thu, 11 Sep 2025 14:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757602780;
	bh=d9nAFXGJzmeWzLCo0MGgmQRlh5gWyfX0TrCYQC8mEIk=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
	b=AERr1Yeum+bWPl8xQvvh75i/6VVOcutsllTdjwjlg4aS+vudiUiH2/kvyXmRlQO0u
	 gaq+x+uTYpwSE0FoNrI8l7wffqnFdr/b8yyuNK9xco1QBW9NyHLpQ68GX/HOq7XZje
	 XSabv07yNgkvPk+NEAI8z/V/BjdgWk2AvnvMapqhDF6cqZWOv0npI12JBXWRl0OSfU
	 R0Oo3cAHjfj+9L5+OBy2b6vG+C/MWtqWgXc2/EbebUOhB8xlFnF9yQpSXaEtLGMoT4
	 lZW9+5jHYqPZ1Wpn9xdzQPZtjr3u2dstolJgSTRYufxmmBvo9z5QALRzWpejFfknlO
	 okjpx496nP/XA==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF8A383BF69;
	Thu, 11 Sep 2025 14:59:44 +0000 (UTC)
Subject: Re: [GIT PULL] hotfixes for 6.17-rc6
From: pr-tracker-bot@kernel.org
In-Reply-To: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
References: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
X-PR-Tracked-List-Id: <mm-commits.vger.kernel.org>
X-PR-Tracked-Message-Id: <20250910200250.b110da062c9561aa092c479f@linux-foundation.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-10-20-00
X-PR-Tracked-Commit-Id: a68172d95c2845d2b5455b072b4ff51ba32650e9
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4f553c1e2c7b81e957b5463bd7efad2465a586f8
Message-Id: <175760278335.2208976.10071544460985449453.pr-tracker-bot@kernel.org>
Date: Thu, 11 Sep 2025 14:59:43 +0000
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org, mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
X-Stat-Signature: fpgzgt1hyg98a3zt3pemxgxnrqso5fg3
X-Rspam-User: 
X-Rspamd-Queue-Id: 3173B2000C
X-Rspamd-Server: rspam10
X-HE-Tag: 1757602781-727049
X-HE-Meta: U2FsdGVkX19DyPxOFGdIMn1KU1rR0Gcfec5hxy1VKQWQbxa6C+g7vsFw7Dc95+M9FP4WIZvFOaMhRN5C6NnK2XErQC+gzOixu49gCNm4TUmSbb79pRcIAtY3jazqBJRlRfc+ywVrPq46wq2EuCVd8+m/UaXIREkddD0IMtJ3pgBmysoOFD2isfH7ySqWFR5hFHUnNzweJKwVaXHRg54g8g8vOdTXFmsBP+Aafzhj3R0Aufwyg8MlosQuvbpQsIH3WHKg5/q0j6eC38y8O5UGp5RrgYHy80M3oETMDcpeKIxFAZfhug5TbAAyy9+dPxOeH6nPshNn0EvTa9yOT7mJvAeZJJcYN2npde2kw0npjCECbb+aa1bxaikZiEPSu2mHbPh5L/EbVfWfeI9WhQdksWVZzvl/482lT9o4r7K5TKc0GiUXFOsBIF4scSGcNbqAmAbrGLRsw6lMT9Hgq1Z/Iv8HQYiO0EImk5tfUtvMYONarigcbvN/GRxtXTmtYcs78FT/UMHN+3WGuqnMGUFqXWxWIPJoH5uGrPh7UaXwates1ByCGUCe/Qnfso3dq0LA5nIxgoABFE0zKLJV6N5WMGxvYJ6Zd49USVs34Dpq8SXbKe6oWO0dVRg3pxUGA2byavcbMIr1ETKhFd9sjjir59wkADTEizf09e0M88sWnqw32NGJ9jLCnWOF5CIj8dCX06EK33y9zuvvRU3Y+WDAzP9GPaG8LfRmazgXUsYz9aU0KHWusMKECOzKVwcd8rRY1nt6AHMh9owxC1zw4OEfJbtrAUOHRhjOYqU2K1dKyCsAwaWXYJyFwBrJ9QeOWnbDj5OSozlJUxTbwfHbb9fJ0dVC9aehi9Ng1VJ+UTEHDVf2XRutdU0mXbTL6MsaoSNAgTIo2yLYoytgCgdEgujPrhe3HaewTUAIbwtgct/QpYF2c9TrozAlYytMczFiusD31fqix5muuRp6s14Lvng
 RJQJzcck
 6zGp4kq486CdoMJmQ/jV1ThkX6oeOjvOFUYdH+hSI2tIHqjmSwMoH7Oex3GKFeRZ7Zv/2mF7+CzrHE3Er5Zp2HIF5AKF0LRs+865Gyj/a7ldcRf6GgYX1v3beCHad4EsSVRKcYE3JfTT2uiJjwxckiuY5EQQMbF0xUBloNEyAmhgLxUvbuZEm/GmwpKdPPzMeLtPZo5USPKivAuHfMMW+NkmmjRi+OhJxjoRLE+AdkaFG08MltqPhypSHRx5B9X2ecB41SeouRsQV7P7r4zwZzmgz4Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Wed, 10 Sep 2025 20:02:50 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm tags/mm-hotfixes-stable-2025-09-10-20-00

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4f553c1e2c7b81e957b5463bd7efad2465a586f8

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

