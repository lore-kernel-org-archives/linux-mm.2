Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AD4CC87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C95E6B0088; Tue, 29 Jul 2025 21:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7A1D76B0089; Tue, 29 Jul 2025 21:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B88E6B008A; Tue, 29 Jul 2025 21:52:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DEB86B0088
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:52:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 00DF91402AF
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:21 +0000 (UTC)
X-FDA: 83719256124.04.31E57DB
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf05.hostedemail.com (Postfix) with ESMTP id 23E23100009
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:19 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VYjViiAY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 30nqJaA4KCDkdnVVXhVieVmmZnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--isaacmanjarres.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30nqJaA4KCDkdnVVXhVieVmmZnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--isaacmanjarres.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4lpYwICX0CJSHu8yDb7qWIdE6OnXVrrqjQR/9Vf5znQ=;
	b=QVZ1EwHB+Cn4M5ahzAtH0GBL/43rLAlmGzURIiRU2c/f+fOb/4RPIbFXjvJzpxgRtrENn7
	CKumWnEapqwjl/ntfDzFzIiueLNLtzLv/hjmsHGf9ZmGnA3RBWbuCvKHzIA7LFHk+EFCTC
	A0XI54oV+jVbTK0u0IhJFwUU914oHJM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840340; a=rsa-sha256;
	cv=none;
	b=DnYzSnjtIUG79ilhGdqvcrsppKnaB70MkNhND3w6xtfzynf/Yzw6NZQvboUGh/0dH1c1Ar
	/Mv9kGBOZkD2ENsq+GitRPCm7Ihww4s1MnUe5+UQj+DaBMQ4ZxS2GE3wT80xc5UL1Dt9Id
	0T+iNozASw/XubdvVO0T02SlnZhbA8c=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VYjViiAY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of 30nqJaA4KCDkdnVVXhVieVmmZnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--isaacmanjarres.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=30nqJaA4KCDkdnVVXhVieVmmZnbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--isaacmanjarres.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-23fe28867b7so44335595ad.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:52:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840339; x=1754445139; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=4lpYwICX0CJSHu8yDb7qWIdE6OnXVrrqjQR/9Vf5znQ=;
        b=VYjViiAYhbdsOsaKBtAv/hfNw9TExgXE9tLvCmPf+UKnrzo09JrfxrtYJz5oVwE/Li
         3peUsLpl176JTeEfX73Ti4AivUjf9c19K9AHqnf6PYjjZdwmK3zlB8OqQp79+wJNnKkN
         59eaMGDjjKGEaaJbYuzGFysQzo9REaf1E4DsPcx1q7TyaGV6g1p3Qpk/1ItzemQnEKfP
         oySSzcWvu8ZNtA+rSl4+RiKi+7EnqR1nUF46rSfF2w71Igl7jaTpwxU1GuMnuClmBNeN
         qKMCA+lFzHMChoHC5ZEWABAW5cyb44EaebfV8LVBWXZwy5fbyOl2i65e5W0gH/pLS+7S
         FerQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840339; x=1754445139;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4lpYwICX0CJSHu8yDb7qWIdE6OnXVrrqjQR/9Vf5znQ=;
        b=db7SbhtkErM6PzE7FUd4JKdL38YH5LQTgFMDlLp81vP2ghAFh9WURalqkhKLOcPbTM
         m2OJ+W8jPmx9OC2sDXHgtHXOFtRAthQRQwhoy1hFrfvYT1r0bnsmrxC142yhHCmfMJt5
         jW/2D45yWwCVEWIyckmpcPA4lrWZ/b9bIcLy5evlKdxfhW26FE97tDNwY5O4TrHlDdHZ
         hn1FldVe51TBX9D6r0zrfKPj9gJH6uSJvSMavDztrc1leIm71bmd004Z1rU/fEoCjGNE
         BzGW/ryWKUghA3OOhXPIlEIru7+d5pd1wdJ+xYapNGwcMa6k5Ymb4NaOxGnyWgSpd1jr
         Z+8g==
