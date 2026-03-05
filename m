Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B85C4F47CB6
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 18:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22456B0005; Thu,  5 Mar 2026 13:57:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6066B0089; Thu,  5 Mar 2026 13:57:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8876C6B008A; Thu,  5 Mar 2026 13:57:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 717A06B0005
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 13:57:49 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1ADB5578EF
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:57:49 +0000 (UTC)
X-FDA: 84512918658.08.976355B
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 49B7140006
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 18:57:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mq1ZDqU2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772737067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=M96FxMHGqXkOLvQsr+HkAU1hM7UNd5HvAR5XRWMmWUI=;
	b=6wQHG2qfKfeXKdDYMJN4IY61gZYyL/rZFpwVefKNTJ4f2eZlZaDNFrz+TfRYs1bxrxSbLh
	MwiXq/MG3PmGQjCW+rih1Ha9iyBVoFGhgwpVnOjPsFkerUyf0drHnqyT2F+6ICosp9gFng
	KYDjLuOxdY95MBCUg7Y7hhhANYPcyW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772737067; a=rsa-sha256;
	cv=none;
	b=UxXe0mCXRRt+wJDR4OA0MBLJYg+DJux8j+yoGp4Kd6PHrau1cvinJo9OaxRsDXrdWproQy
	pyMjT8CXirSmr8RVT0+OjEp741wOi2qyEEHVBPw/dZ0FtH+jKdrEMVkBIYqy5RdpimZw3S
	B3b0lyZjGrdXHV93hQL9OUP5KGJl9Mc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mq1ZDqU2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of ryabinin.a.a@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=ryabinin.a.a@gmail.com
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-59f7369392aso304175e87.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 10:57:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772737065; x=1773341865; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=M96FxMHGqXkOLvQsr+HkAU1hM7UNd5HvAR5XRWMmWUI=;
        b=mq1ZDqU2lKVyuZtBju+0VnW0IVN5TQSLd7Vd6mu31+gEclZqhuYpKBXLjZl7xhD5cH
         PKgJlaFymgwL4os2UpoKQVhDjDAoV+lyGtDW31LZ3WvHhw/nte5V4HTXJ3uIGpejLx4a
         eU6rG9b4ENvsqGsr1FUTtysXvPHujPTMmu5J8+rhTCOhI6Wv1SW5g10tlPBsHVduyPwX
         N4wZT/Xq9jR4TLpiCr+gx/Zh6rFc+bzO0B0nHoztHioH1GMP7wEAODw3/SJUClaVzIbt
         0UANhRD+zAF4eiJAQQsa3MMgxt2Srl4BDAzSx17cIH7a5cAGk1dExx3cic7FWTLRqtBX
         jmZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772737065; x=1773341865;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M96FxMHGqXkOLvQsr+HkAU1hM7UNd5HvAR5XRWMmWUI=;
        b=ubblMxvTeuIgHRYN8YK0E8TiU5uqtIH9RdWsx1QaYOcG+/OeRjRfOEWHG/grkckXPW
         ci1C1ytbzp9NI3Giy0ZrJbVgdjmFmsinqi6d855YZ1UCiJ6qY0wFE8KirEjjCUb3OVqK
         1J2HdQ3GpS72gdNTBRfywAlR8v2Ezyt7JEtymIW++uzfWxs7WQgbvKWzRIc08acuuHn4
         E0k1oqN+WpoVJbxwZFCcF47IvZ4VP/ih1ZPHrEokIZGTbyU2K+HjsY5wy6YeYSkDEHyk
         frSeh3H2XlnrndA2wT3h1i0Sq9t21mLFd+7BH1gdRx3acb985bNNa0l8McMhLXV9eyOX
         j9Hg==
X-Forwarded-Encrypted: i=1; AJvYcCXZeMOwmjx9WC5s+krkYGznZVThPTqXM5Gpyq8zoL4vmF+OBdvJ3hccfXhAQG0YgKPxxhP9wCwEWw==@kvack.org
X-Gm-Message-State: AOJu0Yyby+lysJsZR4XgB34IAnrnZuCpFJkt2NPLbPHWcFBR2WCBTSTB
	t2crWQ8frPpzVNQy4AYd9f5R5tJFRvZQ7YdEfbO1Zu9rothItgQ1MJfn
