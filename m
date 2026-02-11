Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFEBCECD6D0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 17:40:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2B9F6B0005; Wed, 11 Feb 2026 12:40:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9246B0089; Wed, 11 Feb 2026 12:40:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD84A6B008A; Wed, 11 Feb 2026 12:40:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BAFCB6B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:40:03 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7436213AFA0
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:40:03 +0000 (UTC)
X-FDA: 84432889086.11.89B6ED7
Received: from mail-ed1-f74.google.com (mail-ed1-f74.google.com [209.85.208.74])
	by imf25.hostedemail.com (Postfix) with ESMTP id A1056A0013
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:40:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ysRItyEh;
	spf=pass (imf25.hostedemail.com: domain of 3776MaQoKCPIgWfUjchmecaiiafY.Wigfchor-ggepUWe.ila@flex--mclapinski.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3776MaQoKCPIgWfUjchmecaiiafY.Wigfchor-ggepUWe.ila@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770831601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=dlNHJZ4DB/YIFPcTP8iAwpEYyWUng6cE6zKvxjI6tZ8=;
	b=NW0MgXlwzErMHycQ97/l92Ny4Ux6Q8RIvFFe6CUFPI5iAE6OEMY7TSyst+9QHBh2Wyk6tJ
	dBpPLjQBEA7a0xFISEJgs8PpShpVrKdzYQLE6RtWTkC7IblP3O/pbEXuO/fzo26m+HfbTl
	Fm7Hf/1NoYRtVhDd5/g6Nm5i039saLE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=ysRItyEh;
	spf=pass (imf25.hostedemail.com: domain of 3776MaQoKCPIgWfUjchmecaiiafY.Wigfchor-ggepUWe.ila@flex--mclapinski.bounces.google.com designates 209.85.208.74 as permitted sender) smtp.mailfrom=3776MaQoKCPIgWfUjchmecaiiafY.Wigfchor-ggepUWe.ila@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770831601; a=rsa-sha256;
	cv=none;
	b=PUCn9ONN93nKrHuXpkCA3jjJTyRT4iEk98a0LJVoE4As5cOT4phmnHh1kPZ/HYqaR9mk/J
	AlOCRkaKAhRE0EPogMrZhIsxP4PbljVYhM0QBwTvvP8J/s56s8sIijwi3JQrPudkyA63ip
	C2D5LNk/Eu82SFDYyRZOxx3BsXxfZJA=
Received: by mail-ed1-f74.google.com with SMTP id 4fb4d7f45d1cf-6593d768a99so7450761a12.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770831600; x=1771436400; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dlNHJZ4DB/YIFPcTP8iAwpEYyWUng6cE6zKvxjI6tZ8=;
        b=ysRItyEhuxi3uSvxGiP0Sv5d7uSM/qVY25FYpNWG8KWDa1ZyZ8ZZmcjTri4wbehicw
         hQhf/kvdHDy9YgqaxLPS62hDr8q6KvZoJMltFIcDNSFF8E6Rn34rEWiUOtKOFikfC0Hm
         sOkdp0Ir1RbD2JTedIqSn9ISyFUhUhv7jYxrXDpCH91mKDJavIJ15HGQPdYWMO9R37Bw
         fQko0UgkpIDp+Gy2FWxhgs0B9bv2Yq8PC1MxITl/fncU1YLFEm+w3vhQP6UsFh6NK4Q9
         Jumir0kCCebrU6WYB5599HDU1zBTlU9DYoZo8IO8e25UtQwj6yvFd2k1HfkrrP8VLNdI
         AdjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770831600; x=1771436400;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dlNHJZ4DB/YIFPcTP8iAwpEYyWUng6cE6zKvxjI6tZ8=;
        b=I5HFTcdDVJWLMPmOTU0mr63yu4MCT+6In2V45omNTmqB4fLZIdF7BmkeGluqbuaLQf
         +a3NwHUlxD9qhM7lk4UG8u3MVNcqf5eOPFxWFVhEsHA8S+MJtHZ2zluG452cPWVQ/I+O
         VxTx0hodSdoWKkrgohbbiCuNkGGuLd9g95/O8VxRUz8L/rIXqcSdOmT0kx6LQRvjeQ9O
         ekz1/FAecGxZviCKlT72FukBVK0nm09jkY9ALTPzAUXa7twjmu28QpnIluhP7h68wrK3
         M9NwCWcq5596UBYDB0BZb7yaHKktnFy4VHC+bBdjRgg2l0sxOI8n2ip9WQ+sZp3EVLZo
         NOZA==
X-Forwarded-Encrypted: i=1; AJvYcCVp6SgC11ScCjsxhZIq9bqaJYDcbytBsm0iRXu/V1hvf0dGzk+8ieDo2SsCChRwAPkcLEAd9sMIbw==@kvack.org
X-Gm-Message-State: AOJu0YypIKQka/kJIyiO+ednAbgaV0CxCU7WFXD51WynfXYBXkKG1u6Y
	ETDh8fgHU66o7P2DPXlPxdp4tcr0ADS1FtnFZXDJluHIWXGP+FkWGwqootLZLoO8EtfHg8BhhGW
	ys2uirx5uyUylklPDz2JOuw==
X-Received: from edvj14.prod.google.com ([2002:aa7:de8e:0:b0:64b:aad7:d741])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:907:930a:b0:b88:463e:b55f with SMTP id a640c23a62f3a-b8f6a8e08c2mr193618466b.6.1770831599663;
 Wed, 11 Feb 2026 09:39:59 -0800 (PST)
Date: Wed, 11 Feb 2026 18:39:54 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.239.g8d8fc8a987-goog
Message-ID: <20260211173954.2091119-1-mclapinski@google.com>
Subject: [PATCH v3] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: A1056A0013
X-Rspamd-Server: rspam07
X-Stat-Signature: 3tcey9p7gcfybrz4okxo18iipn7gxoy7
X-HE-Tag: 1770831601-311965
X-HE-Meta: U2FsdGVkX18yBU9t9co00k6DWhSkrxYfSkW41ztrxfNx2wwPUTU0JK2wRA3hovPspCvCGnPvOTBLAqmD232oHcW7idzJ1WqGPU+kvrRZLQJ45c9obL3xzBKpUwd8YLqHeWYHOaZ9bQ82CYrlHth31KcQJKkZNhsznDvkXza9jHGUqHbHo5U7S9NshPyetNmBINlzjFHcDCbuNFOqs21wzcQbvGNxNXaC+KRzF/RDkzgsqhHhA8MKOjnPwATMVw3Mkbmyl7tmFtVB5UJdbpU1F2FAEjKCvG26iSlbBFWuawr5486wt3GxnKWMKhB8+ezp4C7ArAz/6zfqlh8IMCHutHGGs3kdqonDzLmN3cnXY+T/MG2cOvZuPQVueWDoux95cVo4ilvVOnD92VkX5otRtMnywWVNcyX6hs7jot9kT5vC07qXGeAU1IdDikAnVegioL7ssG/Z4B+wCz2k7dcM130mcIm2gluarpUYd2vVxmgsZI6qbEeCwVI+GqeVu8gA2fXvEfwfoeFmd+Eje1kodw+ATLlOP1F8NXkIWrsKcAMFchunab4kLpsSn9M+YV0bP653wZviva2ruLRN/GAhgHtQaqhzpHwX0Y+5u4oMtaKVv/sSBh4bJTMN7wfrg4rYFrIKxPAugQrw3/kcdWgah+cUDfuR0qEpZwZi9vitn6w2Aaz2+Eur38/MSFcANkjMEn9W4o3hrZ7SDIXH/jqDfrutHNkMdyiyFvJu1l1I4NJYQcR8/lBD9j/X1wl8MSeS4E3rZYDYbgKZcbFtexgXh4B7Oh4zOekgb1kVlKkBmdLj02fyMSv34smmwGZs7127OMR2Rh512ETmZ6FYOx5bL10/UNGP9FYOBMUIpmWorRo5cX22eQfCRY09E5EpIClhuOvchRp9rDLAH1X2o0mmrmYe475naXA3FW3r8Al5glKogzBF/mrMb/WS3WWSDcPCeUcr3MKC+cf3bWOXEKz
 vGZfpi4d
 RBDTnUdUtmoWNXeUvJATP2rRLXgkje+K13TttX/nRgX4/pi/axQS9cIHAYKcnFMplP+i+q6uFka5A+ev/+YRb4Iy4VYnvzBEPh5iBARtu8DfgYCEeBlSSNKPJ2tzXjAz/7YkFkknPZ+6xlVMZOdq9nfbf90IMbF8mqdzgO5R+mWVhmfgeIUZH8S0LT3S+/PQJov437Aj8eNx15/hsCEXt2HnsOdGbBhtFWWUwYwHHva88EnvLOpjZjKZdfVvBvHqD6KqkNrNlY5TCmhtHEpLvsmRhZgeEdtsBoxZhtJjOEcsMG7YEda9RJcXMcohpwbEsSEZKnlaKrKX5xigB2DU/Fk/3yr5LM3jOmRAfLmAUzZIiZa3q5GZeaKjk0g9kJ99Y9urocwI5kVLJN/FK3mNo8GFYOT/MFOBlirZXglYqVKGTXXoDru6I00boSrIJVtXwdNU/k0OaySAp37YcVzDBxrjmAxCTES5arR9002ECvJACeM4ok32G5AdkTcE6no2Rwo7FOtFeNkdT6uFzSnkLcgF9G8uxaZqdrH2plFBPnUaTHuyUu8Ifm4Sd7kO5qeFcjDAxRVqDMiG85i+dsFLTVlnmSWpY0dquqNlmP5AvE5KI9Eu6c5fCcy/W5/AYtAf9Uk0f5B65oy0u140zZafL52IkZg==
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
Signed-off-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Pratyush Yadav (Google) <pratyush@kernel.org>
---
v3:
- changed commit msg
- don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
v2:
- updated a comment

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
index b851b09a8e99..3bc14f3d7690 100644
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
+	for (int i = 0; i < (1 << order); i++)
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
2.53.0.239.g8d8fc8a987-goog


