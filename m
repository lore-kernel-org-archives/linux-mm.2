Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81D3B606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 05:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HomJDfQj
Received: by kanga.kvack.org (Postfix)
	id 14BBF6B05CF; Tue, 10 Nov 2026 00:58:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D3436B05D1; Tue, 10 Nov 2026 00:58:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F04726B05D2; Tue, 10 Nov 2026 00:58:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE9CD6B05CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 00:58:12 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3B9CF1C42D0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:12 +0000 (UTC)
X-FDA: 85418154024.29.E53AF54
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9B5FD1C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 05:58:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HomJDfQj;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794290290;
	b=HyoKMAsDivhzOm/IJ5+Dc/0ic4zJDQAjaMvgd+Ubh+Q2xzKY97UMI8sPFuHkMwI6TLESML
	um8TP+qyobh3tYzxWBP7/weILPjTVCoJ1KAZ6IoqrMrmRkNYHA5xgy2obEh1Y5MlfdTmmX
	ZYk3Mioh6FD9dw2HE8zDD8bhPyQSdCI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HomJDfQj;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794290290;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+xcvBj5oeLw5Mo3RUSlR++4Y9V524/YaZLX+6WblLJQ=;
	b=CqKdYhAU+T6hf5ISpvSR4xNfJzSnwj5cR2+5fCZu5XrlduYNxbNOtAiIBBmjEdmQgDYK1o
	hmJ1Cq5JOesUxpkKWOybDU0KmnEB0j39/GKkib6MZ44P56kKvoerrnh+kfHEgRzh1gkpC4
	1V1AY5/t/0BntA/OZIYQ0gwYGQ/6sH0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 326BF63595;
	Tue, 10 Nov 2026 05:58:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B514D1F0089F;
	Tue, 10 Nov 2026 05:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794290289;
	bh=+xcvBj5oeLw5Mo3RUSlR++4Y9V524/YaZLX+6WblLJQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HomJDfQjfwwYSeYgs8ZHftGpGE5M///gKSgcB+A+sqemEOJ8cZeVhqbDCxIk4pT6D
	 S87inoveWjX9k7xXNn0F007BxQCCVY2xdloOfIhtciWMzxySLM1KDBJcpG3G4Ys89O
	 wzumIV3BGkzmT9Eof1dehaRRf/ZeQUnmhhggpN98unz7/BaA6E/yuc1XDARPAIp02/
	 3e9yRc7ZDj9IhCD5jHITB+7veCtfNh86FaZlf4p6ERsHJOCQf3m1HwSjjetOVRO0rI
	 VHutLDKUEznGBIkj+Jhfu0x9aFUeFSsUjAGCFthP7IcccvKZKy1rpUNvox3QwdIbJb
	 zoOAh6GYvvTWw==
Message-ID: <sashiko-outbox-206377@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 18/19] mm, swap: do not give an xswap slot to a
 cgroup that cannot zswap
Reply-To: sashiko-reviews@lists.linux.dev
To: "Baoquan He" <baoquan.he@linux.dev>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, david@kernel.org, chrisl@kernel.org, kasong@tencent.com, nphamcs@gmail.com, baohua@kernel.org, youngjun.park@lge.com, corbet@lwn.net, hannes@cmpxchg.org, chengming.zhou@linux.dev, kunwu.chan@gmail.com, klarasmodin@gmail.com, "Baoquan
 He" <hebaoquan@kylinos.cn>
In-Reply-To: <20261109055455.536925-19-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
 <20261109055455.536925-19-baoquan.he@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 05:58:08 +0000
