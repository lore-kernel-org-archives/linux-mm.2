Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6992DD33992
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 17:00:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B37516B0197; Fri,  5 Dec 2025 12:00:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE7406B0199; Fri,  5 Dec 2025 12:00:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF0B6B019A; Fri,  5 Dec 2025 12:00:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 843506B0197
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:00:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55781B7701
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:00:19 +0000 (UTC)
X-FDA: 84186030558.29.BB5C0BE
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id B5083C001A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:00:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=JXgljEa5;
	spf=pass (imf22.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764954017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUXffJ10pcwposVmC9vM2kcbCnj2+0WuRal0d/tv1pE=;
	b=pqabC1pgn/P3+El+Z1lgILH2AWHoTp80LhOmGH1vgXolN8YQMjX/h+4qNVrt3i0EkYLsO+
	y2hpji9efcskJo7EJnfrFgTeextaoCdHbfhn/USlTxwf0W856eqE5Ih5dmNhWmBKUTldPb
	mMtkog7QPjDBvm1TGeq+zhO+NWxApkI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=JXgljEa5;
	spf=pass (imf22.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764954017; a=rsa-sha256;
	cv=none;
	b=U7N3y4zsOvt4SDJ4WInDntwUFsq8X+gjF+NkvJ5xv36asdKgwOypnDHTL/GSEsX5nVO1A4
	SwzKHGd7RSjAjS+cXiyzaNieH9EAs1lEG/KL4egqj2DbNvYNVNug5LomhqZmEFKraIr3gt
	IbjAcMzEFAEltAwCMdb9WIk0C7eMVXc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764954016; x=1796490016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sUXffJ10pcwposVmC9vM2kcbCnj2+0WuRal0d/tv1pE=;
  b=JXgljEa5Kr/ilTI4mKNfkZHgOt97l00HoLe840WnqrTosvN8bScbibM7
   533/GPyaLGrEB/6g5pNHXQmn2+e879z2mIVbjwpdtywT/wdKYn6y0OQKc
   lNUADaJRQoEcolnysyb8u48JXHmcanPEcPP1RTKT0uMSEWPfwlxtFvU/W
   eGE5IVr/KLMuz2FY28gSiYgqEZ17Zizq8TC9XiHS0lLN5JU1NRUN3ZrY9
   laIcmI3OkDYXmk1D7Jzb07bjCaFMqxY5LO94aaHBLPGkvuRdOZm0tvLG2
   IFrkWmfs7+VQyheBUfphBWfSql7fJ70yigeKd0zP/f9vww7RBSWtStC3x
   Q==;
X-CSE-ConnectionGUID: P9803+feTBiSUBA+N8ttpw==
X-CSE-MsgGUID: Pg8pNwcjQpCugjo7oQu4Vw==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6301836"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 17:00:15 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:1229]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.34.107:2525] with esmtp (Farcaster)
 id bb13a913-5eca-4334-b10b-a564cc743b40; Fri, 5 Dec 2025 17:00:14 +0000 (UTC)
X-Farcaster-Flow-ID: bb13a913-5eca-4334-b10b-a564cc743b40
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 17:00:14 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 17:00:14 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 17:00:14 +0000
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
Subject: [PATCH v8 13/13] KVM: selftests: Test guest execution from direct map
 removed gmem
Thread-Topic: [PATCH v8 13/13] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHcZgifgxQmXVCcFkmA//3xLcHAXw==
Date: Fri, 5 Dec 2025 17:00:14 +0000
Message-ID: <20251205165743.9341-14-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: B5083C001A
X-Rspamd-Server: rspam02
X-Stat-Signature: h6hu58b4c9anjfdp9ax38k4m4iam938o
X-Rspam-User: 
X-HE-Tag: 1764954016-733605
X-HE-Meta: U2FsdGVkX196t1jzRkU0GH9BTjB2Q0+fld26yseH8U4tbpTMKNskOunsmhoEwe1HBiHq6aRTiuh17umy/W8Lokk/6m3JccsWhTbhMDkVmguGA+nmQ/WhJeCa2Bn2SnTW7LF+3CCIgUMFd8Yy8DvkdNyKTUILnKofWkSEv/hY66/wOK/5VYDOypmSlWOjsZtn8AbPCWye2wuZTXgHOmqYFA6ToarkYOrDkmFdMvpCPAShFKwYgjjrc/fXwtKFopMSSIq38wvp/0CtaCwoUulwgGk8ojc425c5Oyc0lBZ63xZ7QBx8oWRZIGl1u3xEtjP4Ew3Y3CNydKvhx3h07faXwU5rOwPDoclYc9o97X1HKWVT2aM8X2R1n8Rb1IXMIC8zuA4FkT/T/IrQbZfskUtWMEiq3pXGTY4gRmW9RhosgNJ2y0YDcTx1gEBePVMd+P7grys5uBhyuAb+YEPU8CSNkBG7tcFgI2EYfMoaGX17bxDVoWCcHfpJ+VC197DGFaRWI77hh+herPziNY14E+rEoHOIdXd1ikpvMouin2vUpFqKjItqmqqK0t5mpItDWn+27EY1qRBc5Ct148Mw5OWMtmir4/PbPsQpbs0OPBJQkeZ0POXSW/Tta3YmDhx79ceuA/xAMat/EDFBTrAMsxWOCqjhjC+Uf45w2l0mXJB+yvMS1p0C9f7xngO92JFsc12X5BFDo/ifymyKF6iZbNEMc7dr5hMVE5uQLyr1jDmznTskZddsDhmrsqwLlns8DyFcrV4aX5DwYDtgHeUX+c+kYl63E0PJsRnbmGZRRRXUuZnaUyknbhIOreMR1WAYTWESLUJQGSZPbNc2r+CFLkPTkHtimdYAhGRsvTtCF6MqPcrDBmnJ7PLJPzTwovgds+RW85xT3xfVrPCU1q90naSwIxJQ2gTTJtTgE22gPkdCI7SNIsEbJIXs54Z4NjpO0cPZoTyhiOOKk7XFmTvyCP2
 UxJkuy4A
 4LGkcmeF05X76TQgL6Hh6TpqhuWrm7IWUPNIXZqxKhAsb9oDDU4f4Tm/bKJfTX6WqVL6e0GrQ/S6t61zvWVtLIR7qxbICf+RgLJID5dVVTpMzNTWVVBMfysLk5kUgq5VkdNt83MwJWiwDD4dJRdATs8P98BgQN0BpedjQhJnQOvt1arySpb7/sWB0IPkGSplz3SHYvgRzSSSdo6DvJx9NMA48rD+XrFcPG2rrars9f7FwL6Kl3UYy0ZEvcm/fPZkuYtoLoEdS/LA1Lvv8YaKCwt7C1PJb+6TR3eTBSZeVjZUS4SbIgjA2kv1HsquZzCX4PmvYzdOqaoUnnRjRUNQUA9MruSJz1GLVhwFnUkWAOp9qSnmGZEO7ayaUeTgxhofpPjwOfdzQICEbA5bSY+IqTmqcXNOpb6+RLcyeyjxCAUBa37CgEg3RxSL6K5ASCDZ5OIDrGKSMR3winph3nBENnu8rM10L588UDdMFxstewsL5PKokGIs8clsCbjTMazFS4IwiG9vHcXlEEWuDObrsWt4WXIPXZNzuXbtfbAYm9bC2ZFiCzhnA6/FTngvkaiu3PBfV2Z4BfMaAOWFVeakqsDWfeI5Mp4spDH4KYkCXR4Eg6tqUvuF+uIKB4OOj1xizpUfnQiOn4XIwv8kSEQI47tEur4FvLfjQiAbB/Ew/NDssKcOah9Ur5LY0fBHwQAtbm4Nq9QvMNfwn00MK8FGlSg8lIKlPCEvy2uJa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Add a selftest that loads itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) and triggers an MMIO exit when executed. This=0A=
exercises x86 MMIO emulation code inside KVM for guest_memfd-backed=0A=
memslots where the guest_memfd folios are direct map removed.=0A=
Particularly, it validates that x86 MMIO emulation code (guest page=0A=
table walks + instruction fetch) correctly accesses gmem through the VMA=0A=
that's been reflected into the memslot's userspace_addr field (instead=0A=
of trying to do direct map accesses).=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 .../selftests/kvm/set_memory_region_test.c    | 52 +++++++++++++++++--=0A=
 1 file changed, 48 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/t=
esting/selftests/kvm/set_memory_region_test.c=0A=
index 7fe427ff9b38..6c57fb036b20 100644=0A=
--- a/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
+++ b/tools/testing/selftests/kvm/set_memory_region_test.c=0A=
@@ -602,6 +602,41 @@ static void test_mmio_during_vectoring(void)=0A=
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
@@ -625,10 +660,19 @@ int main(int argc, char *argv[])=0A=
 	test_add_max_memory_regions();=0A=
 =0A=
 #ifdef __x86_64__=0A=
-	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD) &&=0A=
-	    (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM))) {=
=0A=
-		test_add_private_memory_region();=0A=
-		test_add_overlapping_private_memory_regions();=0A=
+	if (kvm_has_cap(KVM_CAP_GUEST_MEMFD)) {=0A=
+		uint64_t valid_flags =3D kvm_check_cap(KVM_CAP_GUEST_MEMFD_FLAGS);=0A=
+=0A=
+		if (kvm_check_cap(KVM_CAP_VM_TYPES) & BIT(KVM_X86_SW_PROTECTED_VM)) {=0A=
+			test_add_private_memory_region();=0A=
+			test_add_overlapping_private_memory_regions();=0A=
+		}=0A=
+=0A=
+		if ((valid_flags & GUEST_MEMFD_FLAG_MMAP)=0A=
+			&& (valid_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))=0A=
+			test_guest_memfd_mmio();=0A=
+		else=0A=
+			pr_info("Skipping tests requiring GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_F=
LAG_NO_DIRECT_MAP");=0A=
 	} else {=0A=
 		pr_info("Skipping tests for KVM_MEM_GUEST_MEMFD memory regions\n");=0A=
 	}=0A=
-- =0A=
2.50.1=0A=
=0A=

