Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 213EBCCD1BF
	for <linux-mm@archiver.kernel.org>; Sat, 25 Oct 2025 03:30:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E24738E0125; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DCF158E0112; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBDB38E0125; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B960A8E0122
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 23:30:11 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 472E414100D
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:11 +0000 (UTC)
X-FDA: 84035208222.25.06F6D91
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	by imf07.hostedemail.com (Postfix) with ESMTP id 04F2540008
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 03:30:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761363009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=iBcOVcLweE0cI680hRQbpDdPdQ9nEiTGqgympd/Zp18=;
	b=p5b66Lhv6J44me3kj89cLTgrlgQoqH4y6ZR2DQkI4kTpy5Jy2EXr0Ad+AK9C1qRljgMYdH
	1NBKc6SUqC9Ctrnkc7rqXfEi1yiq4Xki922ZICx/gWcDT7bdpbkGV1W6imYkw4c9tXIppK
	qej6n+4qPjoNZ+AzfFui3jzesP9qHcA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of libaokun@huaweicloud.com designates 45.249.212.51 as permitted sender) smtp.mailfrom=libaokun@huaweicloud.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761363009; a=rsa-sha256;
	cv=none;
	b=PPCXsZ7F/edFvWRU9OG6XIgNWwyrtAaYklcrr8PmxC2mHj0Swk6pb31YsDlJ4Fel98Pz+I
	FRlVlqlLF1rOk+wkD5tKAlFSOhfMBoydwzwTERkyGzFPLnTFLdYsTzLa+efcHT9fEOtYoK
	uWZXVfUCjkzEQY07SSO3mPVJtTQy22I=
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4ctlcJ5Q5szYQtlQ
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:29:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 67E971A13A2
	for <linux-mm@kvack.org>; Sat, 25 Oct 2025 11:30:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.50.87.129])
	by APP2 (Coremail) with SMTP id Syh0CgBHnEQ6RPxox1YbBg--.45388S4;
	Sat, 25 Oct 2025 11:30:03 +0800 (CST)
From: libaokun@huaweicloud.com
To: linux-ext4@vger.kernel.org
Cc: tytso@mit.edu,
	adilger.kernel@dilger.ca,
	jack@suse.cz,
	linux-kernel@vger.kernel.org,
	kernel@pankajraghav.com,
	mcgrof@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	chengzhihao1@huawei.com,
	libaokun1@huawei.com,
	libaokun@huaweicloud.com
Subject: [PATCH 00/25] ext4: enable block size larger than page size
Date: Sat, 25 Oct 2025 11:21:56 +0800
Message-Id: <20251025032221.2905818-1-libaokun@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgBHnEQ6RPxox1YbBg--.45388S4
X-Coremail-Antispam: 1UD129KBjvJXoW3Xw47Jr43Gw1xuryfZw1xGrg_yoWxJr4Dpa
	yfJF13Ar45G3yYk3ZxWw1ktr48Wa18Gr1UXry7t348ur1Iyr18trZFyFy8ZFWjkry7JFyj
	qF1fJr4xG3Wjk3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUB014x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r4UJVWxJr1lOx8S6xCaFVCjc4AY6r
	1j6r4UM4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02
	628vn2kIc2xKxwAKzVCY07xG64k0F24lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64
	vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUoPEfDUUUU
X-CM-SenderInfo: 5olet0hnxqqx5xdzvxpfor3voofrz/1tbiAgAMBWj7Ua9I5wAAsJ
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 04F2540008
X-Stat-Signature: 4f3ji9dpuguhrtwf4fz84c37ojmqq1f7
X-Rspam-User: 
X-HE-Tag: 1761363007-872119
X-HE-Meta: U2FsdGVkX1+HaP7SA9PquF9WBchaX/buMxo+DwXjyw2MiuEj+aeLlABGjGAsiNK3zD/4He3MXj8jggqPqE/3px2OGufkgjOKYUDWswaWKTxDC9bYxgoah+LnVm7xiJmr2eublOjfomy2xm8H5b58tpAHOi9G20fK5jS6Vy8DI+Mktnq3KkFW+cERpZbOQNvIf5M82WCOr3JZvGzMiSI6iYoqwAtjSx1cjUHGNEY84x8mRm44GhsGb9CkV+vJh5dO06InJ/1GeRTwSh3S3p9Da7YIl7PNpZYcJ7Z66ISEvp0HltQSFZFYoR226r8kuyvWSvnst1Cn+usqTVK8lDdcDza7gkqAudGtsJ/xLIsGhMiFvANLL2HivZfmz5uoHPdqX1RRBmmOXVZq5ZlI3up1fFCiURyCmzxtpTfiWd8xc1lZomLQZ+f7yTr81WLLAS/E6Z1tCHJpUzyafd32KQo31HAMriWVZ5uxa2p0FzwYmiUli7jXxRfgD7A1UoIVeXWYjM7OcwHcJQoWrIe+gK860D2thmJza4TeXaWWqfB/lP76oMciPIhxAz29LJoy0qM6Ynl637CASBNdXRejI/O/nZPgwA+AIzpwBsx/v6VQsdMvm3/YnWjaC0uH1M/n54BRWJK0BgnapuxFs4NMQ1cz9r1UmqdmAkkhYsHpiT8anDowDPTfyY0WLllnol4jhiwIQS/OflbqxIiYNd6TnQ7lxYE8zJX0t06gz/1NA6WLfup6OtNydqX40UtVsdjpTlYrNEuvFEy0MhbRokybULvguWSaTZ5U4lCpXw6fHpjnDQgjBMNnRM150b08ktCNh7CIig3j3ofB80Kwzeo4Gi5186mifEuLOmtbXsIDRDlPq05ueNrzYgWLn5yA4Jp3kTfsQWZdl0ZJ8I6MeJLxyOnkVrrOjDTvMt5WsVkiM6r+rdQIyGmMpGnXDLDYABqmKFsUgCLQkJn4HE4aln9uQU2
 TibeuIJy
 23yKzVrtx3jCUqM/opVE0+0HbfomB3hHtQj7nbKxzFLJcNRgmdIrOTa/dPmSAJNDJUck5izZqNkK0UXJkiFT0cb5/Y/EXf85uTGJeN6QIk7nREOg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Baokun Li <libaokun1@huawei.com>

This series enables block size > page size (Large Block Size) in EXT4.

Since large folios are already supported for regular files, the required
changes are not substantial, but they are scattered across the code.
The changes primarily focus on cleaning up potential division-by-zero
errors, resolving negative left/right shifts, and correctly handling
mutually exclusive mount options.

One somewhat troublesome issue is that allocating page units greater than
order-1 with __GFP_NOFAIL in __alloc_pages_slowpath() can trigger an
unexpected WARN_ON. With LBS support, EXT4 and jbd2 may use __GFP_NOFAIL
to allocate large folios when reading metadata.

To avoid this warning, when jbd2_alloc() and grow_dev_folio() attempt to
allocate with order greater than 1, the __GFP_NOFAIL flag is not passed
down; instead, the functions retry internally to satisfy the allocation.

Patch series based on 6.18-rc2. `kvm-xfstests -c ext4/all -g auto` has
been executed with no new failures. `kvm-xfstests -c ext4/64k -g auto`
has been executed and no Oops was observed.

Here are some performance test data for your reference:

Testing EXT4 filesystems with different block sizes, measuring
single-threaded dd bandwidth for BIO/DIO with varying bs values.

Before(PAGE_SIZE=4096):

      BIO     | bs=4k    | bs=8k    | bs=16k   | bs=32k   | bs=64k
--------------|----------|----------|----------|----------|------------
 4k           | 1.5 GB/s | 2.1 GB/s | 2.8 GB/s | 3.4 GB/s | 3.8 GB/s
 8k (bigalloc)| 1.4 GB/s | 2.0 GB/s | 2.6 GB/s | 3.1 GB/s | 3.4 GB/s
 16k(bigalloc)| 1.5 GB/s | 2.0 GB/s | 2.6 GB/s | 3.2 GB/s | 3.6 GB/s
 32k(bigalloc)| 1.5 GB/s | 2.1 GB/s | 2.7 GB/s | 3.3 GB/s | 3.7 GB/s
 64k(bigalloc)| 1.5 GB/s | 2.1 GB/s | 2.8 GB/s | 3.4 GB/s | 3.8 GB/s
              
      DIO     | bs=4k    | bs=8k    | bs=16k   | bs=32k   | bs=64k
--------------|----------|----------|----------|----------|------------
 4k           | 194 MB/s | 366 MB/s | 626 MB/s | 1.0 GB/s | 1.4 GB/s
 8k (bigalloc)| 188 MB/s | 359 MB/s | 612 MB/s | 996 MB/s | 1.4 GB/s
 16k(bigalloc)| 208 MB/s | 378 MB/s | 642 MB/s | 1.0 GB/s | 1.4 GB/s
 32k(bigalloc)| 184 MB/s | 368 MB/s | 637 MB/s | 995 MB/s | 1.4 GB/s
 64k(bigalloc)| 208 MB/s | 389 MB/s | 634 MB/s | 1.0 GB/s | 1.4 GB/s

Patched(PAGE_SIZE=4096):

   BIO   | bs=4k    | bs=8k    | bs=16k   | bs=32k   | bs=64k
