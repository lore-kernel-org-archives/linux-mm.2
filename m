Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E56EC8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 09:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA0C6B0031; Thu, 28 Aug 2025 05:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A85F6B0032; Thu, 28 Aug 2025 05:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 688586B007B; Thu, 28 Aug 2025 05:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 48A406B0032
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 05:39:37 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 114405C184
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:37 +0000 (UTC)
X-FDA: 83825668794.21.3A68BFB
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf14.hostedemail.com (Postfix) with ESMTP id 89B8B10000F
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 09:39:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=DUFA81dm;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756373974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ojtm9hG3uDHHN9CPzAzA1kwd7CoLxip6b5f2qHGneMU=;
	b=fhZwpreiaQsNwSzaA92yt3kTZGtYwkmcrumVUc9xAIuAHZ2LmpqxBtMleE4xCGMyG1U22d
	x+tjPTIA5lZLO3BwdUKg6VXYTbMsKH6L60iEtF+CYz4UIyC3G1F51mAtHsi4uJppvjgdGh
	u2VgX3DjJNabHV5if03k97fhlVfZ6K4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=DUFA81dm;
	spf=pass (imf14.hostedemail.com: domain of "prvs=3288f7157=roypat@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=3288f7157=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756373974; a=rsa-sha256;
	cv=none;
	b=ZQ/XnBOG5bKkl2CtTqu0LqVh4LUSF4oNsED7YLVWR6h7IpfkMuy1mjmm+7ykjqu6YmUPFM
	aGr1/sbBX0r+0D2hOxiYnTmH+yfqvztRh3h6O2q9njlndcA6MNC0/7qSiRkHsJFLkCQ4OO
	45AvZHJxVR4oFMjnM6enn+LWwZAszrE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1756373974; x=1787909974;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Ojtm9hG3uDHHN9CPzAzA1kwd7CoLxip6b5f2qHGneMU=;
  b=DUFA81dmeQAQp7k3BdpYx/fkuFdJNBVDcHuFdcM4Xs98lDR4nbFiYl69
   lCJhkE1NCpBcKljLOiFLiLBJoaua3ybL2Tgz0CMw3CPmu3eR+2sgDBQME
   E8iJh4luggE2PHpVjr5Op32S6E6Aes5A2LcJcXa/Z50AE6y+V0s1jqo/H
   6ev/1SJOo5DHjjOyRasl5agvc2VWmbd11+rgJsWW9ANT6x62u9mT5ALlh
   cpzmSdCon0FyJIjfP2BpqyxDjyKC29KOGbrFHVkqjDkqkqqA6Oav1ZvtL
   E61QoqSi9g4JP6zgsVAA8l69wEaeUH//lkGuOIust0UXlSilcIuKtKT54
   Q==;
X-CSE-ConnectionGUID: RbFhNUEdT4GAw4sjaHWgJA==
X-CSE-MsgGUID: rBTTxvnjRyaNUzDadwvW4A==
X-IronPort-AV: E=Sophos;i="6.18,214,1751241600"; 
   d="scan'208";a="1303847"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Aug 2025 09:39:34 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:21352]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.1:2525] with esmtp (Farcaster)
 id 7011dc75-05c8-4dc5-9da1-0763e3fb5b81; Thu, 28 Aug 2025 09:39:33 +0000 (UTC)
X-Farcaster-Flow-ID: 7011dc75-05c8-4dc5-9da1-0763e3fb5b81
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:33 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.17;
 Thu, 28 Aug 2025 09:39:32 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.017; Thu, 28 Aug 2025 09:39:32 +0000
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
Subject: [PATCH v5 12/12] KVM: selftests: Test guest execution from direct map
 removed gmem
