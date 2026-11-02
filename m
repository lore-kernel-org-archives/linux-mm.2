Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D87606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 10:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=FXXOQLqo
Received: by kanga.kvack.org (Postfix)
	id 96A3D6B05BD; Mon,  2 Nov 2026 05:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940ED6B05BE; Mon,  2 Nov 2026 05:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 857D06B05BF; Mon,  2 Nov 2026 05:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 481486B05BD
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 05:41:59 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C841480C13
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:41:58 +0000 (UTC)
X-FDA: 85389838716.04.8A5EB32
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id EAF6840003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:41:56 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FXXOQLqo;
	spf=pass (imf12.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793616116;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OJg1Na+PMAE5RwVgjsfjwULctd8zKBeuPkayvvN7fUg=;
	b=B4Yx9Ci939wbUb3wF55I9KV1l24i81haGLF5RRYQCs7ZSkRF97B7ZwygARB3FS/ZftY2x+
	phObOujnL9lRgjpSgQ+5S3VBzYWBixhGyDu5KkK+e87d4+XgRt8OvNN0NzP3kUzYjJtR9f
	rWdIKcN1IK7WY8VciLC7lpZTG2C04gE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=FXXOQLqo;
	spf=pass (imf12.hostedemail.com: domain of umangpokhriyall@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=umangpokhriyall@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793616117;
	b=DrE9GYUAYrwy1omUFQyT60m0lkWRSm+iCzLpgDVf2ZZ6Vwo3rsOb2ref38NJaYA9V9eYXB
	V3KUG9EX8Sgaq5H6ELP/My4p0X5E8FAJCzKieGb6CPATyP2gavyBUaBooUler3nEhzYl0X
	XdBSK9EF7wowCAXLq7qVA2nmMiC53EM=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e99b1e5b4cso16789575ad.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 02:41:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793616116; x=1794220916; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OJg1Na+PMAE5RwVgjsfjwULctd8zKBeuPkayvvN7fUg=;
        b=FXXOQLqo7usc8yoiupVQ/cNQSTzLy3FzIKHHr10E3xrG7GsteRKVJDm8TkLhlEn9Sr
         L+ZBFMAx4MxT8PVrtKnskA7lYVovOLJl6KCfkmRTUtXzOjY4qUtYf1b/19zJD2m4U1ff
         oJFaSL1wT3aZXm/rmU2ESBMe/0LXEKZSTWKY4yfd09nq+WXv38N2sX+wsOW2WCcv1P9i
         9wHXZYhWLFP0RMuuOgncNDXM634KT7bdQ2VM2g1aRm+kpNV9fSVpDlio21d+MKz9pNy2
         jET4dtlAl9xOdvT7cnfZWQ5NBbSzDt5eCjnY4O1+1FQSOOl00oPkOpID1tMEdv+ul47D
         ZRIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793616116; x=1794220916;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=OJg1Na+PMAE5RwVgjsfjwULctd8zKBeuPkayvvN7fUg=;
        b=MMfsoR99Zj98G2jV/SStwSHRycrQr++iakZKyv6LlclvBLe3pzv935hu+Kic/Xf3eI
         IHtz8mPjqjgbVgX+izM5BSX9i19pTPE3mBPpeLoBaCPpFtKdkwMkIBU+BmNfwHC3rbB7
         WVyJuFjplSvpJklpV4cTH0nCuaywl6cLtVlI2LAFOSaAn845jXJfrpFSmZ7gsCfXU6Sj
         +iVzcX+g66kVxSsN97WNSu3jfwiwPj1tHRLR9VpE7bOhP3XKzbZQH1agW8rqq35jHWM4
         zlVEC3zxLyQgnzX56ABXYoLy8oYQvknXyr5pKpk5d/sodayru+bna0XudG/l1teCOkf/
         l98A==
X-Forwarded-Encrypted: i=1; AKwUvBwzHA9WQZP7EEeg/gqvJ8MUXkTj88eoTNFQx2Q0bsD/cxDrWV50W966CKFt6Bna89ZEl5zurSzQaQ==@kvack.org
X-Gm-Message-State: APuU4Z+HlmebHzQAoDRcYjZhtVUA9uDgZ4EZv2vEjHnG8F0fNakz6nCB
	a9SMA2AWBPnoEjIiBF2b4CGrO1HcqWOIQkx+q2rPSa0uxtQb2FdPZMeb
X-Gm-Gg: AYBFou2wkjbIhuBDl7KaRRHoZoLbU03gFOMG6bEMg3RlyfQHL5xfpf/qoRf4EC5wO/J
	PLwaj1/5Qio/Rln018sTVXZMLEKtFvwQbFZbse4x0/tMWdxh/SsA1QMV2HWyEDnF4VTBmQfSwTi
	yYBs1Io0qpKf8vZvRtgeKJsqS8djXQuH+pr+7FDeCk/3gGcdvpoaexUE4D0vAIKNBGtSEBYPB0u
	cXSC7sWXwsqDTdU6yIFmrLfLtVRRggan98+w76496+1hdXguvOvROZ7L5xlp+XkerS+vP/Er6Q6
	BHVmWhQmJJ2fmEm6vyVnqXkmROyoVbkKrOx1poYmGXFtYWTY8jvtlP6fld9NuRY8CTJTEqb3ggr
	8WhUW63wI8rluOvcBaVPnof32MoizliOuz+Bj75bEujscfLOc9POszA7rMe6hYeI5AwSeF0yzi5
	z7T+x7x4i85JBBD5xcK0dJ5GdzLGeliVMV8ICrQmK4nrulu3GDK1FJBeLXaeCOYiQ9mxjUkiGzU
	OYrpv1fzwG+TsHvmsBYPQOaspff9I8qcPw73UBET1hDq/w5DRvRZVuItZv2/hXuYtvD10iKDAWN
	O/4cjkN5UQckbIbW40XFdWDIeNylXUxQl/hzHoclIMLvADXRLMg5
X-Received: by 2002:a17:902:f691:b0:2df:8b09:93bb with SMTP id d9443c01a7336-2eb3648b69fmr89524235ad.10.1793616115753;
        Mon, 02 Nov 2026 02:41:55 -0800 (PST)
Received: from umang-Inspiron-3501 ([2401:4900:1f3a:7c59:eeec:de7d:b077:9b9f])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb3925ff38sm25195465ad.36.2026.11.02.02.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 02:41:54 -0800 (PST)
From: Umang Pokhriyal <umangpokhriyall@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Umang Pokhriyal <umangpokhriyall@gmail.com>
Subject: [PATCH 2/2] selftests/mm: test a uffd write-protect range with an unregistered page
Date: Mon,  2 Nov 2026 16:06:21 +0530
Message-ID: <20261102103621.156928-3-umangpokhriyall@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261102103621.156928-1-umangpokhriyall@gmail.com>
References: <20261102103621.156928-1-umangpokhriyall@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EAF6840003
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xxbjs8e1486zh5w7w8fscumubqhzssb8
X-HE-Tag: 1793616116-484610
X-HE-Meta: U2FsdGVkX1+//NHe0DD/WI1aJunKr/jFg1MS/yTm+Hh/J4Yy1t4w0nc7pIxS5hAWUE/HTDdvEfnzMQqscLD6U7lWoXmhSPPxyjTZnguC8ErLMqog8cexfnnT6ptT14Xl2P2/UzmD7anoxnByT9FL44q9NVgqmcgfPf9YPGC1WooKOXuI2PBYLEJisVEr7Zz1WUH3t3sV4BUBrDunx8HzN6FkiEl+8APXIwNvFofwWwLnslpWQZ73i2OQXxTdQeDNDZOCBE3WE/75jjEdhuWXu4MHTR40kvpAsRag3cysIx7z7dfpAuet2itSp5+tB3NUG8INcUsa8hn4I6o4f76rJposB+rgFRLriOWBnPqUFJqtFdW8S7NtRFf5qh1wvzchsmF5Nw7t+d34cIYVkNMBwVD6P9wU5a5pB9FAtvoi0E//EF6RNcx5gTNsTtTnyhnlWoWBdFzYpv4Mkk4EBV1TI9XCqSAkAcXBWfk1pJTI6bWe6kmYY1jiySdpReTeyosZnRDCame4FaFNWsnWMA16t4W2mjBwyPEv39Unpe24QjkDtwXgmNE5SNjX6rswDizc8ZijhM2Mdvxel3s2QTHpoDVDfyhmDJdl51Lt84SE+zd32xzB9U0E8heAV/L/kHa+DBTvWOR1HOsu+C6vzFzUMSKUgB9bu3Q7mzFWnGIIuyyEhILz9X1ahlNTAtRxG9YYrg2fb78UdHOHsBUY8l0pUzH3Zv1bedwWsHiWNoY87/7gkQ07+lDqTidRrXAtgV1i8QHlzyi3ARzfUiu8DSs4jLLIitksaoPMYdAANtRevHGl3a5ik6oRswy3dNIiyT+IWIsAD6S5IlQvnmILw9g/G19X+ZfsUjEQ0tdvLJHMMyoJbrrfJ0ECm/RsIDY6TVqKO7kUlrMcQwCctHSrCwNgQZNTnGF74CIUCT4xgrtFyzjUMSihDSVVKRWN/p5eNxtLQScThnN9i7gXzatD3E8
 bbPlW8vH
 ZldI2cZfy7kDulkJRnLdgKVeMo0iGJiZCWYRuinz45LVrqjF5lofwI8Ls8QdIuZW3MOrP+qJXLgvPH5uRn//75nutCvRnoUW/sfruvUugGKUXoSQ7hQw6wIzT4FhtKsXLx2j+svP2TRayc+YDvSM/usX5TFhDE9Gwp4PUT47smpr2UgHLpTRVJPhdmGU9v4V6/W4dCl7x/oSDySwGKNXN1oxXZ7MUpBQEIBrqSq4FBfap33fxHTAGOxIxwNuc0T+OC1H9Z/k2J/XT0UHJhOPrMBg0aYYVDqUKZQQX0jSCxI12E8maCVNRVb8Rd9fZsjRnoPUlVvJpcA8R3c3xkP8TJCiqByqT9ed+EW/YqEw8fYWSe7BFk989SKEmq8EHmpKnHMEQhmmpKCxdw4DvEM6Cx4IUPKUBFXfkL0hxZAULFhOU4eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Register only the first of two pages and check that UFFDIO_WRITEPROTECT
over both pages fails with ENOENT without changing the first page, when
protecting and when unprotecting.

Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 56 ++++++++++++++++++++
 1 file changed, 56 insertions(+)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index 298609544..57e442fd2 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -375,6 +375,56 @@ static void uffd_wp_unpopulated_test(uffd_global_test_opts_t *gopts, uffd_test_a
 	uffd_test_pass();
 }
 
+/*
+ * UFFDIO_WRITEPROTECT over a range whose second page is not registered must
+ * fail without changing the first page, in both directions.
+ */
+static void uffd_wp_partial_range_test(uffd_global_test_opts_t *gopts,
+				       uffd_test_args_t *args)
+{
+	struct uffdio_writeprotect prms = {
+		.range.start = (uint64_t)gopts->area_dst,
+		.range.len = 2 * gopts->page_size,
+	};
+	uint64_t value;
+	int pagemap_fd;
+
+	/* Only the first page is registered; the second is a separate VMA */
+	if (uffd_register(gopts->uffd, gopts->area_dst, gopts->page_size,
+			  false, true, false))
+		err("register failed");
+
+	pagemap_fd = pagemap_open();
+	*gopts->area_dst = 1;
+
+	prms.mode = UFFDIO_WRITEPROTECT_MODE_WP;
+	if (!ioctl(gopts->uffd, UFFDIO_WRITEPROTECT, &prms) || errno != ENOENT) {
+		uffd_test_fail("protect over an unregistered page did not fail with ENOENT");
+		goto out;
+	}
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	if (value & PM_UFFD_WP) {
+		uffd_test_fail("failed protect changed the first page");
+		goto out;
+	}
+
+	wp_range(gopts->uffd, (uint64_t)gopts->area_dst, gopts->page_size, true);
+	prms.mode = 0;
+	if (!ioctl(gopts->uffd, UFFDIO_WRITEPROTECT, &prms) || errno != ENOENT) {
+		uffd_test_fail("unprotect over an unregistered page did not fail with ENOENT");
+		goto out;
+	}
+	value = pagemap_get_entry(pagemap_fd, gopts->area_dst);
+	if (!(value & PM_UFFD_WP)) {
+		uffd_test_fail("failed unprotect changed the first page");
+		goto out;
+	}
+
+	uffd_test_pass();
+out:
+	close(pagemap_fd);
+}
+
 static void uffd_wp_fork_test_common(uffd_global_test_opts_t *gopts, uffd_test_args_t *args,
 				     bool with_event)
 {
@@ -2403,6 +2453,12 @@ uffd_test_case_t uffd_tests[] = {
 		.uffd_feature_required =
 		UFFD_FEATURE_PAGEFAULT_FLAG_WP | UFFD_FEATURE_WP_UNPOPULATED,
 	},
+	{
+		.name = "wp-partial-range",
+		.uffd_fn = uffd_wp_partial_range_test,
+		.mem_targets = MEM_ANON,
+		.uffd_feature_required = UFFD_FEATURE_PAGEFAULT_FLAG_WP,
+	},
 	{
 		.name = "minor",
 		.uffd_fn = uffd_minor_test,
-- 
2.53.0


