Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E039CD19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:47:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 571916B0092; Mon, 26 Jan 2026 11:47:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 548DF6B0093; Mon, 26 Jan 2026 11:47:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4210B6B0095; Mon, 26 Jan 2026 11:47:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 300EC6B0092
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:47:34 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D9C5FC29BD
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:33 +0000 (UTC)
X-FDA: 84374695986.24.39426FE
Received: from fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.65.3.180])
	by imf12.hostedemail.com (Postfix) with ESMTP id 29F7940008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=av28pWNE;
	spf=pass (imf12.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itJUHovmx8ThQnuXFjcLy1G60dRyIFRRQr44NmgQ9VQ=;
	b=YvkWIgIW7HZAVmxTf2TS1qLJ7u1Ob+JnEdToz5MRHicG1VdH5WiUOpCXDQ1czZ0cPHVd3V
	hom+LrrXVseagYk5o2AOEU3UgMRqD6WJRHF+qriZ0vCEQfDW4qaPtq69r90MJgfiF7ukaL
	saTZDAM/n4l1SbofLWDfLENowg8tfpQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=av28pWNE;
	spf=pass (imf12.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.65.3.180 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446051; a=rsa-sha256;
	cv=none;
	b=yXrWSc3WQaG41yUkQYG3+pFRhwDloenEectNIK9Va3XYv0MJ8Z3xulBZT68KVp4LwYDQ0E
	uEqY0aJNsf6Zds0hOEO7r8aGaAmTXYMb2Fl5Zd5ALDQvYhhGQwBSLt0UMD2D7vmQ41IRHQ
	0E9F7LKGzPlvW9kqzJRfvBE6GU3FHlw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446051; x=1800982051;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=itJUHovmx8ThQnuXFjcLy1G60dRyIFRRQr44NmgQ9VQ=;
  b=av28pWNEVJn3VMWqWUSrBCHb10+j609zYlL0PBS3P7k8f3tw2OkmA+6M
   gEayfhW9ZsX0PI5aGQHioXfuUSMgx4BhzzE2IXRW1irtnTKLj1zSFf46P
   qsLHQRuguRoMiAsPWXGgzzYTx7D/ftfO+onclY31ae2Q0tngYKEabQoMY
   Gp96Y9t7GQpQckLcEzUpMz+wWh4TIQaT8lXQ2/S52T8b5IXZMwA0whid9
   HJo2qEyXb5QgOGPeYGtgRs0KfBkG/jGHfV6sGIiVqbRqjeJrhPdSU2kO5
   QdLKnGDlDhGSgj7Z4EOyHPeft4etXmohQHPaanxF7yWfKRaL12o/scKaN
   A==;
X-CSE-ConnectionGUID: mAl7W5q2Q9qKqPQn17E9NQ==
X-CSE-MsgGUID: vLAaNxp6S+iNE/SUHLTamA==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8460917"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-002.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:47:12 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.233:20657]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.13.191:2525] with esmtp (Farcaster)
 id 7aedb640-8db8-4ae8-804d-436f487cb697; Mon, 26 Jan 2026 16:47:12 +0000 (UTC)
X-Farcaster-Flow-ID: 7aedb640-8db8-4ae8-804d-436f487cb697
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:12 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:11 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:47:11 +0000
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
	"tglx@kernel.org" <tglx@kernel.org>, "mingo@redhat.com" <mingo@redhat.com>,
	"bp@alien8.de" <bp@alien8.de>, "dave.hansen@linux.intel.com"
	<dave.hansen@linux.intel.com>, "x86@kernel.org" <x86@kernel.org>,
	"hpa@zytor.com" <hpa@zytor.com>, "luto@kernel.org" <luto@kernel.org>,
	"peterz@infradead.org" <peterz@infradead.org>, "willy@infradead.org"
	<willy@infradead.org>, "akpm@linux-foundation.org"
	<akpm@linux-foundation.org>, "david@kernel.org" <david@kernel.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>, "vbabka@suse.cz"
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
	"palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "wyihan@google.com" <wyihan@google.com>,
	"yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
	"Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "urezki@gmail.com"
	<urezki@gmail.com>, "zhengqi.arch@bytedance.com"
	<zhengqi.arch@bytedance.com>, "gerald.schaefer@linux.ibm.com"
	<gerald.schaefer@linux.ibm.com>, "jiayuan.chen@shopee.com"
	<jiayuan.chen@shopee.com>, "lenb@kernel.org" <lenb@kernel.org>,
	"osalvador@suse.de" <osalvador@suse.de>, "pavel@kernel.org"
	<pavel@kernel.org>, "rafael@kernel.org" <rafael@kernel.org>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
	"patrick.roy@linux.dev" <patrick.roy@linux.dev>, "Thomson, Jack"
	<jackabt@amazon.co.uk>, "Itazuri, Takahiro" <itazur@amazon.co.uk>,
	"Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
	<xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v10 02/15] set_memory: add folio_{zap,restore}_direct_map
 helpers
Thread-Topic: [PATCH v10 02/15] set_memory: add folio_{zap,restore}_direct_map
 helpers
Thread-Index: AQHcjuNqThDEVtMYx0OshrAVDnsQEg==
Date: Mon, 26 Jan 2026 16:47:11 +0000
Message-ID: <20260126164445.11867-3-kalyazin@amazon.com>
References: <20260126164445.11867-1-kalyazin@amazon.com>
In-Reply-To: <20260126164445.11867-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam12
X-Stat-Signature: w8aftojq4rhqisduuwbdyruhgripqex6
X-Rspamd-Queue-Id: 29F7940008
X-Rspam-User: 
X-HE-Tag: 1769446050-706777
X-HE-Meta: U2FsdGVkX1+jbuZCtYLDHNqMH4UQnM8OVhXhs4ylrHHrNQGiktmLa9LNLxqgl8+Ens5YyCBvi9ZVN6DZYJtj2j68UeuyXsdBu+0ME8wETcPaQwEZlO38r4dBSci0h08VSRBCfcJ7rhnvPsaMF+Ni4J+TCYWtHxew3tG7dGzprwxwrnmiz6T1uWRiQOZs3pp0aVK5Kbh04a6tQKZWLPtaEgpGvlwzqHEGB5/z3SOb3X0RNstaQPoDlIQ0l0KalD3fvQ1Hz4WpZHiOF68ARK4n/IRnO3VblGNHyHF0kdvFY8uRb9gByrnhFNYDRRNFQ4KBJC2az+mckyWRz9Gmf2ljWQk6wGoD3ZuD+WR79tgkWUIhwJES3hxN9jCPimMp7UH/A5/jIrRdkJuuq1lNRz1FZZmbbLwBEPz0pY0RyYdFUroFYkaIP5KbrL5+rLIIpkgm6oLUp15mFpEzrlCZ/tKZS4pdt9vI7HbBq8zAP9USUwVqil6o+7N4KEGfTXZbbvIEP9TtSBFAeThr4TXaReNFtJ4D4lLRZN6yqBBVZKSZKoX9vaOaYJBbnOYmsjSWx1/rhRrOJrlv7QLRs7BsP4T0lFC4ICo13hAr5NDP97uDdGK0d3btflDKSuHEF4ZFD6ojcTCThDI0w3H/RQL0h99T5diTHniRBY7fkVa3I8aUaWN1sAqhzXz6xUBpGU1wf1u87i86bvMbyf/5Ak/nOgIIE2JYedTIEBQiEAwAC+m7JsMZIGwE2q0HlLDVI2YHTq247xOipp/Sb5d5O94h6kphpJ4wJ1T3FJm42rPNaptW+ibS+jeUqOpegHfWD2OCyIGFA8Ut91lMSlVbLBe9DgFQzF2P0Uv3g2gAOnAx4887Jwl8mLfte/ZeOvVI8ugVTBqk3KIlMk7o7XZygAHnM1RMa1VVgmaeG5NkoBOEBQPUl/HPQ7O2pSrbvP/rI2VPWcnMf+Q2HLHlSjyTWkt0+ao
 pePfR1V3
 0z22+L/qZB+mP+O8b6SUzG4nNTLlCk+in44fPEeVsm/41u/+Lh3aoDE/atoY+JrdQnZvTjCvzdOpWWqUDnNqasINEwZAAq/dLh8l80xM4xrpxtOmU8uU2WuMWqK/NRC3+cmUyoAvQ5086ZlI33lTgrpXa6U0prAuvTDJpEmHSZ3xQISKZPkY6NPGMjMO7TDJxBXl/EnO1inQUea8dk7wA2CYkIaY2qM3TRybbF1xPeU3YoRXodxZrc48N/+3zytuxM/M3NOsbbyyHCYWy0hM2sgNKI11qdGBhrOHKI/hZMeWJ1WEBN2KCJTnHnlDteCFXTDduPL04BqCo3Mbe9r/sltegt4vVzWp65ZF8IrOUa3qyV/90Paexfgzu6ShC8HSlqTs2gdQWp2dECu53hQNyV7vgOAtJZgyFvYUoCfZ+W6j++yl3TwEFpNwCZ2+FSFbkok7yI9YCuJtwcY1T5d8Wam5sVZG11AXZHcgqGWhBlKVlp2b5nQy7Q9dxUZVCnYfz7zdL3BRcd3p1QS9+0OtnZTAZY5gcxsb2YRm9C/xtVEwXQbAVVEYqCbeO36vBMV83GI8aDENWvvWD5HJWQKfciSFjjtDwtY2GF2c0AxlpJHDyLDnEFs9oDpguEjQ1SPp1EwXm97ko6J8DQmREadNIy5lBllX9IEUlZ07vURtvPU8plCLzRPbLOlMLOi0xn7vaOkGleD1YwidpgLjRJ6rb9duWo7LeDlGV+BMRNaauIRiMYT3Hi2ZWFLpxWZ9ruOrjfdRJqg4nLiKXjHW0yJFUlAZ7Ug==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>=0A=
=0A=
These allow guest_memfd to remove its memory from the direct map.=0A=
Only implement them for architectures that have direct map.=0A=
In folio_zap_direct_map(), flush TLB on architectures where=0A=
set_direct_map_valid_noflush() does not flush it internally.=0A=
=0A=
The new helpers need to be accessible to KVM on architectures that=0A=
support guest_memfd (x86 and arm64).  Since arm64 does not support=0A=
building KVM as a module, only export them on x86.=0A=
=0A=
Direct map removal gives guest_memfd the same protection that=0A=
memfd_secret does, such as hardening against Spectre-like attacks=0A=
through in-kernel gadgets.=0A=
=0A=
Reviewed-by: Ackerley Tng <ackerleytng@google.com>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/arm64/include/asm/set_memory.h     |  2 ++=0A=
 arch/arm64/mm/pageattr.c                | 12 ++++++++++++=0A=
 arch/loongarch/include/asm/set_memory.h |  2 ++=0A=
 arch/loongarch/mm/pageattr.c            | 12 ++++++++++++=0A=
 arch/riscv/include/asm/set_memory.h     |  2 ++=0A=
 arch/riscv/mm/pageattr.c                | 12 ++++++++++++=0A=
 arch/s390/include/asm/set_memory.h      |  2 ++=0A=
 arch/s390/mm/pageattr.c                 | 12 ++++++++++++=0A=
 arch/x86/include/asm/set_memory.h       |  2 ++=0A=
 arch/x86/mm/pat/set_memory.c            | 20 ++++++++++++++++++++=0A=
 include/linux/set_memory.h              | 10 ++++++++++=0A=
 11 files changed, 88 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/s=
et_memory.h=0A=
index c71a2a6812c4..49fd54f3c265 100644=0A=
--- a/arch/arm64/include/asm/set_memory.h=0A=
+++ b/arch/arm64/include/asm/set_memory.h=0A=
@@ -15,6 +15,8 @@ int set_direct_map_invalid_noflush(const void *addr);=0A=
 int set_direct_map_default_noflush(const void *addr);=0A=
 int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
 				 bool valid);=0A=
