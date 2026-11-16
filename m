Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3ED2606A333
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=IgqWzP7x
Received: by kanga.kvack.org (Postfix)
	id B57646B05BB; Mon, 16 Nov 2026 18:07:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF236B05BD; Mon, 16 Nov 2026 18:07:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959066B05BE; Mon, 16 Nov 2026 18:07:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6822B6B05BB
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:07:04 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F389D40271
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:07:03 +0000 (UTC)
X-FDA: 85442519526.01.785A36F
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2A159140006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:07:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IgqWzP7x;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf09.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7noARN/sft+NtmJTHmUDUAvU1Dihrn7FLenu365oKlA=;
	b=jc8ByM70AsKnjBHLFUXLTH17/L6sjWyTlz2p+0RQ1I8C28xywkt9lx1I04quOiJCsb8e/B
	bebpZxEPSpSR202Yph3tRremCo9pbiY5jzkxPYFwxXOUW5YFcDoD1B1i5Cm0OOO3C0GdX7
	BLLWOKix2tHYyDRFHY6DMn8C8vxZ9tQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870422;
	b=4JweeUY21BMuZUVv1VcVwutLdCT86l8QqwihJGHH9nY8yopE3pMgbNmb0+viXSwZ13/Ipj
	eieUBsBShUf2fIRQQx6O0+MFg+Z6Tr03J7wZBmEGzVJ3Mz90zowkihoPxDSXIh4l1jGkaR
	DV7Umc2uCcO5uCxDtOZg9FlZvKn3NUw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=IgqWzP7x;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf09.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.52 as permitted sender) smtp.mailfrom=jeffxu@chromium.org
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3b0d0f38abdso725661a91.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870421; x=1795475221; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=7noARN/sft+NtmJTHmUDUAvU1Dihrn7FLenu365oKlA=;
        b=IgqWzP7xaXA8e/qxevVlycknGfucZcgS4SmidPLt8jsMAjn4yTBoQUTKdrbZYygViO
         4hM6+JEhMm1gGYH1Vj/xUFnHpFFYrcx3ZQINWmkGfMm7gzrcgRJ9yiqqu/PWp+zaPxRI
         TydI+W41SMRnMlZnGNTPLNdog1KtVHtWAnkw8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870421; x=1795475221;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=7noARN/sft+NtmJTHmUDUAvU1Dihrn7FLenu365oKlA=;
        b=O86VwBeWC3W3nrViyjo8AHryx18XXIV8qoT1LwoBSwrGkGspgHzWc44qpgBlFmwsf2
         aMfncSZB1WjLkUsGecW2UzAIbxE+AaHFTQnGzHVEuIwsezOBTN2k/nI9GH2XSI+2HjM5
         7T92WbjqoqzOH3o0Qoc1w4IqIlUh1MkhVqq9v2aE7ZJHdUwCWCOmpm1i+/7z4D2L2rbd
         9NN3B2QDKAr/LtC3Iik76q3UDO2BipZcFVcSb4/bZnEfMiXbkLzJU5y68+U9O03dbS1q
         Jc8Ad7wSOWqYkzTGX5zkTYm8QE/wt2Esyga5zb0BGbItkyqqCn+AudJWIQR7xeZ2+2uF
         kwoQ==
X-Forwarded-Encrypted: i=1; AL+hErEwCpsTkoI63qtMyPaNtOxSfGqSBrlg++4pnc08LeL0pou+UdPTFqSig63SR2eoE3t68X+NTpHlCQ==@kvack.org
X-Gm-Message-State: APuU4Z9d71DYnUCfDSUXY3caVRrNCTkBY8u0+vKt5EDhbrtVuTNB2UIX
	UR6AhV5Xz8iM5BjCi01+/rIN5HujvXLxrW65B652iC9kYr5TA9vWkf/9eKEFCrUAsg==
