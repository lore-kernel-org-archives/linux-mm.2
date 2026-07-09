Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B3EDC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 02:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B74E86B0088; Wed,  8 Jul 2026 22:21:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C806B008A; Wed,  8 Jul 2026 22:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3CA46B008C; Wed,  8 Jul 2026 22:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66C406B0088
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 22:21:45 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D55328D4A1
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:21:44 +0000 (UTC)
X-FDA: 84967637328.08.4DC1BEE
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC90F40002
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 02:21:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=HHnBwscD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783563703;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ujdbWcKs5QrHmjMr7suLiT2KeQNYhawhbrLCyECtjEQ=;
	b=0vAUvEwqJ2ut/HPqttvv1D7MyDUZlsuCQzt4QDxve4OXzvNo8wIsABv+Cn0hRUQW5YLIKW
	LEQyMhqMccSXeJahXF+b89ZBoFue2VSyAoq/m1odA47H7L6e+bLJr+K2mAtDOf5kSrKnP6
	P/tWgRsyQWko9YUy7zTa1jjjHLTc5u8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=paul-moore.com header.s=google header.b=HHnBwscD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of paul@paul-moore.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=paul@paul-moore.com;
	dmarc=pass (policy=none) header.from=paul-moore.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783563703;
	b=Z9v+iBVFs6p/8+2F7BwDPhbl/hEkVbFzugj18cmQvldjqG68L61VcRVrfJpWDyu0MqWuw1
	ADypjxCh5kV9LbuH4nIQrJ6rHoc4dj2rmS/tvhJ2Ppz6RH5DY/8zNwnPzIjBQPRNunAxxj
	1g7xGU1OGM4DI+6Z5Lm3+tU1AOjZU9M=
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8423f236418so975955b3a.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 19:21:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783563702; cv=none;
        d=google.com; s=arc-20260327;
        b=LUkvsaoyxfLkJ4SPVwSsfmGFsDwJ0LZ38RgFyf/StDYfl5ZXG28yiRlvLOG7pS2rgQ
         yaEK+Syo8CRYcQ32PmQHET7fvNBnzjgxq0j65uqgkG7sX23Q6nBA6MDAe3TiwSHGWAbW
         u5YQmJ5sZcSEAQk9GcHjmxh28eLEDfXwuF56+wTzM6UeX5HLxgFqQhBl6sMBt07trUbm
         G1FonPZeIcBwRWwi8LiiyEDN7/6cnBhDvxfrieRhmfoedFMfOhuE8oKm+T6XoA4cAmA/
         0UJIfsOTI4Ji4NkXuDDN3t/fO5+tWpDkBeGRBA1dnEwWA7eePUdEtevyliO47ixAjdv1
         XyFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ujdbWcKs5QrHmjMr7suLiT2KeQNYhawhbrLCyECtjEQ=;
        fh=dMBu8pz2hYIGCiZmVD+/HSM48BZfAvtSwZyaM5dflFo=;
        b=msIEgl+yXiABvyXgdBbTm5heIyKaf6tvThwzmVkYf0iUgO9FXCtvb5myDlhiloYf5e
         /3jbv4DTYOdn0QT8ymAT6+ySvr81Wi/MK8FVthUAjsjl7G5j9YFGnY3pPY9dHIrHXd5T
         zbtI2zG14afW9LzOgahdbUwOV8U8uVhbeM3p+33ubsil/Rsk6f7jl4GtOAz/CoMHp0I1
         xC5Jz1CBMLFcIwlmYxVekJPsNMOEjwEF7M1U0KqgfAb65N177yNnxsbWPUz4gtUN7AcV
         sBlK3N/AS3KjjiYock+3izcVF/HhSRVox1BugByqxavKG/nrOW1C2Bh67k2V0F8QVcJl
         PJ9w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1783563702; x=1784168502; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ujdbWcKs5QrHmjMr7suLiT2KeQNYhawhbrLCyECtjEQ=;
        b=HHnBwscDwRKzjRGBfDd4vhm7IdaGSrD/D0t6vPBcLDSYWrihjVuOcn2lBeKp2Y+nKz
         Yqqpi0L+Rg+oyGEQzAOVL1Lt8tS2Q3L3+MllH/wOc3AohJn7s4JbVf1PP5EGaVy/hiW0
         gksmmfILBTXUiBaIbsLBTVowr95jqi3zupNhcKTstgRXemEt7/nNmdjfOr3hlS29AkjC
         inlyP73tyg+KtucLjGeseZ/HyBUcrNYIlw3COQguJl9pAZa05/Mt7DonyGWojMCzfMd9
         vYWViRVm0tdjNBvDRDdGum+eecme3uZNR8uuEktTfRBf0SiygjX9NRnl5mWkv6c3gb8Z
         KsMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783563702; x=1784168502;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ujdbWcKs5QrHmjMr7suLiT2KeQNYhawhbrLCyECtjEQ=;
        b=JM2EzigYBTf67k93M3Bi/CDo4liTD2D1i7Bp2LFRwMv4/DwX2ssyahO7/Z45w5/M5b
         xqDXTIJeU7qxlXupeKVDhdZ9z9TIu4nzVgACr0Tgyfk+Zqi/XJjJftRUU+OWO8YD3qU3
         4Yk/mnDr9/qh+wshyfHndWH35wul+697M6TaJYOJFPUyFKma02Bm58xd5sr0qU0tzJ+1
         IGEbGAZ6hI79840Qxn/BiLlm+r01YldMImvzJy+QmfwrhxN+80VgKsPNznltKAfcTFYU
         sCMwBAGoLx1Ul9Sn4o/oB0CewYJm/BootvqAkxeMDgFofeKcbRA7tmk6oGBb7vrntvqA
         Rvww==
