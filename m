Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 456CC103E300
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 02:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8217C6B0088; Wed, 11 Mar 2026 22:15:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CE9A6B0089; Wed, 11 Mar 2026 22:15:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DBA36B008A; Wed, 11 Mar 2026 22:15:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 569F66B0088
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 22:15:50 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D286B140677
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:15:49 +0000 (UTC)
X-FDA: 84535795218.30.42B4C36
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id 48FA440014
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 02:15:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xpC3+Mpr;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773281748;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIQkQUVHBjAH9cVwEx7XxqiyBXCERXLZwu9xPGpZC6c=;
	b=3Cm5qAoOsGMBhoXBNuFEX2L3uQZgW4ElxVl7GqlaDMOQObAS3bLjQDVt3nYlYbAPx52NIH
	9U53Lvm2FVJwNPAkxRCL87kSOqS4YnGqyitCJgK7oqZF01ApSyXkPsNPpknAXSDnMfOuXB
	lFAtOHHTn9IPe97Td3U34ZXvlqH7r/s=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xpC3+Mpr;
	spf=pass (imf11.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773281748; a=rsa-sha256;
	cv=none;
	b=gBGXrlvkk1uBy9PgK/q1WpUx25fbV+sASzR7S7WDPNhqoVLQqNApqX/cl1tGA5Jjlo1a2+
	+73ilyMTeSzUKGj2Yv1NU7VHXdoUayADufQtJ64azZnOeFlYxrSwWovaB9VG6VocgwgKzP
	ew0Gc+DLKbaDi5y4gVuwTljjL9O5ccQ=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773281742;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TIQkQUVHBjAH9cVwEx7XxqiyBXCERXLZwu9xPGpZC6c=;
	b=xpC3+Mpr1Ozny7Aakt7MAy8d4M+vxecK8xsq2pzIublz4HefX9SiUbP81XJjoWoQ8xsWN3
	mmWI7LQ3x3GRqJzD76tyMj5dR9GFlBjSZZeq8yMHPUj1eskmQLmtBwczJ969/YlyxWlBdM
	KWdVzmpjbJj4xPrXZ5bm7dxEQBdt9HQ=
Date: Thu, 12 Mar 2026 02:15:34 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: hui.zhu@linux.dev
Message-ID: <1e56279445806f6e1f0ff5ac142b6efb9074dfa5@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v4] mm/swap: strengthen locking assertions and invariants
 in cluster allocation
To: "Chris Li" <chrisl@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Kairui Song"
 <kasong@tencent.com>, "Kemeng Shi" <shikemeng@huaweicloud.com>, "Nhat
 Pham" <nphamcs@gmail.com>, "Baoquan He" <bhe@redhat.com>, "Barry Song"
 <baohua@kernel.org>, "YoungJun Park" <youngjun.park@lge.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, "Hui Zhu"
 <zhuhui@kylinos.cn>
In-Reply-To: <CACePvbVKmAPKRRzfZ-id=5ESf3SL1QPYU4p5xBJBg4F9ocPb8A@mail.gmail.com>
References: <20260311022241.177801-1-hui.zhu@linux.dev>
 <CACePvbVKmAPKRRzfZ-id=5ESf3SL1QPYU4p5xBJBg4F9ocPb8A@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 48FA440014
