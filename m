Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFC9FD877B
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:11:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965186B0095; Tue, 17 Mar 2026 10:11:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D586B0096; Tue, 17 Mar 2026 10:11:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82C056B0098; Tue, 17 Mar 2026 10:11:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 750336B0095
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:11:27 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 114031C16D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:27 +0000 (UTC)
X-FDA: 84555742614.19.266FDB5
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf25.hostedemail.com (Postfix) with ESMTP id 72232A0019
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:24 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=IBbFxnxX;
	spf=pass (imf25.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756684;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QH/0pY+L5Mnx+GXH9O+3FVFXbnxf+J6Zf5bgE/TnHq0=;
	b=Wk0u5tN/wR7cVSOTpT9ahGgE56oKcZxHN3sfD6X5d+ltKKw1JMBr2lKD2EFupPsM1Cmyno
	3ytwJzT9VVqWS8RkzbFmCyDQmyN6AUj5CyrPSic2+0ZzeUi8uVfnkgwGp9Fjfp07Zuu1cn
	9PLnxNLloGAI5ADQdsyn+dEtCAku3IM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=IBbFxnxX;
	spf=pass (imf25.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756684; a=rsa-sha256;
	cv=none;
	b=YsYedc1cLoLrZ+U4/AJlJjpQdCCYsJROCShJ9gHn+cGmypBUd8RI+TXfUTesEHeSRn0Zeg
	BfYqgN5ASqdbJgXi5lbKB6/khTpxuFZL0vYaMle2lo+TtNaYe88hzFUT7WOlN1BE5WdfSP
	5r52MDG7FHTHT/b3y+JokiJFmgmsb7Y=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756684; x=1805292684;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=QH/0pY+L5Mnx+GXH9O+3FVFXbnxf+J6Zf5bgE/TnHq0=;
  b=IBbFxnxXaOMpt4G+TYoY/pbcYqEncVSInOIuXZ8hpqR41Is06pFF0f45
   sOhw1y3oboIcb9Kb2s6SQufuAYeIOEsOEaK6H7/G5UP20gfSpKC87oeJp
   jX1azaxsjDvwaqEMrOYldxiBpPhtwVDDXqjS93rCMboIK0WMYbiw4udLM
   ESuhK6udPleKqdvyM096m5ycE4Ijhcos4BH8DwQ4+TmIqLtmVTvom9Jzy
   OZzN3hnOyBVom2cweZBzOPxgbQMXviN3rtXMlc+yLsqAZfDouRzJcEhUs
   pqp5buX79FawOlgc30aoJaqOqzJP9D3AcoiCvBUbxVVZt15FDr6wmgb+7
   w==;
X-CSE-ConnectionGUID: bjZm6s3/TCWdkXS4JpYsMA==
X-CSE-MsgGUID: Uv/u4CHeTxOSFi5l4I+Zag==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="11017718"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:11:20 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:28302]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.29.244:2525] with esmtp (Farcaster)
 id 2703a9d0-a65e-493e-aff8-54f3e9f5b406; Tue, 17 Mar 2026 14:11:20 +0000 (UTC)
X-Farcaster-Flow-ID: 2703a9d0-a65e-493e-aff8-54f3e9f5b406
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:19 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:19 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:11:19 +0000
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
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "yosry@kernel.org"
	<yosry@kernel.org>, "ajones@ventanamicro.com" <ajones@ventanamicro.com>,
	"maobibo@loongson.cn" <maobibo@loongson.cn>, "tabba@google.com"
	<tabba@google.com>, "prsampat@amd.com" <prsampat@amd.com>,
	"wu.fei9@sanechips.com.cn" <wu.fei9@sanechips.com.cn>, "mlevitsk@redhat.com"
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
	"Manwaring, Derek" <derekmn@amazon.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, Vlastimil Babka <vbabka@suse.cz>
