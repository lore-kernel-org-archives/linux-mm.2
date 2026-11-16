Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF822606A884
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 23:23:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=APFXTrlf
Received: by kanga.kvack.org (Postfix)
	id E5CE56B00EF; Mon, 16 Nov 2026 18:23:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0D086B05B0; Mon, 16 Nov 2026 18:23:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D23206B05B2; Mon, 16 Nov 2026 18:23:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A404F6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 18:23:50 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3241A160253
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:50 +0000 (UTC)
X-FDA: 85442561820.05.50E764C
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	by imf15.hostedemail.com (Postfix) with ESMTP id 75A58A0005
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 23:23:48 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=APFXTrlf;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794871428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=VKxvJEBSpjGlsGfyxb4wEnmaujupzaQfHMLbEQO7Hww=;
	b=VKVh1vaxkfHVYiRBklOPe+hPUDcNRKbKDRAlLeaGKUFOgvyx+2F4nF1E/+9DFDqlLqkl2c
	KYAFiAxOu3v2DIQy6pk3GeRTVOx8FQDY17Bnmq0UqM7golRl0uqW+AdBmOa+izDkPC8Wv/
	XIdmiUiupFbGAS1inaGcl9KBSRZq9fc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794871428;
	b=EUBfBd46vvx/TPRwk9VVt4zBvYyfGCqc7Lfy2daQW0tL5ccs7LU1gtOv/fe+1KdmUDNi2H
	jtCQ6mNq7OqvfnITuFbbx6qyL8J0sR9mrn+gq9qgEwWbX7o5AoKmwd9OeatDSOnubs3u7I
	XfI9Km6Sb82pJMdynib4Nz+o4ivqBPs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=APFXTrlf;
	spf=pass (imf15.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.46 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-43bf9548df4so5366455fac.0
        for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794871427; x=1795476227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=VKxvJEBSpjGlsGfyxb4wEnmaujupzaQfHMLbEQO7Hww=;
        b=APFXTrlfnVHuSLCkFBGIPudnbX1golJNaActYunKZPXtojpqkz598+8FNOEjHO17Gc
         lqVBTYFUbnLqDJOF2GbUpu6TVT2gSuhFbWiilFPlzCC7kl1Chi1UsLOHr1qkGzpB5KOo
         QQXrQGt9UdIoUti9ry3oOpPROVp9DQCppPL91EeB3gNNsMmC/dR9oNx6ty2az4TPkRyq
         oXPKmuWmdQXLKMdGIS7czukHpZgKITBI+BYjswDUs48JdvQR5sshLlnY9mfXTpavoYoC
         4ucWEa+aEEK1MBt8d6GYLsFClHZVUtLFeIrN1qaUz7Mkw5hXgfMQCkfxQnQEXCfXHo7W
         t0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794871427; x=1795476227;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VKxvJEBSpjGlsGfyxb4wEnmaujupzaQfHMLbEQO7Hww=;
        b=XZoBEjQwMwjolpfKkeCrUUt1vFRD+wWlXh+QBjz7JcboLkYUnp8UH0KGnjOw9rmlRh
         phUE7KR4+747mA/QuUHxmzyz6ii/jchItdfmjf2bcRcOeo6O7OT4mRHZ5LdBmW9ukttc
         Ifbvjju+qpJnJB6VzOKN3U/ziUIewSP6G/4uFpTrOJusghGtl3Iaz2qhCQI2CR3IpF27
         eezIZh145bY1ZzbYA3ShrtRHRaoTQdd4enQsSNXm/K1mTO8MyiYh8FgkwY5ohnATAMUn
         nWaSvs0HJGfOO3fzjijqEgurawlhhbds50aqDTEkYdeF/vIPNIGf/aX/NdH/J/d9fr4m
         EXHg==
X-Forwarded-Encrypted: i=1; AL+hErHmE/imymTt/oyuANWOp4rOzzi63dcofiG6LEeGoPQcUpw3f0Aj2H7+khIezaC/4ANAIOPDYHLQxw==@kvack.org
X-Gm-Message-State: APuU4Z+4oLM5RQ9vr2aR2OVgpkdkROT0R5iLA9/SPiBO632eNVEUZYSl
	6C9/zKheQ0iPfJ1vRaHOw3Li6yRCJybn8sERXF4/h5JgYfaYCx+hhZJB
X-Gm-Gg: AYBFou2jS4pKmHM6abMr6BhGTFLCzmtGGiqpRGzmtyBD/R9JWl1uyKGgji2BniXASv1
	8RMbKcfeoXVOgXrEiKC5Oqd8T5L06fxe28dgGe8KsD2S7bQagWC7n7qrZ3ebARA2lF2VAv6ybnq
	wLpcyB5Ofve4LXhcBIlOHDaaZgmL6QWapyq2R7gHHs0SKZjYNBlIWCrqf++3NKeW0KKTaiLkN9e
	7TNJp4FjGeawKLQyuNJeCnLZCAQX9D61fcRaYkAL8FCP61Q+TK8oPghT7y4PK1Pu3hLwVODozyL
	YVEZwmBaFdOBDFPG98W0rn3Z5FljQaBse0H3ctsxX1EbAasP/lQ+lz7Wj5dolRyIkVmReGRWEQS
	MqPJqDd0PflcfTMsBgrtK3b7IChJEvXQzL2BT/MXs0d2Yj/FCbNtM7ZeWwFC7yxlKsolKyGGhbN
	+poIhRhzs3n4p9WcWgEoOkQaijRXupeunD7qfZq52nMEHDQSE4/VQ4wsnmQkMgaXAh9iL2xHUKm
	BuYtm13kageBAMgZ/q77ZaJpuq/hd+Pzq4Bb0vjJczbOEDuT7QI42yOdzzr65IWP3fK8FE6h4uI
	e6gENMt6Fl21bciA8MzItOpCcxfNjkANONNJbuEhhnpSWpKvs3xvEXbByFQ=
X-Received: by 2002:a05:6871:453:b0:4ad:6057:560e with SMTP id 586e51a60fabf-4afdf0b94bemr10417482fac.8.1794871427343;
        Mon, 16 Nov 2026 15:23:47 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:1::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4afe2288f59sm7849326fac.9.2026.11.16.15.23.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 15:23:46 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2 0/3] mm/page_alloc: get_page_from_freelist cleanups
