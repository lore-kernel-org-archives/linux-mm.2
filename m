Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1C931125854
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 17:34:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C1806B0005; Wed, 11 Mar 2026 13:34:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 085986B0089; Wed, 11 Mar 2026 13:34:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF4916B008A; Wed, 11 Mar 2026 13:34:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DD9926B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 13:34:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8740657EF8
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:34:38 +0000 (UTC)
X-FDA: 84534481836.22.7843FA9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6F69E4000E
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:34:36 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QJw1q6dR;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773250476;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxohpoYV7FxROC8jBuBjmJ4BOVlSQzo2TfoCeyxTw6E=;
	b=39mheO9bx7Gz/zocmOb30vNqcPwaq1/rkI0dPqAmxcwqULmtryd+O9Z4g+Mk/DFIkQCblA
	HEFdRMhvI3GYj0keGQLNY/EWIIGA4S+3bc4nSP7k7ZJWQ298t3a938hinuMotrKRvVEgNg
	tzlP2k+U0gDxFPidEBED0LVB/NPHASI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773250476; a=rsa-sha256;
	cv=none;
	b=Qzvlfuks8iCo1nVtV5NX8murlIS5zJXWpF27KEacSWtDO4NL6upyenkFtXGHKHA8XYuKhj
	gcBe4bjumCI24brQSibztLyfhk+YVg5Q6vhzZFnQBwHPKhMtRbAPHL6WrkjwffVT0eSsyS
	XIuhHXtiayQPBo1P2G9zDRCoz8d0j/o=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=QJw1q6dR;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6CF2D40DDA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:34:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B556C4CEF7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 17:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773250475;
	bh=LpRRZYPi+vMf8ynmnAiOKOJjFQw7hsrwt8dz1RjsBe0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=QJw1q6dRrQL7mhcWgB/wc931ak2nbKliPan9ayUv0qeMdgIz0FylgCh7S/deLtu9v
	 JrUzQqUP6saCrk8txEaP/dyazGiwUreis9ijobwGjXYWNlNCfUBqrP60iEDNhIHVA4
	 TltAIFiuu7wpb9cVFU0CRzxJjtdFvUPdiBQkQm+XoZiEPemdUA3wFTvbcwJOm8VN03
	 j+cTE87lI/aRyvlaDEWeavWDdbG7SaWiYv5FIv8BraOWitCnwWgjoHCiVS/jW346pU
	 XBs8BuWMxPNeBlvx0FjKx4SGdQEbZPlZ3eWfdNiCnw8TmfYtJKdIZ/OuKKS1tMJg3/
	 oiDtoOlVY+WyA==
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-899fac9caabso1493826d6.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 10:34:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWw/hl050uEvOGwPV07wxTOElZyAJyMirwWhwDgBbEKmySBJxgMlWj+tePvAAKvfv6ARtML3xcUsg==@kvack.org
X-Gm-Message-State: AOJu0YzzOYWTI1gefQFF90SWQkbOI4ekOL2GTIQleo86Oftn9qKv6n+E
	AHNqhcd+Mxh7eDv1ZymJ4IHW4M/0rlVUeYtI2Ykz6/8/x85ScMpDaoz8KMLe8XN4oN84xIyOegH
	CiY4OXEH2L/lsM9uYcwYvUNeN/7bPBbo0u5JmMF7OJQ==
X-Received: by 2002:a05:6214:ccb:b0:899:ecd8:d266 with SMTP id
 6a1803df08f44-89a669e8c30mr44220786d6.20.1773250474599; Wed, 11 Mar 2026
 10:34:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260311022241.177801-1-hui.zhu@linux.dev>
