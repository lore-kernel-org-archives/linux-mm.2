Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED0DCAC5B9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 18:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A701D8E000E; Thu, 25 Sep 2025 14:46:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A21298E0001; Thu, 25 Sep 2025 14:46:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E8B58E000E; Thu, 25 Sep 2025 14:46:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7A5808E0001
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 14:46:42 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A2BE13A4E0
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:46:42 +0000 (UTC)
X-FDA: 83928653844.23.B32A554
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf07.hostedemail.com (Postfix) with ESMTP id E13F640013
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 18:46:39 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jVfBOaxV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c+XpOmjC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ef+qXcgc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0BFWXYIA;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758826000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vm3JvwQjV/UqjTVcE+o2pRBJ3UDo+akHZgLnAEywFnU=;
	b=7RvndH8SaYO+22KVW/pUgINj1sw7E+VdX3IQFa7U+OjOwHRouUs9q3EVMb29Jt3NtzA+1i
	6WsCakwHqvXi0gkvltWztpoJZ3g/yQT5qeYKMQJs/BQvIYUcA2jgny5FCCFNxWwKzv8m/O
	4qg+wICRG2+nWfuVsOqaxvBWXtb9cqs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758826000; a=rsa-sha256;
	cv=none;
	b=1T4xPKYEtakdHYwuiXXB7YYD7T47IO0UxTaOFglKoqO6fQTgCNZijPHHHcWDp7HrtNDUeU
	aRZeggjv76Adl1U8oh0Uhoh/RqpgtBCUGNvd0TMMR22W0fabV1b6PEgaHz9EzwxuaIW7SS
	NTvElYpv5Ij6TQKzxRdK/UllF11IQp0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=jVfBOaxV;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c+XpOmjC;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Ef+qXcgc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=0BFWXYIA;
	spf=pass (imf07.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D80A53F90E;
	Thu, 25 Sep 2025 18:46:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758825998; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vm3JvwQjV/UqjTVcE+o2pRBJ3UDo+akHZgLnAEywFnU=;
	b=jVfBOaxVvMAdBvV2urTjTfj4gYp+QqVAtVD+GoF7uG2DQhBQEu2MLXpd9sZ21j5ntFfcb1
	T1S7xKcgaTfHIuCKVF8bNmmaqPbSCdI9KA0WIp/IFI1FO0VEdq+du+eCcOxVCHOPwt+JVn
	buNfiN9o3COEilMlx55Jvdu+nJsQ3oQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758825998;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vm3JvwQjV/UqjTVcE+o2pRBJ3UDo+akHZgLnAEywFnU=;
	b=c+XpOmjCDeAQ3/Erjd/FRQVLIKFRKcwn0l8yr5zH6dNFi3Xx0GSTdTk/0XtZPOOj3fK0er
	q2CqEfyiOE5kU2AA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1758825997; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vm3JvwQjV/UqjTVcE+o2pRBJ3UDo+akHZgLnAEywFnU=;
	b=Ef+qXcgcTjDF9f5dtbRBT1s6aXO9psNfwJ6RDxq6vDfIWD9naK6johjZE3O7oiiYqN2nUp
	BxMQqe39bGUCijYnt6ASV3ub9gofJIMXoawhSq/5X9pHIk+o4jYGXNB7hMCwRj8IcnpMLA
	hUD3ppX/tdhNWNoq3nocWYQ9H/JzSL8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1758825997;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=Vm3JvwQjV/UqjTVcE+o2pRBJ3UDo+akHZgLnAEywFnU=;
	b=0BFWXYIAdZYvfVcKuHfnuBb7omxCt42fe9EjAQsNyr7xq2wce6Rz1NuBBkkuxayOljixot
	OMYiUY912bipTpBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BDF00132C9;
	Thu, 25 Sep 2025 18:46:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id /JsGLg2O1WjoEAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 25 Sep 2025 18:46:37 +0000
Message-ID: <3bab750b-0aa5-4df5-9be1-9132c7980f2b@suse.cz>
Date: Thu, 25 Sep 2025 20:46:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH follow-up] mm/thp: Requesting status update on alignment
 performance configuration
Content-Language: en-US
To: siddhartha@kenip.in, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org
Cc: krill.shutemov@linux.intel.com
References: <e3d003e7d0b7a5b0840f08cd7d630fe4@kenip.in>
 <595a57cd68463194fb2d6f34e9366e38@vger.kernel.org>
 <0197c80c5bc7989b858b79317a4fbc45@kenip.in>
 <4ffd8306e524480d6dccca2bd9981091@linux.intel.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <4ffd8306e524480d6dccca2bd9981091@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E13F640013
