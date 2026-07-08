Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51584C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 18:01:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 404346B008C; Wed,  8 Jul 2026 14:01:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 365866B0093; Wed,  8 Jul 2026 14:01:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC086B008C; Wed,  8 Jul 2026 14:01:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD7A06B008C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 14:01:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2619E402A1
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:35 +0000 (UTC)
X-FDA: 84966376950.20.FF40044
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf05.hostedemail.com (Postfix) with ESMTP id 319C110001A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 18:01:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TloUrjyB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2+8XQS9kX86TaKTDVFizNxuv4HEp3Ew7yMZEy877UDU=;
	b=NLUj9DTK4/OeC64Sd1AkuaykR9Xamu2CQDRpWKR8ob6kwjwmsQbENAxkwIuor4l1dx/S+2
	pzw47DHIjDqkxT+MDHn3ol5xcqFKDEFu1bHMpKEDJt1ItsOy1xnmb2rGQZVgm0Lb6bMj3K
	IdEksazi8PwnJx9YAID7Wbtz01JHBj8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=TloUrjyB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3e5BOag0KCDAMNTUeTQWNMbMfSaaSXQ.OaYXUZgj-YYWhMOW.adS@flex--abhishekbapat.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783533693;
	b=wKg7xENj8FkStx63aO3k3BelqME9wANfuhbH5jrkmwhhnivgyOEC0rVnhA4xrGTggqbaYi
	iocPJBvFvNjaYsVfQ9TqHoK+JFkPKKbvQPAjSIj5EWQaxczn85NYjlwU0GqR1stkQUAMQq
	5Bhzr3Vx0ZeAT1Sa6eD6NxNBG9i7bgs=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-384419c6c74so1349612a91.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 11:01:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783533692; x=1784138492; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2+8XQS9kX86TaKTDVFizNxuv4HEp3Ew7yMZEy877UDU=;
        b=TloUrjyBlfubaiJOcRrspisDiTryq3/z95AgECxWpNaoKDNekKS762Tv9kXVCgbU9P
         wlUuzTaF4GVUiu1IXJLN3WOibe+dOCCLWY8dQ2wQmnawHxmT27AhHUqSoh2Y16L0af7O
         Xz0Dhd+oFYD7EPUVOrrwpuEG/3d1T0dmNyt4ZIp1/pEaBKKzzuEuuJPSFtkhV25EQpA+
         V3uA86xeIy9pm5iFH9Zhd/EdNpy/hAVb/BsbT9rELBCmCoIBYHvN0+EJWf4DibbzslmJ
         kriEuXWlp8ybAWEJIhjjA4fzTEC96PneIbXAhxswU+UH4x6oBd6txulFClOZXQ6998fV
         sNIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533692; x=1784138492;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2+8XQS9kX86TaKTDVFizNxuv4HEp3Ew7yMZEy877UDU=;
        b=gn6+CANFYL2C6lVkIJvawHI2LWHDJnKBtR1+Ywx8rkqCwLKXm9AD2bCgj7FygEBOox
         qgBCixTZrMAibFeNyPWu4XzJt9YoaTk8IVbLjTIwyuTw8lRS1sUexVMqrwA3aM29Mroq
         KIHJOOND9u/y6k//Gf346NLE7uexNav49/ocYBT1SNyNn0cnVtvA1Auzl/UUizeebXcy
         k0FP5J4bJ1coVWynNaLaOy6mXgTpCiOCoVxQwHf8PZZnCi1ETbmxHHLtidcuLBX+bIZ/
         x+vMzOw7QPpQyfrPYjPHp6gyVTyseTAZHDO0myQbXya2du6At+BfFK9X35Cns3BirgxV
         8SkQ==
X-Forwarded-Encrypted: i=1; AHgh+Rqf1Mdu1TR1Y2dT+OPLhRB9qA3Plz+HB6YV7VpcfozLGYKBtGGcou7NVNN6fqn5Y47RglqQk10fBQ==@kvack.org
X-Gm-Message-State: AOJu0YyguYTnj/Xg4R6LuFhBaDFHqFhPAD/hx/LuR7ZfCp7UkFU/isaQ
	5XvJHrZNxxKtEXcTRmAa2O66FFpcc8qS6IE/eqDwXeVURi8t569vaixhC7vJ2yrvxRLzG0KtKRp
	X03Ncv2Ydum6/hSAGbey320zCR9k1KJXZHw==
X-Received: from dybmt1.prod.google.com ([2002:a05:7300:d581:b0:30f:1e22:c0ee])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:2d87:b0:382:5c31:1f8a with SMTP id 98e67ed59e1d1-389421ae167mr3972883a91.27.1783533691909;
 Wed, 08 Jul 2026 11:01:31 -0700 (PDT)
