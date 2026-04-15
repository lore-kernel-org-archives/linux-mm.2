Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9D6FA0C42
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 07:28:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 093686B0092; Wed, 15 Apr 2026 03:28:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 043BE6B0093; Wed, 15 Apr 2026 03:28:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E277C6B0095; Wed, 15 Apr 2026 03:28:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFE076B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:28:43 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 972CAC1A7A
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:28:43 +0000 (UTC)
X-FDA: 84659962926.08.22D30BD
Received: from mail-dl1-f50.google.com (mail-dl1-f50.google.com [74.125.82.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id AA21740002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:28:41 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=k56lNBWP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776238121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=i3RCg8jAq8bEKU8zr1VoGVX0lX4zwfP6AXnb54K8yLQ=;
	b=novfRgCPVoWmrMSnRKXq5iatH8n1PpC74br6zJtqC6IQ5dXu4jIuknCsqKkFxdLvWNm35O
	InDhnIwS81t59MGds+NVZROdLX8qo0PTz1NbpGIGTwfo5G/aHH3QNNe/mvgUXkXpAwpuZV
	5iSmnjdcHiXPPL2bYBlGxHn4VpTB0bM=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776238121; a=rsa-sha256;
	cv=pass;
	b=X7/bTdgmYbyqPl1S4OX2vuWsqUNNXZhn9EZPCRUhFsxza0ViLThGVURzaoj3FHPAkIFrM4
	QUvjTNM5Cux49P3KgIkrsZ+UhteqF6UMeD7VE85vK+wPpuoqDHg+x6QIkpwgH1H+vrCe1r
	KKclZkOHu95lgkNynjJjztmLAOc2ksI=
ARC-Authentication-Results: i=2;
	imf12.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=k56lNBWP;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf12.hostedemail.com: domain of mingyu.he@shopee.com designates 74.125.82.50 as permitted sender) smtp.mailfrom=mingyu.he@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
Received: by mail-dl1-f50.google.com with SMTP id a92af1059eb24-12c19d23b19so7553339c88.0
        for <linux-mm@kvack.org>; Wed, 15 Apr 2026 00:28:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776238120; cv=none;
        d=google.com; s=arc-20240605;
        b=Xi3+6/Yq/A0UiXpXetOj1W8+da49KUYQtnH9O5xlB3o0lOvZ+0/savirr5Fo5FYNSf
         NoPnl2e4rlbyMHhi6HfIPFBoAeuzJ61//LGc+M7P8lMZbNngwnhrwJ3+Y6urxHRTtZ3G
         UGIsc4HlGhsoPYVwJ40Jd5g42kNENZYvGpT9aMN/fXHBK0fs0SGHbXR1VpyEur9T625s
         taVkyn3qdfJztOnAPZ0YffNgJchEfk9BIJOTC36lzAjF80SDJAMixXwIaJzIRcdxfRtB
         ANerNkWrXr4UDQ0kpTXyMaHw1/+yhXxCQ1uFekoVlOI8/oRv52/NC1ylQ14Xskft4wuy
         eu5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=i3RCg8jAq8bEKU8zr1VoGVX0lX4zwfP6AXnb54K8yLQ=;
        fh=e+gtuQz5F30+vQ0Kq5iKRLKfWA52GuiBZ4m5XW/7aB0=;
        b=aw3sb1DgeMViSjL+jfCTg48ZDOkem4QY1fHgoCdsDhoDJtaE5JYKbKsFdX56vMmPx7
         8LOHZrObEmtgQDaeafpXcHtCrCyOUg2HSvtb8VgoiJvaAVVLEy9wrC//E4R/zHvUdwsg
         mPp+hngAd/OLrPfbVjyS+/ozGwzzfnnbTsrsD0NoFp5AJ533P9kJL/Dt4vjXl4AYu+8E
         7U9X9fu4hbrKYo3n3oEwalTFf//0MKOMOY34PeYdOt/jmcyljHrZ5gaBVdadPcGwHu+s
         X5hOCoJFaOSB5s/DoBMoymvXUHq9ELBv9ZA8p7+MyGIAtjpumXTE1yScmJS1T/W5V3UI
         T24w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1776238120; x=1776842920; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=i3RCg8jAq8bEKU8zr1VoGVX0lX4zwfP6AXnb54K8yLQ=;
        b=k56lNBWPeh2S3Me+t5hMHlcvZMZs4F4jcY3k1TkLPnXGcKXRrgXkVCZhPMWGQhTInh
         9DmD9cdrwiBdl2TDd3M4iZkU5tjxo0281rhK6re+TsCKpL6zLyxh7krnvEZhx++GA3wq
         XiAn0TRXmEyRcdcg+O+gPgc8MwKibwHv/yUMsolpH/peIA+mZ3V2+xyBl8zv/EcG8GYd
         B+22H2vPscLh/fiye87vDbi3mYx3u/aUtw1Wu+1kG8XE0oKRTHFnwVz352M7KBZrxCb6
         9c94zEDogAQGzFqFPHX+0PvBKyKuwynF3BhV2bH+UIeVqE22sbKyJS1xqEFa/OEzd8KF
         tQEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776238120; x=1776842920;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=i3RCg8jAq8bEKU8zr1VoGVX0lX4zwfP6AXnb54K8yLQ=;
        b=YBct0oJqxE3FoEOa+xsSowXlqcOknvNZk5wJ8LOMvKEzFzzpjRUAj0H+ASejCJbRfH
         qaiPYlYMxGp/RmjUILTEIgCfF/wddCK6xpFoa7JLWYFJ8mt1jWoTdBGCPta7qfXo7Yt4
         gvy7Un+8wuTdFM23oNpao6nLsxqIUwHoHPbgMtORO4f5zb40QZaBDFaYqy0Fwz19157a
         0o+al9np1x0N0KkxSBvsSmHivV7fodvlCgYtjWbnHLW/xqf2aRv0kkVywdI9iGPTf3ns
         Q9wm0vQsvQyApyAdwUHt6fyZmmFjr5GVNFQSJUZcsLU8k25ajQ9qRKrbydHVBGj/lkeq
         8ggg==
X-Gm-Message-State: AOJu0YyF9XKQNLyvshLAyh70VWEVsmy71G/Yf80PwpZxMRoiKLCtqE3J
	oeDoe1tpoky3fUpy/a4A6IfvVWvOR67Hmtmo359TAJecwBPLUm6y/pBS1i06NJJIs1FW6oTeBmW
	afHAHuwLwlxXYN17w86TUOguiooXjxi4wzujithFNbjtE2aYDA/ErXgYZLbkV
X-Gm-Gg: AeBDievO5qsqmoRPLG0dJj8t2jZj3RfWhrtVhV4ilbY6q8XQHsFiaB3xz5oOTGUUJi3
	d8RIZQuQyDf16rh2WOjhXhVEFRNDp4Ik2H5ecRWNU367fC8T4q5ou46KZjVcy8bxE3bb2AtS9Uc
	wHq13CoBd9lfgOXr7LjCMCr58kOJMLCz4HsvL9VuW1iYpneZUU1vbv+8hAzDPZEqtWneHNDjkYM
	/qTbg2L0PJ7sTwxdHrdeKKSWOh7Ysfq7WHB/SOBuBITSL4JyoG+6W2tH8Y+qvRIA7o6WZX7+I+D
	P8CMUc1wajqNyobDBw==
X-Received: by 2002:a05:7022:3d12:b0:128:ceac:6da6 with SMTP id
 a92af1059eb24-12c34ee91c9mr11364895c88.30.1776238120061; Wed, 15 Apr 2026
 00:28:40 -0700 (PDT)
MIME-Version: 1.0
From: Mingyu He <mingyu.he@shopee.com>
Date: Wed, 15 Apr 2026 15:28:27 +0800
X-Gm-Features: AQROBzAm2xFwr4MALc1zssK1xrKh48KJqi6cFMhuCqu4uq6NyXdJo7D0QDgCiSQ
Message-ID: <CAAoBcuSK38z5Nh7rGuHDFwpNvtc0W49OZKc1_d1QkCbK_nL7Ew@mail.gmail.com>
Subject: [ISSUE] Read performance regression when using RWF_DONTCACHE form
 8026e49 "mm/filemap: add read support for RWF_DONTCACHE"
To: linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Cc: hannes@cmpxchg.org, clm@meta.com, linux-kernel@vger.kernel.org, 
	willy@infradead.org, kirill@shutemov.name, bfoster@redhat.com, 
	Jens Axboe <axboe@kernel.dk>, littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam12
X-Stat-Signature: j5pzat94xtr9fqr5oyzkuhufpozo9dp8
X-Rspamd-Queue-Id: AA21740002
X-Rspam-User: 
X-HE-Tag: 1776238121-662202
X-HE-Meta: U2FsdGVkX19fC3b8twITJ0rK+dhF/RPewtO9D4ITklJbKi8vQa8OOh/KkC0yo8VUGQ0kNTcgFTJS2P5BYNrqYSS2OpM/6xJC+EF3r3/+1QA5Es6Tcp4EigeCtNCbyob68ocAX6eSnrjpSofzix9Wpuc6uu4m64/Q1KkCpgFuM1kr2GzJKuq0URDgBok8d3m41TubbVbu7F46aiChonTVstESSxxq444YbnzJtwhBXZUXJukM3BtPJ+1svQTrKZ6b1tyKxRATAtT17+axR/6ycjyeEb28uonGcVJlBXjuYciIAs+uMb7qWjTg1c/Wy59K8EOfqelgnLdwgOoVP1tX0Sjf2Ob4tXpkLpB4SvXDDn9SHME6pscD4vA1X63Mtip0RYVJuwHpNGg1H5gzcmh8iiqyEDY63JKLDwvRnBtHo1pdxFBALDrfIpZEu8MjpufJVDEYRhd6diUKPgPaqPnbtupbdK3KfBUNuHP4lzb3lAQtZlQwxf0fqVrzuOjBIlDm887hFbMtNvgOManoKngSsXbm7ZYzX0kQ5gFkenrs80WLNeHyfADLQNGQU0BFAdNBBJshMPfFzHyAzx3HuwevnS/3xkX/0pnbU7WAHfVM+TS59u4h60UufV9sh3e//nCvlSkJ+AaJqAvThdQbRAMjUZovXWCMSrJ59yB2QKzF+PVS7bf2zc/p5ar9ZP9YTWftqGKDeVgHpyehRJ0SSON4YXOfSEsT1EHGu8kWIH4ojDGBpcFmpk6vJgJJh7ulT4EJmWke2VVD+I4qTDFBaIQids2B7lX87ZKwcR/Eqlj5cgzeFdaYwfTY/NEsOe89BwMFXwJD0mqHgChknTJm6rJyy2jusPNFVH2uV32lPbqrn4r/HvPm+NQTLk8JHM09RrvA1VFVffxH1ZYFw6nXcOvMLjGB2MuoiPdAIcN51tSagFNSwV6Kn8zHnewwQOv8bL4XUc+//mGLjnIG6t2n6sp
 TknZBftc
 u5W/wTjelrYxrzBG8Kf+81aqJ8g6z8cARoFH3l/PADj4xn/rde3y5H7GwYNdbQ3g2rW6+NH4fUBoTAqVjs0/4RDrPEnErPSEy1NGulNv8zJruOH9LkPbUpV7NcceFGoraiyuxOqJHF5cTvKIlc1dIXfL15fZCfSo9i/bspG8sfekrTpiTEsLAqqijnlbjEW++n5MKmlc2Ld+5/V2eJ8PMobIkhFXKvU05vjigzyaEfJ5Gn2V1w0+/GBZEuJWl+J/UNvKUhU3qX5zjM885k6vq5z4qI+mkDCXfyH9U
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

Introduction:

I found this feature quite useful because in many scenarios, files
only need to be read once and then discarded. Keeping them in the page
cache can lead to a drop in read performance during cache reclaim.
Therefore, I conducted functional tests after the official release of
v7.0.0. I found that in normal preadv2 read scenarios (write has not
been tested yet), the read performance actually has a significant
regression. I would like to discuss whether this is expected, or if my
usage or application scenario is incorrect.

Test Project:

I tested reading a 5GB file on my NVMe drive using preadv2. The file
was generated using:

dd if=/dev/random of=file_top.bin oflag=direct bs=1M count=5120

The test was conducted in two scenarios:

Running outside of any cgroup.

Running within a cgroup with limits: memory.max = 3G, memory.high = 1G.

Each scenario ran the test program once. The test program performs a
controlled experiment: the first round uses preadv2 with
RWF_DONTCACHE, and the second round does not.

Test Results:

I found that after applying RWF_DONTCACHE, the performance dropped
quite drastically. This result was consistent both inside and outside
the cgroup. During the tests, I monitored memory.stat within the
cgroup and confirmed that RWF_DONTCACHE was indeed working (the file
cache remained very small).

The smaller the buffer_size in the test program, the more the
performance dropped. Initially, I used a 4k buffer_size, and the
performance decreased significantly. When the buffer_size was
increased to 128K, the read performance with RWF_DONTCACHE actually
surpassed the non-flagged version by about 10%.

Important:

I suspect this is due to readahead. In most cases, files that are
"accessed once" are read sequentially. RWF_DONTCACHE might be dropping
these readahead pages, resulting in a failure to fully utilize data
locality. In contrast, reads without the flag do not drop these
prefetch pages, making them much faster.

Discussion:

Is there an issue with my program? Or is the test flawed? If both are
fine, is it worth further optimizing RWF_DONTCACHE in this regard? The
concept of RWF_DONTCACHE itself is very attractive, but the practical
effect in this scenario is not ideal.

Below is my test program and hardware information:

================================

CPU: Intel(R) Xeon(R) Gold 5220R CPU @ 2.20GHz (96 cores)

OS: Ubuntu 24.04

Kernel: v7.0.0 (Tested after official release)

Disk:

nvme0n1 ext4 1.7T 5G 0% 0 Dell Ent NVMe v2 AGN RI U.2 1.92TB /data


=================================

Test Results (with 4k buffer_size):

File: /data/file_top.bin (5.00 GiB)

=== Round 1: preadv2 + RWF_DONTCACHE ===

file: /data/file_top.bin

flags: RWF_DONTCACHE

page cache dropped

bytes read: 5368709120 (5.00 GiB)

time: 35068.1 ms

throughput: 146.0 MiB/s

=== Round 2: preadv2 (normal) ===

file: /data/file_top.bin

flags: (none)

page cache dropped

bytes read: 5368709120 (5.00 GiB)

time: 3428.6 ms

throughput: 1493.3 MiB/s


==============================

Test Program:

/*

test_preadv2_dontcache.c - Compare preadv2 with/without RWF_DONTCACHE

*/

#define _GNU_SOURCE

#include <stdio.h>

#include <stdlib.h>

#include <string.h>

#include <fcntl.h>

#include <unistd.h>

#include <errno.h>

#include <sys/uio.h>

#include <sys/stat.h>

#include <time.h>

#ifndef RWF_DONTCACHE

#define RWF_DONTCACHE 0x00000080

#endif

#define BUF_SIZE (4 * 1024)

#define DEFAULT_PATH "/data/file_top.bin"

static void drop_caches(void)

{

int fd;

sync();

fd = open("/proc/sys/vm/drop_caches", O_WRONLY);

if (fd < 0) exit(1);

write(fd, "3\n", 2);

close(fd);

}

static double time_diff_ms(struct timespec *start, struct timespec *end)

{

return (end->tv_sec - start->tv_sec) * 1000.0 +

(end->tv_nsec - start->tv_nsec) / 1e6;

}

static void read_file(const char *path, int flags, const char *label)

{

char *buf;

struct iovec iov;

struct timespec t_start, t_end;

ssize_t ret;

off_t offset = 0;

size_t total = 0;

int fd;

    buf = aligned_alloc(4096, BUF_SIZE);
    fd = open(path, O_RDONLY);
    iov.iov_base = buf;
    iov.iov_len = BUF_SIZE;

    drop_caches();
    clock_gettime(CLOCK_MONOTONIC, &t_start);

    while (1) {
            ret = preadv2(fd, &iov, 1, offset, flags);
            if (ret <= 0) break;
            offset += ret;
            total += ret;
    }

    clock_gettime(CLOCK_MONOTONIC, &t_end);
    printf("\n=== %s ===\n", label);
    printf("  throughput: %.1f MiB/s\n",
           total / (1024.0 * 1024.0) /
           (time_diff_ms(&t_start, &t_end) / 1000.0));

    close(fd);
    free(buf);

}

int main(int argc, char *argv[])

{

const char *path = DEFAULT_PATH;

if (argc > 1) path = argv[1];

read_file(path, RWF_DONTCACHE, "Round 1: preadv2 + RWF_DONTCACHE");

read_file(path, 0, "Round 2: preadv2 (normal)");

return 0;

}

________________________________

