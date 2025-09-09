Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1C9CAC589
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 07:54:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA2828E000D; Tue,  9 Sep 2025 03:54:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C52768E0001; Tue,  9 Sep 2025 03:54:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF32D8E000D; Tue,  9 Sep 2025 03:54:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9A6DB8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 03:54:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 419D11A01C0
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:54:13 +0000 (UTC)
X-FDA: 83868948786.16.733E81F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1FE3E14000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 07:54:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LpPRoHvq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757404451; a=rsa-sha256;
	cv=none;
	b=vntpijJE1AZ4gPtnTNb+2QHF8DCA4ZhdfL/p43PhoJs8xax80H3rC5QNPn5Zo4FPREmZjy
	m3gw8WYz0A+KRSsSpNlHBp+4qul3d7d8LrN4x1njPbrdHqyaEUnziZHseIsmVAQuVUehlK
	H6uLgdLiGkdbxT2O+qM++OsK5UZHa68=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LpPRoHvq;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757404451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3DZC6SjHJqkdnRuK9QPLIzqW2N3dxyIyOzsJfjQjEcA=;
	b=nm7VaK4C14Pc+9/i6Elk0yBlCJT1xcRfCyjKi2CODlmV+1bvMosoyO8mNBu2paXwnC6Rw/
	wdqBFj4rkBB3un6vKACx5Srz3vedTq8f2FR1KL95TKP8/ijT3G6xHy1IJENt51L2xspF86
	NeGk8KmCDXfaboykMeRpPuRbbBvx/Tk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757404450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=3DZC6SjHJqkdnRuK9QPLIzqW2N3dxyIyOzsJfjQjEcA=;
	b=LpPRoHvqf4F6nL8YlJ3eA4eIM8o1e+CVgVJN0/DFBr5ODipLbnsqDzRnCpXqr1Bi2SoXpz
	rDQwXV7GAIhyrSO7xWtqUxrXFiCUIkNIPx8Qd/ch3xZz4Ql57cSg1sXc5/RvF8YWLtioEz
	vEm3q68Ksvxhgt2FkQrIEBNve9r56YI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-680-fa-oDekPMY29gtwjObSYkQ-1; Tue, 09 Sep 2025 03:54:09 -0400
X-MC-Unique: fa-oDekPMY29gtwjObSYkQ-1
X-Mimecast-MFC-AGG-ID: fa-oDekPMY29gtwjObSYkQ_1757404448
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45ddbdb92c5so18551785e9.3
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 00:54:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757404448; x=1758009248;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3DZC6SjHJqkdnRuK9QPLIzqW2N3dxyIyOzsJfjQjEcA=;
        b=Ghl6I8QEa4XG4pEJL6AeVkLmqhXS20cm0UXHdgi5FREjXiTX41K+KIljyDSxkQDI3C
         hpt1PFxB6w/ce/43ZzR5UR1wT/4nRpK1+vjagkOCvqqb38nlYoyVM7F9AWPVddX/e0IM
         ndMpdqVKo1Zel3ZoLBM+4aJsKoLuOIFd/kH0SDqi39/ECIf0/HGiAKHB+RFtXyFKe/WB
         qKfpws5/FRQMavKpw2j9WZPgr+bdODMgfd+ujCRXi2TjLUBUwhakOHmAz2WMmwFZfGAb
         dFmYddDbjaElMyEJ1jvIJ2VwR7UZ05HZkGyroeMv3nYVREOmdxDSEY6+VHa+bhTJdyOH
         o4mA==
X-Forwarded-Encrypted: i=1; AJvYcCVTPba4hvOL3JVhtbP7uBn6Wlcrklzp8yL8RxWrYDLSokHLQ1X1oRr6QYx8QlvVLD8SUxs1+Sxxww==@kvack.org
X-Gm-Message-State: AOJu0YzIPhJk321u/LypJTvT+grQIVXnr90+oiQTySc/+/BbDngCmNmh
	uE153RrjTq8DrsbncQLN9dR8nm5kWj3hkJdSmpkKn4Vq3ulGw+vJF1hJSiQ69C5MPNkN4x7AhWj
	5czApnG0caPUn0UCoeLAmKLHkmW90ojgAZ4+lpDwPUDlkh6TZ88An
