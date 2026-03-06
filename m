Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 320ACF01829
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:36:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9AFDB6B0005; Fri,  6 Mar 2026 06:36:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 980C86B0089; Fri,  6 Mar 2026 06:36:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 897EF6B0092; Fri,  6 Mar 2026 06:36:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 75B1B6B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:36:30 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3DD5313AEF3
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:36:30 +0000 (UTC)
X-FDA: 84515435340.17.6AF6297
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9980B1C000A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:36:28 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QIOAzGT/";
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772796988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zrOM11qq2Wt8EtwgyTrD9IqrmzGKUNxJ26C+4LP2SIo=;
	b=sDQS1YrobsQNapqBffQArj7gJ+0dVnwAy/kWxtJoWJeU2BCH4zFxJzid22vw545iQy+Fod
	cLuoi9suoTWXFEs0VxoVSUiWzE2djKw4Q22tBLMwohMVLDauL6luBRhogDhzi2HT35ysSO
	sotnpvVAjeMKsU9kDGwC/fSNgcLiAAw=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QIOAzGT/";
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772796988; a=rsa-sha256;
	cv=none;
	b=cTJj6Ekqo2WA5YMtjLFYV550/3FoHH8jKSCNj/gHH0Kh1O9wD/UdC16eYrFwDxz0SBOxc5
	9+YE1KCGJ62rtrsoVuAA+09AyF8M7YB1sCl+TabvkdcfSJex/D10K50S3uoPmNimlOoTLg
	Q2GaGPGXaaV8nBddaONsfcu1Ec6Nd7s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9FBDD40416;
	Fri,  6 Mar 2026 11:36:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B74BBC4CEF7;
	Fri,  6 Mar 2026 11:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772796987;
	bh=V5ObVZZfm5FLF637XiQISqfieEnIwze/yzCYCJIbxOk=;
	h=Date:From:Subject:To:Cc:From;
	b=QIOAzGT/ODy4fdRFKL3fluKHEE+/D0Fy7fyIAOYGOR4pz4St/173gNYhWXC4xK8mY
	 OnfWquYiXtmkGUkbXXRYXMe14uCWCDJgvi7w5gZq9IgRVHMHVtwZQ/Q+aatYtJNscg
	 vsGK1c/PKt/+Ifl77RDvC6NBtlt5gsQD9LBb+yO/wn2t944lzL5b6EUW41fOIDe0S5
	 r4tW/mxgd7PvY8t+bWrmXoKB+srT37S7FLalf/LrQzWZbcKAYeDXnsT1EyuRXvECs2
	 CST+x5MCaLT+1Z/BzMpI6fW+HKdFmK0GMKE1znf246vf95m52QCe14uU5LPP/Wzzfp
	 1Vxv2IK8J7JzA==
