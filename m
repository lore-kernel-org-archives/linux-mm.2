Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69247606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h45kPzaH
Received: by kanga.kvack.org (Postfix)
	id 69E496B084F; Tue, 27 Oct 2026 12:57:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 675D56B0851; Tue, 27 Oct 2026 12:57:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B1BA6B0852; Tue, 27 Oct 2026 12:57:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ACFD6B084F
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:57:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AD235A87AD
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:57:15 +0000 (UTC)
X-FDA: 85369011630.29.9C34CAB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 0F7321C000A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:57:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h45kPzaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793120234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZfqPY3Erv/g9mQt4k+Coj1gdlGms1HCX62UMjguoFM=;
	b=6OWes+wEgotWg6wyVUkPyzjKarGvNkX0Op+DrkUr5xtL6w+xqDHdXqjlX0L1OoxZ/effCr
	cYCO9rokokrtdHNSLfyd4t4JFeP9LgdvU2nZHbZK5vHNcQPvu2gTGOMnLSeGr9I3oSE7e9
	tVpFuhuwSLkw1ErJi/xXwNLes7cZtAY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h45kPzaH;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793120234;
	b=1xqp0QwFoaZ+FDgHS5TpUBKHblbdCketty90eVwAw62EoaP1TpT0DBBsZk2ksu4UjGfgkf
	KkzuWCfJLXCSjGjNynKuHIJkw0hxOmMwvkApdp4YRwz/lzgPmETxtW3fmBRBMbABA/kN4U
	HqMxv+xB80e8NhNZ366eogGYieCnO6E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B2C5A60219;
	Tue, 27 Oct 2026 16:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D37E1F01825;
	Tue, 27 Oct 2026 16:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793120232;
	bh=uZfqPY3Erv/g9mQt4k+Coj1gdlGms1HCX62UMjguoFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=h45kPzaHDhEmZmxxzBvN2+CDEbdEm0+mt6GRoI7wRvz4n1HF7cvhWDVPmaOTBnF1o
	 IFtcCipfw1D0tHcXiDt7GLPRJAu2IR48LCLriMwZItMjX9kHZGS5thjqZIPd6rC2dZ
	 3gQ1qAdTzk3RpOOpQjhCdseY4xP3ji5ToY8JRsgMlBnL2jEmS6oLZR/5FGjPDp8dEs
	 QqClY/jNpHblc8QhmWi0lQYKcjg0StU9r6AaSnDxqOa6QgIVA/5+N+OpBwkxA8OGU4
	 sXLgGWXSw77DX6FJp+7jgKHmk1Hj+8V8Pcvbipe/IpILejomUcTT8/7lsDjDUQSK2r
	 i5ljJZN00awjQ==
Date: Tue, 27 Oct 2026 16:57:04 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, Kees Cook <kees@kernel.org>, Jeff Xu <jeffxu@chromium.org>, 
	Andrey Vagin <avagin@gmail.com>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Shuah Khan <shuah@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-security-module@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH 1/3] mseal sysmap: Add mseal_system_mappings= boot
 parameter
Message-ID: <auDTptDQsB4xBcz7@gremlin>
References: <cover.1793094611.git.chris@chrisdown.name>
 <5bd3c89d733ad22224f296dfa8900769de937de0.1793094611.git.chris@chrisdown.name>
 <auCxjbvY3qPv1sV6@gremlin>
 <auDTMb6WMFUpxeZy@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auDTMb6WMFUpxeZy@chrisdown.name>