X-Gm-Gg: ASbGnctcRB5fAekTo3XQ1af82vh+c61aFGgQLRREfTFhqTtnHV29BioW36QBip26dXh
	7UkxYzcjTL0MSQxXnbbmMcH21z0IfPUorFMCJhLo58dUkBopqtvap9MVSP/W1i5CbTpXbftEpAr
	bihMV78bYnERNSayAgAeKj/9yD4fR1L9V1eAcIzfYZS7E9PvpVWV4IE31oBrTJQ1lKoMy3Vbpji
	PjcSwBFqK4ygTsDrxj6ttng13hKC2+8gYCJLOJsgIDOnal3/vnmKtA2A5djOLrZnHfudq6caguL
	Ab6/v51jTEh4ePhyi46FaDXcKUDEHBK9d2dot/Hqgm3R+j7/Azel8YBvFWDUnZKCvwS53kYfLtm
	kwzCmnm/Aby3cHx+Cly59+WGSuULB3Kc0KfKDXF0aia/XBL3WdsEfz+hvkt3yODzL2Nc=
X-Received: by 2002:a05:600c:468a:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-45ddde8bc12mr101543285e9.10.1757404448085;
        Tue, 09 Sep 2025 00:54:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGUz3EkIxY8XDmKHvxdRFhJd9IIUJCM0gY5BxCMp/dmmyB70Mgbw3LDDyyvPoo/+JCo4SkyQ==
X-Received: by 2002:a05:600c:468a:b0:43c:ec4c:25b4 with SMTP id 5b1f17b1804b1-45ddde8bc12mr101542885e9.10.1757404447568;
        Tue, 09 Sep 2025 00:54:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34? (p200300d82f239c00d1f6f7fe8f147e34.dip0.t-ipconnect.de. [2003:d8:2f23:9c00:d1f6:f7fe:8f14:7e34])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45dd2304e16sm224325475e9.7.2025.09.09.00.54.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Sep 2025 00:54:07 -0700 (PDT)
Message-ID: <1bbaa34f-6c32-46a5-bcc9-f8886b865d18@redhat.com>
Date: Tue, 9 Sep 2025 09:54:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] mm/gup: check ref_count instead of lru before
 migration
