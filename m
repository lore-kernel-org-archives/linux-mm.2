Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72B40CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 15:06:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEF228E0025; Mon, 20 Oct 2025 11:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9FEE8E0002; Mon, 20 Oct 2025 11:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8ED68E0025; Mon, 20 Oct 2025 11:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9B35F8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 11:06:36 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1936C1A01DE
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:06:36 +0000 (UTC)
X-FDA: 84018819192.18.8833EC0
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1637B40012
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 15:06:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ft6eRI9/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760972794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pEYAPg0/9P8i0AqXf9KQgQ5ijvrv79Y+WAS0UJoYxic=;
	b=a53uknmvmUXVDqOoFWgvl/8rM+Vi3u8+tgMzG34zd/llhqkjQNtC7DMpj3nnO7zD9hb/Zl
	PyW2ErfjEBZS4/twGjlMKluytJcGtgm4EuQJaNi55nFeQGDiNfzSnJARzxMpPC3WizCabE
	XLODKgZWXFPQqzfAzaQIqyy/BlKqYUI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="Ft6eRI9/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of jinji.z.zhong@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=jinji.z.zhong@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760972794; a=rsa-sha256;
	cv=none;
	b=W/4r6XnUxCI6SWIz300rDBufNI7wqwwxEc53bkkjbGku+9Hqt4x9yJdo98qaaZn0NYo/ki
	ZnYirwu12Rf07fJsCmYWsGCOg41RFR4AL/RnZxPE2Wms4ErDj/Rgs7UU1WY84tiC8IaTqa
	69/UaPCB4ruFmBzGirj0LTvUPN30pLo=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-7811fa91774so3907198b3a.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 08:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760972793; x=1761577593; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pEYAPg0/9P8i0AqXf9KQgQ5ijvrv79Y+WAS0UJoYxic=;
        b=Ft6eRI9/aJsoJM2dfNn+LA+V12tDIE2E6XaxNPInqyU0XGKarDdOKigM4XGRHh5giK
         hjqKL3am4ggPY4l/dBPdREdW24KXA4giHT/TIHqOnXTH8wMPyNaWKHEChh38Q+fd75Yx
         EwU3tQQIKh8TOez0l1s4K6Yzxm2J0XHbe/cZzlgPC5tdOxm5hvXeJPqFoJGNGGs/vFrw
         evyiSI5Bu1U+U7gLylp/5MM1lswewEBNdPgMy7PuTqoeiox3XNJpYp57fCYC5/jE/Zrb
         /b1GP/c4L/MQ002TBMGAkY9xhAvy80dQjAqONfRBogWMptC3PQcfRXGw1cwpokq9P159
         sZOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760972793; x=1761577593;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pEYAPg0/9P8i0AqXf9KQgQ5ijvrv79Y+WAS0UJoYxic=;
        b=IMNapI871N86NGG4GMR/BUa4iaacuZ3Gto/5bwLw6pAAWDxD9HwPcQbzHBkrW2sRLd
         532fSYK5lxipiGGao5hXToiRbfioKsLvWWqj0UXRIugic/aAZ1fshbmpWHSb4np8Y3a0
         4nz9kbAuGJC9JDtcRhVnaGSV4CRCsx9hETL4ekKtR2k/effBtz+YOikvUQp6RXmnMXli
         k9EAgULgPZA5Ds0CzVUUZB4xq/sDWtbWYwTxykAHy8m8rdiREQyK0DUqdJsfiWmKYf8w
         rVxhZTWHCae3KwSQxeaxhzfz7k+PspXrebOaIS3o3OZS+7+XzIku2J24PR960uMcKrRv
         JXaQ==