X-Gm-Gg: ATEYQzySfyUYt8hYOfdI9ZCP460c1iG0O0tywNakgCYlS/VfgCHSAGo5tVjrUf+ZIYf
	bJSaQ26PjauOjBd4jwJE9XXDu9pPVSNX0ptSSyO2nxrNvP92TgSfgF3n1KZFNtB2gIOqs5nVEyX
	soQDugwBC7fOUgs8X8S/Dnv7eXGePHuS1nc1YRB0r0OX2DI7UCBuuq2evqeooAZIiglYLhjkyw5
	dTwD1Q9WfEZjDrPwjeVwrntUqCk+2gtq6FNMEE0VBkzXj5sqvQcvRdRI27FHTkPo0XpXLmiDffv
	Irbsm4FivSOc/RTg+MfCJ334zeMKKblDdgXuKEgeSWg1Uv18bouVHNQuZTlvQcCyzgyoecPyoba
	YqcIi9PxCQIRgY+b6ccKxnGfV4NfTTup/jc5WX7eyqCtq8FOMEDpXf3oaXt0TMKElNMGSiuRIR5
	Ltw8jNSPg/uQoNdeivYf8TF3HS13S2FjJMVmYO3Bt30fNMHQ==
X-Received: by 2002:a05:6512:2c0f:b0:5a1:23fe:b047 with SMTP id 2adb3069b0e04-5a12c23cd79mr598071e87.0.1772737065001;
        Thu, 05 Mar 2026 10:57:45 -0800 (PST)
Received: from dellarbn.yandex.net ([80.93.240.68])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a12358ef25sm2163251e87.3.2026.03.05.10.57.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 10:57:43 -0800 (PST)
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>,
	Alexander Potapenko <glider@google.com>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	kasan-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>
Subject: [PATCH] kasan: fix bug type classification for SW_TAGS mode
Date: Thu,  5 Mar 2026 19:56:59 +0100
Message-ID: <20260305185659.20807-1-ryabinin.a.a@gmail.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 49B7140006
X-Stat-Signature: yi3mrz3edjspy6hydekuh9z3og93qhpt
X-Rspam-User: 
X-HE-Tag: 1772737067-239368
X-HE-Meta: U2FsdGVkX192Y2Q0nnnmanTIo5AbCYxWjFnTAqwVWHTkGvZNHeqkW5MwBo385WOMG/YmOUBHyOOp+UPMaNz/9gBp6fl/NY+5PjVA/w0HeqD8yJaJQKQIx3qhomk47LwX6RmmeHmrGb+uHBBg+5pDmPEl63NSGib69c1j2SXXCLA4TLKCUIVjVNxi0kEN5FwKwH96fjtCnh31qkGqCFTaiqwH1Ewa3cYRDQYrEHwF8fbt/+x/45xQw0Wo+GBa009HQZ9C2w6f/TQrzz1it7jbsn27xJl2gcK23SfW+vM7PU/za9T4mBQ/JWJWViqwtZvwQAxxqb58f73K9QiUiZS4NQfAkL1RkJfCQHLEVMoI1+67oIBMki3PFNglT8Rp4qPL/YQ3Xv27O7SmvSUnpalGu2n+ITV7wolmUc7GbNhYM7F04Bq/VFDOWchwAI16tw/MLySbqmogbbsQL6vJuPeQ07Qs1L37xsBqThpb42BarzFz9zkyA02dijV4h2bYgM/+XtLvvsqaLdfbkNELYDni3Vts4Z8gntcOSP8dPGnBTi2B2Ujb5SWIc5XrqO3akoBOtVdN918Xh6hBOn1eWSOH6Vur/q3YfeILWmhxBPviz2GWvpZG+/nUfEwoKcG0Ztz1yQ79c8EdDAx4Z9QZPcB/J1WKQHEz8Agfgpt8kELbRXKpwSjhWBxURKF4wXCyHduj+Dv/e09aihWkeMf6gp4FEDyE2yNixLqP/ZlObT7Sic9WQZFwuiVDZgP8PhDtdRHh/0YLmeAiSJiXeuhLZm0jXW+VBSmtDEXP+GXfXPrCq2+4aPgn9oknLgmbEpp4SeRmSCdxYRUSUtUuNWlWDfNWVo3VCb8Ke5875hqexuSovEAtZwGjyVRQH3tiTa//PIUFZzqSM3cPXQVA9HsZ6L5uEj4xm4csgMuAa36Oiihqy5T5yQyCiCyoHSZOikA8EeTxLp/r2IzVPzBxGOodzLG
 8kNb885U
 k5iPsvl7vxZrxGhl2UUMiBIK/wa858GVVR83X+hHfodDlWAGHxxhPkY6KL2duGC7Kg2sTm9qQmuiwwdta2rxxRErBx66EidCidOoW2B5PTh+lTsXwO9/IzcI2S4oy4LJSM9vB3ULhdKfnjs5i/zRG5UapmJmidDcVKJHAGu1dTW6lznWkBgmKp24VSCOp9uEkqH0jRVgGex9bNBZlvfOw6XCfe3zHRQNuJgoBe5H0/S/agHsQDyoVypkcm96O/7Pfs8KQWvIM6sm1pRITdW1YZu7NDJhor8/LWBDf9bP+mZ9lCM+ZuShTTemBu+8gi5Mg/0fswxB+zV/iCwDNDEhBD9nngpVLSdlaQgNsshO14KKMv+SekOCEw6wLTMt98Xm/mFWprCtSex7/6xY+V9hXvQVJ8ZZ+4Q1DtpXmdORU63FUZ++EUmgz8Gat34Yq4c1LkUeDq772s+iDhtNmsleve4Rn6Nr1K5bqqLfZ0Zi9/uxBpjTXR/6of3mBWynXZ/zOGKdSGl/q/ymqJV7owHW9NDaVCzkazscVJNv6+rHwpgJxOk9/Z58H+K35gw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kasan_non_canonical_hook() derives orig_addr from kasan_shadow_to_mem(),
