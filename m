Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B84FAC982CC
	for <linux-mm@archiver.kernel.org>; Sun, 20 Sep 2026 09:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F6F76B0088; Sun, 20 Sep 2026 05:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A8426B008A; Sun, 20 Sep 2026 05:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 898BD6B008C; Sun, 20 Sep 2026 05:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 620596B0088
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 05:21:56 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5DB0140393
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:21:55 +0000 (UTC)
X-FDA: 85233598590.19.A3A0E72
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 078BA80005
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:21:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6ypJEi3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789896114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+D7/BT1IHpcDxVkUKhWYFCe5JmCtgbgwd+dQYTaICxM=;
	b=0zsSU2wtgS051/lT44ge2QcdKPXf8Z+2tbQs/zOqp+6xUzuJCLDYVWWI1AqOnRG5Ohhpl4
	xFZQ1NaylRszkCFEGqpRauBCg3vFhZMfWNrVh5RDUsooqPkEQTKr6nq2RFGqe88B1txfGB
	LgJFegb6nTlQHcCLNeD1oL0lztEIr6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789896114;
	b=x4L72F2gg6K2gvnYrYrncSVzB9B0TvTGY+u1ot2II1W88af1t3bq0zBuUxGtB9Yb4Chm6v
	9mzLVJnTmza+h3MqC045L8T7h3th85lc1XReGRDPDxJnZ/ePEiHSEGhAQWQs48wFZ4Y7nC
	xWdh59wvpnH3QEzkuR17xftbwUa1rS0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O6ypJEi3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC0E960252
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628391F00893
	for <linux-mm@kvack.org>; Sun, 20 Sep 2026 09:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789896112;
	bh=+D7/BT1IHpcDxVkUKhWYFCe5JmCtgbgwd+dQYTaICxM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=O6ypJEi3XmekbbWJhkr8fU5bGBhJpZweRrAPld86N9f+lKoQacQFpI6vCntJYqtUH
	 5WYVN219o7kSTBzJMetqeguRA5BWrydKqxe+JH3IhoLh4nsv97nwyFAUpCNzOKlaCF
	 O6I1YRYD+ydrxK6LoJq3xG9DTg/U4wDF6l0VWKcIwkgrSqofIfx8iuHqjWOAlx65YX
	 7F+/Ic/jPzyFsJ9hATZMIqljoOONJvpOf3QD66oamNWbY0cQ3TxHp6XBSjuoCjATnX
	 TbuyjTtyDl4i8eEjSSF9UfPbLe8NdTpFwmCVNS67/EoDnvjKwoSsZMV4aRrKPYyVKl
	 o7zrC/krE3tkg==
Received: by mail-qk2-f12.google.com with SMTP id af79cd13be357-93910c9ff1cso174126285a.3
        for <linux-mm@kvack.org>; Sun, 20 Sep 2026 02:21:52 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBx2Vnq4UkJdPmrnediVXEeJgwNXLDP4nnrutT4wKD1ruAlbwUyAVts5r9fxAo3X2RrXj0pJ8BAygA==@kvack.org
X-Gm-Message-State: AFuF++nvmBW0Yhc3QyMRx/J85IO0/KZ4NWHgiWW3haJtFpr4REQPFhNh
	+a4sY2RGyr8ArHgSygL1eNqLRhMSNwb1Kt0Navk4Jnz1rW3CCrl9j9o3f5qBEE1lkq021zW4mMS
	GqJXrEk5sW/DYhw7wxe5k5DvJhfwxvZE=
X-Received: by 2002:a05:620a:8809:b0:93b:d7a3:45de with SMTP id
 af79cd13be357-93bf57e5603mr459482685a.71.1789896111765; Sun, 20 Sep 2026
 02:21:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260920043015.3126317-1-ridong.chen@linux.dev>
