Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9BBAE6F086
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 19:20:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1E9F6B0005; Tue, 23 Dec 2025 14:20:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF6326B0089; Tue, 23 Dec 2025 14:20:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01726B008A; Tue, 23 Dec 2025 14:20:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3646B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 14:20:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 607DC13853E
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:20:27 +0000 (UTC)
X-FDA: 84251702094.20.DCE902A
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 44F571A0018
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 19:20:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CPqm/Gc0";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766517625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a5+xgM/+DEzFbXxJOlaWSbNM7nqa8vatKp2y4g04VfM=;
	b=OmZUF7Ee+bvionv7I9fd/3u2jDSWYn6B2g2GAQ9umQpMXWtsSkJC7uG44lVvCEIcfi1sWP
	U1EDl1Aq8FiB7UO4E7CyMcBOQxwRF9wwBXMC9xkWo1AS21pjqQrJ4OuoSKdwJX5G4IK8lU
	QcMHprsAlB6WzEM7jfpDW8kIWF++av0=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="CPqm/Gc0";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf19.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766517625; a=rsa-sha256;
	cv=pass;
	b=LzV2DQZs3BXjvqR2irQ7NIWRpLOGXtLSoAOs6WIRXQOpqw/uPQRAmHNBW1Id2SntqYkrPo
	EBg1qPQuBS5rvnws/3mabzX40sqxcI0bCwwZ5kw2y4weahn6rxcSGkxtpfR6fC/DavcRMR
	1rvTJSu2c5rhK69zdSQmufTAwJr1WXE=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so314915e9.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:20:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766517624; cv=none;
        d=google.com; s=arc-20240605;
        b=TiuRjuOxPVy79K7f7uWjlYsluqgokKA8/q/eX4kF39QqvmVl38TbHdOMChg0Pc+ui7
         B8bLcCd09LRxNo3BJmqq6WR9ExyuzDrRc/R5ocIxzvv1+8YvXywPHxJsdQC8p9SrM0wd
         HWD+THzmooeMcRwf7xcpel70TiLJMN9UBUYcw3+tphIT17A2no5c1z6hwGGasrNlWTmx
         bBcylVW/M9HoPIDxKFqeDoCiU4wbcTRk2ECH94srtHqSEVHzvFuUhMT9hJPKjIAr0x8U
         orNfjRRzxD+AQffvWyYuRepNSbim3NJox8e2Zf3IRPgSED+OvlG245+hCZsvXU7glKZH
         V7ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=a5+xgM/+DEzFbXxJOlaWSbNM7nqa8vatKp2y4g04VfM=;
        fh=V81AUtNqSqQDSv6OSPsSFg8ETIqE2Z4p9kT6Jz2HC5o=;
        b=fDT0lp7hDJ5I9Foi9WeGJhkGpA6DHtOJNWO4Prd9TGVSNS2Frxc98VcEBBeCYTPlYR
         wRqdNgiy7jjGFMK50J8w/rZKjgf3rxXJSZ2VoMzC3ZgAZ1ZjWMliQzjOSJ++O/1VYipM
         kHFinLkdgF6R1C4XdeR42niuBE/6T78Hu/NtbDg/hm084idvTYd2/5hcgC66JK/PNniU
         fHtY5pX89+8zp+PzsAbB0mnszG9oc7XHMRo6RjhX9bLVfPNMyyugv5n/XUqXyrMSaIpW
         Mj5Kl4qWf9iQFWcYFCwP83L64jUMEQkm2R/uCijdvQ2ZCIBqu25JaAgR7P7tRcG1GA0q
         42Rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766517624; x=1767122424; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a5+xgM/+DEzFbXxJOlaWSbNM7nqa8vatKp2y4g04VfM=;
        b=CPqm/Gc0VJpGi4WZ9pEYAXciqw15s2HzaKbOOjIHs9/k9jB+G4a4Wc7q8E+iUMXydV
         HPju81smyXfX5Io9tWn5HX/YUgUwT7l7xUX97tMhOI2vX8EplkceDL1UYpiBzFw0uwT1
         pw3cYurWzReE0C43yrJwXmik5HdeaZKQPfCRr0M7B0NL4W8fV/QFgwGPq4y7bQafJnIk
         hE/bCViYHDiYtHWsC8xd8UBUaHGP8NGm1tidcaQTM5zYRxr1nFQsgQeR7ycSGRrZ5/O6
         +mqRF1M9DAj8NK+fGXERclc4U9E66RcHQEUyrj5GZq/qKlL2oW2cXQcYK3q9IkLh6CH3
         PwjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766517624; x=1767122424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a5+xgM/+DEzFbXxJOlaWSbNM7nqa8vatKp2y4g04VfM=;
        b=WKizv/JW7JcAmI4jQZiLIEnil6JhYVbkd6wePZM135gOuaUKGtLmnVemXGnCcyekyS
         dsSlIFlDa2X3Ca8qk7H7JYgYGjBHzbiS9QmKQllfb8jsVVp0IL7i2z/oc1kTGOzZByqO
         G0tMu23lmKDOLOKO2bKoMosH0T307ik9tuYBc/+TQ8yjlZteK4L+gI/UrP6RrSGMaKFq
         N1au2dTay7Wz9pSDWEuI1CoRxRIynoRvQd9ca8UnKZC7umVYM11r5Cr3mt3g7cnqzaLB
         Rm6Gj6kQy0PIcEp1/fCbdo+UkGJrEP6vK67TdNNPgPhH6+fXW+gN3sIUBWnHqlrDOowy
         k+1w==
