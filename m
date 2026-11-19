Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4B3B360A382B
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=fv28Dxji;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NGvTTjtX;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=s606/Mk8;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=NpvJb5ju
Received: by kanga.kvack.org (Postfix)
	id E58256B06EB; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E30BE6B06EE; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C836E6B06EB; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1426B06EB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:11:28 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 70C5E40BF8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:26 +0000 (UTC)
X-FDA: 85452963372.29.89CCAA7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 674898000B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fv28Dxji;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NGvTTjtX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="s606/Mk8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NpvJb5ju;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795119084;
	b=uvBJa39zVEn3wPyCj3qc+PTZEyj2q7PJkaUJx0RyltkAB/LERDcLW390h1CbaH6TxK888m
	EQB27tP87uoN1apcAVC75f5KogiD6sgUpA1dXZ2V3bIipbo2FUG9xhDh6D1oQeyooyaQxj
	CSmu54NkLWphmL7ar4T7S12nyq6ZxZ4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795119084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E0JMQvtIW98t79y2PymOspKrjqnL38s7VvLSlkqXnAQ=;
	b=r18BCDd0p5UrxBI/yeoM722kUJk/K90M8EA5iV8wUWE0OEn+BooIj20Iv3Ii2FENkNS93+
	nsbnTqT1b3R75JKVVqfpmmOzuFyhDbVcV2+RQHvamt9RejoINTS0XywfojabOPYplAGc4z
	UkbxJ791gS4Nyjv3fbiFB9iTAqyywfY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=fv28Dxji;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NGvTTjtX;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="s606/Mk8";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=NpvJb5ju;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id EAA751FCEC;
	Thu, 19 Nov 2026 20:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119083; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0JMQvtIW98t79y2PymOspKrjqnL38s7VvLSlkqXnAQ=;
	b=fv28DxjiaDhoF5fTY3ws/RkzFL3T6Osh05wt7gSqPfDV8iTwq+B7Lh77BXzt4bLWSxhDms
	ku1/lG5hoel9Tc5NccaLOvOWBDFPny7UqNcLR4QtI2xHffdSbWE/Uyxstkzv8PNf1TYmZT
	KQpadoETaj8kNEbtbYKwYYs8bCywyM8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119083;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0JMQvtIW98t79y2PymOspKrjqnL38s7VvLSlkqXnAQ=;
	b=NGvTTjtXt89TF4jydV6cZiMADwXXXcYvq1zBz6q23jI6nooiAxe98ObFpkEG9w+lsxDPif
	hShMQjYPSYnkbFAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119082; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0JMQvtIW98t79y2PymOspKrjqnL38s7VvLSlkqXnAQ=;
	b=s606/Mk8kzgzQVe/0/ZKHA+DlGC/FJ0taZowr7flLw3/RnlbLYn2nbzP3R4+vJ8MPsgGyE
	SvCyoV4LJuAs8qcAePEZss/DEjKE34XMfPAGfuBPr7lHqsiNkIINQ+Yn9swm1JTJj9JUUj
	KJFDP0AHGvt38kY+2yJbiDfWBBln7y0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119082;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=E0JMQvtIW98t79y2PymOspKrjqnL38s7VvLSlkqXnAQ=;
	b=NpvJb5juU2vGru2EPyqmlOidbcwgu6JxZgt9Tme5YBU177SNL6zyh9MymhbC77OoyWoTCy
	fdIg+2ylzDidpfAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D95F51334C;
	Thu, 19 Nov 2026 20:11:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OqV1JuRX/2pPYQAAD6G6ig:T3
	(envelope-from <pfalcato@suse.de>); Thu, 19 Nov 2026 20:11:20 +0000
