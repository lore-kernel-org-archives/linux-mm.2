Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68C5EA8109
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 13:04:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7B86B0005; Tue, 10 Feb 2026 08:04:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBFA26B0088; Tue, 10 Feb 2026 08:04:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBE8A6B0089; Tue, 10 Feb 2026 08:04:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BC6E26B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 08:04:39 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 16097B9E04
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:04:39 +0000 (UTC)
X-FDA: 84428566278.30.52BB84D
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4663BC0009
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:04:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PMy9e8X8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 34yyLaQoKCLwoencrkpumkiqqing.eqonkpwz-oomxcem.qti@flex--mclapinski.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=34yyLaQoKCLwoencrkpumkiqqing.eqonkpwz-oomxcem.qti@flex--mclapinski.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770728677; a=rsa-sha256;
	cv=none;
	b=N0k5s3u46FaFHV0dKcaVZ0LrEgfk+ZpDt4msbknk60HcCGXE+fcfIwD9UMzhWk+Ak4DSuM
	QwnXwzPFBWTWbSTnGjqrdZCn0Pp3OmvCKQEwI5R3k9saC3zOH2rrokYb/Jf7BEOsuyalbu
	WBFnjmap/G6PRSGPuFbO+vqXPBxirD4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PMy9e8X8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of 34yyLaQoKCLwoencrkpumkiqqing.eqonkpwz-oomxcem.qti@flex--mclapinski.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=34yyLaQoKCLwoencrkpumkiqqing.eqonkpwz-oomxcem.qti@flex--mclapinski.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770728677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=eH6JL7gkCCkK21U6qSqUgOiFfCqEIuZ4GNLMeFzGLJ0=;
	b=HFzeCmioXMYqJQ8I2wOXIybWuB7axs/Do64omFDn66mrcnjNeC4XdCH1pm3blDjQkZ92JE
	Zgu4whHM4jt12LZSaqH6ns+FCss8PK5e8zJ/uUyw38wIMl5fLdx96/Mf/VAr5cWR5F8qhY
	OOVxRlBYlBOysYIvp+A1z94VUjtHT4c=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b8d78d3fabfso345688266b.3
        for <linux-mm@kvack.org>; Tue, 10 Feb 2026 05:04:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770728675; x=1771333475; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=eH6JL7gkCCkK21U6qSqUgOiFfCqEIuZ4GNLMeFzGLJ0=;
        b=PMy9e8X8TFSUKTMvfMf8JiJOy+of/DF5kSgwbZFgnI4RIVXA+dgPg9wCQ1cMvKwtyb
         7Q+Guak3mGvtcjFAocouPNDZ1ozNMhpYYkGFVRJxwVkHA6azkduZfnVXtJQiFuLAHxVp
         9bYyliAPyOA6YafXMTIOC3rX9i4HQ3/RQzRmA7ztnl5xl4DDICQk4blNy3/7DeS8Y5lG
         6JjLGABzqTo+veV01gynjrMgnK2aM9p9jL8MVEKpXcT4IQ+oYRd4aryfYpOXx/ARDLT8
         lYy2L/KMoDwrnI6jZAKoLwq+2GljvfAEJKUke10NBJjRNl8QePg1iOqI64pN6zHeEwTd
         HrHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770728675; x=1771333475;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eH6JL7gkCCkK21U6qSqUgOiFfCqEIuZ4GNLMeFzGLJ0=;
        b=VsPAGQ8/I1f0xr5VZyJ+NaLkJPdgQ73Ct4jxvZS8CkWvC3mLckYXtfYab+gY6Owkex
         YWiiBth8X7W2MedFbspHpznMy8UBB2fayPs/f/LRTKuiY89RFWu0BZ58d5q7ln48UD0H
         O//Z9r5hDNt+hrtoP3V34SwphrV+pO07KwowOn2WWvDhay1nI/EVlAiIafBFjQc1Fxvy
         SInlq2BGNZcxaKoO/fhTvZ5XQ7Vm9XrZTfOoYvBYrTIGZHhrYfFtMm8Qnuh3JIv9oVR/
         pUlebk3f6JVp5wCbkaQaIR3JA3O+Ocnnz6NXeeVqIHSUWVNJxkFo2CjOb7n8HICR9bMn
         6E9A==
