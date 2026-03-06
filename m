Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF1C7F01832
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:49:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 033A26B009B; Fri,  6 Mar 2026 07:49:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FB16B00A1; Fri,  6 Mar 2026 07:49:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF8D26B00A2; Fri,  6 Mar 2026 07:49:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC9E56B009B
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:49:05 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 68D3F16054A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:49:05 +0000 (UTC)
X-FDA: 84515618250.08.F7987DF
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf10.hostedemail.com (Postfix) with ESMTP id 144DFC0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:49:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="r7UnFV/P";
	spf=pass (imf10.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772801343;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CYNmKAIYLANzYIpa2I/xdJ5H5+KpVyo7DXkoAl0aOOw=;
	b=GFBGGBV0Gq4oVvJsPaFkf6GDHMEyzFjWbx2n7JFPhVUmRDzrKMTmE6pIDs4RoDfRDXgoGP
	ZA0Ppgc1KBMQAw2roAOUf6wlxGpCp1/J0nckbiKsPclamBJEU+tVwgrGkKnMoeZkaaaT3E
	Wplxu8X569DT94BMysAW0zIg0Q2GyJw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="r7UnFV/P";
	spf=pass (imf10.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772801343; a=rsa-sha256;
	cv=none;
	b=cujJ0uCgvrsLjS+LdFx7PJv/+snCb6l4mpVOYPHqyjEVoslrBJJsfK1AHDr9LU+QOTXX18
	jDRz1EN4JaCN29V0F7lBAjReGowuKoh5g5a9KwumXIcU5ZURZLaECmNxkFLGeOFrIdfoep
	XNkMSYc1jvWusJAvxvdD4s6yWIySi7M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772801343; x=1804337343;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=CYNmKAIYLANzYIpa2I/xdJ5H5+KpVyo7DXkoAl0aOOw=;
  b=r7UnFV/PXFB5+dJFVwBsLcp3YKgXBRfZYshqG7B0JiP/Hmy5uCO308N1
   RX31bgZSj3FM893ebOGZyFxmp+K5kvhirMxg67pd+gEGuXX5+FoZ3CYSh
   pAGYqBqRjhIeRnw7rWT880BN9MytboU96PkFu8ZmgTLEdgy98jZA71BzP
   QP4su+6r2C4bEywOJyfuN6Unzxs2avegsOVvIgL9Jc7Mwe2nASs2IgrU9
   IYCIrIavHIRllfex2w34mS5oHLIU0aLVd4TpFDe/3K+zNCElS0cgbA6H/
   MRtye8zgz2ER+AqquMC/2CbbboIw2U0czPa6CDm2E8hdZq3Ybuzfu/scd
   w==;
X-CSE-ConnectionGUID: tyGyI/djTA6pJNxUDqgzyw==
X-CSE-MsgGUID: I8l7qS2EQbS3LpyAB/W9cA==
X-IronPort-AV: E=Sophos;i="6.23,104,1770595200"; 
   d="scan'208";a="10425965"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 12:48:59 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:2354]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.24.155:2525] with esmtp (Farcaster)
 id e48020fd-6821-4580-89f4-8de4f43de7f2; Fri, 6 Mar 2026 12:48:58 +0000 (UTC)
X-Farcaster-Flow-ID: e48020fd-6821-4580-89f4-8de4f43de7f2
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 6 Mar 2026 12:48:57 +0000
Received: from [192.168.2.180] (10.106.83.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 6 Mar 2026
 12:48:52 +0000
Message-ID: <e2834fd9-e4ec-473c-90cd-6c3a5049747f@amazon.com>
Date: Fri, 6 Mar 2026 12:48:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v10 02/15] set_memory: add folio_{zap, restore}_direct_map
 helpers
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
 <20260126164445.11867-3-kalyazin@amazon.com>
 <af2d4dcd-60a8-4a5a-b508-d9600b1f2275@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <af2d4dcd-60a8-4a5a-b508-d9600b1f2275@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.26]
