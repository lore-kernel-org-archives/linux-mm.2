Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 832D9C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:11:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A92C6B00BA; Tue,  1 Sep 2026 03:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859D06B00BB; Tue,  1 Sep 2026 03:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76F836B00BC; Tue,  1 Sep 2026 03:11:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 574616B00BA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:11:53 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DFAE41A0366
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:11:52 +0000 (UTC)
X-FDA: 85164323664.06.9CF5A42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0073B80004
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:11:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0Uv1bVT;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788246711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYd+AmENN7bAFVPF+YgWJegBKmXG80GfPgevNF8Tk5I=;
	b=6pYkAAeI5tIs41/xj22p2KQIAEDfRH4T2iYqO1/mCsRMUyejLnxw2tkvEn+p46eVNK3T0b
	uMJp5znhxiTtQXv1k8iTLVWY3vXAs6FKy4zXioXlJ9QD2wBnDhl/Fjmlx48IsYXdSKCvER
	+ItGPG6DqyuM5lUDS4LiZNMIncIYrKA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788246711;
	b=rN/U6L/Z36+xoxoNC/g08HOqYc1PNi83di2Z9gxrBkWo6lKFcB0hQpu5nb5B4yR7HX4dE3
	qtRK3h7Sz5CKC6dpV/i9NOgoZF2Q1xSPxOaGEgYjYVZbvOLG3H2EkrLvkv7vJqSwbHg+KA
	XlMYd7Sa/lTeoEt3WvpKQdRSI5TDltI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Z0Uv1bVT;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2553E40F00
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:11:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CF61F00ACA
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788246710;
	bh=pYd+AmENN7bAFVPF+YgWJegBKmXG80GfPgevNF8Tk5I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Z0Uv1bVTmwNSe2MG4zBZ/kangfL5DrGJqCNG/6ct5GnHKZHWUSwEMwwNj4pTpVOlY
	 vzTpNrYGcucfa8jnKRTpQ+ZnYpxlyClnyOuP5+tAtU6+JvqWHuUgegvjlLhKwEarfi
	 ppWog9b+ApOwXPSWjKv53yC2veI+vngUvIa/sjCMCCiynJ43HIZE2FEM+kLCuPOWkV
	 OSxcyUViy/ADlXnYS0iOSci9XZunbLiVHTCTAo/nAYQ10BFsGF1lM6xQW2kgEIANtl
	 +BfWFb9w7eaeov88N1e0ydbBrjDZCN/Y4HVyOm0vOZ4+8ZALCJM27a77uwS8iGBZ0Z
	 Fa/D8xo+lXk6Q==
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93906e8a5feso450984285a.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 00:11:49 -0700 (PDT)
X-Gm-Message-State: AFuF++n6nUPqkML60i5829kKDgvOTA2HZhPNZTXMo5HxZX7LAJ9MDthH
	S99ZkwDKPkBnC9gF6imgvLUBFxfrwirxFV+If7DiTUK783yk4TzlvnhocUsiP4DanmkBsjG+bWd
	5awg1fwK+03szBidRWVJGWj0dCRz0GJI=
X-Received: by 2002:a05:620a:3c09:b0:939:409:708a with SMTP id
 af79cd13be357-939137d1dc3mr2947753785a.13.1788246709416; Tue, 01 Sep 2026
 00:11:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn> <20260901063755.1519710-2-hebaoquan@kylinos.cn>