X-Rspamd-Server: rspam07
X-Stat-Signature: p5bwsijn9m3p87cp1yruo3hsiwafzggx
X-Rspam-User: 
X-HE-Tag: 1773281746-847393
X-HE-Meta: U2FsdGVkX19yLFNCbNdoG5UrO+1BK3whdCvGzBASLwChqgRCPE5O2oG5KIqSsGY/2yhtSqHRK5wPve3jmKZPA3ClU3aTIKnzp2SWW3dt9hTzLII3wAe/yifgZKbfMRlw+r/LtRBxGqVo/6eqE3Yzb9ljKk44nbmp6Wy4V6/4vgOS9LxEtfA2nMsSWJ8fYhpSzMU7VkSCmxYaOWaImFhF15rSH2YyJ9SoBZ3ng6vpVdzQ8bbFh6NO2WaYU0fLWLKs7iPNY38sFjpC6IMI1UBH0WBFIN8n9CdWxWoDyr5nr7JtsW35SUdZQ1VxUd2GMDxen/hwRm1KysMFw1gsYFMQB73yO8xbaqxDAiXZboKaRm2NbB1r6sM/cN4wz4TrbzKe2Uco/Hc9qHebA4oio/lNHDHmSucxkg0TD9RizINfXbROfkKCdWiletIgiKB4ZnmazazNkaUKYruUEwcAcRQkX1/qhn6sSKHXFSz5OAtLoy0GnIgU8AZqlAoUWTEazIizHJ69OwMejSpcJdiWiEKKxXnwTClXMUA+fApI+EF6Ruq8jDvJ44jLdWMTw8NjQK06MgsxjO50wAFLFFNqSrXrc1r2lOXZ6gz7CV9dhpJ1irRRmRf4wC83ngkGyU4ZpJN3VpacVzO2BilbkejKu7j/0rWTo60BSDmumyJdHK+bb58XWq/bUiqyy3y9eUy3dYYY96sFUKXXZfWddCayd1iGLXbOAJWy5Yzon2ac6Et1R3iR1dElhTeIkTe4PbMSj5ZH4Ftp2URxv2O3c89chOgVK2jqXaPTQRtUvG57vYUWqCAVVHVHPi+MPFPATDqVaMzMA7YzaWXrO6+rxozJC5OZvkzB8gyyrmzl1a6IAGQmHxzA5lcqgRSI2w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

2026=E5=B9=B43=E6=9C=8812=E6=97=A5 01:34, "Chris Li" <chrisl@kernel.org m=
ailto:chrisl@kernel.org?to=3D%22Chris%20Li%22%20%3Cchrisl%40kernel.org%3E=
 > =E5=86=99=E5=88=B0:


>=20
>=20On Tue, Mar 10, 2026 at 7:23 PM Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
>=20> From: Hui Zhu <zhuhui@kylinos.cn>
> >=20
>=20>  The swap_cluster_alloc_table() function requires several locks to =
be held
> >  by its callers: ci->lock, the per-CPU swap_cluster lock, and, for
> >  non-solid-state devices (non-SWP_SOLIDSTATE), the si->global_cluster=
_lock.
> >=20
>=20>  While most call paths (e.g., via cluster_alloc_swap_entry() or
> >  alloc_swap_scan_list()) correctly acquire these locks before invocat=
ion,
> >  the path through swap_reclaim_work() -> swap_reclaim_full_clusters()=
 ->
> >  isolate_lock_cluster() is distinct. This path operates exclusively o=
n
> >  si->full_clusters, where the swap allocation tables are guaranteed t=
o be
> >  already allocated. Consequently, isolate_lock_cluster() should never
> >  trigger a call to swap_cluster_alloc_table() for these clusters.
> >=20
>=20>  Strengthen the locking and state assertions to formalize these inv=
ariants:
> >=20
>=20>  1. Add a lockdep_assert_held() for si->global_cluster_lock in
> >  swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.
> >  2. Reorder existing lockdep assertions in swap_cluster_alloc_table()=
 to
