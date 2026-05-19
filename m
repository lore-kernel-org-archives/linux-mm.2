Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77CE7CD4F3C
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 01:40:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A941D6B00B1; Mon, 18 May 2026 21:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A447E6B00B2; Mon, 18 May 2026 21:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95A976B00B4; Mon, 18 May 2026 21:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 84FA56B00B1
	for <linux-mm@kvack.org>; Mon, 18 May 2026 21:40:31 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 32CA11C0025
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:40:31 +0000 (UTC)
X-FDA: 84782464662.20.6593882
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6B953120009
	for <linux-mm@kvack.org>; Tue, 19 May 2026 01:40:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DJGuWxRc;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779154829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aFNPqECUvzIjQM2xh3jiajRWrtxxd4LfC5NGW5y7hhI=;
	b=BE6okMfFmnpTVLWvU4Vo5WK7zJuNuW3oGcWykwHq+YkIVW2Ct5+lM7X3U4lFX/Bo/VjB2I
	zDPnZdZHVkkHk1mq4WX8ZynJaViPgMlmnPYH0nAIeGU2+LHFBNYCUHhqskqC1NgBkM1JMR
	kGHbAcPkXas7N0GpWHYOLF650kpW0hk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DJGuWxRc;
	spf=pass (imf29.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779154829; a=rsa-sha256;
	cv=none;
	b=SKh1dcJo3O5cIlvAkdCD52AFOeA1idlbRzpBox/SFDaRjeaFs6l9+V+g+oidE0fy2gkkCy
	2I35wPxu2fh3jakuYQRj9q+lBCKZmur8+TpSvTP+yNqslrMQbcK26hbQRsJGNYQib0BNh9
	b2nnSeLhnMOXHLfgc2wX7YTXYTV3p1s=
Date: Tue, 19 May 2026 09:40:19 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779154827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aFNPqECUvzIjQM2xh3jiajRWrtxxd4LfC5NGW5y7hhI=;
	b=DJGuWxRcGchDQ9kHK45v116lREVNAqyqy9LrbHfpc8iFeHs12FtRl+j39x7uPYC8ooHg8g
	DUWHNd35b2t7Zi2vCBG4oBuwi4uYUthgSzQ18xZBUgtHhe/TQC0ykJPHb0z2+YeK6L7BkX
	LCiLJA27W4vm+AIdoaTKerSAFBrGU+o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/vmalloc: Do not trigger BUG() on BH disabled context
Message-ID: <agu_g0HODqOHXodu@MiWiFi-R3L-srv>
References: <20260515153009.2296191-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260515153009.2296191-1-urezki@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6B953120009
X-Stat-Signature: nhxsh75zn4qn1tnot9p941e5cp3o59uu
X-HE-Tag: 1779154829-356645
X-HE-Meta: U2FsdGVkX19kOrFOwNbmluhA4g8zMazHPNEBbmZ1if4qR6i2eJ5e/wajuH08A7A3hQZrtTZUFExDPCkn79tmQzGhrXTkyKxHuAf5fJVQRpkEcyleobFNsUjSbCRPWaFcb81AXT0Wq1+TfFrc3F256RZ5Qcrbdy5iHJdgWYqnsjLCCl3+IqA0v1pvLr96OX9G0sKGaf78xZSJovgtbBaqZ2abU545uBj+6JzJQ0aqzk/fkJaQea5vVmtaMhGmnwHrJHNFT9xBBfNrFl0X4JASz73gQdJjBojNVAG27AkC+kXLuYhP+ANkfww61MXA5HxRbIxguT2/COGHrdkGAF9i+XEgrKtsX1NFZUuwy7XztUX93mZjnqNRSUgdzTz1SZ7uB1MuFQyf0M8KR0UVWyhemYi+WdQuUTzsw16Jx8TSi2LvuV1F8eQxf8CAviiYFJR0eBpCNl2/N3MC/tU6sE8N+y3eI0dDZ0UkfAhdMrT9OdzyQS2sL2Cn8mymf9hrvduNRzMWi7ddwSteJg1fr6u6d4apTuax50hlz5Ayc6Gci1sx8EZYXUWwK5o/ajnhmI7HxhNEBczJhvm8jQJXsXRz7cq+AV5xrEtEUuZr6g5fmotEb4jYp0J9CcEU3c3jqgAp6I030PCaILuEJpHcmBvLAABBqrTc/EdFT2fuoYASqCfP2jM4AP1ryEumCnlVgNSQb4xwDbHqeb34NPGMx3LJQmhwQlzlNh3oD7HLkUB0CwTQUWfz+11mTdQFDoiZfKtJgNtTG/GRYhAw2MGtRi87Oh8K8EnreU0EHiVewfGRYTfQ5qt2+g+PTwwzLBrgcPfYJSEmck64ugpSgwzsnK+PF+5sDfxE5Lz8aVZByGDFiEfcDzpv8EhRVnXd/oQ9KHf+aba+qgVgs+Q21fEKjQ+yQJ+Pg0qb1bizCdB1TIOm2SWKEfqGu/cPpAu9QapzxERYIdIVuSC39c8+rkVl4J3
 9gMuZAZL
 NtEb/3ABhVlDRO6a5jJFg0Gsx8u9B2aUVXUbUeLjdoh8f31SlEYo9YQFcjvMRxySNPIMpwtqQGFRbRkXAuLNBIci1E019DeJTm/mvQsutR2QfEwRvAr7fdP8Jo31zjfmARYfnz73stsY4FWvOD/bN+3yqt5gpsKwhL3K+Nz81HT/tSSa6696xz3rs34RoIaWY5qun/xOWImvIgt+aAPmWBXghSbDf1ju4ez+8WlKzFqvQu/7y3t8QESQhd0fwkwWSG1xQi9mUDQ+dwsElxZoKYjXLWSdQKXO5UQX8EVmYkvX2SzPEGPsuYcnbqUjpIzEoSqdiALejZwx5ZHTU20o6qmOyxH0ZR1CqwlZQxWMNEPSZs45B9HC0WbZeKCknq/Wm/v8RT0ayiWfZ42Oalrx84SFMtWJv4CyKYeTyO6GRm4hfAoQeW6T+CEpVIUeA80ieNjdn4iGm7+iyTM29p5AR2+hB2E2InpX4tcEPe5c7/tRJ07A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 05/15/26 at 05:30pm, Uladzislau Rezki (Sony) wrote:
> __get_vm_area_node() currently triggers a BUG() if in_interrupt()
> returns true. However, in_interrupt() also reports true when BH
> are disabled.
> 
> The bridge code can call rhashtable_lookup_insert_fast() with
> bottom halves disabled:
> 
> __vlan_add()
>  -> br_fdb_add_local()
>   spin_lock_bh(&br->hash_lock); <-- Disable BH
>    -> fdb_add_local()
>     -> fdb_create()
>      -> rhashtable_lookup_insert_fast()
>       -> kvmalloc()
>        -> vmalloc()
>         -> __get_vm_area_node()
>          -> BUG_ON(in_interrupt())
>   spin_unlock_bh(&br->hash_lock)
> 
> this triggers the BUG() despite the caller not being in NMI or
> hard IRQ context.

Because the current vmalloc supports non-blocking allocation, so we
need to skip disabled BH or in_serving_softirq() cases to avoid unwanted
BUG(). This change looks great to me, not sure if I undersand it
correctly.

Reviewed-by: Baoquan He <baoquan.he@linux.dev>

Thanks
Baoquan

> 
> Replace the in_interrupt() check with in_nmi() || in_hardirq().
> 
> Cc: Ido Schimmel <idosch@nvidia.com>
> Fixes: c6307674ed82 ("mm: kvmalloc: add non-blocking support for vmalloc")
> Reported-by: syzbot+8b12fc6e0fb139765b58@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/all/69ff8c7c.050a0220.1036b8.000b.GAE@google.com/
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 676851d5cfe7..273bbe49eaef 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3209,7 +3209,7 @@ struct vm_struct *__get_vm_area_node(unsigned long size,
>  	struct vm_struct *area;
>  	unsigned long requested_size = size;
>  
> -	BUG_ON(in_interrupt());
> +	BUG_ON(in_nmi() || in_hardirq());
>  	size = ALIGN(size, 1ul << shift);
>  	if (unlikely(!size))
>  		return NULL;
> -- 
> 2.47.3
> 

