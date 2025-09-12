Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C43BCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:18:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E5C8E001A; Fri, 12 Sep 2025 05:18:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 017B28E0016; Fri, 12 Sep 2025 05:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAC2A8E001A; Fri, 12 Sep 2025 05:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BD2A58E0016
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:18:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8904611AB86
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:18:02 +0000 (UTC)
X-FDA: 83880046404.22.F31B976
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf06.hostedemail.com (Postfix) with ESMTP id 13E8018000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=sZre0aTe;
	spf=pass (imf06.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5NNoBeZQBb9T957EsbM7la6hJHqpaE8HET/lqUjlaxE=;
	b=ZZiQCl30vZDpayG4gNYVuLr82ZpT9LQ2WY/cWEsCHvXk8Ujp4NAw/xRDHrozaMcb5SiRFM
	TBp2vFWjWF33BFV0KiouHUsYf9JiOmhpfnoeoPVpRhD/I1i/LwZUfQ+EcfKwK6vQnJKX3e
	HKdBRD7zx0prdKI7KNu7KWhN/8jAmgs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668680; a=rsa-sha256;
	cv=none;
	b=ZUYMmaiGIaA0qPd3z9npv/Zf5cTMqYFaFLOEO5YEEwT98nMq3gap3sfavOg+cEQdqFj1uU
	ZldiBY0Rxz8HA2Gl43g95yXVDlsap1ENCyWhc//3ViSs3d/FLN5S0I6s3v/ZG0S4xy4SsI
	g7oTVVtsCIYsFC+VQEKSDqzf41B80F4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=sZre0aTe;
	spf=pass (imf06.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668680; x=1789204680;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=5NNoBeZQBb9T957EsbM7la6hJHqpaE8HET/lqUjlaxE=;
  b=sZre0aTeXnb/yNGcTYv+Os4qG4H2yV+dqDKPwcp4MiaOu00JZAzPweOM
   ZQaC+GQTUaHcobG65NvLvhYCA0+98jnKTpMBw+hyuf+MqSUyyr/CsZpkV
   UBwJFCJ7dhWMR68YJDOBPcDULN6O93LqCxxCemL3krrU8af7WoJOLq09w
   RAyx0GUJ+xcmHdUCw6/nUu43g77r4RFwVvDYrHzLUM4XAuN3mUZeCP7d6
   PCYj+QY2JDmLP0L7t8ghBGsZaMTCxcqC3pZYetkuFWIR/hz1SWmfwFSV/
   uTKmAJflFaM9asr4ZHr03Z6mp9qeHBtQJWTzESYrgyCBRCAm6+/c86rtT
   g==;
X-CSE-ConnectionGUID: wYtI5NgKRIqisl+Vievf/A==
X-CSE-MsgGUID: EReQ7El5R9GU0+jpTmihUA==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="2009022"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:48 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:6176]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.248:2525] with esmtp (Farcaster)
 id 54936bdc-7bbc-4a51-83bc-460f78b35c73; Fri, 12 Sep 2025 09:17:48 +0000 (UTC)
X-Farcaster-Flow-ID: 54936bdc-7bbc-4a51-83bc-460f78b35c73
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:47 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:46 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:46 +0000
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
Subject: [PATCH v6 10/11] KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP
 in existing selftests
