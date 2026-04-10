Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 782EAF459F5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:28:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2E706B00C4; Fri, 10 Apr 2026 11:28:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E06F46B00C6; Fri, 10 Apr 2026 11:28:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF4C26B00C7; Fri, 10 Apr 2026 11:28:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C0C446B00C4
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:28:46 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 986CC1B7DC3
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:28:46 +0000 (UTC)
X-FDA: 84643028652.04.5903325
Received: from iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com [13.216.7.111])
	by imf26.hostedemail.com (Postfix) with ESMTP id 617E9140004
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:28:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=BH96aVfa;
	spf=pass (imf26.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 13.216.7.111 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=BH96aVfa;
	spf=pass (imf26.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 13.216.7.111 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834924; a=rsa-sha256;
	cv=none;
	b=V2pGQYNHvjmXVIu7fNxYO14tkvRCBM5/07ntHw8aIksuVvvHsw5THXCk3jP+7mUw9MOo8m
	jcxjAmBbLWTZTI2ib1MaqjlZX2Z70vUF3bPZYYhs0IuvtD1DwfpmZ8DyI0Ml7uyVu/t+ai
	QRGZr5dNFQXQVLSUG4DHkIceShQTGkw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834924;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SAFosHbtBbXBFEeuEoVMlIweSzaAowN27zlshlTqt9A=;
	b=u5DVhLG4My4I4Q1bLaWQEuH/Bqw9goV35+KISEyFgvwbABzPD+HYAze4y66qYz8nknU4aV
	asDLJsSvAZPdOlW0wuczmuFEBRZ5P9wKNh32r9V4v53a9ihx4ErtMG8qW897BZ/3mZAQ0f
	LHtSVl5ZE5fwlHjTzTGjQU64vGIffaA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834924; x=1807370924;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=SAFosHbtBbXBFEeuEoVMlIweSzaAowN27zlshlTqt9A=;
  b=BH96aVfa0ZPcnn7W1iQWZe2Yv8tGtLHwy8B/Kmb0pJboGKpcinfJoaKL
   tXC+UCqP4j2Fvzvz/asOACvMpselLM7arolDNMz4qyoFyAM+2UJTi4yEl
   7yqSzwdMZ5Jv/iAuI4EAbh2nCzoTQk54nO/Z1ekwtKE773NRddoTKGzUY
   Ybt3ZHJt16g3clZBAIfoN7Mai0UYmhk081LMJ8++95r7AlrbeOpHdQ5R+
   7hnjWgr+f8QY2AQSSbOTaGEYlail/3oY1oix/FvGCNSrQ5XBbqYkXD/I/
   YpJYw/8V0IZ8caqQxI+8LAkznuEI+fLIHEc1hMg5finck9gNa5+Dp1aOX
   Q==;
X-CSE-ConnectionGUID: izDL0MYqSwOQy5f8rYYb8w==
X-CSE-MsgGUID: T6sVodo7TcqvgyBOYnLnbA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15811989"
Received: from ip-10-4-13-79.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.13.79])
  by internal-iad-out-003.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:28:43 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.134:8917]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.29.254:2525] with esmtp (Farcaster)
 id 363576ad-4054-4b70-ad88-80e87a8ec583; Fri, 10 Apr 2026 15:28:43 +0000 (UTC)
X-Farcaster-Flow-ID: 363576ad-4054-4b70-ad88-80e87a8ec583
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:28:42 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:28:30 +0000
Message-ID: <978f1fea-19bd-4e92-961a-080136441e4f@amazon.com>
Date: Fri, 10 Apr 2026 16:28:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 10/16] KVM: guest_memfd: Add flag to remove from
 direct map
