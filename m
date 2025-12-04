Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C6BED206A7
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 14:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 362CF6B0095; Thu,  4 Dec 2025 09:13:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29E736B0098; Thu,  4 Dec 2025 09:13:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02E2F6B0095; Thu,  4 Dec 2025 09:13:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E6CD06B0095
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 09:13:09 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5621186F85
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:07 +0000 (UTC)
X-FDA: 84181980414.10.640927A
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id 63A3A140012
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 14:13:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AWHbKWJk;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764857585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vvLRPmFVeFXL/FXUoH0yHVRGEwWvQKNGaG9SkVtG73M=;
	b=i1EOfOYNootoiV7rwWMHswEPYu54/6axhetc4dq1E9N9lE24r8e4d8u1GrtICgplyv5BPu
	VMyJ/Vg0RYZTZCxFGXhy8ehRkUaO449y1BA46yAj1UA9BsRBPVizBiJz7Ax0WZlDX9I//e
	twlIDUU1Xtx88l8qbuNrsE6JnwLdOTA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764857585; a=rsa-sha256;
	cv=none;
	b=JBLNk33j5haon+6QmaqulaCIf4jHsmNWXPlLn9pdoimAvpYhBLfLji0oZMgjhjpbGU4Q1Z
	N554q8C28FJNJinfSrzs8pIX05LnhZlJ48+NdSLylzudem0WpZb1MwHVnLLSd2BRvc/g7O
	tkZlV2zlyhzfdAPcYaFMCxArmka6U58=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=AWHbKWJk;
	spf=pass (imf23.hostedemail.com: domain of ethan.w.s.graham@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=ethan.w.s.graham@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47118259fd8so9850085e9.3
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 06:13:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764857584; x=1765462384; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vvLRPmFVeFXL/FXUoH0yHVRGEwWvQKNGaG9SkVtG73M=;
        b=AWHbKWJkeFFCs9lIaYIUMClooiyP3Sa/k0FA2vr+SgW7lC/zyk+DqqFnxipF54/+5X
         57ssaztKM+jpb/glsmdbmjLmrzwjEYPkyqnVz4J87j7Z1ObOGE8LAZbuAVaj7OF9/eDR
         woXe9bddQjjkyvCsJaYiCxKpGfNmzk8ZVWWHz9/1H/jhCi6LhN92sX7stoVwcDC4SvvQ
         V5ydDj6oPIDBYurTRPpPpzI3s9G9mJEtCKnlxohZiE8XrpXQuxRzhnPY4q+6phMZ0c6X
         84K607y5MOhSRyyq+g+nzAFwcdNO8Fpi3XLXZlE2I441Vi3rItKBiYBEzEJwsaybsupS
         hHgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764857584; x=1765462384;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vvLRPmFVeFXL/FXUoH0yHVRGEwWvQKNGaG9SkVtG73M=;
        b=lQddaDCWveEBrsC568Oyx5CtVoitW1u3faA0KuOyXQo2iPBwVlodrL/8qjwGJagE7F
         NYAgNdKjcS/Lg93l5H6Qh+jFtE4S2WGArPgAlf+3lvTzoq1ruN9jYdaFtkFnaXV45sAO
         45AgIXZucPEXnvbz9Gyqi2DKL3Kk+RplDg7hRe93cmdWbf1shGSX3RQJE2q5JdoX23ol
         +VndPk+PGIhMQLVP5AyJ7TVcuEshTuEbB8nbk4BA1J9T/dbhk4Y6at+Ar8Nt7uIeV14j
         ZXmrZEIqKfNmj7VGj+wwd5isv3hpMIgJm9/ZuauZaxPXfqWgACTOFWq0mNOklBosra7A
         qeXA==
X-Forwarded-Encrypted: i=1; AJvYcCXv/Up6OHs2LEOfEYVEDhpwqoHC+7ErgecZQt9K3rzXplZ0mMqPuDNhAD6yE8bLMcbdiyZI/OQJJw==@kvack.org
X-Gm-Message-State: AOJu0YwxzZ5ikDpBqR11geK32bVeLwTpVSbshG8XRbKNU2kXrgf3UhxA
	7Jr/r4dwz+Ba6gZjLNwUot/X8BgyB+1XTSkTIO2lqcSg5hN/UYoumFrV
X-Gm-Gg: ASbGnctshZ/jhoR8LTtNod3o49pzumTI/QCjX48lYw7qWdl01t0zhDBzrsxv0HaxhHA
	zY8pjdm7W89wlFU5yA/wteD/7+nSI5KHH4Zwn5z9WKSDEHAui0X+U0u8rbJsC52nK+JAYXpZ07O
	9DOrCiOAcHt0fgSq+xNTjX4nvS1aXD04BWorUhMGHA9aMMhJYXfAu0R8/jINC/cxJr1qGBivh2q
	YqI9rsljjNtHjLgdcgPi8rCDtuEmoY40bvKxASEQ9B+oh2AXHOqCppYkYQ7FO6EcagJzIWb//iD
	OhSk1Ticta2O4IGyL7i3/er8u12KBORcVuR0tLyjVvlzzFuf93AVwBosLI8hT6uu6P44W3gNp6v
	zLAnRpRe0nzJaxqRFVtSFSJijBkfGpooy5aizT8sgQTt6GvxsWQTSwMvrUF+RRdH4IjPPl+EzQG
	n3et9HG/uslDZdMJQBQk7RQ221mZw2OIRoj8twNLz1kM98CEVlmJI70H26rkhMM7ZdRw==
X-Google-Smtp-Source: AGHT+IHVRlhcJRejGEsgP4K4cLss0ObE1mVBCmN6UHr1S399d5qS3NN/eNqDmcGxbLusiL5cPl9foQ==
X-Received: by 2002:a05:600c:3545:b0:46e:74cc:42b8 with SMTP id 5b1f17b1804b1-4792f3860e4mr28572475e9.17.1764857583596;
        Thu, 04 Dec 2025 06:13:03 -0800 (PST)
Received: from ethan-tp.d.ethz.ch (2001-67c-10ec-5744-8000--626.net6.ethz.ch. [2001:67c:10ec:5744:8000::626])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfeae9sm3605808f8f.13.2025.12.04.06.13.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 06:13:03 -0800 (PST)
From: Ethan Graham <ethan.w.s.graham@gmail.com>
To: ethan.w.s.graham@gmail.com,
	glider@google.com
Cc: andreyknvl@gmail.com,
	andy@kernel.org,
	andy.shevchenko@gmail.com,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	sj@kernel.org,
	tarasmadan@google.com,
	Ethan Graham <ethangraham@google.com>
Subject: [PATCH 01/10] mm/kasan: implement kasan_poison_range
Date: Thu,  4 Dec 2025 15:12:40 +0100
Message-ID: <20251204141250.21114-2-ethan.w.s.graham@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
References: <20251204141250.21114-1-ethan.w.s.graham@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 63A3A140012
X-Stat-Signature: 7urfwg557o4wopmnyjtp6cre7h16u34n
X-Rspam-User: 
X-HE-Tag: 1764857585-956643
X-HE-Meta: U2FsdGVkX1/6fDbxWLQ6VfNELWwe3nBOG/Q2UZjCWFU63u842990WDtjKwVZSu79PHPtJKIEF/eG9SNdfjh07Q8RxgUMdBkMbiN3RCJanIe2/ntG0tUW4fkEtv5KHqJyR26u53TKEPieaJpNLQk1jOgK4i64oW+dp/WNU+ISMbstqMCk6zDlZQL2AKIz1UhPv03zsGGGzzgbAKQceOFgkO/Rf/bBW3zOT3cKQzpkqIX5qpTFL+yRK5mQjqwFCD+vCYxIltX9FBMfrIXy/Ct32v86bwdJQG2azhLVCCu6Uir90695gF1PZ6aOEiKOVxy5DVOM8ukOn4R8gJboBxnwVte7DUFRUwrutUfq5fmr6KpycClDgNR0KK34M8jJvBi47uRoAkIrUeymHitDgXDuiyHdNI/BR0RCH0DCAyCF8x7ZXlRmoSCiPNTwnSQTktQQFG2A+KzlGUFF5BpvKA/R+l8G5UWuHbE+3twSzE2noMpB5l1xL1rmmtDjA8XW/p+AdBGdodEF60TdddzeLOqB2LQQMiDGUWrevhJDZTjOkKKMtmOrNHDpBMiiOxjVevPHDZVw3B7Z6ejMazcu7LUGKtNEd+x/1djz5Xg308xzVioFowbn0IqF6p1vcueU0G9Ntk5X7rU+wu5Rcxjhig/wrB/ekEgxRvl5fy4VKpMlVSzhSi6LAXXZnh+pWrGhncqCNXVXUXyqKhRdU2ue3euUAY+Mz0s7Yb+r0xAive2PSbOTAA2DmFuTBcHmUwfkoBo1M6/8BK2MihU/CSIFx7vP3q+rmQ+thHx9Wa8iNLbNdpn9xaXKB1QhRviM1hToBL4Wr/nMZq9GwSeOc9mKWrrxKnuPN+QVipVqohD9mUBU4tfLSEqa+AmB8QLpZPG3Qe51xJf11+Nj9aRNgwsrwuYKx5QlvUGHDnElPuGUMTJdttPj9MhXbelCl1sCoTxcmI/p+JAWQT1AuqxMeCFG8jv
 8PXC6WyO
 vR5qjo9eaMvry6rrd5wFqTLF11iwEMINqanCuLAJKckKe6ZLf/Vupo8v7+PN8hfdkqC/TH3zWG/C70BCMmZN4M4Pv1VCIchFVTaS44e9x5e91HKVtOI5uDiFTGgxc3KpdMxz8jJ8KMZ1POXBv5rsi0BJdbb1lk9mFpkWIeYNj/NrAE4krAyEpMs3HAQYRgCnyFAZ4NoWUNCiJTctWFkdkMhRIaauOYno7sxQumKVsBZBikgbK6nahPqtUCTFiu6Lo247MosDUj+d8rEJCkjYnOlI2/qPU6dcl9+MkdUuZ9KPwJzxX/282etqWsVf4MG4lnD3TUBA0by6ddmeumnAYGRtr1iq0C1P+ql/Q4bdw4rfic7fUQ0o7RUf8RXXAfTpPWsXiBkkL90I2bx4fwCeuAJdvgSOMP8+JYu9KLiDTqto9/xfkB2T/4weP1TozERZvaEDTEyGC7Q/5+Su6Xmb6h7ErADauZL5dcrLTS9/9Mg2uQFeNYWYFU4o6OJKjIujLmun9X+/Qzut/VbVaUWi6IZ1x3jxFTAjwJhca2er8usPMQFlcZfNNyaCBk95kWeXXjO1WNtdScotVvJLqt9uqmvpKS/rXUV8ZY0JT768S/2bEfA71BViJ92IWYqohgQOj2Cj0rci0J3gl3nXdCdOr8d7lRt8MYYGEifXHKfbiTBlrblmZev9n1iSec/K0tqhdiAnDRxU5gMg/rojTvBZYz5Zk0g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ethan Graham <ethangraham@google.com>

Introduce a new helper function, kasan_poison_range(), to encapsulate
the logic for poisoning an arbitrary memory range of a given size, and
expose it publically in <include/linux/kasan.h>.

This is a preparatory change for the upcoming KFuzzTest patches, which
requires the ability to poison the inter-region padding in its input
buffers.

No functional change to any other subsystem is intended by this commit.

Signed-off-by: Ethan Graham <ethangraham@google.com>
Signed-off-by: Ethan Graham <ethan.w.s.graham@gmail.com>
Reviewed-by: Alexander Potapenko <glider@google.com>

---
PR v3:
- Move kasan_poison_range into mm/kasan/common.c so that it is built
  with HW_TAGS mode enabled.
- Add a runtime check for kasan_enabled() in kasan_poison_range.
- Add two WARN_ON()s in kasan_poison_range when the input is invalid.
PR v1:
- Enforce KASAN_GRANULE_SIZE alignment for the end of the range in
  kasan_poison_range(), and return -EINVAL when this isn't respected.
---
---
 include/linux/kasan.h | 11 +++++++++++
 mm/kasan/common.c     | 37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/include/linux/kasan.h b/include/linux/kasan.h
index 890011071f2b..cd6cdf732378 100644
--- a/include/linux/kasan.h
+++ b/include/linux/kasan.h
@@ -102,6 +102,16 @@ static inline bool kasan_has_integrated_init(void)
 }
 
 #ifdef CONFIG_KASAN
