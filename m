Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B86ACAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:22:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61C598E0029; Wed, 24 Sep 2025 11:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CE7C8E000F; Wed, 24 Sep 2025 11:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4950B8E0029; Wed, 24 Sep 2025 11:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 325A98E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:56 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C5CB51408A5
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:55 +0000 (UTC)
X-FDA: 83924511510.08.A7858F1
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82750C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=LKBfGiCI;
	spf=pass (imf28.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJuRX5x4RLfTnYWVN5hpYKhn0fZL0PjDC+6I/zQlvOs=;
	b=tQkeXraQJXOIZdf5AZsqoN6TaVaE3rRA7jdMNVFE33yu9P2hpgUuZdLpziS0mzVpuonMzY
	ecowvWsSRpMry+O9Vk1OzJROtBpd7J0zlZeAyfpRSnWpHDzo5hQdu6YGqV5JYO3TzUd7ZT
	e84J106/yRn31/FYSST4/ISMgbUZ5lM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727373; a=rsa-sha256;
	cv=none;
	b=KD0ZJEXr6uCnGCjiFEvZynw+fO25dKgtAZ94lSsAimLKXVQgDyD5EN0gpesCk+LfcKxSFK
	x22fOeJS7LoS22C6Uea2a4cbq+8Sw1RaBedHQ9QczOGrjgBHBiSsfhsnyKtANgpiJv8Jrv
	qdcztFHlWZF40rrQjnNM1tSBQdlIKbk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=LKBfGiCI;
	spf=pass (imf28.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727373; x=1790263373;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=NJuRX5x4RLfTnYWVN5hpYKhn0fZL0PjDC+6I/zQlvOs=;
  b=LKBfGiCIeeD9mhxvrr6YEXlMCuYeGa/04txGAOigVk+dAKl3G+djdwUU
   m91pJLWOLFR26fbu7ZCs0KRWHvRKEMD/FURYOtRV/miMXE4qX1ovhWcIP
   WaOOLVKzv6RnXgDYCTOCzQlQkjwOsoQCwm2lV9++W/jGtmiMq9qsVmt0Z
   1KHRZCdWWz6S04FFKqn0FQMv7ovx+3PrbvsIHf30/PP8gHkWIZ8xev45u
   1PzWwPjO/RHll0ma6uSRmJEzXTqp2x4xXGvKVrF1yZ329DN/mln1hKqQ4
   B94asQuJJt3RHRyMaOEVP1gPDbgtX2qBFnyOuTwi1PHhAFxUZtmhlmnhp
   Q==;
X-CSE-ConnectionGUID: W1lG3sLuQUmOPmRkcn+P0A==
X-CSE-MsgGUID: dnAkDuHpQ9awPPekd+2ukg==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2515620"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:51 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:18646]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.5.254:2525] with esmtp (Farcaster)
 id 77812a94-48cf-487b-9907-25d72d745b01; Wed, 24 Sep 2025 15:22:50 +0000 (UTC)
X-Farcaster-Flow-ID: 77812a94-48cf-487b-9907-25d72d745b01
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:48 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:48 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:48 +0000
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
Subject: [PATCH v7 10/12] KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP
 in existing selftests
Thread-Topic: [PATCH v7 10/12] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Index: AQHcLWcVDySwa3KGykqApf1wGV1RGw==
Date: Wed, 24 Sep 2025 15:22:47 +0000
Message-ID: <20250924152214.7292-7-roypat@amazon.co.uk>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
In-Reply-To: <20250924152214.7292-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 82750C000A
X-Stat-Signature: 4kgkhjb3sw5cmt4hi49i6saix474sffs
X-Rspam-User: 
X-HE-Tag: 1758727373-421302
X-HE-Meta: U2FsdGVkX18+umUQ6GKGFPxf8IsKYu08JDDAYPhwn02Zwsmm6xhmfaDYHk7+2m4Q8e8QdKH4NpyFSvOtYJODS/VteSthpd8F9jOVaj/QUFnIdGOEfkUO4TSyVk+7pn23i2qk+Ja9bDNE22lUn2u2jmtG6ez/EmqBIcmhJd6yNlK70v7HBppTQTKyIb1B6TKtEW07Jgb88NW0abND7pc/HjvAN5Gx0+1OSatoUya/xxdMMpS6XiZa4L04P+/N87+WBxaW6An1GGtQRlcyFdQHFIoZ/5Q/+Y8yheUBunQzklVe0UwbNYvVrArfJICW4kkEOw4tQ7L9dQCt6w85c5h62NyVQqjPotpedMy0mmC2YTYIYY50a+udV2EfCRdxHcgEvXRIG2HXErT/H80KC+V51m+rGegvAi1KjE/wRG36IpZrezY6kDQQtjkAp+E7OYdlPWjMABgiY24Rhp1tSTtCcW2OWhk5/bFPX5DC3dgYgy7+EO1qsZi1svypInG300fUVC7XY0YQmX5pi0pfW00jE/pUE8Xt+dQxqIFO5ZwcC1IH8dhzLwlSbgf5DCT/NZsilO94RQjAQyaY8PZcJn3knf/tK+AI8hHtOAja0g0UfmvI9cijR8Coq0Fj0e8UJMo8CDiUjfwF7GxnX9C2XppsehHDYN/x3pdMBN0PlxA9Fo2K7iDNuFCl9Z7h2+pAgpLycOEUghgMcbVV39BdXGRHz/8qbnGCT+e6b9WMhTcbgDBLAhXvoj1lmGnkRLBN9qIxZ5UPgEN8hLbFND5tGULgVndKPU7f4iL8ThQ8bx7wKxr5HHFmMDt0FX1bLusC3dxwgHrulx+fN0q13L6k8ZECxXaYKdzW9wTng5SKypaqlPPJ8ftEY0J7I4Z37ISqKUfHBZl/y8BOYrFgJA72kaOS/FOgAndndG3QUjKCS6B/PyB3TzFf5B8/oOEZqwC7FPnzqx+ijm/KZibspqhoDg6
 P290d4z5
 Tp+i8272JzHJD01apIOrxS8uta3pp3djJJQcXWFxHm6rJvlwz91U+YHsAMKdLxQ5nIdy/8S1EHMoprR1lIXLGsGOxAMixmTbLsFp9LoWEnrFQVSgj8HzF4uIQZGLaT3GN50kkZdTDwUP8DIP6UsEDqUcWJ88xSvNAJlZ3xOYLWFg127D/VYbOlK8tM+1GUghcc9vhfKjcvcJTSWCjjHBFDQJucfR/SdwRnMV/q+zFqXPGzSSf2Rr/NaksE8NK8JH0EyYWTaa35rCfIghjLYHEACWMIKnAlDDNIOlDc6A1l1P+vZVG96RLBKJPUngi3xA563KbyTKHtRP2/Y43hCi0bdBe8tCS9MOQtwAJbtarfBQ+qAKSHrlIrf0XSyc3J4m+DKqrkCLBAfi7psHbKCLOlIgdfVc/5CMMdimaZgDeIwIpHx4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend mem conversion selftests to cover the scenario that the guest can=0A=
fault in and write gmem-backed guest memory even if its direct map=0A=
removed. Also cover the new flag in guest_memfd_test.c tests.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 tools/testing/selftests/kvm/guest_memfd_test.c             | 2 ++=0A=
 .../selftests/kvm/x86/private_mem_conversions_test.c       | 7 ++++---=0A=
 2 files changed, 6 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c=0A=
index b3ca6737f304..1187438b6831 100644=0A=
--- a/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
@@ -275,6 +275,8 @@ static void test_guest_memfd(unsigned long vm_type)=0A=
 =0A=
 	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_MMAP))=0A=
 		flags |=3D GUEST_MEMFD_FLAG_MMAP;=0A=
