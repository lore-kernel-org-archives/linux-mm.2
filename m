Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 284D1EDF172
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7111A6B0005; Fri, 13 Feb 2026 10:08:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F24F6B0088; Fri, 13 Feb 2026 10:08:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7E56B008A; Fri, 13 Feb 2026 10:08:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E5C26B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:08:25 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 04282B9D7E
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:08:24 +0000 (UTC)
X-FDA: 84439764570.02.B3806E8
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 063C81C000F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:08:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Aol200H2;
	spf=pass (imf20.hostedemail.com: domain of luyang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luyang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770995303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VdwntqRmfU5Q6bP8HbCiALvYsNAn6fL7y37a95bOK7c=;
	b=Az7GR9s3uKH8ED9PSl0OlJjnHMDN1y+ngzt5kMgrSiVTyc9hGtMUSvV/WZdFn+mOS4SMqh
	DM7g8Yn60wAz4NhKUmdO35/j00UM1rZdS7MVKrdG0Yn1gEYy66ZhqPxbKZxggCItVXPR4M
	+z1WNUOT0/i5JLrPpigDcvyd9WrgZx4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Aol200H2;
	spf=pass (imf20.hostedemail.com: domain of luyang@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luyang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770995303; a=rsa-sha256;
	cv=none;
	b=qdMHNJkwwc2nyOVJVSdX70P6OTijw7+3bElpIuW3OqhT+Gb9FrFeaHiRM4l8tm9AsmcEPn
	lsIR2NqG4YbLd+/W3kKEH/CBd/fLvdFE8UjeWWHj4HN8N31jYylArhquTl3Tx6YLdYsnxb
	wnCJmSc8Byg8u8Nv6ikN6G2V2eAyuTo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770995302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=VdwntqRmfU5Q6bP8HbCiALvYsNAn6fL7y37a95bOK7c=;
	b=Aol200H2C0qqM75uZ8k5jIchwYft80QZJmKvFHli1/gmQr0f+owHAtu87g6SVa8e/cP54M
	9/uJC+ryRpOdUQAs/qwAXkYn6uDZElN9rMkz1rs2rDEOfG0q6Dm/SAx8Z3PI5xSDiiakAp
	BVCJspoN87GvDkHv384hivANPLaAOzM=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-39-6zxwxEVwNRqei7-brqVJcw-1; Fri,
 13 Feb 2026 10:08:19 -0500
X-MC-Unique: 6zxwxEVwNRqei7-brqVJcw-1
X-Mimecast-MFC-AGG-ID: 6zxwxEVwNRqei7-brqVJcw_1770995297
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E36701956050;
	Fri, 13 Feb 2026 15:08:16 +0000 (UTC)
Received: from localhost (unknown [10.22.89.46])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 97F9530001B9;
	Fri, 13 Feb 2026 15:08:15 +0000 (UTC)
Date: Fri, 13 Feb 2026 10:08:14 -0500
From: Luke Yang <luyang@redhat.com>
To: dev.jain@arm.com
Cc: jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
	willy@infradead.org, surenb@google.com, vbabka@suse.cz,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
Message-ID: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: uJ8wUq9dLex3wpHhM04h266Xi1tYpFX2jib6ANt6ugA_1770995297
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: dsrc6kjz9pic7zp1r3ubp8cspac1ifbu
X-Rspamd-Queue-Id: 063C81C000F
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770995302-484227
X-HE-Meta: U2FsdGVkX1+5Mt+2GzLWuvPLEkUrWDBLQAK0lOlCkj61f+2K44xRfC/OWsnPA6hssoqE9qvslaMgheg++icbKuei16ML7WT0iK0hn8DHXgTPadD3XkZjj137/DJ87DkP7rVFQvhQndZbtO87pVoaTl3nYj5JS1vW2iue2b/oURar7VMRlMflLZ9XWcOwHVhKkWz90pInGg0Vs4X6LYVNQWEvGdm7zW1LNGeC07r5TfiqY0tA8pZ3feivycBsNXKJ6h21KJD7jEye/zZzV3qFPt9MueqyDvXOaoz4mXSUk+YBHAZy3JkO4DOjoa4oPpCNGFRfAVdB9wj+381TORilLHaPVzI9rXJSq970FkukCNiDQFgfHBT5SZJ9y+RfjKfeP/tzgQNhlqKfrnccT1RSo3qAAc5zWz19P5xhJf983VC/kvqia3ST6bxZUYEIvO84A1NKNxhTlneR25YyBYWWahVN51rAoQGW6Ds+m9MjMwzShPROqr/rgmmzBw5gS7nOKnMYpB5uVhfTEwS48FZ4o5VJu3TIa+LE/qefPtRQgCNMyHeUOqb9gSQNxcR9bQT2uPcfuTt6kwjFt5qRF/JIlrVKlpRGl6uImzDWeqexnqJAl9tb3+IHF05l0R7IszxOEath0Xe2t4qgTqH+D29qyKGItIBD/5qyd10Y3KrejpaRgcX9IFLQnBWt9apyXG+AXu3j7iO72KZjFowsAUz0J2K9bD4/IcWDo1eVDjqJj3/F02HX+zOvHsYKl8d/ySfx0faGLHzoidhRbWaqOI3OCbMkh/ImDVfkEFTTJ2k5ylHjhjVeDjlEl/2Xq5KWnO8evwqW0xlanGgIvl7ynuE1fsXSDvaIxz9N0LMApGlhm8KvAr1aSLWybwTyi909YAwVBZcufON53nTKEXBDCTYeYJwiwTWUMp0dCZ+ksk0SehfyqV+Y0sxjZsbVMy0hWa/0jbjzR+WjRj0LNyR2tK/
 cVHH03NB
 PFiujkbw/r11yEl60LBCpUi2ekKBLIVKrk59BUSytWqEtmCJhsNQYQRa5UWiw7P7f9Wlx4+RCU6d85V1/wb9p1WR0AoxvSTaWUoqur7NiczG1zdNhMleBVX4pMJFfG5GH+t2ZIvGCULNxQ1jZu6qp15rEqEPEMXUUZK1IoJrt8apzvpB5hTM7Xc/9LJ00i/nt8Qa5YXB2Pu8SqlkQxW0qn8fOOHKVUX0HnjlFOIyI+khoVfIjxChJG1Jc/V2pLfvzor0mW64h0RUQQr2MAfG5SFjh0rvNtl+gPvrKCCiOQBlgeKdJI9kDq+DE6PomlQ7iAZH/AN99DzXEDLMr2tSD9u6j9Y0osyKJILLH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

we have bisected a significant mprotect() performance regression in
6.17-rc1 to:

cac1db8c3aad ("mm: optimize mprotect() by PTE batching")

The regression becomes clearly visible starting around 400 KiB region
sizes and above. It is also still present in the latest 6.19 kernel.

## Test description

The reproducer repeatedly toggles protection (PROT_NONE <->
PROT_READ|PROT_WRITE) over a single mapped region in a tight loop. All
pages change protection in each iteration.

The benchmark sweeps region sizes from 4 KiB up to 40 GiB.

We bisected between 6.16 and 6.17-rc1 and confirmed that reverting
cac1db8c3aad on top of 6.17-rc1 largely restores the 6.16 performance
characteristics.

## perf observations

In 6.17-rc1, commit_anon_folio_batch() becomes hot and accounts for a
significant portion of cycles inside change_pte_range(). Instruction
count in change_pte_range() increases noticeably in 6.17-rc1.
commit_anon_folio_batch() was added as part of cac1db8c3aad.

The regression is also present for the following servers: AMD EPYC 2 (Rome),
AMD EPYC3 (Milan), AMD EPYC3 (Milanx), AMD EPYC4 (Zen4c Bergamo), Ampere Mt
Snow Altra with KVM virt type (ARM Neoverse-N1) , Lenovo Thinkpad T460p (Intel
Skylake 6820HQ).

## Results (nsec per mprotect call) collected on AMD EPYC Zen3 (Milan)
server.

v6.16
size_kib | nsec_per_call
4        | 1713
40       | 2071
400      | 3453
4000     | 18804
40000    | 172613
400000   | 1699301
4000000  | 17021882
40000000 | 169677478

v6.17-rc1
size_kib | nsec_per_call
4        | 1775
40       | 2362
400      | 5993
4000     | 44116
40000    | 427731
400000   | 4252714
4000000  | 42512805
40000000 | 424995500

v6.17-rc1 with cac1db8c3aad reverted
size_kib | nsec_per_call
4        | 1750
40       | 2126
400      | 3800
4000     | 22227
40000    | 205446
400000   | 2011634
4000000  | 20144468
40000000 | 200764472

This workload appears to be the worst case for the new batching logic,
where batching overhead dominates, and no amortization benefit is
achieved.

We will provide the following minimal reproducers:

* mprot_tw4m_regsize_sweep_one_region.sh
* mprot_tw4m_regsize.c

Please let us know if additional data would be useful.

Reported-by: Luke Yang luyang@redhat.com
Reported-by: Jirka Hladky jhladky@redhat.com

Thank you
Luke

Reproducer
----------


mprot_tw4m_regsize_sweep_one_region.sh
--- cut here ---
#!/bin/bash
gcc -Wall -Wextra -O1 -o mprot_tw4m_regsize mprot_tw4m_regsize.c
if ! [ -x "./mprot_tw4m_regsize" ]; then
 echo "No ./mprot_tw4m_regsize binary, compilation failed?"
 exit 1
fi

DIR="$(date '+%Y-%b-%d_%Hh%Mm%Ss')_$(uname -r)"
mkdir -p "$DIR"

# Sweep region size from 4K to 4G (10x each step), 1 region.
# Iterations decrease by 10x to keep runtime roughly constant.
#   size_kib   iterations
runs=(
   "4          40000000"
   "40         4000000"
   "400        400000"
   "4000       40000"
   "40000      4000"
   "400000     400"
   "4000000    40"
   "40000000   4"
)

for entry in "${runs[@]}"; do
   read -r size_kib iters <<< "$entry"
   logfile="$DIR/regsize_${size_kib}k.log"
   echo "=== Region size: ${size_kib} KiB, iterations: ${iters} ==="
   sync; sync
   echo 3 > /proc/sys/vm/drop_caches
   taskset -c 0 ./mprot_tw4m_regsize "$size_kib" 1 "$iters" 2>&1 | tee "$logfile"
   echo ""
done

# Create CSV summary from log files
csv="$DIR/summary.csv"
echo "size_kib,runtime_sec,nsec_per_call" > "$csv"
for entry in "${runs[@]}"; do
   read -r size_kib _ <<< "$entry"
   logfile="$DIR/regsize_${size_kib}k.log"
   runtime=$(grep -oP 'Runtime: \K[0-9.]+' "$logfile")
   nsec=$(grep -oP 'Avg: \K[0-9.]+(?= nsec/call)' "$logfile")
   echo "${size_kib},${runtime},${nsec}" >> "$csv"
done

echo "Results saved in $DIR/"
echo "CSV summary:"
cat "$csv"
--- cut here ---

mprot_tw4m_regsize.c
--- cut here ---
/*
* Reproduce libmicro mprot_tw4m benchmark - Time mprotect() with configurable region size
* gcc -Wall -Wextra -O1 mprot_tw4m_regsize.c -o mprot_tw4m_regsize
* DEBUG: gcc -Wall -Wextra -g -fsanitize=undefined -O1 mprot_tw4m_regsize.c -o mprot_tw4m_regsize
* ./mprot_tw4m_regsize <region_size_kib> <region_count> <iterations>
*/

#include <sys/mman.h>
#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <string.h>
#include <strings.h>
#include <time.h>

typedef volatile char vchar_t;

static __inline__ u_int64_t start_clock();
static __inline__ u_int64_t stop_clock();

int main(int argc, char **argv)
{
   int i, j, ret;
   long long k;

   if (argc < 4) {
       printf("USAGE: %s region_size_kib region_count iterations\n", argv[0]);
       printf("Creates multiple regions and times mprotect() calls\n");
       return 1;
   }

   long region_size = atol(argv[1]) * 1024L;
   int region_count = atoi(argv[2]);
   int iterations = atoi(argv[3]);

   int pagesize = sysconf(_SC_PAGESIZE);

   vchar_t **regions = malloc(region_count * sizeof(vchar_t*));
   if (!regions) {
       perror("malloc");
       return 1;
   }

   for (i = 0; i < region_count; i++) {
       regions[i] = (vchar_t *) mmap(NULL, region_size,
                     PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0L);

       if (regions[i] == MAP_FAILED) {
           perror("mmap");
           exit(1);
       }

       for (k = 0; k < region_size; k += pagesize) {
           regions[i][k] = 1;
       }
   }

   printf("Created %d regions of %ldKiB each. Starting %d mprotect operations per region...\n",
          region_count, region_size / 1024, iterations);

   struct timespec start_time, end_time;
   clock_gettime(CLOCK_MONOTONIC, &start_time);
   u_int64_t start_rdtsc = start_clock();

   for (j = 0; j < iterations; j++) {
       for (i = 0; i < region_count; i++) {
           int prot;

           if ((i + j) % 2 == 0) {
               prot = PROT_NONE;
           } else {
               prot = PROT_READ | PROT_WRITE;
           }

           ret = mprotect((void *)regions[i], region_size, prot);
           if (ret != 0) {
               perror("mprotect");
               printf("mprotect error at region %d, iteration %d\n", i, j);
           }
       }
   }

   u_int64_t stop_rdtsc = stop_clock();
   clock_gettime(CLOCK_MONOTONIC, &end_time);
   u_int64_t diff = stop_rdtsc - start_rdtsc;

   long total_calls = (long)region_count * iterations;
   double runtime_sec = (end_time.tv_sec - start_time.tv_sec) +
                       (end_time.tv_nsec - start_time.tv_nsec) / 1000000000.0;

   double nsec_per_call = (runtime_sec * 1e9) / total_calls;

   printf("TSC for %ld mprotect calls on %d x %ldKiB regions: %ld K-cycles.  Avg: %g K-cycles/call\n",
          total_calls,
          region_count,
          region_size / 1024,
          diff/1000,
          ((double)(diff)/(double)(total_calls))/1000.0);
   printf("Runtime: %.6f seconds.  Avg: %.3f nsec/call\n", runtime_sec, nsec_per_call);

   for (i = 0; i < region_count; i++) {
       munmap((void *)regions[i], region_size);
   }
   free(regions);

   return 0;
}

static __inline__ u_int64_t start_clock() {
   // See: Intel Doc #324264, "How to Benchmark Code Execution Times on Intel...",
   u_int32_t hi, lo;
   __asm__ __volatile__ (
       "CPUID\n\t"
       "RDTSC\n\t"
       "mov %%edx, %0\n\t"
       "mov %%eax, %1\n\t": "=r" (hi), "=r" (lo)::
       "%rax", "%rbx", "%rcx", "%rdx");
   return ( (u_int64_t)lo) | ( ((u_int64_t)hi) << 32);
}

static __inline__ u_int64_t stop_clock() {
   // See: Intel Doc #324264, "How to Benchmark Code Execution Times on Intel...",
   u_int32_t hi, lo;
   __asm__ __volatile__(
       "RDTSCP\n\t"
       "mov %%edx, %0\n\t"
       "mov %%eax, %1\n\t"
       "CPUID\n\t": "=r" (hi), "=r" (lo)::
       "%rax", "%rbx", "%rcx", "%rdx");
   return ( (u_int64_t)lo) | ( ((u_int64_t)hi) << 32);
}
--- cut here ---


