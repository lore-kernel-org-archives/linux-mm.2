Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D968BC624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 18:01:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EECCF6B00DC; Wed,  2 Sep 2026 14:01:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9CB96B00DD; Wed,  2 Sep 2026 14:01:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8CDD6B00DF; Wed,  2 Sep 2026 14:01:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E0C26B00DC
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:01:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2A910120349
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:17 +0000 (UTC)
X-FDA: 85169588994.14.37EA753
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 54E0FC0015
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:01:15 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1FKV9YY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788372075;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gKMN/4ga+akQkR+gCUDsGByPhFMGOkvrwnVsmryglD8=;
	b=W8hy6/bpIGTYQ7YQmXMb3XqMG8iMjZyr9a2okc8TN4QbNn6SxyL3IVwAMll5qymBzieCU4
	bonqZQCxhDf0pu+UPs0FnNBHk7tJvOxps5GdNf2qfn2uz77V4pwwzqGkuiBSoqyzxKuTlL
	yum6wpoCPC77+eKlx3naPW0CfZJY7oI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788372075;
	b=Tg4lueIv14TZ14axDGSrJXQRZWVExyjvzjUyItaW3wvgNJOU1I9/SmYFe7++yV4a8yXDFh
	GTQDlF+vm8ooKRta3eSJabGKCmZ1Jd7uuR1PO4efx4vjwGdNZ6ajZvMz8XnSdMt3+f+9wm
	zsC6RJLt1QNjvLE8D7E/F/WgAaNelco=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d1FKV9YY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 95DCF44506;
	Wed,  2 Sep 2026 18:01:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72A4C1F000E9;
	Wed,  2 Sep 2026 18:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788372074;
	bh=gKMN/4ga+akQkR+gCUDsGByPhFMGOkvrwnVsmryglD8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d1FKV9YYgYwhR45HYlw7ao5vs9Wvz7PH7HdW6abQ3+PLbGWWvZo+3YkL2712FNcj3
	 eFB3FqAWjSUj+yOdKG8HVSn91Hj33qCCBkTf4fY5KlCUwk8LWC/p+mBfsSR5DnKUiv
	 zhJY6+WmVzQqCI3nQq9Be6MCrPz/Eynxla55ntnaJM6OZU/sEqproc8yvTFMEcQWrQ
	 eG87GbKzRQfMfugp1SyOaQoerezIFaaZibVV2aRufhYlYB6wVAJNTzBiQo8Z/9TAeJ
	 6/I5figxrew5gszJrQH9r3n1eOfh3ulOJKEDhuPwsCKtrOg0tOiipteEvSpi0Rzec2
	 kmSKNsyOBD/9Q==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Wed, 02 Sep 2026 19:00:23 +0100
Subject: [PATCH 6/6] tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero
 merge tests
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260902-map-private-dev-zero-v1-6-a578c730cec7@kernel.org>
References: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
In-Reply-To: <20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=4280; i=ljs@kernel.org;
 h=from:subject:message-id; bh=6y4SgQpQz3RLpexZGYRim0KFzXiNKV69KBfjEhHHVH0=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLJmpHjNspi7c//R9qnWvN3MzKq2h9cVHb91el5GlePJx
 AUbDF6/6ShlYRDjYpAVU2R5/kV8f5BI2LzOC/5uMHNYmUCGMHBxCsBEWhMZGa6e/NO3dpKZDHd8
 SbPov0Khpf26ryc8Xx3y77RUo+xE11UMf6XV3rybEF3BPn1ybYZMjtSSYidPjSe/6r7wZV45bLb
 gGxcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54E0FC0015
X-Stat-Signature: 8dhyn8wg5gmwd8o3qsoeki5ie6dz4h8k
X-Rspam-User: 
X-HE-Tag: 1788372075-746312
X-HE-Meta: U2FsdGVkX1/2ky//WWcU8YB8qFpUyKpoUJlq83k7OwOr7HDf/+rLfzHxdPnK4e/gmKWEQHEw+Cocyi3yivvIbke4k77Nx2GMP86bSrT62mNumjmVbOcH/Sggt1PPCMIxZ+XBHl8Kdj9aynRn8x6a/+W5PZ13WIQ3V5IhVMFNEYAjKQvrm654hIGhawuPhGTuQ3A9ycna0nygwoPg5gwYNAPta/rblwcWd5rGrsUmcLyQLoR0fJ495H4icHYEzzF2nnt0mpAFvUeGlubYqeSKlIi1XSimwIvcYqHKpgxiFXrdR4NOBLAO2yXbjTsYVIStT9TaNuuPk2i2p4Ks+KcoeOCsGfSi+4jrmxP6yKQz2S8auyXfLP87tAjJ0oSBNx1WfbdNqP5sZ79c24ayK1Wa7udVKfI8ug+YTGiSIEUltb5Dt2lSVLLweC2pCAOLHzW9uWQhrN9+wPSEPTiQuPi4MMuIUTI5UXwxNWwop0TVqYNqTewIt1VaQH1Dfcn/ieWxB1VmYSp0MSj5dIxBmfrvXjcotLuUH+Qwu4YMu+3k9mM3itpGama+02ZIkk3t8buiCI03mR0vcF4wFaKn0MJvkgBo9nKT5zN9duFpTIDAbaKmXLUfSuCcTulkUTUb4kguHzZKJhysx/YltJKWXEHTiy+PqILS1tCDrETxdvgGmTFRnkL+moLEhxGCpq/Njh+y6xKIgSbJslwkVHSDNPhd5iYHS/LFfoJ3codeUhmf8SyeTentPReAyO5c89qOmmHJJLs5xaiSIGM7DyAkk06c8Gk33L6hJV/hBu8L+r+tpxKfAHXsZA/7iWMmNlnbEcbNhQ6bkh1wLM0CzDcG1ehDQ7e7p93bW98nYOB1CRt20L6b+/+rI/TbJD+btW8Wex25QEh/jgC1Eg8cH0qrz19a234Z/AtccDl7sbjkfxDgWQM0SIBCFj2eoImsKdRf6RIyx8sfJelvsWZ2UhVn+9+
 xVyqnTdf
 xQdYYJfvlOHuICtM8TJwbVq9VWhDp2ueFyalqs17QVFgJ3bGo+hi9v0VpxcRJAmagvz62GCIUpRReg+yctJrh1D1xpVVkzTBs+03+DULmjtlZV/9J2H6LN8yRgyUmYpZv9lqfW95OANEpjJLfGM+LTYjgNPzg6PKlP0DJtDQHAjcFj3Zc26BuqdBjWZW8olGSEq5KZuNUcm6WfQ7luiZ1ZxrXLaXmZjJn7y25vVEqJuTjfoRVlumxwzCuQeVZyMno8ZyMEJ5zjiQKtKQGdwdcBQAgd85UA7RBITKs1G62wCq4Y8E=
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
index 52b8727b6628..7c528d470404 100644
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


