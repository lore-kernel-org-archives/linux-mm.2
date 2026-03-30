Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C364310D14B3
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 13:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 129BD6B0096; Mon, 30 Mar 2026 09:50:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DAF46B0098; Mon, 30 Mar 2026 09:50:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 017696B0099; Mon, 30 Mar 2026 09:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E55606B0096
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 09:50:19 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B2F9316065C
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:50:19 +0000 (UTC)
X-FDA: 84602863758.22.70DA4F5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 355662000E
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 13:50:18 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFmADJYz;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774878618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=53Og02o0jzsOxe1G6Igm3lmkfHv4Hp3Nwr4/GmvrBHc=;
	b=nwUCWhZ4BycFukjycSRbRxT+rz99Ny9vAVCyOImR6LRmlUdDUrUQddiCRgxvW3fr8ynQKA
	h/tBoGys8mRtllO9OFya3z/09XhngL9mHz86M1YRg8ER7XE2I8AONfZfI+6xgz+/BnF16Q
	clZQZqN7ubS2OlStTO9ov72XPQH6jac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774878618; a=rsa-sha256;
	cv=none;
	b=yrFit6O/vTZrliRiviIzfe86tpzOIcyWLKDr6z/Pxkv5Su0zhmrSD6yvtJcVM6upZ/wtky
	QAhAjIu3vbRuUb77wveHXXjqKnMt3sEiZhN9C2tQTo15Dcnb7qg7h4akqJ34+OpBFQFfiH
	RNAqJ3ObWr3mrMwYIEywWUJ/Bdl7NRo=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFmADJYz;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 34C1D60054;
	Mon, 30 Mar 2026 13:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1B0C4CEF7;
	Mon, 30 Mar 2026 13:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774878616;
	bh=ecHvzGxq+ix6Lw/BhdjBmCYftEzFzAHOTU4CdCj7PLk=;
	h=From:To:Cc:Subject:Date:From;
	b=KFmADJYzfpN5ybl9s5WINuzTr17XoPZYKJPb5oaDW6nNu6x6pM2slYmVIAGXp0Ich
	 Fi2177u43aCQZjRvpCHGfO8WtJ81IXTv0gr+5Pi2P1YwH0oZGaDeulFz6A6e/eDU3O
	 hCFvCdyBR26Xk5Mm2HWbn/3ugPcUJEu/E1reOeUmbCTnuGUFEbHjtIB/ogFloT1w9i
	 VEJgIAOJiHaSmam0qKPbKnYO0+SN2blg8zTW8b1cq70o+IskifcnyNBclGB/bUu5MF
	 cNELZUldfTyFf9N9Lkig7PLZV2bEiZTGi5a7j7UO4tZBsVXTrFGxsHh9JLvvrvBAhi
	 0al2h/+vWnb0Q==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] selftests/mm: add merge test for partial msealed range
Date: Mon, 30 Mar 2026 14:50:11 +0100
Message-ID: <20260330135011.107036-1-ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 355662000E
X-Stat-Signature: csc8u8p4msthe3kuyfpzydmiqrok9ney
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774878618-500230
X-HE-Meta: U2FsdGVkX1/tsFYp+c7PK21R9CVCNnmyfoYXyNSNpmJsMBGsjGjZfMZibp8sfBnWSAsHOEjsbX56PK6TOCtsNitcUeXYe6yV0edYv4TSnbJ81SUraGFyUDGwCkdwW9zxhfojs+jcTlc0O1uFLKupN+DLVt8kAmqSs7l+bs9haTLZFM0qxndenYlT0T8HTIQ13w7tHgRKnBroGosrUP3zfvjEItIBlTDirNdbLgWBomzVlYmg/O5PvDk5LjQ4K9R9Z0/8KxezldLiZ8Hur2vrhAVRw2z4thkjCXYG7+f9CMS82Dp+cPBekwWCprHzJETZkXsSpR1nyKgjffxX+leJ3wtkPMDZvGf6By3zRdVi8nE9uCNatHrmjY6V/VPxPPCsngh/TWdnR2gP1+OBgaqVoU+ve+O/m1WOV0g0ym5ely02Yxz/ISrv4MSQuXIl3k1k7CepfHf6asYkduXa2vXNafGQRSt4VuyEbbwuqteMOVyr5ckXSQigwUTsh1UCbsGBvB2V8D6mpPifeb7iBE594HxDg/6SKFecc2fvpu2nR4r3rdfUM+qQmAtEK+OSLiwx3GEjBirM8jq1InNUVFs2PyHnNcNvv7a/s5Pa3z6PJkCdnl9AhsfbfuMwdPfRfwGtUhvQjkuXBwWsGt7rvTPTK0ofCpkk+5gb6WhTVj/1I4jy0pJB+J9JVwnpc/MIhSQfusRFljxO7WHubw1osoy2AdYWwFbSbDNGWryfxWemdaRuumFDxcbXx1cF7qMn3Ze3mcJe6qu6uosGGfHmBGPAkgbB1pP6vrS9/N967FvdrMLEQ4WXK+yMWaVrXKAbS7U0SSeKPlT8FM+2V5MpTUWm9olf8SHzh+b2pdkNX0ouTDzGwOclwI31nYc1F6JhGB/tXXDctwD4+fTMjVAYgAuZ2dBp0lISEsBarON4dDKx3jdqh+Cny4CjxK830sp77dpPfPWwIBPo4TcJsJH9Pdo
 h5tptR1j
 sl2P5syi1bbUfxH/eP+FbhlipfBHeEtLTU7ju6+bsIzxJvvM8FuHYSy+n0oIZ6zjbFYNf0hU+JNa/mLmGCGXqoCjgdpEM4W1LPjsu+IxyQVd/Dw5RuhsK0UTclBb6hc7WLKRbAz0iOjJqkxiHU/Kn9qEmrsfunKrsLQByZYYNj01Zn1wLYXp2cV/dK8qic2HwFfYygHzYH2F8uJOreHuL1s/bbMmHmkIRoq7/y8jPPKJbpOE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 2697dd8ae721 ("mm/mseal: update VMA end correctly on merge") fixed
