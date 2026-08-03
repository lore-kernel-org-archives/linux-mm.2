Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15F93C55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:40:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2946E6B00E4; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21E0A6B00E5; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 134296B00E6; Mon,  3 Aug 2026 09:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEDC06B00E4
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:40:39 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 777DF1206CE
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:39 +0000 (UTC)
X-FDA: 85060068198.20.8E544B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 023891A000C
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 13:40:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAGpRqNd;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785764438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3grEtyvv7HjTLXQt7Y4dNymnDB9y7Wt+YYyBTBraHmg=;
	b=2Fk3RLuRtS9yhnlKfcKirgdFklMNJU1/cGTtV0V4N8h75CBozK/hYUtXoGT9Ba4+QWbIiy
	+n+gH9EU1Y67Uy1Qh1ddgNuIjw7EcglhV7AD+YukbVKWlJETdIisoXhgndfpXdgg+kj17L
	AQFLYqGxFO9THBLV0HhC1NoHzRpbaIM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785764438;
	b=LhLefe1u9biQp91Qyyw09cykuZ7ylaKfP0Qa275iJGNbvjwUMURKUhZeZqw8PdazO8IdWM
	N8vVFmtnZIfsSIy+Ha7d/ZflxBq2ZLcsY131M7ucXxJTPC6hR3loZ1XvzujM/kjKkD1NjK
	jfQ8iOAyQb0jeShleD4ojq8axl1L+bk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YAGpRqNd;
	spf=pass (imf19.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7612960A78;
	Mon,  3 Aug 2026 13:40:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E85D61F000E9;
	Mon,  3 Aug 2026 13:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785764437;
	bh=3grEtyvv7HjTLXQt7Y4dNymnDB9y7Wt+YYyBTBraHmg=;
	h=From:To:Cc:Subject:Date;
	b=YAGpRqNd6WrF813XPCqZqeEcUR2QAnZUs2khd/cjc+J/tv5Ps2keDxHV9eJzQ3SPG
	 Yl7RSgO5/S9ndAwd81zKFJaNjrvocuim3ecUvYlSTZ3LNlovR7u7nV1iZ+l+69qKR0
	 /o7BRcpMpLLK5UQXHIFPXhRMVvg/nroIZQra8ei4jU5bi1WsA/6BWCh1kgbjo/NwMM
	 8hjhR0E+YKue41Y2TLEApRClzvKKbfGR/eO/feJTrIZYutbRrazDjiEJoni8MazCYP
	 XcYzy3T6mRbJl8sCC75BgybNGsb/CNU0dOFvG8HbgqpEG5D20uIgkhGm7KzOgU8M7o
	 +44VyN3xHRpvQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Yunjeong Mun <yunjeong.mun@sk.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/2] mm/damon: avoid division by zero from damos_quota_score()
Date: Mon,  3 Aug 2026 06:40:31 -0700
Message-ID: <20260803134034.15217-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 023891A000C
X-Stat-Signature: 8bohizt1n8dp81ia5am7tue7y7ko8pz7
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785764437-686935
X-HE-Meta: U2FsdGVkX1/MfQVUula2LZM4vI0xOnjBJF4UVJLZBAIyokgwm4feErkC+v/kMFKlNIksmH846fJGWQLGp/LzDspVb27DWkxZVAGiDpjHfRCWLkxBtbW47AQIyOzjAfVxVw7pYPO+vVY+680bld6yxLLjwoY+OLOM33jL+2T1Vz8v7leTjlNWe/qCJTAko7QFhHGx/Ji15c9SyXLpa6ymJci0h2yzoleStj8wQl4JnlL+CrzcKqFaSOAZDRqAKrZHBsRrRmQfk1USVGZMHLjuueEo3jviGwxlViAFZ/UDJEKUGoHR/f6Wmb3D506Nhvttz9U6e8OtRkyhux7XuxmFjIne8D/ufJhdQOMUWm9CoFRubz6UfPVedJcXFnIzujdW7Ch4Iux0btM6uC7SrWBYeG4LOWSqCmGD2crEjt/UMCewxhy48CTDCvLttRC60+lTPo8lX6q0bIWjcgrlyDNrsghlzWJ44+uIcGytNxMUggt0EnjS6yOp05eOENLXCEaf8U+ujx5i/65qbrVa3eq0yadZ5jN99aM59Z46ImyH0frl/r77U0EGC8RilnuPuLH7L0GNwR5UDqh3DVTS0yZjsrFnUdMA0znwzK9g5HmPVX61w69MW13KlA8NVp3pFyKM9bU2G+eCCfKEDfrmC8WYQsuZAGC/P/4ZWtjbDy6VxuRkxETNw3bJeS79ex8sZaK7ke+1485ZDh8coNhTEdaLInc6gDRga6kng72WB5Jq2td1O7oHQmBJSVItXQUopjqM6CuIhTVZlm/fG3AiroBW9XdfbSDK3sXabW/nwu3exSW4oJnu/lL3jLbfMAIGNdM4+7wWBFLE6+3Yph+ljFBaBYyRj9/JrHyQB+lzJwQZroecdkWAgSw9wczLtnuJu4aIo2LljD/ykF2+LctiH5WNRPEad74sVJ6NVnm/eR48eOs3V/pxJkf0+Mh4naT36oLdWdYe8rdVz8wCb361L5H
 0Wztet1p
 X23BXjesvG80g5sxHisaF+HQyaxm5cvz8PR2A9NuGj5A9WC5I7/651fdP80NMTvfLM1eiRdPD+Yg9Id/Rd6/zDfn0hf/Dhtu90fFwU54+MOJVoHDw+WLQbzhfBwiBZQ6w4esvurVq4pCMB8ppEtNxSEE6xn/wegRlmwb91Lx7ehmBSt1qlqsuIaW2HETFPGvkdO+Y7U6KiMUr3sxSNAM/P0aQn03fvcnIeK8iUVGHNI9xT460uq/fclONFimTakvuwpNkgIjz1zUyMmBk3lfI6JLuZVZknGM9TlaTPBJrO9Qzu0E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON_SAMPLE_MTIER and DAMON_LRU_SORT allow the user to trigger division
by zero in damos_quota_score().  Avoid it by adding parameters
validation checks.

Changes from RFC v2
- RFC v2: https://lore.kernel.org/20260802162050.89477-1-sj@kernel.org
- Drop RFC tag.
Changes from RFC
- RFC: https://lore.kernel.org/20260801211315.2456-1-sj@kernel.org
- Add a fix for DAMON_LRU_SORT.

SJ Park (2):
  samples/damon/mtier: error out for zero quota goal target values
  mm/damon/lru_sort: error out for >10000 active_mem_bp

 mm/damon/lru_sort.c   | 2 ++
 samples/damon/mtier.c | 3 +++
 2 files changed, 5 insertions(+)


base-commit: 3bf69d5b51b688b8f923a13b7f12eb9b1c6a284f
-- 
2.47.3

