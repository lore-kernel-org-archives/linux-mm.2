Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A515F459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1026E6B00B6; Fri, 10 Apr 2026 11:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D9FA6B00B8; Fri, 10 Apr 2026 11:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4336B00B9; Fri, 10 Apr 2026 11:20:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DCF106B00B6
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:20:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2728B99CC
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:20:46 +0000 (UTC)
X-FDA: 84643008492.08.AF0E729
Received: from iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com [3.221.209.22])
	by imf10.hostedemail.com (Postfix) with ESMTP id 341E3C000F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:20:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=QuTl0Bas;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf10.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.221.209.22 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834444; a=rsa-sha256;
	cv=none;
	b=bN+M72o8gqGufG1xyRDuu+EJnVQLcqKO8IWdYiesVX3oyk8+r8t372gX/+kcKdWbRFpl0P
	98M95+F2acDf+Sz3szMYzZKOq76L7+9zbsXZRT4sMsxi6QMG2jAlAz23Wra/2aSofYJJdl
	DkOLqXWj542YTmcv7Yilhv14/003UsI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=QuTl0Bas;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf10.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 3.221.209.22 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4pa22IBiUxkhl+ny4/A/3k7Ys07iPKfR95Xdo8FAu5s=;
	b=2vdSZ+Axvom/lKz2aCwOxVSznt7qfUYX6V7wne8R2g730Dc9RCvw0KGGTtr3hbQvFsytar
	qflg/JIITOzC4Sa32pGaYIaJufgrDIbD6+bbSWHYg90QwcvyIt3Mh9fv2Vb4INHRyxMfzh
	Vv5omoOf5G3gu+zz2Nvm88mDeFgpoLM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834444; x=1807370444;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4pa22IBiUxkhl+ny4/A/3k7Ys07iPKfR95Xdo8FAu5s=;
  b=QuTl0Bas3MEJY5+Ow1IQGWed5xsecvVSOFcW0mG5yg0xW8rL5ET4fLnK
   QMkwCavrlwHoH3ff0n/8m8WCtXi4cO6Kjp1kqBB9H4EMTWTHKv0E8wI2V
   YOjDtOUDQRIvdKcDzjuLge6M9VhhCZ7j4NE2JLNyqZ31NEaWjz0/lQWAl
   WjyF7bHPPrA2rCL2ql1E0dUjnRf79p7pvCa3DqPy9ftQMHm/c25qIL02E
   qOXSaKvx3aMNQc8Yd4sSRALVF/3olB9aSFmC1KMMZm641BkUqgwt4zNpI
   Qg5wzK0nVV102OGPx//f2DnAeoRnS7T2PxiVZynSeTUBEHsgMDFyIyF3d
   g==;
X-CSE-ConnectionGUID: CxtxYb49QH6Oj+u8asaXPw==
X-CSE-MsgGUID: iz0F3lfkRFOuVkePrCTYBQ==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15990030"
Received: from ip-10-4-22-235.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.22.235])
  by internal-iad-out-007.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:20:43 +0000
Received: from EX19MTAUEC002.ant.amazon.com [72.21.196.66:24508]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.86.77:2525] with esmtp (Farcaster)
 id 4b48ec95-31b6-489c-bb48-922b6f1fe163; Fri, 10 Apr 2026 15:20:42 +0000 (UTC)
X-Farcaster-Flow-ID: 4b48ec95-31b6-489c-bb48-922b6f1fe163
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:20:41 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC003.ant.amazon.com (10.252.137.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:20:40 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:20:40 +0000
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
	<loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>
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
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com"
	<riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro"
	<itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v12 16/16] KVM: selftests: Test guest execution from direct
 map removed gmem
