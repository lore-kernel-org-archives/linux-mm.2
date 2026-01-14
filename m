Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AAC84D37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:48:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C2876B00B4; Wed, 14 Jan 2026 08:48:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F146B00B6; Wed, 14 Jan 2026 08:48:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08E5C6B00B7; Wed, 14 Jan 2026 08:48:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EC6866B00B4
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:48:10 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2BCC1BA66
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:48:10 +0000 (UTC)
X-FDA: 84330698340.16.95E0601
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf03.hostedemail.com (Postfix) with ESMTP id 2F11620007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:48:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=pI6Qkp1q;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398488; a=rsa-sha256;
	cv=none;
	b=CAg2c+ZJ9bm5d0bBgpOhBpUK9hZp3BxVQYK/515GHo27K1jNbiMuACQqTJfr1UeHE3jQE4
	1F1uW8KQtnR6JE7AX99B687VgixJfnJIh3nBb1GYl067gleQ8NHeVUSZd8B5LzuV54WEFf
	0UiaRB+EInQIf8NjWeNWPeV5DDjZG9I=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=pI6Qkp1q;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUXffJ10pcwposVmC9vM2kcbCnj2+0WuRal0d/tv1pE=;
	b=4sf9W1ky7JzOy9aAe2Yk9c/ExE9yNn66QP4T1kS/i4nifHx4w86hiQr7h6hUUTHHoNCaXy
	gsCnAH8sDw+lB/+0bftqVuwutkLItEOA/9uD46V9tvOIhxL7lRc1LLk/FUzNxKApUqkm5k
	i7fhSlCY3Oo/Rrrj+Iul9U4JoEOUusY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398488; x=1799934488;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sUXffJ10pcwposVmC9vM2kcbCnj2+0WuRal0d/tv1pE=;
  b=pI6Qkp1qpMcnkir5CghZWT6RWElA7mrzDKllmgl1Hw8u8TJhUhPT2V5q
   bkGO+ZwmD3PvCVc0tJVXWuJQsPUgfcnjvCFGyy/1HeDpSXwnyCrcK+96b
   8CoCt33heC9HiJ3IyAtyRPatSZcZp0hWXiG4gbTUrCKp6btgwcGZvdWvQ
   92Jx3v/f85BBrE9J6xc0wpqVc1j7q5iaNvrOncQxd2s+m9KYZ6YZs2IFW
   4qBaCPGd2huQlTO3x3r1rqJLeb4HZcwRSMmseefPN58pubN6ybhxxBRQL
   2nK+FZBnEhbWacpoRVY5VZgFod22lhX4gtijmaZzwTGLlrEDwfl+pb7zy
   A==;
X-CSE-ConnectionGUID: TM2P1oQYSV+xOXLTuttl/A==
X-CSE-MsgGUID: EW6MjOESTFSHJbSl7EhLcw==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7897283"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:47:49 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:3376]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.7.212:2525] with esmtp (Farcaster)
 id 24ecbc43-4ad6-4a75-8fbe-89bf20ddb079; Wed, 14 Jan 2026 13:47:48 +0000 (UTC)
X-Farcaster-Flow-ID: 24ecbc43-4ad6-4a75-8fbe-89bf20ddb079
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:47:40 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:47:40 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:47:40 +0000
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
	<loongarch@lists.linux.dev>
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
	"riel@surriel.com" <riel@surriel.com>, "ryan.roberts@arm.com"
	<ryan.roberts@arm.com>, "jgross@suse.com" <jgross@suse.com>,
	"yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>, "kas@kernel.org"
	<kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "ackerleytng@google.com"
	<ackerleytng@google.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"prsampat@amd.com" <prsampat@amd.com>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
	<gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v9 13/13] KVM: selftests: Test guest execution from direct map
 removed gmem
Thread-Topic: [PATCH v9 13/13] KVM: selftests: Test guest execution from
 direct map removed gmem
