Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8A1BCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 07:54:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA7AF6B0095; Fri, 16 Oct 2026 03:54:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7EDA6B0096; Fri, 16 Oct 2026 03:54:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B942D6B0099; Fri, 16 Oct 2026 03:54:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 91FC76B0095
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 03:54:56 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1471E14025A
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:54:56 +0000 (UTC)
X-FDA: 85327728192.22.25C87A0
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3100620006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 07:54:54 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IPpOZmWA;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792137294;
	b=qUq5jO62PbDs0Ktea9fj9zN5xA3QRtfh3DxxGDbDs7dWlhR3/5myU+pEehg0ntog8hLOpl
	aNzDUAbHjjb+dIa0tazaC7wdjFOnf/hoEO4AaneQowHHcebVcXbswhoAquHQHChhR6U4sX
	kT2HlxipMdB4+VFd/18PV1e4zS4NCuw=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=IPpOZmWA;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792137294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sTydiIf1dz0lwLgVUeftG7/xPlIHpWwfPGV7qf09584=;
	b=aqNW5E+RIFu7WEfrjCLZmvenaT3PKAHUEG8vojtZJTNtLL7zICyq0GDJHFEKghftlG1HQm
	B3RlOOxxg4gnDkdl9pfbAEprKnRbrgOaCwmRvFogzKPESinpsnSfBZ7sNyIKA5Ixj2wCyQ
	VKZySCSkljT/4UsCfqswFXwmx447UtY=
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6af8620a7d2so7331385a12.0
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 00:54:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792137293; cv=none;
        d=google.com; s=arc-20260327;
        b=OeJASkBhr1/GrkNl7cl45DfsaOVKqen0+Jt58D5Fz5u1IfdpBA+bq/6MfpXvez8qFj
         zLvlSOQ8WNIKDzd/QHHwWn/+quNXM+MfBw51G/Sc6MMXo9T9STprwWbjpc86fL5b0XQL
         qzWhFOpFn6wRqNrGy/fEsLfM0mcczut1Sspl4unaPBC4BxKGFeF1F54tDn8x4+nm47/b
         opAficKqm8ykJ3bdcKrPDN7zJFGunTHCzW8Ra6zwG+2kHfv59xND+ldPg80H6cwvAAVF
         txCfviOPeDB7M+11WzYbce02GXrM46aRHW8w/g8LAunRSFMR6hfsfFFrJFZ70WUye0iV
         NKIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sTydiIf1dz0lwLgVUeftG7/xPlIHpWwfPGV7qf09584=;
        fh=UiVjFFhVtt1yIxaHmdXCuNQdI8BQc/URaTZCFPh5gfE=;
        b=HF8loCyKeqpOXTymGJvtEtK4qOr49fy0J8oWQXn0a9qkOiKL9i4m8Mx24Bzgtz/zOc
         VsnEjYcVVyqhcMQ1XcbGUzBQWcLQAQD/nuecM7uY9pinGtjCvjmZCC8VTOHuBKY4pxti
         mAGKWOn5OlryASjyDZTOBAhIxHI1hlr2KrGsoUD5l49D3uwfpL8bpCtt0jEUjdj7B7IH
         NheCAp2tdNHiOynSESegp8cvlAQ2hZSTP1b1YrBsEZByFx4/6YHmhR1nM5+5IVVDxyZH
         GgsZmdgONxhpfWr2kl7256kKNvIfSSNC/3OuP4qqQg1sBgv3CU0z+IfxaMgn5tEBYae7
         uAkg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792137293; x=1792742093; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sTydiIf1dz0lwLgVUeftG7/xPlIHpWwfPGV7qf09584=;
        b=IPpOZmWAouJZsRV3CZ8RWYvz0Cn4iHqb03dSaycIsOT/JN2ptj0tApx1E8UL+/tITN
         RSb+I7kGF5X2n5jf4UmvWAFRd+oR6nZH0n/bUjimNHj8Zv/G7civ6U/PvyFYW4zsVjDS
         Bm0M+Wwwbzj6zXaCoTWZ1zlXntKLlafE20Jo9CMrI8aQrdvVrPipxVmP/DncSeNnHFud
         mG7UwOiU/NUtPdH33mruMYvFSKdUAlPgtdlYZnMaB3SeE1ymgvwwIVp7U23Djrq9Gk1a
         3Up/ZBcMIo6zNZI0jXGHPRrXCPuNgzb4dBTUon48pBNtEAf8edOQ5/5dIktIblr/OpRg
         KQAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792137293; x=1792742093;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sTydiIf1dz0lwLgVUeftG7/xPlIHpWwfPGV7qf09584=;
        b=ogrP+F2hRUJcWwMZRH0B5FeI4YTSRaIMSaZFj2HtQdJZQfaq/hVCVeKvmapqNzINGV
         E6wnY6i6mnvZ9dl8wGQIPcClc2ajSncWByN+Q+HKIBchBlatCT1Vxt+0VlUky9m8WgJk
         VHtPWF8axR9oX6yL0SBIAdLJ2d7T8kaSugv5tK0KkiNwD8oCRlLHjtzN8fh9ws805x4r
         yZMtP7CTYJvRx8CTo1tac3tkzuXrYFNpR242OOsxIasiBVnIh7gPRRWHC5ADVk/Xyg/6
         vUbaN1Fdo3EI73W96FKgqPZPKmST9lS2iMqcSwQph/EHzqOGYVbng7bsheFhemTOHBRC
         fM8g==