Date: Wed,  8 Jul 2026 18:01:24 +0000
In-Reply-To: <cover.1783532853.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783532853.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.795.g602f6c329a-goog
Message-ID: <6a6100c0c58cb2911f39126b9fe177a8c17db16f.1783532853.git.abhishekbapat@google.com>
Subject: [PATCH v8 2/6] alloc_tag: add ioctl filters to /proc/allocinfo
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: mwu7wniahux5am16zjgmjf6cwm3998jk
X-Rspamd-Queue-Id: 319C110001A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783533693-448598
X-HE-Meta: U2FsdGVkX18/w1hTn2PaqLT1c/oue/vbYclz3/IiRjG1E4KYRjOfDZgLnWo4pVQyRfphJMhtKI0Fn11DU4KjXU+c268foyAuWiAQ7VET+mvTl7hdAuKhy21k7s+20eBVqMIDNiR2NpAoWfq/d0jxg0CsjMC9TN/giYauXDMrjjDN8iNGp+9DjJiJyTTEsjiAuiafT++ua6V0quTN+l0My0VjEPoUofbbynztozHS24yN8AdRinXWQIj2pBuL2fF9LbqlIfulWREF/A8jO+mS/EXD/lhP2gYVX9WGF6WFSbZ1RVsmxx9wRu6bDq+A3UGo93PJIoBp+qQUPmnnsNL4DLaW5HXP1ka1KIePyp4DMHDaFBzJXv6IKqSITh3DAwXdkJzEOA/nx2OzAhfOMd8XHBv3ZiAfs41hjqDSqLWSaXcUgLPiWRHyzu9PBDLJzhaz55ufmme1D3cfXEuzXM8WYe4Yb6tb1nfKzszD1H+EUEHSJmf8AGLtwwFVqUt5dFPLgE4xWAUMm97zsFs/9WUKvXtbFLPdgx/ugbiFB7ZsTQhQu1+WWgSdc+Ni1mU6TkOOalZsu0TMjS1Yrto3x/kCDjG3gqPQor3TSH6nL1Qt6pc1j20JulsPyGNAzcUKSdzrybUcZ5ePpWQAyUiGLOGsIZZKqBsgc/d75+0v1a+1tRtqRZlKrnLGHfimsw1NqUW1vWGxsQg5lxbZXZYHZ9kpLUs/YitYNHD0g9NCIxzp+O4O2pRmHz9ObrqWCVBAJ+BDaLcCPfTFUcUKJ7GgWzxej3GOUDuAdouSKbEYvfHLGnZds9JKgV4YzQnizDJcLhwYjw6Cgw0I17LcOR40w4cGi6+AVoMv/S+26Dj11gocL+YdE79rYCYJs36nt0yWkPezoxdJdJgK+JzsfKs4DJdRX0COfHEqwfaMrGXI+bGdeBPaz9xjC6q/xqF4HhOp4teCyoLBepi7GgOLwO302PZ
 sLP7puKz
 fmzFsJ3bhQS53YAK0UzOMb4CvgUiA2MYkufBdJKitXUBvzLPC1WR/k8XW+hMnva4gxyF2F7IuAkfwQ9wki3l8SwTnBBO/juMnqMZ+rt2+TjL0zzOsXUu1porrL0OfeTvpwdhjuyAN8wJbqCrpms1HSRuU38v8QLTrsCX13B6R+lcmbJgLDaKoqZ2BAWAyN+eDNFP6Wf3A8Er8YK+6eOwb8keoakJF5UrZnKylBd51Q2liWgGypSdcLDJvop3QZ6maep/Hjh3IAHVv2UMNpR1O1SZraR/HvbGbZnRDUEVILReeHaBek3xc5lI4HfgmbQfirQ9fyvYLmzrvBrWPEOoK0X1NEAqhim4eEqOBlqFXrRF1CHBZ5Ui1cdDpmTRmpV1NKkK6DrfSee4OyvcMiHDzCvnZAV0/BjhNkgwy5tG6XCw/OS/tUN2ZAyw5jDDDa22CQlYzIPZ9poQSuDarcZySE7XNbklHyrve0F3lQcmSGRI0z9oAfv/R6ltivrCDz0Se9GivapMwDknhl6Q4qcbCVZcDde3QcNaCtZoQYPr1PNcL/zs+NwMlgZJPAd2xYHTROiK8Xc3QN85h+DR9cYArkvGs+tUCUdgRM7CXGuP+e6dUdF6g0EimYBs13smNbO6CKOBXh7a3NWQOS1ic8y1iiolWObH3BlmidBc/a8qQX/CkPR8v00ZZcwdRg7WLJZOrYqGc/Vr4vBWPsCY=
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
index c414117e1e97..aa67c156bc4f 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -52,6 +52,7 @@ struct allocinfo_private {
 	struct codetag_iterator iter;
 	struct codetag_iterator reported_iter;
 	bool print_header;
+	struct allocinfo_filter filter;
 	/* ioctl uses a separate iterator not to interfere with reads */
 	struct codetag_iterator ioctl_iter;
 	bool positioned; /* seq_open_private() sets to 0 */
@@ -194,6 +195,12 @@ static void allocinfo_copy_str(char *dest, const char *src)
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
@@ -233,6 +240,40 @@ static int allocinfo_ioctl_get_content_id(struct seq_file *m, void __user *arg)
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
@@ -241,29 +282,46 @@ static int allocinfo_ioctl_get_at(struct seq_file *m, void __user *arg)
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
@@ -304,6 +362,8 @@ static int allocinfo_ioctl_get_next(struct seq_file *m, void __user *arg)
 	}
 
 	ct = codetag_next_ct(&priv->ioctl_iter);
+	while (ct && !matches_filter(ct, &priv->filter))
+		ct = codetag_next_ct(&priv->ioctl_iter);
 	if (ct)
 		allocinfo_to_params(ct, &params);
 
-- 
2.55.0.795.g602f6c329a-goog


