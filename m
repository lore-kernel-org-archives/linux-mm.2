Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33C6AFCB619
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:42:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66EED6B0005; Fri,  6 Mar 2026 10:41:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61CCC6B0098; Fri,  6 Mar 2026 10:41:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D3C76B0099; Fri,  6 Mar 2026 10:41:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3A3256B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:41:59 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDAAB1B8448
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:41:58 +0000 (UTC)
X-FDA: 84516053916.18.30E74BC
Received: from fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com [52.28.197.132])
	by imf22.hostedemail.com (Postfix) with ESMTP id 778C4C0013
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:41:56 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=X4utk3my;
	spf=pass (imf22.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772811716;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YnCR77bPkSJ3r6eLW+FO2o4FnCnPBwwukZtKN2qmask=;
	b=Q1RUxvK4rGrXxNCvol8dmoaWTTGakXk96oBvHENi7nBnV/N/wMWavy+wtHJff0oQGZwQym
	r3JfAfUxnarHTZRBH1Mze5CMo7IMAMXaz0s02mfrDCqUwzp9JVjBN+GQcvlFQXxwG3aw7H
	6vtrNI9GGnJOdEK4CA+sOOe6Waz/75w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772811716; a=rsa-sha256;
	cv=none;
	b=l9VvnI7haMNMe5zhITzxxF+5qHn3NiofAFA63mFSd5pHnCOuHGFtSWADXh+L+3uRM8aMgl
	yV+pU6/jQ+CwKo59RaerqzriMrrhBwxzk2OFt0VXC4lpWOpWpAo7AP08kN/fB5lHyGqn4c
	1tdYUN3289JRGp0uvtMTr/hsJZW5MdA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=X4utk3my;
	spf=pass (imf22.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 52.28.197.132 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772811716; x=1804347716;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=YnCR77bPkSJ3r6eLW+FO2o4FnCnPBwwukZtKN2qmask=;
  b=X4utk3my0nrXJ7V+xNGa7E7shFGSGv0LocFCK2I0V93Tyv/cEvY6Us80
   C0rA1RFQx/RwMB6yd97XmK8H2S7I0uOFLjWn6uSeu1f6GtOFeeufmj1xb
   XticrJity1/xbjTBEzCSbYLucPQq0wAoaxKifnNFo0TuMM6ycPc33GlhR
   qexscSmcB9l0Ur1CI8/dMcSevbKXeZvwq0w32VjwUtYT/cFZi/q1/f8AP
   SlZMhqntKcnezIkIzJkT1eNpDxm3kfi8RgF2Wbp0+6W4pzKRViICvy5LZ
   Px/sbEqLFj1soyu5+TxTohwwA/cwdwdWV5NwlFW3VnuygxuZqev1wq7fv
   Q==;
X-CSE-ConnectionGUID: GwEkaMEOTMKbobqyy3yX9A==
X-CSE-MsgGUID: di4IC+oOQpGwVPpG+YbSbA==
X-IronPort-AV: E=Sophos;i="6.23,105,1770595200"; 
   d="scan'208";a="10322839"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-011.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 15:41:52 +0000
Received: from EX19MTAEUA002.ant.amazon.com [54.240.197.232:9370]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.46.96:2525] with esmtp (Farcaster)
 id 5185657e-5145-4540-97b1-c86cd60d47dd; Fri, 6 Mar 2026 15:41:52 +0000 (UTC)
X-Farcaster-Flow-ID: 5185657e-5145-4540-97b1-c86cd60d47dd
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUA002.ant.amazon.com (10.252.50.124) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 6 Mar 2026 15:41:52 +0000
Received: from [192.168.2.180] (10.106.83.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 6 Mar 2026
 15:41:47 +0000
Message-ID: <5c322be7-ea81-4e6a-9689-978c35e93af6@amazon.com>
Date: Fri, 6 Mar 2026 15:41:45 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v10 02/15] set_memory: add folio_{zap, restore}_direct_map
 helpers
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
 <20260126164445.11867-3-kalyazin@amazon.com>
 <af2d4dcd-60a8-4a5a-b508-d9600b1f2275@kernel.org>
 <e2834fd9-e4ec-473c-90cd-6c3a5049747f@amazon.com>
 <40bd6f9b-d5c0-4844-81bc-d221cd9b058f@kernel.org>
 <38deb26a-918c-4743-b35f-92a1330dbf40@amazon.com>
 <efc1c39c-7eb5-488f-819c-0ca2149898c3@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <efc1c39c-7eb5-488f-819c-0ca2149898c3@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.26]
