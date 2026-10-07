Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 733BECA5FFF
	for <linux-mm@archiver.kernel.org>; Wed,  7 Oct 2026 21:37:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E60C16B0092; Wed,  7 Oct 2026 17:37:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E11FE6B0093; Wed,  7 Oct 2026 17:37:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D288D6B0095; Wed,  7 Oct 2026 17:37:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A27016B0092
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 17:37:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B8C5A7505
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:37:24 +0000 (UTC)
X-FDA: 85297141608.15.EEAA8E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0C190140006
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:37:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwuIbypT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791409042;
	b=ZiCmQGV+9AH2IUfqNSAt+nBEhIWq81WihBcKbM7hYuHzpMLSvXvTcJ3CThS75CRsAzKX+q
	3JnBpIO6IjCmhfej+VG3w/O6V3Lio9mN7/jSLbjc9Ai53nWjXbSjy0q2tonopkOefVgTcj
	YmjI26b3WZoJInUEcJZEraNhQp8XoUk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FwuIbypT;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791409042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UOE7Jbnn9tojgnUkTH49vAYggvweAK9gFAV1451BkhA=;
	b=0YN8sGpziOx4DsQ9ebXgl56eqRRFrjfuWRRz1SADeNdtxSHTBqTSnCPYwTnux25qGCluG6
	4S4iAUoBAL3tSmmMdpOuaUr9izfxRS3V37fEicWx0P9BQ6cHQ+4yH2fLqndB388sWAP1/V
	R+QAqb0lAlQU7h9ETFN5biJ9+ft6cVA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17744447D7
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:37:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4B571F008AB
	for <linux-mm@kvack.org>; Wed,  7 Oct 2026 21:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791409040;
	bh=UOE7Jbnn9tojgnUkTH49vAYggvweAK9gFAV1451BkhA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=FwuIbypT1BD/E3bQ/A22baQ11LqAHE8WYqLDxCPosy2949kKAu/bw1buAI7b5GPU2
	 O+Su7qRvUn9PAJdgcqfqIV3SeENwMHDK2V/zrVBpDvB9sT+BDp22WDHwO2vSGsQAQ8
	 ZblVHi+M+9o+lS7WbFHqWIQXxW73omtPaAPXK5TCh6YUPi3e2RtXfQTfpY0VHgrg3r
	 bkKa+/2PG8c0V4FBsHYTnnuB0wqb0IzTsxknu1rLwwo/y9uDpX7yp+j99QTB7o/fx/
	 gHzJB3BVdKL5/Bo7++cMoPs8r1FWmEifXau1V0VrJFOYih89LPTh2RhT9dpbizUkbt
	 nevyyQtHrM8Ow==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c2e62319cfaso465813566b.2
        for <linux-mm@kvack.org>; Wed, 07 Oct 2026 14:37:20 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByeIcAthrs+3XhWaRXCq58PIlCgZFt5QdW/e7/px9asiFgW8+TL0kLzgr7Gj7Z88S3QqJH8RaFiWg==@kvack.org
X-Gm-Message-State: AFuF++kTHWt0XUQ4eNMP1jLEUY3Ewdqxl/qXAdqdcDzrhAX57ECo+ceD
	Nk2+TOw+mFEDZyQrxbWkIce0UUT9DqSDaKpqquHhrYR6CfJ8WaOF+3rK1q/lWK0YyBodcREKSN9
	V5piOkM4Ua2vkrgp+BNgcRoTLtnuSmPQ=
X-Received: by 2002:a17:907:6eab:b0:c2a:fcb7:62f2 with SMTP id
 a640c23a62f3a-c317bdee527mr356663766b.19.1791409039712; Wed, 07 Oct 2026
 14:37:19 -0700 (PDT)
MIME-Version: 1.0
References: <20261007153915.53429-1-alex@ghiti.fr>
In-Reply-To: <20261007153915.53429-1-alex@ghiti.fr>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 7 Oct 2026 14:37:07 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMHKmAQT8WBAd+kkQEjETVvyHhfbESzKHpXXPQJUB9nVw@mail.gmail.com>
X-Gm-Features: AclHuK9UMP0A0o5RKveu-045r1R_Bso6sJPJj4MLUsXdKtvy9A7Qw5U_iJnA5BA
Message-ID: <CAO9r8zMHKmAQT8WBAd+kkQEjETVvyHhfbESzKHpXXPQJUB9nVw@mail.gmail.com>
Subject: Re: [PATCH v3] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>, Kairui Song <kasong@tencent.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, nphamcs@gmail.com, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, ryncsn@gmail.com, chrisl@kernel.org, baohua@kernel.org, 
	usama.arif@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6mn3a7cocan8akp6hbf4rhxdkiuxsrmt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0C190140006
