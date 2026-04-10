Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35573F459EE
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 15:18:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A25866B0093; Fri, 10 Apr 2026 11:18:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9AFA06B0095; Fri, 10 Apr 2026 11:18:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 850346B0096; Fri, 10 Apr 2026 11:18:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7492D6B0093
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 11:18:14 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 37176C173A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:14 +0000 (UTC)
X-FDA: 84643002108.13.E5F6971
Received: from iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com (iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com [34.198.218.121])
	by imf30.hostedemail.com (Postfix) with ESMTP id CE24780005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 15:18:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=ifsNMxPV;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf30.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.218.121 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775834291; a=rsa-sha256;
	cv=none;
	b=1sGoKLZlxx7jnsAyrfgk8oslIh0prcFRsv76oxyQPGFWF/HUZapO+tfXzabunJleGPr3bi
	gaya3xKH0hvYj5XmUzmnTJGt0enkokaq3CxGvbl/UjGdxh6diZpAMuJdxit9P3FJiExTVH
	VIe1U1VPQLCLVKtbH3PfpQa2osmoioA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=ifsNMxPV;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf30.hostedemail.com: domain of "prvs=5539d40d4=kalyazin@amazon.co.uk" designates 34.198.218.121 as permitted sender) smtp.mailfrom="prvs=5539d40d4=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775834291;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wtjHGpnQg1lu73D2AL344q66wwOjm1vkuSNtOJPDZj4=;
	b=JBquA+pOPZdRAjOSvDXyXw7cA8H/TLNadbxohZKKyAbk7Xtrkm+TFyIHrzIY0g5kBdl9mu
	IUtq5iLFGCATfSKKblrGxU9Yp3/5s6wiUVBgNY4JCBPPxwjjRoDARqwpPxpg+deHgwE9jS
	ixdxSUvXON+9CpdssPurrAmmgzaUG0s=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1775834291; x=1807370291;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wtjHGpnQg1lu73D2AL344q66wwOjm1vkuSNtOJPDZj4=;
  b=ifsNMxPVj/UQVhlKVy2he1+Cv6julmBHIXhkkGvAFwnwyDK1jXHN04/3
   875jJhbq6QJAPzBW9uZb/MaU9E1oCUl5CygYa5xdxPiihSZXGvcSlRdQT
   vxN7KVXpgzsISzKqp1+bru+h6j1KA/zdFh8K9JSNsaOECwQKLBpXp8XF4
   K0yxf+XRr6UlsP5wXYmYrmtYKy93SacvZU3XgCNLPSHktdObV9zNkMiG6
   MZCBANWsMwU/NaM3/WLb8JLTQCcI2lwyt+Pc4QcUKWCmcf4s5f4lppDvX
   xuzvo4I74zyKzKUIAnPJYUjUgoUYNt96E5W23zEOi18niyWcNopUDME3S
   A==;
X-CSE-ConnectionGUID: BTx+enIwRwGAT80uKS6img==
X-CSE-MsgGUID: 9iPVJ/7aQoyu6dbmF3RzpA==
X-IronPort-AV: E=Sophos;i="6.23,171,1770595200"; 
   d="scan'208";a="15428526"
Received: from ip-10-4-7-229.ec2.internal (HELO smtpout.naws.us-east-1.prod.farcaster.email.amazon.dev) ([10.4.7.229])
  by internal-iad-out-013.esa.us-east-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Apr 2026 15:18:10 +0000
Received: from EX19MTAUEA001.ant.amazon.com [72.21.196.67:8399]
 by smtpin.naws.us-east-1.prod.farcaster.email.amazon.dev [10.0.29.254:2525] with esmtp (Farcaster)
 id ab9b97a0-55cc-470f-a2db-ce7ac5d2c725; Fri, 10 Apr 2026 15:18:10 +0000 (UTC)
X-Farcaster-Flow-ID: ab9b97a0-55cc-470f-a2db-ce7ac5d2c725
Received: from EX19D027UEC002.ant.amazon.com (10.252.137.166) by
 EX19MTAUEA001.ant.amazon.com (10.252.134.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:09 +0000
Received: from EX19D027UEC003.ant.amazon.com (10.252.137.250) by
 EX19D027UEC002.ant.amazon.com (10.252.137.166) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 10 Apr 2026 15:18:09 +0000
Received: from EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d]) by
 EX19D027UEC003.ant.amazon.com ([fe80::887f:519b:ba73:21d%3]) with mapi id
 15.02.2562.037; Fri, 10 Apr 2026 15:18:09 +0000
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
Subject: [PATCH v12 02/16] set_memory: add folio_{zap,restore}_direct_map
 helpers
Thread-Topic: [PATCH v12 02/16] set_memory: add folio_{zap,restore}_direct_map
 helpers
