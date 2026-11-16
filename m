Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD05B60A2639
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:07:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=fxHRX4Ez
Received: by kanga.kvack.org (Postfix)
	id C408C6B05BD; Mon, 16 Nov 2026 18:07:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0B76B05BF; Mon, 16 Nov 2026 18:07:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8F036B05BD; Mon, 16 Nov 2026 18:07:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 76F046B05BD
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:07:07 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0DE461C31C8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:07:07 +0000 (UTC)
X-FDA: 85442519694.25.DCAFBD1
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf19.hostedemail.com (Postfix) with ESMTP id 2F2171A0006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:07:05 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fxHRX4Ez;
	spf=pass (imf19.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794870425;
	b=IThFeE0vIQiEe0/tCJ0vYZ1yxb3aivb34KdCp6rpk3AkSiaKWuTRrD5nSQaXRrldl+OfuU
	jJj0CcPWXlBSEN4X/nuN23E9axX1cyFU6bMvkLO4YW2kjtfycQtLciUwXN2B8dxCGJiHf5
	/Y3qCIJw5BRXiaa9elPySVI+dw4OpqM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794870425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ov7f0jCh2x7/B/l+YrluktAKi2O0zfS/6BcSjEJkDWQ=;
	b=OyHkqAadO/BVpgeYBWUo5vkbLOvCxII9xVOIJTrV60o0b+qpHj20FtYcpJ3MI/9xoExgek
	s58TiMqUENKdXeIzw/m/KZrNDu/7+9Iu3/tQao4cbYPq0joZDEwTC3RN6mrTl9Zi3u4dDS
	hWraVEPvNbv0qilpUznIedt591N9WZ8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=fxHRX4Ez;
	spf=pass (imf19.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.216.44 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-3b3b522ef8dso1497a91.3
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:07:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1794870424; x=1795475224; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ov7f0jCh2x7/B/l+YrluktAKi2O0zfS/6BcSjEJkDWQ=;
        b=fxHRX4Ezva3nlLAumTZETZQpwiyZ9WGJE0VsrhO4BI2mSi3qrppLMw5DPfweC2bzmr
         WT34igo11dofMgd2KxpvpB7WZ+grrm1FcuSwpYV5NyQ5JNOxwaXdkTBt+zf1WV8y1AOm
         jyR41Q40J6NU/fSiJtZGFiWK1nbaTiKv9ut1E=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794870424; x=1795475224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ov7f0jCh2x7/B/l+YrluktAKi2O0zfS/6BcSjEJkDWQ=;
        b=HYi5nqpfK3m4Z5O6caWsdvwsS+P7sKkOgoxUw4HTNmebgqq0nGGFW4wVxhDDqifemV
         fUltzpIryRSn6oA4xPSclh/kMHpCRESGA7At8jxXso5m4rCbqlA+OyoDxGXj63jlBpSK
         XrQsPfsLiIk0DH0GryyaBVLFx4rt2m1VXrubqE0ZOZQcp4anKvGN1DZdeX9Agyj7QB3P
         OpWrAalm6j2i+vaqRuFCVc2UcnwsXOZvd54lD1BEnb5+xIwN8B4+KSewsw2L0ud52K76
         BH0ubc3ObJrR8yl9bzqU6JmY+LxkIJs4zhy2UKvfhvBa1kfadvpmjrT4lOLRFDMKtA+g
         s33g==
X-Forwarded-Encrypted: i=1; AL+hErErwUxfnpmudoH6erEHqS7LJ3c3lrYQG76UOA4cG1EKVgr6XA2UDV+LXFA5bwYJLw7aRuooqoxqXg==@kvack.org
X-Gm-Message-State: APuU4Z9NZhHmNPrcTujPurUfVphReZ9ukIbkl0pjupPDrP24CH7fxNAM
	+i5pExneQQpzBj/7K04YK1gxe2pE50dtk9WryaY9MD8FHPdDuwAOaC/cCTwdhYs9SA==
X-Gm-Gg: AZFdTZd8+VeYmJxY4/ifZgCVnLico20aPI7TSSYMlfNkCR/w042UR2qX7Xul0f+TohB
	tl7KK0GbAL9kWaKiJXZ22VZsHUpyrYI1gAWkCQZ7OOqXU+0NntxIEeJ7D89a8TLOmXXAfGWRrfZ
	9wz3eZIO/WimZ1o66kOaUiG5qQi52kuRqg+5xyVWtFhNh3R+9kO5iEEcf+vfuqriCxWw/BcGT6F
	bsEm1I8jX+nn+WQ4ed8qOPnDgrJRWJKJ2YOULuKWTtvD1hEi5Cn5xR/rWwmWlz0ikcchmoDzuxF
	MJVtxmoJX9buM/t56NF9x1xMK/41b9/YBEPgJ7fiN6kbBB3U+ezHa7FkoqzKFvcjIwXLGpH5kfM
	Zc9Rv/d9EmYbbKIG7aKcChKrf/fQdC6d9ItN6HL3w3A+bnDOuBS7Q1u3W3MO4liHPEsVmPUkPLG
	x/jwf91bpeoDdM1TcWU4aFzbKc+AZveHSfW+8BJ6rFn284/lWWMOr0IlcskfbEjXQLjwYn9jCJr
	spI3oV56axrtBoFf2FkaF4S8U/3ir7ck6htnUYHsmIzTHgN+kWXG/kYT4jeV5nw3hG2Ov7yQfPS
	kBtBuIcB4AL2wgAOgsF/Y415wsLIEka1VuW1ZeWTNUtdLVctAWXmN7KlNR+J1ZtptfDoAJz/A25
	sb5Glx4Lh+Ulmit4D
X-Received: by 2002:a17:90b:5906:b0:3b0:d0be:f02c with SMTP id 98e67ed59e1d1-3b1b0b4ffffmr17720470a91.6.1794870423621;
        Mon, 16 Nov 2026 15:07:03 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id 41be03b00d2f7-cddc13275cfsm5035019a12.0.2026.11.16.15.07.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2026 15:07:03 -0800 (PST)
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
Subject: [PATCH v1 7/7] mm/kasan/kunit: add page_alloc_highuser_kasan test
Date: Mon, 16 Nov 2026 15:06:27 -0800
Message-ID: <20261116230627.3537051-8-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.0.679.gc527c65306-goog
In-Reply-To: <20261116230627.3537051-1-jeffxu@chromium.org>
References: <20261116230627.3537051-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 2F2171A0006
X-Rspam-User:
X-Stat-Signature: fxi9swyzm9fy5z7mhhbzt1aeaiejzct7
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794870425-816312
X-HE-Meta: U2FsdGVkX18i5sqYKy2nNE4XllHYs3XRG/2g4DY5tOppnFGiUvu3lCb8LWQo426yU5hBJtEWLS7ogF/6iFP9ny4/JGkMx0JfnDDOaz7JoeXNJszxbRUwfZUfVaMedVAY+2FZYM6Q+FM6M4lEZpjU6b05AWSRbCK1qOVh3tXZz6XCGy4oZnOx5AyNUnD8dEyaGIaAogbUqtzFLJdIfURn12mVWjceXHGAxpT/DqU3IG8nXVlFmrmV0YvRMsBavT0nPon+Ocyp8HB8idHFWIvz/aIqHxlFntnXVwTulz93vW94+Rts4QtmDifPQLcGxhBH++D517rJBtAnE8ceUT6bTvqEpupQxsxXyxqe9izk7kjCVP/QJ7uKIoaiGPIVcLC+YR+FwszQQlIYgbHGlf6Gh1ilIzld+KB+3fOcc6dQaOB7QeZjkBPPS6eyL4A15Mm7GwQZF8v7Nxbx0wBL7EZTdN4HtqiIqTpGJdzXdAjapqP0jWSNDL1jcrUC5qLJwYBV8q8WDCx946SKLwUy8QZ/+kKQH0K+DTf3coeFZVsN1KFJw29kcihmixQRhNXnduuX2cUmK8oMVQ0XfHcKqMnPtO5T8BBxDpBZJ2uhJXPfquQ5w/PByno0HaxqwIeKwBCMeebn/VFr+3Q/RQiv9O/b7c89UHjym6NAdW3Y3F8rMaziCe2dHyOMF6HHjliL2tex11mJZqvHUlQCvYevxNeCJRYuGDNGdkc0un8A998Ij2aX++DVwF6yY8DmkjTeZsOnF8+xmwj6kvswOKjooKS6pvsKPs1XVD+KlTnNK5bU0+t4suwCYEv9J9EZ1D+B7yENyKMd4dhB1JzEJvNRxRSL7Qr1ehZMA+eUGlWmSqiPSICzzFI8JDSP+9hTYY0jLDKJypQAyVkT2DhSIkc56s+MZsbdhVf7mxc6Fz+EWsOs+faJl/RRXRDFH5DWXWctfQ6JpvyfnA9zphN7orA0Xaq
 oe53VL2X
 8d3Ug+ta+HHCz43hdgr1bJxwG8V6WJO5MABctJXraLk8R8VtWDbG+NJ/LoMPpt3nQQehN552dLETemC1965L+7Zs1CpPBiRY7KPuAwx8w7g9K0neJYsHiW9h+q8X8mwfdLUxvoAwXbJM9F3CKkqBycn/8IdCuhZNwTwkUbc2UdaoAs86Evuy95mfYbKBLYkDINW9sVl5RxAIetTh28bml12dfTD9MCvTrKtWtd8rJ96VX0DU9Wg2ebYyTqn2yel0Gh4HtIyFnUf2AykCiUUWwSwUDgDSALHXhxnVaN7lODS6Wzs7AkHsVkowd+yWlsZv9lFjktsL5YMVxssKsCShnEOJwtfe3Yfnhs5JIBvjcd3uy9ucKxMnsV/T6c2tLPEoM8hPn//gXLFOVCqGG96V4D3G6r7EnA2o7nIfUugU6UpbaFplfYxmV+Qhnmyl+BvulfNxzHej02gy7/TWHmHnttN7pZmryGSTBJDga25sWrgyn4Q2eWm9N7bEdmZ1S0iPn/Oh3AzctskcOFWw0hCm94THyk/m9rlDbhe8r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Add a KUnit test (page_alloc_highuser_kasan) to verify that, unlike
GFP_HIGHUSER, page allocations using GFP_HIGHUSER_KASAN under
CONFIG_KASAN_HW_TAGS:
1. Get a KASAN tag in page_kasan_tag() across all sub-pages of a
   high-order allocation, and the same tag in the pointer returned by
   page_address(), and
2. Are poisoned on free, so that a use-after-free through the stale
   pointer is reported.

The test fails if __GFP_SKIP_KASAN is added to GFP_HIGHUSER_KASAN.

Tested on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) with
kasan.mode=sync, async and asymm.

Assisted-by: LLM
Signed-off-by: Jeff Xu <jeffxu@chromium.org>
---
 mm/kasan/kasan_test_c.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 72342137bb18..285b82793bdd 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -423,6 +423,33 @@ static void page_alloc_skip_kasan(struct kunit *test)
 	page_alloc_skip_kasan_helper(test, GFP_HIGHUSER_MOVABLE);
 }
 
