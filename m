Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3287BD5B87D
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 02:07:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4797A6B0005; Mon, 15 Dec 2025 21:07:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427386B0089; Mon, 15 Dec 2025 21:07:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FB936B008A; Mon, 15 Dec 2025 21:07:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 190266B0005
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 21:07:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C92E616043C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:07:14 +0000 (UTC)
X-FDA: 84223696788.14.02D7D3E
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf28.hostedemail.com (Postfix) with ESMTP id D8FEFC0008
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:07:12 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="qOVDI/l0";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765850833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=etZ0EK6rCv46UcJh/ala8M9Aq++W1rrlstabB9Q2neI=;
	b=G2pf2QIdIuM+JQZnVv1yrlDUF4OMPRF3Ab+L1qVJHgS2HpPndtQIsSZIzoNA4boZ6dMV07
	J+fgN4KuzWU+hSSbJbCW4PGZZE8o4tdU11zKT1ePlRYEfUtM/zGoBNEI8gFnPLYRqbdUu9
	ob3xIXwvVFWI17LoZqBWFt2m45d9ynY=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="qOVDI/l0";
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1765850833; a=rsa-sha256;
	cv=pass;
	b=zrrffqngaFAjDA8nZCxDV3gAeTgL5tHHV0ljenWM0zXmfODe6B9BWt7I9jsAuyhYyJu+PT
	TVfwwCg0m8Go7cmlm+Z3wRDUxV2bjY4NXxMwDvfy6kFyMSekqFn0Fbf7uP82AzbRpnGNaC
	LLijsa9527LWQiUb8lOiyExWkdoz2wA=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-47a95a96d42so10065e9.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 18:07:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1765850831; cv=none;
        d=google.com; s=arc-20240605;
        b=jKIXSXgkZSlbWZcHD9F7rdhyaH+bcX+ccgLezeNAqzjP6x50WTG+d8jgYHENSiAQV5
         7bt7gEWfxY6YWLOHZLLifJ6ewdxeRFro6Lq+pUDC2TyOoa9RCUJ6crVq2u7waZoSTt2A
         CA/WjmiPsiXxk+pr63527rAva89QaO5aYalR3mK0MmvUsuUgjuLa4jHbtaZm23Wo0KcQ
         Rt8ltgPIzuoISLeO+zJqVz0Tsk4hlNJuADUqH9Bh4a+nzXDVlZbr/h9j9xp75aaDxdMW
         m5clcw92EvRpnPDPysKyk6Jn/RsCZkUJ7XIuvR66winz/z0cUhUlk8bCrj0wXNGubhc1
         Ye9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=etZ0EK6rCv46UcJh/ala8M9Aq++W1rrlstabB9Q2neI=;
        fh=XLudlDFLgxlgxezZxNhum8QIVqiGjRNeb3uA7Q3xK+M=;
        b=Ah7zodqqSLGoldT08F2JeWRtjMyqQbY86ewFevRCT6eEDV1GVC0oH5tLXhNW1zKgsW
         GSygmayI19F0mZPrDr3UkuFCKc/nHxlFMNEqHNTmmYmcm92Rg92MJYMv+A9CNvwMbCQ5
         d7MSck7SH0IWIpxiBqQmoWlMbrk5ODKVZ30RgRPfeWk+ghNCO5jQOCZAPAiaBZGYS4I5
         S9YrM9iTFMwMpmnfj/9ZXpmO+mhiitcZHKKPxm6MeMrwAfIeKCoQUjkwnO4k41/62K3W
         2FX/9BIcnY8ziMOQtVv6RTOjYiiUsmIzqkZlwV5bt8vYdFuIoBA6hicbN85HNNATOSig
         +V9Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765850831; x=1766455631; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=etZ0EK6rCv46UcJh/ala8M9Aq++W1rrlstabB9Q2neI=;
        b=qOVDI/l0+S7AYuX49VmBwQTRZSAEchACkYMb3lomQM6VysxR4ezQye246yT/kqXrHN
         0+2gykgzcxqr5ccudpGB7iY7OTL+yIQYZAzoJXvnqS2tpkgSi+biqS/+IgksDtp0ltU0
         oU3HxHgSsHcp9qQak0PVHbLmuHfeVl65XyzdeepgqoLlPcZoZXfVoQ8vShV9W8TUeGZO
         5ZsmGz34gu3xnxA8yEHbo7JBcPZpk5VKBXTAPO/l2JKIrcjhPtaJJh8osspQBv3fOWlN
         otlkrRpi7iGvX279syYk6p60OuCym1hAtueczsBZx++UWTE1QtqPTKCJ/02hQbV9LFWK
         7sVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765850831; x=1766455631;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=etZ0EK6rCv46UcJh/ala8M9Aq++W1rrlstabB9Q2neI=;
        b=XVAxz86YGGPWQK+e6y9vF7DFMeOVNSatfZKdl1AYUraTNQLNepFM4lPJsO1ff9CRTh
         fnp7pUi47+4lZGc8O7DwZkGqLgmtIUjzpNJ68SaaeGNZlGsZXVPTV7Orxlli1lNJy+dd
         3hP+c7MGvKopm8vyVeAp0sXM8Cel5rE+Z16Ra4AuE6YWzA6Hxw5l1uEK1Fv0gdZUHGGx
         XjH+ZMfqd5of4jCKW16x8v44cvm0XJNwZWsqM6mH0F4XNt4iil0RZb8szqFG3n04FCXM
         25dZA+84CwI7i8FCZXgIovP9FZt9jvN4KimR2AME6lGOkKaeXrYka8XP9M50cullJylH
         Zj4A==
