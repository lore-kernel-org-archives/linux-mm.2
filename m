Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6856606A323
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=bfPq+iQp
Received: by kanga.kvack.org (Postfix)
	id 8F7E26B05B9; Sat, 28 Nov 2026 01:52:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 881A46B05BA; Sat, 28 Nov 2026 01:52:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 722236B05BB; Sat, 28 Nov 2026 01:52:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B2E76B05B9
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:15 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DC5FC1A05B4
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:14 +0000 (UTC)
X-FDA: 85483608588.14.5A3FB95
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 6786E1C0003
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bfPq+iQp;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848733;
	b=QorsOMb5epLnDWcJPbivmRzg3BYhK75tc+D4gninmxB9pQCsldr2KMFzkXoCERFnrh0AvW
	ffr8di2NjJZGKljBJz7knCWGnLIQz39icl/dcBhwTMegLnqqTJhPerN/K+vI1uVw4CYNGE
	jiiD8HrWTQooKr0vZyxLLBHWgMFk53g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=wNWnK59lEuheBoChTaQMucwiGhxAZ8YquPTuGiD1DFY=;
	b=q0js9q4oYzeEFMW9jwU1jSed3qx6gSARiC5mD5ymM1kOBFbMm3HXqs2+ADb6rRNJNNWuqR
	XaXdHwoNqFPQ0wdQZgtJGPM1qGytu4xyf1aoOIS4fexaaXPCecRY/80nxJRs7GFN8fIPdk
	sX2A5ZFhHFSPSamUEPoOYh++lFWWD8c=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bfPq+iQp;
	dmarc=none;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id ECE4460F25;
	Sat, 28 Nov 2026 06:52:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973C91F00897;
	Sat, 28 Nov 2026 06:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848732;
	bh=wNWnK59lEuheBoChTaQMucwiGhxAZ8YquPTuGiD1DFY=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=bfPq+iQp36L+vKyYIrQz869BWD9SVM36JGiJW/yTdhB0c1JPi1CA5txv9YjYQyu9e
	 cbvBvhmDZBUnygSYLgVX/geARVrFzCDzvskIV5F01HJiN1KQxK4GvXoCruUIx5flvq
	 CP4dlMQCmsqhO9lB7C0eyzDk13qU1JotdTX1r60M=
