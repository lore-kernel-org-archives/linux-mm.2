Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A19DACA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 10:47:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07FF98E000D; Fri,  5 Sep 2025 06:47:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 057BB8E0006; Fri,  5 Sep 2025 06:47:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAF228E000D; Fri,  5 Sep 2025 06:47:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D9A888E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 06:47:04 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2257186B66
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:45:43 +0000 (UTC)
X-FDA: 83854865766.27.E184CD6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf11.hostedemail.com (Postfix) with ESMTP id 05AFF40026
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 10:45:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HoesHaSt;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757069141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vIeg0yqzETdeSHkZIWTN6hmtEKVJ541dSozjEpreLoc=;
	b=ruvjhk7yQMiyzo63SFCqkaVv3XiJP//O9Aa5uPv3byqSdSr9xcaWHKJ/0x1q+J/WDDa46u
	RxtVdT+Iz8ebccBKPXbEriY+vQm1YFiD4+vQovPEz3dqOTfnyEOADQOxJYAez93dpvxG7z
	tlPuURY2HLf2FJ57sC1vbWTMAqS7oao=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757069141; a=rsa-sha256;
	cv=none;
	b=risvlATut13g65c1sQt9Cy8rlBv1RpDVGylmlZpX91zhrKnQQF1WYehu78ffztyPd9FgKw
	U8D2NEPbJJ81SyZDECQiFXa5AzfjkFtA+ip4rx80sxvk4Y0AJjTgkrQGT6PiekWljiS3OJ
	examWVVMQ1oincMBWGmxXGLiedEQiyI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=HoesHaSt;
	spf=pass (imf11.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45cb5492350so13252875e9.1
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 03:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757069138; x=1757673938; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vIeg0yqzETdeSHkZIWTN6hmtEKVJ541dSozjEpreLoc=;
        b=HoesHaStzrM2UDOUTRU0Vteme3PISyX718dDr29hoYARdWcZIaNiysGbspy1SGGYgR
         fNiX/Npib0g2bcrhdDIevqQE05s5HjQxaiXBYjav7hrrRauz4r7rQ+mn3shhJao9RagD
         OaGOe0ziuPgM/+nEoMILbLmNPThP267lgA3wjs8A7aNtIZfeYWaXQ/zUl5ECjZm68Z2n
         hP+T8IkLW8LsazzzN6Ufw7sTlwog/PMRPQAWJGt4+knlbYEWkSBqNHz87tyK/lyrJVEX
         TCRJ06PaQ4j5cErQcX8H6yNni9EP5JqKFRtYwCpr1zwelCxILDg+evG7aaxcsUZITUiP
         yXag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757069138; x=1757673938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vIeg0yqzETdeSHkZIWTN6hmtEKVJ541dSozjEpreLoc=;
        b=AbvSKJJ9A9PHTz0Dc3KyC1CSofI54UwWiWrz/GGFDkvqGrmcd/5ZGBlYToFwcnHCp6
         3Xn99zU/8H+He5nxMLcVkq/vfTFb6g3AhbHLK4ZZN4zVbtwIyyw1bhLQRog+5R3XnpXm
         h90724x9SvhJ/jA1eJX2ktK1UwZUB+v4PKkRDjCCaygHIgtyLmqZaVPyHmd77sFC2jYj
         FI40wXCONjCIEnb1YELggiC7eTNsIQGzHIRUXUSmMQU5ALYfTXy4OdJzQE5CB63NxjiD
         eg96+uchtEbZ8C7xqpXoEHDK4XnbQbGQrUZsw2aYZwd0UV3QKmn1n1S1K4tqjI5FnCFL
         Y2eQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgujI/0Uxq6HKWlbfTDE/xer8Ap5olQR6lAmv2S5LF3WbtIef5svo8qk6yjznoPhmJExbRhfD7Uw==@kvack.org
X-Gm-Message-State: AOJu0YyJlFmtRL3wfCZVmOl0VIQlzKS1F6rGs2/V2mZV8c6q3w9i825Y
	cQ3Y4QN5Fi9bE66PE0y4GfTHL1Q6Kr4yS6mkA+5ebSMiVugE4RwkhzaW
X-Gm-Gg: ASbGncva+odr+S/iFBc/HUV4WenNXMG6HLHfVRh8aLR9k96uTh9HZNysaIHxqHh9bbl
	PP2sDSsjoQVcTWuQofIsmNFLrthDTTsS9NhLukvmeUNp/u+WBxxud/bDEumE9UCTnJcP1EgnfGR
	mfvc78iTLgDXEC5jwdOs8OghRRcTDijBjRLkvNTNgJrxyvSFJKsD09nzYjmdBMYyAlpsBfM6Gny
	g6UCivlVHbU9+gmHoth20WU/2NGOcnCgSWlhi/LRQpP+EC7CNiCSVghTY6PdVFtXAahgN40diuP
	IcD3qnYSCyHYXdWyfwkbknafuRorukdQMonLPWmtTAgWcm/rMJZOa2459Z/UOQlFUA0HFk9LhOC
	dM/c4ftVzFQC7e2jo0L3bZf1M0nYDkT3qs3DNHNfzr/e135Bmaq5UOpDbqK1JwK2F/ONo/Jw=
X-Google-Smtp-Source: AGHT+IF7zH6O/IARVMa6C/x7M1EW7/WLvxsTy/oeKFSx4oRsBGT1cL9nVQpPjnDqP/DV4lTAFT8owg==
X-Received: by 2002:a05:600c:5253:b0:45d:98be:ee91 with SMTP id 5b1f17b1804b1-45d98bef030mr60621485e9.9.1757069138227;
        Fri, 05 Sep 2025 03:45:38 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1126:4:1449:d619:96c0:8e08? ([2620:10d:c092:500::4:4f66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45ddb779eb6sm8583055e9.8.2025.09.05.03.45.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Sep 2025 03:45:37 -0700 (PDT)
Message-ID: <981d7f32-96b4-4b40-8765-fecd53c372af@gmail.com>
Date: Fri, 5 Sep 2025 11:45:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tools/mm: Add madvise tool
Content-Language: en-GB
To: kirill@shutemov.name, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org
Cc: Kiryl Shutsemau <kas@kernel.org>
References: <20250904175729.1029735-1-kirill@shutemov.name>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250904175729.1029735-1-kirill@shutemov.name>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 05AFF40026
X-Stat-Signature: n1amqfug6jiwq61gytf841nim9gxb6e4
X-HE-Tag: 1757069140-420560
X-HE-Meta: U2FsdGVkX1/OFZsvyVe6kbt9B7CWFwt2ZsEDUjjpWE1zQ3ynFUsOlweiUrBWV+gnJT4FPp50tC6K/EZl6CqdwPtdgmS6VY8h8nVt82rIA1EkQoqjU10Vc1zKARUAhAGOSt3TkGVDf+Q3/AzdZHxpIG0sssQGjzKQ5C1aQcyeNLLS7I/2Heix5TEf94s6z93HMzkVPW+5NMagoXiyPySildJAf01QSGWHoqClwJ/PPNtpGWe4IvZo1dubMv+FpHniXjMLlkTI5lvoKvqV2TwPv7PZkpvix6QF55fLSxhAfvcPMrADVUOOWZMG/IXvoJ+bVrCeLrAvAD7HTOfpcFFOy0R6Q6KsvYq0KNKkWU0LJ5YqxUy0uHTDDPWV59+Bgjxpds2cYpv4r7hVoLCT1GutV6cS7BfItUlAIub/7vEG4P4MwLUxs3vSM8ez5qskoylTgVVSIcRjoNRFg/ql59lo+ghM2ogJjxXqj8gLJEAcoGY1VwPo5hKPdc/5MqAYVJa7gDcl1xEeqcIvdfoePtMD97NQev4s9cAxNRrVS8DaMH6N54bRbVSJgvQBcrC0xptv5kQeAsSOLgXgKw0ewAUpJnb7LAXBBJNid2TsXE0AzMctTKF8gPu271rRa9Ifu9KoABBu0wfGG/6N0A7VJpaUOp1JjKP2G640/548wXt5b99fc2rYHDh6W3MoVcnF+28tp9N7NuKl82vXF4yYwMQk+un4TgOIy3dA7011wHGwLo9ZsrvyCZ+wYbLehBb/ZMX+Lt8itdN1lzQ6S6p5qKmRR7n6jOUjAHEvaKBgwEPQ4ks7zOa0PjI0Jd0n7b5C/nL5rNV3x+sOzdqkoUNvPW+Bjoo9vFYfvNOFxotP8b0/ZKKZNBfoQPHQFEvS4fiOdZUa/B4tOSASiAfbSn2DvuE37QahlVHpN1gqioDu13pEEN0rQsTAixgFwpPHSX3BwoIaAsKVdGLxGRHXsK9XoUz
 cWJ9WQ0B
 Y0l40Zhc0zumXBbJnElPuMmU+M86drVTh7FcaCXDF3wZUDhv26umbCaOYLxYqFPS7mbH8c3SgAF98IScl2PYB1VI2AWU2xtmhIaoX+An55YXy7lQSrxaVgagZkoKB67EcmYZ4AP2KxbxsyQjK3SVyVbXloSXYqA8xFduMl5B/fr46O54ipOmi1I4irZgtonnxf9pso7E4fSNjvJyFiWnb6ci02EL4b0KGFzNlkb2PnRrJJKmFxKymPU8ulnz55P8fR4y7I3VOodiCjy7alwBjwSeqOJbyIeaRK/MoOxbcPipeWFWWFeWHVZ2XMB0kpi32mgWfwLYH3KFuDZ5yX1hdy/igGkf9P+4Wp1pxTjVyK8RNszlFntiMlOG2yOJ9GnM8bVrl9nJUkWAgZjcG63UuUfSB+4wJ3h2fni5mh0CsYQWSlMcInrrGKyWmO5NTMSePE1etv7CeqKSq2fEMxDZkqt5h6GbzX+sNQuES8RcNJC2WfjkcEYwaXcN0nc6EMzi57x7QaCd+obhTNhybnNSSFWH1XwhRq3mMSONORdrdOXESQoQ6wdzaV3jUVWubiPWtOolE
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 04/09/2025 18:57, kirill@shutemov.name wrote:
> From: Kiryl Shutsemau <kas@kernel.org>
> 
> Add a simple tool that allows to issue an advice on a process or a file.
> 
> It can be useful to experiment with effects of an advice on a workload
> without modifying the workload itself.
> 
> Only supports advices available for process_madvise().
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  tools/mm/.gitignore |   4 +-
>  tools/mm/Makefile   |   2 +-
>  tools/mm/madvise.c  | 170 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 174 insertions(+), 2 deletions(-)
>  create mode 100644 tools/mm/madvise.c
> 
> diff --git a/tools/mm/.gitignore b/tools/mm/.gitignore
> index 922879f93fc8..b713fcf4a2e0 100644
> --- a/tools/mm/.gitignore
> +++ b/tools/mm/.gitignore
> @@ -1,4 +1,6 @@
>  # SPDX-License-Identifier: GPL-2.0-only
> -slabinfo
> +madvise
>  page-types
>  page_owner_sort
> +slabinfo
> +thp_swap_allocator_test
> diff --git a/tools/mm/Makefile b/tools/mm/Makefile
> index f5725b5c23aa..db315a48adcd 100644
> --- a/tools/mm/Makefile
> +++ b/tools/mm/Makefile
> @@ -3,7 +3,7 @@
>  #
>  include ../scripts/Makefile.include
>  
> -BUILD_TARGETS=page-types slabinfo page_owner_sort thp_swap_allocator_test
> +BUILD_TARGETS= madvise page-types page_owner_sort slabinfo thp_swap_allocator_test
>  INSTALL_TARGETS = $(BUILD_TARGETS) thpmaps
>  
>  LIB_DIR = ../lib/api
> diff --git a/tools/mm/madvise.c b/tools/mm/madvise.c
> new file mode 100644
> index 000000000000..038b3e1076ea
> --- /dev/null
> +++ b/tools/mm/madvise.c
> @@ -0,0 +1,170 @@
> +// SPDX-License-Identifier: GPL-2.0
> +#define _GNU_SOURCE
> +#include <fcntl.h>
> +#include <limits.h>
> +#include <stdarg.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <string.h>
> +#include <unistd.h>
> +#include <sys/mman.h>
> +#include <sys/syscall.h>
> +
> +static void usage(void)
> +{
> +	printf("madvise TARGET ADVICE START END\n\n");
> +	printf("Arguments:\n");
> +	printf("\t<TARGET>\n");
> +	printf("\t\tA process ID or a file to give the advice to.\n\n");
> +	printf("\t\tUse \"./\" prefix if the file name is all digits.\n\n");
> +	printf("\t<ADVICE>\n");
> +	printf("\t\tcold\t\t- Deactivate a given range of pages\n");
> +	printf("\t\tcollapse\t- Collapse pages in a given range into THPs\n");
> +	printf("\t\tpageout\t\t- Reclaim a given range of pages\n");
> +	printf("\t\twillneed\t- The specified data will be accessed in the near future\n");
> +	printf("\n\t\tSee madvise(2) for more details.\n\n");
> +	printf("\t<START>/<END>\n");
> +	printf("\t\tStart and end addressed for the advice. Must be page-aligned.\n\n");
> +	printf("\t\tFor PID case, it is addresses in the target process address space.\n\n");
> +	printf("\t\tFor file case, it is offsets in the file.\n\n");
> +}
> +
> +static void error(const char *fmt, ...)
> +{
> +	if (fmt) {
> +		va_list argp;
> +
> +		va_start(argp, fmt);
> +		vfprintf(stderr, fmt, argp);
> +		va_end(argp);
> +		printf("\n");
> +	}
> +
> +	usage();
> +	exit(-1);
> +}
> +
> +#define PMD_SIZE_FILE_PATH "/sys/kernel/mm/transparent_hugepage/hpage_pmd_size"
> +static unsigned long read_pmd_pagesize(void)
> +{
> +	int fd;
> +	char buf[20];
> +	ssize_t num_read;
> +
> +	fd = open(PMD_SIZE_FILE_PATH, O_RDONLY);
> +	if (fd == -1)
> +		return 0;
> +
> +	num_read = read(fd, buf, 19);
> +	if (num_read < 1) {
> +		close(fd);
> +		return 0;
> +	}
> +	buf[num_read] = '\0';
> +	close(fd);
> +
> +	return strtoul(buf, NULL, 10);
> +}
> +
> +static int pidfd_open(pid_t pid, unsigned int flags)
> +{
> +	return syscall(SYS_pidfd_open, pid, flags);
> +}
> +
> +int main(int argc, const char *argv[])
> +{
> +	unsigned long pid, start, end, page_size;
> +	int advice;
> +	char *err;
> +	int fd;
> +
> +	if (argc != 5)
> +		error(NULL);
> +
> +	pid = strtoul(argv[1], &err, 10);
> +	if (*err || err == argv[1] ||
> +	    pid > INT_MAX || (pid_t)pid <= 0) {
> +		// Not a PID, assume argv[1] is a file name
> +		pid = 0;
> +	}
> +
> +	if (pid) {
> +		fd = pidfd_open(pid, 0);
> +		if (fd < 0)
> +			perror("pidfd_open()"), exit(-1);
> +	} else {
> +		fd = open(argv[1], O_RDWR);
> +		if (fd < 0)
> +			perror("open"), exit(-1);
> +	}
> +
> +	if (!strcmp(argv[2], "cold"))
> +		advice = MADV_COLD;
> +	else if (!strcmp(argv[2], "collapse"))
> +		advice = MADV_COLLAPSE;
> +	else if (!strcmp(argv[2], "pageout"))
> +		advice = MADV_PAGEOUT;
> +	else if (!strcmp(argv[2], "willneed"))
> +		advice = MADV_WILLNEED;
> +	else
> +		error("Unknown advice: %s\n", argv[2]);
> +
> +	page_size = sysconf(_SC_PAGE_SIZE);
> +
> +	start = strtoul(argv[3], &err, 0);
> +	if (*err || err == argv[3])
> +		error("Cannot parse start address\n");
> +	if (start % page_size)
> +		error("Start address is not aligned to page size\n");
> +	end = strtoul(argv[4], &err, 0);
> +	if (*err || err == argv[4])
> +		error("Cannot parse end address\n");
> +	if (end % page_size)
> +		error("End address is not aligned to page size\n");
> +
> +	if (pid) {
> +		struct iovec vec = {
> +			.iov_base = (void *)start,
> +			.iov_len = end - start,
> +		};
> +		ssize_t ret;
> +
> +		ret = process_madvise(fd, &vec, 1, advice, 0);
> +		if (ret < 0)
> +			perror("process_madvise"), exit(-1);
> +
> +		if ((unsigned long)ret != end - start)
> +			printf("Partial advice occurred. Stopped at %#lx\n", start + ret);
> +	} else {
> +		unsigned long addr, hpage_pmd_size;
> +		void *p;
> +		int ret;
> +
> +		hpage_pmd_size = read_pmd_pagesize();
> +		if (!hpage_pmd_size) {
> +			printf("Reading PMD pagesize failed");
> +			exit(-1);
> +		}
> +
> +		// Allocate virtual address space to align the target mmap to PMD size
> +		// Some advices require this.
> +		p = mmap(NULL, end - start + hpage_pmd_size, PROT_NONE,
> +			 MAP_ANONYMOUS | MAP_PRIVATE, -1, 0);
> +		if (p == MAP_FAILED)
> +			perror("mmap0"), exit(-1);
> +		addr = (unsigned long)p;
> +		addr += hpage_pmd_size - 1;
> +		addr &= ~(hpage_pmd_size - 1);
> +
> +		p = mmap((void *)addr, end - start,
> +			 PROT_READ | PROT_WRITE, MAP_SHARED | MAP_FIXED | MAP_POPULATE, fd, start);
> +		if (p == MAP_FAILED)
> +			perror("mmap"), exit(-1);
> +
> +		ret = madvise(p, end - start, advice);
> +		if (ret)
> +			perror("madvise"), exit(-1);

Would be good to munmap here and check output?

> +	}
> +
> +	return 0;
> +}


