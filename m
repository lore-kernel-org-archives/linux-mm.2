Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8189DC43458
	for <linux-mm@archiver.kernel.org>; Fri, 26 Jun 2026 18:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6559F6B011F; Fri, 26 Jun 2026 14:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 605866B0120; Fri, 26 Jun 2026 14:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F6866B0121; Fri, 26 Jun 2026 14:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 296556B011F
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 14:22:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7D7C21A0558
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:34 +0000 (UTC)
X-FDA: 84922884228.15.525B441
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7831A1C0011
	for <linux-mm@kvack.org>; Fri, 26 Jun 2026 18:22:32 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ch3HFNkA;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782498152;
	b=KRC3sOcBp1zTerh55v50u2R4uCqx/Xqx19EpoQbyhZGmnlZVErMBMP7RuiFQRYX3prrAm9
	MzWq3CrCBMvWG2z1qmmVx4rB/DZbAId5qD3qJNDZsYEfva2bs+7s9TGd5o7bND1gs6Mz6O
	dmzfj8GN5SSq6bY2/wN/liZ9ikk/QGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782498152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PHIivcOAmzPrQ+dHMiG0qPloG+hsppnhGlUdnRB5nw4=;
	b=lrHg58yQRuBMWkFFdyS0tdN4Qq0qFh2jxlRrVhQLFZvQzsZiJ2y/Gu0ynSiJ1b9Kg3VIDM
	B200vOBoRBBqrXxc/E6OG+jIei0pQqNbxBctwvjFao/z/ZfD2aJ0lsvstMrmT+HA9uJi3e
	gxA21VNykdFdAdEjqxuaGo8XWQK2FAY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=ch3HFNkA;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.222.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-923220bf1d5so122426085a.0
        for <linux-mm@kvack.org>; Fri, 26 Jun 2026 11:22:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1782498151; x=1783102951; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=PHIivcOAmzPrQ+dHMiG0qPloG+hsppnhGlUdnRB5nw4=;
        b=ch3HFNkAmURU5LsTIO9X9RnDGd341Ghu50gV7/VCY+d4lSkiXL5dH7/gSf8FG/49BY
         PmqUxVmK/AeimfdHUQcQp1GIGWbZKVbjM8cl1EM1ZetFbM01NKd+DWE7wwGcSeAQAfPO
         FJWU2H0hp83ZP/tklBJUFaog9PwBvGQBmy80IST+lAx9IblYVCBixZ4yu/LG/VY6cdJX
         Ld0+XbzfxkTUptVbZoKW+8Dohfmu+7q7DHdt/5AtU1H3EUQUVsFoVMCpTDx7xxLWokwy
         9NwxqPiAaIL8YUiWdK5KYY02Ej8oJm4jdoADPwuRhYR/ewbsJ1JVw9PhsttMPImT1nWD
         Opnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782498151; x=1783102951;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PHIivcOAmzPrQ+dHMiG0qPloG+hsppnhGlUdnRB5nw4=;
        b=JEsTalfpskEQWluvCMy+7PRt5bgi1N9aSWRmOcfBHcie0Iwm0rdvShSG4FOLwpPhaR
         CdGcdg68Kezra7CwCN+AsFy83wLpIBgYiUBePcJWv9/JbhCEiYjOxCqnInN37dCQ9+r/
         8dimNHemEMjlnlpnHQdD0iYKfaqK6gTdM103PUvjkoFoIxm3ibRp/UD2iLFcYI8wYkTQ
         K8WJk0C4P6flng5ZxGMtjBBeX8lvJHgoSL4WBTFeCk/JoIPtopDgCT+/26X7wCTuk5cw
         CuISvY7TyXidMhqIJbw6oAP2/iKAp6YrzqczEo1WHlhGMMCYTCw12LkECRys22uvP6Mt
         8OnQ==
X-Forwarded-Encrypted: i=1; AFNElJ+UGW0khH2csUVbb5mtagZoAGsVz//gX2SR8gXZwElAtegIAxVjIHdTVbUfmMlVvUEvEIgb/bflbw==@kvack.org
X-Gm-Message-State: AOJu0Yx3waFpnZz9v4FNo7ukjLXsl8l6rzP5KGhAAnJdcewLYDxBehHk
	hbFOfMrI5sl5LeDDUMKroVeIzC4cb83pfv6dbyGsh456IIr7j60Lw2QJjDKAEO8vZHNHMfKx12L
	svTBS2qE=
X-Gm-Gg: AfdE7cnKKvIYDYXIhlqRApXNjaSofJD+zw41JKNdBKUnTN59egj/gK7U7JunHSHpAFN
	X63DpfTy93JgtOqitVpWTUGl/IuxlKetK0vio1xyl4/H32zYGhEkJZWd13kv3Mh/IKVCvYCzgqL
	+QAfZ5f9CC6C5liKw+iySpwc/THkKF0+Q09wDqAxLmt4hjlUZp1DAwj/o3fgzf211Bho52drlg+
	Vt9idsYu+fNKyGFoiqzgAcvoQDPoO6kI94C4ue+fhXVybMghZeGdjtkxWzqyDaPlJ88EERtnU/B
	Afuu2PWDt1KZPzkIoEBPjhhk9H4Y9f17/jBfMSPufg7dFNGwI4zUodHpV2VUBQmF0sdhGGIQMko
	SbnJ683Rl8+PjVGKk42oaoyXSSd78DljgCMWlJLreQND6a1abNQFVF8DVHNYmqgv80KzUx8imBd
	BHy0KVDebSRb7aG4J/k1SlCA==
