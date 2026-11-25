Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E7BC606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n6q2xfHr
Received: by kanga.kvack.org (Postfix)
	id 7C82B6B0AD1; Wed, 25 Nov 2026 16:38:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7513B6B0AD3; Wed, 25 Nov 2026 16:38:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 641046B0AD4; Wed, 25 Nov 2026 16:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 447B46B0AD1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:38:28 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DAE361C46C1
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:27 +0000 (UTC)
X-FDA: 85474955454.04.7792D63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 35952C0008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6q2xfHr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642706;
	b=xbcewoJy3jYqXXb3ZnyxClbhxsMuTlk/JOpQ7yPrEbsTG7Ld2744RbyEt8w3FoObCUPKkT
	dWdHqKLLaBYZiXcKdsLvmdhp3AqpNKlU4Zk+Fy420LSO4Q8ZQWlJwfqvdtqQpYbUOuQF4/
	AXnEUc6Bg5d9vkB6IQ1QA/5cOHFXh4w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VtvhyDNbnaCNct3RDhNs8SkFhauT52QXx/BClCdBvMA=;
	b=L1dRVKW1JfUPir3z4N5oSqrxsx4pN1tFusypEsZKjS6C14f6DZ+7voH0sG5iMFR/db2clU
	mqHx5zfp49rAT7F/PQ7lANoUvlXlLGYwugnmcXqYYOstUQkDGAVAgko3U6qvXzrTT2JH5I
	Vxbla0L9aNq1Dss4NK4jdxwFjL60YfI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n6q2xfHr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6BBA743BB6;
	Wed, 25 Nov 2026 21:38:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 494501F000EB;
	Wed, 25 Nov 2026 21:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642705;
	bh=VtvhyDNbnaCNct3RDhNs8SkFhauT52QXx/BClCdBvMA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=n6q2xfHrGBuWnpZqpTh6pf2C0390tzgmRh7DKN1gnFHk0AQmX84qzkWsTtMlQMrLc
	 svRe4uDwGMbaCc0ORb/4eYjHPaJEXt9+0CG6S2sgrj5zO56NZLESt0E0WsTBLPZgHg
	 4szD6xpfXlB7VdAqk4n58y0Mn+XQGISbxcsm0peXnjcedc1s6oscnD5cELpIM2+Bas
	 GV6nHvljwiC3FXB6b7KnWmnzSlZJrtH9ICY4rkDePq6A3dru3yjm3Ps7sz3UPn5Eae
	 qqotYuMecl6pP17UXUrJsGdR+LchYf2VnQkKlBD029/iN7zPzhq2DOWgAKvKRY2xN7
	 WahdfDmjlIiSA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:05 +0000
Subject: [PATCH slab/for-next v2 04/14] fs/buffer: specify SLAB_MAY_ACCOUNT
 for buffer_head cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-4-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 35952C0008
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 91aiw47udh3pop43c3kcw91ts8qxtqwd
X-HE-Tag: 1795642706-510507
X-HE-Meta: U2FsdGVkX1+LCwHVy1sBrD0aL0Jwm/E1yTOjkwjbY6nGeb7FHpJXVoDec7m5ZqEiGa3gTvE3Tcsx0mzUGyp+6ThVIeOdtRfrQIPmQaDTr+lkhNGX4Qz4E/qClANJzlBjzFKC5oAROJvY28gep+HVBJPfmt5c6dwuyeEhsWL/wxtSZLwXhHap7ZIxdaklDytm49U308ixh4LlVWUj1RpY3YkSMYGsv0anzu+xryfGDCWh2V1HRI/EsvwR/Ld0vxeA75B4aTLV/FEgYYJBHHP6ZZNwlNYu+k5zBFyoTjbN0fXoXbfEXuTdb+eCQn9RUzdA6t+rT5fBGV/4Qfr3+6KCvC0/kwIAvXXMokV38QK7UrhascxvIDCSkFEX2y8xYmPGZyrK3+pgXty8t+yjxBkM29RuObRES2+AbpyAtSJ+oBxvoNapnvLM8Lw8brug8YGoRieT5ovSLBizyazbr2KteC/SF5w9VA0aNR4SIhWkoYX0kMKzGZFZ8JQ2cpIIySAaQ5GTvbVQbfhiVMaioymP0M8RXxguQ8qeqVKA9/Z4viC4/hulIvWwxM9y1lcYPErSGS8oK5JjPo4rVcGV5YsJgGmVo72HADHjJwSlIG53oIQke/xclJ2ZQH+2ncaQC6lTpZfF1sbznk5UKCSrHoFr4THw3Xsn/sPwC0wNyIaj+itXSlMuMrxi27hgObotPjpD+DXW6svJwLeq1j15GZxoMsp1dHYzk3/qrMHCdOWbkxT+Us26cACO2QLfKIXW/gd9Buqy20TDbQQSoUnIdj5GHx5AaP9awGD5tTQYZf82E4KpeH+gzFveYj+DUhPxmZdMrq6YGWYXFnOXELCvzc4onq0AeFzqqXT40nZOhZq+iS27uFFdQTgE6SBmJehzY8AXVTrccw8uDwVQa5U1Dpt5S2yeym6OIRpCM4ExXSUNEEBU4tAshDijdlJdyWk2TCOSIg3V8HP+a2X1yhXtyTv
 jxZiHFJ3
 dkamjSZoJk3zDQssEwGxYbYf0MTpqM+w2P/H7GfJsGvzluirJO9Iez8zMOdt/27DkltilZbw9xCJ2v98ufFOE6LbdMp6w1VoUzxIQQFKVFmwgA/US2MPXBm/I2h3pGO9yo/wDYmFAGA/r9fTsW8KQWPsQGn24w1ybUBZ0h53Zw28hmvaeU51pw+MmQm38LYTMh4P7/1naQrBCiXPr4jPTXa3SwvD8ac+Ot9R6qgRQaKdlXBcc+JU7nPY963ALeM8oDVtJ3+MHcsZ7R+ZRWBa952uiUL7fWPiggW60tciBDK2fPqn713h1L/xMrKiowLe72js661QxfrlcGtsesJFLiAHQoe8lnTJ2SNzSHvAaa7fbrKJVQvO1OoyfaDM0EYpUlmmVNNH88YJ6BWol3vDEXCvXSYKFPvr+iNeHHcRqC2i/M1hXtmXPqAxDTYnlpvDEj6bUYlYSXON0AWX0a+FdtK56D+49MiXo/6nBEcqAXZdzg364FrFMZkZiIBt7pYvyZpXuUUnZET7MmF3QDIq+3Vva53XJUxysZkaqU8Bzprf7++R1FbAf7ic3MUdG2VNiG95o1ledfAneKg8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Buffer heads are allocated with __GFP_ACCOUNT to charge them to the
memcg of the folio they are attached to. Specify SLAB_MAY_ACCOUNT when
the object may be charged to a memcg. __GFP_ACCOUNT without
SLAB_MAY_ACCOUNT will not be allowed.

Path: ext4_getblk() -> folio_alloc_buffers(GFP_NOFS | __GFP_ACCOUNT)
  -> alloc_buffer_head() -> kmem_cache_zalloc(bh_cachep)

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 fs/buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index f951559e7d32..4c24f4546106 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -3006,7 +3006,7 @@ void __init buffer_init(void)
 	int ret;
 
 	bh_cachep = KMEM_CACHE(buffer_head,
-				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC);
+				SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|SLAB_MAY_ACCOUNT);
 	/*
 	 * Limit the bh occupancy to 10% of ZONE_NORMAL
 	 */

-- 
2.54.0


