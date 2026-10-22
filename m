Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 704B2606A323
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 11:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5Pk8ONW
Received: by kanga.kvack.org (Postfix)
	id 8AE7F6B091A; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88DB16B091C; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79C7E6B091B; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5532E6B0919
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:48:39 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E4C2BA84A9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:38 +0000 (UTC)
X-FDA: 85350089916.30.928CD72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4682E20005
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:48:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5Pk8ONW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792669717;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fq4LdQ5nq8LydP2J0wH/opLoXwfhZZtfnxkhi3Y1vtI=;
	b=w5QiK3f8gHTxL979VRv1cpN6McSImz/QyLmdCLgK+xEn8rH7Rx+iVd7wjBEDZ1Puy855Hf
	wuhQIkIFT/c8YMBDSSXDXH66uGxSVYaExeqOZmKiCKpNNd9BLXFsF5ake6x00DN0xT7+Bu
	vL78Yug+fCuZYI4yt7Q9BMLj18YAuSs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Q5Pk8ONW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792669717;
	b=lRvtZSxB/v66T/kzxGewMje46r5AYZomgsWS/9n66MjuPZ+eTDPqzZSjsEuZ4W482YdUe0
	jGjj5dhOgcxoU5t5hqPo0XqZh+8PTKnbMwToMJQ8srnxPaR7UdLvdcxrUwGIlC7O4s2c8i
	ATmf5DVQ3EOZjXimxZIxlMB0IDaawyw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F93D4011F;
	Thu, 22 Oct 2026 11:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D39E61F000C4;
	Thu, 22 Oct 2026 11:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792669715;
	bh=fq4LdQ5nq8LydP2J0wH/opLoXwfhZZtfnxkhi3Y1vtI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Q5Pk8ONWQCLExHTrAMPUlE5iPKfgBcsv5DgVcvDni0LSA4FViAgPGb8CrcKquGt61
	 lIIx05J9N1YAtwSCxgxucsgTnk8I/BXsMxetswd1aKcc0e2JeScLFKuJdMer210DzG
	 W/4OZEbn7miy9Qk36pZ1SVb1h1QDDYxCOCe2pCZLpPb+H0JIN657/ndh1xbAj+49rS
	 o1YRAp66TmCt8oLPM83/ShSMuqvCuzNO5s4sk+OYp7VMzpRRS9XK20v/U4W1GSC6Zv
	 2HPo5XaH9+7/caAGII0SOOleJqAoscZmY5wA1faaP4HRRP+lVT7QpEBFA9Fcie3Qhh
	 qGLkOj0IER5Ig==
Message-ID: <sashiko-outbox-181382@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH slab/for-next 01/14] mm/slab: allow passing
 SLAB_MAY_ACCOUNT to kmem_cache_create()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?SGFycnkgWW9vIChNZXRhKQ==?= <harry@kernel.org>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Andrew Morton" <akpm@linux-foundation.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Roman
 Gushchin" <roman.gushchin@linux.dev>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Muchun Song" <muchun.song@linux.dev>, "Hao
 Ge" <hao.ge@linux.dev>, "Pedro Falcato" <pfalcato@suse.de>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-1-096800aa3330@kernel.org>
References: <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org>
 <20261021-memalloc-prof-dont-waste-slabobj-ext-metadata-v1-1-096800aa3330@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 11:48:34 +0000
