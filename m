Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD05606A33C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 13:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YafxSfe5
Received: by kanga.kvack.org (Postfix)
	id DDC546B05C0; Wed,  4 Nov 2026 08:02:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB37F6B05C1; Wed,  4 Nov 2026 08:02:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C54CE6B05C2; Wed,  4 Nov 2026 08:02:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 97E186B05C0
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 08:02:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 324C140724
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:28 +0000 (UTC)
X-FDA: 85397450376.29.3A2F072
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 2805940018
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:02:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YafxSfe5;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793797346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R5z5YvwsAVG0TIHGlZc17HJ/f1VSVEW4yJDbx1J4Pa8=;
	b=NhmS14G834cbtShq1rUWtLvunmvcJ3SfBr1230Zi4N7g/1krLycNMFJYr9Kr8nmSbYbEl/
	aVQ9px41pynOceAorNBndMnagblHJpUDPQ84bnvVK8zVOsFmvH0hEaqHaQbBjFkqOGSLsv
	2vjpydiOxhibhlK4L6vQnIbyekmzNpc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YafxSfe5;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793797346;
	b=Iv5Mo/VfUpnex5oiD1Z7QcPwaJ1SngKnpO5IWQ9Tw3CHW3W25ckGTxLHJvaivAB+2ffgs4
	a00Vqs+IwTUWR5WqYQ7+ELlqm9xs7ZSJPh2XGAw3ylS6kO4n2lbiXCKqTSwJKzKO/1uXal
	dDuWBMcOSiBhu/EAm2wkjiKJW5y3Pf0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BE5B44818;
	Wed,  4 Nov 2026 13:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 928EC1F00A02;
	Wed,  4 Nov 2026 13:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793797345;
	bh=R5z5YvwsAVG0TIHGlZc17HJ/f1VSVEW4yJDbx1J4Pa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YafxSfe5cHMiR4HZ7bDZ4TnFWBkD6wwDAaiZV9Lj8Pjv57z5waB6COZbkSjU8kWIr
	 PgOQik9J9LV2aHfumk++B+yTkchSn3bCy3KbDBeDiNZ4ruKx1sKOfGNEHVxOLJxlV0
	 WWdfYmN+sF3+Hutm+JXYzUuyAuPXUaUDqjG58zMRsiVGk7Chj+RxaEIzWzviKtlndU
	 Lnd+gI/QBsBjfKivBaunXYXalmQ7Ds3tR3ifbSyR+afabizjNeVnKyoBdluHE9HqkK
	 EVtAy4V4sg9MJzKS8UeYutlnkybQ1ri65lA83//mjJ7EQ3z+ddizBBr4V8aY7L4isx
	 89Kj5+3G1Ct7g==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.ams.internal (Postfix) with ESMTP id 71C021980054;
	Wed,  4 Nov 2026 08:02:17 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Wed, 04 Nov 2026 08:02:21 -0500
X-ME-Sender: <xms:2CzranS2EpKURin0G4hnjEcA-XIYjizqdzj1L34C-iYhHgwjZFmlvA>
    <xme:2CzrauD6sINbifwl_EL7N6fatl-EwvW6Iz2uzGPTga-A4Kh8qaMGGrCK3veFDsFZn
    x_Q8gBrLKGaApWfCDJZHQ8Yn_8m2t6juOs9I_YQwf9nHg3HdAjeu8Y>
X-ME-Received: <xmr:2CzravdgjL5paFZN8TGaniMogwwSa4P5ITQgOD7SHvzokZT5RkAheghLneE>
X-ME-Proxy-Cause: dmFkZTGcnWxWNdwzviArTqwO8SleswujEAoF3G5cAnzgWuj9VIXYzVn8L/YtSSoCVpDQCx
    AFAjkaMBKJDECegKseyQPi3BoJ2ULdzgEWHQh0kOOdV3qcZ96T5qYw8zvnYBduU6y+7gOl
    ju1hRqdfaUd029Zpq0M1QKVfvNYpVJXA03mIXM/FVYF2n1TVZdGxcwDBil6kVRafbiJtv0
    QuPNDwYksKVrYzT4QGS7HIxmz8ayVgiPQk5G9zoQji1nSBMTr/zV+0QH6w0a9BT4L54N+d
    cRhB7KhKgiZgmWNJc1G8l9d+gvjQ75B75nEIsy2loqzEXGvtqjUcmfJ5UhZu2fDzNX4RZ+
    6oR/S6KZE3B+Oj59PydT7wq4+cy2/+Do57EyU/spfCtxf/P36vf5deC7qOxvjMAtoOJNe8
    NXXd1ZuH7iDV5jJ0bBxXLG1LqVa7P9BOmaxRW5JTT1/jF3adOCntQdSPvAU4twjqIyOJnD
    il3SYhGq0rYp1kMyeBc99l97LZnhmPCerSKBxilv0VoIbfSZ/r0kRgqeaaq8vWQFyTKMq9
    JqWfqAb8kO8+Eaq32Gnd9ghE13syUX2tJAxCvmgtCsp/xZfVlMEAx0mCJon0C/Z+o5ex05
    Jd9V0ubEBlvCJwgW+XBjmEPpFPlMDPilID7ueQ2EeSfc1TgzPHQ9hBJktdzQ
