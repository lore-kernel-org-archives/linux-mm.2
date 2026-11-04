Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0E60E606A33E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 23:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dKQndW/4
Received: by kanga.kvack.org (Postfix)
	id 179236B05B1; Wed,  4 Nov 2026 18:51:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103246B05B2; Wed,  4 Nov 2026 18:51:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE6326B05B3; Wed,  4 Nov 2026 18:51:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B6C8E6B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:51:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E352A8195
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:51:14 +0000 (UTC)
X-FDA: 85399085268.15.76A7A6F
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6717740003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 23:51:12 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="dKQndW/4";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793836272;
	b=1WFYIwd+LfItKPmmxSQ8xerjHdnci6d/eAEdMmCFkrSfpVTj6BUA+Rlmo32Tsw+XoSlg5W
	rdV3p/HBIm4U8HN+tNekwX2EY3oGykUYGLHB9NVZ3anlzkLAESBhzYpH4bFuK5dzwSnZiP
	aXy1JOREGEuTJ0sAYnl7lxz3/gBc0hQ=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="dKQndW/4";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.52 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793836272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JGZJc9KgnmzNd8yTchlJnUVRh0mKv/gnJvICDhA10c=;
	b=Gkkh2ma1CrFsWquG2Fr6r92rAkj/ezB/bgExNzgS9LA6TgPozm60NKkhdlfQFvRJCcEWh2
	Z3CqXiJD3lLIh6oKzHK4QlH7yajn/5ic/VZjn7bVc/LYtrehgekDBVpLWLIAwjVuUya+NM
	Jy4HWbq5je6ARohrIjC0T5LEXR+ewfs=
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-48df4f540ebso660747f8f.3
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 15:51:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793836271; cv=none;
        d=google.com; s=arc-20260327;
        b=qbmS3Apt/uHlo2p367n0JP5Aj7CKF+xkcJ//iltOzf9TM+tq3WsXKdi0XuZEsZhxx7
         mSgdkg3oKqIlqamw8+njwYkf1uBFYWARwX3hJBFAXOSwJ5dgJjj36QdPo9IqM9zxl4aq
         WnHgN9n3a4YBgU1oStPemYcL5yLDyBSEdQzxbamYNHH1lPt5hIIBnK2yNZxa+H+hJTYh
         7AmnDhEcBrC99BxwiW/89ZZ84PnDmUN2S9/pzX6XDwT5wCA7jBduIMHj+9nHK+uFBQce
         ycOST6rDTB9TTr/J7j6VKCqoVjldDvifmJnW4TDOJdiZZ2UUzydzcem6NAcxeUaY7FSw
         ZIUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9JGZJc9KgnmzNd8yTchlJnUVRh0mKv/gnJvICDhA10c=;
        fh=mb7Ip4vyZpBDW5thiY2VZY2Kei313bIEnXd9SuAi+M8=;
        b=kFjykRAkX1klKhH/EPZXcWY6eHieArFe9k5XS5vjDXUMUTwLAiR/Hi8RRoI0eZnPU/
         bHjpiifQDdl8rI8k4N78mVSJ7kgeVPWVfqI+zKAQWQXS0q/wq2hNVwcXI8w/1mkB5B2L
         73Ua4anFjG5k1v9suQIO+NeXBpPahuey+sb1J/FY1Upk0227LLwzskiuN6vmKjTE6s7n
         x42xpyMfqX09NYD23kddsazDMyxqGzSPZObdhcj0xsGZiRw8HxeybM13RFto3qIkLw+D
         GalBQZcywhWhfD9VFMdiTELUX/E8WFOSldE6uklhRuPotpIp1ZfahKvQZlQfnWuwvoho
         H9LQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793836271; x=1794441071; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9JGZJc9KgnmzNd8yTchlJnUVRh0mKv/gnJvICDhA10c=;
        b=dKQndW/4X8JC6TFLfKz5Vd+y9CQA8y4ciOqSAi8kQzHmsz8LUyzSIwqI4lpy57OCRx
         DmqGCFP68XWQxnyM3Y8qAgyn3xrK+ht/uEaJeF7nyptdABM7mN1Ll/u0Ib70uGOS8ada
         fLLfOoiUCWYPyjk44yrytBJALga4ua1cIS/Q2QI/6AUty9wo4gRTCDEmCjFBTqUbnqER
         obhzYodvU/HWOquWLdP9igrD2/psUqIhVBxxnsN08t/mNnUm4bRU2Do/7jhR0jcrzwOK
         gozBmEXNOhuL8VbNIrn7PTMBonb24Jyw29itH7YzKn/Zzac9DItKcXkD51zuCJMYAf/9
         x87A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793836271; x=1794441071;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9JGZJc9KgnmzNd8yTchlJnUVRh0mKv/gnJvICDhA10c=;
        b=Dx9laU6Lmodbt4Zoz58RIjo7Bc46HKOuJTqYnA8xBUrw9/L0atOxgNZtYaurCRsQ9f
         xqG3H2FfniQIk9qNqtbFKkyqYEX+yhe4rmCKvzt7HT/cc7rV6xmyZee9IcjxHI9++upF
         f7ALUS4uYTYtBUMf8t1muz3VTMWFUAWyw79+GVlVZWnqBgEB37/BFPcTbiByZcQgk0pI
         6F69W6+tVaatobEeB0ome12VwZk9VrowIFdXFL3MN4vmhCBOc2GL5YikFzDmv63jqesq
         4saZPs5nUFu4IVunrWogzRa4NWUUEo0El79BRJXA7L8An4WVdpAh1fJWzXkq/eg23QUA
         K+CA==
