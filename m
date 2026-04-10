Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01641F459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 656F96B00A5; Fri, 10 Apr 2026 11:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E496B00A7; Fri, 10 Apr 2026 11:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5FC6B00A8; Fri, 10 Apr 2026 11:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3A9506B00A5
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:19:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00C7C140340
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:09 +0000 (UTC)
X-FDA: 84643004460.04.E7F0006
Received: from iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.198.218.121])
	by imf29.hostedemail.com (Postfix) with ESMTP id D7CD912000F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:19:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=i1wg0ptF;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf29.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.218.121 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834347; a=rsa-sha256;
	cv=none;
	b=kbDOFCTJNUQEduAni++/wCLUj2//nBoEvZY9rqf1l7bxHp/Ukwamnl8qc42PL9Md7ByOdd
	YpGlPc84jp0D3ev1cytx1dE4VubI80BNpBZQBUBh5ED/vZUHyorcZVFJX6bDdCuE/j2cv6
	AUVVnDfzMVbBzXf5QUzE5rZ3nbYzQ7E=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=i1wg0ptF;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf29.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.218.121 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ad2/8Xs1KJ387StiAXeHCQllqb1BIfUe92knKJwThxc=;
	b=RbIOxRqtpbs8J0cd9Zm1hc7Et/Xsrb2HAAS+AHz9gK5Ns9nMkg93FuwBanQOLM7qfjrYkM
	otvnb8tBohXWYcR08E+2oPxduXAPBeTcg6WOUbhAv73azGeVmopZdqtlYcCiv+bDRK1OwE
	FYM8HvbPD44c5FILpQOQHToLIDTI1lk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834347; x=1807370347;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ad2/8Xs1KJ387StiAXeHCQllqb1BIfUe92knKJwThxc=;
  b=i1wg0ptFwpnabZsXze8iK8AKBGW+0c514OSMGVEOmxwIG/UHWc6hM4ef
   l627LCWWWIoIxrmLO7MhWdTguRTE8uEAuHCtX+DPwn8EmXHrsuAW4Hf7c
   mpnj4K7qBLZ5wwxBj/v3SCHhH+t0C3/6YYtCw6Femiy7QtYpA9drqmaaM
   tYhvsX4+EfBh+oUZLxTQ5c4LqwF3IlrhF2wHo99/lnxrfd2bq+xMNMa6w
   d7l/icpXziNqI2gqi7iy4EezCwg0OmM7xtct4LZIoN3mnqq762/9ch9Ue
   3dVQMf7h/P0oD4DdJeA4hyYYhKknCcEh2tKVGSJpxEwKIFyPAe6thFg/R
   g==;
X-CSE-ConnectionGUID: I/19sXPASriJWeV5I8YRwg==
X-CSE-MsgGUID: eiDY6iBTQ5WKRe3wTfoRSA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15428618"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:19:06 +0000
Received: from EX19MTAUEA001.ant.amazon.com [72.21.196.67:3109]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.62.178:2525] with esmtp (Farcaster)
 id e2c7b72b-ac09-4431-91ba-569d63e54e7d; Fri, 10 Apr 2026 15:19:06 +0000 (UTC)
X-Farcaster-Flow-ID: e2c7b72b-ac09-4431-91ba-569d63e54e7d
Received: from EX19D027UEC004.ant.amazon.com (10.252.137.178) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:03 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC004.ant.amazon.com (10.252.137.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:19:03 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:19:03 +0000
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
 Nikita" <kalyazin@amazon.co.uk>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v12 07/16] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Topic: [PATCH v12 07/16] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Index: AQHcyP1dDjIbyJ6qvkGL5MWaBvgVKw==
Date: Fri, 10 Apr 2026 15:19:03 +0000
Message-ID: <20260410151746.61150-8-kalyazin@amazon.com>
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
X-Stat-Signature: ffhm18e6579mtm38m14it969r3ggoanu
X-Rspamd-Queue-Id: D7CD912000F
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775834347-34943
X-HE-Meta: U2FsdGVkX1+LXafOOEYonr60BzmFBnNY1d6glXWh4U94NBRuesfA5cj+5/VDHckExi/U+AcoCjRtEajnJfmpD187Wxi6B0Q7x5kHzWBzVrPV0j7bESokTRCTCekhU+nzRvqcVfvBBYs96Gty9Aww4G/MFA0DkmkGdbrrcuU2tjqsix1rRJqOsYqlO68kwBMebSffPn/PqFcZoe/ueBRXr9pHZcC9L9RMjhlkk+fxUejw010XjR5YEJGU1hFmhq+fgvHtY+PCewdCHRWq5XzsW7doqqBKHxhbjFl9w3O/JdFt/Gj09bJXxUPHjMhbwV4IXj8SGE3XMKaN0W1JH/WJUYuG1P9uJXOPNqU53iXvvPNjlawiyMlUAQy9hGpjtvQYH9aRC6S0ND1DzxqAcRut+yLSrnFMCmSuOwjYlce5Ka4dcr3MrG3F2S63nEz2/q/qGjoAubLhpc2ogvM9WP9mgZkZU+RbY5Uqh4OHZ10eBs+WhI4LDy60yRRgXls7iOAHAQCpOfz/x4M0VX8AjrBn/HZRtDQUSC7MA2OWe9uWW78fzBrV6CNEyM86m5pA1WREdzoZP+ikT3/VaAN2OcEl4pgkkXBTmfmrbDAB/nOJ2WhBQPJhr1Oq1XRr9Xp/juU6L6FY/1wAvgIGvChGoO7yJWXRSg0Vhlv8jfFu+knNEsZEzGZJWH+WBRVxA7YBGo+jnIHy8z4xNEchA23svZkyOCpV+EM3ozL+rrp3SISQU6tldk/vm7DvH9lZTsQf2VmvVZUqhzoG8gw25z6SK3Y14vqNU6iJW7G05RpDucQIpIrSm3SYUNh+jL2dmEWiNVuPSqJtHhNdHL90MgDMWyfnzoZomiYfXIN3LA8nyz+fJpCFXy3h+XPykpq1rb082QRvV7VvAklEywgOUBfxkoosEirFBnd6tOqih8TLIba7BIkPkl0IVcY9hisL1/boH3Robdkq/Kzy8XSIqc0h3nW
 QGbmkA9A
 T5vU8Z4qYH1NCDChr8c7+uIAa1j/hxkLlO1cblvd07h8gm3GD0GwJ3hDFK+w7hN1O5pWpJEbgPVZ+yD95u2snSp1t2nbb2Ffb+InCs3fycyXtsjw1MG4OTSX6KfAQNq6QGPOv8JNd64LJRGg4O4nRgjBchtmfXZC1nDzBLaARpPQ6TKQLoxx7ccjsbuLN7fPuUykNU6j17WKjUS+iZAFrDe4fwVsGnpep6zh/7n0DZVTOj8qyFtZ/uI7FUHVU3nGgHxHx5SQNfhLEsOp3l4d3hRigbJ0W3rg8VIZ5LecoglT2rOv2RFuDMaNrlH8nhPyuQ3++vH7TzFrN+Z24Pa7TH6eGDXzxwYhxnXwn058hUlZI/9g=
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
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
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

