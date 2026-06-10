Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7121ACD98C5
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 21:03:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917F56B0005; Wed, 10 Jun 2026 17:03:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C90B6B0088; Wed, 10 Jun 2026 17:03:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DEE56B008C; Wed, 10 Jun 2026 17:03:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 708256B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 17:03:56 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0C0C91A02FB
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:03:56 +0000 (UTC)
X-FDA: 84865230072.25.0214E1C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 31C6A4000B
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:03:54 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zw8iaFgQ;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781125434;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dar8A+bLRP/EQe1Ns/CTmjxWxXld8NghJHxNJ9BIrEU=;
	b=fH7HQYaQzapg1e748SE6PgYB04jCSsmSqelRy88NREMxPOocY+NGW6rvpi+BGW7h7tQfiD
	lbPW3PMZQp5FZF9aI94/AAmeFbqfyrcOUwTbOGcYOr5DdY+yrcW6/idiEeV7X9cTJUiHXh
	JSefuUDt29Kk5+gnw2Al0VbWH0/bS6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781125434;
	b=3VsybsoRwZ35MVjWLEaF3hYxG++2k4xi6b2edOacN3zssqyS1J9Ld4i2V99pgGKOcC5mOS
	GnX1YiHu3wN9O1XkwlWaRCoshjakw3+Y/aQSA+mFyhPZRKV651QWY+Z2wZ2RZnFYDsnrC1
	iYsYTq2Rt4yE2oS2p08bu46gRyGEnmM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zw8iaFgQ;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 59D1F44554
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:03:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 418B81F00899
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 21:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781125433;
	bh=Dar8A+bLRP/EQe1Ns/CTmjxWxXld8NghJHxNJ9BIrEU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Zw8iaFgQNF2CozAcnLP2OP5G+gDTbTZ+Z6X5v2yHNsntvcyeEMJFfTCOCvmy9yt0N
	 QyF2knH5xX1535aWt7oalnIceU9AWX6fezkLujAAqYbYvdR2319XsSQwfG7D/Y+QP+
	 3vr/bJOm3gkxdjXvIPhAIoJCozMV2hdA9VVtz/qfbYHudDwRSe3nvNO93kWIChVkPr
	 A9ZkjK3Ogf4Qr9n+EzKDgW1x5GGh+vGPGss4ASivkW6efrsgOfKCM1kn9TaYbaK6jt
	 CVnl3xnGyii79eAsHFrfYGv9aiexIIEJfJns9gZXVdaB+BuCRYs5g/U9EkDMkRBNsc
	 SKWvbMIqMPDoA==
Received: by mail-yx1-f47.google.com with SMTP id 956f58d0204a3-66077e90382so6648431d50.3
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 14:03:53 -0700 (PDT)
X-Gm-Message-State: AOJu0YxB1Yk/PrpvF2oxeTJFUb4uOD1aOmSgAQ1A0Tgjcfsii4ZWeZMC
	h6cvqtLme3Utl5CTWEL/0tr1CvG41BmOBTMFeT6Pc/rG6ebbPooKDVOCxFliDwKFYH2Mav48r3M
	fhu4QqEy90+DDB1Eo/0P49DIFmXeIL3E=
X-Received: by 2002:a05:690e:140d:b0:660:ef1e:5f21 with SMTP id
 956f58d0204a3-6614f7cfa32mr9259398d50.37.1781125432571; Wed, 10 Jun 2026
 14:03:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260610195220.12403-1-jp.kobryn@linux.dev>
In-Reply-To: <20260610195220.12403-1-jp.kobryn@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Thu, 11 Jun 2026 05:03:41 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wRiezXDhsKVL6WXniVxaBiUdM3hJzWmFiEsUSoyMoRLQ@mail.gmail.com>
X-Gm-Features: AVVi8CehC1XiB3ngHfO_-w8x-q0nG9SowChBmCUs9FvZGYuro-WM66pDETAoNLw
Message-ID: <CAGsJ_4wRiezXDhsKVL6WXniVxaBiUdM3hJzWmFiEsUSoyMoRLQ@mail.gmail.com>
Subject: Re: [PATCH v3] mm/lruvec: trace LRU add drains and drain-all requests
To: JP Kobryn <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, willy@infradead.org, shakeel.butt@linux.dev, 
	usama.arif@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org, 
	mhocko@suse.com, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, kasong@tencent.com, qi.zheng@linux.dev, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, 
	chrisl@kernel.org, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31C6A4000B
