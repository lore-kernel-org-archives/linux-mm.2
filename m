Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41E21D2A520
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 960496B00BF; Thu,  4 Dec 2025 15:04:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E9DE6B00C1; Thu,  4 Dec 2025 15:04:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B15B6B00C3; Thu,  4 Dec 2025 15:04:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 690EF6B00BF
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1F173B4CC2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:04 +0000 (UTC)
X-FDA: 84182864808.20.97C08BA
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf12.hostedemail.com (Postfix) with ESMTP id 178C540010
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YgjyekcO;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZzDCu7IaTRxcq9mEPcCPJw7K7qmz1vUabcyA8OBdm1w=;
	b=Mzu+nDjjjQITXiFLCcmLIsO6doWAZYAeO4ko1K2ofP/LxS1EnIDGQrrddLNlbCPhf/Lcn2
	OH0QsjEchK461ZfoVRuYEBsX+9iUc1wvaaMLh/yiJChaGutbvc5AS0/SHpITNQ1DSe2GEj
	U7Sv/HMuJdeQ+CCihvzTwyS4NKRnHg4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YgjyekcO;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878642; a=rsa-sha256;
	cv=none;
	b=REzcbdIMIMusuV/uHYbVHB1nHB/2+Rmf6F7uBhFd8HarKO8g9bheYYU+jfW15vCsfbHS1q
	NQCXrKolcgXTmYCAaWdOIMNc7k8k4o4DjyuzkYCc7k6m5KWBLdVL2XPV+Adnpz3dfL3agW
	Uo/oAgPugBkcTUJP1C0wbLXtokq5KO4=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-7b9215e55e6so974020b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878641; x=1765483441; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZzDCu7IaTRxcq9mEPcCPJw7K7qmz1vUabcyA8OBdm1w=;
        b=YgjyekcOOHiuJSxkChI45Ebq7GOPpPDzS1SeRO7kviuHx/BEfr3Bf1f5tdb8L72G0H
         MHnrpf475KrRe9BecgBvCTFn1sDnIZT1OpXxTuxemi+Kn9gZv6g14fEk8sJeOtgeRaA0
         NlH9EdGUjuajV8Pwa7Lbns4iRM1ZSleSdwYCAPTPG/bppWJNyKvFgCnvDYn4IRcuHYt+
         RNZqnLd0XzkJ3LDnbxikZuM5eG9QwrDD5Qyh/Ct2+59opq3uNYb26QB5/QOHe8yY6yD7
         S8+a5xcPiUvWiqze+NZiHyObPNb93V4Q+QooGpAKmcms2pJtE7TK3F6iYfTTY/3A1zC6
         SxlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878641; x=1765483441;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=ZzDCu7IaTRxcq9mEPcCPJw7K7qmz1vUabcyA8OBdm1w=;
        b=wpaNeECRyO7dTjhbvtW6wqYd2lRKpEyz17CsAVo2wJo3b+Q8WqAvq9yKDK55YUQIXB
         EbzbXZ1ebzyalgMAIyeY1UJOwtpn+gw4UzAWLnBjytx+h8Hz3ZA6SgZpZ0M0eaUN02nS
         Dp4Y569zShK7OFeHxy7SziyNCEaZJrI6XUW+TCeUUsowjtMsv1X2Gu+YB235peAoIdFi
         WztqrgWWo2iKwiVvyJ7DM02y15gYumP18T5+eecES5jEmqXisOL9HbsAlAbOIHCYb+QO
         I2wglUwdeVWBNkVrTpOIYlQmo3Y8M0Cao3ZgwmlkFlIj6F0Gqe3tlYjvX+MBEixgL6Qe
         3jxA==
X-Forwarded-Encrypted: i=1; AJvYcCXSh7PTcRCcOS+KLnY37wRMshKH2Mq7J9f08Dbl4/jrz0mCwkhpuX8O540ucUKB4vRt4DCccKynRA==@kvack.org
X-Gm-Message-State: AOJu0YwFGpVbxowFD1kjL36s+XKfVIPXB71Hm2zgrHXRITDMT+d+2CR5
	6EroythDRvCEnLxZKwO6eJPj9b2RB1Fo9VH24mhRClIY7UyKK/RnBDRdPUImh1fcZL0=
X-Gm-Gg: ASbGnctOUuFOZokdqNfiwiBdi6MXxVhnooPP/oslZtyqo65CVankqNh/TxkYU495dkN
	mqnRJybIAXVQrOeTNmSCAi8hkBbTcyHWsnPCSTE2hkGe2aiRzNTDpiniyNNCq95sQMquswhkNm4
	fzpSMY2CCFtXwBMVBEUwp3TjKVlyJEMgHompo4jqCBzBgOllp4usL4iEqC0RQbCIkSs1OcsZfOz
	z0WWswANDiMEcW18a9+PgZakooe1x57Ow/z0tM19Kh7rZ6qvWmncVeIa/cXWDsXsYxj1G+5YIPO
	MfmNr/dMtfw7e3gWkcT/4BhWiPMRhUFlmcmkdNpgHLCVIgkkox/Mbt+jhrGe+227MXX3tBHT/3f
	HPBy61fkAOgufF6tAeUtTDcUmMEzoaLcdNAht7R5yzol6wjayd0KCr3NQu5EnX8YVA7KGMzKRzG
	f8N+qR9HXdSteoFwjch2AI
X-Google-Smtp-Source: AGHT+IFS3/LyaA7r+iO4CE8PdPOdVvp7/Ont/dyD58FlxgFclLSqiPQIEE7yhvikN0vHy7ae7J+lfQ==
X-Received: by 2002:a05:7022:925:b0:119:e56b:98ac with SMTP id a92af1059eb24-11df646417cmr2797504c88.19.1764878640495;
        Thu, 04 Dec 2025 12:04:00 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:03:59 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:03:50 -0800
