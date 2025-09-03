Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D481CA1009
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 09:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85AB78E000A; Wed,  3 Sep 2025 05:26:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 832B78E0001; Wed,  3 Sep 2025 05:26:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748438E000A; Wed,  3 Sep 2025 05:26:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 657978E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 05:26:07 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A53459BE8
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:26:07 +0000 (UTC)
X-FDA: 83847407574.12.871FB29
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 998CD40006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 09:26:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CYrPLbeW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=McADqQm4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r6o3bBqm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C4tR98NC;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756891564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8T8Nj21cWCWy/GFruQ0Nkz1WCXXils8q9OhLNNO9rc=;
	b=eSSsg1ESszgFWkJucK1svfxgL8W2+MmtzfBgyJWjBriaQswhNATJjZ9wKF6xN4sVujEx4A
	7Uc5MlvxK/4/m0f2Ew+t0MSaQIsax8ytt9V6qt1gFUqASQ5FBJlyH/RizGDGZ29m1wwgVn
	uGEUfMkf/w8JnJMwoujZZanVtWwPtLg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CYrPLbeW;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=McADqQm4;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=r6o3bBqm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=C4tR98NC;
	spf=pass (imf01.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756891564; a=rsa-sha256;
	cv=none;
	b=DGpKOnCEy6lO5AMaSHQe2dKO3K6Egm5z0FdutQwdqq3ujZimJN8S5luqScvSlpGeAfuzvW
	ApSJZCi5TEuiq7tiePRs/4/Bxg3N8c0Cl6bzitS4Qe0kv2hiPLbyGXClNAAKHedv5pYwpy
	qDkej177O4i1kStTxc78vP0ltDraSUQ=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 05A741F456;
	Wed,  3 Sep 2025 09:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756891563; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A8T8Nj21cWCWy/GFruQ0Nkz1WCXXils8q9OhLNNO9rc=;
	b=CYrPLbeWfpZSWiwyQYT7m46mVFVtOsT28U+oyY0mCxKVMbAonZbojs1NmqUfc9U06WfltO
	Dz2tZrUgST7qXEJJ9UMld5Kv48glvj2vIKnyev2Si/hoN1TgLHAxkdawrG3UYNiNu3vkv5
	Py9HNi9KKJS0IsJNLkB0JM02/vH2YEI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756891563;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A8T8Nj21cWCWy/GFruQ0Nkz1WCXXils8q9OhLNNO9rc=;
	b=McADqQm4Uqrs+CdQshzDZD66nG0ezO+E+DSC/ZYcMIlxHhw0CfBquIzc5yFdsLLyeMcYPw
	L+c5joNrfy1zROAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1756891562; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A8T8Nj21cWCWy/GFruQ0Nkz1WCXXils8q9OhLNNO9rc=;
	b=r6o3bBqmRpHj2PnhXyQi5U6dh68FbAnsIG6Hd9oG2fHUX4NMN71tsgyX4u0741/KyuA4B7
	LPvkBcSCVRxAimUjlC90RPL4Jc/Ng6fbJ+rUDH1mjjkSCzglT+CuAMmbZLdPjRK1whzGJK
	4uLN6QHBqTenZ+2GYf2LjGMJ5mJ51wk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1756891562;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=A8T8Nj21cWCWy/GFruQ0Nkz1WCXXils8q9OhLNNO9rc=;
	b=C4tR98NCb+yuVKREUWl/1P6ZyR9UOh8hHBGCdC9eef7sA9iOS40zrpNENyNeHnAGAstdoZ
	bXb4wI1lXKqSnTDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id DEC4013888;
	Wed,  3 Sep 2025 09:26:01 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id TVSvNakJuGioZgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 03 Sep 2025 09:26:01 +0000
Message-ID: <ef1b79ab-15cb-4720-ab05-d77617143a26@suse.cz>
Date: Wed, 3 Sep 2025 11:26:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling before printing
Content-Language: en-US
To: Yueyang Pan <pyyjason@gmail.com>, Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Vishal Moola <vishal.moola@gmail.com>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usamaarif642@gmail.com>
Cc: linux-mm@kvack.org, kernel-team@meta.com, linux-kernel@vger.kernel.org
References: <cover.1756827906.git.pyyjason@gmail.com>
 <8dc71d31de53afa4c0bb25234807b1e6ead5ba55.1756827906.git.pyyjason@gmail.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <8dc71d31de53afa4c0bb25234807b1e6ead5ba55.1756827906.git.pyyjason@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Stat-Signature: se4xdkuib7xrodn34uh71mcx3pas5xj7
X-Rspam-User: 
X-Rspamd-Queue-Id: 998CD40006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756891564-449691
X-HE-Meta: U2FsdGVkX1+x41YbR8/lGwIUPaj5UVl83wMdnGrDSAmzJTlQU24zqVFRTwYtbozdwECEyHKlBHAwimAzEw35UGwx83AEyG9nS3U3tLVeJP6JyOSjCz3cgQLwPSdXsC26tl1lH7xpAQjaWCz1ZD3uQBIhV/1BAxfJ2lk6SEyY8ZZ0lbsmSW6inijE5+jXE60ih2u1r/he6aswsXdPWqQ1aNX2zc3zbaM2MWoJ7K87o625NWxyuOH8YCYk6FkmP5OlCK7UdDJIQB83qucrg2CN6UuRjFXoeX+eKjKeh0L/tADcP5W929/FxSe1VeD4ImFU7y82DSu8Cg5cmafwtR8EVPg2NYWuRMo+SNczD2sbq5lvY1ZjjdAeBl7VLHcB7ngrUhva3tu/m5KXavefZx8YyPcxq6nGzGU/l5QepmJl0LxvlJlbbuoARFdrVQ5Cg05dKA0TpmHV8cz3V33a0fS/5PFuLEFL0/2pVkSMmnM5h9DXVPSTMjhzb+x/Guzn0BXucLN3p5vHDjynzpKgGr+ep1Ov6F4dozTi4Q1wohD8vWWy/wg+TATf+ADSucoSaS7H4kJdnYIDR067mtfMVzLZLKYZANe2rXG20qv0wcVpmRAEwfiJDrZnKM5zj+a4e4b+KuMPnoLUOeMHT+8ppTvtvbC7iGCla1+n/lTebEh2AgYUXm2up99GwwgApZPPuX7kGYG3Gz6iZzKuziTAYAUfNHuDNa6KE+Jnr7wVYy334y+7tNzDld88pns8kEA3v4IqMU74gzUQUqhEv6DCXZYy6xhOrO/WbMrE9SjPqxHLB61aLQZ94fZcWcEkkTYE/90EgTeD5ILrRh9XsYtPH5TwpWtM7S6uKqBPaKqzBB4x6LVxUGozObJi3hTkZw/uvAp+F0PuQ7vzXGwgvyG54seceGtPrjUOSGKafC5R0Ktntfr3fzxxfqkJTi5Oiu0Fdq9tS0aglQTwOjS5fyP/4kG
 YspstBHT
 BeHO3adJiHHyd8vM3Pz5JVEYDnrFZz6rTk9FFfdpSbZCpG+88ZCiA7w8avQtIldRbHnHuYDOMz9s30z36Uayhlh+zg0d6AFOYGA7nGJX9yhZzGQfRzsw3KK8tvkkqAK3/OdKN5U/VwSKzJ6pzDOWON3qn2dXpOM/UU5ckJqBvG22oDIQ+OkNuYYTbruPSZaxcI8OfnjuYoqxw3j9UGcnJfvYZCXbY3viIxc81/lPuIkeKpjpArTl2Yh0HYpobLErzkJSZZH9Rirl5P9Ndst6I667i58G7S3ygREkmlfm1EUszAGkz3Yc3FHXXSQu5xFHfU5mrQoii+pZz7+hJQeUi4xr4yrNtkPZ3R2h6SoXH/7bZW3Q6FyTrGb33rW3AgmeHSejGNHdExhJQQfb7MO2K1hvqH9Fw48NxxLn2VSV6jBsR3ig=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/2/25 17:57, Yueyang Pan wrote:
> This patch prints the status of the memory allocation profiling
> before __show_mem actually prints the detailed allocation info.
> This way will let us know the `0B` we saw in allocation info is
> because the profiling is disabled or the allocation is actually
> 0B.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>
> ---
>  mm/show_mem.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/show_mem.c b/mm/show_mem.c
> index ecf20a93ea54..51892ce2efc4 100644
> --- a/mm/show_mem.c
> +++ b/mm/show_mem.c
> @@ -427,6 +427,8 @@ void __show_mem(unsigned int filter, nodemask_t *nodemask, int max_zone_idx)
>  
>  		nr = alloc_tag_top_users(tags, ARRAY_SIZE(tags), false);
>  		if (nr) {
> +			pr_notice("Memory alloction profiling is turned %s\n",

There's a typo "alloction".

> +				mem_alloc_profiling_enabled() ? "on" : "off");
>  			pr_notice("Memory allocations:\n");

But I think the message would be more obvious if it said e.g.:

"Memory allocations (profiling is currently [on/off]):"

>  			for (i = 0; i < nr; i++) {
>  				struct codetag *ct = tags[i].ct;


