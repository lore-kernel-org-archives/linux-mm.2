Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1479C55196
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 10:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24936B0088; Fri, 20 Feb 2026 05:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1C86B0089; Fri, 20 Feb 2026 05:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB3A66B008A; Fri, 20 Feb 2026 05:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AF4046B0088
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 05:43:18 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3AC1D140C1E
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:43:18 +0000 (UTC)
X-FDA: 84464498076.18.23889BB
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 824BC180002
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 10:43:16 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4Rdg48R;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771584196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lOTSyKS7v1pB8BGMmuAy1KIzWpJRl3+1EGlLKkiwmgY=;
	b=GeeZGm7RdJcRTMCkoN1gIYd0u+6wPbGk+MO3umAT03kbfcAm+qkNlKRDCDNxtVqF5gngUV
	KmMUNRv9xkQ4LvUTDq8uGPnIA3znoqCkxla37zNHHpfTERjoC5DiFe7mklBSC6byaFuD7o
	OdAqt4OO7nHZ3xQ6rRrFLIoT3C8kTA0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h4Rdg48R;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771584196; a=rsa-sha256;
	cv=none;
	b=op3sWTEZcKTLgdpKsgrugUG5DYDmNLeMEUDBv5ET9JsxryEKcfZSgaXsBBobmMFucgasFj
	x1PiyKDrZ3UWzc5E9Qe9IIqWRRkYmeR0TutynOkwqDsCoOXvDk6Ue/XpjWxjAM2hos0qtK
	B8mM8HCLQ0w3fxZK3hxOu1esxhln1Ug=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5787C6185C;
	Fri, 20 Feb 2026 10:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C728BC116D0;
	Fri, 20 Feb 2026 10:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771584195;
	bh=Yvu77UXexzu7sZa0hKrXXXI2ScqTjgPRW4bmvkkBJQQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h4Rdg48RMBdTsnXg19agUNta0otbn50YtUgDABQpHPFM2VJDqCrGZiYR05kFA6H8R
	 vUjP0E67Jt5n/RKkfwG8ypfiGduTgpnus1XeBgjOXpHhyyzNcQEf5QXJN3y8bkJUtj
	 E2279EUMv99nJtCLRuGwPwivk8uyyLKM3VhRkz11OXAhlFYWkcmsu0CSUmPQG1Ht66
	 yu7qlHs+e75gj7+AeSlAogxzfhLJhQzzEb1M5eLQmnRF9JhhAC1djj0a7jhhAiuh9j
	 C8/+zAl7YyDw4XT8rEZ/egq4W7ei38WDxn1uTLL6RvglLCPRcB6zH/w03VXpliGhhE
	 ucFk7lxuD2udA==
Message-ID: <8bb7d240-31fb-4cb9-a3f6-ac81b8b9beae@kernel.org>
Date: Fri, 20 Feb 2026 11:42:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable v1 2/5] mm: introduce is_pmd_order helper
To: Dev Jain <dev.jain@arm.com>, Nico Pache <npache@redhat.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Cc: aarcange@redhat.com, akpm@linux-foundation.org,
 anshuman.khandual@arm.com, apopple@nvidia.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, byungchul@sk.com, catalin.marinas@arm.com,
 cl@gentwo.org, corbet@lwn.net, dave.hansen@linux.intel.com,
 gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com,
 jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com,
 joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev,
 Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com,
 mathieu.desnoyers@efficios.com, matthew.brost@intel.com,
 mhiramat@kernel.org, mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de,
 rakie.kim@sk.com, raquini@redhat.com, rdunlap@infradead.org,
 richard.weiyang@gmail.com, rientjes@google.com, rostedt@goodmis.org,
 rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com,
 sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com,
 tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz,
 vishal.moola@gmail.com, wangkefeng.wang@huawei.com, will@kernel.org,
 willy@infradead.org, yang@os.amperecomputing.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, zokeefe@google.com
