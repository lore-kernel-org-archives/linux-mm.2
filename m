Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D5FCCCD1BF
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 13:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E9A98E0024; Thu, 23 Oct 2025 09:25:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 372538E0002; Thu, 23 Oct 2025 09:25:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23A888E0024; Thu, 23 Oct 2025 09:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0EDE88E0002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 09:25:56 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CE502140A97
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:55 +0000 (UTC)
X-FDA: 84029451870.18.6F577B1
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id C3621120013
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 13:25:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=aVPcfhR4;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761225953; a=rsa-sha256;
	cv=none;
	b=Zh96M8fIRTtYq0tBcBLNjhHsJeSaOADPuyEPy7T0Keu0HXiDzp4Bq9u/IyOOcRTNxxf2Yo
	1xYy7wBoSaTEIVt3kKgBGRoFcI0IXFM5j9tYUpJwQQLU2FNpS/D9Qf7f/QJLde1IX2ELIt
	bDWCJ7xef73B4A6bp6WuIDj/1V5wVA4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=aVPcfhR4;
	spf=pass (imf29.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761225953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
	b=LW/5H/UKwxynREqFQ0iXGe1Q3y8Zy+Ztn2Wv3u3E+6Oufs9sWTq0tLnq79jbXNyF6+NfDX
	J8xwm8XRmKYzoO7vd2yElV8IzI+Ke97WjD+8ctE+guB+k9YIEjqhEXWiL80mK+f0UsTRyb
	QZnePDXS88ZdkagUvs4c/uZk+OGS5fI=
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b6271ea3a6fso553551a12.0
        for <linux-mm@kvack.org>; Thu, 23 Oct 2025 06:25:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1761225953; x=1761830753; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=aVPcfhR4Em4iCXbO5gA0TuphYijJXlz2McLduV9GSYUe84rYac2FXjTS8fcy1yAlA4
         7kYTNG3C/mRiEzBl30hNKofbKf+Ub5+IktNvXrnYrYm6caI0BomROOAPU3eLfezgyTrI
         YsC6j/38fypvrgaTHALCmzhdz4D4wUN2i6TsyAv4CjobzarUmlpp26NEhySlIhSNEBlA
         EtMmn5S1zdLSQbRW1u6Esz4og/KAD5oxjMDJbwaNB2tuxlfCKnaS9WqjYFZuvbIpFz6R
         6YP7ou+lHnO7O1eDc9kGi3dAt19nKfY+9YltcDC3q1Ka5uNHknvpICrGXMWR8wNQKrq+
         7yGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761225953; x=1761830753;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=IbthyLL0wH/lJ2MhTw0TLhPyIIOGIMOXNzyBBb8u8lsXtJpB0zRb2038QT9KFIgGI9
         dLV+QDFuwHqeCx9gBMadNGz5KVV1FQQtcPWEx1BXHN8Gurp7VDDWrhJof6s0OCLfi7+h
         Q8rOcub+TXJpvhmrzkbchvVHozh2ITpbO8ixG3a8edYo9xIIDWbs4ZhBkFcxtondXUkA
         3VGo7lhpAftXYDyf6ae0iL6hufE8R+lFz4qQoTGud3CIobyskQS0cyXD0hxtDSs0ZBnV
         dNh6tiKOuFziEVvTxVTGokfkS/wfaudBlW4bRuEfg9MglvQLOyRcyA9FkQcTxaDCVUED
         MltA==
X-Forwarded-Encrypted: i=1; AJvYcCUDm1oBa6soKiwkfmrcinZF/UZ6eteJSHBMTuy/RYiAd7RxJB7ojJibyCRraMNpIHTf73VIFKPHwg==@kvack.org
X-Gm-Message-State: AOJu0Yz9lIE5KUW5R6qYPUveeMoOyZESWhBhVQjMx7SjZ8MbhZ/1Kx4K
	v+so/eRRzN4zNFjolBJaVzhAbv/93TxHkpfwDPXVKYW/WXKSyx5gryYdH52tZf4iKzc=
X-Gm-Gg: ASbGnct7PsB05EgO9CxbrXnuDe1UrBzzbObojeGuTGKsg8qQ7rzubxigCknSzYg2ecM
	Tnj11neSG90Nsz3uCSD1ENd2tIw4cca5JBVCePTltnj8w2i2sKiRG1ESL/ARqIsI88O/sAx7n3p
	W333qwihjTa0QLg1twTIzOdGYUyW4s7v9eAPQKIA5m3qKTs7Ygiobc064NF1giO4jaxb5+9wHPd
	6Y51HO/s0zqNgSGQ8jWDW7UPhYZhZ0eRdOOifwCZ1DJEbyrSt+G9jWxYURzIkV+v0jt+bdYDAos
	6WaOG9z2PTnS3m6HHfBLMSU4bev4+OJK7eKBVzQdUGkglhFesZAFmvusHxx/AS9Et/5FTYb4BSc
	jNo6wN12FLz1/ICb5QUPFotrsMVwa4ueeJxN6Jwc3/joGwfKY6S2uGWpggdLY6uqyAK8hCAbMhg
	wz1wlyqVoWWXhjNvX+3iV1
X-Google-Smtp-Source: AGHT+IGAxsiF712OrLUPQ8MDODIL3Qk5KsmgHC3vsv1nzcwZbCFCIx22kpnWIeS8R2YjMhFzIyCVEQ==
X-Received: by 2002:a17:902:e5cf:b0:290:a32b:9095 with SMTP id d9443c01a7336-290cb7567fdmr344582925ad.54.1761225952677;
        Thu, 23 Oct 2025 06:25:52 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2946e23e4b3sm23432035ad.103.2025.10.23.06.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Oct 2025 06:25:52 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 23 Oct 2025 06:25:36 -0700
Subject: [PATCH v22 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251023-v5_user_cfi_series-v22-7-1d53ce35d8fd@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Stat-Signature: pi1c4mjfybummme6774deduqadkbp8w5
X-Rspamd-Queue-Id: C3621120013
X-Rspamd-Server: rspam09
X-HE-Tag: 1761225953-533933
X-HE-Meta: U2FsdGVkX187g6OmMQqMUSKam8bSyZlQDoeC1rg88/KQt3HE5EcMlSfgAY/iKzNr/TXTPwuh3Ge6Pse8BcXlYWVGXIZW8cLdi6hp4MeaJEgZ1bbLipN+AJoeLuLLVu1n+nXxHzQP2it+H1Nm7JrM9ImDmaIzFsV3isBZ/xLjCC3WmnTgrJMIDIo1kAsgB362ZTTGGpavA3vfjMjfCwCtTe6wdYyQpmcbbm1ntEZ+3D/yTEE7PRU2BKLYEiSeq4lT8Bppw0czggcL/rU7eAcJDP/Kt5tgZer84I7Z1jmD841C9kkHrrOqtlxHMCIGETAldxiycgDvlzHu1K32Dnyj97jZSw3Ozdzfta4VVoXVf3E+eIg8sV5GZ0BuSkapKzExvOW7a1QFd0IGR7/rSxrLOtK6IMhnADQoyzqu7Gw/hI2POgJU8TgiQZDvC+a0r060GrIZltm7LF3/vcTNtnV2sQnFwOgFAOtsrhMonu3UssPsNpwBlATsEjhfOayliPMdCsSpWE6fAg3+mEFdrJYGcu6poMjiimKUjrEM4d2SLEqJPOCsvOVCu2uUFs+FyjBf3v3BtvjppyMkRvSDlbGeFZuLyFszCN5QFmYIpKn/lk5hVk0ezDff4dV2s4QPiArHqj6WJ/JARufJlOLWwwO583a+f++luj+AhTL5fSyySRlC06TuGOhgj0pfckOPSiszloBHVtK2utjQq0wn6nMtLp6daT/cUnwknRspvF5nr00/Z+tzI66Ter1WjNrNRAnyhEB7TwsaUGALrKa8SwzB2uAOky7fM/emKkyaMYU4TwsSM26IBSR38Ol84quowjXBfKRYCumkOU3bp9Q0UWJSr4U5DXF9hyEKUqOB6DdrfjJxMgdhczEIKshlgdgM7ckEGKLjIDzPWgzWw6ZpsAoUp13MUWKM/FI+ysnwLM3EHAAdfFbEHHJUIb38yPEPKRitS9PDnvSPiVziIPd0bPj
 xCDOEC7Y
 s0K6wwVDZmc6jyqa7SqAct6InC6gxcK7bip+QwSnE1Np+oDJXcFkMYFsKE8AkbTzcF9DclSEUItR+Rp+52E1kd1w2GGwZtPMbaqAbyWkQB6AShHdh7CHaBQHi8oxl3qwAPF5cFGfcLe3rUxaAxaolq3hgv1BS/l1aCr+JPejDYgAEOeLCHIqNN8n4CbG/Hn/ssWVKVQP5I4CA5XLuNTt2F1nAcuavHWqHrFuDDxpXm2HdPEvE3hHV/3KvGq8ihf2RFj0YrkKSsd3XgjEvmUytFCdwxfl5u9lDaRzh9oJPAE5a9IgYoG+uGnABdt29ThHrg6nfrP6opAC5WO/fHAIsU1D15KMBy/Mq0e2DbU9APAKru7JCtQGBQuWGouNp0RFDv6sM5rbAm6fRWmolb0TqGgoAK3dLEzsmwJOcHGw0YtzKrxBy4VLPGH9IhPy5T2mMIi5agRM6dtXiA0TatMltlktjYT3q5uOhbNlOZhCYeol9Wca2GPUGk9ojg+fmmoukvVKo
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
index 4c4057a2550e..e4eb4657e1b6 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -425,6 +425,11 @@ static inline pte_t pte_mkwrite_novma(pte_t pte)
 	return __pte(pte_val(pte) | _PAGE_WRITE);
 }
 
+static inline pte_t pte_mkwrite_shstk(pte_t pte)
+{
+	return __pte((pte_val(pte) & ~(_PAGE_LEAF)) | _PAGE_WRITE);
+}
+
 /* static inline pte_t pte_mkexec(pte_t pte) */
 
 static inline pte_t pte_mkdirty(pte_t pte)
@@ -765,6 +770,11 @@ static inline pmd_t pmd_mkwrite_novma(pmd_t pmd)
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


