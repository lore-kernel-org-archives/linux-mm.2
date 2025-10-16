Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73901CCD199
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:13:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F5D08E0022; Thu, 16 Oct 2025 15:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A6CF8E0002; Thu, 16 Oct 2025 15:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 895628E0022; Thu, 16 Oct 2025 15:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 791BE8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:13:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 555B41A03EA
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:13:57 +0000 (UTC)
X-FDA: 84004927314.26.C379165
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id E329C8001B
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:13:53 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DwNNa1xl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760642035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JaZdjRa7yEZiZyCMhP1rrLiVtpOhbGtyEZuYlYpV77E=;
	b=ysub8sFjM6DhaY7/v5crUyXryKmANJ4pgR5EQ2Lfxe+udLnoS4ywMbK0c08OyJQPOL43pR
	VfEQbRWeGoErTfjulPHQTic2iOhgGkY2jt4hYh5uzF4/+SURcdTtfk/bII8UFwa/MQaFLi
	g5TtHb9qWfJlZ5pluaqO1ZnaemDWRgQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DwNNa1xl;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760642035; a=rsa-sha256;
	cv=none;
	b=QhPmiUzBfUb0FgQ2g3t8enF8aE+4EZOekWg0JHESRWq+GGwH58//3p0X1/KvpX3mzPt0TT
	XexkWB3ZSqI2TuCbHaKqcN/cezrHkQKY74ZYHO7Rygc+kmjQChkhdJwwl6Ooi0Nb5ynxiP
	fa/FlpLbSk6qjlHzgsgQAHwsQQ/ozEA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760642033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JaZdjRa7yEZiZyCMhP1rrLiVtpOhbGtyEZuYlYpV77E=;
	b=DwNNa1xlsxzc3adw/mUYEc+FBpDbHUX5y2rSrMR2oYO9Nijm46za4j/v80Wq/c30s/wED7
	ijvurSDX+Fj+Iul+nE/TWz3itI7LKg5hR5q5Z9NDAF4NHekngaYOkPKd9G0qz/1eSSgikN
	0zeO1dyurTSKQ6Zz4VqhL60p9XNyB5Y=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-613-fS9khH7hMLm7gcq2rfWxbg-1; Thu, 16 Oct 2025 15:13:51 -0400
X-MC-Unique: fS9khH7hMLm7gcq2rfWxbg-1
X-Mimecast-MFC-AGG-ID: fS9khH7hMLm7gcq2rfWxbg_1760642031
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46e4fa584e7so5168895e9.0
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:13:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760642030; x=1761246830;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JaZdjRa7yEZiZyCMhP1rrLiVtpOhbGtyEZuYlYpV77E=;
        b=HLnD9iHPhDo3wpfWBGzyCnFX54Qoql7926C3tWdhjkhkqVcfB4MNUJGrxd4/OVz3j0
         e3jmtXnAioUzUETmuqp+IUxsk6uyHPq6Pu/+fFGOX84Kaz42qevcn/d6KdZF6j88WhOe
         QdDxxXlygBkMjX3pNTXbp3wNoSoifCpTRwXZYUthsfvDwTklEzvs3wBaTX6d2Z2lDRWx
         PTP8xDCLte7/zZ7IvXSORIZ0Az8WTLHLtbhy9zE9OrgJUX9Xz7Yd3PXjyC9Eb5buQ490
         bmIV1nKZsY1CkZBujdQ1gUknqn8p3hJMZwXiObi3fXbmayN8iBIMRUjt8fB5W5BYtV/J
         hQXg==
X-Forwarded-Encrypted: i=1; AJvYcCXVCt2Fe6klpD6yg3Jdz3/ArN6mXwvgi87+hyDO6KJA9l8c1M0Jh4e840MkH5k48GOasZVny7L9tQ==@kvack.org
X-Gm-Message-State: AOJu0Yybyy/LJV1s3cTIi6A+Z4FVimlNl4HWDkkd8KOBZPLfwgtA4/mo
	esepc1QKafwkajAKi+Yghu6EWddghKFSuCsIQCTz28KO3r0qVcI/r/uU9MgPOV4Rk/SogYD93sn
	nkypNn/rGhihtcyg51i7oPbViyLtTzZgSAK+kLuKYUjuW/z+hYoKp
