Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF8D9C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 17:17:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E25866B00EC; Wed,  2 Sep 2026 13:17:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFD2F6B00EE; Wed,  2 Sep 2026 13:17:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D13F06B00F3; Wed,  2 Sep 2026 13:17:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A1FD86B00EC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 13:17:33 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2A7FF1602AA
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:17:33 +0000 (UTC)
X-FDA: 85169478786.15.6D1FB1E
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23E8D40009
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 17:17:31 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KfZvlqkq;
	spf=pass (imf07.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788369451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L+uQOUfDo+TK+k3hTP6A5HxoVxFH7C/0s0ldwdZGHuc=;
	b=eH85LD6IfjsjojeF2HhMrd+iRK8+U+Li1tKL8LHkv0NtEtMXSNJk98XHu6XAt+nR3pIOGe
	XFGhwoFBDmGsJoAujQ4lSxXju9cIyzg1ZlCn0BKYkAcQa7u9NcHlEcgv37oYWt/y83Yoww
	/B2JTnZZNBT+P8h/RdQ4uV6fXV2pTww=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=KfZvlqkq;
	spf=pass (imf07.hostedemail.com: domain of mkoutny@suse.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788369451;
	b=7ycU6nOBo9NS/b7JIswrBpn83KbnThARNHBgYxWuS55pbCNDr/eCkad6pBK33ivFpitNa3
	HKfaYMgaXAav7yJ6g9ObtMRqe4PVP865kPLIdJMfTD8TJolTUoVKVvz26Drtq8PXYoQtgh
	QG058V5l3zWs+ZaE8sbDyCNEZgbBStg=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-485538d3499so927704f8f.0
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 10:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1788369450; x=1788974250; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=L+uQOUfDo+TK+k3hTP6A5HxoVxFH7C/0s0ldwdZGHuc=;
        b=KfZvlqkqPMmyuS9rXNRlTNoymPsT/RmHs+Q90cgzKWxdaU1y8i/bGyfGoXbFMWvLvh
         5owmqZis5G/F0lmGpZ6MM1rXOamloOpQITxufOJm+wHX/bgDZIEe8woPOmUwfQiUeaqA
         yxpvYOt42ERL7wy82cy4cdF9nwA3jbQ3AzXRUOosPgneafWHX6PG8ElUB3azN4/4Llw4
         uup0oD2+PorRE4R1PyCXUjYzcGSl8sKbDmN8l0c5DdIsGyUtrSeJv7LUPQxyS9Rmf9gd
         g+na2Tm671RTWaTA6+fqwAg988BLiF1griCqpuEq6NesqRucfiV4eMW0MSlAhTmJliRf
         8dYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788369450; x=1788974250;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=L+uQOUfDo+TK+k3hTP6A5HxoVxFH7C/0s0ldwdZGHuc=;
        b=lTqHU18rShyizdymTqMKTql+SZ+y87g5rvGUPY26RupUr1c91ZtKCWlARfw1iITbLl
         fVxAbz/ENKzxERqR33kROXj5ypDyPIh2GZ4jE2CVd514Is5dk+wK6kP98c/LJ+dO1uh2
         PjCMnBvzgCjLEumt/LiaYVjvAVR0Zp3aERxvkjmdlT9NJqirpj78v7pfk7rONY9sTf7w
         wL4XH6bAzgZcpWzJpTxa5uHUEjRk6qcxs2+pJowKtUPROqbWLOJGEZfI3alsc8F44uK2
         12LZkVF8iLd8B+ZfzMKOMCxFwSqQJ0MLPAuD3LaykivhZ6xTlwjG2oIFscEYMaOGr8Rc
         jKBQ==
X-Forwarded-Encrypted: i=1; AKwUvBywLf+EVr9mbpGfF1tpMY8uc40qtlaD6TVi4s8O+S0OH39AVxyE+BVrAwtJn03NgJI3wjy8P3UExg==@kvack.org
X-Gm-Message-State: AFuF++kpRIMT2V6aHky0NVpM5+XaTgUmyewG60nWqHIBciIAaz4aFyjD
	vQhUMJizXWADB48ar7RuzwCGWGMI56vb12OGrSpIz/AmHcQLaYgcPEQoA7c8LR+G1FY=
X-Gm-Gg: AYBFou2+WgzaHUyFC66tNWRr3dozxRgRzvnKSztbVAyaDLCI8mdX+Fl/dWDqT14AXEy
	OhJi5j3MbvkIP8UjNcjOW3tS+X/PG6P4Dp1qs+tLVUfAnDlYtZjcQ9+YLOgALNPYT5FxEtPVc/a
	HKSXhy9LrTxzgG1BdDB+NlXdagAx7IMSDV9lvjJTR0eZR7r7AdGfdiLef6SfQZV94Yli6GQtMe9
	rVhnbsbEZvL+r+2YncA4mHnX/+Q8xv8i7LxXpQOwqaVdUyH0rPFn/WTQjcTTOx/ASAVxiDD0vT+
	PBHbgKrcdd/npKDt9r39EZelhryToce0mV1jDsMnZU34LJTaK6iczAKyIdDxrZIzUmDTiERR+7I
	Ua5mbjJrSd1UD941t56j//WE71RDydzmgN0zAqOcnalcpZ1PAJbY+DiLW8R7efVJpCKGhv6IIK7
	nzV3tJEkyL5oxTYcv9uuq1PMslVU1gA90mL8DzkSIH4KNg7vWj7teHqoKS4ENfGMQ=
X-Received: by 2002:a05:6000:208a:b0:484:3310:f394 with SMTP id ffacd0b85a97d-48488f20c54mr10977496f8f.23.1788369449677;
        Wed, 02 Sep 2026 10:17:29 -0700 (PDT)
Received: from localhost.localdomain ([2001:af0:8000:1409:193:86:92:181])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48448eea5b4sm7848460f8f.27.2026.09.02.10.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 10:17:29 -0700 (PDT)
Date: Wed, 2 Sep 2026 19:17:27 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Dave Chinner <david@fromorbit.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
Message-ID: <aphXPCn8isUVV87k@localhost.localdomain>
References: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="dutiu445lzpgkhp4"
Content-Disposition: inline
In-Reply-To: <20260901115104.2944996-1-qinyuntan@linux.alibaba.com>
X-Stat-Signature: mmzr49mox6fw14g4g9gxsrrd1au13mrn
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 23E8D40009
X-Rspam-User: 
X-HE-Tag: 1788369451-975102
X-HE-Meta: U2FsdGVkX18pVREDjKWBcEDbNWFBXtqvZOVF8VX+BN88DWosm7UXg3DYGf5Ll9AxTVHemc8UDvkfT/jcfbFdckUb1UBErMzOK7M5pXC/WNu0SobwOg6dCbH16PaNrs9cJuXVEi3qfQ2l/uB4Ol0eXt7psuUOPpRJqI2ei137ZOVG3demDsxwne9BhxLlzSc/SCBjQ8hIcefyPh+xKupmio4cIt+sgN55VmOAymDJgHPjM2TUbicJzx+HLvyLX/+JGFw97IyyZNFGmaHl0SnpzGe9TPOZoJk1oV6d8LR/SFbh5OK64NdOkFcuh4lHMMrQoWtcXAwwEldQ72OlrKJocE4MHZBSwXmxoeTSBOP5pGg+YlhDC61ex1gT5YCTVVm44A0Q3Ybp7mbexpS4150lzL2ZjcmsFr7zyI6HwySsk2moZAm20M9UiLYvrTuhTGpoHXXnVhXnU6qLyTprWcCsdw0VyA+aNwtd5+pvHxpSn5blKoIfznv3KY/LrwsvjVryUtdp4nPd3w+czrPsZFc/F1jhWd16t7TXqDIdssYwpkn8gJV6diuU7MZ+Xlhf668sIKvTEutJi6X7K/vHosBXfK4dFNNbDWpd+7w5hrzAkpfo14jeHVcJLaFRkFjnoNd5GgAgohMlOzAF1tmVADt2gG7k2ta1Bw4BfxFcaINi82PBgbgDrV/cUo/IKmzo0x0zFdGf3YpuVJ7cGp6gB1cEd2WgrW87GEjNuyCQAINULuKUU7OG6kFtV53n/MzXZoyvWTgfjda5A0wt3qMfhfttLIATZNzyKl/pXSoDE8j10oZKn+ddvnG3F5Xg/e79VT/g2w/4s7RLZO1E+T0yAgO7VZee3h8TuyNgV1DXxdeFYBVqPjeOTXwEGCHOKmE/ulytqHYPpY66Vdh0FNLpNApT7jEHYjLMUpMUC7WxPV7acu9w4RSEulLTMSUIjwiwMiiqCsG/eB1PO6/EuwdxJKQ
 9CgevY0w
 omfwEM0cUAPW1lUFDzP6y4EX9ejZR2g2PuEU8UEpzn/DaaXOmyo9gjDbivmLVUUO+riGMuo3V/Iy5RHguN3pcg6mGHjx0XIVAOxVUUzK188g7UFC3sZdcow8Oq5Cs7m9qKNgNhhtJKyz0VjsNeA4vhfcg5ARYTb6I+4JYHgT7FbZDBTv1k2klabyXf/H8VrWtUJUsFa629WsOimVtm6eRw4vPvQkStDKysvbZqLtkucNKqow3xXgGcYaVFGsuVRLFRIMraDGNSjoaK0ZimCacYWVt7GVyK0U4Ah/ykG5fHLsJKIaM8W1dh6iNQ8VZvrxu/Snwb6eRpdCyMHACjpcEPlM4Nf7e9lpdt1AEbZmHseKrjz4X583EwJA/fgO0PhfzEjwq/mkexlfgA9RiZv7YC9iO466719aUybUxTRLPILXFa03ciJmrT/RwG8SqXxIR+0pY/2TLgio9aIR8IBrlQaQynaAUYtVnc2DQoMbgDfnE1A4N7+DON6XH6/9yMu1OCaZF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--dutiu445lzpgkhp4
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] mm/list_lru: don't copy stale shrinker id from
 non-memcg-aware shrinkers
MIME-Version: 1.0

Hello Qinyun.

On Tue, Sep 01, 2026 at 07:51:04PM +0800, Qinyun Tan <qinyuntan@linux.aliba=
ba.com> wrote:
> With cgroup.memory=3Dnokmem, shrinker_memcg_alloc() fails with -ENOSYS
> for shrinkers without SHRINKER_NONSLAB, and shrinker_alloc() falls
> back to a non-memcg-aware shrinker.  On this fallback path,
> shrinker->id is never assigned and keeps 0 from kzalloc(), which is a
> valid id belonging to whichever memcg-aware shrinker registers first.
>=20
> __list_lru_init() copies shrinker->id unconditionally, so every
> list_lru backed by such a fallback shrinker (thp-deferred_split,
> zswap-shrinker, workingset shadow nodes, superblock lrus, ...) ends
> up with lru->shrinker_id =3D=3D 0 instead of -1.

<del>thp-deferred_split shrinek has SHRINKER_NONSLAB so, the id should be
assigned (at least I see it in thp_shrinker_init()).</del> I was looking
at 6.12 kernel.

> Under nokmem the list_lru collapses to the shared per-node lists, but
> __list_lru_add() still calls set_shrinker_bit() against the memcg of
> the added object.  Most list_lru users are unaffected because their
> objects resolve to a NULL memcg without kmem accounting, but the THP
> deferred split queue holds user folios, which are charged regardless
> of nokmem.  Since no memcg-aware shrinker can register under nokmem,

Not sure I understand here, the SHRINKER_NONSLAB are excluded and should
still register for per-memcg info.

> shrinker_nr_max stays 0 and every memcg's shrinker_info has
> map_nr_max =3D=3D 0, so the first folio added by khugepaged triggers on
> every boot:
>=20
>   WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x99/0xa0
>=20
> On systems where a SHRINKER_NONSLAB shrinker (btrfs, xfs) did register
> and expand the maps, there is no warning; instead bit 0 is set
> spuriously for an unrelated shrinker.

Could it be that you see this issue because of a shrinker which isn't
marked as SHRINKER_NONSLAB?

I'd even go as far as pointing at
fafaeceb89a5e ("mm: switch deferred split shrinker to list_lru")
which removed the flag from the the thp-deferred_split shrinker.

IOW, the proper fix should be addition of SHRINKER_NONSLAB so that
per-memcg maps are properly allocated.

Thanks,
Michal

--dutiu445lzpgkhp4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaphaIhsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjwxQD/f1S0abo/AyOAeW4+/VMQ
3+TWP2Ib8ZUBGnI7zXfsbJUA/jJ726jOpW+PD/iuyLKMLOLJKQniOor6aBrBChcp
74cL
=fIDH
-----END PGP SIGNATURE-----

--dutiu445lzpgkhp4--

