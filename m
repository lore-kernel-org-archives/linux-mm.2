Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24587FD877B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 87CF06B00A3; Tue, 17 Mar 2026 10:12:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8540A6B00A5; Tue, 17 Mar 2026 10:12:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 742AA6B00A6; Tue, 17 Mar 2026 10:12:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 629BD6B00A3
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:12:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26831C09BC
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:12:22 +0000 (UTC)
X-FDA: 84555744924.04.6F82715
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf16.hostedemail.com (Postfix) with ESMTP id B87FF180006
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:12:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=OtEYgTyS;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf16.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2c78Mh9z7WDueLSiXQGt7i6WZglrX93MoDY5zuXKFPY=;
	b=8YWhzVYzZpbsuMsA4ocoYueUKMqmHkA0HggB3caT/dZNNiCpC3UbO93Tnx8S2I7IjmvpSI
	assaBJidpwZsQ4NMpPrJWpAfNZdao0zjJMWbtAiHyLc7yvPTwsq4HqpSk3WQTbiVsTpQ9x
	OMyCXMh0ydhk96sMtZYR9MV5b9ELA70=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=OtEYgTyS;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf16.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756740; a=rsa-sha256;
	cv=none;
	b=TaLUJc2aUduuvMUq4YwB5YHmcUGLRf18oZ80kXEzlXUAe5UXgbWe9qFA2Vm4aWrcO/BMN1
	HrsJ0sjEGd0hi13vA2CbM+aoWgLAFYfpMQkVStCuh9oApQXdlrMThHYVXp3aZL50fvjjR3
	NHId6Vg3K9TZx5fqxDvpZZIYTWoochw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756739; x=1805292739;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2c78Mh9z7WDueLSiXQGt7i6WZglrX93MoDY5zuXKFPY=;
  b=OtEYgTyS6YZfhQ+M+BVKc7+b2PFFp/c6Jub63DdO7CGdk8zaJzXH7KiZ
   /SQmvljggnxmnZGq4f6m3OSBdqessDDRAC4ZXny2wj+DndKDxXVxSMCNO
   HFf2YZW6FZ8/BPfFtDw/drK2kCED9JJ2nyXVqzNfH0e6oGFS7FGOCgPta
   jtxC5R+FJB7KjoUQDUiK75uN8u5lS6D4OIUA8Z5+qgJdO227cJoRyfAnR
   c/SeZYLjrc4+O7dhKsoi5whvC5whJNHbKtOY+nLytN8ACbQTlNNwrxZfB
   X69GoqP0rJufILG6cAA5QzRicbvohU/yt68D8PHhsO2sqZn5YpiEXsOF6
   w==;
X-CSE-ConnectionGUID: dQblRH3kTSS8SeOY/jt2uw==
X-CSE-MsgGUID: aa3TGXikT1u2+oO9tXimkg==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10998003"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:12:18 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:3027]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.205:2525] with esmtp (Farcaster)
 id 9ae028c9-faf2-4cea-a353-2d55223a3078; Tue, 17 Mar 2026 14:12:17 +0000 (UTC)
