Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71801EB3631
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 19:53:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA4D06B0093; Mon,  2 Mar 2026 14:53:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3856B0095; Mon,  2 Mar 2026 14:53:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA5506B0096; Mon,  2 Mar 2026 14:53:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A6B4E6B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 14:53:17 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4C5575840B
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:17 +0000 (UTC)
X-FDA: 84502172034.01.6B9F2FA
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf23.hostedemail.com (Postfix) with ESMTP id 741A214000A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 19:53:15 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fM5cE73C;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772481195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpE/M8Cc0DYeAdsX8W3VyabxBIuEQ5Zyn3nZkaA1QSY=;
	b=lJE2P/D6IUxVUF3YCEVKDpPRHc0rmTTiDBATkMM/MBn9HXZyBrn7ZrUlkPZRqb0E8Tqgs0
	A2rfIbN65b8KrAsmYc+nrT9JHEdNqDsriN1Yo0GoEPylcDfCY8mnOCISOiEk9C3OXLkiFk
	sVxSifFO7R+fp7Xik+d/SpLOfecwXMU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772481195; a=rsa-sha256;
	cv=none;
	b=1rLNZDfkMYbB8WnTmSIM6xH+9/4I+HqqnqromUud/ET9wPFDCdVOaKVUlZAv+ZefzWvocT
	y/d1SiKCU2jTsm7rL4q0FkKHHsoV5XLUlIJRRk4g9ZqC7/3ByTxdb9P6U6ymRNtCNWYo01
	np+v6Z28nNqp3LEyuE0xZD0KwB0Oe7Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=fM5cE73C;
	spf=pass (imf23.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.44 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-899a5cb04f9so61659426d6.2
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 11:53:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772481194; x=1773085994; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MpE/M8Cc0DYeAdsX8W3VyabxBIuEQ5Zyn3nZkaA1QSY=;
        b=fM5cE73CkWQ953uB94ffjp86f/4BSAxlTbLdHEpnYd3rrjrlSn6uWzmj2p25fR2WD1
         iVF1pP3CBwPQKg7Q4ehmiWHBM+BXxeE2+c4aUvjLEyxapKWDx6c5MGHxfYXG/CBfsOfH
         uHOUoBxrlEE9PEh5uesqtUdJpeDwlaITQ6Ptpr5Dpt2MUfgEOZOmJO0LdeJgm0XbYVor
         GrujrBfy61T167QRtvL1rJRLYgsIl4pTBIAoxMDcyXYBLxtsCYgsqPVmllRyKxzeGuH4
         AmodRhBkguY4qTIDc64zFGKrjMfp2JUDYmG42G23ZnNJ1UaUe40HcWdQJ05Izx74VtEx
         skOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772481194; x=1773085994;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MpE/M8Cc0DYeAdsX8W3VyabxBIuEQ5Zyn3nZkaA1QSY=;
        b=uS11PO+xyiV/RTTS4V+qcvgP70+7PRRSpV+921qUV7aziUzY4aKwS2iIkd7/o8I9Ea
         /fhlqIC2tQesLTJ3oiRiLhEz1X84cqAvR7pSAg0yv1z7J6OtL9elroiGyOk53Az4iS1k
         DcftcbEdZKEC6OJNwdc12KlBgF4qk9+ikcSrTGaCoP/d/PPc1EVMVljvW8UJy2ps1UhF
         Hq6JuXCZpoV3OEDJ6fJj5UBWIulBiR0/siUzWh9EvZALhqu+OqkKs8TAGin8ouz90oqS
         Kf1oHUyJgy8yoellZFyYFqvF/USZVwxTzH/llDnMqNFeBHF8foRscEDdZ7Gmi/JiR5dd
         2w9A==
X-Forwarded-Encrypted: i=1; AJvYcCXOQtAZRBQcpVmL+EiKdm8ov0KX5D2Dg+J2w67UzDMG+0fnbksrHrAdS+dt5GwFaU/8KdRnHYFI9w==@kvack.org
X-Gm-Message-State: AOJu0YzTUmUqJ4+08JxxNi5lmYfFO7yBwNEY2ZA34Asxrg9AnwDlcdJN
	lhijgcLXRxkH7Vwg9Qgc71c+ok0dMUkpDGt7A5RiX8j96gvFLaiDLh4G05gxdXZhUx8=
X-Gm-Gg: ATEYQzxKaGDHAsiCYhHre2W4CGJWfcobsIzqtlJt/BmFB2GX1l8X7Qho2xCRUrLaPpv
	IjLRf1/RlnEcNf/zp+hewLF7Qtvl62F6qlwxl2QBkvggfa9DBSoXSn17sfs6xyPx2njOJYdgDMU
	aqOyoF6r8V93qbUMnEHDskF1ojp6aACS/yzJtNZV8SDDsKHmvqpTDC+iWjf6sWtSXchbC4KjIBR
	ay9xH6q7pq3myjPtlOfgrPsxDyKoSpkajmms6eyk+0tr/sXvyQZiRjocQpVZvrAsjcrO7KQBUP4
	+roow3NUHydAujJSQJ9XJkWYTl6xMGFWCGN4GPWQhN578O5k45apjR3eQTPMNU83drjmK2BOCyW
	besKKwyUOeBHdp/J1dcOpQQlPZgL4llk8vBTxcK+MAI/b4aJ1ml2jR7i5tMLigGkcL6MKjcenYj
	hGMzPjckj/c6NB0URli1lPAg==
X-Received: by 2002:a05:6214:226c:b0:895:d97:a2ba with SMTP id 6a1803df08f44-899d1e9866cmr180883656d6.67.1772481194477;
        Mon, 02 Mar 2026 11:53:14 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899e53a0d04sm58618466d6.1.2026.03.02.11.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 11:53:13 -0800 (PST)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Johannes Weiner <jweiner@meta.com>
Subject: [PATCH 2/5] mm: memcg: simplify objcg charge size and stock remainder math
Date: Mon,  2 Mar 2026 14:50:15 -0500
Message-ID: <20260302195305.620713-3-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260302195305.620713-1-hannes@cmpxchg.org>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 741A214000A
X-Stat-Signature: s8nwazg8nr98afia83m8rsjfiyyjcyuo
X-Rspam-User: 
X-HE-Tag: 1772481195-627353
X-HE-Meta: U2FsdGVkX1/XZCpFggMsOr/1GoQDxApDTVabT/kfdjsV494zaShQi7deUUID+dhYSnIrf18ep3YLcYdC7sk18vzJbbcpO0XKEhucbXg0kPYOkVwyEiO2mQ3381mgEphh093d7ljrVhSnJdElTea+ReyaoAcnxGfXlTShhiBQtV/rE4ci8QZ/BO4etsHHb7XOuuETKYDZME9RcO1nb7Wuev7pzoOUrdemaCeECumDWoEH4zy5v8MxOTU6m4Hr3e83xPDU+ilCu5mhV8hUqejWTwQu9FEjiu6UDtJBz8Tmn1Er53rxd7Iv/1/NIm73H4a3TRhuo+NxmIHymqr0m89+xtRVAhiUmpX3B4XSjJ+iRl1e+5rZv/57YGMs82mc9V9KW0O5y5avZL+SjVoMkksHT3e+mwwl3n7S6zEbNIjHwbXN5XN8RL/n1dVY3eOk9w0r0qdR9tBI/7RuG68Z/jhXSBu2XGCxlLB5zxQW8NufjByU62x1Amdo0eKk3I5LIcc9bNF5RPZ5iX1YHRroD1xTohatwjrKts7Phr8Lm095oSv+N3bK98MgLr4Cog/0OKM99h1rI0nZcfkHEmWlBMuFjqVv6dx4Jk7PXCf7+VgdbjjKV20Su5fdxKX7F/Tp3AY54sSfjaHXapxvIi7gnMsYrHIetOVrHAKQB7EVey2lZf4JawHmaUtwc2Pi4LE45ximTcbgGk5619jxz2coZmeYCmq2WJ34Z6oGsIpKStFJF146j792oy6UAlnklXCvZLikPgwk/eCUGplKrfKlPjqIXH7lBRDgKB17/TwpTBR4nCxCBKXI4ybd0415nXh6EzOVL+BCJ68qws8utBFRABtY20jv/o7uLXkHnq2ZIcoUcofAYXGHGDjkwmU3gPQ/N+6q6BhAEL8UzfwQND3nDwrweKBtfmFFZMKMIVBTMKXvYPZrId6ulV2JlDs4Vq4V1LMYMU6Jfq5ToTluHZM9FKj
 ElQEd0Lf
 Jp6xzwOMUvU9fa+JZRXAM07DW+9VCcOYL6d9OlsZqp3vVW/xgEa0KObgdmikXIzrZSFzEoIJry9O240/vSjkhM7+DJogX+g7PQUOq3Ap5jPhW+gimjRPxWX0JWkDlTmhqO4ZfJz8UTQ4UEDKmcryRPw8scHFPWOv4Sxn1gtTWl3aq9o34X+8oHI6qa9aFGIlVawLA4yrw01pfDNGbXbPMGYcnDnG6sLbZmQHAnbPyZ2dr34sHjYDk4YGhgV1+VcdLpDJjtOru185JU5p+NQyABYHTXxWRKBH5ku6E4fAsg3fPwMFHN+lhVFWuzKJz8HT3LesFnwLsRL69EVIaHFQv26GePOx+wQFglSrUkXFUAI/GxvkDiKeaLx1JOaLIGbYaHeunTz7GEsKwz/6/5zSNQbCznzK7Gujz+WJ9GpsnZBQmHX4BrM/d3GyryGpzUAHeeq1A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Johannes Weiner <jweiner@meta.com>

Use PAGE_ALIGN() and a more natural cache remainder calculation.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a975ab3aee10..0d0a77fedb00 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3417,7 +3417,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
 static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
 				     struct pglist_data *pgdat, enum node_stat_item idx)
 {
-	unsigned int nr_pages, nr_bytes;
+	size_t charge_size, remainder;
 	int ret;
 
 	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
@@ -3446,16 +3446,12 @@ static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t
 	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
 	 * race.
 	 */
-	nr_pages = size >> PAGE_SHIFT;
-	nr_bytes = size & (PAGE_SIZE - 1);
+	charge_size = PAGE_ALIGN(size);
+	remainder = charge_size - size;
 
-	if (nr_bytes)
-		nr_pages += 1;
-
-	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
-	if (!ret && (nr_bytes || pgdat))
-		refill_obj_stock(objcg, nr_bytes ? PAGE_SIZE - nr_bytes : 0,
-					 false, size, pgdat, idx);
+	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
+	if (!ret && (remainder || pgdat))
+		refill_obj_stock(objcg, remainder, false, size, pgdat, idx);
 
 	return ret;
 }
-- 
2.53.0


