Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52CD4C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 19:34:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D4C76B009D; Tue,  7 Jul 2026 15:34:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35ED26B009E; Tue,  7 Jul 2026 15:34:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F026B009F; Tue,  7 Jul 2026 15:34:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DDEE96B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 15:34:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4F4F81C3B58
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:34:04 +0000 (UTC)
X-FDA: 84962981208.07.96DDED8
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 818BD4000F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 19:34:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qY+BthfH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783452842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yV5ncxbkCYl4acpcVXgqqMbkDn7uQGkSDLvd/JcyFLc=;
	b=dZpJSyJu2qHvhZBjyn1wvUPeYeV3hudmWsB8ytZhKjiXAlrYN4rcH9VmIMQmWcitzeQ3NI
	nM0RdbvXNjFSq4H9f7Ift5VElJ0tli4wxgJHGs90LPJKQkZO657WHXouPRKBzKdrgdsAHN
	9nm/OsUmhzpg6rBA7NMsU5w5dn5K6R0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qY+BthfH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.178 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783452842;
	b=jKEeOngpENUTV0QHVOBLIKzS3oMl9CDxT+N12nZ9KqTr77BJTKLlG7aeOvx9RHOlx+vecl
	WC3qtOZyqqvnyfwj0lggIvqujT3eQ9W4tdN39D5xTJ3UC7sduuZQKAR68wVg9BO/p93ujF
	nCPVVJmROf2joKZlDKouI4SOaTJn2Ks=
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-48d6c621a67so2168625b6e.3
        for <linux-mm@kvack.org>; Tue, 07 Jul 2026 12:34:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783452841; x=1784057641; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yV5ncxbkCYl4acpcVXgqqMbkDn7uQGkSDLvd/JcyFLc=;
        b=qY+BthfHx51fGG+vIF6Wuh9dKdtjvMOGgiR/S8XC+Tnk+qY8jT9nBvdsJZBWOVS1tU
         bDPaKBifHZRqUoprUZ3IS82RpiuYJ4kC6HvmIYVgLx7Y3azIlebT9zt035dVy8P4LGNA
         2n4l7bYSgD5kMXYj/tVSGAMpKN+1SDObetIO3jeVs7/+0zAy3enZzWWh5JhbIPlxymqO
         R8qVVYfJpDPnDgW2nRTrGs5WrBRHk2UDUa/gWGmCkbvwMUEH+u9hdk3Xptz3IzTqqRb2
         KizZovgA43/qXC3z93drKiXQSqyNy3ccI5YeHkEJsT+hOTVKLjsM/OvnQA9rDDATaDHv
         MEKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783452841; x=1784057641;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=yV5ncxbkCYl4acpcVXgqqMbkDn7uQGkSDLvd/JcyFLc=;
        b=rD+Oj9qw2iNrzGRbPZQwcyHdLsQZGVaqx+UNBykQ6QaSVpQY+2+jxjlGTzYcVvk2U9
         HiLdkDTwKxrIMIz4OMqKu82H5wdhj/Rl7Xw1bwSO2QQ3WaiE823oHBtYVVgIcRH/X0Ap
         hlqHhU2kb4qOvMOhg5+BqZuuCAryHrlnKkhwgVDYyXQDrQ5C4pM/JNpUPkEVfGBdQCfW
         NvuRFPLaB4gZaq1+RpkVrNpmHrQ+/FyryS6qcIjDAfyD2g73on0GJjq+qN2A0Fgo9/mX
         URbU0HPr+SSXtbrf10D4177Lt41IqpbvwfvFAKMOZnKZaY3dl4z3L8P1EepWRT+ffn9Y
         JtzA==
