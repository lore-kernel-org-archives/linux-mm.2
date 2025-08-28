Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EABBCC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6138C6B002E; Thu, 28 Aug 2025 05:39:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3926B0030; Thu, 28 Aug 2025 05:39:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 268FC6B0031; Thu, 28 Aug 2025 05:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0B6096B002E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8902685414
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:35 +0000 (UTC)
X-FDA: 83825668710.06.D52AA05
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf28.hostedemail.com (Postfix) with ESMTP id 25A8CC0018
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="G635qR8/";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf28.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373973; a=rsa-sha256;
	cv=none;
	b=Kwr17O2NhSaTxLBrmw1dwQMslPUmFAqMjnZT+q1iFjJLrHt2hTyqL3b1VXZbKCKTUsHX1i
	2StqpS2XoV15eAXsMg6A+oyHMU6pgXNFAx4pmhjpv58SjgL63cpq6VAfENyZxXeouo6ER4
	bNkAZ7VRCcfNkZUIm4Mj6TGCdeLB3wI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="G635qR8/";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf28.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2GKsQpLhDwEigIcg6L6Ns++AnIJyQDate+xl8DCsoZg=;
	b=mqfpuFJ2guBvnIIRod1pbCTtBf5Xk+eN/T8VHSAdA0G0SEmzjAc+e9AM6BuRauUMn0u13i
	udl+9FITgPFlU00bYSmaLZzKUTRSDDBGFP05wsp1TV84JtLtwdOqjN47G6yTXD1n0g17xW
	rygyS1AGKQz1P0FBDI9QkjRbnZBCBxY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373973; x=1787909973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=2GKsQpLhDwEigIcg6L6Ns++AnIJyQDate+xl8DCsoZg=;
  b=G635qR8/xDcO8Wrv8y3JFeL9FXfKaJojrlyLzrLq5GHCJR8AiDI6StwP
   38c7Iq9+7XSGNC7d0azEHf5bVv5uXVliey+ozyrLfCCshsvdnMlaotXO9
   oh4EblbKJY9bD4ywpQIr83AqzL4CUr3qaazE/ZFePDbrFKqCvmkio/XAU
   KXug8Gi7u1JAvKgZ58xwLftQ27zosFfGcs6rH7PR3YI4FibWx+5DFSut/
   pgmxbNBYKBPditmic1gWfH4+agQKur3poOMn9e9M4a+qh3rfsrr+NLl56
   4IxPlK58vHrKBIACM0yrCEhfrDrfav4sodHvLtSxv4Cim4koIDcSA4qxX
   w==;
X-CSE-ConnectionGUID: lWd8i2WJRJqgu4AJCZSeLQ==
X-CSE-MsgGUID: EUKWcsB7TEWoNzzYRDs/cA==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303840"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:31 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:30454]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.42.3:2525] with esmtp (Farcaster)
 id b6128983-88e8-4af1-9711-47b2713193ad; Thu, 28 Aug 2025 09:39:31 +0000 (UTC)
X-Farcaster-Flow-ID: b6128983-88e8-4af1-9711-47b2713193ad
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:28 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:28 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:28 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "david@redhat.com" <david@redhat.com>, "seanjc@google.com"
	<seanjc@google.com>
CC: "Roy, Patrick" <roypat@amazon.co.uk>, "tabba@google.com"
	<tabba@google.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"pbonzini@redhat.com" <pbonzini@redhat.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"rppt@kernel.org" <rppt@kernel.org>, "will@kernel.org" <will@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>
Subject: [PATCH v5 09/12] KVM: selftests: stuff vm_mem_backing_src_type into
 vm_shape
Thread-Topic: [PATCH v5 09/12] KVM: selftests: stuff vm_mem_backing_src_type
 into vm_shape
