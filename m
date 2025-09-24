Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CDCDCAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE8FA8E002E; Wed, 24 Sep 2025 11:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC1188E000F; Wed, 24 Sep 2025 11:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3A968E002E; Wed, 24 Sep 2025 11:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 907F28E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:23:08 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 544E813BDA3
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:23:07 +0000 (UTC)
X-FDA: 83924512014.26.CCDB033
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf21.hostedemail.com (Postfix) with ESMTP id DE14F1C000C
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:23:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Xe6tUH6Z;
	spf=pass (imf21.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FC0wlYdU3H6pxbJnzrvR8fYAavscI+YR5lWUNyKVjNo=;
	b=pOCn5e8lKAic16AHEllSS8LsLNVdvvFTUXCF2DpAiPACyyDMvoMZn3qu3BvwP07EOTw5GV
	Yp8Sbw8m0cMs6xw73EtuGlwPK66cXHC++MnIB5v4DwnQ66pGZ0J32Xdmt0mfkwUp9cYDxm
	7POpLc7eq/Z1itkMHRgPxmAT18cAJQ4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Xe6tUH6Z;
	spf=pass (imf21.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727385; a=rsa-sha256;
	cv=none;
	b=eRmrJVmZmkBaUeOuxI/kbEjYC0ZMkyM88RVKOQUhfbEtxmU0pfSa2yVxBnMMSCHHbrEAZb
	p0hc5WlkpVGL3AwsbNlAsJ5bEOVkqfZ8EBygDxGpwSZP3n1OJkThZoCLwVRNqz0GirysrD
	lHoB9BU9sJ3DGvNQCkrePxQE+PmWQOo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727385; x=1790263385;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=FC0wlYdU3H6pxbJnzrvR8fYAavscI+YR5lWUNyKVjNo=;
  b=Xe6tUH6ZHtqS/xrTMSDpIKK1p07lYCW1euN18IkEgR/nyA9NJJLG4m0a
   +cyc93/VP71eowjqNbrWpet01DGyFoqpIWlVFeXK9FWhc39IWUOLqy5nS
   vWr5xzcr2f9A/d/8IMPh1fuqrDcuYpfZv+1mIBH7L50zcmlMjslomH7Z7
   qqi2RyXLGFIcV5mo9nnOpXcTPFo49GNiLbjCgkGrxHTbf5HBtJqtvjmXS
   22S0xlRR8WsviIgLf4Gidct0qfI3sU6VVE/TUuoAGjbejQCFBPn67KDXW
   77EuDWwHGBV4VW4OhbfhVpgFnXabaiRldtsLG1rJ5LPmczZfLtJ/Y6qkc
   w==;
X-CSE-ConnectionGUID: bnqBIY0+S7ugHJxPMWxQtg==
X-CSE-MsgGUID: vtWk9PxTTeqaCk4lc38v8Q==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2615697"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:55 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:17289]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.38.97:2525] with esmtp (Farcaster)
 id f8fd47b8-ee11-4f7c-baeb-49adbc882bb4; Wed, 24 Sep 2025 15:22:54 +0000 (UTC)
X-Farcaster-Flow-ID: f8fd47b8-ee11-4f7c-baeb-49adbc882bb4
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:52 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:51 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:51 +0000
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
Subject: [PATCH v7 12/12] KVM: selftests: Test guest execution from direct map
 removed gmem
Thread-Topic: [PATCH v7 12/12] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHcLWcXXo32DUDFrUWE2L4osbrEFQ==
Date: Wed, 24 Sep 2025 15:22:51 +0000
Message-ID: <20250924152214.7292-9-roypat@amazon.co.uk>
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
X-Rspamd-Queue-Id: DE14F1C000C
X-Stat-Signature: egki8ex5b1kp7qzige8gg15yg13hje3o
X-HE-Tag: 1758727384-967261
X-HE-Meta: U2FsdGVkX18uhyEkUnNh31Axnrn4eMaMbkgyISpVQMZ/hMoTsmPF6CR1LEGBWbqIqST+oyNlhKdJZgmwwX68sGjPiwNk7wGf8CQ6JytRwv/e4n2C0C4IIKaR8VWeWqfnuMf8JgFw6x9E9nBLCTqmPiF1P/q5b++OEuNajeZkDmokgZu3oO8B1EJCVTju4DenDjPU1LQKCPRhYIvBZIQgsVqxidlCMSTeH9BFmfmbjmeolazg6OAD/bwdmGOQqDk++9OgmmYgmfggOvbrJtTv9F0Mk3XOGKszF5uKEC1V0K6XtmmTyyeBzwE8e7THBCdmRO5Pm44eM9v0hDxpPVznRK/sVO+eITxpUPUTCeICDEWcAxu8mp7O4eMqE+tcRG1DHKA928otoZHNrqmIXzkBXWZDG7Xo08vtTfp8kouIaDm47NtBgd7ftXIcvSndSNk9tXdaYE2KlXuzPsNNaGSPOyc36Y3C7fAnsEYb08Y7aRiTRq9niY7x/b6WQWduvzsf8GSfpd4J3debaFLWbycncQQKox2DDY5yLrrPrIei1OQNc4WxtJmbNGuecUQ1KuouFFeOQnEa7lFQbtMzcDqWwFoXvBGqNuys8JnsHGeuaiz4Z/MigHtvWj9qOl7eJ+NPy1cEyvBNlqbW8MJEfcDDdBAYneJ3eOmp8VSYxq7HEIFVIRVonlmd0qVNL3uL0pOocFYmnA17Fq1uQCLYVdbL8dWvkfyCtJKUtZSjLVjW8l8x2JXcT/Y7EXBh13WC1OaOcWWMdhux4BJEk7y2YuKxUI12jyiAm38H8kfw6FZ/lQ/9amqRKu5qERb08ZBcnRH2wEwsySc7eZMBgWcPyi2uGgzGPw7eQlc4XfLsHtxlX7VQHW/Z74xZR/Hfip5sbrJY201aDmM9Xmqzdn1WTKTI5bFuO4DuSILpw6q2JUZ9+Ls4ozpAQEFldTqEaEj2XyyhMALAs97DzgdEvMR4VuF
 mZzk0/Yy
 x77ajU1gQJebsS5FA0p5uXMY2i1PKGaCA/Tl/4pDz3Q15rLyLw9JaaGEUJbo0CUiKHupVt2hwBSZAi4rB2KFXOAn1W2bVg/EzM/gDr3mTAmtaVUTVxv8bTKPFsQgfH78/Bnv1tk5EnBO1B9kW37lJFqApoerTancr9jSiASRPgsR5e83S78A/H1TltUQX+MRAEqodTtdiyRuouYH7+Ts5uR7x90Q+0cY8LXec/a9Xtns7yypk1TQA6fIO3xe3Jkuke6r0v9zSdjJbVz12HnvVQruXFsjSoBHEMs1DLV3aEG7zlhgqyrImaPZCGRzpUZJBfirvF4/ABXnExi4kc34oFZfuZ4RpAQ6Kvu8jHt4PWRS25odgApTs11NuNvdK5AklkYA7syETuDm2ZRkCOYczhG4aW152b8PhE87d7mbc4czMiV6cxLPTnQZh4laCBmQ1PDhouInEcU2z5m2/ZD/VKU7SjygE7I9MZTK4AtEHZkkbJEfAVmfsAL8YKTWU3qxg/t9qvq93Ce0HEOyzHDxINcrqQAa09znbXjyOAYYMDLYhRPAkmTKGp4R71TKAEu2kKifwJV2G7RpocuQoJwI1agHxhIQJ3/nEz7GOyfDIArjhhGo8HUhJEt6z80SkhsgXerGe98pZKDzM726dTmNKJHLNVZSzmujJFm8LrxVxqNeA916Z2nMFQYzBA9RQ30vfjTf5bYgWek0NvApo3TK8uAIemPaLm8snW+XTRdLEPlyP6NTmk119qrMHcVK9t4yRt1tcJ+a8HGlFTqrHD2nVi+SHO6N7hwiSO++ox9UnIku20N9FKc1r+D5wOg==
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
2.51.0=0A=
=0A=

