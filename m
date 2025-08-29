Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA5D9CA0FF9
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 13:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10356B0006; Fri, 29 Aug 2025 09:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE5BD6B0030; Fri, 29 Aug 2025 09:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD4396B0031; Fri, 29 Aug 2025 09:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AA0EF6B0006
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:22:16 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2D85C1198FB
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:22:16 +0000 (UTC)
X-FDA: 83829858672.19.D24C124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 961D818000F
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 13:22:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hjIJulPT;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756473733; a=rsa-sha256;
	cv=none;
	b=CDWLB9wnmhLOHCtfq8s2P5QEm5ySPGja3etE1je3fe0/361G63LoII+wwToUUGxOBUV94v
	auPCGn69sHyJpjxY1GEmkB8sDUgwViZAJBsv6UU/cKu7++oRhn4hcRNC3BNWM42Smuepmp
	RADH42JGinKUp4DM1qGzEEBfRGVFNMc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hjIJulPT;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756473733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aggFKTWIoz3JmsTS53UGUQwfpKwPCT7EHzMCjR4W6Kc=;
	b=Hl6nWJP7CwCJZMgRFfbORmPMKK+4CMtNC00q55O+Hqipo9euj3iU/9YF7pPlwMWaYUgIWU
	v59KwVlMTwVPnJyK33QVtCB6q4lxuYXzW9eBMF6Y4uMaG/QpCnNyK4oJ4Kqi6Ktmy4NSSY
	Nj408xo3q4IFwvF16XUhGAzDIT1o65k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756473732;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=aggFKTWIoz3JmsTS53UGUQwfpKwPCT7EHzMCjR4W6Kc=;
	b=hjIJulPTXuBR338grYt+1VjSuaB07xzT1f0wqWj60WeOtbf+9WW9c9+pEDMom6RZEmR3QU
	RTG+6r3nu6q0NR7AmZQvsLCMYfFfOKXs80ru/3i4JREsuy/Xge+lASdGdMmctNCVAiDm53
	Vfj35gen+b9jA71J6iqB4LlfbvsVexE=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-SIkfXQvRMcaso5BvJ_FgCA-1; Fri, 29 Aug 2025 09:22:06 -0400
X-MC-Unique: SIkfXQvRMcaso5BvJ_FgCA-1
X-Mimecast-MFC-AGG-ID: SIkfXQvRMcaso5BvJ_FgCA_1756473726
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3cf12498799so601746f8f.2
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756473725; x=1757078525;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aggFKTWIoz3JmsTS53UGUQwfpKwPCT7EHzMCjR4W6Kc=;
        b=nU13aKqA4m9yxEDWSZr7RIRAgfN40anLRDRVMEXinJ3Z552gq6KkbYvVxRMvCuw1qp
         HfIudND1yGNbZiUuke2a+rXKEjubafc3gWBGoRZ3QpFymmDPucd22jD8wS9rZggI2Yb4
         s5PYQGNtaBQEXR0Sez4JCHauQkzejClWELLNB308x9alriVtKIqqKLOjlJoFUEAGQWft
         ptcFis+10QIdszWmuNaIBe8g7czLDFiEALiSjUksDuS8PdQxs4pmTzxT1eb1ZVqbjRjQ
         PqAsIk0gjGTGTSgAI7R5gkBUelqGAL8ri3ONwhAq9QsGrOIX/AH5EsYnbylLHWjNvr7Z
         N88Q==
X-Forwarded-Encrypted: i=1; AJvYcCXvsXcdg+tXLHk1TZqCZfg/T163tTNaNx3V/2MxXSQqGxVSzcUU4mKKkHWU2ngL3Wnw1VCvQeJhLg==@kvack.org
X-Gm-Message-State: AOJu0YyyZFkQcPjoZY7DGCScDOf7I0uTsaBp0bDD7ky+D2d5GYcL49O8
	repHUePYd6vrPJf5l087pdmpzEu8vmki5Ty2QF6QhdWCAzHVGBhIQpfk04CWmnWKWIqf4bNmf8l
	j3JZ1gJ2aIX0C3UPrdCBv9N7O8r0h/vYMTlD66g3lZOSiohEhUluM
X-Gm-Gg: ASbGnct46jotIn/tLc6F/XP/EFZOHQu4QI93EfBDa/d8uiDHI0AwLSV/U5/4JmVkPz4
	uOrbH30Uw8p8DhKCP1YPenVqxW4wKjBTvg9UlamJoA7IqmuPt4O3sgM5GuhSwjOWaWdrkUSwNBT
	iHtEnvgyvwhScTv8k0CSr2vclxcFy9GRDw8a6cwQnIkaXlm8xb336KTGpyJNNhQBdCajztP2cOr
	BAskmgZazwsGairFxj0HZTqjT9Z/ZmGFTar9UyeGMVCPUNvXy2SvyNlgPdcXp8JPDrVY09vpB3x
	Yq5PvnZZnem5uc7Hm78x6P6wjOdu8+PuDqE7t/TLvELdswKmHmukHb1AbqVsqaKCkX9KBouhZbm
	Z1PiTT6PSufEmeWxE/A++KzBwL0a8ApQXBTKKNWIdAJcFhi0NACuX+I02yVRj5DFP
