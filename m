Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 353B0C982DA
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 13:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA1D76B0088; Sat, 19 Sep 2026 09:02:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D62106B008A; Sat, 19 Sep 2026 09:02:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9EE66B008C; Sat, 19 Sep 2026 09:02:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AD0016B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 09:02:42 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA76F80253
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:02:41 +0000 (UTC)
X-FDA: 85230526122.28.95B5B10
Received: from mta1.migadu.com (out-27.mta1.migadu.com [95.215.58.27])
	by imf19.hostedemail.com (Postfix) with ESMTP id AE6FA1A000B
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 13:02:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iRnKcDfT;
	spf=pass (imf19.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789822960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ehd492Wd8bFyayJBAoOeC+yR6jFwKDxmYO1vaxXlwb8=;
	b=Y9QKxxu4gDx3ze1itVVHOT3BaFv8IufmmuV/HHZe/w46k1XaFLb3JkhD1f3N8vQu7C8oIK
	uCVPBfGdE6Z8b4fNfxrjtQ6gsWaxmv8PXiAX3oJGODBMp1bOJRq/iTyQeP6N/N4ab89fEk
	AT0mcBVVO/fK6qs3FsFMOYeuRqXjI2I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iRnKcDfT;
	spf=pass (imf19.hostedemail.com: domain of zenghui.yu@linux.dev designates 95.215.58.27 as permitted sender) smtp.mailfrom=zenghui.yu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789822960;
	b=Q8DaN7cp4cKbkRIaW8pCfgDiaW1BcdgCVzLoI354RmdUkX/haYIb07zDgjggtB8cbRCwbf
	sukgJJ7IhWIBlSu1KOuVGN+uhQmjzWy3FgjYOXsfbNr6P2XAuCweqZQjAUcBRZ/VsqFtFA
	LDm4XcNJOUxGW5jeNbXnuBHZG8FpODA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DUvjoQROS8yk+VfXJeNWxO9qytK3Bfp0yYXrhXYSjQk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789822958; v=1; x=1790427758;
 b=iRnKcDfTf0v1aSNak1pUAjhodKXLzeUe961jk+nr6pxeNb2rM6+y9wZX9MsE1XJTkqwCogfL
 +NX5Y/XaUTPNylEcBdhj0ucDU+0cs3jHZIfPvfMt03FNHyzO1HSZysRen56eMWENWZj2ZpfKaw3
 fL+tjUNdcbs5FGn8yZ6BYm1g=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 498751209693f72e;
	Sat, 19 Sep 2026 13:02:37 +0000
X-Mizu-Trace-ID: 498751209693f72e
X-Migadu-Flow: FLOW_OUT
Message-ID: <ae900f5b-7f00-4c48-8097-f2f836c09f60@linux.dev>
Date: Sat, 19 Sep 2026 21:02:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/10] mm/damon/api: remove NR_DAMOS_FILTER_TYPES
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20260917142210.90829-1-sj@kernel.org>
 <20260917142210.90829-2-sj@kernel.org>
