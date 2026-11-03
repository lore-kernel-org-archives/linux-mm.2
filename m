Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9950A6071A0E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=DJkpM8/G
Received: by kanga.kvack.org (Postfix)
	id 8DBC66B05CA; Tue,  3 Nov 2026 10:18:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3486B05CB; Tue,  3 Nov 2026 10:18:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A30F6B05CC; Tue,  3 Nov 2026 10:18:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4541C6B05CA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:18:56 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C389A1C3AD6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:55 +0000 (UTC)
X-FDA: 85394165430.03.33DECF4
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id D76E18000E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:18:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="DJkpM8/G";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf02.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793719133;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x+ielrpl05GqbiDgrjkNFqFmUWyU2mlgjjUSLSA7ydE=;
	b=h5VSIm0Twko22CvU62pdAWdUIbX+SSQ9JE11M6enDa9BKL1D49Y/5/5Tv+ARZ/dSKQns2r
	do4MJ5RBpaKiO8nDScd8K8sKdmILOobVTOcXQizdMpYBvJkRIHR/auO8oQksdtGO3cmA8g
	fcYjtt2HymYBxql5Zg2GFQbf5i587js=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=chrisdown.name header.s=google header.b="DJkpM8/G";
	dmarc=pass (policy=quarantine) header.from=chrisdown.name;
	spf=pass (imf02.hostedemail.com: domain of chris@chrisdown.name designates 209.85.214.172 as permitted sender) smtp.mailfrom=chris@chrisdown.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793719133;
	b=5Q4JvBdZbK2TM/4B+d8gZ6oUpWCKEOiUaRpd31gq9wQZg8iI5gND5MtryQfRCMg9cTKc9d
	7uRtoOpOBhEJ9F37u83K7fmV/WumotTi7s+7Eknugh9/wNywMKWcjAOJZDKYOX9mKYwx1X
	NWoY+15jGxTDAhCU3neZWHtDG5VTb4o=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2e60f9af6e6so40255975ad.3
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 07:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1793719133; x=1794323933; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=x+ielrpl05GqbiDgrjkNFqFmUWyU2mlgjjUSLSA7ydE=;
        b=DJkpM8/Giuw6BnOXwVVJReUmhIJR86bDD2+mjv0DmPG26anbIUI1jKDoITmCuFAq6j
         s1lVP1iln5caY6Cnzj9hgobLipo5GQrhlc/pF6oF26F8T0oR8GkVrobQ9IlUmuheYJVr
         cCZ9SHxSYF8S0si09M85cp8EPQ/DnFEp3/TKQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793719133; x=1794323933;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x+ielrpl05GqbiDgrjkNFqFmUWyU2mlgjjUSLSA7ydE=;
        b=INkc2q9TL6VDoDC0o7Siq7M8mPJLsZiXvxzH5ACY6+bJNw5tEs2GQl/Ya3t8Wsc+uL
         F6tEAW5+eTnm4/xoN97ovugj8ZtmA691SF6LliFVF06QUaAJUactkslmy641QGF5+jGv
         WM4+bHAcFwei7z+qhkQ2W9CpUGDioT3z005Zr+QpniUnvm5nYEuq0hosy7AQVx46R0Gw
         lw7ht7zpyFZHX8eLqj8/GFS0I6UyYms+0+n54a+l2szyEHV2D/0M3rxja4RAxwQpnAM3
         jNaacFvlJHasBKL7e5P+vdrAVXf9CLS/CZcjWfuuTAayN/eoYG93EXPImHF6M07a4YYN
         KfRA==
X-Forwarded-Encrypted: i=1; AKwUvBw2UUI8QK6bl1L2JbFVKchYd8cfJFr7zPAwAnLq74abXV8U8HOUWEmbA/ZyGH86jwt8K4HrvvYKMg==@kvack.org
X-Gm-Message-State: APuU4Z8Z5Sa/6GNt/PIXWfSafyEI0R6pC/iASQ/x9K6Hq7l608vXBYdp
	V33Omge+JbuiTzUDbG81lKunFxpx4J3fXu/iQGr6zsaMV8qrQBvZkExaNLAE9Sk49dc=
