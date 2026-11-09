Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE500606EE8B
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:54:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=gZY0e2YU
Received: by kanga.kvack.org (Postfix)
	id 015B26B05B0; Mon,  9 Nov 2026 11:54:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2FC76B05B1; Mon,  9 Nov 2026 11:54:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E45BB6B05B2; Mon,  9 Nov 2026 11:54:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B724F6B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:54:14 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38FF84073A
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:54:14 +0000 (UTC)
X-FDA: 85416178428.22.CF0879E
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf01.hostedemail.com (Postfix) with ESMTP id 51D744000D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:54:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gZY0e2YU;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794243251;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0sf9I/k/98So0/htGcCu4KYBn2oXlMUyb15O6ueVwk4=;
	b=UGlF2I+3iaxFGBwYZEUjNLtQSCANUm90IFV9QH68vBK6F5fp/DRYMRPJYEvPOCtM3bsDVJ
	GaaxfNm1nXeg4bb4XNG46TuXSupt0mptHNqQXZvs+AeaaZ6ReWLv4ELzbz5QxJdrXiRgrf
	No+1HHjuTTEstbRz/dezJ4V1NhbRXOU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794243251;
	b=MmAzDD9iw39F9RlbUinG2VivMx0qUpL7VwU1L4Nr+CHJrEEEPVOt+QqLiGRiCt3zSnccHW
	kfPSsdzlt/0/wS92e0roI61iWz+T4fnDJEDp/08v8E1pIJ7CyDMDNVHdJYAPnuGBuOt1QH
	pTV2YvYCxDR8Q/NSJ/vAH1zJzYuG0Kc=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=gZY0e2YU;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3ace304021eso9497761fa.2
        for <linux-mm@kvack.org>; Mon, 09 Nov 2026 08:54:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794243250; cv=none;
        d=google.com; s=arc-20260327;
        b=SD0mvKCmE2hcABS+Tyc6yoe8UiODfkyj2GLwa5hS4U5IGdQcdw0ss0tN8pEjn9x2+p
         rQBdqk6OQVH3Zcrc803XNVm5bbpE+KCyA4Kz6PC3BJxqWz8odTFHGeGJyikwnEWdH4cO
         upkzNWHnuSqf/Zj4x4rSsgRSG1iEslG1YMhxzbs+rXFLXcFDxiT+QKfne9bPBiHRSroi
         H8OVKKzF6HbPS5fwgjB9C/x0kOAV0Sa5s0Lgrzj0LABarNqZlWhYa4B//5RHl4JNQ1pg
         zer2CMwTqiFao6O4cMmC5yhql839ilcMjwtsK+DZPr1j2nCxRCvgeJ5UJ5lTSeelskWx
         zIdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0sf9I/k/98So0/htGcCu4KYBn2oXlMUyb15O6ueVwk4=;
        fh=p8K2u/9xvPM8sg/03RQSnPAZL6V71H06s/Q+LEWlk+g=;
        b=elb5NRlvc0uI1qPvpcGQO2UNhpwAHWqgpccTCnD50wlePzl96UuP0xTC7SypstKU01
         qMsCxhnTcLNQPw6f10hAdILVF3P8jlaBf3CLQCwTQiNL8C10ZYrY8dpWCtBA+KyyiAA5
         ZCgN6kaZyqctwmQBUhCiQrfKKp/WsoOcYyxTvo8wFDMPIdQlPKGjsEwgy7Mc6PxncRan
         imf2TQcMPvrBAhAZW1tPVajA7Di66Mbbf9SZN8Ub/WUQUoNuMQIEtP3TEEJQ3sZKbII7
         +CPgjahbE9YiKwRxE7IAb1+T8x7PG/8AK9bzH3kNh0pvu6SWXDyIQgmwZ721wMpjzFNG
         MDTw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794243250; x=1794848050; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0sf9I/k/98So0/htGcCu4KYBn2oXlMUyb15O6ueVwk4=;
        b=gZY0e2YUJlAn2x/WYynrARZMsOiYHPrBOMHqAuYzFi97ny2sJDWcWTm6d529/hdf//
         W6j3WzywXaqfhoid7GN6ZKlGn1MMWl7Qbl8/hJtZyMFAQ1kMvLMy3lZhqlwhuir5ALW7
         uWk5A8nUQzcb3pHKrstIHCtdDYdzLw5OU9p0HMvrXrFWhW2bxm/EPRnhnN7S6ATll2n8
         XegfXcnMDCWC7ZCpuKWVgAlD7ML+ot4W+NsO8K4sKMSjFhWl6T6ru6ENSalFeDSrP0kC
         6JqOoTzzU6mhyOPEJfJUihLcC8yNzL3Yc8aCEITeLvc9H6nxnFZPGlqaIr8nqCZ4PCCU
         7ElQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794243250; x=1794848050;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0sf9I/k/98So0/htGcCu4KYBn2oXlMUyb15O6ueVwk4=;
        b=lAr9ac9jrS0BtnBf+V0vE1SA0Rsbqu/VNBDDLFea88rVJeN1mOPx9W6V6GjOoAPaaw
         juYjR6RQictzo6Mgvn9t4NA/EQRHAvULIb5aRlxExqq7Fitn9FeE6nOzZDmNUzKe90gc
         bWfH4R1ytVuSHJRJlpifkpZ0VMAO3JGAwRGu+rEtums4yy6ty1+JgUfeO6H5+5gmIoDt
         mjtGJUFzSUhFxbZiXnPHU7rG38QUQN7W1ejuUVdIlwX+uxD0U3b0PicZdwHoRdiVLcsX
         LQgrCNoWTEQg6/dFz1PYN4VjwXntSRMciOQxDx+aRn/0wROT5kat4IHZwNhvEUxHv0sj
         UKtQ==
