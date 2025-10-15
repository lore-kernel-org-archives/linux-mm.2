Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A85ADCCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:14:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A5328E007E; Wed, 15 Oct 2025 14:14:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E03C8E006F; Wed, 15 Oct 2025 14:14:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFE58E007E; Wed, 15 Oct 2025 14:14:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0AE618E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:14:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D268957981
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:48 +0000 (UTC)
X-FDA: 84001149456.13.E7F5415
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9049040016
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:14:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EVbctbGy;
	spf=pass (imf11.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vF8qB1ggi2AgO42vY2E0TYNR0wLng1Z038sHj948ols=;
	b=lzm45qylUhHJYuQYXZoL/+pqnyWsdt0vW9l2LDZrDAF3RpFXsma0Ysw7ZH47G9GaiMp8FJ
	fnU8IRufYJRuvTRckfhiBI/Z+zJXI7Z9ZUApCdbqNXacgoErK5Q4n6NKK2ZAB1zZmV64tg
	NKJPzjFqMX0EMehk+OpXWpJIoiFkIAU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=EVbctbGy;
	spf=pass (imf11.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552086; a=rsa-sha256;
	cv=none;
	b=IIfatc6fdr7yrOPSmzc9JFXUf2dsEWwJPLAT5bcQf6FLvam5qtjNeJCh/DoFCTx+Bv6Iti
	DRMQ5zTT3GHGxQR0nKhdq563dsE0zUtjl/oBlvnJQ0GgU7a3O2bAXhiMPL4Z75Eb1QoO2M
	ctMp8awLmcodCKZO+/WR65qM4c47uqE=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26e68904f0eso70608255ad.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:14:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760552085; x=1761156885; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vF8qB1ggi2AgO42vY2E0TYNR0wLng1Z038sHj948ols=;
        b=EVbctbGy1I7WPRZIinQRLYPpS0GDrIBaDDj3PoONXhRI0xHVvy4VZUc7C/79QNb7un
         hpQZWRL8FaMgeSzBfwxPugZvd5ORK1kzlgWI1B87Fu9AwXMuGpbLj39782F8KlBqPg2G
         +YsZvB5EbUClGSH/sfwyRmxL4PYdNf2Q8oM4fSGqAqOfJSVLNdG8SHxY9SLK52r9f93I
         o8asVuJMITixU5weh8BShZDOTwHNCF1Da2O/FSUwsFxrEybDawLh5ooVtCbKTmkm+Bbf
         eMRr8AnHywV4xHnTbk/1o/xS3RnmCe1cUm3j/FQPdxlzhNsTrUoOSNKZeo2BxGENSndM
         1HsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552085; x=1761156885;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vF8qB1ggi2AgO42vY2E0TYNR0wLng1Z038sHj948ols=;
        b=Gj+ASd0FaIHrlOIEDS9imt7nZBgisAv5XwOIuWVz1/PCx/kLLn/VaqHCkzNBTYYO/F
         kgQK7uYe/7DS5z95tn/rDfQoo89+wN+vqMOxhtc8AIbmIvq1S36iPYtHHyBN0KPUatUD
         5zSp2ZQ6Gp6ox3yb5YoKbVZ7/yY2C+cg5kLXguymStoNFKfhh64ULLD79yupkM/+DFMG
         O3DXd9Re0AF5E8GCSwomKnmRzGLKFOkonL+GFNl5W7kzwHPMrTPjGv2I2hvJW9MvRQzT
         8nDwAbhIFnC72iIIgcTvysxyp/c1Bc055TaTr/xdHczVtZtgLJDS1rI/CKA0J8yduk2a
         0ILQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSl+wjyz0UdqdzJJGjIdaX5m6fZd4dQ43WpxtoW09kqa0NS27FnlLq2xvbkvm48Ds5GJhyBYn/ww==@kvack.org
X-Gm-Message-State: AOJu0YyxxK/JxWwBDQrzsjYDKqeVRLoyLQsNgwtIyGrDkS5CZmboSq+6
	bjbbL/f/wflLlZO/CO6YGKwNT50TJouElcE95KesWiDV9kJg2mFcn8PS2FeXGrmAQuF1gJZ4tuc
	suDQo
X-Gm-Gg: ASbGncui+FnAy8oAVaiB5UEDWrPMmhAjaiz6Axd3SNx7YZz4PTEpNtTxkyhr5OldvHC
	ZXviQ7XS5Kfr3FqSCg85EBWUARzYfsobHSIu45ZHoSluNzz0uzigLmwUSSx6OOKK1HcMWy7gqJn
	uw3740fNgJDhvWJfJljZUIm1k2Nl2JME9jUKI9Uy8F9QxbDvdKRjgvcL6uADYiKt6tFyh7EJcmR
	Z+t5aAqR1xuwDGnZ4izBjmSsWYBHmMb0GwVZfz8dnglqAc5uFsixikVyUKNfnx/JbsNgh7sfO9+
	gKDX4YUOySPZcxs2Pbk/3TYIjmz11quxPkTgJojhs+TYrU9PVADN3byfjgtYzjaiM+XyeJ2Xfs4
	AYCsklAQFKxWEALTqJc2Tv6mznc7pmCnkL4skUDU2PYazloIPt7M=
X-Google-Smtp-Source: AGHT+IFRxaKa/T4laOB1ws3sBGOU/x0bAxdw6xsigN7K/CZNZgfgVlPeOpzGbLKmrJG+9D7I82erMA==
X-Received: by 2002:a17:903:11cf:b0:261:1521:17a8 with SMTP id d9443c01a7336-2902723b1d9mr418718815ad.16.1760552084843;
        Wed, 15 Oct 2025 11:14:44 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2909930a72esm3126625ad.21.2025.10.15.11.14.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Oct 2025 11:14:44 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Wed, 15 Oct 2025 11:13:59 -0700
Subject: [PATCH v21 27/28] riscv: Documentation for shadow stack on riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251015-v5_user_cfi_series-v21-27-6a07856e90e7@rivosinc.com>
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
X-Rspamd-Queue-Id: 9049040016
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: fbfa48b7kcq3y6r7nes4njs7kg7w9ktz
X-HE-Tag: 1760552086-566197
X-HE-Meta: U2FsdGVkX1/vDMSO3nHhMdSW7ot+mY+JOVhPIZLyOKMNrtYtyEfuIdrLlVfQ6U6MtrGct5JUJVHxV8F3bVVE7/rciw3LWrAq0zIerRTFPHrwlNoo1Y4sVHnFuJtRzzq0GmFvL511wX0mPvIk2oEebDTEkWjDn0pFmfKLaEDt8c/iJ+IrUKtq12XuTakZKHNtwZl8hUYq2Vd5aI1xQJpKS//cJOKEWweBZURHePzrvTloyTEgmSDljKWneoODC3aweA/ezCt0lzFguan8uqwHCIV/Ve81xElDmfHmSZONGUVRXhqolr6CVBWIP7PRZ6cLx4T0CNJXKpCJKgcIjgzbRDhOr8AoV1auseXgeD4TDDiEOw1n4ej03ONXfqtFaBc1pn5QbyaA2GSNaFDA+JzDt3Dq4Ne2x16bDHuQsdF1xD2/KFNoypKU5eyxtkhQjKreYaZnB1BRSWkrDf34KTv2sJTWZn8JAYj4t3PGEO2r7TsNlZUggYRg8Jh9DnY4mFbobtWZZlbR8NTEJ2gXUj7296bNEvOT87ppE7FGI0QQGN5UPRZsIzFOstOtLUDWOijT7jHx4MDg3HHOBG9CLWJgZDUp121Wx6epxKccqPgTPpdQWvOvoCUkyaVdyUElbbPa8DqjuiD6bgfTEIydYrJlRKThlHFmU9xGLEa6EL0TSlMsYBdCuSVhWu1nmri+LDMrs9CFBoPGOp0Fjr2RTK+LBGd/CcODwSAONnyph2LTHtPSYJzYRQLRbiRkTpvI5nzgOLdnJqm0GkCmCPlSuoSG4kr6uzP2GnzrAU8Mwh11vMCnbOsLA8Z8X3nlFwQfw46uwFaPsRaztL05IrnzA69aSCXimD8idFU9nLU3wCwqobcIGRFKoOrGdei8biXEg0lRrvpyHIL0yGqq7NXG8sd6+8bEkbhZGNcSMnN/skNNVwp1NHCRr0WOkMpU0X0mzQzJYXE3peziGvJcgJvy9K3
 nITuon72
 f2miQvdOye/OzQphgZ+hrUeFLtatyeRmTBeUeXNNuyT0SN0GZRIfIQug8A1o37IjuD5pvGi2cKGGntCvfZU+s/yc0hdsi610Rs/nXgAc8vJ8p/esVUPaLePvwfO/71UXJNMMU9V1n9zXUWrwM36tNNUYOHjUImKhLcvQi7P86eAMfSqXv1FdRWPRz0ifdw44r2ynHs1xnb9ZJBeP2hbq2O+9Y9C7HCSnr/bWZB9LbKSvUn4C08K6+ixY+AvmuZFyC+qAbXyXIYS0Ppzx7RIRmW3cTTDx7wHY7L7u4FKl8xNcpXk4gSrGNt4KKKKT6JsrOCAKdaCFRcuaZDpVQhtfZpkUuPGcvV+XnJ2oJ4iVanDlKloNrb1vJxZpqvKJqWT+vwOYwl/d4qDiS5ZEVk9ndFmjVhWKbwXYTFVMzeUgcv80/weWW0JvR91m19Qo4mW2emoO/OBQ0DOsA88/V8bc/lF1mK5j4FT7HkklP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding documentation on shadow stack for user mode on riscv and kernel
interfaces exposed so that user tasks can enable it.

Reviewed-by: Zong Li <zong.li@sifive.com>
Signed-off-by: Deepak Gupta <debug@rivosinc.com>
---
 Documentation/arch/riscv/index.rst   |   1 +
 Documentation/arch/riscv/zicfiss.rst | 179 +++++++++++++++++++++++++++++++++++
 2 files changed, 180 insertions(+)

diff --git a/Documentation/arch/riscv/index.rst b/Documentation/arch/riscv/index.rst
index be7237b69682..e240eb0ceb70 100644
--- a/Documentation/arch/riscv/index.rst
+++ b/Documentation/arch/riscv/index.rst
@@ -15,6 +15,7 @@ RISC-V architecture
     vector
     cmodx
     zicfilp
+    zicfiss
 
     features
 
diff --git a/Documentation/arch/riscv/zicfiss.rst b/Documentation/arch/riscv/zicfiss.rst
new file mode 100644
index 000000000000..7fb86d5ba120
--- /dev/null
+++ b/Documentation/arch/riscv/zicfiss.rst
@@ -0,0 +1,179 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Deepak Gupta <debug@rivosinc.com>
+:Date:   12 January 2024
+
+=========================================================
+Shadow stack to protect function returns on RISC-V Linux
+=========================================================
+
+This document briefly describes the interface provided to userspace by Linux
+to enable shadow stack for user mode applications on RISC-V
+
+1. Feature Overview
+--------------------
+
+Memory corruption issues usually result into crashes, however when in hands of
+an adversary and if used creatively can result into a variety security issues.
+
+One of those security issues can be code re-use attacks on program where
+adversary can use corrupt return addresses present on stack and chain them
+together to perform return oriented programming (ROP) and thus compromising
+control flow integrity (CFI) of the program.
+
+Return addresses live on stack and thus in read-write memory and thus are
+susceptible to corruption and which allows an adversary to reach any program
+counter (PC) in address space. On RISC-V ``zicfiss`` extension provides an
+alternate stack termed as shadow stack on which return addresses can be safely
+placed in prolog of the function and retrieved in epilog. ``zicfiss`` extension
+makes following changes:
+
+- PTE encodings for shadow stack virtual memory
+  An earlier reserved encoding in first stage translation i.e.
+  PTE.R=0, PTE.W=1, PTE.X=0  becomes PTE encoding for shadow stack pages.
+
+- ``sspush x1/x5`` instruction pushes (stores) ``x1/x5`` to shadow stack.
+
+- ``sspopchk x1/x5`` instruction pops (loads) from shadow stack and compares
+  with ``x1/x5`` and if un-equal, CPU raises ``software check exception`` with
+  ``*tval = 3``
+
+Compiler toolchain makes sure that function prologue have ``sspush x1/x5`` to
+save return address on shadow stack in addition to regular stack. Similarly
+function epilogs have ``ld x5, offset(x2)`` followed by ``sspopchk x5`` to
+ensure that popped value from regular stack matches with popped value from
+shadow stack.
+
+2. Shadow stack protections and linux memory manager
+-----------------------------------------------------
+
+As mentioned earlier, shadow stacks get new page table encodings and thus have
+some special properties assigned to them and instructions that operate on them
+as below:
+
+- Regular stores to shadow stack memory raises access store faults. This way
+  shadow stack memory is protected from stray inadvertent writes.
+
+- Regular loads to shadow stack memory are allowed. This allows stack trace
+  utilities or backtrace functions to read true callstack (not tampered).
+
+- Only shadow stack instructions can generate shadow stack load or shadow stack
+  store.
+
+- Shadow stack load / shadow stack store on read-only memory raises AMO/store
+  page fault. Thus both ``sspush x1/x5`` and ``sspopchk x1/x5`` will raise AMO/
+  store page fault. This simplies COW handling in kernel during fork, kernel
+  can convert shadow stack pages into read-only memory (as it does for regular
+  read-write memory) and as soon as subsequent ``sspush`` or ``sspopchk`` in
+  userspace is encountered, then kernel can perform COW.
+
+- Shadow stack load / shadow stack store on read-write, read-write-execute
+  memory raises an access fault. This is a fatal condition because shadow stack
+  should never be operating on read-write, read-write-execute memory.
+
+3. ELF and psABI
+-----------------
+
+Toolchain sets up :c:macro:`GNU_PROPERTY_RISCV_FEATURE_1_BCFI` for property
+:c:macro:`GNU_PROPERTY_RISCV_FEATURE_1_AND` in notes section of the object file.
+
+4. Linux enabling
+------------------
+
+User space programs can have multiple shared objects loaded in its address space
+and it's a difficult task to make sure all the dependencies have been compiled
+with support of shadow stack. Thus it's left to dynamic loader to enable
+shadow stack for the program.
+
+5. prctl() enabling
+--------------------
+
+:c:macro:`PR_SET_SHADOW_STACK_STATUS` / :c:macro:`PR_GET_SHADOW_STACK_STATUS` /
+:c:macro:`PR_LOCK_SHADOW_STACK_STATUS` are three prctls added to manage shadow
+stack enabling for tasks. prctls are arch agnostic and returns -EINVAL on other
+arches.
+
+* prctl(PR_SET_SHADOW_STACK_STATUS, unsigned long arg)
+
+If arg1 :c:macro:`PR_SHADOW_STACK_ENABLE` and if CPU supports ``zicfiss`` then
+kernel will enable shadow stack for the task. Dynamic loader can issue this
+:c:macro:`prctl` once it has determined that all the objects loaded in address
+space have support for shadow stack. Additionally if there is a
+:c:macro:`dlopen` to an object which wasn't compiled with ``zicfiss``, dynamic
+loader can issue this prctl with arg1 set to 0 (i.e.
+:c:macro:`PR_SHADOW_STACK_ENABLE` being clear)
+
+* prctl(PR_GET_SHADOW_STACK_STATUS, unsigned long * arg)
+
+Returns current status of indirect branch tracking. If enabled it'll return
+:c:macro:`PR_SHADOW_STACK_ENABLE`.
+
+* prctl(PR_LOCK_SHADOW_STACK_STATUS, unsigned long arg)
+
+Locks current status of shadow stack enabling on the task. User space may want
+to run with strict security posture and wouldn't want loading of objects
+without ``zicfiss`` support in it and thus would want to disallow disabling of
+shadow stack on current task. In that case user space can use this prctl to
+lock current settings.
+
+5. violations related to returns with shadow stack enabled
+-----------------------------------------------------------
+
+Pertaining to shadow stack, CPU raises software check exception in following
+condition:
+
+- On execution of ``sspopchk x1/x5``, ``x1/x5`` didn't match top of shadow
+  stack. If mismatch happens then cpu does ``*tval = 3`` and raise software
+  check exception.
+
+Linux kernel will treat this as :c:macro:`SIGSEGV` with code =
+:c:macro:`SEGV_CPERR` and follow normal course of signal delivery.
+
+6. Shadow stack tokens
+-----------------------
+Regular stores on shadow stacks are not allowed and thus can't be tampered
+with via arbitrary stray writes due to bugs. However method of pivoting /
+switching to shadow stack is simply writing to csr ``CSR_SSP`` and that will
+change active shadow stack for the program. Instances of writes to ``CSR_SSP``
+in the address space of the program should be mostly limited to context
+switching, stack unwind, longjmp or similar mechanisms (like context switching
+of green threads) in languages like go, rust. This can be problematic because
+an attacker can use memory corruption bugs and eventually use such context
+switching routines to pivot to any shadow stack. Shadow stack tokens can help
+mitigate this problem by making sure that:
+
+- When software is switching away from a shadow stack, shadow stack pointer
+  should be saved on shadow stack itself and call it ``shadow stack token``
+
+- When software is switching to a shadow stack, it should read the
+  ``shadow stack token`` from shadow stack pointer and verify that
+  ``shadow stack token`` itself is pointer to shadow stack itself.
+
+- Once the token verification is done, software can perform the write to
+  ``CSR_SSP`` to switch shadow stack.
+
+Here software can be user mode task runtime itself which is managing various
+contexts as part of single thread. Software can be kernel as well when kernel
+has to deliver a signal to user task and must save shadow stack pointer. Kernel
+can perform similar procedure by saving a token on user shadow stack itself.
+This way whenever :c:macro:`sigreturn` happens, kernel can read the token and
+verify the token and then switch to shadow stack. Using this mechanism, kernel
+helps user task so that any corruption issue in user task is not exploited by
+adversary by arbitrarily using :c:macro:`sigreturn`. Adversary will have to
+make sure that there is a ``shadow stack token`` in addition to invoking
+:c:macro:`sigreturn`
+
+7. Signal shadow stack
+-----------------------
+Following structure has been added to sigcontext for RISC-V::
+
+    struct __sc_riscv_cfi_state {
+        unsigned long ss_ptr;
+    };
+
+As part of signal delivery, shadow stack token is saved on current shadow stack
+itself and updated pointer is saved away in :c:macro:`ss_ptr` field in
+:c:macro:`__sc_riscv_cfi_state` under :c:macro:`sigcontext`. Existing shadow
+stack allocation is used for signal delivery. During :c:macro:`sigreturn`,
+kernel will obtain :c:macro:`ss_ptr` from :c:macro:`sigcontext` and verify the
+saved token on shadow stack itself and switch shadow stack.

-- 
2.43.0