+int folio_zap_direct_map(struct folio *folio);=0A=
+int folio_restore_direct_map(struct folio *folio);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 int set_memory_encrypted(unsigned long addr, int numpages);=0A=
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c=0A=
index e2bdc3c1f992..0b88b0344499 100644=0A=
--- a/arch/arm64/mm/pageattr.c=0A=
+++ b/arch/arm64/mm/pageattr.c=0A=
@@ -356,6 +356,18 @@ int set_direct_map_valid_noflush(const void *addr, uns=
igned long numpages,=0A=
 	return set_memory_valid((unsigned long)addr, numpages, valid);=0A=
 }=0A=
 =0A=
+int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), false);=0A=
+}=0A=
+=0A=
+int folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), true);=0A=
+}=0A=
+=0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 /*=0A=
  * This is - apart from the return value - doing the same=0A=
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/inclu=
de/asm/set_memory.h=0A=
index 5e9b67b2fea1..1cdec6afe209 100644=0A=
--- a/arch/loongarch/include/asm/set_memory.h=0A=
+++ b/arch/loongarch/include/asm/set_memory.h=0A=
@@ -19,5 +19,7 @@ int set_direct_map_invalid_noflush(const void *addr);=0A=
 int set_direct_map_default_noflush(const void *addr);=0A=
 int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
 				 bool valid);=0A=
+int folio_zap_direct_map(struct folio *folio);=0A=
+int folio_restore_direct_map(struct folio *folio);=0A=
 =0A=
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */=0A=
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c=0A=
index c1b2be915038..be397fddc991 100644=0A=
--- a/arch/loongarch/mm/pageattr.c=0A=
+++ b/arch/loongarch/mm/pageattr.c=0A=
@@ -235,3 +235,15 @@ int set_direct_map_valid_noflush(const void *addr, uns=
igned long numpages,=0A=
 =0A=
 	return __set_memory((unsigned long)addr, 1, set, clear);=0A=
 }=0A=
