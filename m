Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 418BBCA0FFD
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 08:00:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FC98E0012; Mon,  1 Sep 2025 04:00:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E7398E0002; Mon,  1 Sep 2025 04:00:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D6308E0012; Mon,  1 Sep 2025 04:00:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9A38E0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 04:00:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3477985D89
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:00:36 +0000 (UTC)
X-FDA: 83839934472.09.8A5D524
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id C95DC140006
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 08:00:33 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aJMb0Unz;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756713633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMoScysp6W8agnmS99/Jo+BknK/QCKLcEVvBRO/BrfU=;
	b=JGksBd6882rSAANhccHnDfkAc4dBT0vAZmpgpwszUKe4FQeiBzkHF3ACwOK+JiVwKs9GDw
	sdsjH25MeccUcVttP2AE9fieb0B84C9by8IsXo+XS2/S6Ak4YHK5fplDvZG/QGLf5BAMVa
	FLqi3VqM1BrxlV6EDHzeaeIC67mhrU8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756713633; a=rsa-sha256;
	cv=none;
	b=g4YQCYa3cDs6jJvbgbSSe5pIdkM/qYJ2ymVeQqJBVEHKZzDf/B7NQ1dL/nSKkfK7kVv/+3
	yZQZ37lFUKVv1eO4/c6JFBxoq4c6O8RulNo6IuTKyTD6JGFt4oQF1I7ayGUXqPO93z5bF2
	FHw+y/Pi1dYufT4ThPuC0E7rJAprlxg=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=aJMb0Unz;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756713633;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nMoScysp6W8agnmS99/Jo+BknK/QCKLcEVvBRO/BrfU=;
	b=aJMb0UnzAQmGU4usoIwZ71HLrx0LBpLogHbM0UU5y9xTZvbEH0atsQVWfckzRr/Ka33ah1
	HA/Yi1ZZrDti8eKlJYplRpmx9xVDoh0jVReJ1LaCplKZQUHtCHx/GFeFEHzOMRz+Zu5ns4
	H18YLWf2PLkriPkI5PsW8JslD83PBkE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-686-ZKocNwtoPvKoYOFnJ1esog-1; Mon, 01 Sep 2025 04:00:32 -0400
X-MC-Unique: ZKocNwtoPvKoYOFnJ1esog-1
X-Mimecast-MFC-AGG-ID: ZKocNwtoPvKoYOFnJ1esog_1756713631
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45b87609663so7338255e9.3
        for <linux-mm@kvack.org>; Mon, 01 Sep 2025 01:00:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756713631; x=1757318431;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nMoScysp6W8agnmS99/Jo+BknK/QCKLcEVvBRO/BrfU=;
        b=YeTEFXHowdptIifCw8C1P4EmLUt3hnf9P77vngYT+NHDc4sV0X3uCMHpc/E+InPImw
         zLdjsXMGa5rzugn03G0PgZ1SHQ8aRciNjpPyq5Bz75CX6cPzy3EFHzQYTmg94jOGMq3+
         EJ60c/x40EopTWFlAlK/deuuwamVWQDBeJrs0c6FqL5ucpfahGumiClqQ4+SjkJGcE4Z
         CwesdpVdpyQcoHgmKb4b9cUsNsxeHsM0NSdaAK777NSLRNQKF0mx8Wzmqo3Sh6epN1FU
         pGhOjemalQF3S0IERo+otVosypMt6OZyWt8NNWGxWe2GuRxVLJDadWEnZo78yWiHfU5v
         4U3g==
X-Forwarded-Encrypted: i=1; AJvYcCW426iFM3d8EiwSLDnvBAzW+0ogiFIXZVokrz3SdAKJAjDp2gYiK0NtaEfLNbbsGVlCy2cmCuH+Ig==@kvack.org
X-Gm-Message-State: AOJu0Yw5oP5tnDVVpP5x2cIpMJJcyhmfoXhcxcFhyn6M8gRBhK9m1PZE
	UOGbHO1aruaOLdjRzTI+2T93DqdaXCcnQazJFd6g3oDAKTwH8TkejvnjBfY03tkRkWMCP7tyk6I
	pBwg6cysviq39YTkIhBbeB9gm2MoctBPUbXR1OoJHKvp91+1to0aS
