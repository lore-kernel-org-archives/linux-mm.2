Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 018DAC5DF88
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 03:41:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5C516B0095; Thu, 20 Aug 2026 23:41:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0CC06B009B; Thu, 20 Aug 2026 23:41:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4A106B009D; Thu, 20 Aug 2026 23:41:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE90F6B0095
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 23:41:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE233140338
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:41:35 +0000 (UTC)
X-FDA: 85123876950.06.A837ECC
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9EF2F120002
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 03:41:33 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UjmXfeHe;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787283693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EL37QOqkfz4M1rcSjU6ngbT0t5Oo/IwMsygbaYu8nYw=;
	b=iVlIBQGBM5Y+wRuxsfxSjMJMveVvO8bJAfFAhWTMLBxpdcYG20EAwCgFGwnTp/dUyDZLhj
	TlbujP5jKWU5BEB2jJNMOXem71yi8EXJGlEV3KKGZ1Yb2dxvFo1eyGr3Y15vZmA44Eay+b
	6KyRca8rVZfuJ2DxZGyoRPigVEv1JRg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=UjmXfeHe;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.179 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787283693;
	b=Q24OqXo4kAXvNlDFz//I8cJmbbjY+u0gNTDTPk+IfEVenhjqZjK/jWR0Cove4eWKJ+yU1x
	CSHZRjgD0Gc22PB1oZEiBoweHaAV3TLNmoL5NryBBpto2dVg9Zze7YKfWrRixUmjA3Gh6S
	mef5Gi8DHbC0NKPv6GuQKUjLtVVUDJE=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-930f4e5eed1so30363985a.2
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 20:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1787283693; x=1787888493; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EL37QOqkfz4M1rcSjU6ngbT0t5Oo/IwMsygbaYu8nYw=;
        b=UjmXfeHebXs/5yTjsWE2FAiVizBPOWla4IB+4lfvVVAYnrf8izpg18O8TPP4oGUTsm
         v6MRJrzFSjYt8JLtDBLEmcmiOD8ug099emPnR66k8TFenv2N5F0l5RCrU08mLUPbyGTk
         tdHQCoVppdszshLYr5mg9bdRtIkfCJ6yfBHScCFewEiwVcCHhQz7eSlqO9uWOLJF73ew
         k93G47QjslA0itaaupiBn44HV0Z73eug3170ieuuPME2P0O5fH66tX5o76cR6C3O60Ml
         XA0tneEg26xluVLUZHbg77bxMSM0IrynTCAWKXP+h+Q+p0eZoYwvw3dmhUbsxu5X4BWy
         BRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787283693; x=1787888493;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EL37QOqkfz4M1rcSjU6ngbT0t5Oo/IwMsygbaYu8nYw=;
        b=JBN1mF7Iumoeu/eZjWV9Dcb5fclnp+jbkzEFVsWJHfPLpplvuryZSaBAQ5nC/fs64e
         +iVD/W/DTNmq7EPWnwISdxCuCPtGz2t9D+Alx7xE+cNIuVT5W52uT6S9xkB4UGhHAKRH
         piDy4cH8+8QbMKJo7ClQkbHbUu/DNt2xUzuA8vpWMmwz65gZ8l+YKahVDtHdMg79213/
         xDLq+f7k8ONH8D3NGE1F19kOkJIq/U9tuv1dm/icozXyUIRMT18ZeEgH5LqhuORLP7g8
         nJer3pZlaz+98d5J5hAwHSGxOMThsCIJNQTffqjdzJb1JNK3MytlVc8Rj7a7ejHbhogU
         vEEw==
