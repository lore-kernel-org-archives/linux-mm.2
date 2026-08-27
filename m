Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CF10C61DB9
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:18:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EB866B0096; Thu, 27 Aug 2026 13:18:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49B126B009D; Thu, 27 Aug 2026 13:18:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363336B009E; Thu, 27 Aug 2026 13:18:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 037D06B0096
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:18:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7C5DF160144
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:18:36 +0000 (UTC)
X-FDA: 85147708632.20.CDF1D9B
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	by imf15.hostedemail.com (Postfix) with ESMTP id A1906A0013
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:18:34 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E08cCIik;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787851114;
	b=YAsypSBcQRKPX5rdAIu5iuLf4TXU3qINSnPyPw4BCDsc3q7OxCej5k4bp8LoryQbVD3F7Y
	Q/gPlXP4rK3W/pYyz4ANQbzfvL4QgPA6ovmnNaftJREzP5860YbF1FUCRoLug+6LuBAnW+
	Nb8WeUVvdA2HmWnUuZXilY6R42Zq50M=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=E08cCIik;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787851114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XtbE6IYV/bM0IXeRDDxsSyGBBMTGpNCnOy9DkA38jik=;
	b=4daVlmlLUkPzEME+ZuwDqBNnbP2jJ9LEnMqGdiRkmPS6gBt1lN7pf4FwVJv/akJg/oUDDV
	bRxBTURmogP554HjeLNRcoXJb3pNbqOkVIEBVZzbb05/UgJmSjt9e75XC7qwOApPvGvYe4
	pCNWx5KGDjfIDHAIaA5IH8KI6qaJewY=
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a601ba6870so64347a12.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:18:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787851113; cv=none;
        d=google.com; s=arc-20260327;
        b=Dkfb34bC1LQvaiieBn3El1U18nsfH2KNa7HtMFJto7Xcre791vE/k/0OOwdshIzsJb
         srS2Et/UEkUIqwi0aCSZ1ENppKuOudcLibV1ydccndRqHHthh0yMrsCAqZRcJMNkxFyh
         Vs98i7NVdAW6DBe1bEfdqCAx+je4XT52/orCo9FFx24KFnMqo21/puuZUfreP9IgZbyr
         +G0ypxBZvKFCTXOvx7v4Hcq49IvS0q/tBesTzb07Ifqcqh2bYoW+vdxIbcRpgzrhcmTM
         LGweDbFB/D7VI75yZC7HVeXNWH01MXO5UAqhuy2iQuO8T7UBm4TckXsPlvXWDkBz8Uhn
         /gng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XtbE6IYV/bM0IXeRDDxsSyGBBMTGpNCnOy9DkA38jik=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=RP34MedqjtBuYU5lp25qPinKq2v7NUvW0gs6iFw2M1qcCsd5XlEUGeZueSWSH03DYX
         umPkP8tAu5rymN1jQrol/G2Tp3PzVKtCoSrdtexEdLDRg7FaVHCEewZA2ZUz/IK/n7FM
         YnPsOHjLdH+9lrLdL8XDF2yRCKqxefYAX6zBZU5L8uE+/DzA8INhqC7pKZO7hW9SFB8l
         SRdMubT2PatN3493rCnpj3NwV91+R9FQdY91Go6J8dKWFOfmkzTHv+J27yTJ2ocWdOpx
         a+0j34Dlyux6urPm+n9t902qimksCjroHOLEFYS23gpqxti6n5XM03RQx+FT9dPFyfdN
         4u+Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787851113; x=1788455913; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=XtbE6IYV/bM0IXeRDDxsSyGBBMTGpNCnOy9DkA38jik=;
        b=E08cCIikgCkGj3z0vFa3dYGTcj0phV91rj6aKenfLJ3hsR4T9XWZkGc2HIIDMOMVNA
         Tley86xkfiWqy6MzcqrSfvaCuNB2C1B4SUL2TqgHy86wCmBVhJD2Ab8IW26n1NLrjuai
         q5Qm0y5dd0OpBRwaz0yn1OXuJ5C2hE165//WwVy8JUyxPzmlJCEHrRpz0076vb2n4BZd
         ri4Gx4R0Lr/BP1ItemAdUxq4PB2jvlOZNTRGuj6VovPhLfchlzb9hWVlrJkWwPfqodRI
         nzkKtN8VqfyerKUHfAqA/qYTUKE1026/8CS+h2lcvmnB5cKCwMkgy3RKFnG6JBWqp6Y/
         sifg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787851113; x=1788455913;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XtbE6IYV/bM0IXeRDDxsSyGBBMTGpNCnOy9DkA38jik=;
        b=fHhxoa0ht4B7/ZIVbjCColwFNuXSIzHhp2MPheHLGnS8Zdyx70de4eW1NztWZD5lzf
         /vGF+EhkgdBSEWN48NmMPhhGOF+UkW+9iTJgea+fqUKjCvwYpUn0G4olUQDg6IHjjS31
         eqJoq6aF3LO9b9G1Q/79cz3NP3IAWVGJQqndHaARPOw6TyN2JiyAoSuBLY5+m8iM1/b/
         WicWFwZeC0jfYWQ13kBzxjE6sAyK8YFt1talqvuRsT3gVjcnr1YI6O/DDCg40CB6HMmP
         bTcHQub1WSU8zw6LIpUtz4rTXyEmMg7KiHZpQE4joQjeO1c4Bb75/glKT/D4BG5KBhNX
         jrgQ==
