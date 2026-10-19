Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537FCCCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 11:30:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FD466B01A3; Mon, 19 Oct 2026 07:30:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4556B01A4; Mon, 19 Oct 2026 07:30:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19DCC6B01A5; Mon, 19 Oct 2026 07:30:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E55AF6B01A3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 07:30:48 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 64B741A06DB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:30:48 +0000 (UTC)
X-FDA: 85339158576.13.9B3BB72
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id CA36E1C0005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:30:45 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L6O2T2x9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H3OGq6vW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L6O2T2x9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H3OGq6vW;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792409446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gWeSLpyc5O1IcgR6SkOdVi69vnfzBIqmPx/MkGbdVCU=;
	b=y8PxRmw4mnSwp1OM3hKPIdmQdn1Pux+/j+v7MVhCRcEg581OWCWzxKxHkI/y5ZkGzpn4Pn
	NQwQadk4lzxrPO4kseaMMXdkGUoGFnwA/SYMHhR3/INIR60fukCzk6vWKd+24N6NfOG7pL
	xoN2ovu5/3VNhOFA1T2/d7x3rcpEmjo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792409446;
	b=iY1G7snIPv+NsYrwXCyuJJW+zrPZeDCfWpOO8AFqPmeXn7MQWRiVN8OUfZJ+15mfs0GZ/B
	gtejHTLe/bkn67IOTxUMcBPvQm3wSPkjkzXMUtjZBvRlDsXl7EtR1d8psuuE5leP9xcy2Q
	Pbov7LrSnJ2qMQXN3bFsdueMDrOBzjo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L6O2T2x9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H3OGq6vW;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=L6O2T2x9;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=H3OGq6vW;
	spf=pass (imf21.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 73CAB21C5D;
	Mon, 19 Oct 2026 11:30:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792409444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gWeSLpyc5O1IcgR6SkOdVi69vnfzBIqmPx/MkGbdVCU=;
	b=L6O2T2x9pSLXoAEQlsmjHrrlsPwnlVdfuIgN0qbTfEVWTSnrY/yP3H1h67Rrav/3ml7vgr
	sYMquu3X0n2E0sMKEUYRRxoLXN/Fe+iFiwhrNTtrijGZZgPKPhw2o6UQ1Iocq+dLrXcQCE
	rsRI1icyDY9oGLpqyZw2dBBw6l+GJcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792409444;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gWeSLpyc5O1IcgR6SkOdVi69vnfzBIqmPx/MkGbdVCU=;
	b=H3OGq6vW1LSBbUwIQtir4GTqkGn4jFhwdkH2E4CLsHm/tdwz/hhMmQ+qR4wSWu0bBXSuWt
	Gtx1HIIQndRXOtAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1792409444; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gWeSLpyc5O1IcgR6SkOdVi69vnfzBIqmPx/MkGbdVCU=;
	b=L6O2T2x9pSLXoAEQlsmjHrrlsPwnlVdfuIgN0qbTfEVWTSnrY/yP3H1h67Rrav/3ml7vgr
	sYMquu3X0n2E0sMKEUYRRxoLXN/Fe+iFiwhrNTtrijGZZgPKPhw2o6UQ1Iocq+dLrXcQCE
	rsRI1icyDY9oGLpqyZw2dBBw6l+GJcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1792409444;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=gWeSLpyc5O1IcgR6SkOdVi69vnfzBIqmPx/MkGbdVCU=;
	b=H3OGq6vW1LSBbUwIQtir4GTqkGn4jFhwdkH2E4CLsHm/tdwz/hhMmQ+qR4wSWu0bBXSuWt
	Gtx1HIIQndRXOtAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 4A9A7134B3;
	Mon, 19 Oct 2026 11:30:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4JMqCmT/1WooLAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 19 Oct 2026 11:30:44 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CE575A1413; Mon, 19 Oct 2026 13:30:39 +0200 (CEST)
Date: Mon, 19 Oct 2026 13:30:39 +0200
From: Jan Kara <jack@suse.cz>
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Brian Foster <bfoster@redhat.com>, Theodore Ts'o <tytso@mit.edu>, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/truncate: fix the zeroing end of
 pagecache_isize_extended()
Message-ID: <uolyy5wn2oc7iiu3e3vlsp5m6yjlsakwcjtsuzklbe3mk72ruu@qlrdp3q35igz>
References: <20261016222721.791785-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261016222721.791785-1-nickolai@csail.mit.edu>
X-Rspam-User: 
X-Rspamd-Queue-Id: CA36E1C0005
X-Rspamd-Server: rspam08
X-Stat-Signature: 9srnqx9zana1oet4ruft7fy7znwg71hy
X-HE-Tag: 1792409445-939662
X-HE-Meta: U2FsdGVkX1/i+8dBkmRJOs7L/NxFBbjh29gWieDEAWT8lkIw9TKyCe+0xJUkD8DMXTSumbqeT9UPwxvZqIP9ExJ0f55EZ/8Hl8e68mV6PZMeXRnW4/NckAf9APXJG7/LV51Nw3ouFJXyAd4c7qhKu5GXNc2SgOhhYDXzLQdW2Cf2u7QJzFh7z7vq2XKYHHpIZtImqzFB63JVK/mzdiQJdoRs5UGnC2vjw9+7ef5ymVS4Jx5HZK4ETPPjlQiuHd94QktEJRXUpTpoqWPbrIiPgVu9FrgGqIy1d8exv3al3HrwWIQaijqULj1RT118PUDtbFGta4O1i7mEEJS0eZuhDlQnjnKLxwfUyGHWI7+vAa/CiwftTNWNJtfwkcHxoBlIoG9EZABfznNYPitgX+d0P90nygKxwRJiw6NuKJxruSqbVkYq0og9SJPbT1ow6eZpYhQbRd7+Hir0yOCvjaEsQkbfQXqccIG5c5+TBlymfHFN4hnZU/cOQvyahYrfpTK/FNsd2sChULCU2aCk/d0xHDXWNw+HnAap+vgwi0NbZ2XLwBQivoiRD5Ih9ivEA0aGTDn/X0vPLRVGO/tNpRdolqXyAWWnhCyHPxPqxDaSY0WTDFFQueyp2h+Jj1TSFE+zWLLMm5i2wJCCz0HJeZr616xjLWp39r5KJP7jrnuXyuChC6yzQUzsnk5hFGPb9e/4WWpMvOLDO8G1CyqCrrQxA8sa/o9GuApIZD0qJtQLyYwXElz5x1PTh9zdTVfq3oEFu7V7T9CDORdxddQuKfyZhCruUHvaNQycbhkSOzS8P11mChGKaWUG3iDqMWFbJ+n5q9DUysHqvDRX5siRreceUmQsivjhDyZsgktQil5hSgj3pTnONpL+5sLu+6YcpGnfLKDYgTJ8m+aS6XZpQ/Ss8lYmAbw8qDNT2dh7WVvbkxDVYPfwWiHswDAOqiUarKlhct+eYh4Dzur56BY4uQg
 405fHlYF
 VUUbVWXIFa4jrYGSVGcxlY9PMB2s/gkqQ/y+koL5N1PGswZutWCaUbOSZBwev/ysCENixSXeBLO1saX8M9jBjrTf6W16eAQW41lsvzDz+4GCZGS7SNsGbqS7sdiAl1dRr+nzNXIA5Uj9kFy91eQ0d91HxoynlnqWh8m6V3MQS6z3NiWVVepP6kzAtQYmLMiv7Qelo8Jk/25vE/walbzsKDb7kR2eK9Vqydtxl9S922BFBjrAi4zlde9kDCFSPrkFwMY3TLwNcE8xEeXZqennuO1iUMRHEsQmH0KE24BHx0NP+ovLoSNSJSsB4CIdPGxaQuq68GN2gJpR1gnRpswRujc9CMluC3LaGd9A6M96/U5HebQrCdtC3bWJ3kKNyZyp+zCVLRLWwQPj9fwFw0qpEDFeV+KB2OfTgd108Ng6xposeuqA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 16-10-26 18:27:21, Nickolai Zeldovich wrote:
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

Frankly, I find this paragraph useless. Everything is said below in a more
understandable way. I'd just drop it.

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

The fix looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

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
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

