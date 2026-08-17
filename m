Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52E39C5CFC1
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 05:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2EA8A6B039C; Mon, 17 Aug 2026 01:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C1EF6B03A2; Mon, 17 Aug 2026 01:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DA1D6B03A3; Mon, 17 Aug 2026 01:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC9856B039C
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 01:51:44 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69CDE1406B3
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:51:44 +0000 (UTC)
X-FDA: 85109689728.02.611B3AD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id C8111100002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 05:51:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2gKdWFh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786945902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49GLJIYRy4vZ3cG5rYKQJNFQilEnE70SWvjy9to5mKY=;
	b=UClqhw4rY5xYyAZAmjgMAywvLFhhGrFVLYlhviUCsLPetbEaI87fRdYFtq+ar8Cnxw+DT8
	+4+YgiWOtUxDcE1fdKiXngHOS44WfcFDs65Wpm6VcioedITASsl8tzlY193/DhlsWyuCYe
	e2Vh3/MSQt9ATBaCIBJWPIWPwauQr9s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=E2gKdWFh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786945902;
	b=34wbaoBtArXif6b6k/rgBFZ3uXit2Q7AUfrNBK2sjKq1m0t6yvQrDfOFP2xCpX6AvlJsJm
	raIP71JGW0LwpQaRqt//FXJ0O1p+UED6KYEgMPXhr7GA8cWD9HGswH3Vc+kCBVdbw9GjCc
	2gZSZgnzpJ6f9hy/n8f2tM51SJMPeXw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C47F943990;
	Mon, 17 Aug 2026 05:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF9EC1F000E9;
	Mon, 17 Aug 2026 05:51:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786945901;
	bh=49GLJIYRy4vZ3cG5rYKQJNFQilEnE70SWvjy9to5mKY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=E2gKdWFh05E+WTUIOy6fVlmJoZ3AvzL3kKF6IpS67NmfM0FfdNGCl0v01yMKbnGC5
	 gdYwLQP5f3+qFGLh37gfG4MPQtnrkZ/Ly5TzzUuhdbxJEpKQzEOewIjVencSyP5sWg
	 qePR8aIdDUEXfbYtP2RFGB7IRpDpKJR3GnykUJ5p1yZFfcoxDTNJNy80cVP7Zr10ZY
	 o6S9F93N96hliFB9V0GwS0CS0qP5agd9pNj/qum8Hcal7Syo8NGbz0OdNbKfOqpKWA
	 zjROHDvoZF+n5TBVvlruFBx7pLDYILQsS0OoalotCdVlBLjku764siAifLFJzQ/S6M
	 X8q/9FNobYH5A==
Date: Mon, 17 Aug 2026 08:51:34 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Kiarash Azarnia <kiarash.azarnia@gmail.com>
Cc: pasha.tatashin@soleen.com, pratyush@kernel.org, graf@amazon.com,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] kho: fix signed shift UB in
 kho_preserved_memory_reserve()
