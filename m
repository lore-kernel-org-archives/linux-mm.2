Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B63D5C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E0536B00B6; Thu, 31 Jul 2025 19:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0921E6B00B7; Thu, 31 Jul 2025 19:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E25E16B00B8; Thu, 31 Jul 2025 19:20:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF34B6B00B6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:22 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9C4511DCED6
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:22 +0000 (UTC)
X-FDA: 83726130684.02.985004F
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2FFF120005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=it4vlU+l;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004020; a=rsa-sha256;
	cv=none;
	b=xOEhHLPzZW7TJbzfUNsi+G01AsCJx1dLmEULrCtNlLygIqWGs8TNKJ6ePGYICVLP+qNsLg
	UZ/brTm6Xbc+0+IQCQF2qngF6m4wGKAzv1zFq+XOO4Sf4JPoCbU4BjQDWTPy8aRiE/XWFh
	elFyg3HiUu0NJ7ub+/jXl9vpFKQUlsE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=it4vlU+l;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97idN3yevHtenW1UOqMmzI1HJzUNQ+IzroMxOnaMZVo=;
	b=oMrn4l0j0Vxd1BGDL66GJ0zNHo+R5dtspGpEs9WINjkFvG96sz2hVJv2NkyGThMV4IrPFM
	AzZMYXrGvDhe/Ol7J4ZTUFnHSWvfi9XwPyi8wiW4UHBjpdBJbA7a9JA4uyyI9EHbOkpg4e
	yNrcSK30rCz4sJR3s7UfQrDGC3y9978=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-748e378ba4fso2067919b3a.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004019; x=1754608819; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=97idN3yevHtenW1UOqMmzI1HJzUNQ+IzroMxOnaMZVo=;
        b=it4vlU+lpp+hSustqxaafUCSkOl0uaciX8g3icgmZ/d+LQg0LrYAw850/bqaUulT8y
         Wo4OcIxDQa39PNcLT9oL4nUkfPNWlTpR0zp1P9RHtGtOj4BvxAkQtpWomvy8aJAvbr2u
         QLzmj3yEi8eZIEwYE7RNaZ8qWwaiCfLYCT0VSsP6I3rbYUfKRBPYitEFLJNqqpOg11+z
         YfMf/25sbB5JWVBdGmKOJyg8o8uARWiaGKncT1qdOCv6uxcl1eRq2p5l314KBXKJPwu7
         tUa0hOolvf88eSC9woLYtPuNyS9wR3UZ+JSqMYHhZHHkdYTgkUggm7PBFKqhK3lYAm4m
         vSDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004019; x=1754608819;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=97idN3yevHtenW1UOqMmzI1HJzUNQ+IzroMxOnaMZVo=;
        b=OW6mwrySTgylF4kIfXL8XRfLxve79amuXcf95/YI5oMsmKICmFKaWe8oRdmFhOf2oV
         nRQRkPawn6s7C0WoBvC5PW9bz5SHHNXC2Wt6toE1t3nMYJBTgpDKxEvRttshBc4Qzjm3
         fl8N5FIIFN114t+j0pfrLltM7jNasxCdh/k9I1rHVR7pcKOU8KvwihVwsn1dUWAjV5lw
         QSPHzSRc4gV2YwMIq/ZR7PyIXA3QorshimxB9BMMmfcOAegL+gGQTEzoYyGQijL/f7CS
         nIibqJNtofqiEgPnkKzud1qYtuNcoPZ+j7ZGfYSiuD+pgHjmgjsq5+HV3y1/9Twj+9Lp
         z6tQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnsubJavtEmBUdiThL714AaVDq9e6rsRduLJ2DdSgQ76dtsrNAyYA6xX9HhR7LYuRYNOMkAfj3OQ==@kvack.org
X-Gm-Message-State: AOJu0YwVRVGAj4/YmNAI0IcJA23xF+gLKkhukcoIBXpkqamnlmqqlndb
	RjFMFNkFO9d6/zuPLtol4m4H4AqaX0omgXJu/YB+MFNXFRYrb1jCCJIqEB8JiGq2Xs4=
X-Gm-Gg: ASbGnctJ987i9CxG1xtA4yAolbz2mLZ5UIo7TcRa4H/j80/9jtQIzCHWnEf7OudrKnc
	lUfM4ZgRoKPJFR81bNtcWSGXs0DakPN2Z695l07X4bKUpjUtv5Kx58r88Y/LhwTYT2txgY9RxaT
	Ry8ZNZQQ6SZjriAchD2agG5wMTwK+r2rcv7RlckaRjqk1R5+w0Xkvy03jiojVQZS1K5q8xQ4Den
	fr2JbOlwZfInvlt4hVVTaa2UEAKaShKXZFsjZzaesMnY/5cuwnJxeL0ANKmatNsFoJBgPjWg/W3
	9eRkRURcTRPSdEoXkpuhT2SZmTqYkA1BYEiKuj44JxLHF3zerS5e49kNh11Nj1W+nPuT10+myjv
	xLDxDxKQ17g50HQeVhBD1iorO9Da83PHb
X-Google-Smtp-Source: AGHT+IEUoMa+BXtql9s2cZFjETmhAnatI7rWJGQzevop4U/kycX0Vn34mEDUpI8kYIcAJsoiygP9Nw==
X-Received: by 2002:a05:6a21:b98:b0:23d:e370:ccfd with SMTP id adf61e73a8af0-23de370d395mr2848807637.41.1754004019603;
        Thu, 31 Jul 2025 16:20:19 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:19 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:30 -0700
