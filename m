Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D97FED2F326
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 16:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4803F6B0005; Tue, 13 Jan 2026 11:17:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42E1D6B0089; Tue, 13 Jan 2026 11:17:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32CD96B008A; Tue, 13 Jan 2026 11:17:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 214676B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 11:17:09 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C774B56E49
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:17:08 +0000 (UTC)
X-FDA: 84327444936.28.1B5AE9E
Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id C6F2480004
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 16:17:06 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rl1hGqHF;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768321027; a=rsa-sha256;
	cv=none;
	b=jZkU+EgF+I2aKfB8L6fdbvGR3oadqmXWuw4IY2dbsnTZLC5N2lW9FcrmzqpImBTX4T3b1i
	yL8VB5Ex70gDadnj7692BD/t8XoZHIKo8dNDInoRnk/GyQPKvQYTon2bNfoo9Zu1FokLyP
	Pv1SOQosS4rF9TOIccagZ8bOz7icZ9c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Rl1hGqHF;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768321027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7bd+UtBJangmLuzKR9t6l9CpBCCUbDMFM6346WeMfk=;
	b=riH2XDbLVINs7Su8pZA9UPHpIBaTPiUpd3wO54Gf+840XNR4lmX+HEkENHpy68LHaB8Q1K
	BT0aSxkUlKaL8siwQaUDWLFlPMJU4wPqsp/yGegcJIsbxILeNKi9X5E0zyCLAYDrjsVuV8
	ViVlfeHzNmWTfb8H6PRXu47lAKFaxbE=
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-652fdd043f9so1965915a12.1
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 08:17:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1768321025; x=1768925825; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W7bd+UtBJangmLuzKR9t6l9CpBCCUbDMFM6346WeMfk=;
        b=Rl1hGqHFtXvmaULb2OgAbR0py0MBu8sfI7/vzK16ykiCh+0PAW88FkpV2Cf41prrS+
         oYp/kPTe6knJlJSxZFZu3pEDRPyKOJmb02HqoOd8ilUzIFHtJA7qoleOHqXhjHSni+LR
         IvsaDnzYkWia88FlOei+wvVTcXT4/HkG0JznmWzJAoBNVNFD6R/KAHjZ+yESEx1+bKib
         IB/enRsiwFTY2+nblfvzteH0OmmZmmiINp08Th/yYxSwGIGuooO5EqwsgDTaik5rTBSL
         udbuM7XqovLj9zJaAI9qchdAaVj2XMT5N9kQooAeeJb9dA0z9iH3xWc4xl4CdwnHcOv/
         owHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768321025; x=1768925825;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=W7bd+UtBJangmLuzKR9t6l9CpBCCUbDMFM6346WeMfk=;
        b=K3ngZqmzUv0xADf+7d6JwADsttz3DHfWoG0D3/oDHSYTOqNzUV6mk0gkbbDRfDL4z7
         ttjSiy5OSGfXWTJwJrgPDK0i1xPaIR/1RN8oK3LK1/cTzkMyVP3dBC06qLrDTkA3dDj2
         842U8+CGJ1+sQqBDmFV45pqjxWHu4oeOs5gE0gqdnPPiFlOK/NgCjYjx2OouRhaJvNl3
         onFOjrDbzCFyE2zwAMI3hoSFLx/mPZq3L3IKbAJzWuYrS5/tWOCUi8NXXsiQqOqIzkW1
         4v0JF2Hi03R3RymmUBDgPDIYUK9+q7jGSPdvPY/+sRl+ihya/uNBk+zlTIJhbOD7OsZu
         C+Ug==
X-Forwarded-Encrypted: i=1; AJvYcCUBoxUIxwcNBkpaUy7SW3AQZ1O0Me37BB0FpjPTcT+ek8qmNvKky7dT4qTkhi2BRd0Ai5/OWX4wow==@kvack.org
X-Gm-Message-State: AOJu0YzO9ARg0W8x9y7K48RrX8tEf3ggzFuWK2XAIbiDvWoZ9k594IU/
	Ut5qWf+V8JxYIk9pkY3Wdosz2jCeHBI6OgCdf6JQ8MAwVLfdzUGycBVhbWIFfzZAjozbnPO1ITy
	vZt9sdcQ4fvgf1bO8zYNkJDKlUa6vugr01RkfSCc6PA==
