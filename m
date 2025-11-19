Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD003CF6495
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 23:53:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E16906B002F; Wed, 19 Nov 2025 18:53:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC7DD6B0030; Wed, 19 Nov 2025 18:53:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDD7C6B0096; Wed, 19 Nov 2025 18:53:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BBC146B002F
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 18:53:12 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EA1A5BA94A
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:53:08 +0000 (UTC)
X-FDA: 84129010056.13.C092645
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3C7371C0003
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 23:53:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnY7g93p;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763596387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=JnOOo5ncytdwKVtZqcSLcwiXzE3PwnOveMBhVLi1LEc=;
	b=pJYyEQ489y1CV9xeiQFRcIFgSuEPaeCj8TGSSONq1qCCqi170ASUVy8ntjEEAfa+7pBYsr
	/7lBrfMyM4rIbsAz4Ozvp8g2NoJkTT9Fd8ZrjyZRJqpZPMsH2Y78b5SFQeuniLHdpzTRbE
	LEJfHezWCGmiDRILA5SetmQ1DIB4dLc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=LnY7g93p;
	spf=pass (imf18.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763596387; a=rsa-sha256;
	cv=none;
	b=VFDIpn/4TXiohyrW6Q5zNsGqZzXH1dY0fbszDPUy3V0M7X1k6zWKLSllVE7nvznu1fF7Oj
	VwNguhDL7wLRRa2hByzdVNHhLqy/nI57azW4IoDL4zSHdUN/T8S6pgHYzLAwVSZwXaR1aR
	69NZ8USBMoQkENgTdnrkb1fe9Jzq2kg=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b7633027cb2so64498566b.1
        for <linux-mm@kvack.org>; Wed, 19 Nov 2025 15:53:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763596386; x=1764201186; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JnOOo5ncytdwKVtZqcSLcwiXzE3PwnOveMBhVLi1LEc=;
        b=LnY7g93p+v4CeE1PA0fzS2zznDiKogpZUQsGI3lpZ0G+FMv7x7xSVHg5mUV09a+qZd
         L2FyzDOym6GkZinfYE4qebh3VCzxRZiR3jXkLY2HoH3coPXr3s3hGJoeBpXFJ8knr9pa
         yHmZMJI7P1sflDqkuW0Vv3EFeCUOcAzYOZtjt7pnsOwj9MRnaEGbytahzbQxbk7VcFBR
         cpouN3ebKb4DRWFfG0rLxkb1aQZ0/4tckoGoE6e5loDT4Bi5BQ9vX451w/3Gfrdkw3x8
         W5h/3AYPkzI49jCBtTng5Nx/tZyrnM6FxEpOhQEBdgmoVzg5YkDmTbdD6YoK7j7MSOoJ
         0u4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763596386; x=1764201186;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JnOOo5ncytdwKVtZqcSLcwiXzE3PwnOveMBhVLi1LEc=;
        b=v53d/FVc6tBQmo3WGNmrqzB0s/OoA2PEa5ahAaKXx8jdBynX66AXxPHYkcQtY79nxi
         O64sc60O5DQcpcEHOk97WDcNzQMJwJxU6fna4YvxhEcH1cdvXqJSJvyOSkkx2gVd1vCH
         oDMoALv6t1/+xyh8gzaAWAjk/YNEx37mb0N0sZxSkPZOlo7/s9UTRr+wdyXgPXrRTSpe
         NJcXKperwlUR8mu7da1GLtYgJdAioCka/1/TDjVO+Pgl8hLbNqTMISAkYvj22wbI1U5u
         X5u+c3SPNB2axp+dgwLPJqGOB5SCwK0e/8a2ZC5xxwl4j8q4LrgkuURc1b7kBKeLRk/k
         jR1w==
X-Gm-Message-State: AOJu0Yw7PobInjgtucTftTNQ4Ryc9QUPxdukBtWIR5V4jBq5s3XLnUwI
	2Gk4QLaOXHph9ETTHuFEVP68wpHExmBE+pMkbw3ayUvp5yChgogJQxvvIT5dAQ==
X-Gm-Gg: ASbGncs6P5X51tZDwpfbb7YMDpdIhJn7np2EyauaZtuLDR+l9wv3Vy1zudh9BAhLSHU
	j5YOewf0HMycg0Lbb7/F6yFVuDg40mx8ym3LrErrsLn8Suxsc9RlQpwxU+iR6ibixGli29TuwkL
	KIEqc3aljubhLKXszW9hGGVL6UGUQfABAEKrITCg8jvnmWdq6co6uMQkaxSWNw1bMyALyXIuNNh
	x5iUxgivJdySUGHKOHhtY/gmxc07Vml3n+5b180HqKJDt1wY/RHsNbU4gFF35YotviaU7iN6k+U
	S9b6blQGhIzsIY5YNT/VtOOc0EXvgb1uCBgbHr+zai2Vt00Low9eov6fusZVDXHZStoF+rEX4lI
	SQNR99t0DQuy775CCV/nowe7zDif6jxadhcaZ+T6w1t8SlJesHYwChR8HCSZFoN5KHYyeAFtLaV
	Q0PXdixxFG5p0B4Aaeqh/a3qxd
X-Google-Smtp-Source: AGHT+IGkTPnmhR4gMTnNbAhjowqyAFNlU5ODY9bQ2xesxliBe0zfnRE8ekW9twCPyXvzIhFCmjCY7A==
X-Received: by 2002:a17:906:dc91:b0:b71:df18:9fb6 with SMTP id a640c23a62f3a-b76554f2f8emr95563866b.26.1763596385574;
        Wed, 19 Nov 2025 15:53:05 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cdabd0sm63024566b.12.2025.11.19.15.53.05
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 19 Nov 2025 15:53:05 -0800 (PST)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	stable@vger.kernel.org
Subject: [Patch v2] mm/huge_memory: fix NULL pointer deference when splitting folio
Date: Wed, 19 Nov 2025 23:53:02 +0000
Message-Id: <20251119235302.24773-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3C7371C0003
X-Stat-Signature: htpz11srn7c7zumyo314b65k4eo53cqm
X-Rspam-User: 
X-HE-Tag: 1763596386-980946
X-HE-Meta: U2FsdGVkX1+l34Pd3IHwtt/zfgHlwNSKjHwRczlBQb9I0dTnGVqbefMTFyNWHw++Na+oA9fe9AYOyMs+VVMFAVRVz0UfhR7ObcHBwzA4sr+ed/g7bklv86FqXBoGx4GvRM0PT61bBKnG7mkcYtpLLINqs3FyM7T378odRJIT3QWXif40CHvQdC33Ut0MQNLuf5WPB8SZwMup/MhRZiZaT+PGAr94VE2M1AKBEKD67wf0BkL4frXXsryr1GGyGJcqWTELczNbZPEKn2BgXaSNakYbJ5342ziT2a9TrvGg3TUsqPQS4vKHEYeRbC1PzDsevh9A7li0xEkMbRdHEpKieXNbajBBV7ONlN9ICRoyh5nsVMYys8wtMP2Ht1iobC+EN2xisUBWDE4T2t96rNP2Qh/3QI6zZEvNkXR4TpsEandUHa0CT1GVwxFMC2ozMqJLbBW46zREYtGgjQaPg6XkeA7PSmzifF8M//Nf/tJdAIvApNtr5rdgz04ctLgc+JlvV2EvxjCL5ZJgAgzipY9QxBPYzRVI8DEMVT5yrWAd84fN/aWj3XXY339EiItTiQ/AxtynVIuLOQf35DJ9gFhyNO4sybbmgaexBoerf7a33SuE8BGPPeJdnALWsfh0rZLeZFPkpVGklEbO2JUXWoXUWVrWtg8uYNTw+yH0/IbpB+HNTZaj0e++TdqzdacVqpE+psrPW3ZfE49FR8oi8gkez9lhMF/j6R5X+i+//s7XXdgb9y+d5wfDYqSKmf35i7zm/PsioTuLj2iVSXz+Ag/FJwVzBkBrpRT6z3a22mgK2OW1t0Idn8po8WjN+NsD3exhwpfq7yqUwtraMFHN2USw5dCv5LcfzfCqg2+AF+ljr0a0G4UJOeKeewJxIQv/u8sGlX1pbtGYMGhfMK/Dsi/0W1yKxczPoVmr4qiNG1vUF2ax3o+k1BBxbv8hssEt/9D+FY/RUs/lvZuLQs4pbJi
 4T1+4s3H
 RjdIGgn9fBIKhsiUPTCBSLDS7UTTGT2ptsR8rW8Wk5ryNB5a9chVkt+tBQ1QFLgqDSMp3vlLKObuZU6/Wi+2Cll3eQh6XMEKAH6uwIBKakh+JLuyvhZ7HADOKi5rovMJA+QnnGkYXN4iZTmLeZMkyltejfqe4lUEwJcKrEOOAjtMiGx88rmWiNTV+IGNoGhM3/jD6Mdlxkjnwxo7xwJg2dWZ753s0b+blYj9U0uuHcpZxUcI8RdVe2A6X4qvlBVMOnRKjziuzS0Or2bWVKjN7+T8a0qqlUVoTCMvTp5oA2Fkyxn0mPHQiL9ewNlzuvJ91b/5AFHdWY1C3aFXkJSAfXwU/esgahhZlBIX8J4jye/NC0pNWwDQxwH3SHsKA5l7rV1bDNchzSegD+RMO5yjwHusgK5s2eE67xhe7wpqPaDgrF3s/iGFhHywz3l+d8Wdo3cCsdnmTDc2INqNJyuzQO3ZmAH6M+yR25MFkfou0np5xmzyoxlyVdDq0mqjZLHNRVhLkVnzviQjXeszVbwXCmQMY2+65Cm6I77fXkBCvtbBll5WV/zx5GJVOY2ttEWcL8+aJBY3oGpqg6D8cUpkOeKilFxIvhQnw8DYxwK+kHGef+S9JVgomNxwgbQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit c010d47f107f ("mm: thp: split huge page to any lower order
pages") introduced an early check on the folio's order via
mapping->flags before proceeding with the split work.

This check introduced a bug: for shmem folios in the swap cache and
truncated folios, the mapping pointer can be NULL. Accessing
mapping->flags in this state leads directly to a NULL pointer
dereference.

This commit fixes the issue by moving the check for mapping != NULL
before any attempt to access mapping->flags.

Fixes: c010d47f107f ("mm: thp: split huge page to any lower order pages")
Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: <stable@vger.kernel.org>

---
This patch is based on current mm-new, latest commit:

    febb34c02328 dt-bindings: riscv: Add Svrsw60t59b extension description

v2:
  * just move folio->mapping ahead
---
 mm/huge_memory.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index efea42d68157..4e9e920f306d 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3929,6 +3929,16 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (folio != page_folio(split_at) || folio != page_folio(lock_at))
 		return -EINVAL;
 
+	/*
+	 * Folios that just got truncated cannot get split. Signal to the
+	 * caller that there was a race.
+	 *
+	 * TODO: this will also currently refuse shmem folios that are in the
+	 * swapcache.
+	 */
+	if (!is_anon && !folio->mapping)
+		return -EBUSY;
+
 	if (new_order >= old_order)
 		return -EINVAL;
 
@@ -3965,18 +3975,6 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-
-		/* Truncated ? */
-		/*
-		 * TODO: add support for large shmem folio in swap cache.
-		 * When shmem is in swap cache, mapping is NULL and
-		 * folio_test_swapcache() is true.
-		 */
-		if (!mapping) {
-			ret = -EBUSY;
-			goto out;
-		}
-
 		min_order = mapping_min_folio_order(folio->mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
-- 
2.34.1


