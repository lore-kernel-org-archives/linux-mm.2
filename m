Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5770606A325
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 18:56:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=FqAa3Wd7
Received: by kanga.kvack.org (Postfix)
	id 1D9996B0348; Mon, 19 Oct 2026 14:56:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 15C366B034A; Mon, 19 Oct 2026 14:56:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0234C6B034B; Mon, 19 Oct 2026 14:56:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5EA456B0348
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 14:56:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E51BCC0796
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:56:13 +0000 (UTC)
X-FDA: 85340281026.26.ED6AC82
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf28.hostedemail.com (Postfix) with ESMTP id E2B57C0003
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 18:56:11 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FqAa3Wd7;
	spf=pass (imf28.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792436171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YweAkpYKyGj3scLTRzUA6IGAh/m/fJWQQXcdDA+kHZI=;
	b=C83mV+PzYEZqB0RXwg5ArHY6KhwO/+zEtcbCiN5s2US9/mPZWOaK44ov4fqwFzfXII+aFX
	2s7nfhE8mauOtLmNJkaNX80PJuf83XIm4u6ze3YjjE3ZJ+7C61IMDAI8IsuGNsQ/rM0z5d
	UKaoTR8SYXR5SWDTow334cgjwuQ+7OE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792436171;
	b=bs4KgWO9cF8neaJuPLa+JDNy3MZMxU750KH2RNREE+wqyNMDjLnX7O6hGweCpPHi4xe4Mj
	x6z5TXMp0LquaMayhD722tF7uIBZtHO/1D2sxVI9GdHr3WiA/UVUIgBFqdd3dZDM1Nc8r/
	5NxBOWLnMU8Nl7yhJFsefiG3xZSlJSA=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=FqAa3Wd7;
	spf=pass (imf28.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2e8623790f8so13335ad.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:56:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792436171; cv=none;
        d=google.com; s=arc-20260327;
        b=CwBXpZpSFaKBPJTF3AkxLNk05z/jftgr3cInCbvksl6xDNohkqg1xH7lBbxBbxKpKs
         0alQMB0zhIhRvytIHfqI9fZKS8ae6gOBDEOQGREdvRruCqJv2oLJbRMNzmp2X9gOLwD9
         T5ytfIVL022LrlA/e9f7FzQJDGXWDratNjPiDoPuFD+VeOgkEdQxH1E9XVLonI61ufsC
         Xq4P2Iy8Hgr/ZmcxVZfxCvEI3YuNTncjPf8IYkXmasOC8Z/dhe2R3VDJibkabyetFbri
         an+YCZvwnuR/vfkIfFNCF/2KxcqIv6UyqXl8Odxi+3zphaoWoxjxl7EelIcy63pgz9HN
         ZDXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YweAkpYKyGj3scLTRzUA6IGAh/m/fJWQQXcdDA+kHZI=;
        fh=WyN6rjMCETQrfDeey6Frl7z1c6K1LSP1RxnWrdD8voo=;
        b=db8X8ZPzK9DUCtkbLxvxLpbfaRNmGTApvwLWQJIvzkRXkaHEFutSVz0EfoYLkIPb0k
         Nz2HqLP50gj4nWzjCid9468K03hT2kXpSZUJz+dHlOAEV24WaBuXHrzhCKiykEHXpm4G
         m1UlDlB2IgYDd3li+6zGuKdDX0V7hV7iKoErQ90g41tEYRJhrbwbojarB0R9gu8piCsq
         nE91UNG18fX8rZK1MUsGiZPS+ECTjCMk16+152mgVJiB4Fg6rVZyPcQK1Vc2w7WT67L6
         5hwG/PJTsl1pvQ0jE3v+6H9OKa4i0b5Np16GCsEGo5d9Z+4z+IaSte2kye9zvEp983Ge
         Jr2A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792436171; x=1793040971; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YweAkpYKyGj3scLTRzUA6IGAh/m/fJWQQXcdDA+kHZI=;
        b=FqAa3Wd7Mq6ZHmU42G0oJsR7VQMbcuxYqUhQ8rVurc07a86AzPM0lc+cFThP4UeNEt
         ArU8nPruCv5UtNJbE54F0RycpphsLcin8ObWDLFrYCD7x4E6eY+tyfyPtbigP3uTg/6W
         Bd24k4mp90rsUORjvdWrZAyKGNKFAKxmiMs6ViiD+tMRbDccOo7ZPR7COA1P5bZTI9CP
         L0oFX8eJRom0YvMJLoiCMpaEflEuemptDSapfweyPJlwWqjvcBqyRc+r+pe9BHOwxbBQ
         EkMNhCxubFXB3V6RfDUyKk2rRhfVC8xJ03gDXmiWvQmMWgYm9uQD33Tcz2egxmRBgx63
         pIjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792436171; x=1793040971;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YweAkpYKyGj3scLTRzUA6IGAh/m/fJWQQXcdDA+kHZI=;
        b=x/yDbaW1DNK8hBWNYqkpWbHe/x6qJzDLBgB/+u5fAzvlPI6+J1NBjvO0+aISQu/JIR
         +dSUJS84dQqzfigUd06ZJTEMO+zDr9ihSxBJ79oMkmKBUq94G+gdpuEGFo9nxxQ/Fjyn
         uxkrxEpr55NEMNF8XLEkEV7/Jme4br9sDnimMgKHcnnn2ljHTJtvkOFwYMvuQlkTPeWh
         4iEeklujnitrmCJBIOFUp7D+vNs+vh9FsjzD0kb9mGzbKoduyoazQUFM/nmFrHO2zIxu
         TDnP+6VBfqGbW3om3IFzglk+RfV6Pz5q30ZcFpMNvg3A77O9EXooff5DXZ6fsFLoPSQ7
         1XHw==
X-Forwarded-Encrypted: i=1; AKwUvByUO62ifq1jnRHY7o6yD4C2ofJIl27x5H+YjIouE8Dz98k/EPgcDqmKbFGUVqVZNONi4k5hrYqhaQ==@kvack.org
X-Gm-Message-State: AFq9FYKIDeKn4ouapgMbaXVP2HvItJPjA9Pg9lvovBdQ3Y4KhTkdS1/k
	gDv9LJFjJAWhJ5kWVBQOFSD7fYG8mj27Z6QVSteR/b6EUhou4qzt0XuJDSX7n2p+bXk+CdkHzEd
	I8+eos3NWYoAZe091DLoKUoN2f9PAKw7AOyUuxZeC
X-Gm-Gg: AYBFou0QDT5ekRcnAZ4JtUGtE+K2Rszdvty1CQSC2TzgY0wzUf0++yT3e42joqeiIeS
	0hbEv4cGCWUnGlKd4i3kcXxWU6eL6/VMmRG9+sPAzcDgAy1Tul+oYfX+hXGwUwCW1bp3sef1AkD
	IaFYDHYWYwuEWrtnAdUZXYSjb2zTMtWutCvj01cOuXEfhq2c9R5bzmxGtMUpSL6ujQgSEly6UIN
	fcpOYoskyYVoOwH9ehGUh+X/64aFLigEyAa0A7algt+MrfqSRd3rZziy47i0RYmt+Plrrciar19
	0gQPblj3lREDpamwzwf5wKSVOsj2ZzwAhJ3kOzirDBbz3J7XGD0ciyW1uuP2RCeys77GZp7oB8B
	enS170muD9Q==
X-Received: by 2002:a17:903:f8c:b0:2e6:23e5:4934 with SMTP id
 d9443c01a7336-2e9b3302552mr10210825ad.14.1792436170142; Mon, 19 Oct 2026
 11:56:10 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <cover.1791410885.git.abhishekbapat@google.com>
 <aae089a81ea891e1bc7e3ad171064d37d800ad1a.1791410886.git.abhishekbapat@google.com>
 <CAJuCfpF+kVSa0Rb0pW2gSwkBF57u-JC0J6gwFk62iGUpXVNwSw@mail.gmail.com>
In-Reply-To: <CAJuCfpF+kVSa0Rb0pW2gSwkBF57u-JC0J6gwFk62iGUpXVNwSw@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Mon, 19 Oct 2026 11:55:58 -0700
X-Gm-Features: AclHuK-9zWJgFdAaiaHRH5quyks5irCzrBiNc0VLEM6EY4t9qn-35fHPfFLOiaY
Message-ID: <CAL41Mv7cFudV97MEr2gq_NDno8z=BtqiKegDdM-haxUq3WRCAQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] alloc_tag: Extend allocinfo_filter to support
 tracing queries
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E2B57C0003
X-Stat-Signature: swep6wisif4nwapswp8x4b8notemkphd
X-Rspam-User: 
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1792436171-337274
X-HE-Meta: U2FsdGVkX1/p+Fk8OH1szlA/1cy+IPoC6sz+3TTGBSmyHi2JNwJHNwmWsWu5iYdMnPgcEHXQ7jMQ9uUdEiPzpiLOvMjkMQ8A2cVIbXDAdVevjv3w537uX+ru98csvS+vx+5kkCeVP04WdhTO8KLazduAlhhuuxqsC3xX3p7vDKq7QzsnCTSF0GR95NZ8kwlDrSYCGV5mRPP6xXFGf5bO0xX/vIhXYRoIJhLRb1vFIUzgqxDbMNwjIKNnDRZQezFpfJya9sCxrK4YSHrP4A2LODj28zNdV7zO740nknEhsZmkJKdfu2UDK+8cb6BuBgnWe3XE5SujvYnxx4UYF02bcuo01oC25Dw7CsK+6RBMG2iQEHPxikm5unjnmXeFq3wmRUe77ClV8Tx8fsgdt6dup4v+ZwmtxIeri5gaGpC0UmYNw+zVR/lLI/BFy7BIuJD+zQOWH4Tr+zRQKjAfkjsIMUJVkquEHcikCxkANhUwZnmC6g9vW9XXO4WXIb8+ytLVpb9kXSMoytmTAz+tFbV1fCLz2n9amq7PvY5rAQnZ44z7RSLYg/uQO0ZawtoCNccCQXjqYvPS8pQtX4z7Ymt+awvOL8NDeigUqdc+6LIG6D1uTVu+I+0eG1sr9061pq0KWaSuAfEeIdnRTS8MJu7D73stKZJX/tk7RgMHMu0ZN8s0IpnuWfFFHkT7U60RfyxvHa+n7jBibxGljc9nD8wg4b8pIhjLbuJ29UHn2x4X7grkDVrHr2mBw0HQRCaFGYu6sHmPRCv1T28kNW36sL5wC7FwRnTTx/aNTPZY5jyeiOS0xlIpQfJJSrVCBk6Nho+jzTntBTCsKoMreqn9XKPD0Q1x7ynJUwf0s+W3YwC3aMNW7EBgOryNJ/fp3tPV24xiEipg6l35C+wi/JuOHR368J4QcRa0vQAFdoD4ygC8gZIw00csRkyqK1auXyCuN5AW4UlRDJQBIkJ+n6V6eoc
 ZV5J1eyz
 6zPALClDvJ3Zm/lod5M8KGanl3TtKay19St2nrsi/YEM5Bd+orQGqhNu6ivQmhxD+T5bToi+4m8JCIUszZvBHmh6bHGswogdBdfYzaaYV9JIfBdaBqwTt0ctBUvqPrN2BWsw60kbdFRSxNRo0iYHSpmONZy5KHvLuokYjD0LfYFQ5c2tIKSv+p0tLMuVbIhWW8s/a2Aj523mISGoR0jwSM5wwcUt25SE1P/UsAHgrGalIPamD5/C4OxGQWEZbABGzAGf0kpH0p9AwnzVAgLIJ2JFmLVYKI41qw42Tk4O2Gf+Opcqr6Lv2SqoMQw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Oct 17, 2026 at 9:52=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Thu, Oct 8, 2026 at 2:40=E2=80=AFAM Abhishek Bapat <abhishekbapat@goog=
le.com> wrote:
> >
> > Extend the allocinfo filtering mechanism to allow users to filter tags
> > based on their trace state.
> >
> > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
>
> Acked-by: Suren Baghdasaryan <surenb@google.com>
>
> > ---
> >  include/uapi/linux/alloc_tag.h | 8 ++++++--
> >  mm/alloc_tag.c                 | 8 ++++++++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linux/alloc_=
tag.h
> > index dafcba2f7e2c..a96054ac2237 100644
> > --- a/include/uapi/linux/alloc_tag.h
> > +++ b/include/uapi/linux/alloc_tag.h
> > @@ -38,7 +38,8 @@ struct allocinfo_counter {
> >         __u64 bytes;
> >         __u64 calls;
> >         __u8 accurate;
> > -       __u8 pad[7];
> > +       __u8 trace_on;
> > +       __u8 pad[6];
> >  } __attribute__((aligned(8)));
> >
> >  struct allocinfo_tag_data {
> > @@ -54,7 +55,8 @@ enum {
> >         ALLOCINFO_FILTER_INACCURATE,
> >         ALLOCINFO_FILTER_MIN_SIZE,
> >         ALLOCINFO_FILTER_MAX_SIZE,
> > -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > +       ALLOCINFO_FILTER_TRACE_ON,
> > +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_TRACE_ON
> >  };
> >
> >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO_FILTER_=
MODNAME)
> > @@ -64,6 +66,7 @@ enum {
> >  #define ALLOCINFO_FILTER_MASK_INACCURATE       (1 << ALLOCINFO_FILTER_=
INACCURATE)
> >  #define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO_FILTER_=
MIN_SIZE)
> >  #define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO_FILTER_=
MAX_SIZE)
> > +#define ALLOCINFO_FILTER_MASK_TRACE_ON         (1 << ALLOCINFO_FILTER_=
TRACE_ON)
> >
> >  #define ALLOCINFO_FILTER_MASKS \
> >         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > @@ -75,6 +78,7 @@ struct allocinfo_filter {
> >         __u64 max_size;
> >         /* filter criteria only; see allocinfo_counter.accurate for act=
ual accuracy */
> >         __u64 inaccurate;
> > +       __u64 tracing;
> >  };
> >
> >  struct allocinfo_get_at {
> > diff --git a/mm/alloc_tag.c b/mm/alloc_tag.c
> > index 262f00f2bba9..8e63f347657b 100644
> > --- a/mm/alloc_tag.c
> > +++ b/mm/alloc_tag.c
> > @@ -250,6 +250,7 @@ static void allocinfo_to_params(struct codetag *ct,
> >         data->counter.bytes =3D counters->bytes;
> >         data->counter.calls =3D counters->calls;
> >         data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_to_alloc=
_tag(ct));
> > +       data->counter.trace_on =3D alloc_tag_is_traced(ct_to_alloc_tag(=
ct));
> >  }
> >
> >  /*
> > @@ -323,6 +324,13 @@ static bool matches_filter(struct codetag *ct, str=
uct allocinfo_filter *filter,
> >                         return false;
> >         }
> >
> > +       if (filter->mask & ALLOCINFO_FILTER_MASK_TRACE_ON) {
> > +               bool tracing =3D alloc_tag_is_traced(ct_to_alloc_tag(ct=
));
> > +
> > +               if (tracing !=3D !!(filter->tracing))
>
> nit: Compilers are smart enough nowadays to convert u8 to bool without !!
>

There's a similar check right above it that checks "inaccurate !=3D
!!(filter->inaccurate)".

I just want to be consistent and less ambiguous. Also strictly
speaking, compilers convert a bool to an int implicitly, so if
filter->tracing is > 1, the if condition without the !! will result in
false.

> > +                       return false;
> > +       }
> > +
> >         return true;
> >  }
> >
> > --
> > 2.56.0.385.gd3acb90ef8-goog
> >

