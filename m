Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74A0DE9A04A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 17:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 531F86B0088; Wed, 18 Feb 2026 12:15:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B50C6B0089; Wed, 18 Feb 2026 12:15:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 389CF6B008A; Wed, 18 Feb 2026 12:15:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E35C6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 12:15:05 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BB7361BF1A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:04 +0000 (UTC)
X-FDA: 84458227728.27.19FB6AC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 54D7C180006
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:15:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=avf7wLd1;
	spf=pass (imf06.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771434902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXUqFvDgr/GgZzXRZIRhwXqtA/ygCg24XF2XyoDsQa8=;
	b=QYQvtvx6tPFvfHfTsKIzWbqchZDc62s+RI8nQYc9kmaKKc1j+sfKVhs7zpIWkoXbpDD8Ab
	dl9hZPtPnp5v52TbmvAinYkzHtb5d88ITYRJ6lGgsTqWaQ7EwckmfpxSG2if9nosKwuE4V
	wyWy0LMfJEmYKrJkEsxZN3yJcEVtv94=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=avf7wLd1;
	spf=pass (imf06.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771434902; a=rsa-sha256;
	cv=none;
	b=XDHYinSt8c3nMo1IHAjk6RWTh4AdX7PzWVn6ceZQz03wYbDfsI+07MGgrYJlsjXh53/Mu/
	tCQvKwzMxbf/Rn80l7j5pf5xoXrsXc3FISFkHGW855VIA+vF88pTQDUQDjSopgAoZsGdjw
	75jkP3up4GyfZS1rNgbFpjlX7SKofro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771434901;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VXUqFvDgr/GgZzXRZIRhwXqtA/ygCg24XF2XyoDsQa8=;
	b=avf7wLd12v+orlKzEG9kpaNixDaX0SD0XOpY39OvVRaC2G4ElReFEGS7QVoHCXpKg40QJx
	cBN/XBrr6tYHcj/GxmRyuxNIIlIle8TxFpyIucQs35zNhpUlEb9GVZMETmwXtlu9ZCW3gi
	KYkDibxtfdNol2Cn/P1TBjwo0rqbhGI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-617-3bi8fVwrNquAug4lG0wA-g-1; Wed, 18 Feb 2026 12:15:00 -0500
X-MC-Unique: 3bi8fVwrNquAug4lG0wA-g-1
X-Mimecast-MFC-AGG-ID: 3bi8fVwrNquAug4lG0wA-g_1771434900
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-8cb4817f3c8so10838485a.3
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:15:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771434900; x=1772039700;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VXUqFvDgr/GgZzXRZIRhwXqtA/ygCg24XF2XyoDsQa8=;
        b=wpfVTHHSR3imlLCb04CtNgRZNsYzIh5/t2+xbZKcTCENRQjCyLDiiW1F0H29aifbiC
         bJ2de88KIb4JAgagjH3lQv6Kjk09A0qofwO6cUzkc9rnPJ/+keg2ThL8VwyUJM5Zmo87
         pq3YnFLBFRXwtl38CWYvu1+0Hhyk9p3GrhlnEeKSfY2jRqH/YjM4EpN+EhLoHSV2+lCD
         PW4B31D5fw+nhH347WumAzAJljl3L+A2nr26QZzYrNwM/W8MidHAzABTE9ifG1lR1Odd
         TEK6O1t1QV6+8n2+PHMvjQnh1WvVzsRkWeSCm7DLN2jiMe5AsdRpZ7I5LGCPHp2jbDsz
         TkNg==
X-Forwarded-Encrypted: i=1; AJvYcCXAF02SvArpN9F2o6AKzdS4dV+tbVuMriQvA0ISa4/afT0Q9W/kUYJOzYRNSzcKI+ErSFIQprdg/A==@kvack.org
X-Gm-Message-State: AOJu0YzF9NwZvm/gz5jexIHnfVOhE4pkftJ/D3CX7n6LwLMrxtioE7fO
	FBo3hj0EeIUYXy0ni0ucHFl6G2/pT9VGdpj7MdHh22OXXmEi3pBHKbRFDugpV9uozcoVXxYfXfP
	BEB2eOe6GWK2haoskYr36sBSGyLUWp9oeptcSrWmOhwHNzAHET0Z1
X-Gm-Gg: AZuq6aKdGa0tXfOs7iSWNz1DPaPl6s77V8V4NhtxRwlMKs15kctdSUe8Zr+RAqWmHUd
	GrjK1OOgrvW684ersLwI1b5zhw0gpIzYj5ycInfIasTUaCCtq3E6QqlArxmIK7bFqitSHpdc9xu
	3BKEBMjekTCF/hudX99S/ndXLITL4CTrNTBqPFX7YpH/Nr83xdNM36KTUwewRtfjsiTYp4mB4uh
	PKv24diZHkbgDhd726O2LP+9mDUWldcplUJSrupyoy16noDocAZWWQ2hXf3zbqMgaxHSwpJXIvX
	aCovxlHcC84mq+2bLqNIgREzmE5UvVjdjeoFMMsOYLbgSuM9Rb7thnZBZrxmD1VqNq2dnrboeMw
	MZXHYNXTAsw43+JBnoDXO15ZYBRrxUtRgJE2c+YffFO2hTy74OSbxea7r0gw/S9Y=
X-Received: by 2002:a05:620a:7081:b0:8c7:fdc:e871 with SMTP id af79cd13be357-8cb408629c4mr2086848085a.34.1771434899691;
        Wed, 18 Feb 2026 09:14:59 -0800 (PST)
X-Received: by 2002:a05:620a:7081:b0:8c7:fdc:e871 with SMTP id af79cd13be357-8cb408629c4mr2086841985a.34.1771434899177;
        Wed, 18 Feb 2026 09:14:59 -0800 (PST)
Received: from localhost (pool-100-17-19-56.bstnma.fios.verizon.net. [100.17.19.56])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89949b3d543sm57039066d6.16.2026.02.18.09.14.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 09:14:58 -0800 (PST)
From: Eric Chanudet <echanude@redhat.com>
Date: Wed, 18 Feb 2026 12:14:10 -0500
Subject: [PATCH v2 1/3] cma: Register dmem region for each cma region
MIME-Version: 1.0
Message-Id: <20260218-dmabuf-heap-cma-dmem-v2-1-b249886fb7b2@redhat.com>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
In-Reply-To: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
To: Sumit Semwal <sumit.semwal@linaro.org>, 
 Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
 "T.J. Mercier" <tjmercier@google.com>, 
 =?utf-8?q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
 Maxime Ripard <mripard@redhat.com>, Albert Esteve <aesteve@redhat.com>, 
 linux-mm@kvack.org, Eric Chanudet <echanude@redhat.com>, 
 Maxime Ripard <mripard@kernel.org>
X-Mailer: b4 0.14.2
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: qwMRjNhUAcc5UUpL6p-SX5CorG4KGSEwGlZeVVnvS-w_1771434900
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 54D7C180006
X-Stat-Signature: cnu5xy4rr75w1t75swu5jwr4snqt7e3z
X-HE-Tag: 1771434902-90823
X-HE-Meta: U2FsdGVkX1//l+8jEMVQ2560qLG54R5XGdPjnSGhh2t2CgCePg6QndcyHkVvq47uesBeLvv3VrY+r23xUxxdFrALWJePyOXudkydTDoCqira5DxGuGZjLkLP8i9Pg4qDZgxDFnTERuv1N8GOfxPR6ktb6mzAAM0qR97OHlGYWrfhsTOEha0xXE79IXIl2Qp/WHUlby/JilPVGPt96a3/KJHe33n/xa9nBdgw2X6KuTl6JimpHokKzDmCgRRpEljl7QRctdXf/G6LUbqAmBrnyfcGNYE/3sHGumZWra16EdQOiJBhJrw2MwHHdRkkiTAubw5pN9RFZCeFs+Q6EVzROo0Z9lW7nTc+wocavXsE3CbQT+FSMdQutn74sF+EJksiIrtCk/hN85/cJzUEa4vARUOMNYBanN4eitN3+iCy0W8fFFH9+d9J6F6c97+knDWnAQKv2Y0pJEQLci4uXsja2MuqBBzka+1Z4kB5Se2N08EkDXN5nYBcFXykqjfp2sVI7vXzm0/nrU/JiyT76czPYvn+72EL60C364xJY+g+BhAQZAy8EHD3ATQYUfVipkfm453uthJrjKLVCTHaS0x2Pc2XDTh02ezfoQ/QUJR2nJpaAvjyXrGdpcRQxCIqEV71uBk4sKrx3W6HsrZCMDX8QCxgkeBei+w+Th/cRUJka17FqOAX5DACelqDjYNiiDkmyYcl+wFn01ZJ/x9emcqOrHuGGeR2nIuq6Nbey57T8fQGOcBnkGiuTQNgv0r4zYJpthDQXKPq1FZc5605fygOsxwSTuQv5dydMtfnx41hGlJ4/ljYpgiunzVK5GX1qL4S3jB5aT0zWunwfeUWFBU3ZpNgGsA9DEBN0fVzHp0N0TQVl9NMq7iPMUNBHymmY0LHFrzNDVFF5NLfi6egRluTh2cf4u2rgh+yNJ/DAIzOoUr5dtOSpr6aKYCtw/c6x8eqBij93kgOgtbWcrNb8+K
 cE25LOvH
 U1TWYEqSgxBMN7V+doD+M7SjMwn4KcCORYWIM7XMt52Eb+hZnMlUGZ9S9sFTEIclNWgrZTWB5Ql2ILxKSS/z6RuOCL3rTz1oUVHoMdNSn19PxhErPi2lKBAuS+eLqXBj2RVjwZQ/NjHZ1qwaSbWwvxpv2sow7T+NJQTdhFja+E0PbVr1ta5MKvvh+nLxZea01sU0hGyAZhuJunNqqS1GAxdY1aA78h3Snwj42Pj+vdo9zG1wbocmlpAYrNPQuPRrfOJAV02/FYOrL02oyqWk+5xTU/YOu+1Q7laT7aTzyuMwjtVxueFzP8gp7ss3uYBStcNSZhobkdXB2TPiJ/+qSKSj4xmp2X5v4MUNnH+qaRcwUTTbzZc+EdX/U0E2NnugcUYLJxWCTmurRHBaxi7uFWEI/8MUdtd7ZJ1w6Wngm97xASpVEYvRFIGvVP2eHt8Ske+Bam95kgmeVwYVY2Sr6oPA5Lw0c3DKa0RsNEA2kuRjZPC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Maxime Ripard <mripard@kernel.org>

Now that the dmem cgroup has been merged, we need to create memory
regions for each allocator devices might allocate DMA memory from.

Since CMA is one of these allocators, we need to create such a region.
CMA can deal with multiple regions though, so we'll need to create a
dmem region per CMA region.

Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 mm/cma.c | 13 ++++++++++++-
 mm/cma.h |  3 +++
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/cma.c b/mm/cma.c
index 813e6dc7b0954864c9ef8cf7adc6a2293241de47..78016647d512868cd87bc2c1a52dd2295acaaf01 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -25,6 +25,7 @@
 #include <linux/string_choices.h>
 #include <linux/log2.h>
 #include <linux/cma.h>
+#include <linux/cgroup_dmem.h>
 #include <linux/highmem.h>
 #include <linux/io.h>
 #include <linux/kmemleak.h>
@@ -142,6 +143,15 @@ static void __init cma_activate_area(struct cma *cma)
 	int allocrange, r;
 	struct cma_memrange *cmr;
 	unsigned long bitmap_count, count;
+	struct dmem_cgroup_region *region;
+
+	region = dmem_cgroup_register_region(cma_get_size(cma), "cma/%s", cma->name);
+	if (IS_ERR(region))
+		goto out;
+
+#ifdef CONFIG_CGROUP_DMEM
+	cma->dmem_cgrp_region = region;
+#endif
 
 	for (allocrange = 0; allocrange < cma->nranges; allocrange++) {
 		cmr = &cma->ranges[allocrange];
@@ -183,7 +193,8 @@ static void __init cma_activate_area(struct cma *cma)
 cleanup:
 	for (r = 0; r < allocrange; r++)
 		bitmap_free(cma->ranges[r].bitmap);
-
+	dmem_cgroup_unregister_region(region);
+out:
 	/* Expose all pages to the buddy, they are useless for CMA. */
 	if (!test_bit(CMA_RESERVE_PAGES_ON_ERROR, &cma->flags)) {
 		for (r = 0; r < allocrange; r++) {
diff --git a/mm/cma.h b/mm/cma.h
index c70180c36559c295d837725e26596cf546cd8b7e..e91bedcb17be8c9e0d31aea1b67c0db36315536d 100644
--- a/mm/cma.h
+++ b/mm/cma.h
@@ -62,6 +62,9 @@ struct cma {
 	unsigned long flags;
 	/* NUMA node (NUMA_NO_NODE if unspecified) */
 	int nid;
+#ifdef CONFIG_CGROUP_DMEM
+	struct dmem_cgroup_region *dmem_cgrp_region;
+#endif
 };
 
 enum cma_flags {

-- 
2.52.0


