Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C397CCEBF93
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 07:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 304478E0013; Tue, 18 Nov 2025 02:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DD098E0010; Tue, 18 Nov 2025 02:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CAE68E0013; Tue, 18 Nov 2025 02:30:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 082CB8E0010
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:30:16 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A987A88E3B
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:15 +0000 (UTC)
X-FDA: 84122904390.29.8A22A77
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id D32E21C000F
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 07:30:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jt62u35+;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763451013; a=rsa-sha256;
	cv=none;
	b=aDfBoJKX3RyGAT8h7BPKSnpslt+Xd2rf4RSc5894ZDhngYJHuP6nJNaUqGTIuJjcuPyCYe
	JqE3bjla5znymKkqr6zGqNBGUD3bKM8OWGNpqMc1xXh9hFOW59fSxDUx26Fe6GkcEyvurZ
	9iomwINfL8BjLd+7ZTcc4unCURxm3e0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=jt62u35+;
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.182 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763451013;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aEgVdiPNMHoJflPqef6CyPpb7lp1/FKP7uAVKsdFjfo=;
	b=Ov+b87OMOUY1oig1+B0ZHj8lvITMXOHhI4zPrAGgf7YyYOYKaKb4QyrB5gang6aCsha6/r
	PsUoqaNQyHX+k4XYW994rQjJX9AyXVdsnmk1/cxND/s/d4k599XoNJ3W/umtTfrWQHvYXr
	AVU1EU8KRCx2DquwfHAPmFu+Xe4XdIw=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2953ad5517dso57295785ad.0
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 23:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763451013; x=1764055813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aEgVdiPNMHoJflPqef6CyPpb7lp1/FKP7uAVKsdFjfo=;
        b=jt62u35+WYm6o14MWmUAUGR0sM/A24xlk1YuPzd6iFCtjEwQVYif/5WKGThPaLipn1
         9uh/rco1xZxABduv6PrwOjuZhWXTskUGO/hkL5Q/Uy0Ahq/jktFxxR3jLMLigELjCxPg
         dfBA8oe5bBSz/qxJQb2jlnNkUFw6dIIaxTCpA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763451013; x=1764055813;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aEgVdiPNMHoJflPqef6CyPpb7lp1/FKP7uAVKsdFjfo=;
        b=DIRfkAgH34kueRRO7hBq++e1PtAikOAwXqjTdndaXpVPEwOn7xdwxqKoASIY7PVMfN
         O1+77iSJMi1WeO3gSQ08a3R2bMM+rH9F9bUdWPknDuL6L9jMQjMqZ/CxxrsHA7j/Ny+n
         dGHzP71zlU1LH59PSd5hRHSlrAIuJY17PuZ9eO3VWlzANzRkg/nDUoGAFE5hPmpuSWSj
         k4oFXn1xNTMmBwRbKx3mk2pED4rlcTGzxlS8s1N8uO/Pfkq4Pbn7QQt3O9+rK6ClNy1/
         QZKqWTaCitjpoh348PIPRv6wzWXr25n7RlMzAXm0GP7PkoibAx/9kMERUtz7m4vLkSDT
         DIsQ==
X-Forwarded-Encrypted: i=1; AJvYcCW0E79hnm3plscwgFRpH+PcREcKWx1+atW67IeVl5NOcoMc6ujbXBv4xA1Qw6iaJHqFq5czQwVDxQ==@kvack.org
X-Gm-Message-State: AOJu0YxPkty/UcYVZdQ2Ge8zQa/cOlqFqzDe/9SToD8ovFFSaH1yZCUu
	odM8ACuPa0nmWgITM+W7n+361pXAHwi2Ei99ugt1iE21hewRPoIveLksIT6lwHLlXw==
X-Gm-Gg: ASbGncudPxH//0eiWjVB1+xtbHCXBXzWUUTinV/iquZLknO4rPAkY8yu3obGIMUDu7j
	WJuqXujFLTQglwH0bZfKp5c6oa7mlbh5maChXbOlZahLIoXQDMCnpwuw2cQFkoF51bDpO70/PoM
	RZFQbeaGXg4kR2s8TxtPhaMmwLOHDu2CF+I/uAs+5tma3wmSY3aWIwc1sg0zK6GX27rrrJdzCnh
	Rgk627/Xdm/oPQRmDx8sF9WDgUlFKqAvTVmXAi5yOJO0SFF74kSMmlZTQf+XYeIryMUE+a9V8qS
	+cwNhA5faNcM0vX8jui+0MiEjAaL0uYxl7GNYvOiA8fcvCLaIZBLfs/XopEwXj4k1tuB2Dpfl/U
	yKvndt/ffSjhWC5jOBFFsj3f8O/oAXtGT4nnfoTfOGxg1F7yK1w/xDo2Pv/JLbeY/Pcg9QSNSoI
	UQVUavDDkSAiNuPrxozgWmk4jRPz8=
