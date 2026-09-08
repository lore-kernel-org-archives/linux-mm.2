Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724B2C79F82
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:25:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5302D6B009D; Tue,  8 Sep 2026 07:25:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E0C76B009E; Tue,  8 Sep 2026 07:25:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E4E36B009F; Tue,  8 Sep 2026 07:25:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 016B46B009D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:25:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8EDFC0581
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:25:11 +0000 (UTC)
X-FDA: 85190363622.28.0BC8092
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1CFBB40002
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:25:09 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgmNxLy3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=om0np5kv2o7p4ujdr2YodlAc5O6JiCLsFWeQl7Rh24s=;
	b=IAOnmSP0LSkPDW9xnM6z6g0qnCKj5ucHmFXFTW698KmvJSn3jHrU6hPA1Tu6mB+r9P0te8
	numFpdiHWwyhQVr17b3ClsgLt37/nSRZt30fMKuWxOOLMtME7FZUA3jvCq2zoVVVHF98vu
	T/R9rhglE0gRgr6Wu0/TeKlvNDwHXVM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XgmNxLy3;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866710;
	b=CPYLOT/fSgymasiiF5FNgJLg1OSoYPLEcUcvP7tTBQ/6AXdYxBkiKnohJEjiDmikXu180O
	Gk0oiz6qPDbpDfBuhAItt/Zi84I6HrRp25FA5lJeiGyWQAVsW6t9BIwrSkBRHp1xMLLXcZ
	0GOsMdvaCjC3T0jBwnbFU/iKB6WtN9k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0AF5543F8E;
	Tue,  8 Sep 2026 11:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C87C1F00A3D;
	Tue,  8 Sep 2026 11:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866708;
	bh=om0np5kv2o7p4ujdr2YodlAc5O6JiCLsFWeQl7Rh24s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=XgmNxLy3XXo6zJi+ipSK9/Kxq68nxv16sLLPsIcI4SUgz9twJMZI81MQ1uLL0ZcxC
	 sd97Rux856rODIB4DkQj/J3btopjnfJz8KZCP9qLUOFtDQ2gQaa0TKT3NTVC4GBxU1
	 sI9BHcnkMlIEvT3Uq5LYGLwZs7FIfAp4e0w3RWiA0yOxITZIYl1/1TqH1gLG9liSBj
	 Kb076kSuPDadjILy/hzduDtUlggkJN6sLYAXYVTZWNmCw9NK5UL2hwjZJMzMYTiv8Z
	 l53JivNcQ3Y6aIvGa6Ww9F6P4pV3Nj1kltUc3JU6Apyk2SY5pGVVxBG5oH77ddyBC0
	 RtU5Qgx16whFQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 08 Sep 2026 12:23:43 +0100
Subject: [PATCH v2 6/6] tools/testing/selftests/mm: add
 MAP_PRIVATE-/dev/zero merge tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260908-map-private-dev-zero-v2-6-acc7b5625305@kernel.org>
References: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
In-Reply-To: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4111; i=ljs@kernel.org;
 h=from:subject:message-id; bh=3png0c8or7nYdCZx23lmGIGRrVIeUt4V+p87b2uuFI8=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLmfyh8seHhftu6/WGcCu07NVd5JzsuVNKK1z46e9qze
 f6bWVjWd5SyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAifVoM/3PfCx6wSxSaVbmk
 7+bO4wwSV0UPetSq1M6ULVgWsuaT41aGfwpzf6lGe8wQfcrt4LPt3/Qizd8Nv+V/c+012bGWz6A
 mhwUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1CFBB40002
X-Stat-Signature: za7mzo5hkce6mh7i1yux81sg5asta9c3
X-Rspam-User: 
X-HE-Tag: 1788866709-959910
X-HE-Meta: U2FsdGVkX18YP/KbavYamtqHa1AQznpQnX0AvPahjk16XCaTHFyY+lGA7dLGVLjz4sGIlEB2AjpnMoNqe669lHsFHBPGSJu5iPXasMCE6MWhZKI/6O9SP64ZHwUOE4VriqNsrE5m8/SlgcJZzgKgb8twWLO4840z6fw7vJEW2Q03iz2l/dDpDxvXJGLq/kHBI19Ig46n/8I30Bhv4QTlaBzjwdQh+QAwtUkC3xmnKYDDEGGvp50451913uzhHHMVVJ2WVAvNJ+6Ol+blaFzYj9vPIaMDJAWvlk8qVKTzuIVXVhsWOQnSQOZvx3zmAAJb9LSRHwwzJHzCweu003HNonm390N0zVP8TdTY2QI9pvYYYzSP1fKcNRHRDV03ZKnge9ocwBHvoYf73OqymWl/u3HlVdqI0LDubg2eg6kSJkVUqv9lad/gdJpfYbJpgD63Jt1BAQj1EwlOAyrClvXpzpJKm4SvnhRnQ1VjXQXZF0W1dOdW5jWecir5CfQshvNurs0pxWonX5xB9LloiyjRZJ881APEz5DtTC5qOAtMp3tlUPv3zcPxbajeQw4oNL9ppMy6EebiEpV/3shivIqZ2HR2RbaHp78+0RedP11jSbDzAabzeKJAVXLY90dIcJe4EpKOEhgyNZKMYhXCSFeQZVG4iaUGr2SwSwOBic9l4/XQQE3cYRpI7u6iGg4lb7V5u6mELAFuI3PYG3AkexjRwU+q0biMMFQ911/JwNPKZRVZCAuUrj15g/47TcueujeZNTSkDXiJ85r7tUrqzFTnMZI6qRip/Y0jOXzHGbSJ7h/yc3iwqrZrDlpSuy6XMS6X2rzqt56Nlydeo0uDEg248TFM37UPcTX3RIq9nz0xfG8qUVTlqBN5i47j+DLGPJiXjoXac1LWok7tGTedCwH+zGcejNrdhbHwmSn91tsaZzVrwW58aep5qAaZBlHNxFT1Uy6tOICYGD3my0KlTcg
 Ick/w9i5
 m6NEns+1Q74ijEIxrCRRtC0Sl7ttAhAvZL459qB5GJDKUKETXtOBfuEsxooIB/mbmgl4zdC0rd930qNmM9f2S53q3Tqu76r3ZOKXVqJVk3BB66vCMjt+8bBUDCNbkvibgOfAtk+FTxRGFtmiOyyUZQGCQ3LmdAfm1RCjm6cfrGSiDyCGJeVIMyJq03vOrrC7P6d0fB+qqf04inY3CrJnN8/IpLPRIPqEv+yRGoLobE8lJ5wNhL9kJJg8Kn0zYHuT/DlS0QxZ6j56Qr1X9d7HuhhZ8104m75/oD5Pd2RiJ+42c3lw=
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