X-Forwarded-Encrypted: i=1; AJvYcCUTZjaLY9wx1NAE0eawaRnlO3YnnfoqaG0hsXouRGZz2BSLqVsXp7WwRiC6dc3v6nww97DxaAgTNw==@kvack.org
X-Gm-Message-State: AOJu0YyDiw7YsEy0iNRN/FFrZVPTjs94CojrMoNkdHPkGwPChuRz+XNT
	2TtiY2Wm7ZyYWqUivGhXPv/+t+6Fb4yKbsRhLDt4en2+gVDz6vwgyYGM4hiOdzaWHZzU4NqsDYv
	91Nes5NTmq5KkvAofnzT1Aaz8ozDM1665jGpS+ZgW
X-Gm-Gg: AY/fxX6zkNNtK1sug27SeMSjKho62oQyEiJoXKDQeAH+FexftUX5c97oqJyv8zhwL7s
	Y6RuyVzusONGREWrj6v+bdMfePsUpVvVASJqymTXaWWGndk1K5yq42V7O+nJ2QM80VcDN2QBHCm
	Tmm2NBSJQEw2HhWjM//axTTSIVgbyn+4A+vAw2n+veRwmBEQfoEga2F+HYZHDZAF5shu8tTxaej
	0CEP8O1TJFJeEuxC4vYa/tgtRt1R9e2wOQyXpzeZjr5t3RfGsZAjjJfY4E3Pv3+0BFLXC/yvXxx
	54bnj5WJo3/TrZQOqsKZO++gKJ2A8ha3Gy5sJQ==
X-Google-Smtp-Source: AGHT+IEG4L2KtlFmlxwH8tyJw8U1LD9lfHo+uuj+XTeCuha19uVEvcigX9Mg2ksFjQLFcEDqzYU+ZZ2oCFS9tE7vZu8=
X-Received: by 2002:a05:600c:6013:b0:477:b358:c0cd with SMTP id
 5b1f17b1804b1-47d3c6f23e0mr76385e9.18.1766517623353; Tue, 23 Dec 2025
 11:20:23 -0800 (PST)
MIME-Version: 1.0
References: <20251211193106.755485-2-echanude@redhat.com> <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick> <CABdmKX1HgSzUPS1Ot93tpctgunfHt_F_XNROB6zzpu_u0oH2=A@mail.gmail.com>
 <20251219-precise-tody-of-fortitude-5a3839@houat>
In-Reply-To: <20251219-precise-tody-of-fortitude-5a3839@houat>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 24 Dec 2025 04:20:11 +0900
X-Gm-Features: AQt7F2rw01H7QxvGsejUIuV_ynmYDaCiSn7pNjMDztmbKKwMiJ0pZlidXREqHoc
Message-ID: <CABdmKX2_UOENujpW0dXe0Z0x+4V3onfGDmHf1DMOXfDha6ddOA@mail.gmail.com>
Subject: Re: [PATCH] dma-buf: system_heap: account for system heap allocation
 in memcg
