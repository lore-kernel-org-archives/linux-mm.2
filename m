Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D365ED6CFA2
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:48:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 422816B030F; Thu, 22 Jan 2026 13:48:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D0BC6B0310; Thu, 22 Jan 2026 13:48:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2879B6B0311; Thu, 22 Jan 2026 13:48:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 167B36B030F
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:48:25 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF1F61A04D5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:48:24 +0000 (UTC)
X-FDA: 84360485328.01.558E2B2
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3CFCBC0011
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:48:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=efwLAsQR;
	spf=pass (imf28.hostedemail.com: domain of "prvs=475c5ed80=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=475c5ed80=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769107702;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvBM3L4II/cGkagk2VbdKNvKqQzeUtAnRgo+PSoIV/Y=;
	b=SXlnMoAB1z7IagCfqt3HCi0W+DKtGAJjzlSNvDQQ7lwg9j/A9NILiVkodW31idTICZJdSo
	S2/ZUaY8vpSf1XxI9kHssk8qhGlnfqd8J5kHw2IFfqxqF9t1uz4sIvZY5UG5JwEZcle2jf
	KSsFjgV2nNWuoxwQZj2P8NI9VABjVyA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=efwLAsQR;
	spf=pass (imf28.hostedemail.com: domain of "prvs=475c5ed80=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=475c5ed80=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769107702; a=rsa-sha256;
	cv=none;
	b=sq1yoEkriGxfZoCjYWTYNcvAoWk4jO+O0B2JePd5kEEHg7tlPDmxN6Q6l4lWl2aQiREVMk
	RdGenBOqm0NOmyj/e/SeHnr02jijoh/M5RgIf91yJ2VaF6FJGwOqFDSe/1+6yX7bR+1qso
	a7oARFKQY7kwSRXPrAiB00hTHU6TqgU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1769107702; x=1800643702;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=EvBM3L4II/cGkagk2VbdKNvKqQzeUtAnRgo+PSoIV/Y=;
  b=efwLAsQRmEC8SBq4DybgHIwhFyzudYE/GaGcqTVeTFd0pSIx9C9d+uaX
   ROoQF9yuOmIWTl5SrnrI8RP9fHR95HhWufc1xLMuRvq+sMC7nEGto65HK
   +Mh1fr7ansDXQWbF+5UxJMJsgZlHMB017FwJDJuCQ3ZNHTvbkwRt/hLat
   UB/3IQphaty7i8RL1Vgt+uO7axEyHZA5EyxtSslEanUyuzSwLsHbY6ZIi
   OlAXXmlmbCzh1xX5Y38uThbuj8C9arNPLFGOeB8kIU4/U2ChKlpmxML9F
   1h/EkzkcFWTUpeONPB2KlBqPaRKiM9kXLih3iBGs/RT5Pe3QYumdIgpRZ
   g==;
X-CSE-ConnectionGUID: tcmKhT3uQH6oov/07SCvrg==
X-CSE-MsgGUID: qNQV+8P6Qz6tQEAKSD8cQQ==
X-IronPort-AV: E=Sophos;i="6.21,246,1763424000"; 
   d="scan'208";a="8196021"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 18:48:03 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:17130]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.29.47:2525] with esmtp (Farcaster)
 id 32c357db-7900-4592-9eca-47dae0cab1ce; Thu, 22 Jan 2026 18:48:02 +0000 (UTC)
