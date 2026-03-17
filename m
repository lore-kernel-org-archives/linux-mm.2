Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FECFFED9EB
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 16:11:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0B76B0093; Tue, 17 Mar 2026 12:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FE36B0092; Tue, 17 Mar 2026 12:11:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E362F6B0093; Tue, 17 Mar 2026 12:11:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CEC116B008C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:11:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8971013A32B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:11:03 +0000 (UTC)
X-FDA: 84556044006.24.C74A1FE
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf07.hostedemail.com (Postfix) with ESMTP id AA11840017
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:11:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AyfhwnMl
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773763861;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YH8fD1IzZL6h5rUNAaqwcILRggoUDJ1blzSAWoAiJKc=;
	b=4hi3Kx3UEJCR5Hp/ySQs384zYyeDXYkxBzj0DqHc8unVJP1flpPELHxpnhPW0lppANmse8
	bGC4vqgNKXvVnxU+sTD7nJP5k2nGNWbVQRUu4oAQjzQCqA+hq5d+b+1WIh7lWB3oLZFYuj
	vSBlhxfxwb2chwVlx0OIl/As3+oM/lE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773763861; a=rsa-sha256;
	cv=none;
	b=zuoyTFDDgoWDzr7DvF0YwPXA68pgiOxpo+Lu5MCOfXnFyaa8LR+akY8unIA4c66G31gpdG
	X40hugbhFsejc0N9vcsoh6zIi72cBsKDebNSMMWMvodT5W9ZnXEpuLCX5o9qscl5CVZGlt
	1AMiyiqj6f9k4OmeiM64qYf8ERAvAA4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=AyfhwnMl;
	dmarc=none;
	spf=none (imf07.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=YH8fD1IzZL6h5rUNAaqwcILRggoUDJ1blzSAWoAiJKc=; b=AyfhwnMlngogFN7ZBxoSi+p1+p
	jcwv86yjzqEgr/MDo7mPDIkuJJIB4YRA5eW/sl9OmaKQOVUyGb+wOTW4yzklJG4AuIr0mg8tuNNC7
	u2TgIceZefQuWAd8omA48b3E7tSvHk94nkIeTcEXz2+bfEeDjCSZ6b/wIhdl5mdihR4SUjKAIraj+
	gd3lJE4omGXVyQHiTpic34kKuqK30kRG3lyjNHj7H/7tlKLaWJX6S69mX9TA/hJyZ7op5oaDBtAzG
	T5hZurA64ozrijDZjPcu4IgbYdzZTRByiXOm4fmjI9J2IWRokaeiosDXrDL96cz63qeCNU1g/2uTY
	9NC+Yg8g==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1w2X0H-0030D2-5o; Tue, 17 Mar 2026 16:10:44 +0000
From: Breno Leitao <leitao@debian.org>
Date: Tue, 17 Mar 2026 08:33:58 -0700
Subject: [PATCH v7 3/4] mm: huge_memory: refactor enabled_store() with
 set_global_enabled_mode()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-thp_logs-v7-3-31eb98fa5a8b@debian.org>
References: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
In-Reply-To: <20260317-thp_logs-v7-0-31eb98fa5a8b@debian.org>
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
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
 Wei Yang <richard.weiyang@gmail.com>, Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=3635; i=leitao@debian.org;
 h=from:subject:message-id; bh=Ad7z3HJ2if1PIQldhqb2c7q3YI4ATsbh//vY1VYZr6E=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpuXzrh2HFlAWxcSLtzduwx9EkBuYGgsrwmns4q
 oXbojSC7mOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCabl86wAKCRA1o5Of/Hh3
 bSsUD/9c8yfvdymyg6ulRdEROv/oa21LpucvoYvy6O/YIDoLmj+qopNzDSOp02FmGd6tqnefQBu
 7gvW8EUsTvl8mmbPVVksYhzTBpgoPCVTWEM9vDI4BO/WvacFguHItfQwHIzC10UnTZC94nCDN7Y
 iC0xLG9TX87kUuTvmVynlzH2txCAwd3n0747aJRq+aRcE/A7SoCeY6vnB7J3JlWwUQ23V7zDQ6f
 HnqRhKyj+7+bxfXOtve7WoPRkiBsUCaT4s0xdxHpbbFqiyt8Ac9D7uMGKXmVAd8L0dy2E8jqt7B
 8aE+5aPBG9TMHwz7pMq0yxVhjZ166QOvH/v9YCedMQ6F74mTr69uwwjd1E+V4bICpP6MWpCe791
 GAbQcH8hd8qSnpw07lT2P0kjJmVI1KXP9vbeL5cDLtV91BNnxXceAI0ou/gVu2JN4ktJBGBBHXJ
 7htObsRpRhXTjoO0cU18QBpa7qYdZ4kdPl75mSSSKHPUFMNHlaV66waCMHOKN2KSMSEXfOwrz8J
 cige+elKvcFgHiI2JoEBx7RxAREnhp0wjeTKGkLJGAVSiv9blZXMlYBBKfQVVuSfqr9e7mJwm+m
 2SqUwhoaZq32V4KTXt/ejQnhB5GDMRUJ+m6q3ct47Cc4+VZn7JBoGyPl/GYDi/8u17rOodLulvT
 DzUygzJ+iwNIZqA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AA11840017
X-Stat-Signature: 95n3yad3c4m5t6577yxkwdscanycytin
X-Rspam-User: 
X-HE-Tag: 1773763861-597640
X-HE-Meta: U2FsdGVkX18+m5gP+VFO5fnxVt00tpKuXsAut/J+rixtV1/ybvmH0FGxdjv5wNhNMLWWXeQOID19ff+xa6782tTJoRdZjGiHhlt4KwNGcTK//LObJhFwwhky18gMMpStRsnApNeha5G8gD8EdxV5bCuqrRcJ1+GP+HB4n8KZtPoC07WmJlsbTQupB1dkOah1txiB1KLvYgNDbrv4cGOfwqLfe+uVm4C+ryjnHAq06PBByQvYebYhhs0JH/KsdkE2AefHtrkJbDVM0OHA86ierZesQR10k42G5HeM7v/6BrzH58ZyxlGPlJ6gGgFgAB46vpbjfu/QrAdSGQfi+qn7nPJ5eRn9ZiBuibuQ+Wubyjxuwr/9TrmIN2A6YDiCPtS54UNNpm+BmNw+DmliCFgBak+15HMDvfDfNxFQl9BY8IcZchHfqefe1OfnmTsN2DdHN1nvtsMqD7PHAW5PQfI+FHDi5ciwJ7h4ulqagqd5qaRfLmm2qVSMDFiWTxJ1AGePtZknmxBdfhxkTVCQBB+QySUV3lyjSMbX8sKuKVC2qxTx8qkVND++N4OCTxw/mtBNUMsQFhPqBdx3hM2Iwsu6qcQcmfE52al5IxCVXBwhexk62Fq+R6q6+l8tz/yfRwiSFq7bycIVngKLLhlXORbo+2CR/e9f4bL9rpdk6nKxXWqdfKkXwKcpECPchbaihyHe75lVNBof7jSfFOqTjGW55hR6Is5+0zUSyEGb4Yhp/CDib7M/NLMM0HscpdiG+rb2Qh7PlJYC0Z5bf/KDm3xIBk76ScyZdFg4YJT/GrkxP+3B0OqENfSzcZUbUyltujNriGIv2X738d9KpCSy+Z8anRaST31QZduhXpC8ZKx4yUHLPpVo9s9inUJvK3gn2hTdLcLjoUfs03EncygNcTWvR+XGaHDgPb3Hbm6FfFXDD4uC2vxjXu/y62H3AiUyEromTDqqLZ+sH9RzM2VusKl
 RnlX2IUw
 j+3Csr2aL3I7V8rGWyzCuIragqmSMwiLFZib92PmNbrC0b0GgORtCmRsJUYs7nXAUM6Hux3yl8dhee3tkZv0WJZjwHf7HcinevBrTLVPsn/PB9NaPXvOB5y5+jvIpxKPtELapIcu55RTrW5GCoaoyLnsYlZOvjSUwGGfu6pVNPuegjvfT5COUDyrSfMivHtnlSbM8IO0WsnUSc/mlETudLTHeS/U2QzD6TO0U2PJOcvJKTpvDK1ZdFEUMpU8jESfhVfKKvZW1q9EBaJFYjcH5tEMEi6QHUUp488b1rwtViBo3zCkHy6tPY8o9skUVpYLquU/17g6TfsaKJ8zhPF7d8RtL8GLdRzja0HivR/ONzv1aS9IPIItRqcYu+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Refactor enabled_store() to use a new set_global_enabled_mode() helper.
Introduce a separate enum global_enabled_mode and
global_enabled_mode_strings[], mirroring the anon_enabled_mode
pattern from the previous commit.

A separate enum is necessary because the global THP setting does
not support "inherit", only "always", "madvise", and "never".
Reusing anon_enabled_mode would leave a NULL gap in the string
array, causing sysfs_match_string() to stop early and fail to
match entries after the gap.

The helper uses the same loop pattern as set_anon_enabled_mode(),
iterating over an array of flag bit positions and using
test_and_set_bit()/test_and_clear_bit() to track whether the state
actually changed.

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 63 ++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 48 insertions(+), 15 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index f6af90e6cf05d..b95fde5843399 100644
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
+static bool set_global_enabled_mode(enum global_enabled_mode mode)
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
+	if (set_global_enabled_mode(mode)) {
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
2.52.0


