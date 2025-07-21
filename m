Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49389C83F1A
	for <linux-mm@archiver.kernel.org>; Mon, 21 Jul 2025 19:36:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAC906B007B; Mon, 21 Jul 2025 15:36:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A84DE6B0089; Mon, 21 Jul 2025 15:36:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0DB6B008A; Mon, 21 Jul 2025 15:36:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D9156B007B
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 15:36:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF967C017E
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:36:05 +0000 (UTC)
X-FDA: 83689277490.09.FBC3A63
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 3055840002
	for <linux-mm@kvack.org>; Mon, 21 Jul 2025 19:36:03 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R6aBBL1v;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753126564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+CWknxHCijqZvGBkW1s6DuIkr6nwbH/RGvL06OTQ/W0=;
	b=5kag0f044gmPgLAXuKRd82sFQmXPVN8+kREKLVqy0oLwvLBEuRUlEt3FdK2TiHP/+Q/Ux5
	wIESSilhS0A9yciOijMyzD9vTgkh9nohAKCqkKjJ7RLpQ5UHDWYRAb+b0xq8XWKUz1N5yB
	rhdpkaMuWOxgxg61Z1fMIEgbtcyu6bg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753126564; a=rsa-sha256;
	cv=none;
	b=fG5ZANZ4N8WVgr46d+O4P2tgB/STYktf/43cm+zbcUrV7jbKrProYn0CuxdESTHB0Uhewb
	ePc0Ut9v9yg1kpZ1JYFJw4kiuFqp0o4sanfzdZL2HXlx/nUdV89Nju2TEbbY3oMS+nazMY
	3jkFvgmjPe3QXNjQ22j6eHN9YGXdMEQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=R6aBBL1v;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DAB21417A1;
	Mon, 21 Jul 2025 19:36:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DBD3C4CEED;
	Mon, 21 Jul 2025 19:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753126562;
	bh=TB7rn67MajC8Jyg5Da1lj9LyQ2ZybUzjBr843rmIh84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6aBBL1v+Jac/gTJPVwUGLOuSxcdUoTjM2CZ0uHsM6v9ZtbEbYxfIYf3qgS8fVdUZ
	 jjoin8kV/LPRelW8iVxYtHZ1GWxY8bRcxOX4IoqWoMZ25zTcAEAyuG+y3Q6WwJpGuK
	 dDOWrQVmRWMH3+eFy80/am9w0icD0VsV2fsCXK79EiOmYEfVRrSjAnmeztcZe7ahg8
	 Rwq84sT6xhO598gnhxIGq9EIQSJdzhdPQdX8NbO0H4Mcax2rh46R80iAY2gZWVT6qW
	 rXIUTfbsa+ti4Wor7QjDIVUWVPClj0iVQVyordX1wm2QctV3JrhWCl8CTyidLs2YfC
	 wyID6ZM3jpR8g==
