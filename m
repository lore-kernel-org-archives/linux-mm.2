Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27C0606A326
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 06:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=j/mgew1X
Received: by kanga.kvack.org (Postfix)
	id ED0A66B0AFA; Fri, 23 Oct 2026 02:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5B9E6B0AFC; Fri, 23 Oct 2026 02:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D48FA6B0AFD; Fri, 23 Oct 2026 02:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id ABBB86B0AFA
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 02:39:19 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3B12DA01FC
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:39:19 +0000 (UTC)
X-FDA: 85352939238.24.BC7DBD9
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0A1ED2000C
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 06:39:16 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j/mgew1X";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792737557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3ePuYPfjoZ05DZ++sVmcaT0SKfKunlahFRC2mb2Sdw8=;
	b=WuXUJDCuQlyo+oe0Wrwy9E0FYh7q2B5GvpvWGTxcSxUy0w8wfSe1Rwr7YPdSUurcxehbbv
	KblsSa1eOF2qz+tlcrymZpK7KVMnvkAoMnhygdbkkMx2SK+6xuvZmPFahr+fsvhwFQ3ocx
	RU7AKEXJ3JKqigbKeIdbEZkxpidTEu8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="j/mgew1X";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792737557;
	b=lKHQbgs6SYDK67iCQ5f3uKDn387GMgih8hoXdGTilw6TaSDOJIDTDJOV3sIdEukIBmylF+
	dO9tr50jZZJ/7hHZ4VWHsQJt5tIpKRPqf+gAo4Gi8Mk+9BjdiD2XlQ1NBy+cU0pRbvAH6J
	UIM4x217KNudgvycn5KmgR8LNkGVLMU=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BB58C1691;
	Thu, 22 Oct 2026 23:39:12 -0700 (PDT)
Received: from [10.163.161.88] (unknown [10.163.161.88])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 85F7D3F7D8;
	Thu, 22 Oct 2026 23:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792737555; bh=4kiT1MFYmGQIVe9KuvZ75yR5vTBKZiDpHAYU3XDncL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j/mgew1XZ6LbIuCvZRfwJPzoZqNT16kqYq7UAs7TjV6QqXVlZoWIIBbIOVolCMHZ1
	 Hq7EPZ1wwNdbjNb/am7CD+R1qhAoyetEV7ZDskjwSLEcTaAbrmNdXFr3y/y09gboG+
	 S5eH8JjaU8du5MOTU0QqVmLelAlOy7t6PoyUV5YU=
Message-ID: <d2b8edf0-39ab-4a44-bd0d-58230dee2fad@arm.com>
Date: Fri, 23 Oct 2026 12:09:07 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: page_alloc: make defrag_mode retries follow the
 promoted order
To: Kiryl Shutsemau <kas@kernel.org>
Cc: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Harry Yoo <harry@kernel.org>,
 Usama Arif <usama.arif@linux.dev>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeel.butt@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 kernel-team@meta.com
References: <20261009125503.126202-1-kas@kernel.org>
 <15a9e03e-c748-4e51-b8cc-583a3610c897@kernel.org>
 <20261012192834.6934ef85444dee4a60d6d876@linux-foundation.org>
 <as5q14OsbK2CmOrh@thinkstation> <20261014202936.GC371161@cmpxchg.org>
 <78238103-3a7f-432c-b1df-bd14d7cf4bb1@kernel.org>
 <atDMN5MoGrwJNpAj@thinkstation>
 <4aa14b41-9b89-494c-8825-55fffd5a541c@arm.com>
 <atiCG2iPrHwDznSZ@thinkstation>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <atiCG2iPrHwDznSZ@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0A1ED2000C
