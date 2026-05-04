Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 097D8CD3436
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 23:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740316B0092; Mon,  4 May 2026 19:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F0AA6B0093; Mon,  4 May 2026 19:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56A456B0095; Mon,  4 May 2026 19:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3D3026B0092
	for <linux-mm@kvack.org>; Mon,  4 May 2026 19:36:36 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0A4901C00E9
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:36 +0000 (UTC)
X-FDA: 84731349192.29.E625817
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 49FC740008
	for <linux-mm@kvack.org>; Mon,  4 May 2026 23:36:34 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oJGabyTx;
	spf=pass (imf11.hostedemail.com: domain of 3gC35aQ0KCBcxy45F417yxCxG3BB381.zB985AHK-997Ixz7.BE3@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3gC35aQ0KCBcxy45F417yxCxG3BB381.zB985AHK-997Ixz7.BE3@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777937794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P8In7SqV1CDaELSYurDVfz0X7xi71y9ocBNy94kYNvE=;
	b=4FIISGvCMX/MRtE6BJUoehT9bA/8L4X9G6wy5xc4GRUYjxn4z7jCbmLc5If/SYbhkBl4BF
	j1FlCmldN/ZfhqpzRP/AVWZoPdI6qY5qjPiyd64XKvEL3nCvGgwYJcbeupc2GHYJTynebq
	JVjuuj7K6KEIypo0VI8BXpJOcVx6+XE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=oJGabyTx;
	spf=pass (imf11.hostedemail.com: domain of 3gC35aQ0KCBcxy45F417yxCxG3BB381.zB985AHK-997Ixz7.BE3@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3gC35aQ0KCBcxy45F417yxCxG3BB381.zB985AHK-997Ixz7.BE3@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777937794; a=rsa-sha256;
	cv=none;
	b=TuYKUSOclVGXJsHED+AUGKmsGSYREul66VnDm3cNacsrPeiHUBkg+w2ehvix1VmfHM0YIj
	/JHvxozMDw+RmLGA6/wMm75rNqIDv8/dbTewngQ0hSfoAYK1n4d05yi5xnup4c2jXgkn8Y
	hCHW/oX34laUR8ouvLC5X74MHkal3DA=
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so6682967eec.1
        for <linux-mm@kvack.org>; Mon, 04 May 2026 16:36:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777937793; x=1778542593; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=P8In7SqV1CDaELSYurDVfz0X7xi71y9ocBNy94kYNvE=;
        b=oJGabyTxJdyjjFWUBS/obw9R/qcgvHLCBmTuKNB5MS9sgT3w16O4PhFBfEdSUIbNVN
         8SDwbad1ZSSW321foBtH8P0qn01tRr3WEE/Yp1+PNP6I6Lp5wD9VwCSsz9g+lI2WDXx7
         RKpXz/7Tw2jiBqaz0aGyuXjeROMiiKmKcwTWyEYdNL9LUfkKqVs7/NMPqNC0Gs/vdglO
         GW69ZiZgSPvAPq9yoIZtUExr7JgENX/r5lZTNwbMPgmLzvqqDWHOLW+UlYr7Ax8PGCEd
         kRM8GZV2N1Qs8qf1mdZwECQh3HmrquBwwNVvLekTOFXRCS4TMWP6h5F0ys0HEyBeOTYR
         cNSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777937793; x=1778542593;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=P8In7SqV1CDaELSYurDVfz0X7xi71y9ocBNy94kYNvE=;
        b=sAZDkT0EUmEbPEpXVEsgtObRrikPTc5svPRgmWut4/nfIlwelruQK0z5l/BXFZFwBW
         gGPxjYYV6RyG7b9wht+XTq99MsbIWULxkLn1n7qJJ7eVTcq4SxJbTIos5HipYlKEhiKi
         1wLSe2iEwbnx4AwAREz4jgGbsWXTJpz1mo1G2hRdG7iG08Ja2L0s2mCHJTl7zpWdscow
         3k4GTR0+t5vwE6+L69vCxwlgpRcks/kI9jZtbblkhUqv+ou2mBsdwlHRl+C1L13UUAir
         Bsgyfsg7s9E9FNsZD5U4zotElHnCHAgRfQyEBNEm5YCWcYo4d9jf4t+23vxthjZ7sTgn
         L2Uw==
X-Forwarded-Encrypted: i=1; AFNElJ+bqMqEhvhSLS+e6TrifiMBTmYSXpXG1/ChD6NIQ2PkS1sxQi3SnTc0p8DA+9AYAnD98cDbV51IuQ==@kvack.org
X-Gm-Message-State: AOJu0Yya9FPPsRA2jkHucQ9D29ewLK8KMnbjuQxkHt6V2AbUB5RssUhY
	Bz5Gd1HB8yUtcc5K3AmPMD9yQR5EtsURK5jEluNdRrcvmAp6AwtneXxZk5vPN9mCjXMhbkJL12r
	uTWz2Axlnym5Y3Mdp1Hdg1dKSNNq1AunjyA==
X-Received: from dybmk34.prod.google.com ([2002:a05:7301:ea2:b0:2ed:a84e:18d3])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:7fa0:b0:2ea:e93a:ff9b with SMTP id 5a478bee46e88-2f408519825mr409335eec.13.1777937792756;
 Mon, 04 May 2026 16:36:32 -0700 (PDT)
Date: Mon,  4 May 2026 23:36:20 +0000
In-Reply-To: <cover.1777936301.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1777936301.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <2d1cbd93b987198d9569ff54b7fee4ae6aad5ff6.1777936301.git.abhishekbapat@google.com>
Subject: [PATCH 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: s6ieh4rckdzc3hzbwpbscxo7yhqwj3py
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 49FC740008
X-Rspam-User: 
X-HE-Tag: 1777937794-251610
X-HE-Meta: U2FsdGVkX19Xl8GsNbM+LS2V7yZFHaB7KcFFwivgivjfsaNgx+pf+JnXDUgm9qENZDq38Uqu/vrdSUwG0r6GZOlE78uAdB9VEFK4XdpEKS+vXphEec+vzY4VPMHp/+JRsvxNRy5Kwxyyx6y3o0Jxl6aeI7vt7mO8uTNjTXBPBGK18Cno0TniX6xBo2c1HS7LYOZBLlwXAUDzaAvaIGF516/0WelkI0VDXKHE3NIdFDrDXZ7buDQoKDH7jGrpCLOq2QTvNSOGqHZx+T3LjZo4LCvqvad5M5q1l9Q3L7ZRaXLNha5FyPvVkD0HDBaKSlQCK7K9thL6B6GnpyDvF0yOa1D/fJjOY/JmpPGVwYUjdDZ4l7qn9ptSTCgK1/1tNA3+wsr+S+PuzoXUTJjSsF24O5HZ+LWfknL+iuDYt03/0253jspD1/TzHFfseZLGQLU8wJIlk/3P96e0K9Wddjz+nLlORE+UvG2oD9MkpjnR707wwNcGkUMxJjpXzITR8ou3+GBb5nsjc282nozYYM5qsUmHSbk2U8BIY6Y32wgJW4zqntJFAyJI3CFqPV72WNkI1DvlpYzitgJ5WGgEE9FKRDe03SWHhLBQczxsy6t74HPNKRhKlG0busTVNO/a8hfv3BHxhcQLyW3NK/nd2tvBgAmcXChn7WQyTs3U9cBe7LoyJ1rWZYdEetacwDPQiLq2wJhg3LDB4Nsgepxxc2tl5fjSYzG/A67lHdxwtYHPGqxswyst40aeJcmR5xcj7v5PHwWTb4x7FZwy9/sVzsQo+NicZ7+iymsMH3hOCxRX/6y6CGV+5Jqht8Nis/QRQj3gtqa18ZXLZzv7M0GFREFhYcTqEqoea/tkNfKEbPot89QyVF7X2FN/GZxu6kWYboWOI6pm3kiV4ULphVMQI6yArEWz8u8PhiHQ/AY2KddKoXQQVo4zzBqJNCZESJU66rME7LyuTA4GWhI6OidBuVa
 rK9cotaR
 brCyMfQy+ozsc6yiExlPkZMiiRlZ5ysma6OVEoc8RNExhzcjmZ31J1/JULCTaUTA1Q2JT12p+yqUmT7CCj03CjRPXPyx45WS5kpcFflk87+2IV6gGTvpk9vQWoTF2u46NpzZN03jDJrP8oagIjZktgVIRzbO2rNUG4efCdp91sXE6FQDz3fNcwiGo7M1QJ3CYt+TJ9kQwctVw1HO8Y83QTF5shnTjwk2U1SPVqFqvPlzkmLwYQUMZA2u6x8dw1H8jbFZW3iLbkl88Bm235MzVFuuQtqXS3qC9csWh1rw7Bgn6xBW6nHbViU4sgWHTTKbf9uGD3apwh22gJ5Cinf6n4USSES1DCsLuPWIMimQYlXakkN1dIV86dIfrmqyEHiOD6y0Sp/99zj6Fd743LP8ysdBdf6Tut8y/ZR4NE1i2c7S1V9S6i2es/9E55puzdYS6cqzL1+m+6BY1aq9XJoJOoguURNQJDZW/SB0QuzavSss7yDyargnHZ5VXJNjpaBzpy/rjOD+tlkkVCv9fL7q9kf9azvgt0oUDGgKYawKHlhjZTuyr7cnA9XEqf0se4+7p0ZJjOSECFJhwqx1MwSqZWs3fV2hsbidbJwrPXfzagOKVyAU9smmXnbtm0Cx7b40VumVS10I/3GmE0G6jbjo/kaOXtN9Cd6P14/tX8NYTWelRxIP56yTc30ohocm9RTB8+qxWRVeZ16jlIfHB2/vrT6wJdwZe12wFxPC8HeMGJgOoNUPV64CxQwofakUIzJsO11jS
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
 include/uapi/linux/alloc_tag.h | 26 +++++++++++++++-
 lib/alloc_tag.c                | 55 ++++++++++++++++++++++++++++++++--
 2 files changed, 77 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index e9a5b55fcc7a..0cc9db5298c6 100644
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
index 5c24d2f954d4..7ff936e15e97 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -47,6 +47,7 @@ int alloc_tag_ref_offs;
 struct allocinfo_private {
 	struct codetag_iterator iter;
 	bool print_header;
+	struct allocinfo_filter filter;
 	/* ioctl uses a separate iterator not to interfere with reads */
 	struct codetag_iterator ioctl_iter;
 	bool positioned; /* seq_open_private() sets to 0 */
@@ -156,6 +157,11 @@ static void allocinfo_copy_str(char *dest, const char *src)
 	strscpy(dest, allocinfo_str(src), ALLOCINFO_STR_SIZE);
 }
 
+static int allocinfo_cmp_str(const char *str, const char *template)
+{
+	return strncmp(allocinfo_str(str), template, ALLOCINFO_STR_SIZE);
+}
+
 static void allocinfo_to_params(struct codetag *ct,
 				struct allocinfo_tag_data *data)
 {
@@ -187,26 +193,67 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
 	return 0;
 }
 
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+{
+	if (!ct || !filter || !filter->mask)
+		return true;
+
+	if ((filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) &&
+	    ct->modname && (allocinfo_cmp_str(ct->modname, filter->fields.modname)))
+		return false;
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
 static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
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
 	priv = (struct allocinfo_private *)m->private;
-	pos = params.pos;
+
+	skip_count = params.pos;
 
 	codetag_lock_module_list(alloc_tag_cttype, true);
 
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
@@ -240,6 +287,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && !matches_filter(ct, &priv->filter))
+		ct = codetag_next_ct(&priv->ioctl_iter);
 	if (ct)
 		allocinfo_to_params(ct, &params);
 
-- 
2.54.0.545.g6539524ca2-goog


