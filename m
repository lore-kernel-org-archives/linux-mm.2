Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F33ECA0EE0
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 07:11:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB2B18E01DB; Fri, 15 Aug 2025 03:11:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A64F68E0002; Fri, 15 Aug 2025 03:11:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 978C38E01DB; Fri, 15 Aug 2025 03:11:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 880988E0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 03:11:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3851B1A08C6
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:11:51 +0000 (UTC)
X-FDA: 83778122022.09.56642CD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id CF4061A0002
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 07:11:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gCHyF6wz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755241909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=64tD7SquxlFNDEbC3pNsIE3pob3nz1tYkUOwDAu4r0E=;
	b=XhfvM0BmTr9562p75N66uPL8prnLd2P1WllaBa8jdUVSZ1bBFpKNDn3gnpwkZvdJcS8HrY
	2T8GvTWholO/iBUYWbk+EEQp1aggNLAgfG6fMmw2AjDWmawl8D0EKldcNJO469mpisxbfD
	aP4yrd2VggXDUzXnKm+ZkQKYBENeCIU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gCHyF6wz;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf19.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755241909; a=rsa-sha256;
	cv=none;
	b=i4DFJH/EQquiLua53tgVwRB+NwCAXjucXWewxTL6f5dBwJHpD25HU58iBTZTkV6TVX1s1S
	U0T1/0JhPMKy2J27LB9a77tRwJ0anQA+xpsDCJOO5UcybMyKyKo+KRUd+QHAPkPSyi8S0s
	rukKGP5Ap9aqYLkt0B84wVNxxipTUAw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755241908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=64tD7SquxlFNDEbC3pNsIE3pob3nz1tYkUOwDAu4r0E=;
	b=gCHyF6wzX1GAwCX0rh/9Vh98zPD1SDEBXBo8h/JlCDcnCJoONKkLXC4Tn0KibC3pXeJLbj
	GqB4XVgjMX8uuzdZD1fdT/v/076PDZnUxdRsnzYUPehcyvThy7ODm5WUnPRFIKY4Nt7m6m
	krxp5DQvdm7EMXK0nRYrXS7SxYg/gdc=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-Dxz2aB4eM2aE_48WlKKHiw-1; Fri, 15 Aug 2025 03:11:46 -0400
X-MC-Unique: Dxz2aB4eM2aE_48WlKKHiw-1
X-Mimecast-MFC-AGG-ID: Dxz2aB4eM2aE_48WlKKHiw_1755241905
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-55ce526c3b3so657649e87.3
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 00:11:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755241904; x=1755846704;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=64tD7SquxlFNDEbC3pNsIE3pob3nz1tYkUOwDAu4r0E=;
        b=dFdO+u/R/bTHDRO83R1+wm2WYPA2NOMgvm5bGmIN/UzZMug8z0ZS9uf/0jj1xWOLs3
         e03HsN9Dh3OMnsikd8M9OlU6z5idg7fEdbRUffKOmHKvBvS0wB0rodzuTd5BFd4w0nBb
         K7s0WIoKHgbPVGFfOZu/OxG+hUCg2qiyK8yevmV0w0zE2USDLBh78zWMGdyHd3O8zHDl
         VKnu4YocFZNVuMzbWrZv6X+t4Uj9HF9dZSghp+bMQpMmy8cMwDKN7E01bsDx0BPei/KW
         Imo1gipf4EP87cNUxafookzS3F3MRMT/3HC8m51rqagbya04+m+jafCYY3mFgsPyOpHF
         TBoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXzYvguv9MgcNW9V3jeNam2V3xy0U5Rx2WIznu4j5XNHqooSJI46REkffXD2k12reU+jzuZ1LOJWA==@kvack.org
X-Gm-Message-State: AOJu0Yw2Ws/qq+PhZKn5coKIpAzlwgl1EWah9I/gOkPhkAdBHU1esaw1
	BBOpBKylX0qPZTViD6Pw1G2s5xTZq+u/1sKOeDc1PhlvMI2z2PgVRuUKKuQzIBsbzjycRPvCJhj
	ZxsQS2zQbEyt9TxVZiyO8MXRQeSvDNPcHF+nNgODLRkJDojTLjRY=
X-Gm-Gg: ASbGnctte/PLSlQoNVd/eylyL2ETcxwShEfn5XxMb//GB0/QrSn5H8DjWQCVXTF68Q9
	lO5kbqc9GzFmOZFMI0XbtZJj6mrUXazr+7dlPo6yZ5jCZoPgmTKuJHy6CoPILbK/YTbkRzvSDWA
	fjTWli3/PAtyuoS1fyhZEoHRo5y7m8Zsd7/GbF7O9C/FBWWFVKUck5OikgdMiR3Kuu4BDqzwaGL
	1CxB0O3tL7dRYFcrvRhIssvM+B3vLYGBufRwXv2S1lSe9dV/jxbDHK/zaSCEchANPCxCsn7LzPJ
	onTzlMLSVvRuWFsixfEOIujob+BPx0tvr8+8spuJEWc8DA535b0ZYwAps7riRwrUpQ==
