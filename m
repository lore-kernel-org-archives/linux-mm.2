Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5D7EC606A330
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 09:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cQeZfwg1
Received: by kanga.kvack.org (Postfix)
	id 79DA86B0601; Fri, 20 Nov 2026 04:02:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74E666B0603; Fri, 20 Nov 2026 04:02:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63DB36B0604; Fri, 20 Nov 2026 04:02:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3AB026B0601
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:02:09 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDB4A160E56
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:02:08 +0000 (UTC)
X-FDA: 85454905536.07.6927437
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 38D4B4000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 09:02:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQeZfwg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795165327;
	b=1HvDAPLM2fmNsXi2lnAUd+9/ninLbHW+H0NsEM3GNWrOyWITLMrgDsYTYiDDB/Qo2hkd1u
	41tjcTH67fyAeTTc5mxrHmWmsoSgQvSGV0v/XOA2yW0m0MASbQlockx6MwqXd23lpFjHaN
	ofe7x9V4FgzJ6WZvqr78/W9+o6+bdI0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795165327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SO4taNSoFWvfzpQNg247sizb7f95ixN+wBWNxJFGHeE=;
	b=Ep4Y7lmG8khaMrkAmW4ZHef7hfPGwbAtez1RMq6N56iPYzS/Cf3HbtnEg9ekXhYOsTY6CM
	fFWgbtrWZ+rPSoZ6MTAeZDBOZr7dYfwYN/lz9gxPf4ZGivNPL/KJL7jxg3v90+uuO1l5Hp
	5YOXqoHCMu4KBB5M9hfqqd6EbS6nHKo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cQeZfwg1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA85E61D3B;
	Fri, 20 Nov 2026 09:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D84481F000C6;
	Fri, 20 Nov 2026 09:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795165326;
	bh=SO4taNSoFWvfzpQNg247sizb7f95ixN+wBWNxJFGHeE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=cQeZfwg1AQaM9+g+ZoOKOqTcPDPhUkTiRut3nuD0MYet9vo1DHSjUYUKOvGyZ/lMZ
	 bdKNfGyEmcjPBORO2M3AKpNBgY6M1ZAk8CxlueoNizE1bvfxP2g77TD55706V566Os
	 XVP92ksQ2WrH1AXNCzKWB58iqA0tLp8VFDxb+MGHp16fvV8jyeRYijIERnEFOed/d6
	 eXmkXDYDMMUwzKP55Z2w1viMbecEbCHI2pp1wHVl6Ml56hEU9LAYdGDRcTgOo7udhw
	 tsbdg/h1F13HLAETPurF73/cNsgQXW2ox/j9YKlQNkd9V7tPfS9vz3dxaFFS2tiMwq
	 mJWkJfhoM6cyQ==
From: David Hildenbrand <david@kernel.org>
To: Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 "Borislav Petkov (AMD)" <bp@alien8.de>, 
 =?utf-8?q?Cenk_Y=C4=B1lmaz?= <cenk@deepfinresearch.com>, 
 Zhang Peng <zippermonkey@icloud.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Mel Gorman <mgorman@suse.de>, Sasha Levin <sasha.levin@oracle.com>, 
 Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@kernel.org>, 
 Peter Xu <peterx@redhat.com>, Hugh Dickins <hughd@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Andrea Arcangeli <aarcange@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
References: <20261118-file_folio_flush-v1-0-e9e739ed14e0@kernel.org>
Subject: Re: (subset) [PATCH 0/4] mm: fixes for stale TLB entries due to
 delayed/batched TLB flushes
