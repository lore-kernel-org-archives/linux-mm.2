Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E21DAD19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:50:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A476B0093; Mon, 26 Jan 2026 11:50:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D17F6B0099; Mon, 26 Jan 2026 11:50:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9BE6B009D; Mon, 26 Jan 2026 11:50:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A9276B0093
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:50:31 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C78E5D3167
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:50:30 +0000 (UTC)
X-FDA: 84374703420.14.E82CF14
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2F90140009
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:50:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="Ve1Cb//j";
	spf=pass (imf11.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+0YCRdTDnWSs97jpjMZOSlIedfR2zbQnGU/yn7jp+s=;
	b=qzcvXQOMWZR1G8RpPPNW5oTARYkjWuqUIHUgQqg5rLIIShyHi1RSwYXEsvIpuFlBoIIFRK
	u2i1nC0RTh12SPxwZHFEhwkBk0uYYtQrjck0EqwisPFy6gKvaZzN3o5D7V5AkXTmNOrdX8
	x91mh/SKSU7OLIfp+FWRvE7SDj4qqG0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="Ve1Cb//j";
	spf=pass (imf11.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446228; a=rsa-sha256;
	cv=none;
	b=Ij5CsfVAopM/P8JitJZ4gi3dBr0gWkS+kbg843qJpi8HvGRch7hDClrhcD52Br18PtEXqa
	QoYzdQS5OM2JQ5XMc0VPEkX7RRLRMimk6qkm4z9phQcwruUrZ3gN28Vavr89usiOkEDQS5
	daCAYcCbe8a8tN7/0dRyUIerPPETXRI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446228; x=1800982228;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z+0YCRdTDnWSs97jpjMZOSlIedfR2zbQnGU/yn7jp+s=;
  b=Ve1Cb//jLIyrIAmNQNE1rGNo9cvkS6PsNqcrJgMh36OJ8cTghDVhxm3H
   Q+3RcBK9wrFemhjw3oLnXpOWg+rW6esG1u39BjxeO1RNM0ASytfCQqkT9
   s15slnBnghozynKNRC1yGUyxYAslSYlCW8IszYJIQIlyUiw4OptjY4Dpa
   4fPmvceNyHEUQewwA8l5s5L+UPn5heOkcD7AFnvIPRWTJuEzglJgomYCb
   E5AQ4uV3SzI5FDVJziW08bn+kgGCb+btirP8sYAXLdGQhV/Gw5/gdKDlJ
   u9TbPV1JfU9I3IOs4/bWl81N8mGyEJiFilFTF5dnpTpQ8sKfREi/3rXJb
   g==;
X-CSE-ConnectionGUID: u2oaZC4NS1OsnhY1SRBC7A==
X-CSE-MsgGUID: Pxs/ngYXSYK56Rj63xFgrw==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8462653"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:50:21 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:11258]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.13.191:2525] with esmtp (Farcaster)
 id 0c98ffad-9331-4293-9e93-229526262b2a; Mon, 26 Jan 2026 16:50:21 +0000 (UTC)
X-Farcaster-Flow-ID: 0c98ffad-9331-4293-9e93-229526262b2a
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:21 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:20 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:50:20 +0000
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
Subject: [PATCH v10 08/15] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v10 08/15] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHcjuPbS80kQwcCmUC50XT6X/2MWg==
Date: Mon, 26 Jan 2026 16:50:20 +0000
Message-ID: <20260126164445.11867-9-kalyazin@amazon.com>
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
X-Stat-Signature: 1i47mu8q8ejmkounbsabnuj1zf5n7oyk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2F90140009
X-HE-Tag: 1769446227-743946
X-HE-Meta: U2FsdGVkX1+ZijeFpneLcdSMCCgGtJX5AwkRIxPI9q5TUUyxMnWUQ1I0JHAb687ZiyCMjWRIPa6Xzm5EUccMhDvn5ZedV1aobBobPHWpsmNV3rQ+Z/beZc+ZJJTd9H2YEXpPPsaaJLsTULOCCf5WwhwzlHYW2KFnjawBmy6kEHhL5FDZEcGBLK4rDeOBJ2pg3TRb2N3ot2+oWEgDrmB+pwN1qkDiDG9F2mhJjoxpvrbmqGW4vwqTREED0t8O6f92pBjvh9Y+g6dmo2Y69/ievrVIeee5VFg1PJsOY5slNJwTx4hhAnsD3iVeDE9yO8JUssqkqJVPHBzUwH/fxxdJdYZPFhfD4LNohbz9kMPvWFkJkvFqqqj4jduryZnHitmkAHtrFBkKb9CbCYCOGl6oijc0DZYNiVXq7t9ASVLc6Zm3AzEoqcyW4qm65M82rVRkgMkNdbH90reKDN6SO1+FWDkVuxEAeO2NOb6wxBhPfHlO9lILxQXYw64VJjsgEz2njYGkqjl6hiBW29RC8DQeGty2D350Lw/s8ux9sHdB6e2qVO75eE9v1mGrVpBWrT8K0fxwe0fQWRCBlT1Lp4t6akW72SHiTgCJXuS5yF6HDwxpIgo1FpM6Rr2O9eII8gm7V2icP3l7Yv6y25OzjZu5k1C4HR3oSyzfP4zUsafLRckI1nDFRecI/cnjOWL0gszPfjBDsPnQMDsaN/z3wlS3lzoV/nGh3F5X85r46lr1utn3PGU8FS6iPzfq7RXl3bcut3/Gr7sODcOSVZB5TrBh8Goi0oV0zW577RZyUbbh2whW+nI7Z2T7JPFZFke/Ev16JCspMlS5Vhq0exUI5nq3hQtBpKJH14ddese9yMTvnKn7vUAnS5SFNgP4JtmGeJPOqO2yBidH6vQJOLuEkaRmsZSh+ZAUQ+s+11zyd/2Z+fb4JQtwYysL7keDwuevpGyGz5e2hrkcHjjKlS3FHix
 SshLiWBq
 gLAgDZ2qWx63xzlZZhMVa4K6yLpo4gdindnGdiYi5R3LpWfRCnOJXx4utvwaZprN8groN57nq7VpsfSx1PGm5KEC9xjEJqxUv4DgsDC1rz24E59Pq40GZodTK4MkkKW80+wnIYVb+aT3ULj6RyYKfFvcM77ynSSH6kkj5WNVp1YEPZgCdPgPUcPBwD80m9CLiY25l7ADxUMYmhPwQPwk9TZYskID8qLhYQypFdyr1YI7yl2g4JkPYSbuTB+flPZ6ZMd7PtheXF8sVD4jwVa3ChZ3mPV/vQq2oBL/bsbub/UipGINdov8BFKwevXu/mK8je9T+WSDh2HVzs/vc3/U1bjGsra/0fSyVfT4nnrQtfdoX+X2OFbCqkGVVHdkmNGa2lvs6zPO8xtoBmi89yhZn1vXyeinscLG4MnhE3FQOX0uNhuoyiTJ96orheVc+oVaFuwAqld8HAis0G21w8OB+EMjF4o6by6GuLxVW25W02d09g9BQpAfh5iBGc1thHS93JN+4mdndcWfq3D3NaSswa8cc9XBtbTJk9jVDvN7dIfdXFx1ihDt/xdrG3Fk4Qdtwr5jPD5a+2RBzBDN9p2yr2CAgu6VO3NQQ8iA1A5Af9XPpnmAMVkQx5YrA54TFUWr7X4yiwv6M0LyG68zOx3WO3b3E8fdEm1IORlrkZ5qd/mgnE/tnyN3zES2xnFGrcIECijfwsqsw4DwD/S0dQsQUXxEGkcs3czTu4jJUcYb1FQd9HkDr9k8g004UQncmKVFZ7jl5/7RTiRBfCW3SuN1SpEPFlplt8xXpghtKEg20F2cVSko=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++=0A=
 1 file changed, 13 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h=0A=
index ac7f970c7883..d431ca7d4fc9 100644=0A=
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
@@ -1654,5 +1655,17 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg=0A=
 									\=0A=
 		p;							\=0A=
 	})=0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+static inline bool kvm_arch_gmem_supports_no_direct_map(void)=0A=
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
 #endif /* __ARM64_KVM_HOST_H__ */=0A=
-- =0A=
2.50.1=0A=
=0A=

