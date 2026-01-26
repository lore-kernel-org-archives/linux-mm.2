Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90EE5D19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:47:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00CA06B008A; Mon, 26 Jan 2026 11:47:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F06566B008C; Mon, 26 Jan 2026 11:47:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB3746B0092; Mon, 26 Jan 2026 11:47:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CA41B6B008A
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:47:22 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 714898C468
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:22 +0000 (UTC)
X-FDA: 84374695524.13.8D039F4
Received: from fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.75.33.185])
	by imf20.hostedemail.com (Postfix) with ESMTP id DC5131C0002
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:47:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="l1/AIHcg";
	spf=pass (imf20.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446040;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6ugj0bR1L5ovoLDxTWlvdxW8Q8SHuJm6TTfMMHh6kqk=;
	b=7AlGr/Zx5dVFlKroVay1uAhYownvGXetn4coiSPoJWmzdlWLbf4vFCV37skUDxaoBKpv85
	d83gOgC/xofZW1kbr3IJbwYJOEyj9aKG9oA9Z58l1ifRPoH0Mm/vNhrvn1Kb3sgSLBZJui
	7p1pupwj1Elr1NXvS3CFNooKUZp6Odo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="l1/AIHcg";
	spf=pass (imf20.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.75.33.185 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446040; a=rsa-sha256;
	cv=none;
	b=0R5FrVj9JM2Fq77PHJodZ0TH9VcEeWPCmO4DEn/9KLx40pGyhqQq2mUXfa0wMtSBejQFO/
	NeP7Zvd0menex2d7mXCHaD02BC9cS6QokKmZFixiuCoIdX8jCkaFEyYFWhaxO2w12mqQvT
	13z7pHZI1x6ITiA7xE/lAAmnd2SWnhg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446040; x=1800982040;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=6ugj0bR1L5ovoLDxTWlvdxW8Q8SHuJm6TTfMMHh6kqk=;
  b=l1/AIHcgUNISHQO7VOUgmEC+ZXbfs1KOv1IU1hk+6KG8mdoPiAogCMME
   VXNAFJpKErdW5UtDpCbzEOcnrba4ZBjx7tcxycNCQT3bAI8ARrPSJjD4L
   uK40990tXJBO3rCZxuhShsJScKRArcUeNmpQnRLdhd7o9PoTWogZd1mO/
   xnB8zKAFrCxrQKNk6yUEbRvuDoZNfom1cismF7IEtl8xhyRyW2YZtBQsR
   yU1/bo+LYItAYs7EcsluHNz/oPFtEbTlwDbM4ACRb+EpDwVIaq2l5AsT6
   YtCBk278QanDLfNG8M4TBUqPX5YlnCk2eo/rg7zi65E9msgdqamaLD50n
   Q==;
X-CSE-ConnectionGUID: QxeAWK3mR6WkCG2dwYYSeQ==
X-CSE-MsgGUID: XT1Tl1+7Tz26ahOLrIwLCA==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8453195"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-007.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:47:01 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:23982]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.185:2525] with esmtp (Farcaster)
 id 33cab3b0-dbc0-4166-ad4f-7954de6f437e; Mon, 26 Jan 2026 16:47:00 +0000 (UTC)
X-Farcaster-Flow-ID: 33cab3b0-dbc0-4166-ad4f-7954de6f437e
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:47:00 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:46:59 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:46:59 +0000
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
Subject: [PATCH v10 01/15] set_memory: set_direct_map_* to take address
Thread-Topic: [PATCH v10 01/15] set_memory: set_direct_map_* to take address
Thread-Index: AQHcjuNjuvenIG/S502HRVa9ETfo5w==
Date: Mon, 26 Jan 2026 16:46:59 +0000
Message-ID: <20260126164445.11867-2-kalyazin@amazon.com>
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
X-Stat-Signature: d8ys9npnp4x4tzi3s9uxaosfwiiyupha
X-Rspam-User: 
X-Rspamd-Queue-Id: DC5131C0002
X-HE-Tag: 1769446039-380112
X-HE-Meta: U2FsdGVkX19mXLBUrM1cNXGNM9zS4p1fSzqWmouGhdaMVcs3sFWX1h0dHGdLT7AJanbl7Wr0CZ2zrVCrUdEG3wj7rex50sGTLeuoOaEljQ4/tlbd36qDInbKtucyRqNe+Rz0Q2akU75qZZCg+5LK8WWAXIXN4HeGMg4V+Fg9lUNTg9N9j/doj2gBI9fGf8ycYjRLY+c1rY5cP8v4GaMMIqaZAtgdvViQxgMIa4vprORkxpHFdX8QXtILoK3I4U+PQzwQ5xArYJkCAp3CDG/qXZ5fMJnsJChtTaye906msvuNvsz43AKZoJZBtct//IxgOxkw90oOaYIdaumvfSMz1fqpLeejySMVV3MH+t5r3HURr5XlX5Q32M0Wy4/xm2Uy1v6s4xQvyLX7/OF/UzkiAFSfv0ZHHemKdBcI4cPWy9tgxS6sX4y8BRkw/P7jMqOQLSW0uuJeM6G2Bk8LKAyQc7L7k+vtpXrhcEB77siYUuUV7s492OrE0MFn5tnTYRgg5e01MGopnyX6iVN/dsd0Ku2ctZa6I3IvFZjaW/sw7A00W8j0CO2MEyJ7mzthYz1yZWU5UaCyByOQaru52SCZSfJe4cNV77NettjSVvbyjHowXOhC4vDAGObctz/X19DePFMQ0n/52qJ54TaAbE+riZQyqMeDAYWMlb0mjfzUkI+3fbpzvzznJaTziw6ZScyd8p0A/P3ghGUkH+lbB5iDWW5NNamIiPoMm+T2PfPcaxexaFwV6oNhjHHvec7zzEcL94yjFEibpTrg2lJCo9QMG1NI/NxpbqEVSnvAw+ZQt5tFnvMwGjABZuXWWkA+N7vTJUNckhxbzuMjjLEnE8VLA8ItuTSYVcQUhYzyi/NvJAvbBOctJRhzDLgjG6+RERLMrb82yrCjh4+04iWQkp4azWOTPv91lLlnLacRdPFVojCLVSygyVmcl3UsH812e1abKWrBTrn995MtM4jLBGV
 TfCWVYV6
 xH8QRT+LnoN8Tu0ybMJTY+6GKEX29m8LWyqHxWeON9JNZF/zX/2qeVw6ym2jNahCAMK1AzBanQSFOPDm4xI0b7NLrKCcTyIgpwMNhes6YjQnHFYGzB/fsqEnhVUMvyHxqz0p1nup0jqwDt+fQ7QFXlDwxhAsEdivTkK0ag8/ef+IKhVUXoBIIn63AEdGBfZPbDSOTYFwh4q6Ktf6NCPMh8eLwjwM+5ucEuXnnedCSPHjmXXJLDMMJtuYjkBiqKAps9c2w8beGXVZOtzbbKFVD4+IGTYWnD6FDjjyxuVCl+eXLIA0iwvd+AGsQxNtYyVMKo6lhI6txti5bgizHMqNP2rfFDxywf6b6edHAF8H9RWio+MOhZCKZmjszbYIFCqLo9ua28OTP+Sivg9EzUEEZg+bYluSQ21IEOEXNEKdmn2Lp95KsLa2vFm6WwqPSz+4icCGD4lx3/HEmSJvUS84gICU5a21AzEV2tfNoq0eHWhdrGlVwnbOPMrjSkcGnAP1BozPpFzyvReGT0VFl+9tzM9UwuapGpMKF2IcvX3HvIwHjcGXedpvodO+1dEaQWl2vFQfc86RV0tEeyYHlMtFMQc/nbMK4lf4C4wsJnXnrUL7MFffIFA6RzPYUIMBQjKlN0oAQ3MMLSz6izI3lWLLi4Q/zC58ou3AItzf/yXtq6vo14rpz7ZSixyJdPVrntvHf5yizjq7j4Sw12rkd9ip5ERUhWftMg/WKmh99xvyD3ctf03RqVDwNYzpQ5iC0alWPDl/IYGoZKq8Aqfs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <kalyazin@amazon.com>=0A=
=0A=
This is to avoid excessive conversions folio->page->address when adding=0A=
helpers on top of set_direct_map_valid_noflush() in the next patch.=0A=
=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/arm64/include/asm/set_memory.h     |  7 ++++---=0A=
 arch/arm64/mm/pageattr.c                | 19 +++++++++----------=0A=
 arch/loongarch/include/asm/set_memory.h |  7 ++++---=0A=
 arch/loongarch/mm/pageattr.c            | 25 ++++++++++++-------------=0A=
 arch/riscv/include/asm/set_memory.h     |  7 ++++---=0A=
 arch/riscv/mm/pageattr.c                | 17 +++++++++--------=0A=
 arch/s390/include/asm/set_memory.h      |  7 ++++---=0A=
 arch/s390/mm/pageattr.c                 | 13 +++++++------=0A=
 arch/x86/include/asm/set_memory.h       |  7 ++++---=0A=
 arch/x86/mm/pat/set_memory.c            | 23 ++++++++++++-----------=0A=
 include/linux/set_memory.h              |  9 +++++----=0A=
 kernel/power/snapshot.c                 |  4 ++--=0A=
 mm/execmem.c                            |  6 ++++--=0A=
 mm/secretmem.c                          |  6 +++---=0A=
 mm/vmalloc.c                            | 11 +++++++----=0A=
 15 files changed, 90 insertions(+), 78 deletions(-)=0A=
=0A=
diff --git a/arch/arm64/include/asm/set_memory.h b/arch/arm64/include/asm/s=
et_memory.h=0A=
index 90f61b17275e..c71a2a6812c4 100644=0A=
--- a/arch/arm64/include/asm/set_memory.h=0A=
+++ b/arch/arm64/include/asm/set_memory.h=0A=
@@ -11,9 +11,10 @@ bool can_set_direct_map(void);=0A=
 =0A=
 int set_memory_valid(unsigned long addr, int numpages, int enable);=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page);=0A=
-int set_direct_map_default_noflush(struct page *page);=0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d);=0A=
+int set_direct_map_invalid_noflush(const void *addr);=0A=
+int set_direct_map_default_noflush(const void *addr);=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 int set_memory_encrypted(unsigned long addr, int numpages);=0A=
diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c=0A=
index f0e784b963e6..e2bdc3c1f992 100644=0A=
--- a/arch/arm64/mm/pageattr.c=0A=
+++ b/arch/arm64/mm/pageattr.c=0A=
@@ -243,7 +243,7 @@ int set_memory_valid(unsigned long addr, int numpages, =
int enable)=0A=
 					__pgprot(PTE_VALID));=0A=
 }=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page)=0A=
