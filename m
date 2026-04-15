Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 281B4F9D0FB
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 539316B0092; Tue, 14 Apr 2026 21:10:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E9DD6B0093; Tue, 14 Apr 2026 21:10:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D9216B0095; Tue, 14 Apr 2026 21:10:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2BAE06B0092
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:10:41 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 824181402FF
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:10:40 +0000 (UTC)
X-FDA: 84659010240.10.4658D72
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf04.hostedemail.com (Postfix) with ESMTP id CC2424000A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:10:38 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ddFiHdSE;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776215438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:references:dkim-signature;
	bh=9BY0u+9ICUg6YWkwSP8FEux5iqufebTEc1CFNWOpcLM=;
	b=VrEi24HPk9CJ2YlDvRD2rlxOCMqOEXeHt4+18Eb4SpTYZKwLh6NHVkVKuQRy070W4ExTYq
	DaQ4Py+Ew2Ob8kzNsz+Jq5XpZw7hBNyHxX6tFr3QuPrpxGQL41PwcL9ZK/j+rDvLnD7uJm
	OTAolkjSu+fIQsc7Lo7mTIXNICmrKVY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ddFiHdSE;
	spf=pass (imf04.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776215438; a=rsa-sha256;
	cv=none;
	b=egYNvG7gmjGu8vBRctASmC/XZzGwc6UfKwf/+jbTiGyuMfvr972c1SVNaUKdzFOJulEUuc
	cWb4LsMNuSni68/hgT6fKFS+xS5V/U5g7tuEkTAdyKmEEpQ5pTx+UYmBMOpYAorXAC736R
	Bwz0qjqRWGX08fqFP0m1HGXrtuYP+eg=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b97f9587e6eso863523566b.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 18:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776215437; x=1776820237; darn=kvack.org;
        h=message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9BY0u+9ICUg6YWkwSP8FEux5iqufebTEc1CFNWOpcLM=;
        b=ddFiHdSECpTdCP+d5o1vAEBok7Vlt0aVOYOc+1hrEREBfeU6cay9acLmNmoye2HIvV
         sIjq1EXOFAZERMcjBtkGyl6JG/AueE2C6ApEEVS7MQ5OJwI/6lwPxZWhaz4aUre7qfu1
         ge3G+wAF4Q7GkRyRbrNV/RrvNkAOHYZsyKE/c4tq48SU4I52m3fJu6sydA4/DpGS5fft
         PO8sP/ZJ5uNjjz4fu6AtbKaK7uC8LmUwA3cqjzgaIJ4aqcIpkCBONk3+m/0FGYrzEpgX
         6OjcOwS1adVKhC4CEF3WLsl0rT4CZDLsP1LOQQAiQq5oroSYXRpbgQtHWkdDuP0Cdsju
         telA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776215437; x=1776820237;
        h=message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9BY0u+9ICUg6YWkwSP8FEux5iqufebTEc1CFNWOpcLM=;
        b=LjaXtUYsjXqze23MmAGcB3KxG5cuizFqnvSmme6H92JSHzyqxS6IIgJEziDn0EObJM
         toqix2Po4ciFJlGm+xZGr1pgaRFeKyd2tSEnNXZCtrN88YtYXDyTGIZZZKrnXV/c1L6j
         yh4gsqG5u0chkPTpKlYZLFMal1zfWdIss6oI05NLB2cqbRdp9/GY8vgAygvbpunvl4Ss
         pcyaWX8SRxKg/xEMN4gaCIBDJzBOCgVo/chFUOS+HSeyY2mleWeHEVl6nam5AW//BJ/s
         oRKRTa/bDjazHwowKrmeJQY5VdI9VGpg1TMz434SwapDrLRGKm1H9/CzphPriBJsy+U8
         y8Yw==
X-Gm-Message-State: AOJu0YxUkXDUrUNKcSuWlmXvQZhDpbBs7v42P+AvZilH3jDs93XPb0eq
	Me/6mAgoEhtjkWQ9adfyookCsvNFpaJYEQmgYsWg6g27WOPuVHoiWTTk
X-Gm-Gg: AeBDiesg9otMUYWVKIi8ZF8MI8W+uO9/FGX+T764EN2DrPFWOkNkRU52hCOpegLIjEO
	kroMvnJElKcF8rcf6MeXk+nubgsruKt2dICq0uuUfqCJOpLoLdahwnqH0cCi3nOAYwLJZaioGiY
	jHqZz2AVqfg5jUuUK8JB7pdZt9XUtlTUMAxlZFK/yNoYGypP5qMK3mCI409hcJUpW0D13RVOEVS
	tThjnqv6O/0dfNrI88th+/Fi7isd/VbhEIwXtpkrH0MRtb0DGQgaHCcB9BLMRr5kTogQ6qbOjik
	iaKAb7+IpGdIc0gWp/UlbA/dobzw/VOd7Wb/u//VzUK5KxJhYHUbGg8oUzl7ROAKh8iiSFt7xvk
	FsEJ3nBhCEqJBRdmRKVc0ImKSKy4qzXaUBZvQGW93z6hfBAmEoy/Gt7SjdkY9+TwgsGI1cYJV69
	+xduVasg3/JO9Beqfh8IZrqpNBjgEWblp9
X-Received: by 2002:a17:907:3f20:b0:b9e:165:4b2e with SMTP id a640c23a62f3a-b9e01654b85mr425273966b.28.1776215436840;
        Tue, 14 Apr 2026 18:10:36 -0700 (PDT)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba1778c58cbsm3865266b.49.2026.04.14.18.10.34
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 14 Apr 2026 18:10:35 -0700 (PDT)
From: Wei Yang <richard.weiyang@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	riel@surriel.com,
	vbabka@kernel.org,
	harry@kernel.org,
	jannh@google.com,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org
Cc: linux-mm@kvack.org,
	Wei Yang <richard.weiyang@gmail.com>,
	Gavin Guo <gavinguo@igalia.com>
Subject: [PATCH 0/2] mm/huge_memory: optimize migration when huge PMD needs split
Date: Wed, 15 Apr 2026 01:08:37 +0000
Message-Id: <20260415010839.20124-1-richard.weiyang@gmail.com>
X-Mailer: git-send-email 2.11.0
X-Stat-Signature: cgm9jt4k8jr386d7cp4ctbakdt5eepwe
X-Rspamd-Queue-Id: CC2424000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1776215438-130522
X-HE-Meta: U2FsdGVkX1+CthKDxmZxpQyVPsbByKfkhzVLjHu1AZi5JpIiCv+VuzL+n03eI0GVo7Sc36igInAge2A+x2Mcr42hrEqdwciupSyI6RaZcMYNON/u+FtLDvexN4ZrZjSx1r7ogFsbsF397+USe3KJPBZMexgulkpsT7mGj3lr2A5R/5zVoQvydbahOz80u15DBzEWsV2CfkM/DT3NZs0I1hkteFHEuUuG2s/lut0NeZHFTnDeFC051oaieLqfjTBF+0b7khGY5R7vtZkVvWrYcj2SpSMV5lkEsXgjL8ia0Pg++XzEofpz3As/MXdSNzxfKpDIo6dfUEDDb8jd5pZhnI2rj84/Q5ahRBeJdo0TRhOV6ZG8Nxrad4WLNTAkVi+KZagQjHJcErZcBgAE4Q70vTJSEs8kr7TnV2ptGtrk47ltKO84aOaoyvdnh+rmW4w9ZucYUpRp96vxqF1Q9csD3MlYNggMOtPtYKCgx8T/IBI5yBpaE1/tZ7w50c9A9ooYByjwC6bxEJjD+G+d2d1U+qop+XacJEmMtoRukpC/IpkRF8AWsgy0hzUAafTD/YcFDASf2S81+cXOQu8Wnyo0yq/lZxvLr7ZLyOsAebogTI10tq2DUnmJrU/WMQs6Ad5mCE06CS03gjJRy9L3rzrjHEtOgUkQP8SJSBNhEnQ2/4zOSJndSEYVLHxUsHUXzBd99Kte7akGrqICBVMhbdjKyjKxZqpx1gRk9QYJ4BcIJl+nCyINRg1V7mEkfhUjufXUwUT9f+j9HYB1HY1hTN9Hps9CH/T0M6uuN2tMjqPOkgLphVh2BJevhEGFhVUGRzJ7WcTYtBzLkQFNAHPKaIGrI2kBggK38GhHOTuxCfvXtwMqYTrAYsyOtkqzQtGOQU2CgqrOrvkIPFWM8H4TCFf8h7AvARojLV8boimakc504poswxwA6bcZOFt28Xpj5BZfmHC+tGEsKQ3pe3SV5rS
 L+K1mwGP
 1KgwWatmEt83P1SeQEkd1QHuc0p7dO/m7p8asCWhgnPo5h9d2ywWLTYUyCJdlxUnRMSJg/XpmOLgvJuKntzpoeILvV+d03UD4JwX8Do4rV5EQzCc4hhfcXHlnBZpCzXLyNxQR4PMubK8vnkvr9zKgMT9DgI5oKtwwAxbFf1PV1hT0smf3MtVXjUPfvE8YRrKdhzzRIfZtPnAP6lkb04LMXdNmN9UztFu6joPvqUkFuxze1OqnBK5eZOuUcQX0Y4jNo/YkqRZZaHUpqL+vV2FVdFPX9ZbUfcm0sWJExUtPu0UkHgOW+TQq8Ojhx6wPIo2FNcW/tUksSRf5HmEjZzadxNlUpcH2a7GVpFY5xhCntLqJfu+e8JtC/0nyloN6dqAG42z0JG7ZIAV1OabM8lNOIGCREUsb7ZIyXJ0EchgbLMnlyeRCD9YLcL4DRzEChxS31ckIEwnTmsWNjJj0XAhG4CxeDl7yZqVagwq5+HjHLY4vsxcU05gFyfBCKDwcZXEtNx5ra3obL/JAy9gl0YgHMt7GlQVartrEVj33ZazazyLhWXA29cU5OfqfI57vwWlEmiCrvAZd9ToKfVcVbAXpeRoECgcvgZHqJGgMwzdw74JjUI7aHRhOhPSvZQG7qYJkmngN3SoKXQ3xNWG3SqCRNOhbS6EQOCaXE1ynVdF76+uZbBc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is a follow up optimization for commit 939080834fef ("mm/huge_memory: 
fix early failure try_to_migrate() when split huge pmd for shared THP").

When split_huge_pmd_locked() successfully split the PMD entry with @freeze
= true, it means each PTE entry are properly set to migration entry.  And 
we can return from try_to_migrate_one() directly. 

Currently it is done in a sub-optimal way: it always restarts the walk and go
through each PTE entry by page_vma_mapped_walk() which then skip all of them
when the PMD is split to migration entry.  

Let split_huge_pmd_locked() indicate whether it split PMD to migration entry,
so that to optimize migration if huge PMD needs split.

Also add a selftest to check the bug fixed in commit 939080834fef
("mm/huge_memory: fix early failure try_to_migrate() when split huge pmd for
shared THP") will not be introduced.

Cc: Gavin Guo <gavinguo@igalia.com>
Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Lance Yang <lance.yang@linux.dev>

Wei Yang (2):
  mm/huge_memory: return true if split_huge_pmd_locked() split PMD to
    migration entry
  mm/selftests: add split_shared_pmd()

 include/linux/huge_mm.h                       |  9 ++-
 mm/huge_memory.c                              | 21 ++++--
 mm/rmap.c                                     | 11 ++-
 .../selftests/mm/split_huge_page_test.c       | 73 ++++++++++++++++++-
 4 files changed, 99 insertions(+), 15 deletions(-)

-- 
2.34.1


