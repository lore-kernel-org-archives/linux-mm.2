Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4BCDCD4F26
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 18:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D87D6B0088; Fri, 19 Jun 2026 14:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B1556B008A; Fri, 19 Jun 2026 14:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AF86B008C; Fri, 19 Jun 2026 14:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63CD86B0088
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 14:08:33 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E8BA11C2C8D
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:08:32 +0000 (UTC)
X-FDA: 84897447264.11.45F7BDB
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf01.hostedemail.com (Postfix) with ESMTP id F09E64000C
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 18:08:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GmYxeZn3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781892511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=if+w51pfEbXF0aIKIU0/YXuwi1jZSWlejSs+38AZ5sI=;
	b=azwHTHA0GDKT361FOH5I4mTcdljE1urWU3CWRl7DaagezC7i2dly1o319QdPxHYafgrUvJ
	PtrMgoUsFVaam/CmnqFUxMrFB7VeCGRSHZNftRPWs1BwqQM7TiDXWbh3VISybn2ZXGe1L3
	0ocd/9Vq2zDKTtsRqnK1erh4w+o4MN0=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GmYxeZn3;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781892511;
	b=On560BhUkmEVwe7w2d9gYny3U8s8XbbfcSVetk9Twl1ZQvbUsyysC6gSK9vSnjA5tK7sYp
	0b9EofAHBaq/407KAAGGY9+TQRxmkCOfmrlLF+sbwczIQgn4BueP7pWNTCvLdMNxtG06/Z
	HV2tGmqN1DQNzQTMxyxn6FyKwQ6/khw=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-5177d1ff061so244791cf.1
        for <linux-mm@kvack.org>; Fri, 19 Jun 2026 11:08:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781892510; cv=none;
        d=google.com; s=arc-20260327;
        b=KWdryu+czFLa3E/sajO6pu4SzC7W4BlElbUuSb4Du2Rlq/9orpj3cFSqS2E9jytQFi
         qbi8ITWLBpkEpTwTd0SIfmhLykw2nrd+mIKVzIG1Pv0w4dUK6v4s+D6B5Zny7lE2ONH9
         a0QVeWXxjCCW9dbpy+33h09Z/voliFqF1OqXewayXMDEIYBDKH7/TEedOitF0dgYxCfJ
         02CtCu8b5tzWZQdb9dTZObBeYXGxnc51K0+T/xsx6Us4ovYQneQIZB7GVdcUSI+OQNBy
         zr+PH4/SguZtkRpnwA6nAZscQg5zosnNXqUPK6qGoJxEOu/ophJ3GZrebQSCvj7xZ1MW
         Px/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=if+w51pfEbXF0aIKIU0/YXuwi1jZSWlejSs+38AZ5sI=;
        fh=XTgPmEIp/MCvTdhHx6hGv8zVuILAjNr34DTlWquJWp8=;
        b=PSLeICliDVTt/aeQacbNuanLSo5qMv+jY1MxJrD4/GGohMOBPMmpiDzvsgIXe2vrpf
         +k569A0Ie6AoJxg1erCMVhSpocBGkLdtF65dI6wqAU6bdzL4BGXX71r+PK9+FNRWxUr7
         PXjKbjMlfawB5hWsxSB793UxW/SJxruH6KVX1eQFG3EVttQC6tUqfCQrSnZ8MbfJV5X1
         lv1t6LtjWpNFZhZNZKKe2UkTu2q0pDvDV7jjB95XLr253FDhV8DUqMo5o6ptF4pZhCLJ
         ZqOAhiDycZ+6LyM/hf10r91A0As+gn1ctu1Z9qiF42kY8kqime3UxLtUqeCzdcXJ+M7q
         3tWA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781892510; x=1782497310; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=if+w51pfEbXF0aIKIU0/YXuwi1jZSWlejSs+38AZ5sI=;
        b=GmYxeZn3rhTNLJe0FvjiZZHL2qp+i4USuvPY4WibvMsnWLHQkc+Cly+N6jKvtdeDUb
         VwZ9BSpXyEqQvPbkeVrIdDsYAtJE+hzVL2UoMnLZXU00br7ZR5EMwPHgva1IAhwsFfUL
         rxT/IlhXp9HqbzB2KPGaIutP1FLri6tDb/cRj4+0EVshSB80AhSVCsJbEhcnLrR4uBTF
         2zAM/RS3cGn7f/0t59qgNA2IwCydHTYdYgdFaBJKzVtZHF0JRuWD9EzF75lkZfgXEqac
         /ewffxFlKGrv8PfxXX6mMwaouMlhMTK4mYwJslVvLqaxhIgwvRkHfFHljph11nk4eDiD
         Zorg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781892510; x=1782497310;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=if+w51pfEbXF0aIKIU0/YXuwi1jZSWlejSs+38AZ5sI=;
        b=j5vcSFqrjVgc9EryXO4j0x9pzGqFA4D+vz1fgIb1EK4FWZuJWc5yspXNwyeETghUkf
         iRjz3Mfy+lXAWVv6Mt2Y6Sz2J5tycw8Nkk+xibM5D5dQIFma9Lgfk/++eZUHTvleQ8tB
         0FPozGeyhCZVMl7Rc+nkiWKMUfxm4vwWEe09qwONvndav+H07e4MDS26hPe9TJTPcPep
         0e6WJOOhFBaLmr1qQSX/56JWLfUZ3GwWQv8fk4YYgKCMeUc2ruChRbqWwPsqE0czfC6W
         kXE0OolrPJT0AYHtFyh/Ptdh71wWL2NLYUKNV2t+XtWZtBqAgHuvJa0xl10YF7E0eXya
         +ELQ==
