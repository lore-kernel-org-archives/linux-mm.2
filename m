Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F04B5CAC5B1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:23:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F18E8E002D; Wed, 24 Sep 2025 11:23:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A25C8E000F; Wed, 24 Sep 2025 11:23:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66A748E002D; Wed, 24 Sep 2025 11:23:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4E1538E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:23:07 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F1D3DC05BA
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:23:06 +0000 (UTC)
X-FDA: 83924511972.22.5624B35
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf18.hostedemail.com (Postfix) with ESMTP id 772511C000A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:23:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=JeWzg9FG;
	spf=pass (imf18.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zo29nLVVEqNQE60LDs8ecp6mhlnjq/VaFgPB1m/VqPI=;
	b=RNfpJ6mN40MMUivBaeX8GgB0L7HRic5Etj7qXYNyn5IMLa411Y6cV82lwYS31Lv1HtxvTd
	ErBR4okbRudjD9Q7MJRxn8hhOqPV8Cze+ghan+VB1TalxYT+EP1DW3h/FmcyQTc5OyhBnT
	/4CUUP091e7kW11r85ePExC+4mcHN98=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=JeWzg9FG;
	spf=pass (imf18.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727384; a=rsa-sha256;
	cv=none;
	b=MA+L/HyE9DdAE9OktRbIWoTXEehMdlmv76Om0Tzl0bNSox+TgebiYO3xoXfvZpxWeJ6HGH
	n5WODHa4BP8OUtuKRg/sPxiINcnc+vHoJ6WJErnfeMjvrGGfyO2KK0RYoOJOQciDY4UodA
	jXvp9q+vul7SF3Yk/JCc+tY+irX018Q=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727384; x=1790263384;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Zo29nLVVEqNQE60LDs8ecp6mhlnjq/VaFgPB1m/VqPI=;
  b=JeWzg9FGbJI/bed30NZlO8tRJNtDc1LQoMnrvRs5y9Ym4Wr1B6bPSOU/
   AbgazEqSog4EpWftnDYTa+jMn4yYPy7UqSBwuqFdjEP5+pbLKotZGOvUx
   rSbkweijIwToPHLPK4/NmceidZD6awVcbeZgfd6uSJjgKXJajTxVcBIxt
   Va/VVmk2eNC4lOJ/tP5h+Vr1d0PDcH5Qxgy0ISup1GIJtdYYCwF4qj0MK
   Uj9QZOwY8ZnKC6on/MCuig9qhglDEc7XLZ9C4RS8+AIX8gRc+pYuH9xnt
   5QyIy5B+t8ZDknDeA8oZu+76y//sKjZf7N42DKHFyIZTtzHBK2s7M4de/
   w==;
X-CSE-ConnectionGUID: NOVVk6GdTc+ry/BCCcWsqQ==
X-CSE-MsgGUID: H3J/emL5ShupkcGKPK6ptg==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2622601"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:54 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:10918]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.16.16:2525] with esmtp (Farcaster)
 id c6ec7cb5-6667-4a23-be25-5fd13c977552; Wed, 24 Sep 2025 15:22:54 +0000 (UTC)
X-Farcaster-Flow-ID: c6ec7cb5-6667-4a23-be25-5fd13c977552
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:50 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:49 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:49 +0000
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
Subject: [PATCH v7 11/12] KVM: selftests: stuff vm_mem_backing_src_type into
 vm_shape
Thread-Topic: [PATCH v7 11/12] KVM: selftests: stuff vm_mem_backing_src_type
 into vm_shape
Thread-Index: AQHcLWcWSBJv2Dh2m0ma3LK8YIjHKg==
Date: Wed, 24 Sep 2025 15:22:49 +0000
Message-ID: <20250924152214.7292-8-roypat@amazon.co.uk>
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
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 772511C000A
X-Stat-Signature: gsd3zjtaciz3zrdtddsrgx4y774x3ri8
X-HE-Tag: 1758727384-312745
X-HE-Meta: U2FsdGVkX1+BFi4/Hf9V+IsAjkOANxVDdDUJ/mytK/M+e7L9s8hGnJFR5789k9esC8NDDNAW2iQYcPJR0+CUIKmieqC9oueTn+qVEeUgugJPIlK7PjzH24zBlw1u9sgz6c/qHxOPA8MINPvSYjvIa/qYG/EczYCWSxvlpMVK6ku5I5h8PcCnzpNP/q9/hYDkOxcMBRiNQbLCROMUP6knROAIsehSyeucl8W040noNYw4nPTmlWOxtC76CJjpFCwDtfW4JblF3Quz0Ike4s+eTYzYTPovszoesxr7aPKYyQHb0adDrYmO8IuzWO9lAvkuupz5ARxEsFtlkAnX5vc/EoTjRsamU2AFxCKcJbKKN340tk7hVK2clblubMzX6uC5MXs3h5QNtW+g6tUfbzHDVbSxBC4t8yeZRqFb6HbmlsKHNgiZjsd7V8TnduIB3jp8kvcPnJFEAZbk3qcN5hYO0C07uDXYzuzJuGTzTWxmk/B0O2EG0g9NQxpmD5dfLG41cFOyCe4wmlBNpw75lhSu9CUzXeKs5Pf3yW1kL3fiwPWhxibrDMdzHdpFN2WmmC73WFrR74O3PAiYGby0L3Sp57QYKPmDe9XHEEFRKuIyxU7rDFV08M6wtVjKQDkaRlqs9m3DPxmZ9qCSYiRfyYFcPCd0CTYtxqObKnM3wHFHZyAcRwVIU/sxqSHMx6+ipgDXltOEHkkHWklf0oM9NY3p2mZtplZeFjI2vnmRwoypm9ewyMKDrdcwS4U8OC8s0BkTkEbphAa2qGZyvln5K7NOB8ramVti6H0bT2B3Z5dBThfvQsDu5t8v5bL4QXuPzrk7fbybev30cEAJHsaHdliVQkK67ZQV5CSjb6ReyGmbP6ZOFDO2FFiOaWrRTTboeRuAHIGsc4pyGMrZxhMKfEB2MOlp/MD3lkU3ny3bURsTHG602t8W/kgBs/0GtlKbbIfQR0bnvgia+FF+FH3bV0n
 tTyWLy6k
 P9G3xqeSgrhu9gjgani7YoZagNgxubSj6bd73RJSfa6hfCiKGmkumd82URNp1a97s6HfpxCvDYyFU5fTcP3bytiGXLv864Op4L2nYLP29tTl5HFYO7bDu6r5VGaSOAq6HNcEc0g6yyK+VL8k7i4gj/TVA0A0h76KR3rXC6ahh468WdWRf3zll3NJFm+jHh89loKpOnI0AEgZ4t3kg4TiGYuLHgeOOANa6fdiXNTr219GDDwJ9lhpk2jwvXLftmTI9eJM67/VETwWT4+9aT4EWyk/YaqPfa3GLh/iXHdEc6F+bW9ik3UCWsWPTWdwHpbeqnOLuiQ1w2niphcRowCMeuQVeQly8V1YAAoAcUA25ZhsDcjRYd+Cruq/TCH/W8IBO6AioGOqPKgz+AX8WN3dpCCWLfFWudKXaVJnNp4CIvYFM+0rggVYYKJtFxRushLoyaxxtoTa0UB79oAZa8dvn+X497q+CbaYvu4fFpP8zYxnLM2BzCObmIAFztz12vdgCaFdFObjIk9bOqsiOgZJAxwAM+AftEeCi9Fz4mcZ0K8AWXVvMyHq25X64eb2E6a1Gi1n5vLFoS2TL3BPXaVCk6dhVWyvUr6+HUQCokHy2jr+O0pSHZWNgdqSLeHsVVnR3o5dJIYT7LMLYXx5Agu4P4E6g/D2vbt8C1YnRHbYNkdKF72nwI+Ox55Z+3dnArnMtW8wVf2jz6OP3DIWS1VfErAcHm4hNLW9Xkt3UHsjhZ23COvgum7z5bJl/rEx0OCW6YwIdiG4HHyGiQnEyPvZ7wut+lUGzqVFlhKuHbHimBVYEeNiOl6ETL6s3G6wEVxavqDwGVSIsGZH+Mu42+RL6lW4W+gH+Y7kAh/R+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use one of the padding fields in struct vm_shape to carry an enum=0A=
vm_mem_backing_src_type value, to give the option to overwrite the=0A=
default of VM_MEM_SRC_ANONYMOUS in __vm_create().=0A=
=0A=
Overwriting this default will allow tests to create VMs where the test=0A=
code is backed by mmap'd guest_memfd instead of anonymous memory.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 19 ++++++++++---------=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    |  2 +-=0A=
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +=0A=
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +=0A=
 4 files changed, 13 insertions(+), 10 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h=0A=
index 5204a0a18a7f..8baa0bbacd09 100644=0A=
--- a/tools/testing/selftests/kvm/include/kvm_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/kvm_util.h=0A=
@@ -188,7 +188,7 @@ enum vm_guest_mode {=0A=
 struct vm_shape {=0A=
 	uint32_t type;=0A=
 	uint8_t  mode;=0A=
-	uint8_t  pad0;=0A=
+	uint8_t  src_type;=0A=
 	uint16_t pad1;=0A=
 };=0A=
 =0A=
@@ -196,14 +196,15 @@ kvm_static_assert(sizeof(struct vm_shape) =3D=3D size=
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
index a81089f7c83f..3a22794bd959 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -495,7 +495,7 @@ struct kvm_vm *__vm_create(struct vm_shape shape, uint3=
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
index 0350a8896a2f..d403f8d2f26f 100644=0A=
--- a/tools/testing/selftests/kvm/pre_fault_memory_test.c=0A=
+++ b/tools/testing/selftests/kvm/pre_fault_memory_test.c=0A=
@@ -68,6 +68,7 @@ static void __test_pre_fault_memory(unsigned long vm_type=
, bool private)=0A=
 	const struct vm_shape shape =3D {=0A=
 		.mode =3D VM_MODE_DEFAULT,=0A=
 		.type =3D vm_type,=0A=
+		.src_type =3D VM_MEM_SRC_ANONYMOUS,=0A=
 	};=0A=
 	struct kvm_vcpu *vcpu;=0A=
 	struct kvm_run *run;=0A=
-- =0A=
2.51.0=0A=
=0A=

