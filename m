Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5873FC55173
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 21:57:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 720146B009D; Fri, 31 Jul 2026 17:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D1026B009F; Fri, 31 Jul 2026 17:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C0D36B00A0; Fri, 31 Jul 2026 17:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3B1666B009D
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 17:57:12 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3A55160198
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:57:11 +0000 (UTC)
X-FDA: 85050433062.18.DD34389
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf22.hostedemail.com (Postfix) with ESMTP id DB3DBC000B
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 21:57:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lm48D4pC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of loganodell@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=loganodell@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785535029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WTn5nuKnJDRIJ2W+5Ct0Qi+MqrY8bd4Qgdd1o8+thLg=;
	b=53+pr1rCnTUF5W/PqnFTg7welSG8LZmC/6R2XMYJuMoHYUEinge4b5vLzC3pRnhXZCckyM
	Z2A0Q0pOToBzG5zIhisRTDba+MCpnisDcvZvxSXjVmobNRA19JpJzmHXXyHbLHa+nOJK4X
	tmn6H8f7wWhXddPlGbVNbXeTFDxZAFM=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=lm48D4pC;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf22.hostedemail.com: domain of loganodell@google.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=loganodell@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785535029;
	b=4J2Yb4uQi82IBrD/ErxUueOK8RL8Cj1b5sr+vLtbXigPg9AF45IObQOk7oJwUo5SOz/gqc
	JWZwS9n40LcaEjcpMYmYn4PeD/46LQjFL+8Rx+0sWoXmBRo4lVcLJ5r6dZFLIyXHUm9L/m
	d5eYVqOrJzburWUTQNyqnsHW/NMvkSQ=
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c10e86e52so22921cf.1
        for <linux-mm@kvack.org>; Fri, 31 Jul 2026 14:57:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785535029; cv=none;
        d=google.com; s=arc-20260327;
        b=MNZZKmu9GC8TmPDdIR31orTH+5L1dBXzwGyL1ny8aDnaMG9cd0sCyS0jbACVIUEMhd
         zkQ2s+1f94L36CNC+Cu6/+9e4eZ8Lf1fcEey9laQWWUu/e2bEFQQKfubuxgzGRApQfuP
         +r5ONOqaCtW5PGLq4aGBtCTHt/XRifPO0dY5VFL82qonoKarv+BuNV9lgM4DmNarmkvL
         mU/lNANRSJKtWqTMg0w8CiEW0nHj0KtJ7c3GFIBL0nVRZSSsu0tYOOzrW7spRDlTID6Q
         /X5MREfTKTi6ntaFoYnVTcMWQlvoUB96b+4UpZCwJagBmKE21nDCRIqu2WueXARS0N90
         zxYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=WTn5nuKnJDRIJ2W+5Ct0Qi+MqrY8bd4Qgdd1o8+thLg=;
        fh=m5silSSXO2bP0zPfDnICsrYtYiNM4P9ZPLGDxZfbSeY=;
        b=nQ3q3TUPKAFbRyWe1DvLE4RwvaxUyEy2FzVOYeRO6lNyYwPodhIktlckgitvVMNFZ5
         P1OGNlfSIBvTXi0byjm8ejd1EQZc0Ee7OKqMKiNDCukeJ0w0e+CZalLVMXTClwGgQyAr
         5eDa4Sl9LsLbzFj60guAYH+NH+p4PWaOIX93ENqzty97/7xsVWHEtzx4CzNQQV0LLHR8
         OmrZTw06WX9Y1d0jwLRSicb4Jp3uwKYhkKth48ADQlyqkQmtjUkjKvKnAZ/GxB4OIu7C
         bp4GJeHI8KdjTF3ILUUe3Zi+FdVz2ttOHOG1MxdLm7pEq7IuXlPxsLKXqJHwrqTBxfwR
         q4dQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785535029; x=1786139829; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WTn5nuKnJDRIJ2W+5Ct0Qi+MqrY8bd4Qgdd1o8+thLg=;
        b=lm48D4pCbHoNcsgB5jBR5aoOg0WOqxDXPmEHAwuAif3GtacplTuJebeQLVwMqFFKqg
         hE551TSHBPAoo8y/qSvcrrP9KO8oUMDh+A7yy3cMP0pfPzcAY6mIA8NDePSwgODzR6oR
         tNVpmnuNPM3lPe0M2NhS1f6EjK0QSpYiKbAqjKjYTIo3nAnlE53DWUe+xb7MrFKyZ1A6
         vVAuc5ieeoW8orpNcTobMei664OfhGMq35gyC25e0IQGuVuCN40pGNA/pQkuCBYKlCeU
         n2BVxc9NQjcNgz40LLpZi/US/6DDkj+popnw3/XLB8uP+n75ErXaB6UAeLsi02wEEuwK
         8KsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785535029; x=1786139829;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=WTn5nuKnJDRIJ2W+5Ct0Qi+MqrY8bd4Qgdd1o8+thLg=;
        b=TZpT7lXOQI+mxxFEO8zzLflKixlJGXvWnyoqZ+mV3zmvXLgTx9dn6Q09DVjElVitMW
         C9HRugQvP+VovjrJIS2psr0YEo4oUs/XvKFWLBVlH94YSwae/w9YY/AFlg6mGuG/sTDB
         gYsMstfDcPFlWtOiHHOCs77RHZa81dct71UWfwn8c2irIKwwJL/rW2LB5nR2I5xYNIT8
         FnPMhdtxFF/HGdfhFt/r1n2cCbHz8VnBiRYMXAkSP5OOuy3njzGeXeLH3aUWucU7PSKW
         KeuQMHb7IdYjFfcs0K3qH8eiU1z6SUnp6K+aGybLRCUwkRtFRIWM7Kq5GOPoKkBkQgZb
         m66Q==
