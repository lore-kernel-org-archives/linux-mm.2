Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46DB6EB28D5
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 07:14:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 468CE6B0089; Fri,  6 Feb 2026 02:14:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416CE6B0093; Fri,  6 Feb 2026 02:14:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB526B00AB; Fri,  6 Feb 2026 02:14:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 16B8E6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 02:14:40 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A4AF140391
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:14:39 +0000 (UTC)
X-FDA: 84413169078.21.5466332
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.35])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4DA5D100016
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 07:14:35 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf14.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770362077;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Er9v4jx3JzX3NTNndPavABeuo/f/+V7CWZ8pznvvPvk=;
	b=u48JWhN0pB/DRkVQMF7vAaiG1eSpH2QeuvkaT/yq7XoB64GwGqF6Z8QjN5wEOpG3JAPqTd
	AEN4fIJNOCFUGldtln55ecBKSYsGah87gBGttUlo00/IR+FlhNXv0sQfy03Yza5wYYskSN
	M0g93dt18gkzRXwSgeQd0WAPNr2on1Q=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf14.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.35 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770362077; a=rsa-sha256;
	cv=none;
	b=L1tkAa/KHOSJKZbOpl0gOhQJU3Qxaduj+ROYENBAuEnSA1r+xZ11btktMKcBb+Imob9oh1
	UFzHc1FIWWVHgJ20RMIcy0C38WnarnScw/KnyL4FvBIbYUi5UtctqAVPjq3G9njGYEODfv
	uOCgS4cS642Ls7Ng/XEAG2h5WOBgt38=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4f6lhP6mG2z8Xs3G;
	Fri, 06 Feb 2026 15:14:29 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 6167EMZ4079486;
	Fri, 6 Feb 2026 15:14:22 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 6 Feb 2026 15:14:24 +0800 (CST)
X-Zmail-TransId: 2afa698594d0ff6-fd440
X-Mailer: Zmail v1.0
Message-ID: <20260206151424734QIyWL_pA-1QeJPbJlUxsO@zte.com.cn>
In-Reply-To: <ba03780a-fd65-4a03-97de-bc0905106260@kernel.org>
References: 20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn,ba03780a-fd65-4a03-97de-bc0905106260@kernel.org
Date: Fri, 6 Feb 2026 15:14:24 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <chengming.zhou@linux.dev>,
        <hughd@google.com>, <wang.yaxin@zte.com.cn>, <yang.yang29@zte.com.cn>,
        <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: =?UTF-8?B?W1JlcHJvZHVjZXJdOiBbUEFUQ0ggMi8yXSBrc206IE9wdGltaXplIHJtYXBfd2Fsa19rc20gYnkgcGFzc2luZyBhIHN1aXRhYmxlIGFkZHJlc3MgcmFuZ2U=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 6167EMZ4079486
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Fri, 06 Feb 2026 15:14:29 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 698594D5.000/4f6lhP6mG2z8Xs3G
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4DA5D100016
X-Stat-Signature: pqf8cbdykofkg3e15gtkyg9djocdd73a
X-Rspam-User: 
X-HE-Tag: 1770362075-189376
X-HE-Meta: U2FsdGVkX18uMDSrU5lnCD6jqyREQLallacXJhuFdujb0Crfqb4MreYLFC8sxosYtLRy+9gH3+AAsoMfX0cWjowV/hm3l0zf38/Zyu0MXg92/6jXTMaPqajqsaOG0w3YVIx6JdF2DFQyA2WvnUMZlGDfqgE802sMrPM0twxX5pzIzwoUG+qLGn1pGm3GcsHqM5yk8yIxr0zhQ/2XGMRDkC13fJuqGbaNCS9idI+m+ekX93zBT09jUucpSpw+VD9FPRot4Vx/GYqlWRv7L3EuQJRQyDc9fyqdpONMmGrq5cY591l4JittsZQXZ++8VLWubGq6QtrIYnolDDBqv0d588ptG33xuBNMD87a79yGvJNvAGNnj/VNcLER/M1rRQeR9yEUIHx12A72VjaDy0GmnkcLxC1m9/M5wO2lysmZTLLkwLuUNJWt56PvoW2vAWBZuALBgbiZ6tg1Rwde79bkfWCkvPXdQlY7TDYWsFIPW4AW2H2AQ8ZGEQ7JrveQzTBiuB52NLIsviubCJ+JuagqsYZJs5HNvpDaoETNMmHPs6BKCUkcvEyivon4Njt0KkZIlA5MTJlAbmrhJpCyVW8uBnJFIRST46ej9plCZ6v5UUQjj55obVAE9g5VgfG9B1gtLxjKk9VqSyEXU4xXRap8ROgPUJ39vvMiRuGq3CpG2VCbSb/sQbfBQ1F24Y2wXVNPri1EGILyDXsMpKrRM9rdwvceXTQNprZlk2c+4qQSLQu6qbawMlJxPx58d4ElfjiB4Ioxam4B+l0KTY7dZ2lqc8kqFpma4+qVlV2kzPlwHkscL51THEzhB952IciKxvaWYzqq3dGfTd/42ouE7SSACy9LzAdR8binvby8cyrVuSTC5mPCsorX/ukHxUqrCKwaLoVZ0O5PNYWxqfB28aZg7P+8BEZC0LnH7HFxR41LDQxZImbZYZqKi3vPEgx5TB4VyoVknaeiuIKsweBM1F4
 a5qQ3gFg
 8Ca9gzzJbZtr5dchwjy/utxSYuCYHofTglMIOjMWmZgI5601PIvvAhPMPxbCBq9xAGv1P8+OfmF15NTGh2KbxqHLxKVLqhiNBkX1DRVKNK85BInASMtoru+SFmQn/TBPwKBayDGa6kc7F5WBoS5suYrnMccJXczRSQv+66hxTG2tixkTGZ18l9PLINqY0Oz8s55SkxzGzuo8UrpfDcRgf2HZIvfMG2egv9MgsViRZDIwleDCsmIceTBOlzguwAwKfTbVx9jLfE1dlwmVEzWY1pydZQU9E1Ud3Ffr2Vva3DAOYna4/a9uBFwVRe9HH0EtgkQBWbkZQypHllXuOHDF8zCyJFdqf9grOx6gTzXyK/76ToVI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

