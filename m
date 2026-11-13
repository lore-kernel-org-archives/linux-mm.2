Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C147D60A2612
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 02:42:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hZPxDKl4
Received: by kanga.kvack.org (Postfix)
	id DE9376B0645; Thu, 12 Nov 2026 21:42:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1166B064A; Thu, 12 Nov 2026 21:42:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D00E86B064B; Thu, 12 Nov 2026 21:42:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id ACEEB6B0645
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 21:42:14 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 48F62402AC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:42:14 +0000 (UTC)
X-FDA: 85428546588.28.B0EC95E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id A299FC0003
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 02:42:12 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hZPxDKl4;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794537732;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yhrn7dhf8Ad5S2iQKXEbQSvYOGtSv+f9fbe/S5Jt1ck=;
	b=LaC4MyAV/dggrDVEAU93KMJiuH9PvBw2B/LWv++6w69xeBUR5tyrkgWmTKCMbqFvzQRnqt
	DIkFkaAKMkIjPaV/rdHTlXw/J1OXsdBkIZFCvwA3hdbtI37rihV5W25z6j7xaeDejBYWIC
	ELcsEqvaQRYkc22fC9FUA+PzACc6+jU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794537732;
	b=gFtSuQTwJ17HokkHw67zDmue8JZ3yNhGHFD+hoRTlBk00PnijoUt1/ctsIiaQGXRKdHRu/
	rg8N1dXy8GLB22MHmjd8eC7b1fEY/XSDOoDinGb8HvsEjod/yQ028oT4VthwtOLeBe1zMf
	lfRPJzJO4G+DxR1j0a2CY1S+8Ohzgco=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hZPxDKl4;
	spf=pass (imf10.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D4008464CE;
	Fri, 13 Nov 2026 02:42:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC0E1F00925;
	Fri, 13 Nov 2026 02:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794537731;
	bh=yhrn7dhf8Ad5S2iQKXEbQSvYOGtSv+f9fbe/S5Jt1ck=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=hZPxDKl44g45amloSP8jUatst2w4db02t6wbQMeCJypcVgthvwu5bl1fWUEiC7yvg
	 1ZtGTEb7gl5hGknewQadXWHAim3K79CMPgOAmmvjzawUx3aZ1FvhZexSy41aVieum2
	 WamxPiU6BtUsROBvgYhwm6HrX76HUHUAN4/pZCN6twtjiqAAYNz1B1tG+rQxJmncXE
	 n25JKOteChKHHeIKmWEu2+0j73WSEZge4I91RbElQ+nMVDO6u/cwA1GXFEYu7Vgb0f
	 1fdtAcGp/B416RLyx8nf2zu6V9XGUCKJo0aIU+S3KZreqr9tnd6GN5cwzj3jTYrejL
	 M9+wLhDh74ePA==
Message-ID: <sashiko-outbox-212084@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm: list_lru: fix NULL deref when a folio moves to the
 root memcg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shakeel Butt" <shakeel.butt@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Dave Chinner" <david@fromorbit.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "David
 Hildenbrand" <david@kernel.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song" <muchun.song@linux.dev>, "Qi
 Zheng" <qi.zheng@linux.dev>, "Meta kernel team" <kernel-team@meta.com>, linux-mm@kvack.org, "Chris
 Mason" <mason@kernel.org>
In-Reply-To: <20261112024140.648088-1-shakeel.butt@linux.dev>
References: <20261112024140.648088-1-shakeel.butt@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 02:42:10 +0000
X-Stat-Signature: rmmw966cwtosuxon434i6b7u7kb5eog1
X-Rspamd-Queue-Id: A299FC0003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794537732-731283
X-HE-Meta: U2FsdGVkX194cGPNTB9yOq4k5qRsbtToykA5du+yUJuw82TpcHGgaEhhG6CECE+WL7efWQcabJ7AWpv3jI130JDsiu7zvMEdfGmq2Q07MHyOgPtt+B7G0s5CDzkUZdLcub9dDJHWVDDfMEChyV+K967gN1e8+zjUjH8h1BUT/bKiCCJd8vkzwwHLUDj+T+TNr8e9ViCU1tTBV/eCT25edp5OvVFSoZl0Np2h0qoQrlvYMTGufD66L4/L1G1XCds3DNgqgZWU0qNETlChd3CKkCCjJXFekZZiCMVo3plbG7GB5nguxe1fCTuvQhf6pja/gIz3ZqBrcjAgSWKR8h7PAczOvsY3jdR9ThJhenKnShAYiu1Nj809QiT12L6TzV19/8Eeng0XXIFOeOxQYBME20D0L2BTf6gP4chp7mfVGEICpfvgyLm/fIZckr97V5ZjITgl78Pf2eGRitlBgPjbEiOP0nCBRKZFUuhJ7ORXdBrpjIbA4F7f3Btetu+rUSzXnbo+2KLsmY747Jqk364gHgUOkyXrzYiX1QvWtYliaS7C/8LOoStxK6KxnAB4qXEJbLZTUwXRBOtPkX73KVgBdi55EsM6Nl6weKm/dn2wXo2hAxWkpravRMwjOmD9wIS/eMj0w6dNxVHKUiN09xssz2jmu1WfdL5fpGr/YqE/nzz/RrJPVkBcLk3RQF3/SvlNmLzkniTvbAaAhdpGqruUjSpJtUCzzrpYAEwULw8dNNbEF1H5ABojch7bXDn4m/U8tMugTxp1U4d6XfP4Uss1WuGVvB+ICe8WSgTIDuJCv5H8BsR3V0ub8nvTF5eKAxAGCnSe/UHih8+oncX8xAAtyD322nHmT2szymlEZNnB08lYmNcn70KoQiv2npzThSF3PyaBYc//Rt9dSvDP9dvLIUCOntY7OgvHyxoDDa8HOtmCrlFFggvtNmv/haxd+zGvAJBiGK9AVSnMJo8ot/s
 gis4mdFP
 lxFzlBJowOdIo0zd6fxIxe3Tb81wn4FYujYCpt/X0N7iiEwCMosSAhLINRUd2/zozsRuwS5au9yWl/hohuA6l/xzq4/wYq9+4+DnxTvCMuNWZ/CyzLrfMm4ssg4ZOA6tJJ+r8t9ENyKUuM/gXAicb3pk5UigAHZE2ldjrDIyCM5IvXANrT2cN8NTUWMBx9phUhuZNI8GD0RTn1QPney0mkWrsh/M4/XNC6yTCoq7BpISgb4+Re8dHtBiNLhMJbHs8B9wfcNIg+eKCLe0QeFLcAUzlS27iFlhUuEYsq9CIRnxU5YajN6CcqnPsG85Bmx92CuCUaOhu6OA4pnM7dCRUEaBEr1cK1FqSRmSxe2Y3TzjcQ2yn3MVhjd6FqHGqKOVBD7nopcXV5lcSt3vAKcnqEoLswTraJnHgs+oouSNynjUeuVx2/4ZLpMUmls3cu9wwRmYFFVLxHjo47NzqKoc0rVZeM1343xbIp89gTkYmGCL+bf9aochTw7nmFy+R+ffPbdAZrTaczbj5ucPcb65bV58NeEDoxBpptiUZl/2fQuz+pjhTmdacGu3NjwAuUgv5NE7/xVYKCQwJ/BmKoLIFU9HYjbfengwVRq4x1c3ijOaScwF32owk4+tdc3QPAy68VSWRcppy1GeCoM8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found no new issues
in this patch, but noticed 1 related pre-existing issue it does not
introduce:
- [High] mm/list_lru: infinite loop in __memcg_list_lru_alloc() on
  xas_nomem() failure [1]
--

commit 17fdd494fc11d51fee607883de9cf2593b4f8f83
Author: Shakeel Butt <shakeel.butt@linux.dev>

mm: list_lru: fix NULL deref when a folio moves to the root memcg

This commit skips calling __memcg_list_lru_alloc() in the slow path of
folio_memcg_list_lru_alloc() if the folio's memcg has been reparented to the
root memcg.

> diff --git a/mm/list_lru.c b/mm/list_lru.c
> index d1d256822ccc7..566691ca3dd8f 100644
> --- a/mm/list_lru.c
> +++ b/mm/list_lru.c
> @@ -645,9 +645,15 @@ int folio_memcg_list_lru_alloc(struct folio *folio, =
struct list_lru *lru,
>  	if (likely(res))
>  		return 0;
> =20
> -	/* Allocation may block, pin the memcg */
> +	/*
> +	 * Allocation may block, so pin the memcg. If the folio's cgroup
> +	 * was removed after the check above, the folio has moved up to a
> +	 * parent memcg, which can be the root. The root uses the global
> +	 * lists and has no parent, so skip it.
> +	 */
>  	memcg =3D get_mem_cgroup_from_folio(folio);
> -	res =3D __memcg_list_lru_alloc(memcg, lru, gfp);
> +	if (!mem_cgroup_is_root(memcg))
> +		res =3D __memcg_list_lru_alloc(memcg, lru, gfp);
>  	mem_cgroup_put(memcg);
>  	return res;
>  }

[Severity: High]
This problem wasn't introduced by this patch, but can __memcg_list_lru_allo=
c()
enter an infinite loop [1] when xas_nomem() fails while populating an
ancestor cgroup?

mm/list_lru.c:__memcg_list_lru_alloc() {
	...
	do {
		pos =3D memcg;
		parent =3D parent_mem_cgroup(pos);
		while (!memcg_list_lru_allocated(parent, lru)) {
			pos =3D parent;
			parent =3D parent_mem_cgroup(pos);
		}
		...
		xas_set(&xas, pos->kmemcg_id);
		do {
			xas_lock_irqsave(&xas, flags);
			if (!xas_load(&xas) && !css_is_dying(&pos->css)) {
				xas_store(&xas, mlru);
				if (!xas_error(&xas))
					mlru =3D NULL;
			}
			xas_unlock_irqrestore(&xas, flags);
		} while (xas_nomem(&xas, gfp));
	} while (pos !=3D memcg && !css_is_dying(&pos->css));
	...
	return xas_error(&xas);
}

When storing mlru for an ancestor (pos !=3D memcg) needs a new xa_node,
xas_store() sets xas to -ENOMEM and leaves pos unpopulated in lru->xa.  If
xas_nomem() then fails to allocate a node (for example under memory pressur=
e,
or when gfp &=3D GFP_RECLAIM_MASK strips GFP_NOWAIT), it returns false with=
 xas
still in the error state.

Because the outer loop does not check !xas_error(&xas), it repeats for the
same unpopulated ancestor pos, where xas_set() resets xas.xa_node to
XAS_RESTART and clears the error, looping forever and causing a soft or hard
lockup.

[1] https://sashiko.dev/#/bug/linux-21c1dba9-8d6f-4368-b38b-9a57cacb056f

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112024140.6480=
88-1-shakeel.butt@linux.dev?part=3D1

