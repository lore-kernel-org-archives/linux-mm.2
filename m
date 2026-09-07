Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCA3C79FA0
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 16:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C90F96B00AD; Mon,  7 Sep 2026 12:53:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C68A26B00AE; Mon,  7 Sep 2026 12:53:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59996B00AF; Mon,  7 Sep 2026 12:53:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7E7486B00AD
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 12:53:08 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DDE44401DB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:07 +0000 (UTC)
X-FDA: 85187561214.27.9435277
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 133FE80002
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 16:53:05 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hj8MpJWs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788799986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XAeQPdPGwWZkycRcbqHqvUFSglicl66turt58h60TpQ=;
	b=RssOkX8D8kDo2PP1NvnezcfxFi5I3eicyWzr07pvQtEUzPdIcMc4Qlitrj6i+gVlni9P/F
	zegUEa82XvLirtRdqAWCIKV3NePVlACbOfU+q2csjh0/AIVaK3Jjvb5h747GeznceSsz8l
	J7SOk5SQrPID3DtxnOZZ8hJHJPK2l3A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Hj8MpJWs;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of tasos.papagiannnis@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=tasos.papagiannnis@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788799986;
	b=3hf79+h1rraDDihgqALsACiTJ2yZ5KUBzKUFZcJGBJvzYTr4a/4PAB3Qz8nyWwh5VDrapw
	BgaRcket+WB5nyMpTB1NhkiNziC2eCkZlss09jsAqUa5+4bFCR6Jyb5P18j8EmJLSmentu
	uJhNm0ONrpjcQH0yJ1sKtyWgayYwvfE=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-49b96837ca3so29955505e9.3
        for <linux-mm@kvack.org>; Mon, 07 Sep 2026 09:53:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788799985; x=1789404785; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XAeQPdPGwWZkycRcbqHqvUFSglicl66turt58h60TpQ=;
        b=Hj8MpJWs3gN1sbdMhFFV2+6q/15ZO/UCrWsQmVodSqaR5eX6tpKf3YE6cF6aIz5JpI
         mYBob+f8khLQdy01t9bpi6+cCsrc6sGFg3UX+TgwrEddy2kouvLY83uB55XNb7H3JfS4
         sJ7KhGX6Fy4IgwFuDT41zBY9Zjl5GgMpqJApIG0ivxkk3n4eNpQXffic8YUywNVsQ5gy
         DDqKYBDlZTR6y3h4Y778114Meippb8cp3ETJRH5PdBm2y0mJnygkT3KPlAFSPSWskcFO
         isETAH2obAWTUXFuEIeeH0+oV/4XDkc1tU6U5yaXhOKZWfCFcS/pC8OSGWxtEdbXfnxd
         ZpNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788799985; x=1789404785;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XAeQPdPGwWZkycRcbqHqvUFSglicl66turt58h60TpQ=;
        b=Y7ygXfmHpfUKbv3OR2nQymY4PifI7Y//c+oONkGcbyQOvrjHLG6d7q2B5kdt65j2Le
         jppQCCZyqlDFS3dCJfdTZl84pTi3rNE845qmGTYf8a583pZOHmECiHDnSfXHVyEbPzQW
         B82+59Q2L+gx8aGqX9aYm4coNMh1qOxTWb6wiuVmKyY46vDIG6HtaBnFZ+emLEJ+xgEp
         FFrkAnNpLvTd9rAZX6QIbvOSghtvUzB32E2MmauSRrqGEAn709YrNmDofCnw8m2SAkOY
         PEeNHl301kl8fMXfeiHSj1QKg0HOsU5bLCohn7HsOnFRlRshgO02gZi8+8MWxR+dacxL
         kW/Q==
X-Forwarded-Encrypted: i=1; AKwUvBykADNHT1We5h99AGtJivFHei8T3C8PWWcXhzF1npAC3SJU+CSv+bPovmmCFNyG9a0qCRY37yaNpQ==@kvack.org
X-Gm-Message-State: AFuF++lccoXaOo2ZHn5c8+F7gUh35S9zXzHsRb7TjAYJDJ85B4+tDrpi
	aBoUhsG56C//gd/bMZHy6Wu2LyvgE5r29L0X30b8yYF0KR+owVmNmeuK
X-Gm-Gg: AYBFou25PJVamLJBHIehYbVCW7vHdz97lEOOYujEv/gQVYPRZarTSQLmMADcaG/b1eY
	3De3ysfB9yeUTXxgNW3GZ0fQ6SBtIXC5k9Q/3qh5dnqJE4R7DRNeaq+BPGqxsn9lQLqrlsfUkWd
	jH54l1dKeoDQ3q5amIhQltp1pfhg4oc+8w9vCr0YuOX9jRy7VikOJcopKkK3bsN69n/EZBGy0+g
	CPOP3GmnqGa57mg7/idryRZ6LIj7r4TTVdaYfhGQDOaCSmUrAnb/2tbfPjmmcegOMOc0IxsSYr1
	qTAyVaJC3xAaQPT5VjSpmqwyGE9yyTDyrsp1IPZbK9ncpFwEFcG2EFMTUgJFPqdtaUXMkGd/P9+
	QwKRxnBvGtEU+4RHP2vhImn4OMNi54qEquokaTOYv+MscG3DrgnqppKpm/2j2nvPmBGFEkrpFtB
	oZF1JytGClHoo3yrJlYG4Z9S3s1qxTC+W7NZn7sUUk9E3ow8ssCIO0qYUoLYzHeNWD48HDQoQx3
	A==
