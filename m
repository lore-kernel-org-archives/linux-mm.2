Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96A4CCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 07:52:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F07488E000F; Mon,  1 Sep 2025 03:52:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EDE248E0003; Mon,  1 Sep 2025 03:52:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCD3C8E000F; Mon,  1 Sep 2025 03:52:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C9E558E0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 03:52:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73F7A5AF00
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:52:26 +0000 (UTC)
X-FDA: 83839913892.17.7678574
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 165E22000B
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 07:52:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d2neTr1z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HllG5yxgEuvgobHZe1WNgsnnNNSMr0+x2czShD/v46g=;
	b=4hPf89jb7MYap0/5dDulshfpasBiBXLQ1cwJ8Enyl1mY39LheZV8nkHIVMjj4lvuh0AlOu
	lsedX+AQWx3fVPNZNaRrBtdCkvpjS34dZmedY/MGQq1kOu1CiVriDv+CEj9U4QektG8eqz
	yRTFEU7Ns7A4tjFjTdJ2qTivVmIYlQ8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=d2neTr1z;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf03.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713144; a=rsa-sha256;
	cv=none;
	b=CKRTyWmk/PEIJulN5FgMXAI+76vvpBWbIrtyzzZXymTEa/6Hs1xd0aqqzyAhMmKuqiZfVU
	7T7fIGbb+USEtAYy4nsp/5lKqk9OHATB/UM2d0A6DjvG4jK71fDGK0V/VY8ZSVJ/zLenlL
	7PYPsL88tc/GWEpppjAMmV8EB/lGsuA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756713143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=HllG5yxgEuvgobHZe1WNgsnnNNSMr0+x2czShD/v46g=;
	b=d2neTr1z+lW0Qw0mpjusjwmEJ9Xzkm0mPaGe+TaAhCkVtSnvohJ9Thi+rtbXYT0XRCV8Ej
	NcL5R2llg+4LOkVEkO4HB1nbSgvPIxhC9Ge217sf9kMtLCu0YYkPa/eaLUzlAOAPETtLtq
	XXm/3xXY61FkXRRwsWAJboi86022sck=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-588-usDMeNGjNqieiy-t66hD-Q-1; Mon, 01 Sep 2025 03:52:22 -0400
X-MC-Unique: usDMeNGjNqieiy-t66hD-Q-1
X-Mimecast-MFC-AGG-ID: usDMeNGjNqieiy-t66hD-Q_1756713141
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ce059e3d42so2358703f8f.2
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 00:52:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713141; x=1757317941;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HllG5yxgEuvgobHZe1WNgsnnNNSMr0+x2czShD/v46g=;
        b=Qnd4hnqRvvJiRZhLwJwnzE50JbJAyiYB0MJkQvvccju3Of+cYQ9vTKOYPnOR1nIrXg
         kXgNNYC4aeFGYvqa4wsfZ00Hx7rYy7HqRqJxzuW6sd3EAq8Ne7jp1cQdWYhlp6ZF2ZNm
         H8gqNFhVfLTQ4dCieooFezYboEVL2j5gg0uC6W/jIe3bR6mOL8zyE1gWfcBRzy8ezkQ5
         GR9vaLE4n87/+jVj0KMf3UKHhNr1hH1b2xy/zQwN1GB0b18qAII+wKIfo5NvwW93orol
         CUm7vA95BvNS+Z4+jNQPBHNQYgPmnZZlVGxvzWB00WZS/177CPy8be2RmD9uYkSlOAht
         bvHA==
X-Forwarded-Encrypted: i=1; AJvYcCXmpGCGWWSDL33TXdgIl7ZZrFSuG9wEWGsFHZmcPVcZ1PdYSQesRoh31cgb+aXp8wKf1tYN1uYAYg==@kvack.org
X-Gm-Message-State: AOJu0YwXyF37uE58qKcNbT/6ZL42f+Iawu8VVGB0+KOOVZ/e/RaU6eoC
	xfCCSZZTDvkYhIPlLmZmyn7P+GYbb3Rk1xB0RXxc/7sNZnCNZsZptlCI+VhN6+0uVIQZZAtDdsp
	IIRhBk2S1c3wCz/ZlAf0pYQvwISRusgvADUvTY9IZ2H+BUT7tQQXo
