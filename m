Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 86F45606A20D
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mCuUCxkM
Received: by kanga.kvack.org (Postfix)
	id 922D46B05B2; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D3806B05B3; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEA56B05B4; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 57D586B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:37:07 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EE9DDA8638
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:37:06 +0000 (UTC)
X-FDA: 85419764052.11.DF12B1A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D80B5180005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:37:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCuUCxkM;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794328624;
	b=5/h1Hzl7m/K/vHjriYS6OcF8tqAGqUt4adjD/vG7NLglvdZxOvdMhYfdT2zVf0sur5UnJr
	+Ej0JQcOmkmKYmGkkATuHdW5wnpcTR7t8mHskNZEA6oigUg09rh2dap4o6qTXnvkVjt7/1
	NP03oZl4xJX5fSBB+2gTGQHz1o5MNcU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mCuUCxkM;
	spf=pass (imf24.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794328624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxH6nWu3xoi9MOLiEKHpTCtqocoY9P3KkSkL15dxQ2E=;
	b=w/TiRLWyTCQ28NADS+RDPUJGC/8H7FIqnZiy7BpbD4ijPpIJb+g0fgTE0XqiCR6gVSXEJO
	bmsb0vkXDmFK51ugXsWCTnGSK5C5vOABIuAhT+A/u/RoFTp6KOicF0Bg508zWHWpI25Rat
	seoX6S/QQUOcTr/nofkk76VdGOTUjZ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2E2F543D93;
	Tue, 10 Nov 2026 16:37:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2C401F0089F;
	Tue, 10 Nov 2026 16:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794328623;
	bh=oxH6nWu3xoi9MOLiEKHpTCtqocoY9P3KkSkL15dxQ2E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=mCuUCxkMSU402Oj1O0AMoMXQm08SgmKiJRj+2b6/XHGVUnUUUXvWULEFS4WoZNsLR
	 q0riXqwIPXhIfgRQQzOtH9ck1XgPYID22txx/TeeYcp8d3xHAjKkAdEV5vODmBE9rJ
	 kW0wp+vrT9yxRIU5e7kuSGyj4mVIGTC1Rk0Rh4+mntLl8ymXLwLUhuScL03XlmB3IR
	 E6MkXokc+rMzNoBDkKhYWVGuAdLQPKP3ImRQT/XnBZcHTXq3wFJ21TnQ+4Tzqg7tGf
	 CepsHdBR4s32iM9mHGZhzs5u1pXwjWJhKxGMxSGfI+8Q2TfelQPl+3nTox6JhAdRQf
	 2bGqrWSIgvdvA==
Date: Tue, 10 Nov 2026 16:37:01 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, 
	Minchan Kim <minchan@kernel.org>, Richard Chang <richardycc@google.com>, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 07/11] zswap: do not free the entry if its pool is NULL
Message-ID: <avNIFZ0XVgOUdpDc@google.com>
References: <20261110054836.1515030-1-senozhatsky@chromium.org>
 <20261110054836.1515030-8-senozhatsky@chromium.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110054836.1515030-8-senozhatsky@chromium.org>
