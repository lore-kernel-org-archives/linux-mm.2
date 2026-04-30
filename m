Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3BBCD1297
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 04:05:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D7B2A6B0099; Thu, 30 Apr 2026 00:05:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2BFE6B009F; Thu, 30 Apr 2026 00:05:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C68A66B00A0; Thu, 30 Apr 2026 00:05:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4CB16B0099
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 00:05:06 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 528571403DD
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:06 +0000 (UTC)
X-FDA: 84713881812.21.C27D7BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id B684E80003
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 04:05:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKwVglCF;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777521904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e+UUS7GUGZaVgbrELoIxuwWRfwzqtpp9mPPWbq3QxPI=;
	b=AwdcRJs2rkGC71vG3qC8YeAjYqBdcofM0E4fkONATr7W1FQW0Nm4cGf9CiSH+UmRYiV9G3
	I9cJz4MgLS4R0xy1L5a3Bl+vC/PXLY5mJS4C06lA4kM7X691hIvFxZzqQ90gx6NWuxarmc
	VcR56y28+bopXKFFBEaNNWieDD06aPg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mKwVglCF;
	spf=pass (imf30.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777521904; a=rsa-sha256;
	cv=none;
	b=QJrQd7CNDwkUD2s4cv76SB3W3PDGPLx5FtGkmocjKkATGZt5ixgcEhEc26i8iJJa+P3D5z
	QmkCR++tRwFDRKNcK2PxAhqWz03mgZbAWA9Yko1owqq9BfCt+gHM8zBVQq2SQIt0wWA6aj
	VasqfJDCZXx3gCln1uOJHSwA3H7zzzw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3A3E16132D;
	Thu, 30 Apr 2026 04:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C627C2BCC4;
	Thu, 30 Apr 2026 04:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777521903;
	bh=3UzddeMl13pC5cJUrT4HHkjYBFF8Z0grqJoknqLkHzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mKwVglCF7XEsFftOn0BAtLwGM5IZ72wXKgPaG3s9rdnfQtx+pmDdlMhp0BTc5EYNf
	 FJboHwOiMXC33Onbze1GSoNvzLlFPIK9rhRrqSsueRkYACFW51iYCE+t5LiSSUtrDZ
	 6Zgo/egoBF46WoaKKLJpL+hNtjheakCbbtpFjT8y7TDrK7Ows6M9EqK3rdErLUzivK
	 4Ay85oZFt3iFrC53ukdn7sqXcw6md9eq3jFLK0YjDszHvyQDD9gHGtkAjd47bH+XH1
	 stGeQfEGcaAiSsSh1IY9gXD9Yt5DxgBQ/zzQ6kcBG30A7WMR3XO465Eebcb6ZNIjyv
	 BawWjDw+St+Lw==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org,
	willy@infradead.org
Cc: david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	jack@suse.cz,
	pfalcato@suse.de,
	wanglian@kylinos.cn,
	chentao@kylinos.cn,
	lianux.mm@gmail.com,
	kunwu.chan@gmail.com,
	liyangouwen1@oppo.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	youngjun.park@lge.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 2/5] mm/swapin: Retry swapin by VMA lock if the lock was released for I/O
