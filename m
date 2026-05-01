Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917A7CCFA13
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 17:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0628E6B008C; Fri,  1 May 2026 13:31:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 013786B0092; Fri,  1 May 2026 13:31:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6AAB6B0093; Fri,  1 May 2026 13:31:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D51CF6B008C
	for <linux-mm@kvack.org>; Fri,  1 May 2026 13:31:30 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91A9187E16
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:30 +0000 (UTC)
X-FDA: 84719542740.06.1BDEFB3
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf06.hostedemail.com (Postfix) with ESMTP id A16A5180002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 17:31:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iw5Pv2Lx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777656688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owhGFFGkj/MfzHZLNOkioxRyYPGExMvDZLhrjI6gPS0=;
	b=q1wOeyQ0ag1W7BiA8T7c5iK7MwDIb0t+zj6sgQ19hklN4/RLW2AP+MWa67z67zX57S4gT1
	jEhMGiClGuDqW5Jr/4I/UBVm3d1fXBkKlSyqQbRvy4OKrK75TKYw3CU/HwR0ScGllF696B
	3/c1b6KAUtfEcM9gx+DF7vKoaeG9Eus=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777656688; a=rsa-sha256;
	cv=none;
	b=on9WNqn4TwpZ9xRt9MjRrF7U6bEDIldFAEgRdWNsNhaoPasoaKk1lqWscni3i1ZeuhAE5o
	vAHkZ3U1+eVF8Y2bTkEF35hK6sJ5N8f58fpLHqjOrU8PHdfSv34XFMUnKA+Elz66/MFNDJ
	YLjrsBAVA19rFU43rohJamOOWM41CfM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Iw5Pv2Lx;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of crisjacobmaamor@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=crisjacobmaamor@gmail.com
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-362e30526f8so933447a91.3
        for <linux-mm@kvack.org>; Fri, 01 May 2026 10:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777656687; x=1778261487; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=owhGFFGkj/MfzHZLNOkioxRyYPGExMvDZLhrjI6gPS0=;
        b=Iw5Pv2LxyZgZQ1sJhX3oPUo8Kk2pqgV6mUQoGk7kdCT4/V8Zot0WME66DXficzCrue
         8z7B41z9j64Eqzy9VLn+t8vkrhzzqpt3Yg0CfTyfuZGa93EwZn2aR7fpQA01Lj8Jx1bR
         7DagtfQeHEgRVTFYZfY157ViPMMbNdGC3l1fZ1fnMijtBJuwkF6KmgP/jFhQI1HOFyRN
         QeLbP1umjoDZ+/NPhxB6WZkms/3vaa6HxTKb5HTiSZ3g7JakbwGU6CaSMDq4H/i8ZjuT
         VfSI+SedZAKeu1AReh4wD7bfAfh+7zdTYXsQ9dxkDZYglHPdDH4AaUbVXgZ+ua2X8bU/
         dAcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777656687; x=1778261487;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=owhGFFGkj/MfzHZLNOkioxRyYPGExMvDZLhrjI6gPS0=;
        b=dBw3wxVK3xiL2NmBb1PGN1WklDRcOtigDE/NO92xpi/uTykVBEvMf8cFV4T82Nb0CP
         Qsqo4N5GxCsZRBzbXO5AQaR97upbTLcZImv/OhTzx0p8FMNCpi7ASp/ks3zTAnQXDojb
         eGEyI1UtyFVYMVR9NyMZjMNRih8iYhM3w6AqKxG7KWDYbhQDAAcX0pq8+3uK1oA6Q0pq
         lh61qcbWQgMeYw5BlWnymnyuT8DMIQEB5uhFr06E2EJJASVQN3/Q5PJxrqsG0COCL89k
         fzCCMxOfKj0dzTg7y3j1V9YKV8WEmRu9x+cTYmjf5nXA3hxTcq/3EQUmJxq3tnixoToS
         JO7Q==
X-Forwarded-Encrypted: i=1; AFNElJ82KpCq2oPPSxs2CBg5KAY9P9ktcO2ybZ1JtfQo4euabokh1psG5t0uetTm0lp5EA8/TcoU4o31XA==@kvack.org
X-Gm-Message-State: AOJu0YzN8gVuGGCLM7HtH9whyyJZqlxVqzjq4aRwA3efIpV/OBlMYhHc
	Jpajn8nU19U77xjNFg+6RbBLRVjK/DK8kseuCB4l2uGRqGbTJuAetXaoywerWsfPriE=
