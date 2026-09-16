Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6B34C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 06:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4FCA6B0099; Wed, 16 Sep 2026 02:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADA106B009B; Wed, 16 Sep 2026 02:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAAD6B009D; Wed, 16 Sep 2026 02:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7EF106B0099
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 02:44:09 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 237561A0621
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:09 +0000 (UTC)
X-FDA: 85218685818.16.03D1EEC
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf19.hostedemail.com (Postfix) with ESMTP id C2C291A0002
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:44:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fv7YGo1c;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789541047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PDFzpc+a9bATnmd50P4M+vPlS8YdthhE8ho3W/sX1lQ=;
	b=dV0hAS0QxAeEF1haMqZYpX/S9jfKdw/7vdR2UCRHNsz2EIzqVYK7O4hwm31Jl9uJiW0Z2/
	5J+S2wOQrNbcabMwiuQ8/F/8Fja/31lRQ4vfj+66WTopH9mK3YQ8y5YVe8btghsUOd0Y3E
	AVnncwSLUk1WkLQy977+Uu1CHQV1198=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Fv7YGo1c;
	spf=pass (imf19.hostedemail.com: domain of songmuchun@bytedance.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789541047;
	b=M2pwWZ3VVicX5N2hWULviNwlvXwACBHonJJyXOdAgdX+KxxF0pixrWbvxFn95wD2C17peT
	uDMGldsJl1BHtmQsivSKuHqCQDzrYgJ2soHuerqwjAifjR5pRJKu16PfJxYfbtvNvyTew2
	FfWkWEa/WwMl8XTzThg5RbhA58pJ9js=
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d747eefae4so1578345ad.0
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1789541045; x=1790145845; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PDFzpc+a9bATnmd50P4M+vPlS8YdthhE8ho3W/sX1lQ=;
        b=Fv7YGo1ceX3KfTM8EY1eCPo96BgohBhRv/7ApzjafZLh7/eL7cMsJOReHVSPpftFGD
         jeMcrjn9FJvEDCbkU+uvg6lqAlJ1oGEafFfDWwQqUIN5G2hGjlCG4DaBz+32yvAHhCfS
         2tihNsRmBGpmxFaBCv1vloZ2KpzlKfTfdPGsjA12VEMgT0QvVtVe62NZAiWYviY96U97
         qM0I38SMbLwJ7RSajYNkYt7FL8HvCNFwqHvsXHIsqQWm5hNmncdwkLTOUwMuN31ak0WV
         RcWd9rmAGfXJ96SCBszteIBwWGe9Y/ODTkbIE/iwKoXV9rBkHprlyMXE2ukRGrS27iGI
         L9MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789541045; x=1790145845;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=PDFzpc+a9bATnmd50P4M+vPlS8YdthhE8ho3W/sX1lQ=;
        b=lIwhZV6ewGsNK50ZSC4NKx2x9fpo6+1cyyp4SkUn5pq4TYwaWOJSO4bt/R7/PzNJJp
         0qwophVFOTsXyJtzKiXx54Wmj+42x6DeuKxj+Sx4mIp5C3LPArqtPT4jfu0dTaa3RtWO
         Fqi3Y9kOUM7q3EduOfe4VIL3AODjLWjA6AdVbFIvdPkHDF31zo5TyOthlPMKkyhhyKcx
         5RYN9fwzK/9Sy07OtYX/XixDbwUsoUdzyEKd7HRTKQ0YpRB1sZgBac4uj/LHxVz1hqPi
         IVDjS30g4q6vAgg9loEjIloFgFa58cOu+sj7jRnZgaCQ/HecbNmCmoKIjUkK3/zTwhe2
         0muA==
X-Gm-Message-State: AFuF++mWhWwNQKBer1ct4qQ+Rcg5Iulc8zNBL022vP6hxM9KI9ov48w4
	A7MQghIjrK7fWNqiWiGuaAi6qJBRe9U6WzTJwEiIBsVT22+dKAEkC5ZM/4/eEXJW/Tc=
X-Gm-Gg: AYBFou12ciNPs1X/nPrpssiruap84kYm8MPt8jNlI/OhwjFrqX48gZ7Vqh3nfFXjZ1D
	4944oArgZnCKfpdjPULXpqAaZwwk5OvnXo5w0mvY9yFpmLgPifcscxWy0HNuQZqcqowa6R6DUcw
	dehv8ZozHKJmBnQWo6mxQcSGAjB8x9wdBWwL0awGaNLICmG/ttx+xoerWv0apc+Igv7ldqJcAAB
	lWhopyJbVcDj/fGuiCBI3W/CmbcCwdCyUTpCEsE9eUz/lAV0u6e5C/mClQ/A5fpVZP80O6idFqH
	9S0B1+nt01R3SAxURyu0WeUhHId/erK5nFwzCp0ebZFexoqeT4yZMhtgSHgjbLy3CPOm+GxV3rF
	A0UyjaNoft0gbDiOaUBhh2yfHDyWVmhkl6jqFMr9C/Lo421FkziIxjhSZ3+N1BheRjA6VrE6pw9
	e9a2CpO/LZFguBbOeUH2Q8zRVyZaaplk9hq3cdJ6dr91onRiBXLjB/1xwTQPv4fxKOAQu0MpedJ
	VhK23o9y2MxRZwAcMg=
X-Received: by 2002:a17:903:3b8f:b0:2d7:4bc8:41a4 with SMTP id d9443c01a7336-2dd8ea1cd1dmr17328145ad.10.1789541045356;
        Tue, 15 Sep 2026 23:44:05 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.98])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89f0592asm6074755ad.62.2026.09.15.23.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 23:44:05 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v4 03/11] mm/sparse-vmemmap: open-code init_compound_tail()
