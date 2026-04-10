Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31EAFF459F4
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:19:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B28C6B00A7; Fri, 10 Apr 2026 11:19:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 963C46B00A9; Fri, 10 Apr 2026 11:19:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8040E6B00AA; Fri, 10 Apr 2026 11:19:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6A71C6B00A7
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:19:18 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1E99457DE2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:18 +0000 (UTC)
X-FDA: 84643004796.17.45A8291
Received: from iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com [44.210.169.44])
	by imf21.hostedemail.com (Postfix) with ESMTP id C1C1B1C0010
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:15 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=dwvO7dmi;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf21.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 44.210.169.44 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834355; a=rsa-sha256;
	cv=none;
	b=Z2tN6JzCAQ3ZnL0agLeLKX7d/1WwBglVHwOrlXZ1iCWzVeswmmzlVvJCDGWOinpqvRMplw
	qSTan0dOGZzyAAMX9HdLIO+lAAtQ/ZQxnxzxk7zp0qGPTRC9NqTQ/p2aEUUgveuvvq/ZK4
	UU/tiu1riZP++HYjW8Q3PS9JLnA5AsI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=dwvO7dmi;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf21.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 44.210.169.44 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834355;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ALg3p/ltsqIoaqb5A/f57OhF7/SQhKPMf9Yd0huEWqI=;
	b=KkEyUnMwwxo0CqVWgDjdxmCXixFxagm4n0HciEiWDSc9F6O6nIn60LKvIwW6fUJ1MAwix0
	U3ifhTWhmTHgGTpdZzzfN7ITGholVNiSeUQXbNaSAX45JDZ5h0vcMZ+T3nXhm8FjeQG0K7
	E4TnX9eGnOLkxbpf2c1HucH81U8PJ/M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834355; x=1807370355;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ALg3p/ltsqIoaqb5A/f57OhF7/SQhKPMf9Yd0huEWqI=;
  b=dwvO7dmiq+eJZnondPYw7FMfOBydLTBvYA+MaDFfAsQ/o3ugXFfYONPJ
   T2AInUv9h5pQhdnYR2vs1t4sBKBMEEfckmxI5dDWBQdJnkcWDFgGsE5xc
   OdBtXUauHDJUp2R+x9zfsH2fiBjKJrvdgJ6nu6RrECdo/H7PuR5MYaPCC
   coVD8vSHr8wB2w61xCj6O8EPxDvGo86zaeMYLMHx9c4uE5oBp4k+YlYYE
   MegK/1gSnMDGIldzWnn0iPQfoZvqq8nkzvEXoRyYy1ZCIZxKet1iYazkv
   ngNIiaarAylUvOJJQjeMqI8RD+Pr1T3Wc85ZmIFsKctfzloCVCoG6XGcL
   Q==;
X-CSE-ConnectionGUID: Guv9fjVNT/aSrGQUraKCmg==
X-CSE-MsgGUID: tuX3xo+YRyC+BGiBmsyZ+w==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15419479"
Received: from ip-10-4-3-150.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.3.150])
  by internal-iad-out-015.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:19:14 +0000
Received: from EX19MTAUEC001.ant.amazon.com [52.94.133.142:28111]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.29.254:2525] with esmtp (Farcaster)
 id ff476389-81e7-44f5-b885-cbfab252140c; Fri, 10 Apr 2026 15:19:14 +0000 (UTC)
