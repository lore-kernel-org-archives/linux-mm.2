Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4537CA1016
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 15:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C7398E001D; Mon,  8 Sep 2025 11:25:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49E5D8E0001; Mon,  8 Sep 2025 11:25:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB308E001D; Mon,  8 Sep 2025 11:25:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B72A8E0001
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 11:25:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C30AF1DBA9D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:25:37 +0000 (UTC)
X-FDA: 83866457514.08.4A64F6B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id F147618000D
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 15:25:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757345136;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T8zaQx18vqAAVaqHky442ptbdchvJx4GvBOWo1UiFbw=;
	b=yVj35X8DHD0KBre7m+Tx5j68xwEGB6OafBUFMkDDPgCcGJ4wqp/ud2s1nzPsgRmj8umWWX
	fBW9sPBr1YylqMwVAhfwfomkwR2extgy8qn8Szt9s6Nk8lBWRHLcB4L7K1dSO8korRaYkX
	/SSH1Z8ZBED8pXxEmGh6cAeQkwT3174=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757345136; a=rsa-sha256;
	cv=none;
	b=7+w9HSLwZ69+7MlajKtE9af3Og3CE+s5nOVnZgE9L9B85ghTOmm0/V8kKS4BfVr/l9b/8c
	7sAJsMXaKirl0rqFKGLfWJ2tUnEU9nA0GNkwHmnQw2+AQOfuQTkJrhnGAZ/htLkyKQJ+sK
	UpFf1utv8aOQykwQ0iexEDQtXynF51Q=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 623132C46;
	Mon,  8 Sep 2025 08:25:24 -0700 (PDT)
Received: from [10.57.91.39] (unknown [10.57.91.39])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 57CEF3F63F;
	Mon,  8 Sep 2025 08:25:30 -0700 (PDT)
Message-ID: <11f84d00-8c76-402d-bbad-014a3542992f@arm.com>
Date: Mon, 8 Sep 2025 16:25:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/6] arm64: mm: split linear mapping if BBML2
 unsupported on secondary CPUs
Content-Language: en-GB
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Yang Shi <yang@os.amperecomputing.com>, Ard Biesheuvel <ardb@kernel.org>,
 Dev Jain <dev.jain@arm.com>, scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250829115250.2395585-1-ryan.roberts@arm.com>
 <20250829115250.2395585-6-ryan.roberts@arm.com> <aLnFd1Hl_FSHZR3z@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aLnFd1Hl_FSHZR3z@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: F147618000D
X-Rspamd-Server: rspam05
X-Stat-Signature: 4qdpousgirubo98ow1cer6nuryb7ff1g
X-Rspam-User: 
X-HE-Tag: 1757345133-111074
X-HE-Meta: U2FsdGVkX18xUyTCyEoK08qEg4cQghH5Jjyo2N9Z6rNZQV8BLxdWAMWpzOXdtYMWVXNz03lChpszrp246kwoHSnoNa3YH0QgEdXY9UNvrpi70UuuXvKhQ+Im4hBJNPfH5mkNW8ipjU9UBReS+fwqhrpY/Yot4wEZF+hjJkP1wmusfO1uqF3PkozKX1e4E5FRb6q5MC/kjRds+Tmhy3r0B+msLxb7mtLZ5Z5jlCf3nidfC0MQQ43ksueIqSbcyA5p+RxO87xokAuy70ikqobSkdLLgd3d7obhYOVdAgDIRi9Q9kykAvSaAte4cESV43jGv8Pny0MMNYXHEjK74oq2zQG1rxVvTb1a7pSpT6GaUZ4DpUQdLOtsTrrJlNtOpGAORpKxPGs/NlKMdHsHsuf8HGk4IFDTIBPQvck1JguCiP6dHFvQUaMyh8B9hgfcIb9PX8G54qGPg94/enHX/w5Q5xP1xfwTSvc+rHWB0Asn3SR4fSxveURpWnLyVQOjrRYeXSWPSmkQsOA9JBU3oOYLnkho3vpolF/3Bh1xhqTRqemXWlEDFgEwGWcBB5eFj6UoNREB6U0fWOwuYIa5o+FNy8rUjuR6DNpq4QZkPTgXcI1ylRCAyAuZvJDu93a/ZBUpMCTB8xlGFmRQYwcrMsxcV2DYLmVBBwtiqEuDgt6ZNYUv+uRag68JrvOQNXNioD9+9LscO3q87yOne9RSe3SrDvujds9oQmLO7XcDVRezKFj+iO4I2eNBZ3Vr78rOKX7Af9R+VfU5F9nFrimnOxUwKySIml4UIFCTgiSZCurt+K2TDGwI2huODd700WwbL0ptBTgEH8JQ93NZVLNlXIfETXQAY5Cb+wZoPz3ViKb5xqK7DGU94HQOxV0eEBXcsXURHi+IbHFmcj4NrRFU22JOG9puL/sU5tnTKNDRkKhwpYMeU1Szuw2MfBraoiI7HDg4OMBZc2iLjwiykSiZS1N
 c3E5PZyy
 nIrKWf880UVtskPnIfrcuqULVF1af7Z5S1XCgT+h2pgRBgQjHPgMLXChGrtT+o3jhT9q77Y7W2yfr0WOle4DVAgO2IMvtYMisTMX0wva3kAV2D0M2EA+3C4Up0iSdt7G8nY5ldtv87bduqdI1jcUo3VL9uK2357RTlFNT5dtOg4gImA1pAGIhgI9AWQSkeRuu7lybXwtFMkPCVu3FuoBZJIJD5EFV6v9dzgSZmS31NA13sXMN1uNoV6PAEsdABi6W8BFprrD3ot2hlfAOVUEki/G/Kfl+7bWpALMC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/09/2025 17:59, Catalin Marinas wrote:
> On Fri, Aug 29, 2025 at 12:52:46PM +0100, Ryan Roberts wrote:
>> The kernel linear mapping is painted in very early stage of system boot.
>> The cpufeature has not been finalized yet at this point. So the linear
>> mapping is determined by the capability of boot CPU only. If the boot
>> CPU supports BBML2, large block mappings will be used for linear
>> mapping.
>>
>> But the secondary CPUs may not support BBML2, so repaint the linear
>> mapping if large block mapping is used and the secondary CPUs don't
>> support BBML2 once cpufeature is finalized on all CPUs.
>>
>> If the boot CPU doesn't support BBML2 or the secondary CPUs have the
>> same BBML2 capability with the boot CPU, repainting the linear mapping
>> is not needed.
>>
>> Repainting is implemented by the boot CPU, which we know supports BBML2,
>> so it is safe for the live mapping size to change for this CPU. The
>> linear map region is walked using the pagewalk API and any discovered
>> large leaf mappings are split to pte mappings using the existing helper
>> functions. Since the repainting is performed inside of a stop_machine(),
>> we must use GFP_ATOMIC to allocate the extra intermediate pgtables. But
>> since we are still early in boot, it is expected that there is plenty of
>> memory available so we will never need to sleep for reclaim, and so
>> GFP_ATOMIC is acceptable here.
>>
>> The secondary CPUs are all put into a waiting area with the idmap in
>> TTBR0 and reserved map in TTBR1 while this is performed since they
>> cannot be allowed to observe any size changes on the live mappings. Some
>> of this infrastructure is reused from the kpti case. Specifically we
>> share the same flag (was __idmap_kpti_flag, now idmap_kpti_bbml2_flag)
>> since it means we don't have to reserve any extra pgtable memory to
>> idmap the extra flag.
>>
>> Co-developed-by: Yang Shi <yang@os.amperecomputing.com>
>> Signed-off-by: Yang Shi <yang@os.amperecomputing.com>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
> 
> I think this works, so:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>

Thanks!

> 
> However, I wonder how likely we are to find this combination in the
> field to be worth carrying this code upstream. With kpti, we were aware
> of platforms requiring it but is this also the case for BBM? If not, I'd
> keep the patch out until we get a concrete example.

Cortex-X4 supports BBML2_NOABORT (and is in the allow list). According to
Wikipedia [1], X4 is in:

 - Google Tensor G4 [2]
 - MediaTek Dimensity 9300/9300+ [3]
 - Qualcomm Snapdragon 8 Gen 3 [4]

And in each of those SoCs, the X4s are paired with A720 and A520 cores.

To my knowledge, neither A720 nor A520 support BBML2_NOABORT. Certainly they are
not currently in the allow list. So on that basis, I think the require the
fallback path, assuming these platforms use one of the X4 cores as the boot CPU.

[1] https://en.wikipedia.org/wiki/ARM_Cortex-X4
[2] https://en.wikipedia.org/wiki/Google_Tensor
[3] https://en.wikipedia.org/wiki/List_of_MediaTek_systems_on_chips
[4] https://en.wikipedia.org/wiki/List_of_Qualcomm_Snapdragon_systems_on_chips

Thanks,
Ryan


