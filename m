Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18046CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:44:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7751D8E0020; Tue, 21 Oct 2025 11:44:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74CD88E0002; Tue, 21 Oct 2025 11:44:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63C508E0020; Tue, 21 Oct 2025 11:44:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 529BE8E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:44:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E8AF6160545
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:44:18 +0000 (UTC)
X-FDA: 84022542996.27.FFB772A
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8DF14A0016
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:44:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LRnI/rX7";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761061456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=83AP2pcUZVkXSATkF5eTHL6M4I08IXBIdo5h/3fKK+w=;
	b=z0Vpq8h3s8iu+S13Vgw8F5LFujO7q59E9g7m+wD6+oiwzOJfuP8NfRfyEFOHhFOP8iaegQ
	MPy9Fqn4PPaX3vdkqnH78t3AYOecQk6uTkhcIdtcoFtJzOuOmcghy5gyPjpiSbCC/eYYfV
	Yd7DGn6wezy6FnV4p5vCFwV24isfTJQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="LRnI/rX7";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761061456; a=rsa-sha256;
	cv=none;
	b=ld05JYYb7RGW8jtcwSiwjroKpyZm8MvS1Cg7ygUrdY9N2TOA4Xn3Yw3It4ZkdZeuKtmv69
	wfkKMBDHe2JTWZLBa5rFQFRCvpZ+usN1D4buwg5CRMPJbC0t8SS5/LX+HkKGXoofVxDXqs
	XClsHAWte+8DmDadg+JqqUJ2Gpfc2GA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761061455;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=83AP2pcUZVkXSATkF5eTHL6M4I08IXBIdo5h/3fKK+w=;
	b=LRnI/rX7J9vm4DZalzSjL6ZKNEv91QguNZwMAR1J/pRWCHrNqLPJqN2UEahEpXht/GcVaz
	kJFl16i/MzfUNkaaTFBSn81aLy8VyLeyrHWbvhUX9rS2VE5caRARYqyQ9BNXAUOu2UAcUY
	74+EbaG8Nyf+q9xSPKm6M9asUrenUUI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-uLiO3mS5NCqE0ElL0RHWEg-1; Tue, 21 Oct 2025 11:44:11 -0400
X-MC-Unique: uLiO3mS5NCqE0ElL0RHWEg-1
X-Mimecast-MFC-AGG-ID: uLiO3mS5NCqE0ElL0RHWEg_1761061450
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e39567579so34567125e9.0
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:44:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061450; x=1761666250;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=83AP2pcUZVkXSATkF5eTHL6M4I08IXBIdo5h/3fKK+w=;
        b=Atumvjn2LxecMBXwybN5oNCH0gswNE5rmh5Ur3A+TVub98HZht8Sa0IKtJmXqi8VhA
         xoTvMDVnAZyGBRzcXOt9sbZQvmjvwj8PULYcmSUrYnJlvtCPcTDgbZcrX+JDRA8YXGjk
         WRXj9nvXwGrw2AhflcPSgddzcuJV6Cq7UZn22zxrsNQBzVeHAB5ZmPB3KgkzLDzjNc2F
         FkvAhHclmLCgVG3TN6sU4bTgLzefMuQTOgRf3cA6LdLvsCAjQ0s8J/YD4Qw/BHfeqmzK
         S9Q0MMi7mGMy/lqPOjn9tG2TFhFic5wSao6mMKCdQTjY7yw/eHPpCpMzm2XLnHySGFBW
         um0A==
X-Forwarded-Encrypted: i=1; AJvYcCXHA1Gy766jw1mnP3KQnRvN1XVuNOTk1vwCjI+w340qpa+TQB3xjkdkcA0I7eZTsjY/k6sUD9ATQw==@kvack.org
X-Gm-Message-State: AOJu0YywZlpcbikucQRjSS8N7Rfn9z3tZTSql6/6kYw2wMVWBUJJ70Ow
	YEN0mMNwvOMLOcPA897zyWWeQcYxWbHI7y+qbTfxhwQ/UijbTbnE4BNm4YrRoN7LgG2nq3iufKX
	xROKSqxJJ6iQ/YHnylmNYLShyBzWroHo3wLM8ElP2TWbSDw1M2OOU
X-Gm-Gg: ASbGncuEtHg63tBkoCHWU5tQkeKLgWiIirb51n7nlC2s9NvgXDGSRoYn3UqkvyZSstn
	Uff2Sb4doFMkO0AjCULvBvYNGbxBzJLF89a0KooNQzgZPOn1HkqJio4UlihJqWcSorLsBmL22D+
	+HduxF25iiqyC1BIMK92HAPGFG4UdTGPyQfsG2zn1D3Sl8K5kfyXxDqul8Inf5k++uGpiplk7i3
	0BpRshboIve0qq5LhYspwiKmgk36REXDSP8m5StSvttfMhOIPOwvnCX6mJSnArER+lsJU75Sd8a
	qwNb2+12dOLtYAqZFk9zlm2ESpDyG9QkXW8skt0vsEOYifdMlj/dib1oWodysU1+CStoJ9GCYGv
	5dt6Gsu4PVNnipYpuFae++6EUlehJU8yhMW/45cWywNFT0VNbEHcraB72TFV5nrh1R67rKTeyqW
	5/zA2IpCSwBv72AoWThpLMhIirML8=
