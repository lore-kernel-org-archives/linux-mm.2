Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3DA9DCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2F38E0027; Wed, 24 Sep 2025 11:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 752DB8E000F; Wed, 24 Sep 2025 11:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61B1B8E0027; Wed, 24 Sep 2025 11:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4B9888E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EBED8BBF10
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:52 +0000 (UTC)
X-FDA: 83924511384.04.3B62412
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf09.hostedemail.com (Postfix) with ESMTP id 34F31140006
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=HlewSA6G;
	spf=pass (imf09.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727370;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pV0ItvY0hWll18OUGTIIe4Ubw7ats5CZ0DOzdEQeTOk=;
	b=pknqOtRvGRum4MO5jjI78AVkQy/OvhR7xD3DXiindbnwj3syt1rxP7Sx8Kn+MNm2Nq7Zht
	+pUu+i2w0XJHRqKetZ8Nv5Raiay/5Os/7eFyvv6NW7ECcrBeI2vHZT3jXYPHzX3Aiyqb60
	sU6kT1s5lVYqzAMW0K/jB1+GOYihFPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727370; a=rsa-sha256;
	cv=none;
	b=L/1xU/G9cdbbMO7/Dyxco3mZJH9LBhBpU14u032RiCNmPMgGutFjzkdu24bwtFLWVLjPht
	InwxH7j5bLZQLmItZrOZkxm3x0iQ8f5o4Z2brcwOCps0ktETbRSIItkJkgcYAWWLCqOUX2
	mtZ6jRUIppFuAhRnqdg41gb1bM6H0hI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=HlewSA6G;
	spf=pass (imf09.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727370; x=1790263370;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=pV0ItvY0hWll18OUGTIIe4Ubw7ats5CZ0DOzdEQeTOk=;
  b=HlewSA6Gpjr48byeRRj/BzaAXNXn0b/YGNs24dbFm8gZ/SSyntfMnFY1
   3v0kAOAESeLQH6w344QDe/SR1TMAyVbJOylAAekomsG+9LdyErpYGkinF
   tqX1BmQUhXsqiVnNdYfFTMO2WujThr2MpG2sGhVmZ+/Vzekn23H8w7o1l
   ei482PoEykf1Hn/ddxS/LgKBwpF6KbVDKTnyyb66w6+6fLHxC+7e+v68O
   t90an+8OMQ0YZ/f7HuX685AlrAe6Tq76a48dEm8qnGJnL1vIQ4gK0K2l4
   xsR6Lp1FSNOLFfX143ofxOx3FqrMRwX7FgwImJE9vBNCysmW8iw3yP7rm
   Q==;
X-CSE-ConnectionGUID: s3BkeWEkRo2EDpOnnS/WuQ==
X-CSE-MsgGUID: dG6RbGblS/CzWUKebAgDpQ==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2618267"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:40 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:15622]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.33.43:2525] with esmtp (Farcaster)
 id a43211cf-8cf7-4647-8a0c-093b80639d44; Wed, 24 Sep 2025 15:22:39 +0000 (UTC)
X-Farcaster-Flow-ID: a43211cf-8cf7-4647-8a0c-093b80639d44
Received: from EX19D015EUB003.ant.amazon.com (10.252.51.113) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:39 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB003.ant.amazon.com (10.252.51.113) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:39 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:39 +0000
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
Subject: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct map
Thread-Topic: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from
 direct map
Thread-Index: AQHcLWcQtdvVokkndkuNN5YMX6g9SQ==
Date: Wed, 24 Sep 2025 15:22:39 +0000
Message-ID: <20250924152214.7292-2-roypat@amazon.co.uk>
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
X-Stat-Signature: u5hj57nszuige4rtjofhkm5nrn3eqyik
X-Rspam-User: 
X-Rspamd-Queue-Id: 34F31140006
X-Rspamd-Server: rspam10
X-HE-Tag: 1758727369-872153
X-HE-Meta: U2FsdGVkX18TD+drqaWd4DGvAdYNvTrfwopDYRpOEqpITYQoY3nloS36j5LU2MCQ9mTywXT+K9eq89wK6sxh3a+UTV2MGvM5FI3zJMGCqkTr933nk+sM+f6KUapK4Mtp+hQfEa7/ylV6N9bcGpXu0grQ8aovgKkOtap+2kOwsvJ4x19pO41lFOIgGTYXaTK3zGCEwpoe4/ovCXYYrz3fJei9dBfZq0UF0D2tpwIKXt/+tTDdiZ8iZREsm3dADmHVKI511nkN42zJXuk8AjCf2R5DrTSXbUHZpV5IKghXa1UYFnFNiAaw8tXv89JWLPHne0SCtMQlk4LawHVkXup/32uVpzm47EpSR9QYKd3V/v/MPHKCOxBNcb9fePYQr/IkoSaVWIkYhawcy1zVg2QOYIN4Us3laLzvd6Ou2txQQrJfC3aNPmMQkNbdIK77GurrhdTLIpU8qaG3FzkGQGt0l4OIgQ57vYQR/hBTPoYQJjnpO9MJuRIbkfl25mFo5bRX2fbFOPpzUTiix45/MOJ82j8DfQ1ki5HuaRdaqRP3HkSTH+q8anjoKFqSgThM2Vk5kT3MtR4bZIxD7nW/1uJJarOZM/ylVbeth7sX3CJdQbvaNs69P8mN2dqOJvt1NrTVYWhi1tezLTsVIA2XC0ev/Hbumho2LbYihPL2RXm1XVMOlArWcB1Y6dMUTKPXCz0ktLJpMhgCW+vSU8PeOMXdJ7EN844YSkVGB8dsYSZyF3NrA7dO9kbw/wJJ+94oBUNZkAWmZqSIcQpwPe3kc1RigpfseYcXdS1gmEgqk9a11NLtVwyUJYygBHw87xc5k1Yk3PKzttgG7skCccDJxLlStvBR7X5VetOnkSepRlrj/z/VVz0zjloXQ/EZDcx0QszFpaoDNULTNhGCRrMLmxoPAma8bqBB3Eaot2ZDfB1i7wyTvPr8WEZiuYFQF4ZVAEM1NgPDOBfcexL10Be/aKD
 BNIXC8/Q
 7ssbaMXTLUawjPAYH7XM7Nz3PS2F2tcf6WYaMiCYJwSgaJvJbRAmXyPj894sejggJ0NnY+kknXyNLa6wPupluFatcviae8rHqIXKL73L2vRJgSVTeFy6j5ddsLeX95Gju6dlBGdgFZ080dyXwqVbd5pX5KSjlPFeroJloqFw8VYfQK1hfplucVduvvfPq86F17qdxicVrgSDFeBAZb7dr17Ne1MtjNdSJoNMaRn1jiBrbrWDQUntVPBZxRSpIGH3pC5DvREk+8iIU0i33V8XxjVgxQlpbY1Z+KiDPvH/JOrU/b7Q728tTNL7sdGHdVEpZoX4Ty1f1qvGrFJThebd3FhdoBlWliLXsyKSNQfVE71GAY04LT7ARI6v8IaiBUHunZFW85IsyL8FWZDhvGO71auZeBDK144/XHOO0aaD2sDVxqjFc/y3tnMbJYY3rc/GMFVN3BWFo/ABJd8EPh3HRdNaAlsJ8huqG8KzOVueYs6e0do3imboP9yrLn9BwDu38kQKoW2wPLrCzi24hgOpov4DwG9w3uQtk6LsdG/bIj0XXiLkIYJlx5C7Va4+FCjHtxVooCHNq/KmwxH0o+7HMSc5cECu6LwgCqXWI0FHjqVLqOUJEezJ9h1qX0tqhCveSirUfuP6tHuO5LC0XE61h1sFVCkYL6Sz8HutLLzOEDzcYxQMTvAmRpl31NHE2loUG8KLhxgXvYLZHbk4maLQXdTHv/UwIaH9Ji7jsih0VAsxJeLWillNaqRl6LMhYpBOJXtfMeks6SferUxPxfIXpYAuaOcJocHbQ7fMffIl0Y9VhBLIneH1C/C7gd5yoQPweMOPPH2lFah/hk2hrEqUnuOj8p1ytKaMVajLa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()=0A=
ioctl. When set, guest_memfd folios will be removed from the direct map=0A=
after preparation, with direct map entries only restored when the folios=0A=
are freed.=0A=
=0A=
To ensure these folios do not end up in places where the kernel cannot=0A=
deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct=0A=
address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.=0A=
=0A=
Add KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP to let userspace discover whether=0A=
guest_memfd supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP. Support depends on=0A=
guest_memfd itself being supported, but also on whether linux supports=0A=
manipulatomg the direct map at page granularity at all (possible most of=0A=
the time, outliers being arm64 where its impossible if the direct map=0A=
has been setup using hugepages, as arm64 cannot break these apart due to=0A=
break-before-make semantics, and powerpc, which does not select=0A=
ARCH_HAS_SET_DIRECT_MAP, though also doesn't support guest_memfd=0A=
anyway).=0A=
=0A=
Note that this flag causes removal of direct map entries for all=0A=
guest_memfd folios independent of whether they are "shared" or "private"=0A=
(although current guest_memfd only supports either all folios in the=0A=
"shared" state, or all folios in the "private" state if=0A=
GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map=0A=
entries of also the shared parts of guest_memfd are a special type of=0A=
non-CoCo VM where, host userspace is trusted to have access to all of=0A=
guest memory, but where Spectre-style transient execution attacks=0A=
through the host kernel's direct map should still be mitigated.  In this=0A=
setup, KVM retains access to guest memory via userspace mappings of=0A=
guest_memfd, which are reflected back into KVM's memslots via=0A=
userspace_addr. This is needed for things like MMIO emulation on x86_64=0A=
to work.=0A=
=0A=
Direct map entries are zapped right before guest or userspace mappings=0A=
of gmem folios are set up, e.g. in kvm_gmem_fault_user_mapping() or=0A=
kvm_gmem_get_pfn() [called from the KVM MMU code]. The only place where=0A=
a gmem folio can be allocated without being mapped anywhere is=0A=
kvm_gmem_populate(), where handling potential failures of direct map=0A=
removal is not possible (by the time direct map removal is attempted,=0A=
the folio is already marked as prepared, meaning attempting to re-try=0A=
kvm_gmem_populate() would just result in -EEXIST without fixing up the=0A=
direct map state). These folios are then removed form the direct map=0A=
upon kvm_gmem_get_pfn(), e.g. when they are mapped into the guest later.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 Documentation/virt/kvm/api.rst    |  5 +++=0A=
 arch/arm64/include/asm/kvm_host.h | 12 ++++++=0A=
 include/linux/kvm_host.h          |  6 +++=0A=
 include/uapi/linux/kvm.h          |  2 +=0A=
 virt/kvm/guest_memfd.c            | 61 ++++++++++++++++++++++++++++++-=0A=
 virt/kvm/kvm_main.c               |  5 +++=0A=
 6 files changed, 90 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t=0A=
index c17a87a0a5ac..b52c14d58798 100644=0A=
--- a/Documentation/virt/kvm/api.rst=0A=
+++ b/Documentation/virt/kvm/api.rst=0A=
@@ -6418,6 +6418,11 @@ When the capability KVM_CAP_GUEST_MEMFD_MMAP is supp=
orted, the 'flags' field=0A=
 supports GUEST_MEMFD_FLAG_MMAP.  Setting this flag on guest_memfd creation=
=0A=
 enables mmap() and faulting of guest_memfd memory to host userspace.=0A=
 =0A=
+When the capability KVM_CAP_GMEM_NO_DIRECT_MAP is supported, the 'flags' f=
ield=0A=
+supports GUEST_MEMFG_FLAG_NO_DIRECT_MAP. Setting this flag makes the guest=
_memfd=0A=
+instance behave similarly to memfd_secret, and unmaps the memory backing i=
t from=0A=
+the kernel's address space after allocation.=0A=
+=0A=
 When the KVM MMU performs a PFN lookup to service a guest fault and the ba=
cking=0A=
 guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always =
be=0A=
 consumed from guest_memfd, regardless of whether it is a shared or a priva=
te=0A=
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h=0A=
index 2f2394cce24e..0bfd8e5fd9de 100644=0A=
--- a/arch/arm64/include/asm/kvm_host.h=0A=
+++ b/arch/arm64/include/asm/kvm_host.h=0A=
@@ -19,6 +19,7 @@=0A=
 #include <linux/maple_tree.h>=0A=
 #include <linux/percpu.h>=0A=
 #include <linux/psci.h>=0A=
+#include <linux/set_memory.h>=0A=
 #include <asm/arch_gicv3.h>=0A=
 #include <asm/barrier.h>=0A=
 #include <asm/cpufeature.h>=0A=
@@ -1706,5 +1707,16 @@ void compute_fgu(struct kvm *kvm, enum fgt_group_id =
fgt);=0A=
 void get_reg_fixed_bits(struct kvm *kvm, enum vcpu_sysreg reg, u64 *res0, =
u64 *res1);=0A=
 void check_feature_map(void);=0A=
 =0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+static inline bool kvm_arch_gmem_supports_no_direct_map(void)=0A=
+{=0A=
+	/*=0A=
+	 * Without FWB, direct map access is needed in kvm_pgtable_stage2_map(),=
=0A=
+	 * as it calls dcache_clean_inval_poc().=0A=
+	 */=0A=
+	return can_set_direct_map() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);=
=0A=
+}=0A=
+#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_dir=
ect_map=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
 =0A=
 #endif /* __ARM64_KVM_HOST_H__ */=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index 1d0585616aa3..73a15cade54a 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -731,6 +731,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm=
 *kvm)=0A=
 bool kvm_arch_supports_gmem_mmap(struct kvm *kvm);=0A=
 #endif=0A=
 =0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+#ifndef kvm_arch_gmem_supports_no_direct_map=0A=
+#define kvm_arch_gmem_supports_no_direct_map can_set_direct_map=0A=
+#endif=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
+=0A=
 #ifndef kvm_arch_has_readonly_mem=0A=
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)=0A=
 {=0A=
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h=0A=
index 6efa98a57ec1..33c8e8946019 100644=0A=
--- a/include/uapi/linux/kvm.h=0A=
+++ b/include/uapi/linux/kvm.h=0A=
@@ -963,6 +963,7 @@ struct kvm_enable_cap {=0A=
 #define KVM_CAP_RISCV_MP_STATE_RESET 242=0A=
 #define KVM_CAP_ARM_CACHEABLE_PFNMAP_SUPPORTED 243=0A=
 #define KVM_CAP_GUEST_MEMFD_MMAP 244=0A=
+#define KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP 245=0A=
 =0A=
 struct kvm_irq_routing_irqchip {=0A=
 	__u32 irqchip;=0A=
@@ -1600,6 +1601,7 @@ struct kvm_memory_attributes {=0A=
 =0A=
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest=
_memfd)=0A=
 #define GUEST_MEMFD_FLAG_MMAP	(1ULL << 0)=0A=
+#define GUEST_MEMFD_FLAG_NO_DIRECT_MAP (1ULL << 1)=0A=
 =0A=
 struct kvm_create_guest_memfd {=0A=
 	__u64 size;=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index 55b8d739779f..b7129c4868c5 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -4,6 +4,9 @@=0A=
 #include <linux/kvm_host.h>=0A=
 #include <linux/pagemap.h>=0A=
 #include <linux/anon_inodes.h>=0A=
+#include <linux/set_memory.h>=0A=
+=0A=
+#include <asm/tlbflush.h>=0A=
 =0A=
 #include "kvm_mm.h"=0A=
 =0A=
@@ -42,6 +45,44 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, str=
uct kvm_memory_slot *slo=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+#define KVM_GMEM_FOLIO_NO_DIRECT_MAP BIT(0)=0A=
+=0A=
+static bool kvm_gmem_folio_no_direct_map(struct folio *folio)=0A=
+{=0A=
+	return ((u64) folio->private) & KVM_GMEM_FOLIO_NO_DIRECT_MAP;=0A=
+}=0A=
+=0A=
+static int kvm_gmem_folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	if (kvm_gmem_folio_no_direct_map(folio))=0A=
+		return 0;=0A=
+=0A=
+	int r =3D set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pag=
es(folio),=0A=
+					 false);=0A=
+=0A=
+	if (!r) {=0A=
+		unsigned long addr =3D (unsigned long) folio_address(folio);=0A=
+		folio->private =3D (void *) ((u64) folio->private & KVM_GMEM_FOLIO_NO_DI=
RECT_MAP);=0A=
+		flush_tlb_kernel_range(addr, addr + folio_size(folio));=0A=
+	}=0A=
+=0A=
+	return r;=0A=
+}=0A=
+=0A=
+static void kvm_gmem_folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	/*=0A=
+	 * Direct map restoration cannot fail, as the only error condition=0A=
+	 * for direct map manipulation is failure to allocate page tables=0A=
+	 * when splitting huge pages, but this split would have already=0A=
+	 * happened in set_direct_map_invalid_noflush() in kvm_gmem_folio_zap_dir=
ect_map().=0A=
+	 * Thus set_direct_map_valid_noflush() here only updates prot bits.=0A=
+	 */=0A=
+	if (kvm_gmem_folio_no_direct_map(folio))=0A=
+		set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio)=
,=0A=
+					 true);=0A=
+}=0A=
+=0A=
 static inline void kvm_gmem_mark_prepared(struct folio *folio)=0A=
 {=0A=
 	folio_mark_uptodate(folio);=0A=
@@ -324,13 +365,14 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct =
vm_fault *vmf)=0A=
 	struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
 	struct folio *folio;=0A=
 	vm_fault_t ret =3D VM_FAULT_LOCKED;=0A=
