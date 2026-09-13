Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01AC9C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 10:16:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 117696B0093; Sun, 13 Sep 2026 06:16:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8D86B0095; Sun, 13 Sep 2026 06:16:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9A56B0096; Sun, 13 Sep 2026 06:16:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3D5F6B0093
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 06:16:57 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F8308060C
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:16:56 +0000 (UTC)
X-FDA: 85208335632.30.1B9B9C2
Received: from mta0.migadu.com (out-72.mta0.migadu.com [91.218.175.72])
	by imf05.hostedemail.com (Postfix) with ESMTP id 14650100002
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 10:16:53 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pDHbned7;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789294614;
	b=gOXe0FkdLlwjqVJsR6sndzZQHaQSqIPLDA9XfAATHBGTbpfWnaqMdidBUY5fT+PDPBaaQC
	TdIsUMCrMYy28+NobbWCjHV2h3qI2O/iD7wKoqt61+wMHBkNjbr8FakNpMyUuQUMro0Ks0
	vSG+kFdpiEfZ6b+xI8rFu9q/erYATKU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pDHbned7;
	spf=pass (imf05.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.72 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789294614;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n4M0OeoQmY+H04o+rMWiP1rLMMW6op0p5ihqt731dAU=;
	b=N7HWO7RghUkV+0CtNbvS6fphYWR2JTJq1GdT40lUkLn4hCjMP3iOlcJB8f714i6dF/q/C6
	/fK4Y7P3pNN9S8hBFXvGFML+a5fP9NUS/95bXzMgUT2iTXP3qyXprVgXJCczAFziQvo3kC
	0DTSpfa6HrEr/176LRj73gvYlKlALJA=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/wu/fbxDNn+n1dkUM4jcl91XU1j5H2XhOQeune7fHf4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789294612; v=1; x=1789899412;
 b=pDHbned7TWlncl5hhAOnZ+t9WFXCkgclIaMw/gxv+Opi2SH26Fw0McQh73ipQ2E2TM8pxyaO
 7yYGXfpBzRJTwRX3ljzQcmYKUXt+sqhtvBAkQ7gkEIF3Ym6G7TdTQtnnKg7B4jK50An2yVWi7Kx
 qO7ccX0D/HUfMcdNW/icYJ14=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id cbe18b715c9175a4;
	Sun, 13 Sep 2026 10:16:52 +0000
X-Mizu-Trace-ID: cbe18b715c9175a4
X-Migadu-Flow: FLOW_OUT
Message-ID: <46037a37-4cf6-448e-a94b-30a4d16e8814@linux.dev>
Date: Sun, 13 Sep 2026 18:16:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8] mm: vmscan: retry folios written back while isolated
 for traditional LRU
To: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 "open list:MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU)" <linux-mm@kvack.org>,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
 xieym_ict@hotmail.com