To: Maxime Ripard <mripard@redhat.com>
Cc: Eric Chanudet <echanude@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, Christian Koenig <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	"open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 44F571A0018
X-Stat-Signature: azo73n1atq9a6oazcycn4rz11itj6i56
X-Rspam-User: 
X-HE-Tag: 1766517625-979686
X-HE-Meta: U2FsdGVkX1+tkyrtzqxlJ/kQKlKVZt31JuIIEornEmnHFaQqDiVDL71U7kpMliiiHTxgKrg233OSGhSYwfHMLpfFYTtSbtDOQSH5FidPcSQDnDGF+lHBHDjt2M+2yOYs7rnSr8rytAGugqKYhgfKCgk0X1Anko91tedF3kwdU7aN7QQ5tEe5RIawU1TG2tqLdoTi+Zd9MM4RW9m8zHYhbEXnqPV6SPVR3zoNMOfjEt5YeFwivFZoG7lFEGg9K/3g+fIH3oNrwzezW0bsu22i8FdIQVQ+fVQv7L8ccsGGSQULnYcgrleUClgIlocxHOy1aQFF2zum9nakqO9jpBQHxfJjyYZhe5ykg8XOiGxt5y2rifbmpgi+KlmRfC20ZItHal9+Q7w5H5RErDYqLCCeukuYXMSweLRC5p1fGl9IKY+xnbA7gvdLXQBzmg7E/9c5zQ13cThfBrxVRO5p0iH1VM8fKRnOC0xDS6lbgsf8Kaa1Eea+XRT2brfBO6boWnXxtac8BJdKAKvo9Gqk1gTT+P3+sgkS1nXwJgWCNmQFDB0As5VeXL8xJNKvfPutvHbvnygqQtiV1Um5vGE7MJEEfzENBd5vJ38dmqhZyDieF+pj6brCN3YdhGEmXhUgBVyhjYffKA6RXsCjQW0YV85OM6P6uGF2VXCFviYf78XRSzyqV8ICZGKrzRcX5pHxBeoGiqS3x93Za5u/kkcjsZnTXVTu5Ed8l6UevoVEFzB0yYvSacvXXCnpsXVJm0YuG9njVO+xaRbZhXOZyxUQlCg5gUbdiqJZB5ynchOcEiZByuEOnoBCpS5z/21dRQjHAkCHLksZsEcRj9+Cq1xVi6Ech1X9O0jWgDWJmWlaOzMkJJM2EzLOeSg7Lljv/v7kK3so63R7ADU9lW9kdoIQDjPu8yC8eHMAfwbBslV5MxukcF/jSR5w2RrhXtlIoE/IXCB/IFakyyQehSrDuOP7oFM
 /p57P/Rm
 31z5TmSCZTVaN3M9zoDFGbFo3fDwpqdhqOV9M3XgvSsW6m39jRU5puehol9Li5MNQuchvpU+xNgAWK4O1QqgdLSviNZRLPmLZO1QXRWJhxuK/A9GtcBQaR1aSnB6y6Svl0JxIimZMu6M3OXsIap6Ug47lHgzipYDQOvWscY7yBuw8bOSaWEtHcU7J/ktMZ41DME7Kg6hQckuIa8Gyxy98tPLfnUA/EA9ydtcxCxRIowvdedF9Z5TljzNJ0PHEoGp0Aw4voijASt9Kcx2/o1SwyibWEMeMI7ErdW8dJXOrPD+QYK6qExlD4RVw7w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 7:19=E2=80=AFPM Maxime Ripard <mripard@redhat.com> =