+	if (vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP))=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
 =0A=
 	test_create_guest_memfd_multiple(vm);=0A=
 	test_create_guest_memfd_invalid_sizes(vm, flags, page_size);=0A=
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=
 b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
index 82a8d88b5338..8427d9fbdb23 100644=0A=
--- a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
+++ b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
@@ -367,7 +367,7 @@ static void *__test_mem_conversions(void *__vcpu)=0A=
 }=0A=
 =0A=
 static void test_mem_conversions(enum vm_mem_backing_src_type src_type, ui=
nt32_t nr_vcpus,=0A=
-				 uint32_t nr_memslots)=0A=
+				 uint32_t nr_memslots, uint64_t gmem_flags)=0A=
 {=0A=
 	/*=0A=
 	 * Allocate enough memory so that each vCPU's chunk of memory can be=0A=
@@ -394,7 +394,7 @@ static void test_mem_conversions(enum vm_mem_backing_sr=
c_type src_type, uint32_t=0A=
 =0A=
 	vm_enable_cap(vm, KVM_CAP_EXIT_HYPERCALL, (1 << KVM_HC_MAP_GPA_RANGE));=
=0A=
 =0A=
-	memfd =3D vm_create_guest_memfd(vm, memfd_size, 0);=0A=
+	memfd =3D vm_create_guest_memfd(vm, memfd_size, gmem_flags);=0A=
 =0A=
 	for (i =3D 0; i < nr_memslots; i++)=0A=
 		vm_mem_add(vm, src_type, BASE_DATA_GPA + slot_size * i,=0A=
@@ -477,7 +477,8 @@ int main(int argc, char *argv[])=0A=
 		}=0A=
 	}=0A=
 =0A=
-	test_mem_conversions(src_type, nr_vcpus, nr_memslots);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, 0);=0A=
+	test_mem_conversions(src_type, nr_vcpus, nr_memslots, GUEST_MEMFD_FLAG_NO=
_DIRECT_MAP);=0A=
 =0A=
 	return 0;=0A=
 }=0A=
-- =0A=
2.51.0=0A=
=0A=

