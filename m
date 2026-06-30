Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD656C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 01:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B328E6B00C8; Mon, 29 Jun 2026 21:29:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABBE16B00C9; Mon, 29 Jun 2026 21:29:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AB076B00CA; Mon, 29 Jun 2026 21:29:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F9436B00C8
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 21:29:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0109D1A02EC
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:44 +0000 (UTC)
X-FDA: 84934847130.06.4C5A42A
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 0B2F880004
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 01:29:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lfvbKi0x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782782983;
	b=RWkOkejDKCwBEVmXIs177fX0L9YuWZt3ke0uJl49TU+Da2bGOjDgEriB4qpdfUmVHFhR6b
	7W9uQ9bqaTKJnsEwBEoAWVVGUF3oapOlqhSIpGDQq7rJbDcakrkFakH5dfEPOCZKknUA2s
	p/fgFB8ez/WdBUl4k+r4ieMhLJk+lpA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782782983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iNY5ofzw/V67suDlBB0hHUXne2mwxKxzsLsbqE3X2rg=;
	b=5N3RcIcECgYrdtwgN36K0F4Dcyvaf+GP+RyMhClXJkvYhtzQyGuqWXhrQGjjLlcm1nfdzC
	8DwawqkrmQgpou4a3X505ALS32CbPoW3hMzgsMs0sYo8sco1+TCCSO3EXeSMfNTa5rZYMx
	/4UvRb78PhfBJy6+hcP18OdsQT11Uxw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lfvbKi0x;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782782981;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iNY5ofzw/V67suDlBB0hHUXne2mwxKxzsLsbqE3X2rg=;
	b=lfvbKi0x9TPzaRiCQdbbDTLdsj3y5GMKV56KE8V9zh9j+D9H3HMMuUEt1zVj419JR97Ee0
	GLELR45E4eIae4yQkoxM2xCnbbUMaAhSBTBmdm28fhrg/Nd14p9w4tvanBcqU1Q2ug4Tu/
	s13lNao0JM2afRLWiVJ+PLFYhpmL9vQ=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	yingfu.zhou@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/4] memcg: bail out memory.max when memcg is dying
Date: Tue, 30 Jun 2026 09:29:02 +0800
Message-ID: <20260630012909.144372-3-jiayuan.chen@linux.dev>
In-Reply-To: <20260630012909.144372-1-jiayuan.chen@linux.dev>
References: <20260630012909.144372-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0B2F880004
X-Stat-Signature: kqz35exng49nxynhru9q1w45ghunisi9
X-HE-Tag: 1782782982-9880
X-HE-Meta: U2FsdGVkX18uVsRa+zDgbW51Tg8iV9a93Zl+1yJk7Yo3rVj0CYb2RAs4osrOuhcyMLShlKH8SsdqD6CPPyRjha83bJJQE6DqzXEYOk5+5TPkHO7neN+9p3tvfm7V9NjFciPnIZokHY1hiYSXKTFJ6zdy2+aSM1mOkSVxlj7/Vi1xc9TCuAEhFm6i69R1eF/tQ02tnLXoM9H5P27aIhiMbRHpSJVKrwkbxa8l8w04rLQ++wJphNZ66xQwoQ7Slb+xUpau33Nx21E6lG38iigPguo/XkZR4Gwdd1GL2/u7QgObU6hDpGbrdDzIO/CyqBdCa3fP5Iq2pfTHHtHkMpWg04aMchzZozE20F4ZqeLGrsItZy4S3n6Rxow7by98h71b2353sopxTJtPn3JqC/jFmrSMwkaLSGz6zSGvpNENgiRvsAbUlwpEmzuvB/wzL68eKu5lrG3BAInhl7jg2qAaPT3VKY2t6tQ7HU9AAPpHUoepwuI4vKzsxgwTp7icv9Txn6D+cCNlHntoykUUy42uQQ4047ldKJ5yJSONNAT20GVj7V1/FcY+VWF0fw5VeezSNPr0cov6eQMYkc5hhFQ6q0HBpfIX2g5xaI/pVMzuuuSsIirxDVO0xT66vdD3Oe9Fxc/ct0xiehrMG6EXMrAAFpcLkj9ykgKUNqFSpNyTXRIE/H/+9FeaqfzWFpityKBMXNfXrR8iWE/SDYd4UNZgkL2UTxEya7mFJfsNEiWMmpPEZ1l3gjg2H1ykwfEbYNar0PINFc5iDedRmcJ0uy9VjtEZLcINjvHytswh9c2qR1AAPZArnk895vVECioQI/RL7YtAEFyqsiut9v/P4ETeFLyVCTDqRKdXR3CQnd3S5yR7tr+F89x8Mp4xtcTS+6JHV7RypsekiHF9+E0BNKHeajh1tNblHhu0pwfP1zVBdMF6nrlTZfd3J5TjyqMDLFH1n6EufdAbyUGN98rxrCt
 rHlCydJd
 ocLIkd3MKLJt1F77l4xnGCrtlXZKYI7Av54yEWvjFYhIjVUFgKA2AHF//sNVxN0iNxn4GkQ5QgiTBUvjyjoqPZXyaiITsZL7d8dmqEU1I1BG2zVekdgPlBZB68IY3EUZb3kbMkkFl7IbqiJzC5SDd4CYUqJ8KPLVTxoISuOCy+tdDFn+h1JcL8r6vUo+nna8eWXL7UQ/c6SjYulvG94Bix/lTO4VFDmKWB8TcubwbV+P6Gbo1mm/0F5qX9FbSr3QG7w7NtRwdyXl99hSGxwUp324q2DZ3bD8ZSLp+dV02J2oPzl8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

memory.max has the same high-latency reclaim loop as memory.high, and
may additionally invoke the OOM killer on a cgroup that is already going
away, further delaying its removal.

Mitigate this by bailing out of the loop once memcg_is_dying().

Reported-by: Zhou Yingfu <yingfu.zhou@shopee.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index eca9f6091980..ad5f6dfdc021 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4848,6 +4848,9 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		if (signal_pending(current))
 			break;
 
+		if (memcg_is_dying(memcg))
+			break;
+
 		if (!drained) {
 			drain_all_stock(memcg);
 			drained = true;
-- 
2.43.0


