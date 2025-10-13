Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A361CCD18C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 901708E00A3; Mon, 13 Oct 2025 17:56:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B1BB8E00A2; Mon, 13 Oct 2025 17:56:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B6528E00A3; Mon, 13 Oct 2025 17:56:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48BA78E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:56:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1896011AA44
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:42 +0000 (UTC)
X-FDA: 83994451044.03.7CF98A9
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2AB03C000C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:56:39 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Rv0MYssi;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392600; a=rsa-sha256;
	cv=none;
	b=kXiao80khhHrhxIww+rfTCA9telCR+aIpWV2mrS3sMosI4EVjlP/bKCBk2M4XGOQFlmaFZ
	HD6bJl80iMErZq1KLDGaGluJsKpfjLlnthhB/N1Njh/AcjZ/To3a8wCeOigJ1jKg6MjJRA
	hd94Zcxbcz3r1DU2nSaFPdJNtGCnK5U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Rv0MYssi;
	dmarc=pass (policy=none) header.from=rivosinc.com;
	spf=pass (imf22.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.51 as permitted sender) smtp.mailfrom=debug@rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392600;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tg1KhEMZfMefo+THEb4ueoLXzfJu3WY6LEuxXprwk8=;
	b=xBbmwHOyN8FmGcfMkspRYsJZ01FYCvLFjfV0v/IJ2yIm5dZaEBbtteAewcaf6t9b1qhnMw
	g+RRVid8rmIxRDLdASF4tI/FJ/mFWnsVD1RxB2PKmwqiBmVNSxPx3ZjxjhkiuOBS/mFaGM
	TBX7esiSa3+VyGJUSxzS6aEJLWtp8JE=
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-3322e63602eso6280546a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392599; x=1760997399; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/tg1KhEMZfMefo+THEb4ueoLXzfJu3WY6LEuxXprwk8=;
        b=Rv0MYssiXIOMfxlMYntYSwnhXbJqwPnMSHWoTx6PbstrkdsgI0PoVq+SrahDaFtAXa
         Q7blJ3tY7CFvNviYOhjvyfi2GSqWwWZoEf0MeYf8QApAZVTJa7I8BY/UWfWcKS952ZAx
         UnZdG7RhwVPAZTfaBz4LE6r/tu6JJtyDZHWisq8TuB2Z2+Yp8oUFyDA0pKgmrArMx3QS
         MZPwKg4wlEeZ64/DyX8cog/t8T1IdkeK3YZNo5SNE0PZ/bE4H/sbOQdKDSpkoq2LWAj2
         OHcW/fiLcmts9gTokAIzDjIFK5tLTWz8S2QQY3hstjLhNDtV2ioYHI3j/7IeHaN0oSj/
         h1AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392599; x=1760997399;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/tg1KhEMZfMefo+THEb4ueoLXzfJu3WY6LEuxXprwk8=;
        b=uKAWYt4nCBPqWKdV2gUnROYTpO/of/OpdIMVMp26yGtAZiosLZv6lpcMekJme+XkUi
         lRWzGnIvVzH+mKKzctrSuQytr/dTlQnkCJ5oIHBIXtPjOvdQn5TLUC1A0K3h82DWAqIY
         qQYHDmX828pas9hYJ1u1PWpvIBXngNLWNTsKRKQ2/3P3U/l7vMFbU5u+rl5fvqF5EeQb
         tnUqshCjnA3Sd9kVluNdpI3e4MYLyamq4GFLj4l90iR7cNgduidehV77bZofg2Wa4po/
         rIGYQ8/xX4Y02xy84WBEOnAObG7jnFq9PeE7kDXrnNx1BBZcPW2hHobyhwWxlwplKRdZ
         x1Jg==
X-Forwarded-Encrypted: i=1; AJvYcCX9cFkT5cyqx9xQZrUieWKJuPIio9c5co8Q7nfPlvUScNPkka9qA2c0tsSSWMxRg6JBIE4n2HnMsQ==@kvack.org
X-Gm-Message-State: AOJu0YyJpc9/cNah7cHz+6un72nQm7RyRHVxm3w55VGb0YnvOXka4qb8
	k45Kvg2vKRcq36q9r/MCX5LdkETV8jQQI5gkoK+bSpofu36PaeOSTywLlBhYbA5J+M8=
X-Gm-Gg: ASbGnct74U9gBQuZAJzgGLItnIgFTDeFD9sbYv2m4yYhmWHQTSMkWqak3lYj+bQiktP
	8Ezz4wSi2I6QnBgbEu4ZkmNIVVNHxTQmbFJhS9qLPlopM4yupDhyfrfYLHPy8C4S+v5xm83Xdyk
	PO/cKKIO8A9BAjaAkNmgsQZNfpWLp2ybRcyMP3hJa5JX1nmu2fnhhlDQethOWBI+SJ/IfKeKgkC
	L7Tq1S0ORRZaQYfbCXVUvFZlvhiflJpJ57o+kOa6Ut9Rv/rhGAk9gKI/ARGfNgQx1VR/zjUBcpf
	qFs6RgT5VfHgYLI44T+RAMONjZHDTDFQWgQdvOOHJjFUBQKhaOD2AQGUp53yUv7pK6yeZkAiotK
	iI6IlXbEElUt1C5lc+jXmY6y5WaRnpsCQvAD9NwpOJV4g3n/0XGQ=