Thread-Topic: [PATCH v5 12/12] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHcF/+ov3wHy4Cyx0u9xmPfJ46Qpw==
Date: Thu, 28 Aug 2025 09:39:32 +0000
Message-ID: <20250828093902.2719-13-roypat@amazon.co.uk>
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
X-Rspamd-Queue-Id: 89B8B10000F
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: phcmxiorjejthfyn55bfix3qa3jqmbdh
X-HE-Tag: 1756373974-313411
X-HE-Meta: U2FsdGVkX19dge/OdnhtHXyy1/ccd/CJmGbeW2Pqceo2SzYUvGDlRPs6U9qDzRBq0jB/eixfgG8U6f2s0bf4tsD4LkuAZKq0GyhHM3JgafyU1Fvlk3J+D8fGUwoUBEYhdTO+XNqjFzJ/K+1tbRP9V4rfrv61wl7HcLzsS6e84qXyPrNei6IXso7tGT2AP5My6uNSeZEh8HcYfTdtt0YQqF16gfmWhlXkqvnjO7y2v+W4dNgJBpWG4BGbTtg8bo0SNuprps6ngY8Y5uvc1/tb2DIaONmfomVytfS5qNAc/7AXDLOeS6K3AsUcvG28CaLPL0WmViioA4sw1QWmJbO2pvef+EoFYT8hJLWfxuUOjmTZtzXt5rqP7x5cGDy5irXmu5vbtm2E+v1D/iq+A15nglz8yw6dYAFOOaacQWZ65yyK+0R8F7dzOrcf4+3z9lFRuh2EOSjEpWVF/W/AhMGEQkGVNpyc8XMTj9VC437Tkrvy7UpCB2qN/Ap0BChKK+UaEFtUJKrMZtr6CwjsdRgFsbNs6wQ455j/MW8oX3+2ZCDJ3/YERcAGrIPTlb4tMhg5/P6IzAkl4b/Xm+DtnGi+N3LSARNvI8bvqw1xdBa+Vzvppn7TUUDC21EoqIuQoamaWuvDUozC6S8iJQBOzspgot6zd9jqSm4ahl70n5clieJGSpl/t2nvJE/TkfYlzqAKuIBVumrj4FrgL1XS7u8K1nwh3amqMxAJfe6T6d9ze1T7zCmOHFehZqr5KE1zUerh7sH/CDQScPZWT6nba0CnKcSVWoUGV1uLs55zT8Hy3jQH6JN8RSEt01eS1EP6k4W8phxVIV8gcW/2rjt3x1UguL1k45F40Zi7WP3zF5oyMuHkStr8u3xzaXmjdz7mSlFP1/OwI8axdBRrC8bN5/iD70kIPr+Zpn3OkAw/uw8Oh/puzFF7tCogUOIgK1pvb0wEQNQ53b7trTqxhmBTmXs
 qJded+lP
 vCRwpqLp7K3J4IVPHAc6DC/er5p8ucedeA+gDWkrzck/TJMqDmMarBoI7vldfgZal0pg3soLDwwpmZLgNAEsJwa8BYKS3S4gDbwlsPkm59WMiw/3grx5ulEjIGkol+kd1RPrss3NfZfvSVXtgsxrWfaN8MtfAo2wC/nHWL0mYLoCMseLolj9Y/zao5ljUzG+MRonD+kTypXvuTS1yX5UL/Y84M1aqmv5ckenucD3ybmmeUIExO/cFYpYxsSD4EJo8CVrw6rRVw/qY2uSisJONRpFLp3wRXx1RLif1mtln1uHobGP+A7XApOnjSF+uljT1l1wCwKqqA61tuntrpUx6t9AMo059riLPPme1zOAmEQiwubl3Fn3IiW3wUanytJqH0j6KZLfckMj4b/tLq2rrF5rBAZWsfKtmINQCn/u0JdUHZ1UQMZyKFFk8xKizLWBOcdjYyuFGc7sSKadzYXidada0pIckjiKKJKGloEt/bEQPQVeShyvWzxzzlM5/+WfbVZkuoT0B5x0XNv6vhsL7X+t1qE18N5tEFLPd9ciGG8DCCgFKgiiqcXx5E55Gw8oFpatlOk3oe9C+1hskyVTtKAd0PpW2FjZDW00napqOm9CMfPePspsZBokbvGLIgSaNd8mf4hwk/4AL3F8ByeiCIXHBc019OobWthsqaYdcfWvcw0RPGnZnNFvEWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a selftest that loads itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) and triggers an MMIO exit when executed. This=0A=
