Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53C78C5DF97
	for <linux-mm@archiver.kernel.org>; Sat, 22 Aug 2026 12:17:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA2B6B0095; Sat, 22 Aug 2026 08:17:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6AEE6B009B; Sat, 22 Aug 2026 08:17:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5A206B009D; Sat, 22 Aug 2026 08:17:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 97DB86B0095
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 08:17:04 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 149A3C0112
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:17:04 +0000 (UTC)
X-FDA: 85128804768.22.E226A9B
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf01.hostedemail.com (Postfix) with ESMTP id 5AC0140006
	for <linux-mm@kvack.org>; Sat, 22 Aug 2026 12:17:02 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TDfA+q9i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787401022;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jsN6LvX9NPfCQNk61W1iZUjewLQksV8dhJul9MwmJzE=;
	b=uBdf1JKHozJq5LoVNLnCWjCDh/VoU7cq4mbGapbA1JHPWJ6VfdSl9gpHIyMFrzwLYUnbYh
	zyM3fgCxK+ngFmJKZRn+ivq2GyUWXDsVNV4nvyfEF/NNir9OJXetbHFVkeMnye6c3Om0XI
	38q3KF5UPQ+M+iiKgLpcRgSZ/iFcg1E=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=TDfA+q9i;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787401022;
	b=Dod4SjwhcEmPVQHSBzD/yDZXvUHTefaZIgNpr8ov2jCzdrr84gbnMp6P0bziu4Ar047zo6
	VpuFX5pQGJuCbBxI3QzlskoQ4uSmeBO600waN4imKENWwv3tB/tomnWR2BkpruzU/Cl5GV
	NePIOy5fEryxooHk0n49k0sxmNTxifM=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a0794669a6so3798388a12.2
        for <linux-mm@kvack.org>; Sat, 22 Aug 2026 05:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787401021; x=1788005821; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=jsN6LvX9NPfCQNk61W1iZUjewLQksV8dhJul9MwmJzE=;
        b=TDfA+q9idV5M5uP8u2GfGmn4io9naOoGI6qHrM/YtH4zguArhbmK10Jz+X5q12Nk3m
         WVgEuQv1b3RNUxukv0C3pAFMGu45YII3IAhZT6ndryY4X+/zgeUKwGvKfBwwFi+TPVVa
         8tvOk0kedjUYYbSOnxOLWNwlRLKUcpx87YWnA00R6cxOHJ3K1OdPfmBcaJZoO+g36W0o
         pZvVjLDGBAUNxfva3ifdRS9mReOw5Q4JbZZIdF38H1qH5yVkMgKXOKObF+B9vNW7BRkn
         ok5PwGX8kor5Y3aHMQZoEXZUXWx8uW20gzEWlsfQXJTpKObIGz35fkFlZ8IIEkRYPXPo
         9Y+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787401021; x=1788005821;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=jsN6LvX9NPfCQNk61W1iZUjewLQksV8dhJul9MwmJzE=;
        b=PgLaakqueqwUN4HMSEQpaNk8ADmPodVs9y81gW/1o+GpibxXvKfVEK8Z1ZUH6O7LPO
         X8xsCCCcAhKiDAzTYWCKeg6a5YWHQVG4uoPYzScZuF8z/4J7kAtw2mzAuTG+DHjgFf2v
         xup6KMv2Ex93zNxgA+oZyfSVPBp9lxH5oRrPoH7XnviCe4rEiitUgr5jLTWCGmIDYopM
         3G9hWgC7ronivGAYGfezpyZTmKdRNr4Qi3bFEneuEbaUrbisH8BE/DiygdbmXss/XqO8
         u/eFyFEb9jO6orNFp6v90nvawwk2R6dMCWoRlLYxoZONBNZPNLL9NJtnWti1cdNq2UC4
         pkaw==