+int set_direct_map_invalid_noflush(const void *addr)=0A=
 {=0A=
 	pgprot_t clear_mask =3D __pgprot(PTE_VALID);=0A=
 	pgprot_t set_mask =3D __pgprot(0);=0A=
@@ -251,11 +251,11 @@ int set_direct_map_invalid_noflush(struct page *page)=
=0A=
 	if (!can_set_direct_map())=0A=
 		return 0;=0A=
 =0A=
-	return update_range_prot((unsigned long)page_address(page),=0A=
-				 PAGE_SIZE, set_mask, clear_mask);=0A=
+	return update_range_prot((unsigned long)addr, PAGE_SIZE, set_mask,=0A=
+				 clear_mask);=0A=
 }=0A=
 =0A=
-int set_direct_map_default_noflush(struct page *page)=0A=
+int set_direct_map_default_noflush(const void *addr)=0A=
 {=0A=
 	pgprot_t set_mask =3D __pgprot(PTE_VALID | PTE_WRITE);=0A=
 	pgprot_t clear_mask =3D __pgprot(PTE_RDONLY);=0A=
@@ -263,8 +263,8 @@ int set_direct_map_default_noflush(struct page *page)=
=0A=
 	if (!can_set_direct_map())=0A=
 		return 0;=0A=
 =0A=
-	return update_range_prot((unsigned long)page_address(page),=0A=
-				 PAGE_SIZE, set_mask, clear_mask);=0A=
+	return update_range_prot((unsigned long)addr, PAGE_SIZE, set_mask,=0A=
+				 clear_mask);=0A=
 }=0A=
 =0A=
 static int __set_memory_enc_dec(unsigned long addr,=0A=
@@ -347,14 +347,13 @@ int realm_register_memory_enc_ops(void)=0A=
 	return arm64_mem_crypt_ops_register(&realm_crypt_ops);=0A=
 }=0A=
 =0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d)=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid)=0A=
 {=0A=
-	unsigned long addr =3D (unsigned long)page_address(page);=0A=
-=0A=
 	if (!can_set_direct_map())=0A=
 		return 0;=0A=
 =0A=
-	return set_memory_valid(addr, nr, valid);=0A=
+	return set_memory_valid((unsigned long)addr, numpages, valid);=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
diff --git a/arch/loongarch/include/asm/set_memory.h b/arch/loongarch/inclu=
de/asm/set_memory.h=0A=
index 55dfaefd02c8..5e9b67b2fea1 100644=0A=
--- a/arch/loongarch/include/asm/set_memory.h=0A=
+++ b/arch/loongarch/include/asm/set_memory.h=0A=
@@ -15,8 +15,9 @@ int set_memory_ro(unsigned long addr, int numpages);=0A=
 int set_memory_rw(unsigned long addr, int numpages);=0A=
 =0A=
 bool kernel_page_present(struct page *page);=0A=
-int set_direct_map_default_noflush(struct page *page);=0A=
-int set_direct_map_invalid_noflush(struct page *page);=0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d);=0A=
+int set_direct_map_invalid_noflush(const void *addr);=0A=
+int set_direct_map_default_noflush(const void *addr);=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid);=0A=
 =0A=
 #endif /* _ASM_LOONGARCH_SET_MEMORY_H */=0A=
