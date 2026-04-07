Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24955FEEF51
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 14:37:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5C51D6B0088; Tue,  7 Apr 2026 10:37:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575DE6B0093; Tue,  7 Apr 2026 10:37:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48BC06B0095; Tue,  7 Apr 2026 10:37:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8FF6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:37:48 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4DAFBB4C5
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:37:47 +0000 (UTC)
X-FDA: 84632013774.23.BC4ACC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3CE99C0009
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 14:37:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m1aYYWfg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775572666; a=rsa-sha256;
	cv=none;
	b=4FFz7evu0KACfg+fbxeeOYAQjqQ0GHSlMaTuSSjpMDxK/gS4zwFCMpkIyoj/OczXlRRXfV
	366m9FfxlIDUZmTUo7ngzb6ccfU5iB1U5bPtCbhzl+3FR/pL+N/qqt+LmDzsj0EOi89EIL
	VO1fLNIizfPmGdWbPlG/cUHzI0KIzXw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m1aYYWfg;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775572666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJxNVu1NWeXsWGYD0Hz/0bUitqRe57nbeSU5E8O1gg0=;
	b=DrKj0WrTOp11P6QlBc00vMYlFD/ZuGFjmRea1NeYPq2PfptaCJ08HpTuMMjRLieoDvxs0O
	qbL68XdjtwGvjLZ1VNs/y/HgytS3FzrVsyAkxLDsU1DTr1R7mxOBii6VS/h/ZbvjCaAUhp
	Hbje56ywhNTXRbCi2KKna6arDpryXWo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0559D44259;
	Tue,  7 Apr 2026 14:37:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 305A1C116C6;
	Tue,  7 Apr 2026 14:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775572664;
	bh=qcwFe61yYk9/XUZijcBTHdiaZcYiATYoWR8d6pB509M=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=m1aYYWfgF/eFXk/afD3YzfALOhQ9KLQpxC0RKhl7tRHY/yF84K3UnhNOR5oOTe5Yh
	 qFs+epdHRiQl7rM/NOKXBYYn1VL3y160pZBKFiOACcODp2GPE8WlvnfABMkwDXtz1r
	 v7iuEMvECHtA2msunmgR6rFtkxeCMxRlNKAGT/PgnzyhHUIO3Rh0VmY0D6hLc5NC1Y
	 QEhIABtmIND7sPL52Tr2RHJc5MiWyvnsd6RD1hQD7pMZLCz9IsN+/fY7ZaAM8cRSQF
	 8EIXaztizpEiFdcMpfGZ/s+ORHlAk27DWD2/5eRDPtbIqBf7ynQkCRwHaKJrmEQaU5
	 WRCNMuzjePmWw==
Date: Tue, 7 Apr 2026 15:37:36 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Anand Moon <linux.amoon@gmail.com>, David Howells <dhowells@redhat.com>, 
	David Woodhouse <dwmw2@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Peter Zijlstra <peterz@infradead.org>, Nathan Chancellor <nathan@kernel.org>, 
	Kees Cook <kees@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Douglas Anderson <dianders@chromium.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Randy Dunlap <rdunlap@infradead.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, "open list:CERTIFICATE HANDLING" <keyrings@vger.kernel.org>, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:FILESYSTEMS (VFS and infrastructure)" <linux-fsdevel@vger.kernel.org>, "open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Subject: Re: [PATCH v1] treewide: Fix indentation and whitespace in Kconfig
 files
Message-ID: <adUWbw60LyIMaDKg@lucifer>
References: <20260407053945.14116-1-linux.amoon@gmail.com>
 <2w7il2oprhkus5eyuxj3alzlsstp4yv23gazmxfmofzikqllrh@uwsx5nbj2hwv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2w7il2oprhkus5eyuxj3alzlsstp4yv23gazmxfmofzikqllrh@uwsx5nbj2hwv>
