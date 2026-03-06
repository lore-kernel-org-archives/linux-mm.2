Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4070F01808
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 07:59:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735686B0005; Fri,  6 Mar 2026 02:59:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E2FC6B0089; Fri,  6 Mar 2026 02:59:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E1836B008A; Fri,  6 Mar 2026 02:59:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4BD816B0005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 02:59:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B35021C480
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:30 +0000 (UTC)
X-FDA: 84514888500.03.3300D15
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf10.hostedemail.com (Postfix) with ESMTP id E7117C0004
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:59:28 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=H6TCQlHN;
	spf=pass (imf10.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772783969;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=T1vgmYqExVu6291C5z/MhQ5jLLEBkwRqt9pjw3b4n94=;
	b=HjK5GW5oPq2vKWER59mdB1eZd1In5E4NlrT7pUfRiSJiddIUimHbcdVe4c4tgzutRc5yNA
	UCGrqwn9CbRTUWtjL9HgCzV1hdJmaKvKnsgaP0noeS7p6BOKTGHjdtHSVxp62c8c4RqqnM
	bjY+E2F8kUYjk1GYp/1aFat5PvuEK9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772783969; a=rsa-sha256;
	cv=none;
	b=kljWxjcwgIb8JNmMISVDV/9DsqHrq7A4UiYphGSkuujGv+RlBH73dAZ/NNXLcciS7iiNHL
	uaZ0V90n33/TKZrkfvHJwHbUEYWx5+NCLnn2xrnJCSrP1X77Ry4ZkSpawmGzaAhGJlvL/z
	mfSgNq+WJoP0SqMenA0+YF0anp7j14k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=H6TCQlHN;
	spf=pass (imf10.hostedemail.com: domain of haifeng.xu@shopee.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=haifeng.xu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-3597b474cbdso3290575a91.1
        for <linux-mm@kvack.org>; Thu, 05 Mar 2026 23:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1772783968; x=1773388768; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=T1vgmYqExVu6291C5z/MhQ5jLLEBkwRqt9pjw3b4n94=;
        b=H6TCQlHNAaSgowV8/6CFpvPkUP8EB6JD92s6p2k5Vba3t5QnKkzmSSbQW+a4K3dte8
         pd/CZ9L90Sc7hEM1FWUijgfAPkPlApyo3JbnPwhTnkHpUB5SOdcZopToky3laASRKYyu
         P+5Pd7+lbxXm5DhHE1N4h2NT4udv7OZh3QhtpSgonH1Yf9a5kBLFbiqss5NtqCv8My/P
         DK6c+XG7jhd9PrirwnHpn/qQ5mKz6hD9eCWPQQMsTU1/JSzuNa2kcxXuyC3JxkzUUmrB
         W1h0ua0MWT4COJdqzMdu/54kcYJQZ1chU0vpUpel43oYAiGIJBvwlAFMPnqVuQbJfItF
         zPIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772783968; x=1773388768;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1vgmYqExVu6291C5z/MhQ5jLLEBkwRqt9pjw3b4n94=;
        b=iGH75A7NA+iFSmOOuep8mGcqObrZjxBEKQqv3Uk8VPxZs/G4z0yC9u0/+4Zs+cFAuk
         xG0FivoID0AEv3BfmAKiWjRtOZFdLOBCKjytckjG1girrEkcNHLKZld/Rn+GwG3QFS3f
         D4NB3CimUAQuwkVUC1RymjT7YSs7wnuPrgqfYHLpyyKF4UyPhb90CalWfp3kWKXX2V4p
         Fi0qWhjt52g6+rgowdpWQ5HXHwowjeEYfIKRDOHGqlwbkzguMIgPNAmRFb33iJI/5QBj
         rqft+6UJJZ7v+XDxGikBOEsr6xF6hguYGDh/Dw5Xub/Nz71Qjci762e825IydrUf/vXt
         jXVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXAp/fuT99C17n1dZqTao+PdE7c5nDfK60CQ1D4ZftiyVgEJC1XGMcehxPGsOP3Qdf+hU2BguJufA==@kvack.org
X-Gm-Message-State: AOJu0YzdJwfrITGHlhJj/qtH8Bh6v9MczwLAPm4kxI9Jpyz4RLcJc55/
	zT+9tRhi2N1vg7ACZPnFZ2HHDz8a/XfbHVwmW+8QPcv2PZuzvo5/8EYOPI/kX69nQcw=
X-Gm-Gg: ATEYQzx6Dj40a0Wcy3W4bPsRqWnbrSDxDyyCokteUMctYbUns/O5V8434kL5DNSY61H
	uEXdZZIVCVbcYSTn80HP7QjBRQmWDDn77od/FqPBzWAwEMWMOI2zDaSKyYvMEV8pXEVW95KA2OU
	td5aZT5aN4qHvlgmMBsYbTuhT3sAar9xhF2xUKy+IHff08DILNRtJCCO1q0lt3S/V/W5GSx/ZmE
	H/2kogHOj1PHvr/E1o1cvEgxRdRoIY0KPLvRvi+ufkHxIDdTuRi5btyU2xxPFcJhNbg9z40oooK
	nGqsZ4F1qvgyvirz9jLv1uiZQja+9Ct8yJdo7UsZVsuBNa/w7Ay5z6Wrmcl9pjSmPNW48PvHc7W
	eaSndJbh4QuBA2O+o0NGWa3Yvy0sOPLbMppMHlSd87jll+ji1lX/oS9OIqB5m9ZTlpUFNqDSWa0
	nyybf1yZJZrjnJPP8yhRo8nodDiXSzdCEBrJgM0Q==
X-Received: by 2002:a17:90b:2b4e:b0:359:95c2:b3e with SMTP id 98e67ed59e1d1-359be390472mr1164522a91.30.1772783967678;
        Thu, 05 Mar 2026 23:59:27 -0800 (PST)
Received: from localhost.localdomain ([147.136.157.2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359bbaa0d83sm804787a91.0.2026.03.05.23.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2026 23:59:27 -0800 (PST)
From: Haifeng Xu <haifeng.xu@shopee.com>
To: akpm@linux-foundation.org,
	david@fromorbit.com,
	roman.gushchin@linux.dev
Cc: zhengqi.arch@bytedance.com,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Haifeng Xu <haifeng.xu@shopee.com>
Subject: [PATCH 0/3] record non-slab shrinkers for non-root memcgs when kmem is disabled
Date: Fri,  6 Mar 2026 15:57:53 +0800
Message-ID: <20260306075757.198887-1-haifeng.xu@shopee.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E7117C0004
X-Stat-Signature: 6zcro14unhkqrbanj3jm99dz6qtdnkgh
X-HE-Tag: 1772783968-667953
X-HE-Meta: U2FsdGVkX18Q2WA/grr5NQGCllscZriHk56vzH47AP6R2PLNMoZ6qd/lQBGyGfs6xLMFw+aoTNSJhotHQYGsjUryXVmXLh2Qpo9dJ4NRfzCHH9U/q1be5SMq7hQQZzDy5HrBJ5dH+SByVy/BNDKt1VrkVrA2GxV7/fG5sUzoZPMhT5RpQVOU+Hr/VYFzhhcyCd/NzOHJGl3MP3sZI4hgY+/aNb0dZyxqC2PG4E5I/xcUwcBZCZMTlLxhRyLjMwDA8bByM2KB6JFPJyODKHZwDKq+Xhm+P18ElG6/NImg3ErxqnFuKWvwvrq37AU/flGuYrcImc3WrT9zyf46GPzrq1RF3FKFtmyPbga3aZTn9Mr+D83GZvCni72WSatrUs68ALjGVlah/9F/VSn6SBf2/Yh3vgCQ1HsbQAmTdHAzp9ajfQZ1o1SGRjDhqlMneWmGOE27agvfek8kBaFr7oyG0xl+2Rp7eMDLq0FpPVmNyqgOmjWCka1yYepL3mBevxgZtvi6gvL8vF0Qmc1KFYO+a/CqFqub9lQMv55wKYWPG8PzDaH9hS097V5OYbDZ0n9QIK58nd75s3eR5VoRu25VSriwsePdCe0ZiJ6P5bTBLZ+q6keru4CUzQgM1QURuqR70qj0nCmBKlNBKanKVJKIBoPNhab5WYKqjVYf3NjDGk2EJNObgBtahYsSZPIJ24z1Jdew74PMWVe2kipEgcGLBtptPfs0oOSZkbttIlSP41+82e1mKKAUQc9IkhqVjSzSuR8+aROy1Zi0QnhH1iAoQ4NniexyDAiR2FMC1jFaiYAbDbYxjWGasrDMCozOEEfRSYkueqMBdZsVxD9Xfb/V9p2zIdo0xSEm48RMoTmM9jV6gFGzjpCurL2OmJpctZD+KJ4lIireq2YsXQLSjvCTD9vswIFbW6GEF5bUL8oMUaWcXd4YMFra7LmQmHa9ZKpYzC8iZ3U2eX7aUHyaJP2
 m6pA3X+L
 FqYBM1RUOg75cglMVMCEdntwDbs0ZqIROLc+EpSC7q8geRntLE9R43vuCdAzzkfVBs3QawfT7INm5xUy+htM+ASCRDPY48Kg06k6WIsuvTylM8haghibvaosxaBiUzkP7bKmAF+gM8+Tu35QeZojLoKtdskC9Y0zQx730VV/s+/ZiiV4d/G3rfiDLjmxuEPJG4jrfbs9Hm0w+9wuaDEprgoWpOajvRv/V9DrlWEH0LdEWcfzeqDtONXCbvKfw1Ajn4CdcT9sJPjj3rPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When registering new shrinkers, all memcgs need to expand shrinker info
if new allocated id exceeds shrinker_nr_max. But if kmem is disabled,
only non-slab shrinkers is useful in memcg slab shrink. So in this case,
it is enough to allocate non-slab shrinker info for non-root memcg. This
can save a bit of memory and reduce the holding time of shrinker lock.

With this optimization, the finish time of pod creation in our internal
test is reduced from 150 senconds to 69 senconds. We test it based on
stable kernel 6.6.102.

Haifeng Xu (3):
  mm: shrinker: introduce new function get_shrinker_id()
  mm: shrinker: optimize the allocation of shrinker_info when setting
    cgroup_memory_nokmem
  mm: shrinker: remove unnecessary check in shrink_slab_memcg()

 include/linux/shrinker.h |   3 +
 mm/huge_memory.c         |  21 ++++--
 mm/shrinker.c            | 155 +++++++++++++++++++++++++++++++++------
 3 files changed, 150 insertions(+), 29 deletions(-)

-- 
2.43.0