This is a simple demo reproducer for the high delay of rmap_walk_ksm which uses mprotect()
to split so many VMAs from a large VMA, and these VMA shares the same anon_vma.

Reproducing steps:

On a Linux machine with 1GB or 4GB memory， doing as follows：

1 Compile: 
			gcc test_ksm_rmap.c -o test_ksm_rmap -lpthread
			
2 Configure Swap Space, for example we use CONFIG_ZRAM=y:
			echo 300M > /sys/block/zram0/disksize;
			mkswap /dev/zram0;
			swapon /dev/zram0;
			echo 150 > /proc/sys/vm/swappiness;
			
3 Running this test program:
			./test_ksm_rmap

4 There are two ways to monitor the rmap_walk_ksm delay.
   1) Before running test program (./test_ksm_rmap), you can use Ftrace's function_graph to monitor.
   
   2) you can apply a monitoring sample patch at the end. You can acquire the following data by:
	    "cat /proc/rmap_walk/delay_max"
   

/*
 * KSM rmap_walk delay reproducer.
 *
 * The main idea is to make KSM pages scanned by kswapped or kcompactd
 * or swapped by kswapd. So do the following steps:
 *
 * 1) Alloc some same-content pages and trigger ksmd to merge them
 * 2) Create another thread and alloc memory gradually to increase memory
 *    pressure.
 * 3) Wait 1 mintutes at maximum.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <pthread.h>
#include <errno.h>
#include <time.h>
#include <signal.h>

#define PAGE_SIZE 4096
#define KSM_PAGES 50001
#define TEST_PATTERN 0xAA
#define WAIT_PRESSURE_TIME 60
#define SWAP_THRESHHOLD_KB 100
#define LOW_MEMORY_THRESH_KB (15 * 1024)

#define KSM_PATH "/sys/kernel/mm/ksm/"
#define KSM_RUN KSM_PATH "run"
#define KSM_PAGES_TO_SCAN KSM_PATH "pages_to_scan"
#define KSM_SLEEP_MILLISECONDS KSM_PATH "sleep_millisecs"
#define KSM_MAX_SHARING KSM_PATH "max_page_sharing"
#define KSM_PAGES_SHARED KSM_PATH "pages_shared"
#define KSM_PAGES_SHARING KSM_PATH "pages_sharing"

static int read_sysfs(const char *path, unsigned long *value)
{
	FILE *f = fopen(path, "r");
	if (!f) {
		perror("fopen");
		return -1;
	}
	
	if (fscanf(f, "%lu", value) != 1) {
		fclose(f);
		return -1;
	}
	
	fclose(f);
	return 0;
}

static int write_sysfs(const char *path, const char *value)
{
	FILE *f = fopen(path, "w");
	if (!f) {
		perror("fopen");
		return -1;
	}
	
	if (fprintf(f, "%s", value) < 0) {
		fclose(f);
		return -1;
	}
	
	fclose(f);
	return 0;
}

static unsigned long get_system_memory_pages()
{
	FILE *f = fopen("/proc/meminfo", "r");
	if (!f) {
		perror("fopen /proc/meminfo");
		return 0;
	}
	
	unsigned long mem_total_kb = 0;
	char line[256];
	while (fgets(line, sizeof(line), f)) {
		if (strstr(line, "MemTotal:")) {
			sscanf(line, "MemTotal: %lu kB", &mem_total_kb);
			break;
		}
	}
	
	fclose(f);
	
	return mem_total_kb / 4;
}

static int configure_ksm(void)
{
	printf("Configuring KSM parameters...\n");
	
	if (write_sysfs(KSM_RUN, "1") < 0) {
		fprintf(stderr, "Failed to start KSM\n");
		return -1;
	}

	if (write_sysfs(KSM_MAX_SHARING, "10") < 0) {
		fprintf(stderr, "Failed to set max_page_sharing\n");
	}

	if (write_sysfs(KSM_PAGES_TO_SCAN, "2000") < 0) {
		fprintf(stderr, "Failed to set pages_to_scan\n");
		return -1;
	}
	
	if (write_sysfs(KSM_SLEEP_MILLISECONDS, "10") < 0) {
		fprintf(stderr, "Failed to set sleep_millisecs\n");
		return -1;
	}
	
	printf("KSM started, scan speed increased\n");
	return 0;
}

static void **allocate_ksm_pages(size_t ksm_pages_number)
{
	printf("Allocating %zu KSM pages (%.2f MB)...\n", 
	       ksm_pages_number, (ksm_pages_number * PAGE_SIZE) / (1024.0 * 1024.0));
	
	void *ksm_region = mmap(NULL, PAGE_SIZE * ksm_pages_number, PROT_READ | PROT_WRITE,
	    	      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
	if (!ksm_region) {
		perror("mmap ksm region pages");
		return NULL;
	}
	
	if (madvise(ksm_region, PAGE_SIZE * ksm_pages_number, MADV_MERGEABLE) != 0)
		fprintf(stderr, "madvise failed: %s\n", strerror(errno));
	
	for (size_t i = 0; i < ksm_pages_number; i++) {
		memset(ksm_region + i * PAGE_SIZE, i, PAGE_SIZE);
		((char *)ksm_region)[i * PAGE_SIZE] = TEST_PATTERN;
	}
	/* Use mprotect to split many VMAs by one vma per page*/
	for (size_t i = 0; i < ksm_pages_number; i++) {
		if(i % 2 == 0){
			int ret = mprotect(ksm_region + i * PAGE_SIZE, PAGE_SIZE, PROT_READ);
			if (ret == -1) {
				printf("seq:%ld\n",i);
				perror("mprotect failed");
			}
		} 
	}

	return ksm_region;
}

