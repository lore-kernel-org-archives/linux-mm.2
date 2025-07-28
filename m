Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7690C83F17
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 12:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A746B0088; Mon, 28 Jul 2025 08:47:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22B286B0089; Mon, 28 Jul 2025 08:47:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11A456B008A; Mon, 28 Jul 2025 08:47:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0122D6B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 08:47:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 82066160254
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:47:27 +0000 (UTC)
X-FDA: 83713649334.10.78B30C9
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf27.hostedemail.com (Postfix) with ESMTP id DBA8F40008
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 12:47:25 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fVrLDUF6;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753706846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bzb8t/6nORtGXVRimdsT6Upco6zC0qWd4/4ieZdsy5o=;
	b=K1GNXFV0qbgUlTdSzHca1ibPM74M1LlbPyfkubtMN+bOzPfzl8wEM36p0rRHDNq65fu6zk
	SIegltjp96zCsd8MwpmAVdY4CEmSDvXZYMNH4obKnhbsxXhgaXJz9lGrK5LFSr6mNI1oog
	P/l0YbdengFqzMhS39RxMLYlgI1SNig=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753706846; a=rsa-sha256;
	cv=none;
	b=xkDhRxdKAGyClr1C4S3rygkq7bRTv3LePkW7e9IDFm0m7FM3eaFcoTPDRoCKozMd/UxAId
	V33RmfCLvRjJJ3L1o4LujZyRyWnkbqGAc6WlwDtvYgHRBh3D+XLqtGPg0ZQK3J6isIiafC
	aulH18GaO0EyhdRN3JXMpSHo5ynjDHw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fVrLDUF6;
	spf=pass (imf27.hostedemail.com: domain of will@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 8EFD75C414C;
	Mon, 28 Jul 2025 12:47:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A14C4CEE7;
	Mon, 28 Jul 2025 12:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753706844;
	bh=8erufKMpAOmnBQJD5AQN3zyqiuSStzu2grxssP0lTyk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fVrLDUF6ALvU1+rw08l0PQQfJJ7diMMEUvcuQzJIilzrRSpYwOlOYK2n15xwoyML4
	 D4v1V5ouoPMP5Uz79ByW5/BerCfgE3utI4NZmRpjthPrhH6zfjhuvxxdwBw/nduyx5
	 BrLlHsjfIfQLUwiEsrKJ7Z00EUM59kWy8WUBrjuxruXI8VGjRYFATJyEOBskkNPuBj
	 cOwpUVMCLcgqoD5XxSL62JtvLUxMBr1zB0b3M8fPyxY2JnP4ebqJETtie1/WquwywI
	 lFApDm1CkeeTMlruPIC1tMlq6jstGhB1R7LebnE8eV6IkSurORWhWXOaOc/cTwOFqR
	 53bl3DIV1aZJA==
Date: Mon, 28 Jul 2025 13:47:14 +0100
From: Will Deacon <will@kernel.org>
To: Sami Tolvanen <samitolvanen@google.com>
Cc: Deepak Gupta <debug@rivosinc.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nicolas Schier <nicolas.schier@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Monk Chiang <monk.chiang@sifive.com>,
	Kito Cheng <kito.cheng@sifive.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
	llvm@lists.linux.dev, rick.p.edgecombe@intel.com,
	broonie@kernel.org, cleger@rivosinc.com, apatel@ventanamicro.com,
	ajones@ventanamicro.com, conor.dooley@microchip.com,
	charlie@rivosinc.com, samuel.holland@sifive.com, bjorn@rivosinc.com,
	fweimer@redhat.com, jeffreyalaw@gmail.com,
	heinrich.schuchardt@canonical.com, andrew@sifive.com,
	ved@rivosinc.com
Subject: Re: [PATCH 10/11] scs: generic scs code updated to leverage hw
 assisted shadow stack
Message-ID: <aIdxUpSc-Co8wLYE@willie-the-truck>
References: <20250724-riscv_kcfi-v1-0-04b8fa44c98c@rivosinc.com>
 <20250724-riscv_kcfi-v1-10-04b8fa44c98c@rivosinc.com>
 <20250725161327.GC1724026@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250725161327.GC1724026@google.com>
X-Rspamd-Queue-Id: DBA8F40008
X-Stat-Signature: 46waisn1wxsga91zuiteyxu6kchgpzo9
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753706845-611360
X-HE-Meta: U2FsdGVkX1/kp2jqQ0N7T+AS9d2VA6HNprI4Cx22UteNGqR3dUaX5T/OdZIlxT7P1usMAw/+Ap//QjLbMbbuHiWql7W9QNCEB1LrQHHog3pWtPxYzOVa+3VMBjXN2pLTlmPbFW4Xd22rw+8zBuPKnC+nfO27W0TpOd4zvnq6L6u5Yb02K8TX2v3en+QzXt5GLfBuU35uDUZFZg+sOE7gceG51YqZv7T5T1KDHNbYal8OgkOVBkWts79jro8qVcZBz5n2+lkMCzkDSxVHZIwm8WfYIEuA+S4oRmUFgJ92Qj2dR6Pzb4A//1yD5fS1WQvu9WDrJR81S20PZi+fd5FMVa9ddMe7S1swl55irlv0wZykXm3FTSFFh7WYn7cnKl2vmSSXtG2NYfNCZH69QzUTc4fDb3RYweZo3+NLFdgM+o00h8vaOcO/IjsxSGmsCuBLkDZ+sylGV/gd5nJBsFhR+E7zFyVp+K/7QNk7mbK5M5Cr5JDbBAUgrTTVVQlcWvuPxBYsybc6gIGN84cUmYOYWQztpIuyfp8lV82/QgR/RHcN5qxCAON9i8ZD976QDOZ76dhLe3VuPDjRJS/L0vTK5qKwte1mupQUR95XSyXFgqo4499fQaemAWLOBGH8A7X7EOZvItATgPA6Lj37zp5LkqqJccbXlvrXBi5GQAgPcOKrRDcq5GcLBUxYFcgdJ6psFUw/XqCj1jGsUfu3YiD6Rzx0m9l3mUj6TZbI8kZql98rFmnTITupt4zUa+aAYKBs4TjBN/CFAmkBN0ZUxfrR5t7C5Cw4gpvEzZld2Mn3pzrK2NqK/PI3LwswPogrUqkiZXjIyALNJ0u++6EdEre/XzJ2vhuaWuEPcAEqufRfCecn96CQW8uPAPfJkMN+L800CATikV95xChKzW363CI4Zn/dGsUO3N664KbrCvkSzw9zZQqObdt8XaQEcaQviUiQV6WOxKSmX0P3oo0eZzz
 Q/LavTEQ
 wF94iis8chGrsvGfDpE+I1eJwSBxbKevzXtjy2ssEcWXo7PSnIXs19bx6fA1F1MmhMmPXgc9/GCLhlBflvJfYTV14a8+9hXV2tNGvPGi0yni+475tKYZ20pInecZw9eLjCWv8etx0I9NQdVpGGcikDbnPn9ReJhd6cz+TYynkJ/CYAfxe8zv/7bsDQ785R4Rc5UnpcLxttBGyk+Tta7heH9WHucjFqUMt2/5aAa8Rcp7wM5yXAg0ZRsg0L6R4P+0b5RNyqItxzx/Iv2jgqqQqmfHUEpPPWTk84WJ37AV4957EsMx7Hn1jhEHL/ISUNIO+IK6sBrJpCOHOFV85VrwHXekn5DOPNuEv1sVjh0jDFT7wxkc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 04:13:27PM +0000, Sami Tolvanen wrote:
> On Thu, Jul 24, 2025 at 04:37:03PM -0700, Deepak Gupta wrote:
> > diff --git a/include/linux/scs.h b/include/linux/scs.h
> > index 4ab5bdc898cf..6ceee07c2d1a 100644
> > --- a/include/linux/scs.h
> > +++ b/include/linux/scs.h
> > @@ -12,6 +12,7 @@
> >  #include <linux/poison.h>
> >  #include <linux/sched.h>
> >  #include <linux/sizes.h>
> > +#include <asm/scs.h>
> >  
> >  #ifdef CONFIG_SHADOW_CALL_STACK
> >  
> > @@ -37,22 +38,45 @@ static inline void scs_task_reset(struct task_struct *tsk)
> >  	 * Reset the shadow stack to the base address in case the task
> >  	 * is reused.
> >  	 */
> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> > +	task_scs_sp(tsk) = task_scs(tsk) + SCS_SIZE;
> > +#else
> >  	task_scs_sp(tsk) = task_scs(tsk);
> > +#endif
> >  }
> >
> >  static inline unsigned long *__scs_magic(void *s)
> >  {
> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> > +	return (unsigned long *)(s);
> > +#else
> >  	return (unsigned long *)(s + SCS_SIZE) - 1;
> > +#endif
> >  }
> >  
> >  static inline bool task_scs_end_corrupted(struct task_struct *tsk)
> >  {
> >  	unsigned long *magic = __scs_magic(task_scs(tsk));
> > -	unsigned long sz = task_scs_sp(tsk) - task_scs(tsk);
> > +	unsigned long sz;
> > +
> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> > +	sz = (task_scs(tsk) + SCS_SIZE) - task_scs_sp(tsk);
> > +#else
> > +	sz = task_scs_sp(tsk) - task_scs(tsk);
> > +#endif
> >  
> >  	return sz >= SCS_SIZE - 1 || READ_ONCE_NOCHECK(*magic) != SCS_END_MAGIC;
> >  }
> >  
> > +static inline void __scs_store_magic(unsigned long *s, unsigned long magic_val)
> > +{
> > +#ifdef CONFIG_ARCH_HAS_KERNEL_SHADOW_STACK
> > +	arch_scs_store(s, magic_val);
> > +#else
> > +	*__scs_magic(s) = magic_val;
> > +#endif
> > +}
> > +
> 
> I'm not a huge fan of all the ifdefs. We could clean this up by
> allowing architectures to simply override some these functions, or at
> least use if (IS_ENABLED(CONFIG...)) instead. Will, any thoughts about
> this?

Yeah, I agree that allowing architectures to provide overrides makes
sense, however I also suspect that some of this needs to be a runtime
decision because not all CPUs will support the hardware-accelerated
feature and will presumably want to fall back on the software
implementation.

Will

