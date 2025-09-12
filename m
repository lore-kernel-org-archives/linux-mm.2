Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8669FCA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:18:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 151308E001B; Fri, 12 Sep 2025 05:18:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 12A2E8E0016; Fri, 12 Sep 2025 05:18:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0176C8E001B; Fri, 12 Sep 2025 05:18:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D98438E0016
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:18:03 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7703A13BA59
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:18:03 +0000 (UTC)
X-FDA: 83880046446.05.37E29B8
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf29.hostedemail.com (Postfix) with ESMTP id E8FF3120004
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:18:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=fnBV05W3;
	spf=pass (imf29.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sx3+9NqAutB+Cmf+Db3J2/+vf0r+9QnQTa0qeyMJaf4=;
	b=GfYP/h7rWxe3RHHgE6w5ISMHY5i3/VHGy3dXeXFuucSMt35iMhtgM7InYMd3flKRTcfAgd
	KejONhW3vE9KkCthQLA0pl5U2p7UKokcXzUG2f+VtOkt1pSHe/GbqfsIb6f4yYcfaGvwjl
	cCjhaZjeKXQBeufiHPFsqEL9Rbwf/6g=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=fnBV05W3;
	spf=pass (imf29.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668681; a=rsa-sha256;
	cv=none;
	b=Hsde9f/8zr9wxmH2E+GD+QVM00DGF3E536p002PTXZuQ0oKz57mDloE86+ngsZNjqAnfWB
	POU+QXKDq0z4szLgl3+sRVbSu4LKBITWIdkJ+j7YXp0gcQ4XzchCgYRFGJPDHR14UaWco3
	diuzdZ4s5qRU7BH2BiJvZ0t9iIDd6pE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668681; x=1789204681;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=Sx3+9NqAutB+Cmf+Db3J2/+vf0r+9QnQTa0qeyMJaf4=;
  b=fnBV05W326OtEQHxCC/m9SPLW11FDtUsdfVB+kTsw1JYop+zcnqD+t0F
   2jaOkb12y3dWL15BJPUx8CmpbyYrW0oL20igofZV8pd5lz6MUWQ8aizwH
   cu6aioIXrGy0pZsA24UOve1NCvEHj9yPw03SrG+21udlTmQXRwylhGdD7
   wHw2GyH6TSIuHPRe0LiRCx1xS088allnLEcWS3aNOPnPnKMmyM0MI5xk3
   ORuUwRnITC+HTuu/bANtzy5XcIbFLRrhOoIDVif87Il/kTQ6f4ijbOJLb
   fSScWgrFLgQ4uN3JgEOvkPxw8eq2edSKynTdXEjsTdIraJB7qe/S4rd4j
   A==;
X-CSE-ConnectionGUID: bZRsWIxlR/yEbUbMLmfOOw==
X-CSE-MsgGUID: G63+TtQQT9+uaWQFpDkUig==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="1893875"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:50 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:21053]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.27.75:2525] with esmtp (Farcaster)
 id 11132b9c-31f8-43b2-a215-ef61df00b885; Fri, 12 Sep 2025 09:17:50 +0000 (UTC)
X-Farcaster-Flow-ID: 11132b9c-31f8-43b2-a215-ef61df00b885
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:38 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:38 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:38 +0000
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
Subject: [PATCH v6 05/11] KVM: guest_memfd: Add flag to remove from direct map
Thread-Topic: [PATCH v6 05/11] KVM: guest_memfd: Add flag to remove from
 direct map
