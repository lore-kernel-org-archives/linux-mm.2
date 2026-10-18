Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B776BCCA490
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 09:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3F7C6B0088; Sun, 18 Oct 2026 05:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC9B36B008C; Sun, 18 Oct 2026 05:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991D46B0092; Sun, 18 Oct 2026 05:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D0B26B0088
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 05:10:10 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD6EA1A04C9
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 09:10:09 +0000 (UTC)
X-FDA: 85335175338.17.96CB766
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id D358C180002
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 09:10:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HSW4gySL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792314607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X96Dw2kONVYl3pYurol2SUKv+j8HTJxgA5k41JeZl3E=;
	b=hv/qDtQG91+AeiRR2uJoy5k3lCyhXjhGYjR1khXRUEZrySOT5TxBzCB+rvaquuhy2DcBCZ
	cM/XVk67wsGZYuJBcmT1XDMjEcrlq+9G/4samDsoHFtVMYyX9Oxro3U2dObzyIHRP5zb3T
	J+fn15AUzRsptF+lIMCHgqwRXtzW4FQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=HSW4gySL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of urezki@gmail.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=urezki@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792314607;
	b=Xm7w0oSsnm2glOjbqe7JtONldTbO//ihmiv55Xa3/7Qv4vuURNVTRCAxvPQ7NCbxMbsd4q
	HlX0o9VHDnvJYbZnPJ1NnLz9TU6isMVCsDazn9aGxoqwqf1a8WG6VQtXFZm07E5NSJ1MCn
	2BGtGJzHhb2rvz611fPxSJC4kuw9f70=
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c34bff61551so166424866b.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 02:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792314606; x=1792919406; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=X96Dw2kONVYl3pYurol2SUKv+j8HTJxgA5k41JeZl3E=;
        b=HSW4gySL82/wk/leoLASRY3QvyFOHv13xXocbFgguVs9JSkvHHBceoGuDBvCAApbrb
         Gj2/HRJW/a7KZ3BSuzG8/lWAr/cDh3fIU4uanyZ6qGShMhcHFKUb91J5GB9NsIhWEy0W
         7jb96xpCJtmxxxlxMx0fQOE+dQtkJFVtIAgcPHcKtFAoVwWpdEnJr3lEZyLkNjfXPCy4
         yxIjWU1vuiNNMRHTqEUhgmssqeydqtipiOdtZYGG1o3+Iy3aON75EbFY1sUlDRFebg74
         RnWGEsPmsgeooPlt1nGN3VaZtdXu3hByihKdRWV8CVWlrVrY6hklp6AEuLnPfFgEaXqK
         74Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792314606; x=1792919406;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=X96Dw2kONVYl3pYurol2SUKv+j8HTJxgA5k41JeZl3E=;
        b=auOXC0fcJCD8b71xfDqgoVkMOriU1L06lxFIhdKhFV8YZlSyAM+RzWH0eoDjPWJ6xt
         nicNtlQt2X79+OiEJG4gKgUR4QfIYWqVJ79ml6UI5EdTySEZ+Tnbr0BmJ6DJQY46aUZw
         s3LC0dQswDAkQTB29rDSTlpmuRrZ2ICsxnp1aIZfZF8BA89jSuT3WRuMWlLw6fZboIL5
         1rAyrQFTRSUMzx1Sr+JWOVrXufTyqn+Op0vADbuwBFMa2Qb52En7Tr7CJ50JShI9V0Sa
         c3xj0tkLJWJ9DC3CBquEokEOh/KizvQjiNynZLnN9AORoNDOSpOZio9HP6d+exzOgEQP
         pXng==
X-Forwarded-Encrypted: i=1; AKwUvBzryrpGx1Xo+HtUB5is9WJAe34Xs2AKLJXmXwlgGpS/ykfgi+s/hhvQyKhjJxVdGyQeXCeTRywmZg==@kvack.org
X-Gm-Message-State: AFq9FYITsItHqoy3PXh6sZp8qJk6qUHJprkh1IAvfP+jRpNXqhqv85qR
	mw65mn8AAnLHMKgE3zJ6gyS3uO3NGpAUHIDq0q/IEOtgffyn4rLNLRmk
