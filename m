Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2DC8CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 20:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 176C38E0016; Thu, 16 Oct 2025 16:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 128358E0002; Thu, 16 Oct 2025 16:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0161C8E0016; Thu, 16 Oct 2025 16:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E1C9B8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 16:45:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3629387369
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:45:48 +0000 (UTC)
X-FDA: 84005158776.29.6C686D1
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id 59855100003
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 20:45:46 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SeHe3PkJ;
	spf=pass (imf05.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760647546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1kpH/IPeNwgc8siGpWHSiGFjX32BfbjsHkNF2cmzC/U=;
	b=ryGe7gki0lu66XfnYSzMS2+s6WdNfsg2ZdFEBTUbvVEvzdVDJulMaWc0FLB9K607gSm5FX
	glxV/qK/ua0HvJbPQ9vz9Z+s8WO3htrO2zjwI+6gnIsXHsyfHGna9SmmQB008xVQgCgkkU
	KOLAsQv89V9o1fO9HAPwmdxGYPk1dpk=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SeHe3PkJ;
	spf=pass (imf05.hostedemail.com: domain of inwardvessel@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760647546; a=rsa-sha256;
	cv=none;
	b=H+XqRt1wQ06Jrvxc4BhEhp9xob+y+O4iAm2SsK3qrPhInVYBRo87PV9eqs/aBLjeFcgAGm
	mqELTS3HQpofTvKTptnsj3Ih227yr7GZNOETTThADVdhfIjkfftANz9gG75YMS4iQwO6Yf
	lOshV43s6XMKcDH7cZaTT8CqX/xv0yw=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-77f67ba775aso1739862b3a.3
        for <linux-mm@kvack.org>; Thu, 16 Oct 2025 13:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760647545; x=1761252345; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1kpH/IPeNwgc8siGpWHSiGFjX32BfbjsHkNF2cmzC/U=;
        b=SeHe3PkJw5mW9miUM11Fe3bKU9S+1+MM3iGKTl2GNxc0XsyBl4ViAkZuEgEV5Ib/P7
         KG+2l+n/yG9rm4O1BAjSswFd8fV/zRr8BUJeOxFF+jQWY0oBmnCopvbUxaq4FDJtX+fD
         QxLAkabbUIBm3TzHGlQwUZYY3XOMy8X3oJ4KIiy3eOnCtzl1CBjQKYRNEV1QgbOG6QWg
         MPwHXTuAzB2bhswJvkpvHPvxSHrTqGy5Z/BvF3hr3vFFvmxVm/5Yu1/3FUx3nmDOmkKM
         7gTUU+Vj6fUBXkLbWABajd0RZ/k4tvSL8I/INpl0wW46pq4BRay9bymN9ODwVEpXiC4a
         X+1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760647545; x=1761252345;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1kpH/IPeNwgc8siGpWHSiGFjX32BfbjsHkNF2cmzC/U=;
        b=RwlIKCHiP/35HzSnTCIEYjB3UK6u6b38kfqZhKOccKjutImji574HXRsFIXNns6CWl
         EKnQQ9DdBPVKLNZYIvR3Ng4z/nXGUc1Eq4EObgaMnnMEAGoUW6fqNloI9BQvcUVfb8BF
         /sgqN8BfUcMLSowZmdgnCUIFMnDxdvaEjJitGaPZUMf44ITKaGnOkBJ6MAKTPQSkj90V
         5pg0te9c3ziNnCA9lLZjeolVM9UazKswmsTf0xTVDlTuFSb7qePNFZVqaUiYlKC8tCTC
         x9HbNtw1nALaDCu5hnNdpGox7r3gWOk3UXVV0Q6r7yQ6mb/L7X2wK/yXOTUT4VK9gFyY
         1K6A==
X-Forwarded-Encrypted: i=1; AJvYcCXpEzvfUp1T5rcTCOa6IFawchYT/gLYMOlBFBbsHmok9CV0KXeiu1Cm2Sjf76myQU8qskMMThJ9Xw==@kvack.org
X-Gm-Message-State: AOJu0YzFgfkPw1arUNl7MC+PqAi6+HSnqpxzkdtgu/D1V8JDJBWRa3u9
	78C6y9rHQam8lIfnLsoq416khcIcchk5FcSjhuVG6+9n5p7K4LjsQZZd
X-Gm-Gg: ASbGncukYD2lvpfadV57sYASepUlNZUicWnBKj5aqyqUFvcBm01TBl3OIBIWtphPWOR
	e1EKDjmcZHDhXXoJ2Avw0s5fSUspl8hWjKRjPHWGe6/bbv1VVWywdHu15fY325LNf420plLaiLk
	VyS5cJ/+LGVnaL+7STE2NgPLb9+xbWjKdaosQJ4hp+X13arWRbVFt63eRFfavM0ukgFeuk/f/Nn
	XrHkPShzetbceJPiXETFePSN/uRvmr9GsH28LMqkOYEEQ0l6clRWsnlxmO42qTDlL6uqQfr6xPJ
	aJwleRJmS+sVQ1hvfPu1Q2HbejBgrW8kZtgGt4RQAiBUpivwhDSYz4sUjs+m2khUINICQIsojSz
	MUU2Kn1LilMNsolr83SmFhTxYEu0gnHSt8gpZ3Je1CTMKivpXjTbBjlOOkigzFrOWI2bC1u06iy
	7vViqXGqgO1BVMrK/la0Ezh1mBxCHLx6fF5geM+1oKHBfV
X-Google-Smtp-Source: AGHT+IEoAMG2mVaG+NEkk3ZlOYGx2UdFMICSOF0uPohRDbPIlD8LLNH2B8Z8QyGDdKqZ5YjGUOuVCw==
X-Received: by 2002:a05:6a20:7344:b0:334:88a2:d985 with SMTP id adf61e73a8af0-334a864fec8mr1996525637.54.1760647545100;
        Thu, 16 Oct 2025 13:45:45 -0700 (PDT)
Received: from ?IPV6:2a03:83e0:1151:15:6028:a61a:a132:9634? ([2620:10d:c090:500::5:e774])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a22877ebcsm3792046a12.4.2025.10.16.13.45.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Oct 2025 13:45:44 -0700 (PDT)
Message-ID: <fe0c8bb4-938f-4432-a0ff-584c7322a478@gmail.com>
Date: Thu, 16 Oct 2025 13:45:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] memcg: selftests for memcg stat kfuncs
To: Yonghong Song <yonghong.song@linux.dev>, shakeel.butt@linux.dev,
 andrii@kernel.org, ast@kernel.org, mkoutny@suse.com, yosryahmed@google.com,
 hannes@cmpxchg.org, tj@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 linux-mm@kvack.org, bpf@vger.kernel.org, kernel-team@meta.com
References: <20251015190813.80163-1-inwardvessel@gmail.com>
 <20251015190813.80163-3-inwardvessel@gmail.com>
 <f1558b5d-41be-4f56-8428-d5ae63d696ea@linux.dev>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <f1558b5d-41be-4f56-8428-d5ae63d696ea@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 59855100003
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 4fp9uy5ajsj1k6epp3hmzkta6s9kmaj8
X-HE-Tag: 1760647546-632245
X-HE-Meta: U2FsdGVkX1+LyTBM3XcU6oVkkyoZ7TYFPyJDsbJ6fUIQymGVOF8VrKeoWLRQhnVtcU76V/eL7UrwIUpgxvFfB2QDSmPEHocg9SFFlkuKL0Sm6cRDim6wVs94V9Iu9oWAUj9mUzt+ZP2EgnarN9uK0AY3HqtvU4q84N5qXK6SBqvodzayseqrqLj6kcT+q1TDlAYgt1pid6Kz2b3TSG3xZuPoR4UgsffVb1u/MzRpmKgh+cV5tIX2x8bXQXfGe/PAYLTKmym/z/nDKsEFahP++Yd+5jiN5muimOGIxhAPDQEshlsy65CbdyvH6XdKsStQRYLtSu3mX932KS5/ppudJzw/A9AQ313K3t13BvYSHQO66Or+TSiZbK0f+UzH6HoZYWKHNlwPITX83siSM/1I4USE+aJHSDNTpi1I3VRUmPj5NvFX0xNaWZycFEd3iWYW7CPDcce9USB6fzPNSGgJdqM5sVXOYzkDXHQQ0iRRPedyxOlX9duvv2kAFMlPqs/FsTvZ9G7opTgUEb1P1ZhIzUPDtZhz/+a81NME64nN3FnqEq8gF8lznHsx9X1F1oOijPvdF3yas1pKR57lipuCrIY0Xd3F3S5TMeGPClkmX1noAXE2nQMpPy9I1T3EZvbhvrcfatGyn4cMSFrBsqO0x+inuSJ5kUCrhMJcFvVOt0PQIA1v7OacoIlX+IBwlmOijVSMNuSkpS4DYRlOgbCshYECJEy2e2VzdxXJNr59m/WJwW7FOP8lKJ6TxOMELBIh9LXrqqKQTb4Oazwryw2lSgg/yupbfdMfPWPeLm0ZPo9eRMnWtew+FQllhb4v8XyEkllLL8vNbFVD5ls6W1Y4yAlzwCoTgATpapQ7bEvYzXujpQLRF9V9zopLHGFOHtCwgReUSYhQE2mzytHK0uth4qD09oLP5Ag5izsIj5MqPuZA/9y94HG2odBER6MjygNTu6yJnpz4/cABK5Fm54l
 TrRhRah9
 ZwzJBfnvNhl/VFfdFMFn0WU7hhKycJrLOgdaP6AWRukIsq9WY0aVn5uZa6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/15/25 10:04 PM, Yonghong Song wrote:
> 
> 
> On 10/15/25 12:08 PM, JP Kobryn wrote:
>> Add test coverage for the kfuncs that fetch memcg stats. Using some 
>> common
>> stats, test before and after scenarios ensuring that the given stat
>> increases by some arbitrary amount. The stats selected cover the three
>> categories represented by the enums: node_stat_item, memcg_stat_item,
>> vm_event_item.
>>
>> Since only a subset of all stats are queried, use a static struct made up
>> of fields for each stat. Write to the struct with the fetched values when
>> the bpf program is invoked and read the fields in the user mode 
>> program for
>> verification.
>>
>> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>
>> ---
>>   .../testing/selftests/bpf/cgroup_iter_memcg.h |  18 ++
>>   .../bpf/prog_tests/cgroup_iter_memcg.c        | 295 ++++++++++++++++++
>>   .../selftests/bpf/progs/cgroup_iter_memcg.c   |  61 ++++
>>   3 files changed, 374 insertions(+)
>>   create mode 100644 tools/testing/selftests/bpf/cgroup_iter_memcg.h
>>   create mode 100644 tools/testing/selftests/bpf/prog_tests/ 
>> cgroup_iter_memcg.c
>>   create mode 100644 tools/testing/selftests/bpf/progs/ 
>> cgroup_iter_memcg.c
>>
>> diff --git a/tools/testing/selftests/bpf/cgroup_iter_memcg.h b/tools/ 
>> testing/selftests/bpf/cgroup_iter_memcg.h
>> new file mode 100644
>> index 000000000000..5f4c6502d9f1
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/cgroup_iter_memcg.h
>> @@ -0,0 +1,18 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
>> +#ifndef __CGROUP_ITER_MEMCG_H
>> +#define __CGROUP_ITER_MEMCG_H
>> +
>> +struct memcg_query {
>> +    /* some node_stat_item's */
>> +    long nr_anon_mapped;
>> +    long nr_shmem;
>> +    long nr_file_pages;
>> +    long nr_file_mapped;
>> +    /* some memcg_stat_item */
>> +    long memcg_kmem;
>> +    /* some vm_event_item */
>> +    long pgfault;
>> +};
>> +
>> +#endif /* __CGROUP_ITER_MEMCG_H */
>> diff --git a/tools/testing/selftests/bpf/prog_tests/ 
>> cgroup_iter_memcg.c b/tools/testing/selftests/bpf/prog_tests/ 
>> cgroup_iter_memcg.c
>> new file mode 100644
>> index 000000000000..264dc3c9ec30
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/prog_tests/cgroup_iter_memcg.c
>> @@ -0,0 +1,295 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
>> +#include <test_progs.h>
>> +#include <bpf/libbpf.h>
>> +#include <bpf/btf.h>
>> +#include <fcntl.h>
>> +#include <sys/mman.h>
>> +#include <unistd.h>
>> +#include "cgroup_helpers.h"
>> +#include "cgroup_iter_memcg.h"
>> +#include "cgroup_iter_memcg.skel.h"
>> +
>> +int read_stats(struct bpf_link *link)
> 
> static int read_stats(...)
> 
>> +{
>> +    int fd, ret = 0;
>> +    ssize_t bytes;
>> +
>> +    fd = bpf_iter_create(bpf_link__fd(link));
>> +    if (!ASSERT_OK_FD(fd, "bpf_iter_create"))
>> +        return 1;
>> +
>> +    /*
>> +     * Invoke iter program by reading from its fd. We're not 
>> expecting any
>> +     * data to be written by the bpf program so the result should be 
>> zero.
>> +     * Results will be read directly through the custom data section
>> +     * accessible through skel->data_query.memcg_query.
>> +     */
>> +    bytes = read(fd, NULL, 0);
>> +    if (!ASSERT_EQ(bytes, 0, "read fd"))
>> +        ret = 1;
>> +
>> +    close(fd);
>> +    return ret;
>> +}
>> +
>> +static void test_anon(struct bpf_link *link,
>> +        struct memcg_query *memcg_query)
> 
> Alignment between arguments? Actually two arguments can be in the same 
> line.

Thanks. I was using a limit of 75 chars but will increase to 100 where
applicable.

[...]
>> +{
>> +    int fds[2];
>> +    int err;
>> +    ssize_t bytes;
>> +    size_t len;
>> +    char *buf;
>> +    long val;
>> +
>> +    len = sysconf(_SC_PAGESIZE) * 1024;
>> +
>> +    if (!ASSERT_OK(read_stats(link), "read stats"))
>> +        return;
>> +
>> +    val = memcg_query->memcg_kmem;
>> +    if (!ASSERT_GE(val, 0, "initial kmem val"))
>> +        return;
>> +
>> +    err = pipe2(fds, O_NONBLOCK);
>> +    if (!ASSERT_OK(err, "pipe"))
>> +        return;
>> +
>> +    buf = malloc(len);
> 
> buf could be NULL?

Thanks. I'll add the check unless this test is simplified and a buffer
is not needed for v3.

[...]
>> +
>> +    skel = cgroup_iter_memcg__open();
>> +    if (!ASSERT_OK_PTR(skel, "cgroup_iter_memcg__open"))
>> +        goto cleanup_cgroup_fd;
>> +
>> +    err = cgroup_iter_memcg__load(skel);
>> +    if (!ASSERT_OK(err, "cgroup_iter_memcg__load"))
>> +        goto cleanup_skel;
> 
> The above two can be combined with cgroup_iter_memcg__open_and_load().

I'll do that in v3.

> 
>> +
>> +    DECLARE_LIBBPF_OPTS(bpf_iter_attach_opts, opts);
>> +    union bpf_iter_link_info linfo = {
>> +        .cgroup.cgroup_fd = cgroup_fd,
>> +        .cgroup.order = BPF_CGROUP_ITER_SELF_ONLY,
>> +    };
>> +    opts.link_info = &linfo;
>> +    opts.link_info_len = sizeof(linfo);
>> +
>> +    link = bpf_program__attach_iter(skel->progs.cgroup_memcg_query, 
>> &opts);
>> +    if (!ASSERT_OK_PTR(link, "bpf_program__attach_iter"))
>> +        goto cleanup_cgroup_fd;
> 
> goto cleanup_skel;

Good catch.

> 
>> +
>> +    if (test__start_subtest("cgroup_iter_memcg__anon"))
>> +        test_anon(link, &skel->data_query->memcg_query);
>> +    if (test__start_subtest("cgroup_iter_memcg__shmem"))
>> +        test_shmem(link, &skel->data_query->memcg_query);
>> +    if (test__start_subtest("cgroup_iter_memcg__file"))
>> +        test_file(link, &skel->data_query->memcg_query);
>> +    if (test__start_subtest("cgroup_iter_memcg__kmem"))
>> +        test_kmem(link, &skel->data_query->memcg_query);
>> +    if (test__start_subtest("cgroup_iter_memcg__pgfault"))
>> +        test_pgfault(link, &skel->data_query->memcg_query);
>> +
>> +    bpf_link__destroy(link);
>> +cleanup_skel:
>> +    cgroup_iter_memcg__destroy(skel);
>> +cleanup_cgroup_fd:
>> +    close(cgroup_fd);
>> +    cleanup_cgroup_environment();
>> +}
>> diff --git a/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c b/ 
>> tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
>> new file mode 100644
>> index 000000000000..0d913d72b68d
>> --- /dev/null
>> +++ b/tools/testing/selftests/bpf/progs/cgroup_iter_memcg.c
>> @@ -0,0 +1,61 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/* Copyright (c) 2025 Meta Platforms, Inc. and affiliates. */
>> +#include <vmlinux.h>
>> +#include <bpf/bpf_core_read.h>
>> +#include "cgroup_iter_memcg.h"
>> +
>> +char _license[] SEC("license") = "GPL";
>> +
>> +extern void memcg_flush_stats(struct cgroup *cgrp) __ksym;
>> +extern unsigned long memcg_stat_fetch(struct cgroup *cgrp,
>> +        enum memcg_stat_item item) __ksym;
>> +extern unsigned long memcg_node_stat_fetch(struct cgroup *cgrp,
>> +        enum node_stat_item item) __ksym;
>> +extern unsigned long memcg_vm_event_fetch(struct cgroup *cgrp,
>> +        enum vm_event_item item) __ksym;
> 
> The above four extern functions are not needed. They should be included
> in vmlinux.h if the latest pahole version (1.30) is used.

Thanks, was not aware of that. Will remove.

> 
>> +
>> +/* The latest values read are stored here. */
>> +struct memcg_query memcg_query SEC(".data.query");
>> +
>> +/*
>> + * Helpers for fetching any of the three different types of memcg stats.
>> + * BPF core macros are used to ensure an enumerator is present in the 
>> given
>> + * kernel. Falling back on -1 indicates its absence.
>> + */
>> +#define node_stat_fetch_if_exists(cgrp, item) \
>> +    bpf_core_enum_value_exists(enum node_stat_item, item) ? \
>> +        memcg_node_stat_fetch((cgrp), bpf_core_enum_value( \
>> +                     enum node_stat_item, item)) : -1
>> +
>> +#define memcg_stat_fetch_if_exists(cgrp, item) \
>> +    bpf_core_enum_value_exists(enum memcg_stat_item, item) ? \
>> +        memcg_node_stat_fetch((cgrp), bpf_core_enum_value( \
>> +                     enum memcg_stat_item, item)) : -1
>> +
>> +#define vm_event_fetch_if_exists(cgrp, item) \
>> +    bpf_core_enum_value_exists(enum vm_event_item, item) ? \
>> +        memcg_vm_event_fetch((cgrp), bpf_core_enum_value( \
>> +                     enum vm_event_item, item)) : -1
>> +
>> +SEC("iter.s/cgroup")
>> +int cgroup_memcg_query(struct bpf_iter__cgroup *ctx)
>> +{
>> +    struct cgroup *cgrp = ctx->cgroup;
>> +
>> +    if (!cgrp)
>> +        return 1;
>> +
>> +    memcg_flush_stats(cgrp);
>> +
>> +    memcg_query.nr_anon_mapped = node_stat_fetch_if_exists(cgrp,
>> +            NR_ANON_MAPPED);
>> +    memcg_query.nr_shmem = node_stat_fetch_if_exists(cgrp, NR_SHMEM);
>> +    memcg_query.nr_file_pages = node_stat_fetch_if_exists(cgrp,
>> +            NR_FILE_PAGES);
>> +    memcg_query.nr_file_mapped = node_stat_fetch_if_exists(cgrp,
>> +            NR_FILE_MAPPED);
>> +    memcg_query.memcg_kmem = memcg_stat_fetch_if_exists(cgrp, 
>> MEMCG_KMEM);
>> +    memcg_query.pgfault = vm_event_fetch_if_exists(cgrp, PGFAULT);
> 
> There is a type mismatch:
> 
> +struct memcg_query {
> +    /* some node_stat_item's */
> +    long nr_anon_mapped;
> +    long nr_shmem;
> +    long nr_file_pages;
> +    long nr_file_mapped;
> +    /* some memcg_stat_item */
> +    long memcg_kmem;
> +    /* some vm_event_item */
> +    long pgfault;
> +};
> 
> memcg_query.nr_anon_mapped is long, but node_stat_fetch_if_exists
> (...) return value type is unsigned long. It would be good if two
> types are the same.

Good call, will do.

