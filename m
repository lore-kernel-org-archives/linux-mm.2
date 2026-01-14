Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0630FD37E37
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:45:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 372EB6B0093; Wed, 14 Jan 2026 08:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FE06B0096; Wed, 14 Jan 2026 08:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CA856B0099; Wed, 14 Jan 2026 08:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0BC2E6B0093
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:45:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A4921B9E9
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:45:35 +0000 (UTC)
X-FDA: 84330691830.18.162EFDF
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E7BB1A0011
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:45:32 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VloJZhBE;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf19.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398333; a=rsa-sha256;
	cv=none;
	b=jRkXFhDI7BebpiyKUZ89duhpGyRSHeEMwu8QJneTrdYVMXpEUsKNz0xirMuqA+l+sULK5M
	eC+OB91dbyOkOcsQK/dsh8/6+bL/5FbNyL3PX7N9bpAQHIn/xLGvlT+tjmGRBJzWMDNooT
	th9R7FYlOryFcZAgizj5CfPsPlXAFLE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=VloJZhBE;
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk;
	spf=pass (imf19.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=C5qlMH/wtsmcLk6SljUNTD3DCGuIp1OApZnkGozlYCk=;
	b=NbHshKpxuGgvLWM4uKkFONUGKHco9pyGbOZsMlmNX55H7byDGPDbafFyxnP0chB2QbU2xP
	Oq9r2ANOAv7Q7+VdP3YYSx09joLa9gvQjv1WqfVnXuTpK/EnR9YopFz11ZYRegVj8ngwgE
	jBIQpbBumheqs/0uzEyDylAiX+Efat4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1768398333; x=1799934333;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=C5qlMH/wtsmcLk6SljUNTD3DCGuIp1OApZnkGozlYCk=;
  b=VloJZhBEIDg+bEhn4OECS6+V/c0FMnI0gF4kd1Z1oy/GvPbpr3AyLk6m
   Qf0JBQyFt+gTVL5at5VxL75JZ91k4f1YsBzxen6OV7fgmtO3Ufmh/0F0J
   oJW2aGcLro/WGxYW42yQqLkAXnwcmTLm8s7wDSla211Of0RYHOaBLmjM/
   Wh3rCrRXjW+829ff/7qlLQ91vWJEhh1V2YEftqOlxch/7hacvAhCUj/c1
   opgMiqNafvLDYjLUyuR/9ke30eIk/M4EEnmvTPXBH58fSVWiaIJTRZvs6
   mML599ZRCOTNGzERpKM8fK6r+SJ74NHlrQ6L1Y5zPLH9A0cx7jIS57G0z
   A==;
X-CSE-ConnectionGUID: cAS/p1IlQ+6brG6UAGBozA==
X-CSE-MsgGUID: 6cYb4iAZQq6KhV7Q0e9uwA==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7898964"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:45:13 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:25244]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.2.33:2525] with esmtp (Farcaster)
 id 4d53a730-c517-4321-8200-fcfe21696f25; Wed, 14 Jan 2026 13:45:13 +0000 (UTC)
X-Farcaster-Flow-ID: 4d53a730-c517-4321-8200-fcfe21696f25
Received: from EX19D005EUB004.ant.amazon.com (10.252.51.126) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:12 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB004.ant.amazon.com (10.252.51.126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:45:12 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.035; Wed, 14 Jan 2026 13:45:12 +0000
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
Subject: [PATCH v9 00/13] Direct Map Removal Support for guest_memfd
Thread-Topic: [PATCH v9 00/13] Direct Map Removal Support for guest_memfd
Thread-Index: AQHchVwBJodCfIOOzk6JfArIPtu1ug==
Date: Wed, 14 Jan 2026 13:45:12 +0000
Message-ID: <20260114134510.1835-1-kalyazin@amazon.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [172.19.103.116]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: efc1m14ztdy35sk1ykynp639yq85ssb6
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1E7BB1A0011
X-HE-Tag: 1768398332-726185
X-HE-Meta: U2FsdGVkX1/AT42QIrlgKFcUsLOG1pN0Ov//C/pAm1N7wlvQZbhayh143YKrXdU3aouZnkmonWzma4j66QkOqyjiQ7eoIoRFMFwTlHPodblZqg/iLDaZ8tkjp7sKjF49d8Aq3REpRAhANZ9xg7UDBf3ON4SdKHC996bhkdk/t4U4pB3mlBfplr0lHXNxyyLoxclOUgdGet7FognZHFax3r/Kx5US4iuwPerOxGjLAu7zbM+EnsHVLPa0sD+tTcVkuyCNmzvzgMAOQZsODMmAt+L6CyCShnKpwLhQ7nHFfo2dcaLUHsTi8EX7jN0Ji3/ljxLK/J8aNZbyMxTxYRTVvIUjzxfcBGpJ3S/rNtgzi/fo4nVLoknAWzQiIJVDEC9Kp2Thgxd5mRT4rE/0KUSN+O7IJ3u/k1fR1PjXhi//vxxcx0OqzCuLxPgyfqNeAmC79FFo+B6nAKMngoYRKwNxTuaQ7yTGZTAtk3qXll6ghe4wvnX1ZIHFfkGn5vScDADD0tymFTE9zHaAe1f5e5nTv31dEHU9mjrvsvdYhrmdVzP8AgfaHzgHsjlxdhutXVRvxbQj9NLlJIvhnIiyv52zszzDKJWyml9H+3p+0uJ/Co7KIz/3hLImRM9omH8Oc9GG3zfwGCVpYohn9df0qKKX/tU7Dv0K6oP1MzYw7EQm8oRsFs8O+tGN1eIlE6c4vajkrilOXD2iMxl/eJ8gD9OHHxm4lxz6z50PVtAVdWtE02wkj/umNSVWG54k2PB3sYUv+X5M6nk9aUFoSLtM+VrDLsZOV4ivCBJqjr7MwkH5mZm+lRH8REFmP3yMHUzqPypk10p/fld5KhZIuku4HmayKOTlY0pqwPGixH39rJqQ5brtzgcTxtsTSN8Nq6/ig2HFrd+96r+0PxJsDMl5iJyjqrq8mLwZrjXvnMBMeMt5WQfOoe4UXWDTMXCeWuakRgGCIk7BOrBfobnbPuBzk3J
 nGW173GP
 SCU9a9iZ1steywwsM/XycmjyZ1MpRaalJr3CK2vVBPGKiePBJBqvr79Fx2WYlnMCJ2JSHMnmdgf/e490uu9nd48QOYBupMKIiirWRtJqtnKl7cmZ44CU74flRqrrEvE05eJGC7LyLjGT5x7TQy1P9XHE+iva4oYg85Q8VVmhc7npame98GUCMfgHP393W4st5HjqOulEXjkd9mnC5Z4UupSycRPr+PAZyin6+rfOUjkRU34FJDQthrS362QaXJXgPxjM08ypoRo3Ajty5Wy3A1WQinkD+9e9e4jhA5ULHBGYkRVLMkrgHt1aifLLumV/Fg/pdKpNY6K8IsKbbo5JSxvLw82Y9TCnVTEzaWxfwzCsr2o3zYhJxMMxQphgiM9r9pfWdeaUTxUgcIblYWgBdtoTIvjNhaspSPGdOGpOwww3OowSjGErjJEmDrxxo/wFjRwKQr5YMyMCfpFvJb62BqVN4n2p2yft0fKl1rhqEaVWJOYKfrltUrJ90C/wajTGTc7JYR4RG56H0oI5702hZvF/6oOqp0PkCeSHC5K38qIMezUS9oMG/xWyM0B3wxgBhT/GGgmg0HYS955+KT44JwwT1v1dP8cYWv/CEfG+nte1gTUAnOOJb/vNuEmJtbKRQKY32K8vHOQZG6EWYoOEoJWjDunGFsL6brE2ABr/pdv8fZGDUpL+YXa5xvnJPStCo47ti6VrBrnG/MSSx9Bx9mH5j8R75ZTtSILYWyQ8YdJ3/Xbmc35mUPzvtvEKoiVSAjvwEK3Avgg/VsDEpw6gCWEYJfHN4RZHeiXZf38dleChfgOoaptQsjo9lruHrQLva5lALcQFDrpTOR4aJeCEBoQO29tUgymk8VJqXM84lxOa2l8Fqdoc4hRSF9kRQWXQOsW+IFmjPewePoxWfXFO9zCQgGPC4QV1QHzXqIMcT6cidZ8U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[ based on kvm/next ]=0A=
=0A=
Unmapping virtual machine guest memory from the host kernel's direct map=0A=
is a successful mitigation against Spectre-style transient execution=0A=
issues: if the kernel page tables do not contain entries pointing to=0A=
guest memory, then any attempted speculative read through the direct map=0A=
will necessarily be blocked by the MMU before any observable=0A=
microarchitectural side-effects happen.  This means that Spectre-gadgets=0A=
and similar cannot be used to target virtual machine memory.  Roughly=0A=
60% of speculative execution issues fall into this category [1, Table=0A=
1].=0A=
=0A=
This patch series extends guest_memfd with the ability to remove its=0A=
memory from the host kernel's direct map, to be able to attain the above=0A=
protection for KVM guests running inside guest_memfd.=0A=
=0A=
Additionally, a Firecracker branch with support for these VMs can be=0A=
found on GitHub [2].=0A=
=0A=
For more details, please refer to the v5 cover letter.  No substantial=0A=
changes in design have taken place since.=0A=
=0A=
See also related write() syscall support in guest_memfd [3] where=0A=
the interoperation between the two features is described.=0A=
=0A=
Changes since v8:=0A=
 - Dave: create new helpers for direct map manipulations=0A=
   (folio_{zap,restore}_direct_map()) instead of using=0A=
   set_direct_map_valid_noflush() to abstract TLB flush logic=0A=
 - Dave: add WARN_ON_ONCE on the error when restoring direct map=0A=
 - John: separate patch for dropping secretmem optimisation in=0A=
   gup_fast_folio_allowed()=0A=
 - Vlastimil: add missing clearing of the flag when restoring direct map=0A=
 - Reorder patches to keep the kernel compilable in between=0A=
=0A=
v8: https://lore.kernel.org/kvm/20251205165743.9341-1-kalyazin@amazon.com=
=0A=
v7: https://lore.kernel.org/kvm/20250924151101.2225820-1-patrick.roy@campus=
.lmu.de=0A=
v6: https://lore.kernel.org/kvm/20250912091708.17502-1-roypat@amazon.co.uk=
=0A=
v5: https://lore.kernel.org/kvm/20250828093902.2719-1-roypat@amazon.co.uk=
=0A=
v4: https://lore.kernel.org/kvm/20250221160728.1584559-1-roypat@amazon.co.u=
k=0A=
RFCv3: https://lore.kernel.org/kvm/20241030134912.515725-1-roypat@amazon.co=
.uk=0A=
RFCv2: https://lore.kernel.org/kvm/20240910163038.1298452-1-roypat@amazon.c=
o.uk=0A=
RFCv1: https://lore.kernel.org/kvm/20240709132041.3625501-1-roypat@amazon.c=
o.uk=0A=
=0A=
[1] https://download.vusec.net/papers/quarantine_raid23.pdf=0A=
[2] https://github.com/firecracker-microvm/firecracker/tree/feature/secret-=
hiding=0A=
[3] https://lore.kernel.org/kvm/20251114151828.98165-1-kalyazin@amazon.com=
=0A=
=0A=
Nikita Kalyazin (1):=0A=
  set_memory: add folio_{zap,restore}_direct_map helpers=0A=
=0A=
Patrick Roy (12):=0A=
  mm/gup: drop secretmem optimization from gup_fast_folio_allowed=0A=
  mm: introduce AS_NO_DIRECT_MAP=0A=
  KVM: guest_memfd: Add stub for kvm_arch_gmem_invalidate=0A=
  KVM: x86: define kvm_arch_gmem_supports_no_direct_map()=0A=
  KVM: arm64: define kvm_arch_gmem_supports_no_direct_map()=0A=
  KVM: guest_memfd: Add flag to remove from direct map=0A=
  KVM: selftests: load elf via bounce buffer=0A=
  KVM: selftests: set KVM_MEM_GUEST_MEMFD in vm_mem_add() if guest_memfd=0A=
    !=3D -1=0A=
  KVM: selftests: Add guest_memfd based vm_mem_backing_src_types=0A=
  KVM: selftests: cover GUEST_MEMFD_FLAG_NO_DIRECT_MAP in existing=0A=
    selftests=0A=
  KVM: selftests: stuff vm_mem_backing_src_type into vm_shape=0A=
  KVM: selftests: Test guest execution from direct map removed gmem=0A=
=0A=
 Documentation/virt/kvm/api.rst                | 22 ++++---=0A=
 arch/arm64/include/asm/kvm_host.h             | 13 ++++=0A=
 arch/arm64/include/asm/set_memory.h           |  2 +=0A=
 arch/arm64/mm/pageattr.c                      | 12 ++++=0A=
 arch/loongarch/include/asm/set_memory.h       |  2 +=0A=
 arch/loongarch/mm/pageattr.c                  | 16 +++++=0A=
 arch/riscv/include/asm/set_memory.h           |  2 +=0A=
 arch/riscv/mm/pageattr.c                      | 16 +++++=0A=
 arch/s390/include/asm/set_memory.h            |  2 +=0A=
 arch/s390/mm/pageattr.c                       | 18 ++++++=0A=
 arch/x86/include/asm/kvm_host.h               |  9 +++=0A=
 arch/x86/include/asm/set_memory.h             |  2 +=0A=
 arch/x86/mm/pat/set_memory.c                  | 20 +++++++=0A=
 include/linux/kvm_host.h                      | 14 +++++=0A=
 include/linux/pagemap.h                       | 16 +++++=0A=
 include/linux/secretmem.h                     | 18 ------=0A=
 include/linux/set_memory.h                    | 10 ++++=0A=
 include/uapi/linux/kvm.h                      |  1 +=0A=
 lib/buildid.c                                 |  4 +-=0A=
 mm/gup.c                                      | 19 ++----=0A=
 mm/mlock.c                                    |  2 +-=0A=
 mm/secretmem.c                                |  8 +--=0A=
 .../testing/selftests/kvm/guest_memfd_test.c  | 17 +++++-=0A=
 .../testing/selftests/kvm/include/kvm_util.h  | 37 +++++++++---=0A=
 .../testing/selftests/kvm/include/test_util.h |  8 +++=0A=
 tools/testing/selftests/kvm/lib/elf.c         |  8 +--=0A=
 tools/testing/selftests/kvm/lib/io.c          | 23 ++++++++=0A=
 tools/testing/selftests/kvm/lib/kvm_util.c    | 59 +++++++++++--------=0A=
 tools/testing/selftests/kvm/lib/test_util.c   |  8 +++=0A=
 tools/testing/selftests/kvm/lib/x86/sev.c     |  1 +=0A=
 .../selftests/kvm/pre_fault_memory_test.c     |  1 +=0A=
 .../selftests/kvm/set_memory_region_test.c    | 52 ++++++++++++++--=0A=
 .../kvm/x86/private_mem_conversions_test.c    |  7 ++-=0A=
 virt/kvm/guest_memfd.c                        | 58 ++++++++++++++++--=0A=
 34 files changed, 406 insertions(+), 101 deletions(-)=0A=
=0A=
=0A=
base-commit: 0499add8efd72456514c6218c062911ccc922a99=0A=
-- =0A=
2.50.1=0A=
=0A=

