Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C91EECA5FA1
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:41:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3268E6B009E; Mon, 28 Sep 2026 13:41:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D29F6B00A0; Mon, 28 Sep 2026 13:41:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 175926B00A1; Mon, 28 Sep 2026 13:41:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFF706B009E
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:41:51 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 72E031602BB
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:51 +0000 (UTC)
X-FDA: 85263888822.13.148C96C
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com [209.85.128.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id B8F6510000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:41:49 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xukjx2jH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 33Ka6aggKCHEhbdhiPUPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=33Ka6aggKCHEhbdhiPUPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/R3jIsuFxLI+ycNCkUkycnkKQylo65Jf0ypcBShLiJ0=;
	b=hJP9KsuZfcmSSck0xckb4l1WHjcQDrQW8urlONfNcX4dlskZXA7rdTHZ7veYXccdoLNwRA
	Sh2lyVACwi5u4tCbzaU0qzAJ9AZCO7YIwTMCsCCcGdt2rzOsYDDw6h5BXHvaeG/y+nppL/
	cXs+aJD4MHH5P3eOmGXlM82KtMJQdyo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xukjx2jH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 33Ka6aggKCHEhbdhiPUPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--smostafa.bounces.google.com designates 209.85.128.69 as permitted sender) smtp.mailfrom=33Ka6aggKCHEhbdhiPUPVddVaT.RdbaXcjm-bbZkPRZ.dgV@flex--smostafa.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617309;
	b=FuIFQWNhd1uMpiMriRhsSTFCIv/Dd4gwgv6hAPl8pNKgQaGIYIwcRGdgLPRIRy0qzBIhrP
	UJnC9DnCUTSctoUTBJ7SCs6sKG9HKEfcmfBGAUTkCnQYvmgpCuKS6TZSV1X0myHtqpjXru
	ZYBlHJfOqH+IPJBKe5Oa+uLvJuP7VnQ=
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-49e661c6440so22454375e9.3
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:41:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790617308; x=1791222108; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/R3jIsuFxLI+ycNCkUkycnkKQylo65Jf0ypcBShLiJ0=;
        b=Xukjx2jHEn77ATh50QiRoKwR6mESqZtF+BedQoRgo5VMJnVjQ2A23I3KxAEnAHLiFI
         SlPIl0238jxz6xXSjEU5+OUoYQqTTcSi7h71O8kRfsBzPedjNl2/5AjMRXumZEyxg4YV
         6zlvw6K8y0PlWw1gy3O+pFGLsGrbxSPEr70XB4xvkKEKJM7FtZSjTFU1Zy7yQOVVqreX
         aqmmXDBWMgUAYmiymaOCLqW7hoenJBt8cqfK1BiXETodo38OM2PY8jYs7pQK3mtfkzQr
         LBylOZyjUEzvIu9EABCxvzEQvv9tdaaDyig0niKPUWzbijKeB5S3OKDHDei+7EysWVsF
         6EWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790617308; x=1791222108;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=/R3jIsuFxLI+ycNCkUkycnkKQylo65Jf0ypcBShLiJ0=;
        b=kFlDModGccixEIvQ5aUq6Sp5Ds3mqYDpbv5Z4AM8oA8ibmaLkTWRbdJgD/omTbQeSG
         6AdHOhlUOPdMI18tso0njhxkpw1cNJ7KcZzsEHGRQm2wh34qvu+kOU19Zbzd2MMBeWLh
         cl2gcd1ODJUUCaPY6OaMsHvfy4tn7o8zsIGwPo154vrN1LlaWM7L9COLhG+oNcUUxLbx
         qsgRkjiERNUk1wJt4EHaFAfNFLtU4q/PBJLedj41QGVes5T9gPEcdYGpAoqFwqCkGIpt
         2O+ofPJpfoGPAr3s0KmL2IzaajVhYCVM7ViyxjaUuTQFEq+DXG0mrsppJHPek4Pf8tcN
         u8KQ==
