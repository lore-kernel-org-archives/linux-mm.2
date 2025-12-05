Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71810D33994
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 16:58:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2E7B6B000A; Fri,  5 Dec 2025 11:58:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDEF16B000D; Fri,  5 Dec 2025 11:58:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA6C96B000E; Fri,  5 Dec 2025 11:58:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A415B6B000A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 11:58:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7DFBE579CD
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:18 +0000 (UTC)
X-FDA: 84186025476.27.7FCC0A1
Received: from fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com [63.178.132.221])
	by imf09.hostedemail.com (Postfix) with ESMTP id EB52614000B
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:58:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q7MPPzRQ;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764953896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OTta7SWGM4sSlljWxtUnxsblM5lcOxRPzU4BqTYg0Qg=;
	b=6zwpkr2+SqOZlgC9AAd2N7pvXl5UVfyRnBrT2nCf8vebIPw8MPTzosa2Nkbi4SzSR3deuO
	WB1bY4phXoHdjnlIfVCdQdWum3zi8PKnUJRX/hpISpi9GPxovemzH/xc3L1wENY7JVzT8V
	62IqD7c8gaNqN85HXmFYm0NMgcjWK80=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=amazon.co.uk header.s=amazoncorp2 header.b=Q7MPPzRQ;
	spf=pass (imf09.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 63.178.132.221 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.co.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764953896; a=rsa-sha256;
	cv=none;
	b=A46NZcbTGCX4T07PSetSvb50RKKTU+YPz5jk+x0Eo9N1mI7FXq5ZPnB55Q82NoqHiEkOKS
	d66SH6VlONZWzZbkNxl1k+ILmNmgewfVFe5z1usEgRWn6i+bMtVauKUpQSNZh6uMP9SP5/
	2dUkR8J3rNT6fq9VQDOH9o6M9mU8QHI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.co.uk; i=@amazon.co.uk; q=dns/txt;
  s=amazoncorp2; t=1764953896; x=1796489896;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=OTta7SWGM4sSlljWxtUnxsblM5lcOxRPzU4BqTYg0Qg=;
  b=Q7MPPzRQxETgyE4pJfEDfkRATi9wXmgN2d0zFc8p+OaFm3Nv05jL5TPg
   eez9bL4J9DZuJlJ4no4nyqmmiogqdVnIBd2CcKt7LJMvvLB4ywBYZNDaP
   B86yOHTdWq2VM+Ydb7nJ3kMdh8YxmOJ6J/P0enWHRm16p/jngWpmTlcl/
   wrXmBNlWRlyJpWtebdIvs2IbiBOJs+23WcreLqWw7mepam4Y0ieZW4vf/
   w4yS2d2HBVO19IpX2MPQVxU2UFtIKuuXAi4IBwlx2BelQhMuFsJoL36+h
   D0GpAAtUc/hZbpMKyRzjnfhXtiRQ2FAYOtY1ccRUIL4TUeLxang6Bi0pt
   Q==;
X-CSE-ConnectionGUID: tCSZJcjsRGW05HlXnAg+rw==
X-CSE-MsgGUID: DdJLRKRZQbmfkk+SpQ0udg==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6196568"
Received: from ip-10-6-3-216.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.3.216])
  by internal-fra-out-013.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 16:57:58 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:10986]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.26.175:2525] with esmtp (Farcaster)
 id 2bf591aa-fe6a-4778-8f28-ccc43634a12b; Fri, 5 Dec 2025 16:57:58 +0000 (UTC)
X-Farcaster-Flow-ID: 2bf591aa-fe6a-4778-8f28-ccc43634a12b
Received: from EX19D005EUB002.ant.amazon.com (10.252.51.103) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.155) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:57:57 +0000
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19D005EUB002.ant.amazon.com (10.252.51.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 16:57:57 +0000
Received: from EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c]) by
 EX19D005EUB003.ant.amazon.com ([fe80::b825:becb:4b38:da0c%3]) with mapi id
 15.02.2562.029; Fri, 5 Dec 2025 16:57:57 +0000
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
Subject: [PATCH v8 01/13] x86: export set_direct_map_valid_noflush to KVM
 module
Thread-Topic: [PATCH v8 01/13] x86: export set_direct_map_valid_noflush to KVM
 module
