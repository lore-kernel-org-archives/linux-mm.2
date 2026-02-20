Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7643EC5AD05
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 16:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8FD76B0005; Fri, 20 Feb 2026 11:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A5D876B0089; Fri, 20 Feb 2026 11:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A936B008A; Fri, 20 Feb 2026 11:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 74ED86B0005
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 11:52:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2156F140211
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:52:12 +0000 (UTC)
X-FDA: 84465427704.20.A3A4180
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6AC7E160009
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 16:52:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xfiIyRVV;
	spf=pass (imf08.hostedemail.com: domain of 3OJGYaQoKCBE3t2r6z491zx55x2v.t532z4BE-331Crt1.58x@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OJGYaQoKCBE3t2r6z491zx55x2v.t532z4BE-331Crt1.58x@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771606330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CZAtOD8ZRnarQucUHW7t2nY+Ut5JOEodfHGgZzqPkiE=;
	b=zhTKOZI7pHmOH8qtLgAzd+u6sfpjg864fMwK//ygYwYhW96iQNT5oAW/0cc3lYsZ+auHFT
	YMO7R5gLLa0EnTStNYhnntWgzyo5ta/iY3m+irEKsdtnfFEfRfXDlA14+mFxOyIvnJUEQ7
	WIUEKmxjaecrPbe+uv8LaJSvdhQUyrI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xfiIyRVV;
	spf=pass (imf08.hostedemail.com: domain of 3OJGYaQoKCBE3t2r6z491zx55x2v.t532z4BE-331Crt1.58x@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3OJGYaQoKCBE3t2r6z491zx55x2v.t532z4BE-331Crt1.58x@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771606330; a=rsa-sha256;
	cv=none;
	b=rPdx3XOeYZs0okN+mIjOwjZY4+5xPmoIv2LsiZGwaFfIYzCx65jrFcDq+ZH1bykekylQSm
	GcE2hd4QQYPgIDGI04bVryirq7tNdrba29To+MK464yHNMGdHabQYWuK7wDs+PGMujCHhn
	89kLuJM6up91va5nIYKzyvTWSYb88xg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4836cd6dfe6so17691345e9.2
        for <linux-mm@kvack.org>; Fri, 20 Feb 2026 08:52:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771606329; x=1772211129; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CZAtOD8ZRnarQucUHW7t2nY+Ut5JOEodfHGgZzqPkiE=;
        b=xfiIyRVV7aLZ+cRwvg1c8v3YkFcRqR1e7hGuV2eHnIFxBdqfK3U11YdsVOJNeJj3J1
         lAXmYr5UYM51Bm+DvyyevO8iRcQhnN8g1sv1ZCDD6eL+oDMCRAPTCHquzWtpxVxB7C+v
         BZ+8JRDqgmvzZP9K75D96A7EYFLkJJwrAXzptqQNcWWcM7QokrwdIforRF4toZIcKIra
         BeESF0Pc2ssl99eORDecG5oZInbB+x0F1i6CyVPRnr5ub5Kv6VU06rYoIrIXgGYi7H3p
         1vV1wNfeZIWbdUGz3hBT/n0vnU+fLeiAY+qoyzkFOoYftt02nAwfhJmeok+QZy4VggfE
         fsXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771606329; x=1772211129;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CZAtOD8ZRnarQucUHW7t2nY+Ut5JOEodfHGgZzqPkiE=;
        b=LYnZ5/6XyanNewaDEd6lIRnhSVgDePCGK7xHKxoPDGXTtmH3PeLxRBJvYiGEHSCdN7
         fa7aUK9o1zn/LP99tKlkYX9EQtpWNRteWgXDxS3h7HihzqHnru0yDZQQ18kmgsQMhc3r
         +X4d9L/axApqmrSkXKrFTpK67E/4Y2jRfII/xbZgRrX1okUu8l2o3a7Jl/gtfj1wcFYT
         tFXA8c1LU+e+kFS6dmIbNAVfw0zw3VoAh6E8c8H2YygJJaKOJqtQ1kHQsHq32KrStYZn
         PPy+OsuQcxTQ6GZuSBoJQ9dxwfgiryMZiyvVzNgSo0oQTiKkbqltdU0nI6+Ihc0WxB6D
         k2KQ==
X-Forwarded-Encrypted: i=1; AJvYcCUcgN621eHANqEXxFLX3e2gHt2osny/etvN03v7l6HQizOJVdAH3s8zsvus0Wzz5P1Bymx25OH28Q==@kvack.org
X-Gm-Message-State: AOJu0Yyj4QgVi9FXe7KMLauUOUrKTijpykn/9RLMYOpFDIpXRKWbyRgv
	L6Nyjftcg9MxB+orz2Ta8v8DNmXoW0jhgz5wLr/vnJ3yYFhJhZyfVFXYxmqSfLCFgIIs3g3fRIu
	tQ8NG3vkIs1JX5KSXeeQeKA==
X-Received: from wmog4.prod.google.com ([2002:a05:600c:3104:b0:483:6fcc:920])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:5287:b0:47e:e807:a05a with SMTP id 5b1f17b1804b1-483a963c238mr2105545e9.33.1771606328737;
 Fri, 20 Feb 2026 08:52:08 -0800 (PST)
Date: Fri, 20 Feb 2026 17:52:01 +0100
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.345.g96ddfc5eaa-goog
Message-ID: <20260220165203.3213375-1-mclapinski@google.com>
Subject: [PATCH v4 0/2] kho: add support for deferred struct page init
From: Michal Clapinski <mclapinski@google.com>
To: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Mike Rapoport <rppt@kernel.org>, Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6AC7E160009
X-Stat-Signature: 75okk1wfdt4bnifj186wtbuyrbp6aiu6
X-Rspam-User: 
X-HE-Tag: 1771606330-288300
X-HE-Meta: U2FsdGVkX1/52HVlqJdJsGhN9PgYI21z5WIsHbL3D2Ejh+A+T11SzUJsAAxaSKVINwHK5PF1MxbJMdqH7vecSNhSlz++av/OGIHXyaPAH0Exng2I+HxCkTSU7Gzb6P/YkYNuUez0q584rvtCH0qGkOoZH1CyvtVMczH9+1+eBEv0baiG1bigxnjn6pYgbjVYBM5Esf5wmI9FX0ZqB/+iUgDXyVRj6OT6OAhL5nj89HrjUMr+66RSM1qWnBI7oOAP3g5v+/SHUH8eiW3EZIZ0HKaiXX85DY+CxC3ixVPgnQ+v9fQplPiEt6AEzE7LmdZ8tgbUCkgE3QM89hMuSlm76mZXQBiS7wcwWSVyqsFLu+wEXo8hINAshz6khkvYejzRfHwTKLMzJEjLNDGp4jFzEWaEwudVbriPNwdz9r2Pd2Jbvuje1UlpZSoC/7bQhCsyceEYjvuAxqnBD8SYp5B2ZIjkXocGyCoQk8DinUg3g7mjLkbi7+exkoOqS13yd++N+09SS7swXpWiJXIX/h4446lVvCFOtmWJT6S/ngSHmKBkGm+arYrrItxp9fH6bZcsvVvXp7gJXDSgTdrhTP3Qg1UX1DopcEBRU27rt4MbjGZpWB2BUwHr+Y9xwNLZGvPS4rlNsQZPGHQ89pTAkkj4hCVnbi4HmMgkAjWgKwB2ygtRCoDdY5orA55yulufTEW8SEPHRYXgysnoIymkjfhSM3Xna4IWgR4y41ppYfW0z5nWavwObjNSZpEFMqyENwdniZ1x0xqJEVDA/7SilPgC/GbFZGVE2XB6dzG56E5rvZ1AoJ1epkc1AoyFUPKQRBxU8gfpw9P8zAX2r/m+/TWzsKinE2ShVsmGOtIEe4Xo5dHrvvDRGfi/wNIbSiOSV375mPpC4h4mTG5Y0Q5gvSSb8ElqAkeZF0vormYQPGH1McGGtLU/LQeUCWLlLoZHCaZdY+lKgj+Wa5psvelzgRG
 q2eFzJS4
 T0qxVNrZVu8+iimAWsnK4VnzLfqqk8GVudrtrcx219WpamB+XwhyzZtf3mVMnxO77uZomxQzM0NaVqkHHPa3N6G64lcZ5+Htpwh0NqyOJ3R5NZdC82Wpzkp/osZVtRE3pJIWJAn0qTCJBvvyfd+XEFSb6EMg3H/xTrovS1ijl1Z7m1Y9NnOv65JRGdFie/89/6r8fuy9LNp+w7obJL7NyTcmzt+Vrxd2cqpeGtgxPGm78FS6qj259FyqAaqvZeT1SatTnaZw5AUVhkz+3JeimllHm/seeZ1G2O5afyYMCk5uPHblFEhkjamie5l2aB+PFav/JjrxvCnjsTK5Omawuc/qiMLOxKN+POEhDdLjE97uctrmDk4Jwupc1NRd32UtYkFcFJyAKEAduShWhNXhoJwytOkNMRL4I+qZu1KW1QmBaBRj+lKWv5VQYVxcbplPHWOYPMKWhcsB2ucdP06yiANMr39FDicdoBIVJiTo8pJn1OQucfJqJjzIsGCbWb4VU/1Eq0ZOpd/fQYB8vCt6dkSG4ECko6b4vY4PnHcOXzNb+5e9KkVmAIK0bgdqNl72etVLR6vL0J7/4RiQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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
2.53.0.345.g96ddfc5eaa-goog


