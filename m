Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02B83CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 17:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 873D06B008C; Thu, 18 Jun 2026 13:36:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84BC56B0092; Thu, 18 Jun 2026 13:36:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7887F6B0093; Thu, 18 Jun 2026 13:36:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 53BD66B008C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:36:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B83821C1110
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:43 +0000 (UTC)
X-FDA: 84893738286.23.8075EB6
Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	by imf28.hostedemail.com (Postfix) with ESMTP id E6C41C000C
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 17:36:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A8ePby0F;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3qCw0ag0KCCsHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3qCw0ag0KCCsHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781804202;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DrCKQmndYCTLKZMT11TnLt2FQ5FzBuck7HJJlx0dbhM=;
	b=IK7e9+VczC8ceiqSqPieifI3JLQV8MauEShT0MG7RJ6xqKX8g7X1bX6pxNrAQjvfmByhuz
	c988UxaJX9GwmfJVVAMWnPCBvfdtjyiFQfjULdVOKK7YeyG8yejdElNylfGIA8avb+b96T
	OiwlXRWNmUzHCz4PcTBFimyL1GBgAe0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781804202;
	b=yDTLkTFH1mUA3efuj8T+XBc2Q3OHj/jAxC0iCowmKtpiEtIS96p+vUX3c2HFb4+DOSi17E
	vqXIn42U8pjvNsSy5O7jU0NewKfgC3qIUMdevd+nD7B2yg3EogGgUWZbFNOjVKQl8Y6MYF
	J7HDgdLyYIaAaT/BQBvNx4Cz0h7TJMM=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=A8ePby0F;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf28.hostedemail.com: domain of 3qCw0ag0KCCsHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com designates 74.125.82.202 as permitted sender) smtp.mailfrom=3qCw0ag0KCCsHIOPZOLRIHWHaNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--abhishekbapat.bounces.google.com
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-30bef75a41eso5028331eec.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:36:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781804201; x=1782409001; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=DrCKQmndYCTLKZMT11TnLt2FQ5FzBuck7HJJlx0dbhM=;
        b=A8ePby0FIpApZGnyMuMiXtMMInQD4fwKbu2DI09fJQa26qfJf4l5Ts4as8836VIFbl
         iJ9QWMYWuQsoLyrD6VH2LfDkjyPO/wCyaeM3wwmplKdQiTgHU4zjQ1ZKo0yO7YLddA8w
         YIw6wLjzIVfrvvPNxAL6O30tXLinbPN6EEpb06WiNrFQ0jOPiX/SGYzwX0+eGvXrfyNG
         Jn6+qNvH8hb68jIIAzr3xGBR1hutDEG0+JXedvmK8wdfIR3eggR6qm4CZovdYiXIbx2M
         XSu+zjXkXa5WHHOYxjvnI0LrdONmKNDKK3vxPlJDcAj8jfrrmylvArjPmQyeddqxRzsZ
         C5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781804201; x=1782409001;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DrCKQmndYCTLKZMT11TnLt2FQ5FzBuck7HJJlx0dbhM=;
        b=FwWTrQ4qfd6aLlXOmRlSOUgYxCoVufn+T4n0sPuF1jY2tBKRQWRf1pBPXdRr1HXHCW
         /leycaJAlkNRs5T5RPSludSm7wk2KN/QeSCHW0bC66i+SCQ7eYhLjPM1yTeupYdOu9rM
         hrneHKPC4skIzfvqC+TGlxlRYdYADBS36SOSbUysTFg+V2VXh0Ui4M7IVyKhEbBO+bSy
         GjQKjKEauw9BYYFaX2k5dy7YtMY06RIZ73EOVlk08O/BGUTqCKj7Smka2R/Eb5aY9nj3
         RECEAfWVwbFxEAV+jLuYx5X6hvxMYqaMxVBkNf5nXS7xTb6VaiaNQUb0OPrbhFhnndPb
         bH8Q==
X-Forwarded-Encrypted: i=1; AFNElJ9YFYuuHMzg6eAWGWor11v+CFBBhs9HU5A7VUmB3+TQFQUXhdlLBh+ZN5ymVkNvgSLUPBnKwCJDug==@kvack.org
X-Gm-Message-State: AOJu0Yyl4LIIMKLqcCQVt0yqI9otN7vI+Ny5SVucxCQdI4RQ8YHdXL1Y
	hGGMmiUd+CFisP7m7Q/A5BfxC+Sw7Fqxyk6nSAqDxjEmhY41I5nsG/HPMsvdg9KqVZBBoQ8n1BH
	2xohkbmFMpMNE2WOeooqNmm04UKhVCBR51w==
X-Received: from dycmd11.prod.google.com ([2002:a05:693c:23cb:b0:30b:f184:dc27])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:7fab:b0:2ed:27a3:eae2 with SMTP id 5a478bee46e88-30c070b3bf4mr148588eec.15.1781804200369;
 Thu, 18 Jun 2026 10:36:40 -0700 (PDT)
