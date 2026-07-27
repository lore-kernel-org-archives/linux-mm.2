Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 093ACC531F9
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 01:46:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C65966B008A; Sun, 26 Jul 2026 21:46:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C15DF6B008C; Sun, 26 Jul 2026 21:46:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B073E6B0093; Sun, 26 Jul 2026 21:46:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7EEE26B008A
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 21:46:39 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EDCBA801A0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:46:38 +0000 (UTC)
X-FDA: 85032867276.15.4565945
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1FE90100009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 01:46:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i4bsrfq5;
	spf=pass (imf05.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785116797;
	b=Dfc/IQtoP4SLff7u4tniCboRsd0B8o0PL7Q4zBgPeqIEQXmW4dNMU1+ms7spjp9Ml5Pib/
	aLoBCx7QGCQDYaF9GnLV/i/DkyNKRSS40cMCb3JSBoB1mhT1TqxOzkaAbaF/x/mBVIPZCQ
	4IIaVK///QAq7WSFjMvd/txf+qff4bU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=i4bsrfq5;
	spf=pass (imf05.hostedemail.com: domain of zhangbo0325@gmail.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=zhangbo0325@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785116797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lVCOJq1qiSToLbfY5dL7R4lpViAumORGhYxyWIEbqU0=;
	b=Cc/uKdWMvr13qxeR8wWJGh5kBbb3LhXTlKiecdNXeNNCX3Q4MHl7Fvtf0ZjcXSeM2qmbE9
	tB2fn+r+PLdX5TDpcUDVenA+Q2kXmByt6XVNWsGrQzS1oX9fyTAW8BHEBivbXOO/lAAViS
	l6j02VuSBRvFtPvlOQDnimIKwbH8dCM=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-51c4436d02cso10942381cf.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:46:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785116796; x=1785721596; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lVCOJq1qiSToLbfY5dL7R4lpViAumORGhYxyWIEbqU0=;
        b=i4bsrfq5gdRIxWj5K6qDxt44hiNQ/g9tWIrkT5GETv2Zw1BktvYq+qw+/8zNEx0CB7
         97dJFTHe5OLpyARPh4z9ct41gGAPzcP1PnF9jJ3CJLvab+51tTWjVc+oq4mh0w0ZIoCh
         3KnlWhKI5AVsgweL7gEGLSvG7JfTZuzuiEqM+Xa+Y5B5PHn0eYBNu2fW+cHOf0+KaNmN
         6w+nFZJJyIqF1mDYD0taCiHy2k00jR4Vh/73MC9gqU467Yh5xNARO6EN8PaeijKeOMaX
         r6KO+KJoRzCdgOjvT1G4tLataVqxKipK+cR917ZDJWfq4iC6f9lEglr0dBB7EbNI1jNF
         +3nQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785116796; x=1785721596;
        h=content-transfer-encoding:content-type:mime-version:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lVCOJq1qiSToLbfY5dL7R4lpViAumORGhYxyWIEbqU0=;
        b=SkpZTO2/WjruAQroBYTxAGU4gQyRJ0hIvlBhJYmuuzrPWWZE4fVUsJkGhHurCSLxs3
         7gW2ckAqaY9hzzDKn7fjPFP0Xivau29ExPUsc76gavjlFi6Vfxj3vGU1z73RddpSi7/g
         iRCquZH0Mr974gIkYQ23qpN9qO0gTzWU+N75lhRVHt9IUEI7mG8eAXOr0qYH1LFM+TEP
         0ak6sEsTcLN3CWhX9GVJS60ZSfpSOx2bNBV4O0fRCO4qdOdbFp58oHxBd3V+CW5oCdAP
         +dTKREFMmgyGokVSBdB+pc3a35F0jCxOD3SwK/lqE7A/taTRQRgEIyJM02pZwlzE3ypw
         TY2Q==
X-Forwarded-Encrypted: i=1; AHgh+RpeJa2ripIQYkD8Ijn4ampWLuyKOI1EORqN3DYAg87jddiz+K+hxDdFHAy4uLfwc0/lJANnTEBG1w==@kvack.org
X-Gm-Message-State: AOJu0YxzWts270qZN2DI3NxMh3Z5tVJMW8DHzWdidfeTHxqmu7BzR9sO
	LrWfvORnqsUmbGj8kgj3cpopYLPPuuS3S13WG/h0Wk/8TCsRsksoeIk5
X-Gm-Gg: AR+sD101NJ9w+1qZDZ0zD059K9uOynAg/xmkPGPCPkCr/53eU/GqHWFoGgKMhUZSnL1
	8avX/IlhE5NqWk/eZueWE1SBiiG4pQtqEHVWdPFeI5clKOUefzdaCXxOhpqYNDgoZbueKyeqE7C
	kX49fbcAZBorqiQRtqNCpPbnfr2o7C9ZtewLHAcId/G2K2EpDkw6qi0dVupsHbe4OkDftL/8vnW
	BOoSXFfwW1MXA8HymckFyKbs37hvFlbG/lDJ1GAI9Ey4yl3ccLsvcY8p3R2AuuqC1Bn2VYgP5oe
	O5o1pcn4A8FAqE1Lcxv9kmlKnVOsGtNqPazytORqj5yGfYsLBfSJ+XfIEaFx0omoy2KpIMoP5RU
	WlDQGvoaehzKJowasGO4ucdcCL1+HW4SheYyUfcWRHaFO1nzZCy98YWwIdr7kCJiiu3C/8TbZtl
	KJRv8KveGQDrai1RxYVIDnvzuW/yBaEg==
X-Received: by 2002:a05:622a:1387:b0:51c:1b78:b044 with SMTP id d75a77b69052e-529a8732f62mr73155551cf.61.1785116796193;
        Sun, 26 Jul 2026 18:46:36 -0700 (PDT)
Received: from zhangbo56-PC.mioffice.cn ([43.224.245.235])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e8694197sm53772036d6.24.2026.07.26.18.46.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2026 18:46:35 -0700 (PDT)
From: Bo Zhang <zhangbo0325@gmail.com>
X-Google-Original-From: Bo Zhang <zhangbo56@xiaomi.com>
To: fmayle@google.com
Cc: jack@suse.cz,
	akpm@linux-foundation.org,
	david@kernel.org,
	kaleshsingh@google.com,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	lkp@intel.com,
	oe-lkp@lists.linux.dev,
	oliver.sang@intel.com,
	surenb@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	Bo Zhang <zhangbo56@xiaomi.com>
Subject: Re: [linux-next:master] [mm] 7b32f64bc5: pts.svt-av1.Preset13.Bosphorus4K.frames_per_second 45.8% regression
Date: Mon, 27 Jul 2026 09:46:10 +0800
Message-Id: <20260727014610.3479784-1-zhangbo56@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <CAHCxdc64d-6qNBwwSZX8mdz4-V+88No2x0wG4mex5WPXBDE9AA@mail.gmail.com>
References: <CAHCxdc64d-6qNBwwSZX8mdz4-V+88No2x0wG4mex5WPXBDE9AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1FE90100009
X-Stat-Signature: 4pck9k5a9744ffh1hnxy4b7r6sa4mjks
X-Rspam-User: 
X-HE-Tag: 1785116796-3394
X-HE-Meta: U2FsdGVkX1+x3GVRZdfQFXcNpmfvRGKMx0JxjAl+eKgeHM+QX/PECojhCY3GKkXluLLq6ciGDJmzi6s0agRXNh47wDPv1nz5Yo4+yXzfNCSumnlLLzUh7hQ/8++mlaAMXiR5bXUyeE2maeaFSyghZb4laqYS24Pfi23i52nL/Bp8GO2WqqyywW2xOCJp93D1Wu+/rmzvfdKENCzMGvCT9e/Axu9jynhQaYGv4rr3Tvk44rmPRjIg+4SUcfiwJUsSeuDCGocdf3PK/I/U31iiNtj42OAparktisYgapMLSzzOO3NpVvBO0DisgTV++p74fuxyarWDjCvstmea3R4irdzBPQ1mZXkVpU+zQk4zoSrJvyczJPgIHv5NXJJ66G5aTBGu1TzX4oF4LkcJiTg7wH6lzYNgXYvtxJPPpWUQqhvEg8IiW3RYBeeXCtt3hQCK7HYwu50YHt6Y/IKBga5rKyArE8ER0PN12QMyTQxnleu3RsmVQVnswBWkwHvH9PeIznXD1dCI6DkmdoI9rEOHMu/D5/F8BXegNuVLQNeeh9LHN/9BXjzRYnUJFPPLMcTUwpFOXZDR0BWmotKhD/Z9T+ZVOQ7gVpEj57yjpJFn6jhMXzN0TmRgSlNcgd3Qcfg9XiW+/X8Q4N1fAJRrdZK0k7uw6J3y5h6Y8anumNgY/DE0C48fTHdz84fTAwGnm8wg4s324hrUHyLcbyq5RQzf1/e+FQX4lywhIupGoVjQLl47QF6bPVN23CrraRv5EiFtq5nEHQw1DxS38NPgRx9sp7Qj0RbkdZI3jVCtAAaNmht4nPJnmVlqmE3dUxoXZjdqhx2JCYdhAht0qFO1ZZQTJKVIefrqG+ijB8fCKlENa5lno4aiFwTcCapoRJFyhcr6D69EIPANt1e/S8AEek7yWmy/i/84N7vrbFOIcLzE1eqmB+dc8zZHHVujv67Ttqwv/G07WKlHwLiwEHxjEaf
 gl70Zjl2
 RGiN2SjkEKP4wnFlKcxfbNTR8l2DGQ5jQGswEQCf/19iuKDuKWmXp8IuTFXkcI8rATwxtCmVtZTnnfYR1CfUH0NIdwrGYWw2qQ4OicmXS+Pg2BwjyCdSvtmzZj2bZMMwow/7xnQm8nCeZjfhQUBTmww92tA21LwAux0JzxsIlGktS+yh+Et9U6e1BvrbAq1/wNr3Z2Q1CQgDiQi0WwCacsZ6E8/LbjCAhVX6dD0Zp98pz/3XWlMFI1ZUyOZZfTf9i8b3vXggoDVZJ8iaUimMznS5FfQx2DzNwZBS+6KIB8eFi3sqBGUj6z4QkXCta86MWqc4G5Epp+FSmaAxJS2wH3sa6XNIIIPP83uR2a4X0bQe2WFrmhcZFWYBq52ZJnqSeH/0SMsinAL5q05u7fpt0+mEGKmO8v6dX0OY8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 01:34:38PM -0700, Frederick Mayle wrote:
> I maybe missing something subtle, but, I think you've changed it from "don't
> read beyond the VMA" to "if there is a chance we could read beyond the VMA,
> don't read beyond the VMA", which seems like a more complex expression of the
> same behavior.

Hi Frederick,

The subtlety is in how async readahead interacts with _max_index. The two
are not equivalent because async readahead sets ra->start to the end of
the previous readahead window, not to vmf->pgoff. So even though the user
is still faulting well inside the VMA, the readahead target (ra->start)
has already moved past the VMA end, however _max_index blocks it.

Here is the concrete scenario (ra_pages=128, VMA covers pages 0-1023):

  1. Fault at page 0 triggers sync readahead: reads pages 0-127,
     places PG_readahead marker at page ~96.

  2. Sequential faults continue. Fault at page 96 hits PG_readahead,
     triggers async readahead in do_async_mmap_readahead().

  3. page_cache_async_ra() detects sequential pattern (index == expected)
     and does:
       ra->start += ra->size;  /* pushes start to end of previous window */
     So ra->start = 128 (NOT vmf->pgoff=96), ra->size = 256 which is doubled

  4. page_cache_ra_order() calculates:
       limit = min(file_end, ractl->_max_index)

  With the unconditional approach:
     _max_index = 1023 (always set)
     limit = 1023, ra->start(128) < limit (It works fine here)

  But after several ramp-ups, when the window reaches the boundary:

  5. Fault at page ~896 hits PG_readahead, async readahead fires.
     page_cache_async_ra() does ra->start += ra->size:
       ra->start = 1024  (previous window ended at 1023)
       ra->size  = 128

  6. page_cache_ra_order():
       limit = min(file_end, 1023) = 1023
       ra->start(1024) > limit(1023) (Which will read NOTHING)

  Result: page 1024 (in VMA2) is never prefetched. When the process
  enters VMA2, it takes a major fault and readahead ramps up from scratch.

With my conditional approach:
  At step 5, vmf->pgoff=896, vma_pages_left = 1024-896 = 128
  128 < 128 (the condition is false), so _max_index stays ULONG_MAX
  ra->start(1024) < ULONG_MAX, and it will prefetch pages 1024-1151 normally.
  Page 1024 is already cached when VMA2 is entered, only minor fault happens.

The key point: when mprotect splits a large file mapping into adjacent
VMAs (common for ELF segments, or read-then-write patterns), there's no
benefit in preventing readahead from crossing the boundary, so the data is
still sequential in the file. The limit only helps when we're actually
near the end of useful data (within ra_pages of the VMA end).

I confirmed this with a test program that mmap's a 256MB file and uses
mprotect to split it into 4MB segments (simulating mprotect-split VMAs):

  #include <stdio.h>
  #include <stdlib.h>
  #include <fcntl.h>
  #include <sys/mman.h>
  #include <time.h>
  #include <unistd.h>

  #define FILE_SIZE (256UL * 1024 * 1024)
  #define SEGMENT_SIZE (4UL * 1024 * 1024)

  int main() {
      int fd = open("/tmp/testfile", O_RDONLY);
      char *addr = mmap(NULL, FILE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);

      /* Split into 4MB VMAs via alternating mprotect */
      for (size_t off = 0; off < FILE_SIZE; off += SEGMENT_SIZE * 2)
          if (off + SEGMENT_SIZE < FILE_SIZE)
              mprotect(addr + off + SEGMENT_SIZE, SEGMENT_SIZE,
                       PROT_READ | PROT_WRITE);

      /* Sequential read across all VMA boundaries */
      struct timespec start, end;
      volatile unsigned long sum = 0;
      clock_gettime(CLOCK_MONOTONIC, &start);
      for (size_t i = 0; i < FILE_SIZE; i += 4096)
          sum += addr[i];
      clock_gettime(CLOCK_MONOTONIC, &end);

      double ms = (end.tv_sec - start.tv_sec) * 1000.0 +
                  (end.tv_nsec - start.tv_nsec) / 1e6;
      printf("%.1f ms (%.1f MB/s)\n", ms, 256000.0 / ms);
      munmap(addr, FILE_SIZE);
      close(fd);
  }

Results on Qualcomm SM8850 mobile phone (ra_pages=128, UFS 4.0),
sequential read across 64 mprotect-split VMAs (256MB file, 4MB segments):

  Without VMA limit (baseline):                  ~158 ms, ~1620 MB/s
  With unconditional _max_index (7b32f64bc512):  ~180 ms, ~1420 MB/s
  With conditional _max_index (this fix):        ~158 ms, ~1620 MB/s

The unconditional approach shows ~13% throughput regression for this
workload due to readahead stalling at every 4MB VMA boundary. The
conditional approach has zero measurable regression while still limiting
readahead for the last ra_pages of each VMA (the original goal).

Does this clarify the difference? The conditional check is "don't limit 
when the async readahead mechanism would set ra->start beyond the VMA
boundary and get blocked, even though the actual fault is still well
within the VMA."

Thanks,
Bo

