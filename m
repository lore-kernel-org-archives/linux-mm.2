Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 884D4606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gR7IJgfO
Received: by kanga.kvack.org (Postfix)
	id 7306F6B0AE4; Wed, 25 Nov 2026 16:40:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 707796B0AE5; Wed, 25 Nov 2026 16:40:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D4D6B0AE6; Wed, 25 Nov 2026 16:40:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2DC546B0AE4
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:40:00 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 123BD1C496A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:59 +0000 (UTC)
X-FDA: 85474959318.22.9136A02
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 71DB820007
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:39:57 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gR7IJgfO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642797;
	b=umDDxXhvbbQIspdgScsp+DW+le5h1oROgvc9bU4atJU9apmrM7t9A1OhrSUYMd2zsod+HS
	mRcsdUvJm3fNtgrfxsm2Xd2tncZ0ilRRtigB5lntRTF+6jKBrBK7hhQGeKUcpy9LILjXyq
	obyVC6/hVqhHrt7tQxU0PCWTGdSLPdk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5x95mFtq9SsOz7VWm3eLFqsSut3QNXOjHk0FlS/OEJY=;
	b=cj9aazOoM3aG9fNJZUYRSVRB9vGcSycSn3576htPZkvTah62KvhdZS7MrL+zVkwgbq2dMa
	U5nNgizbIAgk3C7GXjMbi6q2RTaRrcAz/nnR3WhF30F0k8GlEeAI1mRJAaqy+pwDaSXfKu
	mR4i51YSnD6boHdHOdydqvhWShWLmgo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gR7IJgfO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB6A5612BD;
	Wed, 25 Nov 2026 21:39:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1478B1F000C6;
	Wed, 25 Nov 2026 21:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642796;
	bh=5x95mFtq9SsOz7VWm3eLFqsSut3QNXOjHk0FlS/OEJY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gR7IJgfOkEVQt+Kjd5Lhv9/b2kVV8yRkGEde2GpliNCOVGS04lYkQSSULOJDv53Px
	 2Jekw39TzKqHcUDkbuoYJCn4S1gmvYLWPkpuJUCpoFdw3elJJ7zWe1+xTfJHApgEiK
	 P/qQpkx14FJESeSKPtOdFd17NKyU3J6ilRq5E+0WakHtwQXwFkW8NGI4pXgUznisYD
	 rHkqysyl38T7vPQqLMCGxrCLYc15vSWMv8Mtbx/OlEhREtZmOooXaG3WLLIMn7ebg7
	 Sv768LnK5Hpwl/Tk+Rc/AyiB0N22eVUhJz1rai3YDYmpTQusukjx69daAQV6QwFd6R
	 NEmZ1eWYWrp6w==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:14 +0000
Subject: [PATCH slab/for-next v2 13/14] mm/memcontrol: do not allow
 charging objects without SLAB_MAY_ACCOUNT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-13-7c680f02a734@kernel.org>
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
 Eric Dumazet <edumazet@kernel.org>, cgroups@vger.kernel.org
