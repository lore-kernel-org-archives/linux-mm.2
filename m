Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DBF2CCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:25:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4ABCC8E001D; Thu, 23 Oct 2025 09:25:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 483788E0002; Thu, 23 Oct 2025 09:25:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D5AF8E001D; Thu, 23 Oct 2025 09:25:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF338E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:42 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D4E32140B04
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:41 +0000 (UTC)
X-FDA: 84029451282.17.590DDFE
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	by imf19.hostedemail.com (Postfix) with ESMTP id ECEFD1A000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fS6nH2Py;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225940;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
	b=igVgJmRQCvkfrxBwqobvsBzF8Bc6Vhfl5tDCvSfrd33kbV79sJkbLWJVFbW4sYySY9Vwwm
	9i+BFimxejq7hoD67Ki8VExcopztqkQIEv1sWq/cdtCVx1VinYKrLoT+CtzRr8WuW8eYbC
	CU65umJUGrrV+wdoVV6wSQ1XDpffwZc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=fS6nH2Py;
	spf=pass (imf19.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.173 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225940; a=rsa-sha256;
	cv=none;
	b=TO4f3ND36nxjtLM4Lv9qxt+vXl3/PUVxdWQiUPHocOSuqZmYBStZHIkTMwp83ATDjF0VUV
	zVwcDw8z55totBHo+Ae7RIo4pcaAAM8vFREHPS2N82+Me5XJvDAhlwrAAmhgbntxd6T9He
	pcCnfgEiq8L1tkIUSigDwx3oE47jXEY=
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b6cee846998so513455a12.1
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225939; x=1761830739; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=fS6nH2PyePXmviPPBK9vCUC+JnQ1ZiFaYul/4DRiHv/zkmc8V776wMXX3m0TaND+wY
         35NCVpGLRJikPbYJXVw3XLKrUZJENQ9x8hsFQBFJsgMhgmUqPvmm/l9I6F5qRSouFrS+
         CRMWF4GC6aVDIGGsrzF2FbDnrVfAbdZ4aURwypdu6Lom+Pt6CAqlSipxLgQzzt1dfhIQ
         0Gj2ELVGTWDW/EPdq/KTflniLj4lnnQLinYEV+lxboAiqP7XQaPiBBUC8f6SYzap/wMv
         kBdjdb4c2Cd5F7foYO9WmtF5gY/+IFr32Kh81IiY3CGrnS3AMlQB9FR0fCBx1uz3TTjT
         JHzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225939; x=1761830739;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RuPJu5G7SzSWQtkc01838lduYo70q11KgqBzT6e6NXg=;
        b=CQ5+hIt1h7LQq7asoUwLaxMz6i/UrbWgG3zzeW4eWoaPnttaT1lCoaXCQqCyY9ptEG
         padXz1Jxd1KEFRK+RcyqNtg/ymydMgMphIEYGCrhdVMe6jtihh7oH03xPgfOnhnnx0VL
         NqQOoqQiKz0wUfO5eXHpIwe2yOVxljiM/Q1ZEZeCMjFlT7GnrtwV9DwOXMAkzhTV+fV0
         u+UB3UV4GbHYIFOjMkxbRE80fsdgvyf28YgvsvjiEgw/+/nvZuvriStPW3QSyJD/Z44t
         O8iRshIYfTnW2h5ySQSr0cfKzbyrVlWQCg1q3e8IZuusFDnsLIyjhjjYREx5C4f9xAJK
         SotA==
X-Forwarded-Encrypted: i=1; AJvYcCWVIeLT534ElVZ71TRAuRZHJNcLfYvIXDJ38KsMgunSgEfI+M9TQKMgRs8GFirEUH8Vy/pr1XXRiA==@kvack.org
X-Gm-Message-State: AOJu0YwfEjRNdDdy2JBARFmEsZ6xkMYgqJV7YVkEPLTJ1NmcM6HY77Tk
	5wKun75Kc3SlYTa0gmn4q/KZiyhZONqpj2Yyli+wtP9hSsaXhLB72dqgHtFnmxD4Vo0=
X-Gm-Gg: ASbGncvACxVjsflDacilY7HEVMKTX1p7Fg1160DZRJVyJQGrg3iL9n8QazO/8sHZ2tL
	MwR5UxfH8GvzD9Bzy+nt0hs1gxRjl7sdZufQGNDtsaOwj0IqVDUQGf6yZmjm9M0xHNppPn0f0/f
	vr8oaTF1Pcp9oOAgerDfkwlVr1vi0tYGSWG03aRcYqOvVo3bodx2FtRpN5fGKug+yLM9yE3UdcY
	AJFgYyKxX0uiyyWdvWT1Cp256gfAEYkS/HVgD04c6boRAO088ZUr1cvM+lRqA61GaQN75S8p5EN
	LwUAu5pHaN4g2gxZpgbZo0ynvhASqA6eG2KZEV95CJbZZxDbjx2In3vKsIPM3dg5K1KEpvtpDUV
	CUAHhJS1QkQLVK1hQrVXNhciQAwUArnR+jdHvVLburloORtz8MsbCd8b9EnJnp+VpRuen17rP6h
	i+63FEY4QcV/2GqciyOenw
X-Google-Smtp-Source: AGHT+IHiowaMdQQMukarKWR4DwE59dag2M41jW8yOYSmyuKRWbrYlIpW80BNasPiFne9iuxrtQYkag==
X-Received: by 2002:a17:902:e889:b0:27e:f1d1:74e0 with SMTP id d9443c01a7336-290c9ca3304mr315130655ad.17.1761225938726;
        Thu, 23 Oct 2025 06:25:38 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:38 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:30 -0700
Subject: [PATCH v22 01/28] mm: VM_SHADOW_STACK definition for riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-1-1d53ce35d8fd@rivosinc.com>
References: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
In-Reply-To: <20251023-v5_user_cfi_series-v22-0-1d53ce35d8fd@rivosinc.com>
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
X-Rspamd-Queue-Id: ECEFD1A000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: rqb4nrjdbjfg11jt4r84r99sxtkfgqcd
X-HE-Tag: 1761225939-435185
X-HE-Meta: U2FsdGVkX19tyLijckBzYocrVh+0tAbkT54MuhDP7z6YHi1FiT7V0/rqgLdJBWX8rh31KeQSglGQAeNbf6yCHWicqoYhueftYf3B3hmCWAAkohOZWW+BE0J3+y1WPNAFbj5NPv3QkYZUUoNqCboPzK4qw75OOdXlDLWHOsR8X/ojg/0VVh9nY7uCBr6Vaq/WLwGtWd97eSdUuKpBWeBCB45QRO8NcvuQrBlwV79gOqtlKK/mk1Wb+nR4YxSGcjfRXQIj7dphkMR57OG29HqoEIf79gCuXPQa/Jbs9665VXTwbSI7IoCsXprtOrBtzSVvk3KJkIakBeu5emFNm5csUgNqg1IixM907b/+lgvyKTpE5/cN34AJ9RcQfpYAC4YyoQaLmYQ6jdPh7IKZs4cU3Gy7CGT3kix2Z6U86I9KxkRAV0suTM+uX948ohVde+kLOuSdl8S0ZwKvdEvFvk794QTTW7kOZhqw8EFusjiXw6DCWCdV60xw3DA7WboaXkcX0fPeQv55yydfRclXcoDOSRLjhTHZnYabonGkN15DFNP46RHnQENb4eB3R+FRCerx5T4Es/pK9WoHx1KuO7A08JaC0JR//AAq2M8Z4HZBMLR7zdCWaRDgZK8yyh7h2P2DRVFkEixA4G/yypHBGH8w8dab5BgXYd3FqT/UnzyePZwqSY7qO93A43PFNpd2VIplTrU0guQ0yadxb4qV4B9/bbIB5jkZrSGs67v8a+xmT35PLKebhsZf+VGum6wWoODEQ6sTLFx1x5zzorUvxiiENKSjUdbZjSFNW4EEreW6bekw7N/p/g3Jh9seOeZxi+JpGthfKIfk1Y1XwT4Z5/VShb3aPYMoUAdzds35P8nR42PWHz/w6tPDKI9S02G9973/jgO9QX/V+FsPamvXSLgaSQUaU2DaiDs+qj9bSSd8Je2GRFcrnLOCFGLhVT4RMmXAYhfKZCFTxjNuvHe19m8
 M7ANze/Q
 1Ev+OjOntv+AJ0ySbNrx35mqngNOsx/dSpIC76rI3X1Yt5v8v64aHLbCA2nUFog8aFAh/4w1LnXhjbzXcELdTHgaHhtApSTmB7KmQXEJZ9yk15vNT9o5FUUW6e4/v/MrZQbRC+NGey8R3ki4FZl7IIRQvYnoMYhCWvlBByttGbx1fLFQtq3oZwEAnPwbR+erSA6VpNZw17s+wSNuahI9WYt+SOqmlEg9sGNR6mGq0MUxVTTvEQ9aKqqufgEoA/1m/WYdKMb04h6x3apyMbuJqynzV8XX0o9ZTHOe1C3fZbIq0czLPVd2gf6lmDXg8qsf1YtKHYxPccRby3K+KucFIvb5d2+wgGYrzX7F+xXZLnZyx+sEXakstFPqhdhMeFONMMl0oJmy0JyAFW49DACXR2Ig7H6vix6FCyqZNmd2QVT6QWQVc2pRsN/1Acy9QhQFt0UjMFz41EVpuBHa+snlulBp/pnFgsPRkM/GBzVu3jLR/oFeLUnQUyM4l2sEofYwx3S+WJzHbF9JMwNF9GQpY3y+Jpk8rUXn01eZ2SpSjnaRwjpt6LVELsQiwbj4yzQDJ0TqLzMJT1rWFs8M=
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
2.43.0