X-Forwarded-Encrypted: i=1; AJvYcCVAyRADn/3Idr+gGA/LCGgG7um13oDGy72oM0tTs1aSYI34DBBcx4jJUf/jJQzzSWv6HBg9oZMS5A==@kvack.org
X-Gm-Message-State: AOJu0YyULir0DwMFpLyoeS5WpSdzGiJT7TbJuozebiywyYAqiGgcHYcE
	sp+HArclbqv+uHmJzMQ56vqwHbxb6w7+iQcHNdIt9xXTWcpcc+NmtujaiS1wwdnFvFnPu8oL70D
	eicBv/OKFp5wGTDpXb1LUH4IXOQpXRvcP48kRSg==
X-Google-Smtp-Source: AGHT+IGeZs7EIs+wsidrRLh3DvOWd/rMI+xlaw3P1K3iT5U0r2fWnca34EEPi5qKaWhGTlIWdLQsx8AEbCbxzPoxkPb7kA==
X-Received: from plil7.prod.google.com ([2002:a17:903:17c7:b0:234:c2e4:1df6])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:f70d:b0:240:4faa:75cd with SMTP id d9443c01a7336-24096bb3415mr20277435ad.48.1753840338964;
 Tue, 29 Jul 2025 18:52:18 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:51:45 -0700
In-Reply-To: <20250730015152.29758-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015152.29758-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015152.29758-2-isaacmanjarres@google.com>
Subject: [PATCH 6.6.y 1/4] mm: drop the assumption that VM_SHARED always
 implies writable
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, 
	Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, Hugh Dickins <hughd@google.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Muchun Song <muchun.song@linux.dev>, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 23E23100009
