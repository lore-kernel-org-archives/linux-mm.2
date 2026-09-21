Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9E8DC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 11:55:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAD366B00C7; Mon, 21 Sep 2026 07:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5D546B00D9; Mon, 21 Sep 2026 07:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FDE76B00DB; Mon, 21 Sep 2026 07:55:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71DDD6B00C7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 07:55:11 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0CC351C0860
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:55:11 +0000 (UTC)
X-FDA: 85237613622.04.1491AD4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 25B21C0003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:55:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7mYAwGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789991709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ts7BCcKLEMsHRs27nr3/Et+4cKXGbijtrtbrzWBUmOw=;
	b=b5b5m+QHI/G2QL/BtaT0iKBNHgr4Q5vD3MHdGNCIfBRvwysFe0LU5jh97NjM0vTo4pxIz3
	lTHE44RSrSfRHiA26eQzZmmnGHqvjSzR6Xv/1VuWk1E/ncGBgymwQhjiEQd+Ry79qr0eIW
	fU3vL3+qHRV4z8dhYJcDkpCFXWYFOaA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789991709;
	b=x2IHEUaKbPbCpMBohxIhKAu7+dWKkJOdKDu663RWk77HdtNRkRTC3FFGBQ7qzVCHo0c9Pc
	7hMe0TeiQ+s1neB87/W7v923K750YbSKVse61dUWNz0qFpMKdVbTny18RQzonkHyaSgQvs
	cO6RPSlxE+sb6pf194o8XHaoqWyt5jw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S7mYAwGm;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf22.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 19F7643DD0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1F051F008A2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 11:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789991708;
	bh=ts7BCcKLEMsHRs27nr3/Et+4cKXGbijtrtbrzWBUmOw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=S7mYAwGmGr8nnff24TrDEpql9kCy48pkgU9XF2EvIA1iqjuZ/hcpXDYXPsfBP9vHw
	 q+G/YFkI9MGdXR+pil7USaMTg0/o/5wWwS+oJwm/qElvQPLTMHIaSbqIRKT0msQkEB
	 Bdb/3O2qNYlyoTiLUkvB4lZQfaAtw4G/7rmIOb1w2VN9n++/1krwPBHlOp7379rBeS
	 mk0oWYMX3/c5DiscnwqJXTAs9TgHGBDcA/cVtYE3R7k97WTMU4k3m+hxRWuq4H1pSe
	 Aqol2Nh/yj0/oo/bhvKxS+zfzg5zaysM/YmRr0B/IrMK+CHgNnPom8I14Sd4ItDYLV
	 /WyUkWUSwxKbg==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-671563fb8beso2534316d50.3
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:55:07 -0700 (PDT)
X-Gm-Message-State: AFuF++kSZcrgP40Pk+kp3wJvX8ZOQFJdi18auuAKatCid2wKW6aD4CTt
	ad2LzFeLel3GEj6uOWgQ1HQmZhp+QPWfQ0+XZNRM+p9IidIOy5BX10o7S96NXe2X1X8YzlRofNX
	myjas3yHjyth3C8MgjIyy2cOpwFdj5L1lA1lK9m9dvg==
X-Received: by 2002:a05:690e:4810:b0:671:1ae4:995a with SMTP id
 956f58d0204a3-6717fc92f1cmr2146065d50.29.1789991707217; Mon, 21 Sep 2026
 04:55:07 -0700 (PDT)
MIME-Version: 1.0
References: <20260920072043.430390-1-hebaoquan@kylinos.cn> <20260920072043.430390-14-hebaoquan@kylinos.cn>
In-Reply-To: <20260920072043.430390-14-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 21 Sep 2026 01:54:56 -1000
X-Gmail-Original-Message-ID: <CACePvbUXQmJv9nu=utFQvr_G8z7EwWj=Yy-JCcT44LXoR=2uNA@mail.gmail.com>
X-Gm-Features: AcwNN1WSsW2-x5-Bri4gvnhbMmkhyshlx-6m6ivsxwWAlTxq0MEx6TmYaXd6gIk
Message-ID: <CACePvbUXQmJv9nu=utFQvr_G8z7EwWj=Yy-JCcT44LXoR=2uNA@mail.gmail.com>
Subject: Re: [RFC PATCH 13/17] mm, swap: do not charge zswap-backed xswap entries
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	hannes@cmpxchg.org, nphamcs@gmail.com, baohua@kernel.org, 
	youngjun.park@lge.com, david@kernel.org, kunwu.chan@gmail.com, 
	baoquan.he@linux.dev, gourry@gourry.net, riel@surriel.com, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 25B21C0003
