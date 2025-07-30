Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21D95C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:53:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B4F1A6B009D; Tue, 29 Jul 2025 21:53:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B26826B009E; Tue, 29 Jul 2025 21:53:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63AF6B009F; Tue, 29 Jul 2025 21:53:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 97F196B009D
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:53:47 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 46D12802A0
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:47 +0000 (UTC)
X-FDA: 83719259694.01.06235DA
Received: from mail-yw1-f201.google.com (mail-yw1-f201.google.com [209.85.128.201])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7B5372000D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bj8HDUAF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3KHuJaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=3KHuJaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840425; a=rsa-sha256;
	cv=none;
	b=KoWodYukipjgrRBe5ApqNGycx/8Zri+eXTLq3otUSlrwBAcd3MZSty+QqMVmBky5FxvLql
	pi4U18d1XGP+aN9wBEoVl+vMkPJPm7kIJnoPVnF3J967lf5FQ+e1iiZQ+JJ6NhQ0z/N5L6
	Mb0+Ik6UrHBTHdDzOgA6bBqlqQs4wLY=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=bj8HDUAF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf03.hostedemail.com: domain of 3KHuJaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com designates 209.85.128.201 as permitted sender) smtp.mailfrom=3KHuJaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840425;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=onlJz6BD80Z84XFpKfEiLRPlkd/ws/nZvRst3Bs3TXk=;
	b=juSnqeXg9/0WULCOkxENIZ1M0RaOwINcRrIQXNtkX+WoBmPEyWBXdeBsfb8SVYceGq2we5
	8o8qQU97vNMRcZXJ2Ooi10h6MMYPBBtjEp0b7gzjtPwGHTjeT2JQh7e8rUW9EHcCWRE+Sa
	S6dxCVW/ldOZu6cGCnlL1fYqCP6zK30=
Received: by mail-yw1-f201.google.com with SMTP id 00721157ae682-71a0e9ab539so5907157b3.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840424; x=1754445224; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=onlJz6BD80Z84XFpKfEiLRPlkd/ws/nZvRst3Bs3TXk=;
        b=bj8HDUAFcO6WvZ2Z09H6yGUfq7ajHmzuT8w7zuJGPT5qRH+jT4DXnu3mvYPWSWXsEi
         Y211l+3U5ndgkS8ZoBQdNBjzqYqCTzvEj5sfSgsRdMufVEuRyhT7h7GSCCI2h8x99wJz
         rSWzwwESm2vvYaqfznIZdVV1RNVrj0F3QkFCQi/rEW7rlKXpgzYKRGi/YfQQ8VavBuWM
         sMKZG9L+FdlNgwOxArzGBgrow3buZVI5p32Hfa4Q/Ypjkvv4EUh57tKezl6U5n/a5UEQ
         4lwit1xZlO8r4C/iWth7J4Qnq5KRd1eJszK/mTkX2DS5VNTH/5xG6u0JdUqIVdzLxy3c
         i7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840424; x=1754445224;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=onlJz6BD80Z84XFpKfEiLRPlkd/ws/nZvRst3Bs3TXk=;
        b=lifA9BrAxpST//Bx+E4QBXv4A944ey1/1RddSBuX/78tlgW0E5+DM/uyUoCL6PheZ2
         ysUTao1zhOS5h8nwDirCioLviPHlANfza2ygup0IJvNWU2XL/w0RTPOdWhCJgs5vE1pe
         Nn15m1B/U50LmyL4Jt+GdJXKdRu5R/rRF4XaFoM8aGk+tgPZy5wwyck7vjrBktqqFv26
         SBHCwbtY89wH+bdNx84nnzfcBAWWYk4A8yMaKfGh29OFjdv95JO31kYHb7JMuw9BK7vn
         2PbQmtsokko5b/77wHrcvvTyMbir6fcmNjU/zbaBOqPA1+nca+pA/QEuSDbgDsdxLpDX
         3Nnw==
X-Forwarded-Encrypted: i=1; AJvYcCUINg1/FaUqb68b4wO9nzCMXyPeUrSTt1XOD8k72FqTMZNKhneWG0MOxmL/QiR+BetPlokck+ypyQ==@kvack.org
X-Gm-Message-State: AOJu0Yzu5/T+iwPSYsEFnfgfnlipYpZGbR9xfGvMg5Q9xN4bR5Ys51Q5
	Ilz5OfP1seOALPa7xF4g+0UgRt1T0qabqH3Vu8bXqE7zLYTkoIqu2YH6xYL0WMRpyKQ8FGOhHvE
	FC3ijnCoeuz188haq7L206tHT0COH1t2p6pWKFQ==
