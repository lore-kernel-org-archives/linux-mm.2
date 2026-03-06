Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD3BDF0182E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:49:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42E756B00A7; Fri,  6 Mar 2026 07:49:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EF1E6B00A8; Fri,  6 Mar 2026 07:49:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D4A06B00A9; Fri,  6 Mar 2026 07:49:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 17F1B6B00A7
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:49:22 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFF3D1B80BF
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:49:21 +0000 (UTC)
X-FDA: 84515618922.04.1AAEB37
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6F9A7A000E
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:49:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ay0F96w3;
	spf=pass (imf25.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772801359;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bRMHQdQ5GfQ08jWBNyGRBN4vXmA9+fBBCWCkl04FNjQ=;
	b=PuBisf74ypRmeeiZ5NUj72gGuBSqY4SnUYOO8IuN6imy1s0hP0OpZ3ufv0yTYfXL3D0v8t
	iAaDXPokkAcJEGU6mze594aqoYUb5ZjD/t7uf21D9JoLc3uv8LCTPz/35gcRozALTAZovO
	Bx3+KmrnsN75pocYRocXvXgmkDarZh8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Ay0F96w3;
	spf=pass (imf25.hostedemail.com: domain of "prvs=518a0fcdf=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=518a0fcdf=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772801359; a=rsa-sha256;
	cv=none;
	b=uioDiYYbHKeSgJbnjkv/8F0Xa7PZvZKXOrV0ifDtpWsiRzlT2vUjds2TRgSwfTxfozm0pF
	Vn8480oEPOtFmjuPVS6JVwcIoq2GhuZsJGQkF/+MFzlK/gpTHUXJygbzk8K+UP0fvkyQyS
	KNViHRxXnRsTkc82E7Uc2VUZq23PxVw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1772801359; x=1804337359;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=bRMHQdQ5GfQ08jWBNyGRBN4vXmA9+fBBCWCkl04FNjQ=;
  b=Ay0F96w3RVw2nm9FgxFQd0sC5fktbIchaKwSfO23sZWwD7ihM2x2wRvT
   NoKdM31efeHTiGLW9DMguDe/Kb68smNDT1K10yhnwJoTiAzCa05BT+6FD
   A+J+mTdjwVFGVQLz76hoa0J9Je0mjftPrNbSOq0meXlU1s/s9l7QEifsX
   jyR0G8XVNrAzoGcyeravQ7n4UrxLrS0pRljOw3yw8Ozi/ciEBUCUuL8JZ
   WkBlymruZ6q/BE0WZSyw/mAXwhXhxNUrzbnC2FSyqE6i3LrsGi/2fz612
   r35wqmeOklrk6CS6TJTw7FCKrYi/13CM80qoesc9ZQY/LQt7ivvLAvMPj
   g==;
X-CSE-ConnectionGUID: +CBc8LTUTFyKU3vgne5J+A==
X-CSE-MsgGUID: SsgvaCDKTQyRTYkBnx7yEA==
X-IronPort-AV: E=Sophos;i="6.23,104,1770595200"; 
   d="scan'208";a="10334046"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2026 12:49:17 +0000
Received: from EX19MTAEUC001.ant.amazon.com [54.240.197.225:27792]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.8.50:2525] with esmtp (Farcaster)
 id 3c65634d-d2ee-42b8-a0db-5e2cd1d9a376; Fri, 6 Mar 2026 12:49:17 +0000 (UTC)
X-Farcaster-Flow-ID: 3c65634d-d2ee-42b8-a0db-5e2cd1d9a376
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC001.ant.amazon.com (10.252.51.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37;
 Fri, 6 Mar 2026 12:49:14 +0000
Received: from [192.168.2.180] (10.106.83.26) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.37; Fri, 6 Mar 2026
 12:49:09 +0000
Message-ID: <a2d34a91-1d38-4d9d-b7bc-8315245a08a6@amazon.com>
Date: Fri, 6 Mar 2026 12:49:08 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v10 04/15] mm/gup: drop local variable in
 gup_fast_folio_allowed
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
 <20260126164445.11867-5-kalyazin@amazon.com>
 <ebb4beec-13dc-4b94-a1f8-756e7a8ef5af@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
In-Reply-To: <ebb4beec-13dc-4b94-a1f8-756e7a8ef5af@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.83.26]
X-ClientProxiedBy: EX19D015EUB002.ant.amazon.com (10.252.51.123) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 6F9A7A000E
X-Stat-Signature: zhpqgti1sydywtyaonbidrkbhga14heb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772801359-842345
X-HE-Meta: U2FsdGVkX19IgdC21YU79p9/xcsl9jW0MIdzL3pXdZBmvkMxocpS32FzeAEfPidkRG8DDe0RrsfhJyBr1AlNRga26fb6VfDTaWxrjeVptw07ku6jOTxYI9JbOfCCKeUo0FaMuGLSlS+zHinXEjfo6anZhJH24+L7lfGAYDRVYay8yfpmCjIF+A7vfkDRdmlRW16CPClYNJhlExaTmY41vrvXFfDpkdF7VoWP513LsIdEa2X02HuARidj9OU+cg/9JwMY4U9ZZU4o3DZnrhaMdTzHhppwpWUyAj1oR31VBZIJtq3jrIp7LHvbR/xPTPcgiN/RSEHlH1Fo3hNFPuw2YHInyf04uKrfRYznxRHH53mKomMISHVfKojUP3q5A9RPPhFRJ/8fBy1RPoiXM6izdmek3xPeljmesyCgENlZoDVVryG6510bH9eXewG8JdAd0g0baLiwIYT/5nkjUQgzvMjn/8qW1SdK/AL2PA7Kp8F2gL3JkKxNsYUN49xVBTJLpF6HQFGG46/eXRdI6kK9FYscFibC6Xhr/UxQKI7iPVljt5y9jnK1DPjO/GRD7WradBtlmBsLDMS8eVPi4OdtfdNs9uB8dZD5O+ghFBgg6kVUA+D4Ohnrb8HyYIVB0+AwYEXoImZKhtC7ABERJw5riP+wOEyWIQ4ascwiD7kDmDQyQvg4kuhfctu8yfpumxraPH6xZU/eda6sukCGgxSnjhtyF4d853+tizMQIcJi0c7S5UoFApF2dD2/Vxk1Fpf5D9z43XGJ/CNdI0IQR83Jv3g+b7/y4reZ9w0AMPXeGp2YN4BpJnITT0X1qnrSier56Fnuipzbt4D72aoknGRPD8KiwcUiaF648GuKZbgLfsY6g3SXUeQjJC/U4VqL2HjKHkfmE+L3q1z7mZwTwjsjOJUeYJ42y4qIpJBtJJ0urAg0G1dfGGgBHudDyATXnWQhn3/dTdqTcE1NOmAeJ1+
 ca0c6uuv
 0/UAsmKg3wje+jHKp7GjW+peuPwVSj6i/annUpJEKpvejzxb+kKkf8OSu/CQaCkfshNz/3F8fanZy9lstg63KhNiZxTaLJOqSIWh4RPyl17RfZNKUPSRJe+DUG+gDpVqm+siwqNLDHNd+XflMgBPWfsRyO0A5OTLZ8lPtPrhYCH7MPdfNdrX2nZ1sy96HJ8kySIU1OqmErxSOdypNOsJEpAh3N8tqKFtjWE/Nej1rdTXJu6jtpDDzUzrC4LNJUq4W+knyNkQyOquKxSs1WJ7FAepGOTiN7tKh3vnoUUMPQ3fB7ONyIS47LSggon1LGz+q8YPrm2+d9Zcz3mK4JXdyD4XjlhCqoizEVGl4rUY01qoCdfL2ZNNupRxvydlsJLESOa/k8bq2KtaxgsE1gQWN1E8vGKrlyRvPmAO9yaJZYoxg8k37bNFb8V3EWtmNR1XX0G1ivKiwUv6T4NXPxsE+iu+POKYpt/+dLmmQfVW4z4f1H/UIFEraj3QliPl3BXGSPNXd8GdLtPfDxkqo8nNO6x160O9gIuw8i23J5J5um87xmB1vE3W705oBy7Dj9wDUuRjUaDcvLRCJ5/MKm7cVM9rB1auoppSfkdc/qB1iFqNIhV5kPhJiLZbASeX9I9nnlgynE9bjtD+GNLEiRc1Fp5UMeu/VPHm/gvQdLNftMaHbqVg/tBWcf49q0Znunw2NkpvRenmoAZ35OoREUOnPS98GWAowvbDA6znIPbsTzU8c0UhlFoghT/orYnCETsfox+wTpStALZbCOQ3Bn8/M8FVWENP774diwif7fCs/+UctX9cesT4Aleq4kExd2vQdNgMUjOBO7VP3sb54cvA7h4RgyraLgekf5KdlJ44ZUzI4KT2VjKAQ3V2X+y2wxXfhFs+hSA+WEODgyT5XPWHT0H3YsutzMEdYgpVbHp7Lg4OAjikFIGH0Y8+5eMwJgpbHfsNDxowQh/3c2L6C7j8RuRMXRbnO
 Bv6gEPRS
 13oiOF4OUw5/XBMR0TNlphwe+W4rUrxB+937qIt3P6q6D+C2tAIkNDFIBCJ3UQTF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/03/2026 19:07, David Hildenbrand (Arm) wrote:
