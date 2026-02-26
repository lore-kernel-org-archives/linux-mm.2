Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93E45FCE07F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 13:39:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8D0C6B009E; Thu, 26 Feb 2026 08:39:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A106B6B009F; Thu, 26 Feb 2026 08:39:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 91C8C6B00A0; Thu, 26 Feb 2026 08:39:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7E01C6B009E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:39:11 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1855A140173
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:39:11 +0000 (UTC)
X-FDA: 84486714102.02.D0E87AA
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2A1FC40007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 13:39:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LAijfW77;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772113149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86+mXi9L/gLCLWNcu/Z+GG/qwyq3WnOhFFQzn1lQbCg=;
	b=skvFLZZceAjWO5T8ONfNKmhfJDGRBHzMyr8JAXDMZ6n/yD2k4XJlJMiXs/Vvil6kjzO64+
	MqjXrl8rUwDWXtoVI5neq6W1x+R3E/QHZJQ+HwBcpDl19RHs/PfPa11dB8qay2MYK56FuC
	19jcD5A0q/vPPxV3fuIfAC1l48egX6M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=LAijfW77;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772113149; a=rsa-sha256;
	cv=none;
	b=guxQyDcvkp8TZl1aGd28+ZtGxElAC8P6j9+h+FPDnQQ8X7pkuTgzlxPsxr237kJwjUrNSj
	IpFzE9vhn6Wcy+HfxlifKnovlvhJQV0o8NZOYY4uhuCUL3Ccnla2pY9UiElyQI0PddREHh
	B9wEkBKZvAuZWuQYz6GYywoA82ccPZg=
Date: Thu, 26 Feb 2026 05:39:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772113146;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86+mXi9L/gLCLWNcu/Z+GG/qwyq3WnOhFFQzn1lQbCg=;
	b=LAijfW77YpuG22Udq9aazERjZ8rTXISFn3fH5kBDmQyvSHGoPNpQ+xcI7gfApl3um0jHeE
	xM6Gn1o1IeCYWqFgomAd8+WnhYKXcBO25ybeGr87DGNuujH5q0F77ZPmn1rMQ3Z4eBIaxZ
	QImFVIzvMNhaGFpSh9Vmf3kWUBxbJjo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Hao Li <hao.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	vbabka@suse.cz, harry.yoo@oracle.com, muchun.song@linux.dev, 
	akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Message-ID: <aaBM0fN8fqER7Avf@linux.dev>
References: <20260226115145.62903-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226115145.62903-1-hao.li@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2A1FC40007
X-Stat-Signature: sxmg9f8f9b9byq7omzecsqdh5xu8pue3
X-HE-Tag: 1772113148-346521
X-HE-Meta: U2FsdGVkX18M4/KVaHx8Pkz5llDGtRaqlVw06w76cbh5xPpZt4LbmohbmJXITtLN6QckdmDVzvP0P8EO6n7QmOaXYCi8xqFJ/KEeXpSvhDsoix/4SkwRv2QtBf7AkPvIekOp89IgVkFRz+C8tEDMYAbWOi+004qMntu8mwFOyLFnoANd2+9eEyqs0ScXox84UujiYehJKccjs/3d0RGojQ2H/QFoMRcQDZ6txM9FoF2LZLNIi/f7AJ2OacnJNf3mAgOTtK1k035xExj9pYEyYdd6IqaTA+CRZYu3OuW6ngggf7DwHnDtykO697b6zudtVcL/6QjaBxHu/izZUpv4JYcs9DE1/iyUEXChYb087yKxuh4xD5vKFW6UZ2yrG4icOaHRtac16UTA+TH3bUXXY5oH402SN8kr+s2A3eFsX+MEo95zt8KnlSkgMtFtK+ifd2JpoBSkZ4Y5FikyF5R+DDOTsALftD47XPyZ+T3WF9YECYmfgOtdcWflvn6WaSHvwHP+SewYRZZASQFRGqa2d4hj72oNOUmflJhygddHXl5MgVNWEwnnl0SohhxHGnS8bGo4/haykaCmcVhDvfmv0fVJ6zjKMEX6TDK+1iUCuyEsIcu8K8XwOdLoucJOLEqdxSGPuCD8zeuOXjxu7x2ZujEZINSOc0rOPj4lMLr/pYa2SKPHJZJkr4Ldxjr0iL6ZgmLGaU27yCZ6taOLBcQxv44jENIZH8fAyzNHloRtdAgc2Vg5DPG0wPJCouNti7lCnqiUPVmwHoqePeKELGFLT5WOkt8OilC0sP2m5RvermLwFLqy9efhdt/HKsCyUD9jJzjyGaGjrrXs5431meUA10XbciosfqkwWgvZVFJ5xJWIvkjW6DdIHkRP9MCivxqccHOt2KP9PGdxAgjXC8Tb783RjMjP+xHxTmhQcykLkBPtwn+bxUqytMI0xPdiRHX7O0nYlTG09Zt7uOURF5F
 CTTxYbKI
 NfYS0/CBFylBNCRCuZkO78uQ1nPBj+XufoO634857pq/7iXRH9WBtU3ObesEYUM3PeWRExGoR1t4GiiykHB8cuA4UyPzevZS3mdj3zSoZ2nTMec5KW/QhTPVR3Z8bm+GItKmaB4MCII7TbHjH8W196rV5uLChea5DV8Gand042nIvyDqooByFbnftyOclz99InkXxX4oRuz1aAmxNA/damsqdqGnIn7c5wkUBDIB1ayRIVWBMdiNxI1P7iQyV803ddjdu6+C58FQvOBVjUxcuVCPDkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
> than nr_bytes.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Li <hao.li@linux.dev>

Thanks for the fix.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

