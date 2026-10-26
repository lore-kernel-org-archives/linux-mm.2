Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5961F606A32C
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 22:06:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=EN4ZZO5m
Received: by kanga.kvack.org (Postfix)
	id 374BF6B05B1; Mon, 26 Oct 2026 18:06:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FF326B05B2; Mon, 26 Oct 2026 18:06:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2389C6B05B3; Mon, 26 Oct 2026 18:06:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E461C6B05B1
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 18:06:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 855E5A853D
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:06:34 +0000 (UTC)
X-FDA: 85366162308.11.38EB4DC
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com [209.85.214.200])
	by imf27.hostedemail.com (Postfix) with ESMTP id D304040005
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 22:06:32 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EN4ZZO5m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3587faggKCGISKHAWAJAGOOGLE.COMLINUX-MMKVACK.ORG@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3587faggKCGISKHAWAJAGOOGLE.COMLINUX-MMKVACK.ORG@flex--skhawaja.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793052392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8qqAYIAfPgq1UPwTJslv5kHWAuX4fEMnW0g2gFuydk=;
	b=XTgaw1SRWeWcZVzv7niYns3r0QXzR3MgPm8YJ7vbRT2tc6qiMep4hKfPAbmFuhoY9hYPpz
	RMd3rOIplgVJwjlvuCi3eH324Puoob0zM0bCms+xoeQUStUFlGaYnHVzWuF4BO4BQTL8Uq
	780fZvmxE8QG5o+OuXX//MsM1wjGluI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EN4ZZO5m;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of 3587faggKCGISKHAWAJAGOOGLE.COMLINUX-MMKVACK.ORG@flex--skhawaja.bounces.google.com designates 209.85.214.200 as permitted sender) smtp.mailfrom=3587faggKCGISKHAWAJAGOOGLE.COMLINUX-MMKVACK.ORG@flex--skhawaja.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793052392;
	b=KYa8pwh0xQn8HhwDKsCFReNRbO10LW2XvQyr4fjupgxbbpUi2ZgS1Zpy6bzmQ+Gd9eJD08
	iSF5GJK/lIqS6li/CSEdWS3iF7Ye+mumBHyUaAQBLRrbzfE7EkIC5/9Q3gNG/78J2BUHzj
	1+zPJVPd2/a6o19bROP2rRUZ2745AZE=
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-2e9821ca96fso42326435ad.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 15:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793052392; x=1793657192; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=J8qqAYIAfPgq1UPwTJslv5kHWAuX4fEMnW0g2gFuydk=;
        b=EN4ZZO5myeOV3MjUHF31aNEt7jkA5sZ7keLk+3FSlNyEKSzKEjBmzCMVjaLSU1SDMr
         mAn+3K1VfrRXUF8Dzg60tr1S7tpi8cS1PHsPQLsm/oCNtJlo26x9SAG6VlbVDLrX3TFd
         CIhcfuewcxZjzbncrIK0zS9gntyVCl848rc621u9dB1P30rS46z1UE3EiG23AcaWFgix
         T/FyRh3X/G6EwBcBnvY9PQ7YTqcw0qiZlKL90cN6VRDmt3qQk/gPZir4bEdSrdWCmVgC
         nEpvsjBMKbUexqQCi2q7YfTBAwPU3x/WbS0MrpnrnZgcdnEZbxQLVYxt4RBAloB0o/93
         KHFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793052392; x=1793657192;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=J8qqAYIAfPgq1UPwTJslv5kHWAuX4fEMnW0g2gFuydk=;
        b=LHdqbQTS+zXmjIVcmUikfQ1BQcgWX7xHjIcTTaycZUkzvCqnorsQ6sKEZ3e3kQC0r3
         I5Si2tZa1/Xti1Kr/LXopjNydvKnXhSOeOdhNe4pjqIoxnNJffiKsiyZf1dUdgewjQx3
         ilgxr43qn97VBdc3xDSPNHbQ+p62ef/qsRAuSue/U/kZ3VJlZv83A3IC3612NMQUmXgh
         tR+GapChl5DdwA9xczKxFiJuXTqqSvrvO91ySwV/Sy4HLzrNlr4TROHoP/BXjgTl0CpD
         URCKWKfOMqmcjAdkjbFSmgncnYBes2VLaM6hW4TkdLJMqY1QiDt2LHkfW29x2AABS9+n
         n/AA==
X-Forwarded-Encrypted: i=1; AKwUvByo/gRw5krMHpPuDqdIDJsikWp1oTRcNgH78TGv4LZqshW0LL8WmEidG+G7qzBzGE45rombbbhR7w==@kvack.org
X-Gm-Message-State: AFq9FYINzvoIpGuSUX1ZvtvwoW5xPbfSI50QEtqB+C7MFDt5iCnOxRGn
	ml80xYcn0Z9Fvkbstvf/78GttF0dHPA3RsGCRmb1UsDwxzJ2mzWoZjHZyKidhZzPcAJ6TjVxZx7
	J/VPpvrQVr6jy9g==
