Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B4B4C87FD2
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D63D06B00C5; Thu, 31 Jul 2025 19:20:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14ED6B00C6; Thu, 31 Jul 2025 19:20:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8EEA6B00C7; Thu, 31 Jul 2025 19:20:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A16046B00C5
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:20:41 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 71C6781058
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:41 +0000 (UTC)
X-FDA: 83726131482.13.3A3901B
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 685244000A
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:20:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="z2/X9PRF";
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754004039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VgTX5jh6pXjtEDHfXrNgVX78ota6UPFjSNVgqZFbeUU=;
	b=OLaFvzTT86T08FEnFtHPGeQoKwpZoItTX1F/B5tXYWxiyjS4gDdFhP8bfQb8PJqzawEIIr
	3lq51MLO/YiMGG3exOSnieWnE1oZ7ZUkUv0QiseJuWIAJ2YVi0g46VxeodlX4kAoe7VlTb
	1jDLHhUTuqSdAE17oUq7/GOtS6IBge8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754004039; a=rsa-sha256;
	cv=none;
	b=gqmbjgouCqkBN7VR7rlQC09fQioU3jzkXl45D0SsCVIhXxP8DfaadbbLFkKUtAgc8khEsv
	3q4w9arhkzHG5GspGd1kSBgBy5MV8hyy8/3DTx0dx6wAZ1AHQm/NPWoRVPRChZp+nu/6to
	aE9PMv1XeSQIY17Hy2sXUZ96N9Amb38=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=rivosinc-com.20230601.gappssmtp.com header.s=20230601 header.b="z2/X9PRF";
	spf=pass (imf12.hostedemail.com: domain of debug@rivosinc.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=none
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2407235722bso15926115ad.1
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:20:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20230601.gappssmtp.com; s=20230601; t=1754004038; x=1754608838; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VgTX5jh6pXjtEDHfXrNgVX78ota6UPFjSNVgqZFbeUU=;
        b=z2/X9PRFhmJqlFw59z6Z3NgRVJ+sPJ3VLU6iuiyUhBReCbeByYWSjxDiqTSNV/S3dW
         RFtIbRzcALvpqxnJQpE4b3MCW0+/FxQnQ/cQ/+RSGzNxLJ94PLzAkZK/0U5q14WeB42a
         f9SFsd1+Ljuo5nYEsb+Fsbv7UKdpdghfaQoOh/UfyTOpPbBJ1ZBvN5biijFgZRnMnTK3
         sdaIoXc1Lo6FbrAKZRUfyD72J1fIu4st++d+veICzJQi2pCO96xhI9KuW0fwSOAkqJxp
         eKjCwS9kX9zxv++JinUNNXgKpA/0yi2taAHh+OWRfMZDxTpmyt+d5k81zsppUQMO+5Gf
         RpMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754004038; x=1754608838;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VgTX5jh6pXjtEDHfXrNgVX78ota6UPFjSNVgqZFbeUU=;
        b=rNbFHA3LA2Zq0X8UtpWaUXwYqWcaR/TW22TrpsZAHIjRBB1oCQbu5IqAWAw6b00KrZ
         PhHuzG+M6etUMp5LvvID2W0lxBvHCOhYiHxtvKT1QYgZKPwa2DgulML2W8u1JzA8b9BM
         /PbLOsqvIef7MpRSGVzpIGdvN7cPSo1hW7KoJvYOAno6tEmcBqeXKPe3OYee+0r0ZH2Q
         TbzG/Y8wVr/tb9DpQjSe9DGisVhPRKjx1Rh9uUT0yDwDwcjN9yHZ11c8qKlMudOHDET9
         /XMIo+SYUlqmpgcaGtVIWep7xSN3E+T+J4XkG6ZmzudQCfnO0oZdn9j2SqlEvRg3O4z5
         nXCw==
X-Forwarded-Encrypted: i=1; AJvYcCVxhAa3+M7gLmztbZXneQhVYdI2QJX555WQS5jH5Pwa7bLlWrlrLrHAvOci0f+94fk5d6IKHCRTyA==@kvack.org
X-Gm-Message-State: AOJu0Yx/3HOsSayoVE686vW+xT4voSfjgjRdO8AXaGJrN9LKcaiAMr6K
	i8oySVWXiQOa/m3kgiaJT3KaIo3OLhyBfpG1UglYj6IjcW65XDf/qbYxhNW4eWLo8rY=
X-Gm-Gg: ASbGncuAIOHc0NEZdSOSeDGyIJyuGrE1T5jL3pCr5fIMiEz57fUiDzL6X3MqulHmMLF
	JBbAasu9pbmt0pXiXa+inhxyrFqEFsDaVkDyA0KxwKmePrhXSFirG5dE2B002v/2en3RcMDKEC7
	geaxvovres5t/xlEXGnAREJwoLMGTbnxFjFSO0XeZbMEwpOD8Kxem1CfB57wufvZoiM3AE6kzwZ
	yBN+UVyO8fCzlSJ7x1e1iOGkAumcUqmugiUbaagpsjJHkrRexLhJojLrjSh4a4LUgFmZp53OrQX
	zgWAhq28h17ZUKte3mPsXzbhygz2lFTfH+Toxwyc7mxCbjfVfdQHhssyFpNhixgheeMBCogdteh
	6bqTYoIvGcWb8+sdk6cTHUAbvMNff4oDT
X-Google-Smtp-Source: AGHT+IFocKm/ehz1fiIsLWcZhQFPYpbaWFAYOep+ZmqQMYBIxaD745LVwHCDUcWGcv+rPPulaFmkRA==
X-Received: by 2002:a17:903:2f4e:b0:240:5c38:7544 with SMTP id d9443c01a7336-24096b44421mr114836365ad.50.1754004038129;
        Thu, 31 Jul 2025 16:20:38 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-31f63da8fcfsm5773085a91.7.2025.07.31.16.20.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 16:20:37 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Thu, 31 Jul 2025 16:19:36 -0700
Subject: [PATCH v19 26/27] riscv: Documentation for shadow stack on riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250731-v5_user_cfi_series-v19-26-09b468d7beab@rivosinc.com>
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
X-Rspamd-Queue-Id: 685244000A
X-Stat-Signature: inmmf5yax1wjfmhjujskdrs8f6bu5omr
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754004039-600459
X-HE-Meta: U2FsdGVkX1+eytFx8m6IEuZu1WcdGZVsjbqCu+x2Tfjcml4wgaLRnoJne8UOItSKeSK19BUC8VfE0TrR7imTUoWWA+jKByedjVkBn1IeDrpD7HKtfa9I6rdEN2dlW6w3fkvuCrl1/TPDxR2TYXoJ8zYRT796Jd6W3gmeJVnlMp+c090yo7QCDPDWvetrvNJNCRuDXO6vzuCPJau6nQhhs5pWIJF3fFkuN0f9zSTXHaRkCOfYn2utlNPmHgMMy8o/EF4Y130NdE3RXW2G1qYsyrU8T6/lYEn8nXxA7DtK0CzC/05S00JGnc0DMIyATppPX8CLCzoHNKpgAZdRwmwplJ7VZ1O0XcRQDIulfWTWa62BpYHUyNo4t8LqaXoGaJncOJTPdEx+GCDKQEuHpTFBTKZA0XVlY6fbHASPpf0ul5q765ghOTJRhTJdqvKQRGfD1gBBbRcDJeWO9eNk5EedgLKsvZLhTGF60zgHcl/RFlNHnnyLZieJuglBiqPraaIKF0onPW5bUtMTcx5TolOKJvHtGfosM7vxieaWn4Njd3TnUCYYVz0a3P+bvQCf2GoXT2af3aZgKz1yPvLXuyVi4tH07r0CmxiJ0jdbmeFx9fOhbZUKE31Wdxg6kODagDsXRb68kyC7U3pGlRdIXr7tR2JLVZwschSV9laYVWxZEmEhMb/cqnTZL//G+lelUqCaUc14zVZudZfio+CTTEksahQwFSoO3LSooiBccxM1rwIJgWBO5nt8QdBkpwSHVhh1M3RuUAVZPuSd6s7dSPSKnXAti19OTIJIQPKq5UBZgKJM6Ex6idAIhxyezjhovtv/XjNimUt4jb3fBgiy36uiDvHE0KGwyHhp/voJ4p4/kRXLw+fxFeVMSYrxZg8ueBSs6YICRg73DV2iQ3xnCVoPhbmRiIvIUXkMrVzEiO9BYhKuzdQA/5EZprcOzsDYBtHDFmJlKcQOhSOVpaV5w/L
 dmgXzSBX
 rL7TGfZVEqBCBkDqcOpRFdr4eC20mnKVgiSW0anLBQbviu+vANREhQr3BUrzBbtPkK6pl1Du7qH3PUN3r1i827Kb7IyUGHybxLtuQ1H1uIu2t/vpgix/rLwlmGyhHO2GZgAo7UDeGSn7hYtWZK5/I090DeRtiP9IlwW6Uz2qOhcuQaAb2VN3Y8S1v6t0idwr+SBa9yvbAvR8ueRZ25Fk//GQaKOm4PZygEFXpoDUFO7NFOzCmsS/OgSke2FKh41gmPSzVGSnBGqOTAhMDoFKgPDPxTbbQkMAcbAYBOWnanCMQFLQC821L1zfOf7xHa6q0Ns8Bm/DOcR+t5mwkLF42RfGJRHf+otckruPFCN1oVzO0VsQIMgshFuyoxnxYfADmylRznLG5+7qfEkS75UVDuyqBdLvqoZEaKJm4h186eMvpPIkI4Nsj0V33+HOPOhTQfgq+97g6FMOm7dDxjJLQ0+EbWhBfZ9zv5/v9gGeGCwdwqLwVZQbL6a4YasW+COJNsrt5w88D0pUC41nB5jFFwFLlXRU/y9Cmrn+Uf6x723JghUs=
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
index 000000000000..b50089e6a52b
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
+* prctl(PR_GET_SHADOW_STACK_STATUS, unsigned long *arg)
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
+Linux kernel will treat this as :c:macro:`SIGSEV`` with code =
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


