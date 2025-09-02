Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C12BCA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:20:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9867A8E0007; Tue,  2 Sep 2025 09:20:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 936368E0005; Tue,  2 Sep 2025 09:20:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 825448E0007; Tue,  2 Sep 2025 09:20:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D75F8E0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:20:09 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3C3071A016D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:20:09 +0000 (UTC)
X-FDA: 83844368538.10.1CA1021
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf29.hostedemail.com (Postfix) with ESMTP id 57F0F120011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:20:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+E7JI33;
	spf=pass (imf29.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756819207; a=rsa-sha256;
	cv=none;
	b=Sau5Os0znt0gxq+HjfjvzGLIbVNTpm1lPqX3gSo68DEPzlTiR/IeQ8YzPTuQNXZJ6X/B5L
	W9ObkI1YfNVKKv3y0wWwCgf09T0ITJjkd/JCjyWQF3t5eLSaw1q5twFPTHtcEbUD9UctSZ
	dTzronY8pdzd+MSb6Zx78CtsPJ2bsIA=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=h+E7JI33;
	spf=pass (imf29.hostedemail.com: domain of stephen.smalley.work@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=stephen.smalley.work@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756819207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dQ3VtxgPqIjVYJknYVSwpAL4G7WyauLrFou64OSui7U=;
	b=ehchASPznV1ECGktPVavfK51ZVWGDq68lxA72AfWTHzce7g2pVDRP8PG+7nmKlL4kBIq7e
	vsRCVQL0VyvASSnzYtkApfoFvg5ZOm3DbEtOCPxeKiMZP2FRJR+5P0b/2shXmn5et7MOYS
	YfPMeJbSsbyGzOCL3BnG31HL4isSXv4=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-323266d6f57so5808646a91.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 06:20:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756819206; x=1757424006; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dQ3VtxgPqIjVYJknYVSwpAL4G7WyauLrFou64OSui7U=;
        b=h+E7JI33Dp0yBrlGoFSA03QftJ7qkfmcGtJ9s9Y4dWdqfrUMBYZon5uyn8owr44tZd
         MnVtraLTLTTZBQNgxP6/NA3VdjsVY14eUUCbMhT5AJdJU+JLztAhgVl0B/bMOl4W60dk
         hduwcCOm8NahtmYTX43CNbPm4HkO++v1ldAAnPob51XDuUW9TtCHwWIyIPt2Wsb4Cl2u
         wvaFoyrnPFVBzPJTDSZK3ozWYtxqSmmiPb0VtDXuKhs+9aBCwCThhXOSuwcSMULph8o3
         YRnYdtBYLGAOzI01pbE++Yy69SPR49trbF3AZkMzPs5qk9klq7oscyNg3/36muueemnT
         gGyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756819206; x=1757424006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dQ3VtxgPqIjVYJknYVSwpAL4G7WyauLrFou64OSui7U=;
        b=kFEUVCCfc3zcL4i/AteQxYmXMuUpOhhnoufOuf/Bd6c9ykQVI8EbfDphu43Th6nFSW
         /Bx0AExNOCkbv9K3KkaSDTqB9s1gIquevyy64pdpV0OrmRUjQ0Cj5BG5Oj1DW26DIPz7
         3MK73wqVq6bOhrgQrcLAaBHVXwafbV12VNg2LigzRpPjxxPOznPKEn0O/IG0gDqeWFV0
         gBcEwTt5jiOYm9e3f00a/CKaSpM+kiRl0p1S7uMo8SU0ZpxgOfqdVq8QsgZ/HVRZXu1+
         NzD2G5fi4zFjcHhxWtfAKA9q31lbV4wTyyKWWhBNWaVUNKMj/xXiBuYwopP+fvBpTy95
         dqwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVCS0Rlhbrmky8uqBRq9WOhCoIZZ6sAQNlMngE7r8D4rvgM6y+Pa5EHDqYJyLcElvnfg/YndbhudA==@kvack.org
X-Gm-Message-State: AOJu0YzBBgQuRgOvaL7RsNJi4MnVWaVF3/n9tuDKajP4yVd4r0RAw3PT
	xQ1bCvBVPY+ILf5+tMBgPxl8gnRd3aMLY5/CCN9om4koIWGdVJ9v+Znt6XjwRkQ5fAZsOOFgBaD
	Q6ILARMzcg98DJ2EvPKVsJn8RcDO95zw=
X-Gm-Gg: ASbGncurg7jIJRyV0LJ8MRC6kPhLchm2cwtcdFxoPs9y2YDILg8e1frX1ZU2ce0S5IH
	2MzsQeBWjx0mAJiSEI4JmYGr3sz2f1ZA0wi+1Qp7XXOQcwaSTRIoAo5R/cGeuq0ycj17UCyC6NJ
	PAru1hcONVlZtzWsSpLiO+82h4KrPgRIa41PHUALPgZjciuMiWYJ7NSnJTNPMb51VE6xSxfochF
	Hlaj029dvQ1nEOLIgHlx2EXrOv+
X-Google-Smtp-Source: AGHT+IHHntWNeb6307IeM+SI0zlh8EZ/o4DFwzv5FzECn4t5M558pYaWqyhZ8DpdAmPb1hEuATGnTdzfcm3dZ2CLfJQ=
X-Received: by 2002:a17:90b:3148:b0:327:5360:5b1a with SMTP id
 98e67ed59e1d1-3281570ba17mr17428904a91.37.1756819204596; Tue, 02 Sep 2025
 06:20:04 -0700 (PDT)
MIME-Version: 1.0
References: <20250826205617.1032945-1-vishal.moola@gmail.com>
 <20250826205617.1032945-8-vishal.moola@gmail.com> <5ee2b684-94d9-40be-b01c-b0538ced33bc@redhat.com>
 <aK9Ogjn71JoOM3w3@fedora> <aLBthEcK1rDPQLrE@casper.infradead.org> <20250830074747-mutt-send-email-mst@kernel.org>
In-Reply-To: <20250830074747-mutt-send-email-mst@kernel.org>
From: Stephen Smalley <stephen.smalley.work@gmail.com>
Date: Tue, 2 Sep 2025 09:19:53 -0400
X-Gm-Features: Ac12FXzjdgirVSRxrRZeOJriOnHYQBVpd6gTvQBDolPhv7jSSxNDmD9GjD6pYDQ
Message-ID: <CAEjxPJ4YLoOG42QOdzHY=w_dExq9-et7su_WPOqzyDZDfGKJxA@mail.gmail.com>
Subject: Re: [PATCH v2 7/7] virtio_balloon: Stop calling page_address() in free_pages()
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Matthew Wilcox <willy@infradead.org>, "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, 
	David Hildenbrand <david@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Paul Moore <paul@paul-moore.com>, 
	Ondrej Mosnacek <omosnace@redhat.com>, selinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 57F0F120011
X-Stat-Signature: dz5rz5kseoutchz6azrdmn5iz6imo1t7
X-Rspam-User: 
X-HE-Tag: 1756819207-822632
X-HE-Meta: U2FsdGVkX1/Yee0FJyaznvXLTMvHnjQL8406lZBCwlEO6nuNX6ckkyY68UB6bBd3JBuGAbuiTElthEkpJh+vgHmUXNWPQFjZRTStRponFoZLHavOedXF/CabufdxVe2tnG2MtJfqqSc0d7IVixMBb1+E6Vr70qPqBfKb6IBwSCNrN4jugbv3nHDV1UZrLu4O3N0GmWLm/U1WRU8BLTzfCMWEdsiTA1mtOMNrar9iHLURTDhU65FJr34mFjPlTMoI9eQUP8id/DuwPrM+dlEUm/JF0VF81feqAlaYT2o+GnJdA8JwaqmntxAjpmn/6pEdBSXCrrHikmL/+hcGqr1gpNuMXSf5bTmzI9F1m3fAVlcCXoXbd4+lhMhKchYHnweeMe5fdSttE2UU0RsVbTW1+8N4WRDqF1aY/zD6hBeREcg7LtFOoRYol4HhjZq6bAsLLclTHseZ4M2CFLZHBQ3KNpFE+SrQ7U4Sy+sSCCDDp1koXw9gK06+9TqVTWVZosUK4GvjbOlMpm1C+umbOhTNDXWNEwiMPhAF/X713/NoChFNeXwsfc5I6eXlDoekztkN9AI/JR92CsiYb7wiEtF6gUQ6E+GOq2QplYI0cXu9UVvaiNKAc7KBcuCeqyeGPhc3MlBiAFAZybZbopiJjdHlAp0F0Cekb/NTMd/8KIMXg+Tmc6hDhtsyKSsuI2aJU03jGoZmOIzsRNGQEZTqa9EW4VS1zvd/pGDSBs1On0SSb6gugrWpqYMpNn79HH0irB2LKGZ/t+dPzTwS/EBuACEIElcoGdfvumcrU/25xykpFgxH+MFcst4YscH3g8FdAXDFfyRxtzGcF0PablPyANeynsM1SyIUbiyMtGf58/f/gEr0ZxF7axr6Jz0dhO5rwPSvE7fwYpwsHBBhUC/Xt/7cegOiDiWd3Dzm/CRDMWUWWLH2WhZFBFNMNxCkvmcyhVJVmyYm4LkCdxcRfjiSVsn
 YJ/VotQr
 So1BKjYAjwEI5k0rTbpQqUEdVgoClna8w0AhwLariH1Y4ch9UxCBtMyw51dTi+z2JRo4n/bKFC4OJxG50B2wHVmMoCo8sO+fMjQnujixp6+lBnY/jMdlzH+mNGLky2pNAeiXNzjZhSe00ScgqPyADnpdaA/DUVHVzT9VIiRl6g1ybYCW/Rhp6z2ailwK3CZbJ6p39jU0no4Rhu/DrL73kVclb/cofatjU4pLSRM9WDLowAO+MkYQ1rKdgbTqBOI+phOPI/gCpy5ZsusgYhS3qYGwCUKcbQ8DxP38t/sdYmC/Uv2EI1aEN0IgrMwBiDVx3RFC/HHjRT8E1fduNbynoTV5KuLRXyhT4jjAuMLU1taOXpQlB/Nzf++pCf1RwMZyGSAjcynHq8p1hrT9EGlAOWAthO227SlOL4nH84KLMG0EQQrRn2Zh7gFC3gb5WAcMBPX5EFE2dGjFY1bWfNpH1w+YJd3Izc2qwKbZywcIvzHE4UDDLNvUKRnAQZoF0Gu2o1Y3sTv0Nr08xzeXaolilTBRbI6r/DZ8tFotKJeayvSqMIN0WBzCyH+3XlBOkmX+YlpAa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 30, 2025 at 7:48=E2=80=AFAM Michael S. Tsirkin <mst@redhat.com>=
 wrote:
>
> On Thu, Aug 28, 2025 at 03:53:56PM +0100, Matthew Wilcox wrote:
> > On Wed, Aug 27, 2025 at 11:29:22AM -0700, Vishal Moola (Oracle) wrote:
> > > I imagine theres more of these lingering in the kernel, but theres so
> > > many callers and I only looked for the ones that were calling
> > > page_address() inline :(.
> >
> > There's only 841 callers of free_page() and free_pages()!
> >
> > It's a bit of a disease we have, to be honest,  Almost all of
> > them should be using kmalloc() instead.  To pick on one at random,
> > sel_read_bool() in security/selinux/selinuxfs.c is the implementation
> > of read() for some file in selinux.  All it's trying to do is output tw=
o
> > numbers, so it allocates an entire page of memory, prints two numbers
> > to it (while being VERY CAREFUL not to overflow the buffer!) and copies
> > the buffer to userspace.
> >
> > It should just use kmalloc.
>
> Why even kmalloc? Why not have a small array on stack?

Patch posted at
https://lore.kernel.org/selinux/20250902131107.13509-2-stephen.smalley.work=
@gmail.com/T/#u

>
> >  Oh, and it should avoid leaking the buffer
> > if security_get_bool_value() returns an error.

