Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCCC1C5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 22:11:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922216B0088; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D2756B007B; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74CBC6B0092; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 411086B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 18:11:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 91233A0476
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:11:19 +0000 (UTC)
X-FDA: 85072241478.13.350C1ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1008B40013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 22:11:17 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca5Kmi3T;
	spf=pass (imf17.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786054278;
	b=e3OuhGfBBRIXv4UZ3om880GgN/hAhrusIDFE5KwRLHFjWbhVXYqUxNx7aHP/2KMCwC3RIH
	sn3syr1+kaPmk5SyghsXI3xaVJ7CLGFvFCMZsDZ+8d+xTaKEdHUTqQhI2HrVhCU90YQOhE
	2AikWBTJnlwQlY/ZMTRom9FoFu/y8QM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ca5Kmi3T;
	spf=pass (imf17.hostedemail.com: domain of ebiggers@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ebiggers@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786054278;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=bkfyYt0nKyeTEUyq1ZBeSX2vfTy+B2vXRuyImjcb0Ys=;
	b=DThNsspQGuOotLAXyuH4EbgdODX6BCpyYqJp1pDTnZbvDUFUZrQwfs/bA/WBN5DS/gJRwk
	QoW6+sXu3uvore6eNtqLEaNfEl9cqq12lyK+5dPmDMb/GUPKz+AAPRPRqNnp0+kONYVFES
	fJtMZxCzZNvDB2vlF6KWalugunKzEAY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C7AB76004E;
	Thu,  6 Aug 2026 22:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B2721F000E9;
	Thu,  6 Aug 2026 22:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786054276;
	bh=bkfyYt0nKyeTEUyq1ZBeSX2vfTy+B2vXRuyImjcb0Ys=;
	h=From:To:Cc:Subject:Date;
	b=ca5Kmi3ToCwGiK0ES26yioe2ZZdSHsut3ZzWxubTNg7D1FtnC+GMmd5x7OhzF7KD2
	 2YWdBp6jHFa437dcbPVjZEcuxXMyOrjNp0u6r015ZgvsUevz3v6JxBYP9vbiiKfu6Q
	 WrXb4OHUFoGbCyhoo/kUnbm4NipW/N5vHCmfaI736zjbsVE+6tyG1FgRW3skRd+tsm
	 jDGNjYaa9mnfJxDLHnZNmVJTrJMQIjG//8la98pHYmIee4BWmd73JsFZG8BGnfwZvR
	 9aPhJ4M457RiiNXJrHZXJJVSJ/rOO7vCpfKqbhdijyn2zzaSsdNHbvVwKobJgRVKl6
	 Wvn3cHzZ3qJTg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-block@vger.kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] Fix a deadlock in blk-crypto-fallback
Date: Thu,  6 Aug 2026 15:10:28 -0700
Message-ID: <20260806221031.79050-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1008B40013
X-Stat-Signature: fmnq7t4y7u1s3i78wgf9196dt5ojyxyp
X-Rspam-User: 
X-HE-Tag: 1786054277-270934
X-HE-Meta: U2FsdGVkX1+VpZcyi1YHrduAnYV4NsEV3hTI6kDmfOemq5gesMJkpoEjW56sgC1/L1Yk1UzNpp2xkVkFPt6s7xIT9EoNylRbt80BugJxOVA8xPu7XI0CE0CgqaU4xHM+6EjyyG4/VQlDO519Hg1Ol2p2one9PU3qps8OYj6lDCnrAflt58vs6DktZe1HLjMhcVueeRK0wbLmnEE+3EpbiuoOjEA4d39kTUc9L8EwIQb5TWmVAj5N6lCMdCJHh6Py/2idbN+L5PU7BhW1ywRRIsA+Px7S3CPwnqXa1G+xGXxa9APMkMJ+ZgLC90Za12Tk7PG/+RZKuGoIYKB5vgn2Ikns54HG9vegsA/KUA1+VDQpmsaTQz0sdL09D5pGMuBqkD/dvrG/JdlnoRijHq0uCWBMwa7MC+nXcG+JVZ/yhn8G4XODGmjBvM6rLuMtwu/qeJ034fwsN8nJGbJvXRt3q1nKrU3Av5PdBSTcH/norwT3kflvqQ1KdlFq+w9HceWoxT9M+bav/fNZquUb/sLEde8FZf/W/Rq31Xy40vihLadghk5FyhD3H7jImKRUvJQOlMeoOpKyJwpRkqVVoq7BOSyrVs/DMlOcs56jbM54O8+YEXvBHSmTHFbaVSm+ZOBDcRfzekuJdWD6vTB19g4k7XZ6CYMDBltekEnRmpWCuCjtCPdURYMaoYDBzFduF99WUWcxpfiwxuyI/dhsDCOB1OZqFVvXK2L2opnMoWCx8pIhBJVVUEaTG6YGZqvalmiloyDm+4P0NQzUaKF5ceLW7MXYBS+J+n+D7/YuxglxQ44XZXkYTh/vw1vCIaQuhpu9WXkAI4tzuvsNBdKidtYZoSI0qJ5hwTvX7MsPxLLhEWZAmu8zrogyV24Kj0oCShF3CIPoaGfha1ftvOfC79U8iAMDBT8+p+CzuNEMNjFg/VuX4t83iiOXgSuWeBz8vsPQONUMW6vQiH2pPP3Vmzu
 +kx/aHra
 kfOCIjEqDdoNH+Zlw9JpsBZ4WaaCzORI/Q4XnYfuu4ARuvQgUYjFH/RvgQ5cy/dHd2DtBqxOCk5JOaS8OeZqVMouBF7145SI2bAUEO4ZV20E7PBdio6wWr2QaHt3HSd6azwKXbC25jJnLUWVD9W2IVnhIcfPEfi2Sb1PGbBNNoDJkC6G3995xmQvBPlZrKQ98zRVcP/UxnUUm//g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes a deadlock in blk-crypto-fallback that could occur
when a large WRITE bio was submitted to dm-inlinecrypt.

As a prerequisite, it makes mempool_alloc_bulk() support fallible
allocations in the same way that mempool_alloc() does.

Please consider this series for the block tree for 7.3.

Eric Biggers (3):
  mm: make mempool_alloc_from_pool() return bool
  mm: support fallible mempool_alloc_bulk()
  blk-crypto-fallback: Fix deadlock when encrypting large bio in dm
    layer

 block/blk-crypto-fallback.c | 72 +++++++++++++++++++++++++++++++++----
 include/linux/mempool.h     |  4 +--
 mm/mempool.c                | 50 +++++++++++++++++---------
 3 files changed, 100 insertions(+), 26 deletions(-)


base-commit: 0d839570765118029aa8bf4a95444c6a11aacf85
-- 
2.55.0


