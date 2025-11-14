Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 964E2CEACC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 19:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24238E0021; Fri, 14 Nov 2025 14:39:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EADEB8E000C; Fri, 14 Nov 2025 14:39:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D75A38E0021; Fri, 14 Nov 2025 14:39:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFA948E000C
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 14:39:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6B1EE13B21F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:39:39 +0000 (UTC)
X-FDA: 84110227278.20.9E51B88
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 9ADC71A0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 19:39:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnop2DB+;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763149177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EB6NPeH9aiRCowjoSqWRgo4v8VZsNGNFCmmOKf/qxBE=;
	b=Bcz4w70Yr3L6xM2N3uxJULD4SdO4T3pEX9b4MMxsI5TQaHT+9WqW5x0Li9UZHw2YEsTeFk
	wi9b1Zyirjwjif3cXjADPcOql228H5uKvXSKLzqkJR2kl5aheB0GbyO0R4VGk4AatmDoyD
	3t7yt0CgF/XIvhcIz/47s79EDL+t7/Y=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qnop2DB+;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763149177; a=rsa-sha256;
	cv=none;
	b=MYsZrmvZLmdcujF88Q0oK1eEnWYMO/ynVzz6o6b+Wfr7UBvERh1rPCJEurLa9m/490q8Km
	jVV6q4z3volUL4FLuOSXuBnqAEfimdjpRLGnBcNcjyMsFXPolCawOKbivKlbPMG+yf876g
	Ag1lUVeCFkfKFkvyL4LtGvOY1CjzbNQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A5BB543766;
	Fri, 14 Nov 2025 19:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B93DDC4CEF8;
	Fri, 14 Nov 2025 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763149176;
	bh=54NLBk7Njpf4E6a9gJR3/zpHbL++ajPh9Y+MWKanMgI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=qnop2DB+z9ZecMETjC2TQD0j7snZXxCyh9BZtRFSL3Vj+nGofDn3vpkjact5FtBlS
	 nHu9Kk8kG5n7Xk740/Z6a0MT1Ju02Z6jQPFIdTIgnZuA7jnpVEXGekwlXEmaEUs7yJ
	 HttHQlQiYtE5ibkAM+78/ptWHgo/VqxpcMgUYqWmeccfxPZWasi2d0MvAv8XU4SYo8
	 UO+mdnxiuQqf4RQhYfW3WJRElizt9RJFz4Fjl+jvaQwksBSUUrh+LKYBGDzUcsVTwB
	 wNTwl58i9PAbsmRr8k7vsZoBaYcKaLkrXI3KWBoE15mCCFi+MJX+YDTXxgfelpASmb
	 NzsyfILQ3/cfw==
Message-ID: <e1345a3f-b5c5-49fd-a1e2-a77926cb9256@kernel.org>
Date: Fri, 14 Nov 2025 20:39:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [akpm-mm:mm-unstable 36/283] mm/hugetlb.c:4753:18: warning:
 implicit conversion from 'unsigned long long' to 'unsigned long' changes
 value from 17179869184 to 0
To: Nathan Chancellor <nathan@kernel.org>,
 Matthew Wilcox <willy@infradead.org>
Cc: kernel test robot <lkp@intel.com>, llvm@lists.linux.dev,
 oe-kbuild-all@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Linux Memory Management List <linux-mm@kvack.org>,
 linuxppc-dev@lists.ozlabs.org, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>
References: <202511141140.LrrRrtIv-lkp@intel.com>
 <20251114182956.GD2566209@ax162> <aRd69_c1pULRoKOU@casper.infradead.org>
 <20251114191817.GA1089438@ax162>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251114191817.GA1089438@ax162>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9ADC71A0005
X-Stat-Signature: pj14ka3gdjkn8r94sbst4cey4wx6mhqj
X-Rspam-User: 
X-HE-Tag: 1763149177-377000
X-HE-Meta: U2FsdGVkX19UcDS4gzoCmAVhha3kGrhJxM450WK/0K8Or/akcQOctGpKRZNZn6HgxFLdrP7RYfuKNlR83fBUo3C+ugdq9R0GyllqbSQAG3/Fa+/1ioArmOgib6WugZt1u3YhY0acZhetmRW2O3EZfQIn8J7Bn7hQn/xbo1uOveLb1ihNHGNpzMexOaWqIcMyo2pibcu+K3HS4hrm9pJ9OspdHEiLUnZnYldP5QyCYbT4clrY0wp91YUoHU4QxMyeaLqq7QIwJlJWpRKJHkD8RhKQ2qLIZUg2BF6NXnjRfHSUm17f5Sf3e22su05r+s41LF5AN/nIQGfCQ89M/U6vfNJzTJjfMffh0ZX6XPNrgQhKPHyXxSntX3QKHFlGHGGCfwpeqtoDmTM6XR9GxjMGOxl09/QQLnhmHUH3noz23bR6ex68xI+QTud6Y8ivZVjL3WAg0I6F1iLwsJbeLn/dFYG9NlQQtRsxaW4+LFWy7c21ml23cmDhVq4jMNgb35PaDEl4hqSWrDw1mEWR7wvZ8/9yXnuAfiTs1rKNfOcxo5SpGfazh25Bve5/ksAm0YJoG9MPPGqQPDwYl2KHjsa7BMkmVXsZNUI9a7og1ApnF9E5P6vpnOSKcpOHm6DHRVXmvzjHgRarcLBG4D7s5lnZjCFqGrEt1OOOGj52jT3Pj2dvpJsb5xmgBznd6uQ8IZOAfThdYejQLYjcLXp9Eg0gNFjhvZotQztgYkaZFFwH4S5XvmiJACXtRPS403yw2YDcOapWtcmb+jepCUiWNqSJar2ACjhBFTJEo2Bt3awXEysZbeF6HHn9E8F8xdRe7IPaYmyp5aARniTvwq9ikpGGSI8Rrs6GFMIx+LadgnXvryPxrf9C0xQRWKGGa5JGILwCymo4MjkP4gGEV4sAccRecNmEOtKHW2op5fGY9j7mtes2RaLHP5pVg202m9PSY7swFNQh5I25UwbjtPHcntd
 C+IsCzwn
 GyzHCBFikEdnQnLvDqSkm3lP+cR0TbmpAncgixX1fGLM+/Hj3ik/SULSc6lL9MkkAEifrQilvPAW3ylNHEkNLlnyh8FqXPoornfg7vVkeWY3+IhBwHJi241tuhrzOqIPJDq9xRH/e+wmWsOfC8rjjwnJtxAqjXP+ApTd2LBp0gUwHHc5+lFdLWn7Dfd3Hp9mQiASiT4zQLlB1zVuItf0U4t7Ry4i2ehDLQh9yrdKll3dQWNLwEQ7Z1CGHJFbPamsGzNmStfz1SGaklJhauXCSQ6ds1AYyRBYmxQmt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14.11.25 20:18, Nathan Chancellor wrote:
> On Fri, Nov 14, 2025 at 06:54:47PM +0000, Matthew Wilcox wrote:
>> On Fri, Nov 14, 2025 at 11:29:56AM -0700, Nathan Chancellor wrote:
>>>>>> mm/util.c:1263:16: warning: implicit conversion from 'unsigned long long' to 'unsigned long' changes value from 17179869184 to 0 [-Wconstant-conversion]
>>>>      1263 |         if (ps->idx < MAX_FOLIO_NR_PAGES) {
>>>>           |                       ^~~~~~~~~~~~~~~~~~
>>>>     include/linux/mm.h:2104:36: note: expanded from macro 'MAX_FOLIO_NR_PAGES'
>>>>      2104 | #define MAX_FOLIO_NR_PAGES      (1UL << MAX_FOLIO_ORDER)
>>>>           |                                         ^~~~~~~~~~~~~~~
>>>>     include/linux/mm.h:2095:36: note: expanded from macro 'MAX_FOLIO_ORDER'
>>>>      2095 | #define MAX_FOLIO_ORDER         get_order(SZ_16G)
>>>>           |                                 ~~~~~~~~~ ^~~~~~
>>>>     include/linux/sizes.h:56:19: note: expanded from macro 'SZ_16G'
>>>>        56 | #define SZ_16G                          _AC(0x400000000, ULL)
>>>>           |                                         ^~~~~~~~~~~~~~~~~~~~~
>>
>> Clearly this is a 32-bit build, since otherwise a conversion from
>> "unsigned long long" to "unsigned long" is a NOP.  But 32-bit cannot
>> support 16GB folios!
>>
>> I say this is a bug in powerpc32's config.
>>
>> #if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
>> #define MAX_FOLIO_ORDER         MAX_PAGE_ORDER
>> ...
>> #else
>> #define MAX_FOLIO_ORDER         PUD_ORDER
>>
>> (PUD_ORDER is 16GB, so I think this will be what's being picked up)
>>
>> but the only place the mentions ARCH_HAS_GIGANTIC_PAGE is pretty
>> clearly dependent on 64bit ...
>>
>> config PPC_RADIX_MMU
>>          bool "Radix MMU Support"
>>          depends on PPC_BOOK3S_64
>>          select ARCH_HAS_GIGANTIC_PAGE
>>
>> so I'm a bit stuck about how this comes to be.  Adding the PPC people
>> for thoughts.
> 
> Note that the original report is against mm-unstable and flags
> 
>    https://git.kernel.org/akpm/mm/c/c3f81a41ba6f93693d208edde08ce2b0da21c645
>    https://lore.kernel.org/20251112145632.508687-1-david@kernel.org/
> 
> in mm-hotfixes-unstable as the problematic change. This configuration ends up
> with
> 
>    $ rg -N 'HAVE_GIGANTIC|HUGETLB|PPC_8xx' .config
>    # CONFIG_CGROUP_HUGETLB is not set
>    CONFIG_PPC_8xx=y
>    CONFIG_HAVE_GIGANTIC_FOLIOS=y
>    CONFIG_ARCH_SUPPORTS_HUGETLBFS=y
>    CONFIG_HUGETLBFS=y
>    CONFIG_HUGETLB_PAGE=y
> 
>    config PPC_8xx
>        bool "Freescale 8xx"
>        select ARCH_SUPPORTS_HUGETLBFS
>        select FSL_SOC
>        select PPC_KUEP
>        select HAVE_ARCH_VMAP_STACK
>        select HUGETLBFS
> 
> which may indicate a bug in either selecting ARCH_HAS_GIGANTIC_PAGE in
> this case or the logic of HAVE_GIGANTIC_FOLIOS in that change?

God how I HATE that hugetlb crap at this point. So much wasted time.

Likely, for 32bit builds we should cap it at 1 GiB, which I think is the 
32bit maximum hugetlb folios size on ppc actually is.

-- 
Cheers

David