X-Forwarded-Encrypted: i=1; AHgh+RryrJp970FyRp9eGOtrk1SCgfC0db4P0Vsb+S/Q+mpGSCYD8bMPjTPlWE9l9dKyOCGCFEzqeUX4pw==@kvack.org
X-Gm-Message-State: AOJu0YxT8H8mwuuDyWaiW72/xTzMJKmASSF2eMPXGyHi+DF3kBmfVvB8
	EizXySuAJNUchb9KpoEBvQD8EuoNXqedyRwAajlUhQGztUEdJjyVq1Fil/zbxEtqtG88mJgTj8V
	GiTPfogNLxT4WPeC8LScbvDfEWeYD15NycLBhc6kS
X-Gm-Gg: AR+sD11PxdIzc/6W7caKS9/unYkBc7TPF5ItlYjGS5f9YyIFe4Bu6jqNmiKqxVtMCeu
	U5MSREKWyl/o+2tLQm1LX7btCe7cC0XziZLYAUpakcCDr3XkcqqKsYjREXecmIvznjJWKryI++y
	ra+G3n7zk3dJ4Ppyd491LqKlGpVlvWBggeNzIVLaXXHBX+KN2ycSJLvNK0tGL1h3UhTmmZp9pKx
	zEaNKmBMQkN8w2m3bpoQIqDsKINBeLVoLqJuslp6BiSMcqU/mozzdof/pJDYpJvH2AETOWOLP2T
	tRAPo/xKHASVTTZwqa06jh3BRG+5ffMacoLNUU7YAf9fVMs+6oaWfxDs
X-Received: by 2002:a05:622a:146:b0:528:3186:5799 with SMTP id
 d75a77b69052e-52b599f9d70mr2420011cf.10.1785535028074; Fri, 31 Jul 2026
 14:57:08 -0700 (PDT)
