Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62E79CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 10:17:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549046B0088; Thu, 15 Oct 2026 06:17:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB2B6B008A; Thu, 15 Oct 2026 06:17:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E9476B008C; Thu, 15 Oct 2026 06:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0C4E16B0088
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:17:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 995D8A09B2
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:16:59 +0000 (UTC)
X-FDA: 85324457358.02.1BA089F
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id B59F3140004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:16:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OvBh4//J";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792059417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7RGsYQTIYU0+A9ayCb7SrWoBueBztNc5suUM+fjhzoQ=;
	b=cv3MzvTWzKbDFlFC5OZspA0PnAl4PK/nhUwgDZzpclUN8JvxqDAsC0OVrubQsAlBn4X5te
	FdDFjwXIn5JuqgxU64lGlW4CFDcgF/0MJMpaNgo+EBjRXcExnNWzBI6LHZ6NZdoptj8dXB
	W43rECfQ9sQVLbCAOmcPSsgrkVNvLo8=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="OvBh4//J";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of ampr.mhd@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=ampr.mhd@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792059417;
	b=Od/GPAn+0VPyuTOIsKi7rUnwHc3zaIkXLX/8LFDDWbR74ZNTopgGzGCaB4TGCYOj3vQ+2k
	9YcCu3gN9srUWfLgmfrCxfJvzTz4KDRrUGpmWvvmQ272xJFbseE533lgfyKSm+uV/9HnYl
	KYLkhQXFbyXiFtMG0lFpTbcqSEsLGoI=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5bccc73eea4so2590193e87.1
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 03:16:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792059416; cv=none;
        d=google.com; s=arc-20260327;
        b=A128gCmE4E8toYUQqNF9NXGgrXZlwUczUj4ibHD5IBAMG82E3rVhkP8z2yhlZNDIdg
         v+qLa/PLy/P3Z3a5H0BSrY6XXUoQ18mjy2BC+sb/2JLHYHIzaTFS1LyKKDmKFnDPUwJR
         mWKNLbGFpJW/mDoqCatGBqyhwzPtUFiKACopwm2JD+LXAKbgXp1Wk4JTn7CydW6VvagE
         rourvHLt6F3f8Ztc9BZ67Iti/s4XWtYhmyXgDLfc8mFjq9zDRsdWToBxbSMHmrHlMKj4
         fLsuXRcDzljItfH1DD90U7NnK64wcKCz4guf9oOCsUOMbcJqXqlz+8NnHS+6zftym/eo
         DqKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=7RGsYQTIYU0+A9ayCb7SrWoBueBztNc5suUM+fjhzoQ=;
        fh=ziShhgjUKaeoEV5uB3m+A1p1+MMLFUBACjcnKpp4uKc=;
        b=bsazaZmjGnkHFc0Cp3mIFjhNowa3ZGmj5Yo8DE2MyN0bH9mz2MknxIDkAYix+EFqRa
         YsD0U6VzckdrZbzjz9uBthpqoJ4851OAV75Hz8ylmUn25+OXDYWjPz4+ictXfdb/twEj
         Wv7pZW82EIqQUVgaAGOkWZRJspJEubsrCm7CTB+awhLiwFHgQX2LkGxCPi84qaOAJmxr
         3dXYCksVuU3LI/h7VYQ/pu+GA1m20Zd5O4Xe8E8wO+0ZQmQBUM/JiqrfttdPSLlE3uMZ
         mxRJxL79pRs2eECGiwV/b+hGKPC0KyWxjTL8u2FPTAGxFshFWYsaktkuVvbfUdyr7jue
         ZQxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792059416; x=1792664216; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7RGsYQTIYU0+A9ayCb7SrWoBueBztNc5suUM+fjhzoQ=;
        b=OvBh4//J68qR6RsTqd1VSw+MIrc16USXNjui1btXwmJyU8r+ozLqzTfXNNyv42IQ3C
         feWP9/3vkwQjNF5n3cC44m9qZR3sYtPJbniWILnTHXjPxli1IKtmoa1s/fDlIHTD10U2
         QWSPBfEvnliN4/rKoWUX7c47WxPhPqUL1TEr4Q0/E0QasQfRyZcKofR1v4gFt+deRqX2
         SFzwMd2Z7ErgyKnn+2yJTdcePfXaW3g66XWtAXsLh4a30gD+f6ucXu6HnK3GlLWQ+r+m
         8BIhK1eUoECB1YiT9ggBpTcYrZYAvw6XGGdhTBRwfNuqRRfpJa1goZ3cWLSkaU4yLGLE
         izvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792059416; x=1792664216;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=7RGsYQTIYU0+A9ayCb7SrWoBueBztNc5suUM+fjhzoQ=;
        b=YWqW/QxUu4NIHvqDWn5fK34UF1+YKybW/XM11aUb6eCRCgZ9FAFn4xS1GM3M9mwAT3
         zHjKDiAEINcQNwk9bnrKrwfRsjqaA1TVyPbXta7+HmNuQiegANp5+dK7kOHeWDcEcmXR
         vtjVkUh8G3gSRBspx3q9d2CoUcBe3kg7+q9dE81hL4lK8gYUs9aq7Lm2WuSSUb+eiGxo
         I+71/u73YdJAPrZsGke9/pZ0sg7pkRX+UKTD4oKhscWnganwSVlMX4t6pDdz21ViLwTO
         6TFpry3qQUOWh4VfxXXRPm3U9b0Er8JIBmKPZ5zPvE352xOHcM4F22IIp5H/OZlInfxP
         rp1A==
