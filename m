Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015F3C87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:52:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 904356B008A; Tue, 29 Jul 2025 21:52:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C7A6B0092; Tue, 29 Jul 2025 21:52:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A1DF6B008C; Tue, 29 Jul 2025 21:52:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DBC86B0089
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:52:25 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3BD20B6A42
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:25 +0000 (UTC)
X-FDA: 83719256250.13.C8890B4
Received: from mail-pf1-f201.google.com (mail-pf1-f201.google.com [209.85.210.201])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5360110000C
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:52:23 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b8GA7JHP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 31nqJaA4KCD0hrZZblZmiZqqdrfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--isaacmanjarres.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=31nqJaA4KCD0hrZZblZmiZqqdrfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--isaacmanjarres.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+0RGgZf0fn2tvYj09uOIiJChmIaihN770HRGuhK7cEA=;
	b=jZmUBQB6Znm6kEgS9JFrPT32io3EUoiUkBSobrSHpMnABSYZeSS9zGmbOUwjE/sAf6+fUI
	4c15tKtc8P/rMk3me8vqc/n9EfTYV2ovKOVNiSfuJDrzlxGVtKnD/blwv7jrOI4b41uahP
	HpCi2FqKCCxTW1eE/teTS/d6sOefyr0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840343; a=rsa-sha256;
	cv=none;
	b=hECvvM4EJeyOs4OMy4YCwh0K7VCEN/QIJTy0QpEFEz15JcCsSe8k4fCzwpDqol3bhsJ17k
	mb56ibZdShFKM6dnbHvlMVoWDIcm5/rzbFCw71Rw7ZYtUTt9z3BUJ/coXHAhtXjePJoDfI
	tFHwLJ7bpYhi0+s8AeCI1h+8iehvs6s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=b8GA7JHP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 31nqJaA4KCD0hrZZblZmiZqqdrfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--isaacmanjarres.bounces.google.com designates 209.85.210.201 as permitted sender) smtp.mailfrom=31nqJaA4KCD0hrZZblZmiZqqdrfnnfkd.bnlkhmtw-lljuZbj.nqf@flex--isaacmanjarres.bounces.google.com
Received: by mail-pf1-f201.google.com with SMTP id d2e1a72fcca58-74943a7cd9aso11340423b3a.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840342; x=1754445142; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=+0RGgZf0fn2tvYj09uOIiJChmIaihN770HRGuhK7cEA=;
        b=b8GA7JHPotpkMNlu4VbkGshmNlU+ZIQXIFOG+dENfBhzkwyiNXIV5HAgFzU2bGHr7z
         zhiKXO+3EkHaGW72haI1N3pZf2fwZyNsiYIjD/AHS/NopPle8jg9kUddkprN5RiG4p5O
         k62Tntxiy+AnBiVfr9j30YzArVN6kT8KjIVTbjq5ks3p6B50F2IaCzJJzd3Vy0UcSHgb
         HnczrEd4TJc/p68I732XAs/gslbLRfX3C6vnxTZPh78hvEVBjPqVKhTSu+BBHl/DAHUZ
         IeeZrK5ZHnEtqAo8626WEEJChg46SoigSXCxWfH81dhmDNo9Y+JLZjcN2oy3kTSIJrli
         67sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840342; x=1754445142;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+0RGgZf0fn2tvYj09uOIiJChmIaihN770HRGuhK7cEA=;
        b=EyiJtFavSlv72GFHQuDkNHSWt5R++nuB7BBB3RjB5yPzYleUU8nJrrPfNLzrn2QMTe
         nkVTp1UMBmNp7JFCsXBj+aAfhOWseR3HJR27zrKoKjVnA2D7KGAEJUk+d5sYkiRYfM5h
         Yye86YGzUssA0F7rAHeA0cO3UqylJSdVl47hq2lINQs7FCoyHz00+A7PUFDfD1ELOQFx
         kYQ+GpfFo+saZamBN2p681oSBpA7bs4c5OdlYr/m6k75ULpfAncKqSEyMgjjhpFhweuE
         /L/KnL3an0jXkahSemCgL7JWRMPVLjGuVCIZsoQDA1+Fy8WXldvBCoSCLPa+Spqm7Rb8
         OmLg==
