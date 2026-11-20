Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 407E3606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 08:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=jPBBY+mD
Received: by kanga.kvack.org (Postfix)
	id 69B386B05DB; Fri, 20 Nov 2026 03:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6726C6B05DD; Fri, 20 Nov 2026 03:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 564826B05DE; Fri, 20 Nov 2026 03:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2FE786B05DB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 03:28:39 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 02E481C4293
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:21:26 +0000 (UTC)
X-FDA: 85454803014.25.ADA9127
Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 133111A0004
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 08:21:24 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jPBBY+mD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795162885;
	b=DKR2PV1ei1duJ0G4U3zo815LlAZWCxkXPo8c8xqoIM0ZQGz2iGYQSYMCKHrMOeeXyhhL5I
	oX4UDV4UUYFyi/I+/TJvZRxF6ouM2ejJ+j5AdZr4C0MubXKsg4feJ1ejltv0u0i3jYwbUW
	xSRP04hDSOqbMqM4JHNiX8l1CQlcFh0=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795162885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
	b=SVqacuSFuKs96qPU2zWMIfXi9pDRfbYmRWoMQc3ltSlMg9b/d0bXK0wIIpdYiG76Nh8cDG
	9r0atjz3IVQ11FJCatqr8UfIPQifMl5JNm8zSdj6Hn3+iJcAkvtcyGtxhKadvlQHVh+sfw
	QIebx/ajzh0l0H9dXytEcwW2NqiPG8Y=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=jPBBY+mD;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of kunwu.chan@gmail.com designates 209.85.208.53 as permitted sender) smtp.mailfrom=kunwu.chan@gmail.com
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6b8b20b2538so764624a12.3
        for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:21:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795162883; cv=none;
        d=google.com; s=arc-20260327;
        b=reuaEkDmTQxOOVytp6vC7axZExEgyRF3xbD9Jo3u6Bu7KSHEVVTPqRXPLKBNZY5og1
         m+EvqcjoNLxGbddgkqm+2V+G8xDyduSOs+NmrmOgslu3zjLhXVe5dcHn1vlehV/T8feP
         rGA2uNGCe1eaA6DPmly4/+5TSu1+0oWSU1S/9jMDxN56Cv4kCqXvm4hG4ByO/InVzvTi
         CPRFTOPjGh0gXpWUy+9KrZJC+guJm571ZmN0xcHExOsJ1KNqYuPcEQTEYkO+Fpathhhb
         gSmbedgOau2L6qhljyeOWBIwkhaK/NfuGTZJVyE7Jx5by1GWmQqf4GZf41kN7OJTJqNL
         zUdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
        fh=01xpVHe4kda/rS6+PGv7HHxY0OOMMTM3Wu/tKcvhHys=;
        b=dVln90VF7kCf/Fth0O7NXAEs5Pf8sjncHqO3Ll/EIrTefaiDVftBHWXohfGqSfIIl8
         IBjG5CpT9zFnwhPPgKgLmCT97nmwAuNrN67roQ0ktPrAJnt+bKtzjYax7q441Wip/Rfo
         7Vl5/3qoWqncm5k6D9T9XhqHmEtZgFgw6TYrDCltq9/ch6Us9U32B/cBjmHT8p+FxlHJ
         OuQxrzdIdXcE5gP02aaxRKPnwt5zyr9mUMzuprrMvcw3AL70tIrCCojc6VX2AFJHCrgn
         E/z4Yx6luuhIHuYov2QbiLeprcaeEfcHaIsTgVkNe7eRkmsez2by+DoyRnl23Iijwi7x
         blrg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795162883; x=1795767683; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
        b=jPBBY+mDrRTNAiAxkfetS2/YZ7tCeFSUI32YygBVmziscypJNUc2neeuNSobC0JO+a
         AOjk6EP9pGiuzCed4zniXBTjdVlgjGz9CX9makLNKHiO15gizZ+2P/tqOiZPlOSa+PlL
         VG20UixkrAfG5L63xtJMmbAcIG1ZaCDKhk9Z+x9e5g6qm6znkv7EUK6h3QR4gYEIXKiI
         DSIKMg/sxs0QmWKdTLXHC7I7FYVbxVKzAs0aH37SsHaIcAW47vMsewVhsgAKm7MHLqQT
         QNTY8Vrho1rW8HcXQXCu4mHYWaekWzG43+XlP7XbV0oJRpjr8Kc4MidSzIUq1PcFhQfI
         /odA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795162883; x=1795767683;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uOP5aWJGRtaVMkdWmgxTwssrKgIM3MZe/XfpLaSpJSg=;
        b=rDVlnkAKr1GWJI9zLMk8OZmD3hIJqNc7OYa33RqJ1gY+DB1W9Ip+W+k7XPGJbCVxbN
         d/tCKj6qZ1OKNHfpldjIwuFp+OlzBFkZanEd4RP30X3yCKqQhwpzMsrEBC6wBoBisnrl
         nUxn50BbyXQ8g5tw8HDr7h8YEcU3I4uLwa2MnVUuCpK5XeeiIpB/dI7rG7jhe5E3+zPj
         TS/zp2rRtRCIDnUDUloT9pc9SfctIzxGFkPrYt3SjBiWb9ViyqGgbgNMjh+WVEfjdoL8
         dqLh97TfN7aGgO82nmQAVEiit+tKbwp6Tj3GZgO947ksHShjSalgneAjCkTv3x0UwYrP
         oDWg==
