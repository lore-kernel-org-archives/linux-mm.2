Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4179E60A2615
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fSTsVZbL
Received: by kanga.kvack.org (Postfix)
	id DAE3E6B06E0; Wed, 21 Oct 2026 07:47:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D85EF6B06E1; Wed, 21 Oct 2026 07:47:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C754A6B06E2; Wed, 21 Oct 2026 07:47:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A139E6B06E0
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:57 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A2DAE16052F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:56 +0000 (UTC)
X-FDA: 85346459352.29.74EB99D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 07DEC40002
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:54 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSTsVZbL;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583275;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FdNzDMyikUDkRQM2Yx/R+UlgduqMmo5RYSj82aLvC8w=;
	b=PKpmbU5H/hvaBxCxBWvBOlMfMTx8KmA+D6zCT6/wOLckBRTcGrK6xSIjtuaQ88jZv1M7VK
	Lm9EmV/ykfP5A5SqTgyuEtSGfbDKZE99cH6LjCDgkQRrLmAAqM03EGMqK+DyBRkYC0lxtJ
	HXjIMsGt3lkvy1XNAfJrQQIpTM0jSAE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fSTsVZbL;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583275;
	b=jtMPPa4mb7cBT8/ZYXNy4rYHQBOop2NV4jigbgKOIsNvPbPuf0ozMXl6XOP/Y1cAsEnjBY
	cicPT9epLAFCunyrt+DTWJbHGOs8KCUHcmtL5HHU0nLinRere1sTVUnUkuRVN1RREZLWcY
	OsRxUzVhBqscPQG404FwrVRtwh+wEUU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5A991447C1;
	Wed, 21 Oct 2026 11:47:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02EFB1F000CA;
	Wed, 21 Oct 2026 11:47:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583274;
	bh=FdNzDMyikUDkRQM2Yx/R+UlgduqMmo5RYSj82aLvC8w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fSTsVZbLq+oG9k7aYHjUwtPMV2IMdRjBz/QrEGiTP+glW02RmmZw163JDRDdGuzXG
	 ywJ1FSKJMY2U+wwwHaYftuUZPJFEuS+rwSxA3qjefkUKmt85gQX5cG+G6pO9lNJ98H
	 ZD611ggfnEzxeVeI/KZr/eowxy1lXMgJEP6Ktem733QZ7eKIwIQcESDMaVeROgqNxu
	 axrwIZcRoZLJpLln5ZhrCy5MDuufEYKyqgX7r/bcohNhL8/zAnDke1oQkn9JeFAir0
	 jZ5NkJECpu/2s80E+IxbA1NYUZ+Tu8/sRif3MMhZ26ifDHLj4eFQHoiAH/GG6CSL8x
	 MMe8xKQYEaOhA==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:49 +0100
