Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C796EC53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:54:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0BCD6B00DF; Mon, 27 Jul 2026 08:54:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6DC56B00E1; Mon, 27 Jul 2026 08:54:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C83CA6B00E2; Mon, 27 Jul 2026 08:54:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9B78B6B00DF
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2F892A074E
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:20 +0000 (UTC)
X-FDA: 85034549880.13.5C74016
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 90ACA1A0006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHMmF0xg;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156858;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=48LV9viFkKhYFL94A+9rUOQ2qkMc0/qMJzE/2IbzWC4=;
	b=piYUuC20kcQ6AI2RPGZQMO4nhU8qXtz2AaMwW+ZJ07iSuvV+FLvb3yLXYX5YT/ZBM/6qvt
	C2wfR8EMCaN3CRYIkjTknY1ZLXSvsxTDil7W3prWfLHjYziTKT6NCKWz/wk/G2QqQPGxUO
	r9RKIT5kOH+q/xxyPwja4fBq0+IF4j8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZHMmF0xg;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156858;
	b=CPelU68FOkOZ/npODmT9UJEWUTCImtNJAvViT1jlvbTSpkzNjaYxrX1aE0KxUqeGZ9J1yv
	Ds5nCkcDqkwKe3np4a6aTQCUyHIrX5yNzD6k7eQ/7Q8tQwTAjQVcQJn0M3fpHUwkE2Td8i
	MmQ7SEsnQUXf06lllu3zaN5kc6bGT20=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2EE42600B0;
	Mon, 27 Jul 2026 12:54:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A9131F000E9;
	Mon, 27 Jul 2026 12:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156857;
	bh=48LV9viFkKhYFL94A+9rUOQ2qkMc0/qMJzE/2IbzWC4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ZHMmF0xgouXrJCZqCSjp8IrOSG2g0miroP65AfHtkeC1t7YuULD2HKIy4Xc3rrOU/
	 +uCLL0B0xzM6lzIGwNX40iWUpCq40eXb+WbfggWDQQwl8VCqN9d6QXtPeSrY92NWc1
	 E+inLjGuJOwmWvPbu9fTyEH/4wx3JxJUt/NDG/bZa0LtVWmGYt32funyuCOqQMSPne
	 nD/ih6G8CtxMp2pCHAKRfMes/L0Wbj23NVnHRsD11Vm5bWUG29O0vfxvqgHTEbd2IF
	 af7ZQ9PP1XJMV3NE2iN6Gc6bxpkPzswDe07pnA+uANFVEuBHT8N4bPGfG38DjOsxrs
	 PTwH3kRBsXQbw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:53:57 +0200