X-Received: from plbjv3.prod.google.com ([2002:a17:903:583:b0:2ea:7f89:8fce])
 (user=skhawaja job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d4c4:b0:2e9:5c55:c46a with SMTP id d9443c01a7336-2ea9c03edbfmr70987685ad.7.1793052391484;
 Mon, 26 Oct 2026 15:06:31 -0700 (PDT)
Date: Mon, 26 Oct 2026 22:05:45 +0000
In-Reply-To: <20261026220546.3114241-1-skhawaja@google.com>
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
References: <20261026220546.3114241-1-skhawaja@google.com>
X-Mailer: git-send-email 2.56.0.307.g5fe7bd680c-goog
Message-ID: <20261026220546.3114241-2-skhawaja@google.com>
Subject: [PATCH 1/2] mm/memfd: add F_SEAL_PUNCH_HOLE
From: Samiullah Khawaja <skhawaja@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Jeff Layton <jlayton@kernel.org>, Chuck Lever <cel@kernel.org>, 
	Alexander Aring <alex.aring@gmail.com>, Shuah Khan <shuah@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Gerd Hoffmann <kraxel@redhat.com>, Vivek Kasireddy <vivek.kasireddy@intel.com>, 
	Jeff Xu <jeffxu@google.com>, David Matlack <dmatlack@google.com>, 
	Pasha Tatashin <tatashin@google.com>, linux-mm@kvack.org, linux-api@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Samiullah Khawaja <skhawaja@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: D304040005
X-Stat-Signature: qyqfurezkjfhtt1bhknr4kpfrt3ubtm5
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793052392-84729
X-HE-Meta: U2FsdGVkX1+O2HsaGruWr1Lfuunu83IEyOCd+cF+ZsCY0P1N+mS/etjqEfqhxCFT3wW32PmE1HoUVR/kzM2yzULW4qkI649gPmf6zc2OJ7EpuPe7rCtfUgQDtuzgV9zzlmxmD14wn9kajp96sCV0EJwatWy78nptGM8kFyemiN5tO8iR6Z+yxBc4ykrLP06gDkPBhjTKsVfmPfvbn3X4XpgetNNpK32ZK3rGAI3KKbk3oMJVsoIHM8wijEvZxgeUnU0dSWQYm6eSZkVHR8LvhHShUFEygti0v70wwPT9YT5Ks9pGTIK/sWZUm8tqPc0P6mW8PLckgCVsttCdZzTi2ymgJQJfWdg3D8OgcFCEDE9u7jcxm++uyW4ronMzncMO2e9L29fbuke43pLXE1hw2TE9fAL8zvv3BbvByUHmB6Skrr/+U/Lh+8jzlfZ4j8YqsyEV7qQNPNoPsA1eyspDwCms+96kK4rf3kOKFzDFpIot5LU+T8na5inKExcPlWlQ1NaL6Xr8GHzGBFnBiQF6gzZCFc6qhHuQFlSk2+rpDiqp6IjvR0KgLOuSnmIhwhnD3s9KQUuLZi64DZlm11/rxpgeNkHtTGdz1sRNqdSAxUH9/xiMFxzVlZFEkLwykMOW/cTbtbv/gaEu25rXhWBNva/0cG5MMW2nw5+c24iUdKrmQu9LLj09S3AADiRSBctvRDGl93ythX74VTMxd1RaSGykP0Hl9MncTKz8njdIlDuNx4zbFB7jC8IGoH4tkYp26FVV1OAi1PGMpcejKFTrXUYmPGnLcJOSeH+szc7jpTvD4ukC7lFtl8ASH+RXe+HCHGe0OcMo2dT8qubx6xzYX/4SRFqv1/D9rNykNK20ammmAClcWuqw4wC/QAlMqFV5ceV1lYdYCt4/n3s40Flk1d5haKVVX3J9uoj/n4E2l9qVr/D3bxhHTdxjDPoXWFOzwYzJy+keCUvyQpLB1DW
 //I+UqaK
 K4vX2+kbpVDUGKDPWAUWQ25eJgzvmQxnZ3C2JDnQGqXXz9VVYja5Ir+8Bn3kCp5vJRCOfOGHWz9cbJ3dmjjm8INcofRr5Y4Axyp38xxt4Z7op66ivd6RDcugS71p0ziC8xzJsPpaSlgk4BVWEa9ETJQ2h4LkW7mk16D1OF35Mx/g+mfITXZpXacDfZCppW0kr5YX/JKvEhxVG6xgwmakBMbtaTPsv0l10S9Wl4Cv1R1ET9IncHdIpoWR1nYRU4U0tiqiJySvd6JhAJbrhprRxzx8ino8nYeEoBNaYO7SGmjgjXhqJvEyq6Du161/T4oh2/sqRPmSozXRt5nkEdo65CFR3mNfvaSMo0MCciOqhQUunF0zyDIp1UeeJUGLCgXMSDyzGHOtYf1Oo1wHhsdc3KmaZz0Ps0ijIYZIovpAwiY4ugv47fa8Q8DAJ19E+hFtnsD3bP+k9cSFxWoExpRAJggKMCH7snFaTL4JWRUU5o+9knx3pOZVDLUqna1nVePwoY7Pmm93EUV5QNZ2oaR14RBcZ7L0iLzTjklZary+ETVAATkOcuE3qtqyUNoIXeYX1hpr49dNjOHgMn8ztMcKtvLjAYQFZX03Cp7ooh/D2rxgDezh3d2Klmqv2a24BqAzP3+5l4uPKA03mwPtN1U0xJWyrYy6VD7xUQkscpq3pplYFfLMTYDJStN7xrA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Users of memfd_pin_folios(), such as udmabuf and iommufd
(IOMMU_IOAS_MAP_FILE), pin the folios backing a memfd range and keep
using them for DMA. A pin keeps a folio alive, but it does not keep the
folio in the file. If userspace later punches a hole with
fallocate(FALLOC_FL_PUNCH_HOLE) or madvise(MADV_REMOVE), the folio is
removed from the page cache while the pin still holds it, and the pin
holder is not told. From then on the device and the file no longer
share memory: data written by the device is not visible through the
file, and data written through the file never reaches the device.

udmabuf already requires F_SEAL_SHRINK so that truncation cannot remove
pages, but there is no seal that prevents punching holes without also
preventing writes. F_SEAL_WRITE and F_SEAL_FUTURE_WRITE do block hole
punching, but they cannot be used for memory that has to stay writable,
and udmabuf rejects memfds that carry them.

Add F_SEAL_PUNCH_HOLE, which makes fallocate(FALLOC_FL_PUNCH_HOLE) fail
with -EPERM on shmem and hugetlbfs memfds. MADV_REMOVE is covered as
well, because it is implemented with vfs_fallocate() and
FALLOC_FL_PUNCH_HOLE.

Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
---
 fs/hugetlbfs/inode.c       | 3 ++-
 include/uapi/linux/fcntl.h | 1 +
 mm/memfd.c                 | 4 +++-
 mm/shmem.c                 | 3 ++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index e8a05d3de327..65034b72b98e 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -660,7 +660,8 @@ static long hugetlbfs_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 	inode_lock(inode);
 
 	/* protected by i_rwsem */
-	if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
+	if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE |
+			   F_SEAL_PUNCH_HOLE)) {
 		inode_unlock(inode);
 		return -EPERM;
 	}
