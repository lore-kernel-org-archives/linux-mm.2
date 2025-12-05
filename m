Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7954DD33990
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6EDB6B0148; Fri,  5 Dec 2025 11:59:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1F906B0191; Fri,  5 Dec 2025 11:59:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE7236B0192; Fri,  5 Dec 2025 11:59:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 939A96B0148
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:59:51 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 661FE88588
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:51 +0000 (UTC)
X-FDA: 84186029382.10.0838EEB
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf09.hostedemail.com (Postfix) with ESMTP id EA833140013
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:48 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=WaRPge4T;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d0fkQSK/G4NqBdB6Hn9NRubMn6LJOB2ByURYL1BmaOQ=;
	b=E2foqUYLCDfdTBmWYWYXV4uYIygax/vc2NXTp8Tu8H/KR3nGgAebyEfK1Qu8EmSwx4SWxN
	xczBXFV7ugSQem8pMw4IiHrUV4ae2c5P46k44FCK7VWr3EEw1awKRWHNAAs5AgJqT39gg1
	NIEquQXRpMPfqclrzvPltLiC5lpQYfo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=WaRPge4T;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953989; a=rsa-sha256;
	cv=none;
	b=KED2SeIHiXeO6YpE153iSZlFKHNF5XcBP4bEw1t/oMaLDgSZQOIfH+BIVrQVZN8nT7Yvui
	y22PbdjwDLasna9799h8H3pcMAdcPbGi6V9lLeEg0+cG+ZljsBsSzQsI/Ah/uFwmqpDtLL
	DiR1Ob2g/aofD/Tg7lJbh9VGdITtA7g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953989; x=1796489989;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=d0fkQSK/G4NqBdB6Hn9NRubMn6LJOB2ByURYL1BmaOQ=;
  b=WaRPge4TJL3k91alXnvS87bKHxNCyzODLfENsc2SLVlJsi3g/a+4m3hH
   Hy06/cO7006joKl6QUIboohf4NSbKsKqECgofDB77nuSAr+1GMwJX8qsC
   7zDxIeQ3BAGdWrkNdbzaoXxkeEkIo8oBMRbt79/Jv2HgSL9d/E/2Oda1e
   mrqnMs7VqMbc1ad1pZiH3A65x2+zZzE1K7neXvmVKkWFPXaetzv9pTSGP
   xe9y9c9WnWEtREqPN9GbEhLJVDxZpMRD9cboHVYTP4IxYlOLTcKXL1EWl
   RYKVAa09wg25YSkDZyE/WUm1JAXzFMH2JeSYTV1Cvtoxle2l1247A6j5O
   Q==;
X-CSE-ConnectionGUID: bnmufHvTQDaW1bi4gnrtaw==
X-CSE-MsgGUID: txDCSJQgRROMr7WjGghLjw==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6206122"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:59:31 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:4306]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.34.107:2525] with esmtp (Farcaster)
 id 1dd59fbf-337b-4e4d-998c-8c9374aef030; Fri, 5 Dec 2025 16:59:31 +0000 (UTC)
