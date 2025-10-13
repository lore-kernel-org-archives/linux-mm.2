Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D751CCD185
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 21:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD7A48E00AC; Mon, 13 Oct 2025 17:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A39858E00A2; Mon, 13 Oct 2025 17:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8DA998E00AC; Mon, 13 Oct 2025 17:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BC1A8E00A2
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 17:57:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3CB7D160654
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:57:02 +0000 (UTC)
X-FDA: 83994451884.22.1C75690
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf08.hostedemail.com (Postfix) with ESMTP id 489D9160011
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 21:57:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cowdGfft;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760392620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vF8qB1ggi2AgO42vY2E0TYNR0wLng1Z038sHj948ols=;
	b=ciRSvOX/jcB0DI0LiAP7cZbyhbYv1Dy7M6+DanKZEPZTwswa/sfoT/YZOKdgZCzla3Eyof
	EXJC4okTis9GssVeV2tnWLdlQ03QrulyjrGjMdDvcOSA+ErSGwhhdJ7Mjhxz05iNR8ZA78
	qAPfDCkgjewlGpltidO9pfBjvu20rEM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760392620; a=rsa-sha256;
	cv=none;
	b=hDFmd0xHguZDRST5fg2ND+AbW46bk7RSxdbXVeJ6HEv60w//YPVkO3k68zx52QvGlxVpOw
	RaawLNxLZ9Z2cd8grHNDqkUe3dm+OU+M9LHDKjup8XcHP2mOSur5+aNgu4v9ctItgAYPYg
	L0icGvnpxDtoJ/dCKnvp7WWoTNC6Zro=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=rivosinc.com header.s=google header.b=cowdGfft;
	spf=pass (imf08.hostedemail.com: domain of debug@rivosinc.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=debug@rivosinc.com;
	dmarc=pass (policy=none) header.from=rivosinc.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3324fdfd54cso5009795a91.0
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc.com; s=google; t=1760392619; x=1760997419; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vF8qB1ggi2AgO42vY2E0TYNR0wLng1Z038sHj948ols=;
        b=cowdGfft5YTSCy2p07uK1WRCFxBFkZYUxj4XdA71rJkO1WASACjZGoFY4ED1y9qIqU
         dGpI7mVdSpnyjJgZWGWW0KFzNXOB7l/mBngcx9m84SYdr8hcXFVxgmMVWelQLluPC/SD
         wVHvgYRojZm0B7T9pSDusAoolNNWTxP1VuQNH4YT8LBHe9/T9wDa9lsZq66rHhfXPzJT
         j9w2FVEeZLl0yHN4zcEkYQpum+NSTwe70BuGGzJMQGCp+PjZGWz/Fge37k4+h7003/0j
         iWqSHFuzIB+K2tYNc9DcQSJrwIB9mUlwwhygNHbL95WK19i91HlAE858vs793uA9K+mp
         di6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760392619; x=1760997419;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vF8qB1ggi2AgO42vY2E0TYNR0wLng1Z038sHj948ols=;
        b=o0o9HBHBoEtPyn3OM/LZpV21MVGWSVuVUOYPuy2hi5P3lIELqrGsuO2JOzWi34IMrs
         3UMh4SRVAbfqiwxHMY0aE8OKt2FTO2y94Oxo8deOiUE++DvX9DcXo0cHmic0D8t9t0TH
         qE7DObPRWoLPpGHKG3HWcoAfSbIOoAl5vtmRvF5bzwlda8LzmAb8TJu04K/Tn/Fnxdl6
         fWDEZ/6fI2vjuZzCsuwsVWGL/lFYtKceK24R7S42Ac0rmEJBQBddoPmXOc5KEGqPiSDf
         IxGPDA6h3NfxyWiYWDE/mA7fjepMTfG+dwl7tRTOHAPJqbYY2G+AVfHi26dh47Du1Vma
         z9QA==
X-Forwarded-Encrypted: i=1; AJvYcCXJ22b5H6V21qeav3uT954r1dif3vPfUW36OuP9waWzwByyVB9quQZh5d051AL79BJVzNiXVVRDHw==@kvack.org
X-Gm-Message-State: AOJu0Yw5OO4DPQBGBUF+K4GbxbuhIBXV4xDekGtoEH2nkhSjbZtKVI49
	VAnyy1WKqHbKYz8PzSQEl8Kjt1slQnGsq/VRqMz0m8UQZkv/E0DilY8ir2JopcZGXsg=
X-Gm-Gg: ASbGncs8BtsJiPIPTusNX4XZunzEhi6pGQuqRg/QtHQHyds86M58WcYPcA7BsHwKHis
	6rO8yDsOZ88VYaXPqmD/Mmogl06nBaVxPvDB01ynxLJkVQ3lwwnXTwkZzG0KDQbf6Jkhy09xvx9
	Fnv0EHmpVkyUug9xBLaH2pHg29erUaxoEqWhQWXuFFpGavZexyQ+eZid6f9/HvEdVyir0IO/bcj
	kHUD6kV2gpcrrJ2h/CVtl3xGvWRD/DMM3kNf4bGKw0q9/vgrqeENhCZFKKNKMSCh46M9pYPxW6k
	JFwU5N0xrukZ8U9jbTU6AOqQM3HJMbyEC3TzQs39xwupAqEY30/2m7QXbBE8L4J9PyLPjT/SbIw
	rO/1mPSReE39Yx3iIiSpFJBSFKHco/W7XQ06oXZXZvQCyeIc0+AefOfAbrKfO5w==
X-Google-Smtp-Source: AGHT+IE0yN0Bz3T36AQTxAw7nsrbxeZGmmGkvflf51qWjiWv42xMaWnB+OSCUm7W63hizFcP3EPbdw==
X-Received: by 2002:a17:90b:4d10:b0:32e:ae12:9d32 with SMTP id 98e67ed59e1d1-33b51169e5emr34393415a91.11.1760392618948;
        Mon, 13 Oct 2025 14:56:58 -0700 (PDT)
Received: from debug.ba.rivosinc.com ([64.71.180.162])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33b626bb49esm13143212a91.12.2025.10.13.14.56.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Oct 2025 14:56:58 -0700 (PDT)
From: Deepak Gupta <debug@rivosinc.com>
Date: Mon, 13 Oct 2025 14:56:19 -0700
Subject: [PATCH v20 27/28] riscv: Documentation for shadow stack on riscv
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251013-v5_user_cfi_series-v20-27-b9de4be9912e@rivosinc.com>
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
 Zong Li <zong.li@sifive.com>, Deepak Gupta <debug@rivosinc.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam05
X-Stat-Signature: wazsbh5tejzgtkxsxdzyo1cezchka4y7
X-Rspam-User: 
X-Rspamd-Queue-Id: 489D9160011
X-HE-Tag: 1760392620-239365
X-HE-Meta: U2FsdGVkX18/F379/NKFuVYBgptNb2Bw+SdNbuWJz8pBp3MdpPjvHMWbh1CpV0Wo/Zob+1nZyjs/7KxUIq6Qc8twWrtOBt62b6ejiQwZhg5XCEUVNrLVIApepYiIWuoiGZ45wRV4Az38nx52uDoP93083BQZtJ3zO23ogKSWI1v0gw+TDF4BPgo/MwOMgcKqf+YBm31TbQwWfFMbOiiPesCiT1G9CnR66iG2IlTeUQKF0F/DGEdegzlHZ3Rkl8nHzWoj3X5D07sZu63MgnsMuqKuskdgknl6gfCB15OCNlNwLAGwAfNOkgxwaQDg0mvTmm88/K2wF4pl4Or3aH6ciHosiU4TTNaBP6h41kALStWb8okG0uCZlmZJIG5KclTw01QJDsAZLyzcjbUlVbHdnaFeiT4YAa3S9wR/YUoDXVg1zJ9m/FjkOCcmsBBeCxxA+3nhK6EWNnot6fsADgAXrxrPkU2xhJKjd7xKe8dlTckal4gC7JtiVVDSwbdSJ3Plt3wxf964I30aFell73Ypjq6ZGf+vr9Q6mAzzkE5Er3FCfPrUWMQq70mkzZZcznAnpVx9YUB0WA/PxyIKyBkgGpuJyihoolFV+xNeOwgk2EoSXIfm5RWft0n8pE3/9z0/EAXYBVOrsLTHG9PsSiGWAfOHmLnb4tjfayoF/vgh4kcaLI+iSZs8iAUsU5s+rGYKuuWqUViIP2VnZ57/2PlOK+BilGkOF3lEtW+gGW84iJrC5nqyHp+qMToT+Mb3hus4Fv6fmvi27aaAbTmblhNxzzCHVhmtUXc4xuBgaE7QW89RgSrWzm+0xvTUSNCBh0AqcVtCAB/YhcPKoswGg03NcJVGrfUqEKEZpEpcbsfMq/qczPObI+crl5TGzK35Jw27b56aT5JafB1YhEkzLVQ39BqoI1vZZRL9Qp+5ZdLPnhbzPqLYjWDu7MdxTb1n1X//1LBvaCp0LBqhOZdBZ9Q
 NGa4K4mu
 3Dc6mdD6H4vKj55Mev56BKEe4TM9kGRzJcZkC5y+lsc17MpOLE/78C1xzxCvevIspRkTXscVgydwHe597Tn5u3DHNTEt8tN0dn9zlVvL6mZXCeDz0eJuc272ll1gAi6oqS4Y1tp8NpvQnEhcQl0VQp5qMVIJL/CAalxOxtl9LX6C3HwkBwr2wvnWHI4gqZZW2W46z8wUv3CWP4XOBYUETH5bFKsXKylVE8OSaum6nHxu5BIUwqX7MJTJitGHkv++mYrt9FuaQ7fRRZdvKsy+G2vFt4sU+GBlvLIiD2rzAm+s+x24Qukyr4C2WjPeqxRnybMo4/1eqM3Sy+aJTJmAZDkwKAqynmKgwiP/9orMnMb4mI1YCQ+Hdn7UGRrLLOuzAYdgTHMPXy3s9MP3X2JECmy8gNar+eOl6816zh2qoeX7AoE52tdVr3ibYTdaqYgl2FplgzDZwnQ6AowmwWhvqSAYK/+0nkxddBaLI
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


