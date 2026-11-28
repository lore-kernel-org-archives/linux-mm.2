Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7194606A32A
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O7lZYwUQ
Received: by kanga.kvack.org (Postfix)
	id 415786B05B7; Sat, 28 Nov 2026 01:52:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 378196B05B8; Sat, 28 Nov 2026 01:52:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 267A46B05B9; Sat, 28 Nov 2026 01:52:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 01D046B05B7
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:10 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6DBE280428
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:10 +0000 (UTC)
X-FDA: 85483608420.24.C8CF3EE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id E9F66100002
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O7lZYwUQ;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848729;
	b=O7wxRdHdTPzLu0tbtyK8vHaNti2oQFRb6h4MpA6DPFjh5oYExx4gLNTXcenUMIfmcNh6X+
	5dM9hZIE0WP+fsx/PvHFD1uGz2+HKom/cXaGpSY/Q4UHl26hhySzPUyFO3+UvCQUbW8GoY
	FevO0S/iwKn8jWIIWM1Gwb57E6cm9Tg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848729;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=7l+FhyvjXsxtRLlxMGni4qPXBC+DaP7Y+7PoLZogouY=;
	b=UFw9CI9qD7EM68YYCAWJBh3nOHJHRjjlBaUsPA53Tb0/vOUToFshf6pSQWu8I6xKtXrIdp
	zluvWVE8KcdCcHd0zwgeNvi/nMmdhW8//2xeapmEWWFgk6eOY4YIYdDvus/bj3Isw5bGgJ
	FCR/TKTo2p6va2WBvSkPUpyP5a9OZMo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O7lZYwUQ;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AE2D7605C7;
	Sat, 28 Nov 2026 06:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57E2E1F00893;
	Sat, 28 Nov 2026 06:52:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848727;
	bh=7l+FhyvjXsxtRLlxMGni4qPXBC+DaP7Y+7PoLZogouY=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=O7lZYwUQ0M3QDavYtamLCQF0OH0asbdFcGceaJo0Lle1d7H1xhGEnhOlnl2tWqBrY
	 G3Eej/9+angzcUClurF716P8aBa8CizwOU4kzu8l+uVwl0PO5GeyxCQTOIDzFoND28
	 HE8/Y58xaYyey+WBPEaAPwzU1Wbc2nND/lpvi/V8=
