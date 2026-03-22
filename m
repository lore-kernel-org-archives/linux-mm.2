Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC9EFFC72AC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 06:06:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035106B0098; Sun, 22 Mar 2026 02:06:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F26366B009D; Sun, 22 Mar 2026 02:06:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E3D1B6B009E; Sun, 22 Mar 2026 02:06:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D08326B0098
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 02:06:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7CDD8BA5B0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:06:37 +0000 (UTC)
X-FDA: 84572664834.18.BEBD817
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf03.hostedemail.com (Postfix) with ESMTP id 9954B2000E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 06:06:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jljgHgV8;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774159595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oGTrddMpoqNlMDtLVg/NZ7xDSHSql5ga38DOEBpNYTM=;
	b=qV3DufSG8wR1Ak1RTsVmY6qrP3YlDTTYBMolIpeo4wn+bMsWCzLG2BMvpgqQeZEskeRzeq
	8aqC8Tw4fVj38SiqonGonXlJi+Lc3B6lAMs5x5a+rRxTJGwub6zAi/ff+rvkYv2KajoIeC
	P/wmiTX5MXrRfLVkfA3olAeDRP3tU6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774159595; a=rsa-sha256;
	cv=none;
	b=ujif26A+ehYpMh57XJn+5O3MXkKdQ0jcQTYwx5E0QEI5lq8tOr4gHo7I+4ZVcxzEMhITJR
	VGDt3nWyXna4rP9DluoXE9ZdmR8QhO0O8xDOosPY018ITEsWoZsUhZTCNzT3fAZUOInYsn
	aGB0VwxxKZ38XnKAhq4kq5zJPRwkeTw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jljgHgV8;
	spf=pass (imf03.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-35a094cc3e9so2172882a91.3
        for <linux-mm@kvack.org>; Sat, 21 Mar 2026 23:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1774159594; x=1774764394; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGTrddMpoqNlMDtLVg/NZ7xDSHSql5ga38DOEBpNYTM=;
        b=jljgHgV8RqfrZzosgI5QMkeJM7K+bBjfc9oy+c5XBaBz2baV3wDgPRwfTBeV8p0yrt
         jg2r3IvxIRR0U5ITSTIE9TJzRf893TPYbliSszqQ1b3EAgHpJIVS6lH7W5r9NLiq0Svn
         dy9kxsBWOlNThEhlXKjc/4sE+SvoC+oOjMj9Xa0ZAfifzW5hczhMmVDnbHo8l7GKaux4
         0Np74d2JawsLwTWbLhOdiMBTbp4wD0EsdlQR1XhtW5Grw+yrzhFv3xZhC723uyPOcKMV
         QjJzrU2U87zf8o0Z+wo1OgPwidkRy1y6AmFZOf3AChbXaeJ3lKeHJAQe1Buf6UcofrkT
         2pJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774159594; x=1774764394;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=oGTrddMpoqNlMDtLVg/NZ7xDSHSql5ga38DOEBpNYTM=;
        b=VfDGuWmsJxxpYVsl8jmTzqqaLckJNWQQHJI7cZnikchj+eGyXm43MVB6v0XnwgNZnm
         kJGBWUjn4bMtMLOxz5pNby+zHQkXU/Ejb0tN07FSkUVmJ1EtEecJWdwEkPo0kdF4Kjns
         wVIczz1NIHzQxk2I5bDUDsUHHuF9gBGp3vkkyxGOHlSqX1RrBKf/vRseI/ySxLJVXF/x
         p5fXkB6AIv18rmT8zVoGoHgG/VNPalC0SbWZzGmDsstOFcEtNnwleDxRyCEm6Q9gGElv
         md5GHDukXhDcUgNGb9MHspg+Ji7ef40fE3T/Gn3rtqwsoCoNjnzFTjIk9JTTJ1uQuRCy
         DK3g==
X-Forwarded-Encrypted: i=1; AJvYcCVhU732WCGnJpG5UVxTwXW3DVt5rMTS8aDEYUiTWTHq3pjJMyvIG1TwSusrzIu97M6a4OHQMWy4Sw==@kvack.org
X-Gm-Message-State: AOJu0YxeB2W2brNXsppEyW/l/q7XcIWP07D3ZllCbKn8O+iIr+EiEsWH
	2UArOdrFdmBYFJZZjs63GEDECTF/I2a6D3LiBXf09rl+QJXr6PiDHLwAvvkUCME4
X-Gm-Gg: ATEYQzwbOmL6RyYMhXJkKeT/ZR16JFwdl4vJVOJVx3eREcfXLYryMLPIlDkATJjZiSs
	TBeCq+Wg1PuIAKLbQa35IDjU/n61kQ7Qgvtbac8knjhwA86y6ApH+SnR9xeyevUqIbBlRKuCjho
	PVGxF3cV6nnxuVXLaCWsRcf+i/8UtyQwByyM5p9r37T7fj6B1Hs6ppGpQI5aFOBsIsR26m5IfGi
	6Zd5aKchK+UteFJ/zeup96Izyx031T8jrVSofhEl3LcRB0JO5H0u6L7B1fXioGXHEyARZWjtmpO
	NkLvWPKWEbRtdCqq81WL0aYjo8QbRj3yAyL+iS75Lh4VptLun9B2s73xnwYUagWtBOYBiQ/GKor
	MfLUns6juYm8YxUoNI9Q/B43wM6p+I14wuaKm3QP0P2GV2HbYDTOcE8C851P/mAXkKelc8AXTlA
	bWUdESpmzdmw2xA0O4P+uD3ERSTnqBF9EzJxhLIVG8dEqawW21p7JVWGYT2OA4
X-Received: by 2002:a17:903:32c5:b0:2b0:52b7:e82 with SMTP id d9443c01a7336-2b08270ec51mr78290875ad.16.1774159594423;
        Sat, 21 Mar 2026 23:06:34 -0700 (PDT)
Received: from fedora.taila51cc2.ts.net ([2001:e68:5472:9397:f52c:8e34:31f3:462c])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b083655b81sm93042045ad.41.2026.03.21.23.06.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 23:06:34 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	damon@lists.linux.dev,
	linux-mm@kvack.org
Subject: Re: [RFC v2] mm/damon: add synchronous validation for commit_inputs
Date: Sun, 22 Mar 2026 14:06:30 +0800
Message-ID: <20260322060630.82964-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321173235.84923-1-sj@kernel.org>
References: <20260321173235.84923-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: x8bqhnjjanchwmyh4x15spfkdwncnt6u
X-Rspamd-Queue-Id: 9954B2000E
X-Rspamd-Server: rspam03
X-HE-Tag: 1774159595-376572
X-HE-Meta: U2FsdGVkX19BVsz3wj6v+kvSNYzXnNnyD4Flqn6O7lqlsMC2L7wbgLB4/SvDA1kDtmwNiRKXSrw3tdmKWQzS/0v3FaQL5GRqfjQVzWcUpNv7tKQ7o1pLM4WRk4h6lD9R6iv4M5SshQ2gYSbJvacCEtFhdypB7Yw8GL6BeynKiP7jTzfNVn6qQInVXbILsTK4Wv3rfM/NSGEKkkS3n0UM/4MosCRetloA0UCvwey2iGRDrGYgCRZU7dFLW42GGMfQlyyVrYvDnwAaz7GZoRY84xytpdL/sVDoG1ab2eqCbWlC5TCPH5ZIKIe20k7wURvcOYxtUooHyhkxRekW0mvvri2KrFHYu3ZMBz3N5lVYWok5+ihfXyENq607zwkt6qOP3LZH/Ym4/cZf77LELpy74b00ait5E6JQBaO+xtTXqBnyBbuuqD/k/k2CxpEYYCpA1oieo7jViGM+ecTddl3IhQx5nEjoZNGM43TUNPsD9MklxslaaxCwOJqvKNiuBg250WDshCgyvO482jqU/9Uz+8E+yz5cxOS8wRT2lUAETndKyp9qiqnYpR/jChNKJ9Xai/BAQ8e2qaYjviEoPSzmSFXsCKaWb6k3wy0nNAzvjPgfcJ5Sqpc8ogbe5q/Dkv8ClnbfKkZ4NQrJAiTPX6pp7feFGdcRd+dTQxhIubYFxJ/fxSb9mHco25VufkKf5kndvXGlO2P3rtrSGRUimKoWx/0Y3+BWdQQCJ/rsXKvnV2O6wPQtJKKHaua3UmQ2ldDo3vx6rfnvBInX4ReebcsGUyw7N20SLYFGxzTropMdwg+npqfAI77z4ZuoR87ZQTeoZ6fXAsabLwnOgf3z5hFlbUe4A5j7/5gYRnTCKkmzGVJNmG9hkoROS/o5amvRjjQHMfsa6eLDSJy/zOB8MT9kYGJYiWhdKlslQl1MHqTc+uF7n8/hX6GGR2BDYVCodY/WIQP8AN5U2KvQJvnV9IS
 SlWKCjpb
 AtGnjsDXZLwp1CEBIYT69tGz2o39BnNktQrBsdUYTx7zoKTwiikviT/7ecF+Xnpj1LHCatL1EpM+4FzFa0Uz0iPuk3f48y36GkfPI7fajfT3Tw+8pY8xHF3J7EwWrTdXKj5YqyiBF5l3D5tMuYy5Iqzm8n+1LC9+ApDnZlJ8bw69DWsVBsYUUM7OW+/9m12CSYysA1LW8L4Dxyz0CGnpRfnPijziPxz1WAOz80KnBtZMnadzdRKxwLpCwIro9Ex0yxvhYXeR7m7/IV5i+ZI4pc2Ly8GbUnWWr0ktOjoichhWZz4u/I/9z4RKoNkRFFHpERPSOXyLTptFYm41h3oaJCKOomp/ORDS4TRW8yf6Ms4IUsQsMi+TGVKvdhOWxrM81C9qa7zyoUrb479juAaEqxwGe7z3r7qbRg8tq4aYS9tpN39rxFtzNKficF0kavDmSlL8yrGEk2XUuCMo8XdA3BCb1Z78jRnik7Ouq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

I tried implementing the synchronous commit using damon_call() as
suggested, similar to how damon_sysfs_commit_input() works. This
successfully returns errors to userspace immediately instead of failing
silently.

However, I observed a side effect during testing:
Since damon_call() waits for the kdamond thread to process the request,
the latency of writing to 'commit_inputs' depends on the kdamond's
wake-up interval (controlled by damos_watermarks.interval).

In my test with DAMON_LRU_SORT:
- With '.interval=5s', the write latency can be up to ~5 seconds.
- When I temporarily increase '.interval=50s' for testing, the latency
  increased proportionally.

I understand this is expected behavior for synchronous communication
with a sleeping kernel thread. However, since 'commit_inputs' is a
control interface rather than a hot path, I wanted to comfirm:

Is this level of latency acceptable for the 'commit_inputs' parameter?
Or should we consider waking up the kdamond thread immediately upon
receiving a damon_call() request to reduce the worst-case latency?

For reference, DAMON_SYSFS seems to have similar latency
charactheristics when using damon_call().

Thank you for you high-level comments and the suggestion! :>

Best regards,
Rui Yan

