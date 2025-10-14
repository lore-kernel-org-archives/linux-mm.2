Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 69E95CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 08:02:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFF568E00BF; Tue, 14 Oct 2025 04:02:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB0308E0005; Tue, 14 Oct 2025 04:02:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F428E00BF; Tue, 14 Oct 2025 04:02:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 962108E0005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 04:02:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3B78114077E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:02:57 +0000 (UTC)
X-FDA: 83995978794.28.9B26361
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf11.hostedemail.com (Postfix) with ESMTP id 216C740012
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:02:53 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="eb/GORzl";
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760428975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlDf+zwrURcQm21l6Scgpbjz72AuPJ/cB5VNPLW+EMY=;
	b=31MA/tFYpFYnn32jjQC0CZemUF7UPjI7RZVGq48SodOpXg3s0PmTjeC1Zo7NCdCnJAtIOh
	8HZ9kdKC9+74wY9GA+k9mN2QJDvgi3fTy9Tfl1Ukhyd26GkChve3p1G6uKpU8BcA6Lk0mf
	mnjRTuBmux5w6ZU59WRgi638vbtOlW8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760428975; a=rsa-sha256;
	cv=none;
	b=o7oEhZT+wmgtVx6e8ULew6KW2fwWD7oNdM9XzH8dHvYYYrXTZAG4MTSKGq/7+frqmMWm/9
	mvFeNjbbtyuVyTMZ1/21Jlgcsv1k1ag7WGabEJchAtvXfDzy75whSKct0PeoGHAejut1Cq
	70wZM94Jx4fzFW3hCFfWD/zvVlRbpKM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="eb/GORzl";
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=NlDf+zwrURcQm21l6Scgpbjz72AuPJ/cB5VNPLW+EMY=;
	b=eb/GORzlrdKoN37rQsNAN+feN44oied3icYmZG8gcTk7+ogEqCe49oMlhxGQQz0erew5o143u
	9gJPoPtqtDzIWXPj14jyfea9u9Z4RNZmd9KbOudYcb8BrwzxoTgvjmTjMMbAoWKmkzBMcZGGxyZ
	Oj31Dmt37T4gJx6U2VT0aBU=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4cm6Bs1LrMzmVCw;
	Tue, 14 Oct 2025 16:02:29 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id C7ED3140144;
	Tue, 14 Oct 2025 16:02:48 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 14 Oct 2025 16:02:47 +0800
Message-ID: <364ceb89-6327-498a-9582-bb1fbe2bd98e@huawei.com>
Date: Tue, 14 Oct 2025 16:02:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/3] mm: mprotect: avoid unnecessary struct page accessing
 if pte_protnone()
To: David Hildenbrand <david@redhat.com>, Andrew Morton
	<akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	<linux-mm@kvack.org>
CC: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan
 Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
	<baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	<Liam.Howlett@oracle.com>
References: <20251013121536.2373249-1-wangkefeng.wang@huawei.com>
 <20251013121536.2373249-3-wangkefeng.wang@huawei.com>
 <93d00bb0-8aa7-4f52-b9ba-ef777ec191dc@redhat.com>
 <4469b9c3-3656-44f5-897d-b024e030587f@huawei.com>
 <93736a75-3fc5-47b0-8985-96e1b0b98b8a@redhat.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <93736a75-3fc5-47b0-8985-96e1b0b98b8a@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam05
