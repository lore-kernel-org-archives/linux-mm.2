Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D23CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:36:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA7C96B0092; Thu, 18 Jun 2026 13:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B31136B0093; Thu, 18 Jun 2026 13:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9ACF16B0095; Thu, 18 Jun 2026 13:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 69B846B0092
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:36:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E303F1A0208
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:44 +0000 (UTC)
X-FDA: 84893738328.18.D5A3BDC
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf22.hostedemail.com (Postfix) with ESMTP id 136D9C0014
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:42 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="L9gD/ozf";
	spf=pass (imf22.hostedemail.com: domain of 3qSw0ag0KCCwIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3qSw0ag0KCCwIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781804203;
	b=w1AEbPVZCHbCxj7cz5TaTKDXzlADEOc+zL1z4TSTXxQg+scL6uORoVrezCVUwZrWlSbzep
	v31/YSMcpCz0Zwtu4d3xYf7cAd6vQNIhP5Fz/tGi8Gk362vpDd2SVeddleFJ0knMYUzy7y
	7F8Vy1EQpFBfc4R/06fR45EOdfEJRg8=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="L9gD/ozf";
	spf=pass (imf22.hostedemail.com: domain of 3qSw0ag0KCCwIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3qSw0ag0KCCwIJPQaPMSJIXIbOWWOTM.KWUTQVcf-UUSdIKS.WZO@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781804203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kcggm+vLyoh+gfR/AuH54hFzP3M8T4keypwurXRVhSU=;
	b=3lDQ2IatJjOcRLxlMx/fCvHABpebGgAORbPv3f1dvZk+62L2rt1s9ZUmOWoFRhSNRZSUzW
	KtV2gW3r19prmvaVTf9pkVMQyohS6lbvdTXF3celICfFdyD3u4rZ1hwYWg9zIP5nIIElk8
	BSMghhFDluIv4FcZywH7BVYlUNNotQg=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-304f1820babso1568175eec.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:36:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781804202; x=1782409002; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Kcggm+vLyoh+gfR/AuH54hFzP3M8T4keypwurXRVhSU=;
        b=L9gD/ozf4MYsFYlSjpEYOpswKt1GfQruOFFsOZp0TQV5ekRv66UGK4EEpykcoPcmKO
         1fNkh0AThH0QN/dZ7oIk8Q52uuQbf7Urzl99tYmOoSbjjkwxU2hHHpVLEpKsE2VuSh1x
         ot5WHd5Es23t/jx009xjbflxniqY37pfv6URSGunl2M438KF+YwuYKiqGMK1Z41bGTVg
         5D/R/ZjAW4ch872R8nemp07JpvIxLfTdyTlAu2j8ST6bj0TTc4XMQpzggUy9WHGyzYMG
         9hGYpVknmx1vNpkyWYPdjz/nTmC8QWRo+y8GhV9FwQ+xveaa/2UC2Xgx03K3r1joh+Ia
         yMnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781804202; x=1782409002;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kcggm+vLyoh+gfR/AuH54hFzP3M8T4keypwurXRVhSU=;
        b=jdEjMZ6nAlzPlnicsbd1qwEDNc2FqkKl43/TYM4BbIOXecWgd72N/trTJhzJzFZqaq
         DcvAHmLupAHAUclBTQN5EoxvFx6mQ/6wTNR/zlTT/+AHGM2JRMlfUORL7OjHgMccHcHW
         E2LoVkScGlf6iuTc1Y+xvMmaSfqQBROtAu0D9A83QM2EhL8sIhHh/3arHRg3Mn+K9Uw8
         9OT/mE7wv+tuSks4xXvATzLBWGY7CO4f3YYLHVCDB5C0vYYvSB7FpUG/d2C21c4JUiPX
         0Qaevl2LD//BnrilFVFMmmd7ci4Gc3t05A3Kk50KNJcKQkNozXiEScBUKLS9m31VdEH9
         nD6w==
X-Forwarded-Encrypted: i=1; AFNElJ/thjPLMUOx9DFBOi+fX2wUrPnTiRsB6jcicTf50oyShYR2BQUWhVvnzfvpfLfe1PVXF1ojXXVsxA==@kvack.org
X-Gm-Message-State: AOJu0YzmK8fUJIkZJ+knkEIpsXYh10/A/W1MNXfUXiB9hjkheLMZ/6Z9
	QOd1rKQrYjFRDecmN4JVlxV3uGEud6Obqw7T4+FJ6cJ72YEzSkPvwXFkIaxz5VQS1T5n5j2c1mn
	jAkVpblGsIiapNCEO2b3qZkw9/8Yzs+X6tA==
X-Received: from dydn14.prod.google.com ([2002:a05:7300:730e:b0:2f9:af7:5041])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:4306:b0:30b:f6cd:fdca with SMTP id 5a478bee46e88-30c06e0c62bmr222134eec.17.1781804201397;
 Thu, 18 Jun 2026 10:36:41 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:36:32 +0000
In-Reply-To: <cover.1781803482.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <6944ab65167d8884ce0d856184730d06ead68cb5.1781803482.git.abhishekbapat@google.com>
Subject: [PATCH v6 3/6] alloc_tag: add size-based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 136D9C0014
X-Stat-Signature: 4aw8ubih7o1jqwa6ujdj969bi5kx4y1f
X-HE-Tag: 1781804202-547764
X-HE-Meta: U2FsdGVkX1/v5o6Tvq+PR5irIqYRGGHU6qaPH1rsGpz7RbTp01OdD7/BkA1QrxF1j/hDeFSc/u9kuCTUI/xBbB/1nU4fWoWlyZ0k3R2H3MTR9o+Q5Aerj70aR6DyCkKK11X2binVyKGEPBUJqBdM+teQdMYdob1ZJ1aB1Ez5hf6ibGw403dq0JWK+srmIBC0081sqdd7XouDr7qtuZnYwpyNIKu+AnqWY5NZjjpatlQi/YX9CE4Dxa+hhs0DztjVaNEtXw+IylISpo1ST030Ec9vMTfR+UpeKeNl68CJgxfme5KUUFnqB5c85KA+qndFVjRiWuf4hnjPoUM7UWG/MTHQxS93gEk0zJWopmBs5SZZjwYKGb2jUm4biWoJ8NRpHQFBXLbJBaAj9JpbfNr3gkvJUXpTKjQoyTwV6lPVLGozAYi+ZT3AgY4rc+pjmqqkqHQ6i9suUVaPmE8frRaAhJEAUi0gGO2tjLbU8qwXHAvYiLNEq/k5S4uULiCexwOkH/x0dJM3c2IVbu5Mdaqp3ZqFD/r/4hFVDdbJ0v4BdW5j11nlQrIdskzq17ulsGKIpoBUtEvzP6OXHBbKJ93qgnS/qmsdzqT3b0ATbu3nzdxUXgwAgeZz+L+78H/6QQCyKEiVa7x923mWzZzhV/FWe0/L9hyohOtrNXfgeqdT04t/oOqfCdnFTXv1BVIcS641ZEDbqwOdlQjjEBpZzOD0ojnfK0cHzJE5xz8X330WYCTFfq1Yul9WI0meRdZDmaOr76i+O0OPkEKx4+/3Oq5U/JKRw/C9OKe+4wzqs89QGd+CssXpYmKSg3LVdc//4+rV5LBo2bJeLTR79Il2lH1FnnC9vaFPFLrDPevkVe7TZEQj8is2YPTX1rgQkCcPMyYI54MDrdRFFleng3ehf+lyx7byFjHieJAgoWVJoe3aiSGkZO4OLvrVm7yuSTcMdiy/65iZUQ/48znREq362SC
 zYm5GONS
 C333g0amy8q07rmDbn9RtNesQ2bMZ+INw/wD5RcP35k/xBUo5Edp8c2HgNKkApkzqHMDjWetVDgz/98M5SXIuLmMZa6XGWNSlLTmIWLVvB95vpsmiHFXfKmCR6tjGzpn877eGiVGhXisudBS3r/XUsPYYNORzW+yYJxYIMPH9WtrarTe0dBmN/wcsRJb7rO+UUVw2Sg5wv/FsKb0PmDBFS5SKHnj477vkMRSG1LY3e88CgTWb+2R9jkb49ijUSOU6d1IeHeYObUK/IW1nxA9EzpS+NAKG/hKODi2pluTdYKFIC/Z6FjJmfW/aQWzlUZHamT/LynQr6euY9Qb8twV3Fq2NiUtVC7EHk+WxoBEmrPBcaPTVtanBg2qNXFi33pZSSzKNZB/iMBYkL/OXr9/ZkDoOM7hBAfHTLFde/itSFnYM/l1qR+35IMh81Su7tM00BG6mOnDS7vf0JMJmKAfOL4rz5YGIn8ktGJhuXpp4TNuexcpPyj4AYwLwhjs+ShF2ATO6XGGbkDhi26ktUyPnzoGlP6G7F9kxEGurAc0TfjWrh4Il2ev2audgz3h56d5XxWv0J41wk3Q1uSihj9OyuBwpXxI/vvLyBZrRL5uIN6tRuKkPj9AUxKYu6uKGcKI59sB3VWkFURgkTnFfSNXlWAJZ722G/UB8j1Oq8lEgsvRwmGE=
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
---
 include/uapi/linux/alloc_tag.h |  8 ++++-
 lib/alloc_tag.c                | 64 +++++++++++++++++++++++++++-------
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
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index f00d731b81cf..ad33d63ef7b4 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
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
2.55.0.rc0.786.g65d90a0328-goog


