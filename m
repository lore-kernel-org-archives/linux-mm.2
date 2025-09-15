Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E7F2CAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:18:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 949948E0005; Mon, 15 Sep 2025 12:18:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FB348E0001; Mon, 15 Sep 2025 12:18:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EAB48E0005; Mon, 15 Sep 2025 12:18:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67BB58E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:18:30 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1D9CA59C87
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:18:30 +0000 (UTC)
X-FDA: 83891992380.13.60BC763
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E5EF40011
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:18:27 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="JXcE/w2X";
	spf=pass (imf11.hostedemail.com: domain of "prvs=34680b893=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=34680b893=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757953107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CDl0b6KkrXQvSS9kzg7AcD96nGNBLMsPGJRUmWs0z0w=;
	b=fdG25fube5YSoUEn1kJ8P2lvi31cI1pdI2S50SZ5FEG7zSmp77CUw6sBO+d5/fSRAVf4h8
	rvILxtP47UDQsDfhCD3pegaFyVAXzjuXT95OfBiyuDaIkEtsc/oVMMfpOWgcvirH+9l1Ju
	Ml8Pp2OPazQwZKQKvL6AYC0YKrhhjW0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757953107; a=rsa-sha256;
	cv=none;
	b=43MQLnhEoSOwndvQL7M9wIfQxCA2aPjvYfhHBd8jT9t/+2cfw8rJ353xizL6lkL9z4WEOf
	yvjj4m5kL4tC3JgpZyDZWfrN+CHHhXt54JJVad4BWrrKU+kahEcwpxVqTFKiqvDAkd0tVe
	2Wu3227jdzfPPJlrt85FVEeevMU7Mvo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="JXcE/w2X";
	spf=pass (imf11.hostedemail.com: domain of "prvs=34680b893=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=34680b893=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757953107; x=1789489107;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=CDl0b6KkrXQvSS9kzg7AcD96nGNBLMsPGJRUmWs0z0w=;
  b=JXcE/w2XYd2GHu8UXsboQSxaA5BlBGbbDeTsRcYjjOkhNa5tghnKkw4/
   Ss2PPGKEGXGWXX2GDMIPXdKAi8/pbwFAtPTIeWsn28YuFFVuCbmLj+rww
   5bG8i3zhi55G6FR21RbklkKLpaaK2mBvw/zDSTRvEF9+u98kBLoNjPLz7
   FAkV13arQsEbgJC6M374Ld0+2lCwX7kQqhRR6V9PPhVmvxvxcV+RjG2WQ
   2rkZNrHN7dUmpVqTBlkF+ypDXnOc+ueCEKHUm+42bDl5GOVN2TnDn32FP
   Bfl+kDL23A2b6qikaRq0zCH6xJffKs83bw/F5BJtHPitfJg9MxRzcL0E3
   g==;
X-CSE-ConnectionGUID: 7g8hTmdISPCOA/xP8HtpFQ==
X-CSE-MsgGUID: yprgmfxkSuWwZ9mZB0WgTQ==
X-IronPort-AV: E=Sophos;i="6.18,266,1751241600"; 
   d="scan'208";a="2139165"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2025 16:18:17 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:15164]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.212:2525] with esmtp (Farcaster)
 id ec76851e-2fd3-4c72-b0e1-9270752f342d; Mon, 15 Sep 2025 16:18:17 +0000 (UTC)
X-Farcaster-Flow-ID: ec76851e-2fd3-4c72-b0e1-9270752f342d
Received: from EX19D022EUC004.ant.amazon.com (10.252.51.159) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 15 Sep 2025 16:18:17 +0000
Received: from EX19D022EUC002.ant.amazon.com (10.252.51.137) by
 EX19D022EUC004.ant.amazon.com (10.252.51.159) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Mon, 15 Sep 2025 16:18:16 +0000
Received: from EX19D022EUC002.ant.amazon.com ([fe80::bd:307b:4d3a:7d80]) by
 EX19D022EUC002.ant.amazon.com ([fe80::bd:307b:4d3a:7d80%3]) with mapi id
 15.02.2562.020; Mon, 15 Sep 2025 16:18:16 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "pbonzini@redhat.com"
	<pbonzini@redhat.com>, "seanjc@google.com" <seanjc@google.com>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>, "brauner@kernel.org"
	<brauner@kernel.org>
