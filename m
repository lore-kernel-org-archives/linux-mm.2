Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B8B8D339AE
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844206B002B; Fri,  5 Dec 2025 13:37:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CDC76B002C; Fri,  5 Dec 2025 13:37:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E3A76B002D; Fri,  5 Dec 2025 13:37:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5A46D6B002B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 20FF91402E4
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:28 +0000 (UTC)
X-FDA: 84186275376.12.DD19EE7
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 18D604000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:25 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HmcOflAN;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7cVA4V+tsTGYh8faQvOG85ZxC8pPRVoW62aZwUk0L0=;
	b=hX9oRGDcdJV/bMypiv6T9Vj/7tcUI2ie1atkjLdXav4KVUGRqXBpm59+MY/Bo0hmjTmm7Z
	3xBcXYBr9wpxEb3jVU9lhFi9i8nKO/B0GMwZk/zKdgD1FxW9hlPowB1g9phlKTilbAJgMd
	59UQf25GI2ifftkxuRtLoWuhLbotN7E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959846; a=rsa-sha256;
	cv=none;
	b=8Dxgi24QlkVIYSHIJwDQax7gsSVfl4xXGrU/NPqlxkWLIjLfqKi/fLYu7toM5aiKKZs/je
	2+5KK+SoLO4CoLVX6o8RU2vQK5YncXyYweesUOI2Ztje8dEPkeJ3DvKhYctQE7mjwFWoT4
	PqOqB/BcceOE7GIbR9TfFYlOcUvgOPo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=HmcOflAN;
	spf=pass (imf07.hostedemail.com: domain of debug@rivosinc.com designates 74.125.82.171 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-2a45877bd5eso4568106eec.0
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959845; x=1765564645; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7cVA4V+tsTGYh8faQvOG85ZxC8pPRVoW62aZwUk0L0=;
        b=HmcOflANJB0Yuq7byFddrDYBw0KF3dHZSzjDq2Gt8Hj24CYLcbf5GBZH9vraFaKbvO
         oTaqjRtOtxtF8SXjYNKUPukyifl3FEYEKATCkM8MnFF2L9PSVD+IDqLB3UG7uf+6x8Zl
         CjIJuVGN00sf0eCe9xpuvaByZdf05Xg2wAe0Shy+oRyiCVE9UBkHdIQPysF3CrCFrSaJ
         8+BoBPtYIevDC60rUpoTLQHmqv9n+Tuac6p6J8sUfJEdXbLkW9vDTF3V6y1Lv9auSj9G
         kGuGAy/4rQFepkvarMlLNTeE9hz029HVEejRWq3lAl5pN1xeO10nXXlXajt+NiULo1Se
         DcEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959845; x=1765564645;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y7cVA4V+tsTGYh8faQvOG85ZxC8pPRVoW62aZwUk0L0=;
        b=Od6EJ5e/lJv7UZsNNNw/m9vWzSZ+Ec3foiZVGwZeU4AaoM4pS14ce9UxmClEkocZBK
         F3PY6XrJOYkFudoDquUdhd/m5yFqgU1KKJPsJmiHyUFwwsOUJtVn/Q4wvxo5sHFV3POM
         IKr+drlg5behhbdjK/8gQcwSrnRdGVCPpoqtt6d+1II5JZAxQNsU0ix9REf054WBt/lR
         FX7UjiZ/X2qrJqvzdJL4h0BmjryO+2LDSBY93m/hl10Kv0agm/SD9WdZ5G/1SMmBa9vi
         mjX0qyC6tAx95VQzsg0a8Fr1+jpv1kIrMuf3E26+a6bhwZoViYCM0C/3T9ftBy6tvMuD
         DxbQ==
X-Forwarded-Encrypted: i=1; AJvYcCUiTNUJmIyCDaPm8sYX8rCZlVx8KfzxZLg5LafzI6GVpGND0yriIn47pl0BKYjqNtTTvWsYaIGv8Q==@kvack.org
X-Gm-Message-State: AOJu0Yy2HHikQya2DG/2kzzdtAgPcf62EYDCUHAhLMkZ+M8i57udk1de
	AMYuo7YjrXje2/WTB1f5hN1gOqoqZ8ffb+WXkWcseOuDST3MA/DY5kOX6QIg6Exsi+s=
X-Gm-Gg: ASbGnctuKa2oI7jI1zbD5DOAUzFyunujx++gKNGrhSNnXvVz9e5108/kTVGKv3zmZfM
	GkjUYNWuS5h2yctigPUiL1Y1oRkUI5jfHeZHTtxYgCYW4id3o9q6IUuB9611f9OUZdVRWVAfSK/
	NfxHgLq4jxxbdxkzviSeE0Mi8MqcpgJLuaLwGnL25kibmSry2OToTDVFwwCdm8erf5L9OlXYW/u
	n/CwPQ/7tt4Hv1Be0NtaCDrnsS63PE2VcVwRQKNUyrTFHVRrRboC/t3se+PyvGKBPAxISr7Jqr/
	/eSzUwA6LmwtsNY3Pt0ovb9FU0zRqry9wEDAoMDbUq42w5TiRT6uLuwf2gnFCu8kQfjIMOk0nuP
	oN5VtUkCUW/KGQiZE0Aia1pnDzKCQSn4sda1HLD41SG9tm7N0D4MyTXCKYydyldAF8PmiPJ1z7I
	urbCFGKpscaT1pgZ4hibRj
X-Google-Smtp-Source: AGHT+IHpgKa7H8AahzL7MXJDXATVAt8op9HJLZz6q1O1yZv7iAcmKoVC4X9a7AcjVimql64o0x0uoQ==
X-Received: by 2002:a05:7301:1e82:b0:2a4:5c33:ff7e with SMTP id 5a478bee46e88-2aba34e598cmr5659789eec.19.1764959844877;
        Fri, 05 Dec 2025 10:37:24 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:24 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:04 -0800
Subject: [PATCH v25 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-18-8a3570c3e145@rivosinc.com>
References: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
In-Reply-To: <20251205-v5_user_cfi_series-v25-0-8a3570c3e145@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=1182;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=5pCsCIMJf4iBOvf300q6+KPihTaIQ8ZBfY4WmoGUnLE=;
 b=YUOAVPCuxUM5Gbaa6opv1masEPHIuQa83DUGc+CGXyeJ5A4kfQSjMwPJRS+2ZDYG/CTYlt+hh
 XoV55OqqjBBArKRtE/ICcgJfxzIDFQra1KnJGP2v9aOA7JvRD/LcfRN
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 18D604000B
X-Stat-Signature: jbz8f1pqnd1nznhou6ygfhxpnb3abhuj
X-Rspam-User: 
X-HE-Tag: 1764959845-810024
X-HE-Meta: U2FsdGVkX1/qYZyu8/pCZPqcWnea0wWiSjJqMnO/kj6svvrN2Jx6vEH4su0sNM5LZv4GUTNJLnbygJviw6xc7/WOIyW2/r1bbQQPzHArCRa7Ns7ahiM7bDCCBh5mOe5kdWiYGmipCznC3cBdJ0ZV643CtPbq0sxg9s/U362j2zAG/G9m7y3jcJQcuiegBvGghs3iPLBslkWFUL3PLAH9AdyBif9bYYCdJil5Ub6g7bsXnESa/ej7u7VVZsV0VTPcf6kMfw2sxK8ZYIHgnE4LebqJ4l62wBzhGilcFeb+xKmdtcX8JAH4PFru2t0dilBHyuHoN/ve7TaQo8w48E70W/jeO2Q35w5I2FL6B+gnoFyJw88U/lDsGFRSDrdA3VQ7ruJy6C4Cu1xWoax77qGLpHSmfIkri7qxoQDwk5ZKiwr1qATUPrRuNffWacMMC0TiVOPmth/6s98uCrhyFnGbJCjbMldEG06colN2LoDBmiWNgyEa6ApkW6t9l5yI5+6cM3UFKACJtevHowij4685+/+3r/qbMMR6ODFUVe1X/2xchZsc3qRDTVq9c4C8iwgIhdCpAEXpVMedh2b1eXcDZKN99YRjd8GwTnso2Vr6DQCLsaJo3JCVx8nkRomfAb+j9ZjH3XMoxQEbbhfoumwqbWlVKH6Ya9eRvh//IV4ho+NLd7/dBUldXQ2XXo+Gcpf/fJeF6rv4uRgkFe4HkqI3NHPbJpbG4Y/k1oznX7mE40YNgEOkcEr56ta8S4UWdEXJ34vZ0OXAFcXTGqYk5HTfQuPrcc8cAp9h9tObKJddWptIF5S/tJWfhOFtlnGGDUXgthA06xba9N517UBdZsnLe7k4QoWSfZZmH9WVlsG+Voag0JmFKfV1nugUVUlPNo+sUz7J/BDjQYfRcr2Ioz6ygLy3dnpV7YlSn6hpNY5j+AhqtwuWa9XNrVFhPa+xo0BgqXdlhWc2uowF67nj3gP
 rTNucOSh
 wVtOuIvSablKFwwCSP268eOuTt993isVlS/4rwgL01RW12UZv/X70ZRtIn6cJ5M27JpEXV+aTNX0DVj7w1A1VX1v7iYXJU9i5jXg5xYsuvtxA13+/iSS48WSXcAXfsB1tuVd8Yl7ZUEjdZkKcVIlVk85bLu5YKaRU2X9fcdnPylcETGSSZARtfUiSG9pEZxqShLwdnYWr4jb1zgwYJKAASOE6cQpoI7y7bgviSjB8V0Onjx91JA0RCGTHG4gEEcX7SwMLvzfCsZjhPd6DbxsxUqGNihLajeDraRHDfC/z+alcAMk4VGXXjXzcwQy4PhvEO13WMlBqj2/hdHFHZ5+vm5x0+5Jf1psmEDWhksp78kW+2lxTdIEom7+nrZHjCAEEuRSkpmue4nYlj00JOZ9fi/f5KoVFPpcF3hbWwQVofKV322iy6fFUF5w/CrgKOgcJCGiP1qeENsEPKAYAnAdD01CEA8SQSuh6JXuW17oO5drRqNv1qtMk/NKbHmpCSU8oSJD9IwoOdeMjxf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Updating __show_regs to print captured shadow stack pointer as well.
On tasks where shadow stack is disabled, it'll simply print 0.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/kernel/process.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 49f527e3acfd..aacb23978f93 100644
--- a/arch/riscv/kernel/process.c
+++ b/arch/riscv/kernel/process.c
@@ -93,8 +93,8 @@ void __show_regs(struct pt_regs *regs)
 		regs->s8, regs->s9, regs->s10);
 	pr_cont(" s11: " REG_FMT " t3 : " REG_FMT " t4 : " REG_FMT "\n",
 		regs->s11, regs->t3, regs->t4);
-	pr_cont(" t5 : " REG_FMT " t6 : " REG_FMT "\n",
-		regs->t5, regs->t6);
+	pr_cont(" t5 : " REG_FMT " t6 : " REG_FMT " ssp : " REG_FMT "\n",
+		regs->t5, regs->t6, get_active_shstk(current));
 
 	pr_cont("status: " REG_FMT " badaddr: " REG_FMT " cause: " REG_FMT "\n",
 		regs->status, regs->badaddr, regs->cause);

-- 
2.45.0


