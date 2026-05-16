Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6447CD4F3D
	for <linux-mm@archiver.kernel.org>; Sat, 16 May 2026 22:35:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D87346B0099; Sat, 16 May 2026 18:34:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC23F6B009B; Sat, 16 May 2026 18:34:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEB606B009D; Sat, 16 May 2026 18:34:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90A866B0099
	for <linux-mm@kvack.org>; Sat, 16 May 2026 18:34:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 628841C0321
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:57 +0000 (UTC)
X-FDA: 84774739434.06.B0CCEBA
Received: from mail-yw1-f195.google.com (mail-yw1-f195.google.com [209.85.128.195])
	by imf10.hostedemail.com (Postfix) with ESMTP id 985FCC0003
	for <linux-mm@kvack.org>; Sat, 16 May 2026 22:34:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YJXodx1B;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778970895;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JJ4eRCsRtGruvU7OzNvMy5LtAnMvACrX8iMrvGPwu/M=;
	b=yvG1FED+bCe3XZREn+Xrdn57GqWnJPelF9BIIJUCoXzLOseDuUmJE0WC7MjRcs/aFt4oSN
	xJE/NC0nKLUNsrz9m6YAPbVfJZHMWf0pOyNuR3681I2n/LlibFF/1r0NQG88vnUNCXpBku
	350PsczEEIp9yC63QMKParcUu9gZ6y0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YJXodx1B;
	spf=pass (imf10.hostedemail.com: domain of ravis.opensrc@gmail.com designates 209.85.128.195 as permitted sender) smtp.mailfrom=ravis.opensrc@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778970895; a=rsa-sha256;
	cv=none;
	b=azOs+tJ6oOrACEiCuEp1oiqg9+1Qrg0QH2bdWMhWbspi5Lvit27oN/H1Fiol4iNcAsloHu
	c8/XgUwFC0AuMpqpFG2d14GEkWB7BvPYc2oc5Sy0jRgbZRbFbeVHp1gFtv5iscv4MdlsAD
	g/CR78lzXjWYBwrCBVV4+4ufqAY+HZI=
Received: by mail-yw1-f195.google.com with SMTP id 00721157ae682-7bd5dde63dbso5294697b3.3
        for <linux-mm@kvack.org>; Sat, 16 May 2026 15:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778970895; x=1779575695; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJ4eRCsRtGruvU7OzNvMy5LtAnMvACrX8iMrvGPwu/M=;
        b=YJXodx1Bxdbhr/lbJXhKKMhBOsXsCI1OjaxxYEsPChSLzTpY+SJ00apCSaYs533ZeT
         YzAgOfktmmlk8CRcq2kb3p2/xnovwa13SrrbpQdDRjG+JbeZw2TBDCx3Wk9K6M/gX89c
         ObkzFVvqwnXk9YgRF9WbTSny2eg8TACiMFKaeUALM86gbnX6PM0rOknHOcwGMy0AmHfC
         q4YTCqoXwhxnHQRcasDtr08oBVmWfhRfMDB3NfcBpSkv+9YGiJYxU3Be3F8G/RBVg01u
         cTBYfM+D6UkCXfUZdH1IL0yg3sUn2o9s3/F3B4U9brOxRNZVeN/rY41/ON70xMv2o8UE
         CLrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778970895; x=1779575695;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JJ4eRCsRtGruvU7OzNvMy5LtAnMvACrX8iMrvGPwu/M=;
        b=ZvjWJ/bCHFViXXeZwgSusAIveYqCWcyDpKNHl9Nj0mQTm3T7T1geYH9zR87K7cBWQV
         pRUpJxxgvtzXSwP8vptQzVtlyfdo/arj93SesgP9oVF0ytaTHFfafxdV1N0sM7hsTN9O
         sDh3NJ0w1IhV4ZjgH/S0v0+og/7ADw+HrywIPoF8ZzCLyw0RiLiE8KasliPzrDVj3gN5
         HlNfULEJPzm8q5w0F5mclBW61olKS/fpz7//SnIXVrruB50VfmrBrOOadAxh3VBa67oe
         DxlYSMQ8ICPjArbHg6IuMLMLqJ0sBk29ztoStHg9+37TC216FjhKxLlE4trKrCb0tVN3
         z0NA==
X-Forwarded-Encrypted: i=1; AFNElJ+Op8436E2I/YHZoVpbRCY9ATebCkVea8M9nQesodDAwgzPIInj5DblKgJ2g2Z1h2WO5ww53ze9gg==@kvack.org
X-Gm-Message-State: AOJu0YwhK5006YmT5XkGyGDwlQ5e5IxbrlofsCMP9ABV8f0xY3aukPjL
	pm+8nwO6uEq3AclIJC/y2P3W53YOAwN+oy0Aolh0+Y1fye9xGVmO3is=
