Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EE43F459E9
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 961EB6B0088; Fri, 10 Apr 2026 11:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB4C6B008A; Fri, 10 Apr 2026 11:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B32C6B0092; Fri, 10 Apr 2026 11:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 671EF6B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:17:55 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 026D31B7452
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:17:54 +0000 (UTC)
X-FDA: 84643001310.12.06E14BB
Received: from iad-out-006.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-006.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.216.221.67])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9814820003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:17:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=oMuIXT6U;
	spf=pass (imf03.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.216.221.67 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834272; a=rsa-sha256;
	cv=none;
	b=A2QeEERFQMv5szrVuLnhXyaanki+390ZPRFF21Cz5qnF8aSSSEBh16N2jZyebzY2Z+cmxk
	qvleceT9CSyfON0jiP0VHhpRIhBpY7Wa+/POKqi1m1FnPoijouQGCIL1it4keKlrlq/sXV
	chzru8tRD+xi2XeFpXajJiSVJ8qwMnc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=8HieUWXwfTPL/TX57Qxi0290udRDGerg8ZVRI0leHrg=;
	b=dGmV47OICCeG59gle4dsKHRErqnYldC2I/IW9kRtoKC5id9e8TywtV+06hNbjVRsc0hYj6
	XlTy6j1Kt0h4zU9ae4THV0HjosBlGrNi/95WwM40sA02X9aLA8oz86l6ZJthIC/9Y2wYhD
	Cf6GVXpz4YABnLj+grB8Tt1zXMwi2AQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=oMuIXT6U;
	spf=pass (imf03.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.216.221.67 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834272; x=1807370272;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=8HieUWXwfTPL/TX57Qxi0290udRDGerg8ZVRI0leHrg=;
  b=oMuIXT6U56jtq0e3lKmkKGYC46q8rgARUirjVZXHYz5JYQohFqcdxTph
   Xk4Sgo0hsqQALeNysBXffebAgeHW7qSHSDeqUeyogrwpP3Z1SAUoYpGv2
   COEr9rTJ/kMPto6jOsCDZRz2DoDVaajJLYJHzaYiaS6NdxHqI+/t0ImGN
   gRSczOqou9066hSvdg3tJxIPkihAt6/LGvZ0XU5iydPI/svFJQME3hOaI
   rvrsNyUlEJFkiGfHWa4aA/E2WfehD6FgrA6kuyaFslLArEHMbpABY/tHS
   w3EMji2hC/W9RnKoXNjT+bflClxRzCPZGkZe4CTSJlJbc8iamq+GYLUzq
   w==;
X-CSE-ConnectionGUID: 3b8vreyoQF+JHxAkoMc12w==
X-CSE-MsgGUID: 7nws4pUrSTqpAuILmVnHgQ==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15982000"
Received: from ip-10-4-13-79.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.13.79])
  by internal-iad-out-006.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:17:48 +0000
Received: from EX19MTAUEB001.ant.amazon.com [72.21.198.67:20021]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.29.254:2525] with esmtp (Farcaster)
 id cbca5809-ea98-4c81-9ff3-7d14d4c26b47; Fri, 10 Apr 2026 15:17:48 +0000 (UTC)
