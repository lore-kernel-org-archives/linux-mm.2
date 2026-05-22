Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDBA3CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 22:06:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 316406B009D; Fri, 22 May 2026 18:06:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EE3C6B009E; Fri, 22 May 2026 18:06:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F2D6B009F; Fri, 22 May 2026 18:06:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 085ED6B009D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 18:06:40 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B001740B35
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:39 +0000 (UTC)
X-FDA: 84796440918.27.7D2F7D0
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id D1D6014000B
	for <linux-mm@kvack.org>; Fri, 22 May 2026 22:06:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VOGTOj+X;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779487597;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SMrn8GveLC1NdRQvZAymrZa6CvaW/GKC3sRoShkKmw8=;
	b=iEhktfUIFSBWoscZB5dHhHn38kw6iqx2NuCV/Z/moDXlEGdSn4CwViWVJepdLRY9Cl1bwo
	GQDjhmyV15ACOv5UaDwwKHNQsUATuYPNlkqOyXKKsAxskTs7FiA6H+wndQHoHaRr+iT1ma
	FHdbxV3Ws8XrRzisZemKJ58pB1jfDVE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779487597; a=rsa-sha256;
	cv=none;
	b=r/o1kFTThB9193Xe3oLP/YG7htd+osJlNo0RxHQ6CyEe3+onDXy3pal1hjymjU6BzWw4br
	YbFtoSxt6VaP0v1KDaUmCRnO3OkPW1e5HoH2D5SXfWAWzh1XslByXzskO2enVDpsJ6ipaR
	MRywfeoaifaPTS0RbhmIIeWDkmdN1Bk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=VOGTOj+X;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.53 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-408778a8ec4so4768399fac.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 15:06:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779487597; x=1780092397; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SMrn8GveLC1NdRQvZAymrZa6CvaW/GKC3sRoShkKmw8=;
        b=VOGTOj+XAQanGuwdG2pUvGutAe8mRtVEKiIs3ESItyTBc84ug7yJHJULwOztAs/lTa
         UeMrTVHOI/h8O9ddFJ/TQDQuiSlhlVv8ibXJL6KTb2sDwbuCm3Ews2DlP0JzLxLPKh5p
         JQ3YmHksJoRV+BVYC1xZ2UUPUvdZQBGE4TaZ1CDHdtCSR0fuGTUnyGYSaoAHcsOK5oU7
         jypEe08sCMX24Kvc5CDkSdNyro4Z3TDoMONe7wUSm2CW7hSVnU4c5ejyTu7Nxv6tqH6s
         5BWlNKpjgTaYgF5tWvhq09u+dUk4LsYBv84UALCbpxEL/+XPO4YAqIRgTFBGeNwNOB0T
         vw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779487597; x=1780092397;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SMrn8GveLC1NdRQvZAymrZa6CvaW/GKC3sRoShkKmw8=;
        b=Mb4KW8SpAJeFXpzZ23v3Q5T0sfNL8yWiqMIM1enO0145JVZFkKo94yKp4oX2dF34yK
         7S2IMSihv22PUJoEuYuKxV+G0xkQdNykpGDSd5D0ITBVX3RfQw9E/y8jgFoPcqUvKjWG
         4gNWat8oSaQzqj/V3sfP+XKazX1BW9nGjP0Rw/L8RtwHFGpLqR0sPRXXo+k6rxZrLhkr
         cR10VG+49hADKzvuXruAvuFlRu/nFdcAFT/FDRirmzAxAu/zNeTyMqEnRPqUwc6sFqQd
         wYh7UfMOUa/629nx1o1l9EyH5HSYpNVFnvY6dcKUD6yVD9MgvhCqm+Hq2VHwH5+7PB1+
         qPhA==
X-Forwarded-Encrypted: i=1; AFNElJ+UlGbUQG1flHQd4m4ca9FiKjYpWLvth8z7foKDv7b05FFhhoMw7+TBQj5p73IMdKiksH0A9BykYg==@kvack.org
X-Gm-Message-State: AOJu0Yz9s57lQ86T0iEu1lD/Co94BDYFiEqAObYunqA6jls8VpZutOa/
	X4SuXFRuHRuVbQs/VvgiBxpSAZ3Uo24tFiIGT5KiCwBEDsux2dtQgmOC
