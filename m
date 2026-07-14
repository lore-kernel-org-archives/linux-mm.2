Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B20BC4450A
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 17:57:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 113216B00BD; Tue, 14 Jul 2026 13:57:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EAE56B00BF; Tue, 14 Jul 2026 13:57:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0037B6B00C0; Tue, 14 Jul 2026 13:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C21076B00BD
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 13:57:09 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 48A15802A4
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:57:09 +0000 (UTC)
X-FDA: 84988138578.11.1404700
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id D473218000D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 17:57:06 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OqekERnM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784051827;
	b=W55JCJg6Q8tgx+9Lum/BsWIqxU6ShjHHZ/Xwajw2kJ7Yacri0+CybV+VbO8GJK7IORJIP6
	2ZeJrKv04r+3Vc+8mSWLZpsRl99rMELCoh6xygDWnhLDBg86C6u47wvSCJrE8B26E/xaJz
	KPA1nhttXFppgGMcdizoGF5G7YvUWEQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OqekERnM;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf24.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784051827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GiPZIKgYVUVSiAjyu5+zq1YI0UjtcnYBb3hfexOE/0Q=;
	b=jQQpPmi9/L/kkIGj53OCeh/VE9E6SSSSkquHt0fSyOgC0cc1nQzKS55g/HEysZjreI2s/E
	2fquJ+kRQwAz9U9zQdD7wCNM+XClg15Mix+Sdxz1lWXtlHta4PqZnflrA1GhByiFC7lf7r
	+jmDwN0oSXio7jXb3dnWmmun826kTFg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784051826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GiPZIKgYVUVSiAjyu5+zq1YI0UjtcnYBb3hfexOE/0Q=;
	b=OqekERnMIVqy/RwWni69LRFECbvVqA91mtyHI2JoVXY+zOYAtjuoDYt5vZRq2caFgq3/Dm
	jP2yn6ZIsI4bHyWfg3zsDP+mEqxPinkEDygwzvzwCNZzsI+ObjkbEivwad+RyyGeGMHIy7
	o+EklOB391N8OigEziN1haxz6fMrNI0=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-648-Q62PeG4rO4OR25HDKSc-Dg-1; Tue, 14 Jul 2026 13:57:03 -0400
X-MC-Unique: Q62PeG4rO4OR25HDKSc-Dg-1
X-Mimecast-MFC-AGG-ID: Q62PeG4rO4OR25HDKSc-Dg_1784051823
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8ef18406878so79743896d6.2
        for <linux-mm@kvack.org>; Tue, 14 Jul 2026 10:57:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784051822; x=1784656622;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=GiPZIKgYVUVSiAjyu5+zq1YI0UjtcnYBb3hfexOE/0Q=;
        b=Z6XsjbplMThBXqtDsq3X8ecJ9NknhoccH6dSYQgk6chzgUxShYs880QPSVtQDL0Vl4
         eBFWiH0Cn/sTP6uxN3OtOn70lSZ/JJUntefSjSdb6lS1Fun6E10N2sRiet4J6JADt016
         hVqp9HQjixekmZ3hMvYJ+ETtodTGxFssv+ipRscO8lCNiR7m59GjmEppKHiLqDDdKiYQ
         yArBuwNgn6JVFX9sncNYS53Lc4bcWekVWXlfSiSEhwK81Atnv/GYAO946astlBIJlFlG
         JBiuj4+333QPJfCUyGmVr8RR4GvPqvKrT/FIdaVfiDvVZh7vBW+aqE1CP5oPZqDEA6gk
         Pa4g==
X-Forwarded-Encrypted: i=1; AHgh+RoYfjt4jX8BJKAERqRMhy3e59M0k40Rjs2KNP16kAgJf//J3rDEnHoQhUlDlY1RnFv0rdKi3fja+w==@kvack.org
X-Gm-Message-State: AOJu0YxO9F8qUbNkrsvizP4TsdZi08bbrQKhBvYDgdwWs/xkTFjvLctr
	fAEvFlZE0Fdkk2w4w6M2/1jtlkV9mcG4h1aOuSG2y5R+V5NV6+3X1VCIsMg5FMRZxTqMoX95lWi
	y0WacNa5c+8VsVAp/n7I251YirPLpcb5CkF25bzU+aJ/edWMnimIv