Thread-Index: AQHcI8YVCIdARtvwGUipYxYs+3gydA==
Date: Fri, 12 Sep 2025 09:17:37 +0000
Message-ID: <20250912091708.17502-6-roypat@amazon.co.uk>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E8FF3120004
X-Stat-Signature: 1nqffax73z3za8c3dkn4yxdzzpt98xqb
X-HE-Tag: 1757668680-174505
X-HE-Meta: U2FsdGVkX186a52P13wn7fHjwx7sTz0tGMeyxgSLzEOkQ+p2Zz7Q/0SvYZfdGHDeeBdACMLe7g9RclAJbXPl0AAYe0O8DXL1h+Ivz65VZOnu1xlEE1kDNt5f5khbPJiuA0heBGLsciOObMVgnEmYL12EL6NCRlYx43p4QmigmmERCfvWZ8wgMs0duV+g3HKaqBCBryKEhUTSxlIDBjsGYgIsMH/7dtt9+loiRZln0ttXdnBbrYmfu4m3YBOB14YZ9iRhOs6b7bVnx4cRaNBn3mvnVUOzG4vw0aw0j7XTXJaBO29sjo7TOKdbUQh9NNdhHpy3DN3q2dQl6dTf06KaOjB4Q/OARjoV9rkwL5MUACRlhEJvuaFBp5GDv4zed7q9R3G0huCcL52R1lMaSSoX0k6KLN/E+/mCL8uUI+VcN4224rXVJw0nnfCELhcfDeGvm2PviKhjdqExBQYgnTF1UVB5xnCk01p/HRwraaCoGC4wR8DiCP+oFg2Ux05bVUKSnnL1PApl3f2KvqkND7lpiudqCW3l8No5iZ1xGHsW9/IW9jo+TbMjBqUrZt2rhHYcCvvIroOPmSBr1dFjRvJZYQ3YsTIlu+jalsVlPFyqoBpUX0ZHau286oGCopfJcYJdyHrJhGFS3MnJS5mQomNy/25FWmpB6Ajz5t8d0w2fUJEmL+bY9ducJTllRSb5WV6VCD6AhkHyCXRL4I11knF+v/UKMyz+kRC1QAvSKafZAxJ6NOJeWSWMMp4RJ253Qc8Qya1arbdU9G4DmykKQ192ixMqgmDMf5nF0Gq/+FWE7/7iWe3g220r/ElnQZor+BvBOVYliQkij2uvv+p3BNSLqZDARrjKs0ODsqy9jP41TBtGSLrfLJmsosoh3KW/d92fMPTi+PkyzpjJRz25USp0JavT2SmGS9zdOzC8uMDFiwNOsyWijUZowLrCC944XoP8wzDQp8GJ32FmNYAw1w2
 wSv9VSjK
 04Y9D+yXbNgxuWS/+RAjIGHZqA+PY9qgpmqzjpu4GJb4OHIEQsAUjWVFeiPh8kZngL9bQt+DWMWu4iZgq64jO7kk4ODLWSyzLIR+oQNNWXouZ1ilD3bPYmAmfWFYS7/77e/BdrEzGv12tXhhGfTM3LiGppA7x5DFV9H1NCYa+YBJHkPV99oNA2MB0AA0t1H0Nv6FBc4oQtuz0H0IkKT7RvgR+o91/0vXiJBqW/r5Kdjcb+cHP8ZyRJqsO6y7rtHU85PToVTfAiXS2HJv8B8sMewrsvlq/Z4z86depRTj5nFrkh5hh+9h9qXXxB2Qhk9AgjOSs2nFzI3f/ItrFiU8PodM6kv9LmLAHGVhvY8k3mIQ2Zm/ozLUhUZdT6LBHBKVSqtwvOzI+uPuOMmxZp0+dZHhwE5Icd/JmwzZ+AupO4Dsk9+HaRAcP12ALkiG9xPAo+CdsBVge3SJ+QwnyjvMn29gVpUxlRFnyAW6ttcpM0k31UY2Ib2Rq0XrS3CaLcgbK2HjlAJ1rGK+HK3qSwnvQtgt6ChJklSZMh3X6JbeCX/WXKvbwOx4W99P0sXnwBFZ1NoV06TQqFzMKfxRvQvu7OcRyLReBkgpRsbL1MZoesy1WDkenzRWf58E2aICrGhuqXPjltz6xyzsMMIH4C4itcJg+jLDuJwZuCMSHjz76PGRyOEMotLdYclmcPt7CNJ+i2Yyygs5lAmaNk8ENfEp+0Kh+jnXTVgZWfP2eRvPGrrXoMo9S24Ce+PgtLJWDK186WeaHrj0Yai3caf0KHfs+iITtiIxDMgeN88vV0mIbGrly4lOlAM3Ni/VN6sBx21gwwJXYza31Uzml5QKQPeXzFL+xvSNX8g4GtRjeZqcGg4w1oVc=
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
ARCH_HAS_SET_DIRECT_MAP, which also doesn't support guest_memfd anyway=0A=
though).=0A=
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
Do not perform TLB flushes after direct map manipulations. This is=0A=
because TLB flushes resulted in a up to 40x elongation of page faults in=0A=
guest_memfd (scaling with the number of CPU cores), or a 5x elongation=0A=
of memory population. TLB flushes are not needed for functional=0A=
correctness (the virt->phys mapping technically stays "correct",  the=0A=
kernel should simply not use it for a while). On the other hand, it means=
=0A=
that the desired protection from Spectre-style attacks is not perfect,=0A=
as an attacker could try to prevent a stale TLB entry from getting=0A=
evicted, keeping it alive until the page it refers to is used by the=0A=
guest for some sensitive data, and then targeting it using a=0A=
spectre-gadget.=0A=
=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 Documentation/virt/kvm/api.rst    |  5 ++++=0A=
 arch/arm64/include/asm/kvm_host.h | 12 ++++++++=0A=
 include/linux/kvm_host.h          |  7 +++++=0A=
 include/uapi/linux/kvm.h          |  2 ++=0A=
 virt/kvm/guest_memfd.c            | 49 +++++++++++++++++++++++++++----=0A=
 virt/kvm/kvm_main.c               |  5 ++++=0A=
 6 files changed, 75 insertions(+), 5 deletions(-)=0A=
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
index 1d0585616aa3..a9468bce55f2 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -36,6 +36,7 @@=0A=
 #include <linux/rbtree.h>=0A=
 #include <linux/xarray.h>=0A=
 #include <asm/signal.h>=0A=
