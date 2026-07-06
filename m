Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3910DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:26:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E28F66B00B6; Mon,  6 Jul 2026 14:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9636B00B8; Mon,  6 Jul 2026 14:26:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC92B6B00BA; Mon,  6 Jul 2026 14:26:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9D5E46B00B6
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:26:00 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 002E74010A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:59 +0000 (UTC)
X-FDA: 84959180880.15.95DDF5E
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 355394000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:58 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q5f/gXze";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3NPNLag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3NPNLag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FBu6OWNGSr5mgdn9UMYR8LBGlXLZ2UBs3XJNG6eWqvA=;
	b=KHl1+vaNNHk0ioy9JHbg98cbk+kEd55xRWSpFerFgbeo/ofC9S+YIPGimE77rp84vS57Jy
	gTKbPWVK5mP0eYUNzIAQSzXpK9XDaVBiJ7AihW7+ZEY9Dseq/EQZdXIqHbozgrooHT99zW
	YZ7X7QNfVcK8wak8iIS0curcdbkDepA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Q5f/gXze";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3NPNLag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=3NPNLag0KCKMDEKLVKHNEDSDWJRRJOH.FRPOLQXa-PPNYDFN.RUJ@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362358;
	b=SQVsa94p9k9eUr2DpWyJNpytXSMbf13y4L9hiHMuI/WzZeHPXfwwzs0hv31UHbYnRFYi/5
	PXo0KbecUWlYVDl8jx1Ovq87I/OIXiQA3pX2AdtE5bEHS5l29bqvyhRC9+QyjAayn2u5yu
	IsAnChIkCE1EoShn4oX16Vkz8OrU61U=
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-845bc2e658aso2926408b3a.3
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783362357; x=1783967157; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBu6OWNGSr5mgdn9UMYR8LBGlXLZ2UBs3XJNG6eWqvA=;
        b=Q5f/gXzeOBBdeMrswDZQ1rmS/LG4jvyD3vI/2hQdvT1BQUmcOmnB9BnJxX5jhhtMlE
         38kVu9xikohD7NGm8gY2zaLdKaS82lV+ZOhv05gTVCxuI6QtdeGZjxyNbUzKz7LX9sT3
         xho4/5mBvBw7le96Bx4a2q3GLisnOQp0Aqlu/HN4S6OzYSRXPDizX534pxff4irMY9FA
         C7JB7zETfAOLLzlNcZPgZRSc+pugD3ylMGtoOAVXT/kbnPLBt9ZvFqYDwpTnYGdsyvIx
         6mhYVxzvII9ThFg/yqEDFjD7ZnSD/Md5ZtHT9Hy7dCfy0TRTBVluuL6E1Xd1jVdv5Z3k
         qaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362357; x=1783967157;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBu6OWNGSr5mgdn9UMYR8LBGlXLZ2UBs3XJNG6eWqvA=;
        b=U5uZUzFf/voqUVuFCs44dFHkcsqSQFVbEIBy5xIpmXrt/0bRx5Z1rrWq1+zqID4wNt
         fov2PBjCaxfNf8NhfitPr5QKfWIywaSolBLYsVOQjW9z0THgyxRzehqhrevw5784OtxC
         6Zc9ZQOg9yOasfmXW7ZZkKJmPT4ic9tK/WCITCzsDI7JM7MdxCPbM9WCaG97lqgncT+S
         3uN9GPvyrkAH1Bo6n51HZt8jDXhp96hreIisqr3rPhsiOnztY7kvKJIsMP2O5cJ51tds
         CF1MOPVzCHOz2Yb+7br+eiFKZNXtf4Fxi+M8LoJz5pGi1Hd87qlCUctH8TgJVqxniHBW
         +opg==
X-Forwarded-Encrypted: i=1; AHgh+Rqnq0u5K1x6kV2oVz17mfAFXxc2R+xVpFhSRKHDTZEMTrzlUATWqsvhju/PUkoDFrOyI6FM7jVjPQ==@kvack.org
X-Gm-Message-State: AOJu0Yyffo7DNdZU37A5btD29EUQoLopR208BTKHFtLcHsYed9f9o+Fu
	vlblvf9Be87pM/nv1Mg/L3oNq3C4u+tH6ZS1pZ4Tv1ECf9h64ixyFN/tuFJapxVXqusNvO7TwVs
	UU1zh0FDhhRWsE12PyT6L4BxfQgWSJKvUWQ==
