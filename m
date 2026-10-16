Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FB7BCCF2C1
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 22:27:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A1CA6B008C; Fri, 16 Oct 2026 18:27:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17AF06B0092; Fri, 16 Oct 2026 18:27:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BB3F6B0095; Fri, 16 Oct 2026 18:27:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D048E6B008C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 18:27:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 487D21601BF
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:27:38 +0000 (UTC)
X-FDA: 85329927396.30.234D54D
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf26.hostedemail.com (Postfix) with ESMTP id ABFEF140004
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:27:36 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf26.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792189656;
	b=5wOvk6B/lba7sYGm/092zq01zJrMnVQnBNpWx6DJfrJngvZxcT4OXZbJKGZLijjiNtbtlc
	22s3aID6pA/Br+RjHbqZVuZwlrvioT/87WbjrsJ7Rm0ouv4mVYepDYUGMhKA7Mh9RqsfwI
	HC+bBz9qWA8oGVRV4BcHCcafbyHyenM=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf26.hostedemail.com: domain of nickolai@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=nickolai@csail.mit.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792189656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=lWB7SP9Ylu5CW89gIfFc8zRLHEI5ZOd9LCo0tU+Tql8=;
	b=d8j+D8y97BVoOB0ouR5lkcJ5jWL6de4JV9yWPkKtzkIFpKxSZl02SP2VcklK3z+VkiMXki
	mYp6TVhxUgvHsHhksxLa/BQTwocwpJvKlFXV5nH6KCQSBbIS8fgLxXr8a+QsuHBV9FBpRc
	3wmtx4fRjo8URT/4gXT+wOuP6rtpuj8=
Received: from escalante.csail.mit.edu ([128.52.128.198])
	by outgoing2021.csail.mit.edu with esmtp (Exim 4.95)
	(envelope-from <nickolai@csail.mit.edu>)
	id 1xHqOX-00GiQ4-G4;
	Fri, 16 Oct 2026 18:27:21 -0400
From: Nickolai Zeldovich <nickolai@csail.mit.edu>
To: Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Brian Foster <bfoster@redhat.com>,
	Theodore Ts'o <tytso@mit.edu>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Nickolai Zeldovich <nickolai@csail.mit.edu>
Subject: [PATCH v1] mm/truncate: fix the zeroing end of pagecache_isize_extended()
Date: Fri, 16 Oct 2026 18:27:21 -0400
Message-ID: <20261016222721.791785-1-nickolai@csail.mit.edu>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: ABFEF140004
X-Stat-Signature: 9w75usixqbc5uhz3yy4osixc5bxta7pt
X-HE-Tag: 1792189656-695095
X-HE-Meta: U2FsdGVkX1/bGeXM2dUU8c5j0U5IbyXAx1BzxMeuTNLdlfqc1oUt/Ysy07iVQF9Z091JFCRLN1LRJwsS2l+2TxcMMq9lPqdIV5GhAbF4X34lhxsRrRZDIHNmlLvk2XlWGBmAbaE85uRq2Fe79RPfvTHo9vCPQgxt2wdvEbs5MN9XptIFx76e3nVQaWRA5xaVqXXxPEn5rNrSIsC9IHtXQSmWYDwkq9/wD+9VKdLrHoCip3UjAMEsJ/sAmtpybE/4uyBuWrCYXTNi+2Mick+NJ2uixrUuyvT3SLrHbYNs6f94NOpqa1slF7Z+WWYwmHzg0+72Zi7cA8/rwtMxCqgYjxXIA48OVW+rOax6oesMmve4jiIjoxr3iB2nU5t4V8IWqbU70xJWd/SlyIpffZ/Is29jxNhQAG7tkZOixJ2Y7v2ASvVMvNzoufOslR5RGJh0l0EV0cf/eF+vcMAqGWGK6qn9/fPUA6+5cO0hcVXUzFtrtJ0/QtlDKAi7Qm5DwBYyTFdh+bBOp7XB/iI5eC7kDp88BBgFnje1894E2ZTBgR8LAGUxh+lv6EbskEhQttb5Tk8vKTXcuaLtgaaasrW1Vuw0h/nKUVzMTQXyetRp3jW0JHoeonj/GBSBhaY8yTYwyKFSC4CVdjJ69u3bQjHmjGnS+BVPC5swD1r5rWOPMRIZS5opXYacn+ymS6nJMvealyeQrD30MONiAZ47nNDUtF07vkEO5UwmULJQ33nTUw+8jKybIOvTqV+BlVR2PjUym1wCvpr/jEEAhQGsqin692SWtQYC7AGsAJZ7lLvPyJrjd9wzm+s2kxe3V5C24yS/z/HSeBvD9NgfQueZKBasSu9exNNtEr/iw7dCTVGtif/iY8XCOjhPXXuRzfH9ZJhUEa7zgTJZJUrNOUmibnmC9l+/s/OGp6QUPyRtThjplkrbMlouTgiSUefRty8FzDO/44I6Dg65abs1KT6xqE8
 F38oUzmO
 DYOMxGJXtFfhZjSun7RZvEj1HxkaDnmPE+gp45m0j0rtVO61D1S5l8JUQ2PoChvOvyH5fDByyegsA3XiFn3998Axos/HHhvGaY9x2niuwlsrh6yY07e2pRY/0ggHpgJq6M1WC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A process that extends a file by 4 GiB or more past a dirty folio, on a
