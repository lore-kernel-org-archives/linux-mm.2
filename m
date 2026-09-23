Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B198C9830B
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 934CC6B0095; Wed, 23 Sep 2026 17:10:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8955F6B0098; Wed, 23 Sep 2026 17:10:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 782546B0096; Wed, 23 Sep 2026 17:10:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 435136B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:10:55 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C96B5140118
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:54 +0000 (UTC)
X-FDA: 85246271628.28.D20BF40
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf02.hostedemail.com (Postfix) with ESMTP id E4F6880005
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:10:52 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mtboJWlm;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790197852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ri8dUqYh2ciqE73sjjK4gAgS5aPTyFxGGtfGAJFHdJc=;
	b=tZEBu6oai5r/Upf5xK6mYVE5dDHT4Tvbv+r45JAaNyV4Nc4E9YcO75I0b63C/fAuBI0kEG
	zYYPl/rDQwj1K+5iHwFh9B/lXqTECLNHtz2MHIV17gL8VIZWFRK153Q/StG8EkSOew3sdB
	50c/XIipUdOQEXUCqh6t7p3HJ+Vl9Hk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mtboJWlm;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790197852;
	b=isXXUUSUrTEEr0k0aekDcsg8SpDcuTyDROmQHh2xON1Vbp7KbPywxuMA8J/zoSmoswZXAq
	mEMiGIaqj5ZPRSofxyfkIX93UfxSKo0xhDMa/pgQTkuxnKmoJ/JjLNEwXoqc9m6tX8OlFd
	KMWbhuPgcDDn8BmIhdVaDRT8ck//29o=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb76ef19aso13688811cf.2
        for <linux-mm@kvack.org>; Wed, 23 Sep 2026 14:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790197852; x=1790802652; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ri8dUqYh2ciqE73sjjK4gAgS5aPTyFxGGtfGAJFHdJc=;
        b=mtboJWlmyFFdlZCHrx/7ptiC9NyxEoJqJaTtGNFbEx+7mrugWpfbnUvDkpzy7As6Q5
         4vdjYAzY37fZ0k4yLPnTf8D42+LHr6qSeCp6KjwD6GuSZjLIwAGxdqy2tmhacZsjRNTb
         phpl3kUvXGyF9yDI1xCkEVrtrOLfU/inA8AFNhBdfm1iW8l475w/dzt7O0dt11xnFkON
         nRD+HlWw/H51LhOypTGpvczv5IvutJSgpf8qiUUXreWX/0yCH03OlLZkmqTrwJT3pqmZ
         owfhtBLoqMPZ809LLwrWWbfTQ4uZchexX2uRASzbdCnpf2DCdPSAEIDdSeb36U2YhUb2
         Vljg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790197852; x=1790802652;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ri8dUqYh2ciqE73sjjK4gAgS5aPTyFxGGtfGAJFHdJc=;
        b=qDVW+F97r5qglY0ci1h8f2kwu2i96l7zejEccVV4CAS3NWxfky5BZjTITAbtyIqA+8
         BXKkLgtqKejGD0FeTbhlWJP/9hcpUFXxBqmBVxXsikrerRwtOYyY5lS6cvdbsdkIJ+Q3
         CLXfJaim+OeZ1eoIHOExSyEHJIbnxny2yhWX3BlzQ6vxDVjH/pvB+0X/CDcdVgP0u9EB
         JY29BY8Aq0NrNpKTxobhlOVhEpo/Zh/B80Mtjo9iexo8bpsByFQaazAXhNQs1t3/XLfC
         OlzyQSMgi2pLp2IvkRKP4iuqjCAhxNaJsoVE2M/6hkd+wy+4EOiaVIrJV979ac4mrFvv
         r54A==
X-Gm-Message-State: AFuF++mc/IUi6kqyYv14MEheL6Mpj/khv8Wf7QqR9WfujXXs0wKkOq0t
	lPLsC8KLFQERHejVuMsTibQSoMiQ721qGPD12+QGhAutOwACZYLXMs77tjOP455NmE3bQ2CHJEI
	wcCISI+M=
