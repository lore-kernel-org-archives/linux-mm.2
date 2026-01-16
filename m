Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0076CC982DF
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 17:33:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65CEA6B0005; Fri, 16 Jan 2026 12:33:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60AA36B0088; Fri, 16 Jan 2026 12:33:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E2D56B0089; Fri, 16 Jan 2026 12:33:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3F1E26B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 12:33:21 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C229C1A01FC
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:33:20 +0000 (UTC)
X-FDA: 84338523360.12.F3D8962
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5186A140008
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:33:18 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="Ue/k4Bve";
	spf=pass (imf23.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768584798; a=rsa-sha256;
	cv=none;
	b=fP86U/HwW9YSy/IajW28U13ASl/LP2qfptmQxTmTT4TGC82zww1M8V8RHt1Doo2l91dSkz
	EntF0CdvQh3E3aI18he4WxPuGeSYc53unvKaUkx8oq0xRDhLwtmeIXRT+NP20NA64mF7i3
	6W4FCSD3kbEWNbJRAfqYJd80Xxoj+bQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b="Ue/k4Bve";
	spf=pass (imf23.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768584798;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JQ9fdAQPvfKL0BQ6nuE1OPJD9/1hgfxOsOgzcBIqcCo=;
	b=AyM4v3JeQKrQl6jGgvl6OqhLTWgiwz26EE1X4Wzd3K8lLKePPmfVG7Z3OZtlv6pDUqvnd8
	laH7EqimIR9AF17kL3lotCWmxhLUe9AaDUBsSeOlql2A5l7Yi2QvG0kQZO+/1E3sPjsmJk
	fcE8Y7SgVsH1jcgOsQwpBSAV7TagbjU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768584798; x=1800120798;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=JQ9fdAQPvfKL0BQ6nuE1OPJD9/1hgfxOsOgzcBIqcCo=;
  b=Ue/k4BveUWlb/FVFDf8RxOEulFH3VnqGMIfLe3gmP9kmaKAQo9f4VVqP
   PNd9YvoNY27sLusouwJiAuW/suQkeTaMr0YloEpUQI4Z3AiA0fzmns887
   ypBgeZbf2KqvlCIItDm4o4Z1Ndf5+S0elfhCMLFuglXHDWTuLLHnkjtch
   7vxdU7/glhdG50YzREK3FHFaHQZ3TA6NoeIr5/e3KuM4VAU+JR9viq2e/
   qlmEDUU+YLkaRXFRKSLYQNSrM5gKb8ssGTceM9zoJScQIK1lYAzfjrFMu
   jlXzzOAp/2+vkthsgvUzS7dX9Y0sKYMC4euHsXh2LUhP1lxQI9caQcZx6
   w==;
X-CSE-ConnectionGUID: mXXvV+M+RuK453p+B3eBMQ==
X-CSE-MsgGUID: MMzLzIdgRnuHEkpgLhJoQw==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="8021986"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 17:32:46 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:17904]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.3:2525] with esmtp (Farcaster)
 id 3abbcd19-66b6-49c8-82e3-6953c2e4c901; Fri, 16 Jan 2026 17:32:46 +0000 (UTC)
X-Farcaster-Flow-ID: 3abbcd19-66b6-49c8-82e3-6953c2e4c901
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 17:32:40 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 17:32:36 +0000
Message-ID: <31e7d93d-0e0f-4976-bff6-84f484a8a6f3@amazon.com>
Date: Fri, 16 Jan 2026 17:32:35 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: Sean Christopherson <seanjc@google.com>, Rick P Edgecombe
	<rick.p.edgecombe@intel.com>