static void free_ksm_pages(void *pages, size_t ksm_pages_number)
{
	if (!pages) return;
    
	munmap(pages, PAGE_SIZE * ksm_pages_number);
}

static unsigned long get_available_memory_kb()
{
	FILE *f = fopen("/proc/meminfo", "r");
	if (!f) {
		perror("fopen /proc/meminfo");
		return 0;
	}
	
	unsigned long mem_available_kb = 0;
	char line[256];
	while (fgets(line, sizeof(line), f)) {
		if (strstr(line, "MemAvailable:")) {
			sscanf(line, "MemAvailable: %lu kB", &mem_available_kb);
			break;
		}
	}
	
	fclose(f);
	return mem_available_kb;
}

/* Get swap used memory (kb) */
static unsigned long get_swap_used_memory_kb()
{
	FILE *f = fopen("/proc/meminfo", "r");
	if (!f) {
		perror("fopen /proc/meminfo when get swap");
		return 0;
	}

	unsigned long swap_free_kb = 0;
	unsigned long swap_total_kb = 0;

	char line[256];
	while (fgets(line, sizeof(line), f)) {
		if (strstr(line, "SwapTotal"))
			sscanf(line, "SwapTotal: %lu kB", &swap_total_kb);
		if (strstr(line, "SwapFree")) {
			sscanf(line, "SwapFree: %lu kB", &swap_free_kb);
			break;
		}
	}
	fclose(f);
	return (swap_total_kb - swap_free_kb);
}

