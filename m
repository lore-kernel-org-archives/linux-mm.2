Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D5574606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 12:57:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=SQi9jfvJ
Received: by kanga.kvack.org (Postfix)
	id F20F46B0931; Thu, 22 Oct 2026 08:57:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EF8766B0932; Thu, 22 Oct 2026 08:57:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E34076B0933; Thu, 22 Oct 2026 08:57:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BDA976B0931
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 08:57:11 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5D393A840E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:57:11 +0000 (UTC)
X-FDA: 85350262662.07.0DD8943
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf07.hostedemail.com (Postfix) with ESMTP id 74F0840006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:57:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SQi9jfvJ;
	spf=pass (imf07.hostedemail.com: domain of libaokun@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=libaokun@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792673829;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xxxC/VqgSWcDOzXmk3VeIAFPBUB3paVgHQXE2J/B61Y=;
	b=POmRxrZMHYPx2go+dfhGJqASCnS+uVeGyUtBaiJgj+BXbTux7XKkBRXk8iAOib/CC8oD/o
	JkwyoufSKmHWwFF+zG+srlb2KqePh+g66GGLYNyctJDBE8hcWQmNVJ4CxiBEEBwJ4458ST
	2JeyeLnV1rIqwZKZOhX9/WhT32FToXU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=SQi9jfvJ;
	spf=pass (imf07.hostedemail.com: domain of libaokun@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=libaokun@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792673829;
	b=3ZcfvGM8O2w8pa6J6hGsjuUwqKH4G0GwhtcSX5IYLSJ/VUbe9crb03DLhGAQ1QIvWWoVkT
	g6KR2qj6fbSfKhPgdnUDG7kvXMl//Xa7XgkcdQfKzQFl6FcPE/sTYDuSRxpQl+tenU6wab
	mwDbwB1qw7kFofOxJq3/B7eNFFTCQ4Q=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792673822; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=xxxC/VqgSWcDOzXmk3VeIAFPBUB3paVgHQXE2J/B61Y=;
	b=SQi9jfvJSS1Gp5yvDwtQh2KxAdHtCyyGm0bQaj8lZWSWv9Ae1eczJ3RyVJhKyg6jj4cPGD3N4K8NbqE7NiaRDNXRalHj+0dvdVDuxEZV/mPfn1NvNIKjvxrVz/4hlhgZOk7ge3+y9A3cou4TVx7nVAkPiUWpp8IO3mozrW26Lx8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R171e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=libaokun@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0XDJJa91_1792673819;
Received: from 30.221.132.50(mailfrom:libaokun@linux.alibaba.com fp:SMTPD_---0XDJJa91_1792673819 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 22 Oct 2026 20:56:59 +0800
Message-ID: <d6e99a74-3b39-4797-a358-2e61156166a3@linux.alibaba.com>
Date: Thu, 22 Oct 2026 20:56:59 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] mm/truncate: fix the zeroing end of
 pagecache_isize_extended()
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Brian Foster <bfoster@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20261016222721.791785-1-nickolai@csail.mit.edu>
Content-Language: en-US
From: Baokun Li <libaokun@linux.alibaba.com>
In-Reply-To: <20261016222721.791785-1-nickolai@csail.mit.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 74F0840006
X-Stat-Signature: 71af3bx1o5ybujsmhhb9iozbrib1dpwi
X-Rspam-User: 
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792673826-40199
X-HE-Meta: U2FsdGVkX18TI6dU33JxZEU46TBkw157Fvm7tbcy7zDvkXoOl4oUVcQ3xKJnrU/H8OqCrhyWllJquwGsHwZQZ7HZJ0XwsmQq8t9bRKukQay0WZtaN/VjrPpAWPXcmk5ohAPeLGTC/gtpCaweFXU6ijATTZq3PfNONfXsI+MjGalqS5ZdOGH70XgJ+Pv9fM47VVDkCFbg3CIn2NxqFUtDuwsiQyPyQytdVmIiGgd3sS2B/QFqIiosvvfF+fCBtUUXw9AlzwXt2PG24iDPP1gtkhQCwHhuPklOnw2kKXzijl6UhGma7wCr3G9dtObQ1UFp8oq5m7vkfuJzCpHBwPkBX79XKLeYxRLIscJOD7m+2p/Qqgx2v8KBVB8Jgs0pH1+KNKixp6zcly0pp3W+MFnFydkzDZxGTSSUgYIBxbXTHKjUJwHHzxT3qDGj3EKfglzdRKWSXVPA/q0Hi+TBJwqFhi2MMDpF2SYfTupYGxVjU9DcQZJxOr/SFvT12ILBl8OS2WjzI1iENPFPazHv2Z2MthoYVwBThfH164iUrvJ2vofjxNxjFws9THLGGdyaWcZtN8Q6HVzKV0ZzV2LzTav6gnAPZoJj8PWKsXma+EOXNRQ2BDroHSLCED7YaY84JJtVzoHoV8cKLhW/NV0GGMRpditoSUEAG4aOtWl1VIW4X0HinbOGzAf/wdaG2DaoEllcnpAAdiXzR7qaMYWYo0SLQy/2dkRyuxB4sLPJ0G4bqseRAe0kRjf1fRC4o5NHKNnYCDRC6i5x5Glqzw4TqWGUAllLZ7KnzFczSl36t34JvbAAfNTbacCYJ3xjqYldg7GgM5l2YUFmnTuzLu0VsHhuY8Jh/mVJHDzCPOMybf5u7qK8Mh8qcTuAzpxakRv7J3j8VVVzaxwSlet9GjyRiE4OSEgoxyy210dYz7AoazyUHQifd751kJqpivAGvQgZiSiRVO0JV7It7H8qwbqlBAC
 HnOimElN
 e5FCKSM7LKfHArLRUC1+RTl0kQmHz6yZejy7b9e3ygtchZanXRZsTUWG3CarWOeVhcrYvaJLykag8VzM5Yplbfy37K+E3HGkanO0l51Z2WZWHqUc8uxKKIOAWlZVl2PvhjVQuVGrZ+eApOfkQ9W+KyOg/ShcFfRtQVRPMt82XafoM9pz/3l1nJ3ySp1y/8iIUN3FnroJ5FY7eoQ9/V9LnMQTN1G8laISSHSGD7Gbid0/zVSbEfl53m3GY0UiHpxElBSCTB95Wif2z6l2o7apAM8YUbVjqF4uPN9P3AK6Y34zikDr8KKiX0s93mxbSMDndIQrF1i42+A2QIzdjAnMBpYobBX1dxWMPfnUBxwhMj63by0QyH/kch0uM8JkQojaso0Qt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026/10/17 06:27, Nickolai Zeldovich wrote:
> A process that extends a file by 4 GiB or more past a dirty folio, on a
> file system whose block size is smaller than the page size (ext4 with 1k
> blocks), reads back the bytes it wrote through a shared mapping beyond
> the old end of file instead of zeroes, and a later write into that block
> carries them to the disk. With the example of commit 52aecaee1c26 ("mm:
> zero range of eof folio exposed by inode size extension") and the
> truncate taken 4 GiB further (pwrite 2k at 0, mmap the first page and
> write 'X' over [2k, 4k), truncate(2) to 4 GiB + 2k), the read of
> [2k, 4k) returns the 2048 'X' bytes, and a pwrite of 16 bytes at 3k
> followed by fsync() and a remount leaves 1008 'X' bytes on the disk in
> [3k+16, 4k). No privilege is needed, and every size extension of 4 GiB
> or more reaches it: truncate(2)/ftruncate(2) through truncate_setsize(),
> writes beyond the end of file through generic_write_end(), ext4, iomap,
> btrfs, exfat, ntfs, afs and orangefs. Affected since v6.13.
>
> pagecache_isize_extended() zeroes the part of the dirty folio straddling
> the old end of file that the size extension exposes, from the old size
> to the new size or the end of the folio, whichever comes first:
>
> 	end = min_t(unsigned int, to - folio_pos(folio), folio_size(folio));
>
> min_t() converts both operands to unsigned int before comparing, so the
> loff_t difference to - folio_pos(folio) is reduced modulo 2^32 first.
> When the file grows by 4 GiB or more past the folio, end is that residue
> instead of folio_size(folio): below offset nothing is zeroed, above it
> only [offset, end) is. The bytes beyond the old end of file stay in the
> dirty folio and, now inside i_size, are file data.
>
> Compare in loff_t; the result is at most folio_size(folio) and fits end.
>
> Found while formally verifying pagecache_isize_extended() against the
> kernel binary.
>
> Fixes: 52aecaee1c26 ("mm: zero range of eof folio exposed by inode size extension")
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>

Looks good to me.

Reviewed-by: Baokun Li <libaokun@linux.alibaba.com>

> ---
>
> Notes:
>     Tested on a 64 MiB ext4 image made with mkfs.ext4 -b 1024 and mounted in
>     a QEMU guest, with the program below followed by umount, mount and a
>     read of [3k+16, 4k). Unpatched 70dd4ee72eb2 (x86_64 and riscv64
>     defconfig): 2048 of 2048 bytes non-zero ('X') after the truncate and
>     1008 of 1008 'X' bytes on the disk after the remount. Patched: 0 and 0.
>     The same sequence with a truncate to 8k reads zeroes on both kernels,
>     which is the case commit 52aecaee1c26 fixed.
>     
>     The 32-bit conversion is visible in the riscv64 binary as a subw on the
>     loff_t difference before the compare; with the patch it is a sub.
>     
>     Reproducer (ext4 with 1k blocks, mkfs.ext4 -b 1024):
>     
>     truncate -s 64M img && mkfs.ext4 -q -F -b 1024 img && mount -o loop img /mnt
>     gcc -O2 -o isize_extended isize_extended.c
>     ./isize_extended /mnt/f    # exit 1 and a non-zero count on an unpatched kernel
>     
>     /*
>      * Stale post-EOF data after a size extension of 4 GiB or more on a file
>      * system with a block size below the page size (ext4 -b 1024): [2k, 4k)
>      * must read as zeroes after the truncate.  Exit status 1 when it does not.
>      */
>     #include <fcntl.h>
>     #include <stdio.h>
>     #include <string.h>
>     #include <sys/mman.h>
>     #include <unistd.h>
>     
>     int main(int argc, char **argv)
>     {
>     	const char *path = argc > 1 ? argv[1] : "/mnt/f";
>     	unsigned char buf[4096];
>     	unsigned int i, nz = 0;
>     	char *map;
>     	int fd;
>     
>     	fd = open(path, O_RDWR | O_CREAT | O_TRUNC, 0644);
>     	memset(buf, 'A', 2048);
>     	if (fd < 0 || pwrite(fd, buf, 2048, 0) != 2048) {
>     		perror("open/pwrite");
>     		return 2;
>     	}
>     	/* 'X' beyond EOF, inside the first page; the folio stays dirty */
>     	map = mmap(NULL, 4096, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
>     	if (map == MAP_FAILED) {
>     		perror("mmap");
>     		return 2;
>     	}
>     	memset(map + 2048, 'X', 2048);
>     	munmap(map, 4096);
>     	/* 4 GiB or more past the folio: to - folio_pos(folio) >= 2^32 */
>     	if (ftruncate(fd, 4294967296LL + 2048)) {
>     		perror("ftruncate");
>     		return 2;
>     	}
>     	if (pread(fd, buf, 2048, 2048) != 2048) {
>     		perror("pread");
>     		return 2;
>     	}
>     	for (i = 0; i < 2048; i++)
>     		nz += buf[i] != 0;
>     	printf("[2k,4k) after truncate to 4 GiB + 2k: %u non-zero bytes of 2048\n", nz);
>     	/* allocate block [3k, 4k): [3k+16, 4k) shows what reaches the disk */
>     	memset(buf, 'B', 16);
>     	if (pwrite(fd, buf, 16, 3072) != 16 || fsync(fd)) {
>     		perror("pwrite/fsync");
>     		return 2;
>     	}
>     	return nz ? 1 : 0;
>     }
>
>  mm/truncate.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/mm/truncate.c b/mm/truncate.c
> index b58ba940be47..5c444812f37a 100644
> --- a/mm/truncate.c
> +++ b/mm/truncate.c
> @@ -878,8 +878,7 @@ void pagecache_isize_extended(struct inode *inode, loff_t from, loff_t to)
>  		unsigned int offset, end;
>  
>  		offset = from - folio_pos(folio);
> -		end = min_t(unsigned int, to - folio_pos(folio),
> -			    folio_size(folio));
> +		end = min_t(loff_t, to - folio_pos(folio), folio_size(folio));
>  		folio_zero_segment(folio, offset, end);
>  	}
>  
>
> base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56