X-Gm-Message-State: APuU4Z/CgXrRJs50YhL95jCft2d1aiVR/kYWhWxqI42OSbVKKpRSm5SR
	e/w4YT40wI1iTOdGObJgPCfJiTFDq+wfReasqDKzDEKQ4VDGtq8PmdPxKxcPeCkterHTBdq4T2B
	iA1/mnO6PACIP29f0t0mVw1Re5oDMdR4=
X-Gm-Gg: AZFdTZfd1kAJZSw4SnUxT8rocJlQ+YOGeErXnp4QTHEHXfoEWJ3+dz9eYPGoLAiK6ww
	s1eV6S1yAfnADtTKiBTIcfdgpYQWeIWdLjmHVTwC7r+hElx2gU2294kLAk2kJ7Wt+XulUqNLNy1
	0TAJTkm+fK1QeJklSzAF5syBn6UQaHhM+4R+LSVmeNu8pymZxZds98bwuMExYPPuxF9m88veYcP
	euOmtYyG9a2RIi+gpcyL3q7Q5bSOHaKfm/DWSGj5ruzl5Mno/osz+vt9JpNsPiAkljB3ulmHZLr
	p99wGyn0YaBxTQ+hE1BLUXtJ6IHn3iIrT0+ffGKOSVaVCUOORyW3BOWo7AMyRBEJOn8XmCnoKHw
	9Vpa2qhr6XGLJ4M0reK7WwZHzVTrejOURw6tiv9Wo9txT/RdTMr/Lk94ptFVKKA0=
X-Received: by 2002:a05:6402:46d1:b0:6b6:efc4:9ebf with SMTP id
 4fb4d7f45d1cf-6ba37ac75b5mr1331883a12.0.1795162882855; Fri, 20 Nov 2026
 00:21:22 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com> <20261119-mglru-fg-v5-10-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-10-9eee2fe97a2d@tencent.com>
