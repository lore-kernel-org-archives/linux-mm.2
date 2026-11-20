Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86AD8606A33E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 04:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gtNrT3EC
Received: by kanga.kvack.org (Postfix)
	id 4F9D46B06C6; Thu, 19 Nov 2026 23:31:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D0936B06C9; Thu, 19 Nov 2026 23:31:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D976B0704; Thu, 19 Nov 2026 23:31:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 10E406B06C6
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 23:31:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74729120D25
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:31:41 +0000 (UTC)
X-FDA: 85454224002.22.9CF3F8C
Received: from mta1.migadu.com (out-18.mta1.migadu.com [95.215.58.18])
	by imf21.hostedemail.com (Postfix) with ESMTP id 897901C0007
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 04:31:39 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtNrT3EC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795149099;
	b=ZCLnCyjy6cm0/3amXgzdpxVXlEZVM7ZSB95Qoc0kYA2FAPUylzpWo+RbgX/6uRhPLyrXEE
	eCbppHiwhHpAPrPRanfB+HUxsskanzyygtbN1AQbKrkM/aPD8EkROIFtqQijOgNH5AHZqM
	/klSvtxx2MtGKF7yOsboA9q5HBJmzsk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795149099;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n2iV8ZgTwYQrd03h4K8/zYSLB89pwsCsAcFgWAxm3fg=;
	b=4stj63w3S/hKuoQRjNm4xNMJ9BvdksrETcW5vQj+0cFrONURtm6OCjV+5erNb5WSAwyj8x
	QSg+OdGLsDmnqfKDoLFBcd933rozmWTN1143R+2BNAoYswGrFs3v6Wasn7tJ+w+JpYBeJL
	RLr8jQdKPlu36Ba+e0Vk/iu40tQbnVs=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gtNrT3EC;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of kunwu.chan@linux.dev designates 95.215.58.18 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1NiiVip/IU0AhZJGu+tv3Ejl1IrHJ+s9jKpO+x/649s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795149098; v=1; x=1795753898;
 b=gtNrT3ECKcBVjHQc7VpSjj3d/h9Bbr9V5CepW3aAlYM5lSsm/b7d2yI1zNWPPttRTq/2NYZU
 9QDuMlOOIc4wW+cINVpqPzvfZLhv9k+QxsZw4aMHhOVGFsohyY6EsyJDBZQ6AX83axPq7QBwp8G
 2dkc7nszuOwckvi2efsXZEW4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f904e1aeb506fb66;
	Fri, 20 Nov 2026 04:31:38 +0000
X-Mizu-Trace-ID: f904e1aeb506fb66
X-Migadu-Flow: FLOW_OUT
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Date: Fri, 20 Nov 2026 04:31:33 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <b4a389b8d71b5e0fd9eb56af50f4bf6dce245532@linux.dev>
TLS-Required: No
Subject: Re: [RFC PATCH v4 09/18] mm/swap: avoid direct reclaim when
 populating swap cluster metadata
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, "Andrew Morton"
 <akpm@linux-foundation.org>, "Chris Li" <chrisl@kernel.org>, "Nhat Pham"
 <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, "Barry Song"
 <baohua@kernel.org>, "Youngjun Park" <youngjun.park@lge.com>, "Kemeng
 Shi" <shikemeng@huaweicloud.com>, "Kairui Song" <kasong@tencent.com>,
 "Jihan LIN" <linjh22s@gmail.com>, "Kees Cook" <kees@kernel.org>, "Gustavo
 A. R. Silva" <gustavoars@kernel.org>, "Thomas Gleixner"
 <tglx@kernel.org>, linux-hardening@vger.kernel.org
In-Reply-To: <88057ceeb0228fd33f42637a3c9647eea74d5d95.1794666741.git.lianux.mm@gmail.com>
References: <cover.1794666741.git.lianux.mm@gmail.com>
 <88057ceeb0228fd33f42637a3c9647eea74d5d95.1794666741.git.lianux.mm@gmail.com>