diff --git a/arch/loongarch/mm/pageattr.c b/arch/loongarch/mm/pageattr.c=0A=
index f5e910b68229..c1b2be915038 100644=0A=
--- a/arch/loongarch/mm/pageattr.c=0A=
+++ b/arch/loongarch/mm/pageattr.c=0A=
@@ -198,32 +198,31 @@ bool kernel_page_present(struct page *page)=0A=
 	return pte_present(ptep_get(pte));=0A=
 }=0A=
 =0A=
-int set_direct_map_default_noflush(struct page *page)=0A=
+int set_direct_map_default_noflush(const void *addr)=0A=
 {=0A=
-	unsigned long addr =3D (unsigned long)page_address(page);=0A=
-=0A=
-	if (addr < vm_map_base)=0A=
+	if ((unsigned long)addr < vm_map_base)=0A=
 		return 0;=0A=
 =0A=
-	return __set_memory(addr, 1, PAGE_KERNEL, __pgprot(0));=0A=
+	return __set_memory((unsigned long)addr, 1, PAGE_KERNEL, __pgprot(0));=0A=
 }=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page)=0A=
+int set_direct_map_invalid_noflush(const void *addr)=0A=
 {=0A=
-	unsigned long addr =3D (unsigned long)page_address(page);=0A=
+	unsigned long addr =3D (unsigned long)addr;=0A=
 =0A=
-	if (addr < vm_map_base)=0A=
+	if ((unsigned long)addr < vm_map_base)=0A=
 		return 0;=0A=
 =0A=
-	return __set_memory(addr, 1, __pgprot(0), __pgprot(_PAGE_PRESENT | _PAGE_=
VALID));=0A=
+	return __set_memory((unsigned long)addr, 1, __pgprot(0),=0A=
+			    __pgprot(_PAGE_PRESENT | _PAGE_VALID));=0A=
 }=0A=
 =0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d)=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid)=0A=
 {=0A=
-	unsigned long addr =3D (unsigned long)page_address(page);=0A=
 	pgprot_t set, clear;=0A=
 =0A=
-	if (addr < vm_map_base)=0A=
+	if ((unsigned long)addr < vm_map_base)=0A=
 		return 0;=0A=
 =0A=
 	if (valid) {=0A=
@@ -234,5 +233,5 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 		clear =3D __pgprot(_PAGE_PRESENT | _PAGE_VALID);=0A=
 	}=0A=
 =0A=
-	return __set_memory(addr, 1, set, clear);=0A=
+	return __set_memory((unsigned long)addr, 1, set, clear);=0A=
 }=0A=
