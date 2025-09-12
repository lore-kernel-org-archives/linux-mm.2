Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65487CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:18:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C28DC8E001C; Fri, 12 Sep 2025 05:18:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFCAB8E0006; Fri, 12 Sep 2025 05:18:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA0D28E001C; Fri, 12 Sep 2025 05:18:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9120B8E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:18:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 545341DF450
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:18:12 +0000 (UTC)
X-FDA: 83880046824.08.6859586
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf27.hostedemail.com (Postfix) with ESMTP id DCE7F40005
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:18:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=gCfCUwSC;
	spf=pass (imf27.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ojtm9hG3uDHHN9CPzAzA1kwd7CoLxip6b5f2qHGneMU=;
	b=LqFA7PozkxYqltTRG3dpZU6SzcAND2BdeWddTlcKMRoAWCv03Yqs9W9ibTfvchS8VS/EbE
	5HtPm5bALiPPrd3xDlwWP789ah9zj9Jqx5JBD22IWl+H69SqzhCVPgnyHAfe+FPSlrmch7
	Ohsqan6+O1BMeFMoAAOy2j1apn9by1g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668690; a=rsa-sha256;
	cv=none;
	b=DYHa+XfSqhRDYmelqsatZwvDuDExADWEHdFjQ1CAx4rCa5onLQvUIAl3tsFnbLXAvg39IN
	SVvODH3TU5tC2grVMIj/pWHtNVAElHMcWtPcIulCESYaWMwPuJD8g8VgQ95M25EqrivW0y
	UhEqau/G5BZtcJpR4ZOxV63euYvGIAw=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=gCfCUwSC;
	spf=pass (imf27.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668690; x=1789204690;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Ojtm9hG3uDHHN9CPzAzA1kwd7CoLxip6b5f2qHGneMU=;
  b=gCfCUwSCYRds0KIQrSrU8dDW8BefAUliT//2kIFd0ukbpP8hEnpa3Uzc
   HDV6sqmGMdeKfgpkgzJ5iJ6WvWmpb9D16xSyOy0Nko60VXZOLQ/CjtuFy
   LARkmQDfjJ023YhcgBdf9haIRcf3ljKFX04JbVAlNUHzuGVgkyZ3NMXzZ
   4MqDEopUW36F77mRWyoQYD9N5d3zU2lO+T1hIdeykDqgSJbomZpaalJgZ
   zpyHnyYO+oF+XEb+xcrNNd6ArueP33t0TOshQWaG6xa/yL/xKnCm1EqYc
   jMWH/3VxRFmid0aASERAFquLWKraWkAHpgI84RKHKgFmawoC+ZZAzxTXC
   Q==;
X-CSE-ConnectionGUID: pZZ13Mj+TDqV8Gs/7yExlA==
X-CSE-MsgGUID: RfZcwfpiTzSibRHA+5TiDQ==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="1903318"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:59 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:4257]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.240:2525] with esmtp (Farcaster)
 id 0791345b-5f96-4e3a-80ef-d080c8c5816b; Fri, 12 Sep 2025 09:17:59 +0000 (UTC)
X-Farcaster-Flow-ID: 0791345b-5f96-4e3a-80ef-d080c8c5816b
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:48 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:47 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:47 +0000
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
Subject: [PATCH v6 11/11] KVM: selftests: Test guest execution from direct map
 removed gmem
