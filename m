Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8069F459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D61D6B00AD; Fri, 10 Apr 2026 11:20:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ADBA6B00B0; Fri, 10 Apr 2026 11:20:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D0E6B00B1; Fri, 10 Apr 2026 11:20:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 08B416B00AD
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:20:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B3991E1FBA
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:20:02 +0000 (UTC)
X-FDA: 84643006644.02.E037DB4
Received: from iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com [107.22.191.150])
	by imf28.hostedemail.com (Postfix) with ESMTP id 6D5C2C0014
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:20:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q9TjPyAS;
	spf=pass (imf28.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJORVKe0i7KoT0bB0BMS3RwuTNBkhAjfGUnknRrFTOI=;
	b=5RF4Fb8Y1Na2K4CXHBCskLTRwAZ5uhoBDj/UNrWHyBK82/SQ/dittOKTpvHVha04SJGWTp
	20g/rCTWRohCBHveGJfkO17S30bfYk3Ilyv2KaA4q9p7dF7caLR2Ad3TjUFPc+ko8qbIug
	LdAmcAADsdnm+du74NedPuGGCYpdLrk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834400; a=rsa-sha256;
	cv=none;
	b=gcuXJfBnb+fkRggL8St2lf5dS4wIdV52tJc72earWjLjgC6D1Zu66gZ080/lks9UGEO+UP
	UAK75mDMCridVAarlmzkDG9/PKHkFg+WENRhxx+q6cY6/cLtqYaZACSMe7GCbvS/M6e6dU
	O/jqpgsN6o2CeEZWv5zTD3stW1bn+GU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q9TjPyAS;
	spf=pass (imf28.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 107.22.191.150 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834400; x=1807370400;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NJORVKe0i7KoT0bB0BMS3RwuTNBkhAjfGUnknRrFTOI=;
  b=Q9TjPyASy0K6WNFcc4fElXlhOvCZQmnOo6tl5+edMzj9+IeR0ayfR+eh
   SlzdWV4S0wkk01YhRmb911kfmGm+QftlA6rPZNCRc7NrIVARHIjo+HHPW
   K/LXCfa3WRyu1oxhY0Y83pbV0kv2kof6DYXgPyEUIPN5OvUwSzzKmUTQE
   uJU7fRcjKPL7wId65wd9s961QLw5mjJ1Muw0V0jQt332LSPJ+lk0xTinb
   vln6vx/PqrHTPvTVmTn764Iewl6cV6SBHAprdVAg8wcvGJGq/KtUmzxGl
   1Ku8r3Zp6AtYSlQ5Zs9tSATsSbsyyp5EPJttrqxr4XgqQdLma1O1qppjx
   Q==;
X-CSE-ConnectionGUID: zm7krPUHRnOf0M7ucK8vaQ==
X-CSE-MsgGUID: nroFxhYxSLuHoMR1OOCrBA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15526106"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-001.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:19:59 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.142:29366]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.3.180:2525] with esmtp (Farcaster)
 id 923e6f6d-601a-4fa9-9e0e-fe61e56cab11; Fri, 10 Apr 2026 15:19:58 +0000 (UTC)
X-Farcaster-Flow-ID: 923e6f6d-601a-4fa9-9e0e-fe61e56cab11
Received: from EX19D027UEC001.ant.amazon.com (10.252.137.156) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:57 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC001.ant.amazon.com (10.252.137.156) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:57 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:19:57 +0000
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
 Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v12 12/16] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v12 12/16] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcyP19+KVGXC9Gsk+eD0kwWBM0dA==