diff --git a/arch/riscv/include/asm/set_memory.h b/arch/riscv/include/asm/s=
et_memory.h=0A=
index 87389e93325a..a87eabd7fc78 100644=0A=
--- a/arch/riscv/include/asm/set_memory.h=0A=
+++ b/arch/riscv/include/asm/set_memory.h=0A=
@@ -40,9 +40,10 @@ static inline int set_kernel_memory(char *startp, char *=
endp,=0A=
 }=0A=
 #endif=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page);=0A=
-int set_direct_map_default_noflush(struct page *page);=0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d);=0A=
+int set_direct_map_invalid_noflush(const void *addr);=0A=
+int set_direct_map_default_noflush(const void *addr);=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 #endif /* __ASSEMBLER__ */=0A=
diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c=0A=
index 3f76db3d2769..0a457177a88c 100644=0A=
--- a/arch/riscv/mm/pageattr.c=0A=
+++ b/arch/riscv/mm/pageattr.c=0A=
@@ -374,19 +374,20 @@ int set_memory_nx(unsigned long addr, int numpages)=
=0A=
 	return __set_memory(addr, numpages, __pgprot(0), __pgprot(_PAGE_EXEC));=
=0A=
 }=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page)=0A=
+int set_direct_map_invalid_noflush(const void *addr)=0A=
 {=0A=
-	return __set_memory((unsigned long)page_address(page), 1,=0A=
-			    __pgprot(0), __pgprot(_PAGE_PRESENT));=0A=
+	return __set_memory((unsigned long)addr, 1, __pgprot(0),=0A=
+			    __pgprot(_PAGE_PRESENT));=0A=
 }=0A=
 =0A=
