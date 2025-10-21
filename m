Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D92ECCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 18:28:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 05CBA8E0008; Tue, 21 Oct 2025 14:28:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00C778E0002; Tue, 21 Oct 2025 14:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCA3B8E0008; Tue, 21 Oct 2025 14:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C5CB98E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 14:28:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79C1388978
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:28:35 +0000 (UTC)
X-FDA: 84022956990.25.E5FC8DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id D3683C0009
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:28:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fg3wHafk;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761071313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p1rUujygHyp+nQsh5XAYAD7qtwFrdj1/nniIVtSG5Cg=;
	b=3IqyYR5dtY5vld9ymdSLbeNMhCrG0wh9QC6TdN6qmT/zitZTdvi9ikm5tXzYzMaAot41aG
	BUentN4g2RbLXrUuCT3oT/fTeP4Nhk3dCpDyP3RpthX9AFu45p9chTnNa1z3tt57C/JH29
	SmzHyAP9clpokScm8tFvdp/2x6FUHmU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=fg3wHafk;
	spf=pass (imf22.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761071313; a=rsa-sha256;
	cv=none;
	b=wLi76jiB/YaeiCu5nbFwwH0Qow+vKtzhxMBPr/LL3O0xKyd1bgMXL/sF7rpmb5GFnTUva2
	1H3sYaXmNa0bldez8I70WNTI+0rdSFqNFEn/vuF19VsuNsGdP4a/PHM9v5QYIUkr4TDcrc
	4frUWJv+RMFA5v2gUpxRGHjfUDcrLZ8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761071312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=p1rUujygHyp+nQsh5XAYAD7qtwFrdj1/nniIVtSG5Cg=;
	b=fg3wHafkZYdLDJ7ttFAREMWBvt37Pe2Z51GDUCfkP63cB/e3zSWXFf17ji2sBnXn7EnxG0
	S8PY+zU2e44uCi1BzFhp92TL8JZlr/5F96otk4DL5GrGA1V71MJv8mlGTePapmdnbzJgCw
	qwVcatJAtrxyil0+Opub0cN5HzvMi44=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-DEW6u5-nMeKNEhcydbQziw-1; Tue, 21 Oct 2025 14:28:30 -0400
X-MC-Unique: DEW6u5-nMeKNEhcydbQziw-1
X-Mimecast-MFC-AGG-ID: DEW6u5-nMeKNEhcydbQziw_1761071310
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-40fd1b17d2bso3439111f8f.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:28:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761071310; x=1761676110;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p1rUujygHyp+nQsh5XAYAD7qtwFrdj1/nniIVtSG5Cg=;
        b=cElnG8Z1ANyckDgHT50SsmKcBRxxl+xF2zX58Q7OCUuGlU8BPzzLiBKJDqTmgSZCdm
         2hh9K8etYM/xjMwbPmAl8JqIVAQA2gf2C8KwSSl+QLZ6pZOb4rMRi8eBZ0fCnCT0QE0M
         J+wVZOX/9hnmne9S4TQbt3MVkKEShy0/qZS3X5YYcKUBVEHNdYZj2OrbjZAgCHYQRDfU
         c1ILFLdgRPQBcGkAskVX0Gamw5FDHEO72s041R5IoPOuRLSppHufenRHeLTgpFVuI+X2
         UPVcyTUIsAu+ddRmEtLBSIcjP9xL2mN2AMlpZT5BrhkbFz5mOcoi3BJ9H19g7qhznNe2
         qulQ==
X-Forwarded-Encrypted: i=1; AJvYcCWZIV3t12OJwGB/y+8Hbo5RGus24lwI96Ds82ls93HxKXt2/30CgpwEM9fnOIggCNqyfCZCWVYyMg==@kvack.org
X-Gm-Message-State: AOJu0YxDL9dTJza9GWTzAgrfqSO4MdwNWZiePcn0xsXd4XdcqaZpPCbZ
	ACe4+fDU8eAimtcV62k4t/wDcHPw0gelRo15l0NSEcy89GWUL/ygucMNGyesWjIlHh1HXfy3q+Y
	0js4eDpSVLtXWCKjXLmA9iH7l3JWCmDbqSQX1c1/qd+6d+MEmmL+N
X-Gm-Gg: ASbGnct8KpOGfGuaiPN//4jhERgPQdshCiasozOh9bwgRAdLjMG3TjpHI7C4p0eq3jf
	hWA8VjmkF5VgquvKoxa7pKo4yhwMadwPqetZK8vLQTHD46Awku1Ru7IOXYbcL2izXxQEQiE2KMW
	x/fh3PMPfEHeTsFUumBF83hSKS4bSInUwgZoPYQjDistpAAQm2yieX1tBdkn6a38EcaV7xWa/o6
	dTNT0u7LPzosdKz0CUavU3/CMrFwzl5w1X6p5tjT9hcgMuxwAbgiURnSsdmco4TRqoIiCiwR9Lt
	jXJ2N0tY0U3lUHw6VXppAjLbW9c7jO85wMF/nfRLOssUEwbg1tzUHjoYi9ad0YN6Bt0D1SO+SAJ
	ZY6XfXPDGbPCE2QwlGfKzjf7XPgJIou8=
X-Received: by 2002:a05:6000:184f:b0:427:a05:2ff with SMTP id ffacd0b85a97d-4270a050510mr10269754f8f.33.1761071309663;
        Tue, 21 Oct 2025 11:28:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH81g8i/LCi1AuXlZHNIML/iiLnpPkqZNzar/dX2uHH9lLINKzpzMqLwuLZJ7387cttvNJOcA==
X-Received: by 2002:a05:6000:184f:b0:427:a05:2ff with SMTP id ffacd0b85a97d-4270a050510mr10269722f8f.33.1761071309148;
        Tue, 21 Oct 2025 11:28:29 -0700 (PDT)
Received: from [192.168.3.141] (p57a1af76.dip0.t-ipconnect.de. [87.161.175.118])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47494aad668sm23481915e9.2.2025.10.21.11.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 11:28:28 -0700 (PDT)
Message-ID: <595b41b0-428a-4184-9abc-6875309d8cbd@redhat.com>
Date: Tue, 21 Oct 2025 20:28:26 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/3] mm/memory-failure: improve large block size folio
 handling.
