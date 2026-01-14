Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4B9D37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24986B00A2; Wed, 14 Jan 2026 08:46:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE4036B00A4; Wed, 14 Jan 2026 08:46:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD30A6B00A5; Wed, 14 Jan 2026 08:46:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE5D06B00A2
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:46:26 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E80A1AE1F9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:26 +0000 (UTC)
X-FDA: 84330693972.22.7AAAA9A
Received: from fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.199.210.3])
	by imf14.hostedemail.com (Postfix) with ESMTP id D4FF1100016
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q3l8nJYO;
	spf=pass (imf14.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398384;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+0YCRdTDnWSs97jpjMZOSlIedfR2zbQnGU/yn7jp+s=;
	b=x3z1g9h0UUqO2GpJZIGFj459IrSs8xuNQ4G/ULlg+L9H5jVS/KSGYzVv3JvyYaFHu0PxWS
	iASIScFefFWo6wA8syMfL7SaYMr6xSr7TqEw46l+07I0/Lrjt3uyGmESMYP+4/3rucyA/A
	c0mbC2/c2R3mbIcK12VbTWwOh7EpQpo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398384; a=rsa-sha256;
	cv=none;
	b=7yWqHMjojIQMJ7tHPsc4DQNBE4ag7osZQwFXAkbYOt3Tfjo72osmqVuxpKeCVAAFT+Zi37
	dOyswLnkKBl5+C+kXlGAN1S2DChS+gQ7r6Naqj6/u1kXtRzGxTrRBa8y3wqqH9296rGhOr
	yW7L+9Oea9oeFU9fSk14QRnyvctP9tM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q3l8nJYO;
	spf=pass (imf14.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 18.199.210.3 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398384; x=1799934384;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z+0YCRdTDnWSs97jpjMZOSlIedfR2zbQnGU/yn7jp+s=;
  b=Q3l8nJYOAyhFDrvWDn2Gx86mJMtS044ywk/AvdJH/UmZMj4gM33ML05m
   5BN2hBx8PvN08L1Ez4SjtpAitce1fKChMs/h3hV+M/qwzZHfwn5PmDxk2
   0nLHkSmj5xqGYRXR0T/januEkpPLfxR3n8bkKelYsAqpWoQAbNnx4KqKw
   +MNcwf8Q3lV+Ib9J7ULRrX8SQ/YR3NCXNjQmKyzjjhfBTe6B1mmzInyS3
   X2/oTd29BfugVD5bsKYjSqcCTTDNfrSriuqfFhO22E/+SItDNR7amw9G9
   5FFM9ySNi0RNld82eURuE538xzLkb3sYq3dTjp9ScgzcKEzlB8CVzSiYU
   Q==;
X-CSE-ConnectionGUID: XXxyITF9Rw6G0U/xRLGdXw==
X-CSE-MsgGUID: /aFraT7BTL+DRqLIi0LPcw==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7804606"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-014.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:46:22 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.228:20934]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.3:2525] with esmtp (Farcaster)
 id 62714440-81e8-4fb7-aff1-a3fc1349bab0; Wed, 14 Jan 2026 13:46:22 +0000 (UTC)
X-Farcaster-Flow-ID: 62714440-81e8-4fb7-aff1-a3fc1349bab0
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:21 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:21 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:46:21 +0000
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
Subject: [PATCH v9 06/13] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v9 06/13] KVM: arm64: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHchVwqXAUms8uaREatvOc5mFxAXg==
Date: Wed, 14 Jan 2026 13:46:21 +0000
Message-ID: <20260114134510.1835-7-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D4FF1100016
X-Rspam-User: 
X-Stat-Signature: fx3u4g69z6cs37qree3huagt46wcigup
X-HE-Tag: 1768398383-812752
X-HE-Meta: U2FsdGVkX1+RqxNM4ZO/J4bBUw7U7I5Xzum3XTDD/JXe2+GLqB1g6bkqg1e4U0w8kQQ7WmbnAmkulDLFpB7wQGH3sV0BmBPOcgAtJb3pJYZeHsB9ruEUrk3v/cWeuxOIve+87jIggT9OQOckNwWjG0d7aWEUx2ErcPTiyCOrQiq4/2YpOosH8uCxGVC+i6DTOBWMkbthass3h9SOxrcZkQ8F7/q6qsgaDBUri7AtQGKW3bPJ18O2G37DB+aEJufyEYJyq2phYuTPViGbgNh0TwTrnPbIWYsrskA8jtb2jc5WLYw0S1hVb5hohS0TUDwTUeslC2fsXYprr2mFDCJryX8n9n1CNBvBRSpZbAjhlBhtY0W8xomHrz55AEBxzXGg10EatgfObXfKxy8PE6GTncvbTsrzKfceB8P/KcN8iE41OwCcsL+kwlosKCFxkU+VEit20b3PH7FOA1osCQ5C/r8bHMKTXxVxBMDdz67gPAZrGQ0xQoffR2YYs04lbUh36oH3XMfVKm0hU2hZfTfUeoY2V1nCkXWYVRDJkFcPO29TI6RGaqENy0h8hhfN3++qBy5bnAqm6o6hIuurQjX2Mr3fPch6rXoAlf41Jiuzgg7gRwOn/sj6ScT5OKydN8siFJOncaI0flUZAlJOSc/NE3fZVrtLgJLcpVjyX9HwZO25vi0CQIkF3opEXUGP4vOLIO+PNqFCcS5WtMx85u+b0wK7eyNv/467U+ZTEJ2NjWDImH1+MmgH0u0gPkaDQSr6PmrI6T9gPr6N41FtjdR23P6VY5w4uhCMdix6V6sW89eawwMOJB23cqTyZBTE8iUMFVsio7FguNCR126vptxQY87HEZn5SpgLU0oj6nsi45lfWHBKtGPRjVSXObSFrEJtd1N8MFffEUvwsSlfk6mJEdbeI2gnW2A+qyZ/M/gkxaCUf2keTjWx6PdbLFqfgMHz00EUk4eTE2WNhioyXbb
 p/pbBI6q
 f8bF8zlWHEzAQNkRr+tbQMduVQMftld5/guFSfFkZj+dLldVaqkqFA/t3JVvWIdSX0BiaEg/vExrsCDjkn3QJaLxuWb0/5JXHygpbeG/PjtDdg53cDGb2eFzbga+1VEZgrBEjYd5hWc7J+CN7mAyfhFxEIAmoEsaSgwvMtwBTmQ+W2IwVG0dn9JVAJQ+RTsRTqerrYNJgB9RMyphUU1XHNCKp6/mfMfON5nRoEo/MRjTP2yd4RsYfDqvJFru3f0ZlfiakhiTs/N+Az5JZfbak5CqqcdjCPFxosabrEeSXQWx1Vb4f6laYo68OdiMR86+NPulf8PINFd7j5/r7G+1FQwSi5QlQIpdgFUaT5pZRC7jXF9c8spOv0xCHe9LZ4dIvLBRQdDWoT76jWRKCV+t7T10BbG/eM22WPzUJnO+2ANYVBzTPIx1nzDn0/A+dHfOULRRXDj45AxaYBmqKPsb51QqavnsSQ1y7KZOgagWwYZEz7oyv32vOhjTOXdwm1cOD5RU13euu2pyp8ec9Oy3FFlWQ2t+38riQFU2MUC1M/ZGwbH+sXPs4HGyBkuLdlEZaCfJifh4AMRfPgC6IDsIP1vhsau2R+zkpDH3Jfb3ytTqajEe8RXoDMDwsgWqh4HvrDAGayr7InRLQM4sDNzesGcv/Irjy4DaPOcF/u0ZUu1VpzytS3ERg3jM1N4TgVuVWrvOloi2776Hew9A5bSyPlXVMsrTwRqQXXjWAWMb1435Mo//yBbwYdDlDrKpo5Srg0MzrudcFrIhsQVwf6sOIhYP7lDCiBEDciAYl
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Support for GUEST_MEMFD_FLAG_NO_DIRECT_MAP on arm64 depends on 1) direct=0A=
map manipulations at 4k granularity being possible, and 2) FEAT_S2FWB.=0A=
=0A=
1) is met whenever the direct map is set up at 4k granularity (e.g. not=0A=
 with huge/gigantic pages) at boottime, as due to ARM's=0A=
