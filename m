Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 447F1606A339
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 16:05:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LooVC/Kv
Received: by kanga.kvack.org (Postfix)
	id 64FB66B03AE; Fri, 23 Oct 2026 12:05:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DA3C6B03AF; Fri, 23 Oct 2026 12:05:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47A3E6B03B0; Fri, 23 Oct 2026 12:05:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 19ADB6B03AE
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 12:05:49 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB6721C1EA5
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:05:48 +0000 (UTC)
X-FDA: 85354366776.07.2B5F533
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf11.hostedemail.com (Postfix) with ESMTP id AE30F40010
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 16:05:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="LooVC/Kv";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792771546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BGTxRD5D7n/UMnlYai6UFr6wWSckBQB5pNIfzliMwQY=;
	b=n5HKsiHPsqIFawgc92tZ1ic23EHsxIVM1LkuY2z9yQbe/SNjhGG30ZN9L9AkoqsMaqKqKI
	WcRmLbRd18xa8dkQVYvpIAMQD+0nshkqxmbRHtPaUV0E9Xch3c1ECqAkp9nARmxQEeg6on
	0+R7JXl55uYH8o3MXfMHJxtWS1TSDUg=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="LooVC/Kv";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=nphamcs@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792771546;
	b=GasoiwPzcY+fTFM5uGWdm/eXW9BQM6fAPTnbIBnJeEEQ335tRaQnhwWoq5KOp4tte6ZAuO
	bAMpsQWv0QwAIQ4fz1GnOV7D/geK/rEmBoSHP/mIvdo/BVvGZy5oQykE4izBpnPqhy4r7h
	SLM/uwXHKPT7SOMa3b1M5ifI6OxX0cM=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-48c4d99c32bso720470f8f.1
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 09:05:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792771545; cv=none;
        d=google.com; s=arc-20260327;
        b=kN7dNthre2eYRuRAxO/6SfhvmgGvKYQE3PIYshMYe02t3c1NNPaVvpdAATn/xS8kbv
         fBcFzw+4ALHovXhbAhNToE3PzvHN2vx7ujN0R8XH0T9jt1BL06sEs2c8l48U33X8NjlF
         0GXqSW920Onj7bxhh1rLNQN99ygxFMxBIggXPFPenV3kb+pMz3wH4VyXI+Cp3oyydaUC
         iimFAlo40zwyPrADHNwzTrT+pMWOS5cq7L3R8onuvbgBHY1TngL9cQi9sB+LzTamjMyd
         nHZ8WY8rZv5mwpZT2GiCWRM03uHEO5TZ/e7LLamHZ9v4TIPL0ADa/4ewTnBe1XhgeEfI
         H9Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BGTxRD5D7n/UMnlYai6UFr6wWSckBQB5pNIfzliMwQY=;
        fh=4HnaQEtpXzZwLOB1Atyi+2gDiFo+5rfZQXYQru+v6t0=;
        b=MLJZiy6vSs48sUeMOzEMF4dkU0VyrKolJgKtPcxcHPfS0Mgw6N+zW69aIXuMWJkZlo
         OWI108xy3ZEYb2SGho3AY+TRZwWxEp6rHjyhO0nLdRhdEHAxw31Culxm8U6MkWVhIUZI
         mJyOR5C2GBPdKh/FNTPFz6OzYG1yDISxp7Jgl9tY2YNrh0ztIj1Bgpsz0SSEaJRbkPpZ
         h7mCAPA2E0uhckcuf/CRkY7cI/MRqKPGzrc/8dZD9hshbrm6lLWeZnQF4vYE2UCsLDt9
         nAwVdzDuUhlkp/vkV/zvMQMQfWu90okxjcXXXli4EFVYbdVSzn3ywxpkqDZSNFdpokah
         6cJQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792771545; x=1793376345; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BGTxRD5D7n/UMnlYai6UFr6wWSckBQB5pNIfzliMwQY=;
        b=LooVC/KvRzkyO/7JuuktvwzyDY/z5UTq5S1hbxwKm7tB+KtFaw9rqkFT1KaN0eu1+b
         9Sc07DYnJkah2Grrx1lG8PewYAK/Z7EXD7mMvzxd/2wpdrVuGuEKITZez9zyEtJ8am+r
         BVl9OCrxObQSral5eKtY1auDqICRffiiuG4QVcIPg5471qyh8SATBHfA91RNfZnTO3My
         BFKpSlzVVFy1lxhASDoYauPuC6GI7OxYDBcSqcfGqtKIJ8PMxNiEgmxVhXcm09lk2zK0
         R6KxyN9vQKxvQg0PkxBJgqEP801n0mUFut7OyvVxCG/3yzNiBiqltzuJ1K3T/MJnfqdu
         Q7Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792771545; x=1793376345;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=BGTxRD5D7n/UMnlYai6UFr6wWSckBQB5pNIfzliMwQY=;
        b=LL+lmSP2B+zbR07/FyEEJy2GGJ5tooyO04HypdMUmpjKixTkk6heU4UdjDTN58lVxD
         MInxy2I5a1Dh9L3spJWfB09NpofMXlrFSxkQmqN6AtCwikYuTGOfgO56wPKX1kXIDOPO
         R0B9ffMmaF045jBJNmTMC1jGeqZXDkbRsF6G+qX0tX5tc/v6DVqYIlmcpAf72/OGD1hC
         53vc8hlTA7lex1Qahz5arbfpuXWBbEBJiI9PMNpTVHqlDGjVW0UemUI3/Ja3FPcSj7hf
         7qcxLdsj9p1/+gUH3eKkExVldORzyxHjocbYvgjmTqy4kd4w4MLHw5ovdZW8vqUtv4oX
         775A==
