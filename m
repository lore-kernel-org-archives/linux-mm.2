Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43210606A6E0
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 19:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Tibf8Tid
Received: by kanga.kvack.org (Postfix)
	id 55D5F6B05B1; Fri, 20 Nov 2026 14:24:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50CD16B05B2; Fri, 20 Nov 2026 14:24:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FB7C6B05B3; Fri, 20 Nov 2026 14:24:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 117696B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 14:24:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8E1EA140175
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:30 +0000 (UTC)
X-FDA: 85456473900.27.B31F3F3
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B65640009
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 19:24:28 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Tibf8Tid;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795202668;
	b=3xpkYNF4HX6dc2uIHEXWgROjWDfhjc8HgTP9ocUe+yyKwQjoLJRkBoPA8teksTzEIOeSrS
	GbEvwrl19l4SnEudbRUNjRmKpSMj1eC08+HbkCNHu+02rFvb+dkq21CIflNjY1LnmdN/EU
	c51Cl1WkYt6Y3nnTNkEnQ3zK12CR9nk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795202668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
	b=WZb+6FdggfCHRuM/s0dtlGNNftD56sPgcxekTxx2FA8GdEpjpj+6rRm2kMdzjUXvx8dmth
	SJJe0kHEQSZAMlug+oq+srBACEJR77dxKQxgwoNMWJEBSOJ5R3q5nkq8D0SzUzPZG7KY1/
	aww4u66EynR2b3s4+yxlWG7nfU+1hqs=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Tibf8Tid;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3ada7d53082so14408201fa.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:24:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795202667; cv=none;
        d=google.com; s=arc-20260327;
        b=o81GVwH7rhykJut+neRr+LaE1qC1W4NZuFmXk6Bx3IzCxwZoto54CG+V3FN0dgeUV/
         OcWDeen9NHRC9P58wEeejPbGj3mfVROPb/7oTTh/LLmPdp1C2YGHT68aC3mQ7gyeCoQV
         8Q872FjOccLV/3CTzcX1vfvV7TerERUJX1uJB5W+zHEbMaoOfRb3/k0qULuYcorf+qVS
         TvGpKTMieJpgxBDexYmgNBiHPtciEfkiTPq/+/NSdYHEJB8hY4uTbpiY8PFwv/TDBt8P
         yRjn06WYp13fJIbv8pqe86ywXbaR1uJN6EaFihkJYQT5Z4/d3f/5er12SoFAboYhb4qA
         /Uog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
        fh=3Whf3rosAxiKU7R0P6Yo9DNdTzTNX60GmzvtjYU9dS4=;
        b=VED3YPCtO8Rh7ZokVSSCrmqiLimgdQE7GM++IA1gcysNPKf8WXuhpOh99OEj5LXd3T
         UjTiObdLKH+t7k87VNaGR+lDvJU6WurH12k4/avWVxC0FcDS0oWO7glkqIiYLlU0rEfZ
         RVk+eyy5ZdNV+6i/B305qiewKIzuLvKdfG2nEqol2n8bST20Tf3g3uuy54bDfbUroOFk
         1ZuqVw/nxSUeGQyH8ov8nOgUC1KLBE15kKUqHzNSkFCbIMNHUADgd7kSRF8G37Sa/zVz
         Ogw0YziL+KoAYlo6Z0sHsdSwFsYz9U8uBpNbixohU/i7gtYtTaS68beA6GlBjHCrOogL
         cpXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795202667; x=1795807467; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
        b=Tibf8TidTxOCHNsxZTc8DOiPfs5CTywuPg9Z25UdVJv1HdNwMh77aG48Ir1025jb9d
         riQXv4wWHtV5G33Q/PMdHGsFXCNqxIIOAf15TcCpcoAnfaUP4q+2u/WUOb/JnsUwL5c8
         Rs5AKvYaC/QfnM6wfL/vMLjVnvZKy4Ie+ObsXSsi6lnaqaULCiW8T8uD9HPQZgZ5ZSFR
         0wd1CYr+vhtP6hwCVl/ErA83hVNtPmfjF6NbuuAOIQ2K0OxOMv3FN5o1msd4EY87oJIU
         BZqlB+RWCNBh4eFco5faccTR9f2zf/2r5XwuuI/WlwZRm/oDeYkaONy3QbMo0R7fBb11
         uLSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795202667; x=1795807467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hR7xJF+eh3lU/QGj+8ASNxswZFRyXVh6Oom4tDMt+sM=;
        b=1LnakxhGvESTVmfu94ILs2U7A3AL1st3ZxjnHgFrqyDmMpEnuhRvnrs2PpNSSkRnY+
         ze7aF+oD71ls0Oev4CYjQOilizRMpGlP086lja9u2NMxG9yyxuVa9EXnsaKZZA2bcZdU
         Y50gzLbvJSCgJ6y+qLSYsZWUxMtXKlF/E1rhtNsA/yhNZIv56Sk6pv4gaKrqclLb5/7H
         IlV///WiRtouhjtgv4sOV9SmINFcu/ahu1/ubrcHxTlciMiFcyXBFwdioqkVTJEMbZ0s
         JQe/kdo2r1WKMecewrDGxn7F3XbGW7vnAqMci9iMRQx1M2jJA/vCARa7777dTIV7Sbbe
         lPdw==