X-Gm-Gg: AYBFou1ihBGd4KEILvcQlpg2aRhSLsL+HBG//jW9UJUkvcqsBZV0+Wa74hlrw0k+U3q
	PZ8QaDEW06UXx/CGmc7cS5T5TLlJvF5EpO7SyIatXn1Df95eUWGghxQ57LpttQcyCcgygy0BE0Q
	EyRsGfVVysErhAxxxQTHLEaM2GrsGBPsJIyrv9fQEjafRH5QzlYNxc8Ei+U0bZotmtGhdXWQxQT
	sYcg/PIctijy3UghgCzDBTiGeSWOX13agFuEwCTrOAhduFtk8K3a6dlY1hhGvJgVt4oYgqLcOYW
	xV8UGtd/a2HWK1GWW6I6TbWEDPM4EJvbdFV0DPSB0ymYbKQmkk/MpOAuifxTYINGASdJwnAXdH3
	E1t0s/KYSx/U33hUxpbxhtT5ns+bW+LjZdCqFVOSb2x8nmXMF+NvsdDXlg3pCrtuaKGuxrvzfAE
	1VBFsRLpmcVi33EqQz25dxdvOYlM9OAVPcvwPQVaKXtuVM6NJR0mWnya3VW1fgXGOWYVGmI15Ry
	0al6hA1dQnjrQRMg90rJNRZBF4CRs6icvMUtnMd2jow5Y7xvO8z/mgUnRrHDLxF5lhb+lg=
X-Received: by 2002:a05:620a:31a4:b0:93b:d79e:18f3 with SMTP id af79cd13be357-93c34540d1bmr71767185a.54.1790197852086;
        Wed, 23 Sep 2026 14:10:52 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c2485926esm305893085a.19.2026.09.23.14.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Sep 2026 14:10:51 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	Brendan Jackman <jackmanb@google.com>
Subject: [RFC PATCH 5/6] mm/filemap: plumb alloc_flags through folio allocation
Date: Wed, 23 Sep 2026 17:10:39 -0400
Message-ID: <20260923211041.3127588-6-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923211041.3127588-1-gourry@gourry.net>
References: <20260923211041.3127588-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6qbtxf97otcz77t8xy1qadbhr3xtna9k
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E4F6880005
X-HE-Tag: 1790197852-154151
X-HE-Meta: U2FsdGVkX1/u7oEfl3gppOOiAMzudy8LPRSd1uzrPJmhLoysY25lrGYRsiz/NXhtaY4qpekVOc/vhEVMhIj6Mdzfza+euxaOTT4JKw3xro7sjWmGcBQ4dtDGFXIvUXZZ0EBJGXEO5JIdmHZktuzTO3yYIAkdfSAQYeqk9GDN66er9NQP9tnUSwM5k8JZzHgu8Ltu+QUmMHeIPxpTexbZ9qk+SXlp6qc5YCetdzwmD9ymhLVeEF43ZE5rl/7US6BnJ97Fa0z+1Ax7pIoC5E9DZ7BMyk19cXuIcFpPSleuo/DeFtjwSCscssmtLwoCzYL2CddYBFOHvM5QTcikNStP8/4WkqgwbAlHnyCdspdVEpeIPUUTl/gWFjtzup/nOnMj3TttcWUpyJg6O3pBkOm14mgextpH0+nuStBj5uCATYeBnybyszRvmdaMDrVLPeLMCGRs3rbnIA6Th3UDhJSjLwfqvWigvCWU+wkHKWLLdD9LMk8+bMNJm/CqpYZsOQxwyBpOj3JpaUV+mFWXDKP3nIYZ/LyAJlTnB+Zt8B+/kxCCLxZ8kl/eAFDaSY6IarhGcYRsB90XxeRxpfL5CS1SHjRQkolzeEtqg2kjC+iYt3cJPc1bWbDqDD3yVqyC5hHKSNtyD96h+/ogcCP+yDPvE7/2wj4JxTTB/CwIVuMNXQEW9azp1xUPoiAfKcGBLTmYQrdQ/2lD/M1AwHcPWR+4K+oyYGIrUpw5lwLy1ozF6cBTqnj0CygjNwkDyudhgBD7cD7ptFRZgcENS+AXbt+Z9oGze1J2/6HlEBafHN4FtdQ7QQwtkQ2ZEBnGk2hv4Nfv9zU0t4qZ3IKK9FRdNidHY4s5ikxEpaIwCRu0K03YaJ4hgEnBMTOoV14yQBmOUJt7GbUxcGgGe/ZsZsPKD6HNMLY04y9PnoSGzVCumGhvlqNLCsPppKwOxeAnEkKCUOwdvPOyZSwkw+PNHOPFeUh
 7B8L29Xk
 K1fAPX9MWkFC42ku8z/1t7hzi6Bkj/rH3ktkeMhMvgn5alhJPthi2FSLz6Wdc2odrLDhB3q3aH+SMN+uZ0QIqJfdoAJUkwjlJ/O7hixYlhWmlQI2u1ZB7WJh3DPkXKKprXlIzY4xPgoCgRtCqcGuKkmr7kBEx9tyYNdqTMNypdgsWNFL8dUCJlYToUVh0sMNt2pVUPqGkWEbsO7nMotCccQ19IalfuqFKN0NDt4NL6ViZ4tf9Ma/crTKmCMHLZtm9WB5EOBNkztaPaYkRW7CzV8chcqsBbHHcPI2Kmz0kVt32Q4SekMW9bk+iqdlEWbLl+lrWo4POUwgjUKlV+gLhuaIkrqQpqQTa1ZWmvNbaIX9DWiRbGKAFsNKWXLIIwCnRSssTwgQp2aqOorUeMQnsbzQ35pxAGYeCBO9R5bjR06IG72UsPtmrh+obEZxwg2Q1frYDd6+pkWni8VxfBVPCbLXyHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Brendan Jackman <jackmanb@google.com>

