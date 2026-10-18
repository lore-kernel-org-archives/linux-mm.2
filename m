Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E981CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 02:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C2A16B0088; Sat, 17 Oct 2026 22:34:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 073926B008C; Sat, 17 Oct 2026 22:34:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA4436B0092; Sat, 17 Oct 2026 22:33:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B41556B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 22:33:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 81BA71403B2
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:33:58 +0000 (UTC)
X-FDA: 85334176956.09.3FB7D62
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf16.hostedemail.com (Postfix) with ESMTP id BDFFD180004
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:33:56 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=raohCYNg;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792290836;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=HeSnSeSZP+b+6MzP6ewtTRyYSL3RxjlUFlHftt5R+jo=;
	b=RaoSslEBay341/JHhnGhhpcPgwmbXe8mJtIMtfjU7b89UfCbHMMLvK1LMhdgT/gOSMUViX
	LabQ5UhcIwaiYKjV9Py7bxDdOVlILCulrFqjFK0au53gcPWPTaa3pBAbcXbg2amI5sHMeD
	Mo+os3f02RX3vX7WqSgWfRGYquRUvYU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=raohCYNg;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.54 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792290836;
	b=YlIY/aFU7iriFVZubMbO4DaIkgyBP2rOXZAe2Y8CS3mTjp58gXhxvNjHOHBO5iZJk8hUrs
	ii32oKBkC3pfy+jv0eTopyg+kCw1zwywhyNVkNnM9ZasbVt5caikYvC257hQ/9YG0Dy2ga
	U8zHL+UWAt4tNqJG5P2DBbWd9Z7AB5M=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-91b8306b9f8so17001396d6.3
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 19:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792290836; x=1792895636; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=HeSnSeSZP+b+6MzP6ewtTRyYSL3RxjlUFlHftt5R+jo=;
        b=raohCYNgU0Rbu2btEno57kLM9oEZYOmCRG5pka6frUQKSFg7QXJ+6Lvi01RBzytHke
         1NuNPRszNEJv0tI0sjumnDO/eVlUBH+xTZtQWOORMD6lQJs1ccaKGdFkKxSYWnfZADhx
         8Ywc+EbFrHQ0nPjCDpUbf9RKmTZGHtbzmugetfrBpGLJMBXaUS1v64M6ssu+AgP7SrWd
         jUQj1M9iqHEtxzWxUvKgc92CiTb7anvkGQ7HteoYdZdnAYw2TzduxI2zLCtlws4NQT0k
         gD2C5g5f0C0jTg+pEiFy5QJjoIS3FaMQ4IExZAUyR7JTqG4g3VQ9NMJg+Ika0aQkOxYB
         lq+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792290836; x=1792895636;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HeSnSeSZP+b+6MzP6ewtTRyYSL3RxjlUFlHftt5R+jo=;
        b=p23y8FbFQ2h2iJJ0xsCwMurmj+Ico0jdmUQtQCzfRhQbcacbTt3ieB/Tcm8YXZcy1C
         G+l6Uy8p/+Xqn6+dLm2tQbD2xExxaDun5asVZmXZWLi/UfFkBXCuGyraaFOz6L429o6d
         eGIYCaVWYkJUCQX29h023GiuRlC1cd+iSlbsgALTazmp37HutnpvxTXB31VO5r/x0I5M
         TtfjcFk7gknQ1cH8JAj/t3TXkVBgp36w/tptKH+JukvcMLq8fTC/Imkm4e7u2oQwe8X8
         Jov1wL9pGcb1drCPLwWJ5BZjzMPQBfcxgoZ1R/v01ltKd7krux1Xc5q0yZro46cuEuK1
         S5Qg==
X-Gm-Message-State: AFq9FYJcIKxts2ij5a5OefG+j+jUWEw3GGJ09UChKdfEWmd49nzgZbMb
	K/TEGBBPEvMIsUlysiA3fIUVp2q+ghXlfkZRCW4PkcY7LlTSI6zJdRgYuovVb0q0gpFyI2GF6vL
	Cw0Rnv94=
