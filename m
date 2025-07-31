Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F7BC87FDA
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:19:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 991FE6B008C; Thu, 31 Jul 2025 19:19:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969C66B0092; Thu, 31 Jul 2025 19:19:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8594B6B0093; Thu, 31 Jul 2025 19:19:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8766B008C
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:19:27 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 407175D0BF
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:27 +0000 (UTC)
X-FDA: 83726128374.30.0E858F8
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3A44C180006
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:19:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="jHwn0TG/";
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754003965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AetdkWsxzLbheuZJ3kb+4mhEhv1uz8fN4NCKhkFj5X4=;
	b=qNSiSceZ+iJFwh5iPkyRYD+CJdG/GYQt4JgrNHdHY5jTXyqFgrjVsdtbzaG2R7EP9ds4Gr
	gwJBz+X4e9jkz/mwhqLAk/1f4yjIXhxa2LFgDT3IfydETF35fDH3+vDwdXluvZ4XRtpDKx
	VgiuJgwafoJpZLg3torp07iuXJZ1s1o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754003965; a=rsa-sha256;
	cv=none;
	b=ptqbUHs35Q3WrXocBtL5n13nKOhJTxpfTrXqdJzxYcSfqvh7c6nnj9QirMr2SFRsXUgMJU
	Foy2LSywNSLRsOA+D4uZMHJXjPjotlRRAxUf+aWoZ/frR/sJifjI8v1m4dL0VOiqXdkRcg
	bl3Ca2Ubfg0z+DnzekiVRcFNrzj9XgE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="jHwn0TG/";
	spf=pass (imf24.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2405c0c431cso15738425ad.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754003964; x=1754608764; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AetdkWsxzLbheuZJ3kb+4mhEhv1uz8fN4NCKhkFj5X4=;
        b=jHwn0TG/qXs4WPlDhD0c3Fi1xv6sKuMjc1Q+kgRReKTr/C4pW+CaRWf4T4QQLlH8Ni
         USUMESmz5XSFE792Wl28X2GLeZgpKtDq2S20Wzb8mN71SvB333oQEhej8JpPbCmC3k3E
         a2LSkqxtFXip5JMp3WPbj9lTK4POfYW7NLRa6LFGtbacyH3vdugo3Pd5iusjfLNz8Loz
         /+4StElkH/af+CcLb3IpxPrVRDPUAWHsUG6qRYDYV7u/U/wELuLH69HvXcUAerxqKeC0
         7CtWlpEfJJkJCZXSkNQ72zkIrZNaFS6o0yaaESCeQaNzTF+rWQLZFwGBpq7BgiDfatJT
         jRgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754003964; x=1754608764;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AetdkWsxzLbheuZJ3kb+4mhEhv1uz8fN4NCKhkFj5X4=;
        b=AySPv/XUyjtuX2l63GXOEkvzIMG3JWtLb8icskCyws4L7dXyvNPXLX3tSjzFofPkSg
         ma9BQKcUiBMqMdLTxnKPy4ierGOrDmBfBSjaGuE2P4OTq9easb81jFsPz3pICwQNFImq
         aid8eU3WSpQmYK+/NrirZLQrFjk/QF60u1Bke2wbi6bKehE3ZaXwFpxhfcjpHGNEG7sf
         6qt77gNv10rD/A4jL/9n1ICDQz4oWRG7uO8uIeQMBg9Nsf1ZVXIcKQHs7l+AocuRn/Nf
         BujjyZPz1u92T0CETK/nPj7MdRK6AoLcmdb9TR1D6QW2YfzIW5Y4xdsJUIDkjJMWikaY
         5hUw==
X-Forwarded-Encrypted: i=1; AJvYcCXjHjACYwt5wlHaucFK4mKULhKXFTUJp5XuWUbOm3Fzzb9r+HSGM+Rk8Qz3Wu79YrfuNkIBZUmysQ==@kvack.org
X-Gm-Message-State: AOJu0YwQeYwdv/svvi9bT2VUBSGAGPrSlz9DEW4saJcMSMx54XnZ8vYC
	KpWi8Zm1inNVbuNXBB22t2HHdpQ61Vs1iMjmvgxlICuzf9JrC8j0fFEeZCVhVH0x9QY=
X-Gm-Gg: ASbGncsFXbGTUddZ3ft+VuhIpgu9OdaX5CkhyoLpsV+bJRfv0UECnK31LDRQkt0l4Y1
	ZufeV+n2x8qIJOuzNpYmphJ6UMRH/x95nKoMbdk2B1qrcEvO45rQ3+Wxp4sYpWPnv4uT4oKZKo7
	WlvUuAunjYsEJr1DENIQF+Z+QqpqAMhpJfuUAXQ5oKjCaNEnj62y11ty8tXsIe5rJr4Ko90cw0k
	YPPz5O/j9hpOIrn8gAPJuIXWQS4Rgk9EUXXK805OYJDr6hUVD7zZ6u/8pzcfOceXkfr//7t5+xN
	JePzinZXmPbTFLCeyHJwQMl09cyIKN+LNQ2sPwJ176iK0mu8J9QTP2N1H9ZtVbTCS2BlS2OqdLS
	VyGDxIHOyUT50WXShF4uVMV6NgFB7EkyXcN5c0AN5+q0=
X-Google-Smtp-Source: AGHT+IHQbINJSIJX3DRCY7VWQRNn4wGJVllkshwYu6z4COruD7/LM4Lj3NJ+5unK+IoBRvria/ND6w==
X-Received: by 2002:a17:903:1aee:b0:235:eb8d:7fff with SMTP id d9443c01a7336-24096b0404cmr123206725ad.28.1754003964051;
        Thu, 31 Jul 2025 16:19:24 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.19.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:19:23 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:12 -0700
Subject: [PATCH v19 02/27] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-2-09b468d7beab@rivosinc.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3A44C180006
X-Stat-Signature: o88u14i37e11f9basp3t4xwkjn6uuuu9
X-Rspam-User: 
X-HE-Tag: 1754003965-981543
X-HE-Meta: U2FsdGVkX197W8xk9Q+Nqo135oDn/ZcYoEQtEnBKSWWhrPrrl9bFAQJUDcj1gNuk9MRXP4c1vR3jrMsUMY4ifr0gdfJwx5ED4FtbEJnFPZbmbGYY8IJE5/z0TqjAN+EE8xX+qpgQexkePX5r8Idaubkfj/iQhaemKNoYJMmHLbYaf+WMYdzvI3DbUn2ad9EdfVcXN4uONtp3G6LoHxaNfMnouWC4g/Ffoo2iZpoDLpSHZrwVMH+Y3/fwj3ixVnpifBNDUq66zJ8fUu+EpBp8MExm2J7sgD5RZtb0J4WBud0Th49xY4bQbsSBoJ82Zof2W/6dz9f/6JlJxaXN0P0Vtps9TNlw2FcJt6AgfhItl3HMjcGS410vqJvu4YDQy3w8BOhEuTKqZ+/BRJI9kCO9pnda09qb9WptD7lNa5M7CcLxaNN2C01fgtLd1kivluP3P2X97FaarTq8dAUWzMmcjWMj2Qv3bQX37WEYHHmQGwrcXEKOUhUCH/vxW9QlYSW1co10pEx36aR5Y2Rfgtwuu6AiN4v7OVQXwk7RB4WUodhe4KG3huBPkGtpKy7ke5whd38R09YIiZ8ba8XMxbkWwSrCNrUus3TKy1X3AafYgjZ4aySnC4zwKULVlAYOv8FhHik3GHQ4VEMUeR0hN81W77xQlFOpIO++JSmOFDcZRG/WLAEFsV5KEafgFRW8v75FOSuyYAT+Vmk5wyMhmn2LrAieE/+sRn1r2cPzciEtrxv5N4IQS00jiGKoD+hKAH8fh/6v757mdyr7hOpfAuNtl1C1mdAVIcDIr3GofqGbNnMWgTOGd7/g2W6spJgjYTVjrXP4UjuJEka5g8fS1xWSokPPfi2Ehsi5rHXwocpQwkkgs/bKMs6BlLwsi27VmQjaHbuPB+rMPHJRkXL9qO+mYo2UZtEN0MkllQbRIxtDo9Y/k3I2ebktkotgQ8VxOIcvrm0gVxx8RKN2GqMU+Ma
 HEmgnHiX
 kXr+XHoNMoZA6ekt1XaR/XFsqp0oe+n8WBDKSM2mAlgMAil0B6AQ74m9YK70v/pxy/8YEGqw10oUe4LC6BsjNVv1f/+B545fFSPwrl/Xm/BPA+UNztwkMm3C7q7SVfNy3Txm8smSUPgM3swCiiQWvw7usxEzgB4gblIlsl8PbC+a+rPFVZXLgufRB4uuof11CMBsSoOpV9uWw04Ce0tVQTxwO7oOW6ShNRJZjrCdN7yM3RiSKj/Ia9qyMssdm8GDDMpu6CxuyM05ue4NgQkJWrRVgLlz0V/Fif3OtycVgFYrJTlEyNbIC6HXduKZ86uqVXCveCxTYgjk9ENNhU3+XrxTfGELAqa2VHUcoUbB2NwmjcmFW2icYFBLzmpuEzEjGDg/5l63bSYBg07pLF+3z+8A2BtVXzAJFwo8HXAZ67SDHfBGoxLKf/kJ5WcfqdQ37jV3Uxg7fSZpM15t23X+GkFiIKwn6Ioqrip5Ss1fiACZq9hS6Kgin0Xr+blidJffUEvaJqhd7OKNV5CA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Make an entry for cfi extensions in extensions.yaml.

Signed-off-by: Deepak Gupta <debug@rivosinc.com>
Acked-by: Rob Herring (Arm) <robh@kernel.org>
---
 Documentation/devicetree/bindings/riscv/extensions.yaml | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/Documentation/devicetree/bindings/riscv/extensions.yaml b/Documentation/devicetree/bindings/riscv/extensions.yaml
index ede6a58ccf53..9cfe4381f3cf 100644
--- a/Documentation/devicetree/bindings/riscv/extensions.yaml
+++ b/Documentation/devicetree/bindings/riscv/extensions.yaml
@@ -444,6 +444,20 @@ properties:
             The standard Zicboz extension for cache-block zeroing as ratified
             in commit 3dd606f ("Create cmobase-v1.0.pdf") of riscv-CMOs.
 
+        - const: zicfilp
+          description: |
+            The standard Zicfilp extension for enforcing forward edge
+            control-flow integrity as ratified in commit 3f8e450 ("merge
+            pull request #227 from ved-rivos/0709") of riscv-cfi
+            github repo.
+
+        - const: zicfiss
+          description: |
+            The standard Zicfiss extension for enforcing backward edge
+            control-flow integrity as ratified in commit 3f8e450 ("merge
+            pull request #227 from ved-rivos/0709") of riscv-cfi
+            github repo.
+
         - const: zicntr
           description:
             The standard Zicntr extension for base counters and timers, as

-- 
2.43.0


