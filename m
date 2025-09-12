Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C64ECAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:17:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CCD58E0001; Fri, 12 Sep 2025 05:17:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14F4E8E0017; Fri, 12 Sep 2025 05:17:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5E0F8E0016; Fri, 12 Sep 2025 05:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A978F8E0001
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:17:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FFCF1DF6D2
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:49 +0000 (UTC)
X-FDA: 83880045858.09.2008971
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf16.hostedemail.com (Postfix) with ESMTP id 17459180002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=oMxWgF6W;
	spf=pass (imf16.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kZG7qKcwoZcAgyR0jihOR1ywNur/8qSCXjw/0MwZqaY=;
	b=xCjWpKwgxajpey91zZ8cUk/8tI06vla1mlaYwhhs01lfQUHjuMU40t5Z2Lidvni/qiPCku
	Mx6wqqfjPPSj+sVDxERKG9PvyU++UByth7qK16u6tRxKbIUcHn1CBUhNchdRoF3thXWsxG
	URI1L5ekQVvq0lqWpwEDkoNaih1RfJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668667; a=rsa-sha256;
	cv=none;
	b=kzDDYUpFPts0XMGWECkJnHs4RPo8Om3GzGj2ucZ7zXpiPF4Cab51xbyHbwo3cPJ2Rjs7b1
	NFTmwC9KNhgRQluRkzSea81yW7gVUFkXYL8OzbfY9PMZ11QC7/kRDRybH4KOg8UITpnqef
	Ll6G7xpKhLJp/3FuB6wDvg5GtTv9z2I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=oMxWgF6W;
	spf=pass (imf16.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668667; x=1789204667;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=kZG7qKcwoZcAgyR0jihOR1ywNur/8qSCXjw/0MwZqaY=;
  b=oMxWgF6WK6bvh4wsHoe1p7eFIdLVg0NCkcomkmZjptcmoHaiiXRZAEHg
   It9lnC7R8xKDZj358l9ha09cNr/cLV88+W7Crr4PJjjF1LEsSq4mnD+2H
   2xQvXtEj/+rOpib46dmBzGgEjurQqXzHAYzRMQvwoen8fiep8KHRyLvvE
   tUKByd9noCxwxqbsoNZDmjbz2LbGx4Qu20ujUw2sKHz8alzv1+2ZCpjgZ
   OW9FKp7iSFV6wX7NA+UidyLCdKWmI+i4j4a7KALtwQeThip5rWlZPpWxW
   HVkZl15ve0CskAkRwKElpGvNhix1mD9Ytd45D5vmj8i0iyiVj5i/lgz5g
   w==;
X-CSE-ConnectionGUID: np9xkGM3R4OsSIWXSr/rXA==
X-CSE-MsgGUID: T6I7qhr+RH2MlTn97VHMOg==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="2004639"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:38 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:15614]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.240:2525] with esmtp (Farcaster)
 id d9500210-6cbc-460c-a7e3-cde9f6be7ac9; Fri, 12 Sep 2025 09:17:37 +0000 (UTC)
X-Farcaster-Flow-ID: d9500210-6cbc-460c-a7e3-cde9f6be7ac9
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:37 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:36 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:36 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
CC: "Thomson, Jack" <jackabt@amazon.co.uk>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"derekmn@amazon.co.uk" <derekmn@amazon.co.uk>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "willy@infradead.org" <willy@infradead.org>,
	"corbet@lwn.net" <corbet@lwn.net>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "maz@kernel.org" <maz@kernel.org>,
	"oliver.upton@linux.dev" <oliver.upton@linux.dev>, "joey.gouly@arm.com"
	<joey.gouly@arm.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"yuzenghui@huawei.com" <yuzenghui@huawei.com>, "catalin.marinas@arm.com"
	<catalin.marinas@arm.com>, "will@kernel.org" <will@kernel.org>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "kernel@xen0n.name"
	<kernel@xen0n.name>, "paul.walmsley@sifive.com" <paul.walmsley@sifive.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "aou@eecs.berkeley.edu"
	<aou@eecs.berkeley.edu>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "gor@linux.ibm.com"
	<gor@linux.ibm.com>, "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com"
	<hpa@zytor.com>, "trondmy@kernel.org" <trondmy@kernel.org>, "anna@kernel.org"
	<anna@kernel.org>, "hubcap@omnibond.com" <hubcap@omnibond.com>,
	"martin@omnibond.com" <martin@omnibond.com>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "brauner@kernel.org" <brauner@kernel.org>,
	"jack@suse.cz" <jack@suse.cz>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@redhat.com" <david@redhat.com>,
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
	"pfalcato@suse.de" <pfalcato@suse.de>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "yuanchu@google.com" <yuanchu@google.com>,
	"weixugc@google.com" <weixugc@google.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "shakeel.butt@linux.dev"
	<shakeel.butt@linux.dev>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "loongarch@lists.linux.dev"
	<loongarch@lists.linux.dev>, "linux-riscv@lists.infradead.org"
	<linux-riscv@lists.infradead.org>, "linux-s390@vger.kernel.org"
	<linux-s390@vger.kernel.org>, "linux-nfs@vger.kernel.org"
	<linux-nfs@vger.kernel.org>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: [PATCH v6 04/11] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Topic: [PATCH v6 04/11] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Index: AQHcI8YUxI4WCJha0Uym6FM9po/nmA==
