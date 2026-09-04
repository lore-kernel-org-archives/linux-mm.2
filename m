Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADD27C79F8B
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 22:51:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CC446B0098; Fri,  4 Sep 2026 18:51:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17C7A6B009B; Fri,  4 Sep 2026 18:51:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0931D6B009D; Fri,  4 Sep 2026 18:51:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA3C96B0098
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 18:51:13 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40F84140244
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:51:13 +0000 (UTC)
X-FDA: 85177577226.26.7709ADA
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by imf09.hostedemail.com (Postfix) with ESMTP id 92FA5140004
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 22:51:11 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tafQEPed;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3XkubagcKCL0ziholshjrrjoh.frpolqx0-ppnydfn.ruj@flex--wfelipe.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3XkubagcKCL0ziholshjrrjoh.frpolqx0-ppnydfn.ruj@flex--wfelipe.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788562271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VNAQcGgCzsGn8fB04Y1RcaGfsgoCFdcws+Wtu5yA69s=;
	b=oopfqtynAqdEv4DtmnlkLlmyrcic+dsp+SKD0d3IzYmKXnnJiS4/QwJ5FPbLUqR6zpep/6
	xcS1afRBDczWL4aSdNOr/YoycL1G9KgGn+Fe9U5GVLM0T1cnyOCNkKejU8tsZ9GMLEYl9w
	nh9NEckgJQASHW7JPWA01twkc2QC5b0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tafQEPed;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of 3XkubagcKCL0ziholshjrrjoh.frpolqx0-ppnydfn.ruj@flex--wfelipe.bounces.google.com designates 209.85.216.70 as permitted sender) smtp.mailfrom=3XkubagcKCL0ziholshjrrjoh.frpolqx0-ppnydfn.ruj@flex--wfelipe.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788562271;
	b=5ZXI2Cvw/u7I+e1oZTf9nZj5EjEDDaxf0xWGAgl/lBReMUDN61o52sd3tkvASCR62AUG8t
	/M2H7iRK9i8r5If4Pnr+CeM/NCNjQInyfrmqMCE0JVmUdOiYmLTKZ4IDNsAg+XzmVZBWUz
	TFcCOf6rMedfyvpBfyg4zqc0p9R63fc=
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f5ac7416eso1794441a91.3
        for <linux-mm@kvack.org>; Fri, 04 Sep 2026 15:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788562270; x=1789167070; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VNAQcGgCzsGn8fB04Y1RcaGfsgoCFdcws+Wtu5yA69s=;
        b=tafQEPed6N8/+o1tO3I+hMZ+LRhOyv1akd3m3NS1DNCtOYLZF60Nv7+y+F8t98qwoC
         MzGbVsjihgHvSJHs87BI/eTgksIgYa9TdiWAHdjpL5Y1lgsLjN1g5fdWvVP7R6rdac6p
         yHQsiEnsTATFrYZNAMhoRcjQbxX8TErAEF3ZT+UbizbwyHN9tWEypngoeLmZj04gaPQp
         2ZiyawcIpNvmJq6pCGkZ7uEPjN7fP2V7ZHsKo4XS6WryoW6+z4fx8ZdB1DUOZ7swxNMd
         Qqf5oK97GruJz8gNNwzQ7Vh+LrHis1Rk3JiIeJuGlDKubrDq6jPnSk/rIteJwM2vdYad
         RbUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788562270; x=1789167070;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VNAQcGgCzsGn8fB04Y1RcaGfsgoCFdcws+Wtu5yA69s=;
        b=f0e9lgihxFvMLx1qhh63rzJmtuheYn0AsaodLR+64twkOwnrR3vhlAW2SZBYATCtA5
         zASrzObqYwh1e18oUOrhMomOzxSuozD+SMof5NnCQ+4ejxmYJd0uKI8xbT3HezSVJRni
         bAfJ85nWLV76hVs7KpkK8AEw/ejcVpgh6j0PIDulXosZw3uu2i6snIGXHZHDM/cmTeAJ
         sVlde3vFJcJ5Q2TGFHJ+RymxpfoI5Uo6b5Dy6Big381d4aBn4Y1lErwSUWe0SMRS9wRd
         9efQifG2v3JWjkdFlEnBB6vbmT0wYjUECWHDZwdc/rEUg/oAQHJc55SS066gj7kL7dWx
         zkMg==
