Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E300CCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 01:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2747A8E000E; Tue, 30 Sep 2025 21:19:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C218E0005; Tue, 30 Sep 2025 21:19:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 188CA8E000E; Tue, 30 Sep 2025 21:19:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3A848E0005
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 21:19:54 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 95C5E1608F2
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:19:54 +0000 (UTC)
X-FDA: 83947788708.08.579A1A1
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf11.hostedemail.com (Postfix) with ESMTP id D91BB40004
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 01:19:52 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WiOCbtfZ;
	spf=pass (imf11.hostedemail.com: domain of 3t4HcaAgKCHohYqmlkgsemmejc.amkjglsv-kkitYai.mpe@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3t4HcaAgKCHohYqmlkgsemmejc.amkjglsv-kkitYai.mpe@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759281592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x4HnKiiE09rl43LC3UECv7NDLXowg9VsBNh2ns+1RXE=;
	b=cvTR/dwp0Zt7USNmrvA6UjI/mFx9E1u4bYgHULWmqZ31WmMaLs5zNHuPhT/zxxRdf3FDFr
	TXvEaDCIHIPS6aiBkXpxIURr4wUDRlfA9q5LQiIi/8LOIr90HtGe46WReVK4S/xtbtlo5T
	/rCfB9knIKxtYB9xB7HDIySMUjhiANY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WiOCbtfZ;
	spf=pass (imf11.hostedemail.com: domain of 3t4HcaAgKCHohYqmlkgsemmejc.amkjglsv-kkitYai.mpe@flex--jasonmiu.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3t4HcaAgKCHohYqmlkgsemmejc.amkjglsv-kkitYai.mpe@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759281592; a=rsa-sha256;
	cv=none;
	b=40OQLEEYhmqhZJ4PkVErUTq9C9x+yfr3mIh76BmS5gIF68yU5jXodjRQ8zJC5i0i4LM45R
	tltT+FYFeccPDpKjoCIrJ75FDVpjgjGLApAZCuDp/6Dlk+xpxUVM1qyhDrTS0GA9mztUeG
	AeKDFaOStJra7dixkWnrFiHOCbYi4OM=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b57e477760dso4200534a12.2
        for <linux-mm@kvack.org>; Tue, 30 Sep 2025 18:19:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759281592; x=1759886392; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x4HnKiiE09rl43LC3UECv7NDLXowg9VsBNh2ns+1RXE=;
        b=WiOCbtfZ17dUZbshzd55t+pCjq8w6QYnDPQsdNjNeJTeOxVbjvCZCkzIfrU0rvR+q4
         mjyIL8dDQFC7H+f4BJqQP5C5+Rfvayg9b2rhABDBQe0nfFQH4J/ykODCTMeRcerR2sgs
         npxTJPuyzdgd1nJQcqJJuKkVM+Iak7WA32XxpYe2fVq9/TPnlJ3QUEsBw9SISTQLsqbb
         L2Xr8f9HxqCiKlcU7aIwiv0lGGj/WwbCVmHovOQ2Z5orW5ZzcSJu07ruyTzfO8KcstjY
         rgGNr5Ildd03QZ30sB5bKqFd6nq1p/uDgCXINDkTR2cr7ODgk1QVv5IbJ5MVhho+ujUv
         zFlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759281592; x=1759886392;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x4HnKiiE09rl43LC3UECv7NDLXowg9VsBNh2ns+1RXE=;
        b=AglidEA19D0Z0PBIGUcA4gTsAWZu1Xy8WNL4UFoW6sH7th3V5/c/3xHSpxma9mRzc4
         nrEkn5fSAg+G9ta+ZsTZRB/G3r6Js5R8n7QHg07Prsd8pPPB//WcJDk50Y4uPMQB4Idp
         T7GvomS5Pf7faT9YZCQqNUAhUVbkiy8o8XYut0bxC7+BX9DA10z74+WviFgAhtykDJqY
         CX8r95vPNyAPGaXW9LA0NbUw7+e+wqnzvQoJWVmp87GBL3ECdJTBjLCvlHtdf3XLAXm3
         kvMX8H5kaVlEXd14MygVVp/e+9X8T3Ko6ehPNhvCpmPGIJ4hagr1ULw2T4Qsk11EXqZX
         1YBA==
X-Forwarded-Encrypted: i=1; AJvYcCUvhBAorW1m0NGuhWc+EQKlvVzU4ONqqQC1lUAR6+haUDAZS4UD54FudPGsxWkqmjzK5jVxMG3qfw==@kvack.org
X-Gm-Message-State: AOJu0Ywv45brV/G/dILkmBOInxxiKmQzkBnDi1cSfWXJEl7EqPtjAruk
	bDNKEal9uQbd8iOIBBCfzFDmtrbyX+eKfI9V3jvjWgRKRfWK1ku57r5h23IFcuq1TZCTwx3BdxB
	Td99wOpW5Yrf/Ag==
X-Google-Smtp-Source: AGHT+IEBtmTt/de8ZAH/Gty67fG7K6wz+DH/TLooGqCBdKidWKsNfouEipgjC7MTQ3Jd+/633JnpD2gkYNbqjw==
X-Received: from plbml5.prod.google.com ([2002:a17:903:34c5:b0:24b:1657:c088])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f642:b0:266:ddd:772f with SMTP id d9443c01a7336-28e7f276df7mr19249665ad.9.1759281591707;
 Tue, 30 Sep 2025 18:19:51 -0700 (PDT)
Date: Tue, 30 Sep 2025 18:19:41 -0700
In-Reply-To: <20251001011941.1513050-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251001011941.1513050-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251001011941.1513050-4-jasonmiu@google.com>
Subject: [PATCH v1 3/3] kho: Remove notifier system infrastructure
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D91BB40004
X-Stat-Signature: y3ge1e818gnaajpe486fefezidf65qog
X-HE-Tag: 1759281592-759808
X-HE-Meta: U2FsdGVkX19lW0IlGYumdUSRo4XzW2r2wCnrgZhgqSoCE7C3jy7wrhQPfvaqyiDOg9b4HP/q2Km5wQ3fDMWfgoUPViIahrmzQ4m8LneLUiunTlxqU/fiBYocRi9mtqOhxDCBPVt3IQO0KeUlo62lBAiaJ3Xg9o8eI5p4Q1GGC2OBIn/dIDDngbOs/tiVV9puX89WEIU+tNcg/xPLHO4xcSNBoHksZe7K8GMdXZrwxGSetKb/YegnrhSaIALY20269CGv08/fnMxeWeiS8V1uojNjTLGij2T9+TdXeFA3IVZpRxAdUDlcnN9FT4hytmWzfqc3PVcJuAE6AvmzxcJJoTNU9AtCdjbuXl5wvUmLRT+JYd5oHWTxdkD9va7SRaWZMPLd/Gsil4W7VSNFJYbuenGfwThOl1FpxIxQHzlfS0+deTuquwiRH5d2SuPuDUwDBo1sG+vmRiVYs2gq1sgURf2CAamT3dD0KZLEBvwcK27d1RGC9iG5PdKjTWmITnhT/7arluBQOtkF4aIUdqCIzCValyF+ff6MllstmKgf21PUh68yVCWAop7kVwVaYcvewQfA+x38/pE3azbaqJch1CaaAuArJxaVoa3SbR7+Gdo1bugg9sVgMKKzDuVxXGcu7V5RyceWg/drL79l7wQ0wGtaMBP+2eUM+Tn6XY60QDj1Db9OBTpS0IizNlZ9DyqAcxx5PBWntKdoj2JT/K3gqSO63CtLYHFwp/iPVk9aQhgYyst1aRwUm0P0glrmMvJ/knILoTRYi/V05hmlSLvIc/a2CPfrst1FxzBmcBr4Yt1R5UxkZbS37PbfLGCaBbrG/Anu3AltvOMNnENh6ocqO0ShiKoi1IXW0Ep+yxsXQjNhAvC3YEmIH+a+ItT8wB1qFSFuDseQ/XYjI8eUkVbSWQqbaSor3gDXeCgyECsxzwIztx69TpU1uxD5fXyarFA6MrpA5r4H6N2S4aQnNgR
 rB9NSiLs
 C45DhclPvLawkJIXqTrtS9gWaT4skj0VF/WHcP8MfUmvTAYKGUggibTYQGjplPBY/SM5TNHbLsO54o47nBZMTEvJ0FbupGFNHghD5gK4HWUd8Jzw+2YgK9o1Txfue/8WsUb0lKgaN+ILqqp2kOZNfRkf9wtR6iTqs8vc4vTwzYku2W3G+HI4U1Bf5I0JiHvNTcntR9PXcZiw5eIDvonzgnxBwB/9TJ3uFi5gRSksq8aBOomyYR/R4BRv/9h9v4xkV3t9x+/G5ZMv4RcDzbFYkG0B/SehqkSJH1wgiamXOPoufwsBJeOrWn95cK8EfLyRadMe1dGIjFAo2ktixerpYOhW++J0Plc1knTDR5y4eTPmL7nTIKsh8FItADxZw0lXs8mN8nt2gHtOQmM1CNo0l2+J/2s7XZm7mroYrydBBLigHTb8uvDG+l2dgU21+BBe22ccElZ2aCkrsf3oUB8FwQCLvtGKzb3OtWkmhRyJVkwIMgy2Qhvl7pMcxm7bfNdDcm3vBKVRbFnod2tBp/g3LQyg9W8pSPgeTh2lFpVc7z4J5YczIzaR2rD2vE19SCF0DfY5rhDURd9DE/YsttZ1ex/ciMd14Au/08T63KH0bJa52ZXwLzeoc6tcVvYhUL4O0NDJfFXyRD5FPDaeHuOP1kz50w5/k19N8G1TFMDN4GfWupU2vxcElY3KGvg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Eliminate the core KHO notifier API
functions (`register_kho_notifier`, `unregister_kho_notifier`), the
`kho_event` enum, and the notifier chain head from KHO internal
structures.

This infrastructure was used to support the now-removed finalize and
abort states and is no longer required. Client subsystems now interact
with KHO through direct API calls.

Signed-off-by: Jason Miu <jasonmiu@google.com>
---
 include/linux/kexec_handover.h | 22 ----------------------
 kernel/kexec_handover.c        | 15 ---------------
 2 files changed, 37 deletions(-)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 9566c90a3501..09e8f0b0fcab 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -10,16 +10,7 @@ struct kho_scratch {
 	phys_addr_t size;
 };
 
-/* KHO Notifier index */
-enum kho_event {
-	KEXEC_KHO_FINALIZE = 0,
-	KEXEC_KHO_ABORT = 1,
-};
-
 struct folio;
-struct notifier_block;
-
-struct kho_serialization;
 
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
@@ -30,9 +21,6 @@ struct folio *kho_restore_folio(phys_addr_t phys);
 int kho_add_subtree(const char *name, void *fdt);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
-int register_kho_notifier(struct notifier_block *nb);
-int unregister_kho_notifier(struct notifier_block *nb);
-
 void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
@@ -68,16 +56,6 @@ static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
 	return -EOPNOTSUPP;
 }
 
-static inline int register_kho_notifier(struct notifier_block *nb)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int unregister_kho_notifier(struct notifier_block *nb)
-{
-	return -EOPNOTSUPP;
-}
-
 static inline void kho_memory_init(void)
 {
 }
diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index ee4f430dfae0..fc290226e58b 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -16,7 +16,6 @@
 #include <linux/libfdt.h>
 #include <linux/list.h>
 #include <linux/memblock.h>
-#include <linux/notifier.h>
 #include <linux/page-isolation.h>
 #include <linux/rwsem.h>
 
@@ -641,13 +640,11 @@ static int kho_debugfs_fdt_add(struct list_head *list, struct dentry *dir,
 }
 
 struct kho_out {
-	struct blocking_notifier_head chain_head;
 	struct dentry *dir;
 	struct kho_serialization ser;
 };
 
 static struct kho_out kho_out = {
-	.chain_head = BLOCKING_NOTIFIER_INIT(kho_out.chain_head),
 	.ser = {
 		.fdt_list = LIST_HEAD_INIT(kho_out.ser.fdt_list),
 	},
@@ -697,18 +694,6 @@ int kho_add_subtree(const char *name, void *fdt)
 }
 EXPORT_SYMBOL_GPL(kho_add_subtree);
 
-int register_kho_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_register(&kho_out.chain_head, nb);
-}
-EXPORT_SYMBOL_GPL(register_kho_notifier);
-
-int unregister_kho_notifier(struct notifier_block *nb)
-{
-	return blocking_notifier_chain_unregister(&kho_out.chain_head, nb);
-}
-EXPORT_SYMBOL_GPL(unregister_kho_notifier);
-
 /**
  * kho_preserve_folio - preserve a folio across kexec.
  * @folio: folio to preserve.
-- 
2.51.0.618.g983fd99d29-goog


