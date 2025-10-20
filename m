Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8E7CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 20:22:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3118E000A; Mon, 20 Oct 2025 16:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5585C8E0002; Mon, 20 Oct 2025 16:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A5708E000A; Mon, 20 Oct 2025 16:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2CE7D8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 16:22:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B0BC758355
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:42 +0000 (UTC)
X-FDA: 84019615764.20.C21E59F
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf24.hostedemail.com (Postfix) with ESMTP id BD0E4180007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:22:40 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cfxhD1v+;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760991760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJyf5Mfx2dyzbSqpH6VID/K8048gVV4D981NLyY4E6w=;
	b=Btjhy1nke7+g/kAx7HaUmVPbH+XwaQSMQJsNH4uKtxJbB9gf6pErKreguYjMTli0aUgz+A
	TQ4iROwRpuoeThNBB9W/NDCUD58r6ZeIkpdGKin5hL+XGy5pxUYujRkNmHuWzq5qqj4Xnb
	2Bqp1//Wru4g9lfgtR3CJ4bp8oQ2zCc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cfxhD1v+;
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760991760; a=rsa-sha256;
	cv=none;
	b=GU0hPVU3F59T7I5DtsuWQKFxS0wgVjrHFrVyeUCkRDndSkjB5ayaGPlEuaivu02qGTscQv
	FC1PQW307QU25fxEw7FU3sFZ/3dqGiRx5y3GO4miHEFcj3/vXx1WLgP+GXGx7SCMzKUKvd
	3yabKNT3St2VvyMTGURigMaMc1zJkiE=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so63942685ad.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760991759; x=1761596559; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NJyf5Mfx2dyzbSqpH6VID/K8048gVV4D981NLyY4E6w=;
        b=cfxhD1v+bRTmsuCyUOrWL/yHLHGnwcrrsbXuQSVOMFoaI2VnDYUgmYq66mJe8t42Rd
         d95XMEZd9IyBdB9cGYvRJhqMKC4ltGAbHME+2+/BN/gGG0/BhUB09TH8dYZvXOIo8tP1
         shgOW9+gmBb0au810U0H6P3sJFgGxPoi/f6PtlPfvw84v75yatT2rMM99druIiozAe6m
         5zHB1V5e0HvW6/w7vW2k1RKe8KShCUxWNvS9p56MTy2tsft9gB6UK/2LdS6fONv79zz+
         i5gVSImPCIHqO+tw4HFtUWS3SwLFjLCs59UApmf1Z28FApjxzcbf+Vy1WaZUz1kumndx
         7+4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760991759; x=1761596559;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NJyf5Mfx2dyzbSqpH6VID/K8048gVV4D981NLyY4E6w=;
        b=LqGLZar8+glOOFf3srQoKXjiiCsxvkxMcslsCnxF4RAsy9+02hhjTXppukBef9u851
         V8KLhGimBA+N/rLFrNoDquK3tQ5ohpHkjPyTZMURCQn0mErNKet8qy4/rxoc+ISys7KV
         bBZNsrMAf6Xf6Xa13Yj5R1BXpq95oTOcAR2NsAFjabsPIoqKUPhdPxOllH0tC2BgiIR8
         Oi+jo58kolb2XuD2uaKJws3p/Fjlve9806WLB0Jj2hyedyrdri18ALuPmyZCqdzk+tyB
         5Bu9/09BAMDkbIosQ+N4w7LVXwQwVW6N/zPH7nyFqDLLVxM7yt1d9EYZwB2GRSeajktB
         CqZA==
X-Forwarded-Encrypted: i=1; AJvYcCWT6lMNyG3XPuWdny4fRdzXY5E+lWW2My0ZMSI/x8ahBor40Q6OCKEQyJHe8ySd9RE3yf1kkYc9Qw==@kvack.org
X-Gm-Message-State: AOJu0YxUDGMCc1uAgHsDS1NUCA5IiF8AYSbKZan0+o7WfyOiz6cf8X0m
	gpixLceNDxr5Ftl6DnykECLTjTNegNxPFNrq3Ia41HUTq0piAwYg0KOQr1iQh3LYHeY=
X-Gm-Gg: ASbGncsGn2ED3thBQAbfETxrIvup1XBpXJ+4t4MmCQNYunmIgBC09aah2BUrPTgwNzL
	pLO1EQszKNn7huQy1DyRggzn1TKYSPJaXMVcfm4xTuJucnVddf3/J4MHPilob0XvNiA/tQxurhq
	P1GFhmgqGhrTvfTb+e24CKJveFqRAZ0e/3+0R2XsocaVaOZAbldFDK8QDR30bX5OMnQs2sJl7bi
	DVPASneBFRAsL3cGHj1PouOUNYIW05NAAFh3Lp6FaK7xNdi4rROdcg63zliMoivmW7pzHcSUIHF
	WQNlI1yJ1RuO7SrpFh5dCUG6MpvH2P5mXTsxWLKFgZ3iugei3eXfSZV7YoQH6QW6YvVRxWL47s3
	yMgi0wobJDudn0/+gV2ocKgR7CE+TRpjrAedBDlsihY8Ids2pSfo58FjZGjnfFu8hum965kTwDl
	gzltjIiGE2DQ==
