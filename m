Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF0DBFD8770
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:12:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65A416B00A9; Tue, 17 Mar 2026 10:12:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 635286B00AB; Tue, 17 Mar 2026 10:12:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 521166B00AC; Tue, 17 Mar 2026 10:12:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 41C736B00A9
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:12:59 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 19A10B6EF4
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:12:59 +0000 (UTC)
X-FDA: 84555746478.26.624AECA
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf19.hostedemail.com (Postfix) with ESMTP id 83E071A0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:12:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=M03Hn+AS;
	spf=pass (imf19.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gmZJ6ya/vdfSa4YhvhpjSYznu951T3SMQIDzGuB8iyE=;
	b=2jdXt+O5UgxY5xs13R67vwuZyXhmQPI0k5F0VqkOHKVvYiVqTM/5SZ/W0nSwRLXAmtJkZL
	Qu363Ht1WcpDNEI8AZAmwlyVJdO6Qi9o+odsl1/0zzl/wzq6Nb66ese+OqkaNH0eBv1s/H
	k2VtaTLCfeHraXKfF7lccIjuxdcrJk4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=M03Hn+AS;
	spf=pass (imf19.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756776; a=rsa-sha256;
	cv=none;
	b=jEXwfZaoNFSpW1GaCiunLZSMCwTb+4kaacJSSSVl3K7uozO3/C25777daiYEQUR50cGz7x
	cPgvo6xAwxjHxpMv/H+0NHY9OqJ0gnTdT4kqQIK6nWS1g+K+r/E73jI4hjQaHwaC3Et/gx
	li9d0zA98IKFnPi31008h8EKzzH3aR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756776; x=1805292776;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gmZJ6ya/vdfSa4YhvhpjSYznu951T3SMQIDzGuB8iyE=;
  b=M03Hn+ASpiTZVYWMgeXr1tgiIslV+jlSZzoP7qArBb+J3hn7ZpYLhgV5
   CrmL+l+uvH0j20L3tkHQMXGtRAV7/LvCGjsMLBj84JGlO+3aCJRJNQr08
   XEjHWk86ITdMBcHrbtsPQCVyuaSqIDIaXhNVFXMbWGOuF7Zod/k2hnUz/
   ZIDOZYnDe9r9XJ1x4n+b0QplKb3GxEDRECFb4Y4AYxBdN8FV4WQe+g3BA
   TvKSG0jos3bGirETDhsmitb95Kq9uWdO3q/rUKaycCqy0kTUGe4NfXQyJ
   UQKM1hyVuFFQXAuDrxOQzIBoVrru3SXii6C3ILFDmYpxC69Ut710fEVxe
   w==;
X-CSE-ConnectionGUID: nLX7ucLRTBicNcF0sNi0QQ==
X-CSE-MsgGUID: Rrdvv5X1QGabark0BBKTcw==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10681150"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:12:52 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:10154]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.205:2525] with esmtp (Farcaster)
 id cbc38a56-a712-46c8-a9e3-1c87071a6f33; Tue, 17 Mar 2026 14:12:52 +0000 (UTC)
X-Farcaster-Flow-ID: cbc38a56-a712-46c8-a9e3-1c87071a6f33
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:12:52 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:12:51 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:12:51 +0000
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
Subject: [PATCH v11 12/16] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v11 12/16] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcthgjEdSlT1yntUuXqx/9OGjNsw==
Date: Tue, 17 Mar 2026 14:12:51 +0000
Message-ID: <20260317141031.514-13-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: 83E071A0005
X-Stat-Signature: buoes7544pby8mmiioj8ahi97mgkcasx
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773756776-846167
X-HE-Meta: U2FsdGVkX18i6B/B2Jpum0CN+XQ+ZuYLJBbd+Kkh7ve6Wd3iuF0MgOFJVJOEoPEgTl/eK9pJNswiMBlu8lp4jqaKrlGGtOHVVInH2xqn4kGVyu9y+UpvkNvDCq3jmfS9Ha6YhRBBhzKjwS8s/gaxbQE0VOWJ0Kt1qwtj94SYrPHqkPqMKoY8d4uWrzfwsTGBWTDPPznN5LwPhhd1XEQBDJCcbkgcv9u5Cur57ZrhlcI2aJpzfwfjKm8/h3cM3xap73fqddsASnSeQB1Qwbq7HHr3G5zlYaNmpwxep6R28aAcxc+IApUQ5JPCX2NG4jTon9+j2MJ8OBzhBNEF48TIDwimrLZblxt/wEI5OV3/jszc69CiXCFY2g/vV3lH7xWWcnDV00QiRWZ1JtXFv09yXcX8K30zxziuKHAGTWEMr6GDWZVjCIC7H3tJG2usHfM3tT7axNvqod6mf5zTXwFuWbc1KJ9wl+9zd9sbcwDBWMaJk8ECZyloJoJ5XzgtwclvQz9wl3HKePQJ6ER8T/S/kUp0P+ZB0+aN0LL6l4EayjhcwP5f6XEAGqphmIw/D96OTSxKQ02fIbKW1gSF5IDavNirExSrYL1B0857WRSNGRYhjjiCmHEuJee9MEiJGJS259RHHyCjxvj3tig0LCsGVS4a72Fr2G08UDyOMZY8UwgeUxpyyO/ig29YOCgM7QOzV729l69plbdC/O+L3570B+qQx/y7N5Nan9KVVdZaKj/PgE1EJEPYrD3ZtL1Sdp4Z67e1NmhjKvMa+kI0gWmDVMRuBsAWNZCdCG8wZWKbx9WeTc+BPWnT0VXOTSZ0CvJcdtZwihmSZV94KFZmPgN8jCy1VrbQSEUc0Ei/Yv/diXzhBrh/Vtw1hjcmOfxw+zumkKEsHaAQl0SRFY2cjix8v5yEYhzmqqSqQQf0K6gemgmFtneRLDv12sbKRlcELlhU/HZqELtzBvO46kyWO6X
 o7T8AQTX
 wmLtsM3M+nMFuVvO0prc/ewzNtoyTGbUmqX0AXCcNdlE5UF8T9q0CPaXqxKqF6v7LogPJbe5fAyGVYGEpZI9xqHMZxNgq9pXlRDt/09Ode4AKOwNceOLw+UGOJ7/xayvxbnTX+HOuIgVKkwHRsbMDlqA0NDOMXLi3+qEmiwTiyBtfaTiIcD5N73YVIDNeaJ/nLHiJCSoVhNLg7vheylb7VsaTt3paJ30XPwFNiSt7XodXGfArn3m5XRrZhzqInKwtyYrShcw6hBKPYTUcdcpRz3lM1XF74Hgsd097z1JNp5HYXw33jZLeh6S8OUGPm18BxndCw2jxaV5CcuFrDPLqQj1AnN0soMKAy7PHP1RLZd2tXiPM/4LZNjvWkhnXqAmgloxN/glwJZJm0DSLT9dpJMsOfcQhdrnEbUwNi0xeefQf1cEo2wgZ0ZHTqgMwr49wz+EGN4idzF/Y+POYtqAamOxuCo8rrEeCmjsMneMjziKiu8IzNYcylIwQhHNohR+HyJevmAIr5OxYn1NN1LZCKivFzQcGqqPIlKjprnSzLIKWGFSH6qVjANLmfFR0AyZ2GGq7Az35DLZFKXSFIuOCkn9vF1VwdHqwHB6nZtO3IX6XVXTItKj/Mza478ea9UJ6JAGTHHndPTofWSGqPfm3gEGpArSXttm6WRCKPvZvV7aVPvGv3oE0woWU6xclr++rw5bPiz+ruUay3N3X+FiIX6va3jl13GcLksosHsHgsGxBeSWNK4bj1dLAX4u8LY82zcPQAK7FosK4I23YNAuBgrFTyGDNCMThUc1ZSBL5BATR97H+tLPmGOgsdA==
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
index 1959bf556e88..5b0865683047 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1090,21 +1090,25 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
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