In-Reply-To: <20260311022241.177801-1-hui.zhu@linux.dev>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 11 Mar 2026 10:34:23 -0700
X-Gmail-Original-Message-ID: <CACePvbVKmAPKRRzfZ-id=5ESf3SL1QPYU4p5xBJBg4F9ocPb8A@mail.gmail.com>
X-Gm-Features: AaiRm50trZWnsvjXyrAVbZ8KWGdf9IJgCAUOiuc749wSi0dPKZY7up_UytpzC28
Message-ID: <CACePvbVKmAPKRRzfZ-id=5ESf3SL1QPYU4p5xBJBg4F9ocPb8A@mail.gmail.com>
Subject: Re: [PATCH v4] mm/swap: strengthen locking assertions and invariants
 in cluster allocation
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 8qr816w57ppncy3pst6wi115w4k4uttr
X-Rspamd-Queue-Id: 6F69E4000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1773250476-749689
X-HE-Meta: U2FsdGVkX19lMFqzvarZJbaQ0FjgQjLSipGRbtwWLwAJgwbvzdm58oc/uO8aJx3NruHM+uYRJaIie/xdCB1dMMAVDD/y5p4q1j3j79/KeRLKLWVraAhQGwX/2BptvGD5zKSFCR6unkrbmZdAUEfLl89DgzKa8KdaK/FtQudYg2QgrIwiiA3dpR+Qs7n1Luk0+JChEIoZ2cIt7W4vcmboykDQTNx7XVoF78KQVJn5rsGrGwizf9oUVqSNSlWGRBuA4DtH06cas8XdR2jC/iqF/XOp6rDSkYYes2sbNTYbJeR5LMFJggk+RLla31O9MzN1C8kM/lZi51+QkhKZeNU+WFHqYL4GmfwQJP2dKNxPNl55TYAIwyevBgOvwN+X2VAOyu3Lu9py3cJ3jEQkhrv/hihpv+QOaJupyyFWCUFXTFWWZbhgxcV/3EP0TrNJgoYd+fEugyLcTJCbOpJWv9dz9ATC/omMM8ovRTlQH+aJOc6PDqibRjh2vODOGgYEy4h/yULhlGS5Se0IWovjGdl+8SkpG42Vre46AM/p21gzIXCfCr7PODqgdkU8F+LVYuS9WIVVMhV7NWJ8DUn9NaisJCbB9wjJ1UzFSsOWuPsTaF54GSd/fq5LDatn+GALSgSMe9oFY/74yM/wE6irD+keQ6QdwhEAYpMMjWYKmRxWSt0Jx2dnRUzdaK3ADN0+Y+TXsQuvcaag1miIDOATp1HDvjxdyWFoBPKOusn9TB8kttLBb6JJ9X1Hg2AEaod3L96leUQIzZGzMx7uNPJ5DZN4BSpfT/G/PoQhKiqpUhP7z+3KwvujeQrZckJvx36otaaXa1XPxevkxlygsfieJ3lDNuSgDFVmZBFDgR7CyW6skqJxTZoDPq9lL+pe8t8R0cQ3I1QY9y9A1o+uJvQUuoBYZdFjKXg8zbRmvNz8OJL7RN+MuQGgtHe5X9pj0pg304HxDyMQI+30GLG4td/EFf0
 pG5twHnH
 QpvVdwiHhcdrOA0Lg7ubaWxgaeIi9/OBQMZ+Cm8wGLhVF9tKEiou/svDZxvrUR8/2k1cZQPJ8Q29HIi3/6/uYpPxDL3Pz8GkS8tscuvRsawiT+K1e581DUG6Q00ATI3YUk4mLiTZmPIFFZ1JkGgRSMRmzqWAG1HYZLBljGvqpOGCcz1XTroeQKwsLjPt707m9zGOMOWjAxg9AzE/br98LOcJCTO0AsnYSSPnRenwZVi3ccPjJAbaa+Rm5I4zw3sxnpdtTiKVEOq6UdvCFqTP+nf5VV8KRjA53Dj5om83n7GkpJr39FAF1JkBr0t5Ouer9BB+4poc8VLwGHfQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 7:23=E2=80=AFPM Hui Zhu <hui.zhu@linux.dev> wrote:
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
> v4:
> According to the comments of Barry Song, remove redundant comment.
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
> Reviewed-by: Barry Song <baohua@kernel.org>
> Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>

Acked-by: Chris Li <chrisl@kernel.org>

> ---
>  mm/swapfile.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 94af29d1de88..e25cdb0046d8 100644
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

Nit pick: consider initializing the value. The flags assignment occurs
in a conditional block. The compiler might or might not realize the
"flags" assigned only if "found" is also assigned, and might complain
that flags can be used without initialization.

>
>         spin_lock(&si->lock);
>         list_for_each_entry(ci, list, list) {
> @@ -589,6 +592,7 @@ static struct swap_cluster_info *isolate_lock_cluster=
(
>                           ci->flags !=3D CLUSTER_FLAG_FULL);
>
>                 list_del(&ci->list);
> +               flags =3D ci->flags;

If VM debug is disabled, this variable is not used after its value is
assigned. Please test it with gcc and llvm (VM debug disabled) to
ensure it doesn't generate any warnings. I don't expect it to be, I
just want to make sure.

Chris

>                 ci->flags =3D CLUSTER_FLAG_NONE;
>                 found =3D ci;
>                 break;
> @@ -597,6 +601,7 @@ static struct swap_cluster_info *isolate_lock_cluster=
(
>
>         if (found && !cluster_table_is_alloced(found)) {
>                 /* Only an empty free cluster's swap table can be freed. =
*/
> +               VM_WARN_ON_ONCE(flags !=3D CLUSTER_FLAG_FREE);
>                 VM_WARN_ON_ONCE(list !=3D &si->free_clusters);
>                 VM_WARN_ON_ONCE(!cluster_is_empty(found));
>                 return swap_cluster_alloc_table(si, found);
> --
> 2.43.0
>
>