X-Forwarded-Encrypted: i=1; AJvYcCV4RODWDKi9V9dCYnSV5Z+GS90bNAJ0cG1++wER7maMd48kGxLHbrknqI4aZfDEYaJpSXQyPgTE0w==@kvack.org
X-Gm-Message-State: AOJu0YykXorthqse/cOvfshDv+GBcq7eRN3DqEYsHh+5JpuPxLRoa70U
	XGu56bejuRIRDCnxETSimjlPNjnr5cA+c2g284/bz4TVrn8BmAeLZ08ThX3fZeoJndUNsEOi4Qg
	1oltykdNgDTXdfdYlabjVYg==
X-Received: from ejeo7.prod.google.com ([2002:a17:906:8c7:b0:b8d:7cde:ce4d])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:9810:b0:b73:2b08:ac70 with SMTP id a640c23a62f3a-b8edf33e476mr828942066b.49.1770728675354;
 Tue, 10 Feb 2026 05:04:35 -0800 (PST)
Date: Tue, 10 Feb 2026 14:04:18 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc2.204.g2597b5adb4-goog
Message-ID: <20260210130418.297153-1-mclapinski@google.com>
Subject: [PATCH v2] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4663BC0009
X-Stat-Signature: s3n9irxugd1sqf9kauhyhcx198b178p4
X-HE-Tag: 1770728677-569117
X-HE-Meta: U2FsdGVkX18rEs470LOY5nHSO+jnRtUD2kOTinuK04Z9d2LARHFIFV9OgaBK6UmOM2qsL9cKRTLjNTTv+Xog3e5z1ER3Sj6ihv+eN5KrRNXO81Lgz8VJnA9DmccWP4u2wUnQPXVJUCSU2OPiXQXJ++RRQz2j1ekvp1t+kKs2xpNJDq4AWvzX/iz5kQkn6GqUShFAQPhUtVp7QyDXgWN+MFE4iaUlbXCcOafnbhndy2gT+pzZM68sbNF7XfFgF2ZpfxMh4hmvJyviYKYDcqxPwIfj6AAGJpa5/ng7aVQPde/OjxrrK4fDMVSdOOB5kzLRdCTuPwkQwtXswTxyl5rOGXz9GssyixRnOf8PBadGsISoOHmd0saFgXe+lZlbyWLeV6qBD1iRknPEKXQOvyvZN9Fnf0NfsUb0yDkSYL+55vCqkO9EKnFzCW3tVP+aVqYW583ihv4wX7fHFF2O4lmN86Z3blHPQONeN89b29XQ3cJEkVn4+XIgUBJQPszh8kBDGVSpzOb/kEWE0m6gP5rj4GczxEeWZepe5qOG7Wm92SDFL1q7uBf0fnb9fr2S2sKhWXIOoXKWPk4q239W0O/i+Cb9aQhNvkMVKHsMR3jzKxEGSvgRRyVfMNbr0KckjjD5Az9t+2eMTRuHQyda5g/QukGrLuCEeWiDOIiXxanVImwqKhyS00vqf2s5t2kprKCrHL8Nwa3cdxV6Liz4K4tTLdpYnpxgahN/S0vb+AZhU5n//TfCIsDNEnEz+luwebmTP2CtER0v1l1NMPcs4oXPfxtnKm3NRxqQ8rgOddX3A8qis3DDRzxJc6okZ0stqSFAIlLuBu1DmvRyGmKaE5aVq9QMBWT2Ss+7TndDUAlPInbnGLM0/jh6qCgp9Jb5A5o4ShcAIm6+mzfWlLstE5/VqqtPrHo5uqmp4FV2qwqaSOyt1v+wUGUX+ONmuGte2XpEdmDPRBPoo//VdcX8vco
 6sdVgOU5
 7AzJ7JG7a7qXcvkqDycft3pZ5gGPwQnXtshvE7QjKEenfuT38eme3Q6ZPohiP6cxZ3Bv9uM2XmhrKHIZXrkUzlzcc+myjrOEBLlyjYyRsi+ZoMVqY8b8O3AUEQ61i5DJYV3k76XH2Uu2B2IGgEfuIAGN0VqHQbPp5vflHPyMU5ngfVpoima7W2iEQDTvXHz48UwSt0MyQ4HfHnb8r6yyNXcsb3vu8ELh4K0lEdygTF5thDtvrCp5lJVsdI3/bOmL/vZuOae324IITLOwKqH4Yx3sFTqz2v8NvZw1bSXfeSDvGxDMx/OJtHRMe3nYPTIgmPh0WPcTkKJceSWhPlAzZafsVByG49c3nRkoy4AFi+HkTyfYSyj654lVtuNfCreEYJYReN7A6lkGs9RtoAUdGuwmGhXuNkHzM3wgyAglD7/yGssCFqwEwncQ8gTP05cdOJRV2+gWC01gs9hVf8dWf1Z1Kp3u2uyRyofyLBkRO2ivQZrQq0oDWvglErhr/RWV2FdxlYEBCz0GRsZmVph7C7wKzPAjY7BrlSo/QEb/s/sjKGH3IM8XEiidDpgZ2G5Orc2sn+sjAu/I2t8Oxj3GaTKLlQtvPeR3zQNglQfDEkpS4yplHBbYVGZadKHFqWfqUb3X6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When `CONFIG_DEFERRED_STRUCT_PAGE_INIT` is enabled, struct page
