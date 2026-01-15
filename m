Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E95FD44C66
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 15:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB29F6B00A7; Thu, 15 Jan 2026 10:25:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B49696B00A9; Thu, 15 Jan 2026 10:25:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2AF16B00AA; Thu, 15 Jan 2026 10:25:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 90E936B00A7
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 10:25:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3FB4C13ABC9
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:25:59 +0000 (UTC)
X-FDA: 84334573638.18.3636B02
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf10.hostedemail.com (Postfix) with ESMTP id AAF79C000F
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:25:56 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=njlIiUpe;
	spf=pass (imf10.hostedemail.com: domain of "prvs=468bf17a8=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=468bf17a8=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768490757; a=rsa-sha256;
	cv=none;
	b=plxpL8k0HdwgWcq2LJcX2acmWQo0G71JFYJrTuSuknFDds8YMCpfwANHtD1iM86KW99Tyd
	S+JFnEmrOS/DERXXVYYezwojxYk7+8JM3xrQsAZvjepsSCNeN8NgNLHPuwVqhmHYPjl+No
	9rvcueSs/5fI6qSykdIwBZ4j951zpr0=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=njlIiUpe;
	spf=pass (imf10.hostedemail.com: domain of "prvs=468bf17a8=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=468bf17a8=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768490757;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErA/nUzcQBK9RfXLPHVY+KZIrd4BxzBjllIcAZaOcaQ=;
	b=KFJVKu7owM7Lm8BWbU7+OY+6ME0sEyYVlDgAZKtBXwQfOD7ythRrT1AlYSPvy05uQJYoQD
	4x8dxBU/llxNlcf0rLX0xQ5K7Bo0lH/kcrya/gJ3eUlKYMTuzRV96ifUj7J207plU/bMcT
	8QNYYrzeirdzKrf4qg6ZPOLJhMG+bxg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768490756; x=1800026756;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=ErA/nUzcQBK9RfXLPHVY+KZIrd4BxzBjllIcAZaOcaQ=;
  b=njlIiUpe25gf6GOiPG3kcnknUVO6nj7ww/2YxO2Otz7HGdqcW+apWboI
   ei0bSdFvEAxBcDcuK/14I1SjtZyYj4P1n+aBX+RP1UYFH6s+XWtQjINMD
   itkGF8VsJhjTAE5X1oo17qZfKPyYWa3MenR6z0vQZQs27T04r/lnnqbzs
   /2C8tXPxx4Vs6eGlvx1Ayx+CdpxZ2bkVBCwFAU+f4UPLfMpaElKne+an2
   gfGeoU+Zx/Z3f+/DGlLfzt1+1VlR0nND82klTym90cU3HaQ4skAZTPLhJ
   oIKW54ZSO4P9T9SCWVJCBlrAc5eujT2JDxf+l/G8t9jsw6f+CeASZvT2O
   A==;
X-CSE-ConnectionGUID: JEI06koAS36Pqlka9p/LFg==
X-CSE-MsgGUID: fziZ5aPzRHWEX3iC92dDgA==
X-IronPort-AV: E=Sophos;i="6.21,228,1763424000"; 
   d="scan'208";a="7652838"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 15:25:39 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:3758]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.3:2525] with esmtp (Farcaster)
 id 78f75ae8-5037-4d9b-ae68-7dfcd2a25e3c; Thu, 15 Jan 2026 15:25:39 +0000 (UTC)
X-Farcaster-Flow-ID: 78f75ae8-5037-4d9b-ae68-7dfcd2a25e3c
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 15 Jan 2026 15:25:32 +0000
Received: from [192.168.15.69] (10.106.82.11) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Thu, 15 Jan 2026
 15:25:28 +0000
Message-ID: <094591b6-97eb-4cae-aa08-fececcba4ba1@amazon.com>
Date: Thu, 15 Jan 2026 15:25:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 01/13] set_memory: add folio_{zap, restore}_direct_map
 helpers
To: Heiko Carstens <hca@linux.ibm.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>
CC: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "david@kernel.org"
	<david@kernel.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
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
	<gor@linux.ibm.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
	<shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>,
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
	<wyihan@google.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-2-kalyazin@amazon.com>
 <20260115121209.7060B42-hca@linux.ibm.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <20260115121209.7060B42-hca@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.11]