X-Mailer: b4 0.16.0
X-Stat-Signature: grpqbmm1cfqdhbha8sx16dddhpdbkp3m
X-Rspamd-Queue-Id: 71DB820007
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642797-363440
X-HE-Meta: U2FsdGVkX18nRcaHTySlCPCWM1q0Sti4KCz48CsAJu8QR+evCpEtRpZ578H+YI8lrGYm/I4rla8ARiumcFrxawdeFhOaOUMfdhw6mBvNEduATBi5oupteHuE/hmpAdFXXI0XrGauG0KmWMjvn5DSGV/OuPl4JtTbIqY/KIRW5Mqu11cNjmnn19K0XyefjFFp4Pu5kyisTQeyuOu+e/nZvbZqJc6CunFX5TDZw0GS65ivmlRn7mA55j3MaUr67R1Kj5UHy84TxogaFEX/0fJTKlIQ1/fn+zQCeikA6yohexiY25H9KJeyM600QSv8JAjDJmNWHyfxzHQBdnzkzccmhtM0LW6RAJTTEiK6rr5JUmDEkjNPQIUSvdh3+8qi/+Jh57A9aKxnAMV33oz+ZjbWXKnHdkJhU4c1m/53XZ31VuYMR6qdaWr0vsp065cjoZSoGfBZ/FcXCVPdf+Q90A3Mh/ShsJjSl7Iy936tHP86uEs+yC5DIZw5ZPiH497nJ/X8sLhlXhwgmx8nYCfa0FQf2dmJtF9RykmUhGV4PSyyJVL3oWrVcRtWIxjQMi9qdoEKx/rWOa0FYPnp11ua/CkGyF9XJtz+1hInm4CA4WFK/yknbcbnnXzQyMHLngHY7cYuIAM4a7dx/ZCYoc6bb3UPTNsX13VeT1ixLHIcWbwkz8bEtAyd16pXusk2XgfscUTwLW/ElvsVOo06x9qsOGYGZo31TNHJpKZrGete4sBO76ihjjMJci29J8JdyD52W1Qe9a9suN2EhPswatOlEnq8PPenQHifyXeZwR5nn7uQ+I8xsQiUAJGr+wJXMzaURgvNb+WOmu6sIRYJG3NVYChuDK/riBWTGA7wjNw8+Tcv+SS31BV+dLkj3xMTeCws0K7vXHv/Xsr9TN4krAMgVqfdmuLh+neZ5Zf5ndsQt19DHheCHtxHmGBoniURiwrsDisJMOphHo4RjygBH8ZERK2
 PBX9fVfh
 D8cYYVfgW5GQWoHttKcUs0QcEAJ5WP9QoX7j3AymAyrQ1dvDaLOigQMFAyEfMwTIEhqEkOYk9CCKe4TWeu+/vWpYMRcc6MvQ8xS4PB+zha84CBglD0kACxCznpHo79GNnFo5nmNRUtyR2eLzTSc0Hf3pcsQjRD+U65lu+GvZJ5PdzAzrFgeFtcK2w34FMlNneD9yhwyPoYMbiGpd0yzaMLngq4fgFCFHYl3EHJRgSD6Tt5R4k7BBocUAv/6dnKfoIjo2tNeA6IHiXqC0HxG2ksfNOGp6ditU4f7Dez4b8hb9Xj7CaIlNygSjoPi79qHbCk+JKDiEq7Wqw1uXeukJBIQFY5oR2aYlaWXJn2el1u6CarqYk6tKOxQnbo2d23OkWeNNiHdkrytp38bzKo7qt/cp5BfB3berj44mOb+VqFwZbSXYnAAuj3Mtw+RSrJYDOwxwljuiupw+zjWCWd3FFeLzsikfZ5U4FSL2s0mHGCESxpSVfLOTKB/FKl4J7dScNoFKNnRs8gVfrqCpJEOag8xZ0VtAw5HwOnk3Oi13e4AtklAsUrXcRApWX07DiNx6lS149
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Objects of a cache without SLAB_MAY_ACCOUNT cannot store the objcg
pointer once slabobj_ext space is no longer reserved for every cache.
Skip charging when __GFP_ACCOUNT hits such a cache, and warn once under
CONFIG_DEBUG_VM to catch callers that did not opt in.

Refusing the charge here is sufficient for correctness: an object that
is never charged does not access the objcg slot again, and the free
path already skips such caches via slab_needs_objcg().

Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: cgroups@vger.kernel.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/memcontrol.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a07cc73acfc7..0eddb16173fd 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3707,6 +3707,12 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	if (unlikely(*p == NULL))
 		return true;
 
+	/* Do not allow __GFP_ACCOUNT without SLAB_MAY_ACCOUNT */
+	if (unlikely(!cache_needs_objcg(s))) {
+		VM_WARN_ON_ONCE(1);
+		return true;
+	}
+
 	flags &= gfp_allowed_mask;
 
 	if (lru) {

-- 
2.54.0


