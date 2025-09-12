Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B3DCAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B15018E0019; Fri, 12 Sep 2025 05:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA5988E0016; Fri, 12 Sep 2025 05:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EDF8E0019; Fri, 12 Sep 2025 05:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F6E18E0016
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:17:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 508E7BAEDB
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:59 +0000 (UTC)
X-FDA: 83880046278.05.1E01619
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf26.hostedemail.com (Postfix) with ESMTP id CDF27140008
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:56 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=KgIXe2Xu;
	spf=pass (imf26.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=41cdObRV2/ULxTOTq6Jo3VA2F7BSJFHzuhvS9zYggVk=;
	b=bO8624Ne2c+oESOuXulzLYs4SKr9v4Dip3WlGXVAYQflrnYYF4W7s3w87SagutxhxCoswx
	kZfugQCMrsjzMeZ6ZfBPj2S1HakywBwHg34+uhduyTFi6QgEm/rFf4bwekS0bS5pxjXDVN
	z7e4TEGer6RWtO80ZZDWBwE6Xsr2Hvw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668677; a=rsa-sha256;
	cv=none;
	b=c48rJ3WXnSy5QtoFQlhp/qdzp/LsMjjKnYo6sxNrvEgJWcCeuzeVxIVNeTqz7Zg+uCrubZ
	81FfxQKJ/3bnhDO1irvRdXxboDNE1H4BA1ZYb/57bj2uFQftunaHgkhTWa9mB2mvxgy5Kb
	yxGWancGYwlcFdHniR0shL9kctCnnSM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=KgIXe2Xu;
	spf=pass (imf26.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668676; x=1789204676;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=41cdObRV2/ULxTOTq6Jo3VA2F7BSJFHzuhvS9zYggVk=;
  b=KgIXe2XuzXCAaHA0zcOeaIlP0GcxDlZ1AHJjTqUiArq3W9aMiqcDG5cC
   c/r9cSMFWxyF46yqdKp3S/JQYXPr4lLsNZN6Z8xoxF3fM48h61Af3k9Or
   7/Le/5Vsr+5l1q+/bkPwYqAeBklA71/0T/ZD7QW6UdY5mnUE21/zdIizw
   0tVjjXLcn7Af0cbqSqJ1MMlnw4KVGB9uc8lBwtbG2DOK7w4mLRJYmQ9JW
   sIxBJNUMbP/Kh7UjhVehXvMXAw71oyV7enR8Vkt4Qay0Ww0V32jcfJbXm
   3tKJKUILFw72JN/kE7BAuM6FJoXo+j42ogi5k4X7PzyQDBXHfWZoql/nt
   g==;
X-CSE-ConnectionGUID: ebdcgtMrTx6xMDSWHdTt2g==
X-CSE-MsgGUID: PGUELi/XT06/ELEYBnfMnQ==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="2004659"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:55 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:16512]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.1.26:2525] with esmtp (Farcaster)
 id 0785c246-36c5-4fce-8800-3c624d06aeb2; Fri, 12 Sep 2025 09:17:55 +0000 (UTC)
X-Farcaster-Flow-ID: 0785c246-36c5-4fce-8800-3c624d06aeb2
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:44 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:43 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:43 +0000
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
Subject: [PATCH v6 08/11] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Topic: [PATCH v6 08/11] KVM: selftests: Add guest_memfd based
 vm_mem_backing_src_types