Subject: [PATCH v3 03/13] mm: move struct slabobj_ext to mm/slab.h
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-3-c29ef0f1f257@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 90ACA1A0006
X-Stat-Signature: 1obdgpzm183z984kzd9ne6iiiap49int
X-HE-Tag: 1785156858-762452
X-HE-Meta: U2FsdGVkX18Zpl9wMWbvOOgBbQtqiCcwaqMuuBququg102ZUHGsxlX8zAssingcvOhJF5IkGO1iFad/PGS0k/F2T0aqNNI4xjEABKMQunf+BC5xYxTVaZQ74CavJpjvcrQ33ZaF+CuBPy1vwnH1pDrtoryvYScU8BjPLrAgcXvJEtqffVKl9EVVHBGmM0mnD0I55ptR18JhuEX+S1RSRHiMiE9vjqvCJVRjPHy+BS+kPspnVW21DgsSsi/d+e4ht20kMILcyWhYg8PYD4oBGPkV/oWzM9KFBZYpORIJotcuNZ9FaWb/mmHqHDwsw/GqoKaoRyLCHtd53G4Cc0OD1q4158m7SeWebkeVUZvlH/Iflp9pbW/+wlBbczxK3+u3zGDaGibrdcDWiYQ3xTbhNlzMeBXMMWKy1bktCyBqn+LDttoudpwrhPTsmbKgeEt20S0pCyhToyWlQtnxQozEynBh2FA/5L4wMEDG3PeXg0lcp9EOw2+DmWC3BqS4G1q3LkNTILuSOEI1BmWmOxpLKmQ7CTEJRQZ+AltAyvY4VCS0Zx60HsScKkjNbunZE/8QtCB/w0wipNEgnynjBD37VmfdVQABLEsBPXNqaUhS8D7wVE6TjnOZRnK/OGansQyklX/BpuNcFjSVs1uCYS6lJc9upksZa6udLqF1kLqfLxGYvmGDEoRIl87yWKZH5rb23e+VyZ0UjQYam9hzLf2O+EpWb7+8lPD0KtqubOkE1jfA8ZQfCtKpWxILjdqBerCIY1LkTfbxC9kC1llCTJkZPJeY6obKuUGl6nDrWF/Q1yLofQvt1BS/lHJmP/Lo13kENtXLOgvNRwvG2iEsZDoLIEsiFrFDMYroCZdNWjOddPcAkWzmU2I4OFvpsmUicsjENVKHDZgJBBI5WX0Pp1xjcrdPJDMWgVkzA8MzUQqQmvFUMbxxrTCoDWt7vlU3ce8wrn0tURCAh0qSAEq1REOm
 21sqEyUD
 vp7r+2S2IUDz3c1gHDi5ZenVhGorpCUr1mJgpjAgrmdYaAz9AFuK0Vg5HG9sQec+JiT2hivx1Wf/qj0W6ExGZY1fnS3XvrLflc6vJo4pUwFaPZeBrQe+TkM5zu+QGk4KHuOrRkb9Ym3CPOy//IESYoKRual7kR9TjkFHiwBKPH8RfItWh2A/nQTnE1GAZanrb+Zl15NaDsQ6c0dPTfmLbxQ8Hf8t3CVkb4MLqm2knrPZvkaQ+lMrKMiUUNaf7FpP51HEfXp3pF/rZIit/US9GW4Zp7R1oyak+gGcHl3eEBD8hHPWskiM0uVhe2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users of include/linux/memcontrol.h don't need to see this internal
structure. Further changes to the struct will reduce recompiling.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/memcontrol.h | 13 -------------
 mm/slab.h                  | 13 +++++++++++++
 2 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index e1f46a0016fc..93869cc35c25 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -1440,19 +1440,6 @@ static inline void mem_cgroup_flush_workqueue(void) { }
 static inline int mem_cgroup_init(void) { return 0; }
 #endif /* CONFIG_MEMCG */
 
-/*
- * Extended information for slab objects stored as an array in page->memcg_data
- * if MEMCG_DATA_OBJEXTS is set.
- */
-struct slabobj_ext {
-#ifdef CONFIG_MEMCG
-	struct obj_cgroup *objcg;
-#endif
-#ifdef CONFIG_MEM_ALLOC_PROFILING
-	union codetag_ref ref;
-#endif
-} __aligned(8);
-
 static inline struct lruvec *parent_lruvec(struct lruvec *lruvec)
 {
 	struct mem_cgroup *memcg;
diff --git a/mm/slab.h b/mm/slab.h
index 01535e1e2d3c..7bd361447c54 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -549,6 +549,19 @@ static inline bool need_kmalloc_no_objext(void)
 	return false;
 }
 
+/*
+ * Extended information for slab objects stored as an array in page->memcg_data
+ * if MEMCG_DATA_OBJEXTS is set.
+ */
+struct slabobj_ext {
+#ifdef CONFIG_MEMCG
+	struct obj_cgroup *objcg;
+#endif
+#ifdef CONFIG_MEM_ALLOC_PROFILING
+	union codetag_ref ref;
+#endif
+} __aligned(8);
+
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 /*

-- 
2.55.0