X-Gm-Gg: AYBFou1GgfkndjQhmRKkeW2I29rCZMpIrTlj7+D3S7vVxiRL6W8u/wCW9ooNLn4vDSb
	Nk2VwF/x+8OZwYWXFXzxI0bgo1euzwAhmNgFNuZ5DFthPb3UNi6POjTuNI0BazGtuYl1Cw8Lx4g
	gdIAWEaVo5h7nr79DSnf5H0lA5Yk5F+sWe8vI5JWj+WcGZvW3LaJihVhpJE73NCtLvISoCetSLq
	AZ5o7lVABNykS4lS5dmQ5OvJqquA+l6lbRAP1n6bu+0nJAgAJTSX3CAE66MHbaK/hDi0pAxz+le
	y6nCdVcBFLdtp2mXPZpD/fn0iA+4iJzk4ajGTwbXn9JGeP9O0A1IUYe46247Ch5VD89Bpn65bE3
	GAoK9+K6QwxokUhJ8HYBSwGKJFn4jo0NxFMbiHT0p0uQgOvtTCfeF7DcoW1dglq5iKa8FiLeT9m
	UF0GzbGZpu7Wu9/7rtY7V2CKPujsL2tMLrRsGy/kNm8UdiZ9dtP+aRlxElgTJr0IELZU7O4GKAS
	Sg0+0aphEowLjcICMOdqi5sgRjaqEhU11tQ8uFDu0Bql4XQVeEua1CLDcsi
X-Received: by 2002:a05:6214:2a4d:b0:91b:5d39:e13f with SMTP id 6a1803df08f44-91bdf517971mr74943116d6.52.1792290835889;
        Sat, 17 Oct 2026 19:33:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91bcba473easm61705926d6.17.2026.10.17.19.33.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2026 19:33:55 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	pasha.tatashin@soleen.com,
	mhocko@suse.com,
	stable@vger.kernel.org
Subject: [PATCH] mm/mempolicy: apply bind policies against the scoped allocation zone
Date: Sat, 17 Oct 2026 22:33:49 -0400
Message-ID: <20261018023349.1697434-1-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDFFD180004
X-Stat-Signature: bm88hmjpqu3b4s7n8ztjitred5awyfus
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792290836-791673
X-HE-Meta: U2FsdGVkX18vg1dDhFEUcZTLAS68hWUvM930F8ZQ+O/Atqvd1lO9dKcOT1qbIn8A2+EyafLxqtXqshzR98Ky/gYY3razzow8+xUbEqpzz6CQH5ZH2IMzjg3uxCbhH+SCAs+kgO4wAzVFC7MSHdDcq+kX2U5cFJA8QKhPxO5fGaaTg7lYIz2ftsykDdz2YiXDx+w/ndnAW8quPHVojiVfU2mE6l9QIn54FzMAC3J9pkzop1Mtvfaz7ATlZTkiKGXu8LGe/xE4yECYREND4Id8SJq2OLB+pXPm+vcYtsADsPlH8yknTlfPDHHorDdSOOa2AIXYUMR8blUdzICfp2ktFxde62TmMp4+9RxiZZAoR9Y6nD9sEhVv85qWfkTzXgmfKs2FSzVcykTp+5rPFNMYKUNp61IRD9kwzS07cpAHyieaDLc6odty50xio/qwTPg8IgwiYq8U+R7i9SLi4I7Q/+tzXcxbs0q5WWU4z+v4IC1P1csPP/LnKTlZVLpGRYIjcYLpgnrw7YCcOxGEo9wJ5JSQDcPdrqzYCwsGCNHFvnlhyN29xAANwdHHT6AhLZtGmg5ZEPh8R69togoLRAX2Jlq0XaTEssz98J3tnDZLbjWjIAOd6R5AdT98uoEI23GWk7GIdCroAtHlC7S4WtqKd1RgryfOi1iY8EjTBcVR7qTJ9q+xheROgzWzR530uwVsvcNZ1fT87t5ihO2wwkkfg1o7wEVZ6ZgrGYip9z142djxFkYsOFyJExr9rgg58zjhoBF5o9BcU7WyisFLWzF8EZKPOykKWSKegpWyeUdeODxnXh14YEFsX+m19F1QDqJoRPhslEjtfxjoARVasgVEzNfM40GBrbdqMZ+KPDJSCpiXbCXqoF/Car+zYWSB/L25SpjUfxah5jPc0VDla3VXvSAysw/4FFcJQqfWjrnCP0sYAhZKTvAw1KhcUZWVDZ2cmOV44o+iEPZlSdcQvBw
 lj/ErIwP
 MeTU45JbWuXGJAhWTrmgTij9yz4lrKdTjzMn3Av2rTDzh7NuIch6+/L5JSopudBnTFPDF51YGfr9v8R+J+6k6ptk9z25uT3lOkXHQP0roDYEXpxtasLuFo6Ywk+JpyeoKfKhm8kLuMNdsi7EVASbe60KisoXWp89mOoH0s18EJjdC12yUdfHmaVs1XtXlkn4Aceptw+k828FKZ8bF+IHpD7il4z9Ykr+6TBsE+WBTZWpz7kK0QoqmZLaIKRAwt6dZ9BLUmcAUgX4bP2gLbSjMjbhBcUnjGRiCGed33uZp5waZCMRngq3ylNhbJwXhE2ELe7aM+H0Tq8IZMY6Cb2b6UyEaRb+X+4EzHFFzLVM++pFX78MKcrl8MtvqGSDdky2CTNbJd0cdbbcVMjlGP77heCLK0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

