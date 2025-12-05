Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 450E9D339A0
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 17:23:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 889006B019A; Fri,  5 Dec 2025 12:23:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 860AF6B019B; Fri,  5 Dec 2025 12:23:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F696B019C; Fri,  5 Dec 2025 12:23:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 621416B019A
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 12:23:35 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 662A513A1F7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:23:34 +0000 (UTC)
X-FDA: 84186089148.03.78E140F
Received: from fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com [18.197.217.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id E8E0140010
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 17:23:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nUwL+l9B;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk"
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764955412; a=rsa-sha256;
	cv=none;
	b=tfqF7Dn1ZgCew0dmG9q+Vyhzag1K8sas14Vp7XPe2CKHmSpsN7NcF5FxnyVi3dAEhDaTnp
	MlX8J3Nrl6g8lhp1eqZtbI1859C2nDONG3E83x8Crm1H4My26IKI0VOuLeZeAP2PpZC+RG
	sJ0BlYcf4bTDDSR+jBl+C2xPlJcItxM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nUwL+l9B;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf27.hostedemail.com: domain of "prvs=42773fd06=kalyazin@amazon.co.uk" designates 18.197.217.180 as permitted sender) smtp.mailfrom="prvs=42773fd06=kalyazin@amazon.co.uk"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764955412;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RienKcTqqmsGG8zizmirrEKiZCGuAJt5fOpB1029IRQ=;
	b=EFXM6/1jqZFkhdmY6UP8BZ8ohku56xnE+620A54OcmnHIJmpcN9FyEQm5siSdo3R9akXy9
	6Bbm5M1lLxdrL7hougaU2qIMNEUKIN9MmnDigT+aZfn5IELo87Pxb0A8wcB5Eyr6uYp195
	7G/AtiVgzE6mVaQgEPSU7tzahDwlRVU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1764955412; x=1796491412;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=RienKcTqqmsGG8zizmirrEKiZCGuAJt5fOpB1029IRQ=;
  b=nUwL+l9BiKZ+uIUQHnjUtXiC0HIxcfwQn7jJrgQx5MXceI/tky0Fvu9u
   vCxKRCJa/IQjI6YaIA9b7FFAQVOsMryYam8+uZj8sdz5ONtD5dzsPaQCX
   ihVaeZrTkfdebu/j+Najpm3avnqttguypaFf0octgywbQ34KmXsFkMyc9
   kWGEkYbqZclUAVGPpxFj5dRhyI88VweO2qDN0zqWl6n6J4HdsNXTTmLLd
   84TWV1iHXw999VSiAjtNYgH/Mj/JIiGBvVoSmEnXL4Y9HCiThjr5EhBln
   G7Gc4UzGXX2FMlgEuHxDZ/H9GnLJhnhhqOPWH7iFj/QZur4HBod38ARZi
   g==;
X-CSE-ConnectionGUID: U9T32tygTySwaMWRVIxYXw==
X-CSE-MsgGUID: ezeiUYqjT6+LtvlkxY9Q1A==
X-IronPort-AV: E=Sophos;i="6.20,252,1758585600"; 
   d="scan'208";a="6302828"
Received: from ip-10-6-11-83.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.11.83])
  by internal-fra-out-006.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Dec 2025 17:23:30 +0000
Received: from EX19MTAEUC002.ant.amazon.com [54.240.197.236:4382]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.6.214:2525] with esmtp (Farcaster)
 id ba644cd0-1d42-4328-b08c-52f3a96e0bd0; Fri, 5 Dec 2025 17:23:30 +0000 (UTC)
X-Farcaster-Flow-ID: ba644cd0-1d42-4328-b08c-52f3a96e0bd0
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUC002.ant.amazon.com (10.252.51.181) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29;
 Fri, 5 Dec 2025 17:23:26 +0000
Received: from [192.168.14.68] (10.106.83.5) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.29; Fri, 5 Dec 2025
 17:23:23 +0000
