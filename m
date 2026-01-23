Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EB1CD6CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 04:57:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99B646B03B7; Thu, 22 Jan 2026 23:57:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9737C6B03B9; Thu, 22 Jan 2026 23:57:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD466B03BA; Thu, 22 Jan 2026 23:57:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6DDE26B03B7
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 23:57:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3E52CD252A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:50 +0000 (UTC)
X-FDA: 84362021100.09.BA594D6
Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6ECCA12000A
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 04:57:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nBdf0/ON";
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769144268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W2Hj3YMXyp6jb16WaA5iRCtpYS8eji7c2VCvrHXWtMA=;
	b=0F4jQf3lvxMgHGU+jp5yxqkamuqeGcps79Gl8wCHpXuJG4CHPIVm8KUA3cQH52qc8HJ/vJ
	JQeql+z9F3uStElbN98V716l2x8KKZ3z7opslqTDdDRa9K9BfHaZ1WgaSockOs0FWO3ip5
	USVvE0gqIZh+cyx7XB2MJMWzuHSGAsw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="nBdf0/ON";
	spf=pass (imf29.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769144268; a=rsa-sha256;
	cv=none;
	b=W3muACaNyU9YiyTixSG8gAgyCNplLVgoBpU7WrxcWL3ToWGDUYxv2sHDmOg3bFaI1ecmzk
	DviN9a1qyDujvDxUixrrkV/jOsEvnrbIbfh/JPgpSQm88kR2vZMJIZKJJNz4C+OQ7Cce6F
	idfrRagS0SFEL0D366crtUZ5iffMl5M=
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-78f89501423so27565287b3.1
        for <linux-mm@kvack.org>; Thu, 22 Jan 2026 20:57:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769144267; x=1769749067; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W2Hj3YMXyp6jb16WaA5iRCtpYS8eji7c2VCvrHXWtMA=;
        b=nBdf0/ONFu/W+gBN2JP6yzboYSXZhe7y6W9R9i8m6vTmy4PyAvSF5rxEj19AuUcCEB
         0Jl8DQYTGWIHo0Q8AWiFP2CYaZ9fZV1lzBuwfoSY6Z8jVE7OoU/a5BsIvBLlZajm06ji
         SUs0gNcWbVxpVbZlrmuwlNTEUJlHfp93gwMr0M7P1dZ7uv7F/rw1kPAQZSSMJUh2A0Vq
         qAu+VAqshUgNzOEjwuQ7f/6QLJtgd/8j5kaB2S7uUELpaL/IUCzk8GdvAIIZZKuW8nFm
         R3Dd7FCRylDpOQNpwDabN+isjNI4FE61qb5lhptmgDW7uXO5LLAq+kpL2nX6/uiIMCau
         OPsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769144267; x=1769749067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W2Hj3YMXyp6jb16WaA5iRCtpYS8eji7c2VCvrHXWtMA=;
        b=SACF+Zy8lEGMsD9mLnYsYIEB7lRArcq7s/JsZi/lUrSV3Q4ZjMIDtWFhHANlijieZ+
         MG8W8QFMprXaL8XQNFOtK1ofoFqIqL/TTtn+sA7HqUJmhLX4yX40L5pCuPH4bWXyjKso
         piiMndponO8hGj8teF1TBXPJCB2Rx4hGVY5BeOH6YZoML3tQr/QmcYWHCvZ3A7b4bsO7
         kcNCSLMoXDLF9IyJ4FaW9g/Z5KzIx/EnMp9CEJSVu5HerjjBtJFawiOUR+cNdI4MgEzT
         tcPvHyMfE3SNQAONSGhlQY0y/lmrjg/vYZyuuNNMXMmXgul/IlebFQOQlrYK6DNH4RFR
         8jmA==
X-Forwarded-Encrypted: i=1; AJvYcCUeo4sVGkuHrTYrkZTJyfu50UbWipn6kTVYBosAL33IDnjkFjJqU17UxxEdC+g6rKlcg61vU15o8w==@kvack.org
X-Gm-Message-State: AOJu0YwsGkq50a5rKXumkGr+qnRf9R1ZZBOkwUmky3zuL20oeVXw9cxD
	sQv45XRTsHYI3zm0WXmPS2aId/hY53R3tPelf2iMssYzbwitbQ8HQ0U=
X-Gm-Gg: AZuq6aJO62oP2c8jBD7yv4D2UPrSt0kW7H0f2JaqZk3uo2IioQ75XI1DyevQukys1wx
	binMmQ98yifty8REuR4yc0Xf0ffrEgnpn44RolfXmFQ6N4YU0jx5v5u6gH66l+0v/vSnvB74Vty
	vVOyKqL1KyrjdDOGDF1lKy3WfNEqpwyCQplm24IIuy1NUBNdpF/p1mt3BXsRESRwKos/QuaUIWf
	VOoI3B60JnC2vSC3EmvNwtiICUKpLpSZOlgMrC1tV/d+QgFEEXQ3VnAgkuKcJDr9GJB5bL3hmW3
	OVJAmLUT2xGjnqVuskAjri+QbCI1tAv3eWoVgm5sWzZ7IRopqpWpu6qMKMfisRJo0jSBki03ZfG
	uQZcg3IvBYwMOTpLLURbFCjfynGtiqQRsOd+gxIc6lCry1DnbZ52BEssFF9RNcUYPICb0dxCgQ3
	QtT14WIvigD06J2CYDci4Xm38N3YpAieWBTgOkEOoI3KqUnhb6S5ZXUCi5vbJqZg==
X-Received: by 2002:a05:690c:688f:b0:794:1f46:79eb with SMTP id 00721157ae682-7942a70b7dcmr45404977b3.5.1769144267450;
        Thu, 22 Jan 2026 20:57:47 -0800 (PST)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7943af14432sm6354717b3.8.2026.01.22.20.57.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jan 2026 20:57:47 -0800 (PST)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: sj@kernel.org,
	akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	Ravi Jonnalagadda <ravis.opensrc@gmail.com>
Subject: [RFC PATCH 4/5] mm/damon/paddr: capacity clamp and directional early-exit for node_sys_bp
Date: Thu, 22 Jan 2026 20:57:27 -0800
Message-ID: <20260123045733.6954-5-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260123045733.6954-1-ravis.opensrc@gmail.com>
References: <20260123045733.6954-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: foktkdm5nygeqtq96m65h9cz4krqism9
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6ECCA12000A
X-HE-Tag: 1769144268-833635
X-HE-Meta: U2FsdGVkX19/QxALj36ffSWyWSIb+tmlLCHAJdl9qIxkKSm5KOBW1KBeORkBY5El0zxKXox7NzZaNJt2BwIVl1klGWuTskOpoCtc6NTdhZiUEnJggWWNgmzIwYvh6vMlxVunC4LmvUo+inl5JnlaM09x4ltVckpS495EhKKjrONCSVBgS9/jMh0fawShVKx2Eg/vyNTayMTvhtPzIkOdf5rbNSQKsAI3biliD1emRBZukRXkLJBZnOIlV/L+2/9jDXLB/DjdXEwAqq60C18NivIXM9H9gW+wvW+MazgRz/srk6VaWDI3i/tFP+Ijye8r5Sn9+YwvuzJ4mAwZeWBEllEQesQko8BgPeMiv7QsN8VhXIC2CvzPIxEdGFzuRnHwmBKNKLvE/HMhhIYPgGkINoGbWebPPvccMPEDhFQIkA1PA+FtQTd2IxC8Sm9GrA9AgL41QkqD4SbQnZIPD/qXA9YGb/RQB3XRf0NwuVWAH25u7JuP9yXmOGjBIaZq4Z3oFGt6wNGHa0x4Mus78tVRlilN55kJ1prO5DtuHh6r0o1cjrmL81Pjje3HeWr6Jk1O6t3/oKxWUzxm8aG2kdLGdd5uRNvHLWtRJLYVd2bT1zgKFEoS9kmJxHgjDa1UyQ0q/X6ZDNUOmUK0LEKdj44++LtZZEqp4p2+fLRFREkI/Hteo0nZ3rcF2HPLAELCSBWT9fiIgnlD91vpCfu9W0x5YhRsr2DkXpT3O2s3r2b0N3Wn4fGiDO7sEB+6BmQCU/9hSQfvYqsTIdRhWZCMLZy5gO85Ga0XdJwt/nMZDfUuuvgoT3BF6kGn30Y2JIA/t/dRMXADYAlHqrGXj7lVqCmFjIGBnRmM8Ixs2t5ZGgObsMCE0k4wMaZGGVBlle0qbUMl9rcbiWWOluV9gSlhcochcAzf+3iPO7fKGVllj5LTff8adY9MLyb9mgjn8J0trVrCOs1mhLEObjU92GTFZBx
 Tb9FV0cN
 DO/Gqmq1BoCim9gXxCLbymra9Pl38JcByK9l0MnCtzxV9CBPsdsXNs8XfEfRhblp94y67IIJHIVll3TswVOnflZaAP+/gX9XWl/mkLOacR70eUU71Veq8rlcGZSMROen1vUArumpyleuFPVyj2oj8scfdKBIlfr7YSHoIvg82SQqa0W3n8th7jEDmnBBk41V6Q6OHAQcs/wuJvnawQjISZkNqAvkcLTA2uRV9GGwttjhKyUDvySmmv5UZTTolFv9ehpNnxWa5XF7OfNg4IA6g3GCD3WvmyJypJ4P+76K3y2B6nO7rRFUemhQ+miZCIjZw7Qs1teCwxqPY2dsQXASOqvkDHuy2nmZDyXO0hC/RUoV3gfuQ7l4NMwYBjDMHVN83qSygA8Ji/cSTu5DrvBJb1tBMC9fINlAfn/URkKDCXiP0oP5PTBZoFDNpKeVSYDZxyWj7Y2AI9FMs8gN1X2gwIIBnUF5ezx5P2uN5Ri5hDkWZA9Q96qVPCH9wMn6nk3xnXCn1uRHWfJn2SzoDbZH/JA8xZATjTNTr/NNTRLXd7RSzo+MduxYAEbAb+EsjrCaesZZdOjD/HzrVVfCDljZo8fDFUTtYlrir8OkkDD2C45JE7t+s/sUuDeq3xmljiu6nOVxEr0Knr4mnTqYv+hiH1UP0wA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Clamp effective target to node capacity (bp) and skip in-migration if
the node already meets/exceeds it. This avoids oscillation and
unnecessary work in two-context DRAM/CXL setups when quota goals
(e.g., node_sys_bp) are met.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/paddr.c | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 30e4e5663dcb..64dbdd2196a5 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -300,10 +300,54 @@ static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
 			sz_filter_passed);
 }
 
