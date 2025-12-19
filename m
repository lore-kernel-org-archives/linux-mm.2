Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38295D74965
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 08:41:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93C806B0088; Fri, 19 Dec 2025 03:41:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EA146B0089; Fri, 19 Dec 2025 03:41:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F6376B008A; Fri, 19 Dec 2025 03:41:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6ADF46B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 03:41:13 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 23F5BB9A6C
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:41:13 +0000 (UTC)
X-FDA: 84235576026.14.09C842C
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf19.hostedemail.com (Postfix) with ESMTP id EDA8E1A0015
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 08:41:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PMdwFh9i;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766133671; a=rsa-sha256;
	cv=none;
	b=SjxmLdO6ocnKi9xACCGxOb7jPM+wNK4lhq2H2jKcLJ1ibo4NEnFYfcYI8BeTcpmhr4Rtj3
	nWJI+ZXCARhYMDETgnkBgyvo3heQJYq5LY6/c2ypzApjL+zocx0kf6al1rOlckrGF5ERcj
	saQWKq7zLiVYdgMzuBchQ/e5lROI458=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=PMdwFh9i;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf19.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766133671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sUHONLbC5JmfhuQtv7hxDSLeRlsmZ7DLJDoyFpcnmnw=;
	b=KMzxvWvRXuHjWzYOixni0Q0nRUHaaIHCCq2i1dQIGepsrBBKh5eXCoyrhWv0TUsUWJDS8F
	NVyJ3yH5TDxSdI887pYk2EbV0S/lci8vKX1HM690NxSKm9aGVeu0VLeqhkLTOe7JxK/YFh
	cwzQ9TImUgSu5iRHN2AIg56OEvylQ3U=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477a1c28778so15766755e9.3
        for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:41:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1766133669; x=1766738469; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sUHONLbC5JmfhuQtv7hxDSLeRlsmZ7DLJDoyFpcnmnw=;
        b=PMdwFh9ivd44EPI5bfuS8eo0P5a9AC3ESibX/za6BMVVNf7LScWdhAOt1BeMSEP8kv
         LbFdF3lB8DIxciaEOd7YwKgnYDSaoYVSuobFgshklOJkio0oRRz6HwGd+F8ps5wOtBwS
         l2BoCbdl4tXUYJ5BAGtapeeedHrQhxeD0HbtVg5xC0QhBe9lPuJ/kL/UuBzhGI8CmlBZ
         0Q73GuVkcaFVahyLgIu2BaJMpMhvs9h3pVHfcTzyulrzX4vaXH1EgsSThYSCWSUIhNBg
         TzzYl+Ab29l0BUk7WQXUf68dYTAUrJ4uV5XT8FjrU1PTrOPa7WMwaScgl0+zzQz2tfZ8
         BHbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766133669; x=1766738469;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sUHONLbC5JmfhuQtv7hxDSLeRlsmZ7DLJDoyFpcnmnw=;
        b=eCpaVZM73fgZqdVoFsaPgdD8dYvdf4mIAk8SFzQcQcdEc6ixfta/vvQdccb0JDIvrr
         wE2nAP1TWL+Kapp1/+cyXgGdYy+8uehwftV/9YTpE4rZ8iTSIPJaUhHudyh6RLtX/Gy9
         r2dQZo1hkvxGqvD/44eGfH2WwG1uYZjLt2y37ue0rP4yDwW4ElADrXlI4dm8CsRTm+57
         5+hMWIIYmhLCk/IjCYKC6WeWjR4MKB9aqfHj4i8oGGpeEuU4/Q511BFx1ICauIkyOfE+
         5i15j2MhLU2hUUeJyXLZaCMhyyL6ssMY8+kfEUYCRQW2IMy/zXxTzMX8ayoitzpfBdkH
         toCQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPG3FNF8OquO/SLYUiwFYPFqvoekLxJRPQFQqkAvdUWkS/wcDN4f3WrlBlzda24AJCMuzySSaI5A==@kvack.org
