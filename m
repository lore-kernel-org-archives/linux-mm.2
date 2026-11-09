Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9B004606A33F
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=aeYA9o7I
Received: by kanga.kvack.org (Postfix)
	id 942C66B05B0; Mon,  9 Nov 2026 04:11:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F34C6B05B2; Mon,  9 Nov 2026 04:11:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8084C6B05B3; Mon,  9 Nov 2026 04:11:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7BD36B05B0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:11:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7D80F8061F
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:11:11 +0000 (UTC)
X-FDA: 85415011542.01.0E9D9ED
Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	by imf24.hostedemail.com (Postfix) with ESMTP id C3431180005
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:11:07 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aeYA9o7I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794215469;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ceETPs2UDE7IxIJ30l+uzPMCZetkCltzW9DlghrZCVE=;
	b=estqhf4hKdK+h8xeWYfBK6N/Wui9ey+GbHSGXqNXNO7AtHTYcc6wKgEtP6tTBMBfNBCXwT
	zRq+OGaSNXx1Chv1HGg5rho2sMyA9HLLSuPNXbG9QW4oxaoj1nR+LYb3SuQ4Y5HwgRzEUi
	6pSX6//fnTUEFt5cgNowX4LtMmaxhmk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aeYA9o7I;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of qiliang.yuan@linux.dev designates 95.215.58.1 as permitted sender) smtp.mailfrom=qiliang.yuan@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794215469;
	b=dWsWRtL0Vocm/r5TrQSgEnVNabS6CdCpLflqDz7ih+dyh/e4f2glPUBh0Ccm8Qv3AVQ00h
	AG8DqDIXRpKPDoh7WR6J/Garl6VoxyPUALWLkR5M+UrfYGJ50/LkRuPEbjt7epm/QoRwfB
	WddWqyQlUR4huWNlkrDu+gotqF6a4eg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=WUpuYALlic5UCEqO8xHXvlvF5G6I45TQIvrJRccV9iY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794215465; v=1; x=1794820265;
 b=aeYA9o7IOM94e2cddbedQ0jaEEsGvDhlYUHbUfwWiOOH9ry/IOxTxIS/0F3pD1frKABfbmO8
 tv7wXc7yWTWMdQkPwj3fxNY6evbj2c/01Xsy8kTbwlVxbErsBoYttk3lmIdsifCb4nBVyJwvvUS
 04QCLOxvVk7Lkagrou1LA3Ks=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f507b16f9208fe5c;
	Mon, 09 Nov 2026 09:11:05 +0000
X-Mizu-Trace-ID: f507b16f9208fe5c
X-Migadu-Flow: FLOW_OUT
From: Qiliang Yuan <qiliang.yuan@linux.dev>
Date: Mon, 09 Nov 2026 04:10:55 -0500
Subject: [PATCH v2] mm/readahead: look two windows ahead for the hole on a
 marker hit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-bug-mm-readahead-async-overtaken-v2-1-06ead50562a2@linux.dev>
