Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D981FC5DF9A
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 13:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B66AF6B00A1; Sat, 22 Aug 2026 09:54:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B16876B00A2; Sat, 22 Aug 2026 09:54:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DE796B00A3; Sat, 22 Aug 2026 09:54:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E6946B00A1
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 09:54:12 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E39C01A015E
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:11 +0000 (UTC)
X-FDA: 85129049502.25.99468F8
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com [209.85.128.70])
	by imf16.hostedemail.com (Postfix) with ESMTP id 29E9E180007
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 13:54:10 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a7TDrvs6;
	spf=pass (imf16.hostedemail.com: domain of 3AKqJaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3AKqJaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787406850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kA/leMB5Bml9VvmxH4fPbAWvPl/SN0OCbc+8KnqiWlg=;
	b=nY3dXjFpe5nCc8z2dOUTthdzLteGRqEhaS6tRqdjO7wdRm/Heap+U9CvjM9Oaq/k41RJqg
	0ZZothFZ9PC7DtvXwa5dSobR9Am9u6fPvIX7+BriAPKycSYyQJfHiVEnu/9g8Wj1P8sIVc
	iN6tNwsKccbJXQ7VSHkYKFMNjrrjUdo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=a7TDrvs6;
	spf=pass (imf16.hostedemail.com: domain of 3AKqJaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com designates 209.85.128.70 as permitted sender) smtp.mailfrom=3AKqJaggKCNU1I42+79K7FF7C5.3FDC9ELO-DDBM13B.FI7@flex--ardb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787406850;
	b=srifWUGQtqlhXq1bdv0uUESnyD6aPeWpUA7wdluOY9v0VVBphN+3tZg2qOHRX850nL+2aC
	6coce/gVPC4QLwzBtFqiX5H1yJptTK0BgVRflrK5p5pPvPDjZ8MFWkkzfiH9H5XgNFD2Wu
	nZ4NNMKVcW0cc4vsdQeB/IkgW9uCuFQ=
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4957287363bso10400305e9.0
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 06:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787406849; x=1788011649; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kA/leMB5Bml9VvmxH4fPbAWvPl/SN0OCbc+8KnqiWlg=;
        b=a7TDrvs6znU8FjSvlkBXAZ9KhJfbsC49KeyJWQV7mQN+g3qdKT8Jp/7LU4JkHZ4jTJ
         gy03D6zFN52gdX5QydCQ2sWdy6Xu8hEdmpAq/kWCuDrcOn6alvCaS2nmuNLblh1DUfAO
         fBWusdd0rwy50gUC4NJkwMZ27aM61KppFykFx55ryDe28py1Y/5HFgxfu1NbVbtXTMWO
         sJAs0O5r0Xg/faK2TFCwPMYhn79/8fjLXgPSu5Rh0ex6K4Yvxikw/ouWXXeavz3LWjfd
         nFcac5qzEHnlhNPjZlnvV9qG/oZee7UtH0vggrYtUUVmMY6MdzUwzAwEeNjvGx4nFm4G
         KH+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787406849; x=1788011649;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kA/leMB5Bml9VvmxH4fPbAWvPl/SN0OCbc+8KnqiWlg=;
        b=OveMtVlj9nxdy3wapRjNevzUMYOh+2T3Ag7kEZ0Vu0atWvbsT/Y/D2AI9ICO4O+Y/F
         A/jb/yj1fmyhKcd7rLO9liyT5XAD/cBvZ9zn7ug9Gsi9ApjlcWvyqXSOzDETgpma+O56
         /2ufcc1WjYW4Vwn4VDgefETL9P2iusZp45ZUges+yMbMX4yCY0ha/UZjVT11BFws/Xuj
         xoEjzdob0zNwvUEr4jGh08FhKopZImYCZu7o6rmimc9BCr83z/u+KzjpISiirTQMYDwb
         K5Zo+FC5bc/4+/DB97avQGE7bplRBxDAO+De4sxonG0JQJx+eRdxnlmgAOowIapD0sSH
         M9kg==
X-Forwarded-Encrypted: i=1; AHgh+RrEWdZiwZ1KeW1Ly6R0QI09rqf8uF4hkIP+T2toK0vvLWe/V3uWiH9eEB9lN+t4bTOmO+d5mqC73A==@kvack.org
X-Gm-Message-State: AFuF++n3OsLpvrZtipRpggS68Do+2iis3uzvGFswUkomaLxKAugVZQl0
	kUzvhe21pDC5UK3ykHP3891tH590A5tGgQprhvLQgDHU407QqimjkRgyN9jzYUdUJ8HIBvb7VQ=
	=
X-Received: from wmlu19.prod.google.com ([2002:a05:600c:2113:b0:493:ae35:2761])
 (user=ardb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3584:b0:499:8777:ccba
 with SMTP id 5b1f17b1804b1-499c19f3a09mr55389195e9.12.1787406848610; Sat, 22
 Aug 2026 06:54:08 -0700 (PDT)
Date: Sat, 22 Aug 2026 15:53:27 +0200
In-Reply-To: <20260822135323.795946-11-ardb+git@google.com>
Mime-Version: 1.0
References: <20260822135323.795946-11-ardb+git@google.com>
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
X-Developer-Signature: v=1; a=openpgp-sha256; l=1748; i=ardb@kernel.org;
 h=from:subject; bh=plFvUlms3IX09TbA06fuB9Z3i2CHbmXiXP7osp2wqLc=;
 b=kA0DAAoWMG4JVi59LVwByyZiAGqJqduhaXhTLES9U3wa8QeLoLCFbLjTooS/ld4OUN8Ev+zVT
 4h1BAAWCgAdFiEEEJv97rnLkRp9Q5odMG4JVi59LVwFAmqJqdsACgkQMG4JVi59LVxbUQEAwLd0
 PDSvV2zyQlqIymz5n+L53p/Botvaje9PasDJEM0A+wcjClUJb3hpwyZuyoMYZ/HDrLzn0R7+g1/ X39juar4F
X-Mailer: git-send-email 2.55.0.860.g4b6b3295ed-goog
Message-ID: <20260822135323.795946-16-ardb+git@google.com>
Subject: [RFC PATCH 5/9] arm64: mm: Permit permissions changes on huge vmappings
From: Ard Biesheuvel <ardb+git@google.com>
To: linux-kernel@vger.kernel.org
Cc: Ard Biesheuvel <ardb@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, "=?UTF-8?q?Adrian=20Barna=C5=9B?=" <abarnas@google.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Kevin Brodsky <kevin.brodsky@arm.com>, 
	linux-arm-kernel@lists.infradead.org, linux-trace-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-modules@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 29E9E180007
X-Stat-Signature: 4bzy97gydymebhbxeqad39h41uddjhq1
X-Rspam-User: 
X-HE-Tag: 1787406850-126087
X-HE-Meta: U2FsdGVkX1+Al4UrnfxhA6hK+RIwCwGOHlsAhUNLWtqkE2MPK/df0QrruaFTNFJd0YKxeTvjk7OzSgrA1/VEeT3Cl1Mq7+c9Ga8yiFm6PI7leaEGYBAUEKz+YgXZNJIUIJRx3aKeBch9jjEAuzvSZbE5osywl/G1fw27J0tyek6CBvzMgUWswRBCqbj4/FmDRJQUKpePzmrOAquZG0KXI4SqFnZbhiZLDMrbQwf2q/gNZaM5iF5ehfIxmHN1Sj0HRdmTOBTs6auq+w/jg1ZNfFhHyd2jo46/IUwaP1ChkaK/B26mqG1bxZudwZicecYi0vphlSKFQa5H/j7yTyeJwJCRdJvyB/wGQdlxkwb5eKN+Sbpqr35ID6DPf3P5elRE/6RSrAFMYydrYDJjX9LVbxvgEhorTIe+mIWvTKmm2shqTCDwAPtCaFQ0grimXOySr/ii7uBpjEKVKlPW+B/dQAR7EgKM4ntiVmFaKF9uQthu2bvxlpV28o1BocMO2QHZhOcCl6xo+cm9h6EIvTh4xTTcqeue7PKEUZJqB4fu71ExQ7+BhQXA6VgKHHY2rDqUhCD5xtug+m6u8VCjrmqsFfR99Fn5hSyAzwETgLeKw5X7zJh+Wf1UaWRhha80h9aKckJkJaNxqJu8Gw999KsuW3M0Bx0qzrNAdbMeGfpmmPyZHBDVGlE+VlH1yXs9BmR3TxtFnhUqMrwaIH1mtIQxvtk/tRzFAWQahhIlDiYKrCeqBPtIhGDHzJBJ1CIRPOFPZkFqVKano/9ha710JO4PoumOVXFtBqsPta0ASBtP6wLlI6P3Rq/ZAe83l5xuV3htOM9IA16dP1nVyUFkykBNLzpowWyPTxC93HfEsNGlJ3ZJLK2yyc/YkxlL4hXlRkO7HYzVzzr6ShE8UWPRBMKrV4AKsQHn6XrXV5vZAuaQ7u+U37fS84Br/biMYlcugX2Ibphzm8ZuCsLoqcOj7ZY
 0vLsIdda
 X12zAfUOGi5+WCD2rRXnEqieEh1bCECtC1sAXRqjUPu1/aPMUpWLtu2iMhLhYdMm/P82K2FsmqsNCtw5P+K9NhtCmMz9JbK+06jaW8sewUlRj5jGCcCCmLKy2xwUNWa/eEJ43jtlRHaWI2DJbOwedZDiLs4aEpXHk6MP/2ClxTDsze7S4A8/LPW6JlVJtbxo4k7t+RYXG7RcHu77DR+h8De/YL6M6MU6ukCEbdcLNaD0edL5rDx9DdYgqum8+XmyaQAsDHaWoHKwt6XKR0nKdqpXj0RgCv2P7WvPVV+QOifTTA9v+DXVE4j1NAAnTCASdFleFuWwOQdOaegIhHPPtMUXo/wQKIuc4hmOcMyX4gvtRXcIK5Edx+gKJyFll4FJKB8nDbOZhfjaYhs/Ghggk4MD5rKaOL8lkmFjjzLb4iIA+eetrIzS5MoAZh9/NDTllaahGA5LfpAeDtLimK+4H0l41stTdRi317DvsKibpQGD50JzbQm8HRdzTRO8GKWb1hEhNkLvJt6uAFjmNvkaW8cCv8TLh9g6CkpwSwRMctJtdyfPEFUfGLrfMOVUYcOkAe0+73s4iXb/IKsanUoj0CuFWX6VD2afBJDjXmzqUeWKg7FQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ard Biesheuvel <ardb@kernel.org>

Allow permission changes on huge vmappings in cases where no splitting
is needed (i.e., the region is aligned sufficiently), or when the system
has support for splitting live mappings.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm64/mm/pageattr.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
index bbe98ac9ad8c..20ff9cb273c1 100644
--- a/arch/arm64/mm/pageattr.c
+++ b/arch/arm64/mm/pageattr.c
@@ -169,8 +169,6 @@ static int change_memory_common(unsigned long addr, int numpages,
 	 * we are operating on does not result in such splitting.
 	 *
 	 * Let's restrict ourselves to mappings created by vmalloc (or vmap).
-	 * Disallow VM_ALLOW_HUGE_VMAP mappings to guarantee that only page
-	 * mappings are updated and splitting is never needed.
 	 *
 	 * So check whether the [addr, addr + size) interval is entirely
 	 * covered by precisely one VM area that has the VM_ALLOC flag set.
@@ -179,7 +177,16 @@ static int change_memory_common(unsigned long addr, int numpages,
 	if (!area ||
 	    ((unsigned long)kasan_reset_tag((void *)end) >
 	     (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
-	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) != VM_ALLOC))
+	    !(area->flags & VM_ALLOC))
+               return -EINVAL;
+
+	/*
+	 * Disallow VM_ALLOW_HUGE_VMAP mappings unless the region is PMD
+	 * aligned, or splitting live huge mappings is supported.
+	 */
+	if ((area->flags & VM_ALLOW_HUGE_VMAP) &&
+	   ((start % PMD_SIZE) || (size % PMD_SIZE)) &&
+	   WARN_ON_ONCE(!system_supports_bbml2_noabort()))
 		return -EINVAL;
 
 	if (!numpages)
-- 
2.55.0.860.g4b6b3295ed-goog


