Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF332C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 01:55:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE2F16B0092; Sun, 27 Sep 2026 21:55:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C93C76B0093; Sun, 27 Sep 2026 21:55:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B826E6B0095; Sun, 27 Sep 2026 21:55:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8937F6B0092
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 21:55:08 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 068D4140ACF
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:55:08 +0000 (UTC)
X-FDA: 85261503096.18.1251782
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3FE9F180002
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:55:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efTM8ZTj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790560506;
	b=cDv4T7yGPVUyienAAC85ExbjKxAFevbQDGWN1dTLmraWdlgSMzLxZrPP69VmgSBt3blCca
	qUw+og8soTLCZxdCOehAtqSelo/aCm5dPqHZFnms5m/GB3DQ2QU7eX88bP/YVkWKC4BylO
	fQeHb4HaZ+bJi2TNdFCf9irLqD3vktg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=efTM8ZTj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790560506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CGDHSAQ5tB8MgTGCNrr1v8mE/afcFeNYKkJFVpSD3HM=;
	b=Z/dBOp/7+xKCWR9SzsZIn+mlG0xDP/51fPieh16iCi+uYwpAMASi5amA8RzgVSn8opJ5Lq
	Tg0mjNKttMXvf8F+tcdO2Nam4BKVNclqzkCvxad2JmryxKiFZgb0+ftoNuKkvdJon7IxLk
	jEr1Bm/RR0VwfMZZkmVcvJrr5Q3GFac=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 892CF60AB7
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:55:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359D71F008A3
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 01:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790560505;
	bh=CGDHSAQ5tB8MgTGCNrr1v8mE/afcFeNYKkJFVpSD3HM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=efTM8ZTjjCUwGQZqLYzGrQMvIRNj811R0a5ErKv8kIFW/DB39UcjRTPbpaaPEls7j
	 IYG32tcb3oey8Za6dN3D0lmtMftQiLW02Ptv4TzONIcuu0zxm3mt/lp6+XKKB6Mxli
	 kuPne008yO6fgfXySCfK2usA9taAcsIW5yVuwKEY8Yq+Ejzy5+3bll0fZ5jkxMwz6x
	 m9WevhtUkFTch45w4jlCwC4Wf0+2EXPPy+ftvJZUB3rM28a8BrKC5NYRsM2kC6pJJy
	 /ZonZsx9sCNsKZG/oOGH25BFYvfvEhPBIuX0zf8PrqjquhO23rCQO7X7TGYDw9q1zA
	 QRilRG6ReHc5g==
Received: by mail-ej2-f42.google.com with SMTP id a640c23a62f3a-c2c570f6f36so180730166b.3
        for <linux-mm@kvack.org>; Sun, 27 Sep 2026 18:55:05 -0700 (PDT)
X-Gm-Message-State: AFuF++mFRO3yAk0Uruhty9x91283nPBtQrSVtgpV5tYtYYpgMOFnic2M
	WTsgWQdpjvhAFtrBJyc3de0yt+XOuGLxPrxT61anjSi/uQctQ2HnY01Fa86T7zI5+Qi3SO0Fsai
	YRhfIlv2PeooNznQjYn6/RALm0DKOPYNToY2DyMO35g==
X-Received: by 2002:a05:6938:a085:20b0:c2a:fd39:f23b with SMTP id
 a640c23a62f3a-c2afd39f9c8mr309429166b.24.1790560504047; Sun, 27 Sep 2026
 18:55:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260916101929.149106-1-hebaoquan@kylinos.cn> <20260916101929.149106-7-hebaoquan@kylinos.cn>
In-Reply-To: <20260916101929.149106-7-hebaoquan@kylinos.cn>
From: Chris Li <chrisl@kernel.org>
Date: Sun, 27 Sep 2026 15:54:53 -1000
X-Gmail-Original-Message-ID: <CACePvbVDR8k+X_AB03qF6LZNt_VUZKpZjdiBi=otpEBqTbH9dA@mail.gmail.com>
X-Gm-Features: AclHuK_8_Mi_A98RRVS32FyJnZqZq_ytQTjn47If1ciKgv35gXDCap__SJ9tEr0
Message-ID: <CACePvbVDR8k+X_AB03qF6LZNt_VUZKpZjdiBi=otpEBqTbH9dA@mail.gmail.com>
Subject: Re: [PATCH v3 06/14] mm, swap: add xswap grow trigger on cluster allocation
To: Baoquan He <hebaoquan@kylinos.cn>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, kasong@tencent.com, 
	nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, 
	hannes@cmpxchg.org, yosry@kernel.org, shikemeng@huaweicloud.com, 
	chengming.zhou@linux.dev, baoquan.he@linux.dev, david@kernel.org, 
	linux-kernel@vger.kernel.org, kunwu.chan@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: ohmyxmcpa8bguiyo8kshtzobcdyw6xqd