X-ME-Proxy: <xmx:2CzramtPXpgB2FliWICvrfCmxHoDBpddpqlwsiVkAgXkl_L2UGuOFA>
    <xmx:2CzrahKBPlFz1_S-h2kDV4eQag1o75hM52YPpdAksDz-esYOivVMhQ>
    <xmx:2Czrai8zhJ2PidkxiL8I5CBOjunxDPKYeAZuTmY9ByGh0DE_oK2frQ>
    <xmx:2CzravA-GhBiS8ZZfrEuFcX1Wz4UiF357WeoQPRfuE8Y_xsXbdoslg>
    <xmx:2Szrasux01fJtrJ1m7E-uwxYNXvJvpS0zmf0fC_8GnCixRdtOO5rgn5m>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 4 Nov 2026 08:02:16 -0500 (EST)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Harry Yoo <harry@kernel.org>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH v2 09/18] mm/memory-failure: handle folios with PG_rcu_free
Date: Wed,  4 Nov 2026 13:01:05 +0000
Message-ID: <20261104130118.2507513-10-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104130118.2507513-1-kas@kernel.org>
References: <20261104130118.2507513-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tt9s4hhj76rh4bzzeaapmjmrod5159rj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 2805940018
X-HE-Tag: 1793797346-679904
X-HE-Meta: U2FsdGVkX1/qPvZxJTTH4ZlqFkSwGEUnuQzdOfhwFusjlyex7bkg8zdrnejldFLrbhwtA6A/92tGtA/dEPLla9dVROW/l8eH75/gpkFbuw85IYFATwU1KD2ZGCuGtOOzJ939uZfKO4RKZaPV5IrK5Izq/Agt0N05maL7ncptvZomt1Kg7acGsx1G1bW42qH8iDIJArvRDc98RKRZsVj+9SC2UrdiYmjyke5ailvm45lzWzST7W089Arlvgg64ZBo0KjJd/2t1dWflaYqyRxU25L4Wa54z+ekfoOAIS9lKb9hWTRiXDGFkbNOhCP5g6aL1DIArAnOWpWGLqru5S63lCXSYIxtv1qzUEPKwL5DC3bEj8JvLgQhur9oTQffw9M/ZwoFSPKQPjVmKVP1/PdhDSgENxApFqP7ZMtJIQPplgH2+mhjUC6u61ZMvYJYUgeMBAZ3OmL96Irp7MHTW8zRuH1zqEWcHTEBF3zOm8eMS9xqFIrZNMq9Hk/DPESOXt492Ilmu96+IzqJhkv+BtqLxwqXQCAm9Oh6PloN2btgCwY6F5MDI36i/ExbfX9i5Pzx83f92h8Qj1mdaGJJ9Bm2t0JUq/SAfHMGKnUdWnurAU+PmzPhb4ZdlPsxDIkpKIAGwebBYDe/4IWpXEAlew5Crppwf+ErCvOxMwXZrl7m85W8L5bhtploePupoNgO9Au9DJBSyCqfN9qCG1IUPhUgjfX4luLDyvYdAwxbHXOKg4kRqmbdsb16W+jb7XIVR+pWJc70HWNxIUSU2VPX++DrR9Q0msHZU/ho2Q4hBOBBQ1dc3bT0trx/yH3icpOU33ytvpXeykk+1fT9T6yI+diaHDoAyGKgtIrkS2ybECk+u226k03hPT7qhfSNeKsMcJ3ogQMjuIKjFo9Tq5kua5QlhbTMTiiUiKbP+jm9u5dnzFXtqrDO/3cCma6dxzDCGLdm83yh4iDaVM4BcTv1tHm
 +aufwAy9
 48Sur+bJHGt9Hs30OoXdf8PrcHTybJH7fn0jdm+6M7tgx3rBIT5zsfySRCSChs57w8HOZzloQytQGK7Ewijx/xhsGF64DQxp+SRixCnTugqFjkxpf9qptFmS+l6OpQus2X+5p4WsrsFoDu5y8BZjLZwl63B7DWgJylZWcQZAfMXxitF/69TonN/8DDbit2+85omrjROhkUIxAUS/kePLiBs6rRm1+03y/22LvUWjTX2RrafbtOajj3AK0sA5qI1Fz/g/7mXBOgSJxDhMWzcF6wTlJBKAhfdypaMbteBm9MlgHWIOa5X3zQuUCByfp9XPlTurbfW/quIK+DzprYmSnGtP0rEst3QM8JSveMdD9/WlI0gIKfK/XZKXnCJ44z+cwhP+Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A page whose free waits for an RCU grace period has refcount 0 and is