X-Received: by 2002:a05:6000:2c0f:b0:3ca:a190:c473 with SMTP id ffacd0b85a97d-3caa190c6ecmr9849820f8f.4.1756473725380;
        Fri, 29 Aug 2025 06:22:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGFfrTd/+15/bT4PGZswHLcvGvODyGQLUC+I3pIFqxdvqjEg2cDf44HeYcneQKTQcaMEr0KOA==
X-Received: by 2002:a05:6000:2c0f:b0:3ca:a190:c473 with SMTP id ffacd0b85a97d-3caa190c6ecmr9849784f8f.4.1756473724881;
        Fri, 29 Aug 2025 06:22:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f1d:100:4f8e:bb13:c3c7:f854? (p200300d82f1d01004f8ebb13c3c7f854.dip0.t-ipconnect.de. [2003:d8:2f1d:100:4f8e:bb13:c3c7:f854])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf33add483sm3368560f8f.37.2025.08.29.06.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Aug 2025 06:22:04 -0700 (PDT)
Message-ID: <f7f9f535-0bbe-413a-84e4-fcb17a502a40@redhat.com>
Date: Fri, 29 Aug 2025 15:22:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 16/36] fs: hugetlbfs: cleanup folio in
 adjust_range_hwpoison()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, John Hubbard <jhubbard@nvidia.com>,
 kasan-dev@googlegroups.com, kvm@vger.kernel.org,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Linus Torvalds <torvalds@linux-foundation.org>, linux-arm-kernel@axis.com,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-mips@vger.kernel.org, linux-mmc@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-scsi@vger.kernel.org, Marco Elver <elver@google.com>,
 Marek Szyprowski <m.szyprowski@samsung.com>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
 Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
 wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-17-david@redhat.com>
 <71cf3600-d9cf-4d16-951c-44582b46c0fa@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <71cf3600-d9cf-4d16-951c-44582b46c0fa@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: xtDJPtgN2M8GglTuSxwZJ4NNwIxA0lFKK8S2czZyY-o_1756473726
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 961D818000F
X-Stat-Signature: 37qsyyryz7zxyefg7ccqodpg9ruzxkkq
X-Rspam-User: 
X-HE-Tag: 1756473733-357776
X-HE-Meta: U2FsdGVkX1+ZTdjM1Pd3qvOs9NZZdgg6sAUo0TEXbxkmwd9rZ3sSUZyFXNPRqpL2FLeJHDrDKhooLOPmPEwZjMXMpBoAUqzvC/7xgio+xoNZltKn8dmJEMIUXwLAlxhR3+hm/3xVg6ybYh7aGsR35h/uPHlsZbLyHdnVePDn1UqIWD6lVru+vd2i5yRbbQND/EzlL57/lQ4+yNbp+yis1Ih6KulVNqLmseOQqCd/YZOWx/meF6H2PQoBsUvLKRNaspjlJHSzTkv6pgG/Eji8hIpEPCDbtQSUXsnIdhNeERFMm1SK8xd/owP/MaK8oY3RWbnj3jWjMXFjzK+iX7fpgYuDHHyJZZB9EX/Ffs1cR8qrDvGy2/0s73fRvQH73/oVeMMhGQjG47toJkyZuxnG+MHinEoQVGSOXz1cGqY9dOqcMWrPnA3e0Jt7NLG/b9q0oA0XJu2lb6rTvfccsLffOjk3/7ua0GjRDWpCzZNTMxcPeOCRRd6cD3FBFMdOSBQHvVl4a6QRWp3pZ+s+IhXfNv/kbqueSr9vbsoBUymy2zMt8U3JGnH2z6AVEiAxBQoQlRtxvIEBPFDPwWU+jmesZHtvS2Bwrx1Vb8QXb7qNvfXJjBI293akGcmp9WTPUIY0C5SvYcvhJmA+KcR63aAo4R91wjNGF8hmnepN6e+p0ksYMuJ3BS3ye8iLHKqYB703deqCA1iJYStbLLrvg3Nfo6cbByf10ZG7gnWkk+NwYM6N8/64pS5yZnxa1/SFep7yjfq+IdpreB70/d3L3WpRdWDDRg39gv1RqqoPsuqGKi/8pLTSz5qAjV1b9r6yRr1q8vP6frpKLh8jCZMi+Jch+wJLW+WQGoV2NSaQEwkdmyyeHNKk+pfsIgFXvrWjScChRF1zbDFXWrsGpjsP3KwnPrwJ1ferq1+Q601+xHaLLSE1dDFJIOodY3eYJCXnMSxj1J6gCvdyS+SnUjc2U5L
 MZb2ompl
 eO06ZuEa2YAmswIxGoFDMxif9uIidz5S/YnRAkJGWkpM37pw39oN1W/1ziihzjjTBbEJLZo26iHwey4c/6zRpzcw/o9+c7+R+R3AWpA5+9+9MjWuGsR+LYMt7VhiZ0/hdzrNODOYmoLJBFMnd+gXvQ+pfgwkDR0QmK1gADskXx/PAJcWLWvizUayYfGN6jBOVUrNdZHOa1/LByVfI1EI+oEt1MwUtHXGRYKMfWF/z4v+9vyENtfg2ne6eV3v4Zil4YeP8jsnFYNGz77NwWyCvBWLFrp/i/j6h381x0sR3U5gZbZ9BwMUWAjgrj99SrWxpvl/ZIBIsH9EVSEowjmm44219M7Qe447QJuFg31NxkjNunXjjCMWa4u/C0P8AiYhtgk6MhyBV/BN1JhY6yu3LWmPa083jMrmnaHm6otbKgywo8f+ZATD+tS7WET8kv/yGd9caIDX1HtyfBdLH+oMQ4peNvmw8rPUMkf0XB5qpnCpyTxEj8bcnd8wE+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> 