To: Zi Yan <ziy@nvidia.com>
Cc: Yang Shi <shy828301@gmail.com>, linmiaohe@huawei.com,
 jane.chu@oracle.com, kernel@pankajraghav.com,
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
 <b353587b-ef50-41ab-8dd2-93330098053e@redhat.com>
 <893332F4-7FE8-4027-8FCC-0972C208E928@nvidia.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <893332F4-7FE8-4027-8FCC-0972C208E928@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: V1J94kIrwl20uKb9zM1D73DKW7tlHq7y5Vc2xaPpnb8_1761071310
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cnrweua8sqwwxf1uz4b8m1fbpkzzbzwa
X-Rspamd-Queue-Id: D3683C0009
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761071312-996497
X-HE-Meta: U2FsdGVkX1+/8+O1KNRW3gEZivmMmMbUf0/ISVIwUgO1EwAG6dfweTWUpPoFAJeLynDX8NkJd9oQaJUW/wEKIl2mgrNo6t2TUBZyeqgGHxOanVOiuUN9IBgFRkF7mkDFayRDfaYGuSSTG03bntHnOrUnvlVGPyLE+nC4LKV3Tgjych5e+Vvt44IZjD/N8gRbSLs9Jph/HrpLo3vJQJe2bexBe4jhH+y0bRx/oBTkKtGj4KhZT3SMKjynznJX8xD9uAQXw6pUmqhiwY55WQkpoGJC+n0bWqxtHmWYPTdS9z2Xjhn/OVFiVfWKXRKOd04NZgPRhpktT+kw6EwzKUju5UekLghGNTIbGrDyO0CpWtQNV2KulrtZLl20oWZPVUMEtMtiY9sLuxezNbdgAdAvxw7jXmYFUk9XNYWv+xVH1vBanyZtv8KGHjU4HaYNFGfvtbGrqI+NLeau0nJOiLeur6RsHRxBNl3MuUFcHZGVJ/0X0XLb20KkiqesSIDmeMGS2KWoSU89F5GGaccFfxl3R9d8suZ/cegGPecZ5MStJvN6G1EKeaa2fJb6nBAZwZEfW1ZwhVWxzYZS9LlzV2q90eUM+U4bXKFVZd/BuF6T1Sa1sq+ekwytqa0/YWt64YJBtHBpMoT1saIEorKZTzSyNcRqehVMNek/XO5SnKCSwUBRndCHu3NsQCseecIhBodrPVgxYCy+dmCVonl4VdOlGljBX7zVUzFfs9ua7prww7Vi6GK0O/zW9oycwFd36leQkKtsj9w5kvfIg9Ql2is8pg1sgW31pHCSX2hT7c8tkGlwJ2Xj+qUUllWspo/vfxfYredjrAjstt6KQ/M+nPnZoAbcSUCkQCL6nUrgAd5Ns9IV6bgqwrkuuPZGJq+PFnyG3UEGSWEChd1/654d6zokcxfcUjMoSWLUu5dX4eIc3Do1sH0HvDAU1WfV4jY2mzRFYNg4LQmBEJvUZq8zzNG
 J5k4gqrv
 xfY/fgBzHKI2H3ftm3QxOA7sT3h89c6pF96/XrYZ3PXTasr+zzwr/2DtQfcG5Q0m9BJZ29GGiiHJHV92KtAc9jMSPnbpKdfKNbu5S+mvePZSo1pVgaTD+QLyiSgKJkxaOmxrfWcrEcGKrEzSjAsZM7kwJ7aqcDDHKZt5Owm5uGdwEo6pBH+TKvQFSoXP9WrOkd03hpfH8xvoUZPQtYpdf00I6gTTKakM4U1QCHKh7VkPxK6Yx0eTOLZ2wIOb5jTOvKarCJ7xccl3/r4d2mmgmrrVa9xmWsLQfbOMB6/8zyfta25Bu/no0f0u8q/ouoawzMd3H5+SgL5EeRVyGmbqePA+Ii/1waU2+pC+oA2r0u6c2oTCMr9QEJ8LZfvHXOWLb0kM2jeLvKxYI6VUd53bQkPWhsxwxavmmZ9JcXBgoLOV1n8xD8NIHC9t/ODb9AOxTzS2DLIGWAIYSav2Mu4+pxtafyhBaccovDkAJ72lEXjvUHq2NtqzDXOwMg33W0j0Jx3DqZcLSr+PPu+MSYiFr0MX1RiRtfl5s9btClwySe6T69mOxU/bQHqXh6F+nhK6HEFN2sI6ZsJOSykD41Tn1LuPYGY3X3NIoDoN/P/H8qWm7h5ma5VIIMSlci5bEytlIUeTVLeeQ5nkRalWkD/Z7bdeAGvC01tCzRBWi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21.10.25 17:55, Zi Yan wrote:
> On 21 Oct 2025, at 11:44, David Hildenbrand wrote:
> 
>> On 21.10.25 03:23, Zi Yan wrote:
>>> On 20 Oct 2025, at 19:41, Yang Shi wrote:
>>>
>>>> On Mon, Oct 20, 2025 at 12:46 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>>
>>>>> On 17 Oct 2025, at 15:11, Yang Shi wrote:
>>>>>
>>>>>> On Wed, Oct 15, 2025 at 8:38 PM Zi Yan <ziy@nvidia.com> wrote:
>>>>>>>
>>>>>>> Large block size (LBS) folios cannot be split to order-0 folios but
>>>>>>> min_order_for_folio(). Current split fails directly, but that is not
>>>>>>> optimal. Split the folio to min_order_for_folio(), so that, after split,
>>>>>>> only the folio containing the poisoned page becomes unusable instead.
>>>>>>>
>>>>>>> For soft offline, do not split the large folio if it cannot be split to
>>>>>>> order-0. Since the folio is still accessible from userspace and premature
>>>>>>> split might lead to potential performance loss.
>>>>>>>
>>>>>>> Suggested-by: Jane Chu <jane.chu@oracle.com>
>>>>>>> Signed-off-by: Zi Yan <ziy@nvidia.com>
>>>>>>> Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
>>>>>>> ---
>>>>>>>    mm/memory-failure.c | 25 +++++++++++++++++++++----
>>>>>>>    1 file changed, 21 insertions(+), 4 deletions(-)
>>>>>>>
>>>>>>> diff --git a/mm/memory-failure.c b/mm/memory-failure.c
>>>>>>> index f698df156bf8..443df9581c24 100644
>>>>>>> --- a/mm/memory-failure.c
>>>>>>> +++ b/mm/memory-failure.c
>>>>>>> @@ -1656,12 +1656,13 @@ static int identify_page_state(unsigned long pfn, struct page *p,
>>>>>>>     * there is still more to do, hence the page refcount we took earlier
>>>>>>>     * is still needed.
>>>>>>>     */
>>>>>>> -static int try_to_split_thp_page(struct page *page, bool release)
>>>>>>> +static int try_to_split_thp_page(struct page *page, unsigned int new_order,
>>>>>>> +               bool release)
>>>>>>>    {
>>>>>>>           int ret;
>>>>>>>
>>>>>>>           lock_page(page);
>>>>>>> -       ret = split_huge_page(page);
>>>>>>> +       ret = split_huge_page_to_list_to_order(page, NULL, new_order);
>>>>>>>           unlock_page(page);
>>>>>>>
>>>>>>>           if (ret && release)
>>>>>>> @@ -2280,6 +2281,7 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>>>           folio_unlock(folio);
>>>>>>>
>>>>>>>           if (folio_test_large(folio)) {
>>>>>>> +               int new_order = min_order_for_split(folio);
>>>>>>>                   /*
>>>>>>>                    * The flag must be set after the refcount is bumped
>>>>>>>                    * otherwise it may race with THP split.
>>>>>>> @@ -2294,7 +2296,14 @@ int memory_failure(unsigned long pfn, int flags)
>>>>>>>                    * page is a valid handlable page.
>>>>>>>                    */
>>>>>>>                   folio_set_has_hwpoisoned(folio);
>>>>>>> -               if (try_to_split_thp_page(p, false) < 0) {
>>>>>>> +               /*
>>>>>>> +                * If the folio cannot be split to order-0, kill the process,
>>>>>>> +                * but split the folio anyway to minimize the amount of unusable
>>>>>>> +                * pages.
>>>>>>> +                */
>>>>>>> +               if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>>>>>
>>>>>> folio split will clear PG_has_hwpoisoned flag. It is ok for splitting
>>>>>> to order-0 folios because the PG_hwpoisoned flag is set on the
>>>>>> poisoned page. But if you split the folio to some smaller order large
>>>>>> folios, it seems you need to keep PG_has_hwpoisoned flag on the
>>>>>> poisoned folio.
>>>>>
>>>>> OK, this means all pages in a folio with folio_test_has_hwpoisoned() should be
>>>>> checked to be able to set after-split folio's flag properly. Current folio
>>>>> split code does not do that. I am thinking about whether that causes any
>>>>> issue. Probably not, because:
>>>>>
>>>>> 1. before Patch 1 is applied, large after-split folios are already causing
>>>>> a warning in memory_failure(). That kinda masks this issue.
>>>>> 2. after Patch 1 is applied, no large after-split folios will appear,
>>>>> since the split will fail.
>>>>
>>>> I'm a little bit confused. Didn't this patch split large folio to
>>>> new-order-large-folio (new order is min order)? So this patch had
>>>> code:
>>>> if (try_to_split_thp_page(p, new_order, false) || new_order) {
>>>
>>> Yes, but this is Patch 2 in this series. Patch 1 is
>>> "mm/huge_memory: do not change split_huge_page*() target order silently."
>>> and sent separately as a hotfix[1].
>>
>> I'm confused now as well. I'd like to review, will there be a v3 that only contains patch #2+#3?
> 
> Yes. The new V3 will have 3 patches:
> 1. a new patch addresses Yang’s concern on setting has_hwpoisoned on after-split
> large folios.
> 2. patch#2,
> 3. patch#3.

Okay, I'll wait with the review until you resend :)

> 
> The plan is to send them out once patch 1 is upstreamed. Let me know if you think
> it is OK to send them out earlier as Andrew already picked up patch 1.

It's in mm/mm-new + mm/mm-unstable, AFAIKT. So sure, send it against one 
of the tress (I prefer mm-unstable but usually we should target mm-new).

> 
> I also would like to get some feedback on my approach to setting has_hwpoisoned:
> 
> folio's has_hwpoisoned flag needs to be preserved
> like what Yang described above. My current plan is to move
> folio_clear_has_hwpoisoned(folio) into __split_folio_to_order() and
> scan every page in the folio if the folio's has_hwpoisoned is set.

Oh, that's nasty indeed ... will have to think about that a bit.

Maybe we can keep it simple and always set folio_set_has_hwpoisoned() on 
all split folios? Essentially turning it into a "maybe_has" semantics.

IIUC, the existing folio_stest_has_hwpoisoned users can deal with that?

-- 
Cheers

David / dhildenb