Thread-Index: AQHcI8YY6/+VU2XIuE+c9Ntv3BXwAw==
Date: Fri, 12 Sep 2025 09:17:43 +0000
Message-ID: <20250912091708.17502-9-roypat@amazon.co.uk>
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
X-Stat-Signature: i9riy1mfy158pg5yzwk5ndzm913fpqr6
X-Rspam-User: 
X-Rspamd-Queue-Id: CDF27140008
X-Rspamd-Server: rspam10
X-HE-Tag: 1757668676-513095
X-HE-Meta: U2FsdGVkX18L59f/BxKpNubH6FQ2Cfl8DH+xE0pvfgW8KdPDmSlm8kty8bZI0RYGmU9ouBAQHOIoePXahMxo9FoqCCNnF2JHjSlZXHKYCohobuEpWqfCti/a1ih/+nE6xsGc9xCV6Y6NReCUqGC/KLQQYiyoX4kMpxsN6686LZccAG/isFDk2pDJ96jPxkX+MP118ytM3wKZ2LmyOgxl+hZxFq9tFiz3DMudMOOOejhLu6p3h51coF4UFfE7bTANn9mwXzQLBrPfuYrIO7G9JMesydIFRez/OuhgxIcQw7CPcyaCqFzABE4wgKIZH2qSqJSMr/u0T9A0RwKOPZmWnVkDyrWmZeVjNuOEgn11eSghUYg1UW5KzzxdUh1YwuIHrjmsDhI27Wh9EQRCDh3FXL+shFNm5l6vQTKGIvHaGQR57vlj4dFprjcNPJGySCvaOgu7PzQ4lnMxARwnPATQqrLIc/YUTYSXo+5sF/4LONAXD1aWB9OiijUFuhkjHUFPyB9AxFREm1ZO4qXzY1hb23YdEviglneFOQ0HjXo4aJJn6hqUdYkcmdVLqdtPGiaC65SvKzS59VVgJZQVTUavzvCByuQ+Brkwejc7iW4z3ZMIPfmh9vszLgEYn9dRCRwOKez65xUg4zdvZUxI6/Kva6xMCUuWaeqR/S5fd53uxY1LBGmdtsmtPCQM1g++KU1QAbljpBKW1vEnsRaffnnJw8Skz6+6RMc3H1ZygtRpIM/OikKgSWKcRzmOS9DVoCi0xwcC0dOxJY0DGAhDUwXTafs3p5soEDmy5hINgns8YssbpzSKeIbPnk5pHi+o6y31NNfY7qea2oEcjF3OozmzRKj0CfHoUsttaYrQ8AD38qSck/d2fg7q47Lcf0dp6PdM4l/KDJg9W0hFWcQ996QPxOFJ8UQ66oSYIFVNjUmWzEQ5+Zy4s4T8lY7XSNgh7Q18Wj+J7JmUw+/iGvwyoA7
 LDK6ZI5m
 TTB7Qbc0aCpFfwyICy0GU1TYuSQyHUFYcCMXMssao9vPuJtc5Nnrg4dtrK9jq0hTrpyMMk/nvD8nqqh7wZ58IoeCj3Cd0SysQO+pjhmzU9Du1S0VeHmLqwwKs23ZSLb2502mJd6KcvvP6XKLz1vUeblN9w4nKgUIIBbgm3Ky1cy5ZrFzu1o3vSuQNnIYe2qLD+ie/Mq5Rt/GHy8WmJInK5dvwonoN26XaPwrZ6ur1ifLouOjV4Q/seuwu3zGVDaSUx/z995YhYshMsRFPchASkx+WtAxSAHzA11rvCuxW06nOd+biRDL4A1etyvF2PfgMpXBkbucSJ31OyDJV6XMhxqgW/3+DBT/eqY69N5P2+49+dsIIKI7jfm51nYY4cgxUsi+CqdKYjpH+ULTmzMZctZxj1hj3jnYSGOOQlqhsylB0sBonycEtxlmSbBgoOCuVwSo4WRCTdJELaQVVFgZbs4/EYEOTYaXlygDGwyMx67w/YMU5/5zYERkA0hbjsPUt3PCDIxfEjAkbl3af3r/hvEle1GOOhQ1pomxvdZhgyKLtYHZFDXFosu4EucOl7fa7ugsWkASXH5t3ysoaOjmYgt7uTwjDYq3UdfySdqy22c/qXzLA6whCOOI0FsRPIqYQnOBrXSJ0ZIP61k5FJaTFC0UjVYMR5+7gZhWoRa+Uz6brlpnP/nfmO+8fNRCvqQ0+YXsW+mAjQrB6MkPqhKmcUtB42znNx8kdaT9FK4n9D0Hg5s46RcdRuAU/+/gcgiTtq1nG8To9WlQ+uUJkzbERQFSkZXgwUB1/uSnYOw3w/mW/n/Q7IJzKcosV51uQHVAr9PItmBJBXHbTUOjePLJt3ot7WYYiRyNEcEep
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
2.50.1=0A=
=0A=

