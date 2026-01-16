Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 277A3C982ED
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 18:17:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B4C16B0005; Fri, 16 Jan 2026 13:17:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 539256B0088; Fri, 16 Jan 2026 13:17:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F0BD6B0089; Fri, 16 Jan 2026 13:17:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF356B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 13:17:17 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D52091A0213
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:17:16 +0000 (UTC)
X-FDA: 84338634072.18.51B5676
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf10.hostedemail.com (Postfix) with ESMTP id 58566C000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 18:17:14 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VYaDnNsO;
	spf=pass (imf10.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768587434;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YapVUMmpOwobMagVZxDJCeWDb1gq+ZQf1FJDAqu8vU0=;
	b=dKkwDjdKzEVsxEWP9PfPwuGx0/yJ0o7Nj4fllQSMtQF8WOyjMh6aXIjaUQlhYb2Ld2BAmo
	g10ePRj3L5+6b43WLuguCfT1tFP3xOc5Vik4WrInHbXNYYq+6uqMMG669ilipymm/d23lG
	VpAShf5adOCqune0lDB2l2ZoKbEJ95A=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=VYaDnNsO;
	spf=pass (imf10.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768587434; a=rsa-sha256;
	cv=none;
	b=DF/ys1Z96akSJzwrep8YF+qBW3oqTqst+3AKLwj/2+kdM3w1mWJioD8dZeyamMYDgRz/by
	LtcPTSrTe9VIpx8d808uW4a6ZDXsXFloKMO6Mum60AmE0LzcXU+gfjgbxgs+CaaZMi4x/2
	Y9W04gDjjpfxr2WiqEB2YGvIKmmydWk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768587434; x=1800123434;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=YapVUMmpOwobMagVZxDJCeWDb1gq+ZQf1FJDAqu8vU0=;
  b=VYaDnNsOXe3tvOc0avSlLKzEgFfshIed65UMoY/one+laWq0gQq/14P+
   EBPzYBmrmVtIpPQ7wVGYHnSCc8CFuL8UmxvfFesFjHNLwXt6EzV9c/IhE
   o9PaMdIC3a+q2omAnfI0H0obeQY9H+YfggP8LmZUYRK5sQwe3EgAQ3fW0
   nyCEEMDUo631LFKxUt3q60eeHDTh4FuOJ1c4d7qK6mFI5pn7St/IpchkS
   jALxFm0nzKSNitH3cx9BLujUZfaa/JBcSce+km60Gr1UsqjAixs8hWFok
   mI7fuF58O2FGgtJp0hiVozzSB86C5HiYxRsm3Z4U9FiXo1SgruHMDMpd1
   w==;
X-CSE-ConnectionGUID: NWjda1oCRYKn9baULLv/sw==
X-CSE-MsgGUID: IK3nVvd5RcyK2jXvKFHlAw==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="8025027"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 18:16:56 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:23681]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.163:2525] with esmtp (Farcaster)
 id 6045a328-4a68-479c-a4ff-a5f3e38bc599; Fri, 16 Jan 2026 18:16:56 +0000 (UTC)
X-Farcaster-Flow-ID: 6045a328-4a68-479c-a4ff-a5f3e38bc599
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 18:16:53 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 18:16:48 +0000
Message-ID: <e4cc7e98-9c1f-4ced-a22f-5d0fe29a6893@amazon.com>
Date: Fri, 16 Jan 2026 18:16:47 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: "Edgecombe, Rick P" <rick.p.edgecombe@intel.com>, "kalyazin@amazon.co.uk"
	<kalyazin@amazon.co.uk>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>
