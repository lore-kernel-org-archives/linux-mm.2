Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5BEF8D31A0E
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 05:36:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA1B6B0089; Wed, 14 Jan 2026 00:36:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777B56B008C; Wed, 14 Jan 2026 00:36:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679F36B0092; Wed, 14 Jan 2026 00:36:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54B5B6B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 00:36:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C3E041AD97C
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:36:44 +0000 (UTC)
X-FDA: 84329459928.10.4E89FDF
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id F378A180005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 05:36:42 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbfRN1a7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768369003; a=rsa-sha256;
	cv=none;
	b=r+G7RMYG5WBXx3oDvig5GZgNbPYFbWntJq+8tLvrvynX/LmIDuGpOkso/4TVuSYdz6s40B
	TjuUXiZFDsMLXUUsA4hNtdExc6I9ZBCDfLZ3KTK+GFyZE1hZ1gTAkF37tDhqnN0CsXD41K
	hSrQirnm8vfzz1dUvrdC/jG3dQ/sIRk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mbfRN1a7;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf06.hostedemail.com: domain of lianux.mm@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=lianux.mm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768369003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RdIivE2ldlrwLIiUkZ/Pij3yXzKqAKo3oC21HuvVTz8=;
	b=xarEyqBvon952Y4wXSyMjgys2LJ7flTJDmq5iyhARvo0tMJKoIMjgzgzOBlTdSRxqStwbu
	72OehjStVL2w5zVPkk+pVv/H4OtCK2zS2yHFgeRHEMWUUbsYofECv0bp+zXA2gobSylUSd
	XBFruGZRTEQ7/b6Q5iDz0W1AusX1RKQ=
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-2b04a410f42so7415396eec.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 21:36:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768369002; x=1768973802; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RdIivE2ldlrwLIiUkZ/Pij3yXzKqAKo3oC21HuvVTz8=;
        b=mbfRN1a7hxGm6l5Btz7hF4qpF86U3m/y0Frth/RujL6rBwxjuxeA9b79D9Ftz8ueK0
         Jeo8914w63DMQK6voW3iiVfpFKmf9tKdc2hWuK2W0lrBdayxGLzthpMR2Wbcd0BFNjCZ
         yMiE0aBX3b3N+RYc3dCrg8OJXqhDy0cVO3qERVD673RQ19jYSjgM2duoguTXpJqP46iF
         2aIQ5RTVK9n3sEiUQOa+5GFqaYwwHtHYmRsClk0RW9c2GYPh0e4eKT5d4xHI6empmj4Q
         7w+ZTzuzja8tEiRszSuRvFD7c091oToY/bidREMZ4m40ijucwBRaYtYHivTdIzE8ZOAc
         /hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768369002; x=1768973802;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=RdIivE2ldlrwLIiUkZ/Pij3yXzKqAKo3oC21HuvVTz8=;
        b=IN/UL8qibydrB1GlGCYwHhDMaUJ8jECrIXqFm+XrsBHmcfYFOcbM36Ahj8NbAIhopp
         Zqz2x9/RYKh2rLI8PSbExCM1vCbxmG8Y46IMcmJH+I+KEFYCI5FgWMZ0RhoCJAAEZEYk
         Fvsk+hI6MAOPZPGlP96Cdhl5zwLP6Vt6bDboa4SJ+VFQ4rLcr4oU1C0dB54hn/CyXOuo
         X0Gr8TfS94uW1uSfqsApcWpwa/FAHpZcqmtO9cT3fbmh21f3GcfCX5WHiKDqRGZeiZcQ
         R+d2/YNhhGGHy+kGQtLDis8AHrLv465DLHhq7jlhRtEYeRBcHq5Ve9MXrQAeviLMa8HS
         7JHg==
X-Forwarded-Encrypted: i=1; AJvYcCVgL2S8TkR7xklm+aV0t64qIHp4vGcOXjbyS6nseUs9jlp1PSl13kt9gRzNYwmTcjG94Rwzjw/pvg==@kvack.org
X-Gm-Message-State: AOJu0YwnjRtXe6burOAPS3XZw2XDG7BYeQ6wrb46g8hrORXwEEEBXAiA
	lGVnbqH5hglQmbmvF+2ZKmmM3Kz2VEAA1t5iVWodauwaI3rmci1lJ4df