X-Gm-Gg: AYBFou290goHHvNZGOPiav+TLK7l8Dy0x/1aQ3LrxSU5NmljNKSgBXMoYpTIVx44nbc
	Ohhq+GrHLTZOtrXWDi1OnJMVfcMmlTmnyYiTEjT33YIQ6K7sFDzMd1KdVXECkRWxs2+40UyzZXJ
	6f0e0jAYMHPgBauSceYCDQjE3kivYSLd/MhrYBXpJZK6KLtaIk+04zMokkZ6SBsisdlGuP6clKL
	G3TNvzaIqFGXkcZn+MaPp/qp5UZT6QmfoEYmfSJ0SAV21Zzc9Rm/CROjw+tO0o0LLrhiK3kh4tZ
	EYxU5eQ2q3kaw5cC6dhNreWIicxMfpA9Qniq98S3Lo4qJ7Y5igmf4mqVTnODGBIBS1a9eu/Iq+x
	qZDB2FQXPbNBmcYsh0Eb2VfEoHdw30ZC5m8p2DfuWHZ55gb0l62Tc/7//dGF3WqPosEmxZpfepP
	kNTsngwmWzsJEflB3yEQiRAwj1qk8IfFbDgifKlJH93Erc2JGaoxZF52gOHaa7jq7YxuU2z2fPW
	xX02qyrVTaV7M16nvxgYJYCo0F4aLKIwLCplQS6WdFl0EIgNr4bKurbMmXgbXVJGxBopigtbG0Y
	oeu7OWmQPd5PsSfXCWlGkH9QL69MrpzGtt4mw8vxQxbbAMEYWtLFa11kBkPOzgYzyJA6joCPwP0
	B1bR9TJ2rrco199ycBi8+stCRKVkyhCEgyNzD47ghaJykdUn++KxDsZHQrSCr44/OHGMfyQ52li
	dqK0/3z7+PGZSNQcnGzQ==
X-Received: by 2002:a17:903:1b26:b0:2eb:1e07:adc5 with SMTP id d9443c01a7336-2eb364026e5mr130622425ad.2.1793719132693;
        Tue, 03 Nov 2026 07:18:52 -0800 (PST)
Received: from localhost ([116.86.153.182])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eb39266b84sm43036115ad.43.2026.11.03.07.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 07:18:48 -0800 (PST)
Date: Tue, 3 Nov 2026 23:18:45 +0800
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
Subject: [PATCH v2 6/8] mm/mseal: Seal system mappings in
 __install_special_mapping()
Message-ID: <74ead8d457288df215405298e213246ef6a1ce68.1793718940.git.chris@chrisdown.name>
References: <cover.1793718940.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1793718940.git.chris@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D76E18000E
X-Stat-Signature: zg61iuhhdrbujnhqwwqdi5d7h44pzcar
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793719133-318599
X-HE-Meta: U2FsdGVkX1895HTznDpoZgUo2SCJnjlV1ozfyxaCVkMrqoq8KA4BtPmShh7g052PA3/XZefe9AMCOssgRbNuJFF1G4d4hnFylwjnjt7+7cfsZ/IMGZBPwUNnXDaGGEiA3kFfkiFN1KSJmVqIDF/XwgFTwkdecO/O6XcJ3RGB5ZOpOPybGJe0jhCOOFxk5jz2sLNyys3JWg0CJwXysViBnGrK5h7qSIOza97B1sGihlXzsfc1/ZLVvpsCTGyQ/sj1d3ojpYmTM6g4WOLSajLsSnLHJKkwj1ZgNV7xn9Cmf3tzbchHPOquQ5cx8KAkdvuJuejkcGZm9fuGHPuNC12QfMeZoGmWkfALCBvNdlSZdYhRQibBiXBjWSILonh7ytiha0BYZlMe0S/DPnCFuabXH40p4SEyjxdoi9q5IM0TcNeXM9z/L6d9xLUEs9ULr6Kxal6CvfiV0603qWzR6VhkdIe0mp4TxOhpQgR+syBfDdRT/4uS0jsk/DydRDor0W2IDSTEcdnNvhuQuikHXZI/lGr+jcpCsl6vNSQE/0ex8yIi48Sp1cKMlWNoZOYFnIgiB0rjGhFQ83f57yLL6uczy1Ewiwe2dYwN6xnFQTHcAz/pHIvU2f2ICRAnkG0FxJ7LnEzYCw1sjyWwU7Ew9ZhrauiVGRuQb8CfoFJdUa08q7iI6BCB9xgJNcTcvGfw9utxMERXIYYaTim9Jd4DtkXfjoqJeTaQQobtDJ0z9RwbAm2jZiu8YEdm5wcFAlz62zZXT+ZsqTnMEC8WaBSzMjGd9Zo8rP5wjUjeoZZptdgKARvIaRljgmXtjn/ckEvUSjrEAG3Ynll+1chZ2poGBJQvvRdz/1/t+HjGbWlTMmv12GbfUZ+zKoXJ0Fso2wzNYgKHDGPbAugt643HU5herJm0KHwoLRIKsfKsxIXcv6KP1Kh1sZhM/0bEetNoS+av5cgv+c+C24kMXcYQGrySpHX
 M1X3oVHm
 G+1jKYCmvatg+kTZoEW+zmt2YOWa+rhAmCfN64rHxKqSC353ACcfVrk4KnxoWf8/RQygF65sonQprA0kAiSjz1sLAfoFMVgNaa9OPlEWoH7S5W++Amd2gw6Lpk5pgDD4uUC0gGlRYO6isOkN6ZP/ME+yNxi37MoKl6B69PyeTa1eFnGi+PJ8OwaAGk5jBPpsz9UunoprdviOt3C9buD60FpqMyGSyUTHCoBWfoLFlybo28Mzvm+ZX5cfLHd7tgNvE+I5sVLfLx9A3mhEMEEzkZe3HYN6WKUmn2UbmbpJWiy8ycxAAagDUXSRXCEZdOye26yInaDRn6p5p3hbCG4F93q1JdjEygfWkuOVEEoC+w5N1+uCrwti1jEJnAWr675GjDqwLszcfvT+OkjaMVmRnNu8+0Ryz9kVBU7y0UZXuv6brc2WTcqwY2GPn1glrg120agRp5T08eYMlMzftN1/TQ+d7Vs3ouVMtcQuC2UcOoYR66ok5GsIDc50sIN9wMDVdwYvUoOpgs9BsDPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VM_SEALED_SYSMAP isn't really a VMA flag, it's an alias for VM_SEALED or