X-Stat-Signature: 8t78dbfq17tzyuci9nam165qbhwpdc1a
X-Rspam-User: 
X-Rspamd-Queue-Id: 216C740012
X-HE-Tag: 1760428973-795494
X-HE-Meta: U2FsdGVkX19r4rvmZ3UICus77dNAlks6ydCKQXCQ4ETKTzkMnthtJW0otrxa73Mdb2twvACZfumXoVpJiLFcMTZo8lV8BCDH3qm5MhEu0DGeCbrgx6jUb3bI0FlwEl4dbcnpSyaBY4lDtQsG9525jCu3hMtGxeClxeF1nJ6EsY7/QdamE83b/kNEbdyN6cLbBanzJLJDZX1qwEhMtpDGCWeASjk03ndpXfc5kSYwuKhxF7mB9mmGZje/m5TOZn/WGy1D5Cxge9tF4G4Bc7fhvuotDv32a3KnlvNTElltAtuwkg6/fA04XzHxEvzAYTGzfVGWKazXM3oKM3cyAEA5Als3YhvKaO67XhVfL4+6Zh94ezrzRb4AH2Dezgj3U0GHyF3tnpwTA0kkWQj3kJnestMzCvaKYQ9NpAGkuHbrQON5KG99c3HZr5SX0rf6qNZmHVsicKO1jiVAEWJYAs03rQ6OsumEVXr/LWJe4DR9wTe6WAx2ou/Acx5nvZJdcdJjOgzUdiZNuVrlCKSdb2/I0bJ5dNCKzEZT3ioXj0rMSV1dj19zX2ghmgbi0lVrM3c3hSQC1xDr6A8lRJ/cbNxrwahjX131VNoOIW/qLyVxXuw7h8MnrRJBdjGO/KFqRBzy5clfvWipjFTeqiCo+6v086xtoxJB52uTej83qg3BvPTMdm5Ou5YQiC+mkmJ7eS90bDPeEzlhT1F9H7unyrXXREVSKrexPv7Y9HJGRdyWx4UNQI3lZ/O/3GZ/tOflVSfb6rvoi5MO5NSk7kEu5kZWC0SR0Z7E2B2e/zIRFZT6Mar+w6QDPd6HTP5VdH8wkEE0FpvM0oXFZbjJ+LvSUkcMxcPTBvklfOtHzIRm5AAfKQdtFw+eD6gTgpw1hc0jg9JfzvUyALgEJzOQf9dddIkfNaw86yzP+mZ0PJ7Jizn2Em3npFbYvHPPJ5skuVnECbHJ4is8inNbXX5DiWfwYPb
 0ckxh3ih
 y7mtlobnMvHNpGqzujzms7cXTWQXrFS+XHwI8J/BT6MOOKcdvlA3lnzfGU7nTAuq5pD4JkojBFNspSL2e1ir4JclUfhx3UuCHJflDqTxblz8ZwzKo1WQC5RKoUjYl7OdwOBM5n6o82ahXwcPe+gNmUOMPoM73I0ayxAjY5MYMXR0R/BvB2mtJpx+YoV8pkgIkJJmi1nYHrRgM46Q9hYrQAr6qRTPlcq4rojkeY47JsY8nszI1uQQ7Hpd1uD+5VULWYKldglKg8fhXrccS+xSpNbIFjUl04RhCCSwaI053RxcT7twKlC+3O90vO3rFumtdMeXevSccuQqRlVxPObqeg3PbfFpfCZTedLBYm35uAcWyj7KKY/n1CXP2sQG0Tzd/sRn2g8T2tzRdLyEX6dar4omnH9Aew6JKHbFFKsz7Rq4QbQEEtTK8RbOjMg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/14 15:16, David Hildenbrand wrote:
>>>
>>>> +            if (prot_numa && pte_protnone(oldpte))
>>>> +                continue;
>>>> +
>>>>                page = vm_normal_page(vma, addr, oldpte);
>>>>                if (page)
>>>>                    folio = page_folio(page);
>>>
>>> I could have sworn we discussed that while fixing the prot_numa_skip()
>>> fallout.
>>
>> I'm not follow the thread, but we found that vm_normal_page does
>> introduce regression for mprotect benchmark(libMicro) with
>> this vm_normal_page().
>>
> 
> Right, I raised it here:
> 
> https://lkml.kernel.org/r/aa496798-5ac6-4cb0-bdc2-91515172e935@redhat.com

Thanks for the links, let's fix it now ;)

> 
> I questioned how relevant it would be in practice.
> 
> I'm surprised it shows up in a mprotect() benchmark: mprotect() itself 
> would never be able to set MM_CP_PROT_NUMA, so the code wold not 
> actually be executed.
> 

Sorry, my description is very clear, the regression is not about prot
numa, I mean the vm_normal_page does introduce some regression when
mprotect benchmark in libMicro, before cac1db8c3aad （"mm: optimize
mprotect() by PTE batching"), we only call vm_normal_page in
can_change_pte_writable(), but now it is unconditional called and
10% regression in some libMicro mprotect benchmark.

We could add limit to call of vm_normal_page， eg，cp_flags
check, and using pte_batch_hint, but it is unclear whether it is worth
doing so.

