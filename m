Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75A2BCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 21:47:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D338D8E000A; Tue, 16 Sep 2025 17:47:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0BE68E0001; Tue, 16 Sep 2025 17:47:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C21A98E000A; Tue, 16 Sep 2025 17:47:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1E7B8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 17:47:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 768231A032D
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:47:02 +0000 (UTC)
X-FDA: 83896449084.18.620F397
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85A5318000A
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 21:47:00 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=umTPcndc;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758059220;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8cORpR7NP/vc984PKQDAJOieXaROC8axwk2H5vOdW60=;
	b=ODkltnh9MSNV+ErnQ3VI4SAxWTMOyZMdJIUm9ILYlLSGeJ4BJGmHV7D2PLUtrmfI+Vq0hE
	lqIj+ygNUUqFfeVEqMojL84lQkCi3rOjYesnjtCiLlm+0C+Xf7r/X1e/Gzhgbv5BY0bZ4h
	WrVSXVXyzTLMlTf0iaGu5byMVIoKIl8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758059220; a=rsa-sha256;
	cv=none;
	b=dZQfz0cQml9vlGUN8CSLgY37QWySCtgSZqOMRGDpwBqgIIli7npUDTbRS6yMPnDlHbRAW2
	EFeB365VQllluBr1lLKFKTFhoQ4MbGmBpQgTkwqUAjnrYiY6dJ9iQVp7RolZqNPZL9HLi4
	hRxzDsSDjhHnDHQXT3/D9AjCoVh4rCI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=umTPcndc;
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-4b4bcb9638aso194731cf.0
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758059220; x=1758664020; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8cORpR7NP/vc984PKQDAJOieXaROC8axwk2H5vOdW60=;
        b=umTPcndc+yXlSiZzmAkTr2sbgpJnd5mI9Bf9dVhskqCr++PeitXBrRaU3LXMw0USlb
         Lku46SEjakWdorJjPg/bYah/jPgpZst/GBlYBdRYgxgub4hUFOy+c53rfLEGyldiVTUV
         qDwhTR9eftrrqnR2feR9iKZ8bLpL7hHifiywbS5j9aSBVErVcHaCGBzsw9OXQw+YgmV6
         7FHO4k3G3gvEcv/3LUvtLQxtdpOfD5SYhfZl0n5VO/+OOu4Bu77CpItLgtk5iAExVbOE
         Sftm221QXQpVbr/jIR+Tgq1zO+nQFPdrGCWjnqrqtumvJ6AxQSUC8JpaGWxIPqsvqVW6
         D/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758059220; x=1758664020;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8cORpR7NP/vc984PKQDAJOieXaROC8axwk2H5vOdW60=;
        b=fO+EGTBkQ063GOF8fhglVgIqeRHhpJdgUb3UxYl/dNbtqK1rRKxhoav/3IqOI21kje
         FOX2t1+Cw9BaA6cqd0ovzV7N28FBvhcmTeffJxmC2isTyBGMRRK3YU2JmicwmiIsfkSM
         wpIka2miebfM/0Huw1y3RQ/6lNb4tr4bEKNO9OUdqeZhESfmKsQj5h4Ej4BkZzk+8Few
         MnOOutZwNJPO/qmMrDN8ODvjOGEwYEd1BhM9CAZVIbfX325Wosrc+ohLwuz/gGDunuNf
         AX4UqfbrhnVvwQNEn8E+vi414JfcaxjlGAlz9Aa7t45Y+/er1XwziL36KMxL1LcvBrQr
         pi9Q==
X-Forwarded-Encrypted: i=1; AJvYcCV+0A4uOrXXTLc/Hw8SC+PJ5zTMbgjXa24OmubKA/0hjzDqjCrZRtyzd72ZGdGTsFsQflG7c4Us0Q==@kvack.org
X-Gm-Message-State: AOJu0YxFTgHFygYRcaxBW4jYWI+p2TWZgNMLD5RsPTU5aRhD6U3sMlv3
	5sKOtNxIN7QRf+gUTBlfDscpzg2VUlepiLGWs+rKNeel4hJOaGAnzJbX5JR7wdfVh2xXTIbAGwm
	xSYNP/pw6IgNWZfiUYw/SykqvkqOQnnQsGAcMa2uN
