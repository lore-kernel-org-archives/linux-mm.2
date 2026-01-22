Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A729D6CFA1
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 18:05:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F11B86B02EA; Thu, 22 Jan 2026 13:05:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEA386B02EC; Thu, 22 Jan 2026 13:05:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DE91A6B02ED; Thu, 22 Jan 2026 13:05:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CBA386B02EA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 13:05:20 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 75E401A04D5
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:05:20 +0000 (UTC)
X-FDA: 84360376800.26.6E0D99E
Received: from fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com (fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com [35.158.23.94])
	by imf21.hostedemail.com (Postfix) with ESMTP id 05EC11C0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 18:05:17 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WoaRQ+06;
	spf=pass (imf21.hostedemail.com: domain of "prvs=475c5ed80=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=475c5ed80=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769105118;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VQH+ZVpl7s1y6QFfIzvVBX/lOO8CFVE93gGifWyjYo=;
	b=BCa2FgIHgqk7HTWmjhD+PhExcbGoOjF+85LoLM+AQZjZxZ78gHFtR0ept+rh0idC61G/2E
	aDjfdWOf0Fym++RlQoSRSD9DnJvUiE6mv40xDvXHACtD3823GFHN/j7OYHtsRq/Flm31tz
	0XdSdALmkJl6lgsYTTiEeKkw0pRd3qg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=WoaRQ+06;
	spf=pass (imf21.hostedemail.com: domain of "prvs=475c5ed80=kalyazin@amazon.co.uk" designates 35.158.23.94 as permitted sender) smtp.mailfrom="prvs=475c5ed80=kalyazin@amazon.co.uk";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769105118; a=rsa-sha256;
	cv=none;
	b=fdHrHRGoWrOnNwCI2ESvH70BnPJzBkPA5kW4Grgf1qMatTWP21w83k1TVJocQWG9tg5piS
	9ZSVsPHL7jGbASqP9e8bt5iQOdxujzG+4RIMB5yJocGujWTwhNnGNJTYKT9RnY+4oeRW4K
	homFAN52zYGka+8AN8FJR8etYHkcEio=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1769105118; x=1800641118;
  h=message-id:date:mime-version:reply-to:subject:to:cc:
   references:from:in-reply-to:content-transfer-encoding;
  bh=/VQH+ZVpl7s1y6QFfIzvVBX/lOO8CFVE93gGifWyjYo=;
  b=WoaRQ+06cPx3e45oh8i0GC4ZsQDdVy4FBcnXUPi8RiPxj5G+FQJWUQCZ
   ld0HNFro0wwSnsKLPgiYz25NXyTNnvHe5U/RPTtaPZ4fnxT0MrevsC8bw
   P1Y1m2BbFG2cKR58445g9Yr0WXZoI6/UVKYco8TD9f9PRTYoM9JxKJZB+
   BUqwFW6Bv6CF/6Qi/Osr1tZAjm4yIEPal4TaT2EUD8djnx9JsJ80GFX5v
   2+1VnvUl9rAgVbHBIW8nebxG7XPAQn8UhzIWrJEHCI1jjEQifICVyMxV2
   57pOc7VMa31EXVOLDep8J26coxjxph9zK21nm5O2xui7gki0PyAl6Cr5Z
   w==;
X-CSE-ConnectionGUID: FzJfTE6DQPiBT8xS65L//g==
X-CSE-MsgGUID: NWC2jrzvQJKPewYEWGLFVA==
X-IronPort-AV: E=Sophos;i="6.21,246,1763424000"; 
   d="scan'208";a="8303027"
Received: from ip-10-6-6-97.eu-central-1.compute.internal (HELO smtpout.naws.eu-central-1.prod.farcaster.email.amazon.dev) ([10.6.6.97])
  by internal-fra-out-008.esa.eu-central-1.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Jan 2026 18:04:57 +0000
Received: from EX19MTAEUB001.ant.amazon.com [54.240.197.234:24209]
 by smtpin.naws.eu-central-1.prod.farcaster.email.amazon.dev [10.0.13.107:2525] with esmtp (Farcaster)
 id 3ec1e9f4-fd44-4c0b-b87e-d835b8518924; Thu, 22 Jan 2026 18:04:57 +0000 (UTC)
X-Farcaster-Flow-ID: 3ec1e9f4-fd44-4c0b-b87e-d835b8518924
Received: from EX19D005EUB003.ant.amazon.com (10.252.51.31) by
 EX19MTAEUB001.ant.amazon.com (10.252.51.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 22 Jan 2026 18:04:57 +0000
Received: from [192.168.23.186] (10.106.82.17) by
 EX19D005EUB003.ant.amazon.com (10.252.51.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.35;
 Thu, 22 Jan 2026 18:04:53 +0000
Message-ID: <f2f2a6bd-5cb4-46c9-a0f8-3240670094b5@amazon.com>
Date: Thu, 22 Jan 2026 18:04:51 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: <kalyazin@amazon.com>
Subject: Re: [PATCH v9 07/13] KVM: guest_memfd: Add flag to remove from direct
 map
To: Ackerley Tng <ackerleytng@google.com>, "Kalyazin, Nikita"
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
	"kevin.brodsky@arm.com" <kevin.brodsky@arm.com>, "maobibo@loongson.cn"
	<maobibo@loongson.cn>, "prsampat@amd.com" <prsampat@amd.com>,
	"mlevitsk@redhat.com" <mlevitsk@redhat.com>, "jmattson@google.com"
	<jmattson@google.com>, "jthoughton@google.com" <jthoughton@google.com>,
	"agordeev@linux.ibm.com" <agordeev@linux.ibm.com>, "alex@ghiti.fr"
	<alex@ghiti.fr>, "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
	"borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
	"chenhuacai@kernel.org" <chenhuacai@kernel.org>, "dev.jain@arm.com"
	<dev.jain@arm.com>, "gor@linux.ibm.com" <gor@linux.ibm.com>,
	"hca@linux.ibm.com" <hca@linux.ibm.com>, "Jonathan.Cameron@huawei.com"
	<Jonathan.Cameron@huawei.com>, "palmer@dabbelt.com" <palmer@dabbelt.com>,
	"pjw@kernel.org" <pjw@kernel.org>, "shijie@os.amperecomputing.com"
	<shijie@os.amperecomputing.com>, "svens@linux.ibm.com" <svens@linux.ibm.com>,
	"thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
	<wyihan@google.com>, "yang@os.amperecomputing.com"
	<yang@os.amperecomputing.com>, "vannapurve@google.com"
	<vannapurve@google.com>, "jackmanb@google.com" <jackmanb@google.com>,
	"aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>, "patrick.roy@linux.dev"
	<patrick.roy@linux.dev>, "Thomson, Jack" <jackabt@amazon.co.uk>, "Itazuri,
 Takahiro" <itazur@amazon.co.uk>, "Manwaring, Derek" <derekmn@amazon.com>,
	"Cali, Marco" <xmarcalx@amazon.co.uk>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-8-kalyazin@amazon.com>
 <CAEvNRgEzVhEzr-3GWTsE7GSBsPdvVLq7WFEeLHzcmMe=R9S51w@mail.gmail.com>
 <a2b79af7-e5d1-4668-bff3-606f57d32dfc@amazon.com>
 <CAEvNRgF46M1jp0+eBu2wQMO7P1afyo00SOkENFwvB2KYX3dnFA@mail.gmail.com>
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
In-Reply-To: <CAEvNRgF46M1jp0+eBu2wQMO7P1afyo00SOkENFwvB2KYX3dnFA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.106.82.17]
X-ClientProxiedBy: EX19D002EUC004.ant.amazon.com (10.252.51.230) To
 EX19D005EUB003.ant.amazon.com (10.252.51.31)
X-Stat-Signature: oj9xu5on59jiwkgdbw1mprzxounzqnza
X-Rspamd-Queue-Id: 05EC11C0007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769105117-971655
X-HE-Meta: U2FsdGVkX1+f0xuWUVSX2vFh6t69iFjX7RNfbqPOi501PRpHMbpSOOOoGog7XIZttOV60vsmYjSmANo9yMLfWb7oIqWdzF8eALlFTVhW4UilzUiiiUW7H1DmIyMAXf81yty5Y4uEKHnSuYbMo6Q5y/tQwAgyHYmBHEzmg7/lWKzM7cUwrZY1Y34FIVJwvDI1YxQgt9CSDENAN2kBWxP6VIP2eZ2L7e9WZtx4rcCCQG4nKWKMBGOro+QWg94fI3Lhb60qg2eURs9I5ZF+OCt62geiNy0CAlNmZ52CdQUmxeqvfGtgWCccqz9AeiSdy9g7J3dyQempFbn9XQYF35IQ1wxQv8hJK8XRuF+cKPv8EZsu4lU4CzZxzRqy3FTfHDXLZrtMC7q+9tQWBaVci16krS1vDyRDv0mSqVM2G6sCuGC1KLBF5FGkmENlCIltDW187YVQIdttC0xIFemSbKovIVj2CZgU3/PNmWxL0NUq8ZHS/RlD5gRsh5fTVJsoe28zFdvqeAypTVdorb/tCkx79Idj7wpZw+fTxA57kMbk2VTaNtmBI34Si6mhymNMtIyVXrL0NefqXxGvSElVFLAN9FNstOaT0ZFOfzD+VId5ZaFjFNXfSXTc49e3eUS6D5V5dIPTYGAISBc7hpwjbCp/YaahSHQsVZaTvbzfg76ESDrVHXdTIPWbsNdb3h5RAD/o3VSqo3gakb2kXukyzyexG/nRwLRLczV3Aki5+sqFdkiefAQ0/5GPmA23KPZrQN2h/Z12jQvK7EeChp5/tcb4GjZZx2MEdlq05kGW+2nsP879DKXSzk/klOm1dWm5r8rP0kZ7hniyddMu9/TNc6w8Q+t+4RdSrcsMro13sm5CBcjxaLtK0FlywN1YirklwYs13mFV+Z4emc9/yCF1HPScg0SciYwLOj1z1geG63A9QOFltzGbMUI1sLQabA5LJ4sR7jBaHeuPbVNvyvPalfo
 0AiJdTcc
 Ur3yo1Ymj/aOiF/5ilNoifEitv22w4JKZvieWITtWg3eCesIHnO+djqPTidCasiT7bxXBPbO+AVDo2ozjrAbhcH4/r34LQ3+tn0S6OpXXjuOpslLF9t/CxIIq/Uqs1B4pJTbrkvCCYrEnFSi7cGxp3sCxaYzSJfWmT2D7N57bQfxQJ9kjspOJlOd94aIS3VbwQH4lK3aJgX+jH/7Nrh2jKW/guK6PQbacewPyZDC1h/hA/Ia6qp6IXV6MwdokTHtIYHKn7CRoZ4Smm4I8HtnD/5meVeCXo+CW1p0ZQTEpT5TmkjltBuLkcKGEz1uO3kdZf/Wh5Ouq7x8aOn3i9M1lfZctrqLwPKjKh+1Cvuwx+s3Ozwf+dNttU1IbNMeC8cQSatCULIDYjvplHTTnh1vAr8pSaBGeh4w5fB9L5W7z3CdsL7vgi9bPapA3qHEjsynfsJ3YuTqwUNk+c7LEXEZGGrv5keJ1KFwFX4kxynJBiJzMVSPX6zZMZ+FB4kf0m2cMExEmJRKok7eoJR5HMfWYDiDiuOfu2tSzHhXop8LkwyV5pUYOx7oHYFZDmkh1SVknjx/+Gt3GMHlGaP2yFV59cYa1teEeRpNhtmiSemzMhUUp83t+EVtMUXwxveg5IWtMWaVr8EncvmI1r+LIhxz+ODj2ig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/01/2026 16:34, Ackerley Tng wrote:
> Nikita Kalyazin <kalyazin@amazon.com> writes:
> 
> Was preparing the reply but couldn't get to it before the
> meeting. Here's what was also discussed at the guest_memfd biweekly on
> 2026-01-22:
> 
>>
>> [...snip...]
>>
>>>> @@ -423,6 +464,12 @@ static vm_fault_t kvm_gmem_fault_user_mapping(struct vm_fault *vmf)
>>>>                 kvm_gmem_mark_prepared(folio);
>>>>         }
>>>>
>>>> +     err = kvm_gmem_folio_zap_direct_map(folio);
>>>
>>> Perhaps the check for gmem_flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP should
>>> be done here before making the call to kvm_gmem_folio_zap_direct_map()
>>> to make it more obvious that zapping is conditional.
>>
>> Makes sense to me.
>>
>>>
>>> Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
>>> this call can be completely removed by the compiler if it wasn't
>>> compiled in.
>>
>> But if it is compiled in, we will be paying the cost of the call on
>> every page fault?  Eg on arm64, it will call the following:
>>
>> bool can_set_direct_map(void)
>> {
>>
>> ...
>>
>>        return rodata_full || debug_pagealloc_enabled() ||
>>                arm64_kfence_can_set_direct_map() || is_realm_world();
>> }
>>
> 
> You're right that this could end up paying the cost on every page
> fault. Please ignore this request!
> 
>>>
>>> The kvm_gmem_folio_no_direct_map() check should probably remain in
>>> kvm_gmem_folio_zap_direct_map() since that's a "if already zapped, don't
>>> zap again" check.
>>>
>>>> +     if (err) {
>>>> +             ret = vmf_error(err);
>>>> +             goto out_folio;
>>>> +     }
>>>> +
>>>>         vmf->page = folio_file_page(folio, vmf->pgoff);
>>>>
>>>>    out_folio:
>>>> @@ -533,6 +580,8 @@ static void kvm_gmem_free_folio(struct folio *folio)
>>>>         kvm_pfn_t pfn = page_to_pfn(page);
>>>>         int order = folio_order(folio);
>>>>
>>>> +     kvm_gmem_folio_restore_direct_map(folio);
>>>> +
>>>
>>> I can't decide if the kvm_gmem_folio_no_direct_map(folio) should be in
>>> the caller or within kvm_gmem_folio_restore_direct_map(), since this
>>> time it's a folio-specific property being checked.
>>
>> I'm tempted to keep it similar to the kvm_gmem_folio_zap_direct_map()
>> case.  How does the fact it's a folio-speicific property change your
>> reasoning?
>>
> 
> This is good too:
> 
>    if (kvm_gmem_folio_no_direct_map(folio))
>            kvm_gmem_folio_restore_direct_map(folio)

It turns out we can't do that because folio->mapping is gone by the time 
filemap_free_folio() is called so we can't inspect the flags.  Are you 
ok with only having this check when zapping (but not when restoring)? 
Do you think we should add a comment saying it's conditional here?

> 
>>>
>>> Perhaps also add a check for kvm_arch_gmem_supports_no_direct_map() so
>>> this call can be completely removed by the compiler if it wasn't
>>> compiled in. IIUC whether the check is added in the caller or within
>>> kvm_gmem_folio_restore_direct_map() the call can still be elided.
>>
>> Same concern as the above about kvm_gmem_folio_zap_direct_map(), ie the
>> performance of the case where kvm_arch_gmem_supports_no_direct_map() exists.
>>
> 
> Please ignore this request!
> 
>>>
>>>>         kvm_arch_gmem_invalidate(pfn, pfn + (1ul << order));
>>>>    }
>>>>
>>>> @@ -596,6 +645,9 @@ static int __kvm_gmem_create(struct kvm *kvm, loff_t size, u64 flags)
>>>>         /* Unmovable mappings are supposed to be marked unevictable as well. */
>>>>         WARN_ON_ONCE(!mapping_unevictable(inode->i_mapping));
>>>>
>>>> +     if (flags & GUEST_MEMFD_FLAG_NO_DIRECT_MAP)
>>>> +             mapping_set_no_direct_map(inode->i_mapping);
>>>> +
>>>>         GMEM_I(inode)->flags = flags;
>>>>
>>>>         file = alloc_file_pseudo(inode, kvm_gmem_mnt, name, O_RDWR, &kvm_gmem_fops);
>>>> @@ -807,6 +859,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
>>>>         if (!is_prepared)
>>>>                 r = kvm_gmem_prepare_folio(kvm, slot, gfn, folio);
>>>>
>>>> +     kvm_gmem_folio_zap_direct_map(folio);
>>>> +
>>>
>>> Is there a reason why errors are not handled when faulting private memory?
>>
>> No, I can't see a reason.  Will add a check, thanks.
>>
>>>
>>>>         folio_unlock(folio);
>>>>
>>>>         if (!r)
>>>> --
>>>> 2.50.1


