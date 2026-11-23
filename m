Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70768606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 03:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=SQPSg2UH
Received: by kanga.kvack.org (Postfix)
	id 827D36B00EF; Sun, 22 Nov 2026 22:48:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B1AD6B05B0; Sun, 22 Nov 2026 22:48:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE436B05B8; Sun, 22 Nov 2026 22:48:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 53B616B00EF
	for <linux-mm@kvack.org>; Sun, 22 Nov 2026 22:48:31 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DB36EA83B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:48:29 +0000 (UTC)
X-FDA: 85465001538.03.8B930BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1164580002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:48:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SQPSg2UH;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795405708;
	b=i7MJ9YDJNRXk6+2K9N2VcpBxZWbiukSwOWS5MTbNUeICiZ9dQo2LccjFr7YqP8fwgWMOUW
	2CurjE0vRhCvhrbnhSmWFTzpN6taSvTrOfmRZxgPDUyhGcVbtSq9bHiU7Y38Rw58LsiHn/
	fCtrgr2f2w9DajZPFfFszHDaAMpweSc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795405708;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4ixwLYNHrzYtUov5QUyLh0SBuMoy5xQNhmCQu9M+e0U=;
	b=zM6N/P1CBLj2owp86hgPz0sCcrenwuckRAff+ZAyFyEVYPMrlx+cqFQxUvnUttsqjtfna8
	NWDCZD0GTJeJNywPz6CpTaKcNOPWzitK9nZ0bFMDQMrvaH6uMgAfTnSa3ZrUgHfGzAZAgd
	ET+MmK/pT2N8iF4XXNNalETKQf5Atmc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SQPSg2UH;
	dmarc=none;
	spf=pass (imf30.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 09B6260D3B;
	Mon, 23 Nov 2026 03:48:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCB21F000CA;
	Mon, 23 Nov 2026 03:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1795405706;
	bh=4ixwLYNHrzYtUov5QUyLh0SBuMoy5xQNhmCQu9M+e0U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SQPSg2UHPTiaBzka5y0mmvvcTp3eQnHFgEXA7m0SMy9eRlCqM6kIwVvhacMrOZOG+
	 bGJN9vKoFa04CpsE6GqWRbd00xIF+BlY8+1VrdQtHwWbZUJvpV3fUoXTEJAhJjtm/u
	 F6AIt0IcMleoKcGSPOOhw0j2BZ0fpRHAA6JzsyE4=
Date: Sun, 22 Nov 2026 19:48:25 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kernel test robot <lkp@intel.com>
Cc: Christoph Lameter <cl@linux-foundation.org>,
 oe-kbuild-all@lists.linux.dev, David Hildenbrand <david@kernel.org>, Linux
 Memory Management List <linux-mm@kvack.org>, mm-commits@vger.kernel.org,
 David Rientjes <rientjes@google.com>
Subject: Re: [akpm-mm:mm-unstable 327/327]
 arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits
 from constant value (ffffffffffffd8f0 becomes f0)
Message-Id: <20261122194825.2541c7389c2f958ef3d07fbc@linux-foundation.org>
In-Reply-To: <20261121133112.48w1QOqw-lkp@intel.com>
References: <20261121133112.48w1QOqw-lkp@intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1164580002
X-Spam-Status: No, score=-22.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Stat-Signature: shw8aaz1s8wjn8nbxxyuxjzd8atezr46
X-HE-Tag: 1795405707-26487
X-HE-Meta: U2FsdGVkX192oIcyNZxS0pUur41uMT6qTnikqYRXsmqUKFaSufUhFn1iJTB1qEiQX9uq9Erez+InpGNQC+hyeKV23gOcJL7x6sjQYH0GVVV1Bfkiw6vw6Pb9UO+BJQMgzqg6OPEweRowSUkbB+Y5Kqe1SbXRQFj28fKaKp7LgFXeCBCq1GwLeI341z1sXyL9n8S7nxJf5/NDJGNEbks5c+SzKLM6Ant5gGV1r8bfzoS1ftJhqBuM6npu/S1ShNRKQDQX6wnS2ccg449brL+yjr6L0XqyFh76j1XKaN6vKcjAm0GYS3/V/l436v+TOBj3HyFmQI3aTaznDADJjEV/iITT/VY5Pf1UAcHRaTz66fL0XkYSFl86os4fATNc5uq83574NHPM9IFP0f0Yql9H8ZtT2oN/1AWiJuBfsB7E4uPDBm1Wa747yeXRlogRPVonqyTJGucybA8z5oAhqm5ewi6iBZTh8PtI/wnWc005Vcbih1qZJFoe/V+Xl+RhLFxHEU9WKLxAmkiY/vfkZcyUftj0Eo8M5v4xVq909Gc0nznJJglEiG5IQCx3sQOVqF+jmAHVfoIOQ6Xh354fPFrQt+uFEL6uxVgGXgh0YRGYSKlCoY7mAEmjYiEeQDu91XI1XERMAnzUb8BJ8wgPlvUwkhvTF35Z2QfscmuCRAtOP8lphoD83YswIB7Mrj/dSh5apSXLy0zik/ZWITT2yq/0zMe+qlLmQghmGPvYmR1Pe4vbb5XSSBcgUs63bRQS8NSF5F3nVdx8DFrBNRaYSt3FINCgybkz52aVLK5SBpnFYGGwWwFhwKPtakcPEMGOjlv3WXMgCXhGjpFMZ4herKEOyGs/gGikJgKXqqu4+GXYtl31WQJlWftgFT8WqHLGVolEMIaWDyYMUUeR0A2Pa6Lyl7h+JLFUIZ9FFP54Wu1xxr1FG7gNPgDSoUKx5Y3kJw2jb0vJxzqVf+NrEU85GER
 CGU/ryPQ
 GSmm8v1KgK5rOv5UWQcvylvuzSGl+vc6SlEwO99Px8x6bAa4mxoOTgHsmNxR/IABwrUMMqcWOM7Inz18djFgtJRsstGpES91V/VsooenmjgoG91FSXl7jNVWFX1cyQlWGO4NKT0LrbjhswsxrZRmEndX4AO2CXlYNJocIkJzkU2RS4J0sOrsnnGU5uPqUb+6Kpk6yy8p37ROr9D7jjn3LUWsfSw5CFpKCQOcAx+3LGaN/IVCJPsOFSjRSe3U1+4D2ZcIDJcv2JMrdO/LPYd/q7fRvMRAyTpxmoYbrx94aTOZtfIKP0lXS18G4RFK75wKV7hpRozRrTd0ECkT6aZFy1gYKlH37/acQDvfdf7E6n9OasrBGbWAAkUaC0iq5LpxfoIYdTEfvxlzRvMq47dXrR6lO2nCQWSeAu9fldIUIapbwETEyZCJT0QFnZuGt4mIKyyJtyeqgDZ8SDu/xBTUo+fLt80RC+Upbc8LCGzOwQJJaygXsF0BqIjz9RaAhAdlDsTo2so+lSUC3idfrehUC95ZzSCGZumX6AGolfVrApncfG60yCrXft1BdkPXxwOHjSCRkpIojk0t8dzonW9cA7f4sksvaIhu3VjkpmvowXJBmhir6+72GEBMfQpnxEUKaeVXdjDoTV+3PO6hX+NGhj2RXIZSBIXDKcIiDVzpGxiwNYQ23sHr4b3ZW/GDStKllPYEvAiwdwjbBPIHHkvefGy3Ql9zkdI6DJ7W3JPp9XZQe0Yj6NPkdsBFTsV92fGW1gVou3eP0fJFXy5LK+FgctqW2hCOwvqX3K933cDyUwKg6ayUCohTcrmV16KrJzVmIfNNWLzCIpOydxpAX9vfWBRgUH3WrCFODDEOtZXmD/p4L9EoHoLFpDh1M1MgCrtGd8LkujD4pYuoeuEFzUKROtZAZj9dt85qCbcw3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 21 Nov 2026 13:34:45 +0100 kernel test robot <lkp@intel.com> wrote:

> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-unstable
> head:   7d1a16abe4cc5dccd21e3d6262e44433a5885d27
> commit: 7d1a16abe4cc5dccd21e3d6262e44433a5885d27 [327/327] mm: vmstat_kunit: add synthetic benchmark for mm stats
> config: arm64-randconfig-r2305-20261121 (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 15.3.0
> sparse: v0.6.5-rc1-21-g84ec0658
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20261121/20261121133112.48w1QOqw-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
> 
> sparse warnings: (new ones prefixed by >>)
>    mm/tests/vmstat_kunit.c: note: in included file (through include/linux/irqflags.h, include/linux/spinlock.h, include/linux/kref.h, include/kunit/test.h):
> >> arch/arm64/include/asm/percpu.h:261:1: sparse: sparse: cast truncates bits from constant value (ffffffffffffd8f0 becomes f0)

Thanks.  sparse is being a bit silly here.  Using a variable instead of
a constant silences it.


From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm/vmstat_kunit: avoid sparse warning in vm event cleanup
Date: Sun, 22 Nov 2026 18:51:40 -0800

Sparse warns about -TEST_COUNT in an unreachable 1-byte arm64 per-CPU
case; the actual counter is 8 bytes.  Pass the completed loop count
instead to silence the warning, with no behavior change.

Link: https://lore.kernel.org/r/21183f5b-2697-cbe6-6370-dbd27c5e2b60@google.com
Fixes: 7d1a16abe4cc ("mm: vmstat_kunit: add synthetic benchmark for mm stats")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/20261121133112.48w1QOqw-lkp@intel.com/
Cc: Christoph Lameter <cl@gentwo.org>
Cc: David Rientjes <rientjes@google.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Sarthak Sharma <sarthak.sharma@arm.com>

 mm/tests/vmstat_kunit.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/tests/vmstat_kunit.c~mm-vmstat_kunit-add-synthetic-benchmark-for-mm-stats-fix
+++ a/mm/tests/vmstat_kunit.c
@@ -107,7 +107,7 @@ static void vmstat_test_interleaved_zone
 
 /*
  * Test 3: count_vm_event() benchmark.
- * Restores counter balance with count_vm_events(item, -TEST_COUNT).
+ * Restores counter balance after measurement.
  */
 static void vmstat_test_count_vm_event(struct kunit *test)
 {
@@ -124,7 +124,7 @@ static void vmstat_test_count_vm_event(s
 	time2 = get_cycles();
 
 	/* Restore balance */
-	count_vm_events(SLABS_SCANNED, -TEST_COUNT);
+	count_vm_events(SLABS_SCANNED, -(long)i);
 
 	time = time2 - time1;
 	avg_cycles = div_u64(time, TEST_COUNT);
_


