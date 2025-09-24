Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2395CAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 50C168E002B; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 493E38E000F; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 336548E002A; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1131A8E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:58 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3D0D11AF9A
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:56 +0000 (UTC)
X-FDA: 83924511552.11.C5C5AB9
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id 9B7BC20005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=A8jFkYMs;
	spf=pass (imf13.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727374;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a6Eg9frEsBCbSIX1oHSvhmXFN9rJwBSh/3zoDo5Aqzc=;
	b=tOjXCiX60jKbUY9o46Z1KbqqyahP3cXzHzwIZaqInEMKNIuI7eXC7scVztTi2ActWltrZK
	1K7/5K7Cfxb28NwjwFfJxlPU7kk2yQfIvwuYD/xSDgLOHwpIGB/ssxPxPaat12/9JKgWcW
	5+NXJmYUA/DqUrXRfcpfp3ilEVOluUM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727374; a=rsa-sha256;
	cv=none;
	b=KIKsTZ5u8jCp62BnhCClTVPqOEaOMXdp62AtuSYz190u25ECjkCV/JDaWLVQIjTyNHCTc0
	ac6B4Ft+hVbL2vlcSxsjYmUeeQE6NUF678cgxNnJEM/hMkZLdoo+vQlYXpvBRJdyP117Tl
	F9ss/WQd7bRxQiRq1izX+5tFM+NSw4M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=A8jFkYMs;
	spf=pass (imf13.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727374; x=1790263374;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=a6Eg9frEsBCbSIX1oHSvhmXFN9rJwBSh/3zoDo5Aqzc=;
  b=A8jFkYMsKbnNKQfpMVYYpToA0wH7lWxF3PrEb2p8vRuO0RKNOAqKi0TK
   XLwx/ObFSwl1Cr3KSiPX4vK44R5GY93RV5+B7zC0eLXqA27MKBYE7iIER
   8/a7wtRlXt2G2YdQaM7bop+ozTaeucynhH2hW5y2aeuBBvod+6Srv8ran
   vti26A+VU3TpdQG4wcJdjs8jYyzvyc+Y1efiHrvp7nqQIZNQH7i6chCzj
   kbY2fUWRxOfRApqYwqlOUIlvEKnye65D+zQ2bth3RRsrmm7/7Tp7K2KZ7
   LzKlEEJ4KnXeLnG0MCz2HSHFzdZvE0t4zIPDXQiPs1SmM/GzLqMcntJNr
   A==;
X-CSE-ConnectionGUID: kMnwmrpSRvifs9CF1RbD+g==
X-CSE-MsgGUID: ywx/MufnSeapNXsnJuhUcA==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2618206"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:48 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:30786]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.43:2525] with esmtp (Farcaster)
 id 61250ce8-c567-4051-8e5f-039b47592444; Wed, 24 Sep 2025 15:22:48 +0000 (UTC)
X-Farcaster-Flow-ID: 61250ce8-c567-4051-8e5f-039b47592444
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:46 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:46 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:46 +0000
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
Subject: [PATCH v7 09/12] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Topic: [PATCH v7 09/12] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Index: AQHcLWcUP/04waNc9EaEk/Asj9iZwA==
Date: Wed, 24 Sep 2025 15:22:46 +0000
Message-ID: <20250924152214.7292-6-roypat@amazon.co.uk>
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
X-Stat-Signature: um3tex1m8pqop3ogagirrc6zux1m71us
X-Rspamd-Queue-Id: 9B7BC20005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758727374-258265
X-HE-Meta: U2FsdGVkX1+avDzF9HaVdSRRNwhpS3oYNHfAOsg7baUjazTs1sXtxB1JqkhY5tYcLr2xqaaXa1jEXQ1bvKo0hAyivYtSeRXSFDYHqISL27hxk3PGViaIXoupm0Orx1P1u1j521loaDP7XfSdKnpr1axalDPC1Nq50Zwynx0u+YeUPgTRudG+Czoz8uKtg2t9xQ8HxZycPuBpkC6lzz2Jkaa20L5lxwVXbXdy8jIlKGsPRkobcPjGsYwXP+fVdoqbJVq8Io7ktagvfTxoy3i8yxKWIWOUisqwF7P2pF1QPTxzcZ9nIug9vcOm9WBqCC8fRmsfahIqW9FuhDDl76ZnquGUtjX0KHxDMJ4pqjrkmUHTmyfNIEwwH3kNlZpMe7ieAUAoYaU2DtOZv2ScjmwLM2W6zg3RIEvOqduSI7cbZ1ALCi2J9jTvtfOrcD35+9XGfcNcLv1nrFghgEs/Wn0C9HmhjE8l9MDFbtYY5KrPUv6SpQbr3Y545WrveF+kRemm0P7iuWVWOaRCaWFrwB7m9ujrCIcNZ+CVmeGgF0qA4h/C0G3I7j1kGBY0qR9ZCBWtjZ2IwerjTBoeNUL2fR1CVvBbdNLZPqtRK4/Z+JGgVpyJyrp1nmNnx65k7WlAZ1pvjss+7TRkQMIfnXyaD8M0QriiMjFDqGvqg7sxrX0oOUjhcCQYZBHO5bio4zxU161aOOs3wHqhnN8YjH5A+m+aqI9LTZykSoebnAqJ17NnKlqEddVuG/MAOlzVONZEeZH37eSCagSUblanEui4V0jJ/NXU+GjkrErFRFlW4YoFxQc1ECrR+y/veURQHAiDMGTNoHx4pEE8QopBjOKB1mHu0YGOZ0c9a9HudRipKEA07Ls9oNfJFYqA7pcDxkkYrGrVUe7SbdyDSiYdTVRANreN/Wip73Q16GdlEY+lpfidyyZBG6yu6wz/9E0OyHDcdpZWrxLmw+UO/BO7Ejp6Q+F
 eK8kAFqb
 LsXtOh7uJ197/oentkwyZPS4lyc8XQuO3bVPAYOixGScZdhvd2+zzD8SZ1NlIvrg+JIY0IuYPpYle1oamkUdBkFRaMAphi4eHVpNO6WsO9Ytdz/Y3DoXUQygLw/m5FVJhKTRsrRn8ryuoXzNW3riwBTM3YSR+iXmWI8fOP0vsbyL8GWkVkJyvUegxPAaXaYKd9IVGfejznQDo3tMA3jYv+4mlg8zj+LRImOx6wFvgpfDvRNDsUiD/qehinxTSm4RCjWM5tyfwouIh/oqNze98Z8h4w2/pAZpfs1LS2Utbap3/CHrP5KD+ixZ8sd+dldLJLClgS65fwSBhKS1+qBZMATJWV3w/Se0OcvCWeSfFuzUT2vYFvV3kWe0Z51vsWn3Y+gDdiftgzSxUaYMmBgKXTPGqzhl4J4HW3M81SYVWNiWk8h99CnBCd6KAH3HzcVkTWzILZ9MOTmSWF11ZvLZQiHLj274LUB/FUE7TvfBE5hYayXlob9CrAdQspvAxhrtIwKu4nX7x9XPDuVwCIi6Vtg4t5cNc7uYK1DunTSnzFplf64wHExLsGv1Aq96U9Qrw7ym77C2PExZTZLHIuhqyJbi5l7rcmZJMm8g+VrGa/kZnBNj8ObvRusMvBAcvzqI4qG1sd6Sx9jdxCFH6ELljl4lXP7uiW2PW2oYFz/Hj3n2Ur4556y1NU2a+tVJ756nQ/m6hk8B3f0DYKOl0fppyBqj0PYEWoggbDflsQfKmAUswXX1T9eJnV0f6tUmyNifNrfkQVBVG8nrAB+KhdQ5CQ40bSyxpNARJAuVdztTVz5O7LxLz8yN6GCdpFS0Gz53LAFuRD5VEy4HyVX25WFIwbah3FD23HiUvljrb+xuUWGqYJok=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 18 ++++++=0A=
 .../testing/selftests/kvm/include/test_util.h |  7 +++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 63 ++++++++++---------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++=0A=
 4 files changed, 66 insertions(+), 30 deletions(-)=0A=
=0A=
diff --git a/tools/testing/selftests/kvm/include/kvm_util.h b/tools/testing=
/selftests/kvm/include/kvm_util.h=0A=
index 23a506d7eca3..5204a0a18a7f 100644=0A=
--- a/tools/testing/selftests/kvm/include/kvm_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/kvm_util.h=0A=
@@ -635,6 +635,24 @@ static inline bool is_smt_on(void)=0A=
 =0A=
 void vm_create_irqchip(struct kvm_vm *vm);=0A=
 =0A=
+static inline uint32_t backing_src_guest_memfd_flags(enum vm_mem_backing_s=
rc_type t)=0A=
+{=0A=
+	uint32_t flags =3D 0;=0A=
+=0A=
+	switch (t) {=0A=
+	case VM_MEM_SRC_GUEST_MEMFD:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_MMAP;=0A=
+		fallthrough;=0A=
+	case VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP:=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
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
index 0409b7b96c94..a56e53fc7b39 100644=0A=
--- a/tools/testing/selftests/kvm/include/test_util.h=0A=
+++ b/tools/testing/selftests/kvm/include/test_util.h=0A=
@@ -133,6 +133,8 @@ enum vm_mem_backing_src_type {=0A=
 	VM_MEM_SRC_ANONYMOUS_HUGETLB_16GB,=0A=
 	VM_MEM_SRC_SHMEM,=0A=
 	VM_MEM_SRC_SHARED_HUGETLB,=0A=
+	VM_MEM_SRC_GUEST_MEMFD,=0A=
+	VM_MEM_SRC_GUEST_MEMFD_NO_DIRECT_MAP,=0A=
 	NUM_SRC_TYPES,=0A=
 };=0A=
 =0A=
@@ -165,6 +167,11 @@ static inline bool backing_src_is_shared(enum vm_mem_b=
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
index cc67dfecbf65..a81089f7c83f 100644=0A=
--- a/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/kvm_util.c=0A=
@@ -1060,6 +1060,34 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
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
+		guest_memfd =3D dup(guest_memfd);=0A=
+		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
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
@@ -1075,10 +1103,13 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_back=
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
 	region->mmap_start =3D mmap(NULL, region->mmap_size,=0A=
 				  PROT_READ | PROT_WRITE,=0A=
@@ -1106,34 +1137,6 @@ void vm_mem_add(struct kvm_vm *vm, enum vm_mem_backi=
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
-		guest_memfd =3D dup(guest_memfd);=0A=
-		TEST_ASSERT(guest_memfd >=3D 0, __KVM_SYSCALL_ERROR("dup()", guest_memfd=
));=0A=
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
index 03eb99af9b8d..b2baee680083 100644=0A=
--- a/tools/testing/selftests/kvm/lib/test_util.c=0A=
+++ b/tools/testing/selftests/kvm/lib/test_util.c=0A=
@@ -299,6 +299,14 @@ const struct vm_mem_backing_src_alias *vm_mem_backing_=
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
2.51.0=0A=
=0A=

