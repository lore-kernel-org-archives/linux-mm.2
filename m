Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E23CCD193
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 00:46:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BA08E0067; Wed, 15 Oct 2025 20:46:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE5618E0008; Wed, 15 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D5FF8E0067; Wed, 15 Oct 2025 20:46:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6F99C8E0008
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 20:46:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1B98FB5A69
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:46:28 +0000 (UTC)
X-FDA: 84002136456.06.3BD09D4
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf17.hostedemail.com (Postfix) with ESMTP id 4B8584000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 00:46:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fxIB+Tu5;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760575586; a=rsa-sha256;
	cv=none;
	b=d/95r4+cSu4RwDUDNN7Su+583/a6ZlVp29J6DB/0dHsR84KMBli1+2G+aVYtCgngj0IaLb
	qUw47wfPnME7T8JLkno11LbRXIkYsqr0KXUVV18MhGtcmdMwLjLn+gMJzoEv6/r8GYUH8Q
	EgNVneylWu2nalqvZLIcLtpw082foXI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=fxIB+Tu5;
	spf=pass (imf17.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760575586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ITfEFQMHnVg+GhAf8C5TihMmjScErPZsZP+L7HX2Jh8=;
	b=0gyt7iaUjRH43IHGXOh+FDBTX7nBw/4qfnvmpTlc8kg087frQ4UDFTAyua6yZmd8EWSYOc
	i++p5AnVd1xRb4TdulFEUU1J5QKbXCUMIvRLxbWmb1ZLlnXmknkvJ5M2cnY/Qq+enLRAaa
	uXCyQTh1I1NWSsPEoD1tPQ2KlhlOMMA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-46e33b260b9so1298555e9.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760575585; x=1761180385; darn=kvack.org;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ITfEFQMHnVg+GhAf8C5TihMmjScErPZsZP+L7HX2Jh8=;
        b=fxIB+Tu5U0WCoolImVnclu7iPwAicGI/F7PJoqRfqXyf5KX0NJVh9g9gOqeoKD4UTM
         9JHaI3tzvKSeOEBr+Gjh4y/NGqIeepPN0FmiEOlmLO8Eks19bb70zSoBR8lxliU+II6Z
         vwf3SgZkhpSoUSGyn9TqS+SjH/s7H6/LnX2Ikk6ph/4fNjzKaxxGdcZIc1XDdPaVliLw
         bzE3FrMKOLzjdiuaXMbFyBz8az6pAIwjFdh52mYc/V/eDDxNCSlgNoVGsNlQkxSAJS9c
         5PMXNNFB+VNk1kQNjzoXqMnP7O7Yw8WS0wmSWn5Qnp+URd2xRdC+yb6LH71G/QvBq7le
         VQHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760575585; x=1761180385;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ITfEFQMHnVg+GhAf8C5TihMmjScErPZsZP+L7HX2Jh8=;
        b=ZiIqDo7yP8dFADoTGCjK/gKW3+9Lg3vLqB5nupwwMEtyAwq+cSOeI9wcxKsu10XDOB
         UJXkMmAbUm+m0jaX7PHtnHPqFz3LRsxTqHZ1Tyy1WoBi9vcxYLF2S2FjIrAYqSIsj4if
         leWdZio0vNgUjW1AK/I3f4VusAT3wgEHBoS8Nzgz45AYSWs+xG7NEhyiJp6Tcpm6sSfS
         RcG6SQnrinZjg/IYzo3415nCVS+wjAQUY5pUr4Ut0UrDebe94Kh7MFj/tgo+4lf+cynr
         97jlFlAh+UuiDqYfHqv3dlc28qNqN/148c5Osak8rbys/3Gegmm59CxpllGbOxtlu3vr
         drFQ==
X-Gm-Message-State: AOJu0Yx5686u/OHb3Hy5FTE0wdb8wDHHjjlhVAbvZ/Z7rKXxGTc2M1l2
	fseZ0uuPXmBJl7kkSxLqb/O9FdJf9n2F0bGU9q4sUkujUi9XgfJl6Mx2
X-Gm-Gg: ASbGncvX2NIx00n442Q38Oh16DWn9IroGEFRs3mPG5h6LGQ9gB7CVUkD3lEvFHeNBEy
	MqEy03OhoumOP+fvXMimLXgieR5ur1pwGLz2c2+qDTzfALTkrTO+cZcn+X5kkE+iNZoLCtu7oRI
	YNC/6jVtYbZHk+zYhB/hE9K3667o36RfHrUtvQVkoo934ds9TiJzLCFbwmjifkZN4byTPnjFqkJ
	wor4eKHKww9j1RDEab+cj3z6Ds7CMNszpNsRN5r1cK43PiGRB/ntLMKHypm5xbNec0mHvPormtQ
	FxnJb0eAAiFviSfalnolveb+9NUieSZpZXJ+UC9V3+gK5/vv70TupoQahkDxLg5CrUTjopO6g0W
	y+eI/SDaBySFV8twsEY1bZS0F3d+BTsz74bonGk+lpkpl0Pb6VID1crF0pehgrpFl1KTSEnRtYm
	wfsBztWUJe0Q==
X-Google-Smtp-Source: AGHT+IEz4HJosQpp50/E5Ipq6dE8s4XlZvjJCsd0If1KIgaadQe6OxhhPEBZJXNy1qJA06O8r/4JHQ==
X-Received: by 2002:a05:6000:4014:b0:3fe:4fa2:8cd5 with SMTP id ffacd0b85a97d-42666ac4518mr17599944f8f.9.1760575584564;
        Wed, 15 Oct 2025 17:46:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4710cd833ebsm6386485e9.3.2025.10.15.17.46.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 15 Oct 2025 17:46:24 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>
Subject: [Patch v2 2/2] mm/huge_memory: Optimize and simplify __split_unmapped_folio() logic
Date: Thu, 16 Oct 2025 00:46:13 +0000
Message-Id: <20251016004613.514-3-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20251016004613.514-1-richard.weiyang@gmail.com>
References: <20251016004613.514-1-richard.weiyang@gmail.com>
X-Rspam-User: 
X-Stat-Signature: 9dgqfaf4gmjta941wx1uqhocmd8o5h45
X-Rspamd-Queue-Id: 4B8584000A
X-Rspamd-Server: rspam09
X-HE-Tag: 1760575586-298337
X-HE-Meta: U2FsdGVkX18r+HmiBHZF/bp79qNoUmhytupIUDJF5lTVc8vVvk2oy3MspZi18rejSWLQd9Wu1OFPygqTu2gOE9CVKdCylkKrFvrKvyt7JmWCJ6nSAjQHu/Ocyb3noX9Rz1NcgeK8gT9Te1qfDBHSi83gNi2d50NSaxS3fMIr/KadmSrx2Ws/dGi+UCHgyQ8Bx17MBA7pj81FCwVTG0XaMGCWOMI1x9aSqgQRbwAWj5BAQqb0L/oXae2/HvBRGqEUf0F1caqmgSqMXhReO4nvJCU25xyhdYq0alhcvHb1EYqQc9nz8KcRR+KfZbpxFTokZBHwhfTgZOf1q3Q+E/LMmfiMLer6+/l3/pxC4xEqGxUtLPNuSfb+Co1gDrDivpyXqwjjEiftaJXJi/Tz68KFZrhd+iwMx7Yuwd5nGwDFWrC2W2X0UbqdVJivMbTLEyXP/+EIsD1IhUdK6P32gn/EMZlQIfI0NjtRUkgQgn9z7iAFJOAQ9Zbr3qzhkJujAqkAhJSLdh8Nht62W/Gvrju9Phf1i+nUnqwW7lwiSBxbDCIi1Wc66mwYr8s7relvP820yLV7TmtMdh9rEjWo9b6qJqg1y7Q2X6cmKi1v0H+HsB9+l1ILfBJpSDxBoNc5Y9mvlckxfSxMSNT0h7+LtR58QGdedbGgjK2V8jDxhJJ0yCBtdBti0eP2mRT++Twi4Mk7B694Tg5+xvf9h0OgwfAjfWyWsRqE8/KF82QN+nQ1ZvN0MXs9PFHHR2AOnz5EebhqWXA70e6dFtpC1dqFjcwheo9EgmoxSDkvDhr+zE6wrMNSWre7mymFzLAFxqhkZarbFg9VZC02toqfMsk8oOXSGS4TR75ObiiZjju+d6k7s8FoziFEWPQ/WIb7DyxqEZxuQxFmglJdO6qTToH4NXmZSf90z77JzxlYtWTWmhWs8c54f2MWnjprEoQGff3E+rPhIjDyIgYSU44toINilSS
 H67w2Zg0
 BtCa3n19tDKcmqG7GjJG+w8ChiKizz2DFw+hrBsK2DKriflneOsGIJICf1OWr2CmRau4h3obQQDiP0xC4SUFktmjDGBgpNLjaj+REbZijCSH09F2Nluaukhg90C4qWHQkt3JeMJn9anZpgCa8IOK+JPR0CGIaKZy/i+7UG4wDaxfiU/gGeYpMB9bpLtVpdOwlmM//xOv9pboyGO4Ug6YtZDkodcFIGQ1D32MyPfw2MmYtB+8LQY+hQ62z+kQyLhvAQgQkRMg6YHlZYu2oZSiUckM7XNE2YFPIIlCOGho4iSLNnjC055O71AyjTAcurTAi9lz53KbvtRBqm0UNgkzK6Uv+m2ujxYeVicm+YC7opC0XaiOxEXqJTQZCfwpCLaqQ3/WukZwjeoa+AZLOFdoZuenLAogF9EYDvIAZ6YYhmru/MNw3XMCMknNBxfPp7I7Ui+r78YDnHkvTuEckqGmP+qH5+UJorwZjyW6HDhkyzfSqvhn9Cf3/HxGgbppcsCAittk4NgBKTZVuGOHoojFh64x111kpE8mJ4MAi1PPkJQQwxU9af2B6aQrWIDxrgomhH8qCxdN+G8bNgAheIAhRhkTTlQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Existing __split_unmapped_folio() code splits the given folio and update
stats, but it is complicated to understand.

After simplification, __split_unmapped_folio() directly calculate and
update the folio statistics upon a successful split:

* All resulting folios are @split_order.

* The number of new folios are calculated directly from @old_order
  and @split_order.

* The folio for the next split is identified as the one containing
  @split_at.

* An xas_try_split() error is returned directly without worrying
  about stats updates.

Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>

---
v2:
  * merge patch 2-5
  * retain start_order
  * new_folios -> nr_new_folios
  * add a comment at the end of the loop
---
 mm/huge_memory.c | 66 ++++++++++++++----------------------------------
 1 file changed, 19 insertions(+), 47 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 4b2d5a7e5c8e..68e851f5fcb2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3528,15 +3528,9 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 		struct address_space *mapping, bool uniform_split)
 {
 	bool is_anon = folio_test_anon(folio);
-	int order = folio_order(folio);
-	int start_order = uniform_split ? new_order : order - 1;
-	bool stop_split = false;
-	struct folio *next;
+	int old_order = folio_order(folio);
+	int start_order = uniform_split ? new_order : old_order - 1;
 	int split_order;
-	int ret = 0;
-
-	if (is_anon)
-		mod_mthp_stat(order, MTHP_STAT_NR_ANON, -1);
 
 	folio_clear_has_hwpoisoned(folio);
 
@@ -3545,17 +3539,13 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 	 * folio is split to new_order directly.
 	 */
 	for (split_order = start_order;
-	     split_order >= new_order && !stop_split;
+	     split_order >= new_order;
 	     split_order--) {
-		struct folio *end_folio = folio_next(folio);
-		int old_order = folio_order(folio);
-		struct folio *new_folio;
+		int nr_new_folios = 1UL << (old_order - split_order);
 
 		/* order-1 anonymous folio is not supported */
 		if (is_anon && split_order == 1)
 			continue;
-		if (uniform_split && split_order != new_order)
-			continue;
 
 		if (mapping) {
 			/*
@@ -3568,49 +3558,31 @@ static int __split_unmapped_folio(struct folio *folio, int new_order,
 			else {
 				xas_set_order(xas, folio->index, split_order);
 				xas_try_split(xas, folio, old_order);
-				if (xas_error(xas)) {
-					ret = xas_error(xas);
-					stop_split = true;
-				}
+				if (xas_error(xas))
+					return xas_error(xas);
 			}
 		}
 
-		if (!stop_split) {
-			folio_split_memcg_refs(folio, old_order, split_order);
-			split_page_owner(&folio->page, old_order, split_order);
-			pgalloc_tag_split(folio, old_order, split_order);
+		folio_split_memcg_refs(folio, old_order, split_order);
+		split_page_owner(&folio->page, old_order, split_order);
+		pgalloc_tag_split(folio, old_order, split_order);
+		__split_folio_to_order(folio, old_order, split_order);
 
-			__split_folio_to_order(folio, old_order, split_order);
+		if (is_anon) {
+			mod_mthp_stat(old_order, MTHP_STAT_NR_ANON, -1);
+			mod_mthp_stat(split_order, MTHP_STAT_NR_ANON, nr_new_folios);
 		}
 
 		/*
-		 * Iterate through after-split folios and update folio stats.
-		 * But in buddy allocator like split, the folio
-		 * containing the specified page is skipped until its order
-		 * is new_order, since the folio will be worked on in next
-		 * iteration.
+		 * For uniform split, we have finished the job.
+		 * For non-uniform split, we assign folio to the one the one
+		 * containing @split_at and assign @old_order to @split_order.
 		 */
-		for (new_folio = folio; new_folio != end_folio; new_folio = next) {
-			next = folio_next(new_folio);
-			/*
-			 * for buddy allocator like split, new_folio containing
-			 * @split_at page could be split again, thus do not
-			 * change stats yet. Wait until new_folio's order is
-			 * @new_order or stop_split is set to true by the above
-			 * xas_split() failure.
-			 */
-			if (new_folio == page_folio(split_at)) {
-				folio = new_folio;
-				if (split_order != new_order && !stop_split)
-					continue;
-			}
-			if (is_anon)
-				mod_mthp_stat(folio_order(new_folio),
-					      MTHP_STAT_NR_ANON, 1);
-		}
+		folio = page_folio(split_at);
+		old_order = split_order;
 	}
 
-	return ret;
+	return 0;
 }
 
 bool non_uniform_split_supported(struct folio *folio, unsigned int new_order,
-- 
2.34.1


