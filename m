Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB0B3606A328
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 03:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=r9Ztd5hA
Received: by kanga.kvack.org (Postfix)
	id A77BA6B05B7; Thu,  5 Nov 2026 22:51:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28076B05B8; Thu,  5 Nov 2026 22:51:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 916CF6B05B9; Thu,  5 Nov 2026 22:51:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 66E5A6B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 22:51:13 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DA96380A27
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:51:12 +0000 (UTC)
X-FDA: 85403318784.15.58CE4EB
Received: from mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf15.hostedemail.com (Postfix) with ESMTP id E34B0A0004
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 03:51:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r9Ztd5hA;
	spf=temperror (imf15.hostedemail.com: error in processing during lookup of muchun.song@linux.dev: DNS error) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793937071;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LDVYX5pprFZ5HD3Zo6BkrsqChiY6yqG+iOkhfuPAdvU=;
	b=aca9X0rTHz7yYp2ZZRW8Dd+cYKaHq57jzrSJHruqV+WQDiudTo56knt7qCAsPG0Lpmx9a3
	ICDem9UrSTxyiYjxyOTfbePtGuMc1ZH2komnVvie0pxiPMZ8CopcE/NEv0ufLiVNOcl6jJ
	D71apek2K36EsrFcMwOfEka/arQKr90=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793937071;
	b=AQdthJYmBwFn3qeZq4VFQuQXe7Oc3BbEb63tA51oMrNaeowOLi7wsUvX444ZLFwCMlFsJV
	Xvum+YvGsWjgWYTbw6QCmdAdqsq0ME6Q9ioTz5VtYvW32ynr7AormjXH0QBhtC2/YAMEb7
	mYvfoYBSY1EA3kIoUia/gJlZa/1x02A=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=r9Ztd5hA;
	spf=temperror (imf15.hostedemail.com: error in processing during lookup of muchun.song@linux.dev: DNS error) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=m4ucnzX8AjDcLxy22+8CSKWxW8fX479FCTuyRg1XHhc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793937063; v=1; x=1794541863;
 b=r9Ztd5hAMLkHeRO6q3xVWEmUPAAhGm9uZWszChoWRlo8EXJoXdw8gulBawXOqH4L/WOq3x8k
 BzeSKavzXqIjv97OGY2fG/bJK7I2cQqOZoilRj1gwQ9Bsjxw/yOkec8mVwvEsNcJJRGyIQb38Z8
 k7Z9yaHvUKMpKoy6jzWFeEWM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id e531e58339419fd7;
	Fri, 06 Nov 2026 03:51:03 +0000
X-Mizu-Trace-ID: e531e58339419fd7
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v2] mm/hugetlb: add htlb_dissolve vmstat event
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261105191508.1021974-1-mkbund@amazon.com>
Date: Fri, 6 Nov 2026 11:50:47 +0800
Cc: akpm@linux-foundation.org,
 osalvador@suse.de,
 David Hildenbrand <david@kernel.org>,
 jiaqiyan@google.com,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <D6862DF6-34D8-44B9-8412-B241812F6754@linux.dev>
