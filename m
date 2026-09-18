Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5EAFC982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 00:38:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9DDFB6B008C; Thu, 17 Sep 2026 20:38:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 98E106B0092; Thu, 17 Sep 2026 20:38:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CA286B0095; Thu, 17 Sep 2026 20:38:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 612816B008C
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 20:38:11 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8AC71404BF
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:38:10 +0000 (UTC)
X-FDA: 85225021140.29.7F68B0C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A8D1100002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 00:38:08 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+bSl1Gv;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789691889;
	b=FFYjpojZJanBd2bA9TULZu4dmRycXvp41ohe8f1KpxaOevTWvUoLUtTn4FZipwYkeom+B7
	WjUEDGv7BiiJm/k0mJ5c5jDJZc6gYEyfd929hf7dCaFJMqbMbLkBTZC4zWH5EwTEe5jUwC
	ou1MO6SwLwB6WHPJs/q/U37sxQjdHug=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d+bSl1Gv;
	spf=pass (imf05.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789691889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ze9UETo+1hNVH97tpJEWQvJ1yZNxYlSuzO4Oj6uf588=;
	b=ZRpN5uqgqC0LUh9uhrajQLxoFOqA4oOITxRTqR78JVlfl7NKkRfeqwcwcIKAccgtrkv7ew
	7HtXBDQDxS5m/Dqt19F9yAQlsBgq8uwVuStYE5Rku5ttPFWln5lV7zvbsOEIXGPsh5IU8w
	pBTtpst9l9K4M35oWJbEsKFry63C9i0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 51DFF437B9;
	Fri, 18 Sep 2026 00:38:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A161F000FF;
	Fri, 18 Sep 2026 00:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789691888;
	bh=Ze9UETo+1hNVH97tpJEWQvJ1yZNxYlSuzO4Oj6uf588=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=d+bSl1GvJPGpKJYMJztB6DW2nOd5gK/0XiKZ5AIB6VuavdGfd3Prp+D3XBcOpYA2R
	 iIwVPvgYhgv6yfq2RUHTq4tnZGKxFiz/sxeJePe2MHqQYzaJoFt/VExnajbgcNtN30
	 sa5IxWpBsDig62Xv2bnappORxL1PDe2qQS/Q7poO1/9geVH64dcJjyP+wYLajXtPGW
	 BpqwM8jasLiVs4z8X42oTLB+m9XNHKPXhw0LX6S3Rtspl31EcKrWRP7ZRwE6r3GQ1F
	 JgCdXruZNKoLXeJgzsha6AEnjUkqjx6HxogeUiC1370bKypIA0nJRIYT5WQ0KL2FIB
	 p85YVOSKrGvqQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Tarun Sahu <tarunsahu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Pasha Tatashin
 <pasha.tatashin@soleen.com>,  dmatlack@google.com,  Mike Rapoport
 <rppt@kernel.org>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  dev.jain@arm.com,  Pratyush Yadav
 <pratyush@kernel.org>,  linux-mm@kvack.org
Subject: Re: [PATCH v2 1/2] memblock: drop for_each_memblock_type() and open
 code its users
In-Reply-To: <20260918002239.4024231-1-tarunsahu@google.com> (Tarun Sahu's
	message of "Fri, 18 Sep 2026 00:22:38 +0000")
References: <20260918002239.4024231-1-tarunsahu@google.com>
Date: Fri, 18 Sep 2026 02:38:04 +0200
Message-ID: <2vxzwlsj5r83.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1A8D1100002
X-Rspam-User: 
X-Stat-Signature: e6z8dnpnkmbfjwe5pg9s3a47csfsa7g1
X-HE-Tag: 1789691888-579969
X-HE-Meta: U2FsdGVkX1+EfkHMt1RTPh22ok1py1tsKyWtHw9UoWx6V0gkCRdiIt8/xA4Kutv9fGkGmAbJvKiDg0s5fopGs67zl4Jx/VNVeYjEHjz91KPG7WXStoKz1kynnWnrWvFM/UDRgk6lOZRFVWkBjd9xXk2xmFbrsUUQc8sHHWqvujtIPtccGjEwbuEiYzp7ix5IiQRAo6C0nhOp+5gRUO1tnRwOQh2NzV+9DFHdN257kNApCczjcotUy0PA7xxfO3Ed+ZFSZZ6mfGY+KmrlIp8Tzj8mTrlFc7ha7Q0JaDu36G8A30b5w+wpsqtkqGixix1TNiwsEd3VkWqwhk1vwrBL+0vKDEbgzNCVgQNUhgLpgaE8w0V0/iBhT49gE7RC5824qo6Q5PK4hu/A5+fzXJb1AdeJlw9Hyf3FLjfseewiyMloDbdox1zytmIGhk48N0lN+6Vzl2p5d7PLTXdJE73jUA7RwyJ8Ct/mCV3VES/9dZor4gJVkrfkU6uqgrqlhvnIlJxnChkigC5AbAuVnzka2HjsFz/ktucoBwgf/qgvxrpPLVG4ZBsNQ8M0S3cIZU1ogSYAYEzvlpYTVZo197QhGpA9MgmrMStTwyp4Q6ctTgwVoC1pOdgmAexM6MFYc2Z4HrxxXGXJbOppWPEbL6YezEhA5cO21TEYwJX/laLDqL8ohnODIqmC0HUk+tjBC722PXquc4BGFor0nw7ziG+MOMfayRO7505wv5LflQoZNDdGQjH7kcF33YqDpYWfx4tQXjlNOA6viIKecNiK6dxGfSKMvf/so04fYsWkPdMbt8QMz4cAtI3707sWX0KCdkTkOmipWQQTQ3RCUlKwal3MPFrRcHYNGgk75WoNmCr/YP2spzIxdcimMDSUhY6cSPRQHz9aCnqPBJo5o6oRxC5ynsxb1BfdoW0302joQ//C6QxYnm9LlYvqdYOEGbpvfkbBiGvh2cJmfaS8hPrOMIW
 SDpqCIa3
 Yxgk3kN6vMXJl2hkM4RqjNc74DcNlfA08LzgnMEbZ0+NrRt0otJoGrAzKFWjfTB+pN3pDPkxfbq9se8f6FMY19n2B5FPPHAsFDFQIIayDZ7EKQf6u5afBvK8iZ7QsdzYwShghOs2kNnssJGGn7iJ0r57cNKqvdMSbSo07D/ioQXcPDm/oP7tZn1GOwhswSHuyOUGZVcKgQx1Q51Z0c8xm0NNxDR1tq6QsNxIARraPmPlxymjJECvHZyj+ufmBMON6vNhfImSmOI+ET2Ei6qaIK8vR9Jl7oIe8Zt8JQgYkvfFn0AFSIomH+KbBfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 18 2026, Tarun Sahu wrote:

> for_each_memblock_type() always starts the iteration at index 0 and its
> body is a trivial 'for' loop, so it hides very little. It also gets in
> the way of iterating from an arbitrary index, which the next patch
> needs.
>
> Remove the macro and open code its three users: memblock_add_range(),
> memblock_isolate_range() and memblock_dump(). While at it, move the
> region pointer into the loop body scope.
>
> No functional change.
>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> ---
>  mm/memblock.c | 14 ++++++--------
>  1 file changed, 6 insertions(+), 8 deletions(-)
>
> diff --git a/mm/memblock.c b/mm/memblock.c
> index 9ce86349a29f..5aae75d34dec 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -155,11 +155,6 @@ struct memblock_type physmem = {
>   */
>  static __refdata struct memblock_type *memblock_memory = &memblock.memory;
>  
> -#define for_each_memblock_type(i, memblock_type, rgn)			\
> -	for (i = 0, rgn = &memblock_type->regions[0];			\
> -	     i < memblock_type->cnt;					\
> -	     i++, rgn = &memblock_type->regions[i])
> -
>  #define memblock_dbg(fmt, ...)						\
>  	do {								\
>  		if (memblock_debug)					\
> @@ -651,7 +646,8 @@ static int __init_memblock memblock_add_range(struct memblock_type *type,
>  	base = obase;
>  	nr_new = 0;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for (idx = 0; idx < type->cnt; idx++) {
> +		rgn = &type->regions[idx];

Nit: this is really odd to read. You assign rgn and then declare rbase
and rend. Doesn't checkpatch complain?

Regardless, I reckon it would be a lot nicer to read of you move the
declaration of rgn into the loop. Same for the others below.

LGTM otherwise, so after fixing this up, feel free to add:

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  
> @@ -827,7 +823,8 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
>  		if (memblock_double_array(type, base, size) < 0)
>  			return -ENOMEM;
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for (idx = 0; idx < type->cnt; idx++) {
> +		rgn = &type->regions[idx];
>  		phys_addr_t rbase = rgn->base;
>  		phys_addr_t rend = rbase + rgn->size;
>  
> @@ -2198,7 +2195,8 @@ static void __init_memblock memblock_dump(struct memblock_type *type)
>  
>  	pr_info(" %s.cnt  = 0x%lx\n", type->name, type->cnt);
>  
> -	for_each_memblock_type(idx, type, rgn) {
> +	for (idx = 0; idx < type->cnt; idx++) {
> +		rgn = &type->regions[idx];
>  		char nid_buf[32] = "";
>  
>  		base = rgn->base;

-- 
Regards,
Pratyush Yadav

