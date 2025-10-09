Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5FEF4CCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 07:40:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B8A058E0023; Thu,  9 Oct 2025 03:40:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3AA78E0002; Thu,  9 Oct 2025 03:40:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A298D8E0023; Thu,  9 Oct 2025 03:40:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 920F68E0002
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 03:40:45 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 425EE467D1
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:40:45 +0000 (UTC)
X-FDA: 83977778850.26.45A7334
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id E80CE100011
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 07:40:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lei51xPd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759995643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4T6bYmZE+LO9vR1ksJGNOmn5mFmrEK+ilv0kzm2Rmso=;
	b=szerc7qCvfDQdvIYcnSZ40sjw2EbnJUsNXujppRgIrcxXIZHgsxWtxZggzbsvPypuS7crQ
	diMJbhQaS9Zi5L+Tov2Yfjq2x/a0gHes+Xnj0MZUlLA9p0moyzcKH+zZZSk1BNvwCDbWrQ
	ih8A4cvAVNv2hcpVSu6/nPbMkAIPnzQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759995643; a=rsa-sha256;
	cv=none;
	b=ez5qrBcqm+4SW0oBWfqRk4Y+KUbTZGJL5AgWSRRm8W3yzgukMkssDOg4D1YX14DnZ2L4iy
	vAe2zHEYNDvQLDrAk8Jb5mz3WPgyt2QutQY4Pxs7aibkcOnes4bNrA9vn3Z7WM1qSkPcIy
	8HApy+ZIB6y4aU0VXJy25xQXfs7KmCw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Lei51xPd;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf14.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759995642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4T6bYmZE+LO9vR1ksJGNOmn5mFmrEK+ilv0kzm2Rmso=;
	b=Lei51xPdfCntzMWMwlvgntAuCqogywAvtSnH3ILB2rhIo+o/RV4rlS+4TYyHeNwT+g4g7g
	JjA4iYcLGbM7PIE6jZJKEtSVXwRJdPsmtWqrbwOazpnggEvAtKOtrLmxczkJaj9m7AN39x
	EcWHPkoF5kgQjj2FGVg/1rrA8krRpK4=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-426-ilGWw0NNOICD4eXFrDT8fA-1; Thu, 09 Oct 2025 03:40:41 -0400
X-MC-Unique: ilGWw0NNOICD4eXFrDT8fA-1
X-Mimecast-MFC-AGG-ID: ilGWw0NNOICD4eXFrDT8fA_1759995640
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-3ecdf7b5c46so404569f8f.2
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 00:40:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759995640; x=1760600440;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4T6bYmZE+LO9vR1ksJGNOmn5mFmrEK+ilv0kzm2Rmso=;
        b=mooFTe2haAdOwDVc2ZC+kioO/A8Ku5rhkXOgT2WjfEOZVqYxEINd8Ekwhfj06SNDCL
         x4cm//7C6VmX4t2t6wtRRK2xwbRyqVKUF5wrHg05pWDgLy4KpDA++JKKh+OfU1ItDkxa
         xuO8eToKqbN0rbDHtLf7HNeWoiie61O0klrsaI4q2DsZuRCKOi/G5pkiPP+tvhZpego1
         qjZ8cELd9b3bABnwyUcVqeecMBDYmJP4Y7AvgOyIELVuzt9Lv2IttWqv4zwhhuy1JBj2
         jr3rGz6a+6G1f4TUrGHNTBHtGW/KcTJ6RD7fI+CifXJUXM0mkX0KaAvcls+LLjB0NoEB
         AlqQ==
X-Gm-Message-State: AOJu0YyBUZ3dnz0tajETMVzXePXk0vK8BQuO81a3q5s9Ux/17k6RgNsH
	s+q5bVs6jwWK6+SwG1QYt0iJN7i875IS3CYypK7BPpzCu+vhJLJAxg/M3yS2bulsh2cJu/0zNZh
	tqo4zjdVWuz50EkWL+gIYPld00FD+jhDRseMFgdt8OTmlz0gko1tI/kAK8Qro
