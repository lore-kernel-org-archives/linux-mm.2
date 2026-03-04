Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE108EF8FF4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 15:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22B0B6B0096; Wed,  4 Mar 2026 10:20:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5036B0098; Wed,  4 Mar 2026 10:20:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E1E16B0099; Wed,  4 Mar 2026 10:20:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ED2236B0096
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:20:46 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3713160617
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:20:46 +0000 (UTC)
X-FDA: 84508742892.02.3DF26B3
Received: from server5.hayhost.am (server5.hayhost.am [2.56.204.6])
	by imf19.hostedemail.com (Postfix) with ESMTP id 243A11A0011
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:20:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=beldev.am header.s=default header.b=TD3IVr50;
	dmarc=pass (policy=none) header.from=beldev.am;
	spf=pass (imf19.hostedemail.com: domain of igor.b@beldev.am designates 2.56.204.6 as permitted sender) smtp.mailfrom=igor.b@beldev.am
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772637644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mX5xi5pnw48tZ6ndL+Q6tsRAoFyZM7RJCq8H2Y5C4cQ=;
	b=xm3bTKfZ2hpH5/zeaq7rWelJhPNXz313hLm9g26UTtO44xp9wHWuicM8kAtAxGK4URRwcQ
	46tbAaRUknuKR8rOAAi87peaImRUg0Htyela08EInXXyJ39B87L7nzMs/VUe6Kv74MRmGP
	9ufLj/GQFDyqoe5paa2mGa+FHCiPer4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772637644; a=rsa-sha256;
	cv=none;
	b=5YUtJfMQVDei/lOS0b3vIZXWaERhHWJozsgWCbaHVTJoc9yyu/rvwDXYkzfjmYxSJUAOIW
	MU78Cy1wbblWktyRTexLXWVoh3x9FoNMuT7c2rqHvlJy4ev+Tk6iAv6J9bhgjzSoR/XjCR
	SstJo4i/5gGRY8n+7koDdvK/fd0iak4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=beldev.am header.s=default header.b=TD3IVr50;
	dmarc=pass (policy=none) header.from=beldev.am;
	spf=pass (imf19.hostedemail.com: domain of igor.b@beldev.am designates 2.56.204.6 as permitted sender) smtp.mailfrom=igor.b@beldev.am
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=beldev.am;
	s=default; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=mX5xi5pnw48tZ6ndL+Q6tsRAoFyZM7RJCq8H2Y5C4cQ=; b=TD3IVr50CCch9kFYqwvCyJElaA
	HZh/f6kXjXvgMSNCjRO0xJqVY0JD3XP5h3LdDtw4a7m3DpmjQLJwI4e2BRBvIFJkpGiUvh+8MZRX2
	13NKwLleaH/tBVFRQbhCRkmzB+zOpEO6r815T6g19KTF+7QPR/zF7ZNGvUXLsA88bf4B8YBh47zAO
	qFdwx3JxgGIognBJ22q5TSOjmRVKlECpwJFRE9y3HCI28M0572Zp02sbCU1e5kbsd2NLX7aEEdngV
	rP78g8mOFZBK+vR7HBKCKzF0KP2vCdItI5dUIqdT4o8sZhCTYvTivr8yrxvrckQjuwNE9uJDfLZs3
	03xUFC+g==;
Received: from [::1] (port=20058 helo=server5.hayhost.am)
	by server5.hayhost.am with esmtpa (Exim 4.99.1)
	(envelope-from <igor.b@beldev.am>)
	id 1vxo1d-0000000086I-0rIo;
	Wed, 04 Mar 2026 19:20:38 +0400
MIME-Version: 1.0
Date: Wed, 04 Mar 2026 19:20:30 +0400
From: igor.b@beldev.am
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Vitaly Wool <vitaly.wool@konsulko.se>, Andrew Morton
 <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Christoph
 Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, Roman
 Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org
Subject: Re: [PATCH] mempool: fix the race condition in mempool_resize()
In-Reply-To: <aag0PRXyEN-ansub@hyeyoo>
References: <20260304131214.102588-1-vitaly.wool@konsulko.se>
 <aag0PRXyEN-ansub@hyeyoo>
