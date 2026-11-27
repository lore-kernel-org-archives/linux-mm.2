Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3EB9606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 21:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=COu2OITN
Received: by kanga.kvack.org (Postfix)
	id A55966B05B2; Fri, 27 Nov 2026 16:16:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2D0A6B05B3; Fri, 27 Nov 2026 16:16:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 969366B05B4; Fri, 27 Nov 2026 16:16:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 75C346B05B2
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 16:16:04 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D417DC0509
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:16:03 +0000 (UTC)
X-FDA: 85482156606.23.457D682
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 39B824000E
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 21:16:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COu2OITN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795814162;
	b=EKagVLYB2CE8fHVZWtRQM9c3RRRPogDVSbKLoiDEQVHg/b9SVKvv7trP0EvwpJkLkSHiw4
	w/LdqyjJ3j8RhiKn80go3Qnmm8Z7ZAc5jr9yA63XNGEC1UONRnaRDi3ecQ1W6TF+Tc8a1c
	V2JFrzcNl2TbjDPmqoWVo8Cx/DCz2+o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795814162;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVFnf5dpR8Dt2DSzqq9t15Qf8T7sRysbntYiM2GJ364=;
	b=O1ZKt5iAzDAaMkxV1Qjo3nltgYKFM5wePEG7sPTne2fk8WwjTpVFAYqm8o4YYSpNUWu2Sq
	SVJZqoQdnTFlRqSGF1y/Kt+rSmZoSDrzewAYFZso5LGrGVdbkm/rxGWJ8H3TRQPWWt+EjZ
	ogDW4hZTRtkLL/rw4ngabSgOpRe3FNM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=COu2OITN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CCD206203B;
	Fri, 27 Nov 2026 21:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C441A1F000C1;
	Fri, 27 Nov 2026 21:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795814161;
	bh=iVFnf5dpR8Dt2DSzqq9t15Qf8T7sRysbntYiM2GJ364=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=COu2OITN+ekP19XcUUH83dFh0zMFmWbjPdl+qcJjSY9IxBJVD2jzLRTtpJ3h9R9ct
	 Xi5Lc7FJQeW7aulxbYVAUk/ytFhcfDTRPQuQPyuZ7PJ6YieGXpZ7038OO52WrGoEjK
	 jDZ96//ILK/LfpNRSyOiX1rIDsuP6KSC1wcZp3six36gQLhtWygefQ3qD9KjlZ0EXK
	 Ci2kR8/O0wl2lRlNoqbI0Sg6d9KiGn+GokTPNkyU/YfR2flw1z2Y5Sq6++5j88WmHw
	 NLsJzY/8lwqv/UjBxNRuP2x1GQRxE9mGFobhZdzvvTBvm7pKekgGwELg+ICbFKnXzG
	 k/PqccmuoCAPw==
Message-ID: <sashiko-outbox-238287@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 4/4] mm/slab: clear stale layout values in
 calculate_sizes()
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Vmxhc3RpbWlsIEJhYmthIChTVVNFKQ==?= <vbabka@kernel.org>, "Harry
 Yoo" <harry@kernel.org>
Cc: "Hao Li" <hao.li@linux.dev>, "Christoph Lameter" <cl@gentwo.org>, "David
 Rientjes" <rientjes@google.com>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 =?utf-8?b?RGF2aWQgSGlsZGVuYnJhbmQgKEFybSk=?= <david@kernel.org>, linux-mm@kvack.org, "Chris
 Mason" <mason@kernel.org>
In-Reply-To: <20261127-slab-ai-fixes-v1-4-cf13b6be6692@kernel.org>
References: <20261127-slab-ai-fixes-v1-0-cf13b6be6692@kernel.org>
 <20261127-slab-ai-fixes-v1-4-cf13b6be6692@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 27 Nov 2026 21:16:00 +0000
