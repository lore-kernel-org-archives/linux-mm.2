Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7B3ECD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 11:15:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A1D2E6B0005; Thu, 11 Jun 2026 07:15:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CE3A6B0088; Thu, 11 Jun 2026 07:15:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E3C46B0092; Thu, 11 Jun 2026 07:15:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7BE216B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 07:15:43 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 12FEC1205AF
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:15:43 +0000 (UTC)
X-FDA: 84867376566.24.BDE4282
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf09.hostedemail.com (Postfix) with ESMTP id D6498140015
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 11:15:39 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uvrm35v8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781176540;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yVOs9G7BhFCl2zXLY/E4s+NW4ToSbs9i+XEVCpRkH/s=;
	b=SK8jEU9A38ArHCyUAAIm4n9UXKcrk9w0v0p9OsEzdKDPN81dQb8xfIf2TiUUnbsPR6xzAs
	SAGXhKn7Ch+ZITEUAbrqQ3lrQMRKoGpOctGU4xpLShTk9qi1keDlOpUGPcbV88hAQz9rkw
	aDSTCBpv3d4aXcTwk86mH5osIN4mSlk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=uvrm35v8;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf09.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781176540;
	b=ijL0++aZXho40c4SoBAitbMOP4yYr76MH9cxw4/LWKncXGpYDrzYxlWu62mywFhlW0uRrk
	W7CLV0wa/tlpRj57o/35K29zWSMKnNs/CG1QMvcqQnshzPHhl51JCAJDBcM6erNJuu5j/g
	2B7WK3rJtweROpl3tlRHuxdg6XpAijk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1781176537; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yVOs9G7BhFCl2zXLY/E4s+NW4ToSbs9i+XEVCpRkH/s=;
	b=uvrm35v8wZ04KuyY5Bsxk5oi2AcLI/b3k0YI6zZqIQrVj42j0o3LzJGMEx4+voHWlgjr+S7dU/hr9kmAVk5HDzrZEXwl7MjJfbREbRK23bEkky/QOAuPTifNMWiQm/jMMYwNZHE10OtDz9zTE0iuht0BRJdLS4wRyCqYCFrjhOQ=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R521e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=15;SR=0;TI=SMTPD_---0X4dXY1r_1781176535;
Received: from 30.120.38.205(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X4dXY1r_1781176535 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 11 Jun 2026 19:15:35 +0800
Message-ID: <4292a25b-5707-401c-9c8d-2210a165ea7c@linux.alibaba.com>
Date: Thu, 11 Jun 2026 19:15:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 04/11] mm: khugepaged: add shmem mTHP collapse
 support
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 hughd@google.com, willy@infradead.org, ziy@nvidia.com, liam@infradead.org,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <0e431c06-b80e-4b4b-aeca-b9a0eacb6252@linux.alibaba.com>
 <20260611024706.95748-1-lance.yang@linux.dev>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260611024706.95748-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D6498140015
X-Stat-Signature: oofddki6yzorfd3g8pqsz1q53wswpne1
X-Rspam-User: 
X-HE-Tag: 1781176539-719797
X-HE-Meta: U2FsdGVkX19dTVOKkl7FPzsZXYm/rvQaVWzv76kx2dXJjEw8KIWvKB3tfHu9TR6YPSEcHr0iy8wqRzLpQ42V8m4Zr6UK/Zgi7Nl5IOhJs8Wy2xfTZydnh9/yXcdnUfu6vmAJn5bPgwZV1rEak59OVT9sIJ2OihPTLX9nDP3Z61jmQZdmSW1l98YcBDjnTA3GWkWx9C+1f2oUIfLnDmxZ3VK1f257sLrtRSahQ/+4H2m6WVVTo/iBQhaR9rTqF2gdVUf+gSEpnZWeSk2Xeyq7BXdI/poIUzjb8jKwVPhESukDQsOVnmk3cS0fuOCdJA/ThJWM0lcht+gYQDmtgC0wdp1Bh2kvGOAoVa1t9fkK7zcJvRVY1u6NcS2NLBh193lOoa9L11DN+pwNgFkoWtkw//PAtrpiPpUcY+wEEgO9bnCnY1FbFqzWU4YOfBcYUaSMb2mHGD3HrreF38Q/S/LdBrA8NohyrtzZCqKZjFcfOtsaTpHdd3kT8m9/2xv70cd192bzuy7Zp2bxCOOSbqtI+VXEN7ETO/sH8M4VbL3Po75/aqUJIC6aQ46P0z4+cxCu8UScbF1NWqb1Wn0QYadu/m0ddiHOc840txNljLHBKRTn6hjZXJOiCmiMpzyqhWvToxbjqbGLnJtz3bTZ7v/aq1n6fXwp8UfjCliGZD3fwN9P4tguJqmWv5nWeM1iIzFoT40NgVP1MDA+RhwuAQ/38BRLpKff55c/w4EwD52Y5ls2D9nMaDfogKgHHzKRhlInrcKJ8d861wIc4iUsYOtBfrsQRxixbnkMThX7GhXvqzvRYj8OuNt/pbL64RZI1CvJPjrQBvXytVvA9hwjDhHr8sX7kw3pQHjDg2ICuA0ZDdvaVusYzkioLt+iKcgNLDdRFFBb4jMskrt0MBbxmcXecUAZQzOYYQ2NqS+a+AH3KkqV5HtL0Gu3NJIQgTfqeWvr4+lbtue8VmjdoeJexXd
 BLn+V8nl
 LgrpphyRF2TtfkizOOQ2Oy29MRSUaqD5IfadHwk/qJoxUUmLMViNIbTyWw+puB301j4ENxDlbE9Zpr5MpHNIF5iK70pxl96VlB3WL1+R/911B3wLhzwPjO4UJ1ziViBuACG+WV0BN7pAUQaNZj05o0iQVLv7fLRsxnWBGot/+CyWebHfEPjnbeA9sc6hqjKoI99bIqT9FZfcOjc9HVXOLTPOVxGi7qb+XkxhcbRDu2bP2sWGtGtdIbXA3DRfIkOUU4imRFsOaZeDB8Axj9Q3Gh7ee8CrRCQb3zWrRspBO11Xi9yRA/mTIqlZr6LqrnBAF4DKu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/11/26 10:47 AM, Lance Yang wrote:
> 
> On Thu, Jun 11, 2026 at 08:42:28AM +0800, Baolin Wang wrote:
>>
>>
>> On 6/10/26 8:44 PM, Lance Yang wrote:
>>>
>>> On Wed, Jun 10, 2026 at 06:29:12PM +0800, Baolin Wang wrote:
>>> [...]
>>>> @@ -1512,8 +1517,12 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>>> 			enum scan_result ret;
>>>>
>>>> 			collapse_address = address + offset * PAGE_SIZE;
>>>> -			ret = collapse_huge_page(mm, collapse_address, referenced,
>>>> -						 unmapped, cc, order);
>>>> +			if (file)
>>>> +				ret = collapse_file(mm, collapse_address, file,
>>>> +						start + offset, cc, order);
>>>> +			else
>>>> +				ret = collapse_huge_page(mm, collapse_address,
>>>> +						referenced, unmapped, cc, order);
>>>>
>>>> 			switch (ret) {
>>>> 			/* Cases where we continue to next collapse candidate */
>>>> @@ -1521,6 +1530,7 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>>>> 				collapsed += nr_ptes;
>>>> 				fallthrough;
>>>> 			case SCAN_PTE_MAPPED_HUGEPAGE:
>>>
>>> Looks like SCAN_PTE_MAPPED_HUGEPAGE from collapse_file() get lost for
>>> the PMD-order case.
>>>
>>> Previously, collapse_file() returned it straight back to
>>> collapse_single_pmd(), so we would run try_collapse_pte_mapped_thp().
>>>
>>> Now it hits mthp_collapse() fitst, and that case just goes to
>>> next_offset ...
>>
>> This is the expected behavior. SCAN_PTE_MAPPED_HUGEPAGE is only returned
>> when the MADV_COLLAPSE collapse succeeds. In this case, if
>> collapse_file() still returns SCAN_PTE_MAPPED_HUGEPAGE, then
>> mthp_collapse() will ultimately return SCAN_FAIL (because collapsed ==
>> 0), even though the MADV_COLLAPSE collapse has already succeeded.
>>
>> Additionally, the SCAN_PTE_MAPPED_HUGEPAGE logic is already handled in
>> collapse_scan_file(), see:
>>
>> result = mthp_collapse(mm, file, start, addr, 0, 0, cc, enabled_orders);
>> if (result == SCAN_SUCCEED && !cc->is_khugepaged) {
>>          /* If MADV_COLLAPSE, adjust result to call
>> collapse_pte_mapped_thp(). */
>>          result = SCAN_PTE_MAPPED_HUGEPAGE;
>> }
> 
> Right, I agree for that case. The one I meant is a bit different.
> 
> I was looking at this earlier return from collapse_file():
> 
> 		if (is_pmd_order(folio_order(folio))) {
> 			result = SCAN_PTE_MAPPED_HUGEPAGE;
> 			goto out_unlock;
> 		}
> 
> Old code let it bubble back up:
> 
> collapse_single_pmd()
>    -> collapse_scan_file()
>      -> collapse_file()
>        -> SCAN_PTE_MAPPED_HUGEPAGE
>      -> SCAN_PTE_MAPPED_HUGEPAGE
>    -> try_collapse_pte_mapped_thp()
> 
> Not limited to !is_khugepaged. collapse_single_pmd() only checked the
> result, then passed !cc->is_khugepaged as install_pmd.
> 
> Now the same return goes through mthp_collapse() first:
> 
> collapse_single_pmd()
>    -> collapse_scan_file()
>      -> mthp_collapse()
>        -> collapse_file()
>          -> SCAN_PTE_MAPPED_HUGEPAGE
>        -> goto next_offset
> 
> So collapse_single_pmd() never sees SCAN_PTE_MAPPED_HUGEPAGE for this
> case anymore. Hopefully Im not missing something here :)

Yes, you are right. I missed this case. Will fix. Thanks.

