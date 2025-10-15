Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6334CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92488E006A; Wed, 15 Oct 2025 14:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B42E58E0005; Wed, 15 Oct 2025 14:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E3948E006A; Wed, 15 Oct 2025 14:14:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A05F8E0005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:02 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3D78B1190AD
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:02 +0000 (UTC)
X-FDA: 84001147524.06.17129EE
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4FE751C000A
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:00 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YRqFl8o1;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
	b=jfaYRRgLm9FhdnUO4x1eRYheUunCNK3q68TRRoH56tHi+mrAI02GrRBdT4qkbNwxd553B7
	WoiV7Pw153Dznjae2dSnvHFolFeXHIDhfCcopcCckjXpilp90UTCIcJm1cx5YHIaAZjtya
	m8fU6uD7ijGMiON7d6q6r8NBL4Pkw1g=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=YRqFl8o1;
	spf=pass (imf18.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552040; a=rsa-sha256;
	cv=none;
	b=vV75i5pZP+OtrE7Jm97iYic4Mx21TYH4wle4fykRPOw8F3/QYktlJHUe5fgNNBzdR2MTqH
	/GF5WELv9lDrfdH2HTxZuDhnfs/rxfOcZXa6MDd9XcddWhFkB+yJcnE9fAT0J6A5pYJoWZ
	SC6totoNl2Fi8odAy1p604dUbl2weSE=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-7810289cd4bso6589903b3a.2
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552039; x=1761156839; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=YRqFl8o1tZwgFAcgACk/zFaTlS6MMDmauDtue4NqxzTsSCIJR8rGkL+0lfLHycS2Bo
         mbd+8DiCpXKMnT18F1nlPdX8h6wxX6iRlE6saR7fzpiM5Vu5EGcf7kKNNlbpkv1RA2ur
         fQwk2Jpce8ePkc7SFa4hVCWx8n/9BGapmyVMCdO39kjpsl+CgvPcxHu9MN8R+C/U2yXl
         JJaEFb5f9662GbXliz3rdDrgNkRlVjXkuKBixCKY9q+kbVPO+H7z5cdpdZOIM9tdzX+J
         4xIw2Sxie7FKsGvglqQ7SLDvTVutoNbs7dCP7971ulHa1LCgEaADbM7iwjs6N/atgcOQ
         tbbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552039; x=1761156839;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oeDKcuIcO6+2FhxyceVVS2WWiuktyVdq1WpyUni2wlA=;
        b=Zuzh+jU5xDN67u4MNlsEd3SSnsKCn/VfRxE4Yo/crwS+/yfpiVq01l7IhMQgdk2XST
         T7nrdH5Pz3WamUMgTutbUp/pAgSznBWNMpkgwY3ON8ZJymHDbLvq/jNBzkfSMEVJxIq/
         Mr7RC8+qulLghvf8u5NXcgfTbV5gQuhPObwiSQiiZo3gUvX1N2LA0IPPgc7vsTLD+kUU
         xlr/WKpYOKc9iTWezxC3oottOdoi+28aBcPvB4Cat0iP/lAsLqSIRTAh2mD24WuEoTC0
         V7+D8bSvL0GTdU+vB/bVsO9jrW4NPqWbLJ5Fk9oxHczYMRIVIxKXE3gfUc9flp2Dfhsb
         TLug==
X-Forwarded-Encrypted: i=1; AJvYcCV6BYlg3/gd43PcXmg1a7ry084p7ukeZC+dVzoGcc4CPvXr+wb9u7H3HQM1FORZGDH+tKa14wvKUA==@kvack.org
X-Gm-Message-State: AOJu0Ywr1yqUnWxgKHmXuAki9WwsRvnlaFJkycoX8SUksWvqhPzktSV9
	ICImFEkLP0ajweA4fVOh2shU8GnLRst4BkD3GkZQfyLB3SM51ajk14U00PsycOHgU0Y47IV+uUq
	Mf+cw
X-Gm-Gg: ASbGnctrmIJxi7Y7li4A2CslZWxmxqDaYMEYxGoe2KH6dq0McoAD58teSRSbC8NUxUY
	sRKgrjd2Kr/WDt+qxT7+A0fq6yfuvno9FFwy8T2T5zipzEZkoWOtb6sPFNsfcQIzii2dhZGwJmx
	wibiBU6tkDOWr0Zz6E4roDMCLz6/paLmNFgpwcdXFtBeblM5Nm/TXn5EZ5RvJ4Wv/teMpYY17UF
	Odnn05Z3WifwGJpLq//PIrI4c71cGSOvOeUVSXfj4YbLMIok5q/5JXBjUqdP3J1Y6AI2hMQpIov
	Io36ol3vc3FTR5VTnoM+heX2T0L8+/UxKnTD64zCL3GvJ5Ip27tG7+5JuRKVUuC56BoerJHUHnZ
	WkvxNTG3xmvptxQNh2ssffKCQLpvcNwz5sB/lSW662DItuZhsJ3k=
X-Google-Smtp-Source: AGHT+IF7+0siZoxu9qB67nOXjy9vTyzrCE83G46axDJgPfnYJq92ADj9EdTAyl+KZI2DWODagqgyog==
X-Received: by 2002:a17:902:e786:b0:26e:7468:8a99 with SMTP id d9443c01a7336-290272c18e1mr357750345ad.36.1760552038791;
        Wed, 15 Oct 2025 11:13:58 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.13.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:13:58 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:39 -0700
Subject: [PATCH v21 07/28] riscv/mm: manufacture shadow stack pte
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-7-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FE751C000A
X-Stat-Signature: 8r6gq8hkgt1opt6unay31d7jtzdtdron
X-Rspam-User: 
X-HE-Tag: 1760552040-623325
X-HE-Meta: U2FsdGVkX18rXdGSe7ZQrvEP4oXjuTwLZjw917ngrZqN3+VPLp2cXJcTl3Jbxi1vhmjO2OcwPZySmBtHtkE2nQTSCPPf4G05jTx9niQJifVs5NbsUZg1nOsgmo00dynyaeTDZcQ4rLFBU1efp3rkMmh+n4mOeWEzl8gaW2CRDTZDLNlsC5ydiziMDp9mqHAm2cJLDECcseUAip3+sX5fvNorMGCRrUD6X5+aymLRr8OnnFDtJREj44a+DEgZzfXBu3RiTLN7i88NKBZLYw0r9/F42Df2+t9t0R4p0QjYWmXcXWLYsXGFjeDD/xhIp6qQvTeOHLqQk9gVtAmDVH0OkvxXZfIQJZp4vc/d7Z38Zbs1A+OtsVDhRBglVCqBgJde5u/CdXJPh8EkXUx8o/hIaHgjk0iwpxtTpBAt8EQUzRb8lSUPb1MrF5zowhpbdtHEY5+BGXnQ651Ryguk94JNpulKuTIYOzEYp4w73sFRRhPAnYcmtg5txWIGGEFBUsHlgxD8GrNSO4CXbKSlZaGh0OviGv+EccFYA1cmadrAUfpInMhvkIy4pNQ4Y8CNPJk++icDvJSKuuV0Ra/iQpcZQQ2ymSaSZRV2tpyO7z8KtBgc4N1xk72fQpakEmVUBNtuo2nO46lWhz1LLxdreVsiXVkpN4ZBrZaKdaMvKuKDoEFEUB+NtuVmkwSlm5rU8J9i+gFf5aH6zRTYxDYsSTqPFDuTZfSP0bq5svyb+waRc9tBgUW4AZ6vzITKhdrZia3LW5dTsX6PuzgpIblcC8BwjBLTFzrA8SbHwC6ko1IXNkQwm/HZzWPAxJSsFuBsRKGtGH8DkAmB7u/LxBNnpimdznb4uF0b8pqtRGe9EJuyLlG6Y7Z22BaZZM5WJFvdV2Nbz5aXQh0C8N0/qSDi8DhWwWcLA1eNkEemCdpdv4LKj/xU6J5qYDLmWzPSfYHrz3e31Z869W4DcZcvOlkCiPn
 PxrS2Iju
 SLzmhSs/k4MGBsgeY4eD5X9hjXg+OHZtYvkY7ZvQn120lQ9n5o3S8BOqvNOqBDc2knQYqBmqgvC5q/TtRgq77U8oitd7PC2E/4cWju3KNb4Spmgdegbhqug1cEbP3/9H095LEGjDJHNRo3KRzVulVK9CiNW+9qL+URKi1cSswdxfPZpDq3F+mARYCOna+G2Uck3BmXErvl6qGUSrkRu1lV1ek6+upHo1KMXKkrxHikip0jtzFJReMCUTan6EBstIhjAXYfqkqN5sRxVZ7LpaFFh0GMh737LD5qpVvUJ40kIPpP6+KllVDYDmsjQarJqgJXJcb5uHmrXUpqH540x8GwL+foV1ynfV+Vg9At3Zk3FVgYy3OR5DGAyzkYeFpwfqmdFxMoOoxy8sKPZqE+/2n3FyhReoHe9dwTLqaamvF0KoHXkwev4rCGHv2zEiHUEbEjirnSFYe08RA4ZSRxHamXedJFtloUeCifR5ht5HUn2XeHZH2WlAM5vfKL3h8Jn35sJHn
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