X-Forwarded-Encrypted: i=1; AHgh+RqVRUSdBWE2+nwli6WRtVJ7UfX39+KR6EOklIUj5/qDZp68jdCTwSLGczX+hhchxYQk0Cyv+BY5yg==@kvack.org
X-Gm-Message-State: AFuF++k3nIsAYenfh074WWfdSzuhHxyunTY86GcwBlVuJrpvzbTXGVCk
	XxycWxbU/zTA7vLZ5pCjqSxrGEXSNg1Ss3sLv0pQxvflpdBcXRSJLcNX
X-Gm-Gg: AR+sD100r+uERAfiIFmh5KqQWRKK7C40PMkQ4zyhYoadECxe2w0hDpVmNwti9GLs/ww
	pRRnTsqUk1Q+8WrwZNuy8FOCFgs8EXX6esUIFSX69sAx8WKmkwXULcLVA01wRZ36RmD5z0UTwCM
	ag+2cF6y4hvr8fEmc2o/D6ANxR9iwyllzwbJCNi6nqK2GCvIAJmdkVOiJjF8NCSWSt633sw6wwJ
	3YSHGUaY6p98BCd+zX690x5Hl9uCN3TRw0psimv6cOh0+rbrDYde1EwZbqr/jjuK/ixpWkAF56w
	/t/usJvBYrDqz4wWJcNn2+K+PCA5b7DEUo9x1ujj/Vti9B2/Or+dwA3oiEzJzHT9f4Y9ZkWtGDR
	PtSqiZYGUDSz3sH9niX1+dgUMhP9MluMcwetr/ZWwPIHcEBCvt9GCdbf8saih7MrbolRFqhJ1vi
	MDmK1li869FbYR28HB0FtUnLLCSipbVAwxMKR76Zs8+6nFy113tMP3xZi/PgjV0BP8JOqiVW/5F
	2OJo8rInBmrwqPVz3rhRa2pboVD6l7+7J3bnjBBrtaoBL6YhtphSnUyFKk+qGka40EvwnttGVca
	yTVjx9wBv4x01spps3bFQMlz/xZA8hBDu3NiinqVCPJi8DpGzDGANbtgv8Vcbf24POcP
X-Received: by 2002:a05:6402:5513:b0:6a4:2ee:5c6d with SMTP id 4fb4d7f45d1cf-6a582b16d2bmr6451179a12.6.1787401020491;
        Sat, 22 Aug 2026 05:17:00 -0700 (PDT)
Received: from localhost.localdomain (dynamic-2a02-3100-a0f5-8c01-3de3-cd62-aa6f-2fb0.310.pool.telefonica.de. [2a02:3100:a0f5:8c01:3de3:cd62:aa6f:2fb0])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff0c30casm10998322a12.7.2026.08.22.05.16.58
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sat, 22 Aug 2026 05:16:59 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Thomas Gleixner <tglx@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Petr Tesarik <petr@tesarici.cz>,
	Bagas Sanjaya <bagasdotme@gmail.com>,
	Michael Kelley <mhklinux@outlook.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/7] docs: core-api: Fix stale function names and a broken example
