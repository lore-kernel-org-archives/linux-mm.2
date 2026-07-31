Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 929B0C55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 18:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 785406B008C; Fri, 31 Jul 2026 14:37:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7361C6B0096; Fri, 31 Jul 2026 14:37:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 627796B0098; Fri, 31 Jul 2026 14:37:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 430346B008C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:37:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CC0C0A054E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:37:31 +0000 (UTC)
X-FDA: 85049929902.01.C7B9D15
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id E32C32000C
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 18:37:29 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dM6FoyT8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785523049;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BlqxdWKhojK2gm41MpVijRMjVzR0QH+JpeA7PN4VseM=;
	b=j6VUQt27fjmRBHWqZPEteu6XnwVmTDLwwPWeqR8GKTNU8GqxEpPQ6fQ5NH+I/DrfQy9vSS
	DYVyxCxmx7D3aQHJxlKN2eZaH+qWrxA+EEtmkSVv9XUtvu5T67CT1wkbRmUs3PPnxkweeU
	+dihCWEQvpIxjpUH20XKYVeSH3R9mZE=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dM6FoyT8;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf03.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785523049;
	b=qTujUJRXdrhGncFEqAuHUFK8ky2siLatcF5VA3xSq69S3c404Ba6urYfyf8L071RBbUbh9
	NiWUJeGOd6wNmXarctACIbFbKmSAgqzXNwMCQA9RYWwK/ZH9hWvBfo0JJjgBWpTmAe2kLI
	kGhp+uD+QWg3dVFdad3ofGgkk+mb40Y=
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2cab97c86bdso13415ad.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:37:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785523049; cv=none;
        d=google.com; s=arc-20260327;
        b=fpXy6itQ1FNlQqmJuBEP8ledsY/XtjUewFZh4tdd2uYJeBq9kJQEQW8bye6d1SBWUQ
         Fxihslu3wizUnHelUTatVAeD1daPgTdbJCaH86oI1Zqmul30DvPvquYRzlriL5GK95mW
         Kq0qX6OOCsBoaMK0JlsRPoAiGgbKSbbAkafDvCnpyChuKDp9blK0r5aUblvzERdgslnp
         F1Z5KQAmAPxqqxsIUgoZPzRTiBjLUhuvG2flTuE3+DFyvFGDYD2YvAW/YFSZ4A0cQDqE
         rdDFyuZA2uTTlhKaUoPLh7Ej+oYI6+NLBBXGupMK34o75jKF1jpe7eMXHn0Ehot5cBus
         wdOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BlqxdWKhojK2gm41MpVijRMjVzR0QH+JpeA7PN4VseM=;
        fh=FSb4BzyHU9hHxiCbLaAG5WElgrHItKccC2/LD5+/g2s=;
        b=Krma0QcoDgRGZsLoWyxpqPIUnIG0QN9WCs2aaGMW21oZQL2JZajTq+bl8hJ5rm/ywS
         I/UGFMufQQBlx1Vx1xfKdtxdc/fPpTOuCIpZW8WbR8ZkII6hmmI4zdg0CSz3DBXnK0rd
         VCRcS/5y7zvGk51dmu3gLGMAtM4NG1vG+bRE2J+FialCTXHEPm1fRo9qIgwnr/Cwngyv
         +nJeIvvxtzqO3Lb1rKWnQvw8W3L9ngZuxKDtbnNLc1CZF6TlDEBzDt0J5h07xNd08ZQv
         /geDLt12Tae0EqEEnwgOfOf+M7Ig/5UDGeK0oGLGypiD2X6Nx+cPhkhrbz9KvN0UwK84
         Jz1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785523049; x=1786127849; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BlqxdWKhojK2gm41MpVijRMjVzR0QH+JpeA7PN4VseM=;
        b=dM6FoyT8nrzg7XrGhPIvqsMrwwcNreQO12vgOP8rf3WzaekjlEFW8HOytNkEWjL8Og
         vZUD49dsMkVpbFRo6ELR9rLiTWqC7SXyrX672P0YpEcyxxnukj6Wl3Fd8WHZOrP3vgol
         SKQE8S9A7+um105F+DBnyCD3XwAhxUdnqs4m677qypRPVl4jGhG5r0iHza5ZOWkKSik5
         LjmGUFC8N1HSX3wt91zH5OK8yNYTGj7msXC7bRbBE91awoAE7+sHAmJXTkUoFPqIUpnM
         iQ4KM22CoLle2f6DX8ipsa/0uoG/6FI0bbz75XzF2DAiaX5mpKXum3oJkJKIF+bxdZ6f
         yC4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785523049; x=1786127849;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BlqxdWKhojK2gm41MpVijRMjVzR0QH+JpeA7PN4VseM=;
        b=nDVk4mg5AgvLfZ3/R2TT/uwLMc0H8I+tx0MhicxPz5X6NYQUAQ7HA/iZmUL345F0Zv
         35X8l2fUKUmqZPkdmHIe+XzwqEirOFtYN7wdMX9ZYmafpqlkvGjpz//erV0KHvBtRtBN
         fMX7UxFxxbNpyYK7ZgecOLylhw+hc7iFtRg55iVsBuhlePsQd0Atd6pwouNyA5YPFoM9
         BE4rytTeg1KtsqbHCum0GghMzcrrqxtd7wnIRBb6a/vpcY/l+WjHBrsYG7oiWjsNkcxJ
         e9vMbtHBnapOq1++ZTfi8WKqrA18TUPMDRY57hsLiGLYtmTALGbOTG+7lwvahKwdU3ti
         yuog==
