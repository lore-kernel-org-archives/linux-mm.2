Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 360BB606A334
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=IbDeRHmI
Received: by kanga.kvack.org (Postfix)
	id B68476B05B3; Sat, 28 Nov 2026 01:52:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3F8E6B05B5; Sat, 28 Nov 2026 01:52:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A35806B05B3; Sat, 28 Nov 2026 01:52:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A9FD6B05B3
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:02 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D555FA7711
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:01 +0000 (UTC)
X-FDA: 85483608042.19.728641B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 566A5180007
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:00 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IbDeRHmI;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848720;
	b=KrzzerqEzTt6VcCL7FJwhPErYX7UujpjCr/bdBs/XvtPpnYf2ipilCmDcuoe5BzxzkfM0V
	ew2zTFyztq0f2CPAZG4hDbDSCGcHncy0Yi79ayEIBqKA1Mvkdjjrl+OFEKp8gcWuQuO8zB
	6y6V7944yCj8sV6nLuL9k7X/YpwvdZg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848720;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=ghntZnsDIyms+oiIJtxtJvdLipGkHjf4T7iuzfBNPDE=;
	b=GXlZtRvoyh1qf56qW3X/R4pqBNoqNwFBzCERFqDopL4ndE3b9Z6ts7my5tb2PD4IVUGJNg
	XqdT80Y7ernl+IQYNS+WGoVsSn6HxR6YddVuuD+1AfSSMwSK8ne5QzGGcr8C+TZIp2Zqkr
	YN+7j4Q+4lpE4gDK7Cgk/Ums4p1c/eY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=IbDeRHmI;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9B27B442BC;
	Sat, 28 Nov 2026 06:51:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71E7F1F00893;
	Sat, 28 Nov 2026 06:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848719;
	bh=ghntZnsDIyms+oiIJtxtJvdLipGkHjf4T7iuzfBNPDE=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=IbDeRHmIP3P+XskkS0TtBEnDXxkLaxX6NleAq/RGHIg5mynO6mBwZa4WnXAjzdSTo
	 SXLgGXjSafx4klX6h21aGdwEBdhTzvIiMq6sK4Iz70ZackwtYa6gSX4vIjQNLkqqM8
	 N7XwVEjg4ZCNAzNwu1O3/oDsPRvQW4Mn1thYOJvI=
Date: Fri, 27 Nov 2026 22:51:59 -0800
To: Kurt Lin <lylin1023@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi <nao.horiguchi@gmail.com>,
 David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>,
 Eugenio =?utf-8?q?P=C3=A9rez?= <eperezma@redhat.com>,
 German Maglione <gmaglione@redhat.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>,
 Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.2@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 2/9] selftests/mm/memory-failure: truncate poisoned FUSE page-cache before teardown
