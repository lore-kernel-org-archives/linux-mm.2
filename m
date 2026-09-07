Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52530C79F99
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 17:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D3AF6B0092; Mon,  7 Sep 2026 13:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AC4C6B0093; Mon,  7 Sep 2026 13:28:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EC116B0095; Mon,  7 Sep 2026 13:28:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E3D96B0092
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 13:28:44 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADF0E1C1B0E
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:28:43 +0000 (UTC)
X-FDA: 85187650926.05.4B5901D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D208C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 17:28:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PYW1rCbZ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788802122;
	b=lRlHE5OeWYoXMaIeIU4NKv09/INaI3Yol4ixz17+byEPeyr09ZMIOZvsKycbQ4zeMXG0FL
	XVyNEDg5aOynyIulFx7/1RcevMmrlQZ+kFWhDd62W1irEpDnCmnDk2uMNX4N1cqVpPv1MK
	Z7Cc68FBdPDaEYI84sELKPQl84A1RPk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788802122;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5b/sg7nRQD9/2QrfkHXPbfXaDTnpNCHth002k6PlL6w=;
	b=SUce8qKqHreMoZ3rWDqgbCuyfzWvq/DINJN+JciVwhUXoSUhJJED5j2xwLGtZlX/ZEHvEK
	x1F7o4GHLUVGobKq1UJpD44b7GdWM3jMCqDFxEE9sIhhPzVURiNqbiVdHPIQcp7jjt1ZoB
	2gyRcYWEfvNNDalWYQEC4Cnhf0NS8aI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PYW1rCbZ;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 86CFC601DE;
	Mon,  7 Sep 2026 17:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 045F01F00A3A;
	Mon,  7 Sep 2026 17:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788802121;
	bh=5b/sg7nRQD9/2QrfkHXPbfXaDTnpNCHth002k6PlL6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYW1rCbZTZK99N+NNFGs7g/OHBV3T9qv/759RQ4v6LlXSkJ2M2a128/B1bdIaxXiN
	 5gvQxG2k5CpBoaJC9t/yFqaiCKSsnDMm5ncqUSG7xSz9uBwyPVrJYpAd8PZBW1DwdS
	 7MQG73viD3iqAfSx5H3LSBirkbRRQFY8UQ3PPQUU2wi6wOAX2Yh6wcaqUIV4CYBRJJ
	 f+I1jPepRGT9vQfbvrexSaraqe5iImI36nqXHWZvskLwPhdRZmzQ++s3b3NoncP5Ff
	 73LRe7TTCFuEfILDGmnK/iqP69dlFoKRAN9lqsvyeD9M8l7qnmhJf0jIoUMrjMXz3Q
	 rnEiPxrVlZXUQ==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	stable@vger.kernel.org,
	Enze Li <lienze@kylinos.cn>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH] mm/damon/core: reset invalid quota->charge_target_from
Date: Mon,  7 Sep 2026 10:28:32 -0700
Message-ID: <20260907172833.102388-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260907165529.98874-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1D208C0003
X-Stat-Signature: 786yyha6q5b4ugttdo9udqntgzstyy8s
X-HE-Tag: 1788802121-173835
X-HE-Meta: U2FsdGVkX1/peiSQhwgPBjtQHNHFPZvidKM78SCnfhX0W7O4LH+fa57QweQOYAdjutfUa6msAsVj8Cr6TbxWqR4lXTW6pmpmRqmF/6Qoa+r//EIuPyHO06yAChWG2cPruQIagQXgwlxcHfLE4AGf/igM3j1BQIEsdYmZ2j5qcUDYhmb6HcwVT5hAH2kNNGwlrfqynib5qCFcfN30Oyg7PGnBPHPlKEKed09kXCv/xTvnihnv96tamTl5MHP1n6ySK8mC0Bi54GFH3nK7ezesqpmELezxlT7Y4j/x8gnm97qfmHlgbJsiM7f7vuvuv9m9x92hsmTD667cF9FMYhS4/Pakmb2EtgnfGJO8gvOhmVsmQub2P2t4vFTVICfhRr2jbzSUzUT/DagjoF6dD8jXBz4NeGZo9Aw1WRoqaDfc8RW7XTfHVqZyP9V5gBcvIvsVdgmoU23fVbpnb30CEeFrl/vjmk/Cx2+VYrZl7ndb1p8zyWSFwuhH2FikLsAOEaNF0umZck7PWm/jhCFGmlr/aPidY1BlXLCIogccC6VhI74i8h1GMJlmiCw7YsUk8BmC/PVA01ySqphkFR/Fw7M9NiL2HRXeqJwjQm6DW9Qd0ZFG/IsAEq+wnrUTnuuJuVcFko9V4Uen/WNQOibnUfn3mH+KBqRs2vl8eyTGs0QdKIEEMmgwzRNvWRpRW9eoLsMeplWki2pP2tTzJRs231HKW+i5pnK8gZOI4yrtSpiaXdJMSbjIYRxheJzhKQukSZeWX05WYsoN5Z7nDJkGLP43Si2OxsegEp/6UXD9KWaHxYRcNyROxijtD3lgmKrw3uEg0YG9tWb1RtqKV6FhsUKMeNj2d7u26w5eK1hnSCU3o4Dd922zz4qyeUI0mmpZXKn2exHFYFPvRAiwnTdRYESdw/0X7JwTw0krvnUtJkAShBmhlsCgx3Po8+v9WKIf7xGi/h0HcyOgLSNJDce2VN8
 mKxsBAR7
 y9yRDAWbt1iT2FxFm8ZbkPlWppdk/Vkz2VQqFQg1GUnbiMJ1NVyKirTRq2rW/QBtSgmLCH5NNkf10xlDXDs0FS9PF00uwQoy+YcxKfNEJCX1vSGIKR84N+6oulXdpTsgFzsDKGogknfseahqD5VU9mTciCoYX/lJeE3ndxsNhxTxtKbJx3hEHLcinX1JgbRWfk1ABOwd5LO4kXUnl1jdxIUi39Q4jy2Y26F5srzrS+j1sPVxxLZbYDQ13H7w6MYniX3ABCH9hgU3JkLnLK5v5BiIgiA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  7 Sep 2026 09:55:27 -0700 SJ Park <sj@kernel.org> wrote:

> DAMOS can suddenly stop working if a target process that quota just
> fully charged in it is terminated.  Fix by catching and processing the
> corner case.

Sashiko found this fix is not complete.  I will post a new version.


Thanks,
SJ

[...]

