Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B774CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:14:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5558A6B008C; Tue, 29 Sep 2026 09:14:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5066E6B0092; Tue, 29 Sep 2026 09:14:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41C6F6B0093; Tue, 29 Sep 2026 09:14:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 128CE6B008C
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:14:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 886D812047D
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:14:30 +0000 (UTC)
X-FDA: 85266843900.26.56F2262
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf10.hostedemail.com (Postfix) with ESMTP id 93B88C0006
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:14:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qOgIyHhJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790687668;
	b=d8e/J1oHodCIt4gaQI4Ag6diqdBmSK9VYVDgcvUq42vImPs5XRSgKSY8SHkdQR8VbpbEtB
	cLsnbPv0g8pgPLi8zCPuL51EB+/NXeDSJL9oZ3Mp78S0Z2TJp7a8N7x1orwXOvF5MXGLUX
	P98YYoyjcvJl4lD/f0uL2Vx2+S8fLiU=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=qOgIyHhJ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790687668;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SYRpRMxccbtbpG1laeX3wfTBykfDUuE+jqqX7h3vEZ0=;
	b=jG5/tg+lJkfsVB4iptJOZY3okNB0g3SSHYXo/qNTXrObgYxumvCaUXsryzUhjdzJxn+zcQ
	XscyGjn13Jl8aLiQ17UZaZ5xd11YnQKZYlxpK8IoyWsOZ5ehRt8U0uYcYy0TAjTG3IQhgM
	NR2/whggydcL9raIiuJo51S7xGFL5og=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49b912d37b6so22801445e9.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 06:14:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790687667; cv=none;
        d=google.com; s=arc-20260327;
        b=duNlp8ynhHneFbyzmP/BawoPM541k35sOpB2LJm+sTfx/rNyqclTn6/zoNXTuYPoVS
         nbAB0y0irHiZtVSAq3pFSqZX2yukS5IBo8RFSMg65BdyrqfmshthFWBB919CLrMVnMlG
         dFTZNmHxKI45DjzPkP1LDccnlZsaPNHTaJn4D4/JxuNEEVyMeJztCHzvk7mUMxtHSoRt
         qwEC1cadCDeXwLPgJrACMfGgzMIk2NcZ/WvCe8rBc9BhECSEKyEpyiB4PF80ahPMM5wb
         GoXCs7ECQcHoHKPGhsZCSlI06ltjXpKc3hhuiMf4CDBTppPBNddGmuCMGLcQ++SMvLcG
         mtOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SYRpRMxccbtbpG1laeX3wfTBykfDUuE+jqqX7h3vEZ0=;
        fh=W5rx6LIgw4lBGNGxy1ER8nSV3TSt8F5jyN4sHmBydQY=;
        b=TjeLthnNC5C7IsqPiTo0T5o9ACphyunRhffsv8KPXFg7CjAKcuwPl+rE5Pr6uogiQe
         DShTL/r8W9MF/b2mRQUQUxSVv7WVlP8i/Yp6QnodGI3TGvT+4IqjrkuVyTS4IWcvgKsE
         gYrqWBKZjdVUxNNwz+981VpxfprKaQ785wX+/qvGEEb9Qa+aEolpEUknnaboUBQZ0eQN
         I/ctM77D5h2YoY/Uy/ZVD/6ek2GHiGQSsazuQ2Nnp7DxwJj/pzwtomMiBWnhbU9YChBQ
         X0FYF6PJeWxSWT5JCAioUNuJxniPU21cmnW+2wY4JUYxTFspw2bGA+vpf2LJQjf3toMJ
         Oi8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790687667; x=1791292467; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SYRpRMxccbtbpG1laeX3wfTBykfDUuE+jqqX7h3vEZ0=;
        b=qOgIyHhJp2QnQsrO6MpyCg60NC85hcjvYvU8f5ysCWSt5J22EDxjsNCw5SeHMIagLm
         cDxM/Ziivo8cMxJmxJkU6LOOp4tjNfi01oICNMpTRlrOruC72BmU4w8PQLPwl6X9LpWu
         jq+cwM8IdJ3lI9bUQ7HK7d9g580Z3RqNHSGPOUyER699j9UI4vjXtBPCNEGHk6pmJsFt
         5hlsy0ZBSTMeGxowYOscv8mP+ZPvORBxJxst9Uc7/jHi03dCylrTdYcrO83Oroheb+o+
         VTSGork19HjhCnI+fAaMc3sXIO6EQ/Y4ewvSfm+GZrq7Xnx+4t8SxYYf8GhbjmqKKLwR
         KqWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790687667; x=1791292467;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SYRpRMxccbtbpG1laeX3wfTBykfDUuE+jqqX7h3vEZ0=;
        b=wBhe5oUB/8LrzHt2LoQHS1TKQllZ8jHOa3RBwgCDSPKwJ35nLdhqfYp7NMMHYC/nzW
         sAtNWH78dHKyhrfHXs2xDSRPTnHvjBqIAxFdvJLk7rfFBVh89YZVbRETOSYU0dEq1Hzg
         9Y9FHRQF5epoEU20VBXmJOxI400xVamFFFCpxaKqVpZKVU/bN8RoGR/T/X+0+AevNrYy
         J1JnSmE8SCbjoXatQfW6Us0jqMB+OxBWrRsQyKXcWci519FgFs+QaPb+cFZ77jhvG+ar
         O9c9h2fkoPuojJ0Tlyb2eCyd1Usbpusf0vmHAy3bW4A0oi722J5qMtrMVjVtcc2P6m84
         Hp3Q==
