Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4969CD37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:47:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEE5B6B00A7; Wed, 14 Jan 2026 08:47:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AADF96B00A8; Wed, 14 Jan 2026 08:47:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F606B00AA; Wed, 14 Jan 2026 08:47:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 828B76B00A7
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:47:00 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4842F140458
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:47:00 +0000 (UTC)
X-FDA: 84330695400.15.309155E
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf25.hostedemail.com (Postfix) with ESMTP id B90E3A0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:57 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=jbncyPwa;
	spf=pass (imf25.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0fkQSK/G4NqBdB6Hn9NRubMn6LJOB2ByURYL1BmaOQ=;
	b=hIYu1z2HX4sIxTU8mUmj6o3Hu0ZGBCZI5HlRMuDNveAVMwZfkKEzA9sGCHmvqWFPXxagQi
	7xdWj0udipVpiqnnzDEOrLmMetliHpCm+7k2252/p/vfSnJ6AzE4uRqy1z0eWjlo05x1WB
	l2gLq5Uowl1oJFb+pcHuaxTBqNthzKY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=jbncyPwa;
	spf=pass (imf25.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398418; a=rsa-sha256;
	cv=none;
	b=ayRQWSoPtp59kA66qU81XkqjQsmcU26gFAR1Yvq1M6PLQrkRM89NAWvteDIcn06wYYZUsY
	8qnJRfVUV4vMrciesDD/zZ/nxqm3HYeyecQOooJdy71YoBiaAjsd1WJc3leOvrCCc/SIke
	bLnNQwGi7ban81NuoNWlArNbxgC7B3M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398417; x=1799934417;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d0fkQSK/G4NqBdB6Hn9NRubMn6LJOB2ByURYL1BmaOQ=;
  b=jbncyPwaorlkAySLsYGne4+7HhnHaS4SuRrxueZc0eaWtQv84sIOpC2A
   uGHPqk3mtLO1wg/Nvqng01k7EHBQHPyTP9K+5MjeBr7IKJfz5Y3Uc6l5H
   SSIuSrTYdCpgEdilp1Oq3AGAJlUYvniDX1Waf6xb4fJtXb5xikjTFd9Ex
   RLmK/01Lv0Qcdi3Vb4BgdocFXgeoP/ZwrG8j6r0tuDMeIKjoc4dPk1KWS
   uCXXm7uyIXRv/k0xdJHjK/VK8UQXseqy3Ta4eu7mpqlQBp98TWfxzU2k3
   jgkxmHlYG4fmkGwVS9O3izjIIWdlHy5B/XHLkyovXTORXXXQcjTC1W488
   Q==;
X-CSE-ConnectionGUID: JgyVqY3SR7ySuo8JPqnwCQ==
X-CSE-MsgGUID: HE+t2Mb0TXuEruP4xIdeCQ==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7586362"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:46:56 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:16845]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.41.192:2525] with esmtp (Farcaster)
 id 7164598a-7f5e-4449-9eed-86b5733e6ac2; Wed, 14 Jan 2026 13:46:55 +0000 (UTC)
X-Farcaster-Flow-ID: 7164598a-7f5e-4449-9eed-86b5733e6ac2
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:55 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:54 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:46:54 +0000
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
	<xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v9 09/13] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v9 09/13] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHchVw+5umpoZDHpUe6e+astZuDAw==