Message-ID: <356ece73-83ff-4c0f-a3fb-4b24df7953b3@amazon.com>
Date: Fri, 5 Dec 2025 17:23:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v7 05/12] KVM: guest_memfd: Add flag to remove from direct
 map
To: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
CC: "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
	<corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>, "oliver.upton@linux.dev"
	<oliver.upton@linux.dev>, "joey.gouly@arm.com" <joey.gouly@arm.com>,
	"suzuki.poulose@arm.com" <suzuki.poulose@arm.com>, "yuzenghui@huawei.com"
	<yuzenghui@huawei.com>, "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
	"will@kernel.org" <will@kernel.org>, "tglx@linutronix.de"
	<tglx@linutronix.de>, "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de"
	<bp@alien8.de>, "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
	"x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
	"luto@kernel.org" <luto@kernel.org>, "peterz@infradead.org"
	<peterz@infradead.org>, "willy@infradead.org" <willy@infradead.org>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
	"Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>, "vbabka@suse.cz"
	<vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com"
	<surenb@google.com>, "mhocko@suse.com" <mhocko@suse.com>, "song@kernel.org"
	<song@kernel.org>, "jolsa@kernel.org" <jolsa@kernel.org>, "ast@kernel.org"
	<ast@kernel.org>, "daniel@iogearbox.net" <daniel@iogearbox.net>,
	"andrii@kernel.org" <andrii@kernel.org>, "martin.lau@linux.dev"
	<martin.lau@linux.dev>, "eddyz87@gmail.com" <eddyz87@gmail.com>,
	"yonghong.song@linux.dev" <yonghong.song@linux.dev>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>, "kpsingh@kernel.org"
	<kpsingh@kernel.org>, "sdf@fomichev.me" <sdf@fomichev.me>,
	"haoluo@google.com" <haoluo@google.com>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
	"jhubbard@nvidia.com" <jhubbard@nvidia.com>, "peterx@redhat.com"
	<peterx@redhat.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "shuah@kernel.org" <shuah@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "linux-doc@vger.kernel.org"
	<linux-doc@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "kvmarm@lists.linux.dev"
	<kvmarm@lists.linux.dev>, "linux-fsdevel@vger.kernel.org"
	<linux-fsdevel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>,
	"bpf@vger.kernel.org" <bpf@vger.kernel.org>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, "Cali,
 Marco" <xmarcalx@amazon.co.uk>, "Kalyazin, Nikita" <kalyazin@amazon.co.uk>,
	"Thomson, Jack" <jackabt@amazon.co.uk>, "derekmn@amazon.co.uk"
	<derekmn@amazon.co.uk>, "tabba@google.com" <tabba@google.com>,
	"ackerleytng@google.com" <ackerleytng@google.com>, "david@kernel.org"
	<david@kernel.org>, "patrick.roy@linux.dev" <patrick.roy@linux.dev>
References: <20250924151101.2225820-4-patrick.roy@campus.lmu.de>
 <20250924152214.7292-1-roypat@amazon.co.uk>
 <20250924152214.7292-2-roypat@amazon.co.uk> <yq5ajz07czvz.fsf@kernel.org>