From: KunWu Chan <kunwu.chan@gmail.com>
Date: Fri, 20 Nov 2026 16:21:10 +0800
X-Gm-Features: Aa3M54pHysxbWD9vjPcsTe4RDZA-59shgtAMQxrcEcwNDlcrEAHTKKIWInyzYBE
Message-ID: <CAN_Opa-Nn_ps+x6gWkERRDWBXxt3Gqnwvfw_4rURaCdPiyTc2w@mail.gmail.com>
Subject: Re: [PATCH v5 10/17] mm/mglru, smaps: convert to LRU refs based
 operations for MGLRU
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
X-Rspam-User:
X-Rspamd-Queue-Id: 133111A0004
X-Stat-Signature: bbdoao4chh1bq6iqryhei75ehr1851eu
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-HE-Tag: 1795162884-728952
X-HE-Meta: U2FsdGVkX1/fgB2ZqBxOsNCBNAeSmRf1myTTst8Qp8CtApnSuY5uj8K2gNWzgPDpLRkRT5ib7wvNYE+/VAXo7aDKW+I7W75ouyRxCTdFvQpbgHow8yRgTrLWcQvAE3gnGcu0v6/x5OAp1ASvi83K8B+4w3gnXrpbJY/+aWMkWm9/r1HsPbJWPRWwHRVh7zlCQfeYBI12N6V17yg1nVhLd7OfPK1g8t28qU/kt+Y6sc/nwvfTS1epLdV+w0747qWYd4Ec4L0KHPuoZAIIbZayDRLWtsM55VRTe8cuA3izAau5yR0wIKtC8lpW/KcVB+ncu1zO23CEM4+b9NVbIVZr+dt6NXDrv3cTpfda/4hjEe5+E/ejc7r0hTHPxGL9aS8G7HluguAyNQpPnCLn/SQdPTzzwZxQm3YnfBbT/InFjqdx5UXIF16Cq0V8bvaA9TaH+ZcU64oO6UtgN42U3D+wV24ZWM3XOPgoSX4kiilPKdQvSdohuA3qO7EuuKKNbXDA8QUMm65OmURiECHWD6MdgZh/A7pp4HOGO/N5jeSixhtecQYfg/kvyUhR8Mxj7wCR23g82onaLmOjzoz/88ZKJPP4DhjLNq8up184PFqoU9pSO7UY4jCDojRlNzdNyTLhE7wilpnnyunszlC5m2lXd07F/KTVzNN8BVI8znN7Fr7YR869pvr4rgBHX6jiN8rRTQh07WbvaKvAwIJrBCeTVS8ArjSwSRnuz/y3U0eYMG64xFX4GKUm/UtEf5yLupNGXGSXKvK+cn1o2jVhpHLLbX16MNhhjUPmPvjTREt/NgKy3g8MhtZVUuTZayssCQfmm+QWaFnXi5cNt0FHOZd+YFVOH5q1dHP5Fy0FnDY4DujzaGwxYBfpGlqm/WBwIW9O6zp68J+JLYFyGaqSyllNthqShicD/55dOm5ZA9dYr1Xu8O7QdlRgbjEuj7joMpHzy05mHTCFMTkaAjjRGOC
 JJ/j3SGT
 6KAD2pVloxD8L5ixO02mGDOFNVbIOiyrD07yrTXsciLLN7pU4DGSv+tjuAo1XytVKqSzgNJHQVLYgOBXOyfsVZ19oxNJ77S7346xysDQxTBNZajkFMvK7gkb515Jd/CPb4AxnDHuNIFgfOp60CWIj4sn4QHxF1GAPh2eVcUQIYCt8CMUuRns9TsVYiFi9PeKHyH0XDFyRQMp8FK5HWoSZgFVrentC6zsOiRb9KP+Mamu+g1EEYNwt4Eku720gVaKBE/DXRiZWVsqEehEVhc5nOujszxMhF57hL8r/3K8HPsG64yK4Y9djeI5ykshf74ZucBVICcMzOOISL+lXNGAIXQX//xxw87d26l62bCv0DKIyABcuvQLNVkWlOtECi8S9vzc93IzcnijqgpQX8kQSRhpOkZKcp008Qp9d3oyxpvQ/J+EdFK51lYcy/PJNrNkHOB0bTO0MmWgtJ7UfDvZt/IMWe3GVnSUql9W/TonUsiPJdew50etvU0+rfNvr5+vbYcEmaejqa9QaFZ9Q8pYW20M4OyoTINLpz1uXWwNJIucNaRT5fPjhot73dVOSvveQMX1lfb61d41tOqzn8ycf2rbNJYmnACNj0a8F5IVheaaAFG6env77mOR5KZGGa8t2302Sdqbf8AWBozlqMUvm0ZtWkIL50eciOBijuEaRWHIh9kif5DQenvcXvBkRuPUcyyuf9N8wXJnMRxL6vpCxS+Ou1aMI05+HBLMF5Jb6xJO4PI43SB6bw5PpkWC4jlY+xnqL
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
> PG_referenced is only the lowest bit of the folio LRU refs count
> (LRU_REFS_FLAGS) now, and MGLRU never kept it stable: promotion used to
> clear it, and now it toggles as the count grows. But with the LRU
> referenced count as a stable API now, we can use two helpers to provide
> in-kernel users a stable and sane reading of the referenced status of
> an LRU managed folio.
>
> Add folio_check_lru_refs() and folio_clear_lru_refs(), which use the refs
> count when MGLRU is enabled and PG_referenced otherwise, and switch the
> smaps paths over to them. The lru_gen_enabled() test stays inside the
> helpers, so its static key is not splattered over the few call sites.
>
> Convert smaps as the first user of them. MGLRU now reports every folio
> with a nonzero count, so the reading no longer flickers and clearing no
> longer results in an ambiguous status.
>
> The classical LRU case is unchanged.
>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  fs/proc/task_mmu.c        |  6 +++---
>  include/linux/mm_inline.h | 31 +++++++++++++++++++++++++++++++
>  2 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 22361607020d..f76a37d052b1 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -889,7 +889,7 @@ static void smaps_account(struct mem_size_stats *mss,=
 struct page *page,
>
>         mss->resident +=3D size;
>         /* Accumulate the size in pages that have been accessed. */
> -       if (young || folio_test_young(folio) || folio_test_referenced(fol=
io))
> +       if (young || folio_test_young(folio) || folio_check_lru_refs(foli=
o))
>                 mss->referenced +=3D size;
>
>         /*
> @@ -1686,7 +1686,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigne=
d long addr,
>                 /* Clear accessed and referenced bits. */
>                 pmdp_test_and_clear_young(vma, addr, pmd);
>                 folio_test_clear_young(folio);
> -               folio_clear_referenced(folio);
> +               folio_clear_lru_refs(folio);
>  out:
>                 spin_unlock(ptl);
>                 return 0;
> @@ -1715,7 +1715,7 @@ static int clear_refs_pte_range(pmd_t *pmd, unsigne=
d long addr,
>                 /* Clear accessed and referenced bits. */
>                 ptep_test_and_clear_young(vma, addr, pte);
>                 folio_test_clear_young(folio);
> -               folio_clear_referenced(folio);
> +               folio_clear_lru_refs(folio);
>         }
>         pte_unmap_unlock(pte - 1, ptl);
>         cond_resched();
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index 3323a3c7336b..14aab2b1ed08 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -508,6 +508,37 @@ static __always_inline void folio_inc_lru_refs_fast(=
struct folio *folio)
>         } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flag=
s));
>  }
>
> +/**
> + * folio_check_lru_refs - Test if an LRU managed folio has been referenc=
ed.
> + * @folio: The folio to test.
> + *
> + * Returns true if the MGLRU refs count is nonzero, or PG_referenced is =
set,
> + * which is also correct for the non-MGLRU case. Kept as a separate help=
er,
> + * to avoid splattering the lru_gen_enabled() static key.
> + */
> +static inline bool folio_check_lru_refs(const struct folio *folio)
> +{
> +       if (lru_gen_enabled())
> +               return folio_lru_refs(folio) > 0;
> +       return folio_test_referenced(folio);
> +}
> +
> +/**
> + * folio_clear_lru_refs - Clear the referenced state of an LRU managed f=
olio.
> + * @folio: The folio to clear.
> + *
> + * Reset the MGLRU refs count to zero, or clear PG_referenced, leaving
> + * PG_workingset alone for the non-MGLRU case. Kept as a separate helper
> + * just like folio_check_lru_refs().
> + */
> +static inline void folio_clear_lru_refs(struct folio *folio)
> +{
> +       if (lru_gen_enabled())
> +               folio_set_lru_refs(folio, 0);
> +       else
> +               folio_clear_referenced(folio);
> +}
> +
>  static __always_inline
>  void lruvec_add_folio(struct lruvec *lruvec, struct folio *folio)
>  {
>
> --
> 2.56.1
>
>

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

