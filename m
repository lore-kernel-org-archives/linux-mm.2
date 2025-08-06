Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6960FC87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 09:21:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC03F6B00B2; Wed,  6 Aug 2025 05:21:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B711A6B00B3; Wed,  6 Aug 2025 05:21:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A38EF6B00B5; Wed,  6 Aug 2025 05:21:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 939D16B00B2
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 05:21:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B957C04A1
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:21:56 +0000 (UTC)
X-FDA: 83745790632.23.4D27D26
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id C026580004
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 09:21:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f8alBsva;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754472113; a=rsa-sha256;
	cv=none;
	b=vK+ioIsMpNJFYm0Crmnwa5DjUbtaBkoDjF25kOq3kX8+HKjZz/ue/0Tp3nelVAY+LWosYV
	rgfzI5G85NwiHKAO2V0wT94SkMKBK4Dg/D9d/Vo8JbIeMVak3q6POvk7ZlpxECpsm0h9kb
	8xdsPmtRS+Ceu8QSqknmJCLPcmRSorM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=f8alBsva;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754472113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLnz3o9ocsbKZkd4mi2GHRZKQa/a0FBBbJaZGX0Q0vc=;
	b=IdN8AxIxoImEC/sWVn9p4EpxANIKWh57iBI/nMHHLFZfVSCL3h5ZpOzMu8QnS9l8HKfoAc
	unCePwePJBR2jvESBSnpWoMK4/9b6DykOoUcTZ0YP0GhpA0f2iVu4kO6879w0aEKUwck39
	ze/g5fH9iOUk7NsbmDkVU4TYyRPb0XM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1754472113;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=TLnz3o9ocsbKZkd4mi2GHRZKQa/a0FBBbJaZGX0Q0vc=;
	b=f8alBsvayUpyqKNEVGqHGYbxZo5zrhBoV34afBo19ojEsQI9loIKmX0gR699IIFgo6gTVM
	JHspjw52XjclG0JIRp3pRuldtpI7Vlr9SvCpmpYMbQr1zASTNw9cgUoDvMSpRElbk9dFZp
	mi10TKMDQk6r0G0Wqw721Exwc7wOmPQ=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-425-d2mRl1EoOruXYOJBBtcMKw-1; Wed, 06 Aug 2025 05:21:51 -0400
X-MC-Unique: d2mRl1EoOruXYOJBBtcMKw-1
X-Mimecast-MFC-AGG-ID: d2mRl1EoOruXYOJBBtcMKw_1754472110
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-459d6c83e2eso17334245e9.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 02:21:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754472110; x=1755076910;
        h=content-transfer-encoding:in-reply-to:organization:autocrypt
         :content-language:from:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TLnz3o9ocsbKZkd4mi2GHRZKQa/a0FBBbJaZGX0Q0vc=;
        b=k+AOwsmALSeU9Iw2EkqC89NgwHXROgJHvIKy1g4nc7c9oCkIEMStyqKKevcIVQq4m+
         Us+/DIyFsgVsrh+t4fk1n7XbAL1vpt89yENVuFcrEHKIJTnQg87RKKpPxSrWbl58B/oS
         l9XgpMDwDq8tqWIjJt78cOvmzjFA//+ibK5Ra0t0FKFo3L83NWNaiSgvDHE2LvNU/2Kx
         sN7sk8JtbvpR+DzWE/6VmKeBmnu/EOLa4CGbKWyW6Mhd5X0AYGYbjc5imys6Go5SrMwG
         69Sy7YBUY5TQSAYDu4wHrzmjnC0BtlLmIumzUGDFJaYra7tNVsB8fDbQdy3Wsul6eZ9C
         772Q==
X-Forwarded-Encrypted: i=1; AJvYcCXkte8s1t4DFjv8LK62YDARj/D+xZm9BmUuV1hXLd2asGjmjbTpE5JPsZofJnEhKSHsJQLljV0oNg==@kvack.org
X-Gm-Message-State: AOJu0YzAyESMI4ftFqG79GIggTJLRWb1R7tSMHmN7gPsYi+R2J7k4usE
	bACshgWXKoaWae8TlwgljxTzOHWuDTrs4b5P2G5iGbNUaBoPJE/Gdwf+LIykJV7XMo8vZxlLb4w
	Nk0e8yTS/qWfcTOSKuiVDvYgHHy51uBeqi7Ekzla/Q0hvrhCmGfWK
