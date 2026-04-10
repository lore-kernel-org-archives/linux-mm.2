Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48882F36BA9
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 04:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A971D6B0005; Fri, 10 Apr 2026 00:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A47B36B0089; Fri, 10 Apr 2026 00:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 936766B008A; Fri, 10 Apr 2026 00:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 83EED6B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 00:05:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1BF08E02A0
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:05:35 +0000 (UTC)
X-FDA: 84641307030.30.F805CEF
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5A96B180003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 04:05:33 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EjrrBxhN;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775793933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lQDW5xqJ5IwYwi5+zyJntrBe02BOIbYzeFaYDOjGuzs=;
	b=mkJFUXg6BygYm/Zr9a39lsAj2BKh7eo7aKbtuMAmLXBizLYGNyuysOnsgJc/izWe2t98xx
	BQVg5aYPxCoykQ3b5WdaxN++fWDS8e2Fa8VNITBL5W2Vz/yfIqjrVXC1Ty++3zSsVYvVfK
	yvXClsSYW67JMDUYcaQfxwD03PUNup0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775793933; a=rsa-sha256;
	cv=none;
	b=BY3H7yvBUGjkqGwnyEwIgrT/kjGfi8MT5dKyyXuGfIZbM9oR7KTLHjKavKp+Mu+qZEHbvQ
	FevU7xpsXvPu/vKJiQTFTGEEGYqZc0/z1YKlqk5dwS7BjHfWvu0XxZinkVmXK6eaBMrxvr
	H3P1XfPYFLsjn81uW1pqIm1+R3GXQFI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=EjrrBxhN;
	spf=pass (imf16.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 895F01D13;
	Thu,  9 Apr 2026 21:05:26 -0700 (PDT)
Received: from [10.163.181.174] (unknown [10.163.181.174])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6C3FD3FAF5;
	Thu,  9 Apr 2026 21:05:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775793932; bh=SjXrSZIRMlWw97Vew6gKz6aH0jyeVoWF6t4/svTR9bY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EjrrBxhN665F8irlIMDsY0dG93Jgc6VH7vWs/gyaNgmOyb5HuyJOdMdEZIIKcE+PR
	 ijF67rpbvOYU1x33AOs7xnIc7mP5eomADBOnauQeabGXX3ZSFgc8o3XaRvU1vYzt/r
	 HCar42SpfCitlvPMFKSVjb57S4OR3WD3UAvD2G80=
Message-ID: <e4a36f3d-abc3-411d-9fe9-93b6cdf7465c@arm.com>
Date: Fri, 10 Apr 2026 09:35:25 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC V1 12/16] arm64/mm: Abstract printing of pxd_val()
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-arm-kernel@lists.infradead.org
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Linu Cherian <linu.cherian@arm.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20260224051153.3150613-1-anshuman.khandual@arm.com>
 <20260224051153.3150613-13-anshuman.khandual@arm.com>
 <4290fcdb-47d1-4f74-97f3-51ac581efeaf@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <4290fcdb-47d1-4f74-97f3-51ac581efeaf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Stat-Signature: k5o1mj4aht5xb8y8mdi45nsioubjrmox
