Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F5BDC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 21:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0431D6B00A7; Mon, 21 Sep 2026 17:27:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0E926B00A9; Mon, 21 Sep 2026 17:27:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFC6C6B00AA; Mon, 21 Sep 2026 17:27:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AA53B6B00A7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:27:01 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37DB61602E9
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:27:01 +0000 (UTC)
X-FDA: 85239054642.21.2AC1306
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by imf17.hostedemail.com (Postfix) with ESMTP id 7A63140007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 21:26:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sExhXrFO;
	spf=pass (imf17.hostedemail.com: domain of 3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790026019;
	b=tGscLuhiV9pC1klU3g7uplyG6G/BJ3IJMX+TKK16iyKqvlVUTBO/m2ic5hGVvZULiz+DOD
	ZNfC3Duk8epv42MwzT3tN+yfgLZvuCaSRYkkTGUfvDGHfxw86oTLfqBPZf21FWJx4WNG5K
	FzesI0l3odKj3/E6Bntf0HhYIaByC4k=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=sExhXrFO;
	spf=pass (imf17.hostedemail.com: domain of 3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com designates 209.85.214.199 as permitted sender) smtp.mailfrom=3IqGxag0KCIclmst3spvml0l4rzzrwp.nzxwty58-xxv6lnv.z2r@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790026019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thyHfYtRbZkf/h8UY4YJlFOO7BMX5P6p7QG3tm7dEMQ=;
	b=BQ2y8EaznErFyVg6vS28YLPWknXGdx9zQvCL7Lb4/LGKrmuUB60y45vqAJ3QNOdxYc87Ys
	UdQldVgHuj/DswokaFcm7tRVws/utDWEW1KYN21RjNOzT/U46F6tNlijTaiJM2BJVi7c8o
	nCKSmO4soBRr9UidcEKm3wM60D3GdpI=
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2d9336581a2so59801135ad.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 14:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790026018; x=1790630818; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=thyHfYtRbZkf/h8UY4YJlFOO7BMX5P6p7QG3tm7dEMQ=;
        b=sExhXrFOi0bFB2SbSEJVWafMbFcOTOFaUoByVXErlBYw69jzgunR7ZPRCWu5kkjzBy
         EFbEykFrhOwMPR7+JFsAv64u+vBslIoRzSWN54MbVdI2ni32G22fUkFYy+UGAj1pjnDb
         DWdm5XBZ+MfhF2NnQIaAMR+gF5rLyW0/ArflPBuOdKn5pt44RpMzW/G0hyGEaAxm8Nzb
         LQkIvbFzIAOccu8dkhpbsrNPseBFMiehXwMepqcwuaXahyFJNIVMkBx5VhgSY+sUAfDH
         LsNE2YG19PWNL0EgQBERwuC9Q7UsvyI0M/BJIHBJFacWR4ZBqmRg2bSUxPlr/VP+Tfnh
         egRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790026018; x=1790630818;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=thyHfYtRbZkf/h8UY4YJlFOO7BMX5P6p7QG3tm7dEMQ=;
        b=UQRQMHKP0y5ZviSc6nEFfaQSIYVeDt0TsLfjbiYpnt5ENtPyD4khagWCWLglq0nWbV
         5t/qcAQVF3yV9xbN2L21cQV+IYJl75febVibMSGxO2iUdnBaxRFm0VoTQyWkkfkkekSb
         jwgCGLz0br2+/bEqQWJBNrR9oYU89PEQFp0GvZvO+fPS/0kYpVhm9fv+thHa1OCas7TW
         y2IvQ55QDZ9J7t1WDs2RVzcNM/pukw/PhBGwkinOGxBM6ML70An30r6HCTXBTzKRzcPL
         U8501/eqFD62aYsrOjvhWVxhPhlVrDHfwTwWtiykjpPIgd4IKCnQzISIvAKS1qWlxbkY
         +NOw==
X-Forwarded-Encrypted: i=1; AKwUvBxZUQMorT2md3VYwXz3mQAiiDaxCcLu5tEuWb4Ts5TU/DjSlInoXbawai6Do3MmF1DZAwWHcbOQWw==@kvack.org
X-Gm-Message-State: AFuF++lTXOKqsul+OkZ7BPERt2ayVv7QUIXTcf2LToGT8IWp881ZAqaH
	7GcwvTPEZne0tIMUC9zCBfEG2MIQ/GT5B5NzGLheoYolGyaUSvK08LLYXWEEBbQrG+9YCkPpmIZ
	lSqu1C2ls3S6WmnmfIo16kNXmsLDlFx8iLg==
X-Received: from dybsr41.prod.google.com ([2002:a05:7301:71a9:b0:339:7118:d1b6])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:234d:b0:2d6:e074:9cad with SMTP id d9443c01a7336-2ddb1acad2dmr184944625ad.6.1790026018153;
 Mon, 21 Sep 2026 14:26:58 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:26:40 +0000
In-Reply-To: <cover.1790025465.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1790025465.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.1082.g2b9226bbc0-goog
Message-ID: <c429b37092a4cb33535965163072a63adf57d8e9.1790025465.git.abhishekbapat@google.com>
Subject: [PATCH 3/4] alloc_tag: extend allocinfo_filter to support tracing queries
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	Shuah Khan <shuah@kernel.org>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7A63140007
X-Stat-Signature: nuhhd5zpeq4k1o6sdc665jww1jwyhd43
X-HE-Tag: 1790026019-734681
X-HE-Meta: U2FsdGVkX1+7z0dGxybl7nyuux6avZw3FQt0a30NKIneYlwp9DmtcWukRB0dIMBPSvUcoK2IE5txRPVTXwPofgs45ThcoiL6WIjzI/3yFQJQbmTxHoIfI9GgyzvKn1Lv3EAIrPQ7oemodRouaGo/0pdHJ+CStQRJupH3ZsS/o3KzKqoMnHdtO0xnamjD2Z2tor8e3lBV48UlFplcQ4Yd+1EPpcEuslBiBKLh5Eg8PgcXZVoeruaqi/9k+RueHHTD1PpKrqLEoZ6k7yDkOBAWmvqlImVMk77AFn36qzeLHROK91rsA9ra36eYmzOdqd+DQP2Vg/d7WYKldaoyS4wHXOUQWNsoFH+Xj5XfUGCKJVPzidnJ6necjCRag6tx4z2M8S1qiYth+PSHlKh7udg2Vt7EIUrptiFXjeCUKeFEYUICWKON4mkUs4UwzUEqfrWiT2S6mm6VOQyvjCe/q4xZ9Av+gjqVsYqaaDGfBfjtPXcf8ldXqgRQL+7iLXzwBCkcVjpGkE2BGxGWkhIxxG/KorvUejBpI5gmc59z6R8+Q4bXapzuuQRKQao+ogtyj/OqQHvMsqeZAQQJsWYWaYNdJgmXibaSROn1YyLSVzQg2T6gtdfrJR6pwz9TQhRb4tSf7aOjB1LYHYWTnJW0hRO16sRlJ0GrBj4iQ/fHn0bPF0b5GgtBoNUt1jlUS8R9AP76FkovgWwuBaTccIcuSJwWK9Nv/I1Pf7u/XXmSKvAZF1JlK99S8EF4bzNs9BMaZMOJRz7rHRhe06VH7VzEdDTuzSWh1XUGpFDwUc3O9fw8WVC1ihxa6LNdYIqwYVC0bCqJaOStJbuICRGVXSKAUVhMONqDy/NDdxD+RJNE3XRJ1UDeusXU0JsJaLg/XlF97FF6H/x7KN2Q5u15vlSDZfnKHBIwZS1tdGA04/TCnYPXQPazZN3QHz5ixO3JoJLSK2bXZs6opi1AgLeBPoxNhZc
 cnkYqmzr
 spgkawDWBMXmPTryUpYBHmpqjVPkl7wsA02uGSvK0GUl3akzofSEtcMy87nr7GGK87rc9Iqye4am0FM6Bsl0sk60YeV2i/PfN872lYKufYegFtnfzU65+4FHFkiXH9+7Af1xZ8wQIQO2fRznm1va5MLO0daHEQDOT2ry1upcf1V5UFAkErQcUCgvBVXxI/mqXf6o9FoR2HfIqWXW/Ts368oBQZFy5Ab2+8fjNS3PuNbo2j2jvTceLDUAeJI0QwoZWVQVupUo4FyrAl9FUAx8+VypBwCEpIbQhac4CtqwdL40WMvvQfwAZu7h+byd+/bz7p9geAlh44KYqF2MESJShGu5bDkwCPF4nTrR1d6TlTjpzU1tm4E3Qdz616AwzA/sf3bn0tyEi0UMVJotr3qNol6kR3rrBEkr8ALgWULIDLYKcmkfp29DQ0SQ3erIZa2twUE+Budy17jBMfBYJ9lvEkKl+mEtMszn1P7BtxD+Pwt0vu9WZM22x+f8Gbx0rFiUkv2ZV+ukGpO4m+k6fdj3rLg9ulV7H0WyeLvT8uEtz9Mw+qYU67wVA01Xcv6qouBzzKQMbCXdcGA6PJvDQLbOIt6LTFWBaL/HnxbvrJIxvES16+jbQYbxu+V2MT7+4Wa7nR2OJDT5oczfUkb62e8B35G9tVxMbgg2yEThe6WP1b8o4l/ljmpkjh+IDIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their trace state.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h | 8 ++++++--
 mm/alloc_tag.c                 | 8 ++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 069ab8341e87..e65c32afceee 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -38,7 +38,8 @@ struct allocinfo_counter {
 	__u64 bytes;
 	__u64 calls;
 	__u8 accurate;
-	__u8 pad[7];
+	__u8 trace_on;
+	__u8 pad[6];
 } __attribute__((aligned(8)));
 
 struct allocinfo_tag_data {
@@ -54,7 +55,8 @@ enum {
 	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
+	ALLOCINFO_FILTER_TRACE_ON,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_TRACE_ON
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
@@ -64,6 +66,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
+#define ALLOCINFO_FILTER_MASK_TRACE_ON		(1 << ALLOCINFO_FILTER_TRACE_ON)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
@@ -75,6 +78,7 @@ struct allocinfo_filter {
 	__u64 max_size;
 	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
 	__u64 inaccurate;
+	__u64 tracing;
 };
 
 struct allocinfo_get_at {
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index fb179321a2a1..50632b627d92 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -251,6 +251,7 @@ static void allocinfo_to_params(struct codetag *ct,
 	data->counter.bytes = counters->bytes;
 	data->counter.calls = counters->calls;
 	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
+	data->counter.trace_on = alloc_tag_is_traced(ct_to_alloc_tag(ct));
 }
 
 /*
@@ -324,6 +325,13 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			return false;
 	}
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
+		bool tracing = alloc_tag_is_traced(ct_to_alloc_tag(ct));
+
+		if (tracing != !!(filter->tracing))
+			return false;
+	}
+
 	return true;
 }
 
-- 
2.55.0.1082.g2b9226bbc0-goog


