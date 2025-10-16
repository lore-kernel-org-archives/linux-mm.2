Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 526F9CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 19:10:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB1238E0013; Thu, 16 Oct 2025 15:10:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A88CE8E0002; Thu, 16 Oct 2025 15:10:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977AC8E0013; Thu, 16 Oct 2025 15:10:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8453F8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 15:10:13 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD7AA1A0418
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:10:12 +0000 (UTC)
X-FDA: 84004917864.29.DF9D0D9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf09.hostedemail.com (Postfix) with ESMTP id 32E61140007
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 19:10:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NjLeukwb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760641810; a=rsa-sha256;
	cv=none;
	b=Lr7TTPquQX3J48rgJE4ngjEIQjM/D5/8JJT1zdgN6o1wSIFrs+gPIX+0i6QpLZZyCX2MCy
	7bBE+8BOeICFayHd8WN7JbOk9Zm6eLM37hbofb8CK/96z6/8wmRjpuOCmsM2ey0olSF+tD
	uw2wVsIV9OpUj0ZcfbV3nsWsUZn059g=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=NjLeukwb;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf09.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760641810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+3AAg05Yf1Z3P5L48FsHnTWstB0ReAZ8G/euj8J0YSU=;
	b=rzPeoUIOcGzwDtdO/L3cPMRG9b+I4mhWCdi1hqmbuyqL3PFY5U3TWltdlYZFPU5u92KPgs
	01KdeHJDfDpM2ApeVnvcdb3CeOj4h5a+UZxX8nj347MHcZKRvcfpljQz6D+ZAmcIJDcWR9
	MnlDGDxcqw/4/PKY5FFP/WeN5JMu2o8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760641809;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=+3AAg05Yf1Z3P5L48FsHnTWstB0ReAZ8G/euj8J0YSU=;
	b=NjLeukwbyEwUSijjrrh3WkN/oVmKT0eU5Mx7mjQtaYMYe6sk6MYR6IlqjLBWBccdSXPs9M
	npELlC/RDxWIfU6PtFYgLlj9tNNg+QGydnECoMMQBOJXdeWUPX4UAyPXGcnrt/TPnpxZzj
	tlW8c3+khb3dYS1ewIG60os4IKvbdhk=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-519-Giln9wB3MVSX9bTfy8ojpQ-1; Thu, 16 Oct 2025 15:10:08 -0400
X-MC-Unique: Giln9wB3MVSX9bTfy8ojpQ-1
X-Mimecast-MFC-AGG-ID: Giln9wB3MVSX9bTfy8ojpQ_1760641806
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46b303f6c9cso11693355e9.2
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 12:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760641806; x=1761246606;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+3AAg05Yf1Z3P5L48FsHnTWstB0ReAZ8G/euj8J0YSU=;
        b=SbydknfjElUfGqWOJxd4GRwC5vhDbm8UEEO6OtRd1s8Ck13E5rEmpb4Z8C7kH1tDqy
         aFgbNDcFe0aPlrjx6cImIjcN43T2WUi7gmO0uAIt3Orij1rDPiT3U1zKlE2Of7o2SLGE
         3TTpeQ3wXHYGZk9bcE9fC51qv8AUD/KBnuXfOMFx8u1VBO6WwiOzXHLUZd3GEX38yVAs
         BtkZdnAb0Pjy+DDF+g4sh760ZXrutIKND7eosA9C8fBdNwFDx79Hc3IeIIXTwSgYU1Ys
         0iTmOYlKUN9cOq75Q/BLv8GfRQ0qhDdmfBuh/6+WTQpJ7lOAUJAalitkZbVy1EHK/VNb
         6keA==
X-Forwarded-Encrypted: i=1; AJvYcCVK178c9P3mDlXm4cSxVmA1fC8wjy8hI+JyXLa0Zdo4FhUTzc3PFUL7VHVL+Ugjuo3q82YlkAjbTA==@kvack.org
X-Gm-Message-State: AOJu0Yx3bVBr8bclxIz03FtcL5aLsCFLu9KynaZ0FSTOfDrR2ED9IhL5
	bioXcjYDTNyJLEqvV6d7onA39HdDNmjef+OIrrbyj1YLFIOYX1ChThvYKE8vSma3D3fl2nK3EbO
	yZ5x7uLp2Gk6VhuPec/yf4Z8TkOI1BTOWhwAJysNTeJk+n3uVBCaG