+static unsigned long damon_pa_node_capacity_bp(int nid)
+{
+	struct pglist_data *pgdat;
+	unsigned long sys_total = damon_pa_totalram_bytes();
+	unsigned long node_pages, node_total;
+
+	if (nid < 0 || !sys_total)
+		return 0;
+	pgdat = NODE_DATA(nid);
+	if (!pgdat)
+		return 0;
+	node_pages = pgdat->node_spanned_pages;
+	node_total = node_pages << PAGE_SHIFT;
+	return div64_u64((u64)node_total * 10000ULL, sys_total);
+}
+
 static unsigned long damon_pa_migrate(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
+	/*
+	 * Capacity clamp + directional early-exit for node_sys_bp goals:
+	 * If we are migrating INTO g->nid and the current bp for that node is
+	 * already >= min(target_bp, capacity_bp), skip work this interval.
+	 */
+	{
+		struct damos_quota_goal *g;
+
+		list_for_each_entry(g, &s->quota.goals, list) {
+			unsigned long cap_bp, effective_target_bp;
+
+			if (g->metric != DAMOS_QUOTA_NODE_SYS_BP)
+				continue;
+			if (g->nid < 0)
+				continue;
+
+			cap_bp = damon_pa_node_capacity_bp(g->nid);
+			if (!cap_bp)
+				break;
+
+			effective_target_bp = min(g->target_value, cap_bp);
+			if (s->target_nid == g->nid &&
+			    g->current_value >= effective_target_bp)
+				return 0;
+			break;
+		}
+	}
+
 	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	struct folio *folio;
-- 
2.43.0


