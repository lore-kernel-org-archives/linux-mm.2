Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C05A9CAC5A5
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 15:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13A7D8E0028; Wed, 24 Sep 2025 11:22:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EDB58E000F; Wed, 24 Sep 2025 11:22:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FFF8E0028; Wed, 24 Sep 2025 11:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB8D58E000F
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 11:22:54 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C70711AFAC
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:54 +0000 (UTC)
X-FDA: 83924511468.29.FC55ED9
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf13.hostedemail.com (Postfix) with ESMTP id C6FC520005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 15:22:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=km8eoUv7;
	spf=pass (imf13.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758727372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZ6aEnN0octnczQEslBC0QJ/62FEQzxTaKcHv32i784=;
	b=vvNW3HRXIoHApjnB72E4xBHW9fpZ9hijyRi7OqzXSu5K/7bKWUpeK3rl4JdmEm1sJajHiI
	cZ+puh/Eqye+8wgnIWd3KqC2rVRV33O4/VM7EpW5OvixO4q/P8AUEXVg/MaW9vqS1UJPfX
	2nUoBegXcmkbZBqijrjFG4oYl8o48xQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758727372; a=rsa-sha256;
	cv=none;
	b=51hqN5rNDeuRTeiSUMIuB8YAX9LYNc6IAxxYkcIx2KRHc97aVPcmH+Iu8tcd6GjgHhVGnV
	L9WG5j00bsoHHjcYqD6saD+xiEYUSiMp4tuWljln27ijg6BCV9cN+8aJiwu9a40PMUbP3d
	G0uGDgy3SV+QFzvSOTxln+W9xLVFyWc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=km8eoUv7;
	spf=pass (imf13.hostedemail.com: domain of "prvs=355a74973=roypat@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=355a74973=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758727371; x=1790263371;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=aZ6aEnN0octnczQEslBC0QJ/62FEQzxTaKcHv32i784=;
  b=km8eoUv7Hpus47hd36DuEZZj616kPmwaq5Psx6Ex5ldQWMIZ3fFvGINT
   6gKwajMkKADbQh4zLgo/h1C4e5ci/tKqJD9iSxJvKOclMO5snRS7iMtFc
   /ytT+ZJZuAOStFY99z8BAiKxi0bgbuDT6dO5SBNwtFRnzfzmF+OnpFJk+
   wR7bZghh+nf3I7N9JXDKO7nztd1WDOBrAgndM0fumqooPwQpWHUTSCgGU
   Y2ogKgvnpR5lt1ZqlXWrEn+CSnFWtmOcz+Eu9OXYdNh8rA2IMitq4rV7k
   4oBdreqInZHfOBFjf4Cv7WmTpkvu5el1JmCbwHfRhZVs/UhSuGEp33ZCq
   w==;
X-CSE-ConnectionGUID: pQcceaiESDSH7bC1cpsqVQ==
X-CSE-MsgGUID: hlpCS6KaT2KSYTE87OW0dQ==
X-IronPort-AV: E=Sophos;i="6.18,290,1751241600"; 
   d="scan'208";a="2618190"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2025 15:22:42 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:30326]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.10.226:2525] with esmtp (Farcaster)
 id 81816518-f8e5-42a3-83ec-e3c3c2235bb6; Wed, 24 Sep 2025 15:22:41 +0000 (UTC)
X-Farcaster-Flow-ID: 81816518-f8e5-42a3-83ec-e3c3c2235bb6
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:41 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Wed, 24 Sep 2025 15:22:40 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Wed, 24 Sep 2025 15:22:40 +0000
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
Subject: [PATCH v7 06/12] KVM: guest_memfd: add module param for disabling TLB
 flushing
Thread-Topic: [PATCH v7 06/12] KVM: guest_memfd: add module param for
 disabling TLB flushing