neither on the LRU nor in the buddy allocator.  memory_failure() and
soft_offline_page() cannot handle such a page: get_any_page() retries a
few times and gives up.  Soft offline of the page fails, and a hard
error is ignored.  If the page is part of a large folio, the folio is
later freed with the poisoned page in it, and that page can be handed
out again.

Free the waiting pages first when the page looks like one of them, and
again on each retry in get_any_page(): the page can be freed while it
retries.  memory_failure() has to do it before it sets PG_hwpoison.  The
free of a poisoned order-0 page drops the page instead of returning it
to the buddy allocator, so a later drain would still leave the error
ignored.

A folio with PG_rcu_free that is still in use may be copied by a reader
that holds no reference.  When memory_failure() succeeds, its caller can
unmap the page from the direct map under such a reader.  Wait for a
grace period before returning success.  By then the page has left the
page cache, or is an order-0 folio with PG_hwpoison, which a reader that
starts after the grace period has to check.

Wait at the end, not right after setting PG_hwpoison.  A large folio is
split later, and until the new folios are in the page cache, a reader
can still copy the poisoned page as part of the large one.

Both callers hold mf_mutex and can wait for the grace period.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/memory-failure.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 7dde7c3c9a0c..398463b2e82d 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1419,6 +1419,19 @@ static int __get_hwpoison_page(struct page *page, unsigned long flags)
 	return 0;
 }
 
+/* A page waiting for a grace period is not in the buddy yet: free it */
+static void mf_free_rcu_pages(struct page *p)
+{
+	if (!zone_rcu_free_waiting(page_zone(p)))
+		return;
+	if (page_count(p))
+		return;
+	if (is_free_buddy_page(p))
+		return;
+
+	rcu_free_sync();
+}
+
 #define GET_PAGE_MAX_RETRY_NUM 3
 
 static int get_any_page(struct page *p, unsigned long flags)
@@ -1443,6 +1456,7 @@ static int get_any_page(struct page *p, unsigned long flags)
 	}
 
 try_again:
+	mf_free_rcu_pages(p);
 	if (!count_increased) {
 		ret = __get_hwpoison_page(p, flags);
 		if (!ret) {
@@ -2440,6 +2454,7 @@ int memory_failure(unsigned long pfn, int flags)
 	if (res != -ENOENT)
 		goto unlock_mutex;
 
+	mf_free_rcu_pages(p);
 	if (TestSetPageHWPoison(p)) {
 		res = -EHWPOISON;
 		if (flags & MF_ACTION_REQUIRED)
@@ -2447,6 +2462,13 @@ int memory_failure(unsigned long pfn, int flags)
 		if (flags & MF_COUNT_INCREASED)
 			put_page(p);
 		action_result(pfn, MF_MSG_ALREADY_POISONED, MF_FAILED);
+		/*
+		 * The memory_failure() that set PG_hwpoison may have failed
+		 * without waiting for lockless readers, and the caller may
+		 * unmap the page once this returns 0.
+		 */
+		if (!res && folio_test_rcu_free(page_folio(p)))
+			synchronize_rcu();
 		goto unlock_mutex;
 	}
 
@@ -2612,6 +2634,13 @@ int memory_failure(unsigned long pfn, int flags)
 
 identify_page_state:
 	res = identify_page_state(pfn, p, page_flags);
+	/*
+	 * The caller may unmap the page once this returns 0.  Lockless
+	 * readers that started before the page got PG_hwpoison, or before a
+	 * split left it in a folio of its own, may still be copying it.
+	 */
+	if (!res && folio_test_rcu_free(folio))
+		synchronize_rcu();
 	mutex_unlock(&mf_mutex);
 	return res;
 unlock_page:
-- 
2.54.0


