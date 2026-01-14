Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADCDCD37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0336C6B0099; Wed, 14 Jan 2026 08:46:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 014256B009D; Wed, 14 Jan 2026 08:46:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E20F86B009E; Wed, 14 Jan 2026 08:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D35F16B0099
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:46:00 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7352E8BE07
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:00 +0000 (UTC)
X-FDA: 84330692880.01.4A654C6
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf23.hostedemail.com (Postfix) with ESMTP id CA047140007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:45:57 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=fPlduSqZ;
	spf=pass (imf23.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s3g/BhJoffjBll6+LAykcl+3VxzHbXMRload35szxP0=;
	b=IlFyEPwKF5H0ANFcI/zwZ1I/M/mBlWSnl9H6EDCKKGwSkeEr7Cd9X/Sh1YaCCKAjBf3lnQ
	e4vu1iDR9QIP2MDLfmgjab5AxYb1544qcNPhhgi+Qcah0s7/GUsKSxt5Fuk04E39HxqpZI
	S13kD2fwes1nR5gvSj/Wzez16D/8ZQw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=fPlduSqZ;
	spf=pass (imf23.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398358; a=rsa-sha256;
	cv=none;
	b=AfKqXnPzRIVckMGAM/OahHghXdkV4wlQSqWwolkqG0JwUsThe1txZT9viaEEu3makal2E4
	nYvwozrVByAHcY5fgBwfhi9x8DLLzxOgxdo921fJBK1cvpEPkLLDRnBFJ3LBfD95BQBQsp
	Xe4lrHnK56722yBPQLX+jfomEOvyBX4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398357; x=1799934357;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s3g/BhJoffjBll6+LAykcl+3VxzHbXMRload35szxP0=;
  b=fPlduSqZ/f73B8LWAA2ZtXmh1Nbj9g7mI50f0hnbKSRZBo+aYEzqmzXz
   UpJeC7kfb65E0C5bG7fkSWxKU8tCz/6+zze8T3dt6iOXri3LUlLkMHY0W
   HkujN47+Hx6VsN7Tzod6MhbHXxhODR8504yqxQqhC9MZxgcEfGeNai/Qu
   SMEAu4hboOiQa6jBRZgFjBQPY4LX28jdhjBN+RXgxMDdEV7FFMO/Z8CWG
   cRbrldBHxTL6muyow82/zkBmB4aYj8GADLdr+9NR7wkZr9VwK2Iz+HVrO
   5O8ZppXfyPQ5Yy9iDKLbStBLd/5BgY27BObCgJRrynnLsP6TuZRsYrTb2
   A==;
X-CSE-ConnectionGUID: 5ad1dBhRT8y+vW+Jvuxn1Q==
X-CSE-MsgGUID: H2NoQRaNSbiw6D3O58r8Lw==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7792774"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:45:38 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:22656]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.3:2525] with esmtp (Farcaster)
 id 36ad4fac-fb8e-4058-8e33-3add72648e47; Wed, 14 Jan 2026 13:45:37 +0000 (UTC)
X-Farcaster-Flow-ID: 36ad4fac-fb8e-4058-8e33-3add72648e47
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:35 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:35 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:45:35 +0000
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
Subject: [PATCH v9 02/13] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Topic: [PATCH v9 02/13] mm/gup: drop secretmem optimization from
 gup_fast_folio_allowed
Thread-Index: AQHchVwPmIqi9oVtQkSM4KLPC6j+aA==
Date: Wed, 14 Jan 2026 13:45:35 +0000
Message-ID: <20260114134510.1835-3-kalyazin@amazon.com>
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
X-Stat-Signature: 7iyi7qjmst34bakmz9t7afspg7bgaemj
X-Rspam-User: 
X-Rspamd-Queue-Id: CA047140007
X-Rspamd-Server: rspam08
X-HE-Tag: 1768398357-2294
X-HE-Meta: U2FsdGVkX1/Iy2Anz6F8r7wFTKH5z2TpSNO6SOOWmHo3Xbn4Xn1dnQDh1svYJueTpIWPTz94z6ObRwGA8f/NT5cCNIHOSsrYGUaAsKM8u2Jkk3bvs2AXdQrZmWNcoBbf+ARWWXAoQGDzsos3/0f4vSQtmbERIe9sp2U5p5QOkiPGo0NVrp+pqQIfAwsw/x2/9lN6oj0Wyukc3+Lm+JfaHTnpCp2TDxp9rD7SpAFNrhyzVNc0oG6jNWyqHgOGii7A9PYrMeqI2OxGMMf5I9y8lnyKfY/dgHgktLFGh3EfmqkpWxOGKM5FkQXff7nAwD5ulqZUQu/vuh6evFB9PtmdZYMijp9Gz+4XsUM4xE2uUjhSwcDDvQrSq1NSqRBZ8BhI1oyQ6SmyUTrwKVpDQRzG7lfZwbzPbDqK4AqCyLFd42uZgO1C9HaehKwM7LYFYG5TlsOrRmOuOYyFrl5JGWfWYOElBDh/zL7CAfKKgVSuqZ6/cDL1fwIsCre2bB2FPR8dHNdheHdXohQ0sz9LnUB3n70lTouPSDr527fbjT1TrrrlR/cNmCOqVaicadJg3d7xiiSGF2HCMNMjkxRP8GcMQa2QA1Ge124bjZ6/i8J3SWmZYIPL51PoM8k1KJnk7d1HyWk90x+257CO+urNo/bJ3/hmOeQm/SNaVLc9+UNUMXmZwHt3bP0U8apk3czE2mG10OH6ccecHJByknqfQF1GYSyTfOwqxsksgUH7SEKgl/QK8939ZggUXA1CwaZMb4dCZ/yT0c7/qvsSJDpyzZFgQqc6dKVT1O+FrWcQkc6L5dj9GJN5iAT734oMGOP6/nCavBIBEBTgYRXLnDVCqLwDBFzig13KxViMYfG6HDw1RtMf/Cq67/l+OZLqnJrF5LzjTF0UGqiVTDcjcTZl/KRPTHvTtWUekXtn7T/1gbHKhXN2WbeO0UG6XTshZb5zRhoxyQfOZ53VKdRI5XYQ+ev
 bKmpzB1P
 tf1rmT9i5zo597/F0by1OK0hHpCuvHTEOP/1msxoDg/35UUc9J9VI3ZstLH5qZeUUd5CNnASeFLIz68cwoAPMl2UL+QfyrP2xzF/PKjCM76dS4bdEvQi+s3ayVBtMwxle7G65AgdpJ0+ldJbR0+aiceNLDTEfWVBcXT6fGnjiIYL7LWCjtQ28Pi9ER78DNlNQaQ9t23UPF69XrZ1kCbb9auZo5XdQXJ/crVQip5Glb9KKA7fD6M1ydY/ZUqgc1RgK7bNh4tgb1qWs5o72hizULFMCRUPm+v1w6mloOM5Or20trGxzPhraD3o02fY2Z/xImX5gZ3eHPwmdIs2f9GnrTKWghFrhL1qlrejVnas/ZDT3ohqO7Ta9sr/NvzO1MqKqepUCQJaNXGEumYvreH42S9J7q3nG/04WwvZ7yuXbEMLLi1AeG5gI3euXLEE7sbVAzM2UOiR8hl17CnCMJaH97IDnM447+RU7T4EfqRt6ARBc8o5jfVU/Zpuhhe+t4XzymobAFQZu2LtjsBBTvzrc8Ek0sJHnDBOf87oEfVbVjhCflezf1s5XECtPLri+QPsB+mQIPjlwqPxXEipem+N/R44JM4y0J6Khb0ZP4ex/OVtErGssi3bHF6ZFOuTMj1euRqpkVxBHtJs9B2+ab2jKiwCTHhKfDDMvAQTqcYd/qhUrq2X7DOpv/fx66dOdmruY7FNA554lyioMPWNBNrL3yjBlU/V5hFOqybnVHjJSE5lGymvH2xjTi8IRZ2PcPJmPIjpxaCUxKJQ/96g=
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

