Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83C03606A331
	for <linux-mm@archiver.kernel.org>; Sat, 28 Nov 2026 06:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=lWhMgMPO
Received: by kanga.kvack.org (Postfix)
	id 6116C6B05BA; Sat, 28 Nov 2026 01:52:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 59B6C6B05BB; Sat, 28 Nov 2026 01:52:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B0FE6B05BC; Sat, 28 Nov 2026 01:52:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25DE36B05BA
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 01:52:17 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F54F80428
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:12 +0000 (UTC)
X-FDA: 85483608504.11.7D5C926
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C516F1A0009
	for <linux-mm@kvack.org>; Sat, 28 Nov 2026 06:52:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lWhMgMPO;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795848731;
	b=zYqgMJ4x5IW7KfoRKOJPGLSssjFXzd+pTvq5u5/bpnoca88WTid5M4R2VgTslJ8lCATrxK
	IwpGZoD3BFJlc+Ij8sHpDPyZ8RstD0vcNzyxVMYZ/oTkfYNEEArztfGAKJkJiVgCKToAfU
	dcIj53M7AKiI6InxRDchgcn5xvRcfUQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795848731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=buuistPcvf2rI/NcPLvcq64Hu+UpmeFVKjzAJKbY2EQ=;
	b=NMifC9tQM5weD5r6iCxFS/lbrxTD3bro/Npc/YhHZDklfro4InuXLIGSpMnpipdbbyrAnb
	ntdLwlKlVUie6dWyR5FRGYACR63TTb5iZ6xyI5I4KQ98L3dojO72PePqZoqjdaCA+B5ZV6
	ZB3ust3cQ5cRxOc17DpaxXqNkVdhGtU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lWhMgMPO;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2673E42E19;
	Sat, 28 Nov 2026 06:52:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0E9F1F00893;
	Sat, 28 Nov 2026 06:52:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795848730;
	bh=buuistPcvf2rI/NcPLvcq64Hu+UpmeFVKjzAJKbY2EQ=;
	h=Date:To:Cc:From:In-Reply-To:References:Subject;
	b=lWhMgMPO1UMoRsHw8fqnw0zDhoq1+p5YMYmcdt9SVu9WM+M5F7tU23I7nPsaA2MM/
	 Niown9sdCLDrmvFUOOF8TgCROsBhYhx5fzQwP5ZtVMYGZjWd9/8xIK45tPLZXYzgMb
	 P6Yp1Tm5yYBx9kIRJaggaRv4LtN/V7FNOHUpG2Cg=
