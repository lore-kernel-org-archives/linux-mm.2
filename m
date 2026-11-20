Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA41960A2617
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iykod0KO
Received: by kanga.kvack.org (Postfix)
	id E7B496B05D8; Fri, 20 Nov 2026 03:20:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B756B05D9; Fri, 20 Nov 2026 03:20:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF42B6B05DA; Fri, 20 Nov 2026 03:20:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 998466B05D8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:20:31 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EBDCC0C97
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:30 +0000 (UTC)
X-FDA: 85454800620.09.F8981D9
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9B81FC0005
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:20:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iykod0KO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795162828;
	b=djKReB3bacbcvREvRTiyqQhdfLTlnmfJ3aqj9t60OqRztBHQMCDD5UhQgjHVnFaS4/L+OD
	f9QIWX86k4Hivnnxffisu/6Xoy7JVlDO1jkGi+PQX0ae4KM0onnBK0Tnp9xQjGWNnHrevx
	rlzlhjOnQN8WKMX68qn3RSNlUoTYLQ0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162828;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
	b=VzZbVel3DiYhAb2PA6mY/QWYPIAaCSaUYUPC7TsudO3v00Wo5hk9tLnXrvsBRbU6ySjP3G
	Idr4MmLrZMIYF4WuBreiqyh5e7oeGSmeYt8+JGB1NtfO2aFTtENWf5psZ67BYY+XDU1cj2
	nGPprHUXqPXRhdv3wwk5Xn01x0sZdNE=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=iykod0KO;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf10.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4bb666304fdso15944805e9.0
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:20:28 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162827; cv=none;
        d=google.com; s=arc-20260327;
        b=IYBVxXZLbCJXoj43ZNdX/+RNn2MQ1guI/4Dafue0/vfUrzlG9TUCDjcfhRvO7YwBxt
         aukiJ4KxU4HVM88cP1OXqYzha9EBqN2m24rw7huIQ8EaSrNWJcsmXAAII2HQGOTNXfMk
         T2GCt0uD/3K3NH6s2FowdWBvCprEjkHKkTrco29WjHStro6a2NdR03Vf82uZ1QnaSh7d
         tX2O7l4D0tFh66NVpARPMZBZTzknAEiwiuFDryzd1vyj3NgtrRfXaF2DyJZsozECm3CW
         CkgZnLy20CSzxHek7/XZvCbHjOGT+Zdl0gL1lyXyUyL6NG+P9GKujxzOuBOK+l4RTKHQ
         7mXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=s1N6w2TeCsVFShYMpsvo6JpAo59MSjuQRjc2UigjjqDX2smXzGI9sLKvaT93XSIzN1
         bWBlr4/UnmvUIVBU4NGH5Pt4Wg3GUTxv+FNw5dKS8uslx3HahkaYCP1vtvI+8eXHsLXi
         jvkDOeVccYZtXL8kRNqdc/0fXGDbTg2EmCP0oPBI9b9ON3n++ZJRbVgTzNPsmusRzY5T
         husP/I3Vu12kok7PM5W0zuBQbfAz0kG6zL8o8EPJIirD+QaqYdWAWucWKM3+L54rIf8H
         jfHQvRLcVSKQHCNLMpk/gZvWrLvqNNaj/KqXf3LwNP0YQ6YWAuQ0eZOSc3Y2lAmkNGpU
         gKLA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162827; x=1795767627; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
        b=iykod0KOZdgYKKH7KcBg1W+172OoLh28ckQCS0P5DaY9I6HeRtoMpAHDP0VjbCRQ/s
         tfEr0QWhxxmSkfEDjrOqzWzsjzoQ30+q+QCfN63ZbwM0eEclHz1lzFdX1o3kP6J1Yzfq
         sezXvGfjrdez3Lkf7TZuOQCGiysGqHtyGwckE3m4D1PKapilMvpLgAbCxjiRO0+k03ip
         iIL7qPCcvVfEQDUQni2UnND02NGr/0OfdFH+Qqh4BTcBGL44E9HxdrsxhYwNpUX//0X5
         FPW8gSF5JDwGa1J85zsn6omk4D0AD74bWvIEQPWcoKOGNiVKS4aeIuaAylIG/81mP6Mj
         AcyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162827; x=1795767627;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ud3dyyf/JEY/R/2fhpQWVjOi5aq4aTlLAjlkAINyk4c=;
        b=UkYPTjDrcwFepzr5wdt8CPHuROgwXhjfYTqZ/0AuRkaNF/9ZreIZgtThAP0DTS3Y/t
         YJqW4mFZTgvm4YSnwxgESB87eW90S5vFGvuJKt3Ej5FchUg3jui8FpLfijEUQdGfRFb/
         LJp1OPfXuf/Vks7KhgfeVJjAo3ix5F6V4kpwmFT3SSo65qzjJoQHVfRqFAkCVE9679/0
         TUuJubTwmDtGT5tHWh/5XPsiJydCqbcxjlsIateBi2LmsZbnTYnzjpOvpuk0IquLvbw3
         87u+IRPPHv35cqGxwMK1jtcd3Ue1krukvZtqqcDZ+GIrgfAe8pEuNmWmEM7ZEwRNJWNQ
         lJgg==
