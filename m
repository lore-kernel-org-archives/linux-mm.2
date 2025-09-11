Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8FA1CAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 18:57:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B71A8E0005; Thu, 11 Sep 2025 14:57:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18E508E0001; Thu, 11 Sep 2025 14:57:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A4638E0005; Thu, 11 Sep 2025 14:57:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED3D98E0001
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 14:57:01 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 98DF9C05A2
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:57:01 +0000 (UTC)
X-FDA: 83877876642.03.E150271
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 357294000C
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 18:56:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ecgea4jt;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757617019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zN4wlABt8vNZKj2SSLrSF1Ejb/HY7Zk25eK/8tuni40=;
	b=iNFwiovRSeWd0wbrfynpZFErrrRtZBsxB5vp+blacn2T09XnAL7lON7/C1tWtzGM9gZNkT
	TmT/RZk2yj/lARWQiaAfUBpQActnQSpnUSu75tXqjpQIUfeBzBdMYpdkjAlbgeRJVdnWmX
	CtmWXrMm5TORooDrs1ADE8NKvim1ihk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=ecgea4jt;
	spf=pass (imf04.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757617019; a=rsa-sha256;
	cv=none;
	b=JWoE0uMREAiMbWJS4V5mep0CfTUc9QZJFU+wupmMvFQSDTN6hAvR2GejkY1ClpnYJg27Z+
	71NVSGWw+V6nJM+ELLnQnAvTCnwm4jspaMjNMG9eLPR7EIlskZKkd4UJrisCVxNVquegs5
	BoGI7HApujDUeiyCXgGzX8GEH+58b6w=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757617017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=zN4wlABt8vNZKj2SSLrSF1Ejb/HY7Zk25eK/8tuni40=;
	b=ecgea4jt81oQorQOm5tibOyL2r0PKZSrtPlpLMSBMaf3nhRKOLXDcFZCwWr1NrCwPDhOYZ
	vTPR8OVPHeeA9/nVvhT2xN0SEQHa95wtIUJ92OOTELpWNvWkuoaGslEnrdpHWSayWIQawO
	XckN/q22KBEil99DpTJ5PY2SwqPdv9E=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-623-98ohCoQuP1yGy9f36bkk9w-1; Thu, 11 Sep 2025 14:56:54 -0400
X-MC-Unique: 98ohCoQuP1yGy9f36bkk9w-1
X-Mimecast-MFC-AGG-ID: 98ohCoQuP1yGy9f36bkk9w_1757617013
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45dd9a66cfbso9082525e9.1
        for <linux-mm@kvack.org>; Thu, 11 Sep 2025 11:56:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757617013; x=1758221813;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zN4wlABt8vNZKj2SSLrSF1Ejb/HY7Zk25eK/8tuni40=;
        b=ZdpBe0zs3Jkq7X4jNZf/gMqGaQCoRMSYRLJCurygw/HQulyQcyBIXpsDosm/iThOfO
         VXw+G0KUJVGrU8dj9fCRCt4b0zQEU+ZKyyjoefVlb+dplah8psdkw8H7dMAK3c7tXEJu
         m37I4aC0N4T75nwMOL50qluBHjttiAEp72QYMMhNjRkZY1KCvQWo3sQJEPl4KzVCue6x
         YwLP6LifO3n0Wy0lK9VplFDMhA/MdOzj04fyY4ete76IOaUNpnLH+yb6U79XtGI4GPv1
         U9wzZlCBEdkjcJA6gJ4B3xLtWuoh2WIdcNG/a5eNedenyKxRfrjE63nfoQNULnNoCquz
         6sDQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKqmiGlQj1aniQTCNo38W0R037yjcypJ8tuLhSbjE8nDUbNo56xjyAg5GWxtJbrfOxZkekeEBSQQ==@kvack.org
X-Gm-Message-State: AOJu0YwD3PvgXIFQwFrMFi0oNBWaBD7wc20SKJCiov+Cj3q1IK3k9Tny
	02YzZkwDDlhy6+Ycw1aFoF2FY7ei48uSUFGs/F68Mkx2XnAfaDHEBhBGkYiQOVayFb+pY5S/sEF
	V/sgTeK60e+SwyLxFctaNwe+NVFUUkP2IW30fC5f+anrVOLMyUStv
X-Gm-Gg: ASbGncucjbxR67Abjjm9fA3gsMKGtPaUkLGXPX7dzffLSKlFAysEoqgNFrEsWfnzXtE
	qOHeaJlez/h2Xyf9hx3rNHarq6OqVUnWnp7T1cOSgOiDrsRrwzeZjtGA4oIcsjheAujGzQlROI2
	lnQjfmjaW5ocbxUmApv8K3V+0ikkVxBF5mBj6RHYuy39j/k4qHSMydT+ICUlwwXr0o3vrghrev7
	TRB2gOWW0+of4q0rpJgqsLuUUA4BgH5+3FS9aSlAePce6hDq+0BP6qzREy0EMrDKm0N0tsyio03
	caWsYWMeF4oze2UToP86uSYS6phb/j4pYyevCApAcrwcr/9fIh0eeCdBCwBPavjzNIrXT7XsBrP
	7bYgAwa0IOjX/SJgLxbRafs0+/8lrBIF46Sfkg8i4cylrX58K3kIEUVIk9FK95RpdmKk=
X-Received: by 2002:a05:600c:228c:b0:45d:f7dc:fa7 with SMTP id 5b1f17b1804b1-45f211ca957mr4717235e9.5.1757617013043;
        Thu, 11 Sep 2025 11:56:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG91DukpMrQgjHRq8+tJlCvjThkE0VpzxHzF2/wzsnPUt6tW85aVk6dIDRFxnLWBs5wEKH/Hg==
X-Received: by 2002:a05:600c:228c:b0:45d:f7dc:fa7 with SMTP id 5b1f17b1804b1-45f211ca957mr4717055e9.5.1757617012616;
        Thu, 11 Sep 2025 11:56:52 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f42:b000:db8b:7655:f60f:812b? (p200300d82f42b000db8b7655f60f812b.dip0.t-ipconnect.de. [2003:d8:2f42:b000:db8b:7655:f60f:812b])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd415sm3407053f8f.30.2025.09.11.11.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Sep 2025 11:56:52 -0700 (PDT)
Message-ID: <667133bd-0021-4d4e-9cde-fc8c1324522a@redhat.com>
Date: Thu, 11 Sep 2025 20:56:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm: hugetlb: allocate frozen pages in
 alloc_gigantic_folio()
To: Kefeng Wang <wangkefeng.wang@huawei.com>,
 20250910133958.301467-1-wangkefeng.wang@huawei.com,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
Cc: sidhartha.kumar@oracle.com, jane.chu@oracle.com,
 Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-5-wangkefeng.wang@huawei.com>
 <90e926c9-40cb-4791-8360-e3d145fe3503@redhat.com>
 <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <8508e8fb-77cc-43a7-8460-456f68a552ba@huawei.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: dixF5CdDJZ3BwxUD4YSJH1L_jTb8mjYoAD1TbDd_A5U_1757617013
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 357294000C
X-Stat-Signature: 3tb3abfybjwkiiwqaei9ahzyyehzbyfr
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757617019-207371
X-HE-Meta: U2FsdGVkX19n32iSkBkmp4ICRx+uW5SnV6bNbLJtKYlZH8nOVMWPF9s4Ldcm7vEFy53b/Wiy7HtftBLIvaSohn6zPORSZdmqssfJBgkAMejv4vVCD2nwiqKMB/BZI1WgajwDw4hoQFQxgGdX9C9R6bQdcbUL0JTNMv3bjpyM7IJlvpiY18m4CWCcj3QfdLvG5hR1AqDqZDgjXtjk7IbjihA7W+IyI2lIdw7+CIQSZrzUwSfUfX2vMjuzYO6odJd9OeAFrk+WDXsgcKNMX+XdlhcKQ4i/C5GiWNJiIoo6gfeP/PBkp8nqdArh2QhhgXHm0RCfrHlqsLAHD3l4xmPfiDCa3zeCGAGkn4fDIfhRrTt2jmMUwpgg8OifqzcwAcCFHtdRj10RK0791oV/GpCkpKl+KiQhFnBwKD+rtk0rcxFd1w6QSMMYFIMcesUrizVEiyObw96U7tF4Ql/DXbcVc3NhS4iTSNOEz9uiiVLVeEn0jlzbRwdNiQJ4DRqlWHOFRE9iV/oS2ZP3fgW5hfxjcOOVNWhzzx2zv8uMQ9QHD66LCYRSBRhnfW8tDVxXhdcoZQ/4nJBELV68bjY46gS/SY9//xdBwejJlqvhItXtFTUDauFy9Wv3KkUaxdFpZHx/wLPHpfCOjlhJpqCsQCL3m0RzJri0+mlt0YsDgMG2U44O6U1o5pdsc7n+Fk/4XPS4bkVAki6h2/Cf3Vityo2V7Oe1R5zBvR4XOF1TMRXeANbE43KnuHxk56CcB7Nvld/PtJx56kDGfuodIH33FIW6dhvyE6ikgur+C2gdYcMC12PrvKi82khTXVb22mBLgjEuLOe8059HWg18NMYxNek+iISvg9lgMkQCSQYESdZv+14aHYiq+Y8dr51gjAsVguFtp/T4LfBP/ko4pm0dMCyVXcTXE9SiPc4kY8KIuHJVdcZ5X+U/wNgs2jAIziC34dDdgJUKTm11KGDK0MXkuCQ
 tAGxoYk0
 XomlJ1qb43G/EHP6b+Pk1gWmjlque43IVswPxa/r4aCyvH62qVskEC+/vS6IkdrJzmeDMMWlOB3xzWI7ulxFQGxnH+C8hxl2q7M6b99vTKjr4t3KJ0++jMqP7baIo03K5zfv6vp1agrUXwt+hjyScL6n84UZNP2bjJd6HRUswdH6N3jqK9clzgiN0oyCc/FqShFc8up62h31ZFNmMBXj5uFZv00s8MqbTrip2zddP3dB8uWcQNCF+mpwKBSd/g7SG92+7cC0NoOBRhnH9+IWg2TFAm0+w1J2UW64nAoXsHjaMVYGPx+Xwo/8nGRCyqz12kXvzaKHk0/CN3m2Bc6OP693AGQ71vBBD8rFR8FP9Upi+XUB32OvT+t4PL+zgjZTY8qhKU1qyk4tq/GsbpPrU2lB5OVhuYq4ldEOtdaxiB70k8BzyuPiJwesHGQ5eSwt8gx1fXuD/CcakHPwERvkQkZYNN29/jmMhZ2Nxzp+DDGCKlFsrqtfclRwKOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11.09.25 11:11, Kefeng Wang wrote:
> 
> 
> On 2025/9/11 16:25, David Hildenbrand wrote:
>> On 11.09.25 08:56, Kefeng Wang wrote:
>>> The alloc_gigantic_folio() allocates a folio by alloc_contig_range()
>>> with refcount increated and then freeze it, convert to allocate a frozen
>>> folio directly to remove the atomic operation about folio refcount, also
>>> saving atomic operation during __update_and_free_hugetlb_folio too.
>>>
>>> Rename some functions to make them more self-explanatory,
>>>
>>>     folio_alloc_gigantic            -> folio_alloc_frozen_gigantic
>>>     cma_{alloc,free}_folio          -> cma_{alloc,free}_frozen_folio
>>>     hugetlb_cma_{alloc,free}_folio  -> hugetlb_cma_{alloc,free}
>>> _frozen_folio
>>
>> Can we just get rid of folio_alloc_frozen_gigantic?
>>
> 
> OK, we could kill it.
> 
>> Further, can we just get rid of cma_{alloc,free}_frozen_folio() as well
>> and just let hugetlb use alloc_contig_range_frozen() etc?
> 
> HugeTLB can allocate folio by alloc_contig_frozen_pages() directly, but
> it could allocate from hugetlb_cma, cma_alloc_folio() need change some
> cma metadata, so we need to keep it.

Hm. Assuming we just have cma_alloc_frozen() -- again, probably what 
cma_alloc() would look like in the future, hugetlb can just construct a 
folio out of that.

Maybe we just want a helper to create a folio out of a given page range?

And that page range is either obtained through cma_alloc_frozen() or 
alloc_contig_frozen_pages().

Just a thought, keeping in mind that these things should probably just 
work with frozen pages and let allcoating of a memdesc etc. be taken 
care of someone else.

I'd be happy if we can remove the GFP_COMPOUND parameter from alloc_contig*.

@Willy, what's your take?

-- 
Cheers

David / dhildenb


