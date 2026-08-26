Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1022EC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 07:50:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA24C6B008C; Wed, 26 Aug 2026 03:50:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53536B0092; Wed, 26 Aug 2026 03:50:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D41A36B0095; Wed, 26 Aug 2026 03:50:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC93A6B008C
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:50:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3AD9F1A02A2
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:50:00 +0000 (UTC)
X-FDA: 85142646960.03.1406AE8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 85EC6100005
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:49:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NT9RDS3I;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787730598;
	b=ATF3jlBo+eUhbWx5rOqIBk0r55Y8D09mCh2TjkG7qoszCdfPjDJmZlgqoVQ2kAi05ZWm58
	DLb89cKyg2cchf27/VMAtJn51H44q21Jhn6wGQcT/bpDG7cunzmz2XmCpB1VuXamczjQnk
	/EraaK8jAW/Amde74PDyIs+PXL4tD/Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787730598;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31F2mnvxq2qWqjVX4eHj0SWEUOHU/pDwGd4gxco3vwk=;
	b=vYFoS4E6upMmjWYBsgLgy1MGq2P1q/il0V1aL/IGBaXXSZP/0PLDDZzpH3cS8kpHyXzQTP
	BfSezW6Mjw2iXv8pAQQFKJioBgPSfcL1thYdY+94ArJ4iTvJhKfRVlxhFustKtbTIzQQiT
	0EmHGiyTb9AKyxcJ6lDVC6Zu6Y3FX48=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NT9RDS3I;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0082B601E9;
	Wed, 26 Aug 2026 07:49:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 181821F000E9;
	Wed, 26 Aug 2026 07:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787730597;
	bh=31F2mnvxq2qWqjVX4eHj0SWEUOHU/pDwGd4gxco3vwk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NT9RDS3ImUoPGQIptssHDPPOYnlqTeTk5eiSTWked48RFRjYMoCGCTbTDz/Wpzso0
	 YLEiAdczW3Cd/y1baDAFXECatnMq9bDxdm8sfwnas+mKhbhR0rBeBrIDseo4PE6k6d
	 9wH6k35Q+kZ28j2zCIHP1uF5wno69VY1esWngoy1WIOa2xCVtlLURrs6xzACzO5gs1
	 wEmuA2sSle4f22exHzxXYzkscHjy8WLxmjkPE7LM5iF6TuAHtNOXolJ4dJPimt4diO
	 YBg2e+rxFWtVSK17Ng/kY6z5yCkl1MZPcli8EJKFFaN3BDNKtWgQZL6lzfLYj0aOeH
	 /atyhy1MxhuuA==
Message-ID: <c44e5924-091f-43ed-8cff-34e87c3d9763@kernel.org>
Date: Wed, 26 Aug 2026 09:49:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/gup: add NULL check for unlocked parameter in
 fixup_user_fault()
To: Liu Dalin <liudalin@kylinsec.com.cn>,
 Andrew Morton <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Deng Yingchao <dengyingchao@kylinsec.com.cn>,
 Qin Yungao <qinyungao@kylinsec.com.cn>, Luo Qiu <luoqiu@kylinsec.com.cn>