References: <20260212021835.17755-1-npache@redhat.com>
 <20260212021835.17755-3-npache@redhat.com>
 <784588bc-2071-4418-825b-9072cc3659e2@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <784588bc-2071-4418-825b-9072cc3659e2@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6npicdmhf9rtchjitpdq543p4umf7a61
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 824BC180002
X-HE-Tag: 1771584196-569289
X-HE-Meta: U2FsdGVkX1+GVagkAjaI6KiIA9b1lNxqAdq5k5OrplnIJA0QT52FtlVNwt9KBJcSutGBAqQj4Ndy6p2lcdpVuDNtW7gb2/uC/NPs7ta2nmak9mqJ63DYYtCxFyX/uvqYuA+PYxp0YSvzNqF6p0wtJ+drJLZRQXG/0pmC1BwN12UOqxLp+2oJ/+nn10n/+J3JhLh4m2LRp+CYBHf3ZGT6paZBZ+pWgwW0WN6fURFO0YGQCN7j08BgVJplwH8mwVL0peXwXNI8Hss4963IsDxLuVhLTvsY5827jRC0AhPtvNnjLYLM8TV5NEoph/zYybUEDcFUXOD4nAXiP8JNZ+Ow/kQjffuBVIqlOFmbHraH//PIhoLNCUJAmH4WjP/oJGQvfDEUUVkF3NF3pdKFUSWUH1CyiDtigMbURt7/2CXwkJrjEs3egKjWTDRSQ9CH8dvnASmjMVjxhkyzfZEAP6siy6GR1+IvtUZ7YBxMuOOMMzJGJLTuoseK9znLyMVN9fASL8JFbfK6seMFvSkRxBtAe5FiBkvzRj4/T6gDwfxajLcxJiKIoENdoctcbXuSPqvCFAj7PVEzfxjs7ru6b0cDpC1kCYJqDxj2dHd7lEAjLqO1LIcQspxEy4xkINABAuCOkF/UEuAFnsqEl8SiLpcdirkcPBos3QmpSoysne8rjh7f6wXk6Sd+DqSvGSfpqNhzbyqsVDg9Dk41DedilG4gLFLNy1kAw1czWLHJ4qv11xZcuflFouZ5wSMev99+OqJPTSqn79NfNe/0Tu/EuR4dG9d5cTz4doPF/ADpj3N0uCMyCZJyyD1BJWPapMazgEU83ghQQbur/lBZCV+qiQ7KFostrdGjEJFFLj1Y9aWOKEsDPDuKH8Sl2d4au1OYyGOzM5ev5/cSm+/L1irx2FZUnggoyEtSRyUQsuKKjroemvzf39ScD1HOXXrYkMPI2Ic3iHuGLcdwqYp2eVGFBOV
 32OIjbe8
 t1m5OCwraBt67YkOwyl2snbAp1Zi0TfbRGAvMFFbgjHNBVsgSq57onrHkUmkVdH8eSTk52WEwpaMPqIVQ7lcAEN3UJ/Mo2Vt7fCWQ9bOt7US56l0zhTsiJ33YONhkxsqdXPa+xwYz4dGIfbYlLc47KJOOJjGYTlOCvmS9O8bsBceTpv08Rtp37uD94WHyZ6BGbC2LXCGihtls1yk3OkIuWH5EB7+2NaDHfLJi4u1DfMLKMegYdgBQ2GVyycH07M0EmH71hojdsfkjoDV3R1oC0dZnQzdK9T58eG1Ak4wxySWcTOtzrf1ZV2sFX/QxWbLp5pSyygjN0sL420MXfpxliyCQFpr1BjCMDZW/HErGqDFiip+iI+1cozkiwq6x0CVXBIs4WGguwlftU86WOR/S7cFNv9pp6tMnzggT8XLXenjFxzk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/20/26 11:38, Dev Jain wrote:
> 
> On 12/02/26 7:48 am, Nico Pache wrote:
>> In order to add mTHP support to khugepaged, we will often be checking if a
>> given order is (or is not) a PMD order. Some places in the kernel already
>> use this check, so lets create a simple helper function to keep the code
>> clean and readable.
>>
>> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>> Signed-off-by: Nico Pache <npache@redhat.com>
>>
>> arches#    pick b3ace8be204f # mm/khugepaged: rename hpage_collapse_* to collapse_*
>> ---
> 
> Thanks, this is useful.
> 
> In drivers/dax/device.c and fs/dax.c, we have order == PMD_ORDER check,
> not HPAGE_PMD_ORDER. Therefore,
> 
> 1) Do we have a bug here, in that these codepaths are fault
> handlers, therefore should be using HPAGE_PMD_ORDER since the
> definition of this macro zeroes out on !CONFIG_PGTABLE_HAS_HUGE_LEAVES?
> 
> 2) If the distinction between HPAGE_PMD_ORDER and PMD_ORDER is real,
> then the helper should be named is_hpage_pmd_order?

HPAGE_PMD_ORDER is weird a stupid legacy leftover IIUC,

The only thing it checks is that you are not using HPAGE_PMD_ORDER in 
code that might be compiled without THP support:

#ifdef CONFIG_PGTABLE_HAS_HUGE_LEAVES
#define HPAGE_PMD_SHIFT PMD_SHIFT
...
#else
#define HPAGE_PMD_SHIFT ({ BUILD_BUG(); 0; })
...

-- 
Cheers,

David

