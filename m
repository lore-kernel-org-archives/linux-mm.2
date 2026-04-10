Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC176F459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D4CA6B00A9; Fri, 10 Apr 2026 11:19:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 285C76B00AC; Fri, 10 Apr 2026 11:19:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 153CD6B00A9; Fri, 10 Apr 2026 11:19:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 012186B00A9
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:19:29 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A4691402CF
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:29 +0000 (UTC)
X-FDA: 84643005258.20.6464FE4
Received: from iad-out-009.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-009.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.198.94.229])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4048640013
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=UIYadv7D;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf11.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.94.229 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834367; a=rsa-sha256;
	cv=none;
	b=4kipWjGpKmlkQ47vDI9KCYdDWfdiewZjOllHMWZMdIwxVU41RFvBp8EHp4S684Ex+qgZIM
	CreOp7Ftt4sr+4jkU2/qX/Y/vw1gFtXYOes/RprPDAWthsgZIvmDww2bfjnQVyoe0G+rMD
	HaOlDQLAutdjc3ilo338ygl0wzbIFRg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=UIYadv7D;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf11.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.94.229 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vLy8Uo7H/yy1MpTCKNu3B0dgocKjoo20PjX7Wqklm/o=;
	b=8JAZX/XKiXxggExSTwWJPHTTRaBfKGnk09ShBhXae5Vx21W6wv2JGWPBMhKgahj6Eju7HN
	t2LLQaPIYPQCBdHQAJUgxVx/AbdqeG7BnbzmKamcaKt1E4duhnstg5QKzesmj9IYBPquTr
	MJmavdjwdA+rw0ADh6i2j//Vdh+PkRU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834367; x=1807370367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=vLy8Uo7H/yy1MpTCKNu3B0dgocKjoo20PjX7Wqklm/o=;
  b=UIYadv7Dr8CN0XX3jsaJ/xofvzrqwod3k9D4GNUiqLG4GuT7ZXZdNud5
   cJDfpNfl60ykBweazbq0vSIdQnvqGFtLHAWjNLJHWBStLRJcwO2P3ZdiV
   y4FLSPp8r9UiUlD//9oiwVizZufFcWG2fxqY4d1wAYTnBOBBTkoGZ2fx9
   50WzostxWXP1TZqwi0rQlF7IiGlNjqJGPXVkAMcC0QHr+zhh9SNQ00hgM
   OFMKBHeEOXxiW6dkKvS1+Xv9Z/1aUJU5L1JxqzeUNz+8wgWvoDeMbPjj8
   IyL9TCAOBYEE7aFUYeSCmyHKLn3bVJxVZVB0x9PV5hSy389SJeaKeWMSK
   g==;
X-CSE-ConnectionGUID: /gJawKxvRtuwf19Z3qd7/g==
X-CSE-MsgGUID: DRWm/oHcTk6GTV9npce06w==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15898148"
Received: from ip-10-4-10-75.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.10.75])
  by internal-iad-out-009.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:19:25 +0000
Received: from EX19MTAUEC002.ant.amazon.com [72.21.196.66:19527]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.29.254:2525] with esmtp (Farcaster)
 id b9c5cfe8-25a6-4ec1-9c9f-bb40ee7f6229; Fri, 10 Apr 2026 15:19:25 +0000 (UTC)
