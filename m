Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D166CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  1 Nov 2025 00:04:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3F178E00FF; Fri, 31 Oct 2025 20:04:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EF6A8E0068; Fri, 31 Oct 2025 20:04:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B74B8E00FF; Fri, 31 Oct 2025 20:04:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 705D58E0068
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 20:04:06 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 18078C0691
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:04:06 +0000 (UTC)
X-FDA: 84060090492.14.BE85EE9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1EFE9C000B
	for <linux-mm@kvack.org>; Sat,  1 Nov 2025 00:04:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dv2iQ0ji;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761955444;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fJTLDl2GB3C3zTiLN2XEfSxtiEAMCbBW88S0Vxf2Ilc=;
	b=0Cm3oQNw3iMa/oMKsEpWbA1hvAPt+PMQP/GQQfXSmiasY2mrxdEWUuwhkbPxWLekOrmg84
	SXCnx3/5EVP9e6yRn3qt+2Gz6d/1yaCC7wL/iZgk8wK09/4xZzeB+yJVKnchHe4k92mH9m
	puwcCoCWEgGspcNEe1dkHQbEx4TIDXE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761955444; a=rsa-sha256;
	cv=none;
	b=ZrI8XbJBrvw1PpFLOseskAy6HQctLBjhElJ28HUtVV3bXJOCx8z0sJCXBY+tm1PZcymoU4
	yBt2b4NISv6DpQDXzKhCNX0Im0cF8PYWhUNPu0EQhHQrHQmax4kAFxSySgDsLHZHh5jrJh
	oZn0K42zy9k7dty+XSaaVpL7qW6pGIk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Dv2iQ0ji;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf28.hostedemail.com: domain of bhe@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=bhe@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761955443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=fJTLDl2GB3C3zTiLN2XEfSxtiEAMCbBW88S0Vxf2Ilc=;
	b=Dv2iQ0jitCoyWP15LeH0os327vUI/lxJsDHn6YttEggx0GAPZDnq2TZyb5depStKB3Dgkt
	11hJ0qz7CaaBnR3464i2j9z7JYmgaxcUWgHSD+EyPWe0RppwW9IhifwYBUfvtp3jUrPDU0
	CDh8vJ+EYZ26t/p5PHb+gZ2wJ6TlE8k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-218-jRXzQ26PMc6Ek-zbo9faLA-1; Fri,
 31 Oct 2025 20:04:02 -0400
X-MC-Unique: jRXzQ26PMc6Ek-zbo9faLA-1
X-Mimecast-MFC-AGG-ID: jRXzQ26PMc6Ek-zbo9faLA_1761955441
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD3391956075;
	Sat,  1 Nov 2025 00:04:00 +0000 (UTC)
Received: from localhost (unknown [10.72.112.3])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C20D1954128;
	Sat,  1 Nov 2025 00:03:59 +0000 (UTC)
Date: Sat, 1 Nov 2025 08:03:54 +0800
From: Baoquan He <bhe@redhat.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>,
	Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>
Subject: Re: [PATCH v2 5/5] mm: swap: remove scan_swap_map_slots() references
 from comments
Message-ID: <aQVOagpCX4GhEu1P@MiWiFi-R3L-srv>
References: <20251031065011.40863-1-youngjun.park@lge.com>
 <20251031065011.40863-6-youngjun.park@lge.com>