X-Forwarded-Encrypted: i=1; AHgh+RqGHq2kfh9ectEAmK/Qb2lsyD9uxno8XEi2yVGAtSmI1v4aKg7q+deDiK7ysUuwsb2G7lp0feRAyQ==@kvack.org
X-Gm-Message-State: AOJu0YzYJGDHwZ3hrYg1+QIm5bBhi3oqigAa8Bco15cSIjGGO9gZOwLF
	drQA2nXvhSV9FL4xifIKibQmHZ9zlDQ3rHbux+FY2ge2VQMbP1hRgG9STpjN5/mqPa9jcB9QVO8
	hjQSHipP3b7XHnkU6871NAg85NJtetAB/uOrV7KLQmDS7jeHHjy6J5Q==
X-Gm-Gg: AfdE7cnfcBotRiuiGZAIO1bbk7Fh5mklWM5RcVXbj1tpG4p8e2QTQhZhxLplEDqVW/R
	ei1XKZCBNdTqi0umBS/sFWwwp6IO8MdhFMZFAoE2FHGR1q9E91A/qatdNDuC+iwX/Y3OV5sZSaH
	vnO1ZiPL8pSHTeG9YXpZZhsznOUViCi6dQS7V/P6TIZQuSrJNyHdiV6t2AvgGWvLCltXyJVNrWr
	PbjlSuynuiIflc0njH2suEQzudQPzeXxrEFKaGJ6K2Mdlv3g8kkDwqZrtOem5YdjYjGrvmV
X-Received: by 2002:a05:6a00:3cca:b0:845:e43b:ae7a with SMTP id
 d2e1a72fcca58-8484368e1eemr5018505b3a.62.1783563701741; Wed, 08 Jul 2026
 19:21:41 -0700 (PDT)