X-Forwarded-Encrypted: i=1; AJvYcCUbDqOuuaV7KQkHwY/wSLNgtOKODNz2DVSPTbsKCPK3CnM+jJTtoMpHCpPbVhL1ZL6Me0D+Gux2Rg==@kvack.org
X-Gm-Message-State: AOJu0Yx1k0d22sEgN63hmOcX14qekQFBOWakUD7yQBrFJ66Ra1ql/0Lb
	sEsdfe+Kn6HPaUpKzskgvvxngAgQEeAw/ICoPBtF1PhjCi/IDL0o3upH
X-Gm-Gg: ASbGnct2GIK9zRhViq8erU0xAFjYmkujUm2A/Yz6YwUmFOIfOeP4q3s6NtftLNZWgeS
	ktouujlnutapg5lbvgGnGjF1kCMga1CJiN3OfpmcQ6DTQ3LE4MPgsLLE+6y24NbACGyDZI9E2HM
	7DlPwJ5GmK7r4nNeKF/jOT8qNzb7akKGV5fmxTnAQT6ETSexeQEAix4tgbC92Qs9gVd059ZSpHY
	m7GJEcZKLf7kQExjrIKwVZXFFdTo2b7yePS8O783/Cm+MVQO7mJXmYPGA0Y09iUBF+nVT4nUmqk
	8rIsmS2ygOKpCIai1eouTTlAVbcgqfO/I0sPfpdP8v2Gv8W7bKo3paU2yG89HisO/A2SM2GXzTi
	ALQc8A//tYY400/yciyoPGoY8sJYktgLzlHV7TCnImncP+dhIbOC02/Qtuevlmj9mB1VIoM1eeX
	u6qfk=
X-Google-Smtp-Source: AGHT+IG4hAvaiT9qMc124aUjhAwGQoPr0u9gLyEZ2Bp4eQLu89aAOxbW8d4Nq6BNuCuodFW2fP8ZXg==
X-Received: by 2002:a05:6a00:2ea1:b0:793:522:b8fb with SMTP id d2e1a72fcca58-7a220aaf9e8mr14700226b3a.25.1760972792539;
        Mon, 20 Oct 2025 08:06:32 -0700 (PDT)
Received: from daniel.. ([221.218.137.209])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a230121f96sm8577259b3a.76.2025.10.20.08.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 08:06:32 -0700 (PDT)
From: jinji zhong <jinji.z.zhong@gmail.com>
To: ziy@nvidia.com
Cc: akpm@linux-foundation.org,
	feng.han@honor.com,
	hannes@cmpxchg.org,
	jackmanb@google.com,
	jinji.z.zhong@gmail.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	liulu.liu@honor.com,
	mhocko@suse.com,
	surenb@google.com,
	vbabka@suse.cz,
	zhongjinji@honor.com
