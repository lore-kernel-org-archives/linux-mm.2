Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AD10D33995
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:59:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E434C6B0191; Fri,  5 Dec 2025 11:59:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3B26B0193; Fri,  5 Dec 2025 11:59:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46296B0194; Fri,  5 Dec 2025 11:59:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AAB426B0191
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:59:53 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74D3514027C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:53 +0000 (UTC)
X-FDA: 84186029466.02.1C7DCB4
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf14.hostedemail.com (Postfix) with ESMTP id D2CEB10000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mpk9Rifo;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf14.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953991; a=rsa-sha256;
	cv=none;
	b=IMPCWz9CKPsfP5nSrTkmIfBafYRD1tM77dnYLRNzbi0YRAHnbq26t3MMFFPebvWEG+C8kz
	nnWE+Po8sIMLewYJ/uGEnE1ldodDCCu+biBRSB7FdY+RiSS+ZIg0ugQQV/3WyrEZTvVV8t
	XkE3ew3Ly6HS5bzdlOnd1gECumSHcBU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mpk9Rifo;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf14.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OprfmizXxq8RRTSlSSc6Z/sKanOls1Ur59Qhbz1MdVc=;
	b=e1IJSaDHuOAlqiHfu4EWHepkuRMgWqL1dEPVYJAvH0lVq2g7sucaq6u0yPus6tVnS4MMSk
	NqtrqjK0+H0wPGkFsJClggFTuC9c565AhsSZ37CF0vRC7E3snpwsm/tg8VQD2adTlf7e8d
	4MQ4Ad1YmhEUSWhwLsNs9GdHW9TwUro=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953990; x=1796489990;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OprfmizXxq8RRTSlSSc6Z/sKanOls1Ur59Qhbz1MdVc=;
  b=mpk9RifoeRTYPhnfQeA2FaMVh5SoPj78m/vfQLZY0qWCakb7ETRDwnSC
   oU0LlxJltm0YUa+uxQEBwdV16B82Ut5nym3IFrlYk40QEK5r8dJEL23rv
   DE1z576IbLmVW5fJoGtOrdlHuejsYWAmvWju1axqfwWiCLJ2F8NSwwIKL
   JXMeFZHw+NLglk9mZNxFc//FEzfW2X9hSfVJEFFtWoP3LN6aMuT+9ZBnc
   e/lnMus/bUpC19/jF02nSeYfS9RCAvK16pt/lCWw4/3wm5ixQMY46FuTY
   1htdZXZwb86c3qeVcnnT2vzmqYawKGpgiRkXBSqoyeGDubInVaiv2wsHU
   A==;
X-CSE-ConnectionGUID: wdWaJSd5SF6NQona6voUBg==
X-CSE-MsgGUID: mLPb0a/XSKCaS9kn1GTYnw==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6206137"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:59:49 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:11504]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.24.148:2525] with esmtp (Farcaster)
 id 34fe6e69-dd5b-4480-b95e-ddc8757a2feb; Fri, 5 Dec 2025 16:59:49 +0000 (UTC)
