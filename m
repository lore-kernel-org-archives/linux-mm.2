Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A982CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:41:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97FB96B00A8; Wed, 10 Jun 2026 11:41:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 957386B00AA; Wed, 10 Jun 2026 11:41:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894766B00AB; Wed, 10 Jun 2026 11:41:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78B636B00A8
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:43 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 21D201C012A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:43 +0000 (UTC)
X-FDA: 84864418086.09.BB3B6C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4DEC82000F
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:41 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jG++jPB3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dSB8ooC+6hgvQ0d6cKYfHgJDcXeMR4283Uzll9HAga4=;
	b=a5FHJbWloHij3iHeu1pQ3HoVL6DAx7bLeBpM4SrUrcjalJn2jfmLh/u7cGwrYVOMuk5YKn
	6WBaxEBn8QEArofnDt7bx2N0ndJq5SzX/2sfcJqaQzY8r9WWAotXyLbX/gP1/Yu4a5GB2Q
	wxp7IqWHS6q1Yza3aDNiBkE+Epx3WjU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jG++jPB3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106101;
	b=U+L1Ppl7j63qOHcrg2yC6bfDwAZxWR/i/A1Tv9aiG7UK/RAHAWGUjjer6zzvBMrwDrsezB
	A5iwrOxFnHREAWQkg5Kc1MvXHtS+3TD55+fRnFwlG5jv0Jr6gp3S7YvyPio91agMo6hSZ6
	gOeVqrg2v7D+vlMsM0ukIY0XXxN/If0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A77040390;
	Wed, 10 Jun 2026 15:41:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F39C61F00898;
	Wed, 10 Jun 2026 15:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106100;
	bh=dSB8ooC+6hgvQ0d6cKYfHgJDcXeMR4283Uzll9HAga4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=jG++jPB3VG5I/EtNtf62Ed1ln6osVnnbU74LV3nqK+1LFuUZdvgJkQWVzMpx2G0fI
	 zqBZAW6VeMSMQ4SJQ7zsDtD+/gXWx2wA9oLWbOXRivXk4kuy3rLbbssxonPu/bixaa
	 BbpMzgfNK5YKTbkxlA531Z0m5IlAWev7ycTLGp1qthHpEhRTIG2e+GVy5pN1RE46Hu
	 FyugsmjTgtYeZo5BOVRn92SXFEPLPKyQuIO2Uwsi05pkcC9eb7niNP8AGMFFNue4bM
	 SMs7ocwMo48fAOM4EN0ynLFA7E/bwMslb5/DnulvwOEtq6ZD5bXC7SpvKClLHcfUoK
	 fuh8YJhSRzmJg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:13 +0200
