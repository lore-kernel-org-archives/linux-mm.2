Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD0DB608749F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:48:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=ARTmqlMc
Received: by kanga.kvack.org (Postfix)
	id D1CA06B02B5; Mon, 19 Oct 2026 11:48:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCD736B02B6; Mon, 19 Oct 2026 11:48:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD226B02B7; Mon, 19 Oct 2026 11:48:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 903C56B02B5
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:48:08 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1C0C6C0743
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:48:08 +0000 (UTC)
X-FDA: 85339807056.29.AF3E50E
Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	by imf14.hostedemail.com (Postfix) with ESMTP id 41517100005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:48:06 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARTmqlMc;
	spf=pass (imf14.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792424886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5EEixkvcwcspzICRMAZjL3IuGJ+enZar5rUD2PHfTo0=;
	b=lTFwqeK4DqFIaWqi+YVwvTwflplaGPr0dnQwNDzKQCHEQaGYUu8RhoV/V0OIW1OJNgY4qZ
	MKmpqbXegtaDUwkbamwTtSKONXUzFuM7SGPLRFtr9Z5R3wSa1TD7YB0KLEs5yNx1KoSOAs
	grtKGgVMExdEelQc1M2Ted/Aprk9ZaM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792424886;
	b=6kVlawpLodioZe8X7Vcj3s/xTDuNPrczd82H2C2RfXuBV/16wEC7IQn0B0FFUx/TA8C59Z
	SMdcQJxoNVMsIlB2nwCE60eW59UNEvo9/t29hsQO2xMGK03um8NjYhfZU8JxZR9Vi/zrJr
	bdxxbtQ1h4rrzWVmGrvHJ9tdBTzalWs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ARTmqlMc;
	spf=pass (imf14.hostedemail.com: domain of zhangbo0325@gmail.com designates 74.125.82.174 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-35943f55c06so3396958eec.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:48:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792424885; x=1793029685; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5EEixkvcwcspzICRMAZjL3IuGJ+enZar5rUD2PHfTo0=;
        b=ARTmqlMcPIq3WiMXIu3Uj5VZPmNAbg7sSNjjXhqDD5iIGlA1BPGGl2wpmTa8TzpYBl
         dFYoJz6RLapS/zIbm4Fq6DUi+zo10RK/FpCXeBaNpkdVjRxGckakqChID0ommmXu9YL3
         2rB11qCp9EJ+a0hg1TA7A8YCVlgvjTzQuJISlZ8OfFWmCdt507qEqmNlZ+4BPjkPAiXL
         gXxFEa33m9723MAcR/ImTPvOHCnLayy/a4Rl+TS6VB2webA6ANttv1S3HyhPRO22Ss9X
         hgAavEeKrSXdBuaZF517s1EM5NUqr7p++xqnp9cyGA+qTubu1H1w74PEgyi3SS6H9UX/
         AW8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792424885; x=1793029685;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5EEixkvcwcspzICRMAZjL3IuGJ+enZar5rUD2PHfTo0=;
        b=hzNcIJnjOlpJM/pb4VaCQEQQsQQyqEPAL7rvUY4heVCc22fs0LwqksMbgFjb+SjMQA
         ILlnkCbxzkvpKJo4XDnBkoTknn8LpQcylcKtyfB8N0X7D1gvjh4cirmbJtBa73QRfdYf
         Wh65ZfNxTjp/0CdhegS+uwEvH2DS6+McGvU2UERSEvRj5FRfvM0NG2swCSdel7fuOGeX
         NZS+NH7E1fOg22Lhp0e/c8D50THBP+0anQW2SGzEXC4ClrpZ2QAtkp/bJYwc1wfFBtDT
         89ddQlkYEvSyDrsX2wcjDyL5NILupTPKtMChITzdHVZfZkRp/JmS7kvsujPKuvM8fWet
         Qjog==
X-Forwarded-Encrypted: i=1; AKwUvBxzu/6N8f9Ioo9JR8vslLIgdxVX+Qb5cPHDMSCfYprqGWf9mJq/NC1LvrKdT4Pv1QfxECe3QJ2ecQ==@kvack.org
X-Gm-Message-State: AFq9FYJDh5OXne+B5kre37bhgVsfCkOfGs6+saZzF43AAe9z1gvIeljE
	Dq3ecYuxwZJgsS1CSsFG4T/ds+UX374Imwsc0O7fAki2XAB728lZUtTJ
X-Gm-Gg: AYBFou0duGIb1Ji7JFVgEN72+2u1zrVGbjZskHY46XLQ5SIn++liw28iQipL7tYrZSU
	Z1pybDoTHrNaH7vKDIFYebsUMpwUQikVhfdKABq26hLU9YIO9Kes29E3qa7SqB8+DOyAwlMAeu+
	qqik/wzpof8tU/UZ1lmUhIew30uOSLivX5YFQ8HnSoiRc/iipOkjN2nbUVKenGcE4pAH2Teejty
	EEqq8Z/KGS6YsVPyhJBiFYRJZgTHXvvkf2jV8OFKQmPKE76LxnQeIYplMHENEfpch4zXz974Qqf
	9VHA1YmxOiU7wUHErmXVUgI3c7wYbfaGAaR1CtJoMH2+47symFMWCiqR7IVwAALhDoSjI/+f1a2
	lhN8HgTj6U5q3VTibSVn5zknBKKG81PK3G5P1WK6U4nQeC+KfznG5jU+/BlW/UnxcsPzWTI/tdl
	VWD5OecMpkawbk4PXbBmNIujNmb6KjcKxHBcXP+BVSvM4WmC2oMOYPggCChnTbAgpPgtzHVyxML
	+ad9yUYAtT9glwF24P6L/JfwTfbng+NRdb1/fQEnE317QaUJrzqyGYmrhrTJD0ahRGkW+vfrw==
X-Received: by 2002:a05:693c:8097:b0:35d:5e81:1d87 with SMTP id 5a478bee46e88-3602ddd6208mr15681319eec.12.1792424884655;
        Mon, 19 Oct 2026 08:48:04 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-360826875b3sm34946358eec.21.2026.10.19.08.47.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 08:48:04 -0700 (PDT)
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
	linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v2 2/4] mm: compaction: target mTHP order for proactive compaction
Date: Mon, 19 Oct 2026 23:47:56 +0800
Message-Id: <20261019154756.2023037-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
References: <8e54025a-03da-4cba-bae8-1604463c7622@arm.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 41517100005
X-Stat-Signature: g1bd9zjxe6cgjwiefb88jsuuhicanerr
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,RCVD_IN_DNSWL_BLOCKED,
	RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792424886-94717
X-HE-Meta: U2FsdGVkX19kPphGS/cnFSJMfUA9lljYG2qtGcJ6y/P8sp1PM7egVMJ8s0uoUypHq0yg0j+CGKWmj1C9oLkM31OqJl6xsnz2J4WaW7p0WzKDUpwflqgfSb/HiI7Nwc9GXjzYeu79OSf7T+2nveTPKZF+WTQV503lXZZmyVhRAdZZMSn5VE0wu7YcYyevMYf/MmXMRUAcdnw5kOLNlA8vRoNW/lf15qrZ0DoSFBzYCBkTmJI6ZC9A1wX8CsdUsp6dqsgs5JEc+GJWYQavhGaMTsfQ4PNuN8aED6APQPeZOHEJ2GbV8WZaxf9gvdPdzri8GDV30vIOX7vYAFO8SXMdzndRPDyV8qo3MOU2kKxTYcx4FayiNDX8oDUDlrq9nBa7TsifsZaj7G+s94+6g+nN0FcCfPSppwrrG4rik9Xnn/GX6z9U4OvlPUeTsXurnDpgBEta1XtrGVGqZElzdu5yXGKMLAEVRa4pCueIGNpOowy/sJOigR9cZBhtvbh7ejwI+nSfcKo9+HUf+M1fcUrUQXFtJLoEeUVTcb67vjf2I2q7ULwiuiaY7xwwlZolgyqL+8eiYRcixLTcH8F4vw9g+PJELYpUKBEetpv2Kf6otK6fEJDkNJH8jwHBvLlEYkjRAtb8OiRw6/rxqqgZMVWHOzmzZmjBSO9AGGsctAWOkF5guid+zsvHik2wQWMYwzlhkAWAUIyDUP7Q1S8q9WvGgyWq4Z2b+7ZFX6cyYcHBaOQAmoPhM/umRj0JMGwMFmMLgqzWW3pYJ6UsiCmwsipyOZUc2JvhVly1ETlfFuVuYKgm6RAgVx8ULYvJ5M3yyQOF0Q1hjuc+2PsQa0u/lZ/nZTWxXn9u8qemZEyNvwKRJrCIzyC8aE87mpM1ZdGkKvsKAWxoaPIcMk/4wXcDuB8ppa1MuWj6jfaseL4PDWg59uCOD9wRd4OnHLuMnttaPbsPXNj1zfzuseDVz7bCWbz
 U873uUPM
 l4tE9apxYqH/VIFo1WJZPC9sWgmZ5apsM6wWvGB4wQo44Gei/YgMSkHJGgvGmBkHKf35+cL9VBwSnb8GQYZNcGD4qsHJIYQNxgfduxjrAbx/+Vu8wEFHqRo7+1gn5ggHKGtXoSNhHMXARLgXuALHv6l6TX8RW8OiBnJG+3XAhrPChN2pUfNidkNah9Ewd7gODso3qSU/zODFy0C5tsZVbPQPVU582Wld9DscsZ89uJ6fbGMHt7ayelm8kYzEH3HBtT9Eysev97qhd+GXHIuoMF6xk0YZNVq3BsjqPd2eysV/1LvkM36seJEboefmRbDaU4hOUYtz36QJ23bkA0psw7AePstlgzfQExwZ4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

[Resending: my earlier copy does not seem to have reached the list.
Apologies to anyone receiving this twice.]

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