X-Gm-Message-State: APuU4Z9HYALn35RBTm3IStavQR+7Nee3EdgtH7KqApm06ShWKLJApJdy
	2K9AbEFBPx2+jU2aJqG/kKldSk8wSNDDJFxj91NiXNUlAe3jZ0jmhDUnO91RHZ3cHdld0e66gm5
	sYjjUsqiKES8W1/FuEg/i1CR13KGQ2bM=
X-Gm-Gg: AYBFou2f2PcpUBjpb/eqL/E0p7T01C4gLbNGqq18OA596agOxZQsy+3t5bFLSojkmLS
	S8zYB/DCEtfpCgzY3Oc9VLZieDtWqSOFLPpFfMcQy9xfO0mivk29TQK+hMtcA3Ro8v2oEitm4kC
	2yr4D7ackxs8SblxjbCXDCs3QKN3Vc22NwZOAQxyoeElwUs6wD9n7be5QK8e2VemeGd+fXfZdMH
	p0k4thvoh8T6QP4/0hBTfA9Zcuop3OEyM/iZVpsGbb20jPcFw/XqDI4vafkazuwvvwchMxzIsdu
	xQdver1FiwDM8rr8/rGL8BkxkASDhoD2WSO80/EODYJVQdwgylhUYj1hnYe5fQFaixvyxu0JE/p
	F3UwMOcLS/4IkZcgcpOgvikRbcozGIWDDWH8I13vQ7gytVjIA0B95FKvXA1GVq3ga1gyIe+qpQH
	HWvyngmf0XP3rJ9CRYN11sUfrY+qB3rAXSMMjbYCM9cRUZO7kLFdud
X-Received: by 2002:a05:651c:418c:b0:3ab:2a19:8624 with SMTP id
 38308e7fff4ca-3adfa3f4532mr7810971fa.5.1794243249325; Mon, 09 Nov 2026
 08:54:09 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261106160432.2552507-1-nphamcs@gmail.com> <20261106160432.2552507-3-nphamcs@gmail.com>
 <sashiko-outbox-203018@kernel.org>