Date: Fri, 12 Sep 2025 09:17:36 +0000
Message-ID: <20250912091708.17502-5-roypat@amazon.co.uk>
References: <20250912091708.17502-1-roypat@amazon.co.uk>
In-Reply-To: <20250912091708.17502-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 17459180002
X-Stat-Signature: dkjx847iecu9bb83rg8ewu3iyhaknwwr
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757668666-77760
X-HE-Meta: U2FsdGVkX1+/DrBPFNwZYZ2+DmtNlnppoqbEZKRTQ2Z5+HFbX+DzF6lSPRFJs3h/I2NWwrJ0ZQVKAqavQFPZ6HZSH+2ZCI5qvIrCSrnBPDkwntURJ74zsc+VE93uEVEbiXig0mhvFDIQVHvFXZtGwy9poUbqqtL1owI0r7vFYIXwPoovEeFT+8QAqcCsAnfZTXWaDFY4QeCZvRT5i8HMmTg9SogIDW4WIEhm60Tk6XbQYLtIyT3qjPmxQ4HEGyYOmXP4NEoDPqoGPC0JJjqDgHHzQJhnFSNhxoJnt58x4BBoaYDXIKlR3JfCdVy2Wkp8dbq+B1cllcGYhA6OT0XD/yOnK7d+p2HvV8ZDAzeATpWi7rnreLj7V42gqd/UF//l45GiDJGJab78rJfBypLCfQvIA8lxEMLvrEoa/zOVzks91aps0zjT/WM7sJq8NFVaevkwpb4fZ5bmMapSuzVFlZYv3OH2gC81IFuyCFmRjc+gXdaZSb3UXP44APvIqMO5CPuzFmdHZU0SWGGcvSGSxKaNj8yxqA+Kcr36KLMSP2/ydjr0aKkbrBvBNB+3ByJNxHgq1VpLnARW1eNAAhqFaC2aImG/LbQhZVBEDXhbSXnJFocPcyWlTZtwgnlKjnGlQJatUqrNKmD74r6P6lnqVYUXjM+znKBp3qM42+MPS+dhJaTyYM/Hqpf0f8NpVptnHgU/9jbLFitn5or419ekKVYSah8RMhXB6lHSF66v0c1bS2U31LTQIFAbgzWdQ0XiLoZB5OgGRQQKkxJOiBtlEvKEcQAes8j0dp0Wq2Vqx69TKHSzyfaTajOywEv4jF3m++jeJTltCfOxkhOd9BjdL4F3gRAX2ednOM411WWfY/zp8SWpF1hJel8CORWWbMcqHT7/u7AyfIDXti33Q7MVniQValjOtCbBOQ9zsyBHpz8Of3VWzJb0LXhMHp0bLqmILlP3JnWnBMTY/69+s4/
 a28SodOM
 6xH/UBD0Pa/s71PiBemMmBt2YbzXSNX5sgd2ne245sPxWGkRBQSAqvIzXPAvGM20pi/9nQJlit0GA39qZqsGgc7TyxMdprbu7KyJqRSd/7IuuVVah/fRkyXS8qm6mt3MZ8kQ34nCanOMG7e4WGl/sjYZW358dwDbR9UzKHjdbde+bIVfBSixwaiYWXuVxBy+vGW+ofY36FpS0N7KAyPmCB8884YmipledpImRIMy8/4giUC8MTWqm4uhXnh0gMVh+pZFgFWVS7+gtzbHZ5GnD6vwxAmXYa3ODko3rgLAMikZ99Y8g34kLnf/6uJlcSbbGECFOcCxAFqjWH966dsJ6DcLlOziMCcEY3BawxzhAfXqrQTzEOV+TBHQjXBEEaAenNexvzZLPYF+NhUo3I0l6Tdp1wxV3bnnQ8AkKmespSiQ5DKqyjkLAhCcKx0m7vNTtU8VNH6UT3DYWCH2+t1voyyAuEPVpl9QRjUhZxTyhaJL45BKPFkQI0jbxb9pZFj0h2tm9v4GeRNpxeI4ytwGw/VG+uD6/klpgjvAaPErv+OHBVr0j3Ax7gaTPFn2Laec4mWdanKLAqJVERTmkh2o6AOOQlvz2tdiq1jwGjflpnR2ZAgFpPbdyspaU//h8D3IsCeLtUu+Yz2MN+zY/g/Zpq8w/r77mO+fnQPv6xb13mcFnAH7zgQ4cj5qJlctEz+JNOOKb4iotJHv7l/XydT8DkdmczQLhAN6zdMfq8CY+SfflD6KXsLSHnPrtq+qNk2thzaioo9V1xdh4yzSXB/3QwxcRgghsQWpuHMifUnzat8u0zksP1FbDFmsZPd+ugnyo31Cy0cPeUglxlFAcKGXcWPy5/FjX+0+NZPTCZ8Y+6JonzRs=
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
index 9ec4c45e3cf2..81028984ff89 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -429,7 +429,6 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol=0A=
 	return MF_DELAYED;=0A=
 }=0A=
 =0A=
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 static void kvm_gmem_free_folio(struct address_space *mapping,=0A=
 				struct folio *folio)=0A=
 {=0A=
@@ -439,15 +438,12 @@ static void kvm_gmem_free_folio(struct address_space =
*mapping,=0A=
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

