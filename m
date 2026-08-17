Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36E54C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 16:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FD6C6B00F2; Mon, 17 Aug 2026 12:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D4646B00F3; Mon, 17 Aug 2026 12:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EA536B00F4; Mon, 17 Aug 2026 12:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7AF6B00F2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 12:16:50 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C1821A0849
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:16:49 +0000 (UTC)
X-FDA: 85111264938.13.2313558
Received: from mta0.migadu.com (out-151.mta0.migadu.com [91.218.175.151])
	by imf10.hostedemail.com (Postfix) with ESMTP id 9567CC0002
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 16:16:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S3wbMJnR;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786983408;
	b=MuevdDV2Gk4LvvVnxe8KNx49Vvvdq/Wbs3GIHkSJAcu07w/P3ipJNtQaJyjARX8S6HI4Vf
	+dz/mX+U+O7CS45wHjMemT/lJxFkNUkFirHAc11hF4mqa39wr7DEWXvAW/cyrKGo7WL50t
	NtWUpQYuHi0IK7XgEOfTovb9vym7h6w=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S3wbMJnR;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.151 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786983408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Og3AUkkEqkruR1yPy0HNDP26ccUiFDFKO+Xo3r4tP0U=;
	b=FJ56K4p0HLiR2kB/1EgO8SRLgf6FVwUiHEpbaLBh/cIPX1NENSs2TM8L97+e1UGRsirhPQ
	SlghNdGfpjLNBk1Yq/OSKm1nhTGaqL7fnLMq7628Xr9+AcCkuqo9qR/oQ/+6jpppf0takG
	QC19ksPMdlgJMH9yPGLaQNYrYqVxr0w=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=i6bQMq/DC00QCcuw75mN4wCsOIuCzDBMfmplOIXgDzk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786983406; v=1; x=1787588206;
 b=S3wbMJnRGCslnNbTCuupNF4iThPC3hCIaT4dcz/TttxVbErzmNazm2zKWEgOcC3McYiMrCvA
 U9xYIHbx8ezn2IRl6XF7tAGQaiBsFpSXE+ACepnFo/JuyJkQJ4G+VaPEundGlELAk0d5J2/Kw1p
 u3wxtnaY/9ZPeiwA68nSEcWI=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2a03:2880:10ff:d::)
	by smtp.migadu.com with ESMTPS id 2099e86e7d174f0f;
	Mon, 17 Aug 2026 16:16:46 +0000
