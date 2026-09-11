Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 266C5C88E4D
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 22:15:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAE016B008C; Fri, 11 Sep 2026 18:14:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5EF06B0092; Fri, 11 Sep 2026 18:14:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D74BA6B0093; Fri, 11 Sep 2026 18:14:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4C936B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 18:14:56 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A86694036A
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:14:55 +0000 (UTC)
X-FDA: 85202887350.30.63D1896
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB46040003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 22:14:53 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RM40TZ8E;
	spf=pass (imf17.hostedemail.com: domain of yury.norov@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789164893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bZMF2qooMPRk5Hq78os7KgYAWUsTasHU8sMqJeIvwpw=;
	b=08fLk1SzNUwGfV83VK4NR/XLaMwMJgl4gNVEffzcG3KpotE52RFBgRQV8cgfhMJgzOq+qN
	eZjJH6BQJrQo3of8px3z4oB6pYKI0rkgJe9mOjkBslN8XbV2p3oYkP0mTfyDnfWuEKSBvr
	iQzOfFsklShIdoGKWGDAspiTQFonqFo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789164893;
	b=HYHxaV0e6WsR72LMykNCkrEDItWGCM+FdE6DyrnxCZr2wuCFHWoZkgLUZkRFn0g8S7jbvt
	NSmFUasDiPDLFuhQkmD1MgTgcuPUVeSBVX4QlGNQFiJs+vsfQxJs5qf6DjPhPhxxqRDb+7
	3hXyudk46esPXExvswokFjsV+CYSOG4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RM40TZ8E;
	spf=pass (imf17.hostedemail.com: domain of yury.norov@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=yury.norov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b350c69b4so43981a91.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:14:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789164893; x=1789769693; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=bZMF2qooMPRk5Hq78os7KgYAWUsTasHU8sMqJeIvwpw=;
        b=RM40TZ8EcSwUeVCrfUAnng7vUhvrlWGINfe+VFwhe13LMs5wVoM9Tf1c9vcUiW1Hd4
         nQZErAG7X/MjFOpZLE+oCDvYmMavJ2m+wGvBFugLrwRfK1x5ws0M9/cZjuxTev3/TBj1
         HOU9aIUtdbBg06r3Cwin8rAyovzge3/GUMa1U6QqgX1VOchBtME7paO6lmVaYnvuRjEA
         ulCYQAGiPARW1ZOUmmqiANwINKXy2a5FTROB4owGUIGACkARmJlxbNnBrPUaWOiZHyIk
         WYbj+T+XbmEiVeMyBC3tdF8m+nuvNbVym966W/ucaQo6DdOHHyAeKCxF1CbluBuDufuR
         bnlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789164893; x=1789769693;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=bZMF2qooMPRk5Hq78os7KgYAWUsTasHU8sMqJeIvwpw=;
        b=C/GW3n+KfwKisv6UKEeB4QcEPc/ezkjmarqJLlIy5gGm7R9z6WgcVbKXg2vO1jPj46
         P7D7pu90MrzpmWWuzzqq32isVf6RY7VU0w6ycxeO+8nm5G9SVThXYYiGWXLp6iQEmnCw
         xm7etf9gc8emYp8yh714L4D57woDLsv3hgfFVTNVmc8fUbYzozhBmq+3qU+SX/f9uREv
         0hRXgfV5o24zlRUivATpv9tcJoUEX7HQ1tIkR5liBwcahP+TNzxt2Z6JlFlq1t8hBpZ+
         Jz1dxspquKeBfTtVjZPipfucayFXUfQ31y2u4Gfn9BKcbsB3icRvrpzphMWsoomWXs9U
         LgVg==
X-Forwarded-Encrypted: i=1; AKwUvBzpIefDBhyKMSP+zggTKcYwKrVAaGrn3LHcsjiBPVId+IVEGR/chiw3j9vis7zQfKsYADOHC9Vaqw==@kvack.org
X-Gm-Message-State: AFuF++n6fU3dkhJotApYvNYOTpRH523RDzImqcatiOqcHA2tbVAiPkPy
	Ygeqvak4wQVmgC8zh9TFPkofvfSYlYN6RgajVRafUIbCuiVKCAcFoeZR
X-Gm-Gg: AYBFou3jtClpvZtZ8Aqn2TBD6kf4ZkZTQZGqaowOH/wXlXHxpIGg/tFOOGnoywRmS8f
	LQrAeormMzQ233Svo1i+1HPR3FDzRyBq8FljuT++V7vGv39oGVywbgAphC9CVBOS+0szl2QJ/5X
	D17aaNJPdw52zZjfAPjBdF9A8xqfHxmnDVdaQk99kszO9NB5nb34MQiZrAOz/N3aYhacM/qDylw
	2acnN8A39w24KlCEyE1lsfDjjO0v/hrRmm8RxsOUXG9MFBYzg7x2mSzPUrpboU72VQ2KYT3wQCb
	f7XV1mQaQCbKwxPlGRin2lZBISISd9mTafsWBVBO4/1Rw7QvJKYIlyJqqPjhV2mNehkjB6F6eMw
	Fcelar5Y0uO4PxNZveDqWrOxohXdXYZVQFk9CS+GJcnfggdMiqoYcWpnKRZz26zk+gkJlLqGnRd
	PdwkKviAk5E1nH7bon8EaKIRagLyZ8pV85uT4KYyjdXn/MSjAoWLoyPE4fYd5dWZEFad3M
X-Received: by 2002:a17:90b:258e:b0:39b:2c00:c3f5 with SMTP id 98e67ed59e1d1-39dbc6d8753mr375019a91.18.1789164892609;
        Fri, 11 Sep 2026 15:14:52 -0700 (PDT)
Received: from localhost ([216.228.127.128])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33ba4e51449sm7862656eec.5.2026.09.11.15.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 15:14:51 -0700 (PDT)
From: Yury Norov <yury.norov@gmail.com>
X-Google-Original-From: Yury Norov <ynorov@nvidia.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	"Liam R. Howlett" <liam@infradead.org>
Cc: Yury Norov <ynorov@nvidia.com>,
	Chris Li <sparse@chrisli.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Andrew Ballance <andrewjballance@gmail.com>,
	Yury Norov <yury.norov@gmail.com>,
	linux-sparse@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	maple-tree@lists.infradead.org
Subject: [PATCH 2/3] idr: assert static storage for DEFINE_IDA()
Date: Fri, 11 Sep 2026 18:14:42 -0400
Message-ID: <20260911221444.1523311-3-ynorov@nvidia.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260911221444.1523311-1-ynorov@nvidia.com>
References: <20260911221444.1523311-1-ynorov@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8rr8fkyotat86ca7ia69magbhzy4xcot
X-Rspam-User: 
X-Rspamd-Queue-Id: CB46040003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789164893-278538
X-HE-Meta: U2FsdGVkX19lZcXr9ZQ1RZ5fznWEuoeZhOPhF5KwJEjtVMICB0dR+YeqzL91VC1g+Vm4RkUxRdXTVT9QhSDorJsdIyBILkP0jvDziabGM43vLBoH7QrZ3eReoqPCP/AJCIeZAQrk9//EfvIp9dw9Dn6NgArmT4iWehzJehKdQeumcOUNut8Cf1IcA0mkN6ggYeFh/rFiyuLB6JpFHQ4V6brqECEUFcAJFNihWjg4zT2w3xg/0Y0xzMvbmYdulhtSxKh6WQwO04sChCueHNrWNULaORqXd8jHhKOOdFUFH0lxDdrKcZie11ZYNmjkh12roGwtrCp2jEwiNFRJaFIV6XAtfCD5U9GYouf08kCzRHp47UkZyyf3UdjhY325dwElLPsaUtNB17XH/6vrWK/6Ia28s4K75dSkPu9cV4/YraXSjlo7RBU6bFkLNsfJoq8Vo0aCCApYuFPYIS5KZkcGgvemykKSciR5wIlRu5B4st+XV5koh1INDJAj+o/smRVI0dlOvhPhJfLA6rFoo7xbkkUu7qWeDHZrFu54scE8zNqR0DYur/Trbt5D2ts25zsx5K7JYLEc6ThXvIBTGS8Grejxtpzevf+DMujfh61LE1dYxOqZqkM0ZzZIxNOgPEyZo6huhiDvr1xuNavvU+gsJYoVAY2QChQjmf1G7Ds3JxyDptoVz5ieDlMyMr1uzPRwvt7XkGe7P2x++DYCpPCeNTsUKGiVpvxDwbveCDlDoX7vUjWV7HNGkiHFf0jDbZOvnWul9bQam/h7Ai2xZQmaVxvHuX+nei8DzSWdNoeeYjSvhBzSWAqlvNFM/+Oj6BBS1NUVIpHesRnP3l48Pb5GE43tl49XZ+N2Bd2h/39NghRbkybFbBqfyg74cY1abHWfHUGfh6UlEuq5KD0e/jsVnpKPNEoG6CSDywKUzuCo1YtxO7KUjSdekwC7CmX0BfcWZA7iIyN2e7HMlDd/KrI
 KStte4m5
 ue8SeGeJJ6oE1t73nX9hTcg+ua5Ry09b+qLxYSXVgZwY+IIH38Sas9aCE7Uf2Y4ZiRvi0jl4pCpuDrnbEmLw6YwkVif1Qcr0wnwzqn/NFA02TgIo++oXLhpCPyxra/cP22aWnTBKJSI9x3IfbqCi5/QBAN3TPSBr6/JVonVRR/+o5hCyY4pAKmzXmntn81Oaa8mKaj2zAMkLowFHj0eui4gJ9SHndYfAPDjqkD0TBPNYZevjdlzUe4I8qfeg8RpL+vf+Z0Of/EiQApenIpfLsP3VE+atE0u1QPS+Jlo7F0lOxwoqGDkE0IeLodFVhJsNrOeL5DcCJobS7X8XWbIxb9pRtpJK6aUGnu5y/JwL56ytIVm26whNCXLXV7i1sJmQvt9YmRWcK98BfyT8bCbkJuEdDA8EAx8981yRqiEjlMpDXmDqnyxQiUi8pDIow5jm9Eum7xOuZEThvZAXqaM7V8WMXoXxYgf3IWJXLDVf9srUf/6+hrrTvaZhN+MPCRk/ZZykvWbO68CrekmDy0mOk+i7iDlhoZjSHc6Uy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DEFINE_IDA() uses IDA_INIT(), which initializes the embedded XArray lock
with a static spinlock initializer. For an automatic local IDA, lockdep
cannot use the lock address as a persistent class key and reports
"INFO: trying to register non-static key" before disabling itself.

Apply ASSERT_STATIC_STORAGE() to DEFINE_IDA() so that this misuse is
rejected at compile time. For example:

  void example(void)
  {
          DEFINE_IDA(ida);
          ida_destroy(&ida);
  }

GCC reports:

  error: initializer element is not constant
    name##_storage_check = &(name)
                           ^
  note: in expansion of macro 'ASSERT_STATIC_STORAGE'
    ASSERT_STATIC_STORAGE(name)
  note: in expansion of macro 'DEFINE_IDA'
    DEFINE_IDA(ida);

File-scope definitions and static DEFINE_IDA() within a function remain
valid. Automatic local IDAs must instead be initialized with ida_init().
Direct uses of IDA_INIT() are not covered by this declaration check.

Convert the five automatic local IDAs in the userspace radix-tree tests
to ida_init() so they satisfy the new requirement.

Validated file-scope and static local definitions with a kernel object
build, and confirmed that an automatic local definition fails to compile.

Signed-off-by: Yury Norov <ynorov@nvidia.com>
---
 include/linux/idr.h                 |  5 ++++-
 tools/testing/radix-tree/idr-test.c | 20 +++++++++++++++-----
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/include/linux/idr.h b/include/linux/idr.h
index 789e23e67444..e2a4b6298511 100644
--- a/include/linux/idr.h
+++ b/include/linux/idr.h
@@ -16,6 +16,7 @@
 #include <linux/gfp.h>
 #include <linux/percpu.h>
 #include <linux/cleanup.h>
+#include <linux/compiler.h>
 
 struct idr {
 	struct radix_tree_root	idr_rt;
@@ -269,7 +270,9 @@ struct ida {
 #define IDA_INIT(name)	{						\
 	.xa = XARRAY_INIT(name, IDA_INIT_FLAGS)				\
 }
-#define DEFINE_IDA(name)	struct ida name = IDA_INIT(name)
+#define DEFINE_IDA(name)							\
+	struct ida name = IDA_INIT(name);					\
+	ASSERT_STATIC_STORAGE(name)
 
 int ida_alloc_range(struct ida *, unsigned int min, unsigned int max, gfp_t);
 void ida_free(struct ida *, unsigned int id);
diff --git a/tools/testing/radix-tree/idr-test.c b/tools/testing/radix-tree/idr-test.c
index 945144e98507..6fcba5b5870b 100644
--- a/tools/testing/radix-tree/idr-test.c
+++ b/tools/testing/radix-tree/idr-test.c
@@ -460,9 +460,11 @@ void ida_dump(struct ida *);
  */
 void ida_check_nomem(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	int id;
 
+	ida_init(&ida);
+
 	id = ida_alloc_min(&ida, 256, GFP_NOWAIT);
 	IDA_BUG_ON(&ida, id != -ENOMEM);
 	id = ida_alloc_min(&ida, 1UL << 30, GFP_NOWAIT);
@@ -475,9 +477,11 @@ void ida_check_nomem(void)
  */
 void ida_check_conv_user(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	unsigned long i;
 
+	ida_init(&ida);
+
 	for (i = 0; i < 1000000; i++) {
 		int id = ida_alloc(&ida, GFP_NOWAIT);
 		if (id == -ENOMEM) {
@@ -496,11 +500,13 @@ void ida_check_conv_user(void)
 
 void ida_check_random(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	DECLARE_BITMAP(bitmap, 2048);
 	unsigned int i;
 	time_t s = time(NULL);
 
+	ida_init(&ida);
+
  repeat:
 	memset(bitmap, 0, sizeof(bitmap));
 	for (i = 0; i < 100000; i++) {
@@ -522,9 +528,11 @@ void ida_check_random(void)
 
 void ida_alloc_free_test(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	unsigned long i;
 
+	ida_init(&ida);
+
 	for (i = 0; i < 10000; i++)
 		assert(ida_alloc_max(&ida, 20000, GFP_KERNEL) == i);
 	assert(ida_alloc_range(&ida, 5, 30, GFP_KERNEL) < 0);
@@ -576,10 +584,12 @@ static void *ida_leak_fn(void *arg)
 
 void ida_thread_tests(void)
 {
-	DEFINE_IDA(ida);
+	struct ida ida;
 	pthread_t threads[20];
 	int i;
 
+	ida_init(&ida);
+
 	for (i = 0; i < ARRAY_SIZE(threads); i++)
 		if (pthread_create(&threads[i], NULL, ida_random_fn, NULL)) {
 			perror("creating ida thread");
-- 
2.53.0


