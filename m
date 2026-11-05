Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C3FF7606D807
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 19:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=U1Lfix0H
Received: by kanga.kvack.org (Postfix)
	id D9CE56B05B2; Thu,  5 Nov 2026 14:25:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4D486B05B5; Thu,  5 Nov 2026 14:25:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C606B05B6; Thu,  5 Nov 2026 14:25:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97DFE6B05B2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 14:25:27 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 204C480795
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:25:27 +0000 (UTC)
X-FDA: 85402044294.28.A28520A
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf17.hostedemail.com (Postfix) with ESMTP id 67DF240006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 19:25:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U1Lfix0H;
	spf=pass (imf17.hostedemail.com: domain of tracekotae@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=tracekotae@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793906725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=s4FZg8DsfWmRP296oRW8/FWLLuk54fxztQ3Y/s+Qjl4=;
	b=5hIKI3kDLIxjJAx2eOJ8E4nd1phUIOgTHjadlaEyeAIf0AxIpbTTV4ws53kMdt4x3Yc7VK
	qAounTRPKmHpUjnZEtLPaY0zCZmAOS8HnqNPbRNuQHoG078ivsR9V89BihLAl2q8ph8Mo/
	m1ELZDiUCWKhr1XXFTHe36DvFJi5WrA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=U1Lfix0H;
	spf=pass (imf17.hostedemail.com: domain of tracekotae@gmail.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=tracekotae@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793906725;
	b=lzMqdtI5qdUylXH1Ps8HwRnGAfY74xqibxa1JjFXWz2Ry56BamYUx4PKv60h7GFIu1XJvZ
	rfekVTh2VsLhb1+vHMyFSGkGvE4ltdQOnya+9pimQNoV560EzpoSL2BXxDIA0g4PkcX8fJ
	Eshn+i29+sJ5QJ3DW+gp0TSwseSuyT0=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5bccecba199so1992345e87.1
        for <linux-mm@kvack.org>; Thu, 05 Nov 2026 11:25:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793906724; x=1794511524; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=s4FZg8DsfWmRP296oRW8/FWLLuk54fxztQ3Y/s+Qjl4=;
        b=U1Lfix0HEXTHJs+K/xOj3JtvKP9sY4BfBEzoFteMs/LUVDwYlrVdtKsFM3T6uGiinm
         WoUCsIqu6Ok+ZsYFdj8raGitZk/UyIFTPErky1TP21zOtOAouJ3k3AQqACrtROA6ZdGP
         MTGpD2kZlAH6u8JMMrxX6WfPfn1sdfrHvrMVW1GQhHkS8QGxPh7+CDrUPvck9Kel0YLR
         rGVZyvAkmt+mKzTEZhHS9fRnUiLY3WC2821miFUx31NLdNlZWZsWr7tMvcdlcsrz4BQq
         87wXT4thvjLXh7PcjqxR1eq6mIzkFB3NKBSTGUF0fEmT3cxzaSG3DDq0n3kvWqNb9EAt
         +Qhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793906724; x=1794511524;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=s4FZg8DsfWmRP296oRW8/FWLLuk54fxztQ3Y/s+Qjl4=;
        b=O2oKlfpaC6/AQwbM4QoAt135k2XVq7kNJ4P5m3pCuOpBvvDYELu4CQ6Y39iFVHEeeT
         QjXzECczFP9IelBIpPHZsj2kU7L81z2kMs+xrdLnRSRus1xwSBlDpYXEfNM4ULEuYfkK
         B6tkU4ROywpeJhhSQR81I1TeHOPE9P9LzQqWHON7TXNbmf7h4mMpQuAfxgm4XaWDhgk3
         RVvDlyC2gdAIQbGYuwLaJWSE6bYi/ePNXHyFa9YHsRDRfXXypll/Np314X9F8pRigpJj
         ohacpU8wuVV/uGefa3coPFMB97PgJ49JkY9WMXqDceVIkuEGvZ9MZHQgK7kdIQrTwbn6
         jUQw==
X-Gm-Message-State: APuU4Z+/l3GViouggSib7KH5RkHgfDfC72IYl5uxtJmC176s5nVwhVSF
	pPZJ6F73Ki/+Q0icXprI9pAs2RwoMBQrKMdHrxgmgAgeKI8J79AKV5Xhm5/CLtXuqOh2XQ==
X-Gm-Gg: AYBFou3ppeRccAlZVNgDF9sRq+hVl7t0QLstIYpunzQqJRYPLC/vURyTuuh9UwbkqEz
	EuzDMUVjM+W5itZDKf8Be/Cx2BXMq8YYQaG7gDmyzjandJECtL2rIldZ7DWTr80dkCch+OdyiZ+
	PX1r/fsANGTcGIzPSESG/mSStfRxpwylHXsAr1a6u4A5h2FpmApWXQ2uFjs2b5Y0aybQwRfoi9y
	IXzuEAa762P7xmE3ogn7ov8SzMjEYQe+MsZBrn7JMJVnaELsFD430FHIHVLNfzMEkLbpC+068ch
	I7WIT0dycC7dmFWUfeRW2ImzI71/tyjep12njj2LDsTLVxN7C8wANB22T2uiL1tpnN6lHe3hG9w
	SkCWyZ5Kfw7FnPrVp/27JFkf2VUfWgo+SMqzCEvmd/Cflyv4+uwpZbxCmCri6qV16GpALHWPyJl
	yvj/huQW8JrrI0+Ai6N+Z9eR6cQliSHrEsMxDgTBlj8YeSoG2ceTWY28yvf5NyOSaXNK0y/8/Jt
	jmXROoCAzFWy0lgMd+uUqcJP2QnZXna0LGr20GLPbEa5mJqE66G9yN7ZqRFzlHOim0t4gdR2pbh
	s5AsJUrFQtGSW8qcRJkXim+CxheItsP/C3JOFrA8Ngc=
X-Received: by 2002:a05:6512:104d:b0:5ba:356b:5a85 with SMTP id 2adb3069b0e04-5c003ae0858mr15497e87.43.1793906723445;
        Thu, 05 Nov 2026 11:25:23 -0800 (PST)
Received: from localhost.localdomain ([185.65.135.248])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5c0030a3b50sm25897e87.79.2026.11.05.11.25.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 11:25:23 -0800 (PST)
From: Trace <tracekotae@gmail.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	regressions@lists.linux.dev,
	fujunjie <fujunjie1@qq.com>,
	Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Vishal Moola <vishal.moola@gmail.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [REGRESSION] mm/filemap: mmap read-around stays off for an open file after sparse faults, since 7.2
Date: Thu,  5 Nov 2026 20:25:17 +0100
Message-ID: <20261105192517.228523-1-tracekotae@gmail.com>
X-Mailer: git-send-email 2.54.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9317ospoge675s8y7zmc5n4grz8csjy1
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 67DF240006
X-HE-Tag: 1793906725-670307
X-HE-Meta: U2FsdGVkX1/nOG7sDULlRpBdvdQXAEL+tkZko7igfuAUJlowP/ffAuS/xP8EX8hiLoitnMBRDwtPFKUTi9IvfHLhbHJukUX6/uEvTKwKMvqz9Dtnwu6ZnmRS7zgjT9mRZ753ruZ1+zaEu6jtnxm88nj/mz/jw97B6w5CFrzRnJReyLRUdZT7uzV5tXxXDJIa4oyVlXO4HgKOq/OWEZvBZcpoOXpnrtAygbN1iXMSCmYvHS/6lUpypPlowSpr/nY+3p2Jk7LWYlHgLS4c1D4e82CUzme86TwOZJEu5PXNVwGmIbk/+1ID2AsjspJZ6jFG3qCJy3BcwoRsLGfHyaB8RA09wUAbWHopbzHNmVgFPsSEI3oMbbXDkLZ+hNqBmlfLGYWrBaQGfgRwy9ifg1ax+vhMuXSTQcWdQ8+MOylSgLV9l2S1cfKre53jOhqDLrBxjC+i6GjGmsOLKr2jDuLnNZBuV1KDxHEG6D3Q8XJLLM8rIR5dpnaOKU62mM3NzKAwMyT/kFYpiqYqJZctj6f1MdV4Z3IrjgF6s08Jb7EiFu+1Hwij3Tlh9jonNp+ILTuBUAqzPUMBX7CSWRewN+qRdJlQqe0axd2jt3tyxbGaFciDR+rDqCDoC8ge175/69UOnt2ebSEQXEvflTj9lYThrqtxrfyzlG5cbkXISDf1qloQsyvmXnA0gD5FPvXYW+WOp4+hc1Mz0ig4SkDYl/VRhkgSNM2fn479MemDRJKWlYPxvtfXzCG2LuZvgM9KKOyltQcZcgdHfwPNSqbUANaW2c2TeZ6CTqq7ISXPZEA9IbokhVEroaw4SsRmaumKuZ0+NfropcfeRlTTEOIykXTBNxcCFLh7dLY0TcjOLzsgJhBiDMSIHxgQX0+TIascQ0LrJqX8bXCn9qAypTSop3kBRNvio5yanw1h/7svAirJBLGtKSPMpuht2trNpI4TmcrxSwMjRrhRGBqp/+32kmD
 x6SWAeyG
 CILKLcKfskMvdKh+lgncR7hV1T56YU0BtYgG1+9BbnduPZif0NWvTKm03U892/EwZf8uXPb1Atel+czXG324h88SaOg8bONBEK5zJfV7YzcXZE5gyq80Wi4QW6BwiOJVTtXqN+Ps3i+mEQvWm+UNa3WcbMuGXARG7BDlY93/N9Tsm902ttHEz9zvb2Ri5h237moDLwXfZesvWfXCmUMtTH+uBPzof5E0CAWsx+KBJs1KiilzLpxuePJbGunTbg0F8M+n6Dq6VvxdlEUOn+vcf1Krm6/AmDovOEhfyzoaZWa3co7b57psaHjGjSr5wQczo5yQ5a1rjiIRorcwYaoo3Fy/10L7kZH2uQWVOYGBO/b+8mTJKvwnyTWoKuKX/iVZFfOSZwznRTUXn3EQDA0P3f+bPX8l8GCCWWY9aEjCeY4vVhRnQweEhfl5meT5RiO0MMSyVL0QIoqiMt3+0XEFB9OKn9YJO1w8Tqiff
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

since 7.2, once an open file has taken more than MMAP_LOTSAMISS mmap
misses, it gets no more mmap read-around, even if the access then turns
sequential. For a reader that does not run into pages an earlier
read-around brought in, it stays that way until the file is opened
again. Each later page is a synchronous 4 KiB read, which on NFS is a
round trip.

I think it comes from this series:

  0b9c0aeba938 ("mm/filemap: count only the faulting address as a mmap hit")
  9b0fcac3cfe7 ("mm/filemap: do not count FAULT_FLAG_TRIED retries as mmap hits")

I have not bisected or built a revert. By reading mm/filemap.c, v7.1
and the current 6.18.y have the old accounting and v7.2 onwards the new.
I measured 7.3.1 and 6.18.60, and the program below also gives 16384
on 7.2.14 (with the zen patches) on a SATA SSD. do_sync_mmap_readahead()
and do_async_mmap_readahead() are unchanged from v7.3 in next-20261103
and in mm-unstable, mm-hotfixes-unstable and mm-new of 2026-11-03.

As I read it: above MMAP_LOTSAMISS, do_sync_mmap_readahead() returns
without reading, and mmap_miss only goes down on a hit. With no
read-around the next page is not in the cache, so the next fault is
another miss, and nothing lowers the counter again. Before the series,
the retry after each read-around counted the pages it had just brought
in, so a sparse reader did not reach the limit. The series' tests run
random, stride and sequential access each on its own, not one after
another on the same open file.

The program below writes a 2600 MiB file, drops it with
POSIX_FADV_DONTNEED, touches 2000 pages 1 MiB apart through a private
mapping, then reads 64 MiB sequentially and counts major faults. x86_64,
4 KiB pages, read_ahead_kb 128, ext4, plenty of free memory (7.3.1 on
NVMe, 6.18.60 on a SATA SSD):

                                          7.3.1   6.18.60
  sequential only                             1         1
  sparse pass, then sequential            16384         1
  sparse, MADV_SEQUENTIAL, sequential       512       512
  sparse, close and reopen, sequential        1         1

The same pattern in a Python version, on 7.3.1, on NFS v4.2 over 1 GbE
through WireGuard: 80-90 MiB/s with no sparse pass, 5.7 MiB/s after it.

How I met it: PyTorch loading a model from safetensors on NFS, on a
Radeon AI PRO R9700 with ROCm, where the driver faults in the mapping:

  folio_wait_bit_common
  nfs_do_read_folio
  nfs_read_folio
  filemap_read_folio
  filemap_fault
  __do_fault
  do_fault
  __handle_mm_fault
  handle_mm_fault
  hmm_range_fault_locked
  amdgpu_hmm_range_get_pages
  svm_range_validate_and_map
  svm_range_set_attr
  kfd_ioctl

safetensors maps the whole file (torch.UntypedStorage.from_file,
MAP_PRIVATE) and builds one tensor view per entry, which takes one
read fault per tensor, mostly on its last page. A model file holds
hundreds of tensors spread over the file, so mmap_miss passes
MMAP_LOTSAMISS within a few seconds of the mmap, before any weight is
read (bpftrace on filemap_fault, reading file->f_ra.mmap_miss). The
GPU driver then faults the weights in through the same mapping, every
page a synchronous 4 KiB nfs_read_folio, about 1800 a second.
Read-around came back only when the GPU's walk happened to continue
through a window that one of the first hundred faults had read around:
async readahead restarted there, and about 900 hits later mmap_miss was
under the limit again. With the page cache cold, one model's first
picture took 700 s on 7.3.1, 512 s of it below 10 MB/s, against 239 s
on 6.18; a larger model's first run took 54 minutes against 13.

Is read-around meant to stay off for the life of the open file once the
limit is passed? I have no patch to offer.

#regzbot introduced: v7.1..v7.2

Thanks,
Trace

---8<--- mmap-ra.c
/*
 * mmap-ra.c: does a sparse first pass turn off mmap read-around for the
 * rest of an open file?
 *
 *   gcc -O2 -o mmap-ra mmap-ra.c && ./mmap-ra /path/on/a/disk/testfile
 *
 * Writes a 2600 MiB file (removed at the end), drops it from the page
 * cache with POSIX_FADV_DONTNEED, and counts major faults for a 64 MiB
 * sequential read through a private mapping.
 */
#define _GNU_SOURCE
#include <err.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <unistd.h>

#define MIB	(1UL << 20)
#define SIZE	(2600 * MIB)
#define SPARSE	2000		/* single pages, 1 MiB apart */
#define SEQ_OFF	(2100 * MIB)
#define SEQ_LEN	(64 * MIB)

static long majflt(void)
{
	struct rusage ru;

	getrusage(RUSAGE_SELF, &ru);
	return ru.ru_majflt;
}

static char *open_map(const char *path, int *fd)
{
	char *m;

	*fd = open(path, O_RDONLY);
	if (*fd < 0)
		err(1, "open");
	m = mmap(NULL, SIZE, PROT_READ, MAP_PRIVATE, *fd, 0);
	if (m == MAP_FAILED)
		err(1, "mmap");
	return m;
}

static void run(const char *path, const char *name, int sparse, int advice,
		int reopen)
{
	long page = sysconf(_SC_PAGESIZE), before;
	volatile char sink;
	unsigned long off;
	char *m;
	int fd;

	fd = open(path, O_RDONLY);
	if (fd < 0)
		err(1, "open");
	if (posix_fadvise(fd, 0, 0, POSIX_FADV_DONTNEED))
		errx(1, "posix_fadvise");
	close(fd);

	m = open_map(path, &fd);
	if (sparse)
		for (off = 0; off < SPARSE; off++)
			sink = m[off * MIB + 37 * page];
	if (advice && madvise(m, SIZE, advice))
		err(1, "madvise");
	if (reopen) {
		munmap(m, SIZE);
		close(fd);
		m = open_map(path, &fd);
	}

	before = majflt();
	for (off = SEQ_OFF; off < SEQ_OFF + SEQ_LEN; off += page)
		sink = m[off];
	printf("%-40s %6ld major faults\n", name, majflt() - before);

	(void)sink;
	munmap(m, SIZE);
	close(fd);
}

int main(int argc, char **argv)
{
	static char buf[MIB];
	unsigned long i;
	int fd;

	if (argc != 2)
		errx(2, "usage: %s FILE", argv[0]);

	fd = open(argv[1], O_WRONLY | O_CREAT | O_EXCL, 0600);
	if (fd < 0)
		err(1, "create");
	memset(buf, 0x5a, sizeof(buf));
	for (i = 0; i < SIZE / MIB; i++)
		if (write(fd, buf, MIB) != (ssize_t)MIB)
			err(1, "write");
	if (fsync(fd))
		err(1, "fsync");
	close(fd);

	setvbuf(stdout, NULL, _IOLBF, 0);
	run(argv[1], "sequential only", 0, 0, 0);
	run(argv[1], "sparse pass, then sequential", 1, 0, 0);
	run(argv[1], "sparse, MADV_SEQUENTIAL, sequential", 1, MADV_SEQUENTIAL, 0);
	run(argv[1], "sparse, close and reopen, sequential", 1, 0, 1);

	unlink(argv[1]);
	return 0;
}