file system whose block size is smaller than the page size (ext4 with 1k
blocks), reads back the bytes it wrote through a shared mapping beyond
the old end of file instead of zeroes, and a later write into that block
carries them to the disk. With the example of commit 52aecaee1c26 ("mm:
zero range of eof folio exposed by inode size extension") and the
truncate taken 4 GiB further (pwrite 2k at 0, mmap the first page and
write 'X' over [2k, 4k), truncate(2) to 4 GiB + 2k), the read of
[2k, 4k) returns the 2048 'X' bytes, and a pwrite of 16 bytes at 3k
followed by fsync() and a remount leaves 1008 'X' bytes on the disk in
[3k+16, 4k). No privilege is needed, and every size extension of 4 GiB
or more reaches it: truncate(2)/ftruncate(2) through truncate_setsize(),
writes beyond the end of file through generic_write_end(), ext4, iomap,
btrfs, exfat, ntfs, afs and orangefs. Affected since v6.13.

pagecache_isize_extended() zeroes the part of the dirty folio straddling
the old end of file that the size extension exposes, from the old size
to the new size or the end of the folio, whichever comes first:

	end = min_t(unsigned int, to - folio_pos(folio), folio_size(folio));

min_t() converts both operands to unsigned int before comparing, so the
loff_t difference to - folio_pos(folio) is reduced modulo 2^32 first.
When the file grows by 4 GiB or more past the folio, end is that residue
instead of folio_size(folio): below offset nothing is zeroed, above it
only [offset, end) is. The bytes beyond the old end of file stay in the
dirty folio and, now inside i_size, are file data.

Compare in loff_t; the result is at most folio_size(folio) and fits end.

Found while formally verifying pagecache_isize_extended() against the
kernel binary.

Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
Assisted-by: LLM
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
---

Notes:
    Tested on a 64 MiB ext4 image made with mkfs.ext4 -b 1024 and mounted in
    a QEMU guest, with the program below followed by umount, mount and a
    read of [3k+16, 4k). Unpatched 70dd4ee72eb2 (x86_64 and riscv64
    defconfig): 2048 of 2048 bytes non-zero ('X') after the truncate and
    1008 of 1008 'X' bytes on the disk after the remount. Patched: 0 and 0.
    The same sequence with a truncate to 8k reads zeroes on both kernels,
    which is the case commit 52aecaee1c26 fixed.
    
    The 32-bit conversion is visible in the riscv64 binary as a subw on the
    loff_t difference before the compare; with the patch it is a sub.
    
    Reproducer (ext4 with 1k blocks, mkfs.ext4 -b 1024):
    
    truncate -s 64M img && mkfs.ext4 -q -F -b 1024 img && mount -o loop img /mnt
    gcc -O2 -o isize_extended isize_extended.c
    ./isize_extended /mnt/f    # exit 1 and a non-zero count on an unpatched kernel
    
    /*
     * Stale post-EOF data after a size extension of 4 GiB or more on a file
     * system with a block size below the page size (ext4 -b 1024): [2k, 4k)
     * must read as zeroes after the truncate.  Exit status 1 when it does not.
     */
    #include <fcntl.h>
    #include <stdio.h>
    #include <string.h>
    #include <sys/mman.h>
    #include <unistd.h>
    
    int main(int argc, char **argv)
    {
    	const char *path = argc > 1 ? argv[1] : "/mnt/f";
    	unsigned char buf[4096];
    	unsigned int i, nz = 0;
    	char *map;
    	int fd;
    
    	fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0644);
    	memset(buf, 'A', 2048);
    	if (fd < 0 || pwrite(fd, buf, 2048, 0) != 2048) {
    		perror("open/pwrite");
    		return 2;
    	}
    	/* 'X' beyond EOF, inside the first page; the folio stays dirty */
    	map = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    	if (map == MAP_FAILED) {
    		perror("mmap");
    		return 2;
    	}
    	memset(map + 2048, 'X', 2048);
    	munmap(map, 4096);
    	/* 4 GiB or more past the folio: to - folio_pos(folio) >= 2^32 */
    	if (ftruncate(fd, 4294967296LL + 2048)) {
    		perror("ftruncate");
    		return 2;
    	}
    	if (pread(fd, buf, 2048, 2048) != 2048) {
    		perror("pread");
    		return 2;
    	}
    	for (i = 0; i < 2048; i++)
    		nz += buf[i] != 0;
    	printf("[2k,4k) after truncate to 4 GiB + 2k: %u non-zero bytes of 2048\n", nz);
    	/* allocate block [3k, 4k): [3k+16, 4k) shows what reaches the disk */
    	memset(buf, 'B', 16);
    	if (pwrite(fd, buf, 16, 3072) != 16 || fsync(fd)) {
    		perror("pwrite/fsync");
    		return 2;
    	}
    	return nz ? 1 : 0;
    }

 mm/truncate.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/mm/truncate.c b/mm/truncate.c
index b58ba940be47..5c444812f37a 100644
--- a/mm/truncate.c
+++ b/mm/truncate.c
@@ -878,8 +878,7 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
 		unsigned int offset, end;
 
 		offset = from - folio_pos(folio);
-		end = min_t(unsigned int, to - folio_pos(folio),
-			    folio_size(folio));
+		end = min_t(loff_t, to - folio_pos(folio), folio_size(folio));
 		folio_zero_segment(folio, offset, end);
 	}
 

base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
-- 
2.53.0


