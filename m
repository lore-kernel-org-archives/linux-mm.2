Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DC60CCD19A
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 158C78E0077; Wed, 15 Oct 2025 14:14:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E50A8E006F; Wed, 15 Oct 2025 14:14:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0378E0077; Wed, 15 Oct 2025 14:14:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D2E2C8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:32 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9BBF485D18
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:32 +0000 (UTC)
X-FDA: 84001148784.25.17D870E
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id CF91414000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YrXcesMt;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tlTCabZFxINt6Lm9QbVDHZ4MzlWsICTGzKM8x7gyE4c=;
	b=XRtfXs0cTl9ecX3ljgdtSljbuN/Kbw5+u1AjIn4+qEQVXOWs+Twg27VenBEA8qV5jgq39p
	bCQbJCDdtpcsei/vT5zfa2dC9S3C4naeHwqa/Z4v8hl18MYnkCpvQLINBxR216utx4ORgJ
	5ZtvbIYiKfHMvxQhGCwRlzU6M2TnI9I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552070; a=rsa-sha256;
	cv=none;
	b=mV02zjarxbxNsH1ICpovPIpbgNEC8P9SCk/Xex9ASxTHIBleee9AXh9Xgs+RIvIm8QbPvN
	6WcNOyKH2XUKBnE7F4S9lQ0fVb884EZ/cwjY1NBFLiklcUokukZk/O7x6K9jZg7AyxH0x4
	Yem9nOmZOJ/LonMZEyMXoTEGXMGD4WQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YrXcesMt;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf23.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=debug@rivosinc.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-267facf9b58so39703445ad.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552069; x=1761156869; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tlTCabZFxINt6Lm9QbVDHZ4MzlWsICTGzKM8x7gyE4c=;
        b=YrXcesMt7ORb0RBut1SQ9vWJbM9rND7cB6GxCiDu7s9U2V/HpmMwb75YhgoXOqvpqI
         mRupGChOjwbXE1VH0e3PuWteOD7qpeskhtWIrREBziSzn6Bp9ni1M6CpCHDg15DCK6SU
         MujTK89fntTBpA81/5pQSLrA5qN89ud2yaHHgs47P8zaeAhHgUk3meaKCHc5cM/TSIzs
         JTeSwpmPJlApxiDDF61EF1Kqx09PyIALOFcinYtwG6g7fhgQeexWK2Ub1CJG7geS9orl
         ovkckl5W4qCExU+h8789kRjoB8iifoY/UgL6bSpkds7jF85A729wJ60H5wp9OLxZp6vM
         2JKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552069; x=1761156869;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tlTCabZFxINt6Lm9QbVDHZ4MzlWsICTGzKM8x7gyE4c=;
        b=KqR5PnfbDO1JIxfw8QS8TSzANvgzkQDfpmCHwd8iu8D851Y2Bko0aD+lai5Sxr/7Xh
         ilhS3Ce1JO4PlCKerZ3ogX0chs2nvcOKsEoxOvU60K8jLiql75Fs4k+J9Zd40VpOMQEZ
         243jI2XeBJHdpG45JJMDci5oTMZ+NTce6jULrTiC8/mKUBiedodk+WL5ENZKdRUJTF8U
         RTuY1DlB16c0JXB+MKPVAGcGe7GO5Lb90cp69BnTCSwdZK5McyY4/CvZpJkpqAD1SriR
         SvSRCTELzLkCEcAVM7HADYh2a8tB+l3hC8cPtax8cfQFDms9iuXV4iv+/P4FohB9+Z6v
         AXqw==
X-Forwarded-Encrypted: i=1; AJvYcCW1QiAIXIGLu5mUKpJjoqVUaxsGpBdhqzKfWhNun6Tkd2UNkRhsI2E4Z3eqjCgcPcP7DAzHbuCmzw==@kvack.org
X-Gm-Message-State: AOJu0YyTgPBClp0p6HAUX5PnIL1a+rEaOxBE6z+bB/lReHRCa7Nkr8G7
	MhNbuP0N5lhMDdycUJtxcXQh4bUqqs4IwIX0bTdakUn2qpCOxO/u40tVN0zvxTt2gbYcH0I+L8l
	swO93
