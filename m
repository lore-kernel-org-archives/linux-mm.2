Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9C10CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 06:46:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CA3C8E0001; Mon, 18 Aug 2025 02:46:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6539C6B0096; Mon, 18 Aug 2025 02:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590DA8E0001; Mon, 18 Aug 2025 02:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 494296B0093
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 02:46:26 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F1A50BB60C
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:25 +0000 (UTC)
X-FDA: 83788944330.19.8915788
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6BAE7C000B
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 06:46:24 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4Ak7vcN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755499584; a=rsa-sha256;
	cv=none;
	b=4w8Z/ve8DF9j1TkwmMTooQTF6s5rZaCjG/+V9QsTrVswe73rgPrpAdi6zzj9TAyIwwodcN
	Ys6TUhJikx21XYZCpsNjjF8UuXqDPxaatY419i2cfumK6lIpSkHfW8DOGsA7LyEI3M51eO
	RcMSuzxOKNqBaccaEatrz7M9A2Y1yZo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B4Ak7vcN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755499584;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3d2pSjfDoc8gBOUS0aTXd2FKYM2vD6M0xOsbu0ZmJgY=;
	b=vtL5wXw/R88Rx41h3x0Ung38qUE48xyL2iznju/lrhBvtLBEo1fZwVjBSzQ1GmxH5EFHkv
	Q12pYILh5dC5lOhWdsxyvXpnz416cbd/E/dPX7JgkYwcr9cOrP+n0Kj/AOMVa4OVR7b7W7
	wFgl/xP4vCfJAIcprG4NWhV69IWzYd4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0346F41906;
	Mon, 18 Aug 2025 06:46:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2A80C4CEEB;
	Mon, 18 Aug 2025 06:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755499582;
	bh=k4wONO4GgkZMYhiVNRn+Rqnc6LMhXUM48Phy2bxQxHI=;
	h=From:To:Cc:Subject:Date:From;
	b=B4Ak7vcNjHcl3W8hAbH6xBZ+wbLYCOfqkG60Sdu897lVLfK1LXXnhUht3bRC4Jq8P
	 VEChPSyBLxM4RgEv0aekhlDJYA9jDa/WWebABA4qnklv7rnhxQZPv6bYXoCNLCQDdY
	 UBa0ZeOXdAhEfKiUkIgfC/SPPiEujZxxLi2wbNScw1IH4IC5/qe6Ccxkrnmcwc7hhw
	 I30DdRoCb+xuoQTTCRDtt5H3Fp80+vUsRniIX1GqzD5rphLKbUYBiu5nbz8Wu6HVfN
	 2FjqOQg7nL/R60MEq/tmHX/SZqcdwRHB87q7lJfEEMIRJTnmAU/Hs4NJxJ0ygInlrI
	 546Z0BC7FB3ZA==
From: Mike Rapoport <rppt@kernel.org>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Bill Wendling <morbo@google.com>,
	Daniel Jordan <daniel.m.jordan@oracle.com>,
	Justin Stitt <justinstitt@google.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH 0/4] mm/mm_init: simplify deferred init of struct pages
