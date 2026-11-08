Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43D5A606A332
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:48:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VZ9dr7Vw
Received: by kanga.kvack.org (Postfix)
	id 421496B05B3; Sun,  8 Nov 2026 15:48:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F9756B05B8; Sun,  8 Nov 2026 15:48:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 312D16B05B9; Sun,  8 Nov 2026 15:48:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EEBAA6B05B3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:48:35 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8FB871C363E
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:48:35 +0000 (UTC)
X-FDA: 85413140190.21.83DC789
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id ABD6C20002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:48:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZ9dr7Vw;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794170913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=djErT1YvUu0mkM8hSl51RULADOIRnOJrc/Fo5hTxu3A=;
	b=dDc5SLD1on+Pblp6ctEbaiAYGSrH0RuFdnHe3ot5djNc8VWv3DC0zddIY+jNM3RkkHToqM
	D2owUNJVrcXKk7LnRLFue/6o5N4eteimAysI1In3tBGHwbkDwrmM4hgl+FpCGtVFOvhimZ
	NOfhUM4MO+67s85ynmUcYVcvd75NddI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794170913;
	b=ACxFxhdrYuHuZNgyzUSqUK5ffG1bP458r29YV8wtrXnnV820jpzuYF1tXpqcdvodlt6l/0
	mPC1JthPp6dfTuhqFCsY/ahp6OA1EgJhAM/rdSZjZyaSL8LY8dJ9s6XfXXrXDSEZPcXmpb
	2MivzAr5ALi2/5hG92jTEQHFen9ThSI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VZ9dr7Vw;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2835744EC3
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:48:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DF981F00929
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794170912;
	bh=djErT1YvUu0mkM8hSl51RULADOIRnOJrc/Fo5hTxu3A=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=VZ9dr7VwZlMqRCf2cZMC4mKBGmvOV4lXJUDDdnwvlDhOR0IigvXaYtuZTIbgdtsNL
	 f7i8FNCsRcbBGJJWx/OiQOMQIOi7j/NPX9ieTBzSWYw8PLgkFZkhiWP9IWO9uPxVdo
	 tNh1aka09dtSXfHWJG2oEajh3/HV2MYm0oZh42efak/XWKeBLkvbqt62djOGExRmGr
	 TS3Gf5XOK1gSeOnsmKJgoyrGsTNpYdAAgaGblzNlLLA22lCk7JlnYaKHuKIh3QNglu
	 0sL4bJmxZmhPf+AS132DBPMHIJ87VEQIBjTBRbj5lwRegYRCHJvHxHdIxJnl3pRujR
	 Jqo4EGqr3vFmA==
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-93cc1ab5f6cso32206285a.0
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 12:48:31 -0800 (PST)
X-Gm-Message-State: APuU4Z8wKG9eCZxCmV9xmtAAKctpSGne+K8QXMRO4esXwHmKAQDBlXCy
	NiBA5ePYATK0vBkrUAmlYn2Nk84xIZNzMTZ4IyP89TVDQ60YeK/SEz6LjSY5pXqtrXTTW3Y/3EB
	HQclyyvYcqiN99v05dBaJeSBGuwPp0yY=
X-Received: by 2002:a05:620a:1706:b0:944:d7b:e7a with SMTP id
 af79cd13be357-9478427a79emr342902085a.52.1794170910757; Sun, 08 Nov 2026
 12:48:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com> <20261016-mglru-fg-v4-6-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-6-2106750c0bfa@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Mon, 9 Nov 2026 04:48:19 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
X-Gm-Features: AclHuK_zbDT_3bnI0_EC4q_0TU7opSFYKTqi1euA2GlbUa3wQRMNDwIK1fC-8Kw
Message-ID: <CAGsJ_4zQh0TnAxifWPo2+DcyFFOtpXM+2QW91A07oumfyrqVYg@mail.gmail.com>
Subject: Re: [PATCH v4 06/17] mm/mglru: move add/del LRU size accounting out
 of lru_gen_update_size()
To: kasong@tencent.com
Cc: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, SJ Park <sj@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
	Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
	Ehab Ababneh <ehab.ababneh@intel.com>, zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
	Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: ABD6C20002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: wfr9tu7qq3cht8jxweyiftoe3aiq19jy