X-Gm-Gg: AeBDietMRum1D7W2mLRdPPa5jm0yCyUDH+7oOwLdKLOfroEsRHLU8NK+BeJPpHrEu+z
	xkcs4VtmYuBmznIef3P8KlRpwpONbhs60yVsJwvHmKRbVmwg98P8qK800370T6Vs8DZVrEm6VP3
	Nm5T6YzVlwAmoUqIoTcSTrBHznRRLQNDl7QGdBeZoVVQKG/2sJQPttGDr9QFMOENsC2dYzGuv83
	Uh46ZxYZfXha1pXV5TmO2vAVu3fFXSEaDw6f2T89kJ8dhxUzgMfyz3JKyKZxvILoY/mO+ZJsQvs
	2pfVg4KBLhqykeovTuxPVxV3x5C9AmQ7NSZaVx3tFoHb5YpeV8zPrwY0is6Hf9PMDAbeH/0grDq
	GHcCThOlFuCQMCxcZ880XOGKRvwg2fy+0xZo3xvqeQ7049pzJPEZYqjwJSCGN4zISd2qOdowgkd
	E0gqQofaxdZVSMh/fCgeKf3SuEK/hi3tUXO6PH2A==
X-Received: by 2002:a17:903:2f46:b0:2b4:59bf:5728 with SMTP id d9443c01a7336-2b9f260d8acmr1445365ad.25.1777656687121;
        Fri, 01 May 2026 10:31:27 -0700 (PDT)
Received: from laptop ([2001:4455:8025:be00:15cc:43cd:8af9:5a8e])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caad2459sm27094895ad.33.2026.05.01.10.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2026 10:31:26 -0700 (PDT)
From: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	kexec@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 1/5] kexec: handover: add helper to check preserved page ranges
Date: Sat,  2 May 2026 01:30:49 +0800
Message-ID: <20260501173053.73116-2-crisjacobmaamor@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501173053.73116-1-crisjacobmaamor@gmail.com>
References: <20260501094637.38650-1-crisjacobmaamor@gmail.com>
 <20260501173053.73116-1-crisjacobmaamor@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A16A5180002
X-Stat-Signature: y8b79jzpu5j8nak9kch553ijrd5i15z8
X-Rspam-User: 
X-HE-Tag: 1777656688-928374
X-HE-Meta: U2FsdGVkX18jtl4jA/ackoJjsWEfhppNhhO+SDlYn6q7pYS2wQIcKctM6671BPLe0MW44md8/ui6p0g4V7Y/VjtDnkPr2Nz4f5CtIljnFxzWqv5GBAmo6JxdG7H+ct61jKnyqjZewpsvlcAg4mpqDUgdiROTnDxtNgOVflXdH1GjHCM6h6iZ5sgjtl23w9DH9ciE24/7uxWKEGzxnt3EyVASVj0ZH/bYxLCW+8lVbztclih3SzKdZA9sCmOKL4ZixQS9VsbsgnnCp9s8cTuhh2a6PNTDg06MAbNsv1ylpAnawH3UK+6znxXbsKoVMOYdpEjyVCQuFgBxnrwK4OuZ0LtfFryQV2gymkkIXS7vQQM6TGtzcpowvSN9y2j/1RObXXkclA3AzBCTZ9fvDJMhKHMd7zd2Age8+oHmEdm3CEaNup1HB8ImpjgXXamfQh/BfxObY1nt3oSnxoVDm4M1iKi49bFHegayDeqTFlrLK5+IGgNvCrXutLD9/SDjWmjVM39Y0EAAm2Msk0BayzrIucrNT2+DnfDmfFI4idJGo/0TwTTkR/pAbTsgvC8PacXS33dOSKByo3e2POUDV/6jSQweedTMgbRzAnbkJmtuX/SMiVZNJYBYdvcLTqJnJxj26bAJWU+2S402I2C+vg1C+qVC9m92VFlANzeqehTLy+10AoLgUnB+iVu/F67F4T5WuxZmsF5B+tXA6DZ2cvpquF0RmlumX/AIpssQseBuubtV1s1aDkder8WyHfekmNjcbmQeY3wQWHOrwVkjAN1wc5XKoFOlxMXHqc22Geh99u6AIrGw+ni+ybr3yyZTsacdYgx/w6eU6KTlC8AC6PbhpU/+qlWqeVf0KVQ20LZgbXoQgS73CHs1Fg00Tpr6dBctJxvEGb/ZcreLZ1hrS+2kb7ntvZlEEE1w42IB4a1b5+/TDZQmpOF8/QqM8bOxT9TJaLKen93oDVakheTqsao
 1huztEFP
 /EU3m/UZKx/PuFzit0QQuDEFFTfs5RWIWnabVS8XQlVXpldtr+u0yiv4hxlsNtqj6Ju82YWSRGw1yVJAKQJqnqnEHf8wIzml1+urIaSkIIQ4Ci9nSjm6HIz+P7im/MlxynWCP0PIKRHmu2aef+uxPPi5GmikJccxLZUxX2fZaFL8QHUMpYyCk7ylmjTGTvnck6e6zUe4G/V+M8/m3UOZ4em8hQnAEkjjR38OAtIw//LBIG9srtNr/BhUHpzWyot8j9Bz9YUGyIuZs7ClpJrDQ+zlHb+4sQ88r1QD8gcfspRj6BZ7H1fiYvi0c9T04o1rJvkHWdgVXE4HQ9OKdtRKhwRneAOk0LOM8Gmi2NJlVrbcnW6kZm9KFs96tgb4Lqa+dQhGNbOedZBObvChaLh5g0mt0ydJnY8TWe19AuxZR/WCzpTX1he14Y66JhkPs3qc42ObCWBDDdCtOIarNzqlp4hck1JgJnLWRJmQxrnbGqDZwinrSjyAxPFkqO4pcnbxTSHwP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Restore code should not use phys_to_virt() on physical addresses from