X-Farcaster-Flow-ID: cbca5809-ea98-4c81-9ff3-7d14d4c26b47
Received: from EX19D027UEC001.ant.amazon.com (10.252.137.156) by
 EX19MTAUEB001.ant.amazon.com (10.252.135.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:17:48 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC001.ant.amazon.com (10.252.137.156) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:17:47 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:17:47 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
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
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
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
	<coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro"
	<itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>, Nikita Kalyazin <nikita.kalyazin@linux.dev>
Subject: [PATCH v12 00/16] Direct Map Removal Support for guest_memfd
Thread-Topic: [PATCH v12 00/16] Direct Map Removal Support for guest_memfd
Thread-Index: AQHcyP0wLRkmRDUt+U2dSCwqaTZUYg==
Date: Fri, 10 Apr 2026 15:17:47 +0000
Message-ID: <20260410151746.61150-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9814820003
X-Stat-Signature: 3qak7kyeuk8ecptmmhimpxr3nud5de87
X-HE-Tag: 1775834272-209132
X-HE-Meta: U2FsdGVkX18WUjI6mJ56mNYzex5CDHHXTSJPFNw6aVDePKVUv2TSpBMBFBp5c4ri8QuKfZCSBgzPksle09vsIsTJCpZEH79uhU8ua13kjjXHtognug/plsRT3v20Zw05h9A9sMmdeo149cU/GPw3Um1ts0xlsZkmV4lWZNsvYD+EBv/C2U90e8pjp3bqgHek7Ir3HRwTbk/OVj4j4u2CN3s4eYXoNCWqhqdvTCosqYDAXtblLJ37bsCz7T7NjoB5BWmwm3d46rGbGK++TRV3JtQkGVKNFM1OYtuuup7B/D9QQ5xCnA3qV86yAc146O8WyMHSHCvVvTP9mYvEFwnzkWJ1bNpFaNJQ5vXGtIAf0I2G6Fb57bD5uXQVyMlk0ZaO2TgHWtTYB28SrjvQ7aEa1GvViLjB4WtHC+6ThM3njCl6nPrL7UNz+rJS2zJuqJPY/IhsD+X4X6tpRnmeBDA4atgeB8YvzYt//bWUyRBbK7FGzM2/xNWU5kg06xsluYNmZiUZUwlldOOkmESTFmG2aYu8IMO9CUxlrzJ/NAgsA2Eq1Y4Vl9RDubOOa2hzkX02C4iXatpwz55ZgAfVefvHeCIisQI2zDkGgnq0KYUOZS5bDF48e/fY5/YS2WOfpiVDuSEpgMvlUiF5R1ph38TwbC4CT03JIcLckdYn7/muJmfWH+QBt/mU119ut5zfthb424WX8AdVJUIq1F/EUyR+DUvLvknVwlXESyNifGnhl00xeAGMTMUhLBH2hIq8bo1COmxK76VncBav2c27xITKBfSzLHtfJq6Vic7n+SYwaMkzZ5x+ZcYoVBcrJ4VNJc8dEBbtHcI/3Ix9Pau14/1MGA73GBudZauEwp8YNZm7jN9siphEG7OrOz81R5Y/xWktvSpN9+6MlUWUEqZgG8cYe8j0wOgOc/rbv70EvzN1vMGK6Sl/5r+czazCcJOJSC0C5Dm/xZ6nFsZRVCgq7HK
 96F8gJj0
 xr0+6N9wYVODSR0600hAJoeMhQG052DimsfFhdqZ5aESa3G8NhSgd+SHgFPgCOCKk+H17ZBmi4e6O8WM7tYvkAHCZXZ3pIKd7IX+ixx9dJOBRTneCEs49qXPYBTQR6HDQPK94m3jXvZyNztBc+fE+C6C10BEmOZHVA7EatJkStmrT4kEnWIhvVh2ZthKtUnj8p6FEfPvhgKfU55Y8EqcT1Y7D8ygTUEGDOtJHjVx3qOho0OWUlO/rtzFXDI4+KUz3UJkUNZbtelpugITssTilLzdmdA+R6lY9gJJlztdUsDFxQ18GaM5ZKu8ji9sw3esTS5I+wmp7zQzSowzdU2Fh1GrvyhzjyPkUbSWYhzlT1IaXlI6/wxzXBeHpXCoXkor6ToGp2aHgpx/CAtGfqcAu9bis1Zxf1E/IasWjl5JmCYdXOaVDIxiR004JYZh2vdBxiCen72BkYXVsLbo+NQ+d7lE+g3drY1afinMLjqJMY/liUaqRkqLYZ5MpYH7kOaZWSCkP5TmK+xcYSfOdF1ZWPFR5NDd+Fi5/e8mSSuaLZZdE3sj82RBwiXo/HP4YCNSapPmBSfKEUncwWkJl6s+wf5M5uU0rQhRrQ4eQHaRuYVF5sBLETbRM2xXydP2vj0cVcJOF6QtsqFNu9H61Cd41Qi0vrJ3R4ObgORHOVALvzRfs5LOxDBGpguLMWVurhmnSO1rKd2/V7uVT2AUMLZ1VTLT9G11UkgwNSJLrZWWzWBO6Lp1eGcqNJ7WINjqtXnHCjUhqUd7QQp6fBSyVV66mDJY9uwMZMoDJfkbuePKKB+fizOaW5dw1NkR1Wc8WVrnBNV0e2ZuTQrmW3WbMQDpwbU2AZ2rKaOFsEzW/VJu92OETy14JT3NMaVxCcPeXtYnTNrUzDxfVXZx4UADk/VNFhVgh8fPAu8W0R9/VSXuzKJvMuV8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
=0A=
[ based on kvm/next ]=0A=
=0A=
Unmapping virtual machine guest memory from the host kernel's direct map=0A=
is a successful mitigation against Spectre-style transient execution=0A=
issues: if the kernel page tables do not contain entries pointing to=0A=
guest memory, then any attempted speculative read through the direct map=0A=
will necessarily be blocked by the MMU before any observable=0A=
microarchitectural side-effects happen.  This means that Spectre-gadgets=0A=
and similar cannot be used to target virtual machine memory.  Roughly=0A=
60% of speculative execution issues fall into this category [1, Table=0A=
1].=0A=
=0A=
This patch series extends guest_memfd with the ability to remove its=0A=
memory from the host kernel's direct map, to be able to attain the above=0A=
protection for KVM guests running inside guest_memfd.=0A=
=0A=
Additionally, a Firecracker branch with support for these VMs can be=0A=
found on GitHub [2].=0A=
=0A=
For more details, please refer to the v5 cover letter.  No substantial=0A=
changes in design have taken place since.=0A=
=0A=
See also related write() syscall support in guest_memfd [3] where=0A=
the interoperation between the two features is described.=0A=
=0A=
Changes since v11:=0A=
 - Ackerley/Sashiko: fix previously missed __set_pages_* argument update=0A=
   in __kernel_map_pages (patch 1)=0A=
 - David: disallow large folios in folio_zap_direct_map (patch 2)=0A=
 - David/Sashiko: check for folio_is_zone_device if mapping is NULL in=0A=
   gup_fast_folio_allowed (patch 4)=0A=
 - Ackerley/Sashiko: kvm_arch_gmem_supports_no_direct_map to return=0A=
   false for SEV-SNP (patch 8).=0A=
 - David: replace a redundant check for GUEST_MEMFD_FLAG_NO_DIRECT_MAP=0A=
   with a WARN_ON_ONCE (patch 10)=0A=
 - David: assert the folio is locked when zapping direct map (patch 10)=0A=
 - Ackerley/Sashiko: reorder operations to "zap then prepare" and=0A=
   "invalidate then restore" (patch 10)=0A=
=0A=
v11: https://lore.kernel.org/kvm/20260317141031.514-1-kalyazin@amazon.com=
=0A=
v10: https://lore.kernel.org/kvm/20260126164445.11867-1-kalyazin@amazon.com=
=0A=
v9: https://lore.kernel.org/kvm/20260114134510.1835-1-kalyazin@amazon.com=
=0A=
v8: https://lore.kernel.org/kvm/20251205165743.9341-1-kalyazin@amazon.com=
=0A=
v7: https://lore.kernel.org/kvm/20250924151101.2225820-1-patrick.roy@campus=
.lmu.de=0A=
v6: https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk=
=0A=
v5: https://lore.kernel.org/kvm/20250828093902.2719-1-roypat@amazon.co.uk=
=0A=
v4: https://lore.kernel.org/kvm/20250221160728.1584559-1-roypat@amazon.co.u=
k=0A=
RFCv3: https://lore.kernel.org/kvm/20241030134912.515725-1-roypat@amazon.co=
.uk=0A=
RFCv2: https://lore.kernel.org/kvm/20240910163038.1298452-1-roypat@amazon.c=
o.uk=0A=
RFCv1: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.c=
o.uk=0A=
=0A=
[1] https://download.vusec.net/papers/quarantine_raid23.pdf=0A=
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-=
hiding=0A=
[3] https://lore.kernel.org/kvm/20251114151828.98165-1-kalyazin@amazon.com=
=0A=
=0A=
Nikita Kalyazin (4):=0A=
  set_memory: set_direct_map_* to take address=0A=
  set_memory: add folio_{zap,restore}_direct_map helpers=0A=
  mm/secretmem: make use of folio_{zap,restore}_direct_map=0A=
  mm/gup: drop local variable in gup_fast_folio_allowed=0A=
=0A=
Patrick Roy (12):=0A=
  mm/gup: drop secretmem optimization from gup_fast_folio_allowed=0A=
  mm: introduce AS_NO_DIRECT_MAP=0A=
  KVM: guest_memfd: Add stub for kvm_arch_gmem_invalidate=0A=
  KVM: x86: define kvm_arch_gmem_supports_no_direct_map()=0A=
  KVM: arm64: define kvm_arch_gmem_supports_no_direct_map()=0A=
  KVM: guest_memfd: Add flag to remove from direct map=0A=
  KVM: selftests: load elf via bounce buffer=0A=
  KVM: selftests: set KVM_MEM_GUEST_MEMFD in vm_mem_add() if guest_memfd=0A=
    !=3D -1=0A=
  KVM: selftests: Add guest_memfd based vm_mem_backing_src_types=0A=
  KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing=0A=
    selftests=0A=
  KVM: selftests: stuff vm_mem_backing_src_type into vm_shape=0A=
  KVM: selftests: Test guest execution from direct map removed gmem=0A=
=0A=
 Documentation/virt/kvm/api.rst                | 21 +++---=0A=
 arch/arm64/include/asm/kvm_host.h             | 13 ++++=0A=
 arch/arm64/include/asm/set_memory.h           |  7 +-=0A=
 arch/arm64/mm/pageattr.c                      | 19 +++--=0A=
 arch/loongarch/include/asm/set_memory.h       |  7 +-=0A=
 arch/loongarch/mm/pageattr.c                  | 25 +++----=0A=
 arch/riscv/include/asm/set_memory.h           |  7 +-=0A=
 arch/riscv/mm/pageattr.c                      | 17 +++--=0A=
 arch/s390/include/asm/set_memory.h            |  7 +-=0A=
 arch/s390/mm/pageattr.c                       | 13 ++--=0A=
 arch/x86/include/asm/kvm_host.h               |  6 ++=0A=
 arch/x86/include/asm/set_memory.h             |  7 +-=0A=
 arch/x86/kvm/x86.c                            |  7 ++=0A=
 arch/x86/mm/pat/set_memory.c                  | 27 +++----=0A=
 include/linux/kvm_host.h                      | 14 ++++=0A=
 include/linux/pagemap.h                       | 16 ++++=0A=
 include/linux/secretmem.h                     | 18 -----=0A=
 include/linux/set_memory.h                    | 22 +++++-=0A=
 include/uapi/linux/kvm.h                      |  1 +=0A=
 kernel/power/snapshot.c                       |  4 +-=0A=
 lib/buildid.c                                 |  8 +-=0A=
 mm/execmem.c                                  |  6 +-=0A=
 mm/gup.c                                      | 47 ++++++------=0A=
 mm/memory.c                                   | 45 +++++++++++=0A=
 mm/mlock.c                                    |  2 +-=0A=
 mm/secretmem.c                                | 18 ++---=0A=
 mm/vmalloc.c                                  | 11 ++-=0A=
 .../testing/selftests/kvm/guest_memfd_test.c  | 17 ++++-=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 37 ++++++---=0A=
 .../testing/selftests/kvm/include/test_util.h |  8 ++=0A=
 tools/testing/selftests/kvm/lib/elf.c         |  8 +-=0A=
 tools/testing/selftests/kvm/lib/io.c          | 23 ++++++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 59 ++++++++-------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 ++=0A=
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +=0A=
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +=0A=
 .../selftests/kvm/set_memory_region_test.c    | 52 ++++++++++++-=0A=
 .../kvm/x86/private_mem_conversions_test.c    |  7 +-=0A=
 virt/kvm/guest_memfd.c                        | 75 +++++++++++++++++--=0A=
 39 files changed, 489 insertions(+), 202 deletions(-)=0A=
=0A=
=0A=
base-commit: 24f9515de8778410e4b84c85b196c9850d2c1e18=0A=
-- =0A=
2.50.1=0A=
=0A=

