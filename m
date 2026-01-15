Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29557D46607
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 17:46:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8728E6B0089; Thu, 15 Jan 2026 12:46:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8463F6B008A; Thu, 15 Jan 2026 12:46:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742E06B008C; Thu, 15 Jan 2026 12:46:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6367B6B0089
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 12:46:18 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1ACA3B984A
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:46:18 +0000 (UTC)
X-FDA: 84334927236.24.D92C22E
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 9731C180016
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 17:46:15 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="rbDrIsm/";
	spf=pass (imf24.hostedemail.com: domain of "prvs=468bf17a8=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=468bf17a8=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768499176; a=rsa-sha256;
	cv=none;
	b=JWCpO7j/FyO1H89LJ9mOyWBrJGjSCrxIzA1pgZq23cM0rhMOZ1VCwds1IUmtEnHdJdvrqy
	joaug8MIGsa1zEFRHX5C5TKxfEnOeqwzVPGij14OMD2RpJMdS/Ksns1FQPFf6FTwCYdR5r
	RKLv6aQDi6pOjgw6j/wSq5x94lGaSKw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="rbDrIsm/";
	spf=pass (imf24.hostedemail.com: domain of "prvs=468bf17a8=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=468bf17a8=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768499176;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m/H+6KLBn2aGntJJ8JBW+O36kdoVRhTXFh0DlSdS7kQ=;
	b=o9Ci4jgqFuZFXTqN+qi6+atmmtriYzB/4awCY+J8BgeKK81bV7JYdEFGliUFQGZAPMM4xv
	kdhh1VIscLrulhON9ySR/CG/CGJBYwswXeDxcDGGYWrJGKZOLkt/Xr/0F1k0mfRdfMaHWn
	7KjREQpQYyn1GEH8eChpDtnhQbZQNOY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768499175; x=1800035175;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=m/H+6KLBn2aGntJJ8JBW+O36kdoVRhTXFh0DlSdS7kQ=;
  b=rbDrIsm/3epApf8UQGqTmFQAZnPNFqcS5DHmAD1D13gRQcAE7EorPFRv
   iaWBk0XsIVbcuQgrliIslS8cD/APg5Jq3/2sG1shBBACPmyBzg+RfyoAP
   YfkiTg+TgpXT5TNGl5iC/u6sUk28gEl2YP+gK6OyNNk4h5Wl75MpMPjCH
   MUOpiJvwTfpVKX2PxAY0sYDbm1Wbcp3lYdE1RBLSGBO8gEfrVRdBjnGfT
   VdDWBi+kW97zIJZP+KCzy45D5rSbNWkGitUfUUCWyYUW2X1d0HhfVuppK
   bxJTbPPO3bZSxtJF/kUZpyLWAQz711nYOemJwSTcW5tTt/GRFlaBghgPG
   A==;
X-CSE-ConnectionGUID: UZboAnEGTqq8ocdnm/l8TA==
X-CSE-MsgGUID: oh7w6HfgSl2x9siR+geNHw==
X-IronPort-AV: E=Sophos;i="6.21,228,1763424000"; 
   d="scan'208";a="7872674"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jan 2026 17:45:56 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:5968]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.2.33:2525] with esmtp (Farcaster)
 id df1a6986-76b5-4a71-8d9f-e42e7d836f1e; Thu, 15 Jan 2026 17:45:56 +0000 (UTC)
X-Farcaster-Flow-ID: df1a6986-76b5-4a71-8d9f-e42e7d836f1e
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 15 Jan 2026 17:45:53 +0000
Received: from [192.168.15.69] (10.106.82.11) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Thu, 15 Jan 2026
 17:45:49 +0000
Message-ID: <34b246e9-0f7a-4ed6-9e43-845c4238bf41@amazon.com>
Date: Thu, 15 Jan 2026 17:45:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 01/13] set_memory: add folio_{zap, restore}_direct_map
 helpers
