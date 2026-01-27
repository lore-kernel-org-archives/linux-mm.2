Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A201D2FEC0
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 17:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33266B0088; Tue, 27 Jan 2026 12:02:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB7086B0089; Tue, 27 Jan 2026 12:02:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B647D6B008A; Tue, 27 Jan 2026 12:02:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A2A166B0088
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 12:02:02 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F213689929
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:02:01 +0000 (UTC)
X-FDA: 84378361242.07.6B947E0
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 72B4440005
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 17:01:59 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KsX4eWvK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4xSd2MZv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KsX4eWvK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4xSd2MZv;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769533319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6VzosSxBHLNs4vZ2mzLFRG099l7jrsWQvS9jypSwPAQ=;
	b=ZtpgpVtu9aYByK/wvyAkJGOB+TZ9tpBDycJvfGiC0tj3zwFaz6fofFNg0edQfaaBu8nx1P
	IGEB4t0YCwwSPdcdcubqk8ClUSP1nPn25ejAzN32w9esTWH0peH5hVz4P7yYRRi8rZ+qKU
	YqB1vceK+sBg8zijQSPWpPthsHgY4eI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KsX4eWvK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4xSd2MZv;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=KsX4eWvK;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4xSd2MZv;
	spf=pass (imf17.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769533319; a=rsa-sha256;
	cv=none;
	b=fcNrPkaEwgvYxepJp8lg5R6BzhKQamYihkl/HXxwtbear/yndjQPCy+TMOJ7VPlMhII2Ih
	Yecoi4WQhcots+pfEIiWpg54zToMHcR+PlZxJKq12qnjn3yOw5M4dzM7KLIWyHQEmJOzxP
	lEUOwHKabQpO8wrhJcXUhUmiB1KtlC4=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CEAED337E6;
	Tue, 27 Jan 2026 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769533317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6VzosSxBHLNs4vZ2mzLFRG099l7jrsWQvS9jypSwPAQ=;
	b=KsX4eWvK3US2CuC9SheihY3dpMf3pUSXB4wszy89D+uPRIA9Va2BufLM+RqGEYKmx4Nfdm
	iJlfjrhetBgE2iPDTrxGgRqfBvRlMQbrDM6KfNPObbQ1hcGaLJCKFrVESyhXBDIFlAyQGg
	LcLmquOt0akAreRWGlzcS1GVEO5/Dfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769533317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6VzosSxBHLNs4vZ2mzLFRG099l7jrsWQvS9jypSwPAQ=;
	b=4xSd2MZvPUOu84tcRppkllQIONTsXuIC1PVOQLuZMyWKQAxFy3Ir1KitvFCj/mk7W+k2dH
	jYuzes8BFMGNANDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1769533317; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6VzosSxBHLNs4vZ2mzLFRG099l7jrsWQvS9jypSwPAQ=;
	b=KsX4eWvK3US2CuC9SheihY3dpMf3pUSXB4wszy89D+uPRIA9Va2BufLM+RqGEYKmx4Nfdm
	iJlfjrhetBgE2iPDTrxGgRqfBvRlMQbrDM6KfNPObbQ1hcGaLJCKFrVESyhXBDIFlAyQGg
	LcLmquOt0akAreRWGlzcS1GVEO5/Dfs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1769533317;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=6VzosSxBHLNs4vZ2mzLFRG099l7jrsWQvS9jypSwPAQ=;
	b=4xSd2MZvPUOu84tcRppkllQIONTsXuIC1PVOQLuZMyWKQAxFy3Ir1KitvFCj/mk7W+k2dH
	jYuzes8BFMGNANDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9F9283EA61;
	Tue, 27 Jan 2026 17:01:57 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 9FaSJoXveGmdWQAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Tue, 27 Jan 2026 17:01:57 +0000
Message-ID: <a9c34ec4-936c-4386-9624-662561f87b84@suse.cz>
Date: Tue, 27 Jan 2026 18:01:57 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/22] slab: add sheaves to most caches
Content-Language: en-US
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Uladzislau Rezki <urezki@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 bpf@vger.kernel.org, kasan-dev@googlegroups.com
References: <20260123-sheaves-for-all-v4-0-041323d506f7@suse.cz>
 <20260123-sheaves-for-all-v4-6-041323d506f7@suse.cz>
 <r3qfus4j6awmixdbcopgva3lx2l3lrvlvuoqqns64q6qp33qep@2hsrrvfsojsm>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <r3qfus4j6awmixdbcopgva3lx2l3lrvlvuoqqns64q6qp33qep@2hsrrvfsojsm>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 72B4440005
