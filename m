Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EC08606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 21:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=crzk+d20
Received: by kanga.kvack.org (Postfix)
	id 9C3B56B05B5; Sat, 21 Nov 2026 16:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99BF26B05B6; Sat, 21 Nov 2026 16:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0F96B05B8; Sat, 21 Nov 2026 16:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 629C36B05B5
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:22:36 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA03B1405E7
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:33 +0000 (UTC)
X-FDA: 85460400186.02.C72D3E8
Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id D728D160002
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 21:22:31 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=crzk+d20;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795296152;
	b=0PS6fC69jDYvhw6fO0W79M8aW0Yy5NWQZ7R2VYczdzg8UrmO0usa9WtLXygGIbpk4E1Fk8
	ZugDC/S6/odFgO5nWqdz/3FCjJkARDWCRiEFwrD1nIWFzkzIo/KCNw0ukgEnxIjvDqscCi
	cG4HEn8QN3kEFx0LLWESYOwn4HM/Cak=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795296152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
	b=1CCIe87iLfaP+8DL2LwnkidJQonV9I44I/sdLSCgdXXtHn4Gr9N4/S2ikq3tkE3eJ95Ho6
	VbdkRjVyLmggHXkTahkTht7J39yM/faJugGRVd0tNNsyQq2aDBjJQDoFSc4vHI73IHMoDY
	EvpXv70UZtW0ciD2/Qbew3BrNZJGuq0=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=crzk+d20;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.171 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
Received: by mail-lj1-f171.google.com with SMTP id 38308e7fff4ca-3ae25d9e2fdso20440351fa.0
        for <linux-mm@kvack.org>; Sat, 21 Nov 2026 13:22:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795296150; cv=none;
        d=google.com; s=arc-20260327;
        b=cbh/lnER1lKV+Pfs4z9qdhkwPjfTD5Lm1iKt3CRH7Ebq82D1fzxo6yuM3pP8L88+gZ
         w8kjQLGW5zgokjUpjbkn17jLshghiZnHWip7dMyFgz1hGX6blwQuPyz8vf+CPQab/X/F
         QHK5ISUe+eKY2kJszGrIAAe/Ch9ciUL0EAPJzuZT5GvBXQ3ZZsjqkgPFC8XzmsTsTsQk
         HLWcpukt7mrmncjzXnakOyAxKetdww98ksBlu+3a3SjYcacGzCOZaOe/AkThbzZ7LbcG
         5kW+J1xHfqrkXz59A8lw9+QGyvRoGTz+jJjESLZaSpHDzB0RuMiMcuWt05Y0Y1LMIM7O
         buCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
        fh=XqhoqEtWU7Xr3/zWiRAauxneu9eAEYrXfgzQsEkcgwI=;
        b=pgpsWKSWy1gqC8huGze9yJM/Yt8aQBklp6wNOGG0/QIgqA+gvtzr1lRjhlTEbKlwSY
         8YhLTC5dUyJ96mUSWv0Nby/zyq15j3t02A8NdEEBgkBv1yUxrfFgRSiaNokhVj+6QkO3
         RgeKoubM/k0P+eBogsl3gYYz+hMzGULDs6J2P3+Kb4bYIZOc8dLXXjcgjJKP7UwhHOxo
         lGFXRBNiESPOsvdxIGil6XExco5e6W2jswR4InihtaT5sjbCvG69PQXDJPgnVNohjXNz
         q47JNX0uIg3qoUXC/MDORzqE1i6XYcXouG7iHvVBSP2i+J4VT82+BHPt+dtf8Q8BX4Fy
         8IBg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795296150; x=1795900950; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
        b=crzk+d20gQVMQ6i7173G7pqSAepsJxBFfA1YEYQPBUKoNjwXTVcvPXhP8vxRGGdyPb
         ULOdmd4rX7ykUKsm/q1sMdneLQejBy6iYcryPM45suABGwLJoYEvIVr2NEdNM469ocG9
         cA4NEogmBLE2P1clZK7HBJVsI7SoP58I84T/bUAZ7xwOCW94gKyrKvqSSvQyLo8dY+UH
         CHzeX1xI46PQrd7V4BrVqnSeM4xGtY5oHViq6PAnXESwgWDPkGTCcrZQ3fOPff0rcOSJ
         nXOKisOLSIrXdeWxLdf5VjUbtLABhL8pdLW99cvqJUoBYmg/6c9TaCCNJs26da+F2U+I
         J4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795296150; x=1795900950;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rGcrw4mT7NdiqFu7SkETRkItggb0uYK1nbamCet3nRg=;
        b=ix6kpAwQXBExrxFTgtj1I/hGU1rAiLwFE+oOhkoH1DsZLvj24TQvgkQujOqqCcWfjR
         WRp5Cxoyb3uhRYuuRGbk7Jrt3YUynNlz4ldOgKwlSaWOnXu1QBWCZF3Or+qN5AJ9Gwa9
         qpZjvP/3gWNc6ElybiA9e6PGW3XsfKjRlhJzbiDoCQl/iENbU0ZnctWRADMZ8N6yxFdd
         AOTQCVJBJBOER5JFgTKYIffTC/QAPsU8JnBGE2xdDM0QVzi7WzqG1carI8laBqjYjHro
         VPJgacf3nISq0H9Eb49+8q+YpAalJDq46e2FElng6X7GiH5i/T0QpAJeF7ESjwDsvOw/
         hpzQ==