X-Received: by 2002:a05:600c:474a:b0:49c:e42b:a4ac with SMTP id 5b1f17b1804b1-49cf823f60amr212091925e9.11.1788799984684;
        Mon, 07 Sep 2026 09:53:04 -0700 (PDT)
Received: from dell-desktop ([2a02:587:4b5f:900:ef25:2f4:1792:4e6f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d03543064sm233022415e9.13.2026.09.07.09.53.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Sep 2026 09:53:04 -0700 (PDT)
From: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
To: bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	david@kernel.org,
	akpm@linux-foundation.org,
	andrii@kernel.org,
	ast@kernel.org,
	brauner@kernel.org,
	daniel@iogearbox.net,
	eddyz87@gmail.com,
	kpsingh@kernel.org,
	ljs@kernel.org,
	matt@bobrowski.net,
	memxor@gmail.com,
	song@kernel.org,
	sun.jian.kdev@gmail.com,
	tasos.papagiannnis@gmail.com,
	utilityemal77@gmail.com,
	viro@zeniv.linux.org.uk
Subject: [PATCH bpf-next v5 4/7] bpf: Allow reads through trusted-or-null BTF pointers
Date: Mon,  7 Sep 2026 19:52:17 +0300
Message-ID: <20260907165220.52431-5-tasos.papagiannnis@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
References: <20260907165220.52431-1-tasos.papagiannnis@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 133FE80002
X-Stat-Signature: 9cbwdfxqrypuk66dnf5grbpzy7haycnk
X-Rspam-User: 
X-HE-Tag: 1788799985-556933
X-HE-Meta: U2FsdGVkX1+iGRqPGrz/IK57TZ0EkRZQyQ8EMXHnRt+rcs0pB75tNxvFHvo/w13rBl9S0scT/qyEBRWkq8AxIU6b6A4ScoMe+VtKNJLZeEoC0LeAzOYwd2aXrZq16Tkx0yv7dzBmA41+rdkkNtBP8v3I4ujqw1PCqJF9HRTm6DtfYIhZObBA4XBS+Xls9P79xGH0ZEqj4/gE3ADNWcBN9SvfJS1ofyhpS1gTBhm+Frhs8LeyCJVWvvym/kCOtDFvUbpcLBsgkI5iP2rz6hrKBiy/cpRyDumAFSa2UNvjJRyOfP4aiXpWs4PCYl6EMZh+h7CIpvXlZeTL0k+nExXO6S9TWwcngTWINptUGyHvr5RxxrOw0aCpt5vkkv6J+QGIB5T13sFrZ9vGReeSnxr6lHgJ6pXwfWOJrxLONmUArOXEcHLjGMfpmN/lPXe1vkhZlPtgaMGGlCJkpLDveZDWGuWEacANv2wPaYUAV99hHugu7heSeCeyVyKqfiZug5JxhT8qnJo6/X0oRKGVlpcwgPiM69tjcPPyICBEZ3rboCkaivpGK60sXuThjzIu9zE9HsMWOLei0KNouHItnav/65sOkFeMK8dfVjfdVceAWLiP+dmVkKKrJKZWi2lSyhaa2kDYFc8KqFj0JVO2lTsEAgx6n+UHVZ5fShwmKiHwe6Dp5mKAfz71X5aI+IKHGKl7ch/iXHiPRFyEDpdTy9lt5iLJ3xg9t7lZLt/pGUCHYK7JouKQzAfZJySBC1RAQGLAacKfEk5Y2XTbvAv67a2tjF76Za2RCHepM44vJIhfmBnYR0ZV4xkT5eq+PzU6etwSq/osgvK5bTBzUcsoZ34RX3Ixi6ZRd8+3P2IaH0n5O0xGHwZ4pWGaNugVyN9MBPLIicWggCKW5+dgzy8KroenSzZIhtuIGHwvoTfaut8/jpg2hvllgQGrXKNBVdUnnp0FnIPMeFwdx/5Y0Iicicb
 snq9eK02
 FnbCMp8ko1IEsO0vqLIUNB1OGNxe8a3WialJvkb4P9vgAin2/6XiPkDnba3SNV7i+OGFwHKSB03m6WSAE7slTZVOKjV6ZTfB2NcYyaN9FTBR4e8HXBoJxAO4f/Dj2tOnhT6W3U5wY8tKpD9f/o6xf+EVVXFiR5igEtzk+sQG+MBuYmUDCgfaZ7v+GgG87GltC0dFeqmgJz4ho2hXgYJeGBfZ/xh3JsJXjJgY9BBAXnWAMkY7cShJislpEtfDfrDTF3uDfuWpiXVMpsA3HrXW+SCOHfw2gUF2oLJ6R51xoWioxrAIKx3IG/FZHk5PNSLF81QvAckBRjqm8oAo9Ai0BxsOFYhxKHohO1YHB6f1aN36mdsLoTgBEj1tMCNJcFTnZLs4V0XznQS2BEzpfWk/FcVSctVkHGRreYrl/utAmrTrDZ17Kpd61K92cco5EVlWSklHvui5QNad7RjHfh328vm9mLNMN0k9FAKOwS1dhbV4K9IxkFAsdjcR6lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, a trusted-or-null pointer
(i.e. PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL) has to be checked
for NULL before it can be dereferenced. Marking a field from
PTR_TO_BTF_ID typing to trusted-or-null can reject programs that
previously dereferenced the pointer directly. This is useful as we
need to mark new fields as trusted in order to pass those as arguments
to kfuncs.

Allow reads through pointers marked as
PTR_TO_BTF_ID|PTR_TRUSTED|PTR_MAYBE_NULL without an explicit NULL
check. Treat these pointers as potentially faulting so the reads happen
through BPF_PROBE_MEM. If a read produces another BTF pointer, clear its
trusted flags and mark it as PTR_UNTRUSTED.

This applies only to reads. Other cases still require an explicit NULL
check. After such a check, the pointer retains PTR_TRUSTED and can be
used normally.

The unchecked read path has two consequences:

1. It uses BPF_PROBE_MEM, which is slower than a normal load. An
   explicit NULL check refines the pointer to PTR_TRUSTED and allows a
   normal load.

2. A faulting read returns zero, which is indistinguishable from a
   legitimately zero-valued field. Programs that need to distinguish
   those cases must check the pointer before reading the field.

The next patch updates current tests and also introduces more checks to
ensure this change does not break anything.

Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
---
 include/linux/bpf_verifier.h |  9 ++++++++-
 kernel/bpf/verifier.c        | 12 +++++++++++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
index 9727df5af83a..4f032ad83c67 100644
--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -1339,6 +1339,11 @@ static inline bool bpf_is_ptr_to_mem_or_btf_id(enum bpf_reg_type type)
 	}
 }
 