+
+/**
+ * kasan_poison_range - poison the memory range [@addr, @addr + @size)
+ *
+ * The exact behavior is subject to alignment with KASAN_GRANULE_SIZE, defined
+ * in <mm/kasan/kasan.h>: if @start is unaligned, the initial partial granule
+ * at the beginning of the range is only poisoned if CONFIG_KASAN_GENERIC=y.
+ */
+int kasan_poison_range(const void *addr, size_t size);
+
 void __kasan_unpoison_range(const void *addr, size_t size);
 static __always_inline void kasan_unpoison_range(const void *addr, size_t size)
 {
@@ -402,6 +412,7 @@ static __always_inline bool kasan_check_byte(const void *addr)
 
 #else /* CONFIG_KASAN */
 
+static inline int kasan_poison_range(const void *start, size_t size) { return 0; }
 static inline void kasan_unpoison_range(const void *address, size_t size) {}
 static inline void kasan_poison_pages(struct page *page, unsigned int order,
 				      bool init) {}
diff --git a/mm/kasan/common.c b/mm/kasan/common.c
index 9142964ab9c9..c83579ef37c6 100644
--- a/mm/kasan/common.c
+++ b/mm/kasan/common.c
@@ -570,3 +570,40 @@ bool __kasan_check_byte(const void *address, unsigned long ip)
 	}
 	return true;
 }
