Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3E2B606A31C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 02:47:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LL7vT16B
Received: by kanga.kvack.org (Postfix)
	id 099EB6B05B1; Sun, 15 Nov 2026 21:46:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 022606B05B2; Sun, 15 Nov 2026 21:46:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA1136B05B3; Sun, 15 Nov 2026 21:46:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7CD26B05B1
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 21:46:55 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 248C71605F8
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:46:55 +0000 (UTC)
X-FDA: 85439444790.17.13862D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 73D1E140006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 02:46:53 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LL7vT16B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794797213;
	b=PjWrv/A6wzMJYyzjPYMfRxOz5R2cVg0r0nvs7ZJspf8w9yz6HIQQZj0Y9HEWg/VX8bTu/d
	xUzR+5W4s87RKg+eIbx7wjPca/MUurd9wu3kSZFN2ZQGaOo3H/Dd9aHYoJntuCiLHvn+9D
	LXNZvAb0l6bPunZgzTpZFobyVEqCLvY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794797213;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q51XsjxzYXtqJ4m3Za86oITQpjmGoPXuZOiFXlWuV94=;
	b=5dT2w0tFEMtlgj/ug7jq4hsrcctRrZzBR1raKO6mYAtX9bO5/nZWtk2okId7M9ag0ZbW6A
	bPq7Diz2Ys7Efxx/gjklD/wsTlV1MPU38vLZWhBGd+vbwvtpS6At+fMeRvHJBk50ZZ3KKi
	Mscat0Pl1hAu38TW7oYPYNbdcjYfYZY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LL7vT16B;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 565974025E;
	Mon, 16 Nov 2026 02:46:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E0431F000C4;
	Mon, 16 Nov 2026 02:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794797212;
	bh=q51XsjxzYXtqJ4m3Za86oITQpjmGoPXuZOiFXlWuV94=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=LL7vT16BAk+5cM/m96XQNjwvH17wZb/WK1YG9k7wzR3/jCZYaR66DMB+ufC2eIDEk
	 lP7h0isEBqu8LDLFY9lgCPFrwcWGkf7uJl3S/4bICOSTLGft1tJUeF185GRBpw4FeC
	 QeQ4wqhbwR9Tf9Kmd2wXMOi6f83NJUblvZBbFlC6wAVetzEyXWFHDKAOwq+ugE5fxU
	 FhIFlkg4d5KAnQScgs2pAlX7kO6kc5gQfcLK2n1HvvS230tgDSstGmpJ3BGl2gr4UW
	 Ocw1lTFp546J00tiTjtqm3+RmkEICQZVWZtwpRJv0TJ8HWF5nukClOQb8PnM2o7RhK
	 4XoYLUCqC/Npg==
Message-ID: <sashiko-outbox-216091@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 4/4] mm: swap: allow direct reclaim for
 synchronous multi-page swapin
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nanzhe Zhao" <zhaonanzhe@xiaomi.com>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, "Jens Axboe" <axboe@kernel.dk>, "Sergey Senozhatsky" <senozhatsky@chromium.org>, "Minchan
 Kim" <minchan@kernel.org>, "Kairui Song" <kasong@tencent.com>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Nhat Pham" <nphamcs@gmail.com>, "Usama Arif" <usama.arif@linux.dev>, "Yosry
 Ahmed" <yosry@kernel.org>, "Chengming Zhou" <chengming.zhou@linux.dev>, "Chris
 Li" <chrisl@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Ying
 Huang" <ying.huang@intel.com>, "Suren Baghdasaryan" <surenb@google.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Kanchana P Sridhar" <kanchana.p.sridhar@intel.com>, "Wajdi
 K Feghali" <wajdi.k.feghali@intel.com>, "Bala Seshasayee" <bala.seshasayee@linux.intel.com>, "Nick
 Terrell" <terrelln@fb.com>, "Barry Song" <baohua@kernel.org>, "Tangquan
 Zheng" <zhengtangquan@oppo.com>, "Bo Zhang" <zhangbo56@xiaomi.com>
