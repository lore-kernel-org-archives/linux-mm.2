Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0FF6C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 11:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A5E66B0005; Mon, 29 Jun 2026 07:20:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4572A6B0088; Mon, 29 Jun 2026 07:20:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36CAD6B008A; Mon, 29 Jun 2026 07:20:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0510F6B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 07:20:50 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 759F312062C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:20:50 +0000 (UTC)
X-FDA: 84932707860.02.A4A6CD2
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id C633220009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:20:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G2YehPKt;
	spf=pass (imf13.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782732048;
	b=bcn7+8YfmaTIWGY1u53MyFiy4I5jFjHl2NpKKVZ+N23cWLr4a8IRCcp+KjKpPD8aOYvhwb
	OOKarPj6A9iwdRQJzXPuL0muJ7lyHX68Cda+Iv8zP3uzBawkfSg86Y8w/BaM250jeeX692
	L3+MdB9PCG7FB07PkTixGSdENFAiuh8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782732048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2wcplDrEZi5L3i6fVdKYZ7PB0BhNDAnbo6eoR1bcDwQ=;
	b=cJlcIdRonIDNZR1BkCHy0v+zjuPE71dNh+Qdy8QHERNS5+tni9pyeylgsJXakeP/mCRF6S
	YY/VQgGcazEc3bxJajuyG+TYHd0CVHkKaZEdietbPjZaC33mserzBJW3g+80SJ5VPz7tIm
	jaqkUAWMiLUtTjr271ynp+UY5MvFrOk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=G2YehPKt;
	spf=pass (imf13.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c9f10fa7a3so9970105ad.0
        for <linux-mm@kvack.org>; Mon, 29 Jun 2026 04:20:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782732048; x=1783336848; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2wcplDrEZi5L3i6fVdKYZ7PB0BhNDAnbo6eoR1bcDwQ=;
        b=G2YehPKtPkmecK1b2ZT2dZAsF/tMwOTU/qBS6rLN7yyQnZOwxTyGqup3y/9bKbZKbs
         r8jgYWWEuCzqX9h1JKcN0XFRsuWXFjTGnCwnytfRpHP2Y/aFENKc5TASKmki0jP72l1M
         VI/R4fYN6u0/OdJxPnxtwSj8Qqvuw+rIuJwnoGsKAPYM3C85DdNoo8p9FaLXaHwf0/a5
         Cs5rzbtuFx7VfTxVKkpbzf5tJg4aVlCfi2HTrcoPDAmCzEXuRmpoSYbNQgLGsCjq+rtD
         nBW5frCLAdixil8E8QhFjAfkUrVr37Unsi1nUjoVhUemXTWJ6L+2Kuf6jUqSoK0rYrHY
         H9NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782732048; x=1783336848;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2wcplDrEZi5L3i6fVdKYZ7PB0BhNDAnbo6eoR1bcDwQ=;
        b=Ed26x6Esiy+bdi/s7vwV8fVbr2WBXKfo5H7X4py2l8iwPu7qela2HZfIDU2qShxEU9
         sPSv4bQ8WQc3Ae8YshIjlm8abS0++/zWLVEDjg+1W4P6aa7V2Kv2BH61VxK9ff9HRoGj
         +ZVlZbgMgKcTkBK2+Ca+xca9Lv7hDrzf41bkw5jLAAe/1qH2syodI44bWSWL4lVJRFr0
         NwZokXZVvyhl3nKQDdOk0BgaflcdZxr9/Vjui1EyNURvqCIRCEu7flamGD3c12Uh6A9a
         CmNM08Ei2LsjPBv+mdjTyAOAmz/PgVWwUmo++u2Po4lIQUkKoyPlj+rjhlZYYrIeMBjT
         eK6g==
X-Gm-Message-State: AOJu0YzRs6tANXX1Hv1wN0/bgSvV8V3ItdeSLTwi0km1fn4uNdIJ2LLg
	55ijxScX1fEtnosycotl4krCG/f39uPCNbk2JQq8LlM34EeYg+ksHyWo
X-Gm-Gg: AfdE7clKXIS4TRnCpuWOmaTqKH2UV3UmQ+Syoicx3cpaPQ48MmdjpB0+seoOSEGhF3Z
	eVsTqLrtCueD2JLIIrKBseQKqSnmUMmB59eN8avDoa0VjZOAmTn40Yd+93KQQdGZIfXBinSOnEx
	tg4PMCHH3sUU7Jw+q9jPhP3Og/Nnc0raLK9YPYoyEM28Xjzv4699ffrET4VuKkDyZDV4OlBWLDv
	oWAk+sZydCrN9BwS0/rRQpeNCmbaVZ9u/YQUiH4irvPYVtB7KL5nQbnKQiPwg7SbNcrmwWAymG3
	+zUAdCVAjE1oAAYIentb2o3gl6DOm2ac2UatZVP20JO86gbu/XBTynIoD2oXqjpnd+Ht6T5SRLv
	oK4a8T3Mw6+ommPcnHyHvC383Dh+6Y0QonmGXUiO3zuksIZNunutXyoeeTk6iaf2PJGHdpw6+70
	fyFVRjuP5p5CSb4NqeHcH5mST0hlRgbimjFVMbaC04
X-Received: by 2002:a17:902:d4c7:b0:2c9:b8e5:5741 with SMTP id d9443c01a7336-2c9b8e557dcmr55818535ad.35.1782732047619;
        Mon, 29 Jun 2026 04:20:47 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c7f63d09f0sm92759085ad.56.2026.06.29.04.20.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 29 Jun 2026 04:20:46 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v5 0/6] mm/zswap: Implement per-cgroup proactive writeback
Date: Mon, 29 Jun 2026 19:20:26 +0800
Message-Id: <20260629112032.20423-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C633220009
X-Stat-Signature: nw7txk5wyosxgpn7gqt7ti77frmhezk4
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782732048-594062
X-HE-Meta: U2FsdGVkX1/2mJoumj5DLvB+9CEYffCQUHRB4kvuVZDW6Int7808Ij6QaltnURgnI0pZSCuyIi2HSJ9/74ICfXGJ+j1xXKNhrb/uHdAO7sf3popZ646MoNtZalffR7s/zJ+XqeWsaTwjOr2YVLECL2jU51vqAPlp4qW4hnKjnz6VUVxVPCnQ85EOXY6sQDu3YTyIlU6eyP2vkEnoH541ku7mFrck+AHGD4yqssKHjPbjSe0fygEc0gWFDMXUaAqlJgR3p1MMFPslVUcpLY3Ct9OWgA+Vp+nmLkswiK+IrnAW+clpRY0/yvu1WlnopR1wGEVbkDVANoQ94+TiEaQbN5TRglChN5EHUr+M0jLY5eevzfP2XIQqgnVRzlRHCA/XwfOkl88MHwqMbc8garG31MpNKaKl4r/RlaLshzPFKshp/UEcHB5iOU4n75+EIJYMDy4fY6zHbDHoeg/HQyVYAsaED6VQvHf3UMjoP3KLegO/x+o7zGyZJRG/GP+lIxFN4MrNZ18Vbm9kzKocecZDcUaonvw3696bzjK0te3a8eR8ApceN62zN9KqSUo7gvBev84ERtuC9972jTry9HIb16ajpUBlSwwggSBJyT+NNoLucIHXJ8Yhpofs7eUR4DSe8q5yzmXPN0lcwvA0O4VxxvzeUtcdK5+rHSmQhmHLbyod4QCrGqRQhlVdjtrVZEOJZPq2IHtkgPZP4IaIw5mSm+rC6t2T8u1QVUhDM2japMaX9vjTdDQvOINVz2wPe/Q7zUV6A6+50qPfcU3HXoq/BSAhOU1UqrGx07dJd6kwir+RLsSqp+9Gz/6FVLBRwslE7IzQH+rd2oatgyQ65erDLviKoNIGXfXFm1XTHlAli7x5cgQx8X2xkyW7OeaJJgXhRLY+SjKXivVYxC++SU9+UqSf7aGw9+Ob4OJwM4O5tHdINxo4qkvikbNH8ae1IvfmKmkg/RWjZFStGsvaTSx
 CX03YTdQ
 INcUJ5VvWDihLNy4yFw4Foe2mIwLhkrpu7w2KqCzoTU5qIYHoI4L651Squ+LQ4YdOjNozWQBjW9O6g6iI5MhtWYJhhX5yahSCJdVKf4aV4L58L7L/vMeDRGz4vNhe/IyUEmCiKXDbxBBuQAGC3IbNgevNxiVVcvHgj4TMhwlF1kg1f8JEV/8ZAwyrLJiPugO28MXBEhMbLQb7b1E5mh1BMG8eGEasqll9pPdaF5NxDFb3QXcQ/Z36TJnn1mGFaaiy4Mmp9xsrCzlYX264Swtl6dKtbyxDW+WN5d13R3270XgQyiNW7VIPUwvmugPHHv6CSRqs2GljaiR8pwsk4/ANWrtPYnYhISG5Q8G+evB5hsN9Y22H2cuu2LQ/lwxrvQ0mlyFQ3vmd+F3BojFpmYE6E7Ln+Vdxa+Flcj3sBxFFN2boOMvesknwSHc1JMXcx78BM3KQ4EmJPKwouL8VcWhMQAbXU6jSMNSOfev+7BVvmLOaOTYw0orzH/Qwb53tM2irnW4KhAdLotHY2+E47IGV9ckpdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Zswap currently writes back pages to backing swap reactively, triggered
either by the shrinker or by the pool reaching its size limit. Although
proactive memory reclaim can automatically write back a portion of zswap
pages via the shrinker, it cannot explicitly control the amount of
writeback for a specific memory cgroup. Moreover, proactive memory reclaim
may not always be triggered during a steady state.

In certain scenarios, it is desirable to trigger writeback in advance to
free up memory. For example, users may want to prepare for an upcoming
memory-intensive workload by flushing cold memory to the backing storage
when the system is relatively idle.

This patch series introduces a "source=zswap" key to memory.reclaim
cgroup interface, allowing users to proactively write back cold compressed
data from zswap to the backing swap device. When specified, this key
bypasses standard memory reclaim and exclusively performs proactive zswap
writeback up to the requested budget. If omitted, the default reclaim
behavior remains unchanged.

Example usage:
  # Write back 10MB of compressed data from zswap to the backing swap
  echo "10M source=zswap" > memory.reclaim

Patch 1: Fix missing global shrinker when memory cgroup is disabled.
Patch 2: Extend shrink_memcg() to support batch writeback and update its
  return value semantics, thereby improving the writeback efficiency in
  the shrink_worker() path.
Patch 3: Extract a reusable writeback helper zswap_shrink_one_memcg() from
  shrink_worker().
Patch 4: Extend the memory.reclaim cgroup v2 interface with a new
  "source=zswap" key, allowing users to trigger proactive zswap
  writeback up to a requested budget.
Patch 5: Add the zswpwb_proactive_b stat to track the compressed bytes
  of proactive writeback for better monitoring and tuning.
Patch 6: Add tests for zswap proactive writeback.

v4->v5:
  - Add a new patch to fix missing global shrinker when memory cgroup is disabled.
  - Simplify batch writeback logic in shrink_memcg() and improve comments.
  - Refactor the writeback retry helper out of shrink_worker().
  - Replace the "zswap_writeback_only" memory.reclaim key with a more
    extensible "source=zswap" key, leaving room for selecting other
    reclaim sources in the future.

v3->v4:
  - Drop the per-memcg cursor and keep the root cgroup cursor
    (zswap_next_shrink) logic intact.
  - Stick to using the zswap_writeback_only key, and change the proactive
    writeback size to use the compressed size.
  - Consolidate and reuse the logic between shrink_worker() and
    shrink_memcg(). Enable batch writeback in the shrink_worker() path,
    while maintaining a low writeback budget in the zswap_store() path.

v2->v3:
    - Align the return value of zswap_proactive_writeback() with
      memory.reclaim and update the corresponding documentation accordingly.
    - Resolve conflicts in test_zswap.c on the mm-unstable branch.
    - Enhance the zswap proactive writeback selftests to guard against potential
      future regressions.

v1->v2:
    - As suggested by Yosry and Nhat, extend the memory.reclaim cgroup v2
      interface with a "zswap_writeback_only" key instead of adding a new
      dedicated cgroup interface.
    - Update the zswap documentation and add selftests for proactive writeback.

[v4] https://lore.kernel.org/all/20260618044857.69439-1-jiahao.kernel@gmail.com
[v3] https://lore.kernel.org/all/20260526114601.67041-1-jiahao.kernel@gmail.com
[v2] https://lore.kernel.org/all/20260525122242.36127-1-jiahao.kernel@gmail.com
[v1] https://lore.kernel.org/all/20260511105149.75584-1-jiahao.kernel@gmail.com

Hao Jia (6):
  mm/zswap: Fix global shrinker when memory cgroup is disabled
  mm/zswap: Support batch writeback in shrink_memcg()
  mm/zswap: Extract a reusable writeback helper from shrink_worker()
  mm/zswap: Implement proactive writeback
  mm/zswap: Add per-memcg stat for proactive writeback
  selftests/cgroup: Add tests for zswap proactive writeback

 Documentation/admin-guide/cgroup-v2.rst     |  22 +-
 Documentation/admin-guide/mm/zswap.rst      |  11 +-
 include/linux/memcontrol.h                  |   1 +
 include/linux/zswap.h                       |   7 +
 mm/memcontrol.c                             |   3 +
 mm/vmscan.c                                 |  24 +-
 mm/zswap.c                                  | 239 +++++++++++++++-----
 tools/testing/selftests/cgroup/test_zswap.c | 161 ++++++++++++-
 8 files changed, 410 insertions(+), 58 deletions(-)

-- 
2.34.1


