Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C4E2D358DC
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 08:21:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 693F26B0088; Thu, 29 Jan 2026 03:21:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641FE6B0089; Thu, 29 Jan 2026 03:21:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F92C6B008A; Thu, 29 Jan 2026 03:21:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E83F6B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 03:21:05 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA50D1A08E6
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:21:04 +0000 (UTC)
X-FDA: 84384306048.20.8F124C0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 652BE4000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 08:21:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="xR/0RAzK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mSJYd8uk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="xR/0RAzK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mSJYd8uk;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769674862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bnoAjIEBZE3yHj9Uu6+mVva3GLy2AXgvwJcLgSTdq2E=;
	b=ZF6Neu44qL/HY8KJdk9Llg/XY2gI+yQ5EioyuEuTt9JaTJ7sNApyBUe/Vw9OT9vU+zj27S
	ccD9WxTI/tludQyT4Nu2xHeOt9jLQgKMnlJoHyLclRZ+PahJchxzxRZbPDDL7aCPtOb/uz
	0uh9Lxc1cmUvA/p+313u2Q9dNm8UxWM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769674862; a=rsa-sha256;
	cv=none;
	b=LFo7wQInKy5jQxldFYr0IljNcppy6XKELffSxH5X7w53xjNNcFdXu9C97NXjnXzPtFnnq7
	d7OZlaACDDmEXkLI2K2OPRQHKQFrDOfhHcvXDqeytWZJ4hW7ZlSaalfjE2wyHP1mlbpmtU
	hdx9RJgd2wyf00DlvG9/9c335sG/3vM=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="xR/0RAzK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mSJYd8uk;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="xR/0RAzK";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=mSJYd8uk;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 95ECA3402F;
	Thu, 29 Jan 2026 08:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769674860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bnoAjIEBZE3yHj9Uu6+mVva3GLy2AXgvwJcLgSTdq2E=;
	b=xR/0RAzKnFqnWlruxbJVJvad6opNrHcevj67zWV6VPMoX9jVYIeTlswHXjFJwv9VAt6+pj
	3t71YrVfzR1V/0zcu0tT+aUS0ss/aA7wQyOe99xOkqEZResS7HTTIKsGhtKnMP5nQrCU9A
	ujhOO4ydpwqAvLhRDbj8sQItQaefcBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769674860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bnoAjIEBZE3yHj9Uu6+mVva3GLy2AXgvwJcLgSTdq2E=;
	b=mSJYd8ukTSAUKe6oOB64FId+oEIgns3dvXQjzbQwwSL7gh2lcc7GwScRux0d5XrVmIRI1B
	Qp2b0Xv+Lqf2FCDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769674860; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bnoAjIEBZE3yHj9Uu6+mVva3GLy2AXgvwJcLgSTdq2E=;
	b=xR/0RAzKnFqnWlruxbJVJvad6opNrHcevj67zWV6VPMoX9jVYIeTlswHXjFJwv9VAt6+pj
	3t71YrVfzR1V/0zcu0tT+aUS0ss/aA7wQyOe99xOkqEZResS7HTTIKsGhtKnMP5nQrCU9A
	ujhOO4ydpwqAvLhRDbj8sQItQaefcBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769674860;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=bnoAjIEBZE3yHj9Uu6+mVva3GLy2AXgvwJcLgSTdq2E=;
	b=mSJYd8ukTSAUKe6oOB64FId+oEIgns3dvXQjzbQwwSL7gh2lcc7GwScRux0d5XrVmIRI1B
	Qp2b0Xv+Lqf2FCDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6A90E3EA61;
	Thu, 29 Jan 2026 08:21:00 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id BxCwGWwYe2mbWgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 29 Jan 2026 08:21:00 +0000
Message-ID: <2cd89ed5-0c8e-43f8-896d-1b7dee047fef@suse.cz>
Date: Thu, 29 Jan 2026 09:21:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Content-Language: en-US
To: Zhao Liu <zhao1.liu@intel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
 <aXsLKxukv60p3QWF@intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aXsLKxukv60p3QWF@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 652BE4000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: habaki88mcba357sr39cy1n7urypx6ws
