Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5C7DC531F9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 08:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7508E6B007B; Sun, 26 Jul 2026 04:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DACB6B0088; Sun, 26 Jul 2026 04:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A52C6B008A; Sun, 26 Jul 2026 04:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2ED236B007B
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 04:22:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 83CE78047C
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:22:42 +0000 (UTC)
X-FDA: 85030236564.17.056A142
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 148AB40009
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 08:22:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xl3PUy3p;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785054160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9YkF7s/f5ohzh9xFZIei612RvubopdQX8WdLPeQPVM=;
	b=zzz16RPlgLIP+uVOcU2vSUXuK7cW1Xskrm1nEx6AsuIfrOBIH5pGD7KsSyuhEkBiIBiKta
	rLrOwjl/OFzWf/Cx0rymQZY2lal88OERs6khvmDC6bWu/nBBxa82dBBUuyBTQXOKaFcPro
	zaJa+3kASomHsSam9iRHNrD1SZM8mWY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785054160;
	b=tqgk2DxzcVukDXPf1X9eRNtrCU4JlYUWm6Bxj6mANLmyqvwENUa8NCEAy+YM968q7MJhI2
	2TUoumAkRrUGfa3RMcyXEYJXUUakJfsdICN3s7dO3E7TT+tpGhnjPvYOh0eZlynf5Enrp1
	q2/UP5pCp6CPO5O1X4rXu3qxK+8c5PM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Xl3PUy3p;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 02DC42F;
	Sun, 26 Jul 2026 01:22:34 -0700 (PDT)
Received: from [10.164.11.0] (unknown [10.164.11.0])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2C79A3F86F;
	Sun, 26 Jul 2026 01:22:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785054158; bh=4h4dnkwrZ3RZrxJ6YzDW7pZjUySnqqbJvWxtu0QhyO8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Xl3PUy3pyzy3Y+fWxTQkLqWNhQOxOAZD5iTokQiCpBR4W3PFE47C9oioz2kzWcoIR
	 RXMoe5FsA8WuAuAZAU4bogJbqFPDzHBow/1ovtF5WNa3OpS4LKJttecDlVsTSe/9Gg
	 ry4cro7aG8MbO00lmeusdLJ89MPTrMTStI4WgTWo=
Message-ID: <8001e108-62a7-452a-93ef-8e21416a0cd1@arm.com>
Date: Sun, 26 Jul 2026 13:52:31 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/5] mm/rmap: convert page -> folio for hwpoison checks
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, david@kernel.org,
 muchun.song@linux.dev, osalvador@suse.de, riel@surriel.com,
 liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260713050050.1017741-1-dev.jain@arm.com>
 <20260713050050.1017741-2-dev.jain@arm.com> <amMtRejoVMX2IV2V@lucifer>
 <8d2f756a-12a2-43bb-8849-3e71c1ce5d8f@arm.com>
 <20260725190721.f2e121f118ef817e42bb3874@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260725190721.f2e121f118ef817e42bb3874@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1hgh1uth8c6pq97j8prx8b7nsn37nap7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 148AB40009