X-ClientProxiedBy: EX19D007EUB003.ant.amazon.com (10.252.51.43) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 778C4C0013
X-Stat-Signature: 4hwismeaenh5dns78fndgaeffb1ikrph
X-Rspam-User: 
X-HE-Tag: 1772811716-677584
X-HE-Meta: U2FsdGVkX198C2Fsizue39cyGtXk2axulY99y8gLRP47Jb2exQI74P48iNR/Bc99lSMSNN1cT0W5/0qCdZBPmMGx8Hd1fI8RjbTsZcECzDaUgJkHxinycYrA5iMFWXPYFfXbW5lkgPUQiVf+5qhSsqsxdiy1iwGzojjJWGASyLmqSB1mCNTwYfMMD/GVml3be7SkfSrfyUkgaV5Rxy/QtflQabO2OehRcWgyW1zqemTrom3g1JeXCXYk2OhqN1GF+Cv1dGwlIM0ERamjKUj5fmoHVBzU4QQr346bUUZdOsXhptkPYjtITzRFOt+0x3tOAPQknXmPRbXDLj7in9mKpvzObSXXVuowe72qHK1aWWUR1eWAp9Bs+n+v/xq9iLqquWnWSh1Jh9g7oTTq+RPf/TO1UDGEYkxIStTzaMZqv+gaSYi9LBnSQm9e6KB2qxGu+dNtCr+vUktQhje67M9WjC3lUPIsZf68gkiwXF/LUhqYYjCkGgbr8jGcH0lGCB+hnRy1Ais2mX7+rN+liwHk1Rpcc9EmEy2i3Zl+eyJIwMc7YKTl80eemJ1SupyXBoZbbpfxZ1iNgDi/mIsea1r0s2baeKlbntupMtUL0OCIb0R6UQ+X6dLAGZSM3AXg8VMrJs5qX0taYV7814ETj5rCNTBxkdm1WyhI4/rE8kkvtoR5vqX7XcvNI+JMDN5VvrXxrBkGg/z17yz/GWzP6WVPqeFFi8aO3PXE8ocsYziO8IrALTosgGH4YmMV9IiL5b/rh3jefHZ8VWRNiAkRqUWLq0SqQ6xndehwwS9Ue1AXYCwasG1AUr7nawvbdEY2OgaNXEjojPyCZphFmaPdKYydMAyg6F2q7JfmrGhfHBG51YZ5V6xIa5tJMpNOCEGeFyA668mf5mO24qpFqz5pDrsqsP4u09FZIGfnN6wB5o64bi9315aMZz5x9ofWSg2Ch9ZoPGg9jFG2F6lsnDf7dEE
 D4eunRUu
 6bg9pxI/oi9IOB7jsf/RelFye8SO5OHkWuYxG97ZSVDmQm2xfu6XsU8emXdHLXakfP3SlJJtQZQwuY1Hd7bNcYkVctRR8Wmef6kHelTlH2HENeoLsswOOpsvnCI48RhmoK4xjFIKYantUIqzBGRBw63eL05esy9HuI4Dz6eBABQWgr/PzUmjkefgMJ1MbAwufQBDfpSB287AmMvcRPQh8wl9/MXJb4df1ejVJOFjFdy5hsi+Lkb+0Nwyp+6/ReTOWu/yF/oR4drxd2H74yNZAoLS+oQlGmRCOwXngqlx3UPEDUca9v+M5EjNVWq4rVPOjd+BQEoEaQmss3asX6fwJqQoVtlhRMGvfbaoA4h/zY3dDHb/RszP8pehXMjyOs7zalddI8l26VmFuUocH0nq4O2jsXQTV6mp1KmGOUZvE6Lfw+Gu8cl/me7Abhg/WqkaqtGRELhT5AYhNyVHN/rJd8BouxXYQ8z+6339toFJV3pg6SYhx6bujFwthFR5tktGmdjCx0ffegTorfQXfXb+QYtnUrnF7BrN4aJM/seY3OfWQzGVFlteVEPYpp5VQATBSOCgqjYKOTB+PJFkMhu8RYtsrNzm9zPAdOrrHWQOnADBJOAj8pY/aCpM1YFDnrfei4pOVgfEBgiiUp+Updodj1bage6yNlK7RtfnI8LPEAloEFt19Qj9EPGo0nDtI3Sh/E3yDzvEospJc0a2nx72l7dTJlHqifKVPpitc+RJ8MsU6Msyj01y+kb9B9pIFj2iwOsAhFInZzuT+Dl3JryRNidjjb1r4qLi+HEojlXR/zos6wQ5uE4mesu9fxtR3p3DHtw1gXVyKw+Zs8NM7Z6gQAsZIFPunb/M7UZDfeaoRySiXFBZxCxVA4K7i5za1rF1gipPPajopAveK90dCzKdmQUamBMhvWtHkbir3Y0hdlBxxHXFhOaemGZd4sMIOMj9EOJoiPUnEFfMATmVX+k8Lbon2Kjgi
 YNYUoEiJ
 +e4V2kmH2ktlAym57TO0MWOn/ktZSG/sBa9F2SiPp/d6wtWgA87Kbb54fwJWChv8upyc6lwUBzfb1aKq/WV4Ig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/03/2026 15:17, David Hildenbrand (Arm) wrote:
> On 3/6/26 15:48, Nikita Kalyazin wrote:
>>
>>
>> On 06/03/2026 14:17, David Hildenbrand (Arm) wrote:
>>> On 3/6/26 13:48, Nikita Kalyazin wrote:
>>>>
>>>>
>>>>
>>>> Will update, thanks.
>>>>
>>>>
>>>> Absolutely!
>>>>
>>>>
>>>> Yes, on x86 we need an explicit flush.  Other architectures deal with it
>>>> internally.
>>>
>>> So, we call a _noflush function and it performs a ... flush. What.
>>
>> Yeah, that's unfortunately the status quo as pointed by Aneesh [1]
>>
>> [1] https://lore.kernel.org/kvm/yq5ajz07czvz.fsf@kernel.org/
>>
>>>
>>> Take a look at secretmem_fault(), where we do an unconditional
>>> flush_tlb_kernel_range().
>>>
>>> Do we end up double-flushing in that case?
>>
>> Yes, looks like that.  I'll remove the explicit flush and rely on
>> folio_zap_direct_map().
>>
>>>
>>>> Do you propose a bespoke implementation for x86 and a
>>>> "generic" one for others?
>>>
>>> We have to find a way to have a single set of functions for all archs
>>> that support directmap removal.
>>
>> I believe Dave meant to address that with folio_{zap,restore}
>> _direct_map() [2].
>>
>> [2] https://lore.kernel.org/kvm/9409531b-589b-4a54-
>> b122-06a3cf0846f3@intel.com/
>>
>>>
>>> One option might be to have some indication from the architecture that
>>> no flush_tlb_kernel_range() is required.
>>>
>>> Could be a config option or some simple helper function.
>>
>> I'd be inclined to know what arch maintainers think because I don't have
>> a strong opinion on that.
> 
> You could also just perform a double flush, and let people that
> implemented a _noflush() to perform a flush optimize that later.

Do you propose to just universalise the one from x86?

int folio_zap_direct_map(struct folio *folio)
{
	const void *addr = folio_address(folio);
	int ret;

	ret = set_direct_map_valid_noflush(addr, folio_nr_pages(folio), false);
	flush_tlb_kernel_range((unsigned long)addr,
			       (unsigned long)addr + folio_size(folio));

	return ret;
}

I'm fine with that too.

> 
> I mean, that's what secretmem did :)

With the solution above, secretmem stays where it was: no optimisation 
so far :)

> 
> --
> Cheers,
> 
> David


