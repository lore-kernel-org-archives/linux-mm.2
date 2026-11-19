Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02283606A320
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 15:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ugKjPZdu
Received: by kanga.kvack.org (Postfix)
	id 2257A6B05E9; Thu, 19 Nov 2026 10:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FC456B0682; Thu, 19 Nov 2026 10:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C4EF6B0683; Thu, 19 Nov 2026 10:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C99496B05E9
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:18:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B253FA89D6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:18:48 +0000 (UTC)
X-FDA: 85452225936.06.B64E8F5
Received: from mta0.migadu.com (out-82.mta0.migadu.com [91.218.175.82])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1779A40007
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:18:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ugKjPZdu;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795101526;
	b=Z/f6XvWOrZZHB6qHAsZ7gbVhi9opsWqj+/N9UTDz0OBfE0uyzuiG6c5kFX0l+m1WhHMQY7
	OpYHMU7H8QhXVB2DDiMZmnnrjTh61SIaN8RATkniiDiMDmdxEcJQ6SqlKhEldbRXC/fOHi
	BST2VX8hsO5/3B/bgW9vdIXJAdpaVOk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795101526;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2jGTFLt4XTYdjInSQrQdimU6T3EftPyWHcN4JYNWBkc=;
	b=8iGP0smojXKiNxrN/JXtNKR9/oB70i8uEQlWmtDzwqixv31mNp2mW6REAShyxrhk2w/Q0r
	yOGuB2K+P1i0MIRCJE9m6BKhqC3Al6eSQ7t3+qPXV20Fo9GcP4KBZlZOPM6KzFdI3Vf6pM
	1Na84vy0pGB6hugPhFf6c/39ZNcSJW0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ugKjPZdu;
	spf=pass (imf07.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.82 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=CJN2pPG+Jtsd6Mi9z6H1krr8C7F/P741OB2FSEBhgig=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795101524; v=1; x=1795706324;
 b=ugKjPZduW91EDwxhTOQzEXwuJfwLcdaqQE6eEZKNebMO6iS0CFiWOC6NeReQNcOPQUyJ9qXD
 RPHVwotPqg9pP7qyMe5BNQsY0Bbo+O65W04gE2DCKP0n7FNAlDwXFFd9W4HXbMFqKGYBQMo8NR1
 lKOTQn7tfdOjE75e1145KTb4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 9b9575b542f5980d;
	Thu, 19 Nov 2026 15:18:44 +0000
X-Mizu-Trace-ID: 9b9575b542f5980d
X-Migadu-Flow: FLOW_OUT
From: Muchun Song <muchun.song@linux.dev>
Message-Id: <D626E659-FAC1-4D55-AAD2-11AA9BB5EE4A@linux.dev>
Content-Type: multipart/alternative;
	boundary="Apple-Mail=_3560DED4-1B36-4D23-A647-FC14D6EE9422"
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2 1/2] mm/shrinker: keep the per-memcg shrinker units in
 an xarray
Date: Thu, 19 Nov 2026 23:17:07 +0800
In-Reply-To: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-1-cf9b836859c5@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>,
 Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Harry Yoo <harry@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org
To: Konstantin Khorenko <khorenko@virtuozzo.com>
References: <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-0-cf9b836859c5@virtuozzo.com>
 <20261103-b4-prep-vstor-144717-per-memcg-shrinker-units-on-demand-xarray-v2-1-cf9b836859c5@virtuozzo.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Stat-Signature: f6x6ouupxd7k8ht5bcbe8tynzqj4zb49
X-Rspamd-Queue-Id: 1779A40007
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795101525-874487
X-HE-Meta: U2FsdGVkX1/I5Z8OBTYOQXfU3qKEO963EiSRgFiJXIqofqSsj+cCYstPlfUIqCavbGedNVu/XMVb8ZOMg3y7bCy+pzpXopN22C8z9DrE4uzhIUUMGhEJOlGmXO2vooe//WIjMxGvrIr8z7PtJeL2b58cqQcKqzcAmDZgp7jvZIz7pQpwkUksNNLNh0z/ultFu5gEtxOSsFj6uU0ZH4gNGq8TIPXY7eXR0rK3AOUF+RNIpRmIhUXwrkLnlnMfbOg8rdKXsnXJi9/7SO3RwPqfvsChUc2NbBxxtvL7poWN6UmXqJARP/HKwDzuIsC0hqRwNSpkCZfhUJivvwB2VNP752L22Xs9cphyY1BPphDhipIQBIyCtcOYJZ7vEJ9yEvY1lUFta2ORpUf/tN9VctDaX/Aq2o64czmvmSmH4aWHQCkqkiBijSzd2F2I4M09OMchuIwM5M18ck44pdIPMIDLXybusgThCTdn0gNTTTK8DgH5kWibp+vCcCzcUddTyfgXrwLriX+/6o+ywVmyYba9RXgsUXrWJoOhWIMIP4Oke/6EeO7V707za51C1Za4WHnozJnv4o6gUsdnuwlnspMbzU2ZK6FSmgEf3JTL6wzgtw0KiT0JLxr+jFLwRpLvniqX9zym0DpGX9hsnyGTz5eocq52nJ3qiK9IYFS3xh6Q3Rx3tGdeSA1r+9TOH445OaFPTHUb0l0gqEslQ4SWuo7xikBdtS+p6t70AYRYJW8sh8XCWEpXk9UFE3i/xP2TniW8w5mYaKf2r2aRkqXLhcqK3Zo4RdEQ1ckGPIVIu0rURMsMENHsAC+vxJKCOz086+5ojOxk/fl+aGK9rTEk9ef84rMpAmv6i0v130LbDQQlnXFr+6/OhIkFVAk5AEAJgQEjQBbShotGljQSQY/IOGFSj68VtUT1ko/OXb6i8LO1OClcFYXNW6Q1k+nFDsVFCtLCmBaxrtXzL0cJ3YKucL/
 9sHT9TaT
 XZsQUz2KIji5d+xBYf6Jyavh9W7EAlIzYM5hFa+TOybO4ZMfGv8yfgVlvM8watqMrIlodsw+lRj3/i/dixNkscHbmxZNIZ/LBcIE5RtDadBoebFw4mOHqoWBhcTACG3S7jNqmAuUX57feM9PammzD0Nk/hbaRGkAyGdDEUbc5kWTxByGNbAHoxX86yonKUjteeTQuKijn+c3BkvP+EdMPu4pcKd1++WbYA8cigv7193agMfMBneRb4vs0rHA6CNjfk1iiPn1ahJIwXFTGlxKbs87jKzFiOrQaFPb8SvUUEryZbLqlOG7ikOIuKupWkHXlvGwb2sVacDz+9BziBqVidR3CjAssY57gVKa/ModOmyvPLkJtf7lVZgelOIsyN2KzmwKodoBcf82ROnYXjq/k9nzPNZ+zY3iQDmvrwV82Noq4TOxvSKIX7YioAatwSfEoHKpIt96Otj36Px44mH7xNNboCG+jLGLsVE9Vh0EYq0V/unf1SnhVxPOfTvdjHV9ohFlXuYJ4t0LZjgdQBfxs6uCYK7nOAZmswu+Of5aITA0IWGbBlPO53ohEmi3SLI4Zs6n7EDoP744NATJe0+9KlYm5ETlUCjwLaTcSLsq0dD/akuezulwEc7Fi79E6En4Sg96jFp5gClN6A+mHtzryJjXbn6UUtJP94W4rLTwjHgXd1RTHJi5Lhmb1tr/6Zz7zCewZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


