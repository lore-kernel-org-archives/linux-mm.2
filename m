Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF371CD5BD0
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDF1F6B00B2; Tue, 26 May 2026 07:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6176B00B5; Tue, 26 May 2026 07:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF34C6B00C8; Tue, 26 May 2026 07:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF2426B00B2
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:28:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50CD514016F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:28:44 +0000 (UTC)
X-FDA: 84809348568.18.9815116
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 7D969140009
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:28:42 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uHmNJCak;
	spf=pass (imf23.hostedemail.com: domain of 36IMVaggKCJ0G79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=36IMVaggKCJ0G79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779794922;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T2QBGqDxu1pEa0HDUW9WH6vK3RxwxPcJXfkG/NS5ntw=;
	b=pvTA9BoVwNlEskzb1ggX9SzdQMxlZdEVYA86+nlngAbllX6NeU3KbLnCWN4/NmTvhlqF8H
	hRdNyjnnsEcReSARPnl6bbH4d/b/t95nZLPQp5R4CcCXtAK9BnTWNjZo66TyQWj1eRM14T
	PJQI4D679Bb1iQtDWjmcdXh2f3WPvRw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779794922; a=rsa-sha256;
	cv=none;
	b=ZY8FU5OQjfH9QUXc3jsgZqCid0S2gzNv294ehMSoXT03uGZ6FwjAODDKY0BBNSGz8lLRqj
	ZV711jCQSgGrwg/+FmGvSZX7spY4q8lpsQSI7tiV8akaNwLVIExbe5M9ApPSqNaV75jOu8
	Pv4wt+EirbNg9e0V5I5c9c545zPdHIY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uHmNJCak;
	spf=pass (imf23.hostedemail.com: domain of 36IMVaggKCJ0G79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=36IMVaggKCJ0G79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-49048e21ea7so18122615e9.1
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:28:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779794921; x=1780399721; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=T2QBGqDxu1pEa0HDUW9WH6vK3RxwxPcJXfkG/NS5ntw=;
        b=uHmNJCakVE/a5/ADBt/e0kGAoMIP3zp0lpiu2QhKrQrXqHm+eL1U0Qjh4fSwQj0V35
         TV1TSNpbscL2TuwVQwpIkofCCsuysHWXM8pftSLTCGLQmgX6rQQAaG60VdYBm2T17koG
         S4ZAxlcUSut1/toO28aR4tDgWU5GFmXK9+ylL3UxcZeVR6hZeM0xWfm0utrk5KlmVIT/
         LZWxWbX/cVmqMLc4P7yB5dvrvSw62N+0NcGoI4dWt4CPb9+wD+zSS9Usk+HY0rsvlsGg
         hJoMa1irR/AfbfWcVgMsOfau4h5wRehHOnNVm2AWU7mmsdoXu17DYUlUMfSyVZXHatzJ
         Cm/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779794921; x=1780399721;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=T2QBGqDxu1pEa0HDUW9WH6vK3RxwxPcJXfkG/NS5ntw=;
        b=iQVNhCsxCWFjOS+MPcr2lKPT61XJVkRgj+isxbCQ5eNgGFQ5dCiO/2gKxlIo+afAsl
         qMT7nfnqlnyqkxXxl504683lrmdHlNABXU+khrDHUalPanN1IacHoPmEXXr/8cMkY7wZ
         6qj9MaxV5OUwywq0UNYJ71wm8DSJqB+rUFlm677dtUGWmaktoP+mXD8vTJwdBAI2w6g9
         nRuxdyVlVtf3hIxV5gXX1eLihSfa+6jX2+29WP9NdxLyPpZ3j3gPzglqoiNxd+lpUO+9
         corETDIT0b8qXrX0uicqZPe4ylVeXOyuJEDN14S6NgjapvDNA8rIAd56N6b056z7FBwr
         489w==
X-Gm-Message-State: AOJu0YxpHrhIxKgA91HZmJCpPcn4IKco6CEgFIdadtj1Pno5ehyLAHr6
	Y7BjkAQjfod+JfjbWQHOGbETEeRFJn2Q7wvRpWTjGKdGysGUkIqoU9g6WcN+uwPUWTFRjePSgXQ
	z/ofXijTh/7YV7Q==
X-Received: from wmsm15.prod.google.com ([2002:a05:600c:3b0f:b0:487:304a:7fdd])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a7b:c7ca:0:b0:490:4b89:5372 with SMTP id 5b1f17b1804b1-4904b8956c5mr154388755e9.11.1779794920584;
 Tue, 26 May 2026 04:28:40 -0700 (PDT)
Date: Tue, 26 May 2026 11:28:36 +0000
Mime-Version: 1.0
X-B4-Tracking: v=1; b=H4sIAOODFWoC/3WNUQvCIBRG/8q4z91QlyE99T9ihNM7J2xTtEYx/
 O/ZoMcez4HvfBtkSp4yXJoNEq0++7BUEIcGzKgXR+htZRBMnJnkAqN2dNfTFAw+l1nHSBZjooi
 m1cRaxa1UPdR5lYN/7elbV3n0+RHSe39a+df+ou3/6MqRodXGDvLERE/q6kJwEx1NmKErpXwAC gmZrMEAAAA=
X-Change-Id: 20260512-page_alloc-unmapped-prep-c3ae0381d58b
X-Mailer: b4 0.14.2
Message-ID: <20260526-page_alloc-unmapped-prep-v2-1-412f4d486115@google.com>
Subject: [PATCH v2] mm/page_alloc: remove VM_BUG_ON()s from pindex helpers
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam11
X-Stat-Signature: cemszsg9hhqbxxfkz96efs3aojnf1m3f
X-Rspamd-Queue-Id: 7D969140009
X-Rspam-User: 
X-HE-Tag: 1779794922-738685
X-HE-Meta: U2FsdGVkX19khOhV4AIHAf/u0Wc5O8I9PQZW+luv7b2+ODSqpMP+OxSALvkjqc0Tpph1N/eWUfwRI+UoHHUwepXuPWe7+w6X7WGy7spC7YvyPmRzTaDm1n0WwiCJUoWD7Q3rE5d3vbtoVLH3yzFoMUz5FIdGYrQWeWfVAS2XyHbRjzEjYs7k1txbm3y84xChEhLuuesmilWmVGLdSeVWWCiL3WgtwYiP8nBdz+cg6/mX+s9e1FseImwbWWmDvjv3dX1swGxY8yfYbGYnTafL5d71WnxY2v7QYOWbWMsSrm7oZeB7JorJVKTb8zq77o+F67kAfoNKMYpNqEA+2vbp1QbADaoLRY203cN94yL1bwCiUeyzBVe8oIE8PaYZbGiiSOJjKXV83M3e72gvOD76ulfak4yi2vDACfA+3JqEmYT+4dxCpQaEuxgGPZIuRvHzO7onnyopA9OcgD1lmHbA8Znrgngif61IPiAQONnYW882kcbsvVNjiNS8waQWbVAw36LLa/frjKWeLe913oV6ftyWxdg+QmUTUWS5B5VtdWEYVPCKUsRLbw6fhFoGu/QXgT3IQElRC3Au+A4xXcMsIFPrr2hdmy0Dr1CcIhVDBN0pef12M67u+5IsFFN5uGlO+T8nLBa7g8QJsXK82T+QA2JFentfQKyKoGKPvBCx1ttSMRNJCxvZFm2Pw+D30M4S/dKCbwUQ9o120AJ9pMw8jTqQaQQkNg7BhOoYSrR8vtw+QW25E3wOrzY0ydJZPfX1h+2NhXeKCqfOG9S/QsOrTWnMszyyHJ8sTJeJ9liAjri7KT3tZv7nLbA3T8QB/PSRy+rumy83EnUGdkpNVfdcwZrbSkn7YF8z+zkUVA0oBs3TtFbmzQhQ6z4kouSG6d9hanpNPIALwqOzoMQZMjZHnjFxIcB8FaK+yadqT0ClJcl3B0qafRYxhVO6MfJ8zu7Kv5hLIea4DPGh4wPMsCX
 PPsbIwk8
 ahbP703jiZVYzgQWNmlNGE+JrjQdZHDtRnkpJoPSlF/e24cqhUbLeDRQNVyjmCKDlBwdFIXk2ljA7e18cgcc4z2+4uTT+3qgNtaUejii1UFJfArdy7RwIcsyxLIwGakflSIQWxhBPse8F4pYxiktzskZuTuqO78GrEMrMxksJn1/0CVP6Mw7/8AcPsO0XPfItmyrxLhF++BTu8NQNyRKTAyFmPk9WsT/AQnu/R/icjfjc/fKpN3lF8CiABO8BxOfKIV5y6B604EEDedH28eRNEaECDBpda+RGnTemwBykyE4+GN+xxMXinBG7X78jedenF6Ivsi3Ka2zus7ty0Q9mJwyV2gt8H5UchwUUloWwhgvpYLgIxyV1/ISP7oqlJxBQ5l5cbO119NvaXdKi0s2NIlC0HXAD1hCjrRQrYBuDnlUoeI5D2UknntWVMQA5TevCUnRaSzxJxzR6E0mS5rRlYC1RhSvdmFA6z9OgAM94CDfrx/5rCSfus/x6cXhbpjI6tD2eN64VGfItvm69R9VkvK7xoe8hkviciNMaLLTyfaLVKNPQ3/mBweo4t8lG7QV1Usjsngpm3dQyVkiWED/onK6bMMdXQmgkm9R9fNRWOFE/yUZlsM29BTDrRQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Vlastimil pointed out that the VM_BUG_ON()s have fallen out of
favour, so remove them.

Suggested-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Link: https://lore.kernel.org/all/4074a816-9e75-45a6-8141-25459bcc106b@kernel.org/
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
Changes in v2:
- Rebased onto mm-new, removed VM_BUG_ON()s
- Link to v1: https://lore.kernel.org/r/20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com
---
 mm/page_alloc.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 1b5b1e556f76feadf21f3f44a9440fe883fb7651..e47679e7a9dbc772aa27f550a10aa8c0e95af55a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -653,13 +653,8 @@ static inline unsigned int order_to_pindex(int migratetype, int order)
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		bool movable = migratetype == MIGRATE_MOVABLE;
 
-		if (order > PAGE_ALLOC_COSTLY_ORDER) {
-			VM_BUG_ON(!is_pmd_order(order));
-
+		if (order > PAGE_ALLOC_COSTLY_ORDER)
 			return NR_LOWORDER_PCP_LISTS + movable;
-		}
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return (MIGRATE_PCPTYPES * order) + migratetype;
@@ -672,8 +667,6 @@ static inline int pindex_to_order(unsigned int pindex)
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE)) {
 		if (pindex >= NR_LOWORDER_PCP_LISTS)
 			order = HPAGE_PMD_ORDER;
-	} else {
-		VM_BUG_ON(order > PAGE_ALLOC_COSTLY_ORDER);
 	}
 
 	return order;

---
base-commit: da0a06486ac3ce47c6ffb603d2fd332229d41592
change-id: 20260512-page_alloc-unmapped-prep-c3ae0381d58b

Best regards,
-- 
Brendan Jackman <jackmanb@google.com>