Subject: [PATCH v19 20/27] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-20-09b468d7beab@rivosinc.com>
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
X-Stat-Signature: cphnnrtm75ngi5iw1kygsgm6581ezhoy
X-Rspam-User: 
X-Rspamd-Queue-Id: B2FFF120005
X-Rspamd-Server: rspam02
X-HE-Tag: 1754004020-898771
X-HE-Meta: U2FsdGVkX18cDzSUY3UPOHLMkfZbnfpHsDxN5sMSHq9zvaDB5hv56eQ3XXi2DDhGZqXYKxJntIEELKn60k3krasJh8HxC0MQo9Gwaf7UL07d5CNnnVjz4kO4fWkpyUgTYJrX8XJaTRolsHvEUetBn6E5UvICnHMTl+Z15HAqcxI5h5sTo2/lqqEP8BCD3ofMRj6UK/Sud06YK/wMwFRYYbFRzSBHQCq2XQFum5XnD/psRQBDh1QhwXu9VEnOg02UeNbDcT+pG6jyN30poN4VCQSdAAlhyLWUcY19DaxZWyLw4EyRUx0U9jAVzam146bgoqwbK+PACERf9L5blL14SFl6zCkZXw2sQHpYFf4Ul6sUlZ0xEKExxTHKtUseAPbulcrSuibuN1MAisEUtc0o51XodPiXK/C4agAMpGpVaAxy8mI3TBFcsn/ttNN4nBhYeVgNXW7ZpvH0If06KQ36P4BNdawRHpGjhzb67C9PWU6yXq7ECpIusY2K4dBZO0Ci7YdN2Y7spnEKfmPCo+WO5+BE2E2/PKraQ9A7aiLZAfmWO1OI6wiWjiTOTjG0y+oN5+WaOiN/4AwA44OsaSPeokWXwOJxxj9fnR+sT1qLP9KnP3dRW3qckMtlseN3F9FEUvWg2MFwXvQN9nMbVZVLsW6+iwN7e2aYYGFPOJPqcltyXEBuLdYxx0kVnMXBZlVCahBfKJnFwRYFTOurRodXDSQ7DFaq/pQKOcuDKTtDHuwrz9VNEMbdNnRLGuCeM6UPv8vQ4QFS8NUJNivE4/lfkrQyq6FQ+SoTzbD+HbvX1NefHQBOw3bzmyxhnoWrzGTIVrYkYvWiGwsCAtoPyde5kxPjJww1ZoHtdKlflVoTV9LOZaSxIos371+lQCVnGDrPfqc9fNhH/xjgVaetnaQ1N//2MCnzpusy251NPUop9En6pWaHFj3KC71O/1Kzo0H6ceUygG+yclCuoSqk17h
 3oxyBdrW
 LN37Rnw41k6CSMPbVGhDVAcgYfz+XnhHETqqE6bx3T0xsP2yE/0rTtQ83Er7vGWalxEhLPiBrvrozGQ12ZmhD1pumtGnbD6aHZlaaka7puJwnDFKxIaaO31oe9yifqdNLLC+qkmV4xZ4WBpwa6hHInKhoF/s+Ne27DBrLw5ll0td3cdlVIca7ymQ3CattNXD/ryueZWGIXBJDrf7cWpMAE47OP8K0vRE4dWAdM8PjO45OcZRIKU0fd4L5rX0o7SRwn/+3+AGjkjmYkbKIFXhf4z462OoRzvrv6kNaqSzeXNWvuDKHgSuWL1K1PSlM7zwjYpzlsr6x5LUl+d+d3WM+rz7+aV7aAUqewfWzL9o/+yPZAPu+xqkNh3OLa8gfWnoFbrWvlLCGi/ISlJkGFkvLwOggsp765FSWjmOIroJ06NnwTOI7Mv7l4Nj7j+p9OUAx8CW/ZMKjKyCNUgaBUM9udvpx2u+zdsk7gYBpv47GhU8Z86aEcQNBFxPBX1T32/GR1412sJJaGUDg7YcDaO9KXjzBAzPeLE+Rx+AkyfLUIjWpkX8PjJizi8WEvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding enumeration of zicfilp and zicfiss extensions in hwprobe syscall.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/hwprobe.h | 2 ++
 arch/riscv/kernel/sys_hwprobe.c       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index aaf6ad970499..45ac92452e13 100644
--- a/arch/riscv/include/uapi/asm/hwprobe.h
+++ b/arch/riscv/include/uapi/asm/hwprobe.h
@@ -82,6 +82,8 @@ struct riscv_hwprobe {
 #define		RISCV_HWPROBE_EXT_ZAAMO		(1ULL << 56)
 #define		RISCV_HWPROBE_EXT_ZALRSC	(1ULL << 57)
 #define		RISCV_HWPROBE_EXT_ZABHA		(1ULL << 58)
+#define		RISCV_HWPROBE_EXT_ZICFILP	(1ULL << 59)
+#define		RISCV_HWPROBE_EXT_ZICFISS	(1ULL << 60)
 #define RISCV_HWPROBE_KEY_CPUPERF_0	5
 #define		RISCV_HWPROBE_MISALIGNED_UNKNOWN	(0 << 0)
 #define		RISCV_HWPROBE_MISALIGNED_EMULATED	(1 << 0)
diff --git a/arch/riscv/kernel/sys_hwprobe.c b/arch/riscv/kernel/sys_hwprobe.c
index 0b170e18a2be..59fbc9c2d126 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -113,6 +113,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZCMOP);
 		EXT_KEY(ZICBOM);
 		EXT_KEY(ZICBOZ);
+		EXT_KEY(ZICFILP);
+		EXT_KEY(ZICFISS);
 		EXT_KEY(ZICNTR);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTNTL);

-- 
2.43.0


