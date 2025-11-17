Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D356ECEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 13:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A7BC8E000A; Mon, 17 Nov 2025 08:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 358478E0002; Mon, 17 Nov 2025 08:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 246E38E000A; Mon, 17 Nov 2025 08:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 100BA8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 08:03:57 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A07008A3C2
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:03:56 +0000 (UTC)
X-FDA: 84120116472.25.2A92280
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 142B420005
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 13:03:54 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=og7gAhEu;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763384635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H84UNIkhVIRmT09jlghSiPXLjtCWFn2r7vqgCuOmaBI=;
	b=qFL4cNIVc61CBb7Xeel6M//Fhro8M5DOezIdlbvyKDRKooERUk+K8vN4/a0gErwRuYDs2B
	FZr1bWXVqwiNcEyoKKP+YXB4cFkhrte5y47pF+mclV/SLsTJJwdbeWHHVBaMYV5bMYI2pR
	WyyRlSZbulRcDWXgrP5R7lkvKrrIPTY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763384635; a=rsa-sha256;
	cv=none;
	b=czC73/TZYqDiZQuz+LI7Mq+UpHyqs4GxENcCljZGuEfpalxlOBNHWZQ5wRCzBncIlSxpwu
	WYnWZSp2f8Hmve9mGLjMEjkWRcUkmDamPX2Yur4+0JbAtFA1yPHk0U5+Sms1ugzdmowCi7
	no+WJuBi+l18LLA2z3kQ49oHJQhciAY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=og7gAhEu;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7880D601AD;
	Mon, 17 Nov 2025 13:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF361C4CEF1;
	Mon, 17 Nov 2025 13:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763384634;
	bh=mLHRse2lP8TCM6UtCPpAgpRgFlU7oFFLWpKldAxaUS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=og7gAhEubxWK2PIaxk+PhpsRl1T141dZPXVR/3M+0mE6jEsBBUlPP0WGIXlbtztfx
	 RZMsHHJKiX24Py11mbhEbtVtUyBbb6lCyPG6NM6kUwFY0my3BmM+n2RZizwi5CAemf
	 JFvf/pSuVVVkljsfxk8w2JrRjDQ84QyLGLU2/BnLISQWRZEMB80WnVyLMcmPVjUdQE
	 agksJJIJD20rXBVLsu6bfpytqPuqnUfdQ2hb4hEfkAnWdEaFQFwCoYtHR9n3bgs+Yc
	 r25DSgMx/O8qPpkYiiZi5fJx+fKNYbi7KObXWGgRUFS1J5MGB+w6PYg9+NW3V6fGmE
	 AbR+hUXNFMacQ==
Message-ID: <534dfba8-6222-4eea-aeb8-440d47c67f5b@kernel.org>
Date: Mon, 17 Nov 2025 14:03:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] x86/mm: support memory-failure on 32-bits with
 SPARSEMEM
To: Xie Yuanbin <xieyuanbin1@huawei.com>, dave.hansen@intel.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, liaohua4@huawei.com,
 lilinjie8@huawei.com, linmiaohe@huawei.com, linux-edac@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, luto@kernel.org, mhocko@suse.com,
 mingo@redhat.com, nao.horiguchi@gmail.com, peterz@infradead.org,
 rppt@kernel.org, surenb@google.com, tglx@linutronix.de, tony.luck@intel.com,
 vbabka@suse.cz, will@kernel.org, x86@kernel.org
References: <20251105090536.11676-1-xieyuanbin1@huawei.com>
 <20251117020956.7071-1-xieyuanbin1@huawei.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251117020956.7071-1-xieyuanbin1@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 142B420005
