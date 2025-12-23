Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0360EE6F09F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 16:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C96C6B0089; Tue, 23 Dec 2025 11:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 255036B008A; Tue, 23 Dec 2025 11:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F38FC6B008C; Tue, 23 Dec 2025 11:18:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C73366B0089
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:18:27 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 73BB613AC60
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:27 +0000 (UTC)
X-FDA: 84251243454.16.B85A783
Received: from mail-ej1-f74.google.com (mail-ej1-f74.google.com [209.85.218.74])
	by imf09.hostedemail.com (Postfix) with ESMTP id B254614000C
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 16:18:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KD4frLVB;
	spf=pass (imf09.hostedemail.com: domain of 30MBKaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=30MBKaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766506705; a=rsa-sha256;
	cv=none;
	b=plVRoMxBxX44MJIzHYb+JzyMUUKzoQpERWUAs+9++7nBdESTmVcWTT0Dc6yWAz6UR28LlA
	zv4ZbLGZGXJDZFL8GYJVEbu9ydwOZSKa3IfIWzngNAjOZrofPP55SR0+na7nCQIp1u53ub
	n7+5I+9dXv3VF8OWoc4rmxzyjDnMpZ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KD4frLVB;
	spf=pass (imf09.hostedemail.com: domain of 30MBKaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com designates 209.85.218.74 as permitted sender) smtp.mailfrom=30MBKaQgKCM02tv35t6uz77z4x.v75416DG-553Etv3.7Az@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766506705;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0Hzxx2WqJaEHIGdZr2YZs1v307yu6j+9XrMYnyKbj4=;
	b=2EQkS+yxJhx6ffHaCweEF+1SWMivvFIJ2gw8wQlemfUxGC+3biQn8HtgUlyv98TX/WzNNC
	woF0v+mWoZBlPqeBnXEid/SIlAsgrbJKhRBmhiheFWQrHxkyvIJ1OjFDylSKYhO9KnVM/1
	NIYQD5aSY/FBWk1Q2Tcad2Fyu6Qhi6Y=
Received: by mail-ej1-f74.google.com with SMTP id a640c23a62f3a-b7d28772a67so506089266b.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 08:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766506704; x=1767111504; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/0Hzxx2WqJaEHIGdZr2YZs1v307yu6j+9XrMYnyKbj4=;
        b=KD4frLVBI9D+3o7WQoheejYipY5ugg9MC+E8e9XHptRe7RA16UPlw5hbjF8Ty/5x4d
         LZdjGCxtlccpL4UPIr8t8XdDzELQjJJJa87taDTd4OCHyG7s1sStsP6A6Lm8Pqo85Imz
         yvz7yxZvEIwOxefV/Jcck/+K2nGicH2K1WICAyw8i9oEvoWlF4m3u+lKMW7niTogVwBO
         h2tgjLM6S4dylwfPJpzeUcH1BYUY2Ui8dzMrLb984aWJZNF03Zf4Q0ohIimQV8CWcH94
         VzoWSVndzFxeoDP1uCZerbOGy4HiU0PRwUr1u2dJFGAfBTP8PtyP08ycidfe2cX0urPv
         B5WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766506704; x=1767111504;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/0Hzxx2WqJaEHIGdZr2YZs1v307yu6j+9XrMYnyKbj4=;
        b=pZ+Orpxin8FD9AuklY3861m2PBmPUwDTZQgu4LqULHUTwsjXV873KO47B81NE1lpXm
         H81YoP06cXZpzyWxTtnzjMKS04AsPkgVKZ2e2is3l9xZC1mIvLfWkRp2rvy2ujn6EKvk
         wj4YkVAv+yKOKZj499czeB/JSfW0fV0Y8NbyGQ0Eo4yvq9c37wC3GEYe8531186lgcLW
         Sbg4LyhHhLlg1IYOq+R0/jpNgPDdVF8iOPdtkCerCzqIVXGhoakOHmjH5vpDhYSfFbYM
         fdHVV6boD/TSaU9T5/7wF/Z2LjXG+XS9rxX7OaiqjMGZiMjQmflKa0UD+s2WL88j2Zf3
         Z1Jg==
X-Forwarded-Encrypted: i=1; AJvYcCVVPSP1yrWZOvwYxi5NtzV1L1yf/gj4SDVFUr9xvA/LZDhzU9n5t7RKaCp7wxyVlBLZ/bVVZZuysw==@kvack.org
X-Gm-Message-State: AOJu0YyUW5yRgoNVsDkPXHptNnqeaCO6UfpfSMGpHvmAfcOPWnM7m4qK
	GN2bplYAEE6zWWitpM/vlKnj7BH+cQ+hcatZd1bdvc5i3x+1FfW9jA5FhECjEjOXC99yI54SfUU
	SgwZbe5RS3mI3DA==
X-Google-Smtp-Source: AGHT+IEtFcjxrDkWqyDW1Yh13A/N/vCOq+YRPV+smnuFFZgDp9YtoqP/3PaSXx1PlTrP2mudWqxqGIkWyOQF1g==
X-Received: from edxn2.prod.google.com ([2002:a05:6402:5c2:b0:640:f53e:dd40])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:906:f58f:b0:b80:50b:6c8f with SMTP id a640c23a62f3a-b8036f5ac89mr1727469766b.27.1766506704176;
 Tue, 23 Dec 2025 08:18:24 -0800 (PST)
Date: Tue, 23 Dec 2025 16:18:10 +0000
In-Reply-To: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
Mime-Version: 1.0
References: <20251223-b4-kunit-user-alloc-v1-0-fb910ae0e50c@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20251223-b4-kunit-user-alloc-v1-1-fb910ae0e50c@google.com>
Subject: [PATCH 1/3] kunit: test: Delete pointless resource API usage
From: Brendan Jackman <jackmanb@google.com>
To: Brendan Higgins <brendan.higgins@linux.dev>, David Gow <davidgow@google.com>, 
	Rae Moar <raemoar63@gmail.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>
Cc: linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: B254614000C
X-Rspamd-Server: rspam04
X-Stat-Signature: o757xf9yn7c8w7kd6ik78ckyic5jxn59
X-HE-Tag: 1766506705-386452
X-HE-Meta: U2FsdGVkX18FlOwVET0CULtmj4nxmJQWhENAlJc3Z+4u5TANPKK73ddT6Gdvoaka4/ti3Ca4FahNCjBTWOYFe3hdCgbFHizCvAeBL6cXk6dR1RPen3alyFpn86Hx80ReOFDxrJm/ibeC5nKaPl5BJdL8coVLWrusIb0plyLrgitMKEfW4PW5hD647EyAdCJrcBoUeGSR8X+bK8/umjU/MLEAc+PDQ+893+ZtO140ofwCV1WLToPXa47mtaSVEPJW8i9vwJYpO8DRuD5fkJdw2aaHiAD3dAvMUGb6afF78iIAmVbbg4S8VWh2idwPJ7n/pQ1umRuONiN7AFAp83gHONMtkNILdV2n4gDJBjQiXN4vM4cJZeqSj4m7fCssb3k5q/lP6bdwDqbOUE+6CjdBaGBpVn9lbBbl10GZNI2yssdAr0e1YvfaXl34iwgv0Z576pgFlxy1gtnHwqFRE3vxguWFVv+L59AyX11WRh+zZ5qEwV6Tm3tCI74W5UeXXQ/3zhIfoRvKz4iRbK8qkXUe9Tpzw35ez3Ci1ucgj7lw4mRna6mcdepZdQSJeX63T1OuwQrvqkcu+G+tsZrgs+wpOlT/DWxC7mdg02orIgUV2H5zwwBXmC/nQBgeTVp0DwIbOFcnMPKDrBR2/mGXoxplTHgRU77SMLi5tQSiUsjtEY2PhT+NRFJKUNSX+2N3VvZZUXhiKFNBS3+PzzmH1AZJl6Dne/WHT0OIBEUvkwwll61ds1ETy2vevcIL+pjEd9nar7foxPcqX30Yt9uyL9wMhrLYD/zoean8exZjNMS1Bp8KgId89GxLo/za5aUI13eV0Y082b02Xzfc1vyrr/fnCO/a96GwOo33yFHRK1i+/xdpv2Dk2XhpcSwuj50nOzNQVHKJ/0FQo1ggYNym83RHPmmeXek4tyELqgfF0hbz2tFfziarJl45v4/fQD2bPJoldN1Wz7TLBpddacTqoH5
 QtPXQWof
 GezFS1sqFE75VC51NtxOzVtLtD2iB6qgBnKqvq/MQQGimeLFHZZAAg7SP2Bjppr8aTZLxh5FOj1X0GvL2Z5KMg0KQOyRwoyY78RZPcceRIY4Gge3fW1cIkSa6TXuL8tIQGggezs2BU+2Sr280gHqQ411rFf7gcACEF6UligpkJ9WHiYU9HspedO552QsNpMCgR4D1Wz3HPkCesaJ7AbYq+IztL/4mVop4WGIa/SQQQKvMC6efBByyDYdFr40//GcWnYZZCY+V/yK9YuaaAgy0Ki0jFw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This code uses the low-level resource API to track parameters of the
vm_mmap call, but it doesn't do anything with them, because the mm
teardown code takes care of tearing down the mmaps. Delete it.

Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 lib/kunit/user_alloc.c | 76 ++++----------------------------------------------
 1 file changed, 6 insertions(+), 70 deletions(-)

diff --git a/lib/kunit/user_alloc.c b/lib/kunit/user_alloc.c
index b8cac765e6204..564f5566641d5 100644
--- a/lib/kunit/user_alloc.c
+++ b/lib/kunit/user_alloc.c
@@ -7,21 +7,6 @@
 #include <linux/kthread.h>
 #include <linux/mm.h>
 
-struct kunit_vm_mmap_resource {
-	unsigned long addr;
-	size_t size;
-};
-
-/* vm_mmap() arguments */
-struct kunit_vm_mmap_params {
-	struct file *file;
-	unsigned long addr;
-	unsigned long len;
-	unsigned long prot;
-	unsigned long flag;
-	unsigned long offset;
-};
-
 int kunit_attach_mm(void)
 {
 	struct mm_struct *mm;
@@ -50,67 +35,18 @@ int kunit_attach_mm(void)
 }
 EXPORT_SYMBOL_GPL(kunit_attach_mm);
 
-static int kunit_vm_mmap_init(struct kunit_resource *res, void *context)
-{
-	struct kunit_vm_mmap_params *p = context;
-	struct kunit_vm_mmap_resource vres;
-	int ret;
-
-	ret = kunit_attach_mm();
-	if (ret)
-		return ret;
-
-	vres.size = p->len;
-	vres.addr = vm_mmap(p->file, p->addr, p->len, p->prot, p->flag, p->offset);
-	if (!vres.addr)
-		return -ENOMEM;
-	res->data = kmemdup(&vres, sizeof(vres), GFP_KERNEL);
-	if (!res->data) {
-		vm_munmap(vres.addr, vres.size);
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void kunit_vm_mmap_free(struct kunit_resource *res)
-{
-	struct kunit_vm_mmap_resource *vres = res->data;
-
-	/*
-	 * Since this is executed from the test monitoring process,
-	 * the test's mm has already been torn down. We don't need
-	 * to run vm_munmap(vres->addr, vres->size), only clean up
-	 * the vres.
-	 */
-
-	kfree(vres);
-	res->data = NULL;
-}
-
 unsigned long kunit_vm_mmap(struct kunit *test, struct file *file,
 			    unsigned long addr, unsigned long len,
 			    unsigned long prot, unsigned long flag,
 			    unsigned long offset)
 {
-	struct kunit_vm_mmap_params params = {
-		.file = file,
-		.addr = addr,
-		.len = len,
-		.prot = prot,
-		.flag = flag,
-		.offset = offset,
-	};
-	struct kunit_vm_mmap_resource *vres;
+	int err;
 
-	vres = kunit_alloc_resource(test,
-				    kunit_vm_mmap_init,
-				    kunit_vm_mmap_free,
-				    GFP_KERNEL,
-				    &params);
-	if (vres)
-		return vres->addr;
-	return 0;
+	err = kunit_attach_mm();
+	if (err)
+		return err;
+
+	return vm_mmap(file, addr, len, prot, flag, offset);
 }
 EXPORT_SYMBOL_GPL(kunit_vm_mmap);
 

-- 
2.51.2


