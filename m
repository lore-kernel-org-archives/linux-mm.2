Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 858FF606A321
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pyOkJhRG
Received: by kanga.kvack.org (Postfix)
	id A80776B05B0; Sun,  8 Nov 2026 06:49:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A56E96B05B1; Sun,  8 Nov 2026 06:49:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993E86B05B2; Sun,  8 Nov 2026 06:49:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD0F6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:49:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 05E3E12044D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:49:48 +0000 (UTC)
X-FDA: 85411782456.28.D274130
Received: from mta1.migadu.com (out-239.mta1.migadu.com [95.215.58.239])
	by imf13.hostedemail.com (Postfix) with ESMTP id C4E0D20006
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:49:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyOkJhRG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794138586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mx1T3x5NdntkCNMC/7Y1AVNRgpHehBLEHp53fMMzs14=;
	b=Cj9p9U7POenfSbNcfC6YxB1pEQ4hRAOGeSe7GN8raFOjwaCZ6zPFTYQd7M9tTH84EUGgIL
	9Ym6ATNYoCEflBid58burElpV5DBY5l7kgxnOyrDg4MHoCNWA0J/UseVdkSZuatbsbdG93
	Gnx3+IQfCipjshC6HlyvFI5QKnofj3M=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pyOkJhRG;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.239 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794138586;
	b=QpX8zZndsQJOa88gdpd2mhk81F9GSbCm8IYwXKYrCUKRUmSX+K569X9j4qeM+/enCoqdUG
	/2VGqQg84ssZzf1qWkhgpmfxP3SGmVZf7/BBU6mfBFUlsGFw67lur2pjyi9luEK8Re+1ub
	mHpGHsIzHG0/2jLZGDTVN5H6O5kWKyk=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=LNqqNGALYABGDri/nTJALkpbguz/zDXcCduaETVR4nM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794138582; v=1; x=1794743382;
 b=pyOkJhRGmmpR0LHwnz/8Y/zc1C7k+SdmwY+DVJaBNsNfETBb+p1s92Ho4IifFFk7728C3rZ5
 Jh7DTMc8OzyUFzli1dL2Be3f+vXMIIVrXlF6d/5EmY5bHo/zX0fiqD/OpxbbytdudouUlsU+EGN
 3jG/mu6g++JmxaIkL3TDRCek=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 1efe042f909cfa61;
	Sun, 08 Nov 2026 11:49:42 +0000
X-Mizu-Trace-ID: 1efe042f909cfa61
X-Migadu-Flow: FLOW_OUT
Message-ID: <965521d8-d726-457f-a72e-98aaab6db3d1@linux.dev>
Date: Sun, 8 Nov 2026 19:49:34 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/3] mm/mglru: skip the flags cmpxchg when nothing
 changes
To: Barry Song <baohua@kernel.org>
Cc: David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Joanne Koong <joannelkoong@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
References: <20261105132220.2233677-1-ridong.chen@linux.dev>
 <20261105132220.2233677-3-ridong.chen@linux.dev>
 <CAGsJ_4wQC+d1ruhf+i6cETunK+h94z32-EHB=ghBQJ_rqVLNvg@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4wQC+d1ruhf+i6cETunK+h94z32-EHB=ghBQJ_rqVLNvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C4E0D20006
