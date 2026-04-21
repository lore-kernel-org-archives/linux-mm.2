Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 675A5F8FA9A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 17:22:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F786B0005; Tue, 21 Apr 2026 13:22:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01436B0089; Tue, 21 Apr 2026 13:22:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EFBC6B008A; Tue, 21 Apr 2026 13:22:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 898686B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:22:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2705E5DF0C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:22:34 +0000 (UTC)
X-FDA: 84683232228.27.58E8F77
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf17.hostedemail.com (Postfix) with ESMTP id 27A1B4000C
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:22:31 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rOfpqSyj;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776792152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PcLBr7Pz5JgqfDdLDDrvjpb70+Buqpr5RFGb1YIZQMg=;
	b=L/iawhDxFBpsbdlOlp2NgyMW+10r1DnS1g1WaGCw2bR6BIJwBZaXDCTJFP9OnJ2iTSLB4v
	QlmNZJVKz4I7hWaOsKeOGLBvKhL8QDjyKnRTHWqHubqXYPgnnR1VvMcyU1sfjLGfbiNxcz
	Vk/vTHvHBlktZU5+9ffuGUgsM3HJU8w=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=rOfpqSyj;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776792152; a=rsa-sha256;
	cv=pass;
	b=IpA4uQ7hKNRKXYzvmJWub086xtpgy2f3q19gqMdKYfr/Jlj1PcEj2mg0tOXdEJ/seAWv4D
	RuK8RH5I1KKdmi9JjxHqzy3FVPhdtdVvRzMpUMfthq8L4Bo7OvufbKMvmYVv2hp2URNkvr
	vnZubwX/7yVCRPvMdmueJkOIq0umSpA=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-671ff4b716cso7573107a12.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 10:22:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776792151; cv=none;
        d=google.com; s=arc-20240605;
        b=AL8cMfatjxWNeomUUCcy2C0VXUz152l27mjhYSXL3z0f1WJIbPL05NcphZqsnvjvMM
         77+lo2gOs6YnYcKrLF5afmEbQfGyzhKP2oIUxKKr9b7XQN2m3HWJv/iU8eHQ9mzQdtb3
         acOIzlsK/0sI3e4WeLbTSgXQ6ovDfpxalM9Q18aJWiD5zMOWe+d6mEY5bzEBsWKjL1Ux
         8ickIJhGdxy5dAl3j/1vVWpcph08Le4TzpHGVfksY+YRMYrWwwwonLZzPFUygMlnUSUM
         ldoNaNhSE/boMjs19OQCYUid75mXS0K52ukrsxYj/gCl9KQZR5v+YFpULiuAcUqocSiQ
         6zWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PcLBr7Pz5JgqfDdLDDrvjpb70+Buqpr5RFGb1YIZQMg=;
        fh=Cs1lDTMZyNjuTUEBNtwSbayIeAlRtnhaxWq+q/n8n54=;
        b=YSlqC7nvgVCT7/vmsJmDPLevp+TyqMA0h2tRse5B6u/hO6MDCUgC7QB5Zgt7/jOTug
         NyBk5U0vXKMUv4v0fJAaQpQ6eR6zxFgLzNBQTstRCxKRPfTYwBPmVc4URxxELP1ij+oU
         YBCvoXXUdmr88swdM4MN8MlvobVANbm3RkE1r0MchbP8lNcOUzA8HOJYQO0dt1ZbqNs1
         GbBeu0c9VdRi8t3q03sAQSTP/Xm2z/txqSJCzjHovW2iD0HhMEdXxSgtNYFJpGCdGwjv
         HFQg9WMsf/B8fQQjvamsxIV5SXcl9bMjAgpQU8Ara4bBcX5D6MZZ3B5KfBi/LGukhxPP
         46bw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776792151; x=1777396951; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PcLBr7Pz5JgqfDdLDDrvjpb70+Buqpr5RFGb1YIZQMg=;
        b=rOfpqSyjsgf+BLedfIcGjW3LKsAPkj+tERW2VHF+OMO2nZqEDM+zJVudNPBdoiZri5
         upJO4X2Kq+2xGN6pT3giJNdIXUcPpQI00ScrSuWxULTblzt+TqJIeiSALOsmXe9lEV6q
         4mgjexnFteC5I6JP5rGeU/C2cAMxwwULQUxKrhZ1sqEGiWy/PuN3FwW3x92B2+tmtnno
         /3IXfCzJiyUiv37vxuqFqbEoJwHSgwIH5f4fz2fgGUiW39kOOz8A1ru/9oe8lyJZ9GpN
         eiDtbL1tihAq/1CD6mFbya13rcyBKQRBfqi5bMG1sTo5iTDTKGcvzOuKJ6IBLtgvN7vg
         Ug7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776792151; x=1777396951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PcLBr7Pz5JgqfDdLDDrvjpb70+Buqpr5RFGb1YIZQMg=;
        b=OFaNjVEC0QBtvtKwKfkRFIDPMsB1OYRdAVDyYwcPtSwP0jCYXndal2jCK2brOMUAYL
         3YYS6I1KWtLIkntislxCQP7RVDzeSkNH0E/D3291vBWRo7To+s3wvkxGIe8AmtYLWdo5
         EfKRRtKc4+nAZkJtaGFmC4DJo3NxRI5+VZexh6kGaoX5ld8q06jw8fc8xvbeAzv5RmPR
         Y1k4sWn1C9GM6MOHHJIlCsR7f9KcB3+33Ki9ARRIcSG2UPMPB3Ao4Rs2RN75SX2Cvmkm
         QpNTGzbGtkwXTFrWD+a32uYVYFqsIFiy7jJp7NDMIdJa+OCJC8aLOizRN0DBMnGOjNZb
         zXSQ==
