Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89770D19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:53:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 009586B00A0; Mon, 26 Jan 2026 11:53:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8AC6B00A3; Mon, 26 Jan 2026 11:53:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9386B00A0; Mon, 26 Jan 2026 11:53:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C7ABC6B00A0
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:53:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 738795B07F
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:53:51 +0000 (UTC)
X-FDA: 84374711862.18.6E47585
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf21.hostedemail.com (Postfix) with ESMTP id F2F691C0011
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:53:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="l/FWrpfE";
	spf=pass (imf21.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUXffJ10pcwposVmC9vM2kcbCnj2+0WuRal0d/tv1pE=;
	b=fxgjKnh4scbluKW2VBEvwPqh2MyMtTikykVr8IzhKVjzNbbsMkzd1g2CpFcI+U0+X1WWgX
	Dxh8o3Cm19cOypPDipEHZYGDYP54QCJf/Mwu7nTJmL5zBUIr9BdnXcI+8cRPvcThvyYrLl
	VjyZpLwRWU4gUq9bj09IZtr7gPceBzk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="l/FWrpfE";
	spf=pass (imf21.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446428; a=rsa-sha256;
	cv=none;
	b=3fJokO/e2FyLC+c8aXL8Vjf6wAP6jWNfe07qAD+KWsWffKI3uXXR52dGyUwF1k26XP/rVp
	GNXCMBvCJ5ABAteTP9/id/uaO39V92ThZTSdeVsgwm+EL5ZjwV8Nsu5alq+05TvKTq1Zih
	1r2wTNnIyN/jKDcY3pzKUZ6FoEetSNs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446428; x=1800982428;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sUXffJ10pcwposVmC9vM2kcbCnj2+0WuRal0d/tv1pE=;
  b=l/FWrpfERJLEfuLePRdYKKmiCL0HGT87uJfBucms2yY9GVJ3uaotH/xG
   CSf/y+P9C+zXQTFlWyl1M+vlZem+oVcVWOG8NDk35X2SuNXBDp3cKDOMw
   BuzHs/CZLkHEMnXBgtzJEbwg02cloDsQ5csMEsSjsHvXnx/BggrIK4nyd
   tyTL8BllSzYTavpoK96CqOWKaiHSHKabB08uH0J5hx66iPZXtEY6XC2tT
   +Nf41BhwKu544JvUFniuQT5JyyJ77MOugSwfU8iz6AY5dKLxIRchvI2RC
   VB3608IGW7Vs6jVgC0W1oEVUCeckwFgREPYVPWuQC/Cjpn/XE+uoy1hy0
   g==;
X-CSE-ConnectionGUID: 2MO852eqTuG8D6xQEfIyyA==
X-CSE-MsgGUID: r4PoUa0vSOeBGqbiWfWq9A==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8451600"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:53:46 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:20340]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.26.95:2525] with esmtp (Farcaster)
 id 7c5d4f7f-b341-4f66-a5c9-35691d57cbfa; Mon, 26 Jan 2026 16:53:46 +0000 (UTC)
X-Farcaster-Flow-ID: 7c5d4f7f-b341-4f66-a5c9-35691d57cbfa
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:53:41 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:53:41 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:53:41 +0000
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
Subject: [PATCH v10 15/15] KVM: selftests: Test guest execution from direct
 map removed gmem
Thread-Topic: [PATCH v10 15/15] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHcjuRTcCA/ThXLV0KKWvmgpRrsIQ==
Date: Mon, 26 Jan 2026 16:53:41 +0000
Message-ID: <20260126164445.11867-16-kalyazin@amazon.com>
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
X-Stat-Signature: 3f168cucc9o4tkkkgpwzgm175cemjhy9
X-Rspamd-Queue-Id: F2F691C0011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769446427-6705
X-HE-Meta: U2FsdGVkX1+xq7/T3MJy4UGaf0hhH5A3E+ve5kdqjXlyeCsez72XQnLT48m3SA8eG3H4JbZdjwY+fpJin7RwbWRFGZeYeCh48SVgAqhMvKaqbjaVK7YLKmpjdInsKwvZ1U3zu0xZb9dVYpxGgjIx2FyilgFqSVzlzU3ur6wjNtDFUtjfvCJWUFZekqGF2kAMKaAplVDJp+GtzM63oYuNnEGPWG+hdH/rWeU7rPlmGmwNmiaVtjGWwKUr5fCZLzT7BziMi9WAbndJjWvLQcEVu1w5ah9qGWNgjLUGs1hiVlpykx9b3lSYCkzpKh2EaoFzFlik6j13lH+bIcOMTEDEr6Y3adHgorNAAQ+tKRUdwTXd8nt7GDi62Zym2iel7ZHeOTqZPrr+JkJ/Qh2Hb8InEdva2vtuC7n+daUwN55Up+9z4hzL77O8zoR6jY0Gxc9+L6rz+KJaEfg1EmdeaMmZp+jW50/rtJ/haQOn5Vv5PoAcINuYLrbexGu/C5oJlen+7UmIlyXw3FpobqBEMje6wZIZa8JEdAbK8Apsc7OPsNqYsUWaK037jY+x7io20F7vlSBmhj9PP39J79sMrmisBnYJF0V4Wm3L0LNVaWU/iipLn2oprcZ5LOwaBdTALyV6qsEP4ionBzbhye5CQ0+XW/dMyX6WNM4GaOuu69rhmBsiysaiDCLLhJu4VehL4zFN+KvOsJdhtK2EIXrpznRebG6KIPZjauOAF2K50rD2An+GbMsehLpODPngJljcQOQRqfpBSTd/hym7YPwS9imTQ/vyhYJB5CDgYHT5C25ySZJ/9+9kjQ+ttyK++jk8EtXPw5kHkjLrM2lcj3kWsfp5qHqv69qh3d1uJYkl+yAenYxI9kkNN5V0tNk1ebNwCrcAHq89b0P1xHfvPm0ghLa855SsMaQ0b5p3JI4rtuULLhiPCGvDvELPUsWaItGfrebPvIya9phngQmrxOi7sKC
 wm+klGsU
 e3jlIfGBjO91MF+w8j7RiBdS/Qx/f+dnwVo/7fIwHBTqyS3XkuQuzZQTlqMcBIj7dBa+Tb20mZvW4ORQ6Cbdu3FO5IFlpNFubOWRC54BCbjY1U+1jNMCkWX13K5NFsim3dj0OhqKgs2DBRl/VYN5OIMTAceULvidwTTxU43igqOgP7g3+jtB5aiaKeexlnNUF3C1UNwoc5eN66NfwUyqZk7qc31KcMJlB41r9a4Nq+X5XwsiNWa7HN1hmKSfMzDaAZHWutkBUvx+EvN8x8Qlp/77sDO4SXsjEL7DgqREAR/AHTBLrTXxQk8fHNfEk7WLrtEVJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Add a selftest that loads itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) and triggers an MMIO exit when executed. This=0A=
exercises x86 MMIO emulation code inside KVM for guest_memfd-backed=0A=
memslots where the guest_memfd folios are direct map removed.=0A=
Particularly, it validates that x86 MMIO emulation code (guest page=0A=
table walks + instruction fetch) correctly accesses gmem through the VMA=0A=
that's been reflected into the memslot's userspace_addr field (instead=0A=
of trying to do direct map accesses).=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 .../selftests/kvm/set_memory_region_test.c    | 52 +++++++++++++++++--=0A=
 1 file changed, 48 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/t=
esting/selftests/kvm/set_memory_region_test.c=0A=
index 7fe427ff9b38..6c57fb036b20 100644=0A=
--- a/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
@@ -602,6 +602,41 @@ static void test_mmio_during_vectoring(void)=0A=
 =0A=
 	kvm_vm_free(vm);=0A=
 }=0A=
