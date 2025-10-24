Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 893D0CCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E550E8E00A8; Fri, 24 Oct 2025 10:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2CF78E0042; Fri, 24 Oct 2025 10:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D69E38E00A8; Fri, 24 Oct 2025 10:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C33388E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:37:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D0EC140E86
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:37:27 +0000 (UTC)
X-FDA: 84033260934.26.E6BDD27
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf20.hostedemail.com (Postfix) with ESMTP id 90E581C0007
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:37:25 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XXaFh2QN;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761316645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GmHMlLZ8cvGQzV1SOkvzrPxFQut2bZwdLJk1swGEGSk=;
	b=NlRR9daT4qe92yagWZt82iEW+xsUUjoPFwHVug4lxBXz65czY3MyMMdVWS6q2oeAewHOt1
	iivAl0MiRQv3YXrqx4D9nSvUKyKOsoaahgyadci9iS2k2nNTvjfWMoqsQXrzRwziF+bXHp
	vecm6F8DQTfyG5M9TxfDY+UhBQ/srOE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761316645; a=rsa-sha256;
	cv=none;
	b=xg0iHXpECeFaum+V5qi77LO4mvwVuaIJt0xikt3a7Xiyrdll2SOA5Mcu696SUDziD/Ev1/
	QywcZhylG/LAWw6wL0naqrWbZXCb3NhFI1W9taRB6e2LJz3YTXx7oXc7Y5k15tD+QBaEhc
	1ULDfmbBeEwGbnHrCniLTEjOVQlE8LU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=XXaFh2QN;
	spf=pass (imf20.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-63c0c9a408aso3533305a12.3
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:37:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761316644; x=1761921444; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GmHMlLZ8cvGQzV1SOkvzrPxFQut2bZwdLJk1swGEGSk=;
        b=XXaFh2QNWa01zBdh/tv5mb7179mNy097MlcyrOHnmTdXVMJswd4sCvzATWd6jHkUmq
         7LM8aBscU7E2fKLWAhFgZdfpZ1fVcZqKJ4aDgRzyt3zSPALGRMxnp0L9PaQQ7oHsr2DD
         HXcZHvOxS0gyrw2oDsfY7mvvT9XArv9lpqyRZl8j3r/37FeWdwPLgwyse32bdN7Q/iMM
         Er8B3muo9StODKJ1nIDM8N6LSEDvXNHAVxR50E0jki/GMcf/xr5f/be45fmc+y6SoNBy
         67DWivI2T/fsiC0KQix0NxYJKzhwzvGITVaUXeCyUtWEnLvzegOKPeWW6GWiML0eTMeQ
         JSlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761316644; x=1761921444;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GmHMlLZ8cvGQzV1SOkvzrPxFQut2bZwdLJk1swGEGSk=;
        b=XJDIH6dIP8/Z2nnC8o60FLM33d7xfDYdYU3rJOLTyUMDGJsMSEKviiYj7PYbfwnxUr
         WAQBUTZa3M/3yKXVsa6MdGYjDLuwh0by1g+NqA3yM6UFvBchwHaqa6a84rLAQbm/+4oE
         FyWmP1NgJvgv1Tx4nksC8zSId3hqzaS8+cDmIjiw+1pa4y0mom9ozrEKp4CZ/NWBy8JP
         rOaWRUnCa/8XS3CzOB3501DvlJ+ZgVJBC3zvqUZXsbMUwoB1hai31WWG5x++7p6Zbxgj
         Ndn1Pl0Cmd/681+yv8Tq1Gk3itcsuHAd8TY6arPEfNnDzzdFSgKAXGuP8XfEuYbQDbjM
         WcCg==
X-Forwarded-Encrypted: i=1; AJvYcCV0i6GSx12wf5/Ba92TMYQzB8UNv//8d7yF4TU/dvLk/NJix8xaT8WXLD65SIQjuR9K5IFWAvF/FQ==@kvack.org
X-Gm-Message-State: AOJu0YxzvGZ4Nu+5ko6WgmCRFFMmFbXDcWxpq8Fene6Z+oRbMneTWOf2
	2PDi+4h0QmPjC79iwi6UxAC1UUbYeHsGnOynQ58466Fnj07099pyfVQgU8rf5dUmf8me3iyFQGa
	fNtGJpQY1KBMmTZsGHjVEDcnEFHkSvtG4Q0MjLfJNPA==
X-Gm-Gg: ASbGnctVj68wMPf1gIu99tFheru1e+BHb/0x0DHinPW6GYi3qCIfbtehj4mp3UCgkZy
	FseoUrtV+iYUI+jTcBWoNskZWZEHwKa+GzGOagrEy06YNtqPWkReg20U7SWY40Ar3bY0DWmOk+M
	zhOcUXTrxWjTOD8wl7Yb/2n958YhlGG71YQCBhNcnoUKSB0VAy2DwHzNSZUa5VSObgBEsw7+XMM
	XRDLxRGIiIuAyjC5xwYTvHx7KqLxs6jyQKP6caVwsB7FA/X6hDR1rlGRe/AG9cIQLZd
X-Google-Smtp-Source: AGHT+IEfOi1byJ+YLjxux8pLcP3Y0/44GAhTeTAdDPQawfljn6Do83/M7DWjU9PXB2SaCV6T+qWh3glv4Xxf9wCVO9c=
X-Received: by 2002:a05:6402:2743:b0:63b:f909:df50 with SMTP id
 4fb4d7f45d1cf-63c1f678160mr26420883a12.14.1761316643832; Fri, 24 Oct 2025
 07:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com> <mafs0v7kgjoxq.fsf@kernel.org>
 <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
 <20251024132509.GB760669@ziepe.ca> <CA+CK2bA_Qb9csWvEQb-zpxgMg7vy+gw9eh0z88QBEdiFdtopMQ@mail.gmail.com>
 <20251024142014.GC760669@ziepe.ca>
In-Reply-To: <20251024142014.GC760669@ziepe.ca>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 24 Oct 2025 10:36:45 -0400
X-Gm-Features: AWmQ_bk6wACdguYPSb706om9VW_qPfXpGj3IbeoEqxd6IkOxzPID_oUmtMSi-F4
Message-ID: <CA+CK2bAmPN+v7SYsdHA+RL4kFfnoQvKqTqZ2YQ4wdq6dnFkotg@mail.gmail.com>
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org, brauner@kernel.org, 
	corbet@lwn.net, graf@amazon.com, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org, 
	ojeda@kernel.org, rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org, 
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com, 
	glider@google.com, elver@google.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Stat-Signature: 4e4afqu63kctgm5ttqezuktdjf1jzsc6
X-Rspam-User: 
X-Rspamd-Queue-Id: 90E581C0007
X-HE-Tag: 1761316645-683928
X-HE-Meta: U2FsdGVkX19o6wgwKUOO5zlIse9isxVadasoKWSNpPRWMYHffdxc7cTzcwIi8oC6h547maUWDUDDBix+Qj8u4W5Gzleivn5QzgZBIsftcMxMFvWuNlNqScrZi6aDAULtrKpfnMG/tE8EsE4OSWzzfifSFNRG4OyBF9cy92HRb9YYxmv9ebUP63vyXP4W44AisZBJjvlcJGs/1iJfNajw1/PxsO4s4lvP1ais99rKKbjEqASshCbEVpxMGgica67GU9Uj4Okl+SE5rZ2iVEOVjHlHcsD4xlSGO2FBkP+9QinwinOiBm4gUXOEcbzcjBNqCG4RjIsI8qkm3HnBBRikutK1wUabWPAYoOH2pl1gnOu1WDelbQ0KFiLvFTdyv71K05u7yX+3nG4Go7zi0kgSBkjZk3GEh5L98aoF5HJN5K+VZJRr5ryhuiOIe6CPSXGumkw0NR928Fo+SGEc7t3I7nWIZaxr3bOM5LHGRJGXydltKMVkuIqb59exK0IZ2khs7iWt7YgsR4LQyhvgslsgqdZgV5W4CyQgG2SOZkhpE54yhb0Pucsu9n4gGJe3WmNIoOoLm9L8VV38XX5ZGnIKiauA7JFgTLH1/BA5/gVF6u0nn8zixLwUCcZptfTRQjjhzBShfOgI5un6u3oIVn+8du+2JteCxvwpNk6lqs1sMqcpzA3LhwI0t2LwibHiyMQrJaNVeeAZnERtWDR7rRi3ZNsfhszsle8KS+ueP41V2msQuasfG++TSfP1OWlG073dp5FF3/VbHOKRjx0rKfT4glJqTab0LkcT8iuL3I4yrtGH7NjIfB17SF5yjdrpdJZwZknbCi//oOoWdaq2LJQJ5hf6mQDdSmCbCn3DEHNYoQOwSJYXGrFH0phhmALvinzqMymCVUQx8woY71RacLrtQ78VvWwDxc3J2/SC31wvFeD0xUQDdba6CY8wm7ZJQnru7f1iEWXhj71aAVi2HtF
 tJhedd88
 oLNpE0B/SGf5b8tzuaJLO/nI7Px+f8ZKCTd9JexwC67hXnC4R/vtHGv4WXJqlTXZ2iY4zCHK0im35j3rKy5Rr9eEmUjTMNEV1Qc+Q1X1eNL4CU27ME2bgYgWSSPna2/Fnym04yVWCqnvlDAIhUXtzV0FN/tc/V/815Abv20d+u0+XFBYA/oDqBmP/LMiSVHVlZWtQRC9jgmJFGLW5jfJsWB66q1veD2X3RZx73bR+6u5mjO9B1UnFlBFUpZb2aHnsVOt1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 10:20=E2=80=AFAM Jason Gunthorpe <jgg@ziepe.ca> wro=
te:
>
> On Fri, Oct 24, 2025 at 09:57:24AM -0400, Pasha Tatashin wrote:
>
> > You're right the new kernel will eventually zero memory, but KHO
> > preserves at page granularity. If we preserve a single slab object,
> > the entire page is handed off. When the new kernel maps that page
> > (e.g., to userspace) to access the preserved object, it also exposes
> > the unpreserved portions of that same page. Those portions contain
> > stale data from the old kernel and won't have been zeroed yet,
> > creating an easy-to-miss data leak vector.
>
> Do we zero any of the memory on KHO? Honestly, I wouldn't worry about
> the point it zeros, slab guarentees it will be zero when it should be
> zero.

We do not zero memory on kexec/KHO/LU; instead, the next kernel zeroes
memory on demand during allocation. My point is that the KHO interface
retrieves a full page in the next kernel, not an individual slab.
Consequently, a caller might retrieve data that was preserved as a
slab in the previous kernel, expose that data to the user, and
unintentionally leak the remaining part of the page as well.

> > There's also the inefficiency. The unpreserved parts of that page are
> > unusable by the new kernel until the preserved object is freed.
>
> Thats not how I see slab preservation working. When the slab page
> is unpreserved all the free space in that page should be immediately
> available to the sucessor kernel.

This ties into the same problem. The scenario I'm worried about is:
1. A caller preserves one small slab object.
2. In the new kernel, the caller retrieves the entire page that
contains this object.
3. The caller uses the data from that slab object without freeing it.

In this case, the rest of the page, all the other slab slots, is
effectively wasted. The page can't be fully returned to the system or
used by the slab allocator until that one preserved object is freed,
which might be never. The free space isn't "immediately available"
because the page is being held by the caller, even though the caller
is using only a slab in that page.

> > As I see it, the only robust solution is to use a special GFP flag.
> > This would force these allocations to come from a dedicated pool of
> > pages that are fully preserved, with no partial/mixed-use pages and
> > also retrieved as slabs.
>
> It is certainly more efficient to preserve fewer slab pages in total
> and pooling would help get there.
>
> > That said, I'm not sure preserving individual slab objects is a high
> > priority right now. It might be simpler to avoid it altogether.
>
> I think we will need something, a lot of the structs I'm seeing in
> other patches are small and allocating a whole page is pretty wasteful
> too.

If we're going to support this, it would have to be specifically
engineered as full slab support for KHO preservation, where the
interface retrieves slab objects directly, not the pages they're on,
and I think would require using a special GFP_PRESERVED flag.

> Jason

