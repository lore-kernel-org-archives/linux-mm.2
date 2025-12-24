Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6D1BE7490E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 04:22:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BAB36B0093; Tue, 23 Dec 2025 23:22:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 426876B0095; Tue, 23 Dec 2025 23:22:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27F326B0096; Tue, 23 Dec 2025 23:22:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1856B6B0093
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:22:28 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C9F2913B4D3
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:27 +0000 (UTC)
X-FDA: 84253067934.07.2DB6E18
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf30.hostedemail.com (Postfix) with ESMTP id EBDDF80002
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Top7b3Rc;
	spf=pass (imf30.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766550146; a=rsa-sha256;
	cv=none;
	b=3N/x1kMY8N7v8TjEf6rRZbJmX5phzk6gqMCAip9RgXrwrzXo5aaxVF6MzgVOEto8bOTg5J
	aTwnQGIULjSShYKZt9PinyXQnUHJE1GawiUeInLYANklpDVl6RZM/Q2RbXYZadIsu9r6Lj
	+dfIoyEkL2t9bZloh9dsPR9MxM6WOA0=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Top7b3Rc;
	spf=pass (imf30.hostedemail.com: domain of shu17az@gmail.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=shu17az@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766550146;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qAW++Y4fgSGuWCowvvKY4zihTht5dFRLAo1G1kvZ8PA=;
	b=V4cPZ686XAamDVqwwbqMLnMmYPE7l9AVrr5CrFu4+AsAqkgq7seIUhKEO/dEnLhPPpMDr/
	x2rtymL9Rtbg+4Z/RdCUkt5rkgJ9HqNv4YV8ntNG5LTf71p10leCYldoBm3/9JCwJVqqIh
	IJsiEJo/CRVtVC7qk0gpdmizyfEtADU=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c05d66dbab2so6054313a12.0
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:22:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766550145; x=1767154945; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qAW++Y4fgSGuWCowvvKY4zihTht5dFRLAo1G1kvZ8PA=;
        b=Top7b3RcwQUX87xlzi+Rk+tjbEIR0bR4XcUB397y3KNtzwzQUtPqZza2AL+oVY57Lg
         g8xxE8+N6qLXiPxhodBV90dJB/5H7o8r5zNKJ0HXN6DILlp41hWDGuu8Q1++KqCkcyZp
         kAI/5UoZQPCPZodSO3QDDmt2rS5kw50jXpKWcb8Yq8PbPZMEjUyc7i3W8cibv/BPOwyF
         McJce6rDjlgUPljQU35+MrGelbJ4R7Qh16AFcWxXDSlS/Ml9mKLLpBnndZsdFt4SuNP6
         HJrmOQgkTh7siXYmUHqtyvqJe71UfuoUVY4QjRDM6PUfb8izDBCQTfBKRPDeipij69F4
         Nh9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766550145; x=1767154945;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qAW++Y4fgSGuWCowvvKY4zihTht5dFRLAo1G1kvZ8PA=;
        b=l9CH7NZ6NvJDPD0BaNG1TOh/yTzwBGTX2gmHtXlrk/M48ss2PoJ5j4FPe3L+cGUiAy
         sBW6Ly9PhpPFvQNsgqtGxgVJjiHTT4A7sRHwioHqI5i943BfblJTg6xOWtrefF8jS51Z
         JnBkgxR7ZeLUUyt7ize5XW874IRH38ao03oTr1EESYt8jnrhievbTWnwLYTpH6ZhsP60
         9vjQ5D9kXc7LdmbP0oL+zzrSZVJ7S/1Igngust14r5sP0GuncQl97tcPwyJaPAI4dHNI
         L6XKiGjrFGYUCfa7LcSh+vyem6C94dcfwDVKexQx8vDshB9CA16C9Blqvx/hbWfayJ9e
         Si/w==
X-Forwarded-Encrypted: i=1; AJvYcCWYPp/i24lAPDgDCPBKUCpUgVe0FxnoG9QMbbcHDrE+lF8Kf5j/RuQyPzxGWTK+6l4A5lu1HDOLqQ==@kvack.org
X-Gm-Message-State: AOJu0Yydkbrxz/60lVN0Uw9z7wm8groFSq/onirTHrhiap1n2hSuV5cZ
	/W/TjZN+RJbD5QpRqziqVP680nhsXmQSPA3006t0BRKZp8nX5DfENrnf
X-Gm-Gg: AY/fxX6Bijd3UcgiloEU4Ja+bYX7GeHJOZn4abHJB4m7YlrBz+HCfunQnGDXp5IyscA
	aJSDZfx0I6sOJkf/9mFOXahTU3yahJNIZSt/h4pDiq/AEntDt5CMHXI9KIlidtZnREqG/LJMjPh
	f+zP64J2sPKWWJgbvc8/lTW+FXVPTO7FR9bv1MhzAGzCcnyXEwWtP2OS+2UFMDmv4xj7DELuo/N
	r21u+k3bsVLsD1KHnJ5MpDZqIT0OtbYkn/84celZPAK7VDB5rEPKL9l0wQWwl26GLkIn0XAJ3zH
	Pb9nsUSQMGKREkUn9xxLG/qnaefgM6jdvlKERx1Mb+ilC8XlbO4mhhTKWyBl3uYLYwNJBx5AGde
	bUeyiFe9MJvt3UHIWthjy9M5GfHKjwubNG/bPYRFYzBZfxrs0RDRldgMzyOQLbnMz4H//Wksj/W
	Ms
X-Google-Smtp-Source: AGHT+IEu3ypAtOJAXn9xiXQKRtee61CBDqJzBQT9KTWObNvd9b3sJXcWL8HyG3+q6D0Cz6eLFD6TVg==
X-Received: by 2002:a05:7022:2590:b0:11d:fcb2:3311 with SMTP id a92af1059eb24-121722e32demr13284390c88.27.1766550144772;
        Tue, 23 Dec 2025 20:22:24 -0800 (PST)
Received: from dev.. ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm48542031c88.8.2025.12.23.20.22.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 20:22:24 -0800 (PST)
From: Shu Anzai <shu17az@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shu Anzai <shu17az@gmail.com>
Subject: [PATCH v2 4/5] mm/damon/tests/core-kunit: add test cases for multiple regions in damon_test_split_regions_of()
Date: Wed, 24 Dec 2025 04:21:59 +0000
Message-ID: <20251224042200.2061847-5-shu17az@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224042200.2061847-1-shu17az@gmail.com>
References: <20251224042200.2061847-1-shu17az@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: EBDDF80002
X-Rspamd-Server: rspam04
X-Stat-Signature: 5xen9ohi88dc6ze19zowzx4mxmy41z83
X-HE-Tag: 1766550145-480149
X-HE-Meta: U2FsdGVkX1+c6Ac8UvFeQ0IHzOuGN+al5JqxsB/rwy23lUwtzYWpKj+9jWssSCoZk7smEDm4D2T+CQPEIJO+BS2clrR40Su2fdhu69FLHpSlJeOUhvAGlMvFEdE9CJzSJ452lyd+hqUJMAtTEeMT2rLVajYZnmCXaGLbXScqo0Z/cWB+xXFs41WvF4V9LnhWbw4C/SqKlcMLM6PWhpOaM4gPMDamQGYQG/wsfShV0HKZIkZvvPVrdkCMakA5xhJ29h2S7atN1kVZqINY8V8rewSpik3+cj7VJiDrkBkfDYYi30eEYTA1s7kAouh9WvU83ItuPWjuJqr9fCzTod1myyyKjoZ/coapzCDuLH7vdcm2vgSZu94VChB75RtbmTFVG2tkciigQctMjiHmRps8l4zJrMURZqdtepPZFI6ZEaFLNvJVymmb+wBvtShSzyumkYsUuLbLJx858qXcwIfmFuJIZlciSz+RPx1JrwrR+ilASHmoyvZiq27mVEL9EWk6TkefwfOPzoXkx89TxqilzvXf98Xbg+cWH3DX3qtQTH4Bc6P/nOrJYF6LpU4fsNPqLRAHls+lXP92OCN/NETZwKM3Rj4RtGyV5gCRhmGMQroZN0wemGKMGi1Y7VEQWaLLtVhIifSxKkUaXNn9IZ4me41hu98s7Yd/Kj2bqTG2jhm+cKKTNlJrC615zOCVnV7FgwiJwodSiNJWqg5FoK+GvDO6AD75hy2kjrylWCS8iUWrbStWgTv1byhhfwQqVSlDmMiDI/fMvGUmKiKNpbdB90XHMT/6r7niPjcoxnQx0VkK19/X5pcoIM5hKwhlI+HOXJLqnsYYIb0mQl6/6vWMzCkSlxooy8q2xaz4K4mMeCQT1XH9bkmxRgDBDe8GLQdvO0Of7iEV/DVG3N7nFhmitFruOga8YQ8Vfnr9f4aPI4qqP6H94SOfftljuGF0XUUnnUko8+pa+goS7u14Ad3
 Hb00ezG8
 uNcPv2UiqklcYxOXTPfxcYUm/C14ZhglzzBcfeT7xMCthEjQXMjkZgLA9CijR15/6p6jRtBFFH8gM5Ase5Kb9YD6jZrViJzUDiDLCeqQgNNRHwfFYhEGOHbH567TlbIMz8hS1sVFh19jbcx4p/Umb84VRCu9+GcDTWgQKiE2HJgMGldZufTAtEseI6b2iYpDD1u/XoeVV1s2yMn6TQ6mw/08Pe2KG/JrqSJfDmNT5Znwe82UPVlmmJ/ksEVmqCAEaAKA0F5rq1+kbLhdNE8vlxVxeGO1nyDc1SeIlH9FvaX4vhpPwJRVkQmi3SgY82VSLMem+QVaTTC5jqVwWrtosIyg77arw+OjEMV6ii4T1ZqnsQmBgfO9Ryqud32QcYoHfK+yQQWHh/8ysJXdpDht7fr3HZouF0N2myZNNSPtnK8xHkahBJWQ/8u35KgkFd4E9gmLs6cyF9LZKZFk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_test_split_regions_of() to verify that it correctly handles 
multiple regions with various 'min_sz_region'.

Signed-off-by: Shu Anzai <shu17az@gmail.com>
---
 mm/damon/tests/core-kunit.h | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 2eb6f41635a8..36622a2c11f1 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -275,6 +275,9 @@ static void damon_test_split_regions_of(struct kunit *test)
 {
 	struct damon_target *t;
 	struct damon_region *r;
+	unsigned long sa[] = {0, 300, 500};
+	unsigned long ea[] = {220, 400, 700};
+	int i;
 
 	t = damon_new_target();
 	if (!t)
@@ -301,6 +304,24 @@ static void damon_test_split_regions_of(struct kunit *test)
 	damon_split_regions_of(t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
+
+	t = damon_new_target();
+	if (!t)
+		kunit_skip(test, "third target alloc fail");
+	for (i = 0; i < ARRAY_SIZE(sa); i++) {
+		r = damon_new_region(sa[i], ea[i]);
+		if (!r) {
+			damon_free_target(t);
+			kunit_skip(test, "region alloc fail");
+		}
+		damon_add_region(r, t);
+	}
+	damon_split_regions_of(t, 4, 5);
+	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 12u);
+	damon_for_each_region(r, t) {
+		KUNIT_EXPECT_GE(test, damon_sz_region(r) % 5ul, 0ul);
+	}
+	damon_free_target(t);
 }
 
 static void damon_test_ops_registration(struct kunit *test)
-- 
2.43.0