User-Agent: Roundcube Webmail/1.6.13
Message-ID: <98e1c65fec7c47e1ff77ac33d5604ef6@beldev.am>
X-Sender: igor.b@beldev.am
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - server5.hayhost.am
X-AntiAbuse: Original Domain - kvack.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - beldev.am
X-Get-Message-Sender-Via: server5.hayhost.am: authenticated_id: igor.b@beldev.am
X-Authenticated-Sender: server5.hayhost.am: igor.b@beldev.am
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 243A11A0011
X-Stat-Signature: ybomkmu7b63ramuouuegdpr79crtg5w3
X-Rspam-User: 
X-HE-Tag: 1772637643-100687
X-HE-Meta: U2FsdGVkX19cTD9cx/sZZZs+dOzhEZnY94HqGW+YrXKDUkndMNJh8QEWRvC02dw+OrVSFnYlx/+QB+YBm/8ZraS7bJR+eU3BleI21+vmiPvus7q9V44bmS7pCoZALHqfmq5VWRFs/H3nKKjLyadO6nhwk30x2yBlCvL/adZHlVFkwVoUyfV9s9w0oLExgLpwZfAO/pgYMVyytM0RMLjq3zYon4MHU5zCSuFenuAAdBXz8kTDKnrhTnUOVCYfB64JHsF+CLAWRR8QKOmw9dFo77IC2+Rd7TJKHhOjF4PG2QyoqH3CRptDg4mS7a1UuuEOKLVdUDN3N/t8jpJOj21iR+FgUvZxBjICME5wq8NBel6Iq1+npqc5+rkRxJlx3xcDrvMmcmQmt9WaOtDgZ9aUvJX0Nb7jg/UHny3M3KiJoXnq7ahkvSpBIVaaNGodV5RmmqTAZyHwrWL4KcnoG3f5jQSqSBxgn48x53pUMQAYMJ258hLJBN5QKL5xPkvlfKWHgltsmQhmlTfucI80udAOzxON2PnmvVpw791zHg5/yXSe6vrnGq8t/1PbJorbeARYwUVczMXqCvT+wtFr4creNXqYTGyCA/Jadk3l7D/KTYNYf2u2GIaXghxqOIKahB8PebBbThxPqIGizMJQgarGzZcT1NsYh2G5tAW7ShCVcPvRAOD5oUuM0ELClcKnkka8K4t7z9yqxznPdURJDD/9iPLiY0skv1mUzAjJ8KQ9hF7tVfXi4oV6SCCgeT185gkuvQlcc94MLewo3WLw8G6a9aHnn+5ZoVXOP/s4fgdXWc+n/lsNfSLtl/h7UhlXUrbdC2R2HYqqZtYGJujn1CQkwooXCeAOkaPqmmtScrAPYHrw0R6iLkZKdXr4wdEVHs1foAH24LCS/ObPrqR+LmP5LIbZu4cscUpFg21CwbsqLBmp+vBSNmVe/qIiK4Ih/5kKw8dzt3i0wADWURIIQTD
 7rpbejOw
 M6oiwYbqEvPTO8uQxrSDZjl7rcVrHffmH07P2DaW/QPcPgawR/LiuVP1FdfGwFJx3WD8PdXPGieTd1tjdsIcU1HXW0dMn9RhggAHNt2tMFoK3XLCFicJb+w6HndurvXOPEujsXCc/dMB/gEkPdykUMiblNyJBxwa7eBYRDW3OGz8tmPng0EqDkPPkRFiYXrE88AqXE05znYYhMtAHOUrHQ8qxVAVAM+PPhqJm+r5gqbN18MtcD0gcAdlElVui4L69AeIsluYj1U15RU7OUAZ0PpvzwJ3Q9MO4OonUZ4JuK3RcDh7n7Tnjycb04SNvW6bbM6jFXoj4MSi6HMSUX7cmMg+NV+RVgxIanAOyRWeSM+QnHmqGEMeEEPPR6td/2LHepch2uW4Wwwylnewi000whuYnaN6H/zussPbLUMbw2/wLZMMqi4iTilO+Zv5gwRAOBvGcLSiE3oAP+4X2FzgNVm62AoG2CO089E7GvyyxD4bYHzA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-04 17:31, Harry Yoo wrote:
> On Wed, Mar 04, 2026 at 02:12:14PM +0100, Vitaly Wool wrote:
>> From: Igor Belousov <igor.b@beldev.am>
>> 
>> mempool_resize() at some point has no valid elements array for a pool:
>> ...
>>     kfree(pool->elements);
>>     /* here pool->elements is not valid */
>>     pool->elements = new_elements;
>> ...
>> 
>> If e. g. mempool_alloc() tries to access pool->elements after kfree()
>> but before the assignment that follows, we end up with an undefined
>> behavior. Fix that by changing pool->elements to new_elements first
>> and then freeing up the old array.
> 
> Hi, is this from code inspection, or a real bug you observed?

This is a real problem, not that easy to reproduce though.

> I think pool->lock should prevent the bug you described from happening
> and I don't think using xchg() is necessary when updating fields
> protected by a spinlock.

Can you please explain how pool->lock protects pool->elements in e.g. 
remove_element() function?

Thanks,
Igor

> --
> Cheers,
> Harry / Hyeonggon
> 
>> Signed-off-by: Igor Belousov <igor.b@beldev.am>
>> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>
>> ---
>>  mm/mempool.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> 
>> diff --git a/mm/mempool.c b/mm/mempool.c
>> index db23e0eef652..302d83cbeac1 100644
>> --- a/mm/mempool.c
>> +++ b/mm/mempool.c
>> @@ -384,8 +384,8 @@ int mempool_resize(struct mempool *pool, int 
>> new_min_nr)
>>  	}
>>  	memcpy(new_elements, pool->elements,
>>  			pool->curr_nr * sizeof(*new_elements));
>> -	kfree(pool->elements);
>> -	pool->elements = new_elements;
>> +	xchg(pool->elements, new_elements);
>> +	kfree(new_elements);
>>  	pool->min_nr = new_min_nr;
>> 
>>  	while (pool->curr_nr < pool->min_nr) {
>> --
>> 2.39.2
>> 
>> 

