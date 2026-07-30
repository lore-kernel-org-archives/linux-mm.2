Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 680D5C55165
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 13:11:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30DE26B0098; Thu, 30 Jul 2026 09:11:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2BED56B0099; Thu, 30 Jul 2026 09:11:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ADDB6B009B; Thu, 30 Jul 2026 09:11:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E2BD26B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:11:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7F0CFA0136
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:11:55 +0000 (UTC)
X-FDA: 85045480590.04.ED1D9C8
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7E0E6180004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 13:11:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=It2kbs4S;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785417113;
	b=s5W26EILNtgZss2MQeQ05mm6yPyyEPzZZU+Nna34jgtrorq6jx+9cSAJXXvwRijCT7XTE3
	SNrrW7OTlSAs9lVhf2uO7YMpK5tNbD+PYfE3uywQYXtYGrXmp0Pd7+z2L0ZIlZ3FooDtrJ
	ulVYOXbF0ZMKzMIfLy5pP/QD6eL8k+g=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=It2kbs4S;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf06.hostedemail.com: domain of yiannis.nikolakop@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=yiannis.nikolakop@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785417113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZxWQFrq5yQB1yLfY/DlKbs1Vg/HpnWd2qZlXhsqsB4=;
	b=62rUuQy+dIVaouLkilMVgaWp9Chh4JTBG0ttc8E6/VVYqeXRTRFJX8Xw5eOVsSKWnwwPaR
	7wqX7q62Sp7aPSSo1wnlGdH+M0zJBiQOmfgF9GtoUVge6ZXk1GWzzV2zFOmAOoHqMphzGP
	RYwZEpNV48oe53PpaG4H7W4vniWCc/c=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495635a85d2so17013185e9.0
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 06:11:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785417112; cv=none;
        d=google.com; s=arc-20260327;
        b=Dyzoy+Z1jNDBYh6DVa0FRGTZaD99Y3nsbvO4UMAOLeHIRHlY48PAN2vTqk97zQ/xX0
         6mis5KDlg0tVe1KSOqDojmo5JKtvYM6B/y+Dj1645ByUFxSAN/I6PQd51M8j7dGt2urM
         W4MMn9LRs6UdwenNoX4EqeySBzjb1XDHEZaCLJE7MpEcr9qKu9p/RmHG7MGp+2ANE7IQ
         JXQSDtb0g/vE2Ls2wjJfFzjkfbvQ9Cf44Pf749RACLpFwi5EPmsmBpAE+hcqMei2GW9V
         ztWKiou6ptd/2529q7tz3+6kW+jTMgeGUuWO/+h+YW98vypBjvdBaMJ57gR0HqoavMmn
         A5UA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JZxWQFrq5yQB1yLfY/DlKbs1Vg/HpnWd2qZlXhsqsB4=;
        fh=Dwemh4vfVn6f7mLSsuP4CD/euqwyy9490gPCNBAkma8=;
        b=BAXX1kJ0WZZkt62rSijhvvodaJNNoDb6pCqVNNFRV9idPbbDekNJKdePF0Lj6ZBkuj
         Ievu/v4qcObRF7kCwusQKo2KDQ/nq2IMS2P12zXZfBpJGqNcRGft27OozRni1VCnnNVJ
         kFMfUmf7+0Y/k3L1J8Z74Q6ZbucDu3/1St+pG9FGn5r67VBkdUYVniEpO5xdGLBU9DeW
         dn5OYHDpKeTtgEoya7BofIORpxjsOprE1IcOSVz/2tmbAwPffMOOTCcaeGxP4WCFi5+z
         kUDUU5HujeEHT+PAkzj3O07uvhZB0VfT3u3me+VQAKu+gl8C1IFJZgZhAHWMUF5NEoLi
         j6gA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785417112; x=1786021912; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JZxWQFrq5yQB1yLfY/DlKbs1Vg/HpnWd2qZlXhsqsB4=;
        b=It2kbs4Sr2B1xkVvPbKFpCOjeg5iR3g0PhYAWZjbvkwbFj0cECE4ytX7ROBrJtNX4g
         ketwleymfBbAzoGQHL3tvYE0B57aq58I0Gsm2PJsYH/outctFmQROWTAEOce6KfLYNfR
         iSvGIIwwdLRnYYTQ+663OCXIIgQyKgNyvmHc6n90Xb2fLU5M2lARO1L7dMLfqCZszSLR
         rX2hTODlbBx2wCfpm0Sm6cL4ckpr3VoUm38nRqbX8LE8QBg/qlASwOMykS8AcDQYF5QH
         /wdysoky1tRNMPlTyVk1yCkTGoli8GSXeLpZcIlgBtJJdkTr+UussgHHrPXjRrqNBht8
         JiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785417112; x=1786021912;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JZxWQFrq5yQB1yLfY/DlKbs1Vg/HpnWd2qZlXhsqsB4=;
        b=dHRHQA9NK9pJIcjRvyy46iD/HwOZdSH2KmBUvBnzade3EDLs6Dd6l949Z5T7xWSN/n
         S7Ve6O9zf1fyp8qjX3dCIRuNdfOC37Z3mbM0IbVE+nqwNyzJKLkv4HLWnzEQQ5BZjxdv
         H7DF86msKrai0a+QgQAH2TWecuHiH6+qMD6B3gnJONFRtMaQz9zW4B88NZ0L7GRlE4ot
         oM1OicO+XDrTheDRS/wCkt3Fo6C3frUNErblDBySZQlldeEzflV9Y4P0Vo6zxcEDrEqi
         71UwhT01JUjvmuM5BCiiUViAv0QP6OXVb6xv4vhUOHjW+nJWGeRQaE2jbzrBAhfSXpPc
         Ms9A==