X-Gm-Message-State: AOJu0Yy0JT/dhu2DwRZpo/GOIEgdHrmTlowmpmHXT0aZX+Fxdn0IHUZY
	6bpyLBV49IuguoKZnIWIxVtEg8tdL3fVsoIpAt3zlXTNCmRv3TphD6/snyptgWAMA/g=
X-Gm-Gg: AY/fxX5V/fTAUpJhTodJwUfoPshKjq7/HFlCqBvUQ2U7Av+D3Ru37FTO9ZcvkKFX1sj
	sAfoRL9PtnAef1w9xZldDlTCgjMKcBVueFPVOJ5Zt9DU/JrdZBMfi/xPeqrmgNfltAxdxjU/TYO
	QgxIm5mRXaweZaPxlWgioViFwjghG0CCrn7xy7rsuIXcdqhy7muk5dY8uob9xUbHQ9GE+99fA90
	kcTXlHeeDNiTw7qhgLLHnrAj9Ihp8rNSGZA4t32vgnbSwBGdkuEddUj07wF1VuLtnqUM66xOUBx
	vnz5SO47S4LwQUzi+g0qDnIkYf7N34ngJVvz6JdhDo2v8+kZHbJB4Mj3R0Suh6bINg3MJfe6QiX
	UEpTqSiKHXhzWUy6WCeeJ0/jwgtKnygaJR085bNjdscdbcl1JPRbPK+tSt0yD0ueSqy21JUX6ze
	05hLBQghJYxJhp9sKAlB7tF5mIDomDDViPpFo=
X-Google-Smtp-Source: AGHT+IFcYKHJPYgcQllNij+gtuh3TUFyMdvjko5VxckTTrIpB5QdDmLRz7IVikid/Xpypc29wtbmXA==
X-Received: by 2002:a05:600c:3146:b0:477:af8d:203a with SMTP id 5b1f17b1804b1-47d1959e697mr16323735e9.27.1766133669362;
        Fri, 19 Dec 2025 00:41:09 -0800 (PST)
Received: from localhost (109-81-80-251.rct.o2.cz. [109.81.80.251])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d19346e48sm32499035e9.2.2025.12.19.00.41.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Dec 2025 00:41:09 -0800 (PST)
Date: Fri, 19 Dec 2025 09:41:08 +0100
From: Michal Hocko <mhocko@suse.com>
To: ranxiaokai627@163.com
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	elver@google.com, andreyknvl@gmail.com, =osalvador@suse.de,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	ran.xiaokai@zte.com.cn
Subject: Re: [PATCH] mm/page_owner: fix memory leak in
 page_owner_stack_fops->release()