X-Forwarded-Encrypted: i=1; AL+hErG+AFX3m/23fsqlT/xm1OjiaJ8GnlB1uAHRtoHdK1K3B1nyCPihympUdLdfv6JFFIxJI5jpYIHP+A==@kvack.org
X-Gm-Message-State: APuU4Z+24Yi/buiyMsPayyWv5ZEtIMX3bL49FsxtztgHp9zcIODGR/Fq
	gB/9xwFJ1ttkPuDjYYmo7NOvXkWzwC4VBun9kr2js7Mx7k56vpPSLCNtFol5ijQHm9Gn+FKoSll
	xZyxC+fRIhYeCumdZIh+u5UTwHW4m5nI=
X-Gm-Gg: AZFdTZfinCe0NiwkF5oa26hUWoyn08WxZBElKUmfprud4uq9p30MHhA/6QV6vJbjGfR
	n1ILN2aBjrqlolOCMP3Yrq2ojm3VcIZjFguPQedl5PtK/9R8Z6U92tkEMWRSIRNkYf2BhJqAv5/
	fxWHNNj85CRx9yEkU5fH0OKUviBqeSk9gXfSRUQwXGJbjoRAVxjpLCeyIqQ7Qwz1i1F5NsW+Oy9
	DMinuoMT7DD1f0EqHWR3orU/PJZIgzSnTs9LSuZZ9CvK+685iZwlQRguwpcvxL/hMDZnEYDUS0l
	Bl7aM0e1XLjpiZLkO6yvB/DN+NzECiGxa7fyuzO2niN61bsgYFKCNCzS8259xnTgFDRK8nhBRIU
	8rsXUf8Cbi1lLPuHOHcKrZqNwqtviSf/VEL8E
X-Received: by 2002:a2e:b8c9:0:b0:3ab:344e:373c with SMTP id
 38308e7fff4ca-3ae7f9d5f36mr20017261fa.5.1795296150106; Sat, 21 Nov 2026
 13:22:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-6-kanchanapsridhar2026@gmail.com> <sashiko-outbox-226635@kernel.org>
