Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12309FD3769
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 15:40:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FBC36B0005; Wed, 25 Feb 2026 10:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B32A6B0089; Wed, 25 Feb 2026 10:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E05A6B008A; Wed, 25 Feb 2026 10:40:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA0C6B0005
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 10:40:07 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C15CC160626
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:40:05 +0000 (UTC)
X-FDA: 84483389970.04.3C455C3
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf29.hostedemail.com (Postfix) with ESMTP id 08F60120013
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:40:03 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RE/kjKr1";
	spf=pass (imf29.hostedemail.com: domain of 30hefaQoKCNE9z8xC5AF753BB381.zB985AHK-997Ixz7.BE3@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=30hefaQoKCNE9z8xC5AF753BB381.zB985AHK-997Ixz7.BE3@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772034004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=PrULVJVjUkqqWE6IcEaH9v85Dt36UVOcnshgCer74SI=;
	b=dNqJP0mnZ17gkeYsNcRak4P/cKMmzwpTg0fTtmVLYUuY3ga5l9KePRHbqfUWDO6SlUggv5
	mUaFOY/jI1wn+TsPNUBeV8Hd/4SX9o/PlZWyha75tY2o+SWpY9RZuD+DIQwmfb/JsJoRWs
	SFVD8G8+KnYLPHU2W54RU4/9+YVtQSo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="RE/kjKr1";
	spf=pass (imf29.hostedemail.com: domain of 30hefaQoKCNE9z8xC5AF753BB381.zB985AHK-997Ixz7.BE3@flex--mclapinski.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=30hefaQoKCNE9z8xC5AF753BB381.zB985AHK-997Ixz7.BE3@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772034004; a=rsa-sha256;
	cv=none;
	b=FPog55Jbr9uAdNKxpRsJFLGZUN8kzYknIRz5L/OmUoK4VhpUbMCyOR94Kol8KncKHLfX4h
	cYEOeD8d4d1gLI9N1uq4GdbBKTGfJC3qPIwD3Vrbx74n5FGLoGSPCflaF22CA4odisACE4
	aCp7Nt3UvFbw38sf7uUh+3xKGAohcIY=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4830e7c6131so66741225e9.2
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 07:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772034002; x=1772638802; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PrULVJVjUkqqWE6IcEaH9v85Dt36UVOcnshgCer74SI=;
        b=RE/kjKr14LQKdbGSwYFOezHnTfj2vXFx9Hn33KAHm1LcZ9v9hWRVidllzwEyXQ5pHR
         dxJuqvPkmCVHn92hDCOY6nXs9mkUjkTe+VgzNjYyP/EeMF2lSJPBVGgblw56iz1t1xJN
         X6Nxq3hhOn4mmjUsM/7rDKkomXWLLfc3D28b77m6DevAugCRBtyPGf4BfDep+b12swUj
         h88ao43nv1wolLMkTntNb1T3SpYHkApJq3JC8J+FX67aYqTUsGKMF/NDptjtnTPzw1iF
         V3THXq5fxZNYEgov5OHwOCiMgOTCZi/CBoK9keDt8BG8B72Ost/OIjp5PddXT6Fuy3Qo
         MvFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772034002; x=1772638802;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PrULVJVjUkqqWE6IcEaH9v85Dt36UVOcnshgCer74SI=;
        b=odj25Rh48mPqCLJ8f2IiU3qDxIVRUa233BZjZAd9SZN4jzXuMHOXfIp1FWJjhQdzrb
         HSV77pVck2mXvhsS4MkBKL+SQUtlXc29lEKeVr+YFnMqf/DzrNuneVL8ywgznN/Eu7c/
         sJtIcPZJSnfMoxItSMUPQ/sgANGt/rO6jAFnQYr/kty+7pMkyCGSkya0nyHbAIknRb5x
         CyeXVkvB7Jfjb2yXYBnfS/wqB7EFxgiVAXQiJvW15tbVDbRSkINc6NMrCegICFtUdKXD
         WNTkx827uRtggi4cSZ7MUZJVPMTcXn6dd6KLMvJaTsGJSgox6aYyBYz2+cMKo77+8Lab
         RS5w==
X-Forwarded-Encrypted: i=1; AJvYcCXs7gjNEKGu9AfiZ2ujbsgTnFMmbLEQuIDFFnEsA2LVv+clJosaBY6/Iv9otbDZ2l8Yt12EJlg0qw==@kvack.org
X-Gm-Message-State: AOJu0YxCw74Oed6kAkowzN0cFmW2nai/zr3AG1N+RsYHzwxFIOPrr4AY
	toq/k7npEakOSq44f+98ibxvWqIaugLW9oWmGqSdSKI1vAlcw0a4CQWgFa/ZjFUGfWLPWtBZaIB
	BA+qspbQb8Uwh8sU/fDOUvQ==
X-Received: from wmer21.prod.google.com ([2002:a05:600c:4355:b0:483:6c98:3d2f])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:c172:b0:483:aa2:6bce with SMTP id 5b1f17b1804b1-483c21a9f7dmr13544945e9.30.1772034002241;
 Wed, 25 Feb 2026 07:40:02 -0800 (PST)
Date: Wed, 25 Feb 2026 16:39:53 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.414.gf7e9f6c205-goog
Message-ID: <20260225153955.1006649-1-mclapinski@google.com>
Subject: [PATCH v5 0/2] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08F60120013
X-Stat-Signature: jrefix1cwuyank73dqm3aumptp9zmiz9
X-Rspam-User: 
X-HE-Tag: 1772034003-240878
X-HE-Meta: U2FsdGVkX18qVMpPelYyjrDqQVZpizKGUAdcZIT8g/BJ0tBjS52IRKtztZLv96vYar4dtRrUt7I/ro8YwK39P9qHXqUqt8m01ST/cAHpFwfNEXOaR9PEmU86nSnhXjZ64VwMSEkAJ20cPxXXNrseY0wHmkMhdiqdqK4MRvA4klRiJ2ZXG+hhAEUNt/PrLzApw/awpKsBcz0Q8+cDHiJxkaUUHQFwYIySYTjle5M1eB9IpjvXO6J7x7EF5+KW+ei2zc6QKZksDsBT4wdtFUI+6Cuz7CGL9G1IRCbm7zbBGg1NhKRFoajdACD6Y1pj8Uewq8/qZMZf2NM8JN1yrkoG4otgTuG1HAkAezukvIy7HCXMF6QtEAEm1LGh+KcMm+lGTRTJ3dl5YQ7nVK4XH2NqJBKYF3vT1hyapGQqdb+bzHLE8dLk6qbgKgjceDG1ihD7rUQy0RSPPQjPm7E3fpsWvjvd1WuyrEKJEzBIQiI00aiqx9kOMr6E+L36a7TXTsTteqphmXXkemNMgFa8xmmQfsuLTzVPLS/YWgCpYzJjm9tQ+N6lcGmusExyvr8gjrimVPuJtibo/w6sbzAhFFYWv+5PBbr7quWP8qNgUzvPVhoTDTtjsC5SGXptWIyXGefMJh98yxewwO14iH3dfce+RUnpY9f3Ep8gqZmKn580LPDk7McSv5Dd4ZKXIh2UL/aOscx7efdwpTxGbez8La0IliysqgEazXMGeCPA/s7j5lBDv1EeBn7oHVuwJbSeY1a42amvedH3HQyeW7SvSiu8Nx631y9qxW6Ngy3fNkg2nHi+rNlsAw7uXWDmbxXfa6zEpOzJ9ELXrWe00agsx5+Fpsl0oh9bZbVq4/oqelS1Nzkd62thfmtVsMFqWBa4iCwnV5g/toS7kHJ/16pPlS738peU/UIecz4+fQs654dmwP8fcaULWQUVw4WRIu16+FFy1iLz9PWGhIueTmdmWFj
 HH6ser6T
 0pjIDB/cHb1a1DBRLQbI/Xv7qVM7VeU9zikl9cpD/EDPT95NT83Tpnpu/IpnK+Ah9jeDbImwpMl1T5yYBQQBYDwuhOzcBbknoxUv4Qf3fqI77js4RxYH4GsaEK46EiLubotUtLsIjCajJ3RAX6Quw2lrmun3dbiJP9XYQFJH9ChmHpTi/9dufpVzEEOK9oFbGUEL4hFx3LtwPnRljXdDQsMY6DDT0qdd8ApeVstc34W+WNPnGcUa8absC+APlaJ7TazyguSaaK4tBJjZkmzkbBpAdMtvISuGxs8cytrr3F5z8TRf4/N38xu4Ydt22T2XAz1NVvkKtax79Zo/tWN5UA4fGtUZYoJBXZ1LM+SBNsVmWESx3MCCbmanKueIGwVs/kSPTZtK48lB5Afq8/oAqBCPq5kwZV6kB+g+OsMWeBCHhoml4R6w1Weqf+2zuXTbQ1chhl++q3xvD7k/0ftBtqr5rQImSdydbBU1BVFq1OZeAqmLbZpWfXkfcnHSOe/p7t8vFxihPVFYgIX1TlsAbBm10yPhJQ5RJywmrpIRByg1a8VeBRJBmpQolKDplRMLS7+E3rffk1n9AEnYFGo3q8wAyhaQDMz71nJmOMVaOtSJkTXJF+EkgwcIvkz/922hjfiyHTbuMqa5i3ySdfTzvAZkESI2C3aDgIL8P0VBnKouzyHk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is
enabled, struct page initialization is deferred to parallel kthreads
that run later in the boot process.

Currently, KHO is incompatible with DEFERRED.
This series fixes that incompatibility.
---
v5:
- rebased
v4:
- added a new commit to fix deferred init of kho scratch
- switched to ulong when refering to pfn
v3:
- changed commit msg
- don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
v2:
- updated a comment

Evangelos Petrongonas (1):
  kho: make preserved pages compatible with deferred struct page init

Michal Clapinski (1):
  kho: fix deferred init of kho scratch

 include/linux/memblock.h           |  2 -
 kernel/liveupdate/Kconfig          |  2 -
 kernel/liveupdate/kexec_handover.c | 70 ++++++++++++++++--------------
 mm/memblock.c                      | 22 ----------
 4 files changed, 37 insertions(+), 59 deletions(-)

-- 
2.53.0.414.gf7e9f6c205-goog


