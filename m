Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1632DF459E9
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:18:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7B5B96B0098; Fri, 10 Apr 2026 11:18:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 765D66B0099; Fri, 10 Apr 2026 11:18:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62DC86B009B; Fri, 10 Apr 2026 11:18:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4E01E6B0098
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:18:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 18AF513B166
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:35 +0000 (UTC)
X-FDA: 84643002990.02.6566210
Received: from iad-out-008.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-008.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.193.58.168])
	by imf22.hostedemail.com (Postfix) with ESMTP id BE7F2C000D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=MZ2ex4w9;
	spf=pass (imf22.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.193.58.168 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834312;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wjP/j8AJgPbtZq1XgPne0gPzghOZdblPBwP2xhZse4E=;
	b=8TMjPjplQ2VpINGtRJ0z+pwlSQ2Paw/3LAssMMhNNFwBCG7kwdZmi998Yzk38LUDxWb5S1
	cniGVYapSw1SUzBRtZJCCwxo5XflzZLu6TbV0pkgPks6gbcSXPWDAA4xFNE1d9zEOZ6f5u
	oFFXE8DdIv5ECVmc20aY+4nYXQd05lg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=MZ2ex4w9;
	spf=pass (imf22.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.193.58.168 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834312; a=rsa-sha256;
	cv=none;
	b=MXKsEsgHcaAgL8gW74v8ULt9npjrwOWKGb4OC1AfrPxbb5KUpFT0FA1spAhlwfZEbi3GZF
	M1ipH/TntfHJrb1kyuIrVW5i42oQGnnvi5WvdCzhhqDGMCqJ3c8xTQA5jUMMpd08yad/Vn
	aXgVR+RTAZAeRFG7mHEE6qMNo4YLMDE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834312; x=1807370312;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wjP/j8AJgPbtZq1XgPne0gPzghOZdblPBwP2xhZse4E=;
  b=MZ2ex4w9PVBt9vwXJXO7rqKusmhqVZ/d7x3X63reaDGWGzHibqeqhc8i
   mbxm9wiC/N4Y9sKq1sTbCOOaMti/btZkp+qB0Wk50lxExsq0tFgxKN39K
   yztx05/RlgeRWvDWtoojixubGIH96z/KR4eyJ4mDKE+XT9muLs3nIMaPi
   PCuksJxQaS1115P0uMDqJPAA88PqPi4UBZ9GAYr/CUQewdkhXVfVtv/te
   RD+Vr5YhuUMEWIyXmP+sXOtQrLIH/jfsIhC3S1EfjhhDGjviaE1fT4Dhb
   MF4qo+0aImVOaOsoScM7+fu33Glxp3CNH7FFci30mpj7f68cXUa7nY0uA
   Q==;
X-CSE-ConnectionGUID: pgHA7Q/vSB6ui62eJSHjYA==
X-CSE-MsgGUID: ocAl+iY7TA2wuReKD5Ta6w==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15816372"
Received: from ip-10-4-7-229.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.7.229])
  by internal-iad-out-008.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:18:31 +0000
Received: from EX19MTAUEB002.ant.amazon.com [72.21.198.67:12659]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.46.155:2525] with esmtp (Farcaster)
 id 84389257-d52f-41af-8219-0534a3422f4b; Fri, 10 Apr 2026 15:18:31 +0000 (UTC)