Subject: [PATCH v24 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-1-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, David Hildenbrand <david@redhat.com>, 
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878635; l=941;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=BfqrkDAmEYT+r742gKB+SlFctae91M/veuPAGWY6Q04=;
 b=rLyoDrCEHiggT9VGWh+AV59ny1tITwEdtsn6xQ7T68CawzBV32k8ccRrfNpmgg6pBQ3jSqH1t
 By7DryeDPH3CNPKMe3XDDQ4h9GMvBJsJm+XUidd42pvbJxj7L7UGjUE
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspam-User: 
X-Rspamd-Queue-Id: 178C540010
X-Rspamd-Server: rspam11
X-Stat-Signature: 9s8s9w61roudqw7z8bt1izpy1jaoo9z3
X-HE-Tag: 1764878641-702116
X-HE-Meta: U2FsdGVkX19gvwPGF7bNZbs6k7RVQljV85uKyeyskLpxsO/Bn92kubGqFBsPkOA4TpXErFcTOxWSZ5ocDB8lhzfNjEiVjrj88ga7821r3ScuRYONf8SRjdOQlNzTUCcFa9T5A9yCcdWmeeCW5Fy73mpVxM/Q0aUEGjEXSqxMsx+lvxpaOTdA2jyPYg/OgGPr6SxHYAsxdenP0z/eq8KwcErjii7hY/WP3TgXcNGIiiLMENTwRI+yItprpdUIqTp88f2Ighm7sNswDiEV4zzKPx12qhlu4bycg1Oo1GOGH+63awR6IQtTtXz3BNupeYpZjEbZeD+SObLBWZCoWvrn5V67jRBB9T1IkMoc++UlpTjAZQqJ5SXGQj3bzXKal1Cyo7Ivk3gkU82vlQT9voBuAtvMIaewwo/0tUs8R/QTzzRt4KcTN8vTo7yxJ8cWYijOhkBmyMIFuNdl3gOB5rTYIQRteXFU+kAlRysjHCt71iB364XKF6YuFLWOccAGQiyhPbq1r0ZlREnUn8k805EaxrOO0LvTAoPmDaYq5h9fQH9rvnIKjAzSIU1v39ge46E2jeagUKMkuOal1OLeJ220E3rU/YXhoDyyOVxIGw7oExyOF2qcCYzaG49TmhbczlnrlgUI09+0Jkd5+lnluS0i47ydGWCV5BZS+vCxKtL66Qew6Uu9pZSTwVOvIdv2T5QET5nA4o1CIl1Y6tSuknU5NPNGoaDiwpUtXUXGzBc9SOogT5yoKT9McRKH/5/GG1YhkdCLUNwJVj2mHI7A6bpIVRERgZCgMJEiMq84aAV2D4rQdCMZp3jvedCZF6R10LT820b3PtLUjg/aETvlVPY8brR5jCokwX8DfIjsW/D8EpAobFIE3fioEscVUSf8ZZKQ5l/DXEKWOP3T/f9803TyNlijP8oeWG/7QJ8hFIhBnJF2qIQrSsrkKT/+sc4ufARHcip7+sjskKkJq0iiRa1
 lGUDiJO6
 85wagJPab3OQnb6fAjRrqDMjeQgo3yL+r+4ijUKULXiB8HAhM/a26vi7XXrJlS970DwANJQHXleZ4OblL9zIKoSRly+YdNQMdqwaY6ijs4Zz6Uu8X8sVlipfc8QrZHu6ItM2PRQQxNqr+PbRJsv3EziJ+AxtaWaPedB0F7b9wU3bd5Frgl9HT1y2gnJwKttJHibCr9bzS5Bx1gwwFLDeDzWrX5+ABYBtRRiWyPaDe+ZhdQ4Mv9UkL9DmQscsLU6ztdujqcQHbzUSDpdH9tTHd2GDuRxsna7+nTLAe5yo1FXGiwQbyr9Pb97bzvwF0occduej0yU7NmXVB0iczm9TAy/J1vtFYRDBgRBaBsHJpdc0YS9ZulzhDVkO6g/RuMuQBKbeE4iknvrBosSu93sjFLmUFPkgDasBgt5rSc1vTOlUDXwRP5d01TQz8c4M0TWtPonKhcpc346T67KuvnBx8b7OIQ+2aoaUVWIXLwHHNsTUMhN51TWCqW8wZOqZ14zEChuPWvNPnWeDAAv/SZ9daodCajqlvPun8DwFbXhKv6QPkMDppS1MX3hM4EqGkyg3jajlHtDMkYldLiVQuFzfcEXeJwdmk15ZkscO0OK78plmj+RIzYJv9VoelTq8fKlIvK2kM
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

VM_HIGH_ARCH_5 is used for riscv

Reviewed-by: Zong Li <zong.li@sifive.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Acked-by: David Hildenbrand <david@redhat.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 include/linux/mm.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index d16b33bacc32..2032d3f195f1 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -380,6 +380,13 @@ extern unsigned int kobjsize(const void *objp);
 # define VM_SHADOW_STACK	VM_HIGH_ARCH_6
 #endif
 
+#if defined(CONFIG_RISCV_USER_CFI)
+/*
+ * Following x86 and picking up the same bitpos.
+ */
+# define VM_SHADOW_STACK	VM_HIGH_ARCH_5
+#endif
+
 #ifndef VM_SHADOW_STACK
 # define VM_SHADOW_STACK	VM_NONE
 #endif

-- 
2.45.0