MIME-Version: 1.0
In-Reply-To: <20251031065011.40863-6-youngjun.park@lge.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7uVhdFZGZdTzVCW28jhfW6b7BkqCC0S2y-m0nqn3T5w_1761955441
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspamd-Server: rspam01
X-Stat-Signature: jbo3ejjrsd8bepnmb9fobkrthusa4xcj
X-Rspam-User: 
X-Rspamd-Queue-Id: 1EFE9C000B
X-HE-Tag: 1761955443-872626
X-HE-Meta: U2FsdGVkX1/pMpY73bpz/SaqTRG17f6z1N+BK2zzKo2qCsWmynpSD1Gp49SDo5TByiCMJHBD5aUCBtMjXw4H+Cps3lu7JRppD4FyIV6uhjTIobwqmVBS5khsnQ9dTQqw/0wCsvruu+Mhjwl2/uQjuzuM3HGsP9vvV9eZ6wCxE8DBI36IAs0QyJR1OFP/8J6VpLMhZbcqSgyHoXi0M06Hoxo09wU37xyTJRycnI58biJQP0gVn/SBlcdL9XC6trgOpviqrmeiplrR+wJ4tq2i2Z4q8Ac7fhv5Vhvb3i7DFa2X76kmAim9uT7gshXi/MEF2PeHa7WpnGoLZB5f8Pf9TyztMi0lZBHGEKe2jTz7pIPGsmUv3HvGc7v0TA6rd/bAP/PxGZTQVC8p+c61/jiPXrvAA04GBKSTTz2cbjMBxi7EGqE0GqpE1hsoxzMDmzzn4RgPR5uJhv0EZZJstrowi8kTfKoHWAhLNtGE3u98LShv4FTcdy8aplBonxO8VqXUICNJbYbg5AYovGpcciqscY89LN3vZzv4kD1+Z5O4UFeupeSCAnqnhWk4G+OUIc784Oo+Sp4epjZctmA3M2Q4LsAl9EOSCcl87qXlkLL8mSlyiLIFNg2xBxS4gSdrZgHY51Om8gg9CHqS1MM52hmzMbILfImDEw7e/yf1RoEzBzjONZlEDl0FViBZ41BayD7Sdmc9fqPc6aUuvvky227/ExdSrzTuduQN4BSVYGzpbn/fkUGMCC93obF1bqB6bQWX6GRyKxGM3kJ/wDSA0WhmWCk6lO1OmBgbjL8kqY8gJgJ3b3QRur7yNXSvIk5itR7tz43j6cgV7m/6SnY/1TtkTplmqDWU3VPPzxeN7VREA9T8+oWz+Oa3aBORsMPAMxPf5GaIEr6XIyHbJ0kGrqrXs/tdSxDU1FKTzuqKrt2uReDugk6JVDoD9e2i0218RkWiLs+GbSzQ+BwkZRnQz8l
 X/LWqJQT
 5cMsmSDLZD6bc9/bk/Y1VKxyI5/mQBLQNNmFeOE9ORx88cQT7O5StG0Jd68d3nsoNMo4nHlGkUItC4lkn+DgSQUtgwBHMXCeg0IJ1KZOHFJmxYt9Z2Y4nXjMundz1Lth59aPGNQdvFH9ytQheWlt4QR83nQbRJKSC/EtbZq63MIYg70CbsYfep3WUrJL9st6zVEvFI7BH6D84XqJpERtYBBvZEuQ1IQ4qRxcnBoXhTr00YsNH5n49YonZyiw/Bl5mlaRq+iP97Uy4ScpyS50HS8aCz9Z+RgH9pg1/YbPh73hbzQGlEO3ToZwcQOW+hSG4n3J6ytvLwQG/y55GDggB13pPQKmrRdUc6sAU6XcvWOIOgArEjWEvFB6/DHB/eWQl7s+pk/RX+6Quo2I6Vkft2BZa7qZ/cJ5JfPH2ckv6A3a/z7FeQg/c6q9rH3mzWjoacHQ9p8tg0L5VtETMcpk07WDObjJlHz4rplQuEWeUif8xFTS/T7wvTCr653pRsOpIClVjfvB4Tw6BU6T8ZHkhNGsu0jpwlNNhWuek
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/31/25 at 03:50pm, Youngjun Park wrote:
> The scan_swap_map_slots() helper has been removed, but several comments
> still referred to it in swap allocation and reclaim paths. This patch
> cleans up those outdated references and reflows the affected comment
> blocks to match kernel coding style.
> 
> Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> 
> diff --git a/mm/swapfile.c b/mm/swapfile.c
> index 4f8a1843262e..543f303f101d 100644
> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c

Reviewed-by: Baoquan He <bhe@redhat.com>

> @@ -236,11 +236,10 @@ static int __try_to_reclaim_swap(struct swap_info_struct *si,
>  	ret = -nr_pages;
>  
>  	/*
> -	 * When this function is called from scan_swap_map_slots() and it's
> -	 * called by vmscan.c at reclaiming folios. So we hold a folio lock
> -	 * here. We have to use trylock for avoiding deadlock. This is a special
> -	 * case and you should use folio_free_swap() with explicit folio_lock()
> -	 * in usual operations.
> +	 * We hold a folio lock here. We have to use trylock for
> +	 * avoiding deadlock. This is a special case and you should
> +	 * use folio_free_swap() with explicit folio_lock() in usual
> +	 * operations.
>  	 */
>  	if (!folio_trylock(folio))
>  		goto out;
> @@ -1365,14 +1364,13 @@ static void swap_alloc_slow(swp_entry_t *entry,
>  		spin_lock(&swap_avail_lock);
>  		/*
>  		 * if we got here, it's likely that si was almost full before,
> -		 * and since scan_swap_map_slots() can drop the si->lock,
>  		 * multiple callers probably all tried to get a page from the
>  		 * same si and it filled up before we could get one; or, the si
> -		 * filled up between us dropping swap_avail_lock and taking
> -		 * si->lock. Since we dropped the swap_avail_lock, the
> -		 * swap_avail_head list may have been modified; so if next is
> -		 * still in the swap_avail_head list then try it, otherwise
> -		 * start over if we have not gotten any slots.
> +		 * filled up between us dropping swap_avail_lock.
> +		 * Since we dropped the swap_avail_lock, the swap_avail_list
> +		 * may have been modified; so if next is still in the
> +		 * swap_avail_head list then try it, otherwise start over if we
> +		 * have not gotten any slots.
>  		 */
>  		if (plist_node_empty(&si->avail_list))
>  			goto start_over;
> -- 
> 2.34.1
> 


