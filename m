Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 191CED46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 20:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7FB846B0005; Thu, 15 Jan 2026 15:06:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C6476B008A; Thu, 15 Jan 2026 15:06:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67D296B008C; Thu, 15 Jan 2026 15:06:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 594016B0005
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 15:06:04 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1314B13B0BF
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:06:04 +0000 (UTC)
X-FDA: 84335279448.11.444AD26
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 450601C0011
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 20:06:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9u0J1eI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768507561; a=rsa-sha256;
	cv=none;
	b=7XyG2QE3BA0riKPTg6cbiPGsC8Au5E8VqlX3KRouEDo+fqt2yDv3c0UNLAxxMh66Q8vjzW
	cFLFqs5siU533zqg3RkEI5mQV4kiddMSoTPtkEw/mr81P9EgBO+5k+gyhZ1NtwtsKJ5sNA
	FnIpf+xw8j1txEihCjvcPyTl/wzhXZI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O9u0J1eI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768507561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QR2Dgkytc5b38WGCVddUEiIlmC4atoWY0t2oKu1M+lk=;
	b=UkPHSjXgt551Gwnx6pqArm/7sDShMKd+MglEsT5NZf7FRgLFEuAy4XbAP3DGCZzJUS708I
	5bJKUIJ80heZOhl75a2fVTfMUC0a0Y9BDYkJ95uPTsZy1qy2fII/rh1m+ntnE0RiFrUvXT
	VvWcxggCIHO24xYieE4cAXHV5ezIgPg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4D2A160167;
	Thu, 15 Jan 2026 20:06:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 916F3C16AAE;
	Thu, 15 Jan 2026 20:05:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768507560;
	bh=/Lm/cQ9KIdEqaaWKki03cmuum9MrucbonYVIjYH818M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=O9u0J1eIRihxKr5zUB4ypIjP14vCCSOt21wOcHu1CjjTUe4M2/FwpBFEeZFhTeiiN
	 JpaYWCpuQfRoQvHUmsJSQ/x4Gem9BP4aeYu0ESw4FG+nbCfU2XB1eb42KSzHf0CChu
	 /w/MGvvPPKIB1faCQ/snYVf2ogs3ndSI1dQgZpekp6GnmHaXSVwAD8G7R6tlxlWqWr
	 8QpKSe0qBPrxHhF3H5cwPuTQVeobV4EG/CoX7uWK8O31hJINQw1IlbbCxfZ4SKLqWE
	 s6odfsHBjSloFK+AYdCE8jAWn9P5kaxB/0XRHh6xgj1z3nFOrjdQx6FsL25eGM5OIK
	 2KevP7wjRCs+w==
Message-ID: <2219ec0f-edc4-4267-b251-ee060fd951e2@kernel.org>
Date: Thu, 15 Jan 2026 21:05:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/13] set_memory: add folio_{zap, restore}_direct_map
 helpers
To: kalyazin@amazon.com, Matthew Wilcox <willy@infradead.org>,
 "Kalyazin, Nikita" <kalyazin@amazon.co.uk>
