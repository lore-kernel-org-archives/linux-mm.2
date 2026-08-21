Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73F26C5DF94
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 15:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6794D6B008C; Fri, 21 Aug 2026 11:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 629096B0092; Fri, 21 Aug 2026 11:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53F006B0095; Fri, 21 Aug 2026 11:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFC86B008C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:08:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 13242A2627
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:08:31 +0000 (UTC)
X-FDA: 85125608022.19.0FBC3CA
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf06.hostedemail.com (Postfix) with ESMTP id 17C7A18000C
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 15:08:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AxV472HL;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787324909;
	b=nKLsznP2OFor1+Ri+4nbNAUqGzd9UPO9tQpU2236K+zZrP4VcW2g2ORNne5OlMULeCVVgV
	HydqL8pIXW5ZiRG/sWfbU4wDiQjCGN+HPHRba+Qb6ewpD5qc0CpWXJAjC15ksQL1tqYeAa
	aJMR/p2p+c6luZEfIHUzYpm+/Fz4VRg=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AxV472HL;
	spf=pass (imf06.hostedemail.com: domain of jannh@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=jannh@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787324909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8B6gWPpC8JGpYPIfuo07l/hitWijKoYP3mF4ztxgwcE=;
	b=1gNRnX2gYDK1SX0tdzs2nc5LwjyUMa7rf9fXDSdDdWqLM1sN8XPtRQasAe2CZnBKY7E71D
	CnmY0diyIfmupltlV/ek7mdc8ORIinpFNPx7iKLX+loOEmXUjkj3LD7KAYBIndG+dW08cn
	0tgh/l0+tuOP4yRi3GifpelGqeyBU0A=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2d3b445a84fso82765ad.1
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:08:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787324908; cv=none;
        d=google.com; s=arc-20260327;
        b=hwQ8DHxq3LusHHrXJPSonca4/xItEFiNXV8UvYlD0e20PisG0w3dyvpoTDTjSRHL6t
         pcOUqzmrhzduQPLqbUAGZ2xoueKY77Jfmx4OLBZq2mxRwspRv7ua88v458lEtJ+FT/2u
         GqCYsi1bV3UzKHRk8jCaIvoOlO3UpOshDjD2GpobpjkEhjAtGHk7cJDWtD9pYnmHxhfq
         dyj0sIb+ypdw2mYGIQh9yMqGvqZg4L7XeiLAWpO8UmkjnI9x+ikbR/uxuAy3oMdaAxBY
         v9t20b+QheQo3mmSFDR38CiqTPbFlUtFFPzNNPvh30C9D7Kf0w8Asl99xv7fveFXVh/6
         KLTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8B6gWPpC8JGpYPIfuo07l/hitWijKoYP3mF4ztxgwcE=;
        fh=Vrl+iBqIy89to87eDB+SIv3xbS5UBCuMZm30qrBbmEk=;
        b=RKlrsILa0qfn2JcJnXnHZi1581vbtgq/kWMTBPz7qvxKJpoPYdtQm21OWIGxfRXX7w
         TXkXIEeBkZvB5Qdp50CrCxeXaEs29GkccdmJujpYqzVJO6+Zfal2ibiJZ1txAaTRjAja
         9noYIqXkCGWaLCKvkGY59kJHxk9XPsc2OZdELas38O1qepcTIbeSXYR2CLNiUhUmUy1Z
         8E8qrtGcs4RwLg/jK969zZWdJ1J1erolMmqZqxa0Nb2K1CBnBf8wAX55kxRnw2Lmaavd
         8gNNpZntmZGZtqAgc0An4llzlpIQ0H/cEuWkILI09zE5CxlPn7M/N+X/vUDQtov3Dj/+
         uFqw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787324908; x=1787929708; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8B6gWPpC8JGpYPIfuo07l/hitWijKoYP3mF4ztxgwcE=;
        b=AxV472HLBZiuGH8XjDk7kkBoa7sQCD7Hcffo0tmYo3MXOuAKBmgK+FV9Qi+OXQK6rm
         8LsIBjG/nnPj05AEmS0hArKvpDnmVviw7paHJsCng0DRJJeTp/Gig70zRNU1UrVp+m+a
         rql5jKKaxkqjXDVR7pQOxcYPDv4t+CDDcx8WjsHdYOyD7GwDw6KkL/mTQn7l+q3j5+aM
         XvTZ6p13AmsG2DwK4YNuQsfkScsVW2VJly3snePFwNI0n44inHJ4/UfklQsrINC6Ponw
         rnrKoy3+kh3ybMqq7eMgNh6nPzv2RIi3PiwejxrQOfz5dyW8e3LRyRSDjyHeXNOR5626
         4XPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787324908; x=1787929708;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8B6gWPpC8JGpYPIfuo07l/hitWijKoYP3mF4ztxgwcE=;
        b=FRPQ7Fxs9bEr5Z5wZ0ZIcUHHXuAOVSFY81/4kXFtElp2X/q1CuiHjJRgWJscSobWaJ
         myZ71zFCyPLZoxLRp1k1BZ7teVHoUQUo/GnmcYlc8lZpTDFHRrGi5WS3XLkhx2O9Svll
         bQMhfQ3rKxrC869LHTZEPqi3yZ67s6z09OYy5DzynasFlRS2iBzELxiTI6nk/qIgRmub
         T9FmkzrPrOERFOg7yu6fMNS5ILsFBOOyZTJ6U5Qi9Gming4pzoSmR0z1tcbbwQ5f8hVT
         UL1F77vo2pOOJdk95SHWcK7YPa+2Yw7HntV5AIkjwTxVfcbe2Oj947EVu4J3ZKqQ4dqM
         Ddyw==
X-Forwarded-Encrypted: i=1; AHgh+Rqh/bzSwzMV+KvuRlg1iFRzhs3YEQbF/sS859+n5DBOVNUNYHbpZoFnzZSdvMQB9Rof72XuGYQJdw==@kvack.org
X-Gm-Message-State: AFuF++lE0vYJbm1QxXhVIxCEZt1PxRfaHnD99hxDnUzGY3ybCAIE74uq
	ZjtmQ1zV0qJevngOmQWauDXju8pqpO6IxQEVC/flMIiLU6pbYb5s54y2wgpppvXqMNNVsD/8wyk
	7TLY7+lvsKHkqBicc9bqi9DhJPQuIpN/rztrzT1Bw
X-Gm-Gg: AR+sD10mAYMIZDFDlZzIpyaPEGkXmTMhlw9g/5bDeWoVtxmapV+UFTLrBNC+BnQyZWL
	oHZ7YULPSn8J4lEPsXNOTOhdWQ00oPBYfcgKQx52bW3Q9E/dpzrLYvfnuG58PuNGI+PTCKpi+K/
	56Z3TwoKnhUtq/VW3zxp0q03yekNX3PIq23bheVOqcXa1LuDXm3ughGQ2PSM3VxpGPnqsWLtPut
	mGVCGLBI2HpumScGOJj22ww/eNYtikxfRUJHrmZkbQge2/1dxSv8VxrCH8hPQy2ef3vaUoHwKWC
	F+FiD8TLZHqCZQDXGMTf2Ok4WnhjtF9EoC1niQ3WO4U9/f8JRlDWNhEKDzkIJpgAGfZUxP2F+76
	RXB8vMCti3Sg2pDcKy1RdOzBc3pGt
X-Received: by 2002:a17:903:94d:b0:2d6:3c22:994e with SMTP id
 d9443c01a7336-2d650da6ed0mr6702055ad.11.1787324907361; Fri, 21 Aug 2026
 08:08:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260818-selinux-pokemem-v1-0-90cd2357ee05@google.com>
 <20260818-selinux-pokemem-v1-3-90cd2357ee05@google.com> <CAEjxPJ714iCMiQRVAN6MQoOyNx998MS5Xfhbhmugcwz+gWYAuQ@mail.gmail.com>
 <CAG48ez3h2Gft4onQ8AgBmf8gHrF26YqTinajuBysNPkUKaTBoA@mail.gmail.com> <CAEjxPJ5cUDBekWe7fC1JYnw6CfT8GVa9fqrFwLPPAOqSP6jn3g@mail.gmail.com>
In-Reply-To: <CAEjxPJ5cUDBekWe7fC1JYnw6CfT8GVa9fqrFwLPPAOqSP6jn3g@mail.gmail.com>
From: Jann Horn <jannh@google.com>
Date: Fri, 21 Aug 2026 17:07:49 +0200
X-Gm-Features: AcwNN1UOD9xZwijeRgcDq5q20lqu4OjcbnnkogdrF0uco3EOG75h8KaWFgvrdww
Message-ID: <CAG48ez2q6rCbVVWxE55RpuTotmMrNGYfj6+56EXWhXFSrgJXQQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] selinux: require EXECMEM or PTRACE for FOLL_FORCE introspection
To: Stephen Smalley <stephen.smalley.work@gmail.com>
Cc: Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Jeff Xu <jeffxu@google.com>, 
	=?UTF-8?Q?Thi=C3=A9baud_Weksteen?= <tweek@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 17C7A18000C