+static void page_alloc_highuser_kasan(struct kunit *test)
+{
+	struct page *pages;
+	size_t order = 2;
+	char *ptr;
+	size_t i;
+
+	KASAN_TEST_NEEDS_CONFIG_ON(test, CONFIG_KASAN_HW_TAGS);
+
+	pages = alloc_pages(GFP_HIGHUSER_KASAN, order);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, pages);
+	ptr = page_address(pages);
+
+	/* Unlike GFP_HIGHUSER, these pages must get a KASAN tag. */
+	for (i = 0; i < (1UL << order); i++) {
+		KUNIT_EXPECT_GE(test, page_kasan_tag(pages + i),
+				(u8)KASAN_TAG_MIN);
+		KUNIT_EXPECT_LT(test, page_kasan_tag(pages + i),
+				(u8)KASAN_TAG_KERNEL);
+	}
+	KUNIT_EXPECT_EQ(test, (u8)get_tag(ptr), page_kasan_tag(pages));
+
+	/* They are poisoned on free, so a use-after-free is reported. */
+	__free_pages(pages, order);
+	KUNIT_EXPECT_KASAN_FAIL_READ(test, READ_ONCE(*ptr));
+}
+
 static void krealloc_more_oob_helper(struct kunit *test,
 					size_t size1, size_t size2)
 {
@@ -2413,6 +2440,7 @@ static struct kunit_case kasan_kunit_test_cases[] = {
 	KUNIT_CASE(page_alloc_oob_right),
 	KUNIT_CASE(page_alloc_uaf),
 	KUNIT_CASE(page_alloc_skip_kasan),
+	KUNIT_CASE(page_alloc_highuser_kasan),
 	KUNIT_CASE(krealloc_more_oob),
 	KUNIT_CASE(krealloc_less_oob),
 	KUNIT_CASE(krealloc_large_more_oob),
-- 
2.56.0.611.g1030f0b940-goog


