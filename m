Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C9FBF459EE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 014B66B009F; Fri, 10 Apr 2026 11:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE08E6B00A1; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8396B00A2; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C83EA6B009F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:18:48 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 69CF216043D
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:48 +0000 (UTC)
X-FDA: 84643003536.18.631F3DB
Received: from iad-out-012.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-012.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.197.10.50])
	by imf28.hostedemail.com (Postfix) with ESMTP id 2C16DC000A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=tSZeKLZM;
	spf=pass (imf28.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.197.10.50 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rramw02zFfaQ/VTWivc4Tqh7KGk0PsNNXj8pjM5nD8=;
	b=OCw3FnjJTS+sR27bT7iyK4B73/flkGYt4O9toXMW4MzDsPEDmEhkQZ6A+4pcrxd+R98/Di
	hmi7Fvj5UZA+J3odJ8x/vJSirks5ej+ShJ4KQ/XIBT9UfqS8pr84IqbyRUbfagxmo8xd9C
	/TZkqgrKqI4fMafB22XfeXLbbF1rG5c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=tSZeKLZM;
	spf=pass (imf28.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.197.10.50 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834326; a=rsa-sha256;
	cv=none;
	b=qHKvjvO9dQqjCXE51ourVpce+h94ndO79ENI9/tvZCv8PrCvkwLaXvFMBRapxwVWNkgSKm
	hHw2LdBCO1IEUTU+sAQBatnLEQ7qGwN0yJF8hGInuxPB2P4HSyqrBPNJI2vdTijz7fegK9
	jBPJvsILQ3iFK1auSPaJpm0UkxAk29U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834326; x=1807370326;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6rramw02zFfaQ/VTWivc4Tqh7KGk0PsNNXj8pjM5nD8=;
  b=tSZeKLZMawo9jtONrZErBPL6fWQFrmb5FrCZSfwzFxVdsCBXje9S213K
   b59kUpWjnc4JTfxDNqE3IzcIPRfjXIzWCcZk/5t9v2vVOUHZ/HavfHxfH
   QFzSPJMVricx12htMZXlcZq3w9ZCOUHjYPVmU4BHYOSuyKDFfD7iULLEz
   1CpjdJl71LOizFgh//1VVm7dFaZz/rdtdKTLU/tNy2MdNd+wS11rg09nx
   mwmm3HmKHA18HfQtlll0r7u8G8s2hZ1CoQJdcyD+5ev0lPm0/WLEu2dSu
   FxXS/m4e02X6fTrHcHA8trDrBjBvpYWaUpK9mZJ8Yg9kA2+y4K0rBT3BM
   g==;
X-CSE-ConnectionGUID: yToEaIXKRYmG7oPx4P8CLw==
X-CSE-MsgGUID: kwtkzB/GQkmjo48FL84lPw==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15710859"
Received: from ip-10-4-7-229.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.7.229])
  by internal-iad-out-012.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:18:42 +0000
Received: from EX19MTAUEC002.ant.amazon.com [72.21.198.66:30402]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.32.14:2525] with esmtp (Farcaster)
 id fba8fd5c-1716-4384-b576-8dedd695907e; Fri, 10 Apr 2026 15:18:42 +0000 (UTC)
X-Farcaster-Flow-ID: fba8fd5c-1716-4384-b576-8dedd695907e
Received: from EX19D027UEC002.ant.amazon.com (10.252.137.166) by
 EX19MTAUEC002.ant.amazon.com (10.252.135.253) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:42 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC002.ant.amazon.com (10.252.137.166) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:41 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:18:41 +0000
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
 Nikita" <kalyazin@amazon.co.uk>
Subject: [PATCH v12 05/16] mm/gup: drop local variable in
 gup_fast_folio_allowed
Thread-Topic: [PATCH v12 05/16] mm/gup: drop local variable in
 gup_fast_folio_allowed