X-Gm-Message-State: AFuF++lPafPuojcQSUSGKQqDaI5kkyQLIIW7bfrFE7RkwkkTMK8z86GM
	QljQ6SdImOidPKzrPFnEpCaNgyigJRkeGmvXKGJUzGtNxdnu1xrzXNJ7tIS8FzfquCcwe/Ppc4S
	iWcZH7GONcw==
X-Received: from pjbsj10.prod.google.com ([2002:a17:90b:2d8a:b0:398:ff5d:7e24])
 (user=wfelipe job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:5243:b0:38e:c232:9d3f
 with SMTP id 98e67ed59e1d1-39b2614df1emr14776303a91.5.1788562270186; Fri, 04
 Sep 2026 15:51:10 -0700 (PDT)
Date: Fri,  4 Sep 2026 22:45:15 +0000
In-Reply-To: <20260904225103.2955759-1-wfelipe@google.com>
Mime-Version: 1.0
References: <20260904225103.2955759-1-wfelipe@google.com>
X-Mailer: git-send-email 2.55.0.979.g7e5102b832-goog
Message-ID: <20260904225103.2955759-4-wfelipe@google.com>
Subject: [PATCH v6 3/3] selftests/cgroup: test_zswap: fix implicit unsigned
 promotion bug in test_no_kmem_bypass
From: Wilson Felipe Pereira <wfelipe@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?UTF-8?q?Michal=20Koutn=C3=BD?=" <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Wilson Felipe Pereira <wfelipe@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 1i95haor7n3buc58jwe6p3hun48nz9od
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 92FA5140004
X-Rspam-User: 
X-HE-Tag: 1788562271-225930
X-HE-Meta: U2FsdGVkX1+BYgnTMxujP7pGtMVMhUdLqTiu9m7R6kgz93oWYxbBDvh6itHAPcyhwmMRQ/C6aX9nArKAxLYIPkwTrQ1mKndd7Bp8eqxo/eFXEKD13C40g/Nbh3o8zxbYwPASI71cJ8tJjd20F5cuaKFTLp+Qt4MG+Mbuc07Ixct+vYwFVOUL4r65tenbjK4LoITVbLO97paUQS2ZqFYoijsw/FIQfCf6ZXloPRixTu7TFJcZXW12y64HCAjziChtoxx9msGmuV9MUVlbvH45Xp9y2RBAzSSmB1zC0DnUqMBpdwzYkTkb7IYFgJBluoPb/giS4lcxNgh5xzJ+FGxXLDDZQdWcqz/rPxrO2oOzu2hBOM6VNmkv4Z5t0EKSIWkZ3L+AD4wqYxxn8jSlkaQkwkfrwsozDOe+Hao6XnTy8+wEcFKjRHJolwzxHuxnmCcFUov4CB1gXAgGarhT98V+UmIH2Wyp3r2r2gSJ2S8xjiSQwI778uuwWscyYoK8VAbP2RYfJ9i6YHEpTM9+yKkLSMN107TSCiN++cAxwTsNGF9VZqYQ5mgotl2YMYsWL6U+BQ+r91ULLKIBNJmwjkI/BNctPeAaAdLGbbWOUKa3cfKnvgJ3H9nmFmvTswKaiLHF5dbQk9LJNsgVNmQbI3YHdvsUlsUyStBsrAbKov0ia9labYcKoVfCq2fGDLGOEqhZA5qCWczJxIpW4BJ8HAE5OLM9dUC+lAEsegqyk4H+27qszPd1hyTsl8MiWmZs3/8M5rW6UKShAPga29l/GpgK9QJEFVz2YdsuiA/o7AB0963oFp8IyecDK+Ki659bmqwIWybGxppTxZu0iCsQ31GhHS2KFTfeQ6AqdOi8XEvO1wji9bSWqiKbLmTTogCBLtGW8KEKdeohAQRHc4L8JLz3d7+vOSWPapdoIXE0SmpXLUaUK4gHVjXyHJn1/7XgRf5OGkef7Nl1ABXQYYcGQVa
 1lVkijZS
 ycYoX46M0Mxzwyxmy3vt08ah6xh7/CfLJ9beghmtjs/F8DCPhONXbRj6ChFdxf7YWrUn0Jyg2Iqw9I9QOtnJhMvkz5q7t5M65MoGVqJxdeS2xue1xOUjYoQK6jow4L8h7hubkAo2tSWhJgJUtUcHZVWeR0tqispFMFeDXuywWtybfk0j17Qde2tbdgsMGjVutIQuS4eOPWu5pvepEycvct5B98iwpyohq3EYH9PD7UFq1u2LKZk4Pn0pMYYBXsmvR6Wf1vwL7gKMA2+Ap6MbcHf2J0Q14O/4Qh2hCqoHgFwkmphFvNSJu9lkfNBmLc3yN0IfnoHzMQilBeg7fSRoSAfx+wAZc4mBoVuvpbp/alcgFBmv+EvsEKVnSe4LjWgUA8G59Mbs7BV4962Zaf15CbW49VqUaHoELGW+eE1ghES9dnScj79Eg1rxBmfgH0k1nLyB3ZdjYnduef+wP9HMyenioBKOkDvZIU5oxq5/QrqrM5xyZrqM4fKRimz2X6Jff23SC0/c9OPZ4QaFuTRdwmqxKKhNvRFh7clCcubVoMJO/BXbjyN1f6kBjStxuk7nHtPw/aeE8w8JR5VRsu40S9RANG7syn31kBCYf71CBTHNHywemDgz9PIVCWoMyZOqkDDLi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In test_no_kmem_bypass(), delta (stored_pages * page_size - zswapped) is
checked against stored_pages * page_size / 4 to verify that the pages
pushed to zswap belong to the test memory cgroup.

Due to slight stat update timing differences, delta can evaluate to a small
negative number (e.g. -5MB out of 1GB). Because delta was declared as a
signed int and stored_pages is an unsigned size_t, C's usual arithmetic
conversions implicitly promote a negative delta to a large unsigned 64-bit
integer, causing `delta < stored_pages * page_size / 4` to falsely evaluate
to 0 and fail the test.

Fix this by declaring delta and max_delta as signed 64-bit values (s64),
explicitly casting stored_pages, and comparing against a signed threshold,
ensuring negative deltas correctly evaluate to true.

Fixes: a549f9f31561 ("selftests: cgroup: add test_zswap with no kmem bypass test")
Signed-off-by: Wilson Felipe Pereira <wfelipe@google.com>
---
 tools/testing/selftests/cgroup/test_zswap.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index f4ee440b3c66..6e7ee11bc97a 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -632,11 +632,12 @@ static int test_no_kmem_bypass(const char *root)
 			break;
 		/* If memory was pushed to zswap, verify it belongs to memcg */
 		if (stored_pages > stored_pages_threshold) {
-			s64 zswapped = cg_read_key_s64(test_group, "memory.stat", "zswapped ");
-			int delta = stored_pages * page_size - zswapped;
-			int result_ok = delta < stored_pages * page_size / 4;
+			s64 zswapped = cg_read_key_s64(
+				test_group, "memory.stat", "zswapped ");
+			s64 delta = (s64)stored_pages * page_size - zswapped;
+			s64 max_delta = (s64)stored_pages * page_size / 4;
 
-			ret = result_ok ? KSFT_PASS : KSFT_FAIL;
+			ret = (delta < max_delta) ? KSFT_PASS : KSFT_FAIL;
 			break;
 		}
 	}
-- 
2.55.0.979.g7e5102b832-goog


