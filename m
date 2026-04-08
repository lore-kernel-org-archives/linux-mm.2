Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE97D1073C98
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:58:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329966B0088; Wed,  8 Apr 2026 06:58:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DA586B0089; Wed,  8 Apr 2026 06:58:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EFEC6B0092; Wed,  8 Apr 2026 06:58:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA236B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:58:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AB94AE2AFE
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:58:57 +0000 (UTC)
X-FDA: 84635091114.30.C982A45
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id B2B6A120008
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:58:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZSPo+kwj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775645936;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u7yhuYhKrxuWpvDbkhQpLo877mxIOEVojE40xbHqSk8=;
	b=ebNdhcEkN/aD4tbsLFlzm5IIEJjzbezEVdApwAqHl2mhOUCrH+weEsyQUOvdmk+WgbF/ew
	SSlgA5GQU3RBMlqbtm9Ydkue4GV9Ek6Hvzv8vKbA8qRItKFCKvrdKdAwHHj8FZB1r2CvsP
	cKr0I+3BRGOTfjFGHa7im9lEynt7EWU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775645936; a=rsa-sha256;
	cv=none;
	b=trt30blQsVPgqch8jQsUf413MoSP4ZL8VQ8kT7/Gb7Y/kK+cRUle+vxcHOBl8HmWTHGPIw
	aRRtbZEz2g+VLbBl1G71ryL4UaGEMBan6kwAnQxURVokf8j1v2i9ml3Z7Kqt9MmOFn9zdd
	BbSwH12HRh1QFjP5I0t3M/jDzYqnFbo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=ZSPo+kwj;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0A7303161;
	Wed,  8 Apr 2026 03:58:49 -0700 (PDT)
Received: from [10.163.180.198] (unknown [10.163.180.198])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F23E23F632;
	Wed,  8 Apr 2026 03:58:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775645934; bh=rvCB0mtFCTChcch/FM64LYIf0vr0IZ0WwJBCN05cnQg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZSPo+kwjikI+iRW4adeq1Vx/UxwAGFrfNhig45c90krMMeJUQpomGNau9pTkioJg3
	 mzGBxrK+v+q1P5KG9fHhUFQbVCAaYZnRtbR6gS4JFEchs1JRDpB3ykj9MtEMsAjDi7
	 VnrqcD848OeDpenFRsURVEewmf1UU4/17K4SfAjM=
Message-ID: <bcf784d9-5350-4b43-a827-a1cead862cad@arm.com>
Date: Wed, 8 Apr 2026 16:28:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
To: Peter Zijlstra <peterz@infradead.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Ingo Molnar <mingo@redhat.com>, Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
 <1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
 <c7688962-d10c-49e1-a434-ab7ae2c64cdb@kernel.org>
 <20260407071820.GA3738010@noisy.programming.kicks-ass.net>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20260407071820.GA3738010@noisy.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: B2B6A120008