X-Rspamd-Queue-Id: 4682E20005
X-Stat-Signature: ji68wmyn8cwoqmgny4kj6znpzi7x414e
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792669717-198594
X-HE-Meta: U2FsdGVkX1/yaZDw9ZpXPzqhgjSC2zIppQezJ7TmQ/mDPcykEz/8ytyfmmSQLkmhFs+MB12F44Xt/m4COgPETDl8j/r7+qWD+1c2zP8VdjATJvTk5A5dyiGGjtk5mSherQxGc7IZlTjGvvxFP6CmHOUjKYxaM3xrfzC3SxRxybLqF8rAQYOqkfm1CIzih8bv3ILL858ySs1fzioGLRb+nQ/HGaainisY4CbYL2RMHzHDQQyfEnJqMpQcGbUfh0NclA55aqc9bjy2Qb3ECrmvbFZKeiOVvl/YGL8K44G3TKb6bCOF85zvR/dVSzyMa+XL52OSLG4UNFu6zyKk6r8fWoyATsFd0RRdj+jnJJGkhaIi5xZkfpSKUms5Guevmo8aTA8l/neKdSAbOl+dwyOnex1NRskBPJ4aij+zJuBv9FJtqeF59X8oOIig7I8mq3PY8qHydriuFw9we8ZLZweKOf3VjZ3h8M9H6dC11ymlZCxROlb4JrIhVA5WdT2EBmBaoYXCiS26T8Z9ZzEQfE99ELuD1Zj99OOFND10T7ts5yjStulgqBW8MNpiftWbNvcLNulv1p5qZ/QhziiEELr8GPnZJdBVAmQfipYv7boUMUu+dopOxcrPk7UFf970YoCLF5t/qQKReXOOtqhXJXUFuKEQyXjFl38z/dDml5qtMHrhqREp67zkws4spftgsxcVmKMj94EIzwN4TP9Bj3SPllf+xaAMnP1HmoHqKKAGfVCsWA/pxEyWlkibmj5JNGW6oRS27e3TFNK+rh7ENsnhSiMetKPdlfiyPWhJQ+JHL9LyH4QNfyYh0EF9XNZrzr1DQwvM9XoXHnDdNPqQtmkJAd0H6WV+Ttskqp3qbTns9koUE8Z83ncUywj1v2R6lt5ideZow8K3nNtHfjn7FLh+wFVuaXDho4z+nPjnUjF8Uiskogvr38LOoIqUEyWkeAL2UXahWpAuZSoM1nVBzIy
 j/WlRRhI
 5uvdnkQ77EacXoidFlLbJza7ry46InbHnHjmGiBmwJ10R2sVohwoCTpMLF7dHGqGhlhM/VFcZI9Yt+xJ4R6euw90AOYBrvjsDGBmzc0ENx94GOzkHWOgusEJnWljnl7YHxT4gdssyRMYfsjJ2quasY+Q/mwtJaLnz2UvRmpRm7WpYQmP08u+xtx3N5yk1OQc56oVFdwe3xazvBwKiV+E5qtU76cNuDIo8UQkhuLg5+USv1mx+/VdX03pUzIepiRT435epKBYaeCpb9rubjjbWiQPixp7pMhkAJynN/AP1roB8FxceT1ZZA/LzFmzXpAdy7YyCpW4SX0L3ymN3zNZuZ+xdfTh/qYGSS58Xsyskis1A+wD2i20htZVJoBm8UKB1dP/sDBnf7c7MFq09caMihEzF0KuEpP6BWiiZ4Gt5yAQ/j+kThljeRvdpaI7dW7SQ/M45r16dtiUIZk1WmHeakwoDbg3alt6Nu0ZHcJPiMoMIgXuMj5qYgbKYXjD2y/kqnyVto/6gYQ8tk9W9xkFAUe9XjWCEMs90NRk1P7zQwbl/uUxXXBxBfB7eIP17QyWZPPVgPK6PbcAvM/wi8t7RJBv8Wjko0v3nuxozUGHt+B/Nir09gcGBrbdhR8qK1UykEAI6OLrj0sG5WsHWZ6fCah8CnlnbotokiOqjZohsnf8/TVQ=
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
- [Medium] mm/slab: unhandled SLAB_MAY_ACCOUNT in create_unique_id() and no=
kmem path
--

commit 6d48a33523fd53d7ecd1bf1fa6ab70ec7126128f
Author: Harry Yoo (Meta) <harry@kernel.org>

mm/slab: allow passing SLAB_MAY_ACCOUNT to kmem_cache_create()