X-Rspam-User:
X-Stat-Signature: 1bdfz3itjr1arwp67majq17sjkkd6nag
X-Rspamd-Queue-Id: 897901C0007
X-Rspamd-Server: rspam12
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795149099-887610
X-HE-Meta: U2FsdGVkX1+nnzfOe7c1abFfL4w4OHbw7+blFXRiyWq0wr3FicBio2P2R7sby84YXJeoX++Pzu6VGLGr9fF1BnPsmHCPmXIIFgtDOz8T5FFi9SKsALWGEMJxiLuc4kiErBj18covFsNFEFPk/65J+i1Hnk++lu+wIssJVwIAYfJ63tc5rgNz9RsVFAVeaCuUb6RvsBxM16mu2CWLtDGvNiGuApShv7maEp8h22IUsaJ24NwKwYgbkdn/bTjy+kRhOg8NkMa1Jh16nwgkKZpMM7HwEOicEPZFDaq6SmNiP7FvjwEZ+YkmFP250FFlZCvjRWJRlro+LiFEml7QyF0/7Wv8aYsy27Y5V80w4YpCeztUEnIateuk8VwUoeDn8IDutkOSnkxUL3tz5i6sSOw5ctr1PEeSb192iJfUPMX504bzSS3ApizK5YhHgr/rg0QWY72i1OMpN8T1WWe8bPZrZC6vBcqM4x0LpOcbGw7kndtkVm/LvhpHC6cG/PxmDVLZKr6/FuD4geqBkS2NVj40hiYqIwf77SFaQbpY2mcCRVhEdrxbTuFaHzrfH6K5iJ0PWJegHykXnW4oVBS5vzYIgkSOBmbF3tvtCX9O7CKaVNyYt+ECW9W2Ist7j0rmS2VLenDIATBfi76Cf1iMxiHltFvOdJ3JIb8UXrz2GvULDTwwF9YpiTpnM/D9LyeSGTvBhl7qvBI87MtH6t2TqJKv7C83KjJocWmqA7ELGeOPKgbLVb9E0iB4qrDDbQbPCvFPsc+ra4rA+wMPjAGIvqz5alhiVyGC7yLAzy52sCQnZ3TWBMNwqwHDGOOCpmxg4OrAhlyEuC66Y1qW0FhujLVNmU/ENnytpLZ16I+mTIYBgQwf/oTEIrxVk5nAiH4xiOfSSjSE+YzZd6Vy/6OBHWY8YaSRs9Xy4tjsrI4OlYsWf5Igrobz2FJ1x6sRBa4gBRTGs6oxQzZRHlGaWk6xn6d
 fv18uGKG
 XGDFVMf+KT5fnKgYxhUsMaMbyAqb65WOyZ6dRhHpClu5Gy+nU3qAB0hL9NgYlCJsLCKx8kAybK3kj+KwVf99/GArzyLdFCqx8MWhnvc6BDUMMmZm6pANuQDIDsn/1PzmMG4h+pKdQWEXyNVG/f3Xt/cR3rynLM9fEmesn5SyhP1l+WOuTE3Qq37VTzUCCyLuaB3ZdiHvR2MqpF+s9pr1+REeXK1T6ChzZbFLyw/cj74oI8xGEs6VGZuQrqwbdYwYLJcp8kXq3ndY2RFGgSr6gVHAGPsSLFc6AfKv+rb20tZ2xMiLnJiIumoKBI6yJl97MmNPF/1Qo5DAm1uGG/XjEHLTqP16SwoIT0HgzDKB2/BS926shKYBonNXmLLZ7L78gNh6GYSJZHHdE62DQwqk0974vSmSYU6o62ncR+jD5vbjU/xbzXoQ8uFcZGZcdehoja9etziL1mELKTDF6xR8xzc9rJXsPX6WhT8JgMOjsLRPcPLVeO04EvYJ9MNxl4/nortKfhWDvVhtIIQ9Ib5/yx9MUYDjx1byjnzgTFUyM8oQD2q1KeIwV4JOuC9RlOVwzrCal17HJgZf8CjA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>