X-Rspamd-Queue-Id: 3CE99C0009
X-Stat-Signature: u3st34ndra8ge8ris1nujsd4kumsyeur
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775572666-940727
X-HE-Meta: U2FsdGVkX19JinnJWJorCBWe+2abesCgzCXOR/oRY3MS6U1b1Bd06F/BLivznYvZcb4fQeszalLXsxJvj6+adtpWeXxlgRWkoNNDiOmywOUunqptrEQZLc8fEyzM+k4IOk5RhNZP+xC+QTYOhtcyJyVGIgVdYM6skqFDBNE9ybMi1LbojztDd8d2TNM8O4dmDG81wSxmvBFsnc8RG9EbCZKFVExrtRGpFo6+hAM8K/2ryrEzXZeP+0GvYOC6XBF1r4VHExQdikqVQ6qHFnN6ih83ShGGfyRVlm2vdnMh9+XzUVMuk4JvrjL3FK8NQOv7y2uV0dsQpIAxf310ZlNltNOh9qnjJfZ+qsRnJCkM1mh23ZQyD8SVw0dOncOK9zTMLTc7xXnVMS1g2Eq5I2UUDSnlyGqDZdtFZhQlIEc62T5TERivy4UQBSsM/73nyfa1uga+Xv5RYmpUc1MNC6PK3/7CN90SOg7Q6lrO1tXzjyD/aVJKLawuJPG4vfKw7OVoYBrZvwVr6+8XXRjFLyFTZOhmKtBGSXVvc3B2U3lgr9T3OMJr2p4Rn1L4zpVSwFfKg/JAN4nLTnF7WYWXmAMmaefQfkShAtEcy+/KA4XzvBfV8oI5T+kKOT9bPUr/97Vw1sCE5fGIqjPCSYExwLp1uJ18hyRL63jzHjbiHbYL53abUd2GORYpwv40pEn2Sp5hz3aU89NQ2U5UqKPsq62NCZ/82K0s8WZURkC0h7h2EwjqLoYrDWMwfz1Xfms3pGoXL7FjalC9oD8aMYek9Y3FESwiT+9gzkPLYqbTm6CkjyQVm1C2tDr1r659Uy9u4Svel4Pz3Z8e3PLpvdObtpDaSxw8DNrtrBVTQ72a7VZG6VPIFue2yp4y8AeGKb8GuFOdJg+Hoh67XwKJrTabAOx3geaQY96x2V9Un7o7yia/ga82pfNXdDPhGE5MIdH74DFvlZtzCPZDFZRLt+Znt7i
 /1Y7LZ42
 RT+yx19Q0tZlHktrNTp/XrVIXthP911vdXbaTE1vPp0r0nU8EhW6WPy+mj7YpVOihcUy5/9kb+OtoMGlRT4ZPvSNj5ax1rRXQywY3wFrxACLFXPD+xh9JXMSVA3tD+7G1MA3XYfUxm09SAaHbSGYxOagZrK6sJAL2EhBmIdpmBBrQJvZhYbCVUSxwqEhrutsu7MzNML7fiKwPG5E6Z5Kc++p1+qO1zILdT7bUeYJAUNmMbdMSz2/jRo4R3vNTPkWAVVcxccVoliw8LNCovdIlIzBQ9XykIv6HIXeo7EAxiLvGzvvR5fxjOnHsX05zEJGhGe700lNubRuNZ/50e36dYzgUERMHzRlzL+Sst9JuT6MVKylP/Sc1Hl3MSh9MpyrRD74ZRxyJOjE+PtM/sBdY5qJ8PSoe9wjAp3yEg+sKfhtXP8zuMVL4KQXS+daanMj6rtJO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 07, 2026 at 09:58:56AM -0400, Liam R. Howlett wrote:
> * Anand Moon <linux.amoon@gmail.com> [260407 01:40]:
> > Clean up inconsistent indentation (mixing tabs and spaces) and remove
> > extraneous whitespace in several Kconfig files across the tree.
> > This is a purely cosmetic change to improve readability.
> >
> > Adjust indentation from spaces to tab (+optional two spaces) as in
> > coding style with command like:
> >
> > $ sed -e 's/^        /\t/' -i */Kconfig
> >
> > Signed-off-by: Anand Moon <linux.amoon@gmail.com>
>
> For the mm section,
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Looks correct to me for mm also, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

Cheers, Lorenzo