X-Rspamd-Queue-Id: 0F7321C000A
X-Stat-Signature: em4rxzrren5371dma5k73t8ggtgou57f
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793120233-976338
X-HE-Meta: U2FsdGVkX18LZZktEJAR5ate5LycLaTw1iMJcqHd6Dgd5+S8J3sKcF/V0Y5bUS6HkuvLJpJwdpA7Ch6CYfnxemKQN4Inv4pAglJ9nDPf5o7uWm+vjTy3iJjig/wA1MG0pL/3WKYABMrYMXjG+/OskbVp92TEoN2mc4NmA/xQXJLoGJP44uk4uuTcSPyhbxQR6JjRt7QLBUwlJGQGjmUWutUFkZNIrI96WiWbFaI4VzmTbi/4OI0qJAKNiq6FChl/7ZkNXPsnGJOz3pBfvdH3Dsu/ZeD5AqxSRgSFPmOTwNnly5x6qULEkw5Q3LFqhRlrIGx8V42T9d2MLZSWsUJTX7CZxw5RG+XxfywxufssEaLA1g6dWAEWsvR5oQ8/tNQ+2OUYgyRLB3vsO79iZcB7fbkGRW8vQcTkNXiyUYYXsMN1m3avtQTlp7kxOEpmq32IbYsAC+JEAB2meSFxeTgSzPRf7EYD+ym9vH9YJPMbq0oYqclW5UZBa/br1R1OdTd2By7TjJkuDMGlFtOpFOEyqnC4tSEraBpCJAWblyfRnWW4Uw/wL+o56DP9ojAfwYrsxF9fzRGlLNVH9ysbDYOM/L/Y2w5UO5gJKaKy5n68mmq08ITdUA1jxtiT5wDSJ5xo9xQG6hH36cIQovwvi7h4wodPWZm2FbhqPMCsiOe3FXmdcfA4qAY4vKS5Rzbs0OBxH1KBHsMwPPq7iXIRxPQd8qq3LiNho6dhpSVVBdLXFJuH1jx4cumnMzMq/CGUJIWwLtlwKvyMZ0W9JPc2n2dHiYkqhVgs6OLsulnv9fugRZ6jGd6unq3n/JoVweBXnB1e2QaXyMtLkdv4Ss2+bwFD3YMICvpI0vuPxJTHWH/KonkRPe9F4Tv40pRaBQmzr8gvU8JQ+ozMa8ri59/Q22G22u6L/WNYeKmwBcIFyVi0ZKiy/l+G31DtVKlNH+GLOBkoAfnNASSDEpFSFnvrGnA
 fbD9A8Up
 1foRyiMXn+mzqTYaWwjJyh0IXC/KPUV10s+UaP6SI5MkbBe3W8RxNX8GF9S2qeJqXOsVwt05mzh9DAIf9xoJ/PiWFbzUwTq20eViP3Q/+5Fs5uezDRmtevnrLqx/TuiJ8n8jMhcarB6wcbXGFIYAOXBMr8W15nf4k2bWo8vBWnGxbZCru99XJhJaLZJZ4JwJdCgz+POCAkV66fQiA8xFYwyscHQKV4AdFMwcN0pTayCFxtNuHUy2lAIEyrExE35uFpBJNhnQugtxvtvqt99EFuUOUIlEdVciGaTkDsyjoFN1LgloCt+Wlypdf0klnfq9yVEw1M/ijnI18Y8EYZbBEAXTt4TiggS28LWZPXkjyHxJo2m0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 12:37:05AM +0800, Chris Down wrote:
> Hi Lorenzo,
>
> Thanks for the quick and thorough review!

No worries!

>
> Lorenzo Stoakes (ARM) writes:
> > The existing implementation is a bit of a mess, so any work that extends it
> > has to put in the work to improve things first.
> >
> > I _hate_ VM_SEALED_SYSMAP. It's a hack. A tasteful way of doing this is
> > really required for a series touching this to be taken, honestly.
> >
> > See below for implementation ideas.
>
> That's fair, I'll do the cleanup first in v2.

Thanks!

>
> > (Also it's the merge window, so no more revisions until -rc1, when you need
> > to resend, thanks.)
>
> Sure, I'll wait until after -rc1.

Yup :) we are a bit inundated with AI fixes these days.

>
> > Could we have some actual justification for the use of the feature please?
> > So far I've seen arm-waving.
>
> Sure. At Meta, we build sealing into the kernel for our VM hosts, and we'd
> like it on as much of the rest of the fleet as possible. The problem is that
> the rest of the fleet also runs things which it breaks. Just as one example
> among many, Reverie (which Hermit our deterministic execution tool is built
> on) patches the vDSO of the processes it traces by injecting an
> mprotect()[0].
>
> So right now the hosts which want sealing need their own kernel image, and
> this option is one of the things which forces that. We're working towards
> hopefully running one kernel across the fleet, and with a boot parameter we
> can build it with CONFIG_MSEAL_SYSTEM_MAPPINGS=y, keep sealing on by
> default, and turn it off only on the hosts which run those tools.
>
> Let me know if you'd like more information. I can also put that in the
> commit message for v2.

Great, thanks for the background! Yeah it'd be good to include all that!

I guess I'm fishing for the security justification, but maybe that ship sailed
:) but it'd be helpful to also include that.

>
> 0: https://docs.rs/reverie-core/latest/reverie/vdso/index.html
>
> > > diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> > > index e75344f4e0cd..b1ec9a8a979e 100644
> > > --- a/Documentation/admin-guide/kernel-parameters.txt
> > > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > > @@ -4270,6 +4270,13 @@ Kernel parameters
> > >  	MTD_Region=	[MTD] Format:
> > >  			<name>,<region-number>[,<base>,<size>,<buswidth>,<altbuswidth>]
> > >
> > > +	mseal_system_mappings=
> > > +			[KNL,EARLY] Under CONFIG_MSEAL_SYSTEM_MAPPINGS,
> > > +			whether system mappings are sealed for this boot.
> > > +			See Documentation/userspace-api/mseal.rst.
> > > +			Format: <bool>
> > > +			Default: 1 (enabled).
> >
> > You _have_ to duplicate the list of things this breaks here please.
>
> Will do.