X-Google-Smtp-Source: AGHT+IG6TVxooarevlSjW8zrVFT+uyU8PdreEG2r0xgjTATLXR8OeKKNJ35yKTRzDmtjqbRnxjjd+w==
X-Received: by 2002:a17:902:d4c4:b0:26e:7468:8a99 with SMTP id d9443c01a7336-290ca121e99mr205845775ad.36.1760991759471;
        Mon, 20 Oct 2025 13:22:39 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a766745dasm8443240a12.14.2025.10.20.13.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 13:22:39 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 20 Oct 2025 13:22:30 -0700
Subject: [PATCH v22 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251020-v5_user_cfi_series-v22-1-66732256ad8f@rivosinc.com>
References: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
In-Reply-To: <20251020-v5_user_cfi_series-v22-0-66732256ad8f@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Stat-Signature: spnbhuenr8j16hdwnu9axwtuzt4ju5mi
X-Rspamd-Queue-Id: BD0E4180007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760991760-127993
X-HE-Meta: U2FsdGVkX18CTv3zF7pSRdHft0lJmwQIv2vYcoPr3t+of38w+B0mSO0aJ3teRqSmnzCFHpBIwSSSd/Ph2HEbsgmq4FxI+bdI+iVSpyt7fUjd06ZTNuFfRHYRzZ+60t0LCHqTfRDmiudblroXzvbsm79F1MrN4lEuzALMfh4L2glJ7P9sBy9FLWZVsK47wmqfdqyivXSS+Dw3D0gZSWUjDCbLOZILZ4VAAZBDFAXWE9VMxz2FI/TrB25/fzGjgskgTGIC2HqbfCaL1r+6awOO/P3IiFSHjG6imspXJzd1MxHFFYll9n5b9ZqLAm+XJh+M24JTwXeokKQXmcKOO+LX9GEj5GgeWVOI8yn347RzfGFzu8zAPCA6LyJw9esJEfYQl7Wp12CAiTEX8QXYk2pgbvxSZ+rvZUICfzgO5FznqQQnknhJGUUmFMLmBVWf3KNqjsJznN0EMSoeeBT5Zco4HW7xCz2fK8PztuOCXVgLBXvjWCfi8KGcomxmRZ+V3C7viJcM+rt3lc5M2JqrgCSeVbl//4aYMUFzz6TfUViLEkfbOxa3rnihrKmQSJAi0yA8fSfxUJN58hoVcu1faDnFwyRrvIE+ynywEvlWtFqllh5F0nCtcJ5HJaVpeXrtcJgwrceyXeB3uevtZRoKNz9MXLnHoxaStJ4lswltOkOTOtHiPAuzlknUM3LzR4CiGN+yfqCp60HKpGZkdyij3iU9YyGmxiPEjnx3pSu1ykVFK7a8z/xgWKQn/vo/oRqINKBSpIu//Mq5uFUQ/ZykNtrDX8QXNGusrdw+bKU/jv9goYkeQBxZ5C0qZrwXHsSpGxHE9+4ejgziJfzjYzwBq7SeYhGPgaQ235uZZLG9SColKt3o37OxBj+I5DXQCuelbGxl7+BkPtvxsYwZtaWEDxin0Swtsv1D1fwSHkrwsTcdlBQZNzNm80fsxb0JLscsBWRHr5TBA4wdUpJu/TTFqZA
 gKYkX+cy
 /5To2uxPudC+eRmOZfuhIpwDaIQzmemF9jceXDNtbBvxgJ/kPhq8gYLN1l33hFZmTTK3gg8Fd3TqsU5593lWnrB2Ehrsptya3kB5OTyv7biSQo/GnbpVDSdp/KHWKVVLqFQP6RyKZ+pCIZjCoX6BYRD35VfEedSiyXhmA2/5HnSIGqkaDg2YETvdDPO0fhBVS0BlOlewn4DEN4syI2mRnMk3Tqi4n7Rpk7bUK2K7/fzq/jy65nSNvsPtg3zfM6I0TbSkUHN7tnc/MA4vca1AXBvjolLeThUPrpaiq36G66KS22sas1UlSTHVZSBxQLSD7q89RvOnJM8aL0bhUVl3BrWJ4iTGF4k3WrbVCmptth+lrjSk44VlukGpdUtsvrKpEGiRSqKibV5gEADEaL9u8QFIa7O3ZS9AbYOyBu5dArmXtBq31M1jtXACRJBLkhnIfeGHC9Q7K2DQcAnDZZcU1G+Vwy6SYmiDy24e+xz75/P575UPxwUNwitTwALxks3HWn/PyQXe24NWgsBv8HVLVMaHM8nQCQt/W/pHX1/HHOPFFuEa3U1y4DKADB3U1YdJ/Whw+maggKPIQRZY=
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


