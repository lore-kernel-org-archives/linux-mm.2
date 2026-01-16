Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BB93C79FBD
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73DFD6B00A9; Fri, 16 Jan 2026 09:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EAD76B00AC; Fri, 16 Jan 2026 09:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFBD6B00AD; Fri, 16 Jan 2026 09:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4766B6B00A9
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:56:23 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E0E4C1A8E2
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:56:22 +0000 (UTC)
X-FDA: 84338127804.21.0701B12
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf07.hostedemail.com (Postfix) with ESMTP id 59A4740007
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:56:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=E0kFmVWd;
	spf=pass (imf07.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768575380;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEO4wkDrWsP8gb8dVRwVt7tfKvgBUuiF6zz/e0uDn6E=;
	b=iGVR3QSu/hmSNz4HwqpugbD1Nhi6h98QQC7l3c8eruyWNgYI38ifnQXy9yJSOFGiFzQUFa
	2anv76QCmrRXkLzLA3Qs7Ww2HPC4fX61xePSEcO8JT/J5Yh5Zu/3AbnRFgL1KOPl/wHh98
	c9CJgpeyiqN+dSmCkOBFcQ/Mt+XCpoI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=E0kFmVWd;
	spf=pass (imf07.hostedemail.com: domain of "prvs=469074ca4=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=469074ca4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768575380; a=rsa-sha256;
	cv=none;
	b=TcmFKGjtgUcrenkDqXyTq6aeAi398gYcaXYhAcq0ehkJI9F809Ae3jxkhRSQyaQW3WCRr2
	XWkdlNCr98xhPXZSN3OxmhlFz4QLV4TM2oLcSE4Sux7vWlyiaPyRbe9U3uXX5PsYtDezQy
	y1zksniYDvnywgwbXjfj3Mlj2Cuf6HU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768575380; x=1800111380;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=IEO4wkDrWsP8gb8dVRwVt7tfKvgBUuiF6zz/e0uDn6E=;
  b=E0kFmVWdSct5dPf1WwjANwcxW4WVDYPPlQRzslfKBnZ/I3S1SuWfdMaq
   1JQPcy/oHEhO3uC+e6uWsXpKSvAaCmHeKs+RxWLKYseLymm3iwE7KdXVV
   b2DDnEl7jP3cx/tUEYslwJCNf74M6KhcPL/Mqs315NbfF7QG9HGmP5kvU
   /4XLKosJ3GbYB6qFxXIR9/KHBSwWqAHvgVVIg6X5sz8yMKhiHDU4gXpnN
   Cpzba0zDFv0s7VAwnBzYOf9RtM1xQ4l5BCVOzJa7V40a0CDoQzlZvL6YE
   aKZYBjjZKXUKypX4QQPcdTOp/IPvgK1s8d2GPeLF13f+wHYMxBJQ8NKkp
   Q==;
X-CSE-ConnectionGUID: t80jrskTRzKiYCPAndralA==
X-CSE-MsgGUID: hn4FZT+mTRGLqNyYAxxD5Q==
X-IronPort-AV: E=Sophos;i="6.21,231,1763424000"; 
   d="scan'208";a="7704673"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 14:56:02 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:3849]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.41.192:2525] with esmtp (Farcaster)
 id 260b6298-10cb-4eed-9151-e85b598fcfcc; Fri, 16 Jan 2026 14:56:02 +0000 (UTC)
X-Farcaster-Flow-ID: 260b6298-10cb-4eed-9151-e85b598fcfcc
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Fri, 16 Jan 2026 14:56:01 +0000
Received: from [192.168.12.13] (10.106.82.9) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Fri, 16 Jan 2026
 14:55:57 +0000