Thanks,
Kunwu

>=20
>=20Swap cluster population is entered from swap allocation and may itsel=
f
> need memory for slot metadata. Its fallback drops the device and cluste=
r
> locks before allocating with GFP_KERNEL, which can reenter swap
> allocation through direct reclaim.
>=20
>=20Make this allocation boundary explicitly non-reclaiming so callers ca=
n
> retain outer synchronization without a recursive swap allocation.
> Clear __GFP_DIRECT_RECLAIM from the fallback request while retaining
> __GFP_HIGH and __GFP_NOMEMALLOC. The retry can still wake kswapd, but
> fails without direct reclaim when memory is unavailable.
>=20
>=20This can make metadata allocation fail earlier under memory pressure.
> Keep the existing isolated-cluster rollback and restrict this request
> without adding a task-wide PF_MEMALLOC scope.
>=20
>=20Signed-off-by: Lian Wang <lianux.mm@gmail.com>
> ---
>  mm/swapfile.c | 23 +++++++++++++----------
>  1 file changed, 13 insertions(+), 10 deletions(-)
>=20
>=20diff --git a/mm/swapfile.c b/mm/swapfile.c
> index c46b43414bf4..fae862fc873c 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -586,13 +586,14 @@ static void swap_cluster_assert_empty(struct swap=
_cluster_info *ci,
>  }
>=20=20
>=20 /*
> - * Allocate swap table for one cluster. Attempt an atomic allocation f=
irst,
> - * then fallback to sleeping allocation.
> + * Allocate swap table for one cluster. Attempt allocation under the l=
ocks
> + * first, then retry with the locks dropped without entering direct re=
claim.
>  */
>  static struct swap_cluster_info *
>  swap_cluster_populate(struct swap_info_struct *si,
>  struct swap_cluster_info *ci)
>  {
> + gfp_t gfp;
>  int ret;
>=20=20
>=20 /*
> @@ -610,9 +611,11 @@ swap_cluster_populate(struct swap_info_struct *si,
>  return ci;
>=20=20
>=20 /*
> - * Try a sleep allocation. Each isolated free cluster may cause
> - * a sleep allocation, but there is a limited number of them, so
> - * the potential recursive allocation is limited.
> + * Drop the device and cluster locks before retrying. Metadata allocat=
ion
> + * must not recurse into swap allocation through direct reclaim: calle=
rs
> + * can retain outer synchronization across cluster population. Restric=
t
> + * this request instead of granting the task PF_MEMALLOC, which could
> + * give allocator hooks and failure cleanup reserve access.
>  */
>  spin_unlock(&ci->lock);
>  if (si->flags & SWP_SOLIDSTATE)
> @@ -620,8 +623,9 @@ swap_cluster_populate(struct swap_info_struct *si,
>  else
>  spin_unlock(&si->global_cluster->lock);
>=20=20
>=20- ret =3D swap_cluster_alloc_table(si, ci, __GFP_HIGH | __GFP_NOMEMAL=
LOC |
> - GFP_KERNEL, false);
> + gfp =3D (GFP_KERNEL | __GFP_HIGH | __GFP_NOMEMALLOC) &
> + ~__GFP_DIRECT_RECLAIM;
> + ret =3D swap_cluster_alloc_table(si, ci, gfp, false);
>=20=20
>=20 /*
>  * Back to atomic context. We might have migrated to a new CPU with a
> @@ -3160,9 +3164,8 @@ static int swap_device_disable(struct address_spa=
ce *mapping,
>  return err;
>=20=20
>=20 /*
> - * The swap allocator doesn't take swapon_rwsem. Looping through every
> - * cluster lock after clearing SWP_WRITEOK ensures that allocators see
> - * the updated flag and that no allocation remains in flight.
> + * Drain cluster-lock users after clearing SWP_WRITEOK, so swapoff
> + * does not race with operations that started before the transition.
>  */
>  for (offset =3D 0; offset < end; offset +=3D SWAPFILE_CLUSTER) {
>  ci =3D swap_cluster_lock(si, offset);
>

