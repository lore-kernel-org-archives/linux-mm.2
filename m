Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDBFBFD877B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:13:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 326AD6B00AD; Tue, 17 Mar 2026 10:13:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FDF56B00AF; Tue, 17 Mar 2026 10:13:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECC16B00B0; Tue, 17 Mar 2026 10:13:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 099156B00AD
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:13:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CB7371B66C8
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:13:20 +0000 (UTC)
X-FDA: 84555747360.20.6CB7282
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3EA7CA001A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:13:18 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=EYZyvHez;
	spf=pass (imf25.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756798;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FYsgkotQwsE3twzfNgwzCUddRr5tCg6gdL5/vBTBngA=;
	b=O39vA8U2eN8S/5xL/gR+k8VQFPjYdHl33ircoIOWpYzGupTsn7zG1XiBKXKMjIhAT6QfU/
	FzlHDf9A3MAirfA5+gEla1VVFVUfc3hA9pgCUd+ELx5jGesMkqVQeODHhRtzyd72AYi7me
	lQY3ATSj5W4qvrMDzsCdzIlbSo836jk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=EYZyvHez;
	spf=pass (imf25.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756798; a=rsa-sha256;
	cv=none;
	b=fmVPwdNhqufWEgbiIHDJMj99eLQQ69bSfin9FdSd+35nO2OHlyom5J67NQjx/2Flt6JTYg
	H7MY6LNPZvjW4yRyBEoKFibgfSQvhAkfqwoubopsjd/ZVmQ6IF4NXKb6DuRELVTkojUbkl
	qNmNn/rKv/QxejTS01kOpu6OSmM4H1U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756798; x=1805292798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FYsgkotQwsE3twzfNgwzCUddRr5tCg6gdL5/vBTBngA=;
  b=EYZyvHezjPmrOd6lAK1D4mGGpYwNOO+VGJFUPNyGmf1ZA052+ZxZhFcJ
   d+Ob39SwJDxI2hXUkRaSUs0ebVoJYiVUSSG+vYyQKK03V8ha9ogch13Aq
   bmfDvh8dw3oWw61h6pL6uKoM4YYGbmpzwUVC9oiKIKSkrBDJKXEa251Ey
   yWJ/DNRxqOPrLzmOFPS8tDlL4wvJGvCY9wLoX1Crseicj7zPZZodayy9U
   A63sxF5uLY/JJley+/jE3M4Sct/mScvCye1U4Foxo5ssJIz38pvyEbb8a
   IJxV7ve55+Aq/PyM3qydMLpu4DtjjWmypUcSBjN4yV2EpsHH9QJwPEISp
   w==;
X-CSE-ConnectionGUID: dQ50hGlCS+mVkdXQCi27XQ==
X-CSE-MsgGUID: 75IWVisKTEGJehvuWkfBTw==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10999470"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:13:16 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:19246]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.18.122:2525] with esmtp (Farcaster)
 id 2f13a2a9-ef77-4a1d-b7d5-f69766945acd; Tue, 17 Mar 2026 14:13:16 +0000 (UTC)
X-Farcaster-Flow-ID: 2f13a2a9-ef77-4a1d-b7d5-f69766945acd
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:13:15 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:13:15 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:13:15 +0000
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
	"Manwaring, Derek" <derekmn@amazon.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>
Subject: [PATCH v11 14/16] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Topic: [PATCH v11 14/16] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Index: AQHcthgyuwe8FmKDH0i+WVkM5uY4og==
Date: Tue, 17 Mar 2026 14:13:14 +0000
Message-ID: <20260317141031.514-15-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
In-Reply-To: <20260317141031.514-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3EA7CA001A
X-Stat-Signature: an96moapnfnraqm8ws86uhxq45d4up4k
X-Rspam-User: 
X-HE-Tag: 1773756797-555203
X-HE-Meta: U2FsdGVkX1+XidXyZQnXt3faip9NZ3HXp/eMd0X3I+yIByJy3eK5L6cpi+eftMfHy/BF9hqfOdPgUzmTgHPnvOJoYpqxjTHk+uGzRm+WUGz7JKjpFje03TX9l7q4AbZbX7v5/RFNQwLpdP0KyTI4Lo6ZNtkJOoyGW0Oqki+0K0AVftAsZlPXZOK7mW37YJvE35NSyHMY2w4gDvzCtGNf94VDay9F5OUXodyfwP0R7RnN+Iuz4aw9kekJrSuH1i9jIk4xIAt/JS/iQ/nyjkmmvzgNS4dTqY/5ouhWKD/MEAE2uH/32abq7qvNtx1eMumBpoigbk7wtRWfSRMFLes/Eq4tAr/sUjrrmYgOwg5cU00vmxpUT52WZaoYy6BCkzjzv0+tvTyi9vXoFwX2K6CYnpzHM1s9ikPXEYx6iJF3a96+pGobZ6hCEExjfdO4xfpnq2p9UOcIcLIuzyfAv5TbHxwN1PffAbtWS/SYRo3Ua+QKAe6FZ//LVGHGWN+GsN0IxBf0FPCLyMIl6RWG3jqg9PE2tkC44OyiYA1oytA6VUcoDxQOEPnI0UgPXZGpiWzlRINq6xlChMngXkeWVLo5kQATVmRGmc+eWLxGhf54Z+9+XyRtbCpGCxqXBjIQ+uFovj8oZ8vPv7ta4kgPZwmCc5cKEU+3Vo9dx5MqlZ/wGSfwCzS8HSh/Hl2tRpkdbUzcFWGI2SkanwTDIP3Q1q7HrZMVB0TT+D7f/Hwi4QZjcS8q7Mh6B2J9JX9VIC6f/oZPbefcvBvYybThx2RchsHOyTwZSHaEgCoYmdHpnmn8sfYtjofDDMOugn5POUfJ0iScoMBqJazuU87DRh2pwqy7mW0VY9cNQyS8gRP6lGGL/nk6TlwnyBOBDtyrzA92aiz5FJgaPAfPantmJrB06CIOIJWqQRkJLckO632l29Le75Zn07u88QuLOp8lh5YudEbNDJNxa6rqnK6/2AxXq4A
 clyxfIO3
 weGJq7qw2RTNbOAnvm7i9BUMyjAkRuFGdNS7jMkHbgDSYqQpHqKQlxxZVCf/LQxiUO5lDMeByycFbiBMkLy64+Q9I/omM4cyHAOdPlKCwG7N8EoN+AFehcnH0NjO+HKrV4/9fxTaVKl0kiphRph8oJM+QabyE14tuFfOJnIJKq1jc2yplXi9O1lu6TIAlHU43vtDDMfq9gIaR+WuxZGsFD75yYqO2tD6nqfJpp98dzHbQxq+OJGbeBRDILddko0h6d0RzqwMpX99QdvTrM67DmJknsxxqNvmI1Cpm1C5u8EeZq2p5i4wvyOPcthnnokPMLuiLWytzBL/BGmA0B6AW1EVU2PEk2DZWCR8eJrtWelrIFojtfiMQp+kdjEzzxauCEU9zBCu4W39ecaFR4IqUiFbTFT2sYFUe7sTFejNqbIGxvxVmD6FuOAWsGpdGtxNKvgQ3zRLxr0/x81Wwq4pY/cYibu4mwD3XCPOgT4mfRIqrhpf2oEWRSUKHQf3Cu+G2sTCngs45MnGqkcD07tlyARwqRP2SedBc2uaZPkL9SeW5zQ3Lau+rSnzahpMw4I9h7QkV27zZTVSD2rvWH3Rl1U2fNsjVwSqeQiHZ7a0Y/Udz8CpM/AtL+gw1soJyvJW8+vZ/j4+Mb1KyosRnggrx32V0kD33d4uIhXJA1sJ4RW4DEnr/cAl78wyVFJ6BrhKOh1AENHDDkHu3ZTH5kXaK/6tpugNqTsQ1roJhx3nDLx+Dfb/fkLyUN1WLHA6qM83W4N4HEUiZ6ES9/yA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Extend mem conversion selftests to cover the scenario that the guest can=0A=
fault in and write gmem-backed guest memory even if its direct map=0A=
removed. Also cover the new flag in guest_memfd_test.c tests.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 tools/testing/selftests/kvm/guest_memfd_test.c  | 17 ++++++++++++++++-=0A=
 .../kvm/x86/private_mem_conversions_test.c      |  7 ++++---=0A=
 2 files changed, 20 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c=0A=
index cc329b57ce2e..64c1200c182e 100644=0A=
--- a/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
@@ -403,6 +403,17 @@ static void test_guest_memfd(unsigned long vm_type)=0A=
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |=0A=
 				       GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
 =0A=
+	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {=0A=
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP);=0A=
+		if (flags & GUEST_MEMFD_FLAG_MMAP)=0A=
+			__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP |=0A=
+					       GUEST_MEMFD_FLAG_MMAP);=0A=
+		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)=0A=
+			__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP |=0A=
+					       GUEST_MEMFD_FLAG_MMAP |=0A=
+					       GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
+	}=0A=
+=0A=
 	kvm_vm_free(vm);=0A=
 }=0A=
 =0A=