X-Forwarded-Encrypted: i=1; AHgh+Rr2FyjblJ8cQ4N8YPmQ8Hi2u4lPIF2jpHFtRjBqpavWTFHOWfQOA39+QEAyMcf1uuwwTTA0yJiZvg==@kvack.org
X-Gm-Message-State: AOJu0Yx30cLRgl7oCPpdP5yQLtz3TtcP2tIzDqTiP/3ItrILezQ/X67X
	dggTFjiPvWmi1TnE9U5J4I1VE4q9s4gWTUOwVYO7D90kPmaFbCyfcnS7no8gcVKwacOvPewqDs6
	XHRYXwzl7wTBMLH/2KaFkXvzog3XGXg8=
X-Gm-Gg: AR+sD10Qr2A0f2l+RXpOEvIV4dHT6TYkdJeAJvph2QXF/yHm4DorJTyj4qPTST2cZJ0
	Gr3NadDNbFGmqab42lEKf8FcuMosIq2bh7fk7ymhP3T8I5eHIPGup4OK4T0QXm6pnt0Y7eF5RZ4
	u8E4cyDsepdBULI2HvzcGtotwwVBdIS7be1pvQFGsDUBuxBL4p5EkDl1GKeDXhSk17T/HZiikPZ
	c6DEpBtNssw0h7e3apSinz9etUwBxb8H762g3ltpZAslIVe0MqqIYYbojWb3cWQfLzQOEVlM+jf
	7+8cz/M6HsXj8RTD581xLNBwZkzKj8Us11isVERvExiQ
X-Received: by 2002:a05:600c:8707:b0:493:c182:6b08 with SMTP id
 5b1f17b1804b1-49800ed12f2mr35808775e9.36.1785417111834; Thu, 30 Jul 2026
 06:11:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260526-rfc-nt-demote-v1-0-eb9c9422daef@zptcorp.com>
 <20260526-rfc-nt-demote-v1-3-eb9c9422daef@zptcorp.com> <ahW7gwgaF0zIPTAz@gourry-fedora-PF4VCD3F>
