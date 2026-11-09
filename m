Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D841606D805
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 10:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=PVJC/UwA
Received: by kanga.kvack.org (Postfix)
	id 76B106B05B5; Mon,  9 Nov 2026 05:34:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71B706B05B7; Mon,  9 Nov 2026 05:34:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A986B05B8; Mon,  9 Nov 2026 05:34:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E1606B05B5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:34:31 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEE9FC0615
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:34:30 +0000 (UTC)
X-FDA: 85415221500.15.EE26A3F
Received: from mta0.migadu.com (out-69.mta0.migadu.com [91.218.175.69])
	by imf26.hostedemail.com (Postfix) with ESMTP id 334DD140007
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 10:34:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PVJC/UwA";
	spf=pass (imf26.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794220469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HcyC4gXLAdfeaP/Wt/S0vvlPaGMCmoRLGX/CIA6lY9Q=;
	b=1j0Su+N9WdeHb+8+v0kPfPwT4pvQEH5Z6UfD58ZclMOtVbhBrT6tBeRgYG/6wCK6xaxCni
	gr01Xxi6mNlDvtKJrbhDAdkxKD9zOl2CyRnPkhyNSp2lZG+sFRTQAwiZ7VccDkvVWIMqT1
	idr9jnazfwEz+m6cg/zL1bALplCFu3E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="PVJC/UwA";
	spf=pass (imf26.hostedemail.com: domain of qiliang.yuan@linux.dev designates 91.218.175.69 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794220469;
	b=Eiox1N+7v6TnSC02edR/LS5eXOOi46B5PSl7Fet30gqvWzHKDCoMk1axjV7GEhfTu6YvIs
	t9560FZ49fSMh+MYoYeiphefGp0vwLDQX1BhqGqe+RmZ6U90JBmFQF17JCwaWJXpI+N03a
	wHozSq57h9uIZH6m5DUib8+oH4zc7uU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WSKRKNHs8TgH01lWznvz9ZL6seoezqmhP3XWrJeisK4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794220464; v=1; x=1794825264;
 b=PVJC/UwAIHH3G4mW91KyQrf9mbg4ryVduXLxAkM/ZzXH4axh9UXh9mRUCm7bgIq4kePsTTtI
 aKSnr4ktc4gZTYxW421oOygh6VDmaTrfelpF7JHlhyIQx5u5hzA+TstLotDnQZ20qjo2GMRHiL5
 ttASds2G4+wWVdB4MIcYEv7Y=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2c4cef387cfdf462;
	Mon, 09 Nov 2026 10:34:24 +0000
X-Mizu-Trace-ID: 2c4cef387cfdf462
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Subject: [PATCH v2 0/3] mm/filemap: read ahead for mmap readers that move
 backwards
Date: Mon, 09 Nov 2026 05:34:10 -0500
Message-Id: <20261109-bug-mm-mmap-readahead-descending-v2-0-abac52890a9c@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKKh8WoC/5WNTQrCMBCFr1Jm7UiaSqyuvId0kZ9pOmDSkmhQS
 u9u7A2Ex4PvLb63QqbElOHarJCocOY5VpCHBuykoydkVxmkkKoVUqJ5eQyhRi+YSDs91UJH2VJ
 0HD1erDa9OovOGANVsyQa+b1f3IfKE+fnnD77Y2l/6x/y0qJA5URvulOv5ChvPmh+HO0cYNi27
 QtDyh2F0AAAAA==
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, 
 Vishal Moola <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>, stable@vger.kernel.org
X-Mailer: b4 0.13.0
X-Stat-Signature: i8iuxw77xp61b3pawme88qp5y4qq7huj
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 334DD140007
X-HE-Tag: 1794220465-675626
X-HE-Meta: U2FsdGVkX19CNgsnisRShelAJiAMnQqQRq41Eb2Rkb4SqXcp38yJzdG7XKmt+CCwCvr2UotzhMLulWyXYCr9Ce4LwyWjCbhD5kf66Y/yRd0MAtml/1CAgxN/VejpzWoPYRbRK+Fpupc/0PYp7r65ajLXS38UV1FEKsE7RDksHQjz/DGqZJfBNf7s8VqA8CHmo1CvtCZeJHQQ2sxhmdesakpnFC8vsScBTXjjtCPcqFZxfSRKVgSmA4ejRejDzBMhgL9LAWK+c4Be8ttGwFlylkpjz1YE0V8inPyNz+WugsltNOtsZHVPoGLVSMoZiBVX0q44T/uYWIYNJFH/JN0+ulQ8WzGYev70cw1VdC8MwDZH8tgW8UMngEYhO5k2AwBrrFDTjlFdZAYLmeI9NyhdqZ8XUBcxk1+GVDr+ADe4mz2iNwB6slmzhrXwBJ8usbIEXm6S1o9cvTjgh1z+H35LjG8aeqD4pQ+7xhUhDhnK3n3MMnXrADh+7YmnSKb7R/HkX3jc2OamI7judHFIuzizHN2iP8HHAQ075CI6B7HXMu8GAlDwTGvyqe68bj3mdpuA4a7++Sa3dGtFHH7KOR5g2S9u4EhlwB9fY60Sv9Ftwqrtw/Gkgrhp2a6DmAAagdNMN0KcNza07E9ANzN8dr4mifqG1QKN0gBgfOEuTZx7wLJHA9mYg8AShgeAcPVKD/0irTX5UzfSgmwmlK0Da/xfy4F3Sb0RsVoEq23rh8qZddktaeUBXAx4NvrcRhLZjZVWgmCJfvYfKiKD2Pbg4uV45GLeyHicJsU0UK0SrY5QOZzC0pd5ugSi49UDvDKsAJNM/Ll47xn56FXH4LY0rP9Pt2LF6hQmB6p89apkDrzWjpPyCOGa+iQiA5IFhIkwxMsW67Y+C5mWvNCd58pM13UJivK5uGlfnisHjOfY+QWiqA5ym+H3KssavFtnSdSpZirIXPr8glicQ73R7IqrNKb
 qitgimOP
 F8j9s4R+empNZN4XFKELqNvm+dTthWBdrCcqDN34rReAs/OSmnjFe7foSjKuOKBRmSKVOFTrCBUOvq4Pvn7bDDVZ+8ZfLGOyeNQ614EPw4tfGYFJL+qW8zOVROkPoQbwbdBGX07Ucs2OCSgfr49rGyHiFycFUoAAxlHuVELC9/MsrUp6K6t57CGDlAXViLNUSsVGqgJzbRGIEjAtUFqMGZFPiMTFnF73ZmZMm5Did407tJyZpkybK2wtXXzmQGjOuuFsKQkiQZBBOgeqc1/+0XWGIhcBq5A7z/bP1VqqJVbuJo8xX5bfZ7pC4shJbGi5UODIwbsIIaPyKpz6PBQl3qUyBMiJFRitW35cS6gQYLahO2Tg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A reader that walks a file mapping towards lower offsets gets almost no
readahead from mmap faults when the mapping asks for it. glibc's
memmove() and memcpy() copy backwards when the destination lies above
the source, so this happens to loaders that copy large files out of a
mapping, such as LLM inference engines copying model weights out of a
safetensors mapping. Both MADV_HUGEPAGE and MADV_SEQUENTIAL read ahead
only towards higher offsets, so each fault of such a reader reads just
the part it is missing.

MADV_SEQUENTIAL was slow for this before 7.2 as well. MADV_HUGEPAGE
became much slower in 7.2: since commit 0b9c0aeba938 ("mm/filemap:
count only the faulting address as a mmap hit"), the PTEs mapped around
a fault no longer count as hits and PMD mappings never did, so a
backward reader's mmap_miss passes MMAP_LOTSAMISS after about a hundred
folios and readahead stops. Each page after that is read on its own.

Patch 1 moves the mmap hit check of filemap_map_pages() into helpers.
Patch 2 fixes the regression: on a descending VM_HUGEPAGE fault it also
reads the folio below, and it counts a PMD mapping of the faulting
address as a hit, as a PTE mapping is. Patch 3 reads the window that
ends at the fault on a descending VM_SEQ_READ fault.

Reading one byte from each page of a 2 GiB file, last page first, with
a cold page cache, read_ahead_kb 8192, in a 32 vCPU VM:

                       v7.4-rc2      patched
  MADV_HUGEPAGE          42.23 s      0.58 s
  MADV_SEQUENTIAL        52.42 s      0.96 s

The same walk took 0.53 s with MADV_HUGEPAGE just before
0b9c0aeba938.

Forward walks take the same time, and a fault on an uncached 2 MiB hole
between two cached ranges of a MADV_HUGEPAGE mapping is still mapped
with a PMD, 300 out of 300 times with and without the series. Megabytes
read and major faults for other access patterns over a 16 GiB file:

                                    v7.4-rc2           patched
  1% random, MADV_NORMAL         1002 MB, 39617      1013 MB, 39617
  1% random, MADV_HUGEPAGE       1584 MB, 38760      1587 MB, 38756
  1% stride 64 pages            10503 MB, 2          10496 MB, 2
  5% random in 2 GiB memcg,
    MADV_HUGEPAGE                2205 MB, 187416     2225 MB, 187402

The walk above, run as "revwalk FILE" for MADV_HUGEPAGE and "revwalk FILE
seq" for MADV_SEQUENTIAL, is below. I can turn it into a selftest if that
is wanted.

  /* revwalk FILE [seq]: read each page of FILE, last page first */
  #include <fcntl.h>
  #include <stdio.h>
  #include <string.h>
  #include <sys/mman.h>
  #include <sys/resource.h>
  #include <sys/stat.h>
  #include <unistd.h>

  int main(int argc, char **argv)
  {
  	long ps = sysconf(_SC_PAGESIZE);
  	int fd = open(argv[1], O_RDONLY);
  	struct rusage ru;
  	struct stat st;
  	size_t i;
  	char *p;

  	fstat(fd, &st);
  	posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
  	p = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
  	madvise(p, st.st_size, argc > 2 && !strcmp(argv[2], "seq") ?
  		MADV_SEQUENTIAL : MADV_HUGEPAGE);
  	for (i = st.st_size / ps; i > 0; i--)
  		(void)*(volatile char *)(p + (i - 1) * ps);
  	getrusage(RUSAGE_SELF, &ru);
  	printf("major faults: %ld\n", ru.ru_majflt);
  	return 0;
  }

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
V1 -> V2:
- Split the mmap hit helpers out of the fix into patch 1
- Patch 2: take a fault as descending only when the folio below it is
  not cached either, so a hole between two cached ranges is still read
  as one large folio (Sashiko review)
- Rebase onto v7.4-rc2 and remeasure
- Send from my linux.dev address

v1: https://lore.kernel.org/r/20261022-bug-mm-mmap-readahead-descending-v1-0-6d08b34862f2@gmail.com

---
Qiliang Yuan (3):
      mm/filemap: move the mmap hit check of filemap_map_pages() into helpers
      mm/filemap: read ahead downwards on descending VM_HUGEPAGE faults
      mm/filemap: extend VM_SEQ_READ readahead below descending faults

 mm/filemap.c | 119 ++++++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 89 insertions(+), 30 deletions(-)
---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20261022-bug-mm-mmap-readahead-descending-9cab86703bbb

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>