X-Forwarded-Encrypted: i=1; AJvYcCX1jgeBL8pOidAh5GqHs8nKF8DgIIlw/DaMxgvsYWEhP76NzOz7kc3x5UQDo/VXY5JqfInfXNWmOg==@kvack.org
X-Gm-Message-State: AOJu0YwBVUBSBy9Dii35qtZDA8KCBug63cJmYFR15YlYnB/yMlbTlSzh
	E2kv44n0ALCIucT4GXOVrkQwXQ8ylcV6xpy/E2Q0HnOVtLfGFuQGdYhdFwqja1HVlPasnmukFd1
	nnNhzir7Gd2DPNInLJfdd1wzTamftq1hWY/QPrMHX
X-Gm-Gg: AY/fxX6KKIqw/3/jngL4UcHEbjVUsRyJxmtZj5Y88790eHniNHzPaVa1XcWDijaqVmI
	NhdFWJxDl+VDRYfMrHZkU7V59W6kfSeeNUHfDbiage8ATboeHJYIZ7YTtML/LGBAaqauJvTzMV4
	ikwXQJokmzUVuVnKExU2g1VG2F+CDn/pHgi9SRMjLzIBoFZ+/5jC4CvO982HEK8AVtH1Xdu6TTD
	128LX20g92k1FUu0utYfi9267zqqkhF7F5a5wRANdPQZRCpGx/RcPohrzn/TRDwgsYtV7x2yq+0
	3N+bGBI9Cc4tGzhlZTIRSV0BvZENQ2EeP3B5dn0=
X-Google-Smtp-Source: AGHT+IEUmHtyIm4mkuG1Lw9nrtCCNOT3mva1Q+G2lidhB9qtF9TON4fldFLcKbTg56beBWDZhQDUCL/VH1kJamQBSf8=
X-Received: by 2002:a05:600c:8a0d:10b0:477:779a:67fc with SMTP id
 5b1f17b1804b1-47bd797450emr116395e9.5.1765850831139; Mon, 15 Dec 2025
 18:07:11 -0800 (PST)
MIME-Version: 1.0
References: <20251211193106.755485-2-echanude@redhat.com> <CABdmKX2MPhw121ZG8V+f-XoOReUsCdmcug-cWDg=3WZcJ=NHHA@mail.gmail.com>
 <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