X-Rspamd-Server: rspam07
X-Stat-Signature: a3md586mkqpsb4gc7hhmjsfqs7yk7t49
X-HE-Tag: 1769533319-802968
X-HE-Meta: U2FsdGVkX1/Df2U4xkmMal66S4v9aLpmgUx8UZocAjvjgb3tYmV6TiIKmddcnkmHYPLiCG7wjfx2uZoumbrzmlg0QCmtBu1OzKiKCjIQzN4FEx4YCn95VIzKA/ncjoR55Q0TyCa07Jb/wXL+eL871sx2m8n4yzF0llqLQUzhClc0jLy84YftbnH+9PIA+Ip6yqHnJl/SG+jPATXaQMgzbXQOLc/r9lMdDYqHXkiOX2UlcvrzkkFWAloDI/1ThQoIR7Reockg6NcLi1wT9guKxDyTzIjJRixLQmKaD180UMhYHqFk69wnycf/6AHGH1mvSbnUYAR2dF6/AxieSiU7Y4GWMYLc3UmjgHFQ+Bzch7xqeaShWvLb6Eu4G1SZmrQoucu0IwrW52qkMw8fMH+Xjpsh2A0H6i8dRo32oLbW7EsfDz9KJZc39N7fA0d2lPcKAazg2W32lw9aEMC9U7s4Iz1OtJN5ryaT+qNOCfjYfOWSwbAmINDGfFBeOOifX1cUFGSWRiTJw5HzOcHZDJCLoqaaQOhH2RY38ynWPEI+mggjItCRfO1ItLHzBKIXMkB4cVfoeLr248GwaD7hPgi1rS9xVyPgSU8tf8H3NCnCRWzf6eRkMSEgZFMRuos5wQH8uhO3+Y1sSNO06dVg45XYv1O/WgmvBkSwpqdhqEM/1JF1Oe0O/fV3pbe2L9YRwqnNPfkk88QrxxY9yBwmfmfGYfF4nI5MY48eb+jHMyeoMeXPxdt2rLL9kG13VPoBTB/nbYuxsPEe+KkoMjof5m+nvNRqLbKvWQBzWtF38Bpab4ZW5boYHeGKb3p3V+j4IR4+hORqPDwPDVU7/Wbaog5AVySI14de3qaesasBGuzNO/JWHbvKkODUeCPs4xyzUIcXZA5xLraxXVFhmhz9iZbUuR3BgmG3ub4rt9mThkcRCKVjW1WIeKCF8x3QpMrOnCo6O3gnadFKgwfr0UT+IuD
 DbcRvB3d
 fWTx1eji2xrfoDWsmXVZqLq5r16VNBOHM9+aKe1Swl1f84ERdRNTP16Q4wZN0A0twpbHU8t2qCHYDMJTVb8M0Pm0t5S0TFQ0VxwTQfSrS+HUWPMYOtvZvg/0t35qrnxVpNo6zz4zZW4VV3jJ3ciaixb9oGzXYVA907TFcLz9ZpCtf9m8ryanHOGVc0iw6klNZxvxxZOg6GesN50egSYEHUi6wI82KVKfRtvyTY5dNRjaR8Z2MpTaKpN4F22ZIAlUudwPdO7TTF7nDYL3dQnvbgGIRhBhXDzL1nrdLOiaBZ7FLJ4933tCn/EAKQhC2UGb/QyI1hOD7fu91xlIJKi8ssGiaCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/27/26 17:34, Liam R. Howlett wrote:
> * Vlastimil Babka <vbabka@suse.cz> [260123 01:53]:
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
> 
> Is there a way to force a specific limit to the sheaf capacity if you
> want a lower number than what is calculated in
> calculate_sheaf_capacity()?

No.

> That is, it seems your code always decides
> if the specified sheaf number is smaller right now.

That's right. It shouldn't break anything, AFAICS.

> I'm not sure it's
> practical to want a smaller number though.

Yeah I found no such reason, so until we stumble upon one, we don't need
such support I think?

> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>

Thanks!


