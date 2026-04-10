Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1BC6AF459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:24:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 611806B00B8; Fri, 10 Apr 2026 11:24:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C29C6B00BA; Fri, 10 Apr 2026 11:24:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48A3E6B00BB; Fri, 10 Apr 2026 11:24:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 370BC6B00B8
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:24:51 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DF0481A0153
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:24:50 +0000 (UTC)
X-FDA: 84643018740.27.EE60EF6
Received: from iad-out-014.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-014.esa.us-east-1.outbound.mail-perimeter.amazon.com [50.16.246.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5E5941C0012
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:24:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=NYCUeKkd;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 50.16.246.183 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834688;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wZc+sAyXLDOw4SNn2V1QCxBFXc6EIQ5hl84+ynFDeD4=;
	b=H5wCHeLkkmTMnblcPOXnkF2JWNGe3PO/oBQ/UIy3jWUbMx3nKojl1UdGknD3eFvOAHpgHf
	814M/iDC+c0EF2JDFrqX30+ruCBFpxsQqhyL3mMDs0e9Yq61wznCk9rBoBQ5o9iGeEiP7k
	SHTTMmNcKUziPrspHlCD8UXeqX9rekw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834688; a=rsa-sha256;
	cv=none;
	b=hbAugpY5Y0U5qb8HLCTYDQzuFvg0y7jQYf7C6/T+gZ00i125szTe5eft1RmizUvUYDhULM
	VmCVXgM40tIvyvVD3v1VC1D8thVF/2fMPRZN8PEsLq/o+3mHyf8Ol3/0I74H4EUS4IuuMa
	SH/cb7sb5VYX/RUYMFN7TLFVNTrxqws=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=NYCUeKkd;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf20.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 50.16.246.183 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1775834688; x=1807370688;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=wZc+sAyXLDOw4SNn2V1QCxBFXc6EIQ5hl84+ynFDeD4=;
  b=NYCUeKkdn6hO45hvQMbf4h2atm8eNmq3K8CQF/acazOWh3xbmIDZijqm
   iq6oan7J4xm1N8Jvn0ZqCjk6xYeKdplxs5zjzNDYnziGVfXOrN1kEd+wm
   va5h1H+2Ph93Dpdwt54kQgsDxKWchyzk2IXmM1HoKF5TjdH/MwHN4hZBj
   kLH3P2OBaGP/mQMhUXPvvB4Hw2lQzB0SxSs7u/alrpa3H+N6JQYV1vucQ
   XCEXY0YcITTLer/2HckPk8b97Bl8mf3YNSaZ28XGYDtOjTs/sJ35Jaj1Z
   NUzWFDjVAiMJczDsXhZvQpZ8eF+aV3DbN10qznlqyt2GpV29FQCNn4o0t
   g==;
X-CSE-ConnectionGUID: X+8/8Q82QPSEUaO2zzwCGA==
X-CSE-MsgGUID: 20SnI1ONQjO+nFdv/IJbAA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15428079"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-014.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:24:47 +0000
Received: from EX19MTAUEA001.ant.amazon.com [72.21.196.67:6584]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.62.178:2525] with esmtp (Farcaster)
 id 7efac024-2436-4ad4-8a7e-9b389eaca327; Fri, 10 Apr 2026 15:24:47 +0000 (UTC)
X-Farcaster-Flow-ID: 7efac024-2436-4ad4-8a7e-9b389eaca327
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:24:46 +0000
Received: from [192.168.12.97] (10.106.82.30) by EX19D027UEC003.ant.amazon.com
 (10.252.137.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 10 Apr 2026
 15:24:33 +0000
Message-ID: <e725b3aa-f67e-4de6-acfc-788f264616c0@amazon.com>
Date: Fri, 10 Apr 2026 16:24:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v11 01/16] set_memory: set_direct_map_* to take address
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
 <20260317141031.514-2-kalyazin@amazon.com>
 <7b785e34-4d49-48d2-b438-afa1def3ec0f@kernel.org>
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
In-Reply-To: <7b785e34-4d49-48d2-b438-afa1def3ec0f@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.30]
X-ClientProxiedBy: EX19D004EUA002.ant.amazon.com (10.252.50.81) To
 EX19D027UEC003.ant.amazon.com (10.252.137.250)
