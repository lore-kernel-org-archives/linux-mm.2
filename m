Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36107CAC5B8
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 14:54:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 924098E0009; Mon,  6 Oct 2025 10:54:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FBB48E0002; Mon,  6 Oct 2025 10:54:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8114A8E0009; Mon,  6 Oct 2025 10:54:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6F3E18E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 10:54:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5059811A7D3
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:54:36 +0000 (UTC)
X-FDA: 83967985752.30.6428D37
Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5FDC3180003
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 14:54:34 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GVtnG6up;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759762474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/nMWZC6mx2lLvBlTIQHePU7b4rUHTiXGBCIFc1BcdqQ=;
	b=X5ltI487q2+i8gnjHjKVki+TfVhj5N3Bqm1MRYZFj4tHlxBHkimaYAh4B34IkSc1gJz4F3
	RWhmn8i0geIE6HRznCGO8iREs+TbMYRo96PLfn2w+ZG0RBdEL3dV1OTdkRWFvLRe4EbHjA
	B3nJ6RyNrpeurBqwye1yMsH8peZzhvU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759762474; a=rsa-sha256;
	cv=none;
	b=uOZgQqYhmjwXIeYy3bd22jMuoTNNw4glk+qNmTFUMEzfq0oLJZbNqbW9KplrkM987Q8+Hv
	Z1UVNmEPodiveXHKAkwgPclgXpz12FMVnOPQbL7vk8rg3o8nhm5Bg6X4CscVQ9kypWAvt2
	lW3o47o1hPCyq5x9QtuPRT76UXX2WD4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GVtnG6up;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.175 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-71d71bcab6fso50921197b3.0
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 07:54:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759762473; x=1760367273; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/nMWZC6mx2lLvBlTIQHePU7b4rUHTiXGBCIFc1BcdqQ=;
        b=GVtnG6upz8lwPS11oTUUWOiXtRPRbAcZw2SBKHBz5RUnuGDQ1d2VxKjqpJ29mCwghC
         Xco0KDyR7B8jr8akKowi4mcjFlF9hm50hii0858ANkunQHqWn1OVzwNI9IvxDugBmSFk
         IVgwnEQsijjfr2PPF4EVaOUjz0litBcgmAfvFxqsjZr+vt02rZb5Df5NqMX2zQYNS+lp
         kc/vWwixbiyVqGjniZZk7Sz/ogHeBMJoqgjqSqWCPqdZwpls+TGwwlYICFs8AM/089Mf
         oNoxCoqY2oe2JCUtC1QZ7npFjB/Q5unDgLko6IENHHLsuWlxpnCRmFLLbSyWN4HQovGZ
         Tfaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759762473; x=1760367273;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/nMWZC6mx2lLvBlTIQHePU7b4rUHTiXGBCIFc1BcdqQ=;
        b=MOj4itySGMKOuBmswGHuiPu7Br8X4muaLSGgQXPA9B0d0DEBzNg8tgglFSpc8PojdQ
         gjrBeM2JunndtAwJ6jgQR+c26XO1nOhaLns1WBBRYPD9e4yvap+cwSGNzWArgTl2ukeQ
         jbgAUD6avfsemYK70yTiQNQzEnx66kMaYanYjNun+1QhIzk0kcM1cXvBaZ+Ew+GZn/f0
         dN3Mzc5zIrfkSVAmZD2Iu33MYbKSoyH1glGahmwYhXKJGXckTwqgsOI2QGZC1u38R7tq
         TpmvEDfbp1fWQd7FDvEQTu2+f81swOu6WnW8qIJtwiV7M18IIP3HYakHzOeoYZmICL0T
         OMQA==
X-Forwarded-Encrypted: i=1; AJvYcCWK2Jxwv3l7Jt3fhZTYN3xrFPlNsznM3YDrtSxG1fc46D65US9TBkyDNYUuZoKchkuvwZylADYkLg==@kvack.org
X-Gm-Message-State: AOJu0YxD4vp49yHjvlXdUxSmAe0J2OMqoHFNpugh4t8YMD+76YkyS+ff
	59BhU3oIwvl6gIiPvNY8WrkfywaXzxvXfSEKT9jJ0NZIbBvdh84QMctO
