Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FFB3C87FCB
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 19:18:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CD4E8E0001; Mon,  4 Aug 2025 15:18:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5316B00A4; Mon,  4 Aug 2025 15:18:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 394158E0001; Mon,  4 Aug 2025 15:18:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 280636B00A3
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:18:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E5BCC1DC773
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:30 +0000 (UTC)
X-FDA: 83740036380.08.7184123
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf21.hostedemail.com (Postfix) with ESMTP id D5D641C0007
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 19:18:28 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xH0vprVG;
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754335108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WLpMpvoA1z4oTuimkC9AbHvBIqL/ABDs45bxwTwR93E=;
	b=V7yHO7kEPOkFBOcIr7+YdoZQCeOUzfwqzYpS1szugul4JzR1fBom1xmqjUS/H/fa4WI9KV
	jzMG3sW1veO1ibT8w0b9TAdtPX9M7V6bz24bsP3BO5e3sOaObtMCfaAhy4sTXWQ/LZbu1Q
	6fD189j4HLJ64RiQNkmb0v2a6h5uIRc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754335108; a=rsa-sha256;
	cv=none;
	b=TPz80vN294KUQ+y9dUT9HZQeqDZQZR8v7PG6L2HyIaKE8wsjODOtFuKItEKpJJbQFDEglP
	KTkahBUU09J+2K+sWzGNb1idlI7YLPhbgfrF5vucAES/XSrAbwyiWnuFSG9OQmvAauizSX
	BXYIQuJ2pGLtSfPCCR1k3Ll5zaoTk78=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xH0vprVG;
	spf=pass (imf21.hostedemail.com: domain of jannh@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-459b3904fdeso165e9.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 12:18:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754335107; x=1754939907; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WLpMpvoA1z4oTuimkC9AbHvBIqL/ABDs45bxwTwR93E=;
        b=xH0vprVGqS7AbzStnP8eQFPUiAM0rbDX8WT4gJyMzN6eVnVlpyD23ECLI/XR4mHLbj
         XmDGi6gh8MsVs65A0CbiSnTMpl2WXQXuxAhYK38NNRc32hyXkJN9ufV74amZzDZCCs9R
         lOqtUB2U/CheGIHFKIk+YpSX2w6RWPuWUlzugepqBtZ6RpOy0Vrht9/CKeHE3uDsm7OC
         iTGMLftGTbLsrhK82T6S30CHe2xK4qkocVWt4CBT1sIouL8f+/Zx8J4Ov40OhR8zZyoA
         Sg7wKvr/O/hg4ocaodEZyf3YUC7DxHgvg4OT2NHGjT6BzQQJ7lmsCmQA02EvX5Af9R3s
         FBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754335107; x=1754939907;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WLpMpvoA1z4oTuimkC9AbHvBIqL/ABDs45bxwTwR93E=;
        b=TySS4mpPwMUYNL6QhPSFzqbGWAjYt0xejGGHLDXoBwZfeC3QfgmVElH7TgS+C0vNec
         U1W3u7qrbRSFHlFktihk0JXuABkqs2KQipTV3PcTf5FP4Fr0jSmfSbiCO1v+6SCFnVbn
         SbneNs++ef/Ak6wOdXsAq5ExQn+nkTfXBxttuA1hEarL8UI6kTD1wq+onbP/q4luXo4u
         Sucs9ObrWJWUMcGi+/oQotiRgVN6Wj4G4iurSxoxCzjwH1RhFx+xYD1KWMmSL9MVmllX
         IL3wgKS/X+fYb0nozITczjfgSuzaF5wkMbSr/lYdjzGFxScRHufe17Gyq+axAM/l742I
         rU6g==
X-Forwarded-Encrypted: i=1; AJvYcCVSitI/iamp6Qr1OzFHywmo/q1kYgIrReycOKDrrFVFqVgnA90DZ8iWNAFvPJP7EvIKjwv9y+nEfw==@kvack.org
X-Gm-Message-State: AOJu0YwZAyohN4CvS3vj8skelB87L0GVIpTBhdVjCDVKU0AX8kIvSbt5
	Yy4cPxu0nJHebO9kBHC3jELgVdFWpkAoePwMPmNGekpqGWW1HwlLSOfj/B4SUeQB5g==
X-Gm-Gg: ASbGncvq7eJAWi2AtJJGOOBKf0wDTGAs3fE1X6yC2edCxX8TRvxvfdW1NXbbO2MOxfL
	bOhrjf81oAjPxl/KEXf3WK4f8czGHXw8ppjt7dsvtFx8ZfetedKWT1XAxZWMW8M9lc79+pFAI/P
	IIR8mZDhMe1z08LWtPu/31tFflVoVbPyFM+B5DuU+ujs2+xYP+qKMFcR6VsBPUecXifrM2rmPmz
	aCWPXc2nwHgMgYhcSupIl5cYGRlnhrbIIvjQDiV+CO9mIbGX8OPGj8aYLIzqDSs8iN1lK6TUA5i
	yGCfJmEGQb9VTfnjiAeL0/dkH++qeEX46NReX4CV1biuu+WHsuoY3Ud2N3S1qVOvoyZRFStS+ie
	nBCOd/kQibQ==
X-Google-Smtp-Source: AGHT+IFk5pynUlS9FSBP/BDYtXEaR7BK3ItjDT3ayyMn7XCBf8iPKo4JkSB801Lzlyp1iGac3gCIhg==
X-Received: by 2002:a05:600c:3b8d:b0:458:92d5:3070 with SMTP id 5b1f17b1804b1-459e13d16demr154465e9.6.1754335107203;
        Mon, 04 Aug 2025 12:18:27 -0700 (PDT)
Received: from localhost ([2a00:79e0:9d:4:2069:2f99:1a0c:3fdd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3b79c4a2187sm17020318f8f.70.2025.08.04.12.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 12:18:26 -0700 (PDT)
From: Jann Horn <jannh@google.com>
Date: Mon, 04 Aug 2025 21:17:06 +0200
Subject: [PATCH early RFC 2/4] kbuild: kasan: refactor open coded cflags
 for kasan test
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250804-kasan-via-kcsan-v1-2-823a6d5b5f84@google.com>
References: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
In-Reply-To: <20250804-kasan-via-kcsan-v1-0-823a6d5b5f84@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>, 
 Nathan Chancellor <nathan@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>, 
 Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Marco Elver <elver@google.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Harry Yoo <harry.yoo@oracle.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Jann Horn <jannh@google.com>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754335100; l=1736;
 i=jannh@google.com; s=20240730; h=from:subject:message-id;
 bh=NjE72AJfCjjPyCkru/f2MOaH1lg7CZ5EkGcOF4OBDks=;
 b=BDqvSo8zU4lISb3FEBItz3PSoNVV4TwDjBHeB1I690t0v00wbQL0cLH2axC58YYT1CIBDzJMN
 B6MMKb0Zo8SD3vG6eifgKNbCFz0c5cSCDSxaGd5VhvQ+hGbZMmExTSZ
X-Developer-Key: i=jannh@google.com; a=ed25519;
 pk=AljNtGOzXeF6khBXDJVVvwSEkVDGnnZZYqfWhP1V+C8=
X-Rspamd-Queue-Id: D5D641C0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 5dwoufosf7zxgwttpnjybtxwy8f17agw
X-HE-Tag: 1754335108-662888
X-HE-Meta: U2FsdGVkX19XEpD92jierRGCKCqoeWQ1QPHhjw+VoJX8X3Eki+57Y5LuVaj14tSy4UoEa/kz2D9ucXXhgbcWrioLMfBwGGXfq+hFcD26zyrilXwwsoPJqUPz4c32jWdZm0gYxNtNg7HiFxL5F6+RtI4B3d3WqUdDH6uy2YIPLAMezHupZE3H6z4oOIuLtwEq4RtlGQDIBYMyXPDPsEKGxbHlVRFdessCiL2G7QinT+dgCwf9HFdVjTlbXAwzIXGnICxKH6K2Vo/pAfnfHm/ye5T5ry6fEvLPUJBS29GqQKB0Zje27p40iyc5FopJ7z8hF4znmXctKDRykFMPM5JnjilB8lqI7KKT/mEObjln1Tabmv2Mmw7t3tjYZkmsOY8rAGLpeIPSSOUn96ityOH1ChS48TnY43NEaQERBgfeSBVxlBXzNdfhuAb2OwQ3UZELdRgYuPvySuD9f5+TQ1EpLio0th3k9K+we3TlAY6H/IaUUiW9W7XbypU1YbX3ILlGoTiP/uDxb/WhxFlFZIDzyLRmF6JwyR3b+gq4neEfd0MAQry51Iqc8/dsVzz2WcV3pI3FejQu1EJdR5fMM3UEqzaSFm4uUIeihZgtxA5Ni2fowv2FJK7Wnasvn5bP+pmPMcscVN1+PQchzTy8EsfkAxeenCTLTVzdNUvDtqpJnn28DGBXVgSITPYgpR5Lb9SKfIueojTHkf5i/efzr8XZ08V6w3rByPYXRefdH6UvyYV8m3JPgdeZIrh93s5Drro5rl26PT0SCYo+F3c1gfD0CZo8Y3mRcvhiNLWrCA9SeF++FO4cvxiHD80BQj1jzznX6yo7I+9Orbt7jN4H534lr0Awujmxd44WeEON6s0g8rdMb/mzOQYiGlGBhfd66eKX7Wo5VDidnC4Yv4aaU+7CrSMuEJOhdD99sGfNixMTURgg18JNMlwekeCFMzwjq77giY1SMJKFQGoS96BPA4D
 eNyOEdHI
 s2IV1GqU3u9XY5bFX2qZNxDSEQCA7xdsYP8UkG/I3z6cgaslYad77k1Wcw8KqAJ/fkcvlgRJw7LRo9V6dQD+yEQ2MNvoYRPeroknh8mHz3ayEiVL8o5NINF7wV2djDQUwYlEvqrtdas68Zlw2O4wGlPIfqasDfek8l0p2MpxGRbpZ0oIwld7y21z6Svr5Y9xAo0kEQdFJAiaa2KGVERI+Q+8QthiEYI5dhWma9VC+G7uiRPDP8OFqsd4cghHsKSQaWEl/qQU5qbWLlYU9jKvFpZDey/yytUxJnA3wMNMtybsjVB7/Dv6iiGDhRct6PA5SlXs959lFc+Y1o9uTy7w/iPm1xJUG5hdUVnahetOLiEmZUiyX6JnRT6kO1uQabj7XG0QHcna4CcqtzzUn0d3sjG440g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the Makefile for mm/kasan/, KASAN is broadly disabled to prevent the
KASAN runtime from recursing into itself; but the KASAN tests must be
exempt from that.

This is currently implemented by duplicating the same logic that is also
in scripts/Makefile.lib. In preparation for changing that logic,
refactor away the duplicate logic - we already have infrastructure for
opting in specific files inside directories that are opted out.

Signed-off-by: Jann Horn <jannh@google.com>
---
 mm/kasan/Makefile | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/mm/kasan/Makefile b/mm/kasan/Makefile
index dd93ae8a6beb..922b2e6f6d14 100644
--- a/mm/kasan/Makefile
+++ b/mm/kasan/Makefile
@@ -35,18 +35,10 @@ CFLAGS_shadow.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_hw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 CFLAGS_sw_tags.o := $(CC_FLAGS_KASAN_RUNTIME)
 
-CFLAGS_KASAN_TEST := $(CFLAGS_KASAN)
-ifndef CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX
-# If compiler instruments memintrinsics by prefixing them with __asan/__hwasan,
-# we need to treat them normally (as builtins), otherwise the compiler won't
-# recognize them as instrumentable. If it doesn't instrument them, we need to
-# pass -fno-builtin, so the compiler doesn't inline them.
-CFLAGS_KASAN_TEST += -fno-builtin
-endif
+KASAN_SANITIZE_kasan_test_c.o := y
+KASAN_SANITIZE_kasan_test_rust.o := y
 
 CFLAGS_REMOVE_kasan_test_c.o += $(call cc-option, -Wvla-larger-than=1)
-CFLAGS_kasan_test_c.o := $(CFLAGS_KASAN_TEST)
-RUSTFLAGS_kasan_test_rust.o := $(RUSTFLAGS_KASAN)
 
 obj-y := common.o report.o
 obj-$(CONFIG_KASAN_GENERIC) += init.o generic.o report_generic.o shadow.o quarantine.o

-- 
2.50.1.565.gc32cd1483b-goog


