Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 358A2D19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:47:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EE136B008C; Mon, 26 Jan 2026 11:47:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A5226B0092; Mon, 26 Jan 2026 11:47:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87CDA6B0093; Mon, 26 Jan 2026 11:47:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 795376B008C
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:47:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 29AD31B062E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:27 +0000 (UTC)
X-FDA: 84374695734.20.A2EAFBE
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf20.hostedemail.com (Postfix) with ESMTP id A53181C0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=m9U24gxE;
	spf=pass (imf20.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446045;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4FHpHY6AJ0hg5Jwwtw1W2IN5LouOY5p8WzE+ejVhd1U=;
	b=SHzvXE9TK2nNG4paa4VthokMXh+meyiemTB2EdZoNmTYlxj2jF4F6okNUZHkDEgfiAqDx5
	nyTriXF2qSeldGJyMUmVFCQvvKEqOCanTOXZ3Mm0j9gfVshq2KKUXBo0iSsMnLn9yrkov6
	1CdI3s2SgqRRQhhSUpO8LSrFPTgt6nk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=m9U24gxE;
	spf=pass (imf20.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446045; a=rsa-sha256;
	cv=none;
	b=LCF8w5X9XtJVTQWPDJ61bASnKZiTw+bQBV/IzON7hL9pJgIyqZHJS2frVc97ZumCWvikCG
	yoccPeEHCD/cn40n29u3FkQzoVYuFyvJpZUJ1dpP1V9JVVrJ9Ch8T24X0RoA5Q+o33W1cH
	N+HxsdAN+uTYI8Ul8eRruSfDHy5jtm4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446044; x=1800982044;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=4FHpHY6AJ0hg5Jwwtw1W2IN5LouOY5p8WzE+ejVhd1U=;
  b=m9U24gxEI6cF9Iu4+w40mJW8ePWnGuPa7PYSofx7zASMZbfVX0NmgMr0
   1lchlvbrieYVKa1PZeEFBeV5djmk3zU3ZR7MY4tXLiwP8NegHnS8JZa+n
   yoCFr9xExF0olQs5bBz9exSVmCdRMVhsQkAe+v/baAqFGOhNPy1jMYv+M
   TM4t/duj5Na86wnx+kT0F3M3aLgRCmHC2l4hPNYPxauQtOyoy79UssqDV
   yJC24fd2GZxZHbx9fn6YxlY1qWCmkJ52O1A4BgdYsMMGImdOBCWF3xqZ2
   zDiDLiraiKg4MJj5jDWyPpu/0YyogiQp9WSHgN5LiJcjYyJgI9s1gE52/
   Q==;
X-CSE-ConnectionGUID: DMzACF5LSsKESVxEYLrHgw==
X-CSE-MsgGUID: 3HCBPdKjQdySNhZmk4v6Lw==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8453218"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:47:24 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:7851]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.23.198:2525] with esmtp (Farcaster)
 id 08284e5c-c7d3-4f42-97a9-df05ddd14a97; Mon, 26 Jan 2026 16:47:23 +0000 (UTC)
X-Farcaster-Flow-ID: 08284e5c-c7d3-4f42-97a9-df05ddd14a97
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:23 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:23 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:47:23 +0000
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
Subject: [PATCH v10 03/15] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Topic: [PATCH v10 03/15] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Index: AQHcjuNxPEuJ1xEMVkO51n3oGxbE+g==
Date: Mon, 26 Jan 2026 16:47:22 +0000
Message-ID: <20260126164445.11867-4-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam11
X-Stat-Signature: txac7rqymgfyhyiawsym6mg3ojxk9fpo
X-Rspam-User: 
X-Rspamd-Queue-Id: A53181C0005
X-HE-Tag: 1769446044-411650
X-HE-Meta: U2FsdGVkX1/itSTiOc/ZQWVbBUQQ1hEupM4QTOk8rAgpHz9DlUvGfqfvKssx0TF9f6MYuwuOSmLXqdUJLT7T9BpYs4JzrUFdZe7ZdiLdfzSr19P6OoMTXW0tZ53vGZKvlyjuvz+ONVXmynUDGiBUqLnxy4o4mik5eKLKJjiSn11R/Vd3Ism7qxvNsDKJ8lBiNiBvxV7fEHmvRmyIqS9MHAxSWtrKiX/NUK7N9Q/dKGf6HjDVdoVvTHFJ6sYz9ZD5UljfNpqKa8QMuSdl7ME3ujbGxewUsXZMFAn/HRUJvb9M8HJZ1GKrOTaMAe4d8urSX2j/z37ZgyPBFGQiHUp6kJ36NqG9ffh3huxPm35z2taO68idchhu4T/nmJCNZBP1RMh+LDqUYyK2U5WK/QN9Hy4mphbXMk0TmzPwLy9DFYFFYg2igkQr6UedPnv2faIuoWIdlStVOduGN2j38qJ6mGGCjiuUkKmv+ez5d75gPtGPh3k/8FtlyRM7iHOIDAQt5i3UsHzL3knD3+9Teing6wnWUMH+AEszVw6hUOcLA+AdXWkJEPatgzAos55dHny2xZlTNYmWc47zGb8dInREIq1VPMyWyT7t5/FLxDV22riyX06u6zzlO+V0Ubp1Jf0WD52lKVMgR8em6LcG9Rt2f1GjLjSWe+MdGV9n1mdxwUm/p/6J8p2w3rayGQP6RnP2BQTubsNDkFJqjDJ5y5qp3ju5zvr/DYXC0hCqA4OvnrPotgrPI/w6Fl2fuYNr3QJDWrd/aFdUBkA2hZAZYf9nxIu04A11xQQeb0Jpr/K5xtMGeCdE5T6T2hq+T0YdVoer/wzpqD05gXKKHp+wZuavbZU98NPsG0aPRCpb11k4a8CoQWNJCY2M7qxa8ZDzPG3cu8FFNFbSz4OhuQavN7b3vBfjbmYVlGnE8w8BnSYXxvlvGK4C1XsrwASao21Eln6CQQen1i9AeXQOExBO6zQ
 62oNMXMc
 AOLnWcJlC+y2KA0S5hQ/8KXrGgSbrBWZuZu7NRBLzskh2VsCw44IbHT8Z/RCxU8RKQo+Kru8N1P1TX/Qh6PIp0Ivb5jjSWD4njmLEwx6cPOon9e7gDTumYOSPI2cBketIyfsgz7/HOhCGI3Esh8qt14A2ORpjtPNiqQ2l+y0A+4AdV4B21S54TBN3k4G5c5X+LasE+tJXERnY8oOVciObe6ty5LO9jpyTOdyOxUS5t59IJ1K1j4+pMDuaKRwzN9er865jiWbznTqlwqpLbWEHXKj9owSo/kWerBHkQDaQ3wxuonYL9rBXsDCa/LQvqzj8ehPculpShkKdKkH5zjGyrTjpPqmfOaEzh6McX9BZEAVB0UoKgODMPMnvGurGpn3kb+VzzlT4y9OyF4ACIBceN62AyoBR40zZf+rX/jpgdqTEwOiS6dzLNotpBXdhDxjItJhMiSoGdknd4eT826B8tSDOmrlwGqaBdeKQD1yIfP09pmYkta+b9EHNtb66zJJHNcaKFvXIjTsaOEtea+/khPrwknsllhpQl4pSkWHTXejVqq2r9xx33zxeeNEJxAHm5hK0oLKA9yTv8E/EPbVDiv0UT25g0drW1alOsTpXH7ROxR/8hZgoPNbWd3VmJszRBGeUF4ulATvS/heR9yVUiy3g/zby9kHUGoyJXgwCNKzpe8FZ3H06lW7g5XUOgJkDRi8BFRwmxeKnAgl+TJqEPLMoOOtkHebfnpbC0VRzWYJSIfAd6YZSIZz30g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
This is in preparation of the generalization of handling mappings where=0A=
direct map entries of folios are set to not present.  Currently,=0A=
mappings that match this description are secretmem mappings=0A=
(memfd_secret()).  Later, some guest_memfd configurations will also fall=0A=
into this category.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Acked-by: Vlastimil Babka <vbabka@suse.cz>=0A=
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 mm/gup.c | 11 +----------=0A=
 1 file changed, 1 insertion(+), 10 deletions(-)=0A=
=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index 95d948c8e86c..9cad53acbc99 100644=0A=
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
@@ -2800,7 +2791,7 @@ static bool gup_fast_folio_allowed(struct folio *foli=
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