X-Forwarded-Encrypted: i=1; AKwUvBye1rSIo95nBO/j1zeI2KA870VB8QeBuVVcsZ68vspQSaMEMV1Jd1+fbJ+GTAtMAdyd+nTWfLaeEQ==@kvack.org
X-Gm-Message-State: APuU4Z/wap4Ydf9zMf9oxL3WqPimThndm0FR5+jHRXwEyE73qqldQTUx
	rkMM4iPAPdfXuVZG/RcoHTg4RMSAAA9ot0BULgDy4AblLVU9QnBkCI2vX79vbEH0C/ycjXEsmXN
	xcvYtW3ikxm+vEf+4PBsd5Gl2JvOIswo=
X-Gm-Gg: AYBFou1T1XOe2Igj1UYBtFlyCAyLG1LWFg6SVYZLHVfDVW1ulVzO2sdtaoIgasQ7Y79
	KNMkJa1SekDNPKlHyiyhrODq0alZBCBYmTGR+1hK4mRivaeEgAMii9JgxeUdVBltfWIK7zdvJHq
	XfPxgHGdvNvqqR81PKJa4UOsc36aZZ79QNhEdjLiCnOU3L+znjdwUhihE5ibUcbVYmVwfuvkVeS
	L+cUlHpi9M4mH7a3jWgTB596cXRH3GSlWFe9wpOSJ6MqujurMZrnvG+CHvWdlSgjw0vAuASoXqH
	0lhh1VAkilwf5+vsRROj6mPP3gznV5wngfWtGdZfTOsbILx/Hx64UzACGH3Hx4of/TG6lA/D5Yu
	XtD7267H3FFd808YD9bfcXBdqaF238E+m1xDy+wxtqSlFHRzhH0IUc+4acIORq31BnLcEoHDJIg
	o3Z02VdCaQy/OBaqI80Q==
X-Received: by 2002:a05:6000:24c4:b0:48d:f9dd:e3de with SMTP id
 ffacd0b85a97d-48e6e511219mr38694271f8f.45.1793836270653; Wed, 04 Nov 2026
 15:51:10 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com> <sashiko-outbox-198104@kernel.org>
