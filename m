Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27410CD6E56
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48F316B0093; Wed,  3 Jun 2026 06:46:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4187D6B0095; Wed,  3 Jun 2026 06:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 306ED6B0096; Wed,  3 Jun 2026 06:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1ADEA6B0093
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:46:47 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A8F381202EE
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:46:46 +0000 (UTC)
X-FDA: 84838273212.05.899A8A8
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf23.hostedemail.com (Postfix) with ESMTP id DF1EB140006
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:46:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XXGF0ws4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780483605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=eX4TxU9rB0+/Bivm6trS3GNuZ9v16Mi+xd4AjbxmjDM=;
	b=Gr4SdAP9SbawIDL4xmNpsr60vtcson/3fW3h500GLzfMVKgBgEOQmyGJTgEnDCqcbw69s0
	HoDbCpF/TY+FSd5FV+uSbLDOanM1PMO9b9rU11+lfTNI62MIxalexTrUmTFfk9+zoIShdQ
	W9olHhjLEbY70aJlz+TkxjJ3CYt0ARA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=XXGF0ws4;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780483605;
	b=4Wn8RaAeP2tUtV/P9tNJiMRHkNDnK/DD5YTePRkCo3o685zTJtO0A/14ZUU6dIJqL4uhfZ
	Z3LXqib8Elwo3zNAZIrw0sbxrH+R+nvxMR+AzGKjoxRXd56h/kz/qPgQiA7cUStvFc+XRA
	8C6bNOi7tM40P8efT94BivS0euGyUFg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780483602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=eX4TxU9rB0+/Bivm6trS3GNuZ9v16Mi+xd4AjbxmjDM=;
	b=XXGF0ws46yyClAQ65lfsa2iDd8t9S9FUgM/ihG6ET15TzjyydYQOLLE/QG60SWFONV+T2F
	/jD5/kRbsEKB9F1vZN4T/dpcgNZp8AfInoTdT23j3rFIcl888YGD0YX7Qh09yW6LLzJ9vY
	Gq6uLBa1eOm34vN+812305wSvgki2Mk=
From: Lance Yang <lance.yang@linux.dev>
To: akpm@linux-foundation.org
Cc: rppt@kernel.org,
	david@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	hpa@zytor.com,
	luto@kernel.org,
	peterz@infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xueyuan.chen21@gmail.com,
	ioworker0@gmail.com
Subject: [RFC PATCH 0/2] restore large page mappings in direct map for secretmem
Date: Wed,  3 Jun 2026 18:46:22 +0800
Message-ID: <20260603104624.36390-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 76sdift7115779xrqmx5xqcc6f9ntuy8
X-Rspamd-Queue-Id: DF1EB140006
X-HE-Tag: 1780483604-684945
X-HE-Meta: U2FsdGVkX198GcfAnpq3i3muhoW4EjI/gych8aKQ3yeC6CurMWq025gbWB9UbxqVKEVLnMWuB0oohwmA54Ps+oEcw0YJLt2uUw0/OaCOGsclVG8+Rs8WHS4ZJGYe3jpMXRXzamaOsgrMU8OIBQriYwSDoZMyK8FugSE2/zBeckxRqghRpqjiHroG7PPlepU6Mt7F1atMrX1Q0fxhgEW3zjq9DRNsovGYDYIZpRsXHB8C9PXB+MCjfay9T03fmUaQw07pFcE9ibVos0THASFtCuZ4I3siq4u6BFBSrU5+Fxk9XHZHXhtO/0dwKQCPm81sx00gZGY7M78JH/SqmHLxzMCxeDKqeJTgpwEyuAj0v2gEg84Vp/8rarwH+x/9nEnJNy4GZI7FqLAf/woelyPGWo/6MOgMCOyX7xQSs89bFeKfFijJOBrQ39qgJDwyyHqGduY4uhZcg3fdXysbxL5jf/KQbuiPMDj42Whsxq3vCRUVXmvj5zGZpePvyykTMXvgVdanbQwDY9fZ1aiH+ziqMcNDqDyeSHQuO92oD1x2fXni8u3kAsJ5HOSDwvemKaYp4U7YUAdhATJliDdYvGrAGRZ/J1pBL0Fe4uOVvHbIF7vhiZRr8MWcWydp3ZO1d6ksEQ/N0BOex9ln0ZbelIadA2XduG7qSLl9alX35WBtXeR2I5LF1+pcIRfvzo2TWJcQjIWzaelrxnveCi59wZ0Ti3X+YpHcJbcUNaO7GPg6NzJpeN2kKMq9D1FrVmbMSF2Y1gFDe/nydZ+khcAEwhugtc8Z5eUlXYpJqMjnbtgoXERZrSfpK/hqq2gxRVZ+8GYhNpC6dGdPfchlEg18Ws4wo5peQqV5MA9LRcxDXygh8NNwnMN/hCM8GXZnmGKBAiJIEJeiL+R8nW44AbH+vC5jgn0oqvrYvXc59WMBIST3i7lfmBU1OyS9NrX2PB0agTc3QkI/URB67oBQpse1BDk
 MWrpysZP
 cWYfnbfAwe/0h30j6orxBU28LGvnCQOxqZBbpEEbeQfcsKVrBxhKKRrk51ibMRfDLaGMUCD5g0Yb8BC8ZrkS4gx7Uj71/blYhrjuKPiiTnqxrunl+YaPQfwLitvaMN47auElGN55Mu9ucgOJkJWzEMwbEZkLnIlw+2bJy03s66wVGtXOc1fEyoh9bfZ8M2OYxTljdUo84ZNd21BW8V8wmy/JlBKxwZAkzgeQ9t5T8ZaZ931+Vvft5bNDMPvItSD+lXWNPbSnGfAroBUg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

secretmem removes the pages backing secretmem mappings from the direct map.

Removing one base page from the direct map can split the covering large
mapping down to PTE mappings. Repeated splits can leave more of the direct
map mapped with PTEs, meaning more TLB entries for the same range and
potentially more TLB pressure.

This series adds an arch hook so secretmem can ask the architecture to try
to restore large page mappings whenever secretmem restores a folio to the
direct map.

Thanks,
Lance

Lance Yang (2):
  mm/secretmem: try to restore large page mappings in direct map
  x86/mm: restore large page mappings for secretmem

 arch/x86/include/asm/set_memory.h |  2 ++
 arch/x86/mm/pat/set_memory.c      | 27 +++++++++++++++++++++++++++
 include/linux/set_memory.h        |  6 ++++++
 mm/secretmem.c                    | 12 ++++++++++--
 4 files changed, 45 insertions(+), 2 deletions(-)

-- 
2.49.0