X-Forwarded-Encrypted: i=1; AKwUvBwaqZlqNrpZDi7kq2MQ5DZV4PjP2qZVCSVrk20pk0TkOIO3X55egiCIGGH584AR73IlgywxHA1I0g==@kvack.org
X-Gm-Message-State: AFq9FYJ4FeE92EnN5gat6TD/es2KjB9v7PtXkG1T3SEegdzx/l0jHHOK
	+d1l7Cipju386Mlt6ZhxNVmH1NnHg8N9yll6FuhhcobC1N0VKSL+IORA59FoF3e0toyLJ7cC1+R
	rGaj+LgyAf4/dcV6on+M+FupEBF2lhA8=
X-Gm-Gg: AYBFou0LSWfD/KkVnjFCZEWn6KuU0ZduUpw39lMgLNcw/OfUEB28av9IWNarO7mEWMW
	ifiBhqU5Dho4xoHlwhDaNRg/NIO43Ir2ypAc6Vpj5aIPzTBnbyeSBFPfiw4FQayNpr9aMwMRnC/
	d5uaLOvXXrgusJhC75s/eMITWWc7CFjxHhrcY3C/ga3f8a43BLBLzNh5iC6no6W2xGHYRUeQvnX
	NRH+N6v02e8TxL5cP9es9FVxfhwalLMvaeACZCNGj8gfkXxqF3ICALEzIvjz/JRvlKDcPtTZ1sR
	4SpV66zk6qGofDiCMCFAuy8/SEkd0u8/jHGhwF0msWga36bd091h+c0SopbnNsRsjAoxSBjgJ+U
	Ilxk1sgFIMDxeW44ccZ0MRcsGKPISGpfrsctWzrS5EH6e7MTjjjW6n6L/VSbH7Fa+mTjAsKzN8k
	UL51vp3IHbac7yxS6PkA2/Kjn4O2vqLCwDDwINKmY2uAWImGLJ9jmY7eUlLhwqDxsDaav4RmuXz
	w==
X-Received: by 2002:a05:6000:299c:10b0:48e:d88:55f4 with SMTP id
 ffacd0b85a97d-48e3854f102mr3546739f8f.2.1792771544959; Fri, 23 Oct 2026
 09:05:44 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261022145615.2184343-1-alex@ghiti.fr> <20261022145615.2184343-2-alex@ghiti.fr>
