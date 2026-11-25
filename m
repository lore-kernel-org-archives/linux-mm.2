Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F95606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YZloInuI
Received: by kanga.kvack.org (Postfix)
	id ED4B66B0931; Wed, 25 Nov 2026 03:23:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E855C6B0932; Wed, 25 Nov 2026 03:23:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D742A6B0933; Wed, 25 Nov 2026 03:23:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB8C56B0931
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:23:20 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 300BF1C4976
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:23:20 +0000 (UTC)
X-FDA: 85472951760.28.530AAF1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4AB7C4000A
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:23:18 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZloInuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795594998;
	b=Jd5G1EyFg4+LFWeSIbWpx/QplDcjtz2LZuqHl8owprjDzzpS4oHneqUZ96IdnnVx8NLJik
	BYpetfDCo51Ci8ymQjNfW9TNNXNKfdtA857zFm5GUgptVK5DqloNTjIZPnVOxXBrLtlB9g
	/EYRkSXrIoEfyfIbrUXuRAQtnrbIDNw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795594998;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hsT7zBmMHOA0tSmt3vFfihAtL6RUpoMsSd3RGk73F2s=;
	b=VVRu9e0hj7sagofvyTPmsSg6uRxQs8BTV9zFCmiw+qeCxrfiSZwwKRkDLnJmUzYKjyNLw/
	jscbGKMK+gId5uJFafOgc3OefAFhuifc96MTbZaQIVp9Cu+8ECHyDL9JLdh5sSftBOIuzd
	5zOu58+L0wKY223gWp4PTe0N2/KmggU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YZloInuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0074362386
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:23:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A30911F000CF
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:23:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795594996;
	bh=hsT7zBmMHOA0tSmt3vFfihAtL6RUpoMsSd3RGk73F2s=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=YZloInuILkJ9lmMUSqL/V1E8ZE2MR7DT1FHtU5vmr1pynf0SQxxjVeQeMdQmCVdOU
	 yI5vYa/MpHD51913RjFTE0cfACo+wFIrf/YlA2+0n2ByuZEuHOIiFSIN2MxoTdxOq6
	 YQdPQHNk2d43l8aIC62EUfQ5OpRhtdKq3RVYmk61kUu7I3Wo83lhI1Bihi6LX3J1Gs
	 xPyd1O68e+0uA3TiIzPNRDmP1QZvMcU27ndaND5Yx03x0lDJYvF3ZXDwQ82WcwthQc
	 lnTas0aZN4TvJdDeJhA60y3x4W7yMTozdz0arecRmKxYV/HG+m5OCSjgLGKDVl7ITw
	 ZyXG2yI59pwdg==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-94999a08973so510508085a.0
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:23:16 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErGcXxkjjHX2IWRq7fmkcgltOH3c7CSA+1iaDiEyO0ofyAh9XvFMscCg4tPKuGJwNsktLsqqojntOA==@kvack.org
X-Gm-Message-State: APuU4Z/Jc6xe5Ed428Z+u6TBdiebqzVKKrI2aj6K0V1lc4e1A2HNpHtg
	6B/lM7MFzWp5OJuR7TjuednJ0LGTIXXRq2UHh5Vxls2PNvdiTCH6xE4sLlUg2rKIRH+PH/tAzTw
	xfbinfokS3lDQ2w51pqAv79VBGpcOQZo=
X-Received: by 2002:a05:620a:6c18:b0:949:664e:e3e8 with SMTP id
 af79cd13be357-949ba997635mr2899642585a.34.1795594995906; Wed, 25 Nov 2026
 00:23:15 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125073931.1171242-1-hui.zhu@linux.dev>