X-Farcaster-Flow-ID: 9ae028c9-faf2-4cea-a353-2d55223a3078
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:12:17 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:12:16 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:12:16 +0000
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
Subject: [PATCH v11 09/16] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v11 09/16] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHcthgPB9NLB7PWNUiZvDNvyT7cZw==
Date: Tue, 17 Mar 2026 14:12:16 +0000
Message-ID: <20260317141031.514-10-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B87FF180006
X-Stat-Signature: op1yobwm3b8b7393u4oefu88co8pp19g
X-Rspam-User: 
X-HE-Tag: 1773756739-650399
X-HE-Meta: U2FsdGVkX1/cn3kB5VyGSIW+OyeGgsPOHEwblVBONkJj72M13l424SQ5Usj7wZWyCtbMX67Z367gPyyvfabeaUvuOZIGVvwGA37lzyGvM4eCUn9mPtcvrC2BMOTMO9d+IW95OglGFFwip1OXOnUz7y9sdjG+lZzPaQWhB/LGgUFUsOZerTKd9fbutg9zR1Z9qFr7/fixNGWsP0onD9ztDk/ddLPE4dW0mbhvrXGNls3eowoopSadFwa3nJjd7YY+oxAItdFmxoXES8+AVGXNe1szOGSaZ8VZdsCJx7oVLvJtosDcD6wx42KMyhvMbTvx50Z+3Ud6Mc1Uz3HF1Cbu7GrbKVlmztrKYnR/Pj2V3UJ1MJNYMfYJJZeX3sLlCOFwBf7QENWk6Rtmmhx5pn7OoIoYy8O3tYdvQj3uCE2o1UxQELaA7YpfvppuBy56l3dBQVTfCePkAXK7KeQ9Pe0bbSfd5rKxXvRlbFS4Ah7fYZ6OEBvsx2cgHgHk3E/Mv7XKBY9qiOTKsni1mAxzVnXXuyqIQ15IqYVEGCnBFQLQq1yEJ2gwPpVcI476KSBHRnYxd5e5Qq+/P7KGs6s4iAheFAWgU78Cr5x/kGZLqsQcvxVdHH/T0iSD4NZwMPEitiGCKpfPlmc84ngwuQpTOCzkL+f1RMuN/tWt8S+ZYpxVQjoVOcGjDHbWiyIcYLHNw+TdJo1MzZF3uektQc2wz7zZPnad26U9pZoUmb0n9VCxk7YyvC8KXcrjPcjTXTlgmK42RH0qF7uRQUTuCb5vMTMX9H4OhACTi8Aquj7YQB5C5q5mI1OKZP2KE1/r6c0/i9dUMfSp7ruMujhhFNAwCGzkHvtOxqco70DckvWnBepk8DHH1XSHpuYJjRZpr6DbwDxJ/fdM4Pr30ZLSzXP5zcvP0f51mJ83R7XpdZB9lqE3msMYLxz7D50onUIB0Hgse/SbOdb972IfFiPf1r+BJIc
 4Z47hMJe
 D2Iw4GSuTLHtv7f02uEgQVpSfP3brS+p0Rb0En1oXaf98eTQVJag5Nfhy9k68Mc23Zs442+gVA1lR9C1ZpxIhxjPlZDTnhy58Cqp71iwck9yPymXyLcpj3gfsN9z97F/py3aulkcTKSwlmTTwe7Fx8PPYEtD/vgDeNpceSutK8MwWEm/22CxnFHFRh5qNai4hNNiBPIjcm1Vx/4O+SToGJm5Ffn43PdOaQJ+zFzopW1YeLJqlMBmrYX9VZ2K9k+DJNlhgh4kBAkwlSO/I55c0j6OlE54xrMBXCr/mBLwxj8Hj8VRmowEyJH85Ba/TcJWc/A4inWWivqchD9lqwCpJkjxhKzYMNoYZ8+HGKhMLdfT+wV4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Support for GUEST_MEMFD_FLAG_NO_DIRECT_MAP on arm64 depends on 1) direct=0A=
map manipulations at 4k granularity being possible, and 2) FEAT_S2FWB.=0A=
=0A=
1) is met whenever the direct map is set up at 4k granularity (e.g. not=0A=
 with huge/gigantic pages) at boottime, as due to ARM's=0A=
break-before-make semantics, breaking huge mappings into 4k mappings in=0A=
the direct map is not possible (BBM would require temporary invalidation=0A=
of the entire huge mapping, even if only a 4k subrange should be zapped,=0A=
which will probably crash the kernel). However, the current default for=0A=
rodata_full is true, which forces a 4k direct map.=0A=
=0A=
2) is required to allow KVM to elide cache coherency operations when=0A=
installing stage 2 page tables, which require the direct map to be=0A=
entry for the newly mapped memory to be present (which it will not be,=0A=
as guest_memfd would have removed direct map entries in=0A=
kvm_gmem_get_pfn()).=0A=
=0A=
Cc: Will Deacon <will@kernel.org>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++=0A=
 1 file changed, 13 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h=0A=
index 70cb9cfd760a..fbdd43e7e94e 100644=0A=
--- a/arch/arm64/include/asm/kvm_host.h=0A=
+++ b/arch/arm64/include/asm/kvm_host.h=0A=
@@ -19,6 +19,7 @@=0A=
 #include <linux/maple_tree.h>=0A=
 #include <linux/percpu.h>=0A=
 #include <linux/psci.h>=0A=
+#include <linux/set_memory.h>=0A=
 #include <asm/arch_gicv3.h>=0A=
 #include <asm/barrier.h>=0A=
 #include <asm/cpufeature.h>=0A=
@@ -1682,6 +1683,18 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg=0A=
 									\=0A=
 		p;							\=0A=
 	})=0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+static inline bool kvm_arch_gmem_supports_no_direct_map(struct kvm *kvm)=
=0A=
+{=0A=
+	/*=0A=
+	 * Without FWB, direct map access is needed in kvm_pgtable_stage2_map(),=
=0A=
+	 * as it calls dcache_clean_inval_poc().=0A=
+	 */=0A=
+	return can_set_direct_map() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);=
=0A=
+}=0A=
+#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_dir=
ect_map=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
+=0A=
 =0A=
 long kvm_get_cap_for_kvm_ioctl(unsigned int ioctl, long *ext);=0A=
 =0A=
-- =0A=
2.50.1=0A=
=0A=