X-Gm-Gg: Acq92OFvvaR5oEQXKgfXkx6hsPom7+kT39yPKYAcB6rqXi33KXIL6nqwZA2Tdk9KTpm
	VqrM7HtYH3USwzFhu/WkSVtGLJF8hZEoI3RbM52UWnKpHvCc4lU2Xt+yH76BTC6r4bPGG6Q7Hxa
	qoZqstHzyaeNNRhAypo44Y+u7xH0/PT3NmJ7bnsCKLBW5LuGrdwz/gkuEhIoaNuXAFCaGkLaaOu
	4tIy9nK7tMtIpj4cJ7drNmhlAX194+Q17C6Jh66pY2jhQYd73x/0PNw5Lri6G+A2CS9kMOx0KDG
	wVZUHApQkdaT+8DRZcuw06wuSLHWQlcUBaFwbqVYXFJQPx/PJIhNmV63J0viNHE7Dsb2Hqs04vT
	tI3Fj8ny44Hk7SSl9jw0bekdUfHUyUebza1iMonZHvk9zNkBTxy0V70G29tYDgYv9UFY1ttpxyi
	uEzEI+pYuq1e/Aniovyt948qAszRzSAHAiXawHZMQIeAvLljXkX6utcJzPmstBE1f8SAcyc3ppr
	ChDPb1OdDlc
X-Received: by 2002:a05:690c:95:b0:7bd:9ce7:164c with SMTP id 00721157ae682-7c95caea6camr98089637b3.43.1778970894660;
        Sat, 16 May 2026 15:34:54 -0700 (PDT)
Received: from localhost (23-116-43-216.lightspeed.sntcca.sbcglobal.net. [23.116.43.216])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-7cc9cea0642sm643557b3.45.2026.05.16.15.34.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 May 2026 15:34:53 -0700 (PDT)
From: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
To: sj@kernel.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org
Cc: akpm@linux-foundation.org,
	corbet@lwn.net,
	bijan311@gmail.com,
	ajayjoshi@micron.com,
	honggyu.kim@sk.com,
	yunjeong.mun@sk.com,
	ravis.opensrc@gmail.com,
	bharata@amd.com
Subject: [RFC PATCH 6/7] mm/damon/core: accept paddr_ibs in node_eligible_mem_bp ops check
Date: Sat, 16 May 2026 15:34:31 -0700
Message-ID: <20260516223439.4033-7-ravis.opensrc@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260516223439.4033-1-ravis.opensrc@gmail.com>
References: <20260516223439.4033-1-ravis.opensrc@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 985FCC0003
X-Rspam-User: 
X-Stat-Signature: n4wxgh9qqegsuw1sbz8b71a6fhtdsd87
X-HE-Tag: 1778970895-547864
X-HE-Meta: U2FsdGVkX183EGBB/60jCyolqs1IRkNvUWrMEqivfhE0vHp/LbfQxZMpKzlcx1hqWhkpMgow6kMngq+ncXaHtnlyMj1xiMd/IIiA4LcISbY5m4jWgFqHKerX+mCVTWdlBRt0dMhgL4HvsfZyXe5H2GK224mHF+uoGnEXWUb7V4heQTpBbTidIQGQS754oT586sNNb24Nsjvyg7i5K5KEgsOdp8TMh5j0nLgLEmbabiJ3pbcSVz5/MGxm6e5yvqnfLSnacGoZjgGpE8Xd7oV1lWuVKo21NRvl1GqfQDlG6xo39eniZMc8uy/5Y/JomtrqcgdVLnh74wb8Uo9p/QMtzqRgut6weatRyHWYEZsSg8RTrMhuJS7Nrt8x06ODzR53bm4Nro+Fu+JP6SLrz5A6cXyoAEKTusfEQiycf+LbHYO1yYmg3mle6wMrYEzmUnHZaU+q5c01KQsMO63QtavEr9uscvYSjo+cqZWshqh94gXZTdflTV+v+JffKFgMMUznCz3teYT+sqaQxBBIEeGuKqcFMZttpT/cFf/FZcGkZmG18d9/iXaHN6TqDPA3PUFIdqMtsQCOTi3gKCpleRwSBndPy3wiFxINRUMx0/r5Y8iOA6/y76K9kpNPKi+J18GrCtJBEfPjzEBVAoVPTIMmHkztphgRLOcwiQUK4CpRAdmwpNzDZzms+vY5nUL9oR2ccCxPB7IlB1zA1hAvb3keF43v6G1iv1zi3KL91jq6PwkliYTtm5aNUTJ8tcEfdxBUnU+bcjHjooWZfZNBuu4aMS082qKyvqz/ObJdU3y/WrXoSFSbUbQBzRa1JUYIJEUKsQgZKUM0CWop1ONUzkYvSd3HIM81KEY4+RE9nUNdYBnZeyCdkcc5pw6Fdg39WvIpsuKdFC3kg7k15JIMgblgy6kJmO7XH25YPG8LqESYOal45Eq7kL+1luLU3+QvMSPwQO4FSu164nIC5ba2HUR
 30L3/Yy8
 NVdkl4BDY7WA8Bvjq1XQSb118o2sV6HFbyfUbEcvBprQB4jGfBZHu5SM5D5ISMLx1HwSTFKRQwwpI38Tv8NGEyEBVE0e36o/IugrxOeridAnuooMacoe7uOgsVTI9UBC0CyCe0AR5Y2g9qT4vP+8PkKQy63bxDHKgN3dXpF2OD/4AQmCNBYph11sDD02x3DiBhBzIoWLVA3RonNL5PaYPBXRXnx6LdNW/anHFdAft3ypGYsV9FqbMk+tSM4hTdlXFWvJd3GJrdvBVQsGapxAP3vETHXTQYiXxKIzLjwci0LVHk9i/gJWiELS1G4D/JAgI/QPaYtmVhz4Mq8xtSvFjRNSVk//s6XbBAfteAfkRUJXiabf9ejbIhFDSQHebADBys/uBCy+N0K3lhvMslJVAIiV1Ad3gRDmk6PTaxGzfgJY9p5RYYmC5Bpoiwj+7vBmzSOPE5jVpjiVE24+uvj6O0/JEKqoLf4WMcqTSZzw1wJCK5m9/p4OgOkuPEXDNTiDJuV/oo0lAfp8rGBq30/BvM7uQNm99GIuxHgH4V/7loLYViunyODNW58m0aMFFpy3QnyC+/CqvrhlNB9uc7PFG7FXDflwtCqbIkDHxK20szbekCZ5FDXvu/Rw1BWM/9t0rCL0Dmj8cn9+o3Pf5/9jBB/OfxqA9HwQXvb9ZrSiTbf+6MGo3hdgXsHuzpANGcGcuC3Am
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_get_node_eligible_mem_bp() and the damon_commit_ctx() validation
path reject any ops.id != DAMON_OPS_PADDR, which caused paddr_ibs to
always get 0 from the node-eligible helper.  This caused the quota
control loop to run open-loop (esz doubles every tick) when using the
paddr_ibs backend with a node_eligible_mem_bp goal.

