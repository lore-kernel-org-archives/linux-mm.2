Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9AB606A323
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 18:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=NOv0yfLx
Received: by kanga.kvack.org (Postfix)
	id AA8646B05B9; Sat, 14 Nov 2026 13:45:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A58416B05BA; Sat, 14 Nov 2026 13:45:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 920E36B05BB; Sat, 14 Nov 2026 13:45:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6AAD36B05B9
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:45:01 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ED9001A0255
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:45:00 +0000 (UTC)
X-FDA: 85434601560.10.C67BF5A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 25F6D140007
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 18:44:59 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NOv0yfLx;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794681899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3+nwKvgJC1gbMyJT4vyBOO6HuG+8MwwsJLmmSTGtP0=;
	b=xasXOt0RB5QexxMFZNCh7qwH2CuZPwzubWwOU6LoKhW7Kn74LgSl8YNk6CGGj8LEe1nJHQ
	jP8p+PLJkEye0LnoUawKPvAV4nm25Tsv/VkEb/7K3tnH2FFSeg1h3Rcy3345M/y8pLWffe
	vUMr/aR2eMbcb2K0ShJ8P2eFvnS0rlU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794681899;
	b=xzTuCIttoskg2rHbyCpwyRl1RxPZE4c9eX9JFwPMi4Bsn0wAMhacsDsvdOrdvP5Xvy0oK4
	KNw22R4p52ATsZ/Svv0YsSWFCBvuenjOgogY69jz1pnRTy10tthu9tWRfapQArBiKyxNx9
	vLotMapJG1Trxo0YEMWnmbLipd+R7Tg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=NOv0yfLx;
	spf=pass (imf23.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 989E0600CB;
	Sat, 14 Nov 2026 18:44:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E13D81F000C4;
	Sat, 14 Nov 2026 18:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794681898;
	bh=o3+nwKvgJC1gbMyJT4vyBOO6HuG+8MwwsJLmmSTGtP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=NOv0yfLxR99T3ZlPVWmiZ8UVimsrFAJeRIz25yN6bwZnp/bTkMaWxheIOCZ/KhokC
	 WgfnyrfkQYdf/R1kWfl+D/R4NMi2KQJsSQBcoF24yQafJ9r7BvPvD+NQAqdYBrIDEe
	 c0KOWhjsC+r8v8z2t3JvKwiyQjq6UqCHB3B2GzuM=
Date: Sat, 14 Nov 2026 10:44:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: sashiko-reviews@lists.linux.dev
Cc: sashiko-bot@kernel.org, "John J. Coleman" <jocolema@redhat.com>,
 linux-mm@kvack.org, zenghui.yu@linux.dev, david@kernel.org,
 liam@infradead.org, ljs@kernel.org, mhocko@suse.com, peterx@redhat.com,
 rppt@kernel.org, surenb@google.com, vbabka@kernel.org, audra@redhat.com
Subject: Re: [PATCH] selftests/mm: allocate nr_pages based on pmd size for
 uffd pmd_move tests
Message-Id: <20261114104457.6b3247d9abaff0497a9ae545@linux-foundation.org>
In-Reply-To: <sashiko-outbox-214133@kernel.org>
References: <20261113040045.1439391-1-jocolema@redhat.com>
	<sashiko-outbox-214133@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: tdzznoedx1eqmmknp9zhgos8s1btzkwo
X-Spam-Status: No, score=-17.5 required=3.0 tests=BAYES_00,DIET_1,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 25F6D140007
X-Rspam-User: 
X-HE-Tag: 1794681899-267262
X-HE-Meta: U2FsdGVkX1+cd9yaPwUdeaK7bcM7OFrkIugKXUnLVyPK2b585anehARIzQ4hMw7I77zjwIXykr6eYSFXxbrPNeyt0ae0h5Ufw4pl5FE6VWC4XC8rxzKozbEab4lv3Qqo5KY3t5iUDHySy16T4YIv1iEwEv0WeoIIJ3JIgzNneb4LSDmVrCSvf1XlWezZGh7VNido5kaIl6uTlRBSFLJ7ZNtvCKa6FXdj5cLVyQ5LtmQkJ66mEjUWi/pHLnhFmkxglIlJKjkGFzMmAi2jHxJQXLFJCTala9vynT5tMnaHcaVoJydohyx3w+i7NCli6mlN4bGQUJGSFEVVwvdiS+n3I/FafOAnRcSTLtS+uvcV4LGPaO92kGCAvQ6XBaCAGPJ0sSAGwWTnbh2+gq+k7gKNM5OnhGtpb8hlWAO7MctJtoIaEz85e1XMMJR/SGqmrnEjNvoGrb6lq+e84SMVI+XxjuJtqUhot0vG/XR5vszi/MgUuTFM55aLDNTfYVveFjt4mRTyBCXNbsMNEiU775CsF83YavbNxJCL0GTgt07rb3hvvbMNn79uZWcLEamcKcGOwjdKnOpTRRekjq23ApN4fP83SUA4sArVoUlyyFYw/TaOiPBFCFIVIAJM7RuHblDZtajU7MoXACTsVcol/26t3c1fD60qWYVHHYsXv4JbbW2tDxCZ0og9+jRg4R7cuE6TkuoxwebkupSYmqHN0d+b41KBNB6ROLDm+n14Oo384LcQ1jDIveuMgVZMIjsQZMKN6r+/9iDPeu+Rrk8IZ/wjAf4Xke28H8raeSLmRegFzCtQUnXVlNK+Es1KdraYxHWBRcGIqVTSdXWJJbVqsmdhTXhjfJg2ARcwmzWObF0cnY85/EJbpLWniY3jMZjvHuOmLtWCT7tPDMhCVR80L3yiQd0Hs35uy7Pl3NWh64fBQIGD43nUVb0kE75XwrVsU0+Zk96zr8MNaarA7z1/ZeY
 zeVxtzrQ
 NuNYKiEagcu7y3xFJx22IVAdL8YXwtS+X8pROLbyfITrj+jDyvA9TMhV4eZytG7GsY2JZMCAoptdruT5HgHM39aY6YKwrY4q783GqSEUGRLO84l0MBfYvo5Xk5KlGf7HVfqJ1CV7dHKkZlQsh5YXI0yNPW2esFp/jp6FWqmgT7ngE3z35KSEkqH7jpUgNmbuZptxDOaIk2Da2T0pN5+mCsI+/yT1BnyUv1vC+lxWO74ZNE/ocFw9qDb4sScCbCVj117qbKYWv7Q5zu5gVMYVFx1rXlPN4ZdduWtIRVa0PqmKGM9473mOPnmwk4frlTBIq0IUpH93MW2H8SV1C5jmL8Zig1JidBdhKs/v2VmojU6dvhaJcn86Nn2k2/T5dXhgZ0Z/txFL+TiEFitDoiGEMmrZ3tA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, 14 Nov 2026 04:01:42 +0000 sashiko-bot@kernel.org wrote:

> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] selftests/mm: build failure from calling removed
>   read_pmd_pagesize()
> --
> 
> commit baaff8c2bca44f86cbdf0bcae24ee9317be43974
> Author: John J. Coleman <jocolema@redhat.com>
> 
> selftests/mm: allocate nr_pages based on pmd size for uffd pmd_move tests
> 
> This commit adds a pre_alloc callback for the move-pmd uffd unit tests to
> size nr_pages to twice the PMD page size divided by the base page size.
> 
> Link: https://lore.kernel.org/all/20261103202049.499206-1-jocolema@redhat.com
> 
> > diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
> > index 9641f4730a355..9668dccc11599 100644
> > --- a/tools/testing/selftests/mm/uffd-unit-tests.c
> > +++ b/tools/testing/selftests/mm/uffd-unit-tests.c
> > @@ -2484,6 +2484,20 @@ static void uffd_mmap_changing_test(uffd_global_test_opts_t *gopts, uffd_test_ar
> >  	uffd_test_pass();
> >  }
> >  
> > +static int set_pmd_pagesize_nr_pages(uffd_global_test_opts_t *gopts, const char **errmsg)
> > +{
> > +	uint64_t pmd_pagesize = read_pmd_pagesize();
> 
> [Severity: Medium]
> Should this call pmd_psize() instead of read_pmd_pagesize()?  Commit
> 3fe017016527 ("kselftest: mm: rename read_pmd_pagesize() to pmd_psize()")
> renamed this helper, so calling read_pmd_pagesize() breaks the build of
> uffd-unit-tests.

yup, that's the sort of thing which I get to fix.

my reviewbot said:

: The pre_alloc hook fixes the sizing problem. But on 4K-page,
: 2MiB-PMD systems it shrinks each test area from 32 MiB to 4 MiB.
: After alignment, move-pmd usually exercises one PMD-sized move
: instead of about fifteen. Please retain the existing minimum:
: 
: 	gopts->nr_pages = MAX(UFFD_TEST_MEM_SIZE, 2 * pmd_pagesize) /
: 			  gopts->page_size;
: 
: On arm64 with 64K pages, source initialization touches 1 GiB.
: The test also does not verify a huge PMD mapping: MADV_HUGEPAGE is
: advisory, and UFFDIO_MOVE can use its PTE path. That coverage
: limitation predates this patch.

So I came up with the below addition.  John, can you please check it?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: selftests/mm: retain move-pmd coverage and verify huge PMDs
Date: Fri, 13 Nov 2026 20:35:51 -0800

The move-pmd tests need room for a PMD-aligned range. John J.
Coleman's patch [1] provides two PMD spans, but replaces the 32 MiB
default with 4 MiB on 4K-page, 2MiB-PMD systems. With unaligned mmap
addresses, that reduces the test from about fifteen PMD-sized moves
to one. Retain 32 MiB as the minimum.

MADV_HUGEPAGE is advisory. If the source is PTE-mapped, a PMD-sized
UFFDIO_MOVE can succeed through move_pages_ptes() without exercising
the huge-PMD path. Collapse the first aligned source PMD and check its
mapping before either PMD test. Report a skip when a huge PMD cannot
be obtained, rather than reporting a pass for a PTE-only run.

Link: https://lore.kernel.org/r/20261113040045.1439391-1-jocolema@redhat.com [1]
Fixes: a2bf6a9ca805 ("selftests/mm: add UFFDIO_MOVE ioctl test")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
This is a fixup on top of John J. Coleman's patch [1].

My LLM-driven live-kernel runtime testbot said:

Result: PASS. On a two-node x86-64 7.4.0-rc1 guest, all three
move-pmd selftests passed with and without the patch. A kprobe
recorded 3 entries into move_pages_huge_pmd() without the patch
and 17 with it, confirming the additional huge-PMD path coverage.

A targeted allocation failure made MADV_COLLAPSE return ENOMEM;
the patched test skipped as expected, while its no-fault control
passed. An independent UFFDIO_MOVE partial-progress and cleanup
probe passed. No test failure was observed.

 tools/testing/selftests/mm/uffd-unit-tests.c |   25 ++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

--- a/tools/testing/selftests/mm/uffd-unit-tests.c~selftests-mm-retain-move-pmd-coverage-and-verify-huge-pmds
+++ a/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -2124,8 +2124,28 @@ static void uffd_move_test(uffd_global_t
 	uffd_move_test_common(gopts, targs, gopts->page_size, uffd_move_handle_fault);
 }
 
+/*
+ * A PMD-sized UFFDIO_MOVE can also move PTEs. Make sure these tests
+ * start with a huge PMD, rather than passing through the PTE path.
+ */
+static bool uffd_move_pmd_ready(uffd_global_test_opts_t *gopts)
+{
+	unsigned long pmd_size = pmd_psize();
+	char *src = ALIGN_UP(gopts->area_src, pmd_size);
+
+	if (madvise(src, pmd_size, MADV_COLLAPSE) ||
+	    !check_huge_anon(src, pmd_size, 1, pmd_size)) {
+		uffd_test_skip("could not obtain a huge PMD for the source");
+		return false;
+	}
+
+	return true;
+}
+
 static void uffd_move_pmd_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
+	if (!uffd_move_pmd_ready(gopts))
+		return;
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_HUGEPAGE))
 		err("madvise(MADV_HUGEPAGE) failure");
 	uffd_move_test_common(gopts, targs, pmd_psize(),
@@ -2225,6 +2245,8 @@ static void uffd_move_pmd_huge_zeropage_
 
 static void uffd_move_pmd_split_test(uffd_global_test_opts_t *gopts, uffd_test_args_t *targs)
 {
+	if (!uffd_move_pmd_ready(gopts))
+		return;
 	if (madvise(gopts->area_dst, gopts->nr_pages * gopts->page_size, MADV_NOHUGEPAGE))
 		err("madvise(MADV_NOHUGEPAGE) failure");
 	uffd_move_test_common(gopts, targs, pmd_psize(),
@@ -2493,7 +2515,8 @@ static int set_pmd_pagesize_nr_pages(uff
 		return -1;
 	}
 
-	gopts->nr_pages = (2 * pmd_pagesize) / gopts->page_size;
+	gopts->nr_pages = MAX(UFFD_TEST_MEM_SIZE, 2 * pmd_pagesize) /
+			  gopts->page_size;
 
 	return 0;
 }
_


