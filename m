Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF229CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F6698E0018; Fri, 12 Sep 2025 05:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8278E0016; Fri, 12 Sep 2025 05:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39BF28E0018; Fri, 12 Sep 2025 05:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5E98E0016
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:17:55 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB40E160711
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:54 +0000 (UTC)
X-FDA: 83880046068.25.B1722BA
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7C8B2C000B
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=klPzEPFK;
	spf=temperror (imf28.hostedemail.com: error in processing during lookup of "prvs=343957b79=roypat@amazon.co.uk": DNS error) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668672;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhEedpfYEt1PcCJtARYDpqAPZgRl3DEDExfgwDPiBsk=;
	b=Ypmrph45mqHMXgWe8uBLKe/PFkJun2UESEr28IszqUDUfjOO3tXEtaC0KP82DufD8uOMoK
	SDbJg1NLDDSV6KxAkdOEHpYuJqeSqyYqnoWIrCkuhZdXmKLCFYm/0Rcd3ROotIE3mGu63L
	lvUprrF4lvNr6PPhHGnDBUM86yizSeU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=klPzEPFK;
	spf=temperror (imf28.hostedemail.com: error in processing during lookup of "prvs=343957b79=roypat@amazon.co.uk": DNS error) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668672; a=rsa-sha256;
	cv=none;
	b=1MdoEz09YFco1tArEZj6881ZSIbN6aBAuJ3ch11XPUBwW6iDVfoXvC8Sx6BKqRisIrw/85
	oTcZGc5Js3jPEDB93WOpWl8bHsRqJbqrGW5MkCjwsY0xCwL2HNXn/3sa0aQAsgg3GI+l41
	IdNSFUZLJzAk2EITMys7qJDkg3OioYY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668672; x=1789204672;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=dhEedpfYEt1PcCJtARYDpqAPZgRl3DEDExfgwDPiBsk=;
  b=klPzEPFKq6HFW7MdT5sYzX7btRLPXiwY0+j44rgX39ZOYH6oDMtY5uCr
   TRVRYi7ncwUJ2qDM8EVmFEIA6zlMR44XpJBW6o6IwCHv1oxqJi82uJhdl
   d/oK000dv5BYonhIO4NMqa9zBsycB5DrF+W1h2gmJLC6PLMcq7puOyJIX
   g1CNNqRfdC3NAV/HphSSmWskKqvbqJIs8V1oS580MzzE/8eJYoSdPGhab
   MC981A4krdbaZJWOBxpkxVz20G9DgHH8h+lCP1x+UhvUBOW8JC+aqBzHZ
   TUH7DwDC2VJ13bA+t95T9iWd0XXC/+7Mnu0kVpr6fZxTRDc4Vdxch37n1
   w==;
X-CSE-ConnectionGUID: W6I7DBGsT7aIZUgxxd8n6A==
X-CSE-MsgGUID: biCfRrtRTymbPzXlG7U+9Q==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="1905409"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:42 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:21541]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.45.248:2525] with esmtp (Farcaster)
 id 472e2554-8a6f-4381-b8b5-7eb2482469c1; Fri, 12 Sep 2025 09:17:42 +0000 (UTC)
