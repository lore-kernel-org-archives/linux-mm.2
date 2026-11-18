Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 12A44606A325
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZvQNE8at
Received: by kanga.kvack.org (Postfix)
	id 861476B05DD; Wed, 18 Nov 2026 16:17:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 811696B05DE; Wed, 18 Nov 2026 16:17:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 700616B05DF; Wed, 18 Nov 2026 16:17:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8BA6B05DD
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:17:00 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8186A1A0790
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:16:59 +0000 (UTC)
X-FDA: 85449499758.03.9ED1F9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id E292740010
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:16:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvQNE8at;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795036617;
	b=qfLxJa9il5r1BZVK2+xaQbmCwvC0TGc0+l6tqaXYTj85zqTYdJOwaqdP7HHhxWmGw5IeTF
	yFBHHxhAI3ZGlynFRw6MsJB94uMPqj6GwEk+z3OM5AbRVmr85YFOzM5ywPL/uHQ6+NY0h4
	bFHW2tRqGcZ/LxW5wnJt/aXO287nR7I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795036617;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sJGJy+mnoW83ohEBNWbuL9yI4yI37aMf0neuVdmknf4=;
	b=YJV/jyNuIeddLulNTGavKAMeFG+i3iYuSGb1DnGUZ3xRCI7j/TwIIYvT332yawD3YNbjlD
	QdjC55a5uC8kzvIcxMGj0wtv+eXvW+0q9tMKZnpcoOt1BzLjqggt5ksvn0RcQ5jv6F3I0x
	ebNN9a7HAvRsGWimrblurMEw5l1aAZA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZvQNE8at;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 80D8E63E09;
	Wed, 18 Nov 2026 21:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C4F1F000C4;
	Wed, 18 Nov 2026 21:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795036617;
	bh=sJGJy+mnoW83ohEBNWbuL9yI4yI37aMf0neuVdmknf4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ZvQNE8atQYI6cs4IZqGvJ2LE5E7XiCXiMjGdpU27VfbuLCr6JnFIvgpMRvEavVKzm
	 VQ/waJcq5WAktrShedwoYdvF+kUxjSldFu9FQhnbxQxuf55Qd6+qepAr8ZWTGFkwwn
	 b6Lykns3woMy/bI+Y8WyWesR+TUxDs/OrO8BbB2PYqI8ZIYxBj4iEhmNw9RjEB4ANB
	 8kS+8U3qh1mnhvSjbNfjjiAToFsmM9imZOH8vh/g3cc8Z6PMLzq/BSZYWULWJmt7gp
	 5sGwaq6MZ2XgyINVRgR7rtHGPv2aej6aMsaCXdDHgCxZ88dm8oWQzq90l79NLFa4N5
	 Ke43UcA9AjUBA==
Message-ID: <sashiko-outbox-221984@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] [v2] mm/mempolicy: replace copy_nodes_to_user()
 interface with put_nodes()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Gregory
 Price" <gourry@gourry.net>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, larips <larips950@gmail.com>, "Zi Yan" <ziy@nvidia.com>, "Joshua
 Hahn" <joshua.hahnjy@gmail.com>, "Rakie Kim" <rakie.kim@sk.com>, "Ying
 Huang" <ying.huang@linux.alibaba.com>, =?utf-8?b?TG9yZW56byBTdG9ha2Vz?=
 =?utf-8?b?IChBUk0p?= <ljs@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>, linux-mm@kvack.org, "Kees
 Cook" <kees+treewide@kernel.org>