In-Reply-To: <sashiko-outbox-226635@kernel.org>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Sat, 21 Nov 2026 13:22:17 -0800
X-Gm-Features: Aa3M54osTYEDX87du_Iyy9mI8Cvq-0UULn2mX3Kv6V_zPCZindyaWLd_Ecpy6sI
Message-ID: <CACpmpodVacE6-7=sOh7-odaDytspcH=+9u-B0-zkO6c8W0JiwQ@mail.gmail.com>
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: sashiko-reviews@lists.linux.dev
Cc: hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: yba5de7whueuguxatdrdyn8b5wx9pfwy
X-Rspam-User:
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FORGED_GMAIL_RCVD,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D728D160002
X-HE-Tag: 1795296151-341906
X-HE-Meta: U2FsdGVkX1+N57OZSLqRn4s3ODU9xJTYK0NKYhOGzf6zKAg7RDJ2GQMEZgeDHNik8mBcHjbp+NHdnqAN3YfHWab2lU502ieHVD53rOrOrLhS23kBaSXvpsRhUXoOKPoKhFmMgcQEgiGQmIEKowXYJ0d5EXZCGqPsz+q8Cwukhpq0a9wbLPHuvE2EFP+6i9SqbmSqS8aLCjWTnLjsQhuz749lYrLUSH9RTHwBbG25f7lXgFTrXamXnbsp/owWL91/feIvwsvefbwY09EFnn7cLY0bwRaB9knJjxUeHS2Df53BaxBRI8g/XdpPijXdThEtDuW/lUerM522cMDGgo2u+WlWai/EWeVrR9ChV4DQMWVXH3EWUOWYtR+Iyyd92rgCezo7dDNHoaL/QXgbmlTxwWvwyKwMjRwIQSBrfHUjYvExfW1d69sxlzugA74TRrLo6UjWuleLCQ28CYaiszQ22JWoYjjbU07pQK7LMd/95shIvXotop9eK/YHR/1rfhnt68DzDgDPQzkG/Zz+Z38vGRjQq4tRjw2wv9FnT5cWp4oLrI5FQMC8biGUGRxrzfQBnJtxLdfi/UqbJ03Xi0ojdqq6jvq1EG15kbJ7KmfN6YYVU5QeNfBAaCf5G5obhAVY0+LKkW2X5wThVqNWgnJKAqpm7C43P0hU9GlhyPZhWxPNslgftUdlQoeVjDFHFAPFlcYWYZO2hQf6CgpnYwYS1qT+gzp+I3aWURYtSDIIkue3WkZ5qPBytLgqaOn+IOJ/nv/RbLeH7zZRgyeyM5ZfiNpV1FBGWOG9flPWWPKZKb9t13xk//CAi7gT2P5Ba2/oHUexHLzT4u2LzPSD2auy0Fs6ulDtgKnw4EQiCsy8TDC+1NOwtfe6/KoS8fG7imd8Ownt4nKSCCIVKBaG5ftBjSGyZ6tBdojOCgYsroMjaxptAMUTFCMM83Ndzo4/xLzlsCNZ6CtFOCdccXextWj
 cOrlVA1q
 6FjgeQVsRndl2mQHAcf4YnMY2MQPzNwzRZxSbX90VRYJuTY8rq5JRRSKJXH/GY2TiMItC0npQTha0pRoOUkZZe4HkOxUxviQcSjPzzSEmIP4GzbN3RDatLgI9/aD/bSs196Uo/Q1+AHX0IChN8btDLE6Q68NwZffyPZ5x/pX5tdfdl3Ig9Y9MMLJpHHtqu6tdXU9WLDGc3CTT9Fd4o/h293jYzLPtmy4kl4dqUXzURZenXvQ3g6JJrhe5ZRZVoMCat7cewsxRUs5GoynJ85Iag32O4hTf4WEWmSzVs8OtK6y9k2FBQ8XCn60cbyZLgwmaujZpWes+5Vsx21yhG9X51RniTDwjWjlA/yyVG3y4YiwRF0vi3CW2M1Oh4AOlYm3gp0KUXPy5yI2iK+B2H66ZiHiXOJMCO7uwTyrxJ31tPe2mkeqxi6Csw+ja10SbjPcPFQjqeoe9OMEZypTkFfoQqFXH6m8cVqhTR6OAFowVpG3yJ0zRH9pfvt3YGgFazPkAWpdH2W0pR7URs+H0Z9kR8q2J4uGJXuiADnapHEAs8mOsEhBoJPyEAf053o10sNvBhiuR0E8Ne9xfzwOypsuwQ+TMF2bFh2O/9NumBCNJPlfkkFT8tHJUshpjMEvxKE04aFYno9tRsLr6tHPZpe02lxZsFZ6YGo2cNN88OXLYfXYe6NDHwY15eDMysSHlNyxJNbxS+pPkQnp9N6EBpOx7q3OFzz4vJ231++zggcyeiXl2aXaSyvEwgqnLSQoZFgkmGXbvrzUDaefJ/ZQ45wD1FGKxHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 8:20=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in