X-Stat-Signature: ik545bemt15nfmt9hkxyxkeydb4b3zyk
X-Rspam-User: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794138585-84272
X-HE-Meta: U2FsdGVkX1+aSeROZWG+gWZPVudHEtImkv1i7BwKhT5LomkbE2iVlXzMSQh7CsWBEg85Y1vCDV4revT85dp+FGfVn4Ap6kInB4Z+fhLhvDWhgIMu2vUerVv7oABA40lCzoWp16Pc7yJVtP2SXTmKzvR5V9QK9m3gj5j2DgWT7ROvf2qroXgwLct28AxaMbGDq6bDaIvNkEYgyIHbeBbzP+lsCKxX0uMogFmhM7AsrOSxLguP6gBVJ8m7YHTpk1FNCL18XvtUazLVOqeYjBChNgTzvpOyUbKd7aN2RC9hQeA+LYMHzy7XdKjY94c9/sI02XwE3RTsKNflqdWDhyS6RIx58uJi7aSW3uZWmv5AoqWXmIErojg9FMm/CXgMjz1CpV8mfEuq2Cbu+f9A2KgMwk5UyLibkAoAPZcUbWF6J0Y+q9aT4Tuv58X5klD8J+Ag3n7JoeNVml05iJvTrXTmWcflKD/Y2jCpJXyTU31nDUfrvwAK6tfOSke/1Vy/orNuhG1aOuGIEYPXQvoBNk/ZjIRGxYWMReEP/vZbvZxBuPi4L7zMEdgZryi6AItwfveJzCjHLp19mB9cDeJdAMeFHzGq5eC7J+tLrb/PcuAU2M34SKKr+x6LWnWlMQB9TolnbNK0pZ2XHjFnZVBYSufiXAQOudttayG+ftWXB862KdHR23DB6VlBnGnH5EHDDAa5qqXDTU+NiVnzXxB0acupclwjdfYkvOgGc9ks6YZu1dTM9idEDuc1mur2sSIX+cyDZUbkJElETuaGjjHPp7jA9I7q3EJ1CWVLu6g6f/vDE5lAI+X6IgasmokJOwqde4Y2lX36GsoJMhF4oKnJVc9/0IKFZ1kByh/C143I1X/AT9mmkbScYTEYjxcG3fiLJKNiepk8UBSNoiJ4Pbw4T2zuqpUG7vBN62VR8Qj0NxXdGBuZKFJFoqi+TL4hfJo63Xmm/gOO8gfmkUwEmUJizPP
 6pwVmc6k
 KiCMwiawKXmTsCNGrYqEeZOb73EIUCfmlEzx7Y2e//Sn9yoL7+wRc/CenD/vHNv3nMicDu25fmOtBAfF03Zed7QiYS3hdQtH1U7h2pyKsU/IkBevMz1Egw+PihzLJQ5gRhq4YGz8RFTrIIYumixacdjABDJxjMKzxxeKReJ+2ynkz9j81bXeEd+xpXMIlHXcGX8PBCPGI5oWMNaJC7CBhWNsmOE+1xv8RLrdGk0V/FdGCjGlDKOXQrlk8OnpZhkfKyde3VnuIzzYghg2ZMBu8DEym4dNmPFolEEl5iL9NprdFn4OgL47Nh+NQwUsHZHR9LvHhs09scZ81K0I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/8/2026 4:50 PM, Barry Song wrote:
> On Thu, Nov 5, 2026 at 9:23 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> folio_update_gen() and folio_set_lru_refs() always end with a
>> try_cmpxchg() on folio->flags, even when the new value equals the old
>> one. The locked instruction still takes the struct page cacheline in
>> exclusive state.
>>
>> That is common in practice: a folio mapped by many processes is visited
>> once per mm during a page table walk, and after the first visit it is
>> already in the youngest generation with refs cleared and PG_workingset
>> set. isolate_folio() and the eviction paths also call
>> folio_set_lru_refs(folio, 0) on folios whose refs are already zero.
>>
>> Break out of the loop when the flags would not change. The result is
>> the same as a successful no-op cmpxchg. The only difference is that the
>> full barrier implied by the locked instruction is gone on that path.
> 
> Hi Ridong,
> 
> I'm not quite sure this is an accurate description. The

You are right, "the same as a successful no-op cmpxchg" is not
accurate. A better way to put it: when we break, the flags we read
are already the target value, so the update can be considered done
at the time of that read, and any concurrent change is ordered after
it. The current code gives the same result whenever its cmpxchg wins
the race, so the patch makes no new state reachable. What it drops is
only the retry, which recomputes from the new value and overwrites
the concurrent change with what this CPU wanted.

> atomic operation checks whether folio_flags(folio, 0)
> has changed. If it has, we need to recompute new_flags
> based on the updated old_flags.
> 
> For example:
> 
> CPU 0                          CPU 1
> -----                          -----
> read old_flags = A
>                                 change flags A -> B
> new_flags = A
> new_flags == old_flags
> break
> 
> This is how the CAS loop works. Whether we strictly
> need the guarantees provided by CAS is a separate
> question :-)
> 
> But skipping the CAS logic might slightly underestimate a
> folio's hotness if it gets promoted twice? Perhaps the
> race window is so small that the reduced CAS overhead
> outweighs the impact on hotness tracking.
> 

I think it goes the other way. For folio_update_gen(), take two
walkers where CPU 0 read an older max_seq:

CPU 0 (new_gen = N)            CPU 1 (new_gen = N+1)
read flags: gen N
				set gen N+1
current: cmpxchg fails, retry writes gen N back
patched: break, folio stays in gen N+1

So the retry moves the folio back to the older generation, and the
patch keeps the second promotion. Similarly for folio_set_lru_refs():
if CPU 1 increments refs from 0 to 1 while CPU 0 is setting it to 0,
the retry would clear that access, and the patch keeps it.

I will reword the changelog in v2 along these lines.