> On 1/26/26 17:47, Kalyazin, Nikita wrote:
>> From: Nikita Kalyazin <kalyazin@amazon.com>
>>
>> Move the check for pinning closer to where the result is used.
>> No functional changes.
>>
>> Signed-off-by: Nikita Kalyazin <kalyazin@amazon.com>
>> ---
>>   mm/gup.c | 19 ++++++++-----------
>>   1 file changed, 8 insertions(+), 11 deletions(-)
>>
>> diff --git a/mm/gup.c b/mm/gup.c
>> index 9cad53acbc99..e72dacce3e34 100644
>> --- a/mm/gup.c
>> +++ b/mm/gup.c
>> @@ -2737,18 +2737,9 @@ EXPORT_SYMBOL(get_user_pages_unlocked);
>>    */
>>   static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>   {
>> -     bool reject_file_backed = false;
>>        struct address_space *mapping;
>>        unsigned long mapping_flags;
>>
>> -     /*
>> -      * If we aren't pinning then no problematic write can occur. A long term
>> -      * pin is the most egregious case so this is the one we disallow.
>> -      */
>> -     if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) ==
>> -         (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE))
>> -             reject_file_backed = true;
>> -
>>        /* We hold a folio reference, so we can safely access folio fields. */
>>        if (WARN_ON_ONCE(folio_test_slab(folio)))
>>                return false;
>> @@ -2793,8 +2784,14 @@ static bool gup_fast_folio_allowed(struct folio *folio, unsigned int flags)
>>         */
>>        if (secretmem_mapping(mapping))
>>                return false;
>> -     /* The only remaining allowed file system is shmem. */
>> -     return !reject_file_backed || shmem_mapping(mapping);
>> +
>> +     /*
>> +      * If we aren't pinning then no problematic write can occur. A long term
>> +      * pin is the most egregious case so this is the one we disallow.
>> +      * Also check the only remaining allowed file system - shmem.
>> +      */
>> +     return (flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
>> +         (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE) || shmem_mapping(mapping);
> 
> Best to keep this split and a bit more readable.
> 
> /*
>   * If we aren't pinning then no problematic write can occur. A writable
>   * long term pin is the most egregious case, so this is the one we
>   * allow only for ...
>   */
> if ((flags & (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)) !=
>      (FOLL_PIN | FOLL_LONGTERM | FOLL_WRITE)
>          return true;
> /* ... hugetlb (which we allowed above already) and shared memory. */
> return shmem_mapping(mapping);

Makes sense, thank you!

> 
>>   }
>>
>>   static void __maybe_unused gup_fast_undo_dev_pagemap(int *nr, int nr_start,
> 
> 
> --
> Cheers,
> 
> David