X-Rspam-User: 
X-HE-Tag: 1794170913-375929
X-HE-Meta: U2FsdGVkX1/BLynwiwLS24dGPNLdoPiLsOxFFnxQLT39ITipvOK3X2Uytwmx373ez7UargOue9YmGs9ujJc888FOaU4ecCXGU3/CW/6baTsRk7Hw92Nf3r930BwmaYS8I6QNFXEW+c/TpHEiuE2u0RbAvbJSJTSV5AaR2iV/5x/AcLn9ddfENnMox/6bsIO3G2681h1KGc+IgAnRjy3XnSZ4qsx8auMvVT6pczvQCikZfLJ190goD8+scWejQaHt/MRxGRXcVlTSBcpSf/eYUzMsZv4fwLSr3N7UErFwogoL2+Gx5UURfi0TWK8SYYyCBcG7J67KtUWKa82V2uKOIY1MTNIkp3HSTBCbeKQKYTXuq92JTK6tE8Y9T4JJjtiSxApK4GJ6qSXeNPq+TZxVIvbXTmUfB+z98Id88h4989e33O9Z+OFWGaFDihAYE/15rAzdb2/GSz6IEYf5PCi5T7VW8ElZBC3GUWPET1Cr6gcC+vKyJzeFhPn0LH6CEwyuF9emqxRef6Z7ibkAFzbw8AKClYdsng2QB0HAfwP6VAafNMsLG/DYfV6Gh15Diy8Fuf7MXCmDfAgsWHWikk1XB1ewBJXTlNIy3vCarHqfvaBCNvbm580bej66MWfJ7RNx04tW15SiuRjT27WBiaR2LTaZu33xAvB5Cj0bRLIf7M9/9nrd1RHwnoNYcWEifCYEzi5SdwBliZMlQFRWFMo1xsytGgAz5Stg8RBPWwvl/12BmocxYQUhp4yE1niyLDyE7E7xYZFN+QPRIRSepbCBFE8J6RxdYnxFTeZyGZQAamp1GvAkTGlICQ5+7uVma2Fgmez7gKxuG/gApHLRSa2Oy/AHOvEthlBISF5dvYXWWE3l5NTn8clGJJ6qMu9NxEhQUR6QryWCQ8a5YVPupWUbO19I/CI94N+jA7/ButUIqGgcTxazAad4hjImJ9shBzouckIIuoeJqVly2XETzJZ
 WTm62Nw1
 6PK3O43iln0IbQTo9pUv9nXadTVlUXYMkEPdEObS4DWVHS6H6wbeKjR77CTPnQdv8Z+OExjEIZoYNNjCFET14v/5RbkQWolu7fCH1yEj7nw/InHbUIh1Fn0qcZ2i50ytrdhtUmvsfhLkhcc9mgMEg+/WtGVXu8DgIY+FSqmi+026ZQJp4gtVRxHb2D2Ak90tVot18I4dJEohM/RepeKc0p9Zv6HkineP5DyevT68BvLM6HlQTThHBkPbs2xmay0RwV1awZ8TtrLkmPmY1qxwCTeZRXtFqGLM8xWUcvKEknhJPu0GZ9cR3ZbzWX/SwvRf/Nib8oCrEmlYp4p+TAc+xGBXxQI/J0OFNfhHmX30vFK/AJzvYRfePEuM79jBbtI4+A48DP/eNctMOqDFM9dx/lcM3GgTlsL73KnnDBOZ6HC/GQXxdoSZqCFMd1vSNnhi6ljZk01S8qE+RcDUIV1+FUFUKHrPzDAHSwwGtwSqqxgWmV1TMaCs0M8cNZgFAQEBGqEEPZpW9XMZ1wLM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 16, 2026 at 2:15=E2=80=AFAM Kairui Song via B4 Relay
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
> Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---

The patch looks good to me.

Meanwhile, I've been struggling with the names of
__update_lru_size() and lru_gen_update_size() for a long
time.

Given that lru_gen_update_size() now only updates
nr_pages:
static inline void lru_gen_update_size(struct lruvec *lruvec, int type,
                struct folio *folio, int old_gen, int new_gen)
{
       ...

        if (old_gen >=3D 0)
                atomic_long_sub(delta, &lrugen->nr_pages[old_gen][type][zon=
e]);
        if (new_gen >=3D 0)
                atomic_long_add(delta, &lrugen->nr_pages[new_gen][type][zon=
e]);
}

while __update_lru_size() only handles
active/inactive accounting, could we rename them to make
their roles clearer? For example:

lru_gen_update_nr_pages()
lru_gen_update_active_inactive_size()

The names are longer, but the lru_gen_ prefix helps
distinguish this accounting from the actual
active/inactive LRU lists.


>  include/linux/mm_inline.h | 28 ++++++++++++++--------------
>  1 file changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index cfcbe4a9aa85..65415eeac802 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -313,21 +313,9 @@ static inline void lru_gen_update_size(struct lruvec=
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
> @@ -381,6 +369,8 @@ static inline bool lru_gen_add_folio(struct lruvec *l=
ruvec, struct folio *folio,
>         int gen =3D folio_lru_gen(folio);
>         int type =3D folio_is_file_lru(folio);
>         int zone =3D folio_zonenum(folio);
> +       int delta =3D folio_nr_pages(folio);
> +       enum lru_list lru =3D type * LRU_INACTIVE_FILE;
>         struct lru_gen_folio *lrugen =3D &lruvec->lrugen;
>
>         BUILD_BUG_ON(BIT(LRU_GEN_WIDTH - 1) !=3D MAX_NR_GENS);
> @@ -396,6 +386,10 @@ static inline bool lru_gen_add_folio(struct lruvec *=
lruvec, struct folio *folio,
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
> @@ -409,6 +403,9 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
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
> @@ -422,6 +419,9 @@ static inline bool lru_gen_del_folio(struct lruvec *l=
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
> 2.56.0
>
>

Thanks,
Barry

