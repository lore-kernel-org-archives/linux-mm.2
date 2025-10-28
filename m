Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4604ECCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2E3B8015D; Tue, 28 Oct 2025 10:04:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DDDB8013F; Tue, 28 Oct 2025 10:04:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CCD58015D; Tue, 28 Oct 2025 10:04:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 781638013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:04:08 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 25ECF13B0DC
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:08 +0000 (UTC)
X-FDA: 84047692176.16.A38A8FF
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf09.hostedemail.com (Postfix) with ESMTP id 41EC8140004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:05 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pWzdGFK9;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d2EOOSlZh8oRwtRfQtnzgpJLzbPe1acyr5pcLzwWU68=;
	b=OpxMcTVgwJQE7bCOsOWHj17HemIZQu55Mktfw35F/7opGDt8BkAwF9qbG633fek2m7RyXz
	8RFEMCy4JN1+p1TXd06zFcWSK2R30cdbL+/NPOr66IngqKQZ3dP+gQYOAbPX0tJFCtqgyz
	TSswmat2XWSYH+/D8xrp0H76DBlTc0Y=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pWzdGFK9;
	spf=pass (imf09.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660246; a=rsa-sha256;
	cv=none;
	b=KIHgc8CW0N25rUa2Q1AqHT40cv9VuFd8cEN33SWRG3ikTJUmUYU3jPEqWAv9aJwzAfSuFB
	nVuHEFhTXwj+z8DsTSDg4voKD/KQbT0/WwkvX4vQ7qEoxiWa7H7ZksLWmFLV9EhkGRSuzM
	C1QZtNNYVWaRllUbgrqOJZRJombo7jY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d2EOOSlZh8oRwtRfQtnzgpJLzbPe1acyr5pcLzwWU68=;
	b=pWzdGFK9jp5/gKWOoMPYfN/1zgwDvyk5R6UyUH2ocXAJcYLiJkqMhI+d2hIraioYk881Hw
	7rzlQkLG3uO06lrW3XshXYI5VB2JcP+sh5murHeNw1f62HR7cktjcNoiJHB7FiwL0hTSM1
	7bK+5TfatVR2jrRm9JSuNcGrGdlqOCQ=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 17/26] mm: workingset: prevent lruvec release in workingset_refault()
Date: Tue, 28 Oct 2025 21:58:30 +0800
Message-ID: <7d58f7f924961bc9ce386b3101448a49d7aa1daa.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: er8zet795axtiz1ogdep96mngxmi6upz
X-Rspamd-Queue-Id: 41EC8140004
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761660245-249827
X-HE-Meta: U2FsdGVkX1/2/TZBEUgrcX7At1+Vvo30oIJvpJ6WYy2c/g8KiUrMKc0u1SifrZbSh0qqKeb74Qz6u7SY/FjnpMAfZjYkXvQDqNFmdeGGv29cJdjBOc7iQKol/ysJS5HrH+6i+djPjQWyyDJkZTwuswuJHFTx5sn3HFVXMztdWVQDDYslmPWYcM2zD/PCYv5y9AGlbCQBBOBoGUYt+Lp2T03Ed1KZv7o6LAr48qwEkpx0KRVcuysl3Cj7riO57WrTOpv4oMZ4mkoVR10uw2kTlHVcP6SoCFfNVMEQwpB2i7BMS8dg58Z01eBh34tpVbc8a3ydagVXxIZ/uYujx1r1ykB8rLKzGH4g8t2Ayuf+9bIOSFWJwk3vp8mA+emZyzgya1aL2mHgZsM5PE1AtpQVMNbLGMOcahAT1zUGCJkdqtrMC2URVV8CrIe1TiWEgfJZEb63Q91cKwbmIImQmCijo/IJea+pNZuWr1fRWqXYHCbOwtTonLTXAXwsBmVLjkp5ria64lU8fI6mVeKWoUJDwpN45D2FwfP3VblkRWA4L1pbnlb0rITZXi5Q3frVCmJAOHnqdpbwMRQQzcTAkckqEJmf0DPYBMzV9N60YPyweALdmY/x0glLxF42fVeNkLJybZJW+8rFvbGJAkYX/jD6bvei6EJQmncM2X6TyKnqANl9Tof2hYS8c7hal1MYFDhJdOg17byf70DpkoRo+JJskLP4RGhqoREDGWjVpL0Z+tdgF065UyiCp8fzMUvSu2K/jS8LGN9yWc0va/c/sUi6ZPw810VicKIyKgvOzCEVlozmQ86i/yFxJckyo/g9nU5Y9dvWM8hGob+dSFjL7yf8ocQDh4UaVsaUshuEgMXCTTm7j0lNozUCdCeAxoLKHrimW8Gmz0Px3oliGAX9dkd0Ql+n6eakp2CbYjbr0REFCXkIqxY+IadjgnJCjfC3k7l5ra5Cx0NxStMq7A/JxYT
 DbrgxgEa
 2xmMzlBEh5MyF9DPoit8OEI6xZ0WBbEDfEMEf5oTSp87LEDuzjlXaDsI6pXKmP7yZy475jZHFea/3zaFvLz/YANh9rwOIfCr+Y6g63lx0MdChzreU4wnAPKvG1zPs8b9Vr6uyvQwCeT4ZvN/NiNkWZp1eJ56347PFyzt/75gL86D9RXsYulIQF7iSUY2icEelYuXi7DOW1ENh5ftp3nvbR2eH2sYErtWt7tV570fOfHkVXa9mXLuPS5K3vVgYdIxp2NAKJazdQCsKToU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_refault().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index c4d21c15bad51..a69cc7bf9246d 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -560,11 +560,12 @@ void workingset_refault(struct folio *folio, void *shadow)
 	 * locked to guarantee folio_memcg() stability throughout.
 	 */
 	nr = folio_nr_pages(folio);
+	rcu_read_lock();
 	lruvec = folio_lruvec(folio);
 	mod_lruvec_state(lruvec, WORKINGSET_REFAULT_BASE + file, nr);
 
 	if (!workingset_test_recent(shadow, file, &workingset, true))
-		return;
+		goto out;
 
 	folio_set_active(folio);
 	workingset_age_nonresident(lruvec, nr);
@@ -580,6 +581,8 @@ void workingset_refault(struct folio *folio, void *shadow)
 		lru_note_cost_refault(folio);
 		mod_lruvec_state(lruvec, WORKINGSET_RESTORE_BASE + file, nr);
 	}
+out:
+	rcu_read_unlock();
 }
 
 /**
-- 
2.20.1


