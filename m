Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D540CA6015
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 14:22:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 351C46B0096; Fri,  9 Oct 2026 10:22:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3294C6B0098; Fri,  9 Oct 2026 10:22:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23F6E6B0099; Fri,  9 Oct 2026 10:22:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 07A946B0096
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 10:22:07 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id EDBA51A03EC
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:22:05 +0000 (UTC)
X-FDA: 85303302210.26.48E1E68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4D5B018000B
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 14:22:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0VPT2ge;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791555724;
	b=gD6NRZcqvld+tSdURgYUyFPso2F9u/nhsRFcdlzNhNzN+/VnAi1Lb1AU5FAcc1JGxtW8yq
	7PF5whlIGZRPKH/W3QtRlb6eWAVxxoOTpqwcHP7Y1XoL5btkVlUXS9jaKp1AueiRPappAX
	cfSRTFRU545YwqoGMpymSSSAU/VI5YE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J0VPT2ge;
	spf=pass (imf16.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791555724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zBnO3x40NIzVOgWJRZVkADybTZas0fGVJZTACvz2ApI=;
	b=vFes1D+QykPunc4Rf4w/fSDPmRxvLbiGv7PGM9ASSFxKtcDDaCLe8TW7we7viNx7zqwvpA
	eiNuS3qhp+durTXwYSGvH33iIjkmpW+T7qVWhv8/5RXlF8+n6BOYod4jq1RNdv9lJ6OgLw
	g0t7d8cfkH3JnxmrrdPCxq8fLadqo/A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 75B1B40978;
	Fri,  9 Oct 2026 14:22:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C6D1F00893;
	Fri,  9 Oct 2026 14:22:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791555723;
	bh=zBnO3x40NIzVOgWJRZVkADybTZas0fGVJZTACvz2ApI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=J0VPT2geg9nK4PxvkGdJPDu1Ax2DB4cYIOYa0LlOk5CNt47gcJXXwVes5he9zpyMb
	 fdcj3kb6IcAbic2YTs83/uVmj2sIRXVbOmtG8+qjWDvrGYZu/sbGQm6GszWj4esD0s
	 ZnSZiOSAhpQTGTKtFvJaG0gsTUFnzqpG1rQRrNwzwTmF3KnNL7oakXb+GkJpQ354HY
	 uVOsd+bTqrzZ8V/WvNG4TSwgcA028JmqpUSzBnupx7vRy+L1mbvoarx0ECPbxOsUGD
	 sOm77pYYA2gkT4AvO7UMrqNENyeR2dpGpbfEWb1ic+Qze5UmCZxXqlaWxyuiaGFBNQ
	 ZDrR6oUHQOsYg==
Date: Fri, 9 Oct 2026 16:22:01 +0200
From: Harry Yoo <harry@kernel.org>
To: Kees Cook <kees@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, Pedro Falcato <pfalcato@suse.de>, 
	Kuniyuki Iwashima <kuniyu@google.com>, linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v6 2/8] ipc, msg: Account msg_msg allocations
 with GFP_KERNEL_ACCOUNT again
Message-ID: <asjhg2e4-WSeKuXd@thinkpad>
References: <20261006092030.got.500-kees@kernel.org>
 <20261006092035.166776-2-kees@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261006092035.166776-2-kees@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4D5B018000B