X-Gm-Gg: AYBFou2OCZq6vQbptL5VtpXkLVYuvgGxoDI0BDzojxYwLXuPtX6CzM7KCfgh1b44Q7F
	684tQkWZcCo1eaQRFRACKEDoCp4UglE0aQTceozmvB3cQ2nt+QEZeyayG3cjJW5a5mvsXqOzjh3
	7Oy+1Q+A4YxMCy8gmWHiDHp113JS+J15rivVR2dTFofBHSqOpnfucmnLmcIHTws1ldER2qF04l9
	gL/z6lJPM8wScAkfUGIhAh9bE/3JHhts9Mn/pk1meeYV4C4OiD84kFT2U00Cm27EncdEkmWRYzH
	pN6/yNxY/HFaDrqroXJdiELDO2yNkyaYXBk5IYaBg6dgyt4b7uaXnJJyLfe+V3nI2gK5YOqIB0H
	Dg+FqduX/AH6RTRx9Po2u7w7wuYMZipg99lXlWrYm8KqkwzmFQMnhCCIzIuM+ELgfOzn0ZFkCqU
	a3gUHK3a/Dr9iiMm7jVu9ljEoYFSwzK0Tg7us=
X-Received: by 2002:a17:907:1ca2:b0:c2a:f439:f028 with SMTP id a640c23a62f3a-c419e639ffbmr342064366b.24.1792314606094;
        Sun, 18 Oct 2026 02:10:06 -0700 (PDT)
Received: from milan ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c42a3f4eaa0sm88973966b.0.2026.10.18.02.10.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 02:10:05 -0700 (PDT)
From: Uladzislau Rezki <urezki@gmail.com>
X-Google-Original-From: Uladzislau Rezki <urezki@milan>
Date: Sun, 18 Oct 2026 11:10:03 +0200
To: Nickolai Zeldovich <nickolai@csail.mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Baoquan He <baoquan.he@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmalloc: read vm_map_ram block regions from the
 requested offset
Message-ID: <atSM69faDNgmLNVJ@milan>
References: <20261017125244.b2d7134fa9697b2982cb8cec@linux-foundation.org>
 <20261017231325.796986-1-nickolai@csail.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261017231325.796986-1-nickolai@csail.mit.edu>
X-Rspamd-Queue-Id: D358C180002
X-Stat-Signature: nyymzn38j1yoxq8fhdzccrxdh443teqt
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792314607-824136
X-HE-Meta: U2FsdGVkX1/gtljpaizCvgNj27AXEoJYfw+czfbHbeu+mc4t6WDSEdEMeOK+2g3J4CfUtrwG7xhwoGZTebxC0Eun6bZwd6jgvNtJ9ERV/pm9dNcYc+fFQHVRRw9Fjmi3CKPRQYdeOTlYpvSfrt8J8E2xX3tT389JaPbmY9EiFMv7tvaaSlSbB4B+paVyxbzmMraj3NpHOm7xlMUETuwE2IUTqDG9I4+N0kf6BAPq6GkfnTjFhkEof/2robx2SyaPketenmn7mFNjWGmHAww1vFyXrpxXN6G1Wkpq0Xf3HVLqe2hg/jFaaRWacFfNc/jW5bAkwXcpmQW0zv6oIxjzDPL8adlIRL9MmBcFyuYEZs1DJIKJdK/U1b0xcc6nhSD9lHmbdVKKuX1N7QyD0lHuvIeMfW4MzOvTAAdH6FmkQz6TLJ1aV+A3YA86qShAFluGn4Me6Da7IT+tkUBtWVjht9vObmxr3jJR6gPS6RnaqqV+7N3PDGzRPdCX2H8zwrFmcCGuZzUD1iaTVbGL/yVHuzAD/lbnEFd9a7PBsxZnlAIG1wpgEoPpUzQ1an2jTsfCsHlKqQpksCbjSF7ZW7nfHEKHthtO0Ty5H3MX+/9goCnX751964HfFrscrSaLh+WbNTLsswDn+q4vy3PfJS37+HLZH/AbbKpM2ek569QVVZ+58qN4rbApjsqdM+Iw5E+N+T5CriQLabBPDvntlhU91wVfunYLlfDKsldc5eFSLE/5Hn989c8/aSznDGwBl2SfZincYbRPA7EFMc4Feu5mEnPS8vqsVCS79cZGw2IvfOwVgJ9r+/FIBEYaCUv6yrqEY9a/249ebgjo4Sx70HI5lMc7A/213vjUrHlAQi2KhkVSTFBO/BhjHuAl1Is4VJXhm+d3llntxLkNQa6vEpKCGngrIgHOu5ljYhoSK9ZLuutkSJRf6kWVJ1g39X+mO7mIAwdEbbAsLw7mDbzLAZw
 sP0hw2Tv
 oG0Yhzew+DkvHbw4g/Sk1npqY1GlGJf23ghiVQP29zN7PQr4grxuYM1gTzkhIkKX8jsq36WvqcJuAad60P1kr9FQsa8NlSeNHK4w9Gf11gIKxAGSIBV2mi0+TthLK4hQyvEmPueL/tXIFjxI/KEv9wDjWoSWLNcmKZkFnQZZHHCB9qPqmeTl8YC917Gyw+TrZzcwiMt9c1U+I3pWwFHdz+aGcFpGPwG/1EMepj/IsMQvsUOXgmubiMvq5IwOTOFFZJBadcIpDCf80Bgk6AS6L/PeY+xKTrWmnPZbgzq+K6VDwutJfVPEOZG1o3wWY4u/q1+oURWYDWLu4co1RbU6fYdY4JwtldBAO7+oluFCENox2IkwWq5W8L6dq0DpHoCKjTvht6T6E1xWi623tDNknYMNdS3nyD7wSQJGYTYzmsMgtGQud0LCmVZ7ZGZ4XRvONYbumbwnFp2BY0PiS2by9bGyz05N9ioz4ElpHAmx130jZjB/dCV6+6SZeLNJFKBcb4nL6P1/Qp5KNbHs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Oct 17, 2026 at 07:13:25PM -0400, Nickolai Zeldovich wrote:
