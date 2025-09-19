Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1636BCAC592
	for <linux-mm@archiver.kernel.org>; Fri, 19 Sep 2025 19:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FF468E0007; Fri, 19 Sep 2025 15:52:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B0088E0001; Fri, 19 Sep 2025 15:52:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DC128E0007; Fri, 19 Sep 2025 15:52:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 557F88E0001
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 15:52:30 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 20910160800
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:30 +0000 (UTC)
X-FDA: 83907046860.08.B8C68FF
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com [209.85.219.176])
	by imf30.hostedemail.com (Postfix) with ESMTP id E32EC80013
	for <linux-mm@kvack.org>; Fri, 19 Sep 2025 19:52:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCk7Lhvt;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758311547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MRPftj4LaqpBRfvv5a/Vndy5zTyggHCJw7J9EdAecUc=;
	b=VdwMHCvyXfsbaspqYrzatBl7kZqcccoKGqZ7aSeh63pTVK+FJfeHdQp36s6AQ0OWCS8C/A
	XD/nAZxxA7K3x5NsmpvQRCp03lFGh0xxY6kUoCJOW3vrQoPEXIkHULlmeuJ9cNl5NTRGoT
	K0hQzYsaFScSzY446nfP7LO1gYkmqEU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758311547; a=rsa-sha256;
	cv=none;
	b=FWy+1QXPlP1Co3WUVO5YTTRPxLXCGRH3a3RwVUe93vDB5hxxnAZCYpB7AF2BCjAuqZJqgV
	ANyGMN5ta4dm8kkpVfJkd/cbEVbw7QEBobR8jCyCgB/P5FjqBhhQhBuL+wLZxbNRJd+sPA
	059tjz3dIHRahab/LTItXYSi3Hqqols=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YCk7Lhvt;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.219.176 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yb1-f176.google.com with SMTP id 3f1490d57ef6-ea5d856ac28so1725141276.1
        for <linux-mm@kvack.org>; Fri, 19 Sep 2025 12:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758311547; x=1758916347; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MRPftj4LaqpBRfvv5a/Vndy5zTyggHCJw7J9EdAecUc=;
        b=YCk7LhvtVh8U1Q2UYFT4MsgvyeGv1yhfibEGDSOwG/zlJ4LHeD7/ghJYN3hO7cdGw8
         CEmfKrOppoyrage3lGoY8vnTmMc3W3bltjAbzdTRFUhlNqIgsVLqSM+9rFeJZ0uh/gtd
         1ufjM/b9ZaUGFrd6S4eXr2HtsCGN5SQrTlQllX1UDtfYimjZvc40IpY6pHrZF/uJLCcM
         NTi3Wfe9XLJ0FS1SBCbaMAvr0LhETgsuov5il2xEKA8jZUKKNR0HKtcMfU0W2Ly4MD4w
         R0ZY3X6EHoc+X3xHOSios+5onOTxWRVBmhay/eHxH4w6/2fxhGguLicN7Y0vCFDtfgnk
         xQng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758311547; x=1758916347;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MRPftj4LaqpBRfvv5a/Vndy5zTyggHCJw7J9EdAecUc=;
        b=Ys/uz0Y/l/6hmvzjKz9naCqV33O7g5a9E/0eJuSUJa63wJ32qujzHG0srRfvvnOv9Q
         O+sUX0FgxILaxju6TYOiPOuzmqrjV6kyTHSfTGz0BNkGHhnzsHxs46PomybOnEuqjwIz
         jpttI2jtGB0bv3lSZnGqQNSrz7u2sthx4EfP9ms1v/98CwzNvnNAHmIq59Smjhaa7+QX
         WpYytaRv7byhQj4KzUWlInvWcMbpepXwecWOF2eUBqKuuj4qUrgIT05YmTP3TaRKEDQQ
         sCgYjZtBirh5vJdIBOo1idcK8RBDA+onwtrL9PrSWUACE6Ao1e6AKOSo2nTDS1IorLJY
         O7NA==