>> No caller relies on it: the eviction and isolation callers run under
>> the LRU lock, and the others (page table walks, folio_mark_accessed(),
>> lru_gen_clear_refs()) only care about the resulting flags value, which
>> is already in place. Note that lru_gen_inc_refs() already returns
>> without any atomic when refs is at LRU_REFS_MAX and the folio is in
>> the workingset.
>>
>> Tested on an i7-13700HX with turbo disabled and the performance
>> governor. N processes map the same 2GiB tmpfs file (huge=never) and
>> read every page, then one aging pass is triggered on their memcg
>> through /sys/kernel/debug/lru_gen ("+ <memcg_id> 0 <max_seq> 200 1").
>> Time per aging pass in ms, median of 5 runs of 10 passes each, averaged
>> over 2 boots of each kernel:
>>
>>    processes    base   patched
>>            1    32.9      31.7   -3.5%
>>            8   195.1     160.2  -17.9%
>>           32   755.8     592.2  -21.7%
>>           64  1597.2    1260.6  -21.1%
> 
> Could we post the microbenchmark code here if it's
> short enough?
> 

Sure, it is below. Run it as root in a dedicated cgroup v2 memcg,
on a tmpfs mounted with huge=never:

./p4age /mnt/tmpfs/f 2048 <nproc> 10

```
/*
  * P4 load: MGLRU aging over a file mapped by many processes.
  *
  * Creates <MiB> tmpfs file at <path> (mount it with huge=never so every
  * folio is a single page), forks <nproc> children that each map it
  * MAP_SHARED, then for <rounds> rounds:
  *   1. every child reads one byte per page (sets the accessed bit in its
  *      own page tables)
  *   2. the parent triggers one aging pass on its memcg through
  *      /sys/kernel/debug/lru_gen ("+ memcg_id nid max_seq 200 1") and times
  *      the write()
  *
  * The page table walk visits every page once per mm. The first visit moves
  * the folio to the youngest generation; the other nproc-1 visits find the
  * flags already at the target value, which is the no-op cmpxchg P4 skips.
  *
  * Run inside a dedicated cgroup v2 memcg, as root, with debugfs mounted.
  * Usage: p4age <path> <MiB> <nproc> <rounds>
  * Output: one "round=R ms=T" line per round, then a summary.
  */
#define _GNU_SOURCE
#include <fcntl.h>
#include <stdatomic.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/resource.h>
#include <sys/wait.h>
#include <time.h>
#include <unistd.h>

#define PAGE	4096UL
#define LRU_GEN	"/sys/kernel/debug/lru_gen"

struct shared {
	atomic_int round;	/* parent bumps to start a touch round */
	atomic_int done;	/* children finished the current round */
	atomic_int quit;
};

static struct shared *sh;

static double now(void)
{
	struct timespec t;

	clock_gettime(CLOCK_MONOTONIC, &t);
	return t.tv_sec + t.tv_nsec / 1e9;
}

static void child(int fd, size_t len)
{
	volatile char sink;
	int seen = 0;
	size_t i;
	char *p;

	p = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
	if (p == MAP_FAILED) {
		perror("mmap");
		_exit(1);
	}
	for (;;) {
		while (atomic_load(&sh->round) == seen && !atomic_load(&sh->quit))
			usleep(100);
		if (atomic_load(&sh->quit))
			break;
		seen = atomic_load(&sh->round);
		for (i = 0; i < len; i += PAGE)
			sink = p[i];
		atomic_fetch_add(&sh->done, 1);
	}
	(void)sink;
	_exit(0);
}

/* find "memcg <id> <path>" for our cgroup, then max_seq of node 0 */
static int lookup(const char *cg, unsigned long long *id, unsigned long *max_seq)
{
	char line[4096], path[4096];
	int found = 0, in_node = 0;
	unsigned long long mid;
	unsigned long seq;
	FILE *f = fopen(LRU_GEN, "r");

	if (!f) {
		perror(LRU_GEN);
		return -1;
	}
	while (fgets(line, sizeof(line), f)) {
		if (sscanf(line, "memcg %llu %4095s", &mid, path) == 2) {
			if (found)
				break;
			found = !strcmp(path, cg);
			if (found)
				*id = mid;
			in_node = 0;
			continue;
		}
		if (!found)
			continue;
		if (sscanf(line, " node %d", &in_node) == 1) {
			in_node = in_node == 0 ? 1 : -1;
			continue;
		}
		if (in_node == 1 && sscanf(line, " %lu", &seq) == 1)
			*max_seq = seq;
	}
	fclose(f);
	return found ? 0 : -1;
}

static void own_cgroup(char *buf, size_t sz)
{
	FILE *f = fopen("/proc/self/cgroup", "r");

	/* cgroup v2: "0::/path" */
	if (!f || !fgets(buf, sz, f) || strncmp(buf, "0::", 3)) {
		fprintf(stderr, "need cgroup v2\n");
		exit(1);
	}
	fclose(f);
	memmove(buf, buf + 3, strlen(buf + 3) + 1);
	buf[strcspn(buf, "\n")] = 0;
}

int main(int argc, char **argv)
{
	double t, sum = 0, mn = 1e30, mx = 0, tw;
	unsigned long long id;
	unsigned long max_seq;
	int nproc, rounds, fd, r, i, dfd;
	char cg[4096], cmd[128];
	size_t len, off;
	char *buf;

	if (argc < 5) {
		fprintf(stderr, "usage: %s <path> <MiB> <nproc> <rounds>\n", argv[0]);
		return 1;
	}
	len = strtoul(argv[2], NULL, 0) << 20;
	nproc = atoi(argv[3]);
	rounds = atoi(argv[4]);
	own_cgroup(cg, sizeof(cg));

	fd = open(argv[1], O_RDWR | O_CREAT | O_TRUNC, 0600);
	if (fd < 0 || ftruncate(fd, len)) {
		perror(argv[1]);
		return 1;
	}
	/* populate the page cache (charged to our memcg) */
	buf = calloc(1, 1 << 20);
	memset(buf, 0x5a, 1 << 20);
	for (off = 0; off < len; off += 1 << 20)
		if (pwrite(fd, buf, 1 << 20, off) != 1 << 20) {
			perror("pwrite");
			return 1;
		}

	sh = mmap(NULL, sizeof(*sh), PROT_READ | PROT_WRITE,
		  MAP_SHARED | MAP_ANONYMOUS, -1, 0);
	for (i = 0; i < nproc; i++)
		if (fork() == 0)
			child(fd, len);

	dfd = open(LRU_GEN, O_WRONLY);
	if (dfd < 0) {
		perror(LRU_GEN);
		return 1;
	}

	/* round 0 is warm-up: first touch, folios gain PG_workingset */
	for (r = 0; r <= rounds; r++) {
		atomic_store(&sh->done, 0);
		atomic_fetch_add(&sh->round, 1);
		while (atomic_load(&sh->done) < nproc)
			usleep(100);

		if (lookup(cg, &id, &max_seq)) {
			fprintf(stderr, "memcg %s not in %s\n", cg, LRU_GEN);
			return 1;
		}
		/* swappiness 200: walk anon (tmpfs) too; force_scan=1 */
		snprintf(cmd, sizeof(cmd), "+ %llu 0 %lu 200 1\n", id, max_seq);
		tw = now();
		if (write(dfd, cmd, strlen(cmd)) < 0) {
			perror("lru_gen write");
			return 1;
		}
		t = (now() - tw) * 1000;
		if (!r)
			continue;
		printf("round=%d max_seq=%lu ms=%.2f\n", r, max_seq, t);
		sum += t;
		mn = t < mn ? t : mn;
		mx = t > mx ? t : mx;
	}

	atomic_store(&sh->quit, 1);
	while (wait(NULL) > 0)
		;
	close(fd);
	unlink(argv[1]);
	printf("p4age nproc=%d MiB=%zu rounds=%d avg_ms=%.2f min_ms=%.2f max_ms=%.2f\n",
	       nproc, len >> 20, rounds, sum / rounds, mn, mx);
	return 0;
}

```