X-Stat-Signature: inozih6szrxpgk6xyxmp9jp8qrekqpzj
X-Rspamd-Queue-Id: 9B5FD1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794290290-419563
X-HE-Meta: U2FsdGVkX1/n6hyDvDDKcB+DhdXEOG8jURh6z/CpquSqrc9M9/PRDF7XhCzikw7sC58NjKYtW5u4VJraIbLEknSqjrX71hNAChKk1UY8oOR0MJRhTfZZswpKTsZ888vy8m/qLgZGn8/Fzh/RpCjt5eis1GutXyv7RlLdIicfb6cCK9sjYH6Qh9kvC+w39zf6oBG7umLssMaUbX60/GPGvpqiPEVoQffzTp96nXQ4eE/05m9Q9I3Fz5VTlbVEVzFTJLofPbblv7/aeuMdMSoo/t85biyX3tBgFcA9vJqpFx/XZvKmRNU3g5yPZ66L+DQvHd9N+hh09JummcywYUE+WB74Wi0OYzwBOPz7+c2QF7fmMZK4xfFi1kq7RRnYXIpSE19KEyyY0mfGSifcvNfzhSVnbjlnWPstuvQzRrBtnDa6ngT7AH+pQ+5ImuJeUpKaXK54frqIj1ymW+wDbalkF4s++vEgNiKCL9W63c3PqVIBYDUk0gUCvX7C4qRKOL9qNiBFuU2iq2qu5xqMAv7hOWxav6O3IHCnSdTESI3jGN24B9A5nTeBOr3kVOOnXPu/YtHKPvUlIdk+sKf9PckWXnjfrkUOP+TQdGEw3F+WcUu8XrNETzL6hGyk2yuAOhTESYGZbVlOq5u+3ROWxGz3XKbl/snROayWVhhMbZ4+KH45eFtae/x0EaVS3eEVE8FcF0JbEts2tyoDzjcL1c7XU2z7eEA5brQhwblXm/oLH0yBCofM7Q1AIuZEwSe3OILzkIowAjW6StrQuHwBq3E0x9eV9XRc8DOrjuE2gRLtGW9y68bMtByFlkTwrpSMMKZgvD4CKnPEEBDMu2rhR572D4VfGDc+MNGL2e7LJzGmxe1psu/758FV5Gn35tG6KdNoQ9Ceju6Buw15UwS7oNo/FNHTD3T03vXw3U96WhBbgqDvZLAJ7GE+QWlSW5zef00kHUBfITR5llA0tBMhksE
 QzC4GiET
 x26VI91Ws1Zk/M8g2jhMcIBbD+a3hmLTL73/lqhjxah2iFQCe8siQEgUGTg97m4BLETamzCwPzTmMzpW2tjyroF6/dlxFUh5xOu1wOeEECe+GQcRc9P5G60ZiekcZGcKPrv6Av1NSusq9SY2sx0kuasFpTN8mvfhphaB+GcfgBBRriHYaIfx7WsZ09V4LhUa2WWM3vFPm+YSWUIsSomZWlq36BtqNXUg5kD6Ve7W8DCq8G7JMXLwpCibn6mdJKWyZ9/6NFlRsLADdAoUleCPEjG2uWGUuhd0knCZAXxEWjqWsCR8Ndd86+g2q+whO2hX8LdB6SMXC80DCpo0k6EUfxYFMdyOB3xASucH+IfdWnyQY5WX1DcHmCCfS9WeL8QQ7qkxlRdsag0udIOd0upUBtPvTcZ4LE/kKqTHCSzbile0go5DlGK1mCLn7XmLreYB1msfvrzzkTiwwrxSmNrXtVPstaj2qE1VoapeFS/kvOByB1p08RxHLXxdReWE+rKWyNqFrNGs2dg1OmvmadkovQyiZ05qwmcV+f5nuHMtuGcuW26n6yxitH63Y6PxwAhwC3ktbiZKOlWVRULDAe6ZjT0c9TSnuVXt9imgJDszSMTs2CS2IR6hyD+MlL4g8eAGNzyIUGN//FcrziR4=
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
- [Medium] mm, swap: folio_alloc_swap() returns -E2BIG when !may_zswap
  has no real swap
- [Low] mm, swap: racy nr_xswap_files check in folio_alloc_swap()
  post-alloc retry
--

commit bd28f08f1cf4ece0de7cacd5579217aa023bae3f
Author: Baoquan He <hebaoquan@kylinos.cn>

mm, swap: do not give an xswap slot to a cgroup that cannot zswap

This commit skips SWP_XSWAP swap devices during swap slot allocation when
the folio's cgroup cannot store pages in zswap according to
obj_cgroup_may_zswap().

> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 2e5383036fdcb..efb48ef716113 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

[ ... ]