X-Forwarded-Encrypted: i=1; AJvYcCW54VYJkmsiPf3GBi9C4e1fES4M8aO83SghKuT9xfCUdWWCB+yJAmugP8vSXafu20HxQnvbUztOCg==@kvack.org
X-Gm-Message-State: AOJu0YxJzM4k7s8HzdZ4uqxXdPGjpneKcLTugllNoRWeh3nAX/o1p8Dv
	S4bBhl7jCau5DAWL75olIlA5z35qbDj9yImnoUCFV4t/qBxar8xxpSTqEYGNmw==
X-Gm-Gg: ASbGncs8lfT55fMbMZKKjUh5uuqTUtEgn6kiFegRoRbbSyX2Ztm4+G9lIZDq0UuWsxv
	xxXcKatm8pwpcLcY9MUhRuFdT84JttVUajeeMZBipSMOX0HgzVVd+8Ux3kdGZenUqY1vPLe8aP6
	Hw9Ch7RiZy7Gu0sy+OjBORjmLpipfBm9x1+I/mEjdn/uPMH/+6rbR1UJoTaA0wKZKUsli6Z02p8
	gu+yyEFaveuAyhCcHSbUOW7LdjGwlTpPEIslV65neeAE50cIcEZ0eqBYeYi18BGZGwDwvTpfBOu
	NFZ05kYJ3eduihv6aBSqaV11Gn4m/nlh/U1AUGy0dYuCqea6eQzC8wKj4Kywen3rHzv2JID8r05
	X7pv7LrsT0Pu5adsvFqkPGFxBhE0HAecM2VOd8XH0ho7MFRq24aKVXw==
X-Google-Smtp-Source: AGHT+IEdgDrFewuDJoDd3/cY/EMbtsLE4/UlFxrWj3yry9gWHcvbmUqj/wKnoUCikShDc6KxoRtvUg==
X-Received: by 2002:a05:690c:3507:b0:729:df2d:4a23 with SMTP id 00721157ae682-73d3a52a51amr39975377b3.32.1758311546930;
        Fri, 19 Sep 2025 12:52:26 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:43::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-739716f35c5sm16631707b3.22.2025.09.19.12.52.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Sep 2025 12:52:26 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 2/4] mm/page_alloc: Perform appropriate batching in drain_pages_zone