In-Reply-To: <20261115024455.1465726-5-zhaonanzhe@xiaomi.com>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com>
 <20261115024455.1465726-5-zhaonanzhe@xiaomi.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 16 Nov 2026 02:46:50 +0000
X-Rspamd-Queue-Id: 73D1E140006
X-Rspamd-Server: rspam12
X-Stat-Signature: i3tx3ipk7fqyk4b9w7rgxwt91wwpuny8
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794797213-763385
X-HE-Meta: U2FsdGVkX1/24DM5x6cP8JijeWQKvRpMJzCuszSHZNvRZUvubWtYo7MHLXoXgkgiCaCag059gbgjzuizXq8D+ULOsj44jfEVmjrD3hqwR6SSHh5nKSXvz2BojsvAhZIp7x82sQy+WcMWLumlbk1vAcgov7gKXvgZYEyS/FrQoBYcG3srDgjjnQuo8ROxjVmoHvI/V73Nw8N2RKFJjGn8M09HEJckKwdubz5F6ga2FQf0LrC9qCb6XNN/OiSa6zvQ2hW2SkwG55+HlL4CNVEgusGPD2ad2yHry8olNwk92xaggqh/IqCDIiy49XjFmIW4zokdVEfoOJwI4UpMNMXpogxZ98B+GRbRW+ai0mnuazv13RVaApW1mq5iMNqPdUboVNhgu5PedD43uWKiPqkdZx1AXwiLepqOyh73rTCHHH0nPbkqOt0vtojIQ89i0GOJiZFXuRwTPMOwgCyK+SmuH3srXpNygjgTbkf7GLlCmsuDUAUydbCqZDmTDR/BRS3/m7kEw/mVWC0ygUZOlL2KGUr3HanXDydGhfZuVwZgORuvPspGVh6YYgHdwJmVvRGAjs5jxdz+vUWrtiPSYi1ppcnNavQi+y7nmLG5cyXbZUj/a+1XbBDlnhPXz0Q0TGHMdNeKsDOFFFMCnOq7eigZTQXYyxJkvXsbc5yQKERK9bzcwWMjDgzSWJaqa4vZ+DXvmcdP2CxIMwuvx9ymYtTIPinGPY7e6ky3CuRzVmrbF3RRV0SH7CwIYAMnWAVynTaHRIom8wmP+k0cpHotBsAWYD9JBjay5rCk3JmLig9xyQSG4rWtrPKwW5ZUKlHWCu5n8T6rPQqodMapYC/YshpBpOZMAJRFn9zADAuJlkUR+s4fgYCYhEiE+SIflWOMtLynovY/mTmTFkIkiSILWgmf10K6Noa/sM5J4PP2J+OCyq67OGfjC2Rw0Ke6KLykkgmJO8nG6lFOwBY33AksQCT
 0cjx1FNj
 DzSsFe4o6r1jUB+/OKVEm36owgCscDZ3QGZFxZkW4oMRSidIfLW1Kj0D0i3MpqqlKA6mI02nMFsqRbAeDS+5ppmfwVtIGZ/ypFj/OMHUmyUQoQHgjAX4L4c9wQr/nfaTNN/3hLe0RA3K6tICwRlxeFLokuMyklQsfa6CiQjfxHH/W9/Hq1BIKzEze0nNRzj7WOGI07spgmZwEV9qRgqMIGOO1kkF4861NcZIQ6yZ0zt4iTkgOMm9gYZHMPsatDF/Fh6We1O7EPvYq58vwe+I5DQxc3v/xzHIX2FGkrdN9wvdVjwxHBxBv3jBrI/K4MUdlRiBpzbrSvKJwA3z1APvxgES6/ib9alMkDkvK8kRUxg10e1zvYDoQiHIHS4omQBWHkONvc73xV+HYiI8A8tVncDTDBG5dg+5fPEWJf5GsuN4GhXGMhjJHCAOdCssfNFpGUSqY5JgfgQF0UNwiZmIthoEeejzTbWo/6pLwrPGZjhM3IQg/QiFlqyIZCb9AMErY/7sZcaj8xAsfngWY+sXQfEzRX/xgHI4iKEiLPl9h7qBJzZuEBcrqKDuTGbz5v4RGrrrdbtUINow4/tVssaWzQ5ME3EZxgCuYtOplG2uQhQHolfW4fMbVWb66lNxLKTsA0IcXvTRMXhg1gJD3S3XwcqmFwN1Di/1CJTdtTxOVGaOeKpV9bYj16HCTE+79onWAMSLaqOJpactQNs9ALvQGDP15Hcm1XI0M60h+MwDfIm7k6IXwbLpu8xtwWw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [High] mm: __GFP_RECLAIM without __GFP_NORETRY in __swap_cache_alloc()
  triggers OOM
