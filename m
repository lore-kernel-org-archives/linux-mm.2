Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78299F459F3
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:20:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF9836B00B2; Fri, 10 Apr 2026 11:20:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAA946B00B4; Fri, 10 Apr 2026 11:20:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99D46B00B5; Fri, 10 Apr 2026 11:20:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B707F6B00B2
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:20:23 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 800A7B895C
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:20:23 +0000 (UTC)
X-FDA: 84643007526.29.498FE5B
Received: from iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com [18.207.52.234])
	by imf06.hostedemail.com (Postfix) with ESMTP id 43CF3180003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:20:21 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=WLOIFfJL;
	spf=pass (imf06.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 18.207.52.234 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a53EAdE3OmtPzmnkX5XyMGwkjzljlnNgIi86usdTTgg=;
	b=DTqF5rMAHMRF1GGsv7CD67zSyRkjzmYxONtVIEplm54O6szMd1PMRuf7Htfi+v/WkFL4cw
	kmpqal8gEqSwGr2BtGfs9mJrwa+GlDOIwcdSrfjyRXLkWzqc2F3YbRKvatdmmCVhZwrNBk
	D0BZyPRCa/su0Hap3tlTSP85L7GFfOU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=WLOIFfJL;
	spf=pass (imf06.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 18.207.52.234 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834421; a=rsa-sha256;
	cv=none;
	b=7Ps+KqSUNk7iMEM9rfk8zU2aRkqnhNgx1s3f1gJ6RqCLgtcenfoJvFYQWl2W6+z1tnPuoA
	oQWEEBZDZX9cPj5i+6rPJB8J0VZKIzdwxawv0u0GQFzlotA+QdI0/h5gB/Muo0R+porvuL
	ZgSMAPgP87X1PllHmsUHdwvT2Qe6LaI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834421; x=1807370421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=a53EAdE3OmtPzmnkX5XyMGwkjzljlnNgIi86usdTTgg=;
  b=WLOIFfJLExiwd74Q8GZONSoVG0Bb1in0x7+bmQApUrCDILT1HGjwSIZp
   WpeH49iasBo4Y678yZvCi+0ctfc/RUF3is2XHjql6JlNOcMSUCNxqRC8a
   INIQox7CG34843tuLyjPnPIUq16d3Fivgbc7NBVZbTWwb05cKXB7P3DXz
   k5vYOGYASDgFq+tRQ9i4lWQng4mu6/sTwy/bkMw8zNeqUZ3amIXero5qh
   rAaWOqGaI6MjAN4UfhOoXXCLPlvinZCrP8uB/g4sYAhtuaFipHWjucUDs
   rapTQfwbVa4jgNY/PGyM3dvxQSqufKVyw7qABQy7HSpE0VhXbXMYTcxnW
   g==;
X-CSE-ConnectionGUID: HshgngqsQoCu8xT+gk9KXQ==
X-CSE-MsgGUID: 6g1F9W3gSEKM9uVvDEXtIQ==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15970805"
Received: from ip-10-4-17-41.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.17.41])
  by internal-iad-out-004.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:20:20 +0000
Received: from EX19MTAUEA001.ant.amazon.com [72.21.196.67:9796]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.32.14:2525] with esmtp (Farcaster)
 id 9cbd5b7b-c821-4d95-a04e-d864a7868389; Fri, 10 Apr 2026 15:20:20 +0000 (UTC)
