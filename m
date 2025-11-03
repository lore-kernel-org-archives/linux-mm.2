Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E288CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 18:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C93F38E00BB; Mon,  3 Nov 2025 13:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C44398E00B8; Mon,  3 Nov 2025 13:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81A88E00BB; Mon,  3 Nov 2025 13:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A7C628E00B8
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 13:06:38 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6FA58140294
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:06:38 +0000 (UTC)
X-FDA: 84070076076.05.C8ED05F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1B13A100016
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 18:06:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762193196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eU7WK/1PqFlvzgHgAfgHxGbQJbuUHY5MaiGqpoJ3158=;
	b=NUiMHkd4vmz4SCQCChnAcQPJcYXyoggtS5WhnyXQmUzx5RT4m07yL4bDUDmsZ1Yrpr2aMc
	jjUQW3NHh/Lnr/tc3oF/T28A+c8gHjGfIwLMjlBD+Rr2wkMrfX9wJvACfoMurSQK0NWwyW
	kB54dDZmBZNe1evVmvyiQL6Zf6Ns4PE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762193196; a=rsa-sha256;
	cv=none;
	b=rlsb0MCSmTk5fg80WRCgwo1WIk7SdFH6AaeGbCEVjsGmWT4jF/4s/OXHC51Y6IzcZYjUpK
	N55Mc3668+TUjzSyAZQfuexVVSQTCJiDrZVBL78rgC1AgbTBIkG2lvfzJQXoI2C7MGLd0z
	sxzcuA4TozxJthiJJsHJI2VJeykf+lI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 183932A6B;
	Mon,  3 Nov 2025 10:06:27 -0800 (PST)
