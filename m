Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61849CA100F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 17:59:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5D28E0008; Mon, 22 Sep 2025 13:59:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8EBE8E0001; Mon, 22 Sep 2025 13:59:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 97C508E0008; Mon, 22 Sep 2025 13:59:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8612D8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 13:59:09 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3649AB6D0D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:59:09 +0000 (UTC)
X-FDA: 83917647618.26.0B3F307
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id D065A1C0012
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 17:59:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N64cQPf2;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758563946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X+NpTFRiqIAeX32lj/YJRRr02h3IMluyoifxGje7HdY=;
	b=2SI/jzlQNuIYAl5TkCj+BbfPwTlmgukd6IRH+bPCJKZb1fiFsfcxUF0JeilqTFmqwq1LMD
	rsIB3thn9a0kfg7N/AvcF/zek+Ym0gn1XLBQznKDU8nmL2jjEE9VHDKWQN8Vf6K7vyMcUz
	0LBsSKOI2doSygY6XV+M7L6vjGCwtZ4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758563946; a=rsa-sha256;
	cv=none;
	b=L7oBdbgQbI6jpiyw/DLdjhhcJnBcF5La5+6k04+9b2X0SFjhU+y5LmQvRLGezFPAk9jWwU
	pQvGSi60a9r1Sy9agUPm5UCBqaUlgTifYAVCSHf3oTMPlRrG8KxoHni0lnWz4el94ELcyM
	EoNIMJHimc0uv4bD56U76dJ4GvTOhes=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N64cQPf2;
	spf=pass (imf20.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758563946;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=X+NpTFRiqIAeX32lj/YJRRr02h3IMluyoifxGje7HdY=;
	b=N64cQPf23OMOKn8TGNdXivCw5IxXdU+/0DpoI6atO/EuAOX/IzzQVVa+2tecxAhUexQr+H
	2vvm/pLkhVPR3uKa3BQ8sB4sUaRNcxibWiDxZOMzN+v9SCMvfFVUgfOqVdv7uxIVcjMhZF
	mefGu7QTh5oPip1a8hkIP9nhszRqWAY=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-YuXdnikmO_e2D1JwZiumgg-1; Mon, 22 Sep 2025 13:59:05 -0400
X-MC-Unique: YuXdnikmO_e2D1JwZiumgg-1
X-Mimecast-MFC-AGG-ID: YuXdnikmO_e2D1JwZiumgg_1758563944
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45f2b0eba08so33537715e9.3
        for <linux-mm@kvack.org>; Mon, 22 Sep 2025 10:59:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758563944; x=1759168744;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X+NpTFRiqIAeX32lj/YJRRr02h3IMluyoifxGje7HdY=;
        b=ODhe8J4xCExi3/uIKVJvGD0z2PcWflxE+jgW4L6cCCDO8g7Zak6z6vgb0E57Lcx8m1
         ZJAh6DFBrxsVHZ9CfoMWDFZINWGGQHYCAvFoij9tRKJVST2/aZJtEl31hEpu9KLqCXBd
         pocrzYtTBPIrQMAERUnqDc1WgDgP7+Tad/Ty578u36AM7WbfFgFxrDPguHs4d/KFu9Il
         I2qTBFTpernIP0Vv8HM2AVliw3OT9WSdfXlEiPSBdnrQJitlR5h+UAL56tVtu0GGJ1z2
         FoNGt8wyzJBIke+Vrt2iG6W00WU7WPq68BIvKUM2F/aKOZwCCh6+Uno6D/QoQO1kRrft
         zvuw==
X-Forwarded-Encrypted: i=1; AJvYcCWyz966iukuwgm+XscCF0l8psgKNiFAXUv57khOtDOGMuRaSwDL2ecJBt+mvHiMXQ4J/PC+Xk7y0Q==@kvack.org
X-Gm-Message-State: AOJu0Yza7E0Rvrrqvk/ior4hiJ8T76wEP2InY3DRh1RUs9orpQ7FLymU
	h8S25315cUHU9nioiZc6ZdsgvKHLOFr0zhpioExQaDMgGy69qtQWHAAyjisujl+s3JH1YcoPZC+
	4/yNlG1X+58NBMRC+hu00jExJQqVTt37E7jkMSxGscVoA5I4OKHuT
X-Gm-Gg: ASbGncv0FzXm4VR7G1xaENrwLVuFO6saWmTTSUiljMyRt3ON6UGvOdyFlDy3XAkYIyB
	/2oGfeAXu3jiuOrHYoWxA8K4aELKrAb66DnPHvy7CZ6zhRTqOG0IWbD2xeoeECq5s+DYcneRtSg
	PhqSMBeNJxpmc/qcx+PkkKc3dcQRxNUcx4Ayb62r/z9wBeHLvANXb0ugCZ6hFl2OQMKgrhsLaYG
	ZzdMXo9OdRrlHvx/uPFGxuLyy1qQUXbZu4O3p/BosB1QmbXKbqH1+4JjIhtaUEjSooMMWg7L5PG
	r7+xkZ1mGTDTRyKtxHFNufKXXt6aGAdvNbqiK6Oj2/LfriffMDQPQVRfO8gK+ZXsmbhUK7USG0g
	HqGHPj5Iq/wI/ZWrEi5y9Kwrzw/PFmN1tYo3MUOF9y974N1P6movc4kDe/DbisfM=
X-Received: by 2002:a05:600c:468c:b0:46d:4f41:3704 with SMTP id 5b1f17b1804b1-46d4f41384dmr40724575e9.24.1758563943627;
        Mon, 22 Sep 2025 10:59:03 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEoE/UaKLNkRz3YUEvL7yXGK4SAbmQlqVmH48OgbeeBRyoglBEIuVbqUV5YzWqsII28Z7eKwA==
X-Received: by 2002:a05:600c:468c:b0:46d:4f41:3704 with SMTP id 5b1f17b1804b1-46d4f41384dmr40724115e9.24.1758563943097;
        Mon, 22 Sep 2025 10:59:03 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f2a:e200:f98f:8d71:83f:f88? (p200300d82f2ae200f98f8d71083f0f88.dip0.t-ipconnect.de. [2003:d8:2f2a:e200:f98f:8d71:83f:f88])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-461383b7b9csm253669505e9.2.2025.09.22.10.59.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Sep 2025 10:59:02 -0700 (PDT)
Message-ID: <a3412715-6d9d-4809-9588-ba08da450d16@redhat.com>
Date: Mon, 22 Sep 2025 19:59:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm/thp: fix MTE tag mismatch when replacing
 zero-filled subpages
To: Catalin Marinas <catalin.marinas@arm.com>,
 Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 usamaarif642@gmail.com, yuzhao@google.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, baohua@kernel.org, voidice@gmail.com,
 Liam.Howlett@oracle.com, cerasuolodomenico@gmail.com, hannes@cmpxchg.org,
 kaleshsingh@google.com, npache@redhat.com, riel@surriel.com,
 roman.gushchin@linux.dev, rppt@kernel.org, ryan.roberts@arm.com,
 dev.jain@arm.com, ryncsn@gmail.com, shakeel.butt@linux.dev,
 surenb@google.com, hughd@google.com, willy@infradead.org,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, qun-wei.lin@mediatek.com, Andrew.Yang@mediatek.com,
 casper.li@mediatek.com, chinwen.chang@mediatek.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org
References: <20250922021458.68123-1-lance.yang@linux.dev>
 <aNGGUXLCn_bWlne5@arm.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <aNGGUXLCn_bWlne5@arm.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: mVdwLQo31O1QZTt5AA3sXDy552HXtO4LaBqA2c_KeM4_1758563944
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D065A1C0012
X-Stat-Signature: i5n8epzahcaio5qp4nsqutqae57uiz4x
X-Rspam-User: 
X-HE-Tag: 1758563946-103928
X-HE-Meta: U2FsdGVkX181RYrPm9URJzHEABtpPWt+s66BVa1TkmbQJFKuYxilWFH+ftCF6jZM8PMqElJvyulvHW/nZs5NV/i2jQFOjlr4af2wIWBAkK+nZ5X79cTh+4bvH+RqEdAn23OV6ImRrVr3UDcdiriMaY2Yt8cmup8Vo/9vb3tsA6BV6kHG7DGN0A9JOGAJ/4av3vwZbvV9qnPZnN2umksOmIWOkh4fbeh0lSu1oaU55XNV7YreTbduvcKQhRBeP+8Lbd5tkhaQQnlus5Iv/ewNbmvJexiBBFh5dc509NRwmW/WSeBOH+P/OvXfpFL4n6DFTqGdvAJJ0EZ4Ki7UiuqF9c/GKl4iOnsnTmm7zTaux2D8PU2DaPz3ld5D/ij0gf8SqnC+SlWGphAYKnCbJo8xVDduLy38uYESImhG+s/DXxys7iJCajCauUEoRPdGKKUAoPRnwSnnhHVxGGnPayoBV2zYON9ZMGi3vba8nsJHyBvRhYnn2WKyVVioMkRcrtRYKtp9sXCOUGFpBmJ+qvxjuBWrpOpy6Zl78QwBsVa+GaDCydrSZvF/KqZe8v9D75oPISAM65MHd8jE3tJc9x2MAD5hJSRXdlajLeOuYHEqapZwx17+VdDhfrFbu9ZmgMpFWzFBsDI4mXxUpZ9Z4rQVGZMyJxCdZOIkzZa7CtFrEuZR9PkwgauHPyAJHFQjj/BQjp3V7XW6s/aRg9IUrF6NFm5p7zRFWWMQmkLi8+IH2VTWVkIe/ob3XLkvMVf5aTl7Cmxl17jglWUZU5DLu4WOV5JYrLG4zBD4INPSAg6k90z/9SUlwJDNPhiejijmgahEuz90u1ll6AKcbXjSLiLgC9blhXKWyU1tHfOdaCi/Lcu5tM3CFpEeRb4FmNY6iUAs3ZkktIS46IxWsgK9Dc0dNKCC2J8zfyvzLyrMDfWdtLpbsY8h0qthczih3ROG61C6kqAt5zRWbQhVcNG4znf
 9c+2jcX0
 bQerB7avopbWG6C6UZqoaujbqKAYwUWFlKdmtlDR817EgZjYYR5kxWxZAvJtr9PycGKOUfKcXdN0ZHkXfboxqJuR2FPr3wVdx/NVBctysidKR0eIwWGi69E4qyus51HOc/hha6C4MJ/0Ic4r2+tMnAO31ZVjrWnK43ATzbA1FqzxRWT1gzTZBLJx60CA26ox5hfPcAokquRgA5/e3lsrSA2nw1kCYv3tazuld3pScSliyWgp3fAPHgzryyAytEv6Sy34FP0YhoaASX3PFaVqctxS6wRc4pyNhAtb5i0D2LEPmtdpU3W+fc1l2ZOqs267FJjtVzT0JHexIzcQLoPgkbHqKYjkdQC57GRKwArpbZvjqw3PICt4JQHQHRwzz0xR3+0D670CAgbt1S+Dt/sw7y+FDIHWw7ucQnJcCiQYpmvSGXeRpxMgpNUFoHCcr73bDSPgexuNhwETRQyLZ2kCFjaDyowUKNn32UpTHBADrBweQY6hH1p/Jlpm5m02ltMyXjYyzyEbdhW+903jQ52WgTc9p0pTvIJtf7WI5N3MTqpxJkCsmlP6vnz7dU7sn+9GO4wXQH7fRPVNfRwiMLOtmunBflFNLHboMFbvGIsiVzJNXM7GO6pUquHP9UXbiAfrz43lwkVjbGiyfihsZczwMaKpYthOYEzNxs4gUrSMOue+k6I8FpLBsFR1F8Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 19:24, Catalin Marinas wrote:
> On Mon, Sep 22, 2025 at 10:14:58AM +0800, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>> When both THP and MTE are enabled, splitting a THP and replacing its
>> zero-filled subpages with the shared zeropage can cause MTE tag mismatch
>> faults in userspace.
>>
>> Remapping zero-filled subpages to the shared zeropage is unsafe, as the
>> zeropage has a fixed tag of zero, which may not match the tag expected by
>> the userspace pointer.
>>
>> KSM already avoids this problem by using memcmp_pages(), which on arm64
>> intentionally reports MTE-tagged pages as non-identical to prevent unsafe
>> merging.
>>
>> As suggested by David[1], this patch adopts the same pattern, replacing the
>> memchr_inv() byte-level check with a call to pages_identical(). This
>> leverages existing architecture-specific logic to determine if a page is
>> truly identical to the shared zeropage.
>>
>> Having both the THP shrinker and KSM rely on pages_identical() makes the
>> design more future-proof, IMO. Instead of handling quirks in generic code,
>> we just let the architecture decide what makes two pages identical.
>>
>> [1] https://lore.kernel.org/all/ca2106a3-4bb2-4457-81af-301fd99fbef4@redhat.com
>>
>> Cc: <stable@vger.kernel.org>
>> Reported-by: Qun-wei Lin <Qun-wei.Lin@mediatek.com>
>> Closes: https://lore.kernel.org/all/a7944523fcc3634607691c35311a5d59d1a3f8d4.camel@mediatek.com
>> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
>> Suggested-by: David Hildenbrand <david@redhat.com>
>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> 
> Functionally, the patch looks fine, both with and without MTE.
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 32e0ec2dde36..28d4b02a1aa5 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -4104,29 +4104,20 @@ static unsigned long deferred_split_count(struct shrinker *shrink,
>>   static bool thp_underused(struct folio *folio)
>>   {
>>   	int num_zero_pages = 0, num_filled_pages = 0;
>> -	void *kaddr;
>>   	int i;
>>   
>>   	for (i = 0; i < folio_nr_pages(folio); i++) {
>> -		kaddr = kmap_local_folio(folio, i * PAGE_SIZE);
>> -		if (!memchr_inv(kaddr, 0, PAGE_SIZE)) {
>> -			num_zero_pages++;
>> -			if (num_zero_pages > khugepaged_max_ptes_none) {
>> -				kunmap_local(kaddr);
>> +		if (pages_identical(folio_page(folio, i), ZERO_PAGE(0))) {
>> +			if (++num_zero_pages > khugepaged_max_ptes_none)
>>   				return true;
> 
> I wonder what the overhead of doing a memcmp() vs memchr_inv() is. The
> former will need to read from two places. If it's noticeable, it would
> affect architectures that don't have an MTE equivalent.
> 
> Alternatively we could introduce something like folio_has_metadata()
> which on arm64 simply checks PG_mte_tagged.

We discussed something similar in the other thread (I suggested 
page_is_mergable()). I'd prefer to use pages_identical() for now, so we 
have the same logic here and in ksm code.

(this patch here almost looks like a cleanup :) )

If this becomes a problem, what we could do is in pages_identical() 
would be simply doing the memchr_inv() in case is_zero_pfn(). KSM might 
benefit from that as well when merging with the shared zeropage through 
try_to_merge_with_zero_page().

-- 
Cheers

David / dhildenb


