Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A54606B247
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=jxRg02zi
Received: by kanga.kvack.org (Postfix)
	id 9294F6B05BC; Tue,  3 Nov 2026 10:19:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DA696B05CC; Tue,  3 Nov 2026 10:19:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F0296B05CD; Tue,  3 Nov 2026 10:19:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5A1286B05BC
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:19:07 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ED4D5140451
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:19:06 +0000 (UTC)
X-FDA: 85394165892.10.0060F8F
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 0700840005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:19:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jxRg02zi;
	spf=pass (imf12.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719145;
	b=G/YMJ4j7jM62QHHkRv7BgzfrusrYGcCKYQCFL7w3/D8Bs7Zr3fgvQiymTbLKWx3Yo835Ha
	zaolFo9/huGE0xLI0rFsHF3UT2wLHRJGVK4lNmPXYgBsFrE0/AACsJ4EdOussEfV4haEUx
	rBPl/0KvIfJ1vEe9dW1MvuGzVzpCNIs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ed/gwawEhmgCUsO2zTzDURm/4rT61HQtm1nt/NY8TTM=;
	b=5L9UtlnmjH0dcUGkABV/X4+2SW5ESQXoPWjZOSilKQlZ9Q9A5Z0TOe1hRVzuL0BsT4yDGI
	96wPPc6Y2tEKWGJErwvrlsjZLPRFuYAbzlP9ZG8+MTxwYnRgg8e5WVqEJbKcncz7YjCxSD
	4s5o5gwDzHeNQKPOZ/DA390VtnBg+JY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b=jxRg02zi;
	spf=pass (imf12.hostedemail.com: domain of chris@chrisdown.name designates 209.85.215.180 as permitted sender) smtp.mailfrom=chris@chrisdown.name;
	dmarc=pass (policy=quarantine) header.from=chrisdown.name
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-cdac6d19ddaso1719991a12.2
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:19:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719144; x=1794323944; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=Ed/gwawEhmgCUsO2zTzDURm/4rT61HQtm1nt/NY8TTM=;
        b=jxRg02ziDjMj2A7UqsCP40NObk3w6zxqi4Gr5nCwBBEApkeLnPeMAVB0SyhWdWsWD9
         4iAslck4OD6Fld5y3caGeDx6iUNgWF533s2r4CQSvPd0jctIG9hoWjIeOKDexCLKiLiq
         B5zN/ugTz0VQVYc2nludCsPDNPrVQmRmy0jeI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719144; x=1794323944;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ed/gwawEhmgCUsO2zTzDURm/4rT61HQtm1nt/NY8TTM=;
        b=kG+Wwf4N6MSsTsycPTTxAYqKnMDVQDpdabhkettiTY/eFKAp5LePtTw4VyPYC1Xtem
         5bW/rk3kWalFmqTq9s9lmpMdRPhKjKi6waSrbXbNXd8PmXcryMwnWLC9bmNswE4F+zip
         mts2qZjbtj+LjnQxVDfhZIEZaCBN/Gw6z09Y1HaSCmOvHiMCbReuUXSmAwSY4ucM1NxV
         l6BEXoKsMkmUECEsj1C2PNjtQBu8yy+z0KkyIbtgYa5qnCcRVunVeuABUfRgQHAHGlEW
         9senztHAJZBSzHyMYc4KhMsFYq5rEt2jkN9klUgVPFnb8OG3VCtaaajCsVZaNPlIOBpC
         XKcg==
X-Forwarded-Encrypted: i=1; AKwUvBysGbQdMIGLCtKpsuD/jRH4x4jSuSACWm8L08mOOJqdlNyCmiFK7teNQiF5wAk9ritVp/d/XQm/xQ==@kvack.org
X-Gm-Message-State: APuU4Z/d5SxsdUd8N4QZ+IdD1l4Blq9Jq9cGEkfUx437BHuQDukOskwH
	RWf61irx+FHbACz4xxxdGyumYzfdPJd+K9NIKE1TN2hk2IgGwltJmEx7/iWQX0pJUrk=
X-Gm-Gg: AYBFou3enyZFEMjYTZrB64ONCMILqjepXvUllw+2/wpqDIAPr26EHbPnNbMOcxxG82H
	nGwh6W7Dtsw0lIzc3Mr0m8BxHqcqih+d5lbcSmQgKKuoEVzbDaxhNeJP2LN18gUxIrgn+vDk5Lt
	qew8Q2lQTDrrFCJ8chZjdt1SPStbu/9LOjGRnOoaURZ8oFcRKNI0HNIGjswCEGCxgE+fb7VB9J6
	gLWMyH4JUavPF+qwgEBkmGKrowjI9a+MeJ0y6sLpfc3AD/d8jghpvF9+T7lPkU8WE1e61PzNsXG
	stvsrX55Ohj6TQTE66A+CWyswyJeVEPHWY3J0Fz2qQhJ6K/rEzpFlXlIieY2oBTN8XYdbGaYoDf
	BZcntoeGJXHW2jyCg7gTUnFJxK2pHFH71mGsY0yhhjzivDtosuBBrbMo6NnAzlp3BD9ER6m2Wxy
	lxYgkJq3AbaWhrUB3POBq5zW13kSLrWe1wofSr/s2bBAHN+3F3OQ8eN6Hjzlx6dx8Pcguc7j1Xu
	HpVdhR8T/3p4otqdK+gP8UsSZqdTgJIxmvPlnh8nCOAXC7PMw2l85WKTbIIwbK9hT9DMdiGz9lP
	+sKWnjycOu1ltuMBYXXZ72dv2huAtycsHme/iEE8RulwDqxbcM/qnhJONLMJKQdrHUePFORqd38
	+XfoZb/SpK75q1yUWoyK0+77rpq0iQ3M2E/vXssKbeTGYqVqnlYXoj+sxt3y7457eL73WYnfZJj
	GeWNIweVHqa28T5iw6/w==
X-Received: by 2002:a17:903:1b05:b0:2db:733c:fd1f with SMTP id d9443c01a7336-2eb364005f0mr112964235ad.8.1793719143805;
        Tue, 03 Nov 2026 07:19:03 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39262c47sm43118815ad.38.2026.11.03.07.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:19:02 -0800 (PST)
Date: Tue, 3 Nov 2026 23:18:59 +0800
From: Chris Down <chris@chrisdown.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>, David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>,
	Andrey Vagin <avagin@gmail.com>,
	Alexander Mikhalitsyn <alexander@mihalicyn.com>,
	Shuah Khan <shuah@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Randy Dunlap <rdunlap@infradead.org>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-security-module@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: [PATCH v2 7/8] mm/mseal: Add no_mseal_sys_mappings boot parameter
Message-ID: <701a3346a0105e801d247c11139853f156a8d15a.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Stat-Signature: 9tsbuhg1nd8rdyr1fjfwpyc79i4xppda
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 0700840005
X-HE-Tag: 1793719144-391717
X-HE-Meta: U2FsdGVkX183dTg53ltYLoS7lhQ/AvmNYqgu5ei8hO0lLpABQkQkeaAabMei/U+8aEK4+effXvfV6Rr7KMpB1OEycY5XT/Jci+aPrdUmVpEiupeFLA3q1Rx/OeHTa4mwngJ4F9m0pvu6GlbXba1e5gqg8oSLUCS0OD8yesk/XLI/ToPgpqCPcAM1ie32tdWIUqd2MP5P9M+fXQMtmiNmQdU+pFTE67Yn6IGRfjFYwDlFTXO2xomt5PaG/a+zdj5VXGW7GCJQ8pE/IeWvmet02MttoqV79R7bGBh8eaitmvBl9VJaKRULhxQks8MJhYhglbGweq3Xsl7FDl3xAfwI8QD7hjgk3y5tbm0l+9CP9Seyl4huRxJVzWz1JgdNf1GbMOG8NLMDXJUJmnx/MFoO/Hso/Q+xeLZNWL4M/+K8FD/gyTT4biPB/Nf+Vyap9BTamR9JJ94sKKbjjXbesfnGuoiq1FTq5HIMXlp5A/GGBWTnayWUBLUyYzS+XOs48yu18knB+G26/jfXGgXG6IsWCsBnAz2ubBRKPgx/LmerDS3/4x0ZJ9gl53Dx4waSp26XypR8j2JEd89ucEmwij7PkN/YkXT7P6nReVgC0ej7azvBq5IGHDayqY2JdYnyA58Bl4D/ftaWHb9/8SFcFDMZxxsrHve+FS6DCr329n/VYQUA+D+3Q3rTyQItunJhLGmNVk4ITsY2kFN50M9mOz8CMEJx6a5R99wRY4AKLCMHS1WUDrwxE5Do/wt/BHAtNK99N29gwOgscqNuq3G7qT84UDU7+QZn8qqteecF4LUVAOux9JaegHQhJt6rxZdaU6HgJs3gVhkO/KeCkFx6LkFfDFa1QZIOIyTwnjMJqRSl4sGHMprG19YyOlVk90/vPbXENuaVwT/9JWDAyep9uZTOTgJowWXUmo5Eww54xrvyAWMRVU4+XpFOuXQKXAbV9snf0DJIsMkthrzYlRFqwu5
 O2/3Jdn5
 NwrmcS9hexk24419s3NU7minFFWqJgpMDi6miw0X9ShnNlm7kKkUBCmj40JH/Qg9yXvc2wH1PBf0MJ+Jd3BbhfJiDX2Jlms/UgCluvIlHQjsd6MrO0noolgTfh3zTNWb3U9D7be/mj/jWcCqm/aj8R0UUQyqx2EGLtM1Ei2ZFLUY6rbUEmV0XqaQ1gIUtKg+mFn2/lmbfKKj1hq/WbjvV0nfSn6S9yjB+tgBzIA+I5mFDzKK0x3ucQC3FD/EVqDtRcsPwNAyVWYT2uT5vmMBgWXBpJUl7E5aDSlgxzMjLsbGi9u4e2mXtybcMd8VBmmekWy1QRmartzHhigd50YELThapo9hSCLhNagRXhSVkvm3OaCoLtjGPY9aH97OVgrtNSm4tv1amwo0cTxzbww5LCxp/Bc99oD25TMtKnQO3i7kPYYaAAXyyeD03NktwY1gOiY3/DW6DBGxPTeb2PpEJJwSmW58bOiTOgtiY0suzSXXK6sSbkLUaD6A8QxYYziN2FFIORCaKpM320BLAHbHMLg9IDZxN+5nLVzWU1+wGf2/BcyNwCIBVEAkAP123iA7nSgRPaZugziybCtyawccvXoepHtwXeMBr4wo/qmQiLeEvIB6/D9N6cduhU1mQm3Za284hbS7TxCJK3c4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_MSEAL_SYSTEM_MAPPINGS seals each process' system mappings, such
as the vDSO, when they are created. These are read-only or execute-only
mappings which every process trusts, so sealing them means that a memory
corruption bug which can pass a bad pointer to mprotect(), mremap() or
munmap() can't be used to make them writable, or to move or replace
them.

However, sealing can only be chosen at build time, and it breaks
software which moves or modifies these mappings. This is not ideal,
since hosts which want sealing and hosts which run such software then
can't share a kernel.

For example, at Meta, we build sealing into the kernel for our VM hosts,
and we'd like it on as much of the rest of the fleet as possible. The
problem is that the rest of the fleet also runs things which it breaks.
As one example among many, Reverie (which our deterministic execution
tool, Hermit, is built on) patches the vDSO of the processes it traces
by injecting an mprotect() [0]. So right now the hosts which want
sealing need their own kernel image, and this option is one of the
things which forces that.

So, to improve this, let's add no_mseal_sys_mappings. That way one
kernel can be built with CONFIG_MSEAL_SYSTEM_MAPPINGS=y, keep sealing on
by default, and turn it off only on the hosts which need it. Kernels
built without the option are unchanged.

Since sealing can now be turned off at boot, MSEAL_SYSTEM_MAPPINGS also
no longer needs to depend on !CHECKPOINT_RESTORE. The option is off by
default and already documents that it breaks CRIU, so let's drop the
dependency. For the same reason, the documentation no longer needs to
say that it can't be enabled universally.

Link: https://docs.rs/reverie-core/latest/reverie/vdso/index.html # [0]
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 Documentation/admin-guide/kernel-parameters.txt |  7 +++++++
 Documentation/userspace-api/mseal.rst           |  9 +++++----
 mm/Kconfig                                      | 15 ++++++++-------
 mm/mseal.c                                      | 12 ++++++++++++
 mm/vma.h                                        |  5 ++++-
 5 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 0b3c140babd9..a72904ebb98d 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4603,6 +4603,13 @@ Kernel parameters
 
 	nomodule	Disable module load
 
+	no_mseal_sys_mappings
+			[KNL,EARLY] With CONFIG_MSEAL_SYSTEM_MAPPINGS, don't
+			seal system mappings such as the vDSO. Sealing them
+			breaks software which moves, unmaps or modifies them,
+			such as CHECKPOINT_RESTORE (CRIU), UML, gVisor and rr.
+			See Documentation/userspace-api/mseal.rst.
+
 	nonmi_ipi	[X86] Disable using NMI IPIs during panic/reboot to
 			shutdown the other cpus.  Instead use the REBOOT_VECTOR
 			irq.
diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
index 060c9829306b..0efdc5469085 100644
--- a/Documentation/userspace-api/mseal.rst
+++ b/Documentation/userspace-api/mseal.rst
@@ -143,12 +143,13 @@ Use cases
 
   If supported by an architecture (CONFIG_ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS),
   the CONFIG_MSEAL_SYSTEM_MAPPINGS seals all system mappings of this
-  architecture.
+  architecture. The ``no_mseal_sys_mappings`` kernel command line parameter
+  turns this off.
 
   WARNING: This feature breaks programs which rely on relocating
-  or unmapping system mappings. Known broken software at the time
-  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
-  this config can't be enabled universally.
+  or unmapping system mappings. Software known to break with it
+  at the time of writing includes CHECKPOINT_RESTORE, UML, gVisor
+  and rr.
 
 When not to use mseal
 =====================
diff --git a/mm/Kconfig b/mm/Kconfig
index 316515589cdb..bb2a60f52c8e 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1359,24 +1359,25 @@ config MSEAL_SYSTEM_MAPPINGS
 	bool "mseal system mappings"
 	depends on 64BIT
 	depends on ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
-	depends on !CHECKPOINT_RESTORE
 	help
 	  Apply mseal on system mappings.
 	  The system mappings includes vdso, vvar, vvar_vclock,
 	  vectors (arm compat-mode), sigpage (arm compat-mode), uprobes,
 	  uprobe trampolines (x86).
 
-	  A 64-bit kernel is required for the memory sealing feature.
-	  No specific hardware features from the CPU are needed.
-
 	  WARNING: This feature breaks programs which rely on relocating
-	  or unmapping system mappings. Known broken software at the time
-	  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
-	  this config can't be enabled universally.
+	  or unmapping system mappings. Software known to break with it
+	  at the time of writing includes CHECKPOINT_RESTORE, UML, gVisor
+	  and rr.
+
+	  With this configuration option set, the feature can be disabled
+	  with the no_mseal_sys_mappings boot parameter.
 
 	  For complete descriptions of memory sealing, please see
 	  Documentation/userspace-api/mseal.rst
 
+	  If unsure, say N.
+
 config HAVE_ARCH_USERFAULTFD_WP
 	bool
 	help
diff --git a/mm/mseal.c b/mm/mseal.c
index 7a8ac66dc215..271b44e628c5 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -7,6 +7,7 @@
  *  Author: Jeff Xu <jeffxu@chromium.org>
  */
 
+#include <linux/init.h>
 #include <linux/mempolicy.h>
 #include <linux/minmax.h>
 #include <linux/mman.h>
@@ -16,6 +17,17 @@
 #include <linux/sched.h>
 #include "internal.h"
 
+#ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
+bool mseal_system_mappings_disabled __ro_after_init;
+
+static int __init early_no_mseal_sys_mappings(char *buf)
+{
+	mseal_system_mappings_disabled = true;
+	return 0;
+}
+early_param("no_mseal_sys_mappings", early_no_mseal_sys_mappings);
+#endif
+
 static bool range_contains_unmapped(unsigned long start, unsigned long end)
 {
 	VMA_ITERATOR(vmi, current->mm, start);
diff --git a/mm/vma.h b/mm/vma.h
index 3982b239d0b4..11ff9c7d6592 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -800,9 +800,12 @@ static inline bool vma_is_sealed(struct vm_area_struct *vma)
 }
 #endif
 
+extern bool mseal_system_mappings_disabled;
+
 static inline bool mseal_system_mappings(void)
 {
-	return IS_ENABLED(CONFIG_MSEAL_SYSTEM_MAPPINGS);
+	return IS_ENABLED(CONFIG_MSEAL_SYSTEM_MAPPINGS) &&
+	       !mseal_system_mappings_disabled;
 }
 
 #if defined(CONFIG_STACK_GROWSUP)
-- 
2.54.0


