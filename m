Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E499CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:22:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C36AC8E0025; Wed, 24 Sep 2025 11:22:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0E5D8E000F; Wed, 24 Sep 2025 11:22:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B247B8E0025; Wed, 24 Sep 2025 11:22:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 998288E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:44 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 40FF0438C9
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:44 +0000 (UTC)
X-FDA: 83924511048.01.3ABBC60
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9EB234000E
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=QxBvYElN;
	spf=pass (imf17.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+UU/9USrfzM95aGLT2Fsiof0dffr8QNJGxTG3aI9K58=;
	b=HN+NEKG7vDhUhMUF/5fdq/m0eMFw8bbhMddx8FegV1H/subtsB6J9B0NDi9/6ZzKTotjbl
	s6OqZjjhWCBmAZw9kqj6hQE9n2xkEJakXuVAuCNFtYZmyaW2B9mLEvYZFbwBGwpan72A7L
	wIzbs0arI3F2EkwRJd4bGV1pxZFt0LY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727362; a=rsa-sha256;
	cv=none;
	b=OYDdCnetohP7G5BcjpG4fUv/NiD8B9//F9JpAkJg/fjyG7LD6UPXUcWfVE5QIn84UCYth0
	JzEcbeIqwuhchcXCbEP5g5gbX0+v3Dcwgf0Ci1xeAtRYNrima1WkePgmwjEOG14CBiXDbx
	fuvRRUHzLb02UoS+3hRU493jxDIdyW8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=QxBvYElN;
	spf=pass (imf17.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727361; x=1790263361;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=+UU/9USrfzM95aGLT2Fsiof0dffr8QNJGxTG3aI9K58=;
  b=QxBvYElNJBpwuQx1l0eDfHrMeafDPEDfxA7HoQ4ZqIB4soaUKc35k+q7
   IGezT5z1XyUpeGyPDBo4/z7k5o2kCdeoU0d2d/sG0CcqAFZOWLKpimGHW
   W/OMGr0X7lkppbHil4FRSt7kidMbZNi+2CU4b6/80ZxoSj3Ibxz7SZ53y
   tE2EljajTbxUx4QxtQSRb6qlCkzdYIT52A61R4THwgZqR/FM8BhWNKpwz
   oLzYtmFoHK2Y/jpj/kTBXyngWJ7SFwqZyXdOgN7z3A30vAF8ymh/tZeGR
   RFiGTAhA/yy9xEFBJp3LM4WPQP4EDkSyO3jh89yDTlg4pQEk4Zz4g7HFV
   A==;
X-CSE-ConnectionGUID: nvEDSrW2SqWzBBNRU6SmrQ==
X-CSE-MsgGUID: 2Yf5dc86RUi62WhOIbT3ag==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2519318"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:25 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:11349]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.43:2525] with esmtp (Farcaster)
 id 03c68cf9-a36f-49f5-a600-2aaa8ed6dfea; Wed, 24 Sep 2025 15:22:25 +0000 (UTC)
X-Farcaster-Flow-ID: 03c68cf9-a36f-49f5-a600-2aaa8ed6dfea
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.245) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:25 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:24 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:24 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "maz@kernel.org"
	<maz@kernel.org>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"joey.gouly@arm.com" <joey.gouly@arm.com>, "suzuki.poulose@arm.com"
	<suzuki.poulose@arm.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"catalin.marinas@arm.com" <catalin.marinas@arm.com>, "will@kernel.org"
	<will@kernel.org>, "tglx@linutronix.de" <tglx@linutronix.de>,
	"mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org"
	<luto@kernel.org>, "peterz@infradead.org" <peterz@infradead.org>,
	"willy@infradead.org" <willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "song@kernel.org"
	<song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali,
 Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "derekmn@amazon.co.uk"
	<derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>
Subject: [PATCH v7 04/12] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Topic: [PATCH v7 04/12] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Index: AQHcLWcH60RhAO+AlEuiH93VYclyIg==
Date: Wed, 24 Sep 2025 15:22:24 +0000
Message-ID: <20250924152214.7292-1-roypat@amazon.co.uk>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
In-Reply-To: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9EB234000E
X-Stat-Signature: 8jpny6o3ga7it538iuc9kws94twtfj4j
X-Rspam-User: 
X-HE-Tag: 1758727361-549509
X-HE-Meta: U2FsdGVkX19xYEWFDHZPk/gZ0hPM/95unLGt9bxSrVKUmKIl0aIG5WPKzyIyl/rKZ2DpEQ9LTGJOd6elQtcKGwAhI8UWvbVA6WiuZwVkO7jSuVMvRiJ/9p3GFBz5XB+rfrDUuhRQKoxaOqhpaNmBQuMNy/yvv2kFZq/P8mXcjk08CEB1jCA7drKVKIrsfpeR45WTF2n+ak5tVx8SWDLaWHVoKS+n1qsRtrhBdaWH4ZVZsm5b4toqu1ioN4xWMsVfXKKz5IkgW78KL5QfLL0Va1QdjD0rCy4R/WkY36MKslFjDGWCMEeEae0766pIM6VbYTE15Mhs3oPuAmjY1z9uK/bCnyvkmkM7Sb3c9gHFfw6r6VfNTOtkFLno9sCO6KbhU6FfrAuAH4WkUcQUP5t5B6tkivIp1CevlDz3Z4HvTXQ7xdojJmuecPCzSFlMIE5CUkMtXKuvA4a5FVzQDyHRDZDn8SwvV+hMMAeiJI38JlQp2QmOG2E5DV1OZUAUi3Q2mBGszRaAc2vCPCi0j4d4A8O3f49ODMjcPkTaVyOcIXl5CExhYRfRet9eLrpc8QItjQgtkIdUAd9UxaY4yQBgM8zhqQW7olJj+dw7KrRgXh0eMQo64RjS1kT3H1x/o9hio20QeGtl3bnSlt3wVk6LjMp9RA0pe/sAJcxb2wM1x3hQx5IlfOK4El00Z3V9vEA8zAEnguLEKSUNO9LtyBEX29+APmpXcCXyWC7iOfb3yUNhJW7ah60tY+JTWgpaaZMEZL4bYtw5YnUBnEDGxopjxj9jGvgyIx0Zr37Qrt++GlwjIVxLHAiTqwJNjhj5kQ5DuffeE0ihe2CvDgInlh7rnfnyc3vhivIaGi2a26+/8LGZsD2NCoUMJy8Y1nurfMk+zwa2oJFy52qEi9UgwKmH0OwvgANLEExixk53Y43tB441hNm5P2COQe+xgO1UBRsunbO5ZOWmDW9N1l26d9F
 sVQeKJyw
 aK+lUQ6dhSXxse0gUUQOYDgF5wl4NCnmfYDPd1OH9RRfNER9QwQLX7ePLVtZYsN2V1pYqNEAxw7yE7xxm4omdJurNA59l3tBqcNsf6UCjLM2xbo47EHu+Ki0GaCjobs9W9BU78vlnr81Yx580xEFjhhVffiOuYAg84ymVINu10pSs8mnRb1Chkr+IGH/gaTK/NSfhoHY8urJX77FlbHe9QLl/LXNCZtnbb+Pelrl4dnL8RSlrcItv9YGjYMc+nhtQSkVP53Pi87z+tL6fMt2Zmtg9DEQAhy9ArT58OSJHa9KYvsPho+BEYrTkSkQVubkdoIcyS9TZNKcbhqW02TpxGrvk1rLZC9DWwl+N1cLSIKR/YpDglgtELsyshwIEO1xBZlh3QUxC818kfzBNTVca78B2MnlULNI5dcwIjNAL2RpTqLgZBo1+9P1Nq8p6z969/yPclwJjNfb+a97RKXaHgJ0UTXfa3Ew8JZMMLQWKMKX3I91u2+pXGx9lH/jkHkYkPzdXcTYBPA++Ynqk/TTzpISO/cqMsjBihTZeKrWgsA/OkJ1q0MlJLSfDdW5sLCaB1l8F3ybgxVxSpBGEXZStqFVpjfiGInKSSkQtR3peaMOZXHjCTWX1GgkvpXjC6lm61MUYkkeQDJCaUqPaXRCTJ6Y6I+16u/4TSVbvEJSgl2MIORVazjeHg2DHLUaESxSLD4YgzQRgPCx7WKMAolUAD1rhvCQ86lppkiFBcO3qf3pxnvSLC0JjxFGF5q5DPayQ8I4DYqiUt9atK10lm0ChziQ6npZRU3y7WavV0/gNnEgb4JovfS4tKoVsdX8W1VKxUZLPViqeCLqmxMNtbTaSwFfd+G08Xj8UM6cY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a no-op stub for kvm_arch_gmem_invalidate if=0A=
CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=3Dn. This allows defining=0A=
kvm_gmem_free_folio without ifdef-ery, which allows more cleanly using=0A=
guest_memfd's free_folio callback for non-arch-invalidation related=0A=
code.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 include/linux/kvm_host.h | 2 ++=0A=
 virt/kvm/guest_memfd.c   | 4 ----=0A=
 2 files changed, 2 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index 8b47891adca1..1d0585616aa3 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -2573,6 +2573,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, vo=
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
index 08a6bc7d25b6..55b8d739779f 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -429,7 +429,6 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol=0A=
 	return MF_DELAYED;=0A=
 }=0A=
 =0A=
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 static void kvm_gmem_free_folio(struct folio *folio)=0A=
 {=0A=
 	struct page *page =3D folio_page(folio, 0);=0A=
@@ -438,15 +437,12 @@ static void kvm_gmem_free_folio(struct folio *folio)=
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
2.51.0=0A=
=0A=

