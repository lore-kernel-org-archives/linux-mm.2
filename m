Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95990C982D8
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 14:00:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29FAE6B0093; Fri, 18 Sep 2026 09:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F126B0099; Fri, 18 Sep 2026 09:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F676B009D; Fri, 18 Sep 2026 09:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AB2D56B0093
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 09:59:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6347F1A0672
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:59:57 +0000 (UTC)
X-FDA: 85227041634.21.D141E8A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 93FAD2000A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 13:59:55 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0c7Y5oB;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789739995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ql4h3PEpCH97QLxzKmGsLy1Pw0p7ejqCRrfChbDXmb0=;
	b=hLDK+m0casAVmgX35YzD+cgDwq4ajeDpGqa2uLBvvk6HDtpT+4zSMCvTmbBwIVTfLzN2+S
	YyRRcKivfaB+TjJc0WackDGnR1Emb9U4tr3NndFfQVu8/n5nMg5JqrMZrCHz4HZprR2Z03
	N+QPKGwI9OXdejz+KggT07Vq1y3wNE4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k0c7Y5oB;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789739995;
	b=f16XG+UOQoB2VipjAnCJfSpgDElRowjfo4MQSyYTLr+G5DzgQF1/i9D2mB6h6GDirgKnoF
	vrUfa4nK7sAJvv7PGrTDQhy/j3sGBz2AbMBCYP4CeB/2Eufuybtm0k6Yea0eWPCalkZepI
	g04sB4SC+qzq947cCVzG9t3SfntGED8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C369941B01;
	Fri, 18 Sep 2026 13:59:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7861F00898;
	Fri, 18 Sep 2026 13:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789739994;
	bh=ql4h3PEpCH97QLxzKmGsLy1Pw0p7ejqCRrfChbDXmb0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=k0c7Y5oB7pdEPndHGOltPARlBz2zL8Frb8nHWDaLzFB3ZCtLzImQOcO9EMc29l8qj
	 oj8aAavCc+qpeDE/F0yXnmu5iseQqKQPJ3WPc/ZW76rcF5p9w0Y3lOxj+UlNZ/XJZf
	 zdjJZXBpsHLv4l6iK1SC+MRSWotYv59D/LgCcljylTbQ0r+tT6ABKW6payUhGnUdIo
	 QfgAmg19DXQOlXtCzrx0M+xcCSoaks2YAt+OYedsE54NGkFLaCt98We2nURAwwOQUd
	 AkY48NHNMmsDVl9vWSX3VUy8afhOxdMAkO68reCJkZJbPXPb1S0cgOKvM0a9lgSvwU
	 P4kUjcp1y0HJQ==
Message-ID: <c445a20c-ae83-4571-ae97-031ce7facc45@kernel.org>
Date: Fri, 18 Sep 2026 15:59:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 3/4] sched/numa: scan read-only file mappings in
 tiering mode
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com,
 vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org,
 bsegall@google.com, mgorman@suse.de, vschneid@redhat.com,
 kprateek.nayak@amd.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, usama.arif@linux.dev,
 kas@kernel.org, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
 apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, osalvador@suse.de,
 hannes@cmpxchg.org, raghavendra.kt@amd.com, stable@vger.kernel.org
References: <20260911001826.2109390-1-gourry@gourry.net>
 <20260911001826.2109390-4-gourry@gourry.net>
 <0ed3ab3a-80b4-492f-867a-0584441722a9@kernel.org>
 <aq1Cwh9hNw4wWEUP@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aq1Cwh9hNw4wWEUP@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: de9obnwtaz6jdabhjohc4u8ws8cp5hah
