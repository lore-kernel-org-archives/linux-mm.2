Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E522CAC5B9
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 06:32:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D98918E002E; Tue, 30 Sep 2025 02:32:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48BD8E0002; Tue, 30 Sep 2025 02:32:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C11738E002E; Tue, 30 Sep 2025 02:32:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AA8BE8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 02:32:12 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A7D61605FD
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:32:12 +0000 (UTC)
X-FDA: 83944946904.01.C3436B7
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id F31AA100009
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:32:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hzjiWv/3";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759213930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QZxX8N/sKGJlVE5pAbHGzUpk3+c3k9/cnQoJvNOE3+s=;
	b=8dj/qBTo0EoK7neUe2LyXzm2/lnGpUEml53AkFHBZN3g4V9ubPmUq2o5XZKwhkSBZFbDtr
	SBmsIiK1j3AoInIA6h/dKMcY5M8Qcjy9ifEABj+2kkjvFBz7g84kaLvEf9mdLTDoh4DhIr
	i0YxY97grEFunNjamdgjtxt+yPpd18k=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="hzjiWv/3";
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759213930; a=rsa-sha256;
	cv=none;
	b=R9Ner4nBHZBUkIo/X+3ogwYTdBbAGq5We6R2XAlq4wN9OR1T56lfLaEEhDR20yYUAYQDxV
	qfS9V/TKN+WW9HYPO82VwZ6iQVhD7flPIOPw+Fk2oQl3pv3tjwFLIyHeDdWdtYc7YXr8Vb
	vqdsdnQ5OKSqg3G/fr/U5NZelApqHUQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759213929;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=QZxX8N/sKGJlVE5pAbHGzUpk3+c3k9/cnQoJvNOE3+s=;
	b=hzjiWv/30NRDGme9LEmvCNuOcHdmqw8vV3SlADM0OmH4UcLtI3csRkV31FmbdCcCP4FMHS
	zO+XPcyK7FnQW+X0l41bdP3RYLJ+p1CVdsW68agxQJ4MX7P2SdDjBDxAo/C3qwhf/JWUIx
	u2cRPSAfBxZHRPWSPvHcG1Q8ItiP6+A=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-ccF-klqQNL2TvApaw89fYA-1; Tue, 30 Sep 2025 02:31:56 -0400
X-MC-Unique: ccF-klqQNL2TvApaw89fYA-1
X-Mimecast-MFC-AGG-ID: ccF-klqQNL2TvApaw89fYA_1759213916
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3f924ae2a89so4432013f8f.3
        for <linux-mm@kvack.org>; Mon, 29 Sep 2025 23:31:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759213915; x=1759818715;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QZxX8N/sKGJlVE5pAbHGzUpk3+c3k9/cnQoJvNOE3+s=;
        b=nBk7gSJ+v5ErmPcYyzRCTihzxalKfpYdAOv62G/A+LvOAKueMp47mIGG5kMmPl6i61
         pUIn7q4Gfh7jCGQGBsfoMPr74fIItbzpD7Yhmyc7WbzV6qFMWSnkY0SVhst0VeXkPRmk
         YMdWOm3soFOAK5/BZG9VmYHMrtrc0aWE45sM8PCQDix1kKfKwGkbcRdkkffGTpeJhugk
         A+IZEkLH42n6uOe2wm5XNDi5/s9jt8TWgXhbQm/7M2KKmR/MV+92r6mZPvmSl2UcnuHR
         7BDIhpJHdPmK3anUUMUoSAIdnDuGOaORn5G4F/KOhjutt0Aq/9Aj5xtx8XVoi/Ek3dJN
         0ukg==
X-Forwarded-Encrypted: i=1; AJvYcCWc2vUaAPW66IrpJMW6pqQ3linG4ALNyPpqnxfWFZ2x+gNZHxjdmqWOcWi6H/Q9D/3MZeWeEbJlpQ==@kvack.org
X-Gm-Message-State: AOJu0Yz6Ktc/sav67BaM+PccyW4MjzVIlzyvFvX0wrbnUamgOaDjNb1T
	5GvTZKA8b50PlECb2Cg2I1NsX3ekES7Yh1V2Ba+VjUPf6H9Mj9S6RdeQmFyDKHTsxvaHfxVGSmX
	LXSgMwOHuv7e0sEfOzI/7D5904TfDztoVKvm+e5aB7CD2bR56YAqk