Date: Wed, 16 Sep 2026 14:43:33 +0800
Message-ID: <20260916064341.1825793-4-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916064341.1825793-1-songmuchun@bytedance.com>
References: <20260916064341.1825793-1-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C2C291A0002
X-Stat-Signature: 6merf9ru5c5p6tb1b1j8pr7c565q4tbq
X-Rspam-User: 
X-HE-Tag: 1789541046-303004
X-HE-Meta: U2FsdGVkX1+IIhNP2AS3Ft/OQ2rORhBPg4slJfyjcy14X/yH/Lg7rjDi851SjhwG2cwHvEcJVtvMwyJcbS+2gCvFkFQmyJUrlf/Nr4FO6amUMkyeweUh7Yg2rGbeuRhSbsYNiDUkGzAeR5XByPjnBfpI8JWm9VoYwqnopGXFNaYVLUBm8D8gbm1YvBAqQNw5+DhAMmtxCQteY1fxtuCyqZUmbDB3bbomvavTHnCzwjFLV0fETsV7WjkCffKo51cXvlgh81IdfHG/CJNyg+gBkWRUVUJQZ0YNa00Ltn3UDR7HXZFl6+kdcGiVPXPbqmSi1or2ltomS/OMIjGe3QvUsRGSNr0BJc4UH6S8KiTBtocs72AJPrdd/MHhAUFm/QSLwWpl3mUVtEPFOpqGZWkAdT6KfmdbEAOYsN6+cFjvT+vWayRzPZe4fm051hHie2bvfvC4v8AzYd1h/0bncT16vmf7wcm4mQsotrkUf9avoHMO7GF2ohDpK/G0O1qyCLPYGeRzSTYigLVyqoYeD0AKXwLOMSMVDSEH4rAekRlUfgOCpec6/ON7HpImzBK2xTVMWKrr23chpiu4ZiVv/XOvrZoAjZsLeDFLzrxENkb1KCPIOPqkXJ2KD9PKVtMalnPI+lZVdZirksMf/SsS0vVWgk31S1O25xfEDGzjWfvkDrvg8YV4uQuB5iwOqP+nglqyeZTtmuqzFULvYR1g3PamjiCqCLpuwfqipm7sscg4kLRY8ntzgjnDr7wcrT26UnAqQu7iuSDFkxvuYONmVJiTs01q4V1ejsmE/TW1FZmbcGCLwj5gRr6Cni5bViaKvb/aJ4u/8/D1DmQVf21PJhYFfDCSmOXrGxMItX9+3h11Xhq2Rh57zLncaIK/JLEryKWXomJwkKM2BHSKE0RQ+x0di/C+gh55sIqs9N/HhO1yr/mPw3VrN5gCZQO27kdsVQ/AYL37AwLR+gdybDBXeVj
 O5OMQ+8I
 jvOCLhGtICORRaEnjhEWDmK3DHmaOgA8wgMg/fNaIp7Apv5xbmyRjee/lJWpFO5G0XOHZSQsakviuUUui+VaVmzs5KpNiil5X6M/mo+DvLg900y8Ja7ZKrg9DqmkJntAbmUfRziBvs60OK3x8JR7naxcImGM0+6YHVlnwX+rhcE+YjVyOF8VwphsUGzt5YifQ4pKzCToNq6ha3xrFBQpIH7DUtDk6GY5f8wo57axSqo/ySKg4m0JGNGSxpjs81SCWQSqiI6UEmeD8Y+sNNs3pEjOVaNmDIs2m00ithM3FMDOs1y/nCbez9VKZilwMa3i5BJBWXfrKURtOmSqqYepH0Zf4z7Md+NKPdaGGQr6CSviOgMYRbo0Dpy7JNLIkVhqOCs7z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

init_compound_tail() is only used by vmemmap_shared_tail_page(), where
the shared tail page setup intentionally passes NULL as the compound head.

Keeping this helper in mm/internal.h exposes that special case to the rest
of the MM code and can make the NULL head argument look generally valid.
Open-code the initialization at the only call site so the special-case use
stays local to sparse vmemmap optimization.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Qi Zheng <qi.zheng@linux.dev>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v4:
- Collect Acked-by from Mike Rapoport

v3:
- Collect Acked-by from David Hildenbrand

v2:
- Collect Acked-by from Qi Zheng
---
 mm/internal.h       | 9 ---------
 mm/sparse-vmemmap.c | 5 ++++-
 2 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index da14c56fb24e..0dca33db068f 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -786,15 +786,6 @@ static inline void prep_compound_tail(struct page *tail,
 	VM_WARN_ON_ONCE(tail->private);
 }
 
-static inline void init_compound_tail(struct page *tail,
-		const struct page *head, unsigned int order, struct zone *zone)
-{
-	atomic_set(&tail->_mapcount, -1);
-	set_page_node(tail, zone_to_nid(zone));
-	set_page_zone(tail, zone_idx(zone));
-	prep_compound_tail(tail, head, order);
-}
-
 #if defined CONFIG_COMPACTION || defined CONFIG_CMA
 
 /*
diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
index 7388a5b5cce3..861e09b2b096 100644
--- a/mm/sparse-vmemmap.c
+++ b/mm/sparse-vmemmap.c
@@ -189,7 +189,10 @@ struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zon
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++) {
 		page = (struct page *)addr + i;
 		mm_zero_struct_page(page);
-		init_compound_tail(page, NULL, order, zone);
+		atomic_set(&page->_mapcount, -1);
+		set_page_node(page, zone_to_nid(zone));
+		set_page_zone(page, zone_idx(zone));
+		prep_compound_tail(page, NULL, order);
 	}
 
 	page = virt_to_page(addr);
-- 
2.54.0


