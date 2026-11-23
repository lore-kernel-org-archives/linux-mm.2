Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D0E606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.a=rsa-sha256 header.s=google header.b=Y0HJ5+cV
Received: by kanga.kvack.org (Postfix)
	id 79C286B05B8; Sun, 22 Nov 2026 22:31:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7454F6B05B9; Sun, 22 Nov 2026 22:31:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E78E6B05BA; Sun, 22 Nov 2026 22:31:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D51F6B05B8
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:31:29 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AA149160793
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:31:28 +0000 (UTC)
X-FDA: 85464958656.01.AAA84EC
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf06.hostedemail.com (Postfix) with ESMTP id C41CE180006
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:31:26 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y0HJ5+cV;
	spf=pass (imf06.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795404686;
	b=QT0JddUMLGtZvd1leDJ/OyjaED97FMEVJmAsfwz7Bc+dWM2YDbwR5BxNR5oqPpB2pnLHyi
	2pAfONxMk2jjolDNRTMEPXk7A0e+qfI8D4ZYJTA1QRQY9SrfBZKBhpeteVItHdckQgCn7F
	1P9ik/hK3YOosXwg2PeFdCXfg8D6LmM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795404686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ar/2HKjK+NYDL4XIdqT0HePA7oYDrfs2vyoMNJhSjA0=;
	b=YIRB6oepWgOlwswBRodkZnEt4/9CcHGZio8Wkm3a3zcB2D3TP3PNv7WtoQGLG18CJAZDgd
	O9viOADhQEHjq1CSvYBmR1LgMeXWg1Hd4hd0YeGpcnCrz3cvLUFj/1TGQUEkwZlmn5mVED
	d8Cwn51KNSS4HhE3vYSDMieTES4HBAc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=Y0HJ5+cV;
	spf=pass (imf06.hostedemail.com: domain of jeffxu@chromium.org designates 209.85.215.170 as permitted sender) smtp.mailfrom=jeffxu@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cd6b9a2735fso142596a12.1
        for <linux-mm@kvack.org>; Sun, 22 Nov 2026 19:31:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1795404685; x=1796009485; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ar/2HKjK+NYDL4XIdqT0HePA7oYDrfs2vyoMNJhSjA0=;
        b=Y0HJ5+cVYSI6Of82B+ApVlLyPZiRiM7hovx28vHBcAGBCa1c6U0NArdKvAxqS7+xmA
         Mc7OWPa7lng5OlabmhBruufywWX8e+jbfQx1KlmZwoVf+5FK5YYL+utjNqFADKKxH/gh
         hKbnwQALjheJOWN93q5lhl7G1SQcDtAYERFxg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795404685; x=1796009485;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Ar/2HKjK+NYDL4XIdqT0HePA7oYDrfs2vyoMNJhSjA0=;
        b=EWSqsdDveDYjgQ4EURQK4r25gAJdRSipwlyJzAh31pqcfFCxcOk1JKmVC1W2WPGkJG
         fTCO1C1IuvF5ZNuSG39deMxaa9F2Va7iNu/hmnmhZKz+46jd0pixcIZOLfhGY/PYpcn6
         nOm1hJnMcIfV8KtZogJEojtymAUFvH0LyKapiTKwyQHXCqxAkfGd6ut0tq03MhSOZVvG
         v9sin39N2h3NVEd28fPkI3KfKrPR0K4ZfN+9XbsPGwsbAF+fdogs/7jEoyBRh3HCU8Qq
         hJme/almuTELKU4n+W2imv64x/w/Jpq58iXGDb6MooubLX935m3Kdhsfk8wx7ja6lsiM
         izPg==
X-Forwarded-Encrypted: i=1; AL+hErGtUhE5fDLuzujyZbD+/0pyYrh1t5gdXbhTOXpBcqINV9DdOoCXyGkWmtPxYayNesz2TtEBVm+cSw==@kvack.org
X-Gm-Message-State: APuU4Z/4ciWiH9fBZLJvaJi9E+GcqntnS5Ah8b8voz6hhgEpKuQ+E3Ir
	nsl/Q2Iv0ihG4/bRkWA1HBIkJq1caV979lPa/rg0JqwwRlvmoKjjbJ12OiwNPY/gaQ==
X-Gm-Gg: AZFdTZdVdtTUEqZMmxeKZL9tVNDrcMKsUNd12bb1Q2YuOQ44LVeroZEB+i2Nv6oXazZ
	txc5e8KfMhdOC5MXzapeYJGG+vfXMZ6HBjxlOATHkChlmPj2IlIrA6sw68V/cSRDSJ1U9/BZz5F
	J5QRwDolwzUKdRfm2BnoSQi1X6CCmZ7GVsahqzuLTqS1cxiKJsWCYx/T87r4ivmMNUfYkcjKW9R
	X3eAXEJReHSbWz1pbbj3FpdJspt/l7ccmJrrLaiUk75iEQuOcvuq9tW/z42cErgCpvCRldTxV+b
	BojDeQd4CrrOrqSjSUKrDEV7szzO0zNsMUTYUf5JcueLwMFN6xYugeymSoXvYDBY/EQDFXfG2do
	dFGoOJeXL6lYND3LTot9CIvrU9l1WGdoYVPNd5La01YnLLlx6Zg0Fv0Y56OAN9sF59vTkqvajo/
	w+avTZJ+RUc7697Hwh9PCdkFmOeZWurWAYMaZem26wF49XyTyWSFhKr0Flua53pEdFAPs45WtVZ
	LBSJ4slYWXwhU8EaYgaYYLFlGcUw+LdoRsHiCbx5EJ6ipejEM1PJFjb4v3KNmf39HtoGrgU5k9V
	Nm4vFVabeAyXzOW3B989wxcPNzKU2qL7ArzqfnNyVby/p4S8WUK+LKzmXL8DExArwPiTig==
X-Received: by 2002:a05:6a20:9f08:b0:3ef:2f72:c7e5 with SMTP id adf61e73a8af0-4014ae6fe31mr16689502637.2.1795404685515;
        Sun, 22 Nov 2026 19:31:25 -0800 (PST)
Received: from localhost (221.247.125.34.bc.googleusercontent.com. [34.125.247.221])
        by smtp.gmail.com with UTF8SMTPSA id d2e1a72fcca58-8c873f16b41sm4720304b3a.56.2026.11.22.19.31.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Nov 2026 19:31:24 -0800 (PST)
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
Subject: [PATCH v2 2/2] mm/kasan/kunit: add page_alloc_skip_kasan test
Date: Sun, 22 Nov 2026 19:31:11 -0800
Message-ID: <20261123033111.2349160-3-jeffxu@chromium.org>
X-Mailer: git-send-email 2.56.1.750.gf70dc682cf-goog
In-Reply-To: <20261123033111.2349160-1-jeffxu@chromium.org>
References: <20261123033111.2349160-1-jeffxu@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User:
X-Rspamd-Queue-Id: C41CE180006
X-Stat-Signature: tq7yxkaxks57nf7mq9sh1cwx89ddwjbx
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795404686-327261
X-HE-Meta: U2FsdGVkX18eqCixV0EHAmChWvJ5JKm2EUBCJunEgpDqFuroIkLYjxbUqrVYXB6yQTPTO60bcrLsuVqDILDzQw+9lDeZbsbxY7aq5cneUw0pKIZ0sf/Cz1x2/PWOb2Fz9+eAawthpZuojmA7DJo+IYh592wKUMWxAlzq7htXb6I3JDz/acpYR7D5VfSJjYbrkWN3HSLjDWQgk76KQRFcFGEGEdhCeg2n8y+T3r8vsWs6u42Bk1FtMyTF/+v9UiWDeROEy6n29NWsUDxaq8mzJlrlnZwgqI8TAwxbOW5q+V5YeQ21r7tucqEGEagAtl+41V8sgt8SQbwF5pKeep2KUJnxjA9BYDm8HTZ4vmNvUJavF0C7VX3+Sw/3F8FQhwBMhnjtsqcqRXljw2w3yi44jdU8dngzFlAB0O2rX2xMxLxHVI8js53XQcmIHDogwrHqk6QQlnMYupNDbcT5OrFIDXjffgK5+4UpVFObvA3tfSqo665BE0jArnTJH/P7SlYnVyuZQZCQzQUn7N69Jjd4bQ5Am76zk5Oi5LQYTwcI78FUTNQdAjlUmGHPmJKO3vK7tRlYMPI2DArboPdRq9t7irpMrwEs82vnEdv1iqM4yep98jKxE3n7CqnKpP0koXTOVAZjNMnlnEg+0dSeXoMiTZNKW6ToODKwJ3rdDeh/eiNpz7azsBs0pThCDM9cq/hcPtKz7+Kqnlx918mTrBwomuz8+GyZmQo96NkLSwBDnrWz4l0tRrJL601aY0Yvnfqepuh/OCvJdRS+HoQ50EtUFr4z67otYY51+WwOilHKjZwFYpVmSsFGtYq40GfzB43Vb26KYdpPEbti3pz1DL5zxUjL7LpyL58AI6NlDLGWD8IOuCkjRmS1iqSM5FWe/jz03FXwsmoSAcYIblBkeUm3wapSeGVhAXxDyYOZwvV60zk8P/hRiS09NH05cuOf+RCoCAXh7LaAKvHDOmCuvMk
 ulX1GCa1
 Zat43UJDNTwZQnQBP8MCx8JIvYgJ89RuzIpnlFx9qzeL2v4CvHfJRgaMj4yIopOK5kTZhEoMBuqiW0guGssKqJKIscQGimvK8H3Vzv0Y7yTV5zPfHjGCF13/DU/hG3Mrq0SNrG9fPtJuWdukt0Cbf1yDuPJ7i0kx1ErpP/xy9Rp1aoUxpbYryYLBuQJhx/2psZ4kBM1p/qJZQz+B8M0TqWUwGV6bCWfa8hL3PqY9Byz7ZhmFuWcA0jrom7erljBCxdxJ3TOWDttXfORO3eNk8usC/eE/wOpAlzLoxY6hW8HWYawE4gGCI+nkPhrkwtlogrsvQ2zYcfFpw1kUYq9dRfD+LnopO9grYmKcAs3/35hVdvAdVn0UWxNkZNgUqx+2NvS0K/gPTmYsWbUgimrHmCowlR6DY0zVoXCDXVm5u7PrEnCCZuR1gMcs3zV4QqYeUA7FVhpL1K8NhuCa0wbgUyRInPJgsLGYRXgrIZc38tqnoFPA9GLmPpg0r4f4hyM8f+s26ZqTjRORV3VvFA9Hknf7u2z+McWhhXuQt4vJhKCruaneCr3paEZUu4accfYz5qsq4hVANnDbkNHjyfcR16hwGejd49aRzlDBwYMplaRij+XyyWZwaYfOasT+PAdQpFSejLmfouJsKtnYlpL+C7vU3Mg==
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

Tested on arm64 with CONFIG_KASAN_HW_TAGS under QEMU (virt,mte=on) with
kasan.mode=sync, async and asymm.

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
2.56.1.750.gf70dc682cf-goog


