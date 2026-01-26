Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A911BD19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B35B6B0099; Mon, 26 Jan 2026 11:51:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17DF16B009D; Mon, 26 Jan 2026 11:51:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035ED6B009E; Mon, 26 Jan 2026 11:51:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E8F676B0099
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:51:03 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A76735B547
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:03 +0000 (UTC)
X-FDA: 84374704806.16.8C3A22F
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf19.hostedemail.com (Postfix) with ESMTP id 279971A0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:51:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=DBswMq4c;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf19.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jc9MipNs+jRvs8/alLQSd1jk+l+CAkjcNo6zBdOlRgI=;
	b=MiV6ONfCzK0YuqR0pn1+BKY8zSLBjjQGehYT2rhN4vg63BL8aB8tfcpdQLxP2bUFy50K78
	yI68GMngrsPjcJEV+oJyU2z990QBgDFTvkv+lQp+5YXaJRbttuVhXEZylhXv/Y/fDx157S
	nf2+Fl++zXoUTKbS4lnPAtfVDSg3ayg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446261; a=rsa-sha256;
	cv=none;
	b=RVFRysnyzyh/bF52WRYovdMo026U33u5OOlTNRkJqBVcWSMj+7Lg+s9rN9D0TItKpFPPHr
	pclzkxq8V21uDsAU6pB7B8N/C0HTj8hHzR2ipRfWzdqUJx/gskXOeKE0zgJTUDZsuBXg6N
	1SaDeuU1NLGZbTT+fdglQiEtfrJv9og=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=DBswMq4c;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf19.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446261; x=1800982261;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Jc9MipNs+jRvs8/alLQSd1jk+l+CAkjcNo6zBdOlRgI=;
  b=DBswMq4cUZjCOtwpl4icv9mCqvkVsR0jHF55lpe8qLQeM3zv75iHDVqZ
   6PT1w3lpBV/8smqRjbh8gw8h2eYCb/UA60DhBRQZWQ/e5cn0NNM1XJrdk
   lK7lgbS8VYwwTqng5tgbLPFRLR1Xb+mA/mjn865maOTpz7ae2m82swm1j
   7yOUlcUxuRXSCihzYN0EHBVj1G1IjlmckmdAg/Cfehw+22XLm7cA5TAxQ
   j1S1xn4qKdGOYZaoy7YxEoEtDUiroay4cQsO72Ri4+BpOBW2+GhvVhija
   +SMjdNqQJ9J5Kle9jOKBSJ4i+L1z8a+uCINzkX6NbaDDBBNdksTUeU1G7
   g==;
X-CSE-ConnectionGUID: b9vX8AkLSL+fmfI7VGGAOQ==
X-CSE-MsgGUID: Gs1GJvP8TOWtneYnpV4Eag==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8462711"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:50:59 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:24157]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.185:2525] with esmtp (Farcaster)
 id 7f63df6a-e714-497a-a74a-daa6c67ccaa5; Mon, 26 Jan 2026 16:50:59 +0000 (UTC)
