Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47885606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 19:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hUvLR+bo
Received: by kanga.kvack.org (Postfix)
	id 640E36B05B5; Wed, 11 Nov 2026 14:43:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F20E6B05B6; Wed, 11 Nov 2026 14:43:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BAD86B05B7; Wed, 11 Nov 2026 14:43:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D40416B05B5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 14:43:11 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 55955A7F29
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:43:11 +0000 (UTC)
X-FDA: 85423861782.30.695307F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DBF020008
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:43:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUvLR+bo;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794426189;
	b=pxLn4K3DL62+UPxiUQZ4RaW2lq4YR3n8o9++2p87WqqG+Pf/EH0YzvJGI9XIRG7qVPSwvz
	mSSWBq5jydevq+T0DVNMjd1UnKmoEKYMMp/yJx+6VgOXl/w0cCBLh/paDAJ6KHzgvwiUrY
	a0MiwGu63BAXZtvQOGhUucqdbpLfwBQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hUvLR+bo;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794426189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2vDqA8f48MzAhhukXlkIPSTxvdHyn7+6decpCKpqaQc=;
	b=5Bb5I73wATTjP9jDlyn/8N/tvBxxIDFsH3Jy6oUwjDArjB9C3ObVcqaTNetXRjZJtgY29z
	5OqlE+/+ok/XHBgutEeJH/jc4za9uy+nnqK/y8JeLt/3jKcBAamAH9YIJe8VpbD9pBLN2x
	eVAIfqcK962N7XvbxPvareInFsrV0ig=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 018DB6540D;
	Wed, 11 Nov 2026 19:43:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E385B1F00A05;
	Wed, 11 Nov 2026 19:43:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794426188;
	bh=2vDqA8f48MzAhhukXlkIPSTxvdHyn7+6decpCKpqaQc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hUvLR+boOm7fyzYFTLLM1kzy4pOLyWEFNldRghZ8zaiKvBrfSb6yTLAKnBUkMRnYp
	 5ggVwKLQMqOqI1mocrWk6Jh2qnZU6eBZZpn+h4w4tlUdgZ52c2qhJ0YMVXploC3Ol6
	 CQF5+SgAO+hTNXHA4rK5wSzx65uWyviRO98d0ldSFXH7y1ihg62GiKzs8F23YucqPv
	 ebH00pOyx4rlo4SNj4Gb4voPbPC6/hrdVghLkHXnqoahMCNyY08Q6m2PU1KBa2beoz
	 GWYFbv3A2im8j6u88vRyIUaS2+wmR3NUPrqzKqelrBuGoJJqlHSkKX5Oe9/Qau8bfb
	 lrX3hLe6spCcA==
Message-ID: <71e24630-4c71-4518-a9b7-68cf3597ce80@kernel.org>
Date: Wed, 11 Nov 2026 20:43:00 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [SECURITY] mm: khugepaged collapse_file() drops RWP PTE markers
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, n3rd <18670333770@163.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "ljs@kernel.org" <ljs@kernel.org>, "ziy@nvidia.com" <ziy@nvidia.com>,
 Mike Rapoport <rppt@kernel.org>, "peterx@redhat.com" <peterx@redhat.com>,
 "security@kernel.org" <security@kernel.org>,
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
References: <606cae9e.bbec5.1a1c54f4f9f.Coremail.18670333770@163.com>
 <60541e98-b1f0-4f92-a155-8a29c0bb17dc@kernel.org>
 <44abb8ef-7711-4ad0-be9f-ca47206892a3@columbia.edu>
 <856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org>
 <avS5QcRj85yAm9ll@thinkstation>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <avS5QcRj85yAm9ll@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 7swqi9iri1hw8ej3s4jqcufkjutqws7z