X-Forwarded-Encrypted: i=1; AL+hErGVRXtl4v1djc+li9PJsEptR8joKwCHEYxjj+5ReWoQOKnTUiDQxmfdM0xcBMpsnzD8Z/3jYxXt8w==@kvack.org
X-Gm-Message-State: APuU4Z/sAs/e1CZF0vC/oxjXWZsZgxYvCP7nfnEK5Z5s2/TQlnjQnuEw
	ACz289QXWeodYjuaPeX0HOdJr7gE3ULS23A6ViEF0dAD8xUpzrRYFl/xjIPApXA4ACZN/8y0kJc
	T/pQTqSRZvgJRFIimSmYGRcQawr9QYe4=
X-Gm-Gg: AZFdTZcwngVJ/0nFDbYSxK9F1yPHSKExrZyWr27boRYEE2uk19JIwq8iahIVAmpLcIP
	fdCmVwX7w+PCt3m0HOLQuBa4XZgdk5HxnUpzat7iLGZ5aQ4q3ocrZmJrIzm33gnjbErhMfvlwF6
	XvbkxKZsDbnz1D0T+bKpr+slJqGBFEREoK7oMA/ufiZDdtf5wdKyPcuHSr1A+cKsVq1uVHFQLV9
	SqmY8wm0juHsicRu4kPm/JcRe6aZs07Os3K/Xc+LHncuWCQIgCDJ1MuZo7gD6igd/bECdalkx8u
	6lW/0rdodUIUBhMP4h2ijXqB8kUfnjvbYJktM/1n0wRoaQUgODfL2Qcgz1pePZOHkIO69hQ5D45
	QMsfSpOdZLOs222EQqWbRueXo6diYejGGaBJ/MtP+sQwY8WRUW1VLVOjs/n8=
X-Received: by 2002:a05:651c:991:b0:3aa:f4c5:8920 with SMTP id
 38308e7fff4ca-3ae7fb0b5efmr9311671fa.12.1795202666436; Fri, 20 Nov 2026
 11:24:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
 <20261106072412.7909-8-kanchanapsridhar2026@gmail.com> <sashiko-outbox-202713@kernel.org>