In-Reply-To: <20261022145615.2184343-2-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 23 Oct 2026 09:05:33 -0700
X-Gm-Features: AclHuK8Er7cNvGHw3gthKFs78WWdDSGvrANMdGbGbK7ZYvQMhJEnhGeR8z5NV5g
Message-ID: <CAKEwX=NWVVXXU76H3V0DWsH=VDbPmGUHZXeaN1_vkz8kwJCxbw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/1] mm/swap: allocate contiguous swap slots for a
 reclaim batch
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AE30F40010
X-Rspam-User: 
X-Stat-Signature: u4gor4pbwhur33cgm11su1ta5i1aaeim
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792771546-863542
X-HE-Meta: U2FsdGVkX1+/2obRDG9G79yxqf5YsCrL0QiIJIuXNGNQfLa0RVOHOYIWdZTwPGYYRSj6gdEtLu1Rk0Xt5x+guYzaRMWpM0oKKUP6DsOAMartvkYafiGAp+BpjyiLSGjOWOfXcRTNwfhdZTBOrE9Vval6r5NF8gT0OoxHWH+372hnv4Ee61nzqiXRe4N4XR76yXp2pfx2Va2B8sId/4tGuhwBMynQcFpD45fsz6qwq2CCSZsEXvnf48selKeVpPeGr6jRFETdDHQvO1eBvM5EKD0bYJ1sIR7hV4F8l/6bpX1h0cHUNyWZVSvNZsXOWNISGHHuBiGCf0d121DloTmDu8A1WKahkYWA17jCaVJ9j3lNrp1uWS+lP1yZxHjKKDmxtlXuZUT68ceVr3vS1it+PxZkJmZTy8qzD7I9s4DL471G9y6XnSw47TqxNEwSRW8y2ZUyPWGpAITIEPkfnr6x+2hAlU20++sF7nH63V72FYlmwr1ckM1Iazn4bPru7XnKV8WsZC25NbFRua5I5gNRHTVmcNz96gfwZIuf3W0ztjSTTqeRHCVyo4c2I+g/DRARGvy01CBoMOLTYq02gDatZFd7/FMbeW6WwYCUzZTfqb6EROtyiXZOCT5TWOyCuCjwovNmFZ3NOko/m3ARi0TTEYosb3DLDLODPAv2nQ68Iy1rpMf7VS6dmc9ELsaDe9zPw4wQnsttnoKn0vnghSO/V4uidn2QHpta/B8hVNhW8TJhIARxOP9tH7kl1w1nO53z9m38TSKh5gNrvjwE9Xf3enR+otHBbDwNJQSKIsUCGsGgP8LWFCRn237SSQv9ELesa6Qb332ZyygKgMcf/6nOZNofkPoA9QBK9qAEGguakTyYe2I+jwtXDKBjMp/3Q4pGYtQbr9i+d9Gwt6SKJgXo4R/JK6OmRDTegTZ4QRlDCJr3RHhcb94jiKQUKXx4kmrJzlYAxMpM9UtO0emK0Io
 KzJdqCVG
 BCykpjxhrwW9Ygn7bosbha4y9F5Q9MxKG9xcYokrVFu4yuFpdGKD2+K6YahUvZAVNZ4byRyOcmRI3Z6coiTJdHzC3F4wZQGjHzHsTYuJNs60mksxDgNh78hEUg3YX+agiUiQjDzQ3yO0jQh3WabgdKF7FudSgjlbHCPQa91wKdm/olbZK5VoRai2jfUdAJdvriTUmQR19sFxTZg0cjBnh6G5TKNcEKuca4bdEAZXB4C5crQ3GMR8vtq+SDDgiY71gpJrnCoy97UVz3S1MWdFX4x1/GfvpkMFHzgd0t0tDluezXqL2DHAG8Xlkr7AMR4dNSFeI7nVDbYdyYhVVtwj97Ch9jwl26Ozqm//zNJBHj2exYKeRtl3HnthaTNauS1SlJkJAQ6QgzV4Aasx3kJdujcl5hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 22, 2026 at 7:57=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> Reclaim allocates swap slots one folio at a time and only then batches
> the writes, merging folios whose slots happen to be contiguous. Order-0
> allocations scan the nonfull clusters before taking a free cluster, so
> once frees have left holes in otherwise full clusters, a batch of LRU-
> adjacent folios is scattered over those holes and written with many
> small requests. Since swap slots are freed on exclusive write faults,
> this happens with any workload that rewrites swapped out memory.
>
> Before swapping out a batch, record how many pages of each small order
> need a slot, and make those allocations follow contiguous free slots,
> SWAP_CLUSTER_MAX at a time: in a nonfull cluster if one has them,
> otherwise in a free cluster. When neither has them, the rest of the
> batch fills the holes as before. Nothing is reserved.
>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

