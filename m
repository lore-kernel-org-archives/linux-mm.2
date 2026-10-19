Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 20AA060A3831
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KUe3FHoF
Received: by kanga.kvack.org (Postfix)
	id 336936B02CA; Mon, 19 Oct 2026 11:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30EC56B02CB; Mon, 19 Oct 2026 11:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1FD086B02CC; Mon, 19 Oct 2026 11:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F3BC76B02CA
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:50:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A046DA07A0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:32 +0000 (UTC)
X-FDA: 85339813104.08.38014B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id A5E454000C
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:50:30 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUe3FHoF;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HyeMP2UW39CYOeaVl1H1MlIga1p/omRrDkZGp5zmZrQ=;
	b=InU/1ZVBOIWIdBZVShDdQgWIrkvIgoHiGMSYvwYgT6Fznx6Q9fAvPmK7EhMaTyhkKQvd12
	u+ROs1iStS4r11MoUgucFU2LRxem9eV88My1qabr58AlF1qXUxWZxiuBQQgCWZZ6jsNoNQ
	mF2o79TjWCejOVd7VeWvufDCJysanQ4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425030;
	b=fM/jbY5uhUWWKYOnGj3b5zP99ITLlH/ipImtD94VHQSsX9ak8L9ZBqf1iALLtcfKckD6vv
	XkYPUfmpz567P4VylbFpYIlG+D8zgisw4d8GZ/36SMrcL5V2w71jJamJ0SGcMIfjv+3D3h
	09ab94ok9CxATys42exeaB265hQeYOY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KUe3FHoF;
	spf=pass (imf17.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E56960D81;
	Mon, 19 Oct 2026 15:50:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97CA41F000C7;
	Mon, 19 Oct 2026 15:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425029;
	bh=HyeMP2UW39CYOeaVl1H1MlIga1p/omRrDkZGp5zmZrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KUe3FHoFrcI2ArpljZfRCU2EynRF6RNNfX4c78jiOCLKqLaKDk32Nhq3CfAe4kjnj
	 CsT36eG4jMxsfA57cH9KXSpNR8PZu06jTbjW2QziDSDLOs6dkIENzvOOQuw8HMvkED
	 oDtD5DCtaEZdcsV9dKNK2eX6BhkuvCvQjotkHlNHseos32KfDzr3K45Ydk3lqSKkio
	 CekixxdSgm0PJ87xbKsI0WxeD2pnkfb9b6QNXSs2OikGWp9JAxYSr12bUNBcnuH+LS
	 yBueEm+oQ485H2sLyX7pcW3y8B30OYwTGqsXAElYY5qM9kMqLH3zIPWX+N8bQqWp65
	 fE3zL6HQtwtqQ==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8D186198003A;
	Mon, 19 Oct 2026 11:50:23 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 19 Oct 2026 11:50:27 -0400
X-ME-Sender: <xms:PzzWapiFp5Wu7v7gkoAa4GZ9J-SekEeSXyMI3tX_37b30zMGuZEykA>
    <xme:PzzWajSFV-mfaNiSPRqBsdRSriXmJ-1eTDxHJ53VBh-3YD5TcbdEp6GRB_WGbU-Ld
    dDDiHrhT0JSf-cSG6iN4HhO0Oha-k11s5tBkktJoOJQN3OqdWuiBhlGHg>
X-ME-Received: <xmr:PzzWaru-LAQJxkJ0JSQEt8ZHYunmcbesOUnPjoSZx60XF-vhE-4drLkTgJQ>
X-ME-Proxy-Cause: dmFkZTFIZYy10wotytG+4dUkb/TrOx7ODFzNTx6LAAAJtb9SdlnEFJwy1XcImD4gyhna2/
    zAC+EEqvmQ9OD1vfTU8mvYiDS0ghuns47Q4+ryXmkVilrv+pqFomIC1gUoiZOfFCnK2t+P
    9O9avF7uz974hExF8BDh4AlkO2Kz5b3etknTZfQTy3eRHnd2C5TvNt8woK5q07pcssriFF
    0X7YzIQRQ9gOQcIZd4ixgjAJQuYNSGk/RFHFd5/NuxCtenwYPdQO132Kw78QGPjvUTnfF3
    VZ20iGzDVcdiQzqlFcp/qqA68rjIK9UtFNtsCnjCSpXpVKtOfu4ZJHZy8EM6a32BgsvOLv
    GTts5CoIR3ht4mxHxWO6GedS/BYYQFbtcXgGZZZ3koz+37rksmGM/qSKHSSY4u7hGUQHmQ
    rAidDUTvlwtc5G79J2GHONIeDMRXVPObyUry2h6EpUB/+Vk/YU4fyni8LK0vUQdhhBy2E2
    wmoClH/DVozueqSCqPryKyW6Mr6WC/UsdiI/R+v2Rm+6VeTFfrHiMhVAOfWNly4VJkyS6V
    1FqCqwaj3etyYvizowlf8vKHJR0w6sN3HwndbOlAo1xYgonV/h4TLvQbqE5aC/TMsWEFVA
    cL7rCb4wFu7n08oVJvqB68O0OYR7d5RXtC6OBk0vSwV+oN7+WFP8nCzHwLVQ
X-ME-Proxy: <xmx:PzzWat9TlLp2tVW-q8vJ0qfUANgsvZp5SwhMDDlAIo_ETCB7XEypmg>
    <xmx:PzzWanaeLh0IZVbvFBwMRe0LrIh3Gpr2iKIpR6cBTlP8G1bDiQWQzg>
    <xmx:PzzWasOOWP1GNW6BJQoakAP2_ynGKahQgJpD28KD5xH9wF4pEmAEHQ>
    <xmx:PzzWavQ0PGzc7cP82JZnszEaOvhnfPLyXh-cOBIS-LBhMjU_MJHKtw>
    <xmx:PzzWan8JAVlxSRKlk6Ml12K0X-VVpUI7gqCEfPaELBHywtIpmVJFCocZ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:22 -0400 (EDT)
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
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
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
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC PATCH 10/18] mm/filemap: mark a folio accessed in one place in filemap_read()
Date: Mon, 19 Oct 2026 16:49:03 +0100
Message-ID: <20261019154913.1765974-11-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A5E454000C
X-Stat-Signature: m5yk3bkq16ab6affk4efk3yz46i8a8ty
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792425030-576804
X-HE-Meta: U2FsdGVkX1+/1CtVPZF4mtEmqpv8MEsd3q1UbebTjQpBasVUrgv31Lghq31z7DTEO/+mWzQWd2198kh1OQmXeVQAz+b+Gw7+sCvVNjMF3Gp22d7rmlCR1vuPBdSZdPmMxu7Esm7iZd2TBJ7qgC00SQuWo8+boW9Os+JGxicYcIXXLqQqwiuRC1zim0dAno85u32VVUXZheCPzOp3AXQOmszI5KENc5KSm0wppI7RSx5GyxkQWIM3QDwAT32yEH40VPWSyotESghlfSr0r2mQ6/+1wZzj0GpmbsD2MGmOSrlUYdiz0Oa46h0/nTFghoEvcNv3p9LkLA2id1pKCu27lhjuS8NQPUugkBlVE1eMhFMUTk66HF0MGvya1olweNB8nE7iUg/WZ3sZzr/cYXu0UIuHtROTnGWdywXqpHrF0brBw1LyL0X2SBW2rz2cGNfGP8cDm3oN01qszs5O7kvfwUEKap9t8KAgS7Wyc/PM/Gj/LRiyVQ5EFYDKTFnYFc6EAORUtyUlAWzmGhusjlbET37iZ+6vXfZLysOt4UWFDVMje7KPKAYKnsncY2KAskCz6qsejYNkScsxILkrjc6jp7b3MmHXMjgWtAqnUlEVkoXWeNSrf2gqPhTxdenEeQcWT63bAXhY0D3s2mKWLvNInHWIIcF9It16ALLUxpxvg0tMc+gkspU3S4e5cJ5SeR1W1ri6texlnpiQkKDgEOW7nXV3j8GD8Ft1RsznKUgi2Bv/ucl+6w1dHDa8E3vKE967sdzgboGjJAFS6IoRVyOrTIM5Kv19upUnXGQqoQkJtQJrVi7+xLRdMYj4jYE9N3fdx0y4NY/6iZ8907d6rmhUa7kwzLVUhlElI/sDVowhs5Qqz3G50qu5TqTsMs5flXkX5ZLCrslaF6TvYCCkzi5dfLySLX/3cmj6uZRYt8H4HGzXFGNNGu18mqlPWMiayrHshTRnHsrN6ZTPT96Uu0b
 +toDKYpY
 DqVAMJSW9zgyxNIqaP3JpTxJD+I7NIp3ffTE+tPR1Ph4kd/vpuTTbrihS9p2Xz4Z2ulYTbhUiC3WgE/plOQOtYhrTQHzsOXH+GG+BxNq7lgwRIyyYAkAK9oTxBsYkoPf3ckeTGTA21PZK52nd7Mq2ZLnPalyyK+CAOc004rFFQJFbUAUQIg7XsztxrTyijl0L+mSKgzStEqjkISd0s9m38TF6fvheAlhaEml0K6c+mODmiu3icI8BWWEy4fKHPs0JpwykYXh8/b7DuRL/usC6NtUZqBEab5JB0bp+kvQmAC7O0/xDBbUU2M8lbHePenC75MEVj4knJhGxur6dpa+LxP46zzTc4JsSSlUb+GN90/0LcrZuDPh9gWfR2rEFL/Ta1A6QvGCpK9YlcMPxT3EBvCqC9CV0kIwLTRbGipXJj3vWvJf4odc5ndUY/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Linus Torvalds <torvalds@linux-foundation.org>