X-Farcaster-Flow-ID: 7f63df6a-e714-497a-a74a-daa6c67ccaa5
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:55 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:55 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:50:55 +0000
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
Subject: [PATCH v10 11/15] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v10 11/15] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcjuPwB1du/+4SKEWmYrRFe6KT3g==
Date: Mon, 26 Jan 2026 16:50:55 +0000
Message-ID: <20260126164445.11867-12-kalyazin@amazon.com>
References: <20260126164445.11867-1-kalyazin@amazon.com>
In-Reply-To: <20260126164445.11867-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 279971A0002
X-Stat-Signature: aizbbsu6phzub5b3doof5adki9hons8m
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769446260-486961
X-HE-Meta: U2FsdGVkX18TCKNnxK9QUBliGShkfqnrn31t9i4dF2KQgPl+z18GTHsLGUVqpYCVhk1b3YJyifWZavla2+GqI99NIQYxk49yUs2vv0b5Y+tKXMR3ZpWf5CGNhbZGeDYqof4Gf/y1yb9IoKGQEM43v1OislXsj8nI/ApFtlgFLBVG6Z2/ZoCsntpRYG1RZ1jg35T4jgcua8QV13xB6riaUVBxax0NlE4p+ddaXzAEgIh7MGjf5k3gA9o8MSEh7g900Pn6Tr7lKuFvmdyCJTrTho68qR4zgLp5Ri2eioktAbV5TSJ5sDgRgIFPR7dNCu8NDXdfuE33VQ7S0yix9i0FoMR9DvHLSY2UnpZOv2VDvK5pIamOJ5OWAvg3cDeTSRd8+DtBXUINKOdIemL8Wv+YDBcIVPNJEu6XZTe4DZLuhszKNCzd1hXZfRtibJndLv1J5r69IChBwlvBQrFN41CsshzeMSVt47MZDPbTSxLtQcLHqahM+j/FsK+YUC/g1u7/u3uGoroGRlht9jSR5Wkldc9sWb3Y01xrV/8pASpFXxoz7ZtJbJ2KJw1v9b6Tobg+O/vDBAUCwpA0GehXlzf07pGNEaC8csiqe0iEN+3sZSS5F+vkx4V914KQKSrbpAzarow5eSelf99wbjXVa5+2m0bmCSX6jZfWYwC2u2oGNdDeITLeaOKA887vRL/z2CAsTD12M76Od9G8AbbMLFbDMZqpp6wHlKhWpEMayrCDKG5uB4WCpBoLvL/4gLFoZwhIe9saU0sr9AInr8FdlqbjxxLUMdMkqWduymfLv6yIqN2zpJ57HyJ15otHIlWhY2LTgyt6VMZP31l8rCv8rAahMglmi4Z6ACLudcey0q59tM0SW0OpJrnhf34dxrApUdp7DU1g/HsWAkBFUpKfIQXE75sbFou9HobPmfU5LBuWwtGNaH+bVA2BvYFWpAoPWXRr9q8D9J3PRgbqB/98/bj
 KeNIk25r
 tzezKPUup+Xk+UnxwxcsWjbnjNh4n7C+DDKW0RVDZLTo5veXvzwr2fLa2ArycA6vzYPG9LHShv23vzbZMJRkJjvv/RCjFrILrjN1zAx8aQoVoKi7hYuuYTGXCw5u89+VeJTUiP2/hvYrgtozuTTFfkYV1XrTHKhfx1OlU2dOKQpRSbICKOt10DduGWAk/G9/HSmF4hu7dPUZatUKgLuYd7bvRe/XmmfrM3MD60EN7GR8BmrcLqT/tS8jzTMf9tcfrmsKJbaBzMNqJ+xRiUHKnR7nhLwIaW7FKkld3+lPuFTI2GkG2XsLTIM5fiqZJYIC7dVbL5Maq1gNSmKjwYXtxtILUB8a5UR1QKQTwFLkfAJp5IZVwlx1LdRoM7n6ZwC0UhtUJHfmqrWIKWN2yzsc+7JQDfNyJCeyjgDrSIMTmYjqsTgOvTetjwRzF7mjI5XdbqKDtdJem2LrTsFRE4sGii3aUgzGYQLrhjYu42siCDOQVplLCdDhuRMeuyGl2nz7YlGbC3IboddvBhBqGBnzOhgTUwA+bbCj9XFm1wivQLhwWV3T5nFT17mjgXIXaHhpAtJTlLev+Vi+V6jwGPviHtMpAhIvi3uVvxB5NU5uVpOz3OzMUxdHZWuVq+eqIJkDewmCvXD1HtE1K64M5l6udwmzOl0uyBtv/SJwx9hoqDBWnTn4zSrtt4MrbLE3uWb96oNo3j7xL0T2twF00TSeoiCl5mfPjN0gGju1HhTGeOWEIe8seE7u5Zl3o0dElVRk4xeWQr57FG0tAIlCIxpQbqZxGcAD67bfYJbiJiJp7M1NqsN2PYMr2ZVPQww==
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
index 8279b6ced8d2..0a2999d8ef47 100644=0A=
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
+	if (guest_memfd >=3D 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
 =0A=
 		region->region.guest_memfd =3D guest_memfd;=0A=
 		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-- =0A=
2.50.1=0A=
=0A=