Date: Thu, 30 Apr 2026 12:04:24 +0800
Message-Id: <20260430040427.4672-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260430040427.4672-1-baohua@kernel.org>
References: <20260430040427.4672-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B684E80003
X-Rspamd-Server: rspam06
X-Stat-Signature: fyrrraj5pwcsfzatwpxzocbjybqzaq8d
X-HE-Tag: 1777521904-694871
X-HE-Meta: U2FsdGVkX18aHxlnbUjjGaFTpVRx8q1aDS+SZn0OENj+EqTTQj7/+Ltv3aqtkL825i+o1WMu5ns+4VyWCe6G5sUVPhb+mUD6qmPKRYFMI8xNPYhO1depaSc4GSUh88x25GGQ68aswilBPc7dhycbvfDekoqFiYXW63JYckwiO82C6pIDm62sWXplD+CO1o3wGe9mhL6a08qaRV1Iv4vMChXb8nFhVANvkuP6VTfJIH0fyreSHVFrDI8e31Kt5iy1kEV1Gz3CJEbmq5yyLgnt8XPkxIt+ALRFXjm2HdVcMF0r9nFbNaLzeV0nFoEPvI/H3yCTWtnMQLQAETOIoSvI0ohxTZ7Bn1Yzj8j/tTUlSP9cElba9N7wB4PmTGYaCfSYKTpy3lseMKbCEGaejDkqLJ32TUjjSeZpDQhVSWACTLVxS8XE7LRTVouGecaxDfCDA2N7egYE4mxHOA0+n3xBcf9aSBQyDF8/tl9Yr0OsoDWFvLVJv4ZDTbEpiYnfhH13bcft6BBCjsIceZnPXR3WVgDl3vy5YoAzzCpwttrxyeO3aOiD7Eyjnph5yXiGLu8QwIjDdJ1HkjxTotEMeE7G/eaHD5MMrVWoQneX3Cdffcv3gOX9Nn23LJb6l6EvUmqpNlHfoz0+DK3dU2w4a3zpWMsrtVIGMdxaYvzx4B3xLMgQvO9lppO67lC/Y4t+zkCe+KC6MhFnxvvuGExn8rWlXr66H1+6IPeO35WRKtWwkdg3kyluw8lk1Cs/fJPq6RRNpFxcg21zfvTulKeonlz8wwzC6ImA2KFFWFSyyJYYAdpmRSWYsai3VlC+IuIsFyXSY3Y3UIStcu0tqqprxJRnFGSG0eT9FuFkTYbMseYQ3OennA3VSpn4NxxQt5jFfVH1v0xcRnJOJk8EvyDOxTHzNsfzmYlxhoLafhIC+WFXNfQtVBlamvjAlMwc2r7QbKnW0AiRi0bgmO/WXpob8BY
 sdbGaSqd
 LcFN0V7BNSwFdZJhF6kJyoaATCQLJ6iaJBDk/ZhxYKqJjWlvarzFLKpJHZgTrpCnkqXhoQtSxA48EXPAFeXV2Sc0gpws+m6M6zcm1vTEcjY7eq5n2iNU+AQG1QDydNhnKawjmqTcnKqCTlE45f3IYGDR4Kppa53o+4/1/C8xyDDezjwCWTTFBujK6w/bGYexFrvOAjHRzDrP1TjvoVwMKdIq4km5rJcF6rAyKKAphtiBQqbzIUoiacZ6cDsAx3uqfzu0xNj46auLPNV1/YjCP55GgBq2rne90z6eNuWXbTLexObhX4EEB974tkH6I+aX8I51ksrDYkoZzq98=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If the current do_swap_page() took the per-VMA lock and we dropped it only
to wait for I/O completion (e.g., use folio_wait_locked()), then when
do_swap_page() is retried after the I/O completes, it should still qualify
for the per-VMA-lock path.

Tested-by: Wang Lian <wanglian@kylinos.cn>
Tested-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Wang Lian <lianux.mm@gmail.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 199214f8de08..00ee1599d637 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4791,6 +4791,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	unsigned long page_idx;
 	unsigned long address;
 	pte_t *ptep;
+	bool retry_by_vma_lock = false;
 
 	if (!pte_unmap_same(vmf))
 		goto out;
@@ -4896,8 +4897,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	swapcache = folio;
 	ret |= folio_lock_or_retry(folio, vmf);
-	if (ret & VM_FAULT_RETRY)
+	if (ret & VM_FAULT_RETRY) {
+		if (fault_flag_allow_retry_first(vmf->flags) &&
+		    !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT) &&
+		    (vmf->flags & FAULT_FLAG_VMA_LOCK))
+			retry_by_vma_lock = true;
 		goto out_release;
+	}
 
 	page = folio_file_page(folio, swp_offset(entry));
 	/*
@@ -5182,7 +5188,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	}
 	if (si)
 		put_swap_device(si);
-	return ret;
+	return ret | (retry_by_vma_lock ? VM_FAULT_RETRY_VMA : 0);
 }
 
 static bool pte_range_none(pte_t *pte, int nr_pages)
-- 
2.39.3 (Apple Git-146)


