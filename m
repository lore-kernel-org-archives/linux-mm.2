Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4C5A8D37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B06016B00A6; Wed, 14 Jan 2026 08:56:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE04E6B00B6; Wed, 14 Jan 2026 08:56:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BF3F6B00B7; Wed, 14 Jan 2026 08:56:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8AE0D6B00A6
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:56:22 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 31F0E59200
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:56:22 +0000 (UTC)
X-FDA: 84330719004.17.6F7BAB1
Received: from fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com [3.64.237.68])
	by imf25.hostedemail.com (Postfix) with ESMTP id 95A3CA000D
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:56:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Oxr4wNf0;
	spf=pass (imf25.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398980;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w3F8MUhrMvgRZFfwctnZ78oBfLCdFIOc7w3lcR0phs0=;
	b=JyVNVySkj1dVr4ItIXsdpKXr7AZsqY2PaV4rzDc0BYXS8oc9VjBj5pPXZpJnS4SJFwxMRg
	t4BoAxO1x0JeTvIAHck8kIHUM0djfFUhkqlc4GoJ/czg0Iao96sT5n4/wI2rpXdPQY89UC
	yp1ZxKcUfeXsEh57yJSUVVCNRRLUDSQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=Oxr4wNf0;
	spf=pass (imf25.hostedemail.com: domain of "prvs=4674f03ca=kalyazin@amazon.co.uk" designates 3.64.237.68 as permitted sender) smtp.mailfrom="prvs=4674f03ca=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398980; a=rsa-sha256;
	cv=none;
	b=nwF77lLI3+z9HKZkrOvo4KIzCAXHaM5QQU82331yp6Xh2VAdkmzOfvjTyPDnHkmrZz4Wq7
	S7M2dowhxH7BoDoKiAvaezmDLrN86QuyoEsxlDgCGJPEuEDUJgHivLSfZkDQ4OVSXVEkwx
	vvbFYkbYFIidzFDWrh++YH4yQ3HFk2M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1768398979; x=1799934979;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=w3F8MUhrMvgRZFfwctnZ78oBfLCdFIOc7w3lcR0phs0=;
  b=Oxr4wNf0ZAVs0j3CDfQtjEo35WmCkcjp/0VugGuIG1tBchGXtnmq5QGL
   y/nHu9g9YoYRaX/fUYNeWUSi+4X2TPB2JTwgsOAvBRCCHv7tP4GXUE6ZL
   47k7qsQY1MFqrBcGBrcPrIbcCNSrfDFaZvKaFIehkK5ZNLjtIT2oEpbGS
   ytxdVFTDz08hzgaoKaB5uoV1mDCxz6ooVj4X8kDkj1lJV8ssCi4A469Yq
   oxhC/TxyLTPbKcRVsohCVQgc9SxTHeAz2rbBBrYtZfFOWINJWMO6RS2jv
   T+jqBE76cS5ABdhDc6p+b5G7j40rN+q19Nl9MFrEwRc1s9W04cyZA3GOL
   Q==;
X-CSE-ConnectionGUID: XF6mHF4aS6GGlQcAbC9qng==
X-CSE-MsgGUID: y7/KM2RDSRi2eZesrfDudA==
X-IronPort-AV: E=Sophos;i="6.21,225,1763424000"; 
   d="scan'208";a="7809379"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-009.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jan 2026 13:56:17 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:26058]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.37.91:2525] with esmtp (Farcaster)
 id 62e8fe80-349c-49ed-8e4f-57e1f40594af; Wed, 14 Jan 2026 13:56:17 +0000 (UTC)
