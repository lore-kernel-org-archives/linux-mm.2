Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B3EAD339B6
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 18:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB0BE6B026C; Fri,  5 Dec 2025 13:37:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3A516B026E; Fri,  5 Dec 2025 13:37:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1B0D6B026C; Fri,  5 Dec 2025 13:37:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88FA56B026C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 13:37:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 50E591A021C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:32 +0000 (UTC)
X-FDA: 84186275544.23.3BA78DE
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3DE002000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 18:37:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bP+Vg+eT;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764959850; a=rsa-sha256;
	cv=none;
	b=6DXMUT55AqHmCQhUa6/06onxoLo/iMCUqin4kJvqrEIwiwSEB3dD8lEjDIeGPRXvnWNWf/
	rEdjBZIGZoVfN7zMKa+6Tw1H5CDjWpqP/Go7KG1fG5eUFxPRXydY2Jfz6xaPz0Nlqw3MsX
	XhZkjuvXTkakUC9LSpcCBZCfA4tH1AY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=bP+Vg+eT;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf13.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764959850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=caVRo7M49OcsqhffOXnqYtJLXHun4v2kvB6IB4MWH/w=;
	b=ofIGTTw31fCE/Z8WZiyCvX82J+kab2v/v7IZXkadWD5xAoWWae3AHP9tIfCBBz0g3976j+
	J3i1xpWuo60OS0txZOuOOrPEPcfBjeuLmEcWZeZsxf7/dvO2qxkUbKTW+lH8TlSFUzIlLV
	U8m5VtF+hRNuw034CX9Oc24jkZjsAVk=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bd610f4425fso1419104a12.3
        for <linux-mm@kvack.org>; Fri, 05 Dec 2025 10:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764959849; x=1765564649; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=caVRo7M49OcsqhffOXnqYtJLXHun4v2kvB6IB4MWH/w=;
        b=bP+Vg+eTDwNOodpNFO8gcemZeryemZoXjoTHY4hIGiAZfWuu8P0pMKi+pVHi3hoRkr
         v2MJHDdRq0WGHZTSywaR5YYoTFC5TP5Atk9a0ZnKYFYARsrhtWOofqVxr1/oAUpHFxm2
         NNh/mxJuc086uA2tlSBoYvg+JiOONTBia6JtgiSZs25Gr7sw19+4++rLIjmmEgbCHhDt
         iwCjKh+bhvpiHchv4tVInVd466ia2sZFNIgJTY3c9F7ZslicFQGGena682ccKe2LB4qV
         XHYBtk82BQ1ebldZfk9OJCXSjTvwE8Eb02IKD/xEwjR5qyLCdai52amHi5uscd8CS48H
         d2Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764959849; x=1765564649;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=caVRo7M49OcsqhffOXnqYtJLXHun4v2kvB6IB4MWH/w=;
        b=uZzGgAQgJOvoHIUmnHaMmwW2xe0tc/JSFpT1/cAMo75crNMsNNP0C0O+YhmOfLONq4
         dG1c8LuYvNm0Jb6IwAg05wchO/R10pw4wqqgC11lL7zYoUv1VD3Nyz9ml7sjm3RF9kGw
         3d3Bog/gAjYjdUb4F5Bx0UJSaNqn0rDYqaZgp8xIbAmmuGOvvV3SMbqyrptVftfi0mrl
         LSD6spazRtsacUEq1v/fu5dntdQ8Q3jyoo+aAlVtg2zeaI6m0BC/mlg8BCMa24uawbu1
         HFYkGAd89P6ZACo7hpDWS5FwM/rfHjszzqBrAILDyDuTDi42vE8S2cgg7TT2NGvtP8Kh
         irKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXw+s48pC3/BYqWDGChryH9T2Nw0fk2+GHtwhzhmqtis+sFqUHR+A3PFIzEDU2lSQYIUCduLqpmQ==@kvack.org
X-Gm-Message-State: AOJu0Yz5udjhHOs72+MWpRBGR72K9F+BVq0rM8uxEZkGXnsUAw5+bUR9
	kj2go7e6j20jt3BwLTwATYSy+G4wK6o9FM4EUuZ+oWyVv+TQSAaPNebgKcz7PBK0h0c=
X-Gm-Gg: ASbGncu0nqDpUNOTH6b+KFmuB18fFwGZdJjR/ZOl8GVKvs5ktte/k46TYB9dgtUgvoO
	paGH27FfcbQfE5h3XC6W/1MNIzMNqQ/aqSh7E85bHqtO8ih3QZo8RqvEDfMqQDL+N+ANzv9WDV3
	weLXVo0UkpE9PKhi2I+61DSRDj40x6NhsZWZpVrw1KZNWTsDR+eT1GqOTcQBj27M/0iRnOB/wOw
	6B9Zuqd1BO3D2FPZgp5s3x5RLM4CPRKdgv0yml5FYGx35JeyYzJs9NNXcn9KZoECfEnWf/Hyxeb
	UtHJjl85ybsFP+xQwun4+Chh7E5mldaVQ8hdN3moIR6X7/KAXWOn1deL9cSOGhXZLg6lMWc8shA
	dUuFFFXtAg2MY2l4/7khijV3AYH4aKuROkPfUUSeaEQF0a80YGAjSth5NAbkeW5ms8anLOvEG3Z
	zFiV2n0K+SirGJ003EKOaE