X-Stat-Signature: wpnksophqrro5cw6gd58m96n3tf8rdtt
X-Rspam-User: 
X-HE-Tag: 1758825999-498773
X-HE-Meta: U2FsdGVkX188t+rs4aI2pOEyxN4rjunbgPIZa6a8PTvsoi9Zxz6GnMJA5zNL07WJkEYcuSJORHTJdV92n1ihjD50/dTltZpwEQyNY4gQAGaViaxixw62yswzOKPvLIV3DtQJQZ+fC3hiMmL0GfcvvA9eup0DouqNOxjq4QfkK8e4M3l8QTG3tTEXxsRFGMheqbb6ql+XS9DElaWX3vyZHB9hFR7RLon77Ja67i26dXBCKuFzgTQsde1vtckVO+JoOz6hDDDbb2G5wqHIrI/g9C2eylAezgLkLHQP/eoiwu4diT9Wr5aMcfWRn4LHjtIKApuUkKzPKCuyhNDH2GYppbPE2SWmZaQ+T7T57lcsv62lA+xfrAbxB2Ev7t7EndW9waPLlcQY81QdckCyXbjf3alTYPcpDkf2Su47QtjpcF71DIX02/YpMdDpI6lDuJ+YZmQCuGtx+UDff+EW3tY7FT1dNrH1KA9KrXKb24DAGEKX8TBerJ46NHK/pUd6GpcYFR/jl47wDH4SujM87x0bSTsEJcPc8XOwG9f/j4KoG2mn7i+GWMozL5xlP48nRunuzCEM1UTI6l6cypI3u+qrgC1pr0Dr16+3BWnOo0QHUDF2ukoulHM4VI6GkoH9RylwnvmvsJAFzjPErFU7ZGW6qrXySjroVP/RUmcabYtuB7xy8Gl4n+XzDc8tcMAYYHJsTns9JprrJ80CKsC2SHSbBorpuIchXFnQrxMOooKHyOxZB/x+EZehhZfGp11wJEmSOw3WwtT75W1mUIUdNIUF2sFau2kI0dqFaqMofHeUe8Wobc1OTddYlLAOWmf8zt5ORwn6YPwun5wLWFuYPl7GDPLOE+rxXLF00lePajAf2l/VDupNaRyW6iuDP6xTV2rz62JS796HEW1UIj59tIf8Yr8w7Cwz44Hoq4WarxmooRKNbyByJFLYfQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It's rude to send emails with "request read receipt". Lorenzo explained that
already in a response to your off-list e-mail week ago.

On 9/25/25 15:54, siddhartha@kenip.in wrote:
> On 2025-09-02 18:38, siddhartha@kenip.in wrote:
>> On 2025-08-12 05:20, siddhartha@kenip.in wrote:
>>> On 2025-08-12 03:44, siddhartha@kenip.in wrote:
>>>> On 2025-07-28 16:30, Vlastimil Babka wrote:
>>> **Pseudo-diff of relevant changes:**
>>> ```diff
>>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>>> index abcd1234efgh..ijkl5678mnop 100644
>>> --- a/mm/huge_memory.c
>>> +++ b/mm/huge_memory.c
>>> @@ -102,6 +102,18 @@ static bool __thp_enabled = true;
>>>  static bool __thp_defrag = true;
>>> +/* New performance configuration toggle */
>>> +static bool thp_performance_mode = false;
>>> +
>>> +static int __init setup_thp_performance(char *str)
>>> +{
>>> +       if (!str)
>>> +               return 0;
>>> +       if (!strcmp(str, "on"))
>>> +               thp_performance_mode = true;
>>> +       return 1;
>>> +}
>>> +__setup("thp_performance=", setup_thp_performance);
>>> 
>>>  static inline bool transparent_hugepage_enabled(struct vm_area_struct 
>>> *vma)
>>>  {
>>> @@ -245,7 +257,12 @@ static bool hugepage_vma_check(struct 
>>> vm_area_struct *vma,
>>>         /* Existing allocation checks */
>>> -       if (khugepaged_always())
>>> -               return true;
>>> +       if (thp_performance_mode)
>>> +               return true; /* Aggressively prefer THP in performance 
>>> mode */
>>> +       if (khugepaged_always())
>>> +               return true;
>>> 
>>>         /* Rest of allocation logic */
>>>  }
>>> 
>>> Please Note:
>>> 
>>> This is a pseudo-diff since my initial work was developed on Intel
>>> Developer Cloud workloads without a locally cloned copy of the exact
>>> committed files.
>>> 
>>> If there’s interest, I can provide additional benchmark data and
>>> extend the implementation to expose runtime toggling via
>>> /sys/kernel/mm/transparent_hugepage/performance.

Sorry, it's necessary to send a real patch, not a pseudo-patch, including
the test results in its commit log.
> I fully understand the complexities around VMA merging, Rik’s earlier 
> patch,
> and possible regressions noted with cactusBSSN and ebizzy workloads. 
> However,
> given the continued performance relevance to AI/ML inference pipelines, 
> I
> believe further testing and validation would help determine whether this 
> knob
> can be safely integrated (or adapted) for wider use.
> 
> Could you please share the **current status of testing or review** on 
> this patch?

We can't test or review a pseudo-patch. It's not even clear to me what it's
trying to achieve.

> If there are specific benchmarks, traces, or refinements needed from my 
> side, I
> would be happy to assist in generating or providing them.

You said you saw improvements in some benchmarks, so re-evaluating them on
current mainline with a real patch would be the way.

> I greatly appreciate your time and guidance on moving this forward.
> 
> Thank you again for your support.
> 
> Best regards,
> Siddhartha Sharma
> siddhartha@kenip.in


