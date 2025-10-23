Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10868CCD1AB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 01:47:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E6E28E0022; Wed, 22 Oct 2025 21:47:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 396D88E001D; Wed, 22 Oct 2025 21:47:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 285E58E0022; Wed, 22 Oct 2025 21:47:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 139358E001D
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 21:47:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C1B061298DB
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:47:49 +0000 (UTC)
X-FDA: 84027692658.12.48B62C9
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2C7C4A000A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 01:47:47 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4jImpxd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761184068; a=rsa-sha256;
	cv=none;
	b=i11ELxgjQEzu3q1m0tinFYmy/P5btSorxVdIwKFlWeeB5TpOMFoFcKBYNiI+iU2JiclJXZ
	8rg+edu2/GPEoOhEhl04HlaENXmXJS0MTfHJ61Vd5VGXivgIkih/N7bRaApTib66xp+B1F
	+C2fGJP4F29I1JVxf5hA1agGVEgXrpc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4jImpxd;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of leon.hwang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=leon.hwang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761184068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jPBHSIhisQYB9BOAqxE6p2j3YHbxjnfcV2vPoexza38=;
	b=bzfpZqfGZN6xx9I1rCIiu0pMOApEsty4gOBtYq25jTPmSptyO7lQNeVynTptTb+XxGqZQu
	1/tGty1+4djCWlsHPpbDTzt0MOGZmDLN/XgoDiOFY3NSimego6ylITuvKfMajNYfEJlx9V
	3aIMHAcpmo6gVuilnHa+lOphmk4Ek78=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761184065;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jPBHSIhisQYB9BOAqxE6p2j3YHbxjnfcV2vPoexza38=;
	b=X4jImpxdfP/eaQ4Vt75iKwYNUOphmJJbwKZUq/CsVqk0mC6J0eOj/pMI6m6uC95+qqIiO5
	G6NsT5+LdFGxSXv6W1AQkZCOkBhuQEmxirpnQ95l+4Xkn3I9LX3y9IuevZzzvbXZLEnvLC
	rJGGWYtiCctl98tlz5TCW8mT0+neias=
From: Leon Hwang <leon.hwang@linux.dev>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	lance.yang@linux.dev,
	shuah@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH 6.1.y v2] Revert "selftests: mm: fix map_hugetlb failure on 64K page size systems"
Date: Thu, 23 Oct 2025 09:47:32 +0800
Message-ID: <20251023014732.73721-1-leon.hwang@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 56e4ofrxrabay1b3in31wu7q5zemsu9u
X-Rspamd-Queue-Id: 2C7C4A000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761184067-407442
X-HE-Meta: U2FsdGVkX19Yc3TyoXvANVdNGYrZ2YkUye6n0dWmriEMgMghF58J3zVm1yoa1+Ob9tHVF78r5/Uwl46L4H8HZzelIFzejST1a8x6AkwY/7yVO1UZfWig9/GV5wZ1T+afRpeG0bWcH8VT3bsnqIql00+ZNkNDRxoce2K6zXcIezWsjCcIaByR8n0gMbTW7tX3sMXW919noB35TkBybDFgfmHOYyC2KA3euypQkWi6RPPY/lxKZtKZS+uQqx9JfGWp5P9TKfXHtpsCOI0WGtu/1ocB0zoXIz9n8J1M+SAb2SLumSXORmA8jj2Cute7VKSUvm37jtnkfcbdAlhpdOlIg+XQqE8N6+zeUVz1FE4ZyXK1JYN1mx3FIjKkipftywDYmRu0Ajt9Ww6ZFZKWnXIYhV5gl0JkhdnVsT9Jocz/ZX5j/bRLhM45P/gz0wqUwzd+/OXGT43MxhAKKrjyitZUppuL3fNxwe9DEnjWBTwOLi4OVs2SBBVN7C1NKDdHwDEcRjJTgjm8SePjAJx/M4MlxbLwMuJXG7Nf24REOvEgTMlRX791eZZymvmVGfd1QDze9sNm+3fYw8d6cvUaZF/5J6gCPAunh5ezwoUC2zKaKf3/sy+dVNMG7HgVerPGPeYDPEDMUvpl8bxUexROnxy4EAl6l+L1tzwY7rkSS1eb1rbQJXdDXRzjtM6w0GmZZOnPdRLp//IyifZldhMKfMXh5K3X24HHGGtxGPR6o1AsFBNMn/2NmQsu8hnF6w7uJzqP7r9jrhdBWWQ+oXLErmx0hV36XeQkON4LmlRh6IhE/Rr2qhcq0y8ec3bwFRTUSbAUcMyPFVkA/1ob3VUSuDGYtNMiNy5U8OymkdKy+exCOJ6Fn6Ayn4kveomV+AniC0jbf2XhSYt04qE8Ti8hX/QSngtLEIp+bOpqUQ/NqrWjuUYcmq5KloQA3WbTKIdAY6pJsir84x1HlC+K4x1OK+Q
 xfapEP7C
 KcV3wOozpiVR0Cq0jF/fTBSACO4kunyeeJe8xqbtMNVp+y0r0ffLLkhVVNJoWPYMfmWJYwW+QWb2zAvzbxHhnabDMSkTyZsdDkJoGi/58xXsC4QZO2uVCrjQgzseS7IlRN8KYcsA+iqcoE3FMLVTCC+gbrmJ6wJhg1Kcib4XL1nVijDYzEiZp7iW91/bFNtKgIHXseLIGhiiJ6u2C4qzuh2dQvuLx3pFTB0xU3z7CG3XYiVxig27CX4ggTSmQ1TEbyakfmzNy0A8clvo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit a584c7734a4dd050451fcdd65c66317e15660e81 to avoid
the build error:

map_hugetlb.c: In function 'main':
map_hugetlb.c:79:25: warning: implicit declaration of function 'default_huge_page_size' [-Wimplicit-function-declaration]
79 |         hugepage_size = default_huge_page_size();

Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
---
v1 -> v2:
  - Revert the commit instead of fixing the build error.
  - https://lore.kernel.org/linux-mm/20251022055138.375042-1-leon.hwang@linux.dev/

 tools/testing/selftests/vm/map_hugetlb.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/tools/testing/selftests/vm/map_hugetlb.c b/tools/testing/selftests/vm/map_hugetlb.c
index c65c55b7a789..312889edb84a 100644
--- a/tools/testing/selftests/vm/map_hugetlb.c
+++ b/tools/testing/selftests/vm/map_hugetlb.c
@@ -15,7 +15,6 @@
 #include <unistd.h>
 #include <sys/mman.h>
 #include <fcntl.h>
-#include "vm_util.h"

 #define LENGTH (256UL*1024*1024)
 #define PROTECTION (PROT_READ | PROT_WRITE)
@@ -71,16 +70,10 @@ int main(int argc, char **argv)
 {
 	void *addr;
 	int ret;
-	size_t hugepage_size;
 	size_t length = LENGTH;
 	int flags = FLAGS;
 	int shift = 0;

-	hugepage_size = default_huge_page_size();
-	/* munmap with fail if the length is not page aligned */
-	if (hugepage_size > length)
-		length = hugepage_size;
-
 	if (argc > 1)
 		length = atol(argv[1]) << 20;
 	if (argc > 2) {
--
2.51.0

