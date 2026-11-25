Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2568606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:40:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GRSsjREO
Received: by kanga.kvack.org (Postfix)
	id AB2A26B0AE5; Wed, 25 Nov 2026 16:40:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89A16B0AE7; Wed, 25 Nov 2026 16:40:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0026B0AE8; Wed, 25 Nov 2026 16:40:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FF2D6B0AE5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:40:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EAB05140109
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:40:07 +0000 (UTC)
X-FDA: 85474959654.02.67A27A7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4F2C410000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:40:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRSsjREO;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642806;
	b=nfqH7pJy6+dGLXGRIE9Xdj03JPPzdb6KoDOWfeIjisLOGEORy+ipndWiFGjk2wIEC7NlkE
	HDYYoYXOn2x3AenzVlyr6dxBe1bvdq1+pqJVCGwmvTSEbkKnywdnLHhWyUy1TTbpVKrug/
	xEsN1bs/rIS9LemyuiNeV49R96JYDhM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vTpYbw5ItroGz0DZO7PAjQShiM8iXjTmR55aJhYUH3g=;
	b=gy6LIYNYI4G4Yz/1VJhq4572m4Ql+QihFaboaKfWMFbHNDHBiVdXl/qKd+V8kjF7Mdwzwu
	qsjFYr7ZYcyfkta7SUmJgoMS/AQWS46D5uKqMA1LWH7gNsDOyjRrA/smHy0/purbgid9vR
	SdXcJL1HW4NTzY/4N/FMGqNvBBWOJsI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GRSsjREO;
	spf=pass (imf14.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD744612BD;
	Wed, 25 Nov 2026 21:40:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B041F000EE;
	Wed, 25 Nov 2026 21:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642805;
	bh=vTpYbw5ItroGz0DZO7PAjQShiM8iXjTmR55aJhYUH3g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GRSsjREOeODhI5QM3n2jnFfutP8TiC2UDlmMdp0c86+anFTcws9MuEdgcZWJgWP0c
	 5BHn5mQMtmswZRaAL2973a9k4bOpstS04RzDP3QBv4UvxC01O4sXMSXh52Ox23gxTq
	 VZybPONqkOJfx9yY92XNGRQpyENEFbDh6eE+IgK0Jn/cJaWaySXbOteZhO3hd2ts8L
	 XK6ADqs3lQJnK9wJgFqKSlSOKs0TDHR1RizgROWdlolXgbucx9A1WlxtnGSYcSb/Xu
	 5YAZ5xl6hAPVJPR3oCBUPgDbUmduQ8vG6K8fDxNIXc7HR7aR3mvU+/BH/TMQ5YGGed
	 ADuzLhxw7XKvA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:15 +0000
Subject: [PATCH slab/for-next v2 14/14] mm/slab: do not set
 SLAB_MAY_ACCOUNT for all caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-14-7c680f02a734@kernel.org>
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
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F2C410000F
X-Stat-Signature: bfek4cqb1fjdhmnp3s4fign1653ifcne
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642806-228245
X-HE-Meta: U2FsdGVkX19hP3S06jVq+zxw3/soWTD/AOGMa4Qb9Grx4QSU2ocJp/jbmZxMvDRh0Hl4GsuUeH4tQQVjX4lCRjTXRm8I/W9XmFfdiSA5Je9Te+TuPw3gJVhhtBm3D0rD3G+/XnffVXTrh1y1Uwvy+F6wlLtXeUFnN77VJ3JXefAwaa/6nSgn27NC8S+1f2KADBJy3WKYSpqktdXI3uNLkISz2b4P2G6bjl5VspTEz/T6s2nX7dEKGIUq/ICiMPJ2coTcyciGYB5HuAvtsikKjJuKBPSLLudChEZ9rsanBTP+SkMrxzDkWlVFNdfx5qiLhlyyQcjO+6cXennPcWlvF8xw+UOu3BYVaN4B0pbreYqmPN/UVB+bSEmtcaqVQThoG2/uXLjU0iVugkhkxsvZY1ATyGtNQxvZarpIESz6Bf9PxhpbhK4ylH2iqYD3aQa9PtPze4A123rEQEZ2ikCk5k0fg029uJ9I+rIWUwStGO3QSGwBC6ufxwUqzPB/xqSz8F2IYnpgQbu6xXGVBDNPhPq0y6tuUpEoNHVDe7Fqb61gMgFlg2xSEy1DPFqN9LikYMgdDelMtlCZJS658jHrZidHOaO8xHLKDtwtlRODieJnN5GrQHWwnKFywT9lcB4BhB40RxHNJUGAhR98LzY9XXfPy3okJ+h+DXQk84ukpcLtMqDY1nzWwwbgmTtopH9H1PbOxGJHbg9aY/DizpTmYG8nXy6Lj4hLLzsSCPDi3ysopemrlRFfnFqs6xfLXFxaS9VomCwg56IXg5eBYBYb60QNcrndgcx3mvjyoBwOoUOn7navfR/1FEZOZcLxm7boT1etnzBHaWGk0UT2GhAocpyJ42dda4HFtVfznOpFFmCnqMzEsLNA9tCZEmLuJnJe7DpiYFBkP4vRViLL7Ds8dugI9e3WFj7O3QiVoZOnNY/gZECRx5SLhL1DRDGvQSWiPhRl+cwYSgdoW1vu7vE
 u/L+/Mla
 Kea5BPza+A93uxdjx0koux1AaUbhcftlZ7JDaqIXhn4wL8W/djry3zurW8VF570ZdG8z1L5CNGuLPSd+YPB2QN8E7DN0gnYcXxHbaxO2wWkARVlFnY0Fgqr0FzEW4Ccn4hkZJjxp6VzLljLbEO5uUOw/KCqNiarvG1yu4GIfHMxRfpWCB4Iiyb5x4dLa5JDIg6Yk/TMHjDzszftgOhOwFop6FALNH+fm3jgxG4GO8luL5t7Yc9SqmrZfBMTq4lVY1Y8meTpntpB8OqpLcLCVdvnIQrMCWKGniPuDHQR2H9wii3vo5G9i4oNxZvQHGkg23KnskIq4bcMQQ3bs1iZd5DENl78K0tqsL2S1yho3KsZ843+tiCQinTfjEC3HC99jceH6fWzhPoJCz2cp5w0BTkwNZXotoIRz1byhnPJVIR5HwyltpkLAKO+obJbhVyssHWbuCfJFI+bQ426Xb2QTJ+UpoYcTBpN1JwV0Uyq5zNU5wk4SjsaR6s9yehh8Vr5gMFc87A45voYUE6XE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that all caches whose objects may be allocated with __GFP_ACCOUNT
specify SLAB_MAY_ACCOUNT (or SLAB_ACCOUNT, which implies it), stop
assuming any cache may be used with __GFP_ACCOUNT. This avoids wasting
the objcg slot in slabobj_ext for caches that are never charged to a
memcg.

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 include/linux/slab.h | 16 +++++++++++++---
 mm/slab_common.c     |  8 +++-----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index ad645967a3ee..8525e70eaa76 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -201,14 +201,24 @@ enum _slab_flag_bits {
 /**
  * define SLAB_ACCOUNT - Account allocations to memcg.
  *
- * All object allocations from this cache will be memcg accounted, regardless of
- * __GFP_ACCOUNT being or not being passed to individual allocations.
+ * All object allocations from this cache will be memcg accounted.
+ * SLAB_ACCOUNT implies SLAB_MAY_ACCOUNT.
  */
 #ifdef CONFIG_MEMCG
 # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
-# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
 #else
 # define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
+#endif
+
+/**
+ * define SLAB_MAY_ACCOUNT
+ *
+ * Objects will be memcg accounted when __GFP_ACCOUNT flag is specified.
+ * Requesting __GFP_ACCOUNT allocations without SLAB_MAY_ACCOUNT is not allowed.
+ */
+#ifdef CONFIG_MEMCG
+# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
+#else
 # define SLAB_MAY_ACCOUNT	__SLAB_FLAG_UNUSED
 #endif
 
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 193b5a03bc47..464695504248 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -367,12 +367,10 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		goto out_unlock;
 	}
 
-	/*
-	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
-	 * may need to store objcg pointers for objects
-	 */
-	if (!mem_cgroup_kmem_disabled())
+	if (flags & SLAB_ACCOUNT)
 		flags |= SLAB_MAY_ACCOUNT;
+	if (mem_cgroup_kmem_disabled())
+		flags &= ~SLAB_MAY_ACCOUNT;
 
 	/* Fail closed on bad usersize of useroffset values. */
 	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||

-- 
2.54.0