+=0A=
+int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), false);=0A=
+}=0A=
+=0A=
+int folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), true);=0A=
+}=0A=
diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/s=
et_memory.h=0A=
index a87eabd7fc78..208755d9d45e 100644=0A=
--- a/arch/riscv/include/asm/set_memory.h=0A=
+++ b/arch/riscv/include/asm/set_memory.h=0A=
@@ -44,6 +44,8 @@ int set_direct_map_invalid_noflush(const void *addr);=0A=
 int set_direct_map_default_noflush(const void *addr);=0A=
 int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
 				 bool valid);=0A=
+int folio_zap_direct_map(struct folio *folio);=0A=
+int folio_restore_direct_map(struct folio *folio);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 #endif /* __ASSEMBLER__ */=0A=
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c=0A=
index 0a457177a88c..9a8237658c48 100644=0A=
--- a/arch/riscv/mm/pageattr.c=0A=
+++ b/arch/riscv/mm/pageattr.c=0A=
@@ -402,6 +402,18 @@ int set_direct_map_valid_noflush(const void *addr, uns=
igned long numpages,=0A=
 	return __set_memory((unsigned long)addr, numpages, set, clear);=0A=
 }=0A=
 =0A=
+int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), false);=0A=
+}=0A=
+=0A=
+int folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), true);=0A=
+}=0A=
+=0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 static int debug_pagealloc_set_page(pte_t *pte, unsigned long addr, void *=
data)=0A=
 {=0A=
diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set=
_memory.h=0A=
index 3e43c3c96e67..a51ff50df3ca 100644=0A=
--- a/arch/s390/include/asm/set_memory.h=0A=
+++ b/arch/s390/include/asm/set_memory.h=0A=
@@ -64,6 +64,8 @@ int set_direct_map_invalid_noflush(const void *addr);=0A=
 int set_direct_map_default_noflush(const void *addr);=0A=
 int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
 				 bool valid);=0A=