+	int err;=0A=
 =0A=
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >=3D i_size_read(inode))=0A=
 		return VM_FAULT_SIGBUS;=0A=
 =0A=
 	folio =3D kvm_gmem_get_folio(inode, vmf->pgoff);=0A=
 	if (IS_ERR(folio)) {=0A=
-		int err =3D PTR_ERR(folio);=0A=
+		err =3D PTR_ERR(folio);=0A=
 =0A=
 		if (err =3D=3D -EAGAIN)=0A=
 			return VM_FAULT_RETRY;=0A=
@@ -348,6 +390,13 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct v=
m_fault *vmf)=0A=
 		kvm_gmem_mark_prepared(folio);=0A=
 	}=0A=
 =0A=
+	err =3D kvm_gmem_folio_zap_direct_map(folio);=0A=
+=0A=
+	if (err) {=0A=
+		ret =3D vmf_error(err);=0A=
+		goto out_folio;=0A=
+	}=0A=
+=0A=
 	vmf->page =3D folio_file_page(folio, vmf->pgoff);=0A=
 =0A=
 out_folio:=0A=
@@ -435,6 +484,8 @@ static void kvm_gmem_free_folio(struct folio *folio)=0A=
 	kvm_pfn_t pfn =3D page_to_pfn(page);=0A=
 	int order =3D folio_order(folio);=0A=
 =0A=
