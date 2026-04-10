Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB12CF459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:25:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4662F6B00BB; Fri, 10 Apr 2026 11:25:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43D5C6B00BC; Fri, 10 Apr 2026 11:25:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32C416B00BD; Fri, 10 Apr 2026 11:25:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 230C36B00BB
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:25:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BC4BF160388
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:25:52 +0000 (UTC)
X-FDA: 84643021344.20.113E891
Received: from iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com [107.22.191.150])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8335940005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:25:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Yeo47Hbg;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf07.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834750;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ol7pcngOj6CrfOGKJ1Q8+hUmGyttlI2sRZ1Q0xls5wA=;
	b=0uAyC8Bls2Y4Jf9aNw0zdE/Kuf1+1BaShfmGjzRxbZXNbZ+1CzbIhKreucalc3wFqXriRY
	o1TNnSMGVtWkvjabPGv7JpaTpBFlF1dxpPTOuc5JZB76O72tXRL+dq7sI+WLa4f0dpoiMZ
	CezMtI8kfsWaRl65WLrgDkhvL4ivjH0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834750; a=rsa-sha256;
	cv=none;
	b=4U47XBcK+99ypa8aI+gilE6NMBy0cv56C+Tk6CyWcyZyM334LjKDzZiAC5KUzz1YHFWzJO
	dI7AvwiUvQJ3hJZamuUh1qjkMGXKDbPoS8eTab/CnwuPUp8EiVON3V6cQQBayR7dkwM2Ey
	cTfaSSlab3ucOwC0iEa1E5iGY6XJXG0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Yeo47Hbg;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf07.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834750; x=1807370750;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=ol7pcngOj6CrfOGKJ1Q8+hUmGyttlI2sRZ1Q0xls5wA=;
  b=Yeo47HbgMskO71fKnaDsEsSy1EnCtTBIQW7/Fk99vEJamXTMLh+AV65S
   WUGI0z/+XqUj+jDM5rLzYSMUViCXV1SE2SvrLcR/h7+X/CtPQwITbpcwu
   po3MdtZ6zOsxWmn08qhsCT/1QV0Zf6uYw23luG0QF2uZyg/KzickZw6kR
   9KkOx2CXJMxRI/3Mzk0xn8T2nU4J661ffmWSqcEZVa5LYP4pWDk/eOr1m
   XGvEnyy61ok+Omg1YaEYZuHSEj1RV196dQ/2VMPKxz8txr1YwIER6QH9U
   PFmK9MfQ+QCHsFLYbIjtrXqDmeQ7yKoRYLCoKUjwIieRFEdbjTDv+0vKb
   g==;
X-CSE-ConnectionGUID: C6NGMfEdR0yLPJiR2UsJqg==
X-CSE-MsgGUID: FNMxIsp6SHKbEpn1aSfTPQ==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15526458"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:25:49 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.142:11264]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.59.187:2525] with esmtp (Farcaster)
 id 0e62ab68-b87c-485a-aa3c-53498707ba15; Fri, 10 Apr 2026 15:25:49 +0000 (UTC)