X-Forwarded-Encrypted: i=1; AKwUvBwdwVUo+VMLgLwFuB72af4z407JAriQ+qUt+10S/wwPiIBtPlyitgepR4MLz+ESiz/+fQlfo9vTDw==@kvack.org
X-Gm-Message-State: AFq9FYIWzdVR4QfVqMX4Oje/QetPl6yv4IUVhDbEra45jqXtNvet/4AC
	jRhG5HHkCV1o9UNoXkfZgxUl6u32eaJjwlq9uPCrR+dAMvhGpcmIiyNOqhZaO9Al8fHD/atqfGI
	gYHJpW2I+XqZ13wZcH49a80MAnovE6fg=
X-Gm-Gg: AYBFou2S4Dydcu51Rw5UKtDRf7XDOcyKGBeuc5Z2faMzBuB4IUT9jOj4KXSp0S1loYd
	15di7DClShBHjbT5IU2s8XNHlQsBLlOKTfvbX4sTVdjxHK1WnNBDU8wETdurewuPUz6/v/nvsml
	z5DaPnR1LJFVEWX3QF+6nvkCscgLzBHiRbOhRmH5L1PHmoOGsMpSZZasDBEHPqFVXdoeu4VhzQB
	TJi6SJMnlPveIVpDjXBPkXTMjDXN4MOvz+qeXGUyDBWpSqNtRLOjgPg6NYrX+WSBAJO6bEhy8GX
	B3k+FWVGBPvqgJuKMf9bxGLFIb3ES3k3MlEsobJr9m8V8+9yg7VWie5N1/VCFiPBZAKbOs56sj/
	Hs8tyDaqL
X-Received: by 2002:a05:651c:1ca:b0:3a9:787a:fa1a with SMTP id
 38308e7fff4ca-3a9c55db202mr38052981fa.15.1792059415520; Thu, 15 Oct 2026
 03:16:55 -0700 (PDT)