-int set_direct_map_default_noflush(struct page *page)=0A=
+int set_direct_map_default_noflush(const void *addr)=0A=
 {=0A=
-	return __set_memory((unsigned long)page_address(page), 1,=0A=
-			    PAGE_KERNEL, __pgprot(_PAGE_EXEC));=0A=
+	return __set_memory((unsigned long)addr, 1, PAGE_KERNEL,=0A=
+			    __pgprot(_PAGE_EXEC));=0A=
 }=0A=
 =0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d)=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid)=0A=
 {=0A=
 	pgprot_t set, clear;=0A=
 =0A=
@@ -398,7 +399,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 		clear =3D __pgprot(_PAGE_PRESENT);=0A=
 	}=0A=
 =0A=
-	return __set_memory((unsigned long)page_address(page), nr, set, clear);=
=0A=
+	return __set_memory((unsigned long)addr, numpages, set, clear);=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
diff --git a/arch/s390/include/asm/set_memory.h b/arch/s390/include/asm/set=
_memory.h=0A=
index 94092f4ae764..3e43c3c96e67 100644=0A=
--- a/arch/s390/include/asm/set_memory.h=0A=
+++ b/arch/s390/include/asm/set_memory.h=0A=
@@ -60,9 +60,10 @@ __SET_MEMORY_FUNC(set_memory_rox, SET_MEMORY_RO | SET_ME=
MORY_X)=0A=
 __SET_MEMORY_FUNC(set_memory_rwnx, SET_MEMORY_RW | SET_MEMORY_NX)=0A=
 __SET_MEMORY_FUNC(set_memory_4k, SET_MEMORY_4K)=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page);=0A=
