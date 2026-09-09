Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2EFBCC79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 13:34:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4699F6B008C; Wed,  9 Sep 2026 09:34:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 441836B00A2; Wed,  9 Sep 2026 09:34:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 384126B008C; Wed,  9 Sep 2026 09:34:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 139646B008C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:34:53 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 44B2CA0239
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:52 +0000 (UTC)
X-FDA: 85194319224.22.BB38817
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6B7421C000C
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 13:34:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIoHTTPA;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788960890;
	b=LGtsRH+RX+wSSfeQfRr156lchM/C0HyN9nT5DtUDI6L7R8P57HudPbGPkg4wX281+JAMOF
	tgi+JaOGkFjR2+2TXjdTfPu0tNB4qes9H+L7KqAsz/zY62tIBjEeqzncoXR+9M8F4FG4GA
	r0UsvQHnmNWkLsCnwil4Fj0x2Ga9Z5I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kIoHTTPA;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788960890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7PN1IUhSiINmj8se4l4JjZpqC9NFR6pyb0CVD1i9OUw=;
	b=Hkg/Xu4B5uCc5NcUnCKAaCDlIDxEh1j974JNUQPF7jx6uH3nFq00nKPu+2slBHoSHxB1vA
	vUW44I9T21R5fGI1UH+SH5QrKM9hlJ3yATaDfHPVXyVL7791wx4EU/pHi7GX1EvHrJI0qs
	PAmvw8+ohkx4TQJG45oNIHbqVXkij+0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A9E21413CC;
	Wed,  9 Sep 2026 13:34:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45EDE1F00A3D;
	Wed,  9 Sep 2026 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788960889;
	bh=7PN1IUhSiINmj8se4l4JjZpqC9NFR6pyb0CVD1i9OUw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kIoHTTPAUt43eRitH91WceQSKtW/bnO0DsunOWkKihNYd/TT4n16yoEXPoL7Ttm9v
	 E7gprzEbl0f7YRxISlwllUWnaB0OKQSmS0xcjOC1zAFl5XJ1rCnR2aGCbSo+Lb4osQ
	 0yMDnt+yLEJeJkDCoBsEAk22lqqKD00F2VpX20tr6exOlYobDWufPg8N0bHsAZHnNW
	 mGvhmaliePQkYXReT6AVNhIznC18ECGJ8kOaV/3HkVgcDIYTsuIcn06yOVzUJP1Or9
	 sfcTGZOONZU6H6SnH1ms+/x3/csSerKpLL5WpiNLSFH65Js/Sj3S/a4irbU70T20Ef
	 aOOZo8EgoypAA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Wed, 09 Sep 2026 15:32:59 +0200
Subject: [PATCH 06/12] mm/sparse: rename __highest_present_section_nr to
 __highest_used_section_nr
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260909-b4-sparsemem_cleanups-v1-6-008fc8d579fe@kernel.org>
References: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
In-Reply-To: <20260909-b4-sparsemem_cleanups-v1-0-008fc8d579fe@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
 Oscar Salvador <osalvador@suse.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Jan Kiszka <jan.kiszka@siemens.com>, Kieran Bingham <kbingham@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, driver-core@lists.linux.dev, 
 linux-fsdevel@vger.kernel.org, "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=3550; i=david@kernel.org;
 h=from:subject:message-id; bh=mW1IouhiQ9wKrEiRlJmNZfNFYgNpZy9MK7BrqFqJBso=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIWJhjt+K15+5FExW+Nhc9aPAxOq727k9J291GdSHh5F
 INK0Au+jlIWBjEOBlkxRZag4PsGL1+uq61242OGmcPKBDKEgYtTACaiUcPI8Ndc3j9wvsG86jv3
 PwS2ifdN+B1TWf8jNPVm87eqn/UbuxgZtuXck7xmXMy6aIrQXJ9/JdnXLvhcnHklOPNWIqveQhd
 ZbgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B7421C000C