X-B4-Tracking: v=1; b=H4sIAB+O8WoC/5WNQQrCMBBFr1Jm7UgzUCmuvId0MUmmbdAkktRgK
 b27sTdw8+H9xXsbZElOMlybDZIUl10MFejUgJk5TILOVgZq6aJaItTvCb3HJGx5roOc12AwFkk
 LPySgJjN2WqwwKaiaV5LRfY7Efag8u7zEtB7Fon7vH/KiUKFpO93bXluyfJs8u+fZRA/Dvu9fy
 lw4OdAAAAA=
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <qiliang.yuan@linux.dev>
X-Mailer: b4 0.13.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C3431180005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: ixxsn5d8k5caip7fz178ayj6p596hdgm
X-HE-Tag: 1794215467-47090
X-HE-Meta: U2FsdGVkX193PbeZC0e5frF1tTYAa2Bqt/N3+j6Ko0C3PiCORflregYDO1GTbnsfkXH7dK8WJsGmqrenfnKziBFkar74ly9d0rI78cz+Ljjz0aSikjsFFgjy74QjfSu1u3TE/h4fF9Gs3WwsHuyhtrzFgCl3RLJByy+jfMSMdlTVSs5JSeyavirVjZgkL56XwKycUqXy2aJAu64eH8pSgNvmpYKS8P8yix8hDxaY9VhYGTpZZvEsIXAsonr0hrUfFZViBs7r944qiiOefOHUQbuIm0cZPdFi3aq+gEqjaSawsi4Q+YUh+ltCRCMpByXvNuTHc3Gf5zTDXG1TqyI5FUprqLtOGhXaaVyyfDf3whEFtvALWD5v67za5kRhTJMdkC9n3Kj8meq69OLKEyp4KR74d+P2e5do5TeheyExRRistEk0BHXpB9c63Boo2PyQhUf7KcStYOiypbhO97xs/gHPdOSZZNiQfJZzsBr/aPckiVkpP0NHXcsWuCtWkcUNSg7kRAFsJZOLAjhM8KPVcTLGRe5RLmkT3lsgfT/WWyt66Um7WBjvCmTLqUMGqlOe/FJUdco7hDQSAOvUToUSIsr6xD1xk2+acNtKqnQNnBpY12maM1NUVtQP/raMm9WT3nD9So4R9VZRQ7LXH0LHkT4czGNGFnllk7NpNc8bU+4eJQ+levKQW6pkVvShf33GQEanaojxkeDhK3Y9B4afwUlkKmM/LK87Z9PI2b18ITk7rSXcpJHq/Y/rw4d9NPexdRBp0puk/h7tXimszGgjoiTQ/fmtLO/1Fb5qCbYy+vtgQQS8aJCNo35zMC3FKmahw6qRKjy/5S80tT/J7V08tAmb6br5bm4TCje/t+npen4vM4fPLcgPZRp0xvMcoj3I9Ujy54Jeu6ZW8RkI/gKXiDP+OHeu66+xvjmexgBTH1+fQ/SFD66+rgcJvRo4yrLsmX/iqjVjnUmpgLFD7tl
 UF5+XjYy
 UO/3pDz6utKTHtmTrOKR/YHds+csZGjgzpi/QPebBb0RKgGfI2QpUXDBItQl1M30NFbVATqFuY4k9pqUcgxVnaE24+qs9/HwmjGWOFDDNtZwEm/0eqyVu9GF+f9rt0Y8pjbQ8PDuucc3KWT8uIJMvVwSC9FWioX1PDW+IRAI1GNQDSA+TI7aEmzfoki/9l+zD3Q8NRwroILJTnzqEx3Y8c9ySUMeVbgOvOStSLaLbYuhhWhhV/S/lA0QhUlRoW0QPMrXPJ0MxCb8aPUwyNg5vqV2+VicoGnFwAmJmNPhGTuYxEnZ8s3PK9uxY2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When a reader hits a folio marked for readahead that the readahead
state does not expect, page_cache_async_ra() starts the next readahead
at the first hole within one window after the folio. If that window is
fully cached, it reads nothing.

memcpy() in glibc loads the end of a large source before copying it
forward, so a loader that copies a file mapping out in pieces of a few
megabytes faults at the end of each piece first. mmap read-around then
reads a window centered on that fault, which reaches more than one
window past the readahead marker the copy has yet to hit. When the copy
reaches the marker, there is no hole within a window, no readahead is
issued, and the next piece faults on its end again. Every piece then
gets a synchronous read-around of order-0 folios, and threads copying
parts of one file also contend on the i_pages lock to insert them. A
copy from offset 0 avoids this as its first read-around is clamped to
the start of the file.

Look up to two windows ahead for the hole, which reaches past such a
read-around, so the reader keeps an asynchronous window and its folio
order keeps ramping up.