typedef struct {
	size_t max_alloc_times;           
	void ***pressure_memory_ptr;
	volatile int running;
	size_t *allocated_pages;
} pressure_args_t;

static void *memory_pressure_thread(void *arg)
{
	pressure_args_t *args = (pressure_args_t *)arg;
	
	void **pressure_memory = malloc(args->max_alloc_times * sizeof(void *));
	if (!pressure_memory) {
	    perror("malloc pressure pages array");
	    return NULL;
	}
	
	size_t allocated_times = 0;
	size_t allocated_pages = 0;
	unsigned long available_memory_kb, current_swap_used;
	size_t pages_to_alloc;

	while (allocated_times < args->max_alloc_times && args->running) {
		available_memory_kb = get_available_memory_kb();

		if (available_memory_kb <= LOW_MEMORY_THRESH_KB) {
			pages_to_alloc = available_memory_kb / 4;
			printf("Now available_memory_kb (%lu) is low, allocation %zu page by page\n", available_memory_kb, pages_to_alloc);
			for (size_t i = 0; i < pages_to_alloc; i++) {
				/* If SWAP has been trggered ,then task completed! */
				if ((current_swap_used = get_swap_used_memory_kb()) > SWAP_THRESHHOLD_KB) {
					printf("Swap space %lu kbused, now pressure thread quit\n", current_swap_used);
					args->running = 0;
					break;
				} else if (allocated_times + i >= args->max_alloc_times) {
					printf("\n The index allocated_times:%ld, i:%ld excced the limit\n\n", allocated_times, i);
					args->running = 0;
					break;
				} else if (args->running == 0) {
					printf("Maybe timeout, pressure thread"
					"should quit\n");
				}
				pressure_memory[allocated_times + i] = mmap(NULL, PAGE_SIZE, PROT_READ | PROT_WRITE,
							              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
				if (args->running == 0)
					printf("Maybe timeout, pressure thread"
					"should quit\n");

				memset(pressure_memory[allocated_times + i], (allocated_times + i) % 256, PAGE_SIZE);
				if ( i % 100 == 0) {
					printf("Now available_memory_kb:%lu, Swap used kb: %lu\n",
						get_available_memory_kb(), get_swap_used_memory_kb());
					usleep(200000);
				}
			}
			allocated_times += pages_to_alloc;
			allocated_pages += pages_to_alloc;
		} else {
			/* Memeory is enough! alloc a large area */
			pages_to_alloc = (available_memory_kb - LOW_MEMORY_THRESH_KB) / 4 + 1;
			pressure_memory[allocated_times] = mmap(NULL, pages_to_alloc * PAGE_SIZE,
							    PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
			/* force the kernel to alloc physical memory */
			memset(pressure_memory[allocated_times], (allocated_times) % 256, pages_to_alloc* PAGE_SIZE);
			allocated_times++;
			allocated_pages += pages_to_alloc;
			printf("  Allocated %zu pressure pages, available memory: %lu KB\n",
				allocated_pages, available_memory_kb);
			continue;
		}	    
	    
	}
	
	printf("  Allocated %zu pressure pages, available memory: %lu KB\n",
	    	allocated_pages, available_memory_kb);
	
	*args->pressure_memory_ptr = pressure_memory;
	*args->allocated_pages = allocated_pages;
	
	printf("Memory pressure thread completed allocation, actually allocated %zu pages\n", allocated_pages);
	return NULL;
}

static int monitor_ksm_merging(unsigned long *initial_shared)
{
	printf("Waiting for KSM page merging...\n");
	
	unsigned long pages_shared = 0;
	unsigned long pages_sharing = 0;
	unsigned long last_shared = 0;
	int stable_count = 0;
	int max_wait = 60;
	
	for (int i = 0; i < max_wait; i++) {
	    if (read_sysfs(KSM_PAGES_SHARED, &pages_shared) < 0)
	    	return -1;
	
	    if (read_sysfs(KSM_PAGES_SHARING, &pages_sharing) < 0)
	    	return -1;
	    
	    printf("  Second %2d: pages_shared = %lu pages_sharing = %lu\n", i, pages_shared, pages_sharing);
	    
	    if (pages_shared == last_shared) {
	        stable_count++;
	        if (stable_count >= 2) {
	            break;
	        }
	    } else {
	        stable_count = 0;
	        last_shared = pages_shared;
	    }
	    
	    sleep(1);
	}
	
	if (initial_shared) {
	    *initial_shared = pages_shared;
	}
	
	printf("KSM merging completed, shared pages: %lu\n", pages_shared);
	return 0;
}

static int test_rmap_walk()
{
	void **ksm_pages = allocate_ksm_pages(KSM_PAGES);
	if (!ksm_pages)
		return -1;
    
	unsigned long shared_before_pressure;
	if (monitor_ksm_merging(&shared_before_pressure) < 0) {
		free_ksm_pages(ksm_pages, KSM_PAGES);
		return -1;
	}
    
	if (shared_before_pressure == 0) {
		printf("Warning: No KSM merging detected!\n");
		sleep(15);
		free_ksm_pages(ksm_pages, KSM_PAGES);
		return -1;
	}
    
	printf("\nStarting to create memory pressure to trigger swap or compact...\n");
    
	void **pressure_memory = NULL;
	size_t allocated_pressure_memory = 0;
	pressure_args_t pressure_args = {
		.max_alloc_times = 10000,
		.pressure_memory_ptr = &pressure_memory,
		.running = 1,
		.allocated_pages = &allocated_pressure_memory
	};
    
	pthread_t pressure_thread;
	if (pthread_create(&pressure_thread, NULL, 
                       memory_pressure_thread, &pressure_args) != 0) {
		perror("pthread_create");
		free_ksm_pages(ksm_pages, KSM_PAGES);
		return -1;
	}
    
	int wait_time = WAIT_PRESSURE_TIME;
	unsigned long swap_used;
	while (wait_time > 0 && pressure_args.running) {
		if ((swap_used = get_swap_used_memory_kb()) > SWAP_THRESHHOLD_KB) {
			printf("Swap space used (%lu) is > %d kb\n", swap_used, SWAP_THRESHHOLD_KB);
			break;
		}
		sleep(1);
		wait_time--;
	}

	if (!wait_time)
		printf("Timeout now quit\n");
	pressure_args.running = 0;
	printf("Wait pressure_thread exit.\n");
	pthread_join(pressure_thread, NULL);

	printf("\nDone. Please check ftrace trace result to see how long rmap_walk_ksm...\n");

	return 0;
}

/* Get system memory information */
static void print_system_memory_info(void)
{
	printf("System memory information:\n");
    
	FILE *f = fopen("/proc/meminfo", "r");
	if (!f) {
		perror("fopen /proc/meminfo");
		return;
	}
    
	char line[256];
	while (fgets(line, sizeof(line), f)) {
		if (strstr(line, "MemTotal:") || 
		    strstr(line, "MemFree:") ||
		    strstr(line, "MemAvailable:") ||
		    strstr(line, "SwapTotal:") ||
		    strstr(line, "SwapFree:"))
		printf("  %s", line);
	}
    
	fclose(f);
}

/* Monitor page reclaim statistics in /proc/vmstat */
static void print_vmstat_info(void)
{
	printf("VM statistics (relevant items):\n");
    
	FILE *f = fopen("/proc/vmstat", "r");
	if (!f) {
		perror("fopen /proc/vmstat");
		return;
	}
    
	char line[256];
	while (fgets(line, sizeof(line), f)) {
	if (strstr(line, "pgscan") || strstr(line, "pgsteal") || strstr(line, "ksm")
			|| strstr(line, "swap"))
            printf("  %s", line);
    }
    
    fclose(f);
}

int main(int argc, char *argv[])
{
	printf("\n========================================\n");
	printf("KSM rmap_walk Feature Test Program\n");
	printf("========================================\n\n");
    
	if (geteuid() != 0) {
		fprintf(stderr, "Error: Root privileges required to run this test program\n");
		fprintf(stderr, "Please use: sudo %s\n", argv[0]);
		return 1;
	}
    
	print_system_memory_info();
	print_vmstat_info();
    
	if (configure_ksm() < 0)
		return 1;
    
	if (test_rmap_walk() < 0) {
		fprintf(stderr, "Test 1 failed\n");
		return 1;
	}
    
	printf("\nRestoring KSM default settings...\n");
	write_sysfs(KSM_PAGES_TO_SCAN, "100");
	write_sysfs(KSM_SLEEP_MILLISECONDS, "20");
    
	printf("\nTest completed!\n");
	return 0;
}




====================================================================
Subject: [PATCH] Sample monitoring: monitor rmap_walk_ksm() delay

This is a sample patch to monitor rmap_walk_ksm() metrics as shown at
https://lore.kernel.org/all/20260112220143497dgs9w3S7sfdTUNRbflDtb@zte.com.cn/

You can acquire the following data by:
	cat /proc/rmap_walk/delay_max

1) Time_ms: Max time for holding anon_vma lock in a single rmap_walk_ksm.
2) Nr_iteration_total: The max times of iterations in a loop of anon_vma_interval_tree_foreach
3) Skip_addr_out_of_range: The max times of skipping due to the first check (vma->vm_start
            and vma->vm_end) in a loop of anon_vma_interval_tree_foreach.