MIME-Version: 1.0
References: <20260731215224.831696-1-loganodell@google.com>
In-Reply-To: <20260731215224.831696-1-loganodell@google.com>
From: Logan Odell <loganodell@google.com>
Date: Fri, 31 Jul 2026 14:56:54 -0700
X-Gm-Features: AUfX_mxJRt1iOFKSShrQWgDygozw0xoPdaXn5TQE46g46AolJdxphvahs4sLuLw
Message-ID: <CAD14LL9jt+g=tWwT1N5s-OrzuWeWz1TvCQLbCqTRZOi4UuEG_g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/2] Add support for multiple versions to KHO
To: graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com
Cc: pratyush@kernel.org, akpm@linux-foundation.org, kexec@lists.infradead.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000176b0b0657ef45bf"
X-Rspam-User: 
X-Rspamd-Queue-Id: DB3DBC000B
X-Rspamd-Server: rspam01
X-Stat-Signature: spquzjfsxt4wzda8cd4o6nx4rjcbx9g5
X-HE-Tag: 1785535029-968095
X-HE-Meta: U2FsdGVkX19i9RJvTXJ8QyKSpt2+rkit8BtolZWbfmTDHSDc8jTU5Cqa6Ld1UvaPizAyur7kOCV0rFMDXIWt289WZSmaWtiJF4pEE+YgIbeuwg7MCKuC4epsr7VzD7sOmz+aP50K9hpTdMvlALiv5heJcBoVQdVQ++i3xrJ/4fxdTvCzbJI10VKkqGwvOV9NfJnt/GYHEXSOfhKqNO5BRVblz7XO6PyzJWfRvJzHICTGfmucxRmX7OU/0DsCJFtXXkTGfTUq4JR6MC0bah+8qXzV4WOqnVZbHtH7P2KofJm86xJ5C6DNc8ed0PaCPRoelKWGELtiHJgBb1y6zyJDAh9Ps7FxciIg0i5VsYrBoViRCShji1DZBs95NdfjasopU8IOD9syqxbarVGRk+x/vEIc8i3niWGE6MigxEogwnQtDuot3DTtWRl8vwPe7EEZ5B2eP4Z7vL+4LrYPipKi7chjgxqtFcZ5TXT9xkW6XajJdYwPlQ5v25912ypbs2t4KeuVYib1Oc05NDkUBmboz0AOApxiUWwi5Cr9uJnL+kkl36FFieZ6SRzxszAE3seltPlgsEDZgcri230AX4trdixHMLve7sWrjhhhaW+Q2VkmtBJ1vJjn7Oy/6eew5C5vnfwyQJ0FidrZBxcP+8fW1G5B0AYLhjicATDLmkibUrrAbLrGb9AihDvzmlzw7jD/BUIzreZ0VuxoG4BOrFpby2zMkMOQdDRcrReo3HLtQ3hSe5ydzMaNXOwVIVaqagZQ+NEGRIHF5stxs2T5A42I+tV5T4qtXJ2j+3EXh0BjPiWb20UNlG8pl98ixZ3z5vwURyyFk0J+vBf14xt1HMenCQqlrjHT3DYu8TZNF3S3SB9PebtcRKXCPQpnqyYnPyH/HRxW1rPElq084eaTZtFKpss3eVawuaJmrOHvN4cp2qm8xyPTitaSH8Fy7eYE49gVF6iIdbjQkeUd2cW5ViV
 YnxkLtiX
 IbV9xFyMht35wOWhPru9tbJsMysfAuRncctlllyBgAZkU90vee9ugZSv+fT+BD7sXDQwRyztoN6vjE82/UP1zeJps2Lf0YYIE2d2WDdooDSF09BJMqtOi3N/Mu2/A1imWrc0jom0PJt5zVjSx1IegGc7jiX/YRQCoQiuA6+JOM723vnY+kYrSCfO+YdAM4oE2i2AM3RR0goc180dwExJjpiiuCoF+a9t4ilufdJgM1gt650N9LUFhuXBnCKHgWPc3TeCWtdd2Uy20AL88+L7HXQU0nFgjdaIiPQKmeo7KAmm9TyC6505bPrj5UMdD+3z2QBmyt41eRUnYjUvCczjzeXFqr05YYv7m4dVScF7WMmhxi3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000176b0b0657ef45bf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

