Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 854D2606A68D
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 22:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=QEpFoq4q
Received: by kanga.kvack.org (Postfix)
	id 350D46B00EF; Fri, 20 Nov 2026 17:24:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DB016B05B0; Fri, 20 Nov 2026 17:24:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17DD36B05B1; Fri, 20 Nov 2026 17:24:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D64B96B00EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 17:24:48 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3ED8A1401EF
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:24:48 +0000 (UTC)
X-FDA: 85456928256.10.D362FE8
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 3BB3D1C000D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 22:24:46 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QEpFoq4q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795213486;
	b=qql5lShzMiKmJXgqpa/cmm3ss1tRsHvSVWyUIXCjxeIdEnwQ+R9UYmkzGQkYKjbQ3X+mkx
	GflULcSdz1aDJ4+a+/0FFebrPO7phs0aWtO9e9HidouTp9WgKL5cTwzvH9uKi4fejaRN6h
	fcuP9/jB/yhvIfo9+RC1R0ZPGUzZEng=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795213486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1NRDdhSVMLSlkGl3vLfd9oDNXjJR/tyu9kac4iL4k3Y=;
	b=omGYGDP6ltjt3DM3pgYzFmGTUtxTw8i371ed5ESNHbicsxPFLxluSKmURveSw5whyx4WcN
	VBnAYu67mHrQkbVAJRKLevRXM4s6ctJlymsuIKS7vjA3AbPJoPRdeZljmQ/OnHKYv9uKms
	HbhHRLbhuknx174fmHAWIhkgdQaViGg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=QEpFoq4q;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of surenb@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-55c7445cf85so33041cf.1
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:24:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795213485; cv=none;
        d=google.com; s=arc-20260327;
        b=atX+AwPBfP7k3etW0mE7L5+w2FabDxe5Xgsro/xgl29IgZPBfZ9md04AqPb4Pqep2n
         zOenA5boozhSsLZfsgFJVamDcZzKvI6tWRVhMED9QRfn7t789BTzIDPJzbmitOk8pgsy
         oZN41j7hnPmGEFVEYW1ZpsMNLWrv+hCMIBYw45n7rt/+ctUoAAxGs3evZWCMlc0XgvlZ
         Fr83t3w3XKuba4ug1fBZvt5vDcMs/YOPCk9GHSdrztDnJjITzjyHiC1PfZEwRtq9pBbT
         7z8gdvJbGCVKE+rw+SWOorkUWpA2ZYdyDZBf6pwtf6J03pCtT7MV8YBeGEL3B6AZXHJV
         Wisg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1NRDdhSVMLSlkGl3vLfd9oDNXjJR/tyu9kac4iL4k3Y=;
        fh=9P/cghuck3FYFU9dbVdVIPZEn5Ak2diHuY65Bg7a0Zc=;
        b=nhnFmvLcO1LBfhNF5ZyrWasz6eM5eLhlSbI+UjzO3X7kU1zOqnzUbg1O5FHR3zkrP2
         j6b9QLHrm8Wg4uCwQZE7CSPdcw0ZogPbQ+cKicA4AOOzIi/Gwwqb85Locb2a88AsBJwr
         tCuVL7ltui8lX1r2rqU++Xfxnov9esPdegz6divKSDtZoKbB36F3hWLkoj0UjVUP8viT
         XNuzkv1ycyGDL1Zil+ED+vdJ700RNzKNiBzxqx12kKvZ5d9q9jnulV4BN8HeB9H0j3h1
         5LmhzuQYoIM0PUYYGC6NHcmu+WNRISJdGeZ5O2wrFo6eV+JOuN5kKcfvJQhPRkIAxdi+
         beTA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795213485; x=1795818285; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1NRDdhSVMLSlkGl3vLfd9oDNXjJR/tyu9kac4iL4k3Y=;
        b=QEpFoq4qDfmGRcKrILJgl+XDXRlx1AFYtmvp32Umjd0xTX6uAx9pybSWWeUsNmFd9H
         29/SvPSPf7NhhjznsZr2fb0HwOwtUapl2kgoYE53MP0VfpAWOTwnlYT3eCJcTNCPwprk
         8XxXb0z0SUEGpr+F15chAPFr9EaPdZgr1HB9426KXxWJCA7yJNi5jzbl3QRnE3ikTqUe
         aDQttCFuG8tJJSw0BO/aCXNdESDbOHMhQwtGZcajqnmbqCYJpw0YwbnjUIxNXSQl5wSe
         nrD5/MCP1ScDGvtCAOqMBVlj+gvDRjtR87GEt5OJpN/ewQewChRA8k6/UVB5erOukodN
         aqQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795213485; x=1795818285;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1NRDdhSVMLSlkGl3vLfd9oDNXjJR/tyu9kac4iL4k3Y=;
        b=fQ0kitIML840CopM/sBb3FnLhVFa2Kn0LAHruQnOE1qjZQJdsRhFP0linHhPQpQ68K
         xtZx3rF0JXryXraMsJz+oN3Mb49faNHIl+3eRWW3d95wOKm0cf7uygU4KAD4EDkrM65+
         IjaOQTQ+BmrYek5C7LuLHZNip4e3Mq+mzrXwo8g9rmpdsKEmyvVkKC8ZtNzwpsNLnsTa
         J0vjRhDMuudoeJglGCq714uDwkp1Y+brMcSs5Y9KQ00LBBMC1LWFTZoLnb9/KX/oVPuD
         RHv0cSa1C8a4MXP4luMAd2wCqmgqtZV3214PXI3iEcaFRk1YEab02gnX2U/j4SahNPvI
         dGpQ==
