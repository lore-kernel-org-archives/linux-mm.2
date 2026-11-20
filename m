Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 13F76606A320
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 11:09:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lhKk7zys
Received: by kanga.kvack.org (Postfix)
	id 3FB106B05B2; Fri, 20 Nov 2026 06:09:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384E76B05B3; Fri, 20 Nov 2026 06:09:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24D4D6B05B4; Fri, 20 Nov 2026 06:09:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E42866B05B2
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 06:09:15 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CF7DC0EBB
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:09:15 +0000 (UTC)
X-FDA: 85455225870.06.BD7DBAF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 97FF7A0003
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 11:09:13 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhKk7zys;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795172953;
	b=CophixrSB2SnOdv0+5cgE3NJa8Vpkh434TUGxecyeUyXKALjh8f4VbfkiAbVvr5YHK0nOg
	zIch5YstlP7Je+or46SwokbJf96GFE+0as0K7I6p1lwYhAJK05/Mg+MlVF2f/Gz0/1y3gE
	2Ka9uO84CECYh+lEL2WG7cXSryhZ7UY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795172953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z6fjCNd0maTf3ZDeSWMBMSww+6wSokgMYXSsZCtjgGY=;
	b=ZlfP8352mWNiXysnnZk7Ech0BFGs6aOlKI8NDLZBrdzDM9ZCEWAUqQ/5XhdHapvBoHllLt
	nUZPH9eC6Ku27uHkKiNyx1bw2GitM99zpIb6ebUuRz3tbHTBSnEH/WC/OsVbBl2FZodjA7
	cdlvDsQzPgkURIlReWJqPEfyud8g4eo=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lhKk7zys;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BD0C5463E4;
	Fri, 20 Nov 2026 11:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5B131F000CF;
	Fri, 20 Nov 2026 11:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795172952;
	bh=Z6fjCNd0maTf3ZDeSWMBMSww+6wSokgMYXSsZCtjgGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=lhKk7zysHEjOB4cYeFDvfVNXsW1b6xo6OjwgjNJrjvGY9y0YpHPkf5FUqxveU1laf
	 lmd5gF/B+VL/ryQ+CxsVILutP8QEns/yHfD2Umo3mnD1TUImsgws0odcSJrSKqP/Q4
	 BDcH9nwP6fM7mQBOZJH06nyPbu9GcLeXbRDa7JbY1XVABWtzJ5RfLAsRP5acPr5h3l
	 ZFRDPOhIvTjoRzjNm0gz+REtnTWeqAe0Crf2HGvkcgi8bQvCiUmlD5d6hHn1QahHgl
	 PWbZJDYLe84QTT9DBqlxAuo2DL0VuTqFIeqXKXuGLq8AUcBOpKz4CDF4ZqNgfZYVif
	 Yd0bXk69YoY7w==
Message-ID: <5b916aaa-cc04-4ad2-8008-04a57d8e83a7@kernel.org>
Date: Fri, 20 Nov 2026 12:09:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/msync: return -ENOMEM if page-aligned length overflows
Content-Language: en-US
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>,
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Wupeng Ma <mawupeng1@huawei.com>,
 Ding Feng <dingf3ng@gmail.com>, Linux API <linux-api@vger.kernel.org>