QEMU fails to start a guest with a VFIO device when guest RAM comes
from a memory backend bound to a movable-only node:

  vfio_container_dma_map(0x55b1b1317800, 0x0, 0x10000000,
                         0x7f39a2200000)
    = -12 (Cannot allocate memory)

VFIO pins guest RAM when the device is realized, and the pin faults
the pages in. io_uring fixed buffers fail the same way. Faulting the
range in before pinning lets the same pin succeed, since resident
pages are migrated off the node instead.

A long-term pin faults under memalloc_pin_save(). PF_MEMALLOC_PIN makes
current_gfp_context() clear __GFP_MOVABLE, but policy_nodemask() tests
apply_policy_zone() against the caller's gfp.

The bind keeps its movable-only nodemask, and the allocation finds no
usable zone:

  page allocation failure:
      order:0,
      mode:0x140dc2(GFP_HIGHUSER|__GFP_ZERO|__GFP_COMP),
      nodemask=1,cpuset=/,mems_allowed=0-1

  Call Trace:
   warn_alloc+0x136/0x150
   __alloc_frozen_pages_noprof+0xed8/0x1720
   alloc_pages_mpol+0xaa/0x170
   vma_alloc_folio_noprof+0x65/0xd0
   __handle_mm_fault+0x137b/0x1ac0
   handle_mm_fault+0xa0/0x270
   __get_user_pages+0x250/0xfd0
   __gup_longterm_locked+0x116/0x870
   gup_fast_fallback+0xcfc/0xdf0
   pin_user_pages_fast+0x47/0x60
   io_pin_pages+0x9a/0x110

Base page faults fail with -ENOMEM.
hugetlb faults fail with -EFAULT.

Check the policy zone against current_gfp_context(gfp), so a pin-scoped
fault falls back off the movable-only nodemask, like any other
non-movable allocation under the same bind.

Tested in qemu with a dax/kmem movable-only node 1. io_uring and VFIO
pins of unfaulted base pages and 2MB hugetlb pages now succeed and land
on node 0 (correct). QEMU now starts with the same backend binding.

Fixes: 8e3560d963d2 ("mm: honor PF_MEMALLOC_PIN for all movable pages")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 70298fded1b4a..0884c629670dd 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2302,7 +2302,7 @@ static nodemask_t *policy_nodemask(gfp_t gfp, struct mempolicy *pol,
 		break;
 	case MPOL_BIND:
 		/* Restrict to nodemask (but not on lower zones) */
-		if (apply_policy_zone(pol, gfp_zone(gfp)) &&
+		if (apply_policy_zone(pol, gfp_zone(current_gfp_context(gfp))) &&
 		    cpuset_nodemask_valid_mems_allowed(&pol->nodes))
 			nodemask = &pol->nodes;
 		if (pol->home_node != NUMA_NO_NODE)
-- 
2.53.0-Meta


