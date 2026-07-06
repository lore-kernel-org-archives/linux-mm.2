Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BAD04C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:26:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 21C0A6B00B4; Mon,  6 Jul 2026 14:26:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF0D6B00B6; Mon,  6 Jul 2026 14:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E00BD6B00B8; Mon,  6 Jul 2026 14:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3DBB6B00B4
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:25:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1E2D91C12D1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:59 +0000 (UTC)
X-FDA: 84959180838.30.87155C0
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 6ECDC40003
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ARyP+/9X";
	spf=pass (imf11.hostedemail.com: domain of 3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362357;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wii6nX8AGBJij88y/K868cO+98u+SKZQ5HlBNi/w6Tw=;
	b=D8j/sAeISY8bN3W+grl4cQqMXPJJ6vW+0xNzwKlrfApVKDTDHEgbMTdI1lofcL8PNeKYHI
	9sMUFFI2PJPMoGmSmu2Gdr35SaBOwoif+ttGqj5lx05S+GFvF67xGEmZASAi4KOxvuPlxy
	xn5iw64DXk92hzzltJujL9YfqqKFwAU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ARyP+/9X";
	spf=pass (imf11.hostedemail.com: domain of 3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com designates 209.85.215.202 as permitted sender) smtp.mailfrom=3M_NLag0KCKICDJKUJGMDCRCVIQQING.EQONKPWZ-OOMXCEM.QTI@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362357;
	b=lrf0OZgThB2jL/P3XA0WfQx80qAzln/PMG9u3+/Vs3jUKbPsOE/Ye5gczZPwoSLJuZ6lD0
	cAAs9cAkEb/yBc6z0tIxKVPPBDUlX95MMXs0XLfdn9G4zNlaO9NctaARDEfqEiaeyUfb/C
	FviFEYCm3B8MdH6+bbzPhrJuI2bLSrA=
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-c88ab059052so119510a12.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783362356; x=1783967156; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Wii6nX8AGBJij88y/K868cO+98u+SKZQ5HlBNi/w6Tw=;
        b=ARyP+/9XqV+4ZCPIO3ko/0oz/gARqO+y/r6rkOL1CZ8ig/i559JLFr5fyooyy0IUcR
         +1cYc8zJ7WGGPw/rC7qK5wyb4/j91ktuZFuUMNg7XF9d+rzw31tKFCHI74DlaL+T0xrP
         Kr8+x2MuHEQNVn0HarH4lGGIdMpRNyp1UrH9G8HotbccAqVtqx0ORXZmquIb0mHkNqGs
         Kw4K02aMlSIbX6KWs0Y9bYdaFmlnW3r05/exirp94wEyOe1ltPmLaVgp/MY9NchBg48f
         fYvFVsCvCTgGgCYZWdfPssSi3EGzC2WzNmsDt+02XOiPjSOehAPl5VZshdatkdtxZSHx
         a06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362356; x=1783967156;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Wii6nX8AGBJij88y/K868cO+98u+SKZQ5HlBNi/w6Tw=;
        b=rvB/RFMOYlVIvRYGqQO8NyZzVGpFVVw2G4bRFmi7FqlLkLSW+3G1y2krZAvQvhsYG2
         juM0UosGZ6Z85dGJzlE6n4aBiN/lkZxY+HJja3XisCebxrR1Ko/8jRP56/RI1LG6uDmq
         qwXEKL7l1aamVycRTnHA68y6it3dP/3jvRArHymB6riXYAEIo/aJtUnH6S3pwvTDGfJZ
         wFp/ov4AsJd2VMmJzA6/5jGD4vhh1XPj85zQMelpe6FxXG97/ZubXGOvc5mfQulUYBWY
         A1O/6K6MnFbF3OevowUVuEq8EjfbKcf4DyAbEZOkb64+i1b4SyqDCYlGE4WPgw+jW/vu
         o7+g==
X-Forwarded-Encrypted: i=1; AHgh+RrRFs3JSmmGZyV5gDJbeiHaNUu/mUu/b2bsvrENZ59soHIrFm5nLl7rxZQgMGWkD5AsLJkwbs+bzA==@kvack.org
X-Gm-Message-State: AOJu0YySdUoP2YsgDg7mcgMyYg/9YgHZDC2votKoPaMZRGWmU8JBBgi/
	BwRLAB5NLW4sFnwat/PnwI9mPCG5h5fPJWUBKFZ7DB+MlwLLcPbN13uUolZraOm4OPwUnSli5Iv
	2WQBIV5d1gQKUNltRlIf9j8MTZkzaUgQj9A==
X-Received: from dyuw16-n2.prod.google.com ([2002:a05:693c:8810:20b0:30c:86eb:3114])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:938e:b0:3bf:a8fa:a7b1 with SMTP id adf61e73a8af0-3c01cbe495dmr18148893637.37.1783362355996;
 Mon, 06 Jul 2026 11:25:55 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:25:45 +0000
In-Reply-To: <cover.1783361692.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <b0fc4d7dc587aed6376a29bd8dd03896cc1e1704.1783361692.git.abhishekbapat@google.com>
Subject: [PATCH v7 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6ECDC40003
X-Stat-Signature: zz5fn5fa39qs3196qh4rs4ooxipz1rse
X-HE-Tag: 1783362357-139003
X-HE-Meta: U2FsdGVkX18cPB7hc5tnid4Wyp5Fq79JZw5ZWIu90eIAOuoHEXWRopEGD7QD8CJBS8i6oaHK7e5ehE3TVj0K2Wfqey+DxW9+KOc2Chm6FQGx8SsjBrHuiRPY7vOYb1/ZjN63bOOAwx3oND1SC+OQ6BLhCG4fRsgEMmKB83j0uIG/qLV4nnSOQjHpQg+7ZL2gTsaeuxikDJqXPN0Mef60DOBW6Tw71MHsxWchhkrrcV8P1jn3EmQ1V/3sMtizVfPDJBdepfz4Yi7+zGL2LCbMrReVo55JMvPVXaOL5u8sSoepDxF6V39CdUJaplvC1keQFEheXs/0BYAwdVDsayEScUOtRySNNrfpy3IUPPTq26pjZLNBleGYLG+19xz8bvg0NJwiMfpDfpp/2bQTnovkSSzcPp+7CIvGMeTSQZw6Rrsdpvsj3izZnRX5a/ssoxxzjtn5bl0bpkcAMxSbhpvpkV0iYAGW0Pe00UPAox919Uq6m8rL5Eh7DPsmPGNXSR0bBXpuPKh3RiGFmtTm4c0SmXsoMFFV6/8I6HyUAPSemZin7KLZbwdvea8pojQP1azXASoHIEjh28a+pCZKuvY7yBi8vZ+mCTJUnf3Dk1yoJLVkX5cN7O70056C/gKaofDK3D1scMPaFqRkl2wzVK3+Rlz2M6UFBCa7/tUACULE6Hi+VE3O55cfwtEqN51Zyb58Ph4Td5krAod0XuYJKUiQiWFBBX1IAPOtVVDDdN/PS8NlvXhiz/3HlUQ5t82IF7rnPTj6k/7TzGJ4PP76arOPFwM3aK62cf24AMqwQBmzcKtXTeuyI4Nd6DhqiPUTCKvFCCkrfHXiEhqbyl7npRkzk1r4lzZy56gpMn+0Q0X6wDKzJSJxuznIyq7dMhfaiHPvL77jwjxpmvLgyXgUsyaMRK3waY+ZTH8JfzL3h2zT+eI20Hdiyd2UMzC5roU8gWfzIFb3oc6KZqMhoQyNB24
 xwNk1WpD
 j/Rm9WSi8VI7SAfua4XeGL+A/6HmzFjVSoL/DWhv0rT+A4GjAFBG73WxYOIu0Svy5gjKzAfPeNY0Bwy0a9sSF7oZ1EMCoaghfMyhnvq6/fYpKcPYuky+IrzEbeUS3+TzDrRWeNB+PNglUoxKRAIQf/YMSfvr2wn13wX3+QpvLdOY7jkGPihLst5M/tLzcdbQS9EXgD1cvCQhM7BbHzP5XfLPjK+JoWuKCipQK1TpH7e78FAEBVFl8WEz96vlfzMVj7zrXoeiRxAfk6FwKna3UKPkH883f4Cq7+GstSQs84MdXSUuz9YFG/QRCBzBPUhSesjl7WC51fuEf+8rKq7fsvYlWHdO2VlKtbiwM9cHnQZaEz+q6rtT9IpkqI8PFV7p6LLgSsMyOaZckEXMN0aLUxByspmhOCn1Z5U9Ob6A419Wvd9wdIyW1uTTUMVb0a8HIrCyKdUrf14kuEfZVcJ8vb9D+b1YBqKanVYZo0+a21LOADF85TdD86A0gbDc5mHls+qEQZNhBBQ2kDrlu+t+fVHPmbL/yrgOuePKNqIvDoi7KjdkDZMPpVe9KkEPjsSHxMbAT7AJSGpgIXio/3az0D4NN7kGXwZI+dxyqQ2zyqhvrfVG30oarGA6tWlkBdzDrui2S/BmsDG455FToyurT4FTrZdLjrBA+hUxxOJ6+3uXx9EmM+JrY+kUC9E3aOLWcPzfXAq9WZehVcMM=
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
 mm/alloc_tag.c                 | 68 ++++++++++++++++++++++++++++++++--
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
 
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index c73195000830..f00d731b81cf 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
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
2.55.0.rc2.803.g1fd1e6609c-goog