From: Pedro Falcato <pfalcato@suse.de>
Date: Thu, 19 Nov 2026 20:10:45 +0000
Subject: [PATCH RFC 2/5] mm/huge_memory: fix filemap_release_folio()
 interaction with GUP dirty
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-gup-dirty-what-v1-2-236d69f25c24@suse.de>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
In-Reply-To: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Lorenzo Stoakes <ljs@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Spam-Score: -17.30
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ijhsxcrmcepc8w9cxxt4bdxbeh74munn
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 674898000B
X-HE-Tag: 1795119084-912115
X-HE-Meta: U2FsdGVkX1+yoUfTz4Di2ZDmmnUqroVDuSXb84DbMLPBlY2M38zCmATfhE5AxCP8uV6qFmksW1EcIGp9NJC9b5bzVlGiAVnxc4M2g4O3aSFdpCkQi6FP9gaeFfrpom9LGCpECE64TFlS9Ro8FjipMCWQSCIqFOH1q+oHe3ZFR0wHd7HMUzkHAUAvqz6JagX0U5U2d7T5bdCC97VTW1jofqbkIJ4RsBk7GWAMcIGDUeSol2Huv5uHLI5rC/oi9QdbQtmcy4fHGh7hic210XYPU6ryPZOBcS0Bwr9OkEwT3IuluAlbYWpylrAd58FwpM+SoSo4d5EpHgSg3ZCg7XNHVkc9b9uhR5IRIrZqoYLxpdyjqBGBiLA7Hrcb6JpAxnKokcv0snUyv47LFb8EvlSyowIkc9gHEcP/kBKd9IMVfjbWGnOUg3MNmMBpv0UX9LIlQYbdZc3coyf0sUoYSSGNR2jG6EBtmjmOpj9EY5YnLuWXNalTJa0X7icdhlSUIgYzLg6FNT2HErifTQY8R+d54jhpYAOSHog+o9tZtKCHyYZ1DuJ29VD/WbqI+or6Sahl50+QXlKZrYiUhfcj2RVc0RFYN+7YHg1yU5NLh8FJqc1LAEVAoGQpCCJVdSVE6F4Q9rwip2l5YqOUsA8OlHISCZIpu7hlmeyhk3myzjbMIfiEcshwOvqStFZqIUkDxhhiqDAxNUelHcOm1lZdGEY0j1MBWCTHMe/h/t1OT+4zZkc2OPmH0M/34l939MkCROhaO27HLc2adM0rnsAk96YNiMx/ZYf8o1/7O3zzT3FD2kOldmo+4+NLsOuF5/7MVxBUn/bdr4no7gUyoYOhpAHpcKelsVJ4CYofmbvJ3aEtC0wqGitoMJjw6lI5Bs5qW5ItrjspXuUsB7chxkjuwo1tBvQOiUA8bDvo44X69nOHEzNmkDFNBsdq7RtnpVsnTv2s3nA2Y0+ZC4vI/k9n9a3
 KaOFwhot
 KF7er4rS8DmlLESMaQ5GQnSZAZwqbMDDijSmw18elfnF1sBNhwL2znxvhuaYTvzqzHB/BU4AEh7Jp/JbZAbGonl63aUWrd0EQn+Ce0dwK3aeHe9C3xhYQ13ENYnn5bEnKnnBOyTiKlcnQPcIw1C1qiZRuoEzsP9EJ/in/t00GNG1kbLFcUkHBAabhuo2NXaKEPdfww/TwUfxoECDVSgO/89E95aYBsdSn5Z2jCgzvD9sVOmIWNgT9SvcFUI5mzxPjLJhwi/g/uRzNXSXfuBkGjwH9Du/p1351Hco4jKbu+x4exB+8/vqUIv2B3LtSIUBeDo5YwxbMpHNrJQ4NQVYgKVwryRnxqUM79DSNPirwRgTMQgyjcrYJqKhP/GSRlebQ/E4E0F6NQv7zYcmcfdzKtzZrA0Dip/pXjbtc8ggW10803bIWd/0xFpMH/EoTNDf53N1Uu4XoVw1KMjLJqWelagQMB3evlbZgQT0yQVeWwHckG/E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

filemap_release_folio() can only be called safely on:
 - folios that are unmapped and
 - folios are not dirty and
 - folios that don't have elevated refcounts

Anything else can plausibly be pinned for DMA/writing, which interacts
very poorly with ->release_folio().

Fix it by adding a filemap_may_release_folio() check, plus move unmap_folio()
outside the i_mmap_read_lock(). unmap_folio() does not need the
i_mmap_read_lock, since the folio is locked anyway.

Reported-by: David Hildenbrand <david@kernel.org>
Cc: stable@vger.kernel.org
Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
 mm/huge_memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 79d400ea9553..7c619c45cceb 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3630,13 +3630,13 @@ void vma_adjust_trans_huge(struct vm_area_struct *vma,
  * still have failed, but remap_anon_folio() must be called afterwards,
  * for anon folios.
  */
-static int unmap_folio(struct folio *folio)
+static int unmap_folio(struct folio *folio, bool locked)
 {
-	enum ttu_flags ttu_flags = TTU_RMAP_LOCKED | TTU_SYNC |
-		TTU_BATCH_FLUSH;
+	enum ttu_flags ttu_flags = TTU_SYNC | TTU_BATCH_FLUSH;
 
 	VM_BUG_ON_FOLIO(!folio_test_large(folio), folio);
-
+	if (locked)
+		ttu_flags |= TTU_RMAP_LOCKED;
 	/* Racy check if we can split the page, before we split PMDs */
 	if (folio_expected_ref_count(folio) != folio_ref_count(folio) - 1)
 		return -EAGAIN;
@@ -4170,7 +4170,7 @@ static int __folio_freeze_split_anon(struct folio *folio,
 		if (!anon_vma)
 			return -EBUSY;
 		anon_vma_lock_write(anon_vma);
-		ret = unmap_folio(folio);
+		ret = unmap_folio(folio, true);
 		if (ret)
 			goto out_unlock;
 	}
@@ -4271,8 +4271,13 @@ static int __folio_freeze_split_file(struct folio *folio,
 	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
+	ret = unmap_folio(folio, false);
+	if (ret)
+		goto fail_free;
+
 	gfp = current_gfp_context(mapping_gfp_mask(mapping) & GFP_RECLAIM_MASK);
-	if (!filemap_release_folio(folio, gfp)) {
+	if (!filemap_may_release_folio(folio, 1) ||
+	    !filemap_release_folio(folio, gfp)) {
 		ret = -EBUSY;
 		goto fail_free;
 	}
@@ -4306,10 +4311,6 @@ static int __folio_freeze_split_file(struct folio *folio,
 	if (shmem_mapping(mapping))
 		end = shmem_fallocend(mapping->host, end);
 
-	ret = unmap_folio(folio);
-	if (ret)
-		goto fail_mmap_unlock;
-
 	xas_lock_irq(&xas);
 
 	/*
@@ -4384,7 +4385,6 @@ static int __folio_freeze_split_file(struct folio *folio,
 	lruvec_unlock(lruvec);
 fail:
 	xas_unlock_irq(&xas);
-fail_mmap_unlock:
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 	/*

-- 
2.56.1


