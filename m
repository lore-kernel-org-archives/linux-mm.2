Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E85EFD2A523
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3F36B00D8; Thu,  4 Dec 2025 15:04:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 394D66B00D9; Thu,  4 Dec 2025 15:04:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CA16B00DA; Thu,  4 Dec 2025 15:04:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 04FC26B00D8
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:42 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEF9513A9DF
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:41 +0000 (UTC)
X-FDA: 84182866362.29.15FAF97
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf01.hostedemail.com (Postfix) with ESMTP id C4D9840020
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:39 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Ivj460hZ;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caVRo7M49OcsqhffOXnqYtJLXHun4v2kvB6IB4MWH/w=;
	b=y5DgUdZSrKmHCxmAlWtMrt5iykmtEEToPqf4Yw0qLA4itwEQc6UpeuX6HAQLv4rknk1fX2
	YgkGn0oPDuSENrkTSG6cyt2WpN2roGhmipjXv4nN+hVD4q2SeqzJLfZ4mVQ0yionrFGw8L
	sPp37/jKOr8qA4uCDtUEZ1lbjdcJgPI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Ivj460hZ;
	spf=pass (imf01.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878679; a=rsa-sha256;
	cv=none;
	b=NtjbdEg7S9pO+rJemduyXiKz2dLR8LVN4TLkxuMNqJ/5XrkoZTPrqqcys1LQbiSkMhq8AA
	ViF7H1exSsX9Q6ZhpK2NWOOLixxxsS2cDAoFz68VjUct1umMjXH6Wa6ky5uNXDYlYh72rz
	3HbMKaZ5BEQjsJykxzWkQm0Yw/48b7s=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-bea8b4ba79bso1089080a12.0
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878679; x=1765483479; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caVRo7M49OcsqhffOXnqYtJLXHun4v2kvB6IB4MWH/w=;
        b=Ivj460hZ8NAfH5+bNiz5xl9rOlTyNDf8D3v4nT/r2W5wKJNGLdHds6cgp55+FKVAGg
         Kq1sUzVS4s2C7VLgTOJ5a97Cn9wwG4M7NrRL5o2QP5MC9pEYjQBJDY9YRcfLzBAz0eA6
         GOxdw/8woX4z4qHa0F5KfwfS192SJT78dh3JWc5oVVNODBgrnb/RAaUBpbbz3RMt3iJX
         S7Nky7Za0Y7uRVc+th48nv1bVSmumngiSMiDEhTgRV1kcoz3BCNURIQLCX9DDUB1m9fu
         r0VB/K6WgRL+Y/Qf+rVftiaIYRCqr+7DQLgtDZoI0A1wjFQduanv+zK6OHFhfSsndCKb
         JmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878679; x=1765483479;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=caVRo7M49OcsqhffOXnqYtJLXHun4v2kvB6IB4MWH/w=;
        b=lPWNM2JW0LcTP0kDOsQ922Rk1F1AQaonzwMo92m8ukXqa8q+/7bfeYuFTn+mpkYPMd
         OqeQDEyjT+r4ENNYOlOzwHRG9A8Imun/yKWFJSZYLKWYpFjnSzSS3xF9RiDucdnfiOZh
         91bFOjvjedIf1jsLfEWp57krd0PKkdDSXJsGvrxXU4n2TexWTFIj//gN88xzqN+KTZJA
         krWvOgjwfnhxcQlWCOkhaHFBsRJ1Zzo9hVK4gkFGswzqn9I1zNIrsnK45LYkQXfFEwyh
         1lXBw/7wNCVGloCkXXUiqwNdzzVWIhNrCxZdXEoVsEfIfNSU3SDoObe+t590ZJxBq0N5
         musw==
X-Forwarded-Encrypted: i=1; AJvYcCX7t/0af/6QFFGbuTmJLKrpD/OpAuQ5T+eTV7IP7NgYrPMUpS8r8WLZ9G+kMMNTsWF6KmATjGjiNg==@kvack.org
X-Gm-Message-State: AOJu0YyCtBF5d7ZMO3nKIQ1jG8yKicdbXeELsKkwEASYwKwK/F3JM69w
	EeRlksiAPZCCfadMhusZnNA20XpYkIpspcrNQpoWdK85VGEORw43p7Gf6OnWoPlOBiQ=
X-Gm-Gg: ASbGncuXVgrw842H2iiGzpUrvDb3mDeppw0wXbcwzY9Do2obSBlwdNrbpf/Gg6DnNlH
	LKNcvWQrGfCBdcLLy8la2tarIEI48oetFrV2yTrtWxdXvQBETEKnCvtUgbzA0zKnmAMNAwWvldr
	Ue2mDNg6GPbu8GeXZzox0f2AUijQo6ZrDjiZ9SNVGNCYIsbcnvRtSJcppcfpAa5+fAoVMXotoJd
	7zTtjSkl9vKCLGbScFnq/+VO4orUx+NOd0O4ya3nn+zI39/UvVuRP21LJV9QGm/WS0ce7XZraQt
	ogH4SAKagr6XhM9B/Fst0kVCPuU49A3tbx2pLwn7YxJet0Yb6cSGgn45MQt88c8pyTmEJN0O1k/
	usFTCT/+YAsu9soQ1hKobmlU0SvFrIDm3C/ncceqEFu+nFlNBmJ1Mkqw3lZxNLfTtw7UW0veHkL
	yWncHb3ClK4k+JYZMJOIYK
X-Google-Smtp-Source: AGHT+IH8WfNOBR0WYTIAjC7h4KWRD4arxZjj56t6ot/oIQda4VPJ+vPnGe9pfxDTosFlvlQPrVkwhQ==
X-Received: by 2002:a05:7300:2d06:b0:2a4:4e38:9a39 with SMTP id 5a478bee46e88-2ab92e786eemr5009491eec.34.1764878678491;
        Thu, 04 Dec 2025 12:04:38 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:37 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:09 -0800
Subject: [PATCH v24 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-20-ada7a3ba14dc@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=1494;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=o+mupBbwLM9S2HS2KmSc2gYbDSK/gb3i74YBTExGXIE=;
 b=2TL36FQBTxYHJECnsPKiEOH953BZcSJpF1TPScxWirFZpsiwieknY9HPgz7ctQuE/tNNnQFHX
 qay7b5jPJ7wCN1QiFJshFM+JS1yjoWqf4sTvAxW/wwYUz2revUqCcLB
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: jufdh3kgyqkbphfwa63rkscafj8xno7c
X-Rspam-User: 
X-Rspamd-Queue-Id: C4D9840020
X-Rspamd-Server: rspam09
X-HE-Tag: 1764878679-919218
X-HE-Meta: U2FsdGVkX19nzNnvoxtsJ7MZjVfOvce5cOgUpd8Q/mtfKhVwLJn9aAHViayXoSWFUhxlHB6BUcButC/fyp7fRH7fMBotDkPtOYPSG895ALl4M0/RzXl4sB+7nQmgJcyVqtcujb2CX8QPVHB2yExaNC52fcc7a2ay7W0wS/D3NN7jjxNwX3WMRnGcZ8OK/r+u8WpldAYHnYXfsPhyAucPJllCZfaa7nbd7+gDnerYYp/w7IKaZEwAK5Rl6ehDUjoL2wA7/l7UAcSOy1QRpi6yzzUNWVxBnMXwjBDT3wqE20woA2wljz8sWyrn4y8b7ChsXtVnPKg640Efn4xASVFjk7hf0WF2b/EHJuijH9muHUHooNpviqrforetvI70YThZ/GWI5ODltQflky4bIzT+13XGMgJGzOACEHVTDDTDn4x0LS83+vXOyQYAaPNVhPXG3gI3BzSGK0GXUdonVRFIAdjGOnsGd3DJmfF7F9lRCN7fQOtFR6QP+8Joz3Ou+o2jlvo5dbna89UnhEVRtlLZyp+tcs7NjSHeRo4u1gBTCWsBCGUWfIlRnriqh4Vv9wB0x5hs7dfb9D3n84RVgSAks/t91jDbSs8GV5KVFvd+3/RhICZwA/6WYUZxC0dZMFMFqzDcRS41+ZHYEkZMIZ7/qoj8Yh4aOAGPezZZSVXCBvMbnrUrJ5Mwjb8nypJsT1SxFOwhZjqrcFjvpsLTPOYw75lJcnyER/lTSIJTL/8WedeUh2AC6rOeAwbsNaINgBGSMlLOIMEHbLTy3sNb9TeVM9TvubnxVLnS35fF3vF0MQcpyPEOvt/7D4G8NTadSKbhRmzNwrNT31zN8pISw8b4qUAZn0D/96SC0aLyyAgA/WJXEj+mr+nQjRpChhhKY93EVWhZhuVj/e7qAqGxhJX9dsC0sZWGJHwrysQ0IFMPmrJVtYxFWIT3WCgQqwUD40lfpdqBNgX/JaywGc+hh4R
 U6Y4IVKm
 ev5Jefh2DHBbVJQoGFCBIyoQCLn51b8wUEfN6HFIU6zClvuntgQV7ymcKzW84vDM5HzheCMbZbjjUv0qwPIhUQH80fhqmvKp4Q5kxb1AgYlGPnoL8chEVTTIXLqKa96XEpPVVloF7fIDnhbaVLNQ5l3M3+yrQV3Eoje1NJkc9RdEcAnFaj537qxJGzO9xevJGWMAiQvcdI+cA2eN4g3AYhpQwFFJ+INHhKNzHdvP/EmOKi0Fn6h7eWsW+2Pi/cPXZgYvhkN1EE+Eeihkk8R4RAHA5gZObv1I8syJUmpiEfv/tYwty67vut6k/slZQrg26h44Q/WEs7dJDAl20EZMBa1TKt384mrohdIv0EgX4q4+CvsMV4otDePcigMzAwtNVcv4MTdIn3jt6iK+JpvvRWCok2eW6UsOLHnTVpvwwKDdZTUf/GVFnkozPydHBqlRm5szyaous41hB6ohQVJTWGoWtTH6Wnm72h0OoW6rd3ZnWAkeAyZkzW4tmAyRB7gtY7OY0mLqQBgWOcwADaGXf653575erPNa1VCB6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding enumeration of zicfilp and zicfiss extensions in hwprobe syscall.

Reviewed-by: Zong Li <zong.li@sifive.com>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/uapi/asm/hwprobe.h | 2 ++
 arch/riscv/kernel/sys_hwprobe.c       | 2 ++
 2 files changed, 4 insertions(+)

diff --git a/arch/riscv/include/uapi/asm/hwprobe.h b/arch/riscv/include/uapi/asm/hwprobe.h
index 5d30a4fae37a..0efc9c7d1199 100644
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
index 000f4451a9d8..d13d9d0d1669 100644
--- a/arch/riscv/kernel/sys_hwprobe.c
+++ b/arch/riscv/kernel/sys_hwprobe.c
@@ -114,6 +114,8 @@ static void hwprobe_isa_ext0(struct riscv_hwprobe *pair,
 		EXT_KEY(ZCMOP);
 		EXT_KEY(ZICBOM);
 		EXT_KEY(ZICBOZ);
+		EXT_KEY(ZICFILP);
+		EXT_KEY(ZICFISS);
 		EXT_KEY(ZICNTR);
 		EXT_KEY(ZICOND);
 		EXT_KEY(ZIHINTNTL);

-- 
2.45.0


