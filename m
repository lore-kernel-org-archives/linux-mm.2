Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6E07CA5FE0
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 19:16:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 637726B0093; Fri,  2 Oct 2026 15:16:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E8346B0095; Fri,  2 Oct 2026 15:16:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 525A96B0096; Fri,  2 Oct 2026 15:16:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2F5106B0093
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 15:16:15 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4832640837
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:16:14 +0000 (UTC)
X-FDA: 85278641868.19.9D51E03
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7BCEE40008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 19:16:12 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVVfzrfr;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790968572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=TW/3Bgp+W6aVNC7AIynY6HBkchlAdDDuI95oxaq4ozg=;
	b=vqdl7nmaU/2LTU5mD2PnTT071l1Act41yCG2V0Thseqj3yBuq/7JjF9nBkF5KwvR9Sj3Ii
	nQV/rU7dPVShLJ5aM9b18qxLV/R+oNu2/PUs6woaqqbSkxUbx81UMwUIKKhRmVGgYaixuj
	eICFsGcF9rgj/DIL1YtkEsxioQhsgJc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVVfzrfr;
	spf=pass (imf11.hostedemail.com: domain of pr-tracker-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pr-tracker-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790968572;
	b=JRYY5yywH5ferVNrs9Bd8lVeSGjaGfS8lKeCaIZeUqBmwzkDNWGX8/GGaq464cr9rclApG
	foMhhAEaNFmmNAAq6Y/f04dnlBurqnYk23kb0U34ytp9uRssBKxQ4yAHEiY9sZf8ojfcBZ
	HYH3vyB5zRPAaml8AUoEZqdnySQdj7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC37960AAF;
	Fri,  2 Oct 2026 19:16:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F021F000FF;
	Fri,  2 Oct 2026 19:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790968571;
	bh=TW/3Bgp+W6aVNC7AIynY6HBkchlAdDDuI95oxaq4ozg=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc;
	b=JVVfzrfrCKD42iq/WhBRg8oJzshkAtYmyRXrM3oSS6R/qygwS40pabNn8N7WRCgCm
	 40PeEvIIthYIJp+IkLrw9zIi9PvuKrt+MKZmy7febET6Jxsy1A0rJ5BollQkMeBOeS
	 leIeA/E+7DDRbK1bYo9OarDSWIpWbb/yUJICqYBZKxm73avJGbFdgh08PZf8fzPWN6
	 x2IVdmW4O2Jav1mpfb0E+2ogI/y+7CVRu2jNiwqNPtDBIdRuRhKFsVv/Nd3nscStM4
	 zLEitkNfjgAndrgGK1+RaI4R7eTILP4+2fPE+/BOqyCzZ+YbKec1KR+lUY07Flb2Ct
	 yyOiI95fTVF/w==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 775413811A6B;
	Fri,  2 Oct 2026 19:16:11 +0000 (UTC)
Subject: Re: [GIT PULL] slab fixes for 7.3-rc5
From: pr-tracker-bot@kernel.org
In-Reply-To: <2283e699-01e3-4575-8bba-93d0f5b2066d@kernel.org>
References: <2283e699-01e3-4575-8bba-93d0f5b2066d@kernel.org>
X-PR-Tracked-List-Id: <linux-mm.kvack.org>
X-PR-Tracked-Message-Id: <2283e699-01e3-4575-8bba-93d0f5b2066d@kernel.org>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc5
X-PR-Tracked-Commit-Id: af2fb3ee6679b517e2fdbd3ba16ec276a8b74312
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 4e9a2de02fedd0137f058a6e69848072a20f8f34
Message-Id: <179096857000.3549447.11222267736622715493.pr-tracker-bot@kernel.org>
Date: Fri, 02 Oct 2026 19:16:10 +0000
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>, "David Hildenbrand (Arm)" <david@kernel.org>, David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>, Roman Gushchin <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7BCEE40008
X-Rspam-User: 
X-Stat-Signature: nn1sipp7ajqzahyorwxwqiopyeuo1mh6
X-HE-Tag: 1790968572-635673
X-HE-Meta: U2FsdGVkX1+L1pHzoFrswzg8XNwX69e1eU4CSDpt07d1s0UkExqhegedUZ/OVwHyPt59MV+qp0Ow6XAzDHwI3jsXHFJTiMVRxbL+hdLPwyLeIIcCoSm0f1qU4pcvMy7Y65m/FwSrCSe/pNzn+803ENNx/TNBkJvQc0ekzAPvxxh95trJCUYL4bWoQYyj8sMGGRSZXtneZXsoVHDtoUtGxPIOsjv5lHp9/mGZLDT1lI/qD1xqIrmV7uBgxmKqUrCfdTC8Yb/zrxI/c2SSXiSa5emUnbNNX44zskSazdkXYwd2za5YRFASVzBtZcRC6Vhp7pwgMMdCjrGgtwoa/qzakTqUfAlQgr3jISJySmkx4ZMMxZakB8nz0HRy11AN5fZBT6zrF6Vj5GbgRvW1nRV47e2TuIXSYToNiz96Cjiw4/SPrQxc0/ZQ3bC8R872MFlTHfw8Pfh0Vd4nTqN64i55p0j1rkC9qleSVELtw0z8Nj8GgJtytq0rf+N+/9crCPvDHFXbTpIw+xqePrlNN1i8QNi3PGhp4CNc7oj442CLbtKQxve2Jau6+f9tYmh2LU5eB97U012rq+MScnM9I6d4oeDY8v4eAeHWpqWJXZ/zNbD9Qap29nCD/JS7wVw04BOldYxDQwL2mNrr5Tw/YaJ9loJoxxyPoMpMM58PAo3hi+x6GucNYce3BgMNmfzPwtnnj7EY/ISZREHWPvVQuZXWzegf/mFQWJVqo/ZlSBuCAkkx6+hMwT2W55g3xYo5S4QhHpyA/AfjAYPADREfjk+wq9PH6LjDmwrVsJk/CkZSjHraG6LG+AnAHfHp41xQnBXsCuT0pQMJyUUaMKFdTQhU8sMxg6B9kBv7Es2ai1X+dgo1fNSfeLKCd7enNWdmC2hxyH3DJCuf4o8IrqQHYE/VQM6V1cc1peUUA58v5Y6+Ez9DFc3mMHf1QTjDF1UhYT9HXsVdHQBQ823gsQIikwW
 ju67VE03
 XccWdTBNhDcPUUJrCwOKl4GfMtIxRNqLkr1kIbAF2OclAb31Od0ntD5R7roFYRl33xDnLY7Jsk4YzrUw0z9/uOR1Dd54npgzPH+a96Pzo5+U4F7+RQr2Nw7wsHgW0k5yZo64nashJb1y5YH/rskSGwDKRH6I6GSB9SwD7sGhmNgCw2agh85X9+yxvH8WoiyoLiWiCuCB1gGMwXMeXqNXA6sKfo8v/tSffrooDUunZadm+62lFx5By8hjBAJ6Rx3Avzf9UPr+TxxPKWqZsrknftU9cI7dzDagItfE+zt2XTa/KjmKmzPqT5bYj794mGLYb7bM+x3cvWLUvkmXd3uHKPIatyrrckpmgGykDv4/JzwJPDcKgNRZwktqbEvWmL9Dkdwo8qnVIwIOyjA5WthiW3feed4F+a4MTVhPBuAbslxpihkVFxnffzHNomtYrhxXHkLs9bOd5aW25bvagy7PjHQZni0BdIHHjLUDG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The pull request you sent on Fri, 2 Oct 2026 11:15:49 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc5

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/4e9a2de02fedd0137f058a6e69848072a20f8f34

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html