X-Gm-Gg: ASbGncsHRTix11vmz3IEMQCchxTE2jWOt4X7y7vAuHksCPb6o5G6BXnUbYtfFP3rwJs
	Yf8WTRy6Zjj2j1HmW0EVhnb073q5rE8yZ7aNxrms3+u1SwyiNCYXGQEjz4TmTZc8v8bEUfgdK30
	S80nrR9pSfnaPlQ+ov3+fPt5r41aDeKT59THYXHiP+Dm3qdf25q0nMbfk4pBa36lK0MDeCPHeAl
	6+CbmoxGwzuzeIR8htX/+alv/zpmF9+h9hYUNWXTYrlCSV7yAiXxc52TQyPzRNep7ZDvacgIy1W
	VPj7dowNdQGzjoyjvQRzyxq2o48ojnHvpD+FcZ48vC6urZW8tJl0yfVvdObeGzw6Rvn1g2vxQYk
	fy5FD9lwppqJI4Ckg1uBBxwJs77aeEdxqfCACk8Tgj+7Buro83ZaOCpe+ge6hg+mj6dg=
X-Received: by 2002:a05:600c:1c14:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-459eb99e605mr326275e9.0.1754472110309;
        Wed, 06 Aug 2025 02:21:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENkbPszpIki01VcMNi4ikQjySykp+PQiRvKbqALptq2NByD+y+1DiNLmRqKUdKH+LjkIWGPA==
X-Received: by 2002:a05:600c:1c14:b0:43d:9d5:474d with SMTP id 5b1f17b1804b1-459eb99e605mr325895e9.0.1754472109803;
        Wed, 06 Aug 2025 02:21:49 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f35:8a00:42f7:2657:34cc:a51f? (p200300d82f358a0042f7265734cca51f.dip0.t-ipconnect.de. [2003:d8:2f35:8a00:42f7:2657:34cc:a51f])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-459dbba5210sm109716695e9.2.2025.08.06.02.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Aug 2025 02:21:49 -0700 (PDT)
Message-ID: <54ee1971-d91a-4fe6-90b8-16212c8568d1@redhat.com>
Date: Wed, 6 Aug 2025 11:21:47 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 6/7] mm: Optimize mprotect() by PTE batching
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org,
 ryan.roberts@arm.com, willy@infradead.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
 Liam.Howlett@oracle.com, vbabka@suse.cz, jannh@google.com,
 anshuman.khandual@arm.com, peterx@redhat.com, joey.gouly@arm.com,
 ioworker0@gmail.com, baohua@kernel.org, kevin.brodsky@arm.com,
 quic_zhenhuah@quicinc.com, christophe.leroy@csgroup.eu,
 yangyicong@hisilicon.com, linux-arm-kernel@lists.infradead.org,
 hughd@google.com, yang@os.amperecomputing.com, ziy@nvidia.com
References: <20250718090244.21092-1-dev.jain@arm.com>
 <20250718090244.21092-7-dev.jain@arm.com>
 <7567c594-7588-49e0-8b09-2a591181b24d@redhat.com>
 <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 g3eXuA==
