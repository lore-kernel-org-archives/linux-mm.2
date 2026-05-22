Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E367CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 01:43:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90FA66B008C; Thu, 21 May 2026 21:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E6B26B0096; Thu, 21 May 2026 21:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5436B0098; Thu, 21 May 2026 21:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68B576B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:43:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12635A02CC
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:43:00 +0000 (UTC)
X-FDA: 84793357320.22.B68FB69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 43895140003
	for <linux-mm@kvack.org>; Fri, 22 May 2026 01:42:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzlH30ek;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779414178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mlNm6TyZ7Md00Vr37/Ne1y17FHH4DvK/soaPft4LyGE=;
	b=Jy7k0GB3CkXqRgzhmDCcRT0y3ffD/4LgKkkIcE+o5uz+3oNGZfYb0Eim02LTAilUiLRLN0
	aeq1Lf1eOOhUbV0RBMQlPsvup6TQK10fK7bqs4o9JcLXhgfw/OcItEjxNbJpNJJXvmgXR1
	xvPTXg/sJsaRarVdRnFa6PH787LTxIE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OzlH30ek;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779414178; a=rsa-sha256;
	cv=none;
	b=NFrAdJYsSzRwWvAMUwztMycEWpuR/I4g4IoJNYIDjo4vLMsmPQLEimqAqUyE53FmBTxUJl
	SGi1XI5AArz+DmQr4nkX8AmUhk0LrL0GUeQXfUHWmQpHiIH+Y+nBDZ0Asv/S8RyPrG3xG+
	mfHU6qwWHx2Ap0kIfKxPEvCrZ0RXsGs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2FF1D43AF1;
	Fri, 22 May 2026 01:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB991F000E9;
	Fri, 22 May 2026 01:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779414177;
	bh=mlNm6TyZ7Md00Vr37/Ne1y17FHH4DvK/soaPft4LyGE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OzlH30ekNA2RUaCa9m4cCbrFAmMxCb0lDc5RdG5aAgcn4hDxm20AYqYANNI/W6TwX
	 3Nl7LpWjmo/IN+bNManh5WySchj1Pty1xi3TQ2hYLo4UF0E/nZ92QZsVNKbqL4Lg8A
	 iKxnWVensT53c6CCD2p4xVcNh5Nd0zmBPf2JfMxMAFzE6iL986Bn86e7gzdGKlhVn8
	 LoMpjhCNx3jV8iLAnuJ5cCrPPaKVEPGLgqahwn0pdmNp313qZjx3HOSrvq04TN8iAe
	 jxySjzFRay76CmTSXyStYj8qAKAWGBAPE4JmROMic6WZRmO7OxrXBfjlTh0nJ2XHVC
	 bptwyQp9PrFow==
Message-ID: <aac8ce93-8236-4471-add0-c04ee7a84d0a@kernel.org>
Date: Fri, 22 May 2026 10:42:52 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/slab: fix probable issue of dentries registration
 under /sys/kernel/slab
To: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter
 <cl@gentwo.org>, Hao Li <hao.li@linux.dev>