X-Stat-Signature: cp1fmp1sbbxxt1p4i871d9fj8hpxwdhk
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792737556-51113
X-HE-Meta: U2FsdGVkX197z32lXwc1IbW7AKzjNNny943mKlgTv+D57X6XxzNuBqqvtPyogXPUAvSNTMIp5Ll+8mOJIiS+oGQ9SynkTYh+Xpx9xmccYDWUruyMsU97JL92JNlyam3yRcVTQwEwdyXX/M8x5/6gyJdXQrobFQIuEg5w/WKd7zmATyu2xYbc7bv0Mr46bduy5+3m43Bd1oEelPcdNq0duH+T+88ASPdUCPhGSa+w+ZfVwe86mr9FAA9siVKBynf2Zc8GeamjJcfOu1IC73YSLnfmHM9EBT9fChggGWTV+hWBrInew71dCjn2x4ia0lrQqhAa2SsIQEdDecZALcu61Fh1RKIW9icgpY8eKlZH8nXLJsDZu/K4dGNs+r89YEA6r2Pe/XBmVMrLiXZuL8jIqGnpX63Alt5OhlmMoRc0CLHXY7qKdmz/yK9ocoVTb5cz1kX/TShdHz4ps4t8UkosG3TxtZaeWDcQhS1T0Cu4MnBpaFUpWpp08Xsj1Xerr8ncXWzKfxEnnfhk87DWHZnQEm23kAi5/DMqvJIcNCB0k5af9oZda+f69nGYVfAm/ev5oETUh1CTZQPfXG7104yW/a0u9KYSEsBF2bPa56dlNx3SKUWGNuOHIMH0IqMiodNNS+dw4tzBcVbxXmF+bbhgWHpMOg0as91i6BzRLfIWVY892OYw6MIJPYVTshmbl9yViVO8lGiE/898/GfPkjvMv8B3rJX4inOtAQErN0RU/4Tsnv0nFYtOO0xJD57xHfDUGDL67TaRqNuRIhC2y/TlLraaICazTGo/2YmqGRGKl/8BdWnTwkZpOH6jdJqmMas5sVINDx1GJQzZVVV65DRHZnZPrWNUDC0qjLY7uxCCWeSvb5X8IjfivP6yZfQjn8hxx6X5xcOX2+W4ynYLiXT0OMC/ZTVEJt0J9M0xj8xtvSBNSupgUVMl2Cwjd92VEykBJ3BYzovbskSegqocioV
 AuQhEcAp
 xOYXirXeV0ST0HV6FDuFcqAJTv+rTK5O78CjIxiae3DT+/Qh1Eu7PDoF3BXVary/hwdB0c/aboLmDg0NNRQum9PBbQ/1tX4qDIYVA9skwxadEz01whU5SMFWV9pWYPKcqoDGUZY7RIcLsCvRntXXIodgzlxi4AJwnGrRdduWXZqcR2Ce4t3SqfQwBwpocnRE3fIq2IgE+suG92yMuTBVobVIMjiqTAQaIKGyhspvoJqPE9MVvmuEBMCz6Z0eJH6uZ2Rc3FWE+l0nbZbgqp8nNAFEx3doWNfdtIsXA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 21/10/26 3:03 pm, Kiryl Shutsemau wrote:
> On Mon, Oct 19, 2026 at 12:28:40PM +0530, Dev Jain wrote:
>>
>>
>> On 15/10/26 6:25 pm, Kiryl Shutsemau wrote:
>>> On Thu, Oct 15, 2026 at 09:16:36AM +0200, Vlastimil Babka (SUSE) wrote:
>>>>> And agree 7.4-rc1 with CC stable is fine. Sadly, not sure if anyone
>>>>> but Meta is using the feature right now.
>>>>
>>>> I thought it was there for a long time but it was only added in 2025 :) At
>>>> least the enterprise world is slow to adopt things, AFAICS.
>>>
>>> I was thinking to propose a patch after merge window to make defrag_mode
>>> default. Do you think it is too early? I don't think it is ever going
>>> to be truly stabilized without wider exposure.
>>
>> AFAIU defrag mode is not going to improve mTHP allocation success.
>>
>> I ran a synthetic benchmark faulting in lots of 64k mTHP with swap enabled,
>> defrag mode caused me to enter a warn_alloc (and 8 times more compact_stalls),
>> which didn't happen without defrag.
> 
> Could you share the benchmark? I would like to play with it.

Benchmark is given at the last. LLM had written it, I had verified it on
a surface level ...
> 
> Which THP defrag setting, and was the range MADV_HUGEPAGE?
> 
> With the default "madvise" and no MADV_HUGEPAGE, a 64k fault cannot
> reclaim and does not wake kswapd.
> 
> How is your system setup?

This is a VM running on an arm64 machine, memory is 7G, only 64K mTHP
enabled with madvise, number of cpus is 4 with 1 node.
/sys/kernel/mm/transparent_hugepage/defrag is madvise.
> 
>> So perhaps bundle the default with pageblock_order eagerness etc.
> 
> What do you mean by pageblock_order eagerness?

I meant, something like, if the least mTHP order enabled is the pageblock
order (so in most cases that means there is no mTHP, only PMD size
is enabled) only then make defrag mode the default.

Benchmark: (running it with time ./compact-bench 99 64 16 20 0)

#define _GNU_SOURCE

#include <errno.h>
#include <stdbool.h>
#include <pthread.h>
#include <sched.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <unistd.h>