X-Forwarded-Encrypted: i=1; AJvYcCXQlm9cEMn/beIHPElLa1ch3cmlnvV8C/d0hX6KG2Hpq+eKsTPx7qMuAEC5mTiygJcVlzYvKe6Wsw==@kvack.org
X-Gm-Message-State: AOJu0Yz8pk8d7sfqaV+EiOtEeyS/iDnfs9eiKvxPyNT0ttqjTOLSIGCa
	dTQVAtpO04MiA3oxO9qwHxYfOj6WpYAZ/oCL4eT+K9yRYibbsuTr11i73brjj1WCthTwXGUzGTL
	XmwBkGaQ7cRCZJn2qOBd1taTNiqET3+IQjKC/Rw==
X-Google-Smtp-Source: AGHT+IHzNEJ/jzYX0FtMn2+7BiG5mL108A3i2Ajr65TeHR5WLUWsP/dCyaoBLvXvu+kvbEDU8meaCfPSHxSvCaZY6Ind0A==
X-Received: from pffy13.prod.google.com ([2002:aa7:93cd:0:b0:769:ee8f:9dd0])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:3a1e:b0:730:95a6:3761 with SMTP id d2e1a72fcca58-76ab092f862mr2694402b3a.3.1753840342087;
 Tue, 29 Jul 2025 18:52:22 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:51:46 -0700
In-Reply-To: <20250730015152.29758-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015152.29758-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015152.29758-3-isaacmanjarres@google.com>
Subject: [PATCH 6.6.y 2/4] mm: update memfd seal write check to include F_SEAL_WRITE
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, 
	Lorenzo Stoakes <lstoakes@gmail.com>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 5360110000C
X-Stat-Signature: ax6fypmkn6rbgek4yqoudwxy5cpzey98
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753840343-646272
X-HE-Meta: U2FsdGVkX1+/KRiICreRb6ZyLqwxXqWQUSaou+P+lnVj/FWL+hpz6TnqPdeR+XqAMf+rKK2l9SJnXUSLFm3s/jW3Wcx+1utEwtiiOOKaoM6FgIM3VmUZC7d24xPaEZwuqoVDx0Ux1PZliriOAw2+6gOZsNaeUtW+BJhCtIWXWBi3sRYo55QkC//G2kbYHZbu3seVoyJ6+VJ4chQobZ9KOpO6NpINJ0GTVyra8zsoxbzF7IL4XxplwxFmpr8lEHweYcqHLmhbkrUq+x3DGJA4ay57SLygg521DXTEtHqgetPXtDCz7uUHaO5E/VXAAojOO9bEmpyCfxNJqTWK3b01v1mpAm4Vp3yFj8Q0x0xAWo0bdrksAG6sO2+DZ4f05JK9zMmBjUDlX+/v1sQogb4nWOCfD98h5dJY2qqnwL6Snee7rUxgmYucDVGV0fgxZt7PQy7Upa/Dr5k2iOtFfmlHp9s7sHwAhnqpGOEDr4OKcXTvFfrTidFOFTrJasnD3HQBJFY9occHOPjOQ5Glkt9k/o5fViPdIb/W5OdHknW+pqbu8Cq86apsGStqdwCr5rkyedtvAn86osQb24y6wftJsd+rfUN1mMmBLJIh9pIvMKeqifQ6fPOR0ycnfwMWaZ67CIzLLwsfZldBP5o5Hdtz1oFuPCh+/9LjwCKPhiHpDJtBCXT8+MkSdjGikTGD3GSvtQ6c3+ex8PXHq/2dxZLYT64ra4iTOZDF8MNULY/E8EIwSY4gt02jvJGhx/l2LQOKYHibT1dYhUNx4gmPXFxF2XisdBxtZTbzJiSQ2ytRHpwvFnw2Wgv3HQt558iDZ+nM6vdOE021NFng/u1TqPskEmenUdkVoH8cm4hEKqRW/r/cwSYFrhRHwv5398KntXX/Vwa+HnrzohqyW2aHH4bGosp30aZptmCwLZeahcQ4jgx7yD3n9OfLND/5aeV90JrXxp3DZg1lIeGKtrWpk0+
 9nJ4Isav
 Ml1VdXLvWn51mGSFDv60242PoDps+MvUzfwu61NxdtmY/0BSXl6KgtiprReYiAZ8Hrp5plnNFH8hKhggRGCVlrS+veTekz3JwcSgS8AyTVn+kqXEKvPEGtvHNoQjslQ9LGE9EvHv7bbPtBNSKRMnhVGozFYslkqrE6PhFi3m0s9hPTteyuEZb9wbJWsglCiItwFQFHZfzeWpSpzoMBzf5zo4mhbg0raPFuWOCVtiGDUCzZhSb7/H2IYVQCQqUKt941BUdCBJtvX6lhJSTciYWRyd3+Y/IelPWjqPxP/nEwleKkjN7jVQW3v9WkeI866G3lKRRxcEwyKCJyynVlDFEk9DAfFOjq/q/F4uH8nvCe7b3EAcvFnvxGpnlUOjzBHxaUPXNumYVIR6/tWjiTeGTX8qbtxWgVNmKlWiGc1ief1Mga3OmX3Mw9Q719T6lFB5EClfduZE5fui9bs5AwE6HTeeVBhat7tZLVFoTIsX26jzKKFe0mX+tHHCdgx/M9IOQNyi+MRCCtryv8/7pRC7Qpvay73bHT4mMEg+OX/g94xL/MRd5hz3GCEY+m0Bi0+kVgO+nC2kDywdQPBKa/6YKAC1ILdaO5/AobSlkGRB9CPB+gkcuZYwApb0RPkzJfDyRleQ/Gym9bXvvC+QUz0wfSUCDWTkqns5fLeSaH4Tq1yp0FgQZl8Qn7Syjh/qcQcbyGo+wPQQMMmL46/X3vhxgUUUbBsbInWpcSdKWok7+T5Ufiow9+6dpfGDGw97hCsnhglhGKNg8DWORlfMpYeurivp5U8l5dJnLn35AEuSqCGi/tW3eCThu2NmiuBxEONCkSBJJrqx0wQtNsxKwJsBkaVI1FkhFz0wQ/rIt7/W/2jxecsyCc/oTjOU8DXzLMEND/NBt3yH2OHbPyMWGauTLp1KART5pkKD6r1jlcYBkWhHW2XGqO1HU68TDYA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 28464bbb2ddc199433383994bcb9600c8034afa1 ]

