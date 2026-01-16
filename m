Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B4295C982C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:00:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D83596B00A3; Fri, 16 Jan 2026 10:00:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30766B00A5; Fri, 16 Jan 2026 10:00:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C33206B00A8; Fri, 16 Jan 2026 10:00:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B15AA6B00A3
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:00:57 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 667F31AB20
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:00:57 +0000 (UTC)
X-FDA: 84338139354.30.E5FDCDA
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf12.hostedemail.com (Postfix) with ESMTP id E40BE40007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:00:54 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MScVtAYR;
	spf=pass (imf12.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768575655;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ESFkuLZPGT8fbXcE99iW3+H6+Z58GdtIZgdRAPcl1wM=;
	b=cihTYeN8cXgWMlc1HCCSruIGmF33iqW9MAwKR3+fGiPTl4R52mABVYaZdooRtkUyYGWziO
	FrrJkWspHPmXtSCpf/7ZIshaqqy5z8EbEahP71Gvl5O91RvOfHLgGjYAnWZOBGxCvgcOw4
	hsaIElheil/9AAmVCrM24dCcdEE/CPk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=MScVtAYR;
	spf=pass (imf12.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768575655; a=rsa-sha256;
	cv=none;
	b=u8C/p/iyDTVzIRrA/rA8TVhzix5d99z0juHGZav94dzf+lYoYTA3mCE63/JbNIugLLkYRD
	pPefhCk+1bZxMkp+mnegaa7IWOwTDo1kRfhMN856ItDgAYxli/6c78s43+Y3gbYUZHlxfZ
	aqds50/ZNZeZysZ1dpc+3Of5Vakgi04=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768575655; x=1800111655;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=ESFkuLZPGT8fbXcE99iW3+H6+Z58GdtIZgdRAPcl1wM=;
  b=MScVtAYRZQy6jgfplK20tVbMgmqSg72YJSpTRV/lBlnl4rgopT4cpgI4
   oxc4KNbGaxHf+eQFhE8yGCVpdbFv8zantwBjJ8gtZx6Uham7vL0ZqQyK/
   Bw3CAo6+FMX7vt/XKilthvVnBC39LmppZwo1buUu/dWALjotyOnJjSLLR
   Z7MbSFNj2BJPJJrRgOQCMGbGpZD1G0PLaKvHpi/mc0ACELQ3U6W3qSWc6
   I3JDrwe01H6N/A0w6Wlh1kfEwNwFE7JA1fp4gUyJmFk1BSkdhgjCB6iYg
   uRbca2FweXWMK/laz1DGWrApM69bznIRRVddqKWTwNqBG2dUY8YFKdlx3
   g==;
X-CSE-ConnectionGUID: gk1Li/PmQKCcG3NIHCLDrw==
X-CSE-MsgGUID: 3iwqWVkQSaGSUUqmLqKkqA==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="7898391"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 15:00:37 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:10054]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.163:2525] with esmtp (Farcaster)
 id c5194cd9-a815-4ca7-beb1-df7b75e8b434; Fri, 16 Jan 2026 15:00:37 +0000 (UTC)
X-Farcaster-Flow-ID: c5194cd9-a815-4ca7-beb1-df7b75e8b434
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 15:00:31 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 15:00:27 +0000
Message-ID: <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
Date: Fri, 16 Jan 2026 15:00:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>, "kernel@xen0n.name"
	<kernel@xen0n.name>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>