X-Gm-Message-State: APuU4Z+OgVKN635dqSRS3c4EMg7NGCseqFIDsx3bjen48WwYXWTQAfpr
	Rqv9BHZTa1RlQCNBWeagcvZumm41QwveoKQV+Px15U+/2w1sogkZhNW/3NmHHbVHPIEOQ836o9O
	SU+ZHJtzSV3X6A9cGUQa2r0SbuaNBUHs=
X-Gm-Gg: AYBFou2UCO0Qm7L9+ObHTpLJLgCmZM/10+yz6vPnz8vbPWnd58T0QoQzacnLNmLmWn+
	1XUw1SkLfu1/YpEp0B9QHFyx0VbjNiCsGaSCWRpV0HgctqHf34UOHYphcVmLWD1Abxg40mLynoS
	HV86jG1jJmNvTGFGfFAShbucK9rHi5iatD1hZyeQuUYa71QVT50HQRd4rEVpp0Y+D0NUgh6OgUx
	CD+yautctBGznlOiXGO3gwdNfbOdMuYBjw7Qyf0YXWsFmfi3zlvaewplquZ9rtxUv+UzJd4kRIL
	/3UL8jh9cGtxXtC2YKUfMXJp1IfppRPBkzF3O15IMlOXBgMm6i4TsX7/r0AEr4vcPDObiSRcgY3
	rfZJnwf/AiVRL1okC3Rk1l7BhF4ubzWD51efOeCDgSM8dE0qbq7J/ErLJBqW/Rghb
X-Received: by 2002:a05:600c:4504:b0:4b4:a551:681a with SMTP id
 5b1f17b1804b1-4bb887fc396mr47908935e9.3.1795162826538; Fri, 20 Nov 2026
 00:20:26 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-8-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-8-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:20:12 +0800
X-Gm-Features: AclHuK_oxtudcnoh95U_WO0vrwwpF-uDqqiNW6HAKd9dIMedRC4HEEVfEGFR52A
Message-ID: <CAN_Opa_3vb54=6pMeRfzBpTmXG0Bfprhjw8H1mzA8NZ4c51U-Q@mail.gmail.com>
Subject: Re: [PATCH v5 08/17] mm/mglru: move add/del LRU size accounting out
 of lru_gen_update_size()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
	Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
	Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Hui Zhu <hui.zhu@linux.dev>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev, linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9B81FC0005
X-Stat-Signature: nzybtxa8wbeqtm9w36z95b7xbu15dcdn
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795162828-189925
X-HE-Meta: U2FsdGVkX1+c7b2ZdBxxTFSfspqnz7aFBYocK9V0PMrXzoTsvg2C/paT2HMHoL8EiDFNhq3WmgqJyyEJiPqJlMQ864757K/mMBKzfqTlmdZZvyy6SF+ecoTkdpAdntY+F6J4lteQRBEMhERZsuK5so1FP9sgXJF5i+iFWM+JJPtVYNDNyLNArea7ipLe/LPG4ErcKCLVZ9I9iMn9nDCSygJhIIyvEBuzVcLZbHAhp1c9jEC66dnUSQAAjk1uw5QGkZOENYMouURDtOTkfwpU5I/ShZg14SHkbx/6YxZ2Rpw06H4n7MVG+6qmAVFIxv6V1PI/ze1JciuKtnzE3rPstGx9txje7vVoyqHvA8ZYsU3CS8QXYvpk7Ume/73pPxulnfXwILhe8WsrVLic2d9q8YE5l0cH+Mu2xzE9ziU8WPpfDr2mgGmuRtLN+UxLipO4I2EUjiEEtYNR5bM1lDBcmRApi6focfl/iMieeRDPRNxeBHtOfyuLKmvD/qDTdyRda5jPX7Hm8a2IHZUUHHPUgBZGPhbnCFVnWGAuzjOgGgcStexLnRnlTx47s+L77anl4rIrLX9MJecFoVPyQI2vnUi1Yg4LrJOBql6s5/cLszlsnX5772PJngpJdMp9520B5dWbZO5K3EdyB2xfxZEJZNQdc9VvUIrsBqpbNkGjoP4qTd0m6jZvgBdGAe9PAZrqXXwOn2ravs4+zsddVh9LqM5WNpOcrDpS9Y+VMbUTPl09zRUHq1Togn6uTH+FyV09UXs9IGuOc031dDllHNHfISYzcy1M7IEqeAgxJMU4GXjaLUJyFwORRHjt3z8b3f+n0K1nYQO9XMER7RRfxoDEsMFxg1a5ga5HkzNjJMAMUsQd1MenzwIvw9kPbb6xVGTxP9XA7t5MYNW5/UShAhNo5dkPvuKP9wMUbLXC4zTEq5noWiBEqjYCV+p+tKz0BqrqYwQzdjRxdgxtFA9wrwk
 6RFAggQD
 2rSdGG2yyd4POIB3vkt1QVB8WHLUfpDwmbsPLMHu6rT6SykbFycia0+ad/QxLn5jw73BuoLilu+8FUft2A/5dzDxLQcdt8wESxat3a0AUs8RcYFvkKaLa56CAir6DpA+hKVKiQW9gtrCjiDjSlZJNTZWxylOFmcFRBpXU1ETsSC9iyk8kLwsRb2ERjk7lYh8y3CvPraa3apEJqGutx59nRX7JGKQTh4XGiLCgNmg6Qvl8ssGmxTiknodEh/e6f/VwvM+onTEI1zOHKFeI07ugJvGZMxIfew0jKmA6ntHfwAzvsDOTQKTCFrIbMzlqlpyd6Bj8ihyMDrebkm3FoXlXVmznmb1WQUtbKLDhyfMvlywWaF//mflM9VroEAHlAjOSuT3Bs2G3wynJGy2tOHfjXv7TgMiORBWIBay7XxlMLSaY75HoJj2xWfmKGC5zsyyvpoT/nQ2LqqaV1GbDZTg+UZserPZzf6Oxpfo4j6XJqW+34vvoqbeDaMQQua6iwXSc7i0kzuiH41mO7NM3WpfLCheOFoz37Ru2jHvy5Bt10S2qpw+/6iqQXf+K0rI96TisJStVn9QH2M74lA2kFIDrT33Awze6YzmB/ki4fZU0Q98CUzOJ6PkBeWWQSxe9WsB/9zRMuoYSMKCy/PnRw3xFHeUE0eC2+xbEQ37r3JlkFQmeK5s9/ONDlbj6yeBWAY/gahb/42r3cDGNLgHOjO6dbFqdJzrWBXSmns6yuo7pItCAzrO/6qKNuWNjGJ1Lx3ImfvjRNm6j0ZtWe1zHfhkZailRsobZnul397GLCn2kULAqARxxHArx/jFgit5zafknJc4QhjIDcPcHd37CJHjLfNhPx823fHzuze3MGjpxiYY93j8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 5:03=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Pure code shuffle, no behavior change.  lru_gen_update_size() now only