- [Medium] mm: hardcoded order-2 __GFP_RECLAIM in __swap_cache_alloc()
  bypasses policies
--

commit cb747b328cc1a8c3f1c43755cbc281a7af714c90
Author: Nanzhe Zhao <zhaonanzhe@xiaomi.com>

mm: swap: allow direct reclaim for synchronous multi-page swapin

This commit enables __GFP_RECLAIM for order-2 folio allocations in
__swap_cache_alloc() when allocating via vma_alloc_folio() to improve
multi-page swapin allocation success.

> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index da65d75ceead1..912b0e21a781e 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -462,6 +462,13 @@ static struct folio *__swap_cache_alloc(struct swap_=
cluster_info *ci,
>  	if (mpol || !vmf) {
>  		folio =3D folio_alloc_mpol(gfp, order, mpol, ilx, numa_node_id());
>  	} else {
> +		/*
> +		 * zsmalloc uses order-2 pages to store compressed data.
> +		 * Allow direct reclaim to improve allocation success and
> +		 * avoid partial reads.
> +		 */
> +		if (order =3D=3D 2)
> +			gfp |=3D __GFP_RECLAIM;
>  		address =3D round_down(vmf->address, PAGE_SIZE << order);
>  		folio =3D vma_alloc_folio(gfp, order, vmf->vma, address);
>  	}

[Severity: High]
Can setting __GFP_RECLAIM without __GFP_NORETRY or __GFP_RETRY_MAYFAIL
trigger premature OOM kills on order-2 swapin faults instead of falling
back to order 0?

Under the default THP defrag policy (madvise), as well as defer,
defer+madvise, and never, vma_thp_gfp_mask() returns GFP_TRANSHUGE_LIGHT
without __GFP_NORETRY.  Because order 2 is within PAGE_ALLOC_COSTLY_ORDER
(3), adding __GFP_DIRECT_RECLAIM without __GFP_NORETRY causes
__alloc_pages_slowpath() to enter full reclaim/compaction retry loops and
invoke __alloc_pages_may_oom() -> out_of_memory() when an order-2 page
cannot be formed.  The same gfp mask is also passed to
mem_cgroup_swapin_charge_folio() -> try_charge_memcg(), so a cgroup with 1
to 3 pages of headroom triggers mem_cgroup_oom() instead of returning
-ENOMEM and letting __swap_cache_alloc_folio() fall back to order 0.

[Severity: Medium]
Should __swap_cache_alloc() unconditionally override the GFP mask for
order 2 here?

__swap_cache_alloc() is shared by all swap devices even when zram or
CONFIG_ZRAM_MULTI_PAGES is not used, and when multi-page compression is
enabled its order is configured via CONFIG_ZSMALLOC_MULTI_PAGES_ORDER
(1..9) rather than hardcoded to 2.  Or'ing __GFP_RECLAIM after
thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp) also overrides
defrag=3Dnever/defer and caller GFP restrictions, and placing it only in the
else branch leaves out the mpol path while causing shmem_fault() swapins
to behave differently between CONFIG_NUMA=3Dy (where
shmem_get_pgoff_policy() returns a non-NULL policy) and CONFIG_NUMA=3Dn
(where it returns NULL).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261115024455.1465=
726-1-zhaonanzhe@xiaomi.com?part=3D4