X-ClientProxiedBy: EX19D012EUC004.ant.amazon.com (10.252.51.220) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: uzi6yx9gt64fhimwizwzsc3rkczkyojt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AAF79C000F
X-Rspam-User: 
X-HE-Tag: 1768490756-685321
X-HE-Meta: U2FsdGVkX1+E5rSUkuNVwL6KimGgV9Le5iBg1ATWCukf1C2WW6vFP8qyHm8I5UVJqjaLVeT/kBk5lk7t6z/l7rmfMrbmKqMxczUEeAQoMN9gScc4jpTHU9SOse1Qe5XJROW43KLoW4++TeQXiANuLn0Zctd6CXHMF+p5q5MMP+kmCQDPQsoBC3ldrSEHTZKTnWVI+cbgRHMM1gvXZaMaObMq5vyvQ/H0KpCO3F2n8mhvf/uaM/eMZVjxJ5m7poPemKyDYxGmIP/FSdNGAUCU60wZvkWYRGlyigSPL/lOi4JF3f8EGpEY9/JYMc3DAAfcwD/zN8kZ3h5dI8ckbF6OnIl1lzBGb2SVChMaMcH0Pf//47bcSPvJT7xVb7uN3QICpejZFce31T2mKZkOvPzK34utnagUQOUygYHYftaftWnyyvxBw5exHUMlHZkpZ5ikTZ4So3zYhhxxfZcRwij0mpnARgFpiF1uBr+nbRTSVuTTgsUv4lSM4rwuxCyoWatJBQgRw5gR/H6sPkmkkMHEsZtX6QYtmst4hL2aEdyxMPIFjtf8NxDfZC3LNx96PMZ4LPJ/0mpT2ovd3N0UjmfNorue/NJZPoJ2lWJ9nzUqwTLql+Z/nx6A8cm94s7IVQ6oEgCKqlFfVfliACFvQVWKBMm5rkrc9TxluhV6feVd276AMZMMlzvnlKpMvA/siSM6T09DYqc+3V5C8VKBKmdHCuRjj3oZJ324IRZbfSQD0vy8+gEZzgQxVDoMuGraLK3eMTzBq3qdrXcu+cZ+0I0nfijx7iMuHMT7xwgGOZucP286SxvURv/IDJYuC27l5vgEEwgqlIbq5Yxt1ez30IFNippBpnU1qkB+uDWR7XbtAz6DoORLh9HshxoWx50woZRFJPBzoDXI+xzPDvuYWGGLI4IDkyDgkbcnWUsCiQIp4SmuuoJhLz6qwe2rgdSuRSzJhdL2xiFnLsywfJUFtbX
 q5QS/Odm
 Rv2IH9xbBv9cXgQVaMfitE4dn1gHIspem2yJzvf7U0JnGGe20YZ+xmrche2NBxXtPfVLO4iAFwkMPy3Rdtbx0cRXuPg5+hDmx6TXQK1osQVrAPKP5o7qYPt4KABHO+97z47Hs8czx/WXdQPZRa6goK//+TfDNopnD/Kv//ep1gQIiclDE3ebcqArGkRQyVVmySO7zvDbBvNwmtZryNA/fJOX/V6R1YzNwxsbS6JDKfFG8E1TxA3twe7zIbeetYehAX6EO4Dvbv4Q63X54bQzEXSU6nlP0Werkz5NM+8KjkSsxWngsu4/alZnyiJi902dp70M+yO+qs/+FJMKneJZZCLMhX9f2YjJh6CteBo6ozJhVDiAEhCVwwhWxOFeCh699somRtkaUiLnZ21znT2Zd2sQQW79hhSwiqMsFkuqxixoCzWT+qkmjROpxIqiv2S+irct5Pgx1dpV5bv2pj3O2nzVu+Wkxy4+FCcnczt2PMBetyupN37lBQjHNvv6XxBdFVCsNyNzIhop3eNJmpF6QKdWYkPkB1H4Icg5x5jbCpZ3+WziAW/tK6hm1VpGKXQfBA2R9wyiQXwXjkirrJnjhUubolbnbb7wwSyy51vQlvfZ/SEQom/PT+qBjyDqp/Qh6UgkMpcuGRZBdAmjuDNBBSVhWFDrML8T6/eIvXBQbQBYBPk2uhC3qrVnjbA3SLHn5PQGKH1YVipj9RTt0yJEapALPrjUxXwAzCp+sGrYo+kJkm51Lgc9OMowa2WJCGRFBS0kSPxFc2+8UDex9yzk+sCymVJdWBp9HwoWqX2bZtMb+k8vV76Q/nNWcgDBetnwAZ91jC/niZoQabs5j1KYurX4bCvYALO/WgcQGzjLMWKCkrHergXY17FFXR8bMVuRyuPP2pAtGtkrnVJalH1r/XlrXn58FtUMrMz559YZHe+ceF3pEu212G24L5+uVpXkq/QUI6Ujwq4wxFqL8J1QBqFR57pGD
 Wa0eTilm
 O6vnhbAnj7KxsAL2UaXYeGFK8tCdUcboi76UBZe/EjP/R4nI3/IMF/vsLnroOGjf
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/01/2026 12:12, Heiko Carstens wrote:
> On Wed, Jan 14, 2026 at 01:45:23PM +0000, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> These allow guest_memfd to remove its memory from the direct map.
>> Only implement them for architectures that have direct map.
>> In folio_zap_direct_map(), flush TLB on architectures where
>> set_direct_map_valid_noflush() does not flush it internally.
> 
> ...
> 
>> diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c
>> index d3ce04a4b248..df4a487b484d 100644
>> --- a/arch/s390/mm/pageattr.c
>> +++ b/arch/s390/mm/pageattr.c
>> @@ -412,6 +412,24 @@ int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool valid)
>>        return __set_memory((unsigned long)page_to_virt(page), nr, flags);
>>   }
>>
>> +int folio_zap_direct_map(struct folio *folio)
>> +{
>> +     unsigned long addr = (unsigned long)folio_address(folio);
>> +     int ret;
>> +
>> +     ret = set_direct_map_valid_noflush(folio_page(folio, 0),
>> +                                        folio_nr_pages(folio), false);
>> +     flush_tlb_kernel_range(addr, addr + folio_size(folio));
>> +
>> +     return ret;
>> +}
> 
> The instructions used in the s390 implementation of
> set_direct_map_valid_noflush() do flush TLB entries.
> The extra flush_tlb_kernel_range() is not required.

Thanks, Heiko.  Will update in the next version.


