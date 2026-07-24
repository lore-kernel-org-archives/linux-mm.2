Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71F25C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 12:32:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549A26B007B; Fri, 24 Jul 2026 08:32:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F9C56B0088; Fri, 24 Jul 2026 08:32:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8C76B008A; Fri, 24 Jul 2026 08:32:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1292F6B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:32:21 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 88F4D120360
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:32:20 +0000 (UTC)
X-FDA: 85023608040.30.0D31BC9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E1F9140003
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:32:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoO4MdrS;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784896338;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1Mw2kcUUwoDnm8QhW9I6MAmD2TOQNWESrXV0NJzwkyk=;
	b=R9xNfQZwTc1GM8QOGg+E58Axg2IgFFJ5cXOYTnGsv/EqU+lqN/Cbk+mNX5iBWpIDYY4p07
	A3jl5nKr2E9fCFIsBlyCTtu0L24+8G3oUqXZko+enQLKQURO3Lr8uBT+SU9h/4hNKed3td
	CE+pypIkVTNtKe+toQPkspZW082yAxw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784896338;
	b=z3hVeNrg+Yqn7wLMa42Ulfw5TNBMUbPyEggVV0erf+2O44fzE7iShffNHnlOT9R8OJ/1Ll
	M+CNeLIYyOzRd1F9FpcazXhuQzbaRWdMNYKkwB1XPXkabMnihSRzcXjpSxPzT07c8XNxB7
	nDN53lZNjqDJi7Vz3hyP/SBu839voqg=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RoO4MdrS;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F4020600AB;
	Fri, 24 Jul 2026 12:32:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BB401F000E9;
	Fri, 24 Jul 2026 12:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784896337;
	bh=1Mw2kcUUwoDnm8QhW9I6MAmD2TOQNWESrXV0NJzwkyk=;
	h=Date:From:Subject:To:Cc;
	b=RoO4MdrSpmFJeOsBKGhEwxv0r23vpBT7zAgIBDxdtL3pdvP6cDl+j28wqVTv2ZwZ3
	 TagaxOE6YGM8cuSQ5ZretgingwmWMG+Fmyh5WKt41aDUgHGrch0sGVu+WlEVdiRRc3
	 dcBbYbi/iHASWUuMy3aVS1kqBGcYtEP5vQxvZDFNDr+nSOQknuXkDLoDSMRTXrMpUH
	 rZrxe1xcfutJWcjjYswcj+vuaSQbpIlCZeFebnfI8BioMjhdRdz7dE2rD/LYGmBWI6
	 9AkvKbMkYymjOcjJqpzHe44wPn458QWvbKldevI8/MDVmlbp2gdCUDs6PfL3mg4aTq
	 HdrdEU6sa0mFg==
