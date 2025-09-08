Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DED88CAC581
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 14:39:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5388E001D; Mon,  8 Sep 2025 10:39:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47D4F8E001B; Mon,  8 Sep 2025 10:39:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 393278E001D; Mon,  8 Sep 2025 10:39:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2A2EC8E001B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 10:39:33 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D24FD1A019B
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:39:32 +0000 (UTC)
X-FDA: 83866341384.27.BA835ED
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf05.hostedemail.com (Postfix) with ESMTP id 79FD5100005
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 14:39:30 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NAcsvilN;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757342370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eRKrbV6N+yXcBvX5Xr1RCzbreOC0YbswLK/9bZDg2dI=;
	b=EIRMLcbDXtMVtbwiYn2b2kTMNqaxYzPsOCIFFVQVXTeqVv+6TLcjTqMz7nqa3VmsPJp/pF
	zt39Hyq6wjsArPRZEbSB9vV3PQx6Ui3xH0s77NZ8+xfsnG1UM+9LaZH4w9JDGGHMRTkydX
	6USnYlBw3mcMb/oGocGoI/cdDIyWDok=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757342370; a=rsa-sha256;
	cv=none;
	b=Ppx+xn6TQ6mVly8MrZzW81OvUXKRshDiqBxvKzBtT3RB9ryNwbRRK/x9mIFy8Bf9nuHcib
	q6PliObwm8cUQl15iuU2uNew90PMW6xMFOsqRB4Ut/9ACsrZhjVV/pIk0y3cJ//Oy6VjOR
	/5nygT19oa9NlWtwpHMZy49cfJdUkuc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NAcsvilN;
	spf=pass (imf05.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757342369;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=eRKrbV6N+yXcBvX5Xr1RCzbreOC0YbswLK/9bZDg2dI=;
	b=NAcsvilNDnSw5GC4+0tBeuqKrJz/TVxkueXbPh7elsyOlHTB+hawlthd5F+OYRKMx26By+
	CKHXj1ORvjWVTVMf/I6b0ESljab/vHi78MezenYWtEml3uoYvGZZfF5DQ5emNCFVb0ghQm
	1rWDn48Oca0hIg9EI8Ywl7E3IrBf7xA=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-511-1rvZJzYWNRS83cxSILOpkw-1; Mon, 08 Sep 2025 10:39:28 -0400
X-MC-Unique: 1rvZJzYWNRS83cxSILOpkw-1
X-Mimecast-MFC-AGG-ID: 1rvZJzYWNRS83cxSILOpkw_1757342367
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3e40057d90aso1573899f8f.0
        for <linux-mm@kvack.org>; Mon, 08 Sep 2025 07:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757342367; x=1757947167;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eRKrbV6N+yXcBvX5Xr1RCzbreOC0YbswLK/9bZDg2dI=;
        b=hUZs8yH85x6ds1nYmGzOGsT/XJB53JPtSkv29m/UMx66BSFIAAzfsSBle/ne2fJch9
         esgAwu6Da7yQd4fOfIKPMc+RWbSLqHmdDcj0hrUl0MwzJqcj9JIUyOuzKOH20n7M91eG
         /YJuw0E3n+glpmWq0aO/gvw3vCF7mcuriCDncxoLXnjT8Q5THaAWOYquym9zQJVpXVqa
         2LFutmDWhYDaqcKfC/3Dv4E1ZP3V2c9kQ0MDHPsz228Kt49cj3mwRN/qxdvsY+SqHHc9
         wEZp7mNJTDOolc/iPXmMGucm97zFsvLKv4+idnfkqCY2TPOkh58pDbHTFP2SKz2lOMTA
         MugQ==
X-Gm-Message-State: AOJu0YyCD4rjBUPf87jpihb8U7ODFAxhR9kA4hhMdkbhU74n7jlaSaoN
	uBoW9iak2MSnQrcVp5khmdPqjIml866DirOW7v+CfW3WtagaRxJc8dPUtYJuVhDVSgTnh1eVyhJ
	W0QCE5hMgZzoQxC//9L51f/qAifuHjsgMuIc716DhnhvbtmZhwo4e
X-Gm-Gg: ASbGncuHQ4BmWDsD037DaTnILoueZpell00UHmnR6ZBM0IssqSY26wNO0It7WVIpQ6b
	zV328jRuzeAjzEbJ8neS+GE46G8UMNspWTdpL7BcFbiY27XjF9rOsvQAKiM8p1I48UEyNOcWr2I
	BMunXVVqOLefuyOxuM6D/Ih502GhPk/4878C/Qbyyt2c4osxYIuPGBw2YsbSftBrUp2rETOLhlx
	w4/dbCW70Q/PSha8W0HB872TDB25FpRD+1WGtOlWYFZoLG/6dLtRReirOlP22n4gKC0JWPUSY12
	AKQj0TBBAIvK1rHMPvsrUBpUMlOPN/7ueA1bsOh4+eoVBBNHP7mSNl1RaoyhcG4vAefi1895Oll
	3z7TMkEhktkLU0xYxaJ7/XCVD2o8Ti07Nt0SpCGA0Mh2trDO9q+WYA6hf+UpE3tB+
X-Received: by 2002:a05:6000:2003:b0:3e4:471e:3c91 with SMTP id ffacd0b85a97d-3e64ce4fd7bmr6231235f8f.63.1757342367126;
        Mon, 08 Sep 2025 07:39:27 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHb/kakovac8mr4rbvPDrcKOg6cfu0Yow2z3Nhfp4hslKCb3WIHrScQnsGPat9hnCS18bzntg==
X-Received: by 2002:a05:6000:2003:b0:3e4:471e:3c91 with SMTP id ffacd0b85a97d-3e64ce4fd7bmr6231197f8f.63.1757342366611;
        Mon, 08 Sep 2025 07:39:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f25:700:d846:15f3:6ca0:8029? (p200300d82f250700d84615f36ca08029.dip0.t-ipconnect.de. [2003:d8:2f25:700:d846:15f3:6ca0:8029])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e748171834sm4787288f8f.5.2025.09.08.07.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 07:39:26 -0700 (PDT)
Message-ID: <9b4808cd-3239-4bb2-8073-7eb1412c4529@redhat.com>
Date: Mon, 8 Sep 2025 16:39:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 10/15] mm, swap: wrap swap cache replacement with a
 helper
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
References: <20250905191357.78298-1-ryncsn@gmail.com>
 <20250905191357.78298-11-ryncsn@gmail.com>
 <c2ff433c-35d4-45e4-bf06-e725726fa515@redhat.com>
 <CAMgjq7AsYz+pDTCU5PWoNPN1VJ5Vx8ZLQgF6MT26JUSXr=6__A@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAMgjq7AsYz+pDTCU5PWoNPN1VJ5Vx8ZLQgF6MT26JUSXr=6__A@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: E8fLoKd3GRldvKD4lWE-oP5ev8e0zCagZcSerJPNrI4_1757342367
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 79FD5100005
X-Stat-Signature: g5uape6jsshaxh6bbicao4ommdbj39wy
X-HE-Tag: 1757342370-600857
X-HE-Meta: U2FsdGVkX19an1ivQJpofzxq8VlKHy1oNgHXONVagsCExk9+IrPGGGI5NtH+JFHtn0ifEg9UfApBidx+yelfXFfGr4Pv7Fvlolq8TzoaWtKxeEopfxaPhvvV4dURM802DUv89m+MwY/8RO/43FhE6j/mm+IBRN4hdNO6syS0k80N7eQJjWiBypYXlq/MvMdy9sBIwtOyQwed2bJAlBijeFCKxWmY8T9U4xeuGXo385qqoByyOEzV8KPhK5/tP6qxDXQwkEuHihjs1f48z7Xj13BZHm8aiL9REtuiZVg3n0W79c2vrtDt1K2yiSremaNPeIRVOPLH1PibJOvDEmXktb04IFaBwleaSV0cepjqqi0Q4PU0yT8VJPjw1P7IViUAabapwc8C25Rc5QeSLIdIYTNxWytvvAfm8i/Rbwj8xNK2kpzd0I/Kh5wqltdAmsMEQrePfSiV+mDOElTOH+xpbL+QkbeDnWI1jV63iSJ3c5bLU0Z4uMdnqo0aOIAI7BVjCAhW9qxSi3As3pwUuZnjODFd0x/sdOkmhH7XFyfZ6gv/hQMptADG/LlY+AvAlrVxd0SYmYbzIjOmupWyDq34ETL8bIcphuj7x1N890M7ASogLY31zT+4EHrHeHaa4XypgWK+J9j5h4QZWoiJzj2cf2xH5HTCtwR5LBVcddlD5toHgZDLcuv7Tu6vKiEvYrgn14fcnrGsZpxeuGZzt4pDt316wW1ihDRkM140rHcWMqOwv1ss7G7Pf3kNELsU4dSLv1UlUvctLSImTAn2P8LxaQbyJBxl0s4pLQhbGZTZV+WfZeElNpR80dYxeATCbWn7cE+gPS5567hffWHOC1hOkL88ujiyLa3robdF7k1MWjoxmJIjtTSvFMNff+7VwynzbS+zJ6k9AUHFcfiJCstLgBI9+XiJyteAaxG7Z3VL7mAsB8J06ldiQqEyMUKwVrvDl2JfsadgV+ObhtLNuQf
 uLhUNeNQ
 LB+/fk693uQFbnGhrzQA3aEAuadjcUmsg5HguDoHXhRLmANlBDoEiC1bnyY8MrYSUji4QhDyJVW4muMnY+B8EqwhejLX/luADotpF+Qm+olsMrslJKYSk8nzFOU5S3nok+J6n4W04/EV//+mFhxF5MF1XbIPIJyoRs4DBpg8DmwRt/NZZlwjXBAsfm+XqQqKg2PUm4Rc0sYiRIGk+aZ6hHuQ2ECdaLU4w1d+3cPKM1M5QYkWy7isCMC6NuR48klDVQTBnRTtzQ+kFxkJyDoWGuZP/P4emtI0ss6MSXkDSckDtjC1f7GRedDvzpMU/tlm9hQ9vSc7GgHLc2tzaKQuDpQXVhIeSPl6qBjtDk6Mpwckg5GjaMAc8NNpe9LVVBeptnMftOh4EFXON0VrmwTk4qomL2saUDqGP6r+lgWiEu/A8WORyHmp2y7/is9hzME+DtETH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.09.25 16:20, Kairui Song wrote:
> On Mon, Sep 8, 2025 at 8:35 PM David Hildenbrand <david@redhat.com> wrote:
>>
>>
>>>
>>> +/**
>>> + * __swap_cache_replace_folio - Replace a folio in the swap cache.
>>> + * @mapping: Swap mapping address space.
>>> + * @entry: The first swap entry that the new folio corresponds to.
>>> + * @old: The old folio to be replaced.
>>> + * @new: The new folio.
>>> + *
>>> + * Replace a existing folio in the swap cache with a new folio.
>>> + *
>>> + * Context: Caller must ensure both folios are locked, and lock the
>>> + * swap address_space that holds the entries to be replaced.
>>> + */
>>> +void __swap_cache_replace_folio(struct address_space *mapping,
>>> +                             swp_entry_t entry,
>>> +                             struct folio *old, struct folio *new)
>>
>> Can't we just use "new->swap.val" directly and avoid passing in the
>> entry, documenting that new->swap.val must be setup properly in advance?
> 
> Thanks for the suggestion.
> 
> I was thinking about the opposite. I think maybe it's better that the
> caller never sets the new folio's entry value, so folio->swap is always
> modified in mm/swap_state.c, and let __swap_cache_replace_folio set
> new->swap, to make it easier to track the folio->swap
> usage.
> 
> This can be done easily for migration and shmem parts, the huge split
> code will need a bit more cleanup.

Right, but it's probably worth it.

> 
> It's a trivial change I think. But letting __swap_cache_replace_folio
> setup new's swap and flags may deduplicate some code. So I thought
> maybe this can be better cleaned up later. So for now I just add a
> debug check here that `entry == new->swap`.
> 
> And the debug check does imply that we can just drop the entry params
> in this patch, there will be no feature change.

Well, the current API as you introduce it here is confusing, as it's not 
clear who is supposed to initialize what.

So better to it cleanly right from the start.

> 
>> Similarly, can't we obtain "mapping" from new?
> 
> This is doable. But this patch is only an intermediate patch, next
> commit will let the pass in ci instead. Of course the `ci` can be
> retrieved from `entry` directly too, but it's the caller's
> responsibility to lock the `ci`, so passing in a locked ci explicitly
> might be more intuitive? Also might save a tiny bit of CPU time from
> recalculating and load the `ci`.

Well, no other swap_cache_* functions consumes an address space, right?

-- 
Cheers

David / dhildenb