X-Stat-Signature: 9tgukpqrnzyek8xea8q8exgu9978ctso
X-Rspam-User: 
X-HE-Tag: 1763384634-992212
X-HE-Meta: U2FsdGVkX18//dmwrouB8P9yLt9LURdWwDVqtFc42BvUKn/Wl2qKiA8AHvuHtjEsMVNG6/t9u2dlmWdHr0h2x3O55+NZxHREygJJnzwjncJyBunnZD8Is+SIxEv8lfz/R3YT8Xn4HkXbi4AGIeWoCuc8gV80IJlGMY4Q3m8T0uJ+0rA962qsCbGrF5CAVJa5LjAoJnaXCDzKECgti/126k3U/rEawTyyKZ0nXllHLjKdoW3fmmOgXeV30bUAfCiclI8zhwP+ByXBs9w8wsKG1GkWoKlN4xCQCVxFipYXYAxxBOFzq/OznNXxA2ZMf9RkqcSmT+a9pX+cltTi+sRuADm82fqWmD439rl2AIDNOFDOTOazCq3E1BJXdDJmH0xvkOxwTWQ5SBG8YRyvM4EluCSr+5tb1SElkbK/mvDIP3wo+2wpt3u5K+FtVOQna2q/BtxuzgCCFNEfCU4dFB4Wiigo3E8T39mKDzagnZLjCzG9t7JCERkWwIriE9G0XVc0P/Ex0/drMjCSRfJvjZyUbbOUQRMTXtJphnwlm0TyFD2HiIvewgv03kBUV1lPI4v+MR0S9G86DwLUEjdQ6Dhn9DEvAS8u/CFQJYkEcTomqh4FNtr29ke7Odcb3lSAmVkx1eT+hoRXobNojLirYHLbJoEnww6ehz/DaePdy8jfdE5jmKrb+ZnxDDcAVjKVwSLflCE7cgwh/6JOX6RGGcCTKmVMbGHc9afEG8h9b/bChOjiUNIiJuf+IUAiDuGRv4PJsUBS5kfGxxAT0rcU4GVlkNMF5O1Tet6GIGucl7ABCpldrF1WdPQUKL+J+w2e3BHxCAzQRz6slzA53FsttS7aItCg4wNxhOavhaGj3hJ2EXUBnwHk6yi0ca/Lz7wUD6NNxRYlxw8mUZFXb+SIWD/gcbqBbswK7BMTstW2MhRyL3w9GuhERZ7wrZAvG0uyFSkWHvX/LENBsEi05uVq8yh
 W9JCSf39
 tBIqK3AB+Uaq6RH0301at6P8uzsYkZ2m+cGPc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.11.25 03:09, Xie Yuanbin wrote:
> On Wed, 5 Nov 2025 17:05:36 +0800, Xie Yuanbin wrote:
>> On Wed, 5 Nov 2025 09:12:04 +0100, Dave Hansen wrote:
>>> Let me clarify what we need to know:
>>>
>>> Will you (or your employer) be running such updated 32bit kernels on
>>> hardware that supports MCEs.
>>>
>>> In other words: is this change driver by *real demand*
>>
>> Thanks! Asking like this, I completely understand now.
>>
>> We won't directly upgrade the kernel to 6.18.x (or later versions) to use
>> this feature, but if Linux community approves these patches, we will
>> backport it to 5.10.x and use it. I know that the page-flags in 5.10.x
>> have been exhausted, but we can work around them by adjusting
>> SECTION_SIZE_BITS/MAX_PHYSMEM_BITS to free up a page flag.
>> Another patch I submitted for arm32:
>> Link: https://lore.kernel.org/20250922021453.3939-1-xieyuanbin1@huawei.com
>> , follows the same logic.
>>
>> Currently, there is a clear demand for ARM32, while the demand for x86 is
>> still under discussion.
>>
>>> or just by "oh
>>> look, we can enable that now, I can come up with a theoretical use case
>>> but I don't know if anybody would actually care"?
>>
>> It can also be said that way. In fact, when developing the demand
>> "support MEMORY_FAILURE for 32-bit OS" in version 5.10.x, I found that the
>> latest version already supported this feature, so I submitted these
>> patches, and hope others can benefit from it as well.
> 
> Hello, David Hildenbrand and Dave Hansen!
> 
> Do you have any other comments on this patch? If you think that
> supporting memory-failure on x86_32 is meaningless, I will only submit
> patch 2 in the v3 patches.

I'd say, if nobody will really make use of that right now (customer 
request etc), just leave x86 alone for now.

-- 
Cheers

David

