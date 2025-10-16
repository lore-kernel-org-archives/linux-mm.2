Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 223F1CCD19A
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 13:18:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BF2E8E0013; Thu, 16 Oct 2025 09:18:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76F268E0002; Thu, 16 Oct 2025 09:18:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6371D8E0013; Thu, 16 Oct 2025 09:18:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4898E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 09:18:42 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA4B8140315
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:18:41 +0000 (UTC)
X-FDA: 84004032042.09.7071DF6
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3B9E3A000E
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:18:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dbnd8t8u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zvuPBjFf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dbnd8t8u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zvuPBjFf;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760620719;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OpLoFhO55qvXCeDSb7iOIrT14k8fZCmzlAT2djDZro8=;
	b=kyi0NNnWNN0d5qi1kpzDScgugRKGP5i9wD5GuLStsWzO0DNXSRQSyTdz6f2+oRHHpdC27C
	IgwspvWu7EL5rPRPnwxg5tcHeuxSgqsPmpNXZ/PDJjBYKSK1FJnqL9T10FTTlC9CYMGXWV
	I5arQt87CfZiGAnAN2JBIgtoxW5McsI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dbnd8t8u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zvuPBjFf;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dbnd8t8u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=zvuPBjFf;
	spf=pass (imf25.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760620719; a=rsa-sha256;
	cv=none;
	b=FVf8wEkH4BWwm4tfmAMgSlwv/tF5kHBsJItkX28zUl9yTU5WTannta42ZJgn65c1HmNrfs
	d2CQLl6snk+HjS5cuwqcZBTGn9d+Cwr/QMhjE5C2FK5E2Zti127YVYRi+DblPSTAqGcqsf
	lSYBI3OFopF0F+GSoMfoWbRLoqd5958=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 65555218D5;
	Thu, 16 Oct 2025 13:18:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760620717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OpLoFhO55qvXCeDSb7iOIrT14k8fZCmzlAT2djDZro8=;
	b=dbnd8t8uLQkbNc/NSTihLLGx1dltH3xDCI4PH64Wqf2A3qv7rosnVa5zwviVN3jZT9y4u2
	TH77bEfWkxXkkUiW04qH+ZiOXkBvMnysVYuVtVpQ3bEKzPa67DsBiYn2SNQp5b8o6CwqYd
	ZDjfgjniBP0shiMsVevQpFgomyqtowQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760620717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OpLoFhO55qvXCeDSb7iOIrT14k8fZCmzlAT2djDZro8=;
	b=zvuPBjFfEEHya0Hpgowsl+Npc73ts7wIQ/X5S0XK1B2pzX4gBBKK998c81xBWz43gn0ol+
	Iz5i61dREyu9zYDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760620717; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OpLoFhO55qvXCeDSb7iOIrT14k8fZCmzlAT2djDZro8=;
	b=dbnd8t8uLQkbNc/NSTihLLGx1dltH3xDCI4PH64Wqf2A3qv7rosnVa5zwviVN3jZT9y4u2
	TH77bEfWkxXkkUiW04qH+ZiOXkBvMnysVYuVtVpQ3bEKzPa67DsBiYn2SNQp5b8o6CwqYd
	ZDjfgjniBP0shiMsVevQpFgomyqtowQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760620717;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=OpLoFhO55qvXCeDSb7iOIrT14k8fZCmzlAT2djDZro8=;
	b=zvuPBjFfEEHya0Hpgowsl+Npc73ts7wIQ/X5S0XK1B2pzX4gBBKK998c81xBWz43gn0ol+
	Iz5i61dREyu9zYDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 420131340C;
	Thu, 16 Oct 2025 13:18:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id g/LWDq3w8GhyOgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 16 Oct 2025 13:18:37 +0000
Message-ID: <d64db373-cb98-4142-ba44-1aa5ccbdcb45@suse.cz>
Date: Thu, 16 Oct 2025 15:18:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] slab: reset obj_ext when it is not actually valid
 during freeing
Content-Language: en-US
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Alexei Starovoitov <ast@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hao Ge <gehao@kylinos.cn>
References: <20251015141642.700170-1-hao.ge@linux.dev>
 <CAJuCfpEpO_HaJuV3ukDtTdw_5zCq9R0MnMexC5PoEwOcKWjuYg@mail.gmail.com>
 <0928dcc7-a4e0-4641-9381-6adf2ad30493@suse.cz> <aPDud4tUzZ_NxE_R@hyeyoo>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <aPDud4tUzZ_NxE_R@hyeyoo>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 3B9E3A000E