X-Gm-Gg: AZFdTZeHnj9qA+8Brt2EXgZipmpqPp2Ek5/3OFKun2kkdBr6DuKcKgUSPoMlTiWCyg0
	2EbzvpYk5ce1XgI0t+OqIIwKtOhc170VMt/dRBDvfWpaB0w2ieqpg8NeIwmXAO25+5xOzCimd2s
	wF44+CuQMXIvssihBTeViwGtk8VCNnWOqNfbPpa/vaonI4RrLfmxu4Ebvo21BkYBzzE4RehmF6v
	vwUeYwc7AIkLTK4PMRaoDl4FRmD5voTZmOqpeuH7DJjfNU6zHk6QvXK6YXpY67TsmJEfiBSR4iC
	vydhULvO4ajd7ilYA6FfO4CdS89CBw1mbqaEiWnMZmVVR/fCK7iXflG6r2tdlmvClj1NsbHd3Lq
	KmirWG132lVS3hOXupP4HghKoAIrngLP++riPqTH0WvPR1QZQSTONdJISWyzE8ej1+Jko09M6T3
	xFasX2tGGlQv70wvGgGlDMwtYzrqG4CzKJ/D3/i52W1a2unMfbKtVMwUrvr4NCLZ5O0fhGJWX9n
	9QenKBplknMRsusESDTXWcqqm5V+mj2CoRlbEhpOokpARFrcXASZqzLHlOwtgwQnwLqZWyjiOTS
	toKS/oUXYBhkwO0C55M3nLXEkMuMpTR9B0ooo8kvhg1/FoRTLjlbYldwur1npN4Ap67ipIc=
X-Received: by 2002:a17:90a:c88f:b0:3b0:9a3e:bf8b with SMTP id 98e67ed59e1d1-3b1b0b5d63amr16850510a91.6.1794870420893;
        Mon, 16 Nov 2026 15:07:00 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-cddc1873531sm4674755a12.10.2026.11.16.15.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:07:00 -0800 (PST)
From: Jeff Xu <jeffxu@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Jeff Xu <jeffxu@chromium.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Marco Elver <elver@google.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chia-I Wu <olvaffe@gmail.com>,
	Dev Jain <dev.jain@arm.com>,
	Evgenii Stepanov <eugenis@google.com>,
	Ian Rickards <ian.rickards@arm.com>,
	Jann Horn <jannh@google.com>,
	Jeff Vander Stoep <jeffv@google.com>,
	Jeff Xu <jeffxu@google.com>,
	Kees Cook <kees@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Peter Collingbourne <peter@pcc.me.uk>,
	=?UTF-8?q?Pierre-Cl=C3=A9ment=20Tosi?= <ptosi@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Tomasz Figa <tfiga@chromium.org>,
	Will Deacon <will@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Baoquan He <baoquan.he@linux.dev>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Allison Henderson <achender@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	linux-mm@kvack.org,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kexec@lists.infradead.org,
	netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	rds-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH v1 6/7] mm/kasan/kunit: add page_alloc_skip_kasan test
Date: Mon, 16 Nov 2026 15:06:26 -0800
Message-ID: <20261116230627.3537051-7-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 2A159140006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Stat-Signature: 6agrb9g5equkwz3dpz4qbaw65e8d8k8p
X-Rspam-User: 
X-HE-Tag: 1794870421-871920
X-HE-Meta: U2FsdGVkX1873fyHwBtcj66mDSSYOFr8gpCKHuQRRPjxjHySjDZDbfPeUEvMCKHNgp5XfEf5pBgrVJq1yaGn37hcpP4wbmB32WV2Wpm2uI8SV/FxNYdFcJ8XdSQalY92AuFRLQ2wPFB49vvFHXuUawHlVeiLRYefOXrlmlWcoCjNyGk48v0j2+oM4BWRz67aG9/umMmRbgkLsNyWwZ5GtEqM813/OnSzeeHw6Ke2aNKZU6vmXE8zhPfZPm7ArMZc0ElU0WQUdtcn4yFbFD1mgciNuIs1tiu8FXOoy990BjAUvgkHFxzKDhjFBN6LUDlUvXsmxb+x8DmFhs14mk7D86Zik/dXNI1FJGhkLIM1U712pobMzeu9HrGnU1GeWBORwAkkAax15D9fLu9n1MpJ6kp1btLcF44Z6QUk6Mcl16JvZ618Vy6fcWJoG5jBHfbAqCmHtFgk4gb6f4KqT35rbDLEsQP2OH/JlwEq7Cod5uuCNLi3goP++CDOlIJ/1OqTf5pk4Al8DkcXYRngaLEvNwcFVeFIud2LUvPQgb4+3VyAacc2vg7HOpMSmKD/1ill4qV9mKU03v3GiSzFhunfHZ75gqd7WdrLcsTBk53OVi/jT2FTmDJIQl+er66EHCNqn3mD8+xRmhWVaZDp6ZSkNy6Gr+aXYtg+3fk84O4acdkzYuSRey/qLa4AYYwNbpc/YqvyJncWbpvdUB6BAUvWag+cFOvpXQTWl3DD3OoG/5r1PXQQp0rGC0Hfki6Ud1rhxC9KnPJy8gIC87d2UmtnHhd9VdL+0PhtdPUuhefvVu+3sAZeAXm/xhDabIxGLLlsKk947aP08TFskpT0mndgCEUkH203tY5JTuWIxBKCYJiiLwdQEjLFBVxDe/UD+TCgwlYX7eGwzsN6JrqimoxQKtxH9+9GC3NOsk60d8d1GKvqLKsWEHFJQNfmQxegzOOeF7NSnVSq/9OS2KVadSX
 sTeQqahq
 SHaGBq7+aCBYYzgsI6BDolUDEyvfMjqMUtABWUR+lZObvUiG/PlDReGwuD1M07nNMXEjm+7FR1/NrEKNoK7UGF1XdGIOFDrHhWWrDQaP8aZUYJL3PKBjuNn7rXVhWgKe3vch+i+fla7gTxn182CAxC3cZ0ABl4VWe383n8F6AgsC5VXNBA/rSjvc2OAi7tCPRIxlYDfauxKgZTFzDx60LcBMyqDrghnudf8RM9RvGMIz19H2f2rNHu459BpxhxmFr8QpaYwdeUsDN/XU0QVmdNu0EdIg9lUSpl/3oz7M3eljyb4rA55pVl/dQY1KypG9sTPtdnBYYbk0F9ZFjr7DQNXyN8ha5hU0YL5jbXpsb3oLQLjK5zx7RXudVbZgjBsycegWiXNaWhciRcUB6juHFJV1dSj0b89aE/M4Zyn0tEGfxJpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a KUnit test (page_alloc_skip_kasan) to verify that page allocations