Subject: Re: [PATCH v0] mm/page_alloc: Cleanup for __del_page_from_free_list()
Date: Mon, 20 Oct 2025 15:06:25 +0000
Message-ID: <20251020150626.2296-1-jinji.z.zhong@gmail.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <7B0DF4ED-FBB8-48E5-95B7-4C32B645F4A6@nvidia.com>
References: <7B0DF4ED-FBB8-48E5-95B7-4C32B645F4A6@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1637B40012
X-Rspamd-Server: rspam03
X-Stat-Signature: jxorndtcnfx43kykawb1uw6mwu3nbrt8
X-HE-Tag: 1760972793-63525
X-HE-Meta: U2FsdGVkX1+w0wbrHspnjMai1gD4H5xF0k0sHmkexSjOEARr+S/pr5+eAafirV1OvHJFvFxWYA076v5jc8HqpLTanTqnucuG44YiFHSmeKH9Bd1bJ7tJv7X0PzNrlKEUaiOMIBhm2PkSEicfgyqY86zCSSwhS+r540jJRcRQz85NQBLoX5TCmBbVIF7pJxgYLiun0s8Ex2fQoj5zcpUK6C+5lyTUu1yDEeY0nuv3tJnChQzY5Xg1MqFlOTZXNgygKiZh8eWxD11ssALoi1rhGZtJMnWMh0OKOJJYkfV9+vbauaMDbrZgRYrnhnstS0Ap66CcMvKLB00nMZY2W3P7XZxWKW5RPtvzIFfTFOtio+OHM24uDLnMHnivRDgPGhDWgd4c10s5rX8LO3JrSVbIsaOCPtt0JYBqy+8QjpVg+/TyXSJZvMwnWmoJNyrYmj24QnnM9YsweRNwQbDosnW0vqAFhtaTryjljNg1lha4n1kcy2ObE+XPRNtfQZCCkD47QCRUkwtdDOHq0s7KzC/+RdaR+fIHRHUD9tuiT3ytde6Jx0prT1H/s8uOtmMb7Kdy8Z45wvQ8C/ZEK5SwdLuqKk9a2Ka94kUW9I9GB7+fam+ERdK9VUBFsdx1NqxgyhgOVLt9r8901RvmGvz9eN5BE1PsdzNrEWZIqwf0ssbbCE4ChC0f+ScF+lFkmDt7WndtMEwYyX2cRUZ0EVwB+Tt48ib8bWv14tZDjIpDhZG2EIq4O0sZmNonKO00T1PYTqFbaS8laypKVLd+2LesupWwpKk9opCBC/WIKDOTcn+Es+g5T9Rkfd1pdEuJ2qCW2BTgIKzAOzU3vSMthwirR2rauylylGAvT0yTEg0otgoODYJoLssYU8t7q/bdAd2meZaD0/1z2Plo4I9klI956RJBpRFWRLp619kWe7RydM3T/3LtiG9ETYof3UU59aK+oFRdCidbgdjUddeAtvk3SPm
 XbgjsN2j
 Nbcr++z1P/9KXUBoEQ3UfiDc3hSIxgOmdUToqNM+0j+wpNQ/jd15xjFNixXDMDP0uXX21gKwQFmcK1tzxm+zAYENbVuDwUCSnegABfViOGVgfBB/t01lDgMM+9usrpyVfH2hDu1SLbHfIJR4IzqZytdHd3YYSEej1Q/z6oVSDzd+iqKiKfMC1GNdJPuuLSe+0NtWEqIdshROn+BMf97CqoNu6vN86fcZ+mfoYCw0u3cuQ9lN0wwgVYl7LHiwIr0pZLRHDRw4dTjTegM4yLdO3S5hF5dwbQEfYfhAybZBXtepL5eSgq+b8uo/tcw3PJxUXhdbSdoHXTW8EB/tK0JjScmqsSnt+o11BO46V9ViCfR6wmv55gq4qH0oLMzCgwSn9zthJAASgDCWF4mx5FLv0cyYnYN9CKBP4Mo7PXpwCYcZCPWFfyBFgmYICB+faQGlQlv2rmNfGEQ+aNF0CZP1SRaQ1MNoWrZp9QMsmvgBaBCVyZGyY+6cBwOGRibXyTZJ4AYhKpWg6mykX3TDvyTbxy4Buv0vY8k6YfuNuQnPrNdwLQkDG5ZDguoXeoEM8ruvW6hkLSzlC/JE5Zoup8TTjw11ONDzx/S8Pd5+eB7LOClMRLO9SKiOExsn2W5C99l60BkdLL0oflrd9nhP+9KXsgGlvZw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>On 1 Oct 2025, at 0:38, jinji zhong wrote:
