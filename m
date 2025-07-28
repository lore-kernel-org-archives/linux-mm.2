Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45D80C83F26
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 20:18:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F576B0088; Mon, 28 Jul 2025 16:18:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80FBF6B0089; Mon, 28 Jul 2025 16:18:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7258D6B008A; Mon, 28 Jul 2025 16:18:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 61A7D6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 16:18:27 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A6A158DAA
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:18:25 +0000 (UTC)
X-FDA: 83714785770.08.DC3222F
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf03.hostedemail.com (Postfix) with ESMTP id 29EC520014
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 20:18:22 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uhJOyUUX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753733903; a=rsa-sha256;
	cv=none;
	b=wqbjBV+JoeKr74kP0hf3Aa8Ym9SMg14zEiuB3OLJOmJEIEqifj+SaQI+5yBaxmw5dnInic
	7djxvOjLVjlFW/myZ992ZWZXrEVu1ZfxEUBFWFNOmA1ebsut1KP7yFgLZLO/2NvVx8rywi
	HAwg+xxRA0r5LvDJn3nsSZNwl2viKu0=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=uhJOyUUX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of jannh@google.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=jannh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753733903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s0cHzSvxGHBD6anMEro7maJOsM/+ZwrFtNd3kS/G7GU=;
	b=eVFAcIMYyqyNCBV2eBW9lSHHh19hSYhiN/zM/TGFId1rl1prBtvhPuQKOxQ9SZjGtonqYU
	2CxIDPu63pzKSBQ7OeJjeTmegl/nOwsPK4X0f150xMI6eTmtTuuHaAoElFDKsmMXWBop0K
	sC6drPi1pawzrc5/UtRyoynyIzqQR0A=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-553a66c3567so334e87.1
        for <linux-mm@kvack.org>; Mon, 28 Jul 2025 13:18:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753733901; x=1754338701; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=s0cHzSvxGHBD6anMEro7maJOsM/+ZwrFtNd3kS/G7GU=;
        b=uhJOyUUXZpb3++KumtgDY+HYgsymtYerDa9nw9yHXpkLFYBKu/QBX2XNO59r9IowMt
         /O8ea58RzjbnLU2yksH9tmzCkpudZXOCBaaPIrLrDgz9y1RS2GAe7icNt0GOkYBRhZwx
         yX+LCgWEcrlOG865EshKd4E+SOxLDGZZBosYcqlmTxLY7LohM/76ugpBrtNlgQkOyWoo
         jEfhVelWDyV4xN5NlTVn6U8jwyYJI+XILHuC/wk/aJ3t8RpifLrcgBxBfHPw2tNjspoi
         HmdGu37EjHgs4eIbQAFLUW4f+E4mYymDMVA4Vd4Pz7wSG2s7w+5XmPc1lFxxoIqIxbfM
         5caA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753733901; x=1754338701;
        h=cc:to:message-id:content-transfer-encoding:mime-version:subject
         :date:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s0cHzSvxGHBD6anMEro7maJOsM/+ZwrFtNd3kS/G7GU=;
        b=n737ARLJc6xhLNAMFz78ZHsyTEBfQFsnBhDrn5c4wu3YTA+CmC566R5D3E5PodgacK
         RXbKTGoSBF1FgRKH5vHmKeqX9QDE5/agLUDicDYpyS/u4d+bO3FUARfczzdClpmT7dDS
         +O/gEslQjY7/V791KTgCTdUsE1WEx+XYVcQu1l03+UfgIEtiHZVEuQY9WgWVk3GJTdFq
         OaBC4YDJU0JvvsgAMxma5wUDDo2WwRMmjsYaIn1OSIjs1R9nC2iOqW8FfJfjCwqXWx3x
         xhynaQlazR+x7ynrB9/egRmdGzSm5VK9tigrPsyUHxJ6rnH75Nv7nIqehG2ca2WlOl93
         rZoA==