Date: Wed, 14 Jan 2026 13:46:54 +0000
Message-ID: <20260114134510.1835-10-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
In-Reply-To: <20260114134510.1835-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: ype6zx4nxme8q795suug5xedr9izzcdc
X-Rspamd-Queue-Id: B90E3A0005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768398417-451200
X-HE-Meta: U2FsdGVkX1+HMNnambSvBfVDmKx5hCeLatpUnChQJFvpUXoAV/6TM+QIkkko929nKY9XC5L7Ye8lcySNGmLrHTE+b48Ss8PTQ8Ms1C9Qyzuo/HH05hM5rBRwNv86Fps0MRIq/+sxMrCzxNkqJgCWA3fQ3i4RAZpXDo3c1TmFkSlCNiKG1EWzoJVMwrb+6aRo/EUKeJDgO1vUE1gK2q8FU/JOV63gycQt88IwJ2adOtPJa1qvrby3vAgD6U3e1G9htjqwwTb0TuN6Kqof1Od97LLEkRg/NUAQoMhUjFiTGZWGMtNG7+tGz4wEQhFtJO3GlUt+B8CVEWd8ETkmukSZRppQXLgwCVqm+/GZ6u8HtGBVUQFrGOtHBc2rOMC50+s43muLBfqE7MISmHYHS4L0N0+N8zaVF+XiVqDMScaPemfzVfbOvFexCyM6lAxyR95hEmUbaTU8WeH3YP3QbSR5AAFjFEgQWyBm8IpFegBOAo6hsDrUcysBJvUN77WDjnrHDEKlCO/TSUI1OT497fOiXjgqlqUOnnBvnAodbADJuam/1/NFgZ7rZCdR8iZAka73Jon1tFNJQNSvC8hWshFkeYUJq5I+vUjv4FEZlgW0exhhO3CZ1LCa6PFx8n2LVz6VISqUtI28Fxl1pl2inh0V2OBn/6N41ApOCg9mVDD958hM0NHx/iREAryyH314+lWJEiAY74fPT+KL+h11fN0wTHVHsRuMp0iVDjcLPLq5fXsI+Bz9L0k/AHBXBfRE5m+dK1dWRxnNTD/k7MwmZgmNTrcTV7PIZkQJpaAert/jqoE0jt4oekypk9ZIkobQM9OT2s8FSWsMCRdfXj/nnHopCVXL6wbk45eaQ1xOaMa4040hAd/oN/OB/eNBzr/EUOn/Ybsy+tfX8iv1q8dl23iuwywAg8OQV24F/GXoieI99Z8ptNPEpTc9hLlFrf1JnwqYn0jS0ixv5bt/XuTBMrj
 gdu454eP
 6usrOEkfQza0jybejZW3FHHlD4VV2EzFF2XG3CyktTdL0ccD7JfJNRkNILZzzWfyOVoOBcCVf+dO54q0/t9oVW/wibdEIc9F9O5yb2Qyh1seBlUvZ8cyPIYR7ZK7s8H8RBNkHXVjLhY+5jwxWDP1xH1hO9pkvW+OWQyye+JKYZbc2GZwZfP2C5DEr+LkSNXZSiCh2Vqrx2mjYjGD8lFO9hfMv6jk2JfY9+/j/gkiLZ1UYs3IKtDXkHA8++dxET/xulqXqXyinsohu+Jk35rKt74Z5LSfVOD6FDeSYRocDplNDDK4XcG/dBjnQ4CPBrUTzZPD+TQFMBZLCCu4INtynkisXYR8HfshATorIriseZ8MM+mHMTcvGc3tK/tcJkF3xr8lcJAfA/pe5Sbu7qAvdqmZqORKeQDAQIeWHbplGJHVw6wbTVaalxlk96L2p6fgSssU1FiTEVJuKEJN1kBSkETeAZDuUSSyOH4MsCzEOqIWbnid4zyJXam5nz/KqppEH6MHd7Y8BTuyEz67CVpHJjS4VOZ9/cXoZd4anhOOHEP1UhvoXQYjb2zB3aL4SQEhkmjWGfR0zvyjhOdzk0s4OAtpZiUXVUaLGfd2DfVQkVAxia5ZdO6wTtTzAdlM7456m6J6ejIjFJfVkGMTcjzRCVzi4N27mXNaGRRSU85DeFVvyFzefSkDcchyB9ZgH2un5ARDBmJPDh/vWYn8Ol8eOfDiZBB2HIsvlO6/Htl2WowXukfy9rDjtSv4rgN5o1uP4IfKTpBGQyQitoMjgRuEKYHwb4dRpO+/jvu0UmK2whTpuuhnQwyeC7+m7Kw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if=0A=
a guest_memfd is passed in as an argument. This eliminates the=0A=
possibility where a guest_memfd instance is passed to vm_mem_add(), but=0A=
it ends up being ignored because the flags argument does not specify=0A=
KVM_MEM_GUEST_MEMFD at the same time.=0A=
=0A=
This makes it easy to support more scenarios in which no vm_mem_add() is=0A=
not passed a guest_memfd instance, but is expected to allocate one.=0A=
Currently, this only happens if guest_memfd =3D=3D -1 but flags &=0A=
KVM_MEM_GUEST_MEMFD !=3D 0, but later vm_mem_add() will gain support for=0A=
loading the test code itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) if requested via a special=0A=
vm_mem_backing_src_type, at which point having to make sure the src_type=0A=
and flags are in-sync becomes cumbersome.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c | 24 +++++++++++++---------=0A=
 1 file changed, 14 insertions(+), 10 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index 8279b6ced8d2..56ddbca91850 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1057,21 +1057,25 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
 =0A=
-	if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-		if (guest_memfd < 0) {=0A=
+	if (guest_memfd < 0) {=0A=
+		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
 			uint32_t guest_memfd_flags =3D 0;=0A=
 			TEST_ASSERT(!guest_memfd_offset,=0A=
 				    "Offset must be zero when creating new guest_memfd");=0A=
 			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		} else {=0A=
-			/*=0A=
-			 * Install a unique fd for each memslot so that the fd=0A=
-			 * can be closed when the region is deleted without=0A=
-			 * needing to track if the fd is owned by the framework=0A=
-			 * or by the caller.=0A=
-			 */=0A=
-			guest_memfd =3D kvm_dup(guest_memfd);=0A=
 		}=0A=
+	} else {=0A=
+		/*=0A=
+		 * Install a unique fd for each memslot so that the fd=0A=
+		 * can be closed when the region is deleted without=0A=
+		 * needing to track if the fd is owned by the framework=0A=
+		 * or by the caller.=0A=
+		 */=0A=
+		guest_memfd =3D kvm_dup(guest_memfd);=0A=
+	}=0A=
+=0A=
+	if (guest_memfd > 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
 =0A=
 		region->region.guest_memfd =3D guest_memfd;=0A=
 		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-- =0A=
2.50.1=0A=
=0A=

