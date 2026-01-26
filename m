Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 428FCD19503
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 16:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC196B0089; Mon, 26 Jan 2026 11:50:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2BE56B0099; Mon, 26 Jan 2026 11:50:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 864C96B009D; Mon, 26 Jan 2026 11:50:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 784D96B0089
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 11:50:33 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 51F67D3970
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:50:33 +0000 (UTC)
X-FDA: 84374703546.23.BE8C7B1
Received: from fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.176.194.123])
	by imf11.hostedemail.com (Postfix) with ESMTP id D861A4000B
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 16:50:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=QqWqKtDj;
	spf=pass (imf11.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769446231;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rs2OSpPUD7LW69rM0Y32fiRw8ksGft8hlxMn679P0dQ=;
	b=RIRUOlAXhWld3mrFpnRZLGeYBhbwO95wjvriHfo/fiKlIxPSsNda8UL7LeV+eX9yr3olpT
	ysRHTRIHrQq+ER3qcBSdRX81G2HVvFdmSLSYKG841CMRVFPjGOLcOflQuB6Yk0vsX5ErlL
	8lnWIeU77DmtbsAzhUqn8XOiq7qc8U4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=QqWqKtDj;
	spf=pass (imf11.hostedemail.com: domain of "prvs=479813157=kalyazin@amazon.co.uk" designates 63.176.194.123 as permitted sender) smtp.mailfrom="prvs=479813157=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769446231; a=rsa-sha256;
	cv=none;
	b=XNK6HOIu/+HGULZB//U8sSBObrgKAXG4OhWCYZ9sBjvXJOemr+mywYt5yr3cZ6fGWbGTOD
	W5z6/FmpjxO9FN/YH+9OHeblE68/PzH8hVi+D1QTgMwGWfea3MOP4U1AKy7A49BjNA0M4q
	CXpPBg4ePBaSlJ8T+yvoPf/NCP6pmzA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1769446231; x=1800982231;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rs2OSpPUD7LW69rM0Y32fiRw8ksGft8hlxMn679P0dQ=;
  b=QqWqKtDjDkPGnIxrwKRmBytjS8Q8YQnJ9a7/gWgHmWa+oLNCkMBGrV7g
   8QairDAg5oEgncvtlf2HYmK4T3d9wD6+tjhPYyQa0oMAbsWXkmQ013a/b
   KbI1c0d2DvHqZD3MYN+0mCeRPvivngdM2QoyykTgKf/8ShSjCP3BlLxBT
   nxKXnubZ8J5hcku9XYgKyru6JIs4VIVwA/AVILVxDp3HuQbTKFVrmxDRV
   f2nMg/OYKb7GeU19cR3Ns81LS5bWU0FtBwcxG6CoVdutkfzDzn1uuF9eP
   4JCSdfbEjhlIrJlA3JAJ57aSJLQvQe6Gn1XhSHybI6ut0y6AgkvFsCIFX
   g==;
X-CSE-ConnectionGUID: tfQw3dF6SUeRkOjQ65gfrA==
X-CSE-MsgGUID: /o96abYjSkCEh36gM1Jw7Q==
X-IronPort-AV: E=Sophos;i="6.21,255,1763424000"; 
   d="scan'208";a="8462640"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-005.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jan 2026 16:50:10 +0000
Received: from EX19MTAEUA001.ant.amazon.com [54.240.197.233:6667]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.12.85:2525] with esmtp (Farcaster)
 id 28592ed3-d374-496c-8ee1-bd4e5c4b28cf; Mon, 26 Jan 2026 16:50:09 +0000 (UTC)