X-Forwarded-Encrypted: i=1; AFNElJ9vqSM0iK5LaXYFWMgfME7L85NBiCXFbYnCNAnycCjiiPnfI3FkpV7G9XjAcyx0NInDlNByunDCrQ==@kvack.org
X-Gm-Message-State: AOJu0YxfVGTEk0M4JG99DcYUnyU48yePYQ1Y+ubByv0khB73WmQ5sRsi
	05bU6K/RfLJcz6dhKU2lAwCKk1rVa/xMveAD8S8IvUmZjBj/Ht0LQHPlRHXtyXIBAWGJdjMVIYb
	ioOKWigZbLKhx8Kct3U9OO2ow6VfAWZ8jm9F7uNtb
X-Gm-Gg: AfdE7clj/HdrFI3xjRnYDYOan/4XY95wA/AM8hjrmFVAWNvlm4Z4TXqagVZ1jISYUxt
	nmCRVvGvjnrFN1JmDp35y6VtPoTZpquIx76NJtlexz+DzoUYd1iwQVDBNZlsMNjMGGMuStq2dnC
	axxHMjLPH/0YoPJAf84WFqQhuHrpaNHNbBjbv+zQsNXs/QgTvr5JW0ddpDomJdK9pPrVXElvn16
	YNoZKE4uT6qMKpQpxCb+/2WJai93AmM4bFCqJ5j82NBWRm9WZDhqP4+XM/pm2yUKbmdJ20=
X-Received: by 2002:a05:622a:1b1d:b0:516:3def:1cf4 with SMTP id
 d75a77b69052e-519e877e8c5mr8151881cf.1.1781892506298; Fri, 19 Jun 2026
 11:08:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260617-alloc-trylock-v1-1-83fd7858832e@google.com>
 <2399b3ad-4eac-4a14-94c3-27e9f07972a1@kernel.org> <CAJuCfpG48TmvaiaRvnL-NXKU6nn55D3bks2DgzAc0URsZhAxqA@mail.gmail.com>
 <DJBHRVM65A11.1OL2M9MXN56H@linux.dev> <45fcc57a-ec8d-46d6-9c28-065d001c081f@linux.dev>
 <DJD0AGHTWYRN.1YWG5MDH87WVO@linux.dev>
In-Reply-To: <DJD0AGHTWYRN.1YWG5MDH87WVO@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 19 Jun 2026 11:08:14 -0700
X-Gm-Features: AVVi8Ce-wKSRl9HZnLx7RL1pqEgargGWpGuNyAl9oa2UQznN8ojLU8He4KFHTmo
Message-ID: <CAJuCfpGtymV=Tmsvs8Z-oF6pi7mD54mRiZNZtpF3UpYwBL7Uig@mail.gmail.com>
Subject: Re: [PATCH] mm/page_alloc: unify __alloc_frozen_pages[_nolock]_noprof()
To: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Hao Ge <hao.ge@linux.dev>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Alexei Starovoitov <ast@kernel.org>, 
	"Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price <gourry@gourry.net>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: F09E64000C
