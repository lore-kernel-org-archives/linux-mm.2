Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B61FCB61A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 15:42:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5EAAF6B008A; Fri,  6 Mar 2026 10:42:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A8026B0098; Fri,  6 Mar 2026 10:42:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 455836B0099; Fri,  6 Mar 2026 10:42:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3595B6B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 10:42:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CEAA41404F2
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:42:15 +0000 (UTC)
X-FDA: 84516054630.08.A8ADE3B
Received: from fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.72.182.33])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5EE3E18000F
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 15:42:13 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kGQeBc2u;
	spf=pass (imf06.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772811733;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zlv5A21skW2cpWW+wfG6AmLOagqEDkrIsCoF7K54pBc=;
	b=2TcKAH3F2hELXZppjwub11+q+lu6m5fGSHvdr0NSk09qrkyzdlksQ0neg/uQCz0Sa4CPnQ
	NJKbaHjPiezBXAOP6N2zcQCNpbespojrGvy7zIVTVrP6Cp8n5BB3H7lBAsAcB1vScvAWFf
	zFzOR9jsziJdLYzxX14xRNvYL7jCZUA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kGQeBc2u;
	spf=pass (imf06.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 3.72.182.33 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772811733; a=rsa-sha256;
	cv=none;
	b=XXEGQcRTexMQg1FQdAHebVQl+R93/ipWJFYBmBCfnjICyKplA0MQnKMIQZWUfUBGGecfZD
	Qb17CkbgCpmO2NLKP9X+JKaKoyhKERI+xemsyppR2neEUcZ3DhGZBGXtrVFzQSnn5K0Bp8
	6DGQVSzvdQ5Mi8EQt9BR/IBeX+rS8gY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772811733; x=1804347733;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=zlv5A21skW2cpWW+wfG6AmLOagqEDkrIsCoF7K54pBc=;
  b=kGQeBc2uvROoZHYWd5iVTZr/hDVMtEWDpGOsZ9LagNyu0YjTa7habFhZ
   YodGbi5VqVPGFaXHtYVFpIa+sSPAAc/jdEXV5hYtXLImAkcjhf6qIq4NC
   7tc/6V7nTlTsz+Fa0a4U7cA4Mh22UYLxWf/LdEH3DrptW7ikso1RCqbnk
   jBoRvBAsGWQSmxq3eL5TSbbDsc8pSwxBGA1SedvoCEX6FcH07z0UCfal0
   tbJR/2aU5w44vy9vKoyviTXeh59Y/qWtBBlwH4NFWj4t8EAtPNVIRM9x7
   CPexHqVftOyVbRi8vcdAzti8yCNlSaZRHaAWTpRwNNUUMcsMfjMAg4L0M
   w==;
X-CSE-ConnectionGUID: /M9OfjBRTeKqpDhCE8ldMA==
X-CSE-MsgGUID: 0Bb6xkULS3yW60j2eb25+A==
X-IronPort-AV: E=Sophos;i="6.23,105,1770595200"; 
   d="scan'208";a="10435125"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-003.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 15:42:09 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.226:28153]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.5.165:2525] with esmtp (Farcaster)
 id 8290e714-6a53-45c7-af32-ec04f3406384; Fri, 6 Mar 2026 15:42:09 +0000 (UTC)
X-Farcaster-Flow-ID: 8290e714-6a53-45c7-af32-ec04f3406384
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 6 Mar 2026 15:42:07 +0000
Received: from [192.168.2.180] (10.106.83.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 6 Mar 2026
 15:42:02 +0000
Message-ID: <6dcbcdcb-bfdd-43a3-b724-599a717c1054@amazon.com>
Date: Fri, 6 Mar 2026 15:42:01 +0000
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
 <936fa782-d937-4b14-b92d-cc8707336e5e@amazon.com>
 <9b4b9f48-595d-46c9-8f77-fc021ac2619c@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <9b4b9f48-595d-46c9-8f77-fc021ac2619c@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.26]