but the pointer tag may remain in the top byte. In SW_TAGS mode this
tagged address is compared against PAGE_SIZE and TASK_SIZE, which leads
to incorrect bug classification.

As a result, NULL pointer dereferences may be reported as
"wild-memory-access".

Strip the tag before performing these range checks and use the untagged
value when reporting addresses in these ranges.

Before:
  [ ] Unable to handle kernel paging request at virtual address ffef800000000000
  [ ] KASAN: maybe wild-memory-access in range [0xff00000000000000-0xff0000000000000f]

After:
  [ ] Unable to handle kernel paging request at virtual address ffef800000000000
  [ ] KASAN: null-ptr-deref in range [0x0000000000000000-0x000000000000000f]

Signed-off-by: Andrey Ryabinin <ryabinin.a.a@gmail.com>
---
 mm/kasan/report.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/mm/kasan/report.c b/mm/kasan/report.c
index 27efb78eb32d..e804b1e1f886 100644
--- a/mm/kasan/report.c
+++ b/mm/kasan/report.c
@@ -638,7 +638,7 @@ void kasan_report_async(void)
  */
 void kasan_non_canonical_hook(unsigned long addr)
 {
-	unsigned long orig_addr;
+	unsigned long orig_addr, user_orig_addr;
 	const char *bug_type;
 
 	/*
@@ -650,6 +650,9 @@ void kasan_non_canonical_hook(unsigned long addr)
 
 	orig_addr = (unsigned long)kasan_shadow_to_mem((void *)addr);
 
+	/* Strip pointer tag before comparing against userspace ranges */
+	user_orig_addr = (unsigned long)set_tag((void *)orig_addr, 0);
+
 	/*
 	 * For faults near the shadow address for NULL, we can be fairly certain
 	 * that this is a KASAN shadow memory access.
@@ -661,11 +664,13 @@ void kasan_non_canonical_hook(unsigned long addr)
 	 * address, but make it clear that this is not necessarily what's
 	 * actually going on.
 	 */
-	if (orig_addr < PAGE_SIZE)
+	if (user_orig_addr < PAGE_SIZE) {
 		bug_type = "null-ptr-deref";
-	else if (orig_addr < TASK_SIZE)
+		orig_addr = user_orig_addr;
+	} else if (user_orig_addr < TASK_SIZE) {
 		bug_type = "probably user-memory-access";
-	else if (addr_in_shadow((void *)addr))
+		orig_addr = user_orig_addr;
+	} else if (addr_in_shadow((void *)addr))
 		bug_type = "probably wild-memory-access";
 	else
 		bug_type = "maybe wild-memory-access";
-- 
2.52.0