initialization is deferred to parallel kthreads that run later
in the boot process.

During KHO restoration, `deserialize_bitmap()` writes metadata for
each preserved memory region. However, if the struct page has not been
initialized, this write targets uninitialized memory, potentially
leading to errors like:
```
BUG: unable to handle page fault for address: ...
```

Fix this by introducing `kho_get_preserved_page()`,  which ensures
all struct pages in a preserved region are initialized by calling
`init_deferred_page()` which is a no-op when deferred init is disabled
or when the struct page is already initialized.

Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
v2: updated a comment

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

I repeated Evangelos's testing:
In order to test the fix, I modified the KHO selftest, to allocate more
memory and do so from higher memory to trigger the incompatibility. The
branch with those changes can be found in:
https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
---
 kernel/liveupdate/Kconfig          |  2 --
 kernel/liveupdate/kexec_handover.c | 23 ++++++++++++++++++++++-
 2 files changed, 22 insertions(+), 3 deletions(-)

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
index b851b09a8e99..26bb45b25809 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -457,6 +457,27 @@ static int kho_mem_serialize(struct kho_out *kho_out)
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
+	int nid = early_pfn_to_nid(pfn);
+
+	for (int i = 0; i < (1 << order); i++)
+		init_deferred_page(pfn + i, nid);
+
+	return pfn_to_page(pfn);
+}
+
 static void __init deserialize_bitmap(unsigned int order,
 				      struct khoser_mem_bitmap_ptr *elm)
 {
@@ -467,7 +488,7 @@ static void __init deserialize_bitmap(unsigned int order,
 		int sz = 1 << (order + PAGE_SHIFT);
 		phys_addr_t phys =
 			elm->phys_start + (bit << (order + PAGE_SHIFT));
-		struct page *page = phys_to_page(phys);
+		struct page *page = kho_get_preserved_page(phys, order);
 		union kho_page_info info;
 
 		memblock_reserve(phys, sz);
-- 
2.53.0.rc2.204.g2597b5adb4-goog


