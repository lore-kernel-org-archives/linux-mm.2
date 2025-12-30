Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44E34E94107
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 00:37:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 619F96B0088; Mon, 29 Dec 2025 19:37:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C3ED6B0089; Mon, 29 Dec 2025 19:37:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49C766B008A; Mon, 29 Dec 2025 19:37:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36A2C6B0088
	for <linux-mm@kvack.org>; Mon, 29 Dec 2025 19:37:36 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CE88F5D6AF
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:37:35 +0000 (UTC)
X-FDA: 84274274070.11.415814D
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	by imf03.hostedemail.com (Postfix) with ESMTP id AE0BC20005
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 00:37:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=lQfhg6um;
	spf=pass (imf03.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.49 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767055053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IheJhIQLOL+uGWt6XQ0zIC5UxYwT55m5ifEVRi78ko8=;
	b=OklAH325WBBpv4RXwt06QcZQKZ1zQot90Q1sWTSxdx7PR6iNqiydbENSDiQGugMAm4OPvQ
	I/YKWN2yGA4ErUE8zg8EIL6Ixm9xAqazmNad4QOQtw01GldUBE2hPL9J3v5LqyZvMc+xOC
	1OGFl+7TobhgeEhLDp9CtofWvowNodI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel-dk.20230601.gappssmtp.com header.s=20230601 header.b=lQfhg6um;
	spf=pass (imf03.hostedemail.com: domain of axboe@kernel.dk designates 209.85.210.49 as permitted sender) smtp.mailfrom=axboe@kernel.dk;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767055053; a=rsa-sha256;
	cv=none;
	b=OVu7Cz8vTA7cJbGBJlywbObe6DnGG59NqON32sw2ykphyiYWesqpbfneXi4fpbp/sjK2LM
	6j53MRWROT9henh7aUEqwfp9+tLtaVxX58pdUSzf8yA/jxgFfLxnWBWfbboSmNEmoHvfiT
	rpwbmrmpnZxLSewsgaWf8rZ/0v0+tAk=
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7c6da42fbd4so5180995a34.1
        for <linux-mm@kvack.org>; Mon, 29 Dec 2025 16:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767055052; x=1767659852; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IheJhIQLOL+uGWt6XQ0zIC5UxYwT55m5ifEVRi78ko8=;
        b=lQfhg6umqV4yK3K0qpBY+St4tn8+N3+lvq97u+RccLT4+MT8kvQhFU+GW0v8qMpgjN
         unbKQzqPPTzd2FOsRrrZN+aPh30cmbSFB/qvvB/J4n70uS7pL2dWtoGAzuT6Q3/qbaTN
         f+yEdFOJdRyWFR0Sp4gqc+tvysybCUH9wML4Q+qGoeO07Z5cx9JAK3fnav/4ct7os/ZQ
         CdnVl3FHx9w+njzXKOFUh5q68DsVyYt3cFGv0LUnlJyc40w6C2XHbaFssOAcajKlNRnX
         M9kcliwojWw5TL8PIpHn1EyWXBHBmM1TXoRstKSbdwFQuUgTKEIezyI7DAjn5fJk73mf
         2Qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767055052; x=1767659852;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IheJhIQLOL+uGWt6XQ0zIC5UxYwT55m5ifEVRi78ko8=;
        b=Pmb61m29PO+M5n90nEFlRFV0lL6pPViJuky4io/gChE4Qh9KTN6VJKMJevm5btiSfJ
         q7Jaxk6PkAcK//3SFb8DCYL1GnR9Y2unOItqNFngGX97iOb+pfnjdaTV5sHiENuE5KzL
         Jx0nIwiOlK+DJQPjvIeLzfx0yyUkw7DcUnAsWqEoY0Xs014xjJlaTi3BAn13sc/su/ZI
         iSKIp8ydqblh+tBGtHh0hxE8Ln0xhudHS0Spf87boZf678UCLaVDEbJ0oV8J5UMvVrZb
         Nn7tAdMK6yY9lg4UvM/fXwtoArq5iLw9USCMmCZ8YEj0IDoeAYAqMoWlsLx24/MhHDhw
         6rrg==
X-Forwarded-Encrypted: i=1; AJvYcCXBnnj/81Zot4Nf78/2QldvzNg8VosjEyXTKZHfmFTyCtnKhHNzHLjy18uOI8rLP80LZXxkupcotQ==@kvack.org
X-Gm-Message-State: AOJu0Yx6oso15M5iVSj8f/Un4mU9OjExTK1LpyeX2MA7YRSO/7qyG2Bm
	YCVBEthYGC/ozm85YlUW+1a5w7HeXSRnFxVv2e0ebrKgtLDs9q3DmbYIGM5kfgSP6f0=
X-Gm-Gg: AY/fxX4YzVjiMieY0oaHVF07RwbvGtIlO9kjuiL2ZC4fc2WFumJXWClvi+PY3M3iCHI
	LcfGC3ozNGAlGCMKg94E3zWNJ3svcj38HX1FfuAyxThIL0aRGpMrn0PP81fJWXhuvyukhK5LrLM
	24oeH43w47GTWQOrRK0shOkYOWgMF/9lxKmDFeRDMfshhW+W+Jow174rrbpDDV5LDcMP4TDrYkO
	yIVXgtixynQVE2Wroz75aQMWsxrwCwXElzfxKW2lAKWOYyhQsjURjyDq98jqUSrE2AdV3y3ySld
	JGKWrAi1WZUFpLoV6dZwXzs+5AApcH0GQ6xHGmH6ng5yfuyYwI1m3XS9OPozCcqAt5jmwdm7ez+
	/s4QsIFHhp54ydxiYNVjvTyb2lZp+Ko1AnLS1hnAjqo2PGhXCdH/H4jjrEUX/FFHZtoQ0x3at9Q
	EGZIudCaEg
X-Google-Smtp-Source: AGHT+IFl9yxlJpaq7sZYozgWoQTaTewr4cBUOiverIAjbR/CmqFwp/DL9X0O2bEGHsivPH5Emtcv9g==
X-Received: by 2002:a05:6830:2642:b0:7c7:6217:5c60 with SMTP id 46e09a7af769-7cc66a603d6mr14529090a34.25.1767055052471;
        Mon, 29 Dec 2025 16:37:32 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cc667d4f62sm21773347a34.19.2025.12.29.16.37.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Dec 2025 16:37:31 -0800 (PST)
Message-ID: <0f65c4fe-8b10-403d-b5b6-ed33fc4eb69c@kernel.dk>
Date: Mon, 29 Dec 2025 17:37:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 09/33] block: Protect against concurrent isolated cpuset
 change
