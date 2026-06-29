Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F022C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 09:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453FE6B0088; Mon, 29 Jun 2026 05:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42B706B008A; Mon, 29 Jun 2026 05:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3437E6B0092; Mon, 29 Jun 2026 05:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 120EC6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:25:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 96AA61C3658
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:25:58 +0000 (UTC)
X-FDA: 84932418396.06.0883029
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09716180009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 09:25:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CyZL9ojg;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782725157;
	b=wFGAfZqSnk72pE01o18OMt4TxV6zzZnB4BxHXanCfO5z6LLYctOeiX9SQN4jZp6cLuMcnq
	EsonraVIYK66vlqWQ8V4xardIfCFnkfo+pjZigNGuEmtR89cg9wgCEH9sOzE0o6szMqlxI
	l5sm7l2h5H+ozdp9zKz/TLuze2xbH58=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782725157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pdZf8FEQU/Nz7H0SIPDxFTAlCPeoMrqoIBM0aEQEZEc=;
	b=g6IIEB/fwk2uaBQgORH4DX+nYO7cuf1xWW7Gz74Pk+JxHeCkUpFnCuZxQc9LdX3xg+uQIE
	MRIeAEtMLLpunh+St1M875XcEazDbJSbBsMhW1QBtMSLRO9Qiz01YDCITpjmBtsl694Nqt
	34GhpecUeCk4+xl7Q3c3dfrqugs2ROk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CyZL9ojg;
	spf=pass (imf24.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 474BA43C98;
	Mon, 29 Jun 2026 09:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204A71F000E9;
	Mon, 29 Jun 2026 09:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782725156;
	bh=pdZf8FEQU/Nz7H0SIPDxFTAlCPeoMrqoIBM0aEQEZEc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=CyZL9ojg4JokMZn4tULoJ5z79GszhxB7MBh0TLLm6N8wwmKuIXzvkTEDqZDH4X90j
	 c8Ds+zmpG3rGJ2pGYIC3PRH0aWVsjOdpQCFayQQRz7w+KLNqB305ty1xb45Sc9l3Tf
	 cKiq8Y0MKEWjuv0hY02ct4Lt6Ht4r3zJnFEpQnSdPWLc/D+UEwDnalNlluo1+c3846
	 2gcKVeDGzzEiwej51RxTrzkTu1ZCIL385qHQqLCFrU70xVaQi9LcgiVmMRVYzXll0f
	 Hp8DEZ8ZwZ6VWzLJdMpWpmulsLykPi5bNUGXyNh2ccEygSlYvlA7OaaMelgd6NGkGc
	 4uADB6zoGjwQg==
From: Pratyush Yadav <pratyush@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: SJ Park <sj@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,
  "Liam R. Howlett" <liam@infradead.org>,  Lorenzo Stoakes
 <ljs@kernel.org>,  Michal Hocko <mhocko@suse.com>,  Mike Rapoport
 <rppt@kernel.org>,  Suren Baghdasaryan <surenb@google.com>,  Vlastimil
 Babka <vbabka@kernel.org>,  damon@lists.linux.dev,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: s/SeongJae/SJ/
In-Reply-To: <e29d1211-8bc3-433a-b1d7-d7fb44c2f0cd@kernel.org> (David
	Hildenbrand's message of "Mon, 29 Jun 2026 08:30:23 +0200")
References: <20260627195630.24519-1-sj@kernel.org>
	<e29d1211-8bc3-433a-b1d7-d7fb44c2f0cd@kernel.org>
Date: Mon, 29 Jun 2026 11:25:52 +0200
Message-ID: <2vxzo6gtk89r.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 09716180009
X-Stat-Signature: gpnuk5914drosb34nzzoxhg36h7hns84
X-HE-Tag: 1782725156-826827
X-HE-Meta: U2FsdGVkX1/VIu4wH+UB1eTZrpWmY51m407rNRe9sE9xaoWHcsjklfdpu4NA7UunEnozN/UDvG8AYwROqu9ENNv3oQKhgjbLULF6ndLPbffyN29uRdiWiO3jiLV1Sx+tzjrPDKj8TQ0eHRKrLJAsZOQMdvYV3vregxznnkj2i2vuFt3lW/I0sKr0LbqxyGEIIiIPwYwaHXeVYpSJ9SMVgNlzNCEIjF4ezuAx8/kls4ad3qDzyO41Wlma3Pnu5N2aC5qbTnHfFpXCAkIYbrHAl2i9ys/XHpnqODsiLOIwxzMnr6L/P/bvL/G/BdSWvvqZGB/8W//P+gRXac8UTCj4j+l/gnMaYv6dGJYAMIbez+E7Vze01lSbSc7uHdpLIWkyIQhkQvOQCKczQrtcvEfGuCGWsYoY3Cp7o/qRcbZhp7p6a7ixLh6TjJ/wshg/9MNx1RDGa+3vfN7Qm+BqugqNgjjBZP1CVbAU1JewiC37fI9QAtEtN3WTW5D8hf/LpYR+NBIkf3ee2VEAtKC9PRaQMF2YBMiIsHiKYSQhstNS558E+jqm5Ut0rg1L0MoriPatS1KU9PGPKX2shjvFv5YwXxkx1j8c2GSFYaAMP6SEA3TybAYWQx1RIvOBTXFThUg1oWKPv74YbyiWDocC+Ez3EGWRDeaANqxSfdeSIqASFXTDGTnVdHj5MechDhEQZ/qGfOnQq8943rmil55bGNDSt/ZH/fZJFwKgwKR04zOW9cwfzPWMn30Vg233NCBcBhBVJSjmOXbMTau19Rzg+JECuuD8PdoiED3PXy4QNndW+VzfxZVAlEgd2oYWgFdl4xQaK2B/OpCFaUDopgKMub7/QXufBNSHLccL63lrFeHZDRXlYrnAxqiS5IIqfNq2EdRlX/kT02ii91HkyPKmWUTc+MtJOgYKOLV4R6Vmd6M6E6hOkT0i1vP70PH6VKUkc06u8DUE5UJvVvboozU3nUT
 3prtCvhE
 TGwb/AIIitEbfTQcavO2PBvsHj2nx9KaQzeR8jJRe1nm7QrtvoNQY5mjeYMrG9q/ZY00McmgtEN8SAfp+jm9VQiI3DZ3fiPFDh47GlZTZ5DFKLP2iJjAy0md+I3XoO3FfvTnnJnuMS6T+wGvWMiNyV1RfW2P17xP8WaXkQfgzz9ufbNwzjUcZhydSnf9JO/OYhfBRGT0cFxPdFvQmkB76W2jzFVQIWthqjYQ/Y3GjgZNsp77MyTw8Ra/bYnxTzQ6uFlDScUsn4/rNqwaaud8bMeDX30/YvckqwREj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29 2026, David Hildenbrand (Arm) wrote:

> On 6/27/26 21:56, SJ Park wrote:
>> My legal name and preferred first names are SeongJae and SJ,
>> respectively.  I was using the legal name for commits and tags, while
>> using the preferred name for conversations.  It sometimes confuses
>> people including myself.  Consistently use the preferred name.
>> 
>> Signed-off-by: SJ Park <sj@kernel.org>
>
> [...]
>
>>  #include <linux/pid.h>
>> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
>> index 1cfb8c176b873..fcf7c7fadb5fe 100644
>> --- a/mm/damon/tests/core-kunit.h
>> +++ b/mm/damon/tests/core-kunit.h
>> @@ -1,10 +1,6 @@
>>  /* SPDX-License-Identifier: GPL-2.0 */
>>  /*
>>   * Data Access Monitor Unit Tests
>> - *
>> - * Copyright 2019 Amazon.com, Inc. or its affiliates.  All rights reserved.
>> - *
>> - * Author: SeongJae Park <sj@kernel.org>
>
> Just curious, why do you drop the author and copyright information? (can you
> even drop the Amazon copyright note?)

Off topic, but I am curious how these copyright notices are supposed to
work in the first place. From what I have seen, the person who creates
the file normally adds one for themselves/their employer. But then other
contributors who make small/medium changes don't add theirs, even though
they should hold the copyright for the code they added. Bigger refactors
sometimes add a notice but that isn't done consistently either.

So do these notices even hold any value? They certainly don't list all
the entities who hold the copyright to the code in the file. Only git
log can tell you that. Is there even any point in adding them?

[...]

-- 
Regards,
Pratyush Yadav

