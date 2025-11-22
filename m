Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9F445CFC51D
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 07:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 99FA76B0006; Sat, 22 Nov 2025 02:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 976FF6B0007; Sat, 22 Nov 2025 02:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88CE56B0008; Sat, 22 Nov 2025 02:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 77A7F6B0006
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 02:40:53 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 06EB916086B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:51 +0000 (UTC)
X-FDA: 84137446302.07.3253D23
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf18.hostedemail.com (Postfix) with ESMTP id 34FB11C0004
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 07:40:49 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Cgm4/LZZ";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763797249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jlvl/ghygj0NmIQRAayRRMGj5XV6lcmj5TBV8+HeVEc=;
	b=KQD5rSZAlcyZu2Ok5WRM1qm8HwzytTJnfDKHtIiVy+dziYX8LWvxua+pMv46Gabadz5qN4
	WqBSk5UntZiWU0JQ9ub68jNYViWeT3LCIh28pvyq+ImbsfYbaxQrBMyW9Kl6EdSh5oYKoM
	GscpX4KSLf6fO6sH6kni3nDcdrjvRKo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763797249; a=rsa-sha256;
	cv=none;
	b=NyasOEI6dWyAbDb4GgQE/UxFBwhcCocJes9kYI8ETsvSc74JMedAmzlcHNY9kl6q4VzV8p
	YaPUcBjkcVR3gDLwW+1NoJVLOj7oqd+jYN9JwKr5q55LfHM+seHAWP29bh6VoCXBRNv7eN
	cpO4bRRA4cHPiOq5HKT9/BhcC0BevCY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b="Cgm4/LZZ";
	dmarc=pass (policy=none) header.from=chromium.org;
	spf=pass (imf18.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2984dfae043so25109675ad.0
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 23:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763797248; x=1764402048; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=jlvl/ghygj0NmIQRAayRRMGj5XV6lcmj5TBV8+HeVEc=;
        b=Cgm4/LZZgY/nUL52eX0eztBNiv5e8gjWESUJlCRuSNK02WaS8btWcyH8Viq9nZ3u/0
         WdZhORVXiI1qlZ1/ehYgCBGdzCKkwSq3use5SbRkmyPmygNWcBggFc8ZuHgtwfffohYv
         cBL8kkoqpKtvm3UdNmnjyAjieQvEkQXq2zVZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763797248; x=1764402048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jlvl/ghygj0NmIQRAayRRMGj5XV6lcmj5TBV8+HeVEc=;
        b=ht1zPTYmAthQU+yyONv4Lgw4FAylK26ewrQ7NE/WzdTOMboLclS+0t78ej219MHMJ/
         tOBXw6QfWDVg5mbEfQ6xwgjtI/R8+KzbwR3GRAKrfMAfIQjA189dM1T+W/kPmhvQ2rrf
         Qr+ymUxmhRb7Z1kGzCpKpvi0bsk4X3eO3nxC8q1mVrFQE74pW4Y0IL+GgzqFJzoKCVpJ
         px62CDGg20tsxxEFDXiTv9deqzP64MdlS4WPRH22ivnfAKUeQuEXLVK50M03+7FQZRXQ
         3wFuLUqsZNoWZwgo6MSRIj+jiRaW82kYJ1QKveWpx3SG6NP+7bOpfZjYLjqkp7oGxZIg
         n5/g==
X-Forwarded-Encrypted: i=1; AJvYcCXmaSfu9kGMXZsLwvbL4oDMd4k82G5ZO0pLAh1vRTdRUJX4yAGf/6reAHoxnmQj4Q0Tczb9wb3JKw==@kvack.org
X-Gm-Message-State: AOJu0YyEIhgS1vML2R83eqBF6cGvYgE6reFjTJtErfcJsnKXLQiQQ71l
	Y4kKrXG8zOVnEudN/jqYMjo5kO6XVmfmogqwr7HfBAnkygigwD3+9d+whsfVF1Vf8w==
X-Gm-Gg: ASbGnctGoSMkhML9phV0uFiyCs0yITNeZEPmH7935cle2e1f+/+8qkYLA6dlyNX1D4D
	zBViJQ0sbMdeu0R2bWaGbDYllE4V3W0EV6TqqakBy1Fzng69QeWw1ACWOBEDoFm0nYocqhHKbBi
	nbDXmDhPeHxWC3Y4DAk1IrYmAtu6jDTOwqaPYthhU8cJIOZ3F7ObujzQ2l6Wt1G2iTtJdhx0FXQ
	/ldzrlOGx6rprbJ+Yv4py6i6ApJRwKM6wbDh4RXGd4pmMqAutq9DqeY7Lpk4v+uHF769+WXbbF4
	O7rQrbfvcT701Ebk6hmA4HmKhoTHBDLWCrAQUPQ4tMoeZdHEq7/1t9NQ08kyWVlmriOP3E5qTPu
	HoO52vVRMdEoXMpWaiTSW65/Hj19o+INdLjvuJD7HTKHL5p9lGojuWHr4Z+2issyt4J9bQabOdE
	LIPBtZnI//8K11SUamguIYSpVcvfcc0RJPOifQ0Fmrn5h7F0QhI/2dE9web+/Ahc0bDO1KtLJbR
	A==
X-Google-Smtp-Source: AGHT+IHJ5OoQEmf8k8l+f+f0vaIbSHKi6dQio3TsdtNL2AazXMLkkUb2ETu1nh4IGFMM7AfN6JKoQg==
X-Received: by 2002:a17:903:19e5:b0:290:c0d7:237e with SMTP id d9443c01a7336-29b6c68be27mr64410735ad.39.1763797247998;
        Fri, 21 Nov 2025 23:40:47 -0800 (PST)
Received: from tigerii.tok.corp.google.com ([2a00:79e0:2031:6:948e:149d:963b:f660])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29b5b138628sm77771555ad.31.2025.11.21.23.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 23:40:47 -0800 (PST)
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Minchan Kim <minchan@kernel.org>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Richard Chang <richardycc@google.com>
Cc: Brian Geffon <bgeffon@google.com>,
	Fengyu Lian <licayy@outlook.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: [PATCHv6 0/6] zram: introduce writeback bio batching
Date: Sat, 22 Nov 2025 16:40:23 +0900
Message-ID: <20251122074029.3948921-1-senozhatsky@chromium.org>
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yeamed8ge9n5cne8rdgstkoagtxdbfum
X-Rspam-User: 
X-Rspamd-Queue-Id: 34FB11C0004
X-Rspamd-Server: rspam10
X-HE-Tag: 1763797249-146712
X-HE-Meta: U2FsdGVkX19OHEN8vu8nu8XiwBBkBNen6mSuPxi1pnTnmcZat/uMLZY2kdtpBga7J3KxJ5xtyhSSyQ45rzxLDgt3kGW6mhXe0HzxKkmVO0GpSxcOQSi7C9ob5+tK0IAWQ7A3J/8iM6j4FSQ9CBacd8itIo491rTmoDjdyU4vtgl/nAT+M2EvtQ+yhemnYtfskjFM/YyPM2x9+DHzy7WpkJlOuHrlautLNAsfaGDVINeVolfcpknvMaZZv6ZlgmtAaCF3ScVi10Cu6ghg61ISAojCxzb3Ti5NsOUrc+J1RV3Ot6mpd/HmXi4rP2ML3iykmZs2RDDI6XA4ptJIGKwHLMeB8+JHg0mu4qGxCND0lFn2K8UkJ/ZXmwsIMrIr+b+4V2vreWcBfvUxV3LhakZ6XTNVI3rd8N5NP8X7jY5Nxw3XBDp2yDUAIbelZk7CUGjKZNUj61YLJfZWDPk9VotAQXLAsoaSD/Cq17+DA5JmOjU+YDzESrvMVb9rC0qQUiLi2lx0horHZiFGSfmToLBUB6HMoHlwMIz/nMIvmaH27fg12PSAQz1r5K2znzlc3ufAqyXae0OtPg8GTra5mCN21aX7VaKKvD4ScuQKyiw3NsJijby1UJJ9OL+UhUTwtgOATNPCyDFopzvgZkf3DurAlI5f4BM8GFRBDm/SyEK26kDBSFUgk2WIn9robXGdMlr3gmDxEg713F5HpvS3y95F2izYK7tKTsIerVuNvJdz1vrRzK/V2qKc+dHPX1SdLWba5N4yXKmrXK8DCQU+WmhZQ4cFihRnK9J15bmRrzN9R9APvdtp95PJz43HWX7VB4JcUstI9SyTcgCCQUXVD0x9TGg7mimeHpvsdZSzlZjCZiZo3YHaHgsmfJLGEBcoMcnEG9ystZEYmRpGhtjGyFalr2MG/dTwiAR75beuTq3Do0UWEUXEqlqROr0hEbRU1KWFc61/BDBchttAfoVJKm+
 vJi0TaVt
 wyobwUwCNS3BsnmPhe6wD1dagTC+GLV4eegdI7PDsABIta8NNuUNMYAmEnxSjxAKrNeexSLcUZiZTy2YHKMukRAiRCxKAzdSoqdytzNqkOqqEmjdWD2Y/0WzgOu1czBCd6UtbCWUB+q15zNlRH8EE8Kefacmzxj9XWNW4WYLEwVq9T8an/7oIcalxZvALAdn0C3ZhWrDrbm1bULUH3yzkKebSBoOQYcpR+ovN3d2iYioWx25oY+C20TuiXBWxCkWyIksYbxml8/k9UwarBHJviJp6btuLjs8KvAAxO2EzXxSwzBZgTA8/cgUv4nYV+VS+l0nY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As writeback is becoming more and more common the longstanding
limitations of zram writeback throughput are becoming more
visible.  Introduce writeback bio batching so that multiple
writeback bio-s can be processed simultaneously.

v5 -> v6:
- added some comments to make code clearer
- use write lock for batch size limit store (Andrew)
- err on 0 batch size (Brian)
- pickup reviewed-by tags (Brian)

Sergey Senozhatsky (6):
  zram: introduce writeback bio batching
  zram: add writeback batch size device attr
  zram: take write lock in wb limit store handlers
  zram: drop wb_limit_lock
  zram: rework bdev block allocation
  zram: read slot block idx under slot lock

 drivers/block/zram/zram_drv.c | 471 ++++++++++++++++++++++++++--------
 drivers/block/zram/zram_drv.h |   2 +-
 2 files changed, 365 insertions(+), 108 deletions(-)

-- 
2.52.0.460.gd25c4c69ec-goog