Date: Sat, 22 Aug 2026 14:16:44 +0200
Message-Id: <20260822121651.1559-1-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xip7tp7s417xs7hr4j54kx71ic3zzfgc
X-Rspamd-Queue-Id: 5AC0140006
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787401022-485939
X-HE-Meta: U2FsdGVkX1/l/zmtjezExW/PEHKxzgQ6nUN5fj+IQ8tCAadspSufMa5lVKwV61r9nhthyQ32wTQH/JQK8abKVYvfCmqMprbAjy1ZJJG5u3Yqku22OZrOfmOVY0bxEmxTYvaoI2lA2asK2oVGk00TDzr94k/7LsEim1z3XDXG/tnTaOIVSxfgkfm8DZQXcA+RHmZP3oNyayUkFLMsuHruY7h/zIHqvBGYZFaK9Vw/BEJA9KvbRQIV8Khc/HAJPgi6fKK+zpJ4JB9lxD8yIrTMGL/h1DI6ZWnehkGNLR5ipEGPwNyfO+LjXp6R0TAcat2xvZtbLk0Mw9BMrmQMhc+P+PGFVH7ymkh7WC2qN8/zztYPJLWZI3mqsxFboIe13B6pZslNIs0nIB7ZzBRg6/EJYM/qvLe+Ow2THMNeBqFr6ZL/qMbi8U8kf4m9e2zKy6/PqoFDPVCtEPNDV/w/aohgIFKdnbPv47hNMfIme5oVFoLZwVWNwUSsAVUf98YqaX9N5XCK3fvltPRbmwEaVu5TWEfiqXlDr+LgxO3qDUXr5ofnzGza4+0LGikpApUwa7dNMwzPpxa+P1uONkrDHfxnxV8a3Tab4USthwvyaXc9kllR0znJ5PjjVNZT+k/DNLLQ/yPovjd6mt+fKFUmqM1sV56U1Qi2hTcAxPwARAI1yzCezC8UPBHBxjz2yLpk+q/2TKt3eIC4F6uPDOs3aoUhHt4NnaY/Io1UOCC4hxBRXfJE8XwIdNVkSu4bQfnK62Dw6r6vzygBQNbDAG9Nt4M2krVlr9eqXiydUOTFcg7agRPz9Ak0TtqO20Pac9nhDvmNTdk6jJuK+zxQVxfB4MKh1lyDjU1iGETyhfmhsguw9g9vBsfqGkQ5kvbGD0pqjls3w2iP1lEuhcEkaZuqBOcF68+JhHhF7yYxtUevWTRm+7deEvs8aBe+zqteOSy7tvgKjamcnxDL1NvPXRGRgIZ
 nw2J+qTs
 201lOUnfZYGQPhwDVQhxD5gDVderOUlj4WX+FceT638zijJJekYhYFe5cf4tq6Adl7L7DQWF87v2vumnoLQdW2cGIaB+L5Fu1WK/aCLLj1jfKA8gmZozM5Vqd9bhg7cfAPacUkl9mEagELEf1daPHGdeX2WbFqj0vN92GC785GYcBI4cNa22GKpiAbf195zvcnndsrvkv5qHWdGBaqaecBRukbA/8pVh9edjTkwS43QPg5mzXxzur9PQklEtrr3lDS0x9HlIZb7n/zE9S/kc1i804nlOQxfkZFwCWD1Z57CjPwzh1ErbBuZ1dwWeRqdeytQGzy02j9NU/dU+TAy+3Kd+f/x1DLxZGZhrZa+miD4Qu13OaMNvQFSgPZEDFJIc8QnSGDe4hFERcmMXtNcX4tif+BG6IUZh8zBqrzKtk0+x+bOc/4NyLJXG9Gg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A review of Documentation/core-api turned up a handful of places where
the text names a function that does not exist, or an example command
that cannot work as written.  Each one is a plain typo from the day the
text was written rather than an API rename: for every patch the wrong
name was checked against the tree at the time of the Fixes: commit, and
the correct name exists in current mainline.

The changes are independent of each other and only touch prose and
examples, so each can be applied on its own.

Karl Mehltretter (7):
  docs: cpu_hotplug: Fix multi-instance removal calls
  docs: irq-affinity: Restore grep in example
  docs: dma-attributes: Fix dma_alloc_attrs() name
  docs: swiotlb: Fix maximum mapping size helper
  docs: this_cpu_ops: Fix SRCU helper names
  docs: xarray: Fix xas_try_split() name
  docs: debugobjects: Fix debug_object_init() name

 Documentation/core-api/cpu_hotplug.rst | 4 ++--
 Documentation/core-api/irq/irq-affinity.rst | 2 +-
 Documentation/core-api/dma-attributes.rst | 2 +-
 Documentation/core-api/swiotlb.rst | 2 +-
 Documentation/core-api/this_cpu_ops.rst | 6 +++---
 Documentation/core-api/xarray.rst | 2 +-
 Documentation/core-api/debug-objects.rst | 2 +-
 7 files changed, 10 insertions(+), 10 deletions(-)

base-commit: 26260251022fbc2f248a3d747a9b2b961b18d2d8
-- 
2.53.0