+int folio_zap_direct_map(struct folio *folio);=0A=
+int folio_restore_direct_map(struct folio *folio);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 #endif=0A=
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c=0A=
index e231757bb0e0..f739fee0e110 100644=0A=
--- a/arch/s390/mm/pageattr.c=0A=
+++ b/arch/s390/mm/pageattr.c=0A=
@@ -413,6 +413,18 @@ int set_direct_map_valid_noflush(const void *addr, uns=
igned long numpages,=0A=
 	return __set_memory((unsigned long)addr, numpages, flags);=0A=
 }=0A=
 =0A=
+int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), false);=0A=
+}=0A=
+=0A=
+int folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), true);=0A=
+}=0A=
+=0A=
 bool kernel_page_present(struct page *page)=0A=
 {=0A=
 	unsigned long addr;=0A=
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_m=
emory.h=0A=
index f912191f0853..febbfbdc39df 100644=0A=
--- a/arch/x86/include/asm/set_memory.h=0A=
+++ b/arch/x86/include/asm/set_memory.h=0A=
@@ -91,6 +91,8 @@ int set_direct_map_invalid_noflush(const void *addr);=0A=
 int set_direct_map_default_noflush(const void *addr);=0A=
 int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
 				 bool valid);=0A=
+int folio_zap_direct_map(struct folio *folio);=0A=
+int folio_restore_direct_map(struct folio *folio);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 extern int kernel_set_to_readonly;=0A=
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c=0A=
index bc8e1c23175b..4a5a3124a92d 100644=0A=
--- a/arch/x86/mm/pat/set_memory.c=0A=
+++ b/arch/x86/mm/pat/set_memory.c=0A=
@@ -2657,6 +2657,26 @@ int set_direct_map_valid_noflush(const void *addr, u=
nsigned long numpages,=0A=
 	return __set_pages_np(addr, numpages);=0A=
 }=0A=
 =0A=
