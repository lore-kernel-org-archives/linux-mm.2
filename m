Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7393D607DC4C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=GN3AUQf/
Received: by kanga.kvack.org (Postfix)
	id 21A2E6B029A; Mon, 19 Oct 2026 11:03:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A5306B029C; Mon, 19 Oct 2026 11:03:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06B6D6B029D; Mon, 19 Oct 2026 11:03:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C557F6B029A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:03:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B92EA0769
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:03:33 +0000 (UTC)
X-FDA: 85339694706.02.22B719E
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6F0B540008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:03:31 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GN3AUQf/";
	spf=pass (imf04.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792422211;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKFgXAWOd0iYwNRMqtKFlgfZbmk+9qhcBIiWIQuiCC0=;
	b=EWGISFzOiH/T2Ut8UM62B5rosOWFd1/EIBNg8nG53z9+1MAjQ29jqurt6iHRjRF7GuSU1r
	+Q0WQbhqXOWwDfBKRm1EUG8PMRGbuVWkykaCER9sawlAhoNSCh4TvnSXFP0ln1nDDGvLup
	D4qq/Pc7JwhpA9LCv4ppIub5SfLt5a4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="GN3AUQf/";
	spf=pass (imf04.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792422211;
	b=OjhTx8IHyYKGAYKqRdWmPIeuVdMrS8l06B5GKRFIcA8ptlriDL4LrQ1bwgBqngfTpMCjAZ
	9yW2Yo0o251i/BigrVc/Y4SgX1kmtAuQWRvKXfka9wdKbs0WjgDhkQb5NAnUBi/b3jGDjh
	26M5kHwGOf5xnc/SwwU76Zqyr3rc524=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-33bf40b0c8bso144316eec.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:03:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792422210; x=1793027010; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kKFgXAWOd0iYwNRMqtKFlgfZbmk+9qhcBIiWIQuiCC0=;
        b=GN3AUQf/sOLzUPctm7thcEqHpMRwKp1ZhcwcqVPmYwsHP+Y02XTazFmsBlGaQ+G/Xq
         kIfhKIoFxSp2ac/dwkeltpyY0/P3s7RyqgbqJ1kSFIqv01es4Rh435D81j8CWIWqYlF2
         NTJNU1G/Mg1gPzLalsKzMijhzMcZ8naeGUmzAfAzEhqn/ckn2UGzS5QCbnq+xwhM708p
         THRdsrylZRBtVvTavVA2JpqmeAzBHR4OIDCODHnVnTlncEutIO5PX4Dp7OUjIIrtJkTC
         hD6vZcMWmfw1KskMwZF/WGb0FkeBNW+4AHOePFY8F4gnF9CrBLH22s6mfEh9OANZiijZ
         nI8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792422210; x=1793027010;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=kKFgXAWOd0iYwNRMqtKFlgfZbmk+9qhcBIiWIQuiCC0=;
        b=thEU+WmrjinhZvO2i0x965d17SC7etbhXffwjSJvRJWNRUuTBWSVVmHrIFQCDHKiA0
         1jdb0YzgfEdsIZldgv9zb4Qm1ykYjR5oANVnuYerlg9N4C4o0UzlMV+EwqKTc4JMyDq1
         CwueLcTWTi1kEIWDqkWLpj65/slhXYBxkma7phg6w5ResQn2+j9hmJ4NANsvpDNLX3Yp
         mzRiRwNKgiOgxcsWuFbqN7YgxLLrsXTOEDndn94cYzaNJcN4NgAkk69K5OcNwQR9RTRD
         it0/8tX20bZt96+Wh+XpBKaNHERsM8QPZrXQYR6Nug1JE+oZ646+NhmWM69Py+7uHYiV
         410A==
X-Forwarded-Encrypted: i=1; AKwUvBz1hyz2Y+pdKPjHE0BuVSn1bFcdZjzIc59s0qrFlbYZj+vDcy5IsSPWcJF7i1fZVmEq1adgi4TjFA==@kvack.org
X-Gm-Message-State: AFq9FYIV42aabmr1/D5UlpVXd6g8cvaEEFo2Zu1w06i8PzsDzrHutFWK
	UbX7DzKODLrZ3u1chSA20kqcv4nWGXDzD7Wdw/HnWlOgyx3FFNf7y9GW
X-Gm-Gg: AYBFou2dXgFPfyB6wM9HvtXJGitszwHGlFtRH9Uvvyf4XglR74cOEPPg1VNetW51cMT
	Rp9BIKb3nB+lamR3o6zrt7aFGAPEpdatm5sW9qKZY7UTY8YX9PmgpuWnAIbsF9d4VzJVVDYVm/P
	GTq85HX4cQRIOTluMO+NJTqb7mMRCzNNKK5CbFwMzy9WOIeeUvYJsQQJzSXzC+OY8xUJkWldZvL
	zKo6PX9TQAk5E4goOUdBkq+ub2Y6K5SXAYnA9qiFe/ofsGmpW53N99Kn3EG+5XV8cOiPeGnwru4
	/hihqMOmCrg4jtd/nyc1MjSKrU8Ihfe/qonhEezAf7EHW4d3QH3Q9OHW1/u5z7JyBUMR8EQ5SeC
	KyXTfx5SfhfGOlLZpNDP66F/HWdsg4/ZaMiuo7XA9FC091sU6431nMEJrvFo3eOidhr6WNEEgSn
	AYJxhZcXnXMnABcflNoB7NXpqO/D6Go9x105CR/UNM4vaB1z4HqXRDgUrK4rpdn3WHcauU/Qxfu
	q+K+Bp5kWgeMTCFYgftPQjGcQQY
X-Received: by 2002:a05:693c:87db:b0:35d:9516:eb26 with SMTP id 5a478bee46e88-361a1366c56mr10050323eec.13.1792422204963;
        Mon, 19 Oct 2026 08:03:24 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360813b6e33sm34648900eec.7.2026.10.19.08.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 08:03:24 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: dev.jain@arm.com
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
	linux-kernel@vger.kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [RFC PATCH v2 2/4] mm: compaction: target mTHP order for proactive compaction
Date: Mon, 19 Oct 2026 23:03:15 +0800
Message-Id: <20261019150315.2018934-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
References: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6F0B540008
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: 5ezns3qyusf49xgkfg55nykzax5simt6
X-HE-Tag: 1792422211-772655
X-HE-Meta: U2FsdGVkX185V1kPEIOajpBsM42/Ov3T1fOb/WfinXjVBOtKtqPZDwmYifI4BgIj0rQM4hNJoWEKy1zlHhhlhkrmhnVcqsj1s9Pi3D6sLV3hO4vvoBDjQLAPHqq7cVpk92xBPRBLpar5Z48QFM2wlqkO1DwUjsBqX/i7NtyfsIUvKbSw3VGzZ9enq0PBorsRVnbcDoLZYK/YVDVJGOZ26CO76qyl2GWzpL2c8KhsGLQ1WZCy3CVYeLVoYHuHLfVkHzRFxJ3qDURVJJ20CKau1rA/Ac7Sw+SgrWjgOY8WUtDhSQfpIP4JElKCGBa0xGmoTfQovU0BTyElhpFJGTw9zNH6f9iaMT+sA6HYMcF/OQxlkGqtvcJYRcKdUIFNssnU++YZ9E8fh8iAZeX2zSp+rhA470a7DP8xfzXcG1i0Citoe341RyHNl6W2aj1+6IlvzX5GqzUCM4g378fobp7jv5IP4HLTYGR/jXex75J0zWoWiBdCIi/LW9LMh/EDqcwT3DOhBwDKrzwj7wCqCYaritkOQ8F5XV5bRpPeflvxWO+XIeftlryocLqkX5XST6PL2HpqvzS6k7gAtlSEEP9rozwyNxFRtww7deFRI77lDeGhozuJUbEB8Qp66v5qhp962hc00m68Zmp59d6JcfP5XnUvFVwcJGxO+wGgeVmK0sV49+qmk+cRLpbcSY0Aee74vQJz1CAW5SahKSe8FQTGNnpQlBQNromRgBSJC2coq3eey6roJKZ6fbOQpvAKsogpLRAQHwf3bmqjciywlEz4cUcSXzrogYRCIFpZdXzPKdA/L3lrWezv5YGg4JYOPoJ3d/TaxCyA0Zs8ulaVBeH2ZC27THNKD77AV22RJlx6c6ZC5KiKivUL652EZm3DK2Cku7bAnfUrPctQicByZmQftcY2vCNf9nmQuFVxTgpwGJ40e9koDGKr3SDY/OQ0kHdylWPF9NpUMptL3BRgb8U
 jxM3umWy
 4P50INwz/IXUvRZzRrgfclUsHHCQDwz59oSNlZXHSiX8kJ7hcJKI/OiNoN5I8x3g0xtylrdl1kFfsA7B0188D4pGlr96EQK88czrMqP99qy7G4KF909HC7r7mGTXcyYFDFvNP6RfzHNaZ/pf+bDDCTap+8gZdYrvTX7ucHb+UCT/TtKHW1BFaUgW89UTWmOfPqgUF5V0bFh/Ax1C+AUJghTdFIMSmb/Cy7HerBD9P+dB2UlOcvj4Db7cuAah2rB8NMj1veUtowM4Dop6P0tUdgT+/HN34PLL6Vvfybd/Cfxs/CXXAlqAeKbzVlTOd+f0x71RHPPQ8g6aKBSxUBAcge+WfYrfeuMvvNd7A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 19/10/26 1:42 pm, Dev Jain wrote:
> I wonder if this function should be left alone?
>
> compaction_proactiveness, as I understand is given as a sysfs knob to
> ensure that the user can control how much power they want to invest into
> compacting. So suppose the value is 20, and the highest mTHP order is
> only 2. This gives wmark = 90 * 2 / 9 = 20. So, even if 80% of the memory
> can serve order-2 allocations, we will still perform compaction for
> order-2. This seems "extremely proactive" :)

Thanks a lot for looking at this closely, and you are right that the
scaling factor is the weakest part of this patch. I called it out as an
open question in the cover letter and I don't have a solid theoretical
basis for the linear order/COMPACTION_HPAGE_ORDER form.

What pushed me towards scaling the watermark at all was the opposite
problem on the measurement side: without any scaling, the order-9
threshold is essentially never reached for a small order, so proactive
compaction effectively never runs for order-2.

I instrumented fragmentation_score_node() for order-2 on an 8G,
data=journal kernel-build workload and sampled it at ~100ms. On the
unpatched kernel the order-2 score looks like this:

  order-2 score (unpatched, same workload):
    mean      17.3
    p90       47
    p99       91
    max       100

  fraction of time the score exceeds a given threshold:
    > 90 (unscaled, the current order-9 wmark):  1.0%
    > 20 (scaled down to order-2):              27.2%

So with the current (unscaled) watermark, the order-2 score crosses the
trigger only 1% of the time, which in practice proactive compaction almost
never fires for order-2.

That said, your example shows the linear scaling clearly overshoots in
the other direction: a scaled wmark of ~20 can keep compacting while a
large fraction of memory is already usable, which is not what the
proactiveness knob is supposed to express. So I agree the current formula
is not the right answer.

I'd appreciate your thoughts on the direction here. A couple of options
I can see:

  1. Leave fragmentation_score_wmark() alone and instead make the score
     itself order-aware / normalized, so that a given proactiveness value
     maps to a comparable amount of work regardless of the target order.
     This keeps the knob's meaning intact.

  2. Keep scaling the watermark but with a floor / non-linear mapping so
     it cannot collapse to a value that triggers when memory is clearly
     sufficient.

I haven't settled on either yet and would rather hear which direction you
think makes more sense before reworking it.

Also, thanks for the review on patch 4 -- good to know the
costly/non-costly split seems like a reasonable compromise.

Thanks,
Bo

