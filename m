Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C538C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 13:44:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2F3866B0099; Sat, 18 Jul 2026 09:44:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4146B009E; Sat, 18 Jul 2026 09:44:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16ED96B009F; Sat, 18 Jul 2026 09:44:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E18B46B0099
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:44:08 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4D9B91C0645
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:44:08 +0000 (UTC)
X-FDA: 85002016176.17.D3942E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7404D20002
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:44:06 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=maJiWk+o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784382246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jYalFBgutm5KDjz/B98LKvDxzwCmsCWkO/Rd57DRHwM=;
	b=3NQE0lX1A40KKd20RGpcEfG3qd9CQcXEJymAOITiqJITpa+ZROiOfCruft5KWT6bKUPHme
	3kjAAJ+grPk9H/11RRoABHni+zdVGNF3zXyUUp+juzQ5LezEsGEH7ZyIAH/nMy6Q+4BpB3
	wHD1hq731kJIWGBcKZqEq0PT8v/Hf2w=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=maJiWk+o;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784382246;
	b=zsdR4M/gwnH8DuoGK8S6vXEdi6nrdqn8pnpVI3Xj8BeQdXc8lLMEEH2C+yDw7/01ENBY84
	4qB8cxeaLIr/7UiPrcMZFctjkewuDKYytMleRPzw7mmz3EWVa0h7bdaaXxeDCqkQ8CWID0
	cTo7Tg1QQyQIikVKBtT+hMUGnHmU5pk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DC98360A5B
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:44:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 822C51F00ADB
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 13:44:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784382245;
	bh=jYalFBgutm5KDjz/B98LKvDxzwCmsCWkO/Rd57DRHwM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=maJiWk+oQun3W3JJikG3IRaGsr/xxEJe9coRnPiS4hlhCx1eYSzcKCGIiErDkNbKL
	 2kXwwmMjoIjxs19TZNY0l1w05V3PzWfam3fGVbajsNFqdYJJ387YX67f+nt8JP1DnQ
	 og/MtfOZFt222IYgcYpnnHX8vdtFG/MKEMkLAEMKyntfbr71ENo4MFgkxlrcr6YZJY
	 u3OHziF9+GkQrhUosw56K3gIjqEtSdYElvCP+9elici7b9gMvrnlWmjdeyrqN33y21
	 wvK1XdpKGuRkyFxCsvOYab0ipyYKvlQ/TOlwxNUgcecXrf8uviYLEb78r1K/eOVHg+
	 jGcEJmjryG77A==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e5c92c389so533916785a.3
        for <linux-mm@kvack.org>; Sat, 18 Jul 2026 06:44:05 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqIvfuxwxWPxQiJpHwPzw9W+QezRXo5rUnGfeBib3x0efLjepBOmw0ZnehOtXA4t5zdMBH1mtVNpw==@kvack.org
X-Gm-Message-State: AOJu0Ywl5wTnNKlfUzkXeILncXTQrAEzGRnliuNv6g0MTQkGMsp13OK0
	/rQBZUPsr94gMxI98lLbgeSEYQpEhakGLvLrmqBOCIZAwE1gX3V3Mw1Qr6eZKtfR3W/OMbxMChb
	3Lbmr2Pt8TN/cLN05WKkac9XV20+xmlY=
X-Received: by 2002:a05:620a:17a0:b0:92e:72a4:f28c with SMTP id
 af79cd13be357-930b3ed5207mr693258885a.30.1784382244779; Sat, 18 Jul 2026
 06:44:04 -0700 (PDT)
MIME-Version: 1.0
References: <20260718095251.82937-1-ridong.chen@linux.dev> <20260718095251.82937-5-ridong.chen@linux.dev>
In-Reply-To: <20260718095251.82937-5-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Sat, 18 Jul 2026 21:43:51 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zGRtDEGnQwmFqXrEcm93UrHaX8A_awJgu=b8ikceT8fA@mail.gmail.com>
X-Gm-Features: AUfX_mxzzeBpYUHxtyHE60mGP9IGYujCrB7RrTO9tzrI3zr5hMDWpIRUiIiKp6E
Message-ID: <CAGsJ_4zGRtDEGnQwmFqXrEcm93UrHaX8A_awJgu=b8ikceT8fA@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev, 
	dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7404D20002
