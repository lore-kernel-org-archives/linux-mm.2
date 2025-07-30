Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658A5C87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 004F76B009F; Tue, 29 Jul 2025 21:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED1156B00A0; Tue, 29 Jul 2025 21:53:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E0DB36B00A1; Tue, 29 Jul 2025 21:53:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D29326B009F
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:53:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 93D34133C0D
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:50 +0000 (UTC)
X-FDA: 83719259820.16.BC72C99
Received: from mail-yw1-f202.google.com (mail-yw1-f202.google.com [209.85.128.202])
	by imf24.hostedemail.com (Postfix) with ESMTP id B9F30180008
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:53:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="waHRKv7/";
	spf=pass (imf24.hostedemail.com: domain of 3K3uJaA4KCJI4Ewwy8w95wDD0E2AA270.yA8749GJ-886Hwy6.AD2@flex--isaacmanjarres.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3K3uJaA4KCJI4Ewwy8w95wDD0E2AA270.yA8749GJ-886Hwy6.AD2@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=39x+FWPwzH2SKG6lIOzneDjaUlY8W/uoBQrpnBZb02Q=;
	b=XOKanf8RxtRRqFaQ4z9nJV6B03Hr8BhHA0twleRkcku2LnPrlnFI1fnhDBIBB/wL1A4WSx
	eTOW40BTNwbLJF9jMJuK24upU5KcTX5wmuMdEc3h1rSJkcULpvSrIeaYHYcgXl3pB0eX4c
	cc/MELhXogfrrahIqldnKhYvPb1C2Cc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840428; a=rsa-sha256;
	cv=none;
	b=N/FkAGJ7tKFeqriSaBCLiptd20Kyc0Cv4wPdMUTmMZ5AB+Xn+le42HKU4awjHl2lQc51is
	nL6EtL4GecFR/nQ4Boy5LBJ0N3PxcUXTSQXk8e+nlMeO2PahgxX9YTlxECsV0ovDxIiSpj
	8ZMniNfVXLtrPjfyozVmOvx2wl7RqYw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="waHRKv7/";
	spf=pass (imf24.hostedemail.com: domain of 3K3uJaA4KCJI4Ewwy8w95wDD0E2AA270.yA8749GJ-886Hwy6.AD2@flex--isaacmanjarres.bounces.google.com designates 209.85.128.202 as permitted sender) smtp.mailfrom=3K3uJaA4KCJI4Ewwy8w95wDD0E2AA270.yA8749GJ-886Hwy6.AD2@flex--isaacmanjarres.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-yw1-f202.google.com with SMTP id 00721157ae682-719a3eafea4so92502657b3.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840428; x=1754445228; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=39x+FWPwzH2SKG6lIOzneDjaUlY8W/uoBQrpnBZb02Q=;
        b=waHRKv7/mWjrnw70qzvsPtvLhMxFEsfNkYE9Qvqev2d9xpPo9CtxaZdvXLuzDV8qlm
         KJ+6lMOMiJBoMArrkVDVWZnuvljX4JJ/wyLzIY2vE3GB0uYXdkb0VEDStExZaRliUJ9/
         2oTYI+hAVN3LO6iWxwgv+4G5F8F5qLVqwJ2k5oz78k9cDHMhc6XKOBGVZvJwQIjutMx0
         BgWrJtL9i5Ae/7dTAX6YEkLwm58jbDoeVmBohJZ5iuTRdDl4QcIvgV8gFXSfZUnGmlrK
         b0KskfpLADylvOUKD3RMClqpCYCbaMzINfq6LaHChjC4nXXGZC5YtHTtjFpY3mU1yHEh
         nOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840428; x=1754445228;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=39x+FWPwzH2SKG6lIOzneDjaUlY8W/uoBQrpnBZb02Q=;
        b=ciP1A49xoTv09T3qCRAcJAyOES+rAMxmwTvkUcYzFDh+pTFT9vS13seNKLukl4igWN
         +dgxVOASqPEwB/Y2SX2y4PNR70YW3HChjPun6bTUzcIYxyZIVU8YSzVc+CsD5V3H5wMb
         nzcjChtPWybIbqzVQiKkDyS8DpITsH3HYU8XlWzCUcfO3IhUMFNjs/DsQ4J58xE7zCeD
         h3XfEhsYI1nD6xT6cZfp0nsLKd5RN2T5RWbU3TFfZJWhdO76N4vSacUYaqU9apFD5WI5
         MGDVSz/7oSUxzB35Hl0P6HR2qaZDQwI2q18S7RedW+yRm4S7SGLXUhKVl4hc+nCBhvJw
         0ySQ==
X-Forwarded-Encrypted: i=1; AJvYcCVN9VlJktCpRXfONx3yDr64SNOK/2Aa34ThvWYmIbKphQ9vVVZT/g/a39+mZjG/bC6IowuGulRVRA==@kvack.org
X-Gm-Message-State: AOJu0YzFXBzLuqPp5sbB6iL14g1ErS+Bx/YP4uIDWgCIvQWdruwFna55
	e0hem/8J8/z6h1xl4olnbGaNTvyA1cQpgS/ezqHaRa0zDTa1tXwc7IsV2AV9LUAj1TXUww1kUSb
	4M2nKVkw8RjiVkXzvqT46XKabwgbUHXb9kxZS/Q==
X-Google-Smtp-Source: AGHT+IGjCf5KwJgx9XGkjXLwUnllofZO1a2HLuupENahyAxK5jK5Et3l4fLbuwgKvSEACA7+q44be6tAId7B5VpbYdPrmQ==
X-Received: from ybdo28.prod.google.com ([2002:a05:6902:6c1c:b0:e8e:157e:e705])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a5b:ed1:0:b0:e8e:13f1:f174 with SMTP id 3f1490d57ef6-e8e315f2dddmr1583968276.37.1753840427764;
 Tue, 29 Jul 2025 18:53:47 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:53:31 -0700
In-Reply-To: <20250730015337.31730-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015337.31730-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015337.31730-3-isaacmanjarres@google.com>
Subject: [PATCH 5.15.y 2/4] mm: update memfd seal write check to include F_SEAL_WRITE
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
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B9F30180008
X-Stat-Signature: 6394rhtu37ezb8e7tf3beybp9hn5pmjn
X-Rspam-User: 
X-HE-Tag: 1753840428-554104
X-HE-Meta: U2FsdGVkX18L60zYmy4EeVCNJnW5wN53oepWzCGNGFFxlB1OKQ5CG+hDC/n0TO2mvOg7O8zpDX92YcgZn2uOXIM55hreG8ls0vbIPohSSB7YNF9bMG7Ty88w3g6OLIoc0JVBPBBAkPQUBVWldxafFmEl6W8P6W3Q63giQj5nGj+03vgulN9EcQOPG4DqEtT1BLx/pB9P6qZLWGvNAZCoF6OFhOk9nMa2c+mJXrWrCP1Gpm/PdqkAZb1WMb294dEFwl6XACkaXZbzZRTbbhi6dnbPw5K8WC8rk9ZFwnEXKWjVK99ZKmSEgGjXU4CP5PI6jA0CCKCeQ4kkuJHOuXy/6I8j1DAqe1dLh1q/HCV5IAjyN+5SOn9k2EA71lmD+l4+GTzkX1UaSAZY+UmowgZKWH/Ybjz5xW+uOY/b4LcgsRfw6JypazHoAReonL8Fmfnmp1+kkMJvohGV2AyAJ2x807XpkDxxyHEkhfnUrVPm/96gpOYpCoC9XOX50s6X+b9gNjAlLYzkCY8PgyGyHi1MFiyO4pawkhImNBlM+XlINX4LS+x6X923HNHrGHEIjo1SDDDrBTGoUSBVAIfQ2la8h4hzEfy4fRmU1lXwC8+69HVMmGgct93T1V0mMX0nBdzwlTB9AvHEB4JTors0LfpPAPBWoRtdzNYWOMEHwpUtEzDXjs2224FXUhXZbpB2TA6sBXaIgW0aNCe2EYGc62nKTPa8nIT1XK0yxcV8fwaWFFqSTlJSfYv1Wrahi1tYxi5Tazg9TKAtmxN7AgpK+Qpk812B69ZGE3CRhRxXlCOyWBDviVv3ilvuvpGBHVs9xHQYtrs2T0N+agMzdyB625kh7We8y6GYcKg3n75wM0KeeqemVrCPNJ7G9jH3XJjAgFgDwVM0mmvVes+Ib6eCXjsDtH7wXKBq5soEVr5mYgCzWqu4qOGC5gdnnqUbGbAKSqyUO/AqNl/9XAfxypazGNf
 SFxTSOpq
 g+tIgOc8LzwLixAeCVREloXIm4tdYWAEIYHShWDhCg8HYC+0T3sM11znorjIGYWlh3I7HEw8Fy4+wAvBYh5RhrUEZAAiaDenB0M5wKjk0ZCJaD3/WxzK4OdUfF1QfQAmTR84DNtqqMy/VznERR3uwOpXpWnNGc9gTtgwD6y9lmhcO39Zb1L3ad6o6Yuu8zJkYUJURwOVfv2K+JyMi/DaBsiLaHQwtqTsmmXfWbttHO07Qic/kxNodKYWozZTRo3IxUAiG01ZKPU7srDw7sLrdsv585TV/ki2snApK6+BiMzdBYvQzwa4SZ1JCm3CbDIFx/I0Kr+TK6nf1+3gDvC4Jfr2w2MNaj49AFFS2h3bqhVf2gZ9J0B5w051eHzSKHghiKqgC3L0BIw4mXZrWDnoBB5A9zOM/c9npV9gGLUn3ayzz4z4Liyiyt9eXPx2LWN2jLJbRVIMgsDUMYCQWbPwoLN/CkZNbdpBS+JPM3tew65x5HtbJGtRek3nFcd8iCMqegl3rfQ5MBjMBuThgVRBGqdnAMagrCaRwB5hDn2f1WmqsGnTq+CDxjrCPLj7+xnj/ec+pHAIYubXjgtSARqP5RM/CFzVlAZfY5GFE4RbjokwdynznLXcpDXGpU+Yr0Pdk+d9ZSLj9tBKqgSAolmVPIVkBOw0zi4aO32UBSz8kxV5I2Nfupumi8ZfpdXRSnpwYe7TLf39CeCbpr+K+QFvuuov140+pqW3oJS7lh0Zm+XbKyXa21lJmVD/9NqiqQBmVQck2rZ0GTCraXp1AntQAMinCFpb/QN56LSphtALUpYrThtUQZ8mC4YFi00xNgsI+Xg0EaWmcAFQQMweiFhojwR6cQT3PV0tVM1kDEzt0VF0nlX92QY44SZgqi5bOZ+KHjuxZD50XVQNqyiW3IkIir8fsp5SPb2zJRZvwbLPK0sFoqKU=
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
index 9b6004bc96de..c8a5d94561ff 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -148,7 +148,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0ec171c6557a..61874611d0e4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3287,25 +3287,26 @@ static inline void mem_dump_obj(void *object) {}
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
index 431a48e1b90c..06ed84ebdf3b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2262,7 +2262,7 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
-- 
2.50.1.552.g942d659e1b-goog


