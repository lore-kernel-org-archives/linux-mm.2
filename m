Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F0A3606A335
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 20:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MFqTmVod
Received: by kanga.kvack.org (Postfix)
	id 7A64C6B05B5; Fri, 27 Nov 2026 15:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2936B05B6; Fri, 27 Nov 2026 15:12:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55B576B05B7; Fri, 27 Nov 2026 15:12:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D565A6B05B5
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 15:12:50 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 543891A02E4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:50 +0000 (UTC)
X-FDA: 85481997300.21.6097647
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 961D71C0013
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 20:12:48 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFqTmVod;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795810368;
	b=eLZ8389SiDOE4udPd4DV5GhcmRtTt+plLrSXn2Bngg2m8JdC4JDj/s5Rbcyq8oLImxp4S7
	Ola6m0aeweptQzxPE9lLut9tez2Gsac8EASOUit6v9vIXMatyf5I7C2FT/AcTiHcsJ6vq7
	eZBoTqtjgsWvIi3decn9le7tKIkanl4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795810368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LYceGOXzN4hiBJZC1Gl2vPJRF3wXxgb/h1evZjNGMfA=;
	b=so9l0KBjniYZHPxK8ERKprapfZLfm8dEIhGZBbVyitO5ylmku8R4P9S+ztsFcE63u4RJhR
	YEHxEHfUomdRWBFScH4sBwInIfapJomZdO2ncrC35dZ/Drw4cWwzdI8TEoLwl6d/HttVJo
	TvHGpB4128HruEiJiCHuvvzNKel+ufA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MFqTmVod;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 37CEC620A8;
	Fri, 27 Nov 2026 20:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D5141F00929;
	Fri, 27 Nov 2026 20:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795810367;
	bh=LYceGOXzN4hiBJZC1Gl2vPJRF3wXxgb/h1evZjNGMfA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=MFqTmVod5hzkGn4ZfBotiC8ehNkVALKRz70n+huCUEHtvDSRMiVrEmrYvpgazjr+a
	 o+hPkekFfAWN06iXJTm8uH+SgSvbw46/KaNwJRU9v0kgQpGBQfieb/igf7Lkejc5s/
	 vJ/AEaFQjxjX8mTSU6ZkCJGDjFM1n03TOMcWLAedv4JpwHW/No/zXjz4lljCEWEqlI
	 bG1+SYVayjO1UjiWM+XfZfntV50QIK519F/SiMzLDxgHIXd5OfcivzrJnZcSKegeHo
	 Gcpk04V0GvUSbg2KRWzgx16K3pBS6t8jQjwKDoycGTSzQC8bxfqPdzImcohMBSmBJ/
	 hxZui8HihKu8A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Fri, 27 Nov 2026 21:12:33 +0100
Subject: [PATCH 4/4] mm/slab: clear stale layout values in
 calculate_sizes()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-slab-ai-fixes-v1-4-cf13b6be6692@kernel.org>
