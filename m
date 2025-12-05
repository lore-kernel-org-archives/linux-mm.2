Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5B55D33992
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 17:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CEB6B0195; Fri,  5 Dec 2025 12:00:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20DB26B0197; Fri,  5 Dec 2025 12:00:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AE076B0198; Fri,  5 Dec 2025 12:00:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E8E426B0195
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:00:13 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A8E8D13316B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:00:13 +0000 (UTC)
X-FDA: 84186030306.23.F5B593E
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf26.hostedemail.com (Postfix) with ESMTP id 01462140015
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:00:10 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=msBOPxoU;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf26.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764954011; a=rsa-sha256;
	cv=none;
	b=XIj9GdnFDZl+/qDx6TBpFWKoaZq3bAhISoHF5vDOowWb1P17x6LlgylNnqjANyG3ylNmfh
	W7Bc1Z2RLXkLvnu6rGh4e+T5EoxD/oEjCnOAcDCXYGT0fr257fqhEzcPn7lBQz82vI86aY
	J+eFykL+K6CxTl/notrKCWKnLUpq+U0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=msBOPxoU;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf26.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764954011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+Z5wrixfI4H8rTwsRxl2yKp4vaZueJxgsH7jlHoBL4=;
	b=wDHY2dUMj+bFWP1Sh0SzYnRdW2FLDHbpJyav7dFY1jyTWzpT3Lth/OnjCcpw4wq9VnXDDL
	EBorYHFyhhJGm5iW6JStAB6lKA3aeCNjTbV8ulYf7YhykzpHDglYoPZnDihk6MsnLfOFSW
	+tThZjareXo79dIgyt+b67y+CadhMLs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764954011; x=1796490011;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=j+Z5wrixfI4H8rTwsRxl2yKp4vaZueJxgsH7jlHoBL4=;
  b=msBOPxoUtR4KLnH8j/uG23lrUo5xKpaLhNcOgK8GrBMTDODI9AZV5qV7
   BnDjoRdxLQ8YXp+zXw1Th0tkmCGPdmqh/oGT2ApUkDymuiGU8FKUPYMCQ
   +abirJCJ0CBu3Riw9LqTVmSiedFbFPWfG5Clu4PGiPBjsyQUxVGIt41PI
   lQuMNwVbKtT2q/gEIqDhpGp4K9SAd+yC3wrdJlUUIiTYaj8LxcxFRLyAj
   UC3cPqQznrVkoEAULThSlab1oc6pJ+suknRP7P4CxhwkjQxrDok+XSz4Z
   rpnGf3fhyL9Z+Yu7X6tUDf8mOyNqWOSAO4Lx3XectwUYLDRCipi5xBCdJ
   g==;
X-CSE-ConnectionGUID: MRvNL6aoRryvv4gsH+MURw==
X-CSE-MsgGUID: jK4+obf/SNGZvM6PfooJcQ==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6306432"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:59:52 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:11955]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.26.175:2525] with esmtp (Farcaster)
 id ebbc9af5-ef2d-44ce-9711-a58d362cbdb5; Fri, 5 Dec 2025 16:59:52 +0000 (UTC)
X-Farcaster-Flow-ID: ebbc9af5-ef2d-44ce-9711-a58d362cbdb5
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:52 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:59:51 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:59:51 +0000
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
Subject: [PATCH v8 11/13] KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP
 in existing selftests
Thread-Topic: [PATCH v8 11/13] KVM: selftests: cover
 GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing selftests
