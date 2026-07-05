Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0EFDC43458
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 08:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69AF76B00A0; Sun,  5 Jul 2026 04:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 625136B00A1; Sun,  5 Jul 2026 04:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4ECBA6B00A2; Sun,  5 Jul 2026 04:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 22AF56B00A0
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 04:08:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 94B5D1A068D
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:08:58 +0000 (UTC)
X-FDA: 84953997156.05.28A962A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 735F41A0006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 08:08:56 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FqQCx48U;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783238936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSUmvuRPVl9U9TACBIYiWbf4aORkyvu1is7CpbgFQ6k=;
	b=gTtR0QlS2qLPUQF7xY1ob6imsF7T2xEQwi9Yy7tF9h5WzwoZNacrsAH6PAMwjIw32Y6xEy
	45p/AAl8Z4La4d08tD6teeGT6DYQ5G6z8WfZ7540W2RfLvefmpOUIW4NOYXvyXP3+T1yvO
	EZOx7beFmPJn6UE0LA5VHZZKBDvU3e8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=FqQCx48U;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783238936;
	b=XBCuDIT4s01WGZI+GLhI+udjMHJjgxMUGMQpCakP1tOgBOBt4jBZLeOQcr3MItoYCAFej0
	EQQ1KCAgwND0VDqa0aIejZtlk/WHbYrTpdnsCm3KmYEQRQypSJSSFh/+KJkAPmHOuyo9k6
	DU1txvPa8K9n4wAXTSWLpzTnCB8h5gw=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DA63B1D70;
	Sun,  5 Jul 2026 01:08:50 -0700 (PDT)
Received: from [10.57.73.18] (unknown [10.57.73.18])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id BC3F53F905;
	Sun,  5 Jul 2026 01:08:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1783238935; bh=cIrRmXjneRyxZCYVtjOisOC7Q6AqKSJ27U6Pgn9w7QE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FqQCx48UJNUfeHogU9/y9HwEqlbbhAQ6HAGisLpAoZ06/5JM87N/K8zIXSOkQS9Lo
	 tzFVemZDjh6FMqDs/3oBIzs/gxTzjo2BY91OzyLW22GOwYSGCjWr8ywmF0OCMoI9D1
	 02im7RrlbLfHvqkoRtrjjP2YXspf26q5PHLafXU8=
Message-ID: <8fdbe0d6-87fd-441c-b6d2-baac380f6fb3@arm.com>
Date: Sun, 5 Jul 2026 13:38:41 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
To: Andrew Morton <akpm@linux-foundation.org>
Cc: muchun.song@linux.dev, osalvador@suse.de, ljs@kernel.org,
 david@kernel.org, liam@infradead.org, riel@surriel.com, vbabka@kernel.org,
 harry@kernel.org, jannh@google.com, lance.yang@linux.dev, kas@kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, apopple@nvidia.com,
 rcampbell@nvidia.com, ziy@nvidia.com, matthew.brost@intel.com,
 joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com,
 gourry@gourry.net, ying.huang@linux.alibaba.com, ak@linux.intel.com,
 nao.horiguchi@gmail.com, mel@csn.ul.ie, j-nomura@ce.jp.nec.com,
 pfalcato@suse.de, tglx@kernel.org, dave.hansen@intel.com,
 jpoimboe@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260703114202.365553-1-dev.jain@arm.com>
 <20260703114202.365553-2-dev.jain@arm.com>
 <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260705003559.8b124d2b94b685cc2e4e77ae@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 735F41A0006