+#include <linux/set_memory.h>=0A=
 =0A=
 #include <linux/kvm.h>=0A=
 #include <linux/kvm_para.h>=0A=
@@ -731,6 +732,12 @@ static inline bool kvm_arch_has_private_mem(struct kvm=
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
index 81028984ff89..3c64099fc98a 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -4,6 +4,7 @@=0A=
 #include <linux/kvm_host.h>=0A=
 #include <linux/pagemap.h>=0A=
 #include <linux/anon_inodes.h>=0A=
+#include <linux/set_memory.h>=0A=
 =0A=
 #include "kvm_mm.h"=0A=
 =0A=
@@ -42,9 +43,24 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, str=
uct kvm_memory_slot *slo=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static inline void kvm_gmem_mark_prepared(struct folio *folio)=0A=
+static bool kvm_gmem_test_no_direct_map(struct inode *inode)=0A=
 {=0A=
-	folio_mark_uptodate(folio);=0A=
+	return ((unsigned long) inode->i_private) & GUEST_MEMFD_FLAG_NO_DIRECT_MA=
P;=0A=
+}=0A=
+=0A=
+static inline int kvm_gmem_mark_prepared(struct folio *folio)=0A=
+{=0A=
+	struct inode *inode =3D folio_inode(folio);=0A=
+	int r =3D 0;=0A=
+=0A=
+	if (kvm_gmem_test_no_direct_map(inode))=0A=
+		r =3D set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(=
folio),=0A=
+						 false);=0A=
+=0A=
+	if (!r)=0A=
+		folio_mark_uptodate(folio);=0A=
+=0A=
+	return r;=0A=
 }=0A=
 =0A=
 /*=0A=
@@ -82,7 +98,7 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct=
 kvm_memory_slot *slot,=0A=
 	index =3D ALIGN_DOWN(index, 1 << folio_order(folio));=0A=
 	r =3D __kvm_gmem_prepare_folio(kvm, slot, index, folio);=0A=
 	if (!r)=0A=
-		kvm_gmem_mark_prepared(folio);=0A=
+		r =3D kvm_gmem_mark_prepared(folio);=0A=
 =0A=
 	return r;=0A=
 }=0A=
@@ -344,8 +360,15 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct v=
m_fault *vmf)=0A=
 	}=0A=
 =0A=
 	if (!folio_test_uptodate(folio)) {=0A=
+		int err =3D 0;=0A=
+=0A=
 		clear_highpage(folio_page(folio, 0));=0A=
-		kvm_gmem_mark_prepared(folio);=0A=
+		err =3D kvm_gmem_mark_prepared(folio);=0A=
+=0A=
+		if (err) {=0A=
+			ret =3D vmf_error(err);=0A=
+			goto out_folio;=0A=
+		}=0A=
 	}=0A=
 =0A=
 	vmf->page =3D folio_file_page(folio, vmf->pgoff);=0A=
@@ -436,6 +459,16 @@ static void kvm_gmem_free_folio(struct address_space *=
mapping,=0A=
 	kvm_pfn_t pfn =3D page_to_pfn(page);=0A=
 	int order =3D folio_order(folio);=0A=
 =0A=
+	/*=0A=
+	 * Direct map restoration cannot fail, as the only error condition=0A=
+	 * for direct map manipulation is failure to allocate page tables=0A=
+	 * when splitting huge pages, but this split would have already=0A=
+	 * happened in set_direct_map_invalid_noflush() in kvm_gmem_mark_prepared=
().=0A=
+	 * Thus set_direct_map_valid_noflush() here only updates prot bits.=0A=
+	 */=0A=
+	if (kvm_gmem_test_no_direct_map(mapping->host))=0A=
+		set_direct_map_valid_noflush(page, folio_nr_pages(folio), true);=0A=
+=0A=
 	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));=0A=
 }=0A=
 =0A=
@@ -500,6 +533,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t si=
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
@@ -524,6 +560,9 @@ int kvm_gmem_create(struct kvm *kvm, struct kvm_create_=
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
@@ -768,7 +807,7 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn=
, void __user *src, long=0A=
 		p =3D src ? src + i * PAGE_SIZE : NULL;=0A=
 		ret =3D post_populate(kvm, gfn, pfn, p, max_order, opaque);=0A=
 		if (!ret)=0A=
-			kvm_gmem_mark_prepared(folio);=0A=
+			ret =3D kvm_gmem_mark_prepared(folio);=0A=
 =0A=
 put_folio_and_exit:=0A=
 		folio_put(folio);=0A=
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
2.50.1=0A=
=0A=

