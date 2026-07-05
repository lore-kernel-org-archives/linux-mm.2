Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D52C43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 04:46:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7485E6B00A2; Sun,  5 Jul 2026 00:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71FF56B00A4; Sun,  5 Jul 2026 00:46:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 634EB6B00A5; Sun,  5 Jul 2026 00:46:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1866B00A2
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 00:46:27 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 99E4F14060B
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:46:26 +0000 (UTC)
X-FDA: 84953486772.01.D3608EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 08A2D140006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:46:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldarkZ3e;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783226785;
	b=pt8Dl1SFOb16Jq4CSz006WFNjCEYbW4QsHu1tuAlIANhZfY3qlXwnj2y1oIf1Gp167TR44
	4IV0kKFofFatGUvFBTHom75RG2J5A8Bp4884l6ifLrgRu/Zt3yjMLYWyzUmPZ6SH23FPJP
	7pHj4Htyo9H/Atp7rYYuhac6iQMhX1E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ldarkZ3e;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783226785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yS8tgMFHK16gSd7DdvCSlq4Fkcx4ZMA8N73FiBRXdhw=;
	b=BAjHaibvPBEM0w0+x8oy/EodpHU3GbQY9T1EmLS/+zYTGqDPmz6vrPLaI+Ns8A4kYr4ZZy
	8wzdAP6BBPzOF+n+5+RqF1NKli9EwHVHVFrSgs6kUkE8LIPFLyeOzlkJHj9wNNmkisNAlR
	Pa9JyPWz01Vzz48k+ZZUr3OKSiNv+nc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 675E56111A;
	Sun,  5 Jul 2026 04:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 177E61F000E9;
	Sun,  5 Jul 2026 04:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783226784;
	bh=yS8tgMFHK16gSd7DdvCSlq4Fkcx4ZMA8N73FiBRXdhw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ldarkZ3egtjcsy6bcatiw7N/TsfCSvt6dAg7K6aQxhaxDhMrrfewm+k2QCypCbwHq
	 KqnCF0r0BFVYoaGJor/NsspNjoK1l4QoH1oq7s6TVQh8ZiDgAFOEgEUYefr/8+hc0i
	 Bleyk4L9gc6QhQ339R/XLxlu7rbEwUes6EFUFpIGluk92blmo0BuX6lOyX6GdjbIgI
	 wSVkHIv2B5bfy12drDL1mXZbJFu5Soo8x+jgLc1bfwUTsEH/HCF1NwJ9tbv2X/wfQT
	 Zi53YMSC6zAMBl1u3nSnO7gw+8pgaYIYcn999oEnAuMWIx9YAZpfDhT559zCvDR5Tf
	 7+DbK450rzEqw==
Message-ID: <7f211fa8-e2d8-4878-a8db-fd275d4c6821@kernel.org>
Date: Sun, 5 Jul 2026 13:46:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slub: fix lost local objects when bulk remote free
 batch fills
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------B0QdMbL9ogUbc1uFToe2mPr9"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 08A2D140006
X-Stat-Signature: admpsj6bjm64cjsyaj7xnxj8r9hwixhn
X-HE-Tag: 1783226784-833260
X-HE-Meta: U2FsdGVkX1+gLzaBAdwxAx350p3Y5ILJyduXGUdJP8dmR6HCKWdNjB8IhBGyYngm+Bvg9yHkv0wQPAbQ1a5FcRtm24ky3JiYGB/bUrFb8e+E0n1FdCDRHXGd4PAaErEPeaOZdwCGH0vpy8PSrUuHkNp4gkjlJPvBOfc8jLzwMsRqJlMj6rDR/hPTdXiQ1vhjIMCFu+GVfqLI52gvatKwv4FyDhQxeNY/9+lboPz/sC8B9uA2LMYPP3rE5HBkTIjmk4VGZk9FjwYTHtb9scTlAgDhs7jw7oZYk6Hg2gm1blpyYHSHjK1vRfHqOvBoCUJTXPdcxaFmc5GLxE4TisMpMEJ4UKBjfv+lEfUqGKkGCntaVmBqJ9xDOrEkjSa4v7Qjo1nKJrBFvmNoATNY2714PNkZFE8WQbnCGT6a71hRcFVVo+YOojhW014ZyrE3sTy1WGKr1mYnHjIv3my8rKItijSuRwUIU3j2Iuz9jZ9w1+S6Ndg6FRbeXFDctExbTK+21z20d75TqJp4ptygFZR9wxTv9aDPllWQb9Fqp96S9d6CsEltvv78z3rUxvY+9sPZjsOEmojnynSv7PVXQwvXtC/ztFdLzJ9BaLAj2vw2KX+jFFkv/YldUmnWuI8PVTZNsYbKH9tmCCm+GeCs9pKDRUrnfsdnPon+QXnOjP2J5t/zNXpv0CYin52uY7RNuiDKjYEragGn58UfOg70YTx9bzJWRu4yq15u+lozfHL19puxtSevAOdiqMffGFC80SDmBy0oGNqACCmZTPOqAUB62Un16fOURn3O1lkkN1YD1hNxjdSQQ5cwIwtWp0Md8aLD8ksLS23xmH+8CBLv0EgV+reZWCPNh870D7ifZ5JD9bdHLGcJCfySoO4xP4OYrPlK7GRdOY9043RoxhkaABZOPuaRktINkT5KX3DwaVFIMWzGZxvvooyeWjvAOtjgo8WJWpRPmqwwi4jjmYHNyon
 hBR33kw4
 zk03wStSYFbJ7t3SRWr6wlm54TNf1xmr35dxLaEMNOOahefkg+BsxNGDgLUaOjyswtWJavOxSDr5BGhjUF5X6/y7UbD/CAltjquovD1CQJXWvsa1d4izXDA3HginQc+GpJLFMDQBEylBRENAGXEI9mv5mfwMrdpCddrYI/X7GYmvX6pSW2FV6cHdpY2AtGnYSrJAjkFrRK1dPMrsIKIkpt54ho0Yx6njDZb6iiU24auyZd2UkC5yCVW4s0WISUt/zn9wZzOigAqC66CUXpFHshDoFb361XJTikAEFtKGd6HfC6/OCxaqMAAekuQ1fpGAfckihSfimQpl47t7084GxVLD01MUiBaOzK+iT8Ju+V9GFkSuCK0yw20dB8kFfmSniyoRvAPrC0svcCcPn2rkyWs0CsCi/n6n0P46WAqFzXE3WeVDmjOEhpWfG1BLXbcpFLn04OC8shCxjkfb8efZXem99dx0NNhzZTcLQVvrP6H3nEboDDGRdrUm+nAbbcgdyylfy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------B0QdMbL9ogUbc1uFToe2mPr9