X-Gm-Gg: ASbGncuRn8v+9ERcV413ctaPNQDCgbHzdVVHQBNTaD1+A+JhIcKoEzbZ2nh/9R9UFvy
	TyySLn0nDWUaJykulJAPLbnMCJ+Jdywf6LhMb4YMR9JuOhKCi7tfDcctMCAzH6C7jCPm9cOYF5x
	lORnXtvsv1bENJ3RcoskNzT35dksF1PK/Tf3QChdcrDbNOpTWCa/6KB4dBUK0VaqCJ8MOApNuOO
	F1EtCXT4gFfDXRqBmtVr0udQi2hUujInVYzmZK9wPkSVzWtnYPoITU=
X-Google-Smtp-Source: AGHT+IG8pJr4Ku/EyvmNj7ByPDO1y93cWqsNmE/h4IbXm3vcafdNzffACFkfdJfTBgdN/uG7iO/k1NvDgpQ8Ad+czjk=
X-Received: by 2002:a05:622a:199a:b0:4b5:d6bb:f29b with SMTP id
 d75a77b69052e-4b9dd893ec8mr2081351cf.8.1758059219140; Tue, 16 Sep 2025
 14:46:59 -0700 (PDT)
MIME-Version: 1.0
References: <20250915230224.4115531-1-surenb@google.com> <2d8eb571-6d76-4a9e-8d08-0da251a73f33@suse.cz>
 <CAJuCfpHXAhGZb1aOPyHOPiTWSwQJi570THqJQcjrVPf=4Dt3xQ@mail.gmail.com> <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com>
In-Reply-To: <a8519bca-ae16-4642-84a1-4038b12e8bb0@gmail.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 16 Sep 2025 14:46:47 -0700
X-Gm-Features: AS18NWDiLEtpy2aZT2Vj6GfSOG8yRsirQN9jUBpKyJCyPlYfizq21u9MuuiIH3E
Message-ID: <CAJuCfpFJabb02OK8Rj08d7WU_7AM674i=vsZxzfw7i7h-PGftQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
To: Usama Arif <usamaarif642@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org, kent.overstreet@linux.dev, 
	hannes@cmpxchg.org, rientjes@google.com, roman.gushchin@linux.dev, 
	harry.yoo@oracle.com, shakeel.butt@linux.dev, 00107082@163.com, 
	pyyjason@gmail.com, pasha.tatashin@soleen.com, souravpanda@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: go9jy1ke49gkx4f414mpk8je8eekzcn4