X-Forwarded-Encrypted: i=1; AHgh+RrMT+XKcyPS3b9FCpsB+/dXdzykxdVdryFj0xKChIPSpsA3gAxNnN3R4Py8M2JQ8KHfU2TaX6g0zg==@kvack.org
X-Gm-Message-State: AOJu0YwBQU/tl1GvaBPe8rqcEyboOrSZJA/HeIlH80SBTBQ6pzeDnrn+
	zYOlMD5OEaU+QKMr/gMgk6K2UoMCJ+uYhZdRIez8qDimVdZdvqUvXbl1e2lXRqCBWxLaOZEkT+3
	VWoMD
X-Gm-Gg: AR+sD10idDA9+iicPgAVdDqF7yovbqlPtsa1WnDt6icLxplsyELNNtfp3XQeUnGIW5K
	wFfBqSNaCSYVsxbHAm92pPCczlHP9sHs854onENTExK4aWT2A+83tlKoBam6TeApl4GRH90ADg/
	ke/qzxzODkVacyhsjbaUAnDSiu9UMwcr6kAFOzTstRqjTqaE1VdUPvVBHMSuOtU0yJOwYcRtJFy
	Dzfc2/L4hsDpw4O/RsNp9slbb+jEvRKFJUCayxrQ9W7/PwTNLpWuehLrgc7ekE+wdagxyYQYho9
	UgJiOTwVK5l7SCO2SB+cK4MRj3jicyfNLvZ1CeBHGIYYQEd1+oSIEa//qG1UwJntyDetwLXh6hA
	xviz+A+Of+pN9TNgAa5XlIxl2RBPajjIIjFrm4zQTMFFUml5Q+0xGn4y4cxhNS+X4g7JM8eYDpj
	DKA6/5XKFRyRQIqsTvGNgpXPLY24f2VoHzPdTCdv6AssIaI4d/DE0oI1T5ft4=
X-Received: by 2002:a05:620a:6f02:b0:931:4b6:a9e6 with SMTP id af79cd13be357-937396f3282mr286246585a.47.1787283692603;
        Thu, 20 Aug 2026 20:41:32 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9372fdf59f3sm234049085a.10.2026.08.20.20.41.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2026 20:41:31 -0700 (PDT)
Date: Thu, 20 Aug 2026 23:41:30 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Enlin Mu <enlin.mu@linux.dev>
Cc: akpm@linux-foundation.org, kasong@tencent.com, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
	yuanchu@google.com, weixugc@google.com, david@kernel.org,
	mhocko@kernel.org, ljs@kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, enlin.mu@unisoc.com
