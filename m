Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D370C624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 08:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DCC56B00B6; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 166646B00BE; Wed,  2 Sep 2026 04:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006F76B00BD; Wed,  2 Sep 2026 04:23:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C4A376B00B6
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 04:23:03 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5160FC0122
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:23:03 +0000 (UTC)
X-FDA: 85168131846.06.D0403BC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59239100007
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 08:23:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eae+IDop;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788337381;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=WsG1umXNBkZtcSPDoEuKxZOpN9hlpasrB4gbkcRIH8I=;
	b=XqA5U6y2Zk11G6CR5J7v7aUqBnnhPsvaj0/sGKpzEF4wah1qAYKPRZ2mh0aOkZ5TL5j6co
	QBHvitOo/SAkA1jG509/xvPj6mzavMPlViosWycc87WZlee+rPLXKmgZmg+ZIU4gndiHov
	Z/TqljM7qA3wbtvKEBTpnJIYLv1i91o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eae+IDop;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788337381;
	b=BZIC6kcvcg10DDx31PdtrC2TWPV3gHkADfL5f+kVlpyBB2Jpd3OBsHo2EwjY6QGyto3wDW
	AbMllqTg7aWgsMSMbQTzzAh62PZ9XJ7shfXkD2ahG7bR8lJzxxx+VRVB8qbnBDPMEHWHFv
	7GZx6iTvcq/KDYfUdpDZcJSDy/DN30U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 83B47419E3;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5857BC2BCC7;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1788337380;
	bh=9s2vpaiXD6s4W26CbucrW3C0rPFnD/K26BzyCEp2oKI=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=eae+IDop8RQum/3tRAhM6zJOu0m+Qt5zsAiP0eQZLF1ZWgIab8mJO52bxYu1h73d8
	 f4txXi4iMPdHSf/8+fIaAotI8HHVuhCnXqdkf2SpgzuUrygpJO85NPzgAXO6BaiQLD
	 LGotZT0yQ/r4GGvdvhHXkNSOqZP2k8/cRRoSSSF0sV/VOUcUPa1pj0+Aqx7z9V19IQ
	 g7WhBsab2/Vp+m7OxVBSjMJVDAZJdtqoRMmZ16mSOVxi96FFBRqOyNSPSY07fBTm2z
	 Z/kyMT4AmTmtG//Uq3NzSHKKfv84FFHQC38QRy/qjO92pueJflaIwad9tQaX5vV+iy
	 O9GKuYl1Bovnw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE2EC624D0;
	Wed,  2 Sep 2026 08:23:00 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Subject: [PATCH 0/2] Fix bugs in HugeTLB allocation when
 mem_cgroup_charge_hugetlb() fails
Date: Wed, 02 Sep 2026 01:22:55 -0700
Message-Id: <20260902-hugetlb-alloc-folio-memcg-charge-error-handling-v1-0-e3e8942c141b@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAN/cl2oC/x2N0QrCMAxFf2Xk2UBXaVF/RXyYXdoFslbSKcLYv
 xt8PHDuuTt0UqYOt2EHpQ93btVgPA2QlqkWQp6NwTsf3dWNuLwLbfLESaQlzE244UprKmi+mk+
 qTdG2s3AtGC7RUzx7CjmAVV9Kmb//x/vjOH6S4QqagQAAAA==