wrote:
>
> Hi,
>
> On Tue, Dec 16, 2025 at 11:06:59AM +0900, T.J. Mercier wrote:
> > On Mon, Dec 15, 2025 at 7:51=E2=80=AFPM Maxime Ripard <mripard@redhat.c=
om> wrote:
> > > On Fri, Dec 12, 2025 at 08:25:19AM +0900, T.J. Mercier wrote:
> > > > On Fri, Dec 12, 2025 at 4:31=E2=80=AFAM Eric Chanudet <echanude@red=
hat.com> wrote:
> > > > >
> > > > > The system dma-buf heap lets userspace allocate buffers from the =
page
> > > > > allocator. However, these allocations are not accounted for in me=
mcg,
> > > > > allowing processes to escape limits that may be configured.
> > > > >
> > > > > Pass the __GFP_ACCOUNT for our allocations to account them into m=
emcg.
> > > >
> > > > We had a discussion just last night in the MM track at LPC about ho=
w
> > > > shared memory accounted in memcg is pretty broken. Without a way to
> > > > identify (and possibly transfer) ownership of a shared buffer, this
> > > > makes the accounting of shared memory, and zombie memcg problems
> > > > worse. :\
> > >
> > > Are there notes or a report from that discussion anywhere?
> >
> > The LPC vids haven't been clipped yet, and actually I can't even find
> > the recorded full live stream from Hall A2 on the first day. So I
> > don't think there's anything to look at, but I bet there's probably
> > nothing there you don't already know.
>
> Ack, thanks for looking at it still :)
>
> > > The way I see it, the dma-buf heaps *trivial* case is non-existent at
> > > the moment and that's definitely broken. Any application can bypass i=
ts
> > > cgroups limits trivially, and that's a pretty big hole in the system.
> >
> > Agree, but if we only charge the first allocator then limits can still
> > easily be bypassed assuming an app can cause an allocation outside of
> > its cgroup tree.
> >
> > I'm not sure using static memcg limits where a significant portion of
> > the memory can be shared is really feasible. Even with just pagecache
> > being charged to memcgs, we're having trouble defining a static memcg
> > limit that is really useful since it has to be high enough to
> > accomodate occasional spikes due to shared memory that might or might
> > not be charged (since it can only be charged to one memcg - it may be
> > spread around or it may all get charged to one memcg). So excessive
> > anonymous use has to get really bad before it gets punished.
> >
> > What I've been hearing lately is that folks are polling memory.stat or
> > PSI or other metrics and using that to take actions (memory.reclaim /
> > killing / adjust memory.high) at runtime rather than relying on
> > memory.high/max behavior with a static limit.
>
> But that's only side effects of a buffer being shared, right? (which,
> for a buffer sharing mechanism is still pretty important, but still)
>
> > > The shared ownership is indeed broken, but it's not more or less brok=
en
> > > than, say, memfd + udmabuf, and I'm sure plenty of others.
> >
> > One thing that's worse about system heap buffers is that unlike memfd
> > the memory isn't reclaimable. So without killing all users there's
> > currently no way to deal with the zombie issue. Harry's proposing
> > reparenting, but I don't think our current interfaces support that
> > because we'd have to mess with the page structs behind system heap
> > dmabufs to change the memcg during reparenting.
> >
> > Ah... but udmabuf pins the memfd pages, so you're right that memfd +
> > udmabuf isn't worse.
> >
> > > So we really improve the common case, but only make the "advanced"
> > > slightly more broken than it already is.
> > >
> > > Would you disagree?
> >
> > I think memcg limits in this case just wouldn't be usable because of
> > what I mentioned above. In our common case the allocator is in a
> > different cgroup tree than the real users of the buffer.
>
> So, my issue with this is that we want to fix not only dma-buf itself,
> but every device buffer allocation mechanism, so also v4l2, drm, etc.
>
> So we'll need a lot of infrastructure and rework outside of dma-buf to
> get there, and figuring out how to solve the shared buffer accounting is
> indeed one of them, but was so far considered kind the thing to do last
> last time we discussed.
>
> What I get from that discussion is that we now consider it a
> prerequisite, and given how that topic has been advancing so far, one
> that would take a couple of years at best to materialize into something
> useful and upstream.
>
> Thus, it blocks all the work around it for years.
>
> Would you be open to merging patches that work on it but only enabled
> through a kernel parameter for example (and possibly taint the kernel?)?
> That would allow to work towards that goal while not being blocked by
> the shared buffer accounting, and not affecting the general case either.
>
> Maxime

Hi Maxime,

A kernel param or a CONFIG sound like a good compromise to allow work
to progress. I'd be happy to add my R-B to that.