References: <20261105191508.1021974-1-mkbund@amazon.com>
To: Mark Bundschuh <mkbund@amazon.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E34B0A0004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: p4oqbeerpawqma4nt6jdikjqgbgrua3o
X-Rspam-User: 
X-HE-Tag: 1793937065-382765
X-HE-Meta: U2FsdGVkX1/VQtVKYHGMixitr3jZROFbmdl3zo2dGuZxEeC8VbBpid8FpUY+5P/ZiuOpIsAHKUy4A0IaE26O+XqWAe9nu+fQD1sQ+HlHCUSUpz1yVXapNfItY7G3CgdHGTSpO1VfSPd4k6vAS+xV/F9BzlBIbixCjnNSDAzE/ss3CGDKHF7axdQFXDB9zVgJjL2/rrwef9TFacBgDgyP/5fzYPE73ino61Bm07YNxP3bgWThVQ/+BIv3eyuWY3OKhPSKhvThbBbKDfIRFIAVebwUJDDPabRk4X7EujAmA+gZZXOAQfxcIx/lXBgBZJu9mYj3QJcfRLbMUD6EPwsijo4KIwmW4GpVkppH+myOf+QYwh86qgvBhqNR2lA6ui2DBb1ZMpbRbZyC9iX7py1MhxZc1C2c9mLO+CQcZasOZ40xJDx0oY5lgsKHN781UARsYeiZQDir7ibdDy224Nfh/9Tn48rxjtMg7V+Z5wDSUFyQjS5L2hVxq2Ldm3fSdjASZdyFRA/Fnqzb9h/byAM/h1fjnBL/FsTyLULQl6W4z6hBAunWrIWP3j+SDlB4/TgyuDY9Le7OKfx+e9CZ/Y7FA/2Brr12qFajYxARZip5zALJScuWKtlDtyHbjJZjIMdp9V+SR+6TICI4gbg4e3TDf0n9Qwr352s5rv3/4UCRituv6S+VtC3RKJhd//sOVylejTDGaJQC4taAFHYiYPpluJIVVper2rngxwwzsfae3kTYsC7+95bqYIBkUOpf/PrVriesSjgsN88r3mcfpcJ1VxLAKYubpHM19JMxu3LqbuzK2kW/9u9jALrg7NcCqwG92rJAzvlPA6vH3dO9yfXhJXu2DIJjO2xw2EtPiD6Gcl0yzC/IJyPJQJBCfUGfad2vTygfLpdmTboF9csaWd9Nrmk9hI3dW2nFGT9cc5QzyGZ42OBAu2F24fDo5WUUfOSE3pNru6HU2WIZNFt0wZK
 PlCU4HSY
 TcAmuaAf/0s0QsqrgFT6NYmxc2Os0TQVey4F3K7elCyjcrCrNjRX1X17AGCy7pbPbMVHGwJSnYHqoLhHpdEQT0uT2wvNLn8DE+1PS0Avf6zeZ2jChAUGDZ5m/f8g5lkuW7a9Is+zWfj6u1rox0WCq2bicLgVNjULM23pVzD5MXtLB3CFv2yA8MqEc6c/tJittyJ6D/BCv2ONR4TypZtkCyQJi3XE5Bz02RT9ytQ41aFtshirrbP1rMR16BUYpAtU0m7i1stJRn//N3wsDZg8VbCN/ZXbWaj0ycVA65lWpkcBYAED6sDHOHmGHnoPOmSxh2SFteK/z/djjFqWrirMhBWngvw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 6, 2026, at 03:15, Mark Bundschuh <mkbund@amazon.com> wrote:
> 
> Memory offline and memory failure handling dissolve free hugetlb folios
> and lower nr_hugepages. Nothing records this, so when the pool shrinks
> it is hard to tell whether that or a write to nr_hugepages caused it.

Hi Mark,

I want to know why you need to distinguish these cases. Is it because,
in your scenario, there is a possibility that unexpected nr_hugepages
operations may modify things? You are not aware of such operational
actions, so you want to know whether you have experienced this kind of
operational action, is that right? Since this risk exists, why not use
auditctl to perform audit logging?

Thanks,
Muchun

> 
> Add an htlb_dissolve event, counted for each free folio that
> dissolve_free_hugetlb_folio() takes out of the pool.
> 
> Signed-off-by: Mark Bundschuh <mkbund@amazon.com>
> ---
> v2: say "takes out of the pool" instead of "frees" (Jiaqi)
> 
> v1: https://lore.kernel.org/all/20261105020324.2011790-1-mkbund@amazon.com/
> 
> include/linux/vm_event_item.h | 1 +
> mm/hugetlb.c                  | 1 +
> mm/vmstat.c                   | 1 +
> 3 files changed, 3 insertions(+)
> 
> diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
> index 2628ccda076a..822fe862e5b3 100644
> --- a/include/linux/vm_event_item.h
> +++ b/include/linux/vm_event_item.h
> @@ -71,6 +71,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
> #endif
> #ifdef CONFIG_HUGETLB_PAGE
> 		HTLB_BUDDY_PGALLOC, HTLB_BUDDY_PGALLOC_FAIL,
> +		HTLB_DISSOLVE,
> #endif
> #ifdef CONFIG_CMA
> 		CMA_ALLOC_SUCCESS,
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index da5d04edf7c1..7c79523b2a3c 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2047,6 +2047,7 @@ int dissolve_free_hugetlb_folio(struct folio *folio)
> 		}
> 
> 		update_and_free_hugetlb_folio(h, folio, false);
> +		count_vm_event(HTLB_DISSOLVE);
> 		return rc;
> 	}
> out:
> diff --git a/mm/vmstat.c b/mm/vmstat.c
> index a3e809c57f29..6282eef7074a 100644
> --- a/mm/vmstat.c
> +++ b/mm/vmstat.c
> @@ -1397,6 +1397,7 @@ const char * const vmstat_text[] = {
> #ifdef CONFIG_HUGETLB_PAGE
> 	[I(HTLB_BUDDY_PGALLOC)]			= "htlb_buddy_alloc_success",
> 	[I(HTLB_BUDDY_PGALLOC_FAIL)]		= "htlb_buddy_alloc_fail",
> +	[I(HTLB_DISSOLVE)]			= "htlb_dissolve",
> #endif
> #ifdef CONFIG_CMA
> 	[I(CMA_ALLOC_SUCCESS)]			= "cma_alloc_success",
> 
> base-commit: 05441d697f7f9a927264f4058cbbc6a03dfcac9d
> -- 
> 2.50.1
> 


