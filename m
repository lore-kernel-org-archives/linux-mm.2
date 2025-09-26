Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4512CAC5AE
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 17:50:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BD2C8E0005; Fri, 26 Sep 2025 13:50:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494C68E0001; Fri, 26 Sep 2025 13:50:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D1DF8E0005; Fri, 26 Sep 2025 13:50:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2BD698E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 13:50:21 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0FD1160670
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:50:20 +0000 (UTC)
X-FDA: 83932140600.20.A69D6CD
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id E77B240005
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 17:50:18 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d9fgNeX3;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758909019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tl7XQK783n2BcTfMcJVdy8g77YXkosVIIL/ZsHMQncs=;
	b=BGDSC3wUxtW3+v2ygqbsdxIoEcoEb+Xf6UDNOvB1h6cE4h+cdfhN1N7tUH6CrGEN4WzipG
	5KvydbjzNq33rmqIpLM+Jh3Qm+bNCWItzgq4BCtwdkMnTZU8fqL8vJyZNxsUQPurr8vLxX
	66NBdGBdWSdhX8KPgNtEz02m2s6AYyc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=d9fgNeX3;
	spf=pass (imf27.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758909019; a=rsa-sha256;
	cv=none;
	b=yS16Ig/C0NO8dvXc2RpRBK6BdY5Hka96zU7uHx7bvHpe2VjmNGhxEt/z+cmc5gfCwjRnYc
	24k30rqCkKBhv70IdXO4XO7ecWVJfvIZBG32gJ7aJf7aEa2P9PI/AcMSvwOYWIvrMaCRu8
	xUi9+7LcxB/uczSEMlAv3TC9avElHkQ=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-77d94c6562fso2764157b3a.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 10:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758909018; x=1759513818; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tl7XQK783n2BcTfMcJVdy8g77YXkosVIIL/ZsHMQncs=;
        b=d9fgNeX34rji1jAUBqYJvciypPiKsoe75WkoSADFOPyA9ZFO8gYFFMNWRKmKq+rImH
         KTFacIparjxsbpOm93j3cSQSq7KCt7tcksPxxzkIeDUEJbmahW1Ww99K/+HNwPz68FZw
         PwCOvE4by0HJnr2J4CG8JFbQp7pQaEEmfFduSmN6CiQ1lM7qMFqFtPw7r+vQl3rlXhQ5
         sQ6yzErKUMHdcJE5TCjXGQqqHIxlVrLA8hNZE+XSUFqwmIJhm9ZQsuFCXU2b0IVygBaf
         0ANFnnOgA/KjwHzslTHg0CYeObwysKNhiS7idUS3YrparcvR4clifr7jxFWDplEuRiW+
         /kqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758909018; x=1759513818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tl7XQK783n2BcTfMcJVdy8g77YXkosVIIL/ZsHMQncs=;
        b=i/vVKLvINRy88Kg91FnTkMJQVhE5i1M5o4bNjOwGCZBBcA9gm86Y7/XokJpGnSR2gB
         BtPlcU4qiWMnyRNlmczX31PndGGOl6J731koMtZMAxPL6aNPtf/j1D282I/WshSHhuXH
         5L1LIkqzcx5vkD6mNXlwc/BprPE1Y56jyazNGMJS3cqnNM96Ipq7HGfRpjMHbofTUMex
         9Ndbv4GNoiw8VLxlLQb8ib6EtvshQO+5NA8iz3EkEna3igJ+Y3XQm2zZxHBRm9ykOvMw
         8XMykwEdGICkBhwmpVXSl8WULC7452QHaXrqvT0gU6W4XyFlFisIskbFkovh0pTl9EQ3
         bp6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVKGcJHz985kqndWCUeYV3p5cgH2A3l+M8F+5jmMe7Wrdek5hcWe6X17n0VyPW5fk8uRv5mJwrAXQ==@kvack.org
X-Gm-Message-State: AOJu0YzS/Fbk4y2jsJ+jMvAggaGmWZBaoJo9nU6xVIZZcCp9rabZzidI
	CLSNYyNlLM1q/s9IC2oSJB7qYoi8fVrZNtXP3XXLkyW5ycRaFMOEZianKcbi2A==
X-Gm-Gg: ASbGncvxXiLoxcreNAtKW21wuI7Jab0KpkPlAxEE5vnNQ7dWc3B6UIOl2KVItAkASXE
	KI0LwZBPCoIzbYBw97GUTDlGUiC93INWl/EgeX53QiMQrJvfDZmyhExBrX9ZBozZlFSY9XNYhku
	QApkesvQUKnyKTW3a+zeReSKFQiHm6as8I4AY7QSQx7b9WoAxOuc4/0gE620XX7hVO+g5b3tW4s
	C0XvTyLq732tYUYltFGdY5kf1aVzjAXV5T2+WGNxA3HWV1qPlJ9fyID/+gT0RNfdVEIsBuCJOsW
	UHrq24TjjBq98qtKJ6bnfTRl9X2w1xPsxAy5uo/ipkCpcpwToAXYwQwLtbg0WOarzJaLrdJrBlR
	K/6bHxhHtX+FHi6JNTRdzWanLBI0J4cLIxT7052qu63AEvSMY9CgHwkc8b1w02rQ2
X-Google-Smtp-Source: AGHT+IHjp8E5q+W3TQ5BUUuAX6KWZ1EN9m5INfrKtRDUuKplaLUfJoIX/Wbu6d/Mpiu6liYDBvjLDA==
X-Received: by 2002:a05:690c:6483:b0:76a:b1ef:25ad with SMTP id 00721157ae682-76ab1ef3bbcmr55310947b3.7.1758907534254;
        Fri, 26 Sep 2025 10:25:34 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:5b::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-765be47f614sm12246157b3.28.2025.09.26.10.25.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Sep 2025 10:25:33 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v2 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Fri, 26 Sep 2025 10:25:16 -0700
Message-ID: <20250926172532.2814977-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <567be36f-d4ef-e5bc-e11c-3718272d3dfe@gentwo.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xaj5e4ck15rkn917tdbezbomhxueopci
X-Rspam-User: 
X-Rspamd-Queue-Id: E77B240005
X-Rspamd-Server: rspam04
X-HE-Tag: 1758909018-168187
X-HE-Meta: U2FsdGVkX1/59S/5zKVcXJn0CfEjcHSu9i/cCRdFK6y1FeWxk4mepYUuBHPFb3Uihofxtnv/0ebXOTESo0dWW8PHj2Xzopwn9VlhfXH7EoGzqrOlQreCZaAnUNznooRXxfiLdZ5rDVD++EMIaY3euTCcog0grqBPYIcy9UfgOWt3mLBNSVeXUsMcnCVUzPFNZnCWkhgeG6pzzRZthLyokSjwzPZG1Ju2FQK7s3QmNA4GYpi/w7/3pHMn10sZIKpo+SJK1Zu6WCVP26I/xTIl71kY7sVjqmQff1ru/jz6K1sm0wuXjd6F8rBbrv4OjSZnlqdpQh8OQso+8+qcDRoh8UYhkufXTBvVFQD70A3iY3gv0QlYr2fQxf3J9vfSom0XD90ys/siPmJbag6naeuruES2njQF8YORDUEJ2pW3I3DRqLmslN3Qu08rYJ9izQLs14IdufJhSt70bSyeMHj2EXiWt2KZJN8lgA62dJwCU42zYP1zcZVt2Ra1NvXxbs5lYLsHcT/+BGvKNvbG9jVary/TqBXT3Dbd/Tl8jY1+SbfA1cEYS4mdIx/W5jQdzfagOFLarTKvnWC6sRPvlBu4n0Ob2w+IMMveDCVmBugzV1gEchyYB4bk0YXfKJ7oKjuqTMaKGYkVwLgWHALkoaeKGHx3QUPcyez8HzNwFmN6kUJN2Y/AFWU2TvuTmwe/PDk4ssJvSSSxFXKBWcEaW3OjkSuER29qXRsfq00JbSdsGrn4YcqWs6K6lvrkreEbaWzhdJSPYBxIHKSKXMCtAcFLSUH8Wy+IJRopHt+bX4WsYi8qJxKrZzs7Lv5Az6eiyX9V7OCOgrqR7mPX2n6fZJ0Qe4yO8fN6+rT60piY720sOZ+9GdlfNLnbcgIJumcKMzagavaC+Yfh42q0ZDQd7pXiCP20C2NyenOnNSo3Y61vZ7SXYvwftMnHZDRnQk7rwgqDYYDNHaF5CIwLWtESA9G
 pW+RWCE9
 lSoaJBupV1r8XsarUKSn0/WA9vIkLHXH9Dy4YcYxC5RbYO2dJDAvHktAYsNCHxqu9GxaBL2xtry6IVGWAexe6UDOjob6PWH3o9uIQMYl/GWVSX47F0Thq2lAp+4OK8J7dyeJBstFgXFbQSf0KcXDgezwDKtncBSUdeh8A4ethiLbGVvg9hoI3HwgADrsf7QyXGnvMMbKFhtUwRMgiwabp4HwhJ1neA4UEFmk/Eo9YvFLbxru4Bjke0Vx4FAd8FJGCqGLtvNutg8qN4JJI6sA4QwzmPUqRAXkt2q0galgWaspXssBpWyXREGQSBKnLrftsMbSPZ2UfioMkfKOK5RFwO5drGkIkXVeZ9Jqj7NbTk0ZOpWmpt0ArwqPyFPYwSTMyubveu4VxgQ/Ff+TdEGnisNvuXev8/qwtjf2LwLKe4WdVPSt2le/zGlqLIQP306FNMIpd8dCY30yIviHA1CpL5kFJIJhH7W14CbjT4j3ZYFfZQWj247AFXuF2URLh8EIsIoLvRssUj3LEKg79pIAZgekynvznBcc8PJYreieL2K4GIaOw0ikY6x+LKrndQbivJhGPr+LzCjWT8Z3MKl/kHslqa7b6jVWM9Kklr5/xENrvY+61fyp5EYRuLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 26 Sep 2025 09:21:29 -0700 (PDT) "Christoph Lameter (Ampere)" <cl@gentwo.org> wrote:

> On Thu, 25 Sep 2025, Joshua Hahn wrote:
> 
> > > So we need an explanation as to why there is such high contention on the
> > > lock first before changing the logic here.
> > >
> > > The current logic seems to be designed to prevent the lock contention you
> > > are seeing.
> >
> > This is true, but my concern was mostly with the value that is being used
> > for the batching (2048 seems too high). But as I explain below, it seems
> > like the min(2048, count) operation is a no-op anyways, since it is never
> > called with count > 1000 (at least from the benchmarks that I was running,
> > on my machine).
> 

Hello Christoph, thank you for your feedback!

> The problem is that you likely increase zone lock contention with a
> reduced batch size.

I see, so is the suggestion here that by reducing batch size, we
increase zone lock contention because we are bouncing more often and
having to spend more contending on the zone lock?

> Actually that there is a lock in the pcp structure is weird and causes
> cacheline bouncing on such hot paths. Access should be only from the cpu
> that owns this structure. Remote cleaning (if needed) can be triggered via
> IPIs.
> 
> This is the way it used to be and the way it was tested for high core
> counts years ago.
> 
> You seem to run 176 cores here so its similar to what we tested way back
> when. If all cores are accessing the pcp structure then you have
> significant cacheline bouncing. Removing the lock and going back to the
> IPI solution would likely remove the problem.
> 
> The cachelines of the allocator per cpu structures are usually very hot
> and should only be touched in rare circumstances from other cpus.
> 
> Having a loop over all processors accessing all the hot percpus structurs
> is likely causing significant performance issues and therefore the issues
> that you are seeing here.

So just to be explicit about this -- in my last response, I noted that
drain_zone_pages really isn't a hot path. In fact, it's never called
with count > 1000. The real offenders are in the last 2 patches of this
series (decay_pcp_high and free_frozen_page_commit), and I believe these
callers don't have the same problem of iterating over the CPUs.
free_frozen_page_commit only iterates through the zones
(from free_unref_folios), so I don't think it has the same cacheline
bouncing issue as drain_pages_zone.

So perhaps drain_pages_zone is a good candidate to leave the batching
size as is, i.e. pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX. What do you
think? Again, happy to remove this patch from the series as all of the
proposed performance gains and lock contention reduction on the cover
letter come from the last 2 patches of this series.

Thank you again for your thoughtful response, have a great day!
Joshua

