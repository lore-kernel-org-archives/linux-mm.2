Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57950FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 03:02:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79DEE6B0005; Sun, 26 Apr 2026 23:02:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 774766B0088; Sun, 26 Apr 2026 23:02:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B1606B008A; Sun, 26 Apr 2026 23:02:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 540346B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:02:02 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BBC6B1406E9
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:02:01 +0000 (UTC)
X-FDA: 84702836442.29.FFE9B4D
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1027EC0003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:01:59 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GhecvdTH;
	spf=pass (imf28.hostedemail.com: domain of 3ptHuaQYKCFs8F3RE79HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--fmayle.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ptHuaQYKCFs8F3RE79HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777258920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5ioCKyTrZjs5zhjXH3CtGoC09/oSwp/qrBcKYJ54Avc=;
	b=UmfubPB64j9aVE3Ya2t/viuDZQiMBfC+jXiaWScSj/MuKJugKKML4Yj0JlNj4s1QEOPMLe
	4NJYyTD8c48vYXAE/8c3RGf4CHiuPtZo0wmi5EHUZTInXMPFjE3mWGhnKmwH5LBIpq/C5D
	aMHMaWlNvR9RiKMI0Nx2B/QUE48Kuvw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=GhecvdTH;
	spf=pass (imf28.hostedemail.com: domain of 3ptHuaQYKCFs8F3RE79HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--fmayle.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3ptHuaQYKCFs8F3RE79HH9E7.5HFEBGNQ-FFDO35D.HK9@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777258920; a=rsa-sha256;
	cv=none;
	b=whdQGDbeyTvLJp0v1Ql+pqKHBUVxMxq9V1+uSTagP0NT3tQg3jMs6/abbkidhbs05oEKSN
	ijQoCCpMOgXqQOqEVDjoczjkDUfQSvkE9NO0b1Fh9kLsXmRL6FYn/loLyvGY0dvEewwD3z
	hKB+VwosNnVMIlbxM3PUVTW+XD8UNZc=
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12dc3d81736so1528941c88.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777258919; x=1777863719; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5ioCKyTrZjs5zhjXH3CtGoC09/oSwp/qrBcKYJ54Avc=;
        b=GhecvdTHMMKcEsNx8k616fObVTVekUMX8nJY1MpnPc+ruR45VqJOQCPd0jC/GNIWPU
         Kuag6FYlAyOdGuljQwuGyr0WMdImFh8fDu0pI5Zx369+RGPaJdSVWxBH2ZtLgL8Un/Gf
         wM8e+8kdVSFWTtaYduLxO+fyTWvj8mGc53XUYJTu3lEMpNPmR+26WS71a83c1IYtrAvC
         MTiIomgMFUu446qXWKwQIl3tZ7IEjc+eEuLkDB4+IYW32SEIvyukP4PVM+nUG6tnkp3I
         OiYDMk8yqI7d3DiI8/Xktxhc+tfXjEoYfPcdvL180pC7/gqNGfT/+5gQhvm/KxTk4Tpt
         9kfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777258919; x=1777863719;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5ioCKyTrZjs5zhjXH3CtGoC09/oSwp/qrBcKYJ54Avc=;
        b=VKU7lTfkB/lw6pvzeGEuI+Qr95EswO5gCKWsh+PIkL6j0EJwt5g3B+OkGhNXOAia0o
         CM9G0++Cw/09cIwbYIsaLNYkz1ZnETtpPlRD0lq07DZATK33C9Xh+ntNb1s5tBg3JWRr
         1NqWyEbO5naolb6G4/i91jWNwcQu1j+DGFm3zmEKoNnMSNz5LY1PEY6CVLbbFeAIEdN8
         tIXtYSIJgvJl6Mrwi3wJNH8pcZysdSwPyqVbxdC3D4CcqJFwKJ03aPWI24BvbNG+dTC4
         ohl2ADIIm2QdUqSIxbdD/yXG1rusWVmPaEmUnpH+kcOdwCXWpTMPVJmpH+bhueMaeYaR
         iMdw==
X-Forwarded-Encrypted: i=1; AFNElJ/ke2kSxVpw8AQ15feFls33LbFefC/HJmC8nnWzrXXGcIu3KGZqurBjkz/QYatjCmpPOt2TJ2QkyA==@kvack.org
X-Gm-Message-State: AOJu0YxxlL9rZhrpRPHCC/72jXDZK8SU/iB55H1RGc5WJbB9rjfWeLrh
	W3uKxBm0MaYVEK20NxffemHz1ZSSfzDjHbMTO+Sdke+Gh/QYzBVVa8rcNkg2JHwd4w+fe3Xynvi
	Spdya5w==
X-Received: from dlbqq3.prod.google.com ([2002:a05:7022:ed03:b0:12c:8db5:2517])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:12b:b0:128:cf75:42a3
 with SMTP id a92af1059eb24-12c73f99753mr21738722c88.21.1777258918488; Sun, 26
 Apr 2026 20:01:58 -0700 (PDT)
Date: Sun, 26 Apr 2026 20:01:47 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260427030148.653228-1-fmayle@google.com>
Subject: [PATCH v2] mm: limit filemap_fault readahead to VMA boundaries
From: Frederick Mayle <fmayle@google.com>
To: David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Pedro Falcato <pfalcato@suse.de>
Cc: Frederick Mayle <fmayle@google.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, kernel-team@android.com, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1027EC0003
X-Stat-Signature: z7r9eeh9841six1qdznz1z5jhbac1d7y
X-HE-Tag: 1777258919-659876
X-HE-Meta: U2FsdGVkX19YtBOnxLvXgmlA8Lzxqnc9ny2de0lkn0hB9ofCj/WI26TvYH0jYprW1tTBvPcvaEmUdNltntSTbx+TjU9Bm5F40BM1I+CW+UmwTRW4UCobXnB/E3PaVunw6Ou4oM1Nqt2qr/RwhNgIAIRt7k5sWAFp40c0dSlspnGyHKqV7xtA0YEGOOhLpTuvDzTuoFJc2dR460tH7MA9e2DzUyFGE6h7EYPqA1LYJ6vhnZSXY52487UhxrSxDc/PwI9EiuDzmnz+xR/ZU1gyQOTOWaq87DOT26Dwtb6JHX0EP+hvCcn6yACTG0w/YJ8xP26dpe8KA/Gfuiq8dFSrNC097qyybDB93vcwv9QoVF9/zPesu5jDUAKsZNOZCOJGEhcrih4aAXi/68WZof7ARsuZscRgK9O1Pg8p7SMJLIKOWuBNzF+rkPVVWQcfCQGQnl5zXBHET15LBxjR0f3IwCS17hPsMe1GLrCIGzkEa/GET7Jzma6JLLol5lC8YutrYII/fqwZTC9TYgBx+Uw5tV7wz5ByC4WIs1Leyyp63cRqYBjuAv8RKhlmP0iCtcNZGQ2LhpnTX+gkgsCs+mFpFQCDJexctCCpRw2GZOC7X+FBSVxKheu8+pXsD8oMYozEXkr/+ib69qrtHqmg7F9k0MCHcwGAer8Y6M/yg38AcNILLRjYxO0GSrVNy3oyOLSitNGR1y2J3KRMbtmENagwTSTgTvS+PB9aWZsbUyuLQpdL7E1yjFHJt9L8Y+wfvVmta79mvGBNkTisRiMnFC3kffMeftxVG8XJVemgR9Ht8NTOqlLQVRAF38DVM7Xa9/KpC6OlDB3FDD4jmrOBZ6vtbUaNvGwmMLtHVqjE9IDtXLhpBttlepBJ4Y1RDEuQxYR1SRMXs4vqlpcHRPSu7C9cBZtoqhwDpQSxjTb7EvwJ/MNakdskgAxZ27O4eJvTSET4SCA/n46H7qEDssx5iwp
 Gl11XZDL
 jdo5mKAK0jY6ns+T5Z6wwyxigM3A3ESD3yTDWKJrZ2K85i01SY3KK0pRHF70vJZzaNNTlD34qZPCGFmqd/l1WQCmrmOTGuGjjuOmQt80RN2X8k+d1fiPfoxS1jMShqWAXpHX3NWw9Tn0uQtG7hT7cq368LeVuMQw7A3/ejA7AE+aVt10Bu6owR9DbbtKkr9tBzr5Yr8+mk2vgJKezldBdQSwxy0wK7Xq4dwQjKo8q1RSCoKDYq7mjSMg+Vh4JOuzPe+JufQJZyhDI/iX6fUsHHJuQFIg14uFj5oJDiH/84t4RakBHeUUhOeDRQTKw1S3Pn8n3uiJ3zPI02AYGNUeAz+F2oqxJ5R0Zz0yHwauOvogFgRqHGTbx/b4ajq2g8zuh8RyeL2nW69ies8p+EqZPOvOldsdQxW/dX52XOTGfrlCOzd2CZZvIrmn0BHsJB3Rrpl6TjmmOB8cYCxSblMifTzMqZZ/ATmKjuh5O7eu4GpZxdBH/OnvVSZFlSYISmHFju+/NNSygyA7dAMls+FjyTDrknVotthGuotiXQ7nTQJDjayzjfrqIsYXPu/M7LtdhdKPyWZoJoYNWz33GWYX9g6ZdWQ8acOvnBLLsPEH9S7yO+PeF2fEFaXnaADXH/WZfxZG1u+TgXMGJh1pltqr51Exe01ewyETAxzAT7Lvx2ZRm1X6fynj/rrioqHI+rZD5niaEtKusrqlprMDnb+veVcx5XZW6jRR6c6Q4hZfy4JhiYxTTa/oRqyWdRjQUGNrKlNV7uzJ9Ts8iYTLKjpSQh1uYY08cKABvygcALxhXcn+YMmLTL/ltGwLOZuGqDnAEzFjxIM9pBMFPx6eNXfkUfYClqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a file mapping covers a strict subset of a file, an access to the
mapping can trigger readahead of file pages outside the mapped region.
Readahead is meant to prefetch pages likely to be accessed soon, but
these pages aren't accessible via the same means, so it fair to say we
don't have a good indicator they'll be accessed soon. Take an ELF file
for example: An access to the end of a program's read-only segment isn't
a sign that nearby file contents will be accessed next (they are likely
to be mapped discontiguously, or not at all). The pressure from loading
these pages into the cache can evict more useful pages.

To improve the behavior, make three changes:

* Introduce a new readahead_control field, max_index, as a hard limit on
  the readahead. The existing file_ra_state->size can't be used as a
  limit, it is more of a hint and can be increased by various
  heuristics.
* Set readahead_control->max_index to the end of the VMA in all of the
  readahead paths that can be triggered from a fault on a file mapping
  (both "sync" and "async" readahead).
* Limit the read-around range start to the VMA's start.

Note that these changes only affect readahead triggered in the context
of a fault, they do not affect readahead triggered by read syscalls. If
a user mixes the two types of accesses, the behavior is expected to be
the following: if a fault causes readahead and places a PG_readahead
marker and then a read(2) syscall hits the PG_readahead marker, the
resulting async readahead *will not* be limited to the VMA end.
Conversely, if a read(2) syscall places a PG_readahead marker and then a
fault hits the marker, the async readahead *will* be limited to the VMA
end.

There is an edge case that the above motivation glosses over: A single
file mapping might be backed by multiple VMAs. For example, a whole file
could be mapped RW, then part of the mapping made RO using mprotect.
This patch would hurt performance of a sequential faulted read of such a
mapping, the degree depending on how fragmented the VMAs are. A usage
pattern like that is likely rare and already suffering from sub-optimal
performance because, e.g., the fragmented VMAs limit the fault-around,
so each VMA boundary in a sequential faulted read would cause a minor
fault. Still, this patch would make it worse. See a previous discussion
of this topic at [1].

Tested by mapping and reading a small subset of a large file, then using
the cachestat syscall to verify the number of cached pages didn't exceed
the mapping size.

In practical scenarios, the effect depends on the specific file and
usage. Sometimes there is no effect at all, but, for some ELF files in
Android, we see ~20% fewer pages pull into the cache.

A comprehensive performance evaluation hasn't been done, but, in
addition to the anecdontal memory savings mentioned above, a benchmark
was run with fio 3.38, showing neutral looking results:

    /data/local/tmp/fio --version

    fio --name=mmap_test --ioengine=mmap --rw=read --bs=4k \
        --offset=1G --size=1G --filesize=3G --numjobs=1 \
        --filename=testfile.bin

        Before: 4366.6 MiB/s (avg of 3459, 4592, 4613, 4697, 4472)
        After:  4444.0 MiB/s (avg of 4633, 4655, 4511, 4571, 3850)
                +1.7%

    Same, with --ioengine=mmap --rw=randread

        Before: 445.6 MiB/s  (avg of 446, 447, 442, 452, 441)
        After:  447.0 MiB/s  (avg of 447, 446, 446, 451, 445)
                +0.3%

    Same, with --ioengine=psync --rw=read

        Before: 3086.6 MiB/s (avg of 3122, 3094, 3066, 3094, 3057)
        After:  3084.6 MiB/s (avg of 3039, 3103, 3103, 3084, 3094)
                -0.06%

    Same, with --ioengine=psync --rw=randread

        Before: 2226.4 MiB/s (avg of 2256, 2183, 2207, 2265, 2221)
        After:  2231.4 MiB/s (avg of 2236, 2241, 2236, 2193, 2251)
                +0.2%

[1] https://lore.kernel.org/all/ivnv2crd3et76p2nx7oszuqhzzah756oecn5yuykzqfkqzoygw@yvnlkhjjssoz/

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: android-mm@google.com
Cc: kernel-team@android.com
Signed-off-by: Frederick Mayle <fmayle@google.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---

This is v2 of
https://lore.kernel.org/r/20260422005608.342028-1-fmayle@google.com/

In v1 of the patch, I made a mistake and accidentally mailed twice it,
the first time without including get_maintainer.pl output, so the
mailing lists weren't CC'd. There were replies from Andrew to the first
email which aren't visible on the mailing list or lore.

Changes in v2:
  - Add Jan's Reviewed-by tag.
  - Tweak commit message wording, per Andrew
  - Change field from `unsigned long max_index` to `pgoff_t _max_index`
    and move next to `_index`, per Andrew
  - Avoid min_t, per Andrew


 include/linux/pagemap.h | 2 ++
 mm/filemap.c            | 4 ++++
 mm/readahead.c          | 6 +++++-
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..6fd2a8914073 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1361,6 +1361,7 @@ struct readahead_control {
 	struct file_ra_state *ra;
 /* private: use the readahead_* accessors instead */
 	pgoff_t _index;
+	pgoff_t _max_index; /* limit readahead to _max_index, inclusive */
 	unsigned int _nr_pages;
 	unsigned int _batch_count;
 	bool dropbehind;
@@ -1374,6 +1375,7 @@ struct readahead_control {
 		.mapping = m,						\
 		.ra = r,						\
 		._index = i,						\
+		._max_index = ULONG_MAX,				\
 	}
 
 #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..97772a05a18e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3314,6 +3314,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
+	ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
+
 	/* Use the readahead code, even if readahead is disabled */
 	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
 	    (vm_flags & VM_HUGEPAGE) && HPAGE_PMD_ORDER <= MAX_PAGECACHE_ORDER)
@@ -3396,6 +3398,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 		 * mmap read-around
 		 */
 		ra->start = max_t(long, 0, vmf->pgoff - ra->ra_pages / 2);
+		ra->start = max(ra->start, vmf->vma->vm_pgoff);
 		ra->size = ra->ra_pages;
 		ra->async_size = ra->ra_pages / 4;
 		ra->order = 0;
@@ -3438,6 +3441,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
 	}
 
 	if (folio_test_readahead(folio)) {
+		ractl._max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_ra(&ractl, folio, ra->ra_pages);
 	}
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..8c12b63ccd4a 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -324,6 +324,8 @@ static void do_page_cache_ra(struct readahead_control *ractl,
 		return;
 
 	end_index = (isize - 1) >> PAGE_SHIFT;
+	if (end_index > ractl->_max_index)
+		end_index = ractl->_max_index;
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
@@ -471,7 +473,7 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	pgoff_t start = readahead_index(ractl);
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
-	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
+	pgoff_t limit;
 	pgoff_t mark = index + ra->size - ra->async_size;
 	unsigned int nofs;
 	int err = 0;
@@ -484,6 +486,8 @@ void page_cache_ra_order(struct readahead_control *ractl,
 		goto fallback;
 	}
 
+	limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
+	limit = min(limit, ractl->_max_index);
 	limit = min(limit, index + ra->size - 1);
 
 	new_order = min(mapping_max_folio_order(mapping), new_order);

base-commit: db2a1695b2b6feb071b47b72e61d0359bf1524bf
-- 
2.54.0.545.g6539524ca2-goog


