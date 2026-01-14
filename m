Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98E79D37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:46:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C9496B00A1; Wed, 14 Jan 2026 08:46:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061B56B00A2; Wed, 14 Jan 2026 08:46:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E63C26B00A4; Wed, 14 Jan 2026 08:46:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D39C96B00A1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:46:21 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 978FE1603D9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:21 +0000 (UTC)
X-FDA: 84330693762.19.48C6F92
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf03.hostedemail.com (Postfix) with ESMTP id 22A4820007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=AB8LZlSw;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398379; a=rsa-sha256;
	cv=none;
	b=KT2nhVAblRjWNVQLAWd3zvr7QVBLEMXRq8bti22CthtFf6wJEOJ767GEcd2wfIRLg3FsSV
	QH5c+O+2QQlyU/5QasRm4POAI8KPpApTJ+KrQq4GlbtZpKfqZcXjuB6yqfyy/GYAiimvzI
	SWzZB/XdR3HpvUcq9QSMiqxFge6FJ+o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=AB8LZlSw;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gA5A6MonXXL1eBT9QwcqZWtspT4vy6rsMqzKnfTLa8c=;
	b=JhyUnS3OE3jn5TON9lHA++1OlEMV5vZhalvegJGGOGV50/MJ5b6Mu4ozU11gFl8jPWdum9
	e1AFHFrd7g4qBKmWJyXrPcs/BV9SOEPJMgEnpZrInTO83v20Y3M+KquM86mxws+aI/m3XA
	YVFk2b/LLUjvii/2O2zrW5trsggPRSM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398379; x=1799934379;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gA5A6MonXXL1eBT9QwcqZWtspT4vy6rsMqzKnfTLa8c=;
  b=AB8LZlSwMiXU1MZKQ+wQwhwNa9HWTHiNC9Kek1Y+ikoaE53otKCZh31l
   8+4LdQC0EVNKJWNts/d+9bZhPp4qxtzJq8c7/vjfyJLXH1E8mUow18qhB
   tR3dhDknboLH7P1Fe7lISujtlLZ5srKbb3Ed0PDG9CI7bJ9BYp8f2K0Xl
   QQexqai3fXJkrhFjsmotAcIBhHT92vhh6+57wFnDAiwGRt15fEH4gxN6c
   CJNbo9iqolHBYXxAks9gLE5iNrwYmxWrUrBGfbkV5AjUX1owxqYnbjLRU
   jTLB33KVry6w3q1NuxsoSgGDNe6St20IRim0WfMG3dEidBMpJ6V7ZW22w
   A==;
X-CSE-ConnectionGUID: zUM/ZeoFSImA3f3usHA0OQ==
X-CSE-MsgGUID: HGXmXkKRSKKG8yFbWD1XXg==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7808475"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:45:59 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:10779]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.60:2525] with esmtp (Farcaster)
 id 4dd0ae6a-5ebd-40b1-b1d1-7a6c75fb8774; Wed, 14 Jan 2026 13:45:59 +0000 (UTC)
