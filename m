Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBF63C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 19:52:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 902366B007B; Fri, 24 Jul 2026 15:52:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D8996B0088; Fri, 24 Jul 2026 15:52:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EE2E6B0098; Fri, 24 Jul 2026 15:52:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C0226B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 15:52:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D129E140164
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:52:54 +0000 (UTC)
X-FDA: 85024718268.04.FD8207A
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf12.hostedemail.com (Postfix) with ESMTP id 1AB5E40008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 19:52:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=F5IZ6VyA
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784922773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NC+t0PVzM1V3bCRy8dl7R5jb/yivKWdDFY9rHZ/PNfY=;
	b=ICj/wfvOz0POpAJ0Jk2uuyfnzAo0/62DvGdspnWWVYepTCr8/Gv7jM2fXARghGKWduCb2a
	SQMwVM/YG9qAwHd/GO5YOEoB2QEfWopVRfS/xg81+yfIQQNNYRJbs9u3HVI7RyeV89+L81
	LYiYV+dnnoCLX51rqT2exRGBLmx2jts=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784922773;
	b=ywZPA7+5k3yHqC/fz0iD4cB4HWTBPjlErZ/JbZ31mp49X1hOGSyChys+xKZIspgPo9JgHJ
	XdD6vo8+/Orj2dJ+gGN8ukALTK80wQlr9OUbrwA6LB0FKlECluSW+f/Vx6Uk2YbAl0wogJ
	rRo2rLwRmMtxcjCdKtzSbzg68jI+tdk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=readmodwrite-com.20251104.gappssmtp.com header.s=20251104 header.b=F5IZ6VyA;
	spf=none (imf12.hostedemail.com: domain of matt@readmodwrite.com has no SPF policy when checking 209.85.221.49) smtp.mailfrom=matt@readmodwrite.com;
	dmarc=none
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47f81a3ccf9so574128f8f.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:52:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=readmodwrite-com.20251104.gappssmtp.com; s=20251104; t=1784922771; x=1785527571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NC+t0PVzM1V3bCRy8dl7R5jb/yivKWdDFY9rHZ/PNfY=;
        b=F5IZ6VyAz6ru/CFVlD0OWB/XnNCoZoHtfN1NLAfCe5C7zpwKsY9g+AV1DIk3Ecbvn1
         fb45YRAMxqQGR1YCsu32Tn1dROepU6+DGdDlfPJhR2ceD7O9YNYDd1SwHAPtpntKm8vM
         U/bcRRxyixUYxBfWNVpVyoA0o5BZlcdb7L71vI9QITOGGERZbD26rXYUVN2Ag7l/kG57
         RS3Go9yW0L99bWm1ltc2NDLUjk8ooIs/WBtI22gFLTPi5/a5U7npXVlHtlJDLWDid5GC
         e4gAeed096yS6j+Tl5J+TgevA8QfesBEv6wcb1uxrXASEEThp/S8B/SEGSvjVdjBiTTd
         Mcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784922771; x=1785527571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NC+t0PVzM1V3bCRy8dl7R5jb/yivKWdDFY9rHZ/PNfY=;
        b=hnq657ION9PWoSjrJ+tySm6WY9hHVIYYWelpubNXNZlbNCEMLw3j/bEdAclvYWf3XH
         ouXqoyKeheI31jUG/pVg8EvCy6oxxIj9TN1m+tzK130yIUhgwo5NjmCcIp6333YvCSBQ
         rtQsnDR2dp4cys1ZB0kKDkuVghfNDKwenl/85CtQJvreBXSfvnoMgaMo6euEfJJMedOP
         XRfJ9T8wm8IbweRarLbuOGLEjogN4zk5BSarsFAm3F/uyGFbcXhH6cngMqYscui618QA
         UHVBnWcJk8Ln7QRQGRa+dv1JyTmK6tSdb9JJsX/Yo1hxQ8xUH6E9kXRSRWk2/hV5+MWB
         czrQ==