X-Stat-Signature: o4bxtwinhkdsg7yjbnyoanf1dgwhkyaw
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753840339-473036
X-HE-Meta: U2FsdGVkX1/sig/XdjKELiu0cNbb6O5DR4Jnwa0DyvRpPTtgQPCNcI+xy0RU2S48YSJCft15UAAY+Qf1ZytaSdILk6hDoJ9N179uJdRnv3sFPaLTkYSKfIto2Y/SCrIctqnRStYmdeOPoMwdSI5fz1FoebYMlbfFQCDNozQr4PZpe/eNQH2kucToYpUwZdNLWx3Pf/kLtyjtBk3W3Gca4MvhWEwPkK4nLxFVa75WYoOmDQpNw0TnopI6+N2JzweCBXB1fQhiRPAAp+H6xkwK3eiixHz0Vhx5nA7swlUER/U1BtRtwqGmkqrnCcf3yPzwOI0yAuf4dL91qOCVYBKxy5BMbeMnxBkCW4a4hp75oaeDjLQou/k7MMaGc1l9uYr9lb/xOKYKeqoLiksKsyignhd1gbeGOEONBhZFE0UFQOP+0TUKpPFtyEEiMApUHbSnWLckbozjVILW/aeINyTfvsQhv6VYPvCLMAOz9sZsyKVszoIrD519jcljCqb9kQ6if9mAyo6xTKYT/rq1MDkIk5zzLHXtAafC2jwbIIxLi8X+wkCybUcgVtzdJYS15Av8oROUbJgTHsyaoyMdUrYTrcUllfOLqo47DLR3Njzu2rWlGgS8MR+Hlfv3NQSMgfQdr4wBoNBu/phBnM7Q+ljRrMI45rHMSXyNDcJ3IgH9f4DXcaIqYOHuIXUAusRogS5bLy6/4lRpJL9fSfp2pyhZAA92NJ/tVMQLDN1WoDkMAVhU7L07aUfp/rwnw/CI5On4dpRKtB1CZQdD4vCM2yhFIlKU2rWdcWhaepqSQ2vxoXpjgEh39avHGWks6U9L1cLnAJg/Uiy/cd5HkbrSv0FAZM1zbOXDIqgL2i/ObC5KMdKnoudAWqn5j5byLMjp7mxdCyEq2DQ7AlAPcT6TekW79b/TU1reqOrfW5x7T69EVQQTPYEfQC6tdVLNnOk6dXRNiRkcI262NAeGlZ46m2M
 EFiXonoT
 9WA07bwN5JLXWGQKjityJXyPLv3ly2XbGK43KFaxVv1KjUEuvH0fuv99IyEdXQ5HudvRLiWnaTTKZk/dP8FK7Q9LvsSdHNlc08oh/1OKQ65RjjLTLiApqDHEKUf7zwhW3DDr126rne0b38YSbnMTAhMmS9VGfwM6ePpm86eVcFVF2E5kg/e8ulA6E8MtiX0uWP+atrTbIDkI1k4Xg2JWdADfLFX30OPY6s3gMR808MuYTemDEi/HoC4v8mRGHeRxSAj1IrWQh6k+X+mOXW7Qk4SpA32r4BGterLzFVOIxsJmgklwDTbEPh/t79GZpIbOPRP+A5b7rqSvHOcij7xdeb9aI+dod7qo+8geuYBTu/P1d6ZpgJ+ZHtM7dsRQ2Oe9jlBWKBoUYttwHUCGsJcbPZenu+0B2vZeY3gLz7u2MChxrK/SsR9oBshjHL2nC4teqMMzAPoT5LbSEcYLLLv41YW/4+rquhpzruTUIQ/OK0SKmjoVQEiuP63utCKJtGYhX6puK8lBxuCtL2EnEazS4/fTdajV/dRZmy599bbZmhg9QT9E/Bp8VQLmNryVrzrG97WYVfIq9rC0FDNr2O2/6ayXmkSVj7w/8PKEeaI49IFEvKTFr9Z3nmkWmRsAexA44roG2DeURqJzMJpFQtp0tvxsA/j29veJTssEuhCag9gzjxFIQf013TghRuaf3nfWPa5ldikOhtuQpAQm4Wbz2sgisv0FbR0FYg9oBIhrDfXTj/dt15EQaXIkyl4NhPW5wUXZPzP8ja2FV07V7CKjmvIhwP4ZDRNejwT3c40xDpDA/4sh2Wq9QSOOJk4cI1Numwx1SPv05kjesQkPqjAvBoDntBFre+RKP8nFSnCXmX3ta62D7PjHL6qPnQTclTUaAvV05yIpFLmm/GRF6qTSZOKOKnMh8+irxT7uebAJQMknDW4Vm1Rjt3oyOyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit e8e17ee90eaf650c855adb0a3e5e965fd6692ff1 ]

Patch series "permit write-sealed memfd read-only shared mappings", v4.

The man page for fcntl() describing memfd file seals states the following
about F_SEAL_WRITE:-

    Furthermore, trying to create new shared, writable memory-mappings via
    mmap(2) will also fail with EPERM.

With emphasis on 'writable'.  In turns out in fact that currently the
kernel simply disallows all new shared memory mappings for a memfd with
F_SEAL_WRITE applied, rendering this documentation inaccurate.

This matters because users are therefore unable to obtain a shared mapping
to a memfd after write sealing altogether, which limits their usefulness.
This was reported in the discussion thread [1] originating from a bug
report [2].

This is a product of both using the struct address_space->i_mmap_writable
atomic counter to determine whether writing may be permitted, and the
kernel adjusting this counter when any VM_SHARED mapping is performed and
more generally implicitly assuming VM_SHARED implies writable.

It seems sensible that we should only update this mapping if VM_MAYWRITE
is specified, i.e.  whether it is possible that this mapping could at any
point be written to.

If we do so then all we need to do to permit write seals to function as
documented is to clear VM_MAYWRITE when mapping read-only.  It turns out
this functionality already exists for F_SEAL_FUTURE_WRITE - we can
therefore simply adapt this logic to do the same for F_SEAL_WRITE.

