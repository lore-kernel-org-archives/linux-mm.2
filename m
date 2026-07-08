Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5708AC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3BE96B0092; Wed,  8 Jul 2026 14:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEBDF6B0093; Wed,  8 Jul 2026 14:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8E1B6B0095; Wed,  8 Jul 2026 14:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 894426B0092
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DD8E440280
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:35 +0000 (UTC)
X-FDA: 84966376950.26.89424FE
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id F3FEE1C0018
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:33 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R5dbcz3S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3fJBOag0KCDENOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3fJBOag0KCDENOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o22pL91tE+P4D0VLdFqeuEkk7oFP7QFbC5BsbPhxntE=;
	b=PLm4rgEwfv5t4vv2KaynVomEMIOlJxvGNKThQJvtyq+VGkyoMAPdZge+NEyAStNHW+7ttg
	U7C90l9pC2Z3TF/yVD/CoSLyy/fY1wAGAAv2ExP3jatCJ2U7TB9hc9pMu5eFmiZjs05UFB
	f9JjzrLtv7RJHsTWBSr/U9DKlUUw89M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=R5dbcz3S;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3fJBOag0KCDENOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3fJBOag0KCDENOUVfURXONcNgTbbTYR.PbZYVahk-ZZXiNPX.beT@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783533694;
	b=WwrPNuoZIuv7tGDW/pdDuQSOXc5ydiKygje/tSafeE+coUy2VmXx58aiB1gcz8DZSraWpl
	XNyAlmh7oTja8yvW21fS4JMyEGE6Ic/ZYchE2vuaxQfMo4rMiOQNSDdOf8S8Uozt09iDV/
	Az2x+BuWxaEmc5kWihV644IqhC9hsQk=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c889d1eebafso2019053a12.0
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:01:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783533693; x=1784138493; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o22pL91tE+P4D0VLdFqeuEkk7oFP7QFbC5BsbPhxntE=;
        b=R5dbcz3Sia+7kQ/JVz7IGEr6oNp9sB1bPVeFwHbWP5oKjem/VAMBJ085GawH89HEk7
         vC4a0YIArxFhNy6mDk62jpiLRRJA5ezfqlrggU+pvApYq8QrjfvbbVfabyCowO2OLaaf
         du95H1zE5q5rNZNezUW51KFfByhP1XWQV0tPtF//LwRFIOewXKuzruQdJSS/uZ3dYSM6
         ocB+ubjdXDl4oOv6pGXz144SxpeabKP4O/FQweJHNwjnHGW2jX/g99/YZoRAlQXvhaZQ
         9f0fA4Ot2TPUls18M4GspSolNG2Qo91jcvYC3dLJa8G8gms3NqPv79wNay14ujk9gp/X
         pICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533693; x=1784138493;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=o22pL91tE+P4D0VLdFqeuEkk7oFP7QFbC5BsbPhxntE=;
        b=UVoa5QAqeg/g2uTthr9F8sdlt8+KmqU4PsBj9SRQ3j3vxfnRjIrACWWCgej+rR1E3r
         fcUkUKXMgGhFW0YON4F1Pr5xg7fc7sZrWjPDvKDKV4lYD3jaLSFvJ5nyd/Q4YN8TjwUN
         tzQNTCCdJuiznG5K6RhThO/IchzFU9uugyOjAAco25nypits3Bktuj7Npg+bg8SDPf72
         AE3t2b4hVjV7I8gmraXjn4eq7+nCDWR2SxB0YUgS2mL4w73xBrHFskoLycaKRZSlU/xE
         HnQ1kakq4rThn0BGioDO1IZObSdnmmbn+De9r5W8g+8uZAQVec/G9dr6zJa2Tk+Tq1VE
         u/Kw==
X-Forwarded-Encrypted: i=1; AHgh+RoklrnNhFrPu7b5fO0bacTniMGb9DRSk5gg4U80owLPsFxNAAr/ePi3wYmewqXEGYnGqisrOWRk4g==@kvack.org
X-Gm-Message-State: AOJu0YwngzGbzLnz2ApC0MU9GRVc7DIlhpTuS59Y+IjbTSfn8LMwdKIC
	eyyjxP6CnkY+bHn+m47sR9LkNohb3/R6ybnKXLuzcvh90FLhIZ9knl1kt8kB/eMzw4DLtPED2PA
	dYxVf+uc4qcqZTQILyyNwojQ31GnlNF1LVA==
X-Received: from dlbcj33.prod.google.com ([2002:a05:7022:69a1:b0:139:d9c7:3cf4])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:c5a7:b0:3bf:6363:11ec with SMTP id adf61e73a8af0-3c0bd06fe47mr3841527637.34.1783533692710;
 Wed, 08 Jul 2026 11:01:32 -0700 (PDT)