X-Rspam-User: 
X-Rspamd-Queue-Id: 85A5318000A
X-Rspamd-Server: rspam10
X-HE-Tag: 1758059220-237520
X-HE-Meta: U2FsdGVkX1+7nD6AEe8/MJ7ypNm5FvWRnPhrIfc3E135uyxquv9CPolNuLKEbVD+Os8mZHiUfsIkucnt3kXOSSaWc00VeYHepYu3VQqjAY8nAQLHDTXtinpIiWCHHBq/ATf8uwGxlYGiOGiWMIe0GeusE2Q6xCTGPcspa/yFAVH37UB87uVVWDDnWYrrNkoiGZYI7F6ippKhxvfSYyynCNsQQ2zkdKA/IE0eqN3VkLWqcqxhasUD39vL2Dj5MNlU1Vmhy5xTQjoxIM1y5/u5sd6HXwYHqdV0wb4ciybvti/FyxQfgnXdJHPHISZRjrRPkDMyqJPrAsouIbSc0PFf70QZk8CcxpKVEl8fST/4pPL2v6FP+Hi0CKX6OVStz++bpk59BZv8BxCz5d/6aeS8My8XH8L/I2RVD+AeYYMSlHiaxZCzhAoQU9Mf/Xz5Ks8YTtc4MN3ya8uA2d7btelQ+cWQIwGlzLINmkewhdIpD7ZUCNpCo2isIEs2hMUsCrhn+N/Egtz/+GvemD3Xg7NZlQECoAtMppfgPmJlRr+WhmOcU9u0IjLqus1Mcs2Pq5R9B5FcNjJ2S1OW6ctSv+/NA0pTpEtf5DywqwdVPyoRFfPkiewFiHRnNz2wS45NkafYXNZHBu/8GNpyDR0ePxZOzhTzXVE6X9lXmilKxnEffTl5LijAcazpJM3NXDQrfQfO4mMVFReDuy5euDVw6dhscAUq0z2AT9I9WYDkj1Cd0OTOD0CSRwri2S1Z+cbQjKrSPLBKE5IoTM3fudZWSQkJ838M9GgE6P/conZM4uCSIVzMtpqNYLJ6QuVYOMwJKqE5oazNUl4l6psEf2ZTbMXBkNoxCjbx2dMGao/TIks2/CaHYqJhbVpTCH/XQXo5yfjS75ZztQ7IWlWQwC8DPelwvd09wUgdMt5fD0ebSYym56192C2B8yIl5aPdxUcK9kiXP7OhN+ijtShXf3V7rT6
 BILK7EDU
 0Cv/qrv699eV92PpOpwKxy3qVwHK1IjHUq+ZHlSKniUQ8/IFb0exqR7sZD+yC1dbGtj/Ig+Gdt3t9UhqDNbntHHaEVUqqSd+NCuX5bzPxav5vTnxf75IXOxt0hIB2nGlJv2fRx1BXa3TkBeYflgUhdGI12xsx6C8Ys9GsFRyoXRzr8vI+tYq/MMHabMjFs8QB3s9lE85hB/ahWh/SQasy2t69fhgLEqEQ4zeHSf942fDddoxcPpM7Dr4oa78V/0rY79SIlL8YBESHKNhX+YiEEvSrulTrw4f98GTJv8NZwW54eF5dRai1peL/AAJFs4O0Bm2Hp41VdlR1b6N6AUpGoZ4Z6oG/tUy3DJQQZwLXj6ksVxmYjRFIe6KlvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 2:11=E2=80=AFPM Usama Arif <usamaarif642@gmail.com>=
 wrote:
>
>
>
> On 16/09/2025 16:51, Suren Baghdasaryan wrote:
> > On Tue, Sep 16, 2025 at 5:57=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz=
> wrote:
> >>
> >> On 9/16/25 01:02, Suren Baghdasaryan wrote:
> >>> While rare, memory allocation profiling can contain inaccurate counte=
rs
> >>> if slab object extension vector allocation fails. That allocation mig=
ht
> >>> succeed later but prior to that, slab allocations that would have use=
d
> >>> that object extension vector will not be accounted for. To indicate
> >>> incorrect counters, "accurate:no" marker is appended to the call site
> >>> line in the /proc/allocinfo output.
> >>> Bump up /proc/allocinfo version to reflect the change in the file for=
mat
> >>> and update documentation.
> >>>
> >>> Example output with invalid counters:
> >>> allocinfo - version: 2.0
> >>>            0        0 arch/x86/kernel/kdebugfs.c:105 func:create_setu=
p_data_nodes
> >>>            0        0 arch/x86/kernel/alternative.c:2090 func:alterna=
tives_smp_module_add
> >>>            0        0 arch/x86/kernel/alternative.c:127 func:__its_al=
loc accurate:no
> >>>            0        0 arch/x86/kernel/fpu/regset.c:160 func:xstatereg=
s_set
> >>>            0        0 arch/x86/kernel/fpu/xstate.c:1590 func:fpstate_=
realloc
> >>>            0        0 arch/x86/kernel/cpu/aperfmperf.c:379 func:arch_=
enable_hybrid_capacity_scale
> >>>            0        0 arch/x86/kernel/cpu/amd_cache_disable.c:258 fun=
c:init_amd_l3_attrs
> >>>        49152       48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_de=
vice_create accurate:no
> >>>        32768        1 arch/x86/kernel/cpu/mce/genpool.c:132 func:mce_=
gen_pool_create
> >>>            0        0 arch/x86/kernel/cpu/mce/amd.c:1341 func:mce_thr=
eshold_create_device
> >>>
> >>> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> >>> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> >>> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> >>> Acked-by: Usama Arif <usamaarif642@gmail.com>
> >>> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> >>
> >> With this format you could instead print the accumulated size of alloc=
ations
> >> that could not allocate their objext (for the given tag). It should be=
 then
