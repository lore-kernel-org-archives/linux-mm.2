Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4873EC87FCB
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 05:45:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9320F8E00D3; Tue, 12 Aug 2025 01:44:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB2D8E00BE; Tue, 12 Aug 2025 01:44:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75C968E00D3; Tue, 12 Aug 2025 01:44:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5AB6E8E00BE
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 01:44:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 30271B6B6D
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:47 +0000 (UTC)
X-FDA: 83767016214.09.E5D6240
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf29.hostedemail.com (Postfix) with ESMTP id 58A50120011
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 05:44:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eDOLCLFD;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=x8u4rxPi;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754977485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BSsLaj0Vhu9/PGMTmPXGdssJTXVn3W9ZA9BGqH+Jqx4=;
	b=0rjTv3M0FBWq1qnS3zuKltJ+SsZZF/2s66rRmH52lANwAD0Y0gE+l2ENT5f/gRv5oPivO0
	BvNbKAGV93i3USbBp8qoWPdQWe/Mtl6Qv0Je1GCE+iOGu5PdibL7wXODK5bZkM5c0fNyu5
	bIiA29uyQMeJWmLC1djnoZ8SdyXylPQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754977485; a=rsa-sha256;
	cv=none;
	b=nVsI+c/KDYBRPs0uQERbvto+tRcpejUOngfXsQRSQpbnp2waDfN9uSFUBQ5A7gIDXhI85G
	6AeWhpQ84kWgT9S8PG2LqetjfRo5qinZ15cbF1Ck/mfnjdpcE3/c8de5HVI6iUxT6Ln3je
	BneWaMKlKIgPLaBLQbkbWeP50a47xtQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=eDOLCLFD;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=x8u4rxPi;
	dmarc=pass (policy=none) header.from=linutronix.de;
	spf=pass (imf29.hostedemail.com: domain of t-8ch@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=t-8ch@linutronix.de
From: =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1754977477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSsLaj0Vhu9/PGMTmPXGdssJTXVn3W9ZA9BGqH+Jqx4=;
	b=eDOLCLFDPRbYYV6S9jLoySaVAu3Me/4SS95J0pa44QzQju1lVdvjVQb0NHn26GgiKzsdo0
	la6VnrTn3Ck0BTNHV6iPzgVSMcM+D0zEUl6vIHzxvac1IhKbgdrENmV4kvNogwCDIi9bUc
	6NLSPM+lX/mzQgqWdYfgFCIaVbyuAVg9fXpU/8xhY6vP+6L/k7HV27ig2A37biQWg7w8ix
	r22eKq9Rr8f+6bN2DMXyuLJK6jRyLg2KwjU7bpH/2t/nkFxU+VPhqpYVJXC6AZK4UecCPQ
	yLI5tse76hfyElSeWwb5NV3HG2g/+z2gvs4FmkDYEzX/DdmDG0K9iSN0HH4iNw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1754977477;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BSsLaj0Vhu9/PGMTmPXGdssJTXVn3W9ZA9BGqH+Jqx4=;
	b=x8u4rxPiqX9dOvWWfSpG/Ujml/DOO844CEKhLv/WuFCx5Vk6KLOOdTUqW25zFxXj1eXLob
	cNpDxW8Y1VxhSEDw==
Date: Tue, 12 Aug 2025 07:44:26 +0200
Subject: [PATCH v4 13/24] ARM: vdso: Enable the vdsocheck tool
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20250812-vdso-absolute-reloc-v4-13-61a8b615e5ec@linutronix.de>
References: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
In-Reply-To: <20250812-vdso-absolute-reloc-v4-0-61a8b615e5ec@linutronix.de>
To: Paul Walmsley <paul.walmsley@sifive.com>, 
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
 Alexandre Ghiti <alex@ghiti.fr>, Nathan Chancellor <nathan@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 Andy Lutomirski <luto@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, Kees Cook <kees@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
 "H. Peter Anvin" <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Russell King <linux@armlinux.org.uk>, 
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Christophe Leroy <christophe.leroy@csgroup.eu>, 
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>, 
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
 Alexander Gordeev <agordeev@linux.ibm.com>, 
 Christian Borntraeger <borntraeger@linux.ibm.com>, 
 Sven Schnelle <svens@linux.ibm.com>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>, 
 Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, 
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, 
 Danilo Krummrich <dakr@kernel.org>, 
 Nicolas Schier <nicolas.schier@linux.dev>
Cc: linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org, 
 llvm@lists.linux.dev, linux-mm@kvack.org, linux-um@lists.infradead.org, 
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org, 
 loongarch@lists.linux.dev, linux-s390@vger.kernel.org, 
 linux-mips@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-kbuild@vger.kernel.org, Jan Stancek <jstancek@redhat.com>, 
 Arnaldo Carvalho de Melo <acme@redhat.com>, 
 Alexandre Ghiti <alexghiti@rivosinc.com>, 
 =?utf-8?q?Thomas_Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>
X-Developer-Signature: v=1; a=ed25519-sha256; t=1754977469; l=2638;
 i=thomas.weissschuh@linutronix.de; s=20240209; h=from:subject:message-id;
 bh=qygA/StJzW73SS+Ekq7PC7CyPNI3mc4mEN9yJxXb3XY=;
 b=T+Y3ba3sPD8SH63yLbLTW2WkOy2PgtViR8rWIZYQ/4UjtoPlEd+0f2LNjX0dkYHy33nz3NhFa
 fZMmsLbItu4Bl44kkc4ojPXchIFcJeEzvChFGVZh7EzamhWR3UCQS7W
X-Developer-Key: i=thomas.weissschuh@linutronix.de; a=ed25519;
 pk=pfvxvpFUDJV2h2nY0FidLUml22uGLSjByFbM6aqQQws=
X-Stat-Signature: cmnc1wg47bq1ppi96698bd9fbnfnfjn4
X-Rspamd-Queue-Id: 58A50120011
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754977485-483032
X-HE-Meta: U2FsdGVkX199I+cor3Ame1pyElL+hy/3h/VRyz6UBaBa2rtiHNe/d0FqhFri2SK/A6Loq+ESK4YSO8ALzj7sYK84GHesfNcsoVDHbe1PQOen+Zhq+dkZNYVWKYCIN9iHdfOOaH53ucV1/57Tk02gIjKaXTJiAeyK38pNVcB/Yh+z2oTnGLa1ivoOfBlMQ1ku5aVppSVc0GfQKP79FksICJXKVYp7u13GKqL+Jb6NveaW8rLA0xr9mq/ii0lMwlPD0XS3TSpyKZgWuqhWIArkpuif39b8g6mi7A1WGDDStYhZJiJLz7XRHQOYTb2VDR2RYXB2ii5uvYpI5ULEzwq5XzvzMNlUFzduBhHiu8TnS0Jdl+lpOrNkG+Kwoj2gQIh/O9aXMF8n78muGGG0V2jc5OqngCRJVmNxqDK6KOyeSIHAlCHHrBCfR/UE9llxIWB6ZE/sRDl2ogGrTx46wYcyb1z53DmcJp1RA1M6Wc7XNJqRl3gFGAD6VicaL4HmeSuh+POdbHXKOr/w+ZJQzAOHYnCXTDv94hQuDI5mxEhVVQmIu22CX1IMO1H6eyRYp8aI+ezasGWzXkPa6jfWbDJbhkLITXqw5aI6bN7YYTJsy/mB3fT5Hf9gQpr62Qzp2SttPjsRaG7tQrwwFXCnVJOJL7PlNEN2ALi5tNES2tvRdGgIZuMFM/bDxluR2qNkp39AWqLH8kKOdOYZVB1ADbHfDFuR8otG948NCf8/+2CWrnKglRSDKCiHBgpAG75P2HmhEIyK8oq4o+qBSKP594s941fmg3zJwKjrDYU+pU+9qm9eRpTaNZjkH+ua5joj9lYj5vnCstTgxqvpWN+7Q9xD2CTY+WhIV/1w6cjaYq4rj7dfAolacUpVcai/smhc+oVINdJxWBEgvaPKHCMV0OKBgGWBd9El9v0pqMSQRGNxfOkF0hiuun+rDxP3yfbUb+EakcOA8nzPEbkUNTooibS
 uFjQUI+w
 SYf8Dt3ENxZTC/03kd6uc6H8ze1FZpukRh9DytAkCg9JiTePu/+ReUuf+paquNSDMucrv+3xMASvevZWNRb2dd3OHWPJev5qtjS9blafxGSGULH+KUkQOYSvPMduDpZ+TPvsMOLrCno0MOWpVN3q9VBqycUiC6xHom3o4UPHA/wBPahQUgTr1Zf1PPldkIoTU8NHO3k8kMiMymk78g7NxrzqeHexV3R2ck3WJAXPrt2D9H5kU4yPImiow94+NADOUXSlSrRJcBVHHluOKEtVPMQkKJBrX4jJ06UrE1X18A/wbwP3P+FTb8L0u0YDgZOQ6ZNKWdP1zyohqm/eJBSSpkZa98U1yhIczPStQN0rfpRZlUuoe+VPagpOiki3se7zzRPwXAKGGbWAgTnd05rtixNy2EyF2gzK6EeCkdkeqfvnp1/+ibmXiTpNwBMUMv7jWhZhr+1OnHxsSf6fHKJ+4Enh2SAYbOba3Gl5lM+x81r8Ijlez5m+Wf0DdcP9MdHgYCnK9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The vdsocheck tool validates the object files and final .so library.
It can detect if the compiler created relocations which are incompatible
with the vDSO which need to be worked around.

Wire it up for the architecture.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
---
 arch/arm/vdso/Makefile      | 4 ++--
 lib/vdso/Kconfig            | 1 +
 lib/vdso/check/vdsocheck.rs | 8 ++++++++
 3 files changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/arm/vdso/Makefile b/arch/arm/vdso/Makefile
index cf8cd39ab80468bf1409172a8b857d050b224004..fd34d0ff018a8afa5bfebb62f69bba964c6e73a3 100644
--- a/arch/arm/vdso/Makefile
+++ b/arch/arm/vdso/Makefile
@@ -37,7 +37,7 @@ endif
 $(obj)/vdso.o : $(obj)/vdso.so
 
 # Link rule for the .so file
-$(obj)/vdso.so.raw: $(obj)/vdso.lds $(obj-vdso) FORCE
+$(obj)/vdso.so.raw: $(obj)/vdso.lds $(obj-vdso) $(vdsocheck) FORCE
 	$(call if_changed,vdsold_and_vdso_check)
 
 $(obj)/vdso.so.dbg: $(obj)/vdso.so.raw $(obj)/vdsomunge FORCE
@@ -50,7 +50,7 @@ $(obj)/%.so: $(obj)/%.so.dbg FORCE
 
 # Actual build commands
 quiet_cmd_vdsold_and_vdso_check = LD      $@
-      cmd_vdsold_and_vdso_check = $(cmd_ld); $(cmd_vdso_check)
+      cmd_vdsold_and_vdso_check = $(cmd_ld_vdso); $(cmd_vdso_check)
 
 quiet_cmd_vdsomunge = MUNGE   $@
       cmd_vdsomunge = $(objtree)/$(obj)/vdsomunge $< $@
diff --git a/lib/vdso/Kconfig b/lib/vdso/Kconfig
index e9215084462dfb33a5cd55a57171d2ec4295a270..84bff59ccef4acd95159d03e96991161a029fb2d 100644
--- a/lib/vdso/Kconfig
+++ b/lib/vdso/Kconfig
@@ -52,6 +52,7 @@ config GENERIC_VDSO_DATA_STORE
 config HAVE_VDSOCHECK
 	bool
 	default y if X86
+	default y if ARM
 	help
 	  Selected for architectures that are supported by the 'vdsocheck' progam.
 	  Only transitional.
diff --git a/lib/vdso/check/vdsocheck.rs b/lib/vdso/check/vdsocheck.rs
index c4feb75f93ec0a6a153a758ee7a51cc6f2f58bf1..23970b9d05dc320eb4966967904deae661171b15 100644
--- a/lib/vdso/check/vdsocheck.rs
+++ b/lib/vdso/check/vdsocheck.rs
@@ -46,6 +46,14 @@ fn allowed_relocations_for_machine(machine: u16) -> Option<AllowedRelocations<'s
             ignored_object_file_sections: None,
             in_object_file: &[bindings::R_X86_64_PC32, bindings::R_X86_64_PLT32],
         }),
+        bindings::EM_ARM => Some(AllowedRelocations {
+            ignored_object_file_sections: None,
+            in_object_file: &[
+                bindings::R_ARM_NONE,
+                bindings::R_ARM_REL32,
+                bindings::R_ARM_PREL31,
+            ],
+        }),
         _ => None,
     }
 }

-- 
2.50.1


