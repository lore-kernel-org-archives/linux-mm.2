Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4DD1D33990
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:58:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47C9F6B0011; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42C766B000D; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CCE96B0022; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 0DB3F6B000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:58:41 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D8E2888588
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:40 +0000 (UTC)
X-FDA: 84186026400.01.D33035F
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id 49CBE120019
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:38 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mhpM3htW;
	spf=pass (imf29.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XlbB/AHh0YQTX9rpyDTJlTKE99RJ4c4rYvfLyG5A7fY=;
	b=K8JZEtXC8LJ9TFx27ezcaYAIjsTFei3kq8KodpHJwbibh5W1ZuAiMDsqpL5OP+phbqOYNu
	0j9x1VnKmsl7oiLIJ5ti5XApCOC6jng8GLJpqFsUfL3x8zOveknOAWxsIx9dOazVyvg0An
	Spj0Wp7gnyoUMJ2DBalQd4cgcCTXc5w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953918; a=rsa-sha256;
	cv=none;
	b=4bgS4D0IHpHGTyfU8GRUT/DNdKOa5IrIus+h+KnSkiHVsLl5T4sHht8K8Ew395nLFoaJn/
	lwOGbAELiEYw1e6LXCHOvdoREfx4NlmQ7j0e3ZrwD0mEjhCVz1UW6KABfxW4SiZ4c3UlxL
	jx0+GIZNTED/kpqFuG9AFyNACmMe8Sw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=mhpM3htW;
	spf=pass (imf29.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953918; x=1796489918;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XlbB/AHh0YQTX9rpyDTJlTKE99RJ4c4rYvfLyG5A7fY=;
  b=mhpM3htWGGdw5mD6uvJDttXceexTjgjirQ5jdIB1zHqvalgwOnOVekcf
   9TUrmgJtBWPPPTcojh4TbBandw97bU2sRr0MBDT4i7nyyh3R/2mCl3Tbb
   SZ2rmpackx9icmvZMBvisNYIhEZ66vMfFlrO8JE7go/ixBJ82oOtFKSU7
   ccCBnG80EPJMMz6U7aVD7xFbUW6XUljSPcIs68gd6UsTyk478a4GWjRgq
   K7sCH0NPK+lsAcoYPUVtcALQpsdkm9GmGyrBpUVK02124IVdrCdzr9Hd7
   dY3cl/WWjgu97UVlSWDUfDz6FIV/vqDF37RM9t7G95ExGzRisLFf/2lui
   g==;
X-CSE-ConnectionGUID: tZu3dFNkQvqA1ZyZ7qwk7w==
X-CSE-MsgGUID: cc5HHGcuQSOXn+liRVfvJw==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6301792"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:58:21 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:7206]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.0.231:2525] with esmtp (Farcaster)
 id b66dbefc-1774-4ce5-8285-0803812e64ba; Fri, 5 Dec 2025 16:58:20 +0000 (UTC)
X-Farcaster-Flow-ID: b66dbefc-1774-4ce5-8285-0803812e64ba
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.223) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:20 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:20 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:58:20 +0000
From: "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
To: "kvm@vger.kernel.org" <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
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
	"riel@surriel.com" <riel@surriel.com>, "baohua@kernel.org"
	<baohua@kernel.org>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
	"jgross@suse.com" <jgross@suse.com>, "yu-cheng.yu@intel.com"
	<yu-cheng.yu@intel.com>, "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com"
	<coxu@redhat.com>, "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "isaku.yamahata@intel.com"
	<isaku.yamahata@intel.com>, "jmattson@google.com" <jmattson@google.com>,
	"jthoughton@google.com" <jthoughton@google.com>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>
Subject: [PATCH v8 03/13] mm: introduce AS_NO_DIRECT_MAP
Thread-Topic: [PATCH v8 03/13] mm: introduce AS_NO_DIRECT_MAP
Thread-Index: AQHcZghb1bjlwJbbGEq/dQeHI0u86A==
Date: Fri, 5 Dec 2025 16:58:19 +0000
Message-ID: <20251205165743.9341-4-kalyazin@amazon.com>
References: <20251205165743.9341-1-kalyazin@amazon.com>
In-Reply-To: <20251205165743.9341-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 49CBE120019
X-Stat-Signature: w98zbkkh8nqkq1gn3w1nifqpeyhpqtmu
X-Rspam-User: 
X-HE-Tag: 1764953918-558327
X-HE-Meta: U2FsdGVkX19v6tgnAI39OfijvhdBTA+JSn/nCcA3H2NmDvPm4le8j01DkXV+jn0HQH5wySDb8LzurAJHopvIBuezKCmhf73lK+ziJn58cFFXr5JLEhHgtHyct/xIYoiBar17olXduyuUz+qwmdme/Ruq4ZivIoSNf43B0wx0Fh5iltQeGjqPqrRgml0soRIYTPJu3FVR0wHzFuSSfTwW2fwY+QwVkbxvg6OXkLaajAAiZF6W5taqsJCDyMUcWYH1HWA22UeCrQ3x3ZS4mdNdxQphXHQfIQY2xoieR82PYn0FdSaBPlptr+sSgG4NcJo0mWXhR52Fl/q5sHnZYrbvXAsSvTXoZE1V/ENS/vyg/SdQYCJ0ObJl/YKFilLGMOhaMjYySxd4pXmuyLeOGsI/SVnXIPvxr8cPi1UwMpQJ8oyP8AZDEd3Kv0KyWpU61eufSoCpShvcD4ZCUlIzw0cswB2mGSPAWA17pIczEtnY0nDdzLBMDWG4+6Y1noX/SVjCQxjUZH7DCQtsvtqdRATDXh4xGBkuxoIP4jYxdj+70KuY7J6IWVZipEfY1dyddsprz7PeSYwUNuLd38IKQtrlsbVjvpSTW/JysBE02gauLarYCdt7vYGRju5KP7a6PCKJSQ2v0mMqDgHU0ElXCGk67LwCmHoDKnF5nrW+EsFPD9yCPbKuXtthn4p4Uyi1GIFniP3okZUtTRAofLibykTOpYenTn0PJiJGxjml+CmpngAGkxPWG/NIhAC1KpG6loD6UEQW8sD6vdDRLYYSDyrZcmK0nuJRX1MK6ez0b4IPO6PwHus+SGzgEipPpMLkUjM412RQYNiU+AZMEN+e1I2bxWynFlLDcmXhzV++04P6Tnc0mbmoAhdtOJLXo22cIgOfSFDnvE96wgX1EsXX9fZEOl5tDJQ2nv13h2SYy5keGrUNZUqDleYb/LWwpaWM0EUK90vLNz8rOiyyj7deDZ4
 UJbQX/Uy
 0GFpBMQFHaQ4q6VvxV7HB1lZQNNwqRQEYYF5A+/1XHSHX5jWPyrCL/JyhFMeJu7H0UWawl/jRURQi2oRR3c1rHfsuyL7kQa/MS4Bm3fjuDi/sbw3ylh2UqsZvM9N6YNxZ4AtfnJxe1jNVBBiWnx7XpLg2K+RULsPA8+HNjjxjcSf+SjxxBrOn3Hah1oB7RO8ThV726A+eTriocuANF4SwiukRgiOco8PlNpk0OMoM5lxuCdbfdwutO7Do0mopCw7gxnBmClq/Q4+LHF/a6AgK49ad8z4Po0SmY+HHSV+u2zyKrvYX9r5D7VT6NusTnEiLLP8S8rV91WM+PSe7LX8vYP4dIKFMpBdnHHX31uvFev3EJPuOQoiQUArj0ZKd6SKkVYK0SWRcAJptjC9LGuXi+oCWcnPvCWu4dqY/gWZKadpWd2Zn0DPLyHnl0+MX6qblx6Rw16zBNRF/f8G/f6t8wtgDhEdGQ9gHZfhwXKvr3hZS8VJ/dfN423hz0qs9YAy+QkLmT5N/Eppvx78qF08l+muCbGENNEXrjGTDXQeT7RnoyJvVEt68VJcJEbzgAjOuOEGgW2hSPtCtp5aCwFJx0Oooms4LJ9JrmecsttMae53EgI58fEjkUZUxhgjcA0M4I2deyV+mxUUC97/zotR8UZCX/0HwZ9KY+czinGMBe61jsFKy/MkHw+bfBDgToHBouSTIeXOrd2fIPpP8O8J4AGj3MxXUspbKZCxXcIXnEs9GuWIHYapyV0OwBRA/pdfh8mEc8X0jaQsdev03kZ8PbnPBeKuUhBiSRSkh
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Add AS_NO_DIRECT_MAP for mappings where direct map entries of folios are=0A=
set to not present. Currently, mappings that match this description are=0A=
secretmem mappings (memfd_secret()). Later, some guest_memfd=0A=
configurations will also fall into this category.=0A=
=0A=
Reject this new type of mappings in all locations that currently reject=0A=
secretmem mappings, on the assumption that if secretmem mappings are=0A=
rejected somewhere, it is precisely because of an inability to deal with=0A=
folios without direct map entries, and then make memfd_secret() use=0A=
AS_NO_DIRECT_MAP on its address_space to drop its special=0A=
vma_is_secretmem()/secretmem_mapping() checks.=0A=
=0A=
This drops a optimization in gup_fast_folio_allowed() where=0A=
secretmem_mapping() was only called if CONFIG_SECRETMEM=3Dy. secretmem is=
=0A=
enabled by default since commit b758fe6df50d ("mm/secretmem: make it on=0A=
by default"), so the secretmem check did not actually end up elided in=0A=
most cases anymore anyway.=0A=
=0A=
Use a new flag instead of overloading AS_INACCESSIBLE (which is already=0A=
set by guest_memfd) because not all guest_memfd mappings will end up=0A=
being direct map removed (e.g. in pKVM setups, parts of guest_memfd that=0A=
can be mapped to userspace should also be GUP-able, and generally not=0A=
have restrictions on who can access it).=0A=
=0A=
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>=0A=
Acked-by: David Hildenbrand (Red Hat)" <david@kernel.org>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 include/linux/pagemap.h   | 16 ++++++++++++++++=0A=
 include/linux/secretmem.h | 18 ------------------=0A=
 lib/buildid.c             |  4 ++--=0A=
 mm/gup.c                  | 19 +++++--------------=0A=
 mm/mlock.c                |  2 +-=0A=
 mm/secretmem.c            |  8 ++------=0A=
 6 files changed, 26 insertions(+), 41 deletions(-)=0A=
=0A=
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h=0A=
index a17fabbc0269..d51e0c0404e2 100644=0A=
--- a/include/linux/pagemap.h=0A=
+++ b/include/linux/pagemap.h=0A=
@@ -213,6 +213,7 @@ enum mapping_flags {=0A=
 	AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,=0A=
 	AS_KERNEL_FILE =3D 10,	/* mapping for a fake kernel file that shouldn't=
=0A=
 				   account usage to user cgroups */=0A=
+	AS_NO_DIRECT_MAP =3D 11,	/* Folios in the mapping are not in the direct m=
ap */=0A=
 	/* Bits 16-25 are used for FOLIO_ORDER */=0A=
 	AS_FOLIO_ORDER_BITS =3D 5,=0A=
 	AS_FOLIO_ORDER_MIN =3D 16,=0A=
@@ -348,6 +349,21 @@ static inline bool mapping_writeback_may_deadlock_on_r=
eclaim(const struct addres=0A=
 	return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->flags);=
=0A=
 }=0A=
 =0A=
+static inline void mapping_set_no_direct_map(struct address_space *mapping=
)=0A=
+{=0A=
+	set_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
+}=0A=
+=0A=
+static inline bool mapping_no_direct_map(const struct address_space *mappi=
ng)=0A=
+{=0A=
+	return test_bit(AS_NO_DIRECT_MAP, &mapping->flags);=0A=
+}=0A=
+=0A=
+static inline bool vma_has_no_direct_map(const struct vm_area_struct *vma)=
=0A=
+{=0A=
+	return vma->vm_file && mapping_no_direct_map(vma->vm_file->f_mapping);=0A=
+}=0A=
+=0A=
 static inline gfp_t mapping_gfp_mask(const struct address_space *mapping)=
=0A=
 {=0A=
 	return mapping->gfp_mask;=0A=
diff --git a/include/linux/secretmem.h b/include/linux/secretmem.h=0A=
index e918f96881f5..0ae1fb057b3d 100644=0A=
--- a/include/linux/secretmem.h=0A=
+++ b/include/linux/secretmem.h=0A=
@@ -4,28 +4,10 @@=0A=
 =0A=
 #ifdef CONFIG_SECRETMEM=0A=
 =0A=
-extern const struct address_space_operations secretmem_aops;=0A=
-=0A=
-static inline bool secretmem_mapping(struct address_space *mapping)=0A=
-{=0A=
-	return mapping->a_ops =3D=3D &secretmem_aops;=0A=
-}=0A=
-=0A=
-bool vma_is_secretmem(struct vm_area_struct *vma);=0A=
 bool secretmem_active(void);=0A=
 =0A=
 #else=0A=
 =0A=
-static inline bool vma_is_secretmem(struct vm_area_struct *vma)=0A=
-{=0A=
-	return false;=0A=
-}=0A=
-=0A=
-static inline bool secretmem_mapping(struct address_space *mapping)=0A=
-{=0A=
-	return false;=0A=
-}=0A=
-=0A=
 static inline bool secretmem_active(void)=0A=
 {=0A=
 	return false;=0A=
diff --git a/lib/buildid.c b/lib/buildid.c=0A=
index c4b0f376fb34..89e567954284 100644=0A=
--- a/lib/buildid.c=0A=
+++ b/lib/buildid.c=0A=
@@ -65,8 +65,8 @@ static int freader_get_folio(struct freader *r, loff_t fi=
le_off)=0A=
 =0A=
 	freader_put_folio(r);=0A=
 =0A=
-	/* reject secretmem folios created with memfd_secret() */=0A=
-	if (secretmem_mapping(r->file->f_mapping))=0A=
+	/* reject folios without direct map entries (e.g. from memfd_secret() or =
guest_memfd()) */=0A=
+	if (mapping_no_direct_map(r->file->f_mapping))=0A=
 		return -EFAULT;=0A=
 =0A=
 	r->folio =3D filemap_get_folio(r->file->f_mapping, file_off >> PAGE_SHIFT=
);=0A=
diff --git a/mm/gup.c b/mm/gup.c=0A=
index a8ba5112e4d0..719e4dbecc09 100644=0A=
--- a/mm/gup.c=0A=
+++ b/mm/gup.c=0A=
@@ -11,7 +11,6 @@=0A=
 #include <linux/rmap.h>=0A=
 #include <linux/swap.h>=0A=
 #include <linux/swapops.h>=0A=
-#include <linux/secretmem.h>=0A=
 =0A=
 #include <linux/sched/signal.h>=0A=
 #include <linux/rwsem.h>=0A=
@@ -1216,7 +1215,7 @@ static int check_vma_flags(struct vm_area_struct *vma=
, unsigned long gup_flags)=0A=
 	if ((gup_flags & FOLL_SPLIT_PMD) && is_vm_hugetlb_page(vma))=0A=
 		return -EOPNOTSUPP;=0A=
 =0A=
-	if (vma_is_secretmem(vma))=0A=
+	if (vma_has_no_direct_map(vma))=0A=
 		return -EFAULT;=0A=
 =0A=
 	if (write) {=0A=
@@ -2724,7 +2723,7 @@ EXPORT_SYMBOL(get_user_pages_unlocked);=0A=
  * This call assumes the caller has pinned the folio, that the lowest page=
 table=0A=
  * level still points to this folio, and that interrupts have been disable=
d.=0A=
  *=0A=
- * GUP-fast must reject all secretmem folios.=0A=
+ * GUP-fast must reject all folios without direct map entries (such as sec=
retmem).=0A=
  *=0A=
  * Writing to pinned file-backed dirty tracked folios is inherently proble=
matic=0A=
  * (see comment describing the writable_file_mapping_allowed() function). =
We=0A=
@@ -2739,7 +2738,6 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 {=0A=
 	bool reject_file_backed =3D false;=0A=
 	struct address_space *mapping;=0A=
-	bool check_secretmem =3D false;=0A=
 	unsigned long mapping_flags;=0A=
 =0A=
 	/*=0A=
@@ -2751,18 +2749,10 @@ static bool gup_fast_folio_allowed(struct folio *fo=
lio, unsigned int flags)=0A=
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
-	/* hugetlb neither requires dirty-tracking nor can be secretmem. */=0A=
+	/* hugetlb neither requires dirty-tracking nor can be without direct map.=
 */=0A=
 	if (folio_test_hugetlb(folio))=0A=
 		return true;=0A=
 =0A=
@@ -2800,8 +2790,9 @@ static bool gup_fast_folio_allowed(struct folio *foli=
o, unsigned int flags)=0A=
 	 * At this point, we know the mapping is non-null and points to an=0A=
 	 * address_space object.=0A=
 	 */=0A=
-	if (check_secretmem && secretmem_mapping(mapping))=0A=
+	if (mapping_no_direct_map(mapping))=0A=
 		return false;=0A=
+=0A=
 	/* The only remaining allowed file system is shmem. */=0A=
 	return !reject_file_backed || shmem_mapping(mapping);=0A=
 }=0A=
diff --git a/mm/mlock.c b/mm/mlock.c=0A=
index bb0776f5ef7c..506452ee8cad 100644=0A=
--- a/mm/mlock.c=0A=
+++ b/mm/mlock.c=0A=
@@ -474,7 +474,7 @@ static int mlock_fixup(struct vma_iterator *vmi, struct=
 vm_area_struct *vma,=0A=
 =0A=
 	if (newflags =3D=3D oldflags || (oldflags & VM_SPECIAL) ||=0A=
 	    is_vm_hugetlb_page(vma) || vma =3D=3D get_gate_vma(current->mm) ||=0A=
-	    vma_is_dax(vma) || vma_is_secretmem(vma) || (oldflags & VM_DROPPABLE)=
)=0A=
+	    vma_is_dax(vma) || vma_has_no_direct_map(vma) || (oldflags & VM_DROPP=
ABLE))=0A=
 		/* don't set VM_LOCKED or VM_LOCKONFAULT and don't count */=0A=
 		goto out;=0A=
 =0A=
diff --git a/mm/secretmem.c b/mm/secretmem.c=0A=
index b59350daffe3..c1eafe29c3e8 100644=0A=
--- a/mm/secretmem.c=0A=
+++ b/mm/secretmem.c=0A=
@@ -134,11 +134,6 @@ static int secretmem_mmap_prepare(struct vm_area_desc =
*desc)=0A=
 	return 0;=0A=
 }=0A=
 =0A=
-bool vma_is_secretmem(struct vm_area_struct *vma)=0A=
-{=0A=
-	return vma->vm_ops =3D=3D &secretmem_vm_ops;=0A=
-}=0A=
-=0A=
 static const struct file_operations secretmem_fops =3D {=0A=
 	.release	=3D secretmem_release,=0A=
 	.mmap_prepare	=3D secretmem_mmap_prepare,=0A=
@@ -156,7 +151,7 @@ static void secretmem_free_folio(struct folio *folio)=
=0A=
 	folio_zero_segment(folio, 0, folio_size(folio));=0A=
 }=0A=
 =0A=
-const struct address_space_operations secretmem_aops =3D {=0A=
+static const struct address_space_operations secretmem_aops =3D {=0A=
 	.dirty_folio	=3D noop_dirty_folio,=0A=
 	.free_folio	=3D secretmem_free_folio,=0A=
 	.migrate_folio	=3D secretmem_migrate_folio,=0A=
@@ -205,6 +200,7 @@ static struct file *secretmem_file_create(unsigned long=
 flags)=0A=
 =0A=
 	mapping_set_gfp_mask(inode->i_mapping, GFP_HIGHUSER);=0A=
 	mapping_set_unevictable(inode->i_mapping);=0A=
+	mapping_set_no_direct_map(inode->i_mapping);=0A=
 =0A=
 	inode->i_op =3D &secretmem_iops;=0A=
 	inode->i_mapping->a_ops =3D &secretmem_aops;=0A=
-- =0A=
2.50.1=0A=
=0A=