MIME-Version: 1.0
References: <20261014191803.196515-1-ampr.mhd@gmail.com> <f09eedd2-3a82-4184-a456-6d8a3b0f4139@arm.com>
In-Reply-To: <f09eedd2-3a82-4184-a456-6d8a3b0f4139@arm.com>
From: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
Date: Thu, 15 Oct 2026 13:46:44 +0330
X-Gm-Features: AclHuK9c1uoC12fzsYkL10Fvj5EVj7kGyZlf7kLGw5eDqN6WJpFxOQyPoVmdJw0
Message-ID: <CAB_t1-AdDXPaShrLZ8wt0EcGK=PXVSwFweNjvhO1_QehhzNocg@mail.gmail.com>
Subject: Re: [PATCH] selftests/mm: test mremap DONTUNMAP with locked memory
To: Sarthak Sharma <sarthak.sharma@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, shuah@kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000e0e82c065dde584c"
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B59F3140004
X-Stat-Signature: k8ptt4tczokdmecus5je7n57ryrzk3fg
X-HE-Tag: 1792059417-47670
X-HE-Meta: U2FsdGVkX18nSC/nxEudWusUbblONDWOlMuctg8/UrOVWAD0995dBJNOVKWHX4zkMltbSmeAC/pSwUvJgI3cxS6nH9mYhIuudJKZ6IQCqWrRLDFtUHQoOm630mPj32VCs2IEa9EkFXPYptVT+97Tqvz3W45CBylGLNSc+/bWF7mD1+xQLZf5v9FKUbIgiAM2emuP3LUhtDsMS6kYcm/P2bLQoVra70FMfhUvOuRD1AAx337w1n5gnyEi1ziBg0P4VS0Ye/fM6u7N6aOzJ/NBvD7jxAM25G4isJfwQRjBVWMS49iClkcH+Hr/aA6jfgooQXm4e5OSBnaOfGLMs6m+XckGOoeuyLkH0h060/py+QyHkqaDX4XA8byWwlZsAycVBf0qWaIl0nl+8ANzf2SE6t+044PBQsl0gz7J07W+LuvRljPC5rsxC8QNuWthp7a8BNXRXb4Mqvtt5yG4tvr9brFWLhhttQkHSZdoqbXtGYNuCuydY+ShslcrFbPQCALaQ6bfRdH+4IdbP6MRtYtUOjmR3Jtjco9w1cWglJ2v9Vq3s2BBeA/NF8onfhHebRszomq2nMpJ2i9IZlHVIO3+VmhQKNiwLAc58OtyUpmet2OEYiPo/zSa0tSpZxFeULD8m/cdmBBikUhI8huao3P/JWZSMxHAAVG8xPhPov2EjoxOmL/97rnNahE4t6fsW9MFWNMz08Fn4yM92tBLz0wnae9nezG9M4Y1woqVvttvnQZg/8+rWtKw85rBW/p78jIp+g92MKLEHUmc27Le/nWgYTuc4JYXvuWj/TYQGU9HOEKsaHZGE9MTBV8V1U56CwznEewMYWY5Qdj5RIVr5NumeB3pr3Go8jrKMMN0P7Ls2CdoamemVWsloIjlOnoT98FY6qWsmdNfRYtXeFY5tZ3FaN02VSiOCxUZK6weMac5BKhu1BtDdJvIwxFEdlYHblneoeIXWxUVFoA8KVCT2HC
 C2qjYVLa
 RgD0iGBMim5yhO7NOVXsmb8Ob5n6GvksCpf+VyiaZXQnI0LSMWfI5z1GQMVD2QaOQR+vrGRAxXrZFMPoUmuuQEMxu4Two2Pap+nQAKoOwkXK4gxltuF5TXxSQlx167OC9uCEAxem/5gmj3jKXus2dWHZaYvkMYz1RMwEdBggCnc69xfDbEFYvGIvwmRXC5wWuEKWbkJToQPNbC5b+VuyCsgRDTrIOft3iAQFoih/CS9gF9WSExB+EYMC/Hb+vvWuL1KgBx1BH78d3qg7jswvyG92GJy/8w8QbOKNUu5iRkXOPRjp2WMU+PGzoccdDMg6l9ADJkmJoejPsc7Lv+7BaJAmAgmoFpgmzOY14Hm/F+T7OzySPE2TyOwgO73jHqNq8uRqK/c7JVUZOjk+A75q27iuYVjrA5YH83z2mIiBZg7U/zRXQCXpyf6okCj0FJoXZxiRDhVEMAlw+EJc2R4Plbv7XbmyAXSrn8w/o9r3TGIZJTlvgH8WP36CyLyiXCWZRR7HAd9Uc68RoUvSncxlXN1iKoG3Aow1QvDHu2oMICbF8LLtVIVGzpLIHWoXUsx6fy3jWHZ15MAGVpnN5PEOOoCCKTS/oa5clZ5yfcQYsdE1Gg7Uyx5+oxnA9R1GwHn5xiZbpbS9IQzQfd28=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000e0e82c065dde584c
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Sarthak,