X-Stat-Signature: e5mf9d5ufuriuax55zqjqyy5esyk6ypb
X-HE-Tag: 1789991709-75212
X-HE-Meta: U2FsdGVkX1/NI+C0I53vWA2ION+6kMRV+wGNKL1j1xFF/lX8yUwidXabxzWs0ZBD3ROqm7KSrkbWqzomRFZPhgF239PgGFhqTLTCEoeNl7iIJLbwLaQmqa4MhyBR298ksRx+dQyFVYlfKEGcHDyBCIr5P39G+2Sy3qt0iooxd4ph8W7JTpC8wgPPvz4xFFrUBwmkWhV4k1Aq4I4SCHrY2w0zMG1k0bpQqlj/ncbNOAN5q4EhRIEWwN6vMm6Xh8R9nm6doSUR2m1cwVhy/bsgnCjgUXVHCwptzYKWEu9HgER3AfeTNnRN52eo/x5uiMImKkI4Zr5JBRRSlabZGwdB4gsL3xSaHnv00Sf1mXIjlFzGp9zDYdZxuhJgVVkChpXsjoCdWup7BDZcSrihoqZ8MZOrQ5aIVY4o8RnHoteadF28EzoTyBExZ8NwPpJvS3LU1vFkG7St9sQVj588iGfRvg1aojuJxVS6Oa66/O8XRXa/ZWg9LPjWhAjrBjv0zDhLJPdqyek4IYatV8K1jiGYyXu3U9c0DIx5TocFnkQcGkqqaGAsSg6+NYa/vsTaZgN4x6GQml6rK5wSIJ62DSx1vi/Ex31JOHynw1Zho7ndzdfz9SW2UjYdhnScqCko/C0IeuynYezQGbeWBkjs3KrdCbOhXtNhQtVkKJ5wqXAre3Jl6LPoJ5ilET2JLBernPZoUukfBbHsx2AbPrtEQgmX5KVaZO/crED9j9I0HjK7/zxsUimyKZgOdM2hoHfzmZUWsdcdZ+frZiDDpjggaUfRkHeT5lcxlDCaaB8hydZsK+mR3RioYxmb1SeC63FneCtp+1BRxZ+LW9nrRbmL/B0/QUS9TfqGTROXIuEGam4tbtu49YcmhqvNS8gigU7O4yS10jY6TEyrETykMKBwdQOI1HYxXKjV2vnNJVoKbkcj2R5Zdq/Axo9SZfm8xIS7E6S3yhCarV/vvoAm9A2bHpo
 UmK8aJKx
 MIdq4itWlvTDWl4E5JGnvgNyUJpclCFi4s1lOLanJneCcgO4kHHmpUR28/+ZCSlgYEz2+x1CTDQq06LniQUW9xSkWfv/mb62QZPc1htuKV30Voh6O/4pjjFPWWZqcn47Uw8Hmcplpefh7ANgHCF7H/3WZX+Qp+2dLamlfyMyRdNleCsbIGan0wn6kPXyULDEG+5DDWPw7PFLemOaBpJhCVTIe5e0mh3xilVn2LSwK/Ch+i2uTWJUnYUS88LQI+50Br+KA+ljcqlutflsCGSsFgRS4Ry9r/6rUm7xHQk6HTilgGz8/VoNqGE5KQZ86nKuhVbCPu9I+IKZrmoKH/xVKHdJEYMOKE0oJe8BnHdDikpRuFxEcASM1ueHtX+lwWC1s10xTFdeY9JJCD3bXK/OwUPYgqPOShHkN454I1W8CK5Na4yK3Xsh9n8AVg9WVMuFgKrYf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 9:22=E2=80=AFPM Baoquan He <hebaoquan@kylinos.cn> w=
