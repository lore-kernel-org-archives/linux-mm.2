Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0BF9CAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 08:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C9158E0068; Fri, 19 Sep 2025 04:44:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 278B58E0008; Fri, 19 Sep 2025 04:44:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119448E0068; Fri, 19 Sep 2025 04:44:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6BB98E0008
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 04:44:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 88E828696D
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:44:43 +0000 (UTC)
X-FDA: 83905364046.27.EFC6F1A
Received: from fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.74.81.189])
	by imf03.hostedemail.com (Postfix) with ESMTP id 30BF12000B
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 08:44:40 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=stOBsgVg;
	spf=pass (imf03.hostedemail.com: domain of "prvs=35079eb1c=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35079eb1c=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758271481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FDaXBfPtB1+IZ028q3Oc9ecT9TZeV+KPQRYxRClbnDE=;
	b=05G9YfujfKT7xUbucOEwLmhMsvtB1yLabjQJQL1h1UisG9ev17R4BLEd/XBk18m76790lf
	KHi1SCkc+9Y0BU4fkDddpeAS4KUYH0nWtd+UcAkUlQZLKzFh8tZ/vinjmcafsdQAl+PbHq
	YzPAmMYHUj4f0EHcHQdmIdFTLyAQFOk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758271481; a=rsa-sha256;
	cv=none;
	b=OQayezOf44rMGmSjKtGYl+cyNA69mb6aRHmVxA+4vj446cMsM9cStCBXV3YMa+K1AUAXe8
	c8NpUig2h3Kkdb0X96D84ZMx16VzF0Y8Gk7txVkdrI8XMddF1vLQWfVsHU5RsZPzS40j0X
	Iw0vrrvSC8tynjcq63Xkq40xsPCRYqI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=stOBsgVg;
	spf=pass (imf03.hostedemail.com: domain of "prvs=35079eb1c=roypat@amazon.co.uk" designates 3.74.81.189 as permitted sender) smtp.mailfrom="prvs=35079eb1c=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1758271481; x=1789807481;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=FDaXBfPtB1+IZ028q3Oc9ecT9TZeV+KPQRYxRClbnDE=;
  b=stOBsgVgEIz5/6E8WWdU/+HzUiFzx9QrEJEY6BLeIgF2wR7Zjd/Ws3xJ
   5KRb1Yfy0Bu/liWdRWualNjwjGlbzz2EGkL5uO1j9FSbQF97Q/qbJf3C/
   nNZ7rnh6Hpd637Gu9JKocafYVvsL3RU2avGJqCQErKS5HivVNWGZEuZm/
   iUlbwotaqYitekvqlzwHfYn4HTsk6/SP+NtTANzao1C5QHRa83bL8BPJL
   I9MIwSIe/GZXBYW5l0wZPC9utYQSQljyecemP+VHuyv4Nf9FDQ78FvIVn
   Z32kfkD/PbQ9I/Q17Vd0ZiTZazg6U+D3Jxk6hd1D6/d+JeF+YhvvPaVgx
   w==;
X-CSE-ConnectionGUID: mbWG6VQ7RoqqzIWbzp0AjA==
X-CSE-MsgGUID: vpo8mYMDQZK9UPEfdukZNw==
X-IronPort-AV: E=Sophos;i="6.18,277,1751241600"; 
   d="scan'208";a="2360353"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-004.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2025 08:44:31 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:18849]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.3:2525] with esmtp (Farcaster)
 id 2446a584-4a1c-4985-9be9-b5a1e9401e86; Fri, 19 Sep 2025 08:44:30 +0000 (UTC)
