Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72299C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:23:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8255C6B008C; Fri, 11 Sep 2026 04:23:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D7706B0093; Fri, 11 Sep 2026 04:23:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C61E6B0095; Fri, 11 Sep 2026 04:23:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 49A0A6B008C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:23:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A02468013B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:23:03 +0000 (UTC)
X-FDA: 85200791046.11.CF8D047
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id F0D79C0003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:23:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789114981;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G6vZ0wn72s2wifUhSDQUkE+NFerw1ACpoIcRIViUPJU=;
	b=WX9+ODKdiiQRbrDKokdpj8qUcshgsxPFjRe/2ZGPoYtfWmrgzKCYKnPLVzRPPld7K8Q/xD
	TodpVWH0KuWyCzLQDNDH46BZC1ISBZfPGZGVMugSQn8CwYZEQ9awFzTVcUkkZ8zUtDI0xC
	TJPNRAbfh+Y1GKAvm0cpWLoz5qv4BpU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789114981;
	b=cSeFguHTuhLykZ58AdDIsfwRiw6A8/oelfSu4jntTuq3MOUPyXHoftqaVPC53GZy/kxnhr
	rq27oFuT0Dkqw49sfG0Pt3jwWOaQr4wVi68JU3q1ZgVfIf2LBbjiGdlNwsQ3mlwjCAvrJF
	o3E8wfMTJi+CzA5/PcsHOp0+0TqsT6k=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4hh6xC4KX9z5B0p0;
	Fri, 11 Sep 2026 16:22:55 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl2.zte.com.cn with SMTP id 68B8MeHY053487;
	Fri, 11 Sep 2026 16:22:40 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp05[null])
	by mapi (Zmail) with MAPI id mid32;
	Fri, 11 Sep 2026 16:22:42 +0800 (CST)
X-Zmail-TransId: 2afc6aa3ba52b0e-b6afd
X-Mailer: Zmail v1.0
Message-ID: <20260911162242418ODBbr9wspxxIXDS8uvpeZ@zte.com.cn>
In-Reply-To: <20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn>
References: 20260911160421076_KNXun8Mpp9Xj7fxHG0i7@zte.com.cn,20260911161333316ISAQaj9yJhmglKT5A9OnK@zte.com.cn
Date: Fri, 11 Sep 2026 16:22:42 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <xu.xin16@zte.com.cn>
Cc: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>
Subject: =?UTF-8?B?VGVzdCBDYXNlIENvZGUgUmU6IFtQQVRDSCA0LzRdIG1tL2tzbTogYWRkIGZpbmRfbWVyZ2VhYmxlX3ZtYV9sb2NrZWQoKSB0byB1c2UgcGVyLVZNQSBsb2NraW5n?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 68B8MeHY053487
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Fri, 11 Sep 2026 16:22:55 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6AA3BA5F.000/4hh6xC4KX9z5B0p0
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F0D79C0003
X-Stat-Signature: 9p5bxdkboephhkrdbg1dyakzdrdhdxam
X-HE-Tag: 1789114980-473148
X-HE-Meta: U2FsdGVkX1/25PSa3KfvFwh2X2zM7w1e2ihfbZ40TYENQB4hMAQjP3ltsbP4CvBY0l7JMRfwe/C0zm7d3G3SyxlGAjBSEZ8qmZjdFyATfs0v9Z/oyRG+DvSflN05dc1z1T5peOLsHt8beMcB0GQXClgvqrSeRfK8VwuVuhIp+MyvPdpQ/Uenrx3nWbJmuWOY1papX0qMcG5lmhxvFL8RneX2ZhNN9lDTjunRzvFdphBIGTjcjCejm9+aW5lDpykOGRBF4bAOzLgOrCD2YXjbwlTj3/35H/EA/MMRAN1R+1EdAzgKEgAacYAZ+zQUeHAZKlf9FGeKj74BXkDjlK8jq20Mu+I5XYlUzPh0mYe4a3A/1uJd9VjBBZLJVZPER7SOM/Mnmo6gupDwMRuLg071EPwYDAUHkNb+9ckqblled0+DurfhMlcSaLcqr+aOaK8nX2/S6FqnosV5q6aduHoC4yEB3uySxO8MNfXYMF/8Cg5hYnuf7GUh1salKeK/IJaA9xs4wJ7xUVibixf3jciqlqV2xrwiNaw0nRiUA7NoBo1l+TtllEWHDinzDRhF5KwsS+y7vYXBtZE0HDXygzqCPox940CF7Wk1u0esnmyk5GC3XE7bF8zE3g9GSDymNw1hteFxJhxqG8UMQZ5B30V0RQ3N/a1RKWr9PrMCP7Q2aTuPhBZYbzt9CqUB1Pp5bYH2cgI47ABPAKGG25p1Dz81gIcjVfOveRTEiaPEZ3CCIXleIqm9ytdTnYQOj2BKmJNvnhS7DYa3PfuvDfNhjjxStfJGgBd3G3ejAopEaABhj4NLYSVtQn1AAkLfuO60TmrWZ6axItyeoLlz6WCpSG9Nmvtt4+snPNSIhfwZbthxSf9pgq6OTOuuRe4mXD6xG8nep5PF7QFIqn+VwIsgow/9dfwTpykit4UGqCwuJeWgE9b8VKNqrJI9QCerswi0veMY/BxRrzZY/6ZGHm0FtUm
 r4OqWlnP
 YnHOWtIWXadglxYcbnwddl9jsyiHa1AxgWhVrSzVJUnIraInHQ/uuEodEPLh4RC4lXu0+rv3wE77fdw4ZIU2CmMS8uvr6ZGXoh73uw7wRWEKa4jqLVP7sviS04uCclRM2svay86amPBfSwQnYd94SEyBJVDt39bFyJdspfEubfPbsJ5ErJNypT6ODcGon5HNDnt4K26GmECFY1eA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

