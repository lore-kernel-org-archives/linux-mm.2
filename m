Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56B57C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:20:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9FFB6B0088; Mon,  4 Aug 2025 11:20:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E77F46B008C; Mon,  4 Aug 2025 11:20:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66496B0093; Mon,  4 Aug 2025 11:20:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C3A256B0088
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:20:04 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 555331DCC58
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:20:04 +0000 (UTC)
X-FDA: 83739435528.02.F0586BF
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf11.hostedemail.com (Postfix) with ESMTP id C1AF840006
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:20:01 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cBZ59xBm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ebd2r8Jn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cBZ59xBm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ebd2r8Jn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754320802; a=rsa-sha256;
	cv=none;
	b=q5TKlluVji/Jr+RKfzz478P4blaQmV/ZbjbExwbFH/fcwiXx/tTW/WYPDMfedIxPZoWqwI
	I3G0+z9eQuheJlhlnO353a8z/pTzEI6Cgnznkps4uwba39tu6cMXLD3E+knfQpv/9j8ysW
	Ja34caNWscEaGzTppzaFuPO/vf3PtdU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cBZ59xBm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ebd2r8Jn;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=cBZ59xBm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=Ebd2r8Jn;
	dmarc=none;
	spf=pass (imf11.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754320802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lq0Y2U+mB6S4jVE9iEXQtQ6gO1VJJ4PROG8UK522xjM=;
	b=rGoVCS1wVZJ9Ss9E24mZ/lxN10v2q5lpnS88sdghMrr+Y9iQVVarr0c+dCeffbQD/pTWXs
	LQRvJHu9SaezX4R5LtuZrSpVurd11AOrS5j1Lgkus0mTtW5zGTRJOCoZY6okwb5iNO9Vff
	+m+o8/03BD24uahpaSVj36rZIE0LWoI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1166421A63;
	Mon,  4 Aug 2025 15:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754320800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lq0Y2U+mB6S4jVE9iEXQtQ6gO1VJJ4PROG8UK522xjM=;
	b=cBZ59xBm7trdRqemCJuajnMGyOBqPEVYknyAjKBwKVK75BplXQa+wmA9sONaaXlq/DyXuj
	IOdWWOEsGStpx8UqQ6w6356+q/PYZz4QjZHGMU9Xws37glXtJCH4wbeUmzQ822tUHCTVHw
	R7McNubTzEW749DAzT+bbAVSN99yBqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754320800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lq0Y2U+mB6S4jVE9iEXQtQ6gO1VJJ4PROG8UK522xjM=;
	b=Ebd2r8JnO/900Alx45SS2afwIfdSgS9fu0M+jt8okR9Hod3nyAkrbqJng2K6gzw1YGGIhe
	sqZRp5ucNjYFxRAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1754320800; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lq0Y2U+mB6S4jVE9iEXQtQ6gO1VJJ4PROG8UK522xjM=;
	b=cBZ59xBm7trdRqemCJuajnMGyOBqPEVYknyAjKBwKVK75BplXQa+wmA9sONaaXlq/DyXuj
	IOdWWOEsGStpx8UqQ6w6356+q/PYZz4QjZHGMU9Xws37glXtJCH4wbeUmzQ822tUHCTVHw
	R7McNubTzEW749DAzT+bbAVSN99yBqI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1754320800;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=lq0Y2U+mB6S4jVE9iEXQtQ6gO1VJJ4PROG8UK522xjM=;
	b=Ebd2r8JnO/900Alx45SS2afwIfdSgS9fu0M+jt8okR9Hod3nyAkrbqJng2K6gzw1YGGIhe
	sqZRp5ucNjYFxRAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id F169713695;
	Mon,  4 Aug 2025 15:19:59 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id KmCHOp/PkGiscwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 04 Aug 2025 15:19:59 +0000
Message-ID: <a5fb57c6-fc32-4014-a4ef-200b41ddd877@suse.cz>
Date: Mon, 4 Aug 2025 17:19:59 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm/slub: avoid accessing metadata when pointer is
 invalid in object_err()
Content-Language: en-US
To: Li Qiong <liqiong@nfschina.com>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Matthew Wilcox <willy@infradead.org>
References: <20250804025759.382343-1-liqiong@nfschina.com>
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <20250804025759.382343-1-liqiong@nfschina.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C1AF840006
X-Stat-Signature: dn74b19ezxaam999aum3pzg4xye1jy4n
X-HE-Tag: 1754320801-819615
X-HE-Meta: U2FsdGVkX18rBGZuAy2w23LRSXjorfFOvXk2RHECeMhIQHKiry71TTNB0ou0cf8T2u7+v6f0TlVblVIvHN9l2MJzHYL4RkKXx58luGG3RcUJ6vS0IyvYqIFgOyBc2QKcBQjrc8wVrNwT4qjpYpF5iTyTo2wcTzgMjkJlI+wNJzat4yeJGoerdFBKbcdxFkIKoUlwGT85F5sY1VrBfNt9yrN8pBNEsQsQCuVn+yCb/8bEAzK5FYb0WhJugzmUBqVXf5fn5d2KMydsBEvr74cxWJvmRu4XpspkCJ+O3Vu3VVkGaa3Xj71nmBfT2aBmZqjYOLH4E3/SwasYtQcZ5P5cwjbk2Sw4vkXyv2L6ztmPJadlSz37lIypCbLJMFK6LmdRNe89wucRpLwYvlYAl1KjFvGDPZZAoYjyorLIB4mTmW3hxg5Q0gOqbKOcPiOMgc/Gp5y0/Mb4V1Eix9wnX2kH7FsvNLBd/YD0Cp9PFExNU8YL4HAo6KhLHhJF8Mxd0vtndW7oiiRHcBMJKJCi/BGowZsXS5yAPJNePitSt00uaKkwZmWPhvg7KsXpim6WeBBAdXBx+/kO5xvOy1D+kR6/S08BAMBLkx/j4Jm7qFDEIvfuWB6/fK0hpejYhGj1zb+PkIwE34O1Zkb1k5HnOBOjyUjxEjjNit9s4gQAWwggfnUVY/wC/fF6hzdMOMC0vB4DGPqbJIOX9YGKBytHX+C+oDayuqyTzsCD1oTeyGiEOykUAIxsGletUzgQk8HfYLGTtIrQsFzet0ft11sp7rL5GlPiJDJ1DYSgwFTaDDUL09359pBooafIjcGk+/sCCnRG85JT5DRGWGWDeh6TiVo2bhcH1pmRyyice1NfU0ArDo4bLyLkmtQ39/cVFQn3tYpWh/ki31DWc2LzHl6m7RcNJxbpIRmcWWFaePzUJB86V2OK8CMrg+EUN4MN7XEZPZI30JkZc/aWP7cSToqDtKC
 4f4olxym
 xENUGWE05tYuq0nUOirZhSiYEcFrQ+9odYKSovwbkPuWkbgxWj2YTm0Mn1f9OV9H+ZOr3xMxML7i03t4yOr8lxkadWg4np16gc7LLYpXmhZn8H2cPgdXV7b61b0/Bip5X3LUIc7Zb6QEFtbmiVQ4FUuTiTSH4H3H2REHHMO5CmdZ46vpL3vUPxJD7bV4refpVUe6uUJA77Opg514SL0b45TEH3Vl6FTcrIYSDbK7kCLngDX6od//jnDzCq38vvT+1s8GMyYnYfcf+735cnf84xT0LkX67BNmN46eOJ41dFCyjF6Qyen/h0rDdBjCFm98uI3cKf3SnQiSO46DQsHVtPvCdRddReUDI3YKR7TVcxDL/YDfobc8tbb+YFAVNdUHvZ58e
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/25 04:57, Li Qiong wrote:
> object_err() reports details of an object for further debugging, such as
> the freelist pointer, redzone, etc. However, if the pointer is invalid,
> attempting to access object metadata can lead to a crash since it does
> not point to a valid object.
> 
> In case the pointer is NULL or check_valid_pointer() returns false for
> the pointer, only print the pointer value and skip accessing metadata.

We should explain that this is not theoretical so justify the stable cc, so
I would add:

One known path to the crash is when alloc_consistency_checks() determines
the pointer to the allocated object is invalid beause of a freelist
corruption, and calls object_err() to report it. The debug code should
report and handle the corruption gracefully and not crash in the process.

If you agree, I can do this when picking up the patch after merge window, no
need to resend.
> Fixes: 81819f0fc828 ("SLUB core")
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
> v2:
> - rephrase the commit message, add comment for object_err().
> v3:
> - check object pointer in object_err().
> v4:
> - restore changes in alloc_consistency_checks().
> v5:
> - rephrase message, fix code style.
> v6:
> - add checking 'object' if NULL.
> ---
>  mm/slub.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/slub.c b/mm/slub.c
> index 31e11ef256f9..972cf2bb2ee6 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1104,7 +1104,12 @@ static void object_err(struct kmem_cache *s, struct slab *slab,
>  		return;
>  
>  	slab_bug(s, reason);
> -	print_trailer(s, slab, object);
> +	if (!object || !check_valid_pointer(s, slab, object)) {
> +		print_slab_info(slab);
> +		pr_err("Invalid pointer 0x%p\n", object);
> +	} else {
> +		print_trailer(s, slab, object);
> +	}
>  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>  
>  	WARN_ON(1);


