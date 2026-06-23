Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A4BCDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 23:16:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 061C36B0088; Tue, 23 Jun 2026 19:16:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0138B6B008A; Tue, 23 Jun 2026 19:16:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6C0A6B008C; Tue, 23 Jun 2026 19:16:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE07F6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:16:48 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1783B401C1
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:48 +0000 (UTC)
X-FDA: 84912739296.26.0C1D380
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7C637A000E
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ar7WtGLz;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782256606;
	b=QUKsLv7RjgH4qzB+grmrq2DsP4bB9hm2s+/62NVxEO3LcM8WDXQZp/4l/rJcBQ17R3jIAX
	uCeqRPXZk30u+Zn/np9WBGmFnfSiHYlthBUDv9rq3pKYRDfgDZoBBTtnSHPnGw7OaRR0v3
	POIMbYt5PIA85m4ZDIvTxVo/UCJN16E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782256606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/mBkNkspwnl0TWFRqFnXvj0MUzFsNuEOmr7fCwDzmCc=;
	b=Gw/pGdnyCWzfy9B4ETXfmR7fybZeyJqKeLVYnSuH7jPoXsWwswDgkBNL3cvBrUFPP7Ncuh
	QLysuQjJxWdkW0OSrjUPlDgk5n3bnIwM2VNQ6XdyC6xF6o459HiQdYHqyByUnB0CBjkcaq
	OPS6Dy05KuCsXRwVPPt65DQAtIjN+hU=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Ar7WtGLz;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 573E6433A6;
	Tue, 23 Jun 2026 23:16:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCED31F000E9;
	Tue, 23 Jun 2026 23:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782256605;
	bh=/mBkNkspwnl0TWFRqFnXvj0MUzFsNuEOmr7fCwDzmCc=;
	h=From:To:Cc:Subject:Date;
	b=Ar7WtGLz95wUxCr24uMlO9CXa4A91PAbdsp20PUqQtifbtts8scECRMP6+4cq7S4R
	 9wYrH5mQWmrsU9A6B/oJNj+S/pC2kcWBgtUHvQUxaX2NxlwCi9n6vY9PBB2USaBk9r
	 qYNyALM7YpIrb2i2ueCdHI0PYFSAuLXbSjrCkk8XjjNbk65bUnEqPyd17+AnfDFVyj
	 AiSfn/TlV1koORKe+wHGweDKqnAknPH7dfEB+fjfKRgNUNNduO2V3zZ3Cg7RdLgfrL
	 m/G5OBR51USrR2XxSl4x64R0t1XOgiWustzkCROhO4Jlq2eyHwvcL6lh2M4Zm0paeu
	 /2HQ8TuZyAf/A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baoquan.he@linux.dev,
	chrisl@kernel.org,
	david@kernel.org,
	jp.kobryn@linux.dev,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	youngjun.park@lge.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 0/4] mm: drop redundant lru_add_drain in anon folio reuse paths