X-HE-Tag: 1791409041-809544
X-HE-Meta: U2FsdGVkX19jzM3wvEy/ZQICYAYrslnmrr2iq63RDPnMHIlUAmVVAY1iL8UlZcf7xHECei9IFThonHsUv67Da1KvGVNNK/jtjfJBpvyiC9vCefh0PpnW9mH1nXqXM4MTm86A5p1bgWou+I5hJ2Ton4tI5Nk8tdVlz07tLRS9/rWAMbJzYPpzev0eme5osJJ/gY5bzyx2MRLPBBDzsskxbg46+XEKuU/CgNGBQ6xm5JzmmRTJA0ecaZiNtyMoEP0jHt2uQsLks4cS7kF0gyEqeSZDNhOnX2SKyNO5+uvjGhgdsd8rQOs066RpcJb13FtjOyIay7kS1woJ63tF6R5qxtUJKoey5qgqv9wkloiCfmVV05GX1tpz1ETU+I58b2sIEjCf6XIKbVZL6qyRAYUA/Cq7WUwsznTH7rLIr8Ml/bl1xdG7cDkWuXKyblvaf3EF2C6t1xthWIIMRxk2oq5qX+CVNY+2MHe2TkS/kut9VxljCtQVbRDqDF7vgS748UZK2iUYiZ1tHoXcoVkh2H6zTdao+TFyhDq2IVpbWh/eluMSMbt2KFViOUdVWig/j7yfbuxLsWKsFEXWC7jeH8frJjhp742JiNC4EP3lK1fuFp3W5BZds6ov2O6VI5n4if/SiJgd6ExNTzojHHkpe3aLyQJ6BPInbngdTlFAKtIgkWXGd5zN2iyGG517FHnuPL6RFuoj5/dp/q2aYPfBpQUzXwEca3dUfG6YzIpx6KPOHb+LaU34OmDaObYnZmggUhIr/cCZeIHmTjO3xhiOv7kLzCThe6V0MRA4Vxc8sFKPonG7EX0IBjuUvrR+b7FnagLyR2FXLFQsfGQAIwWpN475OtGm/urimvaYWOyZss3rFvOi4RR+SqckRIw0MRpZeAuZJzoXZycJu66ch/oL/BQMDEqQL2RXpLfpctUBzGiCpnF5le8t6ZXE9fRBNekKLwaMlt9eLv8sc6CafIbAWEA
 ceH24FPN
 InfSmc9fItgobu6yQ88uCljP0wpqTstD1YvbZBd3vWdFySu75tL8J/8F6vDHKn7V7GTjzPpUvmNFTSL+MH1ZXNHFDXWuCrJ3JhJTrWYLAQ5+7XmkAJ6c6+1UMZej5CaZlSL4wv7xWbYqkVbGZirNCvwhFlNDoXeYZ3tm1T4/xmvmhewMuCESrF4xoYHpP3/zfroZsl35Sv6XjubK1eP8r3eUx2adJh2CHnuYqCvHaVYqakBlcPD7Myosvj7P8QzZ21HtANFDRtbdUNVe+1+c00DO7jYohyxaaGibQUTuvS12T1UENnWWRnQVierjZDMoIunW8SoWqF7+JmbAg/8i9SK/FCMEb/IiuesuoAHKBKRW0RkjAdG7V++BeU4x+FQGaty9pz/GGM4jlnws=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 7, 2026 at 8:39=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> Similar gains were observed on an AMD EPYC 7D13 host.
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.

No objection here, I am just thinking about Kairui's LPC presentation
about how compressed swap can (in theory at least) still benefit from
readahead: https://lpc.events/event/20/contributions/2421/attachments/2116/=
4689/Better%20Anon%20(Swap)%20Readahead%20(2).pdf.

Seems like a big portion of the fault cost is still outside of
decompression and can benefit from readahead, but that isn't the case
today. I assume any future improvements to readahead and re-enabling
for zram would also cover zswap?