X-Gm-Gg: Acq92OFvtrqWUcQrjSLnbLByBr9rY/dzOJ9ns+nQ0fwAd5IfyD9UhhEcS2GLB8VybXM
	nibiIp8LalcwcV8au9LykrGyRK47LWpzos+AhJz4tpD5fLeP4eqnZ8upIvBFDytruOyNGU04y/q
	CjV4P3IKNYhGIkmSk3nwFkNqmcHAE+O+/l932SoMsE9iIXCxsv3HyPjPmVBAVgpjNn5d5iTNccB
	xfJogEr9bJFOv85FJ08Hsu4CH0bA7qXn7sJnjS5R+hoF0zpA0BFFu1y5JwwcXfTUzNjc5R+3eMX
	11hALSym3c0NmTgtsbBsnVSS5rxSZT1rAGGqxaMWTVo9lpL1kiIZEyBcMDxGNZiZP6V3yKh3sNB
	PHx69JYHDvWk8pF+/h9jOj5/FndhsRw0XWunzlClzoM8YklucN2zpNJ6zkzq/BGqNUio5nri7Tb
	wrZB9RHEyMm7X+58J/yAyKK+xDLd3Iw1P1f6AEvkthqCZvh4wJRCJZ7w==
X-Received: by 2002:a05:6820:1995:b0:67b:b8d0:a7d5 with SMTP id 006d021491bc7-69d7ecb113emr2975215eaf.53.1779487596841;
        Fri, 22 May 2026 15:06:36 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:54::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-69d83709124sm1455347eaf.5.2026.05.22.15.06.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 15:06:35 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 3/7 v2] mm/page_counter: introduce stock drain APIs
Date: Fri, 22 May 2026 15:06:21 -0700
Message-ID: <20260522220627.1150804-4-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
References: <20260522220627.1150804-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: xc168wdiqe67ckjontzyhk1oz61tsa9n
X-Rspamd-Queue-Id: D1D6014000B
X-Rspam-User: 
X-HE-Tag: 1779487597-29538
X-HE-Meta: U2FsdGVkX1/nNoDRLOBbs981Mkr1Ba20B9g+uLtOpC6UKU6cfb+Kh1VGGBTOUkxYqNW5oZUtcMsnSHnu7J8Ik02EhoRE/2uCqo+VEVmVc3IA+4R3pIgbUngJcwWHm1UXhMoiGFOTXwvFCFpwu7/9giJnT74/Tze2kJl9oVrg9jA31pw2PeNo+SssoD2IstU7sncH7/WNK6fbIFYAyBh815/j6L1PPs8FhHKsLMHiwLckl8ejx6+mRBrf/UZ5LAzEAYpfn2lBfvW1cAkFeaitONjREbHvgVJj2e1NRObn35fEJkeMfgEyEYyUvcBQmExuM4h5gaMiH9i2YdvelRqZ+QaqEnxv7Y3tELB2BlarmQlik3Vq0YonTfiZU0dc7tAFVmBMOlg7tJ8SoCva1fZWrC0EIYPGeQdX2G+K9NJdNpyNFhZbaaOYki131UBP0GCXyuIMAF/JQyJx1C+0EisTVwzK5ikwrlg6giN0dVNekxTSZzuTVwCDAxcalqsedPsJGDLHjqvsikmHMkZu5JdXRw3C29QV/SkPwYydEFQBWz5/k/PW0FX0mNrkTeDW5VjUgJGl5mzNnqVRIkfgwNSTRiVacaNMcCdY1a5OWv4z0yUqJlyedPZqTtVD8KV+oAyMxz0hrfnu+P3CwpzTPtb6qi5q/ggQ7jKK48SkOy9l8RWbYWA2fo2YTIK0iMSOVUvXgRMK+I13w+KeXaqCl/zcDz+34c2ky74jWJO3aWS21/obASa6WE9K9lzKsS5Cm4RgRUDSwR48744G6PDWL99gSdcrmfKQhaH43pTnAF/dJ6xKJtd3jme8N7S/exykOIX9nfelkw7uZ9ANN2TeWN1DFljnJze78J4ey/lRCfaJDRWksdwAVse2TeTRBrG+uYgciReSBtMfhEANS1IFSLHo522deVLwp8Uphew8coWt29SLR0sEuePi0DXOzdCiLqcmA3knvcod2Q2aYtzrD7c
 seiw2WUS
 TIAYlJp1UQmnWTbqu/Tzj7zpYaD+exm0s0sWpeQ5l517jxm67vGANyz3RWOrDkUEjYFkNlKbz70DpvkxV9YhBnx2KCCMrlIyhgooHrWgnOebI6GC2yTYzDvHcyNF0OALiP9h/XXMQvWL34mzBrhgaMabeqyEIdUap4omSlx2GH2fZvAM2zyw7/dE/55sLnugKzRzKOeF6csaDkWhrkE3lhK0uLYczk4nBxCXzaw/Fg/V2TQr61ubY+5myMpWlbbrO/IPgnmo2yAyX8SvlNLcKn8OtDCYUi8y/t4vncCAAXUd7ZwDJf+QFSJsrkejOmbjnjaXcHVFy6Z2kYd6tKRXZZEnlDdoADLyjP0+G6e/BUg7hZ/0l4djrpHb85puICW9ARqzPgEqBAWRsf4FOdITBliC3CqptjsHaFKVPrGpsaxJk9cG59SNIfTzM7Ykph1zJDEp3/ay3RTOkHmkkhG040Bj1DNYtGY3PyLzm7OjrRPEAMhiY0G88c4794ZXw2xbSL7y71wuXLu0Dxdlg2ZdREujLm4UJHhADVY1GMxGTzEUXgj4eyYksO0J+JKrLqGh8YyK8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce page_counter variants to replace memcg stock draining
