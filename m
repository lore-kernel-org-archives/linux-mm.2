Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 229CFCD5BB4
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:45:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42C3D6B00B2; Fri, 22 May 2026 13:45:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BC636B00B5; Fri, 22 May 2026 13:45:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3036B00B8; Fri, 22 May 2026 13:45:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C3E6D6B00B2
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:45:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7A934C2979
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:52 +0000 (UTC)
X-FDA: 84795783744.01.CAD99AA
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id AD69340009
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PfKajD6X;
	spf=pass (imf11.hostedemail.com: domain of 3TZYQag0KCBQuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3TZYQag0KCBQuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471950;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m+ziR3ir5mA6/jcqBzHRUrW8UazgUIvdAYJekJ5g/uA=;
	b=SvsaUVctfF6ZJ9gCVqHSkvr4Qlql2POZRjXnHHFzFG2G0qph55wk3TuYCUTSWLiAiopN0+
	ZlNq9DMxnZqC3MQfPmtvOtNG6l75hUUwVOCbjKU31FeCeDuGc+ovVT/IieBy93ChNY985T
	Llzz89QDSlSuc7S4jdmqXcCPyyjbhmc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471950; a=rsa-sha256;
	cv=none;
	b=HkcNBs6V/iLigyOhV/TP3osMLcQ6zuqVvwtytAB+NFaVXnH7SkNeptcCI4EjQTb/2hwyMJ
	Btq3VzNYLD5PLR1ZaosFFb4lCORpwfOiSbkb9a2zVpKZs9NLjnycY5+w0fu1S+TAuD6zpz
	yrllr9Z9Tt7QwrCkDKe06nTSNSpqPZI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PfKajD6X;
	spf=pass (imf11.hostedemail.com: domain of 3TZYQag0KCBQuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3TZYQag0KCBQuv12C1y4vu9uD08805y.w86527EH-664Fuw4.8B0@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2eebb099efbso5529480eec.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779471949; x=1780076749; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=m+ziR3ir5mA6/jcqBzHRUrW8UazgUIvdAYJekJ5g/uA=;
        b=PfKajD6Xn4ZeGwMsqgCJNFpoM+s9uxdBVPAjGe7z4VpivjDq9BYBFFiFPoMC6XWjle
         hVeSOEs4dsJ5YPgp8pB4sjQd79fkZHxOIH3VfDcfIYohLmfEXiL9C4/dbLWAjhL+DPVK
         Cb0kt8uRxKVy1w6f0DJO/7H3EnI90lZ0aJMqRnwofw0TYK9At5G99TTHMZAJklayBjUC
         BWJMwVR8RHeGbe+D/pWJFTQ5YjS2NpKR3K43+MXZjPYNo0c5ubFDoy0bFcj5NpCsEZG7
         /iIF7+KGG4isABPUtmX0iS3scwEZNWfKedAGSJEsmXKvEWwWN0J4ttyOuKJiVUrBMcgd
         HzoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779471949; x=1780076749;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=m+ziR3ir5mA6/jcqBzHRUrW8UazgUIvdAYJekJ5g/uA=;
        b=I/mJZjsgaBO0urWbbblAFmJ6qfhGz42xSG0fxMjMuYYV8s/3NowQtgmylYfDxxE8xy
         mrunjFu1Ed5uMjzu1lSOpO42HDZgVSI4o576QJ0N1s0Pr1GwRt88q3C6jswG/YYMdXQJ
         kyEv0mLY6fsD35SxIrU1G24Kp+LLp7ibJd0ShZoEJ/phITche/3Wbb/DFTJ56NWPeC0p
         zsK2jlVzC2YkzbE9hCCycAh/JfiYTvK2YcfH/vJZvHaPAas8NgNQ2jF4iDD75t+SB+Ch
         JbR92C9R0CXF4lfEpqViqAoBOsbIU1EzJCWyjJAeYxLqlX/NrT5R2vzyjxMj9qKY7med
         jUfg==
X-Forwarded-Encrypted: i=1; AFNElJ9ydeKZXsh2FUFSZu3hhwrVVa6P0d+Ik8GuU7zq23vNTJwbvX1UBz2xg1fnoQNydYaLZ4D1ry8ggw==@kvack.org
X-Gm-Message-State: AOJu0YxIIG4bp2T5LmF4Tozyj4XQKIOm2gszVbvt6DzhlikZzVoFmf27
	V45HZVyl+sv74FcyY0Xs9o78N8s0Q9Bg+3n3jiRciIvjiq3i+/WHnsoAaKJzyzrVfyqxEGNQ2LT
	G7+2BAoa4/kqOD4JHK4aOJkmW5r8+lVt2eg==
X-Received: from dyox40.prod.google.com ([2002:a05:7300:7fa8:b0:303:9ed8:4d8a])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7301:6446:b0:2f2:8857:1804 with SMTP id 5a478bee46e88-3044905b3ecmr2504647eec.9.1779471949234;
 Fri, 22 May 2026 10:45:49 -0700 (PDT)
Date: Fri, 22 May 2026 17:45:35 +0000
In-Reply-To: <cover.1779471082.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <c4b425d1f9192caca3cad830f322aa048ed26d45.1779471082.git.abhishekbapat@google.com>
Subject: [PATCH v2 3/6] alloc_tag: add size-based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: AD69340009
X-Stat-Signature: a4m13ddnfhd5rme4sqycr5ocxo31hujs
X-Rspamd-Server: rspam06
X-HE-Tag: 1779471950-272565
X-HE-Meta: U2FsdGVkX18ddfrptyZwAITMQt00t7L8GR1P0ktK7y1GQvJr7VBeeWNuuEYIneCKtNF1f58NxCYHfxroMC4nUDb9M/j4ld310cl8ymTYRJhkt7l2fBiYw1aI1fw4CnADIXkg4V2HKHeaO972sVGHo+gNr4FttvqlOWudgwBmL6Kjb/XKgKrsLDgFLCJmPNvR8iebBnxXxIqIk1sN4bBQmny/BfGwWrv/r2OqksIs9hG3PA/5ZndP/NTDICLH8h1L2Bd2BKth0xZcSIGmKoyw3G1RfvZaXNLppzgC8LPSJ7Jke0TwDELPQVb6rnTvAGmD7k1Hq7glASgDSBnYWC3RljTp0RT35PSSfTAerxcJ3ZojpD9o3pk5RtRhyeebZIZenaRQSFooBrJpF3QgJLCSPpiMWNNTcKzDm9L2TcuGDy1mwDejjb5egyYqrFNb2q5L5FCpIyGJp8338kBTPcCctReddltCvUiPtTtTecjeE/HOkHf7wAz5rK+cugD+gVpOiKp1YJB1BDKuYnFzx1+DdOm3asgdqdMe3cMVHff2bRpi5E7ImCas1jUGl83lTTUGUZnxBaE0nOfHVAUTAVl8cXx0w4Wv45pd36f6eC8ItY0hCufQDrg9SwpdkgnX0gQ1LxiPupRrTZWscVQqT+6o1L+eSwWKr8DO/ZQPV/7ycFvvbEgPAWiE5/Rm6MtEYdQJaV5FxZS4bi8/vEH0lpjNw7M1ZDolUscVdHNdIBOlZLLRXwMXEXqg2yWl+3zXnUE62t7z9xpGRoyLnveYk0OJbp4ZOtx7yqC0GhGObo7CGBHJw4NWxFNWYKok7zOnWBh0/ZvqRf+X9jehtUge+KuSHM+Vpt7Y2ifZIhOtFqrvoOhP1b6q7k3561CQTR4vLo+LPhmUZcCcJ4ovsiM5sw7GaCG2R5nynpe9hMObkok6z6OTam/NxouFlfIKuWJG5NhypdyJOE/2jG6qr9ylrX0
 a3R+a4sD
 rWpmisLkxd8nTxshqNY+tnXwejfT5+C6n4yptPjfVkqVMiRs5cM6RfzKJEcetXa7exEjvtEFx7LAesK+PGfQTF19NLqUhv6OixxGMKlD33eAmMhHFZ+6SqgWtV6ryf1Ai+fdGzHFrP1R7LMGHebP7dDIuq8evqIiDFUx/DLFhSHOth+KKTnwIrLMHmjFqjC9f2tU5e+BB9eSpEDGmQiCJIZ5dzkFJWrsR3z5rShjNMvnnZTjO2ivOfvCXVJPvboFbJXADUTU3fkDHp2LNd5OjzmZ1RisAXq79wUUeBmr3CuERfz1oMmCwPseiNTDETxaqUL5hdmlJz+90FKZvFx3M7YPmTJifwPY/Tls34IxnDLN1awkYsb4wPDXMUd/ZsXWW/OtvSytZXuwxIAsG1Mg5n5vuQXuIERtvPWMcKZr3ynOeKS2tQOZIGIZYlfjrfSxzWvAFmBHTEaddz5R/Tb3oBOfrbjLNwsrsT8GMSKtNkdeFjDtUyWPloh7GW9FzkydWchjnUMKytPVE+ZcO6B4Hj7tGzwFSvDFWAWSQERF03Fs0keO8GZrX58un5M0ipfMOMyt1G/CerhRpEbF034nsohaVJ9U+aHKLpNOesKzQUfwUFVYurIhlGDAf5CPAOOfRo+DZSLCTbiIHC42EFtz5X1uwIHfxQxTXmHVD17tbif0FVBPLPma2dHYDtVBuh+DaQWVCM9hzHFzkAeuTaGfZKnEaebeHqfYutG+yJfovUPZA5+tyjp9Z9eCHhg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on the total number of bytes allocated [min_size, max_size]. The
size range is inclusive.

Filtering by size involves retrieving allocinfo per-CPU counters, which
is an expensive operation. Hence, the performance of size-based
filtering will be worse than other filters.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h |  8 +++-
 lib/alloc_tag.c                | 72 ++++++++++++++++++++++++++++------
 2 files changed, 68 insertions(+), 12 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 0cc9db5298c6..45f158bee0a6 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -39,13 +39,17 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
-	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
+	ALLOCINFO_FILTER_MIN_SIZE,
+	ALLOCINFO_FILTER_MAX_SIZE,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
 };
 
 #define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
+#define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
 #define ALLOCINFO_FILTER_MASKS \
 	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
@@ -53,6 +57,8 @@ enum {
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
 	struct allocinfo_tag fields;
+	__u64 min_size;
+	__u64 max_size;
 };
 
 struct allocinfo_get_at {
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index 56c394ef721f..6c8743eead2d 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -173,11 +173,21 @@ static int allocinfo_cmp_str(const char *str, const char *template)
 	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
 }
 
+static inline struct alloc_tag_counters allocinfo_prefetch_counters(struct codetag *ct)
+{
+	return alloc_tag_read(ct_to_alloc_tag(ct));
+}
+
 static void allocinfo_to_params(struct codetag *ct,
-				struct allocinfo_tag_data *data)
+				struct allocinfo_tag_data *data,
+				struct alloc_tag_counters *counters)
 {
-	struct alloc_tag *tag = ct_to_alloc_tag(ct);
-	struct alloc_tag_counters counter = alloc_tag_read(tag);
+	struct alloc_tag_counters local_counters;
+
+	if (!counters) {
+		local_counters = allocinfo_prefetch_counters(ct);
+		counters = &local_counters;
+	}
 
 	if (ct->modname)
 		allocinfo_copy_str(data->tag.modname, ct->modname);
@@ -186,9 +196,9 @@ static void allocinfo_to_params(struct codetag *ct,
 	allocinfo_copy_str(data->tag.function, ct->function);
 	allocinfo_copy_str(data->tag.filename, ct->filename);
 	data->tag.lineno = ct->lineno;
-	data->counter.bytes = counter.bytes;
-	data->counter.calls = counter.calls;
-	data->counter.accurate = !alloc_tag_is_inaccurate(tag);
+	data->counter.bytes = counters->bytes;
+	data->counter.calls = counters->calls;
+	data->counter.accurate = !alloc_tag_is_inaccurate(ct_to_alloc_tag(ct));
 }
 
 static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
@@ -204,7 +214,8 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
 	return 0;
 }
 