In-Reply-To: <sashiko-outbox-202713@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 20 Nov 2026 11:24:12 -0800
X-Gm-Features: Aa3M54oUl6qJ5hZlCYYhmiDiQH5xqNAdQbMYZMdPI76DbB-hbPU55wGtY4uRrEQ
Message-ID: <CACpmpoe44wzBDMdLX=Ryau8uuDYrfNRbGmAvuWF6p6rPc6_zbw@mail.gmail.com>
Subject: Re: [PATCH v3 7/8] mm: zswap: Refactor and optimize
 zswap_store_pages() batch operations.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 8B65640009
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: ajjhwixhrht16rtqgjafezk4t6omj347
X-HE-Tag: 1795202668-250930
X-HE-Meta: U2FsdGVkX1+JEFK58aq2AhjTYRzdZbjBPkbt+TY6MpGcq6G4MWni1ngnxBOlYP9g1U30PfCssb3xwR/uRTMumWeg3S/85jQ1WjXia1KP3jnvEpzgMohHQa/3JfsALCtWIPekSNrSjA1+0kUzwXmMmIdLq7zlZRrHclM0rxaxJ+uPPD7Mra05OpO0hHVmTzup63DWeCIjx86qoHCjliL4DJxaP3dNTFQqpirn7HQfpTiBx0cblymSa+n7I7XtVYHPb0Qh+tn4uF2L8wTnwGkI0ByQejvcMshd+xHQNJqtKXuN1SwKTQGi+Qf2d7L91UrR0Jj6mwjr61MXZN5ATd26kMJCPhe11HIsOOSrAVRHEneVr1EDM7F4U/l6RXCKwUST+DMQbJu/ftUM5vxwAzOXvlcUhKAacxocOQAaTq74qMEExlq+YTtcSmpIQ4ZzJ7LbXLW+W4tbOlBdLPof11TdYRL4vlsrndwwXsJ3rYzOXNX8GtWwwJfp3Ns7W0wRCm7WyDKStLz8iCSBI93K+9jZBuBcnc5x+PLoD+MYigxDoP098ZrxgsufObCMCTfaZUouU6Nu0Ljgl7NrR+cUA6daPkjU8e54mI/n3zVutpRZrp2uhNEwxDM6j6/NKthc3qDogZPc3rQ4Djt+k/vZ7zI1i1VWXA3XrVr818oxnbtP6RmYjIShhHCWIDWWFGmRKWOdDhyoR/b9jvgaz1bxMzIYjxSvIsWMAz+1v/og0KryLZ2dgi7qC56G5aUUVZt7Hc5Of5M0aeBcNN0iez6GVN9QQ0ekqUhbf8cGjERKmiQKnMrljEPu4xIgraz+FiJNbodKoxVuMAP7TsouU5rkgP0p4BmlYVogFgR6BStokR7rXD85Jj3/04NmEzza9N/JihDmGlHz7/GFsi1kwWW0sFdKfFXT5PGxS/7hdMBHzOSZgYx8b86THSjuU0z2FFjGQUbEZ7FmFQ27Tc424Ce1Dnb
 Qbcp1iGN
 BXpyJjumScX/Kmq1UtF9sh+4h5HsriSx8/SC2U/C1RsU88xy2jnvFRFUmDYLfqaFrKtanpLetlDZm0yFPfW9STGjXl/qv6Qo2k6NhCc3b2eBrxySIomg9LiZt5crolJU7tbvj3/Z9dfPo3XHK/LfytTCqllPBbmDT5cjbunETaqB/NTSlkOIFs9SEsX20sq6EfLW5feEONX+Trxw0rXbOz3lGH3gmTtdkwvxaejoLpCDBGbnWGmlw9gT1gVS4mtAcWGTsuUUdJubqI1eplItWVw8qrrGxr7kHtSzu++XKRykvcnM0QGAz8D2rX39tBVmSdnrgpbcjNIHLqPuS1oX41Z9cZTqhsrmy52QcmDXa4+4o+7eOmPajUbZmkPlV9qhtAwG4scbmOezgig2G3Ufl7ng6j3r6L3X63SHHKgO6wNSqpBGGBOxhl0KXAGJbyG5XgSP8M82cYPwZQZXTuJi2Ww5XTOO2I004cb/uBc/qMIfV63luT/D40hMOMAZvmrNNntOTxqDFB0W9bNpdCycX1mpusnE9/Ir3BkWc4JABoVrOoBJIJqC8oMZcKQzyzzLuUADFtZxHeXwW71ldC4rQEo9SbVg1tS126UUcR0wBfcJrDaQMmhmfxruzIilIW/Nbd78f/pdU48pL94/CE5xaV3noSLLiVpFu9WQDKKBhZ/OpxACSeFOI4u+vXTIvy3hDfrDLaC2icRUPboCFwBbmVI0d0oiCmqksfZfJozuhywEBhdU+nVsxFzF02aZkMqBiWXHbK0CWEd1XbTiiXXXXi8Uxlw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 11:25=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 3 potential