Cc: David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Hugh Dickins <hughd@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Pedro Falcato <pfalcato@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 driver-core@lists.linux.dev, Danilo Krummrich <dakr@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>
References: <20260521111516.1903707-1-vladimir.zapolskiy@linaro.org>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <20260521111516.1903707-1-vladimir.zapolskiy@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43895140003
X-Rspam-User: 
X-Stat-Signature: 9gg9oxkmmio3osqa77u5bg3ydoeg4bky
X-HE-Tag: 1779414178-568764
X-HE-Meta: U2FsdGVkX1/RmnrLwmBhv4rlm79dDUnsA526rQQ6DyLntHdgxk2V4xcH2EGda1pt4pLiGigtI/VkLNbl5m2QskSw3Nd9DysBuykrb1IAD6Vcx4TKdWWCqZO2ca2OpsxLxMK0QtAZb6tBLMHtsPyEPl+MQfb+n4rHRqAUVlzBgLiCTnRVpM2vEYTxYjjsvQyYfySGBPWUmadtHh5Ps8S7RMbfLCggBxoTZKLBH/cozHzplEPAmpdjpb7g6dlKGd7wj2/G95imfzTCogleZpGDyw6uta4O7oCRm76WHjLosFPXdIFfkoWiHyScH378JikbxVAPXgYckmERDcniDj439QIVLIrHgp1QrXQmcXVr/F6HqZULPgEcrI4otKuiWQffbNMWF6w9x/y7rw+FNVQZfqe4b+YdukhVPGF7Z8AUHEzOqc3gn1Jx9zTB2ajahlNz/1xdsAhILjDKPd0OXoYidbG6Phtihc+hENubRQnRgb4fZJPuMdSlJaZ4pYLhcxQu+M2DDGclJ+3h2V37wUc+Jj4EgTLuBOM1SMrhLPvkLikoXKYSc1o1BZAF2UGg7W8poGQBVsutTkw9ZxULO+IXpcUd9JbBOfLpBrxkghYAZR5ducVgVE2gp1qmPHkpDaD6kvO9KoKLq8itiAyhuFSeBxTjRJrarW0r8YdQL7xr6QyozJhsKoQZJri1+yQiKvZZhq9BNUBOa3DbtYlj1Zpcg2BDGx4Kfj+n4Ur+30E35FCb3An+fqjU3wRqjEHcSzeXXROF4bA2JSV7g28Ex/A1byjilAN6knWX8xR+48J/bSdZQnfvH1AB15FLwMqkMGMyGSU41Rl3vOSko7QfIPWrZ1rhQLxQDFXFfoTinT2v5M67w7UKOSLnIFHHnzdA+mg5ysrlrFNSTdUzXAgORyiQDH9ERt9+BQzRPaLQ9xYUIrHUDebMoZ5VzsS/TeAWzyUZscg98smjT33JIM+/U8o
 ZSY/gcpl
 MeT1KchQbvyOG0ruCXhdXnYRdtxjcHIAdJpC/r2QBjvv+K4vZJKGCMDBncCzmHSUm0/7oDItTDySxRcPttRBXOlK7ZCcggzmqmv9Zuf42S+a0nFyAkFWzlTcv12F0VkQUKXh116t60+PFxM2RjrQkoJ4mhzPcCf1jNOOKgtI+8QivI5o0c1JwM5vFjXEvZRk7XNtB4HETf0hCBA0iSSu5Ki56pgukszI/kgkOpBeHzlB0sAH8jEnhR8Dkk+FqMNgMSFmnSoFTrNGUbQpPERN31c1Yij/o44l172tNBqRpNSOReq5hmgBxFrNLd45L6+QHxbh2en4/kz/WSJdca1KH249rpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 5/21/26 8:15 PM, Vladimir Zapolskiy wrote:
> L2TP/IP and L2TP/IPv6 protocol names contain a slash symbol, however these
> names are blindly used as symlinks to slab cache objects registered under
> /sys/kernel/slab. This kind of symlink creation is successful, but its
> dentry is obviously broken, as well it breaks the access to the list of
> /sys/kernel/slab dentries.
> 
> Likely L2TP protocol renames cannot be done, since the defined protocol
> names are exposed over /proc/net/protocols for years, but the symlink
> names can be renamed, because they are yet to be properly created, and
> this should be eventually done by this change.
> 
> The problem manifests itself, if CONFIG_L2TP_IP build symbol is selected.
> 
> Fixes: 81819f0fc8285 ("SLUB core")
> Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> ---