Received: from [10.1.30.16] (unknown [10.1.30.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 67BAA3F694;
	Mon,  3 Nov 2025 10:06:27 -0800 (PST)
Message-ID: <bcc78ea0-5eca-49e5-bafd-84a16e06ab98@arm.com>
Date: Mon, 3 Nov 2025 18:06:24 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] x86/xen: simplify flush_lazy_mmu()
To: David Hildenbrand <david@redhat.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Alexander Gordeev <agordeev@linux.ibm.com>,
 Andreas Larsson <andreas@gaisler.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Boris Ostrovsky <boris.ostrovsky@oracle.com>, Borislav Petkov
 <bp@alien8.de>, Catalin Marinas <catalin.marinas@arm.com>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 "David S. Miller" <davem@davemloft.net>,
 David Woodhouse <dwmw2@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
 Ingo Molnar <mingo@redhat.com>, Jann Horn <jannh@google.com>,
 Juergen Gross <jgross@suse.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Nicholas Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Suren Baghdasaryan <surenb@google.com>, Thomas Gleixner
 <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>,
 Will Deacon <will@kernel.org>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
 sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, x86@kernel.org
References: <20251029100909.3381140-1-kevin.brodsky@arm.com>
 <20251029100909.3381140-3-kevin.brodsky@arm.com>
 <5a3ccb7e-9d36-4ac8-9634-c8dec3d6a47c@redhat.com>
Content-Language: en-GB
From: Kevin Brodsky <kevin.brodsky@arm.com>
In-Reply-To: <5a3ccb7e-9d36-4ac8-9634-c8dec3d6a47c@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uwdrbayq8q3cqjywyy4x176b8qhpxjhf
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B13A100016
X-Rspamd-Server: rspam10
X-HE-Tag: 1762193195-964827
X-HE-Meta: U2FsdGVkX1+YxJ7za5wujQf9g4hmazwwbEV8SWGKVnK9lES0ZnyAx0O/ftVarYSUL19+LS6xJbh0tJd/Y54hEPtnPKxOPPAhvSjVzLlung9KoXLqzUqPmzYUFMUYBiAKDDl0j2XctHri3I14fTS5UmsXj2r05Wc1+wSTlPyUbDMQ5BlhaDkgpwMZyLNXECbOMYRy9WbN1adOK479fpOut5lO3gkpKGZErskq4r/cJm0sbd1pQoeIoc9UaNh2etRSsBKBPLNTDxphSwH1SLsf+e5n95SjSWbm8BbZA89/TUoZ0l8qdQfwhmyDC/LW+HjRL0xgHSYp6IKwYQSoAcxdYIvTtOdrFJC6p8f3MtYyIpfuyvRrx+7sKcjrfPwLPAuvD/ThtjLikxNjU9SQieUctklASnKboLkkQq+WK73xVylOkjH4/3B4f6Y5x0Zkz0jV5U0TxxCKkRPn2Rx5msErK1QC/TiCzEW8yMAAnBWnnxV8N052UeW90Dhc9oAo0fSvsO+cKR/4BTrH8uD4YDrHla7vifrITiLa2v7lS4qWlBswx7YfPGO6+YwFM6Ize0A1Kj+hLoijqDB48M8rsS9ZsukEAJ6hz99N8kessFEQDNf3zVy1HCt1u7YKKWJvrSCn95dngyk6INuRkgl0vhT7snX+IzF6XgsxFjEpvu+HGnI+FwsjGb+CgGFDuMOWKwsaMU6npjFaPuVD+e1ZEj+ibHTT9xNl/4Vd41Kuhs9JwBtTqqf12R5jXIyaicJU4MsQH5WFktqWkcPT5Qx8jDsRlclr5vjjgQ4QjNZzsB8SaQiGq+YUkTtOZcNt6jDPCEA60vki6OLIlxbCTnVXtAi9E8M0qlv7zayEM/x0v6owHCnvtWPKdqNmE40raJ41zX65efUoZU/f0lsgAg3PzpMq0HA8iXiUD1GW64VQjvCkGCsXGwV72R8OkfDkyQbw0e2qnwUZBXilD3KMjVIc0xC
 pFk0SI2e
 2LXuc1zRdmPz7hwo4ExOLmWGBll/5/6IdRtbcXc5VP3PYaRdkCFncegCk1It5Nuo9jXMVWvWDxLOt7fwQlEWjv9InUEBHjat/WiIduBrrdOSx6M93+U2awVYM3gsW2qFnU2UpBtsXRXQohkvTxxwfs6w5h5LlSJ+7o+g0J4Qda8vZ0DXTpcB4l74yftxuWSiTd8pS3nIvOnqsjNzWUrmjGyC7lW4fOgKFihhmDJTX7mjPbr/0/uQXWdkOpPhUBHuQ1eMOb7Hiw7r+LbXkBWD7xxezP0qKU4IRslu0jqLUOG4VNP48dn4C9SHxyNCoe0aI80hxL45EBTMW/rm34y/Xq7tmaPfcX8t1dgy6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01/11/2025 12:14, David Hildenbrand wrote:
> On 29.10.25 11:08, Kevin Brodsky wrote:
>> arch_flush_lazy_mmu_mode() is called when outstanding batched
>> pgtable operations must be completed immediately. There should
>> however be no need to leave and re-enter lazy MMU completely. The
>> only part of that sequence that we really need is xen_mc_flush();
>> call it directly.
>>
>> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
>> ---
>>   arch/x86/xen/mmu_pv.c | 6 ++----
>>   1 file changed, 2 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/x86/xen/mmu_pv.c b/arch/x86/xen/mmu_pv.c
>> index 2a4a8deaf612..7a35c3393df4 100644
>> --- a/arch/x86/xen/mmu_pv.c
>> +++ b/arch/x86/xen/mmu_pv.c
>> @@ -2139,10 +2139,8 @@ static void xen_flush_lazy_mmu(void)
>>   {
>>       preempt_disable();
>>   -    if (xen_get_lazy_mode() == XEN_LAZY_MMU) {
>> -        arch_leave_lazy_mmu_mode();
>> -        arch_enter_lazy_mmu_mode();
>> -    }
>> +    if (xen_get_lazy_mode() == XEN_LAZY_MMU)
>> +        xen_mc_flush();
>>         preempt_enable();
>>   }
>
> Looks like that was moved to XEN code in
>
> commit a4a7644c15096f57f92252dd6e1046bf269c87d8
> Author: Juergen Gross <jgross@suse.com>
> Date:   Wed Sep 13 13:38:27 2023 +0200
>
>     x86/xen: move paravirt lazy code
>
>
> And essentially the previous implementation lived in
> arch/x86/kernel/paravirt.c:paravirt_flush_lazy_mmu(void) in an
> implementation-agnostic way:
>
> void paravirt_flush_lazy_mmu(void)
> {
>        preempt_disable();
>
>        if (paravirt_get_lazy_mode() == PARAVIRT_LAZY_MMU) {
>                arch_leave_lazy_mmu_mode();
>                arch_enter_lazy_mmu_mode();
>        }
>
>        preempt_enable();
> }

Indeed, I saw that too. Calling the generic leave/enter functions made
some sense at that point, but now that the implementation is
Xen-specific we can directly call xen_mc_flush().

>
> So indeed, I assume just doing the flush here is sufficient.
>
> Reviewed-by: David Hildenbrand <david@redhat.com> 

Thanks for the review!

- Kevin

