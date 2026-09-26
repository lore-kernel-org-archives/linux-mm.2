Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16D0BC98332
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:41:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F0396B009D; Sat, 26 Sep 2026 06:41:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1B46B009E; Sat, 26 Sep 2026 06:41:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B9166B009F; Sat, 26 Sep 2026 06:41:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D10C96B009D
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:41:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 574AB160864
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:53 +0000 (UTC)
X-FDA: 85255572906.23.E189867
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 9ACFC100007
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:41:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IgB7NcLq;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KhsTvKQ2fnSXkbWyS/YqLnoRwyxqzmWUbttn/FRcKWI=;
	b=qMjc6gI+dutKcic7doBZjmxvEnF2AV/IopOxbR46uGvZqp5E2cIgOvChwm7QmOrabNnvAH
	Ka7DpBCfoy8WzOc62n2HGTIIQlFY/hbuFdq5x/pCf8IxCp2dL/yalCSgQlFRep1UvuT5Pj
	Sb5ntaWDJ+DJxMv7+UyEl+KzW+pcE14=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IgB7NcLq;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419311;
	b=JNkw3JgSLfP0/BNc8Uj2Z/3V6RKl69ZVLRtfAIwa/dP2VvxNetL219cAU1yzLI/BAfmZ0T
	Dte3N0GAYEKSer57da5SqUb4yr2o1JPMD3BzZEvF8OTmig6yMnPnpIOBoeX0VAyHkMA+eO
	tMrP0FUu41HMF/TkN+sZfZNJFBD3aGE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 42ACF6020C;
	Sat, 26 Sep 2026 10:41:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 911E71F00898;
	Sat, 26 Sep 2026 10:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790419311;
	bh=KhsTvKQ2fnSXkbWyS/YqLnoRwyxqzmWUbttn/FRcKWI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IgB7NcLqpIid5a7MCnUMmAaPtKTkayne8jLDSMRHZx1NqxEy28NQKIqqBrt0kwUsH
	 b5E7ISJiho2wtth7t14TdP78Czhi0m2aaVU46ti3XZ2s9NiPIXuYIZqBI9IVeuFTAQ
	 3B4P2xm6hgkmMtW2iPxKpO7XQPj0CPKepn2CxcLChKM8IfWc8/V43sabGia/2CONjN
	 vXJmFU8Aa2uEMCUpSKmgh6j/AZY30D2+sEBUaGhTNIceeWCrK216ttRkZ+8Ahs2ssF
	 T+WlcsrVxx9rA21TPxnmq+NDdoRaXN3nmOOgJMBEaNx73SJSFKP7jBJVqMVLoEWGGx
	 dttV6cWAoZV7A==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 26 Sep 2026 11:41:11 +0100