Message-ID: <abd000de-e6d6-492c-b50f-09d1309afc83@kernel.org>
Date: Fri, 24 Jul 2026 14:32:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fixes for 7.2-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Harry Yoo <harry.yoo@oracle.com>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Rientjes <rientjes@google.com>, Christoph Lameter <cl@gentwo.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E1F9140003
X-Stat-Signature: wecpoz4o5k1iirix8hdtq4cqo8bjqrzg
X-Rspam-User: 
X-HE-Tag: 1784896338-467824
X-HE-Meta: U2FsdGVkX1+5Pfh5opK0RG/xBioPosh7yhzWgIidgoEkagvuHnxh4iAjXcq7ALRy0uZQjawWAjHs45dMWz+iDJcDINLnlVNZfJu4JmzEJf/8kYlC+sghXWxlwyb3EYhrWSdELhKBaUfLqOqKxtyQlLTtVFAChq2iTwg0Fyl7wSoGWLM+zHg1DuW30n0o5ybRBB9bL9dw7PzO8Bi25z6u8jRg7VVXZ1isHweqTPY07A5VbLBmwMvEu9TE1nxfGtKyBCOxg9iQnj2tVbNhLFZRiL7n1MMre7vQBx2WxqMIMSmxi2soiNWvQ+AdQ71yC26YEhtJRNrptYNsHWDxQTeBw9prqNC6MIdGWyedSpTeEU8MCGIdYI5M+hPySIhLAjcM5XHWOs05vXNPCPRmuX4c8BVNT48XHLSdWZj2b1+mVH9pIHLQiMfuoZ88oX4DrhsvZGLFFNGk0EMHu3a1ebGkM2816HBkGPL37wsOikKQ61FMQHpQprfFEJV+6pF2qcMTvVz7Nxl5SANMc4FVrX1OIsdVBIAH6xHqFDYtmqrpuh20GLdMg4X3Hgg5XwaTsAoGLCwIat1xzGgoLOjgw9j9pUdwFqLrmHeEhAVLInH7tvMcMRzxka4Fat/v3x1jgDgUY/RBe8BYB0Eog6qUL6d7q7/EtwGoZal2EWTdBlkXTakA4KbzcHiFB5oPiQHxblR+dNBbT76JuMb1aXqD2B1drvBlvkRxhKX5dxNgcO10UiN5Y9olMhwClLnOdBWayD+qNlrMu7UDnXCuzeC08cBV6S5SGoQjcLeRSkGz2h/pX4GLp2cYgzQYtqddD0cyCiH/eg3O7M117ccVwtMaCWj14SbXGgdRkSwZ1ln39atMhb6YPrBXpEdKkMA0pMWgZwmbjyfBJjM7cIIn+i4baXE1Jad9il24reLWckqI5p5Gp55eMld9DUg9tvd6yeZ8WU56MVVbTxfStzla31B/fiy
 JQsyNGIw
 nqga8pjq9BB0ME/NCnmlt3FxVWUEeR+Yrd+jEDKZo0+YgJzwoBPpvpJxIOObgY/Hun/hN+AZMpakKLyTlHep+4uVnaLpORvcp1vTs6O9+/W7AAefqcvQlR1UO691dSjaGWZh3fe/mkhyXRgKBexZ8iiceuUV755i/9RZfFLS1Phq8vvTgDSlpNGlfWOU36HXAYMHE0Hq1VRQOIb6c3Cd/9dbq9NZPkCoUJDgQsqzEh6xG6G0PAw35XybIrKpIBxxNAzYKClN36U1SqrcpwUNrevMFUbqx7nleG1wYwyEdIoheKQ1KI1+vi63cQgSsq/SCoUJY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2-rc4

Thanks,
Vlastimil

======================================

- Prevent unbounded recursion in free path with memory allocation profiling,
  which has caused a stack overflow on a Meta production host due to a
  125-deep __free_slab<->kfree recursion. (Harry Yoo)

- Fix type-based partitioning confusing sparse which does not know
  __builtin_infer_alloc_token() (Marco Elver)

- Fix a potential memory leak in bulk freeing path on NUMA machines.
  (Shengming Hu)
  
----------------------------------------------------------------
The following changes since commit dc59e4fea9d83f03bad6bddf3fa2e52491777482:

  Linux 7.2-rc1 (2026-06-28 12:01:31 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.2-rc4

for you to fetch changes up to 5ff172f6c94d282d83cb88bdfec5f647ad9c6105:

  slab: silence sparse warning with type-based partitioning (2026-07-21 11:28:21 +0200)

----------------------------------------------------------------
slab fixes for 7.2-rc4

----------------------------------------------------------------
Harry Yoo (Oracle) (4):
      mm/slab: fix a memory leak due to bootstrapping sheaves twice
      mm/slab: decouple SLAB_NO_SHEAVES from SLAB_NO_OBJ_EXT
      lib/alloc_tag: introduce mem_alloc_profiling_permanently_disabled()
      mm/slab: prevent unbounded recursion in free path with new kmalloc type

Marco Elver (1):
      slab: silence sparse warning with type-based partitioning

Shengming Hu (1):
      mm/slub: fix lost local objects when bulk remote free batch fills

 include/linux/alloc_tag.h |   3 ++
 include/linux/slab.h      |  25 ++++++++--
 lib/alloc_tag.c           |   9 ++++
 mm/slab.h                 |  32 ++++++++++--
 mm/slab_common.c          |  19 +++++++-
 mm/slub.c                 | 121 +++++++++++++++++++---------------------------
 6 files changed, 131 insertions(+), 78 deletions(-)