X-Google-Smtp-Source: AGHT+IE2xGqf6PsGRkrxaqECp1R5gZSEA6uoyMXhatYShxnn+tFhMQT5orx1xHyQl0N4uRXeo3OQqg==
X-Received: by 2002:a05:7301:f07:b0:2a4:3592:c60c with SMTP id 5a478bee46e88-2abc71e17e9mr78847eec.29.1764959848864;
        Fri, 05 Dec 2025 10:37:28 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2aba8395d99sm23933342eec.1.2025.12.05.10.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Dec 2025 10:37:28 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Fri, 05 Dec 2025 10:37:06 -0800
Subject: [PATCH v25 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251205-v5_user_cfi_series-v25-20-8a3570c3e145@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764959808; l=1494;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=o+mupBbwLM9S2HS2KmSc2gYbDSK/gb3i74YBTExGXIE=;
 b=h5kVDkaUUUs99aJk0qS23WgDcswkl3+9vDfiJ5qfqx4Kce4+ENPu1q1DoLCHOQG7/oTl1GxgM
 WtrUtrWksYgCk00mzDTDyGq09yoemSOOYeLn27NuQe2huLJS2GIT4Gi
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: y7ysqpg9ek1gwgitoa7mzxmua6yxedhy
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DE002000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1764959850-262809
X-HE-Meta: U2FsdGVkX18jZ2HigKoq1vrYNRMov/cflrjjTlMC555e74ZEYm6RLTIFhhcqafsJT83VP1fVpNQAL+qgSxATOIOSFL2NAU4s+HttXtYxLREf96HlLFNEOvS/ovTMgFdKi/yHySVE60zFVpadocCSIxe6b5Nlwva0zr6WgeBdq5w6YnwBS3LNsGcVuh+T5gQWaJsC25ZIe6Wwv4Cvj0SKG8l2YA6UZbILd3eqz5Sc69Pg0Gb/Azmmpw9JrxUwY+vk/U7tb8SvD0qA7SszHCX5bNV67Bpjx3xv8qiAEzH6+UfsWtJBxJJ1W71g3hW54iWagsPjrVWAxqmHdgjL3UvFgVvW8oLmwm2XLwuwFbNDjkiDrG1Plbsz/SINUHJpZtKCBuF6e8RRprY5vyINiGuimBWUDP8YNWh4wlXOBG4wKELb+QcROf3vLoDui/4z+88rHp5Wj48aJGfbIiBl9tXEK2853nhgf6uIXCOfihqATNukI8M8LRr9Kr9kC5Lqrb7bBWxXrsxMVg73nZGSQTWzX2CislahNp4FIKD1nhmn/RgC7zYxSaOeNoXqd0adLLoAslbLP67F/eEoNTZhYgRuV3CYsv2iiI6NrRXre3uWNWxuanZnhYUTg1ZaHEoTSeSMvZabe/WE6bXneftFp9CYWpJ6WIyfAfZkaRpGBy/T2HI3nNe7U1Fq1TqNkoOcRcTu/W8wkSI5yDbGcZtVFFwZ+juwIIg7hcptbPrPds75KB23sq4/1GAJ3XhB3ZhtRxwkH5+lNECZyzVka+xr7Kqd8bzv1xlSQWS7GxUR304DivSjJH9hYMvvM/dvBTQvCDcwFRm7+FJ8LOzIVARo3JyhwibgCoztSCnJ+LG+nnL1g2oCpAURIvWnET5Y+OAlRny7Ny3OqD1SlQfoYKTn9D4rc5RcrWccL6grurQtBaZ6USwF75BVxKx6m/j9Hjx51qWnhHKJd/9r9bmIFpwcxDL
 t5hRsrXU
 Gb4pvixHXSL46q+slvbX/ZRofg/CXO/hZUFuOFOaMqnGsKAOueBwkxaKHjQ/Ijw08Fw6tYfFiZEpWyevttz3sajaKkDdIuu/+xQLn5MICLCCIkZOSkj4/b3AyaG5hZIIwPuf9TXHtj1w1uqj88zGrYn3wzrUStvRMZYqMNGbA1v1LOmfzWa20k1b5QHu6C8P1f2p/uwZ6Mkn0TkmzUinY+T9rdsrz8uR1E9npGB9hn2NLdJZr8tNVdpkNI6bwtC0HXOkKO0QYyFxAg6l53RMAmY9Uhp2c0xEjexgdOORNk3MYGOhzd3k19YeaWQpOhQn9Wh3AbhTLnfZzX6D5yuVCeEErgSjAYM9KpCgSawQq4OdpzOJwg6+usqT4YrmIk8ZqiZaE6sZT328Iie8v+4TfYtZGNg6hBdlRtzkhZlvA/x4bK08uFw6qkGEhp9YcFtRoNfAVMvWtcYv3saRct3jsSCVKW62QEewc0PNICHS50AYe+g8e240h6rUUzJ64NIfvXQDLTYPFMShA5adU9ob0Z24vAQRlGDQKh9Ym
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