X-Gm-Gg: ASbGncv+gO0d/jx1OnEc4UUrg5uEN4dCrIUsCtHXlpXjy1mAsQsMcMYLhqG6xbFziZc
	UHHs57dcfJHKHPC6XTT33j0wBVsQXVC0w+zPev+G/fhfLqq5SHP75rTaQkBaTO9BXgYfNzqNiyA
	DN5uriwtITZGxK5W3OQImLF49aQp4AtKd+kw3Z+MTrVKBYHSHHzyHB7uEr7Gr9RbWFm400Tox8r
	MopM0yl4efjD9ny2n2tMHb0vkDCOvlddrBSgaTSGKe6/y1fNVB/0OYBjUHIuhA7vfpZbvAJX2PW
	Udqw3i9lgRor41LvpRTVWsbOi5kJM9oM2GDS8IzyeqirPcihuTo92KHpzzDh4E8s+xYHTHJ/D6f
	RE6wbum6wkPOOBYClvV1NA34MDXauiLkicpM7xMGH6VsrVl0rQll7PECni/PywJHtwmU=
X-Received: by 2002:a05:600c:524d:b0:45b:8a10:e5a7 with SMTP id 5b1f17b1804b1-45b8a10e8c5mr38768635e9.37.1756713630614;
        Mon, 01 Sep 2025 01:00:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFLQBpKydXLPgNuaYH1v/Kwcnc9w+AqlJhCRAo3rSYLANWpzHzUcARkSJmgNUWV3Yjyip67yQ==
X-Received: by 2002:a05:600c:524d:b0:45b:8a10:e5a7 with SMTP id 5b1f17b1804b1-45b8a10e8c5mr38768115e9.37.1756713630019;
        Mon, 01 Sep 2025 01:00:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f37:2b00:948c:dd9f:29c8:73f4? (p200300d82f372b00948cdd9f29c873f4.dip0.t-ipconnect.de. [2003:d8:2f37:2b00:948c:dd9f:29c8:73f4])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf276d5e5fsm14200992f8f.27.2025.09.01.01.00.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Sep 2025 01:00:29 -0700 (PDT)