> updates the per-generation counters plus the promotion move; the
> addition and deletion active/inactive accounting move to
> lru_gen_add_folio() and lru_gen_del_folio(), which know the generation
> and can apply the active-window test directly.
>
> The unevictable case is untouched: unevictable folios never enter
> lru_gen_add_folio() and keep being accounted by lruvec_add_folio() as
> before.
>
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 180db43c3a85..b15c3618a1f2 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -322,21 +322,9 @@ static inline void lru_gen_update_size(struct lruvec=
 *lruvec, struct folio *foli
>         if (new_gen >=3D 0)
>                 atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][z=
one]);
>
> -       /* addition */
> -       if (old_gen < 0) {
> -               if (lru_gen_is_active(lruvec, new_gen))
> -                       lru +=3D LRU_ACTIVE;
> -               __update_lru_size(lruvec, lru, zone, delta);
> +       /* return now if not a promotion */
> +       if (old_gen < 0 || new_gen < 0)
>                 return;
> -       }
> -
> -       /* deletion */
> -       if (new_gen < 0) {
> -               if (lru_gen_is_active(lruvec, old_gen))
> -                       lru +=3D LRU_ACTIVE;
> -               __update_lru_size(lruvec, lru, zone, -delta);
> -               return;
> -       }
>
>         /* promotion */
>         if (!lru_gen_is_active(lruvec, old_gen) && lru_gen_is_active(lruv=
ec, new_gen)) {
> @@ -391,6 +379,8 @@ static inline bool __lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *foli
>         int gen =3D folio_lru_gen(folio);
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
> +       int delta =3D folio_nr_pages(folio);
> +       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
> @@ -408,6 +398,10 @@ static inline bool __lru_gen_add_folio(struct lruvec=
 *lruvec, struct folio *foli
>         set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active=
), flags);
>
>         lru_gen_update_size(lruvec, folio, -1, gen);
> +       if (lru_gen_is_active(lruvec, gen))
> +               lru +=3D LRU_ACTIVE;
> +       __update_lru_size(lruvec, lru, zone, delta);
> +
>         /* for folio_rotate_reclaimable() */
>         if (reclaiming)
>                 list_add_tail(&folio->lru, &lrugen->folios[gen][type][zon=
e]);
> @@ -432,6 +426,9 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>  {
>         unsigned long flags;
>         int gen =3D folio_lru_gen(folio);
> +       int zone =3D folio_zonenum(folio);
> +       int delta =3D folio_nr_pages(folio);
> +       enum lru_list lru =3D folio_is_file_lru(folio) * LRU_INACTIVE_FIL=
E;
>
>         if (gen < 0)
>                 return false;
> @@ -445,6 +442,9 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         gen =3D ((flags & LRU_GEN_MASK) >> LRU_GEN_PGOFF) - 1;
>
>         lru_gen_update_size(lruvec, folio, gen, -1);
> +       if (lru_gen_is_active(lruvec, gen))
> +               lru +=3D LRU_ACTIVE;
> +       __update_lru_size(lruvec, lru, zone, -delta);
>         list_del(&folio->lru);
>
>         return true;
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