Content-Language: en-US
From: Nikita Kalyazin <kalyazin@amazon.com>
Autocrypt: addr=kalyazin@amazon.com; keydata=
 xjMEY+ZIvRYJKwYBBAHaRw8BAQdA9FwYskD/5BFmiiTgktstviS9svHeszG2JfIkUqjxf+/N
 JU5pa2l0YSBLYWx5YXppbiA8a2FseWF6aW5AYW1hem9uLmNvbT7CjwQTFggANxYhBGhhGDEy
 BjLQwD9FsK+SyiCpmmTzBQJnrNfABQkFps9DAhsDBAsJCAcFFQgJCgsFFgIDAQAACgkQr5LK
 IKmaZPOpfgD/exazh4C2Z8fNEz54YLJ6tuFEgQrVQPX6nQ/PfQi2+dwBAMGTpZcj9Z9NvSe1
 CmmKYnYjhzGxzjBs8itSUvWIcMsFzjgEY+ZIvRIKKwYBBAGXVQEFAQEHQCqd7/nb2tb36vZt
 ubg1iBLCSDctMlKHsQTp7wCnEc4RAwEIB8J+BBgWCAAmFiEEaGEYMTIGMtDAP0Wwr5LKIKma
 ZPMFAmes18AFCQWmz0MCGwwACgkQr5LKIKmaZPNTlQEA+q+rGFn7273rOAg+rxPty0M8lJbT
 i2kGo8RmPPLu650A/1kWgz1AnenQUYzTAFnZrKSsXAw5WoHaDLBz9kiO5pAK
