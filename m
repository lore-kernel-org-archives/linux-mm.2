Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C3C6D33990
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A21D26B000E; Fri,  5 Dec 2025 11:58:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D14C6B0011; Fri,  5 Dec 2025 11:58:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 899706B0012; Fri,  5 Dec 2025 11:58:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7382D6B000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:58:32 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3917DB76B8
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:32 +0000 (UTC)
X-FDA: 84186026064.27.1C5A54E
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf26.hostedemail.com (Postfix) with ESMTP id AB1B814001A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=SOFmFbJs;
	spf=pass (imf26.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DAa+s0ltL2AWBGJLNkppOiWQM65ZNjJ1swchhaZKNTI=;
	b=JVMaRQgwvmsqPLBPYK+33jzq0uvC7FmOJ0szYVMsVbvsY980DrujQNey8K8IU3x1tPyU3F
	ehSOPRNqgMgFtgyswki+9JF7nPVxz3jzyFKPb7TsBjzUbjrZx4EaKp9vz3mgTuA4RNJrlF
	DKRShKEnbozoVn41UY4evpTtHcO38Mg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953910; a=rsa-sha256;
	cv=none;
	b=0zC1q9ehqgp/z/8zvuMgId/aPrsT0ue8fczYbujBPmxYICv9O1ZsDdNPm5NUQmUoiYp6kL
	qat6ojqDKyZ/+7Dy8HsBSMkwmK+NWcGjNl3Pys1Ki+NkdATQNeu6EDkjZ+CCj/i0BBuNGM
	ZEN0P71A82WmM2ZilMJ0Dasi1afGU7w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=SOFmFbJs;
	spf=pass (imf26.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953909; x=1796489909;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DAa+s0ltL2AWBGJLNkppOiWQM65ZNjJ1swchhaZKNTI=;
  b=SOFmFbJswrLU7EUW2/iVC+Hap2GAU8bFN8DBJE96tlGKqC9q9fGAP32V
   HvC8dYzQ7GFfpxhRRKrJ3Jx+tn1k9Mh7yNNF1Ppu39yV9hnfu2N18R+8c
   3YFbCUgl5D5lZoMcMgxtBip9x3TPcl5PhGmgNoy2fMBPC/zkBKIrsMYY9
   N/tzxuDXZj4FSLqI/jmUcZ5wTGbJUb0MJInt30CPQv+FAUq+Gxh8fxuni
   7c0RjU2gqr6JlVrGjpWWz/ClXhNF9HXJGP+btH3p32QPi0qaWwcFp+tcz
   3U3+90BnMxRUWzJngsDk0ERbLSmGCWbNMRwg4rxmCnWxJTvYGnQH6MaOf
   g==;
X-CSE-ConnectionGUID: q0GqOJJ7TEuIVrXmD2UySw==
X-CSE-MsgGUID: W7Hjf9rtRji/ZjNjf2UQHw==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6301667"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:58:09 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:3739]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.37.108:2525] with esmtp (Farcaster)
 id 30a38f77-2a8d-47e1-ad78-b78782ea5839; Fri, 5 Dec 2025 16:58:09 +0000 (UTC)
X-Farcaster-Flow-ID: 30a38f77-2a8d-47e1-ad78-b78782ea5839
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:09 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:08 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:58:08 +0000
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
Subject: [PATCH v8 02/13] x86/tlb: export flush_tlb_kernel_range to KVM module
Thread-Topic: [PATCH v8 02/13] x86/tlb: export flush_tlb_kernel_range to KVM
 module
Thread-Index: AQHcZghUt46N9MNDx0Sv0bdQIhD0sg==
Date: Fri, 5 Dec 2025 16:58:08 +0000
Message-ID: <20251205165743.9341-3-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: AB1B814001A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: 4jc99wsjauprz5qd4e7yd9xysjmyncqa
X-HE-Tag: 1764953909-13877
X-HE-Meta: U2FsdGVkX1/I+wQvNyJbTo1qqUoz4rKFjUgkBzh8ilzGf4QebiPwOPUraNZHtTx7iifceXfx6jg8coNuw/bvN/g3xSFeH2mVabtv9WpJQcLBsP08jQ7qbZ/NJJH9l1EsyBtLROOsX0T7Hh3sHSGUOcy67TZAYi+1IOLehchW6tFfK1TIFxDiFysNQ0DFb2JTx5GSf0ZFBArAgs84fglzwZEoVBRSRUZsghZImqUcgJfa9sT8cmdN9a/naWsCS3OU7acmmq+G1DHI3kywq/uITgg4YO9nnjVVXvwJnxYyIyDbMsHgWlSx11TTW5Sf0gz8mYLDlXlVScQvMQrc5DK0lDcRnmxBt93ErrqqENU75EXIw8Wnyn9XYeYcuKu+wm0kuI2RU6kK71yfh+xRvZNAqGQO2u4my6Rhy5fJfRe6IDjhHNGsoKT3acocPfpUt+3KkVY2ncVEtLwSZnNtP6f0pjxOLjNB9mOTVYzGsVYNRmZselDpVsmU+Me01BHFzakvy6B44Qe7ahMgy5joxx2UraDYTTuioBRI3OiYvS91etFblxZ8Ce2mZp12GzLUco3eMAYjqWTp+7mNpk1p6dwAi6UlLuaMSvop+E+ItQUOVZjWK5cuycd78hwMVtmlTT5+3pX153PIwpdVv21tr63ha8eknYSJxQpkzXSWfudnkXW3vbgRHvceNHlTCbGizVcew4sNMpXpg3QYbKjqbxgvUvOtHkEKBWEvG4wtMszwCG3DlXsTWZbNvr3dy02PQIguPcCrNojOi6Jh/ZT0CJJ+cLv3ajj+sc0AdOCaKMgEf1w8ONYzFIB2CosZM/MvJaGlJpz8zQ0+QUpLctOxgIh3YVpWtSXQnXbY3IZSKqbYpAoALPty4U/4/jVI/80nwEgcdq5eV/ZA3F5vEf0V4T84QzlqlP5dx2HvP4zARvtj+YgvKDKl36HcQf3fyQiHpTyxr4sjtuVd0ziSNOYbS80
 FRN8vCqr
 +Q8GrjuDhfh4AnkgALcfqeqUqpiFGZmubPS5jUlIpsKxI94OtgldCf42qzrhbcUwxCZb4oQ7vSz1VZBLUQ8MhRTjr2ICJBR4g9wmtAQXxa9/70PZaFHXWSsEyh6c92O9NsUhg3Ua4lMhz/FgmgOIWYcTWYNt6lfnmnZShYIgF4mNb0//hGH22J9NQPduF2DhbNXRP3vUPx2eedllGIpPc4NegBxL8DhSBVhi1sLuSM+oKJKEo9EDaQyMEtwIN7q0My2mDIIy+YP5NHcZ1gH+ya+gufRTr/CMAXTcKZW/4FH9cdH5lAJu+y1y3FJubuJrJ6SX9ofwtRyg57HggTMBmFW86w7ecYBa0IGd+3vPkjtMMO9rUO0Hwf5mSIS8g36eq2QLpFJN/n32gsIXgN5nWv1tOL4gh5G4WtZ976RArasfaaOJPamj43OCYc7kJJ44VzWE0/AFxtPwCRCK87+n7D0NtpSrcBq1zim51h+k4l1lVN7ZWMr8iZig3aa4E1favhFEs1diiILhS5ac7BEIXO9BxtAJkVPUvy2UGaLdKcK9zLgEHCjk6THmhzgAZHgYJc+iIFlL2tJd2Sgi6YZ+LZm8C4h4bxN3k2DfwVFI2qD0uMHPCHzRc5BRe3ojv15aRUUgIlimJwy26Fz8Nt3686ZLZWOzGiAqVxsEU4zLBe0wjsOz3wm7O5uzlo8DT19boNxlIkLekS7FSU7M+A18ylvK4joFP2aRwDhdzWWcn17VelX9yI1R+LNpUiBVanDIXWC8w+S08ycJ6uqvGyKHe/82AmRaJdq1Idz4M1c8SAkOesAw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
After direct map removal, a TLB flush must be done to ensure that the=0A=
just-unmapped memory cannot be accessed through stale TLB entries.=0A=
=0A=
This export is only needed on x86, as arm64 (the only other architecture=0A=
supporting guest_memfd currently) does not allow building KVM as a=0A=
module.=0A=
=0A=
Cc: Thomas Gleixner <tglx@linutronix.de>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/x86/include/asm/tlbflush.h | 3 ++-=0A=
 arch/x86/mm/tlb.c               | 1 +=0A=
 2 files changed, 3 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/arch/x86/include/asm/tlbflush.h b/arch/x86/include/asm/tlbflus=
h.h=0A=
index 00daedfefc1b..6f57f7eb621b 100644=0A=
--- a/arch/x86/include/asm/tlbflush.h=0A=
+++ b/arch/x86/include/asm/tlbflush.h=0A=
@@ -317,7 +317,6 @@ extern void flush_tlb_all(void);=0A=
 extern void flush_tlb_mm_range(struct mm_struct *mm, unsigned long start,=
=0A=
 				unsigned long end, unsigned int stride_shift,=0A=
 				bool freed_tables);=0A=
-extern void flush_tlb_kernel_range(unsigned long start, unsigned long end)=
;=0A=
 =0A=
 static inline void flush_tlb_page(struct vm_area_struct *vma, unsigned lon=
g a)=0A=
 {=0A=
@@ -483,6 +482,8 @@ static inline void cpu_tlbstate_update_lam(unsigned lon=
g lam, u64 untag_mask)=0A=
 #endif=0A=
 #endif /* !MODULE */=0A=
 =0A=
+extern void flush_tlb_kernel_range(unsigned long start, unsigned long end)=
;=0A=
+=0A=
 static inline void __native_tlb_flush_global(unsigned long cr4)=0A=
 {=0A=
 	native_write_cr4(cr4 ^ X86_CR4_PGE);=0A=
diff --git a/arch/x86/mm/tlb.c b/arch/x86/mm/tlb.c=0A=
index 5d221709353e..cce591d26e4c 100644=0A=
--- a/arch/x86/mm/tlb.c=0A=
+++ b/arch/x86/mm/tlb.c=0A=
@@ -1561,6 +1561,7 @@ void flush_tlb_kernel_range(unsigned long start, unsi=
gned long end)=0A=
 =0A=
 	put_flush_tlb_info();=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(flush_tlb_kernel_range, "kvm");=0A=
 =0A=
 /*=0A=
  * This can be used from process context to figure out what the value of=
=0A=
-- =0A=
2.50.1=0A=
=0A=

