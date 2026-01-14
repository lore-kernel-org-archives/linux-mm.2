Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1F8BD37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:47:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51A926B00A8; Wed, 14 Jan 2026 08:47:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F1AD6B00AB; Wed, 14 Jan 2026 08:47:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DDD06B00AC; Wed, 14 Jan 2026 08:47:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2954D6B00A8
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:47:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C18DC1A050A
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:47:03 +0000 (UTC)
X-FDA: 84330695526.04.E6F145D
Received: from fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.158.153.154])
	by imf03.hostedemail.com (Postfix) with ESMTP id D31B320004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:47:00 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=o9bkC1yl;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qRcHHdR+Sn0Hgnqc4EhM391wkU6kJqHm858dZaM0mYM=;
	b=XxpWat4fdnoMXyna9tPeA7x5sjq5xWCNp/jShxH5hZz8XXnMHVZ8UwbHC4k9mh1E6UQq9n
	vnFtcIZOWImBpZQk082xwyQrHxcZOULjoYlpyppOQRIXPx1r6FkWTjQ0NxXO7Bj8kqsZBK
	xM1weeV38MUF6oCO9Fe4rd8YAZaVlsI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=o9bkC1yl;
	spf=pass (imf03.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.158.153.154 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398421; a=rsa-sha256;
	cv=none;
	b=Jo8tcHMAkfROKJ+XvzizfqF7BmtEGPBQRozSUqr8Ssqu9bHldllCgxNEHeyqZINwOGQ4MF
	6thmQIz9tj7QmF0mg8B1+qXW76KTQO+Vjfs69xwzET6NjM45pggXYy+ukdtRnVygePa0el
	vtmJZxTegiTkgpfS/GGUQ3XrHUq5LFk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398421; x=1799934421;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qRcHHdR+Sn0Hgnqc4EhM391wkU6kJqHm858dZaM0mYM=;
  b=o9bkC1ylKMvVkE3mkEsSsUI182242YUhBdTnYBfzyfflOspzjTtEgYRH
   mfQ5Rw68l1QOBY7QaMAT67p/Gj+UIac55wDfj3RKbzK1a1MIN6SfXWEnf
   jduKBQLdCPP5rEoTYTgMkotyxUI9jAEgue1um4pAmMT8H+i65LYpbDLzH
   NzZIKrXvt0hK7uvjsL+HQ54NNVUljRzR8ES+vTB+7//OF4MQtdpJHNDmT
   83bNkmEWUeoAmMvmpmIm2nwoC4SLl1r4kqmvtG8CIPXhzZDFKxnLEcJgJ
   vSTK3kII69gw3+CKV3QHdsG1QrzyocrkpWRc6kLfRwtAhhv8Ic0TBfPo2
   g==;
X-CSE-ConnectionGUID: 0qnMa+tjQOGP5gLNlGr2Aw==
X-CSE-MsgGUID: 85z4WXisQOGrm511UAqrdQ==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7780439"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-015.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:46:41 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:7299]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.30.60:2525] with esmtp (Farcaster)
 id 878e6f71-dbb9-456a-8c30-1d51432bc172; Wed, 14 Jan 2026 13:46:41 +0000 (UTC)
X-Farcaster-Flow-ID: 878e6f71-dbb9-456a-8c30-1d51432bc172
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:33 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:32 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:46:32 +0000
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
Subject: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct map
Thread-Topic: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from
 direct map
Thread-Index: AQHchVwxUHbiw0Os6UOagV6OHUZMMQ==
Date: Wed, 14 Jan 2026 13:46:32 +0000
Message-ID: <20260114134510.1835-8-kalyazin@amazon.com>
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
X-Rspam-User: 
X-Stat-Signature: x6ybnh5fwnw61pxi7ebqez9jj6huu5bo
X-Rspamd-Queue-Id: D31B320004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768398420-943579
X-HE-Meta: U2FsdGVkX1+iuNoliCISxGgnVAdqilHOpIFh9SqtWOWyqrGaQLuxeBC4TckPEm+dQM0uf/FCyCh9opbZEwc3SY2m+Oj4MFWogj2Gmg4cEHuNaPR5kQImgH5+g4UV9l9f0iF/Ln8hQVFDWm1emcSuavkUlLLq8ZRHKOYNpLRx3KnDDdLUtCbCq408e8G161bJPeuTlXJPAnIYjY5x7513i0n3K/mY9/Y+grLBo573vdFs01wXxzYmeIXcIRSOr20W8qJ0ZYjWudnIlFN0mzSpyxrovQTdJ4pTywbYTu1Uo9Ra6lM3uASwtD7o8UFARNA0GoeDd956wQmW4jGQ1t6EHV2OfaxWeHRkZO70pu+ojrE+YQZVHaudM2BZwHfaiNRpLe3+u0XaO0LMAGAbemOeHKkzBkaFG3XznP5GyOGS45a/U2AJKPq82ZLk3UHiCn9r0di689WmLYwFttazc7Rw6iDFOrpLhjNMsaI8VAngydmpxNs2500VTZy5D0L4dMwCmKNQ7+vLcPQzFJwuS+SDpHQYMMsyBWKInxpXYnDvvxzznaYKKOb24WgUsXaod2JlRhWH0oXzvb6bzPkZ1shBY2YOM2BrnmJsz0zvYuLtJKoCUUAyMa1T0g2JwYPHj3zVAiJvh3eZcehVax7O2JoA7lw8maLTaUvLuiOA/yHidpVxX2Yz5pyp/FhUe6edStez9L9nQfsWwfljj2QEbBntRJRL2dbz79wQDHw7zgu+wDbb+j/NhNg/BMRd/kH3v69yh+9lUwXNUH4EkQruuVak7C9fg+euwsaYIGJk60jNf8bPW30U5Vzyl0wWuvjvVRg2ylYcG/wygWQvX4M2yZExe2583UzhWNH8PPfNQOHbCI/n+nKZqSfYQnpAbqIMJQiiNV7v1KbYv5IPRfpnfObu8Crjtqi/JbT+731FLXprK4UDtIrt/4FLf6wGkdYaYxz3MS8/tTb3a4Y1GYpnZmE
 nJ0Jol17
 zGTkGKf4bIRM/8x4AutjIacitGia6SjeHFmi6kBKh0g6jLYhmYVZhdQgls1cjTec9IC3PzaxeURKfDmpyX5pqncqoxT9wjGK6xHuO+O/xbu2dmK7LzC4G6YTaKYkjNNaEFKBfI4yxzuf3w3xZZXA/qOiqwBSUkJZ6o2vHHSVAWaVSZRWyINGgpRILvcCrrl50tkMerXtTcZRtfb5xjuBFQchiKKC7wpX58SfRWENIEOgRlYJco3bZLv3/86FkLjrLNrISIjJlGEZx+1YuUAvpsuXgWgS4/q9Qc/k8JqgfiBAqkiTt909EpBM5t9G4Bc3QksAZAY703Kl095AQ+jJpUYBQ8vY7xwAsSINYeyOcJwvbRGDN4UWl8DQTuizdO0YvWrHmBXpl7yU2EyuHQqUpFge7RchjDu9MRCmen6fVc8BWNYckq7DkjTP+6ddzjdk77ecMHCIYCwr+MrE/YrlLsFtEljP1A5yrSTFYZTTaQLW4mAXnkgI4S9K5CMGUtiF8E5B0ngf+nMCn9aJP6G0sPovRGuiULEp5p3smIeFtTE+T1i87Zdkz6WBRKpyLmVb4ooV9DsikOe6CCvLBsijQMc+zQlTENnk8ToTCX3/PL9NXaBIk2xAkO+mM+jvieL7YrwDT8za+90xHy6CVem02Qqa6TYla5mVM4rKcfj5b9Mud4vvbRNFJA5Qap1mLLVF79noXgx5mH2TP+ECH+Ovw0Nn/C5JLd+RZbqf1h3f91jkr5SVFGgWmrt83N0UZFoXBxzR+dQsE3KHVero=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Add GUEST_MEMFD_FLAG_NO_DIRECT_MAP flag for KVM_CREATE_GUEST_MEMFD()=0A=
ioctl. When set, guest_memfd folios will be removed from the direct map=0A=
after preparation, with direct map entries only restored when the folios=0A=
are freed.=0A=
=0A=
To ensure these folios do not end up in places where the kernel cannot=0A=
deal with them, set AS_NO_DIRECT_MAP on the guest_memfd's struct=0A=
address_space if GUEST_MEMFD_FLAG_NO_DIRECT_MAP is requested.=0A=
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
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 Documentation/virt/kvm/api.rst | 22 ++++++++------=0A=
 include/linux/kvm_host.h       | 12 ++++++++=0A=
 include/uapi/linux/kvm.h       |  1 +=0A=
 virt/kvm/guest_memfd.c         | 54 ++++++++++++++++++++++++++++++++++=0A=
 4 files changed, 80 insertions(+), 9 deletions(-)=0A=
=0A=
diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rs=
t=0A=
index 01a3abef8abb..c5f54f1370c8 100644=0A=
--- a/Documentation/virt/kvm/api.rst=0A=
+++ b/Documentation/virt/kvm/api.rst=0A=
@@ -6440,15 +6440,19 @@ a single guest_memfd file, but the bound ranges mus=
t not overlap).=0A=
 The capability KVM_CAP_GUEST_MEMFD_FLAGS enumerates the `flags` that can b=
