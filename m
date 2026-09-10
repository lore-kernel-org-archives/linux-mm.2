Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10EFC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 14:09:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB0E46B0093; Thu, 10 Sep 2026 10:09:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B880A6B0095; Thu, 10 Sep 2026 10:09:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC79A6B0096; Thu, 10 Sep 2026 10:09:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8E3F56B0093
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 10:09:10 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 60943A056B
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:09 +0000 (UTC)
X-FDA: 85198034418.06.5D3A25E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7E3B5A000A
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTz9bHXV;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789049347;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wLFmz93+gGmAMaZJ5LYKKNbOgDv5sZVgXPWj/XZLQHk=;
	b=VNHM29jYtSkDLrDYPJY/Opc3vuEdehVz592vaZX/NSl8gPryHNqTvzwURqqjs3CMsgClE6
	KJiqCthRy3JeP3KxWIPDNABbRwW4C6LaBSMzvoh7OPl8iySeXviaeijJ438pd+uzXJVXy2
	cnIYAfU+fvtljfbDSh9B0TUgrW6zz+E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OTz9bHXV;
	spf=pass (imf15.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789049347;
	b=dtdN6IZH5tECRgytU/aqlO845aOqCOiOztx3nLSU3otVySO9ZFqixzcEifF3j/vvfTC8as
	MQ8TJ1a0jo6mKZUdpZPRUB2koXNSLHb03njnWQd7+1B+1IFholQmwQkJ2YZB+LHRh9XkXB
	Pz3IoIQ95TIAkjd+L0TqaPdt/MMf0RI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A64D741E97
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A8A31F000FF
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 14:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789049346;
	bh=wLFmz93+gGmAMaZJ5LYKKNbOgDv5sZVgXPWj/XZLQHk=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OTz9bHXV6FDtWwtUTzYgnkRxkuCtmZMvKdbbWf0Mn42Yf36Jx5jsV6JWMZM8/5Ae+
	 QFW691KOg9hxy2e0aWg3mVUisUdxu753IlOS1vW3JqnNjuJUGBPAYbvedYg7EO+6DR
	 wy+FCu38B2oCriMOWcYnyMdsMzEkBlKp4+9hl2hjlH6YbcHxkD3l6hBrsoG1FMLuGA
	 31vk7VxISZ5Mq+38rkdg98hiAtQBhQWkYDtUfIP+2a/gZwkLBjmWT796IjfAQbfogq
	 jRVCnLp8ho/9v5h/afQ3yNGscQKuGvIXgGWpvCHl8r5vFMPZqoxHAJQqZbJuRSE302
	 Kdsj1/aHrj5tw==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c28fde3bbd2so738604666b.3
        for <linux-mm@kvack.org>; Thu, 10 Sep 2026 07:09:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzIrKVUfEaOdQaXc8tpRelcGO7FgFw0i0O4HSWNVr3CYOjOZEmWdaUySjwyAjkhGKkNnrDGWLoLdg==@kvack.org
X-Gm-Message-State: AFuF++lj8idlX9K8S4tIGvaRKGpi/gcfs7pzLAVv6R4TGQY2znvsAAiq
	izKWCrPcI78R1ItYWqdlFWEeMd2Sa83FDKhrbLSLAZ9duV/Xq7TgdEFLV7qMnPdy1Uw/TjLKRMp
	ZAZkQ1I9yPHX6PRP0s7Ta1I03iWouXWg=
X-Received: by 2002:a17:906:4fc7:b0:c25:5faf:b207 with SMTP id
 a640c23a62f3a-c260c7ad6a8mr1693902966b.3.1789049345464; Thu, 10 Sep 2026
 07:09:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260910123544.818146-1-wangkefeng.wang@huawei.com> <20260910123544.818146-3-wangkefeng.wang@huawei.com>
In-Reply-To: <20260910123544.818146-3-wangkefeng.wang@huawei.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 10 Sep 2026 07:08:51 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPU9jTuuNdkzN0fJONA48XGdD+4Vb2pknf0JJGKth8fFQ@mail.gmail.com>
X-Gm-Features: AcwNN1XWsUt4oYqe54Bj0zmGaKk7pLnz2SmIAKIqwEZBod0BFkgqvw8MYg2w6lk
Message-ID: <CAO9r8zPU9jTuuNdkzN0fJONA48XGdD+4Vb2pknf0JJGKth8fFQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm: zswap: skip xarray walk in zswap_invalidate()
 when zswap is unused
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
	Chengming Zhou <chengming.zhou@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Kairui Song <kasong@tencent.com>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosryahmed@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7E3B5A000A
X-Stat-Signature: t8iw631nydkqdn5wh6qzp5ero1g1p5jk
X-Rspam-User: 
X-HE-Tag: 1789049347-556906
X-HE-Meta: U2FsdGVkX1/iFXMWYjNMq2T1XtRZgLdLDG+qofMMLzaIA8ioDruO14bc+MEfcSxKDBjQfpc9f5BOL+NKcCjhIG6FatCpHgZHZAhKF7f87wF5bVjE+oIt6cr1p1ZK8ClpN2bHHsLwhUgJYfahqHXn2kij+8TNiwftily4rIbG0eQVn3KwNWNC/MpvR7CVq9VEbnCymzHbFDAgButZKwpu5Qu7nPD8stEQ3Gr8DiZhy+hYz2emxAG2XIkUfQj9C9rKTSu1CLRSjw0SE4pZfShxxOxlWIHX0iEb5N5auMDiZ9AqlTSZOEUGIrxQYlvK7JqnVxbDe6oTvUtTUggl1atJb0uY6vZY1xu55Mo4s77EDEm6kd7OYkGObP/u5CJe4DU9MBDZ1tq5RqVwcrXiIg7kU2C19hei8rA6zOrWEyjE1MSiahYhG/gxZ6CVIg+6RfDCeuqc8XHTF+NO8lBPloGlgAzeZpPRMYrHuZ/IyP7L1317+tirukKMQnpyOf/VgxkXgdaGZqNj0aqfP8QJQwOEKGCVV6CJXwbCrDolLiDrOufs7enN+FmYe8A+NQ51yYW1EWQ+7DPFO+uZ76b8QZFyz1f7/FOu2YDrjwELf8zQNHbbhW6oMU65r6yPoPIJvIkQ8OECv+ztFh8kmADJEqGQFhT8Cj3z/ZC8lVyLG+JJ9gFIhL6jbmaWjNFM2DBceZYy+Df5/HE9FXqPQC4djh9e8/+ufEchNlzFrD660prOqmnZFgHD8s/Rj2qJqgKG9xW3K+EoY3+iaDab2u0aZu3ZpIaUol5munSpkOqI8aY8J+OjbK1g/W7q+9mHey5tyFkaUnsZceOBeEv7ErM8GDbKxflIhn/41QoNzCDrFubOD6E/9i+ADmtwW4aet/zX1subBvQ3+oz7wts1lxaUjMF1OIpJMgh43Ef4P6ajk1Let3VL33CpTnvA68TwzPNrcxourXO/B0QsdsO5AeAbRBG
 E+gxv5x9
 RgCu/t4A9A0/viqwOshZivETLCvcYD2e59Dxm6XdolRat2YKOrOqTY9aMMXBRfQKigGk11kj9xX2Q/ZM4ivgfOgfbCFLLCHIHaU+X7zKflek8u7mvI92p161/BNUCTSo96oSakeYir80TAF00npXz3iYS0tOWxf4he+JHDyYgDfDWQkQTqkCJwMmEI2sMfYMeqOTLiLViHlc27iAghJworewLplSdgnqMzOkzWD7VVl6GDxPJCZIJCCQ3gnDK0m3IJk8XOc+Y96tCqlWta1PHwQVL0SG6qAn7L2/NK5KJAtwa+HJDYYelh1UNZBSvLRAfa6m+pSqfuVWbCdeuli2UmQiXrBBr/kFjS/LQcEnT4VekB3/BWGJ+S7pPaEAsaBJpvxNxefSK7vXRaNZohsBY7tuzk2MLatR/rpC+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 10, 2026 at 5:36=E2=80=AFAM Kefeng Wang <wangkefeng.wang@huawei=
.com> wrote:
>
> zswap_invalidate() still walks the per-area xarray even when zswap has
> never been enabled. Add a zswap_never_enabled() to skip it.
>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