X-Stat-Signature: 84nbitiiiioaimd4ye4w39fu8wupxt46
X-Rspam-User: 
X-HE-Tag: 1781892510-874283
X-HE-Meta: U2FsdGVkX1+DuE/6x+9u94xkJGXbzsj46I5KPMKGlvfT0ZsOZNboWhvVvfIHriOnDxdafoKF6XsZ6HlryYP/6N3JFTCAJyL8LSeHvLkumbWT/9jGwx7lNmvP/fEW/GpzwM2ito5y2dyQj/DLC7WXDD2+QqCjx+kGDhsSLgbGlgR/L0TM6DK94k0R3f/VqFGNVeWNB3749zy1AkFSwlm3pC4oSL5eYdQLd1p0j8VS8rm9xsG9gpNVRouefIUwawSUKdcaEUM0o6C1f/+PTWyb+IA1PuEl9gIA/27fiwQn7vkYNs9709A9cFBikgyK/ELWA08M2XKiV6EFrWIaDn0IAAYtGI+pHoA9cdraXR13Ak7XmFZUmdCV0FapCPnAKwpjl1leI5UNMSCd70MIkvsdlGNtsOYQ1/mSGDPAR6sKY03Pdml338JECRkuq0HdoNx+rli7ahcWfmMXKFFwmm2/NHQbKKR+0lN2yHfvojPbLscgEh0oiN5es/kPBmspTv3sFm4Am0jdQx3VGNibogvRTOOadGpwLruSOnidscSWhkoFj1jBbqFKtMpzoRCUbhHIFAM+OGx2QnVgSiq1CNMIoAjIYanJC0kTvjZYqHElk2UKpmuZHPfs+utpCGxQGT7e7urq92bI02goYWGm8kLC0CTs2L0t9ntdgFNuo1iERoHZVEX4W1WlsofD6+ZsJKfCMBtFJNm06+ZWoDEgpyQvktHzz6t/NE3Dl9fIDSZN99kWATZ7NQejUedfIFstNJEomibTKTt0sPFZP+VyFQUtwHu89Ng9P04FJv0diQFQFtNXsuUC2ReQ96Es12gdYWN2KFONdjbZr9ol52jpl9e/wY8FBFNCe2Bxc/eP+jskO4Nxlz04NXOonjZE6Jm5AjNF8chroMStOwf9KY9HzzY1Z6rNSP0MUWM4ampQcbshV85kiElTmH+67PusoNZUnXwZMfpJDEUHgQ4ShaKUe5o
 lGciNsR5
 bfuGRZ4zhnm6VGpa19FLCnuxUPj7k2FX2f9KUUhaBvsHPttUZ14VbT+udNqQ1y5s1zlvz1iI/Gxx3f/LOJPZJS9eSk2U+ZTgt27qMte85pCu+UksUIurSLTS5HPcN80slQtqoGqAc5rFNnbG4nneCP9Vo6RmLLw6NN8tCZISrnZbOH1IldnzAcU/Rz1QPgbV/uHV+MMpPedPAbxJQf/jSPKiBB16fkfHRc7az4LwqUSN5YOqdSpLBg0pQwXWxQdpriII3hs377J/y/xbD+8uH5CAQvDqB4yb7Ptnz2as5JuRaKTZdS1ifYOXG682DyRzauI2PkvaehLeEYYuBtAd/bhVqMMleMVUEvM4TZP2uiNWNpyp+rX3WfzDXBTNm3OXzO+HLAdQ5EBa9e8Buc+LZymPBSAzATxua3bH+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 19, 2026 at 4:57=E2=80=AFAM Brendan Jackman
