Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DAC03F459F5
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:26:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 503936B0088; Fri, 10 Apr 2026 11:26:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DAD66B008A; Fri, 10 Apr 2026 11:26:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C9866B00BD; Fri, 10 Apr 2026 11:26:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2FAE26B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:26:38 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 07AF0C17C2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:26:38 +0000 (UTC)
X-FDA: 84643023276.14.0D0D749
Received: from iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com [44.210.169.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id C77C920014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:26:35 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iMJHn9gg;
	spf=pass (imf13.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 44.210.169.44 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834795; a=rsa-sha256;
	cv=none;
	b=dcscG3YTDaiUBjLMHO1Ipluwfy7rH5vdkomCqkLryeaPaqK1PI8GB9bnYCCAJDih7S16FA
	KSsZvE2Y6RYKTKD5yKPkcVaYxqUCk2LOOMdRzpTfk821rbkmycAFecbAIXPNXo0PNqPecb
	2WRi/deCRrTZPSviWMrOXKk7HtDhEZ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834795;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VmQVOaKe4OHBy7s0WhO7CpJe9iNWFuij3fj2r7HhWw8=;
	b=oW6EEboqU7uSEdI29TVCfnBKxX/WC2Z6Tpwpc5WUSnH6mVX/zOElL/4kErOvVsM4h41bOE
	MFL63fkT2Mq8ayj69R5NQsRW1O6SReEnOHdF0gW980Q+Z9S7wCPUkOGM4Fd70Ma6vJeuw0
	yZ5VV9ov04G8OR/CYFkf8o65QgvBVNo=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iMJHn9gg;
	spf=pass (imf13.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 44.210.169.44 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834795; x=1807370795;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=VmQVOaKe4OHBy7s0WhO7CpJe9iNWFuij3fj2r7HhWw8=;
  b=iMJHn9ggD7ZtBczd9l/oS3GUUPxQJpq0ftfMgmomY93YUPtGwITlluAI
   IpRkjjhvN9lP/fNKU4EsX+6yta8BDCP+JiLjXzjkIoKmKH3htwwS4YZTj
   imIWnUKtk//hkVF9BuBooG0fGNKfyqqfH10kOPHt71cQ6+Y4IDv/BgkZP
   9Ss6brf+kdPnBrO1SqFoBpJWDtidaYa1B8ML8xsPxw9PpPFPrL64s+Dz6
   +jQzN0CgkltBjVb1iYXAz8k4bJ8w3w8C4XAZQ+HqPwNiWtk94kTw4JcO8
   Nc8sFNwoRq7tUSIXFw3h0HPrr/iBsF+UmDODJ5UE2PCDBi3HD0i4Zbefu
   w==;
X-CSE-ConnectionGUID: K//6lZflQx6l49/Ly7Z2sw==
X-CSE-MsgGUID: Slw79NhtR2Ssxb4gST/A0A==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15420052"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:26:35 +0000
Received: from EX19MTAUEB001.ant.amazon.com [72.21.198.67:20384]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.29.254:2525] with esmtp (Farcaster)
 id ad4b6a99-5cf6-4fde-8f55-cfde01d49a91; Fri, 10 Apr 2026 15:26:34 +0000 (UTC)
X-Farcaster-Flow-ID: ad4b6a99-5cf6-4fde-8f55-cfde01d49a91
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:26:34 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:26:22 +0000
Message-ID: <c881f3c8-67d6-41b2-a3c4-498f1df40368@amazon.com>
Date: Fri, 10 Apr 2026 16:26:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 03/16] mm/secretmem: make use of folio_{zap,
 restore}_direct_map
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
 <20260317141031.514-4-kalyazin@amazon.com>
 <187fa189-b6d7-4ba0-98a4-7a525cbaf4f9@kernel.org>
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
In-Reply-To: <187fa189-b6d7-4ba0-98a4-7a525cbaf4f9@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D004EUA002.ant.amazon.com (10.252.50.81) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C77C920014
X-Stat-Signature: pw1w9b6h99qwamjkszcsdgdbh14hdpzj
X-HE-Tag: 1775834795-407987
X-HE-Meta: U2FsdGVkX19hbiMQXakMC6gfDcZaI8HemfUehmr5YuIaUzU1q7GlvpYtz45eFv6c5bjDzIRMSTXT2RcTtC7armPmATqiLAQG3Uz0oKsJ8vuMPmBF5DU182UKmumsIv8VkvKW4lRqZ6uWkknp51BUodTFl2tj7gfRfW0wrIhUVJZ1gjun47tIRB36yb/Y3PgU5i+myJAKxvN8B9+Tj97Wq/tQcrUPtH8wvpSrovgT7gnifrPyC8H0bbLLaKFGFmyaW+Epy2X0aGgb7ml2h8d9BkcULIFhLRtwAnN0cNkG80A2UVCao7zwC5UCC/tkAo26r7AqGIHT+naTkbQXqCb29hoValHRo1EXa5CWB3y1K1fAXoF7hru3VvmIIFpqVlVN/kNwEGLE5du2Uh444sKLuN4VKLqSZ5LOZjPWEKaC3yiDAGwqPglO3tT3iWLrQ6gTF/hlC3FktWSRG3YE2MUgnOhEEVrsaAcY6RTzyuZl6NAONtl4drhvYPy/L2CpBrEv2RtsiqtLApcPfgxFnmgE9uNZgboyXmEaqNLwqIFRYW12Gn6HJoUWfe0xcR/t3pRelrrKxYNq/GUtV5pke06Co+8h/xxsPAMsjADkA8tt9xk67WA7jpXlv45LQEXbxpbnzXlEAGroV6ssNrZT2CNQwHb1IbHnZd41ZcW2+EqNF+hHLSgr5Mjz8tkf9RY1XiweyqZhfvPg0KPKg9YPUimXqyFybfp0mEZx7hPU33mtk4XRVxQWITZwKIPxy5NKTmwJC9V+hMlcwWg3SJdvbB+2QHkS701E0tbzr8MQT/T0/TO2jPgMDRzPZoxuM/hcgiYv/uWyt2TOI8OmKfqxwEI5v5OPMxIye1tae5XpA3apDgZzG6QneeaG8tSdo0ZjnUQfcppPMzI5X+tj6iAKCdMOQRMpqiNHoCISFD/sO4aJugJz4KyDwsu3/zLWRL2wvyegeRhDtv1GuMOANWZ/hOY
 zr0khpNk
 vAneASHfPSEvhBupCIdC6qUfZRO7uyNflsq/PlbZVbapdZuzdmNLsNsj0Z9iREyDugX3yEwJZF+TeYpF2/wbpS9s4YbLYj0EeQVQ2sRkC93vYfWxO+iJSNmHDFEM180esEAS28yUm/C+cPF+LPyTtKOJjxZS3Z3QwiLCiZh2ovH39BKlN1JmnX2j8YJ14LSgwEWY8H92yTwKAerLRl14XweUkfS1kBALCBHP9JZgT55IXWrGEHX5bizswl4T4zEZufltM43Ayf9DCdm8/uikPrC2eMP9mrcoT4WlpLhqfkluVFNczc8w05iMV1Wx7OmXMQA+43tG+ixQk8PQ12u/zMYXNW2iOo+6AbNylfrHGm63+kkDnNXv5PUedGpzT0ulFKpPit/grYO1o8xsFmF8DpjTAo2O1lYtzBfjzkoQ2V6jGMTtO9I9rFMUW4rRTs3wbX8sBGuNkjupsBN++q4m9wFSdOmfFt13DweQoJ1WSLLa+/EFPlnfWrrILRiqJOX+h384bdZDcXSd+FBc30mmLGg7BKkdvEc/fpm7ezMEJqFOEWidI0EfO5ldxUB9MmjNLdQ+xUVzeZUDxgTkptfzmXGyu9vOyVm2QVqw5uLOXoA5VXXvXnwQVQiVqClo6n0Setmj0SqKKjAoUlo4yTiJWAQcJXIcuNnB6tLHO5Ts3ca+gKhS+x1rFALSqbl9NiOKZHKww9z33dRjXpuo27wSfNN/vJ8vQhOqYsCWWYmu6ShDMlo/RPtCboUFQUzLrjaDHJ2QtkbDDtOX0fbY/ae58i4bXPbzYhy3RGH+DfpSdtKp+VU8QuKVpdH2UpIYP3y6NqdP2akGi7v11pY4avbW6JHC2TFDFrsjmZlrBdG7S+G0DjFTwsUknRfZEvGkXF00/+xy11BllCoqiKxV9Opt57sw39qMFlYMBnOX1oIc2Mt2iKaz5saX58zbGTDkVy9aLlMkBKbSXgdXaDDaJfKmH3QhTVC4o
 6qtVp3H+
 E0/0oGRSb+G5LLCheHCTE13Km96wnyXbls2GTagM5fQ3JYwgMeFRc788OIABjTqCQSkj87gd/vmpYTd7eN82IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 17:53, David Hildenbrand (Arm) wrote:
> On 3/17/26 15:11, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
> 
> Describe your change :)
> 
> Ans also worth mentioning that we now flush the TLB even though
> filemap_add_folio() failed -- which shouldn't matter in practice I guess.
> 
> With that
> 
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Done, thanks.

> 
> --
> Cheers,
> 
> David