X-Stat-Signature: o8jzhes71qfdwdwt98199xk5mwpy4mbm
X-HE-Tag: 1784382246-592957
X-HE-Meta: U2FsdGVkX19AWXd8t9a12X6dc/GO3D9pciepYAFogkM0S+FAhmSamqQuHAZfCdoqgM+R2q+LfBWWLrFl1AjdjaCm+8qxWVL9LnOTpsb8iuhr4mm6RJtm3vXRz+Pa4rEhxwxXQYO6JSsehuz29cZ9iI4Kjpqv1SG14It/8SOBEfJjfoPXlpQACibX5zzB4Yh85+r4sIlXA4Y5yCOsvMLCIhL1kVTFfM3e03SDBZ//hErxmAl5Rr5uD9GX701vtt61vBtOO6eHsOlvvO7kzRn45yNtFiMDKEtm7VfBV1TWhK4M+OzRzBB4KDWwc6bBywYZ1u4B0pW0r28CIWeZ51vRVpiLOjioA8eTEy8CilxfuTtftHiXc6U2xUTui+RtIpdEE3/sY1kRNy9ew1znOlrYlHb+d741g/sK5kzcUzIoKigTlzvhfwVvqaUfEItJRFcWTcAXEwiger/jnr4y0VB8gscX9ITe4AKfUNGXy5J+CdopWfjqTtI+O7uV2t+X+kTZd8q4BcE9yom2zSL/ZajSDOHjRBw5ar1vCNCzzWlQ4MncUHgowWJ5eERT4RGS09ItF6OsFI8D1mA5nF1q/2BajKQKkkR8J/ebslkTq/s9vceCwccQNIVEHArhYJ7/ojL4JAAa25jCMyAu5TiRoA8jt3F0TrALyuqVzCZUZhOFr9YIdjte6OxQHL3ZRlh0ElnrOYZMjDhWF426NEuJRaHAPzMoarq9qYZB/+wTFAjzjVilGJv9268D7u5H0MzFxyf1A+AhNbWLVe6kRe1rKsuK0ith7FyLrRtaip6uBen2M1K+tmvjkjbwlLXKHflhDlI/K05xQ4mN/Cr0aqkGranSdC0o25B3hDKPro/J1xgpmt6nodQwAiCj3gz9Ap4r2rcQFboyKvLfs32jELtMV3fjOxm5ryWEEV5r01YBEZ06ISuV5X529zuB2zS8UjnG+zYKA+9MPSYAx5a6Z6LRJlh
 P1OWvi8o
 zOvxlpmayUQUl0hMWRLoFx+398bBxz/lbkpc9HL5btg11dw6R2uzPrOxi1x3Wpfbws+CUE2YeAa4+TxW+D6vwqFXc1ban0y8bm3PPXPV3R6OZhhO1wXZXcXjkEPKd9wjF4TS8vSV/aagytZYF4iQMo88bGv+fLu+4T1Qj6WrG1ZOJZF/QJ9tcOvKfEu2tMhwjwNL3NDziJrr78lF5BWvBzZOpx9yg9x93o3gLSh4DmPdjmoQGNIB2UpOEGckBbXvswNj9cNICoMP1l/OCsc2hg6nP2NLu0soN2ebV0Z/6sPRniPzHZk2mEl6Y6yw5heeyp2ydngnJNKYMEurt4rgTINHDqpzhDzA0d8fyrBKuqljDznBxGhQ9S+jM5g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 5:54=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev>=
 wrote:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The previous patch fixes this issue for the traditional LRU, which also
> exists in MGLRU [1]. Fix this by checking whether swappiness is
> SWAPPINESS_ANON_ONLY in get_swappiness() first, and returning 0 from
> get_nr_to_scan() when swappiness is SWAPPINESS_ANON_ONLY and anon pages
> cannot be reclaimed, to avoid useless work.

Is this intended to avoid unnecessary work, or to prevent file folios
from being reclaimed incorrectly?

>
> The test result:
> Before fix:
>
>   # cat /sys/kernel/mm/lru_gen/enabled
>   0x0007
>   # cat memory.stat
>   anon 204800
>   file 67108864
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
>   # echo "64M swappiness=3Dmax" > memory.reclaim
>   # cat memory.stat
>   anon 208896
>   file 0
>   ...
>   pgsteal_proactive 16384
>   pgscan_proactive 16384
>
> After fix:
>
>   # cat memory.stat
>   anon 188416
>   file 67215360
>   kernel 1970176
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
>   # echo "64M swappiness=3Dmax" > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat memory.stat
>   anon 204800
>   file 67215360
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
> [1] https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@li=
nux.dev
>
> Fixes: 68a1436bde00 ("mm: add swappiness=3Dmax arg to memory.reclaim for =
only anon reclaim")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> ---
>  mm/vmscan.c | 14 +++++++++++++-
>  1 file changed, 13 insertions(+), 1 deletion(-)
>
[...]
>  static int get_nr_gens(struct lruvec *lruvec, int type)
> @@ -4915,6 +4919,14 @@ static long get_nr_to_scan(struct lruvec *lruvec, =
struct scan_control *sc,
>                            struct mem_cgroup *memcg, int swappiness)
>  {
>         unsigned long nr_to_scan, evictable;
> +       struct pglist_data *pgdat =3D lruvec_pgdat(lruvec);
> +
> +       /* Proactive reclaim: anon-only requested but anon is not reclaim=
able */
> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY &&
> +           !can_reclaim_anon_pages(memcg, pgdat->node_id, sc)) {
> +               WARN_ON_ONCE(!sc->proactive);

Similar to the previous patch, maybe it would help to add a bit more
comment here?

Thanks
Barry