X-Farcaster-Flow-ID: 34fe6e69-dd5b-4480-b95e-ddc8757a2feb
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:41 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:40 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:59:40 +0000
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
Subject: [PATCH v8 10/13] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Topic: [PATCH v8 10/13] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Index: AQHcZgiLyS0oCQO1nUODCs70+4I+GA==
Date: Fri, 5 Dec 2025 16:59:40 +0000
Message-ID: <20251205165743.9341-11-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D2CEB10000D
X-Stat-Signature: 8ctzz4i9j6y5szqmcjbgejysn6rzdz4i
X-Rspam-User: 
X-HE-Tag: 1764953990-292093
X-HE-Meta: U2FsdGVkX1+nS1yXdfCtOdH+G153zwiRrr35MqAjg1Nt9vC/7WO3q1+OynKiS/Z4EQ19/deTfeBUjnU42KcyEwhOC5TmBnFLTpA00v9ZB2Qtj0OkAnpbE3Z2kExB2gRkrwf6T2KQ8p40qWTL35rFXJIbZn4mO+Tn8KniXd4rYitHYXTN2nyJ6f3oyZ12NRd4/QlhhQiPI2oo/PL8o5igxm99KMtuLBRa3qsmijLxJDXsXwyQGNv/P/Sg7JyFDhPHYVKcmQQJmoNaeITX6ifxaNIEcqjDVtNja2jo10wmOHm08SGFCXF1iDRceOcxa8Rzja2KSpGZoY3zllLOeeIbOI6aBTMyjQMOmsxZHDsj3FfURU3rR0O4EtFCZIyGPhUOKTyck41yvWovr7fzXcD3/yRp/QYkVTLKXBN8fbQjB3lEbIsfrEomJMlOTYnRUuI8fU+OKxG7gzcosBfe+qymHvleStTPhIzA7vGP7byjRHfqceTbpUzi6a2019bHUHsgQMK3XW8lUjDjY+Hb9I/WeNlfRH4DtrlwXrQ25UKN0P2Ldxd5HC17toINb2yUIcrzwtdOCd2zOpENI66UKi7TFD3PSJE/Nzbv/xtN1odyck0zyxYsDoypjebacekoMpOP7/TcFE4bY9vqUsM/zZGhK3beUbGb2eAK0mSk2KZPUDoOb413H4kOKXNmzr2v1h1r1jVXujS7NEFukeoh3A5/HuSjbS5NDSCUUwOay2JzLWCga5ojtsk20WISx6cn7ldpPOsflmEfnwZJj8L+iZS347l5wMLHZ9akq+4G5s6tiSiF3VHCTwjgjsu3jorSWk6AAy4/BFO49wpuYfoPvqr6aS0OIkWOJInmKqvZwLU5zfGHMqPT6oYwZzfoLAfpvs5QgKzAaX8uZIqG260oJeziXEgKQ2LH9pRHa49qeMsTdEBkSHAV3qS3QAzsoU/oOxK9NQ1kP24VJtFMeCoex2N
 reaf0l54
 A01tfGB+a4Y77cvrYjWs3x5P86HY6lkDC+Z/o1hZqiyBihPnNbZeJqjpxX6WGzJPQcppRY47qpy4ojzFsPHoY5z1aHrrhQtRf+dW4rNtlQuTuiHjufH6g5Agds1FPwNDbCaSA0ESvU0AXa3RfCcWrc8XBVgwJmi5uhbMqV8QWrebQb/HxjZFLLcb7Yey4384mkUGpck6jCueaXL6OmQnDuLK0SFJ/p+4kA2BkgDmI23hKDW/2A7QBs8G4rNiw24ilxyharxWcr6FBtc48xItieY/tKNlf9lr9CsYkIJ9wl3rV90twXOF7NSumqRIm0cEoWsDt2T1O5zMkEY/ydTBhKKRyviXj4rr39cWWp4F6hJ9wNokJqHGwDQQqCF9bhOaR6MEbmZS1tYmwAiKVCto3uPtRHVhjuqTCe7D8sINJogJpMA/OWY1+/eaXALI6+LYtFuUoEZHZfrZXJIDTs5XTP/EVrT89ESnx8mnAO51jmtRScvYVPpr7+jY83fP3EZqQJfJ0Bojadpou0LuMivVpmm69i82SULtcOXePaxt3jBuEtJuK8v9WO4c88EKS0yoVXYO0sIyHXL0ehurvMB3yCziJi5UNhvtbVM8VbP1Koi5c4EEFTzvRzxM/OxpMPhHscckW9VmoLpKbiDH2PCd1NG0To9ameH8sBu+Y5/FLBsqkiOUosYJsHCRIIeFTyCXR63T9PI4+X5Wc/9ICDEJC53fDvze7RO2qqF2M2/hy4guka0AJWMJ49W7WExlwyI6YFk6D
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Allow selftests to configure their memslots such that userspace_addr is=0A=
set to a MAP_SHARED mapping of the guest_memfd that's associated with=0A=
the memslot. This setup is the configuration for non-CoCo VMs, where all=0A=
guest memory is backed by a guest_memfd whose folios are all marked=0A=
shared, but KVM is still able to access guest memory to provide=0A=
functionality such as MMIO emulation on x86.=0A=
=0A=
Add backing types for normal guest_memfd, as well as direct map removed=0A=
guest_memfd.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 18 ++++++=0A=
 .../testing/selftests/kvm/include/test_util.h |  7 +++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 61 ++++++++++---------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++=0A=
 4 files changed, 65 insertions(+), 29 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h=0A=