/*
 * ksm_merge_latency.c - Measure KSM victim merge latency under
 *                       mmap_lock contention from churner threads
 *                       in the SAME process.
 *
 * Build:  gcc -O2 -pthread -o ksm_merge_latency ksm_merge_latency.c
 * Run:    sudo ./ksm_merge_latency [nr_churners]   (default: 4)
 *
 * The victim region and the churner threads share one mm_struct, hence
 * one mmap_lock.  ksmd must scan this mm to merge the victim; on a
 * baseline kernel that requires mmap_read_lock(mm), which contends with
 * the churners' mmap()/munmap() write-side mmap_lock.  On a kernel with
 * per-VMA locking in mm/ksm.c, ksmd only takes a per-VMA read lock on
 * the victim VMA, which the churners never touch, so the contention
 * disappears.
 */
#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <time.h>
#include <pthread.h>
#include <sys/mman.h>

#define PAGE_SIZE      4096UL
#define VICTIM_SIZE    (32UL * 1024 * 1024)     /* 32 MiB              */
#define UNIQUE_PAGES   2048                     /* distinct contents    */
#define DUPLICATES     4                        /* copies per content   */
#define CHURN_SIZE     (256UL * 1024 * 1024)    /* 256 MiB churn region */
#define TIMEOUT_SEC    180
#define POLL_INTERVAL  200000                   /* 200 ms               */
#define STABLE_TICKS   5                        /* 1 sec of stability   */
#define MAX_CHURNERS   64

static volatile int stop_churn = 0;

static long sysfs_read_long(const char *path)
{
    char buf[64];
    int fd = open(path, O_RDONLY);
    ssize_t n;

    if (fd < 0)
        return -1;
    n = read(fd, buf, sizeof(buf) - 1);
    close(fd);
    if (n <= 0)
        return -1;
    buf[n] = '\0';
    return atol(buf);
}

static void sysfs_write_str(const char *path, const char *val)
{
    int fd = open(path, O_WRONLY);
    if (fd < 0) {
        fprintf(stderr, "open %s: %s\n", path, strerror(errno));
        exit(1);
    }
    if (write(fd, val, strlen(val)) < 0) {
        fprintf(stderr, "write %s: %s\n", path, strerror(errno));
        close(fd);
        exit(1);
    }
    close(fd);
}

