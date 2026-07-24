Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 095E3C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:23:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13686B007B; Fri, 24 Jul 2026 15:23:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEAF06B0088; Fri, 24 Jul 2026 15:23:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A28A36B008A; Fri, 24 Jul 2026 15:23:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 84C0B6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:23:33 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12C9A120146
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:23:33 +0000 (UTC)
X-FDA: 85024644306.03.ECDD1ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 37E6120003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:23:31 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hpCwonE/";
	spf=pass (imf31.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784921011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=4C7azbQxPyf0Q0RZ9NaohHKFJZ863QDX4y6W/XLd6OU=;
	b=GhpTw2/hq+P3C/3cee1aNzXttcrRdYQixIqhIBimvRQwMPwamcGzJTM6nDy3bgXWuFaswR
	2kgIeLx9h96wpPQdJLCR0Aiq6t/Bi0ahGdoRLtuxISZw5IxPFG9nm7FgUYMaxVg/vYtqga
	8sUPoOnUqr+6vvvr7dEmg2/1yrH5plc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784921011;
	b=6QwVXSVMWlcawk7prk/Amavgdj1YxKVc6350/Sq5IYshPW1xJWhR4ovdjWcqGEgytObvzS
	aKhad+IPAHNU9QkqZaAyF3hpKOSKpQcJOCec/LDyUGlfmj0oZgQgcHjDuSut7/CZQoIXT7
	gMyAUsxB8EKyPz4BMqpHkhPb6T+r4Eo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="hpCwonE/";
	spf=pass (imf31.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 783B160A61;
	Fri, 24 Jul 2026 19:23:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA231F000E9;
	Fri, 24 Jul 2026 19:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784921010;
	bh=4C7azbQxPyf0Q0RZ9NaohHKFJZ863QDX4y6W/XLd6OU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=hpCwonE/IpabcOMsGIgqUxm8VGVSsirLh5n42HiBdxMOl1oC1BhUOZAnJ56vUdUSE
	 LhL+4wiWn0PQPtAG5eVndu3+eRAOPxwN2qze3L4TnHDax0AspHLkHKjUt5Y5l+Gyxt
	 0Fs64DeUAvJ3S24w1v/9Ux4/+RYdbYAxbYkOpsHItnNjOPGoyndTo5bSnPt7Tb6sHK
	 NeeBVOtg+h3w9q7GKTKrsdQu9Aw5H7RVhnbttH8WNIGfq/BLmTZLq6HK9cyUWwIf96
	 N/6kuaq+cPeUqNUzmenxwH5W0P88Q3RF8JX8MSCMczCKW+WgVQEjiDAKxwdw0IQKW4
	 /3O5weIJPOHGQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 93BDB380CEF6;
	Fri, 24 Jul 2026 19:22:58 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 7.2-rc4
From: pr-tracker-bot@kernel.org
In-Reply-To: <abd000de-e6d6-492c-b50f-09d1309afc83@kernel.org>
References: <abd000de-e6d6-492c-b50f-09d1309afc83@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <abd000de-e6d6-492c-b50f-09d1309afc83@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2-rc4
X-PR-Tracked-Commit-Id: 5ff172f6c94d282d83cb88bdfec5f647ad9c6105
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 86ba24c41adcf1d6e63827a828a9b5120a86917d
Message-Id: <178492097709.3280582.11868370257429116027.pr-tracker-bot@kernel.org>
Date: Fri, 24 Jul 2026 19:22:57 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>, Shakeel Butt <shakeel.butt@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 37E6120003
X-Stat-Signature: 8bfbfjrd44hhmntjucd7e4f74zz74axp
X-HE-Tag: 1784921011-911397
X-HE-Meta: U2FsdGVkX1/gzN+OFbkFcihbJGhpdm2B5RDmrFS48Qzz/1dQRyPrYtIPC64ylU1nS7Bbae63baWZN+SqhyFeY66iVRr2myJiHU5s7vTJsuSJLrYVR7UAGaAko3qs2ld0VkIjB++5wB9l20GLGUcikwmgQZZJytpNxJUypU5/YJHoZE/Z79ZOUqhynPAe/tc/u9jmW88aq+/7xweoopTYKcPT8BuBBTaalpZzj+0vnam9mUbs76cekRxStJRdsO4s/0RIuBz9Tb8piptYJcYv4aX4AfdjweDo9wergGCjrPys3lBSUTfGaDSyUdv0e9SLI08hPFYg72/rJwJ8tWtY5sLrh3y3bGOHlKkN1mHSYXMhnnr1WlFISqbefrpIOGC40dUaBiU6dQ0zgSA2jSLXUJYQi47gcWJWlSzOBnPE8uIo8ygxEv9ateBz96hOXPLSm78RPKcTRXL1YHR54NbC7tkt1+KHKYjwLXANuC7m1AgvIV3Fln1wEduuo7z7OwcOIY6CSCihaPKfkDVvnoX0KJGxT63741aqjyeZROYdgr+OXMfskb/sYqJocTGUFuMNaTtbvhKRSMrbx52zAM/8ULSVefPui846p8ipYHpJOBQBCfsyIiS/eGKtwIY0qiwaN0QFYDQppbOzKQIalSMyugwbE5mlCZQsNFHHRrjaeAWVp5tXhXCImfHRYIzUOTzwZn1UW5JUcsXmCj/vOxQnIhtl4psnrvzxoYWTPe+awm1Lxbbu9MS3bsCJLQSZes56mjYrubXxYMBkPFb/3LyA3G6/tXRtQN0XLeVF8v7TG5d19d+ibEC3zP3u2GCecfmZXsIrG5yUmoQ7bdLpW2XIXXmNK/0CN/LjtwyYg2Z/VI6/hiM+rwIY7w7ULFhTcc/KfXbZSVNhoDUs+lXl1jxTGHrzPh8nLtmcFiDSTdESyH0/PU6PiFCABQIElw9v4DvNzUmFc85Li5ZX4vUvOQm
 mncgHIYN
 UNXtPPus4979gw78E5UZp53YaHVEp0wfGvZL7NVrk2ulFJM1OXPOP9AIET8DRFYywpzb32cn7Hw7yqPy158Xl3nu5TFREAqCoAHBwuo40j5BgGT8O3qsLZbDLbInK4jjP06EkHxSL/HiBb0XxuKcil0DH5X1oA4xJuYVXMAnTlCWtUjmf6q8969qrt98lXbZ4RBs5b5gdttsHYoHVAaiWOUySFFWLh6hQ93XuToJIzq+gncxpTuHalhqYa88B17lm9d+R2TIJFA4GcxqQ5NLrr86JcN0wq534ddBn6d+swXkOVRo05fTR3FG//TqxDApGur6PhaEUGwju1IC56CwiBQGA8yYpVJDTRx2ZnhxaxOeanrg4CYDFZH+xjImJ3qHtSCwARPqVm7WarzrHmv0tR/XRp0S0U9Ppw3sDUeJdrgiT3py6f03aW6g+DI5nH2TqlPLB2vfEFh9UevfSEG3/joQFE2MpYE/n0lHH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 24 Jul 2026 14:32:13 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2-rc4

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/86ba24c41adcf1d6e63827a828a9b5120a86917d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