Thread-Index: AQHcLWcRbocNw3xUv0GREpQeD3nXQA==
Date: Wed, 24 Sep 2025 15:22:40 +0000
Message-ID: <20250924152214.7292-3-roypat@amazon.co.uk>
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
X-Stat-Signature: g5i6y73i8uqbxww9988hzjb9zt9gi8ae
X-Rspamd-Queue-Id: C6FC520005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1758727371-960166
X-HE-Meta: U2FsdGVkX1+E/zaCsvnuqxbPDoNWLkpM4/4zmfAV00CSz6UUvdUCNGZunMm4+3thVSuwT4HFTbxowXys+YyCeq0st7T9ajvMM4cyQZ1JLU7M7gqGVdU5dC3rX487WKCVMnWM03PiGa/C3NrNlzJRpyL3Nf7ahDmontGuJlcRGOMBvO8x6/17oO/JB+UDwHPkst6TlTi5n8x5WQq2ZGrm8bLG33Ss1N6HttuhkTMcHKw7fKNFUsFoR+us9ULl6k6PzGHq7FcFXLj6AtoqpHWJnXhBIqawBldBDExOUGC/b3BdV8KtE0xAHm5p4G94wH4aj0c+Cs1Q9/oeEiB4hlVzVU73SOvNyfa/flKHPfz11naJIcQK/vgWeIWD+52pCxOs2Zq/iAY0zC1S6aBfP6yN7jlQicELwVHNpeLSYVDIofX6kykVjkIuS1OfZDmpdHrwZungc2XV3HsOdm07t3bhRJC34hBCvoct7gHKlRo/7r8LxmYAulKUpxM2199veiNcCRbZuetJ45HWbZNdtzK5hxdB2xEQkgeLFiCL3hoi+KEndbB+RbmZDyu3Fg557MHjQXsQSBb5nFI151xzBHHJk4fjvheX3wPziqK7ii4O8YGnu+zkkxx8xUPT1aPpkByCVKKCmbXwV6gutbEzBL8U4nYEyHqF8TcvstKZme9xN+/KwM5J3hOBy1jTy9V0mfD+Efv4fJ17Mm/NrfFyJLcfO4w7zKa45inCRpPP5/+ztnUsrmN5kumniUjUjzA62pLmOevbjnzeVbYfwh8Xf1Y0L64H5KyoL5qiWuPG3eqp/7YWDSMDygMo8dLynfT8xxCgGkct4Z52xWjlm5BZYSn8U7203MqjRT6DbX58erWDY4vEhPocHxKR3cZQtVww7aMje7ElZp2Gu+i3E1E2EvIRxUozs6snCUtjhTaXUVnmTYPSWIJr6LisAFSqfSg72XXclBIvShTknCsXsxYWJmk
 krYu99mp
 kvnqw6uyEC+r9cdJ1CHsf/NDAV4xMeJazTLxffRke0+MctM4w6w6r5TR5tqm+scG+hoqixgVf2XWSwo4WW3JgImFbJLH6cw3JOf3yYeLF1KfvNny4qnXzV1EmdyCn19XQcMr2OhsTDmLlIjX9PaoMgOzax5b+pl5x8Q4J2yXSI3PL4cT1EyvR/b4jOEJZsLDthMqmvpMAFlIJ1h7UB/GFO2pW98X0y1IJz76giJP4r3c5vdakhN32Iu6ZRbJFw6Idq1JrGUPSKyGlcX78nWClnhjzBYePDKjaFUZ+D1juY9hwgT7JZulw/EvovlpRfPOJvlLNW5rbqJUDUXBjKTLtGBE5edAst3DqKAXjXzWIU7Anlnj20yqQU7rdtHt+tV6jE4v27DriCSCpyUQwuPN+UBw1AsXyHm3bYGMFvETry9IRdLLRUhpVXVaxoirW3dTwEV9cffG7ohuW5BKiKIcR5LIGz0RRaKnk2w2BWko0Tyy+132M3JyRf5cn4r04Q0m6P6aIPQw/WOmVVHFuggzMgYws8M50BO/2gEywySPimkZL2SKOIXl53e3neOJ52ZFr2PqK7qKmYZVm8fmzyEi5SlO1+Wfqy6g+RpYPDD5Bfj482v8U+TmnrVFPc5pCu0edU9sSMv+XNXajo0bspuPYKxKYBvrj4UdH4+uEarBGVR+IThn7JwgIvBQqXnDyUEi3Q2tb2SY9d6LYLcu250wKHN/FmttLLs5Boe4kMueeFveI8XdcJmgO3Fb1+6lGHAUEpTCFixH5SQnSVO6bFv5ApRzhHJhtK1WWz5IAte5dwsAkTgUkEgtV5OGBzYhiPpByOZjD0yKMj3m5xasuM5+YNzR781dcOayaorULL0ZKArBsH2xKz0GwtObSmBaQ4/mqCT1y5vXPw7KVJvF8MHsIvyggYG3T1VgHb1x36Qbxv5Q3+3M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an option to not perform TLB flushes after direct map manipulations.=0A=
