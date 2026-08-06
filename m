Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7B60C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:50:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9D716B007B; Thu,  6 Aug 2026 09:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D6A6B0092; Thu,  6 Aug 2026 09:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C0B6B0093; Thu,  6 Aug 2026 09:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9B6686B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:50:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 284FF1206B5
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:50:21 +0000 (UTC)
X-FDA: 85070979042.26.CC9D895
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf07.hostedemail.com (Postfix) with ESMTP id 15B3640003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:50:18 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PGFtxNYd;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786024219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ejTfR18inMal9BF+WY2i6i5Eh6izHN7yhpp6phMOSsU=;
	b=ws4rGUShxvF0EwVZ63fw/PyU7PDxHG3Wl4r+WPw373ums2Nae/lGKoOGl6UpnBM5teWPhL
	HOolmBw1WDE6f8MdTwpv7utGG1PhXFu5lrbKdJJjqqYfoMVXjKU4RURLQqRkSBN97Np6QU
	zd8jUtS4K6jLFqy+hAt4P1sFMropjmA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786024219;
	b=qQALVsCIMY1uqffvH9zhh24xYLrvOFZ7LK0vSNvmNWRcGcOkGCq+HpoP4rydsG/9R54chG
	MlB+97jxbxBrxpzfTSZilg9kW3iIyr8fmtzUUlwmpi/UE4Vjl+YmzUcVhGtbC59tR6eIkN
	ir/UqU8tl7JA+jHcXc0qMQc5ioubBmY=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=PGFtxNYd;
	spf=pass (imf07.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-936623c6dd3so24795285a.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 06:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1786024218; x=1786629018; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ejTfR18inMal9BF+WY2i6i5Eh6izHN7yhpp6phMOSsU=;
        b=PGFtxNYdx0UgjIGkgI9mdLEs+f53D2lcnU2jIde1996G/WgJCDQucXE3jMOR1SB2IM
         0mw7myxk9DXm6vHdXTlI0/l0NNeDy6buiqSFMjJm2jC218WXCC0pMj8+FeSY9SMgKrxW
         ODe/eEne17CEwnPpuc0Q9cUBMxlNFk6mxOndkPBjIThfsp54N/IirqRVfxVQplT7Eu2A
         S8ibeSe0RLCrJWhunwTdPSgKduI/91MfLCK58fKLD9t3Ip9iwGGQss3UQEV2vAzpHG+g
         92dXLkuPpdDE7mwv7OHv+VhIHtN4THLSi+g8HTwtMLebMKRjIEck5xpPnez0oRYvfFv+
         W0UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786024218; x=1786629018;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ejTfR18inMal9BF+WY2i6i5Eh6izHN7yhpp6phMOSsU=;
        b=cPGHLgPvi7sXTvQQcFZfXLgLhWbnpl84ew1u83AOYUFVgoMh17U8ne0DQrT0oCjFTW
         U/MZV7MFGElnog5dXVo6w1hCFQVXHuPj5sniXu+C1JirxjHbtt9u/hX4aRza9/6rzz51
         Mjl49lHp68rKw8Jn012qmUmHed5Od84He7knMNZOg0PUJ/ShIpr9XKJiLRTUJ/udIGc5
         5cSjSDt3xxTQrvTjlEknIEcIhWXi558qCj/JNE+2RhXOgG51HEAut1Uk4MrGC0ySRGL8
         BSf3Umd/cTrFTpi0DVUJ4/Vc7ejG6IoJXs7+pdJ6jzO5TnTUkzm7mkp68WQsKmKqeeDp
         cPHw==
X-Gm-Message-State: AOJu0Yyetyj+1i2Y1VvjsTQ6vhDsMGuHV2PxrPLugXkujThoaMJmbMx0
	C7KG7LYFucX6QVZoD8qQDo7EzG2Dq1DaH0/8pLF3JK8P0HeejC3wGHHFVy65K3tTQ9E=
X-Gm-Gg: AR+sD10rdcxYCDRDn3e63FnDgE5pCyRsHM+5ralhFKj48Wi9it66UOt/IB2NTKFq8Nc
	2y3wYc4Cn6WHsRblavyVZ6C5RQKZmq9f6aQ2OxGXZecCjlt4CcBJSny9kSSdSMFixf3h9/VtjDR
	denvZ+WfFITFWsXjzr6ZuRQR/379SgQjGqT6IMJ+uOWuS42q/4+j9IQdFjHMGIR/SkZ2hUwVXI/
	R8jLLTJvvBtjRRSwqG7RReoDDQTb27feto8RBP+Z+0XwMN0/fIpRaiTGdgjS9uXLd0OVgAc65Kx
	UWw72QzT8E5L+r8oaedQ+wkTJQIuA7uP12yFUhGmwUAOSAPEL3UO8cPV7337YkTKbY4/skN6MF8
	9PBt60yXHNaG53QwFiQb2Je2mPK4BGDYsliPyCJInLsYosBiZS95bhIhPoknczt/rAXcAq+JeN+
	GcolS5zKEhe1yB/pAH+lrug15MYwcyLOFiwN94zGTaDU19sGj2gjWS2O7D5Fc3hSy+kdUpEdk=
X-Received: by 2002:a05:620a:450e:b0:934:ac0a:8bb1 with SMTP id af79cd13be357-9365de9c3b0mr432348085a.8.1786024217836;
        Thu, 06 Aug 2026 06:50:17 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9364a4260c8sm409474285a.11.2026.08.06.06.50.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 06:50:17 -0700 (PDT)
Date: Thu, 6 Aug 2026 09:50:16 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jianlin Shi <shijianlin11@foxmail.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, vbabka@kernel.org,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	ziy@nvidia.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-ID: <anSRGASe5FIrqwlg@cmpxchg.org>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
 <tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 15B3640003
X-Stat-Signature: ge5arfazjqo5banx9rns1xdpwgeemy4p
X-HE-Tag: 1786024218-105672
X-HE-Meta: U2FsdGVkX1+It/FtZ6MnvwKKbxJCrI4Z+/ihnei+eNf1tU0u5rNc/czxIQ0Tn3jFDD2lDcuQqYFW4+cU9KpSEXfmkCj+QX8Tx6ZrvKs9APUY2RLz6YKAUUuePTST6nZ7oMq77aaHyCEAcyFmrHENH1lhfR8FrTKcDaolXjhNWVBWgNN3Nat/K0qv47NGmCbsJh+7Y1xVL5CHNiMbeWjJNprpdeRqrCMsKZXwnsaEU2BBrNClaROCLUINm/HF+QZ5XDI4heFBFx58WYdij4AEUhLegcfswOC0XR/rH/4/9RVnrEwAw21wKNvmbGys6R7thbxO9ihGSpiTuZPP4qEBobfinmj4yGnau0ODljcKAqQT4ZtNFZWPq0b4e89phVMcB5+7xSmwQaTlG/4LvYPCoTeph5Yx+cVv+t7poBm8nJQbhGfCN49VHolSxsgYmAahCaFuCKafkgH0Rhbj9eP1zlENymxjb3lvbEoPypvwBXMneGIA6AV6GKk/2bPKPRLedgyOiE0R9PPSVUmbIRQBcHuJ8tb9scXehIYGVD9shPKyukNsaSCJkrM1y2qTJZ5pnBkx5TeQEoM3HY6Qdms8x+eSzUsuUsefCVrfsz43e294QWI13mOwdMOpgTfK0RS43x2Y9S/w2tslR+5XwAbYiAPJ1ab8zooB7PS1VJWHUxV8RbLT+oF5gepyGLUQ0k0PWIgIxoOLiAzNr1W5TeWivBMpmS8U/0ku/mFOJKTRSwPaWzHJzpK4c0wsBS63wx43q2RHdVv4dF2W5c5J0cMfWQleWJGYBtWGI0w5OyU5d4ZHONMuAySW9s8CFCio7bVKwjfy7lL0Xl1ccJL6SGF5nDg4XmofpHGSEIkxKU3FJ9b/uoFNWj/K2IC2LNTuu/XpZV9Lu/2Jd4bvXWEz/m/rnZX2aL55EmzN8CYBlsXZSiHN2t9tauwgcTWIhVIb8H1muNXal8EZIPTDfq7Ikpy
 DqZzjvuC
 dRIWgR3zM5rhdifUotO9zOXp8dys5DfkNzCriChfPfdJCzl0GDcWHRrDaFHtSV6PtvcPGIkc0Qhx2ky5K+jmpHo6DWe+cJ0TuSaGmYCfRhh/0Wy/+C5yEWusXDIE8FCAarD8TRewi4ecdcdRA29JtluQDROLrKosXIJgxWLPFjeskio29SBsTa2XAZR+ncole9h4N8/6CceT6eW+NRgCt8Hr4yfhiQOV7vHw+qQt1ZMTy8xfpnzxErPxAsnGTNwiqfj/VThzlaZsg0WeOGyE69gZdaC3aumMVApIcgNWbfo5lohtusQofdQ03oyP3KWtPWTdHgPTh8gJoVgsddxz/JCFS8i56JIPNP7U6sTUQkt3nsaLfIbsuzANX4oaYnlTqjlpC8HRjRJjq8HrjgcNjYGATYKfHjjWcASG2bre/BiMDIh/M1X+KaudkQuOJzwdeiR8Xt//sLnYrvg5BtFgFEeMWDsrgTPC0ONSf4LkYZikyMdsFGRhUk3M2xoTZw2qi4rYT0Rroyn1ikY13I6nNnbZuKoBgcYZgjSQdEA8WRVbkqxHGyIruHm8xmhJm9uAj6CrAaeVgM/LHfxk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 06, 2026 at 04:27:34PM +0800, Jianlin Shi wrote:
> lowmem_reserve_ratio_sysctl_handler() ignores the return value of
> proc_dointvec_minmax() and always calls setup_per_zone_lowmem_reserve(),
> even for read operations.
> 
> Fix three issues:
> 
> 1. Propagate errors from proc_dointvec_minmax() instead of always
>    returning success.  For example, writing non-integer garbage to the
>    sysctl now returns an error instead of silently succeeding with
>    unchanged values.
> 
> 2. Only call setup_per_zone_lowmem_reserve() when the sysctl is
>    actually written, matching the write-only refresh pattern of
>    min_free_kbytes and watermark_scale_factor handlers.
> 
> 3. On write, parse into a temporary ratio[] array and only copy into
>    sysctl_lowmem_reserve_ratio[] and refresh derived state after the
>    full vector is validated.  This avoids leaving the ratio array
>    partially updated while skipping setup when proc_dointvec_minmax()
>    returns an error on a later element (suggested by Andrew Morton).
> 
> Drop the manual "< 1 -> 0" sanitization loop and set .extra1 =
> SYSCTL_ZERO on the ctl_table entry so proc_dointvec_minmax() enforces
> the minimum on write; negative values now return -EINVAL instead of
> being silently coerced to 0 (suggested by Vlastimil Babka).
> 
> Link: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
> 
> Signed-off-by: Jianlin Shi <shijianlin11@foxmail.com>
> ---
> Changes in v5:
> - Size temporary ratio[] with ARRAY_SIZE(sysctl_lowmem_reserve_ratio)
>   (Andrew Morton)
> 
> Changes in v4:
> - Parse writes into a temporary ratio[] array; commit and setup only on
>   full success (Andrew Morton)
> - Update handler comment: proc_dointvec_minmax() and write-only setup
> 
> Changes in v3:
> - Rewrite commit log to focus on the two tangible fixes as suggested by
>   Johannes Weiner.
> 
> Changes in v2:
> - Add .extra1 = SYSCTL_ZERO to ctl_table entry
> - Remove manual sanitization loop; negative writes now return -EINVAL
> 
> v1: https://lore.kernel.org/linux-mm/tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com/
> 
> mm/page_alloc.c | 24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0387d2afd535..51f35e44132a 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -6673,8 +6673,8 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
>  
>  /*
>   * lowmem_reserve_ratio_sysctl_handler - just a wrapper around
> - *	proc_dointvec() so that we can call setup_per_zone_lowmem_reserve()
> - *	whenever sysctl_lowmem_reserve_ratio changes.
> + *	proc_dointvec_minmax() so that we can call
> + *	setup_per_zone_lowmem_reserve() when the sysctl is written.
>   *
>   * The reserve ratio obviously has absolutely no relation with the
>   * minimum watermarks. The lowmem reserve ratio can only make sense
> @@ -6683,16 +6683,23 @@ static int sysctl_min_slab_ratio_sysctl_handler(const struct ctl_table *table, i
>  static int lowmem_reserve_ratio_sysctl_handler(const struct ctl_table *table,
>  		int write, void *buffer, size_t *length, loff_t *ppos)
>  {
> -	int i;
> +	struct ctl_table tmp = *table;
> +	int ratio[ARRAY_SIZE(sysctl_lowmem_reserve_ratio)];
> +	int rc;
>  
> -	proc_dointvec_minmax(table, write, buffer, length, ppos);
> +	if (!write)
> +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
>  
> -	for (i = 0; i < MAX_NR_ZONES; i++) {
> -		if (sysctl_lowmem_reserve_ratio[i] < 1)
> -			sysctl_lowmem_reserve_ratio[i] = 0;
> -	}

This could use a comment. How about:

	/*
	 * proc_dointvec_max() works incrementally. Use a buffer
	 * and only set the values if all of them parse cleanly.
	 */

> +	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
> +	tmp.data = ratio;
>  
> +	rc = proc_dointvec_minmax(&tmp, write, buffer, length, ppos);
> +	if (rc)
> +		return rc;
> +
> +	memcpy(sysctl_lowmem_reserve_ratio, ratio, sizeof(ratio));
>  	setup_per_zone_lowmem_reserve();

But otherwise, looks good to me now.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