Thread-Index: AQHcyP09iU0saiM/JE2jxlJdvD20bQ==
Date: Fri, 10 Apr 2026 15:18:09 +0000
Message-ID: <20260410151746.61150-3-kalyazin@amazon.com>
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
X-Stat-Signature: rcs9ytddwx7szsg4brmieh7ahe55iyz7
X-Rspamd-Queue-Id: CE24780005
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775834291-184702
X-HE-Meta: U2FsdGVkX19TY+qMe4nDUIFvqfXTWxrAFzvyx4YsF3g6pQ+V1ERNUif9Mf1rNVOPK+tZKT7JguXtrRgny9doMkOujnMc3tZFDZKhwUGoxjb66Gbbup35d1w3kp/ZDmAGR85awxb7I3Wx3yBT64GDSrORZfIYGUU9WDxr4KcEC723lcAPzb86+eW1MBFIN4rlMTGyHGF1pcdgxAfE/RVFd4K3N3yeEFXhOYbH+h7Bfsr5UDdoK+tT/7jt33NjT7A5CNMwzZ1NAvGnPsU3p+SUWHTrrLZER+CSuSdPq3xbWYtgUqCtYC5H5abIsLSxffe5+Vu9pkmIhOUCsDkMRsHVOSvrA2FB9CgCilCNfEYTdqtdvVwBBoAx7Djky6LeAMm0fwLULZ63Pq7hEQQEZIcnE7sfZFJcVKEAkXDrETeAjHMya6VM2DcKi3P8tEspk6B07KGvUQ7RT+kxlvt5UwOFetOmEewrarrJxuQyDiAYiPaL8rZoLyGWQcoOQcjjO/a6I2FtTGI6ZCYt5N5hoYoAmZrhZ0r3gYX6BXRW/pqRHBjfFC+N0RWMwNtbZhB4ZhqvfB3bKeqhyHek1NfXSw6EUoGTW5xvrCR4qo0cbiHbvgegv7eNOFM2i/0fG1A/DqJPSMwgTpD8izcXvLZVJRgqR/63JzS2dnVEpmX8fb0f9Vr2w1h8aFjy1mSoUkNTKhEwf5qZc6L/SlGX00yKCSOpHx3B/IQSv1TP0arY/y2Ut03eBTLBlEvRVC/c6keYj8MwYeBk2qvG2cG4n5Uw6tjM9Ucq3AV9UPjzzCZxnclepD2JdVmaEy9Ob8BplK6JpsC0vdWGwQJuBy4N5/DdtJicGr1p4CRoFebLng0K3sVLaqedfO1hIGwmBpL0mR4nV92JL5RmJ8mH/Lx5lsg9bohnqIqGoStgezLf7fH3ZEWsJiX8HMd6+vONx66qZkYsH3Mp38nT5i9h1D0ytHAFvF+
 Yd7s+wFr
 pOV382bh0pOjPE7Ju0ebdJH63wHcupUuryBQBR1AUlVGqNWL1zD2tTNu3MKAPcTvFgPsiqSbYByODQSufphtr+ckzg8NGm5DuB3MyXHad5zlfuX3/k8rMHzWaAplI14+XuixzENB1sscoc+zTTVJR1Iw/PrUfCESdSPIpQ8dqFUIBOHoSVPHV54PhfRnzjYO9TQHTNK468VPw008Iy0+gUq9XQ0ycOmOiYZJVGbpCquqfc+PFfaiAT/S7TAOKWK0MtbdgwVRz2KT7k9qvIc8aOwUQO9svoHJA8pZcQP4ugkYdsdsfOq/pk4Aclmoi9BOiKH4BiGA4Yoap3yBBtVYLE82RnAXPjBMbHfeP6E9kcejTHjh74Ivqon30M6RDpDQj9nDPj7KuldmKH1MLthS9uM3ZGZQ7lmCTPoTrMllSpqSY1jJv3Y+Bt67mlHH4aR7eQlUCHFf0wrvBm0gBFBS+E2xZm52fF94Wv+z1zP5fsev/WI9J1begHS7/XmB27sGgfxlp+Wu61s/aWgEPiBIZbNkUgiLc7gMwMHb1267bGwx3fefjMmpQIMqxrMiY5D8Q5ZcLc6woxSYdCzVJZC8DBdNFZDqokOY7KOwsv9N5fJTNAl8H9ZKn988bwMhPRcPU8QCmDxH7VOtfJE83a499xcaADYlQYrrpIM7OMO4BVYg8hW486xsGdidVSHldzuO1PXYIRmGn9GKLsQNKRx/MOVTjqLsvCpC8BO2Uhb0ghaTEoP8U/x8PXo7x44zRGteTy0GiSpphagiOufWxrKVXm5PRIsEmGMqh8YauWIXAq/cUpQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