4) Skip_mm_mismatch: The max times of skipping due to the second check (rmap_item->mm == vma->vm_mm)
            in a loop of anon_vma_interval_tree_foreach.w
---
 include/linux/delayacct.h |  26 +++++++++
 kernel/delayacct.c        | 112 ++++++++++++++++++++++++++++++++++++++
 mm/ksm.c                  |  25 ++++++++-
 3 files changed, 160 insertions(+), 3 deletions(-)

diff --git a/include/linux/delayacct.h b/include/linux/delayacct.h
index ecb06f16d22c..398df73dbe75 100644
--- a/include/linux/delayacct.h
+++ b/include/linux/delayacct.h
@@ -107,6 +107,18 @@ extern void __delayacct_compact_end(void);
 extern void __delayacct_wpcopy_start(void);
 extern void __delayacct_wpcopy_end(void);
 extern void __delayacct_irq(struct task_struct *task, u32 delta);
+struct rmap_walk_call_stats {
+	u64 skip_addr_out_of_range;
+	u64 skip_mm_mismatch;
+	u64 skip_invalid_vma;
+	u64 rmap_one_false;
+	u64 done_true;
+	u64 complete_processed;
+	u64 interval_tree_total;
+};
+
+extern void __delayacct_rmap_start(u64 *start_time);
+extern void __delayacct_rmap_end(u64 start_time, struct rmap_walk_call_stats *stats);

 static inline void delayacct_tsk_init(struct task_struct *tsk)
 {
@@ -250,6 +262,16 @@ static inline void delayacct_irq(struct task_struct *task, u32 delta)
 		__delayacct_irq(task, delta);
 }

