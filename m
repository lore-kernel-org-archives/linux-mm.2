Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA56FD8770
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 14:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 769C86B0093; Tue, 17 Mar 2026 10:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7411B6B0095; Tue, 17 Mar 2026 10:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62FAD6B0096; Tue, 17 Mar 2026 10:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 527486B0093
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 10:11:16 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D81A2140239
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:15 +0000 (UTC)
X-FDA: 84555742110.27.1186FD0
Received: from fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.57.120.243])
	by imf18.hostedemail.com (Postfix) with ESMTP id 576AF1C0004
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 14:11:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=hfGFt+LE;
	spf=pass (imf18.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773756673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=civgTW3KdVqRnNr9DLmAUo8biVlHbqHYSTZMRg7ipUE=;
	b=z9bRmMpG2zR0Fz6Uz549XC/s1cSH54IjYhjQRQ+KBwmQzDHlbQ4Nd581/99jw+VS0MhLwl
	FlD0CUqpw2fPv0/gO9GA7Ljc/eDQU6gGMFHUGolpolqOHU4y0Kx2sG+bWRZgQM8UMSDb3D
	NfHJ6nYDfJmcghUnowXAaYViGHjxm1U=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=hfGFt+LE;
	spf=pass (imf18.hostedemail.com: domain of "prvs=529a8c084=kalyazin@amazon.co.uk" designates 52.57.120.243 as permitted sender) smtp.mailfrom="prvs=529a8c084=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773756673; a=rsa-sha256;
	cv=none;
	b=Lzp4nUn5PTeVHjjBxUlaaGlZSp1xU9lYfiz0ua4fgNzsry9h5mQOboZlQGWk/e5XzE4JIk
	agWzQ0Rdg1hcUUxzn7Bjf3OMJaxNGgrDSA0vBNPORfkASQExue1y505h0b3o4170nlpdzY
	+8UgLCy8BWO1Em9OkusCCkb5AmRpt0I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1773756673; x=1805292673;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=civgTW3KdVqRnNr9DLmAUo8biVlHbqHYSTZMRg7ipUE=;
  b=hfGFt+LEWIAXzmPjjG28/ANiDgPsBJLxkAeR8leCTGxb1xwknPldalLi
   QtYktOXeUxxOMszifLzGPIQdITBc/Rx4Tb21DGt+cDq1sUXmlOHbBg6aR
   j71g5nvTMG2bJl7ojNTaNq83gAWhEZvrJYA4dMP2UD7f8AsHKyOsUxYZA
   HcnutF+eHvX1y/RznRHgvLo8lSi3/ENvieuWt/CPx1n+MehzXcuqkFQxA
   nnw8tkifMTraJcmRloIQzXKyIdYcY/UH74jlz3k0hEwKNXJB2AD85CtEF
   d2cx+88uQ9O7CtC4rm2edkPSYbe03BfEQ9+P8kR8s+05W3ldFPdjkNk4P
   A==;
X-CSE-ConnectionGUID: RwVI7fN2RW+jRHloYOdsvw==
X-CSE-MsgGUID: GzDBKQ3WRk2Fccj0YhCgLg==
X-IronPort-AV: E=Sophos;i="6.23,124,1770595200"; 
   d="scan'208";a="10908841"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-012.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2026 14:11:08 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.232:29351]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.44.64:2525] with esmtp (Farcaster)
 id 8e39f445-ebd5-4ce4-b99e-d390d1eee83e; Tue, 17 Mar 2026 14:11:08 +0000 (UTC)
X-Farcaster-Flow-ID: 8e39f445-ebd5-4ce4-b99e-d390d1eee83e
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:07 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Tue, 17 Mar 2026 14:11:07 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.037; Tue, 17 Mar 2026 14:11:07 +0000
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
	<kalyazin@amazon.co.uk>
Subject: [PATCH v11 03/16] mm/secretmem: make use of
 folio_{zap,restore}_direct_map
Thread-Topic: [PATCH v11 03/16] mm/secretmem: make use of
 folio_{zap,restore}_direct_map