In-Reply-To: <yq5ajz07czvz.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.106.83.5]
X-ClientProxiedBy: EX19D008EUC001.ant.amazon.com (10.252.51.165) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E8E0140010
X-Stat-Signature: o5k1qrjesadsjs6ean8skkfdfoaenboc
X-Rspam-User: 
X-HE-Tag: 1764955411-282589
X-HE-Meta: U2FsdGVkX1+GX8F/7Po/YEmLSaQo77ubZPDwYplhtPTPl26mpu5Do/OwlFJb0l6ZSq9lsOonr8/V+/rcOuzopfOFMm42FpbPb22bzZwaIzpdEKYt2VJs+Fa6DkNiy8AzMVVrI3RqQj9OqC2DQF9fQwHrbvVEu9vu4TTpiDde1l0vJzR0DR99qawlsdAJkWdUzeqM43dUcMEW5PlM2MVo0Ak34biml2sSSa1sW2NMA0UY6EqQEd97wBV1131+Z5TfPqxdX4AGzjSjKq+s5F5mh3VGh9EF1J4bRvyN5Na7SUysrJCJxgW10GIVAB2c2HItE2+QGwsezubqvAesSblZQ9YxDpkjVcPN6HNVxjTxbRrirHt7+KcW4yoRuT3NAD2SYa3Bm7RATdWHs5vCMW/pD04PiPKEH0O23/JqjH3K1VbDy5lNY5nl/axzb7j311teGWDzn19aQhSHQ4s1f+YzY840lIGVZKKgEQclcUvU5XrvIkMYMbXGT2Y+8mR256s3tYHJbPq2GMyssj4MHey+J8bwwBBYyYfSYgWuhj52E1OLy04kk5WuhYkXXwriwyMTkBkp94A2mYc8HXsOU+i905qFSVQSqD4QRZ5YVZhpLAYhAQU7wm3Z6xT9C79myycueCwXHztAvh8JT7jK2/1UvgVBrrA9axkFUj1qQbR2KE87zWtjX0hZqH3yASoQvPAQIWb6KE0rUreuFYTPwOajN/TUQ/MoXZSnl353aDmmTUuKvvTk1Y5at6sfeh6Y2hkhQdbPHyvWqQpRJdhLcA1o7ItFYwF6oyF2AjLelZmeeT0LPXRlU+mzA2R1Qf2+6WHHivA1yNLnr7wq4eEYCrYrkeY7OJuNdx9xf5pyzlVs3rYtLnfWoY8CbN7y7aSDzjqRs16x3nUNpgRAGU5hrdbHKAD7oHA/aYYriB1M3mmKio+C/af1drVHDG6Sno5/FWFRYKahMJSoEb59/VVYoAx
 tIU/ZNHm
 6Agtbmz9CvnyzpDK88+eXqvLrGwC2VZd9TeIdmMHLbssAcTnkD8kh0omx2iQbH7CbVQUOQohoJirmLsBbbnK8O3xVdifQPX195mFNbHjCGmcyszRM28ORjEf4eXIZ/Ol17puLONPTPp9uIeLMGtOuYmIk/l7Y2DbMJoTVRQL6m+YVfn4eDOa3hrwy5bDEnJhfsrmHXqBun0sybpyi1RLDyBnzqHlellICVPtRgv/eoJQvTFIyZMiGWiPUM2bHFXLy4Plgs8Ue1/sMl5dFGCiF7cX1pq4be78PszyLThK2PCCl9jtlYn9850espLngqmPGEBb1WXEBjjJWVxGyqa2cfGTbzvCQHU6mH3omrqVrF41jJYvtzphTKmrOHeRG5yQ5EKCRBP+yYhsJvJ7JEGmp38DgbhmHndsvt1eqx3siDxrzSUEU8G3YDLow5aMCZ4iHRkkgtyx2E0IkpWPASqP3q3EvbyYN+iAokpr1HKe74eCibl8fH7tEX1KgJ3FeDZAUb8UcFb/Ca39g5I2asZbCW5ULYyCNZdLNaTl0FFrHZB6f9ukMbsQEHzI7YvV0OjL9gePntU5Q6G56Dyg3SpezNV86ijKyL4JX09Yr6X9XkwM31BGuweAd94bh41xPp70s2OvN8Vnzfu0QpPGHtC7NFxo9k6UlSkXnNeCCmBSDAlwf7SKGTnFcY/9v35hhHtnjprAfAXpCuxCam38bhJt5jRnARIKVJ5AHn/9nIRiYytvVuK8sJcf7Qz+GPGuhMn+DP0Ta2pIGZw3Nrt4Xd+NB0gu7s7sxD6grP5t5sO9YZm/EXGZWUmZyuYeDy1iLWWNBeDpfgVmEISjTe0Wmh8BVvFuFNtzaascTWnTCvlI1f23pzx2dTFwP8G40Dgcju1g8ygUh0Mec81cA12bmTWJTup3rDiYxWrt9BPOSyyb3JjQolByGVbbVJbiOgN0WcEme1uowcEyGtOwESNgY2rTvIk5ffoLK
 qSxKSmee
 m8RQmNmkxOYAGRKp9agBQZDtlaYhBdLYLEjLdFTm097vM0EIR2pP1K/KQW1EkxCBVaiPOLGQq13Dv+W77tNAqUfG/YaK8R2C
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 03/11/2025 07:57, Aneesh Kumar K.V wrote:
> "Roy, Patrick" <roypat@amazon.co.uk> writes:
> 
> ....
> 
>> +static int kvm_gmem_folio_zap_direct_map(struct folio *folio)
>> +{
>> +     if (kvm_gmem_folio_no_direct_map(folio))
>> +             return 0;
>> +
>> +     int r = set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio),
>> +                                      false);
>> +
>> +     if (!r) {
>> +             unsigned long addr = (unsigned long) folio_address(folio);
>> +             folio->private = (void *) ((u64) folio->private & KVM_GMEM_FOLIO_NO_DIRECT_MAP);
>> +             flush_tlb_kernel_range(addr, addr + folio_size(folio));
>> +     }
>> +
>> +     return r;
>> +}
> 
> These 'noflush' functions are actually doing flush_tlb_kernel
> 
> [-]  ∘ flush_tlb_kernel_range
>   |-[-]  ← __change_memory_common
>   |  `-[-]  ← set_memory_valid
>   |     `-   ← set_direct_map_valid_noflush

Hi Aneesh,

Thanks for pointing at that.  I ran internal tests and it appears that 
the second flush_tlb_kernel_range() call does add a latency similar to 
the one coming from the first call, even though it intuitively should be 
a no-op.  I have to admit that I am not aware of a safe way to avoid the 
second flushing on ARM while keeping the guest_memfd code arch-agnostic. 
  Perhaps I should seek Will's counsel for it.  Nevertheless, I don't 
think there is a concern from the functional point of view.

Nikita

> 
> -aneesh