> issues to consider:
> - [High] mm: zswap: missing !CONFIG_MEMCG stub for obj_cgroup_get_many()
> - [Low] mm: zswap: unconditional incompressible page stat updates on
>   zero delta
> - [Low] mm: memcontrol: unused and duplicated obj_cgroup_charge_zswap()
> --
>
> commit 55351c710f10c5fbb79d9201d80496dc658bbc19
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Refactor and optimize zswap_store_pages() batch operations.
>
> This commit factors zswap_store_pages() into batch helpers
> zswap_init_entries() and zswap_tree_stores(), and introduces
> obj_cgroup_charge_zswap_many() to charge and account zswap batches at
> once.
>
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index ac6c43ea8c5a6..ab280a448e8c4 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -6368,6 +6368,42 @@ void obj_cgroup_charge_zswap(struct obj_cgroup *=
objcg, size_t size)
> >       rcu_read_unlock();
> >  }
> >
> > +/**
> > + * obj_cgroup_charge_zswap_many - bulk charge compression backend memo=
ry
> > + *                                from compressing a batch of pages.
> > + * @objcg: the object cgroup
> > + * @size: total compressed length of a batch of compressed objects
> > + * @nr_pages: # of pages that were compressed to store in zswap
> > + * @nr_incomp_pages: # of incompressible pages to store in zswap
> > + *
> > + * This forces the charge after obj_cgroup_may_zswap() allowed
> > + * compression and storage in zswap for this cgroup to go ahead.
> > + */
> > +void obj_cgroup_charge_zswap_many(struct obj_cgroup *objcg, size_t siz=
e,
> > +                               u8 nr_pages, u8 nr_incomp_pages)
> > +{
> > +     struct mem_cgroup *memcg;
> > +
> > +     if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> > +             return;
> > +
> > +     if (obj_cgroup_is_root(objcg))
> > +             return;
> > +
> > +     VM_WARN_ON_ONCE(!(current->flags & PF_MEMALLOC));
> > +
> > +     /* PF_MEMALLOC context, charging must succeed */
> > +     if (obj_cgroup_charge(objcg, GFP_KERNEL, size))
> > +             VM_WARN_ON_ONCE(1);
> > +
> > +     rcu_read_lock();
> > +     memcg =3D obj_cgroup_memcg(objcg);
> > +     mod_memcg_state(memcg, MEMCG_ZSWAP_B, size);
> > +     mod_memcg_state(memcg, MEMCG_ZSWAPPED, nr_pages);
> > +     mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, nr_incomp_pages);
> > +     rcu_read_unlock();
> > +}
>
> [Severity: Low]
> Could obj_cgroup_charge_zswap() be removed now that its only caller in
> mm/zswap.c has switched to obj_cgroup_charge_zswap_many(), just as
> zswap_pool_get() was replaced by zswap_pool_get_many()?  Leaving
> obj_cgroup_charge_zswap() in mm/memcontrol.c and include/linux/memcontrol=
.h
> duplicates the charging logic with no remaining callers.

Thanks Sashiko for the code review. I have modified
obj_cgroup_charge_zswap() to call obj_cgroup_charge_zswap_many() to
avoid the charging code duplication.

>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 8c36344000f51..5ef1ae67e67a9 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
>
> [ ... ]
>
> > @@ -1711,17 +1702,86 @@ static bool zswap_store_pages(struct zswap_stor=
e_context *zc,
> >                       zswap_lru_add(entry);
> >       }
> >
> > +     /*
> > +      * Each batch entry is successfully compressed and stored in the =
tree,
> > +      * and further failures will be cleaned up in zswap_store().
> > +      * Next, we do bulk accounting for the batch: grab refs to the po=
ol and
> > +      * objcg, charge zswap memory, increment zswap_stored_pages and
> > +      * zswap_stored_incompressible_pages. The opposite actions will b=
e
> > +      * performed by zswap_entry_free() when the entry is removed from=
 the
> > +      * tree.
> > +      */
> > +     zswap_pool_get_many(pool, zc->nr_pages);
> > +     if (objcg) {
> > +             obj_cgroup_get_many(objcg, zc->nr_pages);
>
> [Severity: High]
> Does calling obj_cgroup_get_many() here break the build when CONFIG_ZSWAP=
=3Dy
> and CONFIG_MEMCG=3Dn?
>
> include/linux/memcontrol.h only defines obj_cgroup_get_many() inside the
> #ifdef CONFIG_MEMCG block, while the #else section only provides stubs fo=
r
> obj_cgroup_get() and obj_cgroup_put().

Added a stub for obj_cgroup_get_many() in the #else section.

>
> > +             obj_cgroup_charge_zswap_many(objcg, total_batch_comp_leng=
th,
> > +                                          zc->nr_pages, nr_incomp);
> > +     }
> > +     atomic_long_add(zc->nr_pages, &zswap_stored_pages);
> > +     atomic_long_add(nr_incomp, &zswap_stored_incompressible_pages);
>
> [Severity: Low]
> Should the incompressible page updates here and in
> obj_cgroup_charge_zswap_many() be skipped when nr_incomp is 0?
>
> In the common case where all pages in the batch are compressible,
> atomic_long_add(0, &zswap_stored_incompressible_pages) still performs an
> atomic read-modify-write on the shared global counter, and
> mod_memcg_state(memcg, MEMCG_ZSWAP_INCOMP, 0) still runs get_cpu(), updat=
es
> per-CPU stats by 0, and fires trace_mod_memcg_state() with val =3D=3D 0.
>

Good point. I have modified this such that if nr_incomp is 0, we skip
the incompressible page updates.


> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106072412.79=
09-1-kanchanapsridhar2026@gmail.com?part=3D7