Thread-Index: AQHcyP1QmbwBcUnJSEGr91ll3sDzdg==
Date: Fri, 10 Apr 2026 15:18:41 +0000
Message-ID: <20260410151746.61150-6-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: 2C16DC000A
X-Stat-Signature: kf79uup9y39hgokw7yemimssz8aaycny
X-Rspamd-Server: rspam06
X-HE-Tag: 1775834326-698692
X-HE-Meta: U2FsdGVkX18Bq6p1whYTwtq/EB4dLOugKNNUMG3zhE6vWcbcxpsYEingldk2dejXioOfF+B4V5f5UVrpcmb3cwi8/hFfyUwECgors8nfT2nWCEapA7CgEOybxkFkAcgzf10vaw2K5G8OWy+uEIKeVmUIKZmFVru3mRbpzG1jaVmKduRif90t3WI6vdOz7MjwjlctAj/yRshyOYdaHIfLHrEuKlLpr5lebtx++5Hu1fceFFxGoSjXOdPwUbbwxFZPKmI1cIbmzeRNIcakm+PcBlDuq8uqYjwvGH8ADKdHamHjNe3laln//NbJOQFl7hlpgCxvYMJoQQfmiyvdAiEW6MMy/BPvlJoGT216XLrTmljZ9cK3r5LLpewZN7S2amaHNcBjnDuPpAjENMSriOW48rPwmDR6ukGXozomUy5kM1InhcJbStvQRvHL28QDYWGy/4+yWS60ZiP+6tLtvR4tfXJxlYhzlGiv2c1aCk0meOUCFP6O1cnYN7RzGmOZFl5niW3z+JDocZuowrYI/Iuv+LHLUyNcnZGnF57OvfYHkkd9sdCPZLvncMFsQugcs9WMvh07rk0VU3SR5ytj/hgTOmp60S7syAI8hRJttBYz74FAtjAQUnzSv/B4rSWPFKdbB32Lb0fW5QOZ6nXrdJgb6wU4ZZnHp7neas0eUU1Kqno1wFGgfc2+zWpW/pOnawRyG+pcLgVNVp5PkJZnm/f4igTBSQKXMGSuyBhDMGvJuNzaE86EqaGsJjqfUFsIKqZ+2sZL53i0/njXU4DHOWYXrBIKWt47xz02SwSLCXwEUA//MBq3IwoVxJfSz+O58bmSvztqQeTPcp+zj3ky1iGK05yEK00Pie0KI9uqorsahGbENsG7I4G7fLH52zHHlgnqJZDjhJaqL3HXai3e9FLCSKNky5EaESfHDWQv8KOnsVGfCbBG1iGzd2DgUkIWcd1+VG6uaABvRFiSflui77Z
 9uO2dGmE
 b2dBMxGe1LM//o9aE3k8WOQ4Twlec4RipPN22Obx8HtNgZ/4VVkL0JdA4JO5Dqh0J48lnqg6/Fvt3MHLnu/QTWQVJm3d5Pkx1aNJwusN9tAtOzYQQwnlQw3vPsd0fjHfAnDrjwqOqxvrGgMwyPOl3x4GSnO1CRsvQviHOLk1QFumWLFNoQVpdm/ojiyAPOx9kJdRviyOw/SH/p6hy2ASjcbHfec9hazqZ6McVxWGxFBEkcfhec2XVkYg8DrH+OyIrtpHrmXcTt50Ce1KB6kxKjOhKSUEGaSKQeMnEMwCBOyTF5LjmyhPY/euKVqsIS37x2avlEMBHodvYmP5nu03A4n8YcWA1lUt2Hzt48AgapNPTVtzLxn7AXe/6itBzpB0ZIWOQfPdwysk0qnhxtd3kmCL4Ij0+d+yi70PbwWZWQvskDrN3YSh5BfMztGxO6M/lMPyo9iomgLpHRI1mJYiTeqhIgLyJusooNBdsCYujF+KZ6FIHg/h8wjES+hCnS6JU8/lwef+IftvyX00dGQOzfvAHfGfOxjMudfAVjVfxCFkTLS1NJFeZMMsLhcqwDxyUbLmm7OC1jkkWrP6olcJqNZxAmNd8ZThZsw5dX791PVo5STXLuTrRn3fFv4xF82WpDisSIDugti27m9a9qEMHkDYR6eeGlzobzjcZZcvdJLEnl6IQSVwdzny0rZ6Y3oNVw2SbA0qk8f4V8skID7Dy//wZfK9zqYEM0LVbZU+FGcdR05gJuNaoGI8JbOLRfLpc0cBxy5LIa1CbP8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
=0A=
Move the check for pinning closer to where the result is used.=0A=
No functional changes.=0A=
=0A=
Acked-by: David Hildenbrand (Arm) <david@kernel.org>=0A=
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
---=0A=
 mm/gup.c | 23 ++++++++++++-----------=0A=
 1 file changed, 12 insertions(+), 11 deletions(-)=0A=
=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index e8367564d636..41eb64783e03 100644=0A=
--- a/mm/gup.c=0A=
+++ b/mm/gup.c=0A=
@@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);=0A=
  */=0A=
 static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags=
)=0A=
 {=0A=
-	bool reject_file_backed =3D false;=0A=
 	struct address_space *mapping;=0A=
 	unsigned long mapping_flags;=0A=
 =0A=
-	/*=0A=
-	 * If we aren't pinning then no problematic write can occur. A long term=
=0A=
-	 * pin is the most egregious case so this is the one we disallow.=0A=
-	 */=0A=
-	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) =3D=3D=0A=
-	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))=0A=
-		reject_file_backed =3D true;=0A=
-=0A=
 	/* We hold a folio reference, so we can safely access folio fields. */=0A=
 	if (WARN_ON_ONCE(folio_test_slab(folio)))=0A=
 		return false;=0A=
@@ -2797,8 +2788,18 @@ static bool gup_fast_folio_allowed(struct folio *fol=
io, unsigned int flags)=0A=
 	 */=0A=
 	if (secretmem_mapping(mapping))=0A=
 		return false;=0A=
-	/* The only remaining allowed file system is shmem. */=0A=
-	return !reject_file_backed || shmem_mapping(mapping);=0A=
+=0A=
+	/*=0A=
+	 * If we aren't pinning then no problematic write can occur. A writable=
=0A=
+	 * long term pin is the most egregious case, so this is the one we=0A=
+	 * allow only for ...=0A=
+	 */=0A=
+	if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=3D=0A=
+	    (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))=0A=
+		return true;=0A=
+=0A=
+	/* ... hugetlb (which we allowed above already) and shared memory. */=0A=
+	return shmem_mapping(mapping);=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_ARCH_HAS_PTE_SPECIAL=0A=
-- =0A=
2.50.1=0A=
=0A=

