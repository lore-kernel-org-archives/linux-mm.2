Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0065C9833F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 11:00:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D4F6B0096; Mon, 28 Sep 2026 07:00:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0E3A6B0098; Mon, 28 Sep 2026 07:00:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FC916B0099; Mon, 28 Sep 2026 07:00:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 781BB6B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 07:00:15 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E7609140198
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:00:14 +0000 (UTC)
X-FDA: 85262876748.08.EDBD2A7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf24.hostedemail.com (Postfix) with ESMTP id CB28E180007
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 11:00:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UTg27kSp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9VkpnhhM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NrEvgq5j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AIpXs8ht;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790593213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w2S8+GdwVQT3oIDF7iUf4yAkw9CJO+ecLy3lo1BQi1k=;
	b=yaNUkUNjHHng9i2HCFMVLuLFX0EbuwlriBIOcJXnjJxXS6GVdYlh0ldc5s6yb2orqKAQ0D
	xThLKYsIsUEUxSOrTvU6XugXeypqXDElNh57GO/1RKzJbney8/pvtG15hQNuP16Xc5q0Wc
	JnhTl6PVugsF3yyLuc25GjV7yx21iqQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=UTg27kSp;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=9VkpnhhM;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NrEvgq5j;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=AIpXs8ht;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf24.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790593213;
	b=UDXiUqfgClxxDDkzQsAqcScxaZZscz9+rnn/krhmHij6TvjhqXfYIC3Q72hlDcuAY1OKHJ
	3qdsUNN82yd5WvVyJ2qfNzb+680jFsrefNpxla36rTuZAGNBfLicT+LGdfDFIluLd1WCsd
	8E7vSrHpUog99g0gD25whOzIjFKq2J0=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 225EF1F44F;
	Mon, 28 Sep 2026 11:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790593207; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2S8+GdwVQT3oIDF7iUf4yAkw9CJO+ecLy3lo1BQi1k=;
	b=UTg27kSpSkCSNvIviojIfZQ7w+K14eltFeyqd3ci8DBUMCZuPqT2gROSTRGcWU+tIML74N
	IDvMpXMppmpIFpbYQO6M9iqTr3Ds+SbQuErq/yXzgJe894+18mqWw2Mb2XJMmo6WWAu145
	Mpu/0BBAPZ+T1Nwk8R8JwoW6ShkqJVU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790593207;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2S8+GdwVQT3oIDF7iUf4yAkw9CJO+ecLy3lo1BQi1k=;
	b=9VkpnhhMT9rMC2CT7BiNGr9nNIgmi5H9TJnyyzMZOKNHRGJr8c5YyzsT/jNuB748WiZrZp
	mm72vHAZhv5CInCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790593203; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2S8+GdwVQT3oIDF7iUf4yAkw9CJO+ecLy3lo1BQi1k=;
	b=NrEvgq5jAqieiU4GgvnuDimNk0r8QlH/AZrRhUSVTG5qr/Nu1YEOhzMNpmUfpmiUYErCc2
	xSzp1PCjc6EgtDhWCDRaNSpTSt/27QlwafoHp7lX0nNvV6Ved6rvi1obYt0qd1iX4xcsix
	IQQV9Tr53VsQPdns+noLzGO5Z3/t+Sk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790593203;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=w2S8+GdwVQT3oIDF7iUf4yAkw9CJO+ecLy3lo1BQi1k=;
	b=AIpXs8htZcGwyt4u7tUmwElrCeomOKxxR+aNCCiIk17haoB+VJ4mpVYHF72sPuhIUUKZBv
	XO+6hyDvCA6mTaBg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 268BF13418;
	Mon, 28 Sep 2026 11:00:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ZvjgOLFIumpIIAAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 28 Sep 2026 11:00:02 +0000
Date: Mon, 28 Sep 2026 12:00:00 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Jann Horn <jannh@google.com>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] mm/mremap: fix locked_vm leak from MREMAP_DONTUNMAP
 self-merge
Message-ID: <arpInHieR4dtSqPK@pedro-suse.tail5790ac.ts.net>
References: <20260920-fix-dontunmap-partial-self-merge-v1-0-6ffb556f8f8b@kernel.org>
 <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260920-fix-dontunmap-partial-self-merge-v1-1-6ffb556f8f8b@kernel.org>