+	kvm_gmem_folio_restore_direct_map(folio);=0A=
+=0A=
 	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));=0A=
 }=0A=
 =0A=
@@ -499,6 +550,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t si=
ze, u64 flags)=0A=
 	/* Unmovable mappings are supposed to be marked unevictable as well. */=
=0A=
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));=0A=
 =0A=
+	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)=0A=
+		mapping_set_no_direct_map(inode->i_mapping);=0A=
+=0A=
 	kvm_get_kvm(kvm);=0A=
 	gmem->kvm =3D kvm;=0A=
 	xa_init(&gmem->bindings);=0A=
@@ -523,6 +577,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_=
guest_memfd *args)=0A=
 	if (kvm_arch_supports_gmem_mmap(kvm))=0A=
 		valid_flags |=3D GUEST_MEMFD_FLAG_MMAP;=0A=
 =0A=
+	if (kvm_arch_gmem_supports_no_direct_map())=0A=
+		valid_flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
+=0A=
 	if (flags & ~valid_flags)=0A=
 		return -EINVAL;=0A=
 =0A=
@@ -687,6 +744,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory=
_slot *slot,=0A=
 	if (!is_prepared)=0A=
 		r =3D kvm_gmem_prepare_folio(kvm, slot, gfn, folio);=0A=
 =0A=
