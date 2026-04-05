Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7588E6401A
	for <linux-mm@archiver.kernel.org>; Sun,  5 Apr 2026 12:58:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 49E396B0088; Sun,  5 Apr 2026 08:58:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44F136B00EC; Sun,  5 Apr 2026 08:58:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 33DE06B00EE; Sun,  5 Apr 2026 08:58:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BE646B0088
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 08:58:37 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E223513BFA4
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:36 +0000 (UTC)
X-FDA: 84624506232.15.7716D1A
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id 21E49180004
	for <linux-mm@kvack.org>; Sun,  5 Apr 2026 12:58:34 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q0sjhgh1;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775393915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64qVqbFMPmvyYt7CQKJ/AlutLuZCqUEnEB7XrUuUTaU=;
	b=Wy0Kc52jsSQEJWCtzczCZnfhph3nPU4CaSuilmtCHumKay8mRhdie5yhYncYBS7WA8NMNM
	SEOOUzky1Et97o/VcxDz2EyjiTMDHFEmXQpHXJiMDfnrF0p4Wkpgpwxa/TIHfn4uw3JVKK
	dcoFQ50e2jiTzfP4RdkqHpcL6rZSLe4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Q0sjhgh1;
	spf=pass (imf06.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775393915; a=rsa-sha256;
	cv=none;
	b=yj5e3Z2FgxM/LtvxX84zvBT7xW+ahpKL9vOeeDwchFYD3lUTs9wz7WxGZSW4+ELDNVxXXu
	nz5u6pnCsRBUp0TEhGTkbT8fP6cC4R3yyxezqo8B6EdPPsWL2/8sHb2ENXIsm3QBFYIYB+
	ygXm8ENBp3ePNdqRuLTOmkwDNjZvk48=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-35da9c0c007so2934285a91.2
        for <linux-mm@kvack.org>; Sun, 05 Apr 2026 05:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1775393914; x=1775998714; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=64qVqbFMPmvyYt7CQKJ/AlutLuZCqUEnEB7XrUuUTaU=;
        b=Q0sjhgh1ULPUWHfbK0t1WTe/oSdhPMp7/BUzCSzVjdD1Enqf2Oq6Y4Wo3pLlYxTEXI
         hmgmGxbEtio1PJwI6P/ELD8LCWkWzMLkqxlE7638MlF44ePsGjMJhAvlm+wFDKTfL+wD
         RjONBIUVkV4g/d+lGFwx7hv4jf7rZ1ffhBfrHliNWpB1VWwrpnOXzZjvp1pHbmak+qqZ
         yxdReR2OToGCF8MJ8RoRk4KSA3wFMLZcJUNICQITEMN5m7TU5uool5hTdt5pf6vAe/G5
         5DbvPIHmzYcd61QuPpcqJqBm3okXnxOEVVEX9d3lK3GncbZ/1oD4SqA2M9OY3hglhwpE
         wqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775393914; x=1775998714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=64qVqbFMPmvyYt7CQKJ/AlutLuZCqUEnEB7XrUuUTaU=;
        b=iJsLHNATGzatC0xZM8pMBdQvKTxGLGSWleOfzoCkvlL6mIzMkdzAFodaDBctPsan62
         lg6oLJarKVPYYOPJoQJ4YIC+zMDC+dZjtZQ0FYnaWfi1EWbSi98HHRnCLzwT813RBG+M
         auSBt0SOOSyhVGEsqTrTm6QUsMvFE0R0NlGAa0lLpON7d+XSOQUT/3+Gwwrk0LNj99++
         1ES0A+rqinT8sxkIARw/cquhGLFhSdQtFZag2cOMe+UW0tRYjIw2UwH49gaEfpK2xE56
         KoBT0vMfdbS/7L8qyUUy9dKchEo4N9DtXQ/MT1lOuAvj2YeQPcqoKViYyRMgdlvTkRNT
         +BuQ==
X-Forwarded-Encrypted: i=1; AJvYcCVYKk9ZRnrquW86MVr8KcFS6i+ZXXzhhEmiTpL3xdEdozdYhFa/ckka+3VaIGD0XX5G2BYEbYmIPQ==@kvack.org
X-Gm-Message-State: AOJu0YzetkdJpiuyD2fF6Yuk8KFfRSHd5zm5A5ohYVbJpFJhVGxWzbG/
	WvA6yx/hmcE0+bNq7DeEWM1Cf97R1Gv27afoyt0+IsKiaQ4MQlV6K0S/RjPy0e8jHvY=
X-Gm-Gg: AeBDietVR/Gt6JKs1NRR765dczo1Z6+y8ztKHzhVT6dJVYY9ngTn0BCUIO3GcEKqZxX
	EUW67dqh3EZryDvkfPWkJBQX+Qmm5LjTGe0KsGiHjOuDqRAnyInl8RBSlchulmGa28bBt8S64eV
	FQ79vmN9lPNs91ECLysZs119iu4t7DGRndaOJJtL7UWYATIiBhst4rnD98wbZre2vJp95Qc6ML7
	hLjlmdBtvH6fQV/jpzmH3o8RlkK8IKfHJe7K8/uGjcdOeenFzY/FSbKbcDBu0d0T8C1It4asPhG
	4cA4PLWkfklbWHsZdEJLXOLfd2ktQfm0+80ZfiAiP9d68D6WSagrLRGSaYJofrRRNkY1UU7eLlt
	9rqiy3gbvMrJJtF+vWwoXXLdtRICyaH/fOPnje+GASv22Q3QI7DAWEXETPLNF76Rat0fLLShn9j
	hZ7gaVUurk3g+sUxf8rFwDqblU7TWmbVrUIPNDAH2WgiY=
X-Received: by 2002:a17:90b:55cb:b0:35b:b52d:f34d with SMTP id 98e67ed59e1d1-35de679faa8mr8791452a91.5.1775393913904;
        Sun, 05 Apr 2026 05:58:33 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.97])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35de66b4808sm3748505a91.2.2026.04.05.05.58.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Apr 2026 05:58:33 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH 46/49] mm/sparse: replace pgmap with order and zone in sparse_add_section()