break-before-make semantics, breaking huge mappings into 4k mappings in=0A=
the direct map is not possible (BBM would require temporary invalidation=0A=
of the entire huge mapping, even if only a 4k subrange should be zapped,=0A=
which will probably crash the kernel). However, the current default for=0A=
rodata_full is true, which forces a 4k direct map.=0A=
=0A=
2) is required to allow KVM to elide cache coherency operations when=0A=
installing stage 2 page tables, which require the direct map to be=0A=
entry for the newly mapped memory to be present (which it will not be,=0A=
as guest_memfd would have removed direct map entries in=0A=
kvm_gmem_get_pfn()).=0A=
=0A=
Cc: Will Deacon <will@kernel.org>=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/arm64/include/asm/kvm_host.h | 13 +++++++++++++=0A=
 1 file changed, 13 insertions(+)=0A=
=0A=
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm=
_host.h=0A=
index ac7f970c7883..d431ca7d4fc9 100644=0A=
--- a/arch/arm64/include/asm/kvm_host.h=0A=
+++ b/arch/arm64/include/asm/kvm_host.h=0A=
@@ -19,6 +19,7 @@=0A=
 #include <linux/maple_tree.h>=0A=
 #include <linux/percpu.h>=0A=
 #include <linux/psci.h>=0A=
+#include <linux/set_memory.h>=0A=
 #include <asm/arch_gicv3.h>=0A=
 #include <asm/barrier.h>=0A=
 #include <asm/cpufeature.h>=0A=
@@ -1654,5 +1655,17 @@ static __always_inline enum fgt_group_id __fgt_reg_t=
o_group_id(enum vcpu_sysreg=0A=
 									\=0A=
 		p;							\=0A=
 	})=0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+static inline bool kvm_arch_gmem_supports_no_direct_map(void)=0A=
+{=0A=
+	/*=0A=
+	 * Without FWB, direct map access is needed in kvm_pgtable_stage2_map(),=
=0A=
+	 * as it calls dcache_clean_inval_poc().=0A=
+	 */=0A=
+	return can_set_direct_map() && cpus_have_final_cap(ARM64_HAS_STAGE2_FWB);=
=0A=
+}=0A=
+#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_dir=
ect_map=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
+=0A=
 =0A=
 #endif /* __ARM64_KVM_HOST_H__ */=0A=
-- =0A=
2.50.1=0A=
=0A=