Date: Fri, 10 Apr 2026 15:19:56 +0000
Message-ID: <20260410151746.61150-13-kalyazin@amazon.com>
References: <20260410151746.61150-1-kalyazin@amazon.com>
In-Reply-To: <20260410151746.61150-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 6D5C2C0014
X-Stat-Signature: acrtueesw98srur31s846ikckxnnytmy
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775834400-503178
X-HE-Meta: U2FsdGVkX180PzDKKJTT86Ym5X413buxJY2ieZ8VTDUrSIolqAN/r8O1MnJ4RmO7TEi/1aRddw9zuX25Y7Tk2KFooqG2PMq5IcM2PSJtwzTlmJDZ7fdJBmkLjShgIlv4rKC2s95LqQb456f0dDl97uyXUBAxiYoK78e7Yu+MLAt5VKEOwyuRGkmZkzigaH7qCSBF5mNXjnH0ZMhaOFceA2ia+xpjOOJ3eMDfV4Xorffz/fwXjA5GwOmqC5a0C4XfvKzXi9DafVnAUwBu92UR0pJ/MI4sVYDeRg8iE5U0XhRr6GPGMhkUncNyEBYcH1YSwnaT+o2Tncg/cnhBFsjE9XHpwxvucUpalS2p1xzYqh9RrAjidWaoC7SK3HOYnmJ0SnnpgGagBDbFppbCE3PiiVjcdFdGGhzL9sAAzDHJ9nWQl/WlbOIqVt+2KYU8Q0OviMd6ieME8RaQHikJSOs5G04ep1rIZwDIjhpSsn4sBx4BlKqa+9QHK2BuOqtqQU2z0i1ZPC37pyePPV/yqVyo50kJm0DyqZMMyyeE+gAzTXqwOVBQLMhRo3+OYc6SMWE2movio2FPxLip+sS02VUbTZHwY4gSQVZVMdjwGWA4LTEL0WzJ585U0e+kRcD+8tcdePM4DSpVObQ8hJivOVrmePuItag3k+bu25KN4UaEf+wJ5wLj59CkTAI9111b0ovDSW9h/msPGdiqEdL347xo1xta2GLtpp5TLwHy/piugtB2KoiKaTo92bU5DM91fVU29AAjisj6+X40wrGrHoy6uZvrB/p3Iz4BZ5rhixnX9+YucKS61HEOeM+EnaWRYC2s+Q7LOSMxXH96l/D43rzUuPiJ6fJyuEtXyVP8L0as1agYbCtuSpXi1iaa5IZC9BDv/mZDpC9LnWEJQWWw2c9LDNlNQbxKNTzMfy8i2qiPnXjSsBdTWv5KZPcob3+il6Py01rJzt36pQekT/qKRpv
 Ihh6fG9o
 0bxpMAxKvU2lGGtX0gy/w959MnplUIuB8fCVLprlHYi7/cb9GtD8Qg1n7JsknpOEbPkwCu6syx2v9H5dPaHbfVPHhBqM6a00ov/8Ypuf9VN/aWTjGuNm6Ry8bi1Cf42yEKaznQvCpjEmYU5m445nqxFZUwZ1dPXbbqhBlXtPw2UfvmYlMg4lTxJswUfMRs+qvgnsgyDH744wA7MKAz5YlOGEAmkXfLIXPbdbqoluE1yChiAU+bPBwDtO18nVnQxi+VgSG1A9QKhCFUZU0xW/kO4u2G1EaM3sS124D1c6xlAgbs/wQ+p6ooxC6yLmy66erO2rpgi0DnYKh59gMbWzibFYbZNmlDZGGOvJBfNuqpQOrlKID5EqT7F70U2Hl5E/4D61Ew/mtmcYTUKXVcwzsJvK5KjdnX/L6C9SbfimYYv/GtuUDDJS6u+tmoxP4W3qzPGat8BwbIQ0MkVTBYP9E2/kMHuQjJXvgIAKQiwUFM/qLeszuMrRgcCMGmuWkFh9XUKSEjFecJIV+GG5kwPHliIZN8XEVMDS+jt8HH2yRSAdNXZYYmMOZZyoMAtjpqU/e0NtdJz59YCYI0nszrER41GXclJGEX3544sYnO4fLuJ8RfbRwP9rvTFjJTIAdKn+T8lVN57JwlFV96oAfBIA2fZexhBjNbvQDXAMP42Q+cj+1irl4twCgGmfrw2I6CRaW5n9baCPBUy0QwGqH6N25EpwE5l/QK0Dr4bQUj0Y+lBQtndEHnLJkD34HtbsniSxQcWUSzvoBHzggDLhQMHTgNrt+5C5oZZi+AmTL
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
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
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

