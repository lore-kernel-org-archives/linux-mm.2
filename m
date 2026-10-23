Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72AFE606A324
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 08:15:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ShGrRr2i
Received: by kanga.kvack.org (Postfix)
	id 9429C6B0B1B; Fri, 23 Oct 2026 04:14:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2A56B0B1C; Fri, 23 Oct 2026 04:14:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E2396B0B1D; Fri, 23 Oct 2026 04:14:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4E3A36B0B1B
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 04:14:59 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5785C1A030A
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:14:57 +0000 (UTC)
X-FDA: 85353180234.02.A43A66B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2755C120006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 08:14:55 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShGrRr2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792743295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=peBrLxQYphAWA0aed033QDkUYmfTpLADSsSaf6bnm8w=;
	b=1Y0xnZitbYhv+GBzRb3Rko8P4sZt/hDNv1oHIaQpskCF8Ofvnx2iFeR1o1uoZOFcl9Res3
	u6tUgFjcF/Vc5W/prVI1p2dKeSINrkUs0zcDWQZIFMNGGdAa18hd9JNBqPxK/hbH0gnNUJ
	ve4Uzuo4yAdkwZ1s4/Rgv6bsXQ8R9Qw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ShGrRr2i;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792743295;
	b=UuxG2pcHHXDgCNyiYHCMzrAyebvpipdQLTCMwAwJ06VZ/LONW5pjwpgU2sTS3NEsvbu3UP
	r6bjYbalxcqgnDirS+5BZWC2EwYhoysY5YZ/mjh6hb36W/DXU9PB0q8YPVKB5QP7bYLrhs
	M61XtLwP8RlOTau8W4H0CbfZNOXJJHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AC366609CE;
	Fri, 23 Oct 2026 08:14:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A641F01825;
	Fri, 23 Oct 2026 08:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792743294;
	bh=peBrLxQYphAWA0aed033QDkUYmfTpLADSsSaf6bnm8w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ShGrRr2i/YYSDBKxdszIqiZelQsGU96ViTWorMdYU/QKsn2y4mEKhwKDfr2twOUOi
	 bluvyJYe7vW0W3unEL8OuMYGiHq5wnA8C2JEDAtOqIMJK85HVrPSmILvI6S630h0qV
	 TwzdHa5YAeaaPPlLoOCozSN57KX7njo3/P7azUXZx7PhcMAz09pCucdBcMHcsJRz+1
	 gMRC3V0Wa3cnF+g2cJ18lFmiZ7t11lRR7EtWOw/d9gecFPVghY4TWrsHsnJkoLJzzv
	 52wSis0Xli+77fsW4MzBqrFxTPuGdZPpr15eZk/eHTL4adAmnhYQ1u2/hzL97MjQXu
	 nuP9WnLNkcBEQ==
Message-ID: <8f09767b-004c-480f-a578-f2722ea4301d@kernel.org>
Date: Fri, 23 Oct 2026 10:14:50 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/8] replace CONFIG_SLUB_TINY with a slab_tiny boot
 parameter
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
 <arU956kfc1QpA7N-@thinkstation>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <arU956kfc1QpA7N-@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2755C120006