Message-ID: <086138f7-052e-402d-ab36-b40ca4428662@kernel.org>
Date: Fri, 6 Mar 2026 12:36:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [GIT PULL] slab fixes for 7.0-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Harry Yoo <harry.yoo@oracle.com>, David Rientjes <rientjes@google.com>,
 Christoph Lameter <cl@gentwo.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
 LKML <linux-kernel@vger.kernel.org>, Hao Li <hao.li@linux.dev>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5wwkagraq88fx4ncjg1srntmb1bw91i3
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9980B1C000A
X-HE-Tag: 1772796988-129517
X-HE-Meta: U2FsdGVkX19QqIuJyCPnMQi66hKUK2gD/qR3IvenlUwL63GjhKkXni0VpsUqo2pSq1nFOaJLntgQ0a9VPzO0nTrQLjaLXJKPS2KeaMAjnvavP8EX/VTiFClvDGZIljHO+1i576tAcFzoqO8fQi4B9yCNRffHVdRP0/+vI829pPMJAEJOE7Leybf7Z8QUnTrS31ZmZdbPDJi6M6ofXD+B8jBZ6O1OjNJtqMYKccPb5wKHpt5bKY81BEEpwnm8gIW8C81IxrV5d0Ep7E3RXQW+vbiEJrSqn3Kv0zj310dS6APqPuLlzHfXVt4nZ9SSnwtt4jKdH+hOJZkSaDGOpwyC8k12rScODVPqu9qW4IMD9B4B/6ra6MIY3YTx5X+mGpzSymv22NZQ9B9uA/UENDDGIMspDWMq8whX0//nUNIAHNKZX8lFzkTW95eILx0N2WCaMf1JKOU5vBeVA3jMAeWr/wwbXX6CQ4yilN4/CFzx4O6u5hO1kYi1CuMaN5tB5f9NU7PZdiVR4SXRe/zXIljm+8WHnqECt4J2yXdNQcm0to6/VZ7XS8Ew5fzYZqLN55mBAqD4RwoEwywZX/bEPWJ2Qz+W5rt2tJOtDS7PXdxXMNfNbPeRxSzMd6BreaDvvwApiUCLLZWU0Mays2IzeGs5mw2mP+gQZnFbD7Uu7fCJWZnR3fvavvDW9y1dKv6edCoy/G+MscVtbMclvOcDriZ0qA/ty2OC+50J7EjhisnwQphsrpuYZq2Mr9HvjSwSojy0IcsRu0GB6Sdw5ilrxORfzFMdB6Shk7YS3E77Y4BPg4M9wrDRWZhwI8HiF/Ofm/bVsdWyFG7zG8d2gx4ljMgT0yl4ndF2ebJN/pO8N/vp6FhPqR2YJq5rnSuaA1XonIfPGPZntlxn4hTqNNsIl+L4HzoqdlBCIUZxjgHGWPRIs38pYHEWm87uSn/TOF4dgFoV4fXSzGRoASwIx1h72EV
 lXTeMDF7
 DQb2ULu4DICmc0ESKcHRnZw1WlhVWYRl+ah9SmePz8i7PTkB4v0Iol+9urM7jTPwYLcA6Wp5lhK7U7MkIalU8Nxm/J75913RjFknWTvIqKG+xExH4wgSQ7KXOn/be1DK0qWLkM6fz5q3lcMot3YzwV5k9jpeoJi2IaEIkEf6w9LzCRz2g9iWGMqq5KJjnI8LIY7JrkhkrBGN4wtpNCdpOr6D6dPu+Rsbdoy2UyZx08gRtTUZQabIJeJnpPaf2W5S4wVHvPSmceRLa5Qa1fmETIjeu9AQSUIiDwr4ugq5VQkVkmPSBqcxXD53TG0TyrximShyd
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Linus,

please pull the latest slab fixes from:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc2

Thanks,
Vlastimil

======================================

- Fix for slab->stride truncation on 64k page systems due to short type.
  It was not due to races and lack of barriers in the end. (Harry Yoo)

- Fix for severe performance regression due to unnecessary sheaf refill
  restrictions exposed by mempool allocation strategy. (Vlastimil Babka)

- Stable fix for potential silent percpu sheaf flushing failures on
  PREEMPT_RT. (Vlastimil Babka)

----------------------------------------------------------------
The following changes since commit e9217ca77dc35b4978db0fe901685ddb3f1e223a:

  mm/slab: initialize slab->stride early to avoid memory ordering issues (2026-02-27 16:22:57 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/vbabka/slab.git tags/slab-for-7.0-rc2

for you to fetch changes up to 6432f15c818cb30eec7c4ca378ecdebd9796f741:

  mm/slab: change stride type from unsigned short to unsigned int (2026-03-04 11:05:57 +0100)

----------------------------------------------------------------
slab fixes for 7.0-rc2

----------------------------------------------------------------
Harry Yoo (1):
      mm/slab: change stride type from unsigned short to unsigned int

Vlastimil Babka (1):
      slab: distinguish lock and trylock for sheaf_flush_main()

Vlastimil Babka (SUSE) (1):
      mm/slab: allow sheaf refill if blocking is not allowed

 mm/slab.h | 10 ++++-----
 mm/slub.c | 69 +++++++++++++++++++++++++++++++++++++++++++--------------------
 2 files changed, 52 insertions(+), 27 deletions(-)