+int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	const void *addr =3D folio_address(folio);=0A=
+	int ret;=0A=
+=0A=
+	ret =3D set_direct_map_valid_noflush(addr, folio_nr_pages(folio), false);=
=0A=
+	flush_tlb_kernel_range((unsigned long)addr,=0A=
+			       (unsigned long)addr + folio_size(folio));=0A=
+=0A=
+	return ret;=0A=
+}=0A=
+EXPORT_SYMBOL_FOR_MODULES(folio_zap_direct_map, "kvm");=0A=
+=0A=
+int folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	return set_direct_map_valid_noflush(folio_address(folio),=0A=
+					    folio_nr_pages(folio), true);=0A=
+}=0A=
+EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");=0A=
+=0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 void __kernel_map_pages(struct page *page, int numpages, int enable)=0A=
 {=0A=
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h=0A=
index 1a2563f525fc..e2e6485f88db 100644=0A=
--- a/include/linux/set_memory.h=0A=
+++ b/include/linux/set_memory.h=0A=
@@ -41,6 +41,16 @@ static inline int set_direct_map_valid_noflush(const voi=
d *addr,=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+static inline int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static inline int folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	return 0;=0A=
+}=0A=
+=0A=
 static inline bool kernel_page_present(struct page *page)=0A=
 {=0A=
 	return true;=0A=
-- =0A=
2.50.1=0A=
=0A=

