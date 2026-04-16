Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A3FF43841
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 06:34:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE4206B0005; Thu, 16 Apr 2026 02:34:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBBEC6B0089; Thu, 16 Apr 2026 02:34:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF8AF6B008A; Thu, 16 Apr 2026 02:34:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A2ADB6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 02:34:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4EC43BAEC5
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:34:04 +0000 (UTC)
X-FDA: 84663454008.04.0E4AB60
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 54F03C0007
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:34:02 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYanMQC1;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776321242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZknuzyHMtLlFYQ95vXYahZ/Y5rDpIyR2+6S2GwdtolI=;
	b=vvccJtma+OT5kIeL8FyM7t0BoYddaLHZxV4yhn06b59vN3vzMithzT9W28V2gSHWZ/UCF9
	q1Gy+3HOrx5x6uEVSoUjdxNdNW+M2/OhR6notEwJTXdxBYo7dpbQcvt9MBr9yVxT+uPmVD
	Qxmux6MGbu70MW+NL9INQlGsQiezgTs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776321242; a=rsa-sha256;
	cv=none;
	b=bhIbWqqnFmRP2Azltivfd6ralbR5vKw4M1vXqXgrNqU/GaPiZGbrfR+F/t0zEJi3vaI3o8
	bycpZPSerLQPoDD/mWVvuARjzvQIJlTVBnbuQ/BCiX6JDxoPtVYsu4AGNGa/O0F0ZzUKTg
	1BCko5g1W9b4KM2TDGF2y63RGIHgqUQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jYanMQC1;
	spf=pass (imf22.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2EAC344581
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:34:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7B42C2BCC9
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776321240;
	bh=AGkrEgpHbwjWfbd00/mYYDFBcDYt0Eagok+4T9GO/8c=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jYanMQC1m8apog5eIZNK3OqgNpVaS9uofPumMac+uDzNILeYNGI4a1b63kKw8SUTU
	 9aJsDYsLz1cTuZyty7jK6k9r/u5aSvfr/5QCfp+eRmC7qV9/mlCCD/zJYM1YPmoH9o
	 vEZD25PLHjhydv4+/257TYuGWyg44buKiQcqyTgj8g5+Yxf5j8sZ4AvpRpgrE06M9d
	 6AkfUh7QH+C+9bd9M3tttxYKt2HGYmNNFNGb77i3nw1OoTn5Dqseaxjst44KXKWU+4
	 2NQLDdRFv1vXUvp15g8vQ7WCDBJhRHYZF+K18/CUZWvTWiZuCMg2aX08ATzkUdbfZZ
	 P5uPLq3TclueQ==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8aca0469204so50031926d6.2
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 23:34:00 -0700 (PDT)
X-Gm-Message-State: AOJu0YxmsjO9lMKyu0R9eDJT56nbFblW7MbGbUG5rpy6D4Hc0ZoCJHef
	KoCOsAaK5USVbt555ci5jefZcxrbm8GZpVSLd4wkiv7JqAGGeAH8eyXYzwP/96kIBMZp8tW2I0P
	+P8qD9QrjiNXmJ50osmLx5eTctcpNqzM=
X-Received: by 2002:a0c:f09b:0:b0:8a3:1a24:8e95 with SMTP id
 6a1803df08f44-8ac8625b232mr341813696d6.27.1776321240128; Wed, 15 Apr 2026
 23:34:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260413-mglru-reclaim-v5-4-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-4-8eaeacbddc44@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 14:33:48 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yQDgD-etzDzXJvaf2mOja6GAuFRw1WS2NZqxBvo7Ag8w@mail.gmail.com>
X-Gm-Features: AQROBzAR5loVWDVAXPMvfFBR4NiVPZlVB3G6EZmJY25sB-Xav8mFrHGY6USH67c
Message-ID: <CAGsJ_4yQDgD-etzDzXJvaf2mOja6GAuFRw1WS2NZqxBvo7Ag8w@mail.gmail.com>
Subject: Re: [PATCH v5 04/14] mm/mglru: restructure the reclaim loop
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 54F03C0007
X-Rspamd-Server: rspam07
X-Stat-Signature: c8sj3xg8s7tfb6iby4t5bkpugcof1gp6
X-Rspam-User: 
X-HE-Tag: 1776321242-329368
X-HE-Meta: U2FsdGVkX18zERMijV8PINMcYFftzaB/kNqcnQR55fJhr7bgQfqygzrmystsnZC67czQ268tKvCxSJJgzt5tYMAOVttMahvF9kozG08WVHb5dBw1iU/n6afEc8g4CsKOITq7rsgZzQkqdp656kp4Ov+ItXsDrz9P0zx9bcs2k8+Jx8isSX1LRdZQvq63v892LezwJxTA6gbBGOxtvgZ4mmpNZfsuvLEd4Bw3cdIyoWntS4KQKnNJrCPKAxEYwHsd/cXfF2r7VFBwQCK37nkyR7WiVYQs59+E/bXAq5A2kdaaRaflF7HZJw5CDH2lP4a6dG4gd9WU1xaWdPCBsJoO+hzVUIRNqqMRgZR41YlqlC2T8Ri3SIJ1H4PEG0ICJJM9lFT3951Q+nl02dKBdWPXAgI5mfE0JhutM8JPm0XT6Gsedu2hkxTvBmA6YA4ZnOOmeD3FzIF/lzADUaFWDOM2rfb7PQNB3351vzj7iF62xg8gUEBT/xIWc7To8yqGzi5VMNpd7ttXyk+1s12sMm60DWnx+VkdPPQTox586ol0TDpauLKwkJJSyMlD6GV+s9SPXpP/FQhSFesYinEO4pFdJWIFfIPc7UTmkhoZT9Z05hGaNhZm5n1gMFyWdYY+TbhfqvceGib62WSJWU973CNnfeicAf0srNhojNQX3W8Wnzf/riCDM6Z3ST2QRxjWOLppf/YrA332xQivy2EMu/b19O7CMpAhRlS4eyiQs4ewpJM5CoaBRm4mFbSLXBO2fMd9J/FH178ifqRJAOik5LZ0Z8i5jBB/wQ8YvPxuqqsW7nTaLjjPchIrcg0QuEf5R1lMHey3PSsKzkWC4H6IJRem7UvqKc03yXT/vSUb/VQMsxw1vQWPKbIJsFc2oxW9MvnoQoXe2IpjT/vC6yiie+DkOOxbkkek2AVq+m48QHTl/zA5XyK/P6EaowLhK/b3NJXi8HSZ8QPiHIkXw0OMclB
 IyQl348l
 F4fpVogmpmfMeEmsE1j70eEbPS5iqYvla+4+2R0u5EgL5cGExm6v/Uikp1BKZAc35li+C1zcNjNFow+XMFIScnk6DA+i4+ePFk8YyswbXeSPmEYlCc6UJO8ZEqZpxp1XRFCAb/nafAbXyo12UjgicosVnQaK+w2yGc1tsEDXJ/XAdrFYcjms+QrVxBnaR9/G+vSry3+ggH/ZtdSUF7QfuccF71fBzUwf2PtbNoHunEDRvb1rFz6i0ahH7gooJBG8EDIy39umXpoBpj1NFybfqDh5V19snxZTF1MFeCoJWCTKZoSayUqpTfawxp1C/+CFhiMTUsrNnyI4FahX7XeDXDghPcHqq8U4Vkk9GC3Nm26pQknJcMkWrxQsuQ1TU++Mp41b0uYhiyZ7CNiLrGD++4eMEFywiV6e2qxw8htqUxFPOS34=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 12:48=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> The current loop will calculate the scan number on each iteration. The
> number of folios to scan is based on the LRU length, with some unclear
> behaviors, eg, the scan number is only shifted by reclaim priority when
> aging is not needed or when at the default priority, and it couples
> the number calculation with aging and rotation.
>
> Adjust, simplify it, and decouple aging and rotation. Just calculate the
> scan number for once at the beginning of the reclaim, always respect the
> reclaim priority, and make the aging and rotation more explicit.
>
> This slightly changes how aging and offline memcg reclaim works:
> Previously, aging was always skipped at DEF_PRIORITY even when
> eviction was impossible. Now, aging is always triggered when it
> is necessary to make progress. The old behavior may waste a reclaim
> iteration only to escalate priority, potentially causing over-reclaim
> of slab and breaking reclaim balance in multi-cgroup setups.
>
> Similar for offline memcg. Previously, offline memcg wouldn't be
> aged unless it didn't have any evictable folios. Now, we might age
> it if it has only 3 generations and the reclaim priority is less
> than DEF_PRIORITY, which should be fine. On one hand, offline memcg
> might still hold long-term folios, and in fact, a long-existing offline
> memcg must be pinned by some long-term folios like shmem. These folios
> might be used by other memcg, so aging them as ordinary memcg seems
> correct. Besides, aging enables further reclaim of an offlined memcg,
> which will certainly happen if we keep shrinking it. And offline
> memcg might soon be no longer an issue with reparenting.
>
> And while at it, make it clear that unevictable memcg will get rotated
> so following reclaim will more likely to skip them, as a optimization.
> And apply a minimal batch factor when reclaim is running with higher
> priority.
>
> Overall, the memcg LRU rotation, as described in mmzone.h,
> remains the same.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  mm/vmscan.c | 72 +++++++++++++++++++++++++++++++++----------------------=
------
>  1 file changed, 39 insertions(+), 33 deletions(-)
>
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 963362523782..d4aaaa62056d 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4913,49 +4913,41 @@ static int evict_folios(unsigned long nr_to_scan,=
 struct lruvec *lruvec,
>  }
>
>  static bool should_run_aging(struct lruvec *lruvec, unsigned long max_se=
q,
> -                            int swappiness, unsigned long *nr_to_scan)
> +                            struct scan_control *sc, int swappiness)
>  {
>         DEFINE_MIN_SEQ(lruvec);
>
> -       *nr_to_scan =3D 0;
>         /* have to run aging, since eviction is not possible anymore */
>         if (evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS > max_se=
q)
>                 return true;
>
> -       *nr_to_scan =3D lruvec_evictable_size(lruvec, swappiness);
> +       /* try to get away with not aging at the default priority */

Not a native speaker, and I=E2=80=99ve been struggling a bit with this sent=
ence.
Does it mean =E2=80=9Ctry to avoid aging at the default priority=E2=80=9D?

> +       if (sc->priority =3D=3D DEF_PRIORITY)
> +               return false;


"This slightly changes how aging and offline memcg reclaim works:

Previously, aging was always skipped at DEF_PRIORITY even when
eviction was impossible. Now, aging is always triggered when it
is necessary to make progress."

It seems clear that you are returning false for DEF_PRIORITY.
How should I understand =E2=80=9Caging is always triggered=E2=80=9D?

> +
>         /* better to run aging even though eviction is still possible */
>         return evictable_min_seq(min_seq, swappiness) + MIN_NR_GENS =3D=
=3D max_seq;
>  }
>
> -/*
> - * For future optimizations:
> - * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for mem=
cg
> - *    reclaim.
> - */
> -static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c, int swappiness)
> +static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *s=
c,
> +                          struct mem_cgroup *memcg, int swappiness)
>  {
> -       bool need_aging;
> -       unsigned long nr_to_scan;
> -       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> -       DEFINE_MAX_SEQ(lruvec);
> +       unsigned long nr_to_scan, evictable;
>
> -       if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg))
> -               return -1;
> -
> -       need_aging =3D should_run_aging(lruvec, max_seq, swappiness, &nr_=
to_scan);
> +       evictable =3D lruvec_evictable_size(lruvec, swappiness);
> +       nr_to_scan =3D evictable;
>
>         /* try to scrape all its memory if this memcg was deleted */
> -       if (nr_to_scan && !mem_cgroup_online(memcg))
> +       if (!mem_cgroup_online(memcg))
>                 return nr_to_scan;
>
>         nr_to_scan =3D apply_proportional_protection(memcg, sc, nr_to_sca=
n);
> +       nr_to_scan >>=3D sc->priority;
>
> -       /* try to get away with not aging at the default priority */
> -       if (!need_aging || sc->priority =3D=3D DEF_PRIORITY)
> -               return nr_to_scan >> sc->priority;
> +       if (!nr_to_scan && sc->priority < DEF_PRIORITY)
> +               nr_to_scan =3D min(evictable, SWAP_CLUSTER_MAX);
>
> -       /* stop scanning this lruvec as it's low on cold folios */
> -       return try_to_inc_max_seq(lruvec, max_seq, swappiness, false) ? -=
1 : 0;
> +       return nr_to_scan;
>  }
>
>  static bool should_abort_scan(struct lruvec *lruvec, struct scan_control=
 *sc)
