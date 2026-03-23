Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48F5EF483DE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 17:54:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D766B0095; Mon, 23 Mar 2026 13:54:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 044DE6B0096; Mon, 23 Mar 2026 13:54:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9D2F6B0098; Mon, 23 Mar 2026 13:54:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id CC7C16B0095
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 13:54:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7A0BD13C1A1
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:07 +0000 (UTC)
X-FDA: 84578076534.22.62A2BC4
Received: from mail-oo1-f73.google.com (mail-oo1-f73.google.com [209.85.161.73])
	by imf30.hostedemail.com (Postfix) with ESMTP id B88B180003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 17:54:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UmIrB5E7;
	spf=pass (imf30.hostedemail.com: domain of 3PH7BaQYKCJMxIx35A3BB381.zB985AHK-997Ixz7.BE3@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3PH7BaQYKCJMxIx35A3BB381.zB985AHK-997Ixz7.BE3@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774288445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QvFV/sENwdGTW4IuMAnR3v5SRp3rVtVMFXWSWmq9Pi8=;
	b=0lVQLOpOUQ4RN+rnCOIi67FXMvjt07kCtqorCxiIURzMSrY1YAgIvxapYiukv+DAs18+Ds
	dTrZ+EV6zag6SQvEhDglYUsUaFA+F9iAtk8TdHQEvFvA8TSuhoGm+ZrEnWH1I1KjIcUsPF
	CU2JrvziP0ma+VrVvAVP95ceRujRZRE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=UmIrB5E7;
	spf=pass (imf30.hostedemail.com: domain of 3PH7BaQYKCJMxIx35A3BB381.zB985AHK-997Ixz7.BE3@flex--avagin.bounces.google.com designates 209.85.161.73 as permitted sender) smtp.mailfrom=3PH7BaQYKCJMxIx35A3BB381.zB985AHK-997Ixz7.BE3@flex--avagin.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774288445; a=rsa-sha256;
	cv=none;
	b=YWFshMvopdNzxwu98Cwgm/0lj2rSXx49PLEW7XnF1K6mukv+jKJ8TH5W3YEI0z2OCLJBw2
	miPeKXN9svH34W4UZjFRW1vXPueVMo8449aws/rnlDFoNBJaYC4fTipiGMxaxaJPaZbWtN
	w5GgwIWfkztum8fOKnHMKXHb1pNXfvU=
Received: by mail-oo1-f73.google.com with SMTP id 006d021491bc7-67defd9e300so11529753eaf.2
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:54:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774288445; x=1774893245; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=QvFV/sENwdGTW4IuMAnR3v5SRp3rVtVMFXWSWmq9Pi8=;
        b=UmIrB5E7NFGta5N4egN+rnbeV5UDN7/pOa0KnQmjmKz2ipZQWO6wA9z0swI/Q9uPF7
         0wDEpHNLRUhbcL2Qv5anKmX/I/UetzhG5jUnOkmXzpOh/vL+Uia5h6KuC7NuRetOju6c
         bL3Jn0A1cS3ct/FmL6k7LSkyWr5djpPlXkRMie9LG7kieT64mQYKw4jz8/RHyPI8ZbXk
         Pv8dUIoE1i+S/wEJpKkBEwWI3O8+wM+0K1Pmp64OHd6uL5DqDBszrJSITnCDsYiFH5Oh
         Tpr+K563VDU6EJAFAGaIvAD+Pg9IaEQmh78dlLVw+cxeKWH4MPcNpPFfIH4zKMC8gxeN
         MhMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774288445; x=1774893245;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QvFV/sENwdGTW4IuMAnR3v5SRp3rVtVMFXWSWmq9Pi8=;
        b=pDphuUn+RoKyNd5aEfF37wX9AXRvGIGMdKPM4YGVbmNe1c3kJM4irwMYHEnJ7/49NP
         /2E3javy3fAFXVaJ2SD3wGOz1Y0wi2xuborPrP3tENTM6/q4vKlJh1pGRf07xktKjTY1
         YfPKlZ7vXQ7Wis0tQ4JTNIFpBhNQ7PNcHC6Oh8LGr7vDqXJo9FCrAA5q2JJ5IN5XHVxh
         8RSj14K27JFY1bsJkKM5A078lS9em51tBZ2NHAdlX+4k9l7jmm5pMHz73T0RQ0Ywwlws
         TgjLUaYowhiooP4FAs0YvCYbbUu9Xq4ajroeOfepjglqzyFj+SvuttAsK1ouMF/b+U3w
         EJKQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxeMoQdOepWfKMDAa1tkH/MYsAzqUoyxIzygK0pppVrbDnNKPLpBBIa9TeOu5T/fuq2QGiMieTxQ==@kvack.org
X-Gm-Message-State: AOJu0YxiNj0MUCrhP6S+lvYBzKcSvQuwSU7Yw2xBGMoWs7OUn9iBVkEf
	9QwaODBtotwKtsmmC//u7yK8HBr68U+bH4fRTCOfmbhGVeaV1fr5KlckX69dLZkY/jhoL/O8vmQ
	bxo2IXQ==
X-Received: from ilbbq1.prod.google.com ([2002:a05:6e02:2381:b0:4f8:6375:8930])
 (user=avagin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6820:174e:b0:67b:d754:9524
 with SMTP id 006d021491bc7-67c22f4ed5dmr9551868eaf.36.1774288444594; Mon, 23
 Mar 2026 10:54:04 -0700 (PDT)
Date: Mon, 23 Mar 2026 17:53:38 +0000
In-Reply-To: <20260323175340.3361311-1-avagin@google.com>
Mime-Version: 1.0
References: <20260323175340.3361311-1-avagin@google.com>
X-Mailer: git-send-email 2.53.0.983.g0bb29b3bc5-goog
Message-ID: <20260323175340.3361311-3-avagin@google.com>
Subject: [PATCH 2/4] arm64: elf: clear MMF_USER_HWCAP on architecture switch
From: Andrei Vagin <avagin@google.com>
To: Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>, Cyrill Gorcunov <gorcunov@gmail.com>, 
	Mike Rapoport <rppt@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, criu@lists.linux.dev, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	linux-arm-kernel@lists.infradead.org, Chen Ridong <chenridong@huawei.com>, 
	Christian Brauner <brauner@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Eric Biederman <ebiederm@xmission.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Michal Koutny <mkoutny@suse.com>, Andrei Vagin <avagin@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: B88B180003
X-Stat-Signature: zjskppmnaajumzkwx4xunin9i93hpzmi
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774288445-277361
X-HE-Meta: U2FsdGVkX1+qgkNfiA4JoHT4Ncn1GbWNQcg0mXRZ4TKSiTbnY1DYb0a9Le/CvveQd4Iv8gQxhAXppr8cLv4N7KsW8/Tc4QcdGLZccivxShzewElb/fI+8AEA2r7uxIUO8sqDAN87ySc22hLP6XTNxzJUxvG7p8DGlTrv9OojRFdYnX1gsxi/mhrV+hOtdjA61rfXYQ92TURWbdDGR+KtPCWS3fkJ1NvLFFX6sMpB9bMl4+3k77kHgJSWam7Nl+znt/SkSFTLKy0IGJ18UF9h1NxbmOnwTYiaSLH1UJlmw42ZNAA/NC9Oin1ilVDKX4jCWHeNrGWUveOVMLTmewB2dtr5+7PTq1b5qweoZsx3D3vI5Oo4k9JYsyPwTGi1Ct5hMVE4dnO2Im2vOWqLtNyXHxlrNBqeqfU3sOEUCe+QdCUQGp1siItQD6n7hmcOHJqbzbl6kideyRnVUuHmURQvygilJwE3vPn27fEqkC/0N/GL9hsLqSQox9G/udh82fpOzlXjDLM5ubVko7PJZFUiu4Yo7luoSexhakyr+0ctCo3nnZR3MmMStFxNOsKFqCy+kQmnhu5FoJJAR8e1hHKi0YqivK87jlsCJB/MJZNVqoBkeZaIl0dcVNNWa/GdaHxg76IiEjEy7pzibGTzKLdQx/By3K6zwwjkFi2DHH2ZJWHcp928I3bk0QOJ2dnCH6t0PmGaG3LchRIw8KrC9d2PANrLJxypr9wrXJ2UC07+sWNxIuU7L4TVo3/UdNaXL3EUqTTD0Ltxu5k7yi6o/Ku41t5ZuiqR60qDiizx672tsaw4kFXKvp80JIlpA7Qus+47040OgNP+KGq1TVn38meQo6lgA1dmAL/mGhCuIO8+0az3vAmyg45m1f/zMQIX6u9fHp5L8MpoOmE+53yNalx/mqmfnMyTIf0W+JCUHE2PIBJ/aocAlJ44TY8ktuyp/RStlhFlZgLYvlE1LtopcVy
 t5w78DQ7
 Qn77ZjLlxjyYWGnHLfYdYFPYbO7Gb4hklQnGnyZGqmNNpJSC5RceK7oEhDM616+KAxekltxKwlKdfz4DPNmul+bXvNGBd53vz5l2fGwWD03y6QUlEwrXz9W8CAFNleXhxE2QAxXOkK4O6avx9bOloEnrwTdExJ0SBurRqTwDTBi93XnshzC6yyirWynhfPAAxJ0r3LE0MhKgne2/fDAr8ChEdinltiKzBSCa8zNnhhaUwNkECOq9lHM+fVepZAG3V+lhPaTGnUK9DPNOuzSxmgLJlloauz1ZCBlYmld9WjSKfSePeMK3NYhNSe+G98y47k9LFfTtINC7ACinW9GPQ/eIYOtJ8MxopeYoheU4mNuutybV/sng4B/BUuUSPMDk/Vl8KSFUOBFt4bOUE9QhWK0W1YPYb2A9uwm2+n+RhtytATvxzrhOjt/z0ne0tp+PTyeLl93dAyho2xl16uNHczcSao93T+vm5NtjfegSf7QqauJn15K7teT5GgnOmN7lDovIw8t3Uas4i6Tr1eAG+fA8Po9sRfKbP0pUC1JmbXleGRiVmdSoa7yzMD7DRLOrGtj0RdH51b7fUk3GZEXAyuVq9geBjNQFNZL25YrIAsJFStLt9PR4sOBJLIAqFAccuDFWR0T1Kkafd3V7ch5/dqBlysztLi3F+M8szAlbfvfp/ygA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The HWCAP bits have different meanings between AArch64 and AArch32,
so HWCAP inheritance is not applicable when switching architectures.
Inherited HWCAP vectors can lead to unpredictable side effects.  For
example, bit 0 in AArch64 signifies FP support, whereas in AArch32 it
signifies SWP instruction support.

Fix this by clearing the MMF_USER_HWCAP flag in SET_PERSONALITY and
COMPAT_SET_PERSONALITY if the architecture is changing. This ensures
that create_elf_tables() will use the default kernel HWCAPs for the new
process.

Signed-off-by: Andrei Vagin <avagin@google.com>
---
 arch/arm64/include/asm/elf.h | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/include/asm/elf.h b/arch/arm64/include/asm/elf.h
index d2779d604c7b..2049d42e2e6a 100644
--- a/arch/arm64/include/asm/elf.h
+++ b/arch/arm64/include/asm/elf.h
@@ -160,7 +160,10 @@ typedef struct user_fpsimd_state elf_fpregset_t;
 
 #define SET_PERSONALITY(ex)						\
 ({									\
-	clear_thread_flag(TIF_32BIT);					\
+	if (test_thread_flag(TIF_32BIT)) {				\
+		mm_flags_clear(MMF_USER_HWCAP, current->mm);		\
+		clear_thread_flag(TIF_32BIT);				\
+	}								\
 	current->personality &= ~READ_IMPLIES_EXEC;			\
 })
 
@@ -223,8 +226,11 @@ int compat_elf_check_arch(const struct elf32_hdr *);
  */
 #define COMPAT_SET_PERSONALITY(ex)					\
 ({									\
-	set_thread_flag(TIF_32BIT);					\
- })
+	if (!test_thread_flag(TIF_32BIT)) {				\
+		mm_flags_clear(MMF_USER_HWCAP, current->mm);		\
+		set_thread_flag(TIF_32BIT);				\
+	}								\
+})
 #ifdef CONFIG_COMPAT_VDSO
 #define COMPAT_ARCH_DLINFO						\
 do {									\
-- 
2.53.0.983.g0bb29b3bc5-goog


