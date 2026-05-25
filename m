Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 339A2CD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 21:49:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 349FC6B0005; Mon, 25 May 2026 17:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 321666B008A; Mon, 25 May 2026 17:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 236BC6B008C; Mon, 25 May 2026 17:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0DE236B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:49:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A371E1401F3
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:49:31 +0000 (UTC)
X-FDA: 84807284142.21.452E381
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf17.hostedemail.com (Postfix) with ESMTP id C23D040004
	for <linux-mm@kvack.org>; Mon, 25 May 2026 21:49:29 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e+fHqF0X;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779745770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cJhBbkkg9PzZDnnqjTJHB8wsc4R5SikbJ0jWD5EeS2M=;
	b=lAqieY8IgK+FGkCr68DmuQQHoxGJv8E/ORhB5scuJ07uoshS1SBFjkuwqmk7fowf3uA09J
	dm6MLTzFTIAl5UT/UPonfCIBMJrHOLoRCefLrAjHInHLftUCd1DOWsK4Zj6f6sLqoQ0cz0
	PA5luk1LfSnMtDQR5tk+UghjM+2GhA0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e+fHqF0X;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779745770; a=rsa-sha256;
	cv=none;
	b=igcOZgUk0ChvGhpa6MKdje5KA0qmqtG+GmkTSb3Dzd67G2VXWHzy6tlvji9o9+IhnKnQci
	AqXmha7pU+LU6k8JV7xjWXS1WHEYbMa7utX5iXDcB1T+gWL1hxjCK9ush9WyI9ZjQRnR/l
	jHtDmlNSLYXQmtzZvTOAvw7ODIuHNig=
Date: Tue, 26 May 2026 05:49:15 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779745767;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=cJhBbkkg9PzZDnnqjTJHB8wsc4R5SikbJ0jWD5EeS2M=;
	b=e+fHqF0XD/2ukH7jaNcc49iWmkLqXOyXDPERSKjViWt9hzNi/4hkjKU/8yJbS4/dnG6K+s
	FsGVz1//2ivLRyemGIQ2qB13gI9xqp8ao3RFpGx6ISu2mR0n9HgXkJYQEtbc4cFi6oqu6X
	3uk6bAdkolNSekPOBXbjMdUUvkJIX9A=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: Youngjun Park <youngjun.park@lge.com>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahTD24kOr9WoluRT@MiWiFi-R3L-srv>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421055323.940344-2-youngjun.park@lge.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: pmcrdi53hj3mp8mr8w47snpgtcwjqrza
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C23D040004
X-HE-Tag: 1779745769-755690
X-HE-Meta: U2FsdGVkX1+i2mpnUZ4NE0cxhixqI/42lnZy7MxUEbvAm6VDh4ah1CzTNSH/4vduJHdmGOqMAmZFFH0mD5Nk+2BBnOEmMRNmMEnZ8eJGtfaPBwxcKnOYy6E31w/WnE95KQW+xpgrusHjsxeeVKsQMZ6ZOR7pYurg3RhQYfokZCudt4vwzcq18TCO8Q3wZIEGPF5EksQQltEKm/M5b5h3jilyubpL6WEsSbpCX1P26lEu/bRLLX2Z7G4dA1m7fek1d5yY/AfhjCecnOKYC0zMqbqAWiOYfgERqwRfg7aJN2QsIYOUbGQjveTLq6PBOEm6QHh3LUo1oWoeIL75oyjwpJ9sHIfKrwIyAbqjLO8DWg+bh2olh5iDFaeCR1yFlZlPNKk0UQHNCy8dyCZ29U3Yxu3GOK1/d6ckLBmLRnIF4uZvT5pWdEe8O0EhajEAtjuUWdPa6e/y3Y1p1Soxwtw0IJWyuv3CqrlC7jAKUZ9B2PFXaePXQl+QhL+5RDhS0JNdWguLd/J3xbE3Pia66RCgDMT7wKUe4KWm6hWc+DEVA/0IMizYyI55HvvbDFvHJS4QCXF5YQ2Ux1LRSjyjckb7VbKguHyi/P7vmEFa1Hkf83eCh+h2H4yrSBU85UrtY329j3Fx/CoRBZbsxAOGmDRTDU7zVlXrvFLZNnwkZqBD/Nzi/lX4TxXqmes3Qfnhgw61FBNfAmTQFkah25T8UbLjoxyhe4gP802izDK/Rh/p5hEYu+DtF2R3CmfW8x1MNLG+nWKD+C5u6ny7nY/MqwjF7MUWFN1k5F6U7Ve1H++rVPOCnIZRrzjcXRw36kWk3Zp+OBWb+enIBrV5k4RO5B5GZiokIpLT5BJ5rpMzpf2S6yOvM9VtnFMBFDI8NpIX443odce4PB1FcHQZT9P+BpxGoFn418ABap7ErY+iQ7+MufciQSC9St9sl3hhXNBqIZeom8G5mgkeP3OY6RfW9Km
 L7LQYfEb
 t9GKHg55uO45Mo03NemEJnnYvVKRIrrjOSHBynZxJqlpV8wAqe9ZIB7OUMTIDAM2bKEJh4QjvhP7/MUB+IcDYAk9ODKE6JyKt0KUC0KEQx/d+xqMrbzBbw6J0dh1dYYtvojoq/phy4H+rmNIwjnqCd5v6F/flZfd21gsk3sNWjf3dykTbSUOdzdZ41QUWHUmlr5C7HVbHGSRecTXxgsiPuUgJ/2VUQyA8CWH56u66h1pU9gZ+nqGNR/U72XaQ/ldpzvycHL3QNg/HQXLhR6VElvJ5EEtkRWbAq9MHdyA6JS9Y+tQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/21/26 at 02:53pm, Youngjun Park wrote:
> This patch introduces the "Swap tier" concept, which serves as an
> abstraction layer for managing swap devices based on their performance
> characteristics (e.g., NVMe, HDD, Network swap).
> 
> Swap tiers are user-named groups representing priority ranges.
> Tier names must consist of alphanumeric characters and underscores.
> These tiers collectively cover the entire priority space from -1
> (`DEF_SWAP_PRIO`) to `SHRT_MAX`.
> 
> To configure tiers, a new sysfs interface is exposed at
> /sys/kernel/mm/swap/tiers. The input parser evaluates commands from
> left to right and supports batch input, allowing users to add or remove
> multiple tiers in a single write operation.
> 
> Tier management enforces continuous priority ranges anchored by start
> priorities. Operations trigger range splitting or merging, but overwriting
> start priorities is forbidden. Merging expands lower tiers upwards to
> preserve configured start priorities, except when removing `DEF_SWAP_PRIO`,
> which merges downwards.
> 
> Suggested-by: Chris Li <chrisl@kernel.org>
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>

This looks good to me.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

While there's only one tiny concern, please see the inline comment.

> diff --git a/mm/swap_tier.c b/mm/swap_tier.c
> new file mode 100644
> index 000000000000..9490e891c5fe
> --- /dev/null
> +++ b/mm/swap_tier.c
> @@ -0,0 +1,302 @@
......
> +/*
> + * Naming Convention:
> + *   swap_tiers_*() - Public/exported functions
> + *   swap_tier_*()  - Private/internal functions
> + */
> +
> +static bool swap_tier_is_active(void)
> +{
> +	return !list_empty(&swap_tier_active_list) ? true : false;

The above line seems like generated by AI. Whatever else I have seen is
"return !list_empty(&swap_tier_active_list);" which is enough.

> +}
> +
...snip...

