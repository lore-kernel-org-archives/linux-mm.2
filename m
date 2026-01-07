Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92E92CF6BE4
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 03:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2BC16B0092; Tue,  6 Jan 2026 22:31:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD6256B0095; Tue,  6 Jan 2026 22:31:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAE096B0096; Tue,  6 Jan 2026 22:31:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8ECE6B0092
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 22:31:13 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6AB8613C9DF
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:31:13 +0000 (UTC)
X-FDA: 84303742026.07.E8FD1C0
Received: from mail-ej1-f68.google.com (mail-ej1-f68.google.com [209.85.218.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id 417B1160008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 03:31:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BJh3p/zu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.68 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767756671; a=rsa-sha256;
	cv=none;
	b=e1ntXepw3eJ7/vQt3KmOSdj/cPFqF0rglIMYWIhz84TP6ZSZPcLLkM1VxyJg7eGrZs5vgK
	PEf9dBqf6SRNQP5yd2lBHGXCz45JNojb84bnS2agdiXgP6KMRuGgbWkLPD8PIRYpPY5X0M
	Xq+A1k4t8qGoLSrVsVJON58wRt45lQA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="BJh3p/zu";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.68 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767756671;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ptUxQkZ+K9ShX84WxQzr80zRKVliAxBdsbmpSy77G1U=;
	b=kgTdGQPzmabh7KULpCQv+sV3f0fvB/xj2Tf+YNiagb582VmEXdgyuDnCs8OQWym3quNPXr
	jFwLFqW1lhaNgBnyjwHGc+17CEdv0GYCjc0ZAEjxmkr0fcRNu6z+uNMssSsqRPAqeg0SVI
	W06/nFhlY/wkLLnRPoSjITGRWOq3+eY=
Received: by mail-ej1-f68.google.com with SMTP id a640c23a62f3a-b7eff205947so224437766b.1
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 19:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767756669; x=1768361469; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ptUxQkZ+K9ShX84WxQzr80zRKVliAxBdsbmpSy77G1U=;
        b=BJh3p/zuT4VPTVBjUYVJI+b0eXnuKjeDfpEZYq60coLsLjGwmUedtv1KusP67Fu1/S
         PIOARWVmkXdMQCZNye/3JINrEZXHBhbqa0s4bOgn80C7Ybp9Evgwx1rSNdPjTBqlGwmR
         vG96/3QLnRGi5xuYZRx6IU8ZyDCm63bTleceZjWPdrX0Vqn/2fW9fsg/a6U9nKxaKRlv
         QqFlQayyqO9tIMfN2uUipmCJhrJwkAVxBu+NYjQKqBUQL0spXSGd5UzkXYecWIUQArIH
         9KAQeknu2Z8Buhk3evMvkV4PHzMq0CupUJpEa4MBfePESPEedW6qjKKnfQSPTdm0k/hH
         5Wrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767756669; x=1768361469;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ptUxQkZ+K9ShX84WxQzr80zRKVliAxBdsbmpSy77G1U=;
        b=KuDqM3EpgSPiELE+m5XUqFtRSYxex+fAaKJbktl5A5G1Ccm7vMyF9bnV8nsQlvJ+Oa
         zAvFWyScMk8dTHNMbHbbewDkEWMYpfT+TxEfchi5ehJnbZnjr5TgId7knWzQ2mLIb32+
         yoXq8em1PddYp80pf5txivEL/87PMXryrHX9Y+wMGDYr44F8FoS/9z/1E+iJqJky85Ed
         pN5IXLZwGb4cmAAWpgEZX+U53DIJMJmj+fn36TD4SHndkbSB0OiLzXcGdRLBeDuD+bxs
         VSKVMUcRPszW3SMDlisqJMvn4jOMuHhHk1YZjkv5m/BomW12y6H+moOnWH4Mq5ofizMi
         cxqQ==
X-Forwarded-Encrypted: i=1; AJvYcCUoS9nMOsCKBg55laq5t5MaCfhniU6SllFuBZGMCjDeclv2XZc4ke7FrI6toDdbeHFRiAbZvPUlmQ==@kvack.org
X-Gm-Message-State: AOJu0YwMI9SuriykS2cnMd/2WO1KBITcaI8tzNSBlzp53dYPwPmyOWMX
	7P8QLXXGJ3CpYNdjMVPgRaSI7pYeEjth+hspcRB5KdPji7oZAmteUx1T
X-Gm-Gg: AY/fxX7sxm90zUXiXfo43fDj9snk/uE+lSAMmlL92mp9LJ8YpAxWnS7y1t3pGd7JdW4
	jf7GWfKFEht1qfbjdwMM0qqBN0aG5vBT652EPnq0/8kYZzWvRe+OP1+xmZSJ5R0UpQlnaM4gnYr
	cMCYB5c+zJzXemipbDRR5j2a6jg0t+ETaMQ60+muls79vYk7gorOdH6B2zI9sxnq0CvDC+QXp48
	01Tjc2hNQubM/3f1RR6Ey4Wa+WEQbamYZuAVzjrKgJ+V0mJjz8g8yrDva74VQ6SY6ZFWvkxLJ5t
	ar+xdjcvU3N1Xn78xVxYzDCvUOCbcAG6whl8qekF9WiHJpzlnSlXQug9Ej/XKWb8ft1cTkYtX/B
	eeFYZg9rc2T1ksWGEdRgI4v2deCV5JTSIr4f4SC21bXTYhj5YaRteSvyrN49FFOjKKxABSjZHOt
	TgFL8DZ0uKVQ==
X-Google-Smtp-Source: AGHT+IHXrUepqohER4eBi/ltvOeG/vWbcCIBmPjJ/7BGwIJoB6JHs+TLloUHrygj8bn21j4DVZ0kQQ==
X-Received: by 2002:a17:907:72d2:b0:b6d:4df9:68bc with SMTP id a640c23a62f3a-b8444c59fb8mr112453566b.1.1767756669213;
        Tue, 06 Jan 2026 19:31:09 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b842a233fb3sm384401966b.12.2026.01.06.19.31.08
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 06 Jan 2026 19:31:08 -0800 (PST)
Date: Wed, 7 Jan 2026 03:31:08 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <21cnbao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>,
	akpm@linux-foundation.org, david@kernel.org,
	catalin.marinas@arm.com, will@kernel.org,
	lorenzo.stoakes@oracle.com, ryan.roberts@arm.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, riel@surriel.com,
	harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
	dev.jain@arm.com, linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file
 large folios
Message-ID: <20260107033108.4rspmaq26fewygci@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master>
 <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master>
 <CAGsJ_4xfVnPKSPvHYWa1cPK7kZC4F6hKreny9RsKfSCyC4RHuQ@mail.gmail.com>
 <cd626b19-2636-477e-ab01-26380b12d4b1@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cd626b19-2636-477e-ab01-26380b12d4b1@linux.alibaba.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 417B1160008
X-Stat-Signature: xoj6fi7uyz65e1pr1uipopqnzbez9frr
X-Rspam-User: 
X-HE-Tag: 1767756671-634592
X-HE-Meta: U2FsdGVkX1+uLHeTdjPd8a0vCQAtBFBtfHWFA6C2x2LIaLCm4zwofWO/3hQw6D6mwZuEUQw93UzkONmba4Bn7Bs4DUzK//l+PgrhCeDvA6lrR4fvG/m2yft+ftQ3AYk6RuskwtWj6QDjqnE+lLUuq4ObsxcUxJunYl75Qe39CNlJLDJK+ztEJjN+iuW7a9iRTZZUBhwnDI+BLd68L4ihlXKK/ayREGucLuODawJ9Ew1hsYx7efw3AWmNVz/sPD6jJnyxU9dbvpDe1yByTqGyLaz/c2tdd036c25ErRM1PIMhIFmXb1WQE5TYNAJ4PhIjmpsCS/gGIPVVXuJnkf5UiIruPM8TkAXj+aH5QUWL67RDPaxFavmr0rp1Y2A5u9kEynb/EfKfuw0dwAam6AFCeF4LwdEOe52YGqw9EhWFxBfv//UEotDSMoj66r4DqqI9g0Wam9G5R1QgIRliClEbYXje9Kyezd00XdEtw4ryoRROUsiliwHslVlYJzttSw4CgFzJ21CiSi9VRXblyIIzvSkGPFJPWOTLe9GmyJn0Zt0NN8GYp8DbqOlLMyD4srEW7yNVDJf3eAgKZmE1Q9pJ4CkMOtm2OKKWYyzvzmj/ipj1k/rkYja9fpk5qoaR7E99yzq/hT5H7dHwWrnCr1uW+KsjmP7/0vl5EPpLy7nz1sQ6Ij2Kb/tsEpmWy4Y9y4Nc8gW5vbZBL6nXIpsGWK/RpJ1mQ4XPiAejAHl7xPOB911tKxHz1mRnQDI9pMqVTlqLs4QJEl+kRPm/dVI652ZBwAzkOVkHvm+8qoliPDHApsSzChO/9ALM1VRXlM99am34KHzCak/lcDc2dowBgDwGuJFoaVFSozEybYbCQvP33KP97C67LE5IdhV5JYyyCdrT/5Qiqz3ZGH+jvjeYJVviheQFAs16ZgQCbAKbEn8gXp04JQ5P1ojaxc12pXo2Bx271KiA80MxKALQslFa5g7
 SMuDTJ9y
 ECS3Wso35eKkuyDzD9uoHXydDuO93fwo1J9yLohVSIIZA/WIPZ6hLKZCTwe1+8U6JE6gqEIHH6FqOcDbCw+LzNJOmCGA62YWkDq1TdFa+lOgB+IIHHHxwLJwoFRVjfP9NmTWwmy5K2iKPD11Sl3rM4rcGwAzq/Emfs2nklmfszZo0Wm9jXGpTn9G4rdWMRBWQVY8xP0Kt2FhSlQoGseyyCpya2H+dN8kPny8VANy5/Aton+2XtQ5IzHlLm0j2iOWjWYCSt3qzJEJPaszKsBRX6B3BxRVZDIWDwOvsMKi+k0tscMX3qrgdu3UTLXkXIh/j71AlUQNJIZlBuSj1gWmYKIm4kWbq0AKc/VuGi3O5IqKVPnIrFJ3mq7F1/fPm8RQSJ9kJ/KgUujHozMc2kWuGqV4GY/+ss5nJv7CUbxmo5Nfb7VMavamcT6fwbBzZEDf+tL2Pyq3aG3cUWJtAZv288ZEMCvkvaZfvMYi3BoZGotTaKUgKs/5KNjciMVMYoMcLIvqBQkxOoS6+0E3eUrQ7ZvdR4RhrvCdmzQP/QboWkPFoUsS7EgAAtxJkV4STUjmsA6o7Fdzm/Tfl6tAKKti7uT+B/Id1zIe/uas0hC6cODBUkWoQEPG5qRNPOEDp34dDu4OP0x5+LqKlf2sFNijrAYPe94dfn5jrn7k7F9BWrQFFpUwU/g715Kxhx4hehNYWWMyDaDEqkv1O9NHfxN6pWQVyxTcZLPmM+VPvFBzebCMAWS07A1hVHrl3G9WJ11eVJeIaYlXGAyoQ+F9Eb2meykLcbAHzJxqJvwEX8gc2ju2iNvN6T8QjEYETmS1eOqkURr3dxEe0JP/j3nZlRJblcpaRzMeOOXGRjjOIhLk6LrE410n4O3ob1tpBZIo2jiD5oTzbdbVZ0cBYKw+B6sV0D9sGAzxU9147j3X/d4ITVqCmihYIUxi4m4JmK24RKVGlsMOK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 10:29:18AM +0800, Baolin Wang wrote:
>
>
>On 1/7/26 10:21 AM, Barry Song wrote:
>> On Wed, Jan 7, 2026 at 2:46 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>> > 
>> > On Wed, Jan 07, 2026 at 10:29:25AM +1300, Barry Song wrote:
>> > > On Wed, Jan 7, 2026 at 2:22 AM Wei Yang <richard.weiyang@gmail.com> wrote:
>> > > > 
>> > > > On Fri, Dec 26, 2025 at 02:07:59PM +0800, Baolin Wang wrote:
>> > > > > Similar to folio_referenced_one(), we can apply batched unmapping for file
>> > > > > large folios to optimize the performance of file folios reclamation.
>> > > > > 
>> > > > > Barry previously implemented batched unmapping for lazyfree anonymous large
>> > > > > folios[1] and did not further optimize anonymous large folios or file-backed
>> > > > > large folios at that stage. As for file-backed large folios, the batched
>> > > > > unmapping support is relatively straightforward, as we only need to clear
>> > > > > the consecutive (present) PTE entries for file-backed large folios.
>> > > > > 
>> > > > > Performance testing:
>> > > > > Allocate 10G clean file-backed folios by mmap() in a memory cgroup, and try to
>> > > > > reclaim 8G file-backed folios via the memory.reclaim interface. I can observe
>> > > > > 75% performance improvement on my Arm64 32-core server (and 50%+ improvement
>> > > > > on my X86 machine) with this patch.
>> > > > > 
>> > > > > W/o patch:
>> > > > > real    0m1.018s
>> > > > > user    0m0.000s
>> > > > > sys     0m1.018s
>> > > > > 
>> > > > > W/ patch:
>> > > > > real   0m0.249s
>> > > > > user   0m0.000s
>> > > > > sys    0m0.249s
>> > > > > 
>> > > > > [1] https://lore.kernel.org/all/20250214093015.51024-4-21cnbao@gmail.com/T/#u
>> > > > > Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>
>> > > > > Acked-by: Barry Song <baohua@kernel.org>
>> > > > > Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>> > > > > ---
>> > > > > mm/rmap.c | 7 ++++---
>> > > > > 1 file changed, 4 insertions(+), 3 deletions(-)
>> > > > > 
>> > > > > diff --git a/mm/rmap.c b/mm/rmap.c
>> > > > > index 985ab0b085ba..e1d16003c514 100644
>> > > > > --- a/mm/rmap.c
>> > > > > +++ b/mm/rmap.c
>> > > > > @@ -1863,9 +1863,10 @@ static inline unsigned int folio_unmap_pte_batch(struct folio *folio,
>> > > > >        end_addr = pmd_addr_end(addr, vma->vm_end);
>> > > > >        max_nr = (end_addr - addr) >> PAGE_SHIFT;
>> > > > > 
>> > > > > -      /* We only support lazyfree batching for now ... */
>> > > > > -      if (!folio_test_anon(folio) || folio_test_swapbacked(folio))
>> > > > > +      /* We only support lazyfree or file folios batching for now ... */
>> > > > > +      if (folio_test_anon(folio) && folio_test_swapbacked(folio))
>> > > > >                return 1;
>> > > > > +
>> > > > >        if (pte_unused(pte))
>> > > > >                return 1;
>> > > > > 
>> > > > > @@ -2231,7 +2232,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>> > > > >                         *
>> > > > >                         * See Documentation/mm/mmu_notifier.rst
>> > > > >                         */
>> > > > > -                      dec_mm_counter(mm, mm_counter_file(folio));
>> > > > > +                      add_mm_counter(mm, mm_counter_file(folio), -nr_pages);
>> > > > >                }
>> > > > > discard:
>> > > > >                if (unlikely(folio_test_hugetlb(folio))) {
>> > > > > --
>> > > > > 2.47.3
>> > > > > 
>> > > > 
>> > > > Hi, Baolin
>> > > > 
>> > > > When reading your patch, I come up one small question.
>> > > > 
>> > > > Current try_to_unmap_one() has following structure:
>> > > > 
>> > > >      try_to_unmap_one()
>> > > >          while (page_vma_mapped_walk(&pvmw)) {
>> > > >              nr_pages = folio_unmap_pte_batch()
>> > > > 
>> > > >              if (nr_pages = folio_nr_pages(folio))
>> > > >                  goto walk_done;
>> > > >          }
>> > > > 
>> > > > I am thinking what if nr_pages > 1 but nr_pages != folio_nr_pages().
>> > > > 
>> > > > If my understanding is correct, page_vma_mapped_walk() would start from
>> > > > (pvmw->address + PAGE_SIZE) in next iteration, but we have already cleared to
>> > > > (pvmw->address + nr_pages * PAGE_SIZE), right?
>> > > > 
>> > > > Not sure my understanding is correct, if so do we have some reason not to
>> > > > skip the cleared range?
>> > > 
>> > > I don’t quite understand your question. For nr_pages > 1 but not equal
>> > > to nr_pages, page_vma_mapped_walk will skip the nr_pages - 1 PTEs inside.
>> > > 
>> > > take a look:
>> > > 
>> > > next_pte:
>> > >                 do {
>> > >                         pvmw->address += PAGE_SIZE;
>> > >                         if (pvmw->address >= end)
>> > >                                 return not_found(pvmw);
>> > >                         /* Did we cross page table boundary? */
>> > >                         if ((pvmw->address & (PMD_SIZE - PAGE_SIZE)) == 0) {
>> > >                                 if (pvmw->ptl) {
>> > >                                         spin_unlock(pvmw->ptl);
>> > >                                         pvmw->ptl = NULL;
>> > >                                 }
>> > >                                 pte_unmap(pvmw->pte);
>> > >                                 pvmw->pte = NULL;
>> > >                                 pvmw->flags |= PVMW_PGTABLE_CROSSED;
>> > >                                 goto restart;
>> > >                         }
>> > >                         pvmw->pte++;
>> > >                 } while (pte_none(ptep_get(pvmw->pte)));
>> > > 
>> > 
>> > Yes, we do it in page_vma_mapped_walk() now. Since they are pte_none(), they
>> > will be skipped.
>> > 
>> > I mean maybe we can skip it in try_to_unmap_one(), for example:
>> > 
>> > diff --git a/mm/rmap.c b/mm/rmap.c
>> > index 9e5bd4834481..ea1afec7c802 100644
>> > --- a/mm/rmap.c
>> > +++ b/mm/rmap.c
>> > @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
>> >                   */
>> >                  if (nr_pages == folio_nr_pages(folio))
>> >                          goto walk_done;
>> > +               else {
>> > +                       pvmw.address += PAGE_SIZE * (nr_pages - 1);
>> > +                       pvmw.pte += nr_pages - 1;
>> > +               }
>> >                  continue;
>> >   walk_abort:
>> >                  ret = false;
>> 
>> 
>> I feel this couples the PTE walk iteration with the unmap
>> operation, which does not seem fine to me. It also appears
>> to affect only corner cases.
>
>Agree. There may be no performance gains, so I also prefer to leave it as is.

Got it, thanks.

-- 
Wei Yang
Help you, Help me