In-Reply-To: <20260901063755.1519710-2-hebaoquan@kylinos.cn>
From: Barry Song <baohua@kernel.org>
Date: Tue, 1 Sep 2026 15:11:38 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x=sZcc0+wkAbS02YJUdpzxTTpozh7o7CSozWL=1K0rNw@mail.gmail.com>
X-Gm-Features: AcwNN1UnSP_OGFmVLmU7cRt9Fi7orb_pKKOsQ_ctPA0p92Y5WcWevpVu-uiCQvw
Message-ID: <CAGsJ_4x=sZcc0+wkAbS02YJUdpzxTTpozh7o7CSozWL=1K0rNw@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/mglru: add MM_WALK_EMPTY stats and tracepoint
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0073B80004
X-Stat-Signature: os7pkjqzfdt5wz654g6jk858a8x5qotz
X-HE-Tag: 1788246710-56824
X-HE-Meta: U2FsdGVkX1+bTTwi2xZHSE3tn1e+vfVj4Q60ZRkn0sNWTU9i6xSZ5o2N3bNU0KFgHv+4RNPla46Y89+PqCssU4/f1kTmV7NzHiimJ93l8i6mRZC/clb6vhLy5GaQgyBFgIOv7oVlHPTTqQB59tJ0jaM0YFlswT2EIKe0gyikcCfn9S5NVHjVdcqKUC5fmfegLbT12r7m+kZLm69d22zwveIZvcEnbPs5FtPE2DAVRS8btxfJRw3RX2QYnqcrFgiUFdvR3E9fgELytrzu6eIqiKWyEvlMMmPFfHagDOSfGnFmFL7S8jJAbbBlozOYG9lgrwkak3P+5pdRIqHX2/NMhPEmogjRiWspl/bJKdWLOoAZttxYSo5Mw8AO2Xckgzf2UObl9AcoVkbthHxs92DeNkeKkuuiYPp6FIndHBjF0UyFrhidl3a+TjUDW+Whs0edaxMDK3xezs3Tzegu1BaimX2KpnTFKXKkvUZCOV6VfTlf9CT22aunlC8Iad5UJSBf+E/acT/g1rLiUp8R/6FMUUL/oNjdVjrNzyA77K2QwCkonmb/D05HUF49euVLkp/N5LElWo88vL3n1MjAdsmMB6UKKevroOLprwjEU8c9HssAafLKC3QXC+ODZja6nQgX03i4usp9ywnzBhN+eUtfb75Or726vbywA0Njc0DSVL8U3HI/ulRP89ve+oKY4Std4zUKbkVmATkYaXb9te4gfyjbNxpPu4I6RbSWhFlVq/pCuq3JJKJ191YiDNb6GJv+jodWfV86YmctAjFvXlmJ8d8oXYg+ksIQIRYLtD0MmikClMzNY9eZ8NKmieriSsOyjqP3t4tRT7F2MKlNF7ru1me1FyySrXmF5go13kQBeQ1yWbBo0u0Fhq8CXGsSydWm26906Zj/bzIYJHTNWLiOROEWzLJxMBBp8JYOdGworObG4bWBrysGQ6mEhAQ8Gf0fn+hDQ9WBf23xiVRg8H0
 MBDz2aWW
 8KFzSYgJvVWiKvn3P0bly1aZfe4+9Jt5rAB2BmpJZEoK6XPvobg4AT2OGzBVb2nIIKAX5hE9qLvokWy1h4eS5bABVdlTHqzO3DUBpHAb3cFzRrIdLGdG1ZRsgSWs+OQZfW2EZdPWDr3OZZRmL6DijL3vqDdbAI4UEP9GPGBKUzGHPRXqoZGcbZUV8YrWks0XllwFyN4CbB4bt78NLjvJSnnoK8ZJM8ejEgldtp+AIP8Sg0I9H9y8iKRzAJUilYLYlOGQHkZAE3nkJBvC+xTXhL1fWTecr//CvjD+G+9129FpgcsGXhhxjrSAb2z3pMM3bpQMQY9Uv9pLInnQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 2:38=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn> wr=
ote:
>
> Add per-walk counters to measure empty aging walks which traverse
> an mm's page tables but find no folio for the current lruvec (node+memcg)=
.
> These are common on multi-NUMA node systems because lru_gen_use_mm() mark=
s
> an mm for all nodes at every context switch.
>
> New counters (accumulated in mm_state->stats[]):
>
>   MM_LEAF_ASSOCIATED   - leaf entries whose folio is in this lruvec
>   MM_WALK_TOTAL        - page-table walks completed
>   MM_WALK_EMPTY        - walks that found no folio in this lruvec
>   MM_LEAF_EMPTY_WALKS  - leaf entries scanned during empty walks
>
> A new tracepoint, mm_vmscan_lru_gen_walk(), fires after each walk, and th=
e
> debugfs lru_gen output ("TYFALWEE") exposes the new counters.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
[...]
>
> @@ -4109,8 +4113,28 @@ static bool try_to_inc_max_seq(struct lruvec *lruv=
ec, unsigned long seq,
>
>         do {
>                 success =3D iterate_mm_list(walk, &mm);
> -               if (mm)
> +               if (mm) {
> +                       bool empty =3D false;
> +
>                         walk_mm(mm, walk);
> +                       /*
> +                        * A walk that traversed page tables but found no=
 folio
> +                        * belonging to this lruvec (node+memcg) is pure =
waste.
> +                        */
> +                       if (walk->mm_stats[MM_LEAF_TOTAL]) {
> +                               walk->mm_stats[MM_WALK_TOTAL]++;
> +                               if (walk->mm_stats[MM_LEAF_ASSOCIATED] =
=3D=3D 0) {
> +                                       walk->mm_stats[MM_WALK_EMPTY]++;
> +                                       walk->mm_stats[MM_LEAF_EMPTY_WALK=
S] +=3D
> +                                               walk->mm_stats[MM_LEAF_TO=
TAL];
> +                                       empty =3D true;
> +                               }
> +                       }

Hi Baoquan,

Where are we clearing these counters between different
mms?

It seems the previous mm_stats will affect the next mm
if they aren't cleared.


> +                       trace_mm_vmscan_lru_gen_walk(
> +                                       lruvec_pgdat(lruvec)->node_id, wa=
lk->seq,
> +                                       walk->mm_stats[MM_LEAF_TOTAL],
> +                                       walk->mm_stats[MM_LEAF_ASSOCIATED=
], empty);
> +               }
>         } while (mm);
>  done:

Best Regards
Barry

