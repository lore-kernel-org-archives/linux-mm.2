Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAF0AC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9AC46B00AC; Mon, 27 Jul 2026 08:54:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71F66B00AD; Mon, 27 Jul 2026 08:54:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB0076B00AE; Mon, 27 Jul 2026 08:54:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F42D6B00AC
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0778B1406BD
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:43 +0000 (UTC)
X-FDA: 85034550846.26.CAA367C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 593E680005
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hd/UZFkT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D1WQPDQMI+coFOVsQT9+cZjeHGlRR3MHadVGl/MWkds=;
	b=xnD75aI2ozIJePk5SQAtwJuKcuvDFZEpSTQ9lH+rjSv6hUjdOu6x7CP9HiYxm0q7Oe+RTQ
	o1tEj9IhanshS1ndhmOijTimjmcygL/uhaNeIqrrt0hMnaAi1iUL+5R1BzZ/kSuyoorQvS
	G0GEQldYZygvyjtJ27wRKIC5+xlsZRo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Hd/UZFkT";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156881;
	b=VWpGPSvHE7RYRMc0FQfniBMeoeT6cDDGUeeogtb2JqYJHUaPLxhmrcAevrf8gI5YCi/P53
	SOmbuu8Ms3/LcNXKhTZzN1a2JsAKiSFqxsP/XQuvmhKP4G2dYW40HkXXkOQJNkRa52HX1p
	l7hCuxijKB8zAISJNA47PWYp8zvquAc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EB70E600E1;
	Mon, 27 Jul 2026 12:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AB21F000E9;
	Mon, 27 Jul 2026 12:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156880;
	bh=D1WQPDQMI+coFOVsQT9+cZjeHGlRR3MHadVGl/MWkds=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Hd/UZFkTORu5A/8m+idVWXvn54XwJLu8J+/rOTMonsv4JYpmrv1dZB3HPpzDCm9js
	 4LLvJH26fasYWcSufdp+u6dd2GXmNi4jpXJz5GQDe/FMWROQtWri4YJ0LeW9DlSY5I
	 2e3CnEQOqhGwrJSFDeDsaBOBS6VJAqZSr/ndJdoLMjxMrunvzaKSpajS+y/tlbvwzv
	 kLvoRRpc4+82Dwd2LmCgAZfJyMJjeT+cM6CwTVyztGJfjoYYPqVDSjdN4/9UyHepVS
	 bJKjXqOVQVRpqMe7bLYjO7TFL/SC1S3JzgMeTDdfJhRqIWjvmK0A0QTlnTT3FJJOI7
	 mqfr+eZqmIjbw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:04 +0200
Subject: [PATCH v3 10/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-10-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 593E680005
X-Rspam-User: 
X-Stat-Signature: mpttebib6noh3z1qxjynnnexj9ny6tsn
X-HE-Tag: 1785156881-879049
X-HE-Meta: U2FsdGVkX181Ykuphd22TaT3GxI5B2u6n4TRdUWZpQ68vNk1Ln4jANtiE75EEWPaYdkEnEgoEyoFl8bYibzRorcfE2vMmB8WkTeHrqK+fDhCDSgNp47d4KPpkVbod1k1RQxuciX9POG2qBxDWh1GzABtPuyfavTI4YyVFlPE6fTRu2GAubUCTZd27d3CrYyatxoWdeGe0H/P93hTpP4geL1KdKAeV+o6BFO8Jsjc2W52fB9hZbBJbgjQpyRgx/QmkcuiuOjA6abbyl79K8l8ixL/7N+ugpA+1/wQqsZ+c7cdiJr2nrySfuGIvr6UibVyEmhzp0zh1Dml88jDsIoFZLWk2BJhcu9wsUbDj10PtiY19b2XmzQO7WG3768/qv1bMg+VkVnoMOV48dfXBxyqAXAZ41mmNriZtUxx+Le1WY/sV8nP9d1S0O3jL4MCgEVruoRT4BnIIyhpmzzflvR8uQhwhDj3c+lYjFH8cw8hC93bQ+1J1G4WFHXK7vOJe42qkxcjkQVnVmJ+TrU5u4mj0NQA58dQHq7u+/tBGnHgao9a3Z2barGfivzrNACAvucC7+O8JhfpJ89MNe6A/nPgHTYTK2AArXFJuAmOGXqCQVsuiMEQ1X+JC4veUbsKIrwu3qIKw7Ixo2fd/tGgQ84jHw9/8cOiF3PFs2WmJzgM6vOnA546DVU1HYstjDJOh3liPRzan5MAQH2KvYjpUpcMQh0sWikfnplnqi3cj3MzijpWKoUaW+zfGcmTKt7Y4+YMg922QCv2kKUvTyNBXi6rLwr6ZWmuXgaM/3CUUdJVyJ8fEsJWh7aER5PTbacqHTEH3BE1DlVivWwrBv1b0C2WaV7G52lrkelcotgs7ltj9pv2MQYkLbv9zOE6My3SrrhsOnbwGC9Io/XQjbPyggDyKRFA0Kelek56u4bb9AAB/9IGe3/Zrw0x8yGglzTdv8gqiRLE+JyceZ+3n3HOOU9
 lR19yWV5
 +brxKRlVWGf75tkkpPdRnITwj4z80hcdIPgofoDx5hmdUpOE4a07R3dBpfUrT+t5zVPs1ecTXwR3gXqmuGfQkzNLoPdNJ+WQjz/xgDN2EIxTJtWrwk256SsEBSUtlWjj3OOkLXaE6SwZFH2y2OYHAe0V131lVT6CjvLzOe6xmOdzymGnFrws22b546Yf46cXF+5OahRfijkZgi/AQYq0wFReRBSkzlL8KeMGZd/SnWiOD3pcOMHV2Op5mWoQ7tpuvrwgjG+K1fY2TjejdiAg4385YZEkH/wYOPVSz6Wn7Ftd2/D5OOFmPBckTMcZcNqT86XOQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory allocation profiling is compiled in but permanently disabled
on boot with (implicit or explicit) "never" parameter, stop allocating
(thus wasting) memory for the codetag_ref parts of slabobj_ext metadata.

Do this by using the new slab_obj_ext_has_codetag() helper in
cache_obj_ext_size().

Additionally add a slab_obj_ext_has_codetag() check in
handle_failed_objexts_alloc(). The function might get called with memory
allocation profiling disabled, when the obj_ext array is allocated for
objcg pointers only. Setting codetag refs as empty is unnecessary in
that case, and with them not allocated anymore would now result in
memory corruption.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 2 +-
 mm/slub.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 8f352d9f4d91..f86d4ed3f2be 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -591,7 +591,7 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 	if (IS_ENABLED(CONFIG_MEMCG))
 		sz += 1;
 
-	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+	if (slab_obj_ext_has_codetag())
 		sz += 1;
 
 	return sizeof(struct slabobj_ext) * sz;
diff --git a/mm/slub.c b/mm/slub.c
index 67958f2b3bab..6050fc08d8ee 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2099,6 +2099,9 @@ static inline void handle_failed_objexts_alloc(struct slab *slab,
 {
 	unsigned int stride;
 
+	if (!slab_obj_ext_has_codetag())
+		return;
+
 	/*
 	 * If vector previously failed to allocate then we have live
 	 * objects with no tag reference. Mark all references in this

-- 
2.55.0