X-Gm-Gg: ASbGncsP5OcpnBy7jjLVYcCMUV3Wz9DSgcpA45VElfMiBSdsWcDZdiCzmqr3syqi6ZR
	xkB+WadJOndJHFWZobWHm+Cby/RuBU41Z/xcTGer1KnsIPhGFopcnyWVw+g93Ad22J/BACbFi+x
	U1SM5kh0ioxp1S5OWsxIBJAsK+wy5oaETt6+WHH4KQ8vujK1c0NUsRWVIIyw4R4kieAhx9QNVs5
	euO25Fl+DBYVfmdYZUqERcnrzclOdt/n8xReAGf8GJVIMaI9Hft0HUdaAfMg3M2Gwijk36+P5yb
	VuAKuNSsjLseMdn+Nl3EA44RBHU4ExwZfW7D55weTIrnBYwFmS1i7wOydlOZBXugmq2OadszZhg
	A1Bpx6w6suzNnCDMc0DZUK5SUJA59UEv9vBB1rvHecft9MaTheBo=
X-Google-Smtp-Source: AGHT+IHEXT5xfzaQ9E7GA47DV8y7VdpAtjfIT1LAxVPzv4De3A/Ut9fEGvcfd0ReXWhAXtZ/RL7Blw==
X-Received: by 2002:a17:903:2acb:b0:268:1034:ac8b with SMTP id d9443c01a7336-2902739ad00mr410312175ad.26.1760552069224;
        Wed, 15 Oct 2025 11:14:29 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:28 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:52 -0700
Subject: [PATCH v21 20/28] riscv/hwprobe: zicfilp / zicfiss enumeration in
 hwprobe
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-20-6a07856e90e7@rivosinc.com>
References: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
In-Reply-To: <20251015-v5_user_cfi_series-v21-0-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam01
X-Stat-Signature: tt774w3q7nqjaj8r43k67dnutuwdj6e7
X-Rspam-User: 
X-Rspamd-Queue-Id: CF91414000B
X-HE-Tag: 1760552070-653926
X-HE-Meta: U2FsdGVkX1/1lwMRDt6HP5c4Le4qKExibf3A3F3P1mwWkEajBCQ8+EPQ0Kt1PFt0j8qqSp/MaEpl3FzhFAaQS1UYaDQp+RKYG3nmcYeGrJR1+Eei9G58cO28BvphoDcmARXg0lENXXrc7u1K6n5//yBoC2HJDQrVF1g7YBjMjJ+tWFr8LYIcOtvOyO85J3jlSgvyX571AV4q9s6PVzjn8lu3QI5kLX0Fc+dAeao1Q6TlXIJRUD5pVxtxBNbYbamJC440Dm0XVSQhZ2bPVkoxiu1t54U9m5nTUo83Q3daS+Ao4irEbqRZaihWdSAYvvmzTpc2Y3gEAvr/WzDrkgUT/mXh5X95h52+cIzUumqHxRqNdvVfCiJoGBMRIOQH4oyVC5EKF4jPSs7A7Qtzz5ZRi+cnZFcaMPACFzu3oPfbIfuou+0O5jUrPfjnOemFWS7G9/19jRU/QIImVGjQ2Ro92HpzLhYbRfyvPbAnGdGXCu4mbl84cRARX/II1wDxeUMkhfIrX2ZPmzLGrTtp0kQ0+GNY/a5nbWsCr0WvlCBE384kgi4wyN8Abyp789rzAEGsAleZvMcAHaArehHMAG/dgKsSN3KHirCe9cCa3qG5NWKZrz2ay/F7yAiwypzKsnTVrD7GT2mGGCmaGO//Upvv+swiWrCrWaX4CweDSTdXjIj3tAW3XbFYp6xwAdxwxQDzU9DL/eg5pb00n2Qqj/fhCRK8FFdq4iepgYNG7+GMq6O9PPvn79gEPlob0uaipV8lSNAnqPnhhYS1nGNsCFBGj9rGZPhsMfYxY+0wr9NjWMSROgUVQ5CBvUYP0gHNyHH26LxJKpcfhRPaK+9OKks8LlxjHPtUCXWZfHC/B/XpiQgSEKIWXWNCSxjQRmyxi6qsTbz3VcDzgHHW+j+CllHrHyRD02YJ+fqsgssyGE/RW5M+rV+N/gUjX/9DwxZA1iwJ3A9+NFMVxGEM2tHGu6q
 DnHiqTo6
 PmsaiOFVfBf8oS2R5V562gXPhccgKw1sr8I7CF41UN3xz+uN0UeLsUHCx/CoBMo8uRbGp
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
2.43.0