References: <6D25DBDC7BEC853D+20260826063124.3255387-1-liudalin@kylinsec.com.cn>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6D25DBDC7BEC853D+20260826063124.3255387-1-liudalin@kylinsec.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 85EC6100005
X-Stat-Signature: brpnjayetu53kshhoik51t4q839zpe8i
X-HE-Tag: 1787730598-347751
X-HE-Meta: U2FsdGVkX1/n35e/xKVo66ZfDMv9GQCjmGBJy5VjLgzxvv8XghGX/x+aSPBcL6N0PtAOBfrmCM2BIh3o8OpPqcSixzesJ+iY3f+/1WbPLInYcgCQu4y976Y3RKyv0m+c2arckLwvbSU7os9k+t+XtbmdwxTnR4EfYEYzkJg07IMjExtw585lFAxRUw834/zH51OMOE0inwJPpGFqOFnEN5rYTFfaXDGnMM725bLwUHW3bBzXQwh8zvBQ9iY0yvsOVAmUSZ/S+fAHCJOPgh9CdcvQuscX82Sk5JFWPhGln59n5wifVzrLYFt58tq4R/xvQBoRyH0HXd2uGn3AkK6mrOGQD9ND8D4q8ozPqKcBdgkvPdcZCULJRxgTRSw636/w3j5cxSMDfTgVxElEABUADS/Yve2d0IqnImxSXFH8Ib5papOfAn7dEaETMq6ua2d3lngK/4H3CtFOlJzkLaOkWIfRxKnC+zDE0RF1YnL1nHKSg59bwjNoOj/fyDCLY5WLNl2oJ9qef46XjdyRZYBA+HKnQHvfUyFOathKL/4UnMz3Si6N+638DfdjOmPzVS4pRRN2z99AIuAaqbLLGooDlmqe8g08jBwujNrvWvsysLZA/lZna6wOfPTEQm84CEj+msyLxRORkQ73hf5q2Jek0BgIwwyQa7JXmG6SsSAIukslv9ctgej0S9K385Lu223Ew2O1VAGxFOpDdUAAiSkvYUxdS2zH8ZCFhKTuzdkd7n5n9QkR1dqfJqSEVQqkFu/rYVOcm3ICAu/AYNv3J5Sgvb4aqBt0xqfChsdWMz3NMnzkSWhYtp2K77P46Ks8U9GzW7h0bsQET7DSkfUGnvDGZl02ieP6stkOFLtY09Y9HdTJ9Pk2Fr8d/pE8Qi78uVMHyGi+ikeTBCMvr2y3HSt5TBdMqhQvINSytxqcVg+pjHWZ9brCoIv/XfJXAtM1a95xuY6I3jcPXIq+G+jyjFo
 Fp5kQzlx
 Keu/pE50hD1Xl6OvYEA/iF0Lrw2wo4kkMG+TBdja5anLn1MMV9RgLSqlnGvKDE3HqC60xZ7/uPYdbuz9c6d/+8PZqQckiLDmlrFuvssEoT+dFbeMEReNyMEIu0kvvNCpXk98JBdA8pCpiyb/+SlBmDRuomUxZihUZ3jwDTbI76J5+apQKi4370DDC4fRFy2q1SKUd2HnpMfAZOIycHnagRJ4i6NyaNpBuRAyz2dFsRIIDqV7zNAARgj3z45DRDfZ/EUH+cesMjLFDAzhMy6Uuf20QNHaNaFMhfN3m3kUqWUV/XhkGg/5AdxWX9X7N2WjgtC1vv2iROEVOIYRq+sx2rnAN+vKLe/EZzFoefiMzdF9C7LE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/26/26 08:31, Liu Dalin wrote:
> While the current callers either pass a valid pointer or explicitly
> pass NULL (indicating they don't need the unlock notification), it is
> safer to add a defensive NULL check before dereferencing. This prevents
> a kernel crash if any caller passes NULL and handle_mm_fault() returns
> VM_FAULT_COMPLETED or VM_FAULT_RETRY.
> 
> Fixes smatch warnings:
> - mm/gup.c:1597 fixup_user_fault() error: we previously assumed 'unlocked' could be null (see line 1573)
> 
> Fixes: 4bbd4c776a63 ("mm: move get_user_pages()-related code to separate file")

If this is not an actual bugfix, we should specify Fixes:.

> Assisted-by: smatch:2.0 [static analysis]
> Signed-off-by: Liu Dalin <liudalin@kylinsec.com.cn>

You seem to have sent this patch twice by accident. :)

> ---
>  mm/gup.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 0692119b7904..d12475a7f7cc 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -1594,7 +1594,8 @@ int fixup_user_fault(struct mm_struct *mm,
>  		 * could tell the callers so they do not need to unlock.
>  		 */
>  		mmap_read_lock(mm);
> -		*unlocked = true;
> +		if (unlocked)
> +			*unlocked = true;
>  		return 0;
>  	}
>  
> @@ -1608,7 +1609,8 @@ int fixup_user_fault(struct mm_struct *mm,
>  
>  	if (ret & VM_FAULT_RETRY) {
>  		mmap_read_lock(mm);
> -		*unlocked = true;
> +		if (unlocked)
> +			*unlocked = true;
>  		fault_flags |= FAULT_FLAG_TRIED;
>  		goto retry;
>  	}

smatch doesn't understand that VM_FAULT_RETRY|VM_FAULT_COMPLETED implies that
FAULT_FLAG_ALLOW_RETRY must be set, which implies that the lock may be dropped,
which implies that unlocked is mandatory to be specified by the caller.

Checking for "unlocked" when we just did a mmap_read_lock() does not make any
sense, sorry.

Is there a way to teach smatch about this differently?

VM_WARN_ON_ONCE(unlocked);

could be used, but I am also not quite happy about that.

-- 
Cheers,

David

