Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 806C360A2617
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FeIwbXVa
Received: by kanga.kvack.org (Postfix)
	id A03916B06D4; Wed, 21 Oct 2026 07:47:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B4756B06D6; Wed, 21 Oct 2026 07:47:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C9D46B06D7; Wed, 21 Oct 2026 07:47:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 699F06B06D4
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:31 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5C04EA049C
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:29 +0000 (UTC)
X-FDA: 85346458218.10.06478EC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B566B180003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:27 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FeIwbXVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O0NXh8hdG+uzuvBEcab3bue23KeeKcY2/7YypkLouPE=;
	b=H39fRl1/2NXZiM5nT74p2+xEi3hE3Ulrh9RLPQtLVdi0Ul3UQ9bzb9pAszALBfvYfJlc0j
	A6CfI5foWZbjQli1UuiY/OauzsBnmx+K50XuQ6IFzTY96n9JvMsNDqUzCzdQ+52DvQ3xzu
	qdJRmBO4BiPtcLFdgg+lRT8tbcfRw4I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FeIwbXVa;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583247;
	b=bksn1shb2YrZlmBiuXQCgnDgxpOo0E1XYsEGa5gXOAIMBPProBfDjzXppRsmCgL2QqaufA
	3cIVHckflwV8tjUA6CmMCYQHQs5SbXlgVhPN+weT8uqr6jBnOaQRjhTOtAoeP05mnD4rK4
	2FXu40Z8p0FLYlZesy9QWtsXa5USaY4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DDD9A42B11;
	Wed, 21 Oct 2026 11:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 392971F000C7;
	Wed, 21 Oct 2026 11:47:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583246;
	bh=O0NXh8hdG+uzuvBEcab3bue23KeeKcY2/7YypkLouPE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FeIwbXVa4VI7WJv3ok6ERoNwYKIgZ5pQ6nWD20UtkfoA0IpkgcqH8zAE55uqLRb1M
	 G1zxVIw2+vFkKcfs+jnML3y7c+3JP8EiddfweYD2fwQWJn5kMJxj9Z5vjfW+PzDE2B
	 TgARio/GdAS1jgtORs5ufeKUWyijpmLoB1jVlYsj8ACeA+05OibGU9yEE4qWHAMLLY
	 IG4cSaPCVUhI/z7SHyA4VF2+VxS1iFLP1R9U6NvvmHc3/sq8gnNbZk4n05G0T8IyL5
	 goBf7zAacatnIyIWdoUEJ1MNtSAuNi5XW3G5M3cFegppeQMbiRUF4ScWZlURkPpPoV
	 qrKh1YDtjm2dg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:42 +0100
Subject: [PATCH slab/for-next 01/14] mm/slab: allow passing
 SLAB_MAY_ACCOUNT to kmem_cache_create()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-1-096800aa3330@kernel.org>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B566B180003
X-Stat-Signature: 1pkcp8td4qfxtytcxabkycj55xcp7bzm
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792583247-170524
X-HE-Meta: U2FsdGVkX1/Hdo1opvUNc0yC8g2fxw+RD4jegXO5rbThevfKwyzeAn7/u5zbATUhR945gFDIfgZRrkpt68fym3P3GSf76mBhVaoAF47N52nMeuZBV9PcLho6z8+EQg1CFQ/UQmoHmoAeZReuD+gFPs0Ma73TwpWVQylINiDcy3C+gfxnJkda0/GoOA+VTxsWg9gK3L6H3W+SAeiVTxzT9twkDT5YM3iMiwGQlKOWGEJTUI+mZg0NAgeDb5Jhlit2niv5aZq0vrOhOTgum24ZTMSiTzIHf8g6gGdZYMHBqesyV4RR62nGUBnwXw/wmILOCvweU7EYECyGQPHcVgDHVTFlI3J82ZFGwn1BFbxwJ7SB941aA6QBJOxlkvHNPH0dUW6bqc7PwvR0+jWq5DdLKbJK6aO5Tk708ib1qJ0v6ERbdbezB8DEPReu4Z8fGtjyWeOO8ra2L/L1Toqk2yFVvBDWN3zOtlJo8kEhsP4kzu/61Cg97wMAfMCkh8RrNtkjwe7reP4nCwA8Ci4Fie+fptODbyg1ZaOZLyy4ZNVjvvrbLvbDBQbeu43XW7wyq/CqRBHt6ofDCn3niwjGbs9QbYQrgifwk4POxWRMiD4l4iey7ZlIsz+66lmKDmWYg6wHCd5BrIReneC141tQJP1+Fi243N88n+bYFxNyKSTkLp2cZYGt/bNN8zaEGsCcaenbj4r5MZi27iDYHfxQxP55tIGfOOLl+Y81VcTe3tgrz/QhDq16GsiE9huacmgpG0MWm3E39uQeyRnZ8hleWwB/Oup+NBQcDWZWg2y/TrL5ZLh0qGn0ojr97TFDTu+PevH/pXS+LIeD8Zbvz/zuGvJlNZDAPY/89P7IFgLewGtHuLsKjK1mjFfO7g/jd+zu6UQCkzD3cnnzLmAqqJXlkDVeDxlxJzKPq3FtWvK/oOqdiYCFIqdKwG4oRLe4L9gIb49eJRCLBIwjZYHqbV+HXDl
 iNn/S2AN
 /MFRm9aejEZVceEY75r3d3AEkhLL8lSgcn1ZEo+VYYw94CqeBecq6a0qDhl9UNWolDfH+menTIcFtiwWodEYmnD7yOETI+b+5ogvzhKLln8ZMN4GU1e8Pa1J9xODxx5/1ygFGdJcDtbMgAJXzxDHqcAAEnXUZx1KMUch7ZLFUYZwGaaJSuWliZ65/APdvwsBFDW9QsO3RH5Zs4MUGoyrdE68+nyFOIPLuGNqHdlYlnfllW+tW5KVzp32v9sQp2ExbNcfChviAFDXOdVaJy+aClSwzAJe2Lr9Nno6u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Callers will specify SLAB_MAY_ACCOUNT for caches whose objects may be
allocated with __GFP_ACCOUNT. Accept the flag in SLAB_CORE_FLAGS.

Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index e94ac63d10dc..31783311e23e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -472,7 +472,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
 			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
 			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
 			 SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
-			 SLAB_TEMPORARY | SLAB_ACCOUNT | \
+			 SLAB_TEMPORARY | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT | \
 			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
 
 #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER | \

-- 
2.54.0


