Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDD41606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 07:58:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AP3e9CWV
Received: by kanga.kvack.org (Postfix)
	id F41426B00EF; Sun, 15 Nov 2026 02:58:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF23D6B05B0; Sun, 15 Nov 2026 02:58:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E08276B05B1; Sun, 15 Nov 2026 02:58:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3FF16B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 02:58:51 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AD7101405A4
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:58:49 +0000 (UTC)
X-FDA: 85436601978.08.CADB3DF
Received: from mta0.migadu.com (out-74.mta0.migadu.com [91.218.175.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB7E440006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:58:47 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AP3e9CWV;
	spf=pass (imf07.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794729528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GWTDxYXkosCm/4nLdsWs8v5Vb0AUZr9LNbv3Ex6rAGg=;
	b=JZMKraiuCvg985m6wnz7s4Euzmb1iqIXb3GKs7bbbOIbAGzftZwtUALB0POBYA5Sjzk784
	lH4/nfsROtvft8RjpzH7+pj8rsR3q5MXx0fHIc7Y78JFZCRkUuNlnjni+NryoBsE/rCN4X
	8NtgQSCBtwSzEgtCO21vO+fM03McWIM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794729528;
	b=8QtBqaM8GUOj7ZyB8GJirSb3mFUSZ/F9w8o6J7UFDItjxTGgCGd+U9jW04d3DXc/rDrcWk
	A8dhabMlYgCuTGCRs0z+awgEUq7+7jDPtJidJAFPWvc+zhre3LGBs6MI8laBlOtPJBGvRL
	Lsg4XJLcm3ma6e2paKi7tSBsRrmIMrI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AP3e9CWV;
	spf=pass (imf07.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.74 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rgg6s0ozTHu2TZmu+4x+Y8upPU1pTz8M7b83SmtrD+0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794729526; v=1; x=1795334326;
 b=AP3e9CWVGhqI8jrQgcTRPlyQdhwR0hejiyWK/WKsIuPolg+slW4psDHWQDNKSGTJisbfGTdL
 0IiflADjZkaqyi7r7g33ifpZhFfzHbWwXaHmL9k4GpWe5NpDcrUs6CUw/zMgpCPa983ZpnDWRHZ
 qwSkv/SwBhwHNL8gQOTehhoY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 64c76c5826d27005;
	Sun, 15 Nov 2026 07:58:46 +0000
X-Mizu-Trace-ID: 64c76c5826d27005
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: David Hildenbrand <david@kernel.org>
Cc: chengming.zhou@linux.dev,
	ljs@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	xu.xin@linux.dev
Subject: [PATCH v2 0/2] mm/ksm: clean up scan_get_next_rmap_item() initialization
Date: Sun, 15 Nov 2026 15:58:32 +0800
Message-Id: <20261115075832.132109-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xgjgm1ws147dt1hhm1ctuisfeagcebaq
X-Rspamd-Queue-Id: AB7E440006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794729527-766342
X-HE-Meta: U2FsdGVkX19L7Wop6U6hEY9oVNwNR/5ROll5tegCnbtAEf4iFSCsJ3T5FqTdqjObDdXCj69Hhm+VtWIosNUEhf19p6+fJgCoTvxODv0R5Q6DnV7ugapByhOsftoiXUfKGq5xKDsR6pe4We8AAhlmYNh0SqfA/yO0W3d/9anvuyyzEEiveXDjSv+nUWNCE08zfqV1IZ1rnS6xEJlQuc/H3cxa5xT6MGVkouFFZVq+noYp+pvVVoDIFJpcVl67njtFv6/jeZ/+kj/e398s0Z81l8d5qt31mtkSRKhrqa+KzaZNwPHsKP8znR/oY9zaX9dseVs/rn0AVz1LVJUE63ujWxrOjkGPYVflntg6CX/qWHyvyJ5RuHlneJEYpeBksyrxam8rbTCnIrP67haN3a1pf9O5pYjfZde6wR8C7Z0OHkAdBI7VDvyduIFJGA+C7EJwku1Dt4fjiXwVkw/iU8grgFzZwTYM0PJljww3PbuoptRqg2UxWR9bUBu2mharGem1SFcOqYMcElLYFtB7GcSPTOBYxpVMoVK+0R23GZAmu/UtQLIEHu5/GkJBc/rmXxjNd4f9S3hmsDup+X0KLgOcKzICclrRy+/n/e+1rT4d/roW643o3I4iu5tGLA4my7+J9V3IL1/oooPKcaekv9MQc8HcD/niq3BpLuNK/62LSHou88D+rWvbKTw/8Os4z62zfrlL2UpcI2F8PVNF8ZJrdqtPsTLpioL/qua9cowR0DicmcLgBKcRBVuMH3krF3VqHWzTJu7LfV5onZ7BoM4JStZrnfvavvQ1Z85FmoYYt9nSlKIQZjneWbigfevvgDfV7GpKWYBPLFenb9yw2bquVcL1dxW3gn2izABidhzAXwDQXE/1eaWErSAa2mInnPHGQZnzULwAXqQ0PFMNbPYVSMo5o87YsCrREegaqpwczHZ7JBBRUSIZu03BcOnhcTvzE4kPGtZRniDAqZi96+w
 znqUssYo
 l8+YA6THs4HOMvfxoeo275uZJUyJ3jqLo6yhas58QwGjbl4EH9yZuhbsYzflyBBqy3/KgV95vn6gc3r1Eb1RP+cX/xY3Hc6O2HN7/XxWZ3jSRYERGUsSWG/Famew9SvIPM9gQkmkcJN3wGoItuDVAqAz+yGemEPo2N/dUPPgzsPdR1H7Len6QsqBXxssd6QAyvp3EtJlN31di7OO8oe3aRTIECvSNGItjlzzDnU3u3dt0PqLgvHrEN78IAa3fff7RCjF4hWw20/LEqtL20pJ5UEMEUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, scan_get_next_rmap_item() has grown quite large and complex.
When introducing new features, such as the only-merge-zero-page mode we
are currently working on, we don't want to add more complexity to it
and don't want to touch rmap_item structures to avoid unnecessary overhead,
so we need to extract some common logic.

With these changes, the entry of scan_get_next_rmap_item() becomes much
cleaner and easier to follow, instead of being cluttered with unrelated
boilerplate such as stale stable_node pruning and cycle initialization.

Let's start by cleaning up these two parts at the beginning (where I think
abstraction is necessary), and we can continue cleaning up further if
needed later.

Changes in v2:
- Rename scan_begin_new_cycle() to scan_should_start_new_cycle() and keep
  it simple (David).
- Keep lru_add_drain_all() in scan_get_next_rmap_item() (David).
- Use scoped_guard(spinlock, &ksm_mmlist_lock) in scan_get_first_mm()
  (Lorenzo).
- Collect Reviewed-by and Acked-by tags from v1.

Xu Xin (vivo) (2):
  mm/ksm: extract helper functions for scan cycle cleanup
  mm/ksm: add initialization helpers for scan_get_next_rmap_item()

 mm/ksm.c | 98 +++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 62 insertions(+), 36 deletions(-)

-- 
2.34.1


