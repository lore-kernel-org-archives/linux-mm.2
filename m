Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FE65C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F37E6B0093; Fri, 11 Sep 2026 04:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A4566B0095; Fri, 11 Sep 2026 04:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 793D96B0096; Fri, 11 Sep 2026 04:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 52B366B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:29:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 607A8160130
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:29:44 +0000 (UTC)
X-FDA: 85200807888.12.D2CED38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id AAB991C0008
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:29:42 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Veua+HoN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789115382;
	b=W3/7OBIHHolGBftbudLsAA6VZ2OQvt19as2ASipDKsN6XVLRt7RGXgoJWd4S0SroyXj6kN
	gKmNuDou6kJeouYbv15uSrktYdv7DNsrjx99zS5jd4hUqQSyXTsG0fBKCKubImgFXCEcK1
	WVM/HeU4KPNSWpF91arCwoB1bZHtP/o=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Veua+HoN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789115382;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=njtH3Y8aJsmF2L/mVvCVoWcGDIcAJ4Klj9jaiQi90MI=;
	b=3X5UGCPBwfB6m4DRRz2JsCdfCYPYEsqtcNNJc6JF2aJ42ExL167RRb1As44QsDR9s2Gkc8
	uIDDqOYfsJo0o0kfCM1MjyhHX8QOMlmet2FahKRPHcgHBa+yRdaAzzzVjU+mlZpAhsXPmz
	+UqfdxV4RCmXlldStvVA20QrMDn6JlU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 192D441667;
	Fri, 11 Sep 2026 08:29:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD3D1F000FF;
	Fri, 11 Sep 2026 08:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789115381;
	bh=njtH3Y8aJsmF2L/mVvCVoWcGDIcAJ4Klj9jaiQi90MI=;
	h=Date:From:Subject:To:Cc;
	b=Veua+HoNohaKmx3l9Bk+TV9RsHWNB2+ZSrga9sg/gwzYk0e6IH4hFQEKrHOmYIOS4
	 3gbsvn2+fxE9bBdFtD1WpB6TOyMZ4Gn1uWuu6UU88lIKU8mG1VNi9cGsWN8N6jXt6+
	 MN0bk7L+fzyeyhZaoLfOzdw6ZlQkKGhppH8EFs6PmpsZeYwa1+6jRvguN1BoeOyELj
	 Y+FTSzgkvlCSqIFPleCvbTiC0AmzS5rzz6VqcVV66PXgOMI8D3KyZbdaoK7U3N+gQW
	 zFODNp/njZUw23aawUL/42+FM40G8jXenP33kOofY9N374ltnn4npPLkwnvNy0DpcA
	 x4JSqzBDMcAsw==
Message-ID: <880edb7b-a803-4847-99d9-a0b80b3088a8@kernel.org>
Date: Fri, 11 Sep 2026 10:29:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fixes for 7.3-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>, Hao Li <hao.li@linux.dev>,
 "David Hildenbrand (Arm)" <david@kernel.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Hyunwoo Kim <imv4bel@gmail.com>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AAB991C0008