MIME-Version: 1.0
References: <umQp9Qs18vw53oZDFIgYE4MyUWNemeNL8-Vbs-BOYEvQByiyPSZ3RrEvOpmdWUZ1YtjEHpjlgZnMo5DkJuJziwrKWTYS_A0QF_B3ixToMBY=@proton.me>
In-Reply-To: <umQp9Qs18vw53oZDFIgYE4MyUWNemeNL8-Vbs-BOYEvQByiyPSZ3RrEvOpmdWUZ1YtjEHpjlgZnMo5DkJuJziwrKWTYS_A0QF_B3ixToMBY=@proton.me>
From: Paul Moore <paul@paul-moore.com>
Date: Wed, 8 Jul 2026 22:21:29 -0400
X-Gm-Features: AVVi8Cf8epDZUvAGsMWUetpWhJurNwoB-tiGg2Boh_8Edu32EBPYzzzvT_qTOLg
Message-ID: <CAHC9VhRCo1nc2qLfq=Fk9Q26vjSOUBgfM8wV6U4S+Hv1KM9LNQ@mail.gmail.com>
Subject: Re: [RFC/discuss] memfd_secret(): opt-in visibility for security
 monitoring (eBPF/audit)
To: BoxStrikesTeam <BoxStrikesTeam@proton.me>
Cc: "rppt@kernel.org" <rppt@kernel.org>, 
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, 
	"linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, 
	"jmorris@namei.org" <jmorris@namei.org>, "serge@hallyn.com" <serge@hallyn.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DC90F40002
X-Stat-Signature: buw3k4qaqyr9hs59zhap8qudruc5qyjf
X-HE-Tag: 1783563702-138018
X-HE-Meta: U2FsdGVkX19Yyk5b85ECjMfCFGJJer7q4/N31uAErkIafR/L+IcTkY6RDupwpS97eR0YFvxTG1y+zXl31CEvxU6IsEu5et354ljXZc0Pmtc9JizuabRbcazEEBQtMDyzOf4NA+2+XZCDOOMKHp945kwyV9XRjkV2zN/hBZiTaBSvmHe6tCXVbpvwxnGiqpzYzfFu8Ee/9AJrEZXBQPugvBbNUAYvjbRb/iNXz8rgIt4Mi+oIQPlh4O+54fs0y04jp1SNrHoXLNnvuhxZUWnhhITBM1imcUt5TwpkAGZ7pyp5woAsVyNp2PP/mq0XGXkyZ212O/W6/gAFXEnlO4VhdBjpS/WiXHP7zwcgLLJB/YUEXhWNuerD1esbGOzmughNhP58WeIln1tx5s7x79bAuiIXZ0kR6ll41En7Ba4OsuABOPF0pGCPYTocOmy64M16D4gy+CL29b4CLrCLqJQTTtBAz5fzua1D0f9y8uU7FC5WbdNXMuOeLH9SAyWguqS2AzvmjCQIDO7Z0vbKq8YHq/mYXY7VG3v49lmq/YZgVmDpjpmsUnZrsQVrpUfwRZQyKFPorwJoHfv+OPs2OXOtTCbXUsGxhJz5aCSw9few+aYKRog5dXONGfPJKKr3vJPYZWMhfEQg1Bcvgi2ztYnGLF2dfPv6u+5mLX/sQBu/7tH2w+ISV21Mh6auwoyjXXPYBPjyk5iKnMX+znlalNRZzHWCHZZUIedHGo/p+z3cx4ehVDD2k6vsB4Gi9ACcGBq+IDWU3mPCG6CVBAe+CNWbjS2+5ArqkRiH6nlvNFaqQ109CsaPybKOQDL0nHwIO1sDqk6jZOw4cPGE+crJuOg71gd+X0rk/Nb+92D8lRLexXy8DDdtUdvKTb6BxHJS+0ycywmxG/uGab8HBZ0rcGHZ1Yvl6VKxbozhLOsBjHQRCXSR5KaVnylI5xuk4MDQUBbEGP4xTiK1lngtIiNl/Hf
 nE9YxWzy
 WhyyE0rI2Oao4AMikiiemBwTpX1qIGs/3661uoasBwmsqPoeGvAt3JUQuANOWB0mQ2gHppUJT5WdbDuZd1b5x6hGHs76gxvPYuxLFiceJtXd3pqHTiR9tKXggbzUvNj495JsGP81LFZdXhLQsvuW/Qcywe+jybijvPTfjlWdF1pTcRuo9h0o8FKHQRdAPEaZktDMX5FaR4xlqQYrwr6gL6m+7E7wzx3eLNX9cYAnEeEBx8PLRtVIpPhjgCrYXJG2aSDuIp9bCkN1U7wGADQv0f+wzsUB93iNrqhQZ+rPhYIv2DxvU/9wfNhgQiYbdclULeU64ghzD4LfsXRBWFl+6F144LiYuwuLnHi87UTKCl5yg9TLR7woqjEYQ36QBvGXgAzb2g2TPx/daaU0TDlAKnaEdVNfARwAB9yBzsXIEHABKvOH8rczOM26cDWyH7TAfiAuDgjw0vhV4f9S2tFWTPpksHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 8:09=E2=80=AFAM BoxStrikesTeam <BoxStrikesTeam@proto=
