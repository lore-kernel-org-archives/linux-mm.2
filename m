Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9326EFCD9A
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 11:08:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B4D46B008C; Mon,  9 Mar 2026 07:08:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 334996B0092; Mon,  9 Mar 2026 07:08:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 260AB6B0093; Mon,  9 Mar 2026 07:08:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16E2B6B008C
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 07:08:21 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD8F8C0155
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:20 +0000 (UTC)
X-FDA: 84526250760.11.EC5225B
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id CB7BF14000D
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:08:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dzrNIntp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773054498;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N4HGQ0yYz7DIk6VexLHFU9Nzgo9+u3GkTdEP1uFtaE0=;
	b=eqWVedceNNF7OAHqSJQxjdSlc4llaIPeGXIRPDpByiA4qCNhSkjTv9EK6K70pHVnhsuvIu
	81Iujttq8cuznujEGZhRRpogLPo461ih05s5qmCLmwkx3SyMD24MM1lhEDd8m71FMhzw/h
	apCtrTqdpXyGRANYByepI2CchSPoi7g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773054498; a=rsa-sha256;
	cv=none;
	b=WFNd4IJfdx74Mg5JHtWy60krckMJ451uODgWjqgrg/l6nOK5YggEDT5Jl4FB4mVosb1El6
	USk1IXgfgLWbhijxcgVk2dIioem41nXDMDptqay6smb61oRfdTHsVUs1GGq2jREOyFHYJj
	5oodPw3wlxhWojNrENSZzr0KDGZk8uM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=dzrNIntp;
	spf=none (imf23.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=N4HGQ0yYz7DIk6VexLHFU9Nzgo9+u3GkTdEP1uFtaE0=; b=dzrNIntpVxT6cyfGOLdS/AuFBn
	KoPTQiOlGIlz4i0FfjWTL1rfst+Cfpbs8MX8Gs0OPGcvUivBzWYnV6rwV5V9wmRKbNdjlIz0UlTE+
	eXRAZo5/MqR1jBHSNZY8WEt4Hbd+hBFgMqB9FinSel9Q8+5w+JEKoX8l548D2mD8dEeFao86z6wvd
	fSno6VKnc+Liem6MWw45zcRapK4xezH4G//BySGJSiFcJ8RR+SfMwkWTAQt7k4ZREOw/MRsL7GkOH
	Oj/XtT4lulUVLKrfRiGBHoXrrL8oX2vTJLKFgliuBOifPPX4ruhHA+OsYyvKYhD2kI5s5DX2rwQAe
	2hqhjrPg==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzYT2-002Awp-P8; Mon, 09 Mar 2026 11:08:09 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 09 Mar 2026 04:07:32 -0700
Subject: [PATCH v4 3/4] mm: huge_memory: refactor enabled_store() with
 change_enabled()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260309-thp_logs-v4-3-926b9840083e@debian.org>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
In-Reply-To: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>, 
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3458; i=leitao@debian.org;
 h=from:subject:message-id; bh=Rps73ws/DtMzsKWxDZkfpvyl2AU0CyVMps0aEftLyqQ=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBprqn/YQ4/idw1iXzDtS07ZJOflm8xgjZE7IOdp
 gm18zxehfaJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaa6p/wAKCRA1o5Of/Hh3
 bUKmEACusVurwYRevmZNNAslBZC0bm0mW0N9BmG03cGa4uzjS6kmskhapX3Y+NlLXVlbPel5yr3
 pa+OBl2fHWgenUWzN3oKRpyKPJeGAlfiiWe8r8LckwJgSRYzt+o5iebL0M5GD/Hk1JQEi0PsAny
 7gP8LBLlvJjKCFN6+VvL1HCHuNHSgXaDA4fOmhGqQPZhXOL2DIPawMqlQfnFqTBO5/5AbXFdFpB
 Wyuj0goQDWhZ7FBqo3sFTN9YuBqqueNsFCsnNkulvA98XdbL1Ze4waumD5Rx2glA3rj1SpMCTch
 E6yQWbdDOp0bj9XGmmvsaOddvh2JvH5n7SNOUfg/IyFJA8dg37NFkWLfHGjvEHBlurGfWLBQx37
 aiKt/BlxFsJEHHFaCzn6e/xZtNDSL/8+mpjmCvseB6KxRq7soR4cokFy8PUzsSDPPUwUKdJPQSs
 UxruOJJdP0NdeYJZPJW1CcALD+PUjC7Zmd5MvBxqizC/03n4UJqB5SDnV30sA+4uMG2lf5UXz5z
 jxHBCvqhA22Yb8KkyJJu18UXwCe77XUzt4YoW0lKh8CBxud9F0z3nSdTk8H1kqP+sRI1F5y08RJ
 vzQ/mbyyTa+DFEUrxuqIUW5fgBitzezIWKr++pQgWWr6n5lsHZrPk5egP+W5slxNu7g07Yrxy52
 +KEm4oWBwGgjbbQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB7BF14000D
X-Stat-Signature: fuw5c1rfbs5xard15zp6mj6omtwmoq5g
X-Rspam-User: 
X-HE-Tag: 1773054498-895826
X-HE-Meta: U2FsdGVkX19ZFaOyPb/Ct+pY51+B0qLJYBTPJswD1IKiC/DZdS3PTvN4MT/UHAgZPnzznb2Wzf3f0vslfPupFKgLIzGYCFrciaXtbwpy6ke+ON4Ce9uhSChVwTJfQP08xLzzi3YLJFGcq6aBJuEJxs6Anxk2zRANV5pbBCmQ++6tS24VSfMxG4h/lHHg1J8y+5Ue/TmBJdvWMuubYa7NunUJ1QO+wJqSuHvQFVX+BS5vJuaCUKLxH63BFFawRIqOIYvkv0Nyhs4dyrxpvHe7nLxQE+CGwiXZxL+cPzQ1NJdRoFdXZActWwLLZtQ2yKEzkTlKai5DfTO7ENBlB3P/qrwst0yTXZdaVj7sUHyD5OyOqxGR2WKOOHIgM2RoA6lJllejigc3y5QA1pcv+/zIGaXvKN2S+nG9pTwBI5A4uLPXqOIcA3lRl0yT73E+he7eM9hcR6fOCiVhWF2OIylW4GQCt6br+Dh/4JpHKYMRUibYi7v6DZBFMVXBiDXMioZ9CZixnkgm3T11Z3H23MhYFvcirARfKnuBgtMFcGK80BFGAa5l/CXqUUo/DiMcX0RWu5OkcjqL1uzUVnwoEQk1cFlzkzhEjr7qhxTlnZFnosBqS50aPscpDXZQmViVQK0r3hpXZPFsE2iDssvDF4KDsjC795AWiwtokDbR3vMDdL8w2yKfWAVpiIYv7Y9gZt2Txb4WqfMJ4EdqANIf7AlWb8gITlYfZPiWDn1iTFy3s2Ldk/96745zrETaEZPxzdEEv3Om5nRoqLzw0GAjmct6aZiNy3TvX4/L2//NCUIWWixLW3K8KAQUiagoJg11bL0o9kn7/bLkOVGzUbZj+wRNDqYQLJQmLcJIonhfu8kjBiVEKsbf1ZCvDxRFlP1tKj0B8z1C6u5rlpyCSiiWgOO530luE87jnDOqNoacoc4kK1J9JaIzpo8QX8NKSZMK/ElZykC9uN5tAL8ra3FkbMv
 yCg/OxtF
 AH831NEKkDnVQjOqxKXSdUpt7K0kmV5RT4GcVm9O1H8gB/YJ2iQXqXus/nf8WrLCIgBJRNqi0Jgo4RkrLv0OEsgjkYDmXCoNf1ii3XB2DAy1okAAauoZCCeiEYMMKpChFMmMsIpGJBaM6bRa1xIfn+Nikp1+2Rdwzn8DCpfRKjWJW6b1+QBhnoPPA/IkKXp02Qp0Ed1EkLqgjJQiuBi4oliebrgQiLUwUVGrU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor enabled_store() to use a new change_enabled() helper.
Introduce a separate enum global_enabled_mode and
global_enabled_mode_strings[], mirroring the anon_enabled_mode
pattern from the previous commit.

A separate enum is necessary because the global THP setting does
not support "inherit", only "always", "madvise", and "never".
Reusing anon_enabled_mode would leave a NULL gap in the string
array, causing sysfs_match_string() to stop early and fail to
match entries after the gap.

The helper uses the same loop pattern as change_anon_orders(),
iterating over an array of flag bit positions and using
test_and_set_bit()/test_and_clear_bit() to track whether the state
actually changed.

Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 2d5b05a416dab..be42a28da31d8 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -330,30 +330,63 @@ static const char * const anon_enabled_mode_strings[] = {
 	[ANON_ENABLED_NEVER]	= "never",
 };
 
+enum global_enabled_mode {
+	GLOBAL_ENABLED_ALWAYS	= 0,
+	GLOBAL_ENABLED_MADVISE	= 1,
+	GLOBAL_ENABLED_NEVER	= 2,
+};
+
+static const char * const global_enabled_mode_strings[] = {
+	[GLOBAL_ENABLED_ALWAYS]		= "always",
+	[GLOBAL_ENABLED_MADVISE]	= "madvise",
+	[GLOBAL_ENABLED_NEVER]		= "never",
+};
+
+static bool change_enabled(enum global_enabled_mode mode)
+{
+	static const unsigned long thp_flags[] = {
+		TRANSPARENT_HUGEPAGE_FLAG,
+		TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+	};
+	enum global_enabled_mode m;
+	bool changed = false;
+
+	for (m = 0; m < ARRAY_SIZE(thp_flags); m++) {
+		if (m == mode)
+			changed |= !test_and_set_bit(thp_flags[m],
+						     &transparent_hugepage_flags);
+		else
+			changed |= test_and_clear_bit(thp_flags[m],
+						      &transparent_hugepage_flags);
+	}
+
+	return changed;
+}
+
 static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
 {
-	ssize_t ret = count;
+	int mode;
 
-	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-	} else
-		ret = -EINVAL;
+	mode = sysfs_match_string(global_enabled_mode_strings, buf);
+	if (mode < 0)
+		return -EINVAL;
 
-	if (ret > 0) {
+	if (change_enabled(mode)) {
 		int err = start_stop_khugepaged();
+
 		if (err)
-			ret = err;
+			return err;
+	} else {
+		/*
+		 * Recalculate watermarks even when the mode didn't
+		 * change, as the previous code always called
+		 * start_stop_khugepaged() which does this internally.
+		 */
+		set_recommended_min_free_kbytes();
 	}
-	return ret;
+	return count;
 }
 
 static struct kobj_attribute enabled_attr = __ATTR_RW(enabled);

-- 
2.47.3