References: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
In-Reply-To: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 961D71C0013
X-Rspam-User:
X-Stat-Signature: sg6iip5pmo8echow7taibp15ubaugow8
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795810368-439903
X-HE-Meta: U2FsdGVkX186sYJt4VYbGTrpvLUrsDx5XW1bdMQTIdFILwX8KQT86iKmSHJi6yHd9gJrt8623SVPyrKtyLGpi8D7rc01LM7HONi47ooHViHIcQYBmeFe4b/V5UIdNd3rWKt0aBVB7gq5nBkoWqTWFkxCOIExsc6FizseFy9jS4Y+zgjDJLyEQ2AXiIMZWPHXf71CDaTL5KoVVMhaQpgvQy03yrNDbTQJtNs7Pt4T9vB3A3FL45DIIgjnuiV1+N2dtc70cNdyVDJxpToHIPPE+rOirooO8+pHMWUla8bhdSMh0aTrtn1x7PYqIYLjNduk5ZX+6GICwbxF9y6orcOCaWievnIRldMBpT6KADXBTvrLeAevKUdre2jQJg1hmLSctZq8Q16Mc24p2JiEvccGXtvj9ZYMOGpjcjnxLNaxFpqdtSmQgSyq/DOInXiq/la6OSaABpPUYA9gUS3y3HVXJq3Eu9uitTklBbxB47w60xGVZxl+yoEFhBASnmjaNE+QJx/zDt/wZaqFYKgVYvxaemIA91lNGJc7ET+zXkS3KCw5lTB+S+zna55nMDqLCobQIP7601bSHOTrlhlWvvo26m7CCHc4BL9VSXpGW+BtPXTXkViUwKpkgawVtFsiUEMl/yx7FsnXNl46JJUMTxjGYv/Cp1B+scBRWhKhETBsG2EicP0Ws/hwWqKre07bQAxuosYVgIX0IEofvB22JcUZ4bENOLNqZnWf+rh+hLZUj56dDg4sMQpKgHFHPSKxpGqV3RPbccLJYaIRaez+7q4Bx32rWMzxNpP+OF3uKm+xiwA5Ic1xhpjaqvqohc7Fs38/m0iNBryk5CRIuxlz7rJz/HZPRdqYGMRENojGnb1nbE+VxUK5UDX9ltDqbxn5zccHB5E6sSMtElsYsM7JtFQzhM03zzjAKH7yVmriObTDyYyA9P8t1h0TG2pIQ8KxcNXz62JmtHamufYWemYGBbp
 aqOIv3UR
 setTLGrk1xxpm7dpvOxzx3YpHQFt0eyZYqpS1NFz6I2De+LlDXwYu4nCabduPzVM+ROQYJJosGM+c9kp63SQ8Sl5yMmCe7KyVLALIa/VkGnSvzo+3aAiFOfkqdiIKt6ychaDlU94G820yoUA82ajbz3tfYc0SGkN6j8ODrepBReZcIIhIZK6VIYMjM54/Bt8tyfecQ2r50a1CQQ/dWQ/7dYDFg6LA5v6FOhZssYMfv0dKRGIXLnRi2nzfvZXyIZr6tyC+WW4IBw930hXFYTAWFK8g6mTxQgWhFiSDfjTJKHdgshbWK54P3Xh0Y7ihC6xbkQ1UAFhgOgbpOKvC++VaGfg7PKjxj4RK9BOBBhnTUU106xik/vBaaRIl9yb6JTq0/zUJFFsOoxSi+zfQNYqs7C8AzE6ihde6+0Rcd68ePaoH5VskakD1bu8lgdN5z1oRlUvxztTBs/mT0KzBL8FhrXtPIfKLWECdrPyz6LtCl/65tKPTnt73QY4WGl7K1v0FBdwYmp+HWwRhY9yVDNt+uNZbBHoe60UQPV1v2L2dJtusF8k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

With O in slab_debug, SLUB can place the slabobj_ext of an object out
of bounds: in another object, or past the end of the slab.

If debug metadata raises the minimum order of a cache,
do_kmem_cache_create() drops the metadata flags and runs
calculate_sizes() again, which has to recompute the whole layout. But
calculate_sizes() only ever sets SLAB_OBJ_EXT_IN_OBJ and s->red_left_pad
when they apply and never resets, so the values of the first run stay,
and alloc_slab_obj_exts_early() uses both. For kmalloc-cg-4k with
slab_debug=FZPUO, 4K pages and no KASAN:

                              first run    second run
                              =========    ==========
    s->size                   12288        4096
    alignment padding         yes          none
    SLAB_OBJ_EXT_IN_OBJ       set          still set
    s->red_left_pad           4096         still 4096

    slabobj_ext of object i
        = slab + s->red_left_pad + s->inuse + i * s->size
        = object i + 2

The fix used here is to reset both values before the second run. The
s->offset is already reset that way.

[vbabka: consolidate the resets in the caller]

Fixes: a77d6d338685 ("mm/slab: place slabobj_ext metadata in unused space within s->size")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Co-developed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 9bb031f9a41f..003023b6f8dc 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -8860,8 +8860,16 @@ int do_kmem_cache_create(struct kmem_cache *s, const char *name,
 		 * order increased.
 		 */
 		if (get_order(s->size) > get_order(s->object_size)) {
+
 			s->flags &= ~DEBUG_METADATA_FLAGS;
+			/*
+			 * Reset fields that the previous run may have set and
+			 * now might be different.
+			 */
+			s->flags &= ~SLAB_OBJ_EXT_IN_OBJ;
 			s->offset = 0;
+			s->red_left_pad = 0;
+
 			if (!calculate_sizes(args, s))
 				goto out;
 			/* Created as unmergeable, so it has to stay so */

-- 
2.56.1


