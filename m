Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA572CA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B128E0010; Mon,  1 Sep 2025 04:04:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33A8E8E0002; Mon,  1 Sep 2025 04:04:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DC6A8E0010; Mon,  1 Sep 2025 04:04:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F33D78E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:04:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9C8D11A157
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:04:47 +0000 (UTC)
X-FDA: 83839945014.09.D4D8388
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id 58BC080008
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:04:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eg4wN66H;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LKbHko7dkYLZpt3fqHnEeSREWycVvJ+8hz3NIy768aE=;
	b=2b2sP9LPDF7gJg6q79oCKqhb2FLdSeko2Koea4NqlciOC8zT4YqmpiznI9FINZ5ugR8Zo5
	rYs+k6Jl4Uhu6G/UnuNaY7dFmomm7iQrOnIX8FXKsHQaEWujtl/16hDhFifxpbcjEPCTUT
	eWok/GPXN9mbE/ymywTkapowsHhAQ/M=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eg4wN66H;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713885; a=rsa-sha256;
	cv=none;
	b=LhnFzuwr1w0OlfETHslrPMIePNRUPYS7az8g0IUPxx8DbmbMEK2UD2UiOCwK7FWQ3cSkzE
	VhPDmX3MGmyrt2wkRvp+OOLDy0psdb7tz20stbZQjWc2/1gbxaoPQvXjLC0QoE2Ys0Ij3G
	LTIkXo4Mwn5GEBKRz9mpPN7T7ZWpIgQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756713884;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=LKbHko7dkYLZpt3fqHnEeSREWycVvJ+8hz3NIy768aE=;
	b=eg4wN66H7SMzjlFQHZveiNRvWzyXzsgd+/28g8qcYRr2vqOCsK0qo1cn1bK5K7exYRkmyz
	6yfOw3sunUxSlUmIBRXkszIvcFZapRkmJ+2d14XJEPfZfY+h9dKUb3puztUE550FofdAem
	ZJ7Jgi/TkfUIJvYpNyukWNbuSg4ftb8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-H53mCuLMOcGkTm0JeTYUjQ-1; Mon, 01 Sep 2025 04:04:42 -0400
X-MC-Unique: H53mCuLMOcGkTm0JeTYUjQ-1
X-Mimecast-MFC-AGG-ID: H53mCuLMOcGkTm0JeTYUjQ_1756713881
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b8dde54c1so2650675e9.1
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:04:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713881; x=1757318681;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LKbHko7dkYLZpt3fqHnEeSREWycVvJ+8hz3NIy768aE=;
        b=SndZWmhji0w9BMeu947BblzyMK1Uc+CLD5JRelT7vPPX0A0/dyEMc7hQwY37nx5Gkt
         UHUQsT51ENg8xXJYuLwkm6OPwYmawza/GVBOMI4Rp5lnez9eaL4dA4KNvZqrvQMF/JE2
         TR+DkkW3H6iwIGo6YR2q/MQaQODEOvuUcvB/tUo77iK5Un0e3drihw1WjFg0/QuCnmFH
         deulskEnzewjGJXpLiWuefB9ZYKc59bFy0VoyBLWOaF8fQsRJE/hD7UieRQTeFotsypp
         YtHqWzD6ThIRI6N6+v3XlQYrcqQjVaDGSpeKmL4lPJlz5sXhvrQjhr+YCYMPL+qWOqsp
         6k2w==
X-Forwarded-Encrypted: i=1; AJvYcCWQ9TyHYQ4lLvihNTWY40S4wUJJRb4eOrFL4nq6VaXeR60GAmZZDGwhvoz+VhhZzWs57pkmgSYOwg==@kvack.org
X-Gm-Message-State: AOJu0Yw68GpKRDVbisDWpxiWKi+cDLxSpRD2m/OtAtlq3X0MldDfdMY5
	CrlJrcuE4L1snAcmk8V6s8TrWzPoU/JWcfrKS18yuDosl5wkwaBCDnn5k5sBwxIN+9MrIYJP1JL
	VWNKMMUxssiJ+q7xfsm6I/hkHWNi31r4Wc9ffEGKXdgH4cnO0RvG9
