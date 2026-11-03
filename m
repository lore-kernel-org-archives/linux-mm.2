Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48A19606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 03:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iI8p6WHO
Received: by kanga.kvack.org (Postfix)
	id 46F436B05B6; Mon,  2 Nov 2026 22:25:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 41FAC6B05BA; Mon,  2 Nov 2026 22:25:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 362A66B05B6; Mon,  2 Nov 2026 22:25:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4906B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 22:25:03 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 953351A0317
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:25:02 +0000 (UTC)
X-FDA: 85392366444.26.092DE74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id DD36F40003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:25:00 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iI8p6WHO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793676301;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5qDS/TF5jxCzBs7vCEnMNgqtroTkKKC/uyfYOW3A7M=;
	b=TdltKLe0G5uz7HEANnfnoQ0S2Xe4rim23E66chSrlgLC9nm0Blyb8Xl9UhwYzFHcyG515m
	WwBKWS6gww1cU8WHRavNaCiXzJ5avg+yUN5CZSxoAeelr2RMrmz4H1s4d2e9id0PNVRVxu
	8a2kbVX/71HdBAac7HheoAruMolRPYM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793676301;
	b=5cp15kVoxafLRmidngoFznTHVCTmWjswKZpzQf45aykl34LnXgy8Hqj3tgJbOS/S9HiXNM
	+7kjlotufvPP95khTfYBWMOBslUOnY1EPR+EowWnEZo5kCXaUrH57brvIqHE6shBFB/4Zp
	cTD5CAcHBVoz5Mv1qB0/kyQT0nlssv4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iI8p6WHO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D144C437C1;
	Tue,  3 Nov 2026 03:24:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B4311F000C1;
	Tue,  3 Nov 2026 03:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793676299;
	bh=J5qDS/TF5jxCzBs7vCEnMNgqtroTkKKC/uyfYOW3A7M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iI8p6WHOgZAAgUjT4C1OOxNy3GkVmYlaM83TavYXRBjR69gceaPSoduq+QMi6PYoO
	 i+eM24/ALfbOhchiY8gyqO854dh0/WWcWVz4t3pVvUgTsdUrLLQKafFqe2OCeqiXRl
	 HHxbXojqYOBJRVeBWQNqf2eEWjhqYyddI1sKB145tbhH7zAQzJldYAtEzHsftzKev3
	 n4zdg05PNVvuu37UsFe2Ow2c/tf79JexTz74I+kEFU1cG/2yvqGFpOsdJCxA++piPy
	 89fEDUUIa/uEEtTA/mJ92sGTiUJBHU0Fgzq3BGqJb5W9s2F5L9v+FMauSJsRWGss2E
	 8VWhh9shmUAgQ==
Message-ID: <sashiko-outbox-194509@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 1/3] maple_tree: Fix rcu reader NULL dereference
 after the tree is emptied
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TGlhbSBSLiBIb3dsZXR0IChHb29nbGUp?= <liam@infradead.org>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Lorenzo Stoakes" <ljs@kernel.org>, "Chris Mason" <mason@kernel.org>, "Alice
 Ryhl" <aliceryhl@google.com>, "Andrew Ballance" <andrewjballance@gmail.com>
In-Reply-To: <20261103020724.2614498-2-liam@infradead.org>
References: <20261103020724.2614498-1-liam@infradead.org>
 <20261103020724.2614498-2-liam@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 03:24:58 +0000