X-Received: by 2002:a05:600c:474b:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-47117877525mr130856435e9.15.1761061450429;
        Tue, 21 Oct 2025 08:44:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGaIH2bO/ck6gwXdnqS8Ypxq8Yv23OSCidYjsq98DaSka5gGo9ipZvZfYK6JfQASLqPXM6hqA==
X-Received: by 2002:a05:600c:474b:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-47117877525mr130856175e9.15.1761061449963;
        Tue, 21 Oct 2025 08:44:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47114423862sm289821585e9.1.2025.10.21.08.44.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:44:09 -0700 (PDT)
Message-ID: <b353587b-ef50-41ab-8dd2-93330098053e@redhat.com>
Date: Tue, 21 Oct 2025 17:44:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/memory-failure: improve large block size folio
 handling.
To: Zi Yan <ziy@nvidia.com>, Yang Shi <shy828301@gmail.com>
Cc: linmiaohe@huawei.com, jane.chu@oracle.com, kernel@pankajraghav.com,
 syzbot+e6367ea2fdab6ed46056@syzkaller.appspotmail.com,
 syzkaller-bugs@googlegroups.com, akpm@linux-foundation.org,
 mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Wei Yang <richard.weiyang@gmail.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016033452.125479-1-ziy@nvidia.com>
 <20251016033452.125479-3-ziy@nvidia.com>
 <CAHbLzkoOZm0PXxE9qwtF4gKR=cpRXrSrJ9V9Pm2DJexs985q4g@mail.gmail.com>
 <5EE26793-2CD4-4776-B13C-AA5984D53C04@nvidia.com>
 <CAHbLzkp8ob1_pxczeQnwinSL=DS=kByyL+yuTRFuQ0O=Eio0oA@mail.gmail.com>
 <A4D35134-A031-4B15-B7A0-1592B3AE6D78@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <A4D35134-A031-4B15-B7A0-1592B3AE6D78@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vpv--qF9LXCfu8NObJw2gGY9zof1fyI3PV-6laNKdNI_1761061450
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 6n3xs7ed5jtm8nxq4tctw7mwud3haczw
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8DF14A0016
X-HE-Tag: 1761061456-861380
X-HE-Meta: U2FsdGVkX1/rW6S79iIdfbPuVRDGf85c5sK+NDLuMMrd2RjZnPjOzB8gf0RV0OOPrbFHLJGw4cxj7EExiv8CMfwQ7qNQKFsZQHi3r6BMC0mheKFde3C+vOTWlQ6UtYYvGl38bDlNY2L6rCb7eHUs7qOWnY+E0z+gk57Z4pDOSVR7sLNR77tqU4b1ZlnzrxANVEqztvPmnVV5UeLQCIJGtM6BEYgzcS+pK+XtlbvFqeJLDEvYWgNIqnZf3jA0yZwGqIJR/nYWyYdMPwQEiyYmoEYeFkzy2MRamxzEARLLuG8IyWW0o1U7WJyDgQII45jUwyRCbropZdlHhm6ggrg4uPGeDWpYTBF6FQkHtxQUgZudc5TIHl4RgHWu3zDT0DDfyH2ReMykOFWWy6JuiLiAcY8/zwEZWTkLoKdhbD2iMHTqHfkRof/659m4i4j9Ef/N32M6fXy0oaiXrvC2uZzx7FZtgX3RzYFHcD4oA/X+weHoCZAf5mDx2AsoikEaZgm3yBHsSTItZO7jXTqEJIdtUUS+RF5hWhr81HnVk/UoIw+gWdyOfRwSl/o+szNB9gqHF7v94PRQm0/NHvfLCE+AHoMK62JEcae7SAr67Hxvm5PcKNfR3ASqNOUYbUW0UXshIzMyfBf0Vd1cqOLVWQ3IM9zEkCE3dwFj8/PCW/oTMx4ZAZak1GtKbJVnGczgVbWheg8oRGZ9RfoHfGIZ0fXjHAeIh4i3YQhFLbY1Yh2LY/arsK/9cogsRXoF3rqtzhq5IDbdRBUjjXuDPswvauQyuvgHweORVQN+vMu7h9bVg50TtTYVhYOkeRCeEUDxM4mq3Nh6DcNDDfympxpprWcLmWXSKav6BNS++wqJzt07gibSZB4SefnMICbE2IPxjLqXzaZlSp3iY6IKpmQidlqra/ODPo3eKZHUEh3CxflEPwNsSjFv5HIf7fKBAtqtM9SJksI9fqT34pYVIdxiysk
 u5n8Vzmo
 WsiyQmV6l+Ba0f9QjwMSbJGU18Vgpp46ZECngF7pOLKnBGIMWGHxSFBklhfMM0fjAW3QF1hqwMjhby3yze/dqM9/JkmkzUcLIHagk2Igww6u1cCyizhZZy8ZQBZaau1UErAq/DfxHqT4Wkxny6Nn3ViLsz1xG3jcYDhbTNexdypirWNZfpvjdGoZQrzUzjraY8TAOAqW/EvWSxVGgmFmLktfFurZ1eBndyTurUnKa4he/yNg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 03:23, Zi Yan wrote:
> On 20 Oct 2025, at 19:41, Yang Shi wrote:
> 
>> On Mon, Oct 20, 2025 at 12:46 PM Zi Yan <ziy@nvidia.com> wrote:
>>>
>>> On 17 Oct 2025, at 15:11, Yang Shi wrote:
>>>
>>>> On Wed, Oct 15, 2025 at 8:38 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>>
>>>>> Large block size (LBS) folios cannot be split to order-0 folios but
>>>>> min_order_for_folio(). Current split fails directly, but that is not
>>>>> optimal. Split the folio to min_order_for_folio(), so that, after split,
>>>>> only the folio containing the poisoned page becomes unusable instead.
>>>>>
>>>>> For soft offline, do not split the large folio if it cannot be split to
>>>>> order-0. Since the folio is still accessible from userspace and premature
>>>>> split might lead to potential performance loss.
>>>>>
>>>>> Suggested-by: Jane Chu <jane.chu@oracle.com>
>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>>>>> ---
>>>>>   mm/memory-failure.c | 25 +++++++++++++++++++++----
>>>>>   1 file changed, 21 insertions(+), 4 deletions(-)
>>>>>
>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>> index f698df156bf8..443df9581c24 100644
>>>>> --- a/mm/memory-failure.c
>>>>> +++ b/mm/memory-failure.c
>>>>> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>>>>    * there is still more to do, hence the page refcount we took earlier
>>>>>    * is still needed.
>>>>>    */
>>>>> -static int try_to_split_thp_page(struct page *page, bool release)
>>>>> +static int try_to_split_thp_page(struct page *page, unsigned int new_order,
>>>>> +               bool release)
>>>>>   {
>>>>>          int ret;
>>>>>
>>>>>          lock_page(page);
>>>>> -       ret = split_huge_page(page);
>>>>> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>>>>>          unlock_page(page);
>>>>>
>>>>>          if (ret && release)
>>>>> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>          folio_unlock(folio);
>>>>>
>>>>>          if (folio_test_large(folio)) {
>>>>> +               int new_order = min_order_for_split(folio);
>>>>>                  /*
>>>>>                   * The flag must be set after the refcount is bumped
>>>>>                   * otherwise it may race with THP split.
>>>>> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>                   * page is a valid handlable page.
>>>>>                   */
>>>>>                  folio_set_has_hwpoisoned(folio);
>>>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>>>> +               /*
>>>>> +                * If the folio cannot be split to order-0, kill the process,
>>>>> +                * but split the folio anyway to minimize the amount of unusable
>>>>> +                * pages.
>>>>> +                */
>>>>> +               if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>>>
>>>> folio split will clear PG_has_hwpoisoned flag. It is ok for splitting
>>>> to order-0 folios because the PG_hwpoisoned flag is set on the
>>>> poisoned page. But if you split the folio to some smaller order large
>>>> folios, it seems you need to keep PG_has_hwpoisoned flag on the
>>>> poisoned folio.
>>>
>>> OK, this means all pages in a folio with folio_test_has_hwpoisoned() should be
>>> checked to be able to set after-split folio's flag properly. Current folio
>>> split code does not do that. I am thinking about whether that causes any
>>> issue. Probably not, because:
>>>
>>> 1. before Patch 1 is applied, large after-split folios are already causing
>>> a warning in memory_failure(). That kinda masks this issue.
>>> 2. after Patch 1 is applied, no large after-split folios will appear,
>>> since the split will fail.
>>
>> I'm a little bit confused. Didn't this patch split large folio to
>> new-order-large-folio (new order is min order)? So this patch had
>> code:
>> if (try_to_split_thp_page(p, new_order, false) || new_order) {
> 
> Yes, but this is Patch 2 in this series. Patch 1 is
> "mm/huge_memory: do not change split_huge_page*() target order silently."
> and sent separately as a hotfix[1].

I'm confused now as well. I'd like to review, will there be a v3 that 
only contains patch #2+#3?

Thanks!

-- 
Cheers

David / dhildenb