To: Frederic Weisbecker <frederic@kernel.org>,
 LKML <linux-kernel@vger.kernel.org>
Cc: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Chen Ridong <chenridong@huawei.com>, Danilo Krummrich <dakr@kernel.org>,
 "David S . Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Gabriele Monaco <gmonaco@redhat.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Ingo Molnar <mingo@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Lai Jiangshan
 <jiangshanlai@gmail.com>, Marco Crivellari <marco.crivellari@suse.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 Paolo Abeni <pabeni@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Phil Auld <pauld@redhat.com>, "Rafael J . Wysocki" <rafael@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Simon Horman <horms@kernel.org>,
 Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Waiman Long <longman@redhat.com>,
 Will Deacon <will@kernel.org>, cgroups@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-block@vger.kernel.org,
 linux-mm@kvack.org, linux-pci@vger.kernel.org, netdev@vger.kernel.org
References: <20251224134520.33231-1-frederic@kernel.org>
 <20251224134520.33231-10-frederic@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20251224134520.33231-10-frederic@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: o865abmd7zqbebipncyk1y5nk6wfz83n
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: AE0BC20005
X-HE-Tag: 1767055053-688522
X-HE-Meta: U2FsdGVkX1+KaWxQ5SIEO++OJLq/psWWAua/gPI77VyyRJIQXFdBkf+00H9Q6IT1qBWNCr5qxLHw9QbZGnhIv++2ZmXJljrllyOUtL6+XJnxP9AFln1GyylLEPXMqqGlfrKlaCWkpxpbLAUHWvVwaSTTpd+w6RCp09/DL9ygC+NsLh0fc8bgHtIlpmA0HlcPamuw75YDu9GIbXDmXyLN0lpa0K3clQjv4yEVhw3LDKqcaCUnEPQlow/WG6u6QxUq9Sepi03iT0Xhk3U7MbWdfJKfSUjrO6NsFDHoeKbRLpTIt0NFgvz0s85WY5soiACwJYWFNpU5EZHiFVR4bWkKcbYXdLJ6NFZBPajaSUaYKFWPv+VM+x2VBBu0KgfrBu4ZXdfXEc6qxn5588MTQFTqNY2G2yrbj3+Wa+P/6TukAFpZ7kmosBMC6fj18GtpOIlUk3KIASvanefR7eMk2ztuuNqbuBkWCNpARZB+WNS1KSbtqNrdq2eRFIVRXxBylzqmuyRc7gitQ7eVooi5IiGQm1y3EHLh9HMNrH2dbGo2BfQ7Hq8XBwjh9Zq8sB5HKK4Snn7simcJKq1ZmBruZhswlx/2ctr1mJzrR2xsbpJ+Y3uLlofyCHP8w3Dlqtnbw4PtR32L+aTZIbOpK6Mkdger/sBhdy5WupbWxUQuyPRaNZnxWdsBVOaP1RPccbVHFE9XilCF2i2IDUa62bUaIdjcqA6x3W1EeKNFdjMlGr/cMPsmTdYtnarFQ0W1UeLlHHt5UHTT18nogUqnOiI1e4vIEJdnsrOBhz9a46Gn/dA1lz4BkL+0cKUGKvYiT05ScDVdqA4wupU8Q28CVQsASDtjRq/eRUSy5mVi0BGzZJx8b8pxM54UqHK8+KDEFry3BsKInKxbiLFmypF5MZGXhU83yMIZOuCe9wTZsYLr8Sn866jEEgTQd5KZcY/NkchpZMeMcFX7fVi/EZmEdGrurb7
 elFm2RlK
 R7mEYgGq5YM9I6mapkE7bPZ044G5pvWt8GlSRnPjcQeOIf65S80MEzD06nTGMq+ZtaD2I3W9tBrUkpQLxP7XhY29M5r/hlWBvTdAL16YW/k+9OtRIhGfO+T93kTvgqvSbCoIx3UBnZkbQcJBTz4oZ+P+PRKg0CWkbb8Ee0ogZylYqvF5trmQ1X60rkoajP8Zbel8GHDs33F5qV2xeK2I1bGq/V8d2GAyg2WTujUBOkd4ZafPvwxYi5vGzNRUqff50jChJy8BCszAQcEG5G3b0cXgbuL0C8sJWA+KccqwY5jlbPse4v/EnKrd3px4o5TrXLc8ZXiP0LGZT1Lbe/AvgO4w3Gpuj1E1y1zfGwtfVcgEEa6Ter0uQdMh61cEkMvbzPT2iEfV6BrlxeGOn1o+D+xY3A3aJGqajXox+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/24/25 6:44 AM, Frederic Weisbecker wrote:
> The block subsystem prevents running the workqueue to isolated CPUs,
> including those defined by cpuset isolated partitions. Since
> HK_TYPE_DOMAIN will soon contain both and be subject to runtime
> modifications, synchronize against housekeeping using the relevant lock.
> 
> For full support of cpuset changes, the block subsystem may need to
> propagate changes to isolated cpumask through the workqueue in the
> future.
> 
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>  block/blk-mq.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 1978eef95dca..0037af1216f3 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -4257,12 +4257,16 @@ static void blk_mq_map_swqueue(struct request_queue *q)
>  
>  		/*
>  		 * Rule out isolated CPUs from hctx->cpumask to avoid
> -		 * running block kworker on isolated CPUs
> +		 * running block kworker on isolated CPUs.
> +		 * FIXME: cpuset should propagate further changes to isolated CPUs
> +		 * here.
>  		 */
> +		rcu_read_lock();
>  		for_each_cpu(cpu, hctx->cpumask) {
>  			if (cpu_is_isolated(cpu))
>  				cpumask_clear_cpu(cpu, hctx->cpumask);
>  		}
> +		rcu_read_unlock();

Want me to just take this one separately and get it out of your hair?
Doesn't seem to have any dependencies.

-- 
Jens Axboe

