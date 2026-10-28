Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EBD93606A320
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 16:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JD2FRaro
Received: by kanga.kvack.org (Postfix)
	id 9885E6B05B1; Wed, 28 Oct 2026 12:15:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9605A6B05B6; Wed, 28 Oct 2026 12:15:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 84E246B05B7; Wed, 28 Oct 2026 12:15:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 632BD6B05B1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:15:00 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E85BE12014E
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:59 +0000 (UTC)
X-FDA: 85372533918.23.1A75C8D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 378A14000F
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 16:14:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JD2FRaro;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793204098;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8naBzzt82Aiy4Tz/Y7fncPSQu77bbEdY7/guuz8xFek=;
	b=JiBtNoOvSG+GILpooEf13dnqgALV3k/2O84Ly39MKgc3nEKgk0jBu5Kpkri0RsUDX//q5M
	ziTQkW30Iz9Xmgnex576xwXORFp3eU5Euf8ULP+yrk33OJUVnwS2wlnx8GbrPuVjbR0VPu
	KMfFsZN14Rewq9nwyvV0iYoomQ1zDXA=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JD2FRaro;
	spf=pass (imf01.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793204098;
	b=RPdC6lYTUaoIHr6uYMDTLwnNNO3LRuc4LDVBDwLTepEPF6H5InRr0iXLqWNyJXtyM3tEQA
	ezpfa3TewGm5hFhi3OCKEiE9V1fwGgTQ1f1wkZGTA00E5HzbVqnms1SYO/TOQOor2vKj0A
	/O/cwNP4okidhP7HDwUGnIQlxVPIMxQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54CBA4118F;
	Wed, 28 Oct 2026 16:14:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852DB1F01825;
	Wed, 28 Oct 2026 16:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793204097;
	bh=8naBzzt82Aiy4Tz/Y7fncPSQu77bbEdY7/guuz8xFek=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JD2FRarokL3Rc8EBfg507hQMWOHngtcs12HIdFtTwBAGeSTjtRQDu+QFyFV1BmHYr
	 M+DDmwzcmGuWZ6iaR5LLivuuTYMg71hY9iKeGDraDwYgOLhb7giBcKZ1uAOUndAu0/
	 bI34dtQlqXc9HJarI57XdpTuFZubD7bAS/MjerQDcPxtwzeMgE26SF82a+iP6qgcL8
	 mgdY2OiWTFDYCjby5gHGSGvUpbn03lziiQczkfyr85XE//y8cfEj6Bq5bRKwpLyQQQ
	 pesvaZXmK8Vz3yOBOkeHCYWFawG9dFsVMrFWfd42TRiMd7HczSEpBXeslfCRtONuu4
	 76yf2vN26E1iQ==
Message-ID: <sashiko-outbox-188134@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v3 05/18] mm/swap: change the swapon lock into a
 percpu rwsem