X-Google-Smtp-Source: AGHT+IE8EMAZwcLOercLFd3V29Mtw+TV1PTT5MZmnf1aBt+aUsjJ3tKOc3EUKuRNjZwY5ubNKmMtU8zJxxapqktimftQpg==
X-Received: from ybbgj6.prod.google.com ([2002:a05:6902:4186:b0:e8d:d752:d99c])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6902:4791:b0:e8d:743b:ebc with SMTP id 3f1490d57ef6-e8e25148065mr7113696276.23.1753840424526;
 Tue, 29 Jul 2025 18:53:44 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:53:30 -0700
In-Reply-To: <20250730015337.31730-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015337.31730-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015337.31730-2-isaacmanjarres@google.com>
Subject: [PATCH 5.15.y 1/4] mm: drop the assumption that VM_SHARED always
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
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7B5372000D
X-Stat-Signature: gd7ry4ehmwjq1i6f39xwqjguhibqunts
X-Rspam-User: 
X-HE-Tag: 1753840425-864037
X-HE-Meta: U2FsdGVkX18vVn5vxW3yAlM8xH7l8tvaKj+SX5W3Uc3N6JfzJY6GPKHEjZX1VR6Pf/PPV3BLiwWHUWsl+esN1EAYS/AmefDldbBWqNFcrQfWZhRvcyy7/1IuxuSFLdN4TwJ0j/5y+Nvqq28OcKL6aIidgSRjolLZ8SiRz5gcKP3watqP8+3H/pB6274UiS9opTC0jq9pg8zym8PhgWcw63BPou2sPiYAtRsF7z4F9eRHCzUWj1vm8AFQtBKGfa9dKxgw5D9XVzE6wWQbdeJbCxFzh3zYYJfhWEgBu5SvvZdzrFe0szMly7PMBNh1NTRRQIBe5zd/OFlt8lccWvLT78FH7U6sFaYJpAJJnQIp6/9izZSZSLxwozc/StXlo/vFfvU4UT6d1zMtJoeebNQYsa/dEeHfw+N8FgC/45rRhGzoRH1chhxCuM+mfMHKuZMwgaS6Zi8ezaUNBWCYkP9BZEpRaRVFa1p7/6AL3f5YAIpialBc2UUduPAJz90Exsr64enU4g5cjYmXwcEKtTzyrR+ZSazwGl8JzUl/lCplifrub5zXbfiyeeOzfwipRkrMPYGHP/V1TXWBD7pIDMFprQ5EgqoaxNZaqOswkAwhZQd+lJVnX7Cyqn36DrjPv+W9J3lotmpeSzIwLD3PotogWNJZ7h+/Fcy7pPh/JQb1dZayCKE3cTQJLJRQnqiOe+csPBHY4kCp21RdbZv4ozRjXBgzAVliobnuoM1lPLSLh3S8aGJh03W/Ehcz0ujfG/JWB/u2NbF0TSlug/IvOa6SrmZ8yuSgKsuj3ieK9+5NTck93B0xDNCy4Is1RJFhod15koUqrYn7RUEui9sMly0SLO5lChYR5pQ3+lb8FT5RfF7E9Bj3puuyoeJdy1Ta+tAI+kOSR9mnb+yaiaBT/dencQymaF3rZkLvZ+IKnxucw10hEqx63k83hoM7TcZR+pZIBAW2focYO8Am4x6v9qy
 fb1kzFcp
 GqHqDVWTQsIkeO6RMbmTcwYqkbFR9ctizRKtqQEkcmKazOqqmCqzegykdzkQbkpEaw9p90rCob30fz4R0NLMm+e0ZHV+xQqDe/7C6YkkE+b78T0YuN/wdrYPehIVMossT4DPAd/PymNdGjkhkbLrtq0vmQoPKfkjbe8UZPF64OlbSedcMPc561i5EkKbsQuFGDr7W9RZKyCV9a2J2xVDOwUoTQUMZbuwMzHMWfJUWTksBc8ks0VU2rk9WhzV1pYUod6lcxwvai1O9qMylWCX2cOPpzwp40Jib/LpSeepPBAyDUx5puNUFgji6ZQWwlBfyUn5BxgpCmODmPMXdwZSp1+OtbVBVp0i6zRROb7KSpDR4J5Enl1ZYsPULCjNsD4iICyk72yXbMEYa5xfSC4vEF5gRR8f2G7fddT1HbM6s2sTiolGg8ExBR+ecg4rhdn7nyOA/LsZ86VanI/3L4+8oE37wvZPTdiJ1eW7oY1S3Bx/+1IBYdi/f4QgKZvACm9Nk0Jk2w3LYXRWDBrU1BGnhYrWUmNIvY1+6I+Bu6A9p3w5kXqNrRQyxmW+G1rDlDPU8ez1LhpL4iaDthKX4juB5AbmO4Z0+WF6dFjtiOlGWFuCybLmwBrZtCgPINGcbJ9SuaoRa0+utbF8+3ha1l23osjaeyzQHu4OrVVfWC6ogbG13GEvV3M3ZzxnusDMW51j0EmgNNkvzSsES0HtXmNB9ShU8tujgwrcBYaLITx237uU7J/z8aKUW77Rm8F3Y0anOzOQZAFZ9GjyrlA4AQ2/g2jgFPQKIqxK2+ef4wo2CevmuI9gVDdsGUjquwyjM+6HIoy9ZBVQ7t7fdtTiKmC+5kGpeAWGFiN+Kd9yHsJ9yijVO4+NeH1q0aBKeD3ZTd4bbDrYu9Ma+ZOXMKBtAp+icTcI15L89t1GMo4Q7XlQh8SgwWC8kjd3O0XIcNA==
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
 mm/mmap.c          |  6 +++---
 6 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index a11172498279..a8d708fe08b3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -444,7 +444,7 @@ int pagecache_write_end(struct file *, struct address_space *mapping,
  *   It is also used to block modification of page cache contents through
  *   memory mappings.
  * @gfp_mask: Memory allocation flags to use for allocating pages.
- * @i_mmap_writable: Number of VM_SHARED mappings.
+ * @i_mmap_writable: Number of VM_SHARED, VM_MAYWRITE mappings.
  * @nr_thps: Number of THPs in the pagecache (non-shmem only).
  * @i_mmap: Tree of private and shared mappings.
  * @i_mmap_rwsem: Protects @i_mmap and @i_mmap_writable.
@@ -542,7 +542,7 @@ static inline int mapping_mapped(struct address_space *mapping)
 
 /*
  * Might pages of this file have been modified in userspace?
- * Note that i_mmap_writable counts all VM_SHARED vmas: do_mmap
+ * Note that i_mmap_writable counts all VM_SHARED, VM_MAYWRITE vmas: do_mmap
  * marks vma as VM_SHARED if it is shared, and the file was opened for
  * writing i.e. vma may be mprotected writable even if now readonly.
  *
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 720e16d1e9b5..0ec171c6557a 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -706,6 +706,17 @@ static inline bool vma_is_accessible(struct vm_area_struct *vma)
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
 #ifdef CONFIG_SHMEM
 /*
  * The vma_is_shmem is not inline because it is used only by slow
diff --git a/kernel/fork.c b/kernel/fork.c
index 22313f31dd8c..2fd9c431bf45 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -580,7 +580,7 @@ static __latent_entropy int dup_mmap(struct mm_struct *mm,
 
 			get_file(file);
 			i_mmap_lock_write(mapping);
-			if (tmp->vm_flags & VM_SHARED)
+			if (vma_is_shared_maywrite(tmp))
 				mapping_allow_writable(mapping);
 			flush_dcache_mmap_lock(mapping);
 			/* insert tmp into the share list, just after mpnt */
diff --git a/mm/filemap.c b/mm/filemap.c
index cc86c5a127b9..9fec53a3f550 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3408,7 +3408,7 @@ int generic_file_mmap(struct file *file, struct vm_area_struct *vma)
  */
 int generic_file_readonly_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_MAYWRITE))