Ideally we should reject '/' and let users avoid having it in the slab 
cache name instead of silently replacing it with another character (you 
don't have to rename protocol to rename the slab cache name!).

...but actually, I see kobject already replaces '/' with '!':

/**
  * kobject_set_name_vargs() - Set the name of a kobject.
  * @kobj: struct kobject to set the name of
  * @fmt: format string used to build the name
  * @vargs: vargs to format the string.
  */
int kobject_set_name_vargs(struct kobject *kobj, const char *fmt,
                                   va_list vargs)
{
         const char *s;

         if (kobj->name && !fmt)
                 return 0;

         s = kvasprintf_const(GFP_KERNEL, fmt, vargs);
         if (!s)
                 return -ENOMEM;

         /*
          * ewww... some of these buggers have '/' in the name ... If
          * that's the case, we need to make sure we have an actual 

* allocated copy to modify, since kvasprintf_const may have
          * returned something from .rodata.
          */

(Sorry for broken formatting my email setup is bit messed now)

But sysfs symlink doesn't handle this.

Any thoughts?

[+Cc DRIVER CORE, KOBJECTS, DEBUGFS AND SYSFS folks]

> Changes from v2 to v1:
> * added slash symbol replacement to __kmem_cache_create_args() as well,
>    many thanks to Hao and Harry for review.
> 
> Link to v1:
> * https://lore.kernel.org/linux-mm/8a80496b-1568-4a0b-a878-836c27d19ad5@kernel.org/
> 
>   mm/slab_common.c | 23 +++++++++++++++++++----
>   mm/slub.c        | 23 ++++++++++++++++++++++-
>   2 files changed, 41 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index d5a70a831a2a..b9930521496d 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -366,16 +366,31 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
>   		    object_size - args->usersize < args->useroffset))
>   		args->usersize = args->useroffset = 0;
>   
> -	s = __kmem_cache_alias(name, object_size, flags, args);
> -	if (s)
> -		goto out_unlock;
> -
>   	cache_name = kstrdup_const(name, GFP_KERNEL);
>   	if (!cache_name) {
>   		err = -ENOMEM;
>   		goto out_unlock;
>   	}
>   
> +	if (strchr(cache_name, '/')) {
> +		char *n;
> +
> +		n = kstrdup(cache_name, GFP_KERNEL);
> +		kfree_const(cache_name);
> +		if (!n) {
> +			err = -ENOMEM;
> +			goto out_unlock;
> +		}
> +
> +		cache_name = strreplace(n, '/', '_');
> +	}
> +
> +	s = __kmem_cache_alias(cache_name, object_size, flags, args);
> +	if (s) {
> +		kfree_const(cache_name);
> +		goto out_unlock;
> +	}
> +
>   	args->align = calculate_alignment(flags, args->align, object_size);
>   	s = create_cache(cache_name, object_size, args, flags);
>   	if (IS_ERR(s)) {
> diff --git a/mm/slub.c b/mm/slub.c
> index 0baa906f39ab..843bed864a7f 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -9634,6 +9634,7 @@ static struct saved_alias *alias_list;
>   int sysfs_slab_alias(struct kmem_cache *s, const char *name)
>   {
>   	struct saved_alias *al;
> +	const char *al_name;
>   
>   	if (slab_state == FULL) {
>   		/*
> @@ -9652,8 +9653,27 @@ int sysfs_slab_alias(struct kmem_cache *s, const char *name)
>   	if (!al)
>   		return -ENOMEM;
>   
> +	al_name = kstrdup_const(name, GFP_KERNEL);
> +	if (!al_name) {
> +		kfree(al);
> +		return -ENOMEM;
> +	}
> +
> +	if (strchr(al_name, '/')) {
> +		char *n;
> +
> +		n = kstrdup(al_name, GFP_KERNEL);
> +		kfree_const(al_name);
> +		if (!n) {
> +			kfree(al);
> +			return -ENOMEM;
> +		}
> +
> +		al_name = strreplace(n, '/', '_');
> +	}
> +
>   	al->s = s;
> -	al->name = name;
> +	al->name = al_name;
>   	al->next = alias_list;
>   	alias_list = al;
>   	kmsan_unpoison_memory(al, sizeof(*al));
> @@ -9691,6 +9711,7 @@ static int __init slab_sysfs_init(void)
>   		if (err)
>   			pr_err("SLUB: Unable to add boot slab alias %s to sysfs\n",
>   			       al->name);
> +		kfree_const(al->name);
>   		kfree(al);
>   	}
>   

-- 
Cheers,
Harry / Hyeonggon