Subject: [PATCH v11 04/16] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Topic: [PATCH v11 04/16] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Index: AQHcthfsUhUKrmwTXkGd7H9F3DgqvA==
Date: Tue, 17 Mar 2026 14:11:18 +0000
Message-ID: <20260317141031.514-5-kalyazin@amazon.com>
References: <20260317141031.514-1-kalyazin@amazon.com>
In-Reply-To: <20260317141031.514-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 72232A0019
X-Stat-Signature: e8pccsgap8wepcw3gw7jf4s9xwmkthtf
X-Rspam-User: 
X-HE-Tag: 1773756684-296176
X-HE-Meta: U2FsdGVkX18ZHTspwtDwOQaj7oM5IveDRAAZBgC9Y9V0G5W+qeIIzPs4SiqGfw5LBNNriyORDaodukqQt/nMh3uK0A8MzEeS85o05FAtYvoQyRgmWESZeYDmFY4egGcY997fHxLa9hG0oOCneU0goUFthH8KvnS06VIodzo37Hnw5DnKu3JEbS/VOvCjHWq77scpj2ALPsQoO7l+TcNCRsOqXZHkXH/FoieqI7LSVZl/++I36lLF4v1VuE092Fh5Au4rzlWcdRvixJYwnmmCXq95QPY4kRymVhPzU0j9W3TGJH98NzfGzY70gXiUUo28VQ7Vrw7eJhnf9iog8DOulJxZ6J8ZIx+SirzjR5GEzZAHQP+KKjWc8jEaLU6yinJUsCI17n2hDoGcJCf6yP/Khp0dxjzD+/rWkDJ3txkS9k38F55PiSJezCi+5vBxqw1Ic3MJ/Tc5jzD3t49w/BGRyKsLBMmHcDHyvsDgD94mstyKhwfEi8iacA0COFyCAztMJSFN8llq0rQOsFxxnjtwWHXO3+LtDH0Y0J2C8GvGrA197V6DqrLuk9Km9OqbNIyFEMC8N5qVQ8yybCVCambtHxHzYtJnUUCOB2NK3uHGAa56lBi7yy83aZ3BmqAEi/yXzjsRJMFa4NC1vmIjVd5GEGkXyQVkkif86iRFFcF3PrrbK7Ij7TKZcbGxvX60pGSdqrFXzQz6Z9Qa4+zsocBz27tLF+3R9tR37UmBUr7osr4Yz2POlHheELL0zGkj5jJnXYBTr/Jix6swwDDJlEyQD1URz19X9xmM9eFfCUHo0wynniLZYs17jATflT/0YYJmHGRTHRh4O50AmRlLXvXivCGzvP3gc0fAo8uFyljcDpOAYk3NlgTY8d8SKSRDKatuRYqqGzbRg0BprTDLDcWOX0LpvAgot2/db6uUAgIb2N+4qj9ej2wxBHdxTUyGBYzCi8SQpgJT+vXbpvdfi/y
 IFGvdzar
 MS6KeV3QitwTMMCVvkaIXGM9a+HIk5DgjhEMGBG9sA430HxlGGmcbl9h4ob68FQZfE0MOsA4dhmTz/fGJdHRPKF5D3+QTxEs0DQV1O/dGb2RTDNnNBkHB20FbLD0vz2YT20vguQAMfxIHuvBxOnjZtIizY6A3Mq07WMaXzJIncdFY585SMWcKRxXStSHYLWDLNrjavj6PYpKOl06mqKWqlU1CDAr5pkZJ80saiDiPqzyzI0ydpSMY3r8zyqqHmFqH2R9yEvDwEjs85yKq9KVr4a41DJ+Rs4f3skacQ0kqgK78Y39MPTix/gIetvHl2Z/HtSXp34bXUtSTuJ6vtvARvah1MM0riP3xlFiaEou1YgC8QKc9JWnQsBStF055QPD2fbUpJkgAJy5rX8xYkduuZfZup6KEUTeOduFHM7aY9OiOYMGoexqxbGNc1bopX5TjL0dyqRJqwm6/mbp8vtdUJeR99iXr4YAE3Newola09ZXi8u823OAmQBH+VRlTXZ8/0tJ2iHYYo5eSQeDl2+OLUynS6KtMuZC3rtU1FBzV+S2FUHWIkQHGruvpM86iGgnd4MEmd3wY1ILLcHje3p9eDnObK4QJWT52fv1DFSoHNdYmIW3R1qHIemQ6mKa+ZeqVpOQLOvfMup3apzFrZb99N65x4BkSL1uvjos+VEagiax1NTpkbh+RpsdpUCJqpOYZbHclQzhpR6jnnOp1pyaq6vGrcXxJ+mB1K9WqVFdymH7DuXqd47mYNNS0plYtegB6X7El
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
index 8e7dc2c6ee73..5856d35be385 100644=0A=
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