X-Gm-Message-State: AFq9FYJhLTxeJspGyZE6J0tck4zuzDYkUOGbHhby9rOmNB2N4LMOKo1J
	3LfZuChkInrUkjf1kH54GKMgxeT4sc6iuqM1LgciRVo22wDRkVRfnrzw+tWlP68s1PMEQBo4IT0
	cK20UWdu9ZVUbemtXnerfb0rIh9+AOeY=
X-Gm-Gg: AYBFou0vxP19GeQ8Iyt4s64dkKbgBRDK1hbjwO1ZUOJB5WdbhsmUfr0wUqGYAN5wqig
	dgBotTHILvrupN+10SsDjKDNWq4ZDvkPjz5fslBEihHK5eWmj75e/ydukunLsrTq23V9qFC3u/b
	LZwNyrrl3kInIFv+asvu2A+adV9A2hxpot1aBu70zCYgmQjf68+sBuFuNpmULFXhQLkqWO4NXpK
	euzpjjyrNRIvAkcaYap12/zO2AtTEeXOXKFHmLAyf/oyG5c8Hb5sXXhVgjxU6dkEjXWDyz4B9Yp
	Kb8IwXBR70/rf/VevHEJQWRh4K5rcIJS/sxrI7FL2Mhq61sk3DUnmkMNZkC7ELY/IgxHNxJcjb6
	C226WxMrT7N/ZWWVOIEIQFXh5EGcKdTwoB/TnJ9W1pVqLWR2qs0C0MS6LeJfwZC2JSmFeCg==
X-Received: by 2002:a17:907:7213:b0:c31:6bd8:b13e with SMTP id
 a640c23a62f3a-c31a9fd33d1mr1854131766b.11.1792137292409; Fri, 16 Oct 2026
 00:54:52 -0700 (PDT)
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
 <20261016-mglru-fg-v4-3-2106750c0bfa@tencent.com> <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
In-Reply-To: <342E57E7-9B7F-4193-805E-D1EBB41299FF@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 16 Oct 2026 15:54:16 +0800
X-Gm-Features: AclHuK8lfaJLkt55oh9aygbGuPc6XqqQ5L-gpY7DcUfl3-ol56sFY5yxSCzcN1I
Message-ID: <CAMgjq7D-2HyvuD5U58ohv4YuyuCEbxYAO_wxkx==WxhsNQrXXw@mail.gmail.com>
Subject: Re: [PATCH v4 03/17] mm/memcg: add folio-based lruvec live helper
To: Muchun Song <muchun.song@linux.dev>
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Xiang Liu <liuxiang.277@bytedance.com>, Ehab Ababneh <ehab.ababneh@intel.com>, 
	zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang <lianux.mm@gmail.com>, 
	Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: x8uo3xw74t1uhnpg6gwjtwphpke3saj4