X-Google-Smtp-Source: AGHT+IHvAN5FTpEAwX09VrPesluOzEdDPyr2GSk8K5mW0HnLaxO7WVj+e+6ZUNER2RJm3RrwKyj1IA==
X-Received: by 2002:a17:902:ecc3:b0:295:7454:34fd with SMTP id d9443c01a7336-2986a73b7d9mr191714615ad.39.1763451012710;
        Mon, 17 Nov 2025 23:30:12 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2401:fa00:8f:203:beba:22fc:d89b:ce14])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2568ccsm163926215ad.50.2025.11.17.23.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Nov 2025 23:30:12 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>,
	Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv4 0/6] zram: introduce writeback bio batching
Date: Tue, 18 Nov 2025 16:29:54 +0900
Message-ID: <20251118073000.1928107-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.rc1.455.g30608eb744-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D32E21C000F
X-Stat-Signature: dh76q1dg87fg8kyxwjqpfawire1ssfmt
X-Rspam-User: 
X-HE-Tag: 1763451013-652602
X-HE-Meta: U2FsdGVkX1/tOj10p4D8D3A1ebjKwr1uT4I637Ty1tKehuZHuYRWFVnKhoY3JtS5kljJucbYyRkgNy3RFUuN4FpEd9sxvWAerIJfO05oJ89buZiFUfCIYnRdJQ9Tjg1GElh5Ynjy0uUCKL6bSSoZelftpDoT4JMwjrNZbijBFhlkH6UeQyVMALbJqsh+tEiBYV554aICilVrHE+MiWgZxd7Qt8jcBctuDpSaUfWgu3pkq+HdiZCLNr2q2ARAQZBLdnYnfskg8JimgnJECfVFLaaElTUq9MqW6ZUfuMJk1zppYLVVjwDidDZbmGn6pV+MVYzLsHlUDSnHTPXb7xEFZd9CNj35Coi47woXbEFhMFhQDZbjxI8jX2rbOUcvGo8Ahpzn9NvBLoRUxVeOqr0JLqtNPCXOeVWcul2zDVS26ffzQ7t8QMKG0fneZY0rshJI+2ysE0nz0MxNpGWe5q68jW3RqysGGzjZT5ONJXynrAsmETZu5zgfFd4UGsXOZj3hgPwg2p9VnGFZVwGqHxflcSIpkLPrEA5WpdiavO8DmYZIotW3eHE6Z41P4/0UsC9dWUCiVYQE9PB5FgTKXQzx2NZFsOjMdcw4eFVpjLF611dZobUX9P1/FYCFnTtpu2mB5QMhDoFJJEeMFjKU07Uh1BLZDEAqh3TAzDQ1IrVeqGe40CDtxwdB8XEdi9evEaPaFKI47HmoKak3s9LfMaSICtuRQ33wJ1jOwhTTg+mBimDBd69sCn4h/5gC19UIQTZ4y2HxK5/lUWd5Kq65Tp3/m7VeH2WyuW0TNwhN8lQMPqQNYTfjcntpauR3+jxrYvoLGMRryZu0A50DugkLDi7Gp4BmmcAi3zku8eBGzCmj0To2rt/HVy4rACQcnulKjy/K0507kSWKa01gTs2EhhNghPZIurPhQTsk+Z8TYX2+ndlhM87PfjAwKiShn2SuzbPUf3MOeDP2hVkqtKTju1A
 /VYbyAQP
 cxIdrlfx3eNLKmNjhyPZBFDzHj7ma326JDUu3gaR1kwTVR+i1WqHid3IRyzl8kWfgdN1uRGwUjHpSMBqbGhXDeMs/Dear3A9xh8AKa44WrcF4rwJb7rryn5Tut0pA6rdJJGeStquPYsRMmlDdmVCJdrdYEBqn8ZaIqjaVdemRWx5hOznTAAy9OdhYn+Y6E5l4tIhL5d/Zs60wvw2c6aXiqHcaV3oGi9vxQgxXiGZvxflX2rI+rum5vTGFrAjZq2XxonVBMp8vElrjA0jTr4zzvbwIAO7CBcmbAakF27cTHEgMOz980X9FhSBnZYp0e4ybZpFlB4jTZkjhjVRFKOs/n2uXeGbz+qX3sogFnf9p+vDLWa6xpBVHhpYjr5/Jc6P3Cmvp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a rework of Yuwen's patch [1] that adds writeback bio
batching support to zram, which can improve throughput of
writeback operation.

[1] https://lore.kernel.org/linux-block/tencent_0FBBFC8AE0B97BC63B5D47CE1FF2BABFDA09@qq.com/

v3 -> v4:
- fixed bdev block id leak (Yuwen)
- fixed missing pps index assignment (Yuwen)
- fixed preliminary wb IO completion slot release
- we now use bit 0 for writeback as well
- access bdev read slot block id under slot lock
- some other cleanups

Sergey Senozhatsky (5):
  zram: add writeback batch size device attr
  zram: take write lock in wb limit store handlers
  zram: drop wb_limit_lock
  zram: rework bdev block allocation
  zram: read slot block idx under slot lock

Yuwen Chen (1):
  zram: introduce writeback bio batching support

 drivers/block/zram/zram_drv.c | 452 ++++++++++++++++++++++++++--------
 drivers/block/zram/zram_drv.h |   2 +-
 2 files changed, 348 insertions(+), 106 deletions(-)

--
2.52.0.rc1.455.g30608eb744-goog


