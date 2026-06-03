Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9050ECD6E64
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 09:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB7026B0088; Wed,  3 Jun 2026 05:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FCD6B008A; Wed,  3 Jun 2026 05:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A080D6B008C; Wed,  3 Jun 2026 05:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8EEBA6B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 05:52:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 34CF21C10A8
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:52:43 +0000 (UTC)
X-FDA: 84838137006.14.70A4BF7
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf04.hostedemail.com (Postfix) with ESMTP id AE18640007
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:52:39 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YfPoiDZK;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780480361;
	b=rz7IXoy1wDuCiHbK4NhmpLvEgEQQPWsLqE83q68HTfrv4JAYGTyjDxXfLeULiCvSclllGQ
	CcpUJeaK+TILR6AHPVuWIhOoNiSlgCx051uS9lAWD5SYzfopriMqHwAtC/RhdieScbOX1w
	NpdMtiORXYIokf86GUsRmZSrU5oNVmI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YfPoiDZK;
	spf=pass (imf04.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780480361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9y161r+C4QaUQPCPFY8+/eWlsInhIknGyIgcTTS+Zk=;
	b=GcYvs6J0Zivhf1BT5jEh4KpjDwVor9YjBzKf+Uk8EbyYHtNK1rc+ZoQN1UBtGGklAXyrbQ
	ZPudhz6vEZOldwfYS68Epmdkm5uRQwKoNaoFy9oYlyTIZ/z251bRJPU68n32L8/cRY9AhN
	FkUhAbAlI6E5EwgXbN6aYs+K1DL/hpg=
Message-ID: <bcf95603-a04b-489e-8edf-b6bc4a42192c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780480358;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=L9y161r+C4QaUQPCPFY8+/eWlsInhIknGyIgcTTS+Zk=;
	b=YfPoiDZKbBT/Gq1znLBKg7M/pnDycgPCLsUnM5pAO6QSkWDgpjnE7JiGWJ53PHqcdOxqMg
	0qVAErTuGUhQr6r9xL+flbasJvM6idM4nP8luELXc01opatOy4V0+ugM4O3laFOVhqmCwH
	53iUQ2lbj07rnJO5W0YktFF9XUCDvWE=
Date: Wed, 3 Jun 2026 10:52:24 +0100
MIME-Version: 1.0
Subject: Re: [PATCH] mm/mincore: handle non-swap entries before !CONFIG_SWAP
 guard
To: Pedro Falcato <pfalcato@suse.de>, stable@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, jannh@google.com,
 liam@infradead.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ljs@kernel.org, vbabka@kernel.org, chrisl@kernel.org, kasong@tencent.com,
 baoquan.he@linux.dev, youngjun.park@lge.com, hannes@cmpxchg.org,
 riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org,
 kernel-team@meta.com, stable@vger.kernel.org
References: <20260602172247.279421-1-usama.arif@linux.dev>
 <ah8XqXQycZdbYFG9@pedro-suse.lan>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <ah8XqXQycZdbYFG9@pedro-suse.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE18640007
X-Rspam-User: 
X-Stat-Signature: 99wpfcyrn4qn4rwaccwzbk3tzoqk8sua
X-HE-Tag: 1780480359-588099
X-HE-Meta: U2FsdGVkX1+xGy8M9dkMGSXCzqXo/rNfPeeY6Lwgz0ENUmLjLwLUkdKEi2cQM+vNRbd7k65eJ56IrmDY1G8ZtuC/WzqQ/sgHOiSCmyJldsmM/qaDnl1IZlb/aslrJUt8RnhMVhUZbaqp06oAaQ4OVqAR7RpwJ14jm7Ev8uaS9UpabwlsT9fd6HGHz265NRZHR/gCGETzNdgeRKv6gl+sH672+868xD/xVbNq8slILuVbl4DxCU9agIYtWrP5t9Rzix3eRoOBEYpH1m2dfwdiN188uMeM6cxfR1ukz3ZYrSUoPeFgytfqqIneU0IQGoNGayTb+UGGv6hEWq34je+m52Rr30+YCPqGZXLnU5fCJPs7wA4/098uE6pDiNA/A5yn340KyLq+5Lg3X2IiJ3JzlSBhPAvdnKNGq3vvbHb8ENAiKSqIVMiBVy1mMCNfyCw/JzF3qvfq2NwwwuI2Ds577rvvGspDhR8ZUt3mWqx1PJCraVGAQ6LgHGRuJinxGxVXj2oRm4Do79Z1YgY3K/R0sGQyyUY4Bp5XbX6il5CinJ4at7OiikUCiCCQ/SBt3jgmfUFkQxgWkM8eb5qHwp027a7Yni6w3IetOrNiLlmI8ARcdHx9xOWdBxm0kiBNw+BFWAAsTjKiQ+q9VsgD9QqMo1+0U70TAvtxQIn6damRqKRA6bOdD/AU0YLKnB/6mrghsXZQBe7Q9Hp9VgTfXkH5iYfgZShE5YesWD8SRxYTe4T7AACygyFou/uEqnTCR5YXBDkOwC1XVlrwgI6cycwUuyftkRwAHqENOOPKKGLeo2qLf1aYjWqi52tenqd9xBUHxs3jhhPzq3R6rHFjMN+TB3kI+h9vwYNoYq/OwP+T9WocUUnET4wRT8h77FzT9G27JapbjCZ+K0yUzHC1xlDQSyTnLl8JMv5LwLSnQhbr/SzkkFWwVWOHCxAT20+sOHRLZwHWWMfh19/Dyj7XUxs
 B5kR/duI
 aIRtWtiKImlMvud1jMGtSYwuXfVUDqYU0+pPqEGb6zVbQHzrA5y0qPGdMzSdx05h32cgo84veUMBXscBef2NkcREOv8j4TwU3iXx55B9lAah6XP7oUdvpB02c1oYJBFDli30lGzQ5QidQR38/FmisxO6//yO1k1v1SkRid73VERFhaTwo3dpuOSqq5SB0++K/7BvuFm17Vzx4V9/Fm4ozfIvqFeUKGqtzn7VJ+n3g2SNqHcnELSK3pc6SBnf9oF/Gzveux3Z64WGt1CqRgAlocfRPFYCp0j7cqwj+BwRQrdzzq4sMUmD1MqfQZCWwIFQe6TON
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/06/2026 18:51, Pedro Falcato wrote:
> On Tue, Jun 02, 2026 at 10:22:47AM -0700, Usama Arif wrote:
>> mincore_swap() also fields migration/hwpoison entries (and shmem
>> swapin-error entries), which can exist on !CONFIG_SWAP builds when
>> CONFIG_MIGRATION or CONFIG_MEMORY_FAILURE is enabled.  The
>> !IS_ENABLED(CONFIG_SWAP) guard ran before the non-swap-entry early
>> return, so mincore_pte_range() can spuriously WARN and report these
>> pages nonresident on !CONFIG_SWAP kernels.
>>
>> Move the guard below the non-swap-entry check so only true swap
>> entries trip the WARN, and migration/hwpoison entries take the
>> existing "uptodate / non-shmem" path.
>>
>> Fixes: 1f2052755c15 ("mm/mincore: use a helper for checking the swap cache")
>> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> 
> LGTM, thanks!
> 
> Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> 
> Maybe Cc: stable@kernel.org ?
> 

Ah yes, I have cc-ed stable in the reply to this email, but probably that
is not enough?

Thanks

