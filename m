Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5DEBFD877B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:12:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 288866B009F; Tue, 17 Mar 2026 10:12:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FDE6B00A1; Tue, 17 Mar 2026 10:12:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 14F036B00A2; Tue, 17 Mar 2026 10:12:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 034EF6B009F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:12:00 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BB9F3B593F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:59 +0000 (UTC)
X-FDA: 84555743958.12.B3E40EF
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf08.hostedemail.com (Postfix) with ESMTP id E44F8160010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=cL1NhbJz;
	spf=pass (imf08.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756717;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y0x5KoVb2XnhSb3FpN6GmZ1KmGrNgU7ZlSRbkqzUa08=;
	b=pRvYY4nO1VALPg7aWYYtt8KqDbOEndjC1zEY7K6DSNByD8DAMMqiZCDJSsX9FtfWxeuilA
	yXcyfepDa1Q/GEBA7+wiawRsOfYHbhIUSYD0GXGkDxfHgd9VL+bgvCbOxkaeV+1zzOM/U+
	6IAogRdfjBKhE69vOXSP7LPrp/Glxm8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756717; a=rsa-sha256;
	cv=none;
	b=rH1FF+JAAqVgRmapNlUOY7zIKH/iL1xH9S6PtMFA8iK67r1lkzWBr+39/7GDhiYwG/tJHA
	3b+HhLvYLcFXBvM2n66j6MZGzMyZE5zTFoMhFi1iIEdBE2V8GTeuUpjT9I7oIc2dkkjO9N
	E1s+epr3pkBdt/zLqu4Lt5v7WzhMZs4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=cL1NhbJz;
	spf=pass (imf08.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756717; x=1805292717;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=y0x5KoVb2XnhSb3FpN6GmZ1KmGrNgU7ZlSRbkqzUa08=;
  b=cL1NhbJziGUwrbRKxXQ3abbl2OQGy+denOhb2+d+wVNA3QDL0OxMZnlr
   0roRdvbUcJyQJa6H5AszIDcVzfyRjDpJAWAj2ICASCDQkap5NVAdI/AKw
   hB6T3VK3Co0JOp89q0H6Hn4ZWidWCd55DBaAnpfd2+8iYBwvXvOLSKbNM
   WaFj98gWieFwW8IgTulEnA7l5ovc7mmyu3n8EHOdl/vAsPyDw4zntCQsI
   Lj436nH3c1lj6xcy0/gl0it4MTDMhjrXO+r+9qxIcfzjpyU+ytVoXeXwF
   E3Uhs5N0s+2+O3lyY6MxIDdonBLElR2Xq8/XACteNBbIVwh649wU/vxX9
   A==;
X-CSE-ConnectionGUID: Dl0HC9MwQMa+Q3LUUQfzuQ==
X-CSE-MsgGUID: DA3VCEsDRPWtBlGsfxdvSQ==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10880459"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:11:55 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:18272]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.15.31:2525] with esmtp (Farcaster)
 id 98ad6bdf-0bd7-47fe-9110-00c11837fc04; Tue, 17 Mar 2026 14:11:54 +0000 (UTC)
X-Farcaster-Flow-ID: 98ad6bdf-0bd7-47fe-9110-00c11837fc04
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:53 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:53 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:11:53 +0000
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
	<kalyazin@amazon.co.uk>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v11 07/16] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Topic: [PATCH v11 07/16] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Index: AQHcthgBZn18ggWzQ06mGEbWQ0oCgg==
Date: Tue, 17 Mar 2026 14:11:53 +0000
Message-ID: <20260317141031.514-8-kalyazin@amazon.com>
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
X-Stat-Signature: ezc4fhiy3u5sittkaow94tfsqjepzh5x
X-Rspam-User: 
X-Rspamd-Queue-Id: E44F8160010
X-Rspamd-Server: rspam12
X-HE-Tag: 1773756716-999430
X-HE-Meta: U2FsdGVkX180oSOMEWjDHCnEq9WGod3Nz1ri5kxqM5i/XDDOHAtu1/CmjBw776U+CovwOfqfXAqf1bS/EZ8hB8AbmB2WoE82tNqYQ7z5vt94yc3oTo3WTwF8CgrZINMHMHKNWUa6Hw/+Xyg5zK1XBpKA8VRGoG30pLGTJbA8TAgA0xbrIG7+nYIPLa455fD09RWoS0nblj0M4LG/0ixFJcdtB08Ypwdwe+LM2p0KcLE3HeYR4GEO3mlD9NkXEfmkl82/k9hplQqqXRsXVq/nE3Mpv/elI7/ywHWk8Jo9/YR4rLBogX2mKZnpWHiDVDDF+nnX99PhPGq5GROKbs47Ib4VO/KnUCD0dSlqZG1s3zp9SwTBfV105kpFBVkdegDAzLqWS0GOnUtGQuGPybdFYbMAaFpFB0ahBzcGO8R6CO0ICPMxTF6fBTlwQB/sL2mWaLsB0acsqhFnf2t5nOV9ZGefnHMdnCTLVA7q/7mfsbuZZsyJZcNH5c+FS/gaf0jwJV5bS/CZZaF9tA4/zf3475OlTbhEqFMVJPv9I3Z3pK1+3dOfUcU3dlV29mVjlOlieVjWOMsDcXM/lKxvdXp1HNEgxDWS84E7MKZ5UuFRdpaDTxKPGApZU5DDCXazVVrQKY5ZFzy9o5k9SVLFJJeAO8GH3gMS7mlQZOwg+iuwtjQxK1c9mpE7XMotuWJVgcOFNt7SfPm0J7ad/k+B7TT/WSd4aEPmN6exIV6FGPnicKp0Zood6qfO6XZl0j7OTMDx0VFyFv3qBJQ5IjLd+YPy3e2/qoIQepCqDLsW9cSiGciNpyTyvdJOuMjD+CcW3M/JrKgBwEDQYbISmRrKNOSH16Nk6Qn9Mmr99cVdLi7VfLAjbzl4e9l4hS5PqELJgS/MnTUIhlsWppIBEZ4RpJc1v0e1n4DAFefNDeyhxuPeJ2pJi+VHeaDTTdENWAm/evVayXZlXHDIO2TuaiGu7bX
 jZWDOUtV
 bGTph27/qjMalVODMePncYXo9yTAIcDq3WTIQvwiC7rjnXKbMI0wm8wUbBPKWbHnniX/ruIRzIbwOehUaujJ22toJ1ONq5Q7Sa9RnWpDA/BwV5l5Rpzdrfrh9d8+lv73GR+SX7nNYmdlpAcnMPRQvt/n7jljzWYsQp+Dq6SMaXMWUOnq/4fvvPTnumbc19d/fBAIOvW9MWl6UdRTdLsuGiJWQTQ8ZJygQ7VBZenDJ7hdqrUMzWu/bKI48ykAekvlKwrq6vhFtaC0KQPll6JVhpKx5u6OMJ4jT8kVp68+I78TWgdLQeZ0xD91ydV52f7D+593el+oTKpMcf5XtXSCX6ixtxtIiNTPKEZqCoG7YZOiW9+Alr/u7Rr9R8BhqEK0LgQvjfuS4NJwasBad9iuC/1fJSIsbsig2MYCe3kzpV23jI4Kn5nU/tDVpbLKU9C9r56/hYNM/p92jTn7N5VR26GavMdZoIOpB4AZMx4wgfzKMcNV1tr7FwGwkl2wyeaxw2htA5HJcqpo1GIQ6nor0SHJSZh8HA7dZL/WwgqotN904iUKCl7sknI+r2Xm7vfQMeop4iWAaGyARRFcrKQH4hBb38TW38qdW9xoq7EnAJSnny/FIwevqrenLUl04rjXaOrjhiWA41+4WvUrYFM2rUGVSnE8yQcWs9HXCHwBJFbFwgf1v/A+RUiNsQ0EL9VkhHbE1xA1rYeJUndWjdLnKeuyp/jbDZ2iPylYMsJUIUNuHaIkGe0blGGLrc1u6gluG0Cowlet0ITCpl44EimAvJ8n6EkcAauKZFXV+b8N8YD5fyTHx4QlIa3UM7cd5crPcJXV9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Add a no-op stub for kvm_arch_gmem_invalidate if=0A=
CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=3Dn. This allows defining=0A=
kvm_gmem_free_folio without ifdef-ery, which allows more cleanly using=0A=
guest_memfd's free_folio callback for non-arch-invalidation related=0A=
code.=0A=
=0A=
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Acked-by: Vlastimil Babka <vbabka@suse.cz>=0A=
Reviewed-by: Ackerley Tng <ackerleytng@google.com>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 include/linux/kvm_host.h | 2 ++=0A=
 virt/kvm/guest_memfd.c   | 4 ----=0A=
 2 files changed, 2 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index 6b76e7a6f4c2..e8aa3d676c31 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -2587,6 +2587,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, vo=
id __user *src, long npages=0A=
 =0A=
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);=0A=
+#else=0A=
+static inline void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end=
) { }=0A=
 #endif=0A=
 =0A=
 #ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index 017d84a7adf3..651649623448 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -522,7 +522,6 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol=0A=
 	return MF_DELAYED;=0A=
 }=0A=
 =0A=
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 static void kvm_gmem_free_folio(struct folio *folio)=0A=
 {=0A=
 	struct page *page =3D folio_page(folio, 0);=0A=
@@ -531,15 +530,12 @@ static void kvm_gmem_free_folio(struct folio *folio)=
=0A=
 =0A=
 	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));=0A=
 }=0A=
-#endif=0A=
 =0A=
 static const struct address_space_operations kvm_gmem_aops =3D {=0A=
 	.dirty_folio =3D noop_dirty_folio,=0A=
 	.migrate_folio	=3D kvm_gmem_migrate_folio,=0A=
 	.error_remove_folio =3D kvm_gmem_error_folio,=0A=
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 	.free_folio =3D kvm_gmem_free_folio,=0A=
-#endif=0A=
 };=0A=
 =0A=
 static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry=
,=0A=
-- =0A=
2.50.1=0A=
=0A=