X-Farcaster-Flow-ID: ff476389-81e7-44f5-b885-cbfab252140c
Received: from EX19D027UEC002.ant.amazon.com (10.252.137.166) by
 EX19MTAUEC001.ant.amazon.com (10.252.135.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:14 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC002.ant.amazon.com (10.252.137.166) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:13 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:19:13 +0000
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
Subject: [PATCH v12 08/16] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v12 08/16] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHcyP1jSNvh4qnnak2U1huEC4ubjw==
Date: Fri, 10 Apr 2026 15:19:13 +0000
Message-ID: <20260410151746.61150-9-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: C1C1B1C0010
X-Stat-Signature: et4grjn6fw5nd657gknx6ey39y3e4sen
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775834355-528635
X-HE-Meta: U2FsdGVkX19Gf0WHXHgEmM8qGnQHs/Io2wOeZtbN65jq7CBS0WP5bLLb4rW8J5BNN+i7Nu3pbMh/IeHVCC4aN+JU+8s2Kb5I6ZCrKHe2Qygu/vw7SuGvicPaHW03Vev8+cufAa/MAlYdL8UhbRF/Fri6filjw59MgBjLd7TIR7ktHWljUl7G0xRvSZ5sUtVnRZ3jZq2gRPAEvyG6OyuHMNO9h3Y8KH5MoZdeqEbHcfylqmNtdghaKTQIlFcENuTetWyermAvWull2AVyRdxWFaQMRSg7N8Xz8Z/oPD3XrvgyRN8ZtBMfNv1xcmpVnOF2eqUMnU0wAaOF6CKb9AjR0ADTQJhAAD1jvNmCcRyYJnWxDP7SLTQB2/iJoNJJRbbrG7i1nqT3tU1EDrOwWbxstl7pMl0XepcqucliaTsRvJlYrEkBcI52n6rATrZPyDBPrmLJQ43dDZD1MW2VgJ9GqITQJQE5DhTEcVgs944peaffjVhgHlNQI3sYk2uXSIkrTCvrX/brb1y4XpUEOsv8ds+DeEqNfm5vV8dlXEW2CXsJN3hWkFeQQIs8sDw/btn9BSU+k+nOzxSOT9NeqflHTS5+Spx4bYZi0KQNzHGe6Qt7Y3CnGk9XGjplL1+kVy8DqN3PH36CaJe+G6AsOH1W5fwCr/oCK8o4I4Rfwygg/wXf/US1gXvVdz5zM2zBV/PYTmhrYdbNpTUzV/6rhY42XVBuz1pP7HQFXEDdTNQtg6J0EmUVKf6Ra+lrPd4ojA69fEmwkc71wYhgMcMpYJlRYv0Gr3EDNnM6/dn0VjImT2jql0KMMbj9clqtzawaQjvySESsQF+CRb+TP7QPYs/Zy/T4dPZABSwienvZhfc3ydK3vLk+G+FLFAnhdrTF0IgewzTF0045jFDEXW45ecv8n0WG0Q5yk6kei7daSBsqx5NZ6HlUs7jJaqF6g5BvDE3NNzM4YpRxABDyIDBgc3L
 CpLQQgx2
 rQfq5Z+MA+Ok8ThmR4bwoC9qZOxWSgDGmzmPnBYiYWekItmhT6gbWCXX6/NbvAwrMN1nqoHxyTnhYhTA8ArbwQq4/z6AxjWawBtGWkGHX/O0x29dqEArfUqKpx/4efD46/l327M2nz9RIkFp3pHqzIb/9QR8Fw9sXUbO+rj2Pg3fG0o9tGGH4mYH4rusikZ+/TzD5e21hWRdXvBJtPHonXomTmcOxvmQ1R6u/YvbSWtn3vg9KLA8GTVCd8aJtD7VhxMNYAUL2BuAhYBfxXdxLiPzubA3YJUAa0t0mxVTIilPFQZzfF1lwlqHcJK/pl/7VwFu6ZmndlgWbSjiPKBk49NGRqTZSvOmT/kyUWfS7sxnV8NliHXqb/vOi92L5A8CQGlOXFROknMysiBJqTRE/8w4U8lYRae5pIzUzUUaZdK4LLz4VVQgsqMybyKBCZd8v6+c/2Vhkp+GchWHQy399COmDz4kzB8g+RrEN8ykji79C5pZd5qfkIRzCnpK8gKi0XICsFjMYR8UNu1h+S7MigdDwXBSWodcSqBYExleqqs/EttMcns45yr1zMRBfDiwLwEvF2CRiMqMh0f3wlFFCeighr1cxSq/dtY4j3DBzENNatBI2V727GR8rWGFzKOmgoH1BeQGqbQwPJZeATq9e9Ax/6uv9Y7b4WHQ0hu01E24OHQCfg2fS0adFauviNTZhws1vvdK2YgYcLTMbwDDiE3X/QzkSM1hmWsN17LmBJnR6+8PCiUa/U5GDPw+68qWFKfCtu3FXBtXZG+TvuZjdlfIu1RpTuh7NhbMA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