e=0A=
 specified via KVM_CREATE_GUEST_MEMFD.  Currently defined flags:=0A=
 =0A=
-  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=0A=
-  GUEST_MEMFD_FLAG_MMAP        Enable using mmap() on the guest_memfd file=
=0A=
-                               descriptor.=0A=
-  GUEST_MEMFD_FLAG_INIT_SHARED Make all memory in the file shared during=
=0A=
-                               KVM_CREATE_GUEST_MEMFD (memory files create=
d=0A=
-                               without INIT_SHARED will be marked private)=
.=0A=
-                               Shared memory can be faulted into host user=
space=0A=
-                               page tables. Private memory cannot.=0A=
-  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=0A=
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0A=
+  GUEST_MEMFD_FLAG_MMAP          Enable using mmap() on the guest_memfd fi=
le=0A=
+                                 descriptor.=0A=
+  GUEST_MEMFD_FLAG_INIT_SHARED   Make all memory in the file shared during=
=0A=
+                                 KVM_CREATE_GUEST_MEMFD (memory files crea=
ted=0A=
+                                 without INIT_SHARED will be marked privat=
e).=0A=
+                                 Shared memory can be faulted into host us=
erspace=0A=
+                                 page tables. Private memory cannot.=0A=
+  GUEST_MEMFD_FLAG_NO_DIRECT_MAP The guest_memfd instance will behave simi=
larly=0A=
+                                 to memfd_secret, and unmaps the memory ba=
cking=0A=
+                                 it from the kernel's address space before=
=0A=
+                                 being passed off to userspace or the gues=
t.=0A=
+  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=0A=
 =0A=
 When the KVM MMU performs a PFN lookup to service a guest fault and the ba=
