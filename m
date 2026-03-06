Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13479F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:48:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280346B0092; Fri,  6 Mar 2026 07:48:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22D056B00A0; Fri,  6 Mar 2026 07:48:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D7B36B00A1; Fri,  6 Mar 2026 07:48:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB1496B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:48:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6D35413A5E8
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:48:49 +0000 (UTC)
X-FDA: 84515617578.26.59D27BB
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf04.hostedemail.com (Postfix) with ESMTP id E5B7740013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:48:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qJl9tLI6;
	spf=pass (imf04.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772801327;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bMQYOYMXLfYYqfrzv9J2aTP1fDeqWn0su8Gslng5WAw=;
	b=BAKcjzYnDsZ6ZUe5Yz6GznyQ9GfJ7GqEp9wtkHwf9tOHtDYadAzb9WvBZtEibH7zSHFuqh
	34tm6rQdxbidyKWHr32gINO1aLecEkN0PZZpuOHp9FoCyIoBhKiJZ6uWWVfE0gjPFdr4Ja
	EL9vCTd8zsgPPMojA4UMg0eCgtjlKHQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=qJl9tLI6;
	spf=pass (imf04.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772801327; a=rsa-sha256;
	cv=none;
	b=boRJhm9iL8OMKw9cRrMQlYchlRqBkq3gj4jueZMONljE0bD76MQy7xbMDDfblkId/x7Kzz
	LihFf9P8JPm3gHPRyrS+3DqhHXxn26Vf1SMHwSzqtfvzKSOcVFkQesdVOTnYgoQ+pfO4I9
	I9OEwllizZiWWa1u+MlTiO0ZaFV0WmI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772801327; x=1804337327;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=bMQYOYMXLfYYqfrzv9J2aTP1fDeqWn0su8Gslng5WAw=;
  b=qJl9tLI6Hmyo/cvynocC/dXRUh6jTzwgUewXZHe5Qx3AqbGjsC/cvgHe
   GYoZXOO1tUCAOOHHOfR+Q9AO0pYhzUQCBYe4g8OUwMtZPU8+mNmklmL1X
   6ifSEp2IHSGmA2Hzq1YxFJfLl2A+gzoDp+LWtP932fRUaBKSdIqSocb7K
   84GfU5suoK6/w2pac4s/CoUj/ce6Ack1D+uodCJsgwqOeAIYjB1rhzA9+
   qzT/ArGvxWtrLw4J9sxk/meMNDwTYlRwRB4OPeH2VvkKNXhOJR9KrmMA6
   eSITT6cdyNGNGTSbyS0SKMWH7iodhFgbkfXgOsA0VYTtMtQ+ZlqoTB+Nl
   w==;
X-CSE-ConnectionGUID: Yx/EHmQHRFy5mQfbcc7SOQ==
X-CSE-MsgGUID: vFI11kARTzO+6Dwqg0rWgg==
X-IronPort-AV: E=Sophos;i="6.23,104,1770595200"; 
   d="scan'208";a="10334043"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 12:48:42 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:9741]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.189:2525] with esmtp (Farcaster)
 id 782955b1-d49c-41df-ab22-e29b6a3853bb; Fri, 6 Mar 2026 12:48:42 +0000 (UTC)
X-Farcaster-Flow-ID: 782955b1-d49c-41df-ab22-e29b6a3853bb
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 6 Mar 2026 12:48:41 +0000
Received: from [192.168.2.180] (10.106.83.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 6 Mar 2026
 12:48:36 +0000
Message-ID: <92fcec4f-43f9-4207-8472-eb94874f2efd@amazon.com>
Date: Fri, 6 Mar 2026 12:48:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v10 01/15] set_memory: set_direct_map_* to take address
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
	<andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
	<jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"prsampat@amd.com" <prsampat@amd.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
	<gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
	<urezki@gmail.com>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
	<gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
	<jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org"
	<pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>
References: <20260126164445.11867-1-kalyazin@amazon.com>
 <20260126164445.11867-2-kalyazin@amazon.com>
 <90058ff2-9dea-4090-b2e6-da4c3cdba81b@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <90058ff2-9dea-4090-b2e6-da4c3cdba81b@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.26]