X-Rspam-User:
X-Stat-Signature: b77zizi71dd9em9bq9fu1wzxdan8qyzr
X-Rspamd-Queue-Id: 566A5180007
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795848720-130513
X-HE-Meta: U2FsdGVkX192J21AW2UH4xHPyZ+GB9dt8y1l5OGllaqKGk1XXUaAcLsvHmqYY8uvRV0Q5YSAl68YacLBvvmV2fpk1MoOSGKORoxcP53Gby9l+bcIvJcMTJn5tG70f3VsMBNY/QItrcpXz5tIoLWkRJq73KWEtLR3vZrR4Ft5kvu2FGalIhOa6VDCOxTF2SZbj+OWk935iMlflu+Bmruj0CHABy0YN0Y3zrjUP8z+oiCZxBvCHLlXfYl9dZdxaUQgt3V09ZCWWMVKUF9xN06tvY+pNR/2PKj4rDkbRyOxtJ0jbsYaq6lsW5WOU7mAhmYsxoDubR4SdN6QlWDjC2Cu4ShD6OtGCbb7EZdiRSOgnBksTnNdfRUHvbW+DNQEn8HHjYmiT/hqQ9F5IENBJ7NBxyOBT72ZNstIAtDTjIi/ScJH7cce7Zq4enyiWOQ+5kobnU+olF9Vt0MYOBdSDuuhUiPHz0FixihnYxfLphO3oxeKg/iUwS6P0Vefa5cF9jEXpB98T8Fdlra5nOxvvqtXBgV7lz0i5XyTjffqSk5ebH3V7m6krnpm0bMPptYwBnENCfTUcxPIRgJk9ZmyCrrVNeP2+ogmdHIzUVnDRBWTM/cGPEK0gySHOyxxu9YeMYtYVou681YvmLThOo9huEeNctqiK3iD+nkF+zTbn0LvHZL/QVv+J5nF4xUFVpQC137gnbyL12oCXU3t6hX4TvzLPuHFHy1Ou0qdpxt/9QOut3oG5sp8rSl9Pc3F7ZkbhmhyQLTGTngK6nZazlo0wheMkbgcOenKv9UAgpJAqS5tSBFgOSyMIX3A7mepwkVce1DyIv6PbgN49nMGRO1tdKU+sXCF89fXJx74llGKlCXLxg94wTA2m2Fte4PrzsMgDn7FZNkHYk/ttDxUds408w4l9shs3Z5RWjKts53rzjjkRoEon0WaTFDORsf4BBGLErPwa0jzilANNwGPKHQtkGP
 Nilw3p5O
 Xo8b3FXSY+WXcamURTuXleVCLGW1qcVHYsIMaYdb8i7WUNdQVT/RdBpF6nGVilhoymgf0g9p/8pGhw9RKMOFp5FMYiIbL13Qt00SZhS8lwQKE56gPaKg3xBdfL/BDV8jgD6EtM+Hv9Jkxe9XJhGV4AcZP+6u/W0eWFYcKuAfKeUVb6CdZRYlJF5YAgWorgNWZDeNIqvKodetvF+RkNa2Fk+k0iPQEjj0fXI/vJ1lyEFIshzk5P6XcWYxhwacoldjsemvdA8cxiz5shAbu3DcG58z4QrvVzarC+FxEwk7xu+K43IORDbejQq/5XQIHGh4bpzAuTKKbZdt/BzbigVST/VVlqITwAe/k/xnx9wnmK0BbSXxlr44bkM0Kx1jePwGaxpfCmuD2iSqm3tx3MtXws+IjQjkhCw5+utllmVTezvYOhEIf0mhxrW414jTE9FnmgqGaUwN7IKa1X8kyGQQ9K6NEgLtVQ5lweLwfnOlgGGkqSMyiAy4bdum5SmaXqL2C2e/hSIyqcNvvO/kVsyJ8ELOBbqHV2nQKuHXSyHJUikdzJ5AcV1lsst95nPs5z8Zyonc+npmOjdZBP8cbErld2f4dndaK4Yjheg5wc9BxBBUkXzFta5N+gBeuV5URRs56dlzZBkDY45E20o7rl3U2Yf1x1xsiqalqtTepUl6s/zHNTt8gohYfqDUQh4s4D9qZdeafcwBKpUwssRChlO5ZyRdFPlgqrIQJC/1IY7WTo9L9pcDrOivuqhif0H8iW10nP0nNyJU+1ajIqN10a6aFac/pGaS3tENQSX5/f48JftivfmMoCeH9pJPaot5507TDQkzAqJUqzhjQwdoiY2e51WYOtW5FISRaSzBhzIXeVEy295yY5h11Eij4TgK9pJ12UTbgwa2wOIVM/xaIueaCirikhQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: truncate poisoned FUSE page-cache before teardown
Date: Mon, 23 Nov 2026 23:18:44 -0800

FUSE has no ->error_remove_folio(), so memory_failure() cannot evict a
poisoned dirty page-cache page.  The folio may remain after close() and
unpoison_memory() can then return -EBUSY during selftest teardown.  In
tests with a minimal FUSE server, this happened in 6 of 40 runs.

After checking that fsync() reports EIO, truncate the file so teardown can
unpoison the page.  Remove this cleanup when FUSE can evict the poisoned
folio.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Kurt Lin <lylin1023@gmail.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>

 tools/testing/selftests/mm/memory-failure.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-0
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -406,6 +406,13 @@ TEST_F(memory_failure, dirty_pagecache)
 	if (variant->type == MADV_HARD) {
 		ASSERT_EQ(fsync(fd), -1);
 		ASSERT_EQ(errno, EIO);
+		/*
+		 * A filesystem which could not remove the poisoned page from
+		 * its page cache (FUSE, for one) keeps it until the inode is
+		 * evicted, which can be after close() returns.  Remove it now
+		 * so that teardown can unpoison the page.
+		 */
+		ASSERT_EQ(ftruncate(fd, 0), 0);
 	}
 
 	ASSERT_EQ(close(fd), 0);
_

