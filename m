Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4D39FD8775
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 13:51:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E013F6B0005; Tue, 17 Mar 2026 09:51:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD9536B0088; Tue, 17 Mar 2026 09:51:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8206B008A; Tue, 17 Mar 2026 09:51:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BCA4E6B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 09:51:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5474F160109
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:51:00 +0000 (UTC)
X-FDA: 84555691080.25.7932C4A
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf14.hostedemail.com (Postfix) with ESMTP id 199C210000A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:50:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Z8Ks1jgK;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773755458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KrJcq8GiXxMyinwAoqRMnMTIBXNzfOAtBfNZI3AE1A4=;
	b=3ug7myeQiFK95sDRraVLnNrG1lelDyEtADqAFxZ25ZMeYfeDpYzfRbJdpT3oJfLQNzVlG9
	hUA2FJY/GhnCL0RZhq2S7/eIy4QyF9aXT2q3nfZOtr8tCjOolYxzGQuX90K1xWpoXwwBVu
	hh0lkllMeoN3N5LZCCdFO0dzImrkxAg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773755458; a=rsa-sha256;
	cv=none;
	b=aoL/aTvbayvTFqefnRwNGnvBF83ksLRBuZJ7qjAadeR766qGpssPMFK82hbXmaDc856EFp
	wViS3B7O9SUie5XE7ATW98bPd0lNQkplTkNvI0yZUW30UaKkK3aSYqfORqj35kpQ+MCsMs
	Vl/PZR5bZgntNlEmnd8NI4/L55YQXVA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Z8Ks1jgK;
	spf=pass (imf14.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=mhocko@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4856cd3f1ffso16597735e9.3
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 06:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773755456; x=1774360256; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KrJcq8GiXxMyinwAoqRMnMTIBXNzfOAtBfNZI3AE1A4=;
        b=Z8Ks1jgKRRqway9uZaX2FxSKVc+o8E188Fnfa1bp70/Jm7wWEa3IBxNGV8c7HoxpMx
         OKzlPkz/bs3yKR5r80T77IKLMOFvCoFIFvUGSPhNry7kr8q86xjL6ngeBjZlR/MdP3TO
         tJQt6EY7gtlXOLHrrixfk90u3Og/2IXpzvKr1ll6SJANw3f3kdmrvvB3vZezQ/b04J6l
         LZOVMafBUURO+YegF5vSvo/ifRdT/2dp/IfkpZ091yiPjUOQAnKCh5f7VpO9XYLM4C0i
         pbXohl758llObzOnBe+VQkqcgMk05vSAJjH324bG8jdosdmTY/8qSrykyHQu29VEbNDt
         q6Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773755456; x=1774360256;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KrJcq8GiXxMyinwAoqRMnMTIBXNzfOAtBfNZI3AE1A4=;
        b=Yhn/O+jLqhWZU7ki6uI59IMLxNsCHVLVSlxVlQiubN5R6HERI59fhvk7Sd2k1CJIGd
         duAw0UShhpUGOGmN1UwgawK3P+N1JwqB83PBu26Eo8ZilByqLvCRF4dfInMD6pWehfJp
         A0fQM+gunxl0eWFGRtW5GUNxfRvKSO0//HoChRCM8Vyta47H4jM0ipJQqbY8JOEMQenZ
         LyzfDFSc4DgMovTMODyRdxtljhelncCBwqRmwwmrfLro0/Ae5xwjrWjW/Wsa7kHUUyra
         jvjcLKL99DtPsRxcChGqFpRQ8ggW/djIs6cz5Bul95cLIo4BuTxEAP4TWo1EtBZ0LUpA
         1xng==
X-Forwarded-Encrypted: i=1; AJvYcCX8ElL22rW0n4EHZq8rnJJPILG0Z+ZHSpGrhGJJrs0NEinobsOcd/7knpYnzhTH8zA6JN4h27cZTQ==@kvack.org
X-Gm-Message-State: AOJu0YzXL20mLk6Eo0onJE+Lh+6UsqnQoklODaz7XkHRh79gtG+C9jbx
	M7wN+DQn/2cJLRnDPnl4C6ausmMbJkCixGoyC5YdKJB03tjsj/UUdkl8F6EOn8aAFJ8=
X-Gm-Gg: ATEYQzy+BodPX2WP9P/MoRk4+kqdv3v4e9ugRTW2sM8xDEyjUPexhPg44hSQjJ9EWkj
	3E8jQqeHRQG5B3kWJsWjhmSbM5ia+k8xE6BbptviD16lle/SJ3AnfwZDb9rgRrRhlDLLgtWbL6j
	I4VVYTi+nz01a+zk+qnGgZ7QNxyB3CHshgwsaP8/nKmxSLVoYTXdF4fAOF8iRdCLaS7KEXqz0ot
	IyV9m8wKZ2yiWhVpW4u5WTeX1b5+HX5LdSMUYxFY70/ZfQ0xuIQtQIzC+7t19gJRJNA22CrZGHx
	C61+n0vFmYrLssGJsslHrv7dT/70p1/TssJnLNauZtJW2wqd2/k/uEzYHjrWK9bm2mw2lGfCEoy
	6NPmTncwqHFqQ7+XHpjZExpCuLssa3uilrgzdYZxYBa4DDHG5ZUw2rSRbZfO4OrNyAa9jQS4Amv
	8pIznnjQ1mFfU0W6XxUufl0HK5P+Nl/VNQ6tsa
X-Received: by 2002:a05:600d:8488:10b0:480:3ad0:93bf with SMTP id 5b1f17b1804b1-485567060a1mr208600275e9.24.1773755456223;
        Tue, 17 Mar 2026 06:50:56 -0700 (PDT)
Received: from localhost (109-81-21-195.rct.o2.cz. [109.81.21.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4856ea8fb0dsm123490165e9.3.2026.03.17.06.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Mar 2026 06:50:55 -0700 (PDT)
Date: Tue, 17 Mar 2026 14:50:54 +0100
From: Michal Hocko <mhocko@suse.com>
To: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	"T . J . Mercier" <tjmercier@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zhaoyang Huang <huangzhaoyang@gmail.com>, steve.kang@unisoc.com
Subject: Re: [PATCHv2] mm: remove '!root_reclaim' checking in
 should_abort_scan()
Message-ID: <ablcPu_1OW-lh3Kp@tiehlicka>
References: <20260317123037.1651424-1-zhaoyang.huang@unisoc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317123037.1651424-1-zhaoyang.huang@unisoc.com>
X-Rspam-User: 
X-Stat-Signature: 5c6cd8wzdqyewf1o4m3fhpqf5k8oy7w7
X-Rspamd-Queue-Id: 199C210000A
X-Rspamd-Server: rspam03
X-HE-Tag: 1773755457-649064
X-HE-Meta: U2FsdGVkX1+I4kSXBEHe/AxC8A3P76VJ1CcKpr0LxLd4h0cHP7zQ/wJEs0S7vGO6u4eNZ8dZMhBnlvXaQFOpu/i7PuZBsgogvDphztUjb2FZxzznOXMKf8vOqG5QQiQBsUatYL4qx7qYL2EcJZEDKTrSvLHsf+Od7kdDI+c0zP03sUTBIUPY0Xj3b0XAE2sDcruXyf7vXGhhG3N79oRkDu8VZT30AWznr0ujVVsiqJ63cr1rfVURZO5gaTBG+wYojQER1oRvU5C/yjP+afx9zPkv9Fp21dJt3rJkYfDYp5XvfR6F+QfHcIFXZeEtoDFBEN3CSaqRG6db0LhJQFE8R50Yj2d9hjt0t0Tp64pVLswa24eGLjMFa8No3Kh/WSC/dqA7kR11XWxITMtFEBDKWTULYuQt4hj06oZe+I6eQa5dPjS6aqeJlEd6WJ9kQaGNku94PmY0ilwE7Q6HSIOeNwsA89Q2RP1qZa8Z08gWOwxdpWfRnRHjnWfd3CkzU/bFTskBr2myC79lP+wA48Ws6tC7RDA+DjnkuJcSH1V0n+zekrksQ398Bxu/NWnKyrXVwHXAKBAyHCrZfVSv76SfdKKjWqXenFUGvg/2ZVtc7MQ+sAzu4rrsn1Pqi4wHOUh2hpEMT/uR4rLSn0wEOOUogDbFCXOyZMp4jKYIXRgcvf4lNpomufGj5JPp1eF3VLk/pOZZUZ2Ug3+I53jkPPUP8M8BrUA5TzWgPLQaQ810bTs0UM/JHDMuRPE3itbo7bJlijJnABhobwkowww2DyNEPwCkae/63RMOcfv9YMmxCWCrPbV/eQYNu0oUZxw1O/EnT0kBJ7FZAyK5gSQgr9RDicmXLJ4oiG3w2oYKgz6nl+vGjiNsMtdW18rWSvr+ZwnUbv/9Rr+D35isijFXTBQL7VUd71KQXMiaqxFB6Equu3JnFWpYDCryJ362Th9QLwtlp/XBXq0a9RgtHwaF2iV
 BgsnCu7O
 vmH+SgmhFDcn5nXCwD5PPhRV4PZ6+IjS3K1SKCWLn6QvVOWDAImFLB/aecJbdO2Wz5sBMaAPkjhcCLCRvdFWgYh0zGKTjkS7Uei87AqviTf4IZb4x/dZ1tMRqcnBUPJ3gGLu8ffzstDda/C9pE9qisKUN3RnkmZ8U1CE13ZR4GXpqKDrQ9jnWzoBoIGQ1m2Ki9OVc6Z0AKVW30IGrqjnp7VFyptE0irU/BYmq8Ogfknntzjg4+Rxl1fKNmTEMmj5SdjoCyM3xlKZl7S6D+j4O3Xc2VqYixuy3CxfMa+26eydx2kISKIOIkBcTxnqTazD48WRUJWQh/7jt6J0YBxLVUZNpIdOecrXuKyNMR5HtR/uUAJbLqMlV0/rSGSGmSQezTt2F7WYb56T7hLlALEicwtx1nJJq21L4GZ2KC+zZOFmXOIjtMnWUCw0cwVXnvTCVG7XOTkB+5SSnBg3hXQp5IjkznlK7svqbJcNNpBXXGW4bb5Rea6p7Is1A6ysS+WRCTol9ZMXUz5mqD12r/LpTxX31jeUbKwRrPSAB5diPHyU6WOHJg+3u9hNHWbC4UBdT8bZZ44Ad3FX4Mro=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 17-03-26 20:30:37, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> 
> Nowadays, ANDROID system replaces madivse with memory.reclaim to implement
> user space memory management which desires to reclaim a certain amount of
> memcg's memory. However, oversized reclaiming and high latency are observed
> [1] as there is no limitation over nr_reclaimed inside try_to_shrink_lruvec
> when MGLRU enabled. Besides, this could also affect all none root_reclaim
> such as reclaim_high etc.
> For try_to_free_mem_cgroup_pages -> shrink_node_memcgs ->
> shrink_lruvec -> lru_gen_shrink_lruvec -> try_to_shrink_lruvec, the
> !root_reclaim(sc) check was there for reclaim fairness, which was
> necessary before commit 'b82b530740b9' ("mm: vmscan: restore
> incremental cgroup iteration") because the fairness depended on
> attempted proportional reclaim from every memcg under the target
> memcg. However after commit 'b82b530740b9' there is no longer a need
> to visit every memcg to ensure fairness, horray. The problem is for
> large lruvecs, the lack of a check against sc->nr_to_reclaim inside
> try_to_shrink_lruvec (caused by the continued presence of the
> !root_reclaim(sc) check) can cause overreclaim. The non-MGLRU
> implementation in shrink_lruvec already checks nr_reclaimed against
> nr_to_reclaim.

I usually do not insist on a specific format of the changelog but the
above is just hard to follow. I would rephrased and reformated as
follows.
"
Android systems usually us memory.reclaim interface to implement user
space memory management which expects that the requested reclaim target
and actually reclaimed amount memory are not diverging by too much. With
the current MGRLU implementation there is, however, no bail out when the
reclaim target is reached and this could lead to an excessive reclaim
that scales with the reclaim hierarchy size.

<YOUR example workload description goes here>

To address this issue drop the root_reclaim exception from
should_abort_scan.  This was necessary to achieve reclaim fairness but
b82b530740b9 ("mm: vmscan: restore incremental cgroup iteration") has
addressed that issue and visiting every memcg to ensure fairness is no
longer required. <EXPLAIN WHY HERE IN FEW WORDS>
"

> 
> [1]
> test log which shows a nr_to_reclaim=32 pages proactive reclaim ended with
> nr_reclaimed=394.
> 
> [  485.100981] memcg iter ffffff8086535a00 nr_to_reclaim 32 nr_reclaimed 0
> [  485.106927] memcg iter ffffff8086535a00 nr_to_reclaim 32 nr_reclaimed 127
> [  485.109652] memcg iter ffffff80744e1400 nr_to_reclaim 32 nr_reclaimed 127
> [  485.112255] memcg iter ffffff80744e4600 nr_to_reclaim 32 nr_reclaimed 127
> [  485.115766] memcg iter ffffff8150306e00 nr_to_reclaim 32 nr_reclaimed 191
> [  485.125635] memcg iter ffffff8157608a00 nr_to_reclaim 32 nr_reclaimed 191
> [  485.131366] memcg iter ffffff8157754600 nr_to_reclaim 32 nr_reclaimed 216
> [  485.136688] memcg iter ffffff8157752800 nr_to_reclaim 32 nr_reclaimed 216
> [  485.140495] memcg iter ffffff8157755000 nr_to_reclaim 32 nr_reclaimed 216
> [  485.147322] memcg iter ffffff8159461400 nr_to_reclaim 32 nr_reclaimed 216
> [  485.150605] memcg iter ffffff8159466400 nr_to_reclaim 32 nr_reclaimed 216
> [  485.158260] memcg iter ffffff8159460a00 nr_to_reclaim 32 nr_reclaimed 216
> [  485.160819] memcg iter ffffff8159460000 nr_to_reclaim 32 nr_reclaimed 216
> [  485.163200] memcg iter ffffff8159463c00 nr_to_reclaim 32 nr_reclaimed 216
> [  485.171778] memcg iter ffffff808912ee00 nr_to_reclaim 32 nr_reclaimed 216
> [  485.174156] memcg iter ffffff808912a800 nr_to_reclaim 32 nr_reclaimed 216
> [  485.179110] memcg iter ffffff814bd3a800 nr_to_reclaim 32 nr_reclaimed 216
> [  485.181537] memcg iter ffffff814bd39e00 nr_to_reclaim 32 nr_reclaimed 216
> [  485.184877] memcg iter ffffff814bd3da00 nr_to_reclaim 32 nr_reclaimed 219
> [  485.187245] memcg iter ffffff814bd38a00 nr_to_reclaim 32 nr_reclaimed 219
> [  485.189654] memcg iter ffffff814bd38000 nr_to_reclaim 32 nr_reclaimed 219
> [  485.192029] memcg iter ffffff814bd3bc00 nr_to_reclaim 32 nr_reclaimed 219
> [  485.194509] memcg iter ffffff814bd39400 nr_to_reclaim 32 nr_reclaimed 283
> [  485.197107] memcg iter ffffff814bd3c600 nr_to_reclaim 32 nr_reclaimed 330
> [  485.201361] memcg iter ffffff814bd3ee00 nr_to_reclaim 32 nr_reclaimed 394

This is a lot of bloat without a very limited information. It would
have been much more useful to describe your specific situation. How does
your reclaimed memory hierarchy looks like, what is the requested memory
reclaim target and what how much memory has been actually reclaimed. Now
compare that before and after the patch.
 
> Suggested-by: T.J.Mercier <tjmercier@google.com>
> Reviewed-by: T.J.Mercier <tjmercier@google.com>
> Reviewed-by: Michal Hocko <mhocko@suse.com>

I haven't given my Reviewd-by! Just participating in the discussion
doens't imply any tag.

> Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> ---
> Patchv2: update commit message
> ---
> ---
>  mm/vmscan.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 0fc9373e8251..10f1e7d716ca 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4839,10 +4839,6 @@ static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
>  	int i;
>  	enum zone_watermarks mark;
>  
> -	/* don't abort memcg reclaim to ensure fairness */
> -	if (!root_reclaim(sc))
> -		return false;
> -
>  	if (sc->nr_reclaimed >= max(sc->nr_to_reclaim, compact_gap(sc->order)))
>  		return true;
>  
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