Content-Language: en-US
From: Zenghui Yu <zenghui.yu@linux.dev>
In-Reply-To: <20260917142210.90829-2-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 1fwkq9wnp1mrw7iq76nit4a91mm5ge1k
X-Rspamd-Queue-Id: AE6FA1A000B
X-Rspamd-Server: rspam07
X-HE-Tag: 1789822959-548170
X-HE-Meta: U2FsdGVkX18lh8Gyw983QpSwyWEpNedqjkzRMacocSlem8KAX4quRrKWRNSjjtvUh8NKOJR6vmZB7akqr76IGAzmK7oEc8aKKkig/9pu4IYSVSwp/B8e9+6285fGPmsMv05Gh5yTMXvL1dBApOVRTeh+4pLg6HqOJ08miY4gLAI6x5bdyoVK81lkzvhjLcBJC5gxw5KkkVWLTXm3BrYnQ+xcfbCFrbc7bBZjKf8r6CpzXosu2z+d7WjF30GttxoaPiCbHxkc38yp+dJr/1gBbSsSSNkNb1soR8CmPKrzQkPf4VmsHqw5KV6JfUCfSibXApszdJEX2VG9DaU90jfoFzQw2ObYynitPLjJedqwm4j34e6woIkfutQWIX1WRv6TJoFjhQc81rLWPzLpIPh8q97nbMOpRPN/logTJA+qt1k4IOCR4T6Yh0qfA3BpF6ZIkLKNyaTi7mY5KHPHRmJNJGam+5EWWvUVNEMd2xtSKVctBwvZa3wBZ0ARn5NhSEKNrrT3eKRwSdJp7CW77PNoqHJAae1CLSoNrk6LQmiDUN70k16Kf/KdtXWzq5aLmTAbVL/rTlh+BcvSR9HpPDZUCiCFRT7GjMBQjuh3f0zruGA4kFH8vc5sPIV9OtbXpFCX3jZYsY/s2yegu6dzVKuyMHlohkGRaIxc71ktboexVytPd8t67khU+jd6JgE03Rwa5jB0hehA1GQvrBzZfQ3OEtUgRiqroinscJJ5aHE169ulAFMyuIYzNN0OorHv5VVUF+WatZFycRUcoLSSiD7YsmAVGxcC/7Uluxo+188tqo53VnOmVN8ye/XtR+WiWX43yaTLu3jZ3EG/dQwhgJB8FJCFvQBBBC6Mxw8SroksBjKUBRgtRdxV6DgxQCUiYbXTJR9UTku5aXtq9WLlX8Vn/RsCbWx4qPCZHYHhPiPbHUweDF3TcQGE2v5tpst+5iGmEhnWc/U3QAFMEDNqwGy
 /pGW2lxY
 /tgGCA+AwLeEDoVGgxd/WfxtIqwxWgt5TO4YADndHriggQqm1hgNc4OljwoMT/vPtMprcsUfFTB/0uUJtG8zkp0HbLv0axReI3jf9xeqIP4eg9e+Ru2trWQhI/M6sVjy/zAEgx1HKXzvwDgfBBvmZcZIdAOA2yMsL363jlyTvT0+X9TvGGhYDvCDS2rPMxNmn7L0IysDj576RPUqX2TBr9qxw1rdHb+abM/xC9ERysXS5Xx/KSBhl8UMYmkSZrMOFhS9CcmtKLkgBujXjSps+aL9/Qsp9R+2UnzUq6g27RATP/jlKUZQP6c+oHL86YOjRlEsMTHBvF6fBeHuk1+Ifa5nH9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 10:21 PM, SJ Park wrote:
> Nobody uses NR_DAMOS_FILTER_TYPES.  Remove it.
> 
> Signed-off-by: SJ Park <sj@kernel.org>
> ---
>  include/linux/damon.h | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/include/linux/damon.h b/include/linux/damon.h
> index bbb190b474015..836353c4ab9aa 100644
> --- a/include/linux/damon.h
> +++ b/include/linux/damon.h
> @@ -400,7 +400,6 @@ struct damos_stat {
>   * @DAMOS_FILTER_TYPE_ADDR:	Address range.
>   * @DAMOS_FILTER_TYPE_TARGET:	Data Access Monitoring target.
>   * @DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:	probe_hits weighted sum range.
> - * @NR_DAMOS_FILTER_TYPES:	Number of filter types.
>   *
>   * All types except &DAMOS_FILTER_TYPE_ADDR, &DAMOS_FILTER_TYPE_TARGET and
>   * &DAMOS_FILTER_TYPE_PROBE_HITS_WSUM are handled by the underlying &struct
> @@ -422,7 +421,6 @@ enum damos_filter_type {
>  	DAMOS_FILTER_TYPE_ADDR,
>  	DAMOS_FILTER_TYPE_TARGET,
>  	DAMOS_FILTER_TYPE_PROBE_HITS_WSUM,
> -	NR_DAMOS_FILTER_TYPES,
>  };
>  
>  /**

Similarly we have more definitions of NR_foo in damon.h:

 * @NR_DAMOS_ACTIONS:	Total number of DAMOS actions
 * @NR_DAMOS_QUOTA_GOAL_METRICS:	Number of DAMOS quota goal metrics.
 * @NR_DAMOS_WMARK_METRICS:	Total number of DAMOS watermark metrics
 * @NR_DAMON_OPS:	Number of monitoring operations implementations

and only NR_DAMON_OPS is actually used (I checked mm-new).  If the
preference is removing all unused macros, we should probably clean them up
as well.

Thanks,
Zenghui

