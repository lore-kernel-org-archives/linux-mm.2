Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC724F459EE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:18:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20F8D6B0095; Fri, 10 Apr 2026 11:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1106B0096; Fri, 10 Apr 2026 11:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 088976B0098; Fri, 10 Apr 2026 11:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECCF26B0095
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:18:24 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 946A5140429
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:24 +0000 (UTC)
X-FDA: 84643002528.22.9F75F86
Received: from iad-out-009.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-009.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.198.94.229])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4D8D71C000F
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=jkVYOm8b;
	spf=pass (imf20.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.94.229 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834302;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SXUxXoRrWTOvyOc+uAqr+1ZCvKnUa6yiTRH8yoXeRFw=;
	b=wDPe7YP/3yMsq0wG8oOuyYPujk8MmtdeKiZ7D7l/RvArr2QBFofHjZSAHgBTcutSOtxZDc
	FcJYEXWo6fuI0VsTuNo3cCUc7e/bG2iUO8XVcMbqVcLurbsxB2Uzl3jan6HPdIa/AoTx0k
	IOpUhUFw2pn5508OaoeFOZtdIo8kqzY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=jkVYOm8b;
	spf=pass (imf20.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.94.229 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834302; a=rsa-sha256;
	cv=none;
	b=3QFNFI4BpzZHgg0IIKJm92NTAXl7FfWexdiE4ixA9C9JSRe75KJkKI0IlHGxtoFIrugpXU
	R5ywJFXp4zAPFBxzBD8n0KZA7fJ2BQBbGfTiYnIemlxDtoTOXoW+WWczX50sracsQfKTlV
	uAhkWAh/Ba8+phRtPIiseiaNI+N2Qsw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834302; x=1807370302;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=SXUxXoRrWTOvyOc+uAqr+1ZCvKnUa6yiTRH8yoXeRFw=;
  b=jkVYOm8bXi0hqfQDmw0pIa9SZRNg4UiIqrhEHa0/aCPy5CR/5OFhZ1r5
   9/T3Yl+tQIK9LrNquGDAuN7Z9hIGkg85BqXJoPeDAIdJb4K69/sMkt48Q
   SjF3TETSVSpQ2LkIcLeoB+0gCCjoOCdttq+ysJPtWnFJAIuqrtD16b1M6
   f9OUnFMsooaVSKumd1sAPetdEUsjl9/RPqUaGtuqH1ydkGc/Rw4oJQsEr
   bwH21F2fkq/I0QKKFErGzm7zKJwMLiUjkyZ6YfXXjIURFsgkeFo1NPXdE
   +oYVvGmckMMJDnXRYlKPEVSNz/awqlq0066egCO7hO0YCto+hta35lnfG
   w==;
X-CSE-ConnectionGUID: ETAIPHXHQ6Cl6VUBPfxqbA==
X-CSE-MsgGUID: K9skfv97QeinTXXHdn0ngg==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15898090"
Received: from ip-10-4-17-41.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.17.41])
  by internal-iad-out-009.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:18:21 +0000
Received: from EX19MTAUEA002.ant.amazon.com [52.94.133.129:4854]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.3.180:2525] with esmtp (Farcaster)
 id 5c57dd77-82b6-4d25-81d9-bfb9fbf59a7a; Fri, 10 Apr 2026 15:18:20 +0000 (UTC)
X-Farcaster-Flow-ID: 5c57dd77-82b6-4d25-81d9-bfb9fbf59a7a
Received: from EX19D027UEC001.ant.amazon.com (10.252.137.156) by
 EX19MTAUEA002.ant.amazon.com (10.252.134.9) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:20 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC001.ant.amazon.com (10.252.137.156) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:20 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:18:20 +0000
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
Subject: [PATCH v12 03/16] mm/secretmem: make use of
 folio_{zap,restore}_direct_map
Thread-Topic: [PATCH v12 03/16] mm/secretmem: make use of
 folio_{zap,restore}_direct_map