Subject: Re: [PATCH] mm/vmscan: fix comment logic in balance_pgdat
Message-ID: <aofI6uXxq4TD5QTS@cmpxchg.org>
References: <20260821005107.3416-1-enlin.mu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260821005107.3416-1-enlin.mu@linux.dev>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 9EF2F120002
X-Stat-Signature: fniiyomc95p1q67f7dgfpcp11zyd4h6c
X-Rspam-User: 
X-HE-Tag: 1787283693-123844
X-HE-Meta: U2FsdGVkX1+8Jfll1/2H4rNe5dC9qQaTZ66J2xPBZrI8nongductfXViupTWuUkE7ptNQutEqBcfBZz/XyZ2PkfRPuIzFEasD/qHCUF5CeAXvyz21SwfI2zmfaVWRpihKeLCEaDXA42VOCaXqMbM2bPsrqNguQrcY8L85acQ1ghAZkWAAFOJM1Ef3METdc6WKAJXKr+Ol5s/L7deT5YiYQJSWGPbAWE3jkXvETMuELyL3RKQNPDcQgCo+QCy+WvtHafoIDkGJTm349oc/vBuxXq6dRCsjUE6ct9RbrhoWGrFOSScZ0l+PV5pMkb+/cjfXJsmIT7zlfXucpmzrYCDg3i2uFEA2+8UT0dmAExyBHq2qktZQ/oQw18ytk7mY6nPTfsPoB/VjFSIYRsYBy8YLe9ORoDsXgpvh/oBB1iTtZNQMGz/HKJ6Zc6IEVwkgfhgesM1Nhy8qulbggrKIWUK3Jgz3bBeqSgRTibA9T1pEIaSxqKwUfY2dzXmE4ryMX9hKbUOrusuZpP4RIe2S2t2J8HzwvULHL6+3bRYV2maUGPD5CQ3KhCfemq6Z31QZZEIwPNjgIZImYUl1/uZ/6/27bkSGd+S3YsauVkRanyzQr4U1BixfL84uClcGAGa2y8Fynt3RHjp0/jHRWfSZF+GKo+Na4dtYxdjKQ98LGfCxa4LJC34+qe8AVsR1+RxHauxYgwkKh3dZFio7Wmr09HBuNROYdBMrVKnRlnfxq0HdXdDRd9btiVmo05M3rf/iP894DZU2UQJk5ShpXYlw+QlNfKpMRoWlM1MqtyzYY9sSsm+fxgRPSNgr+SA4t9cac6yx8KaaZBdKnrPyOZhclseNaVfgOdjB7bF2liwQYfEKxUBH1ecWMP8ySS3JuuC3ED5nVMBXmErz+YqdQRuDzj0RfwpmY1jqQu+DXCWO/8wq/nGvWF4NTIFLS/71JKFBqm8z2qIrAwPhGnr3rrBkA7
 EyGV9L1R
 8xdADlCm856hUBV4EGRlsFCWuqXLBUMtQwwMdpLkvwzUkGMn7bNRrq++i+++tA1IvLqg/COU3Z/d1bSGpCmEmNQefXeER4Hyg87JdR1/UFdvgPD8aeh+ACkqQuGkRFL5k3eW4Byf/RzRoWl+ecMrTXJXHpj1rZKCMylIysI4UmnZF3WmnAz/6hOYIdvxRf/N0WreSIjgc/Hc6NOlIVHrmZQAH/E5dgJtMLt94HfE0kiM9Nhlqzcwj/vjO2+mdmkfBd92F/Z+wQVq4BOABWWH7r9pmNYNNYMzhDr1RNs/xzrAoCUCwfY+RIDoDgHle4kcRU8Nz/xA9CYDE1Aj+ezbCS9xZwYjQjn0Gmx9HfUi9014cuShCrk0GjjvXw/0vNTvnKVWlobAEGxhw3x6QnSEQjLKwuQ7CMmqvfAmR/MRdUHG28NXzleViYEAEkbzCVaN7HHPxLxqPba/TbagyAhOQwI5ljg3pEpKDlRBEB2oAIOYTi1CqrmLO8qSQx5/BGnlyYPivME6OgV5T8XQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 08:51:07AM +0800, Enlin Mu wrote:
> In balance_pgdat(), when the low watermark is met, processes sleeping on
> pfmemalloc_wait are woken up because they are able to safely make forward
> progress.
> 
> However, the comment incorrectly states "they should not be able",
> which contradicts the actual code behavior. Fix this typo to accurately
> reflect the logic.
> 
> No functional changes are introduced.
> 
> Signed-off-by: Enlin Mu <enlin.mu@unisoc.com>
> Signed-off-by: Enlin Mu <enlin.mu@linux.dev>
> ---
>  mm/vmscan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 35c3bb15ae96..822f73758c42 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -7188,7 +7188,7 @@ static int balance_pgdat(pg_data_t *pgdat, int order, int highest_zoneidx)
>  
>  		/*
>  		 * If the low watermark is met there is no need for processes
> -		 * to be throttled on pfmemalloc_wait as they should not be
> +		 * to be throttled on pfmemalloc_wait as they should be

Pretty sure this was supposed to be "now" instead of "not". That would
make more sense than removing it, since this is about the watermark
check after kswapd has performed reclaim.

>  		 * able to safely make forward progress. Wake them
>  		 */
>  		if (waitqueue_active(&pgdat->pfmemalloc_wait) &&