Thanks for pointing this out. I=E2=80=99ve reviewed Jose=E2=80=99s patch in=
 mm-unstable and
confirmed that it already covers the partial-remap case I was
investigating, along with additional cases.

I=E2=80=99ll close out my duplicate submission. I appreciate the pointer.

Best regards,
Mahdi

On Thu, Oct 15, 2026 at 10:19=E2=80=AFAM Sarthak Sharma <sarthak.sharma@arm=
.com>
wrote:

>
>
> On 10/15/26 12:48 AM, Muhammad Mahdi Amirpour wrote:
> > Check that a partial MREMAP_DONTUNMAP operation on mlocked memory
> > preserves locked-memory accounting and that unmapping both mappings
> > returns VmLck to its original value.
> >
> > This tests for a locked_vm accounting leak after a partial remap.
> >
> > Signed-off-by: Muhammad Mahdi Amirpour <ampr.mhd@gmail.com>
> > ---
>
> There's already a patch in mm-unstable that adds a test for mlock
> accounting [1]. It covers the partial mremap with MREMAP_DONTUNMAP case
> as well.
>
> [1]
>
> https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/commit/?id=3D=
35524c870053cb28bb056fb17e715ebebec17229
>
>

--000000000000e0e82c065dde584c
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><p><span>Hi Sarthak,</span></p><p><span>T=
hanks for pointing this out. I=E2=80=99ve reviewed Jose=E2=80=99s patch in =
mm-unstable and confirmed that it already covers the partial-remap case I w=
as investigating, along with additional cases.</span></p><p><span>I=E2=80=
=99ll close out my duplicate submission. I appreciate the pointer.</span></=
p><p><span>Best regards,</span><br><span>Mahdi</span></p></div><br><div cla=
ss=3D"gmail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_at=
tr">On Thu, Oct 15, 2026 at 10:19=E2=80=AFAM Sarthak Sharma &lt;<a href=3D"=
mailto:sarthak.sharma@arm.com">sarthak.sharma@arm.com</a>&gt; wrote:<br></d=
iv><blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;bord=
er-left:1px solid rgb(204,204,204);padding-left:1ex"><br>
<br>
On 10/15/26 12:48 AM, Muhammad Mahdi Amirpour wrote:<br>
&gt; Check that a partial MREMAP_DONTUNMAP operation on mlocked memory<br>
&gt; preserves locked-memory accounting and that unmapping both mappings<br=
>
&gt; returns VmLck to its original value.<br>
&gt; <br>
&gt; This tests for a locked_vm accounting leak after a partial remap.<br>
&gt; <br>
&gt; Signed-off-by: Muhammad Mahdi Amirpour &lt;<a href=3D"mailto:ampr.mhd@=
gmail.com" target=3D"_blank">ampr.mhd@gmail.com</a>&gt;<br>
&gt; ---<br>
<br>
There&#39;s already a patch in mm-unstable that adds a test for mlock<br>
accounting [1]. It covers the partial mremap with MREMAP_DONTUNMAP case<br>
as well.<br>
<br>
[1]<br>
<a href=3D"https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/comm=
it/?id=3D35524c870053cb28bb056fb17e715ebebec17229" rel=3D"noreferrer" targe=
t=3D"_blank">https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git/co=
mmit/?id=3D35524c870053cb28bb056fb17e715ebebec17229</a><br>
<br>
</blockquote></div></div>

--000000000000e0e82c065dde584c--

