Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A52CDCCD194
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 15:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 083718E012F; Tue, 14 Oct 2025 11:28:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05B0D8E010A; Tue, 14 Oct 2025 11:28:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDA998E012F; Tue, 14 Oct 2025 11:28:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D938A8E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 11:28:40 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5EAD411B129
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:28:40 +0000 (UTC)
X-FDA: 83997102000.26.F1F6D8C
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf25.hostedemail.com (Postfix) with ESMTP id A93E1A000A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 15:28:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gN/wTTWG";
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760455719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3LfrRntdqnp7+Z8riKYEbqCkp0MkSxiqZIXsXw6PRKU=;
	b=AyCY/oXXIsrStnw51mN5HTZ4bb5AEEFPYETLJmFk7lvv7hZCfRHGMQgLQ8NDy6j4z8f7s6
	x/uZ9q8qkwxqji8W7yDbyWLjdMf503h/cCgVaH9DJoFPk5Nts7X/VSR6FnlrdIEjvmJppw
	ds2DXYCrns38AEjBUrAsjbBCMPs7Aeo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="gN/wTTWG";
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760455719; a=rsa-sha256;
	cv=none;
	b=UMktC6O6QorIv/fzOOmKJ0MIDtGRbpZzwVwgiyN7weuYj1xWoh1AnwyEQd40cg950VjZ7/
	Ndq57k2vnHMSJIrjYRQhLQjaPvt1Jy1udxt26xQBTs+GFYTrLjh9pW9N2aQuEwXuzGkwm+
	d3OeVgGTWMeWrCbdjEFKsdBwPf1dAyA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760455715;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=3LfrRntdqnp7+Z8riKYEbqCkp0MkSxiqZIXsXw6PRKU=;
	b=gN/wTTWGL9N/luOOdsW4j68R1OpjZ71pxwaSmzY8QKH20jAP2ifGFglkGhFL6+YRWzzyRp
	YzuTakDCxjxTj+eMz/WOaxFF0o370GIkCcjAxMNpXDhJeA0Nlsc3syciZ9KNI5IEZzd4++
	BbDLfbsATBqqetEgJ2hse9wRlW17Hzw=
From: Hao Ge <hao.ge@linux.dev>
To: Vlastimil Babka <vbabka@suse.cz>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>
Cc: Harry Yoo <harry.yoo@oracle.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Ge <gehao@kylinos.cn>
Subject: [PATCH v3] slab: Add check for memcg_data != OBJEXTS_ALLOC_FAIL in folio_memcg_kmem
Date: Tue, 14 Oct 2025 23:27:51 +0800
Message-Id: <20251014152751.499376-1-hao.ge@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nckx6o4wwfajszfcfbk7hei1nd9k4to1
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A93E1A000A
X-HE-Tag: 1760455718-867008
X-HE-Meta: U2FsdGVkX1/Y5rdPrJKo7Qp0VSd51U8gQvOGzAT+LFZNi2VBYZgWSw7P+/Gl3e0yTH5wC9ug+Q2JmT3VaAb0I+oFTl/KD6BDprd2Q+ral/ge0gPH7MxPNAf9nDD3o75oGu8ABlCtZcQY0RRod5TtD/8bPm2uofdo07Me4cTp9GdCYoZQj/KR9NvJnVcFwQnxMezNHTBPSt4N8meXspJsZtBg3YUejX+iLj6ELyvTU5Iwal2fjBmpCtHEJIavN6Crini6Rw0FQHOhcxVET4YzQCbJdeIofp/lokDeiArPEIxfSwHVGfJHWJt8uYRfROIYZuAYI/S8sDUHZBZRXD4c1HZDIB2X38GSWr4c9+Pr6LTXaYg3V3uLLbHrxMPbQPcLnq9hKr713KgGMrO/GqZjBRXcfOPtBeA2LsWrMU+iIfZxxZHACdudHHbBLdZlpBN2Mt3O0sM5pJS1uix1ssC3mHSqyo41B8H4sQuYTbIsoCIEs+z9FBMhJAeeTujyNTlp8w7W/BvSfYx7x5kJQYbIdTzd4Iiux7WsMa2Z3GZvfzPb4IxBB1hwLx4UM/aSgTUMx0xSe77kH411CdX8EYi1WO35jR74iJhHnSFg9oZaTKNu1fmfBwHilTLQghapv4fmF/f7zqoKd5Qz6Vt2aRGf+V0Ek3NILPw9rBdZspVUbsUIFzXuFRHeG66UtEvLjRhe3CJVwTYNJTK2fLikxiwe12g5hroXNRiQoCd7AKTx4KSs9FbvHulDRuQLwI7Etl8/+QeGd5MRKj1KeXhUDXgP8K3/FX0Hy/N0Yo88jSzQinemmn84kBhTO/27ZYaxgHa6YU8uNMcoxIfWdLfY20/l0NGsODUGUsV4psB/mravmbNkpmbtzajjdKy7RC7X4QNwmhYLsaegiFbOdkrwDaDrhkW12YfsmQdZvXQtdNCP0zIm3Lv4OQDMAkp2tOn0xWmUVEijXDFmHFMFa67paYM
 2BeLkt2D
 Pz/hZ4aRm2USuabk4UgQT4O0IDXUd/kNytTfypsVHVSnjRmAvdsWahA+DiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Ge <gehao@kylinos.cn>

Since OBJEXTS_ALLOC_FAIL and MEMCG_DATA_OBJEXTS currently share
the same bit position, we cannot determine whether memcg_data still
points to the slabobj_ext vector simply by checking
folio->memcg_data & MEMCG_DATA_OBJEXTS.

If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
and during the release of the associated folio, the BUG check is triggered
because it was mistakenly assumed that a valid folio->memcg_data
was not cleared before freeing the folio.

So let's check for memcg_data != OBJEXTS_ALLOC_FAIL in folio_memcg_kmem.

Fixes: 7612833192d5 ("slab: Reuse first bit for OBJEXTS_ALLOC_FAIL")
Suggested-by: Harry Yoo <harry.yoo@oracle.com>
Signed-off-by: Hao Ge <gehao@kylinos.cn>
---
v3: Simplify the solution, per Harry's suggestion in the v1 comments
    Add Suggested-by: Harry Yoo <harry.yoo@oracle.com>
---
 include/linux/memcontrol.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 873e510d6f8d..7ed15f858dc4 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -534,7 +534,9 @@ static inline struct mem_cgroup *get_mem_cgroup_from_objcg(struct obj_cgroup *ob
 static inline bool folio_memcg_kmem(struct folio *folio)
 {
 	VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
-	VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
+	VM_BUG_ON_FOLIO((folio->memcg_data != OBJEXTS_ALLOC_FAIL) &&
+			(folio->memcg_data & MEMCG_DATA_OBJEXTS),
+			folio);
 	return folio->memcg_data & MEMCG_DATA_KMEM;
 }
 
-- 
2.25.1