=0A=
Let's provide folio_{zap,restore}_direct_map helpers as preparation for=0A=
supporting removal of the direct map for guest_memfd folios.=0A=
In folio_zap_direct_map(), flush TLB to make sure the data is not=0A=
accessible.  On some architectures, there may be a double TLB flush=0A=
issued because set_direct_map_valid_noflush already performs a flush=0A=
internally.=0A=
=0A=
The new helpers need to be accessible to KVM on architectures that=0A=
support guest_memfd (x86 and arm64).=0A=
=0A=
Direct map removal gives guest_memfd the same protection that=0A=
memfd_secret does, such as hardening against Spectre-like attacks=0A=
through in-kernel gadgets.=0A=
=0A=
Acked-by: David Hildenbrand (Arm) <david@kernel.org>=0A=
Signed-off-by: Nikita Kalyazin <nikita.kalyazin@linux.dev>=0A=
---=0A=
 include/linux/set_memory.h | 13 +++++++++++=0A=
 mm/memory.c                | 45 ++++++++++++++++++++++++++++++++++++++=0A=
 2 files changed, 58 insertions(+)=0A=
=0A=
diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h=0A=
index 1a2563f525fc..24caea2931f9 100644=0A=
--- a/include/linux/set_memory.h=0A=
+++ b/include/linux/set_memory.h=0A=
@@ -41,6 +41,15 @@ static inline int set_direct_map_valid_noflush(const voi=
d *addr,=0A=
 	return 0;=0A=
 }=0A=
 =0A=
+static inline int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	return 0;=0A=
+}=0A=
+=0A=
+static inline void folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+}=0A=
+=0A=
 static inline bool kernel_page_present(struct page *page)=0A=
 {=0A=
 	return true;=0A=
@@ -57,6 +66,10 @@ static inline bool can_set_direct_map(void)=0A=
 }=0A=
 #define can_set_direct_map can_set_direct_map=0A=
 #endif=0A=
+=0A=
+int folio_zap_direct_map(struct folio *folio);=0A=
+void folio_restore_direct_map(struct folio *folio);=0A=
+=0A=
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */=0A=
 =0A=
 #ifdef CONFIG_X86_64=0A=
diff --git a/mm/memory.c b/mm/memory.c=0A=
index 2f815a34d924..3b9ada2cc19c 100644=0A=
--- a/mm/memory.c=0A=
+++ b/mm/memory.c=0A=
@@ -78,6 +78,7 @@=0A=
 #include <linux/sched/sysctl.h>=0A=
 #include <linux/pgalloc.h>=0A=
 #include <linux/uaccess.h>=0A=
+#include <linux/set_memory.h>=0A=
 =0A=
 #include <trace/events/kmem.h>=0A=
 =0A=
@@ -7479,3 +7480,47 @@ void vma_pgtable_walk_end(struct vm_area_struct *vma=
)=0A=
 	if (is_vm_hugetlb_page(vma))=0A=
 		hugetlb_vma_unlock_read(vma);=0A=
 }=0A=
+=0A=
+#ifdef CONFIG_ARCH_HAS_SET_DIRECT_MAP=0A=
+/**=0A=
+ * folio_zap_direct_map - remove a folio from the kernel direct map=0A=
+ * @folio: folio to remove from the direct map=0A=
+ *=0A=
+ * Removes the folio from the kernel direct map and flushes the TLB.  This=
 may=0A=
+ * require splitting huge pages in the direct map, which can fail due to m=
emory=0A=
+ * allocation.  So far, only order-0 folios are supported.=0A=
+ *=0A=
+ * Return: 0 on success, or a negative error code on failure.=0A=
+ */=0A=
+int folio_zap_direct_map(struct folio *folio)=0A=
+{=0A=
+	const void *addr =3D folio_address(folio);=0A=
+	int ret;=0A=
+=0A=
+	if (folio_test_large(folio))=0A=
+		return -EINVAL;=0A=
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
+/**=0A=
+ * folio_restore_direct_map - restore the kernel direct map entry for a fo=
lio=0A=
+ * @folio: folio whose direct map entry is to be restored=0A=
+ *=0A=
+ * This may only be called after a prior successful folio_zap_direct_map()=
 on=0A=
+ * the same folio.  Because the zap will have already split any huge pages=
 in=0A=
+ * the direct map, restoration here only updates protection bits and canno=
t=0A=
+ * fail.=0A=
+ */=0A=
+void folio_restore_direct_map(struct folio *folio)=0A=
+{=0A=
+	WARN_ON_ONCE(set_direct_map_valid_noflush(folio_address(folio),=0A=
+						  folio_nr_pages(folio), true));=0A=
+}=0A=
+EXPORT_SYMBOL_FOR_MODULES(folio_restore_direct_map, "kvm");=0A=
+#endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */=0A=
-- =0A=
2.50.1=0A=
=0A=