X-Gm-Gg: AY/fxX7u9/KjvHbBreCsQKrBOqPtnlY3e21Rs7hAcWZKNWiGdQ7Lyvg4bttTIw+igH3
	r7Y6wfVu8kf7HrjpOt560YJsCyMK8XD0DpiSCVoXRbwCq7wDcVm6xLbeqYO2VsSLmyaHOQZ9wvC
	u3W9JxwMm/a6Ln0Pj10ecW3DvgDnoEvhLThER1nEeMrHYSkF5hec5/W2jDcJ186fCPi7dAegKfn
	xcBYeG04DG07K0UOZ8oZoxdWDyJ/SqzYq4sX9gr8tKdOkFWzyAlXQ/aiJEu4Z24y594vCvMtbdK
	NMBPcvbMkwgDieHBmo3DE+hgJz0oNjFDRSf62ajYh/Zf4C4ScaEulgRlR2fRtTFDuEV8Xxs/c/U
	WkUiYWlRL6cI+HeSGpeD8oQrDm+YRAN4ZywQvhCY1W64oxZsdYXdcUEAq4H5YTDPJ0CbhTXhzp9
	1J8iqn/kN/B8w=
X-Received: by 2002:a05:7300:1484:b0:2ae:5d3b:e1c6 with SMTP id 5a478bee46e88-2b48706e7b7mr2010368eec.21.1768369001549;
        Tue, 13 Jan 2026 21:36:41 -0800 (PST)
