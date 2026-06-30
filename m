Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD6DCC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 21:41:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7B86B00AF; Tue, 30 Jun 2026 17:41:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFF46B00B0; Tue, 30 Jun 2026 17:41:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5026B00B2; Tue, 30 Jun 2026 17:41:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 45BCA6B00AF
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 17:41:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C09B2C02E3
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:41:20 +0000 (UTC)
X-FDA: 84937900320.24.DAC1479
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC747C000E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:41:18 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=NFG8vEeO;
	spf=pass (imf28.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.53 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=asu.edu
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782855678;
	b=W6F3auee10ZoDI8kuD3ebIgqtp5FLBsVb93asSuujqCDQcuqNgmhwM9m2aTpuHrxQJvsON
	FyqNk4PCclU0By/y7Az4iXTTHsgODNDRgNnLgIvcr8uA4JQVTu080wIxGtXftxvYUAp+fK
	Vc/anb8qU6lFquldOEHHbhsNjGmFtZU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782855678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G1qIjvFuUzRw2lOnNAlRyfIkKS+2a6T+brJ0gOzzX3g=;
	b=oWJ7eaC6B8N58HcxNbqPcMbYybYQ1scZaG63c6P6ah4CKam6fNQe3CjngLZZ2sehzR13PQ
	7EzxzOpmfB2HwLF0He7LEC4OtSV9XInqgCVOCH8XveDZt5iAQK6RNUMzGjy7r48RtL23wk
	c4PHgRVML1qaWoKYeSfx3UsZ1lWfX1Q=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=asu.edu header.s=google header.b=NFG8vEeO;
	spf=pass (imf28.hostedemail.com: domain of xmei5@asu.edu designates 209.85.216.53 as permitted sender) smtp.mailfrom=xmei5@asu.edu;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=asu.edu
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-37f7a5a217fso14670a91.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782855677; cv=none;
        d=google.com; s=arc-20260327;
        b=FtD3IcduyIdXM8xvP1k6dsYPOt7q48yQzX5O+J7gJL8ThfqkdkCI2r049I/a/EjRZc
         5rNtprdED63kDKxtoCtNxindK+avB/zShmFkPc4CO1/m/Dr+JbhGR1sBFxIXzezdktd+
         fysgX2l02aGepS5K1FLjcYRPGYObAe7t8skPv0E4IqA+8hHLvORqwCCbNieMGs6Iz10Z
         gueJ0CxAcjL0/Jb8aXOrVPXfXdqYQe7/b6S9czUgRLeM/jhFef3eYm8awxrTuVhceK6d
         fhGiE1LknZVEU9dA51rRQvKHm8LOltHCfKmBm0ITJtadmFJIzijlCUMmbaQ8Yi+cyI0c
         FFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G1qIjvFuUzRw2lOnNAlRyfIkKS+2a6T+brJ0gOzzX3g=;
        fh=dOSM7r41DgDSDCfhySkQKWqGwwtyTK2nOGUm3H5yAEw=;
        b=AGxLqh8lnr0zf5fhvi2eLnhBJIg6gj/Z46KYEaiFS4nKu+WfvwYL15VfgoiJ2mqNeX
         xDu7loQalJloBRSDFBjtSWupZbVKdnklexYfOaLLVtE/oNcWEN5EnOUNXJGkT9TVzRN9
         1KotoyUN0Mof5bcuWl9zpYC1QhA/8tLl9BQm+Gab5qiBVbKBjCPdQnk3vzRgACYrNa5a
         REZzHK+fyGOuYzovgf3jLTED2BY2WRxo+n/unH3mP1Ir+ZThX+tXND2u8wgRbz8frpvv
         yIuoL+cOj3H+URAxA7MP/QQhYsUB+h560oB/pALgP6rzcozOpjfgol18K580MfL9p9mV
         htPA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1782855677; x=1783460477; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G1qIjvFuUzRw2lOnNAlRyfIkKS+2a6T+brJ0gOzzX3g=;
        b=NFG8vEeO+JsAFr64NPpT9ZkMa2A0q+VqPqDwyIGPIn782brro6M9spZhnOfOt7O9Q0
         BgEvmmIJA4hHHMl2/hz8GQrEDz/2xbEOxcz9ZaylUwU9ueHQa1V7A/7ZPueWxyYDDlaM
         BJUSKS/SrV6KeaOqmGdIvP3BFeOONXk9w7Y/oOwpH7C1L2EuIg8WREB7OtFY6ddfUvdz
         ta2Pg7mnxM8nAYcuP+o5FU14tc23flsmWusIOCxepLuaRH+8Z1N5mvyDXKVDLk3d8dbL
         So/tpz00iYWLEWgTx5Mew8DffkLkdECECD/Ed9TXQz4InxwWeqXnXj6REDR06V8XK/Gw
         sq/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782855677; x=1783460477;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=G1qIjvFuUzRw2lOnNAlRyfIkKS+2a6T+brJ0gOzzX3g=;
        b=HnMSIX3GKg/6SQCWArTaUQTUF2CRW3E8t+MBuc+7b+lOB97NFlmlQohlqmqPSfCfCE
         +H0FfTt06vnjE+Ssns9KXsW4I3yCz+7UFwvmAkLjlMUrVfv/Dy08N0LnTkKtgL3p9Y+4
         RuwUyBNv/9Yq9943ndPRCJPMhQ+rglU7yFkL5vgFe46hpGdM6QCDim7lxN3JMe7rlWsy
         gOl4ZG+rBpZ7beauS9kyLfJMXBz8fQyQbldShmYCA6fb6q61SFimxLn0a0qlu9Z0KpNE
         es3SvMtvf/1/fTeRYwczmtKx5kQP5/oZ44aJmpiXeDBssgnvmkgy15EzUakJTG+cBd/L
         TEgg==
X-Forwarded-Encrypted: i=1; AHgh+RrZaLVmPCIUIB84L9SM44WNC7XUSTMT6RajBNGljFsy0YCNMYK71xaxlVCMJPJyCmBm6MdbaEvnPg==@kvack.org
X-Gm-Message-State: AOJu0YwWTUSwRq6cjyyhfXaBACGn0UepSQonu5/3vJftntJgYRcclyqG
	uUYKtZm/q/+Fpt/IwmYgYbPqioZj+srs2zWAl8colGWY5o4h6zb91HejAUValJeumshpxAoq22/
	9rNTiijC6wVJLJ4VAWLeiKqKio/PB0UvEUXSGImDq
X-Gm-Gg: AfdE7clY3vMQuahMK7d4sAJstIwdohxbg1ahvEgEklji7F7/F0Dm+xabt+rcjYYBOl5
	VQkoBGVO5+5f2ssNvto+W47DTnHQX+/dtuiyDe9h88Z+Wr9Wg17QLE4nebP7eqLsh6MRKlRagon
	kYpXUz4F3oNWMOYmorZ52MLWSDJJjF4VEAB6yQI/7A5Kw08C3is7VeXtPon46jPt9i1j7X6dRAQ
	1yRlWibCHEa3+ZV6TMf4pLKIJrWUvyuHfHezXIPBug/1FNczhNJQce0+whx5OlYuZ/gJ2ShwBbd
	8QaJ9a/1YcTFRZ+xUGYC93elt4lz
X-Received: by 2002:a17:90b:3503:b0:380:97d8:902f with SMTP id
 98e67ed59e1d1-38097d8be89mr743202a91.9.1782855677625; Tue, 30 Jun 2026
 14:41:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260629214712.1198680-1-xmei5@asu.edu> <d9775951-fe04-4d1f-b205-bd4626590f5e@intel.com>
 <CAPpSM+QTiwgPk3KNmWbjSk_SS8LLL5XDfikWC1A98vetom3yeg@mail.gmail.com> <akPT82jDvPwlaNuo@pedro-suse.lan>
In-Reply-To: <akPT82jDvPwlaNuo@pedro-suse.lan>
From: Xiang Mei <xmei5@asu.edu>
Date: Tue, 30 Jun 2026 14:41:06 -0700
X-Gm-Features: AVVi8CfJxFJJeFwklcHtZSwf2CBofagh0lCv7AsQMF7Dwy0qHcKAX115Py8RIJE
Message-ID: <CAPpSM+Sz4TOfvh9os_SDvaETS-CDSq9evY9vcDupXwrP1pM9pA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/vmalloc: widen guard region to defeat ENTER-based
 stack pivot
To: Pedro Falcato <pfalcato@suse.de>
Cc: Dave Hansen <dave.hansen@intel.com>, Kees Cook <kees@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	linux-hardening@vger.kernel.org, Uladzislau Rezki <urezki@gmail.com>, 
	"Gustavo A . R . Silva" <gustavoars@kernel.org>, "H . Peter Anvin" <hpa@zytor.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Jennifer Miller <jmill@asu.edu>, Tiffany Bao <tbao@asu.edu>, 
	Ruoyu Wang <fishw@asu.edu>, Adam Doupe <doupe@asu.edu>, Kyle Zeng <zengyhkyle@asu.edu>, 
	Yan Shoshitaishvili <yans@asu.edu>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: k8tzbrwmcgg85p53d7ke74ymc4cyrc71
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BC747C000E
X-HE-Tag: 1782855678-735114
X-HE-Meta: U2FsdGVkX1/4fc0g8G8GvKJt/4XbhvDVt/6mu+bKw9zOe+kvvCKDKNK0s7o274nioTOMii64pakWxSTbka02tZljBRM9gUeLTWJfmGzkR3GhGrQlIpGFKxOxY7moQaQBQCJLHJGXDBQ+18rmkaPFIS85vrkR8Wp0YmNZu61GRUJ4gLpKT2mQ2ADDzJySILXZDRvpWEtZd4fYgpwqS9in3NBS8+YkXubgO0KtB2LGPIx/3Z/IS39apOVXRV+oruAsY9uCbWKZNk17dFVFwAlX5Ce3OzJy+qaMV/4jGy+WeIvjAvZKyi31DCoba225qqZGZsOkv5sl0BJbf7iJVV/bHmKlHUrImNTlYSQwo+b35KBHZmA/xFduT31go7iFly0077o9kkKT4nUiCm7jV9MdjQkFxcxgXxv95CgGGcjoQy35Wckoq6GFcKRc4imn0AVoFNKkJxXD2jGcz4oTEaOnUEzjGPElEZdXpyxOmeHXk3pA/eIEmYhcZBpHw3ObDdN7QFlJjZjkyELgiRUMjh3BarSfbawWX55MaBgvJI5MeHEAB4dreqixDnq5xzM3C5HXiCoBXr2ou02TPIixisRIEadDt55fvWYnn4814DCIdxWxo/AtMJJx0dssL2ymamoyssbtiQ4WX9XboS4tCGiJb+catTkNU7yXfFbw9MHWyOVH722VzXy26pPcIH2iA+/o9kLKLidwr/qo1A7jAaRKXT+8mP7eI+QtsBF1Y4byIDIBJxJ9SWuhl4VZJobhxuF/Z6PxQJAgve8YlP+iIOYJkhpm0yMWLUEm+krrs0xfcEdWHUahi/vhxUSftKG8ceQIjkictqPiAyk1KVVrfOImIEHmcRItVJQQbd+P6Q8zO9kTgtoY/uENXSwJHjCf8XtoUbmIIu93XxruesNjMTF8l+iuPcvwinFiaEeyMOSr5D8I4oFNVQkzHCGFBhjfvU8kYYmJJenCLzCbbQG5fP0
 JIOlpuZu
 Mm++Ll+81c3/EKzcO0iv+oy+5XA0sKuOkHEUAABP3HKNs0izzj0/hJ3XdwpcGVvHYDoEgT9STjuSrOsl//2n8otOJSJcBno7c01obz9PooxitFF7jxZE80A6J8KQjnUZOmkscm1XvEN8o0DFL57OVrg8Sj72sWzMc/CvJgrjCnc+/gjQYQ6Nxpsj8aLDECnNAyp1v4aEQ/SaTxRFIF63qRftWyEf4fT0lTEddVnPeaF2ebb5yGflg8IDY8pLBZAm7f8OoT7FS6WoYmG0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 30, 2026 at 7:40=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> Just as a quick FYI, it's good LKML ettiquette to keep people who engaged=
 with
> the previous threads on CC for new versions :)
>
Thanks so much for the tip. I'll remember that.
> On Mon, Jun 29, 2026 at 04:28:19PM -0700, Xiang Mei wrote:
> > On Mon, Jun 29, 2026 at 3:29=E2=80=AFPM Dave Hansen <dave.hansen@intel.=
com> wrote:
> > >
> > > On 6/29/26 14:47, Xiang Mei wrote:
> > > > With CONFIG_VMAP_STACK, kernel stacks are allocated in the vmalloc =
area,
> > > > which an unprivileged user can surround with attacker-controlled da=
ta by
> > > > spraying vmap allocations adjacent to a target stack (for example v=
ia
> > > > XDP_UMEM_REG, though other vmalloc spray paths work too). Today eac=
h
> > > > guarded vmalloc allocation is followed by a single unmapped guard p=
age.
> ...snip...
> > > To even be considered, this series needs to be refactored properly.
> > > Making this VMAP_GUARD_PAGES a separate patch is the bare minimum.
> > >
> > Good suggestion, I will do it in v3:
> >
> >     1/3 - introduce VMAP_GUARD_PAGES
> >     2/3 - mark percpu vmap areas VM_NO_GUARD
>
> I would suggest you create a VMAP_STACK flag and condition these guard re=
gions
> bsaed on that. Otherwise it's a bit arbitrary as to what callers get 0x11=
 guard
> pages, and which don't.

Good point. That would make the structure cleaner.
>
> (you can find the concrete stack allocation functions in kernel/fork.c)
>
> --
> Pedro

