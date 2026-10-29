Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A21C606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 23:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cd9jirO9
Received: by kanga.kvack.org (Postfix)
	id 2ED9C6B00EF; Thu, 29 Oct 2026 19:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C4D86B05B1; Thu, 29 Oct 2026 19:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202DF6B05B2; Thu, 29 Oct 2026 19:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EBABA6B00EF
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 19:09:34 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 11C5EA8115
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:09:33 +0000 (UTC)
X-FDA: 85377207426.04.A7CE267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1903B1C000A
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:09:30 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cd9jirO9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793315371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SxAccaK9CQKKqijAxHgkuHdJDdULygHNWNh9e96YezM=;
	b=EgWW/6OjVviNeYHwYf/52Cxzu/wgqSwH6TjQmSoUVVrkAQOjO4L1S6HyAf0cREVaOp9Y1C
	aKCQWpkUpKmalVTBYc/FZwOmdo371VpCyI25NsoP3+fdLLIpPvfercp9NBvEhLogcERUqx
	tcAC5aAKaxX7FuZju4AtmaXjlj83khQ=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cd9jirO9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793315371;
	b=V7p9vPgErJImIq4ukyL3XJENZh+1izzuC+gTvbSQsPvs3UYpe/Xub7PAE+B0UQD76dpHEV
	iipVXfDgzR7hTLbSLbKNtLm0xnIUfhEsp3zkyJ0DXVTpkNXxBWY1s8mKB4TOVqP3JJacg/
	IbVmkNMboQ9GY0KXjaeZ/cPPXLIVQ3s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E133443DE7
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:09:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C636C1F031E0
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 23:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793315369;
	bh=SxAccaK9CQKKqijAxHgkuHdJDdULygHNWNh9e96YezM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=cd9jirO9W/+vRVFDbjADdAp0u5N2Kmb/GKL7qLaLbHWNxWybKDCURefBIedJUWnSS
	 6/wCareaJPxjAlus2f3zM2c20cRCt++ZPhvdB1eub4OjUE17sps3XjTueKFNY6BJTd
	 2Wmjt0iPz3673rly56jk1ku90ZOCLY5peM14pb9bt9+oDmgB/Mo3IU6CiHhS+Rb1wG
	 Cus/8q3uLUxCRYz5DwNQzGsMKWPXQMkxq7K6Xlebz6PMuKumBDGsNfq4xIQHIDdizP
	 ZQoTXC7m2Hg6OoXbc8mBkHDkA7pnZPa4sCpKCab2s2irMensJU2Zxb7MreQLSAcCyk
	 z/MUB6SsJ+pqQ==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c4550d8ab15so7318666b.2
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:09:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBxOgNRgFxvVafuPBneFPMHOX9g6GWm8uCoj1LGkicog3xUV9aGJzSo0r4GQ+3EWWl8t8brIHP8yyw==@kvack.org
X-Gm-Message-State: AFq9FYJBIyhGmKZ+g7Y7V+2maxvNyD04zd76ZWw7CLvxCIBhUNSIwRmz
	9KELr6irtBDLSwPSDA6bB2qZSVN2FR3cOBaUL2lvisEvL9bzy+LqRW5cd3/nhG96Cr90lJiYA4g
	aKhi+i6BP6dsjb/M3+ofiuDKmK9tHTLU=
X-Received: by 2002:a17:907:6c17:b0:c41:9228:baef with SMTP id
 a640c23a62f3a-c4ca7a54fa0mr46411166b.8.1793315368743; Thu, 29 Oct 2026
 16:09:28 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261028030503.17923-1-kanchanapsridhar2026@gmail.com>
 <20261028030503.17923-6-kanchanapsridhar2026@gmail.com> <sashiko-outbox-188657@kernel.org>
 <CACpmpofjVP17TpyieQ2khsdRL+FMX9oCEcaNE9Hh+vBfGBO2dA@mail.gmail.com>