In-Reply-To: <20260920043015.3126317-1-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sun, 20 Sep 2026 17:21:40 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xmoGWULDVNGj0LzRFFfxM4VVGg4Bx5Pz5cUfXx9uKrtw@mail.gmail.com>
X-Gm-Features: AcwNN1UQcUC92XzoRFaVg0eXTQk2xu-g1I5nlJQhu3nsQjCKfTWTt3DeOV-UAFk
Message-ID: <CAGsJ_4xmoGWULDVNGj0LzRFFfxM4VVGg4Bx5Pz5cUfXx9uKrtw@mail.gmail.com>
Subject: Re: [PATCH mm-new] mm: vmscan: put rotation-missed folios at the LRU tail
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 078BA80005
X-Stat-Signature: 8m5n6j8ua7jiwida3zs4y66jqu8ocp4g
X-HE-Tag: 1789896113-274933
X-HE-Meta: U2FsdGVkX18t14XRcf7gtHMwzYUNfeRmeynVT2wVUezJkPK0lZbTJmViTzqUebJJSBLFrIY3iCO+5qRvChk+N2pSTZVUsy1pwjrJBw14lPFPXw2z6a/gaa3ZM7MHel9Mm4bJ4sYlD58Ssm0yJvILDSR64NB092dA8LEY538os25hrD3WjXQFJq3Q0njZnvHHxQAkaTMw4MT+Y3TPOOFKMuGaFfu0VWkSRqIww8Go7TyHWgEn4GNKouDOnTA5bcnzfaE2HFgP3m0/3ZIYE/O1CHdmBMS7otOdOciMOaEqAAzIvBvBSS2rkh/l/sQQNJ12XbBbUbLIcdl/VzBSEOQDtuo5Hi4S0UoFX4TbnhogqQ51wAWefh1FaazW9caq9XDvay8DOCpsUGfNgJjhqUFDljjRi2ncDBzIa+aNhj8JqJByHRHSbwp0GNboZnAW1isY2kz8k2REGOwfaaUY4TycKX9U77KCgi02Wid9PigRPKkxAGuiR8befH8St2MGMM1MWAlF2+Ojm8g9qPt2Hg31j4lZ9BCsrBvBwCVzi7WcqY5Q/QEuGEKJKS3RB0Mlk2rgzLbTrIhZiB5IL8qSSlXMtZyRurqA8wLksQiRIpmJWzHLuLP4wM5vougEtlM0eSL7AfW2iCjazT/MSEsPkm01lCsF33n1dbFYqYkOCGvxIn9WROABAzzuOoPNlv69KsbvDG/1OVjNHNdT8pDpZyp92O8GQx/Ferh3yzcWy1lZZz28mtw8hCrovImZn6CWQPpYtOINhDPT75g8e4zW6IkCL+GI9xDk0P1TI15Yd2/kKcdW/nahD97+K5Y0uJYvQFOIqa5HvjHvbeqMzvdlh1IeifkM5JNoE75By8pE3hBAUxx/32EL8jf0E1MWNAD/dwm/ZKdu/X7mWuNw3fUmPDZW1tMyZCIHVEqIyiu6nDjeezFad6NrGH5JuSvs2ratp5bzJFfIh4WE7b5heHv/NM1
 nYQuOYJH
 JIXwzHxb2Ei1adzzevYbOA8GFS+sLPoWx3NIZKSsndUWAOn+XZKjx7yZa0CCKe0m/95MZQxjonCS4QC+TaSyH1/van91vMLLZeLrsGjFdKsVAAfFJwY1BqT4r8DAe72eG1wqUfAPaBm/GIPHwDI2GeocNwFsQn09+RmkQePtXpQcf9umTohGSEbTRvYdr97CHoSDaM6tJIJgmk1R1hOUGonZOERgno4lMsAenMGOjWKs3kvHP8OJUYykNOzVVZS229dZQ+Iv6k15nYhViQvbn/MGf29zV4erek5+D7JbVIxAbgmXqyqWvBRVaH+Ha1fHToc3W1ot8yhg4gCbYvG+hEAN8DNaihzzlP8q8EDz5MawNiGD7sZZd2AKu8qcgUkd/WMzg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 12:30=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev=
> wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The page reclaim isolates a batch of folios from the tail of an LRU list
> and works on them one by one.  For a suitable swap-backed folio on an
> async swap device, it queues the folio for writeback and, after finishing
> the batch, puts the folio back to the head of the original LRU list.
>
> Meanwhile the page writeback flushes the queued folios in its own,
> independent batches.  For each folio it writes back it calls
> folio_rotate_reclaimable(), which tries to rotate the folio to the LRU
> tail.  But folio_rotate_reclaimable() only takes effect once the folio ha=
s
> been put back by reclaim.  If the async swap device is fast enough, the
> writeback can complete a folio while reclaim is still working on the rest
> of the batch that contains it.  In that case the folio stays near the hea=
d
> and reclaim will not revisit it before wrapping around, causing a cold/ho=
t
> inversion: a clean, written-back folio that should be a prime reclaim
> candidate is kept ahead of hotter folios.
>
> commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back while
> isolated") addressed this for MGLRU only.  The traditional active/inactiv=
e
> LRU has the same problem, reported at [1].  A reproducer is available at
> [2].
>
> Rather than re-reclaiming those folios (which would drop the swap cache
> that may still be useful for a future hit [4]), restore the rotation that
> was missed: when move_folios_to_lru() puts a folio back, add it to the LR=
U
> tail if it looks like it missed folio_rotate_reclaimable() (inactive, not
> mapped, not dirty and not under writeback).  A new do_rotate parameter
> gates this so it only applies on the reclaim put-back path
> (shrink_inactive_list()), not on shrink_active_list() where the list orde=
r
> is already deliberate.  This approach was suggested by Barry Song [3].
>
> Only the traditional LRU is handled here.  MGLRU already retries such
> folios via its own clean-list retry pass in evict_folios(), so it is left
> unchanged.  The same do_rotate scheme could later replace that retry pass
> to unify both LRUs, which is left for a follow-up.
>
> [1] https://lore.kernel.org/linux-kernel/20241010081802.290893-1-chenrido=
ng@huaweicloud.com/
> [2] https://lore.kernel.org/lkml/46037a37-4cf6-448e-a94b-30a4d16e8814@lin=
ux.dev/
> [3] https://lore.kernel.org/lkml/CAGsJ_4zwP3_+EYY5Ug9EJ+yD1UdxsBSGr25u8s1=
K3u_i7LH3Zg@mail.gmail.com/
> [4] https://lore.kernel.org/linux-mm/20260911121341.178028-1-alex@ghiti.f=
r/
>
> Suggested-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index e200ce3eb056..026b844c681f 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1971,7 +1971,7 @@ static bool too_many_isolated(struct pglist_data *p=
gdat, int file,
>   *
>   * Note: The caller must not hold any lruvec lock.
>   */
> -static unsigned int move_folios_to_lru(struct list_head *list)
> +static unsigned int move_folios_to_lru(struct list_head *list, bool do_r=
otate)
>  {
>         int nr_pages, nr_moved =3D 0;
>         struct lruvec *lruvec =3D NULL;
> @@ -2018,7 +2018,16 @@ static unsigned int move_folios_to_lru(struct list=
_head *list)
>                         continue;
>                 }
>
> -               lruvec_add_folio(lruvec, folio);
> +               /*
> +                * Put folios that may have missed folio_rotate_reclaimab=
le()
> +                * at the tail to avoid cold/hot inversion.
> +                */
> +               if (do_rotate && !folio_test_active(folio) && !folio_mapp=
ed(folio) &&
> +                   !folio_test_dirty(folio) && !folio_test_writeback(fol=
io))
> +                       lruvec_add_folio_tail(lruvec, folio);

sashiko says:

"Could this heuristic indiscriminately place un-reclaimable clean folios at
the LRU tail, ensuring they are immediately re-scanned in an infinite loop?
If shrink_inactive_list() isolates a clean, unmapped file folio with an
elevated refcount (such as from a concurrent GUP or speculative lookup),
it will fail __remove_mapping() and be placed on ret_folios.
Because this pinned folio matches the !active, !mapped, !dirty, and
!writeback checks, it is placed at the tail of the inactive LRU. The very
next isolate_lru_folios() pull from the tail will immediately isolate this
exact same folio again, creating an infinite loop that prevents any other
folios from being reclaimed and causes kswapd to spin at 100% CPU."

This seems to be a valid concern. For a clean and unmapped folio, we
may still fail in `__remove_mapping()` if it is pinned somewhere. So
perhaps we can add a refcount check when fixing the rotation.

Best Regards
Barry