cking=0A=
 guest_memfd has the GUEST_MEMFD_FLAG_MMAP set, then the fault will always =
be=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index 27796a09d29b..d4d5306075bf 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -738,10 +738,22 @@ static inline u64 kvm_gmem_get_supported_flags(struct=
 kvm *kvm)=0A=
 	if (!kvm || kvm_arch_supports_gmem_init_shared(kvm))=0A=
 		flags |=3D GUEST_MEMFD_FLAG_INIT_SHARED;=0A=
 =0A=
+	if (kvm_arch_gmem_supports_no_direct_map())=0A=
+		flags |=3D GUEST_MEMFD_FLAG_NO_DIRECT_MAP;=0A=
+=0A=
 	return flags;=0A=
 }=0A=
 #endif=0A=
 =0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+#ifndef kvm_arch_gmem_supports_no_direct_map=0A=
+static inline bool kvm_arch_gmem_supports_no_direct_map(void)=0A=
+{=0A=
+	return false;=0A=
+}=0A=
+#endif=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
+=0A=
 #ifndef kvm_arch_has_readonly_mem=0A=
 static inline bool kvm_arch_has_readonly_mem(struct kvm *kvm)=0A=
 {=0A=
diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h=0A=
index dddb781b0507..60341e1ba1be 100644=0A=
--- a/include/uapi/linux/kvm.h=0A=
+++ b/include/uapi/linux/kvm.h=0A=
@@ -1612,6 +1612,7 @@ struct kvm_memory_attributes {=0A=
 #define KVM_CREATE_GUEST_MEMFD	_IOWR(KVMIO,  0xd4, struct kvm_create_guest=
_memfd)=0A=
 #define GUEST_MEMFD_FLAG_MMAP		(1ULL << 0)=0A=
 #define GUEST_MEMFD_FLAG_INIT_SHARED	(1ULL << 1)=0A=
+#define GUEST_MEMFD_FLAG_NO_DIRECT_MAP	(1ULL << 2)=0A=
 =0A=
 struct kvm_create_guest_memfd {=0A=
 	__u64 size;=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index 92e7f8c1f303..43f64c11467a 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -7,6 +7,9 @@=0A=
 #include <linux/mempolicy.h>=0A=
 #include <linux/pseudo_fs.h>=0A=
 #include <linux/pagemap.h>=0A=
+#include <linux/set_memory.h>=0A=
+=0A=
+#include <asm/tlbflush.h>=0A=
 =0A=
 #include "kvm_mm.h"=0A=
 =0A=
@@ -76,6 +79,43 @@ static int __kvm_gmem_prepare_folio(struct kvm *kvm, str=
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
+	u64 gmem_flags =3D GMEM_I(folio_inode(folio))->flags;=0A=
+	int r =3D 0;=0A=
+=0A=
+	if (kvm_gmem_folio_no_direct_map(folio) || !(gmem_flags & GUEST_MEMFD_FLA=
G_NO_DIRECT_MAP))=0A=
+		goto out;=0A=
+=0A=
+	folio->private =3D (void *)((u64)folio->private | KVM_GMEM_FOLIO_NO_DIREC=
T_MAP);=0A=
+	r =3D folio_zap_direct_map(folio);=0A=
+=0A=
+out:=0A=
+	return r;=0A=
+}=0A=
+=0A=
+static void kvm_gmem_folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	/*=0A=
+	 * Direct map restoration cannot fail, as the only error condition=0A=
+	 * for direct map manipulation is failure to allocate page tables=0A=
+	 * when splitting huge pages, but this split would have already=0A=
+	 * happened in folio_zap_direct_map() in kvm_gmem_folio_zap_direct_map().=
=0A=
+	 * Thus folio_restore_direct_map() here only updates prot bits.=0A=
+	 */=0A=
+	if (kvm_gmem_folio_no_direct_map(folio)) {=0A=
+		WARN_ON_ONCE(folio_restore_direct_map(folio));=0A=
+		folio->private =3D (void *)((u64)folio->private & ~KVM_GMEM_FOLIO_NO_DIR=
ECT_MAP);=0A=
+	}=0A=
+}=0A=
+=0A=
 static inline void kvm_gmem_mark_prepared(struct folio *folio)=0A=
 {=0A=
 	folio_mark_uptodate(folio);=0A=
@@ -398,6 +438,7 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm=
_fault *vmf)=0A=
 	struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
 	struct folio *folio;=0A=
 	vm_fault_t ret =3D VM_FAULT_LOCKED;=0A=
+	int err;=0A=
 =0A=
 	if (((loff_t)vmf->pgoff << PAGE_SHIFT) >=3D i_size_read(inode))=0A=
 		return VM_FAULT_SIGBUS;=0A=
@@ -423,6 +464,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct v=
m_fault *vmf)=0A=
 		kvm_gmem_mark_prepared(folio);=0A=
 	}=0A=
 =0A=