Received: from localhost.localdomain ([2607:f130:0:11a::31])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2b1706a6386sm19226783eec.14.2026.01.13.21.36.39
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 13 Jan 2026 21:36:41 -0800 (PST)
From: wang lian <lianux.mm@gmail.com>
To: sj@kernel.org
Cc: akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wang lian <lianux.mm@gmail.com>
Subject: Re: [PATCH 08/11] mm/damon/lru_sort: support active:inactive memory ratio based auto-tuning
Date: Wed, 14 Jan 2026 13:36:28 +0800
Message-ID: <20260114053629.85750-1-lianux.mm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260113152717.70459-9-sj@kernel.org>
References: <20260113152717.70459-9-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F378A180005
X-Stat-Signature: zcc8hzdc1hd6onui7h7zb6d6533yeec6
X-Rspam-User: 
X-HE-Tag: 1768369002-844606
X-HE-Meta: U2FsdGVkX1/DKxh3h+hmb1tTlADW/kc0stM+ohP0YCLuuol/AKESi88izSgvC4te79WPFWJqA9N2JJh0vu2VPTZHadvpAQC+i4jta2i3NTdnG1xPpkZzsWPzjxiRP4ky9j175Hj75SKkdgRlImf4RENWi/ZNnRxC4kRzHV50WvSgL9pyRfJ0nsx/Ioacr6U0DXVsbdm+BdEGjgfk79FAWxudRWMdUsJki5dYiXbrNREspzaAJ9+C6rplcsBXvuStkzF9Xkd0tZaFUWfh1Cn5pEPpmxWb45tZu/Yb5ccM8hEANt/iSMpkZtqhIaJDzMLq6yZBLz5T4bEIJEGt1ZYFGwUcOi2kDdMgpqZURqEHdlsVC3BxWZsOVMM9z/gJ3D881jFd/eZvzuqCeDHLoFlO9vVsx8ripbn1NdKN9NPQcNDjf6WZpjaWycLvIVnpHuzIeK9esVHZKjHfEzrE6uY76/lvmeJ9xeMHe2gONgnJllcFOFiDEKzLcSr6phnFjg65llQTz69pespqibl0VCMQantpRf85ntPikKi5PPTO3ZPM6RPopX8rTs1LF6Uf+LFkA9x3IhcIuBlMZOytUATDw2Rcetb7f65ZinvfVjsKqF9Su1nILBOMC6EXUgJbYNbB1Rk2M2AGYCkSBskQYNzgqEyo/hRF+TG1TDHsX9/kcwK5L9ynbga38CsVFVyWkZNOF9KtiI1R5kb9XlT3Ox51CShrdO9dj/it2dmeJra3oqGIYJ6NkwPI3Zm59YJ8jBEFSuPMFwkYPjewVskFFktL/mNSO91GIN6i5erqycBozcwyqxK/VJGzflx0HzZ4ya+qu2u0vWRridk+LFGM/SaplGrUWFyyMeYCOsFBKkoUenSomud1eKNsAzFee97dFiZImX1VVsFWm8iyz3ho+kArXIxSS00lnAfkMmNd3nUJy18Crlskox8uA5N6aZsEOmOQ6Vj6TXnXdzS/WYsI8Ko
 F9uWla32
 u0rg31uGf31mrO4ZFiAvleKK6CDtfyqRk+ZOp7hu/XBXEj7zP4Pz9kyLuctpbWIpbka4GRGWlsKPQlVvFaDz4IT/bZi2pLrJv9XeoSKPEPjNDQpP+3tPCCZTuBvD+LKlF8wjDjfnUGe/l1Dtvmaw4VMVBgg20b/eILcPSPKwBFlbxYtvUZsfIWpOx5TfFakiyg1OMMcp9B8rCtsne7KzWnR9L4yKthYJuIQKTYa14YwlE/eaNocj+mILqsr23LIpnRjoKNaYLWrDOAfqNPHSpI4S5hA5dCC46E0MWcYNNO4Oj3nNqvgJmRBNzIbZILFBR+pMYJtNaWqSqS/k6Kutz/pDr281aDk3t1biGo1ZkoZJdgEPZJqERgpAQeYjiM5BKcyyXtvmJYogJZXvdPmoKcq7UP3ULZS5EgrbTq+GTj+HRb6676DdZ6+3zWM+EUQGY6RqGK7P0iARJcIIjITHOzCrhxTTXzgqSOhDwZbbHTNm3yuZnX3GUwBaC9gSZ2RYptOUP0zXQxePfgI4bidKRfMxVT2Q2yt9IRlVcHubuF35snWDNfmgDF9a2DHVdzZ4WCk5Hn5OJoXBDP6OIrYfuczT+IKgh96oQXZSA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000152, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


> Doing DAMOS_LRU_[DE]PRIO with DAMOS_QUOTA_[IN]ACTIVE_MEM_BP based quota
> auto-tuning can be easy and intuitive, compared to the manual
> [de]prioritization target access pattern thresholds tuning.  For
> example, users can ask DAMON to "find hot/cold pages and
> activate/deactivate those aiming 50:50 active:inactive memory size." But
> DAMON_LRU_SORT has no interface to do that.  Add a module parameter for
> setting the target ratio.

> Signed-off-by: SeongJae Park <sj@kernel.org>

```
> +static int damon_lru_sort_add_quota_goals(struct damos *hot_scheme,
> +		struct damos *cold_scheme)
> +{
> 	struct damos_quota_goal *goal;
> +
> +	if (!active_mem_bp)
> +		return 0;
> +	goal = damos_new_quota_goal(DAMOS_QUOTA_ACTIVE_MEM_BP, active_mem_bp);
> +	if (!goal)
> +		return -ENOMEM;
> +	damos_add_quota_goal(&hot_scheme->quota, goal);
> +	/* aim 0.2 % goal conflict, to keep little ping pong */
> +	goal = damos_new_quota_goal(DAMOS_QUOTA_INACTIVE_MEM_BP,
> +			10000 - active_mem_bp + 2);
> +	if (!goal)
> +		return -ENOMEM;
> +	damos_add_quota_goal(&hot_scheme->quota, goal);
> +	return 0;
> +}

The second goal (Inactive ratio target) is added to hot_scheme again. 
Should this be cold_scheme? Currently the cold_scheme parameter appears to be unused.

--
Best Regards,
wang lian