In-Reply-To: <20261117211635.2472067-2-arnd@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
 <20261117211635.2472067-2-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 21:16:56 +0000
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E292740010
X-Rspam-User:
X-Stat-Signature: wzmdqjgf6tr4skq6onge4twi4j8n38zp
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795036617-554371
X-HE-Meta: U2FsdGVkX1/zBBeh2nKhn5hzeYc7aobtR2Z/fVAJPqnCUO7CEuHob2+LUO+BHyTPfNYMcIqloBQfiIyJmZvXljKp2kByLnEbbqQnjWOi9NvpwJVP2gFuXpqzVHMjsGELorB9dQb1o024eLxTo4OEjgnHEzKdUmE2c9oZsu9CavuhxW4nmAZauBxJX1TCkHdeiPaWafQB5gMQnZFHcsz024Y5r6yKTy0lNpUyJzdZ32YUQe/MKYW2KN7Ja6u1aRQAV4TUmZtwGBtQF3QrD8ozV7PoTlNw6DhQh/PHXDGPpY8rG6qW/Ph9Aj4oo5Fm8wL/fC1sbuxXiEcuygFJwz4QGI233irJB2eI6XwAeyHXhJyNG+ULZPgkhJtV++69UsQN0KMIA7JHZnVfwhT26RU4AnO7RSak+K6W6y+NQ9gcYuNklUpCP/ObDcOz59l3jvWnTZg9tSyAt9BgXN2vSe41n6rxN+daiBtd9GVY5cz2ne8mVNuv/6+0x2z2nn2PBNTNCxKnw6Ir9yuH4vnBJ6viXEJ3c8mI1gigJfz5CVHA3SJRvdq895ke+ivlzwXU3HOsqaPJ21b8HijxqXZimPYuM52FKxE8zzillF3Lebt3CPCRis8Ktkd+Vg4vX86drcxm3aMFW3Z5hu3RJ/1aMhBCJtkO8a0RbaRyUV2U3GdGLvnlp+dLWVh88cFIG5FpZi3AMXF9wjbFQ95LYBKAtzzaJNXSzjDTH9WSJ+WEPEtyR2DVMfjwDYm6UXoW73QnrqPUZuS5mRiW/qJrUDRymub5MVeqrrm8sK6pDuVdsy9RLo4zHbsDlAI4Z8nqEIkf+ey89/k3jF1xPkvAlYwFPK97eUjwro2gpE/QRsjQ3+7RuYVZjn4CASSNe5UtMGOQlo5MeaSLxZIB/HF6uWvWGBxg+udNwr9zQ7oBmnu/ZLsessnffjaiq+k98L/GzqzaftG9eAS2qJ+EvJZlutJpcxJ
 YHKO8GBU
 KqivgbiLWKL+cRmhNF1B/q3RU92S11rgdFR7VLxONLpU4I7Nfx8ZstJXTJNcee0q15x9IzUtZF5Cn1CTXTq9IqAvrYxGrfwowMfttDqNDsRJX+wopAhQkYfjtQoeDPGHtP/yv9foDicoFxRUvcFURE+RTzgwAd6ABUi0fpSbm1PCJWagMed8q1jLw1t2p5dEG3x5DBA8X+ZBE5cvYrmZCeULMaYu/R81QUWTdhgEn+5AdRtNI/0QkW3HOO97rFzhCDPLDpU1NKVlmp3ICcTG+raRI9UzUAhM5ArVLUI6BH/LyDFIlIDyvBqMnYx06xZ5KmMeLMXD+YLrGFHJ4oqVUirAcrIN38vJBItXtZC4VdBiP7iZXpRsG7wvxqcCcquBuF0zu4NC0k9O0y1J0mTvX3uJBXxq8FHQ3b6lI0/k9rO/S3e5icKu3LaO1BG38i58ldXJaIcHPu0mdE9lX9qsChS95qJZfmTZTDU0+k3WttdAMhk39HmksBxLW9kLUgCJRWqIOv2XOsgbSR0+WUlzH0QhvDpTenZjVm0sEwT/uATQYFQVzpH5n/RV5bxBLNSPxpnCfl4DUNajWBsw9f0fNNFjF3XajxtnZ0m/vfB4V/EY4NAh5s3PH3pJtriSqALKv8gAlKBkCC/LTpBB/+ZSDZSPUhDljGteD0zmK+wdwHPsSDoskVc7feuPJP1PgHcf6hRSwqu86mXKtp9Eq+ufwnHFU27yiJEP3/nhy3FKLnua1/l6MeQn+7VtunkODBqh/YWFC2WycL5Ru1TXAra+v5yDN/dkYMLQjBkj1jlzjU60ivJ5o8eB1TYgE+eU1S+4AzKi2um+IP2ChUljIoRZSA126A0W0AflqUN4FXWKb7Ak6zHhzLkLGwxlTg9A4YY5dZrrisDgYEp9G4jAyGI7DhbEhVG3xznXJfLqGBZozwKbiW0vH2rXATnpRgQ==
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
- [High] mm/mempolicy: unadjusted nbytes for compat in put_nodes()
  leaves 4-byte gap