X-Gm-Gg: ASbGncuz7QQDWfsXUBowvvQWy3AEEGD5yibSk/EEQPsba6QZmatwUYdsBQ0E3W5Hrly
	2be5+3AX3dGVMqAtre6zd7LBYypgn7vn5Baa+mFvCkoHJ92WSXOjU57xsJmdH4wwyoaclgzOURK
	Pc+NUxYSc6UnkcNrGHMLeNrEOL5x8/qpdyakzOxGWYE0tQmSGBrP5brVGBpE72QY58rqMrHvDwA
	T9T2pyvxplseD4miYH12Hpt2IDxWG/3Oh2tGULDfoRlBicwKVmeHa/6Bklrq5wV9Nia+NcxQ9Bb
	7Hr2gQU2kBBNSDjbcQD/4k/T3CrqwHf3qNGB2L+LawBQI80jriYBcG6czA8x/cCMDi8mxR/Cbfi
	mg9UbpJKJ
X-Received: by 2002:a05:6000:2901:b0:3eb:60a6:3167 with SMTP id ffacd0b85a97d-40e4bb2f6c4mr16567492f8f.32.1759213915555;
        Mon, 29 Sep 2025 23:31:55 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGmobp+tOjJOF//PmKFIcM6NnU02g+dLKnBZaleTbh+vwqdgi1vbm7nrtaV/IIxMnFIr9mjRQ==
X-Received: by 2002:a05:6000:2901:b0:3eb:60a6:3167 with SMTP id ffacd0b85a97d-40e4bb2f6c4mr16567476f8f.32.1759213915104;
        Mon, 29 Sep 2025 23:31:55 -0700 (PDT)
Received: from ?IPV6:2a01:599:901:4a65:f2e2:845:f3d2:404d? ([2a01:599:901:4a65:f2e2:845:f3d2:404d])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb9e1b665sm21132349f8f.27.2025.09.29.23.31.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Sep 2025 23:31:53 -0700 (PDT)
Message-ID: <026a2673-8195-4927-8cde-f7517b601125@redhat.com>
Date: Tue, 30 Sep 2025 08:31:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: peterx@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
 npache@redhat.com, riel@surriel.com, Liam.Howlett@oracle.com,
 vbabka@suse.cz, harry.yoo@oracle.com, jannh@google.com,
 matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
 byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, usamaarif642@gmail.com, yuzhao@google.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, ioworker0@gmail.com,
 stable@vger.kernel.org