using __GFP_SKIP_KASAN (GFP_KERNEL | __GFP_SKIP_KASAN, GFP_HIGHUSER, and
GFP_HIGHUSER_MOVABLE) under CONFIG_KASAN_HW_TAGS:
1. Reset page_kasan_tag() to KASAN_TAG_KERNEL (0xff) across all sub-pages
   of a high-order allocation, and
2. Return a match-all (0xff) linear-map pointer from page_address() that
   does not trigger a KASAN fault even when the underlying physical
   granules carry a mismatched tag (such as KASAN_TAG_INVALID or
   restored userspace PROT_MTE tags).

Assisted-by: LLM
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 mm/kasan/kasan_test_c.c | 44 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index f34163e19bd6..72342137bb18 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -380,6 +380,49 @@ static void page_alloc_uaf(struct kunit *test)
 	KUNIT_EXPECT_KASAN_FAIL_READ(test, ((volatile char *)ptr)[0]);
 }
 
+static void page_alloc_skip_kasan_helper(struct kunit *test, gfp_t gfp)
+{
+	struct page *pages;
+	size_t order = 2;
+	char *ptr;
+	size_t i;
+
+	pages = alloc_pages(gfp, order);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
+
+	for (i = 0; i < (1UL << order); i++) {
+		/*
+		 * __GFP_SKIP_KASAN allocations must carry the match-all tag
+		 * in page->flags, and so in page_address(), not a random tag.
+		 */
+		KUNIT_EXPECT_EQ(test, page_kasan_tag(pages + i),
+				(u8)KASAN_TAG_KERNEL);
+
+		ptr = page_address(pages + i);
+		KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), (u8)KASAN_TAG_KERNEL);
+
+		/*
+		 * The memory tags of such pages are arbitrary: stale poison,
+		 * or tags set by userspace through PROT_MTE. Accesses via
+		 * page_address() must not fault regardless.
+		 */
+		kasan_poison(ptr, PAGE_SIZE, KASAN_TAG_INVALID, false);
+		KUNIT_EXPECT_KASAN_RESULT(test, WRITE_ONCE(*ptr, 0),
+					  "WRITE_ONCE(*ptr, 0)", false);
+	}
+
+	__free_pages(pages, order);
+}
+
+static void page_alloc_skip_kasan(struct kunit *test)
+{
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS);
+
+	page_alloc_skip_kasan_helper(test, GFP_KERNEL | __GFP_SKIP_KASAN);
+	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER);
+	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER_MOVABLE);
+}
+
 static void krealloc_more_oob_helper(struct kunit *test,
 					size_t size1, size_t size2)
 {
@@ -2369,6 +2412,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(kmalloc_large_invalid_free),
 	KUNIT_CASE(page_alloc_oob_right),
 	KUNIT_CASE(page_alloc_uaf),
+	KUNIT_CASE(page_alloc_skip_kasan),
 	KUNIT_CASE(krealloc_more_oob),
 	KUNIT_CASE(krealloc_less_oob),
 	KUNIT_CASE(krealloc_large_more_oob),
-- 
2.56.0.611.g1030f0b940-goog