filemap_read() calls folio_mark_accessed() in two places.  Before the
copy loop it marks the first folio of the batch, unless the previous
read through the file ended in that folio.  In the loop it marks every
later folio.

The test made for the first folio also says "mark" for every later
one.  The loop gets to a later folio only after the folio before it was
copied to its end, so last_pos is at the later folio's first byte and
pos_same_folio() is false.

Do both in one helper, filemap_read_accessed(), called for each folio
in the loop.  For the first folio the call moves below the test of
end_offset against the folio's start, which is false for it: the folio
holds ki_pos, and end_offset is beyond ki_pos.

No change in behaviour intended.  Preparation for deciding in the
helper which folios are worth reading without a reference.

Assisted-by: LLM
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[kas: shorter changelog]
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 00fd89cf6f55..3508eea44ad9 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2759,6 +2759,20 @@ static inline bool pos_same_folio(loff_t pos1, loff_t pos2, struct folio *folio)
 	return (pos1 >> shift == pos2 >> shift);
 }
 
+/*
+ * filemap_read() is about to copy from @folio at @pos.  @last_pos is where
+ * the previous read of this open file ended, or how far this one has got.
+ *
+ * Reading on in the folio that the last read ended in is not another access
+ * to it: a folio read in small pieces is marked accessed once.
+ */
+static void filemap_read_accessed(struct folio *folio, loff_t pos,
+				  loff_t last_pos)
+{
+	if (!pos_same_folio(pos, last_pos - 1, folio))
+		folio_mark_accessed(folio);
+}
+
 static void filemap_end_dropbehind_read(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
@@ -2844,14 +2858,6 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 		 */
 		writably_mapped = mapping_writably_mapped(mapping);
 
-		/*
-		 * When a read accesses the same folio several times, only
-		 * mark it as accessed the first time.
-		 */
-		if (!pos_same_folio(iocb->ki_pos, last_pos - 1,
-				    fbatch.folios[0]))
-			folio_mark_accessed(fbatch.folios[0]);
-
 		for (i = 0; i < folio_batch_count(&fbatch); i++) {
 			struct folio *folio = fbatch.folios[i];
 			size_t fsize = folio_size(folio);
@@ -2862,8 +2868,7 @@ ssize_t filemap_read(struct kiocb *iocb, struct iov_iter *iter,
 
 			if (end_offset < folio_pos(folio))
 				break;
-			if (i > 0)
-				folio_mark_accessed(folio);
+			filemap_read_accessed(folio, iocb->ki_pos, last_pos);
 			/*
 			 * If users can be writing to this folio using arbitrary
 			 * virtual addresses, take care of potential aliasing
-- 
2.54.0