X-Gm-Gg: ASbGncuKg8Xh0MiJ3rbnyfOeSlcDljGetx8r0599z0aKxiPZq/k1QJdKvctY5n8kTRj
	R8x3awc+XmH+yRz4GhrGYXURHwME/1/1OYbXm1/sYWhhVN7Y3jVHWxb8M9EyH5kd0d/m5mACN4Z
	wpgQAhDJptqUS/hQgrZ4uwaDxjQYt35pU0sD0XckVD4zdcCcYkrEJUW7zJUowh9gOkY8cWN4cyj
	lsuN0vn/EB01fLJiHFOMsica87b8qErsKM4yvR1XDSQeJSlCDSnCPisMY3yGjN5PWav2gjHyZqX
	ZrT99sv6Dc8yG4KTX+sVd8jcBTdaV1cTtyRZPWxOnp9fF9oxcdFO+dg2VWyMNsljjocFmcNnU+l
	q7HQIBf5XH+5PDUEKFtNPBVHjgR/7EUbCs2TnY0qJ4RIY1/22wQcU9WP51yAhiePepE0=
X-Received: by 2002:a05:6000:22c8:b0:3d4:d572:b8ea with SMTP id ffacd0b85a97d-3d4d582029dmr3197731f8f.34.1756713140936;
        Mon, 01 Sep 2025 00:52:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEkxrzk0lP+lzTzium88rZISj1JP6wQQDJHhaGn2DR4npJJgvliAA7HY6y8ULZXDuQ1rwzhPw==
X-Received: by 2002:a05:6000:22c8:b0:3d4:d572:b8ea with SMTP id ffacd0b85a97d-3d4d582029dmr3197620f8f.34.1756713139105;
        Mon, 01 Sep 2025 00:52:19 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d0a1f807f9sm13185017f8f.38.2025.09.01.00.52.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 00:52:18 -0700 (PDT)
Message-ID: <92def216-ca9c-402d-8643-226592ca1a85@redhat.com>
Date: Mon, 1 Sep 2025 09:52:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] mm: fix folio_expected_ref_count() when PG_private_2
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <52da6c6a-e568-38bd-775b-eff74f87215b@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: FnrDPLYEag1fLSjmWlfwgAYCFxg3P0UZjfDO4EyOkOo_1756713141
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 165E22000B
X-Stat-Signature: 6n9rusictwts5pdfijbr7r6mjj7qi3wq
X-Rspam-User: 
X-HE-Tag: 1756713143-779828
X-HE-Meta: U2FsdGVkX1+Hme0OR4umC5iVxgaveiI/4o8F4d0NTlHkrl2zPFMt5rzvYvggIS0PhFXWEQcp05LaRzVkUQU3x+ZWo+c33xvUc/dzvaLvLPbldeFOEwiEdSy5rvNIJ54BB3BEYyDGVSbqYRD/hXIuXAk5zlPni92yJw2hbXPR1w/7kxfuLPDLEJ5iiru/wygUrJx7KI75ca6srBgzAs4zslteawXSM2+W4Wwa88M26z4Yp2E1/iO6w2VNq02RcLKrPrzC66WpGX7Dzcup0z8rjy8KMscZCN4WjzzJHjR8cG/wsvJOHxQ2O7izAaNGjJQIAe0DHHVFa0WoEhGeIMIBTUn8iLsdfTuyPKw2p0VBvmUuqfvJ5bWOzra6KtYK7uRSgHiLXpYWi7ePuaUnrAwBTVJshDo7zr7DEurdnG4/ZhMP2bf738B5q0K+S7UtNUCPklDWqcdrGCuxrgnW3PwtjYUm6fxWXLgiPDaTRb+fStgsTV8Cut66Gszoh/N7YnYLjYVkc8+zhIudMuonCJUpsJ9kMW2YAhABk/omf+kiD+ZR+66NBdOeFXsYFf0Bxuyw4flWclJovcHsM9+WV02yCpMTWX1gZkEF44mcCD1HJ7usK3C7iJspql5etDof5OMjeXhE6Kn8bkSN7YcKqSCXndkC4CPnb/BuFzm9bhADpPP7pVgx17L0qGcZUCzZD+0JQnSEb33E/rbsfAdMwzAq7f7HOqsO/c7QGxU5Lmc7sNJOcERQ6is6zuKeduO1r9fzr2QgGGAjhHCBNyIv/Mu3BKqj5p0MqJ9z//NjfFZTwn3rnnPVTuNBYUu8JwEyBvn5IROBZlgCjbFDHZwmJPqltodewhpLj/0N91i2L5lZsSGjcPE6RCnjNx86ohcVoVWJ6kHgnPP+KUwE8nkvOnSSii5JFPrtUuTtJDkoozvD3Hq2Wc6fFOf82xoLcsWVNz9Y/LyZjqdxkuQZNCniz6w
 ANlOlEId
 c/ZUaI5kf5olwiRFJRARfLAI/SS9pU6OU+UaaIsNZYdYu2a9Jkoo7P6LAOE9dQoveNUcIz2tMjviKeZY8zzYjfl+XBNgYaZn7iWZFNNlMfCfYfEY8NwffYcFETh34NAq/kPk1Nf3BFGhaC9Zqpk6npyw+gEitHw0n2gr+3XH6q5EKMTf9Bf7CUXs+3DDWW+0xrVPv5PEwWSS/Tqrdmde7rXQDjZbyKyS38365v/9svZ6ImgTJRCLtAfZlAjFtBM65VT8dBRTWjjaNYd8JgG5xL64ygBrGcQXlME2Gx5zf7NDFgZ/WzcHn/S7H2tsAz0gZwhcEpSp7G6BRGKMeuNBQed/6mQgFZKvMDGmfwJecgD3LgXQldCd0yH251EQOvxdirQ6lRlYbAPPUI0qwXsoag7R2cIHlXzJAS1jYqwq+Cg9FWtbz3TLZQPAosMCTKcBSPZKQ5YQd9E6cVpGUu/9o9hMLWlYbmV5TtsHy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 03:17, Hugh Dickins wrote:
> On Mon, 1 Sep 2025, Matthew Wilcox wrote:
>> On Sun, Aug 31, 2025 at 02:01:16AM -0700, Hugh Dickins wrote:
>>> 6.16's folio_expected_ref_count() is forgetting the PG_private_2 flag,
>>> which (like PG_private, but not in addition to PG_private) counts for
>>> 1 more reference: it needs to be using folio_has_private() in place of
>>> folio_test_private().
>>
>> No, it doesn't.  I know it used to, but no filesystem was actually doing
>> that.  So I changed mm to match how filesystems actually worked.
>> I'm not sure if there's still documentation lying around that gets
>> this wrong or if you're remembering how things used to be documented,
>> but it's never how any filesystem has ever worked.
>>
>> We're achingly close to getting rid of PG_private_2.  I think it's just
>> ceph and nfs that still use it.
> 
> I knew you were trying to get rid of it (hurrah! thank you), so when I
> tried porting my lru_add_drainage to 6.12 I was careful to check whether
> folio_expected_ref_count() would need to add it to the accounting there:
> apparently yes; but then I was surprised to find that it's still present
> in 6.17-rc, I'd assumed it gone long ago.
> 
> I didn't try to read the filesystems (which could easily have been
> inconsistent about it) to understand: what convinced me amidst all
> the confusion was this comment and code in mm/filemap.c:
> 
> /**
>   * folio_end_private_2 - Clear PG_private_2 and wake any waiters.
>   * @folio: The folio.
>   *
>   * Clear the PG_private_2 bit on a folio and wake up any sleepers waiting for
>   * it.  The folio reference held for PG_private_2 being set is released.
>   *
>   * This is, for example, used when a netfs folio is being written to a local
>   * disk cache, thereby allowing writes to the cache for the same folio to be
>   * serialised.
>   */
> void folio_end_private_2(struct folio *folio)
> {
> 	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
> 	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
> 	folio_wake_bit(folio, PG_private_2);
> 	folio_put(folio);
> }
> EXPORT_SYMBOL(folio_end_private_2);
> 
> That seems to be clear that PG_private_2 is matched by a folio reference,
> but perhaps you can explain it away - worth changing the comment if so.
> 
> I was also anxious to work out whether PG_private with PG_private_2
> would mean +1 or +2: I don't think I found any decisive statement,
> but traditional use of page_has_private() implied +1; and I expect
> there's no filesystem which actually could have both on the same folio.

I think it's "+1", like we used to have.

I was seriously confused when discovering (iow, concerned about false 
positives):

	PG_fscache = PG_private_2,

But in the end PG_fscache is only used in comments and e.g., 
__fscache_clear_page_bits() calls folio_end_private_2(). So both are 
really just aliases.

[Either PG_fscache should be dropped and referred to as PG_private_2, or 
PG_private_2 should be dropped and PG_fscache used instead. It's even 
inconsistently used in that fscache. file.

Or both should be dropped, of course, once we can actually get rid of it 
...]

So PG_private_2 should not be used for any other purpose.

folio_start_private_2() / folio_end_private_2() indeed pair the flag 
with a reference. There are no other callers that would set/clear the 
flag without involving a reference.

The usage of private_2 is declared deprecated all over the place. So the 
question is if we really still care.

The ceph usage is guarded by CONFIG_CEPH_FSCACHE, the NFS one by 
NFS_FSCACHE, nothing really seems to prevent it from getting configured 
in easily.

Now, one problem would be if migration / splitting / ... code where we 
use folio_expected_ref_count() cannot deal with that additional 
reference properly, in which case this patch would indeed cause harm.

If all folio_expected_ref_count() callers can deal with updating that 
reference, all good.

nfs_migrate_folio(), for example, has folio_test_private_2() handling in 
there (just wait until it is gone). ceph handles it during 
ceph_writepages_start(), but uses ordinary filemap_migrate_folio.

Long story short: this patch is problematic if one 
folio_expected_ref_count() users is not aware of how to handle that 
additional reference.

-- 
Cheers

David / dhildenb