X-Rspamd-Queue-Id: 5A96B180003
X-Rspam-User: 
X-HE-Tag: 1775793933-826834
X-HE-Meta: U2FsdGVkX18AEPH4aH+cnDBF0ntqtEybBpROqBgUPbH3JyI7DKFVpnPAKCnssZ1Hi/WjL/6h/GWPdfdWKNKFkkQ+7Up0Ja2emNj3adftS6567gxf+hmck2wCnVhl5mPojJ1F/uHSGKIoqlhkaTSMd1S5bGLGXGl9llWXGMKMDdEPxi8XTEK3T8h4dem5YRMXz2wIIKMsSR+RLyEmQYxb/8uIhYJmaCW/5za5kyurRX6a7Bbhz6eNBnL87qNpsm1mS8f1Kfw03l88GVkTvHsOof4e4dgpcbL5GCnqZn7ciyCsSUOsrrccUgW+QJCuqeaAGQIHFOiglPsuk0sLCltPtaqjSk7cRVRlEyRJfLQdTw5esT9RgXNyHimeM9fo5XMiPSVmtMULlPFlChZU63BqVXKiwQUXJGT4vRQk9dniw5EL7oHcxOi3JkwpdmbUd3Z+o1i1LQbrHgVF+sTWtYkAMv1ucdQqGHcFvAjhfFnnNdRKOMt/gfBLjE9pIIGYv8ohEfotkWWSWOyl5V3J73E8OaErWxkH0b4cASv/XbOuxaAWgMOtR54eJPARMvnjPMZwcdoc2VxE+axVj9oH0Bnx53wbAVWw0RfLziUmbdfWfU/bu+zneQCxU4Ht4Kbcn4KBP9Zu/H0+NzNGd75dMfSpR+58vgBmyN4fIe//F5ngpoUdmU02AmP2UR9KY4v+N5fgXkf9ARbJg1A56AHKxnJmjVBqdRhSG22hUCMpf6Am/zjrP5DJdidzeu/LgXIwEGaRDKWcUnqowEyYDzdf6L96u1KHyPiBhoW7UUYkho0uENspHNtr7+AHs2lTrz+RfUZ2jgI266mImJwu/WMXs+avmOyHh6bze6urivsm7/ZKfzDcwv6anlyNz3x9a0mwO9IMrU/w2cK6Ryr4QCauP28z+fj5ooHEV+ZZoKKeVU9KNgoFQz92n278mcI0PSxqAomlwEOkfSpKTua0vfwT33C
 il2oE0pA
 jY8w7aJIT0km7PvNnnpvXnB3NCO5fpoi4EW0mHMi5J9qJPh83LpwPSfVUGOTIuzE2PHLsYivQOaN3ZHO7O6lApkBODBmzcATP99S6wz+YMY1q/cxN/0rHrpijJrBo66iIRdmj8qP9eVMfig2owrlT3BuWpkdSR8qwlxdKNJrDIuOxNF+Ufr/ZCnnVrUtSe2uUguWXgQow5HFMFoqFYTy+vug4Gt+aLyjDvjKQdt2KMobAFF1VzgVolRexJcW8gwVqAiJSgaVqy+ysCSuTHfRhw8sbJf1AKrDUmVrLlloXwS8G2uUq1A7cbsgeITCSd7wUaJM4ULj96LErJwOm3dzgDkcAR/9pCj1p2d+VAE7//tmx87oNP1Eq5olY6RnD9LkZl3nOFiTauSvHxI4Ou7lvW3VWOzRPvc3DrPSmDj4G4TD5N1U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/26 5:58 PM, David Hildenbrand (Arm) wrote:
> On 2/24/26 06:11, Anshuman Khandual wrote:
> 
> Subject: you probably mean "pxx_val()" ?

Yes - sounds better will change.

> 
>> Ahead of adding support for D128 pgtables, refactor places that print
>> PTE values to use the new __PRIpte format specifier and __PRIpte_args()
>> macro to prepare the argument(s). When using D128 pgtables in future,
>> we can simply redefine __PRIpte and __PTIpte_args().
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/pgtable-types.h |  3 +++
>>  arch/arm64/include/asm/pgtable.h       | 22 +++++++++++-----------
>>  arch/arm64/mm/fault.c                  | 10 +++++-----
>>  3 files changed, 19 insertions(+), 16 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable-types.h b/arch/arm64/include/asm/pgtable-types.h
>> index 265e8301d7ba..dc3791dc9f14 100644
>> --- a/arch/arm64/include/asm/pgtable-types.h
>> +++ b/arch/arm64/include/asm/pgtable-types.h
>> @@ -11,6 +11,9 @@
>>  
>>  #include <asm/types.h>
>>  
>> +#define __PRIpte		"016llx"
>> +#define __PRIpte_args(val)	((u64)val)
> 
> Same comment regarding "pte" being misleading.

Sure - will rename __PRIpte as PRIpxx instead.

> 
> 