X-Gm-Gg: ASbGncu4FQXX+udp37GmK7hz2QB/eUGTIGvyMsPDdtYGzXc9mlUAqai8fSox7MwF1fg
	xjCsBviubljiDygCCmayhZZ/DA4rPiUSEI3qAfDvInVl4QkIOlr7UVrk7QRMMAhOp9OBGBqFwiv
	A5upufUQ0VvqQP0xrbvfVZDYN79m2qZ55Je78dDTda3rcgkibrTMsUD74+P4p3vV/0oG2WXb63/
	k3gWg8BDRDF9RysntMqJ6L+By5dA3q+Zuns+UV3dD1v1zBLIoZpIg+uFrLe1GdI/3THmXjpQwKq
	wIX3u8tS6lwKRBAq26BQa4PRJA/Xbff9SrJ+0aDACSkvBPR1aZpY207UOLaEYQfdCIxTFjEbBmz
	8OBtSlKmBZkEPEafshCOkEoaGtmL1bynohNbO3fghBoN1ysbwU0nv8koga16mEHLFKySM3gTEyg
	7U3ZqCyMOZ2HDQ39K/IxSmrFv8Bp8=
X-Received: by 2002:a05:600c:5287:b0:471:7a:7922 with SMTP id 5b1f17b1804b1-47117874a26mr10089205e9.6.1760642030627;
        Thu, 16 Oct 2025 12:13:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IENXdoVpKL4SaZsI8wh6bbHQjJKXIIrDbzHNFmgs/sQ0Xp2kcBJz/Qzps/cepiaqf/0WuYRCQ==
X-Received: by 2002:a05:600c:5287:b0:471:7a:7922 with SMTP id 5b1f17b1804b1-47117874a26mr10088955e9.6.1760642030199;
        Thu, 16 Oct 2025 12:13:50 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-471144d1765sm56096685e9.17.2025.10.16.12.13.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:13:49 -0700 (PDT)
Message-ID: <f9d4b143-be84-47ee-9ff9-43169ea592b6@redhat.com>
Date: Thu, 16 Oct 2025 21:13:48 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <45084140-cd90-4fd8-bd31-f1a8a4d64bad@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <45084140-cd90-4fd8-bd31-f1a8a4d64bad@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: jpHEKayh8nPNO81GZSLEzJBmqcxZXL4p60yln-vbZ28_1760642031
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E329C8001B
X-Rspamd-Server: rspam03
X-Stat-Signature: azbk871yd8czo1segjtzq6bju46r36df
X-HE-Tag: 1760642033-80384
X-HE-Meta: U2FsdGVkX18v7WkTUx+HqrUri1FVawQPH3d10aGBIDoRSia9BOQp1h5uXF8f6mtfgImPIK+A9sx8QJJ2U76uUBy9qP0x/ZXVwT5n/fVdJst0M9ESzwTcaGTF2bMrl82/kBU6zPEzyvOQFJFfq1//AiDLZv2XV7xXPzlYLaidLRbLQytStEiwiICmf4SwESJ0kU1QR1pRYqwi8rI2SLhRDk4Qp+wGfKhD/G9pUAxLna7aStzXlFwONFV79NZXKrPQdmbdNCeRfkJKDyia78JNaAivuux3t0e6o6vsGqUcbsSrLpqIkEVpEF48Kozkov24OU5V0uev9dQ0sDJ0xMfG+DX1yV8/n/Rn+MEuie4uA9BySddwzboYIg6ym9LBGMdXuBYrpI6LBXmDl7qywimKuLHLnwe0HVcpghgq069Eolop0FjNbJ0EJG9FYY0Uoj4oZ0tuaxM/oeadp6T9zhHcHZ33wJ2hLUD2tvv0iO8TtbsH0nkOnoU8DXBsPPCIeKvBVeLBHUW//6RsPXvCXtcAEj+0i5ybA5OO5C+5BiLvnCOVAM3x23jvEOUKpyCyieNH+BLbtT4RrNpbJC2vNRZ2RoEwqVanWVYTdj7wL3a/4542QUbPLCwHUXL1pkgtDBmbBJ46gBAnS6+br1XAs3UjgWQzLpHRJpkw2MGkB9X1VKT+ia5/01KYTM69O3vl/QatPtDLZXPEz5oMQda1fXH5Cy2FRH+8tDG0Q4xHCCVaRrqqMG29vd+hEZzw3cKE5qsD5D6tYnw/xPWcaP+7NG+7wAtfMUUU59t7c5Hf3yrM2WT8GCBAW4CddWkwTmGmxmb5iAsoCrl3sBszyRf8HLobVlWOHNC+eMt2tQ3RVfQqFjxAbS2GVluNZ3C1QxjiGYd9ARmLIX4gS4/QKWD71jXknimaR2dvrh9nm+/2ze4NYlzOQAqUYV18bs4ArAFE2IvORRo9QHxe7bnRtGx0Neq
 eGbUiA/g
 9h0+pRpJxHtAoDNj0TCE0Q7wv6drNuPqP40HFk2UwpmdIhb8xXJfiOLdTeDGzjt8I+QqekftBkXa+5mMm7P83jW5wr6mRapnZBCG+WDJmQmO48LqCPtlcDBrhddlE8OgQmqZxg2l+Rx5rt0pHqGYaFEdfpBhfjZFjYpTM8+NL94rlQYCkHiOHImG3XixNsfg03cXvXZKVLdOx+xKLfVhcZ6AG9pHifSUxNLgVU7oLJwAJunsRB3VfqO3XgRYW10/Oo6pXKp9yd1EDIv1sASwKu0rD+7KPCbLErzLxx4UL81Y+jIKx5/CInOIjyvQEljBl0BKoZCxkIK5I505dUmMFD/GOWaYsViOoRXjtR6UD+crtvZnn9VdLZBSSwJH2NwIB2ISaXdCyitHZBnU3rkhIVr96JArDdEsckuVNXWovl/0XPjxlM8VieiN3JgrPt+zEaTEVMbJU/ARN93gHuY2gvQcdgMCmr5HXmB7GaUirzjDkW4LqSIWwPhvGbUmsB30cwzoEgQZG5xv/Njg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>
