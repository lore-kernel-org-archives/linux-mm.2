Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E1E7606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gz+GXDjL
Received: by kanga.kvack.org (Postfix)
	id 1C8506B06E9; Wed, 21 Oct 2026 07:48:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 177FB6B06EA; Wed, 21 Oct 2026 07:48:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08EB66B06EB; Wed, 21 Oct 2026 07:48:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C94446B06E9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:48:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C0DED12025E
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:17 +0000 (UTC)
X-FDA: 85346460234.19.5D94F06
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3119C80005
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:48:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gz+GXDjL;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EjyGHiA63Kg9pRo+xskIrl/3J/aH9iYm9CZHmHbN9Ks=;
	b=UD9qJ302CVnXOC/uE3mFNuN8Dtctr6kfXdIg/fm6jDv0G9b2080Ey3tJoA8rJTq4JLuVkx
	vd/Iv5AmPSpUN4lrR+Ba6QkT/m/5R7D87sdnQqKNax8+31TDKd+fIceNwXMIBvZk4J6yH8
	1ckdyB80KZdFRtrPmNt5Se6t410MC7w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gz+GXDjL;
	spf=pass (imf30.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583296;
	b=A1eG+PmE2kH/JdL/AnJj6Clv9hRViFTTN5O23FvzNs/Vtg3M4wjc7MdKoTULVcoqIZPejz
	PSSFHO/BXn2Lf49PRhdx0HOI3p3w51vDJOTcFNVC57vhW1Rodiv/x/ZTtVl31N/ma7024V
	D7VpPOVi6SxqBkUW/0fLxDsa1rWh3bY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 98BFF60DB1;
	Wed, 21 Oct 2026 11:48:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C95061F000CF;
	Wed, 21 Oct 2026 11:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583295;
	bh=EjyGHiA63Kg9pRo+xskIrl/3J/aH9iYm9CZHmHbN9Ks=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gz+GXDjLutO2S6shUocw0cTgHIwlqLGnY+0JorwJyOhgW7u9stCz2SZl47wxlVLbn
	 lVhxDEsUyPoVkb6j9PiR6gpMylykZHsxTbcRgDa0qhDe7J3KU2tuq/9aiJi3O6RKF7
	 91RveW4SxB5JA+6/X6AizJBeWc2tH3I8n0kBcD7A+7nS6HtfhAdpdWxdUqqH7alFU4
	 LxDyrMh4VGNlnamqhirLa31r6p+22LHBEfgOSoPpusUjlxFLjc/bIbab/G3QXUArc+
	 ySX/ElnrrZLc3ff6Lb1H2KZ1k2IZuKUUIzQp+ikv81t4655Rh0JoMJpyRMsYdo1+Qo
	 BdGzv997QLcMA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:55 +0100
Subject: [PATCH slab/for-next 14/14] mm/slab: do not set SLAB_MAY_ACCOUNT
 for all caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-14-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
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
 "Harry Yoo (Meta)" <harry@kernel.org>
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3119C80005
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: gpynj71gujudj7ds4g1fdun1efzzz8a6
X-HE-Tag: 1792583296-589725
X-HE-Meta: U2FsdGVkX1+yJ4UVSAg+V7PVLAwi2ZQPZF1BTwi0SsSyrIOF1w2Rnrt99DIq1kh8YTh8H+BDX6uWE0bijiRCafiWRfxDcehYPTrjaQd7tmKPWMQQBCuKFK7hH1hjy6FEZFA2eksEt78od6rBvYHm1nRCZqqmda+lBwEeKKGVSYuONHt6cGlNZzpd0JYET+Pv+sSMsy5Ve15vaxTRt55pOBFfxHmcErLiiE/puTHkHGXzX8WdQDPGgPprX8hRGE5irwcCknk+egllP1ir1QCsDmWHzeC6CKF+MAyWLmtgIBNUIP2T6I5FEtRzXCQqbgxxVOoeMn0rYMEMtnEu28lNrDxmBMop6bKW7h7cTiNYAx/FkotnAzsy4iDarIiTUUHWC8Re/o9zyp/5AL7OmtydEd11lnAXNWosK5MNEwbcTqXfaHF5q97IDKBqVVOwJa+s2UMqnv3vFCERi8zeyaCSug4Lpw59ah6v5CPNELrq8UEAI/mZl+kaXxAmCafNCRsrzsgiIf5PeBHHN1TyxHvI9RVzCq0C9GN3a3Q/RUuZ2vls5EAiELDABPSCpca1i+5EXF738LojEV6D5MwjEmFwaZQ0K+kfVXaRVbn6iAAhfNxl0BKDKa/LSWv5aHlxQ1cgsj+AJWJBeqNNY3TwSTIet+MxgrtY8URkMP3DUS0YbMO3wusfFSCzBXohvzBLXtzmKo13OAyoOxCS7I3QbmMiWptgn93qAom0L6L3C3UcdALT+xPbfYHTbX2/lrkaQQTUZEGbIdqxlePHjE8n9xilA03iayaPxW9Aw56ZTyS1V0jOgTSvORL2qRF//X7olvT1E4LNb9pyrlkbAlS8Jd/wTeSqEFs8qoFrSNkykraXNYicU9gq4RFZpHwDA37OZz8z0OjhEzufqkNds7qzd2as93CXUIxPe/bKNQy9aP4Racxa95D01+CrsKyhwPHbpkQO72blZOIftrRKZbE2c9p
 cxYQY1gq
 nat/6pCTj+wDamsbKTj+/yBti0ny0/PaczHltQuqjoEbxMLS3xlSu6ZmAI/NDAKblAgc8uUdiRaqkjyH6hIREOdO9DLy6eIJP+Gqp8cPbSkqbrNObA/0eUUAmQfsVg+X3Mj6fFu8sPYqrh3Asp7+T2gEujYbIR7u+FZsOJMvUknhhHGVQM+ol3hei5Avk6E3r2vfMX6UJCgY6f76MFjTNhMCLeTXMMy+z1RaeyHRHmStDvWUJC7ZQgStZowcFArYAbNJXxuVVegRTB2rQuOxKp+JRUvx8+ArA9APM
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

Assisted-by: LLM # Changelog
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 include/linux/slab.h | 16 +++++++++++++---
 mm/slab_common.c     |  8 +++-----
 2 files changed, 16 insertions(+), 8 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index cda126def67a..d69445346494 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -200,14 +200,24 @@ enum _slab_flag_bits {
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
index e66c0778ee98..c69aac8bb0e4 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -359,12 +359,10 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
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


