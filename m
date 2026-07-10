Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70459C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 21:51:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 367FD6B00D2; Fri, 10 Jul 2026 17:51:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3191C6B00D3; Fri, 10 Jul 2026 17:51:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22EA16B00D4; Fri, 10 Jul 2026 17:51:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E6EE46B00D2
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 17:51:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7F77E8FC14
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:51:41 +0000 (UTC)
X-FDA: 84974214402.10.760842A
Received: from mail-24426.protonmail.ch (mail-24426.protonmail.ch [109.224.244.26])
	by imf31.hostedemail.com (Postfix) with ESMTP id 1501620002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 21:51:38 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=YUTixyXP;
	dmarc=pass (policy=quarantine) header.from=proton.me;
	spf=pass (imf31.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 109.224.244.26 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783720299;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1KkGK1kZyuzsCnW+0aqDpWwzXOCREZm2ehoIG/qf+7Y=;
	b=EXJkc/yi3tpd5anfqK4jRcLgmX84ZIhHSX91w+JODHIdJKtdPxIP2ZjaHcF7ENpgMkwj1Q
	oCinRDFGpkjCCMcuZcf/g0RcA31uKprv7KlUtHS5wHaJm+gUeHXG7uxzx5nD6/ne79z6js
	IK2kT/kr/Osnch6lILkR9fJyr+YQyfQ=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=proton.me header.s=protonmail header.b=YUTixyXP;
	dmarc=pass (policy=quarantine) header.from=proton.me;
	spf=pass (imf31.hostedemail.com: domain of BoxStrikesTeam@proton.me designates 109.224.244.26 as permitted sender) smtp.mailfrom=BoxStrikesTeam@proton.me
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783720299;
	b=kce3P4ZH2L7p76SpoCIahN4Hfn49RdhrKkj1cWTm3RhRzYnMtKTjzSWqwT7qT/f7aECyCy
	fJuMJ1tFfSDQyzLVlhvGACwmJS7B9A2QoP03MWukidtsfIdcS/ujsuWsaqCZEedIm6RyjN
	+0F1yHUgq2ENHXuIwAPuT9qqBzikxEk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1783720297; x=1783979497;
	bh=1KkGK1kZyuzsCnW+0aqDpWwzXOCREZm2ehoIG/qf+7Y=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=YUTixyXPS+Mk4wmT8TNaCmlnNvCyNA67r16JcsD/cWMvbyYFn4yVPMsd5b/jlTPTk
	 fv8hSZdZGZjRpek1TGR2PGXygT+RGBQG0ixcBHj2MxZ5RL9wCqE1WjLDUaTrlWEfxx
	 6wIPOfPEGfOEE9WIimC2zjUbKCrZlP38nSc/ITp5ICJ85KlaTZZyWD1zki6RShIDC+
	 ogoPeQGcONmiynw/+fxKlM0YfCem4bCrG4Sk9OpLqOy89d1B7lzKqRxOdmrrO+x66A
	 8kqOGH0l3p4okL5RVRTJyT4j+Ou6eBd5xP1lZ1F7uVZWEeZadshJ2MaipXIqNTSCeP
	 4K4TFneqMkyjQ==
Date: Fri, 10 Jul 2026 21:51:32 +0000
To: "paul@paul-moore.com" <paul@paul-moore.com>
From: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "rppt@kernel.org" <rppt@kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "serge@hallyn.com" <serge@hallyn.com>, "jmorris@namei.org" <jmorris@namei.org>
Subject: =?utf-8?Q?=C4=B0lt:_Re:_[RESEND][RFC/discuss]_memfd=5Fsecret():_opt-in_visibility_for_security_monitoring_(eBPF/audit)?=
Message-ID: <efkpRkpZ91GfphzYue7OEdLG9WrkPjQx8RXvL3JZb0Fme2DTmcpkqBd3joAD25QFVfCnBY_TMNh2aHMwGRMySeMX0Bs34hN3sBphdj23nGk=@proton.me>
In-Reply-To: <CAHC9VhSWs4=-BN09XWUsJXh+9HB5zeYa0oiRsRNGb4s_sTW2HQ@mail.gmail.com>
References: <MZlCECz5s73hPgQxtqWZ2VbXNTCZnItnwMHu2iZQlRC6ba0B9GuqxT2EhvhwQ-uanBDsNn7Bg09nGVynBHdmSsiRjhyI1udkYbqOoPfpe6w=@proton.me> <CAHC9VhSWs4=-BN09XWUsJXh+9HB5zeYa0oiRsRNGb4s_sTW2HQ@mail.gmail.com>
Feedback-ID: 205449183:user:proton
X-Pm-Message-ID: 1f7ae8acb79f3cb6c99407764188494a0a0ba779
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ub1b3gmky1kwjauxxykzd1jc5t75yd3m
X-Rspamd-Queue-Id: 1501620002
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783720298-852568
X-HE-Meta: U2FsdGVkX19JsbEvVaBvmle5T7IwDqDZnrDDsEsBYqe4kSSotJpqsjABqc5zvGhunLVewHGPYMyYlOPeSFHbian2Y56WTuTQwRBydMg+uuIewAWIxrCdkNBN7lC3R9khmZYVxU4MLl38Ox6b/Imhj5AIFp6y92kbss+1HXk5QClLgxLCKRC2YpNkWAxrhre1/z9EcWgDke/lFrOkuuT6XZmKRm/z9pic42wrU0kzpe8mSsDYfI7sTDOGyK9dK6B2rinA25hq5BVNffGgtrh7AQxG6iVl3l5O32t0kjSt6YDA1wR3hMbIEuWQTfWstww8MxtkGXFFAwhQTQBORrdS9LY9eBZkizW6prazK3On12yJQb94Y2YuxDmzN4rYsl+3uHJ6L5fbKGBECnDQUJdbWh6s/g4LLvqSRNW2DVxZf0gZYBcCTWaDG89fX6ohXAVpGuD9YNd3RKXMqueif8Kti3feF3K/wryIBo7veISXX4dCt6yIwzMp41/5HjnrbnQlWI/4X6o8XTlq4qwblbgdfVVdNQ5s96AkkRYcgksdsuy+JbJQKH5luc6K7e/ek/GN6MG475MOmAnPMYAL53fyHi6zvhJ+e5IEqwIm4VbgeSm0PenkYBC/usaR9/yHrIJRIGCmZzCM2gnu0jpcVfoETAR0zJRgmbywlxC4t6fB4HjLxU1ve0jW5D3a0e9uOqXY7J0MkCwGFBTg4XGBrkbEMgHiqHPaRMvASVAoL7efuLeJqeIayhzJXNKncRQJr8aMGkU9XeN+Y32oSJ/ItgekvlM+yi4rkpU0wc4TRjlUHa3FrZ2dX3cJheD6YDsgKY9A0fLUlBfD0V1+rtRFcH9QNLKxEavWbuX4tMenVBOp6Xf3G27VNxRR/Zo3yfall0/gSH7lwu27MUz8y3kH/dPzzZrsm99mwhEV5+xgEkTZMUjehRI4LRAVOkKypOaCGKavibIFdKRmnIPSEekb7rd
 CDhc4F16
 YyXNqN65MXZrbDWMgzZDYXolrIfNhms2PSnbliZtm7l/tiYdPrBFpJ0Q8nSB5zfbkUrn2mKYg3bBXuwtllyPJBAZBm5m/WZIUmR+2gWuaKXDaw03Ogzna77QNJsmL+mR7ywTz2X60Ta20dQ2RYOMGrEiFQRRkuHtdKwBR/RWRPrYxK2PS9zPmgdBjEHzpemNat+M6/2/+Det5cy5I+kwZNsF6cl8gR/rLLf5MtcrTxWvbJdcE4GK9bFLlnOtEao0elqbTPfumeO/ITPpYA1aZi0t4R3R7c5g/hETyhNbY8KlHqMDv6sL9LzuPDf/BFrkqqpY1qcy82bh/xmWtaKlwQLfN4ooWwLHCsVBCBW1zTD+9iyvMjFdy/dXv1sB/r5ACWjWocUTliVHWzICZ2nUQdniauR26ZulNh86wgnnE61/eG9YazIRkTXW4ariH9SWifQhb6Ar0Zc8aa27yWEqUqZN2/A1MzId4UPmeivO+MSYDX8ckyK0Y0FJPP7MuCIKyNhDIAzP+mq6hyUB0w/zW0lZfSg7aodqY4zIOY3LELWV+h17U6vbQVQ4qD/TMZofh0g5BWt8aDPGCywMCp87GdsDWaCWoJOGY/AxE9Vui12a0JgyHwWJ61RgbidloyLEFL7dN+XTRWH4WmcLW8BXV+JrSdgC2UZo2wNKpd8ZRDzJWIYCTBbVg2QSCLTAlV41KAY7E1VNdUriW5ti/sI43ZuCtYiVE4ff8RBfb4MbMJ7mw0Z3kCn0JVxJcg2/9wBDs4J0x0rxLX+2htBVkH1KQ/QvEdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>





Proton Mail g=C3=BCvenli e-posta ile g=C3=B6nderildi.

------- Forwarded Message -------
Kimden: Paul Moore <paul@paul-moore.com>
Tarih: 11 Temmuz 2026 Cumartesi saat 00:00
Konu: Re: [RESEND][RFC/discuss] memfd_secret(): opt-in visibility for secur=
ity monitoring (eBPF/audit)
Kime: BoxStrikesTeam <BoxStrikesTeam@proton.me>
CC: rppt@kernel.org <rppt@kernel.org>, akpm@linux-foundation.org <akpm@linu=
x-foundation.org>, linux-mm@kvack.org <linux-mm@kvack.org>, linux-security-=
module@vger.kernel.org <linux-security-module@vger.kernel.org>, jmorris@nam=
ei.org <jmorris@namei.org>, serge@hallyn.com <serge@hallyn.com>


> On Thu, Jul 9, 2026 at 1:14=E2=80=AFAM BoxStrikesTeam <BoxStrikesTeam@pro=
ton.me> wrote:
> > Paul,
> >
> > Thanks - I found the Gottsche/inode_init_security_anon() thread and can=
 see it landed. That answers (a) cleanly: labeling exists, policy can be la=
yered on top via SELinux/AppArmor if a site wants alerting on memfd_secret(=
) creation. Good to have that confirmed as already solved.
> >
> > On (b), let me push on it a bit further, because I think it's worth spe=
lling out explicitly rather than dropping it.
> >
> > My concern: as it stands, an unprivileged process can populate a memfd_=
secret() region and mseal() the mapping, producing memory that is (a) unrea=
dable by any kernel-side introspection path, including root-owned eBPF trac=
ing programs, and (b) can't be coerced back into an inspectable state via m=
protect/munmap. From a host-based detection standpoint that's a blind spot =
an attacker can use to park a payload where a CAP_BPF-privileged monitoring=
 agent - something that in most other respects can inspect any process on t=
he box - simply cannot look, no matter what capabilities it holds.
> >
> > I understand the objection this invites, and I want to address it direc=
tly rather than pretend it isn't there: the memfd_secret() man page is expl=
icit that its ROP protection rests on the absence of any in-kernel primitiv=
e for reading this memory. If I'm reading that right, the objection to (b) =
is that adding any such primitive - however capability-gated - re-creates e=
xactly the artifact a ROP chain would want to call, undermining the "no pri=
mitive exists" property regardless of who's nominally allowed to invoke it.
> >
> > I don't think that objection is wrong, but I'm not sure it's fully disp=
ositive either, and I'd like to hear the maintainers' take on the tradeoff =
explicitly:
> >
> > - The ROP threat model assumes an attacker who already has arbitrary ke=
rnel code execution (they're calling kernel functions directly). If they ha=
ve that, they can likely already walk page tables and reconstruct the mappi=
ng by hand - the primitive removal raises the bar, but per the design's own=
 caveat ("no 100% guarantee"), it was never advertised as absolute.
> > - The (b) scenario I'm raising is a different actor: a legitimate, priv=
ileged, kernel-mediated monitoring agent (eBPF LSM/tracing program) operati=
ng through the normal verifier-checked helper path, not an attacker executi=
ng arbitrary kernel code via a ROP chain. Conflating "any code path that ca=
n read this memory" with "a gadget a ROP chain can call" may be overly cons=
ervative if the new path is narrowly scoped (e.g., a new bpf_probe_read_sec=
retmem() helper, verifier-restricted to CAP_PERFMON|CAP_BPF programs, opt-i=
n per region via a memfd_secret() flag the owning process must set at creat=
ion time).
> >
> > If that distinction doesn't hold up - if any additional kernel-callable=
 read path is considered equally exploitable regardless of gating - I'd gen=
uinely like to understand why, since it would mean the confidentiality guar=
antee is fundamentally incompatible with any form of authorized introspecti=
on, which seems worth stating plainly in the documentation for anyone build=
ing EDR/monitoring tooling around eBPF.
> >
> > Even if (b) is rejected, I believe explicitly documenting that memfd_se=
cret()+mseal() creates an introspection-proof region would be valuable for =
the security community, so EDR vendors can adjust their threat models accor=
dingly.
>
> To be very honest, I'm not too concerned about out-of-tree, security
> products; I'm focused on the in-tree kernel code.  If you are
> concerned about userspace making use of memfd_secret(), you could
> block the operation on a per-process/domain basis using either seccomp
> or SELinux (other LSMs may have similar functionality, that's an
> exercise left to the reader).
>
> Also, it is important to note that if you find the kernel
> documentation lacking in a particular area, I would encourage you to
> submit a patch to address the shortcomings.
>
> --
> paul-moore.com
>


Paul,

Thanks for the discussion and for the pointer to secretmem_file_create() =
=E2=80=94 that resolves (a) for me.

On (b), I've thought about it further and agree a kernel patch isn't the ri=
ght answer here. A few closing observations for the record:

1. Dynamic detection isn't actually closed off by memfd_secret()+mseal(). E=
very syscall a payload makes traps through the normal syscall entry path, a=
nd pt_regs->ip at that point reflects the calling address regardless of whe=
ther that address sits inside a secretmem VMA. Cross-referencing that IP ag=
ainst /proc/pid/maps (or vma->vm_start/vm_end in-kernel) lets a tracer attr=
ibute syscalls to a secretmem-backed region without ever reading the region=
's contents. So the confidentiality guarantee holds, but it doesn't buy an =
attacker syscall-level anonymity =E2=80=94 only content opacity.

2. That said, I recognize this is a bypassable heuristic on its own (an att=
acker can proxy syscalls through a separate, non-secretmem code path), whic=
h is why I don't think dynamic detection alone is a complete answer either.

3. The more durable idea, I think, is one that doesn't touch confidentialit=
y at all: hooking the memfd_secret()/mmap()/mseal() call sites and building=
 a signature purely from call metadata =E2=80=94 arguments, region size, pr=
otection flags, and the sequence/timing of these calls =E2=80=94 rather tha=
n from region contents. This gives EDR/eBPF tooling something for static/be=
havioral matching without requiring any new in-kernel read primitive, since=
 none of that metadata is protected by secretmem's threat model. This is ac=
hievable entirely in userspace/eBPF today with existing hooks, so no kernel=
 change is needed for it either.

Given that, I don't think there's a kernel patch to propose here. This look=
s like it's squarely a detection-engineering problem for security products =
to solve on top of existing tracepoints, not a kernel gap. I'll leave the f=
ollow-through on that side to the community.

Thanks again for engaging with this =E2=80=94 appreciated the back and fort=
h.

Best,
Eneshan Erdo=C4=9Fan Karaca

