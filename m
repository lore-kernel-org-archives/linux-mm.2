Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88D5CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 12:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A65A8E0040; Mon, 13 Oct 2025 08:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 430098E000F; Mon, 13 Oct 2025 08:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F7738E0040; Mon, 13 Oct 2025 08:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1831C8E000F
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:55:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D4C731DFFA9
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:55:12 +0000 (UTC)
X-FDA: 83993086464.02.A5117C0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf23.hostedemail.com (Postfix) with ESMTP id 5901E140005
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 12:55:10 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GkjrowLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bOc3W2YK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GkjrowLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bOc3W2YK;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760360110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VVs9OlIdsU9AL1nGyPEm5DWgQn1j1x2cPiqI2MlPSgA=;
	b=O6NNt0YPGDQs1FTlxHFww8dUHihHYAbfD9J0GPCa0lnfkv1wmRpX4pQDAkllaFJY+OMhn3
	xdTBpojM/5pKD2b9psbTs61/KsS+ggrJ4GpLndVd0KDLL2R9YUf9PoJpFm+rKM637TBjIR
	/u+EV8TEtVml92bdNEnGwk2vTug5R0g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760360110; a=rsa-sha256;
	cv=none;
	b=ppKOYjsLovEhUYeg2phM1RuIZUSCsF5K/j74eLnRvc6XUoI5Y1p8xuXq2wILWv+g1ddPq0
	YvULO2U7ePEh6H8FJtYh34SsKSix5fuWvPpN4UP1RrDX57ZT4b4T95/oRXepugI9rJ4zOF
	6PVd3TmMymFlNPi8QiN2e3KHcGX1Hog=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GkjrowLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bOc3W2YK;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=GkjrowLX;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=bOc3W2YK;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B15AC1F388;
	Mon, 13 Oct 2025 12:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760360108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VVs9OlIdsU9AL1nGyPEm5DWgQn1j1x2cPiqI2MlPSgA=;
	b=GkjrowLX9VfY+zWLkJxV4K4xBqmYfLzN4bsM/hBAprVZOAZ1HpwGsx4xncjcfhA3F0GKeK
	6HqsDsC6du2/QHiQp0Zx66S945eNt/Dxf75uKYyFyDM8n5SpWgbKykgLDX4h9ZTjaIwOYb
	XYcMIH9A5KI7B9ya57CAHC4EazwrcD8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760360108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VVs9OlIdsU9AL1nGyPEm5DWgQn1j1x2cPiqI2MlPSgA=;
	b=bOc3W2YKBsyCMgUHW3O4ZkGQ/iSS246oALbWzNY1y7DNc/kp3FvbITaEErC9jDPhLXLslI
	ZGayQBVuCD582ZDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1760360108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VVs9OlIdsU9AL1nGyPEm5DWgQn1j1x2cPiqI2MlPSgA=;
	b=GkjrowLX9VfY+zWLkJxV4K4xBqmYfLzN4bsM/hBAprVZOAZ1HpwGsx4xncjcfhA3F0GKeK
	6HqsDsC6du2/QHiQp0Zx66S945eNt/Dxf75uKYyFyDM8n5SpWgbKykgLDX4h9ZTjaIwOYb
	XYcMIH9A5KI7B9ya57CAHC4EazwrcD8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1760360108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=VVs9OlIdsU9AL1nGyPEm5DWgQn1j1x2cPiqI2MlPSgA=;
	b=bOc3W2YKBsyCMgUHW3O4ZkGQ/iSS246oALbWzNY1y7DNc/kp3FvbITaEErC9jDPhLXLslI
	ZGayQBVuCD582ZDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9AB651374A;
	Mon, 13 Oct 2025 12:55:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 7oR4Jaz27GhsOwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 13 Oct 2025 12:55:08 +0000
Message-ID: <d200e79a-9bc0-4b52-bb38-50f5695fe780@suse.cz>
Date: Mon, 13 Oct 2025 14:55:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/page_alloc: Clarify batch tuning in
 zone_batchsize
Content-Language: en-US
To: Joshua Hahn <joshua.hahnjy@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman
 <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 kernel-team@meta.com
References: <20251009192933.3756712-1-joshua.hahnjy@gmail.com>
 <20251009192933.3756712-2-joshua.hahnjy@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20251009192933.3756712-2-joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Rspamd-Server: rspam01