In-Reply-To: <ahW7gwgaF0zIPTAz@gourry-fedora-PF4VCD3F>
From: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
Date: Thu, 30 Jul 2026 16:11:38 +0300
X-Gm-Features: AUfX_mwGq9AjTR5NxgyxAqgBeEwNx--Sq9pL4ych9I9IxB6UA5FR819gtzB2mWI
Message-ID: <CAOi6=wQ7CxHf8QMFXm5oyHZFc9n6BQecL45rBud=hMubmayCnA@mail.gmail.com>
Subject: Re: [PATCH RFC 3/3] mm: use non-temporal stores for demotion
To: Gregory Price <gourry@gourry.net>
Cc: Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>, 
	Davidlohr Bueso <dave@stgolabs.net>, Fan Ni <nifan.cxl@gmail.com>, 
	Frank van der Linden <fvdl@google.com>, Jonathan Cameron <jic23@kernel.org>, Raghavendra K T <rkodsara@amd.com>, 
	"Rao, Bharata Bhasker" <bharata@amd.com>, SeongJae Park <sj@kernel.org>, Wei Xu <weixugc@google.com>, 
	Xuezheng Chu <xuezhengchu@huawei.com>, Yiannis Nikolakopoulos <yiannis@zptcorp.com>, dimitrios@palyvos.net, 
	Ryan Roberts <ryan.roberts@arm.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-nfs@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	Alirad Malek <alirad.malek@zptcorp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7E0E6180004
X-Stat-Signature: 39zay183mq8f4f3omyditqrua6ddmpbd
X-Rspam-User: 
X-HE-Tag: 1785417113-832537
X-HE-Meta: U2FsdGVkX1/63vUPOMKbhIxn5KWEPXK22U5+Ve7oFD8G04acIBRX4rWAlvSJ5JW6gWvEn1NW02qBkfdG+qb6fcdhcYLBoRkIlTARC8dqFK8jFnKIZLzZfJH1hrBkmfZ2+b487sLNXXLxswx7oLbNg6jV8CJGCbA+a6Kgofvgb5M1GHjXqzypTv4/67ZShckG/nttcvFUrCi+2BP8ioGKVs+zWFE9jx09PJhXyAYSrpQDIlErdCoZmYEkdoo4J9KTeJkY9DM0G4mY0BT77bg0Fj3Vtdq4Eq6q23YIpWGThUSAWtqore4l+KpNeQamhILE/AiaFq8KiR0fvzg3GQyS/5THTBDpnfdMKXjcxW3ZTbFH0Z8hap+4BKNrLafQg1kIKskmMzSuU0mwdg1aDSV0pLOum1tOoJgBeGOWvyOzBBF8c53itu9NzyUcTmR/7933H94LXYrvRggAEq7vIaJtWtv1tzILR21Z47RbfqcfHKw6cF2DpzJSf4BpiytngkJedXz6c/c6eYqJHnasTWVZ7KloYtjWjYbpyCBhntq086EGw82fT3HA61utLdVf7aPP9+1aQk4K68RHOdA8D4CiUMS4R+f01Q7UCVZZ3Rm6BDLsaNJXCQrrvzlWMjUUa/CRzhWFGlXplOGoJ5vSjwsZ3hw1TMOPn6LB78Vt2pmKNvcOkfz8DdhdWJ5ZGO2APi2ZzQAI/UOzMuWjXu+l5SOISrzvhfeW6wQ5qNJYtA6vIctbl2vSwE86e/EctbNR8KHAg2mudmRtd7vDhrEGEyEzkECBk81p3EgUlYOHGGT4Yn3LerfpiXfwWVeWjGmi4Xrp6tFq9d416D+Dx3PuJAji+I198PEs8LCu/WD2ymVMwicqIs4j0/GKyNuvyUGB2qhUtMu9Dez4fDGtttQnhgWP9doVkA3+wYa1HRvONez38gL4JGL4xKw7UjoxsglnWZqry02aKOkw0dTmrlxTpIT
 NprQ0VPW
 QwDmDniOp8/H8Lns30cBMliRX4itr3O4zVFLJEt0QVWjWGIqP9bWus2UJxhJNJGgZoWqBfKcEkx7uJ2t2WZcGwGMS5gOpB3uvpGQi7s82m3wnRdZDoNpp+i29uRVbAVjLK2SOBXW2VFldxiuzOQsTg6dJUi2uMJrRnjNUlawf7qWVWYmVDN86koiOYjlE4I+Jngr9xjaTiR4caf8+iCYdGZEG3Dh+ZjOA+UQpfV6jBN3fLFKoKvdLU6TmOlyTkjNTIsOrRHHPr2L6f1GlA7yG2u4hHA6Q9wKyDMhvOFpFbj7H1IrjTIag9da5Nvv2claa0Oq5c9uqEcJINJWQUXkaPF3QC5W6Zv96AvTvSq+OYD2wowGLoOneO32WQ0cOrlb+S5z33AgHH179zO8W7M08fmC8fgVYybcKIsLnJuZi13OEpNsTOs/OoX4k9BPIQpUJkc72BMCD81AbKKouidetgncvAcY+BRt0ueMStfeOaYVu2Al/JNVoM8YmvQGtOmpkDHgJjxQdlV+aO9TtJYUy0ahmzWvGtQUJqzP0B8UyjIHWhMuNYxZz21+r2mDdRqu+VsKSUpUCigR2jX0WB6yPRa6z//f+7cEafkLTtKpJY+tpnZWLOityEpqaYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 6:25=E2=80=AFPM Gregory Price <gourry@gourry.net> w=