X-Received: from dlbdm1.prod.google.com ([2002:a05:7022:6b81:b0:13b:4811:2202])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:3294:b0:3bf:866b:b74a with SMTP id adf61e73a8af0-3c08ee78ab3mr2178669637.35.1783362356934;
 Mon, 06 Jul 2026 11:25:56 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:25:46 +0000
In-Reply-To: <cover.1783361692.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <57a5d2340d8c021715e845b8b2f47f1120672091.1783361692.git.abhishekbapat@google.com>
Subject: [PATCH v7 3/6] alloc_tag: add size-based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 355394000A
X-Stat-Signature: 4ktwuu7ffpwoji6mp1qkj8mount14gif
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783362358-397250
X-HE-Meta: U2FsdGVkX1+03mQfvX+ecNUUhzdtrP8StN7sTSykRFuIluxObY894/TvDXE3SPy3nQ7dzL2gRzALcc4r2OxsAik6aYQ+E7ktDkSHrZ6Fftrp+aAfJSjM1N8c1IO+0GuA/xpQ61f1K8ijtjQy3sFeDRIS8L7Oev0SgZZGQJCzOvMs9XPMVKJLwWGIdA49jFbo3zxsUNzeMzzGiHli6wCBTDzG8liZvQi2tcphaRqh5sKA2dzrgzM+RqKM/2sgnnZgtz/5EW2Hy4ul6YkJ/8IY8qXdp+9AoW5nH/OnQHNCbY0j6bGLVhvBopRrWQA0XFThxC9ShAUJGf5PU4wbdjVe28Nd5SiHNOzDqp2mb94dFttFqFU2iuT0dFDdcVVrs2Thi+y226V6gl+an3skecS+LQEiUUMMtD8T/4kI5Lphzx0FcwV5WQEKNGxSqvhgjPDw/NneD7KpaByouRlOC4NHxZEBSbmOLChfZ0LgeyqHeuZciNkL22igCmM33eTSsVoYN6d6QjFmsFNiJphGQu/1r153U9cKF7hWtJR9c2kdqlCaPKlrHwvIwg7o/bU27DdmYSzYFvErreOMUKv2oob/pJRf9C15GxzTkaya1Pk1ZgexTnDOv5XIeLbvthqQxKfUIW+HWVcB8UTeL02sBGnMgdoK8ICi6S3jGn5jusai7WN90n4nHW08HbE2XVAZPxjPnxoX9VLCVa6WKJu9UyCM6gMw2yBwboZhMYh/hW6D2C2/ygfqgYuVum4ANt6vdQ9NxD27vtPh5f/P886gpuONku9rKhmEglNgz6EypAxlS/0wJYLOk15pdDz2ImLDK60nK/7RhOUTPuYynzPZwbfFFzoz17Fyur68zyCJ/EsA2x+pW6m2uCb6yuD4PlbivZMI7dy7Rz16bD11RL+pRZU16Z6EFOYfyWXHEB5uOc6+Puke9PrUsECda8nvt8WHV18bA5aRTKXkloHvLiERg/1
 JsALo21+
 Nz0Mw6+d2z5FxyP6wUat3Dsk78QvNBOwrzS9+rQGEk+d9XEDKYkbr4cuip9OQcrA0IJDCG/PNiMk/t+8FGE29lpOeaP/iahMsQD+w2X5UGqukol9JkoIYdG3+8tM7/yvOG0+1Fc23+qjjGBb3lgwNzJaULv2E0RIvaF+mbiWd2R2I/lj2Ch3orrne+synlXX6Yse6EOOWn1ZIZkqKcMA83IYCmGGCcHsHkw7nwBV59lZ1d8j7TBXKehYp1Y6O2zdHhlwUMRf85bmjpWyRScT/X/40APdhCyXk6KiVo8b66cWSsQScG/WKhD9mD9XC14ccKbu7F4Ca/osTcERa4d8xkhhftHbqUMoVwny6SVL7b9065fWkj2EzSg0GXN4ixxqI3EiPX2iWCJ871vUrT7rBeS2gfVaDeeVjc9uy5ER1lkT83WiCY5HNYMsHB5q9Rav8epI8k1GTKuYm6pWztEtER2hi1h6YMYBw5CSrUzOVsWTtBNYeQeDyTfu4kZq8/hQfqaaAiu9sezARt7z2IkpXTwF376f5zEunCNKMLVB9fMUOuKUUtmbFUL7GzivqsXdAp44PmgRC40NLJiKE6+5JEdp3XTlQj7AXluL52bItOLXfEIILHrj9urLURzZocYqYvyqw+0fZ5o28fnQmn7438I5DplDb0P5DOhebfcSvM9+o0+0g8ft0VQQV0LA6U1Pr+vtjsM1WfJvUq+k=
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
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 include/uapi/linux/alloc_tag.h |  8 ++++-
 mm/alloc_tag.c                 | 64 +++++++++++++++++++++++++++-------
 2 files changed, 58 insertions(+), 14 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 13e9b5916bf5..0de5fc180790 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -50,13 +50,17 @@ enum {
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
@@ -64,6 +68,8 @@ enum {
 struct allocinfo_filter {
 	__u64 mask; /* bitmask of the filter fields used */
 	struct allocinfo_tag fields;
+	__u64 min_size;
+	__u64 max_size;
 };
 
 struct allocinfo_get_at {
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index f00d731b81cf..ad33d63ef7b4 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -198,16 +198,20 @@ static int allocinfo_cmp_str(const char *str, const char *template)
 	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
 }
 
+/* Fetch the per-CPU counters */
+static inline struct alloc_tag_counters allocinfo_prefetch_counters(struct codetag *ct)
+{
+	return alloc_tag_read(ct_to_alloc_tag(ct));
+}
+
 /*
  * Populates the UAPI allocinfo_tag_data structure with active runtime
  * profiling counters extracted from the given kernel codetag.
  */
 static void allocinfo_to_params(struct codetag *ct,
-				struct allocinfo_tag_data *data)
+				struct allocinfo_tag_data *data,
+				struct alloc_tag_counters *counters)
 {
-	struct alloc_tag *tag = ct_to_alloc_tag(ct);
-	struct alloc_tag_counters counter = alloc_tag_read(tag);
-
 	if (ct->modname)
 		allocinfo_copy_str(data->tag.modname, ct->modname);
 	else
@@ -215,9 +219,9 @@ static void allocinfo_to_params(struct codetag *ct,
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
 
 /*
@@ -241,7 +245,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
  * Verifies whether a given codetag satisfies the active filtering criteria by
  * matching its characteristics against the specified filter.
  */
-static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
+			   struct alloc_tag_counters *counters,
+			   bool *fetched_counters)
 {
 	if (!filter || !filter->mask)
 		return true;
@@ -268,6 +274,19 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
+		if (!*fetched_counters) {
+			*counters = allocinfo_prefetch_counters(ct);
+			*fetched_counters = true;
+		}
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
 
@@ -281,6 +300,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_get_at params = {0};
 	__u64 skip_count;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
@@ -288,6 +309,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
 		return -EINVAL;
 
+	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    params.filter.min_size > params.filter.max_size)
+		return -EINVAL;
+
 	priv = m->private;
 
 	mutex_lock(&priv->ioctl_lock);
@@ -311,7 +337,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	ct = codetag_next_ct(&priv->ioctl_iter);
 
 	while (ct) {
-		if (matches_filter(ct, &priv->filter)) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters)) {
 			if (skip_count == 0)
 				break;
 			skip_count--;
@@ -320,7 +347,9 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	}
 
 	if (ct) {
-		allocinfo_to_params(ct, &params.data);
+		if (!fetched_counters)
+			counters = allocinfo_prefetch_counters(ct);
+		allocinfo_to_params(ct, &params.data, &counters);
 		priv->positioned = true;
 	}
 
@@ -346,6 +375,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_tag_data params;
 	int ret = 0;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	memset(&params, 0, sizeof(params));
 	priv = m->private;
@@ -359,11 +390,18 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
-	while (ct && !matches_filter(ct, &priv->filter))
+	while (ct) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters))
+			break;
 		ct = codetag_next_ct(&priv->ioctl_iter);
-	if (ct)
-		allocinfo_to_params(ct, &params);
+	}
 
+	if (ct) {
+		if (!fetched_counters)
+			counters = allocinfo_prefetch_counters(ct);
+		allocinfo_to_params(ct, &params, &counters);
+	}
 	if (!ct) {
 		priv->positioned = false;
 		ret = -ENOENT;
-- 
2.55.0.rc2.803.g1fd1e6609c-goog