X-Rspam-User: 
X-Stat-Signature: 9wgjeht5y71k765pn489qgmp97j41qub
X-HE-Tag: 1788960890-740314
X-HE-Meta: U2FsdGVkX1+YFqDA0YqFOnHMXuQ1huynq6K5BmfKVA7KYVBD/mskU3Ez8EKoITC/yyP+GyXanpRf/J3gISP6kIvE73dHmsMLmrnNUd5styJhk3ian8aF/5OFvPlg+ybO5XdsnZCfVEX8337qI3s+6U2lJl/nnHOWyJcyo8uGU1KKYjyaBDcumiYrk7Jn8crb8btiopPACGT6oNYVM3TJXLcUaLARndFQ0AldVbKM7Hd6isJaARj4vY0u+0ziHYC37oWmoq3QxhSu1AIgr62Zrqy1jFSgU7vVuBA2EfuAyviDXYz1nWVXCD42EAO/Bw8C2CGeB/i0JNDUVPtOCK0zUOzgud9XZHgmb4hIMomWjX/Jf2ylXqLujSRh61AEVG5uSbuT6gvaMK7Zu2QkWIuuZFf/SpAbaWWsvL5qIalEdQbWH5VKeb8RyiTyhSS+KUU0DgcOKJKDIGPxDzGIkUAk5zGv1wyqPlaB60GLfnIfvHwut8Gn/6CviN29SdjBp2M9zRsnuNOIfGDkp/qnI6wlcdd9TsnpK7Lo7cfRKrb/rddfu6l+iho6lvBqY8uyT2iX2O0cTo0XQDD+nbiTfQCwu2uWgLpuHfQGng91W4W86z53gZV1s+8KBs6nDL7iQfJ2AdCFytzsLJH8PaKgivHhB4o0XwtHb7YruDjC8haPqKkWxypi/hx9iY9udEugYj1sBa8G6kyQlB7JEPFbofNTBYerBLUn23pndhuXXQUvb7pDmKV5Mo0rf9vtwWy0kIV1T5/TPEPitynzNNRC/ElF8re5uIQzGLTGhF5duq78pzCqQYBubpAtgSuHWKm8BNPxiEvt/tY2KjtRzh9E8jl1igWWu4r+DGkWuUGwxD4fcoIIYx4VQk1Og+m1KtdtPIFyc+Wk+/Nmt0CnnprMN2mTAbNjF5jIjxvVTvxEY/chy8y9TNnfDAjbVKp7OnYksjVXSPcvQ55Hc8Biuq9hJTm
 w2Jdu3Uj
 Vt/8DN5+hIbsNEin+CuN+rB9TMwLn6CPJYoEINN8wrY+GD2NMkPAaeroJ8txXZbf0yjHkHsVZxohnrHO5IQI6KnmjThbHml6F+qUsy/DD1RnHqdcC4GXGGzdksOS0y/oGuqfxb66e6yCzBxMoZbpa7JZprMX66/Cj9uJSxi2s/RJ0TcM7ByLDIVEOEMipQGFbkjHPPJ+b8aCtwRiY8pmYvlXZhQJ+j7wzpX56UtIzf/zZQn0T6/rg0UD1wSeCwh357KsSGQfrHLb++CStGkE3qeFpOvZz2HWWYGNZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for getting rid of SECTION_MARKED_PRESENT, rename
__highest_present_section_nr and clarify the comment.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 include/linux/mmzone.h |  6 +++---
 mm/compaction.c        |  2 +-
 mm/sparse.c            | 12 ++++--------
 mm/sparse.h            |  4 ++--
 4 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index c9ae7991a8b20..19296e8ef44f8 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -2170,7 +2170,7 @@ static inline struct mem_section *__pfn_to_section(unsigned long pfn)
 	return __nr_to_section(pfn_to_section_nr(pfn));
 }
 
-extern unsigned long __highest_present_section_nr;
+extern unsigned long __highest_used_section_nr;
 
 static inline int subsection_map_index(unsigned long pfn)
 {
@@ -2269,7 +2269,7 @@ static inline unsigned long first_valid_pfn(unsigned long pfn, unsigned long end
 
 	rcu_read_lock_sched();
 
-	while (nr <= __highest_present_section_nr && pfn < end_pfn) {
+	while (nr <= __highest_used_section_nr && pfn < end_pfn) {
 		struct mem_section *ms = __pfn_to_section(pfn);
 
 		if (valid_section(ms) &&
@@ -2324,7 +2324,7 @@ static inline int pfn_in_present_section(unsigned long pfn)
 
 static inline unsigned long next_present_section_nr(unsigned long section_nr)
 {
-	while (++section_nr <= __highest_present_section_nr) {
+	while (++section_nr <= __highest_used_section_nr) {
 		if (present_section_nr(section_nr))
 			return section_nr;
 	}
diff --git a/mm/compaction.c b/mm/compaction.c
index 4994e200bbecd..f1b2060eb2016 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -216,7 +216,7 @@ static unsigned long skip_offline_sections(unsigned long start_pfn)
 	if (online_section_nr(start_nr))
 		return 0;
 
-	while (++start_nr <= __highest_present_section_nr) {
+	while (++start_nr <= __highest_used_section_nr) {
 		if (online_section_nr(start_nr))
 			return section_nr_to_pfn(start_nr);
 	}
diff --git a/mm/sparse.c b/mm/sparse.c
index f84bfceb53060..2b41ae36f20b8 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -164,15 +164,11 @@ static void __init mminit_validate_memmodel_limits(unsigned long *start_pfn,
 }
 
 /*
- * There are a number of times that we loop over NR_MEM_SECTIONS,
- * looking for section_present() on each.  But, when we have very
- * large physical address spaces, NR_MEM_SECTIONS can also be
- * very large which makes the loops quite long.
- *
- * Keeping track of this gives us an easy way to break out of
- * those loops early.
+ * Looping over all memory sections is expensive, especially if NR_MEM_SECTIONS
+ * is large but only a fraction is actually used. Keep track of the highest
+ * section number we ever used.
  */
-unsigned long __highest_present_section_nr;
+unsigned long __highest_used_section_nr;
 
 static inline unsigned long first_present_section_nr(void)
 {
diff --git a/mm/sparse.h b/mm/sparse.h
index 744ae29002f5e..7c5d82ceb7142 100644
--- a/mm/sparse.h
+++ b/mm/sparse.h
@@ -114,8 +114,8 @@ static inline void sparse_init_one_section(struct mem_section *ms,
 static inline void __section_mark_present(struct mem_section *ms,
 		unsigned long section_nr)
 {
-	if (section_nr > __highest_present_section_nr)
-		__highest_present_section_nr = section_nr;
+	if (section_nr > __highest_used_section_nr)
+		__highest_used_section_nr = section_nr;
 
 	ms->section_mem_map |= SECTION_MARKED_PRESENT;
 }

-- 
2.43.0