-int set_direct_map_default_noflush(struct page *page);=0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d);=0A=
+int set_direct_map_invalid_noflush(const void *addr);=0A=
+int set_direct_map_default_noflush(const void *addr);=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 #endif=0A=
diff --git a/arch/s390/mm/pageattr.c b/arch/s390/mm/pageattr.c=0A=
index d3ce04a4b248..e231757bb0e0 100644=0A=
--- a/arch/s390/mm/pageattr.c=0A=
+++ b/arch/s390/mm/pageattr.c=0A=
@@ -390,17 +390,18 @@ int __set_memory(unsigned long addr, unsigned long nu=
mpages, unsigned long flags=0A=
 	return rc;=0A=
 }=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page)=0A=
+int set_direct_map_invalid_noflush(const void *addr)=0A=
 {=0A=
-	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_INV)=
;=0A=
+	return __set_memory((unsigned long)addr, 1, SET_MEMORY_INV);=0A=
 }=0A=
 =0A=
-int set_direct_map_default_noflush(struct page *page)=0A=
+int set_direct_map_default_noflush(const void *addr)=0A=
 {=0A=
-	return __set_memory((unsigned long)page_to_virt(page), 1, SET_MEMORY_DEF)=
;=0A=
+	return __set_memory((unsigned long)addr, 1, SET_MEMORY_DEF);=0A=
 }=0A=
 =0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d)=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid)=0A=
 {=0A=
 	unsigned long flags;=0A=
 =0A=
@@ -409,7 +410,7 @@ int set_direct_map_valid_noflush(struct page *page, uns=
igned nr, bool valid)=0A=
 	else=0A=
 		flags =3D SET_MEMORY_INV;=0A=
 =0A=
-	return __set_memory((unsigned long)page_to_virt(page), nr, flags);=0A=
+	return __set_memory((unsigned long)addr, numpages, flags);=0A=
 }=0A=
 =0A=
 bool kernel_page_present(struct page *page)=0A=
diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_m=
emory.h=0A=
index 61f56cdaccb5..f912191f0853 100644=0A=
--- a/arch/x86/include/asm/set_memory.h=0A=
+++ b/arch/x86/include/asm/set_memory.h=0A=
@@ -87,9 +87,10 @@ int set_pages_wb(struct page *page, int numpages);=0A=
 int set_pages_ro(struct page *page, int numpages);=0A=
 int set_pages_rw(struct page *page, int numpages);=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page);=0A=
-int set_direct_map_default_noflush(struct page *page);=0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d);=0A=
+int set_direct_map_invalid_noflush(const void *addr);=0A=
+int set_direct_map_default_noflush(const void *addr);=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid);=0A=
 bool kernel_page_present(struct page *page);=0A=
 =0A=
 extern int kernel_set_to_readonly;=0A=
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c=0A=
index 6c6eb486f7a6..bc8e1c23175b 100644=0A=
--- a/arch/x86/mm/pat/set_memory.c=0A=
+++ b/arch/x86/mm/pat/set_memory.c=0A=
@@ -2600,9 +2600,9 @@ int set_pages_rw(struct page *page, int numpages)=0A=
 	return set_memory_rw(addr, numpages);=0A=
 }=0A=
 =0A=