Organization: Red Hat
In-Reply-To: <9552ddff-d778-4934-9349-37c7237cbb78@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 1H1-396rGdrRHf24cpsj8qx04TN9Luztpw8t5PfrPbU_1754472110
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C026580004
X-Stat-Signature: fiuhabu3fxzx87arhz4eqrfeyufgoauy
X-Rspam-User: 
X-HE-Tag: 1754472113-772321
X-HE-Meta: U2FsdGVkX183fYthFii2HUvZjHQYftpoy2j/f3cX4e1iA+RomR3i5SUqtGwskjWCJQEBgXk8pjIv3zB/sHwD+WGzs7OHIgbcD5mOxtsaGQhAiU7c8gnfqIxwVMQaNEGOyXB6dGqvaUZVSMz5oFPXLNoEsX/mnljn2aTNdm5D0ptbtwuPFbC2j3UjOyV+jeFs4KnM/r2c23m576RXVMAuGDw1YuSefXR6u/rfRbs/GtXFRj1EMvkGTwgwMkiHzd08f/zbwX2KeOdJKqNKP+FxccveI3PyYlo9CPksPRvxXe3eJo7jqSpIr6gUDN4Cupch0pdlx2E0wHHsz2Tkgumf+hG0o5M54FCspiTWvrcv9KaY8c9ycn/sAKegptdEE0qWEwmnwumu9JCIgDZPsWqH6FCzAhghDcZnHn77RHD8wjcp07+uUKYH/JDC2GVrpB9HOAGKrBYSXylcp6Q2Xd82ghTuY2zB4yq/tJ9CiFN5fZv2Xi+4kCczyJ7n8hWeqANVDnDAtACaTUSFqBTxeD7Q08xWKrvfa/UifKhUHhtszk/IXtB6NPUEkK8waTzDcG1X963pr4dCtp3eXTMNnyG1XGKIsam4ntQaSS3yxad/h4pDFYVEadf6Hxv53wFHsbGqbPXzzcQC6VgMxfC+YdzWGh0iMD+hON2LOjiiE2v02CcagUO/3tfTg3+ysnU7KQBD0K1O6y+X992cgGWadVc5nfFJKwM19Y6R46QdSITYIrnwQo0Uxj8RRVnlixaawCgVp6KdrbcswnMSr12qhyyVsHTT4SOnge//uLwiKRPNFMVI9xyvSSjZVvnxChp93+UMfwE/9oi1Bno9M24ZJrWafB/K5ZakAUc+z0DYw/snZQZY9NUhwXgpBYLwe8nvGeHL185mvVU339+dVGnW+AUXCG+ME3vMBstclke174a4r3vPDGOb+tXc/CGuUfk6C8lCAOCGE4qA5X7jYeULX6Z
 zqLTF5NM
 V3GwVH79OisRpFNi3pZuidjbHJ2f/EKU1PahN6RgXp/9AMSdKnBpWdNrebhQa4Kpy+Yi9qE2HeZw9tEOEnTxzn9O7hfLZ7wmAGbeP2zifDKk2YYNHJ3+fYjengty/Zoq8CbPeBDsasW3fdecN6uX4xZtF+7yd0EPkypz+/bMJjs0v21Ss5+EI0TetCT2u8y07X5BI4QI3VXfkNcx5KUproyJaEXkqhTfIYPnzC4L0j+PwoItVvOFHypEyZo3nyHHHDKIq9b/qcuPWGaE/jfO8EZmOnmfJDvnyh28Dyb/J0oMGD4UaH37UWEFDr0t/8oQpjXQVbgDQvSREI4jxFIfSa4xWoOSF9otjUWqJN41SbadH1N9KiXEmp6tlNwzgSo+q/S1nrpOTXrnQEQ+E6KIEoYSGHqGRwA23WLRiTt+kqN98VsxtcYoYfGlA8LWWeJWnN0jRUBevq2ueXSNW6QD9Y2NAe0jHjUvket04l7fVcO00KYM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 06.08.25 11:12, Lorenzo Stoakes wrote:
> On Wed, Aug 06, 2025 at 10:08:33AM +0200, David Hildenbrand wrote:
>> On 18.07.25 11:02, Dev Jain wrote:
>>> Signed-off-by: Dev Jain <dev.jain@arm.com>
>>
>>
>> I wanted to review this, but looks like it's already upstream and I suspect
>> it's buggy (see the upstream report I cc'ed you on)
>>
>> [...]
>>
>>> +
>>> +/*
>>> + * This function is a result of trying our very best to retain the
>>> + * "avoid the write-fault handler" optimization. In can_change_pte_writable(),
>>> + * if the vma is a private vma, and we cannot determine whether to change
>>> + * the pte to writable just from the vma and the pte, we then need to look
>>> + * at the actual page pointed to by the pte. Unfortunately, if we have a
>>> + * batch of ptes pointing to consecutive pages of the same anon large folio,
>>> + * the anon-exclusivity (or the negation) of the first page does not guarantee
>>> + * the anon-exclusivity (or the negation) of the other pages corresponding to
>>> + * the pte batch; hence in this case it is incorrect to decide to change or
>>> + * not change the ptes to writable just by using information from the first
>>> + * pte of the batch. Therefore, we must individually check all pages and
>>> + * retrieve sub-batches.
>>> + */
>>> +static void commit_anon_folio_batch(struct vm_area_struct *vma,
>>> +		struct folio *folio, unsigned long addr, pte_t *ptep,
>>> +		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>>> +{
>>> +	struct page *first_page = folio_page(folio, 0);
>>
>> Who says that we have the first page of the folio mapped into the first PTE
>> of the batch?
> 
> Yikes, missed this sorry. Got too tied up in alogrithm here.
> 
> You mean in _this_ PTE of the batch right? As we're invoking these on each part
> of the PTE table.
> 
> I mean I guess we can simply do:
> 
> 	struct page *first_page = pte_page(ptent);
> 
> Right?

Yes, but we should forward the result from vm_normal_page(), which does
exactly that for you, and increment the page accordingly as required,
just like with the pte we are processing.

...

>>
>>> +			else
>>> +				prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
>>> +					nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);
>>
>> Semi-broken intendation.
> 
> Because of else then 2 lines after?

prot_commit_flush_ptes(vma, addr, pte, oldpte, ptent,
		       nr_ptes, /* idx = */ 0, /* set_write = */ false, tlb);

Is what I would have expected.


I think a smart man once said, that if you need more than one line per statement in
an if/else clause, a set of {} can aid readability. But I don't particularly care :)

-- 
Cheers,

David / dhildenb