Date: Mon, 16 Nov 2026 15:23:42 -0800
Message-ID: <20261116232346.788145-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pwxf69qtskb4gbqujm7w88fo1wecshte
X-Rspam-User: 
X-Rspamd-Queue-Id: 75A58A0005
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794871428-459256
X-HE-Meta: U2FsdGVkX19AiRpZI9/K+eYLabnT22KaJZmWm9/dd+IsyZQr8Dh6rl+hRF5pHP8Eluz6nBdQXbhQGCB7s2byT99VBX1jPUIlp0K5ZctECgnrXi0amZJ9mubwlwNrnrvJqFO6GAqWNJqhZhN5kV4kTLqPKeQ+Q+BsoBTuA9yGS6IJPcG9w5gh1XbhvXKaboIjGK1EGoSqnsDiDiLottkD9L+goxd30a6NgSWgIcqIouczdA+VoFD4VHYLMKGd2mX8xwYJ3nvOSr36f0jqewW+fqBD4vIrIxbPG6BorZT74/x4J/ARo/VAPtorcs69KnKM22O6idu1GriY28CbU55BE98jDMz0vXcEAhFEtzFhQ0zEWv4Mt+qiBE15ucs5VH5aHQPj/abNwuino/h+swInnong+rwkKimCwF0gyO//NunI9l22QXkyuUkcm/UQq3eoTjK79xg34dNw4UrFnwo7Yz8EhYKocQyMqLED266YNh7Vt/fn6yRGWbrEz+DAyDL6gBWCNqh1AuPMGeRJjcTmcN5fBCZhdPLaxH1eEX8MqOJWluoHaxzqPeezeWarRLSea6scPTecWXCEXxIUkWwnO08sKvP/cyqjo6UrJoOU1gGGpLLfgvdvdqBwffx5ZQEMz2XKn/9z/ENj+y9OviFJs+M69/Z6YXo2Zj4FUiBOCEVTkii7ttu7jQ+xpliHg0tcCp+aCURiCYdR+H5v3i7OCjrCYpKXwiBhxgeBJ/m+8WqgGAs0gqToKZgnFobJPI5oSIjv61rL8vQwD28tWVwQU2qD4BHi+88yd+0ObMMhGemQYtyKyHmFvgzo1Z1pmVxV3patsFmS3ruWlMkFRYjBWTt/w2QEGDTCn1yKe9r1ZAW/AtmrpeijdME70nWq7yMQILnaEgL+vft9491MZgtB6tipDObAXX4MKZWGlheIv9KMoQEMZnHI5nhzCKfFNdOl0nHn0fM9uFQ6owffL6A
 6BCzFJw7
 yV6D+SzZTqcP/QSGDJ+wK2KZWywgRI/LPMfQpbuuyO4l5yaZEErmatHPI6sWfPl3nVLL9HolCc7eCvSRmFhEki9rzyeCQaxxtDW1J+Vc7RNG8GWY9ynTbxTxk2d4sBxHuKLKBMO13HqrYTjRDyCuamPSfe9mw/U33iXBDlmi2PilgPv20zsj24MxyKdI5fBJ58taw/90OKFYuhiWrpKrbC5xMNRTSnvX9XftlA1qwzlgPL3J7AaJkUeayyQ11B0Izj8snvpKl6tzqdujOB7z2saW98MyHavbhhT/DLHvCsG9UsPWPbz44DDppn0GvujuOPgSyW40CxdW1TJEobIo1/Pi+fNm+GKTfrHhPuWOf3NcK83dqGBIu58MMEeFAjYQ0glC9BrYvwAw/7FAWCV0uHogIbyiToTmFPR+Q8LorrwrOI76jqBK0UM99xnJOXCEzkA+qSH6BMK5/DekDvjwcsDhahwRkU6XMyYeA8+mPd1bij9A+eIHLM050bMqm/63oSVZcytPuNkqGn19Av5qdf9D/r/aYXU0cu0BLBnbRqUNND6nMK/+6woqBu15u4Pp6U8nT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

