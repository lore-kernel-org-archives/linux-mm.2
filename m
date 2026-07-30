Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8311C54FD2
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 09:07:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4DFD6B009D; Thu, 30 Jul 2026 05:06:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25BA6B009E; Thu, 30 Jul 2026 05:06:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0456B009F; Thu, 30 Jul 2026 05:06:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFA26B009D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 05:06:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA4C9808EE
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:57 +0000 (UTC)
X-FDA: 85044863274.16.F84A694
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 0828240004
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GLjP2cjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785402416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gZ3c+8CwwUe2+0lzilzz3UoIxzFxRhD7Qz/ubZN5PMs=;
	b=5WRv7qHJFjvB6DSaozP9Fp5xMGlJykW4YWl5XnFfL7cbWR4/Ua1/3i35mS3zUviFx6CRA2
	ToAh+5FF0mN3i3VosPJN/QYU2a8zOT14Emw6RPNp7bqlDpQ4OeZ6kU8Ge/9QrwhqWR4kkc
	4rzL8us0YchPJMkiRk/NXDpp7hJhWkA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GLjP2cjA;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785402416;
	b=4uMunBZSbSCsKQwNiFHIaCCJY9Y01Wl4Oxt0TgkFlhj/9Qk833TaABn/V505ouW2StZan2
	i8Sh9Illq03SPNNGOjEcjzYcq/enW9NGCSMy7a2Mp1hMCs1s4RQBjzqtieZ5FyeOmy6Wig
	PrUL04uAhoM69tZ2x63O9l8bC2HpVSg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C33043F74
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242CC1F0155A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 09:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785402415;
	bh=gZ3c+8CwwUe2+0lzilzz3UoIxzFxRhD7Qz/ubZN5PMs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GLjP2cjAsZqdZv5QzIkrlytzISOxmCid9sQybYEv67fOnyE+xreGwdOIl3MOWOos0
	 XqXh3QDgsj/fTFJXHQsRdT4buGG/2RWyKG8Pxj7L8SW/j+H5mjjruNYBzzhuhUxT2J
	 JhTZxpkEwceuR5Dra3TXnw1ILKxgUMrjGcSeFVVCoKqYsQt+hnETacdG3gMFedCtQh
	 1wYOJ34NqUbZ2z5yQEpY3uVV96WUyhOzutR5bTcfv2J6Gijigy1mfiCcdxJ8cQg8MH
	 iXeTjTOXkeSnK9Je9PxuVmCBzRBmAHVLMDK1d7f7Q2yf7GhuNbB3SYZ+GWYc48Nlh9
	 kGJ8dXL70MvHA==
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-8eeadbc5e21so12558686d6.3
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:06:55 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rp1ZoY7tZ7lPX0lk1I/v/TE12cdkS8yLUZTyS2QSDbDdW6CkBXxARUVO9o3Drdk9UjNiLmYIE3YdQ==@kvack.org
X-Gm-Message-State: AOJu0YwU9NP1rDfYDd6w5WUSFPtBIdEdgqA0F4Gq/75obj8NGrIBKac8
	Q/IlhEDchuLoNyD1Epw5iGZAYlF1/RmJ+01rSC9SQAFWiDEbgT9I1RVaDzgqSMzvFgDrntdp74+
	cgg3n5TwYAAHGedp8OEWWfBoYcZ7ag+M=
X-Received: by 2002:a05:6214:4a88:b0:8e9:f62b:8fa0 with SMTP id
 6a1803df08f44-908347de65cmr15709296d6.53.1785402414395; Thu, 30 Jul 2026
 02:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
In-Reply-To: <20260730072349.1360449-1-zhaoyang.huang@unisoc.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 30 Jul 2026 17:06:42 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
X-Gm-Features: AUfX_mzT5lKF4XLU96cwSBZRTI0Rv50EO-e3K_NeFWAEZDexxMV83B-tarYorng
Message-ID: <CAGsJ_4xW8WujWvgFrrR2NHoQZd4nLPi8QBtXwGsrQXj72CL=NA@mail.gmail.com>
Subject: Re: [PATCH] mm/mglru: force aging the lruvec when min_seq pinned
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Zhaoyang Huang <huangzhaoyang@gmail.com>, 
	steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 0828240004