Thread-Index: AQHcZghOBziVXkJRtEWVlaaPn0Dq3Q==
Date: Fri, 5 Dec 2025 16:57:57 +0000
Message-ID: <20251205165743.9341-2-kalyazin@amazon.com>
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EB52614000B
X-Stat-Signature: i14g6buxxmjm8szpzh4wn7jicog8c498
X-Rspam-User: 
X-HE-Tag: 1764953895-329187
X-HE-Meta: U2FsdGVkX184X7VIqRjrSEw6lKhQ3jlFVC+Pb9g4Z0CMIpwFrnRuYuKbNHRIhcQoldIrfEzD/f8cpvGgoudozHPg0uL4J54jozci+BhTWRytUz0Eo6/k36FHVvs/W/qlyj4WEQ2j0rE+rvdgLYIWaXjQDtc/X5WUWaR3lf1JRqYS8ROe0fjoEM1jWnDFeRREhukGGy1MVrAN2aw0FepkqksBJbxGsidlkn/9OlbmxB+oRUoLBysQEyMO1mwq3ua/RYMdppkJLkzCGziEA2FZowMyH7fVMo3LF7YtckQt2VeL08H2UU6TSqKeXBQd38HEXE/zNE0LcJkQjFn5buqjpV3P+L77Pa6OpRdYvetCzC1xTGFO4AmgPi/Cu9MFoNsNjjeFJLp0hDFWUnxfa1dSv2fxm2iuS6jZsrAAhLYGh7DqDbrbFr+CNFreTG3GQbIJYAu37hurtWUFYPl+bx6sewuw4Zp2hVtCHv5eEs49znxGyNkeLKLcoffKFgp8AjsfoMDJrr0g5I15gOBJoFxYXCxlibubXv3kH8k5uBCH7/K5R1/hlg/KQThMzXU1K/qDlEeCpgjBeoXplAVETXQHBc9kIzM7ApMYLrJ7hScqezjmG7pXfMAA0KDGKr0MlODwZIdW8aSs0WMIrbjfrFGyDTi/Jy130upoei/W1YgVZU2Tuqw8JAAkdNcyHur1gQsl7zsIQ0R84S/xasC48C5t9nkLONEJ0S5WxkFSvqMcPo1qpNtX+/QbJDwCWINv3qRztfOpLwufIWgmTts5Eio6C/kYbBwymBQadHZ+vPtAlsCYdXkZtigyLf0GZKydEs8wpzLuEZL2cP1jJaODdP/xORsybT093YdEJ9KhLWmFLYYcxMvQnEbZcE6cwZTkeaDs8bEZWEagP+nka0e4lVYFy9od8sujU2/Ea2REviV0cqwK1ROK9mdISztVAmd2/sUezUT79+12qJ2oeLXCXBC
 NxIckjXq
 5M/sUXi8TsaMwSQ3nBGbO/3dadOLbn94SsQVXQs1G9WnBT9bUtTo0XDYhVDZtCTrR3KXg3tTF1/v6dzOZ5nJR54BgTJh4gNCjvuYhzs3ALgazTVbnUfMyCBzYJQ+I1eFcL+vkSYjR23KN4GDw+YKuA0xrWV6JPhl6EVmolsjwU8ZqxKO39ydX3fo38fdNVbUhAp9ZSzFc7o5qLqU69uCB6NQEQQICggR5AqnYdlV31Yy0hbLyuHxBxV7L70HrL1CuMlXwZQcpjaLpk8GT8q8/HdBOf5f1tRLohwoeDO9KSOZ5x/7oC1Xr/RBJAasbkQsH7gBHFANYqgyMhkm4Fi8udWL21NbyO0NnoTUMsFQA+0Lh3zwSa5JDuRr6d3NCg7rsLh2yqk6Qn5YI5TYHBAW7j4mMyWtXM8NbEfDdU5mxRbJtLm7UEhpbuFx5lqF+rC01kDVDGLt/v/tRJd2MjBM57ZnXaIr7o0kOWwIeOt+SfOObi6ilDkdkkBbYdeUtzJbzJx4e0i5fUGyWryZxOYgA4G+gV3MF+BrzbgQzpolGvTIA57MKiSZECba+NGOek2nKbozC6OIZiFaMIwQpTADz+kOLh2vZInDLa0xuFKL+mY15GDaqteurOjuKPbf+wU8HDVuHZCz0pbT5nxzVoI28F+GCYw5VWviTvtoI1V8p2UFTAHjnLSq6y9gdtjfHWu7HtmGKMDYYtZVFWH4rWRpCG5OVSiTAOhkesbAYJTqG17HxdG6RV7ZvnKJxaPrhaXK8uEmbAjKF7tnI5Sw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Patrick Roy <patrick.roy@linux.dev>=0A=
=0A=
Use the per-module export functionality to allow KVM (and only KVM)=0A=
access to set_direct_map_valid_noflush(). This allows guest_memfd to=0A=
remove its memory from the direct map, even if KVM is built as a module.=0A=
=0A=
Only do this on x86, as only x86 and arm64 support guest_memfd, and=0A=
arm64 does not support building KVM as a module.=0A=
=0A=
Direct map removal gives guest_memfd the same protection that=0A=
memfd_secret enjoys, such as hardening against Spectre-like attacks=0A=
through in-kernel gadgets.=0A=
=0A=
Signed-off-by: Patrick Roy <patrick.roy@linux.dev>=0A=
Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>=0A=
---=0A=
 arch/x86/mm/pat/set_memory.c | 1 +=0A=
 1 file changed, 1 insertion(+)=0A=
=0A=
diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c=0A=
index 970981893c9b..a7a88b598d99 100644=0A=
--- a/arch/x86/mm/pat/set_memory.c=0A=
+++ b/arch/x86/mm/pat/set_memory.c=0A=
@@ -2655,6 +2655,7 @@ int set_direct_map_valid_noflush(struct page *page, u=
nsigned nr, bool valid)=0A=
 =0A=
 	return __set_pages_np(page, nr);=0A=
 }=0A=
+EXPORT_SYMBOL_FOR_MODULES(set_direct_map_valid_noflush, "kvm");=0A=
 =0A=
 #ifdef CONFIG_DEBUG_PAGEALLOC=0A=
 void __kernel_map_pages(struct page *page, int numpages, int enable)=0A=
-- =0A=
2.50.1=0A=
=0A=

