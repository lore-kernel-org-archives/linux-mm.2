Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4B035F01829
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 11:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F286B008A; Fri,  6 Mar 2026 06:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96A3B6B0092; Fri,  6 Mar 2026 06:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87C3D6B008A; Fri,  6 Mar 2026 06:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 771316B008A
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 06:21:11 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0C0E21B7FC8
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:21:11 +0000 (UTC)
X-FDA: 84515396742.08.9E520AA
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 19679160004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 11:21:08 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=dSZig56t;
	spf=pass (imf08.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772796069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m66Tu8cGxsV2zbhEo+WRe9HxhVWQ3WHd+YUbh24wbXU=;
	b=ZyAqvWAPmAICkoM3BddTxSIfl7E7HyroAhjdMIJHw12iFig2j6PBjFWkiw2Rj9rVf6wZUH
	n5EfiNAmhKZlrZakoBTqdFnNdzXWPXKlYGW/0mMsNm+7fWTx7DmryxbVPvTGt7ymJcgKBs
	7HY/ozajiRNHJxDghWBPGzAqPq1Amp8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=dSZig56t;
	spf=pass (imf08.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772796069; a=rsa-sha256;
	cv=none;
	b=d2ARgiejnMnl40VoidAqx6YkFXK/bSWC8qAuv46uyWW+zis451wgplGg+az+88IErRE1Ps
	FdWznPSo3yVJ7jix/mMhGnmFpcyHTPcrqJPN6GdEt5Gb2cJd8yUJ9jcntdEdstE10f+Zfo
	mSasJs67UvCh1QHpOXG8eJpCCFA9fNs=
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3599019ae92so3012218a91.0
        for <linux-mm@kvack.org>; Fri, 06 Mar 2026 03:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1772796068; x=1773400868; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m66Tu8cGxsV2zbhEo+WRe9HxhVWQ3WHd+YUbh24wbXU=;
        b=dSZig56tIpocS5PGsDUe3tVWalMwSX6umIT06c7ubirCpSnW+CyPx8ewUNlDR44f+R
         k8505FLEWQI60hPkfv79xLrTr93sm0xXbmgG87X20D2+I9fJKnzxtKtKZURXQKGwBSCm
         SgcJpAIEbfvhuT0pjbtXmP8XS2AwOTDqUX+UFJt+jkKli5qP/CUIPa79Pj3zMJFm2JZj
         nqEdclkYCOY6FTKfIEyM3UFZ2Ua0gitdx796ZXj7gefnM0z82Iskkv9HPIqPlB5XpPCM
         IPfhUzP+gnmmuiVVUVnUh7g1Rqy8m16KkyDA8yDNBkQNpxBO6w9qR4CoH3tVzeuUJ1is
         0Cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772796068; x=1773400868;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=m66Tu8cGxsV2zbhEo+WRe9HxhVWQ3WHd+YUbh24wbXU=;
        b=uXkMjEij5JhWHYLFRj87aSGyqnRzYeGOwTBil7eA5wOyAb5Zf3AH6qUYBL97L49tD+
         0oe8eC6fac2Upf0qMoY7nN/plKVG94hCBUCZCpLE7hzws7fEdwVx4qwUPIejjN6ILsTE
         49htXecDXOM6z4ZiMyLgF1krwaMr5YUrOIgTuDGWrRqKHZA5CbLBaqXUYURBRkT54dkb
         9dbdiSOp/8jBtS007/r+jLXiswMRUNOivi1uJ9I8s63iQa4PxQJHxU8wxfhmQxMUpU3o
         yYf9ng3WAljZfK7uDhEfbDc8cMQ8+1x2WYa9acCUtZWzPEV8S7pqdqIEpFT5U04N0KoB
         RU4g==
X-Forwarded-Encrypted: i=1; AJvYcCVPewSjLJvksyLJh1zoaBw0JhX7HGK+7VLPjAKyLdF3CxXPXbDGGyT4LWUezGAYx+FGRev9p+6cLw==@kvack.org
X-Gm-Message-State: AOJu0YxWFjt7wR78CmDa3tQwCxMm33dJiMsAsb+8rYCTm/QoRb6oCbgz
	WlHZF5SB7JLZgsPL40jtB03OgpmH7PLYFkeGX9HRma6JFnY0blhqtoV7JqncYqD1Xks=
X-Gm-Gg: ATEYQzyCPl0LRSbRjbjYymP37QAEZaKsA1cgOH7RAk3fBi9Jwmi8b7MUQA6uJJaxx+d
	MprNd4GqghiJAW/GczwXfAInX+s3Mgytpt4Pyw0VfcZCiBPT5qrX9tkdfWXN68f44OX34eLgRST
	VTf45NkYWsRaMi1jspEl2Fr8OyINOl3z5TvAN5yhsnEI6MlVIj381X6Ljtom+A514pZ7q1GwYtJ
	4qao7LbcASPMRGZOXUJUSIEUCIzuzcF73fTmye4qXn3of+pGmBogEvR9NJIOjCZgtROn3uml3rj
	QMHAhSE+rH3QBjW/D/mN4Ps7bjEuKhC7+N/4Tr8EEYX+s5LBKuVsLp+zV86EOJVPnOzfGRQVkac
	BWvIb979tVrt71s+xGNz31LzJkoYf3+r8vGFTseTHT6Wi4upAHQ14uwxmQkAfN0qhH1OCyXmfhr
	oK5M5Ri3nSOcCBFbDtUfc+dIKPAhklZ2RW3Lec
X-Received: by 2002:a17:90a:d404:b0:341:134:a962 with SMTP id 98e67ed59e1d1-359be31e147mr1602376a91.28.1772796067911;
        Fri, 06 Mar 2026 03:21:07 -0800 (PST)
Received: from [10.54.26.107] ([143.92.118.3])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c739e195c40sm1370526a12.31.2026.03.06.03.21.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2026 03:21:07 -0800 (PST)
Message-ID: <5fc45c96-d466-442a-8323-69b3af583cfe@shopee.com>
Date: Fri, 6 Mar 2026 19:21:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm: shrinker: introduce new function
 get_shrinker_id()
To: Qi Zheng <zhengqi.arch@bytedance.com>, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev
Cc: muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260306075757.198887-1-haifeng.xu@shopee.com>
 <20260306075757.198887-2-haifeng.xu@shopee.com>
 <61cd204c-4c1d-4146-8728-bd315b0c6617@bytedance.com>
From: Haifeng Xu <haifeng.xu@shopee.com>
In-Reply-To: <61cd204c-4c1d-4146-8728-bd315b0c6617@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: frykz1yi8wa4tdz4kcrcudo8u913oq1f
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 19679160004
X-HE-Tag: 1772796068-398878
X-HE-Meta: U2FsdGVkX1+FLCNMmWuWpT4bP4hnX1RjkS8j8qB4GnOB1WQyih3O/OdYdit46WgotK26RitU9Nc9+CJBOrjSrWTXRVBfqJw6i9UFuJMS+J5RZ9nueXKzNSunagZjhN40w1belz9edTeG3TFvfrsK/B+QSdDaGuERjLbHFh2ZSRjlGbic7mVOxhCinrXJ+1cMvqZgu5bkqVkmp+LI/JXQ0hPeBeyIJWdo4Hntn+i3e8y41ZELu01+i82BNtcyCSOBawD/80yp7asDETWXwdmBoWPBJK2hCHc7X0+wkEgshvVy0zaNPg+hKZApTK7I6uyfTyqt6Op+tikdxNrDCj1H8BG/oeW+fP29navBm7NCBBu99yrrL2pd91aoCs6C4jPngW3AiT9aBtywA2fO6Sqf7AaQVM05c47ycCbkXkJKDBnoeSZBFhlUgKIKqhs5MpY8LuGW83d/LRwYt9u09S5wnH9SqMM4utAD6THocNcolfWIzkD23aVQJcAPZKy4WbLmhk0OFgVwNet1lqOf1tvijJDun6QCN8x1dCvDgX6/Ldx78+C0UEE8ceNplejBFoXI+3WgQrxcjEaoeJa0GLO2px48arpqhjFWLst0CwR5FrKVbKIL1AEVJ6LclBRVVE3g2FfgnSxQPr0LmgQ6s908GAuRqWhykpuKR0JrwAUh2FQlJVWt1Qefwgcer3Z/8d1LoYO7O1nYjYAjxb73niKE22DEjeomkOJd2di/6Ej5uDjv6zpQYp72JRRbOZPXhDOMHg9QonWHkLgoIniN+0NAlWsrA/8mApMm63jsJH+uYTeTkTXhSlq8fuN64HoT8weDNv84u9i+Fde1JI6ygbsbed/X8MxqnZc4j3qE9n1qV4OzI5ZXqLlHvMZW32GOI3XBUXWnMU0sD7OR9UNkNEvlRQbLRB7krlFn+fDEU8NE34S6bY/Rt7toE9xjJflBN6xRu9UVJ0OnIhRmltTGbBC
 +F1q9sXN
 NGBfPaQPI/3Y8RdJ8LrRQ1E/5W+dBclwGJS1ou94/UrtO3H54/PevKhWOhKhBzWLGaLGhDz0j8Pa2VHPgGympz86gBpX+pScwQNOt+HPutXDSdnc9SbEzLD24bx+SeEEhA5I2aAq53b91qwBVki0PkbJYNbI3gt+kXVDxNrTWcMUGWOjE6VmB0LN09qJRk/Sk1d2P3/VsAEuthSu+KWa4KuzWlfRmilju/IIptx6AYCzL3c0w0ms5FNoDsfmYW7toZqUnIMP2HCCcn0CCv358Pedfzgf97IJbu8UnCwtBFvhpsRU1qpCIZG25HNReJr0r9jj44VSQ3Gi3MwugUC2BWmAkLU/2FrA5p8zTFSAUbv3WE6DrEr8Xw3zd3cGoYeEOdbu3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/3/6 16:24, Qi Zheng wrote:
> On 3/6/26 3:57 PM, Haifeng Xu wrote:
>> Use get_shrinker_id() to retrieve the id of shrinker. No functional change.
>>
>> Signed-off-by: Haifeng Xu <haifeng.xu@shopee.com>
>> ---
>>   mm/shrinker.c | 17 +++++++++++++----
>>   1 file changed, 13 insertions(+), 4 deletions(-)
>>
> 
> We already have shrinker_id() in memcontrol.h.

Yes, thanks for your reminding.

