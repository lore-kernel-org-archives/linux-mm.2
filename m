Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F463CA5FA2
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 17:36:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D6B16B0088; Mon, 28 Sep 2026 13:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 786BD6B008C; Mon, 28 Sep 2026 13:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 601686B00A9; Mon, 28 Sep 2026 13:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 32F366B0088
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 13:36:43 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BBE9AA02B2
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:36:42 +0000 (UTC)
X-FDA: 85263875844.10.B3C5A8F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 299741A0007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:36:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CdVMt+Fz;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790617001;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xXafi02ZLO1Y0xc1WsCP1jTVPyy0rIJ0X6evEJWG+Cs=;
	b=JL6A0WR143UK6Fb9syHVu3Q0O2JekBP6GfD+S4KxN6pVO2VR3YsPq5pdLWQXhgce/VDav2
	lQgFhkInRa6vjPLg6tpH2GT8QXLfesiEdgSuaRyqWYP9/HatGFA5Ale5PbgsyyGH/wEk7I
	XnCnMFu+hay/q+MyYS3780O8+gPkURU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790617001;
	b=NGaJJVo41RF87GLAqidT3ZBjwKN9Hhj6Gimu4uXZRkUzRcvrb0QFUnjfRcTDMh0MG8XjyT
	G2NRhLuRDiCwAOjYg0f2PAG7rOGL54Owaed0PgB8bcWrOV2TW7K1f/NaykdnJpB9SCA0cu
	XXSmuO6m1dZUhHtm+uZAuDHJYbZkRw0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CdVMt+Fz;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 88D0B60120;
	Mon, 28 Sep 2026 17:36:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78B211F000FF;
	Mon, 28 Sep 2026 17:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790617000;
	bh=xXafi02ZLO1Y0xc1WsCP1jTVPyy0rIJ0X6evEJWG+Cs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CdVMt+Fzf8G8t9rbknnGaVrM5SS+D6vf8+Yoh8W6ZNN6HA8AwFKbWq4iAqfZXz+Ft
	 d6MVIyxwinfxhUDgeSbx7Dog/6xDVinP9/nnAQpm3L3BeHj6F2w9uLhGMX0RIwqRFp
	 ow0hYfT1lH9zRieXdzWZTFJ3OuwSjepCBV16JWZsA0vXLvh1ZOhMNs5F+OsbJov4tp
	 Rvcjcg0CXhk62W2ijvnpQb0dh5CrMyp0hQ+z20rlXdt1LlRtr6DDTzOnq5FPBrwN13
	 /j0jojUVX3IMJsrMgcEwhZ5ROe55Wv7PFan2FBHF9O9li/r2rx/qWmXuyEF8Ks1t22
	 NGObYvk9JQFvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 02/12] lib, kexec: Add a secret pool for key material
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rob Herring" <robh@kernel.org>, "Barry Song" <baohua@kernel.org>, "Matthew
 Brost" <matthew.brost@intel.com>, "Zi Yan" <ziy@nvidia.com>, "David Howells" <dhowells@redhat.com>, "Dev
 Jain" <dev.jain@arm.com>, "David Hildenbrand" <david@kernel.org>, "Herbert
 Xu" <herbert@gondor.apana.org.au>, "Andrew Morton" <akpm@linux-foundation.org>, "Benjamin
 Marzinski" <bmarzins@redhat.com>, "Michal Hocko" <mhocko@suse.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, =?utf-8?b?SmFuIFNlYmFzdGlhbiBHw7Z0dGU=?= <linux@jaseg.de>, "Mark
 Rutland" <mark.rutland@arm.com>, "Kiryl Shutsemau" <kas@kernel.org>, "Catalin
 Marinas" <catalin.marinas@arm.com>, "James Morris" <jmorris@namei.org>, "Rik
 van Riel" <riel@surriel.com>, "Usama Arif" <usama.arif@linux.dev>, "Mikulas
 Patocka" <mpatocka@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, "Lance
 Yang" <lance.yang@linux.dev>, "Randy Dunlap" <rdunlap@infradead.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Byungchul Park" <byungchul@sk.com>, "Paul
 Moore" <paul@paul-moore.com>, "Lorenzo Stoakes" <ljs@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "David
 S. Miller" <davem@davemloft.net>, "Peter Xu" <peterx@redhat.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Harry
 Yoo" <harry@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Arnd
 Bergmann" <arnd@arndb.de>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, "Oscar
 Salvador" <osalvador@suse.de>, "Pedro Falcato" <pfalcato@suse.de>, "Gregory
 Price" <gourry@gourry.net>, "Mimi Zohar" <zohar@linux.ibm.com>, "Saravana
 Kannan" <saravanak@kernel.org>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Baoquan
 He" <baoquan.he@linux.dev>, "Jann Horn" <jannh@google.com>, "Serge E.
 Hallyn" <serge@hallyn.com>, "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Muchun
 Song" <muchun.song@linux.dev>, "Suren Baghdasaryan" <surenb@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Alistair Popple" <apopple@nvidia.com>, "Jarkko
 Sakkinen" <jarkko@kernel.org>, "Ryan Roberts" <ryan.roberts@arm.com>, "Danilo
 Krummrich" <dakr@kernel.org>, "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Alasdair Kergon" <agk@redhat.com>, "Will
 Deacon" <will@kernel.org>, "Nico Pache" <nico.pache@linux.dev>, "Pratyush
 Yadav" <pratyush@kernel.org>, "Dave Young" <ruirui.yang@linux.dev>, "Ying
 Huang" <ying.huang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, kexec@lists.infradead.org, keyrings@vger.kernel.org, robh@kernel.org, linux-doc@vger.kernel.org, conor+dt@kernel.org, dm-devel@lists.linux.dev, linux-mm@kvack.org, linux-integrity@vger.kernel.org, devicetree@vger.kernel.org, driver-core@lists.linux.dev, linux-fsdevel@vger.kernel.org, "Eric
 Biggers" <ebiggers@kernel.org>, linux-security-module@vger.kernel.org, linux-crypto@vger.kernel.org, linux-arch@vger.kernel.org
