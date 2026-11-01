Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E9B7606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 19:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=J9orr59w
Received: by kanga.kvack.org (Postfix)
	id 56EC76B00EF; Sun,  1 Nov 2026 14:13:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520056B05B1; Sun,  1 Nov 2026 14:13:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4383D6B05B4; Sun,  1 Nov 2026 14:13:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 21A9B6B00EF
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 14:13:55 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8C3AE120A8D
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:13:54 +0000 (UTC)
X-FDA: 85387499988.20.24D7888
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D34A740007
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 19:13:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9orr59w;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793560432;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7S6qxSAluU5AdwDGWk4KFzyP5dBcL1YEzQEDbpdNMCo=;
	b=zG65QBrgOIy93vDy3T9cNIBFErdsxtyI6YKlSHHXbWvpP9ylBdRLKFZGEMkNZz1XUKCduz
	nkwomSTf8kM87NC4dYvzlqah/EFPi3WTYK6SrwoJRfjZ5GCh3zKplVvl20akLucX6oNFnL
	eApiujb9u74P9CMsELj/XOer9GCqubc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793560432;
	b=KsoTlwwKHJRDXgTnsBDYcNwvAGLlB80PUqO+AttYFBdZC/2GEHFbdzyX9gMtunGL7zDyO1
	M/c6SRp8qa/lWX0ZpTOLDHviiCDda/dfHTIL6ReuggTNRZxepE/d5qscetLJ8fCuz/LSgH
	Iwtj/K7fv8jTaf8Apk8RdqoI4/gJKbA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J9orr59w;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 43419417C4;
	Sun,  1 Nov 2026 19:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E73061F000C1;
	Sun,  1 Nov 2026 19:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793560431;
	bh=7S6qxSAluU5AdwDGWk4KFzyP5dBcL1YEzQEDbpdNMCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J9orr59wDCUxwTVoMXio+VZBFQqFXKqHct9qyTpQX6AYK/aEi3wlWAxRJBT9bbsXV
	 6OKkw1BaGmeNdzruw8FpzJ2nH5WG2lANAchqxlO7c/eXUHh+h7vdXM8XdWdN48ehGP
	 xpERGMWHbF3etUfiIfbY6RKViVcKjL5oI32mIOTZ4c0CctH3j+jQ68bIlFwCDsf6dV
	 5ksod5lN/+lhd2xVF7Xo26Cxz2vGQcF6X4qz4lUwaO74N29SCOavE/kCOCHJoJdHnr
	 A7fD0qR+jzmV+VuDv70p1epw1+s7AjNLDHpvXu83VWyMWI4dpwsm5ssrk2MamC4Llj
	 l6msJQyclhn5g==
From: SJ Park <sj@kernel.org>
To: Wang Guangke <gkwang@linx-info.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/damon/stat: avoid overflow in estimated_memory_bandwidth calculation
Date: Sun,  1 Nov 2026 11:13:43 -0800
Message-ID: <20261101191344.85683-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101180001.167198-1-gkwang@linx-info.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D34A740007
X-Stat-Signature: hed8fesoy67aqbf9j493e5qhq8x9t6xt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793560432-513146
X-HE-Meta: U2FsdGVkX18qYl5ZcsMEuqT0jJoABB4wpxeZe/cl20RGgCjrDTfCkaoTIsqEtB28XDZ76MgZLGFUk9WFpvuynlb2Wg8vKuH1ImhHXjPBbCaFdaqUUnhgnN1KxHdfWo/3R/JbfObzibm454hsFQmw3iN2TQe+sidsvM0ZsOoqreUtCVbl/gSx+Ov89/sRD6nCcCnfctbuljbLrJGLT1Q7FlLRqzHVePIKElbKgNyf2bGgHUJDuQp2GD1ei5w8+PzlbMa17uL1eBaUlX9+Ydrm98At5UKNGV+yfkA1stEL6x5aLwDJ1rBb++2rH2iAIr7yJ3UF+g1Pzpf0yRBViYKC3f951XvEKkeyLQStvv/WBsGXOM77pKx9RS4WRXf7dp0K4nFPLuuKrOAVNFGken9Yf8rulEMz4j3uxIAw3Twx+lr8NEkdpybTtwOJAQajQXnNXTKWCmUA8co1AZYQ3u5Nt+VRGt/Etc6aKnCqrW5HZdVWw8aJ8tU/AAm8Yp46ppWvVgrc4kojGGeFMgWlI0GE1ogiWSf6ETJpWbofcHb+hp+SkOW96s3G9N6PTt/QPRweKapCdDhoVgWHburdQm9+IgVDRngV7O9KVPLY7f/p8z1ayXpejAC5yGuRDlnohZtEFZxxoKFhSgzGl3QR2LXw0OHeHyg6bPL2kg8g0DaWto1Yr5+vpr+I4bSXiNHxCrPIPXwPYUreeiMgdLQ+pgVmUH7d03OLqYvjS85g+MFjBRLizeq8YgAODS4MlBZdl+/j9anMPWwYf8au5R9ZR1k2RrFRk6QaRwOOPDZxXv4UUfv8re/E3CV8tcw/UbpNdaomr/HX0tACy2qs8feTDIouEiwwEoHGxTtrZc0xtYEOyR6WEu1HBgPE8rq7InRQOutSJGP3LzkdJ4MCtNjUODEB0bSvbi5PFvSquKyWPVFK1bWtvQSMxv9xCFCNPl/2DXqNlRbqHqKzTpd9jjqkcNz
 sdEIN+FY
 dv46qmhJYhX+5VmxMC1cFmQb7n1h3zs40UCb731gP0rH9zvfRBQ/AK6/RLxgTC5xEW+zCAkgAKd2mvfnlPceRS4MF7DKMwNRTgor3xkGBxETPayNCz0kLwpdW5VGj/JuI7nzlK/QSQiOfX/m2Q9oVgP+o/8ztCLN2XFijjJ68Cd21u2354dCL9yXWSI4VB1KTuHmvQ6zxP+OXxpNl8XdGt3R52tJAIjFWtLY5yfKNygLuVejMAVyR/5CJjpQebVlT3QipTY8l6USGehtuv9bHePol3UIDHzQsPFwRV5UbbEFOXuHPE4ZIJ3ekHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello Wang,