X-Gm-Gg: ASbGncsaSjX56PD2VVhe38pmHP3RK9BzHJxN0H+A9K9+pkcAqz2Fz6lbr7niX+zk9SQ
	iz3EDNd+NoLIDQzyZ6QqS3wFRaIgwjvu66uiCsq0UjR2hOP+X28cn7F/obtSw0AQgsu6CGepvcB
	WJkw/C0nKGbJN39lbnxC+6/yc/kj8L05XvO73KbwrKfTI1bJNCpHWTRQ6zO4WIC4/shmhILyOKB
	bEWqIfhrykGF+sia790r39ElNjThWtsFvYHwENlK46mVsdoNZaZJz6EJnGJ4HdWLFV0v3m26hIQ
	hSqLzHKfFc4LbfUfDpX6Kx7ZdAblDbVwtfQG4tcJw2T2ySsq0ykWyiuEC297L2oh+o6NFh+vVFK
	JPPSpHrgow0eiMM99mcpfyXcDFhJkJC3wqzfAvs5mm1N6G1qhrkTnbmkoJai3Dp/MQ8wJapfsu5
	vDVfP/jENsWzjaEL7IduBuNbUVAnw=
X-Received: by 2002:a05:600c:3b83:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-47117925171mr12363945e9.34.1760641805971;
        Thu, 16 Oct 2025 12:10:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGc5h2vbpz69OVWKGuaFjCUjxbNEASV+GvR8Na4j9NprkAExd41lL0K2813EC7L3Hmt8vs2XQ==
X-Received: by 2002:a05:600c:3b83:b0:46e:3d41:6001 with SMTP id 5b1f17b1804b1-47117925171mr12363635e9.34.1760641805466;
        Thu, 16 Oct 2025 12:10:05 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4711441f776sm46310535e9.3.2025.10.16.12.10.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 12:10:04 -0700 (PDT)
Message-ID: <e4277c1a-c8d4-429d-b455-8daa9f4bbd14@redhat.com>
Date: Thu, 16 Oct 2025 21:10:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Jann Horn <jannh@google.com>
Cc: "Uschakow, Stanislav" <suschako@amazon.de>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "trix@redhat.com"
 <trix@redhat.com>, "ndesaulniers@google.com" <ndesaulniers@google.com>,
 "nathan@kernel.org" <nathan@kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "muchun.song@linux.dev" <muchun.song@linux.dev>,
 "mike.kravetz@oracle.com" <mike.kravetz@oracle.com>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "liam.howlett@oracle.com" <liam.howlett@oracle.com>,
 "osalvador@suse.de" <osalvador@suse.de>, "vbabka@suse.cz" <vbabka@suse.cz>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <4d3878531c76479d9f8ca9789dc6485d@amazon.de>
 <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
 <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
 <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAG48ez2dqOF9mM2bAQv1uDGBPWndwOswB0VAkKG7LGkrTXzmzQ@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9f8kDo6L7a_1k5BKaIVJPLBJ0xfUOYVaP4YV5q8ly60_1760641806
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6rap3wrgdo3yi7nbsm1jfxkzpip1zs7f
X-Rspamd-Queue-Id: 32E61140007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760641810-938148
X-HE-Meta: U2FsdGVkX18nqfpNX/0ntwvTHkQYKlsr+eAbCiQTtx59naPhyLKvMoPUEjKY4QMf3hraCquqEILJHZCPdAv1ZCcq45sjNwfrJANhgWKClzGDmsh0VuGpQNS8b6Xgy717dxJr5wbe4qVOFjfSxrhG+gWOJ+nN+bu1UwlfJ1pi1V7/6NIAqMt2KYjTXU9ueGRYz5wQPMqqtwvWSyDSvVYbkQJMtKtj5eOKCjBu3sorF7Q/cXBVT8vSuQE76RQ0xDnqL3Rwho2EVHe0BCoVDizmZRxRIn6SiWI8vZimXh/HBTFj9QyE7pxRMxd//8krrog1WkxThayBs65oQxd+RTW6fBlfk/2fH97aK+t0FOI7u5cFhlJUw1rRlFA9qHLKE6q632vobsi1PaoArtI/VeCs2VBLv6OuvVE196xyKrvTUVGM1PV/xQOFUFkRM8C2Gtn8dBjCpsk9VNmGLnJBEeErE03JCakg7SMhtHiL9D6duivGMYhfTcxK/K0S3Bs/yvr/ZdqBxGV/REndKcNyEJJkBDYzhVshsK3qUYSIIILBnMAJbb15LDHHl2CbEX4HeXGCJQfs/AZo2eLqRNHi3ZVIfjf2SxWWhTeQBe484JvooriLHhpaLJBzEWSI+8Xhux4qcqIVIt8zxpUDX8e+lW1F6jhjhaSTWvW3OKsdFx3cynJ2de8cbIRJ+l3cdvoEvwophb16b0eoy5uaIgHJR1VWWOc76PmJmcBO9Nak73W6l6UsWOQgsi7eOCHh55A31egZbly4nJbNx7pilVm5t+8W9M7jbFZVerfcgGNs8nob4HFMk7yNJ0p6qVR85Dc+qxjUvvk1Ah20jMB27rNnMj6vsrYBfOz6fkS4AShiMlNnFuCJyH2INu/Y860uLykBzLjwtFgPCRbFERdu8oWpnHWU9LtjdVCNaB7/UShaQDZixX9uzkP4yagMRUAcAJhNPVl+1Uo1vLBmvaZBTdJxgtz
 pa3gLV76
 QYNcofuvfa0Xn1Ix0DfDQOm1sXqzLyV4psytTFF2GO4Yzlor6JtypOVmWnjNWo8uid4/uARExH84fVGrbb5UIX28rDiL1WOTT9LvX+90DCtcxKfMB4RuuOvbadhBnT2/CsmLmyCYIIhXPnvmY1gG41T8mI4kcC+0mAZQKy6o+UGnVcFGPzgRv3NfGODNXbFZR087Cs9+XQ2YVtPoZM3apbS2ERkNNe8TqCuLHKm5oPOeevbqMB3FZwN5JwkxzjkqxQRo2RZvlasTg74mxDHY1uKmjie84/cJL6o5NVqH7JnTxGZcAK4bK/Yemhjqq8VKrDFGu27nmncUWgoggTRfZAwDd7+yR95cKlc8yCxyWro7eL9GUWnydY9CFCwdqjg02eKXJJjHYXFmGGDhANyeiGMrOVqIBZnyggbH5dQo746I/Aa9Eagd/p7XhpQvgqroUe8Dwm1YH6TvVZzfyRRJlkXyjblgoCH2ADMyc/enjvD2DKTEZ3KUJ2yqNAh81gM0qj13qN3MW09oI9bU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>> I'm currently looking at the fix and what sticks out is "Fix it with an