Cc: "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>,
 "kvmarm@lists.linux.dev" <kvmarm@lists.linux.dev>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
 "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
 "kernel@xen0n.name" <kernel@xen0n.name>,
 "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
 "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
 "loongarch@lists.linux.dev" <loongarch@lists.linux.dev>,
 "pbonzini@redhat.com" <pbonzini@redhat.com>, "corbet@lwn.net"
 <corbet@lwn.net>, "maz@kernel.org" <maz@kernel.org>,
 "oupton@kernel.org" <oupton@kernel.org>,
 "joey.gouly@arm.com" <joey.gouly@arm.com>,
 "suzuki.poulose@arm.com" <suzuki.poulose@arm.com>,
 "yuzenghui@huawei.com" <yuzenghui@huawei.com>,
 "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
 "will@kernel.org" <will@kernel.org>, "seanjc@google.com"
 <seanjc@google.com>, "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>, "bp@alien8.de" <bp@alien8.de>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "luto@kernel.org" <luto@kernel.org>,
 "peterz@infradead.org" <peterz@infradead.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "lorenzo.stoakes@oracle.com" <lorenzo.stoakes@oracle.com>,
 "Liam.Howlett@oracle.com" <Liam.Howlett@oracle.com>,
 "vbabka@suse.cz" <vbabka@suse.cz>, "rppt@kernel.org" <rppt@kernel.org>,
 "surenb@google.com" <surenb@google.com>, "mhocko@suse.com"
 <mhocko@suse.com>, "ast@kernel.org" <ast@kernel.org>,
 "daniel@iogearbox.net" <daniel@iogearbox.net>,
 "andrii@kernel.org" <andrii@kernel.org>,
 "martin.lau@linux.dev" <martin.lau@linux.dev>,
 "eddyz87@gmail.com" <eddyz87@gmail.com>, "song@kernel.org"
 <song@kernel.org>, "yonghong.song@linux.dev" <yonghong.song@linux.dev>,
 "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
 "kpsingh@kernel.org" <kpsingh@kernel.org>, "sdf@fomichev.me"
 <sdf@fomichev.me>, "haoluo@google.com" <haoluo@google.com>,
 "jolsa@kernel.org" <jolsa@kernel.org>, "jgg@ziepe.ca" <jgg@ziepe.ca>,
 "jhubbard@nvidia.com" <jhubbard@nvidia.com>,
 "peterx@redhat.com" <peterx@redhat.com>, "jannh@google.com"
 <jannh@google.com>, "pfalcato@suse.de" <pfalcato@suse.de>,
 "shuah@kernel.org" <shuah@kernel.org>, "riel@surriel.com"
 <riel@surriel.com>, "ryan.roberts@arm.com" <ryan.roberts@arm.com>,
 "jgross@suse.com" <jgross@suse.com>,
 "yu-cheng.yu@intel.com" <yu-cheng.yu@intel.com>,
 "kas@kernel.org" <kas@kernel.org>, "coxu@redhat.com" <coxu@redhat.com>,
 "kevin.brodsky@arm.com" <kevin.brodsky@arm.com>,
 "ackerleytng@google.com" <ackerleytng@google.com>,
 "maobibo@loongson.cn" <maobibo@loongson.cn>,
 "prsampat@amd.com" <prsampat@amd.com>,
 "mlevitsk@redhat.com" <mlevitsk@redhat.com>,
 "jmattson@google.com" <jmattson@google.com>,
 "jthoughton@google.com" <jthoughton@google.com>,
 "agordeev@linux.ibm.com" <agordeev@linux.ibm.com>,
 "alex@ghiti.fr" <alex@ghiti.fr>,
 "aou@eecs.berkeley.edu" <aou@eecs.berkeley.edu>,
 "borntraeger@linux.ibm.com" <borntraeger@linux.ibm.com>,
 "chenhuacai@kernel.org" <chenhuacai@kernel.org>,
 "dev.jain@arm.com" <dev.jain@arm.com>, "gor@linux.ibm.com"
 <gor@linux.ibm.com>, "hca@linux.ibm.com" <hca@linux.ibm.com>,
 "Jonathan.Cameron@huawei.com" <Jonathan.Cameron@huawei.com>,
 "palmer@dabbelt.com" <palmer@dabbelt.com>, "pjw@kernel.org"
 <pjw@kernel.org>,
 "shijie@os.amperecomputing.com" <shijie@os.amperecomputing.com>,
 "svens@linux.ibm.com" <svens@linux.ibm.com>,
 "thuth@redhat.com" <thuth@redhat.com>, "wyihan@google.com"
 <wyihan@google.com>,
 "yang@os.amperecomputing.com" <yang@os.amperecomputing.com>,
 "vannapurve@google.com" <vannapurve@google.com>,
 "jackmanb@google.com" <jackmanb@google.com>,
 "aneesh.kumar@kernel.org" <aneesh.kumar@kernel.org>,
 "patrick.roy@linux.dev" <patrick.roy@linux.dev>,
 "Thomson, Jack" <jackabt@amazon.co.uk>,
 "Itazuri, Takahiro" <itazur@amazon.co.uk>,
 "Manwaring, Derek" <derekmn@amazon.com>, "Cali, Marco"
 <xmarcalx@amazon.co.uk>
References: <20260114134510.1835-1-kalyazin@amazon.com>
 <20260114134510.1835-2-kalyazin@amazon.com>
 <aWkN4yzwPtotaTeq@casper.infradead.org>
 <34b246e9-0f7a-4ed6-9e43-845c4238bf41@amazon.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <34b246e9-0f7a-4ed6-9e43-845c4238bf41@amazon.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 450601C0011