X-Rspamd-Queue-Id: 5E5941C0012
X-Stat-Signature: eyuw6h8yr1pxhdhzz7zx6d6n9jeyqsq4
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775834688-346961
X-HE-Meta: U2FsdGVkX1/+dbIlGls8l6ZOsvNtrp22w8ehc3YggFTJE3nzflTxQ+mniCzadWc+51K0juymLwBmBn0TkTL1b5/B9PieOeL9bUh790wEA8rKvTfRJgf/AEVoe1WkM7SU9PKVLPjdEXlGn2iN2wu6M8c/IiV4Z36HYnibVvwpzYVvLrdpLVqB3oGL6SqhkOT3J8lAt5Ipjc+Hec2mnKNoOevsQAf6cVZ9dGdle5FXQcu5kKnK/gjFm53q05gHRQjsmQSSg5NoBOV49ziKIzBqQimc58UNpdGu2fBLLpaimeXk1XlZdedLV0XtksEQriRXruNBw6xDQP1HSOd8p3j/AleOMwKVSjXAXYM1pFLptl3WEqEMefLXGo3dThm/4V9TX1PiBtVirLoDrC3fYb9BrUfxe2lq/Dj1183qvfM9JzWjFt62rPvIAK5mA9IAjsMfaXveKGD5aD8VuyufTMZS35fU4t5lZk0wd6dOQUUfSvoAsJDGagxKJCMTfHsW+Jq9fHZSWJOfGbqTD1RBLUBs2ZW6md1bI6RInI+VJxXYQMQ28gKv072egDW5pJMs7CbYvxX30WRsCefKRuYLNPIZdAMTqHSLiKJ5MvNB3WiYFAb7Pg25GL8RDLk635u1uIflE7b2MkKINxC5QzzI/LQHY3/iwY+/90fmED1c/XD/MXVhnSNdW92f3TscHWmKQnvZMdZ7ZYOYGwmLWuPpzyV/TK9GIr/PrPiqT1D4hbmBQOFUzYcsWZ1SJlWuX0vKXHfXMnTC6VWPfNT1T0euvvYHQUq9ezAJkCcFHyDhiTifcEm1kpcOt2fQ7/z7272etRIWxcgYQmJTYI0KM0PeVsrOGx4Tag9Z3Ra0HscVEXSdN53x3V+aC7jEr1A1P70OrjfOPwH/IwmrNhFTGKOdsyx0XreUDDNyoUQMUwh7+EgwgJ0FbpNdaYEX/JhgL+Mj2KsSzfFLiTvOvtcjd5LoMDB
 B/YWEObo
 sOfvQ/Uq/O0LTlMbKJoYzETH2kQxocKp31ZZSacH7fOZiY9FVdcpkzT25+GzC1KBZHQsSCJvc0U8L457NYLTYGn2LSktomyUGmuqfQo+TO0vqZzdJrLOxCX3IDT3kTLTo+jTO9MWldSVk0Cgnu/Blfve+Le5KcL7POU6onEd4B5VgkTqqCUG1pipLydvXAahThu5ejiKk89v/qPARztcFNEiPWKJxhMnNngK0k/IBXef1vIkS6ykkD15r+Gl3hoaQrXzr30xvrJi8T26zIglj43ZD7GP0/pCgZjb9M78Cn4XgE0M8MMcAl/8E3UTsHyBQ+qz5PO2DkrVdvfoLwyzf2Lrz934J8sBlvSuX0+JmC4Y1KOzHOjuwneuwijx53upQy/gJ+zoNPy6GqIMaWwTKIMHFRd+v18nv2aUiZLK6AsNlmtzU1kvp9Is2TYyOqx93x2sbQzdSy6PVPrauBL1HZUXzybw1sDsHxroSmDJVNl3XhJOrF8eKStjn2EGAkZsyxfsfvzaOItix2YsCagQv3GVKBK/yFN3b6Dwr0f7wkGbTwV7Z22qKDKL2lAjQ+loNWPEMvh4eG4169G+4U+R5K6Ua8dAOiAf2cH402BQzbGiwwh1URd/uSqPHsAlBOBBzZ5n9TulPKjgMXG0z3FyyUhxcxoMw2A/jHrf9DDAMFJpIqiZh6oGMeFJPJmEAVCcmv5YYuxaqC3V+ZZCDTxqOSOWrKPpi1kvlFyyXk3c6BCQzth/MMhk8eEW8DwkFrp0ah1KhHGCooohOqA/z+8vJdHEEMDvZg1J/O874v/mHZAM02Vp2LPtmgPsSrQDmT4aqMpDCegioWNPkOO7DnelxM+DacQFRc5cpEWACGFmR6yU24xpOhuwIj0x8/drkmUyu6IdOxiPfvaifGpK/sn0CMDExxTOFsZXsfx/YKgdp6JA2Ilw0U6cRdWypz2S6Pg1HkwC8fEB/2un3MBCMWPvWR9APLwN5
 TSWuhYPS
 0Nc5Ay+xIz+N7ZUUQOYoPzD9gy+tQ/6O2bqFVKO/4TT0SYw8y5xGnnJn+CtE1i0AAaXeqWc0jEzW2Qcy197d4QFcBEbdfaC0XkhM0VC2LI4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/03/2026 17:44, David Hildenbrand (Arm) wrote:
> On 3/17/26 15:10, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
> 
> Just a nit while reading over it once more: restate what the patch
> subject says.
> 
> Like "Let's convert set_direct_map_*() to take an address instead of a
> page to prepare for adding helpers that operate on folios; it will be
> more efficient to convert from a folio directly to an address without
> going through a page first."

Done, thanks.

> 
>> This is to avoid excessive conversions folio->page->address when adding
>> helpers on top of set_direct_map_valid_noflush() in the next patch.
>>
>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
> 
> --
> Cheers,
> 
> David


