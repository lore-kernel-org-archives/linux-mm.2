Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 43EEAD64094
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 08:46:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66FE66B0099; Wed, 17 Dec 2025 03:46:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 647436B009B; Wed, 17 Dec 2025 03:46:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51C656B009D; Wed, 17 Dec 2025 03:46:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3D6FD6B0099
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 03:46:40 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C4292BBE67
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:46:39 +0000 (UTC)
X-FDA: 84228332118.15.268876A
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3B027A000B
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 08:46:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kseznyEN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MQpQSaEJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kseznyEN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MQpQSaEJ;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765961197;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j+v4olVIB/Btqfowzf3p4j/NyeP0ecxzrNKIrJm/YCg=;
	b=jMoub3wlgDEPQriZK/LBPkndemssB2Li9zX2zY6B0J+3Kac7Amnzzt2o/1ysUwFb3aIUFF
	4M19N+3AYC815UGIBYHwrUwP6sJDjPI0YvxLYDxkc7EkwFZB+A+JUayv+LwVMkw6QgWkcn
	DMJj08WsYFeBER/ML0A3RfyLFsahnmM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kseznyEN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MQpQSaEJ;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=kseznyEN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=MQpQSaEJ;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765961197; a=rsa-sha256;
	cv=none;
	b=Cvnany8YJZZvRrgsFJBw+jzvBrgVHlDPjl2xE3S/05pW73LbqBCsTJcwT0zavXhYG+qwPG
	A0rQUSvyN83uNcazZbI8/MqmRaMO41Cs5ug6ozcArdEvC2J/OWu4+5dqIGkeUj8Og6DpPY
	lFOm+HSuxEMuJ6b9/RqzYHp0bliIOxk=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 81B875BCC6;
	Wed, 17 Dec 2025 08:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765961195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j+v4olVIB/Btqfowzf3p4j/NyeP0ecxzrNKIrJm/YCg=;
	b=kseznyENi1AcWJH9DqGCwyyQFcIUXmYmimrAHT5PRV20Zp7y4u5S8g8/EvWUAqOcXzxC2d
	UTH1ZSC/DNeBRky1oI2L+1p4RZC5awysFpM3JSRMj+LnYHmlPrkSOiEEUnM5Y3nf44i3PP
	aCCr88XeIG+K8BZozBwzy1aiew8c5kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765961195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j+v4olVIB/Btqfowzf3p4j/NyeP0ecxzrNKIrJm/YCg=;
	b=MQpQSaEJdn77OIjPTFY4Xon9FpCTgIXZze8zOTr7oH4ZJJc0oHXxkdLTGrSQMZDdS+JMsR
	k+BWT4LEuC/RDGCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1765961195; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j+v4olVIB/Btqfowzf3p4j/NyeP0ecxzrNKIrJm/YCg=;
	b=kseznyENi1AcWJH9DqGCwyyQFcIUXmYmimrAHT5PRV20Zp7y4u5S8g8/EvWUAqOcXzxC2d
	UTH1ZSC/DNeBRky1oI2L+1p4RZC5awysFpM3JSRMj+LnYHmlPrkSOiEEUnM5Y3nf44i3PP
	aCCr88XeIG+K8BZozBwzy1aiew8c5kc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1765961195;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=j+v4olVIB/Btqfowzf3p4j/NyeP0ecxzrNKIrJm/YCg=;
	b=MQpQSaEJdn77OIjPTFY4Xon9FpCTgIXZze8zOTr7oH4ZJJc0oHXxkdLTGrSQMZDdS+JMsR
	k+BWT4LEuC/RDGCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 613513EA63;
	Wed, 17 Dec 2025 08:46:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id VN1bFettQmk/PAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 17 Dec 2025 08:46:35 +0000