X-Forwarded-Encrypted: i=1; AHgh+Rq9k3oy5a4FNQeMuJPq7oAPtw3V+KU4JgC3E4WpGrVMA9zsUmw+W92r1RvBP5cH7KkBE1M/dvmqEA==@kvack.org
X-Gm-Message-State: AOJu0YyFwR4EtPGn+v4lmt1aOkx/TLspxfY3bOd/HEpsqw2ngk4V4jTP
	3qnNwiYxPd0CLpnYZubvpG7c3tugl5KOPkUghIBg0opqwXEGi6Y/fYPPIFjsybaF4j4yrVoLNU+
	KgwFP/jkCA3IGs48t3hm0xEZJb6yJxV/5Z1lb7sdzJkMcHsc9idqiXv9l
X-Gm-Gg: AR+sD11j1I389wF1asrFBojmfo8zILoiVOP/CFp6iVlFPJyKGbwQmU4Pn66w6TTIVan
	JjIb9oDqdMOm4d/lEj067LOIp+Sqs0v4TT6Qp2u207oS4oPPE771bHTW585RUI/anA/LwRcsazH
	BI5k2+sOpQLv+bmbxz3mBVwh/ehX83ONKVCHndKQNO9P6K4Dux5kr7HXYmSZQV5kXJmcELG9mAx
	MgI77cng3XtemAXyxEmgNkEjaA0zAFKC8BBuYWk7acQibpUFgqKYs+SnNO6rVDqQvQL/gnp0qAW
	bVeauc4Rq4LZgCe/lpseoRjdFSdL9BqnSBeVuGTQO80fvL+cRFnOiNw05xyuMRsnkTc1Y8N9nWq
	2Cy1P9p68
X-Received: by 2002:a17:903:1ab0:b0:2ca:e0db:3cc with SMTP id
 d9443c01a7336-2d054ab59a4mr1185925ad.11.1785523048162; Fri, 31 Jul 2026
 11:37:28 -0700 (PDT)
MIME-Version: 1.0
References: <0d84763f140ea735d790e0b30a8e954536beb875.1785455267.git.abhishekbapat@google.com>
 <0dcd8c2c-d841-47c2-997a-640d1937a77a@linux.dev> <CAL41Mv49qeLm-MmHtQGFnyzjEsE+8kvOgtMTKpjNAzDWozum2w@mail.gmail.com>
