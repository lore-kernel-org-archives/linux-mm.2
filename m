Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D13C4CD98F2
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 16:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F97B6B0088; Thu, 18 Jun 2026 12:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D0316B008A; Thu, 18 Jun 2026 12:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 69A216B0095; Thu, 18 Jun 2026 12:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6CE6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 12:38:31 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A08FAC0410
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:38:30 +0000 (UTC)
X-FDA: 84893591580.06.067B22B
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9D69040003
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 16:38:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bTIbO73X;
	spf=pass (imf04.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781800708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o2sp8BQwLMMxoa0twTBGCTMJeSc68yYCgpIAukpWf14=;
	b=nm2Qc/s6qouLOvAfx+0lnNHwkuoiOFGi/+M+/KoYfRSVM2OY+4gBHMmyeG4flB2JdP+wDf
	cwrHdwMuIBN9e5eDwO2RDcVLM20OpH/l+nV5cMYWnKrLpXadFerZECrov6fLIhgwaBhl+p
	75dgTCqxpCss/e8XsjnMOGh0RYrcIYY=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=bTIbO73X;
	spf=pass (imf04.hostedemail.com: domain of abhishekbapat@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=abhishekbapat@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781800708;
	b=KmtlegUzBvm3H93Wc1ZtqErWzTbOWQJSHFAuOzrV0FLysYwCGu32OZH5LUF+duY6HGOYOj
	RJZ9Z0Qebu3hHVbGVj96lVFO8sMBWC6Q6EUn2AVRffqFR+e78f7AXCvuFVRvKRjD/2DMrQ
	DVOBOjOVnzqjZU5riW0git8wxKj+f7w=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c69fa0b1f8so1115ad.0
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:38:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781800707; cv=none;
        d=google.com; s=arc-20260327;
        b=PHzCGPFKjefpEf4tSU27TfBBPNIPRhOL0Qb50xH2b4OXuRgQWFvWWFr8th3XbiBIzh
         EON3zrWa1ezWb9MKd8rcT5WDhw7EE75CVOn8XCqAfoQr57SXII2npIeuTQttMVorXTlv
         vHj86WTmM/MHq37WFuwJrxd5Pjj2Pduv3uPPoS7DjUO89Ur9AFaOd5NdYml4Lvjlsz2w
         zqxQEfjNWHx0p2pk737WFm7w7h06ySOrfLbh84lOVX8XfbyprqgBZVH88pZ4MAvavSYQ
         xlaWTAgsXEm8ZLNU+I1S1FhIorpF5YtGS3iOMBQmU9MH1jiFAlrapWhaoXQmxT7pIYKM
         XJSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o2sp8BQwLMMxoa0twTBGCTMJeSc68yYCgpIAukpWf14=;
        fh=yi+5rMY8T+mDrJ1M7aXXU4b7kMcJAgrQlDDer+BWWPo=;
        b=pEzjbUff2QQPnNX/XZBUgeD8MbMYuYM4du8QWlz/YE17VZMV59trRMQGRMUQDvxrZr
         h/Z7DLAlVde4iC+AkXrmWgcHvJZ3hLRUPbLqVYe/Y2vStX+dZl/EXvmD5thPa13gY3t9
         XjKq1EbBA9KPyEu3eCFlO2a4lQcHo4MzXCL+kK9rp1cgiO4IKh4LsGuw+fitUoMv3F+p
         /O+A1NOHUn97S1ikHyoSHVBDGNeaAHsuFm5Pj7ha3KbMO5ubJoSKIq6cc0paP/vToerw
         ucmGjzo80axU4+PELtvrSKI7T5UPSY5g1L7Ov4b97sNBjtQr701E2in719yKcvFYx0lr
         gtsQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781800707; x=1782405507; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o2sp8BQwLMMxoa0twTBGCTMJeSc68yYCgpIAukpWf14=;
        b=bTIbO73XmWD4zsRF869IrOUnwLdlLXuafAN0x2IdOn7BXprS3kxn7WYVdVdFSSoNju
         RHbkEyAXsyMVSrIT3J2Umqb000nEVz3zK2GZugN77ikd/EueOPjwJtrRAQTP3TBb8Skw
         iD2TqlR5qEVia8eKaoe/6uvPs6McHCCI0QCxV/4vBAku+C0v1pFn0Hev9duOE8WoKBUm
         8TSYsFEs3wqy+4vMvx3UZVLDk5Fw4HZKNfWjoFjY61xKzRf6u7iodA0zAsRDjgVVATuf
         NG59JwYPWku1NL/LbA7VzmXua+vnLpYb3+KQCRuGX2Ug4oUsgVCo1edp+wSl7aVEjyot
         qfBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781800707; x=1782405507;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o2sp8BQwLMMxoa0twTBGCTMJeSc68yYCgpIAukpWf14=;
        b=OF7AYEW4UAh/IQuznn0lO8+pSE91q1FxhbTQbHFCcJ23v7hslhs/mPWhqWAAVv30wd
         Js8Hd/4p9x1LUrthhHzon1GdTLfNSeo3mj4tMPRsGQwu6jORucvC6ADV8UN/58sH4n6O
         t1Qwo6cIy6ghJPmQaL3TiLJqCsEFC2axMdl/2hrxI9GkGthGq9xPanywW4Crdgq6EUUo
         N8jB1BkUJ1wm5XFvc4wM6OgmB1IBlqPkDcSeyeTmDL48DXLrulqDbi9MIDwddhwJ46hM
         i1BIWBWftjqov2/wV65u+6OUYp6JIZ+Zc/La/HnBxw1vlxktZtuGpKhuY/Ax6sqIg8+N
         8jLA==
X-Forwarded-Encrypted: i=1; AFNElJ9DVyHO958iGcL8HcLxVnzpVAQgj+l1bALjf06KCWHitY2PsMTZVseyPWnBJ26w6bDzERPNWExQ+Q==@kvack.org
X-Gm-Message-State: AOJu0Yx7W2zveGRjl7/Rv0zefGShoeSdj3QvGzvNlFGN7Q3iqkWmY1ZR
	P804VPuSoZA4Nylk3OpyiWmIw6orcAkKddzvPxC78UszJpfPXUAUKMusqxvM4bf8b7xjMO6Dilk
	RMvCq5yrKpjeOIgCzqIE7sdLepETzy/ENBr/fZtv6g5zpP7KO1T/hNJAC11g=
X-Gm-Gg: AfdE7cmjzUNMdG2VJJRoc/Pp1lj7/YvEHabUOYv8QjCDMbmj98TIg1Z1GUmTuwcnuH6
	LdXfZWOHkhLYjEHls7aekeRZ51AaEyCM4MH1wslGUdUrJIaur23WwiPsT/ppWb5j3jhgFWcLoo9
	JUuGQwGWO1hefJDlksBuX5vr4MlJXIAshLEPJCDwYThFWAX62PiqmhVeGVMEti2adVn1XjuFG61
	hFsfhwMLl6DZECssFULB1B+K48BQXB5FpPSuWFpBriMF46VrgxPv8c8UwxWAwIunzUiN4w4JoIh
	grPiaCU/1Jz6qZ5VceMOX1Q6uwuTvokn4pe1cGGz
X-Received: by 2002:a17:903:1746:b0:2b7:b03d:9dce with SMTP id
 d9443c01a7336-2c6e221cfecmr2748785ad.18.1781800706953; Thu, 18 Jun 2026
 09:38:26 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1781564384.git.abhishekbapat@google.com>
 <7d98db60ab0fddab230b1a7a32140f3361ab42cf.1781564384.git.abhishekbapat@google.com>
 <CAJuCfpFbCKc7FR3tbeCzexCzyfiP+Ab2fJ7Vd1Q76MKTvqC2XA@mail.gmail.com>
 <CAL41Mv7=B7H1C3j5_Pva-kYsJs_1NpCqVhN6wn-WhqvquV6=2w@mail.gmail.com>
 <CAJuCfpGOrtk+3hvUVE7-6wpnsa3Nbr6kGq5CfHVdCzX+DYyjFQ@mail.gmail.com>
 <CAL41Mv6FZU5As+yKiM52axUMsR_FDrYQCK5STjUp-aG+xMD-EQ@mail.gmail.com> <CAJuCfpFrgKBGFWoca=XuKh1p22vdfE_uSz_nt2Kj4UvnjvSUJQ@mail.gmail.com>
In-Reply-To: <CAJuCfpFrgKBGFWoca=XuKh1p22vdfE_uSz_nt2Kj4UvnjvSUJQ@mail.gmail.com>
From: Abhishek Bapat <abhishekbapat@google.com>
Date: Thu, 18 Jun 2026 09:38:14 -0700
X-Gm-Features: AVVi8Cdr5snt4_U1THYDJbxafqi5nb-C3H-GI3Uu0Lkdo0uC1dYMvahVWMYDltA
Message-ID: <CAL41Mv7u0zt4rG9bb73cRj8p48+58DVdJmv3U87bes4fP_NoUg@mail.gmail.com>
Subject: Re: [PATCH v5 3/6] alloc_tag: add size-based filtering to ioctl
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	Hao Ge <hao.ge@linux.dev>, Shuah Khan <skhan@linuxfoundation.org>, 
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Sourav Panda <souravpanda@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9D69040003
X-Rspam-User: 
X-Stat-Signature: 7d6tby9wgzipfr8bb3xssdrcbk36fhzj
X-HE-Tag: 1781800708-590900
X-HE-Meta: U2FsdGVkX18eUNWVoVlO1ut6/MJtKQkiuaYi923KbKw+oqXHL9iduSH0hcmJlhc4oOiTSm9IT3vHUdpuCGJJu2Vza/jaMnRUrEtVIB+wxTHYlVeSKA8q66L2ARt7LGUxQUgqfc9gec4Xev20iUu/FL03xYn0cyXZ5BTrZq0ur47YlOqMLblRvqQQ2yFK2N8QYpggK+SBK4zVTChIIzqWIc37js7W14A7sdnbbdU8BH01WYNiXjre8UG6PyyabrhTItGP9eVYniR8Mm9B3iZVXIc0V3GLixnJprh2ZuAhuaSnFHRzEUEB3onTEfys2Xz7amKFqsBE4kI4wjaMcPGK7zebyEq6iGgFRWCTUSoSeXyxdfbIOoLqi1UJl42ANc/o/VjqWa4ZTDjhK1XJ3z8aKW2w4fMrL0E2AKllgHHbUkekgvTR5xtNLOlPVCevDdZI9KZGaa1T3eXiTj12oVOWvao659AsSrIw8DKF4cv9pT/NBh1nJukGjgHU5YzKXYo037RCrBq0OMNfrlzqjY+ok1I97pcbDl+QPQKe3LDGHlVaxWtDggpbZWarZ0ExK4vxa5HegwFTR2bmv4OSgI3wZI1R0JKmx8CeAng3zHW8ZKwu6nPxBKHz5BJDq16udlvtQ1gIWnq6BJm/2JdfBg/kvp+zJlb03Mn/KEtFbJWv7j0OnwS/L08EUMyYhx1xLZRlbtsrvBxyFNzIhHJeFEP3vjVnAsgDYGLyEIm5l4/EYHprRUO+60Ov5hL0BBxtslXix3eod1tTw5pVSJJv00yvZ8W/UwetQz4+eCIyAKaZ4W1I27C19du6eFIHob8feap0eN3oqwPa00yO/zpBgxDYINEOQPkvSRm1N6/GwSFFOct8H8ZHH3dqoE9+NumDsNVXFYXtx9l8K3MrYIWOiY/mj9T07HwnIyoY8GqXwq6RLiOAS+9Yz4ktJPiiZxGAxBfTQkRIqkwezz7PuXzQww/
 lyOUMDH0
 Co4ktgysWn1EyVvOaypoFkIHL9hzKNZHvRddGL1YeaeLrDKwjSlEbHoV9GPa8OKqKV/bhzwTASV9fT6ussvDfJkEX0dp3PPo0r8GWffQ3bpXjPJKlPAV6UxAre3pqiIM6qD0FVbWgbVxKFXPxqmbcClOCvtqaDWqr8mXA+lGniTZ/pouDeECg5fUivNVTxidJHLDuisHal/lRz1lYHanyZjvkbYiIcLpiDVJD64Z/NxeNhA0y6zwZa9yk0+EMZnkekYLYl/YwITQ4VQmStOVZHPaChdkH9aS91gnKaHEjVIxRJTR0aSkgnd+lVjW67ErGEHfjCLfnlbDBMuQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 17, 2026 at 4:01=E2=80=AFPM Suren Baghdasaryan <surenb@google.c=
om> wrote:
>
> On Wed, Jun 17, 2026 at 3:41=E2=80=AFPM Abhishek Bapat <abhishekbapat@goo=
gle.com> wrote:
> >
> > On Wed, Jun 17, 2026 at 3:35=E2=80=AFPM Suren Baghdasaryan <surenb@goog=
le.com> wrote:
> > >
> > > On Wed, Jun 17, 2026 at 1:55=E2=80=AFPM Abhishek Bapat <abhishekbapat=
@google.com> wrote:
> > > >
> > > > On Wed, Jun 17, 2026 at 9:29=E2=80=AFAM Suren Baghdasaryan <surenb@=
google.com> wrote:
> > > > >
> > > > > On Mon, Jun 15, 2026 at 4:04=E2=80=AFPM Abhishek Bapat <abhishekb=
apat@google.com> wrote:
> > > > > >
> > > > > > Extend the allocinfo filtering mechanism to allow users to filt=
er tags
> > > > > > based on the total number of bytes allocated [min_size, max_siz=
e]. The
> > > > > > size range is inclusive.
> > > > > >
> > > > > > Filtering by size involves retrieving allocinfo per-CPU counter=
s, which
> > > > > > is an expensive operation. Hence, the performance of size-based
> > > > > > filtering will be worse than other filters.
> > > > > >
> > > > > > Signed-off-by: Abhishek Bapat <abhishekbapat@google.com>
> > > > > > Acked-by: Hao Ge <hao.ge@linux.dev>
> > > > > > ---
> > > > > >  include/uapi/linux/alloc_tag.h |  8 ++++-
> > > > > >  lib/alloc_tag.c                | 63 ++++++++++++++++++++++++++=
++------
> > > > > >  2 files changed, 59 insertions(+), 12 deletions(-)
> > > > > >
> > > > > > diff --git a/include/uapi/linux/alloc_tag.h b/include/uapi/linu=
x/alloc_tag.h
> > > > > > index 3b11877955b9..7f5acbb44c14 100644
> > > > > > --- a/include/uapi/linux/alloc_tag.h
> > > > > > +++ b/include/uapi/linux/alloc_tag.h
> > > > > > @@ -45,13 +45,17 @@ enum {
> > > > > >         ALLOCINFO_FILTER_FUNCTION,
> > > > > >         ALLOCINFO_FILTER_FILENAME,
> > > > > >         ALLOCINFO_FILTER_LINENO,
> > > > > > -       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_LINENO
> > > > > > +       ALLOCINFO_FILTER_MIN_SIZE,
> > > > > > +       ALLOCINFO_FILTER_MAX_SIZE,
> > > > > > +       __ALLOCINFO_FILTER_LAST =3D ALLOCINFO_FILTER_MAX_SIZE
> > > > > >  };
> > > > > >
> > > > > >  #define ALLOCINFO_FILTER_MASK_MODNAME          (1 << ALLOCINFO=
_FILTER_MODNAME)
> > > > > >  #define ALLOCINFO_FILTER_MASK_FUNCTION         (1 << ALLOCINFO=
_FILTER_FUNCTION)
> > > > > >  #define ALLOCINFO_FILTER_MASK_FILENAME         (1 << ALLOCINFO=
_FILTER_FILENAME)
> > > > > >  #define ALLOCINFO_FILTER_MASK_LINENO           (1 << ALLOCINFO=
_FILTER_LINENO)
> > > > > > +#define ALLOCINFO_FILTER_MASK_MIN_SIZE         (1 << ALLOCINFO=
_FILTER_MIN_SIZE)
> > > > > > +#define ALLOCINFO_FILTER_MASK_MAX_SIZE         (1 << ALLOCINFO=
_FILTER_MAX_SIZE)
> > > > > >
> > > > > >  #define ALLOCINFO_FILTER_MASKS \
> > > > > >         ((1 << (__ALLOCINFO_FILTER_LAST + 1)) - 1)
> > > > > > @@ -59,6 +63,8 @@ enum {
> > > > > >  struct allocinfo_filter {
> > > > > >         __u64 mask; /* bitmask of the filter fields used */
> > > > > >         struct allocinfo_tag fields;
> > > > > > +       __u64 min_size;
> > > > > > +       __u64 max_size;
> > > > > >  };
> > > > > >
> > > > > >  struct allocinfo_get_at {
> > > > > > diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> > > > > > index 5feb61d9fb92..b3d21834b61e 100644
> > > > > > --- a/lib/alloc_tag.c
> > > > > > +++ b/lib/alloc_tag.c
> > > > > > @@ -195,15 +195,26 @@ static int allocinfo_cmp_str(const char *=
str, const char *template)
> > > > > >         return strncmp(allocinfo_str(str), template, ALLOCINFO_=
STR_SIZE);
> > > > > >  }
> > > > > >
> > > > > > +/* Fetch the per-CPU counters */
> > > > > > +static inline struct alloc_tag_counters allocinfo_prefetch_cou=
nters(struct codetag *ct)
> > > > > > +{
> > > > > > +       return alloc_tag_read(ct_to_alloc_tag(ct));
> > > > > > +}
> > > > > > +
> > > > > >  /*
> > > > > >   * Populates the UAPI allocinfo_tag_data structure with active=
 runtime
> > > > > >   * profiling counters extracted from the given kernel codetag.
> > > > > >   */
> > > > > >  static void allocinfo_to_params(struct codetag *ct,
> > > > > > -                               struct allocinfo_tag_data *data=
)
> > > > > > +                               struct allocinfo_tag_data *data=
,
> > > > > > +                               struct alloc_tag_counters *coun=
ters)
> > > > > >  {
> > > > > > -       struct alloc_tag *tag =3D ct_to_alloc_tag(ct);
> > > > > > -       struct alloc_tag_counters counter =3D alloc_tag_read(ta=
g);
> > > > > > +       struct alloc_tag_counters local_counters;
> > > > > > +
> > > > > > +       if (!counters) {
> > > > > > +               local_counters =3D allocinfo_prefetch_counters(=
ct);
> > > > > > +               counters =3D &local_counters;
> > > > > > +       }
> > > > > >
> > > > > >         if (ct->modname)
> > > > > >                 allocinfo_copy_str(data->tag.modname, ct->modna=
me);
> > > > > > @@ -212,9 +223,9 @@ static void allocinfo_to_params(struct code=
tag *ct,
> > > > > >         allocinfo_copy_str(data->tag.function, ct->function);
> > > > > >         allocinfo_copy_str(data->tag.filename, ct->filename);
> > > > > >         data->tag.lineno =3D ct->lineno;
> > > > > > -       data->counter.bytes =3D counter.bytes;
> > > > > > -       data->counter.calls =3D counter.calls;
> > > > > > -       data->counter.accurate =3D !alloc_tag_is_inaccurate(tag=
);
> > > > > > +       data->counter.bytes =3D counters->bytes;
> > > > > > +       data->counter.calls =3D counters->calls;
> > > > > > +       data->counter.accurate =3D !alloc_tag_is_inaccurate(ct_=
to_alloc_tag(ct));
> > > > > >  }
> > > > > >
> > > > > >  /*
> > > > > > @@ -238,7 +249,9 @@ static int allocinfo_ioctl_get_content_id(s=
truct seq_file *m, void __user *arg)
> > > > > >   * Verifies whether a given codetag satisfies the active filte=
ring criteria by
> > > > > >   * matching its characteristics against the specified filter.
> > > > > >   */
> > > > > > -static bool matches_filter(struct codetag *ct, struct allocinf=
o_filter *filter)
> > > > > > +static bool matches_filter(struct codetag *ct, struct allocinf=
o_filter *filter,
> > > > > > +                          struct alloc_tag_counters *counters,
> > > > > > +                          bool *fetched_counters)
> > > > > >  {
> > > > > >         if (!filter || !filter->mask)
> > > > > >                 return true;
> > > > > > @@ -265,6 +278,19 @@ static bool matches_filter(struct codetag =
*ct, struct allocinfo_filter *filter)
> > > > > >             ct->lineno !=3D filter->fields.lineno)
> > > > > >                 return false;
> > > > > >
> > > > > > +       if (filter->mask & (ALLOCINFO_FILTER_MASK_MIN_SIZE | AL=
LOCINFO_FILTER_MASK_MAX_SIZE)) {
> > > > > > +               if (!*fetched_counters) {
> > > > > > +                       *counters =3D allocinfo_prefetch_counte=
rs(ct);
> > > > > > +                       *fetched_counters =3D true;
> > > > > > +               }
> > > > > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MIN_S=
IZE) &&
> > > > > > +                   counters->bytes < filter->min_size)
> > > > > > +                       return false;
> > > > > > +               if ((filter->mask & ALLOCINFO_FILTER_MASK_MAX_S=
IZE) &&
> > > > > > +                   counters->bytes > filter->max_size)
> > > > > > +                       return false;
> > > > > > +       }
> > > > > > +
> > > > > >         return true;
> > > > > >  }
> > > > > >
> > > > > > @@ -278,6 +304,8 @@ static int allocinfo_ioctl_get_at(struct se=
q_file *m, void __user *arg)
> > > > > >         struct codetag *ct;
> > > > > >         struct allocinfo_get_at params =3D {0};
> > > > > >         __u64 skip_count;
> > > > > > +       struct alloc_tag_counters counters;
> > > > > > +       bool fetched_counters;
> > > > > >
> > > > > >         if (copy_from_user(&params, arg, sizeof(params)))
> > > > > >                 return -EFAULT;
> > > > > > @@ -285,6 +313,11 @@ static int allocinfo_ioctl_get_at(struct s=
eq_file *m, void __user *arg)
> > > > > >         if (params.filter.mask & ~ALLOCINFO_FILTER_MASKS)
> > > > > >                 return -EINVAL;
> > > > > >
> > > > > > +       if ((params.filter.mask & ALLOCINFO_FILTER_MASK_MIN_SIZ=
E) &&
> > > > > > +           (params.filter.mask & ALLOCINFO_FILTER_MASK_MAX_SIZ=
E) &&
> > > > > > +           params.filter.min_size > params.filter.max_size)
> > > > > > +               return -EINVAL;
> > > > > > +
> > > > > >         priv =3D m->private;
> > > > > >
> > > > > >         mutex_lock(&priv->ioctl_lock);
> > > > > > @@ -308,7 +341,8 @@ static int allocinfo_ioctl_get_at(struct se=
q_file *m, void __user *arg)
> > > > > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > > >
> > > > > >         while (ct) {
> > > > > > -               if (matches_filter(ct, &priv->filter)) {
> > > > > > +               fetched_counters =3D false;
> > > > > > +               if (matches_filter(ct, &priv->filter, &counters=
, &fetched_counters)) {
> > > > >
> > > > > Do we really need this "fetched_counters" parameter? Here are the
> > > > > possible cases:
> > > > > 1. If the filter does not include ALLOCINFO_FILTER_MASK_MIN_SIZE =
|
> > > > > ALLOCINFO_FILTER_MASK_MAX_SIZE then counters would not be fetched=
.
> > > > > 2. If the filter includes ALLOCINFO_FILTER_MASK_MIN_SIZE |
> > > > > ALLOCINFO_FILTER_MASK_MAX_SIZE and
> > > > > 2.1. matches_filter() returns true then we know counters were fet=
ched
> > > > > because they had to be validated.
> > > > > 2.2. matches_filter() returns false then we don't care if the cou=
nters
> > > > > were fetched. We do not report that tag anyway.
> > > > >
> > > > > So, instead of passing fetched_counters to matches_filter() we co=
uld do this:
> > > > >
> > > > > bool filter_by_size =3D (params.filter.mask &
> > > > > (ALLOCINFO_FILTER_MASK_MIN_SIZE | ALLOCINFO_FILTER_MASK_MAX_SIZE)=
) !=3D
> > > > > 0;
> > > > > while (ct) {
> > > > >            if (matches_filter(ct, &priv->filter, &counters)) {
> > > > > ...
> > > > > }
> > > > > if (ct) {
> > > > >            allocinfo_to_params(ct, &params.data, filter_by_size ?
> > > > > &counters : NULL);
> > > > > ...
> > > > > }
> > > > >
> > > > > Wouldn't that work?
> > > > >
> > > >
> > > > While we can deduce whether counters were fetched outside the
> > > > matches_filter function, I think the current implementation is more
> > > > intuitive from a readability perspective. I believe it  should be k=
ept
> > > > as is for that reason. If we extract the logic, we'll first have to
> > > > replicate the boolean logic at two places. Second, we'd need to add=
 a
> > > > comment explaining the boolean calculation, and the reader might ha=
ve
> > > > a higher cognitive load trying to determine which function populate=
s
> > > > the counters. The current implementation makes it easy for the read=
er
> > > > to deduce the original intention. Let me know what you think.
> > >
> > > Ok, I guess you have a point.
> > >
> > > I was also thinking why we are passing NULL to allocinfo_to_params()
> > > to fetch the counters into a local variable? Why can't we simply call
> > > allocinfo_prefetch_counters() before calling allocinfo_to_params()
> > > when fetched_counters=3D=3Dfalse? Basically:
> > >
> > > if (!fetched_counters)
> > >     counters =3D allocinfo_prefetch_counters(ct);
> > > allocinfo_to_params(ct, &params.data, &counters);
> > >
> > > This would simplify allocinfo_to_params() because counter will never
> > > be NULL and it would not need local counters.
> > >
> >
> > The only reason I did it that way was to avoid repeating the code at
> > two places i.e. allocinfo_ioctl_get_at and allocinfo_ioctl_get_next.
> > Either way, the per-CPU counters are assimilated only once. I can
> > include this change if you still want me to, but personally I like the
> > way it currently is implemented.
>
> Yeah, I think repeating 2 lines is preferable to passing NULL and
> fetching into a local variable. Please include that change.
>

Ack, I will change this in the next patchset version.

> >
> > > >
> > > > > >                         if (skip_count =3D=3D 0)
> > > > > >                                 break;
> > > > > >                         skip_count--;
> > > > > > @@ -317,7 +351,7 @@ static int allocinfo_ioctl_get_at(struct se=
q_file *m, void __user *arg)
> > > > > >         }
> > > > > >
> > > > > >         if (ct) {
> > > > > > -               allocinfo_to_params(ct, &params.data);
> > > > > > +               allocinfo_to_params(ct, &params.data, fetched_c=
ounters ? &counters : NULL);
> > > > > >                 priv->positioned =3D true;
> > > > > >         }
> > > > > >
> > > > > > @@ -343,6 +377,8 @@ static int allocinfo_ioctl_get_next(struct =
seq_file *m, void __user *arg)
> > > > > >         struct codetag *ct;
> > > > > >         struct allocinfo_tag_data params;
> > > > > >         int ret =3D 0;
> > > > > > +       struct alloc_tag_counters counters;
> > > > > > +       bool fetched_counters;
> > > > > >
> > > > > >         memset(&params, 0, sizeof(params));
> > > > > >         priv =3D m->private;
> > > > > > @@ -356,10 +392,15 @@ static int allocinfo_ioctl_get_next(struc=
t seq_file *m, void __user *arg)
> > > > > >         }
> > > > > >
> > > > > >         ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > > > -       while (ct && !matches_filter(ct, &priv->filter))
> > > > > > +       while (ct) {
> > > > > > +               fetched_counters =3D false;
> > > > > > +               if (matches_filter(ct, &priv->filter, &counters=
, &fetched_counters))
> > > > > > +                       break;
> > > > > >                 ct =3D codetag_next_ct(&priv->ioctl_iter);
> > > > > > +       }
> > > > > > +
> > > > > >         if (ct)
> > > > > > -               allocinfo_to_params(ct, &params);
> > > > > > +               allocinfo_to_params(ct, &params, fetched_counte=
rs ? &counters : NULL);
> > > > > >
> > > > > >         if (!ct) {
> > > > > >                 priv->positioned =3D false;
> > > > > > --
> > > > > > 2.54.0.1136.gdb2ca164c4-goog
> > > > > >