In-Reply-To: <sashiko-outbox-203018@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 9 Nov 2026 09:53:57 -0700
X-Gm-Features: AclHuK-kEkGJpmX8bEshRAj1QlWY3h-AH6ZOffWLi-cEQ50b9BttRYvWlSNJfDY
Message-ID: <CAKEwX=OaSLfSF=JdS6Z0SEBU-5V2zqjLb6s0sHa0tx_GOuwaLg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/swap: publish cluster tables after reacquiring
 allocator locks
To: sashiko-reviews@lists.linux.dev
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, axelrasmussen@google.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, 
	brauner@kernel.org, chrisl@kernel.org, david@kernel.org, hannes@cmpxchg.org, 
	kasong@tencent.com, ljs@kernel.org, mhocko@kernel.org, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, shikemeng@huaweicloud.com, weixugc@google.com, 
	willy@infradead.org, youngjun.park@lge.com, yuanchu@google.com, 
	ryncsn@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: teedsjz8xet7i34pamrs8f8sfcx9oup1
X-Rspamd-Queue-Id: 51D744000D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794243251-367841
X-HE-Meta: U2FsdGVkX1+B9owFrV7b03b9/Um3xlfRJx5t0nSHodH70QsIJ+AFpR7hJ0ut0KdCvdsU+TuWJnOVyzt/XWVSLse7HcUvAxqjgezeSiwWIOwejzz62uBNXk1kGWD+PDlsdfZpwxLSjiIbbu2cmPe5Yf4STa3KOlnr13GaXU0F4c4qapzUDH6ZGl3h3/NaVPPDfHY9xZ8aozoNi05i2kXZvLR0Fc0vjOJUInlU+JU3+DzuVkBpFcWw+roROEa71OYwvUe+qCn79uRfPGEPNuO2SDbjRB1Y/QQ85vSkeNUf4Z7LXmv4OIM50iXC9drIG6p80YmxB8ZL04H0MSuErKDp4XkxNS9T3rp7gqq1v7dTQVlDLED+ykl7wTYnep91sWnvES/zTo3iwtbgS6IcWXqsl9IGZmtQy0fZVuXUhOt7QIBsd+qA8hs/Awbpx2xurrerY9+Y+Ni6dEaec3+7rv8z7FLfO/bhh3ixVI5d/5fvOmmShoBOkGAkp9K9FnhKvRqRJSND6hEWquA7jC4C0msbdbzSyh6bruBPc8QHpiPZ8xFmrWY9qa1TsB0HU0FWN2v/Un2Io5dwZKPmcrE6gjPKTicJcJicZLBUZ0M03YV4xLLCJrmj8GNly+kyBnQbc+HP5FKuk+oHXXuqAYtLmw0KfTHm9fqHOvd0VhyneBm0sJywzEVubGF6KDjSZZnSmqGTy+oKy27ejy7sYfAKEQvu2+26DxEDrPhXgPoaTR8zAuB4qjRZ8+oz6za4qTAVhJN6DJP5gIF7j9+AFs8CzxL8oGKnmku5qFdpbm1kq6n93O8ffnSVt2j2WVdNp5VT2VkdJ8T9dvTRO383IXY3scYUeB85UTYAjOZfhBaSrWveX6Bl04kHWA0sa5d3u0jNGDeuJy/dYBEFWP7GckWsc1xICo8I2OBEu9PbdV+Z7r4GTBakaDyJm4Ws1JGU1aT96QmEyTXL06yCr/COuq1kl2r
 dtK10NVi
 wKQNOguf2aMFGUIDmiL2BKxFVGTZawPrmux6xWkwggRuqUrJa5vFA2nGl1xuYjfSZ4JcK+JeY/oVUKtZHC9w8F2vjfCzEhIVnbJL6SHAdqf6Fv5zxBe9XKIkqWiWZ7tP+u5tIx9OYcZQIrxpitwARP1MMVl7kb2JdDJqZ1YMh/GbAYGrUM0oaoxTQ0ig1x9FcprCEjXuEf0GOM3XgwxHtyrlvZ7VHzlaj36xRrTAFdvB27pR9fEpe/nUhzId51G6K2CV+x5zPGZKgi7jV8pNoaxgXiZPu0aH84VoHzTzJnjU4q9ZthXuFW9xgOifb3DpBj8eMOjVEVlyhlGpYAN3OGiB7fxc5/ykGWflAs9xrCpQ8Rc5aKmQ4RRBfWW1G6c71HeI3mPUBQu1GIceIqijGJ51XF5kXFqik/pL9I3fPg4GnajtaDOC1ZQ79KA38/Kw2WjxXh24CicvfWITpGeiy9q/TgOqTBQVXfyzZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 7, 2026 at 9:05=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 2 potential
