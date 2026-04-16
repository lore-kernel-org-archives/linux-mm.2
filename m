Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7598BF8A15B
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 11:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7DC46B008A; Thu, 16 Apr 2026 07:07:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D54DF6B008C; Thu, 16 Apr 2026 07:07:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C91DC6B0092; Thu, 16 Apr 2026 07:07:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B6A1F6B008A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:07:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 58B448C43A
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:07:11 +0000 (UTC)
X-FDA: 84664142262.03.DD40DD4
Received: from mail-lf1-f73.google.com (mail-lf1-f73.google.com [209.85.167.73])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6EC734000B
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:07:09 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oomijbkJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 328LgaQoKCDoiYhWlejogeckkcha.Ykihejqt-iigrWYg.knc@flex--mclapinski.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=328LgaQoKCDoiYhWlejogeckkcha.Ykihejqt-iigrWYg.knc@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776337629; a=rsa-sha256;
	cv=none;
	b=UOtBO7PFw0rDzwBMSZoLchEW6weUXn1AnCcjfNydoXvFwp4M26ze1tLxj2pXqWBZCUGGOg
	znbc+Jf9nmo9a6uZE3mWKK8D3NCkDRUsqtxfBbk/gWPxtDcrqkbP35xWHSyIINtxwJKtdi
	TxeyG0Ltsvb6JnxGvMxuo6zBVgbhngs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oomijbkJ;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf12.hostedemail.com: domain of 328LgaQoKCDoiYhWlejogeckkcha.Ykihejqt-iigrWYg.knc@flex--mclapinski.bounces.google.com designates 209.85.167.73 as permitted sender) smtp.mailfrom=328LgaQoKCDoiYhWlejogeckkcha.Ykihejqt-iigrWYg.knc@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776337629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83G/JFf5TbAu/dcy7wbV8ZkTGlvEgBosGu//G/NV30c=;
	b=RpWmGRLxMPnILmTViXK5MhSfNFovUO/AJpm//5yOlg/RVqriv4fcFZaRr1VDkB3pJDD06w
	8XokqtIgu1WmGB4qmUhLhKl6qaGCTlq51M03HiKVV0EQy+j9o8YT2jdhJfxB3wBXOMrU7P
	M1s1xq7l3W8LnbMsuifBq0h0Wo1mSr8=
Received: by mail-lf1-f73.google.com with SMTP id 2adb3069b0e04-5a409cef179so1208606e87.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 04:07:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776337628; x=1776942428; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=83G/JFf5TbAu/dcy7wbV8ZkTGlvEgBosGu//G/NV30c=;
        b=oomijbkJrM8tNDZXsEjcHke9h6Q+q3DeaVMWt+nAMlC4uhpukJwfo6RcYHrNqdgGUH
         Sphoukrb6QubjxHIaZ1NDttz3wIrO1dy22e6qtZxKyRYgZ40ZntFerVGOk3jg0yn/mDe
         SQWiMv3YTZZdX9B/5Rs8ialKgOXIM4sNWQlGSp6wwMZGi0n5UfdAVnCabEdI4DfazuD2
         lWy4ZqU5jR871jAxUheqNGXHCINiWIkpdNb2HEwBVi2yfAd93AgMC8hUvd8YjMSflk5C
         FmwD+dyVzzr9lXgCPasbHkHUhRTVkRX2GpeWe4kuNBEGX/4Tkc3jcbBI0nC2ufuyBd/R
         j3ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776337628; x=1776942428;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=83G/JFf5TbAu/dcy7wbV8ZkTGlvEgBosGu//G/NV30c=;
        b=okPWBrjZxhpErY9yIjQnr7X1YEM/OeUCX0Q8Q874T4iTzhcdNzAI4D8i7Zw0VFiHLA
         t2FJ97pwoElZ/fuvj0dQVK6MOApN3SNJl77StkuGpVKoG56pzAWR9ZvVeEh4ubfq6d3Y
         TZiWm3VZ7YkD+zNlId6U63P/8u5acDk0EliQqSYKS3M6Y+cnr1/WAyRqFJ23HWwtY6MM
         sg6gKnKbEMQiKfqsRv15vggglzjvq/IRmPHT1kTU2LRMaIylrRt7n2CodGR7XsBHImi4
         khsdkT+VN6Nj3PUuqUGePWTXyPpfPi7uNE80YJWNSIQ/g9dXvyGQeDY/g4vj+etuYOoT
         btCg==