restored metadata until it verifies that the range was preserved by KHO.

Add kho_is_preserved() so callers can check a preserved page range without
restoring, freeing, or taking ownership of the pages.

Signed-off-by: Cris Jacob Maamor <crisjacobmaamor@gmail.com>
---
 include/linux/kexec_handover.h     |  6 +++++
 kernel/liveupdate/kexec_handover.c | 35 ++++++++++++++++++++++++++++++
 2 files changed, 41 insertions(+)

diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
index 8968c56d2d73..fb09943ab232 100644
--- a/include/linux/kexec_handover.h
+++ b/include/linux/kexec_handover.h
@@ -19,6 +19,7 @@ struct page;
 #ifdef CONFIG_KEXEC_HANDOVER
 bool kho_is_enabled(void);
 bool is_kho_boot(void);
+bool kho_is_preserved(phys_addr_t phys, unsigned long nr_pages);
 
 int kho_preserve_folio(struct folio *folio);
 void kho_unpreserve_folio(struct folio *folio);
@@ -51,6 +52,11 @@ static inline bool is_kho_boot(void)
 	return false;
 }
 
+static inline bool kho_is_preserved(phys_addr_t phys, unsigned long nr_pages)
+{
+	return false;
+}
+
 static inline int kho_preserve_folio(struct folio *folio)
 {
 	return -EOPNOTSUPP;
diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 94762de1fe5f..fe9f11190705 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -10,6 +10,7 @@
 
 #define pr_fmt(fmt) "KHO: " fmt
 
+#include <linux/bits.h>
 #include <linux/cleanup.h>
 #include <linux/cma.h>
 #include <linux/kmemleak.h>
@@ -429,6 +430,40 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
 	return page;
 }
 
+/**
+ * kho_is_preserved - Verify that a physical page range belongs to KHO.
+ * @phys: physical address of the first page in the range.
+ * @nr_pages: number of pages that the caller expects to access.
+ *
+ * Use this before phys_to_virt() when a physical address comes from restored
+ * metadata. It checks that @phys starts a KHO-preserved allocation large
+ * enough to cover @nr_pages.
+ *
+ * This only checks the KHO marker. It does not restore, free, or take
+ * ownership of the pages.
+ *
+ * Return: true if @phys starts a preserved KHO allocation large enough to cover
+ * @nr_pages, false otherwise.
+ */
+bool kho_is_preserved(phys_addr_t phys, unsigned long nr_pages)
+{
+	struct page *page;
+	union kho_page_info info;
+
+	if (!nr_pages || !IS_ALIGNED(phys, PAGE_SIZE))
+		return false;
+
+	page = pfn_to_online_page(PHYS_PFN(phys));
+	if (!page)
+		return false;
+
+	info.page_private = page->private;
+	if (info.magic != KHO_PAGE_MAGIC || info.order >= BITS_PER_LONG)
+		return false;
+
+	return nr_pages <= BIT(info.order);
+}
+
 /**
  * kho_restore_folio - recreates the folio from the preserved memory.
  * @phys: physical address of the folio.
-- 
2.53.0