struct vmstat_snapshot {
        unsigned long long stall;
        unsigned long long success;
        unsigned long long fail;
        unsigned long long swapout_pages;
};

struct mthp_snapshot {
        unsigned long long anon_fault_alloc;
        unsigned long long anon_fault_fallback;
};

struct khugepaged_settings {
        unsigned long long defrag;
        unsigned long long pages_to_scan;
        unsigned long long scan_sleep_millisecs;
};

struct worker {
        unsigned int cpu;
        size_t bytes;
        size_t huge_size;
        size_t page_size;
        void *mapping;
        int error;
};

static pthread_barrier_t start_barrier;
static struct khugepaged_settings saved_khugepaged;
static bool restore_khugepaged_at_exit;

static void usage(const char *program)
{
        fprintf(stderr,
                "Usage: %s [fill-pct [huge-kB [threads [allocate-pct "
                "[hold-secs]]]]]\n"
                "Defaults: fill=90 huge-kB=64 threads=online-CPUs "
                "allocate=30 hold=5\n",
                program);
}

static unsigned long parse_unsigned(const char *text, const char *name,
                                    unsigned long minimum,
                                    unsigned long maximum)
{
        char *end;
        unsigned long value;

        errno = 0;
        value = strtoul(text, &end, 0);
        if (errno || *text == '\0' || *end != '\0' ||
            value < minimum || value > maximum) {
                fprintf(stderr, "invalid %s: %s\n", name, text);
                exit(EXIT_FAILURE);
        }

        return value;
}

static unsigned long long mem_available_bytes(void)
{
        char line[256];
        unsigned long long kib;
        FILE *file = fopen("/proc/meminfo", "r");

        if (!file) {
                perror("/proc/meminfo");
                exit(EXIT_FAILURE);
        }

        while (fgets(line, sizeof(line), file)) {
                if (sscanf(line, "MemAvailable: %llu kB", &kib) == 1) {
                        fclose(file);
                        return kib * 1024;
                }
        }

        fclose(file);
        fputs("MemAvailable is missing from /proc/meminfo\n", stderr);
        exit(EXIT_FAILURE);
}