static double monotonic_sec(void)
{
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

/*
 * Churner thread: repeatedly mmap()/munmap() a large anonymous region.
 * Each iteration takes mmap_lock in write mode on the shared mm_struct.
 * This is what creates contention with ksmd's mmap_read_lock on the
 * baseline kernel.
 */
static void *churn_thread(void *arg)
{
    (void)arg;
    while (!stop_churn) {
        void *p = mmap(NULL, CHURN_SIZE, PROT_READ | PROT_WRITE,
                       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
        if (p == MAP_FAILED)
            continue;
        *(volatile char *)p = 1;   /* fault in first page */
        munmap(p, CHURN_SIZE);
    }
    return NULL;
}

static void ksm_prepare(void)
{
    sysfs_write_str("/sys/kernel/mm/ksm/run", "0");
    sysfs_write_str("/sys/kernel/mm/ksm/run", "2");   /* unmerge + reset */
    sysfs_write_str("/sys/kernel/mm/ksm/pages_to_scan", "100000");
    sysfs_write_str("/sys/kernel/mm/ksm/sleep_millisecs", "0");
}

/*
 * Allocate and register the victim region in the CURRENT process.
 * Must be called from the main thread before starting ksmd.
 */
static void *setup_victim(void)
{
    size_t npages = VICTIM_SIZE / PAGE_SIZE;
    unsigned char *p;
    size_t i;
    int j;

    p = mmap(NULL, VICTIM_SIZE, PROT_READ | PROT_WRITE,
             MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (p == MAP_FAILED) {
        perror("victim mmap");
        exit(1);
    }

    /*
     * Fill with UNIQUE_PAGES distinct patterns, each repeated DUPLICATES
     * times.  KSM will eventually collapse each group of DUPLICATES
     * identical pages into a single shared page.
     */
    for (i = 0; i < npages; i++) {
        unsigned int idx = (unsigned int)(i % UNIQUE_PAGES);
        unsigned int *page = (unsigned int *)(p + i * PAGE_SIZE);
        for (j = 0; j < (int)(PAGE_SIZE / sizeof(unsigned int)); j++)
            page[j] = idx * 2654435761u + (unsigned int)j;
    }

    if (madvise(p, VICTIM_SIZE, MADV_MERGEABLE) != 0) {
        perror("madvise(MADV_MERGEABLE)");
        exit(1);
    }
    return p;
}

int main(int argc, char **argv)
{
    int n_churn = (argc > 1) ? atoi(argv[1]) : 4;
    pthread_t threads[MAX_CHURNERS];
    long baseline_shared, baseline_scans;
    long cur_shared, cur_scans;
    double t_start, t_end;
    void *victim;
    long last = -1;
    int  stable = 0;
    double deadline;
    int i;

    if (n_churn < 0) n_churn = 0;
    if (n_churn > MAX_CHURNERS) n_churn = MAX_CHURNERS;

    ksm_prepare();

    /*
     * Set up the victim region while we still hold mmap_lock
     * uncontended.  It will be in the same mm as the churners.
     */
    fprintf(stderr, "setting up victim region (%lu MiB, %d unique pages)...\n",
            VICTIM_SIZE / (1024 * 1024), UNIQUE_PAGES);
    victim = setup_victim();

    fprintf(stderr, "starting %d churner thread(s) in the same process...\n",
            n_churn);
    for (i = 0; i < n_churn; i++) {
        if (pthread_create(&threads[i], NULL, churn_thread, NULL) != 0) {
            perror("pthread_create");
            exit(1);
        }
    }

    /* Give churners time to start hammering mmap_lock. */
    usleep(500 * 1000);

    baseline_shared = sysfs_read_long("/sys/kernel/mm/ksm/pages_shared");
    baseline_scans  = sysfs_read_long("/sys/kernel/mm/ksm/full_scans");
    if (baseline_shared < 0 || baseline_scans < 0) {
        fprintf(stderr, "cannot read KSM counters (run as root?)\n");
        return 1;
    }
    fprintf(stderr, "baseline: pages_shared=%ld full_scans=%ld\n",
            baseline_shared, baseline_scans);

    /* Start ksmd and mark t_start. */
    fprintf(stderr, "starting ksmd...\n");
    t_start = monotonic_sec();
    sysfs_write_str("/sys/kernel/mm/ksm/run", "1");

    /*
     * Wait until the victim's pages are merged: require at least two
     * full ksmd scans (to confirm the pages are stable) and then require
     * pages_shared to be unchanged for STABLE_TICKS * POLL_INTERVAL.
     */
    deadline = t_start + TIMEOUT_SEC;
    while (monotonic_sec() < deadline) {
        usleep(POLL_INTERVAL);
        cur_shared = sysfs_read_long("/sys/kernel/mm/ksm/pages_shared");
        cur_scans  = sysfs_read_long("/sys/kernel/mm/ksm/full_scans");
        if (cur_shared < 0)
            break;
        if (cur_scans - baseline_scans < 2)
            continue;
        if (cur_shared == last) {
            if (++stable >= STABLE_TICKS)
                break;
        } else {
            stable = 0;
            last = cur_shared;
        }
    }

    t_end = monotonic_sec();
    cur_shared = sysfs_read_long("/sys/kernel/mm/ksm/pages_shared");
    cur_scans  = sysfs_read_long("/sys/kernel/mm/ksm/full_scans");

    printf("=== result ===\n");
    printf("merge_time_sec : %.3f\n", t_end - t_start);
    printf("pages_shared   : %ld -> %ld (delta %ld)\n",
           baseline_shared, cur_shared, cur_shared - baseline_shared);
    printf("full_scans     : %ld -> %ld (delta %ld)\n",
           baseline_scans, cur_scans, cur_scans - baseline_scans);

    stop_churn = 1;
    for (i = 0; i < n_churn; i++)
        pthread_join(threads[i], NULL);

    munmap(victim, VICTIM_SIZE);
    return 0;
}

