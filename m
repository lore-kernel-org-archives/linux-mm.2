Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5CFBC88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 522546B0093; Fri, 11 Sep 2026 15:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D3D16B0095; Fri, 11 Sep 2026 15:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411796B0096; Fri, 11 Sep 2026 15:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 259F26B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:36:57 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A7672A489A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:36:56 +0000 (UTC)
X-FDA: 85202489232.16.726B278
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3877100003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:36:54 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxdkFqdb;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789155414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=rUzayyEKdftEqkjkSuOsigPLJwLj5dara/VKd9lXolw=;
	b=fyg6ziK1xrKfQktIX85NpcOWZNYzR93b+Zphe4TZD00vVoHVjNetkAhKncchxEc4lztp8Q
	nbgP3jACZCemxmDUUqP6CAd9II9eJ+yTpRcoe2SF5oNXgv9b8KdU96UyPFK2qt+rTb8PPe
	9dhiqYSgZe6S83w3Bv2X79YwH+JI5LU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789155414;
	b=RSSn2/30TT3u0BH/pfTN8qbl2Uv6Twb5QX+hhwwcPvTJ+vLpQty0k/sYyy6Al9xuUQSrdy
	WS29DKRmyYf4vWNGFGcaOK0ihkG03yow3mAnuhpVequVODhvycF2Cfk4FhYR/CRfMX00bL
	4KCYUZtaEhUrEk0vpmLK4LZozWkQS64=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KxdkFqdb;
	spf=pass (imf14.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B5FF343C5F;
	Fri, 11 Sep 2026 19:36:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976F31F00893;
	Fri, 11 Sep 2026 19:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789155412;
	bh=rUzayyEKdftEqkjkSuOsigPLJwLj5dara/VKd9lXolw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=KxdkFqdbmda+ujap2v3/OSUAqgBB4rscmKY/uAFty9G4mlTuPSsay+/DG3ATHC4UP
	 fKGVJr2SXckYxZrQ28Luj+ES1cPuC93PRnN2cy2dypeFCID/7gEqm3+rS8V8wLjsBA
	 /qn1CfTr2595iLc/JO3U3lxDquu7u8U53ZF2Z68mM0qNizC8ypA0zC9VhwnqVOgHVI
	 N7yZ6mLcebFXEKcq/gesyxxr0rfq9wKjpHNI9frauSmC0wFkRuGxulil6v9IMq3jjv
	 B88ARone+BiIP/+Euz35TXV6k2BKFVXN2zF888BGr9VIL6jSvAhYPTgBWsUzZ58DfY
	 ffZHjza5u+VWQ==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 939D63924451;
	Fri, 11 Sep 2026 19:35:50 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 7.3-rc2
From: pr-tracker-bot@kernel.org
In-Reply-To: <880edb7b-a803-4847-99d9-a0b80b3088a8@kernel.org>
References: <880edb7b-a803-4847-99d9-a0b80b3088a8@kernel.org>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <880edb7b-a803-4847-99d9-a0b80b3088a8@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc2
X-PR-Tracked-Commit-Id: 4a724bcf5d703e18957397914d79156fa2cf1174
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3026c6e4f223bdded6448fefe53ff85d9cbe51bd
Message-Id: <178915534921.3075396.10785790053310931124.pr-tracker-bot@kernel.org>
Date: Fri, 11 Sep 2026 19:35:49 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Hyunwoo Kim <imv4bel@gmail.com>
X-Stat-Signature: 3sehwurqqa3ztmea6rbokwajwn9pyjwp
X-Rspam-User: 
X-Rspamd-Queue-Id: D3877100003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789155414-721244
X-HE-Meta: U2FsdGVkX19ZHbEm1iMCbBHvkkwAYXHdOsNr4+1EUpFhlrpC8Ytx2PKAKEGGJl6yoROAYxYiHYpLL5YGDR+XIF1Qn0W7i4wWHZRxAAXQjNwEw5E3tU/SCpSb/SiQowDjmrHj5E1Imt+SvT/g19oS1G2aquQZd/ox5vsmAhlP/r9Ohl5MAgekFOzCmI7u7Xj9W6AdhAR5hfBAoY7LENRI8vvKTwt/dVn7v+LAM9AMgbBXqs984N/cnpVxzFtnoei9BZwR9AHRaUzHAszaV4jFixum2B6OMrIuKyfyI0/6h3Vh0v9ef0ZAcZPV4t8JpBOA2Wc6LFuzjDBH32X7mLmnLVK49q1Ck1ZlmSAjAO0xabu3owFxbN9AwmMfR4EijSekPwZy4tjRSq7GwgLi2VOzuOALztOkinm3wI32DGwE7y5n1UpuOHPLwT/uEzCXYcqlgsC+kvcEAOTd6/F906/gzOfSJPI04KbAn3c+Lvzg7EgqsdQNfFS8nFFtwL7vaFGaN5c2H37UdyUVGODuT1f7KksRI5P3XWNaoMNGyTqPVAPLcCjEI47S4gjDT7RPQHF03NDafJH/+bpet/diTHDeN/oJxBxuBqSUBsfCIRLXUcYh4dxruKSh2GJyYn2Y1Z+FklT7rEEaq1bhoN45PjX6UElAc/cVKPFX3Cnsga7OjcODphQ+ntOsgAn3GDyiI0dXo9anOjts9kdKnG+sQaBpkCpYDDrr0UR4j7mCKuTTVLeqh2tbstq4OKnDscrDkaL8Sxx0gWrmze2t0HjDzQ2bmW/yg861t78QMkowldTujS52fGiMJwnw4x5hOhu7fE6Ybz1SSZxO83kHZl+Q3inGp9D7+jyXzhKZY0EdNTm5CXFAfMvVLKhO8JA5hTY8weDU6xkLpktx6r0cJJCUHbm3FQWYJzNCEgusCnSa74nO7NYDpUn8hsm+ioGOnO6286/9ozK3zI3eJAcVakk/y+k
 rPRSp0wK
 0Tb+S1Jk/k0Y2QPC/O9IFxyfTbsxEu8PuRfiWUexE2k/MPRhqZqfOCNtYK4LROHiRcn8YbdVDeW0U0dWPojpUJYRZEf8fqNikkBVkFUZNFS2GgRB+5+4KjlQZjaAzR00A2LtV2fKYJ25tezC0cpQLNDK9w4wR4/jgo4rJ9+YLyJ80BYrobjhUuNjNyDL0NStWGwrJO7q7EUtc4YfYcJDRMyoCScGs/HfU1LO3bCHhiqnP5Z3W6Q0Mfbr9vcvWmW1bf6MWbIhlNt+0aXxcU6u608TyAi/QAtJ07KtUyAUbCYGQwEu3NiSkp9ysD+IteoZ87++5BJuwi5W4L/alR2ZkuZjMjXqo5i0yIe/BPwv5cHrNUV6kWe1NWeigUmbBfC00qDaFhk9oK3Y1/GAAmzYmz1ALMv2Yb8F8dXYSGiK0XVNX/VJCM3lccvBEvNwELg3+To3TqsNnW9xMVSTbfXymAQ5g/XbdDfgfVMZ+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 11 Sep 2026 10:29:37 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3026c6e4f223bdded6448fefe53ff85d9cbe51bd

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