<brendan.jackman@linux.dev> wrote:
>
> On Thu Jun 18, 2026 at 2:22 AM UTC, Hao Ge wrote:
> >
> > On 2026/6/18 01:14, Brendan Jackman wrote:
> >> On Wed Jun 17, 2026 at 4:49 PM UTC, Suren Baghdasaryan wrote:
> >>> On Wed, Jun 17, 2026 at 9:39=E2=80=AFAM Vlastimil Babka (SUSE)
> >>> <vbabka@kernel.org> wrote:
> >>>> +Cc Alexei
> >>>>
> >>>> On 6/17/26 17:29, Brendan Jackman wrote:
> >>>>> Currently the core allocator code is controlled by ALLOC_NOLOCK, bu=
t the
> >>>> It's not, it's ALLOC_TRYLOCK! Thanks for proving that we need to ren=
ame it
> >>>> to ALLOC_NOLOCK:
> >>>>
> >>>> https://lore.kernel.org/all/DJ9QPTO2WXNB.10E88ZHWRDHB0@gmail.com/
> >>>>
> >>>> So you just won the job to do the rename :) I think it should be don=
e before
> >>>> this patch, so that the new usages and other _trylock names introduc=
ed here
> >>>> can be done as _nolock outright.
> >> Ack. I'll aim to send that tomorrow once Sashiko has caught up.
> >>
> >>>>> main entry point function is significantly different from the norma=
l
> >>>>> __alloc_frozen_pages_nolock(), this is tiring when reading the code=
.
> >>>>>
> >>>>> Plumb the ALLOC_NOLOCK control one layer up in the call stack: crea=
te
> >>>>> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is =
only
> >>>>> exposed to mm/) and then turn the nolock variant into a thin wrappe=
r
> >>>>> that just sets that flag (as well as handling NUMA_NO_NODE, similar=
 to
> >>>>> how some of the wrappers in gfp.h do).
> >>>>>
> >>>>> Rationale that this doesn't change anything:
> >>>>>
> >>>>> 1. Simple bits: A bunch of the nolock-specific handling is just mov=
ed to
> >>>>>     the new alloc_order_allowed(), alloc_trylock_allowed() and
> >>>>>     gfp_trylock.
> >>>>>
> >>>>> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
> >>>>>     previously in the nolock variant:
> >>>>>
> >>>>>     a. Application of gfp_allowed_mask; this only affects early boo=
t, and
> >>>>>        only flags that affect the slowpath get changed here.
> >>>>>
> >>>>>     b. Application of current_gfp_context() - also only affects the
> >>>>>        slowpath
> >>>>>
> >>>>> 3. The slowpath itself: this is now just explicitly skipped under
> >>>>>     !ALLOC_TRYLOCK.
> >>>> I'll have to ponder it more closely.
> >>>>
> >>>>> Ulterior motive: adding an alloc_flags arg to the allocator's
> >>>>> mm-internal entrypoint can later be used to do more allocation
> >>>>> customisation without needing to create new GFP flags.
> >>>> Ack.
> >>> I think this change might also help us in removing __GFP_NO_CODETAG
> >> Nice, this actually looks trivial? I can probably just tack it onto th=
e
> >> v2 for this patch/series.
> >>
> >>> introduced in [1] and being the only user of __GFP_NO_OBJ_EXT once
> >>> Vlastimil's patchset removing other __GFP_NO_OBJ_EXT users lands.
> >>> CC'ing Hao as he is brainstorming ways to remove __GFP_NO_CODETAG, an=
d
> >>> this might be the answer.
> >
> >
> > Hi Brendan, Suren,
> >
> > Thanks for CC'ing me, Suren. This is indeed a viable approach
> >
> > and I believe it brings us one step closer to removing
> >
> > __GFP_NO_CODETAG entirely.
> >
> >
> > Brendan, I'd actually put together a rough local implementation
> >
> > earlier with mostly the same core idea as yours, and this change
> >
> > would indeed be minimal based on your patch.
> >
> > Thanks a lot for being interested in tacking this into your v2 patch se=
ries.
>
> Oh, I just took a look and it's a bit more fiddly than I thought because
> alloc_tag.c is actually in lib/ not mm/.

One option is to move alloc_tag.c into mm/ (while keeping more generic
codetag.c in lib/). From a quick look, that seems doable and probably
the easiest approach.

>
> How did you tackle that, can you share your implementation? It would be
> nice if we can avoid exposing alloc_flags in gfp.h.

