Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 486E5606A31B
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 13:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n/jzHDHu
Received: by kanga.kvack.org (Postfix)
	id AB1646B05BB; Thu,  5 Nov 2026 08:26:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A627D6B05BE; Thu,  5 Nov 2026 08:26:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 950D16B05BF; Thu,  5 Nov 2026 08:26:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6E56E6B05BB
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:26:43 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0381A40549
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:26:42 +0000 (UTC)
X-FDA: 85401140286.06.76A28C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 63FC7180003
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:26:41 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/jzHDHu";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793885201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mMfXt/HxPK2Swk1MlzkRGpDW9W5AhDiWyNa7hMLpkX4=;
	b=mffu8C2U6war1h5vSQ+2+55MyWEDCpRqnwCTWJMDv3EFJw42dgbUo7E++6mgVmhNo4AJ0Q
	NubjJUBsGMOwhrMz1A8MDJN++X3IpUHLKn1bdy8ZSNqnD8gYmMGPqSTrHJz9QlnWxBHjwd
	UoT0Iu4MZ+ktTuK/Oyna3AfPNWMcE7s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793885201;
	b=H7k1p2Lix2hB3kPZ7cyqMZGioa0QirTSe0SSAv0u0yNi1yMPemwHeHCO7flkbOT7T6wX5Z
	c80DZckGePttzOJ9WH4nPesBBnDf/1HfAztuzVG6s6DBiJ/3/UlEFG7i0wFg8VXxp6BDjr
	0fchR7HfzKVChm751kZMyrsGkn91Dqw=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="n/jzHDHu";
	spf=pass (imf06.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F07AD60D93;
	Thu,  5 Nov 2026 13:26:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067271F000C1;
	Thu,  5 Nov 2026 13:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793885200;
	bh=mMfXt/HxPK2Swk1MlzkRGpDW9W5AhDiWyNa7hMLpkX4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n/jzHDHu4jj+BZjH/MZStwwB+L1cEl/DyaQ1vCqlsJcbidWE7vAaNciDgcF5mc6Gb
	 mnh8a/0wzXJJzfEhxqy8aGwKrtWpd9P6F3k/4VKPzDYRyOnSeOSDA/9pDPc+7EyWx6
	 wopBwG98F7v0CCu/yCFk5kq1kDLIxgiOTPP0VGMCIlqmvsnfKTes/li27zukqqIY3y
	 t6lJQOIAwBsNwckXngd2AFcd5nYRD7Si3npMvUYiehvZTYHoge/enZRQRw/yfThFIr
	 IVSTEPdWUEMm3vt6qj5SijCHm37SGfXP5Se2GOcNrSAFCA9+O+AdBRKW0V1b99CQ6k
	 73U1TWrC53DPg==
Message-ID: <sashiko-outbox-199144@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/10] mm, slab: introduce slab_debug=N
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>, "Andrey Ryabinin" <ryabinin.a.a@gmail.com>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Geert
 Uytterhoeven" <geert@linux-m68k.org>, "Conor Dooley" <conor@kernel.org>, "Damien
 Le Moal" <dlemoal@kernel.org>, linux-mm@kvack.org, "Alexander Potapenko" <glider@google.com>, "Andrey
 Konovalov" <andreyknvl@gmail.com>, "Dmitry Vyukov" <dvyukov@google.com>, "Vincenzo
 Frascino" <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com