X-Gm-Gg: ASbGnctSyQkc1BWfGy0IuAYfmsmWtFgrB3Mc2bjRE/8moOTmGADycPM2bIpqDzZH7ih
	8wRx76tsOQssB/dwtE3dApKQDMf4IJnrSApnoNLZgtlqQMZoxGz+e8ARPAWZY9yw4j46WScBT1D
	u6p/xdo/kJEhbh/XePhQLkJ8zLmTgJW4Qc0zmJa3lanPveQOFTq9OrpgTY8Vf+HZUnFtZzaUpqQ
	vUjiYXTnqEfM4Bfyjv+8hvDfX32lUMI+caCv4SQnNLBgMkSUkw5mLGpRCoyWnzs/4rKiIO+M+PL
	WRPxEdmQ7zBxzP1eot/zYwQpOw6LjzUq1hK5GFDgh4upctE+6b0DYLVT9wm2TqLRGL5klXY7otZ
	IPZ03EwSXdn8UKZ1qqLU+eRpnZTX8ZnTdaHthWunPGXcX3/EhGLZervkBGUiizyq/82e0ZB9YnL
	dwrzulLBBN3zJL
X-Google-Smtp-Source: AGHT+IGgzF4VnegrQWIU5b5yBOpwKcD6TgCX+7ECIXBS4CzsiVPeoDVDYAGiYdKi3P9JWovBlwsomg==
X-Received: by 2002:a05:690c:6202:b0:729:62ec:9185 with SMTP id 00721157ae682-77f946783e2mr158179967b3.39.1759762473144;
        Mon, 06 Oct 2025 07:54:33 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:9::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-77fa470f315sm26419187b3.10.2025.10.06.07.54.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Oct 2025 07:54:32 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC] [PATCH] mm/page_alloc: pcp->batch tuning
Date: Mon,  6 Oct 2025 07:54:31 -0700
Message-ID: <20251006145432.4132418-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Stat-Signature: e6z8hdb656658133jnz7hmjuef7xf8qb
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FDC3180003
X-HE-Tag: 1759762474-127700
X-HE-Meta: U2FsdGVkX1/swjVTX7eDVJHZXjaw0T2DJUTuyIvqFRHLJxT959r4FrPIejLrI3Wr66niAv2vyr7revE4gzOObKZ2wW8XhYUnlYQpfse+0NiBV6mlilJraxDZTVsmxhKHtS/Klc+6xFg/8TMYGpEoGKMUZ8WZ9ZobD56ZrvkYaqi6rxI7Ux/6AJqdG+0XzvHeUdwXY6v/MejgOURiymkuT6tylJdfacOkEl6P/JwiWjz22HDqrbTnJLyZcQPXovxuScgHWlhR9gw78cLzRB5S5ouQkJRxKCppf/Db3qqXKd5bC1bc9nT9Lts3c3xIz+EI4o/bjWD1n6qzDxg/83/dC1zmwmZ0LPSoLA0pSBOn2nC61xiy82XvLULp3bcA2Oy5zR8NnWin0JiYwBwxVVuQPsjCJK4hZR2jOtXung+tkI8FqHWuOJokS3B+466EHU5Q5bYE1OVbvvooiZ5e+TWGmuXustJ2nPPcOj0PLkPNZ3/qyz6kSKvY0idbluNStDEasoI+eZglaIcgBNGmNArEAZ6tRjisLjAX4goJGzojxS/7rMwijb7IOc2aUrRPUjXXUzKa4CZCtbC22jrRa2w15n6X+JSwm4tlxqt/lfuVJw5IGF73blY6SSUAfAIWVfmjLPqY05covl6ifXZQetkGzTG+Zno5Bm/d5PDPD9MgH9iVJ4X8K9egqUJ3Jfa96wYECGPLTTDya/HbtskH7ycfNt2qI9StMVwQ1HqKW0GfQHHEFGhBBfACMIQgum2647ohYfLmX/ClXCQOeTVon0r4nPLTjKGAc8IqwGsr7wWvkJ5WkxEQ4OM9ZFTQK+LVv9PHofcQt0o9g+dEFFeSb4dB/2Boc4LZ/ZGYR9q/YdiLAoCLNI0ILCcRLyQ+elIjzE1/qnwQLstQsNm+AzZPUuAotFC4G4Fnnbtjeblpu6/bUw8rzFjfFcQT0ayescB8JoUILulbWhLJvPx4HQYhkhD
 BkWjNpu+
 akkC0lQUx0euwp7m163XjOy3s8B2Md7h3RJfX970GzZ66E5E/XrfI+SxVjtKN3yHy5zpnm90e5p4bKjQh/s3B8mY16nB4bs3qZSrFCt862wRa05OzRCBw4LlXmqgh+mmvbjsicKf1+KQBNx4/RKceoj8jdrCr7UjwTiCZ8ZcumtrcSCSgQSltGlZMfp/CU6OfdTsIZ/wnZLG8oXtKJwVnR0kuVuzMjR62lwGjQCMbdRc/UMordczGWeidQSYJydpm1QT62JuvVVJ/YsISTnX7jrOtTLjKImnqM/XrHWdVhE9b2DuG1BP3cY+DqOl42vl96zTMHDLRhslLGibfB58DvBmbkj9sJT4g4uHrPIDIDRvsC28otDYLiskRESr/7QHYuCpl4lyYyUDc9g/UTZ3GzBBbYRBhZiPq+io0HH+F9CuyE2EzDsbcX+vZNeUOiU2V1aE5pE+m3bdfBKpdByKJCAV6IJ2ZTpFmrs3WAueF6eRjT0jiTwGLx/45wlyoYSA6uhlfxG62VS2TWAZ70whca+2UI2lfiVtPyLjzazRitUZSLdIEyjqx2qkoig==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Recently while working on another patch about batching