Thanks for looking into this! There are still workloads that benefit
more from disk swapping than compression swapping... We should make
the swap subsystem work for them.

I haven't read the code too closely, as it's an RFC meant to show the
general idea. So I'll just make some comments and ask some questions
about the idea:

>  static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
>                                          struct swap_cluster_info *ci,
>                                          struct folio *folio,
> @@ -1042,6 +1079,59 @@ static unsigned int alloc_swap_scan_list(struct sw=
ap_info_struct *si,
>         return found;
>  }
>
> +/* Larger folios already make large enough write requests on their own *=
/
> +#define SWAP_BATCH_MAX_ORDER   (ilog2(SWAP_CLUSTER_MAX) - 1)

Ah so we don't invoke this heuristics for folio larger than certain
orders? Makes sense.

> +
> +static inline unsigned int swap_batch_contig(unsigned int left)
> +{
> +       return min_t(unsigned int, left, SWAP_CLUSTER_MAX);
> +}
> +
> +/*
> + * Like alloc_swap_scan_list(), but only allocate at the start of @nr_co=
ntig
> + * free slots. Order 0 clusters without them move to the frag list until=
 a
> + * slot is freed, larger orders stay nonfull as the folio may still fit.
> + */
> +static unsigned int alloc_swap_scan_list_contig(struct swap_info_struct =
*si,
> +                                               struct list_head *list,
> +                                               struct folio *folio,
> +                                               unsigned int nr_contig)
> +{
> +       unsigned int found =3D SWAP_ENTRY_INVALID, order =3D folio_order(=
folio);
> +       struct swap_cluster_info *ci;
> +       unsigned long start, offset;
> +       LIST_HEAD(skipped);
> +
> +       while ((ci =3D isolate_lock_cluster(si, list))) {
> +               start =3D cluster_offset(si, ci);
> +               offset =3D SWAP_ENTRY_INVALID;
> +               if (SWAPFILE_CLUSTER - ci->count >=3D nr_contig)
> +                       offset =3D cluster_find_free_contig(ci, start,
> +                                                         start + SWAPFIL=
E_CLUSTER,
> +                                                         1 << order, nr_=
contig);
> +               if (offset =3D=3D SWAP_ENTRY_INVALID) {
> +                       if (order)
> +                               move_cluster(si, ci, &skipped,
> +                                            CLUSTER_FLAG_NONFULL);
> +                       else
> +                               relocate_cluster(si, ci);
> +                       swap_cluster_unlock(ci);
> +                       continue;
> +               }
> +               found =3D alloc_swap_scan_cluster(si, ci, folio, offset);
> +               if (found)
> +                       break;
> +       }
> +
> +       if (!list_empty(&skipped)) {
> +               spin_lock(&si->lock);
> +               list_splice_tail(&skipped, list);
> +               spin_unlock(&si->lock);
> +       }
> +
> +       return found;
> +}
> +
>  static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool=
 force)