In-Reply-To: <sashiko-outbox-198104@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 4 Nov 2026 15:50:58 -0800
X-Gm-Features: AclHuK8LMj1EsjYTkvxo267ROt1tEN-rvdCDmErGRhbfwk9mjVdCNsfb7CKSm3o
Message-ID: <CAJnrk1auD1u1J0yQrXOeJrxvVsQfbxYf+nsMS-9qFQ0hfchG-w@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, hannes@cmpxchg.org, kas@kernel.org, 
	alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: ngs5fzj4hhp5z1urndadofdqa4uqaj61
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6717740003
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793836272-524481
X-HE-Meta: U2FsdGVkX19Ne1USvFkYUMEEXE/p7CIa0VqwDtXkTQ5/hwqXWwMYW6AyIgh7mHeOqaA8or4DZaMceLTYkD6KlZYEdKo5nlZqMe9KTA3dm+o/mZnnoADgqd0PO/UXdhoXO3AaQ2rz9w1Neu5nLCHZgRGmsJBzC+s0tkl5Vci6ywNvGbZjPyv7jNi1r92Ho8oXo/OGhChEuyX8W+XkkDA5JfQIi2HOoydQtr1f4MNXLzqz8BRBg8204S7Uo38PkO2bVHfa0bn6VIzRs7YA5h40mWVa1f6s3SKhZm5/v0ZH9baj0+5WTMIOf07Vkqx8M6Q7xnKZUDb1KASzVe19BGpFqbeNmCp8g4vxvQymq2jG7S3GLQT6XVDfVrrjPpyaq/bBDq7wNnF8bcDrbxchYSWl49eM3wL7JALaYM/tH8Px+pLsZZLM4y1+PMFbx55lG13CMa7g9/xo98OPdQh3d75yY116V6Rn+RAYFQ8/fOlyMau3vfLMB7fY/fI62rPFMS8GmoBaD4E5SmlovK5yFLZkb1TlhtMmQ0V5de0YJA+eIFukq9CM2QeOWsCfRm1kPlDZScJjOGaPgh9NThMBsDRxXovkz09VAIzDK62LiwmEXA2Hw5f0lkjqDA1e5b3b+Z3c8krT1S5itKQ1COIwYaySX7srjLprUIOnhoIesUOcx7TQW1NnUTwkoC814W24iu9zmQ3YREVAdK6I2UqjqQTKyQ1f7obj3MMiAUFxyrnatXdiwJ8rZOpd63R4pm3udujlq9lI8a9/c4dT62szQ4iJbHuFuQrrJQYwpAzSYsXn78I0Xi/uuUkmWqsZxHQySYOQfk+G15eXKYPAPPsnDv2CMwkTruPdz53gI+nBYiVFz/Y7FkKM+a3UQBmykoGCFIIiLSFEOIaXG6nukA+qfPnIxTzt7Ou6L6EN2qNj5LBo0aRODLP4lRVoYl3A8X5vP+tm75Yehn6ki8P0egtvNJh
 32safAQ6
 2QFBX8FRRqa8uv211dP0Onsz47y1MvFYyJeDTPr3BNKwbgSYeZuWGadx86YtJgGLG3m3PsjtKWrnlvl2DVc0NlHQhG7dv97MtLajjUK3i/dAjcO1671T2YI1NqJFJlAOhqIvOQawwmVHMyKIM4Ne8EHbCf/ccqyGZqggQoJRWbCdT4lEHZ01BCWLNgKB1cysoWmTfnC544559k1u0scsA1nDZotoEqriOB5SzjKU9cl4rpddSo2saNLQz2UaaZlINn5Mnv9CIJUg4CwslJ1JJ/RrhLWhbbKci0+2mbM6gpiy4KR2vddr5ChcGOZ1NB9FSeCnXAbeyapI5actxhCMveS8O4YVOrsgNKb9ELwm79NBFHNi0Nrn/emr3gqMPbhP8jVkEMwufY+RaGxG8w3BxI1UdJhCT8ibYEHrY2iADrwOUqdoPpQ5J9THdrBrO2dOZRpI8aFGhGEhQf7e/r2+NVmxsTpiqRAiT5AdmBo15XZg86M6w4SVbTpupvtBPK02h42i2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 4, 2026 at 1:21=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] mm: try_to_migrate_one() triggers deferred_split_folio() on unde=
rused mTHP
> --

Hi Sashiko,

I'll try to address these points below.

>
> commit 82b7b7063b986d802fe52e75e17211e58f3f420c
> Author: Joanne Koong <joannelkoong@gmail.com>
>
> mm: add anonymous mTHP folios to the deferred split list
>
> This commit queues newly mapped anonymous mTHP folios of at least 2M onto=
 the
> deferred split list in map_anon_folio_pte_nopf() so that underused mTHP f=
olios
> can be split by the deferred split shrinker under memory pressure.
>
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 0c9ed04528d88..44376321180b5 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *folio,=
 pte_t *pte,
> >       folio_add_lru_vma(folio, vma);
> >       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> >       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> > +     if (folio_test_large(folio))
> > +             deferred_split_folio(folio, false);
> >  }
>
> [Severity: High]
> When deferred_split_scan() splits an underused PTE-mapped mTHP folio queu=
ed
> here with PG_partially_mapped left clear, doesn't unmap_folio() trigger a
> false-positive deferred_split_folio(folio, true) transition during the sp=
lit?

Yes, but I don't think this is specific to this series. Splitting any
PTE-mapped anon large folio that isn't already marked partially mapped
goes through the try_to_migrate_one() -> folio_remove_rmap_pte() path
you describe below, where __folio_remove_rmap() requeues it as
partially mapped mid-split. That already happens today (eg underused
splits of PMD THPs whose PMD has been split). This series makes it
more frequent since underused mTHP splits now take that path too, but
this issue is pre-existing.

