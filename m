Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 10259606A32D
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 21:37:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JVr2Y4g9
Received: by kanga.kvack.org (Postfix)
	id 259DC6B05B4; Thu,  5 Nov 2026 16:37:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20BD86B05B5; Thu,  5 Nov 2026 16:37:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FA5E6B05B8; Thu,  5 Nov 2026 16:37:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC00F6B05B4
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 16:37:48 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7791EA864D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:37:48 +0000 (UTC)
X-FDA: 85402377816.24.544168D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id B214040006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 21:37:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVr2Y4g9;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793914666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=Z7MyjlK223pIL18T1qkoDQuJHQwQ7PjffmCPYkwoQRU=;
	b=FU9WLq1KNNg2kwbDbSrXNOUFkCF+Dbem+fsnyBz6jItB+WAoLG/YEtH3HwvTDocBAIrBpy
	dzZ6r+164XThEUqR2qwq6nAMQDRjRfwsJnv0Ejfzf/zUTwHMjhQ5Kk4+Qn67pzw88VWQEX
	0k1Fwf71atHDO69pjmfXJbKALOz1BJY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793914666;
	b=Ah88Y8SBFI6RrqzD80jZbdVIUaqGn/1vlfAjDM5HUpJmtoI7dg3RgG2nS8uiTS0deleSWm
	pc4KyUuxReZ8NICywLCCQ+g7E1zpOvG/SaU51MKAQ+Nt4abQ9B4qV1QyHnuZf0cgRK6K3J
	/a/EcsyPoQXaTRsyC8mVk8IGaH0DVpw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVr2Y4g9;
	spf=pass (imf07.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0D63243D91;
	Thu,  5 Nov 2026 21:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30E31F0089F;
	Thu,  5 Nov 2026 21:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793914665;
	bh=Z7MyjlK223pIL18T1qkoDQuJHQwQ7PjffmCPYkwoQRU=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=JVr2Y4g9I2Uofy1UXMxVq0CmgTurasTa3LZoVOVvoXym3QeZWsjiErAUPokj6NZ1g
	 xcA4Sw4ttCqmyyub6NQT0Pm2H1A2KVO7LC5Y740L3+iKkor9HAeXKVtnvXCnd7T6ID
	 tOtqHDVrHZ4gXZudgJphXWvkvYePyTF0gZ+cPuDZU5jkGEaN2+VtWwtAoyz7dWSCWE
	 RWzsjMKZxIQrIidUeTtdr8cuORz37QPnC5BSRICZuRMhOsNpGn9EkeynPj1y0o2FB9
	 D/rgzRQTpAWWZXfqjEBCX6J4OJqtXrTIv+KffxFqXi+Am3myQm0v1qt9ovkYkw03PQ
	 xtvEFpe8q6j6Q==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id D8155391B19C;
	Thu,  5 Nov 2026 21:37:45 +0000 (UTC)
Subject: Re: [GIT PULL] Core MM updates for 7.4-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <20261105084704.5703-1-david@kernel.org>
References: <20261105084704.5703-1-david@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <20261105084704.5703-1-david@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc2
X-PR-Tracked-Commit-Id: 71555ae8c7572fd99158013ca2e29187c5d2508d
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: d68ce4e71248e1ff5af9654b407541d9260b3ba5
Message-Id: <179391466439.190890.2508388451772076480.pr-tracker-bot@kernel.org>
Date: Thu, 05 Nov 2026 21:37:44 +0000
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Stat-Signature: ed3dm3mo5ni7keuq91zskna6kssthuea
X-Rspamd-Queue-Id: B214040006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793914666-405306
X-HE-Meta: U2FsdGVkX187orGvX2v51zqFQz4c2mn/GYYH7YJ0d52XukYq7Yj3sv/zoNVyOQV7OFHl4xX9CoizxaBWnTIHCsQHT4QLezvqPRBuRr/qoRUvPNPaiyRT1FMgT7MOQVmuM23l9F3PPY7u7AoqjtUlfLqTcUA1dzpvfST/fsA0rzyTuWCA3zaiK23EGsixykQAMrl8N9853VG11q5WWJxbXNJ5UbCmh3hEGc2a+/e027EmTwbgrRCxxXVZf/wXhREdHNqHPZgnIMujJrPqOFsISbA38h/6SppGIQeE42527q0bADQ2e6OwhR3NfVZ6S9k7S2qt4QctkxH313feA6cDzFPSEr21NTINt8qVXz3dgI/23xs77IjHFN+Fy3jHwnRR3I0M705Uk7MnYErS8Ywpt5n3U01Ho4EMPAHhqXEu8xnBU1D4JFHgFnA39ht7ZZfbIDo4ujEf6ykgAWnV2uwbsWpK+bFWhL07Q7G60h3e0ntLpv6DFlf2hHhEDdknc6Q2mFpQs8IfC2Wm2EOJ7tt7FRPxTEUDi340F5HRXqvswTtwlsyMdIMILB6PdbdxIZXD9T0XjIr5/aSAQjzPTRIg5Pqc49ksBJ7SQXP3qtCXEXALMYkNhZZ9+CgCKC5wEkINE+FXaf9ZPY37VhDh+WzV7K3ut22WTG9Ym3OyxqQyUTNJF2TbO9yF3hPWjt9X3b2evLzxfa2LvjlDxu5yukVs0LPDytZknJYvXKs71vnLdvN0sfWElpElzlNwL42dAWRffJdJttGECFgL0SWA61CjLNi6VUTLH8hkLdMF3MqSC6+1Q/n22+H+KD2NB9RsCzi3nIRxIZEns+PA2Ck5kP0/twibdtMSpvPZ7hQ4ygvd5Y8QPv/K1kKBO3V3zA7fGv0wic6hPdvm9BQ93kJIn4F3OHnZICKRgfO5z7TzhFUyFVIaSk0hgdhDKVmXHee0nam+eSay2ZzPBW0vjmdSCaH
 BEDyp4Bb
 dEGevaFTynb2hx6qGy8HuW3j2bA8IMAOAdHmeM/C8ifIjdiWApqTW7nOxUQmCGRKU+9cmRaHwqWZF74ozUj8Suc6pT/Z6iiGWQaAMCAjh3iclfibkJFrBaFUWjQPe43vlVx8Lv2npsbHiO8aGchStlo4F1CelTfp+Gd1pFb7vdV9mZNQCsqBJjeTWl33aml1Dn2Jn5gxQTnMwp0VTawBaWKt4MZB1mz0nksSKI3f0z8R3M4ZxDXtjZpu7pxSP9Y8XFqVfxAQCEuZWYXOIqkG+yTfHbeJbGaOCNwE/HnYJPn6l4IJ2wlFbL9H2ukUJgvp7lq8aqLwfeU6mGhQQTNuBe74qZVani4xMMXrp0A+U5yD9BIA5Y+evmseRc+khDQejyfcArJTCGw6XOO/9W9sLupZ0kjOYdw/gcuqGS4l8OopruOgYJjrn0GeejQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

The pull request you sent on Thu,  5 Nov 2026 09:47:02 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/core.git tags/mm-core-7.4-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/d68ce4e71248e1ff5af9654b407541d9260b3ba5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

