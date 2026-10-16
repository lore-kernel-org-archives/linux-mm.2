Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99DDCC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 18:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D516B0088; Fri, 16 Oct 2026 14:17:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4E66B008A; Fri, 16 Oct 2026 14:17:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FD606B008C; Fri, 16 Oct 2026 14:17:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67C586B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 14:17:58 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D03101605B8
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:17:57 +0000 (UTC)
X-FDA: 85329298194.02.DD8395C
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf24.hostedemail.com (Postfix) with ESMTP id D0F30180006
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:17:55 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DLeB1VLB;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792174675;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WOrsml+QKf7TFFWgAyGx/jH9V3mGobRODjiglkN265E=;
	b=6UBLjXUrsvIsfuHxEuGj4ce1gLACMuVYfz8itRBe5q42ZY2nKwUiwwJ1zuxhhwWab2Mo5T
	ll4Lckp9nQbUetnoSEqt2ldqiVY6DKVGH+qCirO9Cptgbvc82e4Tt77fH8Puye1jsmCvJa
	i8Jj68MemxbWEDp52+Cfs2CA57NYWT8=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792174675;
	b=3fpZJrW74FBw6X3l5XXfCH3QTCMBJblA1Mw+cg/ICuBnSgD+dGaZhJsm1PUqbyvv8reTWR
	BzQJcPyRsapBUCqbS6qJjktsVHXdrmJP07GbiIKY1HGrV8jTYvgTZPPLe5OsCa8leq3qbN
	UEa+uONye6I04btoEvu6Fw0ssA352cg=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=DLeB1VLB;
	spf=pass (imf24.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c3f8d72d7ceso31119866b.3
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 11:17:55 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792174674; cv=none;
        d=google.com; s=arc-20260327;
        b=hBFQRTeTRj5RGE+szSDyqsQFCGQiPsLsYKh+lpROkWGjBOXgZmukqrs+TdywKZqmLg
         3MA2skZBYRgiDN38fVOgs1SZ+gc/3t6XKXiJboC/G6OZMygbqWsaTl4nckSGSrsAPUL/
         ISY9DNKK4IdNZafyrZXgRujb1vvZoul4QmYo6mpPerC89uxr7uQyt/NGbtAzS/LLgr2a
         Gdov3tQ3ci9H3lHdP1mZ21Q9n+lBfZASmuBtWYsl07NgeTBuwxIG0ujvpQxabONe7R7X
         Ika1z+FKEIuwBbfvv3Amz+r4Q0RqJNYi7+7K4+H8o9pmQI/rRLOacCm1f/SqjT3SKEPP
         uNag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WOrsml+QKf7TFFWgAyGx/jH9V3mGobRODjiglkN265E=;
        fh=pYWVRDA79s4loiPF82nyEGOto5jww/yicL5o4JtV36s=;
        b=PWDYydEyhJdkF+Gllt8eID2Vefaw6LjyzGeOyDA/CrMftVd/kSNEdjBtN3pAMC5kGS
         p0sGomGM9HtJVY4w/gxmekGfFPtitzdVazQF6gLuDP8q/2oioH56SorgOkMsSgouHiv1
         6oE2OsxauCnh4vQ5K1KM1aWQKlMF+S14QR1Cg2g6mRqv54uaolPjPNjEbWZxddyvneOG
         IpTfVd8gmQBGsh7haFBquDtCpVQc52rZ5y4lfx6GllUCoFKOYNhd27/SjKMb9Y2Pz6dy
         lJDEIKnJ5VYDy4VY1DFEyt1S0c8Kc2uj1CK8B5wQrIcllczfghggeSsnGE12/Y7PM8uW
         IhSA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792174674; x=1792779474; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WOrsml+QKf7TFFWgAyGx/jH9V3mGobRODjiglkN265E=;
        b=DLeB1VLBJo+xyg8MOsebEinMAcVIaRYfzh0SI8xRB36YvBPMxCvFb3YSSoNwjjPHfe
         IsB6fYPqjfFsj/a1ItQprQlGFwKqDXuw5+ulZZ8fEhxMzlvPrYhQ+kKyoreTEVNs5tAm
         Drmnc4HUQlSA5t4mEwuN6Yns7jrIm0JEafia2/++0hp174qkFddqASs5dxCtNhq1Re2R
         O421XYZqu4PVeqFLfyjTZlo5UehOsHxJpOBLMFTkMnqADvHdVssGHZUSxPj5wvAfPJdA
         XonjvRqw1toaUJ+ju/Ng+VBMSGqU40UGfGirCfqZ8p9AF1NnqDPJJJYMetzfIXIOjHpO
         chPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792174674; x=1792779474;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WOrsml+QKf7TFFWgAyGx/jH9V3mGobRODjiglkN265E=;
        b=eC/xFkrYYK1VOadskfsOzPwO8HNxzsOOu7cmXLVpz7IpF5kTRzrrscQRXptdG7Y7Pn
         k3qTB7bciWCIPcps9H/Icz3Da/A6NYfU88J/OI1N4WFHCkqxDQ+vG//5m9nDLcjwO+W5
         13JO4obdWa2wOmyEaBXmL0rMY+EYfMnszgK+eUH6+a7/s9fLvQ6CwLXDDAJekukXPecK
         1Y/hP5xTACxgINepSFYtsvUauFs3hDvppfx+1JhsrMbsqhFGNBzKivSOnfxO+sfdL++8
         9TojbnrUIRZrbsoQ7bqv43ooACmBCxIyaq1x/31HVhHWdIvZzgxaa7/Jsq7RRT+wAovs
         +6Fg==
X-Gm-Message-State: AFq9FYIcoAoVoxmXXxjIKAqQitZA7d5Gmxsr7/foq5jMHZAT46uYzBRm
	VqfCvEztRun37/5UOAF9iMf6JtAYVm6AGl8/RifdlMT5TMtdnR+/j1XeKb1R7DDraoyrusHVLAS
	zgkcuGDxfS3E55i9OvrZUbfx3956qD7k=
X-Gm-Gg: AYBFou0F6WH0k5b13NjRKhVgEcj+bRsh5IDs1tMrZLM8t3+De4ZQJGynBr5otTjLE6D
	kxtKBu88nU0wWj9kqvNlCwMY5Df1YMJzkvg31PzPatpOd68Ti1gtjSpUsr8EfOF5gTyFdAD36G+
	4pINSOb+uVh51Toa0Zo8M7BjQ3YK3g3XUTK3ZJ6HnlOx8zIbPUBXJVAOp7aM9127CmznOPq/CNs
	9Tlcal0ZvYYMIxi3KqkciyCyHyo7cT6DOo+lZ96uleIQ4LIvQpepKKIACdC5hW9pJ5IHTIcaHsu
	1TWIICbjYbNj6gyYGYzETzLb28vK1UtWzRrKffK+R3Zpq0Wbr3fx3Oue/e5fdCn7xmq3JluutNK
	6EmwoxKZ0SfoR7WoTJjfNNes=
X-Received: by 2002:a17:907:6b86:b0:c41:944d:d2d2 with SMTP id
 a640c23a62f3a-c419f316ab5mr46769066b.30.1792174674034; Fri, 16 Oct 2026
 11:17:54 -0700 (PDT)
MIME-Version: 1.0
References: <20261014090821.227366-1-jiayuan.chen@linux.dev>
In-Reply-To: <20261014090821.227366-1-jiayuan.chen@linux.dev>
From: Kairui Song <ryncsn@gmail.com>
Date: Sat, 17 Oct 2026 02:17:17 +0800
X-Gm-Features: AclHuK-RW0wt5_KGT1K1een9-4BwXdt5AoxrfQKz3zIk5YkesZatKqP4zT5kViw
Message-ID: <CAMgjq7CT4srpTcAkStOV6zN8X2v4mPN7cRzA9B_eevFB4azvtg@mail.gmail.com>
Subject: Re: [PATCH mm-next] mm/swap: free swap cache folios the zap path gave
 up on
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: wu3twgyswumyca36rrxebkoctncfkqux
X-Rspam-User: 
X-Rspamd-Queue-Id: D0F30180006
X-Rspamd-Server: rspam10
X-HE-Tag: 1792174675-911073
X-HE-Meta: U2FsdGVkX19Lhzimu3C9x846D7PQ204PJo7fH9eBKF6qdBcMuHtt3ajTLmpr1hII/5t7scc1xSZOsQOUp9CexZ9b5y5LxRP8BA0OmCcn+WkTt6KcibA9tE4wHO6YwUoJjsP7a6GRLOfJUjnes4ugtPd9buUmEF/Gw6N5KK3VdiXlenJ5P1GMBGmDzyJSxyq2uiCc1pOJT7Q+myQvvMO/TH1USTqkVlJJrRs1K8noyT5jkzvhgpnZUXiqKjydeGfFzRMBooWRPnaYcv1hghfIEPPO+q6H+He+WZu+rS7aERpu0Jpzft58XektMa84Ukc2hpBENbq/B3zfHLeDOR/jWec+3+pFA6yTgVwl1HHWGb3ysZ7bxbm/qDP4I9sTL26iU7pj1vDo8heiLzlVGx5NVYjehwEuKu9rLlGyiVwUXaRmez8+h55PQIhLcZRe2z3aUzaBn0ouSwCM2tIB3os/znIJK/4f2TZippWr2ZqrJxlunkdj2xMvhmBaFYxyXV+DOItqDrlnb6tVx3zyjPDR9JECYoC6xM0ZhcUyi52uzl3OcByHcIFDHab/hArZb0PeYOfj8bAW1l5DmobYWao4S9qIrsQLPSIeUDbtfHW0AjDScvoqavDGH1tKZ7TAazFLazSiWIdnBDUff2+ef3MfIMKx6lwAet9bpj1wVv2Bc+HXlgSsHPNIfxGPYFvNjQDlkig5mXVmE+6bmBoHhonbCQLE4wZloymUVYF5lsQ5n1YRsFsKenHH7nTbfqEw9cr5J98/N/YWVWZulODNLSDp0J6CeLMFS/XValjPW6WdbJxNLmJHl2VW0iq1MngvXNSXBROoVZm55vyZN9rht3xhrtEy1j+NxylgvSLsrWfVxUbrI3MZeOv5Nnhn4vlGmS2CkYShYXiTHBpfXmqDOH6dMlW04yvnOHtkq+Qr6Bhfl9pgFibyadTA5kijebYyxgsWllctObaLXSxwwgQRgWG
 30y/uNeG
 sOdNvBUdY08N9t2tU1fujbdvaTkbRUdTBu80xpbyvz55qPOiNPIAkdc7LY26UMKzQ1tERVUGyEh/CA1TjjxmLpT+WSErr2TAnMGdyLLrrY4L7I7uKQh456BCJB1IQLFSiGO/OAT3cewQiNvSrGAx/JDE94ziCnQO7io3u4GvsgdpxksdxcJEk/TEbNBvt/H3CsifGaF2ZRZHN1m4dwfQU1q/guheV15kWLHVL2+HIkVVLMlMnWS0bIal5FxRZaQngXyJ/OvP6rQOnVy8UFYvZzNOh9VR10bmB98vz1zwaEWI9P3sopuzykfVv7B4/MbHypmtYC4nOY72EeN0tFW1w/0omRtz7xEp7LGbTCxLoUBZYUmuMEItwtL93G+bzVAiCmaN04ZGs3HuoPwFSM20hwE/W5YW2dvjn1qO31XuVNyxNyRRFBb5ns6lELKxQ9JlrM6U/S4L6AdI0P4zaWGQm5mvAoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 5:10=E2=80=AFPM Jiayuan Chen <jiayuan.chen@linux.de=
v> wrote:
>
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
>
> On our production hosts we saw swap cache only pages keep growing for day=
s:
> on a box with a 500 GiB swap partition, 250 GiB of RAM and 250 GiB of
> swap slots were held by folios that no process mapped any more, charged
> to cgroups whose workloads had long exited. The only way to get them
> back was swapoff, and with other services actively swapping on the
> same host that is not an option.
>
> Such a slot has swap count 0 and an unmapped folio pinned in the swap
> cache, left there after a process exited or did MADV_DONTNEED. No page
> table holds its swap entry any more, so nothing comes back for the
> slot; LRU reclaim drops it eventually, and the allocator only reclaims
> such slots once swap is half full. The growth stopped exactly there:
> at 50% of the device, where vm_swap_full() becomes true.
>
> The race is readahead against a zap in a neighbouring thread. Readahead
> works on virtual addresses, so a fault at the end of thread A's range
> pulls in the entries at the start of thread B's range:
>
>   thread A                               thread B
>   do_swap_page()
>     swap_vma_readahead()
>       swap_cache_read_folio(B's entry)
>         folio locked, added to cache
>         swap_read_folio()                MADV_DONTNEED
>           zswap_load() / bio in flight     zap_nonpresent_ptes()
>           .                                  swap_put_entries_cluster()
>           .                                    swap count 1 -> 0
>           .                                    __try_to_reclaim_swap()
>           .                                      folio_trylock() fails
>           .                                      gives up
>           folio_unlock()
>       folio_put()
>   -> slot: swap count 0, folio in swap cache, not mapped, never freed
>
> The lock is one reason it gives up. The other is writeback: with a block
> device as backing store, B's own PAGEOUT leaves the folio in the swap
> cache under writeback, and when the DONTNEED comes __try_to_reclaim_swap(=
)
> gets the lock but folio_swapcache_freeable() refuses. The write
> completes, nobody frees the slot. The present-PTE side has the same two
> outcomes through free_swap_cache().
>
> Options considered:
>
> 1. Fix it on the readahead side: after the read, check the swap count
>    and free the slot. Covers the lock, not writeback, and the
>    asynchronous read path unlocks in the bio completion where the slot
>    cannot be freed. Two places to patch, neither clean.
> 2. swapoff/swapon clears it, as does memory.reclaim on the right cgroup.
>    That is a workaround, not a fix.
> 3. Have the side that gives up come back later. This patch.
>
> The zap runs under the PTL and the fault path takes the folio lock
> before the PTL, so waiting there is out; a worker has to do it. On a
> lost trylock or a writeback refusal under TTRS_UNMAPPED,
> __try_to_reclaim_swap() schedules si->sweep_work. The worker walks the
> in-use clusters and, for every slot with swap count 0 whose folio is
> unmapped, calls __try_to_reclaim_swap() with TTRS_WAIT, which takes the
> folio lock and waits for writeback instead of giving up.
> free_swap_cache() now calls __try_to_reclaim_swap() as well, so both
> paths give up, and wake the worker, in the same place.
>
> For now the worker scans every in-use cluster of the device; marking
> the clusters that need it can reduce that later.
>
> Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> ---
>  include/linux/swap.h |   1 +
>  mm/swap.h            |   1 +
>  mm/swap_state.c      |   9 ++--
>  mm/swapfile.c        | 101 ++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 104 insertions(+), 8 deletions(-)
>
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 4f686709d71f..5777f10e9aa4 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -267,6 +267,7 @@ struct swap_info_struct {
>                                          */
>         struct work_struct discard_work; /* discard worker */
>         struct work_struct reclaim_work; /* reclaim worker */
> +       struct work_struct sweep_work;  /* frees swap cache only slots a =
zap gave up on */
>         struct list_head discard_clusters; /* discard clusters list */
>         struct plist_node avail_list;   /* entry in swap_avail_head */
>         const struct swap_ops *ops;
> diff --git a/mm/swap.h b/mm/swap.h
> index d5bf21f517dc..f62f36c0ce5c 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -309,6 +309,7 @@ static inline bool folio_matches_swap_entry(const str=
uct folio *folio,
>   * - See the comment of get_swap_device() for more complex usage.
>   */
>  bool swap_cache_has_folio(swp_entry_t entry);
> +void swap_reclaim_entry(swp_entry_t entry);
>  struct folio *swap_cache_get_folio(swp_entry_t entry);
>  void *swap_cache_get_shadow(swp_entry_t entry);
>  void swap_cache_del_folio(struct folio *folio);
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index ebef568cd62e..99708f149b25 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -598,16 +598,13 @@ void swap_writeback_dropbehind_folio(struct folio *=
folio)
>   *
>   * Its ok to check the swapcache flag without the folio lock
>   * here because we are going to recheck again inside
> - * folio_free_swap() _with_ the lock.
> + * __try_to_reclaim_swap() _with_ the lock.
>   *                                     - Marcelo
>   */
>  void free_swap_cache(struct folio *folio)
>  {
> -       if (folio_test_swapcache(folio) && !folio_mapped(folio) &&
> -           folio_trylock(folio)) {
> -               folio_free_swap(folio);
> -               folio_unlock(folio);
> -       }
> +       if (folio_test_swapcache(folio) && !folio_mapped(folio))
> +               swap_reclaim_entry(folio->swap);

One problem here, if folio is not locked, you might read garbage from
folio->swap.

>  }
>
>  /*
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c3288910b3e3..ee29085152fe 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -172,6 +172,8 @@ static long swap_usage_in_pages(struct swap_info_stru=
ct *si)
>  #define TTRS_UNMAPPED          0x2
>  /* Reclaim the swap entry if swap is getting full */
>  #define TTRS_FULL              0x4
> +/* May sleep: wait for the folio lock and for writeback instead of givin=
g up */
> +#define TTRS_WAIT              0x8
>
>  static bool swap_only_has_cache(struct swap_cluster_info *ci,
>                                 unsigned long offset, int nr_pages)
> @@ -217,9 +219,19 @@ static int __try_to_reclaim_swap(struct swap_info_st=
ruct *si,
>          * avoiding deadlock. This is a special case and you should
>          * use folio_free_swap() with explicit folio_lock() in usual
>          * operations.
> +        *
> +        * The zap path (TTRS_UNMAPPED) is the one caller for which givin=
g
> +        * up means the slot is never looked at again: it stays allocated
> +        * with count 0 and an unmapped folio pinned in the swap cache. L=
et
> +        * the sweep worker, which can wait, come back for it.
>          */
> -       if (!folio_trylock(folio))
> +       if (flags & TTRS_WAIT) {
> +               folio_lock(folio);
> +       } else if (!folio_trylock(folio)) {
> +               if (flags & TTRS_UNMAPPED)
> +                       schedule_work(&si->sweep_work);
>                 goto out;
> +       }
>
>         /*
>          * Offset could point to the middle of a large folio, or folio
> @@ -232,11 +244,20 @@ static int __try_to_reclaim_swap(struct swap_info_s=
truct *si,
>         }
>         offset =3D swp_offset(folio->swap);
>
> +       if (flags & TTRS_WAIT)
> +               folio_wait_writeback(folio);

You may merge this into the TTRS_WAIT check above?

> +
>         need_reclaim =3D ((flags & TTRS_ANYWAY) ||
>                         ((flags & TTRS_UNMAPPED) && !folio_mapped(folio))=
 ||
>                         ((flags & TTRS_FULL) && mem_cgroup_swap_full(foli=
o)));
> -       if (!need_reclaim || !folio_swapcache_freeable(folio))
> +       if (!need_reclaim)
> +               goto out_unlock;
> +       if (!folio_swapcache_freeable(folio)) {
> +               /* Same for a folio the zap caught under writeback. */
> +               if ((flags & TTRS_UNMAPPED) && folio_test_writeback(folio=
))
> +                       schedule_work(&si->sweep_work);
>                 goto out_unlock;
> +       }
>
>         /*
>          * It's safe to delete the folio from swap cache only if the foli=
o
> @@ -1099,6 +1120,80 @@ static void swap_reclaim_work(struct work_struct *=
work)
>         swap_reclaim_full_clusters(si, true);
>  }
>
> +/*
> + * Free the slots a zap could not take back: swap cache only, count 0, f=
olio
> + * not mapped. The zap runs under the PTL, so when the folio was locked =
(a
> + * readahead or an asynchronous swap-in still reading into it) or under
> + * writeback, __try_to_reclaim_swap() had to give up and scheduled us. S=
uch
> + * a slot is reachable by nobody but LRU reclaim: no page table holds it=
s
> + * entry, and the allocator skips it until swap is half full. Here we ca=
n
> + * wait for the lock and the writeback.
> + */
> +static void swap_sweep_work(struct work_struct *work)
> +{
> +       struct swap_info_struct *si;
> +       struct swap_cluster_info *ci;
> +       unsigned long offset, end, swp_tb;
> +       unsigned long nr_clusters;
> +       int nr_reclaim;
> +
> +       si =3D container_of(work, struct swap_info_struct, sweep_work);
> +       nr_clusters =3D DIV_ROUND_UP(si->max, SWAPFILE_CLUSTER);
> +
> +       for (unsigned long i =3D 0; i < nr_clusters; i++) {
> +               ci =3D si->cluster_info + i;
> +               offset =3D i * SWAPFILE_CLUSTER;
> +               end =3D min(si->max, offset + SWAPFILE_CLUSTER);

IIUC scanning the whole device for one pending folio reclaim doesnt' look g=
ood..