X-Farcaster-Flow-ID: 28592ed3-d374-496c-8ee1-bd4e5c4b28cf
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUA001.ant.amazon.com (10.252.50.192) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:09 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Mon, 26 Jan 2026 16:50:08 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Mon, 26 Jan 2026 16:50:08 +0000
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
Subject: [PATCH v10 07/15] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v10 07/15] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHcjuPUUjWyeqat5Ey1EmCCP9Dgog==
Date: Mon, 26 Jan 2026 16:50:08 +0000
Message-ID: <20260126164445.11867-8-kalyazin@amazon.com>
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
X-Stat-Signature: ybja9dwugk41dgb4atjnpjfcuh6zmjdn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D861A4000B
X-HE-Tag: 1769446230-636629
X-HE-Meta: U2FsdGVkX1+ErlssRJtAR0AD31pyLh1U+cYd9kpJvO4AOb4B6oMnliWl5wKa56UA5hoTs2bSSwXAdT5JvYkQsYdURsw/1yJeh8HmnpHNU8iBxsnyogN9NcpEU8IT0c9mf9vKlVxWWV6MRi/6BeR4xm2Dormt9ySGcCgUnDXdsZcAJRsbX6JFf20y+kMAH+rsngQ8k/JbHSs+8rQ4AD4UEXeYZYfy2WII4LfhG/stXY1x/9OdQ4dn+UnvSE8gEoiceqKIcvQCF4NfNkLQqS+4zetTVRlXzEJurRCWIHiO1QGaP2OJBzanjxqi+RKq2ipqV0XGjrx6KBTKxfkhTRKZFPghhlrbZIX/+NAegbNWvaM3PIjifhCN8bCTaE8nlUwHiOc9UzOV9Q353mjzfsUh/GdB17QeQf32t5nerb/pd4Rw9gvDdEz9aNFtjTK/EA28s//Kn7Iem2FyUqQ8Kzvtr1cWUbl+t5GTW6xCgfkopgNGEj3pbQZH5v1Gf9Dysxxw0Uh1au0Qk4iEZxe6IWY5eS1SomhURu7qxCgthqr82KZOBDmxfcqtreW4VbVWmZnisEjPa3/i/9hLhZijPOkevGRAKaA0UQiCFih5UGnsgZtU42XTPaD3Oo3e568gJohY63DIavflRTcPS6wiUxsJYaCpVDduyM4CS0IyHO1c4CxGe3o3gA3q85jZMCKr1gGlYNh4Si1eaggXI+wEgjNJvf75Dv4HPmtJmPjeMBzjJb5991XWaDoOkn+Rwn0k0grShK4GgIPWFMUsHz5Y+yJ/ql9IXlThdSgdXzen9YqN0cKzEXSD8rpIpa0HpFnEv0lTjwzVU7rwqS8vXybSufI/BJtPmIbMK6zEox0g80g3FrIPQK2lwab30d5V1gF8KWsGatnDYf2Iv2DzLGh8bnXPp9gmqf4J95xsZcVm6C9fqFBqVo0RA9dFYP1YSU4iTUUCG+R504OLFDwM8ikSExK
 8TPN2Jch
 auo8hph0NLLLGBvQmlinfOF9WMsqU5+HvOCUwobGLCOy5SjGzcqVJayOPVyOg1VwEK+4X/Tr/n/SKUwF887IaA1NUKkEhnfRjrf91mEzjZtWw9+G6CJ5apMuycEn/2HUyClFFz/0FYwMa05lgAZGl2+zqgOWSGwoVgTtMHVLiN/4KueuG/WEGGZUoexJsXjdgtbZjiGRlepZLXZ2PcxUPG43fawIt88chHxuCO5eT49jQ3V1idNs6Cy7jvewH90ob9G20KT8FPoI9so6yQYwkbPWKoK0JmxY5DkhiSpaehEadiSg1ZVcBz1y1kqlhrnqXZ+WuIzMuOmr+VSWiRuy5EVEEUDpnh4xfkNcIfosFkyFKHk99pFSJJUiqhJhmTqZVsGipO8pWO3LCe/QRmgOlic18wr4thzTG8KtZEexGUohBTb+UU9Zo6RFf+J8TMr4Q+h8TokVtX4a7bsvGcaCsltuwMf6RhyoNdjHJoaHDkVS5zNxBs+zqAr9s+em1bdkNRTVsBj38tCJU5C4isW6W267aAeeqslNyUTHcKd6M0DioRUTT4k3sY2l+iTozu4rDn1pzheOxjQiRUorbMA7za/mDDb1NYBlwHNcJJOqpxeJSN2xyw6P9Wt1SCdZhvKfZ1Y3cTSAhK9bIs3GBUzuKodG8ZlWtA+N4aJG85KjOxT9pD0qy7ROVpQAQA56c2j7FwIin5H/ZyUww7ymED4WYCzy7gOwR0jEU+hfPjWQ6r/bztWRft31r+2yM0JlmKLnMO9UGHloGlL1h18bVPEm1nCQjvQoP23f19TG6N/IWf6Gsq7Y=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
x86 supports GUEST_MEMFD_FLAG_NO_DIRECT_MAP whenever direct map=0A=
modifications are possible (which is always the case).=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Reviewed-by: Ackerley Tng <ackerleytng@google.com>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/x86/include/asm/kvm_host.h | 9 +++++++++=0A=
 1 file changed, 9 insertions(+)=0A=
=0A=
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_hos=
t.h=0A=
index 5a3bfa293e8b..68bd29a52f24 100644=0A=
--- a/arch/x86/include/asm/kvm_host.h=0A=
+++ b/arch/x86/include/asm/kvm_host.h=0A=
@@ -28,6 +28,7 @@=0A=
 #include <linux/sched/vhost_task.h>=0A=
 #include <linux/call_once.h>=0A=
 #include <linux/atomic.h>=0A=
+#include <linux/set_memory.h>=0A=
 =0A=
 #include <asm/apic.h>=0A=
 #include <asm/pvclock-abi.h>=0A=
@@ -2481,4 +2482,12 @@ static inline bool kvm_arch_has_irq_bypass(void)=0A=
 	return enable_device_posted_irqs;=0A=
 }=0A=
 =0A=
+#ifdef CONFIG_KVM_GUEST_MEMFD=0A=
+static inline bool kvm_arch_gmem_supports_no_direct_map(void)=0A=
+{=0A=
+	return can_set_direct_map();=0A=
+}=0A=
+#define kvm_arch_gmem_supports_no_direct_map kvm_arch_gmem_supports_no_dir=
ect_map=0A=
+#endif /* CONFIG_KVM_GUEST_MEMFD */=0A=
+=0A=
 #endif /* _ASM_X86_KVM_HOST_H */=0A=
-- =0A=
2.50.1=0A=
=0A=

