Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB9BB606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 03:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MogoHxc1
Received: by kanga.kvack.org (Postfix)
	id 88AE06B05B2; Tue,  3 Nov 2026 22:40:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 861BD6B05B3; Tue,  3 Nov 2026 22:40:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79F356B05B4; Tue,  3 Nov 2026 22:40:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 441BD6B05B2
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 22:40:34 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EE52C160643
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:40:32 +0000 (UTC)
X-FDA: 85396034304.05.ABBDB9D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1C576140005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:40:30 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MogoHxc1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793763631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+tZw0K5+jfSV2aRm7WOFqugUNHNTb6GHxCzlpfjuQew=;
	b=PO3Tpxz1ZnaeZAGPjcqYHaiLW2J0LewuLnYdT8/7OaO96HvMeUkuaRJYQsLcFRzCjTjSk+
	SqQCe5j6HkMWXqe0rczG0mD29YPPHMBUJbSErh5VJoj6TOMsjOKEchZJ7q5pXlWsmb0f0x
	075G6hThKHSBuw5k2Hz8MKnaUGckwSs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793763631;
	b=RKKRWf6agZYqUdNhIbWJoEAmTKa8V+ynXxnleaQ41xGsDGjn+4YicJMtb7JtqqE5/ebVvh
	jWEuH9qkks8Ih1YXcr6870Z9EedGTZsJyP8cQeVHUu1Ozd9pefhw2kl/d9p/AW/msbAF6m
	JKNOHyeOG3RFWwhKxiSUBxXO67M1wSM=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MogoHxc1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5DAC60AAB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE651F00A16
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 03:40:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793763630;
	bh=+tZw0K5+jfSV2aRm7WOFqugUNHNTb6GHxCzlpfjuQew=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MogoHxc1lDU2P1JZYWhARSR1ywNNKCZ8EfaS02CKoiTvz5PrWZR2PF50pgo5KbwYr
	 4DB+o0PIXodT0XRysk7/W/FJ3GssiEo3GZe/I8DRjr5VScVGmrzSYpXy8wb3EZAQRn
	 N9yFj/iSV7VxQu8MJctXaBVZLxgx3IDugiJDaiDqBGYTHmatKwSKUdZxPPde6mlugc
	 5lkROUH1J+Dg/qvVOJRx3E5QjYc5tYut+NwMQvAuR0nOAnB5/8lPtBKHQR5G28Cs75
	 A+bAtJCW7H/5vy0OicCC+tBWWZYzBvNK0tLnn0XSqgIqRHFfx7drVEGhKsKVgF7Ml/
	 Np3l598dUmasw==
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-91c60e30054so3192516d6.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 19:40:30 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBw0zj7PUG+PDz1dFt2dbc7CNbhwte+FvgqDWoceP1utqp2Ggc+YrkBVgENFFqfpq+migSJCZ5earw==@kvack.org
X-Gm-Message-State: APuU4Z/p0MxbRiAMdAIvh1QhFhFh+6aLZf76pMIRDTqePqW9L/pw9Eed
	lGqW+CAA/AAmrSj/LCAmafxoGO4RGYBiMxIVLnhjT3NKr+MI0Kz4/AU1zl7SanvKDJwE3XCYBKm
	5WAcgSzvzVUzHVn0pQtXRMn2YQy7CTdA=
X-Received: by 2002:a05:620a:1a07:b0:93e:c12c:9dd3 with SMTP id
 af79cd13be357-94421796eafmr2530707085a.83.1793763629745; Tue, 03 Nov 2026
 19:40:29 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103113711.1832834-1-max.kellermann@ionos.com> <20261103113711.1832834-4-max.kellermann@ionos.com>
In-Reply-To: <20261103113711.1832834-4-max.kellermann@ionos.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 4 Nov 2026 11:40:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4y+LX-CSnDJ59VT2nc-i=rB=4iMuBQYawMCktk-_SPykg@mail.gmail.com>
X-Gm-Features: AclHuK_7q4sg1JpsDk1OEkyOWm8WF60WPZ6zY6tzDeYRFIK1cRTEyQLp5iaugqM
Message-ID: <CAGsJ_4y+LX-CSnDJ59VT2nc-i=rB=4iMuBQYawMCktk-_SPykg@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] mm/mglru: cache the last memcg node, make tail
 insertion constant time
