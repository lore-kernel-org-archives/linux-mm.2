Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CB8EC87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3517B6B009D; Thu, 31 Jul 2025 19:19:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 302486B009F; Thu, 31 Jul 2025 19:19:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA5E6B00A0; Thu, 31 Jul 2025 19:19:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 013146B009D
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:42 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BE20C5D10C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:42 +0000 (UTC)
X-FDA: 83726129004.13.1E29A65
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id CB98340007
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="Imn/XqJn";
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003980; a=rsa-sha256;
	cv=none;
	b=MkhiYR6e3cYXHjXCgpVie8aBJGXMdEzSV1B6by8mkXHMnMhjqBfZZ67E728P55G/mNWMI1
	XusszvreID5KWiVsaSO5IuDT/M2WoyNxbtJvcZuEYIJbHp7nvNaXpdb2DQ4pnUQFsy5FE5
	aBXSGYRdABAZeipCaxurs7p9vD6tS3Y=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="Imn/XqJn";
	spf=pass (imf17.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ez7fajQ4lWgiIPATC51FeBxCIECW6n3uAlkHVBFvak8=;
	b=YQnucvZ33rQ5cdpEWPyBPFUZEqhpYjJIQc/vGfmkb2jQvCeq7z6vMUZdG34ScPuK21FF6g
	ZTm8j/++DzIo+K6Fw1XFbWayCIBZ1BLWi4Vm3TGAVvP7WrZJ3Srv2uoasODJhgI9eEE9fM
	nKsURhoHRsVRpjIWe/7eZN3U65sVWOE=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-76bdc73f363so175945b3a.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003979; x=1754608779; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ez7fajQ4lWgiIPATC51FeBxCIECW6n3uAlkHVBFvak8=;
        b=Imn/XqJnwJSFuZPz/MV/Mt3jSvivmh3uG8FJhEd9fuJaI5KQOz/5FM8dXFbP3F/t/n
         lSaI5HLKvzQJffTmarcHfc1o+A+VLaJuk1kH0KeSE8TWtt0eRlGa8jAzebnK+gk/i0Zh
         jUE1KZAl8tD7sI0HPhgTxMGMeWgJttqPjBaJ69cnI+kt81JHTzcvRNixltBzdlwKGtFh
         aHD+ShgTcbZdxXhrb50GRnu6h83s2VRTxGg0mZ2DIiuCQuguPneJ3hU0mHh6GO7lIINO
         kiEDwFc666EzWcuEm9PPzJDt4KbMmxKr5PMmweYbS8Fqccksdd/kbBVBiGQaNmJszGpf
         6GpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003979; x=1754608779;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ez7fajQ4lWgiIPATC51FeBxCIECW6n3uAlkHVBFvak8=;
        b=IcqcluPe+KHLr23TQGofgJhPv6qL6Bq1/fPt7PUyoC0XbZIAYBHv66gMHlJIfseX2+
         2dHWqt8KQ4UGVq8p2Hb8SflWYD+fIscBW4I47mfrLrMSWCrA6KtRwVPsHAfbafOshWmr
         Cf6zTsCbcfdLuIrtBDBIDY9IDgmiE7THnRPILcrBIHE0ktKwrohu7IoGJpRwiYbuMTo6
         CDNvJ/vNpQcPGRxOXfHJxtYiWo15y03TFGlYaQD8csrNHs89ZPsqq3+WVahiFHoASk49
         Fecih6lkW10Nb8DUohCLCltJTRTvBZUbduZ6528HcJWzUcAteOTsX1qgPECWJyWudaJu
         jkNQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQXQ2fS+hCWf5KWRoq9yb+p5X9jyMCgGp5X954Wsjw8Be+xiWiOleC4s54Yi5m/oCx0Pm8NI+x+Q==@kvack.org
X-Gm-Message-State: AOJu0YwE/xisDTG7VGr2nEA3k/dEHiUxt6Ey1HBst74PPBn2Kz54f1Ft
	mviqkFyp3yyn65ysch24MFvMPfm/EC5ACxnA4N7pXS51q18O+SOpSY2o54C0zOZOiI4=
X-Gm-Gg: ASbGncuZggK0S61r9Wvcfx7oRQs6vYw4e3EUVYH1B5OChK2sNuziq13k/27MXQMKGqX
	jz5lklkQVlhpr2G8+ab9SYsw3mwXE6XSwbMcBl/8C5thvsKaKYojslnlQsWGgXj1V9E6+sOnwIA
	IEFfDWkQeZNHmtOmV3mz9Fd1KxW92VXjx4SvIu3P0En7maFE5VEuhT/tQ6UxkTl8RVYMtb703rS
	pah2kSaKD4rdUbT+GkwWMqxhQDDuyefQoQv8CvCy4udRmokApGcvjvDYC9KOBdf5Uvk8Noe8owo
	iMg3xcVzxVSlQTn46fK35bShJDjliRp8QT55GojuATWYqh2O0SvKQLDKEgWoqbvGeCbQfiie6VY
	Jgn35vX4rPSP1UBqI6pgVY685rh1rMLqx
X-Google-Smtp-Source: AGHT+IF2xo1ZfVMwTGmqa0w+CJyQOLIX1YGoKzAdOOg0c/bt0OowoMzz4A7p4t8/qA7S3n5MiZF/3Q==
X-Received: by 2002:a17:90b:2b46:b0:31e:d643:6cb9 with SMTP id 98e67ed59e1d1-31f5dd7f18dmr11303515a91.1.1754003979507;
        Thu, 31 Jul 2025 16:19:39 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:39 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:17 -0700
Subject: [PATCH v19 07/27] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-7-09b468d7beab@rivosinc.com>
References: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
In-Reply-To: <20250731-v5_user_cfi_series-v19-0-09b468d7beab@rivosinc.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
 x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@suse.cz>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Conor Dooley <conor@kernel.org>, Rob Herring <robh@kernel.org>, 
 Krzysztof Kozlowski <krzk+dt@kernel.org>, Arnd Bergmann <arnd@arndb.de>, 
 Christian Brauner <brauner@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>, 
 Eric Biederman <ebiederm@xmission.com>, Kees Cook <kees@kernel.org>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, 
 Jann Horn <jannh@google.com>, Conor Dooley <conor+dt@kernel.org>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
 devicetree@vger.kernel.org, linux-arch@vger.kernel.org, 
 linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 alistair.francis@wdc.com, richard.henderson@linaro.org, jim.shu@sifive.com, 
 andybnac@gmail.com, kito.cheng@sifive.com, charlie@rivosinc.com, 
 atishp@rivosinc.com, evan@rivosinc.com, cleger@rivosinc.com, 
 alexghiti@rivosinc.com, samitolvanen@google.com, broonie@kernel.org, 
 rick.p.edgecombe@intel.com, rust-for-linux@vger.kernel.org, 
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CB98340007
X-Stat-Signature: d784ba3ebhptr1s84s4anh59sufku47w
X-HE-Tag: 1754003980-575701
X-HE-Meta: U2FsdGVkX1/keVVrKzYwyMHRJSs+g5fIuzt0sTS9Jhwv0WIw3NlkWcM97yuSm3/sSSU3/krDNlrZRqqGxJ8yrbK6RbWuJ4vOWET84uMEdd2sMmDGrv7Zc3wMPBWGUzcJRrjIMpiwYNIXAfe7qAdZcXlpwbZtLLZNhJR6nr9mlTO/e6v3XqCxdvv0r+bsqKwbkoY6V1o982l1m3//BXO6H5RWxUp5B+M6w/z76HlyP6rSPBQyv2en/CdKmPXdFGRCCnpV7mEVjTHtAAaTNbtDhlzUzpMl0gT0lMCHo8sVOJEleA+6fFLWGZUysoiHRHHZR1DqUVbkP01EFHiJn0QaX6lZHhkjM6f05S/o4DFYiwf7+AmKkS4CXjyVWsWjhfo+2n7wEZaOYAIbyAgEfLe0jFB9O6Xg5fCt547337LT7E+5vXcR9smJIc3Fw14ughsFoH+SV5evvX+kNMrFH82uZG1aXzvx76uOgwC6bH8XY0GeJHxJThihQg8oaqbRTrKfdULRqj9/0k9iT2QDbV4H5tfCKaK5JXK8fOYk3qLoBWVko2Q8IlH1EOmiYWdF+26C4Xh4ouZSPjvqGxG+Nezv4RC1qIZGmzJnMEwcb2j+Su4ZlMnrzKMXOMsnyCScwXPX2OSUTIDcqKx8GgVgbDPLFeZx/n0y5eoMGnT60ttMiUXTAEETj9e89TYrVkXZM1GRew0Kk88Ffm6gwegRjPPzpyolf7+FSJlE+xiAbKRMsSdvQrMuaD0xVILeaXfDchdoQdRk9NQysllNfOtnJiEWCPnTEbXXSU3Qsv5ETRE0JpoS6I+B4tHhcqxmIqTUQilfdRUHTQiV5nL52dmFMNiEwNE7jVBDkALLzVi0IDLZ7Awn7jpxoEX/84E7MveaRRf+UVPxNjPA4aTQcd1VPAPM63Y6FCnV38znjH0H6G0Yc9H6igDIZ/00uSjF70htfYVOApk7pboQJTf9+4b0LPG
 SnjYgJLC
 As3TbXi1+squ/RZaeyzamks3KZJ8fBnAptCHeYeqMIRqyRZ+jUQVsdNUQBlYIMZvyZruUMGB3CZ6eHL8mIsQDgktKunvXfk3syFKnVu5zovE9N3AHAIDmcBX+3D89reBmSrGxie55gCa4vdNlPfFjipx4Ta1FmJm/wyhnH2m3gnBCIdQ+v0iv70pzOV8OSOVmd6IQKas7BNFgJa50V8ZmpTHKzW6rM7rwjF2kEH8b7O73V3SQvf05eLu46+fUhxqt1XS3LLWK+TcF9SigEVcq1DTUhiqAZVYnUWBR9DH+QKE27DrdaWPIhGDi36syUvbWIkfCEivH2PxFwfI0B1YDBTkh9v0aGoAEoVJTa+888rQcVtN8KNaZ2aA/IzyOwI4CEbzPWX8KmI38fFrm8Zch8s6KV82A/Zpvzg1RPpXPuRZ7aszNZ7PAimeBmez4IxHtDjwuO8JEyUaVgPlMKWeEmDWxLFLLAmXKAmqfAsTzmYM5xZadx3VX5Ppv8nWjs+lslBRiHmJYBd4RT/4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch implements creating shadow stack pte (on riscv). Creating
shadow stack PTE on riscv means that clearing RWX and then setting W=1.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index c0d7e67c67ff..792cb9792e8f 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -431,6 +431,11 @@ static inline pte_t pte_mkwrite_novma(pte_t pte)
 	return __pte(pte_val(pte) | _PAGE_WRITE);
 }
 
+static inline pte_t pte_mkwrite_shstk(pte_t pte)
+{
+	return __pte((pte_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 /* static inline pte_t pte_mkexec(pte_t pte) */
 
 static inline pte_t pte_mkdirty(pte_t pte)
@@ -776,6 +781,11 @@ static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
 	return pte_pmd(pte_mkwrite_novma(pmd_pte(pmd)));
 }
 
+static inline pmd_t pmd_mkwrite_shstk(pmd_t pte)
+{
+	return __pmd((pmd_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 static inline pmd_t pmd_wrprotect(pmd_t pmd)
 {
 	return pte_pmd(pte_wrprotect(pmd_pte(pmd)));

-- 
2.43.0