X-Received: by 2002:a05:620a:628f:b0:914:7b4f:cf5b with SMTP id af79cd13be357-9293b85ca70mr1189843385a.16.1782498151358;
        Fri, 26 Jun 2026 11:22:31 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-925fd390e76sm1225544785a.3.2026.06.26.11.22.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Jun 2026 11:22:30 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] mm: fix reclaim storms in defrag_mode
Date: Fri, 26 Jun 2026 14:21:16 -0400
Message-ID: <20260626182215.1107966-1-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b4fnm6dmzmephwz6tpkfi3387hp1rqxx
X-Rspamd-Queue-Id: 7831A1C0011
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782498152-284728
X-HE-Meta: U2FsdGVkX1+4yR+rGa591fU1HsiKCd94aqYyEGEkVUwYSz9UJBJrEPSQ/RYzTEq7vDUFh58Z8jgVOaS7nKKxZIDSPmRXzP9qLVOxi8PlivbXEguDryo/1OfAwwyT8iPeNolAZ7E6pi2w+Bdeq60KVqgD6f3RsPZkQKAHPLh8D4/XqjZAuYWkWg8e24udTzzTSZbn2di2ND9yW+yNUJSIEI544S4xoQUzAQYcMtTlxNRAZjP1SBGM3YGuITVGEgEkPt+CU+ymlke7A9NK0v5l/wGed3Jj1zUbzABPlE82f+0UYDFiD95a2N86/iKoWG999celSKMwRSlmIyAGBR5D6nvccT1JPwYi2evcohFVcs5Bd2zfCzcAkp7B9T81Gslh1Sn97i18oVOkStEb6se/2L0JxJsBU0tclGst1BBFBjGd14JIhTRuHj1U4KXxiQcJHPY8nUJIb0Y3TZuutJ4I/UmO0+WWeM333uK7QhpXTKZV43zvtEmo9566tiTbBErcm6cBWNsWY60yKWKvmJ2Wc7hUCJ/fQAGsaFQvudaPRfwzTOVjherLgpJ9hjCoP5tqqyTVEHPRZUW0Nsr37U3vKCAesCMHN3gVKQku1Ha5w7uWAiH7lvFUDOrrcrv9BWlIp2MDz+b71sIMrMvzyyR/6bWVMnFumwH0kb6mUFW7ZBsEB0juA6bpf3AKEAIEY+vSpjs6uOTeXo87ITFvsJbB/iY8yjeaCr/Ty4Cs02UFuTV/o5T/37kwqjPuF8pQRqLbIifsXj5BrIKoTN15kST55rC2vRa1Lpw6mp++B8kXzmvml7bzi1FFRracHTTs0SbFCx/SqEchp8Tfu5VXD6a4MQ+qC+1G9Tnk56LlBW3470mJ7NXihXsY6sEbwCyNUCcfs1cAsJd7bYuOSdc52HObikEINzAGxGCAYNCzEGt4RqkC2tQQyydeK8xltCIIfw0APBGkV6wivEHdj+fFH9+
 hIJOJQJ/
 P3Gu9odTxBGTGRmnradHj2+7MhMsmde94ybCiUaKUDBaPspmPvtkTbOvqxMqPZZeJsQ4Amn3BwEVuOoymObJ5g/MIUofcd70zgylSmChWfkIV4GzUR0bR51gLcwXpuDGF4v5u/QjB14rlNq88azhYJwEVp6BMvQOS9tm/nKylBEdCEmMhLgOCkw//GtMG7FYv2RcSpFGvl9gUn/PtaunyGYY8Uum0iGhguzpYIIoXbPcZxZ5x9dwDdUuxuY5usRQhw29SJB7pX6r23ihP6MWvQapYTUniVri+WbwPVK9oyG7xCzzL7+/cz6udwJcv0ofzI+TEGCfPqPnVSE3c24gHGY34LoOqU6saACkPwrJNgkyS2vAO3WxHsKteiquJ4hOHst+eF+yZ7b5IK8LoFbLrykN7/1i3yITozGQK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As we deployed vm.defrag_mode=1 into Meta production, some workloads
regressed with recurring pressure spikes and swap storms (which in turn
triggered userspace OOM rules on pressure and swap utilization levels).

Tracing pinned this to non-movable requests spinning and reclaiming
unproductively when kswapd/kcompactd are overwhelmed. Direct reclaim
predominantly frees up pages in movable blocks, but those requests
cannot use that space under defrag_mode rules; and it is unlikely to
free up whole blocks incidentally for __rmqueue_claim() to work.

This series fixes it by making non-movable requests participate in
pageblock production in the allocator slowpath.

That requires some small-ish adjustments up front in the allocator and
the compaction code: three prep patches and the fix last.

The series has been in production against one of the affected workloads
for two weeks and restores the OOM kill rate to !defrag_mode baseline.

Based on mm-new (2026-06-22).

 include/linux/compaction.h |  3 +-
 mm/compaction.c            | 68 ++++++++++++++++++++++++--------------------
 mm/internal.h              |  7 +++++
 mm/page_alloc.c            | 59 ++++++++++++++++++++++++++++++------
 4 files changed, 98 insertions(+), 39 deletions(-)


