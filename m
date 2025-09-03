Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E62D2CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 08:11:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480E98E0007; Wed,  3 Sep 2025 04:11:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A2E8E0001; Wed,  3 Sep 2025 04:11:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AAD88E0007; Wed,  3 Sep 2025 04:11:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FE968E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 04:11:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C60E111A383
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:11:13 +0000 (UTC)
X-FDA: 83847218826.19.597D5BD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A9DEA0006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 08:11:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TyrXk/NQ";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756887071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8UkxVY/g1eI/pJSPhScZgnxFl4cSUR/RLbF6nS7dre8=;
	b=3slxO7i64Lt+YzQ1YZCED70x6S+WsV867X/3Io+wvnqJhRyHjGx1c5L0N76NISYfyk3iQH
	zQinjfGRLe/XPZOcQSY9qem3OmQNbn59viRh/qR52BEEubc13bWTPq0N/4LyFTaU6HRLoT
	DPPnno1Lmti77O6sFL4360rRpd3Per0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="TyrXk/NQ";
	spf=pass (imf15.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756887071; a=rsa-sha256;
	cv=none;
	b=CNuu538EC5XbJ/9z23I5gZv/5/gHaqhEDpCYzx8kEQbknrp0mn5c4QK+WeeYbIa42jsN2n
	FG4MTOzwYDHQJpmn/q3Zhibe+OuxjDKeTPQ+rpcTN97c+g54zm+FnzxQyvSOaB+CJngWCp
	WoomQqkBzDzfyZRg/0YcSMG+dcmuRE8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756887070;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=8UkxVY/g1eI/pJSPhScZgnxFl4cSUR/RLbF6nS7dre8=;
	b=TyrXk/NQksavwA4asZcQZ/ICxNncpkzWqSCaqzoatx3nLE4rANYLSCf3lSRqDzYLMaJyYx
	T6kXKC9HpuzwR/QciD3P050b5wPblEopY6bJD1havkxKR7b33faKOy0cPRPAYxYUKRW7Xt
	vOcuqr/wpB6Kbbtbm6YHIsJNlGjavUg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-693-7HrGsDBaObaDr8Nr7JdAMA-1; Wed, 03 Sep 2025 04:11:09 -0400
X-MC-Unique: 7HrGsDBaObaDr8Nr7JdAMA-1
X-Mimecast-MFC-AGG-ID: 7HrGsDBaObaDr8Nr7JdAMA_1756887068
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b8af0b986so4852525e9.1
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 01:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887068; x=1757491868;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8UkxVY/g1eI/pJSPhScZgnxFl4cSUR/RLbF6nS7dre8=;
        b=Sq+Otfefb0/WA6PI/QyvbrQnlxzpA3I6Di75354A7ecnqXcY5H9Q8cfSwCqrMSpExj
         Ng5USxlULz8L2xrf/aKmrvk2phYVgICc0HgfLTBENZ6KDqu/bHJnRsHMJ66VompWk+cH
         lvcZr3EdGFSTI/n7f5msKE8t1zAt9zTiUlXk/tbku5MdIw2SDjMrXwyLpO+fW4wR/CVF
         gLgvu22O+cXnJmP7akv2f+5UgwVtC3NtIcKGz6I8U4ukUmhcCN/scfSLyONieyfhFDYt
         mhY1JYTBd8y26xEI71GX447cX9sjcdFZT/MinUDWzWkWBkbpjLg383iG33/GqLqo5HJK
         GIIA==
X-Gm-Message-State: AOJu0YzzsbSQW38ET0nQRiu7Z72fxLSAM8FUDvK/BB5Gt++NngR2kdAf
	YtKkPOIIstyQFlngHjSaWoWBMaAzt3DZnkdtaEpW+o2vPNsMJV+pzpIM0BURs11rzo+t9YENGTh
	s/gD8b6wnTvYtJrjaXTIzqy74IEk079KdxUN1kc315gy3kvM92VJF
X-Gm-Gg: ASbGncvT8YNYxwuJQssstl1+wVFIDl+5t7wKRr+iG5YBzxF1zp360x5gvihE0kJn4Qa
	/IME1xuI+D3Hhw7pf2uLAG5pMOyO7tphOZ62FpAKmIUOF/fGs8OWD7CUT2uTZ66Y4bENZHtrVQd
	glcQrXnw0qxg3ytwYXP2CN3GkSbjv/dbKz1xYA0naX3Ky64SNyPrsqIBpGMYGKghDIp6BS+YNJQ
	o4LRdkaFssAMGJLa+UE1vwAZtti+2eqqpJE+vPaUdofSFEiKHEeKa8KFOqM2EG1w7gngVltGhTO
	XD/SVznyJeE2Xr9HZliU/pTqCld3tvz9dLAo7JpeMpKlZn2L/6mOixzYfBROlx+TU/WisvsVBmj
	2WBiCPDGkcu++dGKNcNSaF77Dd+h666PDURPCkqLr7KjRULhbaUbMruBG+a2DL1w5a6w=
X-Received: by 2002:a05:600c:c4a1:b0:459:443e:b18a with SMTP id 5b1f17b1804b1-45b8559aff8mr131317665e9.14.1756887068452;
        Wed, 03 Sep 2025 01:11:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEDxGXVQhvmfQ7QL41Vte3hx4orJbJWoRMyeFq2/Ey7ZnhPJtVK5izMGQC+aAFle3fgJPi6zg==
X-Received: by 2002:a05:600c:c4a1:b0:459:443e:b18a with SMTP id 5b1f17b1804b1-45b8559aff8mr131317115e9.14.1756887067920;
        Wed, 03 Sep 2025 01:11:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b7c461edasm140355785e9.9.2025.09.03.01.11.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 01:11:07 -0700 (PDT)
Message-ID: <cd52244b-12f6-43aa-9db2-925348566bed@redhat.com>
Date: Wed, 3 Sep 2025 10:11:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info
 helpers
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>,
 Chris Li <chrisl@kernel.org>, Barry Song <baohua@kernel.org>,
 Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosryahmed@google.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org
References: <20250822192023.13477-1-ryncsn@gmail.com>
 <20250822192023.13477-5-ryncsn@gmail.com>
 <39087ce8-6f6a-4998-95e4-813e265318d0@redhat.com>
 <CAMgjq7C+mChdnbcrYEkKyuuRN9-THXwBdFeCVwvW_m-_CWCzvw@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7C+mChdnbcrYEkKyuuRN9-THXwBdFeCVwvW_m-_CWCzvw@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yeZdvigDC1cV8zgWa_mM_yS9C80Ke4AcPq5XTXFZyNA_1756887068
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6A9DEA0006
X-Stat-Signature: di95nse1pp9isdjnbix4ab3wk573gxgf
X-Rspam-User: 
X-HE-Tag: 1756887071-939943
X-HE-Meta: U2FsdGVkX1+BIWwbwqvnhm98TDLzGS97Oe6QrmlcGq/pZ20AL3U5fBIPkEAkk2jXbkVxACtdSljmEqc9lINa/sT37CpoEbjhyDYKjBO0rgydgmwPORb3+G/GOd2nzInhUR9XtgdclOllZYWdzjMQNO2Y9vVMLcLmBLtesMJPivNDyy+ThtVY0P68FExRsNgbb3+1DlOCnkZDP1HGCOxvSmkJa+KoUrqyIKZXF1apGPmZDa1lgpsRg5irrHtl/Wltf35p5QK1gGG/NDELggZSzW6HBlm7sLz1BKmmsuryePLHc+Tk/j7EW4In6JrRXHZoHLQjDgQF7DAU86XMRmtRvrdeFHMZsZo4YsKcURVBDLFs1O1ww2QDrQD3i0aZqHs4C28mz9p18YownxFlEzdoR+HGjvMIkMbiKOxON/+uFYlsCdMbzCRxcjchWOFRA3xQbb644VPtqU2272in4t2eRlPumSFPeX+90Yf6FVsBZYLW4hoOKC8dm2wlqx8z1bwk/TWM1RrZIfmTCXhD540cBTRYzzXGHxlShfZ6rtqIAKf8CQJn9MEfOY+0i+7gVZux1T3lBjyfqIXjNlbNyAOIIlYy7A39PkufQA9vClEelTiWEZhzlF7cQRQDvPMswzsIHyRLDloDP2m+AS2+7oEa7/3M8w0FdvqsD7tvhnkHRRlUH/jqEJKwwzqNhGqGeueKsTgStlbdXs7s13tT96S/w6xagnTnxKQrQrd9qyHw0JVvuG/zmtfYVtDocGkQNHfax+Ce4200T8AXpNkxVl4gQAmIkRgA0CfvI0iJk7Bi9QRUhGbZE8AMi3SwoYxETajoTww19dwCLF1pvwtcGyfAYs877Jbvt2rpsPKLbRCx3V3tT3OG39BnetE367CU8c89udkksDqoROpmZMZZBvi4UdyqEH0ycRhf8AAbasAQOp+4BdublCaT10ah+H77xlJJNCLKcWJePrJKoAXBudK
 3Lm5Qv8h
 fAf7DD1UZcNqd7R+RArMFTZK7HmkeJnttdzqsSImePiF1qa7M0K7ApJ5CD4c9ubPejNhmYyJZEdAX9rPwLNmVxJq2XOOAP4fPVUjPTyVrrq0rYvsSTmy9K/9RBpESahRxxnwUHHIsthB8NkUkIYdRYB1XEfdoZehPGv2DV5TbbNl+jnqmhxhRYDcFoaMRQKNWhRfan7XQDwH+Qh6szOwrNiwV8aFuUTMr+xkqjgVGBxEmh0Yu5Rgt8OCoDehB6iOT5abTdXkb65BvQQm+b/wwLRaWNj3gmGrCzJF76fGG2fTXjNILgfCYBUKLpLcsiCSHIjfI8w8uiKMBx4ABqFTdp2+1JY+0m6byOez1DqlkwwWGcABWRe/iKq0lh2sSDZFHL49V1unPIvORKP/OR3hCTlqKsZwlNypDj3axcVjtN+sKSzOXqazfQuFgTz/191lqu1S+/MCtgL6cVNiyj5THqSetOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 02.09.25 17:03, Kairui Song wrote:
> On Tue, Sep 2, 2025 at 10:14 PM David Hildenbrand <david@redhat.com> wrote:
>>
>> On 22.08.25 21:20, Kairui Song wrote:
>>> From: Kairui Song <kasong@tencent.com>
>>>
>>> swp_swap_info is the most commonly used helper for retrieving swap info.
>>> It has an internal check that may lead to a NULL return value, but
>>> almost none of its caller checks the return value, making the internal
>>> check pointless. In fact, most of these callers already ensured the
>>> entry is valid and never expect a NULL value.
>>>
>>> Tidy this up and shorten the name.
>>
>> Shorter != better. But yes, "swp_swap" was a mess.
>>
>>> If the caller can make sure the
>>> swap entry/type is valid and the device is pinned, use the new introduced
>>> swp_info/swp_type_info instead. They have more debug sanity checks and
>>> lower overhead as they are inlined.
>>>
>>> Callers that may expect a NULL value should use
>>> swp_get_info/swp_type_get_info instead.
>>
>> High-level comments:
>>
>> 1) I hate the "swp" vs. "swap". Is that a valuable distinction or could
>> we just convert it to "swap" as we touch it?
> 
> Totally agree. I was just blindly following the old style. It's kind
> of confusing indeed.