+	err =3D kvm_gmem_folio_zap_direct_map(folio);=0A=
+	if (err) {=0A=
+		ret =3D vmf_error(err);=0A=
+		goto out_folio;=0A=
+	}=0A=
+=0A=
 	vmf->page =3D folio_file_page(folio, vmf->pgoff);=0A=
 =0A=
 out_folio:=0A=
@@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)=0A=
 	kvm_pfn_t pfn =3D page_to_pfn(page);=0A=
 	int order =3D folio_order(folio);=0A=
 =0A=
+	kvm_gmem_folio_restore_direct_map(folio);=0A=
+=0A=
 	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));=0A=
 }=0A=
 =0A=
@@ -596,6 +645,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t si=
ze, u64 flags)=0A=
 	/* Unmovable mappings are supposed to be marked unevictable as well. */=
=0A=
 	WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));=0A=
 =0A=
+	if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)=0A=
+		mapping_set_no_direct_map(inode->i_mapping);=0A=
+=0A=
 	GMEM_I(inode)->flags =3D flags;=0A=
 =0A=
 	file =3D alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_f=
ops);=0A=
@@ -807,6 +859,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory=
_slot *slot,=0A=
 	if (!is_prepared)=0A=
 		r =3D kvm_gmem_prepare_folio(kvm, slot, gfn, folio);=0A=
 =0A=
+	kvm_gmem_folio_zap_direct_map(folio);=0A=
+=0A=
 	folio_unlock(folio);=0A=
 =0A=
 	if (!r)=0A=
-- =0A=
2.50.1=0A=
=0A=

