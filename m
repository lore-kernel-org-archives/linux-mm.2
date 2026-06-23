Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B91FDCD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 23:48:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36B406B0088; Tue, 23 Jun 2026 19:48:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31C246B008A; Tue, 23 Jun 2026 19:48:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E40F6B008C; Tue, 23 Jun 2026 19:48:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E18046B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:48:19 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6A1231C4D07
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:48:19 +0000 (UTC)
X-FDA: 84912818718.29.F0FE9C7
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D9A91C0005
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:48:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsUkMmSp;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782258497;
	b=VlDii1CiI9jNdm1BkvuyxviWOe1mEIRUCmf+ofMOAxcqJUdaluRXcPWX+t/JuCW+DZB92f
	q7N44HcdGb+OusJFQ4x+ezZDBmP6++V5M/7UCMStxxGo1FFobrlIqfmlwuhHlESZzSOO6w
	3Noo9T6z4f13uGvLheF7KeyDU8zBt3M=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782258497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sHhJ3s+79BMlh+EM41yNOzFZl1I5vOhlk0uG1/54xcc=;
	b=myLc2Ny3xGC8nkLuvX8fzP+o95SvWNQx/OEo29TRPKNQgt8mkpzsLkvjRZviKKtymtfwBp
	q/0Vt+pu1KU6jokRRcz8T+lSxMiUT1JQGbYi1i1w5yWCJve1Bis50M2T3YHQQduYvqeRgi
	iHV7+lTsz9D6jgi6Fze1Ildv+SeF3nU=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YsUkMmSp;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5177d1ff061so64581cf.1
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:48:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782258496; cv=none;
        d=google.com; s=arc-20260327;
        b=g1LDO90img6Yz304TN02OYqSJOmAywVtzbCmtgR7iTSxi097Thk9YWIpSMOxObW6ys
         iOA0AKVeyoTpRpNtC4+fOtqEhSW5G8zD4rKpYmaoiMMLyfvPkNn9k2INJVsbuuprjPJe
         vSRluCPyZuRevplobMPHADpFu/oi5ML2gkE9EafjCWoYd0QrzxKUAGSgP0CCu9ed47Xt
         UsIdCz5ovdjp4iFkbvHoQ1+UEW1ga0C8HdyKsKfhLYevZZTcvBLTFN7VomX5Kxo9NKeu
         EG+yKC+Fx1MEhgT8LtLwxaprVyrqvsajFHY3Y/VFmhIDNilZczNnTELpat5oeYGaFKvX
         twug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sHhJ3s+79BMlh+EM41yNOzFZl1I5vOhlk0uG1/54xcc=;
        fh=+MFMzkFULeREziyskB9lTAPpqHnDsN+jIAqbqPqhkKY=;
        b=it00tgVJ7/ASPg3tQ6euZNx9+NBNMgVdTEZld2KM6Ff92HWfxGU/EVTQs/kvdr9VUd
         I0WIOE4m5cluQaXxiNjxhMq3A01l6dCRrSCkAOrWMjtO+oxMZK24McAc22hokktvYV7g
         MAypjW1PiIwVumYDRu4BY/vnM6etyFuPbez5xdiRE6nbgKtWmEzCmzGvzz4fMulyx6Kg
         zfKviyVrwPIW9nWeIC+b3mo484bTC2ojK4XRSYV4rMa50dFVW6nJwHFD9+qJrWJJZQMX
         snqEjFMzHhB+MmFwxF3JoPA4TXyWRYcjRzxAHVoIAP5hrTkyIbJDZ8oHox502JBYc7gH
         f1Gw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782258496; x=1782863296; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sHhJ3s+79BMlh+EM41yNOzFZl1I5vOhlk0uG1/54xcc=;
        b=YsUkMmSpqOC2a90iWfBkKoB9FJ9aUIIECNxvN3deedJLN/ENZ95o8hoYJ3hFt/Rrmv
         msjgKf19+BpyFxfGkQCpz6zY4vBKMolB2Ks+LhpyJs317KpWGBJbZBS/SCdFnQ6Qbr18
         KYYEGMykcwPl5sYxPRRPQ8m5klFk49V6uhsbtUeyoWlN9GMMajlanrVVx3vlWO9UD8g/
         euqJE9+YnRiS//752L4fnWs3oUtepekQ5qwsYe6GUIQeniraFHDqxl0VLdpHl6I/j9Bg
         aIhtWWrbaiJg9TTNQQTiF68k4XacFBkC5vKLhyn1zXpBwdXCW2x6XPG3++3qAC7pvdUj
         Cn1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782258496; x=1782863296;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sHhJ3s+79BMlh+EM41yNOzFZl1I5vOhlk0uG1/54xcc=;
        b=NkHPBQgiCcT4OMdvepkr1m9Dh9JLen9l4UBnu7DNTTz2dwiktw4eJumrDFSyRrF8a/
         y12UZwfRj72MMLDgZZpNo/m41bx0kHEP+6t6AZ9M6Svw89FLTFh5c2XzpkPXadKfn0Hw
         XnKez/7dJvdeI9vGNPU0oQntR8eX99nS9hWBqPLDA7HVZpPjBV97diqYTu0vjMzhhmnL
         4p4DsPq8AIr7BvCKUApC2iTRopkBOGAxTI2Ngm2yf47tn86esZmf6HlpwK9gtHfcsnWM
         KovMfPJxm9y2xKJYdz2FPrjf80H5cn0mCehBwZEEc8fEe/kG7AZtOi/roUFBOSywGY8B
         3y1Q==