> issues to consider:
> - [Medium] mm/swap: NULL deref in swap_cluster_assert_empty() on stale
>   reclaimer race
> - [Medium] mm/swap: ABA race on cluster state check in
>   swap_cluster_alloc_table()
> --
>
> commit 22e220b18bd05df45a828a3170169b92c0c14f76
> Author: Nhat Pham <nphamcs@gmail.com>
>
> mm/swap: publish cluster tables after reacquiring allocator locks
>
> This commit keeps newly allocated swap cluster tables private until
> swap_cluster_alloc_table() reacquires the allocator and cluster locks, an=
d
> abandons installation if a stale reclaimer returned the cluster while the
> locks were dropped.
>
> Link: https://lore.kernel.org/all/sashiko-outbox-181084@kernel.org/
> Link: https://lore.kernel.org/all/sashiko-outbox-181086@kernel.org/
>
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 189f04d8838f3..162a73a9e6638 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
>
> [ ... ]
>
> > @@ -467,27 +475,49 @@ static int swap_cluster_alloc_table(struct swap_c=
luster_info *ci, gfp_t gfp)
> >               table =3D kmem_cache_zalloc(swap_table_cachep, gfp);
> >       }
> >       if (!table)
> > -             return -ENOMEM;
> > +             goto lock;
> >
> >  #ifdef CONFIG_MEMCG
> >       if (!mem_cgroup_disabled()) {
> > -             VM_WARN_ON_ONCE(ci->memcg_table);
> > -             ci->memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
> > -             if (!ci->memcg_table) {
> > -                     swap_cluster_free_count_table(table);
> > -                     return -ENOMEM;
> > -             }
> > +             memcg_table =3D kzalloc_obj(*ci->memcg_table, gfp);
> > +             if (!memcg_table)
> > +                     goto lock;
> >       }
> >  #endif
> >
> >  #if !SWAP_TABLE_HAS_ZEROFLAG
> > -     VM_WARN_ON_ONCE(ci->zero_bitmap);
> > -     ci->zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> > -     if (!ci->zero_bitmap) {
> > -             swap_cluster_free_table(ci);
> > -             swap_cluster_free_count_table(table);
> > -             return -ENOMEM;
> > +     zero_bitmap =3D bitmap_zalloc(SWAPFILE_CLUSTER, gfp);
> > +     if (!zero_bitmap)
> > +             goto lock;
> > +#endif
> > +     ret =3D 0;
> > +
> > +lock:
> > +     if (!locked) {
> > +             if (si) {
> > +                     local_lock(&percpu_swap_cluster.lock);
> > +                     if (!(si->flags & SWP_SOLIDSTATE))
> > +                             spin_lock(&si->global_cluster_lock);
> > +             }
> > +             spin_lock(&ci->lock);
> >       }
> > +     lockdep_assert_held(&ci->lock);
> > +
> > +     /* A stale reclaimer may have returned the cluster to allocation.=
 */
> > +     if (ci->flags !=3D CLUSTER_FLAG_NONE || cluster_table_is_alloced(=
ci))
> > +             ret =3D -EAGAIN;
>
> [Severity: Medium]
> Can a stale reclaimer trigger a NULL pointer dereference in
> swap_cluster_assert_empty() while ci->lock is dropped here?
>
> Because ci->table now remains NULL across the sleeping allocation in
> swap_cluster_populate(), a stale reclaimer that dropped ci->lock before t=
he
> cluster was freed and re-isolated can reacquire ci->lock while ci->count =
is 0,
> ci->flags is CLUSTER_FLAG_NONE, and ci->table is NULL:
>
> CPU0                              CPU1
>                                   cluster_reclaim_range()
>                                     spin_unlock(&ci->lock)
>                                     /* ci is freed and table is freed */
> isolate_lock_cluster()
>   ci->flags =3D CLUSTER_FLAG_NONE
> swap_cluster_populate()
>   /* atomic alloc fails */
>   spin_unlock(&ci->lock)
>   swap_cluster_alloc_table()
>                                     spin_lock(&ci->lock)
>                                   ...
>                                   relocate_cluster()
>                                     free_cluster()
>                                       __free_cluster()
>                                         swap_cluster_assert_empty()
>                                           __swap_table_get()
>                                             <-- NULL pointer dereference
>
> In relocate_cluster(), !ci->count and ci->flags !=3D CLUSTER_FLAG_FREE ar=
e both
> true, so it calls free_cluster() -> __free_cluster() without checking
> cluster_table_is_alloced(ci).  With CONFIG_DEBUG_VM enabled,
> swap_cluster_assert_empty() calls __swap_table_get(), which dereferences =
the
> NULL ci->table.  With SWP_PAGE_DISCARD enabled, free_cluster() also sched=
ules
> a redundant discard before swap_do_scheduled_discard() calls __free_clust=
er()
> on the tableless cluster.

Hmm this sounds like another pre-existing issue to me... Right now
stale reclaimer can get into this exact same situation?

The only thing this patch does is extending the table-less window (i.e
push it til after lock acquisition), but the race window exists either
way.

>
> Should relocate_cluster() avoid calling free_cluster() when
> !cluster_table_is_alloced(ci)?


But this proposal sounds good to me. I'll add this fix to v2.

>
> [ ... ]
>
> > @@ -571,13 +612,9 @@ swap_cluster_populate(struct swap_info_struct *si,
> >        * could happen with ignoring the percpu cluster is fragmentation=
,
> >        * which is acceptable since this fallback and race is rare.
> >        */
> > -     local_lock(&percpu_swap_cluster.lock);
> > -     if (!(si->flags & SWP_SOLIDSTATE))
> > -             spin_lock(&si->global_cluster_lock);
> > -     spin_lock(&ci->lock);
> > -
> >       if (ret) {
> > -             move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FRE=
E);
> > +             if (ret !=3D -EAGAIN)
> > +                     move_cluster(si, ci, &si->free_clusters, CLUSTER_=
FLAG_FREE);
> >               spin_unlock(&ci->lock);
> >               return NULL;
> >       }
>
> [Severity: Medium]
> Can an ABA race on ci->flags and ci->table cause a failed allocator to pu=
t a
> cluster back onto si->free_clusters while a second allocator still has it
> isolated?
>
> When CONFIG_DEBUG_VM and SWP_PAGE_DISCARD are disabled, a stale reclaimer
> calling relocate_cluster() -> free_cluster() -> __free_cluster() moves th=
e
> tableless cluster back to si->free_clusters.  A second allocator can then
> re-isolate it and also drop ci->lock for a sleeping table allocation:

I think if we fix the above issue (i.e not letting relocate_cluster()
put the tableless cluster back to free list), we will fix this issue
too.


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106160432.25=
52507-1-nphamcs@gmail.com?part=3D2

