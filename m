Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D62FCD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 10:30:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F24F6B0005; Thu, 11 Jun 2026 06:30:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A2D56B0088; Thu, 11 Jun 2026 06:30:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B7F06B008C; Thu, 11 Jun 2026 06:30:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE3D6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:30:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B6EF140370
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:30:09 +0000 (UTC)
X-FDA: 84867261738.15.BC29CB6
Received: from mail-ej1-f73.google.com (mail-ej1-f73.google.com [209.85.218.73])
	by imf18.hostedemail.com (Postfix) with ESMTP id DBB191C000C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:30:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EvgEx0fb;
	spf=pass (imf18.hostedemail.com: domain of 3LY4qagkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3LY4qagkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781173808;
	b=wudG641+VY7i043/N+bKbQMNtBz64NMbwE5dH/ARUAM9+82edeIRM44sxBAY532SxwjhNq
	57jJI1D/TTPRcpqbZfDkCBKFFtCb95uhy1tjUXWliwOnREl6MOu6G5HLsNZyX3Uo6JJBJs
	MF3Mxdo+4yWEgsRfx0u1YXX1Ff0CI8U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EvgEx0fb;
	spf=pass (imf18.hostedemail.com: domain of 3LY4qagkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com designates 209.85.218.73 as permitted sender) smtp.mailfrom=3LY4qagkKCEw7o5816ov8u22uzs.q20zw18B-00y9oqy.25u@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781173808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8qeOP9gDnHU3nT685H+Q/iHqCKFCSLfAQAt+As3buPc=;
	b=OeqlHy0RtG4oXIzonCK4VBg7BgbyLHoIn4HoCr2pUjnV40VH4GJyWpwwZquRmCVyb3Ptkd
	t8BPXF/WMtUFFvGhArPiTIBx7FEGXYZWN9wPW1DHm0QXui/IVh+3URYb/m4/pNgER2hL8u
	lu3o60nh4e3vdhZoWDrDEuKQyXpYC58=
Received: by mail-ej1-f73.google.com with SMTP id a640c23a62f3a-beb1f622263so807018466b.0
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781173806; x=1781778606; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=8qeOP9gDnHU3nT685H+Q/iHqCKFCSLfAQAt+As3buPc=;
        b=EvgEx0fbHqqYQSfyoadjnRF87d4evZDv8IbvvqODvM2U+c2ks5k6gSz4aZ+5caq8bj
         eRaP83O11TQ1F6oVwUW/YmM2MIiGPGmddwcNq4H7g224kbGkNklbGPDT4MPnU1XXlaja
         EaumSiSKYz/mfQTEB2UKDDgFzXWh7IHcgF3uSHCn8vSURNVl5C8w2OsWUAcMAqCl6Fak
         f/d/2z1m21wm8VDbUwMcxzkyUQVI6WS3MBpqGTUQ55WaM6/gPyVnvUwLu0O5S7Bl45NG
         AwErkO8tDpfKZtsEuMFcSa6iFGMAwppB6MUja1TpSPND9D4+9IjpS/oiPeMZN04tIFBQ
         YkIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781173806; x=1781778606;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8qeOP9gDnHU3nT685H+Q/iHqCKFCSLfAQAt+As3buPc=;
        b=JxzLPpSvCXIpXsKUQ47tYfVLfmBT6dlWmSCvComOhnwzs8AQpL63qSDhBcryiECBvy
         YcIMty+27Mcy4k3bUBUD1uzZbMZIhN9SlrYHl8vi+lCr+VAopDcz8p7prwzhDfLWRshF
         vxGHEyu7eFh3O8hlvdKBCwXarIIus6FGtykTTfHq4lNgtEAGKdSMp9QxQxQIqqQkskVT
         DAEYHdesrmyrergUYF4OzcOPm+FqA4+cC3hCX72BnBoUfQzPde5xy6QI6vHvhZyeela2
         BUC6GeKAUvavCDb9VYA4o399V7jyeN3JONYIPg3eawFWsYEztf3MUU5mELKcNo0RaieC
         vm2A==
X-Forwarded-Encrypted: i=1; AFNElJ92nFES5Zmkc6etNVEpyfpXK50pDE/F7cNv5U2IXHpPDjegIT4pOpA6pGu3evWhvYXEl33MF8phuA==@kvack.org
X-Gm-Message-State: AOJu0YxSVY6u3TMJ9TZmfsDD/OOApzd1gZPJB4tQ0MhtxX5Q9n5DEpOs
	bUsJk5Suvu+9wGBQitl2khUEIu3zMUBjTvhmZguPU3AUiICFE5an8emlmU3sU7bAbEZTXdE5sQD
	oMQUvEl1DEfeyqYm+FQ==
X-Received: from ejdbe10.prod.google.com ([2002:a17:906:f40a:b0:bec:3aa5:9928])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:2e0d:b0:be2:cf3b:acb0 with SMTP id a640c23a62f3a-bfc8595c7fbmr65138666b.12.1781173805724;
 Thu, 11 Jun 2026 03:30:05 -0700 (PDT)
Date: Thu, 11 Jun 2026 10:30:03 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <c2478f79207b10a13282d917c961261d17b86a15.1781173768.git.tarunsahu@google.com>
Subject: [PATCH] mm/memfd_luo: validate serialized_data before conversion
From: Tarun Sahu <tarunsahu@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: DBB191C000C
X-Stat-Signature: tzjr3pajj3agxhds4ff7p9waiwtx9ddj
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781173807-502465
X-HE-Meta: U2FsdGVkX19pVvRcFoCa3yCcr9myVC74gcQPem80+qPW0EjYJBbBLwgwMAH6ldnHI9t9OyGaW0stUbXahk8kgrr3u4KlM+MCERq7pD7Y6za3LEkOS8nod370Cx9A+VNBoL/WsEyydVK8kpESoWZxkA4fOuzUyvTUDSZaZOK2rTeOLOEQb70l3tBm2a6X0nNWn1hzMXJydjpvJvVUVqOYdrJHrhQsVBS/guRPbS1dg2k9itkXHf6sQIaHVhmOKDfrvyHXjHhmIY1S0x409qsVHEIjgNEKNN5scMlhCtc8c6HYQxIdsdEOBKvIFmRLLk9c8tOnkuoPNJEgaG8t1Nb/vdSxHaDq3VPuk5VJx1UrKy6C5vHo7APFA8iq1upuqadBzaepMzQ+3GMwagbyMlRTTSFvzd9mqkwZAjNoptVcZ2QwedsrMLnY7tDvEEaLFdiKKo7POjlsyu2apWOY6UXj9+7G5l3O+qXuh3ovEXWdZRKbv6t76Sb3rbotK37RX0jd1H5L2y03YoSpmxh2PboPJy26CEW9f3TORwE7k0BBCb1RmFyloKaYUWxxvMij9/Qj87ATO9zLVURAg2AZ1lW8yfECcT6FiMr51BR//irn87Y8V/2S+BEaWniR1xluQnQSTnABprt9+vOS8laT6DbBcO2/dO5hK/t4ZuOqsou+rwgly49joeUnVT+MU79/id4m5il6GpQmIsTuAXu+09mmtpLxCSTlroYCTXyD1lVvKFJZZSjr+4mvBYSv3qVFWIymcEe4UsdRfw8wj2rHeuElllm8Ihm7w2GJNCU7S4lxtIsxja30PHnQx0Le3aQBowzjLvhwAMXYbt7Ui2Z7Ba6OWPcp2lwJljJGGIekUtydeiqy5VCBhSz6SEi4AyXzEG0m+dXtYcTzN+lkKmn0Oj4l7F4Mz84wbi2eFTMRRTqo6q8kR7U2aZsrhc2BMciRxYc8uz91bDIhvOCH+kl58iG
 xUzEfM8m
 wz7RMKp1X50WV8sYbKJ4z+WzDNdNBr4YtxGi7wWkXkooCYea1rbn3U23kTtO7lqBJi2Jn2Qe8/v2eUaE2E/kV+m7236Ne9z7RsLUN0hi7xqdFr3eb+mLIvIK+VeJISwyi7vYfjmq6NAm4Kls6PanjVBe/JVg7FxWxdL9e3apbQ+DK/s4RTk5wqvSnCM0ziuu5WNLiCIQt6Hr5lWNQBoCKvzVXQ50eZyWmsXwhEARhWlksNihY0WjnqAARzoscVXIvyEmIaAKeN0SG7TyCluMx/3AX15wx//IRNM0XZST+Oe9dKgRKTd6Bc4EKspp7Lir7bZcvcPZd5thUII0bTk3J/tSD8VEAlaCTMFpPz4lHlaY70QTxBlv/1/Np621+cVxkLaoWNMD0AQO6umCvo6aSHfrV3q+598Opkw5W/BvR1bZEnWTrjDkOsvP+GP8nczHFnQ9aQkw+MkeDh/K/J0zeLVA35lBA7NnJfAUVtYf5V14IhGtY4EJbXVbVKrqjqD4j0WA6X737x3P5RmtgV3hArafnap4vNlPHat0wW9h7BGyRUm0eWojgXRv4k9JtQkVNjWhpPR7+l/EkmfnHY7jeBmnjULIA5EIS0gNs9+KfsP0CRSo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In memfd_luo_finish() and memfd_luo_retrieve(), phys_to_virt() was called
on args->serialized_data before checking if the physical address is valid.
Since physical address 0 does not map to virtual NULL (due to direct
mapping offsets), the subsequent check 'if (!ser)' was ineffective at
catching a missing serialized_data, leading to unsafe dereferences later.

Validate that args->serialized_data is non-zero before calling
phys_to_virt().

Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
Signed-off-by: Tarun Sahu <tarunsahu@google.com>
---
 mm/memfd_luo.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
index 59de210bee5f..10f3983b0060 100644
--- a/mm/memfd_luo.c
+++ b/mm/memfd_luo.c
@@ -397,10 +397,11 @@ static void memfd_luo_finish(struct liveupdate_file_op_args *args)
 	if (args->retrieve_status)
 		return;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (!args->serialized_data)
 		return;
 
+	ser = phys_to_virt(args->serialized_data);
+
 	if (ser->nr_folios) {
 		folios_ser = kho_restore_vmalloc(&ser->folios);
 		if (!folios_ser)
@@ -522,10 +523,11 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
 	struct file *file;
 	int err;
 
-	ser = phys_to_virt(args->serialized_data);
-	if (!ser)
+	if (!args->serialized_data)
 		return -EINVAL;
 
+	ser = phys_to_virt(args->serialized_data);
+
 	/* Make sure the file only has seals supported by this version. */
 	if (ser->seals & ~MEMFD_LUO_ALL_SEALS) {
 		err = -EOPNOTSUPP;

base-commit: 9716c086c8e8b141d35aa61f2e96a2e83de212a7
-- 
2.54.0.1099.g489fc7bff1-goog


