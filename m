Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 393CDCCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 13:55:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984B98E0097; Fri, 24 Oct 2025 09:55:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 934F68E0042; Fri, 24 Oct 2025 09:55:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 823968E0097; Fri, 24 Oct 2025 09:55:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 689F78E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 09:55:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1808312A318
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:55:26 +0000 (UTC)
X-FDA: 84033155052.02.A20B172
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 1F697A0008
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 13:55:23 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qBXIdUQl;
	spf=pass (imf25.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761314124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K2dIAtOUUWvG/eBKWjjuLXcfuya+SsNU788uetQyZls=;
	b=VBde1psHBPHmRGEormkB6F8AlOOCY3oFKC2wtShY/7tHHrO7ay1UkgxkiBOmhT1uEnTvnw
	PwtAEyhB/b99y4dPHOJtJ5HeV7brQmJ/TRq2AMgrLtDZD5NxSxkb3jBQeztAbCmdjHIOLy
	Zfh9xo0LL2Q4zQBr1i3qkxUzUAotg7E=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=qBXIdUQl;
	spf=pass (imf25.hostedemail.com: domain of zokeefe@google.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=zokeefe@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761314124; a=rsa-sha256;
	cv=none;
	b=7GqvR6eyjXs7N3zD56fAfvVyaudT+NTmiEoMDdwqAUKO8v8bzfqK6hXsJ5h/1SUTbr1flS
	EYPtk45n+wy9FNQIOKnB+NWB1wTa9zhYJnbV/Y4lkRyoEV2MqSk7F+K8eUCDGgsvrrJscj
	Cewon/TkyB/XLe02+EAJ3pDtTSI2ke8=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-431d824c8cbso171405ab.1
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 06:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761314123; x=1761918923; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K2dIAtOUUWvG/eBKWjjuLXcfuya+SsNU788uetQyZls=;
        b=qBXIdUQlhIiaL59iedy2xpnSQE7qWX2Yzwuj0xIGHkrIKOCpx27mFz3x6Rb3/RghBe
         hzEspvIpCv1qHSp3D+2jOWwXwcSkZi76cpce00eAn8PvNcRfMdymVyqATSj0Z6F+HmtI
         QE/mGrbr9G4qzuaFrzslupgELj5PYyk+g+1pv4VJ4ZURvPeIe51DPHggqwMlkuwB1EQr
         V13pSPl7aFcJehRz98B1yERnPo+exE3aXruhiEN1FvNz8nOaTKLmJSUy8Om+8xjJDNsW
         uvFpTcjapxKaX6UHDsQORJbf6zocFqanBZ9K0qptcmI+etyJdDaAEbI17MfpSOmZ53ak
         G/eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761314123; x=1761918923;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K2dIAtOUUWvG/eBKWjjuLXcfuya+SsNU788uetQyZls=;
        b=wdRBtjdhm4/UoWD1i+Y+hUnsS4dCMOvKDvBjt/HYWJc3QHEMLXKmTMkuqDWZKoRJ7E
         U+B5LR7naWJ34IakS2vdZ2XiPh4M/84OMKP/A4dUjCUEVtufkziGgFfA1oDB77g4Wk/Y
         yce4c4LhHUt1QYrqxAK4Qvm4ovUxkACgS3nUrIL1J5HaElQ7obrOy+erPYVD+ZYy5VI1
         Du9s1BUfBqQaGjtJAzEeSQ7PrOSPeWZ2XzsbBhUz8BhxU67t8A0pPXTjsTJk0o7pU74X
         csXH4qaWizWzFFlTH8eYDg13MPZGoFKHgb6vUz449w39BnTQvI/DOGQOw0tA9WzAmvPo
         0a3A==
X-Forwarded-Encrypted: i=1; AJvYcCUD816IiLHCyRJRr6384PiubgybmGXFlkcoVpVf3+LJIijpMSDqLBmbm4pir4MdV45Z78BwR3siOg==@kvack.org
X-Gm-Message-State: AOJu0Yy6E8mVlw0y6s6z8rTA2kWpAOM5cceQkuW/NN9iwKFNdTkpoC29
	QXrt4L2Dq6R9rjc1lMh8yMkB25NM89PpTH8aInG7Xpxy0wuarlvzqhJU4Dfu8O0M/d40WGtIUFH
	g8wGTzS2QXWeOwH+syamK6TFU4x8s8EtMqwN7agB0
X-Gm-Gg: ASbGnctVI57+VnSit07ORQ4uUwA7uC3+sAMygxUR+7yrZakPea35s8bXROe0sEEiYBR
	vtdgucBaAtAmZc9YWKUtMd7AcD0mD7ew6Ab3U3jmGHb79dn/OgJrGmfTipTdRAdkGrN+o5fhnM4
	vIpC4970NOoS2+ACooQroF5QiDL0pUJ2h+eTiCbvLIVzqPzzypsVXnhm9jgukB6pSOkHrRO+q3J
	jsHoqCPWfT5ytVX614NDMwunD5VboEEzR8Zxnok6mdGhpTqlnEOOvO3DJDOgg==
X-Google-Smtp-Source: AGHT+IGzc6PICLpjn7p5NLgSZidgmsbQwDaACcRVkIv0mBWbrME7xDhdRFUQJbQIQQlqdF4IvQBdVfldvdcu5sVwfbE=
X-Received: by 2002:a05:6e02:3046:b0:430:ab7b:d920 with SMTP id
 e9e14a558f8ab-431eb297a82mr6053455ab.2.1761314122159; Fri, 24 Oct 2025
 06:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <20251022183717.70829-1-npache@redhat.com> <20251022183717.70829-16-npache@redhat.com>
 <bba40f08-1b87-6b57-0e10-6e96e4d7bde6@gentwo.org> <ed0887eb-6124-44ab-9d1f-1e87e9640e14@redhat.com>
 <666ee834-396d-4a7c-be89-96c58b5c2ea8@lucifer.local> <c62m3tyr6co7jqdrwhtp7exnewhogxtife7g6yh4gve7gqecz6@b5xpocyvifxp>
In-Reply-To: <c62m3tyr6co7jqdrwhtp7exnewhogxtife7g6yh4gve7gqecz6@b5xpocyvifxp>
From: "Zach O'Keefe" <zokeefe@google.com>
Date: Fri, 24 Oct 2025 06:54:44 -0700
X-Gm-Features: AWmQ_bmYc3wxdngLfQ6jZCDpaFrV3lO1QrUvKg58p5eJGm6dxJta1c107ifDhio
Message-ID: <CAAa6QmQBmZ-82PwzLao=gO-+1u=GFyPogmVOjAFQ-esVdo9tYQ@mail.gmail.com>
Subject: Re: [PATCH v12 mm-new 15/15] Documentation: mm: update the admin
 guide for mTHP collapse
To: Pedro Falcato <pfalcato@suse.de>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, David Hildenbrand <david@redhat.com>, 
	"Christoph Lameter (Ampere)" <cl@gentwo.org>, Nico Pache <npache@redhat.com>, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, kas@kernel.org, 
	aarcange@redhat.com, raquini@redhat.com, anshuman.khandual@arm.com, 
	catalin.marinas@arm.com, tiwai@suse.de, will@kernel.org, 
	dave.hansen@linux.intel.com, jack@suse.cz, jglisse@google.com, 
	surenb@google.com, hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com, 
	rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com, 
	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com, 
	Bagas Sanjaya <bagasdotme@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: kxjjic4s3rk3mwehf9mdqntsjo8po1kr
X-Rspamd-Queue-Id: 1F697A0008
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761314123-543217
X-HE-Meta: U2FsdGVkX1+HGJlbDkcxhBZzydavsaiq+A/cMVA6nT7vgRsOaMs0ua5F81DGElDy5LgxJ0IVyzn8yTpMmtvK7sDaRTj6zDt9lHL6xXpyyforWtPcB+XWyXjmw0r8LCYXSAEvlhUwcMRc2JXYIDcQPbLuXBcgC6yRzW5BadxABEW2AsFFpgOP2/urEJYQbRuZZq9bG/DV0PcvK61x61dUcxvff9IvXp52uOWyVfkSVk7lP/xpUTZ7ZEkJZWX4fJvwf8NN6SVzNidYY/h9qI3SuRGihTCjSrlcClB+5ffJ+qudDt+XVvFbPgGVDv8n4LXwdA3k0AZ7WVyHPmXHTV2nrETA50AELhRtJ+O05iHbGXUsrEimK4wMWUVLOcDhfrU05oOO4KVBlLyC1EGtJzwBWTlIzW9cBZRqSEFBWw2q/oUZJ6IINgltWHC8FoV9yBXM7DktTdTL4avS/nYFJoJAWjZkxFGlmIstaWNPYIsb3B4xYvwXSFcsBJH69NlAYpj7gemXivL3d+JRkMTvSCAg0u6mRqzSujkCn9VYqOBj6jEat0esWlN+C3WWyYbFGcUP3GitiMGHX1WFy/vcYNpEIoi1LM9Tdrh5Y5erdlGtgJHLtN+2UPnadza5Iw6u+SmG/zkTPd4U6SG+KWhCg0NSupFWGoWfnrotw5stQUG0T0WyWdV8j2MzMjbr0/WcwCjWXZzErI8XNyBlT2aMxGc57iHoyjbrwNkZ7zocCq8ab1CrZ/Yd48jgsGGNSjNL4Op2wfeP4P1S6w4J+vUinZFtF9oJ86dFEb3trABaZVbo9asaXPrinij3d6uEpUIWEXeUvNb7F+0Y+ZwDH/LlzdzuMTFourpA8lLmJ7r9YaYxTwsWzN7wPr9dvi2LOq8qgAejahviqEtuyqqj4wytLnAH8opnEcBWrmNZPGmblo0sdJd6SOv3fIeAuFmw6bPXDJmiH4Gw50mPxYBD6zq2F3v
 XVAzqF6J
 Awh87UBn+gDHPPxYZrmpXEtI0868MyYzfyKjAlYh5p4Y213mLZM9d9Q2XcoJe+uS2hpEwyqTx+IZJb1zV44HPmZ/x/C7sdjC1yyEaA+WMxuSoMifLMJkY60n7CrRCXfUoomtLCMQfmHwRfzyIirqPaqtmDxZpA04DnIYO4/SCaWJrfWDvcoFd517a/1kHlEw4VwlJQXQ1Qd8CyE2r6uueoGvF78MFEtvpo/Np0oNlqhGZGuJ3z9mD9H7gAA/V153wvoXaV7ikztiWnkE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 23, 2025 at 1:44=E2=80=AFAM Pedro Falcato <pfalcato@suse.de> wr=
ote:
>
> On Thu, Oct 23, 2025 at 09:00:10AM +0100, Lorenzo Stoakes wrote:
> > On Wed, Oct 22, 2025 at 10:22:08PM +0200, David Hildenbrand wrote:
> > > On 22.10.25 21:52, Christoph Lameter (Ampere) wrote:
> > > > On Wed, 22 Oct 2025, Nico Pache wrote:
> > > >
> > > > > Currently, madvise_collapse only supports collapsing to PMD-sized=
 THPs +
> > > > > and does not attempt mTHP collapses. +
> > > >
> > > > madvise collapse is frequently used as far as I can tell from the T=
HP
> > > > loads being tested. Could we support madvise collapse for mTHP?
> > >
> > > The big question is still how user space can communicate the desired =
order,
> > > and how we can not break existing users.
> >
>
> Do we want to let userspace communicate order? It seems like an extremely
> specific thing to do. A more simple&sane semantic could be something like=
:
> "MADV_COLLAPSE collapses a given [addr, addr+len] range into the highest
> order THP it can/thinks it should.". The implementation details of PMD or
> contpte or <...> are lost by the time we get to userspace.
>
> The man page itself is pretty vaguely written to allow us to do whatever
> we want. It sounds to me that allowing userspace to create arbitrary orde=
r
> mTHPs would be another pandora's box we shouldn't get into.
>
> > Yes, and let's go one step at a time, this series still needs careful s=
crutiny
> > and we need to ensure the _fundamentals_ are in place for khugepaged be=
fore we
> > get into MADV_COLLAPSE :)
> >
> > >
> > > So I guess there will definitely be some support to trigger collapse =
to mTHP
> > > in the future, the big question is through which interface. So it wil=
l
> > > happen after this series.
> >
> > Yes.
> >
> > >
> > > Maybe through process_madvise() where we have an additional parameter=
, I
> > > think that was what people discussed in the past.
> >
> > I wouldn't absolutely love us doing that, given it is a general paramet=
er so
> > would seem applicable to any madvise() option and could lead to confusi=
on, also
> > process_madvise() was originally for cross-process madvise vector opera=
tions.
>
> For what it's worth, it would probably not be too hard to devise a generi=
c
> separation there between "generic flags" and "behavior-specific flags".
> And then stuff the desired THP order into MADV_COLLAPSE-specific flags.

Yeah, this is how I envisioned the flags to be leveraged; reserve some
number of bits for generic, and overload the others for
advice-specific. I suspect once the seal is broken on this, more
advice-specific flags will promptly follow.

> >
> > I expanded this to make it applicable to the current process (and intro=
duced
> > PIDFD_SELF to make that more sane), and SJ has optimised it across vect=
or
> > operations (thanks SJ! :), but in general - it seems very weird to have
> > madvise() provide an operation that process_madvise() providse another =
version
> > of that has an extra parameter.
> >
> > As usual we've painted ourselves into a corner with an API... :)
>
> But yes, I agree it would feel weird.
>
> >
> > Perhaps we'll to accept the process_madvise() compromise and add
> > MADV_COLLAPSE_MHTP that only works with it or something.
> >
> > Of course adding a new syscall isn't impossible... madvise2() not very =
appealing
> > however...
>
> It is my impression that process_madvise() is already madvise2(), but
> poorly named.

+1

> >
> > TL;DR I guess we'll deal with that when we come to it :)
>
> Amen :)
>
> --
> Pedro