X-Gm-Message-State: AOJu0YyKbQrOGIybARUsdGO6YpAWhI+WnPV1uWXFsgVROMpi+E2Ewd6y
	5URYmRGhj4I78Q0B6zvZDy6bumSV29r9Cf9fgo/kEJER1D25R5GE8J6N/zhaS2tjLIYGhh89OtP
	eaG45WRmjwxRtLqRlJr7sUZ+Z41tkSaw=
X-Gm-Gg: AeBDiesHPUAlYuFBp7kjZsNL0Q5OtfDPiXZSFcGOS4HYS2CFTXGp260Rs2lcgFs1M0r
	OJ7hhxaxljcBZ1W6VtSytBChJEi4cfnD0t7wopocMcatsP4TWbBqhqUqZmm2FCvDcMQ5CVa1Ycp
	5/lgDl3cgYuGR6FjkFAkyHjsZoOIn2impTJWuJOOWv3Ioil15PhWJx+XN7iaZkk33G2jyRWq6/K
	GNFCITbkm+dxVTaS7cZNzJ9FkpOFHkX5+9zGjta5uvvWiOohJocv1qBqW463bAly4iWAigah1sv
	X9moIGZP696P1F5cDz2IDAvkqkuarH3fd41Sfg8Rglmskh++hB4=
X-Received: by 2002:a05:6402:e9a:b0:66e:5662:2121 with SMTP id
 4fb4d7f45d1cf-672bfd97db0mr7797694a12.7.1776792150367; Tue, 21 Apr 2026
 10:22:30 -0700 (PDT)
MIME-Version: 1.0
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
 <20260421-swap-table-p4-v3-3-2f23759a76bc@tencent.com> <D631DCC9-85F0-4E68-88A0-AD5DE328818E@nvidia.com>