X-Forwarded-Encrypted: i=1; AFNElJ9JehG2Ag8DnI6DdPfK7b7vOeVUaWs7D2rvY1KQswAJcLaSvizk7SOcTWS+incQtvi/McJn0g93xQ==@kvack.org
X-Gm-Message-State: AOJu0YzSWJRXKiJ70PfBdJj0UayBOjzUhme1LaZQxzpb1OSXBr2basno
	bDTeL2Su5zytKuZOrWyTa9ji/p7YuF1F/QqAGeGExFifW/Z72OBWr9LNCR5clPviMlFYRaq/Pmb
	vfuopNLevs3333t0EWR2E7w37LIkWkLlGGKHcKCzu
X-Gm-Gg: AfdE7ck0G7R71Wax5MYh25lksHXQD3wzNHwG5lNq0Rm1Vbi9ksgpgL8bp9ya+ZjIXW7
	afnnlBEgLnrHnD4Z6OTivZXZXhYMcptuSuHr9YbF213IyHHm5aYLPLa9Wb9oBxFbqZ27c5Iccfb
	WeUCt6/QC45KQNcR0bplhREN1i7jT8PuzNM1RH+A8ItAckmxck9T+rrbMHotIWPBbuFX9jTxtM3
	sUVW+p7j0JqFu/r8fB6uVwUw55QcRKYLkQHnTXN0u3BUEmYNlrT+j1WedCW2/pe2aiYRLc=
X-Received: by 2002:a05:622a:60a:b0:50f:b69a:f4a8 with SMTP id
 d75a77b69052e-51a62873f9fmr1839601cf.7.1782258495776; Tue, 23 Jun 2026
 16:48:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260622-alloc-trylock-v2-0-31f31367d420@google.com>
 <20260622-alloc-trylock-v2-11-31f31367d420@google.com> <ajrA4wiAKTdiraEO@lucifer>
In-Reply-To: <ajrA4wiAKTdiraEO@lucifer>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 23 Jun 2026 16:48:04 -0700
X-Gm-Features: AVVi8CdNsBAUkRPYTNbvvM06_e98li5SHRpWwrVjEcRlly4hSHl5zjPn7Ue86Dw
Message-ID: <CAJuCfpHqvLVnycuufO6Kf3S_RSFjyDRUnTGDyu3VW0kQ90tiHQ@mail.gmail.com>
Subject: Re: [PATCH v2 11/13] alloc_tag: Move to mm/
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: Brendan Jackman <jackmanb@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "Harry Yoo (Oracle)" <harry@kernel.org>, 
	Gregory Price <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4D9A91C0005
