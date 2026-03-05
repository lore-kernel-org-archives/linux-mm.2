Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6D2AEFCE57
	for <linux-mm@archiver.kernel.org>; Thu,  5 Mar 2026 01:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84D06B0005; Wed,  4 Mar 2026 20:14:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B32596B0088; Wed,  4 Mar 2026 20:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A066B0089; Wed,  4 Mar 2026 20:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8D7576B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:14:40 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15BD4BB015
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:14:40 +0000 (UTC)
X-FDA: 84510239520.27.1F93F81
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 778224000A
	for <linux-mm@kvack.org>; Thu,  5 Mar 2026 01:14:37 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Es9xueq1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772673277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7qdVsEUgmQ1bDG46p5FShx6Zsp1iobdCOhVLyHFG+KQ=;
	b=pYqZeSAxfiWoWS5im6nPsp3/LqiZDFc5dAsY2L/QFPLYQBkxcFAlos0T+1XSz5eFHM142u
	/YFiXnh7zvyohMcUFBs30KwvMK5YfO6o1LFOXoaSBGSm0S3ZI0KcvlqFHLG/rFdukM1n2W
	NlSQS1EDXq0rwVjDdc3i0122posFWYY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Es9xueq1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772673277; a=rsa-sha256;
	cv=none;
	b=Eb58fp4sEsnzAZrcp9EdUAibYnh2PisnqAqTaUfwrTppns4rgiB8tdUgKvndTXbtr5QvaD
	vx1QUneHUGQG6zEj6J/eAFQzPr2MB65zf5MdHbKpfAknUJSIHAk584tEDRPpq/9Drph7oq
	QGVTrJ/NH/Y+DWekleQn8hjyO+ogf+0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 75ACC407F3;
	Thu,  5 Mar 2026 01:14:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27269C4CEF7;
	Thu,  5 Mar 2026 01:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772673276;
	bh=ifGKWyqRAde8fdU1WltSjsgB/wrz2JI2uPwQ/lNVQVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Es9xueq1nfwJ5E7GkgCxwNgbH6cb6SYs8CbMAANep/JYBd78CADJifJx86inVc9O9
	 G9xz3B6SCDJWVwn3NjaMLlfqKyNCqvJcs6SYJRh7XKv8ro0leRvJa1M820xIEC2ka8
	 fgKEpky0ZLoFnhmWErnLmcu9MdAoweVVBT/Baxipg4SBujbBGsFW6wyL1ChJpAkcy9
	 0tt2A33BhwPdDbX5jC+oGvMXgvi1RSEZYLFD/KaRTDXWoAT03P+RkgSZMeqZnnOyln
	 saz5/yStNkv7uxyNDBY/l6ncWCn4vC1gJ8R2AkXDsPdFgu+93ItNODOB57/EkTq9oU
	 E6dRFs1rqxvJA==
From: SeongJae Park <sj@kernel.org>
To: "Guilherme G. Piccoli" <gpiccoli@igalia.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	rppt@kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com,
	kernel@gpiccoli.net,
	Andrew Morton <akpm@linux-foundation.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH V2 1/2] mm/memblock: Print out errors on reserve_mem parser
Date: Wed,  4 Mar 2026 17:14:28 -0800
Message-ID: <20260305011429.79193-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260304203300.1414286-3-gpiccoli@igalia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 778224000A
X-Stat-Signature: mo71whmerbqf9mnp835h9tp5m4n5f776
X-Rspam-User: 
X-HE-Tag: 1772673277-86891
X-HE-Meta: U2FsdGVkX1+VZ90tHtR35GK7yW87JBRkkRlZqYQBoeTWlrKgi6O/Z7oIhJPVdJvYjk5p3ESXJdgvBgJ0QpPduJ4ajrSDj3m8wKm3x2Qr+R5HIWGbP5WC4/8KfXgJzUWL5wYv7gijRlaRBGTz1gLuj2H6l2+XKwEJ9mus73mn8yikjEMCHJBf5FZk9DdA0ljv16sd/4/s22lbkjGLFtCtg3NqxM8TRac1+9KZrjyBN8YgDGLyqUmtpVNa6SzDYTW8Ff+RV+KVgQPa+5cP3SUBWeKTKPxc7ZBkW8G+KUN6jkhDMEAfDlJDe5lyTyQbzIm2cDhBh3a5YqwL4R+SjlHCKK0QiG90o+NDu948tRi619JGAx5815ZA6BmMctDXH/ceWcPS8x1+7waYGwTV2JbPgtqwsM92Fe3pWVhhzwjgRNvyRmfOQtI7Z9GqSKkaryqZqMm1HjH+jRHCFuJNehOXPjMb2kUIRLrzp8TqZLdqVBW6xYc7yE0PbJzD1FcYGcgWnApeTX+H1FBYLOFlq5IU2/Xs0jc0gdlgmNLXUmi/xtkIJhc1dF5HaOfrNiPqK9CQ1aAe2rKMN4OTBsniryqzNXqzVV/SY/om1TJluZ6hwIS0QgMSF3MH2jlEVJW3ioP+XVWFs7FB/Yz4C56CehFxmwb0I5oTHYRe6DUnjvVWZtclIFKcU/ByzvEUAO6QWvLQpPehc+A4mJDlKbT8u6OoBrjfl2hia/dI0MzjE6WJje+J9CoTiTFdxpwGPjVHfUli5JAEvZZth0RWxyQW+zr8eY1X7cKcleng4Qw0IpmXEVhUcjT7dOAjqixtDHaKnR03ycpKK8oGFTOXZ8q9hB1GQ6v4YrlmI2aJBtKahzRinP4DBU5MaHD1/L/jcxXe+DTKXPG4e6zX9tWjg0FCnR0Z74wmO4RdBuoLyMPRgF/w/8uvEzTPrnhl0SPac5axGprGA/X3XU5TEH+FVH+dXRX
 aMeuzkF1
 UOH1FuU6lpiFRtYLJjV4mVicCbmYYUpUtl6phUHmSAnjrqASFxhvHZtBJSHLkW+mEC3Uxtmq66F/R9bRXwSMmeOqjBgDePpUv/UJBatCsWBCpp0/scSU1OpnTxHVcJ2IRxih9chg6UehIv3QsXCVssLGyHAPiI31g7wukb8sppy8my4zgcV2+UuLYOndkJ+f6M/bHIikIfvAHgrmbX3cw6owT4Ni0DDnwdKObVCSs+1MB7fWxZTVlKr2WME12KHlKMu5IfESV3Y2VJTq94Xb/SOvweXgAcLLros3MWSFt96VDet0ZGjuL3bzHoXKRkVZsMSEDjBgkjWEry45YAaO8CwdqdbKEiApQbvPyv8cHaG4sS6kwn/mqnXp1+oLkn0DBHDN4unrIK0L+2gmAh1w6pQbzJDs7dwlS1XWBPriyHlsEXFA0XlDZR7V+9xRpxn5IvfapPP8gqWq/JeU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  4 Mar 2026 17:14:10 -0300 "Guilherme G. Piccoli" <gpiccoli@igalia.com> wrote:

> The parsing of kernel parameter "reserve_mem=" is subject to
> multiple failures, like duplicate naming, malformed expression
> or even lack of available memory. Right now, all of these fail
> silently. Let's add some messages so the kernel log can provide
> useful information in case of failures.

Makes sense to me.

> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Mike Rapoport <rppt@kernel.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> 
> 
> V2: no changes.
> 
>  mm/memblock.c | 28 +++++++++++++++++++---------
>  1 file changed, 19 insertions(+), 9 deletions(-)
> 
> 
> diff --git a/mm/memblock.c b/mm/memblock.c
> index b3ddfdec7a80..2d2646f7a120 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -2642,23 +2642,25 @@ static int __init reserve_mem(char *p)
>  	int len;
>  
>  	if (!p)
> -		return -EINVAL;
> +		goto err_param;
>  
>  	/* Check if there's room for more reserved memory */
> -	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES)
> +	if (reserved_mem_count >= RESERVE_MEM_MAX_ENTRIES) {
> +		pr_err("reserve_mem: no more room for reserved memory\n");
>  		return -EBUSY;
> +	}
>  
>  	oldp = p;
>  	size = memparse(p, &p);
>  	if (!size || p == oldp)
> -		return -EINVAL;
> +		goto err_param;
>  
>  	if (*p != ':')
> -		return -EINVAL;
> +		goto err_param;
>  
>  	align = memparse(p+1, &p);
>  	if (*p != ':')
> -		return -EINVAL;
> +		goto err_param;
>  
>  	/*
>  	 * memblock_phys_alloc() doesn't like a zero size align,
> @@ -2672,7 +2674,7 @@ static int __init reserve_mem(char *p)
>  
>  	/* name needs to have length but not too big */
>  	if (!len || len >= RESERVE_MEM_NAME_SIZE)
> -		return -EINVAL;
> +		goto err_param;
>  
>  	/* Make sure that name has text */
>  	for (p = name; *p; p++) {
> @@ -2680,11 +2682,13 @@ static int __init reserve_mem(char *p)
>  			break;
>  	}
>  	if (!*p)
> -		return -EINVAL;
> +		goto err_param;
>  
>  	/* Make sure the name is not already used */
> -	if (reserve_mem_find_by_name(name, &start, &tmp))
> +	if (reserve_mem_find_by_name(name, &start, &tmp)) {
> +		pr_err("reserve_mem: name \"%s\" was already used\n", name);
>  		return -EBUSY;
> +	}
>  
>  	/* Pick previous allocations up from KHO if available */
>  	if (reserve_mem_kho_revive(name, size, align))
> @@ -2692,12 +2696,18 @@ static int __init reserve_mem(char *p)
>  
>  	/* TODO: Allocation must be outside of scratch region */
>  	start = memblock_phys_alloc(size, align);
> -	if (!start)
> +	if (!start) {
> +		pr_err("reserve_mem: memblock allocation failed\n");
>  		return -ENOMEM;
> +	}
>  
>  	reserved_mem_add(start, size, name);
>  
>  	return 1;
> +err_param:
> +	pr_err("reserve_mem: empty or malformed parameter\n");
> +	return -EINVAL;
> +

Nit.  Above blank line seems not needed.

>  }
>  __setup("reserve_mem=", reserve_mem);
>  
> -- 
> 2.50.1


Thanks,
SJ