X-Stat-Signature: m5i953ibn17fcjw3rgwk6b96y4jz6mao
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775645935-194570
X-HE-Meta: U2FsdGVkX196vJ5YhcQEldj1YUomZEnaKpp2Rwvj9eM/4l/2xShqOVSQAlKtKZx++FLzD9kDXVt4EdnL0TtVVPbDNeod4kjLRjZdVeW2Dp+P+kBlqN2dhZS6Zee8ToRyITciLnoUjcx4ox0r4jZcssEx7m7i3+dbT57ZD3IxC+xopsYfUwfw41wH9TAmZM34uQnLkOX6vP1CotXB6qYKPc4SuFdyuK0yTFCIlJ73brXdrP7OfqfY022uEVXV12fEy5DUr8zD+976Eg/ITnkeSqpBRr1IBe8ZHQwkp4EN11HsTIClgN2HHtC6VtEywCAwqJU/xPuuajMXxmVn2ELr/0+BnyiObg5BLTKw7zB1vRgTYB6RA+rQw9o/frkTuSDE6BcCZFDobNhK6hGpuLiZxyXr7BrO8q+j5WZ1aUWc2hy4wf/PyU7mrMSON9nrQ/C8dz69Hh1+oOfm1omBjbDOzjCr9fyx+H0v0gGGISzoR9nIAvktZ7aBMEl0hk5wuH8K+Yth3whzjQvpwAJOzyVPIAjkdJTpYsiWf20JzE+Swwo9CFB8tvtGlP4+OAn74WpewEfrajO58RDAEHJTLkuWRx+OQCESnGYpe9evqZicg1ly8K5qx33vkOmkpTyyGs1QxmFWToLGsNJu9N7jl1FqHal6Gj6uuSSLhx2p9kVJzNQjYgSKkBap14MM8wSJjbjlfKerrwZQoj3SReTbGCpJJlptMdO0LqhKUNsLiApJn3noMtsS9CNgUfDd9vBJcil1XvkgU5MdGBe6Gdez6sQXKW8f4IID/qca7sD5p/ljvoQoMLrxc+Z2eJFYzC/rI2zfPa52Ia3V5CSK3hROIRCjmWG6bcrMOE8bKlp6LBLwUpM2L0JOg+M+GmZpvFjiC0virw7WFiZDLQHGM0wp6W6isjnGoe+o6Ie4crvsLKQnK2Ev18GeP2WS9i9KlyaAWGvkqhxuK1suaFrybq+2/7Z
 jPibWXkh
 zSutngeSrcCE3o0kPZxgAlUd44Uxm11PgPNVsur7f4B7LmdOk4j5SpDJkYv6ujiSBXIrZPVqoEud9gZLxC92drv5IsjfMwerWAPh5GgpbM8rhLRDNO/UzgyjFvg279FGpVzNjReBKVOBvrKr9PhQzNLZyKRpdnKw2DD8EgRGTtKCy5YXfvaeAiwVUx6BO6/ObHtPRSZFbLM++Z1S+9RWeiWRjhellY2tQ+oFm/24r16TvH61n8acwAY/3A11QaM2Wt/1wJSyL3joivGee6KFUrQtu6j8EqfN23eSPVUCR0bh0EMF4h68kVYt7DP3+KcR3eYiYGzRLDitG/uSe4JjhyfproPT4JQXkqXKfe1AlritCt/Ck508AwNIAXGUGAvAKvWa+Ag95wLyVnIMvjtiGPN8wAgkOgluVPZiZVhCs1kEb01sksVNl/UybGvZzWgCHsrdMIEktHyhl+yEzTPqag/aKTZHqJPX2A8PMDWQRAuFEXq9SN8jJGqQu32fnL/TmZXON7Jao77CVjG0JCUQDTWSW0fJJfp42ExMjYt+ebOCcoNZBy07ce4mnBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 07/04/26 12:48 PM, Peter Zijlstra wrote:
> On Tue, Apr 07, 2026 at 08:48:22AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/7/26 05:28, Anshuman Khandual wrote:
>>>
>>>
>>> On 27/02/26 11:57 AM, Anshuman Khandual wrote:
>>>> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
>>>> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
>>>> accessors default to READ_ONCE() on platforms that don't override them. So
>>>> there is no functional change on such platforms.
>>>>
>>>> However arm64 platform is being extended to support 128 bit page tables via
>>>> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
>>>> provide required single copy atomic access for 128 bit page table entries.
>>>> Although pxdp_get() accessors can later be overridden on arm64 platform to
>>>> extend required single copy atomicity support on 128 bit entries.
>>>>
>>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>>> Cc: David Hildenbrand <david@kernel.org>
>>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>>> Cc: Ingo Molnar <mingo@redhat.com>
>>>> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>>>> Cc: Namhyung Kim <namhyung@kernel.org>
>>>> Cc: linux-perf-users@vger.kernel.org
>>>> Cc: linux-mm@kvack.org
>>>> Cc: linux-kernel@vger.kernel.org
>>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>>> ---
>>>> This patch applies both on v7.0-rc1 and mm-unstable.
>>>>
>>>> Part of the D128 series but independent. Hence could be considered on its own.
>>>>
>>>> https://lore.kernel.org/all/20260224051153.3150613-5-anshuman.khandual@arm.com/
>>>>
>>>> Collected Peter's tag from an off list conversation.
>>>
>>> Gentle ping. 
>>>
>>> Still don't see this patch in latest next-20260406. Hence just
>>> wondering which tree and branch this patch is being picked up ?
>>
>> It's a trivial change and the last generic code change required for you
>> arm64 D128 change, right?
>>
>> I would assume this to go through the tip tree, but if Peter agrees we
>> could route this (mm) patch through the MM tree.
> 
> Right, I thought this was part of a larger series and figured it would
> ride along with whatever other patches.
> 
> If you still want me to pick this up, I can, just state clearly where
> this ought to go.

It would be great if you could pick this up. Thanks !