x86 supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP whenever direct map=0A=
modifications are possible.  Exclude TDX and SEV-SNP as they access=0A=
pages via direct map in certain operations, such as population.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Reviewed-by: Ackerley Tng <ackerleytng@google.com>=0A=
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>=0A=
Co-developed-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
---=0A=
 arch/x86/include/asm/kvm_host.h | 6 ++++++=0A=
 arch/x86/kvm/x86.c              | 7 +++++++=0A=
 include/linux/kvm_host.h        | 9 +++++++++=0A=
 3 files changed, 22 insertions(+)=0A=
=0A=
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h=0A=
index 6e4e3ef9b8c7..171ce8b84137 100644=0A=
--- a/arch/x86/include/asm/kvm_host.h=0A=
+++ b/arch/x86/include/asm/kvm_host.h=0A=
@@ -28,6 +28,7 @@=0A=
 #include <linux/sched/vhost_task.h>=0A=
 #include <linux/call_once.h>=0A=
 #include <linux/atomic.h>=0A=
+#include <linux/set_memory.h>=0A=
 =0A=
 #include <asm/apic.h>=0A=
 #include <asm/pvclock-abi.h>=0A=
@@ -2504,4 +2505,9 @@ static inline bool kvm_arch_has_irq_bypass(void)=0A=
 	return enable_device_posted_irqs;=0A=
 }=0A=
 =0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+bool kvm_arch_gmem_supports_no_direct_map(struct kvm *kvm);=0A=
+#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_dir=
ect_map=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
+=0A=
 #endif /* _ASM_X86_KVM_HOST_H */=0A=
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c=0A=
index fd1c4a36b593..32da7820823c 100644=0A=
--- a/arch/x86/kvm/x86.c=0A=
+++ b/arch/x86/kvm/x86.c=0A=
@@ -14079,6 +14079,13 @@ void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm=
_pfn_t end)=0A=
 	kvm_x86_call(gmem_invalidate)(start, end);=0A=
 }=0A=
 #endif=0A=
+=0A=
+bool kvm_arch_gmem_supports_no_direct_map(struct kvm *kvm)=0A=
+{=0A=
+	return can_set_direct_map() &&=0A=
+	    kvm->arch.vm_type !=3D KVM_X86_TDX_VM &&=0A=
+	    kvm->arch.vm_type !=3D KVM_X86_SNP_VM;=0A=
+}=0A=
 #endif=0A=
 =0A=
 int kvm_spec_ctrl_test_value(u64 value)=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index e8aa3d676c31..ce8c5fdf2752 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -742,6 +742,15 @@ static inline u64 kvm_gmem_get_supported_flags(struct =
kvm *kvm)=0A=
 }=0A=
 #endif=0A=
 =0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+#ifndef kvm_arch_gmem_supports_no_direct_map=0A=
+static inline bool kvm_arch_gmem_supports_no_direct_map(struct kvm *kvm)=
=0A=
+{=0A=
+	return false;=0A=
+}=0A=
+#endif=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
+=0A=
 #ifndef kvm_arch_has_readonly_mem=0A=
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)=0A=
 {=0A=
-- =0A=
2.50.1=0A=
=0A=

