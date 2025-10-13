Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1C69CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2975A8E0091; Mon, 13 Oct 2025 17:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F9F48E0031; Mon, 13 Oct 2025 17:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B068E0091; Mon, 13 Oct 2025 17:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7E388E0031
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:05 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DF955A05D
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:05 +0000 (UTC)
X-FDA: 83994449490.08.A523DFB
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8345F80007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=C2kfCGH9;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392563;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
	b=sgMpj2GFhexkgIjNtMKWNUSAL+I+S33JY0aTt3mCEhwCJ1zQe4JdYqR9l7VNogWzg2mBrm
	9katmrGQSVl4z/N1kvdFQN5Rbr23BqE25k8HXUmxEkDNdh5KnKzE1kcolYpEfj5jSMBphk
	ulYr6QEMwjSZaOLHlUwvGvFMv+iznaw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392563; a=rsa-sha256;
	cv=none;
	b=zM99L+5TOfPXuMnPUhfuw4f0Q1IvmxpKWSaVM+apQNaOE80kQB7c4QRrF33inMejadrQx8
	RctOCop2/zGcj+mFcg3rbBcazTTe+xZkOw8/GSGuqFRysvyw2RSqz4Noq0a4KdjoT8ixWx
	8bri3b6yPc17GTckn/lA6sC7JjtYnbw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=C2kfCGH9;
	spf=pass (imf30.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.42 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-33082aed31dso4845678a91.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392562; x=1760997362; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=C2kfCGH949WJ+o96lzB7pCKckr86waW+pwtk1AU9Tz5M7ZfduJ5OQ/ND5YEMQgHc78
         i/ltCVp77Bng3MacN98sfyjU8a+Ro2xxa919zVCV6d+e2a5aWMomYwbcV7DSMziCnext
         SncfppFJfkeQgTWUEH18rqGYAajVyEMOjfBuF6mkIIz21KP7pXdJYv3fGyGIfiTJImZu
         gneQKxFfpNHlK3Yg4+vEl6xQM9z1dhMF6AY+INTIXT77rGzg5fJq/3Jp8T3K52vzD9Gm
         8ZJ2OQLOTpyHwGW/jXCPkvvUF4evP4B0DZiZn44nzst0fXFslETkRyJ/gX/eWOzKZuSQ
         KPsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392562; x=1760997362;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7Vc18KrWuMNfUoArR2DO1WTDm9aMJ2VnekXi8RaYkOI=;
        b=its+Zq3sNeQXQ74PQ1AsqVXxKyg2/srV6QCOnA1U4b64XObS9BP5IEkU2qPkk5iMmT
         dT5ru4X+R5l/eB26l0h+hSiBxE9aYnKYhc5mthh7EQMo62NdpsmUxk8c2zJPBZVoCLaT
         l4GOYUrKjIilM3+DMNGTp2i3JTvPcob9Xyln2lOdvwYqlziEJxstsByPTLDP+WRRpHcj
         rqzqNJrkXOxrpfkbaS0Th6C1u/RxIWCUkfwb2Ts/oAwKPiahM8B6FSWMYn67EOxPY+Kw
         /3UWm55uXtwUusxaG3CqNyMme07gbxEm2OF/bkpCi+Dy6He97HEO7hFsKNqCYQLM2unH
         KXLQ==
X-Forwarded-Encrypted: i=1; AJvYcCUrrKk/VFT5Cp1Bpfr7LeMvYkZJ37fr5nbETg9l8C04mW/2THB666EAM5ErHfHoQDFNOkbtXPY8FQ==@kvack.org
X-Gm-Message-State: AOJu0YzaLVjS3bbhbWuDMeCgbUgmrzizyVC1xH0a4pwUfrbJejuOboU5
	aCeaACRdRAPdZkHGDRXmzaLBdMzwr/eQpgZ4M0Xph1wQh1mTzneDToYrEiNQ78xPkKM=
X-Gm-Gg: ASbGnctMyOSecwZP/9ktLkgfZL6V/3wXfAITmzkFbGFJNkL+Wn2fFFiwt60vVAREfiA
	DjmLMBbEUfjiB3Uw8Rh7zp/KL6vmCPBHFX4mtKBXwj9/a2mOWIGSHMnAhMbmHX5f8x248P0vNVe
	mPgrUSiPuf+GCZqpXlmSRtmmkdZ80xvdp4N4/zDWzUEmUT9IDegjSs1HdD1G9m4f1fPvmpEnUJ4
	Vjb1Q7uYqA5xPNmbNgUVR2EuXkq6o4pTVizEStAHZ4JCmQFrFoswvQEcYALqssZ/0HbklnF1e8D
	GiKPHpSZe+tN9kg2HuEumFjms4AzE/24CoXT6xa+Ut4iRfdvYHGJDYzXkLwixPuYESbSjUktclR
	BQylr0TffM/0PaAulpe7+eYYt3mII0YMb4K0NYT9/C7mBulPoJVdWXaZxnZ6zrQ==
X-Google-Smtp-Source: AGHT+IGp2pHmwU1UwjR7VWVlmD1Zgem8xnSW6VcNxKOg/UKV/EDFr/tijHZhs1T8DdSJm+2/ITobLw==
X-Received: by 2002:a17:90b:180d:b0:32e:3686:830e with SMTP id 98e67ed59e1d1-33b5137586emr32096496a91.23.1760392562315;
        Mon, 13 Oct 2025 14:56:02 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:01 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:55:54 -0700
Subject: [PATCH v20 02/28] dt-bindings: riscv: zicfilp and zicfiss in
 dt-bindings (extensions.yaml)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-2-b9de4be9912e@rivosinc.com>
References: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
In-Reply-To: <20251013-v5_user_cfi_series-v20-0-b9de4be9912e@rivosinc.com>
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
X-Rspamd-Server: rspam05
X-Stat-Signature: a4jy4q1znk47kccdz57j5ym3ueycyhsw
X-Rspam-User: 
X-Rspamd-Queue-Id: 8345F80007
X-HE-Tag: 1760392563-565859
X-HE-Meta: U2FsdGVkX1+I/b6Ph/+A0t93YSUtVspKU3tQmjXv8nocOQkrOTMg5wnOqzmAEJu7Y/8P/hJoZiPq0qPLbU6C8LAk3t4FbC/IIQA1wlcOatN0wD5yiTJOxF9e0CDzs2o+rUFSzXhr80QRdTqPTI4rb8NMulkZPIq/EdXrTzX+MbONgLLWOwh0q9bliYxNB9l48rzoLIe2PZUyR22qb3VdcUKK9nxH/2abCcz3OLtRQq8JSHJSMRGgO3lWW1FIu/PGvOQfWLb8eX6E+cJkR0LOQk7cGz0PyjJ55sajKwXYEygUCdokXoLONlVAxizkMetnctFM+N0xPf/DWh54U9dGN8di0iu0Y6IeE4ZyvsE2JOMy3NpL8tQLuIsag5Qro7qOKRjtsVrCngf/DAb44f+52Qko2bj7IkU8ejyZu9GtS3ThD3YCIuo6Fj06mwR2mej2gdPtlSIv+11+Pqn6qhJ9Z6s1VJINhyNG+e9FVBwPy0+rUU3xc9+navcS9HbeR2m7NNOdw7shWsKMoLVkVcVLvohBoK2sux/dxjE2ZruQMHK7hV0XcFfI6MsfOAR1W2RWX/JNi0n7nQxj0mWRzetLrVGJD5x6KaNXgIpFtYNj6+xs7YVBAkY+ZDgQ+A1+zNQQFFmuXq/6mp/XnPOH5FGUIVrBD5p2IYjnFzvSLKjnGfZS91Rq7ETVsSlly+V5Ob4s1Ik8BhyNXWH2uPtIUWE1ZA20wYQ2r2zyRNaTrJI73kSeQHmnn4B97jft1Q3/3qoLLMpbBdz1jmr7qheExNdYjx/hggBubUImsaqWHSt9tEffg/jLxtrEVP+AVl4A85ZRmKd2sGqPHTyIdKpEhDsno0nHfqpaDwHZuhh7LDJvCNmxrD+Xi/QFL5lI3H90Bea2BuLEqI55PO1pp8F25vTQFsolfh2BZjRsxFCe4161zvOVg5FRv495MEX+UPSRWGR1nm0ngJrTraOFASSzW1H
 G4QiOhyc
 A/LkSlcV07MgpRt7EAe92zlvaR1ZR6iYkVlq4ONQSA1690kzmZ7lDAhcdnj8zhKQ6QEpFim48hi3ZenPnLefC3ueabIIaMCDq8yM90HdR8wNvEqnZdoMRrJtINrZWe5TdWvNf7HONp0azR2yENo+lV0A7PnPqSok0JoRiigSbrjf13QdmOy5RjlkuaNynr4bsrEZdV1qDzYWPdsuqh/Y/VEGhEooYwSG36zfkvpV+ahBGodUMHQ+dk3yfffqeFBjqa6pgIGFsj52eL/Guv4iCF1JZqDuQT0Uqn51v49eUH+BPyCF2NPZS/BxvQR53GmiCLHsNmrUmif9+zLF4k/XMByN9geJlApahIm0uN3QEgWF5jXLUp66vbLGA7VX+YQoXPaktpdNf8fOVp6GsVf/619jJFQZRoswyAjkOnsA34odR7/nULPC+7WEnRsQCBqob3tXR
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
index 543ac94718e8..3222326e32eb 100644
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


