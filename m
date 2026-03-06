Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3F77FCB601
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 14:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296496B0092; Fri,  6 Mar 2026 09:49:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25FAE6B0093; Fri,  6 Mar 2026 09:49:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0FF6B0095; Fri,  6 Mar 2026 09:49:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F2E0A6B0092
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 09:49:31 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D17E1405F5
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:49:31 +0000 (UTC)
X-FDA: 84515921742.23.D842B4F
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3A1754000D
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 14:49:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JF8M40jG;
	spf=pass (imf01.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772808569;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NrzHXx0Lp7Elw8ALF5D0u+kNkH3P0Dcowz8U+9XDncM=;
	b=XuqzfqhqEmy+lo1gMdPXQtddNoPwIfGAI8Qb/5wauKhIg5JSciJu2iQCa6lYkrbJXBI7Bz
	HpeM4R5zGOfvATS1V9ZVaScrB8WwA0bYOPQ/72q5LT7rHIQVPCl2Kk0XwQk2TO+KY5+aq1
	BFag3ylq1LBb7Ba0SZOKTaFIVF0lRkM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=JF8M40jG;
	spf=pass (imf01.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772808569; a=rsa-sha256;
	cv=none;
	b=7ynh7zaQdKcPNF8UD7z5oHVMEzZAfOdDLWsE/yNc7MzueznSsOStIu45DOKOmhzEVPzSRW
	FdhkVESbCWY4BiYLiulH4CLM2fDby90pMucQuP+erLnDFofNXam4qZ8KkzYiWZLQl1qfPi
	fGkpFODK/qLYFx2+/X/xerXW6EYYksU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772808569; x=1804344569;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=NrzHXx0Lp7Elw8ALF5D0u+kNkH3P0Dcowz8U+9XDncM=;
  b=JF8M40jG1RYIVatOlRZ2CqOb3BU+ftZ6H1UsIQ8V49OkXZiRblnzYzcD
   lwsTrNX2Ak8Uzxz6YlcceM5qy5uW5/1ad9ygHDhkhEvNeH+REkwG/ehK2
   hJnxbzfiuDDaSq41yyj9YNw6LZM0G2DPucgUqa+LJhHBJk5IMmEEQg8PI
   UzfavGT7CHSPCLSFhRbpb/YZN0NoehEnODnrYaZy1ugMYGbxuNMZQLWW3
   AciBzfFcrYlb5IOrhrrphx/ShWLuryuB6k8JqlT2lmPaqHlg687/LJ3ho
   rgkGQmTKB/kAzr7WLBfwP2Sv2Xze8paHGvrtKMeyjbaVs0Wz+XLlbZI1f
   g==;
X-CSE-ConnectionGUID: 5IccaEBNQVSWRB5rNmqQOQ==
X-CSE-MsgGUID: 2TQ5H7tGR3uCD8Jr0npB8Q==
X-IronPort-AV: E=Sophos;i="6.23,105,1770595200"; 
   d="scan'208";a="10436907"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 14:49:25 +0000
Received: from EX19MTAEUB002.ant.amazon.com [54.240.197.224:3701]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.26.205:2525] with esmtp (Farcaster)
 id 00a2718f-a0c4-43d5-bed7-970a51d610b2; Fri, 6 Mar 2026 14:49:25 +0000 (UTC)
X-Farcaster-Flow-ID: 00a2718f-a0c4-43d5-bed7-970a51d610b2
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB002.ant.amazon.com (10.252.51.79) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 6 Mar 2026 14:49:24 +0000
Received: from [192.168.2.180] (10.106.83.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 6 Mar 2026
 14:49:19 +0000
Message-ID: <936fa782-d937-4b14-b92d-cc8707336e5e@amazon.com>
Date: Fri, 6 Mar 2026 14:49:18 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v10 09/15] KVM: guest_memfd: Add flag to remove from
 direct map
To: "David Hildenbrand (Arm)" <david@kernel.org>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
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
	<akpm@linux-foundation.org>, "lorenzo.stoakes@oracle.com"
	<lorenzo.stoakes@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
	"daniel@iogearbox.net" <daniel@iogearbox.net>, "andrii@kernel.org"
	<andrii@kernel.org>, "martin.lau@linux.dev" <martin.lau@linux.dev>,
	"eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org" <song@kernel.org>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jolsa@kernel.org"
	<jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>, "jhubbard@nvidia.com"
	<jhubbard@nvidia.com>, "peterx@redhat.com" <peterx@redhat.com>,
	"jannh@google.com" <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
	"shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com" <riel@surriel.com>,
	"ryan.roberts@arm.com" <ryan.roberts@arm.com>, "jgross@suse.com"
	<jgross@suse.com>, "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
	"kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
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
	<xmarcalx@amazon.co.uk>
References: <20260126164445.11867-1-kalyazin@amazon.com>
 <20260126164445.11867-10-kalyazin@amazon.com>
 <13ed00e1-f0db-4326-a800-2ba306833921@kernel.org>
 <690c22f9-b71a-4f14-9857-008c7c858373@amazon.com>
 <0c0b911c-cda2-44a4-897e-361e02be7da5@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <0c0b911c-cda2-44a4-897e-361e02be7da5@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.26]