X-Rspam-User: 
X-Stat-Signature: yfoc81qkctca6898bdcd1osj5thsargf
X-HE-Tag: 1782258497-483487
X-HE-Meta: U2FsdGVkX1+7EEI9hSIKzl3TuYMsTfQaAGd468CpVgCw6VyKvMa3bbnVQJMsc68GRgC+Bq0XgzXXoiD7WYfMjpxEIYNVGcIpaPY4he5DS+aqNkeM1RuM2xJ2zRw29qpiPSn8F5kRjuRG3cehPA+ALLgezIoOJRPToGj5ubUZIHktVZzrZHa0BXzOhVMSvO4qVIFjRVgV0vll1U9+bxUNufydUCeV7D8RpVagekp2x7PoLxs8c5Ooem3HPpCLVESPeFHgdrMpcMhajCHjcdpXJPoUsStjMf2dbVp+QI+eyWrgdDCaNAJ4yGiTjd49dSKJKHZjUomSU3iAsVlYzngMRVQp2GVQCAiv2l9WjbJOB4olMMs3JN3qUWShgQfDeBGUpIMehgqW14brENT9Svsarfare5je/kpqatNiti68nRkj9/3RzqGtH2GMe6izT9YphU+Ix9qb9VZZdQRMXhsyxQuJu6MtB7kQRCbG5N6/FAZ4VH8meS0xJGcW/9EY0/RO0oiIJyrLLyFgeTygfKuTZZi4Zdsc6rSGx9SOEGSi8niP6ZO8WmW/mcZI7TjYN+mPY4SuVk9JWXdpYhwSaYHmYkJ2DQXIasbXrtdGVFiXuPQZtpBajR1J0RTgrwY6cdGjPIKO4NTDVfKvorwKXNlongfM7X87vUWyNGu2fiYcXL7yNV2D9hNE/hVsSe3ToChyU6BlHktE4V/KdoSVkDdeCdqE+uYuyW7ks6pX4C/6T2J7PUXAAmJuCKOaWxyAaAykcTviWHO+XybtrUNiBkJ39LDUlbLel5wiA4jVx29NgyDaN76yGKNKpwG2KE9CQrK15iYMQI7knOl7znWAI5BFkreGRYVEoRkrk3TiyrRG4uFhUa3YyujZmav359CLHv0tY8amp0eN1SAE6v5FXd/qScCbgmekPK2amxsIDY05Qoi6DEBmc6xfzUWgDZjoZHq2UHR9AQA94Oab/w7wija
 1ZV65BZ1
 jasdGAzzr2V1BSub/q9TIr5abPHyTKt8BAKcVDtX6KT6fG2/nb/N5lzxEm2THQ7PPLsv8Ke1oJJfruYwakxStVh8R+PssccDpxZr+5WPKCIhhVEzzQ+hEoVpM9oAnsBP0lOPJzGpmVztdj+Kp476YPxhZ0MLZSS37+/bIZ7E6i+7LjptH8PK6KP+sQzoyr3KOKos7v8BiGU+Ufu7ceYNPXdXVrDx3tElYsHacp5w29K5HirqQz6rmPN+rdNsxlodaVxeeNoC56zZZ6478psFuHpQ7GD0+IEUpkSYjaO60K34QU6EtC4Zh+3CPqc/IPyJ+NMnpaCpGdfR+sulZnKqW+Oqq+sgMN3JGF3Te/60evZPNQRCJI/zd4bHjoNhSWNZ+lTCtj5s458/s8Ms6eUlNvhvAev/8fcqOLvmb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 10:29=E2=80=AFAM Lorenzo Stoakes <ljs@kernel.org> w=
rote:
>
> On Mon, Jun 22, 2026 at 10:01:38AM +0000, Brendan Jackman wrote:
> > This is logically mm code. Moving to mm/ allows access to mm/internal.h
> >
> > Signed-off-by: Brendan Jackman <jackmanb@google.com>
>
> Sorry to be a pain, but I feel that this change should be dealt with sepa=
rately
> perhaps as a pre-requisite to this series.

I know you have an idea for some cleanup. Let's wait for your patch
and then rebase this series over it. In the meantime I'll start
reviewing the rest.

>
> Thanks, Lorenzo
>
> > ---
> >  MAINTAINERS             | 2 +-
> >  lib/Makefile            | 1 -
> >  mm/Makefile             | 1 +
> >  {lib =3D> mm}/alloc_tag.c | 0
> >  4 files changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 65bd4328fe056..5d426b79b8fe7 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16713,7 +16713,7 @@ S:    Maintained
> >  F:   Documentation/mm/allocation-profiling.rst
> >  F:   include/linux/alloc_tag.h
> >  F:   include/linux/pgalloc_tag.h
> > -F:   lib/alloc_tag.c
> > +F:   mm/alloc_tag.c
> >
> >  MEMORY CONTROLLER DRIVERS
> >  M:   Krzysztof Kozlowski <krzk@kernel.org>
> > diff --git a/lib/Makefile b/lib/Makefile
> > index f33a24bf1c19a..44f6538533a97 100644
> > --- a/lib/Makefile
> > +++ b/lib/Makefile
> > @@ -197,7 +197,6 @@ obj-$(CONFIG_OF_RECONFIG_NOTIFIER_ERROR_INJECT) +=
=3D \
> >  obj-$(CONFIG_FUNCTION_ERROR_INJECTION) +=3D error-inject.o
> >
> >  obj-$(CONFIG_CODE_TAGGING) +=3D codetag.o
> > -obj-$(CONFIG_MEM_ALLOC_PROFILING) +=3D alloc_tag.o
> >
> >  lib-$(CONFIG_GENERIC_BUG) +=3D bug.o
> >
> > diff --git a/mm/Makefile b/mm/Makefile
> > index eff9f9e7e061c..4fc713867b9bd 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -147,3 +147,4 @@ obj-$(CONFIG_SHRINKER_DEBUG) +=3D shrinker_debug.o
> >  obj-$(CONFIG_EXECMEM) +=3D execmem.o
> >  obj-$(CONFIG_TMPFS_QUOTA) +=3D shmem_quota.o
> >  obj-$(CONFIG_LAZY_MMU_MODE_KUNIT_TEST) +=3D tests/lazy_mmu_mode_kunit.=
o
> > +obj-$(CONFIG_MEM_ALLOC_PROFILING) +=3D alloc_tag.o
> > diff --git a/lib/alloc_tag.c b/mm/alloc_tag.c
> > similarity index 100%
> > rename from lib/alloc_tag.c
> > rename to mm/alloc_tag.c
> >
> > --
> > 2.54.0
> >

