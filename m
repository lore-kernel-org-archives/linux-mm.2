Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F256CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 01:56:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A76A8E0008; Tue, 11 Nov 2025 20:56:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 929ED8E0007; Tue, 11 Nov 2025 20:56:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819128E0008; Tue, 11 Nov 2025 20:56:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66C0C8E0007
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 20:56:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 095A2160283
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:56:07 +0000 (UTC)
X-FDA: 84100289574.17.4188921
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf10.hostedemail.com (Postfix) with ESMTP id 13E74C000C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 01:56:03 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TmYpnGV3;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762912565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UBuA1/Lj8w03kZCEoicnR0iXOgCaZCHxQwdHH9zt7bc=;
	b=xssEsNy6R1yQs7N0udKyVjxPPMFVsXzwfvbVCbzIWEkMAABbOj+83Q2RnnRFsxBu+hSFyc
	EL128fecU2gSJsh57gPJJMKyhMqQvZcA3AmUsG0VXn8Q8/oIQFk5w19EEhkeeqkNhjcYdh
	OSF0Yp3LaV9uAZqeQj7hM19GUIgQ5p8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762912565; a=rsa-sha256;
	cv=none;
	b=7QcyR4jATbL1UWmpIttnLmIdhK2p8nOMhxolKkA+qbM7TNkNtrwd8kRg6oseAwp+FMu90L
	YsGQLEEiWoMN1i3rC7kF09mJ2qbM3DQ84hZda5SCwE7qu+gHj62WEQSQceNPjclvvgumnT
	34cLdPxHMq8hmXjHgfRz7KWFWE0HENM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TmYpnGV3;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1762912561; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=UBuA1/Lj8w03kZCEoicnR0iXOgCaZCHxQwdHH9zt7bc=;
	b=TmYpnGV3WYTJdOO2ZyOguEC8WXRfQjPWw58fCUDnRZL+lMcJddHfjnS5EoSMLgfxpkPqHtWzzfaObmZuagjN7Bv3C6UM7gdnT4DE7ml76IKNR9Eq1c2ISFiw/ViekHkaaAw4nJXjlkee0oIfHvHPIAfeV0WobtoFl0M+Hp8B6tE=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WsENh76_1762912548 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 12 Nov 2025 09:56:00 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  Chris
 Li <chrisl@kernel.org>,  Kemeng Shi <shikemeng@huaweicloud.com>,  Nhat
 Pham <nphamcs@gmail.com>,  Baoquan He <bhe@redhat.com>,  Barry Song
 <baohua@kernel.org>,  linux-kernel@vger.kernel.org,  Kairui Song
 <kasong@tencent.com>,  stable@vger.kernel.org