CC: "kalyazin@amazon.co.uk" <kalyazin@amazon.co.uk>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "kernel@xen0n.name" <kernel@xen0n.name>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "david@kernel.org" <david@kernel.org>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"jgross@suse.com" <jgross@suse.com>, "surenb@google.com" <surenb@google.com>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "riel@surriel.com" <riel@surriel.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "x86@kernel.org" <x86@kernel.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "thuth@redhat.com" <thuth@redhat.com>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>, "maz@kernel.org"
	<maz@kernel.org>, "peterx@redhat.com" <peterx@redhat.com>, "ast@kernel.org"
	<ast@kernel.org>, Vishal Annapurve <vannapurve@google.com>, "pjw@kernel.org"
	<pjw@kernel.org>, "alex@ghiti.fr" <alex@ghiti.fr>,
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
	"kas@kernel.org" <kas@kernel.org>, "will@kernel.org" <will@kernel.org>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-8-kalyazin@amazon.com>
 <ed01838830679880d3eadaf6f11c539b9c72c22d.camel@intel.com>
 <208b151b-f458-4327-94bc-eb3f32d20a68@amazon.com>
 <4781ba9c5d16394cdd785d008cf2a2d81c5cda35.camel@intel.com>
 <aWpcDrGVLrZOqdcg@google.com>
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
In-Reply-To: <aWpcDrGVLrZOqdcg@google.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D008EUC003.ant.amazon.com (10.252.51.205) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: o8hnziuopzbspdfjcdukji9n8y9674is
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5186A140008
X-Rspam-User: 
X-HE-Tag: 1768584798-427472
X-HE-Meta: U2FsdGVkX18CrjGoCIOe05wlrYyYv3afCjNdeZxFvkZCTO9iQkVhhW/4NaPlRoAaMincCiAVneyjhEW07abJH0iW6IibjcINvjuoTktG5cXXWlZVqCyhCv2We3dnSTUxr6rDvSGplyJhBo4849Spebzapl1jhevYcS71mlhUoyjv8gHq8S4e/fl0RQiTwnhOVqKxsZJcuUBqiPbKdHkpnMVG6SaN3IN+KtwyGp6fSK4F7mGC1eX3MXankCgFqwAkdRNKG4GynTpbGO+et4YWKT75K7D5R+4OYbkbQRCezvk4YRxh1pwwqManOSCoV3FPyB5Gdc/Hs9Ssxf+I1NzA8nmGl1YATvlBsbeycHKUvxWCzBzXnTR9QNrzp1lH6uAJwBIrSRzzlALm6L+BvxuuDP+xvrDPTs+msci2si3n6XfTcfYdkv9FroLGhhiHT97CD8Y/RDD19ndmbVlJtOOL1SI1vw3Mf1i7Mkm44xIERIbTcYwCtN89yk14oAu04KNIEIkPVEUe25+bYYwHsBYv/mnkmmd/exQmBDIpTNcGwnPsqFYFzVYhviZdX0H2lBsvg4ccg+bIplIZ2GYqjjcpbUI4/ljuvON7L5wM080ZlUOiLH35Qb0eq9Xhxl4EHExLZ2VtwjKWXoAsgTDhwl1NAuRoU0m1ZTNq4MzrmVh4vbKJ73H0otWmBMvccl9mpI93X8bidl6k/H8plOx/GJnMYQiUzLOxnLrvml4AKJxxEn8CV0ityk4/nD9ovpGVdZ/U2u1G/KWqXIgHHFyXkH6WThVoYW5cuod00t2KVp12pE9zZT+KNuZuHv4MjbhXFOTx8XQ0KnN9mAZKqw11uA2Y0Hamj6Hwuk9YAMuuEKN0r0/vuPldHTLYRtxTUc+w0Nv67/HZ5FCh0nVHAN98kJ1KdOo0knlLnRIhi+mR1LbOEjVqC8QYN0XWZmEVAGQHsx5D2fVPs/ndygU7r9siRX5
 5ip9r3Jr
 I6iLV6Awl1GNSFHR1GqqZlV+/UzCY+YvIg0+7ayYXnD2DH0+KVaBpN+DRayUAAHkQ1qJOoBlFUehM56LBnDu9Oj+RvaVj2QCE8SvzjdmIj2kjTqUr20P9UdI4TyVLQhHHTjBAlC5cnUSSdEEWOyZuZ6S5CvlNM8B8gryc18b8xygEXHdNAY4ah16s+2oAhV/aUDtq0vLsao7C0AqPQQYC+/oRL4l9Yjg5oqx44rh83Dx3d8DV73EGS53u5Bj8XcXWc0OW7ncRBw2HZw5KUelX6lnOpJv6INx9S1ThMVxGoEoBEp2o9XcozyoFGVr7f9lUNv0yelK6u52tKZ2ckfQ4gLcezaA6/lgaOGlG2vDv8HVvx7jBjvTeaBVZvN4BpqdJ1JgZZUmbw8y9Gfs/wt1eeb1hS2RnVO2n/7cT/Mb06T9sOtepxz88XS9H0Y1xEV82oZR397yTbIVVXriSw7dRz2wRLUEKhDdtQPLEPsm5qgmKUkLYaIEiW+Lndd/R1UAu6Ncdyt2+PCXecEJkgbIxO+enmmHs+SXLA3W94028KCHpv0iWj3EWZOYWHHRGfJ9QPxoGSXrsrP7xEi9Nod4PcYuPzQ7s/+emEGj7aE/jl+8weMgCw/ExcUx8D5/SslJwCW76cgvuIv2hz5ZAoXRS66jIGx1vbc6ImjEe4jKW/pi7iK26mP1/lQwE0j51Yg28JWzGgTO3RbkmnNUrtQL6rccc3m+D8NVF3aArpL/dtulTOJrOGxGf6bJp/GK4loQco43R/4Dl7dRRV1n09B38qXChsXlIS/EerKtiNqFXYSd3cfI48XxLNvX+FttgcsHhI5VJwUiuKUJLug2cBkfhC7avH/Z/y2AwCl1sLgKao3AMopir6IYiJgGZLUUncBQplFqbtAiK64AqAhzfD4iZORfV7W4Freq0q/iWMgfyOYXGoLQDoFY9dfTIjIWGHI18/O4QT4fXq2HDj4FErOlw+n9BqzBl
 KlQYe9yD
 SZxGegqGKWpANkX8y6rn8ltm7hC4P2ys
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/01/2026 15:41, Sean Christopherson wrote:
> On Fri, Jan 16, 2026, Rick P Edgecombe wrote:
>> On Fri, 2026-01-16 at 15:02 +0000, Nikita Kalyazin wrote:
>>>> TDX does some clearing at the direct map mapping for pages that
>>>> comes from gmem, using a special instruction. It also does some
>>>> clflushing at the direct map address for these pages. So I think we
>>>> need to make sure TDs don't pull from gmem fds with this flag.
>>>
>>> Would you be able to give a pointer on how we can do that?  I'm not
>>> very familiar with the TDX code.
>>
>> Uhh, that is a good question. Let me think.
> 
> Pass @kvm to kvm_arch_gmem_supports_no_direct_map() and then return %false if
> it's a TDX VM.

Sounds good to me, thanks.