X-Stat-Signature: 65yw16ak5whx73j7dwytfn4t5foqjbg9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D80B5180005
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794328623-154730
X-HE-Meta: U2FsdGVkX1+N5a3qRHnyah9YTkNkqSAjMn2eoBBo86YEkwgpreZe1eyLLdgDBhQ7vO7Fj/Y5/VsYtpFOes1+1yPsAVPPULm5/jxuYe88Neg04OdtzrcjAQzgVU5Im22hrRufAaQ0gdtrsKm0Jkd+6qG9f4/UKduvnV0WIpif5SjW1inT9misduQXgF1otn75w/ZflL67Aedh67ALL9wR5b3HUfgdtKo7x8n+IXq7ZiRMl9zd7EhVgb6dH0TNDUF74ke/+/MlGkJW7Yx60c0mUZ4H658ytFCvQ3yc2ipT0lDFmVLWBzTTEQE3O/6AoV4Vk/ueDINW8KylQfgaK+xtCoiOmwa62lL2oIC/QR3t5HyNGrQ2k/5xDTH2xh+KydnVJ7L8bRSJk7Aua90XGivIGtbuobqlMbFYZR+zvXt27iNYtwclhdnqkppTJtgQS8aZioTUPKfGY8MizNrYAiVbbJJr94HEexwdgrZsIJpmAFMS6fnh7MAOfO1pXNXCi+i9bBGhX7HS9Al+9fJ177Yg9JdesK1j1Ou7qWJxoCR2TMxv3PElHdFMATm4ViDUjIqkMW13bHnJxnuH/+aAZn8VXg4p3ogQVHai75qv2xr3m5wx71an/c42HNYzxmRcU4EcSPWndNjQULyU5I9FfyyNBnfNN+vqfEV+dW92EZctBcNUOla+f/wg4DtICXXP+OJqrOSJPrsby2F3GwFWMBIBWjvjbdJkri+DVRQP8XU0GkllCETw0wqEiBnpWRArNximw+5bVs6WAP0+CsMmvVnNHUwYyK48rmJZgGlfkHCq0QHND0UQ5TpxyWoFnqNIWSrWh9neOssncXygORXbPetCx7ftVApUlfJlZUUzLY2Xpl4ZD8BM+Y3Xa6p+ZSDuTnFb0VSD8VgTys62bU4fXq9KcRJQ37SvRZBnBH5caHKYzSmXzNdxlYx6co3SvDU06oHxXTPfT//uL9KPOM9TTzf
 uD2lSjMg
 6CfHTqU9NELcUouQeXV0JIM6a6kUxLrHz5POMK0vPHpKdkAI40yr833U962tVvUVQ6ZqdBAtF3hoZjZlS1ZxUa/r4JSHKB8Oa5cLXH558c31jvm2IZKWl1MxiODlDisYvklcvYW6LeVOiVkOwIPwR+6CTKuJ+JIlqDynf7N1nb+qVsrwe+M+h42Y6cYP7DOXlPGdbDyOPGWpDe2R1F8vwN0oesbSLJ0a0PGlEUqZBgqT6HVoeo5RSVM5q0arrrtON/iWo+OmSvMwSdWwfGjSXr0CgXYEO4vAlfXXtUY3mNZSmMxI4l5VrQRc2sJFYzPshnRIciaJqc7zyQmM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 10, 2026 at 02:48:12PM +0900, Sergey Senozhatsky wrote:
> zswap_entry_free() warns if the entry has no pool (which should never
> happen), skips zs_free() and then frees the entry.  A subsequent patch
> embeds zsmalloc handle into zswap_entry, so zsmalloc object will point
> to the entry, and we cannot free the entry while the object is still
> there.
> 
> Bail out early and leak the entry, its cgroup charge and stats instead.
> 
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>

Acked-by: Yosry Ahmed <yosry@kernel.org>

> ---
>  mm/zswap.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 1160bd34e289..dc0400d7e1a3 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -787,10 +787,11 @@ static void zswap_entry_free(struct zswap_entry *entry)
>  	struct zswap_pool *pool = zswap_entry_pool(entry);
>  
>  	zswap_lru_del(entry);
> -	if (!WARN_ON_ONCE(!pool)) {
> -		zs_free(pool->zs_pool, entry->handle);
> -		zswap_pool_put(pool);
> -	}
> +	if (WARN_ON_ONCE(!pool))
> +		return;
> +
> +	zs_free(pool->zs_pool, entry->handle);
> +	zswap_pool_put(pool);
>  	if (entry->objcg) {
>  		obj_cgroup_uncharge_zswap(entry->objcg, entry->length);
>  		obj_cgroup_put(entry->objcg);
> -- 
> 2.56.0.506.g506a7eabc5-goog
> 

