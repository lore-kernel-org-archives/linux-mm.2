Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 890FEC61DBE
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 937BE6B0088; Tue, 25 Aug 2026 08:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90DF76B008A; Tue, 25 Aug 2026 08:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 827C06B008C; Tue, 25 Aug 2026 08:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9A46B0088
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:59:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E083712034D
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:59:19 +0000 (UTC)
X-FDA: 85139797638.13.3A1F0E0
Received: from mta0.migadu.com (out-237.mta0.migadu.com [91.218.175.237])
	by imf01.hostedemail.com (Postfix) with ESMTP id EDB3D40006
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:59:17 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mHcZVZ44;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787662758;
	b=7OyC3G8flkJ10EcMdc5g4l0dw7hJiFVHdSu8sC0wzBL7awQ9D53PR0hh5GAHGMrHy4Pg9I
	tsHsyyEltekihoq+Etf8F1+PDcsxIrfU5B1grFl6qa45La2lxO+X3dEgVqTQTIcmfQy15O
	5VgdEpoMTX2DZoeB+DWaIKdFizfTuqk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mHcZVZ44;
	spf=pass (imf01.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.237 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787662758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uK5Ad+Btukfe8tO5oA2/EPLxTa7S+nCASEqgqHQPlX4=;
	b=X92kgokyhfvVdhMrXzaLT7jaiTmGDiJ0T31QQa88bj7vuhKPpPVKk5Igd1xE4cfmvtI4Sz
	0sq9LQsCu4KRp0zMutnnau6UQO8hSoqAHseseCID7yvNkRRuuYv73byzHuIO7rZDQnzZ2O
	cmHtOmRgoj+i/fOSwPPgsHy3a/ElQY4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vPycpKER/JF8kLZX9oLztJNJWeKo4SFsQwqcjLqYHsY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787662756; v=1; x=1788267556;
 b=mHcZVZ44HgphCjleFFgUINq9OIsPmkAba+7UrqZi1e5RU05SvUglQ786mM7BrQavFvj8VFcw
 rkoY+gwjxhu1/7yJoERYB1hehA3GkeDuCr0RUQwZOSHnuCPqjxWltvrxo2N03MqB3uD9VlO+vSP
 OyBV+Xix3aPSwQ0QI+JHGAc4=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 059bbcde781145e8;
	Tue, 25 Aug 2026 12:59:16 +0000
X-Mizu-Trace-ID: 059bbcde781145e8
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 20:59:08 +0800
From: Hao Li <hao.li@linux.dev>
To: Longlong Xia <xialonglong2025@163.com>
Cc: vbabka@kernel.org, harry@kernel.org, akpm@linux-foundation.org, 
	cl@gentwo.org, rientjes@google.com, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, xialonglong@kylinos.cn
Subject: Re: [PATCH 1/1] mm/slab_common: reject zero object_size before
 calculate_alignment
Message-ID: <ao2RAVvU5g9Am7_J@fedora>
References: <20260824092454.1693745-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260824092454.1693745-1-xialonglong2025@163.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EDB3D40006
X-Stat-Signature: 9gtjurretder8yhrastym85beny89jqj
X-HE-Tag: 1787662757-989582
X-HE-Meta: U2FsdGVkX1/IQVqfa1wRhuUkBAKq6dET7Xj28IAWcQmkapknxTlcFsG+7AytbGwPA0X1LCBhTB6S34ngVmIV3iAXqi8Qhyae5gsYn5aZom1epENyd2K4UNYarwV5oHpy3GwdzF56Sgt+76OXg6PF7/X9LkLgGdCTMQjyX1V6SuWwRFdS4ydMQZlGVEwRA7N698GcsM6O3ZAzWVVVft7sjspLCPr1ALqbfVKWF2qRjYtRzTOw9B1gpeG9/Kf8QpZxcBt31WAaFr60qHgiOUFjcceMDlIydPBN/z3eyY6fkjGBuAG8lC2WKNqWwRY9XovW7TYPTlRPYIUdJdNhoJBb3RoZGlwCNFT4R7zfXMovTgwxvD6uSd2GQJNczm5Fary2v+tPpryARvkkIhHWljpYVvoLC/6epiGEmHyPNHKRwYrqvSY3BQC+28E7X5W8NBQKa762B1PPU4k6VKfYyPOEiU2qCgPJ+etopC3yZmLwE2bVlGSYwcbpXW4XJMusJi4dXixtaQyOHpfPhgULiCg9bE8CCKgR09bsPCNQlopxDWO4BRVL3uNgg1prWXmGoGNi23EWp0KxoMqnO+CwqJeRfZaMo3a4y7rBxMdayNJbS+laSbOgicZ/qOksiRdF8kLGT8qcPoyownS990iffdOdkQO5HeJ9IjARaBSr2ex7MTl4mndMn6rsspTUFYVxaaOpUl130x02zsoK8jz71DtJs0nrW7qWeDkW1Czkz2moEGwRaQwMFrEX0AZ2IuvH261QbS0N+c+RWM7gtY7NUD6lz4LrTUvNWutD+L81RtOIoxw+1+HcRWos1td45C0cEg71OpicY1qHRCK99+pkmeO+uA6UjXOUFtv/XkVoW4OSM8UqxXRrXOodr0Cn2w9RJGHHV22cJWVSBALa0lBoSi2K8ArXAYm0DAbjhmLvRxkyOHTcbLXG2x/Hr70XUc2E8664X52YUKu+KocSZbq4o4w
 Qbmpd6mA
 +52hun94VDHKwGdDcoAgnKMTSWS3CwBQx9igrX7o3H+XNzfqioghJWUipHvIuW0al00zGYRXIjV9VGHVH1M2eTzCDWZB5KVF0+3zzgn5bOiJDe0rAT2sg0gpkzwtbICpsmfjAE7b/9C4SzxiKqcGbLDXNkzaWpkb8EM/BbxaTDLi6Ng8Tk/F+7aG9jaPuyjAsobQLGxo6lkeD1cOU25wVuXH6B4Nc3PbjiRDob73C7+cXWpC8Es/jjDZcJ5gqn9XlIRd2tSQQf3q4k0TnOtYIJKG2S6oTzffBzu4ZucJHcCm1MAJFh3GehHvD1TaEJ3dF2Leq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 24, 2026 at 05:24:54PM +0800, Longlong Xia wrote:
> From: Longlong Xia <xialonglong@kylinos.cn>
> 
> calculate_alignment() with SLAB_HWCACHE_ALIGN halves ralign in a
> while (size <= ralign / 2) loop. When size is 0, ralign eventually
> reaches 0 and the condition stays true indefinitely, hanging the
> kernel.
> 
> kmem_cache_sanity_check() rejected size > KMALLOC_MAX_SIZE but not
> size == 0, and the sanity check is compiled out without
> CONFIG_DEBUG_VM. Add a !object_size check in
> __kmem_cache_create_args(), which is always compiled, and add !size
> to the DEBUG_VM sanity check for diagnostics.
> 
> Assisted-by: Codex:gpt-5.6-sol
> Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
> ---
>  mm/slab_common.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 657fd75776ea..209fe838fe71 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -102,7 +102,7 @@ static bool kmem_cache_is_duplicate_name(const char *name)
>  
>  static int kmem_cache_sanity_check(const char *name, unsigned int size)
>  {
> -	if (!name || in_interrupt() || size > KMALLOC_MAX_SIZE) {
> +	if (!name || in_interrupt() || !size || size > KMALLOC_MAX_SIZE) {
>  		pr_err("kmem_cache_create(%s) integrity check failed\n", name);
>  		return -EINVAL;
>  	}
> @@ -354,7 +354,7 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>  		goto out_unlock;
>  	}
>  
> -	if (flags & ~SLAB_FLAGS_PERMITTED) {
> +	if (!object_size || flags & ~SLAB_FLAGS_PERMITTED) {

under !CONFIG_DEBUG_VM, I think we ignore the sanity_check deliberately, so it
seems we don't need to add !object_size check here. right?

>  		err = -EINVAL;
>  		goto out_unlock;
>  	}
> -- 
> 2.43.0
> 