In-Reply-To: <CAL41Mv49qeLm-MmHtQGFnyzjEsE+8kvOgtMTKpjNAzDWozum2w@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Fri, 31 Jul 2026 11:37:17 -0700
X-Gm-Features: AUfX_my25Mwq0aS7OXwdUOZMkZJOe8bdV6F4qFtXAkVMi4d8PcYFxWODhZjp4oY
Message-ID: <CAL41Mv46p9bFhX-UYpZ-jk9g+yQcwtMbcQHGnfwp8rQJzw_FEQ@mail.gmail.com>
Subject: Re: [PATCH v2] alloc_tag: expose profiling and compression states in /proc/allocinfo
To: Hao Ge <hao.ge@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E32C32000C
X-Stat-Signature: tgucamwrhi19fdnjstqhqif4uactf785
X-HE-Tag: 1785523049-535983
X-HE-Meta: U2FsdGVkX1+X0wWm0uwj4F2opcfEoo1iZEpnSrfjPZyGNuHLGcEnw+mHUqLojh1O6pZc8ZjL7ZTnpWAN5TG7Xr3tYOcs/aSLWokB5WG13EhB0dcGu9SxHQkBbFNeRNykvmsq939Oco1lMHyOSq/dlpQztvDSpa82lXDAezoG+6FHFdU4fO8PLW6wGeY3s2AKTG/nTcGUq/6v56j5tReC6W/+yzpD0dajm3bqSYHafyKv8fJw1pQl+ffgJESu4u0ATpnbFmLzx8+OXmdFGF2n8xlIOQf4FW17fnr3nvPT08JM+y3uanTNwrgTs9IY8SkPANgJIHKag6Wis31OeS4+RGt0R4dJtnulgSiWiU2iWbZD7CG13jJh640Hx6ruBP/vyflbk6AkfgPf/lP5PF/bUNRjpKxKCxeGJRAzrdJu3SfGWpJBUmGU25QlwlGDp1nZFTY7LgDuYyqWJbtwn0buDrx0swY2n3bkQUrmVjoACMcEUvkEJQIbFqOEv0maYBSxz/JbKS9MfVqgDIjhHArqtLfxDE+GVqN+2dmu5OZJRdPferLujLGYU/OwjCR4A9puHUQxmf3sI5U+fwN/eByIoZ6uybVoJVihE9Drn6U7WvrpwtS0EtuOUcQIUd3JBsDg/3OF6JoouIOvOoNbuamVaTGaakMNCwUrYeDzFnyC26Yt0qTmTzcrhN5p52ba7cOQbUxXlzTdTQZzoxtB/z9RYAs/nLG6TsBEsVCdipQHb3wBFhPS//LAW0q2OL2NRgEE8eJiaD8hw9ykB+rFu4FPDe872OFR1kAjf4Y5BNMo940/OStMUrtf9FYe5I3kWgA/hqOnBpfk94MG05FdLZHizZbZaq8H9oULjxXK0mDtYvMGwcMp8QYHyAs9AmnapPt1BqtRF2DaPurKEr++9uheJnzgzeiiWPVkxYaSjdTTbM+6uDMwTcb6EgA/rOqzAZ0aoYB4r7vvcIOYFkeeyo9
 e+7hizjj
 utmPp4IbL8/zP+RhkG+w3wqAH++uCAsu0lv0mHDtatooOz1yWk/rzc/6eyYuf1xJ5k8y2DgQ30u091rVsICnkIy5YYwWGkpFS0SlDAZC6ypH8DQTb2CCBYMeL4t4kvZMq6If8bZeK4vUq/drrItg9r85quQBWuHdTI8+tto1x2Y0Sn+YKJZpwsv4vyenXZNJQQC2k7OeV6lI6k/dsWpPicSt4/MQohXujOm7w6cly8hxdOa89l2wrunA8UB6thmMaSRhcHS6eKO53aM5s3FzuQ4PYELFzmO+uOQGzgmR7Zxxx4siDv9qN05BbxC8mR4AeTKxgS7qYvTPRYFAkUkMJhD4c78lmGE9livk13nzxNedocdg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 31, 2026 at 10:25=E2=80=AFAM Abhishek Bapat
