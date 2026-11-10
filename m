Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 667A4606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 03:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=TZZwQwt+
Received: by kanga.kvack.org (Postfix)
	id 4E6686B05B3; Mon,  9 Nov 2026 22:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B7306B05B5; Mon,  9 Nov 2026 22:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D11B6B05B6; Mon,  9 Nov 2026 22:48:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 09B856B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 22:48:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 703FAC0878
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:48:30 +0000 (UTC)
X-FDA: 85417827180.03.2F17522
Received: from out30-97.freemail.mail.aliyun.com (out30-97.freemail.mail.aliyun.com [115.124.30.97])
	by imf26.hostedemail.com (Postfix) with ESMTP id 515CF140003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 03:48:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TZZwQwt+;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794282508;
	b=lzsJvsmx4ZPPh2o/wQjmsI6jTOEvv37hJyMZK4cl7RnEGeJyNkVkYhBupcxuRKvz3UA4Bd
	+u7DD6lUcvQ9fQrdGEANjMwQgprG0vUtpeAi+dfABSgW96C+d3V20ZoKLjFEM1cS8oTCjw
	KztyQVXoLWT7cnKwbl/SCqU68p8Dnvk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=TZZwQwt+;
	spf=pass (imf26.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.97 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794282508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1F5tVop/gxIp5o1dtKUD1SVWMDjQ1cisNQp/bAJJCQ=;
	b=K4A2F++EJuvdJhf4Ryaet7vjB/Gi3dSbT/e590vhbLAz3tsIJhioECG4Gykl2nJT5zw54y
	0lKeuSi26xyGnpEEBYC54e5TM9d1PK1dNfBePegxUTrsu2TyXNEg7+PWqn+4Iq6oLN6Byj
	bBuWIaZvPh5XMkFTQPJSvMKgxCAXLCQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794282503; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=O1F5tVop/gxIp5o1dtKUD1SVWMDjQ1cisNQp/bAJJCQ=;
	b=TZZwQwt+NAoz91JKVCWiCvO76PL/Yk/6lij36/K0Z67ZV/8csL8KVCKC9yaP1srsRG0yzK94GFilkIM2jqCQ7Eer43r54KM0p0FcFf3LkiShO9DJKMG3SN+PgunlMRaWyAAlwsdFTt5GzKgWdmyLBKx+qXkBhrerxQ5izxKOxk0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037026112;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0XETt0zg_1794282500;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XETt0zg_1794282500 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 10 Nov 2026 11:48:20 +0800
Message-ID: <3819fbff-d605-44ad-8217-b7d07956fee8@linux.alibaba.com>
Date: Tue, 10 Nov 2026 11:48:19 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: synchronize with PTE table reclaim for all folio
 sizes
To: Barry Song <21cnbao@gmail.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
 Pedro Falcato <pfalcato@suse.de>, akpm@linux-foundation.org, ljs@kernel.org,
 riel@surriel.com, liam@infradead.org, vbabka@kernel.org, harry@kernel.org,
 jannh@google.com, lance.yang@linux.dev, qi.zheng@linux.dev,
 ayushr@modal.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <affd6da4e8d0de1424a4e0b3bafcd1324dfb6c97.1793847060.git.baolin.wang@linux.alibaba.com>
 <auxqWxUfRVvxnk_n@pedro-suse.tail5790ac.ts.net>
 <44740e38-77ae-457e-97db-d6e0a0149dc2@linux.alibaba.com>
 <4a64ea17-6ac2-406e-a432-b82c481a4f84@kernel.org>
 <a069e3ca-6bbc-481e-acec-5ef21855b9ec@linux.alibaba.com>
 <CAGsJ_4wGQ68vEhCS=6CAAr9K4O3Q2fazjpP8QSK2Zs3r6R4Wfg@mail.gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <CAGsJ_4wGQ68vEhCS=6CAAr9K4O3Q2fazjpP8QSK2Zs3r6R4Wfg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-19.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,
	USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 515CF140003
X-Stat-Signature: ecwae45c8gk1ja571q9ofx6r9x66m4y6
X-Rspam-User: 
X-HE-Tag: 1794282506-239849
X-HE-Meta: U2FsdGVkX1+ZtnAtioYi0pyFidghRdAcAPzBu4m1rRGeP8JvjwfEzhHigMk2K8pgRyOvThXNbeGLXApGNsZ3gkkA4sXOqN1XfJ32APWPe7CkIT0GrSaibKez+NiAKDK2cjOBv2P/Jipcb7SnFk1VelgVbq65kwTKUVXgTNdrSzosAWUj+y2CHZ9E9GTj6laLFtlqdyxrDKckGZiwF2JDZydEyHTULjflvFkg5QDitPNQEd9KLpoT6h+v1JOPrN2xv3//pfGr5NxivBnxv5D1bKXHOTkBwhDLqhhhxvHYHE51M8d3wsy10dAPKVEoZS90CM68EuJccaM2GaKYzFrb2Zwzf3CPt91c1lhkQCjxa7Uq17I141Y6TGibUzqPIQw9jqhpDK3Q6wxXQWYKLWoWVnMYnAzS2ftMQ2/coh5aywF70bDi0W1Ey0Kb7zZNiOR30QDWMTe9HKY+2fVv9Q9CdH2Z02OcseD3KnhfP9GUCTdFMCs4mKkoOdY950VzFeJtmlak50DS/tQlUt+MhGFYbsi6k0Fr8Mo+NBuZtHVwiobVQTCcLWJF2q6EUnBVhHD5qf/8YwyJ8hV4iLNhGoqbMwvfxRDKsYdFk7n2lcEhBHh48tCV/UYbnkeCpAzU/wV2asQXKi5EzqjdEA7zuoqXAIMpLQq5a/tgAWztZI4SghuubkRAu3lV3BJkA353Nis8jc8C4FkbGQbmf0aVbC8vot9iZJXdEgfu2OXGmHYpUYsR1fSZNyxsJ6mfct1rbLotAXYxP1K1EjLc+y2QTE0W2SKLvHrNHUAPfFh6huUbXtrhOluYP/ZHOsFpRkDBiA/c70EEcVE64Uyx3PYxApp0Hfh+W61qbD/2LrrVgq5w/eUi9Z4ETp7sHrtylyQmKesM2b1Z9+amHTVybN5JTGsWZdZG7n4tTghCI1zp90jPlbH7qx1VF8sJa0YdFhYZrLKh3dhrEhMmlqoraIeXViS
 vXv/IYLi
 KAaitcmAQYt4TTcQb8qveJwg8hSJWxZet37kEZpv9OmnQaZg3sMfVBd49wcFCCCXaZQbhL1+O6fUbAB6TxigvrtB877iCP9j5hai52/sYFYDUWsVegV8SKb2hJww+a9htuykzlyYJdP0gHczKVjeRT/fWbZgT3ilsxS376jqRqVTIaRqq2PysDqDUf5uwvVQ21yYdZTM19Sy2Z9RMImL8LOLn2wsTnnkIFZDiiHjK5XWGAIYvbuBUGCV6u4pufP/DvEdT6Q3Z9pMuTBZjG0wUb3CtHNGton2NGo1D+1mOtfpleERdPvPt0UK0qRw4u2qIxijHASZfg7MPONA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/9/26 12:27 PM, Barry Song wrote:
> On Mon, Nov 9, 2026 at 11:42 AM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
>>
>>
>>
>> On 11/8/26 3:58 AM, David Hildenbrand (Arm) wrote:
>>> On 11/6/26 03:12, Baolin Wang wrote:
>>>>
>>>>
>>>> On 11/5/26 7:37 PM, Pedro Falcato wrote:
>>>>> On Thu, Nov 05, 2026 at 10:56:28AM +0800, Baolin Wang wrote:
>>>>>> Similar to commit 243cf1f67b36 ("mm: memory: fix truncation removing mapped
>>>>>> folios"), the '!pmd_present()' check in page_vma_mapped_walk() can also race
>>>>>> with concurrent page table reclamation via zap_empty_pte_table().
>>>>>>
>>>>>> page_vma_mapped_walk() is used by many functions including try_to_unmap(),
>>>>>> try_to_migrate(), folio_mkclean(), pfn_mkclean_range(), remove_migration_ptes(),
>>>>>> page_mapped_in_vma(), and mapping_wrprotect_range(). Except for try_to_unmap()
>>>>>> and try_to_migrate(), the other callers do not perform post-walk accounting
>>>>>> checks, so the race has no observable impact on them.
>>>>>>
>>>>>> For migration, the race can cause unnecessary retries. For reclaim via
>>>>>> try_to_unmap(), the race can cause failure to reclaim a folio that is in
>>>>>> fact already unmapped (as shown below), which may lead to unexpected OOM
>>>>>> or increased refaults.
>>>>>
>>>>> This is very handwavy. Do you have numbers? Does this actually make sense?
>>>>
>>>> This is hard to measure in practice. But in theory, if we can't reclaim
>>>> cold large folios that are actually unmapped due to the racy checks, it
>>>> could cause cold/hot inversion (e.g., in MGLRU) and increase refaults.
>>>> In extreme cases, failing to reclaim unmapped large folios could even
>>>> cause OOM.
>>>
>>> Yeah, but the question is if it really matters in practice.
>>>
>>> I agree that page_mapped_in_vma() should sync properly, but the current impact
>>> might not be as severe.
>>
>> Yes, what I meant is the theoretical impact. In practice, this race is
>> not easy to trigger with no real reports so far, or the impact is tolerable.
>>
>> But I still think the fix is needed, as it matches the purpose of the
>> TTU_SYNC flag.
> 
> I assume the impact comes from LRU over-protecting folios
> that remain mapped after try_to_unmap().
>                          try_to_unmap(folio, flags);
>                          if (folio_mapped(folio)) {
>                                  stat->nr_unmap_fail += nr_pages;
>                                  if (!was_swapbacked &&
>                                      folio_test_swapbacked(folio))
>                                          stat->nr_lazyfree_fail += nr_pages;
>                                  goto activate_locked;
>                          }
> 
> folios are activated -  over protected in LRU.
> 
> The racy window should be quite small in theory, so the
> impact might not be that severe. There is no evidence
> that it could lead to OOM.
> 
> For large folios, the impact could be greater because
> we are over-protecting more memory, potentially
> increasing with the folio order. For small folios, we
> are only over-protecting a single 4KB page.

Agree.

> So perhaps the current TTU_SYNC flag for large folios
> is reasonable. Baolin's patch to respect the flag,
> which currently applies to large folios, also seems
> reasonable, as long as we don't extend it to small
> folios and introduce regressions, possibly in
> map_pte()?
> 
> I'm also wondering whether we should downgrade
> ACTIVATE to KEEP, which would allow racy folios to be
> reclaimed sooner.
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 071a6eaef1a1..726266e49533 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1353,7 +1353,7 @@ static unsigned int shrink_folio_list(struct
> list_head *folio_list,
>                                  if (!was_swapbacked &&
>                                      folio_test_swapbacked(folio))
>                                          stat->nr_lazyfree_fail += nr_pages;
> -                               goto activate_locked;
> +                               goto keep_locked;
>                          }
>                  }

Sounds reasonable to me. It's also not easy to measure the impact. As 
mentioned earlier, this kind of racy check scenario probably doesn't 
have much impact anyway.

