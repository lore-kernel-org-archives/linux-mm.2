Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3134FC61DD3
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 10:35:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F676B008C; Thu,  3 Sep 2026 06:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F31F26B0096; Thu,  3 Sep 2026 06:35:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E46E36B00A6; Thu,  3 Sep 2026 06:35:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BB36F6B008C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 06:35:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3DB531A048D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:35:39 +0000 (UTC)
X-FDA: 85172094798.04.752DE0F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4C4A040004
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:35:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KcIHOY71;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788431737;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DmMIO1ElFEdHdnzG6JsJd7rREUzvxjOyIHl3mgXY84=;
	b=YGyYgwTtHkb4zO1ZGy3hVRb/8CLytcupZUEt4Juw+HnyRojnc+u+BkN4Q4QaZuHgJ1q4fT
	ZdP35823MtUdFJEhpRlXY/6JWI68aE0zBwoJo1Q1DpoyllaoFxnd7jfHaxyFDke1kP2dR0
	qnm/XQwBsumsmzP0QGXRgyMc4GuCS6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788431737;
	b=Hjt6nRt4uHfBuMWmCVDPcykfo8BVDTV06TB8SDbjG/b1F9Qh2z1rEvYiOoHAiAUrSKR11Q
	Y6L+WoKpPfkUm060b0gv25tqol1Xh5G0umR5RyUy/HuGcuyK8CsCrpiggZxIu1ALjrGVAF
	VZc8qzTKBfZzriD58jbfMy/YjvBNWRM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KcIHOY71;
	spf=pass (imf07.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6DB6543E08
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C7E1F01559
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788431736;
	bh=2DmMIO1ElFEdHdnzG6JsJd7rREUzvxjOyIHl3mgXY84=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KcIHOY71Lxm7IiSLojJ3tzy5vSnMyc/vEN7u45R8OQ6GgGW6KGz8tY0EbyuTf0vep
	 U4mNC5XFHcNyIoAX7RJpC/SBujvNO7tSlvt1wiGJYr0sG7303SuSXRQrUE4WpZbTcx
	 fbrKrtgw4+QcI669G1dmAT06QY/kV/VDUaZV205d/TAAqy+lGoZiH5HgGaZ9YPfxR4
	 En5GD8AVnHxo5g6Ofzp1fNTdzcNIKSmteAlelZ/Qff5JdaxridZq9wD90el8z2+FTo
	 jJTmCFYklnC7TIissR0+niRjAaasRqMxnKZD7CcVHTpmrVsag3QHvGUkYVNyWB0B6H
	 WkGrutyiCKFTw==
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-90cdffe8e3eso21877546d6.2
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 03:35:36 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwrvku0ZsLI9KDlwSS2Xvr3GbancGcEIYqxN3ea9MamtTz+88L7EVd6nDwhOXavFUuhWoAJsJwYPQ==@kvack.org
X-Gm-Message-State: AFuF++m3DJJlb1x6W0vH7yk10ZKvADDtLmOQge+3Y5U+mDUg9qXsJk3e
	KOg3djwlWL94iLzo2xAvwfw4V8MCrMLdUu6begDMD9A8pV3WI9Eepr1hGPQGYeJjzK65M/84WrY
	VO/QrfahpteqcP2fwE4ssxspc3v5/0Mk=
X-Received: by 2002:a05:622a:1452:b0:51c:1132:c80d with SMTP id
 d75a77b69052e-53036d20556mr117183501cf.28.1788431735642; Thu, 03 Sep 2026
 03:35:35 -0700 (PDT)
MIME-Version: 1.0
References: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
In-Reply-To: <20260903040131.4016290-1-zhangbo56@xiaomi.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 3 Sep 2026 18:35:24 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z+SgetmjVD8bcOFisKNd9CFqe6kNcYcFtVd-PijYJ04Q@mail.gmail.com>
X-Gm-Features: AcwNN1Ux8M4d6A_TmjKucxqe-u61smpIYGpG5JYtI1eeT8wYBXmf61kss7VaqpQ
Message-ID: <CAGsJ_4z+SgetmjVD8bcOFisKNd9CFqe6kNcYcFtVd-PijYJ04Q@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: vmscan: avoid anon scanning for GFP_NOIO with low swapcache
To: Bo Zhang <zhangbo0325@gmail.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, david@kernel.org, 
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bo Zhang <zhangbo56@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8j4a93c3wf6zqyzdmzcp1hn197zkzktr
X-Rspamd-Queue-Id: 4C4A040004
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788431737-318639
X-HE-Meta: U2FsdGVkX19GzmEcf5qUJvPyV8UObVXYvI0gUGYdQR+Xte94s3RVrBWLtrSjjmU2LzyDrz//CvryoDWnI0eFOEB5w90SjrqNQjwnw+xmLVio2z6F0t2mP2bZ0SGYhb8q9NUMwI3AMmptfKfDJL/LQbs9AQvUthyxvlc5NhksrlI7LlInCyrm1G/HVi+TqHukLsYzqVW1sI09lItlvJadQc8bnpFn7iSUjcvRV2gt5bdGimJ/4NiShQOTZAPTv6C+JXyOo6J+/wfHsTqaXH9DXeACC1lIZ2JoPwjMC4Y63q4XXkltZku0VhwveaCrhjRNUZNN7jygzYUx2xoni2hpgV6MgES+2AiCPt6hh+Vc1Sq+HXBM3dSCmppyUZwqLpxToCJTGkEJRYhuit70n3v/Uhy42sVSHrS3Jx3vaO1kNlLMOQqMFvTKCpKMddQY46J/PKQYZ4EkeFTgEZ5pASym9b0beaQdKzqzkkODoOXlaZpMKgMoeNWe5uX4Zr7QHo8gO+NZxlDgdYVV65+yGenCBumO7VdlvfKMepyGIDxkAvZQhn6uGpHo18eNbTWOklZSSPoNdT5tj3zh8HrRL0JsFujhfRSbmNDWQHRxzf+0A9sYoOjD4zrtEMhprrH/M2DUieIwgwbKdmzb5FAFlpC4Px/xqjCmhr4FxGBBvVdoqi7DUvCDKHZoZtsEu1rtGwRCpo08aUxGKi1Iu7FcA13I0qIcuv/qT9vOAapbiRfH/lecpA00nniD7WyArgJI8x4ZYuQ25P4pqzlRScMtrQ83F17KEEWu4ctLoKPXMWxXhGrcXU1RHwhdr21B2ynXHO0KCD7YHc0OTJzr9clLtD0LPbTnrBbKGaShjm9tgl6e0u/0tReDScTlrJbVwv3hFQ0gNr9b+ixc9pGefd9hZGRSDQUq3DriTJ406Z3+x9t15ouorvjtoHyuH44DG2ARvUqUw/A7jtjmxay4tyx1LbI
 VSD6sH7N
 sk0iSaOt/M9sl455BsIYECsKt/cUl7qk4+SeRXkynCqoHwVAd4raSZFcwC6rtWAcKwKrAAI3cQZfarxTBEed/sF0KhefB9jZ0/zObGyy6F6tCtmqeeow/6X0Ckw9LpLLK12OGnEvLY5KwIKMoZGdOUp/PpXtXu+mhiEPw2beqx49FoazAHe5D52Td3902DT4+YEPAi17AiYioycp1e+xH9ojoyzfy4+R8vYm7YUPAHNJnxdwoOuibM1o7qf8R89I80BEPPlwfIt3NZ+BfnlXgvjEbtrAKrhWYSG+UtztHPE05XmFmz7GHzfA4Iv92r1v7BFGsHl9ow1/vNo53ApgUoQ07ppv+9GlPsI6u6nijj0I7sgU918q0UYiyjx2D1VA79C92GmbG11h3+wbLdBpEJFPHy3LqU4ecW7SDlyNoP5zRBI3LDr1vYtM8Zg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 12:02=E2=80=AFPM Bo Zhang <zhangbo0325@gmail.com> wr=
ote:
>
> We have observed some cases where memory is allocated with GFP_NOIO, so
> we cannot reclaim any anon folios unless they are in swapcache. We can
> end up spending more than 150 ms looping in `shrink_folio_list()` scannin=
g
> non-swapcache folios without reclaiming a single folio. This is pure
> overhead.
>

Yes. The coexistence of `GFP_NOIO` and anon rmap scanning seems
nasty. We might also want to do something like the following, but
the side effect is that it might keep a folio while preserving its
PTE young state, indirectly making the folio semantically hotter.
So this may not be a good option. Skipping anon scanning in the first
place seems more sensible.

diff --git a/mm/vmscan.c b/mm/vmscan.c
index ba7adf36e69f..f15aa3573030 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1248,6 +1248,19 @@ static unsigned int shrink_folio_list(struct
list_head *folio_list,
                        }
                }