Date: Sun,  5 Apr 2026 20:52:37 +0800
Message-Id: <20260405125240.2558577-47-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20260405125240.2558577-1-songmuchun@bytedance.com>
References: <20260405125240.2558577-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 21E49180004
X-Stat-Signature: 5wnrcssctgggs7kx1crtr7z4mindy1om
X-Rspamd-Server: rspam06
X-HE-Tag: 1775393914-302287
X-HE-Meta: U2FsdGVkX19jgHsajl2l/8VQIVq3t8NErMLEz5T5gfzDV4wcrhYtEtnPfc5r4Ubk/nh8gJYfS46+HdptbRPU3Y2ZpEn8ZztWUkr3Ka3uo1lV9K9rN4foiktBF0ATgYtTwQeDzW9SabB6OnURv3AaOn6Ep4NR/LNE6UB1RauXchRkPcm9eLGKPwPO6yW66ChcdVt45avgQxUIWMzCdZL8K/eIc4pY3h1j2w+csyNvriQrjpubppnhW6BOg5eYQfTqpf+Z/e9OtF/krnvNs1F1vVrAWo/NEV8TpwLu7qSXvDLHq5lNj2Va+697Zw3IBEBj1sCLJCYSwV8o+7Cdc3Q7QeJxj1LsQu4w2SJYYWitueC2EHG5WYosZXkftzHkVlZ0tHOmdVXH337iPLXBB2MVbE+GSMUTOlbrrpK7FMilY4DuR3fn4S67xPmdkx59qj0v3J/T+3XueBHAzl3+EctgNDGUWwsqSL94HItAPtqgoh9GO2LABWERuBw4NIGVcE3bRLLVnfA3Uskf7/WMGJK3jlztDR9+nq0C8BMZleTwAMT+QwbfGQURkl0nlGwF+n8XaxwwT19VvKeYzSHMqT2odC4xLeDMO4oKyPHnaRbQoegoYcDikYQyeZ774dr1r2PGO+6YO5MMyElwwb4r0eMOd4uWabR7/NVELah2GBMVV0xBjWSIP0yKjgX/J5ORYF6QR1Zw8cGd7KFBQbKjvnPVf36VhrpMjXem905+I6CKpd6xDdIP/vpXr5EkcVW7wiRTC+/HmqK0jO8YqjbHnPbQpvOsxCQb+d4VyLlXsrJpFjy7RAdncWS7pyuSXNvpap4lRDyzqyP9ta8gDfsf8bPjlACJ28fn6B6HZtZXOLVUDqX2akkpN6+1sEVtoxYTZo3qhJMV8HTfVP49F4tSbIuMr8jxPItprJSf5dfZvg4gNcnSF5A+sobDlfpdyoMJHMvg/N5PsP2/rAoTZLqPK1B
 sndIq1fb
 1TbrUSWUBIBsrsY5YItodSPA7vCkzX8UAItvmKwMYUcSfdo2iVtwbNlZC6rlnoq8AbfzNRs85dkNORdt9rZK4TkP0sOKSKxK10WjHtWPsegmxzPansFFZBTrAZsqhdM/YSdGBL57iKVBNBhdW7cAOGF2gj6F/kaPBDGNCYREDbiyh3Sw1PJi/tCVUB0s2eGHgJSRC8TqL1hhqNzJ324XgEfMgh5Nr6Vv9pifOksbm5FCGP/WXUfzSJjCAE6T1EYbv0InurvFZpYw7pExOdbe4GB43t4E3+XXJHdD2pCglGzYyW8SaAiC91d632aPi1md0xnMi1IcW2FXz0RdTFKa+YYl/Dis5/QoHlm1RTk3hfox7PFf5kX3Osa5VSvt/iHkfkjsddoqPF2daOSI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The sparse_add_section() function was using the struct dev_pagemap
