Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A911D37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80F0E6B009D; Wed, 14 Jan 2026 08:46:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0F76B009E; Wed, 14 Jan 2026 08:46:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B88E6B009F; Wed, 14 Jan 2026 08:46:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD296B009D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:46:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DB007B8C47
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:15 +0000 (UTC)
X-FDA: 84330693510.06.C12C451
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf10.hostedemail.com (Postfix) with ESMTP id 60AE3C0008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:46:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=q5X31jCD;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf10.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398373; a=rsa-sha256;
	cv=none;
	b=vrwrRGIil++k0B1e/WGWgTjJgDT0ogcrfQS+J6q1P8Mc3oP6UNE+EwFfje/TPD1rPv9sJH
	IyGFfzfPeBDmuIvbE4MhMslTpv3Mp38abt+wiHV/GCQzwRdp5egdr13VPM9Hi0+ca5nfo4
	e+X9j5y9uVV5bGttDTyHp6SvyG7MBCo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=q5X31jCD;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf10.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qx10YQyM1n7Bzq/TmzHM+nwXVd+92kjURQXs15/Kk1I=;
	b=Ym2s8dSQhLAP1chi4SnKO/wg8lkwOPZGYoGbRIvaSnaqXAIEJBvmTBqynX21IZHJxL+pvq
	1m//fo8bjXQ8O9sooAJjGDNVL24Z+wvDUaOxR0xYUK+mVvYduBoZ/4umAp1URyP+fbh8an
	qXDNW3qth5pCZWAi+9N33l23ZtA3BdE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398373; x=1799934373;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Qx10YQyM1n7Bzq/TmzHM+nwXVd+92kjURQXs15/Kk1I=;
  b=q5X31jCDAUZeR6O9yY4a9IymXf9IfLPOLwinL6orQBghoayDBUtQDcMr
   r814MvkhPTfhHZDMPdkUDm2J78JcKdAaqM99vt1R7gqdye5eSGK8FebqF
   72zbrNwMdHpua9cocX43Z9OAzd1N5JGaC6Fm3Jy2T0dO3m8syNJG9Wrls
   dhT78950z+nprZjdpR3GQEVu+mCabtAxSLEbLL3LHBn84cbbl8oJhL3sv
   fbtonHusciT1hvSRuCoAKdcAaOMLoHKbRQIzoTd1ptgeBoJ1fPusU8RZq
   DvPyi1ubYUBo79Qk4X7lIb91kS9IQznu8g6iGcqgHqOLzfwwvG1+WMSsn
   g==;
X-CSE-ConnectionGUID: 6F6gMhRMTLC+B19uMUHjbw==
X-CSE-MsgGUID: nq2OO95sS4WesM1K/I1Kjg==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7899040"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:46:11 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:23123]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.3:2525] with esmtp (Farcaster)
 id 646304cb-9c48-4747-8d9d-d4686df9ea29; Wed, 14 Jan 2026 13:46:11 +0000 (UTC)
X-Farcaster-Flow-ID: 646304cb-9c48-4747-8d9d-d4686df9ea29
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:10 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:46:10 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:46:09 +0000
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
Subject: [PATCH v9 05/13] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Topic: [PATCH v9 05/13] KVM: x86: define
 kvm_arch_gmem_supports_no_direct_map()