diff --git a/include/uapi/linux/fcntl.h b/include/uapi/linux/fcntl.h
index e43e3de3e9ee..f9dd929adaf4 100644
--- a/include/uapi/linux/fcntl.h
+++ b/include/uapi/linux/fcntl.h
@@ -50,6 +50,7 @@
 #define F_SEAL_WRITE	0x0008	/* prevent writes */
 #define F_SEAL_FUTURE_WRITE	0x0010  /* prevent future writes while mapped */
 #define F_SEAL_EXEC	0x0020  /* prevent chmod modifying exec bits */
+#define F_SEAL_PUNCH_HOLE	0x0040  /* prevent punching holes */
 /* (1U << 31) is reserved for signed error codes */
 
 /*
diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e..3f0ef72fb301 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -227,7 +227,8 @@ static unsigned int *memfd_file_seals_ptr(struct file *file)
 		     F_SEAL_SHRINK | \
 		     F_SEAL_GROW | \
 		     F_SEAL_WRITE | \
-		     F_SEAL_FUTURE_WRITE)
+		     F_SEAL_FUTURE_WRITE | \
+		     F_SEAL_PUNCH_HOLE)
 
 int memfd_add_seals(struct file *file, unsigned int seals)
 {
@@ -253,6 +254,7 @@ int memfd_add_seals(struct file *file, unsigned int seals)
 	 *   SEAL_GROW: Prevent the file from growing
 	 *   SEAL_WRITE: Prevent write access to the file
 	 *   SEAL_EXEC: Prevent modification of the exec bits in the file mode
+	 *   SEAL_PUNCH_HOLE: Prevent punching holes into the file
 	 *
 	 * As we don't require any trust relationship between two parties, we
 	 * must prevent seals from being removed. Therefore, sealing a file
diff --git a/mm/shmem.c b/mm/shmem.c
index fd0953d55fd6..e79a298d6292 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3853,7 +3853,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
 
 		/* protected by i_rwsem */
-		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
+		if (info->seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE |
+				   F_SEAL_PUNCH_HOLE)) {
 			error = -EPERM;
 			goto out;
 		}
-- 
2.56.0.307.g5fe7bd680c-goog