X-Farcaster-Flow-ID: 2446a584-4a1c-4985-9be9-b5a1e9401e86
Received: from EX19D015EUB002.ant.amazon.com (10.252.51.123) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 08:44:27 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB002.ant.amazon.com (10.252.51.123) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 19 Sep 2025 08:44:27 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 19 Sep 2025 08:44:27 +0000
From: "Roy, Patrick" <roypat@amazon.co.uk>
To: "will@kernel.org" <will@kernel.org>
CC: "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>, "alex@ghiti.fr"
	<alex@ghiti.fr>, "andrii@kernel.org" <andrii@kernel.org>, "anna@kernel.org"
	<anna@kernel.org>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"ast@kernel.org" <ast@kernel.org>, "axelrasmussen@google.com"
	<axelrasmussen@google.com>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "bp@alien8.de" <bp@alien8.de>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>, "brauner@kernel.org"
	<brauner@kernel.org>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "corbet@lwn.net"
	<corbet@lwn.net>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"david@redhat.com" <david@redhat.com>, "derekmn@amazon.co.uk"
	<derekmn@amazon.co.uk>, "devel@lists.orangefs.org"
	<devel@lists.orangefs.org>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"gor@linux.ibm.com" <gor@linux.ibm.com>, "hannes@cmpxchg.org"
	<hannes@cmpxchg.org>, "haoluo@google.com" <haoluo@google.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "hpa@zytor.com" <hpa@zytor.com>,
	"hubcap@omnibond.com" <hubcap@omnibond.com>, "jack@suse.cz" <jack@suse.cz>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "jannh@google.com"
	<jannh@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"kernel@xen0n.name" <kernel@xen0n.name>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>,
	"linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "luto@kernel.org"
	<luto@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"martin@omnibond.com" <martin@omnibond.com>, "maz@kernel.org"
	<maz@kernel.org>, "mhocko@suse.com" <mhocko@suse.com>, "mingo@redhat.com"
	<mingo@redhat.com>, "oliver.upton@linux.dev" <oliver.upton@linux.dev>,
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "paul.walmsley@sifive.com"
	<paul.walmsley@sifive.com>, "pbonzini@redhat.com" <pbonzini@redhat.com>,
	"peterx@redhat.com" <peterx@redhat.com>, "peterz@infradead.org"
	<peterz@infradead.org>, "pfalcato@suse.de" <pfalcato@suse.de>, "Roy, Patrick"
	<roypat@amazon.co.uk>, "rppt@kernel.org" <rppt@kernel.org>, "sdf@fomichev.me"
	<sdf@fomichev.me>, "seanjc@google.com" <seanjc@google.com>,
	"shakeel.butt@linux.dev" <shakeel.butt@linux.dev>, "shuah@kernel.org"
	<shuah@kernel.org>, "song@kernel.org" <song@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "trondmy@kernel.org" <trondmy@kernel.org>,
	"vbabka@suse.cz" <vbabka@suse.cz>, "viro@zeniv.linux.org.uk"
	<viro@zeniv.linux.org.uk>, "weixugc@google.com" <weixugc@google.com>,
	"willy@infradead.org" <willy@infradead.org>, "x86@kernel.org"
	<x86@kernel.org>, "Cali, Marco" <xmarcalx@amazon.co.uk>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>, "yuanchu@google.com"
	<yuanchu@google.com>, "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v6 05/11] KVM: guest_memfd: Add flag to remove from direct
 map
Thread-Topic: [PATCH v6 05/11] KVM: guest_memfd: Add flag to remove from
 direct map