+
+int kasan_poison_range(const void *addr, size_t size)
+{
+	uintptr_t start_addr = (uintptr_t)addr;
+	uintptr_t head_granule_start;
+	uintptr_t poison_body_start;
+	uintptr_t poison_body_end;
+	size_t head_prefix_size;
+	uintptr_t end_addr;
+
+	if (!kasan_enabled())
+		return 0;
+
+	end_addr = start_addr + size;
+	if (WARN_ON(end_addr % KASAN_GRANULE_SIZE))
+		return -EINVAL;
+
+	if (WARN_ON(start_addr >= end_addr))
+		return -EINVAL;
+
+	head_granule_start = ALIGN_DOWN(start_addr, KASAN_GRANULE_SIZE);
+	head_prefix_size = start_addr - head_granule_start;
+
+	if (IS_ENABLED(CONFIG_KASAN_GENERIC) && head_prefix_size > 0)
+		kasan_poison_last_granule((void *)head_granule_start,
+					  head_prefix_size);
+
+	poison_body_start = ALIGN(start_addr, KASAN_GRANULE_SIZE);
+	poison_body_end = end_addr;
+
+	if (poison_body_start < poison_body_end)
+		kasan_poison((void *)poison_body_start,
+			     poison_body_end - poison_body_start,
+			     KASAN_SLAB_REDZONE, false);
+	return 0;
+}
+EXPORT_SYMBOL(kasan_poison_range);
-- 
2.51.0