This commit adds SLAB_MAY_ACCOUNT to SLAB_CORE_FLAGS so callers of
kmem_cache_create() can explicitly specify SLAB_MAY_ACCOUNT for caches whose
objects may be allocated with __GFP_ACCOUNT.

> diff --git a/mm/slab.h b/mm/slab.h
> index e94ac63d10dc0..31783311e23ea 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -472,7 +472,7 @@ void flush_rcu_sheaves_on_cache(struct kmem_cache *s);
>  			 SLAB_CACHE_DMA32 | SLAB_PANIC | \
>  			 SLAB_TYPESAFE_BY_RCU | SLAB_DEBUG_OBJECTS | \
>  			 SLAB_NOLEAKTRACE | SLAB_RECLAIM_ACCOUNT | \
> -			 SLAB_TEMPORARY | SLAB_ACCOUNT | \
> +			 SLAB_TEMPORARY | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT | \
>  			 SLAB_NO_USER_FLAGS | SLAB_KMALLOC | SLAB_NO_MERGE)
> =20
>  #define SLAB_DEBUG_FLAGS (SLAB_RED_ZONE | SLAB_POISON | SLAB_STORE_USER =
| \

[Severity: Medium]
When callers pass SLAB_MAY_ACCOUNT to kmem_cache_create(), could this cause=
 a
sysfs kobject naming collision in create_unique_id() as well as unhandled
SLAB_MAY_ACCOUNT state when mem_cgroup_kmem_disabled() is true?

In mm/slab_common.c, SLAB_MAY_ACCOUNT is included in SLAB_MERGE_SAME:

#define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)

so find_mergeable() will not merge two aliasable caches of the same size if
only one of them has SLAB_MAY_ACCOUNT set.

However, in mm/slub.c, when do_kmem_cache_create() -> sysfs_slab_add() ->
create_unique_id() generates the sysfs identifier for an aliasable cache,
SLAB_MAY_ACCOUNT is not encoded into the name:

static char *create_unique_id(struct kmem_cache *s)
{
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

Because create_unique_id() omits SLAB_MAY_ACCOUNT, two unmerged aliasable
caches of the same size that differ only in SLAB_MAY_ACCOUNT will produce t=
he
same sysfs ID string, causing kobject_init_and_add() in sysfs_slab_add() to
fail with -EEXIST and trigger a sysfs_warn_dup() warning.

In addition, in mm/slab_common.c, __kmem_cache_create_args() currently does:

	if (!mem_cgroup_kmem_disabled())
		flags |=3D SLAB_MAY_ACCOUNT;

If mem_cgroup_kmem_disabled() is true (for example, with
cgroup.memory=3Dnokmem) and a caller passes SLAB_MAY_ACCOUNT, the flag is n=
ot
cleared. That prevents find_mergeable() from merging the cache with caches
that lack SLAB_MAY_ACCOUNT (triggering the create_unique_id() collision
above), and causes cache_needs_objcg() in mm/slab.h:

static inline bool cache_needs_objcg(struct kmem_cache *cache)
{
	return (cache->flags & SLAB_MAY_ACCOUNT);
}

to return true, reserving unused _objcg metadata space via
cache_obj_ext_size() and slab_obj_ext_size() when slab object extensions are
allocated.

Note that a later change in the series, commit 51cadd40978b ("mm/slab: do n=
ot
set SLAB_MAY_ACCOUNT for all caches"), clears SLAB_MAY_ACCOUNT in
__kmem_cache_create_args() when mem_cgroup_kmem_disabled() is true, but it
does not update create_unique_id(), where the sysfs ID collision will then
also occur on default boots once SLAB_MAY_ACCOUNT is no longer set on all
caches.

Should create_unique_id() encode SLAB_MAY_ACCOUNT, and should
__kmem_cache_create_args() strip SLAB_MAY_ACCOUNT when
mem_cgroup_kmem_disabled() is true here as well?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021-memalloc-p=
rof-dont-waste-slabobj-ext-metadata-v1-0-096800aa3330@kernel.org?part=3D1