index 81f4355ff28a..6689b43810c1 100644=0A=
--- a/tools/testing/selftests/kvm/include/kvm_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/kvm_util.h=0A=
@@ -641,6 +641,24 @@ static inline bool is_smt_on(void)=0A=
 =0A=
 void vm_create_irqchip(struct kvm_vm *vm);=0A=
 =0A=
+static inline uint32_t backing_src_guest_memfd_flags(enum vm_mem_backing_s=
rc_type t)=0A=
+{=0A=
+	uint32_t flags =3D 0;=0A=
+=0A=
+	switch (t) {=0A=
+	case VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
+		fallthrough;=0A=
+	case VM_MEM_SRC_GUEST_MEMFD:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_MMAP | GUEST_MEMFD_FLAG_INIT_SHARED;=0A=
+		break;=0A=
+	default:=0A=
+		break;=0A=
+	}=0A=
+=0A=
+	return flags;=0A=
+}=0A=
+=0A=
 static inline int __vm_create_guest_memfd(struct kvm_vm *vm, uint64_t size=
,=0A=
 					uint64_t flags)=0A=
 {=0A=
diff --git a/tools/testing/selftests/kvm/include/test_util.h b/tools/testin=
g/selftests/kvm/include/test_util.h=0A=
index 8140e59b59e5..ea6de20ce8ef 100644=0A=
--- a/tools/testing/selftests/kvm/include/test_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/test_util.h=0A=
@@ -152,6 +152,8 @@ enum vm_mem_backing_src_type {=0A=
 	VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,=0A=
 	VM_MEM_SRC_SHMEM,=0A=
 	VM_MEM_SRC_SHARED_HUGETLB,=0A=
+	VM_MEM_SRC_GUEST_MEMFD,=0A=
+	VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,=0A=
 	NUM_SRC_TYPES,=0A=
 };=0A=
 =0A=
@@ -184,6 +186,11 @@ static inline bool backing_src_is_shared(enum vm_mem_b=
acking_src_type t)=0A=
 	return vm_mem_backing_src_alias(t)->flag & MAP_SHARED;=0A=
 }=0A=
 =0A=
+static inline bool backing_src_is_guest_memfd(enum vm_mem_backing_src_type=
 t)=0A=
+{=0A=
+	return t =3D=3D VM_MEM_SRC_GUEST_MEMFD || t =3D=3D VM_MEM_SRC_GUEST_MEMFD=
_NO_DIRECT_MAP;=0A=
+}=0A=
+=0A=
 static inline bool backing_src_can_be_huge(enum vm_mem_backing_src_type t)=