X-Farcaster-Flow-ID: b9c5cfe8-25a6-4ec1-9c9f-bb40ee7f6229
Received: from EX19D027UEC001.ant.amazon.com (10.252.137.156) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:25 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC001.ant.amazon.com (10.252.137.156) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:24 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:19:24 +0000
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
Subject: [PATCH v12 09/16] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v12 09/16] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHcyP1pqKPFicKVfkONXJiuCe9SiA==
Date: Fri, 10 Apr 2026 15:19:24 +0000
Message-ID: <20260410151746.61150-10-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: 4048640013
X-Stat-Signature: 6q7m14xfr1hd9m4xsb973sutgyt1rs39
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775834367-802668
X-HE-Meta: U2FsdGVkX18bDtWXBLUy+F/mvT9+76zri/vgYfKuq6wbz3XKsGWxXPeyzMtVY+4Hp259M/v8Q5mPjcNdA9TZtSmZpwLZObzSe+yu5Yb5NZN6oB1kCJ1K7qy2Dn4gwjEZWp+C0ZovDRzq/GLm0dM+Wzh2AK6nqglA+dsd/YwrCrcEbMDeVd0ARUs3MEfn1QGdiKiKRPlMXPVDvM1fSB8n1FulEtZKkVkEzi/0AybXtpJnPVckbZ9DHikRCi3SiYcd+3m4IO7hS769+6WSC6jz9mjKzRbV744b2n2ennfWpmVHc02Qf2pJomrKdBvUUSyxsOo999ZCgbOIj3/ASqi0ldkIklRhsi/CcGS7xZwsWQxUv5UKqZSus5EP7njc/ZCCuYuRo2EiBGayY3SQ09ZhZVW03hjPkjlhKQquIPgo8hV/nDCn4Dq+RPwuTFNKY8UgzV/C1j6F8aUAaFliUG0HtmohDC1cp+xEMOO4oM5vgRMLlCgxtFEyNNcmd8jFT3n0MLsySd3B0FLHHwm97+CPcSLsQxviSjxJYIybZfBPPmNjeBKpLLSxIEp7NXJlo3W4SYKLT9F/aK0vaEuFzuV346NuGW8C8iUk77GXcG6hzNr2g1O342+yoG247yrMFIjCRJxqIDV9Kbblz+WJtUcGRbQjebJ9zI2oQnQyuuK3xewspeutPEGGrGF6Kc8ppOcfdlqWBdwnbxsMbUp+QO/CNrUkOfgIbN5WKO0rhFtg+91LYzcqOpq/sUwlyXczi3QqW0M1uRsQGAxgyYCYjXUegp8knaQfd840NCJA4vXxzZTJP6k9ZzuspEAXfPM5idP9upYzqVHItbzjmo+dJHlGD2QF0qZ+UceVBwj2C5ZSSPTfkU6N43OZZg2Rtmao8HyPm16gm7TXpUBnGKAn+cTJRG8rpItIEP7Yq/lglVB5PN0qKY5UVy4uDmghbzPF2GUZ/Zk8Y3JqMZX3UHfkAHv
 W6ioK5wM
 5HN0OBxSyQwmsm2cZvC7skLPndpZM0iYC95MwRGBFFyyeSCg5bq/tAWTWnwPRAd6sHlyulRhv0uC0VEg+z16hiUffmhzfU8Ul6wnzrVI5AYBqq0MZlgrXUATg6ekCmC3f/Qpfym005BZnZ/x6hqOmpC62IhGMicMvXtFqZjkxD+VQdXyWuYKLKmKbVJF1flYVfIuM/K4aaMGXY7p116ZzkS9eVyJENIP5O5ssSzumC0W7VSwHOfdYBVFJOeQ0n1QL3CYtpeHShWbgcTvNfrT9Tj5sPh8P+Kga1PwZwuMuSMYeBw0UQbYj7+kXovXXY4JL2Jd3EQmATJzzntAGAkGX9jJhq0/ZvfrHnX9Gfz2hIsyzFAu/JFxAUNr0681OD0P+20+Xmizeq2Zfhmks5sOgJlixpURUJAYPPtWBkhZP00isZcMua/W7STD/WxKHfbWAnQVIprwQZyEIrY64nehDIKXpIVDxJdJ9dRYJ2dE7cAkVr5zRqZrcdwDbmp/QxdrmBy+X2aDmUaK0VoPu6cisfuurP9RhEFWiYaWF+SlVwfIqdeDJs56CC/H4WqNPlQ4FYy9IDaVtMw6N+9OubAiCCCnSIjVQCeNm/3SOWjWqJu4vdrGgQXTRL+RA3vbJKDzhtTCP54WMSRChkvd9MjoAcsrRX1Z+Tq+/vmtt2/s+3uPyIMFrpYzAYOR1Inrj1p0/Qtnsi0qroz38e46xhSIMvrliq8GKB/2VFqd8wtl1O1jhc87I9ikStFfTZ39ahol4/um3JKBVKHPrj9A=
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
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
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