From: SeongJae Park <sj@kernel.org>
To: Usama Arif <usamaarif642@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	David Hildenbrand <david@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH POC] prctl: extend PR_SET_THP_DISABLE to optionally exclude VM_HUGEPAGE
Date: Mon, 21 Jul 2025 12:35:59 -0700
Message-Id: <20250721193559.11503-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <4a8b70b1-7ba0-4d60-a3a0-04ac896a672d@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3055840002
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: b8s77mf6fscb51bzcj6z5wx9nn3beaiy
X-HE-Tag: 1753126563-448424
X-HE-Meta: U2FsdGVkX19I7NI/gVF2CDP2qFnsVJJRmK5q/AmYfUr6G97e1jAMQvcyA904mwDAvOdIZqwCkFNzRgfRh57eUZQQBjsTSRTs0LvRlLi5fqgOLH2VFEjQ01JDQMz4jy7CELzx02gjHRlwhsDPq5LirUvotVeoR1ZplY2CYVtOmnhiEaxQ+TNMsVm9T3g7gGJNzPNnyF8J+T3pm4mJhcFMjIOIVe/BXtdpyJpqFHluKJyAfZeFzyys9dJIqo2qiT2uUmO4Gdy7QX1BHLnfgF6dTRBovnIJAPmOTQaoBiFc27kSZf7dbnqn+CDh0pUe2q4SGmzrpqBGOS26kF/Whm+mv2rpFxzcaWnTIwnJ/1UytktouJI+ayt15OFK5U6ONxvPSwk/DC9ZGQ8/WoYWsCkqnDaBRGydxJhC6NfRpr4WqT6GvTb7+NoZkV+JmyOvictzNopgP2zRRB60wZ5BC7075SScBYtE+sp0C+5UcHdbTuJ6dNl5iIgTXoK+RcfdtKrBNPs3wSpevun9uitPh8le5wbVq8S4LnNiOpsGtGKfU/VqI2orE0TnhCcazkYB0/stxHMKLi244B4AiSCgXwmfMAq2n3eXj3CC+5dYPIlS/+oBLI44rLPX7UA13WCetm/EZL/4s10vCwVoNGuhtISilYG1xLhzIXUOn1mhWFL6KBqxeIPDa9iqIXtBIQQqUom7SoadmWR6kpyVGxGmyaJfE5wdweVWldkxWP3sfM8A8z3gAzzjKLB0f1rIsAsc8TLKpyMChb7geC6NLVKiwVXRafkLlUWUcfidvT+Cbo0hepBV5vwy2Kp/STIPWTQbKvMI9NWHZ6WvC6W4/UR0H163Khyp7w9p61Xuy0qm98rDUY5LwvgZtteVpMtj6wRjxSbSYMo8Bq5JrCV1lAsJ27Yj2VwRpLB0NqcXBQDoNqbOY5IRoenEjkanC0uJh017O6KYZXNnL4MSA1/bIE7dLav
 gxt5ss+h
 UkLYMjhfUgv/gmf0bpz8JdFzPxyiPfJ+tSOnt2Ld1/p2UuNZMBDPa/6xVIxq/jQsMKSEg8X2U/Foc1u5zcVLbkywxjH/dCTvlKsFRREMfEAOKhwGYZUtcz8Y6bcl77G2Blk3J2J7kqVgyklr0HlB9K4dFx0HmOYJ3iC8/4rWa9nOUIGVNjr0iGniqFNrm8wcI8BiI5/RuocJBJP7T0NooL4a40ZpMRNwU9wWpuX45REE9RaHxbdSYFUtOmmalD+m3xMKyx4zwgVsHqMBhtf4BobxYzAmsLzgg2M6+vCGrzY1A3DoSurm+R/epm7BEHeRNZoSwUozisVforg+WulTvkaSc2bqz2Iyf60KJVfkAFurZ6trBJT3vfpd/JQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 21 Jul 2025 18:27:38 +0100 Usama Arif <usamaarif642@gmail.com> wrote:

[...]
> >From ee9004e7d34511a79726ee1314aec0503e6351d4 Mon Sep 17 00:00:00 2001
> From: Usama Arif <usamaarif642@gmail.com>
> Date: Thu, 15 May 2025 14:33:33 +0100
> Subject: [PATCH] selftests: prctl: introduce tests for
>  PR_THP_DISABLE_EXCEPT_ADVISED
> 
> The test is limited to 2M PMD THPs. It does not modify the system
> settings in order to not disturb other process running in the system.
> It checks if the PMD size is 2M, if the 2M policy is set to inherit
> and if the system global THP policy is set to "always", so that
> the change in behaviour due to PR_THP_DISABLE_EXCEPT_ADVISED can
> be seen.
> 
> This tests if:
> - the process can successfully set the policy
> - carry it over to the new process with fork
> - if no hugepage is gotten when the process doesn't MADV_HUGEPAGE
> - if hugepage is gotten when the process does MADV_HUGEPAGE
> - the process can successfully reset the policy to PR_THP_POLICY_SYSTEM
> - if hugepage is gotten after the policy reset

Nice!  I added a few trivial comments below, though.

> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>

Acked-by: SeongJae Park <sj@kernel.org>

> ---
>  tools/testing/selftests/prctl/Makefile      |   2 +-
>  tools/testing/selftests/prctl/thp_disable.c | 207 ++++++++++++++++++++

I once thought this might better fit on selftests/mm/, but I found we already
have selftests/prctl/set-anon-vma-name-tests.c, no no strong opinion from my
side.

