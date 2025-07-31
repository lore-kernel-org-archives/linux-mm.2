Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CA0C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 266E36B00A3; Thu, 31 Jul 2025 19:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23F286B00A4; Thu, 31 Jul 2025 19:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 106786B00A5; Thu, 31 Jul 2025 19:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F08646B00A3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C04AC160C4A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:48 +0000 (UTC)
X-FDA: 83726129256.18.7D48593
Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id DD9DEC0004
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JleeG6J9;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003986;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YcQNf+l7CrEDLiT/8fKsbXFpHxmlSwLjUqKyq0Di2lQ=;
	b=ymqQpNktDrq2JWSK80kHtBjGAwmaLAxLmAjEBZq/SNIRtH4+OCUH77yiUz2t1KD1IOnrI6
	NO8Jr7c3RQvnofgmbw5NGCd4GtEdG5qjOczR4gOJoY5ajw/gyUxNHNUlaXiH4Zx7REjX3d
	72BK5mN4A97qrgkABNiW2lujlBXbOeg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003986; a=rsa-sha256;
	cv=none;
	b=SjucWMOHI8agslrseu33wto1Puf5tkdQjIRUQVBkkcrCSP9oQmAtRYfVT0PZxgQD4lc1fA
	K1Jm6DNiWLV8VVPffTNtFolrGTBriVYzO6jfeB7DsaivjlE1wk7g3DE7GFdlSp+SloTV6O
	QlhUZ/U0omSqRsgzd3ET9ml3KM5z3wk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=JleeG6J9;
	spf=pass (imf28.hostedemail.com: domain of debug@rivosinc.com designates 209.85.215.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b34a8f69862so212228a12.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003986; x=1754608786; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YcQNf+l7CrEDLiT/8fKsbXFpHxmlSwLjUqKyq0Di2lQ=;
        b=JleeG6J9/QCucGuPnhnsExKBUNPEygJd++bUfj+0uGF56l4WzgJoSNFhja75pTE5Wu
         9p78Vy6CIQ0hnQKLcnBhtbGioWC513OkboU+ZkoP/RhXkjNwdKAeLwyg7Dd44sv4TeXE
         LkrWnalAJcdf6INOSbvWmeLoTJHKFlvJ/FNceOsNsSmrwBnPHBHVPrE6NjsUt0E7CeaG
         FQCLHz3RiokqgvcgytjlUNYBeoSMzzX6R9JCHa4FfD4RtmQ1XWjyp26Gy/ofh6RInYdU
         oBupqG7hp/n7ovp1Yd6sU6ukp0rB2m0sF7uPo9+vi4P7maL2w9ZT9ATCU9xQCJG3/Vp6
         zLJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003986; x=1754608786;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YcQNf+l7CrEDLiT/8fKsbXFpHxmlSwLjUqKyq0Di2lQ=;
        b=q+D9KI98D3GRUmaLbSLAr+KnnKqFthJoHfjgHqy/pkJsPi7br4jir8v/9KwE8dF9dY
         YJ2ixcIbZ2mtTCY3Abq/C9+5GOuW4q62uN6uqqRwzTdq93Upu9EbrEPdqKC63ICucbtK
         wPhv2tOuFRcr67oP5RAZ5Fyjw+ZSQMdyS7JPQG8AKoVzBxB+Kdpo8CxT/tNhp++rsg9W
         /Dx5/osuNuvWXU9zWl73BHG1VOL9E1n8yVdLFltnN3cLCHAl78DgZZHPDGjtXB7o30hD
         vdB6Uadj30u8NvPVUTIAIcdms2rYFQl6fsg7XnR3NPdvbL4E16xCk/nVEyFoXFFJsOZ+
         v5Ew==
X-Forwarded-Encrypted: i=1; AJvYcCVpuV4qJ/ONHpsxSkPvX23lmCATfl1fWM94jnTUaTDjiF4bE5ZqAWfMVtZDDFxFiGMR/UxmLcSoQA==@kvack.org
X-Gm-Message-State: AOJu0YxV8DNDWq3Wfz2yImEm8PwjFm0EwNyP8ALW7IUWjkYyaisZ5fgl
	M0+yMhoJB96YtZ3VPorRQuDdV1ctsKPISecoHkbwRmcWWhj+x/lWR3xsJaokJpbWHzg=
X-Gm-Gg: ASbGncufptC/zA38w6LsYrC3YxvQHQKZbsE17I2GnRoKvBzJbFVVOyeDJcHlhtKcwWU
	G+yWLxDQqZgK7SAfwtxmL1IFjU0YpC99m3smgUmQjwPv+nUXpekKEgO4envl0xeDMbW4sci1OEY
	yey6MJoHn4fL7r/N3StScgg32VmTDYl5AVbOrckHaJUOrD5Cs3s1CJt5HneeY7XdhRvbmlFf/+d
	lH1DgSZT9yv6MH/YoA8S3g6sksNp6xVLmdoyYipPmw61BbFoaR+mxU3tOq2WmMvwApv/AknkqJ+
	SBE2pn6ceRxlNtbwe4g4o/KDYYyybukIJkP690wWzQHecjCWr3OJIV/umK/3ls3gRi+ZIVesn/d
	wutKxBQwrdXOlrahCkT23GZoUhd43vZ2q
X-Google-Smtp-Source: AGHT+IG8ZrpcBM3q8FKgO6zVDJahKZxTWTdKtWExGJVc83acMzp6RQIhGZEeMfzbTsLImUCGugdoLw==
X-Received: by 2002:a17:902:d547:b0:234:8e78:ce8a with SMTP id d9443c01a7336-24096bfd5e2mr130518645ad.48.1754003985662;
        Thu, 31 Jul 2025 16:19:45 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:45 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:19 -0700
Subject: [PATCH v19 09/27] riscv/mm: write protect and shadow stack
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-9-09b468d7beab@rivosinc.com>
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
X-Rspamd-Queue-Id: DD9DEC0004
X-Stat-Signature: 76jp9dnu9sbst6bybxxdh8te8mnp8fjp
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754003986-403150
X-HE-Meta: U2FsdGVkX19pDPdv68+Wtju2eqmDwJqWhJxvIqHROFueAGobb4dUdbOUh5uzOuVUqc5m2TaoYdygVipgj4Z1Hcb8LoD6Gjvlh/rOSYAMF6c6tLxMABzDZ6i/Oh/nH/FhSnTk/7YeYeayhw8qTeMhOH5e8Eju4nY6qCXzjcaGB9ZnsPCruTMaNoxQYurC9KvgcJ3HHu8kimV7hKSo5q0zzNFwNhjRny3uy65B9x3+IbIBdg91gVuGSRVloTP1WyE+sFumJ5DOkn7/fUEcubU+DtK1q0shUR441l6fXpX9jGJ/ZN5poUvSqhvaIivTXbGepPMV0VxvPIQOBtodcJp95OfKjDMsr9h6Ozd/CQ3KI2aVrsfHYrQMZh95lN2SORSSUCOxVWbvMOrf4ujnh3gZBZ4k72qZCKNNqccQJzYg173eISDUM5N3w0XfR20ymDBMunPxyhUtboosUMtmYoZ4tS+edQCEerJV6RivwQfLE1HNySj7EALqMxwEF9ouLpV9ASTagBkI6SqEe1K3ael8BT7BhzhHU0NR7gVIfhCrCqHPAuoirCLtznI7d1bqnbRBKtoZupgrUDwiO6Tt/Zjvoo2z2SL9eEUd+3jeJx1/1vcQwWCFhT+R0qqg7piTbzcFYzB0ehdzfe/gTrZCqbbOM1VQfohD6ESCF6L64UT87UWugADiCwHdejQNueqUjCgFl8xrBf23yDX5GRg1UfvAfposOboNrmyxPcCaB4+qrNJeW0nZCk4ApTljMMly5RiYxaaiRvwKNnpN0LUtl7tgZsnlNR5YYdcmeRIZ/dKPOh8m9zuhH3O97XI4Y16TjddqwhC+0tlOrMlwo8DXydoeZBJ7UUm0JaljW5P8GXaGgSiRj6YLx2PdGvpJ4fsVfGeqO3XGP3NQ/sFh8dhKQkwERtq0sW47te7XEgaDNXGKwjidtIzh3ppYf78EY7g9UiIcqwELVRFzAe0h8uiimYc
 DWtG/CR5
 nSxugh5M0zwU5Fs4d2cWnYxgf70kOgkV3s2eUZsjvGOXtLa9nxCwLprpjj4fCTo10VJemSB6LgWpCx07BjCx5iI7vdIXLmZrLjJWdTec/YRh6pV1AQu8EgRCsrPz9/dNXBf05Lkxlpu72ns4NmJPCVXzhpkeFnmO8ZTHOcwktO/hQFPjiuZ22BsRUiALNNuS5NSTck6Vv9k1io/W8w3CjuQZQlsE5gASOZBr7Qac24uVUUafuuZIWjw5BbqpwCeNSWWgTgFTYv2gz/S0lrAtsBjgGtBLe39JFBXVWre7Y0mfyuOgGLh2gTbDgskVVKw0P2zuR7tSgMK+vVD5pAI9rUCeRXAeSIMqhgTugrrFtqc9UVsJfuEXtJ4Kloz7dEYvFNpJGzAwmGf0pPA35P+ONZoOpALah1dYKAdHbhmLUlG+srvrTcUe23KeapHBeTRjN/pzOM5p+E/gbnGujCOAQIFN4jdIWrN2Wwqp/gAGVuHGJZLwVJUCwW/2Zbd9OEG1le1P9TOlCrbMSRM6Q32N2w4V2tbJso861eceIDvN1MzrHC5rYHy0RRp+A3h/d8mdR5CiZVBRoSWBe72rgXT30EkfJcg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

`fork` implements copy on write (COW) by making pages readonly in child
and parent both.

ptep_set_wrprotect and pte_wrprotect clears _PAGE_WRITE in PTE.
Assumption is that page is readable and on fault copy on write happens.

To implement COW on shadow stack pages, clearing up W bit makes them XWR =
000. This will result in wrong PTE setting which says no perms but V=1 and
PFN field pointing to final page. Instead desired behavior is to turn it
into a readable page, take an access (load/store) fault on sspush/sspop
(shadow stack) and then perform COW on such pages. This way regular reads
would still be allowed and not lead to COW maintaining current behavior
of COW on non-shadow stack but writeable memory.

On the other hand it doesn't interfere with existing COW for read-write
memory. Assumption is always that _PAGE_READ must have been set and thus
setting _PAGE_READ is harmless.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 arch/riscv/include/asm/pgtable.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
index 2b14c4c08607..f04f3da881c9 100644
--- a/arch/riscv/include/asm/pgtable.h
+++ b/arch/riscv/include/asm/pgtable.h
@@ -421,7 +421,7 @@ static inline int pte_devmap(pte_t pte)
 
 static inline pte_t pte_wrprotect(pte_t pte)
 {
-	return __pte(pte_val(pte) & ~(_PAGE_WRITE));
+	return __pte((pte_val(pte) & ~(_PAGE_WRITE)) | (_PAGE_READ));
 }
 
 /* static inline pte_t pte_mkread(pte_t pte) */
@@ -622,7 +622,15 @@ static inline pte_t ptep_get_and_clear(struct mm_struct *mm,
 static inline void ptep_set_wrprotect(struct mm_struct *mm,
 				      unsigned long address, pte_t *ptep)
 {
-	atomic_long_and(~(unsigned long)_PAGE_WRITE, (atomic_long_t *)ptep);
+	pte_t read_pte = READ_ONCE(*ptep);
+	/*
+	 * ptep_set_wrprotect can be called for shadow stack ranges too.
+	 * shadow stack memory is XWR = 010 and thus clearing _PAGE_WRITE will lead to
+	 * encoding 000b which is wrong encoding with V = 1. This should lead to page fault
+	 * but we dont want this wrong configuration to be set in page tables.
+	 */
+	atomic_long_set((atomic_long_t *)ptep,
+			((pte_val(read_pte) & ~(unsigned long)_PAGE_WRITE) | _PAGE_READ));
 }
 
 #define __HAVE_ARCH_PTEP_CLEAR_YOUNG_FLUSH

-- 
2.43.0