X-Rspam-User: 
X-Stat-Signature: jseihmkez3kkwdkqebhkb57m1de5hre9
X-HE-Tag: 1785402415-733954
X-HE-Meta: U2FsdGVkX18NJS6q9aUC2Uy6/9ZqizO4Nj4cpKTzexXGIfoP24+DkvxSF2pp8jz/v0HcIBPDAC7B+ZMhx2g34d/QplGWy27vdfc8knWiN5IaPzmYKCRIxaNjL2hgteOsyu9x5PgTttpNZ0gNH1TZw93y9acdeVSPLUohCl0rVJznxtqD4gVXGBVK0DdjSRqancBsu5bLG5Z/B7r4dgZ2PkJ7MOGWxPJYJj6+SRC3ViabSpckVV7Y598p5vNkSBJS+p2vTfnyXaG2DSpxXzoyO1l+sp/D9udzf53oJD9PFkOWh/rAnutELGNbecX/BnpIXBABchlExFzjx3OUUVqXAVf6RPh6/hjQM8mvrRubyaY+3F73CbJmwU3WXy7L3ocdZA08FKx/z+LjKmt3ZQYUHGyeXQQuZfmqAZeG7F/vgOpT3uAEYWnAlneQDT4+9qtO3NwL8e+uF0UTE044gGbLqHkFOPs2ZOZwvalrQL3z/MJ4ePK759sGQwNR1CcLOja6/O5L7ydOYLWCX3GfDhPWxXsMJD7dUjWuEb71IL5m79wk1+UhyR/9wlkjVwo/af6k8ujKdC+bwuw/z5Uwc/Fb17ybq/wHnVAdTawgkIYfr3QV5jPwM0S5yNEUXpqLey2Nymw1owkJCD62rwnKaKaIb8pkrzkQnvZFkTx78WhAFOGe2ATM24c8IHu06lExnJW4zPLDVxNhvySiLobPsrFhpxlgpsFnkif7iMIg3FMJO5pAvNY9+QeTbYA3bBd4ud1W4HcpjcD9GAMK4EgM3UDvxY56in1/IjpQgeYpq6Ejbu7js1LU8SQuKz6SJb2tUveJAbIWRitVdGW4Nov01dEG7iRBmHYLEljc24Y1GAssS+3V47i6F+HyiVgJLI9BFum7nJJVGtpen4HZ2ABIwUcV2AnYz/UMGdyn4GTuw1yF0b8Z7n2o+xPXff0msrHHODyUM84PVpgw/tDTMTiJDUQ
 yuFbaeW6
 q8wdPGzS/gXbZY5nYTVO03mvt7XgphiTs/QV+njVEkz5k80C9RuuWK6G5vnQs44iQizpE8pWPNS2YXq9cN6x1NtMfFP3ZlBWWZg7gPX1y3+P154qGpgnYMoZFVS3ZegTmJ9xlsWNbQp8bIVTrCf10U06eRnE1KYy5bhEPmUUdm5EtEWHRlY8Cdrzckig9+iUbyF+Na/tBThCeEMq2iz38cU91Jgc8PR/5rxS8aeceKw61x54dRvh50wi36/x4y4XuDqTPmBoeceAse1xO3MsdC41/rienMdlDMD6vLVTFgWH7iP2cT4b48taGrsRr18ZkiTJ6kch+vwX4Mpybyf3F78g0jpbIs0hKfCnUCsMSLHbnu1FhCPzcSHdav++OvEWIe2hLyff5iPWvm549s37fZVjOn4cb3TxM2a3RJYbnhD4NjLk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 30, 2026 at 3:24=E2=80=AFPM zhaoyang.huang