Message-ID: <9881b540-7e22-404b-aeaa-282dc5eeb5d5@suse.cz>
Date: Wed, 17 Dec 2025 09:46:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/2] mm, page_alloc: fail costly __GFP_NORETRY
 allocations faster
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>,
 David Rientjes <rientjes@google.com>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>,
 Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-2-0e499d13d2eb@suse.cz>
 <20251216203243.GJ905277@cmpxchg.org>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251216203243.GJ905277@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zqq65otiadu4urd18nana6dupswa99tc
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B027A000B
X-HE-Tag: 1765961196-984187
X-HE-Meta: U2FsdGVkX1+6Jc6b+NuVEhqkvk9YY47gBewVB1rwy5jGCSHkcndiFqvusL7ysdMK2WTiC90aBnh6cVIoukIruq7kXgiQYLCy1I0AtWk8cVIFOpxGkhkF0ONlEXmbSgG/04CgUa39vHHKU4x+ThXGspMDwzDNxzGZQJAVoOlpilKg5efZKT04nW31S9GdRpIon8TtJE9Fh/VHTwNIdmOyNvbO/UjD1e1VXTK66jq7Z8+GmEzYFpU+YSNkl8ClNzZLhsmptUyeq4cH6gvXf0Hs3IZfOC79a8WIeKp20ubSQ+ZH9BhcFYx07Zv2bbYDc5QtFtLvubqZ8lEcBmNJx+24lj0dRzIXdrCoyR4rVtQGDbIHs2U3jcGi2/7rUCFsshAkMN3XcqFQsR8sEbCGvVU+nK7zjq2hpj6IuYIV0HV4EHvPVuy6iZE6+rqh923vmyTj9fR49ZbhCsR9yWkA2l3K+Fr/sjeEy5D82RVQwZaRYU5x8MQbstBgvnGa4zLHghrr8kag6MGvjWk6TH/pxdXq3f3reLv7x8Ko9menBIIPdy/BwmQWtWbpHpwOnuXZ5jLLTlYvi+0288q/b0XiOefR7Uw1u6V1u3fkDj/xNGYac36B5ezeF3gJj8QsAiaKywW6lXuj0bRbg1rqdblLu/TNr3JYXiyiNHuxfRkCgfiT6ouMqS2OCl0ayZk6v78eplWnp5Q6NjrcG2ElujI1sBRRTzqCjv36gQIv1I1mIzee+UB9mVP3beOhRhMr1qCUw1tymkgfYLmTngraKj2+ByLxzRC8h6gYam1hLODeiWvDJ5sT7ZyWpbo66bMV7SrZFKwKrL0mn/1A9DwIXq7/hCU/ceMM5QAedmhQAl9joPNGscfddUfgsB6X9MrVBfwaXl5AoHyJ3cqG8WbIajjXtKyzkgwrMmZpNWuM8hX3ABgL08nhtULSTJb6BYmcE+G6VT305AiumV4b99nazA1Oq/G
 iXWL789H
 4v473ZpLH2970kPJW5Ge1lxqlOsb7VwwNUWW8PMlRKQHRhAtTat5cUJvuSbCnLxoUXTqLXxEvYrekw801cO0PwE6iqFPxnRGdFCaDalmYHYhbMGjvnk+GIlbB8Any8aRBrMn/OGL+0Qbnqz+kaXVI97Kb1dXoxugcT4dp04ULgOqiJIzoxiMebeBSwAeoneqoyb955H/Bm2SKIuzozq1+uX2sQtOnGDjo/mqOYTa6I1tNOY9Kng/HC2e6E0+PBitwg7dRwX3Y7/K/e4YK/xf/sXSmZPY0QWBv/H9Kw/UKEFfUuaV0etqDK8GUWfdXeWOVllnZqYhBPmUTfSiaq5+gvsk6vT/2mLSZRL/qlzxcbo1PyNyEG6mvpOrXDmSOkDJVmSljiUOiLESjl/FmP3NNXhR7jA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 21:32, Johannes Weiner wrote:
> On Tue, Dec 16, 2025 at 04:54:22PM +0100, Vlastimil Babka wrote:
>> It might make therefore more sense to just fail unconditionally after
>> the initial compaction attempt, so do that instead. Costly allocations
>> that do want the reclaim/compaction to happen at least once can omit
>> __GFP_NORETRY, or even specify __GFP_RETRY_MAYFAIL for more than one
>> attempt.
>>
>> There is a slight potential unfairness in that costly __GFP_NORETRY
>> allocations that can't perform direct compaction (i.e. lack __GFP_IO)
>> will still be allowed to direct reclaim, while those that can direct
>> compact will now never attempt direct reclaim. However, in cases of
>> memory pressure causing compaction to be skipped due to insufficient
>> base pages, direct reclaim was already not done before, so there should
>> be no functional regressions from this change.
> 
> Hm, kind of. There could be enough basepages for compaction_suitable()
> but compaction odds are still higher with more free pages. So there
> might be cases it regresses.
> 
> __GFP_NORETRY semantics say it'll try reclaim at least once. We should
> be able to keep that and still simplify, no?
> 
>>  		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
>> -			if (gfp_mask & __GFP_THISNODE)
>> -				goto nopage;
>> +			goto nopage;
> 
> IOW, maybe directly select for the NUMA-THP special case here?
> 
> 		/* Optimistic node-local huge page - only compact once */
> 		if (costly_order &&
>                     ((gfp_mask & (__GFP_NORETRY|__GFP_THISNODE)) ==
>                      (__GFP_NORETRY|__GFP_THISNODE)))
> 			goto nopage;
> 
> and then let other __GFP_NORETRY fall through.

I did consider it as an alternative when realizing the potential unfairness
mentioned above, but then went with the simpler code option.
With your suggestion we keep the THP-specific check but at least remove the
arguably illogical compaction feedback.