+	kvm_gmem_folio_zap_direct_map(folio);=0A=
+=0A=
 	folio_unlock(folio);=0A=
 =0A=
 	if (!r)=0A=
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c=0A=
index 18f29ef93543..b5e702d95230 100644=0A=
--- a/virt/kvm/kvm_main.c=0A=
+++ b/virt/kvm/kvm_main.c=0A=
@@ -65,6 +65,7 @@=0A=
 #include <trace/events/kvm.h>=0A=
 =0A=
 #include <linux/kvm_dirty_ring.h>=0A=
+#include <linux/set_memory.h>=0A=
 =0A=
 =0A=
 /* Worst case buffer size needed for holding an integer. */=0A=
@@ -4916,6 +4917,10 @@ static int kvm_vm_ioctl_check_extension_generic(stru=
ct kvm *kvm, long arg)=0A=
 		return kvm_supported_mem_attributes(kvm);=0A=
 #endif=0A=
 #ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+	case KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP:=0A=
+		if (!kvm_arch_gmem_supports_no_direct_map())=0A=
+			return 0;=0A=
+		fallthrough;=0A=
 	case KVM_CAP_GUEST_MEMFD:=0A=
 		return 1;=0A=
 	case KVM_CAP_GUEST_MEMFD_MMAP:=0A=
-- =0A=
2.51.0=0A=
=0A=