X-Stat-Signature: e78e45ysfs3nmqp7o4hmnbrcu1am8wtj
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: DD36F40003
X-HE-Tag: 1793676300-531481
X-HE-Meta: U2FsdGVkX1++BxA7I1GRSU9nooadBHKRwvsOuVpvzFPHYbYkDIcmmN34kpj99nNirSRzs6lQhORXD3wHrIhGDRFiqRkixP897Puou+esymDFT7vmZrt9cPkqEs+j3rHI4scvreYqquIXG6Y/v7/uJTtKKFoztGeMfa+Wcp5V/EvujFoJ+mNPPp5/m+VGQt6dli9nx9wFmJuLqM/LWPgHrEsTnq9CXSRUUIkd4DJEYa/CGMWtAW9Zgy3VUC3dDu6n7rlxPyXQ+D1vwFIw+BLqwRYC5ijHGfxFCdbk05QloGSycmTvIef8wYNMztMFbt53PPNgpumuDBwYbmgYFKqcMUfqWSsmAbdNjPPHNx0gHW4DZPYLN3QxxVWaIrMff/PvgDjgFcMWsx4NzhbQX/bkNdmuYq9WviVlDC4d4+sUcqJPOLkYmomrjWnTUh3/OS0KtH3lPZklOB4tcd+MzHXbfqGDMuOFz1PRezsnyOg6S61JThBvhSrOK5v7HLGlmm+Z5lwCUYV3h+pGSYxMm24mT5+wY5mf5AdHBV510EhNTfekbh8ILAwWmOzceYcI6Yx2RreuhZIVAwWHf5Ifxhc2t3tixUwG1kDb3dQdaQA4GwZ8s2RU9ZdE1Si0vlNLPRrfURQveJ2S2EipBGwD7UC4leYsOAKsJO6JJcncvK6PVqIKDQjN6H8GdC0yf1RJNHIu/NUC92KmN6h48n+axTZ/6TYjTuz1fIYSQwaA13PXNBo5vdrfiPMvvMMI9D6Bbufysw0ppcAls9yX8A9cNcn6eqGVa4Uz0sGmL8NZU75cZaEPnHd3hkTDhHuhMIcmSWNNqbQoj/uUktmKC98dfNSg49+GEusSaMegcu1fIAHGd7lbYhfuYrOZrRY4aeW3wPmx+9vcIgRwEXSEvXzP62Z11j6dkAWK6sRCUGUIcBg1vELiaZkDlSS0qC24GA7cDoxQM95tyl9dTqRiy2ryehR
 OF1M0qXE
 CclkCu2m6TNbgf8ZYVZgBCMuZVPb3pggN6y1e3X8Ey6Mx/z+UsnUoVF2VEF13YwWLjXwF56sXWHUbDIOk2Zg5e6QVOzYNds7U6N5p9gY7t3NNGisR3SVN07OAsJlxsWXQRu4bHpDuie0wLXf9GksSwMeVR6DnkN1G6/je7rTDkF9ehFG+Io3CqRVyR8AP25uZXS+ny398yPA+01VH2m61xT3FLP34ywBCDFNWtHC/KBx5XH8aSVtDPzfiPSPmWs420cpTQZSgZk64M3ucokFcY1cseuZmiIcdmbNqCSG6SldgYTW9MXO0VPqsKfg7xLVd5fzEp6ZsZPAxF/L6DDQjV7YRen7yTXcm79wbIpWK5kv1wqGR9Zda826UbpdQzBJ/mpC/c//74bGAX80cTrtSsS6+R4BwjoNQYXHYVdy7qj8e0vW0RP40s80FP9P7k5G4xwgewDtSDde+TiLo7FxPi6+cKvGClYX9qKCQvjXYX2VcKJ80efnntf3IDisGoDMacrfto/tGp27Mn7BzPeiIi3oBxDb8+eSqFBuj37qsN8IfVnja/RaNAbuOrttKFhFr1HOPhDvvbncVM8zVDKcEo8dyxudNdO/YcTPWsnWJ1kitKDVc/AoDAimb4TKZURPdbd0oDQMy4AJONQvngGjJt9RUJsHfKMBk8ngyWSQl6YWG0ypYbU0Kd0piJACahhNL7yTDxuS1s0tWnSM=
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
- [Medium] maple_tree: race in mas_prev_slot() when root is emptied after m=
as_rewalk()
--

commit edc2da191bb5cf8aae2a20e02f12ca0a680681ac
Author: Liam R. Howlett (Google) <liam@infradead.org>

maple_tree: Fix rcu reader NULL dereference after the tree is emptied

This commit fixes a NULL dereference when RCU readers restart a forward or
reverse walk from a dead node after the maple tree has been emptied or
reduced to a single root pointer.

> diff --git a/lib/maple_tree.c b/lib/maple_tree.c
> index 0b0036c9f8489..a36dc20af84c4 100644
> --- a/lib/maple_tree.c
> +++ b/lib/maple_tree.c
> @@ -3891,14 +3891,56 @@ static __always_inline void mas_rewalk(struct ma_=
state *mas, unsigned long index
[ ... ]
> +static inline void *mas_prev_no_node(struct ma_state *mas, unsigned long=
 index,
> +		unsigned long min)
> +{
> +	mas->index =3D 0;
> +	if (mas_is_none(mas)) {
> +		mas->last =3D ULONG_MAX;
> +		return NULL;
> +	}
> +
> +	mas->last =3D 0;
> +	if (!index || min)
> +		return NULL;
> +
> +	return mas_root(mas);
>  }
[ ... ]
> @@ -4063,6 +4103,17 @@ static void *mas_prev_slot(struct ma_state *mas, u=
nsigned long min, bool empty)
>  underflow:
>  	mas->status =3D ma_underflow;
>  	return NULL;
> +
> +dead:
> +	mas_rewalk(mas, save_point);
> +	if (likely(mas_is_active(mas)))
> +		goto retry;
> +
> +	entry =3D mas_prev_no_node(mas, save_point, min);
> +	if (unlikely(xa_is_node(entry))) /* The root changed again */
> +		goto dead;
> +
> +	return entry;
>  }

[Severity: Medium]
Can this leave mas in an inconsistent state if the root is concurrently
emptied between mas_rewalk() and the mas_root() read in mas_prev_no_node()?

When an RCU reader in mas_prev_slot() hits a dead node with save_point > 0
and min =3D=3D 0, it jumps to dead: and runs:

    mas_rewalk(mas, save_point)
      -> mas_state_walk(mas)
        -> mas_start(mas)

If the tree holds a single pointer at index 0 at that moment, mas_start()
sets mas->status =3D ma_root and returns NULL because mas->index > 0.

Back in mas_prev_slot(), mas_prev_no_node() sees mas->status =3D=3D ma_root,
sets mas->index =3D 0 and mas->last =3D 0, and performs a second RCU read v=
ia
mas_root(mas).

If a concurrent writer finishes emptying the tree (setting ma_root to NULL)
before that second mas_root(mas) read, mas_prev_no_node() returns NULL.
Because mas_prev_slot() only checks xa_is_node(entry) to detect a concurrent
root change, it returns NULL with mas->status =3D=3D ma_root, mas->index =
=3D=3D 0,
and mas->last =3D=3D 0 instead of mas->status =3D=3D ma_none and
mas->last =3D=3D ULONG_MAX.

Could this leave callers like mas_prev_range() or mas_find_range_rev() with
a bogus [0, 0] range, or cause a subsequent forward walk on the same state
to skip index 0?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103020724.2614=
498-1-liam@infradead.org?part=3D1