X-Gm-Gg: ASbGncuiKkkeyMinhIB/xxEtCEqI8fQ+OMHtJsR07OwG9VcyP/FgO0d2jZXGZdk1mE9
	/32f+GEJtISd0Q7RCtob4u6ou0yKUV7wSZRNGEPp/ir4nD2bgpbay3esiVT+rxgsU9XaJZACrqT
	ds34u3lYYNBZ7G9T4SUMUmmEImIWtBeuWHhPVKjjhp38NvoTJI6dV3ijzKyxqk+1DX7ThrzYNZl
	K3HMwrLN7J5TfjgDj7h0IjHklNF2aFaYXj/Zvmc3V87vp/wWzUSUyWFDsiSTGkgTw1o+Hqzj5V4
	uTJKYoMUkQjN+sb41fIpGUDPQERLk+lSAcXDY4VQdgOXkK25PesHSfWLHvyyu0vlPjCtzCor4RJ
	6qE84eLyJCVwq8ugf9olrAzk2Bij5ycLUo2YKC1qpFUb+IlAvApPNeR/Wk59kDSJucTQ=
X-Received: by 2002:a05:600c:5487:b0:45b:8d2a:ccfe with SMTP id 5b1f17b1804b1-45b8d2acf6dmr16136815e9.13.1756713881029;
        Mon, 01 Sep 2025 01:04:41 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoENLh5S7BOGTqAZNCFkAcOhEK6ENrXTKLMJFKV+IIJ/9xxjJOD54Hf2giRasmZR3ZIqHkCw==
X-Received: by 2002:a05:600c:5487:b0:45b:8d2a:ccfe with SMTP id 5b1f17b1804b1-45b8d2acf6dmr16136395e9.13.1756713880534;
        Mon, 01 Sep 2025 01:04:40 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b73cf86f4sm203834345e9.6.2025.09.01.01.04.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:04:40 -0700 (PDT)