X-Rspam-User: 
X-Stat-Signature: jcqs1fbboom3tmtzxdfognxyz9q4ongt
X-HE-Tag: 1791555724-910400
X-HE-Meta: U2FsdGVkX19lNu/MSYVwLnGKnDwRxtdyZRsDwLZ9qQC5MUSgT0RBMfSCRuHbGfOPyvvJwkOr7nI0VvlSBlT5A0OdRztYGlSAhgLiUh0lL6jn5my5dCc8e+kGfQmED/vEtC5+7Vc9RmGoc6OEKBCDA64wntCVl5Pwn4sZA19zlwKwnnBc6glCHmEKAX5vmsYU9ilF/6nXAKOxIfmBiX9kdRIK1U+AAwWcmYoT0oqxP6Xt4Q0QTMV08N8CHCCN3mpwGK1PoE1uYMiYgMqzNsUEng42xYVvkk/mTK99EdcUEZ56xk6E4t5DwBRA24i7V0Nt/XOmjaV0JxBialpgJ4ZWqXISb11B+z8VA2VzIOCiVK7675LzPxXCmRMo6omcHzWVyRSlqfX7770G1pepG+JeEUa8qOHF0fEZiWtLriS5JYKGtsuAoYaJJGnr+oPz0UREe/7Pq64OLCx8mYZ06NgVtHvHOMrSmSC4sOXGAOtCdFzlFDmqU0lDQWbs8Qr/kTpOu/lWEBV7EvkD15K6ogYX3hmPEtvRfyMWURwhGUTlHSUYBlA87Wjxu/hK4Ea/i9uZghYHthi6vTXHX02ISZnR9j1Sh0h6OTOvdOKk1fhuy81MPDWit9S0O+OI6dS6rHRDvnVlkyeHecl245kwWzlQErj6J1MKTd8GRvQ6HgmTO+H80meQkqJaOj+dCW+rLtCMwVRfiJrEzFneV5DpbIjftXaKONQK3Gm9g/cIfxg9gzU6N1XdTXEMXrbFeTfmcIt0nUB1vsOSQo0KKB/jcX+MdUpzYSH3urpCPdz423YEWtbuKjFDDxmDJQ5ADLJWVYYR2ihph9smwcgWExtGexm6LnuLplw8EpO0Lstd/G5XI5q0qvmW2wxsKJzaBmr7arvO2D1zDGaiMH1rzNKBV1hYZzelRpJTUXEApwi0WMW0NwWts0Yp63w0m3DRO45P1Q7Ow8dkTtw5MMOL5ciEx0+
 gHz79068
 LLxK31ING902yx3FJYAR5CBSqP4NMXPemJyVtTrdsTuofU6FwGM0LeOe5Vc58RROq3T0aIQKAHMNGd4YlXlTDfXaRGAZQ0aXzWQbJttOkNGLlIE1WnnNMaXTeytp9xfRxfMEKw912nd9q3BpzyF+2e4jfN8ZJq7um8zXf71Qw3C3ABVmfqAbvjvqzI068uUsk2ENP17r7oE7nOfTKRB2uMG9m7lI3+GlS/zvKnXZQZMKwod9J1aZweY4Uz6NxznIzbCZ37YLdW8szxvfjfQ6DxXknXcOtIemhcpBagLkiWiICLWNHKKVEM/gCH5ylOmSDnF6n
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 06, 2026 at 02:20:28AM -0700, Kees Cook wrote:
> Since commit 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for
> alloc_msg()"), alloc_msg() allocates with GFP_KERNEL, and a msg_msg is
> accounted only through SLAB_ACCOUNT on its bucket caches.

> With
> CONFIG_SLAB_BUCKETS=n, kmem_buckets_create() creates no caches and
> kmem_buckets_alloc() is a GFP_KERNEL kmalloc() from the general caches,
> which do not account it; the same happens when kmem_buckets_create()
> fails. Either way, the allocation is not charged to the sender's memory
> cgroup.

Ouch, now I see what's gone wrong here... 
The fix for this bug should be Cc: stable IMHO.
Allowing to escape memcg charging is not good.

> Allocate with GFP_KERNEL_ACCOUNT again, as before that commit. Memcg
> charges such an allocation in whichever cache serves it, so drop the
> SLAB_ACCOUNT, which no longer adds anything.

Hmm in the long term we don't want allowing __GFP_ACCOUNT allocations
that are served from slab caches without SLAB_ACCOUNT, as this wastes
memory.

See: https://lore.kernel.org/linux-mm/20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org

And now I see the initial kmem_buckets design did not sufficiently
tackle the question "How this should work when kmem_buckets falls back
to kmalloc?"

I suppose the kmem_buckets' abstraction should not be too tightly
coupled with kmalloc caches. Creating a kmem_buckets should be
conceptually equivalent to creating a set of caches with speicifc
slab flags, size, align, useroffset/size. (for variable size allocation).

When it falls back to kmalloc, kmem_buckets itself should provide a
compatibility layer when falling back to kmalloc.
(Okay, allowing ctor is completely broken, but other attributes are fine)

...I don't agree with the idea that "since kmem_buckets can fall back to
kmalloc, kmem_buckets can only have the same requirements as kmalloc
(slab flags, alignment, etc.)".

By that logic, shouldn't we give up specifying useroffset and usersize
too? :-)

> Build tested ARCH=x86_64 defconfig with GCC 16.2.0, with
> CONFIG_SLAB_BUCKETS as y and n.
> 
> Fixes: 734bbc1c97ea7 ("ipc, msg: Use dedicated slab buckets for alloc_msg()")
>
> Assisted-by: LLM
> Signed-off-by: Kees Cook <kees@kernel.org>
> ---
>  ipc/msgutil.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index e28f0cecb2ec..1ba8e59cb255 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -43,7 +43,7 @@ static kmem_buckets *msg_buckets __ro_after_init;
>  
>  static int __init init_msg_buckets(void)
>  {
> -	msg_buckets = kmem_buckets_create("msg_msg", SLAB_ACCOUNT,
> +	msg_buckets = kmem_buckets_create("msg_msg", 0,
>  					  sizeof(struct msg_msg),
>  					  DATALEN_MSG, NULL);
>  
> @@ -58,7 +58,8 @@ static struct msg_msg *alloc_msg(size_t len)
>  	size_t alen;
>  
>  	alen = min(len, DATALEN_MSG);
> -	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen, GFP_KERNEL);
> +	msg = kmem_buckets_alloc(msg_buckets, sizeof(*msg) + alen,
> +				 GFP_KERNEL_ACCOUNT);
>  	if (msg == NULL)
>  		return NULL;

-- 
Cheers,
Harry / Hyeonggon