Thread-Index: AQHcZgiSLmjQ8ZJCx0KLKn2zyDItvg==
Date: Fri, 5 Dec 2025 16:59:51 +0000
Message-ID: <20251205165743.9341-12-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: 01462140015
X-Stat-Signature: 1zydixew1cwjpyiykk63u9kjadk3matp
X-Rspam-User: 
X-HE-Tag: 1764954010-734535
X-HE-Meta: U2FsdGVkX18nX70cizN+kzHWaOl9wKj4Uev0ReRELYGdcFublH208K9BVNi/LQlp+gZahxw23ax5nwbOKOroiXl6Q+ar4spSILr6BFw+HyK2iIHDsMktdbSPr6PwvTmo8rNg417uDhOVDOLlomz3EAMp/Km86ZET6ReEtoT/0IYutAuZuKNB/EChCa5URvZsFHc8WnZxbqFJRO7TXi1wAW2cXAu9Q9WEtQ3HafBP7RIDAhenqnOurxlaEFYzvPQpunNgJilDrgdnLLH6SYEiumrqwdbTLrMs3CeOAWe22hDLzKLMJCwJb+yl9iLhAox88SMxJPRzFGfUsqsWO5ubf1SgY9LSK+DuqUB0/GdFZpfrMErMJpp5bnbFgME2wCT19ewxdfWaYbp16oI5ZjS+zYOJWENDmRP/QNHw9d/1UBUf5PQZgdpgIBKJuXvDNHhG391XnbdaK+AXe2E3ohtj1rEO2adeABudLSS25ZZ6NOslBTazISvYkCBAfZT9b39y9rDMKLOOcyjJ+JKtUg4+Swf39AaWY03AjtKeSxdkaWEqszijXlE+cxt/eao9ok7ogfxM23lN8uuG69zCL6d1V8Z5JYkg2gwSWHgdiS4aMFkNNXX+a3lp8yufC9Zg/fIVSlsOLEqj5gyMFSo+Kat6482DDuHM9zepqa8ZZ6D+KgwUFq9QaktPFlWAUe06GNb4xRKRp77+axoX9cSHoSBQ61XhGJIEhBAZGT6I6POlliMko1Qffqt08MYuLkrgPwQwfZNZf1BX2daRI2djzXDTnPOxTyaAxX2kQyikzkOS8t9BJNqJKmRgnznTm0IMoDCJfAj7DfxSuUsATXgNV8KchkFWptPz5zwHkv0jWyLvCKWiconZUFih19KjJExRiH2Kqt9ANIVmw0h1tY4CJ2AeV1cgU2B/8zejPXIzv7xDSkMuiJDIdQ2K9bdnwOPn1h9rp0y+rGNrQrHAwHXNIGS
 56gosKuU
 FHYjBdX7oUA5yaqd9/8bAAlreAhlGB7u2xXdABHws4nid5M7ljmGoIhdttuehlShR4g2bfaVSC0ACJ5OyoTqWnHOGL708ccVztHqunSx4+5nN22yteXwDi3u3za0LqrhOrnRNTaxWC0oRam/d2TB3YB0VwUtqKI7PB0kzBjdiR4CdaM/8h9xlfzoBalzNGuJ6esrhQuLIJiWRzp+F3Lrc5PwPl8Z9ZxkLvfh4kQ/6ShjwHfnJHnFB/TwS8aQNpbkIP9MYkeuj6OvzGMu7QttSk/qXwV3ef5Vul/jVs9LQZKGmJ3QGbDbSBQLguiksZMW3Mb+edTOWfX4NiVyVj69L9GjLYwteWVEJTC/98xMDIXnwIUqxrkn0Y2NWAJPnUrYWsJwZPC9csI40fxwPy5Vz0O8A7UHH8hvSJRNHStu6tdW93XC51ahPo5wBKly98xe7mo/8QpCP10yzYPwwSVkpcYLKe4ti9HPqS9UHQ8m7taZpBKZSSb1MLPwjS/Q/aHqz3XxP1/jU3TMz0xMfwkTHSdBC6ozXCU7+Gs3tyPsTdgqMj3eKWiSNI3B60gNRO+GMvE1pbaA/E2oOk53xD38t4okuHG56ErBvIDYSTeYUJqU7sD8fhlbLjAU1y63aJsCZEQIylD3FjgFTPRhDLq5x9dnPkX6In7YYSc06j0vY7i48MnrrQT51nCl7NtbuSDzFx6/iBbsTkniPUhF7qxVnQo2GJOPAfrltJmKv2soI0+HTP0Ct+Z1HazfczCU4vFSvrSN9+ev7AdJYGac=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 tools/testing/selftests/kvm/guest_memfd_test.c  | 17 ++++++++++++++++-=0A=
 .../kvm/x86/private_mem_conversions_test.c      |  7 ++++---=0A=
 2 files changed, 20 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/guest_memfd_test.c b/tools/testing=
/selftests/kvm/guest_memfd_test.c=0A=
index 618c937f3c90..9615018a1a67 100644=0A=
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
+		    "Default VM type should support INIT_SHARED, supported flags =3D 0x%=
x",=0A=
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

