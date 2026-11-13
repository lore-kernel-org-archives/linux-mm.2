Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E11C3606A323
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 01:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=WhUZApyL
Received: by kanga.kvack.org (Postfix)
	id 7DECE6B0634; Thu, 12 Nov 2026 20:05:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FAA6B0636; Thu, 12 Nov 2026 20:05:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A7666B0637; Thu, 12 Nov 2026 20:05:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B9B26B0634
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 20:05:36 -0500 (EST)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1D7BC1A2567
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:05:34 +0000 (UTC)
X-FDA: 85428302988.29.6CCBB32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 532C380008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:05:32 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WhUZApyL;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794531932;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vG/ZTN7qCBSDmFaKjVjdGqfEtbYGB5lYGnePbBzeUbs=;
	b=bVZFY0c9hstMei1lzcWCV9TDKdzOtPbW5aiHu5RYO1Fuq9CHi37I36iLRc0M578Ie3i0/G
	SXxkLsXdeSpfX0h5xT463h5EPd0XtQg1PXoX1yJNYdW0evY4LgfEfyFh5PhcbzlssXvG/+
	nNpGGXixLpxH/2ODgbhoc8EwKc9RRh0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794531932;
	b=EIyo8NxQfU8DskszmMkKOT3N6elLeJGvHLPuWVy8zOAfsO07asv5VuQwS+1RSUfFqasixE
	+/PCOJDyP/PNSMBxjPOODAQzQubGQkj1SI8Bu43d8F08CdMiz2hk6Bmk4U0Mzc47dnZBhA
	RpTIuURuRhgOpl3d6BNF0BDHDhjwkD0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=WhUZApyL;
	dmarc=none;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 55DEE61133;
	Fri, 13 Nov 2026 01:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BA231F000C4;
	Fri, 13 Nov 2026 01:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794531931;
	bh=vG/ZTN7qCBSDmFaKjVjdGqfEtbYGB5lYGnePbBzeUbs=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WhUZApyLsoF66Xt6K2wtFt7kBRT23e1EZ+HI4j1DZGv3z9ixaHOgEAuOm0nBEJtug
	 dseykBs9T8h3tSk4svyzZ29TNaJtdybxtKIfWc3gmWNHVd2geyRukF8kgGjmXAdR0D
	 ApPXm0rXBIXRoMI+y9144IU/E8XnifHObGlpdGR8=
Date: Thu, 12 Nov 2026 17:05:30 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Matt Salsamendi <matthewsalsamendi@gmail.com>
Cc: "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes
 <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Muhammad Usama Anjum
 <usama.anjum@arm.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] fs/proc/task_mmu: fix stale walk_end after a completed
 scan
Message-Id: <20261112170530.ccddc60994db414a3177a066@linux-foundation.org>
In-Reply-To: <CAMPWk9NE_epOdOCbs1PGh8OQP4wjTObvjU-1Wopmu7SSNAMXhw@mail.gmail.com>
References: <CAMPWk9NE_epOdOCbs1PGh8OQP4wjTObvjU-1Wopmu7SSNAMXhw@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8kinw37zakt5uicpbetfpmptxot4odze
X-Rspam-User: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 532C380008
X-HE-Tag: 1794531932-904795
X-HE-Meta: U2FsdGVkX1/FSWjarGyAh2IDrQrcQ8nmq8gt154VAj3PzjtIwuHJEbP8zpdE1YQ8cQzUW93yi8bjlV4Kl16S7gctiufmB0hEmep2YvTxevlNHCMWdtnV479z9549OmVi8ceKjinprfLzxsw/2cLZIPO9uA19oMFDOoo2M850NAJCc/yRjdGnCFh8SDMRKIirUaMtkY1mknPY4FXzCz5nGapxt3Xe75X1Qzibxw8RxYQDy6NobqFwKq/XTmSwvEFkGXrK4OHzitoj/bWbIO6/uunpPlKXdUj4GMuU/Rj2WjAaBGtxmvnIvx3UQX/Jk/wCBV4L6NdKL7kl8dV4I1whk34waCdJxh3bseArFiHOZmAPcwPvUPvaic+0ZXa22+xVs8THAxoQWd1lPWxQK9MMHk6SVBTFwAU38lRr2siujvtGE7Pn5ExINdVG4TnswDXQhSRMJ9WcF5tyXEQu1o1WKs0HiJvibEDkxq4pcy/1gRsF/oM2pSOMeLqP/KtP4k9RdUhd6p+vECM2nhnoT7CJzjEOsaBQ6MRhjAMWBVqO94Sx6afBKn7x7ryjF0k+glWNTZGHhZGf8pDqrvYARRHX7o6FiGrkH7Ntb1pfDJEAblkG7WOvV1AbAyIlja0sHKQvxW5tnCGQ6xBBiu7PsUBl/zHM1oQGYuUw8fHUQNqVN1ViucB270zxvMOoor381INvKGOYvHXmwdrI8+XDx4c0kALduBjCfuf5sDxOmKxXJRlhzleWafQpTG2B5vBMidsg9s9tIt4CtFaVXQyNZkoDrZg+J8zo2G/jIFvfJ5QtD215wDuZG36JOwE1vyhlKrBxV2fpdLONDwhOQR6/WZbpiWx8F/51i9vqAGg0GwwFKMy6HvlsHsKcsMXxPRP4jZBE2X2d2Kh2rFHO+iAHSC/Lr7Qs3UNdK3ou7a1xuY7aYeQdPpf9mNJsU6cVnXpBwsMq9oUH4X2hAt39JaNPLGd
 dP2eCKFC
 CU29bgsriPQmdT6h8tZYYbwiYio70UHlZ/heOtJVivaYgMV76Koh6n8m5hQ0y3MYn2fJkpz2zh8tFj/UhT3hd/w07krNG2tVJlCSBmVy1zyDXxFUflQ3Gs3e9BQ9yuspxha2/9HcMbj1eHLcSqGrul4Gk4WROhkHTK9S6MHJlRzal/tcZaWtOoPhmPheDYhhRH2JdVBtbh3hnlMWFtNyc7MBib9FPwXuEW8c5x9WZsIsqj3Ddby2K2uOLkbML5w7SYcTzYTDAPW7hlN0ut+0UZnQZyPL22XjYPdBHAluigopLH/LfIdJVjvEM+OF0p6irt3hks4IIs5+syqgVV5EpV2MKw3VqxqW/v1OCjnQcWq0SnY+efMXjG5RZ+Xfe0WgFXgImfnVIVYxlKdOpoCF0B2qPFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 12 Nov 2026 12:41:02 -0500 Matt Salsamendi <matthewsalsamendi@gmail.com> wrote:

> From: Matthew Salsamendi <matthewsalsamendi@gmail.com>
> 
> After PAGEMAP_SCAN fills its internal buffer, a successful final walk can
> leave walk_end at the earlier stopping point. On x86-64, 513 disjoint
> written pages return 513 ranges with the last range beyond walk_end.
> This trips a bounds assertion in a userspace dirty-page tracker.
> 
> Update walk_end on successful completion before replacing ret with the
> range count. Preserve the stopping address for partial scans.

Bug seems real, thanks.

> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and
> optionally clear info about PTEs")
> Cc: stable@vger.kernel.org

This should be justified, please.  Hopefully full and clear
justification for backports will soon be required.

https://lore.kernel.org/20261111171055.527b4bf3da705367bc78a64c@linux-foundation.org

and followups explain this.

> Validated on x86-64 v7.4-rc2 in KVM: all 12 scan cases and all 119
> pagemap_ioctl selftests pass. The unpatched kernel reproduces the bug.

Thing is, those 119 test already pass.  And the mysterious 12 scan
cases are undisclosed.

So.

Please prepare a selftests patch to catch this bug [1] then confirm
that the altered selftests fail before the proposed patch and pass after
it.  Then present both as a two-patch series.

Thanks.


[1] my thing suggested the below.  I haven't run it.


--- a/tools/testing/selftests/mm/pagemap_ioctl.c~selftests-mm-pagemap_ioctl-check-walk_end-after-buffer-refill
+++ a/tools/testing/selftests/mm/pagemap_ioctl.c
@@ -1476,6 +1476,51 @@ static void *thread_proc(void *mem)
 		if (getrusage(RUSAGE_THREAD, &r))
 			ksft_exit_fail_msg("getrusage\n");
 
+static void test_walk_end_after_refill(void)
+{
+	const int nr_ranges = 513;
+	const int nr_pages = nr_ranges * 2;
+	const int len = nr_pages * page_size;
+	struct page_region *vec;
+	char *mem;
+	long walk_end = 0;
+	long ret;
+	int i;
+	bool ok;
+
+	mem = mmap(NULL, len, PROT_READ | PROT_WRITE,
+		   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (mem == MAP_FAILED)
+		ksft_exit_fail_msg("mmap failed: %s\n", strerror(errno));
+	if (madvise(mem, len, MADV_NOHUGEPAGE))
+		ksft_exit_fail_msg("MADV_NOHUGEPAGE failed: %s\n", strerror(errno));
+	vec = calloc(nr_ranges, sizeof(*vec));
+	if (!vec)
+		ksft_exit_fail_msg("calloc failed\n");
+
+	wp_init(mem, len);
+	wp_addr_range(mem, len);
+	for (i = 0; i < nr_ranges; i++)
+		mem[2 * i * page_size] = 1;
+
+	ret = pagemap_ioc(mem, len, vec, nr_ranges, 0, 0,
+			  PAGE_IS_WRITTEN, 0, 0, PAGE_IS_WRITTEN, &walk_end);
+	ok = ret == nr_ranges && walk_end == (long)(mem + len);
+	if (ret == nr_ranges) {
+		for (i = 0; i < nr_ranges; i++) {
+			if (vec[i].start != (uintptr_t)(mem + 2 * i * page_size) ||
+			    vec[i].end != (uintptr_t)(mem + (2 * i + 1) * page_size)) {
+				ok = false;
+				break;
+			}
+		}
+	}
+	ksft_test_result(ok, "PAGEMAP_SCAN walk_end after bounce buffer refill\n");
+	wp_free(mem, len);
+	munmap(mem, len);
+	free(vec);
+}
+
 		faults = r.ru_minflt - curr_faults;
 		if (faults < access_per_thread)
 			ksft_exit_fail_msg("faults < access_per_thread");
@@ -1661,12 +1706,14 @@ int main(int __attribute__((unused)) arg
 	if (!hugetlb_setup_default(4))
 		ksft_print_msg("HugeTLB test will be skipped\n");
 
-	ksft_set_plan(119);
+	ksft_set_plan(120);
 
 	pagemap_fd = open(PAGEMAP, O_RDONLY);
 	if (pagemap_fd < 0)
 		ksft_exit_fail_msg("Failed to open " PAGEMAP "\n");
 
+	test_walk_end_after_refill();
+
 	/* 1. Sanity testing */
 	sanity_tests_sd();
 
_