X-Stat-Signature: n7rswf89at31u47q6354taamuxed8cch
X-HE-Tag: 1787324908-713856
X-HE-Meta: U2FsdGVkX1/jAuEq8YKhdu/AN+p2F7NWH10yRogj0lvMp5unErXVxhofbNN2/XOpbpnpAhKh2xzkxdLTPcjKRhfaTFSYCPfgOCla3bGy9qXIXWEir9PClpBLO43nUMWBxeMGkni1ilXMLwClojOBDm4SHSqTYOFXxcRKFC5SDso4F7LHtuS/sXynLrYQzZPRfi8+I4JRA4tLHvAjP+czqfD1qbFDiBMeOf69RQI3d5q2ormPl99LXa5qvYk8usGpKV9Qsy8k8+5rW9/d3eUjazpRNwq24B7j9Mm3tl9osyCTva7X0M5quzE/3i5GSjuqJgQrJUAshoe9Ws+3p/8CwkUUagYsg8HKDMLJCUd2ZeeS0ilwGs/TBdeKPhcE75BLTWE+8TkNrzByRzpoAok7g5xmq4oOea1XFxEat3D4WNNL9G8K4KhgFGtOtl8lI+NtcCgUPeHsd5N3Nx7lHax2ruo/52HHWmtZj7bLkRnHfpCkUJFokhzpiQPICH+Jl2Z8qpODENbgJRnEr2d5bCRqHd+p2g0KoT8iJWHEwSjmbUInLp4/hq6HPzJ72ob5+tM1OJRqr3ORAWhB3jQhUGFqSqy3N+DpVExfHupkkhi9or9hqf1YvyhX0WaQ84KLAAbtZY6BQ66ycK4tydjCG8IyxqBPz32/lDPUPTcskEJ7uVS7Cs6joj9mSDdeYU4jYlqetKvBdGC86p/9BDj9J3fnnzNA2CAirHVgWWbsqxzaAP6ltoMC6L2dqmuC4gwE8M47gV63gD2ERbHOfey2XHhPOw7FF+s8Z9paEqyYEO0e26zB7/8ZB6MnyDEgy4ltALa8QI3I+Q6mc/9f0ICVucl7/iyAQbMiEMjyr4mjQbnhNkrYjLx9jfPllEfGzBrzHYunLXf/JVyhqa/GTQuCDyHwYOWGV6RkApiB7sjM+8vpiyELKTxyKaYzKjKkyfFbb+EjuDmZVevx5Jr/pPeF99R
 bFB+cdoB
 mlMTQR+oAELuG+mZwhYKIIzP2rBZpwpzhnCnvrlzygHaT6a9kOXfE8J09DX503HC2LgqsZMl3JsNQXRjBkUU1EVSW8Qu9eCNfWqXBVdSjFsa0/hRV656hx2AcOZ+8PEBy8tm8QNNuRyAggSww5IWwDANS2UWSIjUBJIT2rEiaH71fZ/jZfCp/f+OMatBgzJFCzlRCbptf/W9BRA37uN59I4/wT8E8Yrym75ZRCgjk3brEMxOdlCZTZ8KA2b3bobZMaencA9HNm/L3QEOc5HWI4Y2eHFgZ+2sxeDmbRVMDzwQLhxR74gMEvTPQypg3nc/ft8cNX7bNXcASr6Dn5ck1RhyAuOOKKJJricb9FKFIB/UADvI0WajOh97FQcMQygNnmIaUWyRHMQhnFFtAjWZ+sVukOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 3:52=E2=80=AFPM Stephen Smalley