Date: Fri, 27 Nov 2026 22:52:09 -0800
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
Message-Id: <1c93b263b19d4465899bb81efd62bcb3.6@linux-foundation.org>
In-Reply-To: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
References: <1c93b263b19d4465899bb81efd62bcb3.1@linux-foundation.org>
Subject: [PATCH 6/9] selftests/mm/memory-failure: close dirty page-cache files before unlinking them
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C516F1A0009
X-Stat-Signature: k4k6e3k1wg6eaknckzj9rdh39caayo1n
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	PP_MIME_FAKE_ASCII_TEXT,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795848730-438313
X-HE-Meta: U2FsdGVkX1+OWRXpTwlxLfRWoZ+YYKeiXWiIEGQRm0uW6sJaIUZLPq9HB0Skp4QnXzZKgRImrcpYnk0lT/nVEsnsiCj4qSuMTe6EaKe2nybrbKEnavYG/3aoamMDb/Ut2RbBjoxWlfhB2cmgjMJcSp5gq+D24uNbqV08+MHLvCWWGMyX6+hg8KUtK0qRIcehmujy95/DPl+H/FljN9ll/yInF4LIvvJVFC/onP38Y9SW2ubnYFgwx89wSr72q08NnqlAe92QkfX8uKDGgNi57dOWpaSXEhxWAKXO7GHbGX8JO2RWoBWCvEkE3P3wdk58LwRmA4JmY5wpQPVcaQPJm2WkZ3PwqTMg3VdY4v9p5dtA6P6N/r1h1VzRT8O+bw19Mxk3bFObikOOzBJeYQYnsQFn9gQr1XqLW0ngXCSnzvMJIcwSDKp1jQ41WSIb2S++aHq4fAhohMoch/j3vBjv7gZTfibkA5Y3ziu/YJT/7eAJotYxTZLWak3ezp/cq6u42yuki1+8Kf/Ds63zpLGh70XbiO09P3XjYABVOhqk2Y9OAAh0rqDnU/GfpXtO6ERrZV9/bgMMN2zl2DmJ5w6Rxow7cGBLX8xLmlD4wJVd5ISmZkct7QFOd3WMBgfiZKVyBfCkGy++8bH3ELULyBTo6iSCUj8u8CF5p/v/PPOwVYbX5/GjMrRcBfNxspRE++6oycdT2ymxzD0XsSHpYALtEB3hzDVXsxnLcpBLJop1mLqMNHn9KLwBDR8wlR0OQ0a3u9jS0iVeeSwUJErjNJ1UWc/mE7ZKes5sr6gPXueqsp1LyU02AqheVIaoIZ1dSmglCF0k/8gcEyQIrJV2MgL7vQlaUB4CQI6UXgiC6c2dPmWP21af498fPzRmBz/6h6SQpQ57DevzQhZJBBzJ17Y0tNS4aSsbAgLhVxpmBIOSqJJHWc4hJ8t8Cm9Xg2Hg+52M6wOfsIxzAHhejJ0Y55W
 uOkT7HSA
 7pv+Ev7FYP58c3nwVFueT7qzbGthQLozJcHL/UsA+nB9or3iWFSrydsXklcLOI7CuCe9rPws8n5fE5Za632ZQ5TEPDyKL6Kn5EOkO+JMKbG+GCmMIpp7/oLjJYoUAS6nQYeS8CXqPajVZHJj8ZwR+SwKfmOSC+GnVZa2WHyfjAyGUcNbM3Wd//4ymBO9ZINRrVetUx93YUX9ixS53GLi+xCbnJpVbUHDgnaKhd60aFwbICcTv4AgXcvqYS/AwotoOzmcRBUZJy5pwGR/nJEetVrd77Gh3kwu+1guVSkro5GjU2CoI1YxJVa66XS+mzH8EvNC1RyS5pE+DTa3nNU9Ne4iAbytmX0j1skzdXgvYPt9+vjEMPuMBAbG3nH6NyVRQnvqxw1gLB8elDOqfUpcnepCxfJ1Sf/hSlMh0sgo5s91hV+stOhOynFr/3CMjGeH0jHf49dG0Ez96woGQ6m0sPC3ducKdtnuEgU3GMoqIPT87iI4cJ9wTJKhfiJMPYGQQ6gDeGVYkoiLMtatLdSpSy6z1rL0ehRkXUaZhZ4CypzN6dJdRLqhvOCC2W+LKO4p7fCcTdUUwJLgpjetsb/DnINRDIF+G7ZYpwHDHzoK3u7qxJRaBVqDmh6lndlEwErPBVZmHKaf2mtnTmSlI1nD/5WZxyU8/mkkj8s3sXvIn22WSFTIpixCaN7mTYOM+JmieqRe0sKKUjxy6EVf179I0ro89EApgGffiqaVKSgVqjgE3huuv5gF97Z4DvzJwLyr1m8jNsVdL6rs/DmfJLSV3ZadQZUvaBLo6HGHP3tcPqvO3NuwsPePTkBqswyRph+WSSCVZxh3zagzKgUPMhv6Ad3PpLjurUsYtOJowA1AdzO9F5YoOqHUFWn96hwR8t9tSuYGzEjI65JzfjvlTJcwUPMYk8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm/memory-failure: close dirty page-cache files before unlinking them
Date: Mon, 23 Nov 2026 08:50:00 -0800

OrangeFS writes dirty page-cache data from close(). In the soft-offline
case, unlinking the file first removes its server-side handle. Writeback
then returns -ENOENT, which makes close() fail even though soft offlining
itself succeeded. The hard-poison case avoids this because it truncates
the file before closing it.

Close the file while it is still linked. Save the close() return value
and unlink before asserting so a failed close does not leave the file
behind for the next test.

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

 tools/testing/selftests/mm/memory-failure.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/memory-failure.c~selftests-mm-check-that-fsync-reports-hard-poisoned-dirty-page-cache-fix-4
+++ a/tools/testing/selftests/mm/memory-failure.c
@@ -442,8 +442,16 @@ TEST_F(memory_failure, dirty_pagecache)
 		ASSERT_EQ(ftruncate(fd, 0), 0);
 	}
 
+	/*
+	 * OrangeFS writes dirty pages from close(). Unlinking first removes
+	 * the server's file handle, so writeback returns -ENOENT and close()
+	 * fails. Close while the file is still linked. Remove the name
+	 * before checking the result so a failed close cannot leave a file
+	 * for the next test.
+	 */
+	ret = close(fd);
 	unlink(fname);
-	ASSERT_EQ(close(fd), 0);
+	ASSERT_EQ(ret, 0);
 }
 
 TEST_F(memory_failure, dirty_shmem)
_

