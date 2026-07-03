Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBA86C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 02:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9DF16B0174; Thu,  2 Jul 2026 22:08:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD91C6B0177; Thu,  2 Jul 2026 22:08:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A163A6B0178; Thu,  2 Jul 2026 22:08:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 52BE86B0174
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 22:08:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 90EADC1928
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:47 +0000 (UTC)
X-FDA: 84945831894.08.80386A1
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf01.hostedemail.com (Postfix) with ESMTP id D3D0140004
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:08:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UUSLFXPi;
	spf=pass (imf01.hostedemail.com: domain of 3rBlHagUKCFUCExxA3BB381.zB985AHK-997Ixz7.BE3@flex--praan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3rBlHagUKCFUCExxA3BB381.zB985AHK-997Ixz7.BE3@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783044525;
	b=h8e+TBVEfUNUsfFFN61s6IJo1PqKf5u2Xm1wcEIeqnC6bUPUOCQBqBPXDm1RBoEQjE6h/c
	DPgqkZShTr9Yiygxi94S1JbsiwbNRjslwfjIPxbJdKPhkGbfxPLb1x9FKwTRG7C+nC7UuD
	PQ3Su/7GBbdXGQ0UIRwJ8MVWB68sl3g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783044525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R42hNae76A7CXiYkYtHihW2CvpPOkdd31plc72X+MXE=;
	b=jttn9WbonjaWx8jcZc01sPBuep7RJDAn4QycVlaHDJU6HpG2Kx7CfkG2fRNClIg7Wr9BaK
	rRtvyrEOpoO51dNImLPJ0ddVCdJFnGsC8etxFQywS1l5XPTvf/T5ytE4N6/25TVJEZpsPR
	viUWuHzKUEHxxKqZVKUN8tQtvkd/fPQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UUSLFXPi;
	spf=pass (imf01.hostedemail.com: domain of 3rBlHagUKCFUCExxA3BB381.zB985AHK-997Ixz7.BE3@flex--praan.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3rBlHagUKCFUCExxA3BB381.zB985AHK-997Ixz7.BE3@flex--praan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-847ad67cc51so81459b3a.3
        for <linux-mm@kvack.org>; Thu, 02 Jul 2026 19:08:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783044525; x=1783649325; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R42hNae76A7CXiYkYtHihW2CvpPOkdd31plc72X+MXE=;
        b=UUSLFXPisd9ZuU4iPq6g+5ZbQ2jxFBH11TMBH4VCqHKYz+RsXHHRFYCQUPPUxd5nY2
         S/8iHUP+ptPrqYiZcHBPxvwPoy4oQU46Zq6sCXAj9fvhB3x6S4OTzESNN5wm2Vep3eGM
         z0QJvUtXlub6OHs0X1EfWvMp1eGvXfZJ3Wg1sXKPWND722oEz1DKa6g7BDBNqjvUPr8P
         iH24+SNxkuG3PGC4fHono6EWDP5GgqH5nlwba36ZgQefOSjeONIWxp7be4xOgMu7ZbcX
         DC174Zum67UzPNhsgO+i/oz6hz4b8QfXaG/QbfWGOpxrRa9wmqOlaHDu2NILJp5vu/mL
         mWuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783044525; x=1783649325;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R42hNae76A7CXiYkYtHihW2CvpPOkdd31plc72X+MXE=;
        b=dvSu3toOC+Eqiuk3xg4PKHuJYBbMUugQhB32A3LzTtRZ7kFdlonpLOSIZOzQaf06iW
         Hn9uZI+wQnAoHoHGnGbLpwPzJXFAHhv7ghhF81Oy+OK8UycgAGEHNDyq8JwqJzuim3ZG
         VOmeQc3xFiUNJIhmXNN2k+RyGhS2o5Xu66RLc8tI2VFOCCQT06PGR7kyMqExFrhO2SOk
         urmKra5m4NmegSRRTBGbTG+q50008CMVziAFvFOoy8j/4Va3O96MBvn39gRBabJCMSyP
         QVGFesJ7ltYOJEIJVKazqus1Z0jhE5XMQ6+eTG6B/ZUJQDLbfF3MWPq+haqy6rwcKZPI
         T7IQ==
X-Forwarded-Encrypted: i=1; AFNElJ+aa8tTQ0P+Xy/eK5foopCA62e4ZLgtgcIqjKGdCaLa9Rimek9gVqOfN2KtDYiHtf4WkNRzb2POvw==@kvack.org
X-Gm-Message-State: AOJu0YyNApWADSzuquWJJd1j3MHy7BynWtgpawGrl38GTcmdNTeEXwFH
	dMaPrSSTaa7mFfdY5ITY2e8eCtRRGhWpS4crbBX3A1txUEOMxFUVoELDR2V9uZ5y81s81cZ1lhv
	Whg==
X-Received: from pfcg5.prod.google.com ([2002:a05:6a00:23c5:b0:847:92f6:92e1])
 (user=praan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:2918:b0:845:c373:6525
 with SMTP id d2e1a72fcca58-847c09344f7mr8276323b3a.41.1783044524457; Thu, 02
 Jul 2026 19:08:44 -0700 (PDT)
Date: Fri,  3 Jul 2026 02:08:32 +0000
In-Reply-To: <20260703020832.1731864-1-praan@google.com>
Mime-Version: 1.0
References: <20260703020832.1731864-1-praan@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260703020832.1731864-5-praan@google.com>
Subject: [RFC PATCH 4/4] kho: Introduce kho_split_preserved_pages() helper
From: Pranjal Shrivastava <praan@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>, Samiullah Khawaja <skhawaja@google.com>, 
	David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Pranjal Shrivastava <praan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D3D0140004
X-Rspam-User: 
X-Stat-Signature: srj18kr3qgx6oourfmbbn6k59a54fy84
X-HE-Tag: 1783044525-135758
X-HE-Meta: U2FsdGVkX18sWUKYT6UrZdbwvm7bLXCCX1ja7qyNEZrRYaALNJXVsYOeu+N7vKobp7IRFvOTgVJNkMIUMMl4KK1tA429eJEEhYd8HHvIlw1n7bntF28h/xtNTvNVJJtsh0P7s5gMEiskFJgYtmfk8zNrGPglHJ5QtkXQ+G5Coamv/VqHgEcJcK49qT2xRBjjG6OSsYc0RnYU4upy37fv/cwvswXS9aKs1mGIAeLK7r1svXl9ILU0j1EOb3pn7T6zqaj8OggIa6k/FfN93NbdhfImw+0CELv5UuYHU1zJGFffPC+YQtO5PWh0kU+JAsO32mwx83viHkEIqwgro1mmkyr/O0TphY8vatyGfdQiRvkgUvPJ6VnLsZvAa3qdtez4U5OZR8I/1jliONBxMNfw7FetHdYBhaEcWPsSgzIjoulBmjLJl8Pqew+3N+hcL4FeLM7bu8W6rRjrR9TrZA/nCaMvzeJKOKOHVDpi3qryFUN9wb2+jCAog6fttUJB+3wImQOO0oDWG381mn0GU2Qk6mKrLANXcGvjbzlTo5yN1X8bU/mMU+B+MRMWU1Ul2MB5PQNq5SsFENqhtgUINGBxPljlZH7c2LvQFxW7pmH9efnhmqPM/wZipjlkvp64bCgYbxziMdh0Hru8xFS/OkSK6y+8j4dt9DnAKiafgW6qyUnusemvIFmjJ+rEMAHEIRoTeGLH+U9gixAuIOZANFAIPesUuMWMyHiZHWK9pdjKiFV1sr0wiD9QB3wA5jd8PrEdQhBoGw5G6/M5QkAskI1bkHzBuz+tRzO+MK+P9+Bpu9jWc+pKD+YSqWccqXOqW/GAgJ3CtoQ0DqNyLL69CholmiiPsifI6vYKAhdmPNK3CaDfHAuNUDkyqapz9KlatJvZpGq51OyzoMkWnMPkkBaHZL0TOUQlIx1URg7N6NjrKS5vcO79R9TptXtgSkhqUpTuRPws8kIt/wpqYtv6ro9
 FVCrYnIP
 ibU21MsGoIISvlZObHgZm6wZhvhoHU9LkEWO1LNlvc+dzlnsW0GUS6GSwBDagJ5YtOQQ/Z+uTbWmymGnoHJrM3cxejIvBsRrcFbNhTSXL+baYpJULl87G6hTiH8XEQqB++/207xuC3YhxOCyKPMPzNvuRcvJpfSOKU0+nZ4ZITBQvh1h/Pttao3chLNTY6Etngmjn1n8+TsvWIKx1rsiEBYUco/OyPdQ/00a4GMHiHt+irZX0GlW3+qUpC5Rq7Vcd06WBwhShAyOCXPlVVnHsYCbq2eVCrT/bcBY1+lR7Ua+fcVNcwosrDxKrhoulTWY2aG+G6YxwCKUyKmuapnpJ8Lao91t6Pxh3F7Yq+3K1VwEJanegLXnUMYwbVteqalZApXu1i4lnrQa+2wkEXbqS6eDYwQQYUNspb+AXyhEb8r5pRk0Cyc1HGf7poKRlcQZ6ty3ZYqh+6ytYl0MFGs/xn0nVbFbMXp/fGF9cSlFGCSx1W+t6IcDn3dlpj6CdLHNKLHlh8yJOKgpOdwt2HWEObrBXfCRTLzVoTKWl5nzcFstaLWC+kxvO8EV32XVbVAyHhHTwAw96Px0pfD0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A driver may need to split a high-order allocation that has already
been preserved. If the pages are split using split_page() manually,
the refcounts would change but KHO won't record the change in the
preserved page-type, resulting in a metadata mismatch during
restoration in the new kernel.

Introduce kho_split_preserved_pages() to handle splitting of preserved
pages. The helper follows an unpreserve -> split -> re-preserve sequence,
while ensuring that the KHO radix tree is updated with the correct
KHO_PAGE_SPLIT type bits.

The helper returns 0 on success, or a negative error code if the
re-preservation fails. Callers must ensure the provided order matches
the original allocation and that the operation is serialized against
other preservation API calls.

Signed-off-by: Pranjal Shrivastava <praan@google.com>
---
 include/linux/kexec_handover.h     |  7 +++++++
 kernel/liveupdate/kexec_handover.c | 23 +++++++++++++++++++++++
 2 files changed, 30 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..452e38bb2076 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -24,6 +24,7 @@ int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
 int kho_preserve_pages(struct page *page, unsigned long nr_pages);
 void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
+int kho_split_preserved_pages(struct page *page, unsigned int order);
 int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
 void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
 void *kho_alloc_preserve(size_t size);
@@ -65,6 +66,12 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
 
 static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
 
+static inline int kho_split_preserved_pages(struct page *page,
+					    unsigned int order)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline int kho_preserve_vmalloc(void *ptr,
 				       struct kho_vmalloc *preservation)
 {
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index f6ca5e24c740..ea08248901b5 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -1018,6 +1018,29 @@ void kho_unpreserve_pages(struct page *page, unsigned long nr_pages)
 }
 EXPORT_SYMBOL_GPL(kho_unpreserve_pages);
 
+/**
+ * kho_split_preserved_pages - split contiguous pages that are preserved
+ * @page: first page in the list.
+ * @order: the order of the original allocation.
+ *
+ * This function allows to split a high-order allocation that has been
+ * preserved across kexec. It unpreserves the pages, splits them using
+ * split_page() and then re-preserves them as individual pages.
+ *
+ * This function MUST only be called on pages that are currently preserved.
+ * The @order provided MUST match the order used during the initial
+ * preservation.
+ *
+ * Return: 0 on success, or a negative error code on failure.
+ */
+int kho_split_preserved_pages(struct page *page, unsigned int order)
+{
+	kho_unpreserve_pages(page, 1UL << order);
+	split_page(page, order);
+	return kho_preserve_pages(page, 1UL << order);
+}
+EXPORT_SYMBOL_GPL(kho_split_preserved_pages);
+
 /* vmalloc flags KHO supports */
 #define KHO_VMALLOC_SUPPORTED_FLAGS	(VM_ALLOC | VM_ALLOW_HUGE_VMAP)
 
-- 
2.55.0.rc0.799.gd6f94ed593-goog