argument only to extract the vmemmap_shift value to set the compound
page order for vmemmap optimization, and to set the zone to ZONE_DEVICE.

Since the full struct dev_pagemap is not needed here and is being
removed from the rest of the vmemmap APIs, replace the pgmap parameter
with direct order and zone parameters in sparse_add_section().

This cleanly decouples the sparse memory infrastructure from the
ZONE_DEVICE struct dev_pagemap. The main motivation behind this decouple
is to make sparse_add_section() a more generic memory population interface
that can be easily reused for other non ZONE_DEVICE population use cases
in the future.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
---
 include/linux/memory_hotplug.h |  2 +-
 mm/memory_hotplug.c            | 10 ++++++++--
 mm/sparse-vmemmap.c            | 14 +++++++-------
 3 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 815e908c4135..089052d64b01 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -305,7 +305,7 @@ extern void remove_pfn_range_from_zone(struct zone *zone,
 				       unsigned long nr_pages);
 extern int sparse_add_section(int nid, unsigned long pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap);
+		unsigned int order, enum zone_type zone);
 extern void sparse_remove_section(unsigned long pfn, unsigned long nr_pages,
 				  struct vmem_altmap *altmap);
 extern struct zone *zone_for_pfn_range(enum mmop online_type,
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 68dd56dd9f74..0f7707f3d4bb 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -385,10 +385,17 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 	unsigned long cur_nr_pages;
 	int err;
 	struct vmem_altmap *altmap = params->altmap;
+	unsigned int order = params->pgmap ? params->pgmap->vmemmap_shift : 0;
+	enum zone_type zid = 0;
 
 	if (WARN_ON_ONCE(!pgprot_val(params->pgprot)))
 		return -EINVAL;
 
+#ifdef CONFIG_ZONE_DEVICE
+	if (params->pgmap)
+		zid = ZONE_DEVICE;
+#endif
+
 	VM_BUG_ON(!mhp_range_allowed(PFN_PHYS(pfn), nr_pages * PAGE_SIZE, false));
 
 	if (altmap) {
@@ -412,8 +419,7 @@ int __add_pages(int nid, unsigned long pfn, unsigned long nr_pages,
 		/* Select all remaining pages up to the next section boundary */
 		cur_nr_pages = min(end_pfn - pfn,
 				   SECTION_ALIGN_UP(pfn + 1) - pfn);
-		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap,
-					 params->pgmap);
+		err = sparse_add_section(nid, pfn, cur_nr_pages, altmap, order, zid);
 		if (err)
 			break;
 		cond_resched();
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 68dcc52591d5..894352cb8957 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -666,7 +666,8 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  * @start_pfn: start pfn of the memory range
  * @nr_pages: number of pfns to add in the section
  * @altmap: alternate pfns to allocate the memmap backing store
- * @pgmap: alternate compound page geometry for devmap mappings
+ * @order: section order
+ * @zone: section zone. Note that it is ignored when @order is 0.
  *
  * This is only intended for hotplug.
  *
@@ -681,7 +682,7 @@ static struct page * __meminit section_activate(int nid, unsigned long pfn,
  */
 int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 		unsigned long nr_pages, struct vmem_altmap *altmap,
-		struct dev_pagemap *pgmap)
+		unsigned int order, enum zone_type zone)
 {
 	unsigned long section_nr = pfn_to_section_nr(start_pfn);
 	struct mem_section *ms;
@@ -693,11 +694,10 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 		return ret;
 
 	ms = __nr_to_section(section_nr);
-	if (!altmap && pgmap && nr_pages == PAGES_PER_SECTION) {
-		section_set_order(ms, pgmap->vmemmap_shift);
-#ifdef CONFIG_ZONE_DEVICE
-		section_set_zone(ms, ZONE_DEVICE);
-#endif
+	/* HVO is not supported when memmap pages are backed by an altmap. */
+	if (!altmap && nr_pages == PAGES_PER_SECTION && order) {
+		section_set_order(ms, order);
+		section_set_zone(ms, zone);
 	}
 	memmap = section_activate(nid, start_pfn, nr_pages, altmap);
 	if (IS_ERR(memmap))
-- 
2.20.1


