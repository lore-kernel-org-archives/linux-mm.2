Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A707D19502
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A0056B0005; Mon, 26 Jan 2026 11:50:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74EA86B008C; Mon, 26 Jan 2026 11:50:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 605E96B009B; Mon, 26 Jan 2026 11:50:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DDC86B0005
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:50:04 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EB9EC8C57E
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:50:03 +0000 (UTC)
X-FDA: 84374702286.04.CC9FE1B
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6412C8000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:50:01 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="g/IsneiZ";
	spf=pass (imf30.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YM73eY307YaRwo6+pc3v4qdEPN5NgqCcavRDYEf/Quc=;
	b=UYTkGsTR2P5OEsiVa9rpOPCjDSdlzDLh8ERuwklNR7xzcO/4XGc1RvHHhowu9Ogvw5B+lZ
	orcZK3FuJgOKYxSBTP1jKW+ICsrcYv4uHG/zU8o3itFT+L5dngki+bsgqdAX8yLepmN6w0
	tbaHnTcc+Q1JrTBw2WI3MTD1hcLAumA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="g/IsneiZ";
	spf=pass (imf30.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446201; a=rsa-sha256;
	cv=none;
	b=1YCu1v71xtW1R1Oj8rN4teUFLIOYOO72OCawWRny/br39/lPSUMjuvPB05Fd6zb9JDqKJF
	uRi3dCOFRgHeRLRYt38ci5cj/8XpzEEHfYJSxPKvZtibu9DDdLLwGdaXHL76gGtbrj3ItI
	O7Lmb3LUAXsxd1H1NA4az2iP+SgM1Hc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446201; x=1800982201;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=YM73eY307YaRwo6+pc3v4qdEPN5NgqCcavRDYEf/Quc=;
  b=g/IsneiZmJ2IZBjZiUhwQh0001TAVkEBxZTiKeBUMyLezQHLjm9OSA/w
   Hq4dnA8MAqY8NQIMbHFF/SOdweiOzOcmq5urX/6WecJl0mkjB4dGp80Qm
   DYMGx2lSLtvnDIn8MUnvwMQ7hJiuLa2nwjiuZc003N3P0l8n3lRRj5Wu0
   1NkX8bSb8Wbow53cDspRZnbRNGghqD6taiAdANOgO6Ap1hkyVrP/LgnhE
   AT3Dh3EDaNVVDxPO0WMmyb+12fAyWnt7j4hld/H2i2ICom6jVaQCnFVSn
   PkUY4ytB5G21R6mlnhsCGpXbTioWKbnIBTmu/XKPknDcp+WVdAM98GMH/
   A==;
X-CSE-ConnectionGUID: tsOMHVQVRZ65NfTX5SQhRg==
X-CSE-MsgGUID: naQRpPAmQfq37MsuRHHn/w==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8451376"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:49:59 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:21144]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.9.185:2525] with esmtp (Farcaster)
 id 54af3da5-7ca2-4763-b9d2-1af04fc03c99; Mon, 26 Jan 2026 16:49:59 +0000 (UTC)
X-Farcaster-Flow-ID: 54af3da5-7ca2-4763-b9d2-1af04fc03c99
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:49:57 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:49:57 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:49:57 +0000
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
Subject: [PATCH v10 06/15] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Topic: [PATCH v10 06/15] KVM: guest_memfd: Add stub for
 kvm_arch_gmem_invalidate
Thread-Index: AQHcjuOFjtfKI2gu60qkE1RI1hTM5Q==
Date: Mon, 26 Jan 2026 16:49:57 +0000
Message-ID: <20260126164445.11867-7-kalyazin@amazon.com>
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
X-Stat-Signature: 3o6y1tmu3s56xg9amgmnrzom7bta44ms
X-Rspam-User: 
X-Rspamd-Queue-Id: 6412C8000B
X-HE-Tag: 1769446201-506960
X-HE-Meta: U2FsdGVkX199IjXIumgLDGiP7K1BdJ+KZHwqZDIgzNY/e4ykcreNYMvoFqKA+pPx9xsPIZDVZ5aan0UkfTYUvBL8/WOFkrrBaJswckHKNKlTX2L8nxanORVX8Wvzjx4b/7kLit39mnkfYb3+C3RzrS7ky8rc87kkpQ5DXG7BVrtLk/0Sv+Y5nXiffZjPo0SHfUSTcXCklAwcC6Sbvo39A//ywoUXbArxlkraRXfsEmmGe427SoDIu51ocAQ/vDYHyVBuwiI+u+icCF2zRlf2znel6jeyfVHkwt7ofjnS2QJ7TxbtnV+ohEZ89KCBXewBsT25iymNbZFIJ3c4H0/gVx1LGgrFVHdF6mkw6tPJ8KRJQbZ2af32QxmMfYixqkcgFqz/YHObQ+TsGQv5cAAnkiy/3FT6k1ngoc6O/9efET3As9ITaXt1U6mCSuhpcsw92s/prd0wn1KoFmWDjpmX7FTJ6oBYhb0YGvM+2rIy8evh6Pa8vN2KXiUWBgQpi5QIlI8Jya7fOn3emSpK2yxgdA2yEgU1y03hR2VAS/pZcJ8xnqeQRw/VQX1ZsmeQTRPgP1yGLide52SYH47Gj/s2uBhMCl2jQuSBi8zQfrq/gXS2B39sL1X6RWuSJ8V6jTWCXdRZTN3zRLrc8mbkdRpwcg+1HCI32jYDJ/P/2fzWd/BOQtDKVZreK5TcYJuxHFul7x5mhlJm7EmMIA8srNWZsvvgyIlhc5+5bAbEokA44nwaoa/KF8cHC+58pVaMzdfQht1yqi4JeO9Md2s6z7Bb45sHHFwDCawISqNpsMREymEX0YK8nYbQaTLCfYbT5wxmmO3XEsyIc3YUWXfWP5dpDLU4a2oJWiWF31s8Lf6kc8wMhTnOuR1l6zeqImjqMi3nYFQJ1ahf0ccocmyXk4HfQXX9TJV8KpHPM6AaNl6c2hpfPQB29RyxC3vNBSoJ7t3F7LAzUm8nhBghScxxhgv
 NMO+2xPE
 DnFaWJ3isFSK/yb6/HyTh3LoK3bBonS0e6z/t5PM1mkzDhP1HlAgnAjVDBYodObJ4SOHUWkszFPZXdnrhCDPew0U5TCoGCFsN/PHpw8t6L7bK5903IkWCJxvAY4HY3DKD6D5GU1oa17Q8ZvFMQTbduTrmN80GYJPvclk/oKh4QOLyJH7iy6/mld6VF16zEZqOuCLOMOX3Z1nSJNOW0fITTzdqJRuZ1PcusMTD+QN0UPbPQQsNnbS0NCPhLAGlDbxGUVKXZ3eZn+NIkBm1UPHQj/TlIVvr4uxHCFGzWElp/LAznNiTDPpW7n77w1HFjhSKPQ/tjgsWubOWxHDVZSWeVDyto2ndnVG2SgmNDznpWohKa2mtjQ3Ne20DGVYtorKshwH5y9yHGQ9bYLRFwbfCEMtKGPgqXjR7K3lR9fzl6zsij+H4K6fNT630/aQxb0y69KNqgWPs0gXoKUzjFq20AA7f2ms9RSMYfLU+upmBYt9va+yyyOvV9XeohgBUkhExr0Jk5d7lFpKYej7KW39r67efH3tFcfQXwzCn+F+6DJhBOjyj1dmtmk/1L9f4Rt9johnIhj+dpDu7W33ln5igA6NzNt1nzrmS6BzsdzXXhTtYq/Uzo1Bupk1sKawJ+r4uZklxrERnm/elUYJgXbl+JRjSPHXB0qF2DK0rZPlPg8msKIJff8IavfOB0Lh9xZyxqsrQIxchcDOChsUzgVBbhmi3csi5gPQXwyS9qCZb859b95X603O/dNBVTPaDpC/sJx4R63OwETNkBdnG7wpCdl63xDo13k3X+3MGhXqVmvBfMeu4cwF3kgrmbw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Add a no-op stub for kvm_arch_gmem_invalidate if=0A=
CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=3Dn. This allows defining=0A=
kvm_gmem_free_folio without ifdef-ery, which allows more cleanly using=0A=
guest_memfd's free_folio callback for non-arch-invalidation related=0A=
code.=0A=
=0A=
Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Acked-by: Vlastimil Babka <vbabka@suse.cz>=0A=
Reviewed-by: Ackerley Tng <ackerleytng@google.com>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 include/linux/kvm_host.h | 2 ++=0A=
 virt/kvm/guest_memfd.c   | 4 ----=0A=
 2 files changed, 2 insertions(+), 4 deletions(-)=0A=
=0A=
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h=0A=
index d93f75b05ae2..27796a09d29b 100644=0A=
--- a/include/linux/kvm_host.h=0A=
+++ b/include/linux/kvm_host.h=0A=
@@ -2589,6 +2589,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t gfn, vo=
id __user *src, long npages=0A=
 =0A=
 #ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);=0A=
+#else=0A=
+static inline void kvm_arch_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end=
) { }=0A=
 #endif=0A=
 =0A=
 #ifdef CONFIG_KVM_GENERIC_PRE_FAULT_MEMORY=0A=
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c=0A=
index fdaea3422c30..92e7f8c1f303 100644=0A=
--- a/virt/kvm/guest_memfd.c=0A=
+++ b/virt/kvm/guest_memfd.c=0A=
@@ -527,7 +527,6 @@ static int kvm_gmem_error_folio(struct address_space *m=
apping, struct folio *fol=0A=
 	return MF_DELAYED;=0A=
 }=0A=
 =0A=
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 static void kvm_gmem_free_folio(struct folio *folio)=0A=
 {=0A=
 	struct page *page =3D folio_page(folio, 0);=0A=
@@ -536,15 +535,12 @@ static void kvm_gmem_free_folio(struct folio *folio)=
=0A=
 =0A=
 	kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));=0A=
 }=0A=
-#endif=0A=
 =0A=
 static const struct address_space_operations kvm_gmem_aops =3D {=0A=
 	.dirty_folio =3D noop_dirty_folio,=0A=
 	.migrate_folio	=3D kvm_gmem_migrate_folio,=0A=
 	.error_remove_folio =3D kvm_gmem_error_folio,=0A=
-#ifdef CONFIG_HAVE_KVM_ARCH_GMEM_INVALIDATE=0A=
 	.free_folio =3D kvm_gmem_free_folio,=0A=
-#endif=0A=
 };=0A=
 =0A=
 static int kvm_gmem_setattr(struct mnt_idmap *idmap, struct dentry *dentry=
,=0A=
-- =0A=
2.50.1=0A=
=0A=

