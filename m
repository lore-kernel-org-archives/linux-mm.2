Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB45AC87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 08:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8FF6B00BF; Wed,  6 Aug 2025 04:19:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 590106B00C0; Wed,  6 Aug 2025 04:19:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4576F6B00C1; Wed,  6 Aug 2025 04:19:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 328DF6B00BF
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 04:19:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E34BF11558B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:19:10 +0000 (UTC)
X-FDA: 83745632460.30.02D78DF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 5429440006
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 08:19:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JcuDpOYE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754468348;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znF6IF91Kjh9fOW1blnmEZLQNQBHGQn5QAy7B3RNZ1o=;
	b=8Uma6RT68e/4ZAWGl0PiQsnU7lY+MBswnvOV4jN5YP4p9GaSisSrnlfgbjgwzlJMr9zSAy
	jzZ6P49L2SAO09CBewjvk8xoKEIrmwLFVsIQ2hG+lGxg92Kel1StkF5IJlfF2k53fKEgX1
	BQQVmnaN2B2bsoM+OJSaneiK8T11Pjo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754468348; a=rsa-sha256;
	cv=none;
	b=v1KTRyaX7dX8hEVlUnOKEKhgdt5E+kjk7FBFXjqNPFV9uaZjHO+7pGNBXncEavaCgHRSxL
	eCxTwV3JhU36zVD30LYCliTtYPQ6R0TWsL2y1EVACVUYgI7VPUFg1zYj6W/vxuRcAF+3AP
	fuUXtKQQCeYWt+p8Fnn2DWupEn4X3CY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JcuDpOYE;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754468347;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=znF6IF91Kjh9fOW1blnmEZLQNQBHGQn5QAy7B3RNZ1o=;
	b=JcuDpOYEUWIMFVgAbvrh2pgLDPsUhxiwBIxY9TeB7mwyJYSNhaePe0r4a3G8dDzsPsMh2h
	m4zzNoCi21kDzwlzHM9SOp9vkBg74GVRUnCeA+ByrW5FomHmU/A03OHKFXKyVIYDDRBNf7
	FYI55VtaCkzNE4KCAEj0LSPHlBk7Zuk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-66-pF7yPI91OIiwt5c6RTZYLA-1; Wed, 06 Aug 2025 04:19:06 -0400
X-MC-Unique: pF7yPI91OIiwt5c6RTZYLA-1
X-Mimecast-MFC-AGG-ID: pF7yPI91OIiwt5c6RTZYLA_1754468345
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-459d5f50a07so16700625e9.3
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 01:19:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754468345; x=1755073145;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=znF6IF91Kjh9fOW1blnmEZLQNQBHGQn5QAy7B3RNZ1o=;
        b=Q6NdU33MOFsi4DRf2p8+40uWf1j8ZSfgtanvk6XtYy/Iv32xasMpA4YHzzCUH0Osig
         I7O0vhNZjUGyYGWYZd2KIrO4IAEqs5apz4HIJpVq6yHNe0fHe15OZhAyiqxKXBNelhzS
         v9TZ3X/M2M42TPai5UV9FtmZepwlaWjoBrtRsNEbbrzeYvvf45FRUSmusO89qdc9HAR/
         Gt6/atDv9X+BtCKHF8bGA4jSVKEjoj03esvfd+V2rv4ERWZwR8/r18IFpHlG6vSvZdtm
         NSNaZA9nXOMWypKg1LvIij/TOFDKFIX5xgwojZZMO1tZh9bqEjR0S/78kRATN6GxPhsT
         Eccw==
X-Forwarded-Encrypted: i=1; AJvYcCUWi2zSpiVwkGvZSIdInw65Hptxz83qAfAro6Adz2FMiOVYxAhdH1J9WvHq+rc4mzIg0Pt/yJVGfg==@kvack.org
X-Gm-Message-State: AOJu0Yw01DM5VVrSDRHW4mHXcwYvrW+rCk4QjOjUzliRp6OQoIKu4V2m
	gRjczeCfMRVYF4agtUYhG8WmnlWtf4szqmZ5swutfBb0IU4rqpHmUcC3ZlRxyTx405nkZ/4Zv1r
	ZtBPwjgHwVnPtRRufiBxoQ7AYd8EMhUKGSNGFzbvYuA/CvBSLrD6J
X-Gm-Gg: ASbGnctyxLyfm8VSShRFD3IFmSNRItoG2cxxrGcmHLS+7/wmKoB0Ph7aaC46PpmZ4YG
	o5oMT539jtS3Ch2rb2J8PVZp2CfXDnArne8YQeq0YNNWXN8v4SzAI0IDX4e1a+3TDQ5a8N7HIMO
	ftA7yKNSdRjjOywcx78PY4V5pxrgN0kziVm4xmgWn9nW5s+wy1GZUyIpL0WDsT788RPxQ2bn4h3
	ODQxmE/22dFohFwiN3xYgsI19jAlCrQOvL+hTrByNAX7tcDpmjyLtfkHSpqjCof30VP0M5jbazi
	LHm5u0YfWmJ3yPFj4jh81pa0CxaoaisnaJw8zp/lm42KdwIlG46Cb3LUEi5y/8bgxkU014UV/Ng
	XpbzfuIr74+ZZU83+4Ei7uIaB+vQ6af3OrWVKHo1z0ubz3TOSdOkousfcRUyqNA==