> Lord above.
> 
> Also semantics of 'if bytes == 0, then check first page anyway' which you do
> capture.

Yeah, I think bytes == 0 would not make any sense, though. Staring 
briefly at the single caller, that seems to be the case (bytes != 0).

> 
> OK think I have convinced myself this is right, so hopefully no deeply subtle
> off-by-one issues here :P
> 
> Anyway, LGTM, so:
> 
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> 
>> ---
>>   fs/hugetlbfs/inode.c | 33 +++++++++++----------------------
>>   1 file changed, 11 insertions(+), 22 deletions(-)
>>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index c5a46d10afaa0..6ca1f6b45c1e5 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -198,31 +198,20 @@ hugetlb_get_unmapped_area(struct file *file, unsigned long addr,
>>   static size_t adjust_range_hwpoison(struct folio *folio, size_t offset,
>>   		size_t bytes)
>>   {
>> -	struct page *page;
>> -	size_t n = 0;
>> -	size_t res = 0;
>> -
>> -	/* First page to start the loop. */
>> -	page = folio_page(folio, offset / PAGE_SIZE);
>> -	offset %= PAGE_SIZE;
>> -	while (1) {
>> -		if (is_raw_hwpoison_page_in_hugepage(page))
>> -			break;
>> +	struct page *page = folio_page(folio, offset / PAGE_SIZE);
>> +	size_t safe_bytes;
>> +
>> +	if (is_raw_hwpoison_page_in_hugepage(page))
>> +		return 0;
>> +	/* Safe to read the remaining bytes in this page. */
>> +	safe_bytes = PAGE_SIZE - (offset % PAGE_SIZE);
>> +	page++;
>>
>> -		/* Safe to read n bytes without touching HWPOISON subpage. */
>> -		n = min(bytes, (size_t)PAGE_SIZE - offset);
>> -		res += n;
>> -		bytes -= n;
>> -		if (!bytes || !n)
>> +	for (; safe_bytes < bytes; safe_bytes += PAGE_SIZE, page++)
> 
> OK this is quite subtle - so if safe_bytes == bytes, this means we've confirmed
> that all requested bytes are safe.
> 
> So offset=0, bytes = 4096 would fail this (as safe_bytes == 4096).
> 
> Maybe worth putting something like:
> 
> 	/*
> 	 * Now we check page-by-page in the folio to see if any bytes we don't
> 	 * yet know to be safe are contained within posioned pages or not.
> 	 */
> 
> Above the loop. Or something like this.

"Check each remaining page as long as we are not done yet."

> 
>> +		if (is_raw_hwpoison_page_in_hugepage(page))
>>   			break;
>> -		offset += n;
>> -		if (offset == PAGE_SIZE) {
>> -			page++;
>> -			offset = 0;
>> -		}
>> -	}
>>
>> -	return res;
>> +	return min(safe_bytes, bytes);
> 
> Yeah given above analysis this seems correct.
> 
> You must have torn your hair out over this :)

I could resist the urge to clean that up, yes.

I'll also drop the "The implementation borrows the iteration logic from 
copy_page_to_iter*." part, because I suspect this comment no longer 
makes sense.

Thanks!

-- 
Cheers

David / dhildenb