The filemap folio allocator applies NUMA policy and node selection before
reaching the low-level folio allocator. It currently provides no way for
an MM-internal caller to preserve explicit allocator behavior flags across
that selection.

Add an internal filemap folio allocator that accepts alloc_flags and carries
them through every allocation path.

Keep filemap_alloc_folio_noprof() as an ALLOC_DEFAULT wrapper so existing
callers and the exported interface remain unchanged.

No functional change intended.

Link: https://lore.kernel.org/r/20260726-page_alloc-unmapped-v3-26-6f5729aa9832@google.com
Signed-off-by: Brendan Jackman <jackmanb@google.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/filemap.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..3b33cc873b73 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -52,6 +52,8 @@
 
 #include <asm/tlbflush.h>
 #include "internal.h"
+#include "mempolicy.h"
+#include "page_alloc.h"
 
 #define CREATE_TRACE_POINTS
 #include <trace/events/filemap.h>
@@ -995,31 +997,62 @@ int filemap_add_folio(struct address_space *mapping, struct folio *folio,
 EXPORT_SYMBOL_GPL(filemap_add_folio);
 
 #ifdef CONFIG_NUMA
-struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
-		struct mempolicy *policy)
+static inline struct folio *__filemap_alloc_folio_noprof(gfp_t gfp,
+		unsigned int order, struct mempolicy *policy,
+		unsigned int alloc_flags)
 {
 	int n;
 	struct folio *folio;
 
+	/* Task policy and cpuset spreading are not safe in all IRQ contexts. */
+	if (unlikely((alloc_flags & ALLOC_NOLOCK) && !in_task()))
+		return __folio_alloc_flags_noprof(gfp, order, numa_node_id(),
+						 NULL, alloc_flags);
+
 	if (policy)
-		return folio_alloc_mpol_noprof(gfp, order, policy,
-				NO_INTERLEAVE_INDEX, numa_node_id());
+		return __folio_alloc_mpol_noprof(gfp, order, policy,
+				NO_INTERLEAVE_INDEX, numa_node_id(), alloc_flags);
 
 	if (cpuset_do_page_mem_spread()) {
 		unsigned int cpuset_mems_cookie;
+
 		do {
 			cpuset_mems_cookie = read_mems_allowed_begin();
 			n = cpuset_mem_spread_node();
-			folio = __folio_alloc_node_noprof(gfp, order, n);
+			folio = __folio_alloc_flags_noprof(gfp, order, n, NULL,
+							   alloc_flags);
 		} while (!folio && read_mems_allowed_retry(cpuset_mems_cookie));
 
 		return folio;
 	}
-	return folio_alloc_noprof(gfp, order);
+
+	if (in_interrupt() || (gfp & __GFP_THISNODE))
+		return __folio_alloc_flags_noprof(gfp, order, numa_node_id(),
+						 NULL, alloc_flags);
+
+	return __folio_alloc_mpol_noprof(gfp, order, get_task_policy(current),
+			NO_INTERLEAVE_INDEX, numa_node_id(), alloc_flags);
+}
+
+struct folio *filemap_alloc_folio_noprof(gfp_t gfp, unsigned int order,
+		struct mempolicy *policy)
+{
+	return __filemap_alloc_folio_noprof(gfp, order, policy, ALLOC_DEFAULT);
 }
 EXPORT_SYMBOL(filemap_alloc_folio_noprof);
+#else
+static inline struct folio *__filemap_alloc_folio_noprof(gfp_t gfp,
+		unsigned int order, struct mempolicy *policy,
+		unsigned int alloc_flags)
+{
+	return __folio_alloc_flags_noprof(gfp, order, numa_node_id(), NULL,
+					 alloc_flags);
+}
 #endif
 
+#define __filemap_alloc_folio(...) \
+	alloc_hooks(__filemap_alloc_folio_noprof(__VA_ARGS__))
+
 /*
  * filemap_invalidate_lock_two - lock invalidate_lock for two mappings
  *
-- 
2.55.0