+=0A=
+static void guest_code_trigger_mmio(void)=0A=
+{=0A=
+	/*=0A=
+	 * Read some GPA that is not backed by a memslot. KVM consider this=0A=
+	 * as MMIO and tell userspace to emulate the read.=0A=
+	 */=0A=
+	READ_ONCE(*((uint64_t *)MEM_REGION_GPA));=0A=
+=0A=
+	GUEST_DONE();=0A=
+}=0A=
+=0A=
+static void test_guest_memfd_mmio(void)=0A=
+{=0A=
+	struct kvm_vm *vm;=0A=
+	struct kvm_vcpu *vcpu;=0A=
+	struct vm_shape shape =3D {=0A=
+		.mode =3D VM_MODE_DEFAULT,=0A=
+		.src_type =3D VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,=0A=
+	};=0A=
+	pthread_t vcpu_thread;=0A=
+=0A=
+	pr_info("Testing MMIO emulation for instructions in gmem\n");=0A=
+=0A=
+	vm =3D __vm_create_shape_with_one_vcpu(shape, &vcpu, 0, guest_code_trigge=
r_mmio);=0A=
+=0A=
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 1);=0A=
+=0A=
+	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);=0A=
+=0A=
+	/* If the MMIO read was successfully emulated, the vcpu thread will exit =
*/=0A=
+	pthread_join(vcpu_thread, NULL);=0A=
+=0A=
+	kvm_vm_free(vm);=0A=
+}=0A=
 #endif=0A=
 =0A=
 int main(int argc, char *argv[])=0A=
@@ -625,10 +660,19 @@ int main(int argc, char *argv[])=0A=
 	test_add_max_memory_regions();=0A=
 =0A=
 #ifdef __x86_64__=0A=
-	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD) &&=0A=
-	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {=
=0A=
-		test_add_private_memory_region();=0A=
-		test_add_overlapping_private_memory_regions();=0A=
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD)) {=0A=
+		uint64_t valid_flags =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS);=0A=
+=0A=
+		if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM)) {=0A=
+			test_add_private_memory_region();=0A=
+			test_add_overlapping_private_memory_regions();=0A=
+		}=0A=
+=0A=
+		if ((valid_flags & GUEST_MEMFD_FLAG_MMAP)=0A=
+			&& (valid_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))=0A=
+			test_guest_memfd_mmio();=0A=
+		else=0A=
+			pr_info("Skipping tests requiring GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_F=
LAG_NO_DIRECT_MAP");=0A=
 	} else {=0A=
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");=0A=
 	}=0A=
-- =0A=
2.50.1=0A=
=0A=