Subject: [PATCH slab/for-next 08/14] powerpc/mm: specify SLAB_MAY_ACCOUNT
 for pgtable caches
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-8-096800aa3330@kernel.org>
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
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 linuxppc-dev@lists.ozlabs.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07DEC40002
X-Stat-Signature: azejeiut3hk7hzxetw174qb9h4hy6xwh
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792583274-285953
X-HE-Meta: U2FsdGVkX18qyFGk1+Gm+6mGPBY3REwKlPN2603CQfESyBmvTRUaggrTJRf2l9TRart7q1epS9dMHxzIMbntgWsuB7iugqsvu9+PFIBLAwZzWGefqxPbnLrvMM7zMSo6ZWz1cLZOhVBPAl1C84NlEVINOI7DwGDMh/+IbCDcVoYPqSKIZodIovrHOK6vrYcRwGH9z/fTPfXozjgVD1CUOl71xCw7kVLt4RU86YPV6SrOaIGlrIRKkQYKvqMHOe3Vlvy0oVn9X94jYskf5xN38LW9VXYT2JGTTMh/lPxuaZ1tzH96JuEP6azxNPTBX5ragqNnWSdVayyN2J0W+eX7H/P/NcKdsryeTxP6GE4w4zybyPfGWuQDvOpcUZc6SS7qANzHILWkldPJodNXYW2rykAbw2DYK1R5SgBaUNCv9Tqe2Vol1V8M5So6h20KN/Hc3jprQuG4mAohXLiIXkJqw07Av8EOakvbmFl8WqelZVtbShBUOrhWQUwEnmuyMh7biWC6NadiW3HqjSAPcaw2MCW/Ubg4Mg5aChXcKelMnwEj6nYPFCG7/lXk56HMQ1lLsj2mVYxrxYZrETWSe0FC43SsCu8CwiDa0mumpu9lNraCgcRWOZ3kRXXm2EKrTneE976CgitXi3qlRc6/h2XN36VwWVUc86Y0zOH+ZOKZRdWdiyIhqILbRkmvxg5eFU3PeogmTbJkMw/F4FcX800IS4rSQM9q09S3wU21qDhSsHLYYtEe92zV8MTZh2s9fQ3rg9D0nQm+qHPK9MYGQDw1KIqfGa/CE2WV4IIXkTX4rEEmj+qI4FXSBjxE/jrVWaLo+pqZO6giOGSmO2FdG1RqV4BLtT+j2Uw3/vS6IgYmLqhnjxwI9ArVnO1eyagY9XUHVTI41GCTjf3bOG3IX6Np9UcJfMt8Ia9DgxgJdccucUbVJ7MbLIefcgR639WbDT3m+Ie4gD8YEo3ZsQI+YuA
 J19su6Vp
 6tOhvgxxhzk1nj1qpQF6D53XweP7RCMAX4HKIfpRVOXYfGn2OWtoCHsPdKOfEMtxXwguo1ySYJ45FsXMQBqI1L/lCAo1JaAcPQTr0OQh7KJ3gkC8QwmM6r/bfBbcsFnzueDZ10++RQyfQJpAxBmSMpfACkTmPwxVJmmHfg0Tq6vmTL3Ll3WwkwRr5puNP/vFY2Mdi0wqrAMO/Oqbf3C1dKPQZ/WcBdD7pr7yeZ6+TN8pU6LjpfoIBCHIJHu+YiJwMg8NXB0TBZ81JynDKwqhvCJ8amsXm8uRwN6hkPxml1sT+8YK2hSYdFKKWKk7hW8DwK3B0b85iUebG9ZEG62S3dyI2pJFqk4V6hlrOUdv2QRSkNO8OKrIlWMfZn+YLYAgxUsjKSmE6DRjwiYs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

User page tables are allocated from PGT_CACHE() with
pgtable_gfp_flags(), which adds __GFP_ACCOUNT for non-kernel mms.
Specify SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path: copy_process() -> mm_init() -> pgd_alloc()
  -> kmem_cache_alloc(PGT_CACHE(PGD_INDEX_SIZE),
                      pgtable_gfp_flags(mm, GFP_KERNEL))

Assisted-by: LLM
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 arch/powerpc/mm/init-common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/init-common.c b/arch/powerpc/mm/init-common.c
index 745097554bea..72dfcc559630 100644
--- a/arch/powerpc/mm/init-common.c
+++ b/arch/powerpc/mm/init-common.c
@@ -140,7 +140,8 @@ void pgtable_cache_add(unsigned int shift)
 	align = max_t(unsigned long, align, minalign);
 	name = kasprintf(GFP_KERNEL, "pgtable-2^%d", shift);
 	if (name)
-		new = kmem_cache_create(name, table_size, align, 0, ctor(shift));
+		new = kmem_cache_create(name, table_size, align,
+					SLAB_MAY_ACCOUNT, ctor(shift));
 	if (!new)
 		panic("Could not allocate pgtable cache for order %d", shift);
 

-- 
2.54.0


