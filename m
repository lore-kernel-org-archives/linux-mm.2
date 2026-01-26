Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A83AD19504
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90ABD6B008C; Mon, 26 Jan 2026 11:56:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CAD26B00A6; Mon, 26 Jan 2026 11:56:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B78F6B00A9; Mon, 26 Jan 2026 11:56:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 676FA6B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:56:40 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 138C4BB33A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:56:40 +0000 (UTC)
X-FDA: 84374718960.16.3BE84EA
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8D0F8140015
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:56:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=klu4T5ia;
	spf=pass (imf09.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446597;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i1wNPmaVv8oAnx46s+pv/CwmAbOdzYrpQ/gTMvCUjdA=;
	b=McP/ZAcgyX4sHJg74EmK5V5CQDE8eIXJNXVFdDjKUdRPGYu/4ST5tr7x6H7x/3fx4cJxnL
	/Ioi4hkvYG3IpIQXA5uPUsv6WPNsLBaxoeWHL6+dHSXEdDfFhgq1Y/mcJ1EisFaktK1iLy
	w08Rn4uCt/IbtbRfEfSYjqadEmkS1k4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=klu4T5ia;
	spf=pass (imf09.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446597; a=rsa-sha256;
	cv=none;
	b=gryv289KF1zmIEOeBSTqLuLjP1TMjqMnGjDBSgjdFxzWAjvNuFArr2Bc1kmOKk7m+GbiTZ
	0Hg2WafBW4Qe6wCwhHvm4y8N/TYLOBoarImtTAYvX/XcoT6XTdCjcxPZVVXw8grwGagG+b
	M6hUSHz5DG2L6Axl8S68OjFMwnI66Xs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1769446597; x=1800982597;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=i1wNPmaVv8oAnx46s+pv/CwmAbOdzYrpQ/gTMvCUjdA=;
  b=klu4T5ia6GxVd51YU6JQ900i2Gdd+JA+cA6n7gP5/u8sl0wiCd4N9ccr
   xpIsP2YWvPMzPNmNHog84/qLHyL3FlvMFNYVRYct5sUS/vDKW+0/o5wuc
   p7rPi53Lv5YqFmvhgJv88WmttLPGvanvInEbTN4CxyQ79WAw/iZ94J6yF
   Pde3o/THqPlZ8aPuh3wgAn4KPamwAhvH6H1m4sCQ1O+b76UCYi3nzmtoE
   6zfq6fuME+RHqLrOC0GsMlzGA0D7YgMyNDJE41dYsxHk0FKCeRHQ+vlnK
   CdSygWmXWLKRs+hRazMsrb9aB9owZJjB5mrk9uaZMB6KrUjhi4rsk3Dxy
   g==;
X-CSE-ConnectionGUID: hG/nmz7vTNmceFnAp6G6SA==
X-CSE-MsgGUID: 3E3qoK4vTpqzDoxpd4XG1Q==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8357615"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:56:36 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:22549]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.185:2525] with esmtp (Farcaster)
 id 8a3ce0b8-5cfe-49f5-b875-46094201b2e6; Mon, 26 Jan 2026 16:56:35 +0000 (UTC)
X-Farcaster-Flow-ID: 8a3ce0b8-5cfe-49f5-b875-46094201b2e6
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:56:30 +0000
Received: from [192.168.25.27] (10.106.82.32) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Mon, 26 Jan 2026
 16:56:11 +0000
Message-ID: <afddc163-4b1e-46ee-920a-85de3b347291@amazon.com>
Date: Mon, 26 Jan 2026 16:56:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: Ackerley Tng <ackerleytng@google.com>, "Edgecombe, Rick P"
	<rick.p.edgecombe@intel.com>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "kalyazin@amazon.co.uk"
	<kalyazin@amazon.co.uk>, "kernel@xen0n.name" <kernel@xen0n.name>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
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
	"jannh@google.com" <jannh@google.com>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "kas@kernel.org" <kas@kernel.org>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-8-kalyazin@amazon.com>
 <e619ded526a2f9a4cec4f74383cef31519624935.camel@intel.com>
 <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
 <CAEvNRgEvd9tSwrkaYrQyibO2DP99vgVj6_zr=jBH5+zMnJwYbA@mail.gmail.com>
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
In-Reply-To: <CAEvNRgEvd9tSwrkaYrQyibO2DP99vgVj6_zr=jBH5+zMnJwYbA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.32]
X-ClientProxiedBy: EX19D001EUB003.ant.amazon.com (10.252.51.38) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D0F8140015
X-Rspamd-Server: rspam07
X-Stat-Signature: 1du9etbr7euj85iodgd3qbbegchis7js
X-HE-Tag: 1769446597-171200
X-HE-Meta: U2FsdGVkX18Ar5BQSq1ZXChhgAp8OuK6AkjOhpupIiDnhf4iv1NtDWDvaaM1VfoDJWyOmsr5tEGpAQ57IV1KO9HIYixjHLDcYmFkCLslnmxUUucZMjXJ0327/yUVk+Ndy2/ebs0gzC9sGunjFCJkLYyCmop/CTq2pCNomcGjFOXYbE0tnmUP/8uMifh2Lo9SfbQUv6YfsJvxpPpt1G2mdghgrHgXtPpRfGOY6oFHR/yTYnxJPgdwztEI/HqGPfuzqjwxrVGUsQZg4RQfzJYFC1Qr1keY4q7oL949WAzBlyUuSPaqKo4Vza0q6+l/wY9CrBgOd93AtQBFywHzioHgOLJPJ/XTCMIjjrywuRbKtwYG9kQ8o78EZlbsHejett3O+g6Saq6t0arakgpZwXJ9Ui9sgVwsrB0fpIakgnBh4Tb+F7VEEEPmj6d6tylDPUPa5uDYs42LQHJlGluXzaYcDv9UoE5Tr9HgBkI4pc4dKPpbbn0x4v/9aitNJ0ksl3OU2yjj7TZNVb9MlDPoiY6Ceo6Csf4JC9Muub4oW7NzSNGPcxHzYC3pRMq0X4+zxMBzOJSXsjSFp1vs1fyLxXXUw3cSEEe6ULfOPf7wd6S1rbiIG2pdCJjrA6LFwq9Yv3adwWAq0W2toWhA2hdP6Aydf7OwWanKTfOAj8iFMKkDmwfTTvusjUOTZTkRnEb74Pv323Lmodyt3izpldAf7Hl1xUpx5EhV/JVwRcPOQr9aiUZWEOZ1a/qtTYVDKncbNp64gDInxHF1RydQb2u5uOy81k03g9Lzlzu7Fp8afxDZ7gCPjiYwGQx0f4yUM6+WvmL/+31ld/4+Xxk2bBf9SjLuokLTl2M131+cy4hqg6oz7fVYfqJs+rtf5QZ9TZZmFtBWTlm+TIeGYF2e49Q5hhHycxGT6jGybVoZiwfV7xxVBK8qxizqmh8kMbhUkeioDxicYnYvsVC+gGT35oSQS6F
 QKNj7YtY
 LxAxRwEr6g3VjNnA485LYBwa8NPnW7C8smQlniO8r7eBqOL3uIEvrZKkbtstH8x4SaxIxU6js53RFJf/b7gE+tgAn9Ex0UjcNEhNqLLhToThmhltOmQ6/LSQh1V7Fz7U2z697wzbMTCDhLzdhglOFTsmvaA1dvHWunbeWNSp2/HicZq+TnHdN5KH5CjuwkHURAXOxgJlkoaIUle46528IAizTrssLpbr8VsjPlsTAd39EOLYX6Edugl0gYdO5VPbC9gWO5SIfV6l5VL/J0lhUmRMG1NRzjQ2mMFN+KlyGCF6uj+UoGvYjchZvTGqyRh7EQUTAtL4MrewZaIsq95Bf6OhnLtYRsFZek6XSsBvsp403RzNozxGFvc4crImtPLHVhcZTVdxdGQweO4nctAyI+aWFPGCfZBWbWVDqVRQQgWIsaadfWsojLmgjzRukenX7kpZRCYL8hJEZ/hszn0iVLnKrQgVo7+TxPa6LW0vbrxpVw80mBvYW2ZNyiubsbPKqgJWIp1NUiNKTigWlJTnqaMKd/5VMESeZ2LF3+SBXnsCF233zfkGGwzctqaVOsqQzCpo7EMD/ZAjKbXtIHqjvVztiY2BgwY/EmZkp8nE1uvxqOWBfc+Bw3WsM08mr2YSY9oJjWsYUULXknU/iOeofwJjZpe0bpIFXS4tvERIpFvAw0hDHnCCAXqSF3IbphMYqx/a76ZnTrgVFm7d8KTN6wzlSEjq58m2LGo/cdaQeNw/7P1/18czjTnWU7YB3uaBUxExKfkoEQytTVcXsJHkLjwCvyUlCDWmDcbThrvAXByiHEVIL+NJsxyb3UcR2DLSeYA5BKdor6aUwEB3r5dwRL8ceY7MYEdaEqcut2zNSlu0Cg7/2lbiAJY1I0ViqgvBXzEIFxFsoxseCiOnDXJjL7K9NJuwIODlkiVz8m4vdihzw8MphCt8twsm0u+onfTNqAPd1HJtqLjjLNa3uuJsCfQtbFkir
 vMqsGBYh
 GSVFaNqLK9KkjJvXjYX2KgmPQutep6YQtlsXuqnP9ABwBcLlMwIVGTLRAUoAy4Tj3TrC9a1048uA6xQ45Ga6AzClkkJhp67snPxUr7hrrEc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/01/2026 18:37, Ackerley Tng wrote:
> Nikita Kalyazin <kalyazin@amazon.com> writes:
> 
>> On 16/01/2026 00:00, Edgecombe, Rick P wrote:
>>> On Wed, 2026-01-14 at 13:46 +0000, Kalyazin, Nikita wrote:
>>>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>>>> +{
>>>> +     /*
>>>> +      * Direct map restoration cannot fail, as the only error condition
>>>> +      * for direct map manipulation is failure to allocate page tables
>>>> +      * when splitting huge pages, but this split would have already
>>>> +      * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().
> 
> Do you know if folio_restore_direct_map() will also end up merging page
> table entries to a higher level?
> 
>>>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>>>> +      */
>>>> +     if (kvm_gmem_folio_no_direct_map(folio)) {
>>>> +             WARN_ON_ONCE(folio_restore_direct_map(folio));
>>>> +             folio->private = (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>>>> +     }
>>>> +}
>>>> +
>>>
>>> Does this assume the folio would not have been split after it was zapped? As in,
>>> if it was zapped at 2MB granularity (no 4KB direct map split required) but then
>>> restored at 4KB (split required)? Or it gets merged somehow before this?
> 
> I agree with the rest of the discussion that this will probably land
> before huge page support, so I will have to figure out the intersection
> of the two later.
> 
>>
>> AFAIK it can't be zapped at 2MB granularity as the zapping code will
>> inevitably cause splitting because guest_memfd faults occur at the base
>> page granularity as of now.
> 
> Here's what I'm thinking for now:
> 
> [HugeTLB, no conversions]
> With initial HugeTLB support (no conversions), host userspace
> guest_memfd faults will be:
> 
> + For guest_memfd with PUD-sized pages
>      + At PUD level or PTE level
> + For guest_memfd with PMD-sized pages
>      + At PMD level or PTE level
> 
> Since this guest_memfd doesn't support conversions, the folio is never
> split/merged, so the direct map is restored at whatever level it was
> zapped. I think this works out well.
> 
> [HugeTLB + conversions]
> For a guest_memfd with HugeTLB support and conversions, host userspace
> guest_memfd faults will always be at PTE level, so the direct map will
> be split and the faulted pages have the direct map zapped in 4K chunks
> as they are faulted.
> 
> On conversion back to private, put those back into the direct map
> (putting aside whether to merge the direct map PTEs for now).

Makes sense to me.

> 
> 
> Unfortunately there's no unmapping callback for guest_memfd to use, so
> perhaps the principle should be to put the folios back into the direct
> map ASAP - at unmapping if guest_memfd is doing the unmapping, otherwise
> at freeing time?

I'm not sure I fully understand what you mean here.  What would be the 
purpose for hooking up to unmapping?  Why would making sure we put 
folios back into the direct map whenever they are freed or converted to 
private not be sufficient?