X-Farcaster-Flow-ID: 0e62ab68-b87c-485a-aa3c-53498707ba15
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:25:48 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:25:35 +0000
Message-ID: <f0ee7211-99d3-4ef7-abd4-73cd202e6440@amazon.com>
Date: Fri, 10 Apr 2026 16:25:33 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 02/16] set_memory: add folio_{zap, restore}_direct_map
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
	"ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
	<yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com"
	<tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
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
 <20260317141031.514-3-kalyazin@amazon.com>
 <54f9b5a7-b8a9-486a-9c12-a910f5287947@kernel.org>
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
In-Reply-To: <54f9b5a7-b8a9-486a-9c12-a910f5287947@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D007EUA004.ant.amazon.com (10.252.50.76) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspamd-Queue-Id: 8335940005
X-Stat-Signature: txfz7n9uyqm1biio7o1sdo7pwnznjsjj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775834750-328494
X-HE-Meta: U2FsdGVkX1/wVLwhLNHRRwlNBeZPgcszrSD9lJbzSGZnjFsl6CrKhHcr61atezb4d+24WIN+ygIYhoOQvGUAwuOoZIlIqV+Xke2cnD1Dud4nhVW4HtMv/ynpQ/q7V+6tPpZ/VVlqZor8dvh3CX//MTTL3CsxKZiSAnQw9gWsqFNKKlKkiiUS6Q5eVad7dzISVfPPlaW1ImBmfCgcaLXx+3Bephj2Yie/PeRJi0ElOzJys1yPmSjC6uEU3tz+zm0CItsCuEPwM9EUiFMJ6jkE85ndVSXKKk/cMHjZ9cB7/8XGlF375G/MpCb7eaep5mo3Yj/y12XgWxpicVSeht2EMloZ298jG6CfzPD+c+lHdzm6aHFmQsg4hR0yuVtuNwf8mIFCrJSQpOZGTkwTSlTH9kmrQCIOzcrKiMqq1FAbBP66ibnqWE+R1haZmIzlWu9CQAA71Hpx2Gs9YxgbcQJh+SOgJkgxtI/ENyGsfPpi2G85MriUDdP7yRO2ror05C1mFSqg44eyD5YGKSQdQo/t5nwLVopTZckEjXAWw4wLsib/Kzdobs8CMVrDpf5bRMRnVHAx0ACB4ffK4KKgfgkZEYx05YdquFWgyLfrexdnwuFkJcZY/XKCcckPdU1lxxVhI4SZkt8pUvrvgoXLXcToZe0gMlxwA2KdlcaamFwRNwq2pkeKPqah9+3jlpbiPY4/iu+mnnlc3JielYQPQ1/4QsXretoFKhDoJlhAxlNAjJVsxZoNQbZWvg7ueZFKncQkMASA3e+ofWg9BULXmrKvlbsrDJhVS0UCVMFWHs9+i5FJCwGBTL2pBKKlZfZyHZfdd38HcKo9HAOMi5cbJSi+nNBOrMW9pBwt9fv65lcTbWlMJkl/nUawgoVsrXCSRlq54zo8mmPokACTHNP58HaEZrvL2VeYXEYrH2yS8uH6ELX7UYlgJlw+J/2wd5Mc2bmZ5bw9LDYZi7JzFPsUrDd
 VNSvaOhl
 NwXtV1+E74qbQ+dslRtu5cELx8+oWZoGPo2uUBEx+Oihnw47LcY3m1tu0NVIk9AgO6tNcaaa+ueiY00baltnNL03ZYHEjKsYMMiopEp+llpkVjP19c95nieNYtO/blpSzeR+rfvKoIEGIx2eUoFFqHCIavQjsEiwbUPLfpg/l7oDMoZFmjtrh5KsxLvzA868NO24HC/eDxU5t5jqX61TdedG6O/ADDE5CkRkqvwhgQmz3q9WrfFl9ANDbUy1yrLnFC/GVb1Jr4XqICdIc6MUkHrBOjYb63vXV9fIt0EZO7DGc4BiRI8d+US1FVdTl3UNKRCUtD41N0jGWFmZqiIWp4n2bgt9RUB9CjNnEWJqI048tTtRq354VHQwaNFFNCFdsEJghB5lU7Y41f7w6CwcOLcDyTWINf4QU4B38tQQ6LJYtx/jze3GWZnVGPMZzwHRaK1P2CPno74zgY7O6DQf54DmWaZv8fVJ794sYE5cvit8hP7xtZHFmzMBxj4oFamPKt6pRRN7CFlRTqsMWLGqsGqaQiLW4mGYBA50ll6AqHX3PPocah3+VTtenoZovhFYLG06VRcgnMYfqZrS8KRZgpiAebOCUXbMZPzFv6cH7CemhuJp+YMZ8iuzxNsFlJPINnVyku2m/HOaamH/ZsMzOfYkZ81ZKD3srlp3TrGY7k80CkaVg/N1ZgwlFrQJfrtuCJBz2CRr4OcSJQ3y1NrQr3wo3XcmVbrL4CWgb++/sWRo9J4hMnmGE/pukso1lsELSaCkTszOfQjyqQSGUx0DWdtJdEbU49ggics86pKtk8ap2FhsGDPWNwETUdk51dbEbkXu1LgDIoqF0lxoZzVY5laLj1aihGpiGmEYj3UvqFu1EkhQ9ctYlEz1CE2sDzhWs3jkGFDR4jSXrNgv1cRyt2IT+vwdzTNrlGv7BYl27aiQe6eGLQlN2JvpFM+k3L002lhrPrrzWC5nO0irqhmloWDQ4hjY/
 JuombloF
 QAYuJf/CDjQqk1/xVTgqI+Q/KnqXcBmZCfrZCb+OI2cvSAkFhYDbdPP7QwgJwpJJiKbpLN0HBs8SZ1wI5I73MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 17:51, David Hildenbrand (Arm) wrote:
> On 3/17/26 15:10, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> Let's provide folio_{zap,restore}_direct_map helpers as preparation for
>> supporting removal of the direct map for guest_memfd folios.
>> In folio_zap_direct_map(), flush TLB to make sure the data is not
>> accessible.
>>
>> The new helpers need to be accessible to KVM on architectures that
>> support guest_memfd (x86 and arm64).
>>
>> Direct map removal gives guest_memfd the same protection that
>> memfd_secret does, such as hardening against Spectre-like attacks
>> through in-kernel gadgets.
> 
> Maybe mention that there might be a double TLB flush on some
> architectures, but that that is something to figure out later. Same
> behavior in secretmem code where this will be used next.

Added, thanks.

> 
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   include/linux/set_memory.h | 13 ++++++++++++
>>   mm/memory.c                | 42 ++++++++++++++++++++++++++++++++++++++
>>   2 files changed, 55 insertions(+)
>>
>> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
>> index 1a2563f525fc..24caea2931f9 100644
>> --- a/include/linux/set_memory.h
>> +++ b/include/linux/set_memory.h
>> @@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const void *addr,
>>        return 0;
>>   }
>>
>> +static inline int folio_zap_direct_map(struct folio *folio)
>> +{
>> +     return 0;
> 
> Should we return -ENOSYS here or similar?

I'm not very certain about it because set_direct_map_* return 0 in this 
case.  Do we want them to behave differently?

> 
>> +}
>> +
>> +static inline void folio_restore_direct_map(struct folio *folio)
>> +{
>> +}
>> +
>>   static inline bool kernel_page_present(struct page *page)
>>   {
>>        return true;
>> @@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)
>>   }
>>   #define can_set_direct_map can_set_direct_map
>>   #endif
>> +
>> +int folio_zap_direct_map(struct folio *folio);
>> +void folio_restore_direct_map(struct folio *folio);
>> +
>>   #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
>>
>>   #ifdef CONFIG_X86_64
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 07778814b4a8..cab6bb237fc0 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -78,6 +78,7 @@
>>   #include <linux/sched/sysctl.h>
>>   #include <linux/pgalloc.h>
>>   #include <linux/uaccess.h>
>> +#include <linux/set_memory.h>
>>
>>   #include <trace/events/kmem.h>
>>
>> @@ -7478,3 +7479,44 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma)
>>        if (is_vm_hugetlb_page(vma))
>>                hugetlb_vma_unlock_read(vma);
>>   }
>> +
>> +#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP
>> +/**
>> + * folio_zap_direct_map - remove a folio from the kernel direct map
>> + * @folio: folio to remove from the direct map
>> + *
>> + * Removes the folio from the kernel direct map and flushes the TLB.  This may
>> + * require splitting huge pages in the direct map, which can fail due to memory
>> + * allocation.
> 
> Best to mention
> 
> "So far, only order-0 folios are supported." and then ...
> 
>> + *
>> + * Return: 0 on success, or a negative error code on failure.
>> + */
>> +int folio_zap_direct_map(struct folio *folio)
>> +{
>> +     const void *addr = folio_address(folio);
>> +     int ret;
>> +
> 
> if (folio_test_large(folio))
>          return -EINVAL;

Added, thanks.

> 
> 
> With that,
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thank you.

> 
> --
> Cheers,
> 
> David


