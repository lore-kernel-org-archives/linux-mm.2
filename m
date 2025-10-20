Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCC93CCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 10:37:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF358E0017; Mon, 20 Oct 2025 06:37:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AFA68E0002; Mon, 20 Oct 2025 06:37:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED228E0017; Mon, 20 Oct 2025 06:37:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3758E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 06:37:53 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D0BF71607D1
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:37:52 +0000 (UTC)
X-FDA: 84018141984.04.E020F15
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5ED1B180007
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:37:51 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760956671; a=rsa-sha256;
	cv=none;
	b=arD0Wd5Rc5uAEi9BcsgQ9tpHdyg1H4fkar4RHkXIqjjcLRZKi34JjWJAiG9gCbY0hSYmIp
	oJa+ueqf/7pzrcHgRY2UQikMdsDdddSSAA+eZqLsScoAa6vHsane44vlaGiUXp6qHBID47
	Unzw/j8iHvXeCNBfrYkR0ouaMJ7jJgU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760956671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pyqZHguj4pWVxVzjCwOW7QzekGnxMtJdbRxBmWKZji0=;
	b=SNug8UVqCtrg9QIrFX7PkbK1Vzhmfkce27PMayKMNsvriO6QZr/5BXQrilgX5FXev2FZqg
	WtvdS5oQKA0bF0l7jUPWYbg3XYx1QSWe7WGTmVxhOtaqTOSwb/kqG1mA+pFHkQ0L0XpDK7
	+z+YCuznOhJRxEU5+1C/0ASof7PsWUY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6116D1063;
	Mon, 20 Oct 2025 03:37:42 -0700 (PDT)
Received: from [10.57.65.147] (unknown [10.57.65.147])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id DB2C53F63F;
	Mon, 20 Oct 2025 03:37:41 -0700 (PDT)
Message-ID: <3836a43f-809e-419d-a85d-74606d9daa0f@arm.com>
Date: Mon, 20 Oct 2025 12:37:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 05/13] mm: introduce CONFIG_ARCH_LAZY_MMU
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 David Hildenbrand <david@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Suren Baghdasaryan <surenb@google.com>,
 Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251015082727.2395128-1-kevin.brodsky@arm.com>
 <20251015082727.2395128-6-kevin.brodsky@arm.com>
 <aPNjd2dg3YN-TZKH@kernel.org>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <aPNjd2dg3YN-TZKH@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: xgebx7aoq3a4iozdbwa9jwkd3og8o9sz
X-Rspamd-Queue-Id: 5ED1B180007
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760956671-12531
X-HE-Meta: U2FsdGVkX18rZB5xA/h0VZARlINlIhsHbJXFcsk4zX926aFNFc/GOxhX75j1fptITu9XqtRWE4vUH9SUTrReJvcbBGYMdOjOTY0efLNt3YzrTjw9rSOWQtoksWYjL9xpV4gltPzuXfsiASqrG+nXfIbNrwurV9+9iWyjoYyKXqgXfPx1hgyVnve9Ro3xwe4OorEoyGmOdq0XF4LUTsw3tiWea/seMhOjzbto9/yQvVdlGncVEJWdmTlYqCb1vq3Y/3fGa2xldZ6kROgu2Oimyclhl8Zdhmz6yue/S2c3Lop27Bac3gNqQAJ0UlAooAOmuPHvmprZHSCfIaucrLCnnoy8NIA9vjCH85fe4GLH6/OuT7PJxwian+NibEk+BWWg3g+1pI/64sUu4KTa5dmLbx6aazJSEBmKAmmdXAcCEwXZJNHlkLcuOIjcN4vPV/LkTn83bLAR2DbkrMlS/Xgr+23t99QVXmdNWtkJ19rsKgPH82NTniTXEPLPzhHoYHffE/24SwahriM5gS9SEgVPTxH3X9Y2au6GX9Vem+IyegWhu2tpBmsBRVEy3OvY1CnToRapl16P6gajV2N7ELRP960PjMArjDIP5qFs08ogXTvq3MohYnehZ6Ak9qSv6v2KdVtxOGKnGz2oDDer5GN34NEJt3vc5+HzQ0XEDgbHDCB0s9NVObZc9U7R7nLbtxPkYW7JQGQ10hvwEbi3e7h7Vfu6PyONW4cVbMEI0H/eHjp+I3LOeqwh7INnuAs8dZTmy5bq8Ks/PUVr1JbYzUVd/D6zg02teDK8S2nsf8NS8q5TrEA2Mxfz0DsKTeU8fDLF105ZLOh5rg+ZeFMp2ECEOOukp9cqhtQeC8oeBR9s18iOM/wl6TU9qYPzDGcH/RFEWqhJI4YDGrBNafQo1ai4ekO/zye6bpkTKLBbpmQjWKo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/10/2025 11:52, Mike Rapoport wrote:
>> @@ -231,7 +231,7 @@ static inline int pmd_dirty(pmd_t pmd)
>>   * held, but for kernel PTE updates, no lock is held). Nesting is not permitted
>>   * and the mode cannot be used in interrupt context.
>>   */
>> -#ifndef __HAVE_ARCH_ENTER_LAZY_MMU_MODE
>> +#ifndef CONFIG_ARCH_LAZY_MMU
>>  static inline void arch_enter_lazy_mmu_mode(void) {}
>>  static inline void arch_leave_lazy_mmu_mode(void) {}
>>  static inline void arch_flush_lazy_mmu_mode(void) {}
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index 0e26f4fc8717..2fdcb42ca1a1 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1372,6 +1372,9 @@ config PT_RECLAIM
>>  config FIND_NORMAL_PAGE
>>  	def_bool n
>>  
>> +config ARCH_LAZY_MMU
>> +	bool
>> +
> I think a better name would be ARCH_HAS_LAZY_MMU and the config option fits
> better to arch/Kconfig.

Sounds fine by me - I'm inclined to make it slightly longer still,
ARCH_HAS_LAZY_MMU_MODE, to avoid making "LAZY_MMU" sound like some HW
feature.

- Kevin