Content-Type: multipart/mixed; boundary="------------XUrLp9QppIPe1C4Gxvb0MSiE";
 protected-headers="v1"
From: Harry Yoo <harry@kernel.org>
To: hu.shengming@zte.com.cn, vbabka@kernel.org, akpm@linux-foundation.org
Cc: hao.li@linux.dev, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 zhang.run@zte.com.cn, cai.qu@zte.com.cn
Message-ID: <7f211fa8-e2d8-4878-a8db-fd275d4c6821@kernel.org>
Subject: Re: [PATCH] mm/slub: fix lost local objects when bulk remote free
 batch fills
References: <20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn>
In-Reply-To: <20260704160450302fnznThT3hBeBiwlhE-oGv@zte.com.cn>

--------------XUrLp9QppIPe1C4Gxvb0MSiE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi Shengming,

On 7/4/26 5:04 PM, hu.shengming@zte.com.cn wrote:
> From: Shengming Hu <hu.shengming@zte.com.cn>
>=20
> In free_to_pcs_bulk(), when remote_objects[] fills to PCS_BATCH_MAX,
> the code jumps to flush_remote to free the batch. If all remote entries=

> have already been compacted out of p[] via tail swaps while local objec=
ts
> remain, the flush_remote path returns early since `i < size` no longer
> holds. The leftover local objects are then neither cached in the sheaf =

> nor returned to the slab freelist, causing a memory leak.

Ouch.

Interestingly, we fixed a similar memory leak in free_to_pcs_bulk()
during the v6.18 cycle; commit cbcff934fa7d ("mm/slub: fix memory leak
in free_to_pcs_bulk()").

Hmm, I feel is a signal that the control flow is quite complicated and
worth revisiting if we could simplify the logic there. I'm not saying we
should do that to fix the bug, just mentioning.

> For illustration:
>  size =3D 64, local objects at p[0..31], remote objects at p[32..63]
>  After scanning all remotes: i =3D 32, size =3D 32
>  p[0..31] local objects are dropped.

I can see that could indeed happen.
Interesting. How has it been undiscovered until today?

Well, for this to trigger, at least PCS_BATCH_MAX (hardcoded to 32)
objects in the sheaf should be from remote nodes.

Looking at kmem_cache_free_bulk() users:
- maple_node has sheaf_capacity =3D 32
- skbuff_head_cache has sheaf_capacity =3D 28
- panthor and msm drivers have sheaf_capacity =3D 4

The capacity is (at least for now) purely based on the object size
(with user-requested capacity as a minimum)

Only maple_node cache (out of four users) has
sheaf_capacity >=3D PCS_BATCH_MAX.

However, for this to trigger in maple_node cache, ALL objects in the
sheaf should have been from remote nodes. And that means there is no
local object to leak :)

So, although the logic has a leak, you cannot trigger this in reality yet=
=2E

> Replace the goto-based flush with an in-place free of full remote batch=
es
> during the scan, then resume processing the compacted array. All local
> objects now go through the normal fast path, and the tail path only
> handles any leftover partial remote batch. The redundant next_remote_ba=
tch
> jump label is removed as well.
>=20
> Fixes: <989b09b73978>("slab: skip percpu sheaves for remote object free=
ing")
> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
> ---
--=20
Cheers,
Harry / Hyeonggon


--------------XUrLp9QppIPe1C4Gxvb0MSiE--

--------------B0QdMbL9ogUbc1uFToe2mPr9
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQQQ1ub6gR5ogjaKRmOGXBN6rc5S1gUCaknhmQAKCRCGXBN6rc5S
1oiJAP9yRGJ0XdV2ZAHxJ346MUIWLyf26AnizXwKcn6sT5UQ8wEAhFVeSyaKEMOk
YeYpdg+WF68xx/8IogS8hl0Dg2+olgw=
=FnEW
-----END PGP SIGNATURE-----

--------------B0QdMbL9ogUbc1uFToe2mPr9--