0/2 is a typo, should be 0/4 :-)

On Fri, Jul 31, 2026 at 2:53=E2=80=AFPM Logan Odell <loganodell@google.com>=
 wrote:

> The format of the preserved-data blob that LUO saves to KHO is expected
> to change as new features are added, bugs are fixed, etc. Currently,
> LUO handles this by embedding a compatibility string into struct luo_ser
> which can be used to compare two kernels. This works if the changes
> between kernels are fundamentally incompatible. In a case where a new
> feature is added, we may want to support both versions in the new
> kernel to retain compatibility.
>
> This series adds a KHO interface to embed multiple versions under a
> single node in a subtree.
>
> We go from something like:
>
>        / (Root Node)
>        =E2=94=94=E2=94=80=E2=94=80 LUO (Legacy Parent Node)
>            =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo>
>            =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_luo>
>
> To something like this:
>
>        / (Root Node)
>        =E2=94=94=E2=94=80=E2=94=80 LUO (Versioned Parent Node)
>            =E2=94=9C=E2=94=80=E2=94=80 1 (Version 1 Node)
>            =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0x=
phys_luo_v1>
>            =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_=
luo_v1>
>            =E2=94=94=E2=94=80=E2=94=80 2 (Version 2 Node)
>                =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo=
_v2>
>                =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_luo_v2>
>
> We can also support mixed mode, allowing backwards compatibility in case
> of a roll-back to a pre-multi version kernel:
>
>        / (Root Node)
>        =E2=94=94=E2=94=80=E2=94=80 LUO (Versioned Parent Node)
>            =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo>
>            =E2=94=9C=E2=94=80=E2=94=80 blob-size =3D <0xphys_luo>
>            =E2=94=9C=E2=94=80=E2=94=80 1 (Version 1 Node)
>            =E2=94=82   =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0x=
phys_luo_v1>
>            =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_=
luo_v1>
>            =E2=94=94=E2=94=80=E2=94=80 2 (Version 2 Node)
>                =E2=94=9C=E2=94=80=E2=94=80 preserved-data =3D <0xphys_luo=
_v2>
>                =E2=94=94=E2=94=80=E2=94=80 blob-size =3D <0xsize_luo_v2>
>
> The first patch moves some common functionality for preserving a node
> into a separate function. The second patch adds our new APIs. The third
> patch adds support for multiple versions to the debugfs entries. The
> forth patch adds new test cases to test_kho.
>
> Logan Odell (4):
>   kho: Move subtree blob logic to separate function
>   kho: Add support for multiple versions in subtrees
>   kho: Add support for multiple versions to debugfs
>   kho: Add test cases for versioned subtrees
>
>  include/linux/kexec_handover.h             |  14 ++
>  include/linux/kho/abi/kexec_handover.h     |  16 ++
>  kernel/liveupdate/kexec_handover.c         | 234 +++++++++++++++++-
>  kernel/liveupdate/kexec_handover_debugfs.c |  57 ++++-
>  lib/test_kho.c                             | 266 +++++++++++++++++++--
>  5 files changed, 540 insertions(+), 47 deletions(-)
>
> --
> 2.55.0.508.g3f0d502094-goog
>
>

--000000000000176b0b0657ef45bf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">0/2 is a typo, should be 0/4 :-)</div><br><div class=3D"gm=
ail_quote gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On F=
ri, Jul 31, 2026 at 2:53=E2=80=AFPM Logan Odell &lt;<a href=3D"mailto:logan=
odell@google.com">loganodell@google.com</a>&gt; wrote:<br></div><blockquote=
 class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px so=
