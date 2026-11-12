Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58B33606A323
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=TXTdwOP8
Received: by kanga.kvack.org (Postfix)
	id 775956B05D4; Thu, 12 Nov 2026 09:47:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74DAD6B05D5; Thu, 12 Nov 2026 09:47:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A876B05D6; Thu, 12 Nov 2026 09:47:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4412E6B05D4
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 09:47:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB3CD1604A6
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:47:11 +0000 (UTC)
X-FDA: 85426744662.17.9D22D5D
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id 3575B140008
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 14:47:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TXTdwOP8;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794494830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=BIgDiiCX9yRZLQGXIA3wPjKWsuYyC54v1yTwFIZpwnY=;
	b=YzrlT4ukm05greRHkfhu0KZ+VkQBJ60hOwRy6/v3n5vtFud0B7aNxXlSkGyfSKQ5T4XK7G
	LRxXSNCKvPOmdLWDb80JN/05CXR2KwuQjAuBSoVEGUsgbxTgaPj4RhnsLx981upoiUBoYz
	rb1qVco4KA/ys82C/4yW9VPmvggoZl4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794494830;
	b=MqGjbqAD1dW71DJB3ptS8261KC1Zsm9trjgBEhcopsq0BwTSpC3VDGDBIWX2o+3pqgry0y
	PSQHSFzv5uitL3tLvXb1l/lGrn/fCtWdGqWMMlzh4TLQ1BfQUYPqe+0M/EgN8fOLj4DOGL
	3359twTLqYx/Y3GId1BDcHuioIOY4F4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=TXTdwOP8;
	spf=pass (imf26.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-37628596783so4531538eec.1
        for <linux-mm@kvack.org>; Thu, 12 Nov 2026 06:47:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794494829; x=1795099629; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BIgDiiCX9yRZLQGXIA3wPjKWsuYyC54v1yTwFIZpwnY=;
        b=TXTdwOP8SXb3mSQEUlhjo8OxfPParUTGSJvUP7h/55Zv2zz4GlRaRmyUjAtxCHerwM
         ZNzqs7CEXkz7cQZ3Out9P4OyxCeY8r3IYPS+Iw4J2KrQrFPxF0DTTbSRLMNYKW/bi1RE
         k8c5PQYxQsnH9SfeJUgPB6pqnqtZdVYUPjupECJC00DGdqcWEM1w/p9SWQHkwcSsqAki
         0XEv5vg7CEghYT00JcFV3g3nY8A3zLZT2wRh48hbYdJtIVejRvvpxi8qDRNzObmINycK
         S8Jrhu7grBPHn2jQxoKyn30QX3XIxs7oHzEs7YSa+iOB/XWuAJe3hDkdRext5433JJ76
         b8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794494829; x=1795099629;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=BIgDiiCX9yRZLQGXIA3wPjKWsuYyC54v1yTwFIZpwnY=;
        b=zEXmypTM+ZEwuuHDGKxutiHwTV3S6Yd1dUXvO/fqC4H2dSlbDL+EjI+8YQ09JDyoJD
         t79lzfi5FuepeXiTSySlYMpeeocwOu64eWS8w0mhVldroG+w9tviN7dpj0/ksRd/qH+G
         qzPTyEPBdAbkEQAvfuBWVM5lTY2hjD0L9k5NAftH61VvVbL29kPls3Z7Eg/BsjLjbfao
         EKl/PlccWTvxw2FjhhU8p8+9cvmWXTUhzmOoHBJTcUpdDceHN7y7P6HgYHLcsKddHAR8
         B5lytyLxZEg5zmSGCO8TiJXH3R+OOywcXixYvhVf/hlbqwlRDKJmvk2kX2nBixbXdr58
         5ucQ==
X-Forwarded-Encrypted: i=1; AL+hErFL9rpKnqZJ7fnGEAkTvAuGM5CkLTJmz8IOf9BkR8CdVMgCQFgpIDfsPiWGXIy8i54nSgzEjr1cuQ==@kvack.org
X-Gm-Message-State: APuU4Z+Fp2cQaRo9Byl5uPLaB7/TwcdmgA3/Y6IKUT4LYHgTJvzqoVmS
	vbw82zoe0vBtYbESsURIx2SS05cm9+oYoVJOG4YUEQweT0jztxpgZLzb
X-Gm-Gg: AYBFou3Ceo9xHAzpIUd57FHtFn3JBJ23iBF0re35uA7vgSJLov9XMJ80XIobCY6Krxk
	+h5IFkn1riM5J2bbaN2FoQ/iaqiW3Iw3EugLR0zlaMooV4OciodmdQd0yH9kFdwrxyTl1qJ/S+9
	45wPjNSZhqFV3skGnncDSrkc7xLXcCOSglFlmz/nKTchWg4qZx452BhCKHpOsNbSAk1xt4mD8tn
	IYYEAVh1pSSBdA2I0DFymH0IZWIdf+st8u+HJtzWwTGfSD12j6knmUn2Z+eBxB2TQ71ojjR6k5u
	GbSrsyLzLKW4womT9OczvS90jeyoMsBJwh4xPNbvishwG8F+VKR5rW5Lt/dkmA0vLy5rEPh3TVz
	OpubRB0XUQWELMHpnjm39U/fQsCgoHCjtXh/vByevitFMl/XSNaOTybEATG7XlOekQRTXl1EE8R
	UdTaIBwK+RkmnogS/oU4PQy7EI3K+JZQI6wTH0wtwOZ2pDAX+vB4bYeSkni1q+K10quO3FgvR8o
	uESXeb8I/OHJwbk14D1ZRk9Bd8ixVTfM7bS1jqLIeRNe+lq3E+8ax3Eej2MUs+jTTTBcBvk+sBy
	tr66HHRbpZf41exzzEUNFaZaCG+FWmIuw6nI3odf+hcG22D5q/Zg
X-Received: by 2002:a05:693c:62d0:b0:360:b8b4:840a with SMTP id 5a478bee46e88-3768694e3a4mr5915728eec.39.1794494828615;
        Thu, 12 Nov 2026 06:47:08 -0800 (PST)
Received: from ubuntu ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37925b77223sm214734eec.18.2026.11.12.06.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2026 06:47:07 -0800 (PST)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Hao Li <hao.li@linux.dev>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v2] mm/slab: remove outdated comment in create_kmalloc_caches()
Date: Thu, 12 Nov 2026 23:46:52 +0900
Message-ID: <20261112144653.840367-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: kawuhy4gauaakfgujdtgsq355sfy53tp
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 3575B140008
X-Rspam-User: 
X-HE-Tag: 1794494830-585448
X-HE-Meta: U2FsdGVkX18RjRjz2QBMVk1+G7khe2u80Hq3Z66ymrmZFajFCPZ6GcbIAehVNeYKljj16WGUAyNvSVcP1IMhlUwiVO+8dSnfSLFEe9pAtx8goHvoG8JsIImslm5cXEvq1nmiBiHlqlyyEFPBJedmJRAmUUEmfWgaESYylaOMQMbdwDdxQJgxM3ZYC9ezT6kkqIMuV2NDWch99qLKID1UCDnCX947mhAFpT3uSa0NN6nyWPwFJL/bmbp1WDlOkzimF9aeQfdIuIolWqBpDvpsgqG+Jyx0pfpHTJX4gV7BO0wd7xJW0qKF4wG7TsDEk7mVVrrgWLroV7ctnzJuNkXcgB2Bx+p+ZZu84FvAN1UV/SeE5BQyJI+dLrg3Jp+nEAJ+2JF80U2bBw91QtJPpxhCp8zpZPKcarNO4ZWKTBaHhcsCCHWjgohQ//iRr0qTd2NRj/dqnanNkxsX+2BWixF8P2It+ZKr+sLV0cJXLxIS6ic6Di+FqY07Bu+xFa5SbQ8M3o/FjQ7JNuNSe28ozneFtRim+72RZ/QRBbUE5KLYcmLJW4vGburDAF76AjwrTOGu5cbW23YylEAmBQe8kQE7q2u3m2CWM4uMrhZ/XrZykUejNVYU15UtB1TYyrCa04Mf/PyvegDHEnGK3oXOczzvjNeWc1xNjqK88UZmGEC750mUEPf8/3iizfnSU71doZp7yL2Rg5qvH9qdEIU9phinGo8tbKlUTVx6/OfLZ4cB3uV0RM9xIKAiF/uJZHyMkYKcQKsg6Cp2UAMw3cGqNITk+Orm3G4OW43WTVHv8pegIUk82xIzU2ut9rpR/4nvdDfp3b5c+XkLzvFO0jiYRcbiMPU1994ZkIq9667H2BNYU2SHNqjjoK0YGQ1rdv92ItyiFrJQfglarwT6/KQYtjpdhSebwdNe9JfSWII1xIkXY7KI63K43ZS98AVvqBVLa+sn0MDfbyuU3brFI6pDUeA
 ReWAwGPx
 L7L3jF+eQjxPx00hMA8+7u+TIvvjRSClZ3mJNaOaWJ2gDL+03SgfbCiQYLgzu/q+LZzJtF+Z/gW5iiOHaKJfr+XvMfEGFMnPMtUzXCt38RTAfxv3d08429g1JlnaT/2x3Qpuupxsb9nnGu7ehQLg9r6f2O0+StG1h3cSXJ8Ent/sMiIoFMikq2Z5kvpY0JEno5UEZMeWrVWjOKDX6GcS8rUEo7aZ1ht47cUT2Cs7Jj5CFa08WY55MXTDbAY6kizUi0GRS/6y51xK+jwznnQwCvvVc0YM47T5/1Z5ZryToAN1jMxvKFlrgpjUv8XHinyAnaWE6O1xRRV4vLqpfxxTBVrMbTDccH5oh0rVYzFnJdSujXFTfrcXkkidoAHrErkBJ5MA2NbZDULHYHlfWUhsPdbWWHPNVy70Bz5NQwGtu83jefeFxQuAdgJJQv7CV+6fjK7csu7EZrAMzExYa/03Py8TVKpcTt9CuNFCx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Since commit 16a1d968358a ("mm/slab: remove mm/slab.c and slab_def.h")
removed SLAB, no kmalloc cache is created before create_kmalloc_caches().

So remove the outdated and redundant comment.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]
- Remove the whole useless comment

[1] https://lore.kernel.org/all/20261104144753.2266231-1-ekffu200098@gmail.com/

---
 mm/slab_common.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/mm/slab_common.c b/mm/slab_common.c
index 01c64ef661e7..10603b9cbb53 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -1028,11 +1028,6 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 		kmalloc_caches[type][idx] = kmalloc_caches[type][aligned_idx];
 }
 
-/*
- * Create the kmalloc array. Some of the regular kmalloc arrays
- * may already have been created because they were needed to
- * enable allocations for slab creation.
- */
 void __init create_kmalloc_caches(void)
 {
 	int i;

base-commit: ce6518e61e3b4bf4f97f7ac6204049b9eba7eb75
-- 
2.53.0