X-Forwarded-Encrypted: i=1; AFNElJ/vLvxsfIydZFm+DFpDwiIgtLjZ7XErSbNE96Y7oFjrzBG6vIkftmc1dxgd+aoC3YXFXn3T6e22iw==@kvack.org
X-Gm-Message-State: AOJu0Yw8+iBNDubUOIcLFcOc38u7j49xPy+mwcsJ4x5QyWjk4r7qdqMj
	zyDeo6/Dmw6GAICwWV/RjxS9Xuux+l7kLG+kckHOffOrPRv1poiQNdqyKUc7UTmg5+pN8srFPI3
	JMVdYR6RTtLUKs/VLulau8Q==
X-Received: from lfaz26.prod.google.com ([2002:a05:6512:21fa:b0:5a4:5d2:9524])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6512:b99:b0:5a1:2332:68f with SMTP id 2adb3069b0e04-5a3ef6e2732mr7016523e87.0.1776337627236;
 Thu, 16 Apr 2026 04:07:07 -0700 (PDT)
Date: Thu, 16 Apr 2026 13:06:54 +0200
In-Reply-To: <20260416110654.247398-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260416110654.247398-1-mclapinski@google.com>
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260416110654.247398-3-mclapinski@google.com>
Subject: [PATCH v8 2/2] kho: make preserved pages compatible with deferred
 struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 6EC734000B
X-Rspamd-Server: rspam12
X-Stat-Signature: eqmcedf6x6oxsozyagoho4fyrwpmudy7
X-Rspam-User: 
X-HE-Tag: 1776337629-271079
X-HE-Meta: U2FsdGVkX1/ZYDn81HHHBty1b/JEjCC2b6D8m90jyJupPvb0sg5KzOdYJEx1BlqQXysj+RcuzxS/w6P/2TadmwolIpfSt7Vgx/ySkD6+NUiJ4q8cHYofCAQ8ZxzzECqlIAniJ+nShZFaQalKbNYHCXNZMJxZYOgF0+vqyvi75wZOBghsTtHWMx6f0vcHl1rgF3tnKQhW10RF71ndLUgq7IQoM9KR2R1rXlUVRZD9NFdCOA0vZi+mbsUhpb+M0DoY+hpRQSs+wYpIRtwvS9fVLTjBBqyjD1/or4eodQEW2Qc4T7/aPA3HGOltdAsexlfc9ws4bV+F0o7+sELHsnVc5mq120kXoPHZ8ZHlCAIXunhwSeBxuK5RszFxfXL3Ouj+H9MMSRZ58qyX/6VZOaEwYWzpGuCH2TPkAW6xfFA3g5RJ99DJ1RIPKDGEJSuxDxb26dcRWWYG9HzO/yzAHVtuRc7QMFrwB95BKIO+cqLGXBR9oTw4/XBjx2oWRlLTewV6heUXtYYM9DL8fmncKAja7pc2D2mvwlY5ByjWB3atdzXUymnHPNwi6gtNkkZ8gJUtkgqdFV2DqZX2jLbklbiI5Y2NPOa6Xo6b34MAxNEa+EFQ5jzqR599BeMt01ineSrknNOH6t/1c3J/srh+e7ZgzogbwTM5hqWvzVMY8nPezODD+GOJL+yAE/yiRkHEUkCx6XJuUhi3w2rkswgvwpSfwqKP3GPkrfofbPbysVECNnoQ6C720j0abo/j40vlDeW7MVdbnCC1xZZahK0VhyvYqEhQurNqtyi3vhY0diNLeWQIKAHp/i9TlL/HCGduq0A1hD1iDu0NdptpPyAHPP8+J3BknwzXJffZpXPK+7shj74rR9+sXOjWP1EyJ5IZGATOcg5fsw+md1OA85YSwCLVUvyJqLuQMlMmW1B4CdJU95Wl1ArEcDwiGmJQ1pdlgA1ee5SJKZUKsI/lwlW9Awq
 1NKubbnn
 uWHonV9MD2gz166putWa86namzp5TVRFl21rPUWEw8HzphDVGwsg9WaydtoZiCQQrI5Ov9d0+PWWZbyxuVe8eukVxVZmv1uVuzzjcLxqVgCjOJlmP6uKGCmnbhw+1I3Rb+5LqTXnXyjN37iPx1O/2AeMejD5NVo2/2RtBfcLrmukdEhMKdWz/3yCADXdIFFoz2EJfHsigzZnZ0/TvTth1p0l6vVu2zI5L6SE2I+0cWH7YYSe+azvUDwz5edrdf5B6DJv7f1PNXDA/MbiyKoXyR9xgRFioLDhdF9SCxu75YfyDI0Qe7PMWxZAwJo6Ot6QoeFv3lcW7tuhqkUSiXoOeibrwCp7DHE4suif+vIXyoveVhUOvr1b/m9uN/ljPDoQ+H6HzM0VbNH2AL/ux5viuiG4cvLXPkeglbt9WKOzmli2zfTBuOYoVfaY4/OlsfXewkOa6a/rNZOM9GvHPltzxp+hB8h+wtCUf24JiRqsLD3cSZ1APkmDK+nVmjW1NxlrRIo+rjq4NwdQ25LHzmtEYaCWCDaYIsnMVbhi3sq0kdbcNRsfsf/6zcHh0GpfYhInsRtgrvsGJ84rQlsByKaQgTTveeGLfrto20idWOE61XB32+crqTcxQypIZNjWV/fdx3V+ThDz3tHCKghFGMel/gKjIP62k6USWifPzL/ND+VauchxZ/3EwiCOQOfVBUZRK/ilKCO0VFLbN//OVf/8tx+J9gPMvr9uTWquqhJadiAcmWQc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Evangelos Petrongonas <epetron@amazon.de>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