> Reading a vm_map_ram() mapping through /proc/kcore returns the wrong
> memory for every page except the first page of the first used region in
> its vmap block.  read_kcore_iter() calls vread_iter() one page at a
> time, so a root user reading a live system with drgn, crash or gdb gets
> that first page in place of every later page of the mapping, and in
> place of the zeroes of the unused pages after it.  This affects every
> vm_map_ram() mapping that fits in a vmap block (up to BITS_PER_LONG
> pages): erofs and f2fs decompression buffers, videobuf2 vmalloc/dma-sg
> buffers, udmabuf vmaps, fuse readdir pages.  Kernels since v6.3 are
> affected.
> 
> vmap_ram_vread_iter() walks the used regions of the block and, for each
> region, zero-fills up to its start and then copies from
> start + offset_in_page(addr).  A read starting in a later page of a
> region therefore copies the region's first page, and a read starting
> past the end of a region still copies from that region.
> 
> Skip regions that end at or before addr, and copy from addr itself,
> i.e. use addr - start as the offset into the region.  The region is
> re - rs pages long, not re - rs + 1: for_each_set_bitrange() returns
> [rs, re) with re the first clear bit.  The extra page is one whose
> used_map bit is clear, and vb_free() clears the bits before it unmaps
> the pages, so a read racing with vm_unmap_ram() copied the page being
> freed instead of zero-filling it.
> 
> Tested on x86_64 by queueing a 29-page V4L2_MEMORY_USERPTR buffer on a
> vivid capture device, which videobuf2-vmalloc maps with vm_map_ram(),
> page i starting with "userptr page i", and reading every page of its
> vmap block through /proc/kcore.  Before, all 1024 pages of the block
> read as page 0.  After, pages 0..28 read back in order and the rest of
> the block carries no tag.  With a second buffer in the same block and a
> 100-page buffer outside the block path, reads at unaligned offsets,
> across page and region boundaries, into and within the unused part of
> the block, and of the whole block return the true contents.  With an
> msleep() inserted between the bitmap_clear() and the
> vunmap_range_noflush() of vb_free(), a read of a one-page buffer being
> unmapped between two mapped ones returns zeroes.
> 
> Fixes: 06c8994626d1 ("mm/vmalloc.c: allow vread() to read out vm_map_ram areas")
> Assisted-by: LLM
> Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
> ---
> 
> Notes:
>     Changes in v2:
>       - region length is (re - rs) pages, not (re - rs + 1); suggested by
>         Andrew Morton.  The extra page was shown with an msleep() added to
>         vb_free() between its bitmap_clear() and its vunmap_range_noflush():
>         a one-page buffer being unmapped between two mapped ones then read
>         back its own bytes through /proc/kcore with v1 and zeroes with v2.
>     
>     Reproducer (CONFIG_PROC_KCORE=y, CONFIG_VIDEO_VIVID=y or =m, root):
>     
>       /* short.c: argv[1] = vivid capture node */
>       #include <elf.h>
>       #include <fcntl.h>
>       #include <linux/videodev2.h>
>       #include <stdio.h>
>       #include <string.h>
>       #include <sys/ioctl.h>
>       #include <sys/mman.h>
>       #include <unistd.h>
>     
>       int main(int argc, char **argv)
>       {
>       	struct v4l2_format fmt = { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE };
>       	struct v4l2_requestbuffers req = { .count = 1,
>       		.type = V4L2_BUF_TYPE_VIDEO_CAPTURE, .memory = V4L2_MEMORY_USERPTR };
>       	struct v4l2_buffer b = { .type = V4L2_BUF_TYPE_VIDEO_CAPTURE,
>       		.memory = V4L2_MEMORY_USERPTR };
>       	static Elf64_Phdr ph[64];
>       	static char buf[4096], line[256];
>       	unsigned long lo, hi, a;
>       	int fd = open(argc > 1 ? argv[1] : "/dev/video0", O_RDWR);
>       	int kc = open("/proc/kcore", O_RDONLY), i, n, np, c;
>       	Elf64_Ehdr eh;
>       	FILE *f;
>       	char *p;
>     
>       	ioctl(fd, VIDIOC_G_FMT, &fmt);
>       	fmt.fmt.pix.width = 320;
>       	fmt.fmt.pix.height = 180;
>       	ioctl(fd, VIDIOC_S_FMT, &fmt);
>       	np = (fmt.fmt.pix.sizeimage + 4095) / 4096;	/* 29 for YUYV */
>       	p = mmap(NULL, np * 4096, PROT_READ | PROT_WRITE,
>       		 MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>       	for (i = 0; i < np; i++)
>       		sprintf(p + i * 4096, "userptr page %d", i);
>       	b.m.userptr = (unsigned long)p;
>       	b.length = np * 4096;
>       	if (ioctl(fd, VIDIOC_REQBUFS, &req) || ioctl(fd, VIDIOC_QBUF, &b))
>       		return perror("QBUF"), 1;	/* buffer now vm_map_ram()ed */
>     
>       	f = fopen("/proc/sys/kernel/kptr_restrict", "w");	/* raw %pK */
>       	fputs("1", f);
>       	fclose(f);
>       	if (pread(kc, &eh, sizeof(eh), 0) != sizeof(eh) || eh.e_phnum > 64 ||
>       	    pread(kc, ph, eh.e_phnum * sizeof(*ph), eh.e_phoff) < 0)
>       		return perror("/proc/kcore"), 1;
>       	f = fopen("/proc/vmallocinfo", "r");
>       	while (fgets(line, sizeof(line), f)) {
>       		if (!strstr(line, "vm_map_ram") ||
>       		    sscanf(line, "0x%lx-0x%lx", &lo, &hi) != 2)
>       			continue;
>       		printf("%lx:", lo);
>       		for (c = 0, a = lo; a < hi; a += 4096)
>       			for (i = 0; i < eh.e_phnum; i++)
>       				if (ph[i].p_type == PT_LOAD && a >= ph[i].p_vaddr &&
>       				    a < ph[i].p_vaddr + ph[i].p_memsz &&
>       				    pread(kc, buf, 4096, ph[i].p_offset +
>       					  a - ph[i].p_vaddr) == 4096 &&
>       				    sscanf(buf, "userptr page %d", &n) == 1 &&
>       				    c++ < 32)
>       					printf(" %d", n);
>       		printf("%s (%d pages carry a tag)\n", c > 32 ? " ..." : "", c);
>       	}
>       	return 0;
>       }
>     
>       $ gcc -static -o short short.c
>       # modprobe vivid; ./short /dev/videoN     # N = vivid capture node
>     
>     Before:
>       ff32776280800000: 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 ... (1024 pages carry a tag)
>     After:
>       ff636d6c00800000: 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 (29 pages carry a tag)
> 
>  mm/vmalloc.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index bea9f76ed7e7..643299c9ca15 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -4588,7 +4588,7 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
>  	struct xarray *xa;
>  	unsigned long offset;
>  	unsigned int rs, re;
> -	size_t remains, n;
> +	size_t remains, n, size;
>  
>  	/*
>  	 * If it's area created by vm_map_ram() interface directly, but
> @@ -4622,6 +4622,10 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
>  			goto finished;
>  
>  		start = vmap_block_vaddr(vb->va->va_start, rs);
> +		size = (re - rs) << PAGE_SHIFT;
> +
> +		if (addr >= start + size)
> +			continue;
>  
>  		if (addr < start) {
>  			size_t to_zero = min_t(size_t, start - addr, remains);
> @@ -4635,8 +4639,8 @@ static size_t vmap_ram_vread_iter(struct iov_iter *iter, const char *addr,
>  		}
>  
>  		/*it could start reading from the middle of used region*/
> -		offset = offset_in_page(addr);
> -		n = ((re - rs + 1) << PAGE_SHIFT) - offset;
> +		offset = addr - start;
> +		n = size - offset;
>  		if (n > remains)
>  			n = remains;
>  
> 
> base-commit: 70dd4ee72eb2d5793c62e71c14e3aba78e5a4e56
> -- 
> 2.53.0
> 
IMO, it should be improved by dropping more and make the code more
cleaner. For example offset. Basically what we need here is to
have a payload start address and its end.

The addr is within that range(skip if addr >= end), so we have
a clear picture what we need to read.

how much to read is: end - addr, read starts from addr.

--
Uladzislau Rezki