Message-ID: <aUUPpBDSfq82Wdlh@tiehlicka>
References: <20251219074232.136482-1-ranxiaokai627@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219074232.136482-1-ranxiaokai627@163.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EDA8E1A0015
X-Stat-Signature: 67gg9kex8idamu7c99pu3u1ttng4xfto
X-Rspam-User: 
X-HE-Tag: 1766133670-156599
X-HE-Meta: U2FsdGVkX1+ZuNIGuFO9pKs0rzTvUxzU4jDX1nbbi9ydkHy4Ihf5wp3xLIM9LvMHRGhemlZ8uDuNa97x9454pyEjUqfmHCt2IEeus+1STV4Vdju71eTInqEj7xXVejfA1gY8QMhAl2kbLzZzDZidvBgKAy7G/3QYX5owMjS/Z4lcR2oHhOYoW7CAuhAD5WRwGsJhbwivaJJn5/9WlLuTLOTHYxaWQX+G952CuYMA/dOaXHMQU/0KdCmFT3T2BQ7EbZJDpoOR+ouieoPqSz1xnHTylkAmQiir/EY7e7hYqP5Gli6Mn4vojRTncRXzcpsgxBK6Sy27T7tNSnlyZKHLwyuP+QjyXWc3XUSvpW9jPFhfFMsUw5YiAZJEQTT9jaXRtJzv1lqB0W2eFAq2blNI4/BF2Y0RI/Cs9rlceSCq5nX/vKvtMRCNlIg/mHNE/IpM9ZOsxXV5lNBtBewBawcmJ/Qm7DygwKeG/nico2fTczFYccjs9qaiDQNzwfc9Rnlf13llsBgxtg2WFtMO4NdMr4kLE7XKkvI4YC7nV5KVi9U3gR/Jjl1/T9wxAuPz9MLdxcGbzBuopwl5FY3ZYq2gYFuFkPOFZbw5sT3oPHoTpRbti64r+uykNxs4WNx67bRSsbXjY5HrRu3Gi+XSWM05/W64PPXG6g+dSdCBKtg2rI1uv0ig8qFaIztB+pYFzP6XlZoJKrJwD44lrJtsubJI+6U5Ex0NWy85CFCC8X7o1rt4HzucGQDSLiiu29KWqS/vI9pj2O/qqHILGYocu6jsVTyx/l6IOs3HkeIc4qmWO7nMos/n7berP5KmEbt1gQl1TWNbTZwT5Iiy3LHXrJa+0oaizLl9VarMc+ypLSnVeAHccxv9xO97DvOCXnyKF7KB6X4Do9apgR0yEvas9hOUvLjUtsPMVHmpRVWC2EM98nhSqSyJ7HhO0iT4y8lw3kIfSPr/4YI5pbBgPAh3eJv
 Wk2RAvCy
 x0S024MwyefdpOiDluXuQ/8VRUhXojt0kMXXViTDqXn+UY/1shAeKB9j23Eu/muaISKY98EyGrue3wGASgG0qrxleT0JzZe/W4NE4zm+gb6b1UGs7RdC48jYRN7bZ3qT8cCJqi7Uz3e6oZfcL6Jn+aSO61zmWgnRp+aDCgebFIHFntLnQAlNk9QsjY+Qf/htgXk+JrTqUtReStzKxa2TCYQny2y8PcQQjK4IrShjpUC6YfWUJb+dF0HWRqtZoDANAv7ieZhrzBv1wb6Y6++PLWeK2A7nftHpbMZUT566PiwRBobnPI4SdxvqbdEwM9tNlP4hak9nJ47u5w0C5c3s0eTru72rgxCK7ycoRebpEaydi8z67vIfqmwXBiKW4rMt1qmwlM+HFd6HeueYavjZLlw0U0ZGh5fFfysxFvfzVJcSQmNCI5DvqrYLO9dxIYeJ1XBuSYupg/g4KRm7av4sctiMRrFGddC1zPL6RosjSz/zeWK2qTsfH95qxh+aIYh5qr1BGZ+vGuLctQIY8bnCV40YVNE8/yg0m26BQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 19-12-25 07:42:32, ranxiaokai627@163.com wrote:
> From: Ran Xiaokai <ran.xiaokai@zte.com.cn>
> 
> The page_owner_stack_fops->open() callback invokes seq_open_private(),
> therefore its corresponding ->release() callback must call seq_release_private().
> Otherwise it will cause a memory leak of struct stack_print_ctx.
> 
> Fixes: 765973a098037 ("mm,page_owner: display all stacks and their count")
> Signed-off-by: Ran Xiaokai <ran.xiaokai@zte.com.cn>

Acked-by: Michal Hocko <mhocko@suse.com>
Thanks!

> ---
>  mm/page_owner.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 27d19f01009c..b6a394a130ec 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -952,7 +952,7 @@ static const struct file_operations page_owner_stack_fops = {
>  	.open		= page_owner_stack_open,
>  	.read		= seq_read,
>  	.llseek		= seq_lseek,
> -	.release	= seq_release,
> +	.release	= seq_release_private,
>  };
>  
>  static int page_owner_threshold_get(void *data, u64 *val)
> -- 
> 2.25.1

-- 
Michal Hocko
SUSE Labs