X-Farcaster-Flow-ID: 32c357db-7900-4592-9eca-47dae0cab1ce
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 22 Jan 2026 18:48:02 +0000
Received: from [192.168.23.186] (10.106.82.17) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 22 Jan 2026 18:47:43 +0000
Message-ID: <cfb0b8e8-b12a-4014-9070-63cfe8693f59@amazon.com>
Date: Thu, 22 Jan 2026 18:47:41 +0000
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
X-Originating-IP: [10.106.82.17]
X-ClientProxiedBy: EX19D011EUA001.ant.amazon.com (10.252.50.114) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: 8kif7mi1yf8d39mk3fbrwmmnupnnt7ha
X-Rspamd-Queue-Id: 3CFCBC0011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769107701-96666
X-HE-Meta: U2FsdGVkX1+HmTgDm3pgo2UswJmH9o8zwi1+thEOYbIScXuTyU79TrNjhu1x/E1gZU2mVvhAW8pLz6sgz8i5F33c+TTtSB/6EJjczirCEdmh6IZzOAGzLXvbRQ5vifKSxZFoHd5ARgN0SH48kuOS8gtoky4qS98We2dOkPRyo3cI8vB5/4L98nHSvBvB7Vd7/xSA3f2vKXrwkN5iiV3Ap6yZZN0ZIN/6YbBgqWPF5vs6RNQIyAOp98hWEBUko30AfFC0JSBVAvC6NXIRrnjuwGZ9cTOLzIA2ZpSkOTDOqEfZLqT3Za4S7c2tiDHkOcPWNwNot0FbdzR/jVvMLRUIAmWibBDfcPH/c8UF70kAfbQ1E463kSqPOHaXy/xT62NHmrHGQCIDyoAEAbTQLSZZSxdI6Kiy9xNNI9VN7Zc5BT3vyUtnWRPc/eAd8MW1LJ8qvs2dX+tn6JBooNl4hbD4vOQ79zK2N2zNNeZG3PFFzy0i0Gci9S9RXgadlNxXxFhxwXmZVHnMnaXIDfIqrZrj3zI3G2W4WQi6mmbrUj/sxWiadQnRr2YDiAqMs+Mm2grxs1HNePOKgdeMfbvzUGvu/EuhZSt5KtbuhOR6/Po5Ste0CiV/klYKm1IDnFMqxznU1ZnxlWHDeh1SWqMMszksLBg4NbF2SJXjXxmdxc64mA+I6dXRet76W2MXGGnxPN4EeIDi2U7eDnElpZyhYu4xoWiu970GRxKBdnx0aPHV0G3LROcc5r0GlXvsGye4EJJRcguzGYLophjRFl6KUTIjOlfNILvo50KTr2oZpLtPZgyBBPCXSByAbX+py/bLGCWcSlhUP4UzdLbgqmYvsXrcTnXOtRI9Oi9O/30sl1jBIxeay68B1W5PAP69ZqgdjipdqQpAhxA+Mh8ja4hj0R+a7xgc9RFkhvkroHeeTrwyIJDccoc6GbGRdm2OfoTiIQ01NFhFwIQN8XChzspKdbN
 uNdE8jNk
 WplaZ0MJn38dLSpONMq3udM04qmgSu2SelFEq0RRmGnYaCwWV9BDYkIEMf1qmn+AZ0tRHT/2Y3iLOgZVQzGaQLpA+bJS/yHsLl4P/vBFQmaEQY3a2mVb5c3M4QoFOH7ceMnnpNl5fNlVPU3RSRURqQm5Ep59yAuwPOg895ACPbyzOrfSUkELa4tz93A6T1LIuuSZjSWe6JjyeYO8ODyow8EvvcscjiISrd9OqRfiPyPx6fiFS7ToZwU9axwA5j1POQ6po0w9/cWOgC9DiKKBccAuAm4Hw+doAU7biSdabqYD9BoXUQXKgjkqWBLhypATgL+80GNk24gDW3PabVDQ241cuH4gfIK2YfEiGiGyevYbl/ZTDSYKlU2rqCVo/LvaOen89e5vbCTB2jOWHE6FnrIZVCb+sV+3dSorSi3D/BGeJ0KR8NMBH5hj+iMxarqJMR9b50rCVjviXDJhHvFjBJroQdqhFYCK8jc+TlmWLlTLkt20OV2Ik7+H417H+jfQepFdURKd8isrWAspwmmNAALUWnwi9dQBuxF1Uhy01YDwhVpRUZhMuqCyUW4YGmBxUcTbRinHSEyidOFW0QFPdmmCxeDyTyl6rCvtS9V9QjbyU2KHx2gF3jHAGFPn5Ml5cGnSOIGa2UoQN4bJk/luehQ6+S+d68J0zjl6ptx8/K5wC2A6Hg/tMXdBU8N2M75gD37nPrss1weHlUe9sPxsBJxMeg93UCJSxAWxPyEf39V9z1rJEfFhrLx6ol3tUdXf+iYf5Koe6HxoykkB1SboDcPSHZ4WneYid1GYuTBAo7v1hQ4md6cIF+2Dl0/0S90baEO3qb3Bjr9QQ0Ql/s0Sle/wayWq7E8tieTwtgfzWH16Gh9Fq7XFGEvyoOtnofRZ6j4Y8VnYP9GIhoTyEazgX8pPekPTLZ56oN5gfl/pAcWi57pU3JFxsrJ03JTf2J3qDt6w3eHyg4btaIweTTULcYZDIBVD8
 S0064i7D
 f3ZL5TUOZwkCTbPgExq7bi3B+dlcGQwpwQwznIpWzN821Q1JuNt3UMNMiLM/+bT/
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

By looking at the callchain in x86 at least, I can't see how it would.

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
> 
> 
> Unfortunately there's no unmapping callback for guest_memfd to use, so
> perhaps the principle should be to put the folios back into the direct
> map ASAP - at unmapping if guest_memfd is doing the unmapping, otherwise
> at freeing time?