>> explicit broadcast IPI through tlb_remove_table_sync_one()".
>>
>> (I don't understand how the page table can be used for "normal,
>> non-hugetlb". I could only see how it is used for the remaining user for
>> hugetlb stuff, but that's different question)
> 
> If I remember correctly:
> When a hugetlb shared page table drops to refcount 1, it turns into a
> normal page table. If you then afterwards split the hugetlb VMA, unmap
> one half of it, and place a new unrelated VMA in its place, the same
> page table will be reused for PTEs of this new unrelated VMA.

That makes sense.

> 
> So the scenario would be:
> 
> 1. Initially, we have a hugetlb shared page table covering 1G of
> address space which maps hugetlb 2M pages, which is used by two
> hugetlb VMAs in different processes (processes P1 and P2).
> 2. A thread in P2 begins a gup_fast() walk in the hugetlb region, and
> walks down through the PUD entry that points to the shared page table,
> then when it reaches the loop in gup_fast_pmd_range() gets interrupted
> for a while by an NMI or preempted by the hypervisor or something.
> 3. P2 removes its VMA, and the hugetlb shared page table effectively
> becomes a normal page table in P1.
> 4. Then P1 splits the hugetlb VMA in the middle (at a 2M boundary),
> leaving two VMAs VMA1 and VMA2.
> 5. P1 unmaps VMA1, and creates a new VMA (VMA3) in its place, for
> example an anonymous private VMA.
> 6. P1 populates VMA3 with page table entries.
> 7. The gup_fast() walk in P2 continues, and gup_fast_pmd_range() now
> uses the new PMD/PTE entries created for VMA3.

Yeah, sounds possible. And nasty.

> 
>> How does the fix work when an architecture does not issue IPIs for TLB
>> shootdown? To handle gup-fast on these architectures, we use RCU.
> 
> gup-fast disables interrupts, which synchronizes against both RCU and IPI.

Right, but RCU is only used for prevent walking a page table that has 
been freed+reused in the meantime (prevent us from de-referencing 
garbage entries).

It does not prevent walking the now-unshared page table that has been 
modified by the other process.

For that, we need the back-off described below. IIRC we implemented that 
in the PMD case for khugepaged.

Or is there somewhere a guaranteed RCU sync before the shared page table 
gets reused?

> 
>> So I'm wondering whether we use RCU somehow.
>>
>> But note that in gup_fast_pte_range(), we are validating whether the PMD
>> changed:
>>
>> if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
>>       unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
>>          gup_put_folio(folio, 1, flags);
>>          goto pte_unmap;
>> }
>>
>>
>> So in case the page table got reused in the meantime, we should just
>> back off and be fine, right?
> 
> The shared page table is mapped with a PUD entry, and we don't check
> whether the PUD entry changed here.

Yes, see my follow-up mail, that's what we'd have to add.

On an arch without IPI, page tables will be freed with RCU and it just 
works. We walk the wrong page table, realize that the PUD changed and 
back off.

On an arch with IPI it's tricky: if we don't issue the IPI you added, we 
might still back off once we check the PUD entry didn't changee, but I'm 
afraid nothing would stop us from walking the previous page table that 
was freed in the meantime, containing garbage.

Easy fix would be never reusing a page table once shared once?

-- 
Cheers

David / dhildenb