Thanks!

>
> > Let's negate things first. Make the boot flag 'no_mseal_sys_mappings'
> > rather than confusingly implying mseal_system_mappings=1 could enable it
> > even with a config option not provided.
> >
> > Then add something like:
> >
> > static inline bool mseal_system_mappings(void)
> > {
> >        return IS_ENABLED(CONFIG_MSEAL_SYSTEM_MAPPINGS) &&
> >               !mseal_system_mappings_disabled;
> > }
> >
> > And call that in _install_special_mapping().
>
> Makes sense. I'll call it in __install_special_mapping(), since that's where
> we already have a vma_flags_t, so it can just set VMA_SEALED_BIT without
> going near the legacy flags at all, if that sounds good? Then
> VM_SEALED_SYSMAP and all of its users can hopefully go away.

Yeah I typo'd that haha, doh! And it just happens to be a function :) yes
__install_special_mapping().

>
> > The LLM overlords tell me that only uprobe trampolines would see a delta
> > from this given the ARCH_SUPPORTS_MSEAL_SYSTEM_MAPPINGS restriction.
> >
> > This would improve things a lot.
>
> Yes, but there is a wrinkle. Since 07c308eb2bcf ("uprobes/x86: Do not leak
> trampoline vma mapping on optimization failure"), __arch_uprobe_optimize()
> unmaps a trampoline it has just created if swbp_optimize() fails, and with
> the trampoline sealed that would now fail with -EPERM. I can see two ways to
> deal with that:
>
> One is to seal trampolines too, and just leave a sealed trampoline in place
> on that path. It's already a WARN_ON_ONCE(), and get_uprobe_trampoline()
> reuses any trampoline which is in reach, so nothing is really leaked.
>
> Another way would be to keep trampolines unsealed, but that means bringing
> back some kind of per-mapping opt-in, which is exactly what we're trying to
> get rid of.
>
> What do you think? Either way I'll Cc Jiri and Oleg on it.

I think the easiest would be to just seal them too.

>
> > > +#define VM_SEALED_SYSMAP	(mseal_sysmap_enabled ? VM_SEALED : VM_NONE)
> >
> > No, you don't use the legacy VMA flags API for new work. Sorry.
> >
> > See above as to a pointer as to how this should look.
>
> Sure thing.

Thanks, but with the proposed alternative approach, we can just yeet this from
the code anyway! :)

>
> > >  static bool range_contains_unmapped(unsigned long start, unsigned long end)
> > >  {
> > >  	VMA_ITERATOR(vmi, current->mm, start);
> > > diff --git a/security/Kconfig b/security/Kconfig
> > > index f7bf6cdc6229..d5e83af1bfc6 100644
> > > --- a/security/Kconfig
> > > +++ b/security/Kconfig
> > > @@ -67,6 +67,8 @@ config MSEAL_SYSTEM_MAPPINGS
> > >  	  of writing includes CHECKPOINT_RESTORE, UML, gVisor, rr. Therefore
> > >  	  this config can't be enabled universally.
> > >
> > > +	  Sealing can be turned off at boot with "mseal_system_mappings=0".
> > > +
> >
> > 'With this configuration option set, sealing can...' right now this reads a
> > little like it's defaulted on.
> >
> > Also can we move this Kconfig option out of security and into mm please?
> > This is explicitly an mm feature, and it should never have been added there
> > (mm needs to know if somebody sets this default=y or something for
> > instance).
>
> Sure thing.

Thank!

>
> > Tests as separate commits please.
>
> Happy to do so, but aren't you worried about bisect safety? Or would you
> suggest another way?
>
> > This seems total overkill, you're checking whether a boot parameter works?
>
> It was mostly there so that the existing test wouldn't fail when booted with
> mseal_system_mappings=0, which meant parsing a bool. With a negated flag it
> can be a lot simpler, but I'm not sure which of these you'd prefer:
>
> One option is to skip if [vdso] isn't sealed, and otherwise expect all
> system mappings to be sealed. Then there's parsing at all, and it also stops
> failing on kernels built without CONFIG_MSEAL_SYSTEM_MAPPINGS, which matters
> more once it's in run_vmtests.sh. The downside is that it can't notice
> sealing being broken entirely.
>
> Another is to check /proc/cmdline for no_mseal_sys_mappings and expect the
> mappings to be unsealed if it's there. That's only a few lines now, but the
> test still fails on kernels without the option, as it does today.
>
> Do you have a preference between the two?
>

Yeah it's awkward, really moving the tests to mm we'd have to skip them if the
vdso isn't sealed, then assume a sealed vdso for a new process = feature
enabled.

I guess at that point it's redundant to check if disabled?

> Thanks a lot for the review!

No worries!

--
Cheers, Lorenzo

