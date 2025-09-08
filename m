Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 840A0CAC588
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 12:53:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC5528E000F; Mon,  8 Sep 2025 08:53:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9CEF8E0007; Mon,  8 Sep 2025 08:53:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C8B838E000F; Mon,  8 Sep 2025 08:53:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B531A8E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 08:53:10 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A418160146
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:53:10 +0000 (UTC)
X-FDA: 83866073340.15.09DF4DD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id EA7904000C
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 12:53:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bnu3yxtY;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757335988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nqKqSNT26uK0ctF10EJrKeCsL0Ppf+8ee2pPXGgNN7Q=;
	b=Wv3nkiaqAOB8h7nfgyUmK3/abkZWd5/+iePwkf5NewhBOBFpGOqrliWAQ3+b5rdg6alTNG
	CQUiXbOt5JnDZ/c97MlMtxKDAjOTl9dUTpEyN2g24dplARYNKvuU/5RD29upbKcMuHVjvw
	fF3PZbqeamrhfP2QwuxK5kFZZt0C50o=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bnu3yxtY;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757335988; a=rsa-sha256;
	cv=none;
	b=PlP3ihYSYVSsJB7ZTeBm6sja3sSEBwh/t3CCszcaMeIn7ATC+9nQdi4M5hjuHtJeH+/wYP
	vY/r4wXKO5e8yCyvKcGpCZ5k5wAxGpzRGGPX9bmYBfI4Vsx8WINMsktqakcpHK7GkBMe6P
	UU/CKXU1f21HTCkfRI81D7J5waTCTgg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757335987;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=nqKqSNT26uK0ctF10EJrKeCsL0Ppf+8ee2pPXGgNN7Q=;
	b=bnu3yxtYkcXe0OTHnBYCpKPzE1C2Gc7e/GNrWQNvBTQcyE7ZNNyJdqOtasldnxG/Ucf1Ob
	mfnOV4ty6PYeO/2mHnSGM50ucwErdOUzgHs7Gyc2AXNfGnuuPrzn1O67mBkAk62huBdsfE
	qUmTERAHqyD5VVZ7VjUFjq7HdvFCdMA=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-XHHGnWg2OQK6fAdIRpnl6w-1; Mon, 08 Sep 2025 08:53:06 -0400
X-MC-Unique: XHHGnWg2OQK6fAdIRpnl6w-1
X-Mimecast-MFC-AGG-ID: XHHGnWg2OQK6fAdIRpnl6w_1757335985
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-3e424a186fcso1283026f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 05:53:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757335985; x=1757940785;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nqKqSNT26uK0ctF10EJrKeCsL0Ppf+8ee2pPXGgNN7Q=;
        b=IHx0xeCi3ACz/O2Kd2OXGITLIT/SMpDmkYJM8FqYVF+ngsXJsxEV3atspHcnRI4Rf/
         poWcJ6XmB+ON+ezRUIQEpJFnPPdWgusZZAhI0Gk/F0JA62pZ4Kzue8qHjLp0EPhAJdTa
         P/rwWNUf/iGqIQnSsPbrN8qF/xnkdmlM4KUnzmGfTURdeOO+8PY6KIJV+yBSNVpZMG92
         OAbTamfaTzDnD44xvm5wUXiw4/qg9zgUg4oS1QtBeb8aufvJophFSKxGCA59R80HZPe4
         jJLoQRW0JswCX5dEVqon4ZjrKQdaJ3vD+NK7fUZpNrXyx38kAN+B0or5gkD2XsbsUfYy
         8dQQ==
X-Forwarded-Encrypted: i=1; AJvYcCWJXHuFNn6mS9JTIVsPIPu11regun+W9V0+tq5CFf146KjnQOintPtyBvoErd0iJG76jHVyttu51A==@kvack.org
X-Gm-Message-State: AOJu0YzGFRTqikM2gVZvbe/8NO/SFgmeqs5MjgEHwwV2GBZFleAQ0WCA
	Q/vuFP9rJ+g2s9ZTNJzk+gYZ0frcoRciDPfuBeJSyVSQo9alzlphCzA4vuQkT0WtIurQMrsR2yg
	myjrTgMRhQnXiyA+hjEblgl5NwP9g3zjeJjEuZLSOkEu5Jrg0Ojyp
X-Gm-Gg: ASbGncuB8aLwlFHFbVos6oSGJtT1FqBsA9mARXGH8MvOAT4dTf87gh/S3I7vNX72fqS
	LAMDlrD956gHHHIqJYXcb2LIGog+mtudlzpZ0meS4v4/KrTF/H/Br62Nf3N6BqjrRm2JPaNvrhO
	mF69/DBFB8Ch55DKQGW0vZtQBwmD9cgQ80T8eM+snu1uPb3p2KTNzxQa4l58/Yq7gPSzXe8obCg
	H3Ecchsxe8AhuQo1YZUerSD6q0PUsmI5nE62suawBISmAIr3Xeg/iQfhFh+JJ2qnlgzyW//VVRg
	ptRpn2azQPW2yT8LN9hXLUXGvTkAIbZkH68Dcs9LJFM/zns5VDO+rwtne/nWBWpnuVb8sYjqWIu
	hiTFESBpq/KjG35Wybr8olNGKsXHejgG5WKxL4emVpbxEvB9RJUG2mJDSzirX85LN
