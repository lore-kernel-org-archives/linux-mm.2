Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFE39D19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:47:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25C1F6B0089; Mon, 26 Jan 2026 11:47:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 213826B008A; Mon, 26 Jan 2026 11:47:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 112A46B008C; Mon, 26 Jan 2026 11:47:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F05486B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:47:09 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 900825B458
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:09 +0000 (UTC)
X-FDA: 84374694978.11.F524452
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf08.hostedemail.com (Postfix) with ESMTP id EAB95160010
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:06 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=TYvW9CRq;
	spf=pass (imf08.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=tbv/MTwQoTKHu7Ejd3vLaiU5iszGht/IvO/yWSvhW4o=;
	b=A85IqlsxTSieKB6Qdv4JnHuhvK+hjGx2pZi53W26jytPxATMtpLPamcdZi3nsnvuaZOZUA
	xxVjrPNAKxZlwFi6ohNUESCefUWztS1/6SjHeG4EOzgMJRuMIQRZJX3CTDseosFs1bPQNM
	FUh6mfxjsLsmqTiE3wjoEZrViCtXFNc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=TYvW9CRq;
	spf=pass (imf08.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446027; a=rsa-sha256;
	cv=none;
	b=AldCDNN4Yy6C+5pYs3QdZkaXCZZ8MrjCH12v+T83U9UXUDY6bOvMZGqRw6uJz3hdmECBKM
	buzpwci539AXLcxixvQXCZvnwO1aTyXAzi5MoR7nH5I2U67eJBDJKqBwIsTUL0VYgMni4y
	6KRMEJoOCIunmAiwzgxOcUPkblF0H2k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446027; x=1800982027;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=tbv/MTwQoTKHu7Ejd3vLaiU5iszGht/IvO/yWSvhW4o=;
  b=TYvW9CRq47mruQooiH58gXIcBiiYEJxKMRoPjnvc3KEaDOE4agD/QJxA
   w5ilf3LNw927GEBmxt2rQZcuzBHW/V1E7o55EPzyvVVk1qBbvy72hmZoa
   h54I06qdRQkhRzXON8E2oj3MWIKzDi7urtqcj2jkeNbnmxFsStdL+jKl6
   O2J+E21KwBILBqqmACkxN4EnoTe5WB3mRM16q61ueGAttZ9QLP/BVEsOi
   d5cHgj5j6L68AcXIMJ57K1miu4+vGAVZ9QAGWMw0RH25SJPg/K+fbCLff
   3u2YUdGG55Vto0HHzi810PpMtn+A7vLYWuu05G3tjMydJE8rMXITn+IOp
   Q==;
X-CSE-ConnectionGUID: 6IHftKH7SsOlKU7AyD1EnA==
X-CSE-MsgGUID: kMm4jjHORlWTkE3xuKVThA==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8361622"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:46:49 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:30081]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.13.191:2525] with esmtp (Farcaster)
 id 867ddae6-4aab-4228-9189-c90a4ffe3bcf; Mon, 26 Jan 2026 16:46:48 +0000 (UTC)
X-Farcaster-Flow-ID: 867ddae6-4aab-4228-9189-c90a4ffe3bcf
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:46:48 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:46:48 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:46:48 +0000
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
	<loongarch@lists.linux.dev>
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
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@suse.cz"
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
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v10 00/15] Direct Map Removal Support for guest_memfd
Thread-Topic: [PATCH v10 00/15] Direct Map Removal Support for guest_memfd
Thread-Index: AQHcjuMVKu9EzWzx90GD17TC625r+Q==
Date: Mon, 26 Jan 2026 16:46:47 +0000
Message-ID: <20260126164445.11867-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EAB95160010
X-Stat-Signature: yz19to1dqmswr91d9n99rjana6zjzfs9
X-Rspam-User: 
X-HE-Tag: 1769446026-544143
X-HE-Meta: U2FsdGVkX18U5fRXIuBYMjCFFuFlOTH9U0ZYz5RT2ffpq+sDrU6eAb47KWDjH2iUwxlKogejgHVpufbYc6JNWUYKssBiMbcaf+c4FjaCd0Sc96zg1Da6Nt1DjAuC9fv35eoiIauTJyWFdE3dG22OAxx/trje3gxXSAD/hthjuM66KlJ0JVQF0X3OALm7kehfKzJRkOQHca5FnAzTyajQfNpIxzxvY68D+yF1Wci2Hf3NZ0jwEyZVS19Q/8tuEUveRV29Bh3fuVz6rNum+UwATacHGHYE5KFkJsLm151Z/rgMkHdoc+tQNVJM9zV25+pf3HU06oSKvVdu71Tgg1uRbSjJ/7+NZCPfmUYB//7onNj7+/kIbDv/8FGJMeYuSrBgc0ROhl8+0b1XCTaVD1FqDkWPRcb5JAueBBmynLaOyym8g+eopD96UMbz23S4hEO5D3r4tqlwclLHbBj1oEMu0DFO7NCx4Infq/lgF264QsqueFePnSH+b4tjrrJezzEWo1iK5mGYh2LTlaXcJtkehoBdzkXbMDgIplkcyrUC+TzQWcW5GQluRnoOtdvgbHmgOXHbwhn5fqADyriLx9i0EYfd9CwSe+tsOjtH2IKgvEvRZuwkmMQb3+7SK1hDpn1qTIMw9f6wVNPGQDBLTobe+B7Ecv47WZWKc/FdESmPIyYKiKcTIgljGReE43e7IaC/rOOml9o1wjjjQXoQCsLbQX8/FpQazP6hl0AicqrJfIY1D3iOHOwAW/Fj+19E4GMuqyJAGfJBlidoMpWFvyPxucfZ2gb5wVCuCSqPkjdF7PZ+YUOcgA1HmHMb4Pp/FbiqlewAwS9lJ+jQfJj7/V5HcwI9S4D+l0W0X4MPqm9czHkHsZYJck7FWT3V54vNH91VS/R3N7eXYEwn+QgDrvZnexEqLUx2TdOzqO6NgFYeUM6OvO/Qqv7oFmen5eTsT6trFPVd7Ro0zPurTHrFQ4Z
 w7RXsH7o
 ewCG14uvOU3fIw1wIQwo2l4pMYLMn5Eei4+JrreEISVRUKtJfRxQl/ClUCVw7H7VX/bi1Kw43WY/F35b/9akV+mBFM80+X5exYP4qiJbATpyixCCMyBN2YbAt/sp5KwK6/lIQqUVbbdBUqaqR2ly0n4hG8gyUk820ZRKsrdtmtWNXLQDQWVGkJEehp65W35A1CZhjtp/OdnD9UT/DdI28muDDw4cLt9lI9m69XZ5KdzTAiM8wL2ePAz4MVHrcQlBHGjpXt4l0yHWonybHNAib/0mEtjSk9KJMhmYryPuylVFH9lofRPkJoBAGNW+wS4LGtUn8ifnPmAnMCpm0VOdw9BkeOXCRKljewANlisc2BX7STVc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Changes since v9:=0A=
 - Huacai/Ackerley: formatting and error handling fixes=0A=
 - Heiko: remove TLB flushing from folio_zap_direct_map() on s390=0A=
 - Willy: set_direct_map_valid_noflush() to take const void * instead of=0A=
   struct page *page=0A=
 - Ackerley: remove reject_file_backed variable in=0A=
   gup_fast_folio_allowed()=0A=
 - Ackerley: avoid referencing memfd_secret in doc=0A=
 - Ackerley: make calls to kvm_gmem_folio_zap_direct_map() conditional=0A=
   to GUEST_MEMFD_FLAG_NO_DIRECT_MAP=0A=
 - Rick: Exclude TDX from direct map removal=0A=
 - Rick: Add a comment about current impossibility of zapping at=0A=
   non-base page granularity.=0A=
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
Nikita Kalyazin (3):=0A=
  set_memory: set_direct_map_* to take address=0A=
  set_memory: add folio_{zap,restore}_direct_map helpers=0A=
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
 Documentation/virt/kvm/api.rst                | 21 +++--=0A=
 arch/arm64/include/asm/kvm_host.h             | 13 +++=0A=
 arch/arm64/include/asm/set_memory.h           |  9 +-=0A=
 arch/arm64/mm/pageattr.c                      | 31 ++++---=0A=
 arch/loongarch/include/asm/set_memory.h       |  9 +-=0A=
 arch/loongarch/mm/pageattr.c                  | 37 +++++---=0A=
 arch/riscv/include/asm/set_memory.h           |  9 +-=0A=
 arch/riscv/mm/pageattr.c                      | 29 +++++--=0A=
 arch/s390/include/asm/set_memory.h            |  9 +-=0A=
 arch/s390/mm/pageattr.c                       | 25 ++++--=0A=
 arch/x86/include/asm/kvm_host.h               |  6 ++=0A=
 arch/x86/include/asm/set_memory.h             |  9 +-=0A=
 arch/x86/kvm/x86.c                            |  5 ++=0A=
 arch/x86/mm/pat/set_memory.c                  | 43 +++++++---=0A=
 include/linux/kvm_host.h                      | 14 ++++=0A=
 include/linux/pagemap.h                       | 16 ++++=0A=
 include/linux/secretmem.h                     | 18 ----=0A=
 include/linux/set_memory.h                    | 19 ++++-=0A=
 include/uapi/linux/kvm.h                      |  1 +=0A=
 kernel/power/snapshot.c                       |  4 +-=0A=
 lib/buildid.c                                 |  4 +-=0A=
 mm/execmem.c                                  |  6 +-=0A=
 mm/gup.c                                      | 37 +++-----=0A=
 mm/mlock.c                                    |  2 +-=0A=
 mm/secretmem.c                                | 14 ++--=0A=
 mm/vmalloc.c                                  | 11 ++-=0A=
 .../testing/selftests/kvm/guest_memfd_test.c  | 17 +++-=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 37 ++++++--=0A=
 .../testing/selftests/kvm/include/test_util.h |  8 ++=0A=
 tools/testing/selftests/kvm/lib/elf.c         |  8 +-=0A=
 tools/testing/selftests/kvm/lib/io.c          | 23 +++++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 59 +++++++------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 ++=0A=
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +=0A=
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +=0A=
 .../selftests/kvm/set_memory_region_test.c    | 52 +++++++++++-=0A=
 .../kvm/x86/private_mem_conversions_test.c    |  7 +-=0A=
 virt/kvm/guest_memfd.c                        | 84 +++++++++++++++++--=0A=
 38 files changed, 511 insertions(+), 195 deletions(-)=0A=
=0A=
=0A=
base-commit: 0499add8efd72456514c6218c062911ccc922a99=0A=
-- =0A=
2.50.1=0A=
=0A=