+	if (vma_is_shared_maywrite(vma))
 		return -EINVAL;
 	return generic_file_mmap(file, vma);
 }
diff --git a/mm/madvise.c b/mm/madvise.c
index 6c099f8bb8e6..5dd5706270b0 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -908,7 +908,7 @@ static long madvise_remove(struct vm_area_struct *vma,
 			return -EINVAL;
 	}
 
-	if ((vma->vm_flags & (VM_SHARED|VM_WRITE)) != (VM_SHARED|VM_WRITE))
+	if (!vma_is_shared_maywrite(vma))
 		return -EACCES;
 
 	offset = (loff_t)(start - vma->vm_start)
diff --git a/mm/mmap.c b/mm/mmap.c
index fde4ecd77413..e1dada58788f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -148,7 +148,7 @@ void vma_set_page_prot(struct vm_area_struct *vma)
 static void __remove_shared_vm_struct(struct vm_area_struct *vma,
 		struct file *file, struct address_space *mapping)
 {
-	if (vma->vm_flags & VM_SHARED)
+	if (vma_is_shared_maywrite(vma))
 		mapping_unmap_writable(mapping);
 
 	flush_dcache_mmap_lock(mapping);
@@ -664,7 +664,7 @@ static void __vma_link_file(struct vm_area_struct *vma)
 	if (file) {
 		struct address_space *mapping = file->f_mapping;
 
-		if (vma->vm_flags & VM_SHARED)
+		if (vma_is_shared_maywrite(vma))
 			mapping_allow_writable(mapping);
 
 		flush_dcache_mmap_lock(mapping);
@@ -2918,7 +2918,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		return -EINVAL;
 
 	/* Map writable and ensure this isn't a sealed memfd. */
-	if (file && (vm_flags & VM_SHARED)) {
+	if (file && is_shared_maywrite(vm_flags)) {
 		int error = mapping_map_writable(file->f_mapping);
 
 		if (error)
-- 
2.50.1.552.g942d659e1b-goog


