Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75533F8FA79
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:39:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56B06B0089; Tue, 21 Apr 2026 09:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A10E56B008C; Tue, 21 Apr 2026 09:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F62E6B0092; Tue, 21 Apr 2026 09:39:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D66B6B0089
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:39:37 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CC4A3C3FFF
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:39:36 +0000 (UTC)
X-FDA: 84682670352.13.7D3FAFA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 16B131C0004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:39:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpHohVth;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776778775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lEwkpSeJAnZOjyGRSxCkI5UhJB5flz/uxgpdoEj2w68=;
	b=MpOBhPn/F7Wt9eMl724pu6JNP4bzUGU+Aak2CJCS+q1QAAfv8zkPvbZxRsX226dCGd813Q
	DsaEzSEwbt9+rDs52JXub08dsbWIyKgu442jS1SLFojDce9sh99JjEP/1m12KSbP3JyRh/
	E1iqAqHXbJRVShZKGFO16nw2gD/9WAU=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SpHohVth;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776778775; a=rsa-sha256;
	cv=none;
	b=s5LvrtoURTsxm8wW5kELM7I1SXSo6GnlDtv2VUvvruuVsMGrrDTPDS4HR7eTsBbKfr1CF4
	ZzrdPt6+9v54HqHZM+yKsYbGSaEHjKjAb0aRL8G0LXaUbJgCNhsMvtLAfBa0aRX//FnRGK
	KpmnyiGLMol7GYbySUQRP6YnTDpyM9s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3E36C600AE;
	Tue, 21 Apr 2026 13:39:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A332C2BCB0;
	Tue, 21 Apr 2026 13:39:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776778773;
	bh=lhzhVWrfpSh5Qp+ByIaNqHmS1c8vpJzymZofhRxC3zs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SpHohVthriLmML5X8wXfsGrBMIj7r9VtWS9QHkajJ745xVMhM1iUGWt49vZOhjCGK
	 P19Cg5oCFQurRWOLeXVMx++r/4EeOzZpsEAOoGSXqpg9oRFJaCvfTRhYHb1YgNFE2m
	 Hl7Z4diYbrOkaTL4QCWwcl3Q3IJGUCGWKEj/ulEdK9cXD7hBGfcZ6q2iWp3FZONyde
	 3N6qXtXxOwZAuF0feZu3g7zP+w+IDtTM0UmrNSG2AhQNA6QKsow/LJfv8AVZkVVTNp
	 vCEI/de0I0QHejZU6iv3oPvlO21hAW4WFyKTFiOkzVh09xPzIK6Gnja/R15j6+ah4k
	 1PdueL/If+YHg==
Message-ID: <bea6080a-850c-4b3f-bcc0-719efc372e72@kernel.org>
Date: Tue, 21 Apr 2026 15:39:29 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: always support large folios for internal
 shmem mount
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org,
 hughd@google.com
Cc: willy@infradead.org, ziy@nvidia.com, ljs@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <26f954be62348591e720c4e8b7a9099b74dc1d6d.1776331555.git.baolin.wang@linux.alibaba.com>
 <1b3c0401-6d10-4a28-97c8-8e3858d8dc3d@kernel.org>
 <015de194-99b9-4f9e-8c89-d35807c6fd08@linux.alibaba.com>
 <ec6aaf0e-90c4-44e6-97db-041bff8644e3@kernel.org>
 <dee02e5b-653e-451b-8f59-7196bdae8f88@linux.alibaba.com>
 <07e26d39-6155-4661-b3df-c2419535ed43@kernel.org>
 <f9508e75-789e-4eb8-b09e-b66a8676a6b0@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f9508e75-789e-4eb8-b09e-b66a8676a6b0@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 7drbm7h8tci1zpjhtwp63dq5m4gon6in