Copying a 16 GiB file out of a private mapping with memcpy() in 8 MiB
pieces, read_ahead_kb 8192, cold page cache, 32 vCPU VM, mean of two
runs:

                                  before    after
  1 thread from offset 2 GiB     7.62 s    2.00 s
  8 threads, one range each      3.26 s    1.08 s
  32 threads, one range each     4.05 s    1.34 s

Random touches read the same amount, and pread() copies and copies that
interleave 7 MiB chunks across threads take the same time within
run-to-run noise.

Signed-off-by: Qiliang Yuan <qiliang.yuan@linux.dev>
---
The program below copies FILE out of a mapping in 8 MiB pieces, each
thread taking one range. With a cold page cache, run as "pcopy FILE 1
2048" (one thread starting at 2 GiB) and "pcopy FILE 8" on a 16 GiB file:

                        7be4bc52fd9e    patched
  1 thread from 2 GiB      6.92 s        1.57 s
  8 threads                4.00 s        1.04 s

  /* pcopy FILE THREADS [SKIP_MB]: copy FILE out of a mapping */
  #include <fcntl.h>
  #include <pthread.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <string.h>
  #include <sys/mman.h>
  #include <sys/stat.h>
  #include <time.h>

  #define PIECE (8UL << 20)

  static char *map;
  static size_t skip, per;

  static void *copy(void *arg)
  {
  	size_t off = skip + (long)arg * per, end = off + per;
  	char *buf = malloc(PIECE);

  	for (; off < end; off += PIECE) {
  		memcpy(buf, map + off, PIECE);
  		asm volatile("" : : "r" (buf) : "memory");
  	}
  	free(buf);
  	return NULL;
  }

  int main(int argc, char **argv)
  {
  	int fd = open(argv[1], O_RDONLY), n = atoi(argv[2]);
  	struct timespec t0, t1;
  	pthread_t th[64];
  	struct stat st;

  	fstat(fd, &st);
  	skip = argc > 3 ? atol(argv[3]) << 20 : 0;
  	per = (st.st_size - skip) / n / PIECE * PIECE;
  	map = mmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 0);
  	posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED);
  	clock_gettime(CLOCK_MONOTONIC, &t0);
  	for (long i = 0; i < n; i++)
  		pthread_create(&th[i], NULL, copy, (void *)i);
  	for (int i = 0; i < n; i++)
  		pthread_join(th[i], NULL);
  	clock_gettime(CLOCK_MONOTONIC, &t1);
  	printf("%.2f s\n", t1.tv_sec - t0.tv_sec + (t1.tv_nsec - t0.tv_nsec) / 1e9);
  	return 0;
  }
---
V1 -> V2:
- Rebase onto v7.4-rc2, the patch is unchanged; the numbers are from
  the v1 base, mm/readahead.c has not changed since
- Send from my linux.dev address

v1: https://lore.kernel.org/r/20261022-bug-mm-readahead-async-overtaken-v1-1-c05b8d8bd2da@gmail.com
---
 mm/readahead.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index 6e5563290287e..d7a511a9fdcbf 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -696,12 +696,15 @@ void page_cache_async_ra(struct readahead_control *ractl,
 	 * E.g. interleaved reads.
 	 * Query the pagecache for async_size, which normally equals to
 	 * readahead size. Ramp it up and use it as the new readahead size.
+	 * Look up to two windows ahead: read-around for a fault further on,
+	 * such as from a memcpy() that touches the end of its source first,
+	 * may already have filled the next one.
 	 */
 	rcu_read_lock();
-	start = page_cache_next_miss(ractl->mapping, index + 1, max_pages);
+	start = page_cache_next_miss(ractl->mapping, index + 1, 2 * max_pages);
 	rcu_read_unlock();
 
-	if (!start || start - index > max_pages)
+	if (!start || start - index > 2 * max_pages)
 		return;
 
 	ra->start = start;

---
base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb
change-id: 20261022-bug-mm-readahead-async-overtaken-b2cf5bedea21

Best regards,
-- 
Qiliang Yuan <qiliang.yuan@linux.dev>