In-Reply-To: <20261105-slub_tiny_rework-v3-4-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
 <20261105-slub_tiny_rework-v3-4-0484ce59eabb@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 05 Nov 2026 13:26:39 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: sawxzijodz8cdb3ftny99kp6799unx6f
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 63FC7180003
X-Rspam-User: 
X-HE-Tag: 1793885201-57518
X-HE-Meta: U2FsdGVkX199CoMX69Fut8aVBxKE7D0UD6DOsQayKwILup846d+P/5W+9uV2nV1KCngNcszWWm2WRMLHFSpC+ByVuMAn4SpKxIimNpmI78O7oMTroksn4DO8cRciY3OCmpo71wAkYT6K0cs+ajZ6Tcr/4k/wFqKFIYdiPsKLiSeZxeEo4lnySEWCbNsSEiV+jOxrJI45n4pwKUChoQcfsynUmrzoCLC8d9FygfG1xAHFZkxi1pfuX1NxU9q4ZBBDI895LKQvsi/o5S8XAoNRIUmDk0NmWcJiqAKMdpOf8QbAgZbSdJel53ugep7lJEL6/o21xiGUs90m9sDoIodDv65vQBzgr9cPu9hqtpItvEOhuMz6nvg7yG25IUwAG5s7yTFDW1vwgIDwvc8zxEtq+Rkw4L/sNBcC56hcssfCoElP/W+uJdpfegohr9v0ys8ZfA4SIQQ4LFUoAl2sVc6oYBgQndpIwX0GdcG9d8FwNcYdttgyV+phpxERY3PQGnYvH1UkqqDap09cV324vBe6QjW5JpPYWyn0uF2yh+fzjdZUxtsP6MSISCH+mwi+RvdBB39p7TuRAp1pAQxqIMfCSmUr/JdeMFaXCSu1mEkPbDKG6vNXCGYl59OlJuPA5MvRup2dCk/f3UVBhPzdZybKsfh+DUT/lO12jokcZvOpjVmzcualjECLdDE6luSmwIsiWoq0w16dvBjpFNeexJpf6N0pZHSLz51nh7EaZraqgVsA2Y5yHFou7L0fut5a++5+lM0hkJHAZxp/9Cn1OYih+J5ByzSnGRzWifGnDk1lnXfmQMO75X6HGz1H/f7nQN82wXZTDo94pX9B90jjoXR9n7WIMaJd3eW7yHgrDuK/7UP0+TbeghHVV/SLNK7aZOWnJr5PvMNN7mSCXB+CLMuVuOjkiUfhP8yrGFm7q5QIxmGlUBLMozSEOoA4OA7MO4e6jGqaz34GkLVUlQ/e+YI
 9HtuOQQo
 OAb9Z05ZAQusBNHsjb0Tjyo/1eghs/cCk9AsMmyDBs1QaGEVlCTr4Q98zzyO+p+gqLgeE51tHP3TZINOmf3OrbKsSdcEfZ2XgVL/tUXTxEgoYLUefxRJuJM0NbBh2dH5+rLdfvCGQIen0rmIOMbi7g9mk3/yGBymGVj/0CSmTuyF3B9RpuEDgE/0PrtKAd5brwGWQvqSb9NdMerfP4zzsE7/XVte4T0RjMWqvov2FtgIJHGeP5wlOKt0WBCfqaS2gNCD8ybAW/Atoakyca8OHFIheD92GApjLdg0l+FWNR1IUKKzYQ+fV7IIbQ10MSzMeonpf/16FAPDkMfKBz0Yw4rlSiYxoFU/J0QRbRdjBYAeKX103hEnebJW5/mTmAAAhWtbosabrs2xYo+QTeq9cgu3ildapWMBztR0UcTaVdL/NcBXGuJ6GpUgRohhOzBaG3qbMVmsIfEtVWGBGbmUb6xXj4GBSJP2voicVGARRm+VI/0xUn3djH6XvxSCQi0iqJh6mRoEvZgSPXbn/Wt0nr/xeohzKxu2xYuSBWS8EiRiX8CG6fUIYEckniuVCZjJ8H8RKSvD1WzBq9JC+BfHJyfIoDUBMltpRKEP3D6ZAnOnUwUYinmXA5gWdKncbOi8D/bDxJDsDm9Hpll5L3G3N1yjvpmHos8fzo/BWQUhICXUAnvXltP45wlRZEiREnZFzafgnZ5En4OrJ4n5QLFgVCLA9Pqe7JDLwzxuzOQZngTsQ3evoZ7jiGhb9GQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm, slab: missing SLAB_DEBUG_NOOP in create_unique_id() causes s=