Date: Thu, 18 Jun 2026 17:36:31 +0000
In-Reply-To: <cover.1781803482.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1781803482.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <e82e6ec3eed46a93dfd794c66a9b7b11169df0fa.1781803482.git.abhishekbapat@google.com>
Subject: [PATCH v6 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E6C41C000C
X-Stat-Signature: pbpirib1rkfpxm7zig8347teqyarof7z
X-HE-Tag: 1781804201-927729
X-HE-Meta: U2FsdGVkX1/mLxZeVzIKxB6qQ2o+A+grN1pQYoCv8K3hmv/A6P+VooSHKeVr9egXwjAWrx5wUQegD+bNV00Aqojcu12QXZiFV2bfTbuixAcPC9384D96lj/ykTxQcw+W+BtMtYa2GzzcybIkkrMNfPr3sfLpKaM12Ol1BQxu0la2hvwp/84upbuYVK3pmIcOuP3GrWa5WgO0BjlrpTG7ggRBgJLitVSJw9oYCPulkXctEXGu5S+wiwAbh2tyHQFGCXlYUA0Hc9Nn16VUYkiiawzdO5zcZDrrMVmh2nSz5h9N11HmyZ+f5xwPVoBeXNZdzjq5dZqDcic2Pb/OzUaGHbi9KoKIVBNiKeiXO7mmsBjexsn/GG2ZQ5eFhyNhCvASe3I/M1WgZipg4DiktA4x1QzJpo67Fe4matZc/kX/q+k3FM7tFykFONapNzoZo/OBzCBVqzdiVtZkMmNrEnfiCI0cOC1hgORT2UqPsNt/uv4OX1d2Kq/9bYOwCuiByX20Ny9/+dQVnWWA2q6ri5e2X7Nj7XGthrVy2wZVwKukKesGf0uK3Shcr4akVOyLYLHgIF+I26+ctLxINRBBezw6/csr5OhWhD+BOMnUePYSEGnp4hveFGvcs3cvJvB0Pb4Zvxyh5jLt0+EWv0mPP+w8PYEL94eIMIMIrVHyMXQBEXFBG6TnWqPUXFXXqSPLK4jp0w7adsKJ1OQGw9viQMIiMHSZE0w7XFXzQs8hXt4RPforFa2aUgTeMjx0V0JQ9GS8pYzAVKqm0ar98XlVboMOAqeFRxo2UluNjw6XbxPnLcCq0il6n1ceUJQWaWwKLcZTIukTWxfAMROHgs75gdVlUnn9tPYpr8tE5uJdlbnuMrWPw2ZpW8carAlmN3ujPQSyq9nnMYKX+GRq+VKQnQQywYIQslIEkJdNJpDp2fbgHSBMgrXEYORvrVDyvKYNKDtJ9KDsqEqs4WAXSvV34hW
 lAvM2keb
 crnHPOHDx1j1Uq0f/IvaI4K6ggnigEL6BtDFTvwGlqtkbnKwb8AZwBRrnPnSQWzT6lSCFLsFstfIA9ltBJ8M9FpzIhgtBFVf+0hNuEa4RnocAQAuHjM4o6Gyb1tKvMcs/fSDR2i/rpVUWwOK98iXNC5PVZ7N7hmBvs2MIARVTYLALOHyuxscoC/xACoV69Sf+WvRpJcyNqKEW7bILIP+09mNoBprY1prgWqhvTpQWCI0V3AwiFbYNMHOHq7SC8pkkEGfdXV1iB8FGY+t9hs7nMS7S/8nj8m78HwzrXxQIX944k6BW1NTi6QvEncL4udI7yEHHUgXGcEoTU+fA/okZeWSgAFGnCgVQkNHaar4hErxyjBwog7d8GhKaFXRfQ2vo7EwfrRjlmMgkh3zsk893fedOhz468oZrGN747+vWI9YVhSmXsTnOOVI+gZU7JUJYGwbb2E3OEky4FQYDlSHnmJZW1WLSVDvwJ+mZiId1QdNEYCiqDabQSxVO5DJCbLm2CLfXGrz7EoNm7GWt1gbPyy8JXLR/hKgRfNy5uhRxhb7yaroQKotZShlib6mBMMMwHEVDQniDJrU3XQ6VYGO2fce9gTbJxpM3XaoJNPzjK9FsPIZcfG4FHWQkmuk0XhbxHVtBewWeu8+DkYsGxjoidBAPymkfKldjL/oH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the capability of the IOCTL mechanism to filter allocations based
on tag's module name, function name, file name and line number.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 include/uapi/linux/alloc_tag.h | 26 ++++++++++++-
 lib/alloc_tag.c                | 68 ++++++++++++++++++++++++++++++++--
 2 files changed, 89 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index ee6a023cbaf4..13e9b5916bf5 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -45,8 +45,32 @@ struct allocinfo_tag_data {
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
index c73195000830..f00d731b81cf 100644
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
@@ -191,6 +192,12 @@ static void allocinfo_copy_str(char *dest, const char *src)
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
@@ -230,6 +237,40 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
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
@@ -238,29 +279,46 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
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
@@ -301,6 +359,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && !matches_filter(ct, &priv->filter))
+		ct = codetag_next_ct(&priv->ioctl_iter);
 	if (ct)
 		allocinfo_to_params(ct, &params);
 
-- 
2.55.0.rc0.786.g65d90a0328-goog