References: <20250930060557.85133-1-lance.yang@linux.dev>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250930060557.85133-1-lance.yang@linux.dev>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VfVsSf4q78Z5Ekb6JZm4hlV6yz0g20BremEUPq28R5Q_1759213916
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: yjakicixdwm7rxgqhnyi7y4kgmmrz85g
X-Rspam-User: 
X-Rspamd-Queue-Id: F31AA100009
X-Rspamd-Server: rspam04
X-HE-Tag: 1759213929-484751
X-HE-Meta: U2FsdGVkX1++W+daJ9UhPVukstnIP+XEhHpBB4BHdUcWQkXqD8LOVoRNZnY4yzKONzlJnIBjC2XWK8+y0r1W2LZCsn4ti1rGCmshpyUz/wyovvSjfSAs9WVVhAtJpCIMp124HL6k2GNI/DvcFXQNVjOe47a58keJ7s8J7MZ/7QG57X52EAneWf5jTEtVkWuRwC17xT5NOKpvecqF3jSs2auwz9rWuJudanxoQGgflZqOe8YZtM28mEX3St2P4QpdNgT3Rc0FEpTs15N2bf4a2t/Daysx3AobJL9ahC1EP9JVs1/TEr1PqvhBdUD55OeCcvrrGS4fqWbq1jEmXGNqCiwOuCWW+3YhMk6I00hVtpAgdQr2KdDVTtqWwtswLbivB5DWpMoPztwOXWAPsW+AFC2nNIDy/y9vTNw0jZt3a7RBabIY0lO62GE/XOnR0m8y4A4YLWqRIOQM9Fwi3lyfNJAUMyqHU59UqRhYRXUEeBOeiSIhfGR5f4dVTpEN6zDIQdE+QUjsBadH4ksjETz7zOBB10XUwGfudACJ4HsvqM7Xe66pWKy9S1wV8PFLawlmS4t/re+tNrulb/rMGjdE0tNNs7GO2cTg3rFAN708P3wGfhZNJGqPbZsjNBUstHP4UrqL2UltEh25t3bMcJ36cT2IijsFKoKm12wHsZpwQeLtu//E4ntxG5JLFz4bDN3tM7HvwJP/ZlBBNimRdnpjHQm0XfR+0Agrq3yDB9bTtOuxj23fO9kKSAz7n1eUINHWhDWNurjJ4b9jVtPDaaQOKBikouk+itJL6JaTHLY/0B72Tf2piDHRjzbrdfUD1gioxbm+Clr5kyI7iijhf14J9o2HolsFCx9WwWxVZOlgpmIEWbcvEP3VXlfDn0xVsMBRFab2U9jDIi9qA0htm200gGVH7RRT1xQjU2nzRUP6TjXAVrMZGiZkVOK0EKlJvH25QWBcd2vVYobTq4W1oE9
 fHdSbo4A
 2hq8OoNlW7g8JNI1Ge+zc91v92AYpMGtCOmCTmvP3CbdNd5yWoCn1c48ICS8OQsYmu6eMztCaeCoMPO0M2RXJ68PNyinlNTMusI0og4/AKu5tJv/CNUFX65lNMrt5hFe6cDYG6Kl37LXBckWJu7vhW8PfLf9+lTCdHjnI1UDCPRlMXA6j71pwPljDo87QnO3dLA28yVHIX3T0XcJPPYALsYqAboAn00pnv5zvo3Cjsgak8ItqVthqsz1oqnqGqKvvmkr1xqaSK0EYi/uygtN7pQd1oJZ7lL9k9Ofgiiw/OavFE5uzlxiR3PiRjOOynOfX1v2vyEih7vcud/ht9WfFiEf+wz6RkcfW1asUVWoZQiIkF0MOCH8tamIXLtP9dv6nfUolg5J5WV6GQ9AQszHxVRdtnR2LVT8K854IuSPIaGcU3FtTPH/ofhw+QKjGLUZegajE8U/LlcL7vpKfc/y/aeuR6ZGDLfBS4zTvAuCJ5HeiMlUMGuG0ZeuJFuEMPXSHAcfNBM25ajH0rYEMxfmymNYJ9A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 30.09.25 08:05, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> When splitting an mTHP and replacing a zero-filled subpage with the shared
> zeropage, try_to_map_unused_to_zeropage() currently drops several important
> PTE bits.
> 
> For userspace tools like CRIU, which rely on the soft-dirty mechanism for
> incremental snapshots, losing the soft-dirty bit means modified pages are
> missed, leading to inconsistent memory state after restore.
> 
> As pointed out by David, the more critical uffd-wp bit is also dropped.
> This breaks the userfaultfd write-protection mechanism, causing writes
> to be silently missed by monitoring applications, which can lead to data
> corruption.
> 
> Preserve both the soft-dirty and uffd-wp bits from the old PTE when
> creating the new zeropage mapping to ensure they are correctly tracked.
> 
> Cc: <stable@vger.kernel.org>
> Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v2 -> v3:
>   - ptep_get() gets called only once per iteration (per Dev)
>   - https://lore.kernel.org/linux-mm/20250930043351.34927-1-lance.yang@linux.dev/
> 
> v1 -> v2:
>   - Avoid calling ptep_get() multiple times (per Dev)
>   - Double-check the uffd-wp bit (per David)
>   - Collect Acked-by from David - thanks!
>   - https://lore.kernel.org/linux-mm/20250928044855.76359-1-lance.yang@linux.dev/
> 
>   mm/migrate.c | 14 ++++++++++----
>   1 file changed, 10 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/migrate.c b/mm/migrate.c
> index ce83c2c3c287..bafd8cb3bebe 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -297,6 +297,7 @@ bool isolate_folio_to_list(struct folio *folio, struct list_head *list)
>   
>   static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
>   					  struct folio *folio,
> +					  pte_t old_pte,
>   					  unsigned long idx)

Nit:

static bool try_to_map_unused_to_zeropage(struct page_vma_mapped_walk *pvmw,
		struct folio *folio, pte_t old_pte, unsigned long idx)

LGTM, Thanks!

-- 
Cheers

David / dhildenb