an issue in the loop which iterates through VMAs applying mseal, which was
triggered by mseal()'ing a range of VMAs where the second was mseal()'d and
the first mergeable with it, once mseal()'d.

Add a regression test to assert that this behaviour is correct. We place it
in the merge selftests as this is strictly an issue with merging (via a
vma_modify() invocation).

It also assert that mseal()'d ranges are correctly merged as you'd expect.

The test is implemented such that it is skipped if mseal() is not
available on the system.

Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 75 ++++++++++++++++++++++++++++++
 1 file changed, 75 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index 10b686102b79..e8b8a91123bc 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1217,6 +1217,81 @@ TEST_F(merge, mremap_correct_placed_faulted)
 	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 15 * page_size);
 }

+TEST_F(merge, merge_vmas_with_mseal)
+{
+	unsigned int page_size = self->page_size;
+	struct procmap_fd *procmap = &self->procmap;
+	char *ptr, *ptr2, *ptr3;
+	/* We need our own as cannot munmap() once sealed. */
+	char *carveout;
+
+	/* Invalid mseal() call to see if implemented. */
+	ASSERT_EQ(syscall(__NR_mseal, 0, 0, ~0UL), -1);
+	if (errno == ENOSYS)
+		SKIP(return, "mseal not supported, skipping.");
+
+	/* Map carveout. */
+	carveout = mmap(NULL, 17 * page_size, PROT_NONE,
+			MAP_PRIVATE | MAP_ANON, -1, 0);
+	ASSERT_NE(carveout, MAP_FAILED);
+
+	/*
+	 * Map 3 separate VMAs:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWE    |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ptr = mmap(&carveout[page_size], 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr, MAP_FAILED);
+	ptr2 = mmap(&carveout[page_size * 6], 5 * page_size,
+		    PROT_READ | PROT_WRITE | PROT_EXEC,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr2, MAP_FAILED);
+	ptr3 = mmap(&carveout[page_size * 11], 5 * page_size, PROT_READ,
+		   MAP_ANON | MAP_PRIVATE | MAP_FIXED, -1, 0);
+	ASSERT_NE(ptr3, MAP_FAILED);
+
+	/*
+	 * mseal the second VMA:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RW     |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 */
+	ASSERT_EQ(syscall(__NR_mseal, (unsigned long)ptr2, 5 * page_size, 0), 0);
+
+	/* Make first VMA mergeable upon mseal. */
+	ASSERT_EQ(mprotect(ptr, 5 * page_size,
+			   PROT_READ | PROT_WRITE | PROT_EXEC), 0);
+	/*
+	 * At this point we have:
+	 *
+	 * |-----------|-----------|-----------|
+	 * |    RWE    |    RWES   |    RO     |
+	 * |-----------|-----------|-----------|
+	 *      ptr         ptr2        ptr3
+	 *
+	 * Now mseal all of the VMAs.
+	 */
+	ASSERT_EQ(syscall(__NR_mseal, (unsigned long)ptr, 15 * page_size, 0), 0);
+
+	/*
+	 * We should end up with:
+	 *
+	 * |-----------------------|-----------|
+	 * |          RWES         |    ROS    |
+	 * |-----------------------|-----------|
+	 *            ptr               ptr3
+	 */
+	ASSERT_TRUE(find_vma_procmap(procmap, ptr));
+	ASSERT_EQ(procmap->query.vma_start, (unsigned long)ptr);
+	ASSERT_EQ(procmap->query.vma_end, (unsigned long)ptr + 10 * page_size);
+}
+
 TEST_F(merge_with_fork, mremap_faulted_to_unfaulted_prev)
 {
 	struct procmap_fd *procmap = &self->procmap;
--
2.53.0