static void *map_aligned(size_t bytes, size_t alignment)
{
        uintptr_t start, aligned;
        size_t prefix, suffix;
        void *mapping;

        if (bytes > SIZE_MAX - alignment) {
                errno = ENOMEM;
                return MAP_FAILED;
        }

        mapping = mmap(NULL, bytes + alignment, PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (mapping == MAP_FAILED)
                return MAP_FAILED;

        start = (uintptr_t)mapping;
        aligned = (start + alignment - 1) & ~(alignment - 1);
        prefix = aligned - start;
        suffix = bytes + alignment - prefix - bytes;

        if (prefix)
                munmap((void *)start, prefix);
        if (suffix)
                munmap((void *)(aligned + bytes), suffix);

        return (void *)aligned;
}

static struct vmstat_snapshot read_vmstat(void)
{
        struct vmstat_snapshot result = { 0 };
        char name[128];
        unsigned long long value;
        FILE *file = fopen("/proc/vmstat", "r");

        if (!file) {
                perror("/proc/vmstat");
                exit(EXIT_FAILURE);
        }

        while (fscanf(file, "%127s %llu", name, &value) == 2) {
                if (!strcmp(name, "compact_stall"))
                        result.stall = value;
                else if (!strcmp(name, "compact_success"))
                        result.success = value;
                else if (!strcmp(name, "compact_fail"))
                        result.fail = value;
                else if (!strcmp(name, "pswpout"))
                        result.swapout_pages = value;
        }

        fclose(file);
        return result;
}

static unsigned long long read_counter(const char *path)
{
        unsigned long long value;
        FILE *file = fopen(path, "r");

        if (!file) {
                perror(path);
                exit(EXIT_FAILURE);
        }
        if (fscanf(file, "%llu", &value) != 1) {
                fprintf(stderr, "failed to read %s\n", path);
                fclose(file);
                exit(EXIT_FAILURE);
        }

        fclose(file);
        return value;
}

static bool write_counter(const char *path, unsigned long long value)
{
        FILE *file = fopen(path, "w");

        if (!file) {
                perror(path);
                return false;
        }
        if (fprintf(file, "%llu\n", value) < 0) {
                fprintf(stderr, "failed to write %s\n", path);
                fclose(file);
                return false;
        }
        if (fclose(file)) {
                fprintf(stderr, "failed to close %s\n", path);
                return false;
        }

        return true;
}

static void restore_khugepaged(void)
{
        static const char *root =
                "/sys/kernel/mm/transparent_hugepage/khugepaged";
        char path[256];

        if (!restore_khugepaged_at_exit)
                return;

        snprintf(path, sizeof(path), "%s/pages_to_scan", root);
        (void)write_counter(path, saved_khugepaged.pages_to_scan);
        snprintf(path, sizeof(path), "%s/scan_sleep_millisecs", root);
        (void)write_counter(path, saved_khugepaged.scan_sleep_millisecs);
        snprintf(path, sizeof(path), "%s/defrag", root);
        (void)write_counter(path, saved_khugepaged.defrag);
}

static void quiesce_khugepaged(void)
{
        static const char *root =
                "/sys/kernel/mm/transparent_hugepage/khugepaged";
        char defrag_path[256];
        char pages_path[256];
        char sleep_path[256];

        snprintf(defrag_path, sizeof(defrag_path), "%s/defrag", root);
        snprintf(pages_path, sizeof(pages_path), "%s/pages_to_scan", root);
        snprintf(sleep_path, sizeof(sleep_path), "%s/scan_sleep_millisecs", root);

        saved_khugepaged.defrag = read_counter(defrag_path);
        saved_khugepaged.pages_to_scan = read_counter(pages_path);
        saved_khugepaged.scan_sleep_millisecs = read_counter(sleep_path);
        restore_khugepaged_at_exit = true;
        if (atexit(restore_khugepaged)) {
                fputs("failed to register khugepaged restoration\n", stderr);
                exit(EXIT_FAILURE);
        }

        if (!write_counter(defrag_path, 0) ||
            !write_counter(pages_path, 1) ||
            !write_counter(sleep_path, 4294967295ULL))
                exit(EXIT_FAILURE);

        puts("khugepaged: defrag=0 pages_to_scan=1 "
             "scan_sleep_millisecs=4294967295");
}

static struct mthp_snapshot read_mthp_stats(unsigned long huge_kib)
{
        static const char *root = "/sys/kernel/mm/transparent_hugepage";
        struct mthp_snapshot result;
        char path[256];

        snprintf(path, sizeof(path),
                 "%s/hugepages-%lukB/stats/anon_fault_alloc", root, huge_kib);
        result.anon_fault_alloc = read_counter(path);
        snprintf(path, sizeof(path),
                 "%s/hugepages-%lukB/stats/anon_fault_fallback", root, huge_kib);
        result.anon_fault_fallback = read_counter(path);

        return result;
}

static void *fault_worker(void *argument)
{
        struct worker *worker = argument;
        cpu_set_t cpuset;
        volatile unsigned char *memory;
        size_t offset;
        int barrier_result;

        CPU_ZERO(&cpuset);
        CPU_SET(worker->cpu, &cpuset);
        (void)pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);

        worker->mapping = map_aligned(worker->bytes, worker->huge_size);
        if (worker->mapping == MAP_FAILED) {
                worker->error = errno;
        } else if (madvise(worker->mapping, worker->bytes,
                           MADV_HUGEPAGE) != 0) {
                worker->error = errno;
        }

        barrier_result = pthread_barrier_wait(&start_barrier);
        if (barrier_result != 0 && barrier_result != PTHREAD_BARRIER_SERIAL_THREAD) {
                worker->error = barrier_result;
                return NULL;
        }

        if (worker->error)
                return NULL;

        memory = worker->mapping;
        for (offset = 0; offset < worker->bytes; offset += worker->page_size)
                memory[offset] = 1;

        return NULL;
}

