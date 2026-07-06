Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CEA7DC43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 18:26:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACE206B00B8; Mon,  6 Jul 2026 14:26:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A09D56B00BA; Mon,  6 Jul 2026 14:26:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB9B6B00BB; Mon,  6 Jul 2026 14:26:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 55DB76B00B8
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 14:26:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AFD9740118
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:26:00 +0000 (UTC)
X-FDA: 84959180880.24.1475AB7
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03A3018000B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 18:25:58 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZnTfic7S;
	spf=pass (imf16.hostedemail.com: domain of 3NfNLag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3NfNLag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783362359;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p7fUX0ZdGauLCkjWca8P4cqWqvbciuJ9Brjs9Fe390M=;
	b=N+6GdwuGgIfzRmGTCdkCjuUTYhXtxFbz5TejM9unWU5shR+Sy4MBBbsSWdX/Wg9Mnme9q/
	XxdWYOUy8FpCd3yuIRyZVa3HcDyytzRPcz3zUvrq5V0sJvpk7aLP97Z7pG4jU53khglglT
	ZKB2t4SWkKd04tGjAqRgaueHRN16y9Y=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZnTfic7S;
	spf=pass (imf16.hostedemail.com: domain of 3NfNLag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3NfNLag0KCKQEFLMWLIOFETEXKSSKPI.GSQPMRYb-QQOZEGO.SVK@flex--abhishekbapat.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783362359;
	b=DgiM6oNYI2kwFMdGPWG6fK/QO2kxsXCq30VcYndUlbKlnWED0vXwznFUAUwJSzeRz4l2Zx
	TbCBxdHRw4uV4WrXSD8mXkFyK0bREgiydm7vZC9EWCyZ5if4DBav1xJijhmy7Vf35E7x+y
	7Tbz0kZjzJbxwAIEZlEnRJxGAUFBOa0=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-c88cfe287e1so2393371a12.1
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 11:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783362358; x=1783967158; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p7fUX0ZdGauLCkjWca8P4cqWqvbciuJ9Brjs9Fe390M=;
        b=ZnTfic7SO9hpeUitnWm8rehFSjOWygl3YJBgzQpLyRUZArXsyo3eOAIDnwidq8OKGk
         DJRD1PLmlJb0D/0bsLRA7QkzWGO4rJxVwHdN3VJLY5GQGHprYhjw0gXgRjdy+lAWh7vS
         QdFKqQHNncg3x7NRlh881ibqcPQqARUFIopI2M3Xlw9Q8Xgmd17p122bLm6edpUoJ9N5
         8kpyw4OdVuY8WoXmH+97yZpJ8hJ/heJPyHCSHxqkOrDTFjr9wpKU9tkzNi1mBi9gzt44
         VjUcb8tMrBnr5FtkW99UUe+pUeHEE71PHhg9ZhWQGJeE9qQx/uzu73zsG9kwUYYLNVr6
         G4vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783362358; x=1783967158;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=p7fUX0ZdGauLCkjWca8P4cqWqvbciuJ9Brjs9Fe390M=;
        b=hPLLB338CNAGDpckEVF9X8y/I/7C0opPMScohto6h6ipQQVB/JtI/RQSaNLF9a+0Y6
         lIf9wkhTEK6fg41wh1LhU3DH8aHwUwqp0BjJBznIvXLbL425CCEIKjoHGVYAwxSEmwFX
         NMNeHcUVtfZwcJCSxrslZDBq5BXi4bvxeRvjt6w56T3eaQqtROZwvSH+mMu2g2G9wjts
         s8LCyE0Cfl0g9GUBVfXiizKl+1u1iZ2vjYf0l5DG51gG4rM/CiaJ5EbF4Kitjv1Yznwa
         1t1rTsKSgREAV/RxjovsDdNeXIs54hiNIxRBavYcYjdaKZhL7qMMT+3QKPgvxXuQSzvd
         g6OQ==
X-Forwarded-Encrypted: i=1; AHgh+RrWC55xjEVvcUi+FbmtdGZ54pkqyuW4DevIgIUg8IgCpVgagfN8nHeBqFeK66i6TBdZAS6C2oGN4Q==@kvack.org
X-Gm-Message-State: AOJu0Yw28x87lO7/ITC7AjA7Bg3ZLtQCebcbaqVqgvi91Wg8h/N/aYDK
	jikFywjK+x6a8ckcdkWpBJDCvgFIlGLmYfLshuW+w9jVK8wi5YBXY6+ih+4BzLKBm0AcOcs7vrR
	EO5jTF2xLhZUe0q714pgsVIt3VYeTxQVa0A==
X-Received: from dlbqq2.prod.google.com ([2002:a05:7022:ed02:b0:138:5e8:1b36])
 (user=abhishekbapat job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a20:d70f:b0:3bf:6c08:2b2b with SMTP id adf61e73a8af0-3c08ef2d409mr2321399637.51.1783362357729;
 Mon, 06 Jul 2026 11:25:57 -0700 (PDT)
Date: Mon,  6 Jul 2026 18:25:47 +0000
In-Reply-To: <cover.1783361692.git.abhishekbapat@google.com>
Mime-Version: 1.0
References: <cover.1783361692.git.abhishekbapat@google.com>
X-Mailer: git-send-email 2.55.0.rc2.803.g1fd1e6609c-goog
Message-ID: <a686bb6fb07778c8ca73ce0419f938f518f4dc17.1783361692.git.abhishekbapat@google.com>
Subject: [PATCH v7 4/6] alloc_tag: add accuracy based filtering to ioctl
From: Abhishek Bapat <abhishekbapat@google.com>
To: Suren Baghdasaryan <surenb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, Hao Ge <hao.ge@linux.dev>
Cc: Shuah Khan <skhan@linuxfoundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Sourav Panda <souravpanda@google.com>, Abhishek Bapat <abhishekbapat@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 03A3018000B
X-Stat-Signature: wkiuhwm19c84nyjnwr8s8tnah7m68g8w
X-HE-Tag: 1783362358-658169
X-HE-Meta: U2FsdGVkX182IUOpGBjq6kjcohPzZGkeDCPj8siNqC06qxgBldK2j7c+qEx2L+oo4g0z0p9QGNL/cuqRRVo1Bm+9wwzyTr24P0nhwAAxWlU+kf1nn9FM1HvDl3F78t5BztwiNzyUpfhLYUq6Tda/6/zXmmQEvzX+tALBVlK09V4x2LP/e8J1w8AhME4y/FAvRXTxgcyXAf4peNAv5vYfIdPHk89GYPQHuJbsp33ny4xEkRUF9JVXxGVZw8BC/OASfsQRu+KhyqXlVHn/7Z6tbkrsTd0gyA51yxiFdj37JGDeKcG4nH20EEILpbHjtVM0sieA7ssCne2xSAdoQh1K3fkrIlnVO0qPIy9XPp2pmiUCUkWAmJvvQcrPdXylj0NllgBEaPivLK+5AOjeq99UfoGxJ/2yZG6kG0LkPSpafrdWCXLX4X5xoT4Dn5r3zWLvL6wpu3VpLZNgOpy0uov+Z8Va8ycSeuu1svyCPXFhZ79NFEkDKMThb0ARbmfcO/lvyvTK01E784EDmZyWU9Dq4pp81gXKuGedlO7ncV6RvKGPzax2Adi6GHdSDn7k8CztVEif9jaxoydC5uWI80rBhiu5giCKQ+rGAbwv8ebQJtAZanB9HKPtszJt9o9kk9uBbWaVgVh/OW3HoMgpSHosVWDrWhvFNYR2ihWEnPvZhFvpK/0TkOsojmUVgJVfCEjUBKYwynbbmMlgv8bvn8gYz20gM2JjbakIYCKZukm5/RYlizBwLKIGNxiR4QL9T2UcfpLnMMuKy8M1BGvpdz7pNmOIDu4ruZC2JpEudLh8egvb+xVGNmvN045gjXBIOZBTmPLfKsmAlShIT4x2PJKNUlFagfhMKu+MbljxOeMLCAkS9y9/i+9DV20H4qTRDfgmnidS3wHoHC/ZxSCkaUSpArRHK6EzxBBPiHU2ahuAIq3tu+Zs4PYVpjAamL1C9kFw9OPRUpYnWI/nMghUWgU
 bmvA4xDT
 AEStX28NxKKuqgTO11mOPO+94YXK8plmjshq0jjJmSQWhAB374Grp29bk3Zy4YSvUxbWZ3v2AKFKcb3JAw78p4mssnqcWHE8axrdohzwPyDL3duVsNVno/h9109qK99N7JwcHqwjsMInZnRvqwIB1T4lhm1W76yaf7gScgavgxVpaDm0yXtRj8VgfSoVX6WrEwwtob16kDvaqwMuhkihBCd0vIXCuTC1/HlekDArT6f93XwSXPYrMfWPPkO/lBeVoSdRZQRGNqvAfqypToa2sM6nHJX4iGCaNoDHwnA7l/ZNVHDNeannM3z+KODNPA3Ji5mZlvxDHMmj0q1hkFyWLjP+eoWG2IogfNFuCjnIRAq/F+InH8bkwI4qUlWNqP+1j3fWdqIslGI7i4m2+8aE8XWzjZsr2itC7Tu1YYrPFL4P3Od6zR3k1jN649WoHjLRxcjUwaawGiD1Iq2CLnzdaN5JcH5N8o4ixdfrxQe4Tr17WpEqaBkZCQG9gTri2ReRxphRDODXIf/dloGuj7xzfydfA7Pj1jQDW55f/jBHUi02E9vP12g8+nAHVBazkK08JF5gULtFi1+5QMbNShEHjwnr4lOsalDHM6zKdhX0Ri/V7gN6+oY2MP+b5iOosN8XUhw6E0so0PFlWKkS1KhtqsO2VEquAFknaqk+uHIfmAgjSLY0GDwzWBB4nmm5ZquMjjzOQeN4kw7un0mk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend the allocinfo filtering mechanism to allow users to filter tags
based on their accuracy.

Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
Acked-by: Hao Ge <hao.ge@linux.dev>
Acked-by: Suren Baghdasaryan <surenb@google.com>
---
 include/uapi/linux/alloc_tag.h | 4 ++++
 mm/alloc_tag.c                 | 8 ++++++++
 2 files changed, 12 insertions(+)

diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_tag.h
index 0de5fc180790..270f693b1822 100644
--- a/include/uapi/linux/alloc_tag.h
+++ b/include/uapi/linux/alloc_tag.h
@@ -31,6 +31,8 @@ struct allocinfo_tag {
 	char function[ALLOCINFO_STR_SIZE];
 	char filename[ALLOCINFO_STR_SIZE];
 	__u64 lineno;
+	/* filter criteria only; see allocinfo_counter.accurate for actual accuracy */
+	__u64 inaccurate;
 };
 
 /* The alignment ensures 32-bit compatible interfaces are not broken */
@@ -50,6 +52,7 @@ enum {
 	ALLOCINFO_FILTER_FUNCTION,
 	ALLOCINFO_FILTER_FILENAME,
 	ALLOCINFO_FILTER_LINENO,
+	ALLOCINFO_FILTER_INACCURATE,
 	ALLOCINFO_FILTER_MIN_SIZE,
 	ALLOCINFO_FILTER_MAX_SIZE,
 	__ALLOCINFO_FILTER_LAST = ALLOCINFO_FILTER_MAX_SIZE
@@ -59,6 +62,7 @@ enum {
 #define ALLOCINFO_FILTER_MASK_FUNCTION		(1 << ALLOCINFO_FILTER_FUNCTION)
 #define ALLOCINFO_FILTER_MASK_FILENAME		(1 << ALLOCINFO_FILTER_FILENAME)
 #define ALLOCINFO_FILTER_MASK_LINENO		(1 << ALLOCINFO_FILTER_LINENO)
+#define ALLOCINFO_FILTER_MASK_INACCURATE	(1 << ALLOCINFO_FILTER_INACCURATE)
 #define ALLOCINFO_FILTER_MASK_MIN_SIZE		(1 << ALLOCINFO_FILTER_MIN_SIZE)
 #define ALLOCINFO_FILTER_MASK_MAX_SIZE		(1 << ALLOCINFO_FILTER_MAX_SIZE)
 
diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
index ad33d63ef7b4..32ac0674d8bf 100644
--- a/mm/alloc_tag.c
+++ b/mm/alloc_tag.c
@@ -249,6 +249,8 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 			   struct alloc_tag_counters *counters,
 			   bool *fetched_counters)
 {
+	bool inaccurate;
+
 	if (!filter || !filter->mask)
 		return true;
 
@@ -274,6 +276,12 @@ static bool matches_filter(struct codetag *ct, struct allocinfo_filter *filter,
 	    ct->lineno != filter->fields.lineno)
 		return false;
 
+	if (filter->mask & ALLOCINFO_FILTER_MASK_INACCURATE) {
+		inaccurate = !!(ct->flags & CODETAG_FLAG_INACCURATE);
+		if (inaccurate != !!(filter->fields.inaccurate))
+			return false;
+	}
+
 	if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)) {
 		if (!*fetched_counters) {
 			*counters = allocinfo_prefetch_counters(ct);
-- 
2.55.0.rc2.803.g1fd1e6609c-goog


