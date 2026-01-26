Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E599D19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:53:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10E536B00A8; Mon, 26 Jan 2026 11:53:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CE8F6B00A9; Mon, 26 Jan 2026 11:53:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD806B00AA; Mon, 26 Jan 2026 11:53:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DECE26B00A8
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:53:57 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A0D96D2453
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:53:57 +0000 (UTC)
X-FDA: 84374712114.10.36DF141
Received: from fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.143.178])
	by imf04.hostedemail.com (Postfix) with ESMTP id 2738A4000C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:53:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VpQJuO6G;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf04.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZkODn83RzbQJlBtvngM/cf4CG/FWZhQcx+73Doqz/A=;
	b=7Kk5sMxcK63bPjfHbHj4REi7bgjm6rnnSUiibcFej8fk7IriRDoYeS8FcobgcyBFrIJ5PP
	QuIOdP8QNmsr6TXVNmlP0cSCtgwwzPwMGEgkRhIrK+262P2Qrc1ZOCJv/fzmHLATn+ArUz
	aGFPX5NCX7snge457P0hoboshxJf4II=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446435; a=rsa-sha256;
	cv=none;
	b=JQc7b3Bb9ppe0rYNoqUSRMvX+ighqd52V+djx5Y0sa2Y5xqIpY1ROs0NtwEO/ljZfwdfJM
	P8VqWYRwhMlq6ErkH0D0mHA5JiTAGH86woQtOGYabb6NGYOstYHvl0Il7GE6jkiM8o4pSe
	s0/jIA7pX1gCtU1EYiPE6hSaZui7TeI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VpQJuO6G;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf04.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.178.143.178 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446435; x=1800982435;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IZkODn83RzbQJlBtvngM/cf4CG/FWZhQcx+73Doqz/A=;
  b=VpQJuO6GpVkePDyUJVv8TtD1M4TVLjs6M44HBADkuTd47jYwsKVAYLg2
   htHaEs53DtRuEBVMcV4UwV5ZZf2VpfCV4rvxu+1DmY7ufUpc8jFaq4X3M
   JNXh16yDckl4YIWjNGpiTzMDwUJ7H4WI9qaFqeeTmXG8am3+2av+f47i2
   lMmWlVjdrmORUpF6ZKz7QNMqPG0bhI97hQFrWepKk1i+hFmC80F0anbX1
   e9jjzhTO45eYuxtIw/EKQqtRWt1EEcWBLzMSzCiiLzYj3rvefgtlEj2GS
   T2cTVA0Wji3pmBzjJs+shkD7IzISc4fcwf3YpiBolj50YtbOVj3bg6eTi
   w==;
X-CSE-ConnectionGUID: 2nORrr6YRC2G4fZW1A4I7Q==
X-CSE-MsgGUID: +c9glS2LQGe9MdXD3TLgeA==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8357402"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-010.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:53:36 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:21035]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.198:2525] with esmtp (Farcaster)
 id a8706c82-9dc2-42cd-ab2c-9b60461130fb; Mon, 26 Jan 2026 16:53:36 +0000 (UTC)
X-Farcaster-Flow-ID: a8706c82-9dc2-42cd-ab2c-9b60461130fb
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:53:30 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:53:30 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:53:29 +0000
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
Subject: [PATCH v10 14/15] KVM: selftests: stuff vm_mem_backing_src_type into
 vm_shape
Thread-Topic: [PATCH v10 14/15] KVM: selftests: stuff vm_mem_backing_src_type
 into vm_shape
