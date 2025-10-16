Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 296E9CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 09:12:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 518438E0005; Thu, 16 Oct 2025 05:12:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EFDC8E0002; Thu, 16 Oct 2025 05:12:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42C7B8E0005; Thu, 16 Oct 2025 05:12:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 333498E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:12:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D7170140244
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:12:13 +0000 (UTC)
X-FDA: 84003410946.03.6943435
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1267CC0003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:12:10 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oNeAWAdY;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760605932; a=rsa-sha256;
	cv=none;
	b=TCs0khCfaf/WGjRVQz8VtWltcOUlyDdemdZlnBdJ+/qPwULKzZDHyNPn1+mT3Z6rFyK8/r
	YmOdSh85A6NIIqJWqINyv9ZKjWWwxBzCaY/aaq6Ln9lsz7xXGR5fPORf0CrfWx7FgIDtVt
	1ZZkGj8TvP32tTGHmntDZEoHP1DnINM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=oNeAWAdY;
	spf=pass (imf10.hostedemail.com: domain of ying.huang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=ying.huang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760605932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fgeHUBnnzn4F0XCj9WH4FTp3VMCD901IrDDVgd7Moos=;
	b=2P/wSkXdMUwjDOa5ypVgqfm0h093+lH4jsQmlHLe0qUPyOHeik3t+s9C+p6IBWaj13mHkX
	Cu3hSEuwR+99pXmgClMxRYix+mVzdDNg2NdpPI5l2imtEuKwZ8WEpX7QuIXM+euSQSHQFV
	/GSrWhZ/U/LZ4CfHQy0bhE/ODyq/fs4=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1760605927; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=fgeHUBnnzn4F0XCj9WH4FTp3VMCD901IrDDVgd7Moos=;
	b=oNeAWAdYxYZs9ysXbbNF/T0xflB58d7nDdUQwfFYc5L8dG85LowfDbXqI2ROe5MyTgJyrhLWWsITQ2sfVPy5DsrSlYIrmCWQGZd15db9wJcIPk/PKlB88ATB9CbTe80/ZKr8tcUKz8wnh+77Jt0hRb6kctVUrFUt9wNUlTVDutA=
Received: from DESKTOP-5N7EMDA(mailfrom:ying.huang@linux.alibaba.com fp:SMTPD_---0WqJqvSn_1760605925 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 16 Oct 2025 17:12:06 +0800
From: "Huang, Ying" <ying.huang@linux.alibaba.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: David Hildenbrand <david@redhat.com>,  Catalin Marinas
 <catalin.marinas@arm.com>,  Will Deacon <will@kernel.org>,  Andrew Morton
 <akpm@linux-foundation.org>,  Vlastimil Babka <vbabka@suse.cz>,  Zi Yan
 <ziy@nvidia.com>,  Baolin Wang <baolin.wang@linux.alibaba.com>,  Ryan
 Roberts <ryan.roberts@arm.com>,  Yang Shi <yang@os.amperecomputing.com>,
  "Christoph Lameter (Ampere)" <cl@gentwo.org>,  Dev Jain
 <dev.jain@arm.com>,  Barry Song <baohua@kernel.org>,  Anshuman Khandual
 <anshuman.khandual@arm.com>,  Yicong Yang <yangyicong@hisilicon.com>,
  Kefeng Wang <wangkefeng.wang@huawei.com>,  Kevin Brodsky
 <kevin.brodsky@arm.com>,  Yin Fengwei <fengwei_yin@linux.alibaba.com>,
  linux-arm-kernel@lists.infradead.org,  linux-kernel@vger.kernel.org,
  linux-mm@kvack.org
Subject: Re: [PATCH -v2 1/2] mm: add spurious fault fixing support for huge pmd
In-Reply-To: <3fc642be-b8f3-4fcb-b13c-3359cd52e921@lucifer.local> (Lorenzo
	Stoakes's message of "Thu, 16 Oct 2025 09:25:12 +0100")
References: <20251013092038.6963-1-ying.huang@linux.alibaba.com>
	<20251013092038.6963-2-ying.huang@linux.alibaba.com>
	<4c453dcc-2837-4f1a-905b-3462270f5e31@lucifer.local>
	<87ldlcpnbx.fsf@DESKTOP-5N7EMDA>
	<d748bc6b-2aff-4cee-a233-008f4d2555fa@lucifer.local>
	<87bjm7lh4u.fsf@DESKTOP-5N7EMDA>
	<3fc642be-b8f3-4fcb-b13c-3359cd52e921@lucifer.local>
Date: Thu, 16 Oct 2025 17:12:04 +0800
Message-ID: <87o6q7i523.fsf@DESKTOP-5N7EMDA>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
X-Rspam-User: 
X-Stat-Signature: 5igc5wotefyzhx517doazzw97t4eeezj
X-Rspamd-Queue-Id: 1267CC0003
X-Rspamd-Server: rspam09
X-HE-Tag: 1760605930-463036
X-HE-Meta: U2FsdGVkX1+NCtO6bgAq+oBCeM5l7BHHsJgrbAHByLxetaNW3t/xe9JkVhOr8vjDHRCqi2Gk8mtmOrz0nH1hBys+5YVaZjYCPHWxtEBnDxBXxxmYZjWKTCIBaK5gHxxzlCkAeNLzxVnlZKzLCt2PPuw/W/nOb1chvsKYpn9jjZBRWVCPkFVwn5V2pP7VeY4dUQH/r4GKPfWjSIqwzS92kOHyuI2wngMfYsCBLkIBgtG/NNchYW1OaLb2ojj+S6acdK7rHISypoytnG9Ds9EpTtBfqecam1EXFEVSONn97sA2n4FCoHXYrMZQw9J8N3Yzs0VPyjd8vzW0hb12dJJplEtQPv/OtTKG6DuRtenAYINnLqxxNOZpy7ivbRhaBTshKG3uChNizPL+zxXy6OW7RoT1XvC+TTns6tfhrg4nxD0NfHtWKgPkGD6hUO/oMSqUt/B6wNmVQDLtYbnEVy8DYZ/z1HxOh1tTqOOowEKVUCWYBY+lCqHypAz147eNJ0wkynWaO2FA0l0xo0MuX5nSvmR4ER0QLsCi3nNWcnqXkQq6Iy2LodixhnMVsPIvWgiKuugxDfKpLi3NHR7/nkDXa60V8xiOskG7mLeFHC0dsqj9URv84LI9KA+9GUNK9jyqVLPHgeDPwWh/9GOwnphlakvx70dtfRiEjmTNZM3KIq5r4ltsyg6wbhthSlXwR726Ne4t5v6kYcIr25qG3/cGXrZkUEwZhL0ZBuUWS5oPvq6WBsxRfhWF7yeY9xyw3PoVcnTBTIS/Q6FZPUm39IwHhjJszxheZCXp2BnuCJtm94NTP4FoW0x++4yKx2CzYqwyveMBU7Dxt11p8HHpjBVG0pH0H9rVBZFhmw4IIADewccVnBrrRQzhoyDixVSHpLUGonPM6AvV8y8Hpy+pu4O+sAbquA3bdmmorv4RvXtloUrY51BQgnCKVJDLrtc/ek5AVV7SjHxv9t7nRGG7ORt
 HC5mdRvD
 Ot09P5kvjqB/tAv8xJtwZbvJIVI6b2iD7ZKeuEc6j2zblMATU4z6f63qt7VUckq9am45E3JuWdWxo5pBMDkUiuCMqD8MEw88mk6sLYCgwod7w5HRar4f/0rHvbniuafUvZm1ei4/PiIFyH2uxzkYI+wfBxggVPEiRuD6f8AXRUFEHnbroMoPDmX7igf0yQSMpKtBF5+UQA018hTQIip5TYLl2eIvxbTpSqQvfko/7Kh+a35Y2c5+VGwwmvC1h3tHYELKHJ/cDq7U2YNJndljbQ+H2Xma+co99QxEAEl5cgF6iFW4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:

> On Thu, Oct 16, 2025 at 10:22:57AM +0800, Huang, Ying wrote:
>> Lorenzo Stoakes <lorenzo.stoakes@oracle.com> writes:
>>
>> > On Wed, Oct 15, 2025 at 04:43:14PM +0800, Huang, Ying wrote:
>> > OK this is great, let's put it all in the kdoc for the new shared spurious
>> > faulting function! :) and additionally add it to the commit message.
>>
>> Sure.  Will do it in the next version.
>
> Thanks!
>
>>
>> [snip]
>>
>> >> >>
>> >> >> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> >> >> index 32e8457ad535..341622ec80e4 100644
>> >> >> --- a/include/linux/pgtable.h
>> >> >> +++ b/include/linux/pgtable.h
>> >> >> @@ -1232,6 +1232,10 @@ static inline void arch_swap_restore(swp_entry_t entry, struct folio *folio)
>> >> >>  #define flush_tlb_fix_spurious_fault(vma, address, ptep) flush_tlb_page(vma, address)
>> >> >>  #endif
>> >> >>
>> >> >> +#ifndef flush_tlb_fix_spurious_fault_pmd
>> >> >> +#define flush_tlb_fix_spurious_fault_pmd(vma, address, ptep) do { } while (0)
>> >> >> +#endif
>> >> >
>> >> > flush_tlb_fix_spurious_fault(), when the arch doesn't declare it, defaults to
>> >> > flush_tlb_page() - why do we just do nothing in this case here?
>> >>
>> >> Because all architectures do nothing for the spurious PMD page fault
>> >> fixing until the [2/2] of this series.  Where, we make it necessary to
>> >> flush the local TLB for spurious PMD page fault fixing on arm64
>> >> architecture.
>> >>
>> >> If we follow the design of flush_tlb_fix_spurious_fault(), we need to
>> >> change all architecture implementation to do nothing in this patch to
>> >> keep the current behavior.  I don't think that it's a good idea.  Do
>> >> you agree?
>> >
>> > Yeah probably we should keep the same behaviour as before, which is
>> > obviously, prior to this series, we did nothing.
>> >
>> > I guess in the PTE case we _always_ want to flush the TLB, whereas in the
>> > PMD case we otherwise don't have any need to at the point at which the
>> > spurious flush is performed.
>> >
>> > But from your explanation above re: the stale TLB entry this _only_ needs
>> > to be done for architectures which might encounter this problem rather than
>> > needing a TLB flush in general.
>> >
>> > Given we're generalising the code and one case always flushes the TLB and
>> > the other doesn't maybe it's worth putting a comment in the generalised
>> > function mentioning this?
>>
>> I'm not sure whether it's a good idea to document architecture behaviors
>> in the general code.  The behavior may be changed architecture by
>> architecture in the future.
>
> Right, but we are unconditionaly doing a TLB flush in the PTE case but not PMD
> so let's document that to be clear :)

Sure.  Will do this.

>>
>> [snip]

---
Best Regards,
Huang, Ying