rote:
>
> From: Nhat Pham <nphamcs@gmail.com>
>
> An xswap entry occupies no physical swap space: its data lives in zswap
> until a backend is taken.  It was nevertheless charged against
> memcg->swap at allocation, as if it did.
>
> Record the memcg at allocation but do not charge.  The charge is taken
> when the entry acquires physical backing, and released with it.

See my other email thread discussion. This is a user-visible behavior
change that breaks existing deployment.

Please remove this patch from your series.

Chris

>
> memory.swap.current therefore counts only on-disk swap usage, not
> zswap-backed xswap entries.  A cgroup can reclaim its anon memory with
> memory.swap.max set to 0, provided zswap is allowed for it.
>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/swapfile.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 7dcb4b48645d..627f2cab8077 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -2002,7 +2002,12 @@ int folio_alloc_swap(struct folio *folio)
>          */
>         memcg =3D mem_cgroup_swap_get(folio);
>         if (memcg) {
> -               if (unlikely(mem_cgroup_swap_charge(memcg, size))) {
> +               /*
> +                * An xswap entry has no physical swap yet, so only recor=
d the
> +                * memcg here.  Its backing is charged when one is taken.
> +                */
> +               if (!(__swap_entry_to_info(folio->swap)->flags & SWP_XSWA=
P) &&
> +                   unlikely(mem_cgroup_swap_charge(memcg, size))) {
>                         mem_cgroup_swap_put(memcg, size);
>                         swap_cache_del_folio(folio);
>                         goto failed;
> @@ -2153,14 +2158,19 @@ struct swap_info_struct *get_swap_device(swp_entr=
y_t entry)
>         return ERR_PTR(-EIO);
>  }
>
> -static void memcg_swap_free(unsigned short id, unsigned int nr)
> +static void memcg_swap_free(unsigned short id, unsigned int nr, bool is_=
xswap)
>  {
>         struct mem_cgroup *memcg;
>
>         rcu_read_lock();
>         memcg =3D mem_cgroup_from_private_id(id);
>         if (memcg) {
> -               mem_cgroup_swap_uncharge(memcg, nr);
> +               /*
> +                * An xswap entry was not charged here; its backing, if a=
ny,
> +                * was uncharged when it was released.
> +                */
> +               if (!is_xswap)
> +                       mem_cgroup_swap_uncharge(memcg, nr);
>                 mem_cgroup_swap_put(memcg, nr);
>         }
>         rcu_read_unlock();
> @@ -2179,6 +2189,7 @@ void __swap_cluster_free_entries(struct swap_info_s=
truct *si,
>         unsigned int ci_off =3D ci_start, ci_end =3D ci_start + nr_pages;
>         unsigned long ci_head =3D cluster_offset(si, ci);
>         unsigned int batch_off =3D ci_off;
> +       bool is_xswap =3D si->flags & SWP_XSWAP;
>
>         VM_WARN_ON(ci->count < nr_pages);
>
> @@ -2208,14 +2219,14 @@ void __swap_cluster_free_entries(struct swap_info=
_struct *si,
>                 id_cur =3D __swap_cgroup_clear(ci, ci_off, 1);
>                 if (batch_id !=3D id_cur) {
>                         if (batch_id)
> -                               memcg_swap_free(batch_id, ci_off - batch_=
off);
> +                               memcg_swap_free(batch_id, ci_off - batch_=
off, is_xswap);
>                         batch_id =3D id_cur;
>                         batch_off =3D ci_off;
>                 }
>         } while (++ci_off < ci_end);
>
>         if (batch_id)
> -               memcg_swap_free(batch_id, ci_off - batch_off);
> +               memcg_swap_free(batch_id, ci_off - batch_off, is_xswap);
>
>         swap_range_free(si, ci_head + ci_start, nr_pages);
>         swap_cluster_assert_empty(ci, ci_start, nr_pages, false);
> --
> 2.54.0
>