X-Farcaster-Flow-ID: 472e2554-8a6f-4381-b8b5-7eb2482469c1
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:42 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:41 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:41 +0000
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
Subject: [PATCH v6 07/11] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v6 07/11] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcI8YXZeuO05bOzUOx1mmYQcKn6g==
Date: Fri, 12 Sep 2025 09:17:41 +0000
Message-ID: <20250912091708.17502-8-roypat@amazon.co.uk>
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
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7C8B2C000B
X-Stat-Signature: 8xz1zkcqgi5c99hu1485ky1pqdjh4f9y
X-HE-Tag: 1757668672-406531
X-HE-Meta: U2FsdGVkX19nbbuZZsdSflkynvH5FMZu4rL5cU91JgqneclZd1MMI/L7dcW3f30bp6HD71zkpHpcD/Qzo2SeCFS7LxrZWUpbZg21SyOXfU89stjHxjLkzG480V3FwCT0ZvwciHPRyc0GsLrW09s0sS9cbGF4C5lZirTCPaf591wKVkDdU2qEQIcBGTm3Pr+UTSUtweKIn5L0p141HU46QarjDXNAkYOLgkmAUHnYtGzfsmFNijSfLamyce5Jnb6i2WBXtVIeIZrXwTkH/CkOhJ2Xu8VlzNkphB/Nr17nrAc2kLpdkiyaYyJUGB+vRg1XvejGExT6bALov1dFVAcq5F0qQZaySqqDEQWwFSZ3sh7aV+9VdcNy+v/w5n3ThRG61dIJDdDR9bSQLuTeFHFm25hGHJ1ItG9k18QRNkX3WaruPNj8WoNrBC+QNQGu2aasLHVVStsEwqAMRvkEWAu2tJBOLz/ioHRjus4UhQWElIrcYV10g8/+dvaPO8H+PFrnDk+Uj6kuJ9uan4YF9eQOX7ieeM/NhJwzoXkmlX+Xm/vWbUlunscNYfm4DFfhbEmzkyJYQwR3HQI/EkW8rfLhgczqh4FDeXypu82Qa2q63QTAcvBB6xEw/VjFkw5jcQsrbeJoUwoAX2jJPIwQqvTbogD9YddpEd+SrmphCUBzVDulWRkwO5fTZTAQT40PnWtw9kB0qMNHXC0Ewdstc07PXgSPK74pfZpoQfe8JEzBE8/V3RXkNp/yz2+gkGnMKCk8yRFwMHtQB7Yc1V01NKQHkse/3mDsh0JPCA9MUZnDMl9Q8Wpg05WUf9gJYE+HAYpsooty6SGzOQH3qycT/QdkpfbknD83IDtynLl+nWZ0Pi2BbhDFUPGZiJK6UCUDJzGNRH7qSRvPuAOQDyc9To6XoIIUX2a+svRm+g/HWxm1zxlYkYxGfnMCXWl8DHOhhrFp2IzImOkhngp2Bvv7Tlx
 o8rIy2ZA
 wRx9rOxThqvxGaS0AFcMq/IOzQwoNbq+3prMH31NIJVGLusQrP6LxaKWeiTFpFyKkKRREwxrLjL40SVMdR9wbkxGMWMBigJX8g8yxqV9BMtu/GKMqHi+eHjV268D0kKzEmkbGfnNjrgdaa1WJFacDQJJaQhvJf9fXXqZnP1+fcUsMtAI8+kvsS7ky9l0/nYe4KOBW1yr23rYjqmlsHFllcEtROV1EEFlX2i2/+2JxIXth0XLKObWjwzC9Sdqvh66/UvUE6ST0zmxJ/KHYQUGEG2oikf/lO+f9nu0sRIv8frWmfApVEl5w6EqdmdHJQW02AnfImNIUvHmX3pw3YVP9cdHxMnFn6OKzHjQYhh5lcNJqoTAxLsEZaFe7RnK41IJmPW0ApjwuAhGucfl/n3cQAwIwW3zs9kY/nq3d9xxrCCW+GguZcTOYSk2/3PE+biqSUpM296Djzj0ruWNd919OmiqrNwAgeqYrXmE+E1QB6PwC8BVsvmYXTJXDdW2ornZBu/sx4K1jOx8s5fAN+zw3maUnL8XNqn5tZAY9KwFzxvjecRhEDW1RUrULqpEdKeqPHNdgfgdtTKXp7XTP/M3nf3t6Wmse4NWhkJcKr0I8jYcyjl2gQ6pjjkqjpKBglqO5ZVHhcg0uFw3qsyTJMoHgRfrJhnNeSVK4aEwpggT1poJSQqFlJ3HwRhfycl1IYwvd/jwfkpRn9qORU8xK7gIvZC4YEE1KdshJ5qD2L/Jhpr3sSkgZ88mrc4a47uZQvvj9y0+JwTFVshLgnlbktbfxKA2aznhso2c1tAb9jjGlJUUA0rDk5zosf7br9X1hW+bVS6gaOwopawoLSXf0hNP62hrzz9uzbBmVJJKPa3+0pgylRA9PVyYN1WIfxTLvjHollhzLjJ678/noPZ1Od8pRFokTfA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Have vm_mem_add() always set KVM_MEM_GUEST_MEMFD in the memslot flags if=0A=
a guest_memfd is passed in as an argument. This eliminates the=0A=
possibility where a guest_memfd instance is passed to vm_mem_add(), but=0A=
it ends up being ignored because the flags argument does not specify=0A=
KVM_MEM_GUEST_MEMFD at the same time.=0A=
=0A=
This makes it easy to support more scenarios in which no vm_mem_add() is=0A=
not passed a guest_memfd instance, but is expected to allocate one.=0A=
Currently, this only happens if guest_memfd =3D=3D -1 but flags &=0A=
KVM_MEM_GUEST_MEMFD !=3D 0, but later vm_mem_add() will gain support for=0A=
loading the test code itself into guest_memfd (via=0A=
GUEST_MEMFD_FLAG_MMAP) if requested via a special=0A=
vm_mem_backing_src_type, at which point having to make sure the src_type=0A=
and flags are in-sync becomes cumbersome.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c | 26 +++++++++++++---------=0A=
 1 file changed, 15 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/lib/kvm_util.c b/tools/testing/sel=
ftests/kvm/lib/kvm_util.c=0A=
index c3f5142b0a54..cc67dfecbf65 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1107,22 +1107,26 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
ing_src_type src_type,=0A=
 =0A=
 	region->backing_src_type =3D src_type;=0A=
 =0A=
-	if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
-		if (guest_memfd < 0) {=0A=
+	if (guest_memfd < 0) {=0A=
+		if (flags & KVM_MEM_GUEST_MEMFD) {=0A=
 			uint32_t guest_memfd_flags =3D 0;=0A=
 			TEST_ASSERT(!guest_memfd_offset,=0A=
 				    "Offset must be zero when creating new guest_memfd");=0A=
 			guest_memfd =3D vm_create_guest_memfd(vm, mem_size, guest_memfd_flags);=
=0A=
-		} else {=0A=
-			/*=0A=
-			 * Install a unique fd for each memslot so that the fd=0A=
-			 * can be closed when the region is deleted without=0A=
-			 * needing to track if the fd is owned by the framework=0A=
-			 * or by the caller.=0A=
-			 */=0A=
-			guest_memfd =3D dup(guest_memfd);=0A=
-			TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memf=
d));=0A=
 		}=0A=
+	} else {=0A=
+		/*=0A=
+		 * Install a unique fd for each memslot so that the fd=0A=
+		 * can be closed when the region is deleted without=0A=
+		 * needing to track if the fd is owned by the framework=0A=
+		 * or by the caller.=0A=
+		 */=0A=
+		guest_memfd =3D dup(guest_memfd);=0A=
+		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
+	}=0A=
+=0A=
+	if (guest_memfd > 0) {=0A=
+		flags |=3D KVM_MEM_GUEST_MEMFD;=0A=
 =0A=
 		region->region.guest_memfd =3D guest_memfd;=0A=
 		region->region.guest_memfd_offset =3D guest_memfd_offset;=0A=
-- =0A=
2.50.1=0A=
=0A=

