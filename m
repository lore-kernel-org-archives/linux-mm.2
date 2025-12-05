Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 828DAD33995
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:58:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E15D6B000D; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 565546B0023; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 390AB6B0012; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DE626B0011
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B62A2140282
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:40 +0000 (UTC)
X-FDA: 84186026400.17.16FB958
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3735D1C001D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:38 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=naju05ZQ;
	spf=pass (imf20.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EkhXi5kdHmtd1AcwEg7Y2Ijcajvi2mTnsK0V4nCbHJg=;
	b=HihX/UiHefc1oo90HJg9c+j4/wJd6hL/bbCMcUKAvnBk1u18vhHztqPKazOlWTEg3dc78O
	bogdqk4XWaV87ZBC335Z13UmrRfN8lykBwj3WioT/tVLCU0AFt1QExroaicXdmEPK/AJDB
	9uEAAy0DjyLXkr38Co8TeJiR0D5PjHI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=naju05ZQ;
	spf=pass (imf20.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953918; a=rsa-sha256;
	cv=none;
	b=d+Y2bg7mp5S4paYLtvZUcMSWzPUtw/VDClZ2DlS2q/P7DSPHdRzaMhprrG+vPIeiFvjs47
	ENtg5FxRxPBlHkPaU6U70ne18wEk+zOmi5rHfhC/3aGnMYMhrE/j+kx4LYdiiY2MY9cJ/R
	Wtxl/UnAsDrxq4ORQgZss7R/FkcWyIs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953918; x=1796489918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=EkhXi5kdHmtd1AcwEg7Y2Ijcajvi2mTnsK0V4nCbHJg=;
  b=naju05ZQbOqI1nd84N9E2MGo9mnx1NjTsZr08TpeL2S+wtk3qIbjMnLt
   Khsh3/GhdzwhMx7/YR7aCCOt7ygSMbFR8a+YnMczpBxhCcU8QvvlbnTPU
   pP6Z70hcxAan1PYrg6bDmivj3VWfwnAlaWbsXez+i3ebVJ7OIGC8YpPqe
   JLjO/bp7t9vU7MbdjIpxymFW2nzqKpBpkZjzqzz21UObqg5yj2B5z8kiN
   LKFEYkRxV29PJXZirwu2Muwx6JBkbDuK5Wc3/triY8LDoiRQAvnX7DZv5
   o1n+P/pGXsFfxfWO1HaQ+70LPjymBNHYJ02DlVJUkLn2tiCtA+XG+USvr
   A==;
X-CSE-ConnectionGUID: Y1gfsvFBTC+sTxrM0g1LzQ==
X-CSE-MsgGUID: /iob45L3Ra68xjbcCTFGDA==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6306253"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:58:36 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:30659]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.214:2525] with esmtp (Farcaster)
 id 003a5827-a72c-426f-be78-9e2d9b40bfe8; Fri, 5 Dec 2025 16:58:36 +0000 (UTC)
X-Farcaster-Flow-ID: 003a5827-a72c-426f-be78-9e2d9b40bfe8
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:32 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:31 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:58:31 +0000
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
Subject: [PATCH v8 04/13] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Topic: [PATCH v8 04/13] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Index: AQHcZghi3A+Ke3NY2kGcY3fh9aT3hA==
Date: Fri, 5 Dec 2025 16:58:31 +0000
Message-ID: <20251205165743.9341-5-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3735D1C001D
X-Stat-Signature: z67o8kcntae9j1a1yprckckeqri5pzc3
X-Rspam-User: 
X-HE-Tag: 1764953918-548350
X-HE-Meta: U2FsdGVkX1/iY+AoC/cKD2li5Moa2SV6MIGLP3MEl9WBHg82dhYiW01dqnu2NFxqa9sO1XVEN72vck5X+/IxvjcIyQTVO/tA4aMI8KIFZ5XveXsKB7wGWElf2e62c20ZNvd05HdJ+k+osd8WrOifLi5S68s3yJ8eb1N2hDR2AYkw3BoOpSk7QeJZ9DYRXEqpUlP4F8FX8qNkFtKxeDc9MRoRyTXq81iI89n/p49NJIYK/a3hOSgX9eXgbhvR/0DwnDwZu4zO7SOQSUuUF04RYRratEv+zCyPGoapIofoMXVAkRvRyN/4/cEFGV592cCZR2tBeONxS0rR7wNQI+3U8qpI+yOlX3tv2N/fGDzf4cOjYtS/BZ3j9453UTXWIvQrpUwkCRtkrg6RwyrpWZ+pxATiZI48dMIgJmPalTqMcE+NPWNHU9P+RtSNo7XEiAemACqT7ei+khosyKL6HNROCwegzBuboM4pS0XM+VyZuxSLq3cGqk5jmieuDR/DEyZVtSSmjLzfR+WGtNatAfEnjXd4scMkgvYsZy1CiPZH1iwrKt3/5mGjPK5OiaD0O3rhRGD6nrgwTHOrLLd8ctKTtNM5Nr4KniN2b4GwYW9uZ4p7JpW6ZSm6t/6UcR1jODq0QMf0JMDBRcZBW886gj0ROK888ByTOM7tgthb7l5pafjFAXiLEZTEIS/7C75mKBrao7bcbbYGo9cjHOFB1273AcGwKlvel4qd9Dahk9DDLeH6t7J/0/6o1sdpwFDQttvQlgpgqiA8pTy8KyvpHGM0V3QagQ7Y0p7YRrsZip6N4E5BOEaohTyldXpB28zWBN3hlyqm2Tg7bCRXaTb2/VzoJtTzjg2xo2LZm//381AMGOYGOVY7AkmSMj2hOKcQTg09LX5J9lpHzhSHVoJCjnQwSOaoHlPOJhVpkDjOCSVEwVNWZzhrqbNi0m+okr1tXL64M364s7yoRdoYf3pbFfp
 xCYFjzOb
 mk/g2HX2sQuCO+/HpwDaikn+ekMzQGTuYXd7YpCKkdWuhW9pYUPlkT4l1TfzwSZuwKldXQSWzcnmhWwr7jLP6XF7TmmZhpoDyp67j1JdoV0+b5+NJmMHfSdMmFgSQQUDXAES7GR1HGJHHeIt/oBTpC1ynDUXb4/Thh4QVE7JPAId8ccJtt12ZCKYrDjLNVzW+vUHNhYtqQBDlT7ygl0Ctt2phuTpVHr3TLrUT6U3a1uVYSuCB2EcG8GSEb6cbLwOz8ulX5BrbnVoOl4FNDfcQ72yhttgDGddUeT1dsUI0e1qBZPyCi2wDYyL1xAszAt27Zvw4f0n3sUOjm8PW4lR7xzgV8gLvp6tmkyj7HlzNRp57LvHDSkudk76oUVyICnizIXHqpsEIAa8wpgqf6QfL14RzgKtSE3++9a1Om25zv3+7uDnpRjgzRWg9mJ/PYBaoJa3+qGyXWDeqYr7COrSqEnyB94boOWtIArU50F53j69ATBcVeQ0qcqHfFnLLYUnEhTx+u1OF+31l1CEjkY/wSjD6g7g77jeaCQurcBm6euvpe+9MLG5S2OXVjDHsVbcaip/hBVKf4sIBzvgvwTlD0hnpOtxMPlmqp78y5CfYXzMTx/uQ2EXjUG432iPST/KNK15Rz5dp8ODNVMkKSTp+bWkj1Dg0B/ENKSJhm8YfKhNNe3iuVqjDwGG+KnzuZJZbsaXQgpZit2gkQKJ48x46FJgRmK5rZOvkFkzkxm2JYSyJhX2GfxytLk0VRnRj8ERQKi0c2JxiLx/iYpsb4TOPe21ihjKy7lB4w2xT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
Acked-by: David Hildenbrand (Red Hat)" <david@kernel.org=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 include/linux/kvm_host.h | 2 ++=0A=
 virt/kvm/guest_memfd.c   | 4 ----=0A=
 2 files changed, 2 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index d93f75b05ae2..27796a09d29b 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -2589,6 +2589,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, vo=
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
index fdaea3422c30..92e7f8c1f303 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -527,7 +527,6 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol=0A=
 	return MF_DELAYED;=0A=
 }=0A=
 =0A=
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 static void kvm_gmem_free_folio(struct folio *folio)=0A=
 {=0A=
 	struct page *page =3D folio_page(folio, 0);=0A=
@@ -536,15 +535,12 @@ static void kvm_gmem_free_folio(struct folio *folio)=
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

