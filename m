Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 166DAD3CCAB
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 09:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F9236B0088; Fri, 16 Jan 2026 04:54:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A6956B0089; Fri, 16 Jan 2026 04:54:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D37B6B008A; Fri, 16 Jan 2026 04:54:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4CB656B0088
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 04:54:28 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19A7659739
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:54:28 +0000 (UTC)
X-FDA: 84337367016.09.0077BB3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 858B0A0011
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:54:26 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768557266; a=rsa-sha256;
	cv=none;
	b=Z3S4iLq1fALZfqfIHe1/7lgDyYUQrzOjhr1WDtcBvcuHf9qKCA3vEQt+PrUwQedFPfP21C
	UnZrAF6bCpG2dv7FfhJW2kMSATnGV3WlGZ3fLUSTBMRrERXr7JIqb3/iwC0yC9TRQIPNbK
	GXNMtKS+ccU/FRLnO1oF4mWnwT2eapM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768557266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qucOCLpK0VCp0p49hSiIXgcqZKwXcARG0+yWY+O/P84=;
	b=rHNeCCzzRj4jxRxBQ2exLbQRlRJEUff/T/8BkusTojwDXQlIsppokZnxk1O2SlCGvFu1aB
	NcP1sCLyI5HfX7eGHmkVDe/m7uocp1mjdv/eiyLWfXU+B6oASKAK/4y2N2IRYIgrlksuvd
	WAnxkAYMCW25jTGZNZGcgbhJ04LWom4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1DC621515;
	Fri, 16 Jan 2026 01:54:19 -0800 (PST)
Received: from [10.164.136.46] (unknown [10.164.136.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1EF53F694;
	Fri, 16 Jan 2026 01:54:19 -0800 (PST)
Message-ID: <8509450b-e223-455e-b44f-03f77705639b@arm.com>
Date: Fri, 16 Jan 2026 15:24:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable] mm: Fix uffd-wp bit loss when batching file
 folio unmapping
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, Liam.Howlett@oracle.com,
 vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 riel@surriel.com, harry.yoo@oracle.com, jannh@google.com,
 ryan.roberts@arm.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260116082721.275178-1-dev.jain@arm.com>
 <343f8462-44fd-4190-9fe2-8120b5403269@lucifer.local>
 <4b784eef-e874-45a6-828a-4fc2acab6fb7@arm.com>
 <15e2a0d8-e8f1-488c-8fce-c0a2a5182086@lucifer.local>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <15e2a0d8-e8f1-488c-8fce-c0a2a5182086@lucifer.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5srfwp7beyzekyx1qzwmmgysmp5mdpwe
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 858B0A0011
X-Rspam-User: 
X-HE-Tag: 1768557266-458500
X-HE-Meta: U2FsdGVkX199Lcjn/5YgN6jNIkl6fmIF9sKw7RQacZ0ZKshfDPXvW/HAIucUUTDKAR1gIqxYN70Yj2bY4Tri2KnFsSh1N8SCeCcM8Y25NbKvsCBsFliHi/SqveafWumQLe41uOebiVO1sWiHKErnTKHi3nsUpUO+DNr+HKAaOdvx4K12GCKIj37zGZl/LVIFlXkt9wVVfnPMN+opiNDCwgGO+NSPn9wNE4SccZSimBmBvfgl+BF4Yvq4D/P3wvTNBEUWnxsbqQ0IQzKbWoFASwDN4HR7QG0gjyUsCXhDr9FmL+BsvQGKKtmvrg1EOSfdyhdsbL0jVONjo08goQIf6KS5/uc8iNmBEXjXbvH+HYJ2sgl3B8GmMXnKCpA8Ox12WR6Bq98RClQnEmUvdxBRTPjGzNkjwAoX66GsGbt0Ly5PK5bVKplEdcKx+VZoGsFaf9jwCJPUakFDFaiqx/+ODPLkAltQcHxoEf3vDdT/JGHCwk+Tre6BvWNuDaEd9UAn2hqY2Cd9qoO+5iP8zfaD8pnfpeN54qpQD825Lx2ppE+0kKEe8ZjQP5SsRjpIhH8OLKdcW6smINYBuuZ6ZghNPdKdT0T6bQQBjvo3NmHV6LzxJKgfNQ31NMj/b+eAWKS7mZ5rDFx4/bDxDmc+GAS69wzxplTd5D7tOH5uMLVejDw9uLOi6syHNIoUsh8rDaGNph2PfkkkVGXVVNx/rIR2ylFnBJZEYx2Rl2AzXxC6JnrVwQz11tjYveKRcWeOETB7Zmw++Q50bcoEFPWl6iiAZ+UfIEFaGZHenFttKURzSzYCB3C8pkfdMlNG1v7E6TCjbjCmF+mA4IUga0wh5nBadg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 16/01/26 3:18 pm, Lorenzo Stoakes wrote:
> On Fri, Jan 16, 2026 at 03:10:23PM +0530, Dev Jain wrote:
>> On 16/01/26 2:09 pm, Lorenzo Stoakes wrote:
>> I saw that the last comment on that series was more than a week back, so best
>> thought to just do a folded fix on top of it - and I had formed the impression
>> (from the conversations on list) that akpm prefers fixes over respins : )
>>
>> If a respin is preferred here then I am fine by that.
>>
> Generally we prefer fix-patches, sent in reply to the patch being altered and
> sent by the series author.
>
> Sending a patch with a Fixes: tag is never the correct way to fixup a patch
> unless they're upstream or unchangeably-bound-for-upstream with a commit hash
> that will be the same in Linus's tree.
>
> You can by all means suggest a patch to an author by replying to the broken
> patch, but then it's up to them whether to take it. Also then the courteous way
> is to raise the issue in that reply and say something like 'it seems that the
> below fixes the issue, can you check it?' or something like this.
>
> But the correct course is to the respond to the series in all cases like this.

Alright! Thanks for your kind explanation.

>
> Thanks, Lorenzo