To: Max Kellermann <max.kellermann@ionos.com>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, baoquan.he@linux.dev, baolin.wang@linux.alibaba.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: rdzbdc4fmb8cuziy1uuhsj3iftfif1hu
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1C576140005
X-HE-Tag: 1793763630-403168
X-HE-Meta: U2FsdGVkX19etbOM43kQb1VgA5TUPKAsL8eDKCpLRPJOzgwbvzEc6xC81EVFEy8cKO6ZTZcr27CyO/vsFdHbl1p7XT/+w8rH+aCtR3jshSeL65ZvYrQ6FbDh0xy6bZhlObTFfpHRU/S6VdB1ixWHxIqA30osOsvuYvGe5VAF3YPc4eAdgwqEJRchwOQf3CkA8FkaDgjNFLcpY0RUggjjk8vNcFG1+juP/B748+2jhIMy2eKNk2DS9I/pNSGNapBA/x3b/SnP6yplG3+tEOtSBvE/p40ntaqWjCn8ytcVVSs9cf6r9c3SS343oP3WOFKRLiIJc2EOJDjnWTIYVyN4C5uGEfIG+r0ZOZSurERlxWzvnMsoQAYDxPr22R4XDIlZKku8KSZythdze4jhqagnCJqUmM87uo4MmBS6E2cPrPwTVrdiSF20eM7Iu+GEXcWnF3TimcyI1imspd4NNup1gZV74znSwRBodjTaTZ+30V/jXPIPzmiHHFisbDcX3mESrqmKWIE0qhw2dOgSw+f641PRDmSbBkol+ueUHvGKMsoBvNnHoNjx7H/RfWMKh/EfM+4PzkarZqHQgMiHvnVSfyNBzkkaigzGL4CLPNsgjN8dxwH/3eA6HEqI0WFNhnULQzGq2fZB2REDLxnVGjpehWTV4npvwQClg0ZfWuhFMEaR5DI0yzr6r4usYPmtjo2OXbHNoFvvEXDHhJQlBR4Hh5Lh+ZIqjLdW2pV0w2SsmbSNzFULW06/iZSRHY37cndIfJebhWH62+07+thsqII29KFX/C1xBkndc259chkpL3FfFl701mvJpE1KZ0l2mEjae81/QBOKYWMIUow0Qc4HeTCdc4gVuF5//Q5tbdkHxP8hdYfaX8c3e92Lvaxak/LyvE13IBf186DwDqomzAt3WhjhMqNNk6KxPbS+ZGUZk4T4ABKt8X90w5VAbJgLsDGD1LmZDrhx81Yjtdbcqm1
 vUT95rzQ
 4UYiCmHFsxnSiiTVUF7Z47dCU93DqT4WVcP27wpQX50BC1CjyRHmjCEn+BDIEa1oQOtZBN/B/Vorq6gwPwqfbzbm3OE3Nxd0Z9lo2F8id3h3vrFKp508dNlr7XnVe8sofa9vfAW2M1cGO7dAMJIiBcSTDUu9lyS7EchsOSpqoXgN2qJJxlY86ag7yDv/qxJnu9PiHd/xiILPVKxOqOPFnpBIAjk3gcGWr1MWKvDF9vV3PF/2rcwH1C0JbP83NgKrDH53qcbWY6tH6k0Re0cZmuk8g37YotsG2UY1MuCCcTLYZfQbPtat0xa/tXWyjYXeK/M2/95ltBZsGFV1tHT3Ul95eBJHlaVA+sM/mpNu4JzMgB3peCJyjerXh1l0k3xRqR1fIPz5rdiGs8qU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 3, 2026 at 7:37=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> Rotating or onlining a memcg currently uses hlist_nulls_add_tail_rcu()
> which walks the destination bin to find its tail while holding
> `memcg_lru.lock` with interrupts disabled.  With thousands of cgroups,
> this takes a long time and causes severe lock contention.

This is the main cause of the soft lockups and RCU stalls,
right? If so, we may want to add a Fixes tag.

The fix itself may not be directly applicable to stable
kernels, but based on the logic of this patch, we should
be able to work out a backport, right?

Another option is to leave the cleanups in patches 1 and 2
out for now, and make patch 3 self-contained as the first
patch in your series, if that makes backporting easier.

You can then move the cleanups from patches 1 and 2 to
follow the new patch 1.

>
> Cache a pointer to each bin's last node, making tail insertion O(1).
> This requires remembering the bin number (but the new struct field
> occupies a hole, so it does not grow).
>
> In a micro benchmark that creates 1500 cgroups and repeatedly writes
> `1024M swappiness=3D0` to `memory.reclaim` in 8 threads, the request
> rate increases by a factor of 9.5 and the average duration of each
> write request is reduced by 89%.
>
> All writes return EAGAIN in both runs; the benchmark measures the cost
> of reclaim attempts that cannot meet their requested target, not
> reclaimed throughput.

I'd appreciate it if you could also mention Ridong's earlier
work in the changelog:

https://lore.kernel.org/all/20251119083722.1365680-1-chenridong@huaweicloud=
.com/

>
> Signed-off-by: Max Kellermann <max.kellermann@ionos.com>
> ---
[...]
> @@ -4561,21 +4561,37 @@ static void lru_gen_add_memcg(struct lru_gen_memc=
g *memcg_lru,
>                               int gen, int bin, bool at_head)
>  {
>         struct hlist_nulls_head *head =3D &memcg_lru->fifo[gen][bin];
> +       struct hlist_nulls_node *last =3D memcg_lru->tail[gen][bin];
>
>         lockdep_assert_held(&memcg_lru->lock);
>
> -       if (at_head)
> +       lrugen->bin =3D bin;
> +
> +       if (at_head || !last)
>                 hlist_nulls_add_head_rcu(&lrugen->list, head);

Do we still need at_head now that MEMCG_LRU_OLD has been removed?

>         else
> -               hlist_nulls_add_tail_rcu(&lrugen->list, head);
> +               hlist_nulls_add_behind_rcu(&lrugen->list, last);
> +
> +       if (!at_head || !last)
> +               memcg_lru->tail[gen][bin] =3D &lrugen->list;
>  }

Best,
Barry