<stephen.smalley.work@gmail.com> wrote:
> On Thu, Aug 20, 2026 at 11:23=E2=80=AFAM Jann Horn <jannh@google.com> wro=
te:
> > On Wed, Aug 19, 2026 at 4:54=E2=80=AFPM Stephen Smalley
> > <stephen.smalley.work@gmail.com> wrote:
> > > On Tue, Aug 18, 2026 at 3:51=E2=80=AFPM Jann Horn <jannh@google.com> =
wrote:
> > > >
> > > > On systems configured with PROC_MEM_FORCE_ALWAYS, ensure that a pro=
cess can
> > > > only create anonymous executable memory via /proc/self/mem if it ha=
s one
> > > > of:
> > > >
> > > >  - EXECMEM (like for other methods of creating anonymous executable=
 pages)
> > > >  - PTRACE (like when using /proc/$pid/mem of another process)
> > >
> > > Allowing it if _either_ permission is allowed is unusual in SELinux
> > > and seems prone to errors.
> > > Is there a reason to not just require PTRACE always?
> >
> > Hmm, that might work.
> >
> > My two concerns about that approach are:
> >
> > 1. This is an operation where a process acts on itself, while PTRACE
> > is normally for acting on another process. It feels to me like those
> > are different types of privilege.
> > 2. I feel like blocking this operation even for a process with EXECMEM
> > privilege increases the risk of breaking existing configurations.
> >
> > I think if we want to gate it on PTRACE, we might need to put this
> > behind a policy capability and let policy authors figure this out?
> > But I'm no expert on how new security hooks are normally added, or
> > what SELinux policies outside Android look like, so if you think it
> > would be fine to just check for PTRACE, I'd be happy to go with that.
>
> I don't think a new policy capability is necessary here. Is there any leg=
itimate
> user of this capability that wouldn't already have ptrace permission?

I do not know of one.
I was thinking that it is theoretically possible that some program out
there uses /proc/self/mem to patch its own code (similarly to how the
Linux kernel has Static Keys) or to inspect its own execute-only,
non-readable code (which I think would also require FOLL_FORCE); but
I'm not aware of any concrete cases that do that.

So I guess if nobody else has an opinion on this, I'll change this to
only check for PTRACE as you suggested.