X-Farcaster-Flow-ID: 1dd59fbf-337b-4e4d-998c-8c9374aef030
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:29 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:29 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:59:28 +0000
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
Subject: [PATCH v8 09/13] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v8 09/13] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcZgiEOs+x69XXckO+A8F3rNWd2g==
Date: Fri, 5 Dec 2025 16:59:28 +0000
Message-ID: <20251205165743.9341-10-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: EA833140013
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: zqmuww4ms43dfw3z48119e31hsons4bu
X-HE-Tag: 1764953988-338343
X-HE-Meta: U2FsdGVkX19sySd+G7MC7zaEPOOl7e3YJA8acIW0BuaGJyf8RQwibLtrviZ1W0+B+MpCi/Y2wQrVB77DF16RXLW2eL5TAbD8z6rsaYJVUP35E34UOin6sSBOLCuR15rhsaS96W1kVa3ZAH33CTniEW6hZPZw5Q9IMu40M2bg+ETX79DolKNmMgbTih6JEjgLe8TnKGu7gqWRW3yDiNOuXcLl0hWl5LzxDToKD5MzPko2vYUe4HeKjFWL81aPrRms5bainrQARsBiJwEsHJrQ7k32oMwqEYkwLO8es/GceOIsXph/Pd3ujhrEC2VhLMj0beklgXSYHIJbpTH4IB7VCQ0MnrILbA2D9y/sUAIVdto966zkMsKRIRaTZkjFfKZGHvTH5rh7w032ppjks/PR/NSrzgZDREvsnr2M8NCTgeWBeDoKCqxlkxwyZS7+e91bpDSk5UD7k3KEfYPw0wehnQqsGHh9XuyEbixzQUzjC8dgDw4VnxiVsX1sHfPJ4FTmoCkpbk0BrQ5i7eHjvZgh1l5jOW8tIBmH/yTbGpIe2nTWSjE600nHa3Mhm7K9zysYjgdujtqT5t6XbusE4ZUztC1IVvScEaSfQj6jfUNseks7BR+XvYraoZGLWyuK6iQEDTkWCHNZKMc8moiC+VV7XjMGInIvVzzp2j8IdrN2YCZPrE3S6moMTVa7uKsMesrwxadLK7K9VIYFEw3O8mTIOUuUpZvkd1x0jK5PpmRjt/hn6KXzGivxcyAJP6rzPPqDF9bpzSF5L2wVcsjMGaACBGhqC6QOvzwYJnJDP1dTacqvlX+QVsf/KgyuBFJWS8d+uanlUlDULpH3VGyrsGrxqL6wCag1LWQc5eES+uRXERjDbrsWzlRzlMqGEXL5la/zoBt6GUlBUDUElZO/gt3Z5hdJzx3zBHhzZOv76QWIuvEUTxVnwhDJlqAVoy8Swv14P74y/ihniPCYMB9wwSV
 oZgwS/ON
 B3Zhd/fcEPLLKZ8NNbcsUczhe5uTNhroxhdtaoRFP0X24bHhxbFubzShOYunoyg9sPlMtIqM1C3/rTvkqrsbHjcfRgUgInf0ynyYCoClQagXN+vaFIuQglDqEHDZxCtIrkggNuCxiIrLNtpODD/yL6LPK0+VCvoSbiNte0QCyCXnE3r/NBGo+6Aou43zfC7bqq1SZQZYGisU83lq/McICBacbqLh2HyEWnjehlFFDZhnEUmbC3aKnrtrhAqUBqOa+LgNiVrXadslQLg9qdeSIeV+V3GALvsItjzYduju7w2krZOeDooOS9Z8uQap1M5BIzdN2xdeK6oPzeRFlPnlBidMtNl8lavFhIw08Kyez5fER/Vq3acrd5ygpsI2qmjH4tDv8LSq+iDjyFqyv42cdvp6dNb+79esK6IxWX2tdM+KkcTzyhQcLIM2E3TChc61GmV57V14YoXDiyxgHI4OeueQkaPRZroNHVYaSYU/4WlcYklXWDqOucw0l40cehwg/KNaThc1PlB6UzldpghDpxrxTjcjM3Fb1i6QpFLEsS5Ry2Bkjq2xUSfDZ/CV3EPy1Lzp4DNy3ep8dupmXZNpq30TZ2/qisVcfVELnbU6+LAqwLtBECSFPdKn6E8yEoQlrMEDvbADEw484IoMFf1PP6jn8EzWN0fFTpKk1YszmTWzPANHcjWPzlz95ioqjB4KYOZaGXE1f2sH0qnMJURlzZ0HDgMT8SF4iy9qpjrDjj6DjfbLCgClKvUwIdh88cT4xqdaSGS8riqeyDnMLxL7oxYy8EN8r+PUfPQQWII9liZyfc3E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if=0A=
a guest_memfd is passed in as an argument. This eliminates the=0A=
possibility where a guest_memfd instance is passed to vm_mem_add(), but=0A=
it ends up being ignored because the flags argument does not specify=0A=
KVM_MEM_GUEST_MEMFD at the same time.=0A=
=0A=
This makes it easy to support more scenarios in which no vm_mem_add() is=0A=
not passed a guest_memfd instance, but is expected to allocate one.=0A=
Currently, this only happens if guest_memfd =3D=3D -1 but flags &=0A=
KVM_MEM_GUEST_MEMFD !=3D 0, but later vm_mem_add() will gain support for=0A=
loading the test code itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) if requested via a special=0A=
vm_mem_backing_src_type, at which point having to make sure the src_type=0A=
and flags are in-sync becomes cumbersome.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c | 24 +++++++++++++---------=0A=
 1 file changed, 14 insertions(+), 10 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index 8279b6ced8d2..56ddbca91850 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1057,21 +1057,25 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
 =0A=
-	if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-		if (guest_memfd < 0) {=0A=
+	if (guest_memfd < 0) {=0A=
+		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
 			uint32_t guest_memfd_flags =3D 0;=0A=
 			TEST_ASSERT(!guest_memfd_offset,=0A=
 				    "Offset must be zero when creating new guest_memfd");=0A=
 			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		} else {=0A=
-			/*=0A=
-			 * Install a unique fd for each memslot so that the fd=0A=
-			 * can be closed when the region is deleted without=0A=
-			 * needing to track if the fd is owned by the framework=0A=
-			 * or by the caller.=0A=
-			 */=0A=
-			guest_memfd =3D kvm_dup(guest_memfd);=0A=
 		}=0A=
+	} else {=0A=
+		/*=0A=
+		 * Install a unique fd for each memslot so that the fd=0A=
+		 * can be closed when the region is deleted without=0A=
+		 * needing to track if the fd is owned by the framework=0A=
+		 * or by the caller.=0A=
+		 */=0A=
+		guest_memfd =3D kvm_dup(guest_memfd);=0A=
+	}=0A=
+=0A=
+	if (guest_memfd > 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
 =0A=
 		region->region.guest_memfd =3D guest_memfd;=0A=
 		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-- =0A=
2.50.1=0A=
=0A=