X-Change-ID: 20260901-hugetlb-alloc-folio-memcg-charge-error-handling-5862e632e5f5
To: Alex Shi <alexs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Miaohe Lin <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Nhat Pham <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Peter Xu <peterx@redhat.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Shuah Khan <skhan@linuxfoundation.org>, jthoughton@google.com, 
 fvdl@google.com, rientjes@google.com, vannapurve@google.com, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Ackerley Tng <ackerleytng@google.com>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1788337379; l=5404;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=9s2vpaiXD6s4W26CbucrW3C0rPFnD/K26BzyCEp2oKI=;
 b=2WFDdksKyvJUDYhmN6mhW3mHuuBJDYSVhnCKZRLzvGT3p8ao0/FZrWrDMPZmoSB6VWfrJvYfO
 ZqEvKDgvDdCDsVLiWbMo1LGxxx+0rHv9PX0GIJuxC/JRx33OyDcKnLS
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: eycbyu19qn1f7siouhjxxajs6u1knfg5
X-Rspamd-Queue-Id: 59239100007
X-HE-Tag: 1788337381-581268
X-HE-Meta: U2FsdGVkX1+MGMYNJEJU3BVs3+A6rfBfKY6nxh2fsbxV0kZn9aqfEI7NP1s/LUD8lJKH63b/i8OjcwzFIu6bWJ63R33J3G/ic5TpIl5zGQrKDsO8jaRrGKoUE/fQzi4+lCsB2BQEip3yYpVzJ6Sii8Gn+5Zydg7I2shjYnxemCa7STGQMF+FLJp99xdAF2GHSpKzlc6BLkq1tOTSqNgT+jDLBiwc6PpV+WKdHXmj8q/er+gAUPZ1Y8imaqg2AfRaIg4oQio3ZACnkBqdlbJqeJX1keye4zFMzsGNKCath0/4HDl0l2wyOVzCFWSG1FGmSQIDFPgQOw4bWAISJ0RmTTPsWPVJaXMLi3OEsUVM0EMvprKKgzVFrMgouSaEmXpUf+Bat8ScjU2P01ijKC03CZNY09cyKoZ5ErkCSgaKyuGlpvX8Hq9sXBp2XXnb+F+xQZH1AJgcOf8f7xULlex/BjFs4Bhwyt9I1eqJRY9CCH/SpWdXFn+U7eLOLuVARK3/4VnNbT6sZIw2i8dZAo38rCNyqnkPfNTjgZLKWRNthHUv9yGCpeNO1jg9+0XT+4n/XVe9r8uq2MogKeNvpGYVPCFjRS9hILjbxszKCobiEqJyAEn3octra6MJMmMeq0T05gu9QpPBKCAK5PBpwOuNzt0AgZ6h3xYgYmUl1sUuYP4Uqvr1CjU3YNFm/6qUYzzEeqY7Q1HLcO74Wc/+I9wp3LqFdoYHsfm8K3QQcrfGZaUiEqs5nK3RRNYIoVanxYNmG2juqja6J4+mXBXV9mFoqJzVWNCofMZCRdvprkwaDe93ho9mjaTg6rMIRf3xvRlNWdC2YJh+xD/RdERZOjSkKOtv5b+rDOY9jZqWsujE157b3XQ4+lHOXCKc6HOZdsFwhUPCS0L2uad7RVsL0qEFPT3XVQCfXQ2BYdX8ZyRYGPxmr6Xul/Ux6kZUST3I3rMqjRWRyLSOSvdL7Rdfv+H
 foU74kof
 J202tHQpgl6n28hvYlqiwJ8JjReAi/off6kJo27UEkJHu3vGHMJmtGYEafOKrWTnhDnYx50qTOErckTJVlHzyrs5qWjo/MFW728T9o/v+Tb1M1MaBtcLuTIQFfxbCOGnhuqgTCEJw5A5VR2Fga0ENAwn2R6DRrtb/uGQNT4mNfY1HsptbNIifateYTtJhYhFV1iWUQPNpV5KXFd1UXO5cCmKdyX0CoW2pg30/cwwBiZW5iLdRlcftHFhTV9hj5LX65sxDEBr+GSOnAv0gx9+KCxaqO91SSOLfUgj/hgEyoJfWuegDACrd/H8jLHeQ97sv/2xaKZetFbC7Ut323kRu/cRwaKb34y3w2Z3tGHzcV72oy96EWVooLCtCzuUW906YFTgm/C8ioiaClOLjz+n72HKgAdpiCiQ/ZUs/FmZpi0ERUoD3yky051BBFs0RbBMIKmfSenl+ysmux7fACHKsxJlgwOCj+L382BRIZMMAME80Cu89wWuT5WYi0mxE9Q/42Ntg78yjWDWBRMZeVvAvs7DImg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In hugetlb_alloc_folio(), when mem_cgroup_charge_hugetlb() fails, there are
2 issues:

1. free_huge_folio() expects a non-refcounted folio and will
   VM_BUG_ON_FOLIO().

2. -ENOMEM is returned, causing an infinite loop retrying the fault.

This patch series is a subset of patches in [1].

Note: [1] was applied on an earlier version of HugeTLB allocation. In that
earlier version, VMA reservations were not undone on
mem_cgroup_charge_hugetlb() failure.

5737df3826dee: ("mm: hugetlb: refactor out hugetlb_alloc_folio()") fixed
that, since returning an error from hugetlb_alloc_folio() causes
alloc_hugetlb_folio() to execute vma_end_reservation().

In [2], an earlier revision of [1], "mm: hugetlb: Drop refcount before
freeing on memcg charge failure" was named "mm: hugetlb: Fix folio refcount
mismatch on memcg charge failure".

[1] https://lore.kernel.org/all/20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com/
[2] https://lore.kernel.org/all/20260708-hugetlb-alloc-failure-fixes-v2-0-c7f27cbb462b@google.com/

Here's a reproducer to trigger mem_cgroup_charge_hugetlb() failure:

static void write_file_val(const char *path, const char *val)
{
	int fd = open(path, O_WRONLY);

	if (fd < 0) {
		fprintf(stderr, "Failed to open %s: %s\n", path, strerror(errno));
		exit(1);
	}
	if (write(fd, val, strlen(val)) < 0) {
		fprintf(stderr, "Failed to write %s to %s: %s\n", val, path, strerror(errno));
		close(fd);
		exit(1);
	}
	close(fd);
}

