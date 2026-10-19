Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C74260A262E
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 17:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=NSg+/GR5
Received: by kanga.kvack.org (Postfix)
	id 4CD9D6B0313; Mon, 19 Oct 2026 13:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 456E26B0314; Mon, 19 Oct 2026 13:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31EB16B0315; Mon, 19 Oct 2026 13:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0314A6B0313
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:23:55 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8FA1DC079C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:55 +0000 (UTC)
X-FDA: 85340048430.30.CB4CFE8
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf28.hostedemail.com (Postfix) with ESMTP id BBC91C0009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 17:23:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="NSg+/GR5";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792430633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ykp4/R1v56ikD31+YWezPL+y1PopNUKQZFoNf3vFuBU=;
	b=N/zJ5Xe9d1Bejk/lC4HonkoMKq6YCROBVtJsolIismeGWjdcISRspTdb/fN7buxDZAATHR
	L1xg3xxBp+XeWQlm02ARK2wLgRpvuwv1oCyOR4KtsxMqNzAGCv8k6FwjZ91m2/E5VFA75s
	/zShgp60aKGzJvHiy9pn7+WIDWidiSk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="NSg+/GR5";
	dmarc=none;
	spf=pass (imf28.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792430633;
	b=rtE5+jgqFOnic/+dqCJwkTlGzDQCF7Ad5HCf/03RVmOvUzJY7a7rNXmoCDCfVqVM/CRoo/
	8/xu1PCm+TzQ/q3+tmZB0paHfhH9eqbEahCxoz8W0c2mfohc++NHv8ZwB8gPcJh5R2pCef
	2g3cNWxP2JUsctucnfCI7exLQBfXP+8=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-535179e995bso25463471cf.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 10:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1792430633; x=1793035433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ykp4/R1v56ikD31+YWezPL+y1PopNUKQZFoNf3vFuBU=;
        b=NSg+/GR5qBf3aCA8cl8i+teogXkwezyhFaw5aM8qka74+rBqcX2lrGPJ2nShG4PLNi
         g86//UZUUthZds0qGWcuEdtnxdOC5ulixO8TPzNcKo/dccIVcIgZdeVSmXTIDdyeUb12
         9oXwziww2RYNHQVtJW9PYmBud49t1uuPJ/UR7BAH7naDS/Fem3T4a5qoogWZHKMN1MKP
         +ce3NNVUfXOQn1THjyYS8VTuL132O6rBHiSQne6ONpcrq9T06n4KEXW5cgGU8TcF1HZk
         UJNVJ9X1hEMhKujpUnBk8+kFVuQ2+u7R3khUAyENqUYSy0f60rDWfNXTk8ssIGLGeA0D
         lFqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792430633; x=1793035433;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ykp4/R1v56ikD31+YWezPL+y1PopNUKQZFoNf3vFuBU=;
        b=IEzh5hPfec5iwDruoKpp/fAy7c4WMcnIfPBg3p/oBcAYH8pqL6wZnUAwV3P5J1f4vf
         pxFgRak2gCIQx9ZKz0QdcqHOQXNQgvMx8uPjaI7lhmBxkqb2X2PtQDyZHM/um4y8hmxs
         8vv0IFrJO/kIlf+k3WZDFdnVLjKWVZF/fqu5qQGh1nsaaPIoTA2T9QSE0vR2Bz7YyQoZ
         ujgZxRSrLRk8uQGH/qlMHRA7DGNIOVXqHKBbRxY/5lxfL4EySTjb2tcyGx0eaujw5A3z
         gXsLOldrRJJXbnw20rjBa6yxejkrUEk1/gGk6aV1dwWgj3boZ5Z+eS5N1evyKdFTn6MY
         +Rdg==
X-Gm-Message-State: AFq9FYLYxKgdExK/WzdD9WXmDAexfPeAXdShjoqWZkXtJ4imnnoX6gWF
	i13eIMWZvmKzZ+Tt9mAGbJzLCdMGLcKEpsXJnMlJ83XIUJpDlC5JFg848IuA9Gs9UD7Ve8fGNWf
	ipTgs2AU=
X-Gm-Gg: AYBFou2W5Kl/WyVSBEvydLou1GqzXTbHJYfLwDhDZkWJptUgA9g3/gfiStlW1w8c7Ok
	Nt7hWzJcte8Rt5MuZrBzgpRJ44CUajDRbBVmVO/z8DGCjzRal1Vx2qxzCqyzQNs5Hs039DnQVN/
	trO91w3D4gB3IxbOV+q3ADdiad0sgjZ+kwH+a8FRuVMzwrzSiwdg3m/4+FX9tz1dS7kG+EoEQXp
	Qn3cY75TG2zod9t60kEoJUv8QH5P0gAd6op3RkeUb3Brg+/nNwe8jJilooNQ0D6LF0zpr+saFoT
	YDLfzvDYc9hdjz+wSg2uSBXeWmsgGP+wUBfy9M3cCudVOrau/fCtyb3aZSBZm4H/rwiXwr2iULt
	7z6ciR8jo23QRD+C5kLG74ZL5ZyywLS2NRubDXokMU8f6IKxfHMWUuVnZ/ARKWWCNFH5Ky3TbE5
	0BKNtAblMP3Rqykh1clQqQozT4Sml96nQW0k36hcU5dX5yFolimCjmEihqysXoDPRxWW2SxH4Bm
	7HR4QoH79KrP///SsF4m4pNcjQZ31Ol9eRk6Ea/ZMYz4ccyT5BqUesfZ+PO
X-Received: by 2002:a05:620a:2783:b0:93e:d051:8f19 with SMTP id af79cd13be357-93f29ced575mr1321775885a.40.1792430632885;
        Mon, 19 Oct 2026 10:23:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93f4adb28c2sm14615385a.0.2026.10.19.10.23.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 10:23:52 -0700 (PDT)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	mgorman@techsingularity.net,
	jiang.liu@huawei.com,
	Bessel.Wang@huawei.com,
	stable@vger.kernel.org
Subject: [PATCH v2 2/5] mm/page_alloc: validate zonelist slots against concurrent rebuilds
Date: Mon, 19 Oct 2026 13:23:42 -0400
Message-ID: <20261019172346.3344005-3-gourry@gourry.net>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261019172346.3344005-1-gourry@gourry.net>
References: <20261019172346.3344005-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BBC91C0009
X-Stat-Signature: 7z91upxa3acayz3gbxphnyns1wpx1qf1
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792430633-694521
X-HE-Meta: U2FsdGVkX19VaGC6MH1yTIL/DXBxKjazWAw4/N5ML98mqOcHOyR4vh/hcq16iVUKa4Fk2PNdde4LNPSl0p0mQHxa3TxBiaHNjP5Tl2Zck+31ye7ND/GAeeSkc0sIMYwF+SUCL6oMaZqOTL5uz2soPme5z9r+EPqhoX+C85mDxrIuC5IsfwgQH++LdQQhN5w1Kl7oYbDnGsF9pgUeFBdQKh6ApGxx10KGE3XNEhRpIBivvL+7EaG3ns9xOnwPI93NyRDE+Pibx7AGtp1Hin3FykA6fPNn59iux58fCUmj/qg0+LmtTtP6pQsssaGgXokm1CZut/y4P2JlmjBMtc4jqXrdWRbDXyQPbw2sZ9YP2p4NDFs9VKiD+rWjkrP26kUeShwh2/vKza7jJ037RcmgeCXQvJpbbtgwtVIizKVaTfTGJ9o4LsVPkoFbbB19vkgNt07SuiwQTAN871laWG4n3C3BZD5c69RlMv15CkW+nauUcI/zdsWCD9y9gtnSKw/dj4finHfJ/fesehklWMbpt1TCGJeNB0hf3xxYZ/sUCB0c6ph8qAPwn098MgrDdM9LSV/hHWv2ZCwvxmXlfMsJywCa1RKJ0iVHeW6GqCVT6LfS2CbigIqw8K1+c7TLIwO2N4rmAfp63Xs1egXw/4e4wi8Q0DSSoRR9TqADuwK66m2V5WTymH/72nN0Q9unEkEoPIh1/Qg9aIbW7hOA5v1UcXIJ//RWhoU1KQaObVT/xq3l3M1JUuS0HSJ8dawsK+JxrUFaH0NkJu/1ItnHesSJF+wLkcymZ4bBHhYvhJVrgXqZPMuCNc4CEV07AyI/37LruJjz3Pc4CW30kL4PlCwFDRVyyP2Tzk0m8mO4U15wDASF2DMle8guqOYWtQ7MktmCrpPdZ8dEp99x/kFP53C1dDphyW5b3TKAtoJzFy/hFw1xpQz0K2hZhW+d136hoxS7jXavSDqOL6+lbFW1R8f
 jOjyUSbm
 JhH4kU6TcFEMc4ElhXz9UjP4e7zsoLAJJViZG5ASb8//xYW0ZNq/EAIJt0TiSrHDmoRLv+EvqNyUjUxoG+6/TgXT/zQ423hi7oJzk3nrI4pXZ8N4sT7ZqdVFnZ+HYjL7/XxYY+ABbLoW2zUargWiCteLuYKijX8kKnhMBVAEKhpNU51L1UT3OKguQGG0vI80wf+6H86YSUKr0qr+oZpAVbypvPm+1lXoppw4+vDC55FYAMY0fNNZRCbDMA5CgGpVJorzZojbOpZow2PRW+0QxqJFbVkbRoSpZZiLFvPOeJIzEsgAaZVlJ8TcveYI12BC/6DXjy7+P6ktO9AnmTq4wF44AS2jvRZtLv+2wZkuNj7jUIvqW0lwJ3G/HX2QK9Bve4UG+w5l7iqKw2O3qaEYvApO+4nPNDqP+pB7lsV4CHBhYL5zxkVJmEFEcQhlO0JpVWgpD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Onlining the first block of a zone rebuilds every zonelist in place,
shifting the slots after the new zone. An in-flight walk can use a
zone it previously filtered. e.g.:
  - a GFP_KERNEL request can land in ZONE_MOVABLE,
  - a node not in the nodemask can have its zones selected.

With kprobes holding the walk across the online, I was able to get this
zone/node misplacement to happen consistently across hotplug events.

The iterator approves a slot by its zone index and node, and the
allocator then loads the zone pointer from the slot again:

  CPU 0                             CPU 1
  first_zones_zonelist(nodemask {1})
    slot 0 (NORMAL1) approved
                                    online_pages()
                                      build_all_zonelists()
                                        [NORMAL1, NORMAL2, ...]
                                        -> [MOVABLE1, NORMAL1, ...]
  get_page_from_freelist()
    zone = zonelist_zone(slot 0)    /* MOVABLE1 */

Every later step of the walk filters and loads the same way, so a slot
approved for one node can also hold another node's zone by that time.

Recheck the loaded zone against highest_zoneidx and the nodemask in both
allocator loops, and skip it on a mismatch. Hot-add only inserts zones,
so the zone that was in a skipped slot is still ahead in the walk, and a
walk that runs off the end meanwhile is retried by the zonelist seq-check.

The recheck adds about a dozen instructions per zone visited. The two
fields it reads share a cacheline with zone->per_cpu_pageset, which the
pcp allocation path loads anyway.

Fixes: c33d6c06f60f7 ("mm, page_alloc: avoid looking up the first zone in a zonelist twice")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/page_alloc.c | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c7125f6693574..aa3cd44fdaa5b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3784,6 +3784,19 @@ static inline unsigned int alloc_flags_cma(gfp_t gfp_mask)
 	return ALLOC_DEFAULT;
 }
 
+/*
+ * The zonelist can be rebuilt in place while it is walked, so the iterator's
+ * filters may have passed a slot that now holds a different zone. Recheck the
+ * zone itself.
+ */
+static inline bool zonelist_zone_valid(struct zone *zone,
+				       const struct alloc_context *ac)
+{
+	if (zone_idx(zone) > ac->highest_zoneidx)
+		return false;
+	return !ac->nodemask || node_isset(zone_to_nid(zone), *ac->nodemask);
+}
+
 /*
  * get_page_from_freelist goes through the zonelist trying to allocate
  * a page.
@@ -3812,6 +3825,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		struct page *page;
 		unsigned long mark;
 
+		if (unlikely(!zonelist_zone_valid(zone, ac)))
+			continue;
+
 		if (cpusets_enabled() &&
 			(alloc_flags & ALLOC_CPUSET) &&
 			!__cpuset_zone_allowed(zone, gfp_mask))
@@ -5236,6 +5252,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
+		if (unlikely(!zonelist_zone_valid(zone, &ac)))
+			continue;
+
 		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
 		    !__cpuset_zone_allowed(zone, gfp)) {
 			continue;
-- 
2.53.0-Meta