v1 --> v2:
==========
- Typo fix (s/patern/pattern) as pointed out by SJ Park
- Wordsmithing kswapd waitqueue condition as pointed out by Chris Down
- Collect signatures
- No code changes

3 cleanups for vmscan and page_alloc code. The primary goal is to make
get_page_from_freelist a bit easier to read, especially after the new
kswapd zone skip conditions [1].

1/3 is just a nice cleanup that I found along the way.

Based on the latest page_alloc/for-next branch as of 11/13/2026.
Notably, there is a dependency on the aforementioned kswapd zone skip,
677dfdfad244a "mm/page_alloc: only skip kswapd nodes below their kswapd
watermark".

No functional changes intended.

[1] https://lore.kernel.org/all/CAN+CAwNsqWpPoag_XE6bxbrfi6m71xw1NS_wc3h_ShZjNspSjg@mail.gmail.com/

Joshua Hahn (3):
  mm/page_alloc: drop unused gfp_mask from zone_watermark_fast()
  mm/page_alloc: move the kswapd node skip check into a helper
  mm/vmscan: consolidate promo vs. high watermark checks

 mm/internal.h   |  1 +
 mm/page_alloc.c | 55 +++++++++++++++++++++++++++----------------------
 mm/vmscan.c     | 22 ++++++++++++--------
 3 files changed, 44 insertions(+), 34 deletions(-)

base-commit: 3a99594e62fce8c646e8aac01d38af16d6833a40
-- 
2.53.1-Meta


