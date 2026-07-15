Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E88DCC44501
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 13:39:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EDABD6B00D6; Wed, 15 Jul 2026 09:39:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8B0D6B00D7; Wed, 15 Jul 2026 09:39:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7CAC6B00D8; Wed, 15 Jul 2026 09:39:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AD20C6B00D6
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 09:39:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 48C7716013A
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:10:40 +0000 (UTC)
X-FDA: 84990743040.02.A3A80CE
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf07.hostedemail.com (Postfix) with ESMTP id 92DA94000C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 11:10:38 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HuWr4ZOo;
	spf=pass (imf07.hostedemail.com: domain of 3DGlXaggKCJU8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3DGlXaggKCJU8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784113838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z7jfYCvKZRG50MPG0jJuxwEVxoiBrjqYJeMDmdl5htM=;
	b=zP8supGEc08W9auIIp0EGtJt+UpcNDh8l+oVLndZ3Bvezmq/5TscekDwsDHD8c75NRKsBv
	XQ4WV2/FiG+VMpqB+VZgVlCi+YYzg+VALYLM64rwgAwzjmmTHwPwtdRSbvMBzIGtZ6r+Zn
	DV4NZbfFKVf07qHWyFOWrFvbNrPoceo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HuWr4ZOo;
	spf=pass (imf07.hostedemail.com: domain of 3DGlXaggKCJU8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3DGlXaggKCJU8z19BzC05DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784113838;
	b=AAjxTcSzcxlG6vcF0k+V/Rh7BgmRgVFkDjMOQGLY2zPd8DA6JXoF9+x3uoHnDj8QSlN7If
	kmse4zfRCPwFO9kZke19jjgIHgdn+hm4xUne16t2nNMR5btZ+WXDR/uJgQZpeNtCyX41Dv
	8p8BZgUD9VK+lYkaPgxJC524vF+Ixr0=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-698ac7678f1so5237258a12.3
        for <linux-mm@kvack.org>; Wed, 15 Jul 2026 04:10:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784113837; x=1784718637; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7jfYCvKZRG50MPG0jJuxwEVxoiBrjqYJeMDmdl5htM=;
        b=HuWr4ZOoYNj9pY/v9jGUtRhAQDJ5cHeP+LR1h4ZSz8zgXxlC3BpmabGulVAamwsPoA
         oy0dIli8sS1LeeWTqnTluTX8v8G7ojCNs5CTtoBnu0Pq7fUFUVIAOgnBPNYGHPjl3+oI
         A+QNMG40fMVCW16eawy9QzffA+e7SCsOJJKd9zrhXYYxZ1YxRSqefUVZrytExKsyacCB
         K4jcsv41aJH6d2cxR7zQv4o9e7DiolbE6A0QUMWgdxnLkpBDHA9r00Q7q250fkM6NGl1
         epNU0HHeM/4uT6TRtnIN44zMmb+BE/auYw8dlu6q238d67HSPJKX/52VyNVjeGQOFXSr
         Hr9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784113837; x=1784718637;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z7jfYCvKZRG50MPG0jJuxwEVxoiBrjqYJeMDmdl5htM=;
        b=IT50H+J0mt1AFnKOWjBnsOCbUJQVWAgb7V5WO9Dtzghv9Kn8MBgHzn7e8ZbxMEmj/V
         5qhDXbr+HbAzZNOmFMPyidP4scMDOHT/AhT05+TPnsD4dB2rL5JMdPJr2f2pQJPN7cNv
         PcS50DdRB0VG8Gbvb4vIuv0CbIWgiSkHNr/mCuOP2caeE/G9Ggs784CnRKo1Wq8dp5/5
         b5fuLjEc5BqKKCgWwlaKY44eUjl7yKaRZJG7BR6QU8IStxgbOfdUA1v5ji/SFT+fik6z
         bePAOMPftrLXsUhE6/nJgvunnhCEgvHKsgpObCmRkZ84BsMn0zQMv1TAR1ycjJ4LPkFg
         HjAQ==
X-Gm-Message-State: AOJu0Yx42CyS8G6lUBVwlPFi5nFYP07Dge9vB7RfBHKGEetz8+jHpuLi
	wkphmzRq8kOzj6kwEUJ6xbIQV7DN4sUbvlcyvOy0ytQE2xa/tBiVRjxC24B7b5bwTu3BxRGIvjk
	Ug4KBq1w8P1Y33Q==
X-Received: from wruj11.prod.google.com ([2002:a5d:618b:0:b0:46d:8498:a146])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:6989:b0:494:6baa:ccef with SMTP id 5b1f17b1804b1-4953c1555a0mr25987965e9.11.1784113420581;
 Wed, 15 Jul 2026 04:03:40 -0700 (PDT)
Date: Wed, 15 Jul 2026 11:03:20 +0000
In-Reply-To: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
Mime-Version: 1.0
References: <20260715-spin-trylock-followup-v3-0-fc4d246f705d@google.com>
X-Mailer: b4 0.15.2
Message-ID: <20260715-spin-trylock-followup-v3-3-fc4d246f705d@google.com>
Subject: [PATCH v3 3/4] mm/page_alloc: fixup alloc_pages_nolock_noprof() comment
From: Brendan Jackman <jackmanb@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Waiman Long <longman@redhat.com>, 
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>, 
	"=?utf-8?q?Michal_Koutn=C3=BD?=" <mkoutny@suse.com>, David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	linux-rt-devel@lists.linux.dev, sashiko-bot@kernel.org
Content-Type: text/plain; charset="utf-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 92DA94000C
X-Stat-Signature: kpuhcnrigsrd5ydjbhdtjnsgnahdj474
X-HE-Tag: 1784113838-686331
X-HE-Meta: U2FsdGVkX19l0y6jQGvP9CWm+7Od4LMpK4HxEyBb3NJX4jPiKtipckC0hDdcOKEnf4uG7bgJrn74QDFKu5xC6WjQsKlHYu/vtF6EikWucsRKTcmvS9BLxKL8pUNL6/ep1Q2f3RWjDezCm8H9s9yxumd5E0Di9UHJyDTKQ92J8Lw0Yn+wLzPamW/MauuVD1llrre2gmcjhfE9MT9nClzzHohdrG8VUiE3yoNlyxaasXa39ANfYGqiSkHJT+S/shDuesHxOtbsqLAr4xeGDsfJNkDOFdcbGg9xDdq1IgJTlJQlfcwLsl4F6FcFSgcEGM2M0lYlMwRiESbLToXghahm1ePWlVaT61OQhSFN0O/aZJBUfPmFQnjxrqd0rNmN9kV+UIhWvUaaC15ndEOHbJ9WejKvp3qoFffZqMMm5mTx1DG/c6lZufzeycD076oAVwJfMSGIZqDQADHOjVE3rQcapgSaKa8Acx+wH7sIoByCD3E+J26VpZ0plOqS2a/yI5xC+7O8BvHup5oMqFWCfNDk5QU4oQn8l6IUr9hSPBdJbmAiwBh+V6ZaM1CttQa7hPJTKlRIL9yELr1ti/qajUzduMnYPIRCHt0zVLXtAOGf4GhXjWR4I4tv/8WTodXrgcaI5F0jhFGSdOKzhOOjc5wQYmakeJFTjpDpKDKohCtERWmXk28Ki3q7pG+xWx6ogT+SJzXGOU7L1P35D4brdQUlOJwWOpz4V2FPzYkDVeep8RcfnQKj9CJGDfV2T0rbr2PFXtGOThgh6WWng1Y4rHMMbn9BlZT9syc2sy2LlJUmkyqCg3RiUmSKooSr21cZDRQa5jZ3c1LHrSQgS90IORCIFXYwEWnZaCpiP1mDFoLFaRKuJFYTY1/rQevsYIv7lrdDZkax83BU8VIgt91OO4TwapJj4uzjm/HF7Up4XY7Izd5KWD7XAqtHBzqAqutkMNCIttBdAGSUsbzwlaNDJN9
 5qSFervZ
 hqGD5CdkaI24h1dGD1AbxMJ1u1kAAEcihGzMOVv1J0JjtSIznSUhGN6OwgKvnYrcCXdgALI35Pj4kvSVcRsUH6+X8tDtDCaDcdPP6no72UL0dAT5CIrBG6IotVA4u0Kf2+CVGH8ZMs93KlZ2Gvf5Wy3Nw+9oYJCWHzw+ZtKrARGUfFcE49GGmIOCFnAT9L6ldUNkLcsX2JGfrztBKGefoHsH1ZIj+lhsmngs2/BAcOsOkW8nTHTKx5UBi98VL9A48zWR4EODaYBtJ/Xo0WqtzszuZItvHuvCvtN6mn8w/rz87Y8m7RiNrYzvR6rA8zSAya3X2oNK5AsvddpQLVYweeQ/X3AXle1LIHCSO0JdaKshrqHI7n5k9Y3rNtYn41c0YO99G3tTDsQYVyw1DhEB/mTNB80HRNJ6zwWO8eFt32yN6adaXwR1+7YkcJ0UnpsoWKqCaGmBRWS+YvfvXD7zgodgpY7YfManP40GKr+622pYTguuXKMBLckPBPT0g65cTJW/YCRkbsaY1GCbToQxBz8xzEVNvNckK0rQhLxZ1VJBfVlq6zaFx/fWI2cHZt8gg3+cEwTgHwK+ICn1XMJ3kqhDx+5pTeij/C4ZI9jJ0ETj2MmPqnrHsUdeYSPpXSNE1BtKF9VLrkjrSATbdJHJYzzA4gtAqiKVi9Z8ZIDbDW+DoSHgThn3/ufdIB6cg3jk4E3Ejv1LTAPxRWceFLAFIAcbff0n50t7pZISuPQXxnnZIZGxVv0pW7r1KLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update the comment to reflect the recent change to allow flags in
gfp_nolock.

Reported-by: sashiko-bot@kernel.org
Link: https://sashiko.dev/#/patchset/20260703-alloc-trylock-v5-0-c87b714e19d3%40google.com?part=6
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 mm/page_alloc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c2da85e69a0f8..25a83a57aab66 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7983,7 +7983,8 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
 }
 /**
  * alloc_pages_nolock - opportunistic reentrant allocation from any context
- * @gfp_flags: GFP flags. Only __GFP_ACCOUNT allowed.
+ * @gfp_flags: GFP flags. Only __GFP_ACCOUNT, plus some flags that get set
+ *             internally regardless (see %gfp_nolock) are allowed.
  * @nid: node to allocate from
  * @order: allocation order size
  *

-- 
2.54.0