@@ -445,10 +456,14 @@ static void test_guest_memfd_guest(void)=0A=
 	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLA=
G_INIT_SHARED,=0A=
 		    "Default VM type should support INIT_SHARED, supported flags =3D 0x%=
x",=0A=
 		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));=0A=
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLA=
G_NO_DIRECT_MAP,=0A=
+		    "Default VM type should support NO_DIRECT_MAP, supported flags =3D 0=
x%x",=0A=
+		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));=0A=
 =0A=
 	size =3D vm->page_size;=0A=
 	fd =3D vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |=0A=
-					     GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
+					     GUEST_MEMFD_FLAG_INIT_SHARED |=0A=
+					     GUEST_MEMFD_FLAG_NO_DIRECT_MAP);=0A=
 	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL=
, fd, 0);=0A=
 =0A=
 	mem =3D kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);=0A=
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=
 b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
index 1969f4ab9b28..8767cb4a037e 100644=0A=
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
@@ -367,7 +367,7 @@ static void *__test_mem_conversions(void *__vcpu)=0A=
 }=0A=
 =0A=
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type, ui=
nt32_t nr_vcpus,=0A=
-				 uint32_t nr_memslots)=0A=
+				 uint32_t nr_memslots, uint64_t gmem_flags)=0A=
 {=0A=
 	/*=0A=
 	 * Allocate enough memory so that each vCPU's chunk of memory can be=0A=
@@ -394,7 +394,7 @@ static void test_mem_conversions(enum vm_mem_backing_sr=
c_type src_type, uint32_t=0A=
 =0A=
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));=
=0A=
 =0A=
-	memfd =3D vm_create_guest_memfd(vm, memfd_size, 0);=0A=
+	memfd =3D vm_create_guest_memfd(vm, memfd_size, gmem_flags);=0A=
 =0A=
 	for (i =3D 0; i < nr_memslots; i++)=0A=
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,=0A=
@@ -474,7 +474,8 @@ int main(int argc, char *argv[])=0A=
 		}=0A=
 	}=0A=
 =0A=
-	test_mem_conversions(src_type, nr_vcpus, nr_memslots);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, 0);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, GUEST_MEMFD_FLAG_NO=
_DIRECT_MAP);=0A=
 =0A=
 	return 0;=0A=
 }=0A=
-- =0A=
2.50.1=0A=
=0A=