To: Matthew Wilcox <willy@infradead.org>, "Kalyazin, Nikita"
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
	<peterz@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"song@kernel.org" <song@kernel.org>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "john.fastabend@gmail.com"
	<john.fastabend@gmail.com>, "kpsingh@kernel.org" <kpsingh@kernel.org>,
	"sdf@fomichev.me" <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
	"jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"riel@surriel.com" <riel@surriel.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
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
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-2-kalyazin@amazon.com>
 <aWkN4yzwPtotaTeq@casper.infradead.org>
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
In-Reply-To: <aWkN4yzwPtotaTeq@casper.infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.11]
X-ClientProxiedBy: EX19D004EUC003.ant.amazon.com (10.252.51.249) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: x3crsx6j7yaqs79s9qk4pu4j86ighgdn
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9731C180016
X-Rspam-User: 
X-HE-Tag: 1768499175-125964
X-HE-Meta: U2FsdGVkX18X13riuWsbYXDA62vFKy1D5TLOSqh56GVolJWAtx25LHB1MTUTRtvy6V8U9oRyAyNEdu7Bi+8t/GBTnum1zSS/bgn3Dwk0DVFNOAMF62ww1qtsMlqS4bHK5q4YNXh1vAM03Nvzkb0cgQl0PxJmllOiueQUaWnIPOr9BD18PRoPAWI9Klffqn/t9tgSrUjrsb9dGnuoAkhjYzhWVf4eygdN0l5T5Bg0tBJp/BTopzHAmXjmwhi8nArmMZxbKLIuWWeeeSCBl7VwvBISWjWHr0RLkq5o0KOprX5jvg+THo5u5WVMMHZTbG8o/8IMieGdDYiMsQRQ+1xopdi6Xp5067/MNy4yn3nLg7Xz03aAVFBtSy0MqNXRFzYolE2TpRwQTFAc2aQfBTA+uqPyfXgmHlyauETBylZhb1mszRLtZXzVSWp4rQOSMOycPBb1dmv506hbBCZ3l8KcZc1eZTzvIKj6gVVF7VU5re5iaTkKg5yWOn5ttGcRrCn84Wme9UWqVUy76CBabyRp2jfBkA7xfPM2VU+9yF1eJAhWIzi7E1FK8A2C2gkSYTXIvwnO5E5juctMNKHpulK9iEMm5yRVBJaD6afa6gpLntPezt7d3JWaju7W6doPKZBvd1uPXCN9XdF7sb7Ejho4MqdXSh/1dDBVTO+hIQGNGD8G3vvfwSrhJQfIC/0FnYulTuIwOUr7WxyG9xrP1xgOuP6pmNAuXVzRDi9nkPqR97KqVDJqwU/6MyPFfFKbJRR9gJpnqcPt1xTcSc0tniotOqw3tYHZ0JTZy4dP597prvCiB9eDWyOxaY6eFfk1gHcGMFU7/fS2TdBfMbJyUtn6U2dyBIsIzx647v9Hc0mw29XG4Iu5e2G3NoA2F3Q3mW59jox7t6UMaVGUSQF2/NstJLgPbWopUAX/ifZmgwm6dtkMugX9a0npYOp0/1zuNKbfjLXFPf0QwyfGB/YqGoK
 NBBUW1ik
 xl/VV5tjt5wmnItEg34cpTQbuq3NYZvKF5yujrTK0KRm3bwTZdfvP+7TIW7GsCBJb6TT1T9Otd7+W0a4Ctw8hP6gLyQmnIs0gsI7ez/XJNWVtkSB3/1N3ht2hDXBrepy3a1INSSP4gGGbTBaAx7ymsOf8D6+WSFUtnQdbTaF9otAhzZbAIYnleJyVmfcPyuk3nId6ZKK31zlbNPUUybgW1Fea5mkLEbESTrQ23i+kw/S6sux7KiH8V2XnAGYClVCMP0cdlgKc5lXGb5oKBF01Px4pTx7hbn/3W4G/nxK94LRhmgr3JDmcPznt/IbUpdjYwg4DiK6dwRI4HW/FHgfjETFeSWUE/ISsCWfZdNyR618Jdfy6w5IDcrI5FWdUn1qcy/4QjOeV8aT5ymTd08sXf5CBy+X/MFL4xCrQ2fR3ovcM3yg601bIzbw/bByf4vT/k2PCx3M8BYZgniPSXm5eo2vnEiKcb82MspgbY0bL19qxUTAK24vxy3AAynBo3lZsDNwMwKK03N5s0/eKEX4z4cLAm88YKbOk6EM59y8U7sfRzLsLJQkGSRW9w6Mvyb3hTSUTJIuFoLthhXTaok/uaTO6vb7x1IqINh0Nr8c3NCtHve8WKLiCppE2N/8VJvTXgIYTp6HqGOFRyKMaE2KkeIFwTNiooKIenqAuduRQ3ozS9ZQ68QMpO1N62pf4vPAnAa9OlZTgvhYcwqe0CliTJCiJbMwTIxhas60lqrUYGkC2ssurj1Kj9FJd303LznjASGyI7qT5eHHhPYinH2w7/lqtclnRuj3Ys3B9x9BRgsujzH1ur7HiGO8PxvgZGkqTN888bbYDr8NOD4y8t7Rq84BW48uQ5hIUTML0R0RoaewjHxyBC0CpWZUEfbNAYSnxcaHqyvOfbLY9qLwiaOZ9S8yPqmd5Un9imXnjA5npYLFZ+3ivs5MpEM7+O7lIta9a9qkwKdNwiS2Im1RhCR17he4nSsu2
 G7GQzbBu
 vOzSxjW09Nznxr4G0d7cIKp5UZKZ8MwU2ECw2bPvpd0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/01/2026 15:55, Matthew Wilcox wrote:
> On Wed, Jan 14, 2026 at 01:45:23PM +0000, Kalyazin, Nikita wrote:
>> +int folio_zap_direct_map(struct folio *folio)
>> +{
>> +     return set_direct_map_valid_noflush(folio_page(folio, 0),
>> +                                         folio_nr_pages(folio), false);
>> +}
> 
> The implementation isn't the greatest.  None of the implementations
> of set_direct_map_valid_noflush() actually do anything with the struct
> page; they all call page_address() or page_to_virt() (fundamentally the
> same thing).  So converting folio->page->address is a bit inefficient.
> 
> It feels like we should change set_direct_map_valid_noflush() to take a
> const void * and pass either page_address() or folio_address(), depending
> whether the caller has a page or a folio.  What do you think?

I have nothing against that.  execmem_set_direct_map_valid() appears to 
be the only other user of set_direct_map_valid_noflush() so it isn't 
going to be a broad change.