On Mon,  2 Nov 2026 02:00:01 +0800 Wang Guangke <gkwang@linx-info.com> wrote:

> The calculation of estimated_memory_bandwidth computes
> access_bytes * USEC_PER_MSEC * MSEC_PER_SEC / aggr_interval directly.
> On 32-bit systems, the intermediate product
> access_bytes * USEC_PER_MSEC * MSEC_PER_SEC may overflow before the
> division is performed.

Do you find this issue from real usage?  Or, jsut theoretical?  Could you
please clarify it, and user impacts of the issue?

> 
> Fix it by splitting the division into quotient and remainder,
> multiplying each part separately.

Thank you for this patch.

> 
> Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated
> memory bandwidth")

Please do not wrap Fixes: tag line.

Could you clarify why you do not Cc stable@?

> 
> Signed-off-by: Wang Guangke <gkwang@linx-info.com>
> ---
>  mm/damon/stat.c | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> index b05b68f73e10..7cfa3a8d6801 100644
> --- a/mm/damon/stat.c
> +++ b/mm/damon/stat.c
> @@ -32,8 +32,8 @@ static bool enabled __read_mostly = IS_ENABLED(
>  module_param_cb(enabled, &enabled_param_ops, NULL, 0600);
>  MODULE_PARM_DESC(enabled, "Enable of disable DAMON_STAT");
>  
> -static unsigned long estimated_memory_bandwidth __read_mostly;
> -module_param(estimated_memory_bandwidth, ulong, 0400);
> +static u64 estimated_memory_bandwidth __read_mostly;
> +module_param(estimated_memory_bandwidth, ullong, 0400);
>  MODULE_PARM_DESC(estimated_memory_bandwidth,
>  		"Estimated memory bandwidth usage in bytes per second");
>  
> @@ -55,15 +55,20 @@ static void damon_stat_set_estimated_memory_bandwidth(struct damon_ctx *c)
>  {
>  	struct damon_target *t;
>  	struct damon_region *r;
> -	unsigned long access_bytes = 0;
> +	u64 access_bytes = 0;
> +	u64 remainder, bytes_per_interval;
>  
>  	damon_for_each_target(t, c) {
>  		damon_for_each_region(r, t)
> -			access_bytes += (r->ar.end - r->ar.start) *
> +			access_bytes += (u64)(r->ar.end - r->ar.start) *
>  				r->nr_accesses;
>  	}
> -	estimated_memory_bandwidth = access_bytes * USEC_PER_MSEC *
> -		MSEC_PER_SEC / c->attrs.aggr_interval;
> +	bytes_per_interval = div64_u64_rem(access_bytes,
> +			c->attrs.aggr_interval, &remainder);

This is not bytes per interval but bytes per microsecond.  Let's rename the
variable to bytes_per_us.

> +	estimated_memory_bandwidth =
> +		bytes_per_interval * USEC_PER_MSEC * MSEC_PER_SEC +
> +		div64_u64(remainder * USEC_PER_MSEC * MSEC_PER_SEC,
> +				c->attrs.aggr_interval);

Let's use USEC_PER_SEC instead of 'USEC_PER_MSEC * MSEC_PER_SEC'.

>  }
>  
>  static int damon_stat_idletime(const struct damon_region *r)
> -- 
> 2.47.3
> 
> 


Thanks,
SJ