Thread-Topic: [PATCH v6 10/11] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Index: AQHcI8YaDbzInvv1DEGA7z1fcDmE6Q==
Date: Fri, 12 Sep 2025 09:17:46 +0000
Message-ID: <20250912091708.17502-11-roypat@amazon.co.uk>
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
X-Rspamd-Queue-Id: 13E8018000E
X-Stat-Signature: pdsod6xzkgu8i54ekzwrn4t1iozkmdbk
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757668679-219124
X-HE-Meta: U2FsdGVkX18+i2zS8eoHkt+ba3nsKRcDMenwilaMdzpF8CWDvACyOEGsjbLBulV2EZkLr3K9TwKTRrB19qhYifIRNWPZ7bHk83cjS38Keu14gtxCdEhGkcjBcaxZtZi9n8pWtk2aZOJX+RoAi7RwIGwQmPUHpY7FzZjX7jvPDjqJQ1ZGIDHjF/01I9Qg4ppKY899Kf6wW+aHH3hVeVSLnKhMWYgsmHLOQvZkfzluob5MbQbqm1WHpuGa/s3yvcYi1v5ysXY6HUTjqDXTz9BsWL+w4DHjX+lzgVXIOjMEudEmnCyJtigbDa5SGJFd1tg3ZeJt3YI4Ix8ZTCAtVhuxc2RDfs6LAcS6D1s9T+R/cDNYYw+rCqPN4vjeaX/rnCmi3MOmwBDkihuB+i8zr7kShymNVyIZeD7zk9lTpaiKSa0nIPBorRjpd5nQdpGqWh/SGnHca9AcrI/Z8pg/flu/eCffzok8ibpswzpYDePS+lN+2A24HmRlPKVlypZ7971+m5a9xx2dCpWBLjxF1gLOAc9VDeSbxBjAWocRq46h0Edh8K72ZhEKzfNfLIjmc6L0YrP1RtQqIQqoeJDAJ5/oVFxmoYgOHQTrNplxfdDyuCxIDJJylP0KEw8ZX5kKRQgMbjOU5rFy1mAVvhm1FulTDhrlkgEWKwx02+HveBx51lI4M1Xnxt5l1TUTxFVnTcIsTr9UPI11oZzRxTCla9tVVQj8qfbPsrA0ywJ3kqpPI87STVCGKCGw5Xkcedc8TEYkDO4vH1uTb1XZ/XJfcQWkU/pLPrtSiODauzYZhSj6YGZ8KZylXtN2gg321Wiha7PrffJZLb0TT74eIyuYjGjQq2ZhKtingkWabWDkHDpuBVUESU64nRaFXZBuRLJOgYcMyI48uurG5z7pYZ6cXradozIZc5GU6mj2DfFp7U3HMruLa3TZdoJd16bp3GbCnfGSSFPB59/Fn/hw/n6YgZd
 vNfzEiO8
 p6kSXCA57fXaEAZNJospiRsbHAbZs5MFfhKf4UR5zt3Yz9NzXzVHEoHKs/nyukEBvTmrzgC9Jn6fN+CTXr5O0A+7azVHs3RbIzE0aMfcg/VquBEZX6mIG5Gl0/YMr6VCRWp0/ZQ97GeVsjX3fvJmfoXoRZFFqvJVHPnnTfGvePWGx34K958lcXRVv/jw2imwS54k7XqYWP+8LVfdjdKfFdyeuqOYx5FvrONcnYUMACe3vCtIWgnJL6X7VC2aEvWKB4CPtensdQkFbqAKReAXhNsEmRMzBMBg2lNKF7lFb4wbvd+rTFHrlQdijDSckm1qsHNxXb8iTQj7NmsNJvD3YeMCI2f8l9+iP56BidmrlpBDvCC26FKway1Qc2cRGIuZVHuEYzKSj1faVdyVqmn7F4ajCNc09OfCk41zxiiFx+sgnlOa5RqaBKEDXSqklZizqxGCmZujXmhksCK+m2yI8z7h6bJSFp9OwjH4xcLd0WXEqbYUJIXo23TKrwAM5b0DNsWSmNKmZWh35RyuekTMIMDZOWb9wMoBgUtKqvJjHifLdPPJIdJPbzsMQ3UnCHAE2z16ETYV2W4t0Pk1lnHnuV+J486zqQzaPm9zZtLuUGQ70bJITlXNCQVY9LGI0gbVuWq6CWl/PT4t5BHhjmaXCvbGGJgmh/SLO70QZWwNpCqHGpRDgPiGgwLthywFq3mOuL4FM42O2Ub1yoyHlEimkefKH8JR7gJf95/fzdv3wMV+JZiCDwNjY57AXKI4J5XUmPKn4jKZUlujUEqua7/WFn53e9IJSmr6JVkybBjf0cQiCxKQ7ZLW5alLwGQRiifckWhz07agpxU7AS29Cr4JBWLjN7vcg8YggTxoo
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
2.50.1=0A=
=0A=

