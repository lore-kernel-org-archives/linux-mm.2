Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0A0CD6E7E
	for <linux-mm@archiver.kernel.org>; Fri,  5 Jun 2026 23:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF76E6B008C; Fri,  5 Jun 2026 19:37:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD5F6B0092; Fri,  5 Jun 2026 19:37:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD16B6B0093; Fri,  5 Jun 2026 19:37:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 99E096B008C
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 19:37:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6040A40313
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:37:00 +0000 (UTC)
X-FDA: 84847471800.03.D03054F
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9901E1C0007
	for <linux-mm@kvack.org>; Fri,  5 Jun 2026 23:36:58 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N32IsIL9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3mV0jag0KCDoWXdeodagXWlWpckkcha.Ykihejqt-iigrWYg.knc@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3mV0jag0KCDoWXdeodagXWlWpckkcha.Ykihejqt-iigrWYg.knc@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780702618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUz21q/5HxpYzbtjUddcLYZc4KL4hA6ns2oMTMr5vuE=;
	b=yuT0W2fQO7EU1yJPkNrFCzOAhkKbweXKA3WB7tGutSt3lf24QyeZweIzjSvSUJ//MN1HNT
	zJjhEbSpfyxO5NC7Hgci33QxrFVfmae/xPGNnmFQ5rDLkopjekxK5C6XktGSL+gnM0KW6n
	Cunq4IehYMRk66NOm9EbPQLgkBH7ypA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=N32IsIL9;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of 3mV0jag0KCDoWXdeodagXWlWpckkcha.Ykihejqt-iigrWYg.knc@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3mV0jag0KCDoWXdeodagXWlWpckkcha.Ykihejqt-iigrWYg.knc@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780702618;
	b=JYWLUwL66DjJ+laEiLtOPvdMJ7xmH5uYNwU8miS1hPBLl5lxT8Z8F7walfeipoYXHI4gQt
	z1JBe4J+jqnmB+lBigBY2yYbNa5PS0jub8+BLVfT0ME3LHQKQmjx4bTDw+P0dEcZrJD9cI
	7D5rxSmvE2oIjkFxhhPaLYd9IGTwDkM=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-304e4636205so4637046eec.1
        for <linux-mm@kvack.org>; Fri, 05 Jun 2026 16:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780702617; x=1781307417; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=CUz21q/5HxpYzbtjUddcLYZc4KL4hA6ns2oMTMr5vuE=;
        b=N32IsIL9ANwI9zuTKmhKNkPJClH7OWHjLKlczxp9lBuCcu7td6seG2jIwX6O8yxax6
         F8qloQxSoxYZ5I6jV3Idd1oErHpH8cfEk34K//VktMZgkQvw/+a9iO2VaBr2tyE3WLHs
         Jq4/6NrdgaC/57IDlOmKQlsHtf4vmg164y3eEsYCZhl2jVSR6WTtCGY5ANHwhCcLhmlo
         1lt6gAIw3ai/9tPJ3F2VjYbibBk1A2xmdor7wW61TbmVqvfaiTPEjEmjJrPt30LP4vNu
         adkvd6TubRPCP3B2xolzgCq9fLARoDQ92wOw8EZjtmv9IgJ5Fw3+ZrEJp71W70BSDOmA
         gShQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780702617; x=1781307417;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CUz21q/5HxpYzbtjUddcLYZc4KL4hA6ns2oMTMr5vuE=;
        b=SDLRL93RQDRO37AnKrF0IUGSXbd3MsRgvWdiuJU2KYkyYC8zpDMHggpM5OFo0+wNXR
         6PFyaHOSH0Lmtx1x0dpuEXRcA7umy+5w/5YcyPdBKPtNAGROh0COO0TEx0+o4szXYoCy
         cNUz8ochOiIBfvTvI2+ge8/j9vDmyjyO5fE//FBJKC+GJ6bW7q6e5SQMLrMHqsTdXRfJ
         Z6YweSIHwiDbBx7ryYt9tSNzlH8W3MfWzlsBS2xrzxmvbC6KjYJmGrThLGY1BLssAn9I
         SdZmChhUuJXUrJJKf7q2Ai14BgNCAu7AR9HCWu4Sxjqoo1w1CF1sc1KBw26DlsypmnTQ
         z9Dg==
X-Forwarded-Encrypted: i=1; AFNElJ+jl2UzJRWlQyBPuSFPe+qOk3HsbQIYObKtdFg9exegLIQuB+23UJ6mnFv25uP8Bz7/uAHshAl1Tw==@kvack.org
X-Gm-Message-State: AOJu0Yz8gqe0H0kpwwmO6k9x4N1HjXy8sPVZSYnVaHTovVmWZyKJQmHB
	FKcod3CX8Jn/TgH3aVCeSdRwbOnVNiHl055sDXXzMCpNHnJnlPskl79CL6Ok5nyMCzLL6CvZdT6
	10eOhXWwocltYT3erDGsXlP3R1i63u/JnWA==
X-Received: from dyba16.prod.google.com ([2002:a05:693c:63d0:b0:304:cde4:bdc3])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:80c8:b0:307:37a4:15dd with SMTP id 5a478bee46e88-3077b26f364mr3065770eec.26.1780702617066;
 Fri, 05 Jun 2026 16:36:57 -0700 (PDT)