+static inline void delayacct_rmap_start(u64 *start_time)
+{
+	__delayacct_rmap_start(start_time);
+}
+
+static inline void delayacct_rmap_end(u64 start_time, struct rmap_walk_call_stats *stats)
+{
+	__delayacct_rmap_end(start_time, stats);
+}
+
 #else
 static inline void delayacct_init(void)
 {}
@@ -290,6 +312,10 @@ static inline void delayacct_wpcopy_end(void)
 {}
 static inline void delayacct_irq(struct task_struct *task, u32 delta)
 {}
+static inline void delayacct_rmap_start(u64 *start_time)
+{}
+static inline void delayacct_rmap_end(u64 start_time, struct rmap_walk_call_stats *stats)
+{}

 #endif /* CONFIG_TASK_DELAY_ACCT */

diff --git a/kernel/delayacct.c b/kernel/delayacct.c
index 2e55c493c98b..77d0f362d336 100644
--- a/kernel/delayacct.c
+++ b/kernel/delayacct.c
@@ -10,9 +10,14 @@
 #include <linux/sched/clock.h>
 #include <linux/slab.h>
 #include <linux/taskstats.h>
+#include <linux/time.h>
+#include <linux/time64.h>
 #include <linux/sysctl.h>
 #include <linux/delayacct.h>
 #include <linux/module.h>