> @@ -4985,31 +4977,46 @@ static bool should_abort_scan(struct lruvec *lruv=
ec, struct scan_control *sc)
>         return true;
>  }
>
> +/*
> + * For future optimizations:
> + * 1. Defer try_to_inc_max_seq() to workqueues to reduce latency for mem=
cg
> + *    reclaim.
> + */
>  static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_cont=
rol *sc)
>  {
> +       bool need_rotate =3D false;
>         long nr_batch, nr_to_scan;
> -       unsigned long scanned =3D 0;
>         int swappiness =3D get_swappiness(lruvec, sc);
> +       struct mem_cgroup *memcg =3D lruvec_memcg(lruvec);
> +
> +       nr_to_scan =3D get_nr_to_scan(lruvec, sc, memcg, swappiness);
> +       if (!nr_to_scan)
> +               need_rotate =3D true;
>
> -       while (true) {
> +       while (nr_to_scan > 0) {
>                 int delta;
> +               DEFINE_MAX_SEQ(lruvec);
>
> -               nr_to_scan =3D get_nr_to_scan(lruvec, sc, swappiness);
> -               if (nr_to_scan <=3D 0)
> +               if (mem_cgroup_below_min(sc->target_mem_cgroup, memcg)) {
> +                       need_rotate =3D true;
>                         break;
> +               }
> +
> +               if (should_run_aging(lruvec, max_seq, sc, swappiness)) {
> +                       if (try_to_inc_max_seq(lruvec, max_seq, swappines=
s, false))

Could we move the original comment here:
/* stop scanning this lruvec as it's low on cold folios */

Thanks
Barry

