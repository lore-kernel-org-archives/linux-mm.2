Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23300D2A524
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 20:04:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6CC606B00D4; Thu,  4 Dec 2025 15:04:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67B4B6B00D7; Thu,  4 Dec 2025 15:04:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5432C6B00D8; Thu,  4 Dec 2025 15:04:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34D636B00D4
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:04:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0318D1DE27F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:37 +0000 (UTC)
X-FDA: 84182866236.29.C426D4E
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf14.hostedemail.com (Postfix) with ESMTP id EB714100011
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 20:04:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Lj9ePFRu;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764878676;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7cVA4V+tsTGYh8faQvOG85ZxC8pPRVoW62aZwUk0L0=;
	b=AKtbdZK9WVm2b4RdmV+L6njn4HhkWKsv5/fsDOitrjq+N/SVVSubcWfSn8PiDBr64qCUuW
	7WT6duRgmgDG4sqNejEZvrtXBvjUR0GgKIA/Fds3Az6eDZ43wq9KlXWJwx62IHhrQRHZkW
	r1pA7nNfkXbfPcI47DN51ULyRB6umBQ=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=Lj9ePFRu;
	spf=pass (imf14.hostedemail.com: domain of debug@rivosinc.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764878676; a=rsa-sha256;
	cv=none;
	b=BL3zNxWwaTHUdNntl+iC6GFjUtMrVxQQbGi3V3jHwRHfLqnlkcNf6gAj3y2FxCWodEdwFF
	J8vqp+ZX9cb+ob0i5gcDNwZ9LAjXQ9txC8bLX0SgRKHMqZPAxytfaaB9w7FwNShQZxGxJs
	N0AbTxzn5zyfTZieFZdFBPD0icQdFRE=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b75e366866so636248b3a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 12:04:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1764878675; x=1765483475; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=y7cVA4V+tsTGYh8faQvOG85ZxC8pPRVoW62aZwUk0L0=;
        b=Lj9ePFRu0tZAqTbj/PFWpSJUZI1mz3rSH0b4TqtOghjY/1cige6z+VeJFMZCLbMr4c
         E21BBV3cNGe6n7RD1KxSYFh4snwnyn1E5Y1c5Smw7VdV465zztTJBzwVnlkhC1ylzzQV
         0+dQHkxrKoOEbEEzjT7GAlhRTNOY9NOqrWqn0rRvuGPP/QNp2O/014TWiHKqtvh9vRXn
         OWQznyd324CZ+OPyILwjgTXTQshzxSG58ZG2mCoXxXQLwikXPU50ewqBIIW9I0a9MdOZ
         BPA1bugDVejWAPUvPhf+VPzoqT1rhufljjpdJUtyDOpP7X0kIMUdePo3yJRV+ssaZYOc
         nH2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764878675; x=1765483475;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=y7cVA4V+tsTGYh8faQvOG85ZxC8pPRVoW62aZwUk0L0=;
        b=ZXSEGPny+n4+b7w8T8OBu/AksfbJGLYWKcB+sETOltyJcBRYMejrkzOcWOK5LbqQC5
         JR1tetvEhWAz1eVKW0KSBsGNQ5cYiq3G1IvnnaoOX1jkS0ZAdcfYq9j7JYu9WM6Q5Kht
         7z77O77kw4mrgAr2T1QgUKdMclqmdGC64v8maJznSNGNUqidYNDKtb7ebK+pCB9YATBn
         6XkXT5nK6h6rQyKbtjUufYE1kb5EpUnJDYfML3mUTTVGSWN9aLzxmPjxF2I1Dnlqs9ww
         YcuNYnLX0c1Cz6SQnP1rIELdTnBPNAMupy7kvxyYDVkMDLpqalSr4ldGQLC8Sk14Y86N
         BnDw==
X-Forwarded-Encrypted: i=1; AJvYcCXq8/RZBqAgOKD2kBo9vqzZidJ715yS0oyEyXmHb2Y9ElYiW3l0INLo0Fx3bW1tKsWsMjcaeg7uSA==@kvack.org
X-Gm-Message-State: AOJu0YyEYZOotqf0fEHF1bqMQOp1J934NzH67VZ5l/UUptHyAHPyEDBJ
	7LIYbKYyDHzc9oKIuPOeKEQdfUHqsprO/SdV2Akcclre62LvhTAZbWpWTDjLduV62x0=
X-Gm-Gg: ASbGncsUKMf3QAC/IijYGiF9GEoVUGfsYX6nvFTkzSFHwoccivqJqNhcS054HANsv0B
	S0TrWL0BDga5Zz919geQ/oRY+X8eW/VopjvfTyNDq1njuxPYLWXggvi/TdlWas1PeVw/dp4HHon
	EKrdTtHAi5UEoz4+y4U4eU5cSlY2HksjvGDX+C0tMP8tPJWyHXOLTxg7C0ne7Pszy0rp0Z6SEmL
	8x4h7kEQhiNpHYuSL2Uu55armWujcI73EyDl/XLvwGvam2r4dCiSa5asx78kPzNlZSibVYwqaF2
	30BcgnzHzru/z4MVxwL765CHwDC1lTNqhbDX/LN3Mf219VYGPOrdMzqaVwU+tm3Futhu+BwIdR7
	hNFq5KGejT2h4RZfspbx9IXPlw//fLrquPZVNb9h+SFD5LxrxH0KqrA24fD9Ay86lzF+cQhKp8f
	KwRrU50r37gATLMRhQ+EBFdUDL2idGYwQ=
X-Google-Smtp-Source: AGHT+IH3DRNGCvULusk0MSN0c34XACnhHDWSefcdBCkji/UkCW9Cgr1V8Io5HqSxhaCaIYKCC+gGlw==
X-Received: by 2002:a05:7022:5e0e:b0:11b:9386:a38d with SMTP id a92af1059eb24-11df64a5fe7mr2337882c88.48.1764878674645;
        Thu, 04 Dec 2025 12:04:34 -0800 (PST)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11df76e2eefsm10417454c88.6.2025.12.04.12.04.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 12:04:34 -0800 (PST)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 04 Dec 2025 12:04:07 -0800
Subject: [PATCH v24 18/28] riscv/kernel: update __show_regs to print shadow
 stack register
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251204-v5_user_cfi_series-v24-18-ada7a3ba14dc@rivosinc.com>
References: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
In-Reply-To: <20251204-v5_user_cfi_series-v24-0-ada7a3ba14dc@rivosinc.com>
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
 Andreas Korb <andreas.korb@aisec.fraunhofer.de>, 
 Valentin Haudiquet <valentin.haudiquet@canonical.com>, 
 Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764878636; l=1182;
 i=debug@rivosinc.com; s=20251023; h=from:subject:message-id;
 bh=5pCsCIMJf4iBOvf300q6+KPihTaIQ8ZBfY4WmoGUnLE=;
 b=gAgt0qiA01P7drDBMqFQXuoLVXR1r0qiMVxyXn0hwdIA1M7y9CqEeq19oXDcQmb0Z/54Aoug8
 68he+4K0zLTDttF3EANbQpNqxF1OUC/aAhnwKbqrODAAIjZ7IEJnRR9
X-Developer-Key: i=debug@rivosinc.com; a=ed25519;
 pk=O37GQv1thBhZToXyQKdecPDhtWVbEDRQ0RIndijvpjk=
X-Stat-Signature: buxrujeab3ohx6sjuhf398e34oxm1m9o
X-Rspam-User: 
X-Rspamd-Queue-Id: EB714100011
X-Rspamd-Server: rspam09
X-HE-Tag: 1764878675-257523
X-HE-Meta: U2FsdGVkX1/5Cn4ubwv7k0q2Oz/OSOzOAQcFg9Urq8j3TwGfVEHuCFYQjHxmQo5s3pwOG++mQoaZGWKMBD0xlkPJUD08GnNV/woDp8YimPSXgP2hEExjGpShbbV0XHt46dYM6YdVBA3fKWlR4k9PvalNln9Rc22+9nwyEy3khz/we+0ufWi+7+9Zq8KxyJLMKyyN1IojSZvJcWbl2t059zm9YW0cB5LiRL2BB+C6+mD835tuXjsZacOuvlM/2z7C50ezfMWJTPkGxxMz2E/TqsdoawVvnQ13YaOycIK4+cQCicImWr7ikluXRgOYpwZqr9m5FBH6genvDkKNiJWFdoAaRKaka5WoYQPpW85SPU3W2GjdgLYF7J3cFYrhGa9chGdk73ADWPZx7v1IPbo3Qvsg6KIUYcZUZpNai6VQOvE4DZgCvwrG44h90gvxUzSjanH8LbDQ0vSXOsfVOnOyNAleuhtGqtLbVDthXFMPsf9uj1H+o/pHo1Zkx6itgx3+Fu4sPFATDFlCIQXBSnaWKUp7y9UIUTlWIdt0EDMrIDAXtnS/tfXiK30gXZjGhEOY9bdWJDPge+GvmLMCDSxvK663/r3fkq+F1YkWsyrBEPQYott3oXUjCgaF2mJyHN7rwK8wRSvixgiXJTjqydrD8VuskIA2HCo4xX/fA8qgMMxw095lr2ahGFcQQB+1hXX63la6iRv4N156q291Bsr5e2lzyav2QXyef9IiAM/tfbORN27o8st4RB24NANA25amAOclBRQaEDafPP7ziPnZjVX6qKsLQh1itSwfMdRQ+O/9TARXgbf0su4HDsbdv7HcxbZW0hj/I+LG/dMk23u26Ucr290jWzP35Np0PlFCZvFOUwf6qpbEHWi4saZRBqJXcBPBIeG/ZRX0fDsCkxZ/zb0/rDhFIzgTkoflmoxfMGDL/IyYtJDG98wFkCPaAN8y35arN8bTSHHVoIcWFeU
 tGKEFCj2
 90WYEMy3oN9Rze2+O0xIX1x7NO0LcXgg9qSqtw8BYSIUqvDt63ZsVhHnx4n9UUVmGuB7lPiFJtRaRnHLic7kxreDuewAKW7jRUEFyAJZglJ3nEaiQGGpFBHoNDQ5xRKo1w5ZSM1Rp40rZl/f/zyQ7kz9mxn+JgRu9Ml7lrxjDBRcL82yfYO+DvoqITNSlPDMxK6JAEOpzDiVAoWq7dEOqhznm1ZC58BPoMWZoIc3BI8vwHqsxTbE5Vz8bg729YSslahmQnyWTQTYEkFV0GgnsAzmgmeG/o7uQ8LubwuymVih334NP/eTN6qaLIWSq8+INUVwsl4J+bC0hr/OnfOXal4fTuhddEO5g9QW1hXDxFZS9emcuyviauNthnO+v7C/3bE7Rrdvln/ZfTd9ltZVf5DZF179znYYvIkTXHAas7B/8Nmse3mFwNZClFAeY3KajLh/FrsR0xbdzeSMkU2s6tAV4IYXcObhWQG+XyIfpVMEELL2D5U0WnKNRNi4MlxTFzPOE3536qT2o/sm/7ZxkTemhgNe5UHcYGsr2QcB942R+km6tQ+/E09P+4VaECt5YSdVtXjrZW4W7T2tqRadgbuozsIxMWrePRnVz0bmXDsZhr238zSeNlZkatVSHMKUHoMWepPwkT9Yowrs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Updating __show_regs to print captured shadow stack pointer as well.
On tasks where shadow stack is disabled, it'll simply print 0.

Reviewed-by: Alexandre Ghiti <alexghiti@rivosinc.com>
Tested-by: Andreas Korb <andreas.korb@aisec.fraunhofer.de>
Tested-by: Valentin Haudiquet <valentin.haudiquet@canonical.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
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
2.45.0