X-Stat-Signature: 5ohoztqagjssp4d5tjuswsnf47unjdzr
X-Rspam-User: 
X-HE-Tag: 1760620718-107011
X-HE-Meta: U2FsdGVkX18J61AS4cgnjvx6f9XUnd113d9Evj0nZehr9dy5f4qs/f7nK5eVsb4VnQsbhCoh08wPyXw/hHAZ9oyy0aHpAwGLl905hYlb/6tFvz7PlbbRBHUMWtPq+Z3vl0XCVao+hSIa7FzXrnGaCLlWXE3IVLOAkTtZ4fIJDye8Bt2Rhj4csXrSi7CBlxyJGJSiy3KLlJ/Y8+FSYi184LC81IJVNKvXXGMEuMcHDHELDpoCAgyCCSymnIUyBSBrdDtw3PTt9SJsZESS+WD9kE9DJ2JWdmZZxUn1IOH8Ge6DFH7Ld2Yc4kxe2Wgo5xWuLQ3NAfZJfCoF+pLRZHegnNx88uXxc8IVroGaPwAeaosta5/lpLwMXIIBLHuvaum7TDSkNOfPYLkMEhLGNABGui9PJjAtCQkyRoMgSnfR/BNt1ekKR5tEmxQ761h9DilAxWqLr1I0QI7x5jtuVwO756Ga2T/etbEx7NGN0137c8hZfy3xBeE974I82Hf1uu/W7xfO+bYamyIvDVBCiv/Z48CDZPwEip3UJ0NxbYCsfYZg5Yl+I2KBUKuYdIRMLohpMqt9d6flBCzjahzpYeAAO25l5S4rmQCRhOwq8WtAK0flm9ELPgMWgvNLcA7++JXjsYCkYef1EqJkqob1575RESiPVRlYiDVhQ1aXcdYYG7qUZTsBgF8Wu0cN5/ScvpD0UvaT5/ooDVqZHSMdswUwFQS5OOWQUijXNRg4iU0ZB7mybzoJo4DCh6CnF9VwVe3bWkPUmirUOLj5i0G4dxh7BVW6V7MMlAVSDGLzzRb3pdbq7V4wqc2axFJQ+BBdSUNY1OXOA8RN8LYdE+A0sKGz37PNtbVdOFNL2eo6F2oqDZp37pVy+sOSSi8XGsH3vj2w5UT+5SgGxAR+Sund3vcvzolAoFiyzcLGm24T274ahnz7FrKxdqdChxgD81q/6kynejxlkAvgNO0eFkn5BAj
 0LIWtYfD
 myaiFb6SG8+lCW6D+UtxJO46zAKInnFGT8PuvGya/XqRQFk94v+PwZUJ6bbFVBnrXLEr+he9n+ZN8xLrsT+/0cj9KzX0JJ82jCec0vaLzbkx9QSDrnOqTQaZZ66KwqsO/vO2HV0pqBq43zRvOlDQ9C3CixujEkHk4L8KU17+2xHbqCeX67NtnhIYO5/iTsvD8rguSQhOuRb7FPUVujLo4xHBDYG1BugdiH/uxiLkeAgWWfG7CdVMiwD13N5GnuJ1avrySbqf/kKV9GuVFf1gaq9Ol/3OIsvllSbbHH4ZTEGA+wh+308DOLfEsFKv9ZK2rw1nv5OOH5Fus5tvVyFFpLAkwk78pWIv/vLOlBmqYwbsygpB8clhstkJq0EmEEgWZwAYD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/16/25 15:09, Harry Yoo wrote:
>> ----8<----
>> From 8151384e5baf34db5812ed51e2e463796ab6e973 Mon Sep 17 00:00:00 2001
>> From: Hao Ge <gehao@kylinos.cn>
>> Date: Wed, 15 Oct 2025 22:16:42 +0800
>> Subject: [PATCH] slab: reset slab->obj_ext when freeing and it is
>>  OBJEXTS_ALLOC_FAIL
>> 
>> If obj_exts allocation failed, slab->obj_exts is set to OBJEXTS_ALLOC_FAIL,
>> But we do not clear it when freeing the slab. Since OBJEXTS_ALLOC_FAIL and
>> MEMCG_DATA_OBJEXTS currently share the same bit position, during the
>> release of the associated folio,
> 
>> a VM_BUG_ON_FOLIO() check in
>> folio_memcg_kmem() is triggered because it was mistakenly assumed that
>> a valid folio->memcg_data was not cleared before freeing the folio.
> 
> nit: maybe this can be massaged as "a VM_BUG_ON_FOLIO() check in folio_memcg_kmem()
> is triggered because the OBJEXTS_ALLOC_FAIL flag was not cleared,
> causing it to be interpreted as a kmem folio (non-slab) with
> MEMCG_OBJEXTS_DATA flag set, which is invalid because MEMCG_OBJEXTS_DATA
> is supposed to be set only on slabs."

Thanks, applied

>> Another problem that predates sharing the OBJEXTS_ALLOC_FAIL and
>> MEMCG_DATA_OBJEXTS bits is that on configurations with
>> is_check_pages_enabled(), the non-cleared bit in page->memcg_data will
>> trigger a free_page_is_bad() failure "page still charged to cgroup"
>>
>> When freeing a slab, we clear slab->obj_exts if the obj_ext array has
>> been successfully allocated. So let's clear it also when the allocation
>> has failed.
>> 
>> Fixes: 09c46563ff6d ("codetag: debug: introduce OBJEXTS_ALLOC_FAIL to mark failed slab_ext allocations")
>> Link: https://lore.kernel.org/all/20251015141642.700170-1-hao.ge@linux.dev/
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Hao Ge <gehao@kylinos.cn>
>> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
>> ---
> 
> Looks good to me,
> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>

and this too.