X-Farcaster-Flow-ID: 4dd0ae6a-5ebd-40b1-b1d1-7a6c75fb8774
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:58 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:58 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:45:58 +0000
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
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v9 04/13] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Topic: [PATCH v9 04/13] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Index: AQHchVwcIho5/MmmbEGuE8Tdm9/Ktg==
Date: Wed, 14 Jan 2026 13:45:58 +0000
Message-ID: <20260114134510.1835-5-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
In-Reply-To: <20260114134510.1835-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: pgontnpksfckicuwyrik44h6wk5jt6ez
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 22A4820007
X-Rspam-User: 
X-HE-Tag: 1768398378-263851
X-HE-Meta: U2FsdGVkX18C3xJtx/b8NjxoCFZZBT4hB+T/b0Pav4eN6pXiZK3vOE+ZPwER1nI45nY7c0rcVTKk18iWd4uSz4VAsTj0kozxPE65nwTMoF49Xvhz6P2s3/Je0bbFOa5cPE5g3tSfPWtqps9Xu2mRB15vDhpT9HUrXxYWqlDKWEqt3rAJWb/toDcDsNGRqMSADwtq5j8/3A+2JXzA1OoS5ViS58BHS89lSrc1clWtWMQTVIgJQh5ys3PjOHvseaFZUFSasiANPe7wKo3hw/Xtj1mCxU5/xAkmdaJyO7gZn+t2qLUgxcsmDAPXH4TVMl39qCIxPes9bNl6VVE1bd8YJ7/9le7JhHbkSpsExQ64fWTLncqoXwjvMo3UtHyk3x+bSAkDmHcx+6z5WGrEPmbuzQkTDk5f43jQOciuvLElR5Xaz96cNFgbgDXIfFLBCxIkT3sLu6s0OuHzI+uFZxQ+qQ1y+ibDpqs+LNDXjugY4TKwPkNDq/oU2MI/4Dr+vCMGVSBXmWhNAHOA74FkC5/JXKf6nJ5KOv7yvquFKz9flshTypQmUi0oBJ53elETl5Aswhs/QvTPbm90ycXdhz9LHrVxSEheguBE+ukeuQUPVCJeK2I52t/4xFqsHHkv3FYvPjx5LxzC6YwSOf3D9EwWNt33B9h5LE+u40d5bRR1CmRVCgHDhHWq0KH6lyDuWzZsv6v2PUnMIsBWPOsBXalBZAxcMwLWv9I/smnlCm9wLqGj0q6GJoO1UXUgti6u45zHMmPZ0lKG5IGo6tx1MZlCDV3LIabgL8pgCFIu/RzC9huSvyCcybab/szyFSHsPhSiZ8MuiZZtvUdzPYwyPUGRgl+P7prGIXrOL8RhKhXqzahnVSLcwOYN0asGXiNxFy7X+G8Df7AnCAHE4VsS8pklm3629qct9w7vWW1MzzTLVzVEZGfWSS5UWN7h28eXl5SSdGA0UCB3zceG01DijMp
 0cOsfwUJ
 HqfBqgkgbJs3CPVzjqOZkpEv0e+wcjVQ6Txb4L28S8goRqrokRKqeqf57OggNpRufk/Ji7gcI7w/TQyHrDfnGUx523mc/HRKPUELIGTEh4M2HxYhmBOi6/3D1YjtWs4OGpwKmt++AVKUPup1JkvOSPDJ6vqSCxoEhyU8ThYNAIzq+tTcb8zj0yd9T3u42OEmU7+BGZK138c0OJYhbaCYzAFtVdNVXM2nA8EABM45sbPInrxxZsNzvOAUMfNg35819ElaUjEJ21z9TiaYpBPaEP5R9+Nvwvc03T3dQPSjr+kbq1qvvROkZaeeYCJ3zhV8hOWzBHmtb8dxUH+6aCD3TbusvvgdrbDTHFxF5LKoipk+4QpVwaeCouQIhIaXe6QWm+5GvlxZXwf/g1QKzfmcvagJKo6esMIprjge68etkxqjqGKykoo55bP0WShLM4HDub84NpiTOE0II/eaePcm2l8WIXr/CYU2u0M1zPangOTEmdkOwde9Y3b5mSvtvnMXW7oyicNgCkrscWwfLpU9yUiPQ9LbXHegrxsf1lQYej4AbU9qa1K82lDBd7KYuRqyntOMRDjBRUfsmjhrTcC/0jPmIE47BHOrAdd5RswM5iyoXnBUKjghed2P0q/AyZUW9ehNRbNxFFzXm1/1eS9dmDDY6wULSXW9ncpmhlgDQPJeapxgIwD7GKTNWO43Ql4qbpln734i5O+dKP7qGogygjBQApn2+Xmx5hrogSjTFg6cbMnJmx0ttkbUtTg162tmZzeYMzFjnoirovJKy5EjkkAQ7wZUMnlln3BHB
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
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Acked-by: Vlastimil Babka <vbabka@suse.cz>=0A=
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