X-Stat-Signature: k3pe7t73u5p99p4wwitpjqkqswuks5n8
X-HE-Tag: 1783238936-796685
X-HE-Meta: U2FsdGVkX185qlRyY0USRSQ20KlaPtQWapHCH2vHdZDPMbInGFWphwP6Q96TENDhbWnbE+IgGB3AuwZ/COPcMfWIMcnSNuBl12CD/fVGhYrl9JJ1fBZqTsaRf5v0lWRL0cZ0+xQqP1MvuovgJ0qHLppBoy/k/44q61XL89Mou4ftZSoss4QJbIqc3BnNNMOe0lq9W8W02Cn63s7/oToqWsOznQIcw0Ig3T3zzCPOCVNWyZMyLorecDdwWk15E4ICGkIJ+Ag1+wq8gT5XpGP3r7Q19SeEpm6+Ru7Bgtos5I+QbiaX607E8O1pN5qHzungZvi5oycC9buYqYv6SkYozJiSw2gUiq92nBBXfszVO6DB8j4ifU4b62ff4LRXuG1n21ra/j1KC07q//PjRnEIjmFr6VHgk4qeD6LDp+i8ecjVSLS5omPvgy6IJUWVm+w91uXAems766ZWo41wiyUtwPlQ/fkPiV8SbydbKkYJifyIbK5c87z+CUDzgKlIQAFjvq+ozW/32B0TfFzBdqyczru2Ikm9fVYZg99FZMHzQZluIKF3GE+M9SGlPtYI81cVvXDIHlQMS53KIrnHRKoVmiIriOmJAYrA5Jak13rPPei4y93GaVINiAAsQa9VIkCBMF3gbo4ah+Kg/WtAO8V+chkIHAhvTsBZaTWqKG+lnvMIuSPYW4eogsqGjR9ilXqLwqa3yMbUmJSeRaBi4bccCdFa5RbAZ+GMDW9rByugfoN6I9ROa7zocd3EVER/7LGODzffLHi1kJqaVywdFnUiZVjFClqLs04dVpkz42V4t/qvlSqCPr9pgH1pmEgmFuTQfROBMh56xqt6ORuEW/m0c1MHk4rZlaC+EyAk/dZu4INqwy4roCECI1ayi5rqS+Y+Dx+iZjm3J4fSfx9GpjnUPdQI2U6fQnMgpbOmwH4eqaeh7CotLfbDwgetfoT9wMKUtTWrZyp8WPPHFLCWkv5
 ljG3snDy
 Q553n3vRQpuBMWUG3ABPiTtJAKmg28xVQ+CUUipi1kcxD6t1x6zJo9EW/gVLu4HqgESVb1BgY74KCf1/bE3FsRNw3NtLPAOLx14GSjJ9bp8SxFNQqx5IkhRuVgsytY26wz9qxm72lDqp0j1UO0S0uCforr5DvojS8XTBDIf/IDW3/GCa/TPrZHZJsqCwn/G3ZPDqfutQRE7iip6ZOIlpVcv9LmYZfXT5bu7HoQPJxXXjhKOXspE0hPItWLyVLUS3fQt8j/MqOwttvtZXqMkAVdE5AIq4GyoGW5gtJ5BDdYzxdJJKWdiyIx072azjEaLZVt1GshnA7UCcAA9wBYLgJE1t/6aNSXqi8Jw97qfo/cu/DJrK7fpy39y3HHt5H433NE3tQpYmM8ok8zqozMgKu6N8CgQAK7RPswQsw0qu/ZM9OymxmBDHh1nUCRICX1fTZXH94
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/07/26 1:05 pm, Andrew Morton wrote:
> On Fri,  3 Jul 2026 11:41:54 +0000 Dev Jain <dev.jain@arm.com> wrote:
> 
>> huge_ptep_get() can be handed a virtual address pointing to the middle of
>> a contpmd/contpte mapped hugetlb folio (examples of callers are
>> pagemap_hugetlb_range, page_mapped_in_vma).
>>
>> The arm64 helper rewalks the pgtables in find_num_contig to answer whether
>> the huge pte we have maps a contpmd or a contpte hugetlb folio, and
>> returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over the
>> contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
>> if the addr is not aligned.
>>
>> Fix this by aligning the pmdp pointer down to a contpmd base before
>> checking equality with the passed huge pte pointer, to correctly answer
>> whether the huge pte is the base of a contpmd block.
>>
>> Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
>> Cc: stable@vger.kernel.org
> 
> Please describe the userspace-visible effects of bugs when fixing them.
> Particularly when cc:stable is proposed.  Thanks.

Forgot for this one. It should be, on systems where CONT_PTES != CONT_PMDS
(meaning page size is 16K) we could collect excess a/d bit state, meaning
extra work for the kernel.


> 