>   zswap_list_lru
> --
>
> commit e4e47a21782dc39867fe81289fb7e9ed7f2692b4
> Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
>
> mm: zswap: Store the folio's node id in the zswap_entry.
>
> This commit stores the folio's NUMA node ID in struct zswap_entry and use=
s
> it when adding and removing entries on zswap_list_lru, instead of derivin=
g
> the node ID from the slab page backing the zswap_entry.
>
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 9a323862bd59d..78d9694f75b5e 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> [ ... ]
> > @@ -680,14 +685,8 @@ static int zswap_enabled_param_set(const char *val=
,
> >  * lru functions
> >  **********************************/
> >
> > -static inline int entry_to_nid(struct zswap_entry *entry)
> > -{
> > -     return page_to_nid(virt_to_page(entry));
> > -}
> > -
> >  static void zswap_lru_add(struct zswap_entry *entry)
> >  {
> > -     int nid =3D entry_to_nid(entry);
> >       struct mem_cgroup *memcg;
> >
> >       /*
> > @@ -704,19 +703,18 @@ static void zswap_lru_add(struct zswap_entry *ent=
ry)
> >       rcu_read_lock();
> >       memcg =3D obj_cgroup_memcg(entry->objcg);
> >       /* will always succeed */
> > -     list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> > +     list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
> >       rcu_read_unlock();
> >  }
> [ ... ]
> > @@ -1537,9 +1536,10 @@ static bool zswap_store_page(struct folio *folio=
, long index,
> >  {
> >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> >       struct zswap_entry *entry, *old;
> > +     int nid =3D folio_nid(folio);
> >
> >       /* allocate entry */
> > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
> >       if (!entry) {
> >               zswap_reject_kmemcache_fail++;
> >               return false;
> > @@ -1554,6 +1554,7 @@ static bool zswap_store_page(struct folio *folio,=
 long index,
> >        * to an unrelated live pool.
> >        */
> >       entry->pool_idx =3D pool->idx;
> > +     entry->nid =3D nid;
>
> [Severity: Medium]
> Can shrink_memcg() miss zswap_list_lru entries when a folio resides on a
> node outside N_NORMAL_MEMORY, such as a ZONE_MOVABLE-only CXL or
> hotplugged memory node?
>
> Previously, entry_to_nid() took the node ID from the GFP_KERNEL slab page
> backing struct zswap_entry, which was always in N_NORMAL_MEMORY.  Now
> entry->nid is folio_nid(folio), which for GFP_HIGHUSER_MOVABLE folios can
> be any node in N_MEMORY, while shrink_memcg() only walks
> N_NORMAL_MEMORY:
>
> mm/zswap.c:shrink_memcg() {
>         ...
>         for_each_node_state(nid, N_NORMAL_MEMORY) {
>                 unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;
>
>                 shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg=
,
>                                             &shrink_memcg_cb, &ctl, &nr_t=
o_walk);
>                 scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
>         }
>         ...
> }
>
> Entries stored from non-N_NORMAL_MEMORY nodes will never be scanned or
> written back by synchronous cgroup limit reclaim or shrink_worker().
> Should shrink_memcg() iterate over N_MEMORY instead?

v2 5/8 response to Sashiko's comment:

Conversely, is the previous behavior correct? The entry is created on
a node in N_NORMAL_MEMORY, and when that node is under memory pressure
the folio (allocated on ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)
could get written back. This doesn't resolve the memory pressure for
the node on which the entry is allocated.

Nhat/Yosry/Johannes: Does Sashiko's suggestion for the shrink_memcg()
modification look Ok to you?

Thanks,
Kanchana


>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.57=
85-1-kanchanapsridhar2026@gmail.com?part=3D5