> @@ -2083,10 +2111,23 @@ int folio_alloc_swap(struct folio *folio)
>  {
>  	unsigned int order =3D folio_order(folio);
>  	unsigned int size =3D 1 << order;
> +	/* True unless the gate below finds an xswap device to route away from.=
 */
> +	bool may_zswap =3D true;
> +	bool zswap_checked =3D false;
> =20
>  	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
>  	VM_BUG_ON_FOLIO(!folio_test_uptodate(folio), folio);
> =20
> +	/*
> +	 * A folio that zswap will not take must not get an xswap slot. With
> +	 * no xswap device to route away from, skip the lookup; a device that
> +	 * appears before we pick one is handled after the allocation.
> +	 */
> +	if (atomic_read(&nr_xswap_files)) {
> +		may_zswap =3D folio_may_zswap(folio);
> +		zswap_checked =3D true;
> +	}
> +
>  	if (order) {
>  		/*
>  		 * Reject large allocation when THP_SWAP is disabled. Check below
> @@ -2107,8 +2148,8 @@ int folio_alloc_swap(struct folio *folio)
> =20
>  again:
>  	local_lock(&percpu_swap_cluster.lock);
> -	if (!swap_alloc_fast(folio))
> -		swap_alloc_slow(folio);
> +	if (!swap_alloc_fast(folio, may_zswap))
> +		swap_alloc_slow(folio, may_zswap);
>  	local_unlock(&percpu_swap_cluster.lock);

[Severity: Medium]
Does folio_alloc_swap() return -E2BIG instead of -ENOMEM for a large folio
when may_zswap is false and only xswap devices have free space?

When !may_zswap causes swap_alloc_fast() and swap_alloc_slow() to skip all
SWP_XSWAP devices and no real swap device can satisfy the allocation,
execution jumps to failed:

mm/swapfile.c:folio_alloc_swap() {
    ...
failed:
	if (get_nr_swap_pages() <=3D 0)
		return -ENOSPC;
	if (mem_cgroup_get_folio_swap_margin(folio) <=3D 0)
		return -ENOMEM;

	return order ? -E2BIG : -ENOMEM;
}

Because nr_swap_pages includes xswap capacity and
mem_cgroup_get_folio_swap_margin() only checks memory.swap.max, both checks
pass and folio_alloc_swap() returns -E2BIG.  shrink_folio_list() and
shmem_writeout() then split the large folio and retry folio_alloc_swap() on
each order-0 page, which still has may_zswap =3D=3D false and fails with -E=
NOMEM
after repeating the cgroup stats flush for every subpage.

>  	if (!order && unlikely(!folio_test_swapcache(folio))) {
> @@ -2116,6 +2157,22 @@ int folio_alloc_swap(struct folio *folio)
>  			goto again;
>  	}
> =20
> +	/*
> +	 * The xswap gate was skipped because there was no device when we
> +	 * looked. One may have appeared since; check before keeping the
> +	 * xswap slot the allocator may have picked.
> +	 */
> +	if (unlikely(!zswap_checked && atomic_read(&nr_xswap_files) &&
> +		     folio_test_swapcache(folio) &&
> +		     (__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP))) {
> +		zswap_checked =3D true;
> +		may_zswap =3D folio_may_zswap(folio);
> +		if (!may_zswap) {
> +			swap_cache_del_folio(folio);
> +			goto again;
> +		}
> +	}

[Severity: Low]
Can the atomic_read(&nr_xswap_files) check here miss an xswap slot that was
just allocated?

CPU0                                  CPU1
folio_alloc_swap()
  atomic_read(&nr_xswap_files) =3D=3D 0
                                      xswap_create()
                                        ...
                                          add_to_avail_list()
                                            atomic_add(1, &nr_xswap_files)
  swap_alloc_slow()
    /* allocates SWP_XSWAP slot */
                                      __swapoff()
                                        swap_info_remove()
                                          del_from_avail_list()
                                            atomic_sub(1, &nr_xswap_files)
  if (!zswap_checked &&
      atomic_read(&nr_xswap_files) ...)
    /* reads 0, skips check */        <-- keeps xswap slot when !may_zswap

del_from_avail_list() decrements nr_xswap_files before __swapoff() runs
wait_for_allocation() and try_to_unuse() (which can also fail and call
reinsert_swap_info()).  When that happens, folio_alloc_swap() returns 0 with
an xswap slot for a cgroup that cannot zswap, and swap_writeout() later
fails when zswap_store() rejects the folio.

Since folio_test_swapcache(folio) and
(__swap_entry_to_info(folio->swap)->flags & SWP_XSWAP) already tell whether
the allocated slot is on an xswap device, atomic_read(&nr_xswap_files) can
be dropped from this condition.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109055455.5369=
25-1-baoquan.he@linux.dev?part=3D18