>> (I don't understand how the page table can be used for "normal,
>> non-hugetlb". I could only see how it is used for the remaining user for
>> hugetlb stuff, but that's different question)
> 
> Right, this surely is related only to hugetlb PTS, otherwise the refcount
> shouldn't be a factor no?

The example from Jann is scary. But I think it checks out.

> 
>>
>> How does the fix work when an architecture does not issue IPIs for TLB
>> shootdown? To handle gup-fast on these architectures, we use RCU.
>>
>> So I'm wondering whether we use RCU somehow.
> 
> Presumably you mean whether we _can_ use RCU somehow?

No, whether there is an implied RCU sync before the page table gets 
reused, see my reply from Jann.

> 
>>
>> But note that in gup_fast_pte_range(), we are validating whether the PMD
>> changed:
>>
>> if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
>>      unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
>> 	gup_put_folio(folio, 1, flags);
>> 	goto pte_unmap;
>> }
> 
> Right and as per the comment there:
> 
> /*
>   ...
>   * For THP collapse, it's a bit more complicated because GUP-fast may be
>   * walking a pgtable page that is being freed (pte is still valid but pmd
>   * can be cleared already).  To avoid race in such condition, we need to
>   * also check pmd here to make sure pmd doesn't change (corresponds to
>   * pmdp_collapse_flush() in the THP collapse code path).
>   ...
>   */
> 
> So if this can correctly handle a cleared PMD entry in the teardown case, surely
> it can handle it in this case also?

Right.

But see my other mail, on architectures that don't free page tables with 
RCU we still need the IPI, so that is nasty.

> 
>>
>>
>> So in case the page table got reused in the meantime, we should just back
>> off and be fine, right?
> 
> Yeah seems to be the case to me.
> 
>>
>> --
>> Cheers
>>
>> David / dhildenb
>>
> 
> So it seems like you have a proposal here - could you send a patch so we can
> assess it please? :)

It's a bit tricky, I think I have to discuss with Jann some more first. 
But right now my understanding is that Janns fix might not have taken 
care of arch without the IPI sync -- I might be wrong.

-- 
Cheers

David / dhildenb