X-Gm-Message-State: AFuF++kfIM95h65/gi4vPqZZcK5JDB5V5BRxg8ssrhi7QinzsKTWvRGY
	grSfkBP1we90rSrNyFFNtLGO6CNQmDkNBF8Kgsd1dUAeEQH8Dv1+Cwqdjg2mAbgNhOSHsiFJDgg
	dOA7kEx8+vXUvajAfOrKBqiOWBrqIjtA=
X-Gm-Gg: AR+sD13PmGdjmgDLSAhCedh0cT8bg0gT30wV7mV8jwZo6Vc+OLJa1A4btmJBbOvcani
	ZhcONKfEhxahKxMgvQHXcJypJefQiZU2Z8NQ5tiUumyAApRAfmJVn8lEsjyvkEwIEphpXv9iE21
	J/SpGxYDuCNlowRcKtbbV2hQyo7A96agtchwbQhnsxoN3Mm1LvIQb6uvF+LlgnKwDTZtG6bsUgL
	Lf49QngrEx6dxpYQWfYaTaLk75GUcFi2gkX1O1g6iA/C9VDp5+oVZ5FKOm2WnzRSDlag4bbct3D
	mV3/XS9/uUXEHebf0a0cbMSSUg2rBV1xMSENsaWi1T51Uj77ed9+HwhwZMvsPbJU2Q/oDCEZwgk
	E
X-Received: by 2002:a05:6402:44d8:b0:698:9e5e:5df8 with SMTP id
 4fb4d7f45d1cf-6a60d3450b4mr16898a12.7.1787851113010; Thu, 27 Aug 2026
 10:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com> <e156c931-69b4-48d6-84bf-c06df134c9da@kernel.org>