X-HE-Tag: 1785054159-398492
X-HE-Meta: U2FsdGVkX1/ywSuSfCf+6EsY9Te3bfvz6+asuXoA0oCDM6zl8Yl3mmNZWt+md58pfU9eznFRuGmkZmIZA6lmXhVlj7pHWuZJjlWZMw+zK09PRQq/bRcCcDRXyewe9ntWcgxquYrjxJYJYqBIfdYE+grf4OoveXdQ3cN0983vNsU/1b9q7iURh4IuR5N9NTPiBvZDPif4pnfmGVDQpRPx+d+t5GyQLtytfD08BCwJPzdsIxp3MxWHn3CY7V+cRDKTRfDXDQfKPIN5bWJdLj/i0DaBt2YYpsf3RXHuxVDJ5MU/5VCxIHp8Pyr0Cwj5uB6KRc/ss3Zt+IhNjOrSzxMMWmMYpKZT5RyY/SBoxdBGY+T5tmZNgsLg+6JY12Tr5ta2CRT57waukndy2X2N8CyFk2Os+fWqzniFX/bRTrTyOxlX1XbKQwEDL+qyVqx4ISZu1Tu6ZSLVhnvclOlNye9P6L4OCEqUOThFTRUDZfGOJCEipPR46DVRUJLxF3MKO0qW1uOgHdFhvJw1N41St3zur5mvkIB4PT57sFSmjXnzNHw0MMpFrqsc7oRZGGtVTYEgRQHB9ikoZRE7Ebx/tgO6UgbESkkcvdUi8ok1+sj6iaydAmJ5NwQKiGOhQZAd46nKygFCDH4+MO/ZqK6dJMatFl6f5lxQftLY4adYWL9cv2/S4fQzIE+LwoNczmVXST0PnS+DlRHs9ZHB8G9/N+VqCA41Y88xZndyyYLIyGailUe/qIXzq2ZYwewdDVsVH6CvlFtJ9aPBBHwMqJyni5McyXNL4d4dBdr0m6THQkjr04tjqDH9T+NCD4pE3l70QNwzDytig1k0BvShp26K4Kq0IDm8rAiQpzibIl52B5K9RCpfGvNYEgEx/trn45gSYr/qhyBOXvJSQgMr2/FE+cJOwtdXwKHyMJQehEJB/zlUHQ8ZaqxLOJq/tlcN2Paxl0e7I1lLqXN+bHSg+mkRtLe
 vcemj1DC
 /+EODtvZdiYsAu7RmZMr7d7EhSq4lAkuV98V5rdwdiNa0TRMCN/tzLTlBWNUn1mZC5XImI4NldjVnHoMVN0h/7mfnVbj/RSNL3aHGiD68hWlCD7OcvxPuhoIg7UvJoWyrt+SLJ0i2K7mD6kfSwfq7XwIxuAiCP5w970fp7gP3iEzcoEopNT73kliTVmKFVcELUJ/peaKafENNOeLJex9W/V1m80qckhIZtxcE3euVNAv14czu238J8Vqw6RLpTufixTrY7eh/0B9sfjREtiS+MT/vb8y5wKlRVEnM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/07/26 7:37 am, Andrew Morton wrote:
> On Sat, 25 Jul 2026 13:06:25 +0530 Dev Jain <dev.jain@arm.com> wrote:
> 
>>>> @@ -2204,7 +2205,11 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>>>>  		/* Update high watermark before we lower rss */
>>>>  		update_hiwater_rss(mm);
>>>>
>>>> -		if (PageHWPoison(subpage) && (flags & TTU_HWPOISON)) {
>>>> +		/*
>>>> +		 * With TTU_HWPOISON, we only expect small folios or hugetlb
>>>> +		 * folios here for now.
>>>> +		 */
>>>> +		if (folio_test_hwpoison(folio) && (flags & TTU_HWPOISON)) {
>>>
>>> As per v2 discussion, I feel this could be tightened up, maybe something like:
>>>
>>> 		/* unmap_poisoned_folio() only refs order-0 or hugetlb folios */
>>>
>>
>> I can do this. But note that this series is in mm-unstable already - what should
>> I base the v4 on?
> 
> Ordinarily basing on latest Linus works.  But this patchset has ~450
> patches ahead of it and a quick trial merge wasn't promising.
> 
> I could drop the v3 series so you can base on next mm-new, please lmk.
> 
> Or
> 
> mm> git log --oneline | grep "mm/rmap: convert page -> folio for hwpoison checks"
> bb2f8a7eb126 mm/rmap: convert page -> folio for hwpoison checks
> mm> git checkout bb2f8a7eb126^

This one looks good, I'll do this.

I'll wait for Lorenzo's (or any others) potential review comments for two days
before I send this.


