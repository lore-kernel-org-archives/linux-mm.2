Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 433F5CD8CAD
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 00:13:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A26F76B009B; Tue,  9 Jun 2026 20:13:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 913D46B009D; Tue,  9 Jun 2026 20:13:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DBB76B009E; Tue,  9 Jun 2026 20:13:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AC006B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 20:13:14 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1A70B1207ED
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:14 +0000 (UTC)
X-FDA: 84862078308.25.90622BA
Received: from mail-dl1-f74.google.com (mail-dl1-f74.google.com [74.125.82.74])
	by imf03.hostedemail.com (Postfix) with ESMTP id 46D1B2000A
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 00:13:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K4dvB9HL;
	spf=pass (imf03.hostedemail.com: domain of 3Fqwoag0KCGkHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3Fqwoag0KCGkHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781050392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GuiL1uopUb0V1ZSKvFrHplWv7LS00WDxcZQ+1Oh0CoI=;
	b=canh84JF55+NVTQ3P6KdsJhi58IhTbxaOQszvxrUsJokun9MpbvuXoruCeWliMN2aQ7QHR
	N2cOxnFVxYcv2GzqXoX7U5oySsiNTPPmfD5NEQK6TB/cm2gRRyvqt4RrYKe5xzVNp3BhkP
	W9Xl4vgOmJS11/2FleAiqJGDZD5n+es=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=K4dvB9HL;
	spf=pass (imf03.hostedemail.com: domain of 3Fqwoag0KCGkHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com designates 74.125.82.74 as permitted sender) smtp.mailfrom=3Fqwoag0KCGkHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781050392;
	b=hB27RDVuSj4IZBNonmwqHoenHPf8YeqspZgfn9XAQaDOX5fbtTgS7ZIrWuyd9j5NWCtM2f
	X30qoG9YIbLXabAYJL7RcfQQLycQ4ZxnE1nB7pbWjpLo1cBsD/dJ3Sd6TnpiFFoDxKYla/
	1vKZQsvFYNKsPkW5qYdDb0vTN70kOCA=
Received: by mail-dl1-f74.google.com with SMTP id a92af1059eb24-1383414cf84so1263624c88.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 17:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781050391; x=1781655191; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=GuiL1uopUb0V1ZSKvFrHplWv7LS00WDxcZQ+1Oh0CoI=;
        b=K4dvB9HLLIWWMmFGOxKop8LrrQDfTI0/NQtNU7EWowKFIiS+H37B8UMlHPaxbCt+HM
         kzORMmqNWwdbuvTfVOBWH5g8pfy3TUCWPmp/4w/mWNTT6MkuDr+KDootwArTFHgyxdXs
         al3ENPPYTAmZTuxF3Odl7VVzzfhQYJgIsoBl5uXhGWmrrQ8ATF731BK0drEHDt6tmqBS
         uKno+UX5ZaR97wrlwKziKNOKn6QJ7IiQ5Nev18ZV5zPt6yK3LAXGfF2W50dEGwhiaH3V
         qyTwTR6HGH9B03r8iubZ7rN8TVas9sL/ff3/AT0MjYXI9jC9/t9CirWPi/rPENS5Fm4P
         R9ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781050391; x=1781655191;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GuiL1uopUb0V1ZSKvFrHplWv7LS00WDxcZQ+1Oh0CoI=;
        b=Aske08BhweVEiA1A1m16d6zDq7B1eB6pqcjPRh/Qtkf6JTNH+JF0rbpayHs01JtwyG
         t0fQsUSJj850plAbquiSbqXEtuV4JokupTWovnBYOCFOV5ke4sw67OpZFhOrYtehxw7i
         10Bvdl8ma6I5zq/irVY6c2Lzg69FyZcAsCLR8CtPWX1vELyiHYrSTCtajOpdjNm4j8E4
         wBVJH5E88VqFkcbbwpQ2hybb/5uDkjPJXJLV1MW4LLTmqKy6plU4EKA4+D1/aG6CGQhh
         8gD///3n9RYjMFv14UDugX9+VxuuAdnI7T1ApM3Vvo4xMj+6ZT4pFcM5bGbEdUVHn6Y/
         9zQw==
X-Forwarded-Encrypted: i=1; AFNElJ/5+fi6jaQCqnE6YoE6wfjoGJ+qOkkuueB7MVHTPTnpp09Njk9ImXOrzX1/ZOaoO1fr3RuEwI6Wpw==@kvack.org
X-Gm-Message-State: AOJu0YzuaJSKzXxLB3Lq3lgYRMtefwYMoS0ArnK1EYb9aU1vcZidrumO
	EZ1uzEoOU0Bn3aazhmnPw1WI6+zBMiPeTefv98JF/B3+x5xjXISFVM7qUxpTtQ3xQbA5qSGo+az
	mHsmJ+Ke7ma6fy6lTPcp7OWG1GMcRCZ6miw==
X-Received: from dld33.prod.google.com ([2002:a05:7022:321:b0:138:281:799f])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7022:e01:b0:12d:de3f:f3e6 with SMTP id a92af1059eb24-1380675c41cmr10307493c88.38.1781050390727;
 Tue, 09 Jun 2026 17:13:10 -0700 (PDT)
Date: Wed, 10 Jun 2026 00:12:55 +0000
In-Reply-To: <cover.1781042698.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781042698.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1099.g489fc7bff1-goog
Message-ID: <8cd864b3bdbf89973e9a1fbd6e8ed1e9c08989b9.1781042698.git.abhishekbapat@google.com>
Subject: [PATCH v4 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 46D1B2000A
X-Stat-Signature: ja1nhxi73pui1km7t467mpxc1t8bcknz
X-Rspam-User: 
X-HE-Tag: 1781050392-95605
X-HE-Meta: U2FsdGVkX1970D3Poe+fiD+qtA2nisSL8V1W+ZF6zLTaYJ1L5LpBMK0hNOx1w8tcXc//v4E8gdJckE3RJbRhfgR7pSWgeUn14TfVzL0i3vTqrjQTWR53tGllDBnItjky8JvN3HTd8D9zf8otQG1npwt0OBDadJeAZ5HQGLFhBCrBjmWeEzB78gsfp60hDkxE7leg8m1ddP0REXtcJdz+vy8eNvicpk3/zsC7FFXLeTzk/ms4V09bFwTB+jLmIpASFo+eyMa1vKfKV0myN58I7lc+WGil2EbQA23zB5BdPzV4/zX3kI9b63fYw38X5aLtd5WxMNH4G7GFSrUyJRjkw0DLLWuKM8gD6YREPXhq09/O5D8j+ZkNx3DW1AqskvHSX2nWOAETtKBwAbkLQlVfrTTENxelNqyHvpiD+Z6EBIhtIwUhLW2fz2Gao8QDwbOffwvFjNv554Ru3auiq8frPfSrXw1oYhGHDDcQEeuEwM5nKUmFqojzWNU3IouT03aCFe7iJ9+N8aqbNSN/FNrtc+0hKo3qokpSXl1dnRuXAwoT34wE+2bQNSczXP7vy0sa+9CLgVBy7adnUDiqP/IWDgcwWBppaxuZI0QNgKdqKlcD+2PL9W2T7f1o3/hOAkFB+XPgeIORE1UzT443v6Uvn0C+2caU9rJXiyXeVjo8oDsjMTnsUs85tn0hYwKlkppqw1MmipyGUSS6HsnEsKEy2UfxOxU4W9HHUrT2EnCb3sGJFm25h2UXfTMny31FcAPWF1NBlnQroeNuJ2cZFX6uHpHPWLVWTBdiqBCyHCq1HEIK5wJBZXmmCvMEyBA5WPfPE+S6JN75oF17HEqRri6D5mfWsi/uC553FhGu3nGpyRsV03pdV+QSzupbubDpIhAeUBGPf31Mnd/lba2oez96aluF4bHZtfV8vlrCgllVYKpvRMfWbqE3h2OC4PzkEuISomz3fpHMLu1oEncmm0M
 grMZHoeF
 Nsi0hopaAFey+IPw6rQGgp+bN2F6kX3LwcpuCuJGHdWJJ5ls1B3c1p/KGkTlBhrHCdbxYq/NQI9kwKAILeAjn3bNvy2qEDzTFJ2U2kiD9u+VwhsHtd61VfqwaMZZCm1OkDc5g/mbrgh2vAzvThq/ljRZLo+NxIOKvsXGyafGX/YpgJGgQwF8ayfpHonSdaS6Mueid4Jrqff/PNokZW4M8H2YKkf2gQFCa3/lWfWe2RPSUbmjJJUMUuVscwICAkQdKVQBo2UluNUHLoO1v5EG/mkYd7rxk3CCvh62FuzZi71ZFq594V6DyPC01So9G/hPNsnKGmyTx0J0xDvAKm2CnqXtMD9VIQxp1E5mZrlZTORtxPV4S6NljkOLwdanGJcZ+uGSQo8ywTEWUK84RtPvTeoWoc8uZNDJuE29lik2prW65okeEjmIoPUQxSlhQ/sDfBERe565eLiGGbQizezhPnge+jNvGCHqH7aEx0mQ6qMErQnfA1Taa0ZbTFZLDVNf5qzWlSFf0CZM4ZNmJuYWk6PF6pja/kIh3tniDam4wjWpu8dFzsUx6ijkupbDKyxVdceNS7ni3HcA/xuWvlHDt7h9hofWdaURDqDqQryJEtQZpI+Rn91VdZGouTJ3hwXDADPoPseqrLeHZqg3EYIRSPJzd7h7YPX2gJ8M8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the capability of the IOCTL mechanism to filter allocations based
on tag's module name, function name, file name and line number.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
---
 include/uapi/linux/alloc_tag.h | 26 ++++++++++++-
 lib/alloc_tag.c                | 68 ++++++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 0928e1a48d49..3b11877955b9 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -40,8 +40,32 @@ struct allocinfo_tag_data {
 	struct allocinfo_counter counter;
 };
 
+enum {
+	ALLOCINFO_FILTER_MODNAME,
+	ALLOCINFO_FILTER_FUNCTION,
+	ALLOCINFO_FILTER_FILENAME,
+	ALLOCINFO_FILTER_LINENO,
+	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_LINENO
+};
+
+#define ALLOCINFO_FILTER_MASK_MODNAME		(1 << ALLOCINFO_FILTER_MODNAME)
+#define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
+#define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
+#define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+
+#define ALLOCINFO_FILTER_MASKS \
+	((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
+
+struct allocinfo_filter {
+	__u64 mask; /* bitmask of the filter fields used */
+	struct allocinfo_tag fields;
+};
+
 struct allocinfo_get_at {
-	__u64 pos;	/* input */
+	/* inputs */
+	__u64 pos;
+	struct allocinfo_filter filter;
+	/* output */
 	struct allocinfo_tag_data data;
 };
 
diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
index a0577215eb3d..378fcd63b6c9 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -49,6 +49,7 @@ struct allocinfo_private {
 	struct codetag_iterator iter;
 	struct codetag_iterator reported_iter;
 	bool print_header;
+	struct allocinfo_filter filter;
 	/* ioctl uses a separate iterator not to interfere with reads */
 	struct codetag_iterator ioctl_iter;
 	bool positioned; /* seq_open_private() sets to 0 */
@@ -184,6 +185,12 @@ static void allocinfo_copy_str(char *dest, const char *src)
 	strscpy_pad(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
 }
 
+/* Compare two strings and only consider the trimmed suffix if s1 is too long */
+static int allocinfo_cmp_str(const char *str, const char *template)
+{
+	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
+}
+
 /*
  * Populates the UAPI allocinfo_tag_data structure with active runtime
  * profiling counters extracted from the given kernel codetag.
@@ -223,6 +230,40 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
 	return 0;
 }
 
+/*
+ * Verifies whether a given codetag satisfies the active filtering criteria by
+ * matching its characteristics against the specified filter.
+ */
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+{
+	if (!filter || !filter->mask)
+		return true;
+
+	if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
+		/* user wants to filter by modname but ct->modname is NULL */
+		if (!ct->modname) {
+			/* validate if user was attempting to filter for built-in allocations */
+			if (filter->fields.modname[0] != '\0')
+				return false;
+		} else if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
+			return false;
+	}
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_FUNCTION) &&
+	    ct->function && allocinfo_cmp_str(ct->function, filter->fields.function))
+		return false;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
+	    ct->filename && allocinfo_cmp_str(ct->filename, filter->fields.filename))
+		return false;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_LINENO) &&
+	    ct->lineno != filter->fields.lineno)
+		return false;
+
+	return true;
+}
+
 /*
  * Seeks the ioctl iterator to the specified 0-indexed tag position, reads its
  * profiling data and returns it to userspace.
@@ -231,29 +272,46 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
 {
 	struct allocinfo_private *priv;
 	struct codetag *ct;
-	__u64 pos;
 	struct allocinfo_get_at params = {0};
+	__u64 skip_count;
 
 	if (copy_from_user(&params, arg, sizeof(params)))
 		return -EFAULT;
 
+	if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
+		return -EINVAL;
+
 	priv = m->private;
-	pos = params.pos;
 
 	mutex_lock(&priv->ioctl_lock);
 	codetag_lock_module_list(alloc_tag_cttype);
 
-	if (pos >= codetag_get_count(alloc_tag_cttype)) {
+	if (params.pos >= codetag_get_count(alloc_tag_cttype)) {
 		codetag_unlock_module_list(alloc_tag_cttype);
 		mutex_unlock(&priv->ioctl_lock);
 		return -ENOENT;
 	}
 
+	skip_count = params.pos;
+
+	if (params.filter.mask)
+		priv->filter = params.filter;
+	else
+		priv->filter.mask = 0;
+
 	/* Find the codetag */
 	priv->ioctl_iter = codetag_get_ct_iter(alloc_tag_cttype);
 	ct = codetag_next_ct(&priv->ioctl_iter);
-	while (ct && pos--)
+
+	while (ct) {
+		if (matches_filter(ct, &priv->filter)) {
+			if (skip_count == 0)
+				break;
+			skip_count--;
+		}
 		ct = codetag_next_ct(&priv->ioctl_iter);
+	}
+
 	if (ct) {
 		allocinfo_to_params(ct, &params.data);
 		priv->positioned = true;
@@ -294,6 +352,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && !matches_filter(ct, &priv->filter))
+		ct = codetag_next_ct(&priv->ioctl_iter);
 	if (ct)
 		allocinfo_to_params(ct, &params);
 
-- 
2.54.0.1099.g489fc7bff1-goog