References: <20260913100013.3603815-1-ridong.chen@linux.dev>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20260913100013.3603815-1-ridong.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 14650100002
X-Rspam-User: 
X-Stat-Signature: 4ky1dwa6g18c6pmzzey1kdjbogrta867
X-HE-Tag: 1789294613-380464
X-HE-Meta: U2FsdGVkX19+ZYR5AaIqrXpufuXFYNoeX9ssitkBAh+UZASE8CqAUnLHnyFu5TQXS/LHJLI+RJZtGDJU0ZH28QSOAxXVHM8RDTjlOPm+yh6fEzw1pRu2eQ1KKVq4ueF5s1j6rbBVjYVu+XGlSrp5Kl30C06ri0+Jf9SSzLZ7/ENuTBUC4ZqGHmHPAEH826Y8jwg/TY0XjeXHzIqG5tY9uC5PyS2FAduzexvrMXV3vLjD5drbVbGf0CGspc1EbhVTGz+swWsZ6TShMV4jeMvH1/AB+eMVXHZ71C5ypyXT6aIbaWZ8c7u4ipw90guiGMTvP3IzTVn2Sq6W/cv6KRrNESBTKAeASrTqhqzujuwUIWYzYamiCY5Feh5FsDTZe+qu+VseythqwzUjTeh2A5ybGG7Rcdrn82QtqoFbpCROzc5gwYr0gvkUUzpA39MBti/4bf+mAEqO3ZKfsIOTX0FIlxUW5DnLcdOvFjdmV+fQwTXOAhXz3eSoSblY7de77LCcZzqam4maV+vjM6ulZOboQelFiiumAGZTdvTxBkH6lG8in5yDE/pwRhpTsM+3FSoWK+d3IFF3dyA1Rrh7Z6JCLyMhd+cPoPHKJhL4UbEStT2YPQYNsDVnQ195F7AtjPKhW4C7Cjt1FNGhsqKH72unSZUsFZKCXaX3SmsMXypTl6zN5r5s0HcuteGGX6bBtzlf3iPoNWAssEbI8yVK/9ue+kMRYbbCwUfT5KYYIqiaKvtglm5lruBSuSTjMK7CtcE3iuHnT3yv7clhHlnzOWU6rczSxN0djEb6fPQW5wmJCe6+DjNV7yrkguMfNqGIJgiMQu+DxwDNngErKH97WNtaWkGx9/UvoLiRBUTm2WiTseNNu76xXt9yM93StUKu9F16ZgIqb+JyqOBm6g+wvLkW1WTuU6Sd5S0xYWNGev/L3N1wgFhv5aqRMsusvyX4MVbjxzhJbmjvRnk3yG0gi7Z
 17VoFfnI
 nrB40+sOgM5YiSIJsJ0qgoIBN2u67IGhtv3WpJJ+5okj1zYfidI07STQjk/SUPs+kHr5vKajHwFoDcV86RC06s89eZ1Ums3zANsVF7o0We/SY3IXceSh5fVFjUwDWaDeuq+e8m01TiMcwXSZyOchP5F8TTC8HHZqbmhVMb9Ez1Yt/UEIJbjCRJRrcAyBMD70Eybfs7wAtTCa+JUo0oC3IaRVorEZKY6H0QhYc2fYPGzNpLA9hLhoPMAKnxL6MUljD6BHoyonvwjwXz/g1Ex8mFr1nychVKJJrqCOyAEqPmttmQN3TiQqJdb83fyq9Y8c112c6MFkO4hpnTEaKKuXRsi6QBbukx2xxEnxlOe+Ss4svznYcna/njM+aUCUk+l8nwQql
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/13/2026 6:00 PM, Ridong Chen wrote:
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> As commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
> while isolated") mentioned:
> 
>    The page reclaim isolates a batch of folios from the tail of one of the
>    LRU lists and works on those folios one by one.  For a suitable
>    swap-backed folio, if the swap device is async, it queues that folio for
>    writeback.  After the page reclaim finishes an entire batch, it puts back
>    the folios it queued for writeback to the head of the original LRU list.
> 
>    In the meantime, the page writeback flushes the queued folios also by
>    batches.  Its batching logic is independent from that of the page
>    reclaim. For each of the folios it writes back, the page writeback calls
>    folio_rotate_reclaimable() which tries to rotate a folio to the tail.
> 
>    folio_rotate_reclaimable() only works for a folio after the page reclaim
>    has put it back.  If an async swap device is fast enough, the page
>    writeback can finish with that folio while the page reclaim is still
>    working on the rest of the batch containing it.  In this case, that folio
>    will remain at the head and the page reclaim will not retry it before
>    reaching there".
> 
> The commit 359a5e1416ca ("mm: multi-gen LRU: retry folios written back
> while isolated") only fixed the issue for mglru. However, this issue
> also exists in the traditional active/inactive LRU and was found at [1].
> 
> It can be reproduced with below steps:
> 
> 1. Compile with CONFIG_TRANSPARENT_HUGEPAGE=y
> 2. Mount memcg v1, and create memcg named test_memcg and set
>     limit_in_bytes=1G, memsw.limit_in_bytes=2G.
> 3. Create a 1G swap file, and allocate 1.35G anon memory in test_memcg.
> 
Hi all,

I am raising this issue again. It has been a long time since the last version [1].

It was suspected that Kirill's "[PATCH 0/8] mm: Remove PG_reclaim" would solve 
this issue, but the issue remains.

I am providing the reproducer(offered by Xuedong Zhao) in the hope that it will 
help fix this issue.

memcg_malloc.c:
```
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define ONE_GB (1024 * 1024 * 1024)
#define SIXTY_FOUR_MB (64 * 1024 * 1024)

/* non-zero fill: zero pages can be deduped/never written to swap, which hides
  * the "written-back-while-isolated" leak. Use a real byte pattern. */
#define FILL_BYTE 0xAB

void allocate_memory(size_t size_in_bytes) {
     size_t total_allocated = 0;
     char *memory;

     while (total_allocated + ONE_GB <= size_in_bytes) {
         memory = (char *)malloc(ONE_GB);
         if (memory == NULL) {
             perror("malloc");
             exit(EXIT_FAILURE);
         }
         memset(memory, FILL_BYTE, ONE_GB);
         total_allocated += ONE_GB;
         printf("Allocated %zu GB\n", total_allocated / ONE_GB);
         sleep(1);
     }

     while (total_allocated + SIXTY_FOUR_MB <= size_in_bytes) {
         memory = (char *)malloc(SIXTY_FOUR_MB);
         if (memory == NULL) {
             perror("malloc");
             exit(EXIT_FAILURE);
         }
         memset(memory, FILL_BYTE, SIXTY_FOUR_MB);
         total_allocated += SIXTY_FOUR_MB;
         printf("Allocated %zu MB\n", total_allocated / (1024 * 1024));
         sleep(1);
     }

     size_t remaining = size_in_bytes - total_allocated;
     if (remaining > 0) {
         memory = (char *)malloc(remaining);
         if (memory == NULL) {
             perror("malloc");
             exit(EXIT_FAILURE);
         }
         memset(memory, FILL_BYTE, remaining);
         total_allocated += remaining;
         printf("Allocated remaining %zu bytes\n", remaining);
         sleep(1);
     }

     printf("Total allocated: %zu bytes\n", total_allocated);
}

int main(int argc, char *argv[]) {
     if (argc != 2) {
         fprintf(stderr, "Usage: %s <size_in_gb>\n", argv[0]);
         return EXIT_FAILURE;
     }

     double size_in_gb = atof(argv[1]);
     if (size_in_gb <= 0) {
         fprintf(stderr, "Invalid size: %s\n", argv[1]);
         return EXIT_FAILURE;
     }

     size_t size_in_bytes = (size_t)(size_in_gb * ONE_GB);
     allocate_memory(size_in_bytes);

     sleep(3600);
     return EXIT_SUCCESS;
}
```

test.sh:
```
#!/bin/bash
set -e

# Variables
MEMCG_NAME="test_memcg"
MEM_LIMIT="1G"
MEMSW_LIMIT="2G"
PROGRAM_PATH="./memcg_malloc"
PROGRAM_ARGS="1.35"

# ---- swapfile setup --------------------------------------------------------
SWAPFILE="/swapfile"
SWAP_SIZE="1G"          # size of the swap device backing the test

setup_swap() {
     # already have swap on? then nothing to do
     if [ "$(swapon --show --noheadings | wc -l)" -gt 0 ]; then
         echo "swap already active:"; swapon --show
         return
     fi

     if [ ! -f "$SWAPFILE" ]; then
         echo "Creating ${SWAP_SIZE} swapfile at ${SWAPFILE}"
         # fallocate is fast; fall back to dd if the fs doesn't support it
         fallocate -l "$SWAP_SIZE" "$SWAPFILE" 2>/dev/null || \
             dd if=/dev/zero of="$SWAPFILE" bs=1M count=$((8*1024)) status=progress
         chmod 600 "$SWAPFILE"
         mkswap "$SWAPFILE"
     fi
     swapon "$SWAPFILE"
     echo "swap enabled:"; swapon --show
}

setup_swap

# ---- reclaim preconditions -------------------------------------------------
# This bug is in the *traditional* active/inactive LRU; MGLRU already fixed it
# in commit 359a5e1416ca, so it must be disabled to reproduce.
[ -f /sys/kernel/mm/lru_gen/enabled ] && echo 0 > /sys/kernel/mm/lru_gen/enabled
# Large anon folios make the reclaim/writeback batching race easy to hit.
echo always > /sys/kernel/mm/transparent_hugepage/enabled
echo "lru_gen: $(cat /sys/kernel/mm/lru_gen/enabled 2>/dev/null)  thp: $(cat 
/sys/kernel/mm/transparent_hugepage/enabled)"

# Create the cgroup slice if it doesn't exist
if ! systemctl list-units --full -all | grep -q "${MEMCG_NAME}.slice"; then
     echo "Creating cgroup slice ${MEMCG_NAME}.slice"
     systemctl set-property --runtime -- ${MEMCG_NAME}.slice MemoryMax=${MEM_LIMIT}
     systemctl set-property --runtime -- ${MEMCG_NAME}.slice 
MemorySwapMax=${MEMSW_LIMIT}
fi

# Start the slice to apply the properties
systemctl start ${MEMCG_NAME}.slice

# Run the program in the cgroup
echo "Running programs in cgroup slice ${MEMCG_NAME}.slice"
systemd-run --unit=${MEMCG_NAME}_proc1 --slice=${MEMCG_NAME}.slice 
${PROGRAM_PATH} ${PROGRAM_ARGS} &

# Pause to let reclaim settle under the 1G limit
sleep 60

# ---- measurement (cgroup v1) -----------------------------------------------
echo "########## measurement ##########"

CG=/sys/fs/cgroup/memory/${MEMCG_NAME}.slice/${MEMCG_NAME}_proc1.service

usage=$(cat "$CG/memory.usage_in_bytes" 2>/dev/null || echo 0)
memsw=$(cat "$CG/memory.memsw.usage_in_bytes" 2>/dev/null || echo 0)

# v1: swap charged to the memcg is memsw.usage - usage
swap_charged=$((memsw - usage))

# swap actually consumed on the device: /proc/swaps "Used" column is in KiB
dev_used_kb=$(awk 'NR>1 {sum += $4} END {print sum+0}' /proc/swaps)
dev_used=$((dev_used_kb * 1024))

# the bug wastes swap: slots written back while isolated are charged on the
# device but never reused, so device usage outruns what the cgroup accounts for
waste=$((dev_used - swap_charged))

to_mib() { awk -v b="$1" 'BEGIN { printf "%.0f MiB", b/1024/1024 }'; }

echo "memory.usage_in_bytes        : ${usage} bytes ($(to_mib ${usage}))"
echo "memory.memsw.usage_in_bytes  : ${memsw} bytes ($(to_mib ${memsw}))"
echo "swap charged (memsw - usage) : ${swap_charged} bytes ($(to_mib 
${swap_charged}))"
echo "swap device used             : ${dev_used} bytes ($(to_mib ${dev_used}))"
echo "wasted swap (device - cg)    : ${waste} bytes ($(to_mib ${waste}))"
echo "-----"
free -h
echo "--- /proc/swaps ---"; cat /proc/swaps

# Wait for the processes to complete
wait

# Clean up
echo "Cleaning up"
# Reset failed state if the slice is still loaded
if systemctl list-units --full -all | grep -q "${MEMCG_NAME}.slice"; then
     systemctl reset-failed ${MEMCG_NAME}.slice
fi
systemctl stop ${MEMCG_NAME}.slice

echo "Done"

```

Result shown as:

```
...
########## measurement ##########
memory.usage_in_bytes        : 1070014464 bytes (1020 MiB)
memory.memsw.usage_in_bytes  : 1413173248 bytes (1348 MiB)
swap charged (memsw - usage) : 343158784 bytes (327 MiB)
swap device used             : 344248320 bytes (328 MiB)
wasted swap (device - cg)    : 1089536 bytes (1 MiB)
-----
                total        used        free      shared  buff/cache   available
Mem:           1.6Gi       1.2Gi       316Mi       0.0Ki        85Mi       287Mi
Swap:          1.0Gi       328Mi       695Mi
...
```

[1] https://lore.kernel.org/linux-mm/20250113155206.GB829144@cmpxchg.org/#r
-- 
Best regards
Ridong