X-Forwarded-Encrypted: i=1; AJvYcCWlcUWtBlbB74iyCid+E3W46vsv0vKTXZ5SUe6A7cACsxiUrH8EMCW3zTAAmzuGPhlkPJsIIazXmA==@kvack.org
X-Gm-Message-State: AOJu0YyURAVbbtzDLTSLIM1/6nGgHFpfkffQms/I53eWQkWMzNKIE2My
	rZSPwyy2gveZl+sijjHSDMRaxoDnZ/8MCmjpinRCwyVFjUfw3aMhDiqWqA/IjL79YgjhvSosJcs
	+qOogjCho
X-Gm-Gg: ASbGncsnmT6guTdT6lAETNpV3se3NAp0n5gHCraCSyz6mlcQoy0f8qo/4L5bEQ17egJ
	at6xn2ZUtAOtfzGmrVVjSzWFykqzJHm6hlpz4VxBGy/2R/0xQBvOYhXZSOpSbF+bhcxLLtaaiSG
	pm/1VdN0WBagfWDctpay6UbawK3dzL2PJPqoANW2TeWVWqH/8+3skoBd5HpDAXr25moiRJP0EWi
	Z5O2D+FQ4S7dUNcRDEGyZ4pfMj9WMs3RtnxKDGs4dXTBJYY78tOM/lIFEeHF8fnxkXFaJPxt845
	HEcZs6EvgsjAKVkRlL4M1C26+jfMDoGA3EX1V+pj0qObjiB+QxkcxeIERL/iJ6/hKpMWI3dkXpc
	fqF2HPHWW65mpvJpq0LDj
X-Google-Smtp-Source: AGHT+IHayh209RgU2OQ2Ql6nCDUMXhu0axdv21GxFZW8eJ+BL/8tzZhBPIchhicCa1tjRfY4ljX+Ww==
X-Received: by 2002:a05:600c:1c8f:b0:456:e94:466c with SMTP id 5b1f17b1804b1-4588d6faea0mr193425e9.3.1753733519713;
        Mon, 28 Jul 2025 13:11:59 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:ec3e:2435:f96c:43d])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-458705c4fcfsm167139575e9.29.2025.07.28.13.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jul 2025 13:11:59 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 28 Jul 2025 22:11:54 +0200
Subject: [PATCH] kasan/test: fix protection against compiler elision
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250728-kasan-kunit-fix-volatile-v1-1-e7157c9af82d@google.com>
X-B4-Tracking: v=1; b=H4sIAInZh2gC/x2MSQqAMAwAvyI5G6gF16+Ih9SmGpQqrYog/t3ic
 RhmHogchCN02QOBL4my+QRFnsE4k58YxSYGrXSpat3gQpE8LqeXA53ceG0rHbIyWm1aVxlDdqw
 h5Xvg5P91P7zvBw59gk5qAAAA