Date: Fri, 19 Sep 2025 12:52:20 -0700
Message-ID: <20250919195223.1560636-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
References: <20250919195223.1560636-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: duz667mxais5q63rb4onkobk1p1pc194
X-Rspam-User: 
X-Rspamd-Queue-Id: E32EC80013
X-Rspamd-Server: rspam10
X-HE-Tag: 1758311547-605129
X-HE-Meta: U2FsdGVkX19rg5uoqFXDzFHlva0KqRQf8UYKGtYSi6XkrTC3YhcipZ4tZXRb1rKnLbILK87lDM/x5XcJAz5fB7rGM7ej7XFHSluJEDWB0oEeCM0QLNk+2rSOGAWyzejSGUCEigFYVS3FtnLjb7Ng61RO5uFWRNcybMI8PDzK9dUzUnfMAbD3STY0/EkbChlgcAkm24CR1COkrhPgnWrH55bu6lSdGlkVuaC1wrdpSx4H05NDpp74SiF8M/LGmjtmoEwnBzzPPVxZKC6meCnLukNgtygGpWeOvhn81APo2Dlb795t+rBnZ3QGIOOwZvwTuVS57C+U7z6GmG8LTYl3ssjwZTPuVJfZ/9ezI4lfYq39zq/fRBHkEnP9hK+4PNdZ3hnCRD7rM4yQX3ny45ou1blpgxUpn/xjzQT0Q8+TSutmvtU3Xa2NXuudTrVkKnbKo56lndRhE9pMzj48cck7Bg+G6EVkQrdSsm04+lszVuGqPZ23ck/vTxeqWuily8VBHUOXnQdVcYaNAYa+hPerx6M1o2ZtjisbBlRP8cDhMpd+1hJ+5hBNpeHbvSKmKnmc46IcQDk+QlGPlHQf1jzhAkzdeocDPxlYT+jHU3dZhwCM7lmDoUI1YtUpyv1fcbsLReOUjOrQgZ97O5CD5zcLPTBu4GL7AFmdrprzuD3Qcwq9d9KfPAwTgfZHrAuIl841HR2zfEc2BhsAZYP41y900LgCsExCnUNDCz319Yj1IfZH4823JQCMg2pIH7Sd+R//CetIBbgum8wlUfUXzdM1WbsImtKIdDrhl1BaZM+XpkA3/dacYeMNTij0BSmSgmGrrPcv4/ATFLD55HqSe+6eZQjvyZhXWiFEt6pirgJ6XojCxEoPiESI6uXn+Sx5Z6fxDZH/nYMJ96bMRxFXvsEdtwVHyLZB15tK5V8rQCJUXCuoVbXk1ndgzHN+pSFNAnTWPHeXginXv25PEtQ7SRt
 thYC6ncj
 THM3DJZ/cF9naGJrsumHD2FVstPknH9G8gaep8MXSOujk4WkC6K1E3ZQI5/H8s0JE43GjaP2KTuenYCogSRtFxt6Tsj+qB/VB1z5+kO9nY9ZfsG7jbL9ZSgeSd5Ne4m6FoIgHSHaE+BF3KNt4ZzgWON/MLdYFedyyKrAQimOvttuoNcZD3fv4Ifl2GxHWe/bRcfKWjMZU7zVZwqCIfKLZ7PPuObbVl9KD7smboiAXhNjMKxuRGPmwenUZJb3bDdshEoYtJjMgD2p3ArGSjStnvwnNZ7o9x36LDhJxvOlQbnSNaXelErCzrb/JSVzcMlKgNOkwQvuK/AbrtNbKWS/07jy3jfxnSE+gd1v5WodeqsyzyA/C0CCOW8WN53mL9g7L/XlDsqtWfR4HboUWU0wOUm/7H3FpQfYsQ5XzVOcpBOwC8WWM831ZzmIaHaZI01Y2/rHd/mh+xNJ+iz421dYOz+26qJ9lAOF+dbi82DznEcoznj7sze2H1fodp/dBeFlIchBpsyUtw2WuJJovmUv8UnJXgcNgXOLjodVRxPwWtWzMpPo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

drain_pages_zone completely drains a zone of its pcp free pages by
repeatedly calling free_pcppages_bulk until pcp->count reaches 0.
In this loop, it already performs batched calls to ensure that
free_pcppages_bulk isn't called to free too many pages at once, and
relinquishes & reacquires the lock between each call to prevent
lock starvation from other processes.

However, the current batching does not prevent lock starvation. The
current implementation creates batches of
pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX, which has been seen in
Meta workloads to be up to 64 << 5 == 2048 pages.

While it is true that CONFIG_PCP_BATCH_SCALE_MAX is a config and
indeed can be adjusted by the system admin to be any number from
0 to 6, it's default value of 5 is still too high to be reasonable for
any system.

Instead, let's create batches of pcp->batch pages, which gives a more
reasonable 64 pages per call to free_pcppages_bulk. This gives other
processes a chance to grab the lock and prevents starvation. Each
individual call to drain_pages_zone may take longer, but we avoid the
worst case scenario of completely starving out other system-critical
threads from acquiring the pcp lock while 2048 pages are freed
one-by-one.

Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 77e7d9a5f149..b861b647f184 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2623,8 +2623,7 @@ static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 		spin_lock(&pcp->lock);
 		count = pcp->count;
 		if (count) {
-			int to_drain = min(count,
-				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
+			int to_drain = min(count, pcp->batch);
 
 			free_pcppages_bulk(zone, to_drain, pcp, 0);
 			count -= to_drain;
-- 
2.47.3