Subject: Re: [PATCH] mm, swap: fix potential UAF issue for VMA readahead
In-Reply-To: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com> (Kairui
	Song's message of "Tue, 11 Nov 2025 21:36:08 +0800")
References: <20251111-swap-fix-vma-uaf-v1-1-41c660e58562@tencent.com>
Date: Wed, 12 Nov 2025 09:55:48 +0800
Message-ID: <87ldkchv4r.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Stat-Signature: h8eyshn1qd414u4u7sa7o43e7wbkpixy
X-Rspam-User: 
X-Rspamd-Queue-Id: 13E74C000C
X-Rspamd-Server: rspam01
X-HE-Tag: 1762912563-262925
X-HE-Meta: U2FsdGVkX1+4g53UF+dPRsNGYeTdHtKi0XTVq+byiCGUn1EvosGvLyPlnw2iUryq64KxnEGEJrN505rM+iygEdm/t5oY/vgupeCHOcywhMJsgpCkyM6Vj5qkrdVmBWBpfnMjB4k7wsLhnUCe48U67MaE4Iq2yHMxV/4eRpgDQazk7rk0+sWfr18xcg5I80hbWjQVqfFG5i+z53ivgmtU6jCwjuaCTrBH3uqkOQES9GQs2meQ8OE/lS7apn6B+tGvJwA1sSO/anDZJ0wQ3AIJstnPTdP4VuJZGEqlyIsZectp0obij/743puAx8OLave0uSBzKp1Ye8CagsLphWlNUoEqdQleokgk/3Zv1KT8p8IHhKs8AfQIT2twnun9F2NrPxSvLK3CR+0HawZipYAxGv0SWIyS5bXJZQ3uqgrjGSRH47EwxSKnKp8od8QOEc61SizyUQiFFqOwqstWisKkC0APVImZROAkSqnRaFDhL5KMDLxWDpTng/D1I9FpmakP01eRUQLn4azf9/YBKl+mU4AglfF/YRof0TGENoLnpqknlIhWKb+3MPgfJYxX1t48cNB72V8OCrIDfd6wgV+DM03O/+s1tBdcHtHkzJMNc1+uCA76oydNeJTaRKbJrj79JZWsYqVC2YV3Xkn9xI7KCSPsCtG3QD1WlrylLNcIAG4e2+Xp3XErcI44bJaRHA9dmJQpD0XiFn2yijzqHqgtcL4iCj8Hzjx8zH8xusUB13Kny2mXioWgo5YXBJk8gGg3/Pv8UoTCFBGvXrorVwKF6QSghhu8nkGdyUrIiUzcbglt/A17l15HgRTkk0chk2FqCqd66JP+9Jy69kD8mfqOkgVM4TlipVT24Cge0jZ9gfiN7ao4usKbLixE07lexKbqono3aV09bXbPfRHbrllAwdTdahl+wBQyB9Gd/HhAIDQ0csAD1WUR6+4QJLnhcZwggkTm+O+I0xid5djDb8p
 mJxbgtXl
 T5q91xuZdM8d5XPEgWdTmfxX2u+e6iCcuwXs1Gagbt5VZBoPKAFMLI5zO2mH0vKRSP/ezDDSsBoT7Lr4a3XKJghT0NyUL0AIbLIKvO+jYwKaohiydTcAqf8/g5tzK3qCvgxi5Gb0Bkas+7BpcjPbu/oovSFhcwOusvwW1V2Q1q14NVlEnlhCANBq2iHzZshJLCACvu0cWfXFTUS3WR8kqbbfu8VEVDtw0tiAR+gsTqYkbvkjMM7EFgVE+sWeIuRbQFmQCsINB31ta7r+b6cpkNdsSy3KoMd41/tYMvxT4ByCXyfkoVoBkcz37mD7C4nl7c4QO7gaJkIDL94s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kairui Song <ryncsn@gmail.com> writes:

> From: Kairui Song <kasong@tencent.com>
>
> Since commit 78524b05f1a3 ("mm, swap: avoid redundant swap device
> pinning"), the common helper for allocating and preparing a folio in the
> swap cache layer no longer tries to get a swap device reference
> internally, because all callers of __read_swap_cache_async are already
> holding a swap entry reference. The repeated swap device pinning isn't
> needed on the same swap device.
>
> Caller of VMA readahead is also holding a reference to the target
> entry's swap device, but VMA readahead walks the page table, so it might
> encounter swap entries from other devices, and call
> __read_swap_cache_async on another device without holding a reference to
> it.
>
> So it is possible to cause a UAF when swapoff of device A raced with
> swapin on device B, and VMA readahead tries to read swap entries from
> device A. It's not easy to trigger, but in theory, it could cause real
> issues.
>
> Make VMA readahead try to get the device reference first if the swap
> device is a different one from the target entry.
>
> Cc: stable@vger.kernel.org
> Fixes: 78524b05f1a3 ("mm, swap: avoid redundant swap device pinning")
> Suggested-by: Huang Ying <ying.huang@linux.alibaba.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
> Sending as a new patch instead of V2 because the approach is very
> different.
>
> Previous patch:
> https://lore.kernel.org/linux-mm/20251110-revert-78524b05f1a3-v1-1-88313f2b9b20@tencent.com/
> ---
>  mm/swap_state.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
>
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index 0cf9853a9232..da0481e163a4 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -745,6 +745,7 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  
>  	blk_start_plug(&plug);
>  	for (addr = start; addr < end; ilx++, addr += PAGE_SIZE) {
> +		struct swap_info_struct *si = NULL;
>  		softleaf_t entry;
>  
>  		if (!pte++) {
> @@ -759,8 +760,19 @@ static struct folio *swap_vma_readahead(swp_entry_t targ_entry, gfp_t gfp_mask,
>  			continue;
>  		pte_unmap(pte);
>  		pte = NULL;
> +		/*
> +		 * Readahead entry may come from a device that we are not
> +		 * holding a reference to, try to grab a reference, or skip.
> +		 */
> +		if (swp_type(entry) != swp_type(targ_entry)) {
> +			si = get_swap_device(entry);
> +			if (!si)
> +				continue;
> +		}
>  		folio = __read_swap_cache_async(entry, gfp_mask, mpol, ilx,
>  						&page_allocated, false);
> +		if (si)
> +			put_swap_device(si);
>  		if (!folio)
>  			continue;
>  		if (page_allocated) {

Personally, I prefer to call put_swap_device() after all swap operations
on the swap entry, that is, after possible swap_read_folio() and
folio_put() in the loop to make it easier to follow the
get/put_swap_device() rule.  But I understand that it will make

if (!folio)
        continue;

to use 'goto' and introduce more change.  So, it's up to you to decide
whether to do that.

Otherwise, LGTM, Thanks for doing this!  Feel free to add my

Reviewed-by: Huang Ying <ying.huang@linux.alibaba.com>

in the future versions.

---
Best Regards,
Huang, Ying