VM_NONE depending on CONFIG_MSEAL_SYSTEM_MAPPINGS. Every caller of
_install_special_mapping() on an architecture which supports sealing
system mappings has to remember to pass it, and it keeps those callers
on the legacy vm_flags_t API.

Let's instead have __install_special_mapping() seal the mapping itself
when mseal_system_mappings() says so, and remove VM_SEALED_SYSMAP.

The only special mapping on these architectures which didn't already
pass VM_SEALED_SYSMAP is the x86 uprobe trampoline, which is now sealed
as well. The previous patch makes sure that's safe.

Since this seals all special mappings, the architecture opt-in now
requires that none of them are moved or unmapped.

Signed-off-by: Chris Down <chris@chrisdown.name>
---
 Documentation/userspace-api/mseal.rst | 3 ++-
 arch/arm64/kernel/vdso.c              | 9 +++------
 arch/loongarch/kernel/vdso.c          | 3 +--
 arch/riscv/kernel/vdso.c              | 2 +-
 arch/s390/kernel/vdso.c               | 2 +-
 arch/x86/entry/vdso/vma.c             | 5 ++---
 include/linux/mm.h                    | 6 ------
 init/Kconfig                          | 5 ++---
 kernel/events/uprobes.c               | 2 +-
 lib/vdso/datastore.c                  | 2 +-
 mm/Kconfig                            | 3 ++-
 mm/vma.c                              | 2 ++
 mm/vma.h                              | 5 +++++
 13 files changed, 23 insertions(+), 26 deletions(-)

diff --git a/Documentation/userspace-api/mseal.rst b/Documentation/userspace-api/mseal.rst
index c039d782f9f5..060c9829306b 100644
--- a/Documentation/userspace-api/mseal.rst
+++ b/Documentation/userspace-api/mseal.rst
@@ -133,7 +133,8 @@ Use cases
 
 - System mappings:
   The system mappings are created by the kernel and include vdso, vvar,
-  vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
+  vvar_vclock, vectors (arm compat-mode), sigpage (arm compat-mode), uprobes,
+  uprobe trampolines (x86).
 
   Those system mappings are readonly only or execute only, memory sealing can
   protect them from ever changing to writable or unmapped/remapped as different
