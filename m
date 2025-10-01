Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59F1BCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 14:34:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B23FD8E0007; Wed,  1 Oct 2025 10:34:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFB658E0002; Wed,  1 Oct 2025 10:34:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A11228E0007; Wed,  1 Oct 2025 10:34:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8DF9D8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:34:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 3B3DAC0A52
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:34:56 +0000 (UTC)
X-FDA: 83949792192.03.EF5A279
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1BA612000C
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 14:34:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwksTKqi;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759329293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ql0X/fS1azakBvLeAJcwxWQYdf/tNZdBt41oVsfxQxw=;
	b=gTtVr0hQr+Sq0ZKKJMlXjuRVPCm/TiPB+Af7wquVKI3U0cPHUArVaY9iOpe0pbWmCQZqmp
	VcJpQwSa9PfNJDKJJuVxilBH5i3BHlnnNspexfZ6MdVi5h0EoCIRK58hvE5tRztXaT+lSA
	1nvvLFS8yLb8ITMmcNXO22KlEMdDzQY=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=BwksTKqi;
	spf=pass (imf29.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759329293; a=rsa-sha256;
	cv=none;
	b=K6BLjLJhFoWSadU5ixkOFNcFywf1KptiDRrrAPl23V1/zbQoheCcrHBiWl04da80oV6fq4
	5hZqLAfGM0K+RRXT8z6uUyMXwXeZgZfrpBrpKS7j9i4n0e/CWuNbIw2MEDStt1wTJTl/2b
	0r5rL7doH7IALWXdtiduQAW9t8gGG+k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759329293;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Ql0X/fS1azakBvLeAJcwxWQYdf/tNZdBt41oVsfxQxw=;
	b=BwksTKqig12d1NGwMYYG2bat7YHIuZOvtQZw8znIFcDL3wdVO2+a0UghqgvnVAkXLneZda
	1mRiU1Bi8lUssIs2SNCs3vsveBOsc7J6Zt/NCkUlkv5kt37rU5QUKdQLYUeXNiJZ2j7rcO
	s7AVeQw28YLRU+3Nfum5/BlS1DHdofk=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-146-xOQsmtJSMlC1K7pjfKOjJQ-1; Wed, 01 Oct 2025 10:34:52 -0400
X-MC-Unique: xOQsmtJSMlC1K7pjfKOjJQ-1
X-Mimecast-MFC-AGG-ID: xOQsmtJSMlC1K7pjfKOjJQ_1759329292
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-871614ad3efso362097385a.0
        for <linux-mm@kvack.org>; Wed, 01 Oct 2025 07:34:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759329292; x=1759934092;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ql0X/fS1azakBvLeAJcwxWQYdf/tNZdBt41oVsfxQxw=;
        b=SuWa5OjaDTfdod0gaxs4LcrA+eIHUZ1Lt0JIBNDsucntWyMfbqMFQSJMFJVYx/0JWU
         x0jWh+bJYejAnWVpQrb7GohOREEVlc084SAtYt4u40j9EvKet9ZyAtGeHpPaLTUMz7yG
         CY9w3aHz+Nn3kYCOvDQxZiZis6FcppFQGufC5R+LPctFu1P+jqVMFSIulyfHR6ny3iJL
         g6mdzxgOukrtNFP0Y2oy0HfBO5/hsRQ9f5GZ/2BJN950AkGKtLS3rnFzwoiSv10smKPZ
         w+9ryy5PzGtddDhf35lzX93XdMsvF4BojCVscdubPrF/iw8Mprrx7zGfR+hUyJOKTQ36
         EL7g==
X-Gm-Message-State: AOJu0YwYlbvBnai0YHb/LuImG7wNABHBrszyam9CQRe4AbzD1GFeCwm9
	7UrO4iKfQkhLrPR5ZZLZCeiIkzSEZHDcPqlRzdYa8z5FiF5OvHYh5b4Bh6tsnDbf96MexqHm/Sa
	WWG+9HvaDbUJN7HVOk4NCPKHZVO6URK3nZsSebwURy0ez985Ivg9X
X-Gm-Gg: ASbGncskNrdtu3Ip21LRO10uvuzzJTuyg96Y8GfX4avyvDVt4pEnNo2b3eKPr+205Mm
	1VNXDft5k+3a9YnkBh65JRHxuM+8kDuU8KLbIT00NkSAt6YAr7rdMeOM66fB0Shj7sCZL/+7Uln
	ZZa/8zQVvErcQ8e8n49N+dWNkTsyep2MPKR3JYt80/kv7RijvI547aIKyfnyEJQSudPwkgqusC2
	OUxITcpPR3N9lHst8TIgmm8NJKwOAidY1OHZ7odk/j8X0xxKabquim9NaYXgwB+tvn96qDPWwgx
	rlM5jAJdpjF+6EFypgPbfJGSmy1pRNBP+7pRUvNHO7xlaNbbA6XA40HwDOKgAbQnZQoUhuhhHGC
	pVKi0j2ni
X-Received: by 2002:a05:620a:198e:b0:84a:f7cc:1eaf with SMTP id af79cd13be357-873722abf92mr512282685a.35.1759329291421;
        Wed, 01 Oct 2025 07:34:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIhe8sT6kZLYr/eFyTULmoSufiW4PQL/CF68C9DFu1tZXtRQ8frsi+7PbF689nMEUKpgsfwQ==
X-Received: by 2002:a05:620a:198e:b0:84a:f7cc:1eaf with SMTP id af79cd13be357-873722abf92mr512276885a.35.1759329290885;
        Wed, 01 Oct 2025 07:34:50 -0700 (PDT)
Received: from [192.168.3.141] (tmo-080-144.customers.d1-online.com. [80.187.80.144])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-85c28a8d4d8sm1241051285a.25.2025.10.01.07.34.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 07:34:50 -0700 (PDT)
Message-ID: <660dc0e8-a23a-4cc8-a9df-bef07b2322da@redhat.com>
Date: Wed, 1 Oct 2025 16:34:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251001142823.4050-1-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251001142823.4050-1-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 0y6sU_G66o9nZ8JRNDHQhzmoC1vKW-an_Xus_PXXinU_1759329292
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D1BA612000C
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: m6s8nxwz8s7ydss1zhskb3gt3hohkt4i
X-HE-Tag: 1759329293-719883
X-HE-Meta: U2FsdGVkX1/JsF/DI8ZeBf30MfzR/dx2siwoSktKEbrcOnmjQ3XzeJWnhLnb1HSUIlkVsL5NYIHZhXE2FIwx0smHHO7pY7O8rrtVz3Bz7Z/T2pbfBr0EuhmSKfKoOWNhVGCe/0WU41X+fuBmgB90AcQK5hmlOrD2GtZoweU5R9RJ/DxVI7pR0qsWlUXtSyUYHJ6LcSUtUVZUHiQuciYnUGXB7n5D42XAXkMnXEDxpREnJHTiAkLPO+BPv6FmEf0867gOThdYkI/JU4IxfV+M15p3hfQawOswi4xR4H/ZmTvre+cTeffYsK2kfT2P4PY8TT+5AzOiPa/bHiDDsu97NIga42DMX4FR5374oLCiO1QW11vhAgFEqdDqRPtyiryRYpVZMikFAyM7wuZAfPEFysoROa97lIZe6rNsXXiwojBVbz8bQPOVnPcnAl5211SV07QpILkkuC2m8/sPyTdr7ENuF/n43k/iM5Su/GZnngEhcxScBNBbtDzmEVBtny1Poz03HVYiDUbefDLuNtxe6KuG1nuylqsq43arCFoTbIlW7g+3rKzoRlHok6JAK4Gl1zW6TC68GWkjndbD5QuvVWPD2vdJEqQPx+fBilJzCk7EAs5+I7lQznfRUh40EqxVKk/6pwpgdD6UxG39oeS6y2vIKz/s31V8whn1oRD3t5j4VPkE+z2mo8BhTH21v0FHdZBqSW7Ka7AAiVcYxGUAee2ukKPz6DbOSQVN08Y0JueqR3POB2khA3qPG9sxUW48yywjTq9LirdszFoy+MYcCXdyEToZKg/UCHNyfm+ysYDPN6ymC8ci5CfsZJNM56Z7cHs3UDjHkjcSxVvI15BohQxuNQCUWgBCX2tLxpMf8BeL7B1SV6mn+VVFiX679UsfgDGiMwdRTYSA/PYwARlwKLZIOfudOYfqzAH0A/7sV407Luw5zrnk84Qd9d0dKa9WZ1gQT5Afd8GAo9aFhlO
 BVZ9joVY
 DeVRZOS+sEktIm1oCz+mW6Ob50r0qizDkBzkc0JMI+69eqepr2n74LfzBO18sHM8Ik/xPQPaP31sGNcgE/CerqFzN+G9ldw7FwugRw4sKEqZRVoAd30NwzSb8ZO5JZFC29+8XpvXmJ0q9o1SOtUVjjKyZA5JWc6IvA3meS6Hao4RS6op4ciJhO8FMnklDQNLOcXOcTK5ZvsSOEh1PQPBt+h3pccupprK0hIniKTY6OmOApLCeG9VXAehkcEL/C65EMkKyBJ+qmRV+vyOUNFVWq/h0ePgci6qYZCr2I8o+PtLz+E3xP3DW+9F1MW2A0QhmvY7BIZUY+kMWT7d7T3Gu9PGhlABnCzdYiRE9QMx7T/tTuvD5KQfgZfy1Md9WQBKbiB1CpRwAy7njzWXTLynUs1JioynNWF6QS5+BIhLE4nVChoOh0bccWlReM6UyQw/cRrnbxVZWT5p3kDePNoa80mccQmZL0rREj0y5nfiQUyjOjn7Uwn39XaPudywfJDcrRboNiAhc4d0SUXZfXTIfdvstodt+oxXX8s23dpFYeLGKWja0QbFx1HE7jGk0JaX2jNmUJxedcgK0GpUN+C2G00A/6Ht4ZKW8FShwLi9i/fJGH6aW/OAqRR8w5y2Tj3QU6jFv9J/44JkS+03MMWNbNGmiGxW3R7E7Wbk00+QU2xzjfQH8E6PnTQae+j+bL9CxtQ4Ktr24J30UClVkcF/KIaCj8v/xzFO23Mj4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.10.25 16:28, Wei Yang wrote:
> We add pmd folio into ds_queue on the first page fault in
> __do_huge_pmd_anonymous_page(), so that we can split it in case of
> memory pressure. This should be the same for a pmd folio during wp
> page fault.
> 
> Add it as expected.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>

Fixes: please, and I think we want CC stable.

> ---
>   mm/huge_memory.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..963cba933cb6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1878,6 +1878,7 @@ static vm_fault_t do_huge_zero_wp_pmd(struct vm_fault *vmf)
>   		goto release;
>   	(void)pmdp_huge_clear_flush(vma, haddr, vmf->pmd);
>   	map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
> +	deferred_split_folio(folio, false);
>   	goto unlock;
>   release:
>   	folio_put(folio);

Which raises the question whether the deferred_split_folio() should 
actually go into the map_anon_folio_pmd(). I think you should just move 
the one from __do_huge_pmd_anonymous_page() in there.

-- 
Cheers

David / dhildenb