X-Google-Smtp-Source: AGHT+IErpeCxY0vA8s7bj04XUohmgz5bxQxVpPcpqkeTx6y9x7HsqMPhnwXuNc3lGWZJbSGptpTQ1g==
X-Received: by 2002:a17:90b:1b41:b0:330:82b1:ef76 with SMTP id 98e67ed59e1d1-33b513d08e3mr27952859a91.28.1760392598996;
        Mon, 13 Oct 2025 14:56:38 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:38 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:10 -0700
Subject: [PATCH v20 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-18-b9de4be9912e@rivosinc.com>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2AB03C000C
X-Stat-Signature: drshz95egdxci9fo1cskiqbra7sshtjf
X-HE-Tag: 1760392599-340789
X-HE-Meta: U2FsdGVkX1/BNloToTkqttgCOiIyN9DURBfFk7FtJrXzVAd3/7M95bCWSPVQI1iEQluQL61JZsR3cfhAU4V2fHYgVuOa9CaxBHaogPYt8agt8yITSAoya5hZkDVdiqNUC0vnYeDacd+CuDWaVrnk+6gObSWsTRIeEKm6oDTudIDJDiXumex2AmFgQiW6dvuCa6Tiddcy2W0G/njoN6Zx9AleyIj3aLq3KFL6/CjLBGH+AmRQEAa2DH0jW7Fx/ykrmwrXq+H5X8P/Bclqxl2flU8muIrXnQWj25Rcr4KywjUUj0IdDhaKSe/sDxatnnhREq8gT6Nib/KbD2lMSEy5tucYKquytInxH1CfyY01tCjhqAQNIxQ+KSvOaLtob1CN9AlCViKl28p+ckFdH7ppBbyEvtKNmRVZCUreCI5GmGAzfMAb0p2DBfe0oX0ox0h2H0Pr2mNZNlpGVA5qpTNWoiOuo6y671AENhAwXiTSBrUzyM54O0N42uM+6Trp9EnJiTyVN0j12fJ5vHCR4sMmt3yrdDTJ36wKkcXXSaaLl8YQU3mO0LYZiZPkjh5GsBsMgiPTT9pkJDAY0UKg/ITWC+MSzYa2iqB/PsZ85l+9NbXYGEJOa13rhdJECWXYlamfCsFICfxWpSaS0P+nUOvb/+PUTN1a1t5NLoXpxrrgncW9KWLXAEkKSCgjhKsilrhwViI+6NDkLrqJMEuvRGGCcIU1CGaughY5xFOeVz+7jAFOK2i6XbqRxJrK9XHAPhyAqs/Bp5w/0bfrASlw6vhQhBeJjvhQl6PUvSNfSBrqH2XtR0vmD4L4a0sfSv8ReRV3zFiSk3W425bFkBI8tvJi/OolKFbJ0ma2MmVEDmkihOOpOX1q1niZS7kukxfbAL4iHg2685sQ7PiE2oK0labIRNgf0B/q1d9oij8FJEuv75WFs5OumiUfvrzFuyn3DUaP2heja+YkJATcz8E0AN/
 oZSBGovu
 quKipEPhaJD1Zn9ACHLiKQ/1sp1dFZB6mugSbM2+Y5fw3cvjCYNwmGNv5PcCTEGMwNCfQjQl1yygFxs/oicgts3ObuEbGyb52Dx+x7kQ28xCm3n/1Lst+SZ6wSGDg1KO5ZZTnXBf4v+uUNyZ4tP3+pEy8/zH7uxI2J4OC4KHxiK/XBgHOWrNuJtgk5vHePYTzsW2ppSBi8zPhdyq45dHp8KxL/kphJBQu66C4WdvML7IDvgKJgbS/RrOuec5CCE9jNCQS1tTmJiO7EYSGEfSxuhW/FMXvZIzbxS/PywQpZKDNQj1Of5PgdPnD9DcA7AZhLFwU+CS5wKwg5ZemtYvZ4PMM2dFvfLDeTbUNOwWlUE7UuNY6h1Fa8wOLnwospKh01KlW8P4ttwnYL3titrd+BGuAK89nJq55PfnOBDnY5kNxjw2ESOrCVbYbN9Dsi04TmdY9YkaezZsRMA5zHxjf/xA5Ig==
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
index 49f527e3acfd..aacb23978f93 100644
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