X-Gm-Gg: AY/fxX6QBWxnYmNOt8q1Q0qbPNOEGZiAFEuC1GtoJbnOCWHTNxk798tgiT5iJNYmp1F
	07hwrJDbnNlPTax5ddFn+aJiVueDUHbEDJI37nD3g7SOqeqSuePBIghvQxAT9yvJLbGwEQdbGbG
	SycxydKEWT28rhdNa9CGFCIYOwcGGkYk9B9SFazLv3j6h74tYLrBMdaNczBSBbDHx36mO32r0Us
	AHB7Shrn0Qwn7I5qVcx8O5cKRSRVf9S1gIfmFRcKSrdfp9EjXQcp43KlVzAi3dU5zPu6kZ8wHT3
	4vtlmYU3u3ECz8W96z38eFYLyg==
X-Google-Smtp-Source: AGHT+IGaOrb4zzhWvIUS63W6GXcdLWTjekK8oVCYKzqKxlL53BXhoc0Q/MVLf36WUVWDul8F8ozYwETiXuQjQyiwqgY=
X-Received: by 2002:a05:6402:278f:b0:64d:3b22:a595 with SMTP id
 4fb4d7f45d1cf-65097dea481mr19954950a12.12.1768321024711; Tue, 13 Jan 2026
 08:17:04 -0800 (PST)
MIME-Version: 1.0
References: <20260109001127.2596222-1-jasonmiu@google.com> <20260109001127.2596222-2-jasonmiu@google.com>
 <aWTJ2v9J-Aa6ykBf@kernel.org> <20260112143904.GA812923@nvidia.com>
 <aWYt0gBHxDCKqj9Q@kernel.org> <20260113130526.GE812923@nvidia.com>
 <aWZaqcStRAK6VWLy@kernel.org> <20260113145802.GA900112@nvidia.com>