Thread-Index: AQHcyP1DBItR5zMXtEmj13bg9CfDRw==
Date: Fri, 10 Apr 2026 15:18:19 +0000
Message-ID: <20260410151746.61150-4-kalyazin@amazon.com>
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
X-Stat-Signature: 96sotscd9wwx5856k8sa6gnk9teh1g1q
X-Rspamd-Queue-Id: 4D8D71C000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1775834302-608424
X-HE-Meta: U2FsdGVkX19G4qbyhhljiRb1B9AaUahpZCze5YnnGJnauyQvdSStQfF85R4wOsjVByd5SeVIjlSAykgPb+jcxR2gQ88Dn7pgFo3x0gDnQUi9i7EGUTXtY7BCtgaQhcPk7KFEFfovABjytHzkOSjAlmRQE6joCDH8dHkETheEIdgngrLRPSdTCUJRECeoR/JGO1Sqoa4UVsZUMNnEhO5kcfXkAf4OQx7j+M4wsF4B+2fZQ0ktmFU+dot02lDDoKH4dVshSQInOjwTPWMKPZgqIdnSM2/R3gVBooP7bGwrgp09CxiumQV7k//1X7sg/yyVav9GrCQT+3If8r4cXtCfJcx6SX+4Az+jxQUiPkMEq+82EEGFW7SXR9Q0G09RFm97FuiLagBmc9I6/LMS6KBbqj+AmCXLeAHIGI1PTCyvFjhTzAgW0arve8ux2zpjnyY+RBU8UjV/LNE3EuxJrXDAEpQizggKR6c0eDxktgzgv9dXrwLAjv1pCFAr+l68/E5IJXofdsvajgzIwjZByJUEDnrxVC+PWRgqD6e0AWrZ3A+yTpbfmZHrgjfwV2hKm/PpSrNNljqmXOroUunZ8hWZNJKcSa0gi5isx4RQm9FC680HrUrdnaR0pKdt3Yxk9eMXp4xwXf6b+clOsbGBGx+fcPjmBKE/V5PKJYf9trTgd44lp0gS0uc8QNL5YdzHpNqkRFYWaO4VskVXPUxzYvKZyoh5N9t5q8ZezSTNZLxHXjDWBPKkO+ZdCY6txs5qvfy2djsxbe3YFANbNTlRz8/QbutPChNIBPFzT0ifyPkUFs68TLTJWEr5Qh0yseliH+1x/T5EU1uUKcMYjrF225Pf+bASYuLmu7WCwe7QeRoIbHn33jNZT2vMXGZ2AYGPenHoT9My8z9qpJqgG6tc3VwN7KNdm9R3KdVxo0yJK8SaHNu6rf5kBjWlzM5i4dlzOVD4BxpdHGUcoP2KVRo3APe
 165nz74u
 h+XdFe1eEcpK5Afv2wHMXstCQYwVtByq2H+sL4i3WGBH96F36TP9hf02NOWq01M3JZ7ngAnvJqst2ZUqiC5phweGm6lyif8fskTFUs6sJNLZogmRMz/I9ycsrYGHN5SkPyf5anV8vxXn4oUYTrQ37LNCNbaFxOyyliCuFzGTVn3tGemobbnkU9r9EhdCz34MdT4L1ApIMIIlsP12E8nMdTRvr4i6gv5P3yQ9VCdBDHoQENq2SxIq7vwzWkOsq7hMTeOkQk/xGGYR8zaPEj0XqKaYC1LpSKNVSpCf7YdPxQAMziAz6XreDpcQUOu9679eRZ0KRTlZbxewGyW1JylgO3WG6OuHRaY+I0oBL6EtXV5qEp1euD25/b18sqgAFN5zBKw09HdpLWQDmbUa2Y35sq4LuSBIAe2RwzWsH+EKjME86LVsBggJPDcZxLJoH4DKbzZrI776vGx4t3jMwEl2VNpiyKLxFjcRHemUtmSEZ4eji0sm7CNaY9TH8w4ipf0cEHMcY72RzXHiBP6obVcQMSX1Fuq/xuL6JEEO4eoTzkbD65h0MyJVQBC0YX3r8wP9XnAxgeqerd8k3WeAFlWqGikVZrgff7Jy86qOKNqMVBg9lnhXynSY0xZ8sUCSWcmDpm8YAq/w7dqnLHJiJyNwgK6akLSUsD0QManH9HhuMG+nQd6lkAKJOek7ahifYs4vxVVmL5J/b8P7TDbCaNWlgAWPnDU7LGoNvIC5/9JyEeAViwKYVfVlyqpUBZqQwtEoWxQk8lF7vQbnufpj9SSKYhuCWOnFCr+ae1BuN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
=0A=
Replace set_direct_map_*_noflush with newly available=0A=
folio_zap_direct_map calls that take folio's address internally.  A side=0A=
effect is even if filemap_add_folio fails, the TLB is still flushed,=0A=
which is not expected to be on the hot path.=0A=
=0A=
Acked-by: David Hildenbrand (Arm) <david@kernel.org>=0A=
Reviewed-by: Ackerley Tng <ackerleytng@google.com>=0A=
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
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