Subject: [PATCH v3 6/6] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260926-map-private-dev-zero-v3-6-d4781e84ccfc@kernel.org>
References: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
In-Reply-To: <20260926-map-private-dev-zero-v3-0-d4781e84ccfc@kernel.org>
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4165; i=ljs@kernel.org;
 h=from:subject:message-id; bh=1leVrHr0vQD42BeUriV2AqaMbiNFdZlxKm+PRWQ0Ih0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLK2L/SREO95sLjfyzgrouFDrfeE3dqSro5pNZGzGZ9n+
 FT4iJp0lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCKKuxkZOiYvr8vK8imSqFlU
 8UpTYW9Zeu+KjWL9Qe51bNZezl6cjAyPA00aN+Xd1r+4LaIrQa/NWK/2fU96h8VzkaOvGUwSvRk B
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9ACFC100007
X-Rspam-User: 
X-Stat-Signature: u3f89gxikdt7tihig6ztw3ax8r9859z6
X-HE-Tag: 1790419311-382984
X-HE-Meta: U2FsdGVkX1/eRAQRlBcn2kOVDy3yoW6YHymVAojeyH/BuaU94CjLcxutSHhp6uQwdaBGyk4YE8dp7a1iiedc2K27Bw4q8QPZzgzP6OuTHOSAg1Pon7coEIs69DeA9ga+oOBfmfEw/1gfYecky0qi+0XWDAo2WCeswZ2AJ9DZI4NvXY+fKH7jmSsfLo6C3CqxaLafej01nKcDnzmnoFZhtG8jXFvXUdr4hRRXPPqLSfIGM7lAuzj7qJF//CeWAlYENnF5NqabdoEv1ZYMlliZX5NaoaYnL4FfmDIelNEjwCOsy0LJhS0esZ7RchzuMi7oLmW8UlodlVhYhr7Llk7R85rP//k9wHpA4MAkX4+SarW4NNfunyJb77VOF8ooRxLkNRIA1mUZTbIUDeszIO16ivLhFwDvUo+QRrflP1IQpcDxWjiIh82GLIUjR5KfRcyY322VNUyW9AavSHGZnDE7mjKFGSWnCYkVWOoU9zVkLQr/C2dDp/53CCR+Ie0QE8z9IZkArbVRnZ9mkzoB68GLCDStlf65byVYpd/6m5guqjOTcBPhkFN9GUpZFubex4ZLxMVhC2SoJHPaP4BtN7GBfedfE+SoCPrr6eXd1qGRRHhPQ8cf2qvdQ1IPVh4C6ABNpQFh62cjz8MB9RPGtfnDpXHE9qGwoq71qRESVfb17rCGvmG8+KysIZXRUtNhXjEtSBDzTwAr1orNBrQxCZVIqxnp4qu86DNOytizb2/ngh2AkuB1t95KYaZ0ngy1ezvCst1pC8LZvYANbLs1RtGh4lv92PVX44MdMnVoOjD6cjPLNo1ffNTk2AEpACZ84Yv0LKbQTWMMuFRloDGyQUlcPOjSTWq4/Od9CrvlnHtpIFtKpZUo+o2CElvGR4NRLL6jsaWuoT2dnoIzxk5mSo3pXeYR3pIZ1xFLU7Vs0mRxDclr81LVTTZgPSs2WEtKsp4ARj6TcHZd0PCIg0/IcrB
 PkDe6aSj
 V9xo2d9lijnfvn39PYzWy2gNr4SNGIYX3WPHnJZcrr3KGeoF+6dLytPeBTsD4XxuETvPMy0zoXx1jIuBh+Hw429EbaqSQZKcp4Ta6/16+AWUmmqWP4joX0tPXa1E27T8MignUstp49J1A97q1bkD2aiTHqUjmy1xH8iLZlk/w2Kp8eUrS0ALP7THBxOzbM7iqf8rzwzYIATAejq6CbUvyg+pwGkUJ/EJ9FJqAxNU9tNzycCXsMMY8/D3CmhlgGwgKABX00hcV7j8l9cBwnfjMDhDpW8e8UD476tgbGebxR1BZOLs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
anonymous.

Test both unfaulted and faulted/unfaulted merges with page offset 0 which
would not merge if the mappings were treated as if they were file-backed.

With the recent change that makes them behave as pure anonymous mappings,
the merges should succeed as their page offsets are equal to their
anonymous page offsets.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 95 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 52b8727b6628..7dd2933417c1 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1362,6 +1362,101 @@ TEST_F(merge, anon_and_page_offset_mismatch_memfd)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 5 * page_size);
 }
 
+TEST_F(merge, merge_map_private_dev_zero_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map two MAP_PRIVATE-/dev/zero VMAs next to one another with offset 0
+	 * each.
+	 *
+	 * With these being made truly anonymous upon mapping, they will
+	 * merge. If they were file-backed VMAs the page offsets would prevent
+	 * the merge:
+	 *
+	 * |-----||------|    |-------------|
+	 * | ptr || ptr2 | -> |     ptr     |
+	 * |-----||------|    |-------------|
+	 */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	close(fd_zero);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
+TEST_F(merge, merge_map_private_dev_zero_faulted_unfaulted)
+{
+	struct procmap_fd *procmap = &self->procmap;
+	unsigned int page_size = self->page_size;
+	char *carveout = self->carveout;
+	char *ptr, *ptr2;
+	int fd_zero;
+
+	if (access("/dev/zero", F_OK))
+		SKIP(return, "No /dev/zero.");
+	fd_zero = open("/dev/zero", O_RDWR);
+	ASSERT_NE(fd_zero, -1);
+
+	/*
+	 * Map a MAP_PRIVATE mapping of /dev/zero with page offset 0, then fault
+	 * it in:
+	 *
+	 * |-------------------------------|
+	 * |           faulted             |
+	 * |-------------------------------|
+	 */
+	ptr = mmap(carveout, 15 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	memset(ptr, 'x', 15 * page_size);
+
+	/*
+	 * Unmap the middle:
+	 *
+	 * |---------|           |---------|
+	 * | faulted |           | faulted |
+	 * |---------|           |---------|
+	 */
+	ASSERT_EQ(munmap(&ptr[5 * page_size], 5 * page_size), 0);
+
+	/*
+	 * Map in a new unfaulted mapping in the middle with page offset 0 -
+	 * this should merge and would not if it were treated as a file rather
+	 * than pure anon:
+	 *
+	 * |---------|-----------|---------|
+	 * | faulted | unfaulted | faulted |
+	 * |---------|-----------|---------|
+	 */
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		    PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE,
+		    fd_zero, 0);
+	close(fd_zero);
+	ASSERT_NE(ptr2, MAP_FAILED);
+
+	/* Assert that they merged. */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;

-- 
2.55.0