>>
>> With one process, every visit changes the generation, so there is
>> nothing to skip. Before the patch, perf annotate attributes 53-58% of
>> the walk_update_folio() samples to the lock cmpxchg in the inlined
>> folio_update_gen() in this test.
>>
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
>> ---
>>   include/linux/mm_inline.h | 2 ++
>>   mm/vmscan.c               | 2 ++
>>   2 files changed, 4 insertions(+)
>>
>> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
>> index b3d85fe91385..4ba9079f4dc8 100644
>> --- a/include/linux/mm_inline.h
>> +++ b/include/linux/mm_inline.h
>> @@ -244,6 +244,8 @@ static inline void folio_set_lru_refs(struct folio *folio, unsigned int refs)
>>          do {
>>                  new_flags = old_flags;
>>                  lru_set_refs_flags(&new_flags, refs);
>> +               if (new_flags == old_flags)
>> +                       break;
>>          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>>   }
>>
>> diff --git a/mm/vmscan.c b/mm/vmscan.c
>> index 50c352e9ffef..3fa76715382d 100644
>> --- a/mm/vmscan.c
>> +++ b/mm/vmscan.c
>> @@ -3398,6 +3398,8 @@ static int folio_update_gen(struct folio *folio, int new_gen, int *type,
>>                  lru_set_gen_flags(&new_flags, new_gen);
>>                  lru_set_refs_flags(&new_flags, 0);
>>                  new_flags |= BIT(PG_workingset);
>> +               if (new_flags == old_flags)
>> +                       break;
>>          } while (!try_cmpxchg(folio_flags(folio, 0), &old_flags, new_flags));
>>
>>          *type = folio_flags_is_file_lru(&old_flags);
>> --
>> 2.34.1
>>
> 
> Thanks
> Barry

-- 
Best regards
Ridong