X-Gm-Gg: ASbGncsK+5pYL/Qz4kuheBNMQNNig0rmrwPhmqWH6do4x0HcIM0KghLLHz8GU95KzXb
	B1XGqghBEbVE2rdCQLqCd8KA4prUYy74pI4+TjKwm4HiJABT0JH30BbtWuy9tNwdUMyVQOuTjZ3
	XeUzr0Bq3pI2/jkzVwDQMDeuMInxr8F0cA5RVoKXHL3OTGgPFy4Bmmrs8qrr7DF/fYWn50qTgXz
	LkYntnZLR81xB/blMHNQhF5OZ5Ub7ePBhp/cuqS30CdAdgVGdMKW+LCKt1h9hkHdbwhvrl4aAqG
	71UAMsHlhMvUUENbg56LTwbc6hK3Pkc4dRwpKSGMnoJYY/uFGaCuN9RW3WFJLfI6WWm4ryvisIK
	eN5/piZWV
X-Received: by 2002:a05:6000:607:b0:425:72a0:a981 with SMTP id ffacd0b85a97d-42666abb02bmr3831525f8f.2.1759995639891;
        Thu, 09 Oct 2025 00:40:39 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWMrszMDlMbAC3kv3AzOArS5/qJRRP5l/pf0umDvfvnlRGQEsSMcDv4DZOlUxZZACt2Yd3Vg==
X-Received: by 2002:a05:6000:607:b0:425:72a0:a981 with SMTP id ffacd0b85a97d-42666abb02bmr3831503f8f.2.1759995639459;
        Thu, 09 Oct 2025 00:40:39 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8e96e0sm33332407f8f.33.2025.10.09.00.40.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Oct 2025 00:40:38 -0700 (PDT)
Message-ID: <c7fc5bd8-a738-4ad4-9c79-57e88e080b93@redhat.com>
Date: Thu, 9 Oct 2025 09:40:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Bug: Performance regression in 1013af4f585f: mm/hugetlb: fix
 huge_pmd_unshare() vs GUP-fast race
To: Jann Horn <jannh@google.com>, "Uschakow, Stanislav" <suschako@amazon.de>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "trix@redhat.com" <trix@redhat.com>,
 "ndesaulniers@google.com" <ndesaulniers@google.com>,
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
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <CAG48ez2yrEtEUnG15nbK+hern0gL9W-9hTy3fVY+rdz8QBkSNA@mail.gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: nEtLusvfiXaEUj_RN9BdM98VV41kDFyhQ8cXyeCE590_1759995640
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: aqko3jbdgrd8x8uj64nrbohfffamkjye
X-Rspam-User: 
X-Rspamd-Queue-Id: E80CE100011
X-HE-Tag: 1759995642-33448
X-HE-Meta: U2FsdGVkX195T5sOqEtbjq8XB3rK45LyaRikeETzqgBu6loOL3bUg96Y8hI11JdkvaBc/jwgCM0zpHjtbBMbiMzGLUf5xEsnvdK3k08JR890wi8f7pjlFy9eI8rSpqTlhv3jTVzchhoXAuxwZSQxxLQuKCCllXN/0l1pFQZxTZ5CWKLWGBUwjTV8W50zHyCibP+ZCD8Jg4QObrEhGogV5BPZMkIZH5OMGeQEIftkx13nq63i0s7YN5oi8dQ4hL5996o+8VpLvo5ZHRfIxWF4XJQkVm+uYinQccABdJ9UoA+CzNsRu5vhNczaa8W6EdHBKlDwSRfeeDygFPbPMRVdODjE8QbUnXe1R64BmDo9VfiDiFIDN4gOyS6Ch58nJYxKqCwQ6QQu/YGh0DbiNltpKgnKwL3o/+ChWX1YKObSgywv0OXyXoEDJtIkkJtfC1gkw4Q69pB095xygfQX8FBZxwQ82PrDq3PdqCweDpyfwSN+/OZo0CDJOt8KRyfkEmH9NTUB06ppnHjUMLjVqAeVt033cbniUzcJFvkigY4fsTCmV5T+vKZynQSA/ABqKKnQ3IgB0Sn3JNFrfD6YZM0wyclwpETkUZ+ma8CnoNbTyYoFCmrNlFgLtn1KxuzdjX+pIecGLi4CWvyWdqHfL6eKqTE5UjDSdYX1EP4+qo3G0saqXsq/x38QdcdcIiyG2101HYtdnI6+6GoIooIFl8W3r+l5qBl0IRAY/Bc0jBclAJkDqw1Sk6fLKTvC80mcAcXttcbYbX4Q+K+gI38QtDDoM1QGiri/W7/iBoUcXEatQAYHSvKAlmKz+oCLMf0oLpNYJDZ3UTi9SzF6BFhuoQBa3bZZfMdXhkh0BJtax5RCjdSAkIEciAdVsbi6zLPkl8Q0+JEx1iCglpIZ1mBIrEsCUgEylHG9IVBg1op/NnREuMd6Zb90GLO/CZ8DiFKXhmkkcVBjrK8ZabScKPv+x47
 YpYH7KxY
 lOXinM0gw+q7RR8gsPFLWNA07MQjD1r7/bWZxCc+JNqxFMkR89DOmnSh3FsIxziqIts4bh6CEcYufK6HDw7rU39J8PIpzNsOODypnSZrsTfouMxOlkihzqg2fDQFNLK7rvGUmTNggGrOxgVUxIlOLk0rtVtvg7RjTWs8oggK66cJ1IFLdDx9InNaODA/bCT2K/3Gdh1q04FHTogOKg7jye2NpZ0B55GWvGI9h5S+6fhQwxMpRAzTwuQbrjD+OzkvlqnulQMFcZbn26LWZURoAsAyhsyFV+BDrt+hy7P5yrIjcuLEqG/2C30zguDLT3Na726oM/ACV4zaIDlzGpzTxO8mexXpzVMve8vOKlFskT2lEfVKoMwZgXVgkBgOYyqSzB+F7hTuAsjlo6YhemcKkxmcpKUJyizXdm0ViyWxtoNCC9JEQrne+PdVCKZd0mN/UMXRnX0JVRD2yO8NOP4eBvDG9BtX+UZRBLmuwgI1EL0PmC1hp7TxqtnKhPLklVT2rPYrP7LtHZkt4E/RNSJ1iEKMxbAw4mz6s4vYkMShmlXl8GSB3tyZ4i8PgnLTsMJqXydTRvpiAyM0AXoD4WwGVb2eqmTMzv5hI/lLNKZEUHoUhPRAHcCUXc7+Uug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.09.25 12:58, Jann Horn wrote:
> Hi!
> 
> On Fri, Aug 29, 2025 at 4:30 PM Uschakow, Stanislav <suschako@amazon.de> wrote:
>> We have observed a huge latency increase using `fork()` after ingesting the CVE-2025-38085 fix which leads to the commit `1013af4f585f: mm/hugetlb: fix huge_pmd_unshare() vs GUP-fast race`. On large machines with 1.5TB of memory with 196 cores, we identified mmapping of 1.2TB of shared memory and forking itself dozens or hundreds of times we see a increase of execution times of a factor of 4. The reproducer is at the end of the email.
> 
> Yeah, every 1G virtual address range you unshare on unmap will do an
> extra synchronous IPI broadcast to all CPU cores, so it's not very
> surprising that doing this would be a bit slow on a machine with 196
> cores.
> 
>> My observation/assumption is:
>>
>> each child touches 100 random pages and despawns
>> on each despawn `huge_pmd_unshare()` is called
>> each call to `huge_pmd_unshare()` syncrhonizes all threads using `tlb_remove_table_sync_one()` leading to the regression
> 
> Yeah, makes sense that that'd be slow.
> 
> There are probably several ways this could be optimized - like maybe
> changing tlb_remove_table_sync_one() to rely on the MM's cpumask
> (though that would require thinking about whether this interacts with
> remote MM access somehow), or batching the refcount drops for hugetlb
> shared page tables through something like struct mmu_gather, or doing
> something special for the unmap path, or changing the semantics of
> hugetlb page tables such that they can never turn into normal page
> tables again. However, I'm not planning to work on optimizing this.

I'm currently looking at the fix and what sticks out is "Fix it with an 
explicit broadcast IPI through tlb_remove_table_sync_one()".

(I don't understand how the page table can be used for "normal, 
non-hugetlb". I could only see how it is used for the remaining user for 
hugetlb stuff, but that's different question)

How does the fix work when an architecture does not issue IPIs for TLB 
shootdown? To handle gup-fast on these architectures, we use RCU.

So I'm wondering whether we use RCU somehow.

But note that in gup_fast_pte_range(), we are validating whether the PMD 
changed:

if (unlikely(pmd_val(pmd) != pmd_val(*pmdp)) ||
     unlikely(pte_val(pte) != pte_val(ptep_get(ptep)))) {
	gup_put_folio(folio, 1, flags);
	goto pte_unmap;
}


So in case the page table got reused in the meantime, we should just 
back off and be fine, right?

-- 
Cheers

David / dhildenb