In-Reply-To: <20260113145802.GA900112@nvidia.com>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Tue, 13 Jan 2026 11:16:27 -0500
X-Gm-Features: AZwV_QhiFAqf5sxAvex6xIJLGyJLdLw2dMrpAVVtkd_ClURKVqujFiU__7SUlmA
Message-ID: <CA+CK2bA2L546L5qSoicA=R2S+a0R+D_kp_uo050uBD3B8f4MGw@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] kho: Adopt radix tree for preserved memory tracking
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Mike Rapoport <rppt@kernel.org>, Jason Miu <jasonmiu@google.com>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Changyuan Lyu <changyuanl@google.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Pratyush Yadav <pratyush@kernel.org>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C6F2480004
X-Rspamd-Server: rspam06
X-Stat-Signature: 66uhj1k4e64d8xjw5pzbdgeb5cmksnn4
X-Rspam-User: 
X-HE-Tag: 1768321026-48924
X-HE-Meta: U2FsdGVkX18mYj4lO6bwgRzkvGZL/nc3FVKrZjHNPVXSKhSJ15n+3nEFpeP/0SnS7MbTJBdbNX2gGfCjSFUXV5GjW8GCQq8NOayIfNmy4fYbbkOiDTe4ZAlLVapx8/xNRgGrSDf8XuZ306ey85ve07oV8idzfIurTIHZ8N8/i3ChlSvT4iV8t27S4UkH0NVPH0Qnviq67Xlj53qXtmrXbSZE/+mE9FcvCcEAKzRifEMDCAG2/siOQ1bzzoYzb3oeSUyQ8s2uzMNfgKiQzPgN+TH3vRZUvHAaOn7WeBVa4bk2tEqTbeCfryUI9x8l1OjKnzYtQFIn/W5A6svMHqlw4bgSV7YbovwtiseYXGCT0vjU99Wxi/KhZhl0HRHsh5LKX4aoSoLAAuVDiMzJnpft9HyZztcd7Wr+GurxW0cZyu+2H5CEo4ZGd9NN+xiVvhnbRtg4fzhbxOxqYrmlSdO1R3Leq0TsLoRjk/16Tk4ctek2q7f8ulu0VUyHHZ8gjifa01y4VqoLZpaSPdQPzUpyT/yuS2AJrJRYcbIcjz3dtSgm96mh38QwtvVZDRCp/3rVzOyiixFKh5zlB5ZDFcUb+PT3MVQJrCtHkuN6ZnWiMxyjo/6hVPubNL+b1n+9NGbzDs5S3VZeJF0pqAQiStn6FN4CAIef6KCucBZlVqcn7WxQYaRnpn9iTDgF6OchQoVTnmijEjIGBIvKGQBt64y8gcKNo8h2A5ubZdEHTkinU+JXSCRLkcu23LyWA0zze2mvD/jv8OqnuMmbpbLHdJ+h0ydjBjaWqmF5Fs4vF8U19VFEZoxziWj715zLD79NJlwcANH3ggdEVW/ZybITgeLhKATH77w+OPG1mmG+luiZY7xIqq0iR0RHK3MzZqE+Cxi6imZBFbrjTkB7TyqSEfQ1nY/XYhaaBxtXBb0GjQ6tBNMN5vBss/uVPtQOH3MXvevIvMFwU968ss7OrvTpUB1
 MIZvDxTP
 IZzHkKBIr4J/j1y1haizCvtERuQom3PpBYLMJVR14y8s62fYqQIce2aAN+sxsJmZ3bbPxfIO9CV5Nbb2DtcU3JPKHJI9Usjar6/GDhlYMMDnFfJnetttLSmidTdOYaRABxZUlXidP7q3JhH6gGC/kcSsmBo7jBtjUy8KjU40G1LVSSDPhcCCwDbEmtgmfBG4HYomI0E64Rgq01EhuzNTBau7ZJTeqJUwfDQOl7b18Yx8b8o8nQ3FG7HvJA1HdTPMn6YIQvn1FvyzrJJu09p5NgHwocFcCVgchDNFmasUmvlItO6Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 9:58=E2=80=AFAM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>
> On Tue, Jan 13, 2026 at 04:46:01PM +0200, Mike Rapoport wrote:
> > On Tue, Jan 13, 2026 at 09:05:26AM -0400, Jason Gunthorpe wrote:
> > > On Tue, Jan 13, 2026 at 01:34:42PM +0200, Mike Rapoport wrote:
> > >
> > > > For example mshv intends to use kho_radix_tree to track the hypervi=
sor
> > > > memory and there unpreserving will be a part of the normal flow.
> > >
> > > I do not think this is a good idea.
> >
> > Sorry I wasn't clear, mshv is not going to use KHO memory tracker but
> > another instance of kho_radix_tree data structure.
> > I don't see a problem with that.
>
> Oh.. That's.. Interesting but sure if it is made into a library then
> it makes some sense that it would need freeing support somehow.
>
> I'm surprised there isn't a better data structure for what mshv needs
> though?

It seems both MSHV and kho_radix_tree have an ABI requirement for data
to be parsable by the next kernel. Even if other libraries might work
better, they likely won't need to meet the stability and versioning
requirements for cross-kernel interfaces.

>
> > > Nothing should be touching KHO until a kexec sequence is started. KHO
> > > calls should WARN_ON prior to this point. If a kexec sequence aborts
> > > then the entire radix tree should be discarded and it should go back
> > > to WARN_ON'ing KHO calls.
> >
> > The whole point of making KHO stateless was to decouple it from kexec
> > sequence and let userspace control when preservation happens and to all=
ow
> > preserving as much as possible ahead of time to save cycles at
> > kexec-reboot.
>
> Sure, but also the data structures should not have a life of their
> own, it needs to start from an empty slate every time luo starts the
> sequence. There cannot be cruft left over from previous failed
> attempts or something

Even if a kexec fails, as long as someone still holds LUO session
references, we might successfully kexec the next time. KHO
unpreserving will only occur once the LUO session FDs are closed.

Pasha

