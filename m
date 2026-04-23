Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE407F589AD
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 12:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 541116B009B; Thu, 23 Apr 2026 08:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 519BD6B009D; Thu, 23 Apr 2026 08:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42ED06B009E; Thu, 23 Apr 2026 08:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 304F86B009B
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 08:25:53 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EFBCAA0143
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:52 +0000 (UTC)
X-FDA: 84689742144.29.95B4036
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf06.hostedemail.com (Postfix) with ESMTP id 26474180002
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 12:25:50 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TeB5fc+P;
	spf=pass (imf06.hostedemail.com: domain of 3zQ_qaQoKCOoYOXMbUZeWUSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--mclapinski.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3zQ_qaQoKCOoYOXMbUZeWUSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776947151;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jpb9j7QMI3LnBirxCYRwTt7/Lt/BiQh7xQw1xaxHQCg=;
	b=cqL9vII+wLWI8EKFvdoukhtR2ZodM1wSw86b9xopLIphMitFJ3Yq/B76yQ5C5fMss3VpRr
	rVPxtK5pENUIZN1wLe6z+ux4qtoOQJTOmbzKFP2zNuqd34luEDXpjE31+t9PBIwAvuVgFT
	25JX76c92ytvLCUU4NrLbT4mFCpnlx4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776947151; a=rsa-sha256;
	cv=none;
	b=pkxCdYu9pCLyxQalHBj/I6fNEIoaT8IbxuHYKi7O822HgIpuZmWowYmm5DtSe7NXRmjoH+
	AIcX7DMSf17vzXHBmZmY0BcCAw9d/0xf3ttx/qIiIFRth49s+/Yp/bTsQkQq3typpvni4C
	RNtMzkic0lb//nN3nt+ng4akd/p/4vg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TeB5fc+P;
	spf=pass (imf06.hostedemail.com: domain of 3zQ_qaQoKCOoYOXMbUZeWUSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--mclapinski.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=3zQ_qaQoKCOoYOXMbUZeWUSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-ba7eadca2f1so315626666b.0
        for <linux-mm@kvack.org>; Thu, 23 Apr 2026 05:25:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776947150; x=1777551950; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jpb9j7QMI3LnBirxCYRwTt7/Lt/BiQh7xQw1xaxHQCg=;
        b=TeB5fc+PmZAuy6pUuqlwf3fuF+DMrT0cJ5AdQjsYSZkT2qn+nwQYUA715e079Tfwcs
         f0b+l7VAZejbCSRRmKCXus6ef9pwxpom9nGLwbsD0piURm8gLomCQoBozLZFlrKt6gwI
         NS/6HDCMc5QvShCkNBqlBFsvZ3yhKvfTeZZrJDbAY8KOjXEAPlP3hcpZoNbiPvVB5wnt
         m7V9SJ1ZcLn39WX5BWMH3+7yIEpdiNAaxvS7tGU4H9uDLrpuP8k+zVfwWSYVp0OApsVm
         i4esVB29icIpSK6JvHmEX+5DOlLlTq+O2Vf3JImJDcot1s5LXd5x9EnyOk0LioBhFzxv
         vpgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776947150; x=1777551950;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jpb9j7QMI3LnBirxCYRwTt7/Lt/BiQh7xQw1xaxHQCg=;
        b=ZZPpiiHdDYHWAgFlautiIOcLSrKiNVHHHZTEMYDCKCNenLv4zL3WcoUEkNuL6PXmbj
         LTzJc6phoA9Fqhcohd53FRR+cY11yIoW7+/+GSJoOeaEVfKqjlRLeKL0GsYas1ccYVHl
         vA966vQkKGgmwEwU7L3ZskHNodLiIeOVETwvF42s0bBkm7bUjdlvh7IqWEzjAZe0p21J
         Jo5Ja0+x8C5AzmYlOGFEQPUnrkSMen4QAB1utirRjN3qwtK4kaCS1DGjfURVJUG2Bh0s
         kVqRuHS2tCgiuzT7J2Sk8SsTF2eRH4yFe8vkg+K16QBLCYqN+00crHaSDu2lhhsrnHBG
         qgHQ==
X-Forwarded-Encrypted: i=1; AFNElJ//lGeuZZpdUhCty5Cqly85eVc7+8K/ifvn6i963TE5qVAC/J5ADL3WFK9htB41fbcpoG1gBnX6bw==@kvack.org
X-Gm-Message-State: AOJu0Yygz2JEykk3VnguUH0Xuc4szQbBnVtV2hQJeNsPGXNcn05CJQkH
	oxrpzo2bhciaxKPjH+8gdHegi5z1JFUnKI8H/YyPH77c9a65NDRmpdx9/+v8Nxpec77dpmHiS05
	mcZzq+ugbLmTpGLhdYMekhw==
X-Received: from edber5.prod.google.com ([2002:a05:6402:4485:b0:660:af38:c618])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:8e0e:b0:b9d:1a1c:a664 with SMTP id a640c23a62f3a-ba41a91e25bmr1360621266b.40.1776947149314;
 Thu, 23 Apr 2026 05:25:49 -0700 (PDT)
Date: Thu, 23 Apr 2026 14:25:37 +0200
In-Reply-To: <20260423122538.140993-1-mclapinski@google.com>
Mime-Version: 1.0
References: <20260423122538.140993-1-mclapinski@google.com>
X-Mailer: git-send-email 2.54.0.rc2.533.g4f5dca5207-goog
Message-ID: <20260423122538.140993-3-mclapinski@google.com>
Subject: [PATCH v9 2/3] kho: make preserved pages compatible with deferred
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
X-Stat-Signature: wu9esu78ps1yaz4ydqky69hi1pg7sr98
X-Rspam-User: 
X-Rspamd-Queue-Id: 26474180002
X-Rspamd-Server: rspam05
X-HE-Tag: 1776947150-518438
X-HE-Meta: U2FsdGVkX1+JP3wkhnLuhd3pOXsB85iuCFPF4VvouUDHrlD0DQr016mkKbLRioJm17qY4sfeCPPtFisscllZT52viKlH/7ykkDW88QecyI4y8flQbBBTs8OPDUjKzjn4lz3fVNIQleOE41B/EA0tEsCRmj+/+4Gdp9HYu4j8/pEXBZb3madvlSno0IHj2WO4g9b/TeTQJ1bWXHNTIIVAw9ThuJwqnIa4TgsgeurGaMKeZJ/ru+qhMc1aI/qA3zwVbaxAHR5bE5br7YBYAMswXwYthdhvqJLA4vfOQ28nEk0dV2Vsv2EepcvkgDt86zsCgR2jT5DsC+MWl+4rPicwT+EFDo3n6DXh39Y21gBLhvtqC+5v1po73QXZOlGAGabOkNfkkNKZMZmK6BRWgndOxS0j6oRlmSNN5eVUWl5y/aSga5nCcBUFfHoISueZOPSDMeLBC84iJPq1/w1TAzoSvdX/vAtIbzH9LbOwcqLzQj3IxKRng6z/Oo0X5tE8EN3yrQKU+1ciE+RGrj43YKDBow2HN5OgWU852wHMHAW5CdIwz43oYQh4RfbNljd0TVdpOI8hJDt5Ez+CHIRGB44KTbrgenDbWdozUH1R19U8uuBsgPhU9dn2NEfLDJYks6VvkqTcHYndJ+aoRUXx8u+G07Rum+L+mX1+6UmC2MEFyFkXdY6CFiOPOk16bAjZVYXlmEZ02WbunsE9FGIq8DAu6y/18Z84tHsC5UvKOPwJHxDhKLPqbE2yIXqFWldtlSmkuyGQ6QkiXbxl/gv4KjMfcfY02qAxloOsqPK1JE/I1FDfEFb80jBpqdiDivTV24UxzMoLZaSwWomDEkssaWO42ciRlat6tkr9sbjG3U/lhDfEVrMv0r6T7deCQmSdWE81H4Zmeh5esFw7JllLW7cisdXALK0N5W4HgFhYt/1LFMIMcaNAPCStPwgqoBIryKT/QvvJ8apFCyWRWnMxtpz
 6VqpKY6+
 kh9fDmMA7Evt4wkL/VikjNQD4yDWuPaW111zkv7e9rfQRTa7M+VCpsvDi+0+FXWwfzigZIplVPz7pg2jD7SyKCFUhECghd037FpT9IxXDIUuvlMgTYySCCKhSfp7U5RBpZCFZBdlyXKVoP91CYUtTzZx42vvi/CYxZJFtlsYU5j7k04vByF6+ajGpo6JjDmRcjWAF5LxKnXhqZKZv+K5CbxKGV3tKMNav4vdBV2+9wWZ5oXkF/62J4NSn26qDdkB4hHpNRTlzjbPc+EkfTmPSIDA0w1KCH0l8gHD1bOcM9KvSO4kLx97M+AgED7ZVwF97wRCbTriMhrvKTw+DtNYdRHfGOvQ+yWvyBH/i76ICBGdh7+uIgVr0zYWIEZGudGBYEYySRVVru0KivPDWLc11NWDusRIX/b8NFBVavmWmgHGR03vHGH1hC75ST7+2nBuB1+djtotWJ4r9lfe1RDTnJGbkfSA+gKUUL+f4hksngwNvdGcSHlVwaIH6Lzlg3B3J9Vfe60Na9lBqyBDWNT75p8Qk6ChIXti9jyQkJ14TJXRX+7BGPWxDpPDU2WoV5ZUIffmXAfKPd2xhZPWdX68IKTpBICfESabJrLVJYGaow+lcyRndjVbtg1T8A2OBfViVrfy0TLc7O7RBOhILg0vf0iQqKAz/a4omHO+v1I5hbXLTpn8Vg4ntlNjtglT/o7VGJlfiWibtxYnpR8rBaSugaT6kjr1WJFEiYzlNzIcHYsd2kB8=
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
2.54.0.rc2.533.g4f5dca5207-goog


