Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B57ECD98E2
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 19:40:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00C8B6B0005; Wed, 17 Jun 2026 15:40:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8B06B0088; Wed, 17 Jun 2026 15:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC1D06B008C; Wed, 17 Jun 2026 15:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B269E6B0005
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 15:40:41 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3509614053C
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:40:41 +0000 (UTC)
X-FDA: 84890421882.19.0B7685E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 4DD1A40002
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 19:40:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AvzaNtnS;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781725239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=IuKO67/a2mtwIzCZvcxCaHb5XqnCSBYPGUCOpg2lCEM=;
	b=UDFFkk5vG488pFhRJciA521omGIpFxQ9qQiSJSDvZTeFPWO4mCxMUs1k8wZFfJosK+TJMk
	sSHCuYVwpJRrKMUPOdAMpsa6GPC2BIdXw5SK/nkBdxI0WZC1kcT/Vsa48Wh+LaKhm6Hicn
	UkaYQUlTMPxsltpNs3IBh7On5I78dDM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781725239;
	b=ZBZq4YoyCkjxVAHiuFo1167Jx9+aUEqWI6/Z6uWdNso5MDPGGKLO8x1RVdfBPuGMyOcHSn
	JvloNiCbvHz7uVy5FiwTBD3XECEJmc2DfyfvmL7Lws1VldDvJ4nJbee9wpvbnkaaTrYmz9
	E75QM84iCQwQEoK6G3w+qdOL+WXBGMI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AvzaNtnS;
	spf=pass (imf12.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4650143EDF;
	Wed, 17 Jun 2026 19:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27DEE1F000E9;
	Wed, 17 Jun 2026 19:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781725238;
	bh=IuKO67/a2mtwIzCZvcxCaHb5XqnCSBYPGUCOpg2lCEM=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=AvzaNtnSORch8jtvBHlc136krk/APkFbo0Z4OExO3w5Q4TkTxz56eSJSM1ujX9ecP
	 /9QSHx3ccq1epGnZJwFXB7L0Qwig/HROSnWGflQE7dxv8tCnDGXtiEb3SfCMsjjhsE
	 3WeawDSqIDjyfOl9DzZyMfppgcRB/5dqJGFwRnJsvDm2MxhLjoN70BXtx19gQF7hDQ
	 1bXmdcyHzkC/88R+ZwJFnNMXcTodfki2gs0VPWFJLHWr4YPkDwxHsaEEL79zYF7/Qv
	 kyXIucVxWhE2T3Vf2JrawniVquuQA6LbP37dJmP+6vgFF7MGGq4/q2zp7Xf+CR23NQ
	 im2eGrEo4DRRQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 57E9E3931008;
	Wed, 17 Jun 2026 19:40:33 +0000 (UTC)
Subject: Re: [GIT PULL] memblock: updates for 7.2-rc1
From: pr-tracker-bot@kernel.org
In-Reply-To: <20260616083425.2347873-1-rppt@kernel.org>
References: <20260616083425.2347873-1-rppt@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20260616083425.2347873-1-rppt@kernel.org>
X-PR-Tracked-Remote: https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git tags/memblock-v7.2-rc1
X-PR-Tracked-Commit-Id: 00e06cb773fd81d4f2806a6ee69d1aef8f6dd5ca
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 21bd909c78241a61c991e1fb332cea04c340e5f0
Message-Id: <178172523202.1784504.12435671004471464379.pr-tracker-bot@kernel.org>
Date: Wed, 17 Jun 2026 19:40:32 +0000
To: Mike Rapoport <rppt@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>, Priyanshu Kumar <priyanshukumarpu@gmail.com>, Sang-Heon Jeon <ekffu200098@gmail.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org
X-Rspamd-Queue-Id: 4DD1A40002
X-Rspam-User: 
X-Stat-Signature: rkttj8m9f9uczakrcadomm6hroyx9r6x
X-Rspamd-Server: rspam08
X-HE-Tag: 1781725239-605343
X-HE-Meta: U2FsdGVkX18UyP99pzq+CJUzoKHGZWnVIZmQernJTijr+ABqP5Ba/IVaDECSabhoz4acRotaxxeXXm48n7cGnKsPH5NYxdisIkndQ/rj/QFW1seAEw/Q2H8B6PP+1a9K5wsA/kMPY1ZxcOX01ZLWYjrISIJOIZLm765mmNZP8UD4hE2SP1JBIW+q+nyjzXVpsAH6Ar4yry/Ns1z2JYczvtHiUHCsq0b64j7viZfEC4zlanYsE65OqGETL2O3S0CpVpmawCnJf6bqOH9QFV4sXUj3leRsRY4HhZmRO9itbasr4MTQpnNONXLApJeVSQfjk5/bWG9sViLA+CY34KcEhP01dZmVDyfB6EPMGL16QD0rfQ/tcMjey8/gQ6k18dz0qJgAIlIbCuVqN04dELqrOKjbjBkKjtd2jWCD439vmYmCC4WqthL1epboGAC6zt+AU1HZKmyMxo+gwYRilOHjxJem4Tnnv/D1O6RKq4FZeS/xU1vi132lspUG7ywUPqPrEIlh5qExMt0aMvveq8blyiwCcEz6ZkFAyFKE3J3/MkHeF4SJRSOuywRbdlZC+1kFXK0w9yPCBtj8SqkmosRE8wu/4eTX9TXPJApXz2uwHrLv7dk269438f1ULXPozZL+tOILRlEIDJZPM4I1WOZ3ptxTFg/Z/p2ymHFgiHCooisvOZAWiqVo7vFnRckgzc5xtf8+N8JEj+vFg8E+fzvpi0Ouyo3Xs8lBuM28L0h2HXxchaQcPWl0F4fBikTnoETeIvccCdHZfBiZf9MFg7wHAfO3OzAh9wR39+DEWJgBE0yfRrU/EGGuxdklecWuPQbmUjey79+nCRX/nQkCza38gn76rfFQT+kRFrro6ONVo50sYbFuiqCW8cJxUKqWoxI9rJkWULlN0EOYd1nAAq7PejuGV+kls5P2T3G/piHU1fqmyHwsubiVLbaOMB4ELWxbMqDBoM5tExm9BKoK2UA
 T3ufvPRP
 XRl4Y5NlzV0gNphZz0fpnl5CDuK3LL4aZtUNEU2Zuzh77tX0ZrCf8z3x3fhS5WvwtQfgX5qDj/SKfBij1X5V76PKA8R9iEanZb26QET5ZjTgNz9NLaRj+omnzLNC0F857A0tQvRd/U11VS7eOXZRJsTtxH/V7e4moP9wbWydk4xEn8VXU5xoJo7wDQKo+xZJbvEf7lrTrKZ//cvN0MePR0Dhg+/kh3iAGy+m0saXBvAYFQ0IVDH9dp46q+WmPAKMVbqOhgkxVId7XXRNW1YozK3/WsjaPcklqxQaF7WiqNVo33ZBhpeyY8+crJiARV/gqYpBK1sNSkty38q+kQKdYv8XCRGGMJQaSAhXqMdZqIkdzQNzPEOIuGcSVPisODeXknihzqMYjPYUn8RWMm3i5DNTjcvBsz/+6+V5A5P0CSz08RDR8l3VrmijTHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Tue, 16 Jun 2026 11:34:24 +0300:

> https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock.git tags/memblock-v7.2-rc1

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/21bd909c78241a61c991e1fb332cea04c340e5f0

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

