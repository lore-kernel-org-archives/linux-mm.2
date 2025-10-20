Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D527CCD1A7
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:03:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CBF28E0017; Mon, 20 Oct 2025 06:03:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07D568E0002; Mon, 20 Oct 2025 06:03:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE778E0017; Mon, 20 Oct 2025 06:03:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D85398E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:03:18 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2DCD88A4C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:03:18 +0000 (UTC)
X-FDA: 84018054876.25.4E5DAED
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf21.hostedemail.com (Postfix) with ESMTP id D929B1C0013
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:03:16 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xEvNY1NX;
	spf=pass (imf21.hostedemail.com: domain of 34wj2aAgKCBwB2KGFEAM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34wj2aAgKCBwB2KGFEAM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760954596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l/xrVZHpXvHRMhRkGHJU8i3nfYQNiwJDcAoOnm63ckE=;
	b=ouCYWamV/HMqghAlSHvQMUuQg2j811HV8kIl88EexxO4z40UMnZ4Vc8fl3/BYcfHXflUaL
	8YZ5Lm58YbnjPtoKw03um6IgWJCxpM/urer8N7y1bv2uZek7GnOrG7Kj+k5UiYf37p9ZLL
	8L3xLTEZASeD9vbeHj7yQgSxomUKUJQ=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xEvNY1NX;
	spf=pass (imf21.hostedemail.com: domain of 34wj2aAgKCBwB2KGFEAM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jasonmiu.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=34wj2aAgKCBwB2KGFEAM8GG8D6.4GEDAFMP-EECN24C.GJ8@flex--jasonmiu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760954596; a=rsa-sha256;
	cv=none;
	b=vgyyTNl3Ct91MN3mvF8u/G6xz4d80o3xx1p+P1LxFenTT9BCR1185tqkvfn4sCjf7wWKuI
	Bg9lOdNJ8HqwwgrH9WwTBexOFEf3ZoQn5I8P2fKbwaaEZV9Xe1A6x182dfaULef37CB6r9
	LstigDZoxlrH0FJNjehFNkMZUPgssds=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-27ee41e062cso53714165ad.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760954596; x=1761559396; darn=kvack.org;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l/xrVZHpXvHRMhRkGHJU8i3nfYQNiwJDcAoOnm63ckE=;
        b=xEvNY1NX63NvvAop/mV8kv/UdB1yDFRa0U+78XNYoG8bPpWdicIX6Vu5wkQrg92+c8
         87Yy8rc7XHQ7wzyiaavNnvdKMAbxeZ0hhzB3H4P+ViBz96SeJUuwa20HuYPqlS4lc9Ru
         lmouER5GOA4nu3kSYkrXg408OCWVX3CdDJRcTkHhMq+ev27dj94nHjj+WNKxRYuivCaA
         RnyqZhNlNb8sZJ3JFNal5jZYawSKS/medq+BeOAcNmqr6Nd+jAMk/tnzx/5Gw/mp8ovN
         R4xzZJNWqw04g5Ao8eVdekQcIZnkOakplpk9+muDnARUObgDDNxGwqkTzJcmTn5b/5gg
         xiLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760954596; x=1761559396;
        h=to:from:subject:message-id:references:mime-version:in-reply-to:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l/xrVZHpXvHRMhRkGHJU8i3nfYQNiwJDcAoOnm63ckE=;
        b=HMLJ/23ROdEh09vv4HeN6cfSfD8blW54Gm0jJqB2eM0LslGakOROV7+kdIx6YeSaoz
         HY6y6TLXJqyQGr0W6UN+fLi1ttLdAEw4QoTVbeVapVDnpa4fThZZgNSr64AIh7F3+tm1
         sA1ld3PsUsccN5+o46TSGQYhvJuXSNlsUM/42zWev0JyC4sOtNViScSniZ65U3EnRect
         8WaArmBWs9rSarFZhrz5PkrY20ZpVNYsRLJNMOPrm/AHcO1Zkkg8q5/GJXFSk05Pylo6
         EetXfeFyZA3qSCSlvTZ7GTyKuTp6XUqcOpWLPBOfCiHNp4rv6pA6EiYoFSjOUnI3LHYJ
         +klw==
X-Forwarded-Encrypted: i=1; AJvYcCWS8PYUrEUCQ6I3Ruj6p6F8cLR64Z/Tn5rR7plkOypnVAIoD4ATZBd3BMSDEQ1RG35e0pGkNip6hg==@kvack.org
X-Gm-Message-State: AOJu0YzMnJl79gWfSwJ9ADCP5NTP7sWnCYEPQEiEN7ekPZ/sfnf8YUcM
	yiQpvOoMfqw+VR+MfsUa5SugCcRejQkalCXTZq4PRy+c7nDiXgD9zH7JcNFTIgYbGWZHU6NDYQ9
	XiDTsSG0voL8JNQ==
X-Google-Smtp-Source: AGHT+IEzFK4LZayLd5iN1w0uFbIESnuBTugytBDsMRryC9YXYqChyResDflUkGa6F21iVpOozbAUdMrrBXy9VA==
X-Received: from plcr12.prod.google.com ([2002:a17:903:14c:b0:290:4eeb:bc7a])
 (user=jasonmiu job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d60d:b0:270:e595:a440 with SMTP id d9443c01a7336-290c9cd4b48mr146517415ad.25.1760954595745;
 Mon, 20 Oct 2025 03:03:15 -0700 (PDT)
Date: Mon, 20 Oct 2025 03:03:06 -0700
In-Reply-To: <20251020100306.2709352-1-jasonmiu@google.com>
Mime-Version: 1.0
References: <20251020100306.2709352-1-jasonmiu@google.com>
X-Mailer: git-send-email 2.51.0.858.gf9c4a03a3a-goog
Message-ID: <20251020100306.2709352-4-jasonmiu@google.com>
Subject: [PATCH v2 3/3] kho: Remove notifier system infrastructure
From: Jason Miu <jasonmiu@google.com>
To: Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Changyuan Lyu <changyuanl@google.com>, 
	David Matlack <dmatlack@google.com>, David Rientjes <rientjes@google.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	kexec@lists.infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: tecid9xhjxuiug6hc5xmtcyhzdmncucj
X-Rspamd-Queue-Id: D929B1C0013
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760954596-267168
X-HE-Meta: U2FsdGVkX18YtOAlPR4wuo1VjlriKgVJDKR1u8oX9VX35QpdgdP9BP3VmSq5cO6KbKtRUlVHZqlqFxeTSAdl5AXHIA9X+deIs6t1oLV1RhzFvsrDwwrrg0134rUryi19LnM9q/ZYCsiowzlSWYaxLiIUIQd/9KVd3P9vV0HvPyPsB8aEOuPPoLoMUXR0Y1RoM3w0rCe51+YKVnWT8mBWPqIPFHLPYTTfe3/gICwacU7nqlyDeSVumpIuXCkT8DCCkG+35au/LhwDrGikos4ckfXV23CIP5pPIbHZNjEh4anQYalce5DQKtaAPALz8EcvWR+ZLxCs9aIKpPy8wMpYKeaSztYDvjeXRsOfe/ITbSvtAZlm3EcN2kfy0c01Ey2olujB54rE/SjYfgJm8t2HPxOcrL54reksp26VpW9RmPSiaBHao7rlB3s+A+Wgtl7QwdAFHlFp6oC9rimIdUUph96H5nR0VqjmqKeMvDtRwjEQ+nXF1M8A2WTv5FF6HsKiC4BV8tXPluvKsGZYkWoTv6Fecw6wUz1iPfMHCTGJfVuva9FErsU48/KV/GPrCZVkPppKWEsPqWEfmgjDZbVFAM27REpV+M77OBnl9tvYMzUlDDUqjsrRUCbgncoahyZvFsS0OzAdEpDjbjobJLJV8cHiDS0TSxYH8Sov3JUd2MiXwzShPOOhqMKP9r3qByXlYQw6ccg6v3f4p3zZaBoyoKzumGN1TnTt/0vm84gRCxwhO0A7eZ1CqEYXuGVnQDC5AvrXGvGUoFdRZpdXEV3bwcN+ah5RxKs2VnnhiX3ir2um3SJrabRz6pUPBeRaFdoDGDFmidoDf9jxsKYDCchJ8pyy1u0s5ir95Cc0E73SlsPGiYRykw9u/97FtwYLU4Faxb8qoDaq6XLV61Z02UFoTB2TC01KU1S/MFyWbeVYwdYzGoLr/PipM4kPVBCvOAcaXQbALQ0AwJUuBpG6b5N
 9db5HzVC
 Wyn8KS0gNAIhrtZfILdSz4aiDNvBI5lyGiuXhs/dTjFDgknJP+is2sXSv7OWOIXXrRR3B02oFouVuRazddeiOrm5ChhOb5CmwDHucC0B65c3DiIwT03TkZ5p6WuAnpX7l4Cio0rNgdbokV1KWdbT18SUa1dBGpJt10Q2/aFFflNK2/6qoNUrz8zPTt9cyvUPc7kpd2y2hy01tWt5SHE4KOsKNh6t56CxbtZYiqmodnhI7GU5bUlY1+yW7JDiA88FZZeAHZePvdoX1ednH8y9G5O7IMSfCda420/ffOLknYtv5bxnGolXIBMYBQ4jHo7pdtNBKKJdSHw+1BTHKq5MUdQgVNt5itYS82DaYS3D3PoPrZWD2Oj/JV/hQ3uJ7mAnqiTmhdVprZVPt5ZEUDdMTtYvOOjSGHLzDrmj/FM2Uf36DeWL1XnFAMhBEc9HKU7IbSjVygG4bts56vdqrHp3KFjpIiAcDoL+7TjHvQMPEEo+hOLdg4wlQmy5jRqQ38HUQSZgxYAxkNEoIhmrjZwMV9KAEvUnzgjJzkGge27hi4Iy51TNwCE/EHVo8jDZRzSoq3bnsU9AsoJ7CyxmO9zyNlb3sbMbqOIIMTFSKNCmgBoLFybQEdo0J8mLLtg==
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
index 1f2ca09519a1..d345f301c57b 100644
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
@@ -31,9 +22,6 @@ int kho_add_subtree(const char *name, void *fdt);
 int kho_remove_subtree(const char *name);
 int kho_retrieve_subtree(const char *name, phys_addr_t *phys);
 
-int register_kho_notifier(struct notifier_block *nb);
-int unregister_kho_notifier(struct notifier_block *nb);
-
 void kho_memory_init(void);
 
 void kho_populate(phys_addr_t fdt_phys, u64 fdt_len, phys_addr_t scratch_phys,
@@ -74,16 +62,6 @@ static inline int kho_remove_subtree(const char *name)
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
index 1138b16fa546..325b83a609fc 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -17,7 +17,6 @@
 #include <linux/list.h>
 #include <linux/log2.h>
 #include <linux/memblock.h>
-#include <linux/notifier.h>
 #include <linux/page-isolation.h>
 #include <linux/rwsem.h>
 #include <linux/live_update/abi/kexec_handover.h>
@@ -674,13 +673,11 @@ static int kho_debugfs_fdt_remove(struct list_head *list, const char *name)
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
@@ -787,18 +784,6 @@ int kho_remove_subtree(const char *name)
 }
 EXPORT_SYMBOL_GPL(kho_remove_subtree);
 
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
2.51.0.858.gf9c4a03a3a-goog


