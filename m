Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99543EB26F9
	for <linux-mm@archiver.kernel.org>; Tue, 10 Feb 2026 18:50:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4AB16B0089; Tue, 10 Feb 2026 13:50:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4D16B008A; Tue, 10 Feb 2026 13:50:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDAC46B008C; Tue, 10 Feb 2026 13:50:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BB9006B0089
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 13:50:39 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4B9181A0722
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:50:39 +0000 (UTC)
X-FDA: 84429438198.03.BFE96DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 913C540013
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 18:50:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMfeJjuU;
	spf=pass (imf04.hostedemail.com: domain of jpoimboe@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jpoimboe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770749437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y/NCyvKhaWuL9evbPf7/ZZ9AFZbyXb14EQQNjQc+Msk=;
	b=zJn5sThJKGj+1VJC9gnFIqto09OgzplfRFaCjLbTzuGgyrDB1CyW7OL8dzklV/0I2pjju4
	x24OnJybkJ//mPKqwxCkbDUzdcYe5pp6lNbiDKBh+Y2w+epAYNsOjpImnhuSG/oIlA6fsn
	BSAIR2SDfOp0S0GEvblKSAEZ5bdJJU0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fMfeJjuU;
	spf=pass (imf04.hostedemail.com: domain of jpoimboe@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jpoimboe@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770749437; a=rsa-sha256;
	cv=none;
	b=4U/+ZROyPVvEG1CLHsC39cgFRKBs6uZbWYHOskdA0mS3xFU9O2LCE1s10HiJ8OaXQ6tr0a
	aF/0HP/Pj7/WHWxB0traz1BJU07oQ+TUQj9s8huyE4qugsTb+LBaJWGsCldeLxghHL+9yA
	o80hcnlb+v5LSu7VW9Np8b8DiQRoWcg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6A68743B9F;
	Tue, 10 Feb 2026 18:50:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96D3FC116C6;
	Tue, 10 Feb 2026 18:50:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770749436;
	bh=zDR5srkIDvMFQqCdbq54Pzg7cM9Na16eVLnG0oEimSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fMfeJjuUKyBZGySKT7tLqVzR6K1Ih8oiEl/Qo7Emb05MV6gS/YeZrRAw3aYLSaE3e
	 cZ8Hzzzk+X3AeH7uL/AS97Cxqpibu3bLYVeht9GcEkFC6mXDOzQznNng5OBhiAwCFn
	 owIlNyTqXsMZpC/eVT9g+oMzRiwErwRzfaYz2gw8uZzwxV9kckpzcXuE/BAPgHNdDB
	 Ir1Hk9k7jF95XibMoKoUaPNiUpTHjyXRE94lIDl2fKdhdw6dubGaN8bQri/Gdr673r
	 baQU/BUYLV9XEi4lAVqgWzgv0uSRJO/1cHNAq4bgH9nWRugfIqM+43oKnZrmTIdTF1
	 MXvPshvDMz06g==
Date: Tue, 10 Feb 2026 10:50:33 -0800
From: Josh Poimboeuf <jpoimboe@kernel.org>
To: Jens Remus <jremus@linux.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org, 
	Steven Rostedt <rostedt@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Peter Zijlstra <peterz@infradead.org>, 
	Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Andrii Nakryiko <andrii@kernel.org>, 
	Indu Bhagat <indu.bhagat@oracle.com>, "Jose E. Marchesi" <jemarch@gnu.org>, 
	Beau Belgrave <beaub@linux.microsoft.com>, Linus Torvalds <torvalds@linux-foundation.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>, 
	Carlos O'Donell <codonell@redhat.com>, Sam James <sam@gentoo.org>, Dylan Hatch <dylanbhatch@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, 
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: Re: [PATCH v8 6/6] x86/vdso: Enable sframe generation in VDSO
Message-ID: <p24gmtzkxrybebcmn4bsw5puqzjebcy2neetotib6g3pixnj7w@x44ke24v5sjs>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
 <20260206193642.1580787-7-jremus@linux.ibm.com>
 <15f2af3b-be33-46fc-b972-6b8e7e0aa52e@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <15f2af3b-be33-46fc-b972-6b8e7e0aa52e@linux.ibm.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 913C540013
X-Stat-Signature: mhaejrzpywc3kogmkw845qpajhce3ms7
X-Rspam-User: 
X-HE-Tag: 1770749437-514828
X-HE-Meta: U2FsdGVkX1/IUQdQr3T/zk/JCvgFxug13iZN7y4pvU+F4TdT+CfVPwM9mQ72NSPz7hxR42irfjv4avOjbynXqvvSZFwPGpoDFyZbLKxwUOE5cEwCIQEY+3oi2CBxdfLGd4EEKZ0msR73F8EtlPIEinqoPg9yEwKZMQ+i69ubvu6fVhUBXDT+f503qxG+zsBjO9wWQtoK8v3VyaFFbqZHMkcGO7fGdTADR2hC6F/Dv1ozJlCLmZ0a/tkGGYTfVD2nz01WQFDBG1rX2FcOjxkJkUK2P2O7u+MSIr4hSrLIjW3u6KGo6XaQ82i538+aOF8pqxyCn4rHGaGnbpAcaKpLFgsnmmZzYPgX5ug4c5JE4QEmhV5YQ1dzwovMd+eg4FljVCTEjEondbjfa/6j038VY0heS4l42uHBs/2fIU6hiGOkFizXU4Cb//Zm8Zg/aZNWuMWn5xTce/AsFs/NEi17DjKQtZGWSN0gJuSmqXP78TtHmG2A+ribPZxzLUlv1I1dL6L7cm7L0OWhouUASCTJYq/ncFkRgdTCEhJmWtkZcXzCR01zEM9QpTdqYYw8wUfPM4t/0nz9+PKXNDLy6jjn0h46c/B8FaP5jeALJUa+eXCbobfHoIzRdDCfB4xDD3E0MUxyOU8C4fKvZl6cWFcuNBeqQI/VqSzxUAxHbqN3KgB2X4id9dSNWyx980yVek+kIEHAfrS79GH352i0ejoMT0pOXa6ljEXo2fvwMNhNFd1CcHH+nfzZmKcM2Lc+F5iPVHOHRl2weLUjwJcXQ+DoI+x7jtpo6jqTT1sqROvyvXTd//VxC4GDSlXtpU4VmKd3Hg2GVvBoKUIKly66zkQhp9u0WoNf9pUA8BlPXgYpUae4uH/kASCgjIQjCcu/NWoY1EOONkaSkPc39hbAzeNx++NFSOYcA1r0FDd3I3/2HbQYFgCYrHDT552ftF98BYW6AU6gWtome6gcUkSJQpt
 eh/miRxl
 Buq/4wWf/PalmeajPPPzGhtuGzyADL9T+RZowooKzLKfvcnOZNFF+3SXrDQzmyrMnqc8h0alCVekhzxp9JC+TbcG8q1DCecIJ34U/f9nEhOQ7HtSTdgJlusQIpWEG9cRw+96x2iVveXCqVaQKS0xLeXbjar+5fOCy25dE6I34uGCpoQV8LQdt9Xk/w1dagggqbtKPm0cpNUPgiDUN0qBZBkCrj8HSxy2DU45NeS2RjEwt5g7XR3gaMDhzaa6lWhILYLjpaNALRUqP4kKkAt0ggQBHvFoem2WF1ML1+69X33xHOw5BXl6bxvkLJcj6PzyEENegPT6VGFhN8uUzZUWEhBs+evc3PZuEI5wPikA6SOoTqC8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 10, 2026 at 05:46:33PM +0100, Jens Remus wrote:
> On 2/6/2026 8:36 PM, Jens Remus wrote:
> > From: Josh Poimboeuf <jpoimboe@kernel.org>
> > 
> > Enable sframe generation in the VDSO library so kernel and user space
> > can unwind through it.
> > 
> > SFrame isn't supported for x32 or x86-32.  Discard .sframe sections for
> > those VDSOs.
> > 
> > [ Jens Remus: Add support for SFrame V3.  Prevent GNU_SFRAME program
> > table entry to empty .sframe section. ]
> > 
> > Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
> > Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
> > Signed-off-by: Jens Remus <jremus@linux.ibm.com>
> 
> > diff --git a/arch/Kconfig b/arch/Kconfig
> 
> > @@ -479,6 +479,13 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
> >  	  It uses the same command line parameters, and sysctl interface,
> >  	  as the generic hardlockup detectors.
> >  
> > +config AS_SFRAME
> > +	bool
> > +
> > +config AS_SFRAME3
> > +	def_bool $(as-instr,.cfi_startproc\n.cfi_endproc,-Wa$(comma)--gsframe-3)
> 
> Above tests whether the assembler supports --gsframe-3 to generate
> .sframe in SFrame V3 format.  GNU assembler only supports to generate
> SFrame for x86-64.  If the assembler is built for i386 (x86-32) the test
> will fail unless option --64 is specified.  I wonder whether that could
> happen in (the rather hypothetical?) case, when the kernel is cross built
> for x86-64 on i386?  Should this therefore be changed to the following?
> 
> config AS_SFRAME_64
> 	def_bool $(as-instr,.cfi_startproc\n.cfi_endproc,$(m64-flag) -Wa$(comma)--gsframe)
> 
> An alternative would be to enable as-instr64 to accept an optional flag
> operand, similar to as-instr, and use as-instr64 instead of as-instr.
> 
> Or is this not required, as in a cross build for 64-bit on a 32-bit
> platform (or inverse) a respective cross toolchain is a prerequisite and
> the m64-flag (or m32-flag) is not used?
> 
> I tried to simulate this using docker and an i386 image and then using
> the i386 tool in the container to switch "uname -m" to "i686".  But both
> of my following attempts to build for x86-64 on i386 fail with fixdep
> not found:
> 
> $ docker run -it --rm -v "$HOME/linux:$HOME/linux" --platform i386 public.ecr.aws/docker/library/debian:13.3
> # sed -i -s 's/^Types: deb/& deb-src/' /etc/apt/sources.list.d/debian.sources
> # apt update
> # apt -y build-dep linux
> 
> # make mrproper
> # i386 make ARCH=x86_64 defconfig
> # i386 make ARCH=x86_64 arch/x86/entry/vdso/
> 
> # make mrproper
> # apt -y install gcc-x86-64-linux-gnu
> # i386 make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- defconfig
> # i386 make ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- arch/x86/entry/vdso/

Hm, I think I broke that with

  a808a2b35f66 ("tools build: Fix fixdep dependencies")

... though it's been broken almost a year, maybe nobody cares.

Regardless, we do need to fix "make clean" and "make mrproper" for
objtool, which would be something like so:

diff --git a/Makefile b/Makefile
index d3a8482bdbd0..ed850044491d 100644
--- a/Makefile
+++ b/Makefile
@@ -1474,6 +1474,15 @@ ifneq ($(wildcard $(resolve_btfids_O)),)
 	$(Q)$(MAKE) -sC $(srctree)/tools/bpf/resolve_btfids O=$(resolve_btfids_O) clean
 endif
 
+PHONY += objtool_clean
+
+objtool_O = $(abspath $(objtree))/tools/objtool
+
+objtool_clean:
+ifneq ($(wildcard $(objtool_O)),)
+	$(Q)$(MAKE) -sC $(abs_srctree)/tools/objtool O=$(objtool_O) srctree=$(abs_srctree) clean
+endif
+
 tools/: FORCE
 	$(Q)mkdir -p $(objtree)/tools
 	$(Q)$(MAKE) O=$(abspath $(objtree)) subdir=tools -C $(srctree)/tools/
@@ -1637,7 +1646,7 @@ vmlinuxclean:
 	$(Q)$(CONFIG_SHELL) $(srctree)/scripts/link-vmlinux.sh clean
 	$(Q)$(if $(ARCH_POSTLINK), $(MAKE) -f $(ARCH_POSTLINK) clean)
 
-clean: archclean vmlinuxclean resolve_btfids_clean
+clean: archclean vmlinuxclean resolve_btfids_clean objtool_clean
 
 # mrproper - Delete all generated files, including .config
 #
diff --git a/tools/objtool/Makefile b/tools/objtool/Makefile
index a40f30232929..6964175abdfd 100644
--- a/tools/objtool/Makefile
+++ b/tools/objtool/Makefile
@@ -29,6 +29,8 @@ srctree := $(patsubst %/,%,$(dir $(CURDIR)))
 srctree := $(patsubst %/,%,$(dir $(srctree)))
 endif
 
+RM ?= rm -f
+
 LIBSUBCMD_DIR = $(srctree)/tools/lib/subcmd/
 ifneq ($(OUTPUT),)
   LIBSUBCMD_OUTPUT = $(abspath $(OUTPUT))/libsubcmd