The seal_check_future_write() function is called by shmem_mmap() or
hugetlbfs_file_mmap() to disallow any future writable mappings of an memfd
sealed this way.

The F_SEAL_WRITE flag is not checked here, as that is handled via the
mapping->i_mmap_writable mechanism and so any attempt at a mapping would
fail before this could be run.

However we intend to change this, meaning this check can be performed for
F_SEAL_WRITE mappings also.

The logic here is equally applicable to both flags, so update this
function to accommodate both and rename it accordingly.

Link: https://lkml.kernel.org/r/913628168ce6cce77df7d13a63970bae06a526e0.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 fs/hugetlbfs/inode.c |  2 +-
 include/linux/mm.h   | 15 ++++++++-------
 mm/shmem.c           |  2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index ac519515ef6c..ab951fd47531 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -136,7 +136,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vm_flags_set(vma, VM_HUGETLB | VM_DONTEXPAND);
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 036be4a87e3d..05b970a6cd28 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -4023,25 +4023,26 @@ static inline void mem_dump_obj(void *object) {}
 #endif
 
 /**
- * seal_check_future_write - Check for F_SEAL_FUTURE_WRITE flag and handle it
+ * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
+ *                    handle them.
  * @seals: the seals to check
  * @vma: the vma to operate on
  *
- * Check whether F_SEAL_FUTURE_WRITE is set; if so, do proper check/handling on
- * the vma flags.  Return 0 if check pass, or <0 for errors.
+ * Check whether F_SEAL_WRITE or F_SEAL_FUTURE_WRITE are set; if so, do proper
+ * check/handling on the vma flags.  Return 0 if check pass, or <0 for errors.
  */
-static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
+static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & F_SEAL_FUTURE_WRITE) {
+	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 		/*
 		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * "future write" seal active.
+		 * write seals are active.
 		 */
 		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
 			return -EPERM;
 
 		/*
-		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
 		 * MAP_SHARED and read-only, take care to not allow mprotect to
 		 * revert protections on such mappings. Do this only for shared
 		 * mappings. For private mappings, don't need to mask
diff --git a/mm/shmem.c b/mm/shmem.c
index 283fb62084d4..ecf1011cc3e2 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2396,7 +2396,7 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
-- 
2.50.1.552.g942d659e1b-goog


