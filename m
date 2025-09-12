Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46D50CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:17:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7E0746B000E; Fri, 12 Sep 2025 05:17:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 795076B0010; Fri, 12 Sep 2025 05:17:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51FD26B0011; Fri, 12 Sep 2025 05:17:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 430386B000E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:17:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EDB645AE58
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:46 +0000 (UTC)
X-FDA: 83880045732.21.78EE186
Received: from fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.156.205.64])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9B4D1180006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:17:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=OZ7xmStx;
	spf=pass (imf16.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757668664;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nAXTWOycHUS9oQq/r+tGcFhviHWk3dwfE1BhY62JZQI=;
	b=3eQ4WBmpGruM+ouSxo77BKqVp/VLKRpePfONbrPTgntk4I/+jb5CMMRJC4RAgQIMvcRQzP
	XwOtJ+ALxAkouBRd2KNRxknV2em1eAW3/hftxy6atPzeeVIEK+ThVDw9F4HY26rQjMBli5
	L2Zo0bAaX0Rxz4AfA+gcHxAcBztdGOo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757668664; a=rsa-sha256;
	cv=none;
	b=8IoTivxv9g15GvqXSbnbM+qjPun4d2K+4UtZBJY8DOTxqdTQAygEX7fMEfGJkU0p13Qy+M
	poPYEJt8ybYGk85dLwUKMcLfLHg5kPiKyOSNWWj1NMiIWfRkactYeoMfwwHTB+PR56MVdF
	oo587GUsT/RhNLUoM8mDbcD/XyY5MDM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=OZ7xmStx;
	spf=pass (imf16.hostedemail.com: domain of "prvs=343957b79=roypat@amazon.co.uk" designates 18.156.205.64 as permitted sender) smtp.mailfrom="prvs=343957b79=roypat@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1757668664; x=1789204664;
  h=from:cc:subject:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version;
  bh=nAXTWOycHUS9oQq/r+tGcFhviHWk3dwfE1BhY62JZQI=;
  b=OZ7xmStx4Ot/QUWvdPWSEDqdkMvqQD0FVqfNzrIVgXg37siWGqcFmOUP
   dSKDzInNsOZ29H5WGuuL2Mwcng+6TglH4RTTk0r78i9qE6x+2aYp6KqG7
   nYvSZOuucNXBIXsSrc/QQ/BhJQNO72pjDY4GlYdAZutAAbdA5Zbxo24Zf
   Jjip83bx0JJJ76OmLKaRDJaXYFtIDGmh/V1pUOdZLrschiNeZwI/L78NJ
   gUsgSUZTmErBDtXlM+ZHllGHDS2HFVEX/d+fvmo/aC6SkGnL/UOODZOXB
   16pslmUdGPupZExJ4DJP29wMs1oHNCziSUhwnUgAhw/Lii9NFfHQ0JPzF
   w==;
X-CSE-ConnectionGUID: j4Efto7WShqD4fI79HucAg==
X-CSE-MsgGUID: 6DNTX8jxTMubfNopILf8Eg==
X-IronPort-AV: E=Sophos;i="6.18,259,1751241600"; 
   d="scan'208";a="2004634"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-001.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Sep 2025 09:17:34 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:6318]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.11.107:2525] with esmtp (Farcaster)
 id a91e1d85-e397-46af-94b1-48a53ba9e43e; Fri, 12 Sep 2025 09:17:34 +0000 (UTC)
X-Farcaster-Flow-ID: a91e1d85-e397-46af-94b1-48a53ba9e43e
Received: from EX19D015EUB001.ant.amazon.com (10.252.51.114) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:33 +0000
Received: from EX19D015EUB004.ant.amazon.com (10.252.51.13) by
 EX19D015EUB001.ant.amazon.com (10.252.51.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Fri, 12 Sep 2025 09:17:33 +0000
Received: from EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a]) by
 EX19D015EUB004.ant.amazon.com ([fe80::2dc9:7aa9:9cd3:fc8a%3]) with mapi id
 15.02.2562.020; Fri, 12 Sep 2025 09:17:33 +0000
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
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Fuad
 Tabba" <tabba@google.com>