Date: Wed, 24 Jun 2026 07:16:31 +0800
Message-Id: <20260623231635.43086-1-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: trger9kijpg1hsg68ujex4af1xw1oxje
X-Rspamd-Queue-Id: 7C637A000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782256606-134082
X-HE-Meta: U2FsdGVkX18mPNPGTElQIimukukwQdKCY1KQQjhViVh9Vhrv0+oERCH53MjqZ6fiGymr5DNyS7oC/o3QTETIShkLhF89nlTlNS1jz0/QjijhOMJUNrzsT3I80o+6/oAFZD4mI2Ic7VfWb51p2rJx5PFDQWf7nVUd63skrzpc0iuknL/ELnb4v5w4Q+OVVRqTYebQhMViQ1CyNdEOMtYk+oZJvSQ4F7/kphSS0dLNDbomiBRDqX+gaKev00WZCN+OS+Qg9pumkL/mlWuWZOJp/Le+aAQ/MsdeKIozcYUp2369QJ9yQ+ipyWR+tkJ+tZ8q0hv8nb7p+nIvUU6QUTC0L8CU97THzivDAfn2858nC9J5+JlRahZA3LBiL48tkJp5Z+y62U9nHS8aNiJkzCEAyeTlFlbwCJivldukdKJloppIDNIm8lo3h32rLZs/SK1inag6MqWFw8c8piTj/F3a7jR4VvJmdbN9UCytLFbmefB6nwEnT9ZvFVyTUwcfmvc/JqGgNYb0YWAvt8ka+TvI+kLaP/x/8fGNerS/qe8/M/B6EcuFVgObXihGrU5/gSCU4HsxW+8yPJ9a+5R63hUOe2UXi7TOoc10imGklVZFza9FihYLjmlLGmqweWH+rVCH4b5ohfp0h7OgMfd1t33OHJOmCJrB2k1Hjcs6j28Fl0Q7yjavdr32+7Xfco6LIFIDQPPgyTn5uT8SaKv74vsUUdeBC4nEDGhZXmEkIj5FiLoCt/6VE+Y0z8S7IuV8s3l8Rg05yIM+HhvH1gOOKcxcszvOxMrMTxbLpR9Eq6TURL5LlBeBZ1cVQrO9MO0HLuMkKocMAvdEtcq0TrA0q6ucSF06nDW+ieYd3TTQTT7WJcMxqmJPDpYoYp/x2LVWZ5BylmMxGg2Mcla/zPmk6Yhnp2JmDbZNXNAPgiZ8YEbJAtgBPuzkCZ2rHTDdzk1PiAppulwlSe150ipQPIFgFE+
 FJWmeaJv
 2f1/BDQXYHRQpSnehay7B8OO6dm6MdNkkFjGShm3yB8rlJZg0KUGgEDx79yiGl/7QDa1+tjtNp6s89ab3MwY9MTsXD4lyvrixTPhzZWsARr0n1smBj7Ow+1todvSzTh8+EbsdRecbG1htG1am9Aoz9ZpHivWXpgmAgN7516j0kvM7c09zjFmQg93AM4I4l6LFEAHKIGmwhr9fvzO/KWDU3sMYKJJ0/LeBe3ylXOi70rSGHca0lrspgODGyVkfHR5KIpqH0LSZu/TzOpZepgmFlbg4HoIqP8ZMmqMo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We are doing a large number of redundant lru_add_drain() calls in
both wp_can_reuse_anon_folio() and do_swap_page(), leading to LRU
lock contention and unnecessary overhead.

In wp_can_reuse_anon_folio(), we can check the refcount against the
lru_cache before deciding to drain. In do_swap_page(), the drain is
now entirely redundant after Kairui's work to route SYNC I/O through
the swapcache in the same way as ASYNC I/O.

Build the kernel within a 1GB memcg using 20 threads with zRAM swap.
The number of lru_add_drain() calls is reduced from 276,787 to
230,283, while sys time decreases slightly from 3m40.125s to
3m37.128s.

Build the kernel within an 800MB memcg using 20 threads with zRAM
swap. The number of lru_add_drain() calls is reduced from 796,661 to
537,262, while sys time decreases slightly from 6m25.981s to
6m22.678s.

-v2:
 * collect the reviewed-by and acked-by tags from Usama, Baoquan,
   Shakeel, Kairui, thanks!
 * add patch4 to free swapcache for non-LRU folios, as suggested
   by Kairui, thanks!

-RFC:
 https://lore.kernel.org/linux-mm/20260611105124.98668-1-baohua@kernel.org/ 

Barry Song (Xiaomi) (4):
  mm: avoid unnecessary lru drain for wp_can_reuse_anon_folio()
  mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
  mm: entirely remove lru_add_drain in do_swap_page
  mm: try to free swapcache for non-LRU folios

 mm/memory.c | 30 +++++++++++++-----------------
 1 file changed, 13 insertions(+), 17 deletions(-)

-- 
2.39.3 (Apple Git-146)


