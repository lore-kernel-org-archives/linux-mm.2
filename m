Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD4F8FF6E9C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 23:07:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD686B00A2; Tue, 17 Mar 2026 19:07:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB46A6B00A3; Tue, 17 Mar 2026 19:07:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CA1A6B00A4; Tue, 17 Mar 2026 19:07:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 85F016B00A2
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 19:07:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2CD88B9351
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:25 +0000 (UTC)
X-FDA: 84557093250.27.42B29C0
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf27.hostedemail.com (Postfix) with ESMTP id 825DC4000F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 23:07:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXbrQdwk;
	spf=pass (imf27.hostedemail.com: domain of 3qd65aQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3qd65aQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773788843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Lb4d72Dw6v8zTFjLSshGhZJgBDqi5O2Bbx7kiArqy98=;
	b=R29yY/vWYWwpRy+DkaV9hcOY1vlS1HgL6v9NBjV8YbUiAKjQNXx6+uKxxpmB+Q/pP0pErv
	yyzEoImVYT5hMohz8Robw061cLhFxCIylPR5PqcGgU/XfTbwx7YTzzWNFqMnUIZ0AUUVv8
	OBWx/dnYyekKlXQs/GnH2WYo5tkYcK0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773788843; a=rsa-sha256;
	cv=none;
	b=gx+ouSJss+lhHqjZc/0wlVM4j6TYY1N++FkAO9bggMZivobleD6Mu2ch9Wu44PJ5vov7Iz
	eWp2pHQqFPqvbuEuh+guyvNhcztvxi1LxNkE6Z7X38C47nEki0Tja92wpI0Gq1caxEG1VU
	4CnXOyMqmPhngln7BMrtYsjhcbQjdEs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=uXbrQdwk;
	spf=pass (imf27.hostedemail.com: domain of 3qd65aQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3qd65aQgKCKIDKPILKCQIQQING.EQONKPWZ-OOMXCEM.QTI@flex--bingjiao.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2bead0a9123so3287924eec.1
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 16:07:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773788842; x=1774393642; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=Lb4d72Dw6v8zTFjLSshGhZJgBDqi5O2Bbx7kiArqy98=;
        b=uXbrQdwkYYfUhpz2mGLjkWwTCBXnJ+96QLlcV0EVrnvaMaaWizfAR7ddtiu9mhnC7O
         AUbdzONywDv4TznvYIh1BN1nUNLSoXchO8dPyyokKpd2spiw1BeWmBEfmNfueAj2eGkT
         SMKXhUSb1XMQhdqlkhNRqP/Tctz9pVpWozQ4Ab6QZz/7LLub4e3oNHcG4rT8zoAb3ZuT
         ma4DbtBMruQB5T09omuyMhb/NDAm4nRsgHrDHRd/rPNs2R0ypsfPn3ECUsTdEK71kure
         x+b1zjiVqVdJYiYxf1gfmekzA2y6g1Uo4d5082r+76OmlUfKChMqSzXmL14PM8zH+PM8
         I5bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773788842; x=1774393642;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Lb4d72Dw6v8zTFjLSshGhZJgBDqi5O2Bbx7kiArqy98=;
        b=Q2+RuqTDHV01juIbf+hets2CwBV/xg7gzikrAt6rKI5bImg6N+sBoYorOXru7LvQJn
         qvU4738epP+CWeTmbqGgtA7+0RdMpT20VDlsKKs/tCFm40582dX/OoEt/X4vW3EBMgL5
         EIR6FYekdvDJDaXR1j7kEw0y+e+KqxOZN9Wpx42IJ2FjedY8kw2HeX9lqZ3w1Kld1WA3
         TO9LER3w9J74SqWsWhuuB/yDVbkqxt3tfaTcx3a7ELlQs7tllcZ5+//bFTlZ0EpIoeM0
         51sksQxfT/uDAkW6y+mexU6ql9B7mpD5hq+/1cC1+SkSsbNbxAUGsE9DfAHbzLmq+EBw
         6kdg==
X-Gm-Message-State: AOJu0YwICqud3j3Rc0Kpky/CPxf/zvYP4GCfTXjO5JhjkKWIC6Bw1C0C
	ju1G4rDP4VVPFtqj4CrMTjseZ3oxLg2MzpTwcXsq0iDNIS+4qpShnnXXgUiDaAtrKoABCmPwbu9
	cJcdTQibD4OgADZL0ECVjthE+gK3E+vM4+jMj8xhiKz69fPZKi25HNEu5e1XKdVlTSfaU1MC59U
	KZ5KTATaogH6SS6xCclPTZluzY5xEUC7n7EcmQTCQgdw==
X-Received: from dybb24.prod.google.com ([2002:a05:693c:6098:b0:2c0:ccba:438b])
 (user=bingjiao job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:7300:7316:b0:2be:3cd:62bc with SMTP id 5a478bee46e88-2c0e4f9f0f1mr601175eec.13.1773788841723;
 Tue, 17 Mar 2026 16:07:21 -0700 (PDT)
Date: Tue, 17 Mar 2026 23:06:59 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.851.ga537e3e6e9-goog
Message-ID: <20260317230720.990329-1-bingjiao@google.com>
Subject: [PATCH 0/3] mm/memcontrol: control demotion in memcg reclaim
From: Bing Jiao <bingjiao@google.com>
To: linux-mm@kvack.org
Cc: Bing Jiao <bingjiao@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: gq4xz77mzyr136hm4tabomoqrxn1ohhc
X-Rspamd-Queue-Id: 825DC4000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773788843-545817
X-HE-Meta: U2FsdGVkX1+UtGrCn+FXANgoZqf9J4dLsmiGqt3leqwsaA9FMu6coR0ulv4uFOqXR4E0fT/ZryKNyrBebDy3vLeJa17Adssb7eRn0ngs0GFadsb/2hAZST2bomXOh/xvJmGJm7uyY8VN/Xe1nPzzAmC+QynuFXXMpxIrr898CcyCePWZ40GzmVGPNnTklWf6ixwLxGmwZVpd64/WEXn05jfTTniqpUSqg1QGCrWIRN5euCahbE/RS48/6sErpSMcP+AGpdFQ8W4LuKX+ByfVL4znrrZNLlqc1eSrxTIWsQ5h/dKkrBiYqjGGz3SmvWUEy5uuYZDE74l9cN2/0njVKfU9a/GuOwmeBbpNCU6AVL+pQbAi2+0hWORuoy7M26rmjejHjXaqiGF4zU1J+OJuwJgiJ/HFNlcYg8bKa7XqQe8baHKjdMtgeKiPlh5xdj/SFGEPMKHr50sHiFcz7WpStddrTWJaPWxpPH6aCPdSMvbdnrQMj+pGWEaPLenUI9cyZt4DiEYP0jIv/U5CKzhG5TaINni0klZrGkF8NUvFh5vcAr1VbuuRoit23cpznzGrLvftOi5fD7VLwhMTJiknKPkzv/FQTITOdWD5cZNaQT/JLWILU2qzoLX+S8fC8JsxfAIra4Wo9voGYSjtsBI3yaPspJtRfBGkCncjz0XMmn+b98f5pnJ4LyAdylpKbyQQfSfE70GPkh73M9P1taiR84j8Y5Mum2VOHOJpDisIozGv1LsGBtg61QAjAend3fdFPI6Vf9F5b4TbPCb1aJ/JG7qNplFNqmM5Xif6txinLsO2BkWrQy73m1CtQzZbTTjQ/jBaKKJFoBAU5I+ksazeOAhxcLiAeNm0X16cFDyGk5c5b9nL8PGzOPwRmFzCepR6dScj+tx8dhqOCw6B3ik0QnSoHciNxtLA+kLgfvYiArA+Qc0e2+EqtRh53T8ftCrT2ZGR55DApz+JfFBVxK8
 yN3QCKS0
 FgENb1sUzU7K5qh8Zd9MJXfxPieKxnVRjA8ZgdaZsewt4w56QNLBcH1kTg0NXNWIPHzhjExMaHOyPDofdYzZhHnNCz/ROPaM5lKxlCQ7VXOlHOsHGXCtONwNlUfzeyEp780SEgVYHpAP5mu1gbQh4bp/vNzVifSRWNhb13TCp1oL1VsAkjeymUUSDRLXEiTaiZV3DudH1NQeWzn9xjIbL3/V7XPRhuHiqgjY/ZDmFl4rEsEMHcNpXd7M2NYHt1SvKpWhLtfF70PsSWpSn5EV36a8Iw5aOfceQTxfzmeZ4l2sa5bNbTIuhiAk0ZS8KH+PZLahYRlQOy2EAxKdgY07TTitQg/b7sTHRToBR3TPuRE6v/RxCwmnNaHB67UqzAVRjfA6ERoIEP1ri1Ir1jexOh5gv2e6+NvoaikyDRiNPVUE2wqusM75E4U9xb5WvBZdB71wJrHreiPsIGna6IrafAfWVhrwiatNKnmiQUJYGdWRmKivbxLeiBAF29WYtUWNy15WqJKDCs48uxNBWwC54jzrQyYBEA4CjlHKilRJgextNmtfkWeymkua/2GPuBbOkgPT78DW/2dk9I0IPg9ALf4CsDUK9geerhqnMAqBYcBfWnpqVJE+eej6jv1tq3SOuEjM2JqRRRVOPEZIHMvUL6kcmrTgj6Q6/y9dOGGRcZv6hPOwnOnGktoJwulO3CFaEa6tQK/4QZqPAqphacRVb5KsRhsIDsTumDO++
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In tiered-memory systems, NUMA demotion counts towards reclaim targets
in shrink_folio_list(), but it does not reduce the total memory usage of
a memcg.

In memcg direct reclaim paths (charge-triggered or manual limit writes),
this leads to "fake progress" where the reclaim loop concludes it has
satisfied the memory request without actually reducing the cgroup's charge.
This results in inefficient reclaim loops, CPU waste, moving all pages
to far-tier nodes, and potentially premature OOM kills, and potentially
premature OOM kills when the cgroup is under memory pressure but demotion
is still possible.

This series fixes this issue by disabling demotion in memcg-specific
direct reclaim paths and provides user control for proactive reclaim.

Patch 1: Fixes a state leak in try_charge_memcg() where reclaim_options
were modified and carried over to retries improperly.

Patch 2: Introduces MEMCG_RECLAIM_NO_DEMOTION and disables demotion in
memcg direct reclaim paths.

Patch 3: Adds a 'demote=' option to the proactive reclaim interface
(memory.reclaim), allowing users to explicitly enable demotion if
desired, while defaulting it to disabled for consistency.

Bing Jiao (3):
  mm/memcontrol: fix reclaim_options leak in try_charge_memcg()
  mm/memcontrol: disable demotion in memcg direct reclaim
  mm/vmscan: add demote= option to proactive reclaim

 include/linux/swap.h |  1 +
 mm/memcontrol-v1.c   | 10 ++++++++--
 mm/memcontrol.c      | 17 ++++++++++++-----
 mm/vmscan.c          | 11 +++++++++++
 4 files changed, 32 insertions(+), 7 deletions(-)

--
2.53.0.851.ga537e3e6e9-goog