Thread-Index: AQHchVwjbMmxqTepZEW4NnK8Myz8WQ==
Date: Wed, 14 Jan 2026 13:46:09 +0000
Message-ID: <20260114134510.1835-6-kalyazin@amazon.com>
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
X-Rspamd-Queue-Id: 60AE3C0008
X-Rspamd-Server: rspam06
X-Stat-Signature: or36mknpyfeqrq5yiaq7cp78eifr4xhs
X-Rspam-User: 
X-HE-Tag: 1768398373-610419
X-HE-Meta: U2FsdGVkX1/bCyM3wn2ZqiQOMMj/kWn/ghtZPZ+qVYYBlFE66AqCJOcQegsYQ6+lv6cf6vFjNKUQr0CMlJ+ACtoNAGwIlHh0iHW62/ssf9jdXRjS3mO8+SDH1P5NdzQaa6CWeqRzyW/BCb/g21Z9+131LR1Bm63zJmI9w7QflhoKpbjuebIZDUvIbcPxmbbJoxfpOiODsIo9xHyNMQ9HRREwzT2HBv2bfeqOUYN31XD92iFIPiRUqmlyOaBqaTNsun/UjbfM3fk5fSf1lGp+ep6G140WxljRAnBnAZxStXghEzayR1BYs8uqssdaPACgM0bTE0W1k3RqMRAGLvdVHvIX+k5KyUEeZcrYxixWGJ/Y8GpV5a5NSCLrTLy5WWhuyHxMtwlCLyiZY0ycntnBB6jbKT2k4uqAPRrTLbQKeUIpZQRuYz+uL+zAmPb/xeI1paZGNZqcebtwu2w4kAyGhZR6feO3M64VcvYFJaJSQ4mHi1dU1Ub5i+P6ElDJTz7fIaowcxGTDOsxcECzWloP73riF2CyZYa7VIAM5qg7MwNd5QUW2/tr0By2khARKBcSsqfcGdBGQPeVHzGOcr7oxbp6Aj18fBRbZLoJB/XZgJOho75/leGuGjLa/ivyfstYQuJyKUx9HuF92QTdrX3QLeu1y4IlyS0GywcHvSBw+q328SBujzwkvbARMNKu07ytszNSEubw7piYNEFJZHlf6fEjpLNzfZv7XK++GQEtvY4yW12u81AXfT4uHmCyExjnQlZWbF2o+cliI0+GbNF8D5ZYJDV5lQvJQE7thCbyVGweGIPQTcbOJMyTDaq1TfqXaqzcgrKLC3rSmxoifaGg1qv4RkSo1Dm3atqrF3RlAdSeIxRvKw2mOzriW/PMKkQJ3ikDdWl8AekzceSw/rR0PrGgrhDerkNmZgqs9wy7waZpQjE5r89SkhzpEelM2Wh0KoCKwPUcFPomOaB/bH6
 7Uo6nayZ
 qZHFipg/mUHNrgVQmW+d/9duoFGOeEae6NtffyUEZ3lJbGCOMqat54Qd8xkRFteamTIOL/e2R5UL97mHh8hRt9V6SLEmf/mtXZn9P7Ww5TGvJfgaYb/W9DHoqXcEJrZ/um0XgG1U9gazbTQKhhGaf83G3pTnR4PVX+YkedxgEnxgJ5Ts8CKSNsH8aBU0GTaMa5SUGjB8Z2BpZ0GBDyYuJgi96r4aQmOcNV7ewzrj36NYxpfc2Eqk9kyF+J9dYa1bPgW/StayTuo8eM6EtAjcRr/cxrFzzQ8UGheoDSiv50A65NQ+BXpkNGUPL0BO+CaZ6PiKeaxuL/fC5N9/hs/P+lXN6aEXyToqmDXtfLeuQUURTR3z0o5DaH9wmyLANqxZpaN18iTCJB4q87xVleSOMivzVFr66gHJh8xfrQl0VScr1TTCM6KdxbfWxnE28ejcfidR6dKuzQk6x6UCuhOXUeN0nZHb/xBvW5nOB4OEv8F3ehzpwv5qtfTSPvouactV80DA5zCwuVKCAMlVRGcAhKkU87kdNXj9edG7lyPSkKHn9SBkmYCz4YjWnnc8zYTH+DnLFP+1MCxwQg45InWn2i19Mz6DXzDIeSklHkrahg6/enS6mgPxGshbM0DUWMxi0wBO0cfXG6/p3Mw2NycxwyfWOx23LxuExVMrUAkhLXyMlf9NCkTkfJJ3QMeLe31vLyRG9RZ9081vTLfM8vnT6tZ9dd6OhhaSvxPhuprnfb81jsj/5JiY3YLB4BvUwxV4QzWF3
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

