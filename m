Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC924CCD1A5
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 22:42:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 053548E000A; Tue, 21 Oct 2025 18:42:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02AC98E0002; Tue, 21 Oct 2025 18:42:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA9B48E000A; Tue, 21 Oct 2025 18:42:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8C518E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 18:42:12 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2914C06AF
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:42:12 +0000 (UTC)
X-FDA: 84023596104.02.D25CDB2
Received: from out-179.mta1.migadu.com (out-179.mta1.migadu.com [95.215.58.179])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8CF4C40007
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 22:42:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fr4Rj0uO;
	spf=pass (imf12.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761086531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IqvbLN5ZgsnjvT0M+y4ZUEk2UJBRh2BxrolCHDhGhac=;
	b=jPYSh2DYJ5TV8qCGMbvxHE/UgRzIFuorBQ9MzpoKCOeRsf3zkuR6QOgbgO7p7ZODHQjfNg
	KU9jPCFzNxbSweLQ7PhN9+xnJ8KYC/hEZJGErJHqOtebFZXveveNFyxiq2BcFWcNz67BfV
	EqwsvPL2G81wCPZFeR1DFtwCsWAg/c4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761086531; a=rsa-sha256;
	cv=none;
	b=B4wIoLZmAfW0C9jKPYVsu9UJLDPr4Qs/gbD4SqYj9etQRu+g9XMa6eEfXn/iWYLXUdeLJ8
	j3xl29SD6wlr4Bd+KS1/SDDDM2hBK1qBuTenTKjMLNeF5PwZquohAaBtEkBQJ2CfacnOIb
	PDx6g8NOWWx8hKVB3DfIHH3u04XQuAo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fr4Rj0uO;
	spf=pass (imf12.hostedemail.com: domain of yanjun.zhu@linux.dev designates 95.215.58.179 as permitted sender) smtp.mailfrom=yanjun.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <bcdb064a-41c5-4ea9-ae71-be347f3b7317@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761086528;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IqvbLN5ZgsnjvT0M+y4ZUEk2UJBRh2BxrolCHDhGhac=;
	b=fr4Rj0uOUNFoWJEKsRb+tkT0s0qx5XjptRPE0N4jDennWFPfmuHELgBk5VdRmXhE1SzWqI
	iSoq+5HiSrn0lBqZqJDXnl/GtUT0bPFWz8p1WCSB2bRiB49D63HLnbps3POlDYmOR9X9wa
	rDTE14xhSYaDAcIWF1GpvcebJDCHkXs=
Date: Tue, 21 Oct 2025 15:42:00 -0700
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] kexec: Use %pe format specifier for error pointer
 printing
To: Simon Horman <horms@kernel.org>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, graf@amazon.com,
 rppt@kernel.org, changyuanl@google.com, akpm@linux-foundation.org,
 bhe@redhat.com
References: <20251016200320.4179702-1-yanjun.zhu@linux.dev>
 <aPdVSyLRKeRN3i6z@horms.kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "yanjun.zhu" <yanjun.zhu@linux.dev>
In-Reply-To: <aPdVSyLRKeRN3i6z@horms.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: jxyhyk3oqgnaa161hgzbu6ir9ny6zscg
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CF4C40007
X-HE-Tag: 1761086530-455893
X-HE-Meta: U2FsdGVkX1+LIx5EtemPSaN4cu0paNnKuos3WlTgI1KlgbD8ZYpss1oHkCPnwMMxbD/vVFlCO0AGyPMFeb21R8MVsPq2j9MYZJ7PdmpvmjB5kM880WUbSFH8g+CrtOAex/Gj+9uqfeRn0TPDMf7Y/h56VoKYc+BpPcYAtWt7BryDNcNsvF4xO3rOgVUp8/KZJdQ25D/wLNeJvdZrK9PgSF0owKpdYCWWZ5hUHtbexBVoe/5ltaRJZsKG+QbrkcSmSYYhgeUJmh0gubA8J8e79XhgZ42NCqE48Qt61lpXJXPeXcdK1ZVyrYENhnTA+6MZsPicfDhlyyiUVuQNDI4FyumoA7iEESEKThHB68x2KBbNXqyZKxh/KH1WQOxZXZ7+X1zGFeOEUmUTJ2hiD/9oT3rwxZQv0wx0yClPbTuThwJvbH4O6r63CtspEM7QJv3lktp19RO6+JULtaDopFeUAaYiSfKX9glZf+BObOhQcXUyXsTGWd36pCaZD/NhFhIrMmo0FWsDN2+fEjn8fIdrlZe/sekVHFM+n66G10QKyi14kVEe6ew7K+8n0x9bzCId0fr7+6KAjFuv2fOM+nQnvL6SqG0i6NwMNm7hbzeXs/0c7PQKeSJl0jk0/4jMCg9n20HIk79hWrYg9NWAccxXG1IA2otlHPcShT4yJGB3ClkKZijZOTdAOS+sYxxquIXm7X4Uvq3pjTdauRJGRjXEk1dbpvkuQW2/yOYeFvtjnhr5NOP503QGCQfS8ETKANij9TVZNcdIodR6CJj4xqknEhV/uxp5ne92L2dDnYNCyIWvzQM+I6jb4gyOBM7y6ea31koF/oNXPjHp/lJbtqt/IClPUT27E65ieU7De5FgFSWWM25+nEffZ0GT4S/Y/RJ1kGVUev6fOkefbC3JA19xj14yrMQ1f5FhZUYs3C6+H3Gk5hU0RAspKFwrmXXePOT/vvbJqFySX6MpzA8KZoy
 GTigpxGf
 C9t2UfDGJvK8JZrNs68m+ZVZxIUg70ogYYhiXuBcKRfcZOfU2WwpcNwi4aYXVFW6RckEBYQclyjKr5X4YKWG0/4GpW8ZZEDyNpBLb2pVuEwU0EDfmPZaP/CZ5/GRfH3XtWAKkFOBV0h+GR+dje4opzBqgECYlVBy/tEryMM/ag11cN6ein4GEEE+kMBtctuxsHTSW7MsX0R4qYQZih4Wi32m4ilebX2NHaKbVtuvQjacWwFs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/21/25 2:41 AM, Simon Horman wrote:
> On Thu, Oct 16, 2025 at 08:03:20PM +0000, Zhu Yanjun wrote:
>> Make pr_xxx() call to use the %pe format specifier instead of %d.
>> The %pe specifier prints a symbolic error string (e.g., -ENOMEM,
>> -EINVAL) when given an error pointer created with ERR_PTR(err).
>>
>> This change enhances the clarity and diagnostic value of the error
>> message by showing a descriptive error name rather than a numeric
>> error code.
>>
>> Signed-off-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> 
> Thanks,
> 
> This looks good to me, even though I note that this file
> has moved in linux-next.

Thank you very much. In next-20251021, I noticed that the directory is 
now kernel/liveupdate/.

If a new commit is needed to reflect this change, please feel free to 
let me know.

Yanjun.Zhu

> 
> Reviewed-by: Simon Horman <horms@kernel.org>
> 