> >  match the actual lock acquisition order (per-CPU lock, then global l=
ock,
> >  then cluster lock).
> >  3. Add a VM_WARN_ON_ONCE() in isolate_lock_cluster() to ensure that =
table
> >  allocations are only attempted for clusters being isolated from the
> >  free list. Attempting to allocate a table for a cluster from other
> >  lists (like the full list during reclaim) indicates a violation of
> >  subsystem invariants.
> >=20
>=20>  These changes ensure locking consistency and help catch potential
> >  synchronization or logic issues during development.
> >=20
>=20>  Changelog:
> >  v4:
> >  According to the comments of Barry Song, remove redundant comment.
> >  v3:
> >  According to the comments of Kairui Song, squash patches and fix log=
ic
> >  bug in isolate_lock_cluster() where flags were cleared before check.
> >  v2:
> >  According to the comments of YoungJun Park, Kairui Song and Chris Li=
,
> >  change acquire locks in swap_reclaim_work() to adds a VM_WARN_ON in
> >  isolate_lock_cluster().
> >  According to the comments of YoungJun Park, add code in patch 2 to C=
hange
> >  the order of lockdep_assert_held() to match the actual lock acquisit=
ion
> >  order.
> >=20
>=20>  Reviewed-by: Youngjun Park <youngjun.park@lge.com>
> >  Reviewed-by: Barry Song <baohua@kernel.org>
> >  Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> >=20
>=20Acked-by: Chris Li <chrisl@kernel.org>
>=20
>=20>=20
>=20> ---
> >  mm/swapfile.c | 7 ++++++-
> >  1 file changed, 6 insertions(+), 1 deletion(-)
> >=20
>=20>  diff --git a/mm/swapfile.c b/mm/swapfile.c
> >  index 94af29d1de88..e25cdb0046d8 100644
> >  --- a/mm/swapfile.c
> >  +++ b/mm/swapfile.c
> >  @@ -476,8 +476,10 @@ swap_cluster_alloc_table(struct swap_info_struc=
t *si,
> >  * Only cluster isolation from the allocator does table allocation.
> >  * Swap allocator uses percpu clusters and holds the local lock.
> >  */
> >  - lockdep_assert_held(&ci->lock);
> >  lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> >  + if (!(si->flags & SWP_SOLIDSTATE))
> >  + lockdep_assert_held(&si->global_cluster_lock);
> >  + lockdep_assert_held(&ci->lock);
> >=20
>=20>  /* The cluster must be free and was just isolated from the free li=
st. */
> >  VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> >  @@ -577,6 +579,7 @@ static struct swap_cluster_info *isolate_lock_cl=
uster(
> >  struct swap_info_struct *si, struct list_head *list)
> >  {
> >  struct swap_cluster_info *ci, *found =3D NULL;
> >  + u8 flags;
> >=20
>=20Nit pick: consider initializing the value. The flags assignment occur=
s
> in a conditional block. The compiler might or might not realize the
> "flags" assigned only if "found" is also assigned, and might complain
> that flags can be used without initialization.
>=20
>=20>=20
>=20> spin_lock(&si->lock);
> >  list_for_each_entry(ci, list, list) {
> >  @@ -589,6 +592,7 @@ static struct swap_cluster_info *isolate_lock_cl=
uster(
> >  ci->flags !=3D CLUSTER_FLAG_FULL);
> >=20
>=20>  list_del(&ci->list);
> >  + flags =3D ci->flags;
> >=20
>=20If VM debug is disabled, this variable is not used after its value is
> assigned. Please test it with gcc and llvm (VM debug disabled) to
> ensure it doesn't generate any warnings. I don't expect it to be, I
> just want to make sure.

After adding the initialization code, I turned off VM_DEBUG and compiled
it with both clang18 and gcc13. No warnings during compilation.

Best,
Hui

>=20
>=20Chris
>=20
>=20>=20
>=20> ci->flags =3D CLUSTER_FLAG_NONE;
> >  found =3D ci;
> >  break;
> >  @@ -597,6 +601,7 @@ static struct swap_cluster_info *isolate_lock_cl=
uster(
> >=20
>=20>  if (found && !cluster_table_is_alloced(found)) {
> >  /* Only an empty free cluster's swap table can be freed. */
> >  + VM_WARN_ON_ONCE(flags !=3D CLUSTER_FLAG_FREE);
> >  VM_WARN_ON_ONCE(list !=3D &si->free_clusters);
> >  VM_WARN_ON_ONCE(!cluster_is_empty(found));
> >  return swap_cluster_alloc_table(si, found);
> >  --
> >  2.43.0
> >
>