exercises x86 MMIO emulation code inside KVM for guest_memfd-backed=0A=
memslots where the guest_memfd folios are direct map removed.=0A=
Particularly, it validates that x86 MMIO emulation code (guest page=0A=
table walks + instruction fetch) correctly accesses gmem through the VMA=0A=
that's been reflected into the memslot's userspace_addr field (instead=0A=
of trying to do direct map accesses).=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../selftests/kvm/set_memory_region_test.c    | 50 +++++++++++++++++--=0A=
 1 file changed, 46 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/t=
esting/selftests/kvm/set_memory_region_test.c=0A=
index ce3ac0fd6dfb..cb3bc642d376 100644=0A=
--- a/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
@@ -603,6 +603,41 @@ static void test_mmio_during_vectoring(void)=0A=
 =0A=
 	kvm_vm_free(vm);=0A=
 }=0A=
+=0A=
+static void guest_code_trigger_mmio(void)=0A=
+{=0A=
+	/*=0A=
+	 * Read some GPA that is not backed by a memslot. KVM consider this=0A=
+	 * as MMIO and tell userspace to emulate the read.=0A=
+	 */=0A=
+	READ_ONCE(*((uint64_t *)MEM_REGION_GPA));=0A=
+=0A=
+	GUEST_DONE();=0A=
+}=0A=
+=0A=
+static void test_guest_memfd_mmio(void)=0A=
+{=0A=
+	struct kvm_vm *vm;=0A=
+	struct kvm_vcpu *vcpu;=0A=
+	struct vm_shape shape =3D {=0A=
+		.mode =3D VM_MODE_DEFAULT,=0A=
+		.src_type =3D VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,=0A=
+	};=0A=
+	pthread_t vcpu_thread;=0A=
+=0A=
+	pr_info("Testing MMIO emulation for instructions in gmem\n");=0A=
+=0A=
+	vm =3D __vm_create_shape_with_one_vcpu(shape, &vcpu, 0, guest_code_trigge=
r_mmio);=0A=
+=0A=
+	virt_map(vm, MEM_REGION_GPA, MEM_REGION_GPA, 1);=0A=
+=0A=
+	pthread_create(&vcpu_thread, NULL, vcpu_worker, vcpu);=0A=
+=0A=
+	/* If the MMIO read was successfully emulated, the vcpu thread will exit =
*/=0A=
+	pthread_join(vcpu_thread, NULL);=0A=
+=0A=
+	kvm_vm_free(vm);=0A=
+}=0A=
 #endif=0A=
 =0A=
 int main(int argc, char *argv[])=0A=
@@ -626,10 +661,17 @@ int main(int argc, char *argv[])=0A=
 	test_add_max_memory_regions();=0A=
 =0A=
 #ifdef __x86_64__=0A=
-	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD) &&=0A=
-	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {=
=0A=
-		test_add_private_memory_region();=0A=
-		test_add_overlapping_private_memory_regions();=0A=
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD)) {=0A=
+		if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM)) {=0A=
+			test_add_private_memory_region();=0A=
+			test_add_overlapping_private_memory_regions();=0A=
+		}=0A=
+=0A=
+		if (kvm_has_cap(KVM_CAP_GUEST_MEMFD_MMAP) &&=0A=
+			kvm_has_cap(KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP))=0A=
+			test_guest_memfd_mmio();=0A=
+		else=0A=
+			pr_info("Skipping tests requiring KVM_CAP_GUEST_MEMFD_MMAP | KVM_CAP_GU=
EST_MEMFD_NO_DIRECT_MAP");=0A=
 	} else {=0A=
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");=0A=
 	}=0A=
-- =0A=
2.50.1=0A=
=0A=

