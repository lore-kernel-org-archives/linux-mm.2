Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59172CC6B19
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 06:32:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7779F6B008C; Wed, 14 Oct 2026 02:32:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729596B0092; Wed, 14 Oct 2026 02:32:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63EBE6B0095; Wed, 14 Oct 2026 02:32:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4476E6B008C
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 02:32:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A7D4D120440
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:32:45 +0000 (UTC)
X-FDA: 85320263490.02.694EA3A
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf15.hostedemail.com (Postfix) with ESMTP id 4E645A0007
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 06:32:43 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iTcsN+by;
	spf=pass (imf15.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791959564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1JmrvG8Wxu6YtXiksiU23e1HswNsSn5IxgMS7VCL0AQ=;
	b=azZxoKWM+rx+/ypAJXpJ5wXoDPjSkzZXuj0TXjsIOX4ahQ3vGy0PPppwbROumtz+oBsk94
	6gbgYRjhkHd2csKXaJnJWQPEQL8QeQt+gJPnhEzPXKKWHEVHS8+KyZGP1aWRZuw5SdJeIz
	mMboAG+p5HHe33fp809Vy3y6E8yGqIQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=iTcsN+by;
	spf=pass (imf15.hostedemail.com: domain of zhaogongyi@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=zhaogongyi@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791959564;
	b=pHjMhP6ooCblT/u39yK+D/ZhA8U6/jR9pg8tMswWKHeO4m/RDAfTjEVjrTgAcjmogW+To/
	9hDB+E21tcj7x+nv5uHzIjy+zs30pp6AZz3s1WCjErmfKhuFHcC4FiMt9MGFXdoX6r7vA/
	RfqQsrZqSBpK3ccu4Rt+8Wb68EVA8gE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791959549; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=1JmrvG8Wxu6YtXiksiU23e1HswNsSn5IxgMS7VCL0AQ=;
 b=iTcsN+byvXNYl6hTEYFqWX8+lbU4twF9xpYtGiOH6InWYmZLRqwfNMRVz2t9bQimc7k9wT
 TjkrOpTjyMYV0WQRL/7JsX086c7rmWh8yDTyg1tRrw0GVt6pd9X069YGiieE/+AVvmY96/
 4YNt0N5ny7Cc8RSMUwpZOnIruFiZmL+/w6ugOS785/hv32r11tWTr5tmln3UEk0x9vY/el
 cBbhbF99VxUyecqIeirKDMSNlEH8Cm/L/vWN6pOg3KjscQLrt0n9yj3NWAl0GpC7H1jDrc
 +QeZlz//gprlBGa91xMSxHvpPReT7tsIW/XlcFZSW18OJhIHtFWsnCQr/jTOtA==
In-Reply-To: <20261013153953.77575-1-lance.yang@linux.dev>
Mime-Version: 1.0
References: <20261013093600.54995-1-zhaogongyi@bytedance.com> <20261013153953.77575-1-lance.yang@linux.dev>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26acf21fb+cf5ad2+kvack.org+zhaogongyi@bytedance.com>
X-Original-From: Zhao Gongyi <zhaogongyi@bytedance.com>
Message-Id: <516828fb-558d-4a20-9532-51f50d6ba042@bytedance.com>
Content-Type: text/plain; charset=UTF-8
To: "Lance Yang" <lance.yang@linux.dev>
From: "Zhao Gongyi" <zhaogongyi@bytedance.com>
Date: Wed, 14 Oct 2026 14:31:59 +0800
Cc: <catalin.marinas@arm.com>, <will@kernel.org>, <ryan.roberts@arm.com>, 
	<dev.jain@arm.com>, <baolin.wang@linux.alibaba.com>, 
	<mark.rutland@arm.com>, <akpm@linux-foundation.org>, <david@kernel.org>, 
	<ljs@kernel.org>, <liam@infradead.org>, <vbabka@kernel.org>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, 
	<linux-arm-kernel@lists.infradead.org>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH] arm64/mm: restrict transparent contpte mappings to valid PTEs
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4E645A0007
X-Stat-Signature: sswnkgnfx9xsxjq31jm3te7kwoabb74m
X-HE-Tag: 1791959563-816179
X-HE-Meta: U2FsdGVkX18iStvp9ADpHOBdgdn488/VhdrpnRmrHrBSa32uPHRTFSdXEnqVLTpVJYlu5GNNYaGikAdu2q+Evu25CpolAfwJFQbPcAKHmBNCI0RW4zUoCtNH3qs7Sj/LHZ5hi+1YFfubn5Kt1U3tokCCehLYerPJ72ACByEGndFVe2pq41OR3DSBojVDX3aKMA9abjfxPh+zZlMBkqygOvtXr8/LaL5oqkVOWeTph5W/9muvPA2qG5D9PR2GeRjsgiKqFV0+jLMAqacxNQuRMQk8h6fe2YII0mw4Trt+TquV+AAozFXxbvvla8S/k885pJN9ibjnzUQTVF3TgdiO/Pog/jv+NUzcwvERWNKy4RxQSKNp9aA2+HdQePDPwXaDfCyfoEA7BLxVhfLk2KE7fNPKyXHciSZ4Y1Ou4amxTMb8f1e2XjDuxa3Ey4Q5gkeqGBkO0YysKYMR+IULn1Ecl317FdJoeeN0y7deUNhxAW+vas5m4LehF35LgI96qRg+jA/SECFG3ItxaPQ6Lx32gky1Bs9oQaq1vHhzOfXWNjLwXtMARR42yzaE7fsmo3mbVUo0ZxHtRHbpEa/ivF/fL+Mky3fMUU+/Z0tAT+j6h5jjTQug3p9HZkMh9kLVs8w9WMA/Lw2Oge9FebPB103kk98mz4fvF9o2fOaxsh0kDmb0GV/lLCMSbPa+mJi+265PDndD/jzk+uCNLw26enMN2L4FU/b7SLv+8N40yTeGkl3nENB0EIEB4KP6QltyT0ElPY0eR0O00CpNuVCfwIsPPks+CMFhkCf9L4PHH6ttfZ1+Lu7wvxWRYuAlL+lZvH9tZz7dpwTepZ5V3kRwHpAI6LbkrC6IfjoVE3v8BQOhSeNTjgOFO2C4rksCkG1059PYfyf/Bj5spKVXubzwvCymi9STiBDAeOsXhGY6bBt8DBN6Ke7NvWAAyyI2iJw5Hl1nkZcQu6A4JU+12mvVWNx
 OcO5/YDX
 rjSr+fFofSgzlbDHSqFtOdYiHyM/zc7J1qrTmYNkosWqAxEIjRs/1sT5BwhGwiejGzPt3QDRrLkTTlojZCQlhSxQjg8C0IqKO1iLnKtGNj1nRTKBWFOMPor8dLhkEiuYyk11SHR5C94rleMe+hxuZSPygCmOPsgQi2jOoAR1xij+gCMlEYtROUrgIe7jp28KcY2U9h39i1V1c/JaiGQBIGAX0fDOXsv1TrTsWypnioCucJ9freTkQuYmjhicfhVYiCJGfHPUegwtf800RZlDzlujMjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 11:39 PM, Lance Yang wrote:
>>
>> +	/*
>> +	 * Keep the producer-side invariant documented in pgtable.h true even
>> +	 * if a direct caller passes an invalid descriptor with PTE_CONT set.
>> +	 */
>> +	if (!pte_valid(pte))
>> +		return __set_ptes(mm, addr, ptep, pte_mknoncont(pte), nr);
> 
> set_ptes() is the only in-tree caller, and it already clears PTE_CONT
> before we get here ... no? Why not fold !pte_valid(pte) into the
> !mm_is_user(mm) check below and return __set_ptes() directly?
> 
> 	if (!mm_is_user(mm) || !pte_valid(pte))
> 		return __set_ptes(mm, addr, ptep, pte, nr);
> 
> If a direct caller does pass a !pte_valid PTE with PTE_CONT set, I'd
> rather add a VM_WARN_ON() to catch that. Silently clearing the bit would
> hide a caller bug :)
> 

Hi Lance,

Thanks for taking a look.

Yes, you are right. The public set_ptes() wrapper already strips PTE_CONT
before calling contpte_set_ptes(), so the pte_mknoncont() in the invalid
path is unnecessary for the current in-tree path.

The issue I was trying to avoid is not that the incoming pte already has
PTE_CONT set, but that contpte_set_ptes() rebuilds the pte from pfn/prot
and then adds PTE_CONT again based on alignment. For an invalid descriptor,
that transparent contiguous encoding should be skipped entirely.

So your suggested shape makes sense to me. I will change this to return
through __set_ptes() directly for invalid descriptors, and add a warning
for any unexpected direct caller that passes an invalid PTE with PTE_CONT
set, e.g.:

	if (!mm_is_user(mm) || !pte_valid(pte)) {
		VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
		return __set_ptes(mm, addr, ptep, pte, nr);
	}

That keeps the fix focused on not creating new invalid contpte entries,
while still catching a bad direct caller instead of silently sanitizing it.

Thanks,
Zhao