To: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Krabler <Alexander.Krabler@kuka.com>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Chris Li <chrisl@kernel.org>,
 Christoph Hellwig <hch@infradead.org>, Frederick Mayle <fmayle@google.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Johannes Weiner <hannes@cmpxchg.org>,
 John Hubbard <jhubbard@nvidia.com>, Keir Fraser <keirf@google.com>,
 Konstantin Khlebnikov <koct9i@gmail.com>, Li Zhe <lizhe.67@bytedance.com>,
 Matthew Wilcox <willy@infradead.org>, Peter Xu <peterx@redhat.com>,
 Rik van Riel <riel@surriel.com>, Shivank Garg <shivankg@amd.com>,
 Vlastimil Babka <vbabka@suse.cz>, Wei Xu <weixugc@google.com>,
 Will Deacon <will@kernel.org>, yangge <yangge1116@126.com>,
 Yuanchu Xie <yuanchu@google.com>, Yu Zhao <yuzhao@google.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <41395944-b0e3-c3ac-d648-8ddd70451d28@google.com>
 <bd1f314a-fca1-8f19-cac0-b936c9614557@google.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <bd1f314a-fca1-8f19-cac0-b936c9614557@google.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KENi-BHEoNKMOrdCsfCOkX5uzj5y0NXXvEWlAjCd8fM_1757404448
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FE3E14000C
X-Stat-Signature: fwnmhs55bogwiboimgzccubik8cw85ym
X-Rspam-User: 
X-HE-Tag: 1757404450-318546
X-HE-Meta: U2FsdGVkX19vmfkf7UxJuwCq+3/gXcu6P+JcVDkuABdXlO4WQr3w1rYYmyw9ydUGCHwzPxa4KH80M0Rdz6vu30B6pQ7HJKguuGY0BGBMbDTPkKewS9L/ZCdzWlGW7TTyJ7XqILDcDN5h6d2MBDdICZB2CZxUxBLnnTIxXr0NWylfJbkr68Hveb5JJ4ReN7JE/L14fyax2qtxD079VETZ0JRG+6WlFBDwtg0rjai8ZGZ6pTPYeDRYisUggIh2Kp0e7CKIgkZVDzyTGDlQIExStOFZOmXi0wyKOqR0kdl9xPiubKTDRukRNnxQmWpE6OjPTSQkoFoVLEIYUzHHKZsdxDPBeI2cXp4GST1ekG002Iw8dBPOfDfRwdasYhebzetc0FTZWcZrZHnFG1sJ8iQSAr5I39Vxb1t7hLBCHdgd4NALTvsKURHkpRcss9E3dNKswOpi9MfyQACpMpjhFxkR7PGnp9HxjhMj0qmRMtoS/xCog66S0t642VXDh2HpDWV9GMm27YOi+FonSSheGpmrtEGHMNJxKbMI3HVi4mAgMx0QQosSuZbL+ifxGno7JMfzOp6aSElD87j/gzT3b0cAqeijNC9e3a5R+vN7ygiSC3wXPVGRqzIucWYVW1Qtmeb1SYAlvLfbYh8CK6MMGxtWw20jkNFH2Ly1UJnAwhdg71x8MZqGLLIv1XpwX7n1kqwVAst2CqSldwrcvG6p6w397dvnHP6DaMZg+L/ewbHm7WXa3VbYGrK83K/CeHqXjNqFTM5K3MXEhpJmUbPUYK3rEidmeiPJPLHnjwfi4gfQyIDol7R9nzK3dtGThA1tRsQ29jGU6Vk0TRzjp5+Mms0KksHhpIbmteeA8+Xr5rU0xjCkGiEJqughqFnUHvL84SSLWG7U5nZ/n4AIuyrJ3QBXeeKlH88CEc62oy/4aYeVAXV7MfKLbslgxj+CJKnMuQj7BsSguVtfrMbW50htzjb
 /P1gHBKY
 UhiBcXG+ifSEkzAlErxLyR1vuvAB8jvxHFOxv/iLez9U+GEEGerCGhHsnGeHSyvSCIk9ZgNv5qJh7gSvPUT3VpNC/YsmAphvLJzgEHdO6z28WEHRafcD0ZoYJCC1FOW1h4lgVsfs2snXkZqB5+ByLkVPOHAWLR/xUEt9tKR0XqW18pkjoxm2LFWd8Ju8iDYEk5z4l+we5now2QfwzxON7IMv5Wg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.09.25 00:15, Hugh Dickins wrote:
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
> Note on PG_private_2: ceph and nfs are still using the deprecated
> PG_private_2 flag, with the aid of netfs and filemap support functions.
> Although it is consistently matched by an increment of folio ref_count,
> folio_expected_ref_count() intentionally does not recognize it, and ceph
> folio migration currently depends on that for PG_private_2 folios to be
> rejected.  New references to the deprecated flag are discouraged, so do
> not add it into the collect_longterm_unpinnable_folios() calculation:
> but longterm pinning of transiently PG_private_2 ceph and nfs folios
> (an uncommon case) may invoke a redundant lru_add_drain_all().  And
> this makes easy the backport to earlier releases: up to and including
> 6.12, btrfs also used PG_private_2, but without a ref_count increment.
> 
> Note for stable backports: requires 6.16 commit 86ebd50224c0 ("mm:
> add folio_expected_ref_count() for reference count calculation").
> 
> Reported-by: Will Deacon <will@kernel.org>
> Closes: https://lore.kernel.org/linux-mm/20250815101858.24352-1-will@kernel.org/
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

Acked-by: David Hildenbrand <david@redhat.com>

-- 
Cheers

David / dhildenb