X-ClientProxiedBy: EX19D001EUB001.ant.amazon.com (10.252.51.16) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspam-User: 
X-Rspamd-Queue-Id: 3A1754000D
X-Rspamd-Server: rspam08
X-Stat-Signature: aty71ki3qtki5op6xyypazc733kw6rto
X-HE-Tag: 1772808569-22983
X-HE-Meta: U2FsdGVkX18NSnF7QNPI14ftYNlq4sjN2E199pmtGfSSyeUqINsSKStMCixegPPwPoO8vZtUGakwIWPy3EgyFKGGy/fUOP6UiRDG6ogBHUEOYWE6uvkl5c06EAwpXzCMA9uMk+pDwDxA1M3aA1yfjYI8yURmHXUriM6clUxrSDmbPu9cd442EX74K9NQ/WApgCc7V0iQxnV+CvisqsvCYDVfyFV6JGq5j8H24kB1T9WT/P1THnop99i7AlaE8zm8de7H0OGSrirRY6vRgMsRpL4HQ9SRdvydAcAWhtiPGVgQlL+iJ1fax2EN6WBaM/zVcG+FDqTmE2//ORtg5BaG7TlX951Z5GDf0j4Xt/P6r0y/iqh7vLdCrNH61nOdWJjuhrNAqmxuafTPZkes14gbzplfqqAtLY8B0qDnELNrJK1I73oBIDJFboHOrF57jAseWrG/SZWolGBxIqvW9AeI3LfUPrQndKgnCEncADZBGFR43tRzzgw6ZSeGlU+UdyuFZvRpB9QTQ88KXUIhtfFkIr+sTa+o8/liEwFRBqzkQw0AAvzlxOsX9reqe2OuKdjFss3DOYSrpTT5Fy3gCj3iHRNaILksV8pSHHDwK9in7NA7d7o3mNVSURICxzU/J2vvPl9TWPpLWxZTB23LInE/S2bbfzR618sSsWsh2rf5gcq4sYs3LbiMJDsayiQlCgyZvYr9mHsxP8LMY5k2kC9OuRY/q71+wNAFZsSoA/Y2mWDHBJNsuGDMIX/1Orv/RnutCDzPoXJy2Bojrwdx1whkA5HBxNCcQYkdaCvdbLZFLHmP9CZWEyPZk0Eojjqh99qa+tMD6N76hdrwYXIWst+hh88XYJngoOlI44QYTynCWcRu8mZxstcjeFGI+Tk96K88vmmvqjT0Wyc2br7PfJLVo29t87bOlFppU0ShzGEk2OQSnxP3MZpz5xfB6Mlm8/Pa+i6zPb4JbmrUwIYXgu+
 2I1Mp6ux
 DbGDDOaw2O4PhkTw5SWdoTh2KWPjCXr4RwUNQDC2P5GjBHhrEPHlJZ4zXGMNz10W9HQoQmJj5ASJ9osZuxG3fccuYYOIKITwI/Xq2oW0T883VXbOKuhBziLPcjTYSEofCKvg1Ko9OhSaiPC3WM6zKR8VE2EPyKa6JjH4h86qFq7f+5kS2mkc0uHb02GwrYhP4sdhbrcOvM3BhRmGjAjYjr9NBH9mZHsRkA2qE6yDNkGG3SqtqNIJziW++kXRd+d3IB9jnN+v1TRITYnbWM2lpwAWRULXOdfgVaODddgYfhlw3Ft6q4vqIzpIrVqPWM9tG3mw2UHmIeqAD+lbFWpl9eQljf5wR0gedPgvDmcjU3qU/l2bCs6NPjUgSBBruwTpAVU+juUxxzDwY1HV6DldS4YVERm2M1XHGscRExq0fP2b4i+/Ltp1gch5yUSY7j3tjp2EtSBrgc5U6U6vvUkjly3obczHW28QOodvY1aOtHXXVkCokR6dY33ghZ8S5mmfjc74pYuMWBM+QYS86uK7uFM3Vv6kgopbVQtPt6U3qZRR3dQWTCPkHeMXTBwGrJmKS2kgg3c9ZwvmGLnQFJgEH/UVvg5ZaVGpbwZXplh5wY4EKSX8ZNk9Vk6HAoWDLMAUqyLiwu0G7XOuyp9FMTygV0DQIkY8QlvgADtl/BpaE8phxmELrBWiVL0TG22TCoJwuB+OXMxPyG96djaJbEjGWn+Azl2J9aFlSl4Iums/GOM5EPCTDQ040X5GGJ9gLIo+L3c6UyRTn5x2ya+X5ITwgI7GkxxeMzxWfsDPFp7/SYtACxkimc5F7EbNLnaoh1fPnN6K1HEW8/rQFpB67tECkOYnFH8bztw4b/dekEB2Mmt0fY5DiCxphLy6uoPmEVZpo57fN2fDjd/UH6lZwL0aKU3ZnI1IPtLanFVQ9Fn0cqbpX6J1BMbEgIQ5vsrHfyR72keXT8gLOC5s+DXmyhrpdRnFPCaE0
 Eu3Vchzt
 2wKxd1JgHGfQDXBF/wW3PJuCym5sQA/xVU1oLj7b5q+NsYc63azh/kioXiZx/x3QVM2VGSFcqiFmRW2lJ7fC1nUy/ImI5EhD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/03/2026 14:22, David Hildenbrand (Arm) wrote:
> [...]
> 
>>>> +     /*
>>>> +      * Direct map restoration cannot fail, as the only error condition
>>>> +      * for direct map manipulation is failure to allocate page tables
>>>> +      * when splitting huge pages, but this split would have already
>>>> +      * happened in folio_zap_direct_map() in
>>>> kvm_gmem_folio_zap_direct_map().
>>>> +      * Note that the splitting occurs always because guest_memfd
>>>> +      * currently supports only base pages.
>>>> +      * Thus folio_restore_direct_map() here only updates prot bits.
>>>> +      */
>>>> +     WARN_ON_ONCE(folio_restore_direct_map(folio));
>>>
>>> Which raised the question: why should this function then even return an
>>> error?
>>
>> Dave pointed earlier that the failures were possible [1].  Do you think
>> we can document it better?
> 
> I'm fine with checking that somewhere (to catch any future problems).
> 
> Why not do the WARN_ON_ONCE() in folio_restore_direct_map()?
> 
> Then, carefully document (in the new kerneldoc for
> folio_restore_direct_map() etc) that folio_restore_direct_map() is only
> allowed after a prior successful folio_zap_direct_map(), and add a
> helpful comment above the WARN_ON_ONCE() in folio_restore_direct_map()
> that we don't expect errors etc.

My only concern about that is the assumptions we make in KVM may not 
apply to the general case and the WARN_ON_ONCE may become too 
restrictive compared to proper error handling in some (rare) cases.  For 
example, is it possible for the folio to migrate in between?

> 
> [...]
> 
>>>> -     if (!is_prepared)
>>>> +     if (!is_prepared) {
>>>>                 r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>>>> +             if (r)
>>>> +                     goto out_unlock;
>>>> +     }
>>>> +
>>>> +     if (kvm_gmem_no_direct_map(folio_inode(folio))) {
>>>> +             r = kvm_gmem_folio_zap_direct_map(folio);
>>>> +             if (r)
>>>> +                     goto out_unlock;
>>>> +     }
>>>
>>>
>>> It's a bit nasty that we have two different places where we have to call
>>> this. Smells error prone.
>>
>> We will actually have 2 more: for the write() syscall and UFFDIO_COPY,
>> and 0 once we have [2]
>>
>> [2] https://lore.kernel.org/linux-mm/20260225-page_alloc-unmapped-v1-0-
>> e8808a03cd66@google.com/
>>
>>>
>>> I was wondering why kvm_gmem_get_folio() cannot handle that?
>>
>> Most of the call sites follow the pattern alloc -> write -> zap so
>> they'll need direct map for some time after the allocation.
>>
> 
> Okay. Nasty. :)
> 
> --
> Cheers,
> 
> David