... and not a lot of space saved :)

> 
>>
>> You're converting swap_type_to_swap_info() to swp_type_to_swap_info(),
>> and I am not sure if that is the right direction :)
>>
>>
>> 2) Can we just call it "swap_entry" when we work on a swap entry and
>> "swap_type" when we work on a swap type in the function name?
>>
>> swp_info() is a rather bad function name.
>>
>>
>> 3) I am not sure about "to" -> "get". "to" is much more readable in that
>> context and consistent.
>>
>>
>> 4) swp_info[] vs. swap_info() gah.
>>
>>
>> I would just have done:
>>
>> swap_type_to_info(int type)
>> __swap_type_to_info(int type)
>> swap_entry_to_info(swp_entry_t entry)
>> __swap_entry_to_info(swp_entry_t entry)
>>
>> __ are the expert functions where we don't expect NULL.
>>
> 
> Thanks a lot for the suggestions! I also like the idea of using "__"
> to seperate the non-NULL version a lot and implis the caller have to
> careful.

Right, it's the "pro" version :)

> 
> My concern was that names will be getting very long in later commits
> following this convention. Which is also the reason I want to shorten
> them here.
> 
> A lot of SWAP relate operations will be cluster based, so it will be
> very common to get offset or the swap cluster from a swap entry.
> We will end up having a really long name like
> __swap_entry_to_cluster_offset (convert swap entry to offset inside a
> cluster).