We then hit a chicken and egg situation in mmap_region() where the check
for VM_MAYWRITE occurs before we are able to clear this flag.  To work
around this, perform this check after we invoke call_mmap(), with careful
consideration of error paths.

Thanks to Andy Lutomirski for the suggestion!

[1]:https://lore.kernel.org/all/20230324133646.16101dfa666f253c4715d965@linux-foundation.org/
[2]:https://bugzilla.kernel.org/show_bug.cgi?id=217238

This patch (of 3):

There is a general assumption that VMAs with the VM_SHARED flag set are
writable.  If the VM_MAYWRITE flag is not set, then this is simply not the
case.

Update those checks which affect the struct address_space->i_mmap_writable
field to explicitly test for this by introducing
[vma_]is_shared_maywrite() helper functions.

This remains entirely conservative, as the lack of VM_MAYWRITE guarantees
that the VMA cannot be written to.

Link: https://lkml.kernel.org/r/cover.1697116581.git.lstoakes@gmail.com
Link: https://lkml.kernel.org/r/d978aefefa83ec42d18dfa964ad180dbcde34795.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Suggested-by: Andy Lutomirski <luto@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
[isaacmanjarres: resolved merge conflicts due to
due to refactoring that happened in upstream commit
5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")]
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 include/linux/fs.h |  4 ++--
 include/linux/mm.h | 11 +++++++++++
 kernel/fork.c      |  2 +-
 mm/filemap.c       |  2 +-
 mm/madvise.c       |  2 +-
 mm/mmap.c          |  8 ++++----
 6 files changed, 20 insertions(+), 9 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index b641a01512fb..4cdeeaedaa40 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -456,7 +456,7 @@ extern const struct address_space_operations empty_aops;
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -559,7 +559,7 @@ static inline int mapping_mapped(struct address_space *mapping)
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
diff --git a/include/linux/mm.h b/include/linux/mm.h
index ee26e37daa0a..036be4a87e3d 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -941,6 +941,17 @@ static inline bool vma_is_accessible(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_ACCESS_FLAGS;
 }
 
+static inline bool is_shared_maywrite(vm_flags_t vm_flags)
+{
+	return (vm_flags & (VM_SHARED | VM_MAYWRITE)) ==
+		(VM_SHARED | VM_MAYWRITE);
+}
+
+static inline bool vma_is_shared_maywrite(struct vm_area_struct *vma)
+{
+	return is_shared_maywrite(vma->vm_flags);
+}
+
 static inline
 struct vm_area_struct *vma_find(struct vma_iterator *vmi, unsigned long max)
 {
diff --git a/kernel/fork.c b/kernel/fork.c
index 7966c9a1c163..0e20d7e94608 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -739,7 +739,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
diff --git a/mm/filemap.c b/mm/filemap.c
index 05eb77623a10..ab24dbf5e747 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3716,7 +3716,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
diff --git a/mm/madvise.c b/mm/madvise.c
index 9d2a6cb655ff..3d6370d3199f 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -987,7 +987,7 @@ static long madvise_remove(struct vm_area_struct *vma,
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
diff --git a/mm/mmap.c b/mm/mmap.c
index a9c70001e456..3ef45bac62e6 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -107,7 +107,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -383,7 +383,7 @@ static unsigned long count_vma_pages_range(struct mm_struct *mm,
 static void __vma_link_file(struct vm_area_struct *vma,
 			    struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_allow_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -2845,7 +2845,7 @@ static unsigned long __mmap_region(struct file *file, unsigned long addr,
 	mm->map_count++;
 	if (vma->vm_file) {
 		i_mmap_lock_write(vma->vm_file->f_mapping);
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(vma->vm_file->f_mapping);
 
 		flush_dcache_mmap_lock(vma->vm_file->f_mapping);
@@ -2926,7 +2926,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)
-- 
2.50.1.552.g942d659e1b-goog