---------|----------|----------|----------|----------|------------
 4k      | 1.5 GB/s | 2.1 GB/s | 2.8 GB/s | 3.4 GB/s | 3.8 GB/s
 8k (LBS)| 1.7 GB/s | 2.3 GB/s | 3.2 GB/s | 4.2 GB/s | 4.7 GB/s
 16k(LBS)| 2.0 GB/s | 2.7 GB/s | 3.6 GB/s | 4.7 GB/s | 5.4 GB/s
 32k(LBS)| 2.2 GB/s | 3.1 GB/s | 3.9 GB/s | 4.9 GB/s | 5.7 GB/s
 64k(LBS)| 2.4 GB/s | 3.3 GB/s | 4.2 GB/s | 5.1 GB/s | 6.0 GB/s

   DIO   | bs=4k    | bs=8k    | bs=16k   | bs=32k   | bs=64k
---------|----------|----------|----------|----------|------------
 4k      | 204 MB/s | 355 MB/s | 627 MB/s | 1.0 GB/s | 1.4 GB/s
 8k (LBS)| 210 MB/s | 356 MB/s | 602 MB/s | 997 MB/s | 1.4 GB/s
 16k(LBS)| 191 MB/s | 361 MB/s | 589 MB/s | 981 MB/s | 1.4 GB/s
 32k(LBS)| 181 MB/s | 330 MB/s | 581 MB/s | 951 MB/s | 1.3 GB/s
 64k(LBS)| 148 MB/s | 272 MB/s | 499 MB/s | 840 MB/s | 1.3 GB/s


The results show:

 * The code changes have almost no impact on the original 4k write
   performance of ext4.
 * Compared with bigalloc, LBS improves BIO write performance by about 50%
   on average.
 * Compared with bigalloc, LBS shows degradation in DIO write performance,
   which increases as the filesystem block size grows and the test bs
   decreases, with a maximum degradation of about 30%.

The DIO regression is primarily due to the increased time spent in
crc32c_arch() within ext4_block_bitmap_csum_set() during block allocation,
as the block size grows larger. This indicates that larger filesystem block
sizes are not always better; please choose an appropriate block size based
on your I/O workload characteristics.

We are also planning further optimizations for block allocation under LBS
in the future.

Comments and questions are, as always, welcome.

Thanks,
Baokun


Baokun Li (21):
  ext4: remove page offset calculation in ext4_block_truncate_page()
  ext4: remove PAGE_SIZE checks for rec_len conversion
  ext4: make ext4_punch_hole() support large block size
  ext4: enable DIOREAD_NOLOCK by default for BS > PS as well
  ext4: introduce s_min_folio_order for future BS > PS support
  ext4: support large block size in ext4_calculate_overhead()
  ext4: support large block size in ext4_readdir()
  ext4: add EXT4_LBLK_TO_B macro for logical block to bytes conversion
  ext4: add EXT4_LBLK_TO_P and EXT4_P_TO_LBLK for block/page conversion
  ext4: support large block size in ext4_mb_load_buddy_gfp()
  ext4: support large block size in ext4_mb_get_buddy_page_lock()
  ext4: support large block size in ext4_mb_init_cache()
  ext4: prepare buddy cache inode for BS > PS with large folios
  ext4: support large block size in ext4_mpage_readpages()
  ext4: support large block size in ext4_block_write_begin()
  ext4: support large block size in mpage_map_and_submit_buffers()
  ext4: support large block size in mpage_prepare_extent_to_map()
  fs/buffer: prevent WARN_ON in __alloc_pages_slowpath() when BS > PS
  jbd2: prevent WARN_ON in __alloc_pages_slowpath() when BS > PS
  ext4: add checks for large folio incompatibilities when BS > PS
  ext4: enable block size larger than page size

Zhihao Cheng (4):
  ext4: remove page offset calculation in ext4_block_zero_page_range()
  ext4: rename 'page' references to 'folio' in multi-block allocator
  ext4: support large block size in __ext4_block_zero_page_range()
  ext4: make online defragmentation support large block size

 fs/buffer.c           |  33 +++++++++-
 fs/ext4/dir.c         |   8 +--
 fs/ext4/ext4.h        |  27 ++++-----
 fs/ext4/extents.c     |   2 +-
 fs/ext4/inode.c       |  69 ++++++++++-----------
 fs/ext4/mballoc.c     | 137 ++++++++++++++++++++++--------------------
 fs/ext4/move_extent.c |  20 +++---
 fs/ext4/namei.c       |   8 +--
 fs/ext4/readpage.c    |   7 +--
 fs/ext4/super.c       |  52 ++++++++++++----
 fs/ext4/verity.c      |   2 +-
 fs/jbd2/journal.c     |  28 ++++++++-
 12 files changed, 234 insertions(+), 159 deletions(-)

-- 
2.46.1