<abhishekbapat@google.com> wrote:
>
> Hi Hao,
>
> Thanks for reviewing the v2 patch.
>
> >
> > Hi Abhishek
> >
> >
> > Thanks for the v2 patch.
> >
> >
> > On 2026/7/31 07:48, Abhishek Bapat wrote:
> > > Currently, userspace has limited visibility into the exact active
> > > runtime state of memory allocation profiling and its page extension
> > > compression ('sysctl.vm.mem_profiling=3D{0|1|never}[,compressed]').
> > >
> > > While reading the sysctl provides basic on/off status, it is currentl=
y
> > > impossible for userspace to natively determine whether page-tag
> > > compression was successfully enabled without scraping dmesg boot logs=
.
> > >
> > > Resolve this ambiguity by exposing the active compression state by
> > > adding a new read-only sysctl `vm.memprofiling_compressed` to output =
the
> > > state.
> >
> >
> > I think this should be vm.mem_profiling_compressed.
> >
> > Otherwise, you will need to adjust the procname for this new sysctl
> > accordingly.
> >
> > Also, kindly add docs at the linked path.
> >
> > https://elixir.bootlin.com/linux/v7.2-rc4/source/Documentation/mm/alloc=
ation-profiling.rst#L33
> >
> >
> Thanks for bringing this up, I didn't realize that I forgot the
> underscore in the commit msg. I'll fix this in v3 and also add some
> documentation about this.
>
> > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > ---
> > >   mm/alloc_tag.c | 6 ++++++
> > >   1 file changed, 6 insertions(+)
> > >
> > > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > > index 52aece27b00e..877068241f06 100644
> > > --- a/mm/alloc_tag.c
> > > +++ b/mm/alloc_tag.c
> > > @@ -1303,6 +1303,12 @@ static const struct ctl_table memory_allocatio=
n_profiling_sysctls[] =3D {
> > >               .mode           =3D 0644,
> > >               .proc_handler   =3D proc_mem_profiling_handler,
> > >       },
> > > +     {
> > > +             .procname       =3D "mem_profiling_compressed",
> > > +             .data           =3D &mem_profiling_compressed,
> > > +             .mode           =3D 0444,
> > > +             .proc_handler   =3D proc_do_static_key,
> > > +     },
> > >   };
> > >
> >
> >
> > I think adding this sysctl alone won't be enough.
> >
> > If we set boot arg sysctl.vm.mem_profiling=3D1,compressed but profiling
> > gets disabled due to insufficient page flags,
> >
> > this sysctl will still report 1 (compression enabled) even though
> > profiling was shut down.
> >
> > To verify this behavior, I have set up a test environment locally as
> > shown below:
> >
> >
> > [    0.265503] 4046 allocation tags cannot be references using 5
> > available page flag bits. Memory allocation profiling is disabled!
> >
> > [root@localhost ~]# cat /proc/sys/vm/mem_profiling_compressed
> > 1
> > [root@localhost ~]#
> >
> >
> > I'm unsure whether we should initialize this sysctl when profiling gets
> > disabled at boot.
> > If we do, we should set mem_profiling_compressed to false in
> > shutdown_mem_profiling.
>
> I think the way it currently works is, compression can only be toggled
> at boot time. The new sysctl my patch introduces is read-only. Based
> on the current behaviour, if compression is enabled, and profiling is
> toggled off and then on again, it will be toggled on with compression
> enabled as long as we're in the same boot session. I don't want to
> include changing this behaviour in the scope of this patch. I want to
> limit the scope of this patch only to expose the current state to the
> userspace, hope that makes sense.
>

I reread what you'd mentioned and believe I originally misunderstood
your point. You rightly pointed out the subtle bug where the
compression state is left desynchronized if compression was unable to
be turned on due to lack of page_flag bits. I acknowledge your comment
and will change this behaviour in the v3 patch to toggle the
compression state to "false" if this happens. Thanks for bringing this
up and I apologize for my previous misunderstanding.

> >
> >
> > Thanks
> >
> > Best Regards
> >
> > Hao
> >
> >
> > >   static void __init sysctl_init(void)
> > >
> > > base-commit: 2ed26e8a624f41887d64e2e37a2f6ab36a118d1f
>
> I'll also wait for Suren's comments before sending out a v3 patch.
>
> Thanks,
> Abhishek.