free_pcppages_bulk [1], I was curious why pcp->batch was always 63 on my
machine. This led me to zone_batchsize(), where I found this set of
lines to determine what the batch size should be for the host:

	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
	batch /= 4;		/* We effectively *= 4 below */
	if (batch < 1)
		batch = 1;

All of this is good, except the comment above which says "We effectively
*= 4 below". Nowhere else in the function zone_batchsize(), is there a
corresponding multipliation by 4. Looking into the history of this, it
seems like Dave Hansen had also noticed this back in 2013 [1]. Turns out
there *used* to be a corresponding *= 4, which was turned into a *= 6
later on to be used in pageset_setup_from_batch_size(), which no longer
exists.

This leaves us with a /= 4 with no corresponding *= 4 anywhere, which
leaves pcp->batch mistuned from the original intent when it was
introduced. This is made worse by the fact that pcp lists are generally
larger today than they were in 2013, meaning batch sizes should have
increased, not decreased.

While the obvious solution is to remove this /= 4 to restore the
original tuning heuristics, I think this discovery opens up a discussion
on what pcp->batch should be, and whether this is something that should
be dynamically tuned based on the system's usage, like pcp->high.

Naively removing the /= 4 also changes the tuning for the entire system,
so I am a bit hesitant to just simply remove this, even though I believe
having a larger batch size (this means the new default batch size will
be the # of pages it takes to get 1M) can be helpful for the general
scale of machines running today, as opposed to 12 years ago.

I've left this patch as an RFC to see what folks have to say about this
decision.

[1] https://lore.kernel.org/all/20251002204636.4016712-1-joshua.hahnjy@gmail.com/
[2] https://lore.kernel.org/linux-mm/20131015203547.8724C69C@viggo.jf.intel.com/

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d1d037f97c5f..b4db0d09d145 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5815,7 +5815,6 @@ static int zone_batchsize(struct zone *zone)
 	 * and zone lock contention.
 	 */
 	batch = min(zone_managed_pages(zone) >> 10, SZ_1M / PAGE_SIZE);
-	batch /= 4;		/* We effectively *= 4 below */
 	if (batch < 1)
 		batch = 1;
 

base-commit: 097a6c336d0080725c626fda118ecfec448acd0f
-- 
2.47.3

