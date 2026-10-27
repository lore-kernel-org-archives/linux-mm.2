Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFC73606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 02:21:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kgpP2nsf
Received: by kanga.kvack.org (Postfix)
	id C0D136B05BB; Mon, 26 Oct 2026 22:21:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCAB6B05BC; Mon, 26 Oct 2026 22:21:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAC366B05BD; Mon, 26 Oct 2026 22:21:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89B546B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:21:13 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11292808E9
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:21:13 +0000 (UTC)
X-FDA: 85366804026.12.CC8A226
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0A3B91A0009
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 02:21:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgpP2nsf;
	spf=pass (imf19.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793067671;
	b=q6HUqXYIjbe4KTta4ziiQRWz445wEeeMFiwwNs1gtWNiMESCQovhALcgBT64dd2Lp1bw3C
	XWdFY4fCeBx/RBShyuXW//LVnvSdtnEdu7y1WQVAexYDq13cgaDWV/ju+MXw/Jaz0ug+jf
	8ug9GAF+NiNDz/sNHmV+VSRYwnngxhU=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kgpP2nsf;
	spf=pass (imf19.hostedemail.com: domain of devnull+bingfangguo.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+bingfangguo.tencent.com@kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793067671;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1S3SP2ZqMnMjtsDJBtDJ6IKHd+fOm8rQneXFfbk3qTI=;
	b=5fogF2N9g1sxRtZKzC87OSVH8VWhpFubY4tkLF9GXdZrWrxekR4iMVsGJNWLp/jG6TRqhX
	rwcbg7Q8Bc4xep1X0ATIeRNCUyrFDOZS0A7T8a6/iys/GdjBuwjzWtWE5PqDQCmkv32Qsw
	ZM0L+Os8hYm+W+ngEFwuKo2tJHb1Yz4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 57F20601F0;
	Tue, 27 Oct 2026 02:21:10 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793067670;
	b=Yn75JoEdsfDJutaq4Q/j66G0BwtCZv33x1dfRLSHzL4DgqYPUAT2rLVUjyyO5/QM451H
	 sFc0aAXzHMkfnoZlckvk+un+xvPlPX00thDmlfn6BUcBTakve2TVbPadxLMOjoCK8I1D9
	 3JxDDy3qqYYvs44g//jCU7Tm20vcDhkfAkGkzpoL0bVy6N+k/Oh7gogJuiZ+0NZ8s/0xZ
	 HVWjVUITfTNu4YpAIPh6euiHrVMY+tAUE88cxRW34bdKjuiCdcpWW4/FjYLTUrW/AVoe0
	 /whXtuC3MSD54P4tniMwTDbOLylK0wUGCwAJxCp/Crm6PaV8Y3falHhOXTdC7h68xUA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793067670;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:X-B4-Tracking:X-Change-ID:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=1S3SP2ZqMnMjtsDJBtDJ6IKHd+fOm8rQneXFfbk3qTI=;
	b=W6Ju2wtT+ggz56Dwj7ZmLyFhh/VVyDeu98xyjdcRp/NdFDRrKOdNyo3r/pYnfX+BmPhI
	 nj0N2hUnrL1ixfwfA82Xy/3LnAgCl3XWLB8o7y5tkPZVrjqyjg3thGE7ZJwMgA7aNQs74
	 kg6Nj7cMUfuYJOsrNpnHjUeWFeq8j3cwHshkY0DmDL0JjnEbEHR/7iOqDeArB1vjhbxiU
	 H+18QQZ1PgJ/uKb02lHeTdhaxQmDWqOrfSVcooZJXA8VedUV+4uAXbhoZ5yUKyyeumxEe
	 gojtWaj4spMt+s3begw+qUhE40JSSO63UAYUcx7k1Z1eEZuuikh1wdpxns1UHVAulqQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 959951F01825;
	Tue, 27 Oct 2026 02:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793067670;
	bh=1S3SP2ZqMnMjtsDJBtDJ6IKHd+fOm8rQneXFfbk3qTI=;
	h=From:Date:Subject:To:Cc:Reply-To;
	b=kgpP2nsfxHbEllUBVOWGvcPG19nmit9KbS7dfO9G2iQ14UvaimbCZVHeZnOyPw4QS
	 nu13L0szVWrP3WBCRnrws185HmcAQ1S40U0wr204RPnT6ktasOkAhHA2iKF4Ga/d1L
	 sdiNpY475cuFZzCqn/r/83yR+x4xgw8YOyNZ1R1wm66uWx4mnCp7x0/qXzAFkut0MN
	 /xzLSIbw7m2OhxpZYiEbH8+BXhcqEa5F2/PqywbOxKVFBPK5DxvoYN7+frEvwc6q8z
	 VwULMpGygl3JUMCtKIEYZzoE58tHslxYj54uNZ6YR6fKJiJ8KWY0h2/te+qfhom/F0
	 tEe2DeL38JQZA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 0DE4B44F45;
	Tue, 27 Oct 2026 02:21:09 +0000 (UTC)
From: Bingfang Guo via B4 Relay <devnull+bingfangguo.tencent.com@kernel.org>
Date: Tue, 27 Oct 2026 10:21:08 +0800
Subject: [PATCH] mm/mglru: skip oom killing for high order allocs in kswapd
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261027-fix-mglru-kswapd-age-v1-1-b1ffdec4ae52@tencent.com>
X-B4-Tracking: v=1; b=H4sIAJMK4GoC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDINZNy6zQzU3PKSrVzS4uTyxI0U0EqrG0MLY0MDM0STY3MVMCai0oSgW
 qAxsbHQvhF5cmZaUml4DMUqqtBQCBaHKzeAAAAA==
X-Change-ID: 20261026-fix-mglru-kswapd-age-98390614c746
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yu Zhao <yuzhao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Bingfang Guo <bingfangguo@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793067668; l=2033;
 i=bingfangguo@tencent.com; s=20260812; h=from:subject:message-id;
 bh=+NHgwZPSL4lsn3SUUTmSyqpRl3Ciw1JrL46ewddx38Q=;
 b=jnw8LXfvvz+KGsE6wZisVj9vHnHVOxP2bE4RM+sv7KPH4LTBMws81Qrt3RYHmK//t2koHb3eQ
 jSlAa4Q+v6VAc8lBCHD+G0R009PadeosKyjVND3NfHj0BEYipQa1Otw
X-Developer-Key: i=bingfangguo@tencent.com; a=ed25519;
 pk=q7u9S7d5e7VijWrYF9O+vv9/XvqWduVGtwGtuCObAHE=
X-Endpoint-Received: by B4 Relay for bingfangguo@tencent.com/20260812 with
 auth_id=942
X-Original-From: Bingfang Guo <bingfangguo@tencent.com>
Reply-To: bingfangguo@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A3B91A0009
X-Stat-Signature: ngbzujinrsqzpz8xd3c7ymsf1u3a565u
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793067670-991020
X-HE-Meta: U2FsdGVkX1/uMe4+9EdBjBkrP6Zpic7nEzsZ2hIWacTxc3/GNUulnv6znWFpU+/UUjYWF/D3XG5u+TaujLIkEuGt4um7n11Bx0vbQYi3fz9qbWpOTomjmR+gB4LYnMBVcLcepXGYTRWOLddbnri74W0bxt8RDSoxLfmn7YExkqiOYaitrjnElo6WjJAC+20xwFIq2yv/6EafLHx/W1i51UVCVJVEqBeoCCeuJuDqca3UjuXX6QHrJeS+IikDu/4UA0ZWvXSSpuitobopg7T8yj7Bh3X9PT7YMzglf1nKvOUPNyAhqEmj1L2dLlL8hm9C1b1fkLaTnzTpMg+ddpDldw+906r3qu0XiorVpXZGuJdCLIk0VEkKSgZIpHLpIlxo1m43bSTXuV5DEetekCdIuJYy1OeX/vtuuRp52OvVUBwTNh4DV8ci6WH2VbRkorqiqNdnpPZBCWy1PUb66QP/lBFvhajnDGivdn8A/gs6YKX7hyBOGGzTxMSJJwBrFrM/jfqneWzUv5wyCDKHAILvF1nhkm42Pzuvt6rSaULfbdUog+YsuYj6lIA0bbrHHhY+TAjqOUWmlPjN0VOtD63sg587ZROj402ifKFBEFwI6o4bxzhkBZ/8ZLLE4yS/X8yu2TtHvWDJL2XypPSzvXxTHZoIX5kU6QMYbas2ryOx1+PufRXHuy2si6YMpm927QLCR5H3mwxE1IiTWuccDWZqVVb57V9BtwC+dkMjQmjI+YYM5EaZaCy3Wx29kZkjjewm9u3YAY1PhT875JEud+EKpxRZAxDdaHhjnQGfC8iwz5Pu92ZJaOD6Td0+g978YQoQDoZEhAjOK/34z0XPwNezOD2kNAo0mMszLREMt97HtcDV2/qKb67jAvZIykvdsnZzrYtW5qHMFJ1s3pDOHoc2sJ6VW2lhQyvb3GdLme/U2gpTrWmpKgS7ELi1zVwkW0pFpw8aQT5M7L4w5hMd+QW
 sOo6EUrQ
 Ab5mac3lG6HdMP45nSlgDyn28ua1iQMBB19M6VRlyMnvdyq+6Jz33siECoYzJ+maBmx9xj4i9UTwjlY0/dHjmsELwuoiXonsTL6qi+5Bqhat9q2yBd8eHaKIZDTte1jbjlngMVqDKgX7FfzFTb0F+ViWV9wwBJhxmDyJVYU6BdoOWAyqZ6KORzxsOp/6LTUjhngy3H4nK2uM4NpH57YCfV4Q38P4zOJD2tO3tVXmGWyQPGdNaqQUaiyTFi9uo505SEDVCdewuhtCriBuSkuCHJCO/HalYp7b1MjPrPX5gVTTGfiWPNsREiMnVYfXvjHC2C0Fzma6TDkmggPVKk7onBlNLAvCa+UEUzXzRz1E7+XI2gDwIP3lBsxtJJ0iJlDjG4VgZW+FSCLMj1m1LL+GPPKAqY0aRdQfcJ6iCMhHVK3ZHzOqUCxXtoTnfe8pr0saQeCqP1bgUFSo0RuNBDwI1ukFF5ydYW/rNvVLUOaSrqHcysEkuxTmG0yq1823EKPLSS7BZkFhp/qAWYP4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Bingfang Guo <bingfangguo@tencent.com>

We observed that when MGLRU min_ttl is set and the system is highly
fragmented, high order allocations (e.g. order == 9) will fail and wake
up kswapd. It can not make any progress, while pushing generations of
memcgs so that they all end up younger than min_ttl_ms, repeatedly
triggering the OOM killer in lru_gen_age_node(). Then the whole process
repeats until all processes are killed and the kernel panics.

Fix this by skipping OOM killer invocations in lru_gen_age_node() for
sc->order > PAGE_ALLOC_COSTLY_ORDER, which is also what the normal
allocation path will do, to fail high order allocations without OOM
killing.

==== Testing ====

Tested on a VM with 6 cores and 6GiB of memory, HZ=1000, MGLRU enabled,
min_ttl_ms set to 1000, and a workload that fragments the memory then
allocates 2M pages.

Without the patch, kswapd kills all processes and panics the system even
with plenty of memory available. With the patch, allocations fail but
the system remains stable.

Fixes: 30d77b7eef019 ("mm/mglru: fix ineffective protection calculation")
Signed-off-by: Bingfang Guo <bingfangguo@tencent.com>
---
 mm/vmscan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 9959ca158ce83..b32777468ead8 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4407,6 +4407,12 @@ static void lru_gen_age_node(struct pglist_data *pgdat, struct scan_control *sc)
 			reclaimable = lruvec_is_reclaimable(lruvec, sc, min_ttl);
 	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)));
 
+	/*
+	 * OOM killing won't help high order allocations. Skip and let them fail.
+	 */
+	if (sc->order > PAGE_ALLOC_COSTLY_ORDER)
+		return;
+
 	/*
 	 * The main goal is to OOM kill if every generation from all memcgs is
 	 * younger than min_ttl. However, another possibility is all memcgs are

---
base-commit: 39274b454e9993cea319f4ac342a8082a9ee1730
change-id: 20261026-fix-mglru-kswapd-age-98390614c746

Best regards,
--  
Bingfang Guo <bingfangguo@tencent.com>