initialization is deferred to parallel kthreads that run later
in the boot process.

During KHO restoration, kho_preserved_memory_reserve() writes metadata
for each preserved memory region. However, if the struct page has not
been initialized, this write targets uninitialized memory, potentially
leading to errors like:
BUG: unable to handle page fault for address: ...

Fix this by introducing kho_get_preserved_page(),  which ensures
all struct pages in a preserved region are initialized by calling
init_deferred_page() which is a no-op when the struct page is already
initialized.

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Co-developed-by: Michal Clapinski <mclapinski@google.com>
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 kernel/liveupdate/Kconfig          |  2 --
 kernel/liveupdate/kexec_handover.c | 27 ++++++++++++++++++++++++++-
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/kernel/liveupdate/Kconfig b/kernel/liveupdate/Kconfig
index 1a8513f16ef7..c13af38ba23a 100644
--- a/kernel/liveupdate/Kconfig
+++ b/kernel/liveupdate/Kconfig
@@ -1,12 +1,10 @@
 # SPDX-License-Identifier: GPL-2.0-only
 
 menu "Live Update and Kexec HandOver"
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 
 config KEXEC_HANDOVER
 	bool "kexec handover"
 	depends on ARCH_SUPPORTS_KEXEC_HANDOVER && ARCH_SUPPORTS_KEXEC_FILE
-	depends on !DEFERRED_STRUCT_PAGE_INIT
 	select MEMBLOCK_KHO_SCRATCH
 	select KEXEC_FILE
 	select LIBFDT
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index a507366a2cf9..d5718bef6d4d 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -473,6 +473,31 @@ struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_restore_pages);
 
+/*
+ * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory regions
+ * may not be initialized yet at the time KHO deserializes preserved memory.
+ * KHO uses the struct page to store metadata and a later initialization would
+ * overwrite it.
+ * Ensure all the struct pages in the preservation are
+ * initialized. kho_preserved_memory_reserve() marks the reservation as noinit
+ * to make sure they don't get re-initialized later.
+ */
+static struct page *__init kho_get_preserved_page(phys_addr_t phys,
+						  unsigned int order)
+{
+	unsigned long pfn = PHYS_PFN(phys);
+	int nid;
+
+	if (!IS_ENABLED(CONFIG_DEFERRED_STRUCT_PAGE_INIT))
+		return pfn_to_page(pfn);
+
+	nid = early_pfn_to_nid(pfn);
+	for (unsigned long i = 0; i < (1UL << order); i++)
+		init_deferred_page(pfn + i, nid);
+
+	return pfn_to_page(pfn);
+}
+
 static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 					       unsigned int order)
 {
@@ -481,7 +506,7 @@ static int __init kho_preserved_memory_reserve(phys_addr_t phys,
 	u64 sz;
 
 	sz = 1 << (order + PAGE_SHIFT);
-	page = phys_to_page(phys);
+	page = kho_get_preserved_page(phys, order);
 
 	/* Reserve the memory preserved in KHO in memblock */
 	memblock_reserve(phys, sz);
-- 
2.54.0.rc1.555.g9c883467ad-goog