X-Stat-Signature: yji659r4ygt6hb6yo4md53wibb8fc8m5
X-HE-Tag: 1781125434-374642
X-HE-Meta: U2FsdGVkX1/0/KpoN6a9AUAJvPgi8pDePB4BQPyOPrd9gKdkmpJ7ycSbMiLU/+gdp6Ry45w8eXQk0ULQDmMHqrZaai4rB+u8LVPDc6/WkDF8QiRltl/kcPDRYseu6b3skplzvbHTvginko1HVzo9Ifetnwip/R77iDL231kDtvdromdC5+KKC2C5nKnaMBMR6h9AgbH91bVOPgUB/A5yeCZpLBUZX9aUpZpXmPIWu33NaKOF8TEAtdQ6jz0ZOdF3YH7pM5KvY6L08ZCzV0JOs+PYs8Xzn4JaW1IG1MOiZIaSE+P2vXfiYZZr/ibMmtxt8iZuDqxBnYAMyVYyD7weY5AizYs51qL72o6Rx8qBtKUh4tulIsgxC1S+pxYpQZM/FqR/G3L+7vtsGTLxH5nf/XRIdJ0DbCE9Ld3U6LTJvzzrfnv2z3XaSwlEmn4FGL0yPKZ1d2RzGmNfLh4vxX1PVyNSWKKER6VepK+FxKYLFKq7G/4KmZ1MwWipwNufpRynrS6MWbuQi8HUkoMd+SBoo507R9czGsI3g96C8pySPOEdObo4V1eEzfzYZ0hLHc3KRRcNluY0Ol/UAt5wsqGWzZiowIjPFMH8COUnBNeHFGbwy0f4W2tRptFtYLX0hiIzmmTEzR/NRt2QpoNhSgvHMGb3Pp5I/v5RFAnPkTTlaOcIre5Ao5u/B9gyQc4T5jXiRQJuzdtZbgx70+Q4czKPj0UpggMoyCPSQ42W9UbFP50xNUl3TLVZlBHAIRWYUvoyJpskiJPTy+QVPi+nZ1J8AIQh+5oFpR6J+tRQBKoF7t86fv5F3vCCsZWL6gsRvrbcf30YbQuV12nYzmIIrHEipSDLr/87o5q8J2zmP3I3tzHA8J3yQuzt/2+nQpHXAptnL8sGg0wuM+SWXccXtE82R07idO+boSQHiLAWXPY1qIHfIUXGpCs6opBTa+Hy1/1rQemBHURTbFYsDcoq3W1
 sKpaGkNP
 ov/g+HmOVwJLvOHF5y8VRAQ4UVzeR6psCuhpjXFooQzvtPgFUPvBOYUMwOGEf/HPVPrmVoWCGJv/3WIMP5NNLFd1EDqmecfOslmT313Go66m5SnAWVaOOq1JcMYjPzUc7TLhGY8Q0eCo7nv07BgO/dyZltCT5P7vL6NTucqn06h0EqHYIq5/TNZrE57TFiQtqHbqN551bxmtcwpchz+g6x7QNlKmyzaqsXFwS5YjIowtDvkd3796aW9reBjNiew0M1pKRLOJjyGoCMOBpSMw4xgQ6e0jBDCUGu+QsOV2nJ27202COLrAxsRCCGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 3:53=E2=80=AFAM JP Kobryn <jp.kobryn@linux.dev> wro=
te:
>
> LRU add batches can be drained before they reach capacity. This can be a
> source of LRU lock contention, but it is not currently possible to
> attribute these drains to callers with existing tracepoints.
>
> Add mm_lru_add_drain to report the CPU and lru_add batch count when an
> lru_add batch is drained. This allows tracing to distinguish full drains
> from partial drains and attribute them to the calling stack.
>
> Add mm_lru_add_drain_all to capture callers of __lru_add_drain_all and
> whether they set the force flag for all CPUs. The tracepoint resembles
> the signature of the enclosing function, but is needed because of
> potential inlining.
>
> Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>

Reviewed-by: Barry Song <baohua@kernel.org>

Some minor nits:

[...]

> +       unsigned int nr_folios_add =3D folio_batch_count(fbatch);
>
> -       if (folio_batch_count(fbatch))
> +       if (nr_folios_add) {
>                 folio_batch_move_lru(fbatch, lru_add);
> +               trace_mm_lru_add_drain(cpu, nr_folios_add);
> +       }

Would "nr_folios" work here, given the surrounding lru_add context?
Alternatively, nr_folios_added might make the meaning a little clearer.

Best Regards
Barry