In-Reply-To: <20251215-sepia-husky-of-eternity-ecf0ce@penduick>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Tue, 16 Dec 2025 11:06:59 +0900
X-Gm-Features: AQt7F2qPBf3y-Wy7fvkcCllXNhzIQ5MM-o21_RdxOwKfkIHj_isVetCaxCEFurk
Message-ID: <CABdmKX1HgSzUPS1Ot93tpctgunfHt_F_XNROB6zzpu_u0oH2=A@mail.gmail.com>
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
X-Rspamd-Queue-Id: D8FEFC0008
X-Stat-Signature: wstgtbrobfgdm6kio78bxwcwdw3g68ok
X-Rspam-User: 
X-HE-Tag: 1765850832-469329
X-HE-Meta: U2FsdGVkX1/CMWbHp+orUDJGsxqsmmOPEFmsauz+ogHu5UpOrP8SQ9m7zdQTcJ03n626UD2Koht9HuZyOUtevpR4nNnK0V/tXQU63DyAyTvSXjCE0m9uouslQOhkRvIvoNyNZEDdXZLk36987x/l/BFFqu5K5bGhtNIdNVC5zEWkSTgD2EzorriQjGYIZ4JBDHYWbxoWLOjXsCP1j/kWQFKTCZpZX/89+7SRsFMQO4zrJr+BlHBKVEz5cgr5ATM2ctU9fW3Rnrb7TX0jeTOI0Bx3NnifwMB/p7UDRo7oeY387CJe0caHU81u5N9VAyqpurLFhHLoXDSIEwc55EYCzicyML/DIgSE71c1R+dyclOAh+RDLMXtUrNrma87NVZFz8UL/ho+pB6laFtvS6R9hSx4KYGoByU9VZcpea7Zo1b4acc8ZEm7rp7bXPtH7SBKylpcR0PxBH0nvZd/k7FVm6md2RNWwzALhZ2TrWbn77t4yrUHJGs1cte5Nj7Ax9/G6GWhNugTk8OOkBq8CYT9zl3HD/8soNJv0pbMwjvzBa85In1+yinVrYyEGcBsmTJpc8TREeV6WSU21ChSpX36p5en4DAmjcqY+1NXid6EDH02MDS0KQ6apHXUxaX302zpKHMLjC++R2uDroQEbiyfLuBJBwfdC2rA+gxMKrt/H4HEW+mtkogXQOhUmB4bcLUV8jQc1iwPrf25jbJHk2s0r6m9sFpq/7QjjKRD5fdEZGPN5n0cp9QQ/lzKsJiHPHgWLs9qDu7yOLlbVEH+TxfhUs1EXc6D8jtucSItfoomIWY2H4qRQ/bYgQDahTEWsJdkX61AJQXqW/5c6qHhDkIetky2NNa6n6tnGbBXPaXsGz+6zINTYvqoXvCByv7tPlDM4AYXjqumxanMclTMVzj3+ifa6x+7O8/fB547ZW91T1hzRRrzoR9xVmKYGWsZWHDN4EiWlDWMZOQVTwC95F1
 c7G5zG9P
 OHn/GMeS4jurmdoDL/7Rwbm23mxPptlsMxo8G
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 15, 2025 at 7:51=E2=80=AFPM Maxime Ripard <mripard@redhat.com> =
wrote:
>
> Hi TJ,

Hi Maxime,

> On Fri, Dec 12, 2025 at 08:25:19AM +0900, T.J. Mercier wrote:
> > On Fri, Dec 12, 2025 at 4:31=E2=80=AFAM Eric Chanudet <echanude@redhat.=
com> wrote:
> > >
> > > The system dma-buf heap lets userspace allocate buffers from the page
> > > allocator. However, these allocations are not accounted for in memcg,
> > > allowing processes to escape limits that may be configured.
> > >
> > > Pass the __GFP_ACCOUNT for our allocations to account them into memcg=
.
> >
> > We had a discussion just last night in the MM track at LPC about how
> > shared memory accounted in memcg is pretty broken. Without a way to
> > identify (and possibly transfer) ownership of a shared buffer, this
> > makes the accounting of shared memory, and zombie memcg problems
> > worse. :\
>
> Are there notes or a report from that discussion anywhere?

The LPC vids haven't been clipped yet, and actually I can't even find
the recorded full live stream from Hall A2 on the first day. So I
don't think there's anything to look at, but I bet there's probably
nothing there you don't already know.

> The way I see it, the dma-buf heaps *trivial* case is non-existent at
> the moment and that's definitely broken. Any application can bypass its
> cgroups limits trivially, and that's a pretty big hole in the system.

Agree, but if we only charge the first allocator then limits can still
easily be bypassed assuming an app can cause an allocation outside of
its cgroup tree.

I'm not sure using static memcg limits where a significant portion of
the memory can be shared is really feasible. Even with just pagecache
being charged to memcgs, we're having trouble defining a static memcg
limit that is really useful since it has to be high enough to
accomodate occasional spikes due to shared memory that might or might
not be charged (since it can only be charged to one memcg - it may be
spread around or it may all get charged to one memcg). So excessive
anonymous use has to get really bad before it gets punished.

What I've been hearing lately is that folks are polling memory.stat or
PSI or other metrics and using that to take actions (memory.reclaim /
killing / adjust memory.high) at runtime rather than relying on
memory.high/max behavior with a static limit.

> The shared ownership is indeed broken, but it's not more or less broken
> than, say, memfd + udmabuf, and I'm sure plenty of others.

One thing that's worse about system heap buffers is that unlike memfd
the memory isn't reclaimable. So without killing all users there's
currently no way to deal with the zombie issue. Harry's proposing
reparenting, but I don't think our current interfaces support that
because we'd have to mess with the page structs behind system heap
dmabufs to change the memcg during reparenting.

Ah... but udmabuf pins the memfd pages, so you're right that memfd +
udmabuf isn't worse.

> So we really improve the common case, but only make the "advanced"
> slightly more broken than it already is.
>
> Would you disagree?

I think memcg limits in this case just wouldn't be usable because of
what I mentioned above. In our common case the allocator is in a
different cgroup tree than the real users of the buffer.

> Maxime

