Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBFDECCF9EA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 05:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54358E0128; Thu, 30 Oct 2025 01:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2C958E0112; Thu, 30 Oct 2025 01:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A419E8E0128; Thu, 30 Oct 2025 01:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92E0F8E0112
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 01:04:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F4036C09A7
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:04:09 +0000 (UTC)
X-FDA: 84053589018.04.EC8661B
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FB4E140010
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 05:04:07 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BjgwPl3h;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761800648; a=rsa-sha256;
	cv=none;
	b=VyQqLbURhiOg1VujVn3iayF01TFQa9NWX8G0qF3meDhWwchVN0OplLPKdqV0PqjwTrK9X/
	TMlUrV1ci0jIlyhQGQbXvHlGyEQ51tgNSPLaQxWa5IKcZR1jiVXjcaPdd4DQGJozGWECAl
	3bpp3wJXEisfhbcX/wt6TbKCfYMjUQ0=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BjgwPl3h;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761800648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=imCnF/sFJhKXZqCTXzziLsifvuU1OPsnWOgGGE2EO8o=;
	b=rosUAVWM6yPY+EkUKRTKkjRbDQlyX/FvG6292sNmsKKKdW0Upt6EbRsGJ9UDpnL2oqGm6C
	Gdla4YNt+n+0QeNk1sQrNrMnHxlz0t468MZsFusBP3N8pESFL+oXcyXAiPNmg0/ObxMqHI
	efdjBGaE/3t7kXRGGSRJbbsmsCFNAv4=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-4ed0c8e4dbcso143381cf.0
        for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:04:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761800647; x=1762405447; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=imCnF/sFJhKXZqCTXzziLsifvuU1OPsnWOgGGE2EO8o=;
        b=BjgwPl3hpsWtre+0/q9IauIsxZfOs1Pc/jBPyIOnyxfy949FJoLd4AfUC6nYY4yWlp
         BIOEKdbEhowBPndXTBZpkR27TKPbZYCehOLChmQFK86DnqcbkZ+bRdNec57OwN17zBNz
         qVRbDxnQINtFkTyLvf5z3UXCQEnZwWS+nrlWF3/uYJt08HHwCkgakxMMiVJMel0NO8Mv
         MDgcOF6jqpvrnhc+7JvciCTG9PxS5XN08c+0DZP34O7N8DyiQO8Y14Lc1iuJQtci8AnY
         Qb1lxw1OeuPMvKb4TzRmIcjjUM8f6OYNtgRZ0W0Fxzmy8Mf5VHPPpnvJg96btu6GCMOl
         g53w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761800647; x=1762405447;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=imCnF/sFJhKXZqCTXzziLsifvuU1OPsnWOgGGE2EO8o=;
        b=n7Pwi43CWKcKltD9N29uF5WZ1STim0Yo5pNKbBgfqCgYbPzMz9fNYGDI5E4hmFfkXO
         39hepuHDjAManIflzaFA3D58APdlud6nHCmT0H5cJepyj6Ua8jgZMy0719l/1aSuEQmx
         u3e3gvoYrXoqUdx0a8XK0Srr3bQR3ulbsMKt2VUpacJWpSYgCKzzpSGcC5hRlMOI+fHm
         ThzsCp1RVEN6tgZWriih1Ms/6+YkDFthDitxtnJxjGf5l5aDJClizco6fjBzgygVPoDe
         mqkndLV2h5uu8ccc/HOLO1dQ2qaO6sFGPduLnWJLTIOJr3sl5i6Gs6xrvWB/iHiIrZjS
         wz6A==
X-Forwarded-Encrypted: i=1; AJvYcCX2tAPbnDUSG6ToyUkLkpnjEMfHVq/L1TpfHVOFdinaU+ETcJSkvw+T6j5C9MU9+RdtDQkNEVTPCA==@kvack.org
X-Gm-Message-State: AOJu0Yz5NtXjzKFcmVbEpc1lXQl9qdb7vqTIQynWFkh5oPwZo+TFRYQc
	IpPQQ5k8Vo/G9ZNfnDxkv2CiF4JaNN2A1Mi7ouMZdVOwrnkG7TosFD9zLAAYgy18HqD4zhziZLM
	peaZ1A2UyLOFQf1ZYoFJMVfHwj7lWC6mjaX052hwA