X-Rspamd-Queue-Id: 39B824000E
X-Stat-Signature: 6nkuobtfo5zbutnp5taqwao9hekfazn5
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795814162-927324
X-HE-Meta: U2FsdGVkX1+gWxqsdAYCIKNo3ICbF2Uy4Hq3lOGUdWAUwCWJqFw1LHdO17XiTcd21KTKl7ebH+HNM7yhM+562UTRTdcJsry3HKE+ubHFVnT4rUhxyNSlJmL1zR2a9RUhaNNNKGir5Shv8ilnkj6VoYBTpEdDosnjjnA6L9esRrFjQHzpAttUXVzZzKqQ4xFJVq4jqx6RyF3rPJW7RirIyd+7FyGT7uI14k0f91llNAhJ1IHV2Dozb8/6W/AdIWD5zFE0JVz0hD1yBP3BEBbBZkWE4/8tMdRJ2mvKdI1pEofdIjfmnilvAi2y7h/1j9mtdLPi1Qd/p9dP2HGGxAlURBktUqe3LUSC4VB7v0tfWFzaRvxFSP/1X8+7EsPBtwLwlZAlmrXyGBozV8wtmYDSFTL65EwB84fjqydzXqcxpfDmt4sJnhcq6uWIO62VGYCgFQAV4SDoMXAbi5ag9NXkOyHGo2aVmSfPihLtOHIWuA4JD8adntlqyR2YuLWjMVQlob//oLn57ioNOHTK6tQkfdvmNhDQi9vDuk4feDRCnlqRz4DLliRKim1AMgDtVWbFo4IulFHRFuDG+BL9DWno66vriRjoGEJ7ij6jKYO9kYK1o8gQ1u2ypgtin2IwfO9zOP27woEUkzIEb14al+gcXRx74Rfofy9ZKeUx4MtZ9EESGf5sQ3vfs9Lik0BcOnpy6rYEbBTxR6UmxCt52ToPb1cmRwqrw73fvtR3QBhIizRg4kl+kO+0YHuzlSQ7e0XCO2zrE51i3Nb/oh3yUw2Xuagh5DD+DepBwu+XD1pZ7BXPNNe1dhm2z59aN0q1LxLD2lZBSyWADBSgaSWcGmeIVOXACbpc5ZWcOJmHOydWiDz6KsgE+3hVfDjB7UK1Tq5rVjhPQUvdm+IkH9fHiGuCGE6+iPUtuVeBALxRYpW1z5qplj+taPV4m7uBfePusN+KmGU9HJ5FmQeqIjOp2lH
 qKFGutY4
 FM2R8H0QFjWju/l0K0j9GkNhx00lpqzeZ0ZXF8DhHmiUJqhcplaJxNiShmtC9ISm7CA8dXcXbhUCvLiE2GrJ/kCYqTwUbz3rAON2h3VE7yZudVrXFHMgGtN325PUgXUDgHSzX4ELSWP7SgrcqMC5+088EEND8UmwW3+o3yoI68GtpVe/5J9STHlZvqf+IBnb+x0JuNOJLcEecFOUH0Ke18/5fB966mzOhMMgOjdxP47Wok1K4V8BpLIEX56e6jaFhNb/6Yqc+BtKUwpv6YFXK4QG3Gj90vKKSv2zrILffUnWWLujDz/8Fh9LOZsvZT87Tuo7cimHl5zZIyFy2HCjQQFLKg0hlKSM56WgHkmAvtiQob5HemG7r6sY21VKci6z0xYfw5DLAYIWvxghEJe+dodpZJc3glAG4Nwnzr8OY+SwJO/bTSFP8Mhgfv+WYBu0zGmc31vG0dSlVyeXxNDWLGcMLtAX8+V6Gh+zro4Fbt1LfaB9lyBczuJJnD3waeGpdr1Z8UU4m0aecKUd9mIz/Uj0Yz3Ou9sH/Ev//lPkW0YgNFzvwF5QAWUL6cPPg6G9luC3/wnErZZ/UF0UEsqlL3+M9pDf8wYHRMaWCCg10xdx4SqNyb27OYRqTDN3LxckICyzdRlljIpzQjXlbQMYjvaGCHbh1Lq0VB3uBPKiMS3C4rcOVA7VwvUj33x1MsDUHPWcf1IV9vXUTSK/SsOjVs51Gf26o1XoOxKkMzWHOG53umsFwIwOfL92nNw87cQGFaoXdrxhr4+HuVGi+kw27YBJ/DABVuZUZYiXEz+sqDP2vEzly1dpMWRYmSnj0LzsHdT+vKzGO4uizqwTwTBNWkjtfxNcEEr8Yc1UWzTYiqY6M3NJzl/pr7LBLu6p3oVBO7BovbIiAG78typyoZkhxhTbFpKhIn67ZG33i8ARDlS0moOpqPMp32rIKnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] mm/slab: late SLAB_NO_MERGE in do_kmem_cache_create() skips
  obj_ext in object
--

commit e36d70bf4b2fe1e8cc089823e91c1a5b0b9817ea
Author: Chris Mason <mason@kernel.org>

mm/slab: clear stale layout values in calculate_sizes()

This commit resets SLAB_OBJ_EXT_IN_OBJ and s->red_left_pad in
do_kmem_cache_create() before recalculating cache sizes when debug metadata
flags are dropped due to an increased minimum slab order.

> diff --git a/mm/slub.c b/mm/slub.c
> index 9bb031f9a41fd..003023b6f8dc6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -8860,8 +8860,16 @@ int do_kmem_cache_create(struct kmem_cache *s, con=
st char *name,
>  		 * order increased.
>  		 */
>  		if (get_order(s->size) > get_order(s->object_size)) {
> +
>  			s->flags &=3D ~DEBUG_METADATA_FLAGS;
> +			/*
> +			 * Reset fields that the previous run may have set and
> +			 * now might be different.
> +			 */
> +			s->flags &=3D ~SLAB_OBJ_EXT_IN_OBJ;
>  			s->offset =3D 0;
> +			s->red_left_pad =3D 0;
> +
>  			if (!calculate_sizes(args, s))
>  				goto out;
>  			/* Created as unmergeable, so it has to stay so */

[Severity: Low]
Should SLAB_NO_MERGE be set on s->flags before the second calculate_sizes()
call rather than after it?

calculate_sizes() only sets SLAB_OBJ_EXT_IN_OBJ when the cache is
unmergeable:

mm/slub.c:calculate_sizes() {
    ...
	if (slab_args_unmergeable(args, s->flags) &&
			(aligned_size - size >=3D cache_obj_ext_size(s)))
		s->flags |=3D SLAB_OBJ_EXT_IN_OBJ;
    ...
}

For a cache that was only unmergeable because of DEBUG_METADATA_FLAGS,
clearing DEBUG_METADATA_FLAGS and SLAB_OBJ_EXT_IN_OBJ before setting
SLAB_NO_MERGE makes slab_args_unmergeable(args, s->flags) return false
during the second calculate_sizes() call.  Even when the non-debug object
layout still has enough alignment padding, SLAB_OBJ_EXT_IN_OBJ is not
re-enabled and slab allocations fall back to separate slabobj_ext arrays.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261127-slab-ai-fi=
xes-v1-0-cf13b6be6692@kernel.org?part=3D4