Thread-Index: AQHcKUGbESLQYfpS9EGxnIIHED72/Q==
Date: Fri, 19 Sep 2025 08:44:27 +0000
Message-ID: <20250919084425.30632-1-roypat@amazon.co.uk>
References: <aMxpvI6Aj8mDsRNm@willie-the-truck>
In-Reply-To: <aMxpvI6Aj8mDsRNm@willie-the-truck>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.88.180]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: xth7iktq9nj1if3jo1u6ie86thjzbq9c
X-Rspam-User: 
X-Rspamd-Queue-Id: 30BF12000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758271480-50877
X-HE-Meta: U2FsdGVkX18a+bVBx6cQ1L9lsVeuLtHLiNR3t2lHxZwLa3l9vqUNq10tDwDbWCE6YSaA+ZkorNoPyuKr7aa80/ndTBqXgnFlxlHAmwOVQPV6ff5AysButOBZarNh0qihLTEo187G23ALAtsqVup+gambmDywkusAxvK+IsR0AQar0bD0pSwsHSf60H+oH6DX6UfiLbOW+RndV+lkTOfcPACephraXFw2yZANEUHJryaFSDVuXWy5nvENtcoJhaBvKi27DcK3R/1WT+ZpcMYXXSumQqxCTe7MFMPMUUwAEMI7ceSGsmtUAZqUpJ2+VNgGxOZsRX/nHNZTf2Kg4Hs3XeRvFx7+69XBIyzE9NZH6rfX2S1W6Y1vIN/S/EnN5zrMSjYHGQ7ZdJDVAIO56iIUL2mFypszogf+Wx3SgtvS+nhAAZByc7Y368U3HS7A9N+mjR8iZt7kcXjsMhBx/LOKFyA+Fs3znFXYTIrvFllc6fQIeBwG7lRoiMIvPB9LRZB2sA1L1hkQQvugm2Sfhx5/DGbFWwl9q0hc2OgDVVLbL7qn5cRsydlsLfQB2I7eVZ7flqPhgkM0sD6zj81SeOkbjj5mE8eAZFuCGTt9XWwtZKsOk83sHZQDEbCKhEEJRskg9U35A41dzd/ca+InZ66/hfi0UB6ouGJxpffdHw9UjwnaCAR4wd5cWFwWQXGWbF/ZNaTCjoLwqAREd8UF95vFM0IgGTbIlgogNvsiIRmhZpGe+aRv76rJM9NI/YE2bvzjrYJnpipPgwrAEqukYduXKXsPwUE8to3IGcRpnrwUv/0nCUGyIwww+kvZxOIt6EHCn5AtstJ+Zilte/EBGUwPGU6FoUhbtkDCTFijwk52Ea57LmhNrrGlCGBRpCD3CFlv2Kd8cSdgGyBJLA6ddCvDbc61PLVEjnHqoSZsKg8fiDaqULnxaIxlxf8bmuzT9XBV0bGt3J9fVq4T4RmOkYJ
 Vn4Zs3TS
 Sjh4kLNzctOWXo9K2xjVFeNjqz6OD+q9wKkWZ04UrVMRKrIJKisC3i6fmPC1fXUJSstT0t0cjWyjnOs9aZgdTLBhuP8SzUEB7Oe/jGspsLD/SJ0AEOWAvCEunt73M78Lmnk68PgteYAVD20WDZASe+jDzYrYW5teMSb3FmotHjUAgaQbsud5npk7dQ88JQIf9VSK4oFUaeV+I9wJp+fIAHFtlEY2bBpODJivy/MfU/fiUhyLAUdCxygYg7a5kr3pCbKCoOWwUt/r3QAKEzOIF3TKMWtLQCnCuJLg3XxpbzXeOfOSll8ID/cnZhMGkYIAV5xzH+ql438sFJwhKzouhTxaBgbuFABnQxVAAqs/bkoj7mFbY7dRaxCrAADxRmKvZlxCdF7ypZ2mMfWM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Will,=0A=