+#include <linux/sched/debug.h>
+#include <linux/proc_fs.h>
+#include <linux/seq_file.h>

 #define UPDATE_DELAY(type) \
 do { \
@@ -29,6 +34,16 @@ DEFINE_STATIC_KEY_FALSE(delayacct_key);
 int delayacct_on __read_mostly;	/* Delay accounting turned on/off */
 struct kmem_cache *delayacct_cache;

+/* Global statistics for rmap_walk_ksm lock delay */
+static DEFINE_RAW_SPINLOCK(rmap_stats_lock);
+
+/* Maximum delay statistics */
+static u64 rmap_delay_max __read_mostly = 0;
+static struct timespec64 rmap_delay_max_ts;
+static char rmap_delay_max_comm[TASK_COMM_LEN];
+static struct rmap_walk_call_stats rmap_delay_max_stats;
+
+
 static void set_delayacct(bool enabled)
 {
 	if (enabled) {
@@ -318,3 +333,100 @@ void __delayacct_irq(struct task_struct *task, u32 delta)
 	raw_spin_unlock_irqrestore(&task->delays->lock, flags);
 }

+void __delayacct_rmap_start(u64 *start_time)
+{
+	*start_time = ktime_get_ns();
+}
+
+void __delayacct_rmap_end(u64 start_time, struct rmap_walk_call_stats *stats)
+{
+	unsigned long flags;
+	s64 ns;
+	u64 delay_ns;
+
+	if (start_time == 0)
+		return;
+
+	ns = ktime_get_ns() - start_time;
+	if (ns <= 0)
+		return;
+
+	delay_ns = (u64)ns;
+
+	raw_spin_lock_irqsave(&rmap_stats_lock, flags);
+
+	/* Update maximum delay */
+	if (delay_ns > rmap_delay_max) {
+		rmap_delay_max = delay_ns;
+		ktime_get_real_ts64(&rmap_delay_max_ts);
+		memcpy(rmap_delay_max_comm, current->comm, TASK_COMM_LEN);
+		/* Save statistics for this call that produced the max delay */
+		if (stats)
+			rmap_delay_max_stats = *stats;
+	}
+
+	raw_spin_unlock_irqrestore(&rmap_stats_lock, flags);
+}
+
+
+#ifdef CONFIG_PROC_FS
+
+/* Show maximum delay information */
+static int proc_rmap_delay_max_show(struct seq_file *m, void *v)
+{
+	unsigned long flags;
+	u64 max_delay;
+	struct timespec64 ts;
+	char comm[TASK_COMM_LEN];
+	struct rmap_walk_call_stats stats;
+	struct tm tm;
+
+	raw_spin_lock_irqsave(&rmap_stats_lock, flags);
+	max_delay = rmap_delay_max;
+	ts = rmap_delay_max_ts;
+	memcpy(comm, rmap_delay_max_comm, TASK_COMM_LEN);
+	stats = rmap_delay_max_stats;
+	raw_spin_unlock_irqrestore(&rmap_stats_lock, flags);
+
+	/* Convert timestamp to hour:minute:second format */
+	time64_to_tm(ts.tv_sec, 0, &tm);
+
+	seq_printf(m, "max_delay_ns: %llu\n", max_delay);
+	seq_printf(m, "max_delay_ms: %llu\n", max_delay / 1000000ULL);
+	seq_printf(m, "max_delay_ts: %04ld-%02d-%02d %02d:%02d:%02d\n",
+		   (long)(tm.tm_year + 1900), tm.tm_mon + 1, tm.tm_mday,
+		   tm.tm_hour, tm.tm_min, tm.tm_sec);
+	seq_printf(m, "max_delay_comm: %s\n", comm);
+	seq_printf(m, "\n");
+	seq_printf(m, "=== Statistics for the call that produced max_delay ===\n");
+	seq_printf(m, "interval_tree_total: %llu\n", stats.interval_tree_total);
+	seq_printf(m, "skip_addr_out_of_range: %llu\n", stats.skip_addr_out_of_range);
+	seq_printf(m, "skip_mm_mismatch: %llu\n", stats.skip_mm_mismatch);
+	seq_printf(m, "skip_invalid_vma: %llu\n", stats.skip_invalid_vma);
+	seq_printf(m, "rmap_one_false: %llu\n", stats.rmap_one_false);
+	seq_printf(m, "done_true: %llu\n", stats.done_true);
+	seq_printf(m, "complete_processed: %llu\n", stats.complete_processed);
+
+	return 0;
+}
+
+static struct proc_dir_entry *rmap_walk_dir;
+
+static int __init proc_rmap_stats_init(void)
+{
+	/* Create /proc/rmap_walk directory */
+	rmap_walk_dir = proc_mkdir("rmap_walk", NULL);
+	if (!rmap_walk_dir) {
+		pr_err("Failed to create /proc/rmap_walk directory\n");
+		return -ENOMEM;
+	}
+
+	/* Create proc files under /proc/rmap_walk/ */
+	proc_create_single("delay_max", 0444, rmap_walk_dir, proc_rmap_delay_max_show);
+
+	return 0;
+}
+fs_initcall(proc_rmap_stats_init);
+
+#endif /* CONFIG_PROC_FS */
+
diff --git a/mm/ksm.c b/mm/ksm.c
index 031c17e4ada6..0f45a8ea9006 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -39,6 +39,7 @@
 #include <linux/freezer.h>
 #include <linux/oom.h>
 #include <linux/numa.h>
+#include <linux/delayacct.h>
 #include <linux/pagewalk.h>

 #include <asm/tlbflush.h>
@@ -3154,6 +3155,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 	struct ksm_stable_node *stable_node;
 	struct ksm_rmap_item *rmap_item;
 	int search_new_forks = 0;
+	u64 lock_start_time = 0;

 	VM_BUG_ON_FOLIO(!folio_test_ksm(folio), folio);

@@ -3173,6 +3175,7 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		struct vm_area_struct *vma;
 		unsigned long addr;
 		pgoff_t pgoff_start, pgoff_end;
+		struct rmap_walk_call_stats call_stats = {0};

 		cond_resched();
 		if (!anon_vma_trylock_read(anon_vma)) {
@@ -3189,35 +3192,51 @@ void rmap_walk_ksm(struct folio *folio, struct rmap_walk_control *rwc)
 		pgoff_start = rmap_item->address >> PAGE_SHIFT;
 		pgoff_end = pgoff_start + folio_nr_pages(folio) - 1;

+		delayacct_rmap_start(&lock_start_time);
 		anon_vma_interval_tree_foreach(vmac, &anon_vma->rb_root,
 					       pgoff_start, pgoff_end) {

+
+			call_stats.interval_tree_total++;
 			cond_resched();
 			vma = vmac->vma;

-			if (addr < vma->vm_start || addr >= vma->vm_end)
+			if (addr < vma->vm_start || addr >= vma->vm_end) {
+				call_stats.skip_addr_out_of_range++;
 				continue;
+			}
 			/*
 			 * Initially we examine only the vma which covers this
 			 * rmap_item; but later, if there is still work to do,
 			 * we examine covering vmas in other mms: in case they
 			 * were forked from the original since ksmd passed.
 			 */
-			if ((rmap_item->mm == vma->vm_mm) == search_new_forks)
+			if ((rmap_item->mm == vma->vm_mm) == search_new_forks) {
+				call_stats.skip_mm_mismatch++;
 				continue;
+			}

-			if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg))
+			if (rwc->invalid_vma && rwc->invalid_vma(vma, rwc->arg)) {
+				call_stats.skip_invalid_vma++;
+				delayacct_rmap_end(lock_start_time, &call_stats);
 				continue;
+			}

 			if (!rwc->rmap_one(folio, vma, addr, rwc->arg)) {
+				call_stats.rmap_one_false++;
+				delayacct_rmap_end(lock_start_time, &call_stats);
 				anon_vma_unlock_read(anon_vma);
 				return;
 			}
 			if (rwc->done && rwc->done(folio)) {
+				call_stats.done_true++;
+				delayacct_rmap_end(lock_start_time, &call_stats);
 				anon_vma_unlock_read(anon_vma);
 				return;
 			}
+			call_stats.complete_processed++;
 		}
+		delayacct_rmap_end(lock_start_time, &call_stats);
 		anon_vma_unlock_read(anon_vma);
 	}
 	if (!search_new_forks++)
-- 
2.25.1