Thread-Index: AQHcjuRM7p/8/MtlVUCsx1GyifAAag==
Date: Mon, 26 Jan 2026 16:53:29 +0000
Message-ID: <20260126164445.11867-15-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: 2738A4000C
X-Stat-Signature: 59arxzhdjo4fbwy1qunfyzbkosn8z57r
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769446434-895283
X-HE-Meta: U2FsdGVkX1+iCzHy+HrkKYj/TgMyuScZydDFtgvGHlfi6aSy5DSlkZW80XWIu5XtDDPtrjJElot3XpoRb4Os0XGZmgSQRwbzuYISp5RBMn3Zsv67+kRejwxwo7DBkN21q+/BFO3HKewPaVU1Z+MvgEY+oEKr8RKoVHQlT50eK87PNv6SDDJLVx25ZiysfVECcTpfK2BxiXQRu1A8j9fNOaSbJ4gL2ogCtc1ws/Jr8tQXHgMWHNTKAwZzPeIge8uA3Ym83YVg7MVzR9mZBIH3XnWWrwxJda8/0JPkMFofzqDheR+JGdReyfZ0jEjtzricwoUjuPvStt//g7IZ9YnocfngCy2LCqo3+iQ31tkNagtFplb5GMzz9RTYeuy+h9Cyj1dgmi6TPhQE+/ArciXn4doLb7NMxDd3IC0uJUht3xjSPu2GRAxABnMrLRT6ETpzhkChe85cgv6JqozvS8o5HU79xKAMWSJxN6iEwzhTgsFdWqFAuhmJ2ADOA+DDbHlaPMkFICU7vE+QVqC4cBemoxBPj+jaPGOXYUs9OzfWAMzCS1qbkJp7f0VxuF0COnSB4JF+ygxbK4fZpp815Dyo8eX7U6SbqujbrFl35bvuxQRAqJVlXqM0wSfUIhv2a4Msz5WR55RWSkVFD076PvS1x3pGjbFK1P9Y6uLmm/LgzU/oJoxJXol8fXc/X/wA9zrJEXuPRggjQCgFJWxn5OvPYNtTCDE09VpzHWjZNw5Sf0qEFWCrxSTnkYATHwvGzlPRia4r+1NKoDzNJG3xALnxcHFVbhsZPpEnOmayDkB7khBUw+NxysHBZuK1ssI+haxvwP1hPsEBGony6iv4c9/vymAAgCYRF6Co1Df42X5BPO7R8RPJ8UBmB8HSw+6Us1ff4/LtpdJe92/5nON8ur7h74eumPy/xbQOn7NUZF+OkicpYteBFblklOH/nDSfrwAe00ehxDfb4T0WhFCvmB1
 CwcUWlvQ
 8Pnm5Tpk4iaYaXZQ1otlOyjhtcS+c/0BCw/VtIk9IwodfWH7K2zyH9ResPRxcQujxo+5C2hDGghIiMQyvq4iaNm6wpa86mq03tW6YceH42bjyW2LnkYyAr2jqbqXUNUOnhfDd7YwXS7wyPCp8jao69OJ3iQS8FHeilobl8mwo1/LGHa8R4KZN5/NZzq0ahQTm+2jE3aGN9telBbPFLw7dd28Knj5XdSpFySeMogNvI0y050C+UQH61kj22LDt3n9u9HzaYQv9DtRajyMwClR5gM+3Se9b8vSCgd+Wd0eiH6ttMcnB0J0tt/aSUWhoyrTowUPte/afb7IT7VO/yIgAA7Kp3fmtdRFcexfhulcLlcMz4BtSbL/3B5X4VvBqhd7wFBIoOi2KLlIIgaVUQ8VV+EWMQRr5hS7t6xf+FYU/3UYd32x9q/VKbk06N1VCIIX0I4S8a/DhY/9TVb8bYJGNcvHw9WuteAhaPaqBZhZo+qVkvlWDJyMoWZo0KRYJ2yw+zaN/U1G4NRRjUq3kohYXGIwmZQDNz5WNZstDHH2dxO2DDBQAKPzHYQE+xjiwS0FiKxukCEAV3dDw3VkbSatpqFsUXuwDzdHI5q2GJfKGxrSgWY8XOFrfajXR7soRFhZ8egW/dHvpNWTG+ep5jsrFBbrXAixqaoPuADks1nrNpDl5QquMDbASK9bxiSowStgDKnbtqnLNqwPko/sUxge4P1TLf+50CjrSIWZuGznqQvnEZTeQxdE/6dOfXvB1Ekq3WP2UduKeJhtXtzWLNR0/THnvCSQ7XrFFiBeVfPOTo4bU3TmSdkxK23Q38Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Use one of the padding fields in struct vm_shape to carry an enum=0A=
