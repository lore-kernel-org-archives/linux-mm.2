Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B107C5AD44
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:52:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 397F66B008A; Fri, 20 Feb 2026 11:52:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33C166B008C; Fri, 20 Feb 2026 11:52:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266B56B0092; Fri, 20 Feb 2026 11:52:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8A816B008A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:52:18 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9E47FC111D
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:52:18 +0000 (UTC)
X-FDA: 84465427956.02.66E7507
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id CB7EE80007
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:52:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ikO/JtMH";
	spf=pass (imf30.hostedemail.com: domain of 3P5GYaQoKCBgA09yD6BG864CC492.0CA96BIL-AA8Jy08.CF4@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3P5GYaQoKCBgA09yD6BG864CC492.0CA96BIL-AA8Jy08.CF4@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771606336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PT6A/oALwI3aAl9sXp0IZoMRZ6ospSVkKGQtoOfj3Zc=;
	b=DpAJEiInHktwLgHF8STS4zO1Yfa3J3kb79fThcWf6f99gcvxepLB5ok78uzEoYRb0+zet5
	K3u2yPysyrMFhpCnMqtlRQS6F8HCoOxaWadVUaD4Cvtcz4vtE3/Lbgws24XXVcAVpVyTo/
	SKQZ4YsmXrQcnPkP9SmhF1pbK6eNQ3M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="ikO/JtMH";
	spf=pass (imf30.hostedemail.com: domain of 3P5GYaQoKCBgA09yD6BG864CC492.0CA96BIL-AA8Jy08.CF4@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3P5GYaQoKCBgA09yD6BG864CC492.0CA96BIL-AA8Jy08.CF4@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771606336; a=rsa-sha256;
	cv=none;
	b=5cFBBwf3hJWi8bTONyb4YpVVq4Zi6T2Agc/s/WT+vJwrepZsq7T5RY6YgUn+ph/m5EpXsA
	n7wIgJv9ME5U+xjR2wFtdxFje8W4FIon3UAYe2EPklayY4scO2TbNS9euHqA+gZMgilnFJ
	ZTdH9Q+yDWgJ4YlWMqRV8xTXmQiAqv8=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-483a24db6ecso20610085e9.1
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 08:52:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771606335; x=1772211135; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=PT6A/oALwI3aAl9sXp0IZoMRZ6ospSVkKGQtoOfj3Zc=;
        b=ikO/JtMH4YsIGSK3OT4OiRwqoo/9A477rqq3Z35yLxfQcvLgKfOlYrpgOKypvm7/65
         ApSDH/lFuNPa6c0cAOksrcD8fqbPGtAO9mm06Mi2PjarCQVqtnPWMKEKejI+QecvGVBB
         utOCnyZ2PxligweBY0KDR95IBEXnVf8kkDlp2sCWm+CPpq+XR2nDYMOmWSSvzBcJ0evl
         iXhAaC5QrsdQYJPkqS36H0+iMQkoS4EMarfN6PiI0CmrgsRfCgsLjptXgR2cOZ3jEy2b
         oJ0fABlhn9fvN1cimE/Aa/F++vli/dN6J/GO9airK+Vfm2avVov+1A7G+mUVVeKu6lx/
         9xKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771606335; x=1772211135;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PT6A/oALwI3aAl9sXp0IZoMRZ6ospSVkKGQtoOfj3Zc=;
        b=E4IWLvHJErzoJl9gyr6nCZqXrRvS9G/47YjaxFVbDpnscmHHLa4sp8O9fIxpAfjPYa
         h5X4uqCne2bf1VIo9XLgZmoWH0GTxeqPuh2VHpbeU3H8+iXZwhSllI1obFi7rRQaPa0W
         nY5hktuCt7AKuBB4zvFBhEW3/kMfjxropLmrJ6kptlJwhNiV5jDj902MFEO56e3BPvVo
         Twg7e92uNnzoMhWafeHvyIacn0oCXxdLf2osgs61YNYrBVbewFUlaIzWLlxM0qk0WeZY
         MTpFDFjTSctljNVStcYe7Nq3hwHdOzoCsmnIxu5OA/LDC2HzNtZyNvX4g0nl+dTtpM1l
         uESA==
X-Forwarded-Encrypted: i=1; AJvYcCWNmycUUtlLONr2VQSdD3HdMchbmcsbnguSE3PVBGKcwEJE4CNu/EULcOFF0LBTO/xeiwZLUf8omg==@kvack.org
X-Gm-Message-State: AOJu0YwUHO+i3BLI4cWeWp0aFC3pdVP7PlbbX0f5eArPgdY4oSdDesRs
	o45xljuZbB8SYH0RamBoyU4CM4RCynyxJGvkD+ItcNsWNllkB7zQkwOvV9ZM2N9p49E/LrjRJ7T
	8rH2oiuLgn/uhpNGQWKcSoA==
X-Received: from wmpu13.prod.google.com ([2002:a05:600c:4d0d:b0:483:a1ee:5eb8])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b03:b0:477:54cd:200e with SMTP id 5b1f17b1804b1-483a95eb622mr2764805e9.1.1771606335280;
 Fri, 20 Feb 2026 08:52:15 -0800 (PST)
Date: Fri, 20 Feb 2026 17:52:03 +0100
In-Reply-To: <20260220165203.3213375-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260220165203.3213375-1-mclapinski@google.com>
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260220165203.3213375-3-mclapinski@google.com>
Subject: [PATCH v4 2/2] kho: make preserved pages compatible with deferred
 struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: CB7EE80007
X-Rspamd-Server: rspam02
X-Stat-Signature: 7owkdipmz849rzxcb5p8cmnyxudg694x
X-HE-Tag: 1771606336-360610
X-HE-Meta: U2FsdGVkX1+/jyx0qNPjoikDEhv6jMrxPOBcIvUsopXGGK8ToXnAJTsVtBBHyEXi2rIkMnXFOLT68OsI92lcxke2FClVA7PZozCr7xvbVJddJDTP/JeCy8Zi6/+d2B49gZikY8Uo5T+wX1lZsbaua9WHfh/RKlOjtEq7AEgXkB8Y36o9P7xm3WkpnbPagcjqtI0qIpjDYIowtrhkAitoVLzIvqScdtvnsYJxAahRQvMZ+rofESvFETZ6a5U1gSM7m3m253SzSd1LD/tCmPD5ufBklJMVntd5bDxaLy4ncDGWbbJux7XhCtRAaZ72RSrUnLL+G8+rSI+NBglHyod7I4ktTgGJwbitn4h0ZbHfPVssYbSnPdejDM/2Di9BqqarrGptP+TA7+A/rEDvfUW9zrPAt+8VW8XaxwRY7cdvRLpS71q31ViW8oOnvA9KxY1TZeERsTAcnuN/NfxLjXNIG1gc/25U64ThrwHnMVUcI+fGBw7JX2ZCCwtrjoMhEU13lORXWk+OaAPlcjBkeTOIy1kta+ylSDxFoD3/F696m8ZOrzHZ6fPnHvR6rCmo9dizVV+4h0eEfRFQ+feOSxB51kyofzDKyItQ210imRj511TtmeJtsrJZ5UEQnQpAMIbB+jwXVMGAZXGaO6VVpuVgMgxGYSFEphNq0u9gH1fjlZvPCH0BsMiDGSCXStLR7XzDFztrmvwygyc26gfVDoGSrESneTUUMiyeuO0pAuMiCfy5jM6bWF/mE+v2+AqCjrjXQtQ8SS/GyXWplHUrfKq8Pb6nhhN0E28LlSCMmmIlcrirFPJ9jhTlQYMqWNsa9N0szctq9rnMUwfr8HmkqgKVNxa4S7g7th8cyiVYRoPB1qKabPxMZpZXkxwyNHYwGUejqkY+sPLpJiXFBfMTqJsRHATvklu2pm5RPlkvRFf/oIpDMGq1EV4Im3fo1+mgcEzf6WiIb7EfexkNfysd3AS
 rpe7R94f
 HMWhdfnSZdpRoOlbxJC1etr0DuvBEqQFZ8IJRhn7drtc2G25/G2pZHP05/7kZ4+vqe+6L7hzQYhNMp1j2LnIYdcA94iFO9g9yPXy0+2MKFhmsuIoK6NQLPBqvuGaJHWIwu+aYr4v4wqBuHPWZK14Zv0HqdZltip8uzYkFt9S+FYLD/9A/xvfCdK+iLAcH2i7ZU7zxNIMMSA/oUOMM6tlrY49CUGgb/cqjs541hrGHr6IIUPUCiRCDX1la6t9sSinA35pIRR303Jev1JIFMTdcUJt6HXwvVuwqTfLbsAtoKbApgrbbn9gy+YFqoJ75s9AOBrvON3QTcRCdWFfltlkEpgPItM9RJh0Q3zMaFmqDeixJTccUJJFtvOzQ8rhr/dN0LK0nOpDHNIN+qA3drQrSDfNTAIPRqhTrwD3vd+KT34d5uqXHvbuZrA+1QJcQ64vSxdoxxDhu7fL+6M6N8xm+oVQakDIl7nST1e0SQRd5YjIcA83nQZFlUvJwL2QNZt8gkOjNIE01OH8QydiUGKMWuJAjq0BBvB8eTW7/m/fQihDYk4krqTVrW7iXyXMGR3LVuYclYXMZXZSWofthpT2HxlesJhs6qow/IrugUS+CK4i/YOqCl20VUa1Rn+zbRLpulUMIrOtVqq9k8iWkjMVkwFYZig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

During KHO restoration, deserialize_bitmap() writes metadata for
each preserved memory region. However, if the struct page has not been
initialized, this write targets uninitialized memory, potentially
leading to errors like:
BUG: unable to handle page fault for address: ...

Fix this by introducing kho_get_preserved_page(),  which ensures
all struct pages in a preserved region are initialized by calling
init_deferred_page() which is a no-op when deferred init is disabled
or when the struct page is already initialized.

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Co-developed-by: Michal Clapinski <mclapinski@google.com>
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
I think we can't initialize those struct pages in kho_restore_page.
I encountered this stack:
  page_zone(start_page)
  __pageblock_pfn_to_page
  set_zone_contiguous
  page_alloc_init_late

So, at the end of page_alloc_init_late struct pages are expected to be
already initialized. set_zone_contiguous() looks at the first and last
struct page of each pageblock in each populated zone to figure out if
the zone is contiguous. If a kho page lands on a pageblock boundary,
this will lead to access of an uninitialized struct page.
There is also page_ext_init that invokes pfn_to_nid, which calls
page_to_nid for each section-aligned page.
There might be other places that do something similar. Therefore, it's
a good idea to initialize all struct pages by the end of deferred
struct page init. That's why I'm resending Evangelos's patch.

I also tried to implement Pratyush's idea, i.e. iterate over zones,
then get node from zone. I didn't notice any performance difference
even with 8GB of kho.
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
index de167bfa2c8d..fe9c88fd2541 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -457,6 +457,31 @@ static int kho_mem_serialize(struct kho_out *kho_out)
 	return err;
 }
 
+/*
+ * With CONFIG_DEFERRED_STRUCT_PAGE_INIT, struct pages in higher memory regions
+ * may not be initialized yet at the time KHO deserializes preserved memory.
+ * KHO uses the struct page to store metadata and a later initialization would
+ * overwrite it.
+ * Ensure all the struct pages in the preservation are
+ * initialized. deserialize_bitmap() marks the reservation as noinit to make
+ * sure they don't get re-initialized later.
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
 static void __init deserialize_bitmap(unsigned int order,
 				      struct khoser_mem_bitmap_ptr *elm)
 {
@@ -467,7 +492,7 @@ static void __init deserialize_bitmap(unsigned int order,
 		int sz = 1 << (order + PAGE_SHIFT);
 		phys_addr_t phys =
 			elm->phys_start + (bit << (order + PAGE_SHIFT));
-		struct page *page = phys_to_page(phys);
+		struct page *page = kho_get_preserved_page(phys, order);
 		union kho_page_info info;
 
 		memblock_reserve(phys, sz);
-- 
2.53.0.345.g96ddfc5eaa-goog