Date: Fri, 27 Nov 2026 22:52:12 -0800
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
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.7@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 7/9] selftests/mm/memory-failure: extend page-cache test files with pwrite()
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 6786E1C0003
X-Stat-Signature: 4niaddctphpbxg1py449zhqsp1ktszxh
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795848733-264436
X-HE-Meta: U2FsdGVkX18YfZg4t2xjlUfG3KkSQx6Tg1LRXUGlXujPlBQ5ArURInL2MAlfOr/EkkpX5EX467MwD18+d0afV+ULgWITGoWKyljWv1s+AC26b7WVbZhpWFVTdZ80l/md7x7ZZOt46yQVS9w6ld3ott5vh0ibRONkeP5qGVs9e5dHhFtdnNqoG1qGzWZg1BTQYnbT4VmBpQGElrM9OwMwOqchY3hnn1I0foWKIP5IyLy53Q6F4R8xeWRO1nr+H41p+OidpCJClbDhyzlNWeZxj3on5/y7QXVia1Cuejfal7PkHnlb4bEBX4qtdNDJ5N9Ou+ygttAFvyhTQghP8/G33GbxBnPg867TDT+LVHLTgRx6nx6eTZr7ejaHx13nAQjj+Dm41YiqENj7NVJ74foIg4sqJI++ExTRe4b5ciIU+BWdcAX5YL6N7vGGurTc8a9xDXNyXl1CfqxWhJMa/cHifZD0TcgAsxjYQ05p2eEKJTx9yjxV9G6ptar3CL9N+NmnKgHGCeqiLwHbxbUBvc2EBnoi7I60pI9mdnhZ7f/infXXtXJ6AKiHWT8BeYXP+6cF9Y4W2I7iwfJ7Sf331Muw8gXtfiZBPxafxa7orWzdBmVcd75MNXqTrA8aG/BlSQAV9FJhAhKG7ZKPKYrazUYxvYHi8TZuAQzPDd7cEMufNlfcFT2fkLvWHvxZq6/G6iAYkgqw0n5ylpH9K7ZXRpcW7t9HpPaM6mHTteNmm4jqvHpeiRJWFRywAzBKl3tGI28yMJIY30nnsPqzkfliwrJrpxZj/ShdkaMquO8jsLO+D0QaNTCHKfbb+PMwXc6gdy/CYQT9wWxauyBkh0GBY5i36vh/UX63X3mvotkDXWtloHJZ4rqlCs/FQTKYSRhT1O9O053RcRwxsMeqanWssMCA2cRn2NwDFfFOWC8bWq37bAto6XKu5g9HtBOffXnY0IkYhFS/+H+n1LmhYbV90/O
 HjPMuFDk
 2UCxxT526hLoMWARts/ge+EMB6uU1otVx+cmPgvFn3SYQMU0OP6n6lxPytmJv+xAAgL2fnDs1Q27i4y5aWd5Bd9cKPojMo9ueE5ZqSOhQ2DKbhbnbKg0ciFGT2JdisKyNxXeF3h/owAQSQP7SKSbZ7i3sF3nq6pQJp6M0kqYYzABiB8KfgigCnMsnW2+itpiPcmUoOeZCd69XGmspS+U79zZ72JUvqzb+GIc3nap9a/esEPQ6sKvYYVdVd9NzTD+sJRYWFCTtx0nqcNg/s4W1drlh1XgTd45sezJgDWOBhol9Txl77HsEm6wiYgNtPFvPQzZRyS9TWz6hgQYGx49OdcfvT1u/ixVkbr6Grcb8Bubyd1xueA08SA7PdFeC/U4Q8usPsCSvpttlDekGVPaSz0a3qwFlSH0OBecfDarksNnGgaDCBilYUZgo07HoVg4LkH/gCcNvyia2ukMhIwRgMzh9eL/owLpAeWfkq0SH6jjvHnTFt7965ObFNkDP6rvDIchMFVM9Gtc+U/BKdnTg1Pna0Oi1lKCsNBcLIqPbd4a7+Dw5St3J39ye5ZtCS0yj5lb1Zs+m/i/QBF69hJE81kHulUHTv6gL7yUldv9AlmTJbHf68DgFS3VM6YSunb4UH22u31b1N27H7uswUVwNH1TLmaLFI4H7GWmaX4TAFNWJV7jRBqcv0DgZ6rLZJ8+Ktfvzx498b8gKHtHxNfKG7BTLX/Z+LPkfTuDK2scYINhbKyCTebHurZfJHkAxCgT59N8aE7TeKGM4xaRz2qRbvLzc3ELUK1Lpk34BYiLX/23IdEameYy50mmJsy28oQYgQeki8HmfoFw7XksNPfJIocx+iwUnJhyDxrXtBiTo6S3Z7Ujy7/lx/t595vqEKjfF/WdvYNsx1lFYrBLRaMnvWfqb1w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: extend page-cache test files with pwrite()
Date: Mon, 23 Nov 2026 09:58:07 -0800

HPFS does not allow ftruncate() to grow a file. prepare_file() ignores
the failure, so the page-cache tests mmap an empty file and die before
they can inject a memory failure or check fsync().

Write a zero byte at the end of the requested size instead. This grows
the file on HPFS and leaves zero-filled data for the existing tests.
Open with O_TRUNC so a file left by an interrupted test starts empty,
and check the write result before returning the descriptor.

On an HPFS image, the existing test passed 6 of 10 cases. With this
change, a diagnostic build passed all 10, including the hard-poisoned
dirty page-cache case.

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

 tools/testing/selftests/mm/memory-failure.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-5
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -265,9 +265,16 @@ static int prepare_file(const char *fnam
 {
 	int fd;
 
-	fd = open(fname, O_RDWR | O_CREAT, 0664);
-	if (fd >= 0)
-		ftruncate(fd, size);
+	fd = open(fname, O_RDWR | O_CREAT | O_TRUNC, 0664);
+	if (fd < 0)
+		return fd;
+
+	/* HPFS cannot grow files with ftruncate(). */
+	if (pwrite(fd, "\0", 1, size - 1) != 1) {
+		close(fd);
+		unlink(fname);
+		return -1;
+	}
 	return fd;
 }
 
_

