Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8AD6E9D832
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 06:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E59706B0088; Tue,  7 Apr 2026 02:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30B66B008A; Tue,  7 Apr 2026 02:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6EA86B008C; Tue,  7 Apr 2026 02:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C64E06B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 02:53:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DEC3BA72B
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:53:48 +0000 (UTC)
X-FDA: 84630844536.06.7F5B5C1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7AE2E80002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:53:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gq19ZaG6;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775544826; a=rsa-sha256;
	cv=none;
	b=0FdGR3FA74cQVcirNJ1jsXP/OlzENL2Dzwq1pcXmjnqd+EFCaiBmhp7PkvULbgJ04wBTGI
	QrZ+aKKjyDuWsNr1s28kwlYlvHkhLjV1PhRXBrCqUEnYH0zljQqBGyhMtO/WYyJly4QtVo
	xwInTrc20MFZwpGJ5j6p7+TCm2aZUBM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775544826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bnuUmqEsVoIsmdO86nk8heyWMrFfzsGSAxjSx//q88o=;
	b=nx25VbhNknrMEVz2kP+XsxYqcWPiZwWzwzAk1bM1Hr4CiUHgWO5DRdui0tV/VRk1jJ746l
	xFiC1IMVY5n1CcuBli+Y+KsD3OZLy5lnpuFZEgRvv56AQ9UEHo3BsSB/ubd9lU/Rj7oxkH
	mig8CH0UYcvZ+EuB3pLAYN7yNx58CKo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=gq19ZaG6;
	spf=pass (imf30.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6B3F716F2;
	Mon,  6 Apr 2026 23:53:39 -0700 (PDT)
Received: from [10.164.18.83] (unknown [10.164.18.83])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A6EB73F641;
	Mon,  6 Apr 2026 23:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775544825; bh=xmJOywtnqtcjtDrOIaLg4cNmmd9eqq3pTFEdQ1HGsDk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gq19ZaG6H/Z6QLLA361dNnxs7Rcoy1FFoxh2es/ZkM34A3iiH7Q0NWkQ9Xjf85a/V
	 Cw84yhYE9dms8niScH613/FI3ApHX6Wc/QmkYVNEjsQk3N+7VxRQ/QXYkr1v8tdtC2
	 iPBeGS35uCwhoz4oVnSyTerqZzVYnRL5bM3gmw1g=
Message-ID: <f5c9bd04-115b-4f34-bfd2-0bac756f84cb@arm.com>
Date: Tue, 7 Apr 2026 12:23:39 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] perf/events: Replace READ_ONCE() with standard pgtable
 accessors
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260227062744.2215491-1-anshuman.khandual@arm.com>
 <1267a6c0-f8e7-4708-96da-4d131b5c6069@arm.com>
 <c7688962-d10c-49e1-a434-ab7ae2c64cdb@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <c7688962-d10c-49e1-a434-ab7ae2c64cdb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7AE2E80002