Thread-Topic: [PATCH v12 16/16] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHcyP2XEHVI3uLMIU2FZLnWTUpJYg==
Date: Fri, 10 Apr 2026 15:20:40 +0000
Message-ID: <20260410151746.61150-17-kalyazin@amazon.com>
References: <20260410151746.61150-1-kalyazin@amazon.com>
In-Reply-To: <20260410151746.61150-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Queue-Id: 341E3C000F
X-Stat-Signature: rkfxqkn6ugfrciihkonqbwmi6e359koj
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775834443-296810
X-HE-Meta: U2FsdGVkX1/1lPbJI106vV1t8z/gfhtQXWx2ZfWkuCr9OzljtoER35Vgo0BuhNK+vmvKW93yxeIj4dG9rL0dnnix4WqWZB8aIPGd747Lh2i8ugFSHu2v+T5npO3HFbLwogRlqJuUNxkuK7x3TwWWmRg25PmWmdl7ZJsqQiSQEv7pb+36+MU1A+GjauoOlrSDIHI85Ty7/q42L7BWpnFhjL7Wr9QnIsqHwA9FEvCZSuonseGjrNeDhyTsdeUXYFx5FBhXHaqdlwKMPVsMWV3NYvAMS3hx2FClhgV91nxGIrYU1qW+7yZQdYZFMlgo6VacTS5fdUoQzNPKgBXV1/xIwTTvVsqNBImWIl2oDioWlAaECArrZATqz+Z42+QgUgaVo4PyLsPrwPByAcM1ocLTmG27eBuv4FakHFevyurlTio+7Qm/MXpnpSdbpUAMSkTzql1N7X00OiL8WaB2EX+yYLxrGSSJDdOdkmzhgCv4Opovto2+jYRohWMcDD56hdwO+xxDEyq9PsBHVwCmJXGojzgYUyOkRICG88mMkqzoDzGTmcSPKhAtaxg1Tm0vksvHlSrPgh2CJ/m8bixY/+NxE6w7jx2wAR4T9y2bDJcKX2nq/opiRQXTqWDa3uRASdxejw0j+tyei2nv/z+ri1FIbbu0/T7od+5rNoEWuHbRzdeizo1zJO8ng4JLJPsqN55F2wVxChT9TZ/j5qQa6ZQ9BmQEgwVgVsrKambUi2mctR/qmoHTh847F+gLRITJ2DZNWgF9KCUrGi9Lj+LGxwTWMea8TflbEyGIh7eE3h47wF8S6MUci44iVO5U5zOApSSHckMWexFgpjdGPMQ/X5K1PkK4koBSGQnynhSJ8nOgPsah1K4eXBKWpZ5KY1lAhBCcwl/4TNQWWmy+QXpKZko8mN/trpa192wAuRlVsY//dKhg1ZwkWOte2E3AEEZLUMUISQh8tIE2BCFVGvd5RXH
 9amZL8Eb
 5vCcKiBHwy5dlSlXbjpNe+gm2/2zeeQJ3rNnRGmKWIi5wFldEkGaXRHIMERmTbp1mHRQM1hi6lpxArqDmPtaMhE/x3oDQ93919wi8b/SJs4mIg0gB+F/HtP3RjQCgRtjjyoqBddtf82LfMbX1qqLob4Vx3oVEAzwmRJSHsUlwbyYpB2TBJ+io+L2gAo9fMcKxBz9HtOWgKLnZfPf/Alk9rn94w03IzbATGeduv95UCRuEH37XdChl4eX3v5tUvZ3zx+Ov9TW/2hdg5JxNtlp8K6B3tWlcprH+PyHnFcuogT5oIOqR1wUHoh9Lzoy76DWhigDExNU1dPheivEgc3vEmPpMxu6zfgYtTEi1d6+GE7gh9OVCsw2x0JLEaPGliaQDmBXEAp3g9H7GNLauq1w1AnS0eqEZHs8dOCdd5ATl0w/cyFBo99kECgHxq2/e25vSkLtlwVbJ5uYNCYQ5zr2ERLRW7rVSLVlBQVS/N9TWMF4/C/KIygrA99DoBEO4DiL6d//sxKUonCETxd9g/C1BAQJySUgasl29XILAtK9gcA/pvp74Ll5XGMdL66OzK9IsrvJs0ekgS9p7cRviQLrlOj8GugOVw+fxO1qdzfQBfUkItib0Khduij2dnYKkYfq2Jg85PF/c8nzfbPPmCIpbcuNdTVIWd7YZtTrxgtxAecjRZFaNzk7bsgSKFoDuaaOJ650p
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
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
---=0A=
 .../selftests/kvm/set_memory_region_test.c    | 52 +++++++++++++++++--=0A=
 1 file changed, 48 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/set_memory_region_test.c b/tools/t=
esting/selftests/kvm/set_memory_region_test.c=0A=
index 7fe427ff9b38..cb445d420e8c 100644=0A=
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
+		if ((valid_flags & GUEST_MEMFD_FLAG_MMAP) &&=0A=
+		    (valid_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP))=0A=
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