--Apple-Mail=_3560DED4-1B36-4D23-A647-FC14D6EE9422
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=us-ascii



> On Nov 3, 2026, at 07:13, Konstantin Khorenko <khorenko@virtuozzo.com> =
wrote:
>=20
> Every memory cgroup keeps, per NUMA node, an array of pointers to its
> shrinker_info_units, sized for shrinker_nr_max ids. shrinker_nr_max is
> the highest memcg-aware shrinker id ever handed out; every superblock
> takes one, and it never comes down.
>=20
> Keep the units in an xarray per memcg and node instead. Every memcg
> then holds just the units it has, not an array sized for the host,
> and growing shrinker_nr_max touches nothing that already exists.
>=20
> The units are still allocated for every memcg up front.
>=20
> Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
> ---
> include/linux/memcontrol.h |   5 +-
> include/linux/shrinker.h   |   6 -
> mm/memcontrol.c            |   3 +-
> mm/shrinker.c              | 312 =
+++++++++++++++------------------------------
> 4 files changed, 107 insertions(+), 219 deletions(-)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 69e1bcc67c588..61dd6d06897d8 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -24,6 +24,7 @@
> #include <linux/page-flags.h>
> #include <linux/shrinker.h>
> #include <linux/irq_work_types.h>
> +#include <linux/xarray.h>
>=20
> struct mem_cgroup;
> struct obj_cgroup;
> @@ -83,14 +84,14 @@ struct mem_cgroup_reclaim_iter {
>  * per-node information in memory controller.
>  */
> struct mem_cgroup_per_node {
> -	/* Set when the memcg is created, then only read. */
> +	/* Set when the memcg is created, then mostly read. */
> 	__cacheline_group_begin_aligned(memcg_pn_read_mostly);
> 	struct mem_cgroup	*memcg;		/* Back pointer, we =
cannot */
> 						/* use container_of	 =
  */
>=20
> 	struct lruvec_stats_percpu __percpu	*lruvec_stats_percpu;
> 	struct lruvec_stats			*lruvec_stats;
> -	struct shrinker_info __rcu	*shrinker_info;
> +	struct xarray			shrinker_units;
> 	struct obj_cgroup __rcu		*objcg;
>=20
> 	__cacheline_group_end_aligned(memcg_pn_read_mostly);
> diff --git a/include/linux/shrinker.h b/include/linux/shrinker.h
> index 1a00be90d93a9..2eae68a7ff6c5 100644
> --- a/include/linux/shrinker.h
> +++ b/include/linux/shrinker.h
> @@ -18,12 +18,6 @@ struct shrinker_info_unit {

Why not move this structure to shrinker.c?

> 	DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);
> };
>=20
> -struct shrinker_info {
> -	struct rcu_head rcu;
> -	int map_nr_max;
> -	struct shrinker_info_unit *unit[];
> -};
> -
> /*
>  * This struct is used to pass information from page reclaim to the =
shrinkers.
>  * We consolidate the values for easier extension later.
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a05d9a8baa1b6..1d4cab2e3f369 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4219,6 +4219,7 @@ static bool =
alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
> 	INIT_LIST_HEAD(&pn->objcg_list);
>=20
> 	lruvec_init(&pn->lruvec);
> +	xa_init(&pn->shrinker_units);
> 	pn->memcg =3D memcg;
>=20
> 	memcg->nodeinfo[node] =3D pn;
> @@ -5925,7 +5926,7 @@ static void __init memcg_struct_check(void)
> 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
> 				      memcg_pn_read_mostly, =
lruvec_stats);
> 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
> -				      memcg_pn_read_mostly, =
shrinker_info);
> +				      memcg_pn_read_mostly, =
shrinker_units);
> 	CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,
> 				      memcg_pn_read_mostly, objcg);
>=20
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 4fb424e721bca..74fc6f64459f0 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -19,48 +19,66 @@ void __init shrinker_unit_cache_init(void)
> 	shrinker_unit_cachep =3D KMEM_CACHE(shrinker_info_unit, =
SLAB_PANIC);
> }
>=20
> -static inline int shrinker_unit_size(int nr_items)
> +static inline int shrinker_id_to_index(int shrinker_id)
> {
> -	return (DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * =
sizeof(struct shrinker_info_unit *));
> +	return shrinker_id / SHRINKER_UNIT_BITS;
> }
>=20
> -static inline void shrinker_unit_free(struct shrinker_info *info, int =
start)
> +static inline int shrinker_id_to_offset(int shrinker_id)
> {
> -	struct shrinker_info_unit **unit;
> -	int nr, i;
> +	return shrinker_id % SHRINKER_UNIT_BITS;
> +}
>=20
> -	if (!info)
> -		return;
> +static inline int calc_shrinker_id(int index, int offset)
> +{
> +	return index * SHRINKER_UNIT_BITS + offset;
> +}
>=20
> -	unit =3D info->unit;
> -	nr =3D DIV_ROUND_UP(info->map_nr_max, SHRINKER_UNIT_BITS);
> +static struct shrinker_info_unit *shrinker_unit_get(struct mem_cgroup =
*memcg,

How about shrinker_unit_lookup? I really don't like using the word "get"
for things that aren't reference-count managed.

> +						    int nid, int =
shrinker_id)
> +{
> +	return xa_load(&memcg->nodeinfo[nid]->shrinker_units,
> +		       shrinker_id_to_index(shrinker_id));
> +}
>=20
> -	for (i =3D start; i < nr; i++) {
> -		if (!unit[i])
> -			break;
> +/*
> + * A memcg is visible to expand_shrinker_info() before it goes =
online, so
> + * a unit may already be there from either side.
> + */
> +static int shrinker_unit_install(struct mem_cgroup *memcg, int nid, =
int index)
> +{
> +	struct xarray *units =3D &memcg->nodeinfo[nid]->shrinker_units;
> +	struct shrinker_info_unit *unit;
> +	int ret;
>=20
> -		kmem_cache_free(shrinker_unit_cachep, unit[i]);
> -		unit[i] =3D NULL;
> +	if (xa_load(units, index))
> +		return 0;
> +
> +	unit =3D kmem_cache_alloc_node(shrinker_unit_cachep,
> +				     GFP_KERNEL | __GFP_ZERO, nid);
> +	if (!unit)
> +		return -ENOMEM;
> +
> +	ret =3D xa_insert(units, index, unit, GFP_KERNEL);
> +	if (ret) {

Do we really need to care about the failure since all writers are under
shrinker_mutex?

> +		kmem_cache_free(shrinker_unit_cachep, unit);
> +		if (ret =3D=3D -EBUSY)
> +			ret =3D 0;
> 	}
> +
> +	return ret;
> }
>=20
> -static inline int shrinker_unit_alloc(struct shrinker_info *new,
> -				       struct shrinker_info *old, int =
nid)
> +static int shrinker_units_install(struct mem_cgroup *memcg, int =
start, int end)
> {
> -	struct shrinker_info_unit *unit;
> -	int nr =3D DIV_ROUND_UP(new->map_nr_max, SHRINKER_UNIT_BITS);
> -	int start =3D old ? DIV_ROUND_UP(old->map_nr_max, =
SHRINKER_UNIT_BITS) : 0;
> -	int i;
> -
> -	for (i =3D start; i < nr; i++) {
> -		unit =3D kmem_cache_alloc_node(shrinker_unit_cachep,
> -					     GFP_KERNEL | __GFP_ZERO, =
nid);
> -		if (!unit) {
> -			shrinker_unit_free(new, start);
> -			return -ENOMEM;
> -		}
> +	int nid, index, ret;
>=20
> -		new->unit[i] =3D unit;
> +	for_each_node(nid) {

Move the definition of index to here.

> +		for (index =3D start; index < end; index++) {

And ret to here.

> +			ret =3D shrinker_unit_install(memcg, nid, =
index);
> +			if (ret)
> +				return ret;
> +		}
> 	}
>=20
> 	return 0;
> @@ -68,18 +86,18 @@ static inline int shrinker_unit_alloc(struct =
shrinker_info *new,
>=20
> static void __free_shrinker_info(struct mem_cgroup *memcg)
> {
> -	struct mem_cgroup_per_node *pn;
> -	struct shrinker_info *info;
> +	struct shrinker_info_unit *unit;
> +	unsigned long index;
> 	int nid;
>=20
> 	lockdep_assert_held(&shrinker_mutex);
>=20
> 	for_each_node(nid) {
> -		pn =3D memcg->nodeinfo[nid];
> -		info =3D rcu_dereference_protected(pn->shrinker_info, =
true);
> -		shrinker_unit_free(info, 0);
> -		kvfree(info);
> -		rcu_assign_pointer(pn->shrinker_info, NULL);
> +		struct xarray *units =3D =
&memcg->nodeinfo[nid]->shrinker_units;

Move unit and index to here.

> +
> +		xa_for_each(units, index, unit)
> +			kmem_cache_free(shrinker_unit_cachep, unit);
> +		xa_destroy(units);
> 	}
> }
>=20
> @@ -92,82 +110,22 @@ void free_shrinker_info(struct mem_cgroup *memcg)
>=20
> int alloc_shrinker_info(struct mem_cgroup *memcg)
> {
> -	int nid, ret =3D 0;
> -	int array_size =3D 0;
> +	int ret;
>=20
> 	mutex_lock(&shrinker_mutex);
> -	array_size =3D shrinker_unit_size(shrinker_nr_max);
> -	for_each_node(nid) {
> -		struct shrinker_info *info =3D =
kvzalloc_node(sizeof(*info) + array_size,
> -							   GFP_KERNEL, =
nid);
> -		if (!info)
> -			goto err;
> -		info->map_nr_max =3D shrinker_nr_max;
> -		if (shrinker_unit_alloc(info, NULL, nid)) {
> -			kvfree(info);
> -			goto err;
> -		}
> -		rcu_assign_pointer(memcg->nodeinfo[nid]->shrinker_info, =
info);
> -	}
> +	ret =3D shrinker_units_install(memcg, 0,
> +				     =
shrinker_id_to_index(shrinker_nr_max));
> +	if (ret)
> +		__free_shrinker_info(memcg);
> 	mutex_unlock(&shrinker_mutex);
>=20
> 	return ret;
> -
> -err:
> -	__free_shrinker_info(memcg);
> -	mutex_unlock(&shrinker_mutex);
> -	return -ENOMEM;
> -}
> -
> -static struct shrinker_info *shrinker_info_protected(struct =
mem_cgroup *memcg,
> -						     int nid)
> -{
> -	return =
rcu_dereference_protected(memcg->nodeinfo[nid]->shrinker_info,
> -					 =
lockdep_is_held(&shrinker_mutex));
> -}
> -
> -static int expand_one_shrinker_info(struct mem_cgroup *memcg, int =
new_size,
> -				    int old_size, int new_nr_max)
> -{
> -	struct shrinker_info *new, *old;
> -	struct mem_cgroup_per_node *pn;
> -	int nid;
> -
> -	for_each_node(nid) {
> -		pn =3D memcg->nodeinfo[nid];
> -		old =3D shrinker_info_protected(memcg, nid);
> -		/* Not yet online memcg */
> -		if (!old)
> -			return 0;
> -
> -		/* Already expanded this shrinker_info */
> -		if (new_nr_max <=3D old->map_nr_max)
> -			continue;
> -
> -		new =3D kvzalloc_node(sizeof(*new) + new_size, =
GFP_KERNEL, nid);
> -		if (!new)
> -			return -ENOMEM;
> -
> -		new->map_nr_max =3D new_nr_max;
> -
> -		memcpy(new->unit, old->unit, old_size);
> -		if (shrinker_unit_alloc(new, old, nid)) {
> -			kvfree(new);
> -			return -ENOMEM;
> -		}
> -
> -		rcu_assign_pointer(pn->shrinker_info, new);
> -		kvfree_rcu(old, rcu);
> -	}
> -
> -	return 0;
> }
>=20
> static int expand_shrinker_info(int new_id)
> {
> 	int ret =3D 0;
> 	int new_nr_max =3D round_up(new_id + 1, SHRINKER_UNIT_BITS);
> -	int new_size, old_size =3D 0;
> 	struct mem_cgroup *memcg;
>=20
> 	if (!root_mem_cgroup)
> @@ -175,13 +133,11 @@ static int expand_shrinker_info(int new_id)
>=20
> 	lockdep_assert_held(&shrinker_mutex);
>=20
> -	new_size =3D shrinker_unit_size(new_nr_max);
> -	old_size =3D shrinker_unit_size(shrinker_nr_max);
> -
> 	memcg =3D mem_cgroup_iter(NULL, NULL, NULL);
> 	do {
> -		ret =3D expand_one_shrinker_info(memcg, new_size, =
old_size,
> -					       new_nr_max);
> +		ret =3D shrinker_units_install(memcg,
> +					     =
shrinker_id_to_index(shrinker_nr_max),
> +					     =
shrinker_id_to_index(new_nr_max));
> 		if (ret) {
> 			mem_cgroup_iter_break(NULL, memcg);
> 			goto out;
> @@ -194,38 +150,20 @@ static int expand_shrinker_info(int new_id)
> 	return ret;
> }
>=20
> -static inline int shrinker_id_to_index(int shrinker_id)
> -{
> -	return shrinker_id / SHRINKER_UNIT_BITS;
> -}
> -
> -static inline int shrinker_id_to_offset(int shrinker_id)
> +void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int =
shrinker_id)
> {
> -	return shrinker_id % SHRINKER_UNIT_BITS;
> -}
> +	struct shrinker_info_unit *unit;
>=20
> -static inline int calc_shrinker_id(int index, int offset)
> -{
> -	return index * SHRINKER_UNIT_BITS + offset;
> -}
> +	if (shrinker_id < 0 || !memcg || mem_cgroup_is_root(memcg))
> +		return;
>=20
> -void set_shrinker_bit(struct mem_cgroup *memcg, int nid, int =
shrinker_id)
> -{
> -	if (shrinker_id >=3D 0 && memcg && !mem_cgroup_is_root(memcg)) {
> -		struct shrinker_info *info;
> +	unit =3D shrinker_unit_get(memcg, nid, shrinker_id);
> +	if (WARN_ON_ONCE(!unit))
> +		return;
>=20
> -		rcu_read_lock();
> -		info =3D =
rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> -		if (!WARN_ON_ONCE(shrinker_id >=3D info->map_nr_max)) {
> -			struct shrinker_info_unit *unit;
> -
> -			unit =3D =
info->unit[shrinker_id_to_index(shrinker_id)];
> -			/* Pairs with smp mb in shrink_slab() */
> -			smp_mb__before_atomic();
> -			set_bit(shrinker_id_to_offset(shrinker_id), =
unit->map);
> -		}
> -		rcu_read_unlock();
> -	}
> +	/* Pairs with smp mb in shrink_slab() */
> +	smp_mb__before_atomic();
> +	set_bit(shrinker_id_to_offset(shrinker_id), unit->map);
> }
>=20
> static DEFINE_IDR(shrinker_idr);
> @@ -270,52 +208,44 @@ static void shrinker_memcg_remove(struct =
shrinker *shrinker)
> static long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,
> 				   struct mem_cgroup *memcg)
> {
> -	struct shrinker_info *info;
> 	struct shrinker_info_unit *unit;
> -	long nr_deferred;
>=20
> -	rcu_read_lock();
> -	info =3D rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> -	unit =3D info->unit[shrinker_id_to_index(shrinker->id)];
> -	nr_deferred =3D =
atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], =
0);
> -	rcu_read_unlock();
> +	unit =3D shrinker_unit_get(memcg, nid, shrinker->id);
> +	if (WARN_ON_ONCE(!unit))
> +		return 0;
>=20
> -	return nr_deferred;
> +	return =
atomic_long_xchg(&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)], =
0);
> }
>=20
> static long add_nr_deferred_memcg(long nr, int nid, struct shrinker =
*shrinker,
> 				  struct mem_cgroup *memcg)
> {
> -	struct shrinker_info *info;
> 	struct shrinker_info_unit *unit;
> -	long nr_deferred;
>=20
> -	rcu_read_lock();
> -	info =3D rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> -	unit =3D info->unit[shrinker_id_to_index(shrinker->id)];
> -	nr_deferred =3D
> -		atomic_long_add_return(nr, =
&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
> -	rcu_read_unlock();
> +	unit =3D shrinker_unit_get(memcg, nid, shrinker->id);
> +	if (WARN_ON_ONCE(!unit))
> +		return 0;
>=20
> -	return nr_deferred;
> +	return atomic_long_add_return(nr, =
&unit->nr_deferred[shrinker_id_to_offset(shrinker->id)]);
> }
>=20
> void reparent_shrinker_deferred(struct mem_cgroup *memcg)
> {
> -	int nid, index, offset;
> -	long nr;
> 	struct mem_cgroup *parent =3D parent_mem_cgroup(memcg);
> -	struct shrinker_info *child_info, *parent_info;
> 	struct shrinker_info_unit *child_unit, *parent_unit;
> +	unsigned long index;
> +	int nid, offset;
> +	long nr;
>=20
> 	/* Prevent from concurrent shrinker_info expand */
> 	mutex_lock(&shrinker_mutex);
> 	for_each_node(nid) {
> -		child_info =3D shrinker_info_protected(memcg, nid);
> -		parent_info =3D shrinker_info_protected(parent, nid);
> -		for (index =3D 0; index < =
shrinker_id_to_index(child_info->map_nr_max); index++) {
> -			child_unit =3D child_info->unit[index];
> -			parent_unit =3D parent_info->unit[index];
> +		struct xarray *parent_units =3D =
&parent->nodeinfo[nid]->shrinker_units;
> +
> +		xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, =
index, child_unit) {
> +			parent_unit =3D xa_load(parent_units, index);
> +			if (WARN_ON_ONCE(!parent_unit))
> +				continue;
> 			for (offset =3D 0; offset < SHRINKER_UNIT_BITS; =
offset++) {
> 				nr =3D =
atomic_long_read(&child_unit->nr_deferred[offset]);
> 				atomic_long_add(nr, =
&parent_unit->nr_deferred[offset]);
> @@ -485,9 +415,9 @@ static unsigned long do_shrink_slab(struct =
shrink_control *shrinkctl,
> static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,
> 			struct mem_cgroup *memcg, int priority)
> {
> -	struct shrinker_info *info;
> -	unsigned long ret, freed =3D 0;
> -	int offset, index =3D 0;
> +	struct shrinker_info_unit *unit;
> +	unsigned long index, ret, freed =3D 0;
> +	int offset;
>=20
> 	if (!mem_cgroup_online(memcg))
> 		return 0;
> @@ -495,51 +425,17 @@ static unsigned long shrink_slab_memcg(gfp_t =
gfp_mask, int nid,
> 	/*
> 	 * lockless algorithm of memcg shrink.
> 	 *
> -	 * The shrinker_info may be freed asynchronously via RCU in the
> -	 * expand_one_shrinker_info(), so the rcu_read_lock() needs to =
be used
> -	 * to ensure the existence of the shrinker_info.
> -	 *
> -	 * The shrinker_info_unit is never freed unless its =
corresponding memcg
> -	 * is destroyed. Here we already hold the refcount of memcg, so =
the
> -	 * memcg will not be destroyed, and of course shrinker_info_unit =
will
> -	 * not be freed.
> +	 * A unit is only freed together with its memcg, and the caller =
holds
> +	 * a reference to the memcg, so the units found by xa_for_each() =
stay
> +	 * valid without the RCU lock and do_shrink_slab() may sleep.

This comment looks like an intermediate leftover from this change, it =
could be
removed. Since we've changed the mechanism, there's no real need to =
explain the
relationship with RCU anymore.

> 	 *
> -	 * So in the memcg shrink:
> -	 *  step 1: use rcu_read_lock() to guarantee existence of the
> -	 *          shrinker_info.
> -	 *  step 2: after getting shrinker_info_unit we can safely =
release the
> -	 *          RCU lock.
> -	 *  step 3: traverse the bitmap and calculate shrinker_id
> -	 *  step 4: use rcu_read_lock() to guarantee existence of the =
shrinker.
> -	 *  step 5: use shrinker_id to find the shrinker, then use
> -	 *          shrinker_try_get() to guarantee existence of the =
shrinker,
> -	 *          then we can release the RCU lock to do =
do_shrink_slab() that
> -	 *          may sleep.
> -	 *  step 6: do shrinker_put() paired with step 5 to put the =
refcount,
> -	 *          if the refcount reaches 0, then wake up the waiter =
in
> -	 *          shrinker_free() by calling complete().
> -	 *          Note: here is different from the global shrink, we =
don't
> -	 *                need to acquire the RCU lock to guarantee =
existence of
> -	 *                the shrinker, because we don't need to use =
this
> -	 *                shrinker to traverse the next shrinker in the =
bitmap.
> -	 *  step 7: we have already exited the read-side of rcu critical =
section
> -	 *          before calling do_shrink_slab(), the shrinker_info =
may be
> -	 *          released in expand_one_shrinker_info(), so go back =
to step 1
> -	 *          to reacquire the shrinker_info.
> +	 * The shrinker is found by id under the RCU lock, and
> +	 * shrinker_try_get() pins it before the lock is dropped;
> +	 * shrinker_put() wakes up the waiter in shrinker_free() by =
calling
> +	 * complete() when the last reference goes. The next shrinker =
comes
> +	 * from the bitmap, not from this shrinker, so nothing else is =
needed.
> 	 */

I think this comment can be deleted as well, because the existing code =
is very
straightforward. The comment is merely explaining the code itself, and I =
think
this kind of comment has no value.

Thanks,
Muchun

> -again:
> -	rcu_read_lock();
> -	info =3D rcu_dereference(memcg->nodeinfo[nid]->shrinker_info);
> -	if (unlikely(!info))
> -		goto unlock;
> -
> -	if (index < shrinker_id_to_index(info->map_nr_max)) {
> -		struct shrinker_info_unit *unit;
> -
> -		unit =3D info->unit[index];
> -
> -		rcu_read_unlock();
> -
> +	xa_for_each(&memcg->nodeinfo[nid]->shrinker_units, index, unit) =
{
> 		for_each_set_bit(offset, unit->map, SHRINKER_UNIT_BITS) =
{
> 			struct shrink_control sc =3D {
> 				.gfp_mask =3D gfp_mask,
> @@ -594,12 +490,8 @@ static unsigned long shrink_slab_memcg(gfp_t =
gfp_mask, int nid,
> 			freed +=3D ret;
> 			shrinker_put(shrinker);
> 		}
> -
> -		index++;
> -		goto again;
> 	}
> -unlock:
> -	rcu_read_unlock();
> +
> 	return freed;
> }
> #else /* !CONFIG_MEMCG */
>=20
> --=20
> 2.43.0
>=20


--Apple-Mail=_3560DED4-1B36-4D23-A647-FC14D6EE9422
Content-Transfer-Encoding: quoted-printable
Content-Type: text/html;
	charset=us-ascii

<html aria-label=3D"message body"><head><meta http-equiv=3D"content-type" =
content=3D"text/html; charset=3Dus-ascii"></head><body =
style=3D"overflow-wrap: break-word; -webkit-nbsp-mode: space; =
line-break: after-white-space;"><br =
id=3D"lineBreakAtBeginningOfMessage"><div><br><blockquote =
type=3D"cite"><div>On Nov 3, 2026, at 07:13, Konstantin Khorenko =
&lt;khorenko@virtuozzo.com&gt; wrote:</div><br =
class=3D"Apple-interchange-newline"><div><div>Every memory cgroup keeps, =
per NUMA node, an array of pointers to its<br>shrinker_info_units, sized =
for shrinker_nr_max ids. shrinker_nr_max is<br>the highest memcg-aware =
shrinker id ever handed out; every superblock<br>takes one, and it never =
comes down.<br><br>Keep the units in an xarray per memcg and node =
instead. Every memcg<br>then holds just the units it has, not an array =
sized for the host,<br>and growing shrinker_nr_max touches nothing that =
already exists.<br><br>The units are still allocated for every memcg up =
front.<br><br>Signed-off-by: Konstantin Khorenko =
&lt;khorenko@virtuozzo.com&gt;<br>---<br> include/linux/memcontrol.h | =
&nbsp;&nbsp;5 +-<br> include/linux/shrinker.h &nbsp;&nbsp;| =
&nbsp;&nbsp;6 -<br> mm/memcontrol.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;| =
&nbsp;&nbsp;3 +-<br> mm/shrinker.c =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;| 312 +++++++++++++++------------------------------<br> 4 files =
changed, 107 insertions(+), 219 deletions(-)<br><br>diff --git =
a/include/linux/memcontrol.h b/include/linux/memcontrol.h<br>index =
69e1bcc67c588..61dd6d06897d8 100644<br>--- =
a/include/linux/memcontrol.h<br>+++ b/include/linux/memcontrol.h<br>@@ =
-24,6 +24,7 @@<br> #include &lt;linux/page-flags.h&gt;<br> #include =
&lt;linux/shrinker.h&gt;<br> #include =
&lt;linux/irq_work_types.h&gt;<br>+#include =
&lt;linux/xarray.h&gt;<br><br> struct mem_cgroup;<br> struct =
obj_cgroup;<br>@@ -83,14 +84,14 @@ struct mem_cgroup_reclaim_iter {<br> =
&nbsp;* per-node information in memory controller.<br> &nbsp;*/<br> =
struct mem_cgroup_per_node {<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>/* Set when the memcg is created, =
then only read. */<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>/* Set when the memcg is created, =
then mostly read. */<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>__cacheline_group_begin_aligned(memcg_pn_read_mostly);<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
mem_cgroup<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>*memcg;<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>/* Back pointer, we cannot */<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>/* use container_of<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;*/<br><br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct lruvec_stats_percpu =
__percpu<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>*lruvec_stats_percpu;<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct lruvec_stats<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>*lruvec_stats;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct shrinker_info __rcu<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>*shrinker_info;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct xarray<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>shrinker_units;<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct obj_cgroup __rcu<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>*objcg;<br><br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>__cacheline_group_end_aligned(memcg_pn_read_mostly);<br>diff =
--git a/include/linux/shrinker.h b/include/linux/shrinker.h<br>index =
1a00be90d93a9..2eae68a7ff6c5 100644<br>--- =
a/include/linux/shrinker.h<br>+++ b/include/linux/shrinker.h<br>@@ =
-18,12 +18,6 @@ struct shrinker_info_unit =
{<br></div></div></blockquote><div><br></div><div>Why not move this =
structure to shrinker.c?</div><br><blockquote type=3D"cite"><div><div> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>DECLARE_BITMAP(map, SHRINKER_UNIT_BITS);<br> };<br><br>-struct =
shrinker_info {<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct rcu_head rcu;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int =
map_nr_max;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>struct shrinker_info_unit *unit[];<br>-};<br>-<br> /*<br> &nbsp;* =
This struct is used to pass information from page reclaim to the =
shrinkers.<br> &nbsp;* We consolidate the values for easier extension =
later.<br>diff --git a/mm/memcontrol.c b/mm/memcontrol.c<br>index =
a05d9a8baa1b6..1d4cab2e3f369 100644<br>--- a/mm/memcontrol.c<br>+++ =
b/mm/memcontrol.c<br>@@ -4219,6 +4219,7 @@ static bool =
alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>INIT_LIST_HEAD(&amp;pn-&gt;objcg_list);<br><br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>lruvec_init(&amp;pn-&gt;lruvec);<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	=
</span>xa_init(&amp;pn-&gt;shrinker_units);<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>pn-&gt;memcg =3D memcg;<br><br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>memcg-&gt;nodeinfo[node] =3D =
pn;<br>@@ -5925,7 +5926,7 @@ static void __init =
memcg_struct_check(void)<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;memcg_pn_read_mostly, =
lruvec_stats);<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>CACHELINE_ASSERT_GROUP_MEMBER(struct =
mem_cgroup_per_node,<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;memcg_pn_read_mostly, =
shrinker_info);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;memcg_pn_read_mostly, shrinker_units);<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>CACHELINE_ASSERT_GROUP_MEMBER(struct mem_cgroup_per_node,<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;memcg_pn_read_mostly, =
objcg);<br><br>diff --git a/mm/shrinker.c b/mm/shrinker.c<br>index =
4fb424e721bca..74fc6f64459f0 100644<br>--- a/mm/shrinker.c<br>+++ =
b/mm/shrinker.c<br>@@ -19,48 +19,66 @@ void __init =
shrinker_unit_cache_init(void)<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>shrinker_unit_cachep =3D =
KMEM_CACHE(shrinker_info_unit, SLAB_PANIC);<br> }<br><br>-static inline =
int shrinker_unit_size(int nr_items)<br>+static inline int =
shrinker_id_to_index(int shrinker_id)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
(DIV_ROUND_UP(nr_items, SHRINKER_UNIT_BITS) * sizeof(struct =
shrinker_info_unit *));<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return shrinker_id / =
SHRINKER_UNIT_BITS;<br> }<br><br>-static inline void =
shrinker_unit_free(struct shrinker_info *info, int start)<br>+static =
inline int shrinker_id_to_offset(int shrinker_id)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info_unit **unit;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>int nr, i;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
shrinker_id % SHRINKER_UNIT_BITS;<br>+}<br><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(!info)<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>return;<br>+static inline int calc_shrinker_id(int index, int =
offset)<br>+{<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return index * SHRINKER_UNIT_BITS =
+ offset;<br>+}<br><br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>unit =3D info-&gt;unit;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>nr =3D =
DIV_ROUND_UP(info-&gt;map_nr_max, SHRINKER_UNIT_BITS);<br>+static struct =
shrinker_info_unit *shrinker_unit_get(struct mem_cgroup =
*memcg,<br></div></div></blockquote><div><br></div><div>How =
about&nbsp;shrinker_unit_lookup?&nbsp;I really don't like using the word =
"get"</div><div>for things that aren't reference-count =
managed.</div><br><blockquote type=3D"cite"><div><div>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;int nid, int shrinker_id)<br>+{<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
xa_load(&amp;memcg-&gt;nodeinfo[nid]-&gt;shrinker_units,<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;shrinker_id_to_index(shrinker_id));<br=
>+}<br><br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>for (i =3D start; i &lt; nr; i++) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(!unit[i])<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>break;<br>+/*<br>+ * A memcg is visible to expand_shrinker_info() =
before it goes online, so<br>+ * a unit may already be there from either =
side.<br>+ */<br>+static int shrinker_unit_install(struct mem_cgroup =
*memcg, int nid, int index)<br>+{<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct xarray *units =3D =
&amp;memcg-&gt;nodeinfo[nid]-&gt;shrinker_units;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info_unit *unit;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>int ret;<br><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>kmem_cache_free(shrinker_unit_cachep, unit[i]);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>unit[i] =3D=
 NULL;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>if (xa_load(units, index))<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return 0;<br>+<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>unit =3D =
kmem_cache_alloc_node(shrinker_unit_cachep,<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;GFP_KERNEL | __GFP_ZERO, nid);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(!unit)<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>return -ENOMEM;<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>ret =3D xa_insert(units, index, =
unit, GFP_KERNEL);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (ret) =
{<br></div></div></blockquote><div><br></div><div>Do we really need to =
care about the failure since all writers are under</div><div><span =
style=3D"color: rgb(15, 15, 8); font-family: JetBrains Mono, Menlo, =
Monaco, Courier New, monospace; white-space: pre; background-color: =
rgb(255, 255, 255);">shrinker_mutex?</span></div><br><blockquote =
type=3D"cite"><div><div>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>kmem_cache_free(shrinker_unit_cachep, unit);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if (ret =
=3D=3D -EBUSY)<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>ret =3D 0;<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return ret;<br> }<br><br>-static =
inline int shrinker_unit_alloc(struct shrinker_info *new,<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;struct shrinker_info *old, int =
nid)<br>+static int shrinker_units_install(struct mem_cgroup *memcg, int =
start, int end)<br> {<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct shrinker_info_unit =
*unit;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int nr =3D DIV_ROUND_UP(new-&gt;map_nr_max, =
SHRINKER_UNIT_BITS);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>int start =3D old ? =
DIV_ROUND_UP(old-&gt;map_nr_max, SHRINKER_UNIT_BITS) : 0;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int =
i;<br>-<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>for (i =3D start; i &lt; nr; i++) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>unit =3D =
kmem_cache_alloc_node(shrinker_unit_cachep,<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;GFP_KERNEL | __GFP_ZERO, nid);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(!unit) {<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>shrinker_unit_free(new, start);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return -ENOMEM;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int nid, index, ret;<br><br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>new-&gt;unit[i] =3D =
unit;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>for_each_node(nid) =
{<br></div></div></blockquote><div><br></div><div>Move the definition of =
index to here.</div><br><blockquote type=3D"cite"><div><div>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>for =
(index =3D start; index &lt; end; index++) =
{<br></div></div></blockquote><div><br></div><div>And ret to =
here.</div><br><blockquote type=3D"cite"><div><div>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>ret =3D =
shrinker_unit_install(memcg, nid, index);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(ret)<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>return ret;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>}<br><br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>return 0;<br>@@ -68,18 +86,18 @@ static inline int =
shrinker_unit_alloc(struct shrinker_info *new,<br><br> static void =
__free_shrinker_info(struct mem_cgroup *memcg)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
mem_cgroup_per_node *pn;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct shrinker_info =
*info;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>struct shrinker_info_unit *unit;<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span>unsigned long index;<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int =
nid;<br><br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>lockdep_assert_held(&amp;shrinker_mutex);<br><br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>for_each_node(nid) {<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>pn =3D =
memcg-&gt;nodeinfo[nid];<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>info =3D =
rcu_dereference_protected(pn-&gt;shrinker_info, true);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>shrinker_unit_free(info, 0);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>kvfree(info);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>rcu_assign_pointer(pn-&gt;shrinker_info, NULL);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
xarray *units =3D =
&amp;memcg-&gt;nodeinfo[nid]-&gt;shrinker_units;<br></div></div></blockquo=
te><div><br></div><div>Move unit and index to here.</div><br><blockquote =
type=3D"cite"><div><div>+<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>xa_for_each(units, index, =
unit)<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>kmem_cache_free(shrinker_unit_cachep, unit);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>xa_destroy(units);<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br> }<br><br>@@ -92,82 +110,22 =
@@ void free_shrinker_info(struct mem_cgroup *memcg)<br><br> int =
alloc_shrinker_info(struct mem_cgroup *memcg)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int nid, =
ret =3D 0;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int array_size =3D 0;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>int ret;<br><br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>mutex_lock(&amp;shrinker_mutex);</div></div></blockquote><blockquot=
e type=3D"cite"><div><div>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>array_size =3D =
shrinker_unit_size(shrinker_nr_max);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>for_each_node(nid) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info *info =3D kvzalloc_node(sizeof(*info) + =
array_size,<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;GFP_KERNEL, nid);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (!info)<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>goto =
err;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>info-&gt;map_nr_max =3D shrinker_nr_max;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(shrinker_unit_alloc(info, NULL, nid)) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>kvfree(info);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>goto err;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>rcu_assign_pointer(memcg-&gt;nodeinfo[nid]-&gt;shrinker_info, =
info);<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>ret =3D shrinker_units_install(memcg, 0,<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;shrinker_id_to_index(shrinker_nr_max));<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(ret)<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>__free_shrinker_info(memcg);<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>mutex_unlock(&amp;shrinker_mutex);<br><br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
ret;<br>-<br>-err:<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>__free_shrinker_info(memcg);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>mutex_unlock(&amp;shrinker_mutex);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
-ENOMEM;<br>-}<br>-<br>-static struct shrinker_info =
*shrinker_info_protected(struct mem_cgroup *memcg,<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;int nid)<br>-{<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return =
rcu_dereference_protected(memcg-&gt;nodeinfo[nid]-&gt;shrinker_info,<br>-<=
span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> lockdep_is_held(&amp;shrinker_mutex));<br>-}<br>-<br>-static int =
expand_one_shrinker_info(struct mem_cgroup *memcg, int =
new_size,<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;&nbsp;int old_size, int new_nr_max)<br>-{<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info *new, *old;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct mem_cgroup_per_node =
*pn;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int nid;<br>-<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>for_each_node(nid) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>pn =3D =
memcg-&gt;nodeinfo[nid];<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>old =3D =
shrinker_info_protected(memcg, nid);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>/* Not yet online memcg =
*/<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>if (!old)<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return 0;<br>-<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>/* =
Already expanded this shrinker_info */<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (new_nr_max &lt;=3D =
old-&gt;map_nr_max)<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>continue;<br>-<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>new =3D =
kvzalloc_node(sizeof(*new) + new_size, GFP_KERNEL, nid);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(!new)<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>return -ENOMEM;<br>-<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>new-&gt;map_nr_max =3D =
new_nr_max;<br>-<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>memcpy(new-&gt;unit, =
old-&gt;unit, old_size);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (shrinker_unit_alloc(new, old, =
nid)) {<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>kvfree(new);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return -ENOMEM;<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>-<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>rcu_assign_pointer(pn-&gt;shrinker_info, new);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>kvfree_rcu(old, rcu);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br>-<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
0;<br> }<br><br> static int expand_shrinker_info(int new_id)<br> {<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int ret =3D 0;<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>int new_nr_max =3D =
round_up(new_id + 1, SHRINKER_UNIT_BITS);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int =
new_size, old_size =3D 0;<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct mem_cgroup *memcg;<br><br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>if (!root_mem_cgroup)<br>@@ -175,13 +133,11 @@ static int =
expand_shrinker_info(int new_id)<br><br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>lockdep_assert_held(&amp;shrinker_mutex);<br><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>new_size =
=3D shrinker_unit_size(new_nr_max);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>old_size =3D =
shrinker_unit_size(shrinker_nr_max);<br>-<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>memcg =3D =
mem_cgroup_iter(NULL, NULL, NULL);<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>do {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>ret =3D =
expand_one_shrinker_info(memcg, new_size, old_size,<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;new_nr_max);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>ret =3D =
shrinker_units_install(memcg,<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;shrinker_id_to_index(shrinker_nr_max),<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
&nbsp;&nbsp;&nbsp;&nbsp;shrinker_id_to_index(new_nr_max));<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if (ret) =
{<br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>mem_cgroup_iter_break(NULL, memcg);<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>goto =
out;<br>@@ -194,38 +150,20 @@ static int expand_shrinker_info(int =
new_id)<br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>return ret;<br> }<br><br>-static inline int =
shrinker_id_to_index(int shrinker_id)<br>-{<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
shrinker_id / SHRINKER_UNIT_BITS;<br>-}<br>-<br>-static inline int =
shrinker_id_to_offset(int shrinker_id)<br>+void set_shrinker_bit(struct =
mem_cgroup *memcg, int nid, int shrinker_id)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
shrinker_id % SHRINKER_UNIT_BITS;<br>-}<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span>struct shrinker_info_unit =
*unit;<br><br>-static inline int calc_shrinker_id(int index, int =
offset)<br>-{<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return index * SHRINKER_UNIT_BITS =
+ offset;<br>-}<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (shrinker_id &lt; 0 || !memcg =
|| mem_cgroup_is_root(memcg))<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return;<br><br>-void =
set_shrinker_bit(struct mem_cgroup *memcg, int nid, int =
shrinker_id)<br>-{<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if (shrinker_id &gt;=3D 0 =
&amp;&amp; memcg &amp;&amp; !mem_cgroup_is_root(memcg)) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info *info;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>unit =3D shrinker_unit_get(memcg, =
nid, shrinker_id);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if =
(WARN_ON_ONCE(!unit))<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return;<br><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>rcu_read_lock();<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>info =3D =
rcu_dereference(memcg-&gt;nodeinfo[nid]-&gt;shrinker_info);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(!WARN_ON_ONCE(shrinker_id &gt;=3D info-&gt;map_nr_max)) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info_unit *unit;<br>-<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>unit =3D =
info-&gt;unit[shrinker_id_to_index(shrinker_id)];<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>/* Pairs =
with smp mb in shrink_slab() */<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>smp_mb__before_atomic();<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>set_bit(shrinker_id_to_offset(shrinker_id), =
unit-&gt;map);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>rcu_read_unlock();<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>/* Pairs =
with smp mb in shrink_slab() */<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>smp_mb__before_atomic();<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	=
</span>set_bit(shrinker_id_to_offset(shrinker_id), unit-&gt;map);<br> =
}<br><br> static DEFINE_IDR(shrinker_idr);<br>@@ -270,52 +208,44 @@ =
static void shrinker_memcg_remove(struct shrinker *shrinker)<br> static =
long xchg_nr_deferred_memcg(int nid, struct shrinker *shrinker,<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> &nbsp;&nbsp;struct mem_cgroup *memcg)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info *info;<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct shrinker_info_unit =
*unit;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>long nr_deferred;<br><br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>rcu_read_lock();<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>info =3D =
rcu_dereference(memcg-&gt;nodeinfo[nid]-&gt;shrinker_info);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>unit =3D =
info-&gt;unit[shrinker_id_to_index(shrinker-&gt;id)];<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>nr_deferred =3D =
atomic_long_xchg(&amp;unit-&gt;nr_deferred[shrinker_id_to_offset(shrinker-=
&gt;id)], 0);<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>rcu_read_unlock();<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>unit =3D =
shrinker_unit_get(memcg, nid, shrinker-&gt;id);<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(WARN_ON_ONCE(!unit))<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return 0;<br><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
nr_deferred;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>return =
atomic_long_xchg(&amp;unit-&gt;nr_deferred[shrinker_id_to_offset(shrinker-=
&gt;id)], 0);<br> }<br><br> static long add_nr_deferred_memcg(long nr, =
int nid, struct shrinker *shrinker,<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> &nbsp;struct mem_cgroup =
*memcg)<br> {<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct shrinker_info *info;<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>struct shrinker_info_unit *unit;<br>-<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span>long nr_deferred;<br><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>rcu_read_lock();<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>info =3D =
rcu_dereference(memcg-&gt;nodeinfo[nid]-&gt;shrinker_info);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>unit =3D =
info-&gt;unit[shrinker_id_to_index(shrinker-&gt;id)];<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>nr_deferred =3D<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>atomic_long_add_return(nr, =
&amp;unit-&gt;nr_deferred[shrinker_id_to_offset(shrinker-&gt;id)]);<br>-<s=
pan class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>rcu_read_unlock();<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>unit =3D shrinker_unit_get(memcg, =
nid, shrinker-&gt;id);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if =
(WARN_ON_ONCE(!unit))<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return 0;<br><br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
nr_deferred;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">=
	</span>return atomic_long_add_return(nr, =
&amp;unit-&gt;nr_deferred[shrinker_id_to_offset(shrinker-&gt;id)]);<br> =
}<br><br> void reparent_shrinker_deferred(struct mem_cgroup *memcg)<br> =
{<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int nid, index, offset;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>long nr;<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
mem_cgroup *parent =3D parent_mem_cgroup(memcg);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info *child_info, *parent_info;<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info_unit *child_unit, *parent_unit;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>unsigned =
long index;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int nid, offset;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>long nr;<br><br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>/* =
Prevent from concurrent shrinker_info expand */<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>mutex_lock(&amp;shrinker_mutex);<br> <span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span>for_each_node(nid) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>child_info =3D shrinker_info_protected(memcg, nid);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>parent_info =3D shrinker_info_protected(parent, nid);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>for =
(index =3D 0; index &lt; =
shrinker_id_to_index(child_info-&gt;map_nr_max); index++) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>child_unit =3D child_info-&gt;unit[index];<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>parent_unit =3D parent_info-&gt;unit[index];<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
xarray *parent_units =3D =
&amp;parent-&gt;nodeinfo[nid]-&gt;shrinker_units;<br>+<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>xa_for_each(&amp;memcg-&gt;nodeinfo[nid]-&gt;shrinker_units, =
index, child_unit) {<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>parent_unit =3D =
xa_load(parent_units, index);<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>if =
(WARN_ON_ONCE(!parent_unit))<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>continue;<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>for =
(offset =3D 0; offset &lt; SHRINKER_UNIT_BITS; offset++) {<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>nr =3D =
atomic_long_read(&amp;child_unit-&gt;nr_deferred[offset]);<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>atomic_long_add(nr, =
&amp;parent_unit-&gt;nr_deferred[offset]);<br>@@ -485,9 +415,9 @@ static =
unsigned long do_shrink_slab(struct shrink_control *shrinkctl,<br> =
static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>struct mem_cgroup *memcg, int priority)<br> {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info *info;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>unsigned long ret, freed =3D =
0;<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>int offset, index =3D 0;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct shrinker_info_unit =
*unit;<br>+<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>unsigned long index, ret, freed =3D 0;<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>int =
offset;<br><br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>if (!mem_cgroup_online(memcg))<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>return 0;<br>@@ -495,51 +425,17 =
@@ static unsigned long shrink_slab_memcg(gfp_t gfp_mask, int nid,<br> =
<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>/*<br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * lockless algorithm of memcg shrink.<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
*<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
* The shrinker_info may be freed asynchronously via RCU in the<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
expand_one_shrinker_info(), so the rcu_read_lock() needs to be =
used<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * to ensure the existence of the shrinker_info.<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
*<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
* The shrinker_info_unit is never freed unless its corresponding =
memcg<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * is destroyed. Here we already hold the refcount of memcg, so =
the<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * memcg will not be destroyed, and of course shrinker_info_unit =
will<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * not be freed.<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * A unit is only freed together =
with its memcg, and the caller holds<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * a reference to the memcg, so =
the units found by xa_for_each() stay<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * valid without the RCU lock and =
do_shrink_slab() may =
sleep.<br></div></div></blockquote><div><br></div><div>This comment =
looks like an intermediate leftover from this change, it could =
be</div><div>removed. Since we've changed the mechanism, there's no real =
need to explain the</div><div>relationship with RCU =
anymore.</div><br><blockquote type=3D"cite"><div><div> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
*<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
* So in the memcg shrink:<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * &nbsp;step 1: use =
rcu_read_lock() to guarantee existence of the<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;shrinker_info.<br>-<=
span class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> =
* &nbsp;step 2: after getting shrinker_info_unit we can safely release =
the<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RCU =
lock.<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * &nbsp;step 3: traverse the bitmap and calculate =
shrinker_id<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * &nbsp;step 4: use rcu_read_lock() to guarantee existence of =
the shrinker.<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * &nbsp;step 5: use shrinker_id =
to find the shrinker, then use<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;shrinker_try_get() =
to guarantee existence of the shrinker,<br>-<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;then we can =
release the RCU lock to do do_shrink_slab() that<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;may =
sleep.<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * &nbsp;step 6: do shrinker_put() paired with step 5 to put the =
refcount,<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;if the =
refcount reaches 0, then wake up the waiter in<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;shrinker_free() by =
calling complete().<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Note: here is =
different from the global shrink, we don't<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;need to acquire the RCU lock to guarantee existence =
of<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;the shrinker, because we don't need to use =
this<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&n=
bsp;&nbsp;&nbsp;shrinker to traverse the next shrinker in the =
bitmap.<br>-<span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span> * &nbsp;step 7: we have already exited the read-side of rcu =
critical section<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;before calling =
do_shrink_slab(), the shrinker_info may be<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;released in =
expand_one_shrinker_info(), so go back to step 1<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span> * =
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;to reacquire the =
shrinker_info.<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * The shrinker is found by id =
under the RCU lock, and<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * shrinker_try_get() pins it =
before the lock is dropped;<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * shrinker_put() wakes up the =
waiter in shrinker_free() by calling<br>+<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> * complete() when the last =
reference goes. The next shrinker comes<br>+<span class=3D"Apple-tab-span"=
 style=3D"white-space:pre">	</span> * from the bitmap, not from this =
shrinker, so nothing else is needed.<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span> =
*/<br></div></div></blockquote><div><br></div><div>I think this comment =
can be deleted as well, because the existing code is =
very</div><div>straightforward. The comment is merely explaining the =
code itself, and I think</div><div>this kind of comment has no =
value.</div><div><br></div><div>Thanks,</div><div>Muchun</div><br><blockqu=
ote type=3D"cite"><div><div>-again:<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>rcu_read_lock();<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>info =3D =
rcu_dereference(memcg-&gt;nodeinfo[nid]-&gt;shrinker_info);<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if =
(unlikely(!info))<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>goto unlock;<br>-<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>if (index =
&lt; shrinker_id_to_index(info-&gt;map_nr_max)) {<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>struct =
shrinker_info_unit *unit;<br>-<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>unit =3D =
info-&gt;unit[index];<br>-<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>rcu_read_unlock();<br>-<br>+<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>xa_for_each(&amp;memcg-&gt;nodeinfo[nid]-&gt;shrinker_units, =
index, unit) {<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>for_each_set_bit(offset, =
unit-&gt;map, SHRINKER_UNIT_BITS) {<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>struct shrink_control sc =3D =
{<br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>.gfp_mask =3D gfp_mask,<br>@@ -594,12 +490,8 @@ static unsigned =
long shrink_slab_memcg(gfp_t gfp_mask, int nid,<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>freed +=3D =
ret;<br> <span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span><span class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>shrinker_put(shrinker);<br> <span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>}<br>-<br>-<span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span><span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>index++;<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span><span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>goto again;<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	=
</span>}<br>-unlock:<br>-<span class=3D"Apple-tab-span" =
style=3D"white-space:pre">	</span>rcu_read_unlock();<br>+<br> <span =
class=3D"Apple-tab-span" style=3D"white-space:pre">	</span>return =
freed;<br> }<br> #else /* !CONFIG_MEMCG */<br><br>-- =
<br>2.43.0<br><br></div></div></blockquote></div><br></body></html>=

--Apple-Mail=_3560DED4-1B36-4D23-A647-FC14D6EE9422--

