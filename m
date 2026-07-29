Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F1D6C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 16:51:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BB5C6B00B2; Wed, 29 Jul 2026 12:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 990706B00B4; Wed, 29 Jul 2026 12:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CDA66B00B5; Wed, 29 Jul 2026 12:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB9D6B00B2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 12:50:59 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E89C6A0709
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:58 +0000 (UTC)
X-FDA: 85042403796.24.5560972
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 162ED40006
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 16:50:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqS5fVQ+;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785343857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWJHtHm2mvw0tY/QnZj2f5XpVK6B5wNlaZlDmcjO+WA=;
	b=DecgpAA30PIBzy00j/KBsxotiZYXzK3gwMzzgcI3EXfsBdshs8HXzBb63kZ8xczzEJlbJ/
	+qz4cWGGYLqu4efNgbVKnX1B2WhjzPP4O1yy3o6oZZFhKUkv8zlpQxzxp5dV8FfU3aWpwV
	JZ1wk2U8sFSkZgX7/h30VK73SZ38Qy0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785343857;
	b=Mo3Qp2zm9UYeHmbxfLs+ByULTMCBEHghqXkslNrUKbHFSQysibFmXHqSZiWMHS3jABY/Ge
	ZimQRbVRbu42+MsdKaneoERYnF93e8yACST1rWs69zTC2Z9fSWiPn4N1qiHaCbMI32bLgS
	nUsTG5/jnpqcrCu/OqCZtIFdGqfiKfM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IqS5fVQ+;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 502E840978;
	Wed, 29 Jul 2026 16:50:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF52A1F00A3F;
	Wed, 29 Jul 2026 16:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785343856;
	bh=nWJHtHm2mvw0tY/QnZj2f5XpVK6B5wNlaZlDmcjO+WA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IqS5fVQ+y3ZZ2N5Vr/Q4co7+X02q/Oib2UfIB/EfTWcBAH/PnfXti6gFutTOLbZa+
	 V39pmznwtvO2xYdBRFV5A7x0BuhheopM8E31gYSASbfHLXXiTIvHsgK/wgQywgm4lA
	 dajqHTdLQmryFkkNV9yn+ttMR2myR/a8+TxUu+Mf6T9W+KVl5MuvREpdWccjxMTXVx
	 KlLwmsVgR7WeNJ8KqvCmSkLvdX4wbEVebpr+YLKDUZfv8DpUIWab3z0KA1wSJn2PbE
	 Ix9+dEoeUsYoKPUv4sctc4qxCKo1FWT87CneuFLMR/JvZ2s4UUFXeVqKe0cNLJ5dfy
	 ZCBSw9wHXTo1Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 29 Jul 2026 17:48:50 +0100