ysfs collision
--

commit 72eeb0d7d0de3c870ebf6a85a45b89ab817bcdff
Author: Vlastimil Babka (SUSE) <vbabka@kernel.org>

mm, slab: introduce slab_debug=3DN

This commit introduces a new slab_debug=3DN (SLAB_DEBUG_NOOP) option that f=
orces
slab debugging slowpaths and zero sheaf capacity without enabling actual de=
bug
checks, while keeping caches mergeable among caches with the same flag and
avoiding disabling printk pointer hashing.

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 01c64ef661e7f..6036ce1ac333b 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -47,12 +47,13 @@ struct kmem_cache *kmem_cache;
>   * Any flag that adds per-object metadata should be included,
>   * since slab merging can update s->inuse that affects the metadata layo=
ut.
>   */
> -#define SLAB_NEVER_MERGE (SLAB_DEBUG_FLAGS | SLAB_TYPESAFE_BY_RCU | \
> -		SLAB_NOLEAKTRACE | SLAB_FAILSLAB | SLAB_NO_MERGE | \
> -		SLAB_OBJ_EXT_IN_OBJ)
> +#define SLAB_NEVER_MERGE ((SLAB_DEBUG_FLAGS & ~SLAB_DEBUG_NOOP) | \
> +		SLAB_TYPESAFE_BY_RCU | SLAB_NOLEAKTRACE | SLAB_FAILSLAB | \
> +		SLAB_NO_MERGE | SLAB_OBJ_EXT_IN_OBJ)
> =20
>  #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
> -			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
> +			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT | \
> +			 SLAB_DEBUG_NOOP)

[Severity: Medium]
As reported by Sashiko on RFC v2 [1], when SLAB_DEBUG_NOOP is excluded from
SLAB_NEVER_MERGE and added to SLAB_MERGE_SAME, does create_unique_id() in
mm/slub.c also need to encode SLAB_DEBUG_NOOP into the generated sysfs cache
name?

When SLAB_DEBUG_NOOP is enabled on a subset of mergeable caches (for example
via per-cache slab_debug=3DN,<cache> boot parameters), find_mergeable() kee=
ps
mergeable caches with SLAB_DEBUG_NOOP separate from otherwise identical
mergeable caches of the same size without SLAB_DEBUG_NOOP.

Because slab_unmergeable() returns 0 for both caches, sysfs_slab_add() calls
create_unique_id() to generate their /sys/kernel/slab/ directory names:

mm/slub.c:create_unique_id() {
	...
	if (s->flags & SLAB_CACHE_DMA)
		*p++ =3D 'd';
	if (s->flags & SLAB_CACHE_DMA32)
		*p++ =3D 'D';
	if (s->flags & SLAB_RECLAIM_ACCOUNT)
		*p++ =3D 'a';
	if (s->flags & SLAB_CONSISTENCY_CHECKS)
		*p++ =3D 'F';
	if (s->flags & SLAB_ACCOUNT)
		*p++ =3D 'A';
	if (p !=3D name + 1)
		*p++ =3D '-';
	p +=3D snprintf(p, ID_STR_LENGTH - (p - name), "%07u", s->size);
	...
}

Since create_unique_id() does not append a character for SLAB_DEBUG_NOOP, b=
oth
caches receive the exact same sysfs name, causing kobject_init_and_add() in
sysfs_slab_add() to fail with -EEXIST and trigger a duplicate sysfs filename
warning.

[1] https://lore.kernel.org/r/20261024-slub_tiny_rework-v2-2-bf1419ab5ffd@k=
ernel.org

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261105-slub_tiny_=
rework-v3-0-0484ce59eabb@kernel.org?part=3D4

