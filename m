Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80F7DD33994
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:59:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D57D96B018C; Fri,  5 Dec 2025 11:59:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE0B76B018D; Fri,  5 Dec 2025 11:59:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81D76B018E; Fri,  5 Dec 2025 11:59:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A141D6B018C
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:59:17 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 49CA1C019F
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:17 +0000 (UTC)
X-FDA: 84186027954.05.51E1A8C
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf15.hostedemail.com (Postfix) with ESMTP id BB2EAA0003
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:59:14 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="l/qT7i2W";
	spf=pass (imf15.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953955;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qx10YQyM1n7Bzq/TmzHM+nwXVd+92kjURQXs15/Kk1I=;
	b=PErsMlOCNpk5wHsya3pq5dS32JPuGOs3xjIBJDxaOr8CGnYjuIw9LqT1O/nU2OC+NS9m1M
	RjP7X3HiGVZzYCs4dQP1V7S7N/r9yr5ksHgy84s76hSS+ruYX2t/t5SaY0VlkL+DU77wfM
	NIYJ422aJybv/cvlXPeiHS8HFS5Wa3w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953955; a=rsa-sha256;
	cv=none;
	b=G3eBYg2D1FX+jPZyV0qn/LYTk80tx7olxODshFfEBJSLMYbZ7dwT948ocYKJOx35cSadpA
	BYgTBjZb2bj0SuuLklZ9ReZDlSONMVdAnbH/qjiR6iYfxKGwWrlsVrk4iY0i4FVRcAwZwg
	9gOlBDhVbXl/zjYUbcBSqx3/MZVmHoo=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b="l/qT7i2W";
	spf=pass (imf15.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953954; x=1796489954;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qx10YQyM1n7Bzq/TmzHM+nwXVd+92kjURQXs15/Kk1I=;
  b=l/qT7i2WgT/xWsWopwrRKZUvCpiK4aG8vaimI7m8efvsnqYAX+t5YzTi
   +payFcJxcN1FrkfSVkSSRPUdJ4+zDpuGpzlGNljieO3tW1mwUIORHnkhm
   oFkLUdlz9LPMGhgEGwXO4h6/BZ1RIKquv1it2BIDlIQFhEQ1M52Yz0mH/
   63ANTS6rkPahh1og1DoOX/NUrBYFKDIUXg1py9VsPnsuJbXP7h2Zyn96u
   BMW49rH54EBsWe+IXSHJwOm0MsdFJb3DQQhg1eAj28jcvvUv/xfxpn9Xs
   KHU9nJ23+vJ1yKpmXNQxDtFdbEXMHA9eUd9+KVzXsYBgMqD20fKwp/lL4
   Q==;
X-CSE-ConnectionGUID: 6oIRaqr8Rkuu7bomYo5Pgg==
X-CSE-MsgGUID: Du9SD6hVSkaAOIpNm4V2fg==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6191211"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:58:56 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:29292]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.37.108:2525] with esmtp (Farcaster)
 id d6b08ff2-69cd-4ef4-91c7-3c44faa72354; Fri, 5 Dec 2025 16:58:56 +0000 (UTC)
X-Farcaster-Flow-ID: d6b08ff2-69cd-4ef4-91c7-3c44faa72354
Received: from EX19D005EUB001.ant.amazon.com (10.252.51.12) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:56 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB001.ant.amazon.com (10.252.51.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:58:55 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:58:55 +0000
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
Subject: [PATCH v8 06/13] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v8 06/13] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHcZghwpwkQ2L3MZ0qB0yKOOmzCSA==
Date: Fri, 5 Dec 2025 16:58:55 +0000
Message-ID: <20251205165743.9341-7-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: BB2EAA0003
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: u47mdxxd7bcauqowhgcq39dymb1jsrzk
X-HE-Tag: 1764953954-872277
X-HE-Meta: U2FsdGVkX1+Q47VWK+KMbHkmf/HNwO7PDDK6fS5XwcYiUbvtmUgs8ZIaXXwf1HLL++z4f+NEZCtgzQrTCeCAgdqCwko2tLx2Rl4rgU3jUBsJTENzyS0rKrH2kZQBBqGQlO5WJG4pH3guPUS3gia1ryBVOM/T3r52mBeYDcbAwrhzErpyYJn9uYJTmhMa6vsixDEgDORLwFfzT/FFliQHKSI/HS74Llv3FpVr3IvYU3oxKmicO8uBG67PZs2tQCTKU+Uhal8jar/9RAvqlecOpqPraDFU+aEWMYCTwmONuqYDFXHglMY3hS6NQ9btOtcoJq0LhgQfRCLsnmwx0yz9z4hwlaEukjJxlUQaDOUGJqbWdVrZxLPQad7FKIMYDegpBXH3WFZow6JsgZhRAlDSgCnRojyCRVsbeJxeIig62cIn1re9CpB8VPwANeF1GrorXqxX0zYwwJqgOB0jtSvbloxsuPJIjbYfx6dKEt6MSJQuOH78N/lZHOB1x7Kuw/+T7VbmBIEbtwUfNkQDKamVSStwurUHZUCIP/yLAMEcRjzmQNoBvGeIQodfVhoYdO3O2UtVchQBwC9XuBFAgJAVn7MiZFS3vmWUWFsTTAMA4PSz0ci3RAH1PljNvy+pe1zBH098lNVlBss31A0qh/kb2xYWjFGU2JtM63Aezo/lIZjVxzK46LDIFVBsQurG8LxombUx/tBcPhabAyUPaRgu0Qh7NId8HjycctRzVMlsEUcEz+nolPqOE00wzWVkqhZoPIb63lpkuILTtsDr8vW5IcwL5I42k+HyENDHiSEahN4EUXIjV+g4zgt1HFIS29rSlSoT6kYjUTBrdoYxlz8wrDBabNDMd6zaDkxUYq0kvCuUHyfx+ibQUppC53jwetE8Lw94sq+I+YsLuVb86dMubXH+5/ULv6gV2CqgAVOU7PR+aup9QWkEgr4k6naZDFHDfVycUAGbRlCGAv3M756
 DVTT5uam
 o8f8fr+xJsip5VMyfVN7snERoxBe27GRlzr/whLw6g5MEQCdwNsjDySt9fbvbHl/tbj+RYsda5oWald6pwWplNJ5p4QogA5Avp0QJyEltVEE+RxFdj8C4lbUGssTGUDOxf2S4Dnq72Ox4XgnFLGs08wGqdcQgkDbhE3xZX2jLO7OE2qGGx96nNsVqfSbmPc3Etlszl9L72S2IhuywcjSalMV2TqcUAZR/cdblmXKf0MaHAud0FBZnRb9L44qmXq6jFoG6OE2lHlY2Sf4CqxIEMmxQSkgU7psMbB+n0WaaI1LZzghsUxv31c+9so2dV4EM6FngkvHvc6RH8cUtByOgX2oHzSF53oOXHPeaC4JcW8kOyLFP9AtpCq6OXU7PUl9k3ZGQFahT/PipU7dsXJtCL+em+6ZTYfnmv1q8CAX0RtBIuRk2g6ZA9h+bRv1wQQRjQgWD2rDu1V3orbmhiP8HaiUrnblZORbwviCs/vAHyn1ZYM2A7Q9f/Wok3h9f+qTetF3mJ+dOaN++q5c+ZxjEuXOQOU6CS1WADvdQZUNPWSMV5dU4xRZKfu/ugMKvUeHA/AadkMEzRHypCTDX4Vr8rQRWBurVUYdSE2H0iEWJD2xBEdAmn4rfHWPf5MhEuEYvYFKhVxpT1fkFkz0+9wQJvIQf6IFv0hYqJl+Rpx4M0qXd2hfUF+UNJKK++M/2sbyC4fLjaUZMTn9erieM8xum+ibaOcAOxwsefgmu4nq4++2Tb4RxvndSYxdXrqxH7DmBS6srJ4E1kgSUfD5KA4nq3cz57GabN+G6isQu2yV1zV6/1IE=
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