X-Rspamd-Queue-Id: 3100620006
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792137294-967321
X-HE-Meta: U2FsdGVkX1/vcczigxBwTFovmYoocyfP1+lNa1kitTP9FneWNqCgO1NhOrBjn/hJKd+2wP0F1J5wTHr+CEUpbYFSVbWQSOcVamFe7z8pDBi2ojMZQVcn+LWcvYim1dleemMB+SEOQ1k+FzEiI92jbTR5JxabL6z1SC5etG4aCiibw7fTsAzYhskpTRT+RFX59L+25UwAkzJtOU/bij1WAivz/1RW5xv7hB76gKrwMlngggp47f3ICU1PhOsNFjwIZsIDJnRXxmwz673AYR1PZxLc1+RPLRNRO/bPuKkR2RVkAfcfH48tiWDic9sSau6DRCcD1k5YPTCTg1isZI5Sh/rHF80UCdmtI0ajOgUesD00r5P2ELu+v51k3kqdpDEb13KaG3qZM/l+91Si17ob4vK4vRr1F3/MWW0QFHKffWtdsCgqHdVxVK6K9VnmLibMxOPph/7+fFZqvf4Qs/dsw1xcH2b0/UMbVkwCLogYIJv8Qo96JeNhSOLrlgTXzLyBcHZWavFbXhncjf5S4dREDOiGWPsagU712TrnbpW43v+CUttrBQ+oYKy3hlP7Qu6rViODCCqloN2DL3TUkjsrJPnqpZtqMzfSp1HPuuSXTXa6K+XYhmeE8bfbPaYnJw/rPQXcUwLmnbT0uHUBNH3J6zZ9HS/fZYwEjFHuEvDCZKKx8b4ijEftsDefSLzTfavd8Sqsal0T4Rgc9J7wmh8Jh/rYSuRpUgM3Xa2f0GSd9MCcPTDhb+zPfFjH1wfacW1+Dx6WqinhKQVqXEQEj541wG+Q7klhgTH2EwiP47AXJ3qNr1vXj4vWDsG06A7zxShdRmn1F85ySFUI1k3wFQ9fIpaDBq58/DIMiUMO6BthJVQjFEhLojO0qoXiqTFIH2NhOql0oFQayHcQuAh6xmbDP++t7X2CE50ZPXe43wSBT5LHd8bHqKFrsehphhvrafT0wwWA3/vcNqBufQz/OQU
 KsEZwY8A
 cfDboWtN0jlhtNXUR1c+84tdCcveFLcDEU0SZbpRdTDq7KBxnmZnbtr2JQmK+rmkWk9B8WUcKd3t8JqtRx2/3ljKrNHeu6sFNy7JDi4e0NNVlor4NK1QHrip9MqLSowJK1BKH1CzYyiW6iDQwAXveDGF1gDM23oUvwAtmx7vBK993kHqdvExEpmDyzleJiM+AphkjDGQ/+S5TCZzMuHhg382iS3blyA/HU998vGd4hD1uJn3ZhxFhI4yHdTWeB76W2/ZmkIdkg5Qo/uxIxfpGVf/ZV67pzKj/3jchDDzHQnQz+EQr4kQIb87GWlw7M1Ct8aw+LA902KT0Ne3taOe61L9IvSgF8kwlUJ/Tj7CAHGD2jIeEVhwbZ6R13aQFeoPgYjhk2+y/DD9QiZe7WmpSC3zkuSqjGyLnHUJLT+CuimDHrCPwfPI/bGDmFVyfTj8vjSNjRk7W3kQATxcoDcpCQ2ikfn+DpkNHGtxwES9kARl+liTP5jG7fsBIUHqEd+w8p6MZAj5gh30/WZTUUt3NptVWJlkyupdNzuyMQEid4akP/R5hlBmC9/AB/wcUjeQ+ShvYHGF4atQTuxA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 3:39=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