X-Forwarded-Encrypted: i=1; AL+hErHEiyQy0yR89btPkdqsj7R3JMU6VIiUH5+4fNtAuxW7ZKoqoYcJYFeEf4+VbmtQUe407Z2JmpgjXg==@kvack.org
X-Gm-Message-State: APuU4Z9yE9P1KjB5+ddBDX3f9OhXIlucklrLSrIqofErJxMdRNOnsKGo
	twr2pLD2aQcUdBItEmGQibJ5SOjEyr5tuMfNgQrAYvCn/q1lMXbGddz1p5mUxkNS0opOa0JVCe3
	QC8DL3itvUBfcUrFaO80RnUUpWTWONCJxmyHFP5jt
X-Gm-Gg: AYBFou21uoPXXxaq8Xyz5eW/t9Pl6hZXjr1ibVLWKHyHtFtbLppHQk04tND4foOvUW8
	FVr9zvxgALGh1pk+24K3/jhtXiyXa6zVknenmlpZZvcK8SN7JPc253lDEnC5O6qROkGBlBw7mJy
	89rsM1ZVNZwRA0bgwgWtNQSPOSoPhCh4CkpUw0PzF6vW35btwzhXxe0u9l6kLtnKHdDrAv1+02/
	uzEDn1M9nmwBaA9hK1I9bOUwjMOj5gt7l3FUuD6ggtytRosToMIg0FXmrwKH5Lx2+f9fzZcJMy8
	0MHSk6U80ZuvxBasteAI4mGucxg7r24BIu7qyBOaSijfQqB7QACb1p6UJ2BksNpabZLXhhftD07
	CcxgSuwXa6XEoZDS2XzTD5IVFHPPTiSxvceK8yKbvWv0lUP9lV0rE+/FyKhkQ7Ti8W3uy1O1enZ
	HhxtqBtXYJ0+KsQgmdOSvGMAG7aIsKoJQA17arwLzmQebG5w==
X-Received: by 2002:a05:622a:2303:b0:535:84ef:2e26 with SMTP id
 d75a77b69052e-55d88ff9f2dmr1848781cf.7.1795213484666; Fri, 20 Nov 2026
 14:24:44 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261116071325.263682-1-hao.ge@linux.dev> <20261116071325.263682-6-hao.ge@linux.dev>
 <av39BuCsq-dRFiMM@milan>
In-Reply-To: <av39BuCsq-dRFiMM@milan>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 20 Nov 2026 22:24:33 +0000
X-Gm-Features: Aa3M54rJ7M1MnGNtQP9_VRtJkxxQVQjNLEl48ynPtV8As3xDhStKJU8NtpTSd_E
Message-ID: <CAJuCfpGoH+M6Ni6b13LOLkcCsGJdGofUwNaLaED-s2q+bRtefw@mail.gmail.com>
Subject: Re: [PATCH v5 05/11] mm/vmalloc: only flush the cache after the vmap succeeded
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>, Dev Jain <dev.jain@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>, 
	Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 77rm4j7oy8du5aucjew6dj9rk4ygn48r