In-Reply-To: <20260928-crash-memaction-upstream-20260921-v3-2-e511e9ee2329@jaseg.de>
References: <20260928-crash-memaction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de>
 <20260928-crash-memaction-upstream-20260921-v3-2-e511e9ee2329@jaseg.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 17:36:35 +0000
Message-Id: <20260928173636.78B211F000FF@smtp.kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 299741A0007
X-Stat-Signature: 3dmsbpphf1to4nyki8aeonqbsd6e1c9k
X-Rspam-User: 
X-HE-Tag: 1790617000-270434
X-HE-Meta: U2FsdGVkX18q6m3AKBuZozR8jS+z1FANz4U0Ww3GP9ET6n1pLJSBc/ygNwW6XBigOzsQJqi21KGLzCYRG3cdUfsn3KRn6RqmtSi7KCQJ5E84iq90QtbH6D+jNyW1/PVcCYEXcVuAwakrd1XLBqlVNZZ1ZgPqbl1wVnH2hJV6zw1Tch6q8Td0COddZzReWo9PWkWuwDatzdaVPWpvyIf7zvvHDjBqps3M4cNvSiFEcCUWOKS4zNoLGqIT1qQ/+CPZhBUMay/7uExXZ2HG4UjvtdndBVQ8wCBAY0MpPelpJaUFtud0xmU+rYC7KXne6ctvVfuKVNgTau07X/ZilXwgOUAF0IZdu1Fn8bqpVoq5RCIhYqrbVIuqJNRtxzzsX8hb7t0BZkce0YS0O900AhktCicc3Ea0ICZmtu9czUvBt6cmx3jxdnnY9yzowZQap8AP8Aj4GjYsvyUI6Wi+xBQQBMd3yoxTXqMlkyrFVyRr7E5sLjDjH9tl5Ov/STFURUF8BKzMEHydVg4lQLiFDMQQ05Z4kEFCrwhrD3sjPDhXHJt0jRRuDMfeAioGZqNFSaGrL86IFNChn1ggIb+icbaOGD48At8tBv9YOJgNQ6d+tVUpsU0NWM/WqpTRDcYmcexwsEP+12pGU2/CE7DbKkT0e1l9tq0JPv/6bUqOtEVmKvKFA9vDPievBDpvwhvPRCDkz14cDZwHpSh0VHMr36QV87dOamr26EwITbeXpuYFGsQttKS7tGrrn+6+trAHkxa4+2/o/XJXmhABF545lVdhj3nS83pm7J5TwAr6x7FlcKer2njtsDG16+X/ABaY2iww6TLtBKN11vNZoVSjjvlCFXEdDUI6XNiIZavCffVge7715kg0Vfzjh7XktVsONOMQ1lZ4Vub43/vnRyGUcb5ZsV1FtNtksaoT318MkGqlJOm7z23SkpHafGv3lQLXIMUVa5tD2vFZ5aEn1zBMJT7
 1Y9BN8pq
 kvrS5Uv2s+ifucCyxcodQ3aw+PEsi1zoFbSH7bD2xpik/yavwylZq2hYAd0gGWZnm9/k2rmOKTEHqdGXCJC/oPTVtYOVVJcrddAxKtc0fXutGDp6E/I/ldgdgFeViejbxYleA5JmdtgWORALz1POON+PRYO7NjkgTDCZU9NZ7RMp/qj9L8LUKwOIxSY6ypXd8K9A0dDFW4euYe+2BXDJCAVB6C+5mOFwpjQsRarUT+CJLKknw+VZUNgAB81taCeE4uKq29+IhZEOUkOcJVho7K9Zie2oTnnf7Gya4tegLhhM91aRFj0L9i2ahVKpgvPd5PXMYxl4W98NXexisS8hm+rL4MzGYYwvfZLwGgmfGX8s537TrsLjWRLApKZfoFaYr3eDjazeLMJ1ER2qULieBPeum9tgO93lVxGc3lPADiOy815IIlEXVPI8QblZPdZMIgpWvjDbFPGo7RjZaiL/PIMCpw49JS6kvHd8HNZJUbyr7vg8WRLTXEFN9n0ZydVts7zTzD0ti0CCQQ285uNYA4m+CJCFEv1eFKiKwHIh0rORzj3xlSWYvJHI0wmxJ5vS2wPlBo+Kk6X0BSyJJsbkhU+H/I0FF/cbsMi8o9kf4O53XytI9gKdbPJH3q1jY808mlgHF6b7K+oC6gInF0HfpILoX+dS+kZgPV6AmConzPho45bE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] lib/secret_pool: fallback to shared kmalloc inadvertently marks en=