X-HE-Tag: 1769674862-372742
X-HE-Meta: U2FsdGVkX19cMCwjQUiz5XXAh9BfmwGYVpZptnl1N+TBADuElJBms3pH/i+jMCJdwzWlC+BdEu8npFlPbpc2iDJzGBQDnGE5HkCGw9Tl9KyucPTvOMvWVwPHIgXBEyFpgtwZgv9j/+GHDQWIclwE6yk/lj/MHOZVScChlzhHQiWTJlxiDWYWoaLTwdqXpm6XHqAkuEKeSiRKnlNJ21uM/V3U+9O4Zsj8bj6oAG6U+71JIJg+p5vcPAsdH5EJ8CUPexoqRQH1wy+tNIjanxD5fp1iKUNiPKYceMZLm32JkzQL9GPUCue3wd8o3uxvAvyzKf3t80TKMhULFsRjfvswVpWekiuhXjD2CGLRjZOTbBO9nHRZL/XmY179n+TENOMI71iW5BKn4zAw7pqC0HLytcCn0BEmFqoyuMKd8rjxEQ6d/BP/yf61dl9K2zsgq9+SXnjsgTA+O1H2anyTRKCU5NJkSH1O3CGE19u/5ErLZs3KtxwBeOPCgc3UciYxnpl2nddZzQnjcrv4DKJTk9/MTmsa0OTH6wVshy//EA789CTOKP7yFV368m1iZi5lHg2F+u2fCOFs68lnLKKTF7spoFs1M7wFAxAqjY6/tjmPeOByEMprZVWsh+z6Q9HsqRrpi/jb7DcsxfmjZt+il3A8r/BZnZNysxiJagqmkQOeLSEOO4AV92S+o8vj/pDccPc9EzfSd3ZDB2EUq6jWPg7I99lfDXIIZzFa55idHtxzaq8xm7e9E7kmIRWDS2J8ekOBXnxUD9HorDoiXbWOOIFH79bzzVJmCCeiGf3f4lBu+eONx4FIHQJH6PaVOK6kZaUU2Hm6jozpv1mYP8euARpFN9FVqDOni2xwuz/oGyMWiKErzSDDQyCvVAhef7lrKcnIODask04Syc9wovC4VxWNoyFWsCuP8x2im94r5L/5zFujB8agb74OxQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/29/26 08:24, Zhao Liu wrote:
> On Fri, Jan 23, 2026 at 07:52:44AM +0100, Vlastimil Babka wrote:
>> Date: Fri, 23 Jan 2026 07:52:44 +0100
>> From: Vlastimil Babka <vbabka@suse.cz>
>> Subject: [PATCH v4 06/22] slab: add sheaves to most caches
>> X-Mailer: b4 0.14.3
>> 
>> In the first step to replace cpu (partial) slabs with sheaves, enable
>> sheaves for almost all caches. Treat args->sheaf_capacity as a minimum,
>> and calculate sheaf capacity with a formula that roughly follows the
>> formula for number of objects in cpu partial slabs in set_cpu_partial().
>> 
>> This should achieve roughly similar contention on the barn spin lock as
>> there's currently for node list_lock without sheaves, to make
>> benchmarking results comparable. It can be further tuned later.
>> 
>> Don't enable sheaves for bootstrap caches as that wouldn't work. In
>> order to recognize them by SLAB_NO_OBJ_EXT, make sure the flag exists
>> even for !CONFIG_SLAB_OBJ_EXT.
>> 
>> This limitation will be lifted for kmalloc caches after the necessary
>> bootstrapping changes.
>> 
>> Also do not enable sheaves for SLAB_NOLEAKTRACE caches to avoid
>> recursion with kmemleak tracking (thanks to Breno Leitao).
>> 
>> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
>> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
>>  include/linux/slab.h |  6 ------
>>  mm/slub.c            | 56 ++++++++++++++++++++++++++++++++++++++++++++++++----
>>  2 files changed, 52 insertions(+), 10 deletions(-)
> 
> vm_area_cachep's capacity seems to be adjusted to 60 and
> maple_node_cache keeps 32 as the args setting.

Good to know. It is a bit larger.
Hm I could have probably applied the args capacity before doing the roundup
to make sheaf fill whole kmalloc size. Would add a few object for maple node
I guess.

> I still use will-it-scale to evaluate the impact of this patch, and
> performance results appear to be on par with previous ones (*) - doesn't
> have regression on my cases.
> 
> Based on the results of previous capacity adjustments testing, I think
> it shows that the capacity of the maple_node_cache appears to have the
> significant impact.
> 
> There may still be room for optimization in maple_node_cache. As a
> general-purpose algorithm at present, I think it has achieved its
> intended purpose based on my test results. So,
> 
> Tested-by: Zhao Liu <zhao1.liu@intel.com>

Thanks!

> 
> 
> (*): The previous ones include 2 cases:
>   1) w/o this series, and directly based on the previous commit ("slub:
>      keep empty main sheaf as spare in __pcs_replace_empty_main()").
>   2) w/o this single patch, and based on the previous patch 5.
> 
> Regards,
> Zhao
> 
> 


