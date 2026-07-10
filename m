Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B915C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 15:02:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 665106B008C; Fri, 10 Jul 2026 11:02:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C0E6B0093; Fri, 10 Jul 2026 11:02:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52B4B6B0098; Fri, 10 Jul 2026 11:02:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1CE436B008C
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 11:02:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9792A1C3AF3
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:02:51 +0000 (UTC)
X-FDA: 84973184142.25.F5D9ADA
Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	by imf19.hostedemail.com (Postfix) with ESMTP id ADA951A0003
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 15:02:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=BpmW1+MA;
	spf=pass (imf19.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783695770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BZ8qRc6hbIbbhNnh/DKzO2CrCJr9e2RB77cv5o5qDZg=;
	b=NmOxj6R7gf/7JHh6q7+s5PVuch2ICJWzK5xVv7GS8r03nnGnKlw6j+Yf/xNbbppuml1575
	9oqU4iV2XZ5nWVqdAc4HSnjlRUbsNVHsk4qAL92i663PqB+3kUZfInmWdmWB/siZBPlbxe
	lpJ9Djq39FQXflgoHTB2RILOvdrG/as=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783695770;
	b=SM4GjAEosNhUI2pVAs+l33/pvhfIsJLCmCZvEF3T+bEE4GmCOXm++MKaQUBTlbv/hOUlU+
	Yk2zfO34sb23dHPQTznizcFbMXZw8dUyztkKkdUlYYVQ4HHzKQArcB8EgI3WoHazK+lzYL
	jZVWcM91w+zI4CEPY5gjt0S7Twg0WGk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=morinfr.org header.s=20170427 header.b=BpmW1+MA;
	spf=pass (imf19.hostedemail.com: domain of guillaume@morinfr.org designates 212.27.42.2 as permitted sender) smtp.mailfrom=guillaume@morinfr.org;
	dmarc=pass (policy=quarantine) header.from=morinfr.org
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id 736322003CA;
	Fri, 10 Jul 2026 17:02:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=BZ8qRc6hbIbbhNnh/DKzO2CrCJr9e2RB77cv5o5qDZg=; b=BpmW1+MA9drrpqAggRd65BBc9H
	rGtJrKgtmckMg1EP35xEozYFNz+qNhd5gV4BdUaufIgho/H6kvFNZ+4qysMOeq9mpgBIxatGe9QoG
	qwjZkFzdf20HQt1kLnAE96fuU8An7PUtT/Xy/m2EyCYAuMumo0VILgUwpRUgwVWVm8kg=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.98.2)
	(envelope-from <guillaume@morinfr.org>)
	id 1wiCkV-00000001wx6-3X5d;
	Fri, 10 Jul 2026 17:02:43 +0200
Date: Fri, 10 Jul 2026 17:02:43 +0200
From: Guillaume Morin <guillaume@morinfr.org>
To: Breno Leitao <leitao@debian.org>, linux-mm@kvack.org
Cc: riel@surriel.com, Muchun Song <muchun.song@linux.dev>
Subject: [BUG] mm/hugetlb: possible temporary resv underflow
Message-ID: <alEJkwn5VlTTH_ZX@bender.morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ADA951A0003
X-Stat-Signature: oqqe7jp113fb9x8ozd67j1hkbg6mntad
X-HE-Tag: 1783695769-743060
X-HE-Meta: U2FsdGVkX1+x9tCcNLl8D/gRkl3yqAdAkNhi7+VUQlc2T76sc5Ayjo9X5XrYEOv8bGSRgRu457sYEzB4vgwOl3fmTgSYnNsL+td8kFFXNP2ub4m4vXn0MOUvdBJycwPz5vlMj0po3chRFUgmFNEHXtIhCMGooYS+sGGYZTKzhBolCRbuMUd2JiZyU7OeWHvf//SJ2IvjjE/nhtG+3lnHOOHi08ZgqFUOHBnnEsSkFF5S2l4SF4XJGqlbsXYLtC7fM7ZF5cJi4uI8kgqJfOwgMhiEyxSsfvVbeLho8KmYfQoxIMm6dn7Hav3hyY1PVgyk66b5rWrHtGAPhBEkqEgnktLFN2Zxjp0+6W2MH+NF8bk0iBSqEQ+Vm6p6IfOjmADV03CXklFYqJXuxT6f3tRlx423g12A0t823dZ8FOe8PxvQ7AZN6pEGwLC/j9q0x23EQUvqbVuOv2xT88fsrWslshc6DsZfdeQI+KY6TS6zpwCXpbA+wfYGK2OLxB8zmFMFhRrisbuP6VxgRqhezmdokqBy7GLbySFytBwqWYNI28+5+xBlb3rSzMO5X/4TmZ7z/QYNh72ldUJVaGhSwJCYTF2+6A5Zy96Fcm6SpFhKtBlOtXHByOnhN84ZTM1EmshxsJyFIQYGUKt1frhCDL7jgfhJalfAEZSgOUBVfkOC6kF08DPB/+8uxRHURvPkun4IInK14EhcV1bQKp27qqTSdgCICv4E3MspJ/rQIS3ZizJr7NQBQDEZOJi1sO8PkTyedw2fveOVIXuYbWDDf99zvcY2uHuqsKmMolELDfXF/FkC4vpH5sKEiJsPVHM5lB6OzWtmxvk61kbdhugevJest97+lyDK0T9pEtRA/TEk1wFmmqj4NddZdC9IRUkMpH1aOdNVrBQ3vMBCqDAyFVoIdd1RMZB1Ylkhh6BoKI/+JfOPOt9E5jyHJKmRE3nmDBz9RcMiV0ec40lby2HEBTt
 4aZpSD6Z
 /jO0dwtVcrlvhnOr5XTt60x535lBcygUrOCftFL3YUxDT64Q1zDOpuTJqcM9qoEEDsSlOb0cI6DsqviqQ3GRKwkcBIfXmTcQe/5TEijlN4l1prKTHBtVXUjvgbLPsmdSz3l+sUT/C1okbkuG+d7U6Zy+vIxdghmtYgl71QdaD8VUShq5PujFg7Ku6TRe7MBCt8j99mavcqHxOUThipoM3Tm6Tw7Q71ueu1rurxIVJPgdAP+SLk78e8vr8QTkJlpEXb9v1s96jstaxC8Uf4f4zAjLl/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