Thread-Index: AQHcF/+lpVChiqeOEU2vKPY3yGmqIQ==
Date: Thu, 28 Aug 2025 09:39:28 +0000
Message-ID: <20250828093902.2719-10-roypat@amazon.co.uk>
References: <20250828093902.2719-1-roypat@amazon.co.uk>
In-Reply-To: <20250828093902.2719-1-roypat@amazon.co.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 25A8CC0018
X-Stat-Signature: 8nfmucermc66azn15epua69wrxhjo6du
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756373972-140507
X-HE-Meta: U2FsdGVkX1+OWZMxzAaZQV0IrLR6wfvtq71yNf1NJ4dsmQ6D179S9FTl+snnS3u7dFjGoeN+HKt0H8gHp5M1wasbvM14mZ2WFkXwSL99v31yrGJp6MOMFnV0bp2djzDMZo3TX7/HZPBJJZrn2b7o8H+EF1E9A4xH6QOrrSi4i4jT2lTJ4EByr57A+7EhqA/BT7MeFaASeDzfcIKZyNwcO2eT+NM8PXlOmdBJGJviq6ZaWaG8lVAsxL9V8M5lhwzN9Y38Wm0U3l7zFu/QdMOqIiX36vgd18dRdkcedmIIwiSFTgwa6JSHZxP2zKvBt/tIbbqoPnsCV91R4L7+Q736yQC3p5kq11zxqr5PXU+Hq0mjxKIhUqEUEuKxZ/sEWdJmeva6HdWYSOvtyYwb9MWPItZPVu6qE6kUOsUVR+pQRzasT3vSz/VNinC0jHhFqi6rmqpvnrogEqS/TuXfQz4IzHvtYQCybyEizCf8CfbGaHYiuGuNs9ofWU6wOyBRqwURi45waKsz8UEi8BQ+wbl+H+yv4q3uQg5JSOGZepmjaV41v5dPAQdr7gkJHwa6vfw5jCxUGca3SNf5LGfyr6KR5EF5Cj4lp8iSaWLhMTdaE70ENFu4k9syzdrpIk9/WG4ZgkqgPjI3Wg4s9Z1ob9YlCeqoK6hLHN65q6MS6i8VoYPpf32R7MtO5UdFOq0aJR9iF3C66jkZejgtYeALuECdwb49ppA2q4s/5zfepHa7vpW3XmBTql89yFUyXOLeUz2MSBqNL4sBGv6eyoLMzzEiTRKhIviWKODu9IMlkzLpw2D7bHHHvjYd3nJr90tVxcbWVS5JZySHpZqs1Nke0Vq5sQTDmgcjJw3AEUsLW+zrhZ/VOc3RwCainOI8tiLhnqznjplmGpYG2eWAOX9j7H4W0BmuwNeDhxfkLC0ar8lyY0bpgOGHFKQoH79Ytql1YJLnWbJLL/EGl34L3MQBc2k
 QB88GX37
 LgS2NRkRvQUolZaeteP6zB9dMJ2i3Wjc2/TjDgByQDvjiDdwhrONnMauQgHAY93A2X/pvg4NEtsbwRjV07t7qdC4xNeWy7q9SYBxyzZuwYsJq1efDh+MiQhkm1zZh8wVOv/DxlC4NJjj2jPNAql7/dTi6BHxJHH5yDA6UKEN/Qbsm7BsTXsZgS1jQ6OD/k+8lPc3KVO8WEIEqzmLv9qX+pOpRtIehyldqRbKF8EvpN/blAVNDPH3iC4uCQ9aI5+PeQGIou2c0/FiJhQcVdchieZuXfvZK0Ed3BSwLR/u86TDa8zwR86QpeFIVaXoPeUUF9wVNKa0o5vuLItyujvnTKmNLqrmOhIBHeX3TaCpKa072SMkJ3zCBaRU6qW11wUM20aLSQnC453SskZWpz9AavTP0avX8CN2oWiW7+f0Tn85QrW9wwZzhAfsWjEobEKfh2zastTSgWWTWRVJml6HpSp35/5nFj4pWyDDKHr7XdyHY5VMJ6fbfy7FdCHBAVsuj27SeZI5jFpjEPGxPN9D/mSklP6M1KxjUTd+528CCnRrrduJU/ovFZfXEHnj0nzE31IlEhrQnWALqHJwtS4N0FdlcPyHC5YrVMrZO4glDBUiCtnPjIHdsvK17ELXd40Hy5YNSapWVh4KkdKYD5F6n4pna6jsfv6AgyJmpmxKlpVnYPDuJN5UtJd00apdh1b87U6imc1EOZQX2YYl+sPfyLdDMhXuRbm16KcqCu2u6JOm5/jI=
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
2.50.1=0A=
=0A=

