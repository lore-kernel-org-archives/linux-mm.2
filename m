Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 60DE8606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 22:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=j2p2p/pm
Received: by kanga.kvack.org (Postfix)
	id 805496B09E6; Thu, 22 Oct 2026 18:03:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7DB7F6B09E7; Thu, 22 Oct 2026 18:03:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A2A86B09E8; Thu, 22 Oct 2026 18:03:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E86B6B09E6
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 18:03:13 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CD3181602E4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:12 +0000 (UTC)
X-FDA: 85351638624.22.C523912
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3E89B1C000C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 22:03:11 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j2p2p/pm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792706591;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6rnjSAKXETk7IX9Iz0xmxItZgkiiI1JWLFVu97pY++w=;
	b=R9HSVJuqqOB6y3xcewLLrNnwcmC0mb/D0spdoB1dx5dRMpXZbaoFgcuectUk3dvyNSgGE7
	OLUxSUNJczhV5+T0+Z0tqXbA87heR1Pc4EnzXbTkOA77B2rHDy7IM8OG+zQ3vESe9va4GJ
	6yr1p4X+kCL9XgBQl0Et/bc3ejaWhI0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="j2p2p/pm";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792706591;
	b=64U6vMuF+xvqyy67GNYnzTRCutwSMTk5kerbvOx2aFkdpm7MX33mBfaundPO/iI3cMb+CZ
	/JT26HWcOAkIOeNYED23be7NXq1fN2ExwilLsHNNm3mys97dSSjsvd0fg+5/6TRo3vL5YZ
	YLUCFVAGmWn1PnVhfmmtdLW4LxMDIwg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D182E6022E;
	Thu, 22 Oct 2026 22:03:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC181F01829;
	Thu, 22 Oct 2026 22:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792706590;
	bh=6rnjSAKXETk7IX9Iz0xmxItZgkiiI1JWLFVu97pY++w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j2p2p/pmAqoVZ9r4zJMNX8O3DdOIzV9h7PhopbCDJwq1qoaD4iCS+CfXSKD3vtVTj
	 JceEjLIXTrqQwfGz7D6OV2HQLza5sBt/admhX8WvGgvwRKU5sfwq0TXG/vAr/IDt4W
	 WOwwwb6vKeOL2lM3wnKJOsJg3NKKVA9a8g1n1nhlrcufg/HWcggaQYwJBbVOPimOXT
	 YmwqVVcfqhYAYqFEFRHuQboNPPy+//tTTii//TlKPYnsD6aUlQ6wRqF0b/CmIa2Xc/
	 NlyVIsNLZK/5GrFzcaKzJpGLhPnd88AjqbVdrW81DqoaV+NlP9juzpINfC0V2z2U/Z
	 c7y/W0QErFFQA==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: hui.zhu@linux.dev,
	axelrasmussen@google.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	david@kernel.org,
	hannes@cmpxchg.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	weixugc@google.com,
	yuanchu@google.com,
	zhuhui@kylinos.cn,
	baoquan.he@linux.dev,
	liuxiang.277@bytedance.com,
	wangzicheng@honor.com,
	lianux.mm@gmail.com,
	kasong@tencent.com,
	liam@infradead.org,
	surenb@google.com,
	mhocko@suse.com,
	rppt@kernel.org,
	zhangbo56@xiaomi.com,
	lyugaofei@xiaomi.com,
	ridong.chen@linux.dev,
	kunwu.chan@gmail.com
Subject: [RFC PATCH v5 11/14] mm/mglru: Reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Fri, 23 Oct 2026 06:02:00 +0800
Message-Id: <20261022220203.91911-12-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261022220203.91911-1-baohua@kernel.org>
References: <20261022220203.91911-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3E89B1C000C
X-Stat-Signature: ha7n87o7dwdn8u3tcq9f8cdopw4j8e35
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792706591-392308
X-HE-Meta: U2FsdGVkX1/cZa6k/xR8E87Ez+DPzIuV0sdxm2dKzG4ngNu14qsfYhFk3hxnpgRNbp2a+p26/IpapKkQOIo/R20Ba0ENrwIRbggyAmF0fClJETn1rkgmYfc2Z5oVaCHpMI3dqrs82YdhaYSO0ArVlpquzzKqyg8YS3tqjmh5yib5lJeqvapTqvj+Idj8OvfrhnfGtR+fD+ij1XXlJ+98JQZ5mUkRu9qSJj3UYYiA9lVbPPgqP0JUajhsjOEwKxhgAlqpfmTiilpcsF9oKoaJaau8hZb7+BVkVdvU7hIySeU9U5dB2f2osm3DHFC4ImBS2FuIakeaiipFDVnVnxZ7MkN915J7jKkm9LeS3Qe/jLBXJw5Hv5PkR71aOXzrj46jjNKm/ETEsMty+WPXurFKwJQwEvMwT4ZNdbEX5QnQCxFIC16XAXZ1VrUYKf9Ifh1M7guOycjofd76IjnXVJbndjzKsVWtLmnh9E74lHqjL51e9m+9FmTf3J9Jilzs4WQWmyA0xxWQA0CAhOt2v02O0xhkrjSzYmxmB/4DEzF/V2tfKchnxXonwIjervR7O5MljUHO6yInkxlkodAfJ1EoM2KB8tFfMctZ8RzMsuKZ5QVMx/4odZxuIi8bgzPZ65l9Fu1QUJAhDygbxp3wjzntZaCC+zRXEAzddrWfuCxKw4XigdkwFcfZJNcudZkk7NhqQ2E7W6dK+A0WGAvtYV1zSp05KNzOV7jr/48jFH2AUX0kkM0hW/yZbtZge4GQPPoHwM1pinCPoWOhYjn2u4dhlKRqjdb75rIguR9lFHjbcePHDsjD+QZWmCba+dcCJjt3MdT0e+CnPRKmMRhdTp8BsY7zRACIjyh2WPgrQhQ/vmX7xCGBeNDQTKLX8RraRvXvIeU37N5hAOkHfVzDhTbPQ/mDQa4rtzoOosEjv/E8grXTeViXorDAfJzN2UhKDa4YCEY/3R8BlsxxlrEpO3V
 JvtVOcMp
 Wk01RxsGK0awpfujpXWiG3L4NN8aMB5xWsWvJeZoEHfRKQivm6uht/XKF6EyFelI22WE4ULF84EO7yEtAS2A/pOFs45AckNVMbYHiXKGG9bK64NWZ4Nv8P36ybaZd/pZidr2IhOfLWluh8gpCNq4qNrBH9dhJC6eFmx4OfGkYCKe2yKp5/Nz8TilZW3h8gXi1dU7Xhiwu1G1LFPGM3kc1tIswiB7cMIvQKFJPZgLuUiyHKBgbWanRs1lumsE1cjf8mNo5AVpkUi9JiMqHEzVtUaD3aEYy4AABCaERGxQMSBlrdvhf011keKsnk/grJfuAXkXH2d23TGHxyv9BScoU1xyVzhDKDNzOJHN+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Reduce the number of folios moved from the oldest generation to the
second-oldest generation in each batch. This shortens the time the
lruvec lock is held, allowing concurrent LRU operations to make
progress and significantly reducing LRU lock contention.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index e8eeeeb76282..555359cc0368 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4051,7 +4051,7 @@ static inline void flush_lru_batch(struct list_head *head, struct list_head **ba
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-- 
2.34.1


