Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69AEF606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=FBM2Voqw
Received: by kanga.kvack.org (Postfix)
	id 7408C6B00EF; Wed,  4 Nov 2026 01:17:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F1DB6B05B1; Wed,  4 Nov 2026 01:17:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 608156B05B2; Wed,  4 Nov 2026 01:17:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E2D46B00EF
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:17:03 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BA8B412057D
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:17:02 +0000 (UTC)
X-FDA: 85396428684.20.7B62C65
Received: from out30-118.freemail.mail.aliyun.com (out30-118.freemail.mail.aliyun.com [115.124.30.118])
	by imf30.hostedemail.com (Postfix) with ESMTP id AC1E080005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:16:59 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FBM2Voqw;
	spf=pass (imf30.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ic+f8fAiF3rnn/6l8bF3oaVZtUIPePP4Mud6dITzj/k=;
	b=cY0i4Bb2/DAgcvLV8HV6pf5OnJaWryBJ484AV2mMJjlSeW8xoHuO3QkbCO5YxWR5f/Stii
	1OE/JdiyoemYfarSnyUs+R94Nz7e15dtPzhcjey7WLbc4106MyINmB0d3ZCA0HtPSoJjz8
	mPXPN1W9S4tMo7PUaEiFr4frHG7PhZc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FBM2Voqw;
	spf=pass (imf30.hostedemail.com: domain of tongweilin@linux.alibaba.com designates 115.124.30.118 as permitted sender) smtp.mailfrom=tongweilin@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773021;
	b=eDWLVtIWJexAbygI7Me5ji+3E30mc8hLEKExrvd2KPy03U9Hef3A8Tf1ZzSQPTiS3EhfDr
	M5r8cyQVJ4vmj/gSTdSpuYnSOoESHjE2sCGXOaGLVByKNyiSqEKXg3Wr9W2NyQHXKurbcb
	nE5B9pf8kdNtxWR85Tp+rW3toDJlQSU=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1793773014; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=ic+f8fAiF3rnn/6l8bF3oaVZtUIPePP4Mud6dITzj/k=;
	b=FBM2VoqwLLtVsgJEQJkRX3aAmFd7XYogA+K3zLw43y+lJu9V7iWx/wVjeZl+NhxhaC1EXUt3XtY4tqOPX0FiyM75hG04aClPxB4R6R9KkeCbNoPLOr0DvJwolUFHO8XfpRZ7p2J4/5If2aiMZHZn5vpHtJhlLRwk/a8lX2DsJsY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R701e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033032089153;MF=tongweilin@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0XE4qK9Q_1793773004;
Received: from x31l07246.sqa.na131.tbsite.net(mailfrom:tongweilin@linux.alibaba.com fp:SMTPD_---0XE4qK9Q_1793773004 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 04 Nov 2026 14:16:53 +0800
From: Weilin Tong <tongweilin@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Ryan Roberts <ryan.roberts@arm.com>
Cc: David Hildenbrand <david@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] tools/mm/thpmaps: handle carriage returns and non-UTF-8 filenames
Date: Wed,  4 Nov 2026 14:16:41 +0800
Message-ID: <20261104061641.1115805-1-tongweilin@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 37tx4ftafmkctpuroboumxmfsyxqx8cp
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: AC1E080005
X-HE-Tag: 1793773019-197090
X-HE-Meta: U2FsdGVkX18V9xuMPf4wVZRd4Ai4+bGXmnrZL2kh7z2tPuk7SWGNCeYlA0HmJvcCFGnMBMGuoNhNICsCYQb4pqt2A5339emcatNDRtInqbKEEwzOXm7eH1+GJcrzibLwO66iGf1djEDz7G5QL7jOKdUOCrxnSDIwvOl1iuofRn/UY2spNibqK54e7TL4TeUyefGIZwhOkGHq0JaIR8XuKvq2p0+W6RpMh2TL0daKAMLxZH3+qA7lf/UT8hlDVzPLnc513GcdqXNhljfJEgWBe1K1jFq6ctGrjfrX5C5CvEUyRzS3EvoVPPEipRVZx4ePCkApv0ga+RrsxMRVfYQ9TQ//uQny9pna/4lzJBdBGJkp62rZXEo7S/T4XFcLzV/EipC7/EOHhKJqon+kFsinjrgg1qaJijKxD2cP0+3QjRgc66Bf/PF/GP/4FfGNEQAQzskbpjWtBLq/ac6vJbwxwFhcxmcj7TXXvN1K5Vtv28Uy6M0OnfWTFFErLdAax6cmpgaLWktg8TVgf7+DWfVas4l40JSbSLFCl6XrQkYKC8g62pYHaXa3esg2iIc4ko+v8PmgZiALOOjL5AO3pBGtQ93YnpJYzd0shDuUzwhNz4o2TmNkDwCKsQ0gpnDVddrI6ZDuEZVAMw14QjtnaYmicaLndsE5cjOfgAQhS3uWtospVvJ2vMKRhvWXVDe3ABr6pqm2HOdCe52hZD0U8nZeu3cnI79dceIjqwyr1KFOJADo3+ohf8pyPuIeTYG5o+ft6W+gAqSt6E8+MHi15i5Pvt3gjd1kuj+v+4uV8SbKZkKoAWsxBQyUzNeN0I0mB+welHaedetNqqxTtzrsqG7PuOqAVAodwipui0gX0HutU16WgrWmHUB5gOlDBrCNI9A1iy2+73aYtsbzVTkVyIKf4CAJyahDpl3667mT82ImiC43XY2UVMbPh6m5PXZiunndRKCwn4QZ8uW9jp9LS8r
 e17dN6aH
 P8E7bzW9LMtITJWck54SHQau6NEU8SOGCSptfbHxGRm5jGBWnLo5ML8JMrnoIFseFznfR/CUmDGAuAjwxsLKJI22Zozr2StcWIZhv0tm03HPSR8+RN1GKASew0PGiJG9yij28WwmH8QdsCYHbLLFvns4L60S56FVOU4TDgOvkIUsKYXrDvpf5QFkTT4TJeR55KD5cOOgEog//DNtCsGRZJRT5446UQUITrUxEdkf7cdK6EmTXMdNIV0hnVqt8PGEDBvTkrwcLPq9n6ouz6ONsomP8NIjObi/OuAI6FkivrlDxCTvevNVVxL8DgkmN354CDJKXSuHVbzXLtF0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

VMAList opens smaps with universal newline handling and strict decoding.
A carriage return in a mapped filename can split a header into multiple
records, while non-UTF-8 bytes cause UnicodeDecodeError.

Read LF-terminated records and use surrogateescape to preserve filename
bytes. Escape filename characters that stdout cannot encode to avoid
UnicodeEncodeError when printing mapping names.

Fixes: 2444172cfde4 ("tools/mm: add thpmaps script to dump THP usage info")
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/linux-mm/20261101211644.c63a2028bbede0f763f41f80@linux-foundation.org/
Signed-off-by: Weilin Tong <tongweilin@linux.alibaba.com>
---
Changes in v2:
- Escape unencodable mapping names in vma_print() (Sashiko).
- Rebase onto mm-new.

Link to v1: https://lore.kernel.org/linux-mm/20261102085419.696232-1-tongweilin@linux.alibaba.com/

 tools/mm/thpmaps | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/mm/thpmaps b/tools/mm/thpmaps
index a1a9bc30514f..0e17723515cd 100644
--- a/tools/mm/thpmaps
+++ b/tools/mm/thpmaps
@@ -196,7 +196,8 @@ class VMAList:
     # instance to receive VMAs.
     def __init__(self, pid='self', stats=[]):
         self.vmas = []
-        with open(f'/proc/{pid}/smaps', 'r') as file:
+        with open(f'/proc/{pid}/smaps', 'r', newline='\n',
+                  errors='surrogateescape') as file:
             for line in file:
                 elements = line.rstrip('\n').split(maxsplit=5)
                 if '-' in elements[0]:
@@ -363,12 +364,14 @@ def cont_parse(vma, order, ranges, anons, heads):
 def vma_print(vma, pid):
     # Prints a VMA instance in a format similar to smaps. The main difference is
     # that the pid is included as the first value.
+    name = vma.name.encode(sys.stdout.encoding, errors='backslashreplace')
+    name = name.decode(sys.stdout.encoding)
     print("{:010d}: {:016x}-{:016x} {}{}{}{} {:08x} {:02x}:{:02x} {:08x} {}"
         .format(
             pid, vma.start, vma.end,
             'r' if vma.read else '-', 'w' if vma.write else '-',
             'x' if vma.execute else '-', 'p' if vma.private else 's',
-            vma.pgoff, vma.major, vma.minor, vma.inode, vma.name
+            vma.pgoff, vma.major, vma.minor, vma.inode, name
         ))
 
 

base-commit: 74d73ffcffe03804f97e9fb82301dadf75671282