X-Forwarded-Encrypted: i=1; AKwUvBy7jiDZlBFICKJJI8F28mlAWtwsZ7tv4HimjJ7qN/UzOMrxJU1X0bjOeJlKOtM78FItEGZ3h3pVqw==@kvack.org
X-Gm-Message-State: AFuF++nzpKKvR0Pg8j5xxG8N/cjxG2oF+/olIYT71pQUUQ9ZsWSVZdxY
	CP8cQmS8tuinTWj7FT5DhLDr5xx/xLaEVqis35yuQ8HQVeRXhR+Xm+hqSqihYGf+RuZZRfMX1iz
	5yOgVrZutXskPSg==
X-Received: from wmoy19.prod.google.com ([2002:a05:600c:17d3:b0:4a0:23b:31a7])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b1b:b0:49c:de80:b833 with SMTP id 5b1f17b1804b1-49fe66c8a1emr263025785e9.2.1790617308191;
 Mon, 28 Sep 2026 10:41:48 -0700 (PDT)
Date: Mon, 28 Sep 2026 17:41:08 +0000
In-Reply-To: <20260928174122.3380703-1-smostafa@google.com>
Mime-Version: 1.0
References: <20260928174122.3380703-1-smostafa@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260928174122.3380703-2-smostafa@google.com>
Subject: [RFC PATCH 01/15] fork: Remove assumption that vm_area->nr_pages
 equals to THREAD_SIZE
From: Mostafa Saleh <smostafa@google.com>
To: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, 
	linux-hardening@vger.kernel.org, linux-rt-devel@lists.linux.dev
Cc: corbet@lwn.net, skhan@linuxfoundation.org, rdunlap@infradead.org, 
	catalin.marinas@arm.com, will@kernel.org, mark.rutland@arm.com, 
	akpm@linux-foundation.org, urezki@gmail.com, mingo@redhat.com, 
	peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, 
	dietmar.eggemann@arm.com, rostedt@goodmis.org, bsegall@google.com, 
	mgorman@suse.de, vschneid@redhat.com, kprateek.nayak@amd.com, kees@kernel.org, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, gustavoars@kernel.org, 
	bigeasy@linutronix.de, clrkwllms@kernel.org, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Linus Walleij <linus.walleij@linaro.org>, 
	David Stevens <stevensd@google.com>, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B8F6510000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: g7hmjyse4zx9cid8o77637cao96csg66