-static int __set_pages_p(struct page *page, int numpages)=0A=
+static int __set_pages_p(const void *addr, int numpages)=0A=
 {=0A=
-	unsigned long tempaddr =3D (unsigned long) page_address(page);=0A=
+	unsigned long tempaddr =3D (unsigned long)addr;=0A=
 	struct cpa_data cpa =3D { .vaddr =3D &tempaddr,=0A=
 				.pgd =3D NULL,=0A=
 				.numpages =3D numpages,=0A=
@@ -2619,9 +2619,9 @@ static int __set_pages_p(struct page *page, int numpa=
ges)=0A=
 	return __change_page_attr_set_clr(&cpa, 1);=0A=
 }=0A=
 =0A=
-static int __set_pages_np(struct page *page, int numpages)=0A=
+static int __set_pages_np(const void *addr, int numpages)=0A=
 {=0A=
-	unsigned long tempaddr =3D (unsigned long) page_address(page);=0A=
+	unsigned long tempaddr =3D (unsigned long)addr;=0A=
 	struct cpa_data cpa =3D { .vaddr =3D &tempaddr,=0A=
 				.pgd =3D NULL,=0A=
 				.numpages =3D numpages,=0A=
@@ -2638,22 +2638,23 @@ static int __set_pages_np(struct page *page, int nu=
mpages)=0A=
 	return __change_page_attr_set_clr(&cpa, 1);=0A=
 }=0A=
 =0A=
-int set_direct_map_invalid_noflush(struct page *page)=0A=
+int set_direct_map_invalid_noflush(const void *addr)=0A=
 {=0A=
-	return __set_pages_np(page, 1);=0A=
+	return __set_pages_np(addr, 1);=0A=
 }=0A=
 =0A=
-int set_direct_map_default_noflush(struct page *page)=0A=
+int set_direct_map_default_noflush(const void *addr)=0A=
 {=0A=
-	return __set_pages_p(page, 1);=0A=
+	return __set_pages_p(addr, 1);=0A=
 }=0A=
 =0A=
-int set_direct_map_valid_noflush(struct page *page, unsigned nr, bool vali=
d)=0A=
+int set_direct_map_valid_noflush(const void *addr, unsigned long numpages,=
=0A=
+				 bool valid)=0A=
 {=0A=
 	if (valid)=0A=
-		return __set_pages_p(page, nr);=0A=
+		return __set_pages_p(addr, numpages);=0A=
 =0A=
-	return __set_pages_np(page, nr);=0A=
+	return __set_pages_np(addr, numpages);=0A=
 }=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h=0A=
index 3030d9245f5a..1a2563f525fc 100644=0A=
--- a/include/linux/set_memory.h=0A=
+++ b/include/linux/set_memory.h=0A=
@@ -25,17 +25,18 @@ static inline int set_memory_rox(unsigned long addr, in=
t numpages)=0A=
 #endif=0A=
 =0A=
 #ifndef CONFIG_ARCH_HAS_SET_DIRECT_MAP=0A=
-static inline int set_direct_map_invalid_noflush(struct page *page)=0A=
+static inline int set_direct_map_invalid_noflush(const void *addr)=0A=
 {=0A=
 	return 0;=0A=
 }=0A=
-static inline int set_direct_map_default_noflush(struct page *page)=0A=
+static inline int set_direct_map_default_noflush(const void *addr)=0A=
 {=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-static inline int set_direct_map_valid_noflush(struct page *page,=0A=
-					       unsigned nr, bool valid)=0A=
+static inline int set_direct_map_valid_noflush(const void *addr,=0A=
+					       unsigned long numpages,=0A=
+					       bool valid)=0A=
 {=0A=
 	return 0;=0A=
 }=0A=
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c=0A=
index 0a946932d5c1..b6dda3a8eb6e 100644=0A=
--- a/kernel/power/snapshot.c=0A=
+++ b/kernel/power/snapshot.c=0A=
@@ -88,7 +88,7 @@ static inline int hibernate_restore_unprotect_page(void *=
page_address) {return 0=0A=
 static inline void hibernate_map_page(struct page *page)=0A=
 {=0A=
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {=0A=
-		int ret =3D set_direct_map_default_noflush(page);=0A=
+		int ret =3D set_direct_map_default_noflush(page_address(page));=0A=
 =0A=
 		if (ret)=0A=
 			pr_warn_once("Failed to remap page\n");=0A=
@@ -101,7 +101,7 @@ static inline void hibernate_unmap_page(struct page *pa=
ge)=0A=
 {=0A=
 	if (IS_ENABLED(CONFIG_ARCH_HAS_SET_DIRECT_MAP)) {=0A=
 		unsigned long addr =3D (unsigned long)page_address(page);=0A=
-		int ret  =3D set_direct_map_invalid_noflush(page);=0A=
+		int ret  =3D set_direct_map_invalid_noflush(page_address(page));=0A=
 =0A=
 		if (ret)=0A=
 			pr_warn_once("Failed to remap page\n");=0A=
diff --git a/mm/execmem.c b/mm/execmem.c=0A=
index 810a4ba9c924..220298ec87c8 100644=0A=
--- a/mm/execmem.c=0A=
+++ b/mm/execmem.c=0A=
@@ -119,7 +119,8 @@ static int execmem_set_direct_map_valid(struct vm_struc=
t *vm, bool valid)=0A=
 	int err =3D 0;=0A=
 =0A=
 	for (int i =3D 0; i < vm->nr_pages; i +=3D nr) {=0A=
-		err =3D set_direct_map_valid_noflush(vm->pages[i], nr, valid);=0A=
+		err =3D set_direct_map_valid_noflush(page_address(vm->pages[i]),=0A=
+						   nr, valid);=0A=
 		if (err)=0A=
 			goto err_restore;=0A=
 		updated +=3D nr;=0A=
@@ -129,7 +130,8 @@ static int execmem_set_direct_map_valid(struct vm_struc=
t *vm, bool valid)=0A=
 =0A=
 err_restore:=0A=
 	for (int i =3D 0; i < updated; i +=3D nr)=0A=
-		set_direct_map_valid_noflush(vm->pages[i], nr, !valid);=0A=
+		set_direct_map_valid_noflush(page_address(vm->pages[i]), nr,=0A=
+					     !valid);=0A=
 =0A=
 	return err;=0A=
 }=0A=
diff --git a/mm/secretmem.c b/mm/secretmem.c=0A=
index edf111e0a1bb..4453ae5dcdd4 100644=0A=
--- a/mm/secretmem.c=0A=
+++ b/mm/secretmem.c=0A=
@@ -72,7 +72,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)=
=0A=
 			goto out;=0A=
 		}=0A=
 =0A=
-		err =3D set_direct_map_invalid_noflush(folio_page(folio, 0));=0A=
+		err =3D set_direct_map_invalid_noflush(folio_address(folio));=0A=
 		if (err) {=0A=
 			folio_put(folio);=0A=
 			ret =3D vmf_error(err);=0A=
@@ -87,7 +87,7 @@ static vm_fault_t secretmem_fault(struct vm_fault *vmf)=
=0A=
 			 * already happened when we marked the page invalid=0A=
 			 * which guarantees that this call won't fail=0A=
 			 */=0A=
-			set_direct_map_default_noflush(folio_page(folio, 0));=0A=
+			set_direct_map_default_noflush(folio_address(folio));=0A=
 			folio_put(folio);=0A=
 			if (err =3D=3D -EEXIST)=0A=
 				goto retry;=0A=
@@ -152,7 +152,7 @@ static int secretmem_migrate_folio(struct address_space=
 *mapping,=0A=
 =0A=
 static void secretmem_free_folio(struct folio *folio)=0A=
 {=0A=
-	set_direct_map_default_noflush(folio_page(folio, 0));=0A=
+	set_direct_map_default_noflush(folio_address(folio));=0A=
 	folio_zero_segment(folio, 0, folio_size(folio));=0A=
 }=0A=
 =0A=
diff --git a/mm/vmalloc.c b/mm/vmalloc.c=0A=
index ecbac900c35f..5b9b421682ab 100644=0A=
--- a/mm/vmalloc.c=0A=
+++ b/mm/vmalloc.c=0A=
@@ -3329,14 +3329,17 @@ struct vm_struct *remove_vm_area(const void *addr)=
=0A=
 }=0A=
 =0A=
 static inline void set_area_direct_map(const struct vm_struct *area,=0A=
-				       int (*set_direct_map)(struct page *page))=0A=
+				       int (*set_direct_map)(const void *addr))=0A=
 {=0A=
 	int i;=0A=
 =0A=
 	/* HUGE_VMALLOC passes small pages to set_direct_map */=0A=
-	for (i =3D 0; i < area->nr_pages; i++)=0A=
-		if (page_address(area->pages[i]))=0A=
-			set_direct_map(area->pages[i]);=0A=
+	for (i =3D 0; i < area->nr_pages; i++) {=0A=
+		const void *addr =3D page_address(area->pages[i]);=0A=
+=0A=
+		if (addr)=0A=
+			set_direct_map(addr);=0A=
+	}=0A=
 }=0A=
 =0A=
 /*=0A=
-- =0A=
2.50.1=0A=
=0A=