Thread-Index: AQHcthflERb7zhsH1EWE6uTFRY4Wfg==
Date: Tue, 17 Mar 2026 14:11:07 +0000
Message-ID: <20260317141031.514-4-kalyazin@amazon.com>
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
X-Stat-Signature: 1desus4mgnq6rsc1d1whjcxmnwkdrgjc
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 576AF1C0004
X-HE-Tag: 1773756673-181085
X-HE-Meta: U2FsdGVkX1+NU/xM1BwtaY8rYWWwACeT7xzoujGC/gby+/gNHt1FAsZxcJC7BW9YGd7d1We8dYVU5KEyi7ulyk6TITOp0LluYcz/ObzfSsp417SVqPlndJncDnRqPpXS1UpOzYce9N/u3EH2oWA7wJA6MMExZr23NJub5vp5HLXnUqWXELoUCj5wTeTwlu/OXuOJKm4JKUMKz25aQ8g0VW628IYSvqRuLzX7k0lfLt1xXhxkmoz/vGjmyvHeuEAJ6d84DDMh1qVTfSKVc7W9AWCxEnGFtyRWaCHpu/37Rtl4XbcYuk1vJ07tbG33aBCbAUpS+16tpR6pvoeZOwH+k4cb6qUir7HLn4xPlpMtoAS4S5GFBbQ1uWGh2jrOaLZDhH2JQtOl5Or+u2i2WIWERXiRRKWdDfpQmvsEttmFbZyByfgxodhFxeNTbTjTo5B+guvZRCLqQ6kt2CrXePW2f2laEBORChk8PRU6uXYiXlesIAKQvERfh36Qj7pRv2CWM5ZnWXevVjwYrAdBOlxiq0Jzs0v15KOIP7Nsm9ZCKg8sjS5fc8U2TD7viPS8NmI/js+u400BiYBUtBBE81FIFWVIKNOjXQegEsiWsgzWZXx0qg3/Vx/jj6t1vqRXbxccFFW8oiCSJhgkE7G2VOym32Jfn7FHZPo4mS3GlZukzfuoyAFAuhNgyWIHlr97ktZCz+WBBtR+Llno/0KX7SERxefFxgfCRloOPgMvIr4dcFGCJECApS+D+U01ae18pMgFCOxl7xZu4gujW5/lNeBBNCFRnRRKP0+ADbVHvH8nsK/Un6d44TCkS2caj6cwfY0PT5u1OSpfo/pMuJEVlHUNbHE/QaIn9fW/nl7Vz0/NoZFtKgejtl4QaynJIBLJndIKY6JS8FDJh5RKLGVnbrikVCdsqfBukRVnD534nJwTkC/uuZC2fpSDgjC/ewNHad2CoPnePwHCYBqpYQvNXw8
 /ooXeig7
 lsFk4oSuxQsMSbbHW5afwbx1B5kiLMJjapuwqZKWIVajxH9vTpTnxDn0zwdgje9snRWt3uD5/h2kddYGmjX9wYURxlJ5QoKsI/utksekzDcHgQZ2uQaczaAh3CCww3rhmsbmfO8gw5BLIojypA0uMkcaj+hsUaywaGJ58nKDIrPWgluaQeJ7DM0F4ugDiJrkxl5/gd34kqilG42jH9k1mX3kf6qdRddObolzEof0LA+8BFZb1oSQ8e2XDyclUFr/+cZw9uUNEJtiQb/OTFlvwT5xY19GQ/LbMvcDSFXAsJZ2QfR3oqmbPslQ2P5Nokywh0D70hFLhk5vxjlKxxIRJX3mvGx5Gdc8BX3PvOS3cz2MZdBQlFiSCswkqogAQzh1GtCF46YEHGGXdpUcliIMMsdN1gMHLeGB3qD+FM9e+Dfev8ClD/OLHFM9xRUI3Q47qQCqWxfBrD14k5SN9Jwstqyd3l/SZasU1xxoqSd3SZGJuvnUjaHiJ7iEyYvvbljDqW8qEvtaiCdx0qyeAONoeyr7iJVFQe99u7x855zyURuCZnUAGHMWKdBL926JPm9M4JuryKjiNnBy/4Z/m5r89CJN79+n6znXAIQJiMmICWObahZtro7uRLHjqN/QmsE///y7+lRMDdsfyWnBz7zMTlkpp1tmazNhebGfK45OGQh1K5Zb7dBqcCVH9UBhlBLlKMk0bfeck3a+4t2Rg+of0LaNMzPa3cpqC6prvZkX7669JDX4OF3IullWsjElUo2P2kw/bZLhecA5nBRY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>=0A=
=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 mm/secretmem.c | 8 ++------=0A=
 1 file changed, 2 insertions(+), 6 deletions(-)=0A=
=0A=
diff --git a/mm/secretmem.c b/mm/secretmem.c=0A=
index fd29b33c6764..27b176af8fc4 100644=0A=
--- a/mm/secretmem.c=0A=
+++ b/mm/secretmem.c=0A=
@@ -53,7 +53,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)=
=0A=
 	struct inode *inode =3D file_inode(vmf->vma->vm_file);=0A=
 	pgoff_t offset =3D vmf->pgoff;=0A=
 	gfp_t gfp =3D vmf->gfp_mask;=0A=
-	unsigned long addr;=0A=
 	struct folio *folio;=0A=
 	vm_fault_t ret;=0A=
 	int err;=0A=
@@ -72,7 +71,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)=
=0A=
 			goto out;=0A=
 		}=0A=
 =0A=
-		err =3D set_direct_map_invalid_noflush(folio_address(folio));=0A=
+		err =3D folio_zap_direct_map(folio);=0A=
 		if (err) {=0A=
 			folio_put(folio);=0A=
 			ret =3D vmf_error(err);=0A=
@@ -87,7 +86,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)=
=0A=
 			 * already happened when we marked the page invalid=0A=
 			 * which guarantees that this call won't fail=0A=
 			 */=0A=
-			set_direct_map_default_noflush(folio_address(folio));=0A=
+			folio_restore_direct_map(folio);=0A=
 			folio_put(folio);=0A=
 			if (err =3D=3D -EEXIST)=0A=
 				goto retry;=0A=
@@ -95,9 +94,6 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)=
=0A=
 			ret =3D vmf_error(err);=0A=
 			goto out;=0A=
 		}=0A=
-=0A=
-		addr =3D (unsigned long)folio_address(folio);=0A=
-		flush_tlb_kernel_range(addr, addr + PAGE_SIZE);=0A=
 	}=0A=
 =0A=
 	vmf->page =3D folio_file_page(folio, vmf->pgoff);=0A=
-- =0A=
2.50.1=0A=
=0A=