X-Rspam-User: 
X-Rspamd-Queue-Id: 3FE9F180002
X-HE-Tag: 1790560506-345288
X-HE-Meta: U2FsdGVkX19BdLZ8nSrMCW3aj9jra9Ej/+IoJInmLN9G6IrQjJB87uoDerAaN9yuoyrgZuk/0XIwLaLG8BHy56GAiGNJba0mlQ/vtoVIVfEgF0zh0TboCG5RTR5BAQ3tAE9XJxItYWqw4l8ONGOUDvPGbRogtRosEcM8PNY2zqC603RwJUK/Jrt373ip43pkZ2S0C8pu5sIrLsewx9s/pGIOlY0Xq3xdw5t69gXp9PO+OBrnhWrdHyj2T93H1DJi36LzDCTrZegl8+1h8qiSnwQCJHAzKbXC3JEwd1XacWyjLB81lF16PoUWeFnyQoEEUG42CCU9wDZ2z00IpC/ygd4DOwBXZByYi26DWIXPfGrFv/dCdaVE3dwmg/ZYT6xbZosOaWhTdsgRertFyxDL3TJ0jZu/J1S+heX4tEDXc0ruxlQhdNeZAxqyNmqa0gyJk1Jxm3r+9QwWLa/3/RPFO/9S7+2P/lIXpQp4OIUUknyr3a2n5lffSlsSBxz0aHlmKVYDH3WzJ8otziXZjoNhWT4qRjBUkBdGHxhdqxFjBjy6SMTSw3ALZIxOU+Txwoflq6K0sEzwneM1HdlBVqQHzXz7mz+U5ifi1V1D7otxBy79dDGDH16DdC5EEdZYbh15sgBdIlVYexwXoAHqO/lzfWZVDQ9lY263grzW9p914c+zNYuXGzP3ERO9nVRtNXKF8CGORRm0OPx11e/swPBZL1x4LBg/Vw6UKY3KzgxKfiONeyqOF4MSKdV7mide36PC0hsaGUpBOIVvOdSIuTiSDl41SAxNTl5XbLKM7YfqJ/AuNPxRJNxWG+C9ddy5VjquuGa/NROLWI6JsBCc+gQEVABYCqu9lvlh4wN37KVXEvbLej/vYL7YZNDHCPd/h1JKFyt8EInUzxWAOTmWjKLP5ErEFC9AJk0ACmgJG1WokOQPcITrb879k2t+QBNGuuVus2oh4iQBL9ZARnvnX4z
 bSyacrpA
 Cd5VWl9cRNDgEmbMbev2RwSJ0Lm9xu91Jf9b6W1P9ctd23Q5l0w5smUH7NILVEcuNYceI5Ea/sRbdPfTb9Y4U/KCUS+IYfB+ir65TNWcbOdPwo9C2sedlaUArtplhsjeJ0ysj4iX7sg+azqbHXg6Ih1mXi/ylVWxR+EzT3e4WKpV9/R/+jH+J4MmtbTFVTYcSXId0KvBdde9+YOwtw9qN5vvACSwUPzSVbemr7R/xjO/ZbfcS7L6IvvDkResmBTyyFHd4iIOgbLH5UFEIJlrAblB5iBBP94BfghfQnQ57OwDArUo8SklxSsBuHjcpgfLdMncQvtRvT7zV41H+l2T8FXelVkz8tmfD6eqxXYGTtK2hYm8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 16, 2026 at 12:20=E2=80=AFAM Baoquan He <hebaoquan@kylinos.cn> =
wrote:
>
> When cluster_alloc_swap_entry() fails to find a free cluster and
> the xswap device still has room to grow, expand the mapped range
> by XSWAP_GROW_CLUSTERS clusters.
>
> Since xswap is always SWP_SOLIDSTATE, global_cluster_lock is never
> held on this path.
>
> This makes the xswap cluster space grow transparently as swap usage
> increases, without any userspace intervention.
>
> Growing maps pages into the VM_SPARSE area, which can sleep. The caller
> holds local_lock(&percpu_swap_cluster.lock) across the whole slow path,
> so drop it around xswap_map_clusters() and take it again afterwards; it
> only protects the per-cpu cluster cache, which this path does not touch.
>
> Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> ---
>  mm/swapfile.c | 41 +++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 41 insertions(+)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b0edf5421fc5..17e482059d32 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1273,6 +1273,47 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>                 if (found)
>                         goto done;
>         }
> +
> +#ifdef CONFIG_XSWAP
> +       /* For xswap: grow the cluster_info array, then retry. */
> +       if (!found && (si->flags & SWP_XSWAP) &&

I see oppertunity for more swap_ops

Chris

> +           READ_ONCE(si->nr_clusters_mapped) < READ_ONCE(si->nr_clusters=
_max) &&
> +           list_empty(&si->free_clusters)) {
> +               unsigned long nr_new =3D min(READ_ONCE(si->nr_clusters_ma=
x) -
> +                                         READ_ONCE(si->nr_clusters_mappe=
d),
> +                                         XSWAP_GROW_CLUSTERS);
> +               unsigned long start =3D READ_ONCE(si->nr_clusters_mapped)=
;
> +               unsigned long i;
> +               int ret;
> +
> +               /*
> +                * Mapping pages can sleep.  The lock only guards the per=
-cpu
> +                * cluster cache, which this path does not touch.
> +                */
> +               local_unlock(&percpu_swap_cluster.lock);
> +               ret =3D xswap_map_clusters(si, start, nr_new);
> +               local_lock(&percpu_swap_cluster.lock);
> +
> +               if (!ret) {
> +                       for (i =3D start; i < start + nr_new; i++) {
> +                               struct swap_cluster_info *ci =3D &si->clu=
ster_info[i];
> +
> +                               /*
> +                                * A concurrent grower may have taken the=
se already;
> +                                * only add the off-list ones.
> +                                */
> +                               spin_lock(&ci->lock);
> +                               if (ci->flags =3D=3D CLUSTER_FLAG_NONE)
> +                                       move_cluster(si, ci, &si->free_cl=
usters,
> +                                                    CLUSTER_FLAG_FREE);
> +                               spin_unlock(&ci->lock);
> +                       }
> +
> +                       found =3D alloc_swap_scan_list(si, &si->free_clus=
ters,
> +                                                   folio, false);
> +               }
> +       }
> +#endif
>  done:
>         if (!(si->flags & SWP_SOLIDSTATE))
>                 spin_unlock(&si->global_cluster_lock);
> --
> 2.54.0
>