rote:
>
> On Tue, May 26, 2026 at 01:37:04PM +0200, Yiannis Nikolakopoulos wrote:
> > From: Alirad Malek <alirad.malek@zptcorp.com>
> >
> > Memory demoted to a lower tier is assumed to be cold and most likely ou=
t of
> > the CPU's last level cache. Additionally, in certain demotion targets (=
e.g.
> > CXL devices with compressed memory) the bandwidth can be negatively
> > impacted by the eviction patterns of the last level cache when standard
> > memcpy is used. When the feature is enabled, use the
> > MIGRATE_ASYNC_NON_TEMPORAL_STORES flag in demotions to trigger the foli=
o
> > copy path using non-temporal stores.
> >
> > Signed-off-by: Alirad Malek <alirad.malek@zptcorp.com>
> > Co-developed-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
> > Signed-off-by: Yiannis Nikolakopoulos <yiannis.nikolakop@gmail.com>
> > ---
> >  mm/Kconfig   | 8 ++++++++
> >  mm/migrate.c | 9 ++++++++-
> >  2 files changed, 16 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index ebd8ea353687..4b7a75b57f6e 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -645,6 +645,14 @@ config MIGRATION
> >         pages as migration can relocate pages to satisfy a huge page
> >         allocation instead of reclaiming.
> >
> > +config DEMOTION_WITH_NON_TEMPORAL_STORES
> > +     bool "Use non-temporal stores for demotion"
> > +     default n
> > +     depends on MIGRATION
> > +     help
> > +       Enable non-temporal stores when migrating pages due to demotion=
.
> > +       If disabled, demotion uses regular migration copy paths.
> > +
>
> Do we actually need this config flag or should we just default to this
> (if the arch supports NT stores)?
As discussed in the sync call, I was just being defensive :).
In fact the non-temporal instructions should be in all x86_64 afaict.
So I've removed this in the next version (landing soon).

/Yiannis
>
> >  config DEVICE_MIGRATION
> >       def_bool MIGRATION && ZONE_DEVICE
> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index ff6cf50e7b0b..368d40dc8772 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -862,7 +862,10 @@ static int __migrate_folio(struct address_space *m=
apping, struct folio *dst,
> >       if (folio_ref_count(src) !=3D expected_count)
> >               return -EAGAIN;
> >
> > -     rc =3D folio_mc_copy(dst, src);
> > +     if (mode =3D=3D MIGRATE_ASYNC_NON_TEMPORAL_STORES)
> > +             rc =3D folio_mc_copy_nt(dst, src);
> > +     else
> > +             rc =3D folio_mc_copy(dst, src);
> >       if (unlikely(rc))
> >               return rc;
> >
> > @@ -2081,6 +2084,10 @@ int migrate_pages(struct list_head *from, new_fo=
lio_t get_new_folio,
> >       LIST_HEAD(split_folios);
> >       struct migrate_pages_stats stats;
> >
> > +     if (IS_ENABLED(CONFIG_DEMOTION_WITH_NON_TEMPORAL_STORES) &&
> > +             reason =3D=3D MR_DEMOTION && mode =3D=3D MIGRATE_ASYNC)
> > +             mode =3D MIGRATE_ASYNC_NON_TEMPORAL_STORES;
> > +
> >       trace_mm_migrate_pages_start(mode, reason);
> >
> >       memset(&stats, 0, sizeof(stats));
> >
> > --
> > 2.43.0
> >

