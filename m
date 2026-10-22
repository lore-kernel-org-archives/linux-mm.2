Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE465606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=WYvLl1Xu
Received: by kanga.kvack.org (Postfix)
	id CB1976B017C; Thu, 22 Oct 2026 11:24:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C88D16B095F; Thu, 22 Oct 2026 11:24:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9DF96B096D; Thu, 22 Oct 2026 11:24:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 904B16B017C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 11:24:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1EE4312019C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:24:43 +0000 (UTC)
X-FDA: 85350634446.25.8534E53
Received: from mail-dy1-f176.google.com (mail-dy1-f176.google.com [74.125.82.176])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2CA1B40007
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 15:24:41 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WYvLl1Xu;
	spf=pass (imf27.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792682681;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ULgRB/f/0nMMgaVufow+n/zddXTXxzXvwgPanbaVK50=;
	b=gVPwlVQdudhe4dWIFrl0N9Vdv6Ej1d2a/HrL7x86nK7i5+RVdYD7LgsPQPo7nAlZgspsD3
	PuQnysQAC8Lr+T+8fUtnydn3nRbgeoNd68FnLg2GG6jGSTtPFuALjfQjVY2ajijCt3lmNK
	3xwXdKjrg1tKr8oGiW5KXOroyb9znbE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792682681;
	b=dW21ettru7CZjsFlUKDQdBSOlwAo0S2q/poW5nUzpVLT6eB1yVB6HhN392oJnIZTDkYps8
	By0k1DiCbKxKyLpseax7lA0a+iZW1N50zuAQqmryHwCfD02083aw2Ox0F/m4sopPj/NmLp
	8sQip9ynuHfyR0z9+WAcX96TXvlBhiE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WYvLl1Xu;
	spf=pass (imf27.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.176 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f176.google.com with SMTP id 5a478bee46e88-353804b591eso3515164eec.0
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792682680; x=1793287480; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ULgRB/f/0nMMgaVufow+n/zddXTXxzXvwgPanbaVK50=;
        b=WYvLl1XuCNSxgVFSpmdYvekjUWh98pgJBroz/wCO04qj/X+Eh4AvuKlzZfH/JgMn3Z
         olqgxvX/ZP2f/QU4mmAZwobTYZcE2Xx8mCSzlVYpnhc5guvWWUweZKng/lzITfwZwWBe
         T8eCHr/RPFYJupWz0GEcosdHDyFNNG/NyCfWGrFoWxK/qvPV/WyamdIWahPGwmV0g3Gg
         19qP/hUTAA0AX1J9Qd4MBzrHEgdHRMo3s5CHoAO7BzzBpBrdL1GkecjwUKk08E33Q9xP
         X5+YK+MeYHEgvE7sHOnoSR6ZYHyWCAJ2v1cUFROyXYeG5Tn7pNw7Exba8npgTXJazcdD
         ofMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792682680; x=1793287480;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=ULgRB/f/0nMMgaVufow+n/zddXTXxzXvwgPanbaVK50=;
        b=IArtd/xJ+mGIqRNz7xF66m9NcAc84u496AuKEV7DPTGWc9YZwXU3IegLAMa8QmKOkN
         Yh5oXmSPRrwzoDaulqSk3uWI94iCXVFg16db9NCnAHlMcwApIyMTXrP7RJ2+nY0cu6eI
         33H1EKN11wjdyicRNajdyzQpySvyLpu8oW4O2sSTH+5Y+qj3ypd5xozHsM3i5CCMOKPC
         ZgigzLRYub879L6pRkc/DaejfaZjzWrP5LqIJqdRJj4FibBPDZoPvSv8uLSUQE1BXbCx
         J1cQD+tP9I9bbFSOg9BPg0eEdkAUmd1xy0WiLd+U/BanNo62PFOokumsAbQvmQLzw5J/
         EypA==
X-Forwarded-Encrypted: i=1; AKwUvBzMI3hMpkLNgWQ1Q2ImMyjJlbrR6XJaBUE6JCDXuE1kHk400ShC3PQJpYMa2kaY2BqhkxYXWrW3bQ==@kvack.org
X-Gm-Message-State: AFq9FYKGpzB5XURwa9s+3naph7rt1ijToSDNUCChCG7Y12lnHvSn5ApL
	25tZ6zUQ0UgDeKuMV5BoBhAaVwLKY9TW8JSKq2Jm9lfVMzPFLOsVOm4u
X-Gm-Gg: AYBFou10Ep4RAsZQ3HH0iaK3ubA8KItycZKzrhDCeiKQIcZf1fBQNR3Mm2V9z2SwQHk
	+t5dp3sQ5uQEUKHNfLIqnsl8shkto9ybXJR8kruOP9Eo7H7g+/QxwQOmziyGCbjATVC3Oe9X4y+
	C4oZwEqgSFehUeLqaZN11JSVyydpFXH59uGbDCics8u3GNVKx8s4MTAGgz6hPrRaW2F1kvTKzLW
	AVtCd573eDJ8rtC5BF+HlTX2E+iFItMX2V7c4UkKZ+obdWZsNAWKJgSOYk8/qhNF4Je+2z1QMIG
	zOOfmCBS1dwvLvlRE6u1kOsm5yU2WxNjhai0MGbvxgjDAdOU8iwpdQ8Rg2fSs0SvFe5ORirzh0g
	4VSgqb0ZvxwPgZPZzBwdEWooQdRqXB3mwp1Va57PTSdKztu1sOu4EURrIw6YNZ3iA+x1zXj68/6
	CoMS3guC+6/dRscpB3qZTrYRw0ZQOg1mAEZjoDMRRH4Da0J0x0i7FLK3YHGG0BYwe0WWgfcH0ST
	KrMt+BlQTNiuyd/RBGnMKrpcUN9tyY4iy3uwOmeqv/78W9ycbA=
X-Received: by 2002:a05:701b:418a:20b0:151:7f08:5961 with SMTP id a92af1059eb24-190a03341d1mr7652600c88.4.1792682679689;
        Thu, 22 Oct 2026 08:24:39 -0700 (PDT)
Received: from [127.0.1.1] ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1903a180ca2sm13984187c88.6.2026.10.22.08.24.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 08:24:39 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
Date: Thu, 22 Oct 2026 23:24:33 +0800
Subject: [PATCH] mm/readahead: look two windows ahead for the hole on a
 marker hit
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261022-bug-mm-readahead-async-overtaken-v1-1-c05b8d8bd2da@gmail.com>
X-B4-Tracking: v=1; b=H4sIALEq2moC/x2NwQqDMBAFf0X23AWz0B78ldLDJnnqIsayaaVF/
 PeGXgbmMnNQhRsqDd1Bjt2qbaVJuHSUZi0T2HJzkl5uoRfh+J54XdmhWecG1votibcd/tIFhaO
 k8RqRoRKoZZ6O0T7/xf1xnj+OvnebcgAAAA==
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Qiliang Yuan <odys.yuan@gmail.com>
X-Mailer: b4 0.13.0
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2CA1B40007
X-Stat-Signature: sityn3qsmwkmk6mckhhgwsfkw8764aet
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792682681-798171
X-HE-Meta: U2FsdGVkX19HDsAnE8p56Qsb+PrFyrK2Sj9L0WmAr+7nuvjJ8ds3E2kqOCZzXiw43wtXGm3Kge5CZ+MaYnhTtNtaA9nKpQ6QUmydjCRIqBnbZvi62b5LN6zcFn/Fk8d2K5qxQk93WLFk0zDzeCLAJ23qtcLxq1SWQVUSm/aVHu+EOhMlFY8ntyDPj/Ap9sffY8H6AYYClfe8kf3BIoF8DDCob+xjOQQXGn7eXiBr0/RzHFJZExjRaAJEC94kTmNAh0mCfZsAm0usKc/obOZmPqXO9oO1mZJeSqt73ifgW1PHE+r1Zsl3BGm6FAGLEiuILuFwamY0Mf1EySYKp+k8kx+6XuCfzCxYy9AGWnosGYjcrIGphaQsZ8dAAouSB5Vtfw5butYOUreniuOMjKG3KmNw1vQeL33mG4uxk3ADg5jqVGif5yrLdGh5/VShhfOu7kTGcgjKN//Wmfqd+LenjtKJYn/bmVWqdrTYfIGelt3G20y5X5WQnD2dhT4MYS5WERIQWKOS0B2gqoGh5zq8IQO9RKlj43LRkYILZfHjbd1u72+jjRrka+7pJW2oYbG3NM4mEZPji57IkJo40VdYQCtuT9lMNsMMUEGabGzrHxFi+Gz1DFCjYA8TOXI50j5bjm5qX4oVBONXVyDMhlwW6PJ3rM7kIUaZ6L1id5ky80xkRAOSFnWqnZDjvupB8sqruE9NBvpQEKdd8G8Pi0blW4p7nPccr553BlIyncEdta5uFsse9503PJ9d6SacjkKRNqYcyakDE2DEAwObJyQZ1tKe9g/7KSENuujbK8o+rakQZMSgu+fyAXeH1jELBfb+Fb7w7n/udY8rBs75FeQbQXyJEc+Lwx/jNH1nNZ/mRmYuvpZm8n8gTYfxjzrhenaAp19w69H0/dmNHoFhNRSK5daJffJOBuyM7b7eYHQP4qXDEEDM0sdSjlTLW7cUVNr9e6VNMZMYaSopLEERwU6
 JVC9PzpG
 VpADzeSqlLfTIrA9ZZJzTKZBrrCmB2/MolH1JyVRUOfPsAlK0bMYkIvAvCYVn5aFHPHLgZXO0TV0WUoqPPKwR8iI7oKTq+WP2eF9ymtTRXj2hGoTtxBqEH+fj4voGUo5Drx08lyOAd0qxLLvrSdlxk6HLSI45c/whXwymGc5HrOOte2ns4DUksOw23kw4KhRkmdPY0mvJ2A53+fXVjKoopFWy20b43X64BShNY1/ipSpNWp4ehbn1FdVyfzaUkCdrxGv86eSfXu0t1y8vowYeZTWZUlYPuIzIVkOLCmdpI9pQxDMokLRub/laY3TxGIO2W2KbnqUdjAZyTEPCVF/JnXSpnjbK8iOOhrDOBZefzzLj/c/xTJS1VMcDtRrXNpC3rSdOhz7XXi0HllA6U6PBJDgSToUmkP5JhufbwM27v8YkAr8Qq3pfKnnQwXT30k0BbEbHSxXgd1Sg4AkM9OV5fAPXafIOjYK0YJmci8nNeVVeJ+CSj3L5yuMWwiz1Tfmjguggd8yRRGF8psoZj0rxvyM5EQ==
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

Signed-off-by: Qiliang Yuan <odys.yuan@gmail.com>
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
base-commit: 7be4bc52fd9e0e55dc9a2e0232b89427d2c4b614
change-id: 20261022-bug-mm-readahead-async-overtaken-b2cf5bedea21

Best regards,
-- 
Qiliang Yuan <odys.yuan@gmail.com>