X-Rspamd-Queue-Id: 16B131C0004
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776778774-678914
X-HE-Meta: U2FsdGVkX1+/XKNWek2aOrRQXqGxBCcdWDr/w1ONioqJ4ln5kKDB+DrFh08i8YrNdDwuW6Ozobd3LRb/TCVqTYCiMykl5CtsyMUhPhX1oWRZ3jerWuKBE5yj7D+Jew/End1V2T/fpY+IzwJw5OfepHXmZBwqQ4OCN3JAeUTFtdMYZygGHrFdDz0uLbUDY3NuYc3iUcVdHq0k5/DlrVfjAIGYDjwxML2B8jwRPyeBD1OgEPgGilD7eaR1NcmDQrITCy2P2qCaUWKpR5+BraveFYvbvZ+bXU4GG73PNpU97SHft4OSHHQxXgcQ3dceDyt6tU5tI52HPbwwfHeyPVHB9xJmNWh7D/NZgzc/fxx3OOYB1J78ALJ6kE1tTSAD/ODMu71mldpO06K9rpDFA2mT6p//zEAhQjM++cp35QLHLuAZZcswH3QONrEtLqTbNbmVQF4r5WVBF8M8TjbtpI711YifFyynRJLQZvUHRqdv8r+/glnts77vZquGyYwGPq/aoNwO1FArRGkB+2K1CUYer2pYt7G5eyYQNNM1PS/5egIQkYt4LJ4gHmKPopanKtBMjoY+Whp2jJYrL2d1rBmnJpMiUwf8Ttk7FXIkleLiUFyEveueSNpxIJMr94dFIBy+ZjPvUThk06yKajvpPIgO6KXbXMwu36oys4QPRcVYkQFGaBkIznxJezr+SgjQYtSyM0YCgUtI4ATulGhYznAyKeqar5NZe8QieEwNRhjRCQneZiX3EH4/uL1e2WuNxlFxQXBuGxmS+YjJoQJOA0joZzJZ98+D8Tbht+1P+GojF6IAGnyRU3ERO6pevLTuppm61gANZOu+vLAMHwgDprIsnsMVfXbjoVXIh6VrX+NFvbvN/LGSvPL9F9zZWcL/nPApgSWqtt9ImM+wq2u6Z9ehdiJYGVKe+/diB/h4d3KVRu5V7TENahxfkFWbjGpjoAi8gvTXbsYBecN846YaXBM
 Y9Cgqoky
 dDz2sYoJcE66nhC7notLuK7++wWH6f89H1oai3mC4fLI2Ezxlp/01XKkSyIHbWiU8tdswhwjvm9053uG92OvM8GzeCzucNCKs1AJdmkeDQ4M0JXl5q4srOm4u9ntwAud9vdV5d0QzibYQmLHp8y44YUNsG9z4NgHuOWNThBQqC3mXfyJ/DJz+wr/jY7gjoQwwu+n5ZK/ZzpIjdJH3t/HAmQZtfc58ZtVO/WMnZz3Wnm7onEwPO63cnks15/VMeDr0eWHz2nA11Y71cIEqFHhFdjl8p1otz8wLt1gRwB//FUTyQpepqB0RE/hLEM2H1AEI5nbfejREACQWsj4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 08:27, Baolin Wang wrote:
> 
> 
> On 4/21/26 3:00 AM, David Hildenbrand (Arm) wrote:
>> On 4/17/26 14:45, Baolin Wang wrote:
>>>
>>>
>>>
>>> Indeed. Good point.
>>>
>>>
>>> Not really. There could be files created before remount whose mappings
>>> don't support large folios (with 'huge=never' option), while files
>>> created after remount will have mappings that support large folios (if
>>> remounted with 'huge=always' option).
>>>
>>> It looks like the previous commit 5a90c155defa was also problematic. The
>>> huge mount option has introduced a lot of tricky issues:(
>>>
>>> Now I think Zi's previous suggestion should be able to clean up this
>>> mess? That is, calling mapping_set_large_folios() unconditionally for
>>> all shmem mounts, and revisiting Kefeng's first version to fix the
>>> performance issue.
>>
>> Okay, so you'll send a patch to just set mapping_set_large_folios()
>> unconditionally?
> 
> I'm still hesitating on this. If we set mapping_set_large_folios()
> unconditionally, we need to re-fix the performance regression that was
> addressed by commit 5a90c155defa.

Just so I can follow: where is the test for large folios that we would
unlock large folios and cause a regression?

> 
> But it's hard for me to convince myself to add a new flag similar to
> IOCB_NO_LARGE_CHUNK for this hack (like the patch in [1] does).
> 
>>> [1] https://lore.kernel.org/all/20240914140613.2334139-1-
>>> wangkefeng.wang@huawei.com/
>>
>> Is that really required? Which call path would be the problematic bit
>> with the above?
>>
>> I'd say, we'd check in the large folio allocation code whether ->huge is
>> set to never instead?
> 
> Yes, this is exactly our current logic. When allocating large folios,
> we'll check the ->huge setting in shmem_huge_global_enabled(), which
> means large folio allocations always respect the ->huge setting.

Makes sense.

> 
> But as I mentioned earlier, the ->huge setting cannot keep the
> mapping_set_large_folios() setting consistent across all mappings in the
> entire tmpfs mount. My concern is that under the same tmpfs mount, after
> remount, we might end up with some mappings supporting large folios
> (calling mapping_set_large_folios()) while others don't.

If we at least always set mapping_set_large_folios(), then there is no
inconsistency in that regard :)

> 
> However, I got some insights from Documentation/admin-guide/mm/
> transhuge.rst. Does this mean that after remount, whether the mappings
> of existing files support large folios should remain unchanged?

That's the current behavior, right?

> 
> “
> ``mount -o remount,huge= /mountpoint`` works fine after mount:
> remounting ``huge=never`` will not attempt to break up huge pages at
> all, just stop more from being allocated.
> ”
> 
> Do you think this makes sense?

I suspect that matches existing behavior, so it should be fine.

-- 
Cheers,

David