int main(int argc, char **argv)
{
        unsigned long fill_percent = 90;
        unsigned long huge_kib = 64;
        unsigned long thread_count;
        unsigned long allocate_percent = 30;
        unsigned long hold_seconds = 5;
        unsigned long online_cpus;
        unsigned long long available;
        struct vmstat_snapshot before, after;
        struct mthp_snapshot mthp_before, mthp_after;
        struct worker *workers;
        pthread_t *threads;
        volatile unsigned char *pressure;
        size_t pressure_bytes, target_bytes;
        size_t target_units, units_per_thread, extra_units;
        size_t huge_size, page_size, offset;
        unsigned long i;
        int error = 0;

        online_cpus = (unsigned long)sysconf(_SC_NPROCESSORS_ONLN);
        thread_count = online_cpus;

        if (argc > 6) {
                usage(argv[0]);
                return EXIT_FAILURE;
        }
        if (argc > 1)
                fill_percent = parse_unsigned(argv[1], "fill percentage", 1, 1000);
        if (argc > 2)
                huge_kib = parse_unsigned(argv[2], "huge-page size", 4, 1048576);
        if (argc > 3)
                thread_count = parse_unsigned(argv[3], "thread count", 1, 4096);
        if (argc > 4)
                allocate_percent = parse_unsigned(argv[4], "allocation percentage",
                                            1, 1000);
        if (argc > 5)
                hold_seconds = parse_unsigned(argv[5], "hold time", 0, 86400);

        page_size = (size_t)sysconf(_SC_PAGESIZE);
        huge_size = (size_t)huge_kib * 1024;
        if (huge_size < page_size || huge_size % page_size ||
            (huge_size & (huge_size - 1))) {
                fputs("huge-kB must describe a power-of-two page multiple\n", stderr);
                return EXIT_FAILURE;
        }
        quiesce_khugepaged();

        available = mem_available_bytes();
        pressure_bytes = (size_t)(available / 100 * fill_percent);
        pressure_bytes &= ~(huge_size - 1);
        if (!pressure_bytes) {
                fputs("computed pressure mapping size is zero\n", stderr);
                return EXIT_FAILURE;
        }

        printf("available=%llu MiB fill=%zu MiB huge=%zu KiB threads=%lu "
               "allocate=%lu%%\n",
               available >> 20, pressure_bytes >> 20, huge_size >> 10,
               thread_count, allocate_percent);
        printf("phase 1: faulting anonymous pressure mapping\n");
        fflush(stdout);

        pressure = map_aligned(pressure_bytes, huge_size);
        if (pressure == MAP_FAILED) {
                perror("pressure mmap");
                return EXIT_FAILURE;
        }
        for (offset = 0; offset < pressure_bytes; offset += page_size)
                pressure[offset] = 1;

        target_bytes = (size_t)(available / 100 * allocate_percent);
        target_units = target_bytes / huge_size;
        if (target_units < thread_count)
                thread_count = target_units;
        if (!thread_count) {
                fputs("not enough requested memory for one target allocation\n", stderr);
                return EXIT_FAILURE;
        }
        target_bytes = target_units * huge_size;

        workers = calloc(thread_count, sizeof(*workers));
        threads = calloc(thread_count, sizeof(*threads));
        if (!workers || !threads) {
                perror("calloc");
                return EXIT_FAILURE;
        }
        if (pthread_barrier_init(&start_barrier, NULL, thread_count + 1)) {
                perror("pthread_barrier_init");
                return EXIT_FAILURE;
        }

        units_per_thread = target_units / thread_count;
        extra_units = target_units % thread_count;
        for (i = 0; i < thread_count; i++) {
                workers[i].cpu = i % online_cpus;
                workers[i].bytes = (units_per_thread + (i < extra_units)) * huge_size;
                workers[i].huge_size = huge_size;
                workers[i].page_size = page_size;
                if (pthread_create(&threads[i], NULL, fault_worker, &workers[i])) {
                        fprintf(stderr, "pthread_create failed at thread %lu\n", i);
                        return EXIT_FAILURE;
                }
        }

        printf("phase 2: faulting %zu MiB through aligned MADV_HUGEPAGE mappings\n",
               target_bytes >> 20);
        fflush(stdout);
        before = read_vmstat();
        mthp_before = read_mthp_stats(huge_kib);
        pthread_barrier_wait(&start_barrier);
        for (i = 0; i < thread_count; i++) {
                pthread_join(threads[i], NULL);
                if (workers[i].error) {
                        fprintf(stderr, "worker %lu: %s\n", i,
                                strerror(workers[i].error));
                        error = 1;
                }
        }
        after = read_vmstat();
        mthp_after = read_mthp_stats(huge_kib);

        printf("RESULT compact_stall=%llu compact_success=%llu compact_fail=%llu "
               "swapout_pages=%llu "
               "anon_fault_alloc=%llu anon_fault_fallback=%llu\n",
               after.stall - before.stall,
               after.success - before.success,
               after.fail - before.fail,
               after.swapout_pages - before.swapout_pages,
               mthp_after.anon_fault_alloc - mthp_before.anon_fault_alloc,
               mthp_after.anon_fault_fallback -
               mthp_before.anon_fault_fallback);
        printf("holding mappings for %lu seconds\n", hold_seconds);
        fflush(stdout);
        sleep(hold_seconds);

        for (i = 0; i < thread_count; i++) {
                if (workers[i].mapping && workers[i].mapping != MAP_FAILED)
                        munmap(workers[i].mapping, workers[i].bytes);
        }
        munmap((void *)pressure, pressure_bytes);
        pthread_barrier_destroy(&start_barrier);
        free(threads);
        free(workers);

        return error ? EXIT_FAILURE : EXIT_SUCCESS;
}