In-Reply-To: <D631DCC9-85F0-4E68-88A0-AD5DE328818E@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 22 Apr 2026 01:21:53 +0800
X-Gm-Features: AQROBzDl5z9C7yRxEIuCYiZdOdIilaUvBCXT_HbOfpgIJfVG6_TY6ZM0pxpis88
Message-ID: <CAMgjq7BDmGWaVWBL+52_c=jgs293bgB+Qe-MafKE7dWZRsmx9A@mail.gmail.com>
Subject: Re: [PATCH v3 03/12] mm/huge_memory: move THP gfp limit helper into header
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Barry Song <baohua@kernel.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 27A1B4000C
X-Stat-Signature: c3rujx83ky7qfc7qnf9i83t6ouejjjur
X-Rspam-User: 
X-HE-Tag: 1776792151-214778
X-HE-Meta: U2FsdGVkX18/vL+P++LwOWnatAb1Ej5PeLJJkXBHNzJEsniBuM6vRx8hr8F+/6pr3qiKsWlQTo2FpwqxXb5qdIKbkgUkqb2y7b950QKTRGQ4uoPsK1e4xaxucxW/UHqITimmXuh79qyChjuHFN8wSZOF0nI1uGqQDiou59SgprsllUwRtw8KT2KW694rfnZsr2kOTGjgvQNU/19WGDuA6uiLETyThPTZJYOFV0rdgoPz0kJYDcLyp3u1TIBXkiXOC1bC0K08kgAgM3LhFHIqPh4qSG90xwjJjnYqkJTjev/LJQT97A4u0iF1a5jFxlCKs5HIZKkVaKuEdzcQfrkxPdoQXh8rllMJlSI27vuN395ZNbq6x2Oq/wKFC9SAwLKr1zSReScp6X2WONd9lVezhBA5obWFAu7Ez0gKtcVTNWfK7xU0U7zRMD/fYrZUArOf3CwNYz9bp3yLoxAeR6+oF6kvoXV2CQnvOaIwWuw4ThDgrCMxCljQN/kRG/c1F40hiNn7ttHOHo9Po96v181vuh17uoYnFWevTulklRvP8DZEKGQH654DRXHPx0vpgazzgwQLdOZajGPco7X7UrSLJllcITFTYsBjxmezJQgYTgE4HKVEUxWhJXIBqfVLfByJe8qnj3htCuEQW3iNlgyKCyd2iFxm8jbdLMyV+TIccSpaLi7BadMA7k7+GtiKJbCk7C/jXb7KrfA+mxoNNKUCqqZ+Ma/diApqDITK/VoQ2u4Y2UV8pbI4LB0NYZTXd7vt2Qs1AEZzqcFPkXPfT/JpVcDapeMFlJ2oOKssz7eyEVRCmsMabhV5UiQkNYORJ7xikrAUh1TCfq7Mz4OR6MXYCLdvu7FUm5xCXOivcPyln5kNe02lLNFmHh6oqHCU5yhXphm5ATqZuB05nOwG7PzyJZEKrtFn1pUi5ECioiHh+/cj/eC4OJ0MFPtk6HF/Whl+AW3Jc4yOv4HtafE8ieS
 HIVpGB1Y
 nbNU6nLELbDd/e45WGbzQmqhfpaxnxz5tCXjU53va+KWSvzIBDH2/49Q8FdqjSAbUpyZbBfD5YJu6EbLz2dFVmCjw2GmHHb/zroGiMpuWI7vFA12adQbncsjyF4Rh2dkdfD67J/96vlGS5ww1dCFspnwCAHLsPBVvNgtrAmms0DfFjJJF4VN6BtHagmdiRRH8IEQ3+DPmNzOyFmIXOTU2xWmrMVRaHcV0MKLgUY7QNT/2yKzuisOdGs4nVhK8E3lRWmzIZV9po/bNl3DN1GcUB63xUBy6nmgb/jQl+4eg/5IIF+Rcd21cjhtWe+DPA6Xmp/02Gx+c9tiRvzK05FMDI5IuCM7VWNEMBnLYIw16rKc6ory4jBu5EFtiMrRX+bfDFO1hGEiIWgtMBo54hV7stArLDd+Ty8PPVkDL6VT5DEMY3Z8lbj1cdX9HDjDvTQ1D6n5ycm3m9bzcztM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 21, 2026 at 9:14=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 21 Apr 2026, at 2:16, Kairui Song via B4 Relay wrote:
>
> > From: Kairui Song <kasong@tencent.com>
> >
> > Shmem has some special requirements for THP GFP and has to limit it in
> > certain zones or provide a more lenient fallback.
> >
> > We'll use this helper for generic swap THP allocation, which needs to
> > support shmem. For a typical GFP_HIGHUSER_MOVABLE swap-in, this helper
> > is basically a no-op. But it's necessary for certain shmem users, mostl=
y
> > drivers.
> >
> > No feature change.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  include/linux/huge_mm.h | 30 ++++++++++++++++++++++++++++++
> >  mm/shmem.c              | 30 +++---------------------------
> >  2 files changed, 33 insertions(+), 27 deletions(-)
> >
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index 2949e5acff35..ffe5a120eee4 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -237,6 +237,31 @@ static inline bool thp_vma_suitable_order(struct v=
m_area_struct *vma,
> >       return true;
> >  }
> >
> > +/*
> > + * Make sure huge_gfp is always more limited than limit_gfp.
> > + * Some shmem users want THP allocation to be done less aggressively
> > + * and only in certain zone.
> > + */
> > +static inline gfp_t thp_limit_gfp_mask(gfp_t huge_gfp, gfp_t limit_gfp=
)
>
> Would it be better to rename it to thp_swap_limit_gfp_mask() or something
> more descriptive? I am just worried about misuses in the future due to
> the generic thp prefix.

Good idea, I wasn't sure if this might be helpful for any other user,
but for now naming it more descriptive does help to avoid misuse.

How about thp_shmem_limit_gfp_mask? Ordinary swap is fine with thp
gfp, only shmem is a bit special.

>
> Otherwise, LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>

Thanks!