Message-ID: <2e069441-0bc6-4799-9176-c7a76c51158f@redhat.com>
Date: Mon, 1 Sep 2025 10:04:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when PG_private_2
From: David Hildenbrand <david@redhat.com>
To: Hugh Dickins <hughd@google.com>, Matthew Wilcox <willy@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will@kernel.org>,
 Shivank Garg <shivankg@amd.com>, Christoph Hellwig <hch@infradead.org>,
 Keir Fraser <keirf@google.com>, Jason Gunthorpe <jgg@ziepe.ca>,
 John Hubbard <jhubbard@nvidia.com>, Frederick Mayle <fmayle@google.com>,
 Peter Xu <peterx@redhat.com>, "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Vlastimil Babka <vbabka@suse.cz>,
 Alexander Krabler <Alexander.Krabler@kuka.com>, Ge Yang
 <yangge1116@126.com>, Li Zhe <lizhe.67@bytedance.com>,
 Chris Li <chrisl@kernel.org>, Yu Zhao <yuzhao@google.com>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Konstantin Khlebnikov <koct9i@gmail.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <a28b44f7-cdb4-8b81-4982-758ae774fbf7@google.com>
 <f91ee36e-a8cb-e3a4-c23b-524ff3848da7@google.com>
 <aLTcsPd4SUAAy5Xb@casper.infradead.org>
 <52da6c6a-e568-38bd-775b-eff74f87215b@google.com>
 <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rtdvSvzgPppfiD-hbTIc7jrsoP5d9dlaKRc3Cv3Jesc_1756713881
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: keazxo4onku9j997gq7cb6k8rridtey1
X-Rspam-User: 
X-Rspamd-Queue-Id: 58BC080008
X-Rspamd-Server: rspam01
X-HE-Tag: 1756713885-830029
X-HE-Meta: U2FsdGVkX18lCWjfA8Wjyji6kXwigL6DxKi2xyWvMZ+ivZnE6ID/AUM4PwtbJaRQehY2Uwc+tG0o2mhTdq3bdhuKGcshJTsKvavOkJnPELo23vLAGwinA5UC28WVtQwYaGXHAKKxh32I92zLqGEPl/Oll/vSvTvOyAk3UfW95SE2RsoYQGil2dD8BPbfAjvgWZbxTLlCxePaBFugtuCFZrQvNTcVMbnAaVRtM4zZSc0seSs4vaB8f7GXZc3Ctq4Gcua7SFyi/uYWU5EDFFz/IjvJC7u1zba04b6vZPshepQn88Jv1n4IMuhuwLqC7n2WREKeJwlEjVzAKi7dWgUHf5/I/RNxbQt+3hjrvN977ercgoN9bvjM58y9N5flrItiW8BILIItwajOrWYqTXDfk6QkB1PH4cmT95pKevcKZDrMUmb/O90amErBBftrd4rREE2BOkAOBuY1m8VEdPAm5iNVHFkvmWauAn/KHIXm8C7Z6FsraYurIBsDnhsNfOLooo6Oila645pDoYSVUcqAvYElFoEDHlydP8ZsHGY9uar+za5yqh0LSFZg8vgI1BrRLYKT4rr7jFeLpajEMmhS9TDf3qA7sAttbk44UmI6tSPr6QlLCCnKO4Q45h7XOnlwEZCaM0DKbe3FrjAA34lbr6t6tpzTgZob3NEDHZ8yNO5S6YPcm0yiUTNKn86BKbVqyAba1UnDCCtaE2R3ImCo/5xMbf2IaHcBvo57vOR7TxUAn8az1Ra7exHwFr/zxKBQOmg7sBvyC6WefaV5T6gvD9XS0TwmX0Yxpw/3hD0sk0Oit0hE7uWH6gleYCLjuy8PQeGFSDVXWlb2CRPQxwDeR/fxEfNf/dYet2O3a9T1QdDe1unKZSn0Kc5EdZTieMRh4qbL9YzzrsESFmHOdRGlXhfrwFwxTwsznf0tMWspX0gz5P83GCWUN1jCGoYgxpRnVMY04DKkjTtbOlW8WDx
 m1IiYCN3
 Nl34zGMaB3a5FoGgpI5QhcdahTQj7dHt5Ye57Mk13NzJvwwE86ynsb2XPWhZ307bw5IYbkZt0xgcEw/fQQiwz4CWp1+logyXooKm5frLWVn9ffojFyEQQXUl4NbA6Z8hYfsKJJFb7iYzQghxg0QcunwMxvK+RYzFi68F9i4Tp7rT/k/CI5gL5j1cLMAGheD26jZyaCiH+2s79M2MrJc2xpdi3oyK+4v+fP62r858of0+1b/fORygKJsJgLZhdkKmUw2abmilzzB/fcpWngd6qA9ZoUx+/elmLCUHMiC059aRoaHPy7bdjLipDFgug1oa8lGhXyN3T8Ts7zT2R6CJNYLqzI8y3fkzL//l+jB3k2QqaMkOb2fWycdr7gBdlP0RhU8Lgmv11BfAvlufjROItCive+S2DRqMPnchzdq5syAEbsH1GnK69EVpYL2JzP0gs4aMENsmEytmYPFVu6kkuzfrnylttRmDtQ4FNJNQMkDsiTw6VELeBtm+2ReaKYns/mkpsgCS49qZSJtlVkkMpdAinz2qftgyzJLcJ79w7pN6lSa8j2RFU9SI1GQ7qSu39UGnpvKZrpGyV7rvm9pFjo7BYODUGdRwgUKk6z+ZuLYiduRLlqRI6KXAvgQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 09:52, David Hildenbrand wrote:
> On 01.09.25 03:17, Hugh Dickins wrote:
>> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
>>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
>>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
>>>> which (like PG_private, but not in addition to PG_private) counts for
>>>> 1 more reference: it needs to be using folio_has_private() in place of
>>>> folio_test_private().
>>>
>>> No, it doesn't.  I know it used to, but no filesystem was actually doing
>>> that.  So I changed mm to match how filesystems actually worked.
>>> I'm not sure if there's still documentation lying around that gets
>>> this wrong or if you're remembering how things used to be documented,
>>> but it's never how any filesystem has ever worked.
>>>
>>> We're achingly close to getting rid of PG_private_2.  I think it's just
>>> ceph and nfs that still use it.
>>
>> I knew you were trying to get rid of it (hurrah! thank you), so when I
>> tried porting my lru_add_drainage to 6.12 I was careful to check whether
>> folio_expected_ref_count() would need to add it to the accounting there:
>> apparently yes; but then I was surprised to find that it's still present
>> in 6.17-rc, I'd assumed it gone long ago.
>>
>> I didn't try to read the filesystems (which could easily have been
>> inconsistent about it) to understand: what convinced me amidst all
>> the confusion was this comment and code in mm/filemap.c:
>>
>> /**
>>    * folio_end_private_2 - Clear PG_private_2 and wake any waiters.
>>    * @folio: The folio.
>>    *
>>    * Clear the PG_private_2 bit on a folio and wake up any sleepers waiting for
>>    * it.  The folio reference held for PG_private_2 being set is released.
>>    *
>>    * This is, for example, used when a netfs folio is being written to a local
>>    * disk cache, thereby allowing writes to the cache for the same folio to be
>>    * serialised.
>>    */
>> void folio_end_private_2(struct folio *folio)
>> {
>> 	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
>> 	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
>> 	folio_wake_bit(folio, PG_private_2);
>> 	folio_put(folio);
>> }
>> EXPORT_SYMBOL(folio_end_private_2);
>>
>> That seems to be clear that PG_private_2 is matched by a folio reference,
>> but perhaps you can explain it away - worth changing the comment if so.
>>
>> I was also anxious to work out whether PG_private with PG_private_2
>> would mean +1 or +2: I don't think I found any decisive statement,
>> but traditional use of page_has_private() implied +1; and I expect
>> there's no filesystem which actually could have both on the same folio.
> 
> I think it's "+1", like we used to have.
> 
> I was seriously confused when discovering (iow, concerned about false
> positives):
> 
> 	PG_fscache = PG_private_2,
> 
> But in the end PG_fscache is only used in comments and e.g.,
> __fscache_clear_page_bits() calls folio_end_private_2(). So both are
> really just aliases.
> 
> [Either PG_fscache should be dropped and referred to as PG_private_2, or
> PG_private_2 should be dropped and PG_fscache used instead. It's even
> inconsistently used in that fscache. file.
> 
> Or both should be dropped, of course, once we can actually get rid of it
> ...]
> 
> So PG_private_2 should not be used for any other purpose.
> 
> folio_start_private_2() / folio_end_private_2() indeed pair the flag
> with a reference. There are no other callers that would set/clear the
> flag without involving a reference.
> 
> The usage of private_2 is declared deprecated all over the place. So the
> question is if we really still care.
> 
> The ceph usage is guarded by CONFIG_CEPH_FSCACHE, the NFS one by
> NFS_FSCACHE, nothing really seems to prevent it from getting configured
> in easily.
> 
> Now, one problem would be if migration / splitting / ... code where we
> use folio_expected_ref_count() cannot deal with that additional
> reference properly, in which case this patch would indeed cause harm.
> 
> If all folio_expected_ref_count() callers can deal with updating that
> reference, all good.
> 
> nfs_migrate_folio(), for example, has folio_test_private_2() handling in
> there (just wait until it is gone). ceph handles it during
> ceph_writepages_start(), but uses ordinary filemap_migrate_folio.
> 
> Long story short: this patch is problematic if one
> folio_expected_ref_count() users is not aware of how to handle that
> additional reference.
> 

Case in point, I just stumbled over

commit 682a71a1b6b363bff71440f4eca6498f827a839d
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Fri Sep 2 20:46:46 2022 +0100

     migrate: convert __unmap_and_move() to use folios

and

commit 8faa8ef5dd11abe119ad0c8ccd39f2064ca7ed0e
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Mon Jun 6 09:34:36 2022 -0400

     mm/migrate: Convert fallback_migrate_page() to fallback_migrate_folio()
     
     Use a folio throughout.  migrate_page() will be converted to
     migrate_folio() later.


where we converted from page_has_private() to folio_test_private(). Maybe
that's all sane, but it raises the question if migration (and maybe splitting)
as a whole is no incompatible with PG_private_2

-- 
Cheers

David / dhildenb