=0A=
 {=0A=
 	return t !=3D VM_MEM_SRC_ANONYMOUS && t !=3D VM_MEM_SRC_SHMEM;=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index 56ddbca91850..28ee51253909 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1013,6 +1013,33 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
ng_src_type src_type,=0A=
 	alignment =3D 1;=0A=
 #endif=0A=
 =0A=
+	if (guest_memfd < 0) {=0A=
+		if ((flags & KVM_MEM_GUEST_MEMFD) || backing_src_is_guest_memfd(src_type=
)) {=0A=
+			uint32_t guest_memfd_flags =3D backing_src_guest_memfd_flags(src_type);=
=0A=
+=0A=
+			TEST_ASSERT(!guest_memfd_offset,=0A=
+				    "Offset must be zero when creating new guest_memfd");=0A=
+			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
+		}=0A=
+	} else {=0A=
+		/*=0A=
+		 * Install a unique fd for each memslot so that the fd=0A=
+		 * can be closed when the region is deleted without=0A=
+		 * needing to track if the fd is owned by the framework=0A=
+		 * or by the caller.=0A=
+		 */=0A=
+		guest_memfd =3D kvm_dup(guest_memfd);=0A=
+	}=0A=
+=0A=
+	if (guest_memfd > 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
+=0A=
+		region->region.guest_memfd =3D guest_memfd;=0A=
+		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
+	} else {=0A=
+		region->region.guest_memfd =3D -1;=0A=
+	}=0A=
+=0A=
 	/*=0A=
 	 * When using THP mmap is not guaranteed to returned a hugepage aligned=
=0A=
 	 * address so we have to pad the mmap. Padding is not needed for HugeTLB=
=0A=
@@ -1028,10 +1055,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 	if (alignment > 1)=0A=
 		region->mmap_size +=3D alignment;=0A=
 =0A=
-	region->fd =3D -1;=0A=
-	if (backing_src_is_shared(src_type))=0A=
+	if (backing_src_is_guest_memfd(src_type))=0A=
+		region->fd =3D guest_memfd;=0A=
+	else if (backing_src_is_shared(src_type))=0A=
 		region->fd =3D kvm_memfd_alloc(region->mmap_size,=0A=
 					     src_type =3D=3D VM_MEM_SRC_SHARED_HUGETLB);=0A=
+	else=0A=
+		region->fd =3D -1;=0A=
 =0A=
 	region->mmap_start =3D kvm_mmap(region->mmap_size, PROT_READ | PROT_WRITE=
,=0A=
 				      vm_mem_backing_src_alias(src_type)->flag,=0A=
@@ -1056,33 +1086,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
ng_src_type src_type,=0A=
 	}=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
-=0A=
-	if (guest_memfd < 0) {=0A=
-		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-			uint32_t guest_memfd_flags =3D 0;=0A=
-			TEST_ASSERT(!guest_memfd_offset,=0A=
-				    "Offset must be zero when creating new guest_memfd");=0A=
-			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		}=0A=
-	} else {=0A=
-		/*=0A=
-		 * Install a unique fd for each memslot so that the fd=0A=
-		 * can be closed when the region is deleted without=0A=
-		 * needing to track if the fd is owned by the framework=0A=
-		 * or by the caller.=0A=
-		 */=0A=
-		guest_memfd =3D kvm_dup(guest_memfd);=0A=
-	}=0A=
-=0A=
-	if (guest_memfd > 0) {=0A=
-		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
-=0A=
-		region->region.guest_memfd =3D guest_memfd;=0A=
-		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-	} else {=0A=
-		region->region.guest_memfd =3D -1;=0A=
-	}=0A=
-=0A=
 	region->unused_phy_pages =3D sparsebit_alloc();=0A=
 	if (vm_arch_has_protected_memory(vm))=0A=
 		region->protected_phy_pages =3D sparsebit_alloc();=0A=
diff --git a/tools/testing/selftests/kvm/lib/test_util.c b/tools/testing/se=
lftests/kvm/lib/test_util.c=0A=
index 8a1848586a85..ce9fe0271515 100644=0A=
--- a/tools/testing/selftests/kvm/lib/test_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/test_util.c=0A=
@@ -306,6 +306,14 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_=
src_alias(uint32_t i)=0A=
 			 */=0A=
 			.flag =3D MAP_SHARED,=0A=
 		},=0A=
+		[VM_MEM_SRC_GUEST_MEMFD] =3D {=0A=
+			.name =3D "guest_memfd",=0A=
+			.flag =3D MAP_SHARED,=0A=
+		},=0A=
+		[VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP] =3D {=0A=
+			.name =3D "guest_memfd_no_direct_map",=0A=
+			.flag =3D MAP_SHARED,=0A=
+		}=0A=
 	};=0A=
 	_Static_assert(ARRAY_SIZE(aliases) =3D=3D NUM_SRC_TYPES,=0A=
 		       "Missing new backing src types?");=0A=
-- =0A=
2.50.1=0A=
=0A=