X-Rspamd-Queue-Id: 93FAD2000A
X-Rspamd-Server: rspam07
X-HE-Tag: 1789739995-842859
X-HE-Meta: U2FsdGVkX18xdCXF7Wl+LZMLv0cZWtmHcWIULXAC/T+/OR1Zor+hzZYfg0TzpDD23A0rGapnVE9oZ66IkR3pu1imOxZ14l1aYgq0u9Jcgg0wVkRr8rGy3YnsO1soYjM6LXMcZLFYtuWoTgD+PNNaFHHHW6Cdq4k2XYyHER8GcJ/HFlYVKHfl82u4/Z8YfSZDudjVHOTfrvSEqUHHxAjwhGnvpfXYAGohBEv439FQjmSEIs7+3Od8vmBC8hSW1I8w3pPgGsJr/O0497gEXQJ8P0sFsVtPbfz92rDvIzR5TESLKSSqtpTJH9/Y9h1YYlSHBDUYAWzTFdOstXNKhucr/BBPXtJSfBNo0sib56LiQtVysIm2WcW0kVLD/6ZPeoWUwgWPz2FAwfyQ//XJRy3VSmzc4u7f5+upmdk6U4sy1CGhvF5ItK8mZIgd14euQNkSpXsu9FmWOkRT5WDuS/NOm5smDLX0frLLXBPnaQSpqfMavlJArN/rw35NKx1RDSE22EOvhz+OuzOA5kch38mW5Vo6meKqtp4vvmXemFMOvDUq7du6lm2+vk6LsL+PGPaU+dHC4Nbax5lMA0B2JFcQgOg8IMkTDjOphJ1iiAr6Vjl38CEHY8mGRM0Oh+xkNU/wH2+/vNtRMeQEUkr2EWwNtjf/xqDojh+3pI2bpfKh5EuL4tO1gu9clPVm99Geq/EVCKEOrgrzDehYeXGj9WGAxO93hjjjU7P+affAygSpcACoMNR+PoVJBb3l9489q0DG/mdRQ3JUNLsUMjaFCROaH6tpFHDUp6qyAQfExf1RShmRE5momMOtLeKjba1rDU9015x8GaNFa2N8aPzWzDt92idv6/aFJzX8zqQN8LjZQzZUysP9EVYbCraH83sdrOrjgz5kQM5d3vUhPQmS9IdHOWD/k9rGpHD6dVevqFGBKlJbuypnGD5nxbBfqiRGh1AGougJb1cmlMUWHAYaxxH
 nMnSpqhO
 i7SCq0Mg87VU2knDt+WjPH/B912Uvszi4G+Ho9FIoKnn+7O8zjTUzjp0kG9F1M/YKczncHRPy1IvDpz9SYnvk/4vDtiIjRAFIN63V/rX65YiEgu62iD2lX7gutEWAWMr4Q109jr6e8lCqulOu0IozvrKyRJ0/fOHd45bvxYk1D9nHhFHvbrAhupX0acmPTMUgVBehWODvb4zsvJ3+aWUlLbXOIrk0CbVTl/JdJmqbGPhWYDTBAaaztQq825WE0QC/YtsbO3nQ6EMuxd84hkx0wWiPL0iyGLCANkinA+N3hPnIFV7/p6wW8bbsxIqt+oMiNMmJ98iAv2lkrSxh+aVMGdoN7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/18/26 15:57, Gregory Price wrote:
> On Fri, Sep 18, 2026 at 02:58:36PM +0200, David Hildenbrand (Arm) wrote:
>>> +/*
>>> + * Read-only file-backed mappings are expected to be cache replicated between
>>> + * accessor nodes, so they are not worth sampling for placement.  They can
>>> + * still strand on the slow tier like anything else.
>>> + */
>>> +static bool vma_is_ro_file(struct vm_area_struct *vma)
>>> +{
>>> +	return vma->vm_file && (vma->vm_flags & (VM_READ | VM_WRITE)) == VM_READ;
>>
>>
>> MAP_PRIVATE can easily map a read-only file with write permissions. So the
>> function name is a bit misleading.
>>
>> This smells like a helper that should go next to other vma helpers and have
>> clear semantics.
>>
> 
> No argument here.  Would like to balance improvement vs backportable
> bugfix though.  I broke out the name to try to make it at least a bit
> more readable.

I understand, but I am not asking about much.

Maybe Lorenzo can help us out.

/me summons Lorenzo

-- 
Cheers,

David