X-HE-Tag: 1790617309-152209
X-HE-Meta: U2FsdGVkX1+xMOW0kp6b0xjr5nZVRFOTdy2BzLXTpghPVwiPhnKrUcTyBcn1V4plU6vp7S1AqYa04CTdacAsKbm+o6Tr9SKT6Q+PT5pAsu6jHHNfn1i5pfcYO1wVaW3LyU4TKqcQVWlab33GFBD04cY7BfhCWJ8qWoPR6a8PVmL9uQNUFiNJjIy0ZT3PSX8rKawy0mzY5z2GY+LJE7ThnVyf1/BItciPThVsVBx5+9XBVQsFVzkn3Ub3xNV8OSCIKb3QH8dYT9qw596MD+e7cQamda3sIoMCJyNMLZkU9Xm3jQkQZXHR/0Q3kofbZYE27XvAJ1gGZTlBR9ULQ6bSFrAo3cxGoNmDUzuSCl0/5HoT2XTEvTMeHydUbDWlF4uhe6rDEfQ/a0o/lE5b2ta0iD6vIru7uSr4utO4roTWoSrJl/yrSdUJ3m93jhE5C/zfBiiuY2y56a8Z5m1abDABsvxwMpX+BxB+97P67MyR1ssyOoIbCj2nqTJm3I3QX7OkLFf3Kbw2VFfPzzYBuP6ihgAjzzEClyszr+9kxiwqZwadTyFB2rXsxMzW1ml3DNZWAXxGQ9XS54PygyezTfYLtY3EhK0LNi41omC4RHHi9VrGSHqaYLzE7GACXWwvmD7h5iB2L+umfnneB7hqCvR0VMjivHut7x+bFi3mr6uO86uw2onuvpWtrDXI8hLVAlgbe4B7c5a1pFHVqiEtUkJ93G7UXLM0id+uO9kCseq6wPK8R2YHVoohrUMZqsyKqMNKohbX6Y14KPZCSk8AIS7PsCfPIExizttRARiKtLNYaBXREF/8LKpw5EJI7OKsFaz3C3JVQp5/A8gBlWamN7Bi3L/GlIpzdT0nCF0eQcViDePn+Byv7oH6XpX1ytSn5cPpmZQ6ZVCPZ6P/MByK0CafZUgkkHrWlkm7dv2nYzg0CRd7Yts9E+vNX3o+bNceWsK35kvjyX7tx2q2qvPtiZT
 emjRHrMQ
 APGL+LJeWCGa4H19wLzhVqG3Iq4dioOCWtxAF4wdrp5gQmLkfR5kOxyP1D74adq/IqoIDbMSjOrHicO3jbi3AlYAZZ8d+JPoqJ0N2EgQc5uPmS0ZxK9jvpRxU9KDqi7chb/PdbTajrny8owH03KoVshzTZ2MwCBXIuR//BEZJJtCxGaM0NxkgUD6Ql/pSCulavhNRVM3gNdh0twoIyEBjVqL3cmdvCkuOnJcstYUAwjUUf498X6eRLFYY8eS5+pq4FK7/B7O6EbFNj4U2K1OJYdc1l01tkrbMnpVTsLRMyLxrovV9GhfQB1GHaeq15FZWEKhfrkH2Zn1lvozAbm6RmKqzErsUA+YS7pHdcgJgy+IYRto4GRU0ojM/MAbOmgB568W+QZY7ln3Vh0IGkm5kzeDM2/02Ttngg2HGiTwU1tvceHspiJgmh61hv11FsQShHtHq0Y94sZwoaTEGgt8s3ZhmK5s3vBefR+wBq6DeTU+1PEMvsn4VZi0thz/aoUtEyqRyOS3QWxwhfN0NrECAVmpV3xrJdQYUvba42gTmHABNVV7lZSnwWKpRpSez5jst5M8QM0+XFJf/GlqAHk3Q48LQR5XeU7YuKBNeYe10Nrke3YnhDkvvdNKkAunfVtt/aI+sNbbMjmXtSRo9Xxmj02txZQRhdyr9dV34Ux/K3TPzQGJKYVYR/0D6VamMc/bFbFP8Se04eMFeWYC+KgfBnbTge31/osQwopjHnTbLCh8/YZcLORb54wwL56cNAMvizcve
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Pasha Tatashin <pasha.tatashin@soleen.com>

In many places number of pages in the stack is determined via
(THREAD_SIZE / PAGE_SIZE). There is also a BUG_ON() that ensures that
(THREAD_SIZE / PAGE_SIZE) is indeed equals to vm_area->nr_pages.

In the next patches the kernel stack size will not be a compile
time constant and would be less than or equal THREAD_SIZE based
on a command line arg. Therefore, use vm_area->nr_pages to
determine the actual number of pages allocated in stack.

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
[Rebased, also skipped intermediary helper variable nr_pages]
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: David Stevens <stevensd@google.com>
[Update commit message]
Signed-off-by: Mostafa Saleh <smostafa@google.com>
---
 kernel/fork.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5ef413368912..2065693e762c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -315,9 +315,7 @@ static int memcg_charge_kernel_stack(struct vm_struct *vm_area)
 	int ret;
 	int nr_charged = 0;
 
-	BUG_ON(vm_area->nr_pages != THREAD_SIZE / PAGE_SIZE);
-
-	for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
+	for (i = 0; i < vm_area->nr_pages; i++) {
 		ret = memcg_kmem_charge_page(vm_area->pages[i], GFP_KERNEL, 0);
 		if (ret)
 			goto err;
@@ -488,7 +486,7 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
 		struct vm_struct *vm_area = task_stack_vm_area(tsk);
 		int i;
 
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < vm_area->nr_pages; i++)
 			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
 					      account * (PAGE_SIZE / 1024));
 	} else {
@@ -509,7 +507,7 @@ void exit_task_stack_account(struct task_struct *tsk)
 		int i;
 
 		vm_area = task_stack_vm_area(tsk);
-		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
+		for (i = 0; i < vm_area->nr_pages; i++)
 			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
 	}
 }
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