X-ClientProxiedBy: EX19D002EUA002.ant.amazon.com (10.252.50.7) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspam-User: 
X-Rspamd-Queue-Id: E5B7740013
X-Rspamd-Server: rspam08
X-Stat-Signature: fdss3tnr7cky5epzytrue15tdk74atkz
X-HE-Tag: 1772801326-17593
X-HE-Meta: U2FsdGVkX1/J4uoHND61vIaPxoSmcI659eVmCgHb0dkZ0mgVUrpPVhFhjly4WB+rpeGVNHLnVkhoR5p+40Ao1CrG+AmEh/nBkRdSt86lHYgb5j1WrYZroOA6NhNMV935FIghlLhoQ4qs8dpX3ekDuLQBnIfvk87L+fUcUPVs7UCBvwxaUumUqtHHKFo7ghWN3vUfpb208HhZg59uCBQWf4VEJchrNjDaYVHRoARcT+3FyrIIbTcZbl/JduQyKK3XzEus2YYkW9821PmYPWZdhY3zkkk8kb0rp7unKUpuIDZ5BwtB1qxi57doXOKkA+TB3W8n2xMKQWyUBrBRpFSdrAk8bKYl+OW9F2vo04cqRmLDO5Z4rIjPmh7QWgLXABZZozfosdyOXmeaTMFckUO+g5A4j85cZTowSqc+FawZYNgLnWtkDk+AmTpRJGM6Hq6zHS4nwfNkr9BOiwrpd9SE0uc9l5yFqf0/Js21i82F3KODse1I4R0YOdCALU493PUqnyqqfv5YMq+f4f8F4O0dXBrTko3cmbJBa1rAiaKivYEvSix8As/tKaqy7LjPTGykSGuq38Qxb0LOxnpnZd0HFY8B+gznGpQ71nAvkp659wFR9YW5BpnznQUuK2XPKKlV8G6IHfaaUjazs1PrLoJ8DAUwQ1Qllm7Ytu3goTv9MP7AOGgVCFPAJEmdkFjI773hNWA882CiM9X+2hHURN71ReYDWoXgG3GL4+gJRC/k1T6+vl8Nn1ciSK+m8lUhJmFjGjkzJE2xCI1FIbigXGGb2Y5EmlZ5eFbyBKsXa/enbpUmay9CwCQG245o4c0ownHGKL3/s4fL2dHLPBSZ01kToAmVN4n5UfYP6R89Ek/xQ1+fxXXiRDC6+DyhlhY6wj5qHSIQDXDK9YNGMfp6IsVDOaSr/KqC2RP8I41C9YmZpxrhTuP7DOoDCWlDkE+aH3NNGikqfuNIZRx1LUamAKP
 A8BPOJJE
 CuRTJUcvOORXEsmeLAUc1UTdlvQxCZKEQEsysva13I4jyAZMByN/i/tN+lS7bVD38oo5CWj0CpYJ5I7LLyUNUk/4/aOn3jRD2LO5/Frns/4ABAFRjVaaO1tkrOr1W7zn3UpJW7/zfTBn7TVJR+ZF9krPAWgd2x2Th4dJJKAqk0Zldpv4vjMbiRJn3XrsjKopXOZcE4syjWgGA3s/epRUGM2iFFP9YU903iQSZpXW3fMsMq7Z+PRrzlGqBG/NgEiCPPviNOck2JLqHPDJHXTgbRhRXUyWY4J/in3XFyGiuLS5IkcOlYet0ce5g+PMEZDlkJ5tg1svN5JTkkzwL2mxDvHeluI8oG4kyYtRBcwZHk9qlNxzJipSgonMOyzmHE16x1RmlpMp232qgDWOFVX3hDWNzTeBcWpdSDDL//vngVJIw9wMrG94D+ar51097fHUbG+vz/t+rt6K8aHF9qv7IZP54nA21By454U/xKS+NYWJO+PIgIJqGBA4Rk1E8qwiYmiNr4gU6WHw2RYqYyloIZXPtBCifFP3DMdF+ZqulMjTe7xXX6e77iw/cIdPl2uJbEjrCfrOiM4tIKYZMA14Na1FNazbdfaeAcVaeZFCn+HcFnDj93+b8LIbAGXjmGqzA8zQN5kWT7DabAa8AEZTI2oVvxNBuNNfB+b7PxkbqPK2nWzpZFQ3ne0cUQuL5JEftEkbW70NbnKpXsCd9vD9WXhJCjBsbeqOoRzq76Vtx9DNlFwZH9JGBFdm6Blna8rWo7+xqkikv54tH/BuS99cStBIx/IeTCdB13uXxabfMlvD5M2Di3ktcd0EHY2Q9uHjZ9V/gmDi4bChoGMEsbK9eQJ97HvKaROJYWciQeeDaHGHSGd4hQqIQ2BPimu1+ui9O5tVBcy4H3fq0nVvegndQ/3NaXAF72JmODkTjmubgBcGFJqR9h6cgdHv4NJ2f+b+XpG7SqhtnMz/iaPBjnx+7r3wSZCGy
 y2kjtplN
 lmYJJXUt7I7ziVwdSck0oVRAOjZ9zp0i5PKYrdhu7++WDiiPuTdnHpN1jeA5e2gIFPJr+8A9W366fFSpVc+tRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/03/2026 17:23, David Hildenbrand (Arm) wrote:
> On 1/26/26 17:46, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> This is to avoid excessive conversions folio->page->address when adding
>> helpers on top of set_direct_map_valid_noflush() in the next patch.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   arch/arm64/include/asm/set_memory.h     |  7 ++++---
>>   arch/arm64/mm/pageattr.c                | 19 +++++++++----------
>>   arch/loongarch/include/asm/set_memory.h |  7 ++++---
>>   arch/loongarch/mm/pageattr.c            | 25 ++++++++++++-------------
>>   arch/riscv/include/asm/set_memory.h     |  7 ++++---
>>   arch/riscv/mm/pageattr.c                | 17 +++++++++--------
>>   arch/s390/include/asm/set_memory.h      |  7 ++++---
>>   arch/s390/mm/pageattr.c                 | 13 +++++++------
>>   arch/x86/include/asm/set_memory.h       |  7 ++++---
>>   arch/x86/mm/pat/set_memory.c            | 23 ++++++++++++-----------
>>   include/linux/set_memory.h              |  9 +++++----
>>   kernel/power/snapshot.c                 |  4 ++--
>>   mm/execmem.c                            |  6 ++++--
>>   mm/secretmem.c                          |  6 +++---
>>   mm/vmalloc.c                            | 11 +++++++----
>>   15 files changed, 90 insertions(+), 78 deletions(-)
> 
> [...]
> 
>> --- a/arch/loongarch/mm/pageattr.c
>> +++ b/arch/loongarch/mm/pageattr.c
>> @@ -198,32 +198,31 @@ bool kernel_page_present(struct page *page)
>>        return pte_present(ptep_get(pte));
>>   }
>>
>> -int set_direct_map_default_noflush(struct page *page)
>> +int set_direct_map_default_noflush(const void *addr)
>>   {
>> -     unsigned long addr = (unsigned long)page_address(page);
>> -
>> -     if (addr < vm_map_base)
>> +     if ((unsigned long)addr < vm_map_base)
>>                return 0;
>>
>> -     return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));
>> +     return __set_memory((unsigned long)addr, 1, PAGE_KERNEL, __pgprot(0));
>>   }
>>
>> -int set_direct_map_invalid_noflush(struct page *page)
>> +int set_direct_map_invalid_noflush(const void *addr)
>>   {
>> -     unsigned long addr = (unsigned long)page_address(page);
>> +     unsigned long addr = (unsigned long)addr;
> 
> Are you sure you want a local variable with the exact same name
> 

You're right.  Thanks for spotting that.

> ...
> 
>>
>> -     if (addr < vm_map_base)
>> +     if ((unsigned long)addr < vm_map_base)
>>                return 0;
>>
>> -     return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_VALID));
>> +     return __set_memory((unsigned long)addr, 1, __pgprot(0),
>> +                         __pgprot(_PAGE_PRESENT | _PAGE_VALID));
> 
> And cast it to (unsigned long) even though not required two times? :)
> 
> I assume you wanted to get rid of the local varable.

Yes, that's what I meant.

> 
>>   }
>>
>> -int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>> +int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
>> +                              bool valid)
> 
> 
> 
> Nothing else jumped at me.
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks!

> 
> It would be good to get some ACK from some arch people that are CCed :)
> 
> --
> Cheers,
> 
> David