X-Gm-Message-State: AFuF++k7Ld6p0Mc3bvIM78nXb8dw/XUZkpR83hU4zCaFmXxMugRuca58
	uu4mO6d7h63psOYq5ZlH8fD0td0Csd88/r0Y89HNS2Kz5Ps7AjmxLcujy4EdLIh82Zr8TDwwA5C
	OZFask/h+yegd9Uc21QDVtasloOUvpUQ=
X-Gm-Gg: AYBFou207oc14WdVKgMRr9wqWeX+B7BsVyZ8mZIAQVla2XyTNvOT8zhom+wGHGYqQxC
	aLUk58YWXoN4/WZHBkqSwd0tV0M55VYVbpofQVaHUn+YPbPrQHvQS2Jrr3jmlLv03w7KxmIZyvq
	d+4ihAapj8GI+jCQhtnsts/giqWQJBjiVWEkukrnCd0C0Dw5albCNtKG5ETXfoVKCCTJiXGFbyB
	zmXs0eUxbBkwiAt1b5IOVGdJO4N+O6KM1rKZ0MKIIuo7PcNyUuj08c5xbYAvdPR+4UR5SVeMJqa
	xqM05fAQJ0HKZRRffjGPEetJgoH338vnDq1B1Bbe3xzSHjmFm1iLDMw8APsMvPZ0mPr99SPigYM
	HC0c0iZAyVwjBKNayWpunJBzyjh0=
X-Received: by 2002:a05:600c:310b:b0:49c:ee20:e787 with SMTP id
 5b1f17b1804b1-49fe66c8959mr264819315e9.1.1790687666921; Tue, 29 Sep 2026
 06:14:26 -0700 (PDT)
MIME-Version: 1.0
References: <20260928081900.4187482-1-alex@ghiti.fr>
In-Reply-To: <20260928081900.4187482-1-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 29 Sep 2026 14:14:13 +0100
X-Gm-Features: AclHuK-gHF1dvlctEtmdSR2RHiaD0wcMX6yQUH1GuqMtNTGrIvszFdFCGGkiTPs
Message-ID: <CAKEwX=MzVBTF46m6qBedUtpSgZFksRNonG6Gkw0kEMaCF17SBA@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] mm/zswap: make shrinker writeback work with iocost
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-block@vger.kernel.org, cgroups@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, 
	Josef Bacik <josef@toxicpanda.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: n9xycs61nbck1sm6poozadcrzpdmssjk
