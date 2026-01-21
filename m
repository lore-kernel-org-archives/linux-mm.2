Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6AB11D262B5
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 14:38:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAF746B0005; Wed, 21 Jan 2026 09:38:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A87C86B0088; Wed, 21 Jan 2026 09:38:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B4246B0089; Wed, 21 Jan 2026 09:38:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 87B776B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:38:10 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3B06258B9C
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:38:10 +0000 (UTC)
X-FDA: 84356225940.07.CB34A78
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf02.hostedemail.com (Postfix) with ESMTP id 10ED980016
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 14:38:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CRB12vaS;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769006288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCFnBYovc8CaOJRyUXyWvhAiDjdFkUOm+Iek0vayQAg=;
	b=4Aw3xlGKq7Wa1CizFJzCpjOV3jcKN0bOicfnumSZzuvqwNDC96ahLKD5MsTyMc/cLw52Uw
	+p2DqYZNi0lBhDv+KtHejKxh9wGY+uX2a59bhxfFNp/05+hPb0r+XsLigdS2zoCwptoCXX
	KJArzTiFniTZ3Fe1L4RMknGFx5RJO0s=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=CRB12vaS;
	spf=pass (imf02.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769006288; a=rsa-sha256;
	cv=none;
	b=jJz+oSjPTmrsj/YSLCWXX1XDebJGOhdxR5l6ZHA6/HiaW//S/J5ie8B/lASsCZOl1ddRuv
	SFkMK89XubrORTQAXdsLSM/NyrJLZIGqIgbemSo+n4BqElc87aO+ABP5rmyqNg4pFJtGjo
	O4FjPZ5SoEq7hd18wqUtFF2EPnWw+oM=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4801c1ad878so55531535e9.1
        for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:38:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1769006286; x=1769611086; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rCFnBYovc8CaOJRyUXyWvhAiDjdFkUOm+Iek0vayQAg=;
        b=CRB12vaSoRRJqjGbHy2CicXA+Nmy0ZRVOYYpdTtN0ziRU3ZPx3SgeaV7SnDJ6CueiV
         m9SKuhrB//jWjzxlbF7l7DAILoQs4GlSdq8E/7Rg8ecIbDIOKwYhQLjsngIdkAaFgJiY
         LJqINQ+xLreyNAWF/OXE54WMYwbHQZQjwwMHhflRUar9sIgCE/0qoNAmZkTQIapSoEH0
         pObP/+4HrLDq7CnwA6LAi6nERc3P2DX2nPPgbEHVc0TaOalGI7Ew1+120wCIw0+iaAcy
         r860wE6CO7w2fuUylr2P2s/kDgn1VY5x1jSmzraFqWpDSjn6cL8Y8MA7SZe9IRU16wW+
         0UEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769006286; x=1769611086;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rCFnBYovc8CaOJRyUXyWvhAiDjdFkUOm+Iek0vayQAg=;
        b=iGdwLNrXIc/yyHTGsDlKTQbaQN/q7TCTu9ozq9OJUp2IhTVHswGB7Z1BoMNCtx4XDh
         h6KKSUW9vxA9R7A7yoQC8Odp2W6cTHnLJhBQ7a8+SlVTn/tQsFsim5s7PfRrzJfjdZgQ
         YZAvXVRuByDYT3qu3zHgQq3XkGWaAII4hTZwkvdAKP9voDDXszByYtqnRe814UIZOsFO
         SNRdomwQUtKPeLed7duD17bk7WgnPlhe2ilbSpOIgGdXcfQ4c/uB8M/DkypXADTmqxYr
         zgjzd4SJpmos8OIHeoEvNZMOoXAeVbhgmPGgyWleuInfRFxFxbAtvtj5XTGvJLwftL5J
         m4eA==
X-Forwarded-Encrypted: i=1; AJvYcCVqhGtnFrQ6b3m+7TX5pG7PNfJTHVjH3bswpzMC/TMQobilRafwU5e9/3L212XIHoURGjYVKgvybg==@kvack.org
X-Gm-Message-State: AOJu0YztqqUg83SRKQSGf3wchbqfAH7BuPYXX/HBUhRyXW2ZZ4x0reft
	26qmmGZDzMCRzdov0cupGuJV2sIM6D/6JfPr6Zmq5khCOV8bWlmizGQE2nP2rWQMT2croJDU1CD
	f2/ob
X-Gm-Gg: AZuq6aJjrMB5oL3f4OSFNej6/zGpuzb76uaHNoNzLfIswgM5iJWeDSbaNOm13yxU3B3
	keL2qCrrixnIhapIQFPSG/bxI3GJDfHcnAyG0IE/4M0j9NXyS8/MmLlAoWP7xyNNpOcS8aoj95n
	rSB1A2bL/NaB3AR0dM2PTqGpgn8srNrIz9R3n0WcVQHBPGL52yyNGlGK7oKmPnjxW4HlcYfyvso
	uOQhBKEW/AK6MbtDVTOGX85qPWKvcWQDPgr7Q4CXHwKDPwm2x2UqiahEyhwzOdw93L2DQYzM1cK
	wcpznPK9ZTw2vsZUUoU81CEXOcRSI1a1kKRUDCH5wE2pipJJBjKuWNc6TNGs8k6lrVTQ1en3JQy
	45yri3hJwLoJHzixHn5vZxHBZx4ci7E5ES/6sMJUvvS/ZEbABUj4cD/V+u5c+uEEt7rRpv6088s
	3e2OWN+PG+28g+nVeZqNKxnfY9
X-Received: by 2002:a05:600c:154e:b0:47a:80f8:82ab with SMTP id 5b1f17b1804b1-48042c3a712mr47102365e9.24.1769006286356;
        Wed, 21 Jan 2026 06:38:06 -0800 (PST)
Received: from localhost (109-81-91-169.rct.o2.cz. [109.81.91.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e886829sm312872195e9.8.2026.01.21.06.38.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Jan 2026 06:38:05 -0800 (PST)
Date: Wed, 21 Jan 2026 15:38:04 +0100
From: Michal Hocko <mhocko@suse.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCH] mm: bail out when meet the goal of proactive memcg
 reclaim
Message-ID: <aXDkzHygHZasufg9@tiehlicka>
References: <20260121090620.559242-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260121090620.559242-1-zhaoyang.huang@unisoc.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 10ED980016
X-Stat-Signature: sxodket94ggwkgqzi1fcuorrjz1yo46i
X-Rspamd-Server: rspam02
X-HE-Tag: 1769006287-358677
X-HE-Meta: U2FsdGVkX19wH9/irQvDnqShCTJWhQfzLTASXD6+22FwjalnPxiOSc0yyxTVsK05aBIuXxGg4sdKAgKuD3h/56iD2WX3OnQe4lh3gjy/9Ozp+dEOom4ENJFtUXzHiX4zdCRfEB3w26gn8cEOQcF4J/uSgH/dOCVfBZ8yPGlJatdgWhEBYY6x+lz0X2dJ22cHOP1p185QPYenopTEUwfE3bt0ZRRy/g7uBesTuq38+zgTmdBpBxH1+8hBy63T4Y/s8w9pcksIZwsfV/dS4YYqaaHvoz15OTKy7kOk3iy6Buc6FluRe3dj6qfSgYDi8rnZyFhDB6d+m7B74r++/gTiYB4YKbnaaorNSAexgQyGD72oYKmHxrUQvMFsuyFZQ29r56bzcVqGdQTiIbvysFd2pv/j+IwSRI5coJv3H2hry1jJnmCcJqFBZVU/dahulaGGVUn5HAnxAMrr73eixUSJAm7vpO//zfNXKFE06zlYiKKSRadKlhNixVUZFQbvl9Zp70ziAVfbq6LoHaFcc0Q+qR81nhiiBeyv9bd2Xwo5YDiYDekq4o+PPlmvvh4W9bL0lVVJulRIqQLRBRHQImMeGfGQk9A+NWujuHf1sSMqEbwnnacGv+dxonJjcolh9zOIbpUasBEDF+11i98SN91i2fAfT2NvZabFJnKX7ERvvotiwwXgeFU+6uGEgGFZSboJ2/NMbKcwl2+pKM3opjotFMO8BUT3PQGBt8bKPN3DzeeA3ZJUsOwwTtWbiLKRZd1/Z7oLfzMXQAMyNv1TIwfW8HU+Dwz8i7ysAUs7t4K3jUuNmXDxMP5HU1Tl6zxpuyA9s87Kay++QhoN97yDNW1mh3udk/ACzXS7dTs5LLnOtsTuEsZhQYRRJIVdvmIYKUEVaxrSQggT4rTdP/KVjT03plkBdFCSsMeZrGeYnxYjoYN5Oti7y2+mRbsiwaLMAuvIOl7cNUzURWxqrnv+CNl
 8xPDSKXO
 TTZ2QgDc0LK0HxvHoqW8C0WGVWuNEivRO+7DYpDtrKGXjBoDAZU7MnLOPwTAG8M+OsR67972sDLEuAQCSDhq5gWOjQMcyLAmc1xZvLVsZ0vT1pN1g2PLuFW4BVvoqeaBrjsC3ZQUNXf9TowI3nlVGyYEPuqPbwSTB1SBP5NdCZWpHeJzoF4HXGGXalmSTCQptFzT5q7tCe5/3jsRYQpgPHoF2vtCTBdh9SO07Z/PhnZNhUINVAzlx/8sxpebn+Byzz95GtFw1eziTAV0nLrtOC660GlpjO6O3hk6cNVKI4nW13wuVHFwlm0iuedFGhWSmEFBOGk12ZMAF5fP5ofJrC8mCeT3YSLaERFuc9eKLuocESkLksXjWZ3fFHjg4utuAnaSaAnJeQVFdr2EHioZaPDhWJYxUbQLY6fnPU9q/F1OVBhDd0LXbKqf7ZRDW1YRP5Dbk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 21-01-26 17:06:20, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> The proactive memcg reclaim defines the specific target mem cgroup
> as well as a certain number of memories, which is different to
> the kswapd and direct reclaim that need to keep the fairness among
> cgroups. This commit would like to introduce a criteria to have
> proactive reclaim bail out when target mem cgroup could meet the goal
> via its own lruvec, which means the reclaim would also go through the
> whole tree if the iter start on the desendants.

Could you describe the actual problem you are trying to deal with?
I would be also interested why the limit aplies only to target_memcg.

> 
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
>  mm/vmscan.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 670fe9fae5ba..5dcca4559b18 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -6028,8 +6028,15 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
>  				   sc->nr_scanned - scanned,
>  				   sc->nr_reclaimed - reclaimed);
>  
> -		/* If partial walks are allowed, bail once goal is reached */
> -		if (partial && sc->nr_reclaimed >= sc->nr_to_reclaim) {
> +		/* If partial walks are allowed, or proactive reclaim where
> +		 * the target memcg is clearly defined that could let us ignore
> +		 * the fairness thing, bail once goal is reached.
> +		 * note: for proactive reclaim, the criteria make sense only
> +		 * when target_memcg has both of descendant groups and folios
> +		 * charged. Other wise, walk the whole tree under target_memcg.
> +		 */
> +		if ((partial || (sc->proactive && target_memcg == memcg)) &&
> +			       sc->nr_reclaimed >= sc->nr_to_reclaim) {
>  			mem_cgroup_iter_break(target_memcg, memcg);
>  			break;
>  		}
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