X-Forwarded-Encrypted: i=1; AFNElJ/XroFKnSJsXeCVj/5urfR5cZI7lsOgPpjEspc9edX0LY4Swyn/l9eQ485Tz6i23TXcNsOo0fU0Pw==@kvack.org
X-Gm-Message-State: AOJu0YwjqbPnM++jpcwEmiecwkcKyE+dl/ALivUYItWanoSpsSbSaQz1
	YYQhGSW8tvxs1pKdlLW3QjqTdog5NP/8DoKGVZGtxdV4rebdf8U95YJx
X-Gm-Gg: AfdE7cnBVm33JwMYT1woUsJKlyPF+Fwi/sXXTeD/4HNJOIbge6A3f2Q/TwJLthfpk3u
	zfgtf38P6i2v6nA/pKiUDlADjKA53/TjQRy1UXPTrGRVQr/L67Pzw/Tnb6ucefWhISujoQ2U/H3
	Eifnm0Zi0Tsz2NATUjf2cE5/HSooG3AaOQlDi/0GUo6+NVkAsm8/fPEYP7B18IFwlgjYno9kQqF
	KbvcRAW53jxpvwTiHz8ssNg75eD8w1AMPnxa32xT9hEeF99+muW02oC5ifsj/Hjec/YEpXxpEd6
	4IaRcag+2BzPUq5MX7A3Wd71+iu4m7DOIliTFaWdMAKsRz8+qUOkJUPtxcm9BsArhDdMexkdSdd
	fGvALi8Hs+k8lRNLmsjFmswW3tJawUO3G1VRI7E/Yqvdmr31fGCelpl2zxBDqdd7PFXmRwX33PT
	kaB1V5B5FqywiY9oKdgJAgHJsG26poNuyE+PyghVo4xUQS2MLyF/T8ig==
X-Received: by 2002:a05:6808:2205:b0:497:e0bc:afe2 with SMTP id 5614622812f47-49fdba4150amr4147933b6e.4.1783452840534;
        Tue, 07 Jul 2026 12:34:00 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:49::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a1adca6bedsm181768b6e.8.2026.07.07.12.34.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 12:34:00 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Charles Haithcock <chaithco@redhat.com>