In-Reply-To: <20261125073931.1171242-1-hui.zhu@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Wed, 25 Nov 2026 16:23:02 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zvaxT+TD2P0ephTRsjAeVo+9NdavmmxLnuoj6d7P5UuQ@mail.gmail.com>
X-Gm-Features: Aa3M54oYpLZLgx5RRSzL4wpUVCax0NId0FybUVL-U-z7-jqsoujZkX4qgzA3cgU
Message-ID: <CAGsJ_4zvaxT+TD2P0ephTRsjAeVo+9NdavmmxLnuoj6d7P5UuQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm: mglru: reset the mm iteration cursor in try_to_inc_max_seq_nowalk()
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Harry Yoo <harry@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4AB7C4000A
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: q1msxzo393gmzhpniixd7aj1wfy3qupz
X-HE-Tag: 1795594998-468902
X-HE-Meta: U2FsdGVkX19d5ztFDgCyIcr3QBmJy7ZXUgK5vzzcpzwb4GKRC1U+C8GI2/xv9EOrvh8zCisL4XKMk9s9T7bd9AlOcknaQo+L4H6YWHcQNaOIuchA8vyvv0h3Bh+SchIZiXfF4OYznsbNzjGQb4kN/t3uT92HACbo3TCOMcTssueZsT0RuntPy/HKNN/AmO7VGCKukUWuPKFDLE943jIdUmHQURTe/okieFjRoFAZoQ3C9Y29F+CVHodhxEQrT5HIvYR2X01u9aTDbNatHPCj3Fw+H5024FAlKpNPTP5YiPotXhPSSh6ExCg8aIKwqPxbwQa1jz92e9UjhVnJ39lORV5qtUtJ66hTP5ElTWZJNUYUbU0/0ocd4rYgqTkzrdbbWDwwSV5ik6s0cqkW4zCTYU4Rj3lbv+OPyiIfl96pEUsNHO7JT2PCD3KyOfpEMmpCgiCZbaHrnlcapxRgm6pknMiyZyO9Ae8E5f7DAXQxEhyj2YhN+pz77EhAJR3Q1S5A9M0hL3dQ55nOyQ/6WgCjp678QVwp9btDLOtnvPDPMR/DG5z+4nm0AnnKi9bzqFu5l5U7rbu6tlD6b0/9G1ocWkkNZmZNpwRLYsD89ddZ51pn7YYuN4mZoP3k4TnKN/QWlkNDbe5VyHIiBe4bVEXfuPSDZJXnt6gynRJoHFGgHhOx0mjS8L6KaVUxTPbxYwiwxSFOIUsDwbm0nKNgaoZlch39cMDTNDyj6SzyJP8JJTpgxZnoSli8jM7GTzCH4BeX5y48k4vwqzyG5r2PGrzCFzrBOjj5EtUPuGH0hdJLNWKpyVtCcyKMdxg3yNDABXhJF8au/QaKU81r/tbDdtv8wRexI1sMbuKrI5dC5jVeWastvxKP/hRnL9sjz/ILvhiBhP8Zr2RJrMkVlKj7fZAMl4tVOwyJyi5PiSWFHOnj9R6T1t+KZWUu9q2XvnkDF193wSuWrWyp/REH42V3jkx
 bVo8jCOk
 BKXdmkL2gN13hHQg5RLGP6cfBUuvsok1Dk0MFHJsILwAtDPapRL94AfKSE9OKBDWFy8q9tTaYdfwFU0uHipsewb0eUrEiTs7YO0FM1wp/f3fnFwE0m4RHZRG7vBZnba9w0jmvFx4fOWf1+G3M2kAeuj9LJzZIIEwmXIXwNWqTIEJAPVfETUQhY9AEGgmKw2Icas16Tgy3cR//sJ3dvqUuRXmFK9TRz3rMxfItbdTRGpsplG81RnvfXEOGoOQxVFUGkGIdjNxTj0J9anVkk7aUGAJo8+59FwWX9Zv2yVmLM91/KLxps72rebepA1EWtZQProJkn06i/MywRhgHUynU/Ko1vPzFjGd59XR2XVzVqKwkS2PaCVQy3Or03/LfWpGmOqRPzlr/EoiE5yjR6/fMXJDUr8qYS8rQ42lTAjuZGRHqlLqK6UPKt+v0++MUpAHhJ/+12BWXWo6Xd0CmB2F+6qp0bnWv1jfFjY+gPHuLRrVAUl/2eHgkIG35KRdwIBtD+RJVXADN37FxeiY8pUUZUP8g5a9TI2fmCx0YhjQWx0mCY3BfW9qxyzwgsPMU0joNwfbI+fzuvVGPCbnnk0ikOwV1MG2VeYxGU8S0W597ohEtF64=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 3:39=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> try_to_inc_max_seq_nowalk() advances mm_state->seq without walking the
> mm_list, but unlike iterate_mm_list_nowalk() it leaves head and tail
> alone. If it races with an ongoing page table walk, the cursor is left in
> the middle of the fifo.
>
> The next walker reads that as "this generation already started": it skips
> reset_bloom_filter() and resumes after the cursor. The mm it visits are
> the ones the aborted walk never reached, so they have no bits in the
> filter being read and walk_pmd_range() descends into none of their PMDs.
> try_to_shrink_lruvec() ignores the failed try_to_inc_max_seq() and keeps
> evicting, so those hot folios are not promoted and refault in the parent
> memcg, until head wraps around a generation later.

I'm not sure I follow this part. Even if the page table walk misses
those hot folios, we can still detect references through rmap during
eviction, can't we?

We also have lru_gen_look_around() on the rmap path.

So missing those folios during aging doesn't necessarily mean they
will be reclaimed and subsequently refault.

>
> Reset head and tail with the seq increment, as iterate_mm_list_nowalk()
> does. It is safe: get_next_mm() holds an mmgrab() reference and a
> concurrent walker bails out at "walk->seq <=3D mm_state->seq" before
> touching head again.
>
> Only reachable from memcg_reparent_objcgs() -> max_lru_gen_memcg(); not a
> memory safety issue, since lru_gen_del_mm() repoints head and tail under
> mm_list->lock.
>
> Fixes: f304652609ea ("mm: vmscan: prepare for reparenting MGLRU folios")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
> Reviewed-by: Baoquan He <baoquan.he@linux.dev>

I'm fine with the fix, but I'm not entirely convinced that everything
in the changelog is accurate. :-)

> ---
> Changelog:
> v2:
> Drop the helper and keep the fix open-coded (Baoquan He).
>
>  mm/vmscan.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6a1af9b92349..3601e58f2a69 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4694,6 +4694,8 @@ static void try_to_inc_max_seq_nowalk(struct mem_cg=
roup *memcg,
>                 spin_lock(&mm_list->lock);
>                 VM_WARN_ON_ONCE(mm_state->seq + 1 < max_seq);
>                 if (max_seq > mm_state->seq) {
> +                       mm_state->head =3D NULL;
> +                       mm_state->tail =3D NULL;
>                         WRITE_ONCE(mm_state->seq, mm_state->seq + 1);
>                         success =3D true;
>                 }
> --
> 2.53.0
>
>

Thanks,
Barry