> >> an upper bound of the actual error, because obviously we cannot recogn=
ize
> >> moments where these allocations are freed - so we don't know for which=
 tag
> >> to decrement. Maybe it could be more useful output than the yes/no
> >> information, although of course require more storage in struct codetag=
, so I
> >> don't know if it's worth it.
> >
> > Yeah, I'm reluctant to add more fields to the codetag and increase the
> > overhead until we have a usecases. If that happens and with the new
> > format we can add something like error_size:<value> to indicate the
> > amount of the error.
> >
> >>
> >> Maybe a global counter of sum size for all these missed objexts could =
be
> >> also maintained, and that wouldn't be an upper bound but an actual cur=
rent
> >> error, that is if we can precisely determine that when freeing an obje=
ct, we
> >> don't have a tag to decrement because objext allocation had failed on =
it and
> >> thus that allocation had incremented this global error counter and it'=
s
> >> correct to decrement it.
> >
> > That's a good idea and should be doable without too much overhead. Than=
ks!
> > For the UAPI... I think for this case IOCTL would work and the use
> > scenario would be that the user sees the "accurate:no" mark and issues
> > ioctl command to retrieve this global counter value.
> > Usama, since you initiated this feature request, do you think such a
> > counter would be useful?
> >
>
>
> hmm, I really dont like suggesting changing /proc/allocinfo as it will br=
eak parsers,
> but it might be better to put it there?
> If the value is in the file, I imagine people will be more prone to looki=
ng at it?
> I am not completely sure if everyone will do an ioctl to try and find thi=
s out?
> Especially if you just have infra that is just automatically collecting i=
nfo from
> this file.