CC: "david@kernel.org" <david@kernel.org>, "svens@linux.ibm.com"
	<svens@linux.ibm.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "jgross@suse.com"
	<jgross@suse.com>, "surenb@google.com" <surenb@google.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "riel@surriel.com" <riel@surriel.com>, "pfalcato@suse.de"
	<pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>, "rppt@kernel.org"
	<rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org"
	<maz@kernel.org>, "peterx@redhat.com" <peterx@redhat.com>, "ast@kernel.org"
	<ast@kernel.org>, "Annapurve, Vishal" <vannapurve@google.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "hca@linux.ibm.com"
	<hca@linux.ibm.com>, "willy@infradead.org" <willy@infradead.org>,
	"wyihan@google.com" <wyihan@google.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "jolsa@kernel.org" <jolsa@kernel.org>,
	"jmattson@google.com" <jmattson@google.com>, "luto@kernel.org"
	<luto@kernel.org>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"haoluo@google.com" <haoluo@google.com>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "hpa@zytor.com"
	<hpa@zytor.com>, "song@kernel.org" <song@kernel.org>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "peterz@infradead.org" <peterz@infradead.org>,
	"oupton@kernel.org" <oupton@kernel.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "jthoughton@google.com"
	<jthoughton@google.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "Yu, Yu-cheng" <yu-cheng.yu@intel.com>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "yonghong.song@linux.dev"
	<yonghong.song@linux.dev>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"shuah@kernel.org" <shuah@kernel.org>, "prsampat@amd.com" <prsampat@amd.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"itazur@amazon.co.uk" <itazur@amazon.co.uk>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
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
 <294bca75-2f3e-46db-bb24-7c471a779cc1@amazon.com>
 <bb58a21f91113ca39f8888d718d4450a5fd72808.camel@intel.com>
 <318407ba-ecb6-4691-8911-645fb8c20250@amazon.com>
 <c42cc00f3902673b1a964c3d098b8c3f236cf9a1.camel@intel.com>
 <98b8ea1e-3bdd-4987-8acc-58112076d451@amazon.com>
 <a84835708eb92d99ba524149bde819c4ba944cb9.camel@intel.com>
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
In-Reply-To: <a84835708eb92d99ba524149bde819c4ba944cb9.camel@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D006EUA002.ant.amazon.com (10.252.50.65) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 58566C000D
X-Stat-Signature: pnrb3jysmyycr6dhqmrykhk9sqkqh3hx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768587434-598014
X-HE-Meta: U2FsdGVkX19RlydWngo/bXMw5YBIaHv0szmasuhNhpbV3CSpBdDyhifyTyC4erEyrIJeHk4nEnx6Tvic/uaNnT2yiPMjiWtZWSoeYxFwLsninG8JYUMH22OUX5smx3xAPttSzeSzCv+Fk8H8tZrWQWeXsY3CenzirNR4+TcWXo15PpbxMCJkml5Nl2DWY7h6TzCwsFD4H3eURNGrY4aCkFmEqMTLxtj/sKloOexWIkPyj30BOToDJOM6VzsmE8pzVJxWenaBPFS3Zof87ABVLwy9mg6dnP04yFjSgv5i3C3MGmO9OZjmasckuYWn5QmvoC7wKSd5CFdLLs5s9sZltKwMqz1C+7q2SfoXVOuuqXuyNRfLDH59Z9oY8AtJCnoHtUIEY1PPMwCl2WmaIMhHr1MJ3U7pRf7bxqZuUeuFt7gQAfV4MLqBZLbxIMqbEMRWdjYZfY9PBvUhDXrSlgbCHLaNqv7L1ggQyoomVuTl2+sFZjS1WF/m8xXKwCn7eRD0KbOfY7lvYUEyWNOxkY5cuC5Vf/vbrDaZm+c1ZRyWUa6Lg4qlSPAO8o1JUiWItJ1/LKonV7CsaKArSL3xmJ5F/CWKAi2YM7KWAbaCP5+AIrdkGXQzD9fNQCQrN1KHeXa+3piiZ/xD6wm0UlJ1Fm2bUZA/KO5eZ/rtZzzoCuNrFOpB2Qp2q1K/ZKQ9bLcahGGmILCDCA3v53XUUQsWRov8iLjAUnFqKgtm1jOT6e4CPOdJ4MX4R4JIoOF+AIkDTm0b14mg3XShpjYHG3WOJI5CIB+bz9AjzamU8XxEgymolwPIQtVVXoxwRCIjcjc+Z0pRSPLEe7jPJuIsmlBfoXNqFuk36sagaysozmrWMlwwZiVINeSe2TQ5BN5k0jlYBlYN6kNTUmJpVXGqUogmKYKt4tAC18FOdmHipaQUQHitvqql77LCWzx3oe9jyaWgc43rH1ykPYyIj5mIL2bzCiJ
 GFXdsOvK
 OSyIMAnQztLfUqlpYTlg0ObqgdH2EBbpvYztzmYcCG+dRTfcx432fsIjIfHsR4UGTd4bogi4XeV9SsOuCf+NV5KxlIOEoLy6yRCcjapjU7pN7Ocp11JybnVZ5g3Bhow5TjQD8oeV8lIHoc7Ntz3p2dKXE/aNpymQtwyj5yg9hc1FU6RR0NfN5+tgskNPsR0yyQIGi+1LZUFrjJhtQTeS0dtASfgtL0ICTmktt/ZUTnJSz0nuKDK1xBZqKAen73aqjnMfybJkZalw2E3Ch+1DTGBny2HkOSZcymi2ARrNhF5QSH2d0YIUTHezpi5KZAtR5+/Lbljyb9/+OgihhGe/wxOfPwfcflOKZnPdeTD5ksy8VVw0iyMTTP40t+frfX8HBjAblXHAX1JgZAszKr4Fom4X5O56zpEsdWV/iEQ+hRHKBYWkeSBk26cWEox9TmZSdv3BonX39vpXWBGaog3iDZp7crCkMnqcMbnDTn/A0x0iNxJacYdS+2ZypzlQc8ZHsU8bdO30B2k4ViDzmC3vP+vpifGW+FREn6OTerAZltOu7e28C/1Laj6uLOOiKPIW7+EjEj5DNiYWXmw9bGNStYT8LWZ6WQdFj8PUOph5b+md6yAwUIe/pnEqDf79VBTmJ9rSNPWFiXZVcBtNnrrPQ1hyOfZCFlVDV08wTnWe5ZRGDi/HFPfLQaXkXMMHB09vIEChfxOgiuf7EH+gjBLmFhlq6qSxmfgQP6EvqPOTxFnQ8HNuI8NJR6kpN9BNbNomZdW0Pz2bGdz5TZVOCTpMt+UcUy/iFuvcidMhUAmyuaF/p3ZAc1aTnG11WIXRUwWzYzJAyJI1q6aRrdHSeFXqxMvIzginUrvQeBm+141XjdTKXMYBbZS+4qczr629uw9MhnZoXaNy4BHNVErAhixv+N3NbrhB4jlQGz+4K9M/qcepTb89WUaTDDt7ymsvMGlty+HRXXDyuwXOwSWlFXfOFLUCaWNg6
 QAG3Vd+I
 34MojLNs487iJxnDbThIsnleDlJTxGq8
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/01/2026 18:10, Edgecombe, Rick P wrote:
> On Fri, 2026-01-16 at 17:51 +0000, Nikita Kalyazin wrote:
>> Yes, this is a problem that we'd like to address.  We have been
>> discussing it in [1].  The effect of flushing on memory population
>> that we see on x86 is 5-7x elongation.  We are thinking of making use
>> of the no-direct-map memory allocator that Brendan is working on [2].
> 
> Ah, makes sense.
> 
> Do you plan to merge this before the performance problems are
> addressed? I guess this series focuses on safety and functionality
> first.

Yes, we'd like to merge the functional part first and then optimise it 
in the further series.

> 