TLB flushes result in a up to 40x elongation of page faults in=0A=
guest_memfd (scaling with the number of CPU cores), or a 5x elongation=0A=
of memory population, which is inacceptable when wanting to use direct=0A=
map removed guest_memfd as a drop-in replacement for existing workloads.=0A=
=0A=
TLB flushes are not needed for functional correctness (the virt->phys=0A=
mapping technically stays "correct", the kernel should simply not use it=0A=
for a while), so we can skip them to keep performance in-line with=0A=
"traditional" VMs.=0A=
=0A=
Enabling this option means that the desired protection from=0A=
Spectre-style attacks is not perfect, as an attacker could try to=0A=
prevent a stale TLB entry from getting evicted, keeping it alive until=0A=
the page it refers to is used by the guest for some sensitive data, and=0A=
then targeting it using a spectre-gadget.=0A=
=0A=
Cc: Will Deacon <will@kernel.org>=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 include/linux/kvm_host.h | 1 +=0A=
 virt/kvm/guest_memfd.c   | 3 ++-=0A=
 virt/kvm/kvm_main.c      | 3 +++=0A=
 3 files changed, 6 insertions(+), 1 deletion(-)=0A=
=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index 73a15cade54a..4d2bc18860fc 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -2298,6 +2298,7 @@ extern unsigned int halt_poll_ns;=0A=
 extern unsigned int halt_poll_ns_grow;=0A=
 extern unsigned int halt_poll_ns_grow_start;=0A=
 extern unsigned int halt_poll_ns_shrink;=0A=
+extern bool guest_memfd_tlb_flush;=0A=
 =0A=
 struct kvm_device {=0A=
 	const struct kvm_device_ops *ops;=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index b7129c4868c5..d8dd24459f0d 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -63,7 +63,8 @@ static int kvm_gmem_folio_zap_direct_map(struct folio *fo=
lio)=0A=
 	if (!r) {=0A=
 		unsigned long addr =3D (unsigned long) folio_address(folio);=0A=
 		folio->private =3D (void *) ((u64) folio->private & KVM_GMEM_FOLIO_NO_DI=
RECT_MAP);=0A=
-		flush_tlb_kernel_range(addr, addr + folio_size(folio));=0A=
+		if (guest_memfd_tlb_flush)=0A=
+			flush_tlb_kernel_range(addr, addr + folio_size(folio));=0A=
 	}=0A=
 =0A=
 	return r;=0A=
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c=0A=
index b5e702d95230..753c06ebba7f 100644=0A=
--- a/virt/kvm/kvm_main.c=0A=
+++ b/virt/kvm/kvm_main.c=0A=
@@ -95,6 +95,9 @@ unsigned int halt_poll_ns_shrink =3D 2;=0A=
 module_param(halt_poll_ns_shrink, uint, 0644);=0A=
 EXPORT_SYMBOL_GPL(halt_poll_ns_shrink);=0A=
 =0A=
+bool guest_memfd_tlb_flush =3D true;=0A=
+module_param(guest_memfd_tlb_flush, bool, 0444);=0A=
+=0A=
 /*=0A=
  * Allow direct access (from KVM or the CPU) without MMU notifier protecti=
on=0A=
  * to unpinned pages.=0A=
-- =0A=
2.51.0=0A=
=0A=