X-ClientProxiedBy: EX19D015EUA002.ant.amazon.com (10.252.50.219) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: osf86kuwqpw78hea45msawsqdfgqmdc9
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 144DFC0004
X-HE-Tag: 1772801342-104279
X-HE-Meta: U2FsdGVkX18HksXMG+zV57Pc1uG3s2U9cXAsiHeX4yDZtXF9y/H+VSUBTyhWFSYFNFli/FyS8BewcpArdE0MiZpLNn3izmQOGfGv4/D9DT0230YQzR079GyGMZhgetjV2yPYpsQyZP1elvdQNg01otbRmZR8Bl0w5KLAHp8sgP3lp6ZXoNGdhGEwQZWO+KWRgTUmzEvIsJ1tGNHk3ZJuE/miLn5phKrlX4fYYAJy0/ZvuVpWSdHZ8KmOe0HAzq1Mg1jCQELMIg9ELrIbshXdQyJ7jt9e9L92DCTUL/jB1JqFs8YGv/REOwpsI1hG48+FK2AkfY2JCjS9XBvUKvW8fehWKCdJNTU084M+1TbBg3hZDR2kwb2YhliD5KY4pW5ouayfwRN+V2dBI4pnv5H8IpDSuGIvjQoBiFChlDnP1F5lJuFhnWLH+G28tfa8dvjy+O7gjNYE0v4j/WXrfMIwfFNF/iYpjJerQtZpzj/NRyYIpqJ5n6x4tTGbhqWtn99/CsVJS81dvI88WSGdYxQnbk+46EauyzhRQVIsia4XOpysHG7ZNFfFgbvli8yjJfLh1+Q12CiGi10Fg0LVVvvNK8Ds+TVPfqq/3mDA927xVdka70RB96dE6u00dZ16UJkbNHm68UizbTNjUzRiClYw6C0s8DsK0EDMDUSLbiCNqnjjRYd7TinyHPO03DDNaisryymXh/kgEm6FVSVxYmT6YgJeDASO61gMQksqNd5CDP1ltMdvDMPo3SPCr8gnX1cPGN2vieF/cF7o4gy548a40oKJtI9T+MCipndPUyalIXCRk1Cl9eZ8J9pWCxEm2pD191PQe2hyWbhwiJ9B48cUq6hhnkiVyULFj8x+qtZphZo8nwnWfMWmScUreTkdBUrR3PeOVVRCAyw4a0EzQvCdYlujB/HbPtl5VVk60Ab7VggKYGmT7Or3bmc0qYnRPZAyMBO7IPX+GwY4RsB/9su
 VR0cTWz/
 txr8xj8mVQwVl/DVYNb/csQ2bXoZDaC711J9LKDx4oOFaoUj4bxctNIWo4rzpl6PPQC921eQoWyoTWsRqg7iPtrGAYDNsxSTmxzeno0JIxKQD7SAK4hIWdlIMZfv5FQKtuUVYZm0c26jDIJMJzrxs3fpdEBJsvpFxHJTDYdDn6JLqnMGWo1X3vyamJ0gAjJP5RzEwjPQ3i8S42cTHRmbccY4GdB9uywR9LtlULeiqFuGFqpMd0wAKcMHnvi2mSW/7cBiR0dm3CmmV21u3XXQrqFZLz0OmbRldgALBZTshmLQVTpe+J1EldGyDvBwzuySs4R5Byh7qKFcYCczB7GFLoJAMjShqjmv5h2UHJMamu70+h5ndJ9WVK1LJ+4u/93RZFQVWHudpTekDPclp8rt9ro1hniAfBHdC6RAdupVNoGKJiCeLmJNfx9TXIVlIQyWyQjowzFJjM3xi9wGQ3JhbdRv3viwn7BHCVGt8V4Y05i0wGgFPX4yTsxdmD7iCvfNIHZKHLm10GCYb05g2wZHnCKc3kSMhkieKo6JCQAQi/X8MsSOgKp5O4VEc6Zh1e6++bBATjfF9pSsYV0o44t2UAk/naigmxLGbHo+cb/AggS/1v1Z4CfjRltJN2AIQLGT2jD1ZFM731AptYJiEeA7md4h0SH9qvZR1ZdgPlq33vMVNgfvFxbEY2tXow0t5HVIwEYysg7wQZpOJThNI7YC5Z3G4o5xDuWX8GBbfcL5bAfcpvzM1n/xx8kte0Btn41c5LE9yy6bXfzREikFZTDl0Da4lWiWXIcuIZkWje6EXLXbxCtcoD8gvBKSc/zFXJ2gdqIGe6V5TwVrE45/FG6fk1+HyxHPfPuhi3yCuHuoWpBTAnKf6v/kSdEdR3Z1dm+8iolQKtwy10rpK/CcLcCOGU3nIASYGMB38uwwlh6wro19TNF1UgCvBKqeal5VZ87NRX6WPVSOwflplroiUF+X6VkDLVwn5
 zq1Co9A2
 tmLiiBeSoCNCkOKbV3+okS8TpoEBATPVzeOMOrwQTS+276uVKbAN580Q3REwH/ufBAMI82MGur7ruVVSQQZVgg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/03/2026 17:34, David Hildenbrand (Arm) wrote:
> On 1/26/26 17:47, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> These allow guest_memfd to remove its memory from the direct map.
>> Only implement them for architectures that have direct map.
>> In folio_zap_direct_map(), flush TLB on architectures where
>> set_direct_map_valid_noflush() does not flush it internally.
> 
> "Let's provide folio_{zap,restore}_direct_map helpers as preparation for
> supporting removal of the direct map for guest_memfd folios. ...

Will update, thanks.

> 
>>
>> The new helpers need to be accessible to KVM on architectures that
>> support guest_memfd (x86 and arm64).  Since arm64 does not support
>> building KVM as a module, only export them on x86.
>>
>> Direct map removal gives guest_memfd the same protection that
>> memfd_secret does, such as hardening against Spectre-like attacks
>> through in-kernel gadgets.
> 
> Would it be possible to convert mm/secretmem.c as well?
> 
> There, we use
> 
>          set_direct_map_invalid_noflush(folio_page(folio, 0));
> 
> and
> 
>          set_direct_map_default_noflush(folio_page(folio, 0));
> 
> Which is a bit different to below code. At least looking at the x86
> variants, I wonder why we don't simply use set_direct_map_valid_noflush().
> 
> 
> If so, can you add a patch to do the conversion, pleeeeassse ? :)

Absolutely!

> 
>>
>> Reviewed-by: Ackerley Tng <ackerleytng@google.com>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   arch/arm64/include/asm/set_memory.h     |  2 ++
>>   arch/arm64/mm/pageattr.c                | 12 ++++++++++++
>>   arch/loongarch/include/asm/set_memory.h |  2 ++
>>   arch/loongarch/mm/pageattr.c            | 12 ++++++++++++
>>   arch/riscv/include/asm/set_memory.h     |  2 ++
>>   arch/riscv/mm/pageattr.c                | 12 ++++++++++++
>>   arch/s390/include/asm/set_memory.h      |  2 ++
>>   arch/s390/mm/pageattr.c                 | 12 ++++++++++++
>>   arch/x86/include/asm/set_memory.h       |  2 ++
>>   arch/x86/mm/pat/set_memory.c            | 20 ++++++++++++++++++++
>>   include/linux/set_memory.h              | 10 ++++++++++
>>   11 files changed, 88 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/set_memory.h
>> index c71a2a6812c4..49fd54f3c265 100644
>> --- a/arch/arm64/include/asm/set_memory.h
>> +++ b/arch/arm64/include/asm/set_memory.h
>> @@ -15,6 +15,8 @@ int set_direct_map_invalid_noflush(const void *addr);
>>   int set_direct_map_default_noflush(const void *addr);
>>   int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
>>                                 bool valid);
>> +int folio_zap_direct_map(struct folio *folio);
>> +int folio_restore_direct_map(struct folio *folio);
>>   bool kernel_page_present(struct page *page);
>>
>>   int set_memory_encrypted(unsigned long addr, int numpages);
>> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
>> index e2bdc3c1f992..0b88b0344499 100644
>> --- a/arch/arm64/mm/pageattr.c
>> +++ b/arch/arm64/mm/pageattr.c
>> @@ -356,6 +356,18 @@ int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,
>>        return set_memory_valid((unsigned long)addr, numpages, valid);
>>   }
>>
>> +int folio_zap_direct_map(struct folio *folio)
>> +{
>> +     return set_direct_map_valid_noflush(folio_address(folio),
>> +                                         folio_nr_pages(folio), false);
>> +}
>> +
>> +int folio_restore_direct_map(struct folio *folio)
>> +{
>> +     return set_direct_map_valid_noflush(folio_address(folio),
>> +                                         folio_nr_pages(folio), true);
>> +}
> 
> Is there a good reason why we cannot have two generic inline functions
> that simply call set_direct_map_valid_noflush() ?
> 
> Is it because of some flushing behavior? (which we could figure out)

Yes, on x86 we need an explicit flush.  Other architectures deal with it 
internally.  Do you propose a bespoke implementation for x86 and a 
"generic" one for others?

> 
> 
> In particular, a single set of functions could have a beautiful
> centralized kerneldoc, right?! :)
> 
> --
> Cheers,
> 
> David