Subject: [PATCH v2 11/16] mm/slab: allow kmem_cache_alloc_bulk() with any
 gfp flags
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-11-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4DEC82000F
X-Stat-Signature: huhrpzhzdaae53r5pnc18hng1muq79g3
X-Rspam-User: 
X-HE-Tag: 1781106101-53109
X-HE-Meta: U2FsdGVkX1/DdpN3jGhW34ZR2qo1kaZCkqJABp8CEDt4AXEVUY/DFVjYIaTIq4ZDA5Eicx/XFnq006qwCmBqgvEloyjjNx28Xf0DEW+AGplipXHWjPuV6A3LqqHUrsBasFPD3d/J2bSP6MkYgYpDyQ+Nhaz8bH3/nPNxZtUA5PTkr4zgpvIZA6TXhMZ7veJs5azCYqeeUnIMtQbxoQ6xFbJIHHWC9UjKVvp6YyXnbjUcGnaZ5UBGiy/Bb2RjB7AbmlUnQOckE4ZqryGayXedxqwN0NpBKWb7c5mIlnZ2jsIsskMp4nTj2uHCjAyTKsmFDA3vrRoUR8lNxsYSmNePyVCrral7UZpvevn+9i9x6OOC2VsveLEe8QWJLehI1z1qIi+60HvADabOCPbsxV5sM7UB2hxMNLIGiEO0fpVVPkGMfFpJscEcFR1pkjPXUqFxa03FumjAQ8qChCt6qixv933wE3yEJXTKfd5Epx84RVDbZq8njtnCwrz7LnJ3B/p0tiH0fB9iygt7gzFIYcVE/y8Gh4YrOBSWdejNUPDXaBtl3V06u9E8A+45XTHu7tpGbyAKsdQAkSjlWtku2EXDvSrOjm1G6nbCo+G9j5d33A09mrsq17Wi1DCWrE5wTqh7HQC4alt14JkvHF/tKPVZwooC7u1u88K9ezoIcRnU0LqfJCo5PGVgXLX9Xslk0Lh2iWXOPBQ79V7SRgCWeYEsHQuw7E2EWdzWcH2lCQVd817SOxQfis6/UArtUT/yiGYkeMsUTO0+ra8Z9udv7xIBoD+5QVuU8FLINC5o662zQuHhwdHOHh+uf3/n3SxztH9GMIzmsiJ0rLPGVkyMIIlLgAn7cEegvxf/ApcNQc1KqYl/k32UTM3sc+viBQOJionMW4NXCi1EhsUadJAUNkL9CpfZIHSIsnwmH/Eupc8IWZ/Mw8s9Ofsi3jbynOfmIGbfceSAAP340wCtpVhriMn
 QgHxGrkc
 sJd05frmZfzNBMeT4Qwqlgm/NNoigChEg7fag4zcDnkM2L9RE6Fnvw5QNZZGejk55sdqTHC/W2Onkw7drOMUSaxKcl0Nq3zSKCr1+z9wCofVxkia29LGsi4kYzgg4qt2nzpGAvgozq6SrMASGXFXsBeA6lVJqetY/64id2Vgk/bVZb1nY5skte1erMjs7+syGy/2e+Poho7T65Eg0SJq4cRAl8eF34lWYiVbG5/UkfYaGxVceD1OaLmLzlg3GNCCpcOW45OIA09IbJPx9CVt7OhmyENWZkJKVh5EGOUzYLb97tbE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The last user of gfpflags_allow_spinning() in slab is
alloc_from_pcs_bulk(), which is only called from
kmem_cache_alloc_bulk().

It turns out that gfpflags_allow_spinning() is not necessary, because
kmem_cache_alloc_bulk() is only expected to be called from context that
does allow spinning, so simply replace it with 'true'.

With that, we can remove the "@flags must allow spinning" part of the
kernel doc, as there is no more connection to the gfp flags in the slab
implementation.

Also remove a comment in alloc_slab_obj_exts() because there should be
no more false positives possible due to gfp_allowed_mask during early
boot.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 0b9974bfcb24..ef457e07db83 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2171,12 +2171,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 
 	sz = obj_exts_alloc_size(s, slab, gfp);
 
-	/*
-	 * Note that allow_spin may be false during early boot and its
-	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
-	 * architectures with cmpxchg16b, early obj_exts will be missing for
-	 * very early allocations on those.
-	 */
 	if (unlikely(!allow_spin))
 		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
 				     slab_nid(slab));
@@ -4867,7 +4861,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 		}
 
 		full = barn_replace_empty_sheaf(barn, pcs->main,
-						gfpflags_allow_spinning(gfp));
+						/* allow_spin = */ true);
 
 		if (full) {
 			stat(s, BARN_GET);
@@ -7333,8 +7327,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
  * Allocate @size objects from @s and places them into @p.  @size must be larger
  * than 0.
  *
- * Interrupts must be enabled when calling this function and @flags must allow
- * spinning.
+ * Interrupts must be enabled when calling this function.
  *
  * Unlike alloc_pages_bulk(), this function does not check for already allocated
  * objects in @p, and thus the caller does not need to zero it.

-- 
2.54.0


