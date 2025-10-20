Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37400CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 13:23:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9429B8E0017; Mon, 20 Oct 2025 09:23:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F3478E0002; Mon, 20 Oct 2025 09:23:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BB098E0017; Mon, 20 Oct 2025 09:23:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 656158E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:23:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14363138EA8
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:23:16 +0000 (UTC)
X-FDA: 84018558792.25.FF809BC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59978160005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 13:23:13 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GK2r9mXe;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760966593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+wQ1gO69qnJ9RJYLFJUY5Ht9X2NoNAtaUt3TQ1G6MA=;
	b=QeVZicfeqwA+U8u2oeN1q4fUtfXXyO3fw4dKg7NdTINiKsx1JJluoLtA+GYyUfcoQzc4E/
	CaZbubX5xeKPgzwF/dUONS14pOPR3XrljclhK80bslkTJjgxBejI0PGe9O6IsUdUdC+DY4
	Zt6NrFxVoS7j0u/MttWCgXrh4mbYxQc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GK2r9mXe;
	spf=pass (imf08.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760966593; a=rsa-sha256;
	cv=none;
	b=5sxftK8oF8FI7m2WUGxd+1yURqWiYfTj/MCtQx0Q6dS/PcJ5ufrhyKg9H0O1qc5hzBIUM9
	XXkvpP3+1lXbW/MlNY/gV2Hg5zmLkENfwOyN3slhUktKc+RyDtjsZn6wvY0BAv4e5fHMTy
	jtmlbp1UC2oS7vQLVmyFW6tVVFhw1KI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760966592;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Q+wQ1gO69qnJ9RJYLFJUY5Ht9X2NoNAtaUt3TQ1G6MA=;
	b=GK2r9mXeHWUx4AfJj21VgLsn6Y/3YqjhIaYAIGnGDXJhpiokxp+5fx0yyRHGZJI+YYeIry
	OekNn3GJ3iC5VFbcWbRhjfbEFE8JaU7Azc4rW2cPMwXoo7OuEE+6PBf76mT79QzUZuo9pz
	82nYg4aU1SFCR+NVljbMFU7auNpaCCY=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-540-pqYPJjVyNMS9Sy4Jb4n-hA-1; Mon, 20 Oct 2025 09:23:11 -0400
X-MC-Unique: pqYPJjVyNMS9Sy4Jb4n-hA-1
X-Mimecast-MFC-AGG-ID: pqYPJjVyNMS9Sy4Jb4n-hA_1760966590
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-42814749a6fso1011145f8f.2
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:23:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760966590; x=1761571390;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q+wQ1gO69qnJ9RJYLFJUY5Ht9X2NoNAtaUt3TQ1G6MA=;
        b=GESVSSEyKG5rIDpPI+1977h6G8L/j4g/i3q/eUMFuxwefFnu6HJZCnaIQwkW1JiEBs
         uMrKJXWvScXx4ffW239bDWQYH64dIIHANYTjmREN/jvZxOs3bRGWA+/YjECSFvDkRRbW
         Hb6/bclbxn1pIihu6sr8SdcFyIeH2Q4hfvZuH7Uddy0Up35oCQQx/gLp/sRissti43gn
         YH3jnsyB6iA411qAlhDyyOiADbEcir7zWstsm98Ujf1NyBoFe3PACEfhrcT5MFl29qbx
         L3Y2gNTRVhT9Y2/gkIvifScuU6GQg+/qcNN4raDWm2TWoq+HgJx9TEJKpiWUrA6ArK0B
         0QkA==
X-Forwarded-Encrypted: i=1; AJvYcCXp05DeuNIeqWgZ77yrqGr9JZ7LzmZWJW/OyFrSPuhjCaeZ8FOt8qmTX5bOF1dyeWVC3oQec7LTFA==@kvack.org
X-Gm-Message-State: AOJu0Ywo4nwq9Jc5K7oVyzkTeJrwSLCjOE9F0S1fLzIpSX0YCph1KM0D
	CJqAfKU0JnO3XK533Rzukr5TIbu1f/Uf8N6w071gmvEoJcMhuuCKsc4vLYFNEwR4oAQTW/SLRjU
	ZEgCzRAROI/5c72jo3advHW79p9coATI5r+Dgnsl83V2EYOKIy9rW
X-Gm-Gg: ASbGncseRgB/u9mjisGTbYSj8/ODqZVt1u9LBQf3uVoRAGyEXB4mPhWlfGAkw9QFYgl
	lR1C00+zt3O1pgAv2a4MmLyYfCcj53UiF0TmjBxUVxaZ6kEZrv1InHVEM+bfjMvDP8bjav1kad7
	+6xcQ+qHBYFzL8PtihR+4V86FgvSKFPa9Tk1ZGpKZviRr6qwwujQL5jmXO3+4AjmF8fMMqrSKuL
	uqPchgws08GayqVZ376RFP+8eS7Wsjk1HN38FUhyUqGl9P9JAqq4q9Q6MJDbt9+6XthxVsn1kWT
	B5g0354kddhWsfxh1LpyO/AT0nsy6Ph54U5nXAPzGom0YPpG1EJWG1Ck5LXPt/FXuANPMtNfRk8
	qhSp5qzGOSpgP1QN0SYABom8sSDagwWZBD980o+GOE4AQGlSDC8dw0sO4y+x7VzFY4PZrWpZ964
	ys7omGM4ZOgL8R3x8/zFwX/ygYWYY=
X-Received: by 2002:a05:6000:18a8:b0:427:7f5:2b8 with SMTP id ffacd0b85a97d-42707f50382mr6666062f8f.43.1760966590020;
        Mon, 20 Oct 2025 06:23:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGGj6EeZCPDunx0oM/sBho+CkCZ4jnkWx4xDYGXMkdxuK9dT515/nF5U7EByTd8v3TC30PiLA==
X-Received: by 2002:a05:6000:18a8:b0:427:7f5:2b8 with SMTP id ffacd0b85a97d-42707f50382mr6666045f8f.43.1760966589647;
        Mon, 20 Oct 2025 06:23:09 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce? (p200300d82f0cc200fa4ac4ff1b3221ce.dip0.t-ipconnect.de. [2003:d8:2f0c:c200:fa4a:c4ff:1b32:21ce])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce586sm15508606f8f.49.2025.10.20.06.23.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Oct 2025 06:23:09 -0700 (PDT)
Message-ID: <a25e1292-1110-4534-b7ee-b3398b955236@redhat.com>
Date: Mon, 20 Oct 2025 15:23:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/4] mm: huge_memory: use folio_needs_prot_numa() for
 pmd folio
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Liam.Howlett@oracle.com, Sidhartha Kumar <sidhartha.kumar@oracle.com>
References: <20251020061845.3347258-1-wangkefeng.wang@huawei.com>
 <20251020061845.3347258-5-wangkefeng.wang@huawei.com>
 <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <4d9b5a05-5e1a-4a99-b8df-bd61b336392f@lucifer.local>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cLk8G1u-iHu_KG14BQ8GPeLCImkAK1OyrDX57j03KCk_1760966590
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ch9rfxiw94nuu1eqmwgjxbuxg9uz4g71
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 59978160005
X-HE-Tag: 1760966593-707645
X-HE-Meta: U2FsdGVkX1+xv3zbDLENIyTkNCbHBB76CWce1Z2cCobaGq3PUiolFOSa86YbsF9y7+aOZYOQF5seCJ0NYeWK58fPK6x9g0JHaPI9H2T/OE4EidzsfNQVdCmmirV7GY7HJ1O/2OAkbrrT8mylQMDeWn2aYk82PjnNKyzvi7IeOdhiEeuWvVz/tQ07wjhG2P7PED22hlArBzdGt9iJUBHIZI3JytAefB3Ne1JarP3+AXwXPqU4i+qHJFYv+rhredJ/Qx7hUJ4azxvyeH1czN2yfzjDSz7TxZjfltuEqxpvoqvp7ErvnGo9PY7Xw1uxrHTS0uYQC6UN7ABAIfyW6n3rQeE7fxneNYl8RveY9ksnLl0WqETbx6TLuyRmCGJjXko0OluBf4UspdlWKogR71jFmDpyNC74h8AyG3snMQ9Z2LkUvvjxiYDxZq4BByM9mZdhFG0DePY7PHA82Jt70MMpKBAJE1hZjA3I3KWues9hWwjpQSWa5rGPNmubMa4i/gqF+QuFB8ulV4u89QXb8jk8L6/Mi0MIdiF0lKFqxYj8Ka7SZZcTBhy2uG6ClAZQjVit1PiFhz+mbnjeRdk0gJQgHQCax9/DqUkoBn36jtxe3/h1mQ5ko8awvdlftTRBzXSAupC9kZILv1WGm8Mjnd5LN0Q6ooyC51xN6JzCxP4MUOQ0eFaxNt1hxHMtEKf+NcVzDsFxR013tMbfllhuKqGX81uYC2vUgEMrR9DY6ObS8B2jacSjKI73uJHQrimSyEwxdR7GqlwCKaJwhbF0UMeDsDeWaLP4EI5lMglSD0kwJX0L30hvV7aFJcveLhBXFn7q4yhMmq7tnjIbSeOmGqxTt8sTJEOpkRHgeFlkw8yXURpimNvFYTeNn0XkdzohbcB/THRN7BZxEAxmWrB9V06tI7WuDrGdhccjjcoIE0rSXwXZ8kXRef6RhGpUy/1ab2+OsHuvz/6phqrWva38lZr
 IKmNOlDV
 eVmw7vpDHEVYe8LY9uQVDjJxuWQ6PfagR3gBZM0vRIXIEJEwr+Dqzz2D7ixbVaux9G6G5ZNGX1QsqGEmVt4q6KeFklm0OEXjkqi6y5xhYlFjHBhcVmnKB4/ftXZ0UFfXSAiqP773tB9ywv0qLZV0OQLZp48SBV/KxzXNgOlPHTpxMMunN3Mj4J8v0J33zAwKak2nNDst054yXTSolPtkmYqpHU+GVegjCJk1pSdpOjOAaKjrWVwpeQ66t1SV4C89eZe/kALTM7UJlW4nVtg4L1BZo45DwUpCBZjFh+62LQCJ3c59bQddPMzch5NgThH22sSWx/kf+ZiColA4BCjwsgk4QehyBhPZ1d9e4XQNwTa4i2rPuQAQgNVmNp1cw0JUVo4Xr3CLkUPR6w0Um145R60+F0BOtHd4GORmhfwjDe+PmU2PzFwzwQhne8VjVwQjS+3cTo4QYQ23a2EnJUg4a3Vf2xF2MZvyZ9ZiW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>   		/*
>>   		 * Avoid trapping faults against the zero page. The read-only
>>   		 * data is likely to be read-cached on the local CPU and
>> @@ -2490,19 +2490,13 @@ int change_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>   		if (pmd_protnone(*pmd))
>>   			goto unlock;
>>
>> -		folio = pmd_folio(*pmd);
>> -		toptier = node_is_toptier(folio_nid(folio));
>> -		/*
>> -		 * Skip scanning top tier node if normal numa
>> -		 * balancing is disabled
>> -		 */
>> -		if (!(sysctl_numa_balancing_mode & NUMA_BALANCING_NORMAL) &&
>> -		    toptier)
>> -			goto unlock;
>> +		/* Get target node for single threaded private VMAs */
>> +		if (!(vma->vm_flags & VM_SHARED) &&
>> +		    atomic_read(&vma->vm_mm->mm_users) == 1)
>> +			target_node = numa_node_id();
> 
> This is duplicated in both callers, and only used by folio_needs_prot_numa(),
> why not abstract this to the function also?

There was a discussion on that in v3 I think where I asked the same 
question.

-- 
Cheers

David / dhildenb