Subject: [PATCH v6 02/11] arch: export set_direct_map_valid_noflush to KVM
 module
Thread-Topic: [PATCH v6 02/11] arch: export set_direct_map_valid_noflush to
 KVM module
Thread-Index: AQHcI8YSgiTpMeKXGkS2hhvLGeEJDA==
Date: Fri, 12 Sep 2025 09:17:32 +0000
Message-ID: <20250912091708.17502-3-roypat@amazon.co.uk>
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
X-Rspamd-Queue-Id: 9B4D1180006
X-Stat-Signature: pkfpuyeemmjxem73o9kjaxud8igypi8f
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757668664-473401
X-HE-Meta: U2FsdGVkX18Y3KLkq5YWAQ41SnP6/J56Z4qK0oCB7eygVQ2qm49EBh1nibSIUeTEuxSa3bcd2ScbBAy/VIjv4tzd1tadxNCEHAZzJJ0uLoqSSuEAVGAYdcLiRB7R+DnLPdhakcWB0S5m+SaI0Q+0mLcdsCnpAt4rgwQdBLzC6GHFfhLmvmus7vmMjaZoHRDUHDx2cyAOLAvNNchCfwWIiQELNGEKudKTIIHuTjJM1cLBL7NyuRS07uG23xSnRNqroltb2BJgciL6RYn4d6wSOAtzJhvJaHGo6IUkzfVa9JCrCrUj7BZ8IeeWoy6k/UNXWf5PXf7JZNipWCZgurxEAD8jycHsU4IuXg9B4lJqk5Z9iSMuoGsvu8vqeB78t3zRx0jGoEOG+b0Ib8oJ2zHV3KX1FBEDRTHm9afMJWkDyRRSQeNS3U/6XUgM6aHjjmn9XNhDQc2jyJb9vsaZyX8TUL7HzGODpyxX01ZIHd9VOSytqeCZbJ+/R+JetcEF3OnGax8jBeXr35AcLW7uHRsL8WIZs0GjVCyEEmE0k33ERR2/GTehrAFbWY6jB/fGDudfLlFDGH/xRZl1IIQzchBMpTmnBflJSeyOfwNEPIU8hE8TpOoXIQNpPmNy8avPqSL+YB6VxNMa9igqIZTMlp7ZaZ2NCsV/i6gpEHg9XGQ2Ffl78iDhU5NIY6MuCTWOpdmfmiaEgJ9x05HMGjZ4MpDd0gt0XTHotrIlWiJKYNzoWxtsikgM+Q7MHsmZ7HbAprIv65k2LSudTGbWuh0qBuNUZkP2FzcyDP8NZk5qYkuVlhex9ugtQfNcHt2RXFaGRWNujYyzogi10PaPHg41D817qtY58ZG5bK1+3kAXM1/Woyu5XG8rv8ZPU2hAwffhXuWIIQQ/3yL6YHmQBpSq3eAiD5ke5RKD+9D6dOx6TJyTCMpqHZzi32i4obShgopgFtg73CYtxCr5I/jkjc+qS29
 6VBpWvNs
 QgIi8lDWPFPROPS5f6hjlfr/JwLeM5ieUWhV4USHjhDmfXtuqplvGYBxMxz9leG4WfVTQ6eKXZUEmrBf3K9Sxnshq7JMEPs4wOIaCvbIXV5je/puovqferkPR0B73uj9pqtE8bXeRZAXvD0s4F1p9AbOwXlisO/j7zsOyZRsUEJ77TvLIwQ6mWcs5boeADOeIqYe9pk6BcCdyUaBbc0fguWGUOGQJvUMqV561c0xqSr3HoQcPAwU7r6wZqjlpuA6BnHabE5Mf1c1+bkCgqhKOJbfizXu2OHR0duslRwN1RSZH82Ftkrr6XVmaIyJtT+6T0Kq9kcJ1D7SwSszdMwHjPABb1vdxDr6fGgUsSD3kCq5ySeLvHtM4BugHYDlAAI+HAaPPvk0s/qqVwH+8OYJsHR/1Vd1bjyk80I35xqEAho2RzkWEhQjV4gE9KqXCdC/56COKyXnM1+3C+9TK7Ii0U9a2Kq1xtVcrUdHgaeAqSq6LJhbAUvvUxPm0FrJqCLPoeZfsS6ymnqjECGRqsInBBCmwa1lmaDTE8KTdwqYDpoaYgl4UAKdWAi/mX7mt/z023b63d0JFBXSA9bCnhc2p1npK3h0BHk9CVtyS0EVaU8zpwGZpRo1YKUSPp7kmeFs3Slwwpjz6LY4bMM0u1qf5x0FOblWxwr34WGApDMOBaJ7X1h7Qta6HBBtPUf2pgTrtk8At8sVPlCoonnWOPP8EYy98QlPMAlmosGDxBNEBPcHzTtDaP3T/uoHF1QCR7vqTBTYjGiXx0bbroRIecrF2DBU8t0JW8DLqoDLZ867Zuz0R5h2Os6FaBBlcFy1c8i/50B//6H/NKEFwLBPLpHPUvzWTuT0G4s+yAQ77UiJa1ZqeL1kJSbFeuRoJFaChpemJiejW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the new per-module export functionality to allow KVM (and only KVM)=0A=