X-Farcaster-Flow-ID: 84389257-d52f-41af-8219-0534a3422f4b
Received: from EX19D027UEC004.ant.amazon.com (10.252.137.178) by
 EX19MTAUEB002.ant.amazon.com (10.252.135.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:31 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC004.ant.amazon.com (10.252.137.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:30 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:18:30 +0000
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
	<loongarch@lists.linux.dev>, "linux-pm@vger.kernel.org"
	<linux-pm@vger.kernel.org>
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
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"vbabka@kernel.org" <vbabka@kernel.org>, "rppt@kernel.org" <rppt@kernel.org>,
	"surenb@google.com" <surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "andrii@kernel.org" <andrii@kernel.org>,
	"martin.lau@linux.dev" <martin.lau@linux.dev>, "eddyz87@gmail.com"
	<eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"skhan@linuxfoundation.org" <skhan@linuxfoundation.org>, "riel@surriel.com"
	<riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "ackerleytng@google.com" <ackerleytng@google.com>,
	"yosry@kernel.org" <yosry@kernel.org>, "ajones@ventanamicro.com"
	<ajones@ventanamicro.com>, "maobibo@loongson.cn" <maobibo@loongson.cn>,
	"tabba@google.com" <tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
	<mlevitsk@redhat.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>, "agordeev@linux.ibm.com"
	<agordeev@linux.ibm.com>, "alex@ghiti.fr" <alex@ghiti.fr>,
	"aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>, "borntraeger@linux.ibm.com"
	<borntraeger@linux.ibm.com>, "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
	"baolu.lu@linux.intel.com" <baolu.lu@linux.intel.com>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "palmer@dabbelt.com"
	<palmer@dabbelt.com>, "pjw@kernel.org" <pjw@kernel.org>,
	"shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
	"svens@linux.ibm.com" <svens@linux.ibm.com>, "thuth@redhat.com"
	<thuth@redhat.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "urezki@gmail.com" <urezki@gmail.com>,
	"zhengqi.arch@bytedance.com" <zhengqi.arch@bytedance.com>,
	"gerald.schaefer@linux.ibm.com" <gerald.schaefer@linux.ibm.com>,
	"jiayuan.chen@shopee.com" <jiayuan.chen@shopee.com>, "lenb@kernel.org"
	<lenb@kernel.org>, "pavel@kernel.org" <pavel@kernel.org>, "rafael@kernel.org"
	<rafael@kernel.org>, "yangyicong@hisilicon.com" <yangyicong@hisilicon.com>,
	"vannapurve@google.com" <vannapurve@google.com>, "jackmanb@google.com"
	<jackmanb@google.com>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri, Takahiro"
	<itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>, "Kalyazin,
 Nikita" <kalyazin@amazon.co.uk>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v12 04/16] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Topic: [PATCH v12 04/16] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Index: AQHcyP1JW+htqwjvM0iCi2ukTUvS0A==
Date: Fri, 10 Apr 2026 15:18:30 +0000
Message-ID: <20260410151746.61150-5-kalyazin@amazon.com>
References: <20260410151746.61150-1-kalyazin@amazon.com>
In-Reply-To: <20260410151746.61150-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: BE7F2C000D
X-Stat-Signature: 5ksqz964f7b3pe6quqxpphyhkow7fgwj
X-Rspamd-Server: rspam06
X-HE-Tag: 1775834312-904819
X-HE-Meta: U2FsdGVkX1+66UUas9kuTPM4VzTWK+60Mh3qaQz2EQDEOLDhQh/yLqZzmjEQSkoJ61Bhx76Pr4vT9+ZDL+6bPwuAPk5B7QmdUYQ1ThzK/KSeX6+a4feBoPt3siIa8DYTfw6ZAc2ikn2xx1CXtIUlYDfpy4od8QnDQ31p0GC+stchXfiGorTfdcsa9oZmZapjUvUT96yaXYJ2T2c6/1vh8gepa9J4EW6ssG+61MHMgYuHLf4jnstaBOEJAC2N55PunXu0zpeuxLtghrsKRQMxEaFkdieT53iTObmT9VgSEe1k3yIsw8gfEKZ8pA9QVbEz/eDgk76DKa/vhdN/izwW+r50EnA0iobW7Z35Wx5KSF/AiMc/ptwDW+ZDr51L0DL+fLYhhDOcJ9qNybbDvQ5d+B60sRFlvUPRQ+vOpuzIxQKaJKvgN8Bvku2DEng6RgJOk07r0ZGXpIB3lU3nbyDDXsFAarBWaa1fTXnuTIYyrIsUHdU4HDsWFAUtMJZAQ0UCfjELl5pL7Fim0EIaStQzt3aNI5HErK62HRynRcqNXyQ8O8LQYyE2YdIFVtCOBeTjL0Gn0OmmaX70pZMAsypCom+uvOMS6EIJ7YAUBKSvhy1CiJ37jGoYp2j7rM9s7AQCJm8gSvesin7uenjBO+M93hEL+RpRaINqGZlaMSo1kNbpjTGjW+fEQzFmM/4GfIqosVBMuPoBzN2X22KG9Q1EdNelsWpp6ECEXYHyRs9B27+axpcgIGyxIV/Aufgwe+ssJxHe5uzKRwkL/EDLFB8/Rge+vIF2ZWKFTwa6FVaw6ozH6n6polCN462L+tiEnJYsvY4IpoLr/5y8T2bwYbCNmqZ3Yz8s+wJGvSRfpdik4zukuc/8OrEDh/f42Nhsw8qN7pKPdaMf6g09lRd0jTVtUOEsGKWCltuZdt9jRBFmCgtvjJBaEJILkzqFgd6zcMajXH5fOtDaVWDCkT9UWZM
 heicleBm
 FbSqzOvkuKrqnffYDTZGcL3PzMIsXaUpio5GXTBbtrcWKLba2BvnfH6ilqTpswVd9kxBPECEx/evI6RGNyrRxDcwJDIRTue/aSX9SgWfIhgp/oaoqMXzSX0ej+Mvnjea78GFukedSKxhvqpa2B4ZJbKMWTu3BIPSDh99ojaTatwbG1OX2cXyLlulpD/dXMsqiK0WD9kZW3TpwVPxQrZx54+b2GSaQuXWeePeL++UcgHAzjm9dFqVp5ikvIgAj88FQsXmAT9iXBHyuc15cg4qOnechuUyp6+8akoAgo6GGOD9VK95opGSib1E48CAWYvcOzI9anQk/k7lqqaQCORYsUV6d2Mut9kzzsOVEuslRut4fUtpsbJcoMTMC6RS91pU2ZBTk5DjYDjVg5Xq38ulfWv4mPd6CWlLoykgwo6iQuZjrrbDxBBSfJpfEus6gLQajJ6jSo20ZzxRupca7WAZPvIzgwrmXKKIj/DeAWbgTUQ74DUAqeqGPQTMc6WlGV0JBZ5+RsMtmM1J0JMjzr2yOMOWmICjXQw8PuQkeuMgiHmH0JumfZYbnsLIEuJRbb9sLqbkDFx/r6tCB6xHRmpjVL9BNSaYjHnq+AibYx3Xb3/NMfP5VC5ywL41MZU+pSfeBKJ4gvlY7eCxywLXc5/DFbQG/vpgYxBq65wqEki4d2Ti68HlC5oMFIubGRJ6MBEPqRAcbnnUPjHrQdRZ70TWvD6qq+e1YY0CRtfXmaSQyB+phCeojIdbzjQV7ALM4QUtkscxtn8dyB8y8JV/KnNhWppY1ywsPuRph4r11cCnpUJym4vY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
This drops an optimization in gup_fast_folio_allowed() where=0A=
secretmem_mapping() was only called if CONFIG_SECRETMEM=3Dy. secretmem is=
=0A=
enabled by default since commit b758fe6df50d ("mm/secretmem: make it on=0A=
by default"), so the secretmem check did not actually end up elided in=0A=
most cases anymore anyway.=0A=
=0A=
To make sure the fast path for ZONE_DEVICE pages (like Device DAX and=0A=
PCI P2PDMA) is still allowed, check for folio_is_zone_device() if=0A=
mapping is NULL.=0A=
=0A=
This is in preparation of the generalization of handling mappings where=0A=
direct map entries of folios are set to not present.  Currently,=0A=
mappings that match this description are secretmem mappings=0A=
(memfd_secret()).  Later, some guest_memfd configurations will also fall=0A=
into this category.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Acked-by: Vlastimil Babka <vbabka@suse.cz>=0A=
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>=0A=
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
---=0A=
 mm/gup.c | 17 ++++++-----------=0A=
 1 file changed, 6 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index 8e7dc2c6ee73..e8367564d636 100644=0A=
--- a/mm/gup.c=0A=
+++ b/mm/gup.c=0A=
@@ -2739,7 +2739,6 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 {=0A=
 	bool reject_file_backed =3D false;=0A=
 	struct address_space *mapping;=0A=
-	bool check_secretmem =3D false;=0A=
 	unsigned long mapping_flags;=0A=
 =0A=
 	/*=0A=
@@ -2751,14 +2750,6 @@ static bool gup_fast_folio_allowed(struct folio *fol=
io, unsigned int flags)=0A=
 		reject_file_backed =3D true;=0A=
 =0A=
 	/* We hold a folio reference, so we can safely access folio fields. */=0A=
-=0A=
-	/* secretmem folios are always order-0 folios. */=0A=
-	if (IS_ENABLED(CONFIG_SECRETMEM) && !folio_test_large(folio))=0A=
-		check_secretmem =3D true;=0A=
-=0A=
-	if (!reject_file_backed && !check_secretmem)=0A=
-		return true;=0A=
-=0A=
 	if (WARN_ON_ONCE(folio_test_slab(folio)))=0A=
 		return false;=0A=
 =0A=
@@ -2787,9 +2778,13 @@ static bool gup_fast_folio_allowed(struct folio *fol=
io, unsigned int flags)=0A=
 	 * The mapping may have been truncated, in any case we cannot determine=
=0A=
 	 * if this mapping is safe - fall back to slow path to determine how to=
=0A=
 	 * proceed.=0A=
+	 *=0A=
+	 * ZONE_DEVICE folios (e.g. Device DAX, PCI P2PDMA) may legitimately=0A=
+	 * have a NULL mapping. They are never secretmem/no-direct-map folios,=0A=
+	 * so let them through.=0A=
 	 */=0A=
 	if (!mapping)=0A=
-		return false;=0A=
+		return folio_is_zone_device(folio);=0A=
 =0A=
 	/* Anonymous folios pose no problem. */=0A=
 	mapping_flags =3D (unsigned long)mapping & FOLIO_MAPPING_FLAGS;=0A=
@@ -2800,7 +2795,7 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 	 * At this point, we know the mapping is non-null and points to an=0A=
 	 * address_space object.=0A=
 	 */=0A=
-	if (check_secretmem && secretmem_mapping(mapping))=0A=
+	if (secretmem_mapping(mapping))=0A=
 		return false;=0A=
 	/* The only remaining allowed file system is shmem. */=0A=
 	return !reject_file_backed || shmem_mapping(mapping);=0A=
-- =0A=
2.50.1=0A=
=0A=

