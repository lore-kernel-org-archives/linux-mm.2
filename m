Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94F9ECA0FF7
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 09:33:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D35678E0009; Fri, 29 Aug 2025 05:33:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB8558E0001; Fri, 29 Aug 2025 05:33:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0B1A8E0009; Fri, 29 Aug 2025 05:33:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 965298E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 05:33:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 49943BA5A6
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:33:11 +0000 (UTC)
X-FDA: 83829281382.20.DDDE373
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id E4C0E40017
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 09:33:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kKOt/Hzn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v4KjrK6S;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kKOt/Hzn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v4KjrK6S;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756459989;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oa+DMVwAY2xMfVjXIc/WRlc7wZwmUNXh+b1Og+c6PcY=;
	b=tovl6l26fRmrgmD76/5eoDFxn5tITh7ND54Qc3Xw8hISxqBuPVlX7ji7J57Q2Yvm/+FdJn
	ZTxpbMq4OHTfYiZQhkkUHSF+rSryZs6EJnMvIGKFb7rNQSfq0ki7sa4joNE/2Y+62WOrCQ
	EZvqCVb8EIX0qC2rfcyEPU5NbDfsbpY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kKOt/Hzn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v4KjrK6S;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="kKOt/Hzn";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=v4KjrK6S;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756459989; a=rsa-sha256;
	cv=none;
	b=OG8tf640whbQVHzyBOPSj5iXN6yx5mpgdZLxgWkG6y2wTf2Ybn7l5AXHP7vkcXWQfl+qh7
	JQxveVO//tWzkKzgRcX+2HTOVX76Y16Dk0zSP/kYUDAIHTqW8LRPpKwG4QVfmXY5/aOvaa
	Zo7+XU9ERU5ykl/m18GnGXYx/FlzmK0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7A3E9220D0;
	Fri, 29 Aug 2025 09:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756459987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oa+DMVwAY2xMfVjXIc/WRlc7wZwmUNXh+b1Og+c6PcY=;
	b=kKOt/HznvXU+fx1+n3ueqMzZyf44ajnO090mrX7wsHl88g2qBJ3vICx4JX+jj1WSoeST8m
	yJ6x19iJbKXdxSJAOBcGa0U1NDHUZn0+dgn6/P8azYigmspJNPGdur5ODdQXLKn7Vsxv54
	U7iK6ug/JQH62EF7GtI8ePYi/wqTEA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756459987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oa+DMVwAY2xMfVjXIc/WRlc7wZwmUNXh+b1Og+c6PcY=;
	b=v4KjrK6Sjv1xKLmnYg7ne6zfpj7paQ/L8/JZf72gJ5DLZkAXrzIqZlgi3ZqWk22MsqzG/w
	r+waTjWYJPBQ6tBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756459987; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oa+DMVwAY2xMfVjXIc/WRlc7wZwmUNXh+b1Og+c6PcY=;
	b=kKOt/HznvXU+fx1+n3ueqMzZyf44ajnO090mrX7wsHl88g2qBJ3vICx4JX+jj1WSoeST8m
	yJ6x19iJbKXdxSJAOBcGa0U1NDHUZn0+dgn6/P8azYigmspJNPGdur5ODdQXLKn7Vsxv54
	U7iK6ug/JQH62EF7GtI8ePYi/wqTEA0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756459987;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=oa+DMVwAY2xMfVjXIc/WRlc7wZwmUNXh+b1Og+c6PcY=;
	b=v4KjrK6Sjv1xKLmnYg7ne6zfpj7paQ/L8/JZf72gJ5DLZkAXrzIqZlgi3ZqWk22MsqzG/w
	r+waTjWYJPBQ6tBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 42FB213326;
	Fri, 29 Aug 2025 09:33:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +pIOENNzsWgCNgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 29 Aug 2025 09:33:07 +0000
Message-ID: <226704e2-e268-483f-8322-0820030ae4f3@suse.cz>
Date: Fri, 29 Aug 2025 11:33:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm: memory-tiering: Fix PGPROMOTE_CANDIDATE counting
Content-Language: en-US
To: Shiyang Ruan <ruansy.fnst@fujitsu.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, lkp@intel.com,
 ying.huang@linux.alibaba.com, y-goto@fujitsu.com, mingo@redhat.com,
 peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org,
 dietmar.eggemann@arm.com, rostedt@goodmis.org, mgorman@suse.de,
 vschneid@redhat.com, Ben Segall <bsegall@google.com>,
 Li Zhijian <lizhijian@fujitsu.com>