X-Rspamd-Queue-Id: 7DBF020008
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794426189-21169
X-HE-Meta: U2FsdGVkX1+1zFVktc91eECeuty/NKJ5J5pyA9qfIc0vDSjMAZknDsyf+vcI5mxwm0+w2I5Uf5vIv+RQs97TtPnxC023lc3SX0019jSRRM0KgZA0JKrQloOEX3ZrxhL2vSSefppnt9zqeWGAglmd9W1Ks06iKReDIgAocu6VWxa40QF0tezIBYfJ1ryMcHv5D2mLctzZsUhOOigQNTh1X+u8wB1d6Cgx0x9o+bIeq3M6sgUGwcbjZdUHmzPWtdjYEX/V3o90kMifFIeGhgt4LpiFAZk4JDA9OD7CcyO1Ck0r/WVB9FbeHs+lNO2sNy4xJ7R338lgYxoDo5Y6Rr6fpIgXebgKwdVPYEQresSYPQZv6RUxCXbG36XqQMZZP18dYRxmYAEPZLFzU8Pc67VGoKv6+wWBqiOAeKuYWhwmWYWsInINZ7kcg/IA4/YpSj/3DlLoGbM+7CSg25N0jgCPBoS1n7SmnPXElO1s0NBJoF3S7Evm75FsyYjtJDg3LvWim1oYahepjS/g6hebbHjRMHKIKIV9TbvEpP85BzoGUhnLbkGBllhw0X4SebbTNZbxzA6znMMsAPsugJs6xjzMsZu1572UsH1dX3gC/rnYXzlFxPVi0o829wllp3ltFur8nXRcTJDSBLCzYqjdkE0r7/1JKycOhHLutRjBtUpoUq1xbAGWSWR82Uokqu5BqQhOQSLA0sXLIqBOkpPdSdJq11adN4Syz1zszYiMTxtb6WKymCCkE1r1VW34y0g+ZKXorGXibbIFliTpM/6s6CJTv+Zr8zKNBEK8mV884U/62dpXEB1TuuDQ0aHeN0XbvcFTRyjD34f3JQyDNRxPF0HvALNggRyiq9ObxqaGkVy4tqSTQiEzU32fOy8i2Jkw8MXLqDWe/WnLjZapMHOHGf5LVUmDg8l1yCKDdikFDi61TTQXAislgPHSSWC7qNfaTeWQaXbbB6BXVHzu7Q5ImDu
 8iMwMHuD
 8H+GioZx8ISH2u3EcYlcQMxk98I5DQ7kHLlwrUPyqznAhyYJkC96Zk1fXDUOYmSksGLFtsAk7qQR87T4SRh/ZMhAewFyU4pxd8mp+GJPFOebdm4FC/Ar8x9p7ArCLi3VJg/uly3FVw5Cz0gwE34Kb2nrC13EcO1zIrikkVwKGNxuk2HHyeWs0JTHWtY+1N1RpF7BMTALvCbaxIK8z6cW6bkdtK0qk1LcmqGaV1ljtwsm3TmLyxTOJcSHkNSaQUTBrZSH60PFSfckDV3YiIDkjJz2ORpTZadztYQ0aK7nRw8lyyQqDMsCc/EYIrsFubewHDx/dhChHXETm2mfIWvdzIYzwNaXXu1EGVxduj3JTrS39moKri7G7BLcNTZZJTd56l5iJ8bQ0WpsvfXAtHj2W5Oh5KsF3m7TAyv+Ak2EKdxlyJVdwMsbVU3jHF3HlHrvhYeqqFVGtjkz/zwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/11/26 19:53, Kiryl Shutsemau wrote:
> On Wed, Nov 11, 2026 at 08:29:50AM +0100, David Hildenbrand (Arm) wrote:
>> On 11/11/26 04:19, Tal Zussman wrote:
>>> So this issue was originally on my list and I had a fix for it... but it was
>>> REALLY ugly and a band-aid, so I dropped it.
>>
>> Yeah, RWP is a mess.
>>
>>>
>>> I think the real solution is to just add actual markers for RWP and solve
>>> all of these issues at once... but that should be a separate series from my
>>> batch of fixes (which I'll be sending shortly). Is there a reason RWP
>>> markers weren't done in the first place that I'm missing?
>>
>> Let's ask kiryl: why is it ok to drop RWP PTE bits during swapout, zap, collapse
>> etc?
>>
>> https://kernel.org/doc/html/latest/admin-guide/mm/userfaultfd.html?utm_source=chatgpt.com
>>
>> states "Unlike WP (which persists via PTE_MARKER_UFFD_WP), there is no
>> persistent RWP marker today. The user needs to re-arm the range with
>> UFFDIO_RWPROTECT after any operation that explicitly frees PTEs."
>>
>> But requiring the user to re-arm is rather questionable design if the kernel can
>> just zap these page table entries.
> 
> There is no need to re-arm. 
> 
> Once the PTE is zapped, the next access faults, and userfaultfd already
> has a mode for that fault: MINOR if the page is still in the page cache
> or in swap, MISSING if it is gone. Register the range with RWP|MINOR and
> the first access after collapse, shmem reclaim or MADV_DONTNEED arrives
> as a minor fault. The monitor counts it as an access and resolves it
> with UFFDIO_CONTINUE.
> 
> That is why there is no RWP marker: MINOR already covers it. WP needs a
> marker because MINOR would trap reads as well, and a WP user does not
> want those.
> 
> Anon has no MINOR mode, so there the bit stays wherever the page
> survives: it is carried on swap and migration entries, and anon
> collapse bails on uffd PTEs with SCAN_PTE_UFFD. MADV_DONTNEED frees the
> page, so the next access is a MISSING fault.
> 
> The report registers RWP alone. That is the only setup where the access
> after collapse goes unreported.

I have the faint recollection that we discussed that handling during early
(pre?) RWP handling.

I think that expectation and the implication is indeed not documented anywhere
for users that have no idea what markers are.

Even LLMs are confused.

Or is it documented already?

It would be a lot more consistent if we'd just add marker support. Or is there a
good reason why that is explicitly not wanted?

-- 
Cheers,

David

