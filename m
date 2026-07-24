Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22170C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 16:25:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EB6D6B008C; Fri, 24 Jul 2026 12:25:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09C6A6B0095; Fri, 24 Jul 2026 12:25:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECC926B0096; Fri, 24 Jul 2026 12:25:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C27B56B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 12:25:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5C3E61A0427
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:25:56 +0000 (UTC)
X-FDA: 85024196712.26.4850508
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id 51A6140010
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 16:25:54 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LSeaOheA;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784910354;
	b=SaFzh+Hw3tzNij0wzoFtAqTHWytEx149vaeU6K7YCR0uqyjmspDEEAOZJxyu7F0i+V2S9c
	21q5Tyv4ftrLYBiR3EZwshbdUIHZ4EtqpDfd054c8njM5sNSJf+DXiSW129kfnxNzL9+X+
	cJTHDdckr3ynh8FwF/kMOAWCef9rVvE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=LSeaOheA;
	spf=pass (imf01.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784910354;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZObIlia0bF/5KoAO7QHOC3KkZX1rkeg1RIL22kW+K4Y=;
	b=qTU5TDMhOvsLZWEnEjknK9irFwuTrDfmexdZsMrBZa4FQGtUUKP1AVlCjQ9xHB2JMuu/0C
	ktcIaKPzd+Q3wPE+agDGBE+4T0GQc9ogfs+INComy2ucEEAS5yvrbbUfNIOKybhPl41ktp
	sRXYoLE2MeNpWiGHqXt9adtLBDKMk1Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 820DC1BB0;
	Fri, 24 Jul 2026 09:25:48 -0700 (PDT)
Received: from [10.57.0.90] (unknown [10.57.0.90])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8D9153F66F;
	Fri, 24 Jul 2026 09:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784910352; bh=90PjtwWiYZulmqV39H8fGSHBZ8shBRidW6H3XBOLz1E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LSeaOheALTDiD44xvkD55jNPMvVMiWCKhoAY3QOMhLgjHKQ4vGk/sCbVALnk8LQcs
	 UGzo+QT8sgIjgylea7jT8NDptv0jyxQHH1Yl0mF7+8llAZ/r++VL9OJQZ9z7INpPWZ
	 IvaE6ewh0IBZMWQRx7oS05rwa6Tfr8Ub24gxyRR8=
Message-ID: <13be2648-f68d-46ae-ae8a-5ca9e067cc90@arm.com>
Date: Fri, 24 Jul 2026 18:25:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 15/22] mm: only initialise pt_share_count for user
 pgtables
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Russell King <linux@armlinux.org.uk>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, linux-arm-kernel@lists.infradead.org,
 Huacai Chen <chenhuacai@kernel.org>, loongarch@lists.linux.dev,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, linux-parisc@vger.kernel.org,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, linux-riscv@lists.infradead.org,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>, linux-s390@vger.kernel.org,
 "David S. Miller" <davem@davemloft.net>,
 Andreas Larsson <andreas@gaisler.com>, sparclinux@vger.kernel.org,
 Richard Weinberger <richard@nod.at>,
 Anton Ivanov <anton.ivanov@cambridgegreys.com>,
 Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 "H. Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>, Ning Sun <ning.sun@intel.com>,
 x86@kernel.org, tboot-devel@lists.sourceforge.net,
 Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>, linux-efi@vger.kernel.org,
 Vishal Moola <vishal.moola@gmail.com>, Alistair Popple <apopple@nvidia.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <20260714-remove_pgtable_cdtor-v1-0-44be8a7685d7@arm.com>
 <20260714-remove_pgtable_cdtor-v1-15-44be8a7685d7@arm.com>
 <e95aabc0-522b-4660-958a-d648c1cfa78f@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <e95aabc0-522b-4660-958a-d648c1cfa78f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 95ei3h7o83e5i5txy8ppgspo57cxw5n7
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 51A6140010
X-Rspam-User: 
X-HE-Tag: 1784910354-405285
X-HE-Meta: U2FsdGVkX1+2D+Nxp8QYOHOTrDGeheD+xRgS9ib5l+zOBLncXEdZATOfLQenZA0vov5aTkfk0w/mM+gcJDQe7GBwzCwf8/nL3lJpBEEacEM4lcTLSjvkxrJK3EnBUmBzdTnxu8BLWvZeFSkNShMrpgmkSscrGclN0JD5M2l38m3WUQnv+PyBiZCpuTNcIbzkc6quIH/O1WIb384CgywtjGOvm6SclZ4T7iBngT3lb7wOPeyhuq6U+VSGjCseXFxg60JyAZYR7qh9JeScp1jJDp7lRmopxqZWfjv7ECD14/n+sgK/37QnwZO+i0YqxPd1dklqlL8pMWXx2JHM8ULvN/53j7IUuIjKllSqdLH9Sfwz1VpHD/D08vFh3LGzFSGnRwwKF5OVvGnKzrnNNKz4tQEKHM6zjdTen05X8xqLBP+7YXePl9zNEA6D6A8+g9Q09OtGrg+Hghhh4MAmhIlmU8Hm3Z+r8/X68///cGZEcvZNYTKi6QiQP28GzhvA4ldhr63AkOVxCivHa0y0r/cAJMbHGqXSuqRt/6vCyqMciISrXYHaU5y/xjbo+QNQoiz2Q8dU9WRybxb7u0QL3MVVEj1gt8pq6JjqUFEIPAiaj3tXSZPjA3AVCEovNUnSIwVWHcAD44DkcOVEDvQvEUSw3u7gFqp6iO+ccnJx0IqyMmh0JGmTZrWl67QcfkpLkHL/9PdZfbAv52qotAiSBvhzjGS2zY2vKz2a7zmn54jgcVLlUq2KW3B80gqKosLcfgR5SQtFqI+73mWE9Av+/8h+Fv6y/srDcAGNrbm4HL7YaKiDPpQY+3a8pNTqWjFTwmt7fGLK1/lkEFLPdg3O5X3FzGIpUpd01V7Nr7mSbALcsIcRiDgNqZeU7nnaFnS95vRfsGb8stLQXdIv0mGm84JzcOyIpd39kiE2nD+PsViMSx9m7hTQSGqAbXZUNgL4f+kCIvXZRO5/KLUDiWMSZFj
 gdHK7jYl
 4o0DNurLR7HEfDyz4jCcZP8DTqWmeMZcDtVFoXPT0mlh14EN30F2uZ8FF3+PQzuPNUosshaYkSSzY9oGk65Vk3w7oS0lVPr1pJ9D+19CbWY4UddqdBo+r717Z/jvkkDG0eoSM+M90ZVV0OHGm8z7R0cYg0o28+MOxjVWMg8vNm4f3s8HGkwBAau5HUaFQyx03J0xPt3GIYb+/Hm8gBtierIipX3X1l5Z/YP+/DKgYg8WNoMJBi+u9wASlQWMOUbvXbRNlzuHm+ns6UhjAP9653MZbtkJKr8RBysrRCIgPt2VTvCeCIKbkws6ceY86dWw0egLWaQHISSiRRi7u2GsbL74/UwZfKCZIsr2xOC4AhjhJeeeoFYZmxQYMMemjMx/ydDXQZcG4p3Df/7Za5ewW5N5qDtDsO7eHNzak6DTfMSnItsIjtGZpgW5Zbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 21/07/2026 17:12, David Hildenbrand (Arm) wrote:
> On 7/14/26 16:04, Kevin Brodsky wrote:
>> ptdesc_pmd_pts_init() initialises the pt_share_count ptdesc field.
>> That field is only used for hugetlb tracking purposes, so there is
>> no need to initialise it for kernel page tables. Skip the call for
>> kernel page tables, like pmd_ptlock_init().
>>
>> From now on pagetable_*_ctor() and pagetable_dtor() do nothing for
>> kernel page tables.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>  include/linux/mm.h | 9 ++++++---
>>  1 file changed, 6 insertions(+), 3 deletions(-)
>>
>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>> index 94f0fb1c662a..b217ccbed5a3 100644
>> --- a/include/linux/mm.h
>> +++ b/include/linux/mm.h
>> @@ -3905,9 +3905,12 @@ static inline spinlock_t *pmd_lock(struct mm_struct *mm, pmd_t *pmd)
>>  static inline bool pagetable_pmd_ctor(struct mm_struct *mm,
>>  				      struct ptdesc *ptdesc)
>>  {
>> -	if (!mm_is_kernel(mm) && !pmd_ptlock_init(ptdesc))
>> -		return false;
>> -	ptdesc_pmd_pts_init(ptdesc);
>> +	if (!mm_is_kernel(mm)) {
>> +		if (!pmd_ptlock_init(ptdesc))
>> +			return false;
>> +		ptdesc_pmd_pts_init(ptdesc);
>> +	}
>> +
> I'd have said "the initialization is cheap, why bother", but we already do have
> the mm_is_kernel() check in place, so

This isn't mainly about the overhead, but rather the fact that from here
on the ctor/dtor do nothing for kernel page tables. Patch 20-22 rely on
this, and in part 2 I would go further and only ever call the ctor/dtor
for user page tables, so that the mm_is_kernel() check can be dropped.

> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Thanks for the reviews!

- Kevin