Reply-To: sashiko-reviews@lists.linux.dev
To: "Lian Wang" <lianux.mm@gmail.com>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, shikemeng@huaweicloud.com, kasong@tencent.com, linjh22s@gmail.com, kunwu.chan@linux.dev, kees@kernel.org, gustavoars@kernel.org, tglx@kernel.org
In-Reply-To: <d7120017ded998ca722ed78e1995f0d1af82e88c.1793106426.git.lianux.mm@gmail.com>
References: <cover.1793106426.git.lianux.mm@gmail.com>
 <d7120017ded998ca722ed78e1995f0d1af82e88c.1793106426.git.lianux.mm@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 28 Oct 2026 16:14:56 +0000
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 378A14000F
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: us8jkto8w58kgnoi9s8he5kbho1cprxk
X-HE-Tag: 1793204098-705819
X-HE-Meta: U2FsdGVkX1+eVts2ZqgX/BBNtRoRQywkDQFdYzMhMFkLrYeUj3pt2Dw7sZvMzjiUIgK+/SgdnII55aD029WRzS+1wzgtbbWTMqtgNrOrrr8lh+yUXT8VH0twf09gJXAsMyjcCSF+6lmsl+N3D4/N3CQW98EhRT2f9sl4IqiH3xOX6peQIvOMqMSORAurkZvRe8rZJHF7o9GDVcjs1TzyvY6XfTQk4lupm7zPcop2R+l1Bk83NVIXXSNsgLAT9Zm/Fp7dvYrL4WL+kArcOwyYipMwuDRXm+CUn1Y1ThiqTw54HCrvDohFkNrT24ptsWVprd1pILMu42BpVOBDPLHrQILfUmH2W9AYecWtX+dk36Y3ZHzEueuX2hOzSLzRP0m0k59F6AQMxFV6kiy/650t7fEDyb6H+5JVQ45vW4jH4pNfHozdQ+YtSHm1FZXm8ArV84ciLjYORLYw+FrnGEeHV6iU8ugc1ehXksBwyuXwwOL1THPkZ2FxW+rV1z7qe5pTSPhRd1mXRE/o44fIan2vyYBseP5zqybgeTEk8cYPqUdNsQ3XQ/XK9QX4DQwr8yu1fsQd4RYemyf8R0hZeQBRNUvgS1FxV1aOx8ufZZFydP3lccspJ4OGxDocrOrjT2+70IfFs79bcAw/H7WPnxUAC8EezyAgSAX2bMmdW5H0bd8BJGUBYxeIQlnb8aCmaCD/yxWNqnt/AuZBpT+tyMm7pRloAzjlWxfqrPqVSPIMvKOfIagwD8SmsL7+tXjJ8DlbgwD2s5fEtrhVTlAZx8Z6yJTB5HWyozaqMM1TGnI9Hf3caq8+Yuc3dg/NiYTXzmu8JbpCcxkwT6bENhwp9ZkwJ6tw+YC9daKoTuZTodyv3SQReFHlKRQcRpD8N/ah+qhgpwkJJr1vSpTxdNfqXXBmt1UBai8ceQOBYU9eqc7Vajy+aqGk0U8gQ046wgTjg5KtlCRnCGVNXH3Ue418qlT
 hkoaf+zo
 xfcsXAbFfeshmhksAbiQOFbdtqaSL2TcNENNj0hl+JDqxFGaavCeajHFzqG1dGJpEmlf8cePXbtkvB3wXuWCSzkqdSRLQCz7z6Nf6il10nqxVedxJbSrrthzNMfgCEUm0vLOf4dM7Q9qwNcQQmlXcooEAmCRLvYn02jKfoKivkgH/iTR9u5NfOqMgq5EesdxZQEvTZtf1z1Yq9wLKnR89EPEG1TZWiMqrPbJ3D7Zw6uaQC7yKNzOiTNd/Iolg1sXIYC4xnqjFDjjjzS/TCGwj3HqwXMyOPmAKdUgbnByCJKMK9EYuj42GVK3eychwtulGS7UEQJpIUOIPw6/N0Twan7zJZJMWsZ7O9R8CoPJdRVzxAO5tzoGW5N7AhSPu4USVfPcne6Hs1Mv8GzdGTVbWyRDl/S2y93w1SZJvG5xgJsws7WCYzBal2UylzvjndEQRsrzjT3fCDvkz71gO/0gSghIdWgQramarscsW3f8ou48dSpm8pu2Kp/4EvTYSHSuLEpGxgl/ys8acmGMdz5BRgqJQpe+PLx4Ayifx/qqx2xMHRzckVICGwVjL8HaW55OfeLILrSz05dzepiKH+krv/rNWK5uHTpMwB8al+UOnyIa/iGIOfOPbMDLuPb6P5y2U0rxW1Y7WAuaVsgXZbgZgya+dz3KWNrzVqV6MC2EjB8FLpCrtrqNWH3MVaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/swap: infinite loop in cluster_alloc_swap_entry() on disabled s=
wap device
--

commit 75f9eec48d8910061cd39d390305f876926fa1d7
Author: Kairui Song <kasong@tencent.com>

mm/swap: change the swapon lock into a percpu rwsem