In-Reply-To: <CACpmpofjVP17TpyieQ2khsdRL+FMX9oCEcaNE9Hh+vBfGBO2dA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 29 Oct 2026 16:09:16 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMxUZxWjZaRx8ZK69qQBmd9EQ3OY3kv8DDVsuDky_7Axg@mail.gmail.com>
X-Gm-Features: AclHuK88KyLz-z--PbBy0WnVbdAZWcqI-BsmnnLL1fm3tmu9BUUE_ZogzqpNpS0
Message-ID: <CAO9r8zMxUZxWjZaRx8ZK69qQBmd9EQ3OY3kv8DDVsuDky_7Axg@mail.gmail.com>
Subject: Re: [PATCH v2 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: sashiko-reviews@lists.linux.dev, hannes@cmpxchg.org, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, 
	herbert@gondor.apana.org.au, davem@davemloft.net, 
	linux-crypto@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1903B1C000A
X-Rspam-User: 
X-Stat-Signature: jkibw9m4ayz1rqcefw9hk4qkzwfirudq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793315370-469526
X-HE-Meta: U2FsdGVkX19sNbCHLlIPaCg6XuDEojagv0xdp81/e51qf7gudhTq3iF21FyYtYDc25PMBePtipRegGXWgc67L6d2wh1Ua8mAyixnMd1YwZWg8P2r2iuail/CXz5YiiNf4EBLJnPzO2AfUJpwOg5ZAScAgxomTP7kaFkHvh5/sfJt6Smmx43dKhvN6Iqh6xTSeO3zCd1+RfYJo26btiyLdl6KPVR+5LJmhI7ZidA8AO/PFUHYiEX0LrfeTSNuU1/aGBCHCwtkCUFunxPj37yqoWVoD7Mbms1mSijzYorMkeak4Nq9wUtT2S8JHVQecJoMU3kZE0f1ElgbEg4idaqZEdRa8orWFbAYKeEZNPmTKy3xf2tu3xeaROZpUPGFReE7fMSNYWC+DYEvS3myBhh/kbOruvlMjnoAkw54uAWvawxGRUdlkcIcMjMUCv9AiMaSujACg0fg1jK9LBnnafmoPp1cw6PIJ6Hm5oi8FRIsAlxfzXoNMDf9YXknCtbdmdEf7YKVuKQBLQ5E8J19NQ4phJ+wOtQBEjnma4cGiuGu9Xa+aglwvW/SBwdcUcExoYZsYogfU3Vs+ZybC/VGVuYhD//FUWyyhR2o9s8lqXem4q+Lr4eBpp6do4G3t4evPMqO5bAPbleo9/J0OhR7B812F11U646oAFjfh12MueNIfqJZJIqU1dUkWFUsuh5zQBZFwOx5CAlWqv4URonAqRLZ7r2vfKuCuRTUgy4dNq2p4dch9jZq3eAQCqMf1rXx9i+pUYOWgVrwQ/+0mUuilQmB9nY+cuaXE/h1TdEKtoGOhDQLZrBhdKXfAt704QXqoF+6NKRYKUa5dZrzYTMeZaZDsHgm/wf6uAK0XTw4qs6Q2h/wuqgksasQMl3cmseluLVjaTNLsoZq0McF9SGnjVw4LDY/N7rlnfUqxZQxAqnfsOzu0Oj4/U3fJpLtj26ReOyM+P+NBxLcy4z/OnaDCdt
 0wTYJHng
 19NxULetoxrbObIwpRL8bHx/YInYbCxvgaP2W6F8c+NMGmF8Hjb3TsIcA8ZIV9fG7wMwEseh9PyEF2WilGId7GeKb3Pl/cSUKiQ1oEOORCeDovcJwVHuEm0adYzjD2F7L07FoKHvF/+tSM1qoxbosrL4xv0kE4GbAljraHqW2J5ItM8UaLPPTmzUB5qH/vzfDTlFfAjdDZhIcXs+ULc4OnRuKXzbi7zDqaGFiBvFCHr9+R2fbIEIP7dSGfSX2Hnzv1KZrLSqWPONi8PjynPL3kjFIk9vsAq4SKyKtCiVofpqyD0ElIcaSe16SDdMw2iqJMgysMVo7t28fP3OD08MjO9AHYlLnrsNuVf0w4JNp2zMpQPrk3yRwjmqsLMahEvxeR50rnLaYnj+sQlTtpOwz3ojyqFIMn8g+6sMO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> > > @@ -1507,9 +1506,10 @@ static bool zswap_store_page(struct folio *fol=
io, long index,
> > >  {
> > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
> > >       struct zswap_entry *entry, *old;
> > > +     int nid =3D folio_nid(folio);
> > >
> > >       /* allocate entry */
> > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio))=
;
> > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
> > >       if (!entry) {
> > >               zswap_reject_kmemcache_fail++;
> > >               return false;
> > > @@ -1524,6 +1524,7 @@ static bool zswap_store_page(struct folio *foli=
o, long index,
> > >        * to an unrelated live pool.
> > >        */
> > >       entry->pool_idx =3D pool->idx;
> > > +     entry->nid =3D nid;
> >
> > [Severity: Medium]
> > What happens during cgroup or pool reclaim in shrink_memcg() if the swa=
pped
> > folio resides on a NUMA node without normal memory (for example, a
> > ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)?
> >
> > Previously, entry_to_nid() derived the node from virt_to_page(entry), w=
hich
> > was allocated from slab with GFP_KERNEL and therefore always resided on=
 a
> > node in N_NORMAL_MEMORY.
> >
> > With entry->nid now set to folio_nid(folio) in zswap_store_page(), anon=
ymous
> > and shmem folios allocated with GFP_HIGHUSER_MOVABLE can have an entry-=
>nid
> > that is in N_MEMORY, but not in N_NORMAL_MEMORY. zswap_lru_add() insert=
s
> > those entries into zswap_list_lru for entry->nid, but shrink_memcg() on=
ly
> > walks N_NORMAL_MEMORY nodes:
> >
> > mm/zswap.c:shrink_memcg() {
> >     ...
> >         for_each_node_state(nid, N_NORMAL_MEMORY) {
> >                 unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;
> >
> >                 shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, mem=
cg,
> >                                             &shrink_memcg_cb, NULL, &nr=
_to_walk);
> >                 scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
> >         }
> > }
> >
> > Should shrink_memcg() iterate over N_MEMORY instead of N_NORMAL_MEMORY =
so
> > that entries from movable-only or highmem-only nodes can be reclaimed b=
y
> > shrink_worker() and mem_cgroup_try_charge_zswap()?
>
> Conversely, is the previous behavior correct? The entry is created on
> a node in N_NORMAL_MEMORY, and when that node is under memory pressure
> the folio (allocated on ZONE_MOVABLE-only or ZONE_HIGHMEM-only node)
> could get written back. This doesn't resolve the memory pressure for
> the node on which the entry is allocated.

Yeah I think the previous behavior might be wrong if Sashiko is right
about the slab not being on the same node as the page.

>
> Nhat/Yosry/Johannes: Does Sashiko's suggestion for the shrink_memcg()
> modification look Ok to you?

It seems correct from a high-level but I didn't look closely.


>
> Thanks,
> Kanchana
> >
> > --
> > Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261028030503.=
17923-1-kanchanapsridhar2026@gmail.com?part=3D5