lid rgb(204,204,204);padding-left:1ex">The format of the preserved-data blo=
b that LUO saves to KHO is expected<br>
to change as new features are added, bugs are fixed, etc. Currently,<br>
LUO handles this by embedding a compatibility string into struct luo_ser<br=
>
which can be used to compare two kernels. This works if the changes<br>
between kernels are fundamentally incompatible. In a case where a new<br>
feature is added, we may want to support both versions in the new<br>
kernel to retain compatibility.<br>
<br>
This series adds a KHO interface to embed multiple versions under a<br>
single node in a subtree. <br>
<br>
We go from something like:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0/ (Root Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=E2=94=80 LUO (Legacy Parent N=
ode)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=9C=E2=94=80=E2=94=80 preser=
ved-data =3D &lt;0xphys_luo&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=E2=94=80 blob-s=
ize =3D &lt;0xsize_luo&gt;<br>
<br>
To something like this:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0/ (Root Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=E2=94=80 LUO (Versioned Paren=
t Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=9C=E2=94=80=E2=94=80 1 (Ver=
sion 1 Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=82=C2=A0 =C2=A0=E2=94=9C=E2=
=94=80=E2=94=80 preserved-data =3D &lt;0xphys_luo_v1&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=82=C2=A0 =C2=A0=E2=94=94=E2=
=94=80=E2=94=80 blob-size =3D &lt;0xsize_luo_v1&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=E2=94=80 2 (Ver=
sion 2 Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=9C=E2=94=80=
=E2=94=80 preserved-data =3D &lt;0xphys_luo_v2&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=
=E2=94=80 blob-size =3D &lt;0xsize_luo_v2&gt;<br>
<br>
We can also support mixed mode, allowing backwards compatibility in case<br=
>
of a roll-back to a pre-multi version kernel:<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0/ (Root Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=E2=94=80 LUO (Versioned Paren=
t Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=9C=E2=94=80=E2=94=80 preser=
ved-data =3D &lt;0xphys_luo&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=9C=E2=94=80=E2=94=80 blob-s=
ize =3D &lt;0xphys_luo&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=9C=E2=94=80=E2=94=80 1 (Ver=
sion 1 Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=82=C2=A0 =C2=A0=E2=94=9C=E2=
=94=80=E2=94=80 preserved-data =3D &lt;0xphys_luo_v1&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=82=C2=A0 =C2=A0=E2=94=94=E2=
=94=80=E2=94=80 blob-size =3D &lt;0xsize_luo_v1&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=E2=94=80 2 (Ver=
sion 2 Node)<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=9C=E2=94=80=
=E2=94=80 preserved-data =3D &lt;0xphys_luo_v2&gt;<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=E2=94=94=E2=94=80=
=E2=94=80 blob-size =3D &lt;0xsize_luo_v2&gt;<br>
<br>
The first patch moves some common functionality for preserving a node<br>
into a separate function. The second patch adds our new APIs. The third<br>
patch adds support for multiple versions to the debugfs entries. The<br>
forth patch adds new test cases to test_kho.<br>
<br>
Logan Odell (4):<br>
=C2=A0 kho: Move subtree blob logic to separate function<br>
=C2=A0 kho: Add support for multiple versions in subtrees<br>
=C2=A0 kho: Add support for multiple versions to debugfs<br>
=C2=A0 kho: Add test cases for versioned subtrees<br>
<br>
=C2=A0include/linux/kexec_handover.h=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0|=C2=A0 14 ++<br>
=C2=A0include/linux/kho/abi/kexec_handover.h=C2=A0 =C2=A0 =C2=A0|=C2=A0 16 =
++<br>
=C2=A0kernel/liveupdate/kexec_handover.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0|=
 234 +++++++++++++++++-<br>
=C2=A0kernel/liveupdate/kexec_handover_debugfs.c |=C2=A0 57 ++++-<br>
=C2=A0lib/test_kho.c=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0| 266 +++++++++++++++++++-=
-<br>
=C2=A05 files changed, 540 insertions(+), 47 deletions(-)<br>
<br>
-- <br>
2.55.0.508.g3f0d502094-goog<br>
<br>
</blockquote></div>

--000000000000176b0b0657ef45bf--