This commit converts swap_lock from a spinlock to a percpu rwsem named
swapon_rwsem so that readers of swap metadata can run concurrently without
contention against swapon and swapoff writers.

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index b72f4fc3e8117..4ffde6827d441 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
[ ... ]
> @@ -3152,14 +3155,14 @@ static int swap_device_disable(struct address_spa=
ce *mapping,
> =20
>  	end =3D ALIGN(si->max, SWAPFILE_CLUSTER);
>  unlock:
> -	spin_unlock(&swap_lock);
> +	percpu_up_write(&swapon_rwsem);
>  	if (err)
>  		return err;
> =20
>  	del_from_avail_list(si, true);

[Severity: High]
Can clearing SWP_WRITEOK and calling percpu_up_write(&swapon_rwsem) in
mm/swapfile.c:swap_device_disable() before removing si from the available
devices in del_from_avail_list(si, true) cause a concurrent order-0 swap
allocation to enter an infinite loop in cluster_alloc_swap_entry()?

In swap_device_disable(), si->flags &=3D ~SWP_WRITEOK is performed under
swap_avail_lock, and then both swap_avail_lock and swapon_rwsem are released
before del_from_avail_list(si, true) removes si from swap_avail_head (or
masks si in swap_queue after the later commit "mm/swap: add priority queue
for swap device allocation", where percpu_up_write(&swapon_rwsem) also wakes
readers waiting on swapon_rwsem before del_from_avail_list() runs):

mm/swapfile.c:swap_device_disable() {
	...
	spin_lock(&swap_avail_lock);
	si->flags &=3D ~SWP_WRITEOK;
	spin_unlock(&swap_avail_lock);

	plist_del(&si->list, &swap_active_head);
	total_swap_pages -=3D si->pages;
	atomic_long_sub(si->pages, &nr_swap_pages);

	end =3D ALIGN(si->max, SWAPFILE_CLUSTER);
unlock:
	percpu_up_write(&swapon_rwsem);
	if (err)
		return err;

	del_from_avail_list(si, true);
}

If a concurrent order-0 folio_alloc_swap() selects si while si is still
visible as available but has SWP_WRITEOK cleared, it calls
cluster_alloc_swap_entry(si, folio).

First, alloc_swap_scan_list(si, &si->nonfull_clusters[order], folio, true)
isolates each cluster ci and sets ci->flags =3D CLUSTER_FLAG_NONE. Inside
alloc_swap_scan_cluster(), __swap_cluster_alloc_entries() returns false
because !(si->flags & SWP_WRITEOK), and relocate_cluster() moves every
non-full cluster onto si->frag_clusters[ci->order].

Then, for an order-0 folio, cluster_alloc_swap_entry() enters the
higher-order stealing loop:

mm/swapfile.c:cluster_alloc_swap_entry() {
	...
	/* Order 0 stealing from higher order */
	for (int o =3D 1; o < SWAP_NR_ORDERS; o++) {
		/*
		 * Clusters here have at least one usable slots and can't fail order 0
		 * allocation, but reclaim may drop si->lock and race with another user.
		 */
		found =3D alloc_swap_scan_list(si, &si->frag_clusters[o], folio, true);
		if (found)
			goto done;
		...
	}
}

And alloc_swap_scan_list() loops while scan_all is true:

mm/swapfile.c:alloc_swap_scan_list() {
	do {
		struct swap_cluster_info *ci =3D isolate_lock_cluster(si, list);
		unsigned long offset;

		if (!ci)
			break;
		offset =3D cluster_offset(si, ci);
		found =3D alloc_swap_scan_cluster(si, ci, folio, offset);
		if (found)
			break;
	} while (scan_all);
}

Whenever si->frag_clusters[o] is non-empty, isolate_lock_cluster() pops ci
from si->frag_clusters[o] and sets ci->flags =3D CLUSTER_FLAG_NONE,
__swap_cluster_alloc_entries() fails because !(si->flags & SWP_WRITEOK), and
relocate_cluster() sees a non-empty, non-full cluster with
ci->flags !=3D CLUSTER_FLAG_FRAG and appends ci right back onto
si->frag_clusters[o]. Because found is 0 and scan_all is true, wouldn't
alloc_swap_scan_list() spin forever on si->frag_clusters[o] (and also leave
nonfull_clusters drained into frag_clusters if swapoff later fails in
try_to_unuse() and re-enables the device)?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1793106426.gi=
t.lianux.mm@gmail.com?part=3D5

