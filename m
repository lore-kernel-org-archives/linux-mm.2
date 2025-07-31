Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E98BFC87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BDCC16B00B3; Thu, 31 Jul 2025 19:20:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8D0A6B00B4; Thu, 31 Jul 2025 19:20:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A56306B00B5; Thu, 31 Jul 2025 19:20:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF716B00B3
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:16 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 65BA1135183
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:16 +0000 (UTC)
X-FDA: 83726130432.07.98A9B83
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id 74E90180002
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=P3KIUZA7;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aaOhr4B8UIBnpyYSF4WgF0h84c6zm8BnVR368xQHyas=;
	b=4C9Q3OU7if0m25TbTab2V+JWJ1GmlQsIvqSDsEfS7YLe0pwSnHzF+m7uBnKx90xQLUnlgO
	qFb4+ADcwb6X+CPJVYW6O+jDX7A5tUI8WhkH2J5zIwiHSeWhOHg1mif/i0/sYM/upjcEPm
	iEvlawjPl/JJq7U34oZrooGboowssVM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004014; a=rsa-sha256;
	cv=none;
	b=NrKXovJbXGnCPx/JtjNOxlYqAH4B+zvYIETAxQqonncG0csHBprMfLll28fyVxpgTsWAWN
	zuBRq9w1wLBnT1ssj505/hDJUBPZspcSo6Nhjpf+kU0spCBsUdeVUG/BqeuXfgddOvZ1MW
	tI1P6TiBUuEbgZv85YycaWewmli6ZvI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b=P3KIUZA7;
	spf=pass (imf06.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23fc5aedaf0so8066305ad.2
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004013; x=1754608813; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aaOhr4B8UIBnpyYSF4WgF0h84c6zm8BnVR368xQHyas=;
        b=P3KIUZA7fHSu6YJZR9anz6PVapsdUpV3rmLVa0qMnguzbdsCNd8p9kIKI75WD8/rQ/
         OlpFWlkIjj9EfgvxM7fQJENDufgcHABlAXoGA+o4pEI6HgspHmH8rPo081FQLu8pY/17
         G6gqmqIusqhQe1ivinXWgshEws4xr58orpwPnHGk3l//Pt3gJZ7JCFZVzg8nihTzJ1n/
         lZpiOQdlqlUjO4Lb3rBfX+dtX+AckdcYE6OSGdYqf6e18AMiUxwdXfEtf0m0P7ysQQTR
         XWR3DmIGagsYD86uRA1vmkgEKOeXbC6xPg1mk17UhhvlgcDMk0AhnB5UIX6Rokpqz0dv
         4nQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004013; x=1754608813;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aaOhr4B8UIBnpyYSF4WgF0h84c6zm8BnVR368xQHyas=;
        b=OBQ9G728O7yfCmJ7BCMHtkIbs5knrhZ3dlNUtt+PQkF5RgfnyeT8Ji7L8IzIjy2Sav
         IDQOYbUggmJnsnRV8v/96QouRkLn2l8Bj7P16gX0In7Ip5Aj3cgEChfgxr0M0QwnRzJp
         GgyhtgojU/uHYIyJ+x3BHttQzGRq4BPw1BJYxIIBiaE8ZprchTqjklu7e6/BugUM7Yqz
         D5TOzk49ohzfHG4Zoqaec9+So8El87LVbvKuXF2PypdD5F1FZWLd3xxUe8Dn7ENesaF3
         1h0fZe63Tk2VNlawY9bMdi9R1avVS52vVy8l6GUZhXDH+uC2gZHL0Yu86yxpmSI1UBU9
         XPUg==
X-Forwarded-Encrypted: i=1; AJvYcCVXpbeSNh5s6ZtBZZdLoqMHkFDsNVcPxJWdooQmZ/oaTkoLZX0Oep3bT6ZgtmFLOk12FBlcmQacqA==@kvack.org
X-Gm-Message-State: AOJu0YyklRK7JGs0KKbgtHoz21Qps4HfBqjufkBhNHAnRR5Qx/IraH1B
	ppDfqstMsJ+wmRfR1+h30/w3E8vN/7ybjJTbXqKOFCnAo/QrxAEz7HruTZg8EHQfMIc=
X-Gm-Gg: ASbGncs0aJCCiSDAWoqU8OboceER5nzh4clI7RU45c7I1fowTP4JUyZ33lj5DHvsfjw
	5k+c68x/aWop9yCBOQ7Bu7AYreNd06+E4ieTDN682on2WxyCcx2GUQJxdk3cnoGU1KmGkedgGSU
	zk0HuW181EITeF7UYJXmNu+lwo7VKLS2R7hVE0zz8G47xl+3eOBUYInh/0pcwLH5jaV1eu5BUmF
	82T4My9d1Ai0u3g3TGDMcj+faspog5RKGmXICTO9+eJByTNNXXVDfAUKf29VEI7R9kuxQwTNBrQ
	J9fbtwi4tLYiAE8s+HUIRBeC/CCsPG1QTArxmkyvt2GI4ye1cCMd6r3JqlPvV7CjVDkAWenRmhI
	Hyder0x2el+5vHeg3dVPqfBezPUpsZ6XA
X-Google-Smtp-Source: AGHT+IEOx2kNK4TLWda5A9GHVV0DV0Tzu98/FGzwUAzzSt+lpD57+aAlabnlaZr4ia9ZMoripanr5A==
X-Received: by 2002:a17:902:d48d:b0:242:1a:1710 with SMTP id d9443c01a7336-2422a3397e4mr5432705ad.6.1754004013350;
        Thu, 31 Jul 2025 16:20:13 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:12 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:28 -0700
Subject: [PATCH v19 18/27] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-18-09b468d7beab@rivosinc.com>
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
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Queue-Id: 74E90180002
X-Stat-Signature: 8k9o55kpb4hqfwcdkmiyfzu5pqfk7jxs
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754004014-143597
X-HE-Meta: U2FsdGVkX1+UHbDNeq26hUiEjq+GIGTRePcu0aUd2QIAspuaHVI9kFCp5xG8GojeiuFWadCmdW65NMFF8OsnOLTNeGHMM09YANws4PQs/evJf3ki39IztM5CktzVyxzqre5rvcTPGwQir/5Klx3O3SVlLy8YENaikCP/rnIEURmUZ10FNNFsKCpug3v9J/KhSTKxVSb5wImcjCg/TKvSC0ie3czvopE1PCWpNbtkYe1koRzHysogkPoYx31ZuqdgpyuMmZO5pDpfDEI3DADrlUsCDpm5RNl2ZE/5WyUv0KymP97VISIe53BWIMZSi3q5VbkUSRNMOQuXl4wgk9iT7hwUk6K4pP+gQytCfazD/hzPc+BVq2v4RpIx8lOEtA5E6P9ThClC8TPywYOcVgr0t3Yo9sUlB5yaYHVDjsCX9TJPTrVEcUwssL3/7hLI/Y1YnE9c8WJR57bA4tHcYC8fblaoBZU1XgaFgDzECLmlW5/wWxxEOqypldnJ9ltsLepxpX5W4ZHYMl1xMsEWOvoeQNr5v6zSk/xjB7sKiaOKfFBZDmSpSowAF+H60yMZMD4Tl3cLTxTWowBZ58XCWy+49bPou6vt7oxivYa6IW3oVBpK9OCuQzxQkEg+fPXRuf8VpMELFzfpIdQmOo8KmhtG7PRqJxNJI59nHyCXQDy7BXZbUVlPcyAwhGJTKhzpP2VeN4o5Tk5nDuA8CnCD/lhnP7DhKDC3rYMwYma1Bh4FwtVI7niDfa8p4snborMdOzDBzVXKFlzrvd/pcpPjD3DuGQzxz/qavw7eiBFLPEosUGz/YbmtJPp0GWfmWqwlYBXSYgar3R4C2S7C+MiNwpvSKeeFwUKX5DXEanhvtGusFar4w5LdpCv1+yCSWqkFCf6MfPXCF+hU3ssnhb538oGtP+FH1NOv7FjcgkXJgG+CWC0SSVXSLhT0WqLBRfa5k4gWHPhDE1OvMOvRQhdfw02
 HNi2sq9h
 g9bquLDAf0IiNqq+f1HVOg4pAA0K5JJ1G3zVthX586eWprbRhz7f65snu3bb1AZiJRqwiuy5EWCORoMwiOIBVPfESlBc+kwyma86frE5iDD1p86eaFr0WktlyZ2sF67XBW5B86Fl6s7Oc7OBImjNgF83X/ZzrRFo3Ztgy4s+aBhs89xeEf+GS/1YUra56MhL2AkpaRhbav+mOiv7saoCNBoPbxDcEPHKthlmAUawI/w7vEWVGThKx3cQQS+L9CtQV+5UvGdpCxvx9WIgJgBgldoV3hjHLFP/sBtVAFx+J3/7wBjYsyf9Vv3SwKJsyJwNL6l3tna3UnSNE3tBhSsYDGY0IpPn+fs4i+98LYVwPr1pm2rlEE0jVA820+rDJCyFj5YrUPRI2ntApmPK4hMLOzL84/ko0QQjJLQshm8c3599h+1IjsqFKpsNF5zKfzIEvwOt7DqUiBDLoE3vB8cah5zigd/rfS+sNSldI83JqJN1dFMX+uwlBCeKjNLvdt42n43ohjZi3ZFnDKAHqjbjlALjdq2ulPH1OxujO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Updating __show_regs to print captured shadow stack pointer as well.
On tasks where shadow stack is disabled, it'll simply print 0.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
---
 arch/riscv/kernel/process.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/riscv/kernel/process.c b/arch/riscv/kernel/process.c
index 91db51413fab..a88b06ad2f9a 100644
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
2.43.0


