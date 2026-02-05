Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6AC0E91265
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 14:25:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F31FC6B0088; Thu,  5 Feb 2026 09:25:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED8506B0089; Thu,  5 Feb 2026 09:25:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E05166B008A; Thu,  5 Feb 2026 09:25:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CC0AB6B0088
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:25:38 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A31A1404C2
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:25:38 +0000 (UTC)
X-FDA: 84410626356.29.441CC48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 64A84C000E
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 14:25:36 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770301536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=09yTAKIMLJX3MbLCONT/iqUJaPKneDPDdQFcKJzvMB0=;
	b=6xF4KstKd3uHjGQczjgVUDmLJcYpxh980MnPaCJ+SoXokm8YqGq/ttAIHcsB2KJISGGgdg
	qxW13SXMkUTGPByQO4yNPinpJe+/iYaXT/7kmT4j9P20W6aKxpp7sjK49Ldb7Ob69EI2Nv
	3jUUj7fDj1aQCPOc1pkKriuy2Z3yCt4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770301536; a=rsa-sha256;
	cv=none;
	b=YxiCOSQO+YiQuAaaEOTJXwq9Py+y6xrqNjBv28aq+mu2A1EQPfmvT+3nkF9H1FqVXjurnZ
	m9r1dTsDDoEiDazKYlb/36cUqT2U2F9ebvUV8Ooaz+x326W1+iI83JMIEcWkYPmeQSmkGw
	gkHZYq/cBWYkJRaCvp39eIlXua4vw4I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DF826339;
	Thu,  5 Feb 2026 06:25:28 -0800 (PST)
Received: from [10.163.132.75] (unknown [10.163.132.75])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E16753F73F;
	Thu,  5 Feb 2026 06:25:31 -0800 (PST)
Message-ID: <9508744b-e5d5-49ef-825f-eef683892541@arm.com>
Date: Thu, 5 Feb 2026 19:55:28 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v6 2/5] mm: khugepaged: refine scan progress number
To: "David Hildenbrand (arm)" <david@kernel.org>,
 Vernon Yang <vernon2gm@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260201122554.1470071-1-vernon2gm@gmail.com>
 <20260201122554.1470071-3-vernon2gm@gmail.com>
 <fd67a91f-3930-4bd8-886b-13f7783f4aec@kernel.org>
 <CACZaFFNGFWv3FG8spJDLfLTe=0QWuBWL+Lbs+W3h9vGL=jrT6Q@mail.gmail.com>
 <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <85e8ded9-a9eb-4663-9c96-93af60006fb6@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64A84C000E
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 66swnm7btastn46fbegam8npg6bi6par
X-HE-Tag: 1770301536-351442
X-HE-Meta: U2FsdGVkX18VWicb6dA2s8RjLC23Sl8yDxZsVKUTTq+myqzBUAVt/urwwyvMmffL/JjsAWOyL7VeLUfl8S3RA/F72wL79JyriGhYhmxsRzivsmNRha8tm1L3Iv7NYJtfUTmiKHSpDRxaN+P/kkIKW7znltd3PsEZ2ID0TsE1c2PChLJac+ZvvtGsitUb87S7ruadIzPo83UKkt5zW4zPRcegluRw9f8yDomq5OgbV5CFY7jwlSzJtyfO6sPKr+qT8CurJA8lI5rwYzmkEv8rwBHenOtK8uu8ro03ZEW2/SwCwzOQEs0Z7BivMm9g9a7ChQWvwC0O5xRqfKnsn20lMMXDQE2EDXOHyxtMz9Ri1ceZPKB+PjfREd9yYybTA9uzEOowEhCjjbuMoaslh7Y3R9JN7H/xeShBacJ3qD3ToIMe4OctNLoDfFW3R/KvQqsAOXY4poLQGTnbnK+BdMhCm5pgYU+A4Y4jgIwl8eKndKqkzP8vXMMVQlOxjQC5GytMtw9TZjcgqmod+9AabFmuzhveLIiyLobwSNsIxxty5ErF0rRVs7Ee5r1MPgBKCzEjXVkL60KMs0RUxeUfPrk1CTvvMrPxoRFulnLloQ1Iau8uqNcCot88ekzoXlp+kne+4VLWjfxLh/+8FremTMQ/P6XHj+1HdxgZ4+tssV3o3q2fyaCvmPEF2JZTA067oKwGApRE3jvgHQUQSacRVB1OoGxgE6uQ7pQPlfuyM8DOUNqW003VxXG9Vhxtqqu5Z9iXW1vX4c6yEzsWRNAD5DhhsmSbGmA2JFnL8khUVE2G36eT2EWCYPMTnA9jWad6zGsaNEPtWagtKL+n3YaL8lXKEaSkuY4CphdkitEtx7Zx8b2YfdSwdLV7cwucCqSHT8/+Ukl9PqNI6g8GnfVEn0k4szUyCiCJmRbMbagsFSeA0g5BT3wdsX9GiDJMrzQ37USwcvUIzdstqhtDPSJoFNe
 FlThsbE/
 Mp18G/sQ+Q80n02f2GmYC5KQWVYSYWQqfUgSWJtsZ9yWIJFoEK5Y2Y/Wdhme4uggaf6ae0ZlZgQA+ZuWgEciz6H2EXY1M3WD5eXLCNPDE3OGPEtNc5k4emcwf2KR4BPZEjQxQvktKC5GQiU61KT0syWXFD3yKBrg5PAXG9+YZreS7/Hrh4QegQQ9VFbRqmUfvtqpJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 05/02/26 5:41 pm, David Hildenbrand (arm) wrote:
> On 2/5/26 07:08, Vernon Yang wrote:
>> On Thu, Feb 5, 2026 at 5:35 AM David Hildenbrand (arm)
>> <david@kernel.org> wrote:
>>>
>>> [...]
>>>
>>>> +     if (cur_progress) {
>>>> +             if (_pte >= pte + HPAGE_PMD_NR)
>>>> +                     *cur_progress = HPAGE_PMD_NR;
>>>> +             else
>>>> +                     *cur_progress = _pte - pte + 1;
>>>
>>> *cur_progress = max(_pte - pte + 1, HPAGE_PMD_NR);
>>
>> I guess, your meaning is "min(_pte - pte + 1, HPAGE_PMD_NR)", not max().
>
> Yes!
>
>>
>>> ?
>>>
>>> It's still a bit nasty, though.
>>>
>>> Can't we just add one at the beginning of the loop and let the compiler
>>> optimize that? ;)
>>
>> I'm also worried that the compiler can't optimize this since the body of
>> the loop is complex, as with Dev's opinion [1].
>
> Why do we even have to optimize this? :)
>
> Premature ... ? :)


I mean .... we don't, but the alternate is a one liner using max().

The objective is to compute the number of iterations of the for-loop.

It just seems weird to me to track that in the loop, when we have the

loop iterator, which *literally* does that only.



Anyhow, I won't shout in any case : ) If you deem incrementing in the

loop prettier, that's fine.