Subject: [PATCH v3 15/15] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-b4-scalable-cow-virt-pgoff-v3-15-e8ecfefea812@kernel.org>
References: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
In-Reply-To: <20260729-b4-scalable-cow-virt-pgoff-v3-0-e8ecfefea812@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, Rik van Riel <riel@surriel.com>, 
 Harry Yoo <harry@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Kees Cook <kees@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Peter Xu <peterx@redhat.com>, 
 Xu Xin <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-kselftest@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4280; i=ljs@kernel.org;
 h=from:subject:message-id; bh=g78skL6phV+2TJQCh61fxPN8lnG10Yx7E7p8vqTiZXg=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLKy9H6usDJrTMu/trbpndfMe9f3Rzqsy5BcnNBgFWS6S
 63A9n1LRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbybTvD/5Bve7bN3jE3UXxv
 5oobL8Imq3i11TnELahN2dqSVWsvo8TwP2zmPF67Tbn/hUteHN8ax5E00e2v5/lVLWvLdrrt3nS
 bgR0A
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 162ED40006
X-Stat-Signature: m95ast8zo4qytx5741kcjk4b79kkjsxg
X-HE-Tag: 1785343856-700573
X-HE-Meta: U2FsdGVkX1+mz1HmQGLUufxxRme22NWYZU04hUqqlnSvellcW/LIiPDfwHa2tbLAYrOUDclU2jbZJ+8cIloCCM27D3C8adZfewOSkhmlSYGl435hVXC1dDGKBO3WYfi0oYBTIlWqOkfzn94n1Tk/YdtSWbDiwBFudW3xgkG2qpIdCjtkGBcJ+LeOLWZNxBgeKU3fp+RQ/VHlggPSXkSJTdpeBroIVzpgxHZ8obzwmqaMwkneVEjVqoiovexDYZ8jA6ai+4dg9v9pezfTFjNB99/txqYJchm6CYz4Rv6+1epZ1VJv1M74mKrrWYMNYiDiy2sVCxPniyFTu6DiOITBocXugwCsBSOJeysgrbuFwPNlUj4UilyOnFoMX/bqJRFLmshbgWs55/RZVFDKQq7VUe601b63/JRBjP/DJDsEWtB3Yges35EkOAq3lR+ohxZwAURDC3UDJPSOZqSENWH6e+XKuFR3UBpwONJXWUp00zQjJGVSpQ7kShwH8ivvw9j7bMAApdpW1AeiJUCWF+XWIQSOfzk5z1b+F8GQVK64qshVaHDCzgxWoisv88mVysGlY9OFscivGO3K9QEpc4FjoI/mVqvUrtnmfJazM4lWbryFapBmA9ht8RoBUPI4B64bE0B1HN1ulivnwmqvmJw0V6lIc08375Vl7vj0Z1FWgZNpFrniLkqMQMmxL+r141oK+hYKNvDo4MBMIlyagOd3zbnJ5+cWrsMT7ozITOwR0adYaRuGbsL9VxR8H8BsfZelMMihTKwsIZ9mhISBJgRKWCdIWKG0fiDiarye3P6xajaPIzjBIearKedGMLRfqXef5K69DVfZMsgX+Uz6OJB9V+FJM+zw+R47xw1zfdCchHqPgTQOm3JQl20x2g1v4WnifSM5BkseOqcojWWHfgoScpX5FACyQ9k5LJ+8VKOHD1mXezn6MOu+UN1sUEYmw8JuL7uEaNDEHqo4F9bjmqR
 RgAx6bxG
 gZESpGWqEcNvaLrsvf1D+O+Dtym1HSyi/6J5lzDSgE3nrbyIu+cvlDDlS9T6NuSBTEN2Jcotf+U6oecSqU6bGuJsyIU2cgeDImEdQHdUU57Z64lNL4EGTa7lworw//+Pou1mXSG8m8U5T4CjittunFO/riR8X28Nb+yTVtRX1xNbRyk7Rf4wLqOAVVpZdvaYIq53rSwnRSrQDphigjV1P61wtjyDZRQiaWc0mMfSxjDMtInxqgQ4/QmYbJPNIZ+hociGjQAe4Pp6ZgnvT3Nh9dQbpTcRgUz5e7Uz3vwbYqnmF8MSSfER9IZl0d5H8nL3bjmuFUVocfre956H4v8+W/eEoEDbMT1OvL79lJXPVzpFCuOo/Csxjrn91Xg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Assert that MAP_PRIVATE-mapped /dev/zero mappings behave like they are
anonymous.

We test both unfaulted and faulted/unfaulted merges - each with the regions
having page offset of 0, which would not merge if the mappings were treated
as if they were file-backed.

With the recent change that makes them behave as pure anonymous mappings,
the merges should succeed as their page offsets are equal to their
anonymous page offsets.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 tools/testing/selftests/mm/merge.c | 104 +++++++++++++++++++++++++++++++++++++
 1 file changed, 104 insertions(+)

diff --git a/tools/testing/selftests/mm/merge.c b/tools/testing/selftests/mm/merge.c
index cb7cdb6b7ada..19c9bf9eb9ce 100644
--- a/tools/testing/selftests/mm/merge.c
+++ b/tools/testing/selftests/mm/merge.c
@@ -1362,6 +1362,110 @@ TEST_F(merge, anon_and_page_offset_mismatch_memfd)
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
+	 * merge:
+	 *
+	 * |-----||------|    |-------------|
+	 * | ptr || ptr2 | -> |     ptr     |
+	 * |-----||------|    |-------------|
+	 */
+	ptr = mmap(carveout, 5 * page_size, PROT_READ | PROT_WRITE,
+		   MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	ptr2 = mmap(&carveout[5 * page_size], 5 * page_size,
+		   PROT_READ | PROT_WRITE, MAP_FIXED | MAP_PRIVATE, fd_zero, 0);
+	if (ptr2 == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
+	close(fd_zero);
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
+	if (ptr == MAP_FAILED) {
+		close(fd_zero);
+		ASSERT_TRUE(false);
+	}
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


