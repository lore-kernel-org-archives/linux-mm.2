Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 430BC60A4ACF
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:47:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ABx0n5+w
Received: by kanga.kvack.org (Postfix)
	id 12BDF6B06DF; Wed, 21 Oct 2026 07:47:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB436B06E0; Wed, 21 Oct 2026 07:47:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0D256B06E1; Wed, 21 Oct 2026 07:47:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA43A6B06DF
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:47:53 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2686A807F
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:52 +0000 (UTC)
X-FDA: 85346459184.07.C91E0F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3700D80006
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:47:51 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ABx0n5+w;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792583271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LamOgwOLGcvObJJ6uLyjNnr+OKxJmcO2SWrOkvHa4B0=;
	b=xohMQ54dgH9DremfQLqvudqiQcZYXd+dQho3W3HyKIQGjTMkM9QIobcfsWwRIRHnT58Ld/
	LxNydASEZewE3898/99WLcnh1Ye6Eq1c9ftcdWcB3lSfb97TvDVwgREL/UNC/c2yPjov5R
	0Msso2LE9CKGrMgYkWOYOIhHzd9PvFQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ABx0n5+w;
	spf=pass (imf02.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792583271;
	b=l3RCmpc8HtbeOQbFMhVeKC6z0KztfITEUFm8ECfT7f9nF8G7sy7Oa4Ra93gBiZlQ5qRjuk
	ZjYzBtFP/l5c0IbDh7aTgR4nk5hOAeAZLLzB1I/0SwBI0oGq9laFgsEHJzd+CB1xrIG1gf
	e7C7+kr8RJOf2Y4XyO1jgCb5+/oF/QU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7E7A60D97;
	Wed, 21 Oct 2026 11:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4EE1F000C4;
	Wed, 21 Oct 2026 11:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792583270;
	bh=LamOgwOLGcvObJJ6uLyjNnr+OKxJmcO2SWrOkvHa4B0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ABx0n5+wJXHhNQk6ZRp0wqw4Rw7NF+bXiYQq2SvsBPoBKUDyPS1FKlsineSsqAOud
	 Ao6k/OkSWtjiesySf8tDYRaKmnk0uZRkpiMrIBtr1f2ZkErMR031WCq6j4RvxMdW9E
	 TlL1ttZOyHC6ksfHTx30Mk27mlMpFbUMTGp9dAVK/qVF0j0+sTE9ckvhejDBOOP2fj
	 g5edE9dWu6I9P5Qu8zdos9gI3ACgQlZET6Y0qNKIlglWaH78OpwE8XdhTD/l2cyU8Z
	 uwCY+GDwkDoxGJhOXUQeOP7COA7+6xbWzdWZl02/XKQzVrtVPJcHxnP7SW1o4Rf2aG
	 OXu998Y20Iu4g==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 21 Oct 2026 12:46:48 +0100
Subject: [PATCH slab/for-next 07/14] arm64/mm: specify SLAB_MAY_ACCOUNT for
 pgd_cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-7-096800aa3330@kernel.org>
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
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Anshuman Khandual <anshuman.khandual@arm.com>, 
 linux-arm-kernel@lists.infradead.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3700D80006
X-Stat-Signature: od1x9gfsshxcmxc6jjjp67pnqqr1nbru
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792583271-569506
X-HE-Meta: U2FsdGVkX18rfCh4QeZzMXezCEHAnqwCdxcIRUGzKU705KQAY8YaH8lCJamo1UDcBQyD1r96PX6lBaKLyafYXcU3TgOHqJFOSuV1nanlegm97jRYyROxumBSlK/PL0rp7SbyZLhrAOdqWVyI/3TRsF/EGEP8RYhKDVwOGcRFXZbVBGJPqriZrJc/8SLQ+HM8eRMDrZm3sQ1R/XQa/GP5yhBlOAVHMvorjPfhp8o5lLsXDW8FxopOROGPKLJEFl97GHzy00SKgQMCL6gofugtJ4mMb9zce9hvecXYNw6ttHZhNMCjNqlvJLqj7vk/QsDNEeNMlym2uwzpVMFWr/ToTmkHnWAc263N0lWyz4r5O7oaSVyQfNSyyh6QZbaltjyTPxrlxjbkOh9jClIo/yEgN4Qz2FVe5yyYAOR/lO8xLbM46xS78GSVA//lOox3YpP0j2e87Q9YCchWoHd2RYyV4XQawSHQvweoDc/xpa+0ahZ9fH7hQDy57grPa/mWCEetBxysXh2gz63dy6aX3jFNFZLfFAl2LHiikWtXrykw5HxaABQIT6ke7KDlx1vDe6clHbsEmw38myZQfd7T7cvJ5VeF66ShzhyNvjzTFjn+A70rlEAdl15es/XWi5N4AB+FEDzcPGgavP/Jio4Eq8Kw/N1lNYzf5m1vYdZmLYVDEiuQ2mqsGZeVGrBURKiKL8uSgnX+tC86kVYkPqahBQVH/29rh8GasOjDIdpCk0O9EKOcP46/MJRZOYW7YLkaC4GJY6iwzG5nQygNCimtFzIno5Ozutzk/0VmrUjDHucCYTpRxkxqGpstD4OIqm1KlO7BjaOl7QI5AvDScC/A5x23NDU5vrNWVukFdiA7oxAba1r+23r6GMqWwHR8UT5Du+Gbk6y5syvSRlvlGbAObqKFcNlk2XvjhkGRUEiS5lMsFveOhpi0Rr0COTTzDePSIQq/Xd9e9G98SHxQiOBe/Nf
 6ENp4miV
 Jtq7GqlWp55zeUbzYSY/Y8gvpjQFDg71evHYyoBVbgxN8Si+3L/KJxm1Z8VCxEgtuMAaescE0ekBYz6lq5p6I66kk91JatbeZB/z/2HzQ6V45EjreS2WVaOoUtIiih246i5A/RNudI4JcnNzXoJnff9t0D9GrZSTCW+QWjOlGJHyDNG7KfzZ1SprQzHpkuwHoh7U8KQkjoACtPDF+4s06JZjpVsgIXE4EmF91G7/ZmRrs1stI/LBlle6yo9zmfw38wyWvKEUojYiD378MfEgSLRmctiEKUkUQu1+k7+SjkZdkAoCO8sd781veO7PlSkq42/4jTgR0Nno6aHmHWqOtbz05CVPiJJA55jR2kmzy2z0/UI1S+ifON5dAPuXS6nY1xHd4cBFre3H9hDnSNi+ms/mvBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When PGD_SIZE != PAGE_SIZE, user PGDs are allocated from pgd_cache
with GFP_PGTABLE_USER, which includes __GFP_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path (e.g. 64K pages): copy_process() -> mm_init() -> pgd_alloc()
  -> kmem_cache_alloc(pgd_cache, GFP_PGTABLE_USER)

Assisted-by: LLM
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 arch/arm64/mm/pgd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/mm/pgd.c b/arch/arm64/mm/pgd.c
index bf5110b91e2f..0fd5b90b5160 100644
--- a/arch/arm64/mm/pgd.c
+++ b/arch/arm64/mm/pgd.c
@@ -63,5 +63,5 @@ void __init pgtable_cache_init(void)
 	 * Naturally aligned pgds required by the architecture.
 	 */
 	pgd_cache = kmem_cache_create("pgd_cache", PGD_SIZE, PGD_SIZE,
-				      SLAB_PANIC, NULL);
+				      SLAB_PANIC | SLAB_MAY_ACCOUNT, NULL);
 }

-- 
2.54.0


