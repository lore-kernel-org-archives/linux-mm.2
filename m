Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7820D33994
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 037CA6B0023; Fri,  5 Dec 2025 11:59:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03616B0024; Fri,  5 Dec 2025 11:59:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DCB596B0027; Fri,  5 Dec 2025 11:59:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C3A056B0023
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:59:11 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 81A95578B7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:11 +0000 (UTC)
X-FDA: 84186027702.16.C05D4E5
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf09.hostedemail.com (Postfix) with ESMTP id 2D11E14000C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=o8EclOTp;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=W7GJfZU7LO05jHXKZKMobVu/d9jql0a0jk/2tfUdHpg=;
	b=0uCkOPUaz0AUX3qEPb1DLjBhBtVPEHAluwB2N/bF3l/f4CKsrTqvOo3IGlTy1yPnkRs2a1
	F0BcdbhgapVhI5WpFm3XBBgmFY1dQAqcZPHcmFu+73diOW3KL4cpXb8uhYkDVGHZJZCqLR
	ieSlCA4xRO50pVllB7rE4wyw1eyslKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953949; a=rsa-sha256;
	cv=none;
	b=ZZXFVAGNTZyYry0za8DT2Jxt0v5FR78uUDzy44QEqVUn/zodhcXBGB4oGgZgQSgKjIIKjC
	GBryBl8Xma8AdBUTkPw/X0k78Ruy/JxcF+y7lDUZpuHfIjBhkNHNST/5KrUhqSm76qrU6x
	7FDyN1XejTU9Dve5g1fPAV8V5EYVHPs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=o8EclOTp;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953949; x=1796489949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=W7GJfZU7LO05jHXKZKMobVu/d9jql0a0jk/2tfUdHpg=;
  b=o8EclOTpVDCqlD9Q519oqmgj1I49olU1p6CUadz7bVlap4olXOsjE7Rk
   VrZlDdNuzccY9DkbmjYwHORVv1ilmmHBH2l1egjPR9gwTgEsqVPKHl4uw
   k5gg4nJleyhxyFz3kjxqUmfR+/AnAEEoh8HAvZkSDN4h+Z6VBT9d6EU9D
   efrlXzfPsDd3EX3sf7NkwoFzdMP1U2dGMgwCKQdkLnSwuIxbttWPRW872
   h7vtcdAQU7gvdYBJ+Efc/bHXnKz1QQYIYPwn0bIm85qmLHemtYIdkBbTJ
   A/TYCvGlj0EY6t4yfNsO21CoTFegO5/cLy8BKjJ7RUuidCFLm2Z9LXD+z
   A==;
X-CSE-ConnectionGUID: UrLe81L+QuOcbGqQwPNB0A==
X-CSE-MsgGUID: 9doc33xfT2uUuc+3NSn9iA==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6196628"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:59:07 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:25054]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.40:2525] with esmtp (Farcaster)
 id 207ea9c1-766b-47ab-853b-ca8cb9de4fa5; Fri, 5 Dec 2025 16:59:07 +0000 (UTC)
X-Farcaster-Flow-ID: 207ea9c1-766b-47ab-853b-ca8cb9de4fa5
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:07 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:06 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:59:06 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oupton@kernel.org"
	<oupton@kernel.org>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "seanjc@google.com" <seanjc@google.com>,
	"tglx@linutronix.de" <tglx@linutronix.de>, "mingo@redhat.com"
	<mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
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
	"riel@surriel.com" <riel@surriel.com>, "baohua@kernel.org"
	<baohua@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "isaku.yamahata@intel.com"
	<isaku.yamahata@intel.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>
Subject: [PATCH v8 07/13] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v8 07/13] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHcZgh3WLdsPS6cE06bWor8xc18DA==
Date: Fri, 5 Dec 2025 16:59:06 +0000
Message-ID: <20251205165743.9341-8-kalyazin@amazon.com>
References: <20251205165743.9341-1-kalyazin@amazon.com>
In-Reply-To: <20251205165743.9341-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2D11E14000C
X-Stat-Signature: w4n8tp1td5tw6tngefeezzegy4irzj19
X-Rspam-User: 
X-HE-Tag: 1764953948-496163
X-HE-Meta: U2FsdGVkX18+ifd6LWw7udBNcOcfDhAnbjAlK/36Bmdvfa0AnDO0kd57BomamSnRjiEXvqRD5Ibtbn0x6kDLqv18e6hKw0T9rJA/ya0UUdybclU+fUV42R+550Go5RXnr529qHjenX4Ki0lS9XYvE+1rtzMMCA6pUcH/4ciApT4ruvxEIBSP/WsHeqZYclKhIQ3W8zrDI2ONh2pmr2ncpGfwtpeMuYmjIpMgHcP7ruGdOxYe4AETOkiKROG4+ys3AL0RUsN+X8Fax//028MmW4d3u05/P4wd0aVYI70lh0pxcRvScqEU6CWNRF36pGJvZjXtH57AkMMGPss09VPpHABPV3Q1Ds5rVrN9H/QzBkF6cNqfYFo20aWySLUqW4kbRAC30jMX+1/XsJacz0iPQdxhGkcgHSEw+LKtvppTTFQqh0+gol9+Cf3jiISRlhUjD57fIss77HiVxarY0T8Him3GlhbSx4U4X1vlOfBpu/U5CLsM+l7TYSePF5ssnUMrd+/V9PjD+DJmdupzPZt39zpJQfUrVCCHnMffT1DTY4Qoz78N5p12WCh0EMM5m+GERZ4I0EU35BQaRT/5f6yBJa0EsxvQzPwxiFHZcDFUvHP1lRmR+6lB/fWti8UB7m9o2DlQueClRwZo0tVEedPysq0BSbn644YYeaBMW55vH4dvoyRg9gAVy3R2bDwU7Wm4YAYf3fZO441y8+3NUdI/y3U07vzmiOH6+DUdR0jVV6JRhQu4NEe1tx3fTRjTDA4mRvH4uAVQi9gTLeGcLpBE867Jih/qoNuz3TXfeztfISmPgKF52o1WD9VDWimaPOaz4M5mPwSOyJas4JelftqkWJ9ooPG+b+Jt0LjyYt/5ZNbdet5e8gLTAKpmgsA2KGn9E8qb36Y2afBe5URIkKi5e13ylr6rK27Xkm9OZifaX6UOVgjvhABFokqWQz0Dm5bMmlIRjCuoOAQhxnGRXIZ
 8dVEd1Gw
 v6aeW6ImYdGU51rypWQdMsUCIpNabZn/r0iLQqoYqf8vIVyfbHFRggqY+svpX2yzW6tVq3VbLCDhIMRroH4AdbiWYEzVCuZz5GJnJQ67gxIDbwfosOm+GUWU/3nXg/TOkzm8lelP3B8ZR4Yyew40XB+uiuhERaSYLRj0SrJdK904Z2NCdef+gTWkbS/dwsXCvKSndvxc2ApvHKd9swVB+azihArcBX6G+Yq36HJaOw99+Le9GTGzegRuAdq87ifKkK5CHRorE3MYzHUIExVNqZtwCqoCMOgYPSnKBDbNESDk4UhFURnLXZwXBHziOOY9zXC5xKuVIgPYDbDTld1jE7su0d325tszd2moCLU5e4i4M9cA=
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
which will probably crash the kernel). However, current defconfigs=0A=
select for example CONFIG_RO_DATA_FULL_DEFAULT_ENABLED, which forces a 4k=
=0A=
direct map.=0A=
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

