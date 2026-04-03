Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B489E8538D
	for <linux-mm@archiver.kernel.org>; Fri,  3 Apr 2026 18:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F6406B0005; Fri,  3 Apr 2026 14:14:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CDB36B0088; Fri,  3 Apr 2026 14:14:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5117C6B008A; Fri,  3 Apr 2026 14:14:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 420496B0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 14:14:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D8FC916075A
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:14:17 +0000 (UTC)
X-FDA: 84618044154.06.36D321C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1E764A0005
	for <linux-mm@kvack.org>; Fri,  3 Apr 2026 18:14:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7WUCjnt;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775240056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/hd5x7EN9l7Y2imp6Q7ShRZ9cLp3uYiRtAcH3/odR24=;
	b=rP3GayUG1g+g3888ZZ9RTcVzaU7IMwPhSaAKTglVVJ+uX/VS1szdPhscZhm5keZrh6/OZZ
	AFpavI8kRC1hYZ+us0g9t2nOxbm5J9ryfwTph4KrPZOQa6lnwhccYoQWfecUWu1HRGYhnW
	TpLILo9sKI6btOPQ9y7ZEQeTUTqRFSw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k7WUCjnt;
	spf=pass (imf15.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775240056; a=rsa-sha256;
	cv=none;
	b=VJAmeR07vC0Xn7hTDnZsJ8w1Jnd5TZWHv12HGQviltJkF4jIOcZaYPBELvRlQZ0GXWqH2Z
	SjDlC2c0yxS/Xpc51Skv7XvKi1aGf17F+gG5yjeU+OG+WuYCSCJdF3fwWEtV6xjhkzDo8l
	OjaQBl1lJgp2/kieTRCaZnpQwdn5cmU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1881E418A5;
	Fri,  3 Apr 2026 18:14:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582C0C4CEF7;
	Fri,  3 Apr 2026 18:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775240054;
	bh=NVmucWWcOjVa31P6c7zH6ESRwNaaHDsOHGyY9BpMyX8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k7WUCjnt9/EYcljpbapkd1dpqelsfSvypsJFqtjuvlobIzznbT3npfcn4HVD5mvMC
	 HgfAmEYSfJb2MrGMD9mfm6eA1EdenC7bh4rKtYwm+2EpdD7iQZMcKLqUBr0lHI+q12
	 lu33IEsyRvFTIzihzaEfd3G611wUxijlJDOkcMQW5RlPi6AzqyOWgw49sKWmTXfHEd
	 DFuEKpwKYw3xYqz/67YUjp/OW4WlrVn6MxiSbbD4V1hjV9Z84O/GoOZubrzxmLKAUA
	 8XndJeqX48vHDqIO288ggQ3iukuaGI47N+Z6Xks+OwepUpeDa0nPyYXLBO58vklsx+
	 Eyz80hcGTzpHA==
Message-ID: <6c90c152-3341-4a46-bffa-3cfaca66fdd1@kernel.org>
Date: Fri, 3 Apr 2026 20:14:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] slub: use N_NORMAL_MEMORY in can_free_to_pcs to handle
 remote frees
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>, Hao Li <hao.li@linux.dev>
Cc: akpm@linux-foundation.org, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260403073958.8722-1-hao.li@linux.dev> <ac-qJ7tYQ-ybegOw@hyeyoo>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <ac-qJ7tYQ-ybegOw@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1E764A0005
X-Stat-Signature: c7ytscteyx57xtkggypenw8nmzu3e3en
X-Rspamd-Server: rspam06
X-HE-Tag: 1775240055-525749
X-HE-Meta: U2FsdGVkX1/mLrKuz30sLLTeFtDsrBQT+rg/VtDatH3BpxBdCoS1EsCXnledpwl8CUTfy7thBM0YfTz6XTXUih+CADCxPGXfNzMZ2SgVtKmxYHoQrR/lITnBUi72i0PDMivo7tHmczrmomkqWwSc6VsBsCEJvq5hdFK0TjdBulBYC/3eYPCPi4qc66NUPsgHPnTtYeGbE/aA4w7EoV9fz/ttPHIVBsCgAX/2FwFqIiDIucXGVCVopuZJKZ5UoQ64JJFSIFcsZ39DdzrxOihxlji8eZVmfSZShP4I++MF7U6X2/YuqvlReNaff9uy90s7fqt4QY5hxGvZEYvRlCWool+xT1S7E62Pw4M8dxdsmMUkG0I2ss9ua+qthPi0d0/4O8uGw1d2loXRR7O0SLuEn0c5nrEMzw0H2OIO/QAoCCwPMc26L0E6Mu1LOTDRd0k9NVJPK6UMeicGwefpyiZ3duXfy64fmmnbNebxN3P40y26yKsRprRxrGmTo4DnjOEAiYw6WO7rg4/pFQYSaycv7ZSXUaaGlmykLgZF1ev88eNvqYT2H/eUFebT7Vks26jXN1W/5euJKEms9EvmFSSKWOSMjAQjLrxKK/cZXEmgCsMrEMhKXQVLevtiKjPQ6j7ZbHLHUoD9VoPJ/ypNTORrO/OLBcby7r8IRAowb1mhAsSNp280yzty1FHytWkEMazphqaQycSI2OggO8gGwTrxkvNnpOMoFGaJ3hvVnj5EiEc3cj9WvAqzjkQANSup1H0Atxm56GSNI9/xb/Mw5qKVAXVnffOgo2MhpZhCnObMCpO0XgFO0NKgQz24KNvpim3oVmW6zkTAMKeXZ2nXPq2QOrt2iNQk/8n6B2TnyNKdi38gZ192rUQxU+g14rKnQjEnv9C2omTM0DH6idpVUang18MHy6U9MRldFvYquohBQd7dFLF/N/+uV8yZqgBu1fCTML+dQBczo8Vm3ZjUnti
 oFiW3AY3
 LTEXwKRDbrGYcqlkLdnhNYGo1V3vCXnoFp1DZbTdHXjOCYnfHx3q025EuL60GiFhmfrp5ETUnZ90t1nuSg4bVb+1av9bGs3uX0/HLHZMQdNWGGoChbwqQUqv7fHfy0hAUOKJ1RAE0DeGlZ1bsqxx+k/h7OGmxZSbX8/DAR5dT2FTBoTo+IBOWlVXR45TOT9VkGsgF+DkGQQcObAFGAx8H/EHsNW/GInVUy/UMEsREgWUW1xIb327qcHbrGtnatIWCJM80RblP8AouucbfW1huvSh7zl7EqUlPmzNRYKQHPlzvCokm9MlfGHommafbVP+AvczvVTyWW44KzE0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/3/26 14:02, Harry Yoo (Oracle) wrote:
> On Fri, Apr 03, 2026 at 03:37:36PM +0800, Hao Li wrote:
>> Memory hotplug now keeps N_NORMAL_MEMORY up to date correctly, so make
>> can_free_to_pcs() use it.
>> 
>> As a result, when freeing objects on memoryless nodes, or on nodes that
>> have memory but only in ZONE_MOVABLE, the objects can be freed to the
>> sheaf instead of going through the slow path.
>> 
>> Signed-off-by: Hao Li <hao.li@linux.dev>
>> ---
> 
> Acked-by: Harry Yoo (Oracle) <harry@kernel.org>
> 
>> Hi Vlastimil, this patch depends on a prerequisite patch[1] from a few days
>> ago. I'm not sure how this should be handled.
> 
>> I wonder if Andrew might put them in the same tree.

> But it also depends on the patch series
> "[PATCH 0/3] slab: support memoryless nodes with sheaves".
> 
> So perhaps better send it to Linus after 7.1-rc1?

[1] is in mm-hotfixes so it should get to mainline before 7.0 final, so then
it's fine to add this to slab updates PR for 7.1-rc1

> Thanks!
> 
>> [1] https://lore.kernel.org/linux-mm/20260330035941.518186-1-hao.li@linux.dev/
> 