Date: Wed,  8 Jul 2026 18:01:25 +0000
In-Reply-To: <cover.1783532853.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783532853.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <0a7653b70ae0d64e967fbea0e933bc35f8ac656e.1783532853.git.abhishekbapat@google.com>
Subject: [PATCH v8 3/6] alloc_tag: add size-based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F3FEE1C0018
X-Stat-Signature: y3z5theh8taqmo7afxq4d6b9efnd8co1
X-Rspam-User: 
X-HE-Tag: 1783533693-122494
X-HE-Meta: U2FsdGVkX1/FJ3FqEwYLSmPNTh43F4esynVrgeFOpOpp5/Ox8w139u2B1Dy+c8IpiQwzuKOPtCYU+GRMXcUyNMZActJrNBa2qV1CW0JJCALBmCxB0HO2GO6FrlEViJJ1yMKTVtonZoVHNID+I7Tq3UpK9378aWJzLPmoe4B1IWQ7nyjpxebNdp3IjFv9X6J9qCDxmR5HJk7YHRKcEX791psokFTWOUQcm7A8JZnalXy94Qk00N+3DxrhoR9Z/tmpD7jsUqYiBbd1B1prQGYAXdyWuKF8A+mMOPfA4FpYb9tdHb27dYKCE1rkxIGG2hml4cv8XQw+F1PjgEFaUFPMN0jSFoFcg21snku5IDEUIS1d/D3bZ4rrVUe6uWzDOeit0BqTjT1ZmCEqeLVWbW7UytWYL+mDjsBkl34lOUKRSv8UxRYsGMrmnQQkjWnrAJuZ0pu7kpuPahZyVQfF+ikxSLIrHJSJ8WZEldzronzCnPa5bg08Uo1THOPVtSSoH7VugzDltQDfUEZimLiDx6ga7RT5928qkENwt+pJcz+wT39ztzAJ90x5DiNNTl/4d02wb/Up+mlfG3tIqrk6XGQCXf48EWNgC+spYYPk1i3WuRdf/iv2OQe8WaSCTG6Mo+1zDkBPsCQRwb6q8SGuiGE68An6EZu6QGGo/dg73OV4L6Bc/NiCKBDxHVjq0ntks/7IebJTNiHzHuIly0KIC6KvhfBq5LnppO2ClqwF3jxBR8//THnkL+9eSRQVhliTMtgjuPmSQiZ3Z13jNXG0sqqzijZfTuuGKCL7+7Mh/g8uK7F+dmhT5vwpUVY5Ez5/YBpytQWGgBgz8lK3fv6gktGFPeOZS+Uv3QA44lk9OEheSX8noyLJ0e/PBQfaJWtbdtTZZloV8GeyNBM0VnpNzmS++qvfHDfJMM2SVINfRXhrxiGVTSeMnB+7aapIjYr8yS768bs584GYfDAf5RN/Q0I
 f51H1LWV
 DAz+ZDlJz8hp0LLcaH5dZcJKk3qPbEZJ2/jKnXzxFwm76q7nZzGpZgF0Kols8gauLbimUYaxdutzORZ3UWRve2qD0xj9DKbGD+rQCv77TSiBUQpZ+Tf1wB0SF6BPQM4XclQy89ac+QpxRY4G/CfRe6kDYKtD7EyqE1Xfj09CLKwNm80fnnIDuzrF4it1bbIhlS/TvVl8v7OH6bbNPGQgG6W0d40GV9xUTXeteUf6WOaiBjFX84LQB7SfZy6LW1+50XRt3zj8TRhiclOQhSk6ED79RkExwMVA3Q+USZWob8uvEOZQmZVikLCx4TQV0Se5ovztkmnEr0xqx1ktXkeBumxi0aqhV2V4nzeOUV0A7+eEs3p1stiier75sYfAO7QWDJLwhg4l8+0R6w07iznXXOh7zJ6HRuVDWowPNo1F6M2FCEnAxiUx4K+pWS5pSeGcfiWLyeL+Bcuu+2P91++7ddHrIW5EOFRwlvrkyNVGaOn6zUC+pAhsglohXgxA/jdbxNE83PYoTSmmxGnoNWc0XZrtqFaUOtxYN81JC6uYLByP7ImIp2ir+AI26FlsbH43qqfhYnADsGyRZS3gV8wjTqk2fL/402GWPY15LpevJQ/6ohdVwIt7lYBNxmIpQhEwKIsOwShRiK5jXWqy0oUtbfTfvDhO2/vdvOps2MBrO5HsEo8Lcc2gZiTf2j5ddBlv4F3YMu0bOkK/INSs=
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
index aa67c156bc4f..27aa47c4c1cc 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -201,16 +201,20 @@ static int allocinfo_cmp_str(const char *str, const char *template)
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
@@ -218,9 +222,9 @@ static void allocinfo_to_params(struct codetag *ct,
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
@@ -244,7 +248,9 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
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
@@ -271,6 +277,19 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
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
 
@@ -284,6 +303,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_get_at params = {0};
 	__u64 skip_count;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
@@ -291,6 +312,11 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
 		return -EINVAL;
 
+	if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZE) &&
+	    (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZE) &&
+	    params.filter.min_size > params.filter.max_size)
+		return -EINVAL;
+
 	priv = m->private;
 
 	mutex_lock(&priv->ioctl_lock);
@@ -314,7 +340,8 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	ct = codetag_next_ct(&priv->ioctl_iter);
 
 	while (ct) {
-		if (matches_filter(ct, &priv->filter)) {
+		fetched_counters = false;
+		if (matches_filter(ct, &priv->filter, &counters, &fetched_counters)) {
 			if (skip_count == 0)
 				break;
 			skip_count--;
@@ -323,7 +350,9 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 	}
 
 	if (ct) {
-		allocinfo_to_params(ct, &params.data);
+		if (!fetched_counters)
+			counters = allocinfo_prefetch_counters(ct);
+		allocinfo_to_params(ct, &params.data, &counters);
 		priv->positioned = true;
 	}
 
@@ -349,6 +378,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	struct codetag *ct;
 	struct allocinfo_tag_data params;
 	int ret = 0;
+	struct alloc_tag_counters counters;
+	bool fetched_counters;
 
 	memset(&params, 0, sizeof(params));
 	priv = m->private;
@@ -362,11 +393,18 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
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
2.55.0.795.g602f6c329a-goog