Thread-Topic: [PATCH v6 11/11] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHcI8YabQ9AygaqQUCaf6AaD/P8kg==
Date: Fri, 12 Sep 2025 09:17:47 +0000
Message-ID: <20250912091708.17502-12-roypat@amazon.co.uk>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: DCE7F40005
X-Stat-Signature: xfprgqkdzwhn4rbw75jtjbpxcm8b4r6n
X-Rspam-User: 
X-HE-Tag: 1757668689-531344
X-HE-Meta: U2FsdGVkX19Q56KhSXlDFU3CurFFzfrzlJHV0bkucamTkdvhZm5jAktu1Zi2UemWwYE1hP8wkRHXATmug1j6/rvFSiCI8GsIiwykkpBY737hLl9+aygy5s+fODDAJKreXmtZkxsnWp0jUws5ub0wBcwHek/qgvggTeMCTazOk2c7RMceIKlU+Kw4bC4W5+8k5rbA03lxowzFwsFlf3GybMQ+B1XZqSsibYEmrw6HxeZHYGmuftLsyVNqjerRxHgn+o7PLcAAYRq96RfKaC/fsMP6/ObOU//4lUkP0ZGDxyU8DRDBRryW0CSVpqJIw6xSERYwg+/qNMvUjjRCWb4vdCJTIo82xSAE11K1lRJbOp81Zhzaq3LI1dzInC6OuaxpYni/Y52dYibH5axegtDq+6zDhb8WGmgcKDQ/hcdAkKmvy9rKMY43KrhSA/K8Q/qP1MM3iWpRogsld/K0jpec1EVw1WMeBGoYr3SqPGyUnLPnzU8ZSTtL6865btc8+hamTy855PzRF83kyIhiHY1visdm80HML5ODcUWzAna0P2chB7qOqDQwfEiy6S2oUgtK8Mw6jcW/YEA+XAUlLK1Rmbj/2HEBZ4lAn0kfxo5v6A0WldM2khIc1axUH93K3cIZkMSXOjQHGn8o+z0Bym2+TEPywD295QUS2piOWSAzKGDQpAzBL87QsKGVhy4n7dAA87hWq4/3B8NHuio+RLNiZ/gtk9SFXkgn87mhEuVWdBf9y8f/sU5s7RltUPAteKo9veVxBPkHwiXB3tsEIE9ynuQSzAZM3A5fzv7uDO0wmdofaxPNU8KRePOte2m/sOBAxnNTcGbHTDy9xdpAwCiSZjjLI08UnSx8mYvE3+JUxgzwwd2vrOCgQ2NMnBgUXCks8/IyE1n5puWuHaPcGQDgBhqUXzjPQAySRRUud+9GWiNKRPaCZn45l+cKujMNC5dQoTgdImGMjCE3v5sajh6
 KHdFSCLS
 v3bH8INPkF1vbWPVy3H28X0dbx5eJ6AhWdWZxh6kFxIym5dKTSQQARKwoT6avSuuq8I2bRTsndr4ZTP8dvXxHQv1mvIE/JPe2+RLrj8y8aYtGyt/ycNcxRks0lyXQUMujAI+H0nBRO+RezK4EPSi6CdCK9mvjBmDiATZ7nbDahx3zE9ov0xT4EaLcp6/sm3qXOtCizARc2VxCrkYyLAcYeCZB7KevO4PvxfLBlDC+vg1IkpK2eoVBmaoRRD/DFABhgWqSYCOB/2ArVyo1lHL48RPAdSQabJA0rYe/+PdM35Gu2rupu8fBSfALkGGn/YU0Vsh42LyzSt/nzJdvS6yoWbIuSVacnBvml+yeu65wWhDpMnT2UoPDoYz5/SM93OJNeFzLbhIB86MdRkZv7InnQ+Kdx9msCnQ54n2IAVDWUkvkGWVfjrmDn00JzY6ThiKaG5yL45B3ur1oSA88rCK76k7LNxvJQS3NT5mtL0zUUNYaS+0Iz2ScicdacFawxTjIEXqb+NfwqiPEA1u+XvOILtVolZ5Ld1CLDQ7yZof12AzsvJkoLjIY+Km0zAiiKDmYQOi5EE6gbLSmHhfoGI95eVMYrgFwnAtLpGuXlbvSr6U53I0P+HtpmL7HcrASkiijX3LJKV9EtKMNHceVkU7nxXiNYIsRh3Tsbpxbw1iTEGmxXSx8qt97YVZ1SXc0AU514tgy8wa0pXv9CDq+h7W3204vIAQcA/lg3cWkv/bl4DsVhXRiNlT3Qj3blnmEefiVodvcQ6126rCx2EU0GD00jZ6Jdcs78GGBOgIQrhl0/5ac0gTFbwmXv5P1nw==
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