X-Gm-Gg: AfdE7clCtFork5ZsqfbbJm4Yf9LJfJc5RO/OSOUz2A2TnbFlnbKhyZtVYWiqzVLGtW0
	hkVso9p5yNlIdt18NayMXjBLdW2agA0qXPLEXsQp1M7vN+jrLRIVpaptec3AqICgxr3YpdtKEPA
	6vwIsWNUw7FX9Xtv2LHglHgG3yPSaMmbQAWLif2jXYvtpZf9KbjLVtPZm4GemN8XzhSWFujiEQ9
	n5kYgDc7BFjyjqyMFysuqAJLrUm528n5Wq1zVn2T7Kv+I8uL2H+Pw9dfCcWc77o1JZ1Hw3rq3Ab
	PeeatoRbZkbUWPZnyxkVablAR4acEySI8BRzOTnqXNaIDTyVSNPMgZlRfUceWtAex7Qp2jD+FgZ
	EDsu1Bgj0GkTTanco+O/QenFuItSC3ZIUqvFp5NritvsEv/zPZ2YhyB7u1mY1D8CfKHgXJnYY
X-Received: by 2002:a05:6214:3a8c:b0:8dd:4979:4b19 with SMTP id 6a1803df08f44-9074c6fa76bmr42057276d6.13.1784051822592;
        Tue, 14 Jul 2026 10:57:02 -0700 (PDT)
X-Received: by 2002:a05:6214:3a8c:b0:8dd:4979:4b19 with SMTP id 6a1803df08f44-9074c6fa76bmr42056776d6.13.1784051822114;
        Tue, 14 Jul 2026 10:57:02 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-61-70-49-81-60.dsl.bell.ca. [70.49.81.60])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd56c4cd1sm173212066d6.16.2026.07.14.10.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2026 10:57:01 -0700 (PDT)
Message-ID: <24432756-29fb-46e8-8d7b-de6e724da958@redhat.com>
Date: Tue, 14 Jul 2026 13:57:01 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/util: don't read __page_2 for order-1 folios in
 snapshot_page()
To: Matthew Wilcox <willy@infradead.org>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Sourabh Jain <sourabhjain@linux.ibm.com>,
 Ritesh Harjani <ritesh.list@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20260708201954.686111-1-aboorvad@linux.ibm.com>
 <ak6zsw5R4Ub8FnmQ@casper.infradead.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <ak6zsw5R4Ub8FnmQ@casper.infradead.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 4ajoKfXpJ1MUZIBSLYG_W5i9tg66Nssm86WpPDlK004_1784051823
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D473218000D
X-Rspam-User: 
X-Stat-Signature: ty5sjk1iwtmk3mpwefr1f4pnqh9j7im5
X-Rspamd-Server: rspam03
X-HE-Tag: 1784051826-92091
X-HE-Meta: U2FsdGVkX1/i+67HKPn9noe/ovFtkVCG4bD0YDHDHkFYEuSZXD3VcGYDm0U6BvA8EuvCH+43i5clkHrIw5tDvYJp2VAqTG1AZX/A4m17cIcv3w8e4SEnEw1nXm2Y+f1U3Ev/UOHu/5xcfyswNwURfzg0NM8X+cZtwVSTPO407t0do3DyTkt9zi+a/i2kfTEAKDfKcffWdWlrqUIC4dF+BZcTD+PFXwoAfvT1HXzvQuXxGvrhIt/UzdidPRXMBEkxewsU04lPy8u4r3eyOWCIoBKtpPoiJne06R8R7POxved1k6Hkl98Dy5YbMatCfeAvAbKDvLLs+0LyuJHC39MSzt47xy0oVgqn3wxrXOR++t6H74BsVTJFnzY4KXiWQ+MFvxfuJ9rrp5ZflipLRC1f9+y6j4TdDQLjKs8oc1mqAPXwkm6QbrwPR9NRQD6vVCPYDZUuL4KY3mPcEaDXuHwcp/zUksydHEC/7jjyJiWzDfUDZAxn6qoRpT6qqPORSTR1pbi7bt72sR3r7iRo8mUthGWf99qgI1y2WOC9mK09iCnHFDuumzmckYpeLT0xNewin6NRZ0HWY5ICHC5Hz/Sd2O2n7uqokSFwiB1y8qv9mDE8V25eYvwD/LgbP/uxR2VzfGYevuRmjBCdsSUy4fARes7m2HH6TG8m2HpYpyTyX2afEH4E+hgp1q8wpZwt6Dn1+BsZnc5xiNChL8XHEXA11xg2DYpwpL1Crz3zJtTl0vUgGxJ7AldCVJG8P376H0Icy0c3+GB+4qGcOM4kDRs8MTR+EahTNi82A675lRrPizXsgQG0qBVJIdB5GnEFTNivrqAqr4gq3vvwf/khCJeBW1Oh5bvZcTggJQcf4YEEco5fb7D9nFHsZhQME0bdBXmyoQ0CDjs05MfyVk3YwYJ9Ew4CqB1SIC4W6cjGYf49miIZvfDuxqJM2QD9Ro2ne5/xKZ1Vxg1f8RkpxFt8BhR
 5vlAfeHo
 ZmtXXh45xJT8HfxBLPzlEDwlji1a48D1kyl4Bdnw+EKY8t3yJOkiARvSP8eQI9KZQpkOVfG8JWkjjEHRTgZHqfm7mFedmADW2u7BEbsMbAB+TbCFgZT63JypBpBDar16KYBuBUoxkcq9X0/824T9GGJA1lgxi11RD8qIWF58xxcJq9J3mwx/Dzky4KwxmB0mMnSRi1Cw1tUdU2Gyuy7hjTSF26ixpN/mWrAMpEJjn3fLN33ZS0+3QH51yDDG0jrCPXUnSOhJ2Pa8rI5xWJJ1NHUX3nArQIKcBKguEFnI0C1XrYiqHc/DX/t9Egz+UqGZ2zrcEmXpKvifHdKKM6yIHpHDw1ZIGTLw9DToJasvdAPreMTU9VuoOfu+a+02GLSiBAhltgVz3ALWBj2b/dJGTu+BSjynXDg/DErikg0kSXOHN95MhjLOqo7dkZXgLvCYx3JBNBB2AFYPPsLOE6g86L2mZM6n66bBnJ+dTcwJ/YFI7WhcYOP2WY7Ipj449vaicM4mZo/tSkdsop1o5wI3CCERGGHNfqQSC4xQwQ9bGnlsT9Sx2Tmtf3kBdlXua4Rezisdu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-08 16:31, Matthew Wilcox wrote:
> On Thu, Jul 09, 2026 at 01:49:54AM +0530, Aboorva Devarajan wrote:
>> snapshot_page() currently reads __page_2 after checking nr_pages > 1,
>> but it should only do so when nr_pages > 2.
>>
>> During DLPAR memory remove on a 22 TB ppc64le LPAR, snapshot_page()
>> oopsed on the page isolation path while reading an order-1 folio's
>> __page_2 from an adjacent absent section (unmapped vmemmap).
>>
>> Fix this to avoid reading memmap that doesn't exist (e.g., a vmemmap
>> hole).
> 
> I appreciate you're absolutely swimming in it, but there's absolutely
> no need to inflict IBM terminology on the rest of us ;-)
> That second paragraph could simply be:
> 
> If an order-1 folio is allocated at the end of a vmemmap section,
> __page_2 will not exist and reading it will cause a fault.

I think having a brief description on how the issue was originally
reproduced can be useful for determining impact and validating
backports.

> 
> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> 
>> Fixes: 31a31da8a618 ("mm: move _pincount in folio to page[2] on 32bit")
>> Cc: stable@vger.kernel.org # v6.15+
>> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
>> Signed-off-by: Aboorva Devarajan <aboorvad@linux.ibm.com>
>> ---
>> v1 -> v2:
>>   - Condense the commit message.
>>   - Drop the code comment.
>>
>>   mm/util.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/util.c b/mm/util.c
>> index af2c2103f0d95..34cb43b3eaa4c 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -1353,7 +1353,7 @@ void snapshot_page(struct page_snapshot *ps, const struct page *page)
>>   	if (ps->idx < MAX_FOLIO_NR_PAGES) {
>>   		memcpy(&ps->folio_snapshot, foliop, 2 * sizeof(struct page));
>>   		nr_pages = folio_nr_pages(&ps->folio_snapshot);
>> -		if (nr_pages > 1)
>> +		if (nr_pages > 2)
>>   			memcpy(&ps->folio_snapshot.__page_2, &foliop->__page_2,
>>   			       sizeof(struct page));
>>   		set_ps_flags(ps, foliop, page);
>> -- 
>> 2.54.0
>>
>>
> 