CC: "david@kernel.org" <david@kernel.org>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "jgross@suse.com"
	<jgross@suse.com>, "surenb@google.com" <surenb@google.com>,
	"riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"peterx@redhat.com" <peterx@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"maz@kernel.org" <maz@kernel.org>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "ast@kernel.org" <ast@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Annapurve, Vishal"
	<vannapurve@google.com>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"pjw@kernel.org" <pjw@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"willy@infradead.org" <willy@infradead.org>, "hca@linux.ibm.com"
	<hca@linux.ibm.com>, "wyihan@google.com" <wyihan@google.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "jmattson@google.com" <jmattson@google.com>,
	"luto@kernel.org" <luto@kernel.org>, "aneesh.kumar@kernel.org"
	<aneesh.kumar@kernel.org>, "haoluo@google.com" <haoluo@google.com>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "itazur@amazon.co.uk"
	<itazur@amazon.co.uk>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"jackabt@amazon.co.uk" <jackabt@amazon.co.uk>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"andrii@kernel.org" <andrii@kernel.org>, "mingo@redhat.com"
	<mingo@redhat.com>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "derekmn@amazon.com"
	<derekmn@amazon.com>, "xmarcalx@amazon.co.uk" <xmarcalx@amazon.co.uk>,
	"kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "jackmanb@google.com" <jackmanb@google.com>,
	"bp@alien8.de" <bp@alien8.de>, "corbet@lwn.net" <corbet@lwn.net>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "jannh@google.com"
	<jannh@google.com>, "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"kas@kernel.org" <kas@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-8-kalyazin@amazon.com>
 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
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
In-Reply-To: <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D002EUC004.ant.amazon.com (10.252.51.230) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: E40BE40007
X-Stat-Signature: spx5muakseape8ekq4zixdei9axrtsux
X-HE-Tag: 1768575654-175440
X-HE-Meta: U2FsdGVkX19PypnX62fkiaDL7oGDCaFLl7vlaYmevmW7EBIwLCq80BwfS0tieYSQ/HcnUPIc+rzij9gwurO3WE7GQgpFF9LIQc9HH7KeyhspmBmEzrmowLfGwFjGfawcm5mgQhn8qqNgjOCURYUsMbuw33FmnmgFRRbM9NDJzrxDVM6WzS2QHEypj8HIiyTztgufgx5WkGAfW/kfSSDY1Z0sbgJYuM7SBbg9xzrD7DFx9c/Gw+dhQ6vuoipnfxE17H2EW/5tYlG8WI7SB5TRi3znGG/iSomwYfJX3wYBMXWOOY/7NgL102rDMcRYP4ALa7tyemJ0dkbrvzNkIr2O/6xM9PgskECZdN+q1+sc7EUHy+eDP+OobJWN3JBO1ZbPTTga78SKSiO5VounobplxHAskc5iJPgqjLRf65e/k8FJ+lbvBNcf6r9fZZivnHCz3uofOEz6bhdvhNwGW+E0GOa25uPEvfFlZkQGjdloyK8L2FGiG9HejwpkXcguoMvUgfUFyg+hTr2XC0Al/HikTAhs9R2U5bGy+944c2EK0hLMUVCGSmWV/C+GN2P8ZfXxg05aTArwXbJu4NYrR+Wvk2FUjDJrKfFpaC3Put/UbNp5ycP0N3M/pbKd3pJ98s+oCk8OdfuLd/FmM7w2wiZWzlz7PavaWQLYnJQRwn9cRngN+dJz/+Z2iNJef4P1Nl4Z8BaMt3JN6bR6/itJBfK3eQWG5IbMHpLNPD9KJAyWxDgrXnboBDeXSf/QGbvO5brAyW2xwiBpMvgmXsunKtPdLXFJHRGQ9vLqps7yQ802oWymMw37WWtAY9sgp92dQHDs44w02FpUnGKRSgLR+MWmUxmBSitJUOoOC4ipWlkbh4RMNAR3T4/1GOpHKbo9K3nZA2CmN+ZopVW3ZYc0GktF1GLMWjVS42m7u2AOGkAzGzwd7jK8C2oPN+rhDFR77Yk2z0poEpI1PKxtSwKHThN
 fY53o4xS
 OTIPFPuoTyuY4Q+BXW/K5rgvr02knQSP2swAtxRXco/eK/fVU+GieoeMnt2LAIgln5derFeVao+3HvktUVcIzg0DEOoMYxw0u5m+7zWXEaAojRtsT8DxrKEH9wy0b752+3s6B0Vy11pQl65cr6HxD7vVMDONp/Y4MZeyyXUBZt/QzYuWoOGxxDWiCNUEf4KNCLiXAR1v2OiFe/cre9LZRa1xzDOeafJJY/6N8gdNphZr8zuYL7Fit+VboNoHeWuyIefxeshCLheq7vou+C+p/4in8+wlAj8qZZQxeSBG2ZYcjvRJ6UTuYD8kWtjP1Ux7ca91zbWRk209sRXnj6Wc1PIk+7uXPHbbgOOLpOJczadj8D/UTU/Du3NPjvbRM4JY5BfIbg8xML1aBqqbZcNueUhkgYnGbp0AKUEG0Q5GZqnuK/k8B+vvd43Ijs48D4v6L3Nlw2OqotH7XX0gI9HYh4O8HyoRmg1x6dNMvCnl50MU1aoQFgmfdD3fC+g4rkn/ZXjRxAq04XYAcjRCBREKA71kEJTaz8I7K7jRLI57gXzuSvtpD8CCAHf3h7K3gQoe2tCYmVgnc3lnOEXQ+I3MGN0Oa9pxDMS3MJRXIflRfeLpq0xckk1mXAEh9wGpvacl8vG8ZUPMwprrhJ+cFOcZJOcqQrm7jVUA/+8ZTyl6xXLznIG5IGMJT7cps7qwVGS4OfSiYkKeRy2SSgTOPUNAt8Xm6LHt52ZLdjCoG984PNintZX7pAOwkJJB2pAENdiCoohrXbFyH3hYVntN5AMMh4AbLpf6D3zwzT1FUSy7YktGufFM2mwwBpDzw2SfDHlHpZ1MxnxcHs8IEcNwQ4T6htg+GJa+p/S0Pu2S65qWtzQtR6PR/d91OIcaaZE/D2k2ScjMSOTUCE+Ah0aHnIC/kZxxkRflsMyow76quQTONkN8YyZRwUIz14xgq+dMByxw8UeKR+vujaMsuL3Y4z7O6morHAbnI
 Ag+XX/4j
 xk0NUowgbphwwoOdLEKjffcurbIJu0s4yjlK6PnnaUA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/01/2026 00:00, Edgecombe, Rick P wrote:
> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>> +{
>> +     /*
>> +      * Direct map restoration cannot fail, as the only error condition
>> +      * for direct map manipulation is failure to allocate page tables
>> +      * when splitting huge pages, but this split would have already
>> +      * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().
>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>> +      */
>> +     if (kvm_gmem_folio_no_direct_map(folio)) {
>> +             WARN_ON_ONCE(folio_restore_direct_map(folio));
>> +             folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>> +     }
>> +}
>> +
> 
> Does this assume the folio would not have been split after it was zapped? As in,
> if it was zapped at 2MB granularity (no 4KB direct map split required) but then
> restored at 4KB (split required)? Or it gets merged somehow before this?

AFAIK it can't be zapped at 2MB granularity as the zapping code will 
inevitably cause splitting because guest_memfd faults occur at the base 
page granularity as of now.