=0A=
On Thu, 2025-09-18 at 21:21 +0100, Will Deacon wrote:=0A=
> Hi Patrick,=0A=
> We chatted briefly at KVM Forum, so I wanted to chime in here too from=0A=
> the arm64 side.=0A=
> =0A=
> On Fri, Sep 12, 2025 at 09:17:37AM +0000, Roy, Patrick wrote:=0A=
>> Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()=0A=
>> ioctl. When set, guest_memfd folios will be removed from the direct map=
=0A=
>> after preparation, with direct map entries only restored when the folios=
=0A=
>> are freed.=0A=
>>=0A=
>> To ensure these folios do not end up in places where the kernel cannot=
=0A=
>> deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct=0A=
>> address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.=0A=
>>=0A=
>> Add KVM_CAP_GUEST_MEMFD_NO_DIRECT_MAP to let userspace discover whether=
=0A=
>> guest_memfd supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP. Support depends on=
=0A=
>> guest_memfd itself being supported, but also on whether linux supports=
=0A=
>> manipulatomg the direct map at page granularity at all (possible most of=
=0A=
>> the time, outliers being arm64 where its impossible if the direct map=0A=
>> has been setup using hugepages, as arm64 cannot break these apart due to=
=0A=
>> break-before-make semantics, and powerpc, which does not select=0A=
>> ARCH_HAS_SET_DIRECT_MAP, which also doesn't support guest_memfd anyway=
=0A=
>> though).=0A=
>>=0A=
>> Note that this flag causes removal of direct map entries for all=0A=
>> guest_memfd folios independent of whether they are "shared" or "private"=
=0A=
>> (although current guest_memfd only supports either all folios in the=0A=
>> "shared" state, or all folios in the "private" state if=0A=
>> GUEST_MEMFD_FLAG_MMAP is not set). The usecase for removing direct map=
=0A=
>> entries of also the shared parts of guest_memfd are a special type of=0A=
>> non-CoCo VM where, host userspace is trusted to have access to all of=0A=
>> guest memory, but where Spectre-style transient execution attacks=0A=
>> through the host kernel's direct map should still be mitigated.  In this=
=0A=
>> setup, KVM retains access to guest memory via userspace mappings of=0A=
>> guest_memfd, which are reflected back into KVM's memslots via=0A=
>> userspace_addr. This is needed for things like MMIO emulation on x86_64=
=0A=
>> to work.=0A=
>>=0A=
>> Do not perform TLB flushes after direct map manipulations. This is=0A=
>> because TLB flushes resulted in a up to 40x elongation of page faults in=
=0A=
>> guest_memfd (scaling with the number of CPU cores), or a 5x elongation=
=0A=
>> of memory population. TLB flushes are not needed for functional=0A=
>> correctness (the virt->phys mapping technically stays "correct",  the=0A=
>> kernel should simply not use it for a while). On the other hand, it mean=
s=0A=
>> that the desired protection from Spectre-style attacks is not perfect,=
=0A=
>> as an attacker could try to prevent a stale TLB entry from getting=0A=
>> evicted, keeping it alive until the page it refers to is used by the=0A=
>> guest for some sensitive data, and then targeting it using a=0A=
>> spectre-gadget.=0A=
> =0A=
> I'm really not keen on this last part (at least, for arm64).=0A=
> =0A=
> If you're not going to bother invalidating the TLB after unmapping from=
=0A=
> the direct map because of performance reasons, you're better off just=0A=
> leaving the direct map intact and getting even better performance. On=0A=
> arm64, that would mean you could use block mappings too.=0A=
=0A=
Not until we have hardware with the newest BBM goodies I thought. When I=0A=
checked earlier this year, a defconfig has the direct map setup at 4k=0A=
granularity.=0A=
=0A=
> On the other hand, if you actually care about the security properties=0A=
> from the unmap then you need the invalidation so that the mapping=0A=
> doesn't linger around. With "modern" CPU features such as pte=0A=
> aggregation and shared TLB walk caches it's not unlikely that these=0A=
> entries will persist a lot longer than you think and it makes the=0A=
> security benefits of this series impossible to reason about.=0A=
=0A=
I agree it's not 100% protection, but it is still better than the status qu=
o. I=0A=
would also love to have the TLB flushes, but sadly the performance impact o=
f=0A=
them would make this completely unusable for Amazon :/=0A=
=0A=
Mh, thinking about it now though, iirc the performance problems were mostly=
=0A=
because all CPUs needed to acknowledge the flush before the issuing CPU cou=
ld=0A=
continue. Is there a way to have "fire and forget" flushes, where we don't =
wait=0A=
for acknowledgements?=0A=
=0A=
> As a compromise, could we make the TLB invalidation an architecture=0A=
> opt-in so that we can have it enabled on arm64, please?=0A=
=0A=
How about instead of an architecture opt-in, we have some sort of opt-out f=
lag=0A=
userspace can set? Similar to the PFNMAP stuff KVM already has.=0A=
=0A=
> Will=0A=
=0A=
Best,=0A=
Patrick=0A=