X-Migadu-Flow: FLOW_OUT
Date: Mon, 17 Aug 2026 09:16:40 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <aoMzchLCCz5hiFHp@linux.dev>
References: <20260817042652.74136-1-cui.tao@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260817042652.74136-1-cui.tao@linux.dev>
X-Rspamd-Queue-Id: 9567CC0002
X-Rspam-User: 
X-Stat-Signature: sz9p6hueyp7ua6g9sb8go1ikfqgh9j1n
X-Rspamd-Server: rspam06
X-HE-Tag: 1786983407-195174
X-HE-Meta: U2FsdGVkX19sxwwOGgpcIhFvII0Cohsd+0Grjs5W2b8+9ACcYjEemAkUcKojGOYTR6jYsDYRRZZ/Tpd9ev4NPAMU+OC2jHjmPXwOm6dC7lldmyk380W0F6lqqTo7+NrXN4CIeeRoe+349qYwju9MxGIx8xZ+/81wf9cMu76iuqO7me/sRL5ZlKNEkV4JvT7V4a5h3gOztPqJDGASvPuKsX1XsL6fsN4ywF1gnSuciV5e4lRZ6FjKbAA31S4ga7XMjEFY5kXWghPRj826foHVHUa4+l49bvfrOjsUM9nqlG0gcdai79SkDNdPAuX5ldlKaG/bg/H5gHySykrc2+SwTHw3pkMv3Ko9C9lvtSgg22xJjR2iXPabVtPzP5B/OAqtRYeVKtcLXwTjrsOaShmGHjUj8zJ9mDNeFngL2TudOiu1piYlBPq1eFo53K1vZ/CFK1CTLb+1VJ/M91A5By/K74stnxIp3HTdOyQWsWE9xLZ95DnxMo/5wOXi+P8NXfdA8qX7lJqJHBa/MZylo0qyU8g2hfrY4ELWg2gxKac8QW5M0mdy63VSVsNjrSRRj/W3eWQuRg7ZLB6btqI1vDQYjvQnXQ6K8nx7QMn8IViLYdj1f4AZYDo533l0lZHzCBIKDEmQv5G+ZbZoW4JIlvk04IZ1zMVYZjQ8KAoplSB58Sdm8IgffKHSGycvGJmJayDwQGSaj+M+IeOndG2C17DkLZVaz+g2s/nFwedHy6ESwPEfTxXWT3pR6VtYBzdEI0TLbtJRk3A0fiQgXPXQrUnxwkMuO97OLWRq4At92m8MVVnGoUuFM2aVUS9Kyq/Wkq1SSjIZthCE4yOZQsKoWlQ3B8BNMO/u3z24T5eIo8/fEGFsRe7F9sokSZ1F+b89IgeNjctGNZ24Gf6x0KuBuvLQyNPv0ws/t3OyPyiKoXuMagOlHguZLJo6jJyHSQCKaBnBUDDbCEV4FN80WNCqQ7/
 8kvGiuq1
 AHc1OMVMU0JIH+je3eu/SnbIcqEuKtOdaLJDPsvTinC64uRfsknVVElSa1+vPKOwraRI68p1UKrt5z//PMRFcke7/6aAUUAUC29MJ69NoKIspv/IJaxpOg0RbOSXyykrEIwnHbE6zUErql2XnMJBoBqInT3Zbs5KhMlkbj5voDgXsNzxGyoPtdOxTjXrpXcIKff2ay3UI/Ql3/5aU7qVR4ci6uuifbYBG/kinbi/skDbRWhEJmQNGkUjxCZEwBAO96G3Nq0lj96xQArGWk+3fBhsHFP2wOBx3yM6fCQjJQ/ctGC50DaK/G5L6ecIyoC0JMnNH+XHIGHwk2zRQHBAUx+SVYCh7//mLltYaiFzsk1hX9ro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 17, 2026 at 12:26:52PM +0800, Tao Cui wrote:
> From: Tao Cui <cuitao@kylinos.cn>
> 
> memparse() consumes no characters on an empty input and leaves the
> end pointer at the terminating NUL.  The only validation in
> page_counter_memparse() checks for trailing characters, so an empty
> input slips through and the limit becomes 0.
> 
> All limit write callbacks of the memory controller strstrip() the
> input before calling this helper, so a script that writes an unset
> variable hits this path:
> 
>   LIMIT=
>   echo "$LIMIT" > $CG/memory.max
>   echo $?
>   0
>   cat $CG/memory.max
>   0
> 
> Nothing reports the mistake: the limit is now 0 and the OOM killer
> goes after every task in the cgroup.  The same happens for
> memory.min, memory.low, memory.high, memory.swap.high,
> memory.swap.max and memory.zswap.max, where 0 silently removes the
> protection or disables swap and zswap.
> 
> Reject the input when no characters were consumed, which is the one
> case the trailing-character check cannot catch.
> 
> Fixes: 3e32cb2e0a12 ("mm: memcontrol: lockless page counters")
> Signed-off-by: Tao Cui <cuitao@kylinos.cn>
> ---
>  mm/page_counter.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_counter.c b/mm/page_counter.c
> index 661e0f2a5127..d14db705b04f 100644
> --- a/mm/page_counter.c
> +++ b/mm/page_counter.c
> @@ -281,7 +281,7 @@ int page_counter_memparse(const char *buf, const char *max,
>  	}
>  
>  	bytes = memparse(buf, &end);
> -	if (*end != '\0')
> +	if (*end != '\0' || end == buf)
>  		return -EINVAL;

I wonder if someone started depending on this behavior. In that case it is
better to return error instead of silently ignore, so we will hear complains
loudly. This looks good to me.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


>  
>  	*nr_pages = min(bytes / PAGE_SIZE, (u64)PAGE_COUNTER_MAX);
> -- 
> 2.43.0
> 