CC: "peterx@redhat.com" <peterx@redhat.com>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "willy@infradead.org" <willy@infradead.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"jack@suse.cz" <jack@suse.cz>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "jthoughton@google.com"
	<jthoughton@google.com>, "tabba@google.com" <tabba@google.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Manwaring,
 Derek" <derekmn@amazon.com>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [RFC PATCH v6 0/2] mm: Refactor KVM guest_memfd to introduce guestmem
 library
Thread-Topic: [RFC PATCH v6 0/2] mm: Refactor KVM guest_memfd to introduce
 guestmem library
Thread-Index: AQHcJlxXR+tr4y5qFkOMqP9rmILQaA==
Date: Mon, 15 Sep 2025 16:18:16 +0000
Message-ID: <20250915161815.40729-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: p51qtqo9h3of6j4gz6167jc7epuqhu5h
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E5EF40011
X-Rspamd-Server: rspam10
X-HE-Tag: 1757953107-943639
X-HE-Meta: U2FsdGVkX183yPoMCDbDHpe9J0Np5yoBVewqPJVyHB8ViRYmXppdyTJkHU8LeeywEACni8ZLb/ZypWEBYc9k+84mZFMacRjFsmgaLtwoa3HVQQ7p9jQqItAk/kmjp2cq6ZzH60JBtAFAUZe2+r9nyroE0cH8fxMOFm8gFJuVIzZr9GLuJwwmgT8ishQQvPBDgPnbsFHKgLD5jNaLtT/reWtqcRWkiL3QYSsGlv1kjnctZOykRqjiKYjghN3jFBwH73D2A3UUZe7MqT0ikklWEE4MTUMep88Q/jXMacmnK53GJH32S0LTweySbbTcMi7z2VmTiWpkrL/ac1Wi1oZRQQzkQIx/p2Nw5I6kda/7ZVwvR994Be82WUsrAt+SNdAhZ5sVXalSBKETcot5jdKagaMsANoQ3fTWRHYONybkMEit4cp8sYtHAiJB3z7AuyU39bAEG2uQ5vN04vMUCBiwdu8WClaWs3oGqOL90FZtqc9yO/3dkCDaY3xTScIaDHzZejbDi/w8aJE/gBq5MsdMrkUro9uZNE1SaS7acsvsna0mSgjpr92Wk7f62Pjz3ic+igq+HWZaDWpmw6ucEtuzDUT7xikWj7KQUbIWe1jU4CB27tINW2P2IQ4ccqXj7RKJcPQdV29GG8duPXm/eKNW0l0M5CCs/jsdgsAMt8KwTEp50EROyDKZVzPHex4OQvtlAvr2ijgOTKs1fFZHVldKlzDhPdf+UtiyN1pZtGw7HC1B7x/Bmy62wKQ+NUizqReHyCKwOHn4/ccb84dF+BMu2WhRjscMvkwNHbh54jGEK1Wyu2MjhJWMLinD3j95Pz4jvjVhYhJ7/mx63FNmwqkbpRF1DkNeR4uIbxal5bz+Qs3wKwjYwhr9hHUnYCFZb1kQmbu+JU44abrORzbWpy9862jY8bLSachheSEB14A75YHWtjLSbckVSM4MGY0zAo0jeWjwtT+JnHqrNRcm/MN
 /BdorTwZ
 mlErQdNPMexEU4kY80zke/P51qh17LD5rJcy2PNXUXuJ7dmRJK4kupxx+7Xt9c3dM5cg5QxSb/LMRxdoYhWNhcYNBoUB4e0CZxy+CBUgZk3RHLd/JOeM4O1TWBiuPRUXkRfllrYUgbSJsGxGmuD2frywj/tYTKt7U+K9A+jxSVOghNXgw8E0Bi9DzBn6+KOpSxUzVWpA7qEr/8sDeuEkH1O9chcN/++Z0d57QHZqwCTHa08oHWFfILyIpgwZSlBBX681ZvqJAXs6pmD1sfgmEVzH1mVuyRXEzzIRtlBCS5pf0PsjptryAj6TRjjtbb+yhMHRgDYkSmIV7HnOLq1uD5QMhl/x08eAvXEG5o3PDqvUN514/fRqV4Vk6atcOnygV6dUQ7z81Oo3k9KMa/ARfo8B4gBWKuY6Nx9UYu+Ws1OX8bRXgIIbwh065K8rbVUgeC7xQAHynDZf8WKPGRnp1ET9NR+PNOmP8hbcyjq6T78BVm8ge/GEAABY7xq7CS6J92g9iRKREdpzwusb2T/MB55jQtnMDNoN5LQhEiAqw6JkSEngC7JtJvkrXd5FZw0lzlvekP+F4mHEOeniKYn0JaRkq1AISHJZEMlJb/RAwDOsJdfZnfxet04TozZZZ2MerdvoFkwvNudPNiOi9KcsBjttw6fLUJA7DKcSXIvdKBXL1pmaQ6PDi5BtM00zRaCKu83g4iMYiAxnPQkdQVSlCICXNHxxUESON5eK9aqAjWP5yFzwfzlpjCWKoefp/PDUid27LzH5FgUrS2c8T/sWjPgwyCA+y3/aK6caDjg1AtuXWF1nPxU7WRR4soslw6dD/KkytwDFvWfXh2gxhhzjLkrFxQoxr1fXOpmOr9aiABPEI5Dw4nPJ0RtaM6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a revival of the guestmem library patch series originated from=0A=