Date: Mon, 18 Aug 2025 09:46:11 +0300
Message-ID: <20250818064615.505641-1-rppt@kernel.org>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BAE7C000B
X-Stat-Signature: ekizem9zkjp35icyet7ogiup1ayusb6c
X-HE-Tag: 1755499584-295926
X-HE-Meta: U2FsdGVkX1+f3uZxQO+FDvTtluhsENMgQd10FdUVQofyO2gkGvYdyfpyF6HcImsH02OQF/Ed6lAddHiXo9oqx0MfEEG4OoaYytoQ3lCKjJ+S/5j1bdO5TS2lZWH4iayMszD8ckHog3jutDfejCXEcWXCrk0payIEIySV+4jOZ9+BmsZSqHKjPy4McMOiNvsOvBBXUWzHn4tBvaXghp7f/ddizce58q7AZvr1gZuy8nNzdDp1SFjG/uagZNTPp1QWhOFJ63q1KEmFiKeFL+z0mVrdD0hA2/gwDDtGZwEKIMuEMNQ+28Ea0rgN3QqmOg7R8vZDZwp/bbBS1WMbqmjqsXvFrYvmNukvCU7vpgqfMYC8wFug8L2eifgXfmaJ5NAlhzZry1C242KyvderzAa3GM+HKO5M2BwawWmxKmnC1yNu5IbLdeVcGMYoW4HQT0Da9VKjJslj7lCo6ipbSpv3vPP7iRNlhpi+xNs5ja3y6nJ4fV5Ai0t7hbvTCziSSwi0Gt0Hw47XhjOT0ie0bLGu1Dd8xpU/axPlvwvWYbB0dbDb58F32B8Bs+y3moQKe6dNH002UI2+qwZpj+TQLWvWPW7wEeF5/kRFWfHCRkow/0zLlBb5OtP9aXBLgwhD2TdlazLCfcPAC38CUwLz+GIEVOoXl2zOL8cJzi4rtXhTsTuILhdTt2tuJfgeoeYOh08YFPPl+zEWQ+2B35cuLzjMTHnAEKP5/jwn2GgD2v8hkBxVqv7e6Oqq2edJcKHVozjzL7bm+4RyaONHDnsTj827Ikpu3D19IWz9ClsbF8qSo+MlYoc4WlRaJ1xD7tPizQqy6oknTjaTA/nOjJkvdwa3gkU4+H046qnubGU7+FPHQ1QR5EB0Blt9w6ry5TBFNnc3juck11O4ivkaQi5HL2IhZbvrryDfPVE/VAT9K6NvNwX9/gZe61bTt1P8J84A6v2+zMwNRHW2jNFcZ0VRUXp
 WCCFtCCj
 03GSFOgPhG3rOVuHH9VBT9+OeO1me4G5AxZxB8hL1k/5lRJkBSWFizLnJbPelHqjtlN3F7E5LdX5HgUoN/yiWGG8yk2hou7w31DyrCN854iGx6EAcCE42sFaDj8MIUyzKbX1Sq0kukbxwgQ1/m2f5lkD50hU+lKYTx6pWqSP0DLcF0CLn1fYot2tODmF7mgfrPWV923wfaOX5P7Kw4dQoIvBqqWbK1YH22PJzKHpInkfWEZunEZPo3Bon+nouOie4mt/zXssx9Qmih7PDP87ZNOUm+ifKN43SWKQxQgv9VasbS/lFFJSC85wauyNZPMME4oEGalpHV1850RlqcQEWEdzV8ynX4uXAvFwPap2FxbG2+Xc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

Hi,

These patches simplify deferred initialization of the memory map.

Beside nice negative diffstat I measured 3ms reduction in the
initialization of deferred pages on single node system with 64GiB of RAM.

I don't have access to large memory machines, so I'd really appreciate
testing of these patches on them to make sure there's no regression there.

The patches are also available at git:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/linux.git/log/?h=deferred-memmap-init/v1

Mike Rapoport (Microsoft) (4):
  mm/mm_init: use deferred_init_memmap_chunk() in deferred_grow_zone()
  mm/mm_init: deferred_init_memmap: use a job per zone
  mm/mm_init: drop deferred_init_maxorder()
  memblock: drop for_each_free_mem_pfn_range_in_zone_from()

 .clang-format            |   1 -
 include/linux/memblock.h |  22 -----
 mm/memblock.c            |  64 -------------
 mm/mm_init.c             | 195 +++++++++++++--------------------------
 4 files changed, 62 insertions(+), 220 deletions(-)


base-commit: 8f5ae30d69d7543eee0d70083daf4de8fe15d585
-- 
2.50.1