In-Reply-To: <e156c931-69b4-48d6-84bf-c06df134c9da@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:17:56 +0800
X-Gm-Features: AcwNN1VebzlFJypx5e4RotNewkKx5zemE-HrEPZEpkP6B4aDviKyhLvjLFBwBqQ
Message-ID: <CAMgjq7BzAkuibv+SyZQ+WzzbEL29dV-vPYyX2p43L0JDn3=wNg@mail.gmail.com>
Subject: Re: [PATCH v3 04/18] mm/huge_memory: split the routine for splitting
 anon and file folio
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 3wmfg3faabpst5hgcrr5g1sw9zcwsc1x
X-Rspamd-Queue-Id: A1906A0013
X-Rspamd-Server: rspam06
X-HE-Tag: 1787851114-979314
X-HE-Meta: U2FsdGVkX18IfyltS4HOTtkO7DnzoCxyslOwOkH/D3pqUMZQb+LNCDQRG3ETRG2l6veXFNVpXb8IKTt3UL0FN6A9PXcFpoJ+mqRFD3JQ7pV+ovmtK5sS7EeIpiQNm547KFwTTZkO2J7btF3lR2jXXS7kDunLIyRtzOMZn0xSrZNevxwgZ8J6VXPmNMyJp8h600Va5cOp2Ll6bA7cTweXpRpMksRtGHEn8YIFTDIOy+3gdr+ROm3Gh+eaLNwqNlAueq8wB5SJIAKVRrDzCIXwAgRUDwBQx7g98h32rBMEV6at4bRSdW1hv2CyO/G2vGLpOgCnb7X23ZvWa1gVXjh7J1/bmyF7sd/HpLnYCiDZZ0QPpQEuvOHsXiVMSczyY4AWT0NEI8c1XD97cACKrsFbdYQoQVVA5dyQ0lD8TqfSxeSpiOUE+nvDupHjzpkL7ZK2GOrTkOI9g84k47NOiBGPRAn09cQpY/2BRqtIUI2LClfdWxRTz4+JoxEPL0W3ZT+8DinSjgJrji5KW8k6rz1NdSAfYlEkrsX5lYsT8kGdN8JylQKARXIaPHTcTFvcCmVJJ8nmp7Wew7sZPSBcZgKiZWmwlmeqv21j1pAc7bsmP9SFsX23BOBxSc/Cce5YAlK+cx0I58iSTsUGdNL1lVUiMfADPSvrZfeCNRJiY6kDS/XSso4GjvFyQp6Bf1H1mAFGQeS43AQba79QvcNqdoARWSx8eHVxtxd9VdL8qtDBD5OpnzgpetswVacIrInirnrQX/RnzmJe35qBTQnpmSv2oet0Xl2TOdTtaUXacccbVBUppygGuWg/zfw7RdUmrcIAxmMHC79K8tif8vB+s7esP3SLLizxc7I7wcjY8DVTAnZ6Wg20aof0r6eU9KxR9/+svRqaN5V/imgRXdo4Clrl3gX5GR9lzlG/b4zAhQkDK0sfGSBFqZJaWuO82Vmqyhu5CkP/KTJv4wEeDte6vFI
 k4AvrqbQ
 2kvEplOBpLm9VBiWlARKqBoJZEkyuw+GNjnu5gAJ2QM0y5dPjl4RjGOjKT/qPE8n7m6q1Bk/R0ehN0gc4EOHWi0jyhcEgnXmHuvU+tgTB1v/zpHdCGBonZhSpHy3Qq9ROTomeMGFXDOCKTCoDATobNunVWuQ91IBp3vxzErfiUJ7giJYLutMJRQKGmCc8RRI2rOaX9od/+uV/QGQUYp0heHw2n95BRVpu91PRWOyKUZ4LoWo57pKF//hY2YfyDCPWJLm1WAHioTnMBLpgCqT1OwlYSECB5/3Uywr+Gj840uFL+0f4HQsZpVR4c0eh8xssRDtApeFNol5Ayo+MiSb91LbGwbjoC4pgddnrczq8VoolQEf6N+2JpKv2Dup0ChOirfCsvczNwIwfz6vOrwQOcQCXpLy2RME1xkjPbjPzV35Ar8S53xGMMY8Uun5WXmK5TYy7wSzEw7B92SiH89WI1Yl9x2IWcvMTc1Nm+6gNKC/xJk/iSixTtuTDQWs7QnMueaqv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:19=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> Switch to double tab indentation instead while at it. Same for the other =
function.

Sure, will change it.