static int is_hugetlb_accounting_enabled(void)
{
	char spec[256], file[256], type[256], opts[512];
	char line[1024];
	int enabled = 0;
	FILE *fp;

	fp = fopen("/proc/mounts", "r");
	if (!fp) {
		perror("fopen /proc/mounts");
		return -1;
	}

	while (fgets(line, sizeof(line), fp)) {
		if (sscanf(line, "%255s %255s %255s %511s", spec, file, type, opts) == 4) {
			if (strcmp(file, CGROUP_PATH) == 0 && strcmp(type, "cgroup2") == 0) {
				if (strstr(opts, "memory_hugetlb_accounting") != NULL)
					enabled = 1;
				break;
			}
		}
	}
	fclose(fp);
	return enabled;
}

static int enable_hugetlb_accounting(void)
{
	int ret;

	printf("Attempting to remount cgroup2 with memory_hugetlb_accounting...\n");
	ret = system("mount -o remount,memory_hugetlb_accounting " CGROUP_PATH);
	if (ret != 0) {
		fprintf(stderr, "Failed to remount: system() returned %d\n", ret);
		return -1;
	}
	return 0;
}

int main(int argc, char **argv)
{
	struct stat st;
	size_t size;
	void *addr;
	pid_t pid;
	int enabled;
	int status;
	int fd;

	if (stat(CGROUP_PATH, &st) != 0 || !S_ISDIR(st.st_mode)) {
		fprintf(stderr, "cgroup v2 not mounted at %s\n", CGROUP_PATH);
		return 1;
	}

	enabled = is_hugetlb_accounting_enabled();
	if (enabled < 0)
		return 1;

	if (!enabled) {
		if (enable_hugetlb_accounting() != 0) {
			fprintf(stderr, "Could not enable memory_hugetlb_accounting\n");
			return 1;
		}
		/* Re-check */
		enabled = is_hugetlb_accounting_enabled();
		if (enabled <= 0) {
			fprintf(stderr, "Failed to enable memory_hugetlb_accounting (re-check failed)\n");
			return 1;
		}
		printf("Successfully enabled memory_hugetlb_accounting\n");
	} else {
		printf("memory_hugetlb_accounting is already enabled\n");
	}

	/* Enable memory controller in subtree */
	fd = open(CGROUP_PATH "/cgroup.subtree_control", O_WRONLY);
	if (fd >= 0) {
		(void)write(fd, "+memory", 7);
		close(fd);
	}

	if (mkdir(TEST_CGROUP_PATH, 0755) != 0) {
		if (errno != EEXIST) {
			perror("mkdir test_reproducer");
			return 1;
		}
	}

	/* Set memory limit to 1MB (less than 2MB hugepage) */
	write_file_val(TEST_CGROUP_PATH "/memory.max", "1M");

	pid = fork();
	if (pid < 0) {
		perror("fork");
		return 1;
	}

	if (pid == 0) {
		/* Child: Move to cgroup */
		write_file_val(TEST_CGROUP_PATH "/cgroup.procs", "0");

		printf("Child: Attempting to allocate and touch 2MB hugepage...\n");
		/* Allocate 2MB hugepage */
		size = 2 * 1024 * 1024;
		addr = mmap(NULL, size, PROT_READ | PROT_WRITE,
			    MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB, -1, 0);
		if (addr == MAP_FAILED) {
			perror("Child: mmap MAP_HUGETLB");
			exit(1);
		}

		printf("Child: mmap succeeded at %p, touching it now...\n", addr);
		*(char *)addr = 1;

		printf("Child: Successfully touched page (bug not triggered?).\n");
		munmap(addr, size);
		exit(0);
	}

	/* Parent */
	waitpid(pid, &status, 0);

	printf("Parent: Child exited. Cleaning up.\n");
	rmdir(TEST_CGROUP_PATH);

	if (WIFSIGNALED(status)) {
		printf("Parent: Child killed by signal %d (%s)\n",
		       WTERMSIG(status), strsignal(WTERMSIG(status)));
		if (WTERMSIG(status) == SIGBUS)
			printf("Parent: Child got SIGBUS as expected.\n");
	} else if (WIFEXITED(status)) {
		printf("Parent: Child exited with status %d\n", WEXITSTATUS(status));
	}

	return 0;
}

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
Ackerley Tng (2):
      mm: hugetlb: Return -ENOSPC on memcg charge failure
      mm: hugetlb: Drop refcount before freeing on memcg charge failure

 mm/hugetlb.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)
---
base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
change-id: 20260901-hugetlb-alloc-folio-memcg-charge-error-handling-5862e632e5f5

Best regards,
--
Ackerley Tng <ackerleytng@google.com>