>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> ---
> Changes in v3:
> - Go back to the RFC's single patch: readahead windows that mix zswap
>   and disk entries will be dealt with later, the priority is to merge the
>   zswap readahead bypass
> - Move the check into a swap helper, swap_entry_synchronous(), instead
>   of open-coding it in do_swap_page() (David)
> - Bail out early when zswap was never enabled or the tree is empty, so
>   disk-only systems pay a static branch (Kairui, Nhat)
> - Reuse zswap_is_present() rather than adding zswap_present_test()
>   (Yosry)
> - Rebase on mm-new
>
> Changes in v2:
> - Keep readahead, but overlap the decompression of zswap neighbours with
>   the disk I/O of the window, and bypass it when the target needs no
>   disk I/O (Yosry, Nhat, Barry)
>
> v2: https://lore.kernel.org/all/20260722163536.773166-1-alex@ghiti.fr/
> RFC: https://lore.kernel.org/all/20260624075700.751467-1-alex@ghiti.fr/
>
>  include/linux/zswap.h |  6 ++++++
>  mm/memory.c           |  4 ++--
>  mm/swap.h             | 25 +++++++++++++++++++++++++
>  mm/zswap.c            |  5 ++++-
>  4 files changed, 37 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/zswap.h b/include/linux/zswap.h
> index df6cafbe95dc..94746fb71bb6 100644
> --- a/include/linux/zswap.h
> +++ b/include/linux/zswap.h
> @@ -35,6 +35,7 @@ void zswap_lruvec_state_init(struct lruvec *lruvec);
>  void zswap_folio_swapin(struct folio *folio);
>  bool zswap_is_enabled(void);
>  bool zswap_never_enabled(void);
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr);
>  #else
>
>  struct zswap_lruvec_state {};
> @@ -73,6 +74,11 @@ static inline bool zswap_never_enabled(void)
>         return true;
>  }
>
> +static inline bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +{
> +       return false;
> +}
> +
>  #endif
>
>  #endif /* _LINUX_ZSWAP_H */
> diff --git a/mm/memory.c b/mm/memory.c
> index 330cde31bf8b..396bc71a265f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5030,8 +5030,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (folio)
>                 swap_update_readahead(folio, vma, vmf->address);
>         if (!folio) {
> -               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es */
> -               if (data_race(si->flags & SWP_SYNCHRONOUS_IO))
> +               /* Swapin bypasses readahead for SWP_SYNCHRONOUS_IO devic=
es and zswap */
> +               if (swap_entry_synchronous(si, entry))
>                         folio =3D swapin_sync(entry, GFP_HIGHUSER_MOVABLE=
,
>                                             thp_swapin_suitable_orders(vm=
f) | BIT(0),
>                                             vmf, NULL, 0);
> diff --git a/mm/swap.h b/mm/swap.h
> index d5bf21f517dc..b8181bd056ee 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -94,6 +94,7 @@ static inline int mem_cgroup_swappiness(const struct me=
m_cgroup *memcg)
>
>  #ifdef CONFIG_SWAP
>  #include <linux/swapops.h> /* for swp_offset */
> +#include <linux/zswap.h> /* for zswap_is_present */
>  #include <linux/blk_types.h> /* for bio_end_io_t */
>
>  static inline unsigned int swp_cluster_offset(swp_entry_t entry)
> @@ -336,6 +337,24 @@ struct folio *swapin_sync(swp_entry_t entry, gfp_t f=
lag, unsigned long orders,
>  void swap_update_readahead(struct folio *folio, struct vm_area_struct *v=
ma,
>                            unsigned long addr);
>
> +/**
> + * swap_entry_synchronous - check if @entry is read synchronously
> + * @si: the swap device of @entry
> + * @entry: the swap entry
> + *
> + * SWP_SYNCHRONOUS_IO devices and zswap complete a read in the faulting
> + * context, so swap readahead has no asynchronous I/O to overlap.
> + *
> + * Context: The caller must hold a reference on @si. The answer is a hin=
t: the
> + * entry can be written back from zswap or freed concurrently.
> + */
> +static inline bool swap_entry_synchronous(struct swap_info_struct *si,
> +                                         swp_entry_t entry)
> +{
> +       return data_race(si->flags & SWP_SYNCHRONOUS_IO) ||
> +              zswap_is_present(entry, 1);
> +}
> +
>  #else /* CONFIG_SWAP */
>
>  static inline struct swap_cluster_info *swap_cluster_get_and_lock(
> @@ -423,6 +442,12 @@ static inline void swap_update_readahead(struct foli=
o *folio,
>  {
>  }
>
> +static inline bool swap_entry_synchronous(struct swap_info_struct *si,
> +                                         swp_entry_t entry)
> +{
> +       return false;
> +}
> +
>  static inline int swap_writeout(struct swap_io_ctx *ctx, struct folio *f=
olio)
>  {
>         return 0;
> diff --git a/mm/zswap.c b/mm/zswap.c
> index eb3494491410..1dcf77d5edae 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -1605,12 +1605,15 @@ bool zswap_store(struct folio *folio)
>   * change under it.
>   * Return: true if at least one slot in the range is in zswap.
>   */
> -static bool zswap_is_present(swp_entry_t entry, unsigned int nr)
> +bool zswap_is_present(swp_entry_t entry, unsigned int nr)
>  {
>         pgoff_t offset =3D swp_offset(entry);
>         struct xarray *tree =3D swap_zswap_tree(entry);
>         unsigned long index =3D offset;
>
> +       if (zswap_never_enabled() || xa_empty(tree))
> +               return false;
> +
>         /*
>          * A pinned range is at most SWAPFILE_CLUSTER slots and is aligne=
d to
>          * its own size, so one tree covers all of it and a single lookup=
 is
> --
> 2.53.0-Meta
>
>