X-Rspam-User:
X-Rspamd-Queue-Id: 3BB3D1C000D
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795213486-276708
X-HE-Meta: U2FsdGVkX1+nPBsyIbzBhxfBeSvNQm/Yl2aUeCorpoMTGdWLF5JqAnxi4T+qlFcd+McGiNp3gRlBewZ6t30TP1Rp+Lm652MpGsCIUyXe7HrBaRwdU8RiCqog8dhm10OvRswTggCNG+7939f3k0mB64u1lpX84F8sw8WuIL+LAi8B10xUmg7xqCfS0wkOzjDkIigblJSroWCANY9Qh2w41CaGSXTElujn5GiOVmH1eOEqajI5XRycDEw7SmVHfBTXIYrOB/c6/Rm7QamWNvSc9ws2bFhW8cQXMyeSmIKFeAqf9AvySDtVPXOYCkIiBpNTea9aVN3/QO8RsFe2cg8rkcOTd2qOgvh6J1Qci7dP0tgmEIvMXHy5cJqPam1OWIuj7Ofjl/6aItKq1uaqsRcfkL9hWNjUC0c00n0mV3BENQq/l0mSXfB+JWlGwEWCgClxarElfjW5E/PqjRRU3Yd8KgYsEdEFr7Ma/jo5xQ4vCs5eiq0xo6P8vbpMkhVzQQhga4RgKAb7UcASL4vhNBk6oWkJ4c0ElWyE406Bb94cdLm6kkWZlp8mQ/r59OAFxLqx9qYJ4Ek+FXrV3g03B4tSywJRek0hfUr9UafnTZ0XtS2Np5zWzto3+HEpELbYQoLjFkUVxPwVnhfX/k+W9sA95eSfaydEZUjrEzXeCpqfNqfO3yusPSER2T2GiaoYOouKtWKlepy4VeNhlvv1jz+8+bgweq8I6QIRhLcTyaqZ8Im9gnEQAFTyZvz2N8GVBBAzgpwl3HvLXifkiZVY9LLn4bacHE1sy0n2XO1CLJAh0E+4l33eHrWDMjYs1o4xHB/xi7Rw2eoUUTI4nDFKzZRhE0qi4LMn8WBp8+Vhe4HDU9EoLYissyGiCqo79VsTrdPAmd2WtviCW49jFvxgZour/oALxTPEcBRUkY+9t7UPbUlEVCMqd08Zzm0MWuMLgv1tmDXg5QVp6YNJc57uCOL
 wF95P1Lb
 7KylF5lef9fBiK1Ip/P3xCLhqmlosYeYzsVFsmmqIx1Ynr1qVlDRGeaXViRAOb29dTkcUtnwi0kn+sHUVk1nQFzvRc8bMDkpH5tDJhXf8AAoAFj2Yy29D8zf8oSlrgg8++1RSNVIBHjg9Dy8Dv1bS8m83qcOPhh3w5+ualShVD3RfiPE8OhpNGdo5ME2+ExHnpsY7JEnKZE7tyy/rZEbOE+g8XgtBp19Ydbmp2NlMLTfEKjDYmEvbnWENbu47fcWCp3V/rOB+wZGoqXjbrAGBGZ+nU4ACZ44Vx0hvonKhSwMyA0nHyuwseO0st2RNYNv3JPdVVDAySpCvvqpB3NlV/b60tqrbNchxAc4XlD6TIscvK1m3SRKHKf0mKUSRbdS1LBUI/TDifDLjrDXbWmIguVRy0BEMyKKTGhMclY/ehA1ra8G1J0cVmB3L72VddloJcCEsHPPTmoOjcHH01K2TYcXo0oYPurycss0GMiEj0BGx9VQ8WxdQOXHiIOG8w2TM1VUyReszVIQPQP8vkCOiCivg2Zz0jzQPPVEZJV2v8IeimUJ+FmiDGBUEDAY7pQ09/ZidtXqHYx7cT5w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 18, 2026 at 7:31=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com>=
 wrote:
>
> On Mon, Nov 16, 2026 at 03:13:19PM +0800, Hao Ge wrote:
> > vmap_page_range(), __vmap_pages_range() and vmap_pages_range_batched()
> > call flush_cache_vmap() before they even look at the error code. A
> > failed mapping is never used, so the flush is pointless at best.
> >
> > According to the Sashiko review it is worse than pointless on UML:
> > flush_cache_vmap() there is flush_tlb_kernel_range(), which syncs the
> > PTEs into the host OS. Flushing a half-installed mapping therefore
> > leaves host mappings behind for a range that was just freed again.
> >
> > Only flush when the mapping, and for vmap_page_range() also the KMSAN
> > metadata, is fully set up.
> >
> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Closes: https://lore.kernel.org/all/sashiko-outbox-178439@kernel.org/
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  mm/vmalloc.c | 11 ++++++++---
> >  1 file changed, 8 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index e2b63cb1592b..d99d7710e1ba 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -371,10 +371,12 @@ int vmap_page_range(unsigned long addr, unsigned =
long end,
> >
> >       err =3D vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
> >                                ioremap_max_page_shift);
> > -     flush_cache_vmap(addr, end);
> >       if (!err)
> >               err =3D kmsan_ioremap_page_range(addr, end, phys_addr, pr=
ot,
> >                                              ioremap_max_page_shift);
> > +     if (!err)
> > +             flush_cache_vmap(addr, end);
> > +
> >       return err;
> >  }
> >
> This is incomplete. Maybe merge with 6.

Yeah, by itself this would still keep failed partial mappings, so it
doesn't really fix much, right? Merging with 6 makes more sense to me
too.

>
> --
> Uladzislau Rezki