X-Farcaster-Flow-ID: 9cbd5b7b-c821-4d95-a04e-d864a7868389
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:20:19 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC003.ant.amazon.com (10.252.137.250) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:20:19 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:20:19 +0000
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
Subject: [PATCH v12 14/16] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Topic: [PATCH v12 14/16] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Index: AQHcyP2KnkH5rbnwD06iHKAPBNZ/4Q==
Date: Fri, 10 Apr 2026 15:20:18 +0000
Message-ID: <20260410151746.61150-15-kalyazin@amazon.com>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 43CF3180003
X-Stat-Signature: a84ogrh1eionbz77y334goopqpy8zq9z
X-Rspamd-Server: rspam06
X-HE-Tag: 1775834421-813477
X-HE-Meta: U2FsdGVkX191opI/R4AWmuYCOfJHU7MizGMBSJrivFx5yXWwf7VgwjwjSwWa5fR4X9kKdGNoJpcCT+Y4IvvMZTtz4zbD2SDeg8Ur0iZTtUO+w6FOljvWU8R8Z0mPsNpPWDiR4maHN7etoYkocVtw9CPiCSNqbPrD44IaT+pA6IAUIpQH8mmD8BGpueXyeRXFRmkY7I9nPNjB+Ld2igL51VR/YVcOBw5xiYZfNr9EdxbQm5BlwY2lmCmSX5WB4GHkKGhGa8LspSFOj0FHjxOQySlLyuPZBfVCuy/e6SeiJpoxiUbn7FrXpzXMEmJ/4MI395bvcStWssDXAO1K9UrJ2Z2vgHPG9P6OAhZhi7ghEqhfzyK9Qke2/vaPrAvqY02BmFtWZtCz/Wr5GSV986lyWECid5qLicvgBIDhBsmAi9AA0n1Hxq7vkedISwrGkIA1rvK8m/MDsH0wsb5Z5pdTzTRJ0HEcstwbfIWTo7kg/6BcowAPyzdcJzmoGxfi+i6ey4RMG67xmackukLPZ89FQyRiNKOkZ+vx5w7emVsZ9RosIx6oEjxp7FDLANDO2Er8el49XAYmeEsunCzVv3yXdGKPc2sq/d2widoYABFeQVMmUkxVCkR78b8V1S/wFGWshjaDy9IZMDxYGXfKpRSOMT+2RYlj0Si8mH42InDgpCEJ/3AJsF52XKOSZYBQSaL/30LUnOK1Oa7n/jYeEgw9O5+r6Ydjd2fiZA6RzbIsXdodM1ChCRLBV08L1tolyh7vqykVQ2ia/brFH/IXxK/NNjmDMmhUAOxCQXW4V/o8fcr3ZXiQ2GPJkUuLjafbUFDXaCtVN0G6ThpUMbN2lt6ebRvoIrZBxo8TcK3l8A+VAqyIuHTLWIHOuK4mVFI7107wnU3RhIoTm0e5uktkxA7gI+/1xC7loKvO6vqk6j35+Jc3XHUE2jsuz+Ar3txAc75YkXSb5RLKsmAJyfBfrK7
 pXGZi+6U
 Ex4xlqrRUgBM+N2zUIA+o+doQ3js1KhCyy6uv5VKBO2YM6KG7pKKzcUJQ95sTxVHbRt26ukC3mKs/sHvPHaTDhU1z1IF96429y71lYCvXHwWrypXmChx+rU0Pcw4OPxc5ZDTJzTBa4y0LpUMmKVSI8JfpHcLbHLjq2NPo0Gjj8VvJfL3w263mOYXrWX5bswQFX9y48dw005QlEg4vAIY3+1hPuya0jTJs9u6CPv/AhPcbBW7J/ACEi2DwxDb4BIwuE0wVTZsosjw53lgS1Ja/ZKdOw+xzoYLTah7o4FxMKnBrnqlXsKXey9JecfTAbRIK8bitLw2+UcRB8UWGgFPPoUcC0Gk0BP2o+VR2XjEANimtjzMF2HD2IGx9T55cg9odcoRWNVogXOI9gfp7Gbqlc0QDfWANv+u3bgAE6NTb+gAnLQUk4wZJKhc3ez2Fh4jkFMrxINSAJSvhI51toYyubZkOCIddH/71+XGhlJJYldAZWjL8iqpxKGw7VdK92cXsWciXxbjhGm9p+ZplcJ5ZHu8wEjKtKEu1yja8QzQjPzPzdO1oumYxULcfPFmiLB3uhiOtUKh3maMJ193ayIt6dvG7q8rXAyfHg/cSiJBTKAxEIkF7wPmlChhSfRx7BtXP7AmUSBKtuOqDQJ0XrNmIfCj0b9UwrK6SLVtGIv3KxB+yGMmEJ9PxbPDQzJYVbV8HzcZurTM0bM6xtzGgEZH6PN2/zEXCykiGHCrH3VxCs66vAdDuSVv7Hcqsrw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Extend mem conversion selftests to cover the scenario that the guest can=0A=
fault in and write gmem-backed guest memory even if its direct map=0A=
removed. Also cover the new flag in guest_memfd_test.c tests.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
---=0A=
 tools/testing/selftests/kvm/guest_memfd_test.c  | 17 ++++++++++++++++-=0A=
 .../kvm/x86/private_mem_conversions_test.c      |  7 ++++---=0A=
 2 files changed, 20 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c=0A=
index cc329b57ce2e..64c1200c182e 100644=0A=
--- a/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
+++ b/tools/testing/selftests/kvm/guest_memfd_test.c=0A=
@@ -403,6 +403,17 @@ static void test_guest_memfd(unsigned long vm_type)=0A=
 		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_MMAP |=0A=
 				       GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
 =0A=
+	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP) {=0A=
+		__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP);=0A=
+		if (flags & GUEST_MEMFD_FLAG_MMAP)=0A=
+			__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP |=0A=
+					       GUEST_MEMFD_FLAG_MMAP);=0A=
+		if (flags & GUEST_MEMFD_FLAG_INIT_SHARED)=0A=
+			__test_guest_memfd(vm, GUEST_MEMFD_FLAG_NO_DIRECT_MAP |=0A=
+					       GUEST_MEMFD_FLAG_MMAP |=0A=
+					       GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
+	}=0A=
+=0A=
 	kvm_vm_free(vm);=0A=
 }=0A=
 =0A=
@@ -445,10 +456,14 @@ static void test_guest_memfd_guest(void)=0A=
 	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLA=
G_INIT_SHARED,=0A=
 		    "Default VM type should support INIT_SHARED, supported flags =3D 0x%=
x",=0A=
 		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));=0A=
+	TEST_ASSERT(vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS) & GUEST_MEMFD_FLA=
G_NO_DIRECT_MAP,=0A=
+		    "Default VM type should support NO_DIRECT_MAP, supported flags =3D 0=
x%x",=0A=
+		    vm_check_cap(vm, KVM_CAP_GUEST_MEMFD_FLAGS));=0A=
 =0A=
 	size =3D vm->page_size;=0A=
 	fd =3D vm_create_guest_memfd(vm, size, GUEST_MEMFD_FLAG_MMAP |=0A=
-					     GUEST_MEMFD_FLAG_INIT_SHARED);=0A=
+					     GUEST_MEMFD_FLAG_INIT_SHARED |=0A=
+					     GUEST_MEMFD_FLAG_NO_DIRECT_MAP);=0A=
 	vm_set_user_memory_region2(vm, slot, KVM_MEM_GUEST_MEMFD, gpa, size, NULL=
, fd, 0);=0A=
 =0A=
 	mem =3D kvm_mmap(size, PROT_READ | PROT_WRITE, MAP_SHARED, fd);=0A=
diff --git a/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=
 b/tools/testing/selftests/kvm/x86/private_mem_conversions_test.c=0A=
index 1969f4ab9b28..8767cb4a037e 100644=0A=
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
@@ -474,7 +474,8 @@ int main(int argc, char *argv[])=0A=
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
2.50.1=0A=
=0A=