X-Stat-Signature: hfysjao6ockseb8fitxcoowe1a55ggrp
X-HE-Tag: 1775544826-804756
X-HE-Meta: U2FsdGVkX1+KrRqeD5oeH/MCBIG1StCqnSixBJyIVz4B6XY6/Dy+1xa0noAYIhiZAnZwKtB1B3YKX7oGE9TGQCx+7SusZT/z/Gtatr+2WECoc/x4jOQhhlPrH8Vgobat01iS4ByUbbJ3oSUAeTczg0a8WqR/D+5pUnRS+e4T7Z3SvkIi8JVamM5MIM2Tt0hggspWWRlwyM69WqyiIaAYYKrOQJZ/cGWNhcl2xL/+yvsIEap986itkybkvn2Ma6cywPWJzoxgQtMV7XSJxk8irVrixbhmiWYsNkyzq7xEMcEagY5g42yff17b959eMyJgQbBghttifqk3xRbYky1sHfXV0Aae0Hj9vG6OUNsnNPb0LtCTXtmK5mAVegrgEiLY9XwV7af98p26zaHi1UEXZMNjqT0BWIT7Htivb16vMoMrHfP5yJaf5jPjOuIuJb13phO+03rTD0Bj1BlunMa7qM93EBIE5BnvuFm3CWjHKTok9xvxGfpkiw86m83h9dEz7FIAE+O/uk/W9QA8WAYXIX0g9eutUV1tpvXTsBguRyQfgsxgwwmlZ0KH8POAGeQKIjyDpqzGdtAxekXaakxIqstCjXyXBZ2HRGucWH06QdJ7Ura+RogG0lV3eQZ7+Fp/cOQlOJL+9zxlliVD4XrFDAW2Xom5paXkNcN9fYUP2E9TrL4gkPTmvjgN8DMqwsXDa5eDVNBAF1dh1io//TgUUe6aYn/cdGoCozEtnN4LRpr5yU83Y65YNqOCViIs+Iw/bP4Zh3b7QG/58diGFfhJuzlOod68m3sj3+eN1U6pro2pTGKPfxT7Yg3ArjN5N/Q//p4FLZjsF7fu34XVUdmesC90+kIvACLTODoGC7MSF1vy1GI3xVC+YFn/wKYGBWMwwfwyFhOWVHTHzSi+g1euu/FTZjaNDqLh6QMiih/NVT3eSE44t9rCDiu5byGTkJuOdPujgTzn7yIGATVJ2FA
 5kUuEIj4
 JyVkWt3rfqtqmhMfjz1W87FRgtjv8GFnfK39/O2HZBv8szI8V7JtqwvdY9I+PyA5nNtc8sd5g/B5P73lDHPKpcZroDJ4d0PZF2meiGm2KeAcj37g/1DxdiSMG9ZgEf5o7s/ffqFpg1pYeEiErTMD4Iy8zU++BKOPNKNnld3exeOP+GNSA2VqHw7luoD3cJ45rh5HzE/cWEpEqNDXCsCa+Bdop/w8CY+sHOfGN/ouTEmZj2KVMKY57gofQxfSga4RCi5F9S/VqvAueX4MhMxnlWvEJiPGreGSG2Yxwx1YsrCXXw+FDKbAi7tMsbu1EvOkeb0uHE67mktE4c5lvnFqya/C3c+jYK0lbVfXWVRbMNg5PoKfMnb2VH93cQnVW99jVCgNFVA04814coKTBu803J7xZH8BKnEDe6mhZCH9K2bFmUtwxplMIFU1bSRMDtoy959DgExTlugbVGLX0rITsxC6XRM06uTDlpLr89hyDJgE7ts3VZR1Hvn52l3dsr+IvulQ9GqWyXVQaaxEHb0arevpSRMElr6tPJ2CP2ll4kmGYBVC2iHw5Od3Hrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 07/04/26 12:18 PM, David Hildenbrand (Arm) wrote:
> On 4/7/26 05:28, Anshuman Khandual wrote:
>>
>>
>> On 27/02/26 11:57 AM, Anshuman Khandual wrote:
>>> Replace raw READ_ONCE() dereferences of pgtable entries with corresponding
>>> standard page table accessors pxdp_get() in perf_get_pgtable_size(). These
>>> accessors default to READ_ONCE() on platforms that don't override them. So
>>> there is no functional change on such platforms.
>>>
>>> However arm64 platform is being extended to support 128 bit page tables via
>>> a new architecture feature i.e FEAT_D128 in which case READ_ONCE() will not
>>> provide required single copy atomic access for 128 bit page table entries.
>>> Although pxdp_get() accessors can later be overridden on arm64 platform to
>>> extend required single copy atomicity support on 128 bit entries.
>>>
>>> Cc: Andrew Morton <akpm@linux-foundation.org>
>>> Cc: David Hildenbrand <david@kernel.org>
>>> Cc: Peter Zijlstra <peterz@infradead.org>
>>> Cc: Ingo Molnar <mingo@redhat.com>
>>> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
>>> Cc: Namhyung Kim <namhyung@kernel.org>
>>> Cc: linux-perf-users@vger.kernel.org
>>> Cc: linux-mm@kvack.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
>>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>>> ---
>>> This patch applies both on v7.0-rc1 and mm-unstable.
>>>
>>> Part of the D128 series but independent. Hence could be considered on its own.
>>>
>>> https://lore.kernel.org/all/20260224051153.3150613-5-anshuman.khandual@arm.com/
>>>
>>> Collected Peter's tag from an off list conversation.
>>
>> Gentle ping. 
>>
>> Still don't see this patch in latest next-20260406. Hence just
>> wondering which tree and branch this patch is being picked up ?
> 
> It's a trivial change and the last generic code change required for you
> arm64 D128 change, right?

Right.

> 
> I would assume this to go through the tip tree, but if Peter agrees we
> could route this (mm) patch through the MM tree.
> 

Sure