>
>>> On 30 Sep 2025, at 9:55, Vlastimil Babka wrote:
>>
>>>> On 9/25/25 10:50, zhongjinji wrote:
>>>>> It is unnecessary to set page->private in __del_page_from_free_list().
>>>>>
>>>>> If the page is about to be allocated, page->private will be cleared by
>>>>> post_alloc_hook() before the page is handed out. If the page is expanded
>>>>> or merged, page->private will be reset by set_buddy_order, and no one
>>>>> will retrieve the page's buddy_order without the PageBuddy flag being set.
>>>>> If the page is isolated, it will also reset page->private when it
>>>>> succeeds.
>>>>
>>>> Seems correct.
>>
>>> This means high order free pages will have head[2N].private set to a non-zero
>>> value, where head[N*2].private is 1, head[N*(2^2)].private is 2, ...
>>> head[N*(2^M)].private is M and head[0].private is the actual free page order.
>>> If such a high order free page is used as high order folio, it should be fine.
>>> But if user allocates a non-compound high order page and uses split_page()
>>> to get a list of order-0 pages from this high order page, some pages will
>>> have non zero private. I wonder if these users are prepared for that.
>>
>> Having non-empty page->private in tail pages of non-compound high-order
>> pages is not an issue, as pages from the pcp lists never guarantee their
>> initial state. If ensuring empty page->private for tail pages is required,
>
>Sure. But is it because all page allocation users return used pages with

Some users [2] do not reset the private back to 0. When the page is a tail
page, the non-zero private value will persist until the page is split.

>->private set back to 0? And can all page allocation users handle non-zero
>->private? Otherwise, it can cause subtle bugs.

Yes, you are right. Some users(like swapfile [1]) cannot handle non-zero private.

>> we should handle this in prep_new_page(), similar to the approach taken in
>> prep_compound_page().
>>
>>> For example, kernel/events/ring_buffer.c does it. In its comment, it says
>>> “set its first page's private to this order; !PagePrivate(page) means it's
>>> just a normal page.”
>>> (see https://elixir.bootlin.com/linux/v6.17/source/kernel/events/ring_buffer.c#L634)
>>
>> PagePrivate is a flag in page->flags that indicates page->private is
>> already in use. While PageBuddy serves a similar purpose, it additionally
>> signifies that the page is part of the buddy system.
>
>OK. You mean ->private will never be used if PagePrivate is not set
>in ring buffer code?

In the ring buffer code, it only uses the private field of the head page,
but I recently found that the swapfile [1] is assuming page->private is zero,
even if the page is a tail page, which seems a bit dangerous. Adding this
patch will make this situation worse.

link: https://elixir.bootlin.com/linux/v6.17/source/mm/swapfile.c#L3745 [1]
link: https://elixir.bootlin.com/linux/v6.17/source/mm/swapfile.c#L3887 [2]

>If you are confident about it is OK to make some pages’ ->private not being
>zero at allocation, I am not going to block the patch.
>
>>
>>> I wonder if non zero page->private would cause any issue there.
>>
>>> Maybe split_page() should set all page->private to 0.
>>
>>> Let me know if I get anything wrong.
>>
>>>>
>>>>> Since __del_page_from_free_list() is a hot path in the kernel, it would be
>>>>> better to remove the unnecessary set_page_private().
>>>>>
>>>>> Signed-off-by: zhongjinji <zhongjinji@honor.com>
>>>>
>>>> Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
>>>>
>>>>> ---
>>>>>  mm/page_alloc.c | 1 -
>>>>>  1 file changed, 1 deletion(-)
>>>>>
>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>>>>> index d1d037f97c5f..1999eb7e7c14 100644
>>>>> --- a/mm/page_alloc.c
>>>>> +++ b/mm/page_alloc.c
>>>>> @@ -868,7 +868,6 @@ static inline void __del_page_from_free_list(struct page *page, struct zone *zon
>>>>>
>>>>>  	list_del(&page->buddy_list);
>>>>>  	__ClearPageBuddy(page);
>>>>> -	set_page_private(page, 0);
>>>>>  	zone->free_area[order].nr_free--;
>>>>>
>>>>>  	if (order >= pageblock_order && !is_migrate_isolate(migratetype))
>>
>>
>>> Best Regards,
>>> Yan, Zi
>
>
>Best Regards,
>Yan, Zi