X-Stat-Signature: 4e37zun46jbphf1sask7xxb7skfhtqbz
X-HE-Tag: 1789115382-313363
X-HE-Meta: U2FsdGVkX1+q0W6xis6Rrnx2YMyJ9OBoLZdrnnQDaWX5Sg/+79kI8mSY4q+K8ZNs0gItctuH0czVFpvtdSHdqyyZxLD6D3R7exKG/DuoafPjeLHxaHoejOQ3AhOkCi2qD3U5+HSKSnNeFV7m91eAlJr7L2hYddYqd5pDK8hxrQTttbAmVc4oYz4JDdqD9iK1kwGMoPVd/LhiE+WILXlDnF6XSQ/ZVT+haJrslaCs1HVPAcjY3ooYZfAw9/RmPTCLBKQudDmSHSw5EdYUYITbb4dOGb6qABGntKZD2KJy1hm44NjrnKfHTd4Qz/8m2KxWW7Euujduz0gfwYEXaav9429qQiZrglbTgwXnTnrkcvAezIrTsjy5416PsuohbtQx4U2RY8vEmd4m2VmHrkNMr8LplDDTdMR/WSNoMGMQ/u38t7ZJEiigrr1Bozk5vDZmmPIF3nC4Zj8rvFq62FrNcTrw+rIwcENq6ACi1F4xRxk/BSsMQR5pu5HZMxo0VWbScpWx3qjbfatTSG5SYD9k18/r0jVSi5qB0DKZ0HkdsBgM7K4dfSRV40nUqWaSjttLQdwmQS87tUyCP6r0KTt2+pUnYQBJTvg5rb4ZlylpvwYn0RGhCBkAu4Y2r1oOlNXwbqmJtdDYAbrVWbPaeCLoUM1mg0jzWAmUhJ0sZF/afeD2QIblO0EVbXZ5n0LDs5i/fZI0DgeaSTyYt4jVJydQ2pAFYBp+xaPom1/NTIkmxKhJ28hIm1lq4D91HMrnFd7m4E7C5c8FwW4TRHUx7SH5RMzaQNpv3B53Uvc6YqNYGvAIW6SecgZ5DKfX4bRanNqCF33wozods2zcl6pRL1qv//lq+UlC+AMc+PuNvyQKuSOWMzkwZr6M1nSJQt1Iym4Deeby1t8E4AclwgQOUc+aorvagGoiOqHkbtzwZ2cRll5Q2jSzfLMuB0qNG1iWk3tYXz1DcuqJHjRsVBh5eiU
 kKT3wEz3
 MtEicsZ5Ao/vJIhY+5tqeaL/q/gMAlYLMqnyBpvqqy9GhZcmZrV6wg05/wpaRVPFCo+kRO51F7yNiM90GJo8nVPlgfetntfldVKBqtOhF2hmZyL+boRtjFTgTwSjSp5Bgbc6H2wmXwusKBNeSdC6csQN0mwQdQkapR+JtBLyuihMjypCzbpkHXzAfSNdlOjv42+IT+Olu/GOE/3iECsbR22TV47d2xaOW96W0urVsMXsbqMPW0e6Hi4w4lwHsokEsh0vDx2cyy/iurCVb+N+lXKU52/cGGCof9QQglgBSnSHOsTYmeQWQUIc0bgi3CMCC46Ia
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc2

Note the slab tree has been moved since the last PR from vbabka/slab.git
to the new mm/ namespace.

Thanks,
Vlastimil

======================================

- Stable fix for an ABA issue causing slab list corruption introduced in 7.2.
  (Harry Yoo, with big thanks to Hyunwoo Kim for the thorough report and
  initial version of the fix)

- Fix for 7.3 regression of kvfree_rcu() on PREEMPT_RT which can cause a
  deadlock from the set_cpus_allowed_force() caller. (Vlastimil Babka)

----------------------------------------------------------------

The following changes since commit cee9395acd8043be0644b25c34bfa86623f2b935:

  Linux 7.3-rc1 (2026-08-30 13:34:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mm/slab.git tags/slab-for-7.3-rc2

for you to fetch changes up to 4a724bcf5d703e18957397914d79156fa2cf1174:

  mm/slab: take n->list_lock in __slab_try_return_freelist() to avoid race (2026-09-04 12:15:41 +0200)

----------------------------------------------------------------
slab fixes for 7.3-rc2

----------------------------------------------------------------
Harry Yoo (Meta) (1):
      mm/slab: take n->list_lock in __slab_try_return_freelist() to avoid race

Vlastimil Babka (SUSE) (1):
      mm/slab: disallow kfree_rcu_sheaf() on PREEMPT_RT again

 mm/slab_common.c | 18 ++++++++----------
 mm/slub.c        | 25 ++++++++++++++++---------
 2 files changed, 24 insertions(+), 19 deletions(-)