References: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20261120-msync-enomem-fix-v1-1-80282c8c5beb@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 97FF7A0003
X-Stat-Signature: dyqxan3n8wwtg5rfm1683nawj188aqwx
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795172953-613115
X-HE-Meta: U2FsdGVkX18+RXolRSN+75jgEzgBy+hh+4dnY5yfI4dXn+QsFaYMKNUcmAl8dV2cul8Wzh8eI0aQt7EyWIu0TuTT6Ho1K8Ys+bZDlZyui/4JT7rkoKw34eFsa+5qOVQLXX1xX0t3idgJCP6tpURutXG6VbJRcKGFVbA8GMu37bjE0ZwcajIh3pgWavBEBbgOdoEay1qL5o+7UOcDeK32TU5xhDUKOanPksbciEPuufeKweFOSrWkcrEvTzdLrkk+612Qb+XgZFAn3DFnP6a+v+438s9CUmJ8oi9NASBapToLEBBgLWx8Hnj62iy49qBWhvyaWjQZUXmE2DGsPcEA71hhKZEZcGmHz6QuncJ85muBVMSEqzArSSHMy7ICD+9O4YkWD6FME9XK85U6LO5tjVxtA9MYTjR00ssQD4uvchdpM0DI9NmstK1/DtZumciWf6hZtF1ogKWuwhmCXia7RyPEm3wuVUQWK0g/dovbI/euQ5TN5c7Bhp1Wnh7717uwIt7hd+o5yAgn4R9f3hxuwwLlYs2zuaoRO4/+eEisugKN4mEzwgKpg8k6nuIBjmmq47XhKBX/HrnXp8fEgSdQYeZVxSk31JM6RkT3UEB+MWK4bKFXCoDXW0aGWIcRZaHNXUEUVS0rE8zoYvjzJ84ngWFW8dHhHrZp3OQre2iGffto/nnavz+G/FxdJFoK4i+RuR0hsLk64rByZZ3+sb8VVdxA1oPPKAG27Ogn8I4aZyDA0qhE5PePFhA0dKasXChyyrGQzGzP1WnL9YZ3dI8a3op+Sq/fZuC31Btek/4EU6tlUtmyaoMwdnYGSnd4JSxsCWkY9PsjPFH0eSar7+StSqxQZVrPWthoKHSI3sKG6fpIwY3fmb7W80vzVoqLSRoof5sXzyztJ7Nq27Lpkq+L5FkPfwfc2SeZub9b8+25hhsxTOXpd9mk/Mc4R5q7yNEtXDjcpPBg3/tUTJOsfpj
 2cnaREhT
 OId850zrkC68/ayR8nhRo3esLIy7KB52bjUgbe6eJT47cemDNEFPb30D3oB5Ge5bcan6DkI6wlyOnVofL789WBeUdVRmysTxVSQuJIR777blOeBP7RXRv6cGfdVPEvykDrv216MgCu+e31Yu01i9ibA5Kl1d/puQhj87jhATxM8JoAkSMRJRH6GyMkXHnEUjLDU8DcyeuWGBrusNgaCPFrbWU56Lxl2hx8/N2AW2pkHIROFDrJCkPNwig0A/+GoX2gsgU8J3Dun80SFpPMeGEG8PUo30Hw91PFlD0hHCVVsUyXOF//79G8TQq9mxEDayIaEdIsMRX8fOhl/OrKY+36daTSwDr8TImcVi0J01ciWe6O7blegp5tFS9VH0L852QlTIG5i7UUlRPnUEcCk6nCg3bNi6/N4zV9N9yXMIl7qRTcvHm1pvf9Z7dltPWzmxUDaFVJg1GxoWLgdF+zYI8bf8WiuBMdTfBgxqNirTMshloRmhXCW2Y1Jbpvz8fZTGkxly1syOlNCVk9QifYJm/S83lYE83r+TkruWCQAb6/fg5vR7kz4cqzROi9A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

+cc linux-api

On 11/20/26 11:59, Lorenzo Stoakes (ARM) wrote:
> Currently the msync() system call will simply return 0 if you provide a
> length parameter which, when page-aligned (rounding up) overflows (i.e.
> SIZE_MAX - n, where n is in the range [0, PAGE_SIZE - 1).)

Weird, as if it was intended, but seems to be pre-git, so who knows why.

> This requires broken input, and nobody has complained about this, but for
> correctness this should really return -ENOMEM, so do so.

Right.

> Also, since error is assigned within the following loop, remove the
> unnecessary assignments prior to it.
> 
> Link: https://lore.kernel.org/linux-mm/20230321074035.1526157-5-mawupeng1@huawei.com/
> Reported-by: Ding Feng <dingf3ng@gmail.com>
> Closes: https://lore.kernel.org/linux-mm/20261120051413.46167-1-dingf3ng@gmail.com/
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/msync.c | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/msync.c b/mm/msync.c
> index 90b491a27a14..ced41d3c2903 100644
> --- a/mm/msync.c
> +++ b/mm/msync.c
> @@ -46,14 +46,12 @@ SYSCALL_DEFINE3(msync, unsigned long, start, size_t, len, int, flags)
>  		goto out;
>  	if ((flags & MS_ASYNC) && (flags & MS_SYNC))
>  		goto out;
> -	error = -ENOMEM;
> +	if (!len)
> +		return 0;
>  	len = (len + ~PAGE_MASK) & PAGE_MASK;

ALIGN(PAGE_SIZE) or something?
But fair if out of scope.

>  	end = start + len;
> -	if (end < start)
> -		goto out;
> -	error = 0;
> -	if (end == start)
> -		goto out;
> +	if (end <= start)
> +		return -ENOMEM;
>  	/*
>  	 * If the interval [start,end) covers some unmapped address ranges,
>  	 * just ignore them, but return -ENOMEM at the end. Besides, if the
> 
> ---
> base-commit: d12eccbcb79a4fa35c3aa588eb79056af62eb859
> change-id: 20261120-msync-enomem-fix-95f830e305dd
> 
> Cheers,