References: <20250729035101.1601407-1-ruansy.fnst@fujitsu.com>
 <23765f70-e869-4ef6-8ddd-24c0b1548fb2@suse.cz>
 <10659223-9bbe-468e-b458-ccd421590b7a@fujitsu.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <10659223-9bbe-468e-b458-ccd421590b7a@fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: E4C0E40017
X-Rspam-User: 
X-Stat-Signature: 6et1kgojuuomitwxbj9e8xsssiknaguz
X-Rspamd-Server: rspam09
X-HE-Tag: 1756459988-289745
X-HE-Meta: U2FsdGVkX1/M3oj813kw57NBKSnk9pu6Iy1hGhtsIlZ79khaEpsCtBAO5gWLmVw7M/7eMgC/B5YRxXrsFbo/5Ek/A0HzlyWQDPw2L+RbYrHOCKtaPc++1YLYZlQ2xA7gC5Zb0bezPVGpe/9GnxFATW6zRyGlc1UW+yrEf36SecPan1E7dc884mY1bDWFCeE4gT0o7r8El9MzBK8NVzLZRbGlWG5LnWqNVaE/FGCjmKvHPpYf56VCBB/0xj6d/lsinsGaLqRB7CR+aF+K6PIZK/HnRbP7gaZokgpMXP0EFdtB4nZ41eKUe0pxNnDqRhnR1xISEhfeHOl4xMV8dU5FFZDzJc8sh+LS2STASmkJpsFVilj95udxmhkwMgx1gUgSvmTeUPpBVnLfVBqO7YBrt0DKQwppKgMYPfl0WhMpYvAk8QJQmEnWYH391HG9hKr1PKrEY1ze5pIPPKNk9D4/VuqyRbeInNwHXHXGS6vKZpkpNvErnia2h8avINdfJrEu7rA/s7wSq3J+krxDQTKqv8HHWBa0b3LwpI1zOwgIjAkuaYOKl4iYmYdfabGqNwv9VKbMn8Lu/O7rPHWePRmiROghjR/scaiqWOvuI6atqP3kwsltnZFUW9SIZEuXti4l6xx8M7w8ib8FDXwDdzBcBreeTeCxppOkzvLxdCr9GLpq4eN14zCfLS+ruYBCCQwi75jBnPEnUHYBGah9+rDAD4ytRWl7nXkivL0R6Ca/53lADETIZ3RKYpr3CUUktVFKLFL5f80RGmCGtElqRiUfsqRHaUHnsMWxeuZEcVuYEYSh+TOQwLGVFxQ4b+/pkKhKnjLV9sOYDmR3DuoUk5KlVPQqcPA3z2ULWRhUiXA23eXhavXCfznzJHnavpHuHoTAtTVKpi4MN+O6ktnBWPfm8BKIGtS8iXVwLYMJPDRrZ7XgnHQFT5ZjXgmPz0Fs0wQXQ2xynn7rzu5qZJECIY9
 6buUGO1A
 xDTdUtcRhI8hqVJTpel3TJ0c8kD+/81LZtVbTIVHDBzgFDAG6jdDA3J0rZjgrJkpHv4zLgffpXYWcdsZ2ZIqlXmxZs0vnok0QyReG8oMoBmZ+Zay2tHU3BpYrLPNIss/Q8DO1eNdlZ3oTewJ3w9rdCajANFeme8bICj7Je6T5PbjRpOeIycJfEjolrKQrTSBI2DbyHLIWt/CqcUOw+R0qUweturCW9hAxw5AS/2zthNzPtjGeqxriqmxOYsv2RCQjiRKgNGmgZQU3JuMsR+gwunXYd+NArUVgcFwhV1xJHJdPc8Kxof2lOgFsPoB0fJ2GyOl9NAO8lRbf11M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/29/25 11:18, Shiyang Ruan wrote:
>> 
>> So the S-o-b from Li doesn't match anything now.
>> You can either reinstate that "From: Li ..." or add a "Co-developed-by: Li
>> ..." right above the "S-o-b: Li ..." - that's for you two to decide who is
>> the main author.
> 
> Thanks for pointing out.  I wasn't aware of this.
> 
> I'd like to add a Co-developed-by tag:
> 
> Co-developed-by: Li Zhijian
> 
> Then, should I resend a new version with is tag added?  Or you will do that for me?

Yeah it would be best if you sent it to make things clear. Andrew can then
replace or update it in mm-unstable. Thanks.