access to set_direct_map_valid_noflush(). This allows guest_memfd to=0A=
remove its memory from the direct map, even if KVM is built as a module.=0A=
=0A=
Direct map removal gives guest_memfd the same protection that=0A=
memfd_secret enjoys, such as hardening against Spectre-like attacks=0A=
through in-kernel gadgets.=0A=
=0A=
Reviewed-by: Fuad Tabba <tabba@google.com>=0A=
Signed-off-by: Patrick Roy <roypat@amazon.co.uk>=0A=
---=0A=
 arch/arm64/mm/pageattr.c     | 1 +=0A=
 arch/loongarch/mm/pageattr.c | 1 +=0A=
 arch/riscv/mm/pageattr.c     | 1 +=0A=
 arch/s390/mm/pageattr.c      | 1 +=0A=
 arch/x86/mm/pat/set_memory.c | 1 +=0A=
 5 files changed, 5 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c=0A=
index 04d4a8f676db..4f3cddfab9b0 100644=0A=
--- a/arch/arm64/mm/pageattr.c=0A=
+++ b/arch/arm64/mm/pageattr.c=0A=
@@ -291,6 +291,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return set_memory_valid(addr, nr, valid);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 /*=0A=
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c=0A=
index f5e910b68229..458f5ae6a89b 100644=0A=
--- a/arch/loongarch/mm/pageattr.c=0A=
+++ b/arch/loongarch/mm/pageattr.c=0A=
@@ -236,3 +236,4 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return __set_memory(addr, 1, set, clear);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c=0A=
index 3f76db3d2769..6db31040cd66 100644=0A=
--- a/arch/riscv/mm/pageattr.c=0A=
+++ b/arch/riscv/mm/pageattr.c=0A=
@@ -400,6 +400,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return __set_memory((unsigned long)page_address(page), nr, set, clear);=
=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *=
data)=0A=
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c=0A=
index 348e759840e7..8ffd9ef09bc6 100644=0A=
--- a/arch/s390/mm/pageattr.c=0A=
+++ b/arch/s390/mm/pageattr.c=0A=
@@ -413,6 +413,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 =0A=
 	return __set_memory((unsigned long)page_to_virt(page), nr, flags);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 bool kernel_page_present(struct page *page)=0A=
 {=0A=
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c=0A=
index 8834c76f91c9..87e9c7d2dcdc 100644=0A=
--- a/arch/x86/mm/pat/set_memory.c=0A=
+++ b/arch/x86/mm/pat/set_memory.c=0A=
@@ -2661,6 +2661,7 @@ int set_direct_map_valid_noflush(struct page *page, u=
nsigned nr, bool valid)=0A=
 =0A=
 	return __set_pages_np(page, nr);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 void __kernel_map_pages(struct page *page, int numpages, int enable)=0A=
-- =0A=
2.50.1=0A=
=0A=