X-Farcaster-Flow-ID: 62e8fe80-349c-49ed-8e4f-57e1f40594af
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Wed, 14 Jan 2026 13:56:15 +0000
Received: from [192.168.15.25] (10.106.82.12) by EX19D005EUB003.ant.amazon.com
 (10.252.51.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35; Wed, 14 Jan 2026
 13:56:12 +0000
Message-ID: <fb6da8ab-01c7-4c5d-b638-d82c9e4e1423@amazon.com>
Date: Wed, 14 Jan 2026 13:56:10 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v8 05/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: Dave Hansen <dave.hansen@intel.com>, "Kalyazin, Nikita"
	<kalyazin@amazon.co.uk>, "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "linux-kselftest@vger.kernel.org"
	<linux-kselftest@vger.kernel.org>
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
	"Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20251205165743.9341-1-kalyazin@amazon.com>
 <20251205165743.9341-6-kalyazin@amazon.com>
 <51a059a1-f03a-4b43-8df6-d31fca09cce7@intel.com>
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
In-Reply-To: <51a059a1-f03a-4b43-8df6-d31fca09cce7@intel.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.12]
X-ClientProxiedBy: EX19D015EUB004.ant.amazon.com (10.252.51.13) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Rspamd-Queue-Id: 95A3CA000D
X-Stat-Signature: o9rqy36rhsco567wo4wg4i5at6hodwa1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768398979-739731
X-HE-Meta: U2FsdGVkX18MdneN5bphN7O9lGvdxzKhqa7UJf6io6ladBMtdgQMuebv3vKo4zicNETfQc+Qa6ndkprYoe4oq4+o/alx6fFTuyqKGJlUvyl8zJ4Emz4AK8eVwODjLmUnE918RVz2XHUY1wnGcMXNXIFBlbCgJGP0WSh3foTksqa45w9dUr3Bd7OaVJ5JDNaNZfTWDg4ReCJ06CZ29ENc8Plnyh9tHCyTBW1L/lby+J7PhIrSGhLoJ2Znry/dmI2ruoZwNz5jm/PYgpDrCmVeM023VHoAZnYraTdOq8Qlc4nniqcs084ARFFRbZz1FJq5YQgA3K6TTuwt1Xwz2jaGNFqkwirASXdeIwoOZzilFm0t0eDkIZbVosHT0Sr1f99FUIdjoIiWWw8atcWfNeIFF/KgK7ZYUYR9Hl53kclW3sdPFhU5Rgkyzc1cgfp0MNbqfESBanSApe35Szg6utpBve5rDESJavV6U1JlM1jKe2/Tcwow5K3kmiJjCt7SyWuvQRyAd10rX+nwjBKATut8NinnvO8GM0X8DSLRxc3IcYP+70hLTc5rowu+etIspN+eEb8IsNGPME4H6vNGYKXn9CQYRyuK5sRpTtIDXfd7BYr/0Ao3JZLzF4uSAsTpcYEXIHxPeZbglLJHJso7btMkRieSbr107XxeZYgTGD8bkKBpb6lg5ITjFKn8UvK8jYPM12mCt3yBN3ZybvRm/WfMzg4B2dz9nOXosPQuYLOIxyEz5Dv+EzlHHuAakfw5XnubgHLPTmXoZYKYRWqYY/eN8Twof+1zWbauE40gzn9+8DVykIeI74i5aRtqVumHlL/aNkrtVH4aIBewPrQyrL61gxEIIFrNAgXrieJg5ysHCPAKHfLPngmYDR/7wXEYGnyH5w8KcS/tHNzlmvPchfnRT1uc3ch8Hv3qZJtScOE//idtg0V4tIE3h7fmpLmZ4hqJNgLExUrAEPfQQefqvlV
 fR1bEGwQ
 KxdkW93lolEsAvI4sV3VjWO6ovEDmr5rbM3FRyzqg/HNb7y2OP41d2XcPA8VvDASJbmXxJLzY3ZzPZTYTDXRlf2/YtFMl2EsBeArHaHHfvLUJGSeXABbiv7eWpqlu/r1qSoLNDRqvb99HYGvvmAYVboiOmjiDKPcYoB+xyZ/CjkaMyfjeO56qrghSWD73FkeuO847gUxkJdOo8EfFjOsUXB+bwvWeIhoNO9rSEciXcQ1gjmRSQH0nfaK50vhhKxRUAZNQxxGDKZYn4Z9jhEuFh1NT0P+S8/d/IVyp7P7TWN/nQUHAYJ5sQbXH6Ity/J/VhfEcW9C8zi4joLtZsIvU4E6x05E08TAPkudViI09SpvrfAoXnayf7++LGqVChAwAqsglqHQNsNEPj9pTqyIOum9NLpzAjSc7JZOVhP7DgJ/wd6EZg6g91KB8vcrDYoFrT4QOhejzIQ9qd1MiCs4inM+T725MdoZuOiu50fOuju/BZ9uMF6QcwFPuLNEGyJcjVT9iprSmK49s/EhpenIJGUYplv5lUEfZBRdxFdRtRMu3Imh7CDZ4g3xs96aTfH7FrqlQ7/0zfspsveN5TVCyHPhtiNcnFRpqezoeJdaKjbGV6InFm3smk5BGC15eaeMH23HgPIac1YxtcqRS7/kgEFLlRecw1kM7+jKBeDnCF8vytkjbZl0FEY+0DJsWjcVtinj6ytrg1JYfJoU4b6E/rHW7o5J+OhOJSFrTG3u5FfulaKVLyEKS35uphFyMqjon6tEM3AT0RMjUBUKX/ZtzdyMOa2xpziUgPV8Iwy+XRXIXfC2gmv9z2vtGkML80daaxz7nADqufanciZgZAcApZ3TUyER3c5qI0cE4IKZr1GUpnL/+fjzYCQt+cGwjXiR0Vfjx1WmXLQ0dSYrHxrKzZB6dFY7wRGSLYVBsGQ0uSxJnKhIaOINxiiXV2Us19bbGFe+KAo4/ZQFThKmuQFIMuVmlTMHW
 V4U68wZO
 AfwvCOEWcgdxt6mUb2zf66fkKk59Dr8U
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 17:30, Dave Hansen wrote:
> On 12/5/25 08:58, Kalyazin, Nikita wrote:
>> +static void kvm_gmem_folio_restore_direct_map(struct folio *folio)
>> +{
>> +     /*
>> +      * Direct map restoration cannot fail, as the only error condition
>> +      * for direct map manipulation is failure to allocate page tables
>> +      * when splitting huge pages, but this split would have already
>> +      * happened in set_direct_map_invalid_noflush() in kvm_gmem_folio_zap_direct_map().
>> +      * Thus set_direct_map_valid_noflush() here only updates prot bits.
>> +      */
>> +     if (kvm_gmem_folio_no_direct_map(folio))
>> +             set_direct_map_valid_noflush(folio_page(folio, 0), folio_nr_pages(folio),
>> +                                      true);
>> +}
> 
> This is rather hopeful programming.
> 
> I can think of a number of ways that this assumption might become invalid.
> This at *least* check for set_direct_map_valid_noflush() failures (or
> whatever interface you end up using)?
> 
> A WARN_ON_ONCE() would be fine.

Done in v9, thanks.