Thread-Index: AQHchVxZK9VKx1JGv0KQmfxswHb3WQ==
Date: Wed, 14 Jan 2026 13:47:39 +0000
Message-ID: <20260114134510.1835-14-kalyazin@amazon.com>
References: <20260114134510.1835-1-kalyazin@amazon.com>
In-Reply-To: <20260114134510.1835-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2F11620007
X-Stat-Signature: mdrsf9jikom83ta745uo3p5gufogyqt6
X-Rspam-User: 
X-HE-Tag: 1768398487-892829
X-HE-Meta: U2FsdGVkX19RecjYZfURTzJIxd28hOoo4Mi2CMcN9vruiT2d5HQNxSkn1Oz1h+5SIyqZTPvGj3uEjVk6tYGNsnz9v/DtxvSlBqNJCE8NYKTkVAQxSrKU7MEX6Z9rQyAb0UHBIEs+a6wlgQecej0TqrG2lgEHX5L2FEg768/B3pDfsX6X20pWHjORgBt3YwGpeBt0RiG6lqq8cBWsHimBG71u64wIv/YIaNg9HlpWPsutWHZzp8d053OFXLeAiA/1TPvnO4iQSSFQhv9486piDhr0qzpSWGTViGt4NrvqLWQvOBKJYpUdT8TEjIrNw4mpx24BA4Gal7ngi+Dv7TQDGuD7Mo6NUnrqi00DiepEm4teyd+aheqxlRi6Caw95pMnyotyFwh0Kb+TGLXqnTqm/wtyPODz2pcvaJZhhwJjAwlDDuHIBLQ5mnxpXfDIedY2NV3Qb3OT2h5UXsaL72X57v3pJ2JTLtyn+iiVRmUbF0NsrZoZkK2XAoIh5O4Z3P2MWc8NCYauSRy1EIV/2viiozdUDKenK+cKNh3cEuNQa8lGWnWOgNd29e5/gsSdt4GHPqgOmdxUQIB5ixggkuS+D1vvKc7sdCAHESQKGSKfRNkSBw4FCMyzBThd64+LFp8qDvGTy73pnbzzqhqNI4KXnVF6oJQTB5hN0GUyiElYAkA6Q8q2xD6yjPS5b9RYDKsWqQrfrqsjnR8AkCc5Z6YlUOM55+hdO8KVk7mYACZE3Vtyc72LG0Fa/96NrqBG0VkhxGkOCGOdWrXdQ6go5knHE7geU2f4A7RIHNlrMLeB/VqkEYYiH4+AQ+CKWuGxfpBRcPfmHM8tJ2MZB8nAw1Ja7Ts5JOSWJ9Eld7UmvxNwBDy21AgyV8RpibC+KviJpvev09H0w3765dnMLz0GG2fcJN+Tz/nnWzIJaF2BJ1ds6ElPoGSLjXqrb5P2ONX4OyF/SxyhX/TVgEEvvWVeLQ7
 D6ekbWp4
 bqU36eeobOvR9VA8qxtQlzJMsNWpNJdecMprYSTv6lBPRLiajnSboDbKoFAmxSzHN/q7jm9MZtl6jAIhIUJ7B0d2IPbOI9v2gDCrGI4yBGsiU6/WALbty7qGak/a7a6P0MvuGorUhz8yikvtKmcny+apkqPdXMEZwbEp8/vppwTO6F0dX3VjvztL9YbymHH6t3zO4u310oY44BVY9G3ymXLpQyl+pBBJ+37tFSYTswmRoWxjbPh5FR/ue3UwLX3D+87TmTDyUkV8J9DBQZ7d8PeWrV2qm2XxSdNMLXQZmbG5Fze/jMp23xWhPDz9MEvxDJmaMS1mXCdsoPWi9P2jEGW2qlQCd3s9Tt6vZNId5uUsGyt85En/2t5WCulcGPsmZv5RA50SgElYmfhmo72DbH5zYLH4pqFYqCQVRBENpzIGtZpk9dDbc8b1KSVRssi/TEKTOTFwG3cM1Zhslz/R461RzBJ4WGgvlrjhgFbmjbBSehS67WnMy14E0A2Oqnn+0lk4avFVbYJe1D/yNFQMYK3pmGGac8HntPgr9Gm76sK0+tiDZ4JF+wIE4OyaBYErOthwu9Ao0RWvKpNITjlmgECXp5yi1D9dlsvwGFzObCZfywAI/9fFAkDix1QLj/Bobl5vA/rJQgf7tMyGDNFojEePzyuDmovx5OkbOIChAifeGADervAVkwh7lFrEcZTRwaG5DgjyfNPvtgY0kJPRCSwpusw==
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