+               /*
+                * Don't waste time doing rmap and scanning PTE access for
+                * non-reclaimable folios.
+                */
+               if (!do_demote_pass && folio_test_anon(folio) &&
+                   folio_test_swapbacked(folio) &&
+                   !folio_test_swapcache(folio)) {
+                       if (!(sc->gfp_mask & __GFP_IO))
+                               goto keep_locked;
+                       if (folio_maybe_dma_pinned(folio))
+                               goto keep_locked;
+               }
+
                if (!ignore_references)
                        references =3D folio_check_references(folio, sc);

@@ -1281,10 +1294,6 @@ static unsigned int shrink_folio_list(struct
list_head *folio_list,
                                !folio_test_swapcache(folio)) {
                        int ret;

-                       if (!(sc->gfp_mask & __GFP_IO))
-                               goto keep_locked;
-                       if (folio_maybe_dma_pinned(folio))
-                               goto keep_locked;
                        if (folio_test_large(folio)) {
                                /* cannot split folio, skip it */
                                if (folio_expected_ref_count(folio) !=3D

> This is particularly true on systems using zRAM, where swapcache is
> relatively rare. So let's check whether anon reclaim is allowed by
> GFP_IO and whether there is enough swapcache to make it worthwhile. If
> the swapcache is extremely low, we're essentially searching for a
> needle in a haystack, so let's avoid scanning anon in the first place.
>
> Signed-off-by: Bo Zhang <zhangbo56@xiaomi.com>
> ---
>  mm/vmscan.c | 62 ++++++++++++++++++++++++++++++++++-------------------
>  1 file changed, 40 insertions(+), 22 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 56708d1d2dfd..192bd0980121 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -339,6 +339,42 @@ static bool can_demote(int nid, struct scan_control =
*sc,
>         return !nodes_empty(allowed_mask);
>  }
>
> +static struct lruvec *get_lruvec(struct mem_cgroup *memcg, int nid)
> +{
> +       struct pglist_data *pgdat =3D NODE_DATA(nid);
> +
> +#ifdef CONFIG_MEMCG
> +       if (memcg) {
> +               struct lruvec *lruvec =3D &memcg->nodeinfo[nid]->lruvec;
> +
> +               /* see the comment in mem_cgroup_lruvec() */
> +               if (!lruvec->pgdat)
> +                       lruvec->pgdat =3D pgdat;
> +
> +               return lruvec;
> +       }
> +#endif
> +       VM_WARN_ON_ONCE(!mem_cgroup_disabled());
> +
> +       return &pgdat->__lruvec;
> +}
> +
> +static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
> +               int nid, struct scan_control *sc)
> +{
> +       struct lruvec *lruvec =3D get_lruvec(memcg, nid);

https://sashiko.dev/#/patchset/20260903040131.4016290-1-zhangbo56%40xiaomi.=
com
sashiko says:

"Will this cause a kernel panic during global reclaim when memory cgroups a=
re
enabled?
When can_reclaim_anon_pages() is called for global reclaim, memcg is NULL.
Since get_lruvec() is called unconditionally with this NULL memcg, it will
trigger the VM_WARN_ON_ONCE(!mem_cgroup_disabled()) and return the raw
node lruvec (&pgdat->__lruvec).
When lruvec_page_state() is then called with this non-memcg lruvec:
mm/memcontrol.c:lruvec_page_state() {
    ...
    pn =3D container_of(lruvec, struct mem_cgroup_per_node, lruvec);
    x =3D READ_ONCE(pn->lruvec_stats->state[i]);
    ...
}
Because the lruvec is actually embedded in pglist_data rather than
mem_cgroup_per_node, won't container_of() produce a wild pointer, leading
to a fatal out-of-bounds memory access when trying to read the stats?"

it seems we could just use mem_cgroup_lruvec() instead:

 static inline bool reclaimable_anon_is_low(struct mem_cgroup *memcg,
                int nid, struct scan_control *sc)
 {
-       struct lruvec *lruvec =3D get_lruvec(memcg, nid);
+       struct lruvec *lruvec =3D mem_cgroup_lruvec(memcg, NODE_DATA(nid));
        unsigned long anon_pages, swapcache;

        if (!sc || (sc->gfp_mask & __GFP_IO))

I applied your patch on my PC with the above change. I didn't see any
panic or run into any problems.

Best Regards
Barry