tire pages as secret
--

commit 774a436bfd0576d919ce17b831096d5b8c8dbbb5
Author: Jan Sebastian G=C3=B6tte <linux@jaseg.de>

lib, kexec: Add a secret pool for key material
   =20
Key material allocated with kmalloc() shares its slab pages with
unrelated allocations. crash_memaction marks memory at page granularity,
so smaller objects in shared slab pages can't cleanly be marked or
unmarked. This commit adds a secret pool built on kmem_buckets to
hold such keys in marked pages.

> diff --git a/lib/secret_pool.c b/lib/secret_pool.c
> new file mode 100644
> index 0000000000000..62954847091a0
> --- /dev/null
> +++ b/lib/secret_pool.c
> @@ -0,0 +1,27 @@
[ ... ]
> +void *secret_pool_alloc_node(size_t size, gfp_t flags, int node)
> +{
> +	void *p =3D kmem_buckets_alloc_node_track_caller(secret_pool, size,
> +						       flags, node);
> +
> +	crash_memaction_mark(p, size, CRASH_MEMACTION_SECRET);
        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

[Severity: High]
Does this unconditionally mark the allocation even if it falls back to a sh=
ared
kmalloc page?

The commit message notes that if the secret pool is used before its initcall
runs or if pool creation fails, allocations will fall back to ordinary kmal=
loc
caches.

Because crash_memaction_mark() operates at page granularity, wouldn't calli=
ng
it on a shared kmalloc page inadvertently mark the entire page (and unrelat=
ed
kernel objects sharing it) as a secret?

In the event of a crash, could this cause the kdump kernel to wipe or exclu=
de
these shared pages, potentially destroying crash data?

> +
> +	return p;
> +}
> +EXPORT_SYMBOL_GPL(secret_pool_alloc_node);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928-crash-mema=
ction-upstream-20260921-v3-0-e511e9ee2329@jaseg.de?part=3D2