Date: Fri,  5 Jun 2026 23:36:47 +0000
In-Reply-To: <cover.1780701922.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1780701922.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.1032.g2f8565e1d1-goog
Message-ID: <6f3b4aa0aa294cd56a73854c631de3ab7c0c5e01.1780701922.git.abhishekbapat@google.com>
Subject: [PATCH v3 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: gihhbmdewr4tw1etew5q8kkz34ykgd8x
X-Rspamd-Queue-Id: 9901E1C0007
X-HE-Tag: 1780702618-128834
X-HE-Meta: U2FsdGVkX1+2gF8KtC5XnFzbcMKmFr9uaXfD5VqFXYydgtH0NagWoZik1K6zV7J/nEgCsn7sxZmSKeqS3t49ONY2eGFoNJc3VrFVj6KAy2zk3JpdqtpzDUM973o6i6PLoG68c0ZdbZHuQgnXJeh26eU/MFOlCj6t/jPk7Q0I9DqhTuONXwoi8DgTXx+DjulSQwIxhvSq0keirXXgdk+C2imPulv5rtWM1BdmNr1UtnQgpfBpQDQDJaesxL4gAMhBN4EntnM2xRICfEp6WrRtnV2ovVUs3Wi6ykBg/KlXroDJ8U5TKXLBImnoY+AVfMdwhUTix6D//tw5aQB78IQdslisnxB2OY2Xz9wuASSv9Pfd9727+9gXUsNGP10fmE2E5l4xb9BLCJ0jhSXLyz4f8ArXssQtMCBUapHLt5X8AFrFIvhC7nDNRkKYnN9mnv8Dn5c9JU6ncftGuREaQqLfjMOvyCLHUW6vd7fM7yaN11qlZhX/0sDkz4mhVHQ5OwmzSyzv6Gh82Inn6eb2YCDBt+BFtT1YzY5+SDB5oGKERnlr4SiB0n8plRIByveKIbh0ALfQr8UbgTfJdwuHNXAAbLoMbddlqn8znpqgT6m0FYNoqwDffSwXl7oQIdh2JSDx64nZkQkaSa3A8c9cziKloP0LYBPfGVrI3pi9l30RAkOxEp2RvoBAkVKT0THspC4ufjCpKMyycmPcXrK1C07HIOBn/06HCeVJez1Ld84VPpHGG+ZJX36fF+ULNEEfKWKCBwnhQAnF9lM9embQG9sdCy3rHUCKe/xCaYsfoxi8BZfe8sz07FEEIfrsQAnX9XPKxf3LtSgDQTTonQDjzc64JqMYrLe04SJunm090Q3hqya/ZD1tE2qpBVUErr4AIOvBDzB7MC4p9X808Z816ezV5MgU37WXxaK0ODNx5yZVDLkhtD9LMniCiG65vmFZiYBZG9/yLihjjNPRntb5FY1
 D0ugumeh
 kW3GP/dy6Y1Fq7kBE8ACrIF/nRgFFa7OU9FQhfu3N7TqIw189lkcHKxukn9ocVLMTDya/CLANNfjOeovZ2ouPLSNIztOW5vkjhyJxKJPvRuDQ3WssU+jzRnzjE6K1CqYXJTLdn59vvTQCKsDMzVMELvVY9qEDzKP7LvNl/9/SRHysBkxVcEjPnn7ROrBCmvsKzSFsYYXJdsTkfEtEm6tSIee99m6HCVcRp/eDVnvhkOk+UhDcLMejKenHiyaDptCQteZURPdHl/nzMv6Box/ysKB0tdVo8Ji/2xl0Jb5D4P7xzLxHtH6mwKvoBOjkVjk0FVy32vOvHXbYb7jmITYZLwMpQLaf32yEALpkWZqE635uAIYrc5Td5c8fEueqqttQybHTEcQBYYjvK6m8xreha+3lMTZNGJ1htbuFzVod0MRWjlTxD16TbgvbAylnBI5dS0yfxvZ+fINJoBSiMgxKJ8Sgj0SDqp5PbYBCd0DQl3BVNhFA6XYdra2sT37eDskx9mWTmcCUcQPMc50dX2yY+FoOcIsRtqgfgeRgbicoTJvFY+vu+Y8ck8hW5ta+1+aG4QMdClhyavKC5b46qYXXhq29aUjBjC5h39jO/rl2Fx/ZSD3YRX13anXUlXhsbi9brnEt7EMC4BI3gu+9N+zrCdLozD6S3xaGvY+t
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
index 901199bad514..cffb0c46e0b1 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -34,8 +34,32 @@ struct allocinfo_tag_data {
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
index a0577215eb3d..93bc976ac505 100644
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
+ * matching it's characteristics against the specified filter.
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
+	    ct->function && (allocinfo_cmp_str(ct->function, filter->fields.function)))
+		return false;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_FILENAME) &&
+	    ct->filename && (allocinfo_cmp_str(ct->filename, filter->fields.filename)))
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
2.54.0.1032.g2f8565e1d1-goog