X-Received: by 2002:a05:600c:35c6:b0:453:5c30:a1fd with SMTP id 5b1f17b1804b1-459e7087704mr18139055e9.8.1754468345088;
        Wed, 06 Aug 2025 01:19:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGgROVHMEZgh0TP3BOKWjmCZln6savk2PzpCHP5awcCjYqYMP2QVJ3P1DIDcRnVzvlbVHqAlA==
X-Received: by 2002:a05:600c:35c6:b0:453:5c30:a1fd with SMTP id 5b1f17b1804b1-459e7087704mr18138545e9.8.1754468344556;
        Wed, 06 Aug 2025 01:19:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1e:2200:30f4:30:4011:370e? (p200300d82f1e220030f400304011370e.dip0.t-ipconnect.de. [2003:d8:2f1e:2200:30f4:30:4011:370e])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-458953cfd10sm300498035e9.21.2025.08.06.01.19.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 01:19:04 -0700 (PDT)
Message-ID: <2d213b5c-555e-4a4c-92bc-58ca8480ca64@redhat.com>
Date: Wed, 6 Aug 2025 10:19:02 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Will Deacon <will@kernel.org>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, vbabka@suse.cz,
 jannh@google.com, anshuman.khandual@arm.com, peterx@redhat.com,
 joey.gouly@arm.com, ioworker0@gmail.com, baohua@kernel.org,
 kevin.brodsky@arm.com, quic_zhenhuah@quicinc.com,
 christophe.leroy@csgroup.eu, yangyicong@hisilicon.com,
 linux-arm-kernel@lists.infradead.org, hughd@google.com,
 yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <aJMPOTripINrafxh@willie-the-truck>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <aJMPOTripINrafxh@willie-the-truck>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XiPGgaWV34PlDHDVaW00kRjR1KYYD28a7BGZ7hyMPiM_1754468345
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uepp9jtu1oc9ch9sr8rafhfbo667n7te
X-Rspamd-Queue-Id: 5429440006
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754468348-351157
X-HE-Meta: U2FsdGVkX1/XY0s52U9iel1ojSj3POIU8dNF8TGwIXnFHIWg3H53/W4bcbycCfPKjGjcURoWjnZJ9H045jpf6S1L0m//vL9NMW9wKsuNFKix6oFoSuInZsz8dINtRQJMUC/7kGg2acxfLog+FSlZFsazvADjSeQxGUKruYjXjEkY25gCwz++PB07RSwMPCiLqFru59bXUpE5Dlw1/DxxBz5x4nvH4L77amnbs7HzK6YSzLQ3DdW8STxzTaAae3EJnt3W+V8uAiZVJQWEq6S8qUeITG/dkq2Vg9OkQUbkqm+yQAOk7w8qx6ZPrsiz6Xum0lDXroyzrClYp5mqRc2KD5Zk1AAbD0iHdUZmMOo5fi+YmBT8aVfp/K0jYmeL27mj/VXZmFrHa/gDZmwjoEIkm044DH+3GAdo2K0DZFsLGcZJlRrzlCF/d/XxzIEx1JyIO/PIKHvjNayt8UJ8/yIlHFp537W323kxxRx02eHBF4QMxYpPssX7l47oBCuXYrc18wWb1Uqnw4Casfl+tk4XXRMyZClje4ZVsgibAiSY//EqF1ch+B0uqAKkhBBiFST3XFcedM8Z0ZWixG7LqHllz0Hr0QqXt0hZOp754tJYWM28rxBMKg1K9dwLFkYc4SSnNlR4aQrZ2sRv2jhEop2Y9U2muWYFlFRDlmoGHBfeJvzRrWG8os3GU7QVwejTj/vzfsh2W5+wbWksGmmwGSrf1DrH7YcqWzYHt/+eSgVchGeJFXIGIDMKE14k5ntg5wzXYLIlZGQ9RFQ8xXdgrYs+z8VAiLKCnMaRujYvo80EmKHoKJzifsRhXwfNP3+d1lWoHY5PMuEOowH4T8r0dpn8wb6BQFewuKDreaLlI5UFe67+1s/Y+VLsZYIr2CR0Nc7ayV1icg1FcAPAIiOl0DY7D9wI9xNcNriLGkBS1Ut6YqK8oOpMKk66wxHVg84rfB8ZNLzVktd16L19hIvOPF/
 EJSCWCsb
 r9FuHsFqLGO274T+tTPE7xDzwQxBx0/VWIYl3/2cB8fdPrQ8aVbNGVsqCA13aKxl4Ju9EHkPrcEtuwJfRM2/gX6Yu7Y4poWEiVhpMwJugYbrLYlBSOlqtSSWR8l56fyBAXq8pSi4UlMIm8HEWsx3BX+T/QzVp/QnaIQR7mSwkwaRSifN5Od8lHjuZw6dbD543M0JCnOJA+9X9DU8PdguXXfkDhRkvqQRFcUJ5wqwPFURIqGDBCfHHk85o4v4fyPma1upg/U+F9PGMNvj/G9BxIDiZB7+rNCLnN9Cd6avogrXk2YMEZutdGSm8Pbotd7djHhQJ73YfDo4mJzr54AR5CTSeUBfh3XRPxU+noXqbASUnzpXytD0qJuocXYHoPCb08155QXAlux5Ll36XKRFGPO+OnSFlcLseUgENjoDgamG+r+ggYgEgCYmwJNM+LfSUO6xmPGlf4nC2Q3Z+uo3GrvwqSBmRyTcy17hqQBnaNrAPDS6/QUFu/XFdJ1zMo3x79JHfso6p3okctabv/sZTmv++nH/9M8g4ytNmEsUK8HxsU9oFAMyQaf+4L2tgwah4J6uGk713mMkxLMHghcHK1oousw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 10:15, Will Deacon wrote:
> On Wed, Aug 06, 2025 at 10:08:33AM +0200, David Hildenbrand wrote:
>> On 18.07.25 11:02, Dev Jain wrote:
>>> Use folio_pte_batch to batch process a large folio. Note that, PTE
>>> batching here will save a few function calls, and this strategy in certain
>>> cases (not this one) batches atomic operations in general, so we have
>>> a performance win for all arches. This patch paves the way for patch 7
>>> which will help us elide the TLBI per contig block on arm64.
>>>
>>> The correctness of this patch lies on the correctness of setting the
>>> new ptes based upon information only from the first pte of the batch
>>> (which may also have accumulated a/d bits via modify_prot_start_ptes()).
>>>
>>> Observe that the flag combination we pass to mprotect_folio_pte_batch()
>>> guarantees that the batch is uniform w.r.t the soft-dirty bit and the
>>> writable bit. Therefore, the only bits which may differ are the a/d bits.
>>> So we only need to worry about code which is concerned about the a/d bits
>>> of the PTEs.
>>>
>>> Setting extra a/d bits on the new ptes where previously they were not set,
>>> is fine - setting access bit when it was not set is not an incorrectness
>>> problem but will only possibly delay the reclaim of the page mapped by
>>> the pte (which is in fact intended because the kernel just operated on this
>>> region via mprotect()!). Setting dirty bit when it was not set is again
>>> not an incorrectness problem but will only possibly force an unnecessary
>>> writeback.
>>>
>>> So now we need to reason whether something can go wrong via
>>> can_change_pte_writable(). The pte_protnone, pte_needs_soft_dirty_wp,
>>> and userfaultfd_pte_wp cases are solved due to uniformity in the
>>> corresponding bits guaranteed by the flag combination. The ptes all
>>> belong to the same VMA (since callers guarantee that [start, end) will
>>> lie within the VMA) therefore the conditional based on the VMA is also
>>> safe to batch around.
>>>
>>> Since the dirty bit on the PTE really is just an indication that the folio
>>> got written to - even if the PTE is not actually dirty but one of the PTEs
>>> in the batch is, the wp-fault optimization can be made. Therefore, it is
>>> safe to batch around pte_dirty() in can_change_shared_pte_writable()
>>> (in fact this is better since without batching, it may happen that
>>> some ptes aren't changed to writable just because they are not dirty,
>>> even though the other ptes mapping the same large folio are dirty).
>>>
>>> To batch around the PageAnonExclusive case, we must check the corresponding
>>> condition for every single page. Therefore, from the large folio batch,
>>> we process sub batches of ptes mapping pages with the same
>>> PageAnonExclusive condition, and process that sub batch, then determine
>>> and process the next sub batch, and so on. Note that this does not cause
>>> any extra overhead; if suppose the size of the folio batch is 512, then
>>> the sub batch processing in total will take 512 iterations, which is the
>>> same as what we would have done before.
>>>
>>> For pte_needs_flush():
>>>
>>> ppc does not care about the a/d bits.
>>>
>>> For x86, PAGE_SAVED_DIRTY is ignored. We will flush only when a/d bits
>>> get cleared; since we can only have extra a/d bits due to batching,
>>> we will only have an extra flush, not a case where we elide a flush due
>>> to batching when we shouldn't have.
>>>
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>
>>
>> I wanted to review this, but looks like it's already upstream and I suspect
>> it's buggy (see the upstream report I cc'ed you on)
> 
> Please excuse my laziness, but do you have a link to the report?

I was lazy :)

https://lkml.kernel.org/r/68930511.050a0220.7f033.003a.GAE@google.com

> I've
> been looking at some oddities on arm64 coming back from some of the CI
> systems and was heading in the direction of a recent mm regression
> judging by the first-known-bad-build in linux-next.
> 
> https://lore.kernel.org/r/CA+G9fYumD2MGjECCv0wx2V_96_FKNtFQpT63qVNrrCmomoPYVQ@mail.gmail.com

Hm, mprotect seems to be involved. So it might or might not correlate.

-- 
Cheers,

David / dhildenb


