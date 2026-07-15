Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A96F9C4450B
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 14:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A752F6B0095; Wed, 15 Jul 2026 10:16:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A252F6B00A7; Wed, 15 Jul 2026 10:16:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 915FF6B00A9; Wed, 15 Jul 2026 10:16:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6C5866B0095
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 10:16:50 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56D45C0118
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:49 +0000 (UTC)
X-FDA: 84991212138.25.CC9F2B2
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf06.hostedemail.com (Postfix) with ESMTP id 2375218000A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 14:16:47 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OaKyFp8x;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784125007;
	b=nHbS6djbJJy2fXKQqAq6u+b5tEr7J8femHL8En/ZgYAWJMtTu+P5Zqzh4hnIfAfrvLOvH3
	uR4UHN+Tb8rBbhH9JYS1kXFTU4wCgVta7Imj7YVkYFXOd1AuEsYn+QSFIegFzzwAvx2ML6
	T443NLrC8SLwGZ3J5jAF8fejmypySwM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=OaKyFp8x;
	spf=pass (imf06.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.128.46 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784125007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1MJNOxKF1qvbceJ+OqaW7oAQYVVR7sf9h12hLrWd+LY=;
	b=7wPxKdH53MAB/7angILNOiCeKHoXVqpiznI5bGa2TyipIXp8bdiV+5mLAyIHs222u84dc7
	kLzguhR33k/w53uncYcV8xuagwa1fVOGvx1vB+cKqou16jG0ijlERhVfclikQvrKZwDYiN
	9WD5YiD0oqUc2FAsavr77JJzkQOz0/s=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-493c19bad03so49230485e9.2
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 07:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784125006; x=1784729806; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1MJNOxKF1qvbceJ+OqaW7oAQYVVR7sf9h12hLrWd+LY=;
        b=OaKyFp8xlitAHLia9HI6DggqYBl+QsJdVgpAyyMgCPMQkSJYLYBn0+1XWXgKha594a
         g/l4ez3tTsMwDD/6KuKxS6ySeSmQHkDFKLCs/bjFMvtgvyvK247qXQ7FcYUnBTk2yjmf
         ZQv/R/3Rz9hHFTWl9hyP2SLKq/QWk2NKZKK/uKZMvNh7YaMpfD3G5G8Sy53molytE7+v
         u7lncWdcQZkN0vGsy7RWb3guhIBJdA5KiGFPCr2C7kOG0XmbLby6gmqlYi43ajs+xXvr
         aMY8Yt02xxyWbYdIsGlWJIrVmeXfh9ypJP1CKBnGoKdNmxwFAWODW0ThNMGhJ7u4lTW7
         LGlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784125006; x=1784729806;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1MJNOxKF1qvbceJ+OqaW7oAQYVVR7sf9h12hLrWd+LY=;
        b=ZqXKZWeanxfkdOvK3sMlFsu1parlq0DV6Ez7YlontsvTzBjs04xpouamkSLGBbSC0i
         CbmalwiQQiHk7U2w592BbvqqDjr7hm5wR57MiMHj3tGL0v1UPvxY0UKDFa6fwN6XQA0d
         Emp6ZuAQdL/0UzA7ubsDZ9X4bDvcqk8GeMinfQtf6N4MFh2KHG8SBbt4/tTlDzLv2QIw
         aqXbuwnix1/9wLFgjdaD96e8jSHVFHIJ5vaCeKKMFAI+OZuw8ndN5rD9Nu53VHFBJ73r
         5QRbVN5NI4KAIh7XzEOWBytGvD2Vg2TR0FcH1dgXQDUrlEHgjLEiE7qWeQsKDZZ/df0a
         3pZw==
X-Forwarded-Encrypted: i=1; AHgh+Rox8aKGwDZ0ILi3Mk9imvhmu9ZaFhCxDAjYTWo/5t7E+Rc7+sVSrvB0zjVLMQHt9rvRgspC/faswA==@kvack.org
X-Gm-Message-State: AOJu0Yw95+CrFMmdMaOZjVgha+ZziSTUSRcnd6t+BX548C4FYnjBCE+J
	AGIfSkCFgVaEjUheG2E/30jX+aVMacNb5e7ZH2DquWPwQmDNtWdGqgu0I2QyYhAdB9g=
X-Gm-Gg: AfdE7cmIIldJFlt9kpCs4oMa6qArQgCwtop6YlSj11+t74XNCB5X3UgLqE8fz3Dktwu
	ROed/8eTQg9xH48Zv/bBkH00zCMtpFa6spPh0e5Mf26+y7M60+xF51olNUR1MFNFoTN6OZhDAMC
	ycl5hYrv53kp1XXviVEWv7ujZYoj6hFmTqEpUppKXh/SbcYOChSS0O91IwecU1CtQ8cyF2mXbkQ
	RwOqtDqiHLkGYQEEhCwLeEqFdjh8TKLqi9UlKpMuf8ReIaKGtURmyWYc0z+sF9H3o6NvkLc1MAr
	FQ+cIEIB72QwwYjHmqa6xW5s8TV5P0+8c4xnEjgIFPd5d8m1ON7Kfts7NPbOZsddgtsD8cwCkw1
	i+de0xq0GPoY8Nf3e0GJCN8LEn/8yJbzL2VH5DmMD5rywnK+VISoyYsz5+7qRD1w2S8UIQszI9n
	vuwcwa2G7yzVCNeg==
X-Received: by 2002:a05:600c:6298:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-4953c16458emr36915115e9.13.1784125005577;
        Wed, 15 Jul 2026 07:16:45 -0700 (PDT)
Received: from localhost ([2a02:8071:8280:d6e0:1353:8eb8:c84a:b6d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4953c6fe0c6sm53336375e9.1.2026.07.15.07.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:16:44 -0700 (PDT)
Date: Wed, 15 Jul 2026 16:16:43 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <20260715141643.GQ276793@cmpxchg.org>
References: <20260713163443.3562378-1-usama.arif@linux.dev>
 <20260713163443.3562378-3-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713163443.3562378-3-usama.arif@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2375218000A
X-Stat-Signature: 64kgiube5fpe14sbzbr7msnr61sby8ds
X-HE-Tag: 1784125007-625925
X-HE-Meta: U2FsdGVkX18w307F30jMRWZmDU1pljk/HjQhmEdkGB00iUGTEo+zCo0TiinM/aoGO9lOeWJlfw54NM5sqBQHJIscS6N9hThiGCKi1Jsimyy1e3bIolRSHqTAht/8VVvxe0Mbc8fyTSSCxerOY4dE2OfujelML2i1X78KG9oen9wThNTRpXmGMOh9/URTb9fk7EHgl9YbN6RQhjcdpY0k9OthPywHxoC9mVMHKr2t266n9ERRYqMgruNffG5BS3/k/A2ZDl4OM7hkY+68O21mhQDgn+Xi9AJhEipQ7l4jEKnxH5F/VVmgy29xG7lLUsp5/rsPu9ZxyyLMZ+/PZM5ukY0bT5wUZWRvQrTIpLi+Qzp1bMsO+nZ5BQ1/3/rdCJNQxu+0gFPx3nINn5yWTApns8y6EAE67s4sQa/pVS728yxOLZ7UbYNj69vL5k2PLtgojGl3tDSbKDk3pKrMqB7ldtS5l2FZh7mGiL2z7yb7ZiVDKZuRpYycLElt8JvUQ0aPo2vheOmGU9bodXtdNQ7TY1wRVHGbbCne+8VSdzCdnkWP/YE6o58oJzGkX/uK6G+GKN1DP1ackL2AQkFoRuXw49J18yveB2gsW6wLYlpmqI6NdSPLWXp1wLiA+IKbEitnnilAhdzPhZeKG/OYmysp0UXUBrh8yVUfB+lrtDGskHMvVwVuYRmR5I0V45WGqY5nbkPbO/jEWtv+DZC1AMEwy97HWzqWO7rPQjls7vSotYRXPk4f082QWIpXxIkbhJJCsZ94IOrRE3MCTh5BEybC1Nvc4ySHZXWLzYuorxOX43VWnv6MqD5G0oz8sAOb1yymeHye5gUgZctpXptiCwrBrESQyl8UMVjaTK5GQzfXZpeWT+k4TEOFsVcPX7XyrO/v6/+5Wsrn8lyf567ifOosen4xZwuNDFcMXt+qav7fOmyi7QyX5rkb+NkkpnsTJBu2va1AvSw6Fo+CK3iDANn
 mNtdhWo7
 /14b3kSL1FXr8UkzZ2WbyAnX/4P46IpyTxnx2Eh74bzwItQ+8W6TZEpwrrEaU89CxAgu/KEJkHPPzh39+aoKD+JrvN2JzMjx/9VKliqPcPCPlPkDbMuX7od5HG2OHxmwRdSKsg4TR8AmWhFYJr99lyvB2RBKizMq3D1POrcYWJ+W6k2esSrwKERmIhUpuGJ2KdqwPomEL9IEkn1qjCNebYs8sUZA+bkDPVPlEdsXbeum0AL7f0Y0SzjfIWiFCtreZlp6pS1KSdrOEPvjyu5pY9L1ppZ4tFGpi0R7XtD3tgyajXzi2lwD65kit3i5iGSK4a/t5MKNrpqGI60CyChlJyAuzUnBF0DT8co9Zv2gWqJhuC8825nwScpVJmC803N8+NeBMWUru6Mkze0VjWX6HLGbrX24tf4QO9vGNu+aq9wK3wQ7nRrZi0tDiGzumGOCGgezCHEY4F0ymrt4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 09:34:17AM -0700, Usama Arif wrote:
> @@ -323,6 +323,10 @@ enum node_stat_item {
>  	PGSCAN_PROACTIVE,
>  	PGSCAN_ANON,
>  	PGSCAN_FILE,
> +	PGRECLAIM_PAGEOUT_ANON,
> +	PGRECLAIM_PAGEOUT_FILE,

Reclaim generally doesn't write files (anymore).

You can use NR_VMSCAN_WRITE for the anon counts.