--

commit 2830eda1a2add7e034fa70931e6090d2764cf894
Author: Arnd Bergmann <arnd@arndb.de>

mm/mempolicy: replace copy_nodes_to_user() interface with put_nodes()

This commit renames copy_nodes_to_user() to put_nodes(), reorders its
arguments to match get_nodes(), and decrements maxnode once at the start
of the function.

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index c10f9d4ba38f8..47bd36ac70787 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c

[ ... ]

> @@ -1717,15 +1717,18 @@ static int get_nodes(nodemask_t *nodes, const uns=
igned long __user *nmask,
>  }
> =20
>  /* Copy a kernel node mask to user space */
> -static int copy_nodes_to_user(unsigned long __user *mask, unsigned long =
maxnode,
> -			      nodemask_t *nodes)
> +static int put_nodes(unsigned long __user *mask, nodemask_t *nodes,
> +		     unsigned long maxnode)
>  {
> -	unsigned long copy =3D ALIGN(maxnode-1, BITS_PER_LONG) / 8;
>  	unsigned int nbytes =3D BITS_TO_LONGS(nr_node_ids) * sizeof(long);
>  	bool compat =3D in_compat_syscall();
> +	unsigned long copy;
> +
> +	--maxnode; /* user space ABI uses number of bits plus 1 */
> =20
> +	copy =3D ALIGN(maxnode, BITS_PER_LONG) / 8;
>  	if (compat)
> -		copy =3D ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
> +		copy =3D ALIGN(maxnode, BITS_PER_COMPAT_LONG) / 8;
> =20
>  	if (copy > nbytes) {
>  		if (copy > PAGE_SIZE)
> @@ -1733,12 +1736,12 @@ static int copy_nodes_to_user(unsigned long __use=
r *mask, unsigned long maxnode,
>  		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
>  			return -EFAULT;
>  		copy =3D nbytes;
> -		maxnode =3D nr_node_ids+1;
> +		maxnode =3D nr_node_ids;
>  	}
> =20
>  	if (compat)
>  		return compat_put_bitmap((compat_ulong_t __user *)mask,
> -					 nodes_addr(*nodes), maxnode-1);
> +					 nodes_addr(*nodes), maxnode);

[Severity: High]
Can this leave a 4-byte gap of uninitialized user memory in mask when
called from a 32-bit compat syscall?

nbytes is sized in unsigned long units (a multiple of 8 bytes on 64-bit
kernels) and is not adjusted for compat, whereas compat_put_bitmap()
rounds bitmap_size up to a 32-bit compat_ulong_t boundary:

kernel/compat.c:compat_put_bitmap() {
	/* align bitmap up to nearest compat_long_t boundary */
	bitmap_size =3D ALIGN(bitmap_size, BITS_PER_COMPAT_LONG);
	nr_compat_longs =3D BITS_TO_COMPAT_LONGS(bitmap_size);
    ...
}

When nr_node_ids spans an odd number of 32-bit words (for example, 1 to
32 nodes, where nbytes is 8) and a compat caller passes a buffer with
copy > nbytes, clear_user() zeroes starting at mask + nbytes while
compat_put_bitmap() with maxnode =3D nr_node_ids writes only nbytes - 4
bytes, leaving the 4 bytes at [nbytes - 4, nbytes) untouched.  In
addition, when maxnode is between 34 and 65 on such a system, copy is 8
(equal to nbytes), so the copy > nbytes check is skipped and maxnode is
not clamped to nr_node_ids.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117211635.2472=
067-1-arnd@kernel.org?part=3D2