>  {
>         long to_scan =3D 1;
> @@ -1109,6 +1199,7 @@ static unsigned long cluster_alloc_swap_entry(struc=
t swap_info_struct *si,
>         struct swap_cluster_info *ci;
>         unsigned int order =3D likely(folio) ? folio_order(folio) : 0;
>         unsigned int offset =3D SWAP_ENTRY_INVALID, found =3D SWAP_ENTRY_=
INVALID;
> +       unsigned int left;
>
>         /*
>          * Swapfile is not block device so unable
> @@ -1129,7 +1220,14 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>                 if (cluster_is_usable(ci, order)) {
>                         if (cluster_is_empty(ci))
>                                 offset =3D cluster_offset(si, ci);
> -                       found =3D alloc_swap_scan_cluster(si, ci, folio, =
offset);
> +                       /* The batch's contiguous slots are used up */
> +                       if (likely(folio) &&
> +                           this_cpu_read(percpu_swap_cluster.batch_left[=
order]) &&
> +                           !cluster_slots_free(ci, offset, 1 << order))
> +                               swap_cluster_unlock(ci);
> +                       else
> +                               found =3D alloc_swap_scan_cluster(si, ci,=
 folio,
> +                                                               offset);
>                 } else {
>                         swap_cluster_unlock(ci);
>                 }
> @@ -1148,6 +1246,21 @@ static unsigned long cluster_alloc_swap_entry(stru=
ct swap_info_struct *si,
>                         goto done;
>         }
>
> +       /* Keep a reclaim batch on contiguous free slots, not in small ho=
les */
> +       left =3D likely(folio) ?
> +              this_cpu_read(percpu_swap_cluster.batch_left[order]) : 0;
> +       if (left && order < PMD_ORDER) {
> +               found =3D alloc_swap_scan_list_contig(si, &si->nonfull_cl=
usters[order],
> +                                                   folio, swap_batch_con=
tig(left));
> +               if (found)
> +                       goto done;
> +               found =3D alloc_swap_scan_list(si, &si->free_clusters, fo=
lio, false);
> +               if (found)
> +                       goto done;
> +               /* No contiguous slots left, allocate the rest of the bat=
ch as usual */
> +               this_cpu_write(percpu_swap_cluster.batch_left[order], 0);
> +       }
> +
>         if (order < PMD_ORDER) {
>                 found =3D alloc_swap_scan_list(si, &si->nonfull_clusters[=
order], folio, true);

So we prefer non-full clusters with contiguous slots, over free
clusters, over other nonfull clusters.

I think this part makes sense to me FWIW. We do skip fast path and go
for slow paths more often, so do make sure we're not paying with too
much lock contention, especially as the swapfile fils or get more
fragmented (which this patch series does nudge us towards). But FWIW,
we pretty much go back to the old behavior the moment we fail to find
contiguity for the first time in the batch, so I think we'll be
fine...?

>                 if (found)
> @@ -1390,7 +1503,15 @@ static bool swap_alloc_fast(struct folio *folio)
>         if (cluster_is_usable(ci, order)) {
>                 if (cluster_is_empty(ci))
>                         offset =3D cluster_offset(si, ci);
> -               alloc_swap_scan_cluster(si, ci, folio, offset);
> +               /* The batch's contiguous slots are used up */
> +               if (this_cpu_read(percpu_swap_cluster.batch_left[order]) =
&&
> +                   !cluster_slots_free(ci, offset, 1 << order)) {
> +                       swap_cluster_unlock(ci);
> +                       this_cpu_write(percpu_swap_cluster.offset[order],
> +                                      SWAP_ENTRY_INVALID);
> +               } else {
> +                       alloc_swap_scan_cluster(si, ci, folio, offset);
> +               }
>         } else {
>                 swap_cluster_unlock(ci);
>         }
> @@ -1729,6 +1850,86 @@ static int swap_dup_entries_cluster(struct swap_in=
fo_struct *si,
>         return err;
>  }
>
> +static void swap_alloc_prepare(unsigned int order, unsigned int nr)
> +{
> +       unsigned int nr_contig =3D swap_batch_contig(nr);
> +       struct swap_cluster_info *ci;
> +       struct swap_info_struct *si;
> +       unsigned long offset;
> +       bool keep =3D false;
> +
> +       local_lock(&percpu_swap_cluster.lock);
> +       if (nr <=3D (1 << order)) {
> +               this_cpu_write(percpu_swap_cluster.batch_left[order], 0);
> +               goto out;
> +       }
> +       this_cpu_write(percpu_swap_cluster.batch_left[order], nr);
> +
> +       /* Keep the cursor if enough free slots follow it */
> +       si =3D this_cpu_read(percpu_swap_cluster.si[order]);
> +       offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> +       if (si && offset && get_swap_device_info(si)) {
> +               ci =3D swap_cluster_lock(si, offset);
> +               if (cluster_is_usable(ci, order)) {
> +                       if (cluster_is_empty(ci))
> +                               offset =3D cluster_offset(si, ci);
> +                       keep =3D offset % SWAPFILE_CLUSTER + nr_contig <=
=3D
> +                              SWAPFILE_CLUSTER &&
> +                              cluster_find_free_contig(ci, offset,
> +                                                       offset + nr_conti=
g,
> +                                                       1 << order,
> +                                                       nr_contig) =3D=3D=
 offset;
> +               }
> +               swap_cluster_unlock(ci);
> +               put_swap_device(si);
> +       }
> +       if (!keep)
> +               this_cpu_write(percpu_swap_cluster.offset[order],
> +                              SWAP_ENTRY_INVALID);
> +out:
> +       local_unlock(&percpu_swap_cluster.lock);
> +}
> +
> +/**
> + * folio_alloc_swap_prepare - prepare swap allocation for a reclaim batc=
h
> + * @folios: list of folios reclaim is about to swap out
> + *
> + * Record how many pages of each small order the batch will swap out, so
> + * that their slots are allocated contiguously. Nothing is reserved.
> + */
> +void folio_alloc_swap_prepare(struct list_head *folios)
> +{
> +       unsigned int max_order =3D min(SWAP_BATCH_MAX_ORDER, SWAP_NR_ORDE=
RS - 1);
> +       unsigned int nr[SWAP_BATCH_MAX_ORDER + 1] =3D {};
> +       struct folio *folio;
> +       unsigned int order;
> +
> +       if (!total_swap_pages)
> +               return;
> +
> +       list_for_each_entry(folio, folios, lru) {
> +               if (!folio_test_swapbacked(folio) || folio_test_swapcache=
(folio))
> +                       continue;
> +               order =3D folio_order(folio);
> +               if (order <=3D max_order)
> +                       nr[order] +=3D 1 << order;
> +       }
> +
> +       for (order =3D 0; order <=3D max_order; order++)
> +               swap_alloc_prepare(order, nr[order]);
> +}
> +
> +/**
> + * folio_alloc_swap_split - account for a large folio split by reclaim
> + * @nr_pages: number of order-0 folios the split produced
> + */
> +void folio_alloc_swap_split(unsigned int nr_pages)
> +{
> +       local_lock(&percpu_swap_cluster.lock);
> +       this_cpu_add(percpu_swap_cluster.batch_left[0], nr_pages);
> +       local_unlock(&percpu_swap_cluster.lock);
> +}
> +
>  /**
>   * folio_alloc_swap - allocate swap space for a folio
>   * @folio: folio we want to move to swap
> @@ -1771,6 +1972,12 @@ int folio_alloc_swap(struct folio *folio)
>         local_lock(&percpu_swap_cluster.lock);
>         if (!swap_alloc_fast(folio))
>                 swap_alloc_slow(folio);
> +       if (folio_test_swapcache(folio)) {
> +               unsigned int left =3D this_cpu_read(percpu_swap_cluster.b=
atch_left[order]);
> +
> +               this_cpu_write(percpu_swap_cluster.batch_left[order],
> +                              left > size ? left - size : 0);
> +       }
>         local_unlock(&percpu_swap_cluster.lock);
>
>         if (!order && unlikely(!folio_test_swapcache(folio))) {
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index ea2d4c8d1890..86245036872c 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1175,6 +1175,8 @@ static unsigned int shrink_folio_list(struct list_h=
ead *folio_list,
>         memset(stat, 0, sizeof(*stat));
>         cond_resched();
>         do_demote_pass =3D can_demote(pgdat->node_id, sc, memcg);
> +       if (sc->gfp_mask & __GFP_IO)
> +               folio_alloc_swap_prepare(folio_list);
>

Some general questions:

1. How many pages in folio_list typically do get reclaimed? There can
be quite a few with references, which we rotate/promote, when we scan,
right? Would constantly overshooting the estimate create problem down
the line?

(This is one of the few places where indirection (vswap) would have
helped - we can collect a batch of pages after unmapping, then pass
them to the phys swap allocator (after checking zswappability, etc.).
Maybe we can solve it better after it's landed, and accept an
imperfect solution for now?)

2. Should we skip this heuristics for cgroups that enables zswap (and
maybe zram)? Contiguity matters less there... unless it help at
writeback time? Hard to say without experimentation - maybe you can do
the same check you did for your zswap writeback batching patch series?