> >  {
> >       struct folio *end_folio =3D folio_next(folio);
> >       struct swap_cluster_info *ci =3D NULL;
> > @@ -3948,7 +3946,6 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
> >       bool dequeue_deferred;
> >       int ret =3D 0;
> >
> > -     VM_WARN_ON_ONCE(!mapping && end);
> >       /*
> >        * If this folio can be on the deferred split queue, lock out
> >        * the shrinker before freezing the ref. If the shrinker sees
> > @@ -3956,7 +3953,7 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
> >        * lock and must clean up the LRU state - the same dequeue we
> >        * will do below as part of the split.
> >        */
> > -     dequeue_deferred =3D folio_test_anon(folio) && old_order > 1;
> > +     dequeue_deferred =3D old_order > 1;
> >       if (dequeue_deferred) {
> >               struct mem_cgroup *memcg;
> >
> > @@ -3986,24 +3983,72 @@ static int __folio_freeze_and_split_unmapped(st=
ruct folio *folio, unsigned int n
> >               rcu_read_unlock();
> >       }
> >
> > -     if (mapping) {
> > +     if (folio_test_swapcache(folio))
> > +             ci =3D swap_cluster_get_and_lock(folio);
> > +
> > +     if (do_lru)
> > +             lruvec =3D folio_lruvec_lock(folio);
> > +
> > +     ret =3D __split_unmapped_folio(folio, new_order, split_at, NULL,
> > +                                  NULL, split_type);
> > +
> > +     /*
> > +      * Unfreeze the post-split folios and put them back to the right
>
> Why call it "post-split" here when it's "after-split" in the other commen=
t?

Will just call it after-split then.

> > +      * place. Keep the head @folio frozen until the end: sub entries
> > +      * in swap cache must be updated first, so a concurrent
> > +      * swap_cache_get_folio() cannot return the head folio for a sub
> > +      * entry (folio_try_get() will fail on the head @folio until unfr=
eeze).
> > +      */
> > +     for (new_folio =3D folio_next(folio); new_folio !=3D end_folio;
> > +          new_folio =3D next) {
> > +             next =3D folio_next(new_folio);
> > +             zone_device_private_split_cb(folio, new_folio);
> > +             folio_ref_unfreeze(new_folio,
> > +                                folio_cache_ref_count(new_folio) + 1);
> > +             if (do_lru)
> > +                     lru_add_split_folio(folio, new_folio, lruvec, lis=
t);
> > +             if (ci)
> > +                     __swap_cache_replace_folio(ci, folio, new_folio);
> > +     }
>
> This smells like duplicate code now. That should better be factored out?
>

There were some discussion on this in previous series, I tried to
implement a macro or helper, but it ended up being uglier. Right now
the duplication is just about 3 lines of for loop due to the split,
and the extra loop duplication existed before, so I think it's fine at
this point, maybe a helper later if this grows.

>
> > -     zone_device_private_split_cb(folio, NULL);
> >       /*
> >        * Unfreeze @folio only after all page cache entries, which
> >        * used to point to it, have been updated with new folios.
> > @@ -4075,8 +4105,6 @@ static int __folio_freeze_and_split_unmapped(stru=
ct folio *folio, unsigned int n
> >
> >       if (do_lru)
> >               lruvec_unlock(lruvec);
> > -     if (ci)
> > -             swap_cluster_unlock(ci);
> >
> >       return ret;
> >  }
> > @@ -4230,10 +4258,14 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
> >                       ret =3D -EAGAIN;
> >                       goto fail;
> >               }
> > +             ret =3D __folio_freeze_split_unmapped_file(folio, new_ord=
er, split_at, &xas, mapping,
> > +                                                      true, list, spli=
t_type, end,
> > +                                                      &nr_shmem_droppe=
d);
> > +     } else {
> > +             ret =3D __folio_freeze_split_unmapped_anon(folio, new_ord=
er, split_at, true,
> > +                                                      list, split_type=
);
> >       }
>
>
> I was briefly wondering whether shmem folios in the swapcache would now g=
o
> through __folio_freeze_split_unmapped_anon(). But folio_check_splittable(=
)
> rejects them.
>
> I think we should consider changing all the "if (mapping)" checks there t=
o
> "is_anon" instead.
>
> is_anon implies no mapping and !is_anon implies that we need a mapping.

Good idea.

> This patch LGTM, but I think we should clean up __folio_split() further. =
Maybe
> taht happens in the next patches in this series :)
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