Message-Id: <179516531551.3851.12254028800691398682.b4-ty@b4>
Date: Fri, 20 Nov 2026 10:01:55 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 38D4B4000E
X-Stat-Signature: tg7smbe1wzq6pex86nd6ea713gfj3ta3
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795165326-985434
X-HE-Meta: U2FsdGVkX1++o0NAxvlj6HD6ZfaIyfJ6iCwjtZfltho3/Wsz2G6xxWYswaqHS4y+yzcm61/1Dvc4xkNGT03XhllNMYU19izRdKBOipF4P0l+16BWHs3IGzECUsKudzFyacGIHmIu7f48EeLX7gBDSTZfETZWbD5buD9KzF6ixIc3t3DOe7wz8SpjvIqrHbWTx82FSiTxYujEop/vRSpXuG1OEEmxgV15W0kkNXjZ5DreJRlfY/uEZZGA4tQU1hDBuj4h8J6SkBMgJ/ewp6Bbs3JVNhhhmwySmVxAgRP6s3aJjBkEQO3ShRXhNhLjDdXM8TMTek/DHdHkQ7TMibyEtMiO7sN+zRQI8MGNj+WEETyRDkq2Dga2thg04ITQTm901FmgpChSfO7xILTQ7T1L59uGCJLJDULI/D/1kTYoH7jFEJuhtHsdHvYRNeZ0K+GMmalAauUhh7oC1YkBFZN7e4yE3vMozoJDAZRtcv95uV+tj/NFE/NQ3MovaDpnDFJlOBCdHMyjPbWc2wi4XD+HHK+orRsveqho6Kv0trGX74FAwPwODKhSUHn6dcTqvAUKThzfmVzMXOyBpKnaDRY2debrTeht+1sQP+12InI5exLr5t1918pG7GfvdPBrQGftyuXYdfgfVNgI+1sSCfJCtkKHXuYpvjTO+I2nTECaa1IJ1JT7I5SI2IW5ceBpBZSWTpZV3a7AbBIJHPFClAV/1zMLTLYDplk/0tvesX6ABpDGL7auXvrOmVvPRULAZKHcoRm+FZk9oihIpovrPbCsn6NYrWqp9DuMJmPiw91axlH1o5nKkOxn1B+xi0sRxxwH4yN+Y1/GT4fzreteO1bu6rxh6zyFsBDzVLiyYqSj2cIJh6kCc+Y6oG3a1gqVmUAAeXvZ74ueOHRbNaNgQlCNKyyzwEhSlx7cwZvx8DfUT4zN9shm+4xkJXJUcyDFGH8j1rNyT9K/vgjqX+46dKH
 d0JShtvT
 f1ADIdrprL1IdMjbkw2QL7vWMYFfrViE9l/FeYwHfjIbkevxNKzN5JezDnHpM3gpVI52GV5OiBPNMTuoRTJQ3iEXeVxhA36A7Fdg1J+8sswS8T1I93g8X+9KzSerrEAKnr/La7h/n0T4+QZ2nBi12dRT6+0n4Apjsq74cmTkPh/i/TbEwRCKjhKlRGDWnMUbGliGnCttssQQ01lJhyfzBMKcl6zgSe9SsDcZWxtP/4IDqU+ORogN4AAqRpPw0pwshWg86JIfU5rrs1WntRnGPMglk3/8Z+xgtIlqM5Xu8LnZ8tzVQINxa9H53L4oJFeD40a+mDbXLE06mHaDt4xTxHLb3SFeL9Yfws9EAeyBrJgGcjf7LiEWSymDgaE8ovnn3iZSpvKV3t4NAT7l1abqUceEGdfEvjOmsRwGnMRcxsl5+XzGyJs9PrctOlr7olxGyyNeeaf4xx0pLUYabBhnWV58O1JkqEbdiZJdK+XmUmMgaX29WbHp3m9vAa/Of7vL/w6oQ0vD67Xm3T1Rblhv+d6M/35ODtq0oqESp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 18 Nov 2026 10:20:35 +0100, David Hildenbrand (Arm) wrote:
> David, what keeps you up at night? Well, the last 3 nights, TLB flushes.
> 
> We have two mechanisms that can delay/batch TLB flushes and cause
> problems:
> 
>  (A) mmu_gather zap: we can delay TLB flushes until after dropping the
>      PT lock, after having zapped PTEs and adjusted the mapcounts.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/4] mm: flush stale TLB entries before installing a CoW'ed folio
      https://git.kernel.org/mm/core/c/5e65fb33
[2/4] mm/vmscan: flush deferred writable TLB entries before unlocking the folio
      https://git.kernel.org/mm/core/c/15d1795f

-- 
Cheers,

David