X-ClientProxiedBy: EX19D011EUA003.ant.amazon.com (10.252.50.178) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: 6ho6mp8jt6owbdndfh8odnoacuotwopb
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EE3E18000F
X-HE-Tag: 1772811733-470191
X-HE-Meta: U2FsdGVkX18+scfJXPryNxLsKqeZ8vJtC5Z0z2m6mU2H1+qt2IGs6k2+H9UKhcX2pH+O5G2JyXU/JSmbB9vMpfhmaMemyzCEAwOi4ZlXnMbO4wee+flup5J7TFgcK5PJHwO4TpQfp2/RQsE6IsFRmSJ7/Kyu2fFGK6hEslUWcAWF3xkClQExTNNTQnh7KnVysTjYYHMHdy0pMzYvQ7vQbhXkHlLEFFrL/vr5Xo5BHABCNH8ydQtF4xbtRO7WUlSU+VG6QbQn+n1pdbW3aAhvTyrlP+jCh1kLbctdl5F5sB3UBtakOZsQKX6erU/rjhwuph7cykRN7PRHC9gQaFVFqmlUteXHDkK+zP8CYqN+tHeILafSJOpmylZGXGoq+APaFADs4nu03j8NPSl1Ct5cWV1qhoAxgPXSbNZl7xyxCJVW+x2BI7xZMZi64iKIesNmvLrjVyxSaMWgtFVhbkMnZBtMeu4qOBrzZ7SL6XKpQffXVVdxuElxjpOatp+H9NYc6vkJINdYAv0d14YSBkzJHs7bmTFZNYt2jdMSq9G2sH3UrepUrxMlEIVPmAOYG69YjxZUQOp+j1mwFkSWJKqw9nTgPCe7+roZ7GbScvM6kp96Quf/8+LSleJiErXqGLatcAIQJJJ+z1dpUqv1wPI57T1bajk1jBr8uXC3072rwApSzNqU7TGivru7e13TChoCiS7pYvFTzedQxCSf8dI1uH6VcfUIZvAA4gZKHH2mKJwr0F/lnQH6FeWZCmlr79/zU5WLK1/hZFB+Gqz558ROCjJJEBAuL6mwIdJMl+ZA1rbSoD1A7n2p0rJHjZytEJtcuaUvL7faXwRFn0r+EMmfCgj/OCx9wVZs08vvKjlGDJp9VQMitVLXsrzdgzIvywQqaSreWt7KwZXVxhvzzWOYRKRKE6xPHe2LXE33c5TjpDt/cv9IMBBO36H/qQkEECAU/q9DOXU9DWNM7vlS6iP
 ETzkIZfs
 ROA/qP6TS/whRdIUR14ndCSLUUJH88GKf5XmcgCcGTZJLksVA6aN3KoOg0kiC2WA3SLB9OOlN8zdn0ERGeRn3LDV0G4/HV/U24wfguqSvuHpIS2ApOZp1SQtGNB7izBE/WKTGkMPd8JHEUPAokKJShWrviLWlFUDtOkcvq4hwA6+/X5zJlgksXNxJMjNokYVo2p2ifVtUlmBVMrvjBK89Svk9cyiek0y2w6MJb+1Zi1utqr/EWcqoUms3cRhWd346Dpcp+YKXL/qeFfE7eYRWtxeLJAfBid0TgvbmZ0g6LnCKg6bzSyHrq62FX4lsDTMtwbco0yRMUp+J4axri8DlAV6hjc6ZwOIyIwusOWSZnkzDq1e7LOHzf6gQQNcSu1flyVkO9XgYyFM5eBTeSM20VFFn5jh90qycXGaC5lA6jL7lxSdqnNAmdX2zm+c1jnG7pYvmwUnipVfnHaKMh8sii95dBNb9O1v/RcGInik65ioW5MsOVEg/U3/bpErDUzSKhCs02r1WTDGuXEtycJIZxqq1EDazWhstlunLiNv/TSTs5lA+HgalNwNd5fHQjx5nap+6VjiZRLuGjdo5ZF7LBkfsMmfMa+nvc9eACPKalaJc71rhiY2OdXw1+kQBDJOVZRE5EJzyVEoQu3TtFhm9tQzkfdN+zN65IM4KyZ2qRIOWEsu5j/NjvKuMMjpZpLc86ugawFfAAy7L3quavosW9Tb/yW1eRlWQ1XxdWnC+KdvQ4E9hN/OA1a9158y6bZqYLvJyZGV8xqr+2tVHbAuzrOFmGqnM0Gx35piYWIHn4BS50RzvbCKU114fId60FO8f4udR+tqVfh5s/7bTjrNHBO5JQZB6lS+HZiqMfXIpXy78w393z2XYXs3udVFruAh+/kCJQ+hOLu+i5w4d9RHtTLbOOqD4MMI/tEk55H2NUjUY9vtJitYyHCCNluCpuw14XMiJbldOiHPBWzcvSYNk2ul22+Gm
 k6YNYH4w
 Jnxla9zO+RHGu+mHnyyxtDBVMAc0AC1p
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/03/2026 15:16, David Hildenbrand (Arm) wrote:
> On 3/6/26 15:49, Nikita Kalyazin wrote:
>>
>>
>> On 06/03/2026 14:22, David Hildenbrand (Arm) wrote:
>>> [...]
>>>
>>>>
>>>> Dave pointed earlier that the failures were possible [1].  Do you think
>>>> we can document it better?
>>>
>>> I'm fine with checking that somewhere (to catch any future problems).
>>>
>>> Why not do the WARN_ON_ONCE() in folio_restore_direct_map()?
>>>
>>> Then, carefully document (in the new kerneldoc for
>>> folio_restore_direct_map() etc) that folio_restore_direct_map() is only
>>> allowed after a prior successful folio_zap_direct_map(), and add a
>>> helpful comment above the WARN_ON_ONCE() in folio_restore_direct_map()
>>> that we don't expect errors etc.
>>
>> My only concern about that is the assumptions we make in KVM may not
>> apply to the general case and the WARN_ON_ONCE may become too
>> restrictive compared to proper error handling in some (rare) cases.  For
>> example, is it possible for the folio to migrate in between?
> 
> Not without migration support. But then, migration would have to make
> sure that the destination folio has the direct map removed. So I
> wouldn't worry about that.
> 
> Once you return an error from folio_restore_direct_map(), you better
> document when/why it happens and how the caller should handle it.
> 
> There is nothing existing callers could really do, so it's an
> implementation detail of the
> folio_zap_direct_map()/folio_restore_direct_map() functions to make sure
> it keeps working.
> 
> If it ever fails, we'll have to figure out how to keep the interface
> working.
> 
> You can document any restrictions regarding when
> folio_zap_direct_map()/folio_restore_direct_map() is allowed to be used
> in the kerneldoc.

Ok, makes sense to me.

> 
> --
> Cheers,
> 
> David