Elliot [1].  The reason I am bringing it up now is it would help=0A=
implement UserfaultFD support minor mode in guest_memfd.=0A=
=0A=
Background=0A=
=0A=
We are building a Firecracker version that uses guest_memfd to back=0A=
guest memory [2].  The main objective is to use guest_memfd to remove=0A=
guest memory from host kernel's direct map to reduce the surface for=0A=
Spectre-style transient execution issues [3].  Currently, Firecracker=0A=
supports restoring VMs from snapshots using UserfaultFD [4], which is=0A=
similar to the postcopy phase of live migration.  During restoration,=0A=
while we rely on a separate mechanism to handle stage-2 faults in=0A=
guest_memfd [5], UserfaultFD support in guest_memfd is still required to=0A=
handle faults caused either by the VMM itself or by MMIO access handling=0A=
on x86.=0A=
=0A=
The major problem in implementing UserfaultFD for guest_memfd is that=0A=
the MM code (UserfaultFD) needs to call KVM-specific interfaces.=0A=
Particularly for the minor mode, these are 1) determining the type of=0A=
the VMA (eg is_vma_guest_memfd()) and 2) obtaining a folio (ie=0A=
kvm_gmem_get_folio()).  Those may not be always available as KVM can be=0A=
compiled as a module.  Peter attempted to approach it via exposing an=0A=
ops structure where modules (such as KVM) could provide their own=0A=
callbacks, but it was not deemed to be sufficiently safe as it opens up=0A=
an unrestricted interface for all modules and may leave MM in an=0A=
inconsistent state [6].=0A=
=0A=
An alternative way to make these interfaces available to the UserfaultFD=0A=
code is extracting generic-MM guest_memfd parts into a library=0A=
(guestmem) under MM where they can be safely consumed by the UserfaultFD=0A=
code.  As far as I know, the original guestmem library series was=0A=
motivated by adding guest_memfd support in Gunyah hypervisor [7].=0A=
=0A=
This RFC=0A=
=0A=
I took Elliot's v5 (the latest) and rebased it on top of the guest_memfd=0A=
preview branch [8] because I also wanted to see how it would work with=0A=
direct map removal [3] and write syscall [9], which are building blocks=0A=
for the guest_memfd-based Firecracker version.  On top of it I added a=0A=
patch that implements UserfaultFD support for guest_memfd using=0A=
interfaces provided by the guestmem library to illustrate the complete=0A=
idea.=0A=
=0A=
I made the following modifications along the way:=0A=
 - Followed by a comment from Sean, converted invalidate_begin()=0A=
   callback back to void as it cannot fail in KVM, and the related=0A=
   Gunyah requirement is unknown to me=0A=
 - Extended the guestmem_ops structure with the supports_mmap() callback=0A=
   to provide conditional mmap support in guestmem=0A=
 - Extended the guestmem library interface with guestmem_allocate(),=0A=
   guestmem_test_no_direct_map(), guestmem_mark_prepared(),=0A=
   guestmem_mmap(), and guestmem_vma_is_guestmem()=0A=
 - Made (kvm_gmem)/(guestmem)_test_no_direct_map() use=0A=
   mapping_no_direct_map() instead of KVM-specific flag=0A=
   GUEST_MEMFD_FLAG_NO_DIRECT_MAP to make it KVM-independent=0A=
