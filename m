Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AFC4CD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 17:45:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8B86B00B0; Fri, 22 May 2026 13:45:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8F0A6B00B2; Fri, 22 May 2026 13:45:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56526B00B3; Fri, 22 May 2026 13:45:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A014F6B00B0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:45:51 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CCD21A0AD3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:51 +0000 (UTC)
X-FDA: 84795783702.24.EB36268
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id A7BB34000E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 17:45:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HTy6vkhj;
	spf=pass (imf27.hostedemail.com: domain of 3TJYQag0KCBMtu01B0x3ut8tCz77z4x.v75416DG-553Etv3.7Az@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3TJYQag0KCBMtu01B0x3ut8tCz77z4x.v75416DG-553Etv3.7Az@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779471949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/jYkf4xPE5NaHstf7F4psma2bVLV13GjTGY2UjXb0AI=;
	b=v7kRX/M+d8XuTxJ6PxJN2JSSVuOZtF22oqtmC0EC56IYNNY+Hsyp9UqME7yJX6HUVoH7dU
	uQVu50FROyr3RvOajZT03Oq/vB/FH0+CKF1jb9+aE7QziR0EMDLRQ0GZu8v+3cQay4mdv9
	xsuTsvYk2ap4jrEhxzFddNEXIVLFIlc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HTy6vkhj;
	spf=pass (imf27.hostedemail.com: domain of 3TJYQag0KCBMtu01B0x3ut8tCz77z4x.v75416DG-553Etv3.7Az@flex--abhishekbapat.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3TJYQag0KCBMtu01B0x3ut8tCz77z4x.v75416DG-553Etv3.7Az@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779471949; a=rsa-sha256;
	cv=none;
	b=uaY2j4z9ne3YKnVN5zpyj9itONw869B0CE6LMZBgu0IPmKjbGEKMEE9t7tGXBPQkluo6EJ
	pYRlG2BuM4kdvqjlyhnJ/i0s7GiQh1rSkJNhTff7SSagREInrS7C2JShHLFY0ntlOh1gDY
	d8c/q/XvqQezhgyTVRlEKjDzpzN9+qI=
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2f2d983d109so3541962eec.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 10:45:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779471948; x=1780076748; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/jYkf4xPE5NaHstf7F4psma2bVLV13GjTGY2UjXb0AI=;
        b=HTy6vkhjSU3Mm5REtzmivSdC3jQVN8LL7K11x0bKZhjExBTNZruI+tsxGjPLxW0vZ1
         DBjhBgXRVwslILk3hG93Y8SpIBPzefZVOAMhdzn4fyBqY/qZhLoNgIDzr6WBmMRjw91+
         JpZWMAPLwvLxTnoP1YbB4t+mOe367LdCnzfJ62eVuSpTxY7NcocUn3brBtloMuNvhgON
         2V5OY1THJ1AOBJWogL1VAQDUzQHABNuDCxV8ey70XFQWrnZUcM8tHLia2/5JY86lLhGN
         rft7k23gL9PiliTKDwCLY48LO4VxH0YRc8iKAe1EO8D4oTN5RiJQmTb34HqMgzp16sVe
         8L7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779471948; x=1780076748;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/jYkf4xPE5NaHstf7F4psma2bVLV13GjTGY2UjXb0AI=;
        b=NK6Bx0GdDpqJv8mm9gSPV4j1+RCx70ylevxxX9MuwbXQXS01X3nha/bVGUSXSLdumK
         sHREB9uufxdAbQpz+pU+m3scyQsawfaquMegPeU/FdMr8INS2DMb1QDpJBmUdNxJvU7H
         DXSn2ykEYvOlvgvMUPmyMw46S7Ao4LS0ugNiaXityexWcU3MoKyPz8ELprIdoh4UqhW3
         FvpYw6f1GRgBt9lsveLv+a9qXMKnS+jVGXEX0ZsdTjdckeygP+gFlmNZARQBOinBSZez
         ybFQ7JvOWZ6CpFamw2RhOsuazzREpWOoz6nJyhH7gevcoCirpf8vECPsF56cpd5VZ5va
         eGFw==
X-Forwarded-Encrypted: i=1; AFNElJ/UMbs62hFkf2F/dEhZMyV/AMH7LkDqm7XYZFDiODYySFS+G4TJvUvqFWOdI6glZplHb7RyuWGVnA==@kvack.org
X-Gm-Message-State: AOJu0YzuAw+qQYQcFgWRAPIa3uJfTMpsLEfFRWp2G3WVwQI+zXlFPhS5
	jc/2+pyY4hMh+CGrrOIuFgzF3l3Gjl+q/HGJTC00hXYvDlO5ANFWEjUg8NnjjWZKOZudhd0PoO2
	W7EljINMUdDsOlrqWfsswnlZd3YtZdLOsnA==
X-Received: from dykh11.prod.google.com ([2002:a05:7300:570b:b0:2f9:af7:504e])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:693c:2c8b:b0:304:67:ba1c with SMTP id 5a478bee46e88-30448ffd0f3mr2906032eec.6.1779471948351;
 Fri, 22 May 2026 10:45:48 -0700 (PDT)
Date: Fri, 22 May 2026 17:45:34 +0000
In-Reply-To: <cover.1779471082.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1779471082.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.54.0.746.g67dd491aae-goog
Message-ID: <f177efebdfda5c2a179d7cd6768e0c6f37efb9c4.1779471082.git.abhishekbapat@google.com>
Subject: [PATCH v2 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A7BB34000E
X-Rspam-User: 
X-Stat-Signature: jjdnbeit7fxuq5onrx9in1p85tpqsui1
X-HE-Tag: 1779471949-279630
X-HE-Meta: U2FsdGVkX18//x7ZTcjgwPe5FEYYVIfcQV0ySPRQlgSqUSapjVIN/7acEDxBQWxjKRHzr7BvvxtfsRxhrmM/o21wXAag0yGwERDAn2VKg/y0TY+zXUqMjTtB8rtDiCsakrrUbUKoeF+3TwtzG0SL6Lb9M2QQvcUJ2ROqrQ5rZthUpIYuTCyU6KUegiMfdZ14suoa0n8cb14Opre17Ctq56kxMH+jy85T6aCTl1+9KZ2oGHb6i1Pk0mXVxJEaPPcKK430Lthk8GBTQP1q/+n7a06Cm27BjHqS+4ICqJKBXcMFuXNdqUlp/i6f9rUmGM9IPqGVwbQ+GmSwMvlYeYzQs0eoarffzmGrbPBaJi7TEeqT8csO1dmhEdGXJcV7unxDgjRE9v3CS6r3rjznSWU6dhMtDoYccPQ0LRq93rIonIq9nIzJbKYBBXW/u37G9UAguZtN/nvfQIzr4k2m0csvFL11SdVvzHsTwIynImKYPhKG+FdHwR/bc9vIJmLBzYBmh5IQXdcLounHEhF4D//Q8JDCXufeJHVMHiQheveo3sqiIRlum9/OkzJ5WXWmvEHEcL2Dh0JRckmQwsTFIvDFZw/j9hAKjOTyp+RhLmB8NsFdd7M6amOo0mEtUmCJ7AodxncWqqN1WKpjxPDEr3ja/NVOfrBDD9qEnAqQ3obh+T5JKDykO9V7u0gjK4TCbcj2t6EXFO5cx/9Vje7zYBOG1BRNc3h99FQ55L/HvQ0Pqk3PfSD+L/VYkBfZwESrlhgMi9KtFnrNSoahUoG9ENPpe1XeMKsJ1z2GDJGkemt9mQDeg6iCssnXMMIIXVPCdoDI2ZcgMmjdeNm3WW1zCfDHQLZWB0FgarHrY80bA8dYgGK9gKfOLAKQhfdDAJPpUdr8AygYyCT+2RM3kuK1wjTC6cXyQ3Ut6jsKt8rmdPveQjklTHDD/VxFxEStr4nIKsdmv/gGB7WuuCcQXWdxkkv
 eiyob1r1
 4Xych0YT2ZXZ+b0N422pskx9iExHnFo0QBofWvaIr2waYZ3QPrm9cFXN3QumwUKDIH1Ob0OwivWdPrVonfwX4yaqebyX6yPAHRoXo3jwuwLnyea3mbvKOZ7FMPGej/kE/SmUHogYyDzWNrCaK4UL0ekcbfrnHijyoQ+ph6onBQAlV5EBeY4CNXYvEdxsm4kWdBoPJ+ij5XSdi4bUvFi9Bx1aCX4qlEvVAbwxijDrvbzAt8H1KSUww8J2M9LGiBDYtz5dPZoV1fvI7DVmdJAR83xvfyehgYvbUu4nOHPknlIV45IcIYTWuEIbqPnQLFCy8jOtf3hIO1T7wbk9c60snf5g6VU3+jA/f+fuDHjH8IjS+USbM2OMoFn4NXjDCoLG60z2lmOdJvnDrYhAcyKe/OuRZTZxPT57UN4VPwOh0JCI/XWIH7Vwf3Cp/uHTcEYrXpEwItqfJlKnKs8l4TeqMbt0YTy7f1Pv7ELMm7I3B/whQbd9OI5fET16YdRGjH5m6mu0Ji6tVFfbxQ7RC5x3N/rROpXYi5mHzu+pvCbw3VvDQt9JfQIyGAvkdfCKp6+QDcS2uedXWKaWa7imdYwabUS7ccJu2ANMMAtEbwhLhimT6vXb41QIzO6W8yfA+aUYRMXnqdq2YrOyDEA7G5ES4xliAujCEsHSubl09
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
 include/uapi/linux/alloc_tag.h | 26 ++++++++++++++-
 lib/alloc_tag.c                | 58 ++++++++++++++++++++++++++++++++--
 2 files changed, 80 insertions(+), 4 deletions(-)

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
index 3598735b6c93..56c394ef721f 100644
--- a/lib/alloc_tag.c
+++ b/lib/alloc_tag.c
@@ -48,6 +48,7 @@ int alloc_tag_ref_offs;
 struct allocinfo_private {
 	struct codetag_iterator iter;
 	bool print_header;
+	struct allocinfo_filter filter;
 	/* ioctl uses a separate iterator not to interfere with reads */
 	struct codetag_iterator ioctl_iter;
 	bool positioned; /* seq_open_private() sets to 0 */
@@ -167,6 +168,11 @@ static void allocinfo_copy_str(char *dest, const char *src)
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
@@ -198,27 +204,71 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
 	return 0;
 }
 
+static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter)
+{
+	if (!filter || !filter->mask)
+		return true;
+
+	if (filter->mask & ALLOCINFO_FILTER_MASK_MODNAME) {
+		if (!ct->modname)
+			return false;
+		if (allocinfo_cmp_str(ct->modname, filter->fields.modname))
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
 
 	mutex_lock(&priv->ioctl_lock);
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
@@ -254,6 +304,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && !matches_filter(ct, &priv->filter))
+		ct = codetag_next_ct(&priv->ioctl_iter);
 	if (ct)
 		allocinfo_to_params(ct, &params);
 
-- 
2.54.0.746.g67dd491aae-goog