n.me> wrote:
>
> Hi,
>
> While experimenting with mseal() and memfd_secret() together on a
> recent kernel, I ran into what looks like a gap worth discussing:
> content placed in memfd_secret()-backed memory is invisible not just
> to other processes, but also to in-kernel tracing/observability
> mechanisms such as eBPF's bpf_probe_read_user() (EFAULT, as expected,
> since the region is removed from the direct map and kernel page
> tables entirely).
>
> That's working as designed for the threat model memfd_secret targets
> (protect secrets even from a compromised kernel / ROP-based
> exfiltration). But it does mean a local, unprivileged process can
> now allocate memory that:
>
>  1. Is invisible to kernel-side introspection (eBPF tracing,
>  /proc/<pid>/mem, ptrace-based tooling) once populated via
>  memfd_secret(), and
>  2. Can additionally be sealed against mprotect()/munmap()/mremap()
>  via mseal() so its protection bits can't be relaxed either.
>
> Neither primitive alone is new or alarming - mseal() protects mapping
> metadata, not confidentiality, and memfd_secret() is explicitly
> opt-in and disabled by default. But combined, they let a process
> carve out a region that a host-based EDR relying on eBPF
> tracing/probe_read helpers cannot inspect, and cannot force back into
> an inspectable state either. For userland security tooling that
> assumes 'anything a tracing eBPF program can attach to, it can read',
> this is a small blind spot.
>
> I want to be clear I'm not suggesting memfd_secret()'s core guarantee
> should be weakened - the ability to keep data hidden from a
> compromised kernel is the entire point, and forcibly exposing content
> to tracing programs would undermine that model and create a new
> attack surface via the eBPF verifier/helper path itself.
>
> What I'd like to raise for discussion instead is something closer to
> what was already anticipated in the original series - Mike, your
> commit message for memfd_secret() mentions: 'Once there will be a use
> case that will require exposing secretmem to the kernel it will be an
> opt-in request in the system call flags.' Two lighter-weight
> directions that stay consistent with that opt-in philosophy:
>
>  a) An LSM hook / audit event at memfd_secret() call time (this
>  echoes Christian Gottsche's 2022 RFC to label secretmem inodes
>  via inode_init_security_anon for SELinux). Even without content
>  visibility, logging 'process X created a N-byte kernel-invisible
>  mapping' gives EDR/audit systems a behavioral signal to alert on,
>  without touching the confidentiality guarantee at all.
>
>  b) A distinct opt-in flag (as foreshadowed in the original commit)
>  that a process could set to allow a CAP_BPF/CAP_SYS_ADMIN-gated
>  tracing context to read the region for legitimate
>  monitoring/debugging - fully opt-in, off by default, and never
>  implicitly available to unprivileged tracers.
>
> Is (a) something that's been considered further since the 2022
> secretmem-inode-labeling thread? And is there any existing tracking
> issue for the kind of opt-in-visibility idea in (b), or was it
> dropped as not worth the complexity?

Modern kernels do allow LSM labeling of secretmem inodes, see
secretmem_file_create().

--=20
paul-moore.com

