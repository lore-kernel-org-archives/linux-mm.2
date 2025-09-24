Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A297DCAC5B1
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:23:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 929D58E002A; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B3248E000F; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 690558E002C; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4CA3E8E002A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 139CB1A08C5
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:58 +0000 (UTC)
X-FDA: 83924511636.14.AC73579
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8B7721C0008
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=kP8LC+DM;
	spf=pass (imf20.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJOu6NiPRHKGbAxmxO54HB96XwzMK1lGzyU7ogX7dFo=;
	b=OFIZnYYgrT0dyZaE5HkzWKYMLsZ7M/0dzhZWMtbJ4L3cgadYQorGpAGem4wyS19ZPHEMIN
	XGq1EJ1cuoBPjbBVfmoD8fjhGAE2O3LIAZYyzVFvv6RZ4LLLXmtbGEhMcWvf5OMKgbD33R
	+ERQhFbzI5FpzA9ERf2vkHhfqf3qEWQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727375; a=rsa-sha256;
	cv=none;
	b=lk2eP70ih4Zo3atq2UT6Klxm9xmErMwlmNAp5KgxkxU6W+0fmFT9A1NvhXyHAiWq4j314T
	pyAxUcsbwseVeX6MUtH1lbRuDiiQfMXLBKiOn9dfmPdGifiUlrg6tr8e5KlE0D3WdovYRh
	c4cyyLtOy0hGFq5IkxZMv5C83i8LYYA=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=kP8LC+DM;
	spf=pass (imf20.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727375; x=1790263375;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=fJOu6NiPRHKGbAxmxO54HB96XwzMK1lGzyU7ogX7dFo=;
  b=kP8LC+DM1fC0otElTMWKtosNvpsTKDjGZgLR8AT3VsGPkn7mQJXwLC6B
   A5oJgtAMwVyXFen4VZqloiFtli1KVrRkoySbdk7K4QsSc+Hjzq1rvX1HA
   Ih/G9J0dijTmVUWjCT+3ury1V+Q+grE8J+4Xqq5BOVohOtoXcQrq/Cvbn
   cg1rgnoihIEpzNWTCbRWgwm19xVqIovvFUDfbkWCAyw1Yqwx7ol4nwQPX
   0I2lDZAkLnYmd/usK+NUr90EplPhTO3J+VrOV7MkYb9D05ddGspbfvfiu
   AHw+Uu8mXoAIw5aiBICZZI9cnoF3Jla3t92+QmNJOA3rYBs2A99UCN2ZC
   w==;
X-CSE-ConnectionGUID: rSroFb0ARWmw0Sy5LmfIRQ==
X-CSE-MsgGUID: y4Usvse/Sea9wZWqmxuH8A==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2617782"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:45 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:30897]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.38.97:2525] with esmtp (Farcaster)
 id ca0be2fa-8622-4408-84d1-4640ea539def; Wed, 24 Sep 2025 15:22:45 +0000 (UTC)
X-Farcaster-Flow-ID: ca0be2fa-8622-4408-84d1-4640ea539def
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:44 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB004.ant.amazon.com (10.252.51.13) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:44 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:44 +0000
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
Subject: [PATCH v7 08/12] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Topic: [PATCH v7 08/12] KVM: selftests: set KVM_MEM_GUEST_MEMFD in
 vm_mem_add() if guest_memfd != -1
Thread-Index: AQHcLWcT9Q16CQNUGUCCXH4Q/39gag==
Date: Wed, 24 Sep 2025 15:22:44 +0000
Message-ID: <20250924152214.7292-5-roypat@amazon.co.uk>
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
X-Stat-Signature: uzz3cp61o5z9g38r7x8otufnfnfjo99d
X-Rspamd-Queue-Id: 8B7721C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758727375-262730
X-HE-Meta: U2FsdGVkX18H8ifuLqQ2rzrFwk4iX2djdebDw+PWPJ5jvALdQ7s4pMwsTRWFNo+UzuOkyvm0LmFbZnOQjxDocJ9MKiOtv97MQ+o0/iVzWyN02KtYQlD9RsZE/BrC68M77YbXHwVTzSBDxOYIEFj7LKY6XaTa5aQbUCQILh8nHfl2NskuBUkKgs04iQchQzG4oBuW5k2uOHEI76geCuUdanlroe6k5pxUsFQjo3/qm73FlJzKSpQ+os93lDzzxbjUX2ss/+rAnnavSA07ZTFSHNCLuXMhTUZ1GZlyV3U76mjkhYsRw3Tpz4YPbf4IcsXNPr0hn1LOdHPjCawe8ruUPSD4GhjdOaUTEIZAP8eXYnNzKHB3XDtLmtq/0oLkJPdwh2RiXR+9d24W7WhdKa7UyAiDNwkcvpOR1qcn8b15uBHIoJr0NPttMz/zshJTMMOpqyfVgpcqISbiebmacBZJ0/v55bbXijCBLoINP8/ieQOHZn38+HMNW/vhsScFsrMvCEFwjRQk0rE8zrHowjkiG58EIpBncS+/9+hY3kfjcN/dzhhbNxNbbvU4J+hD6kOlYNpa3x1m8JB1eikEKETjyNG26VGhDOjigL6BfYU8eqbO8kpf76ScQ/obMhQlwohOBhYB/IheVt/09Ffo1Eku/gdBBYcdqBIcvN0DQIb0RV971rufKIloL/oToKQDUD+EgKo+cA2aoc8Zm1Dan0tKTP4ki59+svOJMhKt8Qd3H83bGyzVqC1F+eGc9TN3sGJlrkoJExYoMlfJg8vKPgSNTzQKzSMtYugN5MDo7Pga8zHmFB9jSY6xmj1dr9zQPtxVFOVtNtNqt6PCwt5wTkH7F5wUEJDmfXL4iIiZNo+ZYf07QSezcMiBMx6Wja/lNjqOcqT6y/ZL13KL7UCHLCS+zWnQ7lwPYAs2NMuDA+NgNezIj/xT09MItdgmaSSY1xOdV4J+GM3nEsjZFqol0P/
 jUXFlYkw
 Qgw0YQj1n0NICfHYEejiy0QFDnrBU6MeilMEYhvAtMJ/rrwQa+3Ylf2xYwrnW6hMznPpRIvuVfhmOh8+bEkV6z5durxty3EyUeWB+CAxATWHmtrctNqKbTUIz2ztigs7HvntHNOonyX+5+L6mppJwCAJXlnrTBbzFlpnufMCEe37WVZE5r0MGdrq/7YIOCS6AH39LRig9h1DII9MZNy6TfhuF7XmiedK+pbT4Qtgmxp9T2Q+PdI+ADQ9J8HLg4FnK101N7acj2uVYXDYTuY1m4oW0IWp4Zz4OhsRcfOG1GhOwMj2NSp/E4i1QXwjg9zDR2nS/Vqv3ldYFajN51SuEg91I9U5M662N+1dIu5IQdJmDr03EYlJLCSd1nSDHQqoG/Vbp4wYdS2YwnzqIBoYKxKjErGBt+5F0Q5oqTlR8AeWv+OUlLwoPQGf/cdziqbpcsz7FWkKAXfzm3pNi5g6gvNgHy/43RrhwR0YP5P9OAH+zlYyLuOFoTAa/lE8ysklg2YZSTcp+acO2HCD5oGfffNxNBV13y6S0Td+2uBD6b9aUulmXEPCaMNMlYdtrGYncwBOsn54PTAslduwQC4tvkuHqspqF7+CcUmtUC0Ws7BSEcXOWT/GdbJ42/5wzRAcDS7ONn1lbfb78QpFWc1vTz/ARTYAdqfe0p56hqjwFK2op0yyn5NU3RhmIMyleohsj9ytVJJNQC0zGJjbGjaJiLHj+u1JJ7LsVTAC6L+SndVjyuG+1PlDNTAcw/GwvvY6P2HGuhL1X768269uL+vHc0BQK4HchewgWsjOOEbQbs60QZ0aK+j+FVqrJQMrA/O95kyCS1aYDPa3MQlv+bxbxfCOu0YP5raNKucfopC/TinqQdsGmanpQnmDCf9FLJ/Iw3K0uRQoRQMumKoz3w0NHtzUwiw==
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
2.51.0=0A=
=0A=