<zhaoyang.huang@unisoc.com> wrote:
>
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
>
> This submission addresses an issue where the memcg MGLRU's min_seq is
> pinned by an orphan page=E2=80=94a page that resides in the page cache bu=
t
> lacks a corresponding reference count, while the number of GENs has not
> yet met the criteria of aging. I believe such pages should be detected
> and handled elsewhere rather than affecting the LRU in this way(legacy
> LRU could move forward by bringing this kind of folio along with).
> Therefore, I propose moving these folios to the next generation when
> isolation makes no progress at all.
>
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  include/linux/mmzone.h |  6 ++++++
>  mm/vmscan.c            | 45 +++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 50 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 9adb2ad21da5..b063c56ea30c 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -434,6 +434,12 @@ enum lruvec_flags {
>          */
>         LRUVEC_CGROUP_CONGESTED,
>         LRUVEC_NODE_CONGESTED,
> +       /*
> +        * MGLRU: eviction failed to isolate from the oldest generation o=
nce
> +        * while the window was at MAX_NR_GENS. A second consecutive fail=
ure
> +        * forces aging so residual folios cannot pin min_seq indefinitel=
y.
> +        */
> +       LRUVEC_MGLRU_ISOLATE_FAILED,
>  };
>
>  #endif /* !__GENERATING_BOUNDS_H */
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index bd1b1aa12581..c18db08c5e10 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -175,6 +175,8 @@ struct scan_control {
>                 unsigned int immediate;
>                 unsigned int file_taken;
>                 unsigned int taken;
> +               /* folios isolated by MGLRU eviction in the current lruve=
c pass */
> +               unsigned int isolated;
>         } nr;
>
>         /* for recording the reclaimed slab by now */
> @@ -4748,6 +4750,7 @@ static int scan_folios(unsigned long nr_to_scan, st=
ruct lruvec *lruvec,
>         trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batc=
h,
>                                 scanned, skipped, isolated,
>                                 type ? LRU_INACTIVE_FILE : LRU_INACTIVE_A=
NON);
> +       sc->nr.isolated +=3D isolated;
>         if (type =3D=3D LRU_GEN_FILE)
>                 sc->nr.file_taken +=3D isolated;
>         /*
> @@ -4998,6 +5001,11 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>         long nr_to_scan;
>         unsigned long scanned =3D 0;
>         int swappiness =3D get_swappiness(lruvec, sc);
> +       bool attempted =3D false;
> +       bool rotated =3D false;
> +
> +       /* per-lruvec pass; sc is shared across lruvecs during reclaim */
> +       sc->nr.isolated =3D 0;
>
>         while (true) {
>                 int delta;
> @@ -5006,6 +5014,7 @@ static bool try_to_shrink_lruvec(struct lruvec *lru=
vec, struct scan_control *sc)
>                 if (nr_to_scan <=3D 0)
>                         break;
>
> +               attempted =3D true;
>                 delta =3D evict_folios(nr_to_scan, lruvec, sc, swappiness=
);
>                 if (!delta)
>                         break;
> @@ -5020,6 +5029,40 @@ static bool try_to_shrink_lruvec(struct lruvec *lr=
uvec, struct scan_control *sc)
>                 cond_resched();
>         }
>
> +       /*
> +        * Eviction isolated nothing while the sliding window is already =
at
> +        * MAX_NR_GENS. In that state should_run_aging() is false, so
> +        * get_nr_to_scan() never calls try_to_inc_max_seq(). Residual fo=
lios
> +        * that fail isolate_folio() can pin min_seq and hide reclaimable
> +        * folios in younger generations.
> +        *
> +        * Require two consecutive isolate failures on this lruvec before
> +        * forcing aging, so a single no-progress batch does not rotate t=
he
> +        * window. Successful isolation clears the sticky bit.
> +        *
> +        * Key off sc->nr.isolated, not nr_reclaimed: folios isolated but
> +        * rejected by shrink_folio_list() are put back with PG_active an=
d do
> +        * not pin the oldest generation.
> +        */
> +       if (attempted && !sc->nr.isolated) {
> +               DEFINE_MAX_SEQ(lruvec);
> +               DEFINE_MIN_SEQ(lruvec);
> +
> +               if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =
< max_seq) {
> +                       if (test_and_set_bit(LRUVEC_MGLRU_ISOLATE_FAILED,
> +                                            &lruvec->flags)) {
> +                               rotated =3D try_to_inc_max_seq(lruvec, ma=
x_seq,
> +                                                            swappiness, =
false);
> +                               clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED,
> +                                         &lruvec->flags);
> +                       }
> +               } else {
> +                       clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED, &lruvec->f=
lags);
> +               }
> +       } else if (sc->nr.isolated) {
> +               clear_bit(LRUVEC_MGLRU_ISOLATE_FAILED, &lruvec->flags);
> +       }

This is very weird. This seems like using a sledgehammer to kill a fly :-)

Do you mean that isolate_folio() fails, the folio is put back
into the oldest generation, and the next time it is scanned, it
still fails to be isolated? As a result, scan_folios() makes
no progress at all?
And is it because the oldest generation contains only this
folio, leaving no other folios for scan_folios() to scan?

Why can't you simply promote the folio?
Do you know why isolate_folio() keeps failing? I suspect it's
because folio_try_get(folio) fails repeatedly?

static bool isolate_folio(struct lruvec *lruvec, struct folio *folio,
struct scan_control *sc)
{
        bool success;

        /* raced with release_pages() */
        if (!folio_try_get(folio))
                return false;

        /* raced with another isolation */
        if (!folio_test_clear_lru(folio)) {
                folio_put(folio);
                return false;
        }

        ...
        return true;
}

Best Regards
Barry