Cc: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	arozansk@redhat.com
Subject: Re: [PATCH 1/2] mm/hugetlb: Prefer mempolicy nodes for calcuating surplus hugepage reservation
Date: Tue,  7 Jul 2026 12:33:57 -0700
Message-ID: <20260707193358.3434034-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707182900.483757-2-chaithco@redhat.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 818BD4000F
X-Stat-Signature: uhz5q1j6bmttwjbh3ugejwtc4tmay1cq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783452842-655810
X-HE-Meta: U2FsdGVkX185FwjcO7BNb5hVSunsQoNj1F3btiQOsNPZOaAyXeaMR1JI9NLaypwtTk7XC6zjiqGbfO9CSS/6dmHHCKEgi7Zgza+bqOvAOgY8js9pGyYrDh1SmyajHMimSefmjDGZQlQYxyHD73j66y/durtFeSMNmVUK6hy3AQHwYxrnKnsEA6lQ3yhbL3hN2zC3GcpOPCL2tUuE55oAyVN27l/iWxsMogyearrWV83DAbiJEPLtH6HPm3W/lq7fW1ciURIGpC0CZ0c6y/3zS3iqqILpWrZd5nkbNBcRgYDeZWW1MwWlIWE2RprYo5yyc8YFhIWJzvlxGuzjI4VyGLTihvlZKdN1KIb/chAyIm0dGk8YGYoiDg5ZdFfv9iPo3HMPRQuYUnfW5Jx6YYC83riDmgrRpcq47KZKKS2USQCSAr4/MeXvtO8uDsZJEeVngPDra+ZOAKe69mF/bCGCAn0Vo6ya89MUDHDN7qewCrOtqoeEhyzugQSjhZ0TQr1lWXDMGXVcHgRrC5rwIUcV82vDObmO+UhdKIH1sG/Mp9D/Fz5rDLIY5kAYQqupzJkN+kRgFUxpRrVWkk62YkBMJNHJGiV1+8j8tVAYbJKVhTa0tLiuY67QQA6i6VcvybdngMbR9gX+ZWU4WeXhZz4Gubwsq9ufTk8GYtq/vpNXQMTtCfwi8u1BK01WKapIQnUBZROS1eNKEbwlwlVTopx+cphjpYfMwO9fPZOcm1QjXtueEF/AbRqIM4bj/sEJVMD3L6VkygBUAEppQQ+05ztr77Vncl9MWirWi6FIg3okVuW2Yw7g0QicWeY4nq/srdN3NXFEN9Cp7n/Gkew+Nx94yXMk4LnSXwIw6qdqII7+kEteaMhn2hP1oA5rVNN+j+9mHOXAkPjwEV+4nz2Ogch/sNHgDOVWe3kOrMRxqjFuiTXoU2g4jjuw6RuTTgDIjFJM5PefioIWD6VEI1szwxO
 ottmNu77
 EYkHtTEnsdwCYQ9w0oItTWm2WvPwWaF+Eg6aQCuhLKXIMtBXcA3C8qPG3hTQTex650/mbE29fAMSXzqh+4/5yTypKFcCHRZ1XrQ0PMQGBrJPKcDsajhDb6ZQYXcP3dfYxO1B9QGgEDgu9dK6Bwrvx6+qP5Bad3fGEAMAxeYjE2hu0O1xmlLEvwG+Bp78LbKOWRMozdc7G9E/QaY3p+wKoSrFF4ec5zu9HoCXUMjctcK1f0HLzmH2E+ZaV8ZegzX6Ao2kmXDQStYl9pVRrgUqvWAgqRd0yy9YU8uJjsEmxgv+lr6W+AOvDBJTQMXYZY7Dv+vIok2rIui7rRCdaLcWurIIs873i+qrE4JyYhupMrPIB+7NwbWhAe9+c+vknlH1KK/aB+WYKwzd9jIotE7In0ZoQTNyt8TwoXTntFYiNboKP1X/fJz7ddEqkrrdtkhQLctRlke1v9tHNJoi+P1Z5A7km9EBJkgLKtbyTIkzm2pZki+HUAMF9RAyhxgPor7SzGtJBew+GrOoirMyo7NYevoal1PR8+oxvgYTFoUtWgUDKVox/PJ2pnQ10hJIRxfog3XOARTQP6UBSgoSlaLqsGuy6lvfN6XfOVpRw0K5rVJ/b0w6Oj3cc7tXvHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  7 Jul 2026 12:28:55 -0600 Charles Haithcock <chaithco@redhat.com> wrote:

> Currently, reserving surplus hugetlb pages in a mempolicy still use
> global counters for calculating how many hugetlb pages to reserve.
> Modify this to consider the nodes in the mempolicy first but fall back
> to all possible nodes.

Hi Charles, thank you for the patch, this looks good to me!

Personally I like the description of the commit in the cover letter
because it provides a bit more context. Do other reviewers have
thoughts on this? In any case, the code LGTM : -)

Reviewed-by: Joshua Hahn <joshua.hahnjy@gmail.com>

BTW this is a little strange but Sashiko seems to have failed to apply
this patch [1] which is strange because when applying on the exact
same commit db6ed2a3d3106 "mm/swap, PM: hibernate: atomically replace hibernation pin"
as Sashiko tried, it worked & compiled for me with no errors at all...

[1] https://sashiko.dev/#/patchset/20260707182900.483757-1-chaithco%40redhat.com
Sashiko's error log:

Trying baseline: mm/mm-new (db6ed2a3d31068ca5577466591b2521dee0508ca)
Patch 41962/2 (ID: 108031) failed to apply.
Application failed.

> Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> Signed-off-by: Charles Haithcock <chaithco@redhat.com>
> ---
> 
> - v1: Modified `needed` calculation to use `allowed_mems_nr(h)` in order
>   to consider free hugetlb pages in our mempolicy.
> - v2: Folded in Joshua Hahn's recommendation [1] to further modify
>   `needed` calculation to take the max of either the available hugetlb
>   pages in the mempolicy or the globally available hugetlb pages. Allows
>   allocations to prioritize nodes in the mempolicy but can still fall
>   back to offnode allocations. Also added selftests to check only for 
>   the edgecase which caused this to initially be reported and sanity
>   checks.
> - v3: Split the change and tests into separate patches and clean up code
>   to better align with kernel style guidelines. Likewise, fold in Usama
>   Arif's correction [2].
> 
> [1] https://lore.kernel.org/all/20260602152022.2673803-1-joshua.hahnjy@gmail.com/
> [2] https://lore.kernel.org/linux-mm/20260624144600.8159-1-usama.arif@linux.dev/
> 
>  mm/hugetlb.c | 42 ++++++++++++++++++++++--------------------
>  1 file changed, 22 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index f24bf49be0..f5e678e997 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -2255,6 +2255,23 @@ static nodemask_t *policy_mbind_nodemask(gfp_t gfp)
>  	return NULL;
>  }
>  
> +static unsigned int allowed_mems_nr(struct hstate *h)
> +{
> +	int node;
> +	unsigned int nr = 0;
> +	nodemask_t *mbind_nodemask;
> +	unsigned int *array = h->free_huge_pages_node;
> +	gfp_t gfp_mask = htlb_alloc_mask(h);
> +
> +	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
> +	for_each_node_mask(node, cpuset_current_mems_allowed) {
> +		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
> +			nr += array[node];
> +	}
> +
> +	return nr;
> +}
> +
>  /*
>   * Increase the hugetlb pool such that it can accommodate a reservation
>   * of size 'delta'.
> @@ -2277,7 +2294,8 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  		alloc_nodemask = cpuset_current_mems_allowed;
>  
>  	lockdep_assert_held(&hugetlb_lock);
> -	needed = (h->resv_huge_pages + delta) - h->free_huge_pages;
> +	needed = max_t(long, (delta - allowed_mems_nr(h)),
> +			((h->resv_huge_pages + delta) - h->free_huge_pages));
>  	if (needed <= 0) {
>  		h->resv_huge_pages += delta;
>  		return 0;
> @@ -2311,8 +2329,9 @@ static int gather_surplus_pages(struct hstate *h, long delta)
>  	 * because either resv_huge_pages or free_huge_pages may have changed.
>  	 */
>  	spin_lock_irq(&hugetlb_lock);
> -	needed = (h->resv_huge_pages + delta) -
> -			(h->free_huge_pages + allocated);
> +	needed = max_t(long, ((delta - allowed_mems_nr(h)) - allocated),
> +			((h->resv_huge_pages + delta) -
> +				(h->free_huge_pages + allocated)));
>  	if (needed > 0) {
>  		if (alloc_ok)
>  			goto retry;
> @@ -4513,23 +4532,6 @@ static int __init hugepage_alloc_threads_setup(char *s)
>  }
>  __setup("hugepage_alloc_threads=", hugepage_alloc_threads_setup);
>  
> -static unsigned int allowed_mems_nr(struct hstate *h)
> -{
> -	int node;
> -	unsigned int nr = 0;
> -	nodemask_t *mbind_nodemask;
> -	unsigned int *array = h->free_huge_pages_node;
> -	gfp_t gfp_mask = htlb_alloc_mask(h);
> -
> -	mbind_nodemask = policy_mbind_nodemask(gfp_mask);
> -	for_each_node_mask(node, cpuset_current_mems_allowed) {
> -		if (!mbind_nodemask || node_isset(node, *mbind_nodemask))
> -			nr += array[node];
> -	}
> -
> -	return nr;
> -}
> -
>  void hugetlb_report_meminfo(struct seq_file *m)
>  {
>  	struct hstate *h;
> -- 
> 2.55.0

