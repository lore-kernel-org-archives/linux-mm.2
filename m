Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03E44CCFA1E
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 08:06:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CB68E0006; Sat,  8 Nov 2025 03:06:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FD748E0003; Sat,  8 Nov 2025 03:06:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C5B08E0006; Sat,  8 Nov 2025 03:06:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F30C08E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 03:05:59 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9376D1606CA
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 08:05:59 +0000 (UTC)
X-FDA: 84086706438.22.8536A83
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9C2A240010
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 08:05:57 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M8XbMmUn;
	spf=pass (imf11.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762589157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hjmnnaJ+dU4QzslBxUrlmdhSXDXCpeTGjd28jp/dBEQ=;
	b=tShu8sqV06Ct3hcWs7Vnp3HN8/tXpFc9NE/t9duYzpAFUBzWT9ny3EmzJnQ+ryNe84qB5u
	Rwq4e9+O2jJBu/DxTfBhI3N6jIikSWAZ34XUBZfLWCkd7kCVuYyBjEr3tYmswUSEFlGy3l
	2QJTGSN/0i3GRpZyEbn/Qy9HZB8977o=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=M8XbMmUn;
	spf=pass (imf11.hostedemail.com: domain of thehajime@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=thehajime@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762589157; a=rsa-sha256;
	cv=none;
	b=nzz2AC8QatVH0lqgTi4n9sIAltd1Vmb/8N6++cr0VjGaC8DbybtZMCjYLNrp9GLo/rk72I
	zDmX4kWNA1PuFR0ER5c2+ZJcyjG3TEhmhIl/8blbgtfvtEKEmj6lIr9VR1BazuwNxoqt4k
	dH/xgLAFd+r9qV2A0V0Vln2I/JVj/hY=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-297dd95ffe4so7793865ad.3
        for <linux-mm@kvack.org>; Sat, 08 Nov 2025 00:05:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762589156; x=1763193956; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjmnnaJ+dU4QzslBxUrlmdhSXDXCpeTGjd28jp/dBEQ=;
        b=M8XbMmUnsmpaDVeyMIVBXgojM4BoFtEq38cBfUgQ3ZhH+F8qJt7Xc10ZYAnaOhWOli
         PVDYKuRACo1goKm5aPDTtKZc2dAq28MmjKyPyNV6k6HIOiyZrkAfZTZi6BhI35gErQL+
         /WxxfdEWWTkFplz5OgdPfnFqmEr+e0ULD/jhr+qcbSZPNNZmnFw08tZZ/b+xEZS4Bjmh
         ShmT6GTq61UZiiPrVfb9BdyEJLpCtSFjP0qpHqFBoDxwRYxy5Po+SWw7wPxEjxx1CoU5
         Q6WMDZj4AHHbUjQUaesdna98PG/OYVhoE6hlbTKkPrbZ/vMFFTijFXDAVj2v+/5RUwE0
         jYMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762589156; x=1763193956;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hjmnnaJ+dU4QzslBxUrlmdhSXDXCpeTGjd28jp/dBEQ=;
        b=gDQpI3OcIorExeklWFlFPS6G0I9Y6B9hj8bngDWQKdvOcAQY2fr7GDuI5eSvXNjhQZ
         tUqogr9zbcolKeWecDyZi0XI9KIsalETm7/etmufnzN87JxGpl1mh0xkwl/WGmjJ5Ap2
         1y2MgfVWaPnlbQkFiQ6wp/gZ4Ybmz8lq4soRUSJbqoonUb5nZkKaSwP5DyGyjwAiLsFO
         wbIA5GutF7okhNPfNJrpaj6RUDhqeHVmIykVsGB05dCiDXeZ09C5yOO00TYfsQzTgSPE
         4zR5KGdG9Xz420ytR8O57lpbS9a8QhWj6oIJbC9fw9fPaXTdW4jYlUpbmf8U7sMlr4hg
         LpRg==
X-Forwarded-Encrypted: i=1; AJvYcCULpxmRMcgvXfTksmB6zxrQNgkehfzBge+WOmSsnuo5tFnREjt7LsEyJtgi9YypK5uuoXTxq+aOHg==@kvack.org
X-Gm-Message-State: AOJu0YzuvaSp05AyVl2EZLrl4RyhsoFNkHLI+kRuoCIdtWMUr/Z8YdGZ
	hvOKM1BQ7wyzjhkaRJjeCwxm6GTLhMHSDsbkEP9vsLGdmk3tuy5x7o2N
X-Gm-Gg: ASbGncvjqw/3d1EfGwK+GUy2toTiDZv79E03T0inUDvCCPp0F6HXy8sJ1pCP2W3jnpa
	pljBa0RVEnMkFKeicd1ji36dt70KnbiVGHszZCCAaJtEs3RgiLRj5+kxj9HPOc7OgZMV136zKAr
	QNTWvuP8BFN9hYDePjhkBUzxYxjZp5DoFOfptWME+MN6xuNcaVL8fP06Bmfpmq7gcz9qYjQUSqw
	BjjcvAMqHQvLeMgiu71u3ZFy0v9W4EXS7pO3dK1b36OMhgbq5KspgFzC0GbtpcqObJnCI1k8L04
	uNJ3TjVWFe30BXsp9GFARX6HIA6TlLzLUJGpBhkQVEsePGOXP5kMNCuQxYeSgG318ArOe9SwMXO
	Pu7GbCsv+IhvMa2rzmlUa3YIA3EpX37MKtv7xH34MrfSX3Y+UBbFNkgiDhd/MKJTPuLO0tQoyU9
	dMdk2n8FI4bg3Z6fSOt0hc/DaK2YCn5h2AYtF0bmuVu7cVndePo0IUFG6k7H1y7HiB7/Y=
X-Google-Smtp-Source: AGHT+IFNIgTTAZ2Vl2vkAxBvJV+q8EYjnppJ5K0pIHpzL9Ue02aCEVYgWqO6SIqSBUirhrY7QzbLaw==
X-Received: by 2002:a17:903:ac6:b0:295:269d:87cf with SMTP id d9443c01a7336-297e5619d74mr21459175ad.5.1762589156346;
        Sat, 08 Nov 2025 00:05:56 -0800 (PST)
Received: from ikb-h07-29-noble.in.iijlab.net ([202.214.97.5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096b801sm83340945ad.7.2025.11.08.00.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Nov 2025 00:05:55 -0800 (PST)
Received: by ikb-h07-29-noble.in.iijlab.net (Postfix, from userid 1010)
	id 0019311388C7; Sat,  8 Nov 2025 17:05:53 +0900 (JST)
From: Hajime Tazaki <thehajime@gmail.com>
To: linux-um@lists.infradead.org
Cc: thehajime@gmail.com,
	ricarkol@google.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	Eric Biederman <ebiederm@xmission.com>,
	Kees Cook <kees@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v13 01/13] x86/um: nommu: elf loader for fdpic
Date: Sat,  8 Nov 2025 17:05:36 +0900
Message-ID: <59210140957e95ab0df73125bfdb035913a468b1.1762588860.git.thehajime@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1762588860.git.thehajime@gmail.com>
References: <cover.1762588860.git.thehajime@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9C2A240010
X-Stat-Signature: onzmjjgbjsyi9es476ykxm5w37q9en49
X-Rspam-User: 
X-HE-Tag: 1762589157-86698
X-HE-Meta: U2FsdGVkX1/KxOutsyXTPKtdQxycnzGrZkAzLBSeOJPmWZfemkoGfFeGCwloGXIQHf5Jt4+b7fa6rkM3FYCtGa6ttTtzlxAQgZCUPLRXawg1SnujA5tDiKf2A4PHYn3Ae9wfz2ICyEt864B/0rOISzS1iwF1zXJZiz9ustZ/phHXNQ4e0bSVbjZxtj+RN7jgSk6ghpyj63MXInYrh6dIMzSTDqlnAhTeJpIMyS+VRANL9jh03RFTHESOTMz18EmQ6UiU8TpODudRB3g2f75jgUKuxKDSWYGxzwr7eVnuXFMd87mXLwuvzpjY6/807h1+FgnOVRBQ/BbIkYkiy2le8kRLTV78AyrOeS4TLICZCk/hviyJGj9dK41dRU+iaA5VAN8Q6D0XTXA+8P7xmOI3XDickmS1L0VamIjov/4h9iPbDvI0OLU86XFFpXy/gszJ6imcIHVeO0I2e3Z75e6M4sHSaL+Q5wP553sCUYKKSPy8zVSfGonbDAshNni+YCwIAOH6OOOPhcR1f0XK6hwgPjztSEKzI43tE0YKCPqvoyvYb5WGphPGVPJSLjYf2fmg3eUzVkE/RuQv4Uwhri/WaQ0wmM/TMTRQGpyo1YZf84DKxbOQhDzBYEiYSX/AZzdqv8ipJcU+Mg2MHZE5lRWsHWx/wg3rrbuuD9mdOH4KKtOdQy2vdNvP4Dncsbro8PQDEO0mhSSJ6qv7+B01FABn4W2bVsnyQ/MA8pWH8ioB49Leqnjd843RR0DxBHtdyY+54R0WjcY3JDe8nVfhEoNLilq0C4/kNA2k+rtsE0mvr5Z367r5KHUvjGx9JJ5UWdDklgaPgUm2LR9Es5ut+SKV0+Urkfdzn0C3kCbAxfWBEaj7SZdeWN7AmGCzmS2jiEPG81ofKZPbptJ7my8qJmi58PtrbkHwcjWuC5HLYlLAXthsOd3k5Wcv6C2LfaYb+OPJpRpSmM2VdnjlOfM1epP
 +JtwUBzJ
 Ty9PsmbRo9GpuXQZgHe26Zp+dlLtdRoUsve9veChn+nCWUqCy8XR8ElBCPYU7DrpoMyTeZao9q9gF+T2p8NfoXTtisuEPRIaX10dNH6jVfYDl44A7yQ0EV50n6lau235bS3fyiyxAd17Ory38DY7phv6D+7lu62CTyD5eXTFjiEaYDGe3BGTlIMXhdybJOsjiSJSyr+xv7bNA0WsopBAwhCeV6SvKNHtGCSdyjoKd1RUn0dJzZ01PiYF0A/vVLZSesbnqHzOCgkPlf0zMpH+xUWvzxm4seABE4adEY9qPeA701qJzKMMIKQ26P4OaUlKlX7kjFrelRLOpWc742uGGIi4zyxXYd2VFheNzfSt77UXOXMb8q6kBOJSAIDmQe0dfzq0d8C0aDHvvEJUi7Ek9gKPdbM0Ehk28jUGShtww2rbw2XIhofHqpwc9v28qHYJ4i8mVKMg+tZRwLxJYvKSO+0Sakf5gAc2VzWklMjPQqvx/eWB2I7ghi0bJo6dBHuQCNwd+ctuCGmeqzZ4+1Hukd6nLbLUtRsQF9kvCQ08WwJvzYcLwk+sSi4gVn8F0JSOg0u/FyzAINxHvy728Ikd9IZYKi+pny0aAc41jb2xPnrzaS5lquQ/JihS+82iJ6tIkVi621gfMPsyzAKU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As UML supports CONFIG_MMU=n case, it has to use an alternate ELF
loader, FDPIC ELF loader.  In this commit, we added necessary
definitions in the arch, as UML has not been used so far.  It also
updates Kconfig file to use BINFMT_ELF_FDPIC under !MMU environment.

Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Kees Cook <kees@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org
Acked-by: Kees Cook <kees@kernel.org>
Signed-off-by: Hajime Tazaki <thehajime@gmail.com>
Signed-off-by: Ricardo Koller <ricarkol@google.com>
---
 arch/um/include/asm/mmu.h            | 5 +++++
 arch/um/include/asm/ptrace-generic.h | 6 ++++++
 arch/x86/um/asm/elf.h                | 8 ++++++--
 fs/Kconfig.binfmt                    | 2 +-
 4 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/arch/um/include/asm/mmu.h b/arch/um/include/asm/mmu.h
index 07d48738b402..82a919132aff 100644
--- a/arch/um/include/asm/mmu.h
+++ b/arch/um/include/asm/mmu.h
@@ -21,6 +21,11 @@ typedef struct mm_context {
 	spinlock_t sync_tlb_lock;
 	unsigned long sync_tlb_range_from;
 	unsigned long sync_tlb_range_to;
+
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+	unsigned long   exec_fdpic_loadmap;
+	unsigned long   interp_fdpic_loadmap;
+#endif
 } mm_context_t;
 
 #define INIT_MM_CONTEXT(mm)						\
diff --git a/arch/um/include/asm/ptrace-generic.h b/arch/um/include/asm/ptrace-generic.h
index 86d74f9d33cf..62e9916078ec 100644
--- a/arch/um/include/asm/ptrace-generic.h
+++ b/arch/um/include/asm/ptrace-generic.h
@@ -29,6 +29,12 @@ struct pt_regs {
 
 #define PTRACE_OLDSETOPTIONS 21
 
+#ifdef CONFIG_BINFMT_ELF_FDPIC
+#define PTRACE_GETFDPIC		31
+#define PTRACE_GETFDPIC_EXEC	0
+#define PTRACE_GETFDPIC_INTERP	1
+#endif
+
 struct task_struct;
 
 extern long subarch_ptrace(struct task_struct *child, long request,
diff --git a/arch/x86/um/asm/elf.h b/arch/x86/um/asm/elf.h
index 22d0111b543b..388fe669886c 100644
--- a/arch/x86/um/asm/elf.h
+++ b/arch/x86/um/asm/elf.h
@@ -9,6 +9,7 @@
 #include <skas.h>
 
 #define CORE_DUMP_USE_REGSET
+#define ELF_FDPIC_CORE_EFLAGS  0
 
 #ifdef CONFIG_X86_32
 
@@ -158,8 +159,11 @@ extern int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 extern unsigned long um_vdso_addr;
 #define AT_SYSINFO_EHDR 33
-#define ARCH_DLINFO	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr)
-
+#define ARCH_DLINFO						\
+do {								\
+	NEW_AUX_ENT(AT_SYSINFO_EHDR, um_vdso_addr);		\
+	NEW_AUX_ENT(AT_MINSIGSTKSZ, 0);			\
+} while (0)
 #endif
 
 typedef unsigned long elf_greg_t;
diff --git a/fs/Kconfig.binfmt b/fs/Kconfig.binfmt
index 1949e25c7741..0a92bebd5f75 100644
--- a/fs/Kconfig.binfmt
+++ b/fs/Kconfig.binfmt
@@ -58,7 +58,7 @@ config ARCH_USE_GNU_PROPERTY
 config BINFMT_ELF_FDPIC
 	bool "Kernel support for FDPIC ELF binaries"
 	default y if !BINFMT_ELF
-	depends on ARM || ((M68K || RISCV || SUPERH || XTENSA) && !MMU)
+	depends on ARM || ((M68K || RISCV || SUPERH || UML || XTENSA) && !MMU)
 	select ELFCORE
 	help
 	  ELF FDPIC binaries are based on ELF, but allow the individual load
-- 
2.43.0


