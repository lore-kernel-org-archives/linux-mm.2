Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6866C88E5C
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:21:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C635A6B00A4; Wed, 16 Sep 2026 06:21:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14D46B00A6; Wed, 16 Sep 2026 06:21:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2AB96B00A5; Wed, 16 Sep 2026 06:21:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8E1226B00A3
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:21:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1D0616063B
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:11 +0000 (UTC)
X-FDA: 85219232742.23.AB5D470
Received: from mta0.migadu.com (out-78.mta0.migadu.com [91.218.175.78])
	by imf16.hostedemail.com (Postfix) with ESMTP id 284FB180004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:21:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yf6HUQ0wAMz0G8wZZgS5F81k26xdJYyMbkW5zISosIQ=;
	b=cpMu5SE08fjsRP8ZHuGzunSYv41T1ZOFzHOpfn7BF3y4Tb5RunnLGf94smvuKgo5agEV91
	vR9zXIoNkrB0WQfTDiU46OvlnjJLnNkVBFrNtG/E03V0WkH59ygWJJwiXXxHRsUuYD9+WL
	JwJS7uP8HQ8K0Re1VY2zINshw9xP/hU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554070;
	b=suIeNBf2LrlKXICx3ZFXvndASnr271WHo+ban6ss0oNqTkpqXElox23vmZJK7tZHRZpFfh
	Lmay3bZINupJ946ixphB7ACq08F5+k3YswRWWc8ukbqKGeK1mgoiHKARHV1wgpckjDjFuD
	6HGqC5xmQ1rG1sOAlU9ND/dginbNdOk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.78 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 0d5d1a8d72c58130;
	Wed, 16 Sep 2026 10:21:08 +0000
X-Mizu-Trace-ID: 0d5d1a8d72c58130
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 11/14] mm, swap: require zswap for xswap devices
Date: Wed, 16 Sep 2026 18:19:18 +0800
Message-ID: <20260916101929.149106-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zaumuqhfsaa88cntbp7fjjmdta6oju47
X-Rspam-User: 
X-Rspamd-Queue-Id: 284FB180004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789554069-986244
X-HE-Meta: U2FsdGVkX19TrM02sQOyFV1kFJwjk2zkiAJ2m9fhHuju/f65r0MfiGf7XiEIwQWSp8wf0bpCr3vklMbGDA0ee4Xg+toeJRuKVVeRm76L1c84p7OciqEncF5Gz4kLWQ1IWvSmSQ/+Tp56CSDGw0KlTtEtymFUxDrVlnWEePXz8XnW3luDszpd8re9ps6b5lvulholYkbUpYBzoYPXxzXCE6q5G4VexJxPHulha6Os9enLbUhiVWZ9zMH3BFdXtqaPYV79GgJf/N1MxCfqA3Dros/x1L2EYQnhsMdWHKwNlzZ084dlELodpMPuvTeVSfxEZrN/TOuFuBjn0LVnxMPNBA9tRdspt2dgohgqZ3ECQH+zv3RRV1p1mSVUNUb6St1+DeQine9HbwbWyp1AyyL91dhBQSJ4bM0OOvatk8JoQLJINAcIdFa2mmd9Z2gziSTQnGpakQxCcuWXGWwb9dnJeAP73ZMWLONPakymy7GHFEBxf/tDvPz3BEPRRAkqYjJa3Du7Ww1pwtSsVrjFVwFqxp23MhyRMYZbMITroc2mQIUTwcXdZqjBvEGZRT/SkxKbQsUIIiSPMe6wa4p/jH6rI4Vi8xed0ISpRJg+IqCD26SnnnN/IQdSuLGYxpXz/EWkhm7N4dv9N16/9EFwcz+LY9nBG2Iv2DD7vUCsZAe4mX059BlpMYjLOHZTj+8/NuCd3Mcjh4bUvyW+zY06wgBdTcT3XHIeM7NkBnm9OgoJRcVMFJrEzEeO1a9NBodJlgWXSplCeQjRS02yQRmWKuWCHavQDuRmx5KIHZo3u3kuhgX4SBnNGXe0mWZK+8cQOHIljWJJWrSkyhp8iV4cE8/VzsF0iJW5vTtyEBnlgsAV6wbeiEayqERleC3woWp+QLLPgstJeMyvTp8qcAYBoPBZjRJ0HC3qFKaZe+eDCXynh1XI2ROHxdrSwSSfISkH7+pkm6WVcSB5wybuibN2MYT
 bpmwq8n1
 xSQ349cOIEBs5PzuXOLRF7o0mH3dPtlPfF+bKNdSi+VeYNeDAziMxLkYmIhOahpDA/iqhFiVDs0Ufm1mWLL9BajFuCNk6uRlv7s2gWB63Gf/1u3bZMwjAyQLGnEwVT+vBnRFlZVcBQ8CMzZvdm6qOuT4s2azwpOo03qgLK961LEk8rjqxYIuk5IAOp6eXkdPuFKOOyq+HiqklCwRuYih9j1njL4/VHSKGfof0ENMQ91lF+rTuXrSgBKYp0kcLSBHvH9yezEIxinaSqPh1OGvg2dKp8zJKiRnThA88/zbvBxzG7XM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

xswap pages live only in zswap. Without zswap, swapout cannot free the page,
but still takes a swap entry. So the device consumes swap entries without
freeing memory. Fail to create a device when zswap is unavailable.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index cdcbcbaa6d87..cac084bc72d6 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -4439,6 +4439,10 @@ static int xswap_create(int prio)
 	if (prio != DEF_SWAP_PRIO && (prio < 0 || prio > SWAP_FLAG_PRIO_MASK))
 		return -EINVAL;
 
+	/* xswap has no backing store, it relies on zswap. */
+	if (!zswap_is_enabled())
+		return -EOPNOTSUPP;
+
 	si = alloc_swap_info();
 	if (IS_ERR(si))
 		return PTR_ERR(si);
-- 
2.54.0