>  2 files changed, 208 insertions(+), 1 deletion(-)
>  create mode 100644 tools/testing/selftests/prctl/thp_disable.c
> 
> diff --git a/tools/testing/selftests/prctl/Makefile b/tools/testing/selftests/prctl/Makefile
> index 01dc90fbb509..a3cf76585c48 100644
> --- a/tools/testing/selftests/prctl/Makefile
> +++ b/tools/testing/selftests/prctl/Makefile
> @@ -5,7 +5,7 @@ ARCH ?= $(shell echo $(uname_M) | sed -e s/i.86/x86/ -e s/x86_64/x86/)
>  
>  ifeq ($(ARCH),x86)
>  TEST_PROGS := disable-tsc-ctxt-sw-stress-test disable-tsc-on-off-stress-test \
> -		disable-tsc-test set-anon-vma-name-test set-process-name
> +		disable-tsc-test set-anon-vma-name-test set-process-name thp_disable
>  all: $(TEST_PROGS)
>  
>  include ../lib.mk
> diff --git a/tools/testing/selftests/prctl/thp_disable.c b/tools/testing/selftests/prctl/thp_disable.c
> new file mode 100644
> index 000000000000..e524723b3313
> --- /dev/null
> +++ b/tools/testing/selftests/prctl/thp_disable.c
> @@ -0,0 +1,207 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * This test covers the PR_GET/SET_THP_DISABLE functionality of prctl calls
> + * for PR_THP_DISABLE_EXCEPT_ADVISED
> + */
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/mman.h>
> +#include <sys/prctl.h>
> +#include <sys/wait.h>
> +
> +#ifndef PR_THP_DISABLE_EXCEPT_ADVISED
> +#define PR_THP_DISABLE_EXCEPT_ADVISED (1 << 1)
> +#endif
> +
> +#define CONTENT_SIZE 256
> +#define BUF_SIZE (12 * 2 * 1024 * 1024) // 12 x 2MB pages
> +
> +enum system_policy {
> +	SYSTEM_POLICY_ALWAYS,
> +	SYSTEM_POLICY_MADVISE,
> +	SYSTEM_POLICY_NEVER,
> +};
> +
> +int system_thp_policy;
> +
> +/* check if the sysfs file contains the expected substring */
> +static int check_file_content(const char *file_path, const char *expected_substring)
> +{
> +	FILE *file = fopen(file_path, "r");
> +	char buffer[CONTENT_SIZE];
> +
> +	if (!file) {
> +		perror("Failed to open file");
> +		return -1;
> +	}
> +	if (fgets(buffer, CONTENT_SIZE, file) == NULL) {
> +		perror("Failed to read file");
> +		fclose(file);
> +		return -1;
> +	}
> +	fclose(file);
> +	// Remove newline character from the buffer

Nit.  I'd suggest using "/* */" consisetntly.

> +	buffer[strcspn(buffer, "\n")] = '\0';
> +	if (strstr(buffer, expected_substring))
> +		return 0;
> +	else
> +		return 1;
> +}
> +
> +/*
> + * The test is designed for 2M hugepages only.
> + * Check if hugepage size is 2M, if 2M size inherits from global
> + * setting, and if the global setting is always.
> + */
> +static int sysfs_check(void)
> +{
> +	int res = 0;
> +
> +	res = check_file_content("/sys/kernel/mm/transparent_hugepage/hpage_pmd_size", "2097152");
> +	if (res) {
> +		printf("hpage_pmd_size is not set to 2MB. Skipping test.\n");
> +		return -1;

Nit.  Skipping is done by the caller, right?  I think it is more natural to say
"Skipping test" from the caller.

> +	}
> +	res |= check_file_content("/sys/kernel/mm/transparent_hugepage/hugepages-2048kB/enabled",
> +				  "[inherit]");

Nit.  I think we can drop '|' and just do 'res = '.

> +	if (res) {
> +		printf("hugepages-2048kB does not inherit global setting. Skipping test.\n");
> +		return -1;
> +	}
> +
> +	res = check_file_content("/sys/kernel/mm/transparent_hugepage/enabled", "[always]");
> +	if (!res) {

Seems 'res' is being used for only checking whether it is zero.  Maybe doing
'if (check_file_content(...))' and removing 'res' can make code simpler?

> +		system_thp_policy = SYSTEM_POLICY_ALWAYS;
> +		return 0;
> +	}

Also, system_thp_policy is set only here, so we know 'system_thp_policy ==
SYSTEM_POLICY_ALWAYS' if sysfs_check() returned zero.  Maybe system_thp_policy
is not really required?

> +	printf("Global THP policy not set to always. Skipping test.\n");
> +	return -1;
> +}
> +
> +static int check_smaps_for_huge(void)
> +{
> +	FILE *file = fopen("/proc/self/smaps", "r");
> +	int is_anonhuge = 0;
> +	char line[256];
> +
> +	if (!file) {
> +		perror("fopen");
> +		return -1;
> +	}
> +
> +	while (fgets(line, sizeof(line), file)) {
> +		if (strstr(line, "AnonHugePages:") && strstr(line, "24576 kB")) {
> +			is_anonhuge = 1;
> +			break;
> +		}
> +	}
> +	fclose(file);
> +	return is_anonhuge;
> +}
> +
> +static int test_mmap_thp(int madvise_buffer)
> +{
> +	int is_anonhuge;
> +
> +	char *buffer = (char *)mmap(NULL, BUF_SIZE, PROT_READ | PROT_WRITE,
> +				    MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
> +	if (buffer == MAP_FAILED) {
> +		perror("mmap");
> +		return -1;
> +	}
> +	if (madvise_buffer)
> +		madvise(buffer, BUF_SIZE, MADV_HUGEPAGE);
> +
> +	// set memory to ensure it's allocated

'/* */' for consistency?

> +	memset(buffer, 0, BUF_SIZE);
> +	is_anonhuge = check_smaps_for_huge();
> +	munmap(buffer, BUF_SIZE);
> +	return is_anonhuge;
> +}
> +
> +/* Global policy is always, process is changed to "madvise only" */
> +static int test_global_always_process_madvise(void)
> +{
> +	int is_anonhuge = 0, res = 0, status = 0;
> +	pid_t pid;
> +
> +	if (prctl(PR_SET_THP_DISABLE, 1, PR_THP_DISABLE_EXCEPT_ADVISED, NULL, NULL) != 0) {

Nit.  '!= 0' can be dropped.

> +		perror("prctl failed to set policy to madvise");
> +		return -1;
> +	}
> +
> +	/* Make sure prctl changes are carried across fork */
> +	pid = fork();
> +	if (pid < 0) {
> +		perror("fork");
> +		exit(EXIT_FAILURE);
> +	}
> +
> +	res = prctl(PR_GET_THP_DISABLE, NULL, NULL, NULL, NULL);
> +	if (res != 3) {
> +		printf("prctl PR_GET_THP_POLICY returned %d pid %d\n", res, pid);
> +		goto err_out;
> +	}
> +
> +	/* global = always, process = madvise, we shouldn't get HPs without madvise */
> +	is_anonhuge = test_mmap_thp(0);
> +	if (is_anonhuge) {
> +		printf(
> +		"PR_THP_POLICY_DEFAULT_NOHUGE set but still got hugepages without MADV_HUGEPAGE\n");
> +		goto err_out;
> +	}
> +
> +	is_anonhuge = test_mmap_thp(1);
> +	if (!is_anonhuge) {
> +		printf(
> +		"PR_THP_POLICY_DEFAULT_NOHUGE set but did't get hugepages with MADV_HUGEPAGE\n");
> +		goto err_out;
> +	}
> +
> +	/* Reset to system policy */
> +	if (prctl(PR_SET_THP_DISABLE, 0, NULL, NULL, NULL) != 0) {
> +		perror("prctl failed to set policy to system");
> +		goto err_out;
> +	}
> +
> +	is_anonhuge = test_mmap_thp(0);
> +	if (!is_anonhuge) {
> +		printf("global policy is always but we still didn't get hugepages\n");
> +		goto err_out;
> +	}
> +
> +	is_anonhuge = test_mmap_thp(1);
> +	if (!is_anonhuge) {
> +		printf("global policy is always but we still didn't get hugepages\n");
> +		goto err_out;
> +	}

Seems is_anonhugepage is used for only whether it is zero or not, just after
being assigned from test_mmap_thp().  How about removing the variable?

> +	printf("PASS\n");
> +
> +	if (pid == 0) {
> +		exit(EXIT_SUCCESS);
> +	} else {
> +		wait(&status);
> +		if (WIFEXITED(status))
> +			return 0;
> +		else
> +			return -1;
> +	}
> +
> +err_out:
> +	if (pid == 0)
> +		exit(EXIT_FAILURE);
> +	else
> +		return -1;
> +}
> +
> +int main(void)
> +{
> +	if (sysfs_check())
> +		return 0;

May better to return KSFT_SKIP insted of 0?

> +
> +	if (system_thp_policy == SYSTEM_POLICY_ALWAYS)

This should be always true, since sysfs_check() returned zero, right?  I think
we can remove this check.

> +		return test_global_always_process_madvise();
> +

Nit.  Unnecessary blank line.

> +}
> -- 
> 2.47.1
> 
> 
> 


Thanks,
SJ

