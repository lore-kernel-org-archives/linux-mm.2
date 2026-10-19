Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B52CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 07:41:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD4466B00CB; Mon, 19 Oct 2026 03:41:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84CA6B0168; Mon, 19 Oct 2026 03:41:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4BFF6B016A; Mon, 19 Oct 2026 03:41:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7F2A46B00CB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 03:41:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E39881405C3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:41:11 +0000 (UTC)
X-FDA: 85338579942.16.AED3D0C
Received: from mail-yx1-f47.google.com (mail-yx1-f47.google.com [74.125.224.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01D5D14000B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:41:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nOR73INO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792395670;
	b=E8Uw3j4ad1Nzk5WLxPmT50uRZkiCRgTZRtBP10D40OnTiuqNMyo0VmpCBnwYr07OJVrKSd
	Oe4K3n0pV3p2zodTxbIMP4u3DgULKxaktuchoE22QcNZXP5P/q+Rv4NcvLu/jwFgPxuZWJ
	hLhYB71XqPUQSONjiQfvQMm7WFmZQdA=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nOR73INO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.224.47 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792395670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KpPZjaMDJls8EZkE/6oJfht+hbPc5JiwcvTAxpT7o3k=;
	b=485ctBbQuqexj/5Rg6/GXXamJJTMWgctbWczMF0WX6d5a68HZJWZjQcLXYzivvZL6h6wPb
	geb5V5xYu9cPcrfUaxn4EjFdmdY9H1ggShmo60WUgAgX7Vu9nxsl+3/JmZQni015V5h63x
	9PPRecpsa5QwSD0tmRiB8fqG0NHjZQk=
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-67921b515a7so1874780d50.2
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:41:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792395669; cv=none;
        d=google.com; s=arc-20260327;
        b=ACBNUip2xhcKudOLZiWzxi+GcXB8Y3bfLUGMMyR/CCRAL+o9B6wIX/v2OyJ8gDcwkq
         Q7Pet7JkXfjU6IN7CdUibf0t1RLYZstePWAQ7+LbIVrT7b91R1OHLpRtCeUBRrWMI2IF
         S8gGAz356HqQhGoWP7qqlWQB5LufniLNVlV8XOPGz33+dbFGltkhxqCKTK9dYqQNXP7H
         DHGcFfBQW9cp0iHf9TEyW4O7trVigNDAAvMxVUxjQGOh7LOGZqXWFFuAQ9/ddSdTO4Uv
         ueJopGlYzAwSkq0JF4LwMtmCKS7OEp+8c5e7AGY5Z9gfCirMXmtFqr7DCZEXWTr3gHL8
         EzCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KpPZjaMDJls8EZkE/6oJfht+hbPc5JiwcvTAxpT7o3k=;
        fh=ifu9WfluMVoWpm1ez15uoVxVJLHajgLSytug/c0yY6o=;
        b=JOsgPTJQxPP3pQjbxeIq1+I6oq4nVjDcGnH7iUTAztHNoNTiKieTDRaL0FOmsdiLek
         XTVm2N6jLpUBT3Iyo7zk1RlNVDZM2lCJ+Hy3eLF9BEhJQKOU1zyar44z1OEyPBNrfen4
         9p6ahOLxpVAIQzs+MTX5yodqoP/Vz3EkOdYGCu2mmkIMYIwMW/ZoFnnBTWncSqLrWtlA
         WlseZJPz1xKQQCD41qxXULmg9PN8m2JimPY62BRU27Br4pQw7cOCuHfXn9OQZfMena6t
         iV5hh2ErCDmUteaXZEmHQoO9Lszw4EukmzvATwur4NMdmFBhOVGwecuD2iH3c+1+OGHM
         RBRg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792395669; x=1793000469; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KpPZjaMDJls8EZkE/6oJfht+hbPc5JiwcvTAxpT7o3k=;
        b=nOR73INONBANUZYauTrYkQbl6g7dIPLp/j8pYpSs8Yzw+dX3antreuAzI2grhOAMjL
         tm6wS+u8oQhTOSlx2tqwyQxML4l/Momvh+pwT+9uvAQtv8wqGBcR3LXV1wgNDu+as+ii
         V6LKQj4gOY7Ua6gUsJds1/ZWm4yqOr8seE/mL58bMnhNdhS9VRKLNt9v3M9TNrg+Z9Km
         hwV9KVtE5XrR/Xe8EaD0DXsuJwpURc4dpOybV+EHrpXKAbdBIpjoHt5coq95sbRa/zyA
         ApolYa6YQW3FMey7xAG7TJWWEwYFrS4Mnlw/Wqh08/INf8Fb6bCKmly4K3VFrmnRlEBo
         2iKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792395669; x=1793000469;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KpPZjaMDJls8EZkE/6oJfht+hbPc5JiwcvTAxpT7o3k=;
        b=rGcCM9IMEcI800Jr3b9f4rS60vXGDlviwYLqBRa+tisfiE57loSNm1jFp7VVGwsimb
         glKGgnC5MsmfVLu/63ZMUk9RNvtUsksFHoOXqg0px+mY74FxHj3czB2qF8ezNTb8qTvz
         rgW8aGEP8ryd5IVYYh9fJmFMkUms9xxvjMfX8D+dqUxpHTcfPjPOTwB991IPan+/awp3
         XkI74mIEHbWkpTiMiO7GAAmfgbvrO7iRaM+7f0vgbBYd8BLUbte+wPzGQ5Pe/ATFPVJy
         VPPo79lkc2Ejz4mRFbUxnhJq88EJEC+m7n39uoKwXcLHMnpfC8+FEcatyzyp/96NuRUo
         u+ug==
X-Forwarded-Encrypted: i=1; AKwUvBxF5fqiKbyhgkTrLv3z5MXBxK2F+Vm6Yc61IrZKQ83mJRCL8vn7yYQur08OOWXNBIj1ldylI/ch8w==@kvack.org
X-Gm-Message-State: AFq9FYKiz7a8ttiMjCS0mgEWDQteNmJOx2eGc7C6UdE4j0Z5VyaeG0lm
	YaTqN688dF9UdrtlY8JfDozgmaGUmT+x7cR3oJAWIu8EMnygSfZa/1Inv+j6ymzsbQqHoQ4wQuk
	xfRzyaNk5FZcigvH+vMELZ7oPEzszTwg=
X-Gm-Gg: AYBFou1DCYC306pNuCxRw2ixV0ADIMX5ryFg9EBCkDF8qr7IO48EISjUPXKc5MOvDhK
	z2CVmQr22lknDwu7T7mgkHcoUK/Ech5HX5hSKRtDiLCaAY9YsVO1Wi+TL9sxmIXj4h1cT93Bhmk
	0AsgRboF7cBSbPERBb5ATA0V8Q/TJkzDmR75hxCP6E4UalpCVZhdq0XLY+40K85fM+sWdq0P6YR
	c3Yt8suq4U1vM2JlBN3CFdxZMFfPPNCOYgkIdcsuALtkiJ0G9hpjBPxLmsAUdn6Tra/qPXFHh3I
	SlujUYsnPhm4SR/HFYmmGlkFwHgQqdXBQF5gwyOl/VElqlmK8DEqBLUbPYakH70v9s3MkBxaFO5
	7ScB2EEvaSA==
X-Received: by 2002:a05:690e:4181:b0:679:938d:a5e1 with SMTP id
 956f58d0204a3-679ca9152camr1672832d50.106.1792395668941; Mon, 19 Oct 2026
 00:41:08 -0700 (PDT)
MIME-Version: 1.0
References: <20261019064157.29885-1-laoar.shao@gmail.com> <20261019064157.29885-5-laoar.shao@gmail.com>
 <sashiko-outbox-176727@kernel.org>
In-Reply-To: <sashiko-outbox-176727@kernel.org>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Mon, 19 Oct 2026 15:40:28 +0800
X-Gm-Features: AclHuK87RnG2er9Q0sMuCWVVDHgxTVssGIXLDngoxhqch9KZMv8DKOFsSe8QrYs
Message-ID: <CALOAHbA9XCM=5AKz=MMCRcx79_E44rBNUZQi_c68tZQ1iYoxhA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 bpf-next 4/5] sched: add BPF-based per-cgroup NUMA
 balancing mode selection
To: sashiko-reviews@lists.linux.dev
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, 
	memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, 
	juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, tj@kernel.org, hannes@cmpxchg.org, 
	mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, 
	yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, 
	lizhe.67@bytedance.com, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 01D5D14000B
X-Stat-Signature: mc387kez864upzt7tdy55zaf98cd74zd
X-HE-Tag: 1792395669-320269
X-HE-Meta: U2FsdGVkX19Z0RCViAW6qju07kS1Qf4wtAfhv/I5HGetbrGZuRvDR8Wrf+KjgKHw/MLhZv7ZCRxknwj/427UTmXt4fUpSR7QAVb8S5yGumdjXqrR168CiHsZNf1axujO8xXn/isJfXf1yqQscoeXoX7Hdcvjj4q7/nSDn+4WXmFu7gFWhQ6ETNtLoUECicv73KJnrdJPw9NPA9l7Y0+jFgSDjXDc59UrhKstEIfxk2G6aTsBFHIwAVxtO/IaU5xa5UfdVfaEtzqlZLQg03Pl6ZGtsJg3IfvcJU7S2v1afcCXv2LRL+d91RNAyttVaNVg7VsNhFPWycxnEzUCs4JZyGGA3/F947iEZRDAx81t3Zuf7GDwZxpwgBTtgrQCKdpAd4KxqWpFxEsRV0TfhEw7KC+YcfV3uund48Tht6Ll0w+zv6H4n/N4BDCbQvmjWEg4fkocQrU2q6ihPRdOPLeGQSZdhuWhIFlZbH6PCbr7cFVX1N/O6Xo4FR8itI3baPeUGz34CMCLN6Up+RpjDQ29ZPAq3gCaRPkoshGNUDLQOy9bJeqaqi0W+hsoZ6sWzuDg+q4eoVpf0yLl+3QrDqPe67ifKO5ZXcjqrkYiYcjCmz7UIl5oAnPSXc5yXoUyyVmDYPUddfe/3qQJSOxdyT98PNXlhe5x7iALUMX037mhRNqqvnqPUipPKqbaiRx8fy7ASdUwZjgkEHP7CRDkDx5lD4VR6KMHVPBlu4LsbN4FumW/Z6Q4Cobwak0dmej19JS0pZgi/cjw1xB2YG/7nz6H057PZ4wWv9zY5oKxmDHi3ZpXkGAW97krspAQr/GmPbCeKhgFAqQVZ6K9EqlyfHh5MbBn58Cb3MXlF8a1hsLq6BNw4h8wAk2//idvR8etWAPHd4oQg03vCczUyEP2x5CmTvewSBp7fRdBV7ZnInkXnUeDaRi/SGaKxIkCAPgrdQwsLBs747uvc/DqMDrSlS/
 XRX6py/6
 UHKilGy3Ph/tTB5kLfPDkCFi3a7NYPD8jKcdEFnV1L7YCGNssL8ZmNUUcI3JNcQhctuRIaaeunidm49dtTGKv8ovV3c6eVLXxlsTfQMtutPJVp+CXa6nOvBrTH6Sj+XSc5we0+CFYX+tRuh4P7htcWipZvv3ruFA9tyhoZQ94SWWlpvFcDKcH77APsOKwJHNRIiIoqLn2YgaDAcqURUSZrNWWfjven9S/m2+62I9fLXBBaE3zezJlabjNacX94r4SVXgDIkIPhDD2eRjFOozBtqATjcDkUEiWfNKl/+L5BL71NQ+NGV0cDTvW7W2DlPw4ccQoldjfDYoiR+my/GY3RqUwjlFmqby3c4sSJRsWIh18QlQGtQYOzeqqarTXVCDwYLjpX/jVHzJpcZlqlr9+QWMflTyghGLmYJ9BotEYF3zcVI9m0D9d+6qXfiMeuj1rZsIAS6/keFgkhm0A8RRQz6cCop8gtZz8/5Sy6kidXwV2Hh4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 2:58=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [Critical] mm: use-after-free on source folio in migrate_misplaced_foli=
o()
> --
>
> commit 5de3ed8c82d3030544f5f025b8ae47dd8339bfeb
> Author: Yafang Shao <laoar.shao@gmail.com>
>
> sched: add BPF-based per-cgroup NUMA balancing mode selection
>
> This commit introduces per-cgroup NUMA balancing mode selection managed v=
ia
> the bpf_numab_set_mode() and bpf_numab_get_mode() kfuncs. Hot paths combi=
ne
> requests along the task or folio's memcg cgroup hierarchy behind the
> numab_cgroup_mode_set static key to override the global sysctl setting.
>
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index 211c29bd2a283..c0692c7b27467 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
>
> [ ... ]
>
> > @@ -2770,7 +2770,7 @@ int migrate_misplaced_folio(struct folio *folio, =
int node)
> >       if (nr_succeeded) {
> >               count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
> >               count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded=
);
> > -             if ((numab_in_tiering_mode())
> > +             if (folio_numab_in_tiering_mode(folio)
> >                   && !node_is_toptier(folio_nid(folio))
> >                   && node_is_toptier(node))
> >                       mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS, nr_su=
cceeded);
>
> [Severity: Critical]
> Has the source folio already been uncharged and freed by the time
> migrate_misplaced_folio() calls folio_numab_in_tiering_mode(folio) here?
>
> Before calling migrate_pages(), migrate_misplaced_folio() snapshots the
> folio's memcg because migration transfers the charge and releases the
> isolation reference on the source folio:
>
> migrate_misplaced_folio()
>   memcg =3D get_mem_cgroup_from_folio(folio);
>   migrate_pages()
>     migrate_pages_batch()
>       migrate_folios_move()
>         migrate_folio_move()
>           move_to_new_folio()
>             folio_migrate_flags()
>               mem_cgroup_migrate()
>                 old->memcg_data =3D 0;
>           migrate_folio_done()
>             folio_put(src);
>
> When nr_succeeded is non-zero, calling folio_numab_in_tiering_mode(folio)=
 ->
> folio_numab_mode(folio) -> folio_memcg(folio) -> folio_objcg(folio) reads
> folio->memcg_data on the freed source folio:
>
> static inline struct obj_cgroup *folio_objcg(const struct folio *folio)
> {
>         unsigned long memcg_data =3D folio->memcg_data;
>
>         VM_BUG_ON_FOLIO(folio_test_slab(folio), folio);
>         VM_BUG_ON_FOLIO(memcg_data & MEMCG_DATA_OBJEXTS, folio);
>
>         return (struct obj_cgroup *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
> }
>
> If the freed page has not been reallocated yet, folio->memcg_data is 0, s=
o
> folio_memcg(folio) returns NULL and folio_numab_mode(folio) falls back to
> NUMAB_FOLLOW_SYSTEM rather than using the owner cgroup's tiering mode for
> PGPROMOTE_SUCCESS accounting.
>
> If another CPU reallocates the freed page before this check runs (for exa=
mple
> as a slab page setting PG_slab and MEMCG_DATA_OBJEXTS, or as a compound t=
ail
> page), can folio_objcg(folio) trigger VM_BUG_ON_FOLIO() or dereference a
> slabobj_ext pointer as a struct obj_cgroup *?
>
> Would it make sense to evaluate folio_numab_in_tiering_mode(folio) before
> migrate_pages(), or derive the mode from the already-pinned memcg pointer=
?

Nice catch. The check has to run before migrate_pages().

diff --git a/mm/migrate.c b/mm/migrate.c
index 4b87d465c5fd..84f224c42ab2 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2761,6 +2761,7 @@ int migrate_misplaced_folio(struct folio *folio, int =
node)
        LIST_HEAD(migratepages);
        struct mem_cgroup *memcg =3D get_mem_cgroup_from_folio(folio);
        struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
+       bool folio_tiering =3D folio_numab_in_tiering_mode(folio);

        list_add(&folio->lru, &migratepages);
        nr_remaining =3D migrate_pages(&migratepages, alloc_misplaced_dst_f=
olio,
@@ -2771,7 +2772,7 @@ int migrate_misplaced_folio(struct folio *folio, int =
node)
        if (nr_succeeded) {
                count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
                count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
-               if (folio_numab_in_tiering_mode(folio)
+               if (folio_tiering
                    && !node_is_toptier(folio_nid(folio))
                    && node_is_toptier(node))
                        mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS,
nr_succeeded);


BTW, the folio_nid(folio) next to it has the same problem: after a
successful migration the source folio is uncharged and its isolation
reference dropped, so it may already be back in the allocator, and
a reallocated page's flags give a wrong nid. That one predates this
series (it goes back to e39bb6be9f2b), so I will fix it separately:

diff --git a/mm/migrate.c b/mm/migrate.c
index 15b45832bcfa..685c06a472ea 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2760,6 +2760,7 @@ int migrate_misplaced_folio(struct folio *folio, int =
node)
        LIST_HEAD(migratepages);
        struct mem_cgroup *memcg =3D get_mem_cgroup_from_folio(folio);
        struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
+       int src_nid =3D folio_nid(folio);

        list_add(&folio->lru, &migratepages);
        nr_remaining =3D migrate_pages(&migratepages, alloc_misplaced_dst_f=
olio,
@@ -2771,7 +2772,7 @@ int migrate_misplaced_folio(struct folio *folio, int =
node)
                count_vm_numa_events(NUMA_PAGE_MIGRATE, nr_succeeded);
                count_memcg_events(memcg, NUMA_PAGE_MIGRATE, nr_succeeded);
                if ((sysctl_numa_balancing_mode & NUMA_BALANCING_MEMORY_TIE=
RING)
-                   && !node_is_toptier(folio_nid(folio))
+                   && !node_is_toptier(src_node))
                    && node_is_toptier(node))
                        mod_lruvec_state(lruvec, PGPROMOTE_SUCCESS,
nr_succeeded);
        }

Pls correct me if I'm wrong.

--=20
Regards
Yafang