functions.

page_counter_drain_stock_local() drains the stock of the local CPU,
taking a local stock lock to serialize against concurrent charges.

page_counter_drain_stock_cpu() does the same, but without taking a local
lock. This is possible because it will only be called from the CPU
hotplug path, where the CPU is dead and there cannot be any more charges.

Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 include/linux/page_counter.h |  3 +++
 mm/page_counter.c            | 34 ++++++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+)

diff --git a/include/linux/page_counter.h b/include/linux/page_counter.h
index c7e3ab3356d20..ffe13224213c9 100644
--- a/include/linux/page_counter.h
+++ b/include/linux/page_counter.h
@@ -111,6 +111,9 @@ static inline void page_counter_reset_watermark(struct page_counter *counter)
 int page_counter_enable_stock(struct page_counter *counter, unsigned int batch);
 void page_counter_disable_stock(struct page_counter *counter);
 void page_counter_free_stock(struct page_counter *counter);
+void page_counter_drain_stock_local(struct page_counter *counter);
+void page_counter_drain_stock_cpu(struct page_counter *counter,
+				  unsigned int cpu);
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 void page_counter_calculate_protection(struct page_counter *root,
diff --git a/mm/page_counter.c b/mm/page_counter.c
index e002688bf7f1a..fbfe9a1b29d2e 100644
--- a/mm/page_counter.c
+++ b/mm/page_counter.c
@@ -389,6 +389,40 @@ void page_counter_free_stock(struct page_counter *counter)
 	counter->stock = NULL;
 }
 
+void page_counter_drain_stock_local(struct page_counter *counter)
+{
+	struct page_counter_stock *stock;
+	unsigned long nr_pages;
+
+	if (!counter->stock)
+		return;
+
+	local_lock(&counter->stock->lock);
+	stock = this_cpu_ptr(counter->stock);
+	nr_pages = stock->nr_pages;
+	stock->nr_pages = 0;
+	local_unlock(&counter->stock->lock);
+
+	if (nr_pages)
+		page_counter_uncharge(counter, nr_pages);
+}
+
+void page_counter_drain_stock_cpu(struct page_counter *counter,
+				  unsigned int cpu)
+{
+	struct page_counter_stock *stock;
+	unsigned long nr_pages;
+
+	if (!counter->stock)
+		return;
+
+	stock = per_cpu_ptr(counter->stock, cpu);
+	nr_pages = stock->nr_pages;
+	if (nr_pages) {
+		stock->nr_pages = 0;
+		page_counter_uncharge(counter, nr_pages);
+	}
+}
 
 #if IS_ENABLED(CONFIG_MEMCG) || IS_ENABLED(CONFIG_CGROUP_DMEM)
 /*
-- 
2.53.0-Meta