-static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
+			   struct alloc_tag_counters *counters)
 {
 	if (!filter || !filter->mask)
 		return true;
@@ -228,6 +239,17 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) ||
+	    (filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
+		/* We assume counters is not NULL here as per caller logic */
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+		    counters->bytes < filter->min_size)
+			return false;
+		if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+		    counters->bytes > filter->max_size)
+			return false;
+	}
+
 	return true;
 }
 
@@ -237,6 +259,9 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_get_at params = {0};
 	__u64 skip_count;
+	bool sizes_set;
+	struct alloc_tag_counters counters;
+	struct alloc_tag_counters *counters_ptr = NULL;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
@@ -244,9 +269,16 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
 		return -EINVAL;
 
+	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    params.filter.min_size > params.filter.max_size)
+		return -EINVAL;
+
 	priv = (struct allocinfo_private *)m->private;
 
 	skip_count = params.pos;
+	sizes_set = (params.filter.mask &
+		     (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE));
 
 	mutex_lock(&priv->ioctl_lock);
 	codetag_lock_module_list(alloc_tag_cttype, true);
@@ -261,7 +293,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	ct = codetag_next_ct(&priv->ioctl_iter);
 
 	while (ct) {
-		if (matches_filter(ct, &priv->filter)) {
+		if (sizes_set) {
+			counters = allocinfo_prefetch_counters(ct);
+			counters_ptr = &counters;
+		}
+		if (matches_filter(ct, &priv->filter, counters_ptr)) {
 			if (skip_count == 0)
 				break;
 			skip_count--;
@@ -270,7 +306,7 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	}
 
 	if (ct) {
-		allocinfo_to_params(ct, &params.data);
+		allocinfo_to_params(ct, &params.data, counters_ptr);
 		priv->positioned = true;
 	}
 
@@ -292,9 +328,15 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_tag_data params = {0};
 	int ret = 0;
+	bool sizes_set;
+	struct alloc_tag_counters counters;
+	struct alloc_tag_counters *counters_ptr = NULL;
 
 	priv = (struct allocinfo_private *)m->private;
 
+	sizes_set = (priv->filter.mask &
+		     (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE));
+
 	mutex_lock(&priv->ioctl_lock);
 	codetag_lock_module_list(alloc_tag_cttype, true);
 
@@ -304,10 +346,18 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
-	while (ct && !matches_filter(ct, &priv->filter))
+	while (ct) {
+		if (sizes_set) {
+			counters = allocinfo_prefetch_counters(ct);
+			counters_ptr = &counters;
+		}
+		if (matches_filter(ct, &priv->filter, counters_ptr))
+			break;
 		ct = codetag_next_ct(&priv->ioctl_iter);
+	}
+
 	if (ct)
-		allocinfo_to_params(ct, &params);
+		allocinfo_to_params(ct, &params, counters_ptr);
 
 	if (!ct) {
 		priv->positioned = false;
-- 
2.54.0.746.g67dd491aae-goog