Message-ID: <e54b1d8c-ad63-4c7a-8b1b-b7c3d76446f2@redhat.com>
Date: Mon, 1 Sep 2025 10:00:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] mm/gup: check ref_count instead of lru before
 migration
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Will Deacon <will@kernel.org>, Shivank Garg <shivankg@amd.com>,
 Matthew Wilcox <willy@infradead.org>, Christoph Hellwig <hch@infradead.org>,
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
 <47c51c9a-140f-1ea1-b692-c4bae5d1fa58@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <47c51c9a-140f-1ea1-b692-c4bae5d1fa58@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 8oVcMHPEpEJsU_xPiT167MX6VJnyCMENKQnVoem3m_c_1756713631
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C95DC140006
X-Stat-Signature: jbaji4ab8i17y613upg5nx9wwmpwgcoj
X-HE-Tag: 1756713633-960587
X-HE-Meta: U2FsdGVkX1/o1iTKhOamcrV1jGNKIZSpadLLla9rModgvme5w8CE4poabHG/mydKHzlX1lKRrYoRTlSqexQqA0VvyJ7KIgebo9hS5WEhtpnpK7Gt97NPHJcDkDwLjPD6/cx5BZA1lThfdXKsVODrAjc5eWv3uASJJi/uf3XCNnP10+ns5QgQJ/5d/1VQzLmnJAXwjQbxyiiLnRGMYrCHipXIapHatriO1iZpJ2DC9uEvkwMPsSdEqOfyis1sJylG8s/LrX5LoNX/TtOZR/dMlm32qFQLx7kxuw1B6UwktNxKivFbU1cwzm6d66gh8yO/zSwZjTiES0FSN34e2KBGl11Mp1igg3Yi+78h+Nqo38kd51Ed4P94woqPZN5A2vnlecdJvKVwsBX4HRy+S0UkB5m1l2wwxEsslvuD1Pkry/E23dbRf/M+6TqW66mKeLWX90O28XFb0LfxzgHqTqRvd0WaLD5FPbpIfVFfc/He9n56loyfu1i1B3i60QQrEITWnUywzp0S7IOOkA9aC4M1AMO31AMdhuK+50Px3Od7L0F3vYY9fkmMCAJbg/tTS1oT5GylC7YQqKEar3qjTXPRhIABe/b3lmZiDpEb5rgAq7NVWuSGEvKrTkgfFgFUAovYVZDn8AlBJWcAJvQdKTQdBg4wNPqEiabrxPaUUiEmLqdR3O4eoHcXsx5eNbXIstvtbzJU4PUDXya9NTThWkcqhdRrOzH/MypUueIYSaJMo6sd5fNWtE68oi+sKrIG1M/kibruwyyW9I4+sxLrBfILBvMjjHbsdBdWIR0pTQzhUqGEOY+O6EnB1XOhiGvkVkhct2s4jFCAHDTSRt1mw8pgnXKOR96ySD2urPwDuEWZhWPXaB+0WxdsHWa9FrlG8WJD2Tbl/GSI4UIJffn0vHj13cDfjV4jn9w43yxtjg4PxBlhxQ11be2UKPwyhMtJgANeSg5V2pEwD37RmN6HBI9
 hZF4xgAi
 ceMkvKFZsIG9rDnsm1m0sXLrHzuzhUAqRS3x1Z0SWjiyj2VDLjraxziZk51J/xPQzX7HsrsXzNuKvTTlA24yDV8ed8XmxthZxMBm3D5iVu6SNPKahA3IPDHVBBtkE00ca1UPuhqSuswXNFCJ9reBk20zkxxSbYrBrutXj6iyxWw4uIyvk24pitzkl0yA1gJaKY/A5IBGXCln6SZav0S8d0dg3Jns3fVrHWAvUEa0bhYDE0XdfXjVJToI+IvS6p/qbEx70Hf9CLv+sUPmhrvZySDhqEwTKKytpCFSvGIqCbgm4GkFOBnEWsXN0Eb8xTqcQu286slSCJ+T+aZ+Qg7S0vEGZcFDF0kXr6A6Cm+ylrmi5JkbWSBqg5lkwxLT1Cwu0nGm07aVRJOMDYVL16PbjtxXX+NGC2HY4LKf46XHqD45vYK6iZzSYwnL+krJig8x2QMBwtORMwslDpowEcVCd0isJXI+K5V+Rkf65cB7eNb4cGJ5PkQrMMqJPVsm/DaHy4OgIXGffz0HtcDOBtLQTq6UAtiR3sC6j+xLxzhfLMdBxmJUHwKR+xsNfBuo8MZsgJjQT8OBVT4ec6SSyD1Lz4cWJUPVLFUcPA47ADpl69LaNT9fao55ukP4li/gnN7qR97NW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 31.08.25 11:05, Hugh Dickins wrote:
> Will Deacon reports:-
> 
> When taking a longterm GUP pin via pin_user_pages(),
> __gup_longterm_locked() tries to migrate target folios that should not
> be longterm pinned, for example because they reside in a CMA region or
> movable zone. This is done by first pinning all of the target folios
> anyway, collecting all of the longterm-unpinnable target folios into a
> list, dropping the pins that were just taken and finally handing the
> list off to migrate_pages() for the actual migration.
> 
> It is critically important that no unexpected references are held on the
> folios being migrated, otherwise the migration will fail and
> pin_user_pages() will return -ENOMEM to its caller. Unfortunately, it is
> relatively easy to observe migration failures when running pKVM (which
> uses pin_user_pages() on crosvm's virtual address space to resolve
> stage-2 page faults from the guest) on a 6.15-based Pixel 6 device and
> this results in the VM terminating prematurely.
> 
> In the failure case, 'crosvm' has called mlock(MLOCK_ONFAULT) on its
> mapping of guest memory prior to the pinning. Subsequently, when
> pin_user_pages() walks the page-table, the relevant 'pte' is not
> present and so the faulting logic allocates a new folio, mlocks it
> with mlock_folio() and maps it in the page-table.
> 
> Since commit 2fbb0c10d1e8 ("mm/munlock: mlock_page() munlock_page()
> batch by pagevec"), mlock/munlock operations on a folio (formerly page),
> are deferred. For example, mlock_folio() takes an additional reference
> on the target folio before placing it into a per-cpu 'folio_batch' for
> later processing by mlock_folio_batch(), which drops the refcount once
> the operation is complete. Processing of the batches is coupled with
> the LRU batch logic and can be forcefully drained with
> lru_add_drain_all() but as long as a folio remains unprocessed on the
> batch, its refcount will be elevated.
> 
> This deferred batching therefore interacts poorly with the pKVM pinning
> scenario as we can find ourselves in a situation where the migration
> code fails to migrate a folio due to the elevated refcount from the
> pending mlock operation.
> 
> Hugh Dickins adds:-
> 
> !folio_test_lru() has never been a very reliable way to tell if an
> lru_add_drain_all() is worth calling, to remove LRU cache references
> to make the folio migratable: the LRU flag may be set even while the
> folio is held with an extra reference in a per-CPU LRU cache.
> 
> 5.18 commit 2fbb0c10d1e8 may have made it more unreliable.  Then 6.11
> commit 33dfe9204f29 ("mm/gup: clear the LRU flag of a page before adding
> to LRU batch") tried to make it reliable, by moving LRU flag clearing;
> but missed the mlock/munlock batches, so still unreliable as reported.
> 
> And it turns out to be difficult to extend 33dfe9204f29's LRU flag
> clearing to the mlock/munlock batches: if they do benefit from batching,
> mlock/munlock cannot be so effective when easily suppressed while !LRU.
> 
> Instead, switch to an expected ref_count check, which was more reliable
> all along: some more false positives (unhelpful drains) than before, and
> never a guarantee that the folio will prove migratable, but better.
> 
> Note for stable backports: requires 6.16 commit 86ebd50224c0 ("mm:
> add folio_expected_ref_count() for reference count calculation") and
> 6.17 commit ("mm: fix folio_expected_ref_count() when PG_private_2").
> 
> Reported-by: Will Deacon <will@kernel.org>
> Link: https://lore.kernel.org/linux-mm/20250815101858.24352-1-will@kernel.org/
> Fixes: 9a4e9f3b2d73 ("mm: update get_user_pages_longterm to migrate pages allocated from CMA region")
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Cc: <stable@vger.kernel.org>
> ---
>   mm/gup.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index adffe663594d..82aec6443c0a 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2307,7 +2307,8 @@ static unsigned long collect_longterm_unpinnable_folios(
>   			continue;
>   		}
>   
> -		if (!folio_test_lru(folio) && drain_allow) {
> +		if (drain_allow && folio_ref_count(folio) !=
> +				   folio_expected_ref_count(folio) + 1) {
>   			lru_add_drain_all();
>   			drain_allow = false;
>   		}

In general, to the fix idea

	Acked-by: David Hildenbrand <david@redhat.com>

But as raised in reply to patch #1, we have to be a bit careful about 
including private_2 in folio_expected_ref_count() at this point.

If we cannot include it in folio_expected_ref_count(), it's all going to 
be a mess until PG_private_2 is removed for good.

So that part still needs to be figured out.

-- 
Cheers

David / dhildenb