vm_mem_backing_src_type value, to give the option to overwrite the=0A=
default of VM_MEM_SRC_ANONYMOUS in __vm_create().=0A=
=0A=
Overwriting this default will allow tests to create VMs where the test=0A=
code is backed by mmap'd guest_memfd instead of anonymous memory.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 19 ++++++++++---------=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-=0A=
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +=0A=
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +=0A=
 4 files changed, 13 insertions(+), 10 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h=0A=
index 6689b43810c1..4bc4af9a40cf 100644=0A=
--- a/tools/testing/selftests/kvm/include/kvm_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/kvm_util.h=0A=
@@ -192,7 +192,7 @@ enum vm_guest_mode {=0A=
 struct vm_shape {=0A=
 	uint32_t type;=0A=
 	uint8_t  mode;=0A=
-	uint8_t  pad0;=0A=
+	uint8_t  src_type;=0A=
 	uint16_t pad1;=0A=
 };=0A=
 =0A=
@@ -200,14 +200,15 @@ kvm_static_assert(sizeof(struct vm_shape) =3D=3D size=
of(uint64_t));=0A=
 =0A=
 #define VM_TYPE_DEFAULT			0=0A=
 =0A=
-#define VM_SHAPE(__mode)			\=0A=
-({						\=0A=
-	struct vm_shape shape =3D {		\=0A=
-		.mode =3D (__mode),		\=0A=
-		.type =3D VM_TYPE_DEFAULT		\=0A=
-	};					\=0A=
-						\=0A=
-	shape;					\=0A=
+#define VM_SHAPE(__mode)				\=0A=
+({							\=0A=
+	struct vm_shape shape =3D {			\=0A=
+		.mode	  =3D (__mode),			\=0A=
+		.type	  =3D VM_TYPE_DEFAULT,		\=0A=
+		.src_type =3D VM_MEM_SRC_ANONYMOUS	\=0A=
+	};						\=0A=
+							\=0A=
+	shape;						\=0A=
 })=0A=
 =0A=
 #if defined(__aarch64__)=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index 28ee51253909..268a4520633b 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -467,7 +467,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint3=
2_t nr_runnable_vcpus,=0A=
 	if (is_guest_memfd_required(shape))=0A=
 		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
 =0A=
-	vm_userspace_mem_region_add(vm, VM_MEM_SRC_ANONYMOUS, 0, 0, nr_pages, fla=
gs);=0A=
+	vm_userspace_mem_region_add(vm, shape.src_type, 0, 0, nr_pages, flags);=
=0A=
 	for (i =3D 0; i < NR_MEM_REGIONS; i++)=0A=
 		vm->memslots[i] =3D 0;=0A=
 =0A=
diff --git a/tools/testing/selftests/kvm/lib/x86/sev.c b/tools/testing/self=
tests/kvm/lib/x86/sev.c=0A=
index c3a9838f4806..d920880e4fc0 100644=0A=
--- a/tools/testing/selftests/kvm/lib/x86/sev.c=0A=
+++ b/tools/testing/selftests/kvm/lib/x86/sev.c=0A=
@@ -164,6 +164,7 @@ struct kvm_vm *vm_sev_create_with_one_vcpu(uint32_t typ=
e, void *guest_code,=0A=
 	struct vm_shape shape =3D {=0A=
 		.mode =3D VM_MODE_DEFAULT,=0A=
 		.type =3D type,=0A=
+		.src_type =3D VM_MEM_SRC_ANONYMOUS,=0A=
 	};=0A=
 	struct kvm_vm *vm;=0A=
 	struct kvm_vcpu *cpus[1];=0A=
diff --git a/tools/testing/selftests/kvm/pre_fault_memory_test.c b/tools/te=
sting/selftests/kvm/pre_fault_memory_test.c=0A=
index 93e603d91311..8a4d5af53fab 100644=0A=
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c=0A=
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c=0A=
@@ -165,6 +165,7 @@ static void __test_pre_fault_memory(unsigned long vm_ty=
pe, bool private)=0A=
 	const struct vm_shape shape =3D {=0A=
 		.mode =3D VM_MODE_DEFAULT,=0A=
 		.type =3D vm_type,=0A=
+		.src_type =3D VM_MEM_SRC_ANONYMOUS,=0A=
 	};=0A=
 	struct kvm_vcpu *vcpu;=0A=
 	struct kvm_run *run;=0A=
-- =0A=
2.50.1=0A=
=0A=

