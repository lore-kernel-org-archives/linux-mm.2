Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 510D7D74EDC
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 15:01:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3A4C6B04E6; Fri, 23 Jan 2026 10:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4ED6B04E8; Fri, 23 Jan 2026 10:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E4266B04E9; Fri, 23 Jan 2026 10:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8B87C6B04E6
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 10:01:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4ADA41A0319
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:01:30 +0000 (UTC)
X-FDA: 84363542340.26.0B6FBA4
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id 37B7180005
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 15:01:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Klt2dyH7;
	spf=pass (imf30.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769180488;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K+lpncMkcciaETgIgCV8/VHPr8GktIzZ/P9zCkM2a1o=;
	b=dQNdb6TWXoxnfbPq4e3lT/DDML0lq/x9PabdW/jAT83lpC04skMwjJVHZiWuzLmzhw+56y
	IF9kOlksXXg3JPRNl0VxkwyQhsA3H/8oXBqU45G/9hSfjGLzCCh1ESXjln4N7fg/9Z3d/v
	jrwWyf1gWtV1KUTE290wKC5Skx8N+Ps=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Klt2dyH7;
	spf=pass (imf30.hostedemail.com: domain of wujianyue000@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=wujianyue000@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769180488; a=rsa-sha256;
	cv=none;
	b=BxN0BYR0cq3XCi0VVrAeWL+qaNv0M1kuz0faNIBBrAz4P/8ZTmWDeU4QmdiUniEej8apPn
	e3zPnsRUV77r9z034vO4oT1I5JuiMHOOO/naS2F7bCltVkWS+uMZvfVbiiILwhJbYbrFTp
	6MzwD/SdC5w9LRXGaqwG6/bL4zjSD1A=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a7d98c1879so11420535ad.3
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 07:01:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769180487; x=1769785287; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K+lpncMkcciaETgIgCV8/VHPr8GktIzZ/P9zCkM2a1o=;
        b=Klt2dyH7yh6EFKJtYRZrgq1nlZalXRJOy1pG8ohYRraW/AiRQ5g+t/P30KOAYPfF0/
         0Aj578orNxxPpFA5w7cD8lMI58tuJAC/CGcwgtkcb9kZA45OerwViAIyPePaEdG+nkjW
         tfBJR7bYqvLvcc+winrdT4LDUDdZVVC8TQzcBr8Iwu7Rqzwg1Bh1zk1oRgFsusmy+eUK
         ernhxEQG0Wk/4/YmS8R8yDwH5x7ff9rwErJbGjES+rzELpbPn1caE49Oxj5YjTmOY+B2
         25cEK+UZjkli2/TVjFqnqOELHJSdBkxmTdjFmPpBV7hfiOj4dKN+coql/4QUEz7e7+5f
         O2Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769180487; x=1769785287;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=K+lpncMkcciaETgIgCV8/VHPr8GktIzZ/P9zCkM2a1o=;
        b=I1SdYL8fijExSG0R8akQrb9fQ/QKrUjzo9lV1GgSOxXSKGhbzNUKRz1OUUEVyfNUCN
         HtjglbKr3TFcmrnjYrvaHhOxghOiIA/+Dieplt9dpx8nvMnsjyXJXeJ0pWpZVxie6Zgt
         TSixh0kDdsn+zJdhAvE9ZYzVox1dTfLJpWp2xwJDgJ0xLHESJOZ++KK25Cia5pzHLuTM
         h1lLMIpMu1CMZ6uECYqc9s0JnRtuIjQOL0afv5JFB4CwantJHfJtf18dHkqXwQT79JDm
         bAkvfibeR2YsRNM6S7hT8DT4s41OkLb360xZ07LPzHcrVtTM3hu/E7GPEdT8JWTYa4QC
         vIRw==
X-Forwarded-Encrypted: i=1; AJvYcCWMBpBA2ctmu8UdT6Xc9mLfyRpYIbnxZACUxZSta21jW5aiwk8zqpvMbCQiZBuvNmLIRpGcAP7Trg==@kvack.org
X-Gm-Message-State: AOJu0YxbX8bhiUoEDN5PFMWgS7ZsmvfeSzd1zKdWJfq0Cg1DX2Sbxeyw
	L6mdhwVTsjKe+hIHQ+7zVMpnf30DLeS3jRSSoDYzrmgVNrIjhasMedoJ
X-Gm-Gg: AZuq6aJgE+Sh7pX4SfoDQJLNkpKDoncNpmowHNOXB/D7lrFpr2IyrkE2rifcKOTx70a
	dQV8Z3noJtmtn5nWyFeZniPxVTJNc9Y1YcM/Ft37JdHKSmGtpScQwwrirPb3lV5hV1j0QeL9Pw3
	kjT3LuADStYov1inBpnhvcCUznRhkqP6cj656o/V7VhyBVmGtKg21bNaemi27DXbhVg4Iu80w5i
	sB/lmJx8jjbk3Zei2v6hYGcpMcvEl0+X+Mxvf3/WyNkl60c6BPmfw78qDkJ1CZVdR+CB4aI9hsY
	/Rq8GBLtQV12uBVDslDpSy8GZ+RNpsm1taVLC/xW8ATSJwIjQtBN/Ug3tyIF/dnqvFrJCMm5nCP
	hfirpPxUxzhshaT9SPI+HTPYc/K3UpbV7vNbASS8Hpb2GJW5qnNqqw7L4iI95MuBClZhjkU14lc
	bmTLyJBW8L1MG1zNCiPFEkrUoLBNg=
X-Received: by 2002:a17:902:f54c:b0:2a7:cecb:9844 with SMTP id d9443c01a7336-2a7fe74b66cmr28603775ad.48.1769180485491;
        Fri, 23 Jan 2026 07:01:25 -0800 (PST)
Received: from NV-J4GCB44.nvidia.com ([103.74.125.162])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a802fae9b5sm22297685ad.80.2026.01.23.07.01.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jan 2026 07:01:24 -0800 (PST)
From: Jianyue Wu <wujianyue000@gmail.com>
To: akpm@linux-foundation.org
Cc: shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	inwardvessel@gmail.com,
	Jianyue Wu <wujianyue000@gmail.com>
Subject: [PATCH v4 0/1] mm: memcg: optimize stat output to reduce printf overhead
Date: Fri, 23 Jan 2026 23:01:07 +0800
Message-ID: <20260123150108.43443-1-wujianyue000@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <87ec59f7-2d76-4c7a-a2b0-57bc4e801d1d@gmail.com>
References: <20260122114242.72139-1-wujianyue000@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: hrctg8djr6qk18zn4dp38d9jepehf37q
X-Rspam-User: 
X-Rspamd-Queue-Id: 37B7180005
X-HE-Tag: 1769180488-939963
X-HE-Meta: U2FsdGVkX18gIldX4G0qGYqktqVIZ8Hh5FXVYFOmo1PhnAlHBHUdykIKu7+P3PuZKQmd+Rh0gQjCf+SXqbkC8dvylozTtBuWgqfrJQhPahhMLOMUH1tcZLAH5PL1KZPLT4PKwaptNde3xBT3oZhJSKOm6jqUa1jzNd5SfScFWYxo1pO8dCAk1fsVsgNBSkBeN2e1nR+0XH4gxo/w/Kgpb8uXXcPdJVRdYplysXsAP0Lb+DCVCy2aa7Pb78JfmQbWxhj0sD659NpjGGg8HekzPlOc7GZ4uwiJvmL42pwWiU+13Aey19aC/Wp/ZBetKoYAjc903E5vlI7JcfqEjk3GSfHfKQ3clmA0yU1fXfIDfmaARBEw92cb+nGNsFKmyDHvkL+pMtZaAdzeNk9nIPjzPbX5SvippNMNTQYCvWrd7SUQv/o8shh7jrVpAAVhpw89UGqWvGYc7ZY6T6n4ojRR8/4Vsfoo8craRPZ+ZYm9WrCMEGR0YGFWD4ILuQnwm+3+SEUxiG742wpZdNsGZ1BzvKsovkb9JWKWsVCF5rTT3bUQpDU/eYvSe0tjVjovrURlIOYNStRVnCR2jcC3MpdRDLweQI5z/D+vRcG4zi14dKvyIEq/68mcMj61hk9xuhwFvEu8ZIq1vRXIc3OVmvJIUpL1Xby+7mV0hkH12p9qFuy58XctePBAzIJZOzGhpHPH1d1BdXcV03coJSz0NqGtsuXxi6Kw/I6DU+UIUUvngR9bJAGcKSKLcIzNQ2cpTyg5x7rHeUszyMpQHR/m4gqlNL4uVXYxp/IuxF2HU/35kI6ynJt4dxjtT1y0s1RsKAEi7funO+M2KCXsnWM010kuLPPwacadnkvi3+P7xXCFunUxNKwq/vQo2KNLdjnuRViNYs1soUDoLlNlzGvgmygsQNkLbS7aL9KQl4/REkxw3xPaexsIw6J6/aJUg8jIX9O6Fmh/Zabf/6XQnMj/5Pb
 fJEHOcFp
 X50k8Dn38CtkF5O/DfQFEd3k6bbVs9QgHAZ9C8DNPbqCM63GeXmCXQwENFdqQI6Cxc8zLixAuPEJiOc18qH61KglYNGxA+l/5ghTVExnIczcxmzIhZVe+tBD/qGgP909ppydJ/7qVWLd44s6jdDrVlmGuLVhhDortFMHr+SFs5xgzWxwgwbDLNqlqykH3IhdEy2KOjKO3QDUSZyzKGMgREzJ644wEBpdrQJb+JGaIH1FDTZTO6H2Hadr0zQ8tRRUU6rG834vllRpiKiXvQ7PDz109OAPaupTT48NdzwKB4NwAr0aXVDEcsnrZrbVx3i/wxPV+egHb921LS05wu9QrZaNT1OsrQi7+DlVLv+OjWkqfub+81nTBCcei/dhDTMnuqMSxoU9ScwfyKBWH5uau1KcxczQW2otviKdJQ7GOyHfvxCdljUg7fja+5eee0benjo0fOS8aIPomoZjZwKb17Z3BwQ7ubeeODXSjS/l4YAk/Y1RinqxrkFfbrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch optimizes memcg stat output by replacing seq_buf_printf() with
a lightweight helper and replacing seq_printf() in numa stat functions with
direct seq operations.

Changes in v4:
- Embed separator and newline in buffer to reduce function calls in
  memcg_seq_buf_print_stat() (suggested by JP Kobryn)
- Optimize memory_numa_stat_show() and memcg_numa_stat_show() by replacing
  seq_printf() with seq_puts() and seq_put_decimal_ull()
- Add comments explaining the optimization approach
- Note: Did not add a separate API for the numa stat case because the output
  format "N0=value0 N1=value1" is too specific - the "N" prefix and node ID
  are separate values that don't fit a name=value pattern. Using
  seq_put_decimal_ull() directly is more flexible and clear.

Changes in v3:
- Rebased to latest mm-unstable
- Updated commit message to clarify the optimization approach

Changes in v2:
- Initial version with seq_buf optimization

Performance improvement (1M reads of memory.stat + memory.numa_stat):
- Before: real 0m9.663s, user 0m4.840s, sys 0m4.823s
- After:  real 0m8.909s, user 0m4.661s, sys 0m4.247s
- Result: ~11% sys time reduction

Jianyue Wu (1):
  mm: optimize stat output for 11% sys time reduce

 mm/memcontrol-v1.c | 84 ++++++++++++++++++++++++-------------------
 mm/memcontrol-v1.h |  4 +++
 mm/memcontrol.c    | 88 +++++++++++++++++++++++++++++++++++++---------
 3 files changed, 123 insertions(+), 53 deletions(-)

-- 
2.43.0