We've encountered a temporary underflow in the reserved count after a fork when
a parent unmaps a faulted hugetlb page before a child process. 

After a reservation is consumed (i.e the page is faulted), if there is a fork()
and the parent munmaps the page before the child, the reserved count
underflows. The count is restored when the child unmaps the page/exits. I have
reproduced the issue in 6.12.95 and 6.18.38. I believe it's still present in
7.2-rc2 but didn't try to reproduce.

The patch that seems to have introduced the issue is df7a6d1f6405, "mm/hugetlb:
restore the reservation if needed"

I am not sure what the best fix is but checking folio_mapcount() == 0 
in __unmap_hugepage_range() seems to do the trick

                adjust_reservation = false;
 
                spin_lock_irq(&hugetlb_lock);
                if (!h->surplus_huge_pages && __vma_private_lock(vma) &&
-                   folio_test_anon(folio)) {
+                   folio_test_anon(folio) &&
+                   folio_mapcount(folio) == 0) {
                        folio_set_hugetlb_restore_reserve(page_folio(page));
                        /* Reservation to be adjusted after the spin lock */
                        adjust_reservation = true;


Reproducer (it only works if HugePages_Rsvd is 0 at the beginning of the test)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <unistd.h>
#include <sys/mman.h>
#include <sys/wait.h>

static unsigned long num_reserved()
{
	const char* field = "HugePages_Rsvd: ";
	FILE *f = fopen("/proc/meminfo", "r");
	char line[256];
	long v;

	if (!f) {
		perror("Could not open /proc/meminfo");
		exit(1);
	}
	while (fgets(line, sizeof(line), f)) {
		if (strncmp(line, field, strlen(field)))
			continue;
		const char *p = line + strlen(field);
		while (*p && isspace(*p))
			++p;
		if (!*p) {
			printf("could not parse /proc/meminfo line: %s", line);
			exit(1);
		}
		v = strtoul(p, NULL, 10);
		fclose(f);
		return v;
	}
	fclose(f);
	puts("could not parse /proc/meminfo line");
	exit(1);
}

int main(void)
{
	const size_t sz = 2048UL * 1024;
	int pipe_fds[2];
	pid_t pid;
	char *addr;
	long nr;

	nr = num_reserved();
	if (nr != 0) {
		puts("For the test, HugePages_Rsvd must be 0");
		return 1;
	}
	addr = mmap(NULL, sz, PROT_READ | PROT_WRITE,
		MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
	if (addr == MAP_FAILED) {
		perror("Could not allocate a huge page");
		return 1;
	}
	if (num_reserved() != 1) {
		puts("After mmap, HugePages_Rsvd must be 1");
		return 1;
	}

	/* Fault */
	*addr = 0;
	if (num_reserved() != 0) {
		puts("After faulting, HugePages_Rsvd must be 0");
		return 1;
	}

	if (pipe(pipe_fds) != 0) {
		perror("pipe failed");
		return 1;
	}

	pid = fork();
	if (pid < 0) {
		perror("fork failed");
		return 1;
	}

	if (pid == 0) {
		/* Child: Simply wait for the parent */
		char b;
		close(pipe_fds[1]);
		if (read(pipe_fds[0], &b, 1) < 0) {
			puts("Child: read failed");
			return 1;
		}
		return 0;
	}

	/* Parent */
	close(pipe_fds[0]);

	/* First unmap, this will close the vma */
	if (munmap(addr, sz) != 0) {
		perror("munmap");
		kill(pid, SIGKILL);
		return 1;
	}

	nr = num_reserved();
	if (nr == ULONG_MAX) {
		puts("After the munmap, HugePages_Rsvd underflowed!");
	} else if (nr == 0) {
		puts("Underflow not present!");
	} else {
		printf("Unexpected HugePages_Rsvd=%ld after munmap, should be "
			"0 or -1. Repeat the test\n", nr);
	}
	/* Make the child exit, this should restore HugePages_Rsvd to 0 */
	if (write(pipe_fds[1], &nr, 1) < 0) {
		perror("write failed");
		kill(pid, SIGKILL);
		return 1;
	}
	close(pipe_fds[1]);
	if (waitpid(pid, NULL, 0) <= 0) {
		perror("waitpid failed");
		return 1;
	}

	nr = num_reserved();
	if (nr == 0) {
		puts("After the child dies, HugePages_Rsvd is properly "
		     "set to 0");
	} else {
		printf("Unexpected HugePages_Rsvd=%ld after the child "
		       "termination munmap, should be 0 or -1. "
		       "Repeat the test\n", nr);
	}

	return 0;
}

-- 
Guillaume Morin <guillaume@morinfr.org>