Message-ID: <aoKhZqkTNUJGpOEf@kernel.org>
References: <20260816090038.3117276-1-kiarash.azarnia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260816090038.3117276-1-kiarash.azarnia@gmail.com>
X-Rspam-User: 
X-Stat-Signature: mgorob51tf69g1p5818ysjeaxe67x77w
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8111100002
X-HE-Tag: 1786945902-713049
X-HE-Meta: U2FsdGVkX19QkzD5AUnr0mO6Yd2LJa2gP+uUn5zlBe4BmkL7JYcHHHevVZsBc2gXTsTVGJcCEIIwGffhYWQXci41fcciFTgQlDeXVdjZVMLSPuNs1d9RDVbuvNNysCHRn5usHR4SjocshKOEolMxWD/0nVIkEBt3kE8UYtDxfTFD+FLnNnF0xaGR5mQ6XMj6jSd9BLvmxrIMdm+y5/mpCgmSslo0ZZksab1n/ao4wCOPgM3Nyb8IoiiOpvkk/uoU8mOAEIp+ijYaQPtTs9T2EIc3TfDk9tCCLHQNaOu3qtgJ0LSNgre2e3lYBoqvbmPIernMSsF3/K+NWQuesbDKxhQMIln7Aj3a5iMoPG9DdM1VYcYw0FVZ4kruFImI2om1HVSCsemx6dzK0LzcaXQGNXluxhAsjfP5q9+VA3xBllGP5DC2hhDHYUMXbZLY9hie66pOq6cSrowWYPQ/v9zJ94KLlQuGaZVBeGGUrZXgX+ZmG27yyCmLQWkSmUmbfZR2Vb3FU2oFZodwO3e+VgwGN9mLA4pfKKAErqbhQ8CdsRrYK3bcAJ/3FX6NUHwDmjuTmvTeSwsaUurLFQehVdUgmillj9Cs1APeu+oJVZULahfZosCcYVREtL+BBd02vlOrLGZ491X8puB23Lt4G54ZR0O1Q7RjJuV2cpwhYp2TT0vGMJCfxaTgMo6CEucE0ivHOcRb05wVd1eqVhTrkYTmSQxK3/9jm+W//UjDeFWPyEkXYnrzb5tXVZsEH9iORxLzOZTQbRQYivwf1NjfWouGas3smjnDLukhNzC/Dn1gy+9qq2wulZ1p3rRsCKjVubpxayKUWhmLnpfDNIoYT+cWh2LYV0Lt/wu31W4tmds64Duhk90wEyzU9sgO6KBUgLzE4gh4id3L5OqoM9iI8up/UVVZyqxOIdGpRByyK84pMXTLNCQ7s8y66Rb0u4d4PVTIBeGYAQApm7AAQTbiWDt
 vQaGkrDy
 YP9MArdTYro/mfzSMzWM0x/eT9QLO9vI3O2w+pex3PbqFawiq465JjF24k6QIgy5qOLn8fITiYz6gFlDQ1ybHI0IH0ooE2jm7Pcy1gERqROvJsoaeWhPWaIu3JkikO0WguGy2yARvVfihzzKJ9zrAXlgBWTYd0Y63ikeEZsWGHzSXBuJmT3+vHxGKQETObYhmktiMwwxJim4B73ATlE/vh9OdG+/Pk3QxLnpVIS/0wRUtoUJ7Z8UxJSdGr/hNPpcdbpwyrEnsn8EGjfLtYwdMPc2KNcsPfK7IC6VSu++oO0Cqr+YqOi1Vzqt+uo9lCBYcK94RGVQedcJQgMmfJq1tsSrpaMx1+yPMzX9tXkjoC6AaHs4Sfh0XbM29oBnqinni8qlGebbkVGmnG0ZMWOyj202W40/eJhxaajSKuQ8arhhraoGB2WN636iGKyG+PWB7M2+LqhfinTPwNFLldGyYubFWL6Fa5vLWX84lWTZCIPbDJ1NIrYAeN5GL84azMDgkYVr0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 16, 2026 at 12:30:37PM +0330, Kiarash Azarnia wrote:
> kho_preserved_memory_reserve() computes the size of a preserved
> reservation as:
> 
> 	sz = 1 << (order + PAGE_SHIFT);
> 
> `1` is a signed int, so the shift is signed-int arithmetic. For order
> 19 (a 2 GiB region) it produces 1 << 31, which is unrepresentable in
> int and is undefined behavior; in practice it yields 0x80000000,
> sign-extended on the assignment to the u64 sz. For order >= 20 the
> shift count exceeds the width of int, which is also undefined. The
> return value of memblock_reserve() is ignored and memblock_cap_size()
> clamps the bogus size, so the kernel silently reserves the wrong
> amount of memory for the preserved region.
> 
> kho_alloc_preserve() caps order at MAX_PAGE_ORDER and cannot reach
> order 19, but a boot-time reserve_mem= region of at least 2 GiB drives
> kho_preserve_pages() to compute order 19, and kho_preserve_pages() is
> EXPORT_SYMBOL_GPL(), so the path is reachable.

This looks like LLM generated, please make sure to add Assisted-by tag next
time.
 
> Cast the shift operand to u64 so the arithmetic is done in 64 bits:
> 
> 	sz = (u64)1 << (order + PAGE_SHIFT);
> 
> Fixes: 3f2ad90060f6 ("kho: adopt radix tree for preserved memory tracking")
> Cc: stable@vger.kernel.org
> Signed-off-by: Kiarash Azarnia <kiarash.azarnia@gmail.com>
> ---
>  kernel/liveupdate/kexec_handover.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 175c08a6e41e..c79f48bd64ac 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -501,7 +501,7 @@ static int __init kho_preserved_memory_reserve(phys_addr_t phys,
>  	struct page *page;
>  	u64 sz;
>  
> -	sz = 1 << (order + PAGE_SHIFT);
> +	sz = (u64)1 << (order + PAGE_SHIFT);
>  	page = kho_get_preserved_page(phys, order);

This is already fixed:
https://patch.msgid.link/20260727150240.889555-1-pratyush@kernel.org
  
>  	/* Reserve the memory preserved in KHO in memblock */
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

