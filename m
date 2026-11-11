Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864A1606A8A8
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 15:35:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=FuOjHULe
Received: by kanga.kvack.org (Postfix)
	id A66E06B05BA; Wed, 11 Nov 2026 10:35:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A17666B05C9; Wed, 11 Nov 2026 10:35:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92D0C6B05CA; Wed, 11 Nov 2026 10:35:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 71EE76B05BA
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 10:35:55 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0A3A1C0314
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:35:55 +0000 (UTC)
X-FDA: 85423238670.16.6E23957
Received: from mta0.migadu.com (out-107.mta0.migadu.com [91.218.175.107])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD90C40005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:35:52 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FuOjHULe;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794411353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Vz84Kwwxu/OXORILPVs0FJv1ASydR/NK4sfzJcCSGcc=;
	b=c2wsTV94RGQ7RUVxiZKXE9l7k1tFDxdv4euVkJiDq515J58pIdigvW++BPPrNIZQz53SQs
	MFO27ogW3EBNuvG1gjkPQIOyGl0L7uH7xNLYE7tFtUakqJi9Y+HbOSOMFWy6gSXYjJp17R
	U3t6S9X5+ECQ+xrXLoI1y4Y7OYaQ+SY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794411353;
	b=MCUArnghnS++mhrnGhteKrZUSygHtB2hlI52f8EXsmml6ObgqnpfS793rJUxgt5364VnRW
	6Lpwq1VHCLibqdp6XD2vYOWXGhFvAwHCAUjUgHTeeXs2iBf16D6aPrrbcVlLjLeHwD+DTC
	CmN7jRELnD2pu0i+CKoEkyoEusHTIrg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FuOjHULe;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.107 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=aX9pIIbzr0WUjOOk9ufqdHhoopyWbM7JVXWDvohF98Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794411351; v=1; x=1795016151;
 b=FuOjHULeZ4ZA4/WVPcUF3X0QnNLWtVcic5UB2IwZMDHmSZZNODuGnY07gPZ2fn/9NiQ+iqiL
 /ZOiLmqaNti3Ez5r5JkCMX9rZ+s7ryIILNBDQTLBIyXF1Vl3Lkf8Q4XlNRArwEGfBOMojs30KyW
 bbLw85cRuWKYTmzTzK5D4ipg=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 5069cfac4354fb9b;
	Wed, 11 Nov 2026 15:35:50 +0000
X-Mizu-Trace-ID: 5069cfac4354fb9b
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	davem@davemloft.net,
	terrelln@fb.com,
	dsterba@suse.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-crypto@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kernel-team@meta.com
Cc: Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 0/2] crypto: use vmalloc() for large stream workspaces
Date: Wed, 11 Nov 2026 07:07:38 -0800
Message-ID: <20261111153532.1036709-1-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AD90C40005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: af73htw1wx66dmxfs4r3bmhd6puawnxa
X-Rspam-User: 
X-HE-Tag: 1794411352-420202
X-HE-Meta: U2FsdGVkX18zK13UZHqRUgeweMfiFU2eOALv64S73aaB0f7lrWPVhfVsJpnCyCoRs9M9zXD69pp7CRpabQpSFlQBYAOfObgQDTcf5oeLbn26d4/LlFikzOAAlY9shG6mnINFxiMwyvSUlI5CqxAnbacdV0QoZLFimF2q8wSU999Z0MEN9H6ICpiivRjStsFs4hjGdqUm5QQMw80UfCZc5aZaA9Jmfv+K+P7JMgRjg11Ww5jp+6HZVI1I9i53gBrEmIEGcJ6EiStVN0YrX3ajcU3cwOEZREyoSdW6sJRcY2L0AIvOun1ZEoctWwzdfdX4pPBcd9S1HYjEg3+nx4vk5GMav4noXa7iKOG263UVBEMI10ucOYhWLb+7+KmbCCAULXG9nV22ytAG3LysnRgvea3QPbzgDWMu0j9gOXWjy/cB3RFFNEKvK3iiijKlMG5tEW6sYVlvBSsDwpEICGr0Z71GtWLiKPoX/seOSrvsB0L/8rRct+ZIvfMQj9T9sf5c+qy0QliL9+NKY/8P0flYHPCMlY7V5iYoIWX1UEvjeX0yZtU9LAWSw8Z97QBfIWgIOvYBm383XOwoaAkxpl7Xz1CX6ElKWj1Mgnfctt0I0/W9rKzhENqDBNz4yL1yi6R+kjLmzCTV4gvxT47T6+PO6GHfSORJq7xR9o9rEaAYa1Tkh3pjpHKQRMBFleW8hkT1Wfj0LnYqRHSa5K+9c+ne0GnEpJ0KhsrXo6hfOhL/piOQo+34CSp49nGlsEWXYL/Ipk7FqG5j+NDXzZnNpKHPKXdmkSglBNnb9USuZd1Rd9Scu+eNW3SyjQNyqBFLvZIbkKokC2xrbJbiE+2RWV5GL8SjboQntvPnh+z6El3nel/SpgDbRuNv89+Eu8TvfqzNNXD7RzO3yyAyOgF9u6m+U/mzv6U3TT7BRoNxzq68Dyw+KECTINPW4LBvWtUI4Ht4yi9YZUqwOOloAhzlEW3
 ztLb8ACy
 0mGM8fKrmu7JIaUrQVWVeWfX3O8rwk4XlCO/Iins/4ckjVXhHWgHA5KYtZXNkK9gaC7OQRGO3LfxFp3jVlMhTxzLFJqtL0NETZyP15hAy7S+hw3fXuVbcB7SNdaJDYR4iGGMO/T0g4kubELmMlYCSZtVOlJ5RfEOEJX7UMBSKiGJ+iHFFuvXK3MlHBNgPyXLm9ZhMNBqrLBO7tmym8lfLfk4/mrn7sFBsuXDUmHaJKuKotfqtZRmGt6btKUcUr+5z8MsNS657lr0Om5s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zstd and deflate acomp implementations retain per-CPU stream
workspaces until the algorithms are unregistered. On x86-64 with 4 KiB
pages, kvmalloc() can back them with order-9 and order-6 kmalloc()
blocks, respectively.

Use vmalloc() and vfree() instead. For a server with 384 CPUs, if
we have streams on all of the CPUs and kvmalloc() takes the
kmalloc() path for every stream, their workspaces use 193.5 MiB more
for zstd and 42 MiB for deflate.

In five before/after boot pairs on a 96-vCPU x86-64 VM with 8 GiB RAM,
the test populated both algorithms crypto workspaces on every CPU. All
192 baseline workspaces used kmalloc() without these patches. The patches
reduced workspace backing by 48.375 MiB for zstd and 10.5 MiB for deflate
—58.875 MiB combined—in each pair.

In five before/after runs in a 4-vCPU x86-64 VM, median compression
and decompression throughput changed by less than 1% (-0.93% to +0.64%).
Inputs were 4 KiB and 64 KiB synthetic buffers containing pseudorandom
data or a 50/50 mix of repeating-pattern and pseudorandom bytes.
The differences were within the observed run-to-run variation.
 
Usama Arif (2):
  crypto: zstd - use vmalloc() for stream workspaces
  crypto: deflate - use vmalloc() for stream workspaces

 crypto/deflate.c | 5 +++--
 crypto/zstd.c    | 4 ++--
 2 files changed, 5 insertions(+), 4 deletions(-)

-- 
2.53.0-Meta