>
> > ---
> >  certs/Kconfig | 16 ++++++++--------
> >  fs/Kconfig    |  6 +++---
> >  init/Kconfig  | 24 ++++++++++++------------
> >  lib/Kconfig   |  2 +-
> >  mm/Kconfig    |  4 ++--
> >  5 files changed, 26 insertions(+), 26 deletions(-)
> >
> > diff --git a/certs/Kconfig b/certs/Kconfig
> > index 8e39a80c7abe5..9d2bf7fb5b9e4 100644
> > --- a/certs/Kconfig
> > +++ b/certs/Kconfig
> > @@ -6,14 +6,14 @@ config MODULE_SIG_KEY
> >  	default "certs/signing_key.pem"
> >  	depends on MODULE_SIG || (IMA_APPRAISE_MODSIG && MODULES)
> >  	help
> > -         Provide the file name of a private key/certificate in PEM format,
> > -         or a PKCS#11 URI according to RFC7512. The file should contain, or
> > -         the URI should identify, both the certificate and its corresponding
> > -         private key.
> > -
> > -         If this option is unchanged from its default "certs/signing_key.pem",
> > -         then the kernel will automatically generate the private key and
> > -         certificate as described in Documentation/admin-guide/module-signing.rst
> > +	 Provide the file name of a private key/certificate in PEM format,
> > +	 or a PKCS#11 URI according to RFC7512. The file should contain, or
> > +	 the URI should identify, both the certificate and its corresponding
> > +	 private key.
> > +
> > +	 If this option is unchanged from its default "certs/signing_key.pem",
> > +	 then the kernel will automatically generate the private key and
> > +	 certificate as described in Documentation/admin-guide/module-signing.rst
> >
> >  choice
> >  	prompt "Type of module signing key to be generated"
> > diff --git a/fs/Kconfig b/fs/Kconfig
> > index 0bfdaecaa8775..74110311968aa 100644
> > --- a/fs/Kconfig
> > +++ b/fs/Kconfig
> > @@ -78,7 +78,7 @@ config FS_DAX
> >  	  --map=mem:
> >  	  https://docs.pmem.io/ndctl-user-guide/ndctl-man-pages/ndctl-create-namespace
> >
> > -          For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
> > +	  For ndctl to work CONFIG_DEV_DAX needs to be enabled as well. For most
> >  	  file systems DAX support needs to be manually enabled globally or
> >  	  per-inode using a mount option as well.  See the file documentation in
> >  	  Documentation/filesystems/dax.rst for details.
> > @@ -116,8 +116,8 @@ config FILE_LOCKING
> >  	default y
> >  	help
> >  	  This option enables standard file locking support, required
> > -          for filesystems like NFS and for the flock() system
> > -          call. Disabling this option saves about 11k.
> > +	  for filesystems like NFS and for the flock() system
> > +	  call. Disabling this option saves about 11k.
> >
> >  source "fs/crypto/Kconfig"
> >
> > diff --git a/init/Kconfig b/init/Kconfig
> > index 7484cd703bc1a..6fea1453c2941 100644
> > --- a/init/Kconfig
> > +++ b/init/Kconfig
> > @@ -1036,14 +1036,14 @@ config PAGE_COUNTER
> >  	bool
> >
> >  config CGROUP_FAVOR_DYNMODS
> > -        bool "Favor dynamic modification latency reduction by default"
> > -        help
> > -          This option enables the "favordynmods" mount option by default
> > -          which reduces the latencies of dynamic cgroup modifications such
> > -          as task migrations and controller on/offs at the cost of making
> > -          hot path operations such as forks and exits more expensive.
> > +	bool "Favor dynamic modification latency reduction by default"
> > +	help
> > +	  This option enables the "favordynmods" mount option by default
> > +	  which reduces the latencies of dynamic cgroup modifications such
> > +	  as task migrations and controller on/offs at the cost of making
> > +	  hot path operations such as forks and exits more expensive.
> >
> > -          Say N if unsure.
> > +	  Say N if unsure.
> >
> >  config MEMCG
> >  	bool "Memory controller"
> > @@ -1125,7 +1125,7 @@ config GROUP_SCHED_WEIGHT
> >  	def_bool n
> >
> >  config GROUP_SCHED_BANDWIDTH
> > -        def_bool n
> > +	def_bool n
> >
> >  config FAIR_GROUP_SCHED
> >  	bool "Group scheduling for SCHED_OTHER"
> > @@ -1625,10 +1625,10 @@ config LD_ORPHAN_WARN
> >  	depends on $(ld-option,--orphan-handling=error)
> >
> >  config LD_ORPHAN_WARN_LEVEL
> > -        string
> > -        depends on LD_ORPHAN_WARN
> > -        default "error" if WERROR
> > -        default "warn"
> > +	string
> > +	depends on LD_ORPHAN_WARN
> > +	default "error" if WERROR
> > +	default "warn"
> >
> >  config SYSCTL
> >  	bool
> > diff --git a/lib/Kconfig b/lib/Kconfig
> > index 0f2fb96106476..4b0026954a370 100644
> > --- a/lib/Kconfig
> > +++ b/lib/Kconfig
> > @@ -589,7 +589,7 @@ config OBJAGG
> >  config LWQ_TEST
> >  	bool "Boot-time test for lwq queuing"
> >  	help
> > -          Run boot-time test of light-weight queuing.
> > +	  Run boot-time test of light-weight queuing.
> >
> >  endmenu
> >
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index ebd8ea353687e..10a4ce4247fa1 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -1304,7 +1304,7 @@ config ARCH_HAS_PTE_SPECIAL
> >  	bool
> >
> >  config MAPPING_DIRTY_HELPERS
> > -        bool
> > +	bool
> >
> >  config KMAP_LOCAL
> >  	bool
> > @@ -1435,7 +1435,7 @@ config ARCH_HAS_USER_SHADOW_STACK
> >  	bool
> >  	help
> >  	  The architecture has hardware support for userspace shadow call
> > -          stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
> > +	  stacks (eg, x86 CET, arm64 GCS or RISC-V Zicfiss).
> >
> >  config HAVE_ARCH_TLB_REMOVE_TABLE
> >  	def_bool n
> >
> > base-commit: bfe62a454542cfad3379f6ef5680b125f41e20f4
> > --
> > 2.50.1
> >