=0A=
Feedback that I would like to receive:=0A=
 - Is this the right solution to the "UserfaultFD in guest_memfd"=0A=
   problem?=0A=
 - What requirements from other hypervisors than KVM do we need to=0A=
   consider at this point?=0A=
 - Does the line between generic-MM and KVM-specific guest_memfd parts=0A=
   look sensible?=0A=
=0A=
Previous iterations of UserfaultFD support in guest_memfd patches:=0A=
v3:=0A=
 - https://lore.kernel.org/kvm/20250404154352.23078-1-kalyazin@amazon.com=
=0A=
 - minor changes to address review comments (James)=0A=
v2:=0A=
 - https://lore.kernel.org/kvm/20250402160721.97596-1-kalyazin@amazon.com=
=0A=
 - implement a full minor trap instead of hybrid missing/minor trap=0A=
   (James/Peter)=0A=
 - make UFFDIO_CONTINUE implementation generic calling vm_ops->fault()=0A=
v1:=0A=
 - https://lore.kernel.org/kvm/20250303133011.44095-1-kalyazin@amazon.com=
=0A=
=0A=
Nikita=0A=
=0A=
[1]: https://lore.kernel.org/kvm/20241122-guestmem-library-v5-2-450e92951a1=
5@quicinc.com=0A=
[2]: https://github.com/firecracker-microvm/firecracker/tree/feature/secret=
-hiding=0A=
[3]: https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk=
=0A=
[4]: https://github.com/firecracker-microvm/firecracker/blob/main/docs/snap=
shotting/handling-page-faults-on-snapshot-resume.md=0A=
[5]: https://lore.kernel.org/kvm/20250618042424.330664-1-jthoughton@google.=
com=0A=
[6]: https://lore.kernel.org/linux-mm/20250627154655.2085903-1-peterx@redha=
t.com=0A=
[7]: https://lore.kernel.org/lkml/20240222-gunyah-v17-0-1e9da6763d38@quicin=
c.com=0A=
[8]: https://git.kernel.org/pub/scm/linux/kernel/git/david/linux.git/log/?h=
=3Dguestmemfd-preview=0A=
[9]: https://lore.kernel.org/kvm/20250902111951.58315-1-kalyazin@amazon.com=
=0A=
=0A=
Nikita Kalyazin (2):=0A=
  mm: guestmem: introduce guestmem library=0A=
  userfaulfd: add minor mode for guestmem=0A=
=0A=
 Documentation/admin-guide/mm/userfaultfd.rst |   4 +-=0A=
 MAINTAINERS                                  |   2 +=0A=
 fs/userfaultfd.c                             |   3 +-=0A=
 include/linux/guestmem.h                     |  46 +++=0A=
 include/linux/userfaultfd_k.h                |   8 +-=0A=
 include/uapi/linux/userfaultfd.h             |   8 +-=0A=
 mm/Kconfig                                   |   3 +=0A=
 mm/Makefile                                  |   1 +=0A=
 mm/guestmem.c                                | 380 +++++++++++++++++++=0A=
 mm/userfaultfd.c                             |  14 +-=0A=
 virt/kvm/Kconfig                             |   1 +=0A=
 virt/kvm/guest_memfd.c                       | 303 ++-------------=0A=
 12 files changed, 493 insertions(+), 280 deletions(-)=0A=
 create mode 100644 include/linux/guestmem.h=0A=
 create mode 100644 mm/guestmem.c=0A=
=0A=
=0A=
base-commit: 911634bac3107b237dcd8fdcb6ac91a22741cbe7=0A=
-- =0A=
2.50.1=0A=
=0A=

