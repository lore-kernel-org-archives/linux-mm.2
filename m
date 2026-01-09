Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84E46D26D7D
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 18:56:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB1FB6B008A; Fri,  9 Jan 2026 13:56:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E72436B008C; Fri,  9 Jan 2026 13:56:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6ACA6B0092; Fri,  9 Jan 2026 13:56:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C54576B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 13:56:03 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5C683C28A7
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:56:03 +0000 (UTC)
X-FDA: 84313330206.24.30BD92B
Received: from mail-10631.protonmail.ch (mail-10631.protonmail.ch [79.135.106.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 56566100006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 18:56:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=DxtMSMqf;
	spf=pass (imf14.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767984961; a=rsa-sha256;
	cv=none;
	b=vDxoWfFzXGhowdDsDslieZmJClccM0qEbT2I+dMa9BujJJF7ncfqWpDGolNuEuL9eIDYa9
	vehnBIWyuPfkbaARgZTJQ6jblIcom4Q0aO8TDiT4p/VZIAracygcMPHjSndm5jV53neV/0
	oDUUY2gPFDkAX9BwHQXfy/vQ1QQY6+M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=DxtMSMqf;
	spf=pass (imf14.hostedemail.com: domain of m.wieczorretman@pm.me designates 79.135.106.31 as permitted sender) smtp.mailfrom=m.wieczorretman@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767984961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UALVR12QqyIFzAEC/BHtozvGGQ/3JPuZHtUGAMu4oTI=;
	b=b/hMWQpUmNgt+TFyup37w2E3e0JYHNihyKL8THjIxuqOczNM9HyzxaGfeUI7sNp+S6xqE3
	VvKwIs7wz1MBj9+Pk00Om+qtMsz36ob1ETwQOSdxUuQc6/eGRq96IWd5dtwhoHDGGnoaM9
	nSeXC3syGWSEzeGly0ASIW3GErO2VxQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1767984958; x=1768244158;
	bh=UALVR12QqyIFzAEC/BHtozvGGQ/3JPuZHtUGAMu4oTI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=DxtMSMqf0NjIX7q/GwRLGGRyaLrR3pjtg8whdsPEeCfC8pbpHcK9El2oCEmf0u3zO
	 21ELY7/Ih5CGb2Bgi509qaxzj/LJe0xG1MpjesTxEMzI04n2CfDPupaUu5gnLRKyjs
	 wi4RiVT8THa1Ujw1NoSYDvD1FXdhZEYfRD0ux4nBVZsiQy/7wlxwa5PuKdB+o4h3cc
	 NSfgKmgHuy1M5Lb00f7AA8ieJLi91YKghw7XSpY9rcOsB2i81fSQiXQI+IMLhooPaL
	 MipZAonFsUdn8CG7UbOPnaCdpNs34zt92PQIEZFd3hGKTSRm4o1WFZmCw2lutjCh6e
	 k9jYAYMI/Be7Q==
Date: Fri, 09 Jan 2026 18:55:53 +0000
To: =?utf-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
From: Maciej Wieczor-Retman <m.wieczorretman@pm.me>
Cc: Kees Cook <kees@kernel.org>, joonki.min@samsung-slsi.corp-partner.google.com, Andrew Morton <akpm@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, Danilo Krummrich <dakr@kernel.org>, jiayuan.chen@linux.dev, syzbot+997752115a851cb0cf36@syzkaller.appspotmail.com, Maciej Wieczor-Retman <maciej.wieczor-retman@intel.com>, kasan-dev@googlegroups.com, Kernel hackers <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: KASAN vs realloc
Message-ID: <aWFKEDwwihxGIbQA@wieczorr-mobl1.localdomain>
In-Reply-To: <CANP3RGcNFgLSgKYPjmro2s1Es04Pnhf+4wHpnSwRX4M8bLDW9g@mail.gmail.com>
References: <CANP3RGeuRW53vukDy7WDO3FiVgu34-xVJYkfpm08oLO3odYFrA@mail.gmail.com> <202601071226.8DF7C63@keescook> <btracv3snpi6l4b5upqvag6qz3j4d2k7l7qgzj665ft5m7bn22@m3y73eir2tnt> <CANP3RGfLXptZp6widUEyvVzicAB=dwcSx3k7MLtQozhO0NuxZw@mail.gmail.com> <CANP3RGeaEQipgRvk2FedpN54Rrq=fKdLs3PN4_+DThpeqQmTXA@mail.gmail.com> <CANP3RGcNFgLSgKYPjmro2s1Es04Pnhf+4wHpnSwRX4M8bLDW9g@mail.gmail.com>
Feedback-ID: 164464600:user:proton
X-Pm-Message-ID: 1cbd7ae2e801abbef632dd9ee50f89616142157f
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: syj8a8hf9wqkf6myx4rrtu9duirauy6d
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 56566100006
X-Rspam-User: 
X-HE-Tag: 1767984961-452438
X-HE-Meta: U2FsdGVkX1/UV+4tD1iH1lFKzEBqk1VprIQM0dWZ0ZEC9bmg3aauz1jKkXLu7L7vGFgYdQoeAu8uzax68fwqCLwPXMJoDURTQ5JLLEwUlgq5qUvqtdvBDPnswVl/cMdFOI1ShP5LI4QFRp6xBkPbE/iHh7zIvDlLVFXk3GEXhIx9A77QmFzA0QYjR0EJZ4B1RBPIkYjRueaadzP3plhwVQADRwTD4FbJtsx7UYDdZmwTuiSemQGsblhQJVMzgUyOqG4QR5/C6HIq415HesWglxuU9UEG132IMYB5mSFXJ8xtHWK523GHNGrdbPuDD1NVEaEMq9HXCE5TnRct0Adt77Yg8XOxm27NlPAgzseve1r3Rn434YO19qpNMnY9SbKiv9BunGISi3n93MQ4B9RVfPKOBWUL8Xf2T+7tg05wf9jQggKf9z1L+CRM694YjRf6K7t2VNmAD7cc70Vu06qf1yHukZlgb9Y0MHmYVGdtQub+HrD+/CDFMIa8xpt20RJfpIYnGREEV1+RfmrZkwtdeMcr7d8hj2wX5THklreW8lhYbbZKWhjE6+oOpP54a9NfYYLZ81Q72dStK3jhuS2NjaKm5tYV0COBeEEJdO7dvefM/oeZR9My19l419acHHv6bUdUMcM2jDZ0kxLLOX4kZeV95N3ZDiCnYejctp8lf1nhYzxPUjncGIHz6GvJY1BrSSnDAOzYQJRVNbrRx3MurdEKu6FseF/Bts500IbxOraMarzthkxfuD2QKzr93yR2Qna7mI2B5rhoziGhIrOWbuziUgIIil03iSd7+wLh0eR7uAQtTQzjh+yRA/ZxyC3lM/N8OMo6KxxUHr+Fh/38A34RY/b0EKRO3RVP7pWxMx9mlHQK+7dWTsfueZ7rloRgaIhAMqoFjXVW6tZOfPBM6iCG5AmaX7kY0OxqS/gki0Ux+X/ZjOeDL3bW0ICKacAD9H47M813gduheDrCGEs
 1z6GLE7M
 o78YEh1XCni+YsOEcuyolgl9NWcchcgvFqXRMDLnyJuLIaxB1f3l0oD0Uo5T558fdD20fnNbnkAmM3s4yl/2gzer+wTl5ZVq4pKOD9A2ZKJkmfJZtc3qUek15c46wBttCUrHx3w9P/UITsDhe86b0zHLTMkax5Vpm/WdrVFnIrfcxB2NNjGMyB/wGxRD4Yrxq8gghQT72+XY4zwqJRrF7ydrr6d0Ly98oZDL/aR46gx/l8DvdSyz6POke0mVIM7zgWYnJifzqUJ+kAlo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Okay, so as I understand it, the issue is centered around adding a size to =
the
pointer - because in that case it can be unaligned and it can trigger warni=
ngs.

So what do you think about changing these two:

=09=09kasan_poison_vmalloc(p + size, old_size - size);
=09=09kasan_unpoison_vmalloc(p + old_size, size - old_size,

into something along these lines:

=09=09kasan_poison_vmalloc(round_up(p + size, KASAN_GRANULE_SIZE), old_size=
 - size);
=09=09kasan_unpoison_vmalloc(p + round_down(old_size,=09KASAN_GRANULE_SIZE)=
, size - old_size,

From what I've read in the code the second argument should be rounded_up() =
at
some point anyway. In the shrinking case we don't want to poison the last
granule of the new reallocated memory chunk so we round_up(size). And in th=
e
enlarging case it would be just as correct to give up on adding anything to=
 the
'p' pointer - but that'd be inefficient since we don't need to KASAN-touch =
this
memory chunk - so we round_down the lower boundry to get all of the new spa=
ce in
KASAN aligned chunks.

Did I get it correctly? Or is there some flaw in the logic above?

--=20
Kind regards
Maciej Wiecz=C3=B3r-Retman

On 2026-01-07 at 22:55:21 +0100, Maciej =C5=BBenczykowski wrote:
>> WARNING: Actually I'm not sure if this is the *right* stack trace.
>> This might be on a bare 6.18 without the latest extra 4 patches.
>> I'm not finding a more recent stack trace.
>
>Found comments from Samsung dev:
>
>But another panic came after those fixes [ie. 4 patches] applied.
>struct bpf_insn_aux_data is 88byte, so panic on warn set when old_size
>ends with 0x8.
>It seems like vrealloc cannot handle that case.
>
>  84.536021] [4:     netbpfload:  771] ------------[ cut here ]-----------=
-
>[   84.536196] [4:     netbpfload:  771] WARNING: CPU: 4 PID: 771 at
>mm/kasan/shadow.c:174 __kasan_unpoison_vmalloc+0x94/0xa0
>....
>[   84.773445] [4:     netbpfload:  771] CPU: 4 UID: 0 PID: 771 Comm:
>netbpfload Tainted: G           OE
>6.18.1-android17-0-g41be44edb8d5-4k #1 PREEMPT
>70442b615e7d1d560808f482eb5d71810120225e
>[   84.789323] [4:     netbpfload:  771] Tainted: [O]=3DOOT_MODULE,
>[E]=3DUNSIGNED_MODULE
>[   84.795311] [4:     netbpfload:  771] Hardware name: Samsung xxxx
>[   84.802519] [4:     netbpfload:  771] pstate: 03402005 (nzcv daif
>+PAN -UAO +TCO +DIT -SSBS BTYPE=3D--)
>[   84.810152] [4:     netbpfload:  771] pc : __kasan_unpoison_vmalloc+0x9=
4/0xa0
>[   84.815708] [4:     netbpfload:  771] lr : __kasan_unpoison_vmalloc+0x2=
4/0xa0
>[   84.821264] [4:     netbpfload:  771] sp : ffffffc0a97e77a0
>[   84.825256] [4:     netbpfload:  771] x29: ffffffc0a97e77a0 x28:
>3bffff8837198670 x27: 0000000000008000
>[   84.833069] [4:     netbpfload:  771] x26: 41ffff8837ef8e00 x25:
>ffffffffffffffa8 x24: 00000000000071c8
>[   84.840880] [4:     netbpfload:  771] x23: 0000000000000001 x22:
>00000000ffffffff x21: 000000000000000e
>[   84.848694] [4:     netbpfload:  771] x20: 0000000000000058 x19:
>c3ffffc0a8f271c8 x18: ffffffc082f1c100
>[   84.856504] [4:     netbpfload:  771] x17: 000000003688d116 x16:
>000000003688d116 x15: ffffff8837efff80
>[   84.864317] [4:     netbpfload:  771] x14: 0000000000000180 x13:
>0000000000000000 x12: e6ffff8837eff700
>[   84.872129] [4:     netbpfload:  771] x11: 0000000000000041 x10:
>0000000000000000 x9 : fffffffebf800000
>[   84.879941] [4:     netbpfload:  771] x8 : ffffffc0a8f271c8 x7 :
>0000000000000000 x6 : ffffffc0805bef3c
>[   84.887754] [4:     netbpfload:  771] x5 : 0000000000000000 x4 :
>0000000000000000 x3 : ffffffc080234b6c
>[   84.895566] [4:     netbpfload:  771] x2 : 000000000000000e x1 :
>0000000000000058 x0 : 0000000000000001
>[   84.903377] [4:     netbpfload:  771] Call trace:
>[   84.906502] [4:     netbpfload:  771]  __kasan_unpoison_vmalloc+0x94/0x=
a0 (P)
>[   84.912058] [4:     netbpfload:  771]  vrealloc_node_align_noprof+0xdc/=
0x2e4
>[   84.917525] [4:     netbpfload:  771]  bpf_patch_insn_data+0xb0/0x378
>[   84.922384] [4:     netbpfload:  771]  bpf_check+0x25a4/0x8ef0
>[   84.926638] [4:     netbpfload:  771]  bpf_prog_load+0x8dc/0x990
>[   84.931065] [4:     netbpfload:  771]  __sys_bpf+0x340/0x524
>
>[   79.334574][  T827] bpf_patch_insn_data: insn_aux_data size realloc
>at abffffc08ef41000 to 330
>[   79.334919][  T827] bpf_patch_insn_data: insn_aux_data at 55ffffc0a9c00=
000
>
>[   79.335151][  T827] bpf_patch_insn_data: insn_aux_data size realloc
>at 55ffffc0a9c00000 to 331
>[   79.336331][  T827] vrealloc_node_align_noprof: p=3D55ffffc0a9c00000
>old_size=3D7170
>[   79.343898][  T827] vrealloc_node_align_noprof: size=3D71c8 alloced_siz=
e=3D8000
>[   79.350782][  T827] bpf_patch_insn_data: insn_aux_data at 55ffffc0a9c00=
000
>
>[   79.357591][  T827] bpf_patch_insn_data: insn_aux_data size realloc
>at 55ffffc0a9c00000 to 332
>[   79.366174][  T827] vrealloc_node_align_noprof: p=3D55ffffc0a9c00000
>old_size=3D71c8
>[   79.373588][  T827] vrealloc_node_align_noprof: size=3D7220 alloced_siz=
e=3D8000
>[   79.380485][  T827] kasan_unpoison: after kasan_reset_tag
>addr=3Dffffffc0a9c071c8(granule mask=3Df)
>
>I added 8 bytes dummy data to avoid "p + old_size" was not ended with
>8, it booted well.
>
>diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
>index 4c497e839526..f9d3448321e8 100644
>--- a/include/linux/bpf_verifier.h
>+++ b/include/linux/bpf_verifier.h
>@@ -581,6 +581,7 @@ struct bpf_insn_aux_data {
>        u32 scc;
>        /* registers alive before this instruction. */
>        u16 live_regs_before;
>+       u16 buf[4];     // TEST
> };
>
>maze: Likely if 8 bytes worked then 'u8 buf[7]' would too?
>
>it will be 88bytes + 7 bytes =3D 95 bytes(=3D0x5f) which is in the range
>of granule mask(=3D0xf)
>
>I don't think it works, but it works.