diff --git a/arch/arm64/kernel/vdso.c b/arch/arm64/kernel/vdso.c
index 50596dab23f9..542adc47cd02 100644
--- a/arch/arm64/kernel/vdso.c
+++ b/arch/arm64/kernel/vdso.c
@@ -127,8 +127,7 @@ static int __setup_additional_pages(enum vdso_abi abi,
 	mm->context.vdso = (void *)vdso_base;
 	ret = _install_special_mapping(mm, vdso_base, vdso_text_len,
 				       VM_READ|VM_EXEC|gp_flags|
-				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				       VM_SEALED_SYSMAP,
+				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				       vdso_info[abi].cm);
 	if (IS_ERR(ret))
 		goto up_fail;
@@ -254,8 +253,7 @@ static int aarch32_kuser_helpers_setup(struct mm_struct *mm)
 	 */
 	ret = _install_special_mapping(mm, AARCH32_VECTORS_BASE, PAGE_SIZE,
 				       VM_READ | VM_EXEC |
-				       VM_MAYREAD | VM_MAYEXEC |
-				       VM_SEALED_SYSMAP,
+				       VM_MAYREAD | VM_MAYEXEC,
 				       &aarch32_vdso_maps[AA32_MAP_VECTORS]);
 
 	return PTR_ERR_OR_ZERO(ret);
@@ -278,8 +276,7 @@ static int aarch32_sigreturn_setup(struct mm_struct *mm)
 	 */
 	ret = _install_special_mapping(mm, addr, PAGE_SIZE,
 				       VM_READ | VM_EXEC | VM_MAYREAD |
-				       VM_MAYWRITE | VM_MAYEXEC |
-				       VM_SEALED_SYSMAP,
+				       VM_MAYWRITE | VM_MAYEXEC,
 				       &aarch32_vdso_maps[AA32_MAP_SIGPAGE]);
 	if (IS_ERR(ret))
 		goto out;
diff --git a/arch/loongarch/kernel/vdso.c b/arch/loongarch/kernel/vdso.c
index 1edc8fb720de..c9ffc124bfb1 100644
--- a/arch/loongarch/kernel/vdso.c
+++ b/arch/loongarch/kernel/vdso.c
@@ -109,8 +109,7 @@ int arch_setup_additional_pages(struct linux_binprm *bprm, int uses_interp)
 	vdso_addr = data_addr + VVAR_SIZE;
 	vma = _install_special_mapping(mm, vdso_addr, info->size,
 				       VM_READ | VM_EXEC |
-				       VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC |
-				       VM_SEALED_SYSMAP,
+				       VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC,
 				       &info->code_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index 5666cec180ac..4213de6afb9a 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -140,7 +140,7 @@ static int __setup_additional_pages(struct mm_struct *mm,
 
 	ret =
 	   _install_special_mapping(mm, vdso_base, vdso_text_len,
-		(VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC | VM_SEALED_SYSMAP),
+		(VM_READ | VM_EXEC | VM_MAYREAD | VM_MAYWRITE | VM_MAYEXEC),
 		vdso_info->cm);
 
 	if (IS_ERR(ret))
diff --git a/arch/s390/kernel/vdso.c b/arch/s390/kernel/vdso.c
index a905f989f910..a9dd3876e7fd 100644
--- a/arch/s390/kernel/vdso.c
+++ b/arch/s390/kernel/vdso.c
@@ -65,7 +65,7 @@ static int map_vdso(unsigned long addr, unsigned long vdso_mapping_len)
 	vdso_text_start = vvar_start + VDSO_NR_PAGES * PAGE_SIZE;
 	/* VM_MAYWRITE for COW so gdb can set breakpoints */
 	vma = _install_special_mapping(mm, vdso_text_start, vdso_text_len,
-				       VM_READ|VM_EXEC|VM_SEALED_SYSMAP|
+				       VM_READ|VM_EXEC|
 				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				       &vdso_mapping);
 	if (IS_ERR(vma)) {
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 4bd3b22beea9..e49d4e4d7b67 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -178,8 +178,7 @@ static int map_vdso(const struct vdso_image *image, unsigned long addr)
 				       text_start,
 				       image->size,
 				       VM_READ|VM_EXEC|
-				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC|
-				       VM_SEALED_SYSMAP,
+				       VM_MAYREAD|VM_MAYWRITE|VM_MAYEXEC,
 				       &vdso_mapping);
 
 	if (IS_ERR(vma)) {
@@ -198,7 +197,7 @@ static int map_vdso(const struct vdso_image *image, unsigned long addr)
 				       VDSO_VCLOCK_PAGES_START(addr),
 				       VDSO_NR_VCLOCK_PAGES * PAGE_SIZE,
 				       VM_READ|VM_MAYREAD|VM_IO|VM_DONTDUMP|
-				       VM_PFNMAP|VM_SEALED_SYSMAP,
+				       VM_PFNMAP,
 				       &vvar_vclock_mapping);
 
 	if (IS_ERR(vma)) {
diff --git a/include/linux/mm.h b/include/linux/mm.h
index d89e6f823c9f..09c047dc9faf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -567,12 +567,6 @@ enum {
 /* Temporary until VMA flags conversion complete. */
 #define VM_STACK_FLAGS vma_flags_to_legacy(VMA_STACK_FLAGS)
 
-#ifdef CONFIG_MSEAL_SYSTEM_MAPPINGS
-#define VM_SEALED_SYSMAP	VM_SEALED
-#else
-#define VM_SEALED_SYSMAP	VM_NONE
-#endif
-
 /* VMA basic access permission flags */
 #define VM_ACCESS_FLAGS (VM_READ | VM_WRITE | VM_EXEC)
 #define VMA_ACCESS_FLAGS mk_vma_flags(VMA_READ_BIT, VMA_WRITE_BIT, VMA_EXEC_BIT)
diff --git a/init/Kconfig b/init/Kconfig
index 4013781e0a02..35d349cff1a3 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1955,9 +1955,8 @@ config ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS
 	  A 64-bit kernel is required for the memory sealing feature.
 	  No specific hardware features from the CPU are needed.
 
-	  To enable this feature, the architecture needs to update their
-	  special mappings calls to include the sealing flag and confirm
-	  that it doesn't unmap/remap system mappings during the life
+	  To enable this feature, the architecture needs to confirm that it
+	  doesn't unmap/remap any of its special mappings during the life
 	  time of the process. The existence of this flag for an architecture
 	  implies that it does not require the remapping of the system
 	  mappings during process lifetime, so sealing these mappings is safe
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index caf444762a27..2290a4cbebf8 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -1727,7 +1727,7 @@ static int xol_add_vma(struct mm_struct *mm, struct xol_area *area)
 
 	vma = _install_special_mapping(mm, area->vaddr, PAGE_SIZE,
 				VM_EXEC|VM_MAYEXEC|VM_DONTCOPY|
-				VM_MIXEDMAP|VM_SEALED_SYSMAP,
+				VM_MIXEDMAP,
 				&xol_mapping);
 	if (IS_ERR(vma)) {
 		ret = PTR_ERR(vma);
diff --git a/lib/vdso/datastore.c b/lib/vdso/datastore.c
index 1426bf4e0c12..e8933ff44aa4 100644
--- a/lib/vdso/datastore.c
+++ b/lib/vdso/datastore.c
@@ -124,6 +124,6 @@ struct vm_area_struct *vdso_install_vvar_mapping(struct mm_struct *mm, unsigned
 {
 	return _install_special_mapping(mm, addr, VDSO_NR_PAGES * PAGE_SIZE,
 					VM_READ | VM_MAYREAD | VM_DONTDUMP |
-					VM_MIXEDMAP | VM_SEALED_SYSMAP,
+					VM_MIXEDMAP,
 					&vdso_vvar_mapping);
 }
diff --git a/mm/Kconfig b/mm/Kconfig
index 40172787dfa7..316515589cdb 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1363,7 +1363,8 @@ config MSEAL_SYSTEM_MAPPINGS
 	help
 	  Apply mseal on system mappings.
 	  The system mappings includes vdso, vvar, vvar_vclock,
-	  vectors (arm compat-mode), sigpage (arm compat-mode), uprobes.
+	  vectors (arm compat-mode), sigpage (arm compat-mode), uprobes,
+	  uprobe trampolines (x86).
 
 	  A 64-bit kernel is required for the memory sealing feature.
 	  No specific hardware features from the CPU are needed.
diff --git a/mm/vma.c b/mm/vma.c
index 423383d59c59..67116be0260a 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3705,6 +3705,8 @@ struct vm_area_struct *__install_special_mapping(
 
 	vma_flags_set_mask(&vma_flags, mm->def_vma_flags);
 	vma_flags_set(&vma_flags, VMA_DONTEXPAND_BIT);
+	if (mseal_system_mappings())
+		vma_flags_set(&vma_flags, VMA_SEALED_BIT);
 	if (pgtable_supports_soft_dirty())
 		vma_flags_set(&vma_flags, VMA_SOFTDIRTY_BIT);
 	vma_flags_clear_mask(&vma_flags, VMA_LOCKED_MASK);
diff --git a/mm/vma.h b/mm/vma.h
index 3fc3b47a954b..3982b239d0b4 100644
--- a/mm/vma.h
+++ b/mm/vma.h
@@ -800,6 +800,11 @@ static inline bool vma_is_sealed(struct vm_area_struct *vma)
 }
 #endif
 
+static inline bool mseal_system_mappings(void)
+{
+	return IS_ENABLED(CONFIG_MSEAL_SYSTEM_MAPPINGS);
+}
+
 #if defined(CONFIG_STACK_GROWSUP)
 int expand_upwards(struct vm_area_struct *vma, unsigned long address);
 #endif
-- 
2.54.0