X-Received: by 2002:a05:6512:3da5:b0:55c:d674:4a1d with SMTP id 2adb3069b0e04-55ceebae268mr322972e87.56.1755241904426;
        Fri, 15 Aug 2025 00:11:44 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG6vMtE71fmtMMpJ1PZZijtMSMe5cHVNFNkTB26zZbYwP1tHYjcj98dWZzlOVlyT7bdSoGmUQ==
X-Received: by 2002:a05:6512:3da5:b0:55c:d674:4a1d with SMTP id 2adb3069b0e04-55ceebae268mr322955e87.56.1755241903918;
        Fri, 15 Aug 2025 00:11:43 -0700 (PDT)
Received: from [192.168.1.86] (85-23-48-6.bb.dnainternet.fi. [85.23.48.6])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-55cef35a187sm129113e87.46.2025.08.15.00.11.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Aug 2025 00:11:42 -0700 (PDT)
Message-ID: <1e854923-c746-45ce-9f56-1c01a41992b3@redhat.com>
Date: Fri, 15 Aug 2025 10:11:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/4] mm: use current as mmu notifier's owner
To: Alistair Popple <apopple@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, David Hildenbrand <david@redhat.com>,
 Leon Romanovsky <leonro@nvidia.com>, Balbir Singh <balbirs@nvidia.com>
References: <20250814072045.3637192-1-mpenttil@redhat.com>
 <20250814072045.3637192-3-mpenttil@redhat.com>
 <20250814124041.GD699432@nvidia.com>
 <2da9464b-3b3d-46bd-a68f-bfef1226bbf6@redhat.com>
 <20250814130403.GF699432@nvidia.com>
 <67b6e041-4bea-485d-a881-cc674d719685@redhat.com>
 <20250814141136.GG802098@nvidia.com>
 <c7bbbbc8-b9fc-40f5-b86f-e43b9a85aaef@redhat.com>
 <20250814172018.GJ802098@nvidia.com>
 <2982b6f1-7c14-46ef-afb0-7951f7cdc2aa@redhat.com>
 <pk4yq5kt5csh5yqd7f2s66eux6yvluxv3rcwrskaagyxcgo34j@6wei37bgqlye>
From: =?UTF-8?Q?Mika_Penttil=C3=A4?= <mpenttil@redhat.com>
In-Reply-To: <pk4yq5kt5csh5yqd7f2s66eux6yvluxv3rcwrskaagyxcgo34j@6wei37bgqlye>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: G6VrSt-A-6s8yUBIbpTOvrYWkRPmpJ1W-iit8YUwyO4_1755241905
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CF4061A0002
X-Stat-Signature: crf5rws44jf5wngkmscmwa3sdzs51foe
X-Rspam-User: 
X-HE-Tag: 1755241908-400011
X-HE-Meta: U2FsdGVkX183CsRk/vlnSmVBTuVrejpgm9ShDhU9hnXiG3RDcXHCDaAPLY6wurShYj7fe5B2ATpFMIwdK0NEPrDk16Xgi+Cv0d3plU+jIMTLlLEwd4K2bZ5pKA0kPkxFWazeEZx5cX8DOsqApytjAuXA3W4BV0Y9Py6V2TQnY0QJm/kSt4sycWi05xpfdkXIUS8Ji0Kk96YqXHH/SCi/+DLv/tui3Mq2ddDphoOcB3J8+xXblN5PxRcXSFAI9YakejYWQmQC9BNcntQtwQY6ezkeqA8TsrZ5D21wOqGYBrEAgKSdeJND3aKeaSkz1cLFc7uY/fu2T8INEnnX3nSbIyZnnH9lIM8VY7c8TLeKL2XphmP++dtuCjeBO5ltMXqAaR57hKm/JelQH5e+ekbQC2Hbliex3OayMO3LQlnd6udGVgLjXyZulU8uCZNlwl1SVNJ0KyQHncCZUyz0RYbSfWVkIyPizNyjen0IkRlWVThXJrPD1y3Ig17pbdmyxbgBh/bA99Q64zb53iakPvSF3Hx/tcFEG1cNsnCNe1myyA0XvT/x9nBF4UTIRiHcHTwuUT3iNiDpg6/S4/9zn0gKAnN7Ca3WyTq9wawkpa2m+WR8hPajFldHPEykywFppAHrHF1Pi8qwyhEfkV5jsENFLDJi0zb+fwz1cXon2O2Ng8YgN0CJ8lDFPzcmBsbkNoNY+yPeSN0ZsqUAAG0OkbV9Gn2pY7m9V9lzsXIj8U7CxsZtlQkyazeQo7LeGVylz0R6Je6vWKRg3uKFzfa+/34+jCsSOrnXZ72bJ1T1kr5bF8fn0Fcd3BBeFAnxyVbY9uQAIJRC7HhInBesq88Uq1KwNpVLZ7vDh04Yb+Y9NPIOTMFzfNyKI/DXRY9c/RAe2jJc975K5h/BzPKqhK+8gWjnbkNY4hyi+ab6omdlUzk51xZl+oZJjVsX67rD47zBX6vdZDatEEsXBa1trZqf8CM
 +sh9GO+p
 Cxf4mw2LKEkZxPHqkofGFRtVjsEOY6W+VqBQ0KTBlJ43pQH5pcn9/LtP5OKSiatR1HFmMvakA5cCHHgqe7VxkuR5npGOHwvDA2exEtC0UBMXCb+N9sLrMGcLt/pXV0DjvEURZsuHtJ33mDbsSZofR1HKvXkLxuGOpns/FSoKk+5e/V62C9CtokNL8mqTFQ3PY2XPDfdPsK9iYj3vL4K8UHyvRQBXIh+itbxvI02aYJZzaOkmFnPuwoYLQ3bViB64GBfdpEpGbWlvdQHZjXULi8x1bssvwyoclrjGjFnwXvMJAAFHdR1Wr7dhephOBlZfGELGB+zPOhDCZttYuubEeF0B6UEyEY47l2y9Ghk9Lq1IJS58behzTaxA+QNE5IcORm27MRazJZxx7zFsvw+HNHY2JWtTXqvz0UwHev8h+k1+gXH+1T7IgJQKM1Cs0PvqXGGoSWnN7hOsvxbyQhIoikwoXtqPdh4c5JaQqw7spOmCXNwK+QE+J1bLTH6jjbjKBZlBX6YLaBvteZPtxvj0pk8nQYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/15/25 08:23, Alistair Popple wrote:

> On Thu, Aug 14, 2025 at 08:45:43PM +0300, Mika Penttilä wrote:
>> On 8/14/25 20:20, Jason Gunthorpe wrote:
>>
>>> On Thu, Aug 14, 2025 at 08:00:01PM +0300, Mika Penttilä wrote:
>>>> as well as hmm test module with :
>>>>
>>>>          * Ignore invalidation callbacks for device private pages since
>>>>          * the invalidation is handled as part of the migration process.
>>>>          */
>>>>         if (range->event == MMU_NOTIFY_MIGRATE &&
>>>>             range->owner == dmirror->mdevice)
>>>>                 return true;
>>> If I recall this was about a very specific case where migration does a
>>> number of invalidations and some of the earlier ones are known to be
>>> redundant in this specific case. Redundant means it can be ignored
>>> without causing an inconsistency.
>>>
>>> Alistair would know, but I assumed this works OK because the above
>>> invalidation doesn't actually go on to free any pages but keeps them
>>> around until a later invalidation?

Thanks Alistair for your deep insights! 

> Right, the pages don't actually get freed because a reference is taken on them
> during migrate_vma_setup(). However other device MMU's still need invalidating
> because the driver will go on to copy the page after this step. It's just
> assumed that the driver is able to be consistent with itself (ie. it will unmap/
> invalidate it's own MMU prior to initiating the copy).

And reference is taken as well in migrate on fault during hmm_range_fault
if migrating.

>
> In practice I suspect what Mika is running into is that the page table
> synchronisation for migration works slightly differently for migrate_vma_*().
>
> Instead of using mmu_interval_notifier's which have a sequence number drivers
> typically use normal mmu_notifier's and take a device specific lock to block
> page table downgrades (eg. RW -> RO). This ensures it's safe to update the
> device page tables with the PFNs/permissions collected in migrate_vma_setup()
> (or the new PFN) by blocking other threads from updating the page table.
>
> The ususal problem with this approach is that when migrate_vma_setup() calls
> the mmu_notifier it deadlocks on the device specific lock in the notifier
> callback because it already holds the lock, which it can't drop before calling
> migrate_vma_setup().
>
> I think one of the main benefits of a series which consolidates these two
> page-table mirroring techniques into common code would also be to make the
> mirroring/invalidation logic the same for migration as hmm_range_fault(). Ie. to
> move to mmu_interval notifers with sequence numbers for migration, perhaps with
> filtering if required/safe and retries

Yes with the migrate_vma_setup() and collecting removed, the firing of mmu notifiers
and "collecting" are integral part of the hmm_range_fault() flow, so logical to use
interval notifiers for migrate also.

I have removed the commit with the owner games. I studied it more and seems it was added
to mitigate a bug in an early version, which led me to do wrong conclusion of the root cause
of the hang. That version had unbalanced mmu_notifier_invalidate_range_start()
after returning from hmm_range_fault() with EBUSY (after done a folio split).
With that fixed, driving the migrate on fault using the interval notifiers seems to work well, 
filtering MMU_NOTIFY_MIGRATE for device for retries.

>
>  - Alistair

--Mika