X-Rspamd-Server: rspam06
X-Stat-Signature: fn937oy6y9o6cao8zfef5qfrjbccdgmg
X-Rspam-User: 
X-HE-Tag: 1768507561-77066
X-HE-Meta: U2FsdGVkX1/IXE0mb+M1P6//k+DJ9GnOSa/H/gFuZQiM+mY9pbeaEnPBQXG4d6on2NoCHA2iF5dnnaw5DigntJ27btsG1aRwlfNvz128ynU4kJK4SdCRj+GVs8Yn6/8DzD7KBksIK2pgWbqn51n4Npgvl0Hbw3Kf3Dp5S1nEtKyTTy0pCnNb+fSC78qPi9mRt3qsNyS/DYS01dtggFkD+aZNXufgHz6J38FLyNbJ70Z7tl+ZJk4xIMZQXvgrK5l6f+cU653lGQ8GpR2kKjWJx3q1iFkIm89qkuUEkdtP1M8InfpAI4z3OLfEdHAUmQs8ckfqsexIau4XsB6u1K9tyvsJnNpHUOdI3qJxw45S5i5Sbt+s2hLcrBgm8rLIdNXFjuE8wKMNMXeMmx2AMohkNmuwWezsESPjW0vCWr+wjRfA3NuSJ4BxiS8NS5lqiQDdQCeYS4TJBqW2y+izo0KuuI81jADcu2V5/7BWaDZpuAc3mXfgX6JcOiq/kMJTBIpjjVXFvFlnU8Yutm2I3HUhIuqppedszNURGakB1zgAsshFYnI2L5uQxZvsLtIoGFML+wweIDymVlez6mXwxegxds0ckn9xSLlWV/hamayxr0MB0qZ+3peQ8Vkzab2U9vI5vXORbJALp793qryIFXxykSim2PetemnH6DfWBcyKcjQbEG4wXMvhLXkmVHpeaEaOpFsVWU/Y2ezeYvW2B9KR2U2JKYey5qhZKJX0Rmfsso6n9128zaiHduathVPmNgXyKI5lKNVK5FTVdEkV0D/f5vCbOYAHlOoZ/iZ0NGey4b3yARSsvSn/N8xMjxIOFXkZjs5YkMrdkhNkOMUk38pfpJGk2OSMkYx+JNVriBdXEbLyoaw5g67nXR11BDGTrRdQRsnKaebUFIa03/WJKk2NCKtyMQflZQ+RQLo+i223NzacY5oZEZHQL4gzgi7xXwqAX2ueqOtreOiCeYEY8l3
 t93oWn0P
 JXJKlsR91b4IoQjrjJhKmMaYaOY/BN8ddmdaJlzRH/EJI3hje8Ren49iIGZ7dLQM2HaNF3P1IPSCz5BwEJ05Na5WWFq4mHrduosafyzoNn0Ndsb0vJ3ANpOuMVYe2qwZTzyfRGd8qYfn8qyEBhGbDQjBViVSCbWvFyv2tDXUFLwDP00dEv75UVUxiyGwPRnEq4YNNvfsMxhzyTvk5otYWb7bswSvjgga1rVW9or3C7ecRKdlILJHa7zLX4cPTz+JAAsVHfcmqW3RVIEo9Gmo5AzuEC62Y5VIpd4L6eJ+Ui5tVbTaUqPTzHlBDNV1bXYnnWyKlOJ9KQ/OV2VsATkLuOzrQS599/8NwLkgCwpb97iktNbaf1UvBvkFppcTyHZSX089/tpKCzvboOAjAYw8Ld6VG4M4fIEL/rgfv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/15/26 18:45, Nikita Kalyazin wrote:
> 
> 
> On 15/01/2026 15:55, Matthew Wilcox wrote:
>> On Wed, Jan 14, 2026 at 01:45:23PM +0000, Kalyazin, Nikita wrote:
>>> +int folio_zap_direct_map(struct folio *folio)
>>> +{
>>> +     return set_direct_map_valid_noflush(folio_page(folio, 0),
>>> +                                         folio_nr_pages(folio), false);
>>> +}
>>
>> The implementation isn't the greatest.  None of the implementations
>> of set_direct_map_valid_noflush() actually do anything with the struct
>> page; they all call page_address() or page_to_virt() (fundamentally the
>> same thing).  So converting folio->page->address is a bit inefficient.
>>
>> It feels like we should change set_direct_map_valid_noflush() to take a
>> const void * and pass either page_address() or folio_address(), depending
>> whether the caller has a page or a folio.  What do you think?
> 
> I have nothing against that.  execmem_set_direct_map_valid() appears to
> be the only other user of set_direct_map_valid_noflush() so it isn't
> going to be a broad change.

Makes perfect sense to me :)

-- 
Cheers

David