That's a perfectly fine length though :)

> 
> Since we already have the swap entry type called `swp_entry_t` and
> helprs like `swp_offset` and 'swp_swap_info' that convert an entry to
> other swap things, so I thought that anything converts swap entry /
> offset to others are named `swp_*`.

Yeah, I think that's just bad historical baggage we should clean up at 
some point.

> 
> Maybe a bad practise here, we can fix it while at it, or at least no
> longer introduce more confusing names.
> 
> I can follow this suggested style, will it be a good idea if we have
> following set of helpers?
> 
> For swap cluster and swap device (swap_info_struct):
> swap_type_to_info(int)
> __swap_type_to_info(int)
> swap_entry_to_info(swp_entry_t)
> __swap_entry_to_info(swp_entry_t)
> __swap_offset_to_cluster(struct swap_info_struct *, pgoff_t)
> __swap_entry_to_cluster(swp_entry_t)

Looks great to me, but let's hear other opinions.

> 
> And for offsets, we still use:
> swp_offset() (Existing helper)

Yeah, there's also "swp_type" and "swp_offset_pfn". They really only 
extract basic properties of the entry, so they are a bit special.

I think we should call them "swap_entry_offset" "swap_entry_type" 
"swap_entry_pfn".

Now, that's not something I would expect in your series.

> swp_cluster_offset()

That one could later become swap_entry_cluster_offset()

> 
> Now all swp_* helpers are pure arithmetic operations (we just renamed
> swp_swap_info which seems the only exception). Is this better?

I'm already happy once we name+document the new functions properly.

I could probably live with "swp_cluster_offset" for the time being :)

-- 
Cheers

David / dhildenb