X-Stat-Signature: ee5rd49ry7ym8x15jw7g19rfz15qcre9
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792743295-315028
X-HE-Meta: U2FsdGVkX19hFTSDw1NJ+wRhSyHYJV3zIAhsip0jcm8LfbwFQ+7V+rasFIPEAihyu0yIu4pSH36b8rqAvXuIbq+se5RXI5F9YIkS907WTPYldSqAFEQvEHxB4hzRl0a3OEkI+IuraqqBb4ocx95wGt5D8FCyZsqN/lvXUSXO4sPIwPgXk6dMdSfwF9ndAuO36Zk8kXinxtq7B03vDZqEV8VrWnLjKr+hxMS33Tm8VGDV29Obwu2nEJWQ1Xk4wiEbpUrlHgxTJdYoKpubtsw3Et/Zx4aqHA8kXZasaGZqHDzW3ZvHYYTsNFHd65fiFhvzn39wwNjFoAEQze7d+GRtfNrbb6NqRU73S1FlpNZW5QzaS+tz6t0WYa5YEjv1oSZHzbZDgRfogjNNQF8H13pZcV/okVL5bIQoJ/49FxPYxgS6ayinRN/UyoWPGsWOuzR/EECw8qu66GQxDwsydcJE2rBaM0qeTG8m9Gqf3GhLQ8VxoI223RzF3aANpTq1EslEj5acbSZkjWQx+9rJVIS/yz92BeLcpDZdrs15S6Mta1RA9EKBS5OgULKvB/taLh5yk2tCNpJcBln6wcroMXja6AXL9ax0cvzJznB3AfXb3xg8kzUJ8Pil9kzhsB99J2fnxwo7lW+Xoc2a37pn6OvEDqc7BPP/wehHzEEMBTjN5+EMVIyQyd3Ad6YPDFyrlWbJvsCcq4kaprGt8qRFEKsW4oZ6GbOs+jW82zeDmPap4Ul+A2Cj71gbr4KwoXu+nl/7E8an1Kc1LZB7iLVt6oyAODLn7+SvLCy6rxYx3vPmaUNApfDU+aY95Lx9SWUZ4BZ6pSv4PnxKjBA0c5USZ15IcTGfYgQQ0hud8cZr6/rN5sGfMWiaePJm6Ly+G5nPUvaIa2zaQtaI+dMf8oQRsu7CrlAlxlGH8YHahWwD9u4DvHzMKPoEtK9pEapT+DSANdts1fOGthN2CtCeLzvrkYZ
 GelcpN6z
 vbqordwnV9qCpDedxYQ1l88O8iGLtqIGjtmJ7VRb/9NNA1D7NMb8+S4oqy1fW+D2ZnHkY9k2SCyRrP1NpOnAjwt0vQmTnGxKEtAuskvICSrYnRS69PTZpMXApLFC3cqIGrsTlJB4R13gRZZvm/Vbo0QKJPoqfwtgjf2/ebI1ogIuiA4tqKyH0bFJSVD1ALHF2EWN+ktDids6Q5uCS1/jVJPhwDwnvbct4CutztXvO6pCfl/Gf4pPVTQopYsC97yh+jCdsv50HbN0GMrHv797ciDahp4MJW7tV7RSsN6dF/OB2Iec11VrDWNjrGe38PwooBptQLV3sb22z8CjsU7Rs90JH93Wht3wW6Hjg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 9/24/26 17:18, Harry Yoo wrote:
> On Wed, Sep 23, 2026 at 05:45:05PM +0200, Vlastimil Babka (SUSE) wrote:
>> To sum up, after this series:
>> 
>> - CONFIG_SLUB_TINY is a deprecated option that has no interaction with
>>   other options and only controls the default behavior.
>> 
>> - New slab_tiny boot parameter controls the functionality (and can
>>   override CONFIG_SLUB_TINY in both directions).
>>
>> - slab_debug=N can effectively achieve most of slab_tiny and on a
>>   per-cache basic
> 
> Allowing "slab_tiny=0" doesn't make much sense given that
> CONFIG_SLUB_TINY is deprecated anyway. I was assuming specifying
> "slab_tiny" would enable it and not specifying it would disable it
> unless CONFIG_SLUB_TINY is set.

I was anticipating a possible autodetection in the future - i.e. "is this
system so tiny we should do it?" and a way to override to =0 may be useful.

> Also it's bit confusing to have multiple ways to achieve the same thing.
> Is there a reason why we can't interpret "slab_debug=N" as
> "slab_tiny_enabled = 1" internally and drop "slab_tiny" boot parameter?

"slab_debug=N" is a weird parameter to control the whole slab_tiny (which
does more than the slab_debug part). In my view it exists as a side-effect
to how slab_tiny is implemented. But because slab_tiny is implemented using
that, I thought it might make sense to expose slab_debug=N separately too.
It might be even useful in some debug scenario.

Whoever wants to use slab_tiny doesn't even need to know about slab_debug.

>> - the implementation is simpler with many ifdefs removed
>> 
>> [1] https://lore.kernel.org/all/CAHk-=wh-k04MsoEC0SGKff2Snm6bBF_e+0pHOKwaWv4umZ_SnQ@mail.gmail.com/
>> 
>> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
>> ---
>> Vlastimil Babka (SUSE) (8):
>>       mm, slab: refactor slab_min/max_order handling
>>       mm, slab: introduce slab_debug=N
>>       mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
>>       mm, slab: make SLUB_TINY handling dynamic for sizing decisions
>>       mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
>>       mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
>>       mm, slab: add slab_tiny boot param
>>       mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects
>> 
>>  Documentation/admin-guide/kernel-parameters.txt |   4 +
>>  Documentation/admin-guide/mm/slab.rst           |  18 ++-
>>  include/linux/slab.h                            |  17 +--
>>  lib/Kconfig.kasan                               |   2 +-
>>  mm/Kconfig                                      |  16 ++-
>>  mm/Kconfig.debug                                |   2 +-
>>  mm/slab.h                                       |  32 +++--
>>  mm/slab_common.c                                |  12 +-
>>  mm/slub.c                                       | 149 +++++++++++-------------
>>  9 files changed, 120 insertions(+), 132 deletions(-)
>> ---
>> base-commit: b4218126d498275444f315b0ed4cef6add6beabc
>> change-id: 20260911-slub_tiny_rework-8f2634dd17a7
>> 
> 