X-Gm-Gg: ASbGncuRsQb2mX1snobnEYOLwfEApXUJy0+cFdEZ2Dt9BTsq2zhBzzkbPzEWO2okv7P
	SGSk+3DVxzZfbeZCF6RValByjex4lJwVAPZ6oHcl9lelnJkFsgYZwsSZaE7VrTRgAEpxmDExdY6
	y6prj7Dq1iodsHUN2uoFdqF1ij6CY2I9BppY7CEJKFNhfkQsBx+EAvb/rVnMqJj04NgItPNU0OC
	+Ex/Sc2a+kvohw+emKEQvs09ocJz09mU0p26yiU+APg8bL4BLA+erM1mIf3k3mrLPS2oA==
X-Google-Smtp-Source: AGHT+IEB/ILAA9xYUQfW2KWQNzMMCyTN5Fgh1c/JAVWGUaLoeQoqs8yLNH5vm5UUyHsuDvyZMDkjSMrqPQd6JjIiXNg=
X-Received: by 2002:a05:622a:1992:b0:4e8:b245:fba0 with SMTP id
 d75a77b69052e-4ed24201737mr2800941cf.14.1761800646803; Wed, 29 Oct 2025
 22:04:06 -0700 (PDT)
MIME-Version: 1.0
References: <20251027122847.320924-1-harry.yoo@oracle.com> <20251027122847.320924-4-harry.yoo@oracle.com>
 <CAJuCfpE9PRvd1Tsm6gAvxKvPFgVt640q3vSbt0wAWOa3G4tnfA@mail.gmail.com>
 <aQHVB_8NVMZ2cuvh@hyeyoo> <CAJuCfpGFPuoUceB7SvAJPtVvzOOCzqS50yCcjbuMxV2a0e0KWA@mail.gmail.com>
 <aQK-wyE-h1bvaNOq@hyeyoo>
In-Reply-To: <aQK-wyE-h1bvaNOq@hyeyoo>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 29 Oct 2025 22:03:55 -0700
X-Gm-Features: AWmQ_bn3R48jrJn5u8sZk4g75yU9gtIgBe7otWH9hfRDS1mVIDIvKkjdnB9DenY
Message-ID: <CAJuCfpFNsmS-wk8OQJwAsT6kRBz9TOmA2wuCJ=AL4588qhYtJQ@mail.gmail.com>
Subject: Re: [RFC PATCH V3 3/7] mm/slab: abstract slabobj_ext access via new
 slab_obj_ext() helper
To: Harry Yoo <harry.yoo@oracle.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, andreyknvl@gmail.com, 
	cl@linux.com, dvyukov@google.com, glider@google.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, mhocko@kernel.org, muchun.song@linux.dev, 
	rientjes@google.com, roman.gushchin@linux.dev, ryabinin.a.a@gmail.com, 
	shakeel.butt@linux.dev, vincenzo.frascino@arm.com, yeoreum.yun@arm.com, 
	tytso@mit.edu, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: fsfw99zr4h5zju7s4df618635rfc4ywx
X-Rspamd-Queue-Id: 1FB4E140010
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761800647-82168
X-HE-Meta: U2FsdGVkX19g5cAU+xhoquhynAbmONUdGVZEalm9XSe3HKGoHlULhpuOIWOIrLng5jZnzXJbgPFOb7EAhtTvtf1wXq7So2tahQO5QMYuTc9txNfgb7hbvCsmspLVf/YOaA/TIBi6cIC5sm3GQR+OlUwR8oU7fwCUiKQAZ1ufPZ2M3UJ2Dzk47+0ntmYuRzJX2sn0mG+4y2pmtyuXapkLPBUdcQjmXQd9ZN9LBLNsKPL1cPpCOZ66IIm5twYDQOhQivOKze/DuvCC21+hwmelvmJIawhQfTToWO66qXxSXFgyZ3pBYh6tcs0ar2DeaYGwVAs+xVk8HnC0OIa3x40zDA43SZfiq2AywZPNxyjjOvt8j0Gceh6K6y9bGfMln1deuSyf7etYNFYUHxUbrycffCEipuri4fXreM70cG2Dbq33nrHeflwug64NQeblzbYjEjgdrQT7XgqipiIEF5TM0f2aF0EryhXLbjCMlw8ov0EWAh5aFT3LwfufDNUy9mRo3NAHnp7YgRnfe1YsCiXIOOBGOiuGZa2Ru+CITxs3udWm2TnHNaqPAKqt9bY6ko+Rs/oibYNBPNc/T5Y2Bwn8O+zoUq1SguxNlhzG9sm33fZSUBUaW8CJLTarye8vFkmy4SaK926x+BYoBg21LXgGSkCe8HQuInXCJOAyk70teu7omJtZwzTSBszZhnnlSTGyF4BA/brQ6uJuDFuRUs1qHoWLpxmDEIeUevduYQypC42zGII/jKkaBMcF95t6ZfuzGlSRmznB2KIHlZgPNqft0r4p9rOn4WUTcISJx8hp8d5P5lQFn1EFXdDBbdCzoy0WZHgDUClHIHs4NyB2OylDXuAEaZUB9Qa4ZnR4yUaV58xhv2sm7teZmIih64g4z2D9vMQJSUr+a1c4jPg4WWG5a6a1Qrm40oS0/lS/1jeWmpypw28fdGu5Iyn/TXib6xU60+Rmc21EJ8YDlB8kr4p
 rF0sgDAX
 /VaYar4MVxxFzLmQEhGgDl3Inms3fuSSdmbdnJJR0vVbezSleCMoQPIiNDicHy0vfultpWW0My30DHqByKPGToG2yDr6nkXhaq588iYhvrVwe399Uz+kL1GdzXlCgZNMUG8uPwQntsP7yg8Ig/16lIeAFHZ+k7mOEX7CcMIeKAgRZ9t3Jc298BmhUhZZO7YLFz9fnxcVR1EZ4Ed02+m5Zs9pqoLsC5i99f3hoAgOkWmyVJbiIbGHEB8ZtMb7s8lSsP3FZCLfAw6TvCClFY14hovGL8idGxpcwVU5qJ64bzmndM8Da0ws0FrchUCsT9nmHliYLtpA/NC6xb4igVazdkkp/vw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 29, 2025 at 6:26=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Wed, Oct 29, 2025 at 08:24:35AM -0700, Suren Baghdasaryan wrote:
> > On Wed, Oct 29, 2025 at 1:49=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com=
> wrote:
> > >
> > > On Tue, Oct 28, 2025 at 10:55:39AM -0700, Suren Baghdasaryan wrote:
> > > > On Mon, Oct 27, 2025 at 5:29=E2=80=AFAM Harry Yoo <harry.yoo@oracle=
.com> wrote:
> > > > >
> > > > > Currently, the slab allocator assumes that slab->obj_exts is a po=
inter
> > > > > to an array of struct slabobj_ext objects. However, to support st=
orage
> > > > > methods where struct slabobj_ext is embedded within objects, the =
slab
> > > > > allocator should not make this assumption. Instead of directly
> > > > > dereferencing the slabobj_exts array, abstract access to
> > > > > struct slabobj_ext via helper functions.
> > > > >
> > > > > Introduce a new API slabobj_ext metadata access:
> > > > >
> > > > >   slab_obj_ext(slab, obj_exts, index) - returns the pointer to
> > > > >   struct slabobj_ext element at the given index.
> > > > >
> > > > > Directly dereferencing the return value of slab_obj_exts() is no =
longer
> > > > > allowed. Instead, slab_obj_ext() must always be used to access
> > > > > individual struct slabobj_ext objects.
> > > >
> > > > If direct access to the vector is not allowed, it would be better t=
o
> > > > eliminate slab_obj_exts() function completely and use the new
> > > > slab_obj_ext() instead. I think that's possible. We might need an
> > > > additional `bool is_slab_obj_exts()` helper for an early check befo=
re
> > > > we calculate the object index but that's quite easy.
> > >
> > > Good point, but that way we cannot avoid reading slab->obj_exts
> > > multiple times when we access slabobj_ext of multiple objects
> > > as it's accessed via READ_ONCE().
> >
> > True. I think we use slab->obj_exts to loop over its elements only in
> > two places: __memcg_slab_post_alloc_hook() and
> > __memcg_slab_free_hook(). I guess we could implement some kind of
> > slab_objext_foreach() construct to loop over all elements of
> > slab->obj_exts?
>
> Not sure if that would help here. In __memcg_slab_free_hook() we want to
> iterate only some of (not all of) elements from the same slab
> (we know they're from the same slab as we build detached freelist and
> sort the array) and so we read slab->obj_exts only once.
>
> In __memcg_slab_post_alloc_hook() we don't know if the objects are from
> the same slab, so we read slab->obj_exts multiple times and charge them.
>
> I think we need to either 1) remove slab_obj_exts() and
> then introduce is_slab_obj_exts() and see if it has impact on
> performance, or 2) keep it as-is.

Ok, it sounds like too much effort for avoiding a direct accessor.
Let's go with (2) for now.

>
> Thanks!
>
> --
> Cheers,
> Harry / Hyeonggon

