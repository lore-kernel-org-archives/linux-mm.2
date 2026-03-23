Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2592EF483E5
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 19:13:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F44C6B008C; Mon, 23 Mar 2026 15:13:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A49A6B0098; Mon, 23 Mar 2026 15:13:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BAED6B0099; Mon, 23 Mar 2026 15:13:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 19F936B008C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 15:13:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE4E51B7D04
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:13:17 +0000 (UTC)
X-FDA: 84578276034.14.7C439C1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4E1852000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:13:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TAMRB8qX;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774293196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KlzULqoQ84/ebNDKgI8EHbgoT07RImvXkUuhC7dvd+E=;
	b=pjbAbD9h0Vu5lAxWLIg5pofkfAekKVCR6fDcjohKwvD71NM17+Qf5YyHUPpa0tVWVh5oz/
	MCJVI9qrlkpOO7Jdyxu7eK1/YMcstEgoYNV+Smho+HDriqllsc4VfkyXdq4VDLQnRv0hWX
	wp2636IBqlnX7Fgp1XCMajpNV16dRSw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TAMRB8qX;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774293196; a=rsa-sha256;
	cv=none;
	b=FVJDb6L2m2SyWmF0LUislTr+1VVJZ2rTSonabOQ3W56DNLe/vMzFhbABSslBlT4njqyMoW
	kfGQ/rNs2Jzbv54y+Acas1raFSnepaK1/TdCdZ/zK3cTmM3CcaZz1zxjsFn9P37oOLZg4F
	DYXBqmccSOFnageMGuwZitzBxJlg7AY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DB0F434DC;
	Mon, 23 Mar 2026 19:13:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9C5C4CEF7;
	Mon, 23 Mar 2026 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774293195;
	bh=YPvCdw6C6+qB9yiSepX6OYKDZRFLBohSuc7vCWJMFPI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TAMRB8qXJk10MxytYpTANIJOrkT9qs7dbZvwtCcqk881kLgNewAwXxSzLkyFca/bM
	 3IpTnTkYr6HEyeyXNs1ZbUHQ62mOcqhfGchZcGpyks1Q4Hx9ebnnMu3MdXwa/xK5zf
	 KZ6SDeOCMVWczyd7p84hZnY1XR9YGMWRXDbkGZfg=
Date: Mon, 23 Mar 2026 12:13:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: David Carlier <devnexen@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, YueHaibing <yuehaibing@huawei.com>,
 Mina Almasry <almasrymina@google.com>, linux-mm@kvack.org,
 stable@vger.kernel.org
Subject: Re: [PATCH] mm/hugetlb: restore reservation on error in
 hugetlb_mfill_atomic_pte() resubmission path
Message-Id: <20260323121314.ab3c389ae368c0179624de8c@linux-foundation.org>
In-Reply-To: <20260322052120.14021-1-devnexen@gmail.com>
References: <20260322052120.14021-1-devnexen@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 5maj5zds3f91hre9oys9mb3q9mfogdqx
X-Rspamd-Queue-Id: 4E1852000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774293196-272563
X-HE-Meta: U2FsdGVkX19rwCZhjwkT6iYrEjMoglui/08amEbFJ8JssKl47f1aIw1rlOJeO6UFi6zj1n8UJq/PloaVjc+5c91FCgZX5QkQmPPS4AEFsvAC/cTRp8+RYfoinxfHxqRl7/eZvjrj+G48wfhqDT7WYaTlR22Rr+/FeLv4etVNxIXucFKqI+Lsu59O7Y+lWHdWiLuIdK4F8MBQ3szGRaskMAi6/BTjpBa/eSe+LtdgqV+PqAtZUjzzwNaZ2DUnGklVVeAfYNS3Cd3Tv+BOUhHVX5VWU0BDWUzS81eR0gdBki3EI4grkEdRU4TLrd6ssO9uKGgq7T2lCAkTSnAS3oxTA0xWx7dKflJqZql/Zpxr2+BwZ+fwAcvwqxVGUXQ6XEFqEEGeJXQ75yK/KITkM9vSdbBzfhxDxAvYccxvBY3nwWAkiyW70MmsiL1uv0Quzxg0xGaGBDzqARXtkzUmQdjLWFKuNuInME1pbRzX7w8/aTzwitku3kjyGoHHmAWxtoB/jACnR8RqHhi1m4poLYX0i8SrvQEAT15M38hC3Yc597qY0C7tZKvEE435kg/2X7xCMhwzp0BdoxJjGK861rqhLT7YnSq+xt2xgzi8RJwlgI5EZMEdtSXXBjN/mNIjsFXUOgSkqOag7rv0swWQhwC+kUBCnWIoN7R8NbUqb12eKOmzVcD8bF9ZDaFkhwGflwhpB4eq9PjyU8RpvwZM9RDKav+aaueIkBTQZxRzq/wNDmA69sv1YRd4heTzwe+VGVq1dsxCsTl74p1jJGeh/IZ4pgpeaPLyKkpTvhCw449leB2Xl3Oh9E+C6cSG1ub91UHqGRbdlRLqHZrEVj0qi1wzSXAv2IqP2G5Aewo8aEPNFe/QhW8aRNwv3B7/9OVYx8XqA0NvXHEWgx4LKi61amv3VnhKeyDNCjugADKWNFpgrk/KcIGg2sbBmP4xODWClsFG2nep6016lNy8adUU92j
 /IsiXDq+
 3FXtC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 05:21:20 +0000 David Carlier <devnexen@gmail.com> wrote:

> When the resubmission path in hugetlb_mfill_atomic_pte() allocates a new
> hugetlb folio via alloc_hugetlb_folio(), a VMA reservation is consumed. If
> copy_user_large_folio() subsequently fails, folio_put() restores the global
> hugetlb pool count through free_huge_folio(), but the per-VMA reservation
> map entry is left in an inconsistent state.
> 
> Add the missing restore_reserve_on_error() call before folio_put(), matching
> the first-attempt error path which already handles this correctly.
> 
> ...
>
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6295,6 +6295,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  		folio_put(*foliop);
>  		*foliop = NULL;
>  		if (ret) {
> +			restore_reserve_on_error(h, dst_vma, dst_addr, folio);
>  			folio_put(folio);
>  			goto out;
>  		}

I guess we could goto out_release_nounlock here, although I'm not sure
that improves anything - keeping track of the value of
folio_in_pagecache is rather twisty.


