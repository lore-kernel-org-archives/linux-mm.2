Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32AB8C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 13:56:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 447CB6B009D; Thu,  3 Sep 2026 09:56:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F8306B009F; Thu,  3 Sep 2026 09:56:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C0336B00A0; Thu,  3 Sep 2026 09:56:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 03AA36B009D
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 09:56:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9B9A740522
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:56:45 +0000 (UTC)
X-FDA: 85172601570.30.FFB9F22
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id BAE4110000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 13:56:43 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PbMjU183;
	spf=pass (imf14.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788443803;
	b=yhcyvrDKdmHC6NeF7FnIK7Iwj/OOgnMsplHRJf2U5JLrZjTrXoK5l/8/kU3uS0M4HERYOl
	pchhHzndGGFw9P1kmcmPVuI3CGz9uanBmz3s5iVYoFvGv6msLhdYii8W1ayRb6OsUSHZqg
	GpLx6MdqjCYZFJu5C+wDij4zXQTykwU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788443803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U5QSQqPQNQQf5u4kt0k5Ugm7eSjsSUE+ivZY0S0TJ0o=;
	b=EV10V+8UxmSz4G80FaSXIn7KFX3o88n5P+qFmAboqdoSbJRpgfegDRL+z7jxVaYfkjyR4i
	HvhU3jOkpq1EbBAVO1OFy6h55lBHPgYnO5/Ijb3lZR6sjoiuSg/hxvT8PC5uV6RAWNIZ08
	PDn4niees6yPQamSjhpe72NvDJFn1rw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PbMjU183;
	spf=pass (imf14.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.215.170 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-cc1d57602e8so2478897a12.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 06:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788443802; x=1789048602; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=U5QSQqPQNQQf5u4kt0k5Ugm7eSjsSUE+ivZY0S0TJ0o=;
        b=PbMjU183/klar4/BYSMqJBH3LwtUaKtMKuLEBBCMj0mz1FYyL4+FrLUagkt7Rzz9Qe
         8R2muNYQpiYRoR9tgoCK7vSwe3LYpACWp2D4RVTtLwi83O7X1gY2WX5yHXSSbUC0Y9bO
         Waz/Re5Q1KlwSX3bF5AwevLMs2d3SMNMXXAyvBvz36wbjAmaVKkDWtERgZ6LU/Ezs0Zy
         2UabyaPk8u2jnNAuZg750QmpkuLaLVD9B03uKRDRW7a9SE5mAo3C3pfbCAdjWgKQv9my
         FfkTUpeCDc07k/rk7/dg8cHLM+ZuUeCKd9S5BrJKTfL0RBf7dOe+xFErso7eCniNmQL9
         vqRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788443802; x=1789048602;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=U5QSQqPQNQQf5u4kt0k5Ugm7eSjsSUE+ivZY0S0TJ0o=;
        b=FrMEgcE3hHXnWPnq35csMQrMyThJri66zvy978P+iDov3jrv0zJUwBEa2BJjY1QE9A
         LVy6TIX+xXqVr6FNxFe7xXvIiNctjBmPAcZQ8K81sQx7S4yXeFmr51nlXh1ie3wS3nUV
         rZIRseISoUzC4SGzmToams5X8F8QocCS+4yci+0+w8oNRO7MIrV6wIAaRrW9+70T4ZEn
         I+Y4g1Q+YB7P56/erjufNizAavkJgENKhmg2kO8S/fDRPAlQ0ZyQm0SnSuhIFJOrFfgA
         XSiEapvIafyQemZ3V5VXn+RSPglGDyppp7S+8sSc4HDS804Bz5f0OOv/dbE9nO7aEWm6
         /0Cg==
X-Forwarded-Encrypted: i=1; AKwUvBzPdeECL3GP5qMCKxDUjzgodIeUvTexqicstmeLvGjRsgMz+kt5az8t5OXcLtCr3AFA0WoKo72/+Q==@kvack.org
X-Gm-Message-State: AFuF++lZH4JK04/uW9c9Ih+21We72ZFRG9Wiiolse3d/huWI/qX3zTxZ
	CDv6cAPBl/XFZVNOVBvMff3aPjSeZpVTSzRqngCc9oWhwMz4/VUboxB3
X-Gm-Gg: AYBFou3RqdqAo/mCiazGzFWPxSbyiHImpjqljy+SRuHBmBlP8lH1NCyaz/EZ7HCYuaN
	iVDbmpGD0+qN2bd39S/MfPXUd05qXLkewDJc7OtHqYIHj8muzf4UVufuGyPPBiXuRUOopxSrdSZ
	Qf6Bpe2rvBaPApKctD2Sk6EcFhKAeujHXz0EmEflq+UQB2Uu7cXdsNex1UuR0q4mAALCI/Kbh9S
	ZS2K2fO0no/DSX6vykOQv6LfdVoD6xijy9nxK1E/pP3n37ivSb9xyD5mDEjyqe5OJzLQBHJKdly
	r+K/frTgHVEWAqi+sJBD8JKm2lKMOMCqtCH8bRwNLoWZAE/osJZK8OnECh2KbYDbE890r48IBoO
	g4OTgm1fP9IJMx79JO5JprYfvlPF4P1WxekyjT9T4TzNlW64MFcqdPuXN1seF3Vsbn9CddTNQFA
	Y8OWAgFb2a4gtxOFb7pz5DdKT9aeKC76hVVbDKUvZeOUKliSxPaNPUib/LBrqyy8hToUBZfpaoT
	U8cxw==
X-Received: by 2002:a17:90b:4fc6:b0:398:c315:fa6f with SMTP id 98e67ed59e1d1-39aee04acdamr21381384a91.14.1788443802462;
        Thu, 03 Sep 2026 06:56:42 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b0832b85bsm5726614a91.4.2026.09.03.06.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 06:56:42 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: xueyuan.chen21@gmail.com
Cc: akpm@linux-foundation.org,
	vbabka@kernel.org,
	david@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	brendan.jackman@linux.dev,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhaonanzhe@xiaomi.com,
	lipengfei28@xiaomi.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/4] mm: adjust free_pages to make __zone_watermark_ok() mTHP-aware
Date: Thu,  3 Sep 2026 21:56:16 +0800
Message-Id: <20260903135616.4106443-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260903024629.574484-1-xueyuan.chen21@gmail.com>
References: <20260903024629.574484-1-xueyuan.chen21@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BAE4110000A
X-Stat-Signature: 61yrq63wfkqhn8d9fcgejeqddq9sn8fy
X-HE-Tag: 1788443803-646040
X-HE-Meta: U2FsdGVkX19uhKeAQUZpGKfMLhoqOZ5ujw6I9j/Gj6/yJLv4U4z9mpaJgPFKa7QC1TaZvfT5b3jbIg52UXLoQxOI2SAecPG7g+ySlJy4fkuuu6bt9qFpoqQnPgClI7BSsE0XIWsdsWAiBTJ9hL892/nN42Hkzy5vn3PJAu/aF4uFo6p+N0MU4dn5D+eXzx0SoR//vFxOgNZhATGwDJ+Mm3r+bhxiKdcCH52xqQQmvig1CGE7RhetQALwoDu02Vl1KD8KXSZnS0RmPcpxGp8AheRUsrk/ti2jNgur7DC0fxBkA7jP+syY/ddPRl5e+2CYoeS8zwygOWWMKmYjETMZ8Vz6Kgt9LjwSO169COXotGPloBsSbh8PJq1ffOtm4PfLpBdEojcjx90WJCsUKV+VQ1erIidkaDcC0cseut1ORCNdyaHfUgxUfa5XvRHtOIhnH/ZioYqG8yXywNebns96vUbAKgn3ALEuNoZ0ppmqJHA/lmVGYstmKzuguxx0CYy4cc2TO8yYDPowPcrv0fQWdC8m5DoDVYjLplvL+mFGh1I82Ie0PQl+qP8Hg00SVZOhkevNNptxfoiXfOwVujd7BZLiKHT/bcQ3XYmaQdxdvgT0j+wrOw7gvC6Fep+5VbVSrkRV8pvYm8eewioAvp7FrI+2/en6HPEMfEz9OSKr0mvhfjoBY+/kPulfRrVhvX18hrF74QMD9zDQUfoWj4Vg8zVZcemwE5jsHlnQFc117z2SRgXmDp7ZFcciibuyqXyGZAu+Z2K5pPX4xa9ORKJB6bb3ZjtE7vcfzhWYl2SxXMa4Yev0J2kqI/+t4SimW285Fs9RbcWRvgBdxJLTvN35svm3P0QuNdaD2tJuLefWU250G6IgCAOQYVLNfKCRhZARCZ/ijJb8VkoP7TuCo1+cSSgIxCKk8qeaHjifCgWODbfzGpbTUGCz18dxvpdoyH7PAcYDE2+7Zrfl3Hv2GTq
 sX6y6Hv2
 iWFYmXdfrsI4WX28uXX8mQzA/IMWJSkhZN6voUdi7v/VTxatic5Hb2IBJa/uc9dNuDVrbe1Rzf3qcFHgA/LU4VqRwO4IpuAWmT2ULn9F08uQ2uPx6j+M17OAPvz2Ldk+KmfDH3ruJDAvRxMjkEiRfcmmrZjjK3bC1n/QdQoK3yENpLQe0aqkfqwxMTRwneSta0qqiPkiaFMYmy9/BIu+dEZgBGU0y3+LjkFEbYpbdIH/iIuBbJSbhc4zp2PpC2cE+hKeF+Z0b1fJKY7Iez3ecBEE61srBSnhnPMe7aMzkZUuu7F1RAF7K2PlIy6OcRyuV42BRdqdMOJvgFmOAQSNCfdrSu7a7MKXeoey+eUZrTixh+ychxQ0DgvL8zX7I6SHIGO7S4quqS7/TuMx9vQ/5p1n4fdxnaBYx5U8/c4DScA+/amBbPFinpYXH8t5uLCmrz/bNhkpy8kjoumkBc9CZVpIRfa6tbFjZZj5Y9qEBkMu99QVCkGSWvGhPOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 10:46:03AM +0800, Xueyuan Chen wrote:
> >+		free_pages = zone_effective_free_pages(zone, order,
> >+						       defrag_mode & order);
>
> "&" should be "&&". defrag_mode is 0 or 1, so this is just order & 1:
> works for order-3 by accident, always 0 for order-2.
>
> Same for the zone_page_state_snapshot() call below.

Good catch, thanks. You're right - this should be a logical "&&".
The bitwise "&" accidentally disables the block accounting for even
orders like order-2, which is exactly the mTHP case this series targets.

I'll fix both occurrences in v2.

Thanks,
Bo