X-Received: by 2002:a5d:64e4:0:b0:3df:58c5:efd1 with SMTP id ffacd0b85a97d-3e6427d6e15mr6188448f8f.25.1757335984591;
        Mon, 08 Sep 2025 05:53:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCDxFquotzqnajJLjBsVtEGOKTyR3mfE6vqo6/1C+mdI526t5VUp3r/8RO80kgSz2c6+Q56w==
X-Received: by 2002:a5d:64e4:0:b0:3df:58c5:efd1 with SMTP id ffacd0b85a97d-3e6427d6e15mr6188391f8f.25.1757335984032;
        Mon, 08 Sep 2025 05:53:04 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3d1007c0dc8sm40030772f8f.53.2025.09.08.05.53.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 05:53:03 -0700 (PDT)
Message-ID: <7ee0b58a-8fe4-46fe-bfef-f04f900f3040@redhat.com>
Date: Mon, 8 Sep 2025 14:53:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: John Hubbard <jhubbard@nvidia.com>, linux-kernel@vger.kernel.org,
 Alexander Potapenko <glider@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>, Christoph Lameter <cl@gentwo.org>,
 Dennis Zhou <dennis@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
 iommu@lists.linux.dev, io-uring@vger.kernel.org,
 Jason Gunthorpe <jgg@nvidia.com>, Jens Axboe <axboe@kernel.dk>,
 Johannes Weiner <hannes@cmpxchg.org>, kasan-dev@googlegroups.com,
 kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
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
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <016307ba-427d-4646-8e4d-1ffefd2c1968@nvidia.com>
 <85e760cf-b994-40db-8d13-221feee55c60@redhat.com>
 <727cabec-5ee8-4793-926b-8d78febcd623@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <727cabec-5ee8-4793-926b-8d78febcd623@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Jr7s8F3D_TukQqKby-H8NswSHqg6MywtXMZ76f_bGDg_1757335985
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zoeex1km1ay55q519bmsdhk1rqxq54jd
X-Rspam-User: 
X-Rspamd-Queue-Id: EA7904000C
X-Rspamd-Server: rspam05
X-HE-Tag: 1757335987-902842
X-HE-Meta: U2FsdGVkX18DYVsc+b3vqGg7QjYDtesDFeRpe9ijDbOQO8m6n3yO4j4Py6TyhFGQR4vUn/0quyxkMjeqfgfz75GA1A/zQoQt0bWG2a5tTKE+UPRB1DjQXFeAaCyD1kogx/CU+bmga+fNhufuBU+p01YF+hZSlNsvuJdIMsYxnQp+pzGxDeNoYAs/FgetW5vsRi22RKYQQdYKfmiectkqaECowEbi9ltje6scCnL0VI3WJGoNFIbxbCmPUtLCf2dlCiQgrQae9aVDrSnU+HhWrre3Jzr5kFgCd+LPTSqIPa63IFOK2MhkhPCOVlhhTYD0OBMyoBG4bbfhDBjBRsU/6MZLUdMr6JGixg12CMTCjQcZKxzzSYVYQLIANWAkgLjMZOxOn/IsQrjYzu0lidNariKmzpA2NXOUaLyK26OH7UPgfVcU6dY+3akCBU8Mo/4//WgvAqnt9P9Oy4vBurCAlgROZEu9PccaJnxVhP53ZbhrLAxzYkhtl/+Y5+hChb4Rqr79rTSNbtimzNSQvHjh57CtIA6rV6V8w3kcj/ENqV2IgNLMR4XyGdZOXuExLym6rVkejykOjejB8DAs9sdKDflBJd6CnFYSO+lZ730HouDp0TCjIXMbdpODJz17s5HBQH8ywXT4RUEZf73/I5VLk72vvSq0AZBRiXYYvmmzRFE6gBxRSOTFGCaNjFmVu8AHIHDye87RVvcxH5hhY3BNkHk5ioQ9NpLt35gzJFKMe/uYLRuK6Lg/MTkM/i3A9Q7iC2qdaV3W/6b8DlGyUoE/ofB69jeVS5D7Ev+LkU+4CIdTovoM4zOKyygXyE1GF7ntFpcDoGcq0d1H9A09+1h+H7T8RG6yZlySTJ0PR9xg7Rq/Idcp4BzGOSHqjFRwmxzRvVD7awP5fpzYFFqDNVMIjlcJetvKlEsLT4l2ufLgNv/7Vjt7lGle3a+pznrxfxOnbjVnmvaj2rk/mGePCFq
 icJeoZ20
 TaEtjRnVdjHlG4UjU2ohh6BW399+TEkejQ/q/JtYPgj4KqtFrNSzP/zdcn3jjNdZFkELyPfNJVt0oZul18mMMXxuGpaHq4fzsY5T56PbFhXUl4sUeE2gu7DTdcTsC9++NILEXuGcYy9QVTMxHgch2aRripDmiRfsUUc801gaS/3EfZedb6Ou81x9jI9O1detJ1jCAluAQ3ns0A9VW/Z/BRW/J/e/5ms1BhK5934akRspRY+8EJWwhCVamoL1+9hI9wSBz3yVK/miDA4GGBfdNGcKFtbBSggOXv65XaOxVl0cVVMX27/gp1IrwIXttygafso4LWjyfPwmrlemdZvZen0PQbAE+7V/lGDs3XkcL3H5rw/EeCEFCg1eH7oBU9FEegA3ZeJa7CrhMawD1FqV56pCagR8viFCL1HJ9gRp26/9x7UIho3MMoaNe7IbycBn2Tg3LibdkFNqhpZFfe03spQj3Gw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 14:25, Lorenzo Stoakes wrote:
> On Sat, Sep 06, 2025 at 08:56:48AM +0200, David Hildenbrand wrote:
>> On 06.09.25 03:05, John Hubbard wrote:
>>>
>>> Probably a similar sentiment as Lorenzo here...the above diffs make the code
>>> *worse* to read. In fact, I recall adding record_subpages() here long ago,
>>> specifically to help clarify what was going on.
>>
>> Well, there is a lot I dislike about record_subpages() to go back there.
>> Starting with "as Willy keeps explaining, the concept of subpages do
>> not exist and ending with "why do we fill out the array even on failure".
> 
> Yes
> 
>>
>> :)
>>
>>>
>>> Now it's been returned to it's original, cryptic form.
>>>
>>
>> The code in the caller was so uncryptic that both me and Lorenzo missed
>> that magical addition. :P
> 
> :'(
> 
>>
>>> Just my take on it, for whatever that's worth. :)
>>
>> As always, appreciated.
>>
>> I could of course keep the simple loop in some "record_folio_pages"
>> function and clean up what I dislike about record_subpages().
>>
>> But I much rather want the call chain to be cleaned up instead, if possible.
>>
>>
>> Roughly, what I am thinking (limiting it to pte+pmd case) about is the following:
> 
> I cannot get the below to apply even with the original patch here applied + fix.
> 
> It looks like (in mm-new :) commit e73f43a66d5f ("mm/gup: remove dead pgmap
> refcounting code") by Alastair has conflicted here, but even then I can't make
> it apply, with/without your fix...!

To be clear: it was never intended to be applied, because it wouldn't 
even compile in the current form.

It was based on this nth_page submission + fix.


[...]

>>   }
>>   static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
> 
> OK I guess you intentionally left the rest as a TODO :)
> 
> So I'll wait for you to post it before reviewing in-depth.
> 
> This generally LGTM as an approach, getting rid of *nr is important that's
> really horrible.

Yes. Expect a cleanup in that direction soonish (again, either from me 
or someone else I poke)

> 
>> --
>> 2.50.1
>>
>>
>>
>> Oh, I might even have found a bug moving away from that questionable
>> "ret==1 means success" handling in gup_fast_pte_range()? Will
>> have to double-check, but likely the following is the right thing to do.
>>
>>
>>
>>  From 8f48b25ef93e7ef98611fd58ec89384ad5171782 Mon Sep 17 00:00:00 2001
>> From: David Hildenbrand <david@redhat.com>
>> Date: Sat, 6 Sep 2025 08:46:45 +0200
>> Subject: [PATCH] mm/gup: fix handling of errors from
>>   arch_make_folio_accessible() in follow_page_pte()
>>
>> In case we call arch_make_folio_accessible() and it fails, we would
>> incorrectly return a value that is "!= 0" to the caller, indicating that
>> we pinned all requested pages and that the caller can keep going.
>>
>> follow_page_pte() is not supposed to return error values, but instead
>> 0 on failure and 1 on success.
>>
>> That is of course wrong, because the caller will just keep going pinning
>> more pages. If we happen to pin a page afterwards, we're in trouble,
>> because we essentially skipped some pages.
>>
>> Fixes: f28d43636d6f ("mm/gup/writeback: add callbacks for inaccessible pages")
>> Signed-off-by: David Hildenbrand <david@redhat.com>
>> ---
>>   mm/gup.c | 3 +--
>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 22420f2069ee1..cff226ec0ee7d 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2908,8 +2908,7 @@ static int gup_fast_pte_range(pmd_t pmd, pmd_t *pmdp, unsigned long addr,
>>   		 * details.
>>   		 */
>>   		if (flags & FOLL_PIN) {
>> -			ret = arch_make_folio_accessible(folio);
>> -			if (ret) {
>> +			if (arch_make_folio_accessible(folio)) {
> 
> Oh Lord above. Lol. Yikes.
> 
> Yeah I think your fix is valid...

I sent it out earlier today. Fortunately that function shouldn't usually 
really fail IIUC.

-- 
Cheers

David / dhildenb