Introduce damon_ops_id_is_paddr_family() and use it at both sites so
DAMON_OPS_PADDR_IBS is accepted alongside DAMON_OPS_PADDR.  The helper
also gives any future paddr-family backend a single line to extend.

Signed-off-by: Ravi Jonnalagadda <ravis.opensrc@gmail.com>
---
 mm/damon/core.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2aa031cbc70b7..1e52161f4c015 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -83,6 +83,16 @@ static bool damon_ops_is_hw_hotness(enum damon_ops_id id)
 	return id == DAMON_OPS_PADDR_IBS;
 }
 
+/*
+ * Returns true if the ops id treats the monitoring target as a
+ * physical-address region (no per-task PID).  Used by paddr-only
+ * gates such as node_eligible_mem_bp.
+ */
+static bool damon_ops_id_is_paddr_family(enum damon_ops_id id)
+{
+	return id == DAMON_OPS_PADDR || id == DAMON_OPS_PADDR_IBS;
+}
+
 /**
  * damon_is_registered_ops() - Check if a given damon_operations is registered.
  * @id:	Id of the damon_operations to check if registered.
@@ -1787,8 +1797,8 @@ int damon_commit_ctx(struct damon_ctx *dst, struct damon_ctx *src)
 	if (!is_power_of_2(src->min_region_sz))
 		return -EINVAL;
 
-	/* node_eligible_mem_bp metric requires PADDR ops */
-	if (src->ops.id != DAMON_OPS_PADDR) {
+	/* node_eligible_mem_bp metric requires PADDR-family ops */
+	if (!damon_ops_id_is_paddr_family(src->ops.id)) {
 		damon_for_each_scheme(scheme, src) {
 			struct damos_quota *quota = &scheme->quota;
 
@@ -3041,7 +3051,7 @@ static unsigned long damos_get_node_eligible_mem_bp(struct damon_ctx *c,
 	phys_addr_t total_eligible = 0;
 	phys_addr_t node_eligible;
 
-	if (c->ops.id != DAMON_OPS_PADDR)
+	if (!damon_ops_id_is_paddr_family(c->ops.id))
 		return 0;
 
 	if (nid < 0 || nid >= MAX_NUMNODES || !node_online(nid))
-- 
2.43.0