> > On Oct 16, 2026, at 02:15, Kairui Song via B4 Relay <devnull+kasong.ten=
cent.com@kernel.org> wrote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Add a helper that resolves a stable lruvec for a folio under RCU
> > without taking the lruvec lock.  It takes a folio directly so the
> > lruvec lookup happens inside the RCU read-side critical section,
> > which a lruvec-based interface cannot guarantee.
> >
> > No functional change.
> >
> > Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> > include/linux/memcontrol.h | 39 +++++++++++++++++++++++++++++++++++++++
> > 1 file changed, 39 insertions(+)
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 74110a324f9e..829ab776ab44 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -1535,6 +1535,45 @@ static inline void lruvec_lock_irq(struct lruvec=
 *lruvec)
> > spin_lock_irq(&lruvec->lru_lock);
> > }
> >
> > +/**
> > + * folio_lruvec_live_get - get a live lruvec for a folio under RCU
> > + * @folio: the folio
> > + *
> > + * Computes @folio's lruvec and walks up to the nearest live ancestor
> > + * if the folio's memcg is dying.  Paired with folio_lruvec_live_put()=
.
> > + * The result may be stale: RCU keeps it alive but does not pin @folio
> > + * to it.  That is fine as the counters are fixed up on reparenting.
> > + *
> > + * Return: the live lruvec, with rcu_read_lock held.
> > + */
> > +static inline struct lruvec *folio_lruvec_live_get(struct folio *folio=
)
> > +{
> > +#ifdef CONFIG_MEMCG
> > +     struct lruvec *lruvec;
> > +     struct pglist_data *pgdat;
> > +     struct mem_cgroup *memcg;
> > +
> > +     rcu_read_lock();
> > +     lruvec =3D folio_lruvec(folio);
> > +     pgdat =3D lruvec_pgdat(lruvec);
> > +     memcg =3D lruvec_memcg(lruvec);
> > +     while (unlikely(memcg && css_is_dying(&memcg->css))) {
> > +             memcg =3D parent_mem_cgroup(memcg);
> > +             lruvec =3D mem_cgroup_lruvec(memcg, pgdat);
> > +     }
> > +     return lruvec;
>
> Hi Kairui,
>

Hi Muchun, thanks for the review.

> Actually, we don't have any means to guarantee that the memcg
> to which the returned lruvec belongs will not become dying
> after the return, right?

Yeah but Qi once mentioned that RCU prevents reparenting, right? Even
if the memcg is dead after return, things happended to it
(non-hieratical counter reparenting, ones in __lru_gen_reparent_memcg)
will only occurs after RCU unlock so we can apply counter update to it
without grabbing an ref, just hold the RCU.

> > +#else
> > +     return folio_lruvec(folio);
>
> Then, I'm wondering why folio_lruvec() doesn't apply to the
> memcg scenario.
>
> Internally, folio_lruvec() obtains the memcg through
> obj_cgroup_memcg(). So when the memcg becomes dying, it should
> be reparented to the parent memcg within a short time.

I wasn't sure if grabbing RCU can ensure an already dead cgroup has
not been reparented yet. If we apply the counter update to a already
reparented lruvec, then the counter is leaked. This new helper is just
a folio version of lruvec_live_lock_irq.

I got the idea from commit de4660898b7a, which says:

"""
.... check CSS_DYING under RCU before
flushing the pending batch.  A non-dying memcg keeps the original lruvec
stable against RCU-delayed offlining; a dying memcg redirects the deltas
to the first non-dying ancestor.
"""

Applying counter update to a dead but not reparented lruvec is fine though.