+static inline bool bpf_is_trusted_or_null_btf_ptr(enum bpf_reg_type type)
+{
+	return type == (PTR_TO_BTF_ID | PTR_TRUSTED | PTR_MAYBE_NULL);
+}
+
 static inline bool bpf_may_fault_on_deref(enum bpf_reg_type type)
 {
 	/*
@@ -1346,7 +1351,9 @@ static inline bool bpf_may_fault_on_deref(enum bpf_reg_type type)
 	 * protection, that is, the ones bpf_convert_ctx_accesses() has to
 	 * turn a BPF_LDX into a BPF_PROBE_MEM one for.
 	 */
-	return type == PTR_TO_BTF_ID || (type_flag(type) & PTR_UNTRUSTED);
+	return type == PTR_TO_BTF_ID ||
+	       (type_flag(type) & PTR_UNTRUSTED) ||
+	       bpf_is_trusted_or_null_btf_ptr(type);
 }
 
 static inline bool bpf_prog_has_arena_ctx_arg(const struct bpf_prog *prog)
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9e79750e2480..b5186e664aea 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6168,6 +6168,15 @@ static int check_ptr_to_btf_access(struct bpf_verifier_env *env,
 	if (ret != PTR_TO_BTF_ID) {
 		/* just mark; */
 
+	} else if (bpf_is_trusted_or_null_btf_ptr(reg->type)) {
+		/*
+		 * An unchecked load through a trusted-or-NULL pointer is
+		 * fault-protected. Any pointer derived from that load must be
+		 * untrusted, as a fault produces a NULL value.
+		 */
+		clear_trusted_flags(&flag);
+		flag |= PTR_UNTRUSTED;
+
 	} else if (type_flag(reg->type) & PTR_UNTRUSTED) {
 		/* If this is an untrusted pointer, all pointers formed by walking it
 		 * also inherit the untrusted flag.
@@ -6644,7 +6653,8 @@ static int check_mem_access(struct bpf_verifier_env *env, int insn_idx, struct b
 		if (!err && t == BPF_READ && value_regno >= 0)
 			mark_reg_unknown(env, regs, value_regno);
 	} else if (base_type(reg->type) == PTR_TO_BTF_ID &&
-		   !type_may_be_null(reg->type)) {
+		   (!type_may_be_null(reg->type) ||
+		    (t == BPF_READ && bpf_is_trusted_or_null_btf_ptr(reg->type)))) {
 		err = check_ptr_to_btf_access(env, regs, reg, argno, off, size, t,
 					      value_regno);
 	} else if (reg->type == CONST_PTR_TO_MAP) {
-- 
2.55.0