X-Stat-Signature: 3yua65meaepzdh5ej1j1epdtooa37hst
X-Rspam-User: 
X-Rspamd-Queue-Id: 5901E140005
X-HE-Tag: 1760360110-572398
X-HE-Meta: U2FsdGVkX1/HpshAmpklFdXQAyWQXI027pKM/hzgx4+SzaKqOYdSeVpInbJ1TvtdRMIT+RRx8/LKGU+Wh37toIdv6elb+rePNqSCkHgHvNwUX2Sx77+uww/3V4OcKxt5BwWKnIiAT0jFGCi+cAChfWvWJa2ZjVbz7gowNyhC8l8aH8wHH9sCHdgoh7kn7W0TaaYBjyqnRRT60exE92Y1F3HW7LjQZtkNnsRwDFuN4iDg1PvpXKQIBFlgIUb0oq+HhpSdBlLWFdwvApQ4ioTb9qG1wChO0kf0NpQnjT7UqThz9TG3jUySeqJY4QgxL6zWouCJkXvJ0MCmMl/vCDxLrK9vjapFav67PoQqWkrBwDqKohSiasEI2WU8SSLylXY9d9i65XBlw765YM/YWgH/SXqSD2PoiSIYZTTJhBY29YB5DY+T5OK8LmxzpRQSO9DWpsnEmRvTfAMwNXiRc61Z4/QJ0wSn7rKVPWKhRMn0cAY+zdmSAeseNYyJ/i5Vy2fEbA8loWeDgkM18HgYGu4blnVyvON6wyW5+AcWqG1varoIZpGQCFHU3/8WHJ07b2xPILwRXe4nVk+uEr2pJJZvwAeXgwcSu9rqs+Vy7A7rjs0bzGpCb6hlyckpZUDKIbjO90A4LtKXufFvCeHoRfi1TziepOW10iEApa9y+D9k2qGtwiPs12Xrc+hdRHUQ/bgzQghlWQTvcvLa3mZyE3kqlKlh5v3hJYfjTTO7PJM2zP7lbOzbiOK72weSOj6kxUXDMQuEPatSMTORWzbbVclBHa0EC6Bc1xTH5YTqNGDCrJpXiWQajPpUOwkxXMzA7Dolm6iSMiJLXwRLLLSZk5QrPt36RSsT/CKudvitRHQKbmO8hof0qsW2Ar864BffKM90zbF/gRePbw+Oawcn4HwhimzN8yF9VnNZqMNlCUFLs2O3FiuR8IWThlfaNa60k3C9F/+wv/H1swR8cWWeVkQ
 Poo6O05U
 IlNtwoNpiFxFY6eXGrhBGbEF9YPqRStroPmoPjfcxbGax0ZBcAFoQG+PmsFr77V5vzXhugs/4JHE1YKaKReT2sLvApEoUh+ZyBCZUCBx1Y4g1ZEd83Z1tnjh5zELMhIJqHgQgJVbk9hxGblcvhgGpnct2fH1AKwRuHP5TdTks62boqyviqou7o7vT9TSq8zqY5KdkwmK3xySNsJYsU3Q9Mtb4DA/7tmLFp3TAKz5LZt1JWNUUPRbNCkZhYcYigA+Q9x/Bolhp9M68C9pFBcRRwEyP77AIpD29DzfDOIXBQ2qGIS366+vNf9TdiFLmhBswJ5rBxez/Ydv2UCdYTrdnLYZVtxp2BIhjsIPOmnUGHcETwhG27vR3sOYIqazNTUDAWxypd0BFRajYc+ABMHnXOzXD2i/d8iqQT03WL7xkO3zdszJItE8t1NMqZyYPRqkjDWC7MUlCLdCkWZs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 21:29, Joshua Hahn wrote:
> Recently while working on another patch about batching
> free_pcppages_bulk [1], I was curious why pcp->batch was always 63 on my
> machine. This led me to zone_batchsize(), where I found this set of
> lines to determine what the batch size should be for the host:
> 
> 	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
> 	batch /= 4;		/* We effectively *= 4 below */
> 	if (batch < 1)
> 		batch = 1;
> 
> All of this is good, except the comment above which says "We effectively
> *= 4 below". Nowhere else in the function zone_batchsize(), is there a
> corresponding multipliation by 4. Looking into the history of this, it
> seems like Dave Hansen had also noticed this back in 2013 [1]. Turns out
> there *used* to be a corresponding *= 4, which was turned into a *= 6
> later on to be used in pageset_setup_from_batch_size(), which no longer
> exists.
> 
> Despite this mismatch not being corrected in the comments, it seems that
> getting rid of the /= 4 leads to a performance regression on machines
> with less than 250G memory and 176 processors. As such, let us preserve
> the functionality but clean up the comments.
> 
> Fold the /= 4 into the calculation above: bitshift by 10+2=12, and
> instead of dividing 1MB, divide 256KB and adjust the comments
> accordingly. No functional change intended.
> 
> Suggested-by: Dave Hansen <dave.hansen@intel.com>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>

Acked-by: Vlastimil Babka <vbabka@suse.cz>