The current file reports per-codetag data and not global counters. We
could report it somewhere in the header but the first question to
answer is: would this be really useful (not in a way of  "nice to
have" but for a concrete usecase)? If not then I would suggest keeping
things simple until there is a need for it.

>
> >>
> >>> ---
> >>> Changes since v1[1]:
> >>> - Changed the marker from asterisk to accurate:no pair, per Andrew Mo=
rton
> >>> - Documented /proc/allocinfo v2 format
> >>> - Update the changelog
> >>> - Added Acked-by from v2 since the functionality is the same,
> >>> per Shakeel Butt, Usama Arif and Johannes Weiner
> >>>
> >>> [1] https://lore.kernel.org/all/20250909234942.1104356-1-surenb@googl=
e.com/
> >>>
> >>>  Documentation/filesystems/proc.rst |  4 ++++
> >>>  include/linux/alloc_tag.h          | 12 ++++++++++++
> >>>  include/linux/codetag.h            |  5 ++++-
> >>>  lib/alloc_tag.c                    |  4 +++-
> >>>  mm/slub.c                          |  2 ++
> >>>  5 files changed, 25 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/Documentation/filesystems/proc.rst b/Documentation/files=
ystems/proc.rst
> >>> index 915a3e44bc12..1776a06571c2 100644
> >>> --- a/Documentation/filesystems/proc.rst
> >>> +++ b/Documentation/filesystems/proc.rst
> >>> @@ -1009,6 +1009,10 @@ number, module (if originates from a loadable =
module) and the function calling
> >>>  the allocation. The number of bytes allocated and number of calls at=
 each
> >>>  location are reported. The first line indicates the version of the f=
ile, the
> >>>  second line is the header listing fields in the file.
> >>> +If file version is 2.0 or higher then each line may contain addition=
al
> >>> +<key>:<value> pairs representing extra information about the call si=
te.
> >>> +For example if the counters are not accurate, the line will be appen=
ded with
> >>> +"accurate:no" pair.
> >>>
> >>>  Example output.
> >>>
> >>> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> >>> index 9ef2633e2c08..d40ac39bfbe8 100644
> >>> --- a/include/linux/alloc_tag.h
> >>> +++ b/include/linux/alloc_tag.h
> >>> @@ -221,6 +221,16 @@ static inline void alloc_tag_sub(union codetag_r=
ef *ref, size_t bytes)
> >>>       ref->ct =3D NULL;
> >>>  }
> >>>
> >>> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag)
> >>> +{
> >>> +     tag->ct.flags |=3D CODETAG_FLAG_INACCURATE;
> >>> +}
> >>> +
> >>> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag)
> >>> +{
> >>> +     return !!(tag->ct.flags & CODETAG_FLAG_INACCURATE);
> >>> +}
> >>> +
> >>>  #define alloc_tag_record(p)  ((p) =3D current->alloc_tag)
> >>>
> >>>  #else /* CONFIG_MEM_ALLOC_PROFILING */
> >>> @@ -230,6 +240,8 @@ static inline bool mem_alloc_profiling_enabled(vo=
id) { return false; }
> >>>  static inline void alloc_tag_add(union codetag_ref *ref, struct allo=
c_tag *tag,
> >>>                                size_t bytes) {}
> >>>  static inline void alloc_tag_sub(union codetag_ref *ref, size_t byte=
s) {}
> >>> +static inline void alloc_tag_set_inaccurate(struct alloc_tag *tag) {=
}
> >>> +static inline bool alloc_tag_is_inaccurate(struct alloc_tag *tag) { =
return false; }
> >>>  #define alloc_tag_record(p)  do {} while (0)
> >>>
> >>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >>> diff --git a/include/linux/codetag.h b/include/linux/codetag.h
> >>> index 457ed8fd3214..8ea2a5f7c98a 100644
> >>> --- a/include/linux/codetag.h
> >>> +++ b/include/linux/codetag.h
> >>> @@ -16,13 +16,16 @@ struct module;
> >>>  #define CODETAG_SECTION_START_PREFIX "__start_"
> >>>  #define CODETAG_SECTION_STOP_PREFIX  "__stop_"
> >>>
> >>> +/* codetag flags */
> >>> +#define CODETAG_FLAG_INACCURATE      (1 << 0)
> >>> +
> >>>  /*
> >>>   * An instance of this structure is created in a special ELF section=
 at every
> >>>   * code location being tagged.  At runtime, the special section is t=
reated as
> >>>   * an array of these.
> >>>   */
> >>>  struct codetag {
> >>> -     unsigned int flags; /* used in later patches */
> >>> +     unsigned int flags;
> >>>       unsigned int lineno;
> >>>       const char *modname;
> >>>       const char *function;
> >>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>> index 79891528e7b6..12ff80bbbd22 100644
> >>> --- a/lib/alloc_tag.c
> >>> +++ b/lib/alloc_tag.c
> >>> @@ -80,7 +80,7 @@ static void allocinfo_stop(struct seq_file *m, void=
 *arg)
> >>>  static void print_allocinfo_header(struct seq_buf *buf)
> >>>  {
> >>>       /* Output format version, so we can change it. */
> >>> -     seq_buf_printf(buf, "allocinfo - version: 1.0\n");
> >>> +     seq_buf_printf(buf, "allocinfo - version: 2.0\n");
> >>>       seq_buf_printf(buf, "#     <size>  <calls> <tag info>\n");
> >>>  }
> >>>
> >>> @@ -92,6 +92,8 @@ static void alloc_tag_to_text(struct seq_buf *out, =
struct codetag *ct)
> >>>
> >>>       seq_buf_printf(out, "%12lli %8llu ", bytes, counter.calls);
> >>>       codetag_to_text(out, ct);
> >>> +     if (unlikely(alloc_tag_is_inaccurate(tag)))
> >>> +             seq_buf_printf(out, " accurate:no");
> >>>       seq_buf_putc(out, ' ');
> >>>       seq_buf_putc(out, '\n');
> >>>  }
> >>> diff --git a/mm/slub.c b/mm/slub.c
> >>> index af343ca570b5..9c04f29ee8de 100644
> >>> --- a/mm/slub.c
> >>> +++ b/mm/slub.c
> >>> @@ -2143,6 +2143,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cac=
he *s, void *object, gfp_t flags)
> >>>        */
> >>>       if (likely(obj_exts))
> >>>               alloc_tag_add(&obj_exts->ref, current->alloc_tag, s->si=
ze);
> >>> +     else
> >>> +             alloc_tag_set_inaccurate(current->alloc_tag);
> >>>  }
> >>>
> >>>  static inline void
> >>
>