Date: Fri, 27 Nov 2026 22:52:06 -0800
To: Kurt Lin <lylin1023@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
 Amir Goldstein <amir73il@gmail.com>, David Hildenbrand <david@kernel.org>,
 Eugenio =?utf-8?q?P=C3=A9rez?= <eperezma@redhat.com>,
 German Maglione <gmaglione@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Miklos Szeredi <miklos@szeredi.hu>,
 Muhammad Usama Anjum <usama.anjum@arm.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Ryusuke Konishi <konishi.ryusuke@gmail.com>, Shuah Khan <shuah@kernel.org>,
 Stefan Hajnoczi <stefanha@redhat.com>, Vivek Goyal <vgoyal@redhat.com>,
 Vlastimil Babka <vbabka@kernel.org>
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.5@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 5/9] selftests/mm/memory-failure: skip hard dirty page-cache test on CephFS
X-Rspam-User:
X-Stat-Signature: d3msuitnjm9e9jogq7y5nfuyfkg6cn6j
X-Rspamd-Queue-Id: E9F66100002
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795848728-733092
X-HE-Meta: U2FsdGVkX19h/2qSHWCaVQkMZju3ev0IhQB9dUPfI3T3n6acmevZ0zXPDCHm1ilD+Q/VCH6oO3p8P8OrR2LwVdm03wxdnkD9hTL+GzeSLlh8mCpylApcYAQDwDCuy18/G9MXBP3wnCaCxWhBbE/tfQ7+rfJXPXSQ7p7X0h/C2V3wSg7+4j1p4jEb7UjQ3wDhWQxtUn2VuOW1hn3usB1qleVOqxdA9IHfvMvYovZvDPDvjh5qH8pZs28UlII5qpHxfyOb2PK6vbcNWm2WEcJkzXJfc686Ey/kVYy57061V/tYbmyf53l6vn885hsNE+1r2X1sQ9FnMqvJtAxGbowKTytSJdVKobiiVGS8RXZhtRAn6mPhxraSTzacD6H6rfJtYCdsuT2GHXlrocC4CfgsGChrq+4aNSdOuir2fUYPbhDHyRCmzj8VHDlUF7vmKiojAvdPVaBi1UEzi4WPbAewd9/68+kF4uLc0sM1goppxwocmqA9wNV3JZ4rDE8j1rpHaPaZfko/PPqNcBpPfa3f6CnT9raZgCKPKcboVIqBU5Qek7hKFuVypQSbl80H9Y9GGsvoA5Hg5zMa9PZx10MaZMF6NAlb3wSN47IfA8MPsx4Lh7VWVeLHUOxTr+oeacW9pqTiHg9jW1PraBzlnpWL9eybjOtOiVcMHXXqN9/DgMGvMCGat3l+HMSqT1p4GF7w3R5MMdH2RqVv3VJjsdtyFcW8aLFOvH89ulZiEPbSkFIrY+bbwTQ/i0XMOpnsQVLuNcWSS+UVqdXBzHznoTrq7PH25fUq6ZFMdLl9m7xKNQFxcZGYKU8y7jh3FzwjZwSh70Jnd16jmSX3yQ2j+Fzjuivtzt/UEXmRWGoeotOvtdkyrkhoqJwCAPNU9ymJBFZF6+nj29JujDs950LIQVD0hi+WLWyL/QcqU2EoJtGgnIOqoDIBz0ji2P6cjGebgj47+jWwprGgpKmKp3B9Uog
 pxF85eup
 z0I2mnj941bACYLdnwijUTcawzVN7m7+yMEm8yKEJw5oKcxvPdk+XrUWEKsamaOXD3kbu0HN/rym4QblLRo/MCzTB32dms1/YVnvu3wVFSi77HAb94dtFjngC6SWilweQPsH/VyQY87nFlOtxQxDw3ShWkVASXuD8lG0PI/8O2pwCu3JksR+/tTZy2GmY/mR+eXSSkNRtUSl1aWGgd/uRVnCtwiN3hBTj9O6If878R6aUWVgKMm8R5eQnEAM1IFyArDcqBrVKHVPnK0eQJpd6rE8idB+Dh9HdsR4yfDnNsuvFtcKr5ie844bwecUHck+KpZVrK4dRFZHgZDOXujXWJ7R5F89FLPgPsp6OwDTI3HuPeJvGVc55cSZLnsCNpbI2BWATyJm2MOTKwo6Y1fu7HBseJX4+gibez/lPiUCiYPh+UEeUe26tt5pv25hqJXi+WQZteI6guoYhbXutY+yjlNPkZuWh/1R7/21eo6DX0VZJ5cblYmf1ea45PlZWl0A5F6RdGZ9KzSEX3hzZR8ZOsks88TdjZfP/RHn0Rqdd/kdCs8Q+QBGcUlRGOp+xdfhN5Oe4E3HqUwVfSjS7uV48/Fd9DEcmgxqy/CUakzz32hmbu9a+QYDJ4SKvbF/tOndn4+FAzm7V/xhX5XFSVu4R/V0cMq7rj4irtc1I+fBpuq1GoLLKxoTcxgk2VM4sHUgP1N+s8cfQ5/brOaMatr+yMIvfIdNr96FXSHn+XrGlzuL07nBvN1TVc87LyET6excAbTc19OE36wW1+bloB7hX/Bq/EQn6cJIRAdeEwtNYjyzq6UzsRejgSBjZU0qiyJnuqeLj5oNmZ2dlgMzBywqYJ8eTs0hz2L76Sh9+vrpayENF9nK1dv+r0KRB+04iKSYpbSJPolvRgJShLzRvJHnFn4mNrg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: skip hard dirty page-cache test on CephFS
Date: Mon, 23 Nov 2026 08:29:47 -0800

CephFS loses the mapping error from a hard-poisoned dirty page:
file_write_and_wait_range() returns -EIO and advances the file's
writeback-error cursor, but ceph_fsync() overwrites that return value
with a successful ceph_wait_on_async_create(). Its later error check
finds nothing, so fsync() returns zero.

In a CephFS QEMU guest, the hard-dirty selftest then failed its fsync()
assertion. The page remained poisoned, teardown returned -EBUSY, and
the following soft-dirty test died on the file left behind by the
failed hard-dirty test. The soft-dirty test passed on a fresh file.

Skip only the CephFS hard-dirty case before poisoning the page. The
other CephFS tests still run. Remove the skip when ceph_fsync() reports
the writeback error.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Amir Goldstein <amir73il@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Eugenio Pérez <eperezma@redhat.com>
Cc: German Maglione <gmaglione@redhat.com>
Cc: Kurt Lin <lylin1023@gmail.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Vlastimil Babka <vbabka@kernel.org>

 tools/testing/selftests/mm/memory-failure.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-3
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -395,6 +395,15 @@ TEST_F(memory_failure, dirty_pagecache)
 		close(fd);
 		SKIP(return, "nilfs2 fsync() does not report poisoned dirty data\n");
 	}
+	/*
+	 * ceph_fsync() loses the writeback error recorded for a poisoned
+	 * dirty page. Remove this skip when it preserves that error.
+	 */
+	if (fs_type == CEPH_SUPER_MAGIC && variant->type == MADV_HARD) {
+		unlink(fname);
+		close(fd);
+		SKIP(return, "cephfs fsync() does not report poisoned dirty data\n");
+	}
 
 	addr = mmap(0, self->page_size, PROT_READ | PROT_WRITE,
 		    MAP_SHARED, fd, 0);
_