X-Forwarded-Encrypted: i=1; AHgh+RoXQMuDDJJCUHxC0HuF7s7TM0TQagbyBYJcbEwegCbaENB4K2nPTAJdr9HsFQ8SIhBcRYPjHoSpuw==@kvack.org
X-Gm-Message-State: AOJu0YwFjDuzyQZCeH/4taQdxzbx/zo0e8GbLD4wsVK94CYOglUCbhqA
	d/WZcNoxzWC+LqUpUGHLmIrh0jfR0vKx9gg+iFvLntoxQfnytSBaepFVRdfaY4SBztk=
X-Gm-Gg: AR+sD129iAwC8TKGcSA8QqzFp0r+kHt9X4AVrIeo0F0NhuStSUaoOiDlIjOjWn20EmM
	PSSWIhCS+Hjic7xX7TW0/l/3tpbkhpSpN8JsPMWI/naYZgpYWb5y1fjZKD7LTfRnrB092jDctQt
	b8UkygMo2OyBJ2d2tx/gz3Z2JXsbGYQjZqZbJB7qkO51Xt183A4UPwT8QZseunsz2rWjhd+iVAc
	+hONWum9UegPnEAoC3lxyYUZ52jTi9IXzlAL/oEkNfRqGjJxFQiF9zMKsuTig/XiEbxiNnUQiEP
	A0vMoo93nk4ZVmr09gQnmCdlVaF4/vsFCifjr9VvghD89ZC8g3dh27gYQyjYEyto/+uF50agTaf
	BVatKKqpeX3+vjY6d7/9TYvdKEl9i9Ng3AYHDXDyrHwkUHfOL3PtWVVrCerdJbP2+fZrJd/90U0
	U4U1Gp
X-Received: by 2002:a05:6000:25c3:b0:47f:6fd1:d399 with SMTP id ffacd0b85a97d-47f8d76ebd3mr11047801f8f.51.1784922771364;
        Fri, 24 Jul 2026 12:52:51 -0700 (PDT)
