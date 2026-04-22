Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8B8FF94CA2
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 00:56:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17BBB6B0005; Tue, 21 Apr 2026 20:56:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1521A6B0088; Tue, 21 Apr 2026 20:56:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0406B6B0089; Tue, 21 Apr 2026 20:56:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E2D346B0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:56:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 88CFEC783E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:56:25 +0000 (UTC)
X-FDA: 84684375930.11.AED56EF
Received: from mail-dy1-f201.google.com (mail-dy1-f201.google.com [74.125.82.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id CBEAB1A0006
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 00:56:23 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ny3phrGC;
	spf=pass (imf19.hostedemail.com: domain of 3thzoaQYKCOUMTHfSLNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--fmayle.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3thzoaQYKCOUMTHfSLNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776819383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fSPQPWpwMUWLrSIOukQG9uvEUqsfb3QUUQ/25v9V8fQ=;
	b=gsBVN7fKLZHQXRnPf3UyzIoZe6ZsMvk0EMZ6gtxqgzDFU5rZoosH6uk/ZwXicLUHZYsv11
	5xlPKJyMG0B122wdsVIT6BgW+p4KRFT6GGS7RBYeUi01tavwoaw4k4Aef10ewae7hci1mW
	ly7qD0czGhU1hEUG+IzgLx2VIcKb+UM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776819383; a=rsa-sha256;
	cv=none;
	b=CletyJYAk1deyXPVEIdfOddMaNeO2gvPzW3EZp+JA7F3qGfFzxBOsCktjPoXGqavycznk3
	lA2Ycuo7CkpgBXDTP7L1HjhyJIgo5+DfZDg8Vm78amV1zc2V03PuJEJDKsNf0KGrq/vQ6E
	dTkrX1+RccWyT3tvFU4n7yvuSYPnTiE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Ny3phrGC;
	spf=pass (imf19.hostedemail.com: domain of 3thzoaQYKCOUMTHfSLNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--fmayle.bounces.google.com designates 74.125.82.201 as permitted sender) smtp.mailfrom=3thzoaQYKCOUMTHfSLNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--fmayle.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dy1-f201.google.com with SMTP id 5a478bee46e88-2c0f6593ef5so5737732eec.1
        for <linux-mm@kvack.org>; Tue, 21 Apr 2026 17:56:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776819382; x=1777424182; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=fSPQPWpwMUWLrSIOukQG9uvEUqsfb3QUUQ/25v9V8fQ=;
        b=Ny3phrGC2X1S25Rc1ACYOlSL3REzM8zHZeVLiHQnXwWI+X7KsfaNRGPUHgWD09Cb0k
         8FmN2cIKX1osbPrj6+xRSkREodrgTbadsusjdmLp9dfRl3c/KTjyMfyFY9quo+qw0H/u
         bEP/1wu8MnebVfaxeRQlNx84lQ7S8UMM0c4ddLF0AtQ6qVVqk3pY8pK+LzdVfTatuY9V
         vFhpJOb5DHZFAblW7OLZlmIfBklKMVtNc5Ot+AaFFQbZOrYXRe/nzQUoFUyT9y9bBNmV
         mpje9hjy1OX2nSV4vu8vLrN5nMRbasMxaLmFteVEFFvn4VWaKJBIlBUPr58ohzfofot6
         XkYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776819382; x=1777424182;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fSPQPWpwMUWLrSIOukQG9uvEUqsfb3QUUQ/25v9V8fQ=;
        b=qfKYRvLgFGkmneJVWqVA3lHUEBh3eOB9pCbJiBmX6XjtWnCO39Kg4HCMah3qyQvINt
         9UG08pGzlvV9iXqtnnoRp2X+GJ5boEC/YrecwaUXZNI5uIT/PAA40WepDsyEk2djDtrt
         zh/MxhigEupkWxozFmgK+e+N1aqHY2aDETkZidWkSa90xFoSg4Mwr8Bkx13mO2fEZEN7
         MZIJ21j/9rqmuJzE9z7if5BPCxQaNRoMFFh+vi1ghK9xWdpLesk8zE8VPlYnfY/3aAK+
         NuACb6e9EVWcYVK9MYEiI5LFyvcApIkLReoWqLVMIdd7qvFk3fCeu3kKPM5jbV7KxxVt
         AubA==
X-Forwarded-Encrypted: i=1; AFNElJ9fNXHvAbZPZXRdVFLtMfzzuRTEP0S3FhYYB/TbZ0s1xD4b2meWAIPZ/X5pTulqdEr+A0zb/9GIuQ==@kvack.org
X-Gm-Message-State: AOJu0YzEyvsHhYDujwHvpXZgGxDk4Ji638SxziNpfWYl4+x3vyY9MFBU
	EI0DbWW/48Fn2eiALcS4+mcFGktJxwEjulfh8TokUQdA6N3CMIVrJiVoDOBiGBwJX3aMjrJsf8a
	wD+rGJA==
X-Received: from dyer22.prod.google.com ([2002:a05:7300:2316:b0:2d9:e328:e0db])
 (user=fmayle job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:3d19:b0:2d1:9b35:4ed3
 with SMTP id 5a478bee46e88-2e4874ea1f2mr12199282eec.28.1776819382219; Tue, 21
 Apr 2026 17:56:22 -0700 (PDT)
Date: Tue, 21 Apr 2026 17:56:07 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.rc1.555.g9c883467ad-goog
Message-ID: <20260422005608.342028-1-fmayle@google.com>
Subject: [PATCH] mm: limit filemap_fault readahead to VMA boundaries
From: Frederick Mayle <fmayle@google.com>
To: David Hildenbrand <david@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>
Cc: Frederick Mayle <fmayle@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, android-mm@google.com, 
	kernel-team@android.com, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: swfko5ehc5mqib3kqekf6qkoqtat98hm
X-Rspam-User: 
X-Rspamd-Queue-Id: CBEAB1A0006
X-Rspamd-Server: rspam05
X-HE-Tag: 1776819383-633526
X-HE-Meta: U2FsdGVkX1/vfUTpYPyz1Dsch/rx5T8rp3L6AlMscpQIB08ZRkfnzyxNSJZlGs9dPT6GnlRLeH3qf+vRPjfuQjpoDuTiOa8mlYcXPPrNoVepBf2sFvlOVp/R+arrWCUSlbPEsTPT+NomX/GxMA4DKmsWaeuS6hKuw6gqlR1pwllYPwKuKgPukgxYL8tO3AqVsJs+tY8kNxzXtlSKfO1Ol6yBrvzrTuqGR5WoTO/f61WnNFqz8YLnWDQarVk6vcRHDdeT/yjRQbA5S+noIQbTCqmne59JRyUrQ9F50I/ZczVEIzSbje8HPGN+N7+Kz2gVTRQD5YH6NOENkTlupthR2pQSEOSopfPU43PsnNUvagw1IqAaRiYrLDdHATvPrDSkhH6TYEPGlJOxvqkgNUSDnKGP3Vnk/E1Ojwau9SraVX7dYacqqLOuhlZh//p5bQ2FOu04LwxdGa9EYmyMSDUXbtbfa1Wzy3SiMKMfICyn3rcPXun7p1H3/fMAX7gn1Ry9uA8wQHexEmUJxM8lIV8r6J4STe2DMiFemaUn57ZzttAdCJh7tNr7Tl0zxyAbXIlHrdfViwC61MRAReErv4PJMATKum9J2PhNjNjWrx3EvD2lfqIJERw31f9Uf5RKNsO/uQOis/SIZQKQ9kPhe1t6LUzFt7+PYcq6QGi3i5cMsNUbDEvkMVP4y7uQ5TvFkRspdP8q1MCpiDLw3D0a8Lp2+hhD3u3FnLj33/+fUxTgCMUfi0OYukvQgbHe6KK6p0bpF8fZP7YYwckjdyyiIa060Npur5XF38CsbDKxjpsIT5x9eaQJZXV3BrqMYPcM7xIOdrxlp68HFQtwLT4uMlVNKMUSh0vUlVTHNkturqdIyCOoTR3hjIJ46NNTzTkYxMwtXge4YxPw2sNIUFIy6EXQyG2zcsgGxhkcb4l9jNJVTokfjRQSFQVDzNb/0bQJa6l+S6/eqV8jtJphuQ+ZSgf
 2+83Etkg
 Pwuu9j8E7e6XajZQOkNRp7RPDp4XzZs02Ll0ncbrNu2rA4cNiw7ILQpRpRTEIGKiZ6M+zQocTrmhUI7z7Hf60s0aT4L/0b53PZ8pazjbtiV8hfC/KhI5KbWPfufbNAPrpEbj8sYLtSj8OGRc7eJcITArEnv/sXqfg8gxUVdxcXDfn18ZRKO79eOVIMemHaEDGJwz3ybBBqrMOQlurCB3xmxzPyJYK50tzT4tK2YtbbHVKNwCnkpBDBmCpYZs6LPwYveIHKeqYYBsfcm9+Eg9v2WEoykOtYkRh9Oc2VbRgKGYJzDdzoJky6y4mixOdq6A8anNTJdSAzOXJ55GoK4gYFGq2vZN++UcX4VcY/eG5gD0WurPvUaPNTbaaB5Kvy+/23ANXFw7zdtYGqmMr7BNxdjvx97szGev+a//yJGkA4tBnZ89SFCc9+VE8WGKUu01xPsdjxOfVdFWUL4bLcEgnbcE87r0j1cQchiTHQbseXTFYVl5HKpUAKa7OSj5UWHxrqaPCkh3guL+7+nULc6mK9ZcQyBn5lqniGiDGA8r5xyeDqjeSq1bsCgUq78CQY4yhsd9BTzKJ7b2AJoLzRqM5u+doAoy1igO+6qQ4iZp0+ixX2tGTkrJdZWfRavrgwpSarZkWiEnND0P0ozSGy3j29DYm2zy7k2KHx4mxiXGKkTtF1GPxa3TuTST8X9BJbeZi8N8rvRpKKWpuaUtx9sC0Z6tFw7r+/J+pJJz/t7WRAEGmFlAphcy3XJAabWfTwTgMqS5SCFVEfxrjQxwISRDom7CKDIG0WWfYh8q3xtsiO+5ACHulyhJb8XpxgqSQd5/N8tx7F5h9uY4f/kF0Cjfehzgstw==
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

* Introduce a new readahead_control option, max_index, as a hard limit
  on the readahead. The existing file_ra_state->size can't be used as a
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
This patch would hurt performance of a sequential read of such a
mapping, the degree depending on how fragmented the VMAs are. A usage
pattern like that is likely rare and already suffering from sub-optimal
performance because, e.g., the fragmented VMAs limit the fault-around,
so each VMA boundary in a sequential read would cause a minor fault.
Still, this would make it worse. See a previous discussion of this topic
at [1].

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
---
 include/linux/pagemap.h | 2 ++
 mm/filemap.c            | 4 ++++
 mm/readahead.c          | 5 ++++-
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..cc628050bc5e 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1366,6 +1366,7 @@ struct readahead_control {
 	bool dropbehind;
 	bool _workingset;
 	unsigned long _pflags;
+	unsigned long max_index; /* limit readahead to i<=max_index */
 };
 
 #define DEFINE_READAHEAD(ractl, f, r, m, i)				\
@@ -1374,6 +1375,7 @@ struct readahead_control {
 		.mapping = m,						\
 		.ra = r,						\
 		._index = i,						\
+		.max_index = ULONG_MAX,					\
 	}
 
 #define VM_READAHEAD_PAGES	(SZ_128K / PAGE_SIZE)
diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..d2f6bef12f58 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3314,6 +3314,8 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
 	bool force_thp_readahead = false;
 	unsigned short mmap_miss;
 
+	ractl.max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
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
+		ractl.max_index = vmf->vma->vm_pgoff + vma_pages(vmf->vma) - 1;
 		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
 		page_cache_async_ra(&ractl, folio, ra->ra_pages);
 	}
diff --git a/mm/readahead.c b/mm/readahead.c
index 7b05082c89ea..95a424b2f3a3 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -324,6 +324,8 @@ static void do_page_cache_ra(struct readahead_control *ractl,
 		return;
 
 	end_index = (isize - 1) >> PAGE_SHIFT;
+	if (end_index > ractl->max_index)
+		end_index = ractl->max_index;
 	if (index > end_index)
 		return;
 	/* Don't read past the page containing the last byte of the file */
@@ -471,7 +473,8 @@ void page_cache_ra_order(struct readahead_control *ractl,
 	pgoff_t start = readahead_index(ractl);
 	pgoff_t index = start;
 	unsigned int min_order = mapping_min_folio_order(mapping);
-	pgoff_t limit = (i_size_read(mapping->host) - 1) >> PAGE_SHIFT;
+	pgoff_t limit = min_t(pgoff_t, (i_size_read(mapping->host) - 1) >> PAGE_SHIFT,
+				       ractl->max_index);
 	pgoff_t mark = index + ra->size - ra->async_size;
 	unsigned int nofs;
 	int err = 0;

base-commit: db2a1695b2b6feb071b47b72e61d0359bf1524bf
-- 
2.54.0.rc1.555.g9c883467ad-goog