X-Change-ID: 20250728-kasan-kunit-fix-volatile-d2b9f6bbadc7
To: Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Nihar Chaithanya <niharchaithanya@gmail.com>
Cc: kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1753733515; l=1506;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=Lw44dNghmCiq28TogKJdMlT60+fsL5APY9+7UOE+tB8=;
 b=C6lZbcU2X+AJW0vETjhTQhf3UGiePUoutVdYlhO5KePE7UNaPnUOl8JEhfpjN20q0CI8rf9es
 golCyt2pFHDBgyH8gSS+VI4ja5yi+aO2ecmGVWz3fDq3wNJKKFrjOeH
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: 29EC520014
X-Stat-Signature: ft11hh6ctndg5aweh3p7ic4ufsxzwa88
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753733902-22271
X-HE-Meta: U2FsdGVkX18E5WzQzwN57Av2ZCouhGyWeq24x/CPlwsP5bBWBJf0Uw5eCyIQX0ySg+QR7R29+vMLpRuEFmheUJ5ipG6ZccfWE535QsXbxz5/pTUABdB7L4hBRb83IGABqvicloL5y4/i8xl9gYvV3168GSnSVRXTyAz3VIdJcUgWLBvesuEbalmUIxUMTjwQxR05TWgGPZzMsQzeD1eWCWbpf+gIHuBnNoJaBmWIaFoItMkvaNGAMPVrge/rSECQWmH6v8u6T0GccsfA78p12cZVJlcFduMB+H6S2iUEkneiOO+L7pbos89WYq5z+V6V6pMqp9mFbCeP2NgHa36H7oQ9OPY2uFMEcVD9i08p3fzLUetkH41g5eUaXHqElFcbQUYo2NvaC+GUaejt2ot1BS66EApeHF7SsNeJ9ehvDt7Z/kxbxREfrTNKbsYx3fzUg15aUGfSQt2tpwe9hYXa3aqqV24HDgXD4gERlSks69sgC4dnms2LYo+9Vq+vR0yA+bwtaJmUq5A/5pgFp9/mI1UMo6uspje68mXkCM+/cwxwH6BNKQuT/+j2hDRGyjgUL9apzYlPR3WaVIbQUWYR4Xy5b/PMOb+MjMAbgdqBLJxB1IfaWu2fTKKIKks0N75ECFnVzmwKpvzFN5LF/BcIjk9thdkbVtPs2OaY4pyEWxX4tMJZ5uOHtGLVOZf0mlyEsWcl9OGfuIaQMzFEmnPRXg9i1ed6p71b/OFIxGf8mlCIAr8O8uCEWoV42XU3NdilllRX6dynwJCGuxxMCjfzS2g6netJS9e9Yo9lbm1nOcHVzxCDa08t4M4elMC6yhsiUftH11d2FsuAY61ilaLekbYfayP2MUCdw8SjCYg6OpyMBS5caJw6a6DDTMLxLg/kv8Vr7eG7NwOz2IiTJ0g/SGN1G3woh/slkL0DcOEkKZGl+McH4eKUweoaEUHgDIUDxzE0iP/pAjEXMljM/36
 XitF2qHQ
 MyfftzRKf37FRSxdsrFYV0cb1IRHyV4V+ZjEoU6QQI2FBWGhV0GB/VmUxPXU5Etfi4ffUEppj4svGSw8ym29qIMYGgBfDdCS3JUAR/DzlyG/bfyIvMBbl2c5xov+mgELbXO+cUmabvC/f9avflaNhAG2P6/Mwnowng7YFDtkBv+ybnIGoVwm+nu/BZqlGcDMFV2ukKvIfbft9ycXeT+TmxU5UD5p1vGAOaD83o1sauFA4n0UJ5MvBvNvvRZn4bltGkd00JbPVKHQb//z5uXQba73tzuYWkG549pwp06Xc/25RMcCvvfw+LbRLDD84Ejky/mgGXtCXHu3ao9QmVp2JWW45N4x2iJihzigbjfU947Yo108=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The kunit test is using assignments to
"static volatile void *kasan_ptr_result" to prevent elision of memory
loads, but that's not working:
In this variable definition, the "volatile" applies to the "void", not to
the pointer.
To make "volatile" apply to the pointer as intended, it must follow
after the "*".

This makes the kasan_memchr test pass again on my system.
The kasan_strings test is still failing because all the definitions of
load_unaligned_zeropad() are lacking explicit instrumentation hooks and
ASAN does not instrument asm() memory operands.

Fixes: 5f1c8108e7ad ("mm:kasan: fix sparse warnings: Should it be static?")
Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/kasan/kasan_test_c.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/kasan/kasan_test_c.c b/mm/kasan/kasan_test_c.c
index 5f922dd38ffa..c9cdafdde132 100644
--- a/mm/kasan/kasan_test_c.c
+++ b/mm/kasan/kasan_test_c.c
@@ -47,7 +47,7 @@ static struct {
  * Some tests use these global variables to store return values from function
  * calls that could otherwise be eliminated by the compiler as dead code.
  */
-static volatile void *kasan_ptr_result;
+static void *volatile kasan_ptr_result;
 static volatile int kasan_int_result;
 
 /* Probe for console output: obtains test_status lines of interest. */

---
base-commit: 01a412d06bc5786eb4e44a6c8f0f4659bd4c9864
change-id: 20250728-kasan-kunit-fix-volatile-d2b9f6bbadc7

-- 
Jann Horn <jannh@google.com>


