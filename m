Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15550CAC597
	for <linux-mm@archiver.kernel.org>; Sat, 20 Sep 2025 09:00:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51B248E0003; Sat, 20 Sep 2025 05:00:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CBCF8E0002; Sat, 20 Sep 2025 05:00:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BA668E0003; Sat, 20 Sep 2025 05:00:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 257BC8E0002
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 05:00:29 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A667611B111
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:00:28 +0000 (UTC)
X-FDA: 83909032536.24.D9E1F06
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9810140003
	for <linux-mm@kvack.org>; Sat, 20 Sep 2025 09:00:26 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UVmDG6aG;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758358826;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XSOr3Sbk4zCrT1wZbw+pixYMzS11xMavyoUVJRMRfrM=;
	b=s3DR8TXYqyDzAo8uoB64KwEQZm6C/kDUd4T++/oRsX3zV6iW8q05Qzxc8AecIwyDtYwB9z
	VMvJ12TzTsJtyabBInjFGqhbi/fj7xLEc1kmFAm+3MltPKcaqocVPJRckhMnYdRFgUMcfN
	3eT6Buf/lhGf7DyLDFA6Bir3eTSa33E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=UVmDG6aG;
	spf=pass (imf01.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758358826; a=rsa-sha256;
	cv=none;
	b=Bs48PN4fLEDPfeATS4S/uNxoyreBO4beaT0BTdhPU0pOMyIRoRRtIksOwP68NH2+e/QwN5
	7xeJgFw8UZ5/Y7a5Anm/4J7t8z062ZbQIHHEn+ScR92bQo/VTpd4NfMVe+if9wiFGKgtt0
	1p894/oqKZF3Jq2s5Ez1XPywf0rYGAE=
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b2391596dcfso350062966b.0
        for <linux-mm@kvack.org>; Sat, 20 Sep 2025 02:00:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758358825; x=1758963625; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XSOr3Sbk4zCrT1wZbw+pixYMzS11xMavyoUVJRMRfrM=;
        b=UVmDG6aGtYd4Tu7JJQj5NOfu4zhko0m6mtskSmS0JOimjCOuCECz6CqiNvEdisZ6fG
         VATeYWYeoRIDgYv3wr2KIlwzkhxa5CBbAFCFRmLcRm1UyhumvGvynYKYllRaB92dCZ4I
         fGM6J2UaTBjPElIwZSImp7X1hRBCKYKD3o7BWbVFKSe9m3VSej0SQDg6euiZp/bGNINF
         LTdYoZAumMjGxqc5GSkfiFvp3x882Dj/PhJDkqeRMcgnRtf0XhfgcT4XtzrNSW8o02c4
         NqgsNwFwSK31sGH/MVBoxKGhONJRD4aOVxZsIEg+lEhObMOe3VxiSjwty1kXAngZ8yLY
         9oJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758358825; x=1758963625;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XSOr3Sbk4zCrT1wZbw+pixYMzS11xMavyoUVJRMRfrM=;
        b=kJUjo4hJd6P6cy7ZVA1xiutRprFAKeQoCmSmNjbqujZ92WZ9WwMGJbTlhTyAMMXYM6
         W5CPXB2+maQBfYa3jDaVgC0WqlKTXlWbFSZCS5GhdPXR7fcCr+EQCqaFpqQ4y1XwgcjF
         tLjw1iolQWBfL2DimP4z1QpY6xCzuA4WwUIuplUiGjTQg2Uzn6R7GdtLAc37zSXQ1ht5
         JIoKtecS+cqdrhvwZANOwnvLwgY1fERf62ORPN4GYKp/uhh7T1hhmljWZxl9BaY3Mxpm
         rRdXXxDvokQtN6u1tycO1GteaYmvnprk+UxJwmZBq5Ex9cHccKPwYMSTrhlNKBOSeSwV
         lbMA==
X-Forwarded-Encrypted: i=1; AJvYcCWmvUiu2WfpOXSsN3S3WQD6kavS+ITQofykyARupkrKKQq8z/rsqf2nwqV/yTU9ZqEBlVyZwH1tIw==@kvack.org
X-Gm-Message-State: AOJu0YzIoSP30DRlshFRn8xzyVUUZwXKPKcsUS4Zq3ifUWvyU3M0dJRi
	sVHUX3mrTLZ+RPU/i+U4FYIRiH1Js3A39YR9C0758f8ZP6L13CtF53Qp
X-Gm-Gg: ASbGnctG3aFwKOHvZQdfpoBALB3SPoOSsfuJsNUCvyHMbp2Q03bLxA3Fv3yLasJ66S5
	+DlVf0OC+8//P5mbavQzsue2pKoYNB95YoZ4siv0UrnZZsfB27I70icHthmjukEfJ5YsigCi/9w
	x536Jrh6dbrVVbp+ucePd8lZRAj7h4KWogZ5zoQO9YdX+fvf7LTZ0QpJmATlUu/xj3+bc0iTebN
	bgcxKUJZGMU9KMZceKiZWSubg1a0W+ps1F1iJWlmbhPjFvspxcYzeJCTKp0yCMm9adYCb001v++
	DosK6B1B76Zm/fOArDULXV5/JkbtAzovfIH6dmq5VeviIyLntZGv6cMAOeHyZqhDYfe9F5OZnud
	JYq7zkj1uHUKMxPXc426eiQ==
X-Google-Smtp-Source: AGHT+IGyVRea9T+eIdA5m/1ORESbwteHi0UQUtN5JloZRkENQnHai/4kpPbkH6WziF5LwzVgp5EdbQ==
X-Received: by 2002:a17:907:d649:b0:b04:2a50:3c13 with SMTP id a640c23a62f3a-b24eca00ebemr541071366b.6.1758358824742;
        Sat, 20 Sep 2025 02:00:24 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b1fd110207dsm627463866b.78.2025.09.20.02.00.24
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 20 Sep 2025 02:00:24 -0700 (PDT)
Date: Sat, 20 Sep 2025 09:00:23 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Lance Yang <lance.yang@linux.dev>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	lorenzo.stoakes@oracle.com, baohua@kernel.org, ryan.roberts@arm.com,
	Liam.Howlett@oracle.com, dev.jain@arm.com, david@redhat.com,
	npache@redhat.com, ziy@nvidia.com, akpm@linux-foundation.org,
	baolin.wang@linux.alibaba.com
Subject: Re: [PATCH] mm/khugepaged: use [pmd|pte]_addr for better reading
Message-ID: <20250920090023.52b4mupfa6dkhtnz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20250920005416.5865-1-richard.weiyang@gmail.com>
 <b1a8925b-8bb6-43b2-81e8-abb377905d48@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1a8925b-8bb6-43b2-81e8-abb377905d48@linux.dev>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Queue-Id: 9810140003
X-Stat-Signature: o5m4yasccknw64aqjxszmkbycwwtbytk
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1758358826-388775
X-HE-Meta: U2FsdGVkX18xo8y+rPCStJl2UnGsxDYKgXZLTwcmUdQWGnzcmwDJKHJTtaOXM8oMA3oZnZgMF9cOW77wJX5twM0jb7pLk5WQn0ZqfCTbqdOK83BveL8rPyHUsgkzWTsFuwExX+lZFj4id+N8JKyx8PRtUCmhBGFgyHWgumxdU2SVZyZWibv4DR3/R8pGVUBHKDKXdGymPk6WEDu0tPPYnDTToO6m7tWae6frtkQR0GBqaEOggcgt4ueFVDIWnsmHuPtNHzhNG3q9FLx7TQvBjxjydkOEezkWvDfYQ6JntMYBBXVhF0nvxfOvzLqY+D5/lmAoG1JOD7oWy/r8yf4wnhSnwe9u6k14yM8eM6wWiW0AvOombzpkFYI2jMjitAVeAu2+MlCjknSbvIxZfkLDiMeFRHphPW8Eiv3wvyo7Amd/y+snJsYNn4RHAU5AaEUcpCjWWwgclGSc7b/0syyUd7lJ6oixUzhD8VcVF+lXYt3KxLR0PsjNY0a2bZrP0FKJbkSOkaswEIXWy+jC2bJ1ujUYHys4qSMIFpdtSGcYlr/C48Z5YaN6MyiThLN4izobQ4xEWP4Z+nFuE3PdFi4HErhC82LUq3LUj+LPwd06HcSy1FMKVjGoQ4w7n9H14Twk8cqWlwyIL0f0LDt7hLP2oT5Vf7pAPkx8Bwn/TI00bn4PhNAcxTg9Yu3CtPIDMDb8ijsB6U1Y6CXEj+igxWV0FSNViLOlFP4SgsDLgC5CxW3QBTBS38Mar0glOlBzTf4pMa1kKtT1R17wr+4DOb1wpIPbtxx++UMVhcXXvdt5G313xStlJq2UfmF5/ZbGvtusDvLcBEwPJmk8tiJJo6ZWn2mwywJ40lfu77PwXqMtyO5Iu8xUnIzjmjmzjlo+O0jSnsLbntJNUiARkWa2TXswFUk2K3FXwWc7cubR8i7Iz6iQiyB+yz5JqrLB7LNFJOkwk1itiPLUQOXzQrvPVAB
 1E8N/Ngg
 LtRZIkMuktaRcuGMpwDQ8oSLYKbw9XyCTBx2spCq+lxLk9WC3+ou3TdAWDZ+d0/CLtSfBAtrEZPMVmpbJIxA5b1c+NVGabWd1fuYp5ywX7Uq+StKOXhx3MH3iR6UuCFPlgFwQUZCiQWPRphpf6B658nixDi4ItUi8+qASIUeusjwazVH6R0EJVMzALK5H3IKAdFS0GxU+V6iVyoB1Js5+dn2xkLWOMNDkmJeIyhwO+mb04spgaer3QhlQfxlpcXIMNf/v5bSgF/HEd4X+BIL3/Ee8oyK3Ah+8oHlq8hG+QqvDD4dnxhKuHqJiP8xxhpJx9fSTiu6nYLjRdvsaifKt6WE7Ig1b8CXGqQXchkm7U5LjUjIr/yVSC/rJjplWixE1bjWfbF3I7WBfQDRyxqTkQL/EN5sjjaYIfD1jOKcfs+UBvJZA/km2ur/vn/TeaZhc7+oViaThlwnWBH5DKvms6nH91m7RFO/5ebGuSJE2JkUZ8oJhe1KrY3JJ8M3nojkF+iJnKhbwTH1VpF6dEwgy6oV/mOVBqD5gE99rxAv++8vc0C4ej3ZaW1Yv7e1RriAiSQbkBKaiKf4eWJJ1B/ujJSh+ReZ0Fw/i9PsOPwgKn6MOe9GGh9sg8yV/3ZQKY5knwzqNQatf/IehmxjcHZx79KqK1iC+oYo3sm8R27oJbucyLBWZA1Oe6Nq+UcT5mRnnCpCx7S1ge7ZPj2AezuxW2Fxn+kqv/a0iS6nQsBllrwh4RGIrJNvlh8b7oqMAYRB4GZt+BkAHrJgSfzj8ya8oJlfg7EGwA3FrObg8C94ia8aFJ+w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 20, 2025 at 12:30:52PM +0800, Lance Yang wrote:
>
>On 2025/9/20 08:54, Wei Yang wrote:
>> When collapse a pmd, there are two address in use:
>> 
>>    * address points to the start of pmd
>>    * address points to each individual page
>> 
>> Current naming is not easy to distinguish these two and error prone.
>> 
>> Name the first one to pmd_addr and second one to pte_addr.
>> 
>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>> Suggested-by: David Hildenbrand <david@redhat.com>
>
>This renaming makes the code much easier to follow, but just
>some minor style nits below :)
>
>Acked-by: Lance Yang <lance.yang@linux.dev>
>
>> ---
>>   mm/khugepaged.c | 43 ++++++++++++++++++++++---------------------
>>   1 file changed, 22 insertions(+), 21 deletions(-)
>> 
>> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> index 4c957ce788d1..6d03072c1a92 100644
>> --- a/mm/khugepaged.c
>> +++ b/mm/khugepaged.c
>> @@ -537,18 +537,19 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>>   }
>>   static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>> -					unsigned long address,
>> +					unsigned long pmd_addr,
>>   					pte_t *pte,
>>   					struct collapse_control *cc,
>>   					struct list_head *compound_pagelist)
>>   {
>>   	struct page *page = NULL;
>>   	struct folio *folio = NULL;
>> +	unsigned long pte_addr = pmd_addr;
>>   	pte_t *_pte;
>>   	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
>
>Nit: could we refactor this block into the "reverse christmas tree" style?
>

You mean sth like this?

   	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
   	struct page *page = NULL;
   	struct folio *folio = NULL;
  	unsigned long pte_addr = pmd_addr;
   	pte_t *_pte;

-- 
Wei Yang
Help you, Help me