To: Ackerley Tng <ackerleytng@google.com>, "David Hildenbrand (Arm)"
	<david@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
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
	<loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>
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
	<lorenzo.stoakes@oracle.com>, "vbabka@kernel.org" <vbabka@kernel.org>,
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
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com"
	<riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
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
	"Manwaring, Derek" <derekmn@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
 <20260317141031.514-11-kalyazin@amazon.com>
 <50bfaeb5-551e-403f-bd00-a7d8b6bbf6e2@kernel.org>
 <CAEvNRgEXp6busURR20cazeG2DQWdU5=ZaJv21OcSq+mhVKwJ4g@mail.gmail.com>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJp2NfjBQkGQlIzAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPPNDAEAvsw8vEWj8ArWQ1QJNufjrvobU/cE8MLKdBxbSE8CyZQA/0BldKxNAtAwG4qw
 wCLxsZ5vBL3Zkh/PdvtFCj/VGscGzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmnY1+MFCQZCUjMCGwwACgkQr5LKIKmaZPPQKgD/f3FtERbJ+LYHLSG/ZbLNAOLngUlQ
 qo5VfIyJOzeLzC0BAP2PIUFIHo7vmia/PXEmT+ve4c5rx+EkH/Dx1GRpjWoI
In-Reply-To: <CAEvNRgEXp6busURR20cazeG2DQWdU5=ZaJv21OcSq+mhVKwJ4g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D003EUB004.ant.amazon.com (10.252.51.121) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 617E9140004
X-Stat-Signature: gqbgteecu65ucw9zjgzaxhc5gkbdqcxh
X-Rspam-User: 
X-HE-Tag: 1775834924-682298
X-HE-Meta: U2FsdGVkX1+/c1tSlAVVsOW+AI2eYYxpC4dSvzGt/s1TrMeR03RPLZkqDzOD/hWsD2Jlp97YIC1L0vT3cmgtZMSjHqFuSqjVIMW/Ikf3mGFl6ax0ObFOqND3i9wMKOTF3kjAgv+1X2h3P7qHbmmIwXWcg0pDYaTs4pSh+lL9F0BEhYRb9VUE5tCSiT26suS3LNRSrgYuNADqsEcje5iyuTc6fW396pbLh5uKVTbdDSME0uOdyDff0Judw2xthy4RZnZhtGu2mdGqwGGzIRYXcLaOsoeON87/kiEZ9jNDOl/EyK2O3ntreuF3kzKV2enD2OtjfKxZQKHjafEJekogotZ5InbDPIi04884xt952/UQeV2n/HYi/0l3W3p9LypVQYvVzGV1F/MSUWF1BDEDy5blycB+9AGdij7T4stO/2yaJ4Oo32sT54zVqWqRlGZQIs9T0t5yr/0yUpgqCmLobmvcqPcME+mw7lLosjP1xgyPcpENWZib5M4lfyxRL9Z8zx6U8N66B3V+2G9JPmvJryYFCqrUSITXtezellGAFTQljrtY1nCXWGV7Az3lo28Oev6dEr9S6bvPn9+SmkThTFKOGlj4fFRuMaV1SJoDKDWW3Quazw1KonnOO6tJ1QL2NwiV5e50dQQkr6zrcK8l0ezmusyfA2ZOsYPItiz1N3T/6pc7x0DuV3x8uVq1CvcQcl/4HIdrxn5EljHsR7MUpOJ5P5UH80p7p/UcNh07x7gUDqTdo5S1Fs6ZnKJ1M0D9yu1+zkjo5dbc+kv4Xqkbb0CbmNSc6MnPiK35G2gMiyFUYXYy8qaMHM9ZATRDdF+24WBdmx66Wpv9YQZ/MNYHxHHljyv/jaiD97zYiZHN1znodxKOgP9B6ayIO4WqNC6P6t02LgIRbaZ0+mvkABlnCgcOG67QRCA07nPxpQyIn/IV0umBjTHEusFDBAPX2NBTmOEj/NeLZ6H8BDLs9X3
 GHP0bNxe
 9D3jiDksBNCAuQAofLQ5JEw6kdMOERwJ22BCSzfiHGQnB33koXNIiJ3kJBaKAPeGniUfZmP4hAzPBpzbbkuwjeTM+YT9FsaEDDdF1RN4sVMufVIQ6/FRIiPY9NFgp9FXnrjdkAcnnQzl23LTLZL3Zb1ZShKwgdpwhqiU3x8wrF7oOWOvGFYN0VLGMVYBmIk92wj9B1B12s1jv2tP66e5e8Tce47fqCDnytSKUeFUvx3UlOAsC1KiNDdxw34hgv8PrYGymz8+sWtz3Ms7ytQOcLfcjmOuurAgfDTksJ1pMd3aZ3VLHSbPzsqZWjE5yneRvS0zHl0eu+ARSiVudji+umvXVweIT8gUO+uXtRb8hXvC071kdatMEn7UN/oIoPmUaz6pRpNisJ+hAbqxYh9EjflgaEedvk2x3NWMhMP299Hd2tUy2CZ/8k7cu94rlObAdx+wjKI2/m/VW/F8DBJXQJw2KYkJl+foh2tqAzQEXpcn71a/L4wY1mACejF0LraWwHPPdsTjdEa5XITisREw2RLjxCGFftvaZLPl8YrkSeOshPEGDequHuXweCxNFj/UY7ytPYdTwHKOZwv8rkGTHI1e1KHdSrzq1H3gYAng/9K8USqRDXDTN8mZ626O+fURhOsNwye23TyHt0QCw+YqqrW7aJ9UlfjUbV9OFIhqCZhp4Q8Y9OgVQWRod0kEQtOjf5Y2Gq9Z8U6HxRYLjvnUNfulvWDU/nsp+lbLoWm/lWO90J2LTRCV+H6tBE327fjtT9cEPtE71qVvQhTVUAhPMq/72Xk3rKN/nDjshYUOvqHNciy4KvHeK30PtrdxtHIkJMBdFMpl/GJ4phRH9R2xBVGl6McbU6zYDl9l2rd/PSYKCmitsEiJwvQhaTIf2q8aoiFOtSaG799L5XHQSqbzb0v6DsiFzlL6kLt4Z1AuhR8B99bq4CXaeenK8QS8Y+2Wd4TJT73Sw1oU8GKLEGGK7cfRDnSLG
 PbtZWoli
 nldsA05N/LQ/HhnG4GTuP8nHs0rqZ8tY9cXCpbEvIVWTnvQqa+xRDMFr/zvCk7od
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 20:47, Ackerley Tng wrote:
> "David Hildenbrand (Arm)" <david@kernel.org> writes:
> 
>>
>> [...snip...]
>>
>>> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
>>> +{
>>> +    u64 gmem_flags = GMEM_I(folio_inode(folio))->flags;
>>> +    int r = 0;
>>> +
>>> +    if (kvm_gmem_folio_no_direct_map(folio) || !(gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))
>>
>> The function is only called when
>>
>>        kvm_gmem_no_direct_map(folio_inode(folio))
>>
>> Does it really make sense to check for GUEST_MEMFD_FLAG_NO_DIRECT_MAP again?
>>
> 
> Good point that GUEST_MEMFD_FLAG_NO_DIRECT_MAP was already checked in
> the caller. I think we can drop this second check.

Dropped, thanks.

> 
>> If, at all, it should be a warning if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is
>> not set?
>>
>> Further, kvm_gmem_folio_zap_direct_map() uses the folio lock to
>> synchronize, right? Might be worth pointing that out somehow (e.g.,
>> lockdep check if possible).
>>
>>> +            goto out;
>>> +
>>> +    r = folio_zap_direct_map(folio);
>>> +    if (!r)
>>> +            folio->private = (void *)((u64)folio->private | KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>>> +
>>> +out:
>>> +    return r;
>>> +}
>>> +
>>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>>> +{

