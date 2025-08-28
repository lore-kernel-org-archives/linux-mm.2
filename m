Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EDECA0FF2
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 12:28:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4CE08E0017; Thu, 28 Aug 2025 08:28:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD6758E0001; Thu, 28 Aug 2025 08:28:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2A138E0017; Thu, 28 Aug 2025 08:28:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E70D8E0001
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 08:28:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B9421D9C96
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:09 +0000 (UTC)
X-FDA: 83826093498.20.9AC6D2C
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf13.hostedemail.com (Postfix) with ESMTP id 59E5920013
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 12:28:07 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RIk/zYVV";
	spf=pass (imf13.hostedemail.com: domain of 3VkuwaAgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3VkuwaAgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756384087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NT5ndZiyJJqWCgiYx08dUhX4e7n0TWvqf6AS15EwVrA=;
	b=7HOe7XPSnhl1mnP05ylwLAIf8RCySOXNHlEEKxAgFLAN/89AnqRHG2auDWG+QDdlWCqiG7
	ewi9cGVA8udF4Z7Lx9JBeJPY5YQ1kglX1vsCrPSTJO5rbLkX9BKa4HwPF/N9e8PxUwzvaV
	2ErktgVU5ZiO7qCf9K2uLxWNlTCGkR8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RIk/zYVV";
	spf=pass (imf13.hostedemail.com: domain of 3VkuwaAgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3VkuwaAgKCPkkbdlnbochpphmf.dpnmjovy-nnlwbdl.psh@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756384087; a=rsa-sha256;
	cv=none;
	b=MmcOdavppBbI0+Ip5vyVSKV5GQLbwqEOgo4hZB+kq+3ItfHB6K/je9kjHEsqCLiKXPjV23
	h5ZkgQL+eu+hkPPdggV7xNgZGwfKVQQU3dU+Zft/0rCUbLFJcYMx+GSePO6RrDvPawDp2M
	LCADlsdD1qXAZCGCAy35+fulxKW8l2w=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-45a1b0cc989so7007645e9.3
        for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756384086; x=1756988886; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NT5ndZiyJJqWCgiYx08dUhX4e7n0TWvqf6AS15EwVrA=;
        b=RIk/zYVVxZTDnApBR4GqZPsj+u3xh88gpXoQ7286H5Esp4KKMMDPu7wHLD39PV7RlE
         eqAZ9w1TYHL/mOGTEBFtRnP1RHDYkwl1eutkSrVtCjvDagJWPgkA3hCFeK2TRDWtQITE
         p292YvQ9H8sBLYAXh4SkAY/TDTI0BZ/E1fRt915uhF1FvvzYZQL3u/hV/U91/TBTclEL
         0LXu9cO6RCRO8CYXa0O9WtyySFVBhtxOHee5dX9b9+E4Qf4ZO401L0SO06rk5hd3LOAt
         SGzo114Ldg/dytcxp61mA6/vvg3lTdnLBGi6/dwDiiPr+aUjB41fuk7LniHvvXUx1t7d
         rdyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756384086; x=1756988886;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NT5ndZiyJJqWCgiYx08dUhX4e7n0TWvqf6AS15EwVrA=;
        b=GARf6WusS3WUn/B26LSObkbI4CzfwG4bzfy2gV8INgnRvPvRTra+vweRjIOGwNpZpC
         NnBUTY5lH2dmBriVFx21z2QjfOyCOM9NfTzFciSDPnY/POlPsURLThaqlV/s6cNLMyY+
         L6oRoJJbF3r2tUG9D8nrwZgk/0iI5kCSVdwPyJv9S+3LzEGT2HAlsPp+lc60WWTZPRZH
         QGzhJoEfYNo/Wp2qNacIwcujU4J84UZgSk2Z19sLKzsSplXxSP9PYhk19qhBpPSnxog+
         7TWJDv9R/MMvzUL3bADRWI2sgrHfJapTnvIQGh/Bq87KxG74RQVxkphDCmVP78u6DVzO
         e0MA==
X-Forwarded-Encrypted: i=1; AJvYcCUDdAlxfNunFx2EQGKT4cWS3Om7T1CBOgLaxHy94IsrReL/aIMk2O/OEYXfAhmthG+N24ooIkCxng==@kvack.org
X-Gm-Message-State: AOJu0Yx269am2PSWJkcimxYsHLhhKJQ0as/WG30ngGT+dxfttH4YO9oW
	jdJJ6YNRArgIB/6dGCXne/ML2l93f/n6yKII4P65S1GKJARhklcxrB4VHwR8A+G8TuO4YBcRW4c
	sDiY9Ow5ys28Ang==
X-Google-Smtp-Source: AGHT+IGJWI0ZFUz+7Oag9wdtFaUSV6+VfGrApOEbus6AYfztggP4vFm0mvCRRgVub8dgHHObAbgpSPShD8KaaQ==
X-Received: from wmbel18.prod.google.com ([2002:a05:600c:3e12:b0:45b:732e:5a16])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:1881:b0:3c9:24f5:470c with SMTP id ffacd0b85a97d-3c924f54bfemr12451964f8f.42.1756384086018;
 Thu, 28 Aug 2025 05:28:06 -0700 (PDT)
Date: Thu, 28 Aug 2025 12:27:58 +0000
In-Reply-To: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
Mime-Version: 1.0
References: <20250828-b4-vma-no-atomic-h-v2-0-02d146a58ed2@google.com>
X-Mailer: b4 0.14.2
Message-ID: <20250828-b4-vma-no-atomic-h-v2-1-02d146a58ed2@google.com>
Subject: [PATCH v2 1/4] tools/include: Implement a couple of atomic_t ops
From: Brendan Jackman <jackmanb@google.com>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>
Cc: linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	linux-mm@kvack.org, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 59E5920013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: jb9538zxjrjnr4obx8ydzx5e5mfq3kpm
X-HE-Tag: 1756384087-868699
X-HE-Meta: U2FsdGVkX19G71zXgz4/N6jhkU0+e3TVhSU6hFgKBF8OC5T7nGXnzCFnn9PV36Wy1IBIsZOlcKHJZkWBGpUr4cFYmT3R+Q3VdkdmeW7PJgXbo30gAEKpfm5gAjCNPtyaahH4pCS+wJjfDmrbcXC6NJpsWFhZgU5i+HF5lelCQFLtkAS5hNUmruAgZOOPFvmCVAq3Rpij3H3lB9RYrlIe7WVLZLL7ZX+4hwjm9YK/tTelIAmC8thMmF72Dq1guFUGhJZRKjUsUh13Hmllshr1+U+rUjvTRpg6Qb8nIoO0JtUsYOf0qNiOqL4L3glx+/76CGCO/wZxCrkPPqdnK48Ivp67KWaKHE1UikxAnSFtOWms5xZiYu+4IfoxcXJHOU0NLdoQ2x67T29a0efEd9dC/ioq0eNJTt2t2sxjColwyh2Db5Fst58rgX+CUPyLuE4pypbXx5TvajRB4HXQsQDkXnpF62b9JJYfwmYhPG3emG9rEQOatamd6xd5lK+DQFQI+44dxy73Iw2xBDuV9v6vGe8tdekOCcruXuh2awmgPG1paVjNIsoM48Xt4ZlrCjFtmrOzWwU/9jfCg3Q/BWyxyjnct30G5AFCrJVdzmNlG3lxaJhrc+vmBheaZYtpXUyMc/1kfOsCa6DFKZ5QriRlY/8NVqsqHqy9TKFr1reZzMz2xxa43KvD5UnzVnnSi1cvDycnBf0tdfwbm5b0uQs2h9oDwPyscZ5gKU/DJFWiw7W7gcnyEGa++4RqGEbwzka/a0f8gypabRIGA9eonrjxRuUk03wMnuCk6aqp1xTTY+e1FMyhQKkJtyO3R9iYBpD0oAJW4uRaXe46XIxJmNQS3KrH4TF7cCAtf0KEi/XL5y7+TfBlxyNX3GF0sgG7E0TE3annBSb292J1g3FljOg0HCidCQdVLh/KKh6bC8Piq4pNqkey3/JHKo/abD+02k/ByoGd2rLJHoNLp2X+sVn
 NIsxq/nQ
 L/hkvM04lNNCnxgqn9qLtDL4uLM353+lqMm4ahljqftzLaB2Vz6RljbFskHkppcdZD5rBa1pz4JQPeKBqd+QIEim0rGd/O0c6HuGsOJqvSIUIL88RkMRxO1uqWR2bxQx5cEXdlFD8siTXwfUDBt4zM1JHFkoyFqklAZMXLQ1bDnmcwl1flcKk4FneB2WyQST7K8pk1Xs3pPd2SuXED3LpRv2SnoQvU/B42Ai2Q9bp+12tr73mVF6M6SK9AsmLiWGz2TYZLsnIlNjNb7f6GUd++p58eiwqjbopqBCJqLUZfHoBjXN5T4jv2hYfdnc9ee8W5djFqELbWbIuj+yYw6tSFHiu9AbkTJDxxdVM/EheeXAPF+Fc9jiM5yl/w+FTGBHShJcN7f9MxQxKnKUrTfDj7/QEr8cWDwAIlQnO4WidE9xEJMPAg0kfua0OS/Elk+vjg0YXAN+j8Eagy0QcoAJq+h7GjHEkaqqkq+kuNNaFt3qP1Yzi6S2v8qSlLBzqjUUA7pnmxnjV2EZZYkRqK/s8x3qbt+bJbvO/FrMf1bKwiheBgbSiSWl/XUg7Nc2ouKra5v/4TXeixULViG2dxVs+KqT4EiN++DnKTSNRV8S3D2mSjeAXiBozHKPsawE5ZcnCZUEFB6ZFCZleDCE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMA tests need an operation equivalent to
atomic_inc_unless_negative() to implement a fake mapping_map_writable().
Adding it will enable them to switch to the shared atomic headers and
simplify that fake implementation.

In order to add that, also add atomic_try_cmpxchg() which can be used to
implement it. This is copied from Documentation/atomic_t.txt. Then,
implement atomic_inc_unless_negative() itself based on the
raw_atomic_dec_unless_positive() in
include/linux/atomic/atomic-arch-fallback.h.

There's no present need for a highly-optimised version of this (nor any
reason to think this implementation is sub-optimal on x86) so just
implement this with generic C, no x86-specifics.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 tools/include/linux/atomic.h | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/include/linux/atomic.h b/tools/include/linux/atomic.h
index 01907b33537e04c5e860dd2cd61a61dfab6ea8f1..50c66ba9ada58cf05125e2e2472734bf3b0f8595 100644
--- a/tools/include/linux/atomic.h
+++ b/tools/include/linux/atomic.h
@@ -12,4 +12,26 @@ void atomic_long_set(atomic_long_t *v, long i);
 #define  atomic_cmpxchg_release         atomic_cmpxchg
 #endif /* atomic_cmpxchg_relaxed */
 
+static inline bool atomic_try_cmpxchg(atomic_t *ptr, int *oldp, int new)
+{
+	int ret, old = *oldp;
+
+	ret = atomic_cmpxchg(ptr, old, new);
+	if (ret != old)
+		*oldp = ret;
+	return ret == old;
+}
+
+static inline bool atomic_inc_unless_negative(atomic_t *v)
+{
+	int c = atomic_read(v);
+
+	do {
+		if (unlikely(c < 0))
+			return false;
+	} while (!atomic_try_cmpxchg(v, &c, c + 1));
+
+	return true;
+}
+
 #endif /* __TOOLS_LINUX_ATOMIC_H */

-- 
2.50.1