X-Stat-Signature: 9h44huayzqw8xcbzuxiho7od6oeoewen
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CB28E180007
X-HE-Tag: 1790593212-104464
X-HE-Meta: U2FsdGVkX1+gNIGdtSuuDpxGVv53pXkTn/uI94IcdqmzrhW6wnxEDJRQVmJ3NnIldMGmqMe3whLhx9AtXBs1C/ztLN/j9xxqWJfVKimZUmvSN1wB5iFNgROaNLQ5Nq47MSHEYlEU1bT2KXNIZ2yQ5XlRFhHwL/A4Ro4zJivEYPBiLo1BqKYPzhXCVZfWv6PN/lAb3wHCyd0+qtEyH4Q/se53HBOAOqcPi5u6betESj0EDmoabWczzViAwbpPLNcrNUTNUvYDYW255V6xCSnO11GWxrXLHXdys5MbIxyfm5XCanlsSCLZ2wXNH0p0VTxuPQF4t5MLu/6WL9PitpDYUHzfhkb6ewOztpqlBo0HTBzUrWIkNaeFoN7/dIqMVU0NpSjLkUAUiBnI22PmYEG6eqc1/02yeBKYPyaW/DJyg9m9kHZmgeFHdgGbyWLHY01x1UHHTqyTIh8GVCdr9BEQ7hB/XiZdfolEpV11UDtfwu0CLD+GUgqPkeM9Xo/dfq9PXITLm3cWZIWDCPk6EAdgUBIZsAY0+88Khr5sxrmOCHdDqVkv8b1YYXtpKCY1F2CHq2dHqMUKDZR+AyqFNJcaJ7nuXugiY0yHxgsRlK37+G0qQb8EhGcfiAZf1PeM+xWEuylC01j+2p7wjtCZib1prGu9QX1/iYmKCjWMLoCuY8tx4NknE355RktQqCIrlhSZ0MS7nPiSFu1KQqs+bGDM48hgSGoDtgk/HPKGh9T0hHiQEyJ2HLQAT4jpdbVOUVvLMW+WIU6KQXo9cCUgsFvzix7DS/cIsNUV28ao3eV7Llf7gz7H1h9AqBv70mj6vm8/3ehrtjnO168oo0au5Prmag1guNuNU4PkfNsTRd0ezmKcL2IV1IZW1JbWHYAoYGj+YZj89O+7THyS5DS3dvpXADncbdO8dhQFwwN8mT7MqOs+1fwv7CMEFO405zECf75gDRJtk/eYjPEdm+hE4XZ
 NhXwRO4c
 Em7Pi8EtnSr7YqHJ8sSm294lg1qjU6s4YEDKdOsFuNcDt1FumR8p7U0Q5SyMV5062zKyCSElUjM6+88cPZSIkIUtV51BX+Q33Een/osht+6Mus/x0WnQmoAdialwJbFCK2Iqifz8eVPYbAOOqsqw4oA2KLjl3J2dOG0hSau5GJYofeyowuUWv03iExfyk7KuHPbNGZ0Uuw4XWo9zMtL0YqYsVrXmDVErFHHDRT4Cgwyt1N9ihY5N0T6QhDdxxN1Up/RrACL3IOxv/IpH8GBDnIdiQ6voiIwo3oFRDli423SeWIOpRkwrJF5oWbRNa8/lkna18p+K1atuUqh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 20, 2026 at 03:13:10PM +0100, Lorenzo Stoakes (ARM) wrote:
> The MREMAP_DONTUNMAP feature is highly unusual in that it permits mremap()
> operations that keep the original VMA in place.
> 
> Historically this has led to a lot of bugs where non-obvious interactions
> occur between existing mremap() operations and the original VMA.
> 
> Fix another of these - self-merge.
> 
> Self-merge occurs when a VMA is moved in front of or behind itself and the
> attributes of the VMA permit such a merge.
> 
> Practically this can only happen for unfaulted anonymous VMAs due to the
> page offset equality requirement for merge:
> 
>                            |------------|
>                            |            |
>                            |            v
>         |...........||-----------||...........|
>         |           || unfaulted ||           |
>         |...........||-----------||...........|
>               ^            |
>               |            |
>               |------------|
> 
> This becomes problematic if the VMA is configured by the user to
> mlock-on-fault, i.e. the VMA_LOCKED_BIT, VMA_LOCKONFAULT_BIT VMA flags are
> set.
> 
> MREMAP_DONTUNMAP clears mlock flags for the source VMA and maintains them
> for the destination VMA.
> 
> Self-merge makes this impossible (there is only one VMA) and incorrectly
> clears the destination VMA's mlock flags.
> 
> This causes a leak in mm->locked_vm as clearing this flag does not
> decrement the counter and the VMA no longer has VMA_LOCKED_BIT set so it
> is not decremented on unmap.
> 
> Resolve this by simply disallowing a self-merge in this case - the source
> and destination VMAs are kept distinct and then are able to have distinct
> mlock() flags.
> 
> Update dontunmap_complete() to make the now-redundant self-merge check a
> VM_WARN_ON_ONCE() instead to guard against future regressions.
> 
> Also update the VMA userland tests to reflect the change.
> 
> Fixes: e346b3813067 ("mm/mremap: add MREMAP_DONTUNMAP to mremap()")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

