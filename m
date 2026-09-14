Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59914C88E73
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 14:44:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492CE6B008C; Mon, 14 Sep 2026 10:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 463846B0095; Mon, 14 Sep 2026 10:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 379626B0098; Mon, 14 Sep 2026 10:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 15C8C6B008C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:44:01 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 843801C02D9
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:44:00 +0000 (UTC)
X-FDA: 85212637440.26.0C5F1B6
Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	by imf26.hostedemail.com (Postfix) with ESMTP id 90576140011
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 14:43:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pHqm/wsK";
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789397038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VbWdB1y5zAgVgUDU6C58oDPNhatCe/TzGoKd8VxEcJ0=;
	b=y8CCo6qR0zwKQBVFimZKpHWhgRAxvbfYzgYyp6CPeUdeqf7lsFxrssnxnWn4AKNLtm+WA8
	oimN5ms369S4nUcU8mt6/Iaedbi1Gic4rgo1gmz/w110FOaG6313sQK9RDc+3scivdDxKf
	QWvV5HNqELiDM66FNyS4HD4Z9nGkbUI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789397038;
	b=X4nnfh0wd1Y6iaGCrwMENclotC7XsJjQ1ty9xSWPb7U1gCJV0nf1JLGbHPrssRXxV3AYwK
	+Ep+bTOEK3A6oYqZ+MdkBd/1PUjVtI/P5tjyhkV2dOlrB+F+lWQpsKq6NUTL2dWl+4qNXX
	4A9zcEnMo/7pn2It5wtjp3J5+A0V1lA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="pHqm/wsK";
	spf=pass (imf26.hostedemail.com: domain of aethernet65535@gmail.com designates 74.125.227.141 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-396ccb652d7so1522127a91.0
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789397037; x=1790001837; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VbWdB1y5zAgVgUDU6C58oDPNhatCe/TzGoKd8VxEcJ0=;
        b=pHqm/wsKPaSDPMKXV77lRs1rAtTJQAQNI1ueIuqpbz1oNhQuX5RNZHdgeUPEZqDR0t
         9sF+r3L1zGcwb3bIUekUCMkOawZDSKtzJnkq5HW6HZJLIlTzr/BkgfZkm+V7/fgu5IjF
         RrNygNRO1FH1b77aP+/to/dbDqwkRrDibzC56Iwq2RN7sVgmcYAWbK8uQFUzYXZNy/hj
         m4/QrxjeNXNlHdvtW71xvGGpvfc41DycdwhSVyXrBOntEyD0bmUgHpb67LaLXKz2/DRs
         J+APWLri68uaRoy9Fq7/16Y898gfiOk+0onynkrOBG2874aHTn1Xn1JCzgQrhDW3Psuh
         65kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789397037; x=1790001837;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VbWdB1y5zAgVgUDU6C58oDPNhatCe/TzGoKd8VxEcJ0=;
        b=QPJHBjuDpWvK7rk8fQlRTsHadxBWVXG/Y186OwCBiSh5Ty0E6sil2M8KHsTIeHQ2rT
         LTYEhYuO17S60lbAVIER82WZK3WF5Mf3+7aGrCbtOHAKUZEB5ppvziNSoGIxoVRJmFJz
         aKflApAYIOw4oiUjY8qvCOVb7HJf7yMQWha2hlp510BCoQS0dBfRSxIMnAXB7qaSM/8y
         DeteTBuO2zXKHjtIeH4g9LwWmMTCUlpUPaALaBjJPALOGlGTokfHMuHk1ox+DvfGO+aS
         2gaKWnU3gn/Mh8mcI51PQ0Pj+qrVNHjoSuSldJ2rOn0u8i3IUfJp/mj/CyZdJDwSB/WG
         1Wvw==
X-Forwarded-Encrypted: i=1; AKwUvBz+0Y20BABSe1lc1SuGTkdI+fTA7oPLD9HO9p7W2BJ+wfq5gU2chweLbXnigjjSaJZTcICfD8GWJw==@kvack.org
X-Gm-Message-State: AFuF++ktsLI5Jl/4bHkDfN562ceWnJ7kG7PojEyOeInf0gEBHXzxeFTb
	Y+Re5omuzQcaFndddBdKsC5uCZnPpOjQ3zSEfMaWTo1KnbuvmFb2lLKT
X-Gm-Gg: AYBFou016q/Sv3mmr8YG8C/CPs3GcyHTNK0otpV5NsNMmN71oKNxkXfY62ie3hVNSmn
	eBfFSDAUvRzzWYpVPiDIOcENbcWJ/bhoPQP77ZlOkNnxSlsUZ4eNWEGkfw31sL8SNJKosRNyZdr
	2HAdo0tvXFxjTIas9SF31ACXZ6MpXrNUbdGRrwRcvwK34Cp8x0Prr7dSafgumCEARXDXPYjGu8Y
	oPayXxF/L+jNBspNnLxykByQaLbNLg03nkLXMo7Yl+Y2H+HOKkZiEPoq/qMg6sdNfmuefHPZyzd
	+cF16v99vr7Hbp8ggON5fugREesJHBP8aFskMtvjUbFPrlD0RB0JtfNgp/Fqd7dBYAdvQ/6hNPR
	2h+p67eR5BNess8S+34KVKykPRXYyjyytTlRkB10/TVKWSz/pYtv+1Mrlf91DajAFbrFzWeIPoj
	e8v1akdTcFkDi1WmR0LVSNqvzjxtVVElkxopBYfee65EilRHhXnXI0moRhGH1nGhopq/uvV7EMG
	KY=
X-Received: by 2002:a17:90b:4a82:b0:38c:a59b:5189 with SMTP id 98e67ed59e1d1-39dec05f681mr5602152a91.15.1789397037224;
        Mon, 14 Sep 2026 07:43:57 -0700 (PDT)
Received: from celestia ([2402:1980:8858:8cc0:7bda:d54a:257:22ec])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d994d8af1sm22675307a91.11.2026.09.14.07.43.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 07:43:56 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: add short circuit for esz<min_region_sz in damos_adjust_quota()
Date: Mon, 14 Sep 2026 22:42:34 +0800
Message-ID: <20260914144409.4592-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260913162046.99109-1-sj@kernel.org>
References: <20260913162046.99109-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 90576140011
X-Stat-Signature: hnuwso9mguu6k5b98d3ow93z7h31x53b
X-Rspam-User: 
X-HE-Tag: 1789397038-596371
X-HE-Meta: U2FsdGVkX19NxvioFAbKZLGNyZcjMeSdHyxVPeo3OX8hVsora5nAkg7X9lFw+4k+6HRcc4+ciN1zMffcSfUnQ/Gt0yknNsbW/CcJsJoFSq2cw4Ewv9uVwv5INcZqHEUhKFtGbuoZCz4ZFpP0QIYUEcinucptU0AzH7b2/UtIhtOVD0LakNKv6Xsuz6iVukLudMkjvtgbjkKbt8wm9ijTmDuh35e6+0OnrvwjbVQ5NDunTfytilQNPElG51E2wzlUufUroRqiHxYvIC7AO1YgiGxs6Z6G8DNrRvUo/lgUl+xMi8+js4HKy//gEDe7TCwrU+vKZrGNyxOMjOAjRIfuVf/DRtvq+vs68MgrQoNgsmIoxA1PU/A1tlfCypEzLwID/uUbKdOcbsvt5ai+9mb3801EyFP0RjAmXMM/T8y6buRlNoyWmEZNHl7cNbhgNRy1N7Q/54GIrRVosqYsq95ZF+y5B3rBvZgRUqqpKkDY0UzhKZhP6OL0A8GFGh81TkWnJgWyKXIIz0jk2Hjs3uMk0H/8SeX2s8NXOgyP69m9tIpqlSnuQ7/7Xo5ttSnikZYhHxd9/TXG41JKOcwkc87fr0P01MWlFuto8gsu5qh5UOan4q+f2I4ECSheWVyTYCe1d3Y8hBI1yFNBznpEuYHUUrtTPU/Q4a4FahR3utliO19m1aFO6o+Ap+7YueuJGQDrWjdfp28E9DxhyYvEvbQdWmqhHzVmglX7f6+bH1r+1K/MU2FKcTr0X9vKepdkd8kRp2JKI19odC0k8Rxzz5bOPJmbNpSZN/VVxV7/ME9zdxjVb8aWr2f7pLoFO86MA87b8PoTlDfU+DqjSkPWJLo9Q28XmB/6Q7zKGNUvgQgC+h6KSOClUzqaAm6PbqmXpBMeKj9QIz/SEl/L7oh1+NQAqVrHxfK/MomldVQksu9YGVHeutUOzbepRU9aP0HEE/PhVytdc+RbVj1PXUaADEG
 yznCOeWn
 Yt7eoP0Nv/UhavfRooqFCa6dUH4h50kD7xjnZmjUjks7WjVwBqRqbFYPvFFcSONxt7mj5uE82MzGxyurZdJJ39rkLmbqaDDnPnFT03qHv6/CpWbGuADXVrIxDqPh6L/djNc1Ke4zHTyhTZU56Nn33YK8ogEjw4yhWIPScnfuImS9hO73Ht2RKicd/EPpi1/UrFcPMnbKTk+xkeDVQx9Cz+uBIMxpFK/uVIEtUsuUk518/zKeWw3ffcXlXBM6WEvbX+SNoiYxhJSC1ICp8BC+i5KJ2Nbjbpih8briNxswnz42nHNgBpjgt9KkxwyBGo36lRKEGNPOIk2Ni7+Uqd1bV5IiI2KTokPUmjqojEW3f2XKudgoUGO8JN5gjLHgeMepiF688fb5JBCywa0T0RtZHUcxGk6d+ddAUkjZR7Nz3gc+siKvpUfpbE/OHWTPChQesykCGKDZGvivW9mwJ3eQaiT1JZ+b9KJ1xvo7QVtCQRb22Ry9PQV8PInqMgz+URzNlqBmE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 13 Sep 2026 09:20:45 -0700 SJ Park <sj@kernel.org> wrote:

> Hi Liew,
> 
> 
> From the next time, please complete discussions on the previous version before
> posting a new version.  For example, in this case, you could replied to my last
> reply to the previous version of this patch saying you will accept my suggested
> changes and wait a reasonable time to decide there is no other opinions.

Thank you for your guidance.  From the next time, I will reply and say
if I will accept your suggestions.

> 
> I think the subject is not very clear.  How about something like, "skip quota
> score setup when quota is full"?

Sure, it is shorter and more understandable.

> 
> On Sun, 13 Sep 2026 19:01:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > After damos_set_effective_quota(), the effective size quota may be lower
> > than min_region_sz (e.g., when the temporal quota goal is [over-]achieved).
> 
> This sounds unnecessarily specific and doesn't cover all the case.  What about
> 
> "In damos_adjust_quota(), the quota could already be full."

Agree, that makes sense.  Since users who is using temporal quota
auto-tuning should know what happens when goal is achieved.

> 
> > 
> > In this situation, damos_adjust_quota() will still calculates
> > quota->min_score.  However, this min_score will not be used in this
> > window, because in damon_do_apply_schemes(), damos_quota_is_full() will
> > always returns true, preventing the scheme from being applied to any
> > region.
> > 
> > Therefore, add a short circuit for 'esz < min_region_sz' schemes to
> > early return from damos_adjust_quota() before calculating min_score.
> > 
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> 
> Assuming you agree to above suggestions,

Yes, I agree those all suggestions.

> 
> Reviewed-by: SJ Park <sj@kernel.org>
> 
> With the above assumption, I modified this patch with the suggestions and
> applied to damon/next [1] tree.  I will repost it for mm.git merge after a
> week.  So, if you are ok with the plan, no action from your side is needed.
> 
> Please let me know if you have different opinions.
> 
> [1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees

Best regards,
Rui Yan