Received: from matt-Precision-5490.. ([2a09:bac6:37a8:294b::41d:2d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85c6287csm26605268f8f.25.2026.07.24.12.52.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 12:52:50 -0700 (PDT)
From: Matt Fleming <matt@readmodwrite.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Kairui Song <ryncsn@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Matthew Wilcox <willy@infradead.org>,
	syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com,
	stable@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@cloudflare.com,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH] mm/huge_memory: Initialise workingset state before folio split
Date: Fri, 24 Jul 2026 20:52:44 +0100
Message-ID: <20260724195244.3715130-1-matt@readmodwrite.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: juhp5aohpuidfng78oh4kc4wrpgrktfh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1AB5E40008
X-HE-Tag: 1784922772-506890
X-HE-Meta: U2FsdGVkX19rWRtI8lkRreeAqY2L9lv9coJRc6ugvhtWeWHfu+4V8zOq7iPLUM5+HNXK9OlaubpXfUylz1kj/emnnbUvf5opXehIAz/OF/wKf7KuBd9Q8WRE0EK+BnhEAfdQcdchle17GJv4shxOyrjh3iK2DB/5fEnjEg/3UzLlAv+TGoccAZer61ufv143STVwijhJ+UH79nDDXa8k/juYpWPhDf6FL+5iPZ8neo0B0W5heLaN1YNfwkuTIn29Ee2xXjJpOghHzVLGnVXt4S1HiIZkAYa2yyD2QZj1xrgrSk56NV1KZb2l4p1i0qtqhjKS4ZdP+l+r/sU/8AAg+hmuiW+S5fhVVJJh5HpJyT1lFHN5LiGhzRPE9Ohc1CzdztavPQ/HHT+DljvBI6AoNjoF1bQQ/TxOVdTjhqM6nXyRt3h9Fbw1ZIo5GKYPM2kDOvL8cRfsm2VkGVGAeu9CWNwuEgHfGnRE6p25QLI+LGvoOxmfdqDa8zfxsLmg6RegvCZ9SqvZWfDjdjkMyTP15fJup2N/gbGSzFa+vGj3setT+knTMwyAxKusJtg1NM5FuYxfU3jdaYBb7IANq+GiuSqcKgJv694TeoDcAbK7Bs3IBzgB3UmAthsvePrtIGAm5IYMHstSJhCzgAs4VRU+9+O/zVzqNERrFXgWCW8gz9bc3REHN7vskfOAtSXQYMFv1wFJVTI3UpsfWlxEok1HPPrN5Mg0nGlOWYJJUWmO/LHshA9quY3SuYNMJ0g2sxPzyarLZixfYyPu6nszBjsdrqC2rPYJ4wVUHChjQBFd3t9eLQGWS26C24F5g4hDsZb0ZCCLyujKy/to8UkN3j0jKhVq/JII2PWAP+jqfIT3JRszDB8ppVQ+p9UfRbdJ7T4YdqW0gqW5dhuB9vY4VDM9E8Aq2QVglx8JGdgzQ7n5N8LNlZ6UH/Lh4y8xWAnRLgUpAA9i/bhlb240O8mYfwB
 XuM5cgNO
 sNfNA/LlCR1R4zybYlMNd8QSLvcf2YqQQdsZXhfDBsRZbu71o0DksTjwsfh3E58SFv9Wb/XquxqAHvo08s2HTfYiGMHeTrKQJSWuhKMMjQbPV3Pu5TXWSEmUQ2taUNHVS5gfK4q2lCKMuVpq3OQHYMqpCwpK7HbpMW6Ha6vsSQPiQzt16bt9kXAeEBFEEQcgCPDrAFe6Gz2uyh3gy5EIEiYSsMX9OQ7f6R6KKzNLJ6PIqnJlkItYXRW85G34VgAh7HuWEf0p8sRiiKQ9F/MWefPcDUA1/00mNtQ+5+en/OIxUNSY4Sp9aY1t65WG6IYXYQMwBvpXk4LYVh9BQl/mTXFtZzebjkGCynLxYwlmJlSVGDA4abL00f5mVA0AdAFaC9/4GL+brN5FRqjxBhbpdAH8QwSwfciI7uoszNmpO/7ozWu3GFTr8eSAz/cLrHKw2G+GQzSbrE/DfVsqKpktRHO3ov4zivaFePHKyE4PsyswsHP09cclg7B3nivc3kL0IP/R4Gm0JPwyX6VeGPqc3Zph32qHR0Mb8E7HiGB3NgUOjLGFPsLzxiUoLaPIiZAJ7XZknqD+9s0ASdxfJz+0wF6Hav2DjSBZ3+4imek7u0LVrAtUcG6pzIZoIeJ0DWvLBAiGVIWH5tULDZJuqUlyl01ps8+kVo6hiTxgmekSAXTqrbtrpI0nfyRdWwD+3dwMrztjV6BX3PQgmn72mrMQpcPnDjA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Matt Fleming <mfleming@cloudflare.com>

xas_try_split() adds __GFP_ACCOUNT for page-cache xa_nodes, but
__folio_split() leaves the xa_state's xa_lru unset. That lets a live,
memcg-charged xa_node exist without being linked into the mapping's
shadow_nodes list_lru; when reclaim later walks the list_lru it trips
VM_WARN_ON(!css_is_dying()).

Use mapping_set_update() to install both the workingset update callback
and the shadow_nodes list_lru on the xa_state.

Reported-by: syzbot+c5b060ce82921a2fd500@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c5b060ce82921a2fd500
Fixes: 58729c04cf10 ("mm/huge_memory: add buddy allocator like (non-uniform) folio_split()")
Cc: stable@vger.kernel.org
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b5d1e9d4463d..12d0e0b14e83 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4033,7 +4033,8 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		gfp_t gfp;
 
 		mapping = folio->mapping;
-		min_order = mapping_min_folio_order(folio->mapping);
+		mapping_set_update(&xas, mapping);
+		min_order = mapping_min_folio_order(mapping);
 		if (new_order < min_order) {
 			ret = -EINVAL;
 			goto out;
-- 
2.43.0