Message-ID: <6b50a83e-acd7-4db3-ae9b-015ffad4f615@amazon.com>
Date: Fri, 16 Jan 2026 14:55:56 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 02/13] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
To: Ackerley Tng <ackerleytng@google.com>, "Kalyazin, Nikita"
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
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
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
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com"
	<jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr"
	<alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "Jonathan.Cameron@huawei.com"
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
 <20260114134510.1835-3-kalyazin@amazon.com>
 <CAEvNRgGrpv5h04s+btubhUFHo=d6mBFbr2BVrMt=bWuWOztdJQ@mail.gmail.com>
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
In-Reply-To: <CAEvNRgGrpv5h04s+btubhUFHo=d6mBFbr2BVrMt=bWuWOztdJQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.9]
X-ClientProxiedBy: EX19D012EUA003.ant.amazon.com (10.252.50.98) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 59A4740007
X-Stat-Signature: et67orpzdxmjceuaeuy499xabcckaoqh
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768575380-840529
X-HE-Meta: U2FsdGVkX18BLFVMgGq3zBAB28ZqIhYgjb0hQg798izUp09WveuGLQypcw+5FnG4VpFFeTrLaQ/Ude4BQC0KI6JknU7hS5KQ06tuKaIbQnMXE0estwAk8HvoBErbfnPFazNNjo5VmlIMnM68RxxeCJa3gGl5myiWRPp25p/pde/DCWoU9vXIWyg1ZyOedw5DDQqRPPLrwFgVcu1EACjFymK6gyenH1HpmHogBEoSTXWxrlhgxltdNtcCBgMsSNSK+2xWfXW1f1/XTEziv7Bw1yedT/603JASc2Y1r+vBFbJ9a3DMGtsuQxrjt3JfO6Lu3SKkWN/+eahirFGJsRJ3PEaWM36N3uh84qOSoE9e2eFpAFc2lIX1KPwwzrjCuFrL6DXxxHbYHUfUm5uVTAAVTPBhbhZPJb8GARd7zGbnWc0q4UJ4HknekaZXpvyenKyIYg55ZoUaaDrSN0tPnz7YysBijtTZUWdIQlmFOCz6b6DcveHK9AvzFJAoT5ynIG6XH9WKyTpux11jFn+Zeg47OurBsPhg5wH+42NOzr6+YimzplRnCqDjgar0vouqcWXPcgTJ2qY+ysh3P34iQGcY3pkhrCgcfzsh96UHMqQ/njINvPUhctxFUdKkiLFlRGOmp3nAreMCyqW7z8djff9r+JhYI5jEPpBo9G/cpdt38SPbtichMv6/O6r0T/U9SLdoW/3dx9muT1MxrXdZMmyGkKSPskOHY02XsbMDb2IyEPMstZK890MIgZgC/w/U60FC7RKos+nYeASvx/rO3ITKpkyrROabW5iPya/NroYWN8h5HdvpFhiAzrFOlvmAphYBlsxVEB2rLUMKVNBF1HZCOo9onjKhjPIMM4+kiCIFWCiKA/CiamUBJyz7jArBJJ4wTGwoP8Kt0pKnCdTjoa+wGoSeifNfB/mQlTx4lSy1yVtifi1LHVA2LwP12HYZ4uSyquNed+r6tFWvXfaaOzS
 Pd98R10k
 kEUMQ1cJ7Cg6xlvmklylX6tGPL2wngQS43L4R9Gi+wVLrTH98zIr1fZFy6mGz+0VXjwMqMRKtOzD+UR/ot/3vqKQMxLusxBDKXWULZwcg1fkLDX2rDDuZvAovoGs5+N8FPPOMJ7qS4jtZSxmQaZRSSRnSpPUf8wNKRvtrgxggoznMsi0dGVzy+B5fAz3gPHllSiBA1w3XqCC9pcIuZlSlwedei2m3iMAYMtG3pu8Y+X4hcCh96QAKSdR4WOAFgxndE6s0RRLgy8RWzd/Cgb6q+67x12ye058iCDrv5dsE/fjaVB8EjSUTWvyWe/9yD/RQnKDj7jdh4/1Av9D0pOpbdzNJmHasiaq9bH9DOwEPfhibDF5Ke5pbnUhbsPgDBAZ3AwJ9cr8A8nQDPHzWQzddI/w0JijR7fxZkqf13aLP/xoOtxqN0JVDJaGhw0o3KE816TS7C7gFXV3Hw+bJGtee3XEI6CHfanOU/o9SOFcHj+bV2H4HZPCFbVeZ66Wxt4cSaZ182DKbPPPhQl+0i9/bhzz2Opl91pBIjM2hZJdnLvsIlhEWOG9gOahrEkTAnSmvrrdX471Kx12siuWb8Zw8nL2+N13NEwx9VM2xszi2ZIzkn7yXUxb3If/6T/rg0VJO4ccpiYDFl3m2omSk5Hw7vki6v5vKvUjX9fTKDcLC1/xbQi6XlBGiCYCCnMmxIBl8OQHgCnMvHWgjgLwhNN8C6y+XWvpPV8IaLmsqfXrL9DVP1nvDt0L4SUvrHt1uXpyOCP9QR2Rza9LychndTCMwF0E0VVTw6JyuiCGlceCTKom1dYeH0gxg+Owjlp2wgp8VtUGqFePDzAQel3PUqPwjgjFq3RqGefgFw/FQSA6/QosfHjgtPRmMwmIlo/t+/yOvC+3W6O/vQZEvdz9Ne+gwBvjFmBQbn7IyRIdQqfDRqOS7K6cDgxHnZMTwzD0jKjv+cZqgNWSY4F1OhWqomQvhrasE3bsM
 7b2nGBcC
 XFmfrj3sGeU1/16AtER+guFr1CGx93nsBgl2TNchq5SH3akIx4evrzCNZqUySA8nplmNRzvw0nflq/prXIVmsQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/01/2026 21:40, Ackerley Tng wrote:
> "Kalyazin, Nikita" <kalyazin@amazon.co.uk> writes:
> 
>> From: Patrick Roy <patrick.roy@linux.dev>
>>
>> This drops an optimization in gup_fast_folio_allowed() where
>> secretmem_mapping() was only called if CONFIG_SECRETMEM=y. secretmem is
>> enabled by default since commit b758fe6df50d ("mm/secretmem: make it on
>> by default"), so the secretmem check did not actually end up elided in
>> most cases anymore anyway.
>>
>> This is in preparation of the generalization of handling mappings where
>> direct map entries of folios are set to not present.  Currently,
>> mappings that match this description are secretmem mappings
>> (memfd_secret()).  Later, some guest_memfd configurations will also fall
>> into this category.
>>
>> Signed-off-by: Patrick Roy <patrick.roy@linux.dev>
>> Acked-by: Vlastimil Babka <vbabka@suse.cz>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   mm/gup.c | 11 +----------
>>   1 file changed, 1 insertion(+), 10 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 95d948c8e86c..9cad53acbc99 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2739,7 +2739,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>   {
>>        bool reject_file_backed = false;
>>        struct address_space *mapping;
>> -     bool check_secretmem = false;
>>        unsigned long mapping_flags;
>>
>>        /*
>> @@ -2751,14 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
> 
> Copying some lines the diff didn't contain:
> 
>          /*
>           * If we aren't pinning then no problematic write can occur. A long term
>           * pin is the most egregious case so this is the one we disallow.
>           */
>          if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
>              (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
> 
> If we're pinning, can we already return true here? IIUC this function
> is passed a folio that is file-backed, and the check if (!mapping) is
> just there to catch the case where the mapping got truncated.

I have to admit that I am not comfortable with removing this check, 
unless someone says it's certainly alright.

> 
> Or should we wait for the check where the mapping got truncated? If so,
> then maybe we can move this "are we pinning" check to after this check
> and remove the reject_file_backed variable?

I can indeed move the pinning check to the end to remove the variable. 
I'd do it in a separate patch.

> 
>          /*
>           * The mapping may have been truncated, in any case we cannot determine
>           * if this mapping is safe - fall back to slow path to determine how to
>           * proceed.
>           */
>          if (!mapping)
>                  return false;
> 
> 
>>                reject_file_backed = true;
>>
>>        /* We hold a folio reference, so we can safely access folio fields. */
>> -
>> -     /* secretmem folios are always order-0 folios. */
>> -     if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))
>> -             check_secretmem = true;
>> -
>> -     if (!reject_file_backed && !check_secretmem)
>> -             return true;
>> -
>>        if (WARN_ON_ONCE(folio_test_slab(folio)))
>>                return false;
>>
>> @@ -2800,7 +2791,7 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>         * At this point, we know the mapping is non-null and points to an
>>         * address_space object.
>>         */
>> -     if (check_secretmem && secretmem_mapping(mapping))
>> +     if (secretmem_mapping(mapping))
>>                return false;
>>        /* The only remaining allowed file system is shmem. */
>>        return !reject_file_backed || shmem_mapping(mapping);
>> --
>> 2.50.1


