Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1582ECD8C88
	for <linux-mm@archiver.kernel.org>; Sun,  7 Jun 2026 15:24:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E02046B0088; Sun,  7 Jun 2026 11:24:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD99B6B008A; Sun,  7 Jun 2026 11:24:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16CE6B008C; Sun,  7 Jun 2026 11:24:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C2A646B0088
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 11:24:49 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 728F3407BB
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 15:24:49 +0000 (UTC)
X-FDA: 84853489098.13.C0F44FA
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6482110000E
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 15:24:47 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B3rKEyWt;
	spf=pass (imf05.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780845887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M7eM0J2wbw/2K8ZZhLt6TUGKPIkNzPAPBwibQcHHdfg=;
	b=b+DrBcDYhDhodeT6r6NxYYmi0Dr/Bj3YBWPdpPAoYMp8cQ2c3MV3KKe4QBdo3piWYdqMWP
	DZxj7maM5yTgjCQ5gr4V2wIxBKQWOkBiJt/R1ZjLg0xu1uUg0nYq6fIGRbPFEIFTXzIPv7
	LxijYv4dS9pqtN9Xi7yF7H6RCXms4gk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B3rKEyWt;
	spf=pass (imf05.hostedemail.com: domain of zenghui.yu@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780845887;
	b=aLGx0n+u75W5PByaGcmu7kg+uOKiDi3/l4aWqqEjC1biBmPP+K5V6A0MVl8ifupL6gqCHs
	z9PJl6RsvipG3VpVgMQ87o7001ZUitEpbHtqORtARn8WDHvxYt5flpWvtEDbLpL+vjSeAQ
	Z5USTYL84BO8Vd8fQBQyrHhebf64SUg=
Message-ID: <d057097f-2efc-4f27-861b-ac076b93e34f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780845885;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=M7eM0J2wbw/2K8ZZhLt6TUGKPIkNzPAPBwibQcHHdfg=;
	b=B3rKEyWtrMBqQzOjs3BD43CH+i23fev0mW7/g/PB1V+OQ/EcCL2pUGzT1iTuFSd/xwMKr7
	f4k7GPxMA11+VcVvtQXdpyYVB0Au1zDt5WXZ6FpONLVWZgHsTs1hEsPAPtCG8/27aVCqZs
	MzHaZ7Aa2Mz672dXagqzB1an+cWHqqA=
Date: Sun, 7 Jun 2026 23:24:27 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 02/10] mm/damon/core: add damon_new_region() debug_sanity
 check
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260306152914.86303-1-sj@kernel.org>
 <20260306152914.86303-3-sj@kernel.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260306152914.86303-3-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6482110000E
X-Stat-Signature: shjpaj5cbj85xx936djsna33eohnqn6a
X-Rspam-User: 
X-HE-Tag: 1780845887-201965
X-HE-Meta: U2FsdGVkX19Q8zm3VBHYXNwcVIHIgUtqWSTlYPr8PaMSBncg56MfBUmg4R3NLQhhlxLPddYG53edXU4IAu6Kw9984d2Vv3jBi4ckGSCDccytRXLq9+iZkdtiO8YkIsmnvCjyXoPmPlUW3Wz7SNbYufmDM1pCKfjGxA/UNjhb54F4hcx+veIFeHkD5eXMPR8/dDyj/muxwKJVfQjt4hxSnS97MuGzbcEltbqQO2OOPmOxlN4mR9nT287uPa8T1PXj/8rMQvAqu4RzfxpyA0FDQ5Yir1yrzlfHiUNr2w4nmzLNpzSBAvF6FiE78qYv3MeizCv6DobdAntZ4g1u7G619J3h+1CRnL/d2gm8cVyjoGzJT07zeyyXzQjSOsOBCvaNWQdZQCt0SnfoIUWYUe7ARtUayCZCIg4buA8OUjBbP11wnXDpqNA0KEBeHQLq59E6EVobNqw4NDconSkXuN0WWBDGacrh91f3PgPRoWpnDQ11f63195RPABBVpCJT1B6uY6FjUiAAxUMY4MyXxBSYdnpQkOYgfuY5vluw2WdCHDnRnvoM0+zquMD8lami5VnLDnA6FVLt0LEP9sC/6iLfuBVwAlqGIZPPxlX6XGxRGgCC29jU1KPMF1RrHpSrp+M83ohvhATNc7BRTxkRPP0pejxezjXHm5N3prKH/31xo1Ap14m4PULilfAo0GO/HEW9mE4xFDE2wEARKquEp5rLdMZ8liUmAXUoHeJKRADRmwzX1FwxvWYdGd5xTH8DPbhSzRMkWP4/4rspz/dk65dqDgN+5rd695irKEKKjAwRSw44A2SqPkO8O4/2Oz4zcpJVOjX3DxeeD/jQOdNSnXt8wy5oQMsQW9g5xXUAHuqr6CL+ezfVfzkJB0iS5jTZUAh20QCe9/lQF2CBu+Y5j+nUygvNPtEHpH8Q6FIl+h8hwr5v5p2ZO+kEFTOzVQtnFjJ486U6Td6OPYeUqo2kWVJ
 fqoaVT7L
 4hUeGxzRogGjlOx8eL44q2n8JwJZP4ubJUuofmG7nds7bh+062LZCnI6fvso+mtdEjvWDtyxyxjjVT0jQHQ6KYIo3JJZ5R1h6Vt2pkZrCGmAwGFGLCf6Ek3LSE0w2kiBK8iSs2CTRaI0aNgdRJxYtJIHlFtzqp5pqhJg8DnwUSEAYC/hrd8CUmxjlAha2G3ROKEAKF2bzVVpGIVhdv7aPEH7/jSSqk5HvSugV2zm7u6NPCWEsYDcs1VtHuG3ftdKa3faMUkdxdV3nbYGH3qyDut234g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

On 3/6/26 11:29 PM, SeongJae Park wrote:
> damon_new_region() is supposed to be called with only valid address
> range arguments.  Do the check under DAMON_DEBUG_SANITY.
> 
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
>  mm/damon/core.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index f1a97e85824ac..0c1353164ec81 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -109,6 +109,17 @@ int damon_select_ops(struct damon_ctx *ctx, enum damon_ops_id id)
>  	return err;
>  }
>  
> +#ifdef CONFIG_DAMON_DEBUG_SANITY
> +static void damon_verify_new_region(unsigned long start, unsigned long end)
> +{
> +	WARN_ONCE(start >= end, "start %lu >= end %lu\n", start, end);
> +}
> +#else
> +static void damon_verify_new_region(unsigned long start, unsigned long end)
> +{
> +}
> +#endif
> +
>  /*
>   * Construct a damon_region struct
>   *
> @@ -118,6 +129,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
>  {
>  	struct damon_region *region;
>  
> +	damon_verify_new_region(start, end);
>  	region = kmem_cache_alloc(damon_region_cache, GFP_KERNEL);
>  	if (!region)
>  		return NULL;

This can be triggered with

	echo Y > /sys/module/damon_sample_mtier/parameters/enabled

because both node{0,1}_{start,end}_addr are 0 if people forget to properly
initialize them. This can be avoided by checking the parameters right
before damon_new_region(). But I'm not sure if this is the correct
solution.

diff --git a/samples/damon/mtier.c b/samples/damon/mtier.c
index 775838a23d93..4a5d3fb12e1b 100644
--- a/samples/damon/mtier.c
+++ b/samples/damon/mtier.c
@@ -118,6 +118,9 @@ static struct damon_ctx *damon_sample_mtier_build_ctx(bool promote)
 	} else {
 		addr.start = promote ? node1_start_addr : node0_start_addr;
 		addr.end = promote ? node1_end_addr : node0_end_addr;
+
+		if (addr.start >= addr.end)
+			goto free_out;
 	}
 
 	region = damon_new_region(addr.start, addr.end);

Thanks,
Zenghui

