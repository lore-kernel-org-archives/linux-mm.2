Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D6BCCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:58:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B589C6B00D9; Sun, 18 Oct 2026 21:58:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0A036B00DA; Sun, 18 Oct 2026 21:58:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F82C6B00DB; Sun, 18 Oct 2026 21:58:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5526B00D9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:58:24 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F3C68403D8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:58:23 +0000 (UTC)
X-FDA: 85337716128.24.D5ADD66
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 36C56A0006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:58:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BcEllLMw;
	spf=pass (imf25.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792375102;
	b=QHua2dd8xGExdYk2iWZtlHZ92EL8TjXqbIkw/SI59hLfjjnRvnew/f+fMwL0txdqpbavtr
	hctgxk4aKG+YCK9SKM9+atgXGaps0TVOmbRrpDijdhv0sVPc5LYHVyTY21Qq4Im5Xxulcf
	C0Rro0e5f8NH8qa0+Mo8dCUxw0gmKOA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BcEllLMw;
	spf=pass (imf25.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792375102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=DIsHUtJOv8JTVFKl2AI7iFPSk57QktOjQTbDJ2/Phac=;
	b=IRTE29/qrHz5qBbAnTf4A59V+pzDOaG9WQSj0OLuEoVkrT1akJ2UZ4AcnWsstzoTPRciCv
	eZ2sNcFU3YX9q2hu4v9xd5OwYeiaPAGx5rniwV/O/32k+uyhUt5eCgJeNbxFmaji5H7O8R
	wfwAjfQJftP8JXKryavHJ2qP+0S+vIU=
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-3535a54bed9so2151913eec.1
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:58:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792375101; x=1792979901; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DIsHUtJOv8JTVFKl2AI7iFPSk57QktOjQTbDJ2/Phac=;
        b=BcEllLMwGEnsm9Iloy9pTZ096O4LKlsmdGOjrMuRkIWYSTSN4KZgPSxiUCmb7r8vWK
         nPLwrC0sGhY8sm2ZDOGvE+gOwrwLIX2TSYfYy1C5ebp4sv3z32zDJqNm7UOCw2udwwtf
         WlNa3EXEN79EVhoCaMQCJ0kYAnuB3io95ZU08g6rwBxswE1fyRzo4MknRsT7LVlK738o
         R24sx789sttS5C3yanu9D25C1vIjbjEPHLMb9JcpOHuVevbZpmNbdio+mqhyCzJOYwQo
         4eJVYweIEkXSx7ovI8tLV5KeKsI9PuIftkAF1pSUzUS/Uk9TR+DwWQGv3r9/wG2jvU4Y
         mrRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792375101; x=1792979901;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DIsHUtJOv8JTVFKl2AI7iFPSk57QktOjQTbDJ2/Phac=;
        b=j5rHTbVXMkI5NK5QKWsgxcOP+qkridsaSQa2VnMmsrWuJpFbPvaNEl/jbGXSPe9alB
         TmAHZ94FFqn4FhMSV4XUaXRH7PxHMO7dPFuS5E5dmWai45rNYnHoWFYFMaF+tHFLz1KP
         q4jxh0Eh/XCOXeGeFYJZgjW8kFafBrCe5CyQdBEDwcQisJkHUxaRq5A/4QW/G0cxNu22
         YAcRnpKj5HnO04QHsi93cmAT5XwYfZvVf9pcK/U0Z7MO2VdmdvZkzO8aN62zGm88ef7p
         3Flyp/H44szT7M6wykAXQL7uvAZurXs6Zeq3HKzr4N4kbUpwuagqll6puTZOVpVFEjbs
         u7hQ==
X-Forwarded-Encrypted: i=1; AKwUvBxKWHra/oDCFZJN2h0XVptCTc8SOqXXieDoneIKemu5jERia4ZSk83aUNyhGt+m8t7vo36/leJ62Q==@kvack.org
X-Gm-Message-State: AFq9FYIKwti9ES4AJJs+REAQItn4OofvoK+Ckpo+earlqjRzhO/Ol1wG
	MvcUvgc6fadS94bQBLubHYt5rWphj9xfm6hCsLfjWQpnCAqTgrkqcrEl
X-Gm-Gg: AYBFou3dGbCjwW1wvohIW1ulNVJXdvgTfbAffbvGJ8qdEYjovzoNCfNKkyrZ/F++5pd
	mXmRPJCPgFkkS79faMkrZwjL3TKhj/gitu0l/caLihws0a9RsAPLV/1Znl7W9Nq3qgNoRZdjB12
	mrL8attKsUxzMCwRmayY9RtD9R2vx5ebR3w0ym9sbz88FG62tk0cP1kLYnSLerk3pq+ZMP9aZkn
	Bw7ce3Tu33dTRsx5TFDNtr7jasQ+CSRgNPgxEqWAFKrSKL+OIUeOwARLUHrOUAOBoV5xjco0w8d
	S3wXcn92VAYXn6e0a3JHPlRfF1WM3sz0wrqJZa7i/yWRMbtTICrNaNKLDbYKDvMlPyHjtr+lzYP
	NnjuktmjjloQTAsjIp4HTtUx0JNcyZM9cozI6bevP5/I6pDKYCcIiMPDEY4Z97IMwDkmeaV1YwL
	2ysaBE4QaCT4k71hl62N+qoQAPXhkAPMuKg+KKeJXB8109zW/4Z7p0KWecvxR+kaRupf0=
X-Received: by 2002:a05:7022:150e:b0:141:b2c3:d84e with SMTP id a92af1059eb24-185120a8bb4mr10990864c88.11.1792375100720;
        Sun, 18 Oct 2026 18:58:20 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831ba424a6sm24177311c88.17.2026.10.18.18.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:58:19 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Subject: [PATCH 0/2] word-at-a-time: let KASAN see load_unaligned_zeropad()
Date: Mon, 19 Oct 2026 09:58:08 +0800
Message-Id: <20261019-bug-word-at-a-time-zeropad-kasan-v1-0-f21a3ed6a477@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIADB51WoC/x3NwQqDMAyA4VeRnBdoiwT0VcYOmY0aZK2kTsfEd
 1/Z8bv8/wlFTKVA35xgsmvRnCr8rYFh5jQJaqyG4AJ55zt8vic8skXkDRk3fQl+xfLKERcunJD
 H0JJriUQIamY1GfXzX9wf1/UDDOF2FXIAAAA=
To: Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 Shrikanth Hegde <sshegde@linux.ibm.com>, Paul Walmsley <pjw@kernel.org>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, 
 Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
 Marco Elver <elver@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
 Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-arm-kernel@lists.infradead.org, Kees Cook <kees@kernel.org>, 
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org, 
 linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, 
 linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 kasan-dev@googlegroups.com, linux-mm@kvack.org, 
 Qiliang Yuan <odys.yuan@gmail.com>, Peter Collingbourne <peter@pcc.me.uk>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 36C56A0006
X-Stat-Signature: bssuc61qexuz3fciozsthybqq97u6rme
X-HE-Tag: 1792375102-70957
X-HE-Meta: U2FsdGVkX19CLKMNiLGu2eSlQr8Xrjp2AX9lR9oOjEpxp57BhS/MVkb/hOlk5LWxcmQQurMTjC/Z5fuJq/79HLFsp+Fget4XUbvKoXV1C9vzyLF7UNNBtC9sQKP0JlBznGhcTyN4PGxTnpiAjkvil2kUlxqThAOEb5TLNJXsCgPqG5D4DRW/xNVi6uiBJRaiIVPbPaIv1Y4toDgUQ/+MwNJr5Qi7Xx3c2QcDffw4qY22if72lBXemPkARMSQyqjngQknVfev1aA4KmjK2A5sdvhOrQu2zoj1LMb/owtBbU4O9n6gN+LZOxCUrT/vWiruGuXiTYtmX8PZ5K53QYXbutzvwg/9qQJ1iXPDAS5UM0sTkPEjq6q/Q1ngPCS8G8ECp7ERx7Diekr17v8xXAPICi7VvuOUUQAaM4XQqFiQXv9vNiMnWCGkz4x71029FLpm2umDhqjVhhaJ21GMMtcDFjtmqaZxV1DGFLfy35agDKzop5DYvk+TYVFKFGZC6ay0Ki1N9NRQVAWSpEuToz9yi8Jl2TLSdGbIdwsa9HhQnXjvJluHF55MNq49xz7ZII2HfTXgXa66UqAIHnPnqpqNvhmQWOfEwfuOUJSleT56F/mWlYzwWucWGLkEDJWv1X/IaxGKlmBCOLUxPHC2WPGvqO20+pU9t0o0s9/A2sNUUGFQDWml3FX0JDOZEVRt4UOfML2WSNlUNTV7CDLGyNAWGLzR1wCS6jFsPMM3LUYD89D/Lrsq7NtGipPUHP8UzyjFvjvP1HYmTlZeKSimT5RG3Ypw6dzxLXMcwwdUvncMhUnnAXRHINp9F/VPnllghWidEcRydYEyzH1DtO+iEDG8NOZ8XVAQGHtmt02A9nux5oQW0ZiuaRbUCoZsKNDeJUfdQQZ6kftQ5uAL7lGndSt0RYU9ieiS7qbWU8tNzZqtokXhEpEt/gTUyt55WgyKp+ZmsLRLXman8gP2HJaQoRm
 AzeNSEsI
 FoZihkFsbE4MlcCheg303dCBwsessuDYMactILcWh6WpG7kKJQA/YlK97rWnOR7y2kV1m38Pu8h/bUOzPyihWHqF1zG534+sGWM3GsfZ4e+ZkBv/upI2koC95TbxEUNBxxRjHghg2VivXa377+rJ84wr6+FFwGNpYRZJDAMaQBSzaYgZiVVQluzoBMVt43hzuEc6EMaDbsU3WQtVrB+PXO9YUsUNjv53XIi+J8WqhOTSSqR/LbRmVYJZcCh8UtnOyScGWXMl41uXWKAPE7t9y5lByoznnGs+bt2XvrlCHPcM91SRRmqTpOmRSyu2/dBTy8xB8ZIkvcjBIlNagKxG3i081BFbNo7jIZMqiZztCZZ9kbeOrSa/nOzrJYpKBu2AhuWs8RB51emRMcoafRAZI1xvOaoe5gsCHpMGcAfWh/7eGZk5+NAoLqOvbPmlm6V5Ys1HfkHLgPBpl9q7bIZ8dp/rjnDgshMhK6KkVyM8sndMIVJIBgRgSGuUFRzAD7IzPfAORb1lDDSmKhHinr5+pWjhiv3ulhTTgXQ4Qv5NBqDJqWdjm9rk5f4lDYxyaiZqPUhNG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

load_unaligned_zeropad() is inline assembly, so KASAN and KCSAN never
see the word loads that sized_strscpy(), the dcache name compare, path
name hashing and x86 csum_partial() do through it. While reviewing a
strscpy() KASAN fix, Peter Collingbourne suggested checking the first
byte inside load_unaligned_zeropad() itself, as read_word_at_a_time()
does [1].

Patch 1 adds that check on the six architectures that implement
load_unaligned_zeropad(). Patch 2 adds a KASAN KUnit case for it.

This is independent of the strscpy() fix, which makes sized_strscpy()
copy byte by byte under software KASAN so that every byte it reads is
checked. Either can be applied without the other.

[1] https://lore.kernel.org/r/CAPQLkRhXZwozmfhNd_PEx1ihwdH1_5qthP6PANYJ_m-v9vfQTw@mail.gmail.com

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
---
Qiliang Yuan (2):
      word-at-a-time: check the first byte in load_unaligned_zeropad()
      kasan/test: cover load_unaligned_zeropad()

 arch/arm/include/asm/word-at-a-time.h              |  7 +++++++
 arch/arm64/include/asm/word-at-a-time.h            |  7 +++++++
 arch/powerpc/include/asm/word-at-a-time.h          |  6 ++++++
 arch/riscv/include/asm/word-at-a-time.h            |  6 ++++++
 arch/s390/include/asm/word-at-a-time.h             |  6 ++++++
 arch/x86/include/asm/word-at-a-time.h              |  6 ++++++
 mm/kasan/kasan_test_c.c                            | 24 ++++++++++++++++++++++
 .../powerpc/primitives/linux/kasan-checks.h        |  3 +++
 .../powerpc/primitives/linux/kcsan-checks.h        |  3 +++
 9 files changed, 68 insertions(+)
---
base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
change-id: 20261019-bug-word-at-a-time-zeropad-kasan-af2460466ee6

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


