Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C8AA606A889
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Yfw0uYdH
Received: by kanga.kvack.org (Postfix)
	id 076766B05CC; Fri, 13 Nov 2026 13:56:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04F526B05CD; Fri, 13 Nov 2026 13:56:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7FD76B05CE; Fri, 13 Nov 2026 13:56:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C0C446B05CC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:56:57 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4FC4716020D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:57 +0000 (UTC)
X-FDA: 85431002874.08.27F8BF2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id B71D0180006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:56:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yfw0uYdH;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596215;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mosG6dXpKs4MiSvsDopZl5qPTYSrZ6sq9UtFKALWaM8=;
	b=iRm9y3FFhP7oH172eFqfDxgHHiCM1d/o4pmFd8bi8l5AjHDKn6iDPbsxLuQCp0jk7I5QTf
	Y3s5zjrBAc4PcrbejgCCb5cHAm0zRKct0WI5yh7j4DpFmbGKa3ZXfBjpBpUpHLEqzZ87mp
	b/H7MlDhziGAe76ebQP35vBmoSas8Qo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596215;
	b=NUNQj1GHlSBEqtZShfw4K05lqdeAodQUEX8sQHvi2apqndO4EPL82vnqrjErCpROcnOGBX
	XpCQlhXbFjV9CZTGUajsgOqPtxof0p/edbeBpbODROtRu8rKWQEniCSPNeQySVUt7dnFer
	5KGpPa2erm9vXKCkvCSicteXvyR6Aec=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Yfw0uYdH;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 521BC63295;
	Fri, 13 Nov 2026 18:56:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57AC61F000C8;
	Fri, 13 Nov 2026 18:56:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794596215;
	bh=mosG6dXpKs4MiSvsDopZl5qPTYSrZ6sq9UtFKALWaM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yfw0uYdHB28H6CZ6a1Qjriabq78wA7ne5Juecy/t5L8jf1M8DmFkK0I0tzYrCgl0r
	 FZ8/NU2UKcvC8wRvEH4Tt4Bna6yVLzBwnM6cK+Rk0twV6YRyYhBBeJmoZUQ2yeHSWQ
	 1wKiw5xDYvscmMfC7RKfzl6IT3v/mLX1a+WUN8B/AZ/F75khkZJYZvmkYw40Qu+3wX
	 MiOzmjsfCP9FSw9lDY5ftO3FJ3MgOyCKXqGu2vqaVjmuUnb5WYOoBqVngODp48k4mD
	 vBuUWOTiep+CuYSPoqwOaiCZLgOpcA4Mv1bybyKLABcVWGagJ7VHe7WZTdcmfUOHNu
	 aXqqj2OEyockw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v8 13/16] mm/mglru: Reduce LRU lock contention by shrinking folio batches in inc_min_seq
Date: Sat, 14 Nov 2026 02:55:38 +0800
Message-Id: <20261113185541.70203-14-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261113185541.70203-1-baohua@kernel.org>
References: <20261113185541.70203-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: B71D0180006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: bcq4stournfkayhcqerhx9heewf8audh
X-Rspam-User: 
X-HE-Tag: 1794596215-566122
X-HE-Meta: U2FsdGVkX19zU8kQCHk8gcpKujJ83LdtaH9LKbbDhxj2gDfd4qiGAMXlYxB7NKp0/mJ0x6tf7+tI3D4bW+0LNEFNmpo9wGSwVOr9iAjcH2MEylIog0WtzWbbe7a19Lj2SAnhE/rbZHPurDh1iF6twEdrEhyMDIblu1TCIQsa307V0cHmL57HrwfHKzAQdk0rXeckeKKMDv5336qJrSLjv/1Uy88MBcoqx1iWgaboCLNp0EJRClpR01dWFg/L/DC9/RzeS05ozxj+pOOB3kf+jd+eRjomew4OkHNorgDeokSCFE5HRL8WtWBz4+gQ3Yr1X4Tcj17lb4X4zrDpKWSGvrIvOs52uAPDM62yLCQ90aFHd/GtrgzChIe18tLnGkPvH0z6/gSdO5KiDwcizfSy32GXv1OnFzfh+76SmOTDgvcjwfYt2aLmF8XwH9XW/Hghy6Y3kODvVs5ejgYU03BMc94MEq+NZ39FnC1nNavIgMyW+ShjyAck5+mY1Re0uBEGw2zrjasXC8Fryi46sPMF185I2xLN903/f2CmuhljGFuP1NMDXSRDHVFQyDfp43a8DKgo60Q0jSEiCBlOG04Etup2y2BGWG4rudWmi36ouhUi/NQxj18mWIjgmeQSFD6n399wbdiG851gLWxt0CDlf9GeBLVKAxUEH3nhcuq62tfWB3TCFCeKVe3lQXi8yaUeypsammO70uZCA8u7njmYC0PnVb2+Ckmgdf4UuMqtF45En4kn8Ur2ZjMPQXV3WbcI16nkFCsCV8xUVN3k5Qz7iK/dti5Sf2d5bRrbIGn+BO8fzY3cw9yIFAzVfaQROKvBiAVwnEUwUS2hgFyOo/7NZLEPYai/cxPGXrZ56RJZrTbRKhSWq6UfueYDBPFE0fLe4VBf/GPz4bwgfWyMNUcgbko1VrAW7JoVFo6Yl79E8fFAfV0T9bSHnQ3wvlrmAE6bCKjKv9axjOlrhO8KxQ4
 DevjkHsM
 2EHlGS+4avt9p6VamzoSLtyjTPtaGy4U6UHFDQ0cptn4ppEwYj5+f4GNnDqBNfehkJOp857fvKb367ItRAkGBLr/xe+8Y0bO3dn5XQZczEgytyzQw5RrYzCaUTviXgE9NTbzqElj3HUorJH9ULLXPRrRx+7nZeBK70o/ywF0wR+DsL0423MCg5ckhLuRwwQ3dvYCZAZJPHCTMQkMGAmdmrWUsC6NJfMPn3BEOhTIaxfG8Jv7lqBKT81EKVYxj0WbD0xr+uj1A8439/tgGYTWFXldmqH0iNJRRy56SUqtjX0P9dyy48EBPZKPzhK3sTPZXam6CRgi9MD3jscRaFrBNnZX3ynyGjiEwDioa
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
index 6ed47089a330..2595f3fbe1b6 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3912,7 +3912,7 @@ static inline void flush_lru_batch(struct list_head *head, struct list_head **ba
 static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
 {
 	int zone;
-	int remaining = MAX_LRU_BATCH;
+	int remaining = MIN_LRU_BATCH;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
 	int hist = lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen = lru_gen_from_seq(lrugen->min_seq[type]);
-- 
2.39.3 (Apple Git-146)