>
> In deferred_split_scan(), the folio is first removed from the local dispo=
se
> list while PG_partially_mapped is still false:
>
> mm/huge_memory.c:deferred_split_scan()
>         list_del_init(&folio->_deferred_list);
>
>         if (!folio_test_partially_mapped(folio)) {
>                 if (folio_test_mlocked(folio))
>                         goto next;
>                 underused =3D thp_underused(folio);
>                 if (!underused)
>                         goto next;
>         }
>         if (!folio_trylock(folio))
>                 goto requeue;
>         if (!split_folio(folio)) {
>
> split_folio() then calls __folio_split() -> __folio_freeze_split_anon(), =
which
> unmaps the folio before freezing its refcount:
>
> mm/huge_memory.c:__folio_freeze_split_anon()
>         if (folio_mapped(folio)) {
>                 anon_vma =3D folio_get_anon_vma(folio);
>                 if (!anon_vma)
>                         return -EBUSY;
>                 anon_vma_lock_write(anon_vma);
>                 ret =3D unmap_folio(folio);
>                 if (ret)
>                         goto out_unlock;
>         }
>
>         local_irq_disable();
>
>         if (!folio_ref_freeze(folio, folio_swapcache_ref_count(folio) + 1=
)) {
>                 ret =3D -EAGAIN;
>                 goto out_no_split;
>         }
>
> Unlike a PMD-mapped THP (where split_huge_pmd_locked() with freeze=3Dtrue
> removes the entire PMD rmap in one folio_remove_rmap_pmd() call), an mTHP
> folio is PTE-mapped, so unmap_folio() -> try_to_migrate() ->
> try_to_migrate_one() removes its PTEs one subpage at a time via
> folio_remove_rmap_pte().
>
> On the first subpage unmapped while the remaining subpages are still mapp=
ed,
> __folio_remove_rmap() sees partially_mapped =3D=3D true and
> !folio_test_partially_mapped(folio) =3D=3D true:
>
> mm/rmap.c:__folio_remove_rmap()
>         if (partially_mapped && folio_test_anon(folio) &&
>             !folio_test_partially_mapped(folio) &&
>             !folio_is_device_private(folio))
>                 deferred_split_folio(folio, true);
>
> Because folio->_deferred_list was emptied by list_del_init() in
> deferred_split_scan() and the folio refcount is not frozen yet,
> deferred_split_folio(folio, true) sets PG_partially_mapped, increments
> MTHP_STAT_SPLIT_DEFERRED and MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, and re-a=
dds
> folio->_deferred_list onto deferred_split_lru.
>
> Could this cause three problems?
>
> 1. Even when folio_ref_freeze() succeeds and __folio_freeze_split_anon()
>    subsequently unqueues the folio and resets PG_partially_mapped, every
>    underused mTHP split will also increment MTHP_STAT_SPLIT_DEFERRED in
>    addition to MTHP_STAT_SPLIT_UNDERUSED.
>
> 2. If folio_ref_freeze() fails (for example due to a concurrent GUP pin, =
or
>    because a second CPU running deferred_split_scan() isolated the re-que=
ued
>    folio via folio_try_get() while the remaining PTEs were still being
>    unmapped), __folio_freeze_split_anon() jumps to out_no_split and remap=
s all
>    PTEs via remap_anon_folio() without unqueueing the folio or clearing
>    PG_partially_mapped. That leaves a fully mapped folio permanently mark=
ed
>    PG_partially_mapped with MTHP_STAT_NR_ANON_PARTIALLY_MAPPED leaked.

This (and #1 above) are pre-existing issues that are already possible
for underused splits of PTE-mapped PMD THPs.
I'll look into this and submit a fix for this separately.

>
> 3. If a second CPU running deferred_split_scan() isolates the re-queued f=
olio
>    onto its local dispose list while unmap_folio() is still in progress, =
that
>    extra refcount causes folio_ref_freeze() on the first CPU to fail. Whe=
n the
>    first CPU returns to deferred_split_scan(), it sees !did_split &&
>    folio_test_partially_mapped(folio) =3D=3D true and calls list_lru_add_=
irq() on
>    folio->_deferred_list while the folio is on the second CPU's unlocked
>    dispose list, corrupting the list.

I don't think this can corrupt the list. __list_lru_add() only adds
the entry if the "if list_empty(item)" check passes, so while the
folio is on the other CPU's dispose list, list_lru_add_irq() returns
false and leaves it alone.

Thanks,
Joanne

>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103212004.13=
56327-1-joannelkoong@gmail.com?part=3D4

