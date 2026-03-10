Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9FFFD88C3
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 22:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C5976B0088; Tue, 10 Mar 2026 18:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 375F86B0089; Tue, 10 Mar 2026 18:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24BA36B008A; Tue, 10 Mar 2026 18:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 12B356B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 18:08:00 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B65EBB7EEC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:07:59 +0000 (UTC)
X-FDA: 84531541878.18.4B41FFD
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id D355B1C0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 22:07:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRUJ+haf;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773180477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9kkeACht95noKyq8swG36CoWs2+8JaKZ99j3py+2/DM=;
	b=O6vj36z1jm3aM4RmGS2pWnToKmRH3dboBXf4mdh1iupoolCrkcszwNacaq3oxc+eUpgkiL
	vI84UpJaAcdahfeMRXoYjA++Yh3NwZ4BaCfgjSUpv9AtQksLLj5f48pY+iIyW+lz8ne2k1
	StPKY3bPmy8QzlzZ6cJ7A9aj3zcWUT8=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=MRUJ+haf;
	spf=pass (imf20.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773180477; a=rsa-sha256;
	cv=pass;
	b=a+xKE99aeLkXPdjub647EuzuWjE18dKqGD7t3uwZzner98TQhcNoA6NoPwbvsHjYT9gsWR
	U3YhH0INablaaKmOQFsnENK8UbxbZNN/xY8V4j779+FWBsrLN8MqJLm2sUqTPltupd38rz
	4h9CCybDo3KmbToCR+FZ/ScuPcntEMY=
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-899fa9610bbso154083546d6.0
        for <linux-mm@kvack.org>; Tue, 10 Mar 2026 15:07:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773180477; cv=none;
        d=google.com; s=arc-20240605;
        b=irptrhmh0SZSY2Ngf/czBPFafU6o9KMqVx4kYoQgw+zMB0rOZfalUlZd3yXldK4Rpj
         tpo/GJlCN/EpT6dYLuXw2EgDuET5GMGrD+ZiEMQBc46MQU1+3IPgZ2bpBVYp4/3CKbJ4
         FthCKNtuBb8BRie7hxP4Brva/NxiuTJmm28OKCvJJrWQb6t/nKisGC0G3qOvgF5pf36w
         1pVwoobKbFekEkXsXrwCkKjjpa9PfB0ERpjs7AfaPqRvup9nsjLdWe2WTEUW/YeF1phJ
         m4V3Oe35A387mXsTQ+Up6LP+JiRaShw6PWmB3jLt0d0LfWNiWEwylwLK0SCoaKuz5iwq
         su7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9kkeACht95noKyq8swG36CoWs2+8JaKZ99j3py+2/DM=;
        fh=KZC+l7m/JT3QCJDfj8hetfrQHBwq9hvAmdnacr2Z3VU=;
        b=SqkyjulgP/f3zLaHm0LUJs7C+ZJMwekHhTjb2Z3mcIR7bJaItgMzN8zNh859gLPG7c
         fXd+vVQCM7QW2AabGwhuRkWrBVX/QW222Li4+LCsQ9YtzTXHD6jORzP272r03xTF6mF8
         fjUs+NK5nSqJ73kh+qdHhXXGElu86b1q8KMKyaPbPf7e0vj+MCq5EsOc14WteCUytqFO
         DnWOj44tHgXDRxjrWgQWR60XwUrgzsuLt7HCXstUOIrPoq/GfX3ESBriNMmx19ZzWV6a
         HVLmSfJKpDG2carcdcOzD+56ukg9dNcXAyc+/a3Xsk6hvtJntxXnvepQmhPCiHzn7w5M
         HHtQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773180477; x=1773785277; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9kkeACht95noKyq8swG36CoWs2+8JaKZ99j3py+2/DM=;
        b=MRUJ+hafr9mO0a29kITzNMsgREjcx9M69n5/Igfxz0Sa6KabXp1nhK508kczv5D9MA
         wCphx8Shj7X3X7Ei8K2DdfR1VmqUE1R48ws/1kg/1i8GiISYpExqBoaNtGEc0NcpPIjG
         FdpzZgPIy8rqOwxr+9B9XEMqvzzASaL5KLYl1as9ueYEVEJU1mVFSi4Tyui5imSExkdd
         7xcLG72o9ptDxktqRVrlTbU6MRbtZUUdI61s3GXAism+EwbJ+0rzup6kQ7YO0Po/l4Gp
         wT7uQkA0fAm9/PF4RHQZYA0yQjB9SG0g9ZqDblu2K01rwvcmNoCDXlXCV263Dm+ppwPR
         PSaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773180477; x=1773785277;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9kkeACht95noKyq8swG36CoWs2+8JaKZ99j3py+2/DM=;
        b=U7RVI5LW66bl0kXvnMTzHqKOHizTrqcsUQYDR6tnDnbHdD6RDLSizkqB+BvEicAc9Y
         P7c73yswqBcXKHfRldILqWq9KRQRHMc7vRuuj7wmOZMvb9bolmQBgqeqE67kZ++sAYcz
         5B10FW6UeAdzAcxzaaY1Q1lhZqk8YUEFMTrhXMTSM3/qM+Ie9Apw9DBlyytBxlT9eY5S
         PzJ02vvyzvr1hQILcXOQhc+yyHjrAa7Af4LMTA8ncvUK4m8c8gkCxwL3fSvM0OkyqWZj
         y9qGkDTqxIVANDrv2Y5l9nsgiD8GsX5QfHC4IT0KxFtJOUFvtHC3pPkI6nHX9xBlHw+S
         uNJA==
X-Forwarded-Encrypted: i=1; AJvYcCWCR9acdTpEK04+T0aP5MK39GUOHLV4jXZyJC2jh6Pcnmpk4ksCmPArsCRHYAImSJb93ifIf6P21w==@kvack.org
X-Gm-Message-State: AOJu0YzoYkuRq0Nt0e9Ec+5VFxPSl3DWFXduSk09jdWuhBIrimwstbRt
	iEBwO04bZh+m7i6bivz2kBAq4Z2zBNHJahC71hcB3ZWeR0zwptLY++4gVRls1TIhICNXpnzxA4n
	NkwqqM3nE+4fSh8sdY+ErVxE6ODXR0m4=
X-Gm-Gg: ATEYQzynRT6xVc8Mg4Lk5k0nHqkHY4YNgZjgJtOf667mYd/VuWszaCmO3ISvatXRn21
	u5gXthYQNKIDIe3iWHh7v9HNB2R8NXtR8M6AWMFaJV4rrfqSZMLvBLlkSDzJkiAMDJ72GEwukst
	n/9ol5aR8OJ39FgILaCGBQcEa0LcWh9CL2mY30y2dMRD1yS3LZTbbTOfGfjJ5BzZu6Gplrbp35r
	6HGzt7llPe/mLFPvKi9+WMhyzJTKdq5EPMDLVKujkwx9aWD2mR/UaTbK0u8rMp7/MhYOo6L/Wpc
	i1fovvYROLLGOf52
X-Received: by 2002:a05:6214:21c4:b0:89a:ff2:b8ce with SMTP id
 6a1803df08f44-89a66a6662amr3068656d6.41.1773180476656; Tue, 10 Mar 2026
 15:07:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260310015657.42395-1-hui.zhu@linux.dev>
In-Reply-To: <20260310015657.42395-1-hui.zhu@linux.dev>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 11 Mar 2026 06:07:45 +0800
X-Gm-Features: AaiRm52RIaYvqSyHW_vTNKb00l8Sd2WDFbB9cGJlzhKPoSbby8yOhzritPID1Wk
Message-ID: <CAGsJ_4z85ZVnky6zCA5ZJ51EFM_8_O-ErYDmthwXryxGCxq9GQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/swap: strengthen locking assertions and invariants
 in cluster allocation
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	YoungJun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4fipofbrikczfc5wqbmwzpyqabzxn9cw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: D355B1C0005
X-HE-Tag: 1773180477-116575
X-HE-Meta: U2FsdGVkX1+smV0jXiBbTLn1Wg3rae75gCKs9ryi6M7gVf50F51yUyhckwlLKrc745X27HxMd4QzShQm1LQSc5JhxeK90ewGkJ+LjNCOkna63bsY2CYEpkUtt8BKu0z2km3I9Vg0fA0R4I5Xnh08iq4SdcIHeejD9BQDWDlaNkV/opB9TVJT0RBP0MWNgKjltOTlKGQ+vsiHGw+6wjPziymGt6d/V3GrpgWJ51g6XNqVRktHrKbc0KTG2tRJ2JGuGcxwSvkzTssob44dnjTvBMaYSY+ShlcXJbVQKEmvNZDT36n4AO/hPS3KG/XtJmHPpxFSFTOf6lSZ5JvCntTRIw800PcSW9QHllqgO3kJRjtgaY0MbZbdCoWhLsfvIkb1tnFVoii5wgLxnHvMu5ZUEbdf2ZrqjcDwsEfhwf487t7Jqtik1047V95zcJfYTCmDvcfXu9J9+24mctS32PoByWM2bxn5olmqy0/NbKQpfPSiv6zGAUEqdQ0sNePe2FUOKIqw6yXQ7jWT0pNMnsju6u4qRARkoxEpF6r/+PkUDcC0qp34Ugie56BlJQ6gqod+8qCZY/GOQGda5cO5INl2kratrelQS8VnglL9YqRHEfcG0ZXu8Q9punZXxy9dGydFgZO6o2Os8Ty6EIoUPB1pTCAqjBsM8p64oNTL2QQItKHYy0pyDE7vPoO2WsHLud7bd8+RqBH68emBolFMy5RJeZEkVJzzmVoOSwXqNNoEhEeC8JdJVqw7V2fwH+4T0T3xfzMBbKUWTDSx+xFq8jnJdCnAe1C6c1mH/z37xUDRY1seAxnyrjtIUyYf2S5CW8AvpsyyXrFxsqovyY36nrZO+bojGBf5zrLJLJdoMAASn8Qxw+B6MuYt4c3gOr1W0pdKeSezFk1BiTT5yYjmdyQeTNBbatbOZmu5ElCZJ91mlcSjI31XkTrhja1mThRnvzHWB0T6ujJtZPm2jv1RcR0
 ERNqBvJa
 wOvUM0AWPTameYdRUlIEjdOrf9u+hCJoCSapLSsZoaB2Lmk0BfFXGzrEDxo2IhV1V0obXmCXE01ns9BOl3+2HrugZRfxr/PQ+dj4UCLrGgg3ucfGrxdJperjSjPAsMriDo/6zQYeEIwe749BiRcUGS/6vc/n0acexitefd2XymhnpwCFGyXlkNgrnsa5Ie/gs/gevqzmPiOtYBa7vsPlG0JeRungfX0SFrmuHynATKhoNEJQTWPSF8zaLERu0K8bbutdTOK5u1uZ1vZvmif7CzNIQs5vPYxCOE/vAb8+7ZXiSs/h+5xnjyRxJ5bq5WxYBVN02bL7qJSKOdHXIK6KLW7mwrgRtdlJFcQfBUMn+t8IfsaEtxhVFAfXn/5NGRAbecRxbRfNNSrkFlRZRdmy89qqu1mGDI/fVVdMd4nfokTzfj5nrWOSlGyckKKa2lcfh8EDj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 9:57=E2=80=AFAM Hui Zhu <hui.zhu@linux.dev> wrote:
>
> From: Hui Zhu <zhuhui@kylinos.cn>
>
> The swap_cluster_alloc_table() function requires several locks to be held
> by its callers: ci->lock, the per-CPU swap_cluster lock, and, for
> non-solid-state devices (non-SWP_SOLIDSTATE), the si->global_cluster_lock=
.
>
> While most call paths (e.g., via cluster_alloc_swap_entry() or
> alloc_swap_scan_list()) correctly acquire these locks before invocation,
> the path through swap_reclaim_work() -> swap_reclaim_full_clusters() ->
> isolate_lock_cluster() is distinct. This path operates exclusively on
> si->full_clusters, where the swap allocation tables are guaranteed to be
> already allocated. Consequently, isolate_lock_cluster() should never
> trigger a call to swap_cluster_alloc_table() for these clusters.
>
> Strengthen the locking and state assertions to formalize these invariants=
:
>
> 1. Add a lockdep_assert_held() for si->global_cluster_lock in
>    swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.
> 2. Reorder existing lockdep assertions in swap_cluster_alloc_table() to
>    match the actual lock acquisition order (per-CPU lock, then global loc=
k,
>    then cluster lock).
> 3. Add a VM_WARN_ON_ONCE() in isolate_lock_cluster() to ensure that table
>    allocations are only attempted for clusters being isolated from the
>    free list. Attempting to allocate a table for a cluster from other
>    lists (like the full list during reclaim) indicates a violation of
>    subsystem invariants.
>
> These changes ensure locking consistency and help catch potential
> synchronization or logic issues during development.
>
> Changelog:
> v3:
> According to the comments of Kairui Song, squash patches and fix logic
> bug in isolate_lock_cluster() where flags were cleared before check.
> v2:
> According to the comments of YoungJun Park, Kairui Song and Chris Li,
> change acquire locks in swap_reclaim_work() to adds a VM_WARN_ON in
> isolate_lock_cluster().
> According to the comments of YoungJun Park, add code in patch 2 to Change
> the order of lockdep_assert_held() to match the actual lock acquisition
> order.
>
> Reviewed-by: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Just a few nits; otherwise:

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/swapfile.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94af29d1de88..4e0fb1ce5245 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -476,8 +476,10 @@ swap_cluster_alloc_table(struct swap_info_struct *si=
,
>          * Only cluster isolation from the allocator does table allocatio=
n.
>          * Swap allocator uses percpu clusters and holds the local lock.
>          */
> -       lockdep_assert_held(&ci->lock);
>         lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
> +       if (!(si->flags & SWP_SOLIDSTATE))
> +               lockdep_assert_held(&si->global_cluster_lock);
> +       lockdep_assert_held(&ci->lock);
>
>         /* The cluster must be free and was just isolated from the free l=
ist. */
>         VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
> @@ -577,6 +579,7 @@ static struct swap_cluster_info *isolate_lock_cluster=
(
>                 struct swap_info_struct *si, struct list_head *list)
>  {
>         struct swap_cluster_info *ci, *found =3D NULL;
> +       u8 flags;
>
>         spin_lock(&si->lock);
>         list_for_each_entry(ci, list, list) {
> @@ -589,6 +592,7 @@ static struct swap_cluster_info *isolate_lock_cluster=
(
>                           ci->flags !=3D CLUSTER_FLAG_FULL);
>
>                 list_del(&ci->list);
> +               flags =3D ci->flags;
>                 ci->flags =3D CLUSTER_FLAG_NONE;
>                 found =3D ci;
>                 break;
> @@ -596,6 +600,9 @@ static struct swap_cluster_info *isolate_lock_cluster=
(
>         spin_unlock(&si->lock);
>
>         if (found && !cluster_table_is_alloced(found)) {
> +               /* Table of non-free cluster must be allocated. */

I feel this comment is somewhat redundant with the one below,
and its wording might be inaccurate. It could be rewritten as:

/* Non-free clusters must have their swap table already allocated. */

> +               VM_WARN_ON_ONCE(flags !=3D CLUSTER_FLAG_FREE);
> +
>                 /* Only an empty free cluster's swap table can be freed. =
*/
>                 VM_WARN_ON_ONCE(list !=3D &si->free_clusters);
>                 VM_WARN_ON_ONCE(!cluster_is_empty(found));

I'd prefer moving VM_WARN_ON_ONCE(flags !=3D CLUSTER_FLAG_FREE)
here directly, without the redundant comment you're adding. Doesn't
it already convey "empty free cluster"?

Thanks
Barry

