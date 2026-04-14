Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB379F531F8
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 07:20:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 471AF6B008A; Tue, 14 Apr 2026 03:20:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4219E6B0092; Tue, 14 Apr 2026 03:20:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35ED66B0093; Tue, 14 Apr 2026 03:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 245D26B008A
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 03:20:47 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D1099B9730
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:20:46 +0000 (UTC)
X-FDA: 84656314092.27.1350714
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf11.hostedemail.com (Postfix) with ESMTP id E986740003
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:20:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bChfPImS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776151245;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPWYjo9GhqaMpwQ+mEVfK6/tiojaazojzQ0cBIRZ8mo=;
	b=vMeQJ1xCgwCnmCynVxa8Ok5CXKqluK0FMgmq1bz87+DNYNVc4ZdzKCKBk/qHb62BnBMgCy
	Us1C79yuJvPXrd1JHsgu35UwUCbluEMvyOzLgIF+CA1OaDxeXICCFZVEBzjb3oMTe08dPx
	v2Muy2FnOqTpZRdnrMIScrhZ5D4NaoA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776151245; a=rsa-sha256;
	cv=none;
	b=GQF6/DvT9+RwWVrIK8B5OIpeFteMnZr5USNpXFfjtKSedlH6ezBySatb9BzVhl28HmF+Jb
	6oUU9lfeiUXui70eZ0rF6CsGpzBQmBQRMh7Op6OyC0+WelAQlQp5kZMAZZD1CSkU8/uod9
	15yGzwHt5KSBOBXk84qOpIRSyCSnC7I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bChfPImS;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
Date: Tue, 14 Apr 2026 15:20:33 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1776151241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=JPWYjo9GhqaMpwQ+mEVfK6/tiojaazojzQ0cBIRZ8mo=;
	b=bChfPImSqYu4PwGtucE+CcphBwv4vWnwTUwbVosYoWuncoTp/VY/esGiJ1QDfgKqf7W9Nf
	EFwgQaAFmBf2MXUGOIv8/Cseejsr4ds1ljv4cITBnukmOckSCL/A7KO4D9Lp7sMuKfn1Xg
	OhYTLpr/s1hYd50w32rFUqv54THNMtQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Baoquan He <baoquan.he@linux.dev>
To: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <bhe@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
	stable@vger.kernel.org, chenyichong <chenyichong@uniontech.com>
Subject: Re: [PATCH] mm/vmalloc: Take vmap_purge_lock in shrinker
Message-ID: <ad3qwblVAJ0tUQBF@MiWiFi-R3L-srv>
References: <20260413192646.14683-1-urezki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192646.14683-1-urezki@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: E986740003
X-Stat-Signature: a81tgzzpcpurnf7pmz7t8cgjg3hfqkkx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776151244-692554
X-HE-Meta: U2FsdGVkX18VB0abqW8kPB6003hymHvI/G5KezTFjgQVpY57u1UM5FD5VZdjH+iOn5Z87hkBoXKm4SwN5ooS8ylhcTc2MaoVmSBIgvhMv3FvSB8wjHjLiSrFeAzOZqZrWcSgqv9RojqXOQUyfXxDuM45O1rvzJ6NAV0gF4DYYHd2TdrdpAYQ5SiaEQkYraRsw3h7fCO5W3QVjYi5YTLE+LSKVjcQfdRVm8lUw/hPm0ODJdp1ATgYk24qVvpujgH6spGwXYEL1W5FwYxlENQH3NKvye4Jka3fW694nJrdotEVWLMYNx3x/rWtnWsLgXEBAzY3GaInpT3ao85q+izB7oH43Qtpk6rs5jl2cgoMokESiBu31zrBMW8tOEGty/SvTv2nnnDSCyYwdPsCYIoh+ZP31IEDCgRSFN112BiBx1XdYLOa7vLLFx5vZW2Nz3xxL9AVVZxGj/kvKcZsHKIPzsqPZvz+iGSq7GXBjvZA2mtDvouFbisrQKYvJ1UthwdiQoFx8FkoLmgE01/4rUlqTEb8JjKwEDVnpp4/AGr3lm8btFt4Z2NyqEBSezWaAT2zGxUjJ5qNhr+OH2NexYfLhBK8c/jeRJY8ljG0VRjy03oUqafwMf+Ao5pIDGA+G7gcYRMxUBS8H6Ma5tl7aOlyOcXDEL0iGCnS5ZAPia7DStqSSLw22sRrC8ptGhE2HgTUVBkuonm3LBSyUJkHEm+LFmwkdam7wMnLAahdYeGwAMzEuUd2APeWG34e9vRUYjln1fVafJkCK3lrxXhFjMThr8yiMg7IAlgG7H1cQ/k88OjUMhuYYuFXCI50qxfQbhpQIuksWR0i8WODGO18vTpAbT+OQ5OYE/8cW5EEGHvKiB58ZI0Hcd+t9kEcm/fwQMPrIQxlxr8TZ/eiw5B9tqbY2GUG6LcwnskBwl1gkEO1ER/iADZZZA9qYCDecNMaebREToN1N7K3tJbdtRYn9ci
 C8+p6yOO
 0llhHUhRkyd0WxYcykSdxbdR8mc+ZAWYol9P8SVQqwihUyVJqG4Dwq+KIrbuqhwdUxKaw8XQFl8158TvpGeCn8MKY2F5bMR70eCEmkRRx4PR5h27RIJw/Iy6ASJWJlvP0hjbhpT1eHsCvXcwx9Uol8Kg+HjM+mbT1gc59B7i3NI5qFV51UD2OQnPBUxHqJitn8i1L7kpSyI37/GmvKEZFn1pMZKbhh+aPaacl6yC7Z27JqUvltC2KpJ9vQmqfXQ+Ir8HllOBL0ZKgfKhpoUcZ2ILodbGVOgrGW1SDo4a+ZlcpD4/pSMnjs6Xf/XRT4dHmLj1fkVzCnIy3Vnls1fLvzR6ECGf4V2HJfnz85XbAsBWA9TLjBUXxJ6bXq7RXVFPTSvYw+Q4GrjFNZfvZXv0mLCy/R8G6xT6p/unEyi4bCdtCkLX5FjVqpktVZg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04/13/26 at 09:26pm, Uladzislau Rezki (Sony) wrote:
> decay_va_pool_node() can be invoked concurrently from two paths:
> __purge_vmap_area_lazy() when pools are being purged, and the
> shrinker via vmap_node_shrink_scan().
> 
> However, decay_va_pool_node() is not safe to run concurrently,
> and the shrinker path currently lacks serialization, leading
> to races and possible leaks.
> 
> Protect decay_va_pool_node() by taking vmap_purge_lock in the
> shrinker path to ensure serialization with purge users.
> 
> Cc: stable@vger.kernel.org
> Cc: chenyichong <chenyichong@uniontech.com>
> Fixes: 7679ba6b36db ("mm: vmalloc: add a shrinker to drain vmap pools")
> Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
> ---
>  mm/vmalloc.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 61caa55a4402..676851d5cfe7 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -5416,6 +5416,7 @@ vmap_node_shrink_scan(struct shrinker *shrink, struct shrink_control *sc)
>  {
>  	struct vmap_node *vn;
>  
> +	guard(mutex)(&vmap_purge_lock);
>  	for_each_vmap_node(vn)
>  		decay_va_pool_node(vn, true);

LGTM,

Reviewed-by: Baoquan He <baoquan.he@linux.dev>