X-Rspam-User: 
X-Rspamd-Queue-Id: 93B88C0006
X-HE-Tag: 1790687668-2370
X-HE-Meta: U2FsdGVkX1/+Ir8R+9PoC0//hfbjjeH01vZ9eaSNQhMP0qqEiimyNYcN+0MwkhM/hSe0gZB30SyHutQ53XDYjnyOYu7TvZqwGanv7LV4Uo+3rOEQ5N0A+O5E9D/X4j628X2XBjBD4gy+ijPcMUYbYvefOqn3a2t3km9CKwZXCezayqJroEE0ynCvYFmKN+/WBlD1aoZpMkCV0LS/BP3qRlC7ICJYBb/uEVVCAqkYo6YjJ/T0w/lzm23orxjRMf6nGwWjo+LX0+on1Uv0seIZoHT6iUm69pw0mGiA6Z6WF9MJ4teQbWsjzUas6kc8WPe+NqSVqEhBt5+3yr9Rcd/WTgHCk23YALOeSt9VuWcJYnw1ZcvNk49S0jf9oyA3EO3yOtbKYcMYi7l4svTJ2MIgb+87ghX1zEBvZJqRYycbHTIxVsSvZbljSG3eJyq/XIVM3OmXi6u7yHQ2GmsbHVUsedYOR/8/Bbc3wCxSVjhRocGINhlyAJZQN0fzbq96QUaPbUwzSHjEVo8nAkQbRHN/L9NRg21oDHGMQdDJpWfQr6eSPNYO8wulsUCbGoU3NGU4dCVDPYU18Kp3P+0rvVRE1NF4Of6JjaeJiGq9gGJuz7OPVz9DLCavtUKlg7ilJiQCZnnM9kXOBNPH0fUz8VYzONzBFOR/Vbx+KFh63vyuzfeZjC2IcrsjgJ8YFqRfwjvzCN4k51FwPlSqjy2XI7mJVA828vsLGMiU97XA5m7ympFPqyEF9WMwDp7a3wcMVKpWIIbMWnxIfYYQQdeza2N0DvYL3GSJ3jSPFkcMTgGE7WR53h9SCQ+8yaPy787BYijKdliqZiLQ4JaJfAbik38FWJX+jl2E07MrYdA8JBcnrHG7DexdqEgB1tX4JNTtrai78nS+eOSsG8/MfvRmFVwcWZLI6e1ue3ICrszPI7fXpjy7JmP9r2Y7VijlC2tbji1+F9tFtC+KOucd06VfaF+
 LK9XEaqu
 cH1Z0kqwCZlXwBNfU0c+zAsV8FnCvLdndwOxpeedTGh9MqkGOc12kDXeX3KGW4Reqvc4Xk7dkNELpOahlps4/ItgYCg96J6QVHFGdeE7ZSwiBJPa8rJZyuR1EdrYeLSDGQZK+agtyDCUgEfRea1/oMC+qkg9jf4+eEIBJcgkYUAYswwKQ23Ya8gSyUEAEerRJnz/cAxX6K0n2wP11aB2FWtjOA+ZY0PUSSvTcHJztGCdGD3mhwEzU7ZbsIBF+d1i2yGMJJl6bh71yoK6dPSbufmNRVjfdfY95k+hztCs0QiwTJpkUr4ng45xNgXPHqNGQZuQOYR/SP5w6K7Pk+bXO4eu397xKwCC65wkvfIM9fMEu0K6PXKhdLGzaoOKUKjaxEjPNoHUZwHDSNEOqrJYvoRwRJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 9:19=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> We want to enable the zswap shrinker on our fleet, which runs iocost,
> but with it on, a large production workload is slower than with it
> off. Two reasons:
>
> 1. zswap writeback is REQ_SWAP, so the IO controllers issue it as root
>    and charge it to the cgroup afterwards, as debt. The workload pays it
>    back: its swapin and page cache reads wait, and iocost eventually
>    stalls its allocations, which in turn stalls the application.
>    Patches 1-3 let zswap writeback be throttled instead, by marking it
>    REQ_BACKGROUND.
>
> 2. A throttled write sleeps in its submitter, which for the shrinker is
>    whoever entered reclaim, often an application thread in a page fault.
>    Patch 4 moves that writeback to a per-lruvec kworker.

Yeah that tracks with an older experiment of mine, where I add some
manual throttling to zswap shrinker to reduce latency :) So I think
this problem is real - thanks for root-causing this, Alex!

I'm a bit nervous about adding multiple kworker threads though, hmmm.
Per-lruvec sounds like a lot of threads... Do we have to scale this by
lruvec? Why not per-cpu, or just a global thread? Is there any data to
support this autoscaling?

And do we have any concerns with work (CPU) accounting, from a cgroup
perspective...?

